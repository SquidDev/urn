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
local traceback = lazyrequire "tacky.traceback"
local Builtins = lazyrequire "tacky.resolve.builtins"

local function errorPositions(log, node, message)
	logger.doNodeError(log,
		message, node, nil,
		range.getSource(node), ""
	)
end

local function expectType(log, node, parent, type, name)
	if not node or node.tag ~= type then
		errorPositions(log, node or parent, "Expected " .. (name or type) .. ", got " .. (node and node.tag or "nothing"))
	end
end

local function expect(log, node, parent, name)
	if not node then
		errorPositions(log, parent, "Expected " .. name .. ", got nothing")
	end
end

local function maxLength(log, node, len, name)
	if node.n > len then
		local last = node[len + 1]
		errorPositions(log, last, "Unexpected node in '" .. name .. "' (expected " .. len .. " values, got " .. node.n .. ")")
	end
end

local function internalError(log, node, message)
	errorPositions(log, node, "[Internal]" .. message .. "\n" .. debug.traceback())
end

local function packPcall(success, ...)
	if success then
		return true, table.pack(...)
	else
		return false, ...
	end
end

--- Reads metadata from the specified node, annotating the variable
-- @param log    The logger to print error messages to
-- @param node   The node we're reading from.
-- @param var    The variable this node defines, on which metadata should be stored.
-- @param start  The start offset of the node.
-- @param finish The finish offset of the node.
local function handleMetadata(log, node, var, start, finish)
	local i = start
	while i <= finish do
		local child = node[i]
		if not child then
			expect(log, child, node, "variable metadata")
		elseif child.tag == "string" then
			if var.doc then
				errorPositions(log, child, "Multiple doc strings in definition")
			else
				var.doc = child.value
			end
		elseif child.tag == "key" then
			if child.value == "hidden" then
				-- Prevent exporting this symbol
				var.scope.exported[var.name] = nil
			elseif child.value == "deprecated" then
				local message = true
				if i < finish and node[i + 1] and node[i + 1].tag == "string" then
					message = node[i + 1].value
					i = i + 1
				end
				var.deprecated = message
			else
				errorPositions(log, child, "Unexpected modifier '" .. child.value .. "'")
			end
		else
			errorPositions(log, child, "Unexpected node of type " .. child.tag .. ", have you got too many values?")
		end

		i = i + 1
	end
end

--- Resolve the result of a macro or unquote, binding the parent node and marking which macro which generated it.
--
-- Also correctly will re-associate syntax-quoted variables with their original definition
--
-- @param owner   The State of this node's creator.
-- @param node    The resulting node.
-- @param parent  The parent to this node.
-- @param scope   The scope we're resolving in.
-- @param state   The state for this node block.
-- @return The fully resolved result, reading for actual resolution.
local function resolveExecuteResult(owner, node, parent, scope, state)
	local ty = type(node)
	if ty == "string" then
		node = { tag = "string", contents = ("%q"):format(node), value = node }
	elseif ty == "number" then
		node = { tag = "number", contents = tostring(node), value = node }
	elseif ty == "boolean" then
		node = { tag = "symbol", contents = tostring(node), value = node, var = declaredVars[tostring(node)] }
	elseif ty == "table" then
		local tag = node.tag
		if tag == "symbol" or tag == "string" or tag == "number" or tag == "key" or tag == "list" then
			-- Shallow copy the node: we'll deep copy the important things later
			-- We have to do this as entries may appear multiple times in this expansion
			-- or other expansions.
			local newNode = {}
			for k, v in pairs(node) do newNode[k] = v end
			node = newNode
		else
			if tag then ty = tostring(tag) end
			errorPositions(state.logger, parent, "Invalid node of type '" .. ty .. "' from " .. State.name(owner))
		end
	else
		errorPositions(state.logger, parent, "Invalid node of type '" .. ty .. "' from " .. State.name(owner))
	end


	-- We've already tagged this so continue
	if not node.range and not node.owner then
		node.owner = owner
		node.parent = parent
	end

	if node.tag == "list" then
		for i = 1, node.n do
			node[i] = resolveExecuteResult(owner, node[i], node, scope, state)
		end
	elseif node.tag == "symbol" and type(node.var) == "string" then
		local var = state.compiler.variables[node.var]
		if not var then
			errorPositions(state.logger, node, "Invalid variable key '" .. node.var .. "' for '" .. node.contents .. "'")
		else
			node.var = var
		end
	end

	return node
end

local resolveNode, resolveBlock, resolveQuote

