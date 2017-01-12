local backend = require "tacky.backend.init"
local logger = require "tacky.logger"
local resolve = require "tacky.analysis.resolve"
local State = require "tacky.analysis.state"
local writer = require "tacky.backend.writer"

return function(parsed, global, env, inStates, scope, loader)

	local queue = {}
	local out = {}
	local states = {}

	for i = 1, #parsed do
		local state = State.create(env, inStates, scope)
		states[i] = state
		queue[i] = {
			tag  = "init",
			node =  parsed[i],

			-- Global state for every action
			_idx   = i,
			_co    = coroutine.create(resolve.resolveNode),
			_state = state,
			_node  = parsed[i],
		}
	end

	local iterations = 0
	local function resume(action, ...)
		-- Reset the iteration count as something successful happened
		iterations = 0
		local status, result = coroutine.resume(action._co, ...)

		if not status then
			error(result .. "\n" .. debug.traceback(action._co), 0)
		elseif coroutine.status(action._co) == "dead" then
			logger.printDebug("  Finished: " .. #queue .. " remaining")
			-- We have successfully built the node.
			action._state:built(result)
			out[action._idx] = result
		else
			-- Store the state and coroutine data and requeue for later
			result._idx   = action._idx
			result._co    = action._co
			result._state = action._state
			result._node  = action._node

			-- And requeue node
			queue[#queue + 1] = result
		end
	end

	while #queue > 0 and iterations <= #queue do
		local head = table.remove(queue, 1)

		logger.printDebug(head.tag .. " for " .. head._state.stage .. " at " .. logger.formatNode(head._node) .. " (" .. (head._state.var and head._state.var.name or "?") .. ")")

		if head.tag == "init" then
			-- Start the parser with the initial data
			resume(head, head.node, scope, head._state)
		elseif head.tag == "define" then
			-- We're waiting for a variable to be defined.
			-- If it exists then resume, otherwise requeue.

			if scope.variables[head.name] then
				resume(head, scope.variables[head.name])
			else
				logger.printDebug("  Awaiting definition of " .. head.name)

				-- Increment the fact that we've done nothing
				iterations = iterations + 1
				queue[#queue + 1] = head
			end
		elseif head.tag == "build" then
			if head.state.stage ~= "parsed" then
				resume(head)
			else
				logger.printDebug("  Awaiting building of node (" .. (head.state.var and head.state.var.name or "?") .. ")")

				-- Increment the fact that we've done nothing
				iterations = iterations + 1

				queue[#queue + 1] = head
			end
		elseif head.tag == "execute" then
			local states = head.states

			local stateList, nameTable, nameList, escapeList = {}, {}, {}, {}

			for j = 1, #states do
				local state = states[j]
				if state.stage ~= "executed" then
					local node = assert(state.node, "State is in " .. state.stage .. " instead")
					local var = assert(state.var, "State has no variable")

					local escaped, name = backend.lua.backend.escapeVar(var), var.name

					local i = #stateList + 1

					stateList[i] = state
					nameTable[i] = escaped .. " = " .. escaped
					nameList[i] = name
					escapeList[i] = escaped
				end
			end

			if #stateList > 0 then
				local builder = writer()

				builder.add("local " .. table.concat(escapeList, ", "))
				builder.line()

				for i = 1, #stateList do
					backend.lua.backend.expression(stateList[i].node, builder, "")
					builder.line()
				end

				builder.add("return {" .. table.concat(nameTable, ", ") .. "}")

				local str = builder.toString()
				local fun, msg = load(str, "=compile{" .. table.concat(nameList, ",") .. "}", "t", global)
				if not fun then error(msg .. ":\n" .. str, 0) end

				local success, result = xpcall(fun, debug.traceback)
				if not success then error(result .. ":\n" .. str, 0) end

				for i = 1, #stateList do
					local state = stateList[i]
					local escaped = escapeList[i]
					local res = result[escaped]
					state:executed(res)
					global[escaped] = res
				end
			end

			resume(head)
		elseif head.tag == "import" then
			local success, module = loader(head.module)

			if not success then
				logger.errorPositions(head._node, module)
			end

			for _, state in pairs(module) do
				if state.var then
					if head.as then
						scope:import(head.as, state.var, state, head._node)
					elseif head.symbols then
						if head.symbols[state.var.name] then
							scope:import(nil, state.var, state, head._node)
						end
					else
						scope:import(nil, state.var, state, head._node)
					end
				end
			end
			resume(head)
		else
			error("Unknown tag " .. head.tag)
		end
	end

	if #queue ~= 0 then
		for i = 1, #queue do
			local entry = queue[i]

			if entry.tag == "define" then
				logger.printError("Cannot find variable " .. entry.name)

				if entry.node then
					logger.putTrace(entry.node)

					local source = logger.getSource(entry.node)
					if source then logger.putLines(true, source, "") end
				end
			elseif entry.tag == "build" then
				logger.printError("Could not build " .. entry.state.var.name)
			else
				error("State should not be " .. entry.tag)
			end
		end

		error("Compilation could not continue")
	end

	return out, states
end
