local Scope = require "tacky.analysis.scope"
local State = require "tacky.analysis.state"
local backend = require "tacky.backend.init"
local logger = require "tacky.logger.init"
local range = require "tacky.range"
local resolve = require "tacky.analysis.resolve"
local traceback = require "tacky.traceback"

local writer = backend.writer

--- Attempt to execute a series of states, in the environment.
--
-- All nodes are required to be in the built or executed stages, though those in the latter will be skipped
-- for obvious reasons.
--
-- @param compileState The state of the current compiler, including escape mappings and library metadata
-- @param states The list of states to compile
-- @param global The environment to execute under. States with variables will be bound to these.
-- @param loggerI The logger to print all compilation issues too.
local function executeStates(compileState, states, global, loggerI)
	local stateList, nameTable, nameList, escapeList = {}, {}, {}, {}

	for j = #states, 1, -1 do
		local state = states[j]
		if state.stage ~= "executed" then
			local node = assert(state.node, "State is in " .. state.stage .. " instead")
			local var = state.var or { name = "temp" }

			local i = #stateList + 1

			local escaped, name = backend.lua.backend.escapeVar(var, compileState), var.name

			stateList[i] = state
			nameTable[i] = escaped .. " = " .. escaped
			nameList[i] = name
			escapeList[i] = escaped
		end
	end

	if #stateList > 0 then
		local builder = writer.create()
		backend.lua.backend.prelude(builder)
		writer.line(builder, "local " .. table.concat(escapeList, ", "))

		for i = 1, #stateList do
			local state = stateList[i]

			-- If we don't have a variable then we'll assign it to this temporary variable we created earlier.
			local suffix
			if state.var then
				suffix = ""
			else
				suffix = escapeList[i] .. " = "
			end

			backend.lua.backend.expression(state.node, builder, compileState, suffix)
			writer.line(builder)
		end

		writer.line(builder, "return {" .. table.concat(nameTable, ", ") .. "}")

		local id = compileState.count
		compileState.count = id + 1

		local names = table.concat(nameList, ",")
		if #names > 20 then names = names:sub(1, 17) .. "..." end
		local name = "compile#" .. id .. "{" .. names .. "}"

		local str = writer.tostring(builder)
		compileState.mappings[name] = traceback.generate(builder.lines)

		local fun, msg = load(str, "=" .. name, "t", global)
		if not fun then error(msg .. ":\n" .. str, 0) end

		local success, result = xpcall(fun, debug.traceback)
		if not success then
			logger.putDebug(loggerI, str)
			error(traceback.remapTraceback(compileState.mappings, result), 0)
		end

		for i = 1, #stateList do
			local state = stateList[i]
			local escaped = escapeList[i]
			local res = result[escaped]
			state:executed(res)

			if state.var then global[escaped] = res end
		end
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
-- @return Returns the resolved nodes and the corresponding states.
local function compile(parsed, global, env, inStates, scope, compileState, loader, loggerI)
	local queue = {}
	local out = {}
	local states = { scope = scope }

	for i = 1, #parsed do
		local state = State.create(env, inStates, scope, loggerI, compileState.mappings)
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
			logger.putDebug(loggerI, "  Finished: " .. #queue .. " remaining")
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

		logger.putDebug(loggerI, head.tag .. " for " .. head._state.stage .. " at " .. range.formatNode(head._node) .. " (" .. (head._state.var and head._state.var.name or "?") .. ")")

		if head.tag == "init" then
			-- Start the parser with the initial data
			resume(head, head.node, scope, head._state, true)
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
			local result = loader(head.module)
			local module = result[1]

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

	out.tag = "list" out.n = #out
	states.tag = "list" states.n = #states

	return out, states
end

return {
	compile = compile,
	executeStates = executeStates,
}
