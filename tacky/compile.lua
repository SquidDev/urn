local lazymeta = {
	__index = function(self, key)
		setmetatable(self, nil)
		local data = require(self.__name)
		for k, v in pairs(data) do self[k] = v end
		return data[key]
	end
}
local function lazyrequire(name)
	return setmetatable({ __name = name }, lazymeta)
end

local Scope = lazyrequire "tacky.resolve.scope"
local State = lazyrequire "tacky.resolve.state"
local logger = lazyrequire "tacky.logger.init"
local range = lazyrequire "tacky.range"
local resolve = require "tacky.analysis.resolve"
local traceback = lazyrequire "tacky.traceback"

local load = load
if _VERSION:find("5.1") then
	load = function(x, n, _, env)
		local f, e = loadstring(x, n)
		if not f then error(e, 2) end
		if env then setfenv(f, env) end
		return f
	end
end

--- Compute a varience on the levenshtein distance
-- @param string a The target string
-- @param string b The source string
-- @return The computed distance
local function distance(a, b)
	-- Some initial checks
	if a == b then return 0 end
	if #a == 0 then return #b end
	if #b == 0 then return #a end

	local v0, v1 = {}, {}

	-- Setup v0, where A[1][i] is the edit distance for an empty a.
	for i = 1, #b + 1 do v0[i] = i - 1 end

	for i = 1, #a do
		-- Calculate current row distance from previous v0

		-- Edit distance is to delete i characters from a to match t.
		v1[1] = i

		for j = 1, #b do
			local subCost, delCost, addCost = 1, 1, 1
			if a:sub(i, i) == b:sub(j, j) then subCost = 0 end

			-- We make "-" and "/" half as expensive, as they are divider characters.
			if a:sub(i, i) == '-' or a:sub(i, i) == "/" then delCost = 0.5 end
			if b:sub(j, j) == '-' or b:sub(j, j) == "/" then addCost = 0.5 end

			-- If either string is less than 5 characters long, then make deletions and substitions
			-- more expensive. For such short strings, it is awfully easy for a string to be entirely
			-- deleted and replaced again.
			if #a <= 5 or #b <= 5 then
				subCost = subCost * 2
				delCost = delCost + 0.5
			end

			v1[j + 1] = math.min(
				v1[j] + delCost,     -- Deletion
				v0[j + 1] + addCost, -- Insertion
				v0[j] + subCost      -- Substitution
			)
		end

		for j = 1, #v0 do v0[j] = v1[j] end
	end

	return v1[#b + 1]
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
-- @param scope        The scope to load variables in.
-- @param compileState The current compiler state, holding library metadata and variable escape mappings.
-- @param loader       The function to invoke in order to load an external module.
-- @param loggerI      The logger which should receive error messages.
-- @param executeStates The function to invoke to compile a series of states
-- @param timer        An optional timer used to time how long this'll take.
-- @return Returns the resolved nodes and the corresponding states.
local function compile(compiler, executeStates, parsed, scope, name)
	local queue = {}
	local states = { scope = scope }

	local global = compiler.global
	local compileState = compiler.compileState
	local loader = compiler.loader
	local loggerI = compiler.log
	local timer = compiler.timer

	if name then name = "[resolve] " .. name end
	local hook, hookMask, hookCount = debug.gethook()

	for i = 1, #parsed do
		local state = State.create(scope, compiler)
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

		-- Restore the compiler scope/node
		compiler['active-scope'] = action._activeScope
		compiler['active-node'] = action._activeNode

		local status, result = coroutine.resume(action._co, ...)

		if not status then
			error(result .. "\n" .. debug.traceback(action._co), 0)
		elseif coroutine.status(action._co) == "dead" then
			logger.putDebug(loggerI, "  Finished: " .. #queue .. " remaining")

			-- We've successfully built the node, so we handle unpacking it.
			if result.tag ~= "many" then
				State.built(action._state, result)
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
					local state = State.create(scope, compiler)
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
						_node  = result[i],
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

			-- Store the compiler scope/node, so we can restore it later
			result._activeScope = compiler['active-scope']
			result._activeNode = compiler['active-node']

			-- And requeue node
			queue[#queue + 1] = result
		end

		-- We clear this so things executeStates cannot access it. The plugin ensures this is
		-- not nil when yielding.
		compiler['active-scope'] = nil
		compiler['active-node'] = nil
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

				local info, suggestions = nil, ""
				if entry.scope then
					local vars, varDis, varSet = {tag="list"}, {}, {}
					local distances = {}

					local scope = entry.scope
					while scope do
						for k in pairs(scope.variables) do
							if not varSet[k] then
								varSet[k] = true
								vars[#vars + 1] = k

								local parlen = #entry.name
								local lenDiff = math.abs(#k - parlen)

								-- If there is a significant length difference, and the string isn't really short
								-- then let's not use the variable guesser.
								if parlen <= 5 or lenDiff <= parlen * 0.3 then
									local dis = distance(k, entry.name) / parlen

									-- For short strings, let's be slightly more flexible with normalising.
									if parlen <= 5 then dis = dis / 2 end

									varDis[#varDis + 1] = k
									distances[k] = dis
								end
							end
						end

						scope = scope.parent
					end

					vars.n = #vars
					table.sort(vars)

					table.sort(varDis, function(a, b) return distances[a] < distances[b] end)
					local lastIdx = 0
					for i = 1, 5 do
						if distances[varDis[i]] > 0.5 then
							break
						end
						lastIdx = i

						varDis[i] = logger.colored("1;32", varDis[i])
					end

					if lastIdx == 1 then
						suggestions = "\nDid you mean '" .. varDis[i] .. "'?"
					elseif lastIdx > 0 then
						local indent = "\n  \xE2\x80\xA2 "
						suggestions = "\nDid you mean any of these?" .. indent .. table.concat(varDis, indent, 1, lastIdx)
					end

					info = "Variables in scope are " .. table.concat(vars, ", ")
				end

				local node = entry.node or entry._node

				logger.doNodeError(loggerI,
					"Cannot find variable '" .. entry.name .. "'" .. suggestions,
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