--- Resolve a syntax-quoted expression
-- @param node The node to resolve
-- @param scope The scope to resolve under.
-- @param state The state to resolve under.
-- @param level The level of quoting. 0 represents none, 1 represents one level of syntax-quote.
-- @return The fully resolved quoted expression.
function resolveQuote(node, scope, state, level)
	if level == 0 then
		return resolveNode(node, scope, state)
	end

	if node.tag == "string" or node.tag == "number" or node.tag == "key" then
		return node
	elseif node.tag == "symbol" then
		if not node.var then
			node.var = Scope.getAlways(scope, node.contents, node)

			if not node.var.scope.isRoot and not node.var.scope.builtin then
				errorPositions(state.logger, node, "Cannot use non-top level definition in syntax-quote")
			end
		end
		return node
	elseif node.tag == "list" then
		local first = node[1]
		if first and first.tag == "symbol" then
			if not first.var then
				first.var = Scope.getAlways(scope, first.contents, first)
			end

			local builtins = Builtins.builtins
			if first.var == builtins["unquote"] or first.var == builtins["unquote-splice"] then
				node[2] = resolveQuote(node[2], scope, state, level - 1)
				return node
			elseif first.var == builtins["syntax-quote"] then
				node[2] = resolveQuote(node[2], scope, state, level + 1)
				return node
			end
		end

		for i = 1, #node do
			node[i] = resolveQuote(node[i], scope, state, level)
		end

		return node
	else
		internalError(state.logger, expr, "Unknown tag " .. expr.tag)
	end
end

