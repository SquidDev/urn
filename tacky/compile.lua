local Scope = require "tacky.analysis.scope"
local State = require "tacky.analysis.state"
local logger = require "tacky.logger.init"
local range = require "tacky.range"
local resolve = require "tacky.analysis.resolve"
local traceback = require "tacky.traceback"

local load = load
if _VERSION:find("5.1") then
	load = function(x, n, _, env)
		local f, e = loadstring(x, n)
		if not f then error(e, 2) end
		if env then setfenv(f, env) end
		return f
	end
end

--- Attempt to resolve all variables in a list of expressions, expanding all macros and what not.
--
-- This firstly creates a State for each expression in the list. This tracks all variables this state
-- references, along with the variable it defines, the fully built node, and (if required) the compiled value.
--
-- These states are inserted into a task list and resolution starts. Actual variable resolution is only done
-- in the resolver, yielding out if a variable cannot be found or in a couple of other cases. Each entry in
-- this task list goes through a series of stages:
--
--  - init: The initial state before anything has happened.
--  - define: Waiting for a variable to be defined.
--  - build: Waiting for another node to finish being resolved. This is required before we actually compile a
--  - node as we need to gather all its dependencies.
--  - execute: Waiting for a state to execute. This is generally entered when the state's node needs to
--    execute a macro which hasn't been compiled to Lua yet.
--  - import: When we need to load and import and external module.
--
-- Once each task's dependencies have been resolved then resolution of that node will continue.
--
-- This rather convoluted algorithm does mean that statements may not resolve or execute in order, leading to
-- issues where a top level definition shadows an imported one, as the imported one may be used
-- instead. Whilst the algorithm is, strictly speaking, deterministic, it isn't clear when nodes will be
-- executed.
--
-- A future improvement of this would be to execute as much as possible of one node before continuing, though
-- this places a much stricter requirement on definition order.
--
-- @param parsed       The parsed syntax tree to resolve
-- @param global       The global environment all code is executed in.
-- @param env          A lookup of variable hashes to variables. This is used in order to link syntax-quoted
--                     variables back to their original definition.
-- @param inStates     A lookup of all currently loaded variables mapped to their corresponding State object.
-- @param scope        The scope to load variables in.
-- @param compileState The current compiler state, holding library metadata and variable escape mappings.
-- @param loader       The function to invoke in order to load an external module.
-- @param loggerI      The logger which should receive error messages.
-- @param executeStates The function to invoke to compile a series of states
-- @param timer        An optional timer used to time how long this'll take.
-- @return Returns the resolved nodes and the corresponding states.
local function compile(parsed, global, env, inStates, scope, compileState, loader, loggerI, executeStates, timer, name)
	local queue = {}
	local states = { scope = scope }

	if name then name = "[resolve] " .. name end
	local hook, hookMask, hookCount = debug.gethook()

	for i = 1, #parsed do
		local state = State.create(env, inStates, scope, loggerI, compileState.mappings)
		states[i] = state
		local co = coroutine.create(resolve.resolve)
		debug.sethook(co, hook, hookMask, hookCount)
		queue[i] = {
			tag  = "init",
			node =  parsed[i],

			-- Global state for every action
			_co    = co,
			_state = state,
			_node  = parsed[i],
			_idx   = i,
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
			logger.putDebug(loggerI, "  Finished: " .. #queue .. " remaining")

			-- We've successfully built the node, so we handle unpacking it.
			if result.tag ~= "many" then
				action._state:built(result)
			else
				logger.putDebug(loggerI, "  Got multiple nodes as a result. Adding to queue")
				--- Adjust the node offset so everything is correctly set.
				local baseIdx = action._idx
				for i = 1, #queue do
					local elem = queue[i]
					if elem._idx > baseIdx then
						elem._idx = elem._idx + result.n - 1
					end
				end

				for i = 1, result.n do
					local state = State.create(env, inStates, scope, loggerI, compileState.mappings)
					if i == 1 then
						states[baseIdx] = state
					else
						table.insert(states, baseIdx + i - 1, state)
					end

					local co = coroutine.create(resolve.resolve)
					debug.sethook(co, hook, hookMask, hookCount)
					queue[#queue + 1] = {
						tag  = "init",
						node = result[i],
						-- Global state for every action
						_co    = co,
						_state = state,
						_node  = parsed[i],
						_idx   = baseIdx + i - 1,
					}
				end
			end
		else
			-- Store the state and coroutine data and requeue for later
			result._co    = action._co
			result._state = action._state
			result._node  = action._node
			result._idx   = action._idx

			-- And requeue node
			queue[#queue + 1] = result
		end
	end

	if name and timer then logger.startTimer(timer, name, 2) end

	while #queue > 0 and iterations <= #queue do
		local head = table.remove(queue, 1)

		logger.putDebug(loggerI, head.tag .. " for " .. head._state.stage .. " at " .. range.formatNode(head._node) .. " (" .. (head._state.var and head._state.var.name or "?") .. ")")

		if head.tag == "init" then
			-- Start the parser with the initial data
			resume(head, head.node, scope, head._state)
		elseif head.tag == "define" then
			-- We're waiting for a variable to be defined.
			-- If it exists then resume, otherwise requeue.

			if scope.variables[head.name] then
				resume(head, scope.variables[head.name])
			else
				logger.putDebug(loggerI, "  Awaiting definition of " .. head.name)

				-- Increment the fact that we've done nothing
				iterations = iterations + 1
				queue[#queue + 1] = head
			end
		elseif head.tag == "build" then
			if head.state.stage ~= "parsed" then
				resume(head)
			else
				logger.putDebug(loggerI, "  Awaiting building of node (" .. (head.state.var and head.state.var.name or "?") .. ")")

				-- Increment the fact that we've done nothing
				iterations = iterations + 1

				queue[#queue + 1] = head
			end
		elseif head.tag == "execute" then
			executeStates(compileState, head.states, global, loggerI)
			resume(head)
		elseif head.tag == "import" then
			if name and timer then logger.pauseTimer(timer, name) end

			local result = loader(head.module)
			local module = result[1]

			if name and timer then logger.startTimer(timer, name) end

			if not module then
				logger.doNodeError(loggerI,
					result[2],
					head._node, nil,
					range.getSource(head._node), ""
				)
			end

			local export = head.export
			local scope = head.scope
			for name, var in pairs(module.scope.exported) do
				if head.as then
					name = head.as .. '/' .. name
					Scope.importVerbose(scope, name, var, head._node, export, loggerI)
				elseif head.symbols then
					if head.symbols[name] then
						Scope.importVerbose(scope, name, var, head._node, export, loggerI)
					end
				else
					Scope.importVerbose(scope, name, var, head._node, export, loggerI)
				end
			end

			if head.symbols then
				local failure = false
				for name, nameNode in pairs(head.symbols) do
					if not module.scope.exported[name] then
						logger.putNodeError(loggerI,
							"Cannot find " .. name,
							nameNode, nil,
							range.getSource(head._node), "Importing here",
							range.getSource(nameNode), "Required here"
						)
						failure = true
					end
				end

				if failure then error("An error occured", 0) end
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

				local info
				if entry.scope then
					local vars, varSet = {tag="list"}, {}

					local scope = entry.scope
					while scope do
						for k in pairs(scope.variables) do
							if not varSet[k] then
								varSet[k] = true
								vars[#vars + 1] = k
							end
						end

						scope = scope.parent
					end

					vars.n = #vars
					table.sort(vars)

					info = "Variables in scope are " .. table.concat(vars, ", ")
				end

				local node = entry.node or entry._node

				logger.doNodeError(loggerI,
					"Cannot find variable " .. entry.name,
					node, info,
					range.getSource(node), ""
				)
			elseif entry.tag == "build" then
				local var, node = entry.state.var, entry.state.node
				local name
				if var then
					name = var.name
				elseif node then
					name = range.formatNode(node)
				else
					name = "unknown node"
				end
				logger.putError(loggerI, "Could not build " .. name)
			else
				error("State should not be " .. entry.tag)
			end
		end

		error("Compilation could not continue")
	end

	if name and timer then logger.stopTimer(timer, name) end

	states.tag = "list" states.n = #states

	local out = { tag = "list", n = states.n }
	for i = 1, states.n do out[i] = states[i].node end

	return out, states
end

return {
	compile = compile,
}