function resolveNode(node, scope, state, root, many)
	local kind = node.tag
	local log = state.logger
	if kind == "number" or kind == "boolean" or kind == "string" or node.tag == "key" then
		-- Do nothing: this is a constant term after all
		return node
	elseif kind == "symbol" then
		if not node.var then
			node.var = Scope.getAlways(scope, node.contents, node)
		end
		if node.var.tag == "builtin" then
			errorPositions(log, node, "Cannot have a raw builtin")
		end
		State.require(state, node.var, node)
		return node
	elseif kind == "list" then
		local first = node[1]
		if not first then
			errorPositions(log, node, "Cannot invoke a non-function type 'nil'")
		elseif first.tag == "symbol" then
			if not first.var then
				first.var = Scope.getAlways(scope, first.contents, first)
			end

			local func = first.var
			local funcState = State.require(state, func, first)
			local builtins = Builtins.builtins

			if func == builtins["lambda"] then
				expectType(log, node[2], node, "list", "argument list")

				local childScope = Scope.child(scope)

				local args = node[2]

				local hasVariadic
				for i = 1, #args do
					expectType(log, args[i], args, "symbol", "argument")
					local name = args[i].contents

					-- Strip "&" for variadic arguments.
					local isVar = name:sub(1, 1) == "&"
					if isVar then
						if hasVariadic then
							errorPositions(log, args[i], "Cannot have multiple variadic arguments")
						elseif #name == 1 then
							local possible = ""
							if i < #args then
								local nextArg = args[i + 1]
								if type(nextArg) == "table" and nextArg.tag == "symbol" and nextArg.contents:sub(1, 1) ~= "&" then
									possible = "\nDid you mean '&" .. nextArg.contents .. "'?"
								end
							end
							errorPositions(log, args[i], "Expected a symbol for variadic argument." .. possible)
						else
							name = name:sub(2)
							hasVariadic = true
						end
					end

					args[i].var = Scope.addVerbose(childScope, name, "arg", args[i], log)
					args[i].var.isVariadic = isVar
				end

				resolveBlock(node, 3, childScope, state)
				return node
			elseif func == builtins["cond"] then
				for i = 2, #node do
					local case = node[i]
					expectType(log, case, node, "list", "case expression")
					expect(log, case[1], case, "condition")

					case[1] = resolveNode(case[1], scope, state)

					local childScope = Scope.child(scope)
					resolveBlock(case, 2, childScope, state)
				end

				return node
			elseif func == builtins["set!"] then
				expectType(log, node[2], node, "symbol")
				expect(log, node[3], node, "value")
				maxLength(log, node, 3, "set!")

				local var = Scope.getAlways(scope, node[2].contents, node[2])
				State.require(state, var, node[2])
				node[2].var = var
				if var.const then
					errorPositions(log, node, "Cannot rebind constant " .. var.name)
				end

				node[3] = resolveNode(node[3], scope, state)
				return node
			elseif func == builtins["quote"] then
				expect(log, node[2], node, "value")
				maxLength(log, node, 2, "quote")
				return node
			elseif func == builtins["syntax-quote"] then
				expect(log, node[2], node, "value")
				maxLength(log, node, 2, "syntax-quote")

				node[2] = resolveQuote(node[2], scope, state, 1)
				return node
			elseif func == builtins["unquote"] then
				expect(log, node[2], node, "value")

				local res = { tag = "many", n = node.n - 1 }
				local states = {}
				for i = 2, node.n do
					local childState = State.create(scope, state.compiler)

					local built = resolveNode(node[i], scope, childState)

					-- We wrap the child state in a lambda in order to correctly handle errors inside the system
					State.built(childState, {
							tag = "list", n = 3,
							range = built.range, owner = built.owner, parent = node,
							{ tag = "symbol", contents = "lambda", var = builtins["lambda"] },
							{ tag = "list", n = 0 },
							built
					})

					local func = State.get(childState)

					-- setup the active scope and node
					state.compiler['active-scope'] = scope
					state.compiler['active-node'] = built

					local success, replacement = packPcall(xpcall(func, debug.traceback))
					if not success then
						replacement = traceback.remapTraceback(state.mappings, replacement)
						errorPositions(log, node, replacement)
					end

					if i == node.n then
						for j = 1, replacement.n do
							res[i + j - 2] = replacement[j]
							states[i + j - 2] = childState
						end
						res.n = res.n + replacement.n - 1
					elseif replacement.n ~= 1 then
						errorPositions(log, node[i], "Expected one value, got " .. replacement.n)
					else
						res[i - 1] = replacement[1]
						states[i - 1] = childState
					end
				end

				if res.n == 0 or (res.n == 1 and res[1] == nil) then
					res.n = 1
					res[1] = { tag = "symbol", var = declaredVars["nil"] }
				end

				for i = 1, res.n do
					res[i] = resolveExecuteResult(states[i], res[i], node, scope, state)
				end

				if many then
					return res
				elseif res.n > 1 then
					errorPositions(log, node, "Multiple values returned in a non-block context")
				else
					return resolveNode(res[1], scope, state, root)
				end
			elseif func == builtins["unquote-splice"] then
				maxLength(log, node, 2, "unquote")
				local childState = State.create(scope, state.compiler)

				local built = resolveNode(node[2], scope, childState)

				-- We wrap the child state in a lambda in order to correctly handle errors inside the system
				State.built(childState, {
					tag = "list", n = 3,
					range = built.range, owner = built.owner, parent = node,
					{ tag = "symbol", contents = "lambda", var = builtins["lambda"] },
					{ tag = "list", n = 0 },
					built
				})

				local func = State.get(childState)

				-- Setup the active scope and node
				state.compiler['active-scope'] = scope
				state.compiler['active-node'] = built

				local success, replacement = xpcall(func, debug.traceback)
				if not success then
					replacement = traceback.remapTraceback(state.mappings, replacement)
					errorPositions(log, node, replacement)
				end

				-- Ensure we got a list from this unquote
				if type(replacement) ~= "table" or replacement.tag ~= "list" then
					local ty = type(replacement)
					if ty == "table" and type(ty.tag) == "string" then ty = ty.tag end
					errorPositions(log, node, "Expected list from unquote-splice, got '" .. ty .. "'")
				end

				if replacement.n == 0 then
					replacement.n = 1
					replacement[1] = { tag = "symbol", var = declaredVars["nil"] }
				end

				for i = 1, replacement.n do
					replacement[i] = resolveExecuteResult(childState, replacement[i], node, scope, state)
				end

				if many then
					replacement.tag = "many"
					return replacement
				elseif replacement.n > 1 then
					errorPositions(log, node, "Multiple values returned in a non-block context")
				else
					return resolveNode(replacement[1], scope, state, root)
				end
			elseif func == builtins["define"] then
				if not root then errorPositions(log, first, "define can only be used on the top level") end
				expectType(log, node[2], node, "symbol", "name")
				expect(log, node[3], node, "value")

				local var = Scope.addVerbose(scope, node[2].contents, "defined", node, log)
				State.define(state, var)
				node.defVar = var

				handleMetadata(log, node, var, 3, node.n - 1)

				node[node.n] = resolveNode(node[node.n], scope, state)
				return node
			elseif func == builtins["define-macro"] then
				if not root then errorPositions(log, first, "define-macro can only be used on the top level") end
				expectType(log, node[2], node, "symbol", "name")
				expect(log, node[3], node, "value")

				local var = Scope.addVerbose(scope, node[2].contents, "macro", node, log)
				State.define(state, var)
				node.defVar = var

				handleMetadata(log, node, var, 3, node.n - 1)

				node[node.n] = resolveNode(node[node.n], scope, state)
				return node
			elseif func == builtins["define-native"] then
				if not root then errorPositions(log, first, "define-native can only be used on the top level") end
				expectType(log, node[2], node, "symbol", "name")

				local var = Scope.addVerbose(scope, node[2].contents, "native", node, log)
				State.define(state, var)
				node.defVar = var

				handleMetadata(log, node, var, 3, node.n)

				return node
			elseif func == builtins["import"] then
				expectType(log, node[2], node, "symbol", "module name")
				maxLength(log, node, 4, "import")

				local as = node[2].contents
				local as, symbols
				if node[3] then
					if node[3].tag == "symbol" then
						as = node[3].contents
						symbols = nil
					elseif node[3].tag == "list" then
						as = nil
						if node[3].n == 0 then
							symbols = nil
						else
							symbols = {}
							for i = 1, node[3].n do
								local entry = node[3][i]
								expectType(log, entry, node[3], "symbol")

								symbols[entry.contents] = entry
							end
						end
					else
						expectType(log, node[3], node, "symbol", "alias name or import list")
					end
				else
					as = node[2].contents
					symbols = nil
				end

				local export = false
				if node[4] then
					expectType(log, node[4], node, "key", "key expected for import attributes")

					if node[4].contents == ":export" then
						export = true
					else
						errorPositions(log, node[4], "unknown import modifier")
					end
				end

				coroutine.yield({
					tag = "import",
					module = node[2].contents,
					as = as,
					symbols = symbols,
					export = export,
					scope = scope,
				})
				return node
			elseif func == builtins["struct-literal"] then
				if node.n % 2 ~= 1 then
					errorPositions(log, node, "Expected an even number of arguments, got " .. (node.n - 1))
				end

				resolveList(node, 2, scope, state)
				return node
			elseif func.tag == "macro" then
				if not funcState then errorPositions(log, first, "Macro is not defined correctly") end
				local builder = State.get(funcState)
				if type(builder) ~= "function" then
					errorPositions(first, "Macro is of type " .. type(builder))
				end

				-- Setup the active scope and node
				state.compiler['active-scope'] = scope
				state.compiler['active-node'] = node

				local success, replacement = packPcall(xpcall(function() return builder(table.unpack(node, 2, #node)) end, debug.traceback))
				if not success then
					replacement = traceback.remapTraceback(state.mappings, replacement)
					errorPositions(log, first, replacement)
				end

				for i = 1, replacement.n do
					replacement[i] = resolveExecuteResult(funcState, replacement[i], node, scope, state)
				end

				if replacement.n == 0 then
					errorPositions(log, node, "Expected some value from " .. getExecuteName(funcState) .. ", got nothing")
				elseif many then
					replacement.tag = "many"
					return replacement
				elseif replacement.n > 1 then
					errorPositions(log, node, "Multiple values returned in a non-block context")
				else
					return resolveNode(replacement[1], scope, state, root)
				end
			elseif func.tag == "defined" or func.tag == "arg" or func.tag == "native" or func.tag == "builtin" then
				return resolveList(node, 1, scope, state)
			else
				internalError(log, first, "Unknown kind " .. tostring(func.tag) .. " for variable " .. func.name)
			end
		elseif first.tag == "list" then
			return resolveList(node, 1, scope, state)
		else
			errorPositions(log, node[1], "Cannot invoke a non-function type '" .. first.tag .. "'")
		end
	else
		intenalError(log, node, "Unknown type " .. tostring(kind))
	end
end

function resolveList(list, start, scope, state)
	for i = start, #list do
		list[i] = resolveNode(list[i], scope, state)
	end

	return list
end

function resolveBlock(list, start, scope, state)
	local len = #list
	local i = start
	local m = false
	while i <= len do
		local node = resolveNode(list[i], scope, state, false, true)
		if node.tag == "many" then
			list[i] = node[1]
			for j = 2, node.n do
				table.insert(list, i + j - 1, node[j])
				m = true
			end
			len = len - 1 + node.n
			list.n = len
		else
			i = i + 1
		end
	end

	return list
end

--- Attempt to unpack single-item manys.
-- These are expensive to handle.
local function resolveInit(node, scope, state)
	node = resolveNode(node, scope, state, true, true)
	while node.tag == "many" and node.n == 1 do
		node = resolveNode(node[1], scope, state, true, true)
	end
	return node
end

return {
	resolve = resolveInit,
}
