local Scope = require "tacky.analysis.scope"
local State = require "tacky.analysis.state"
local logger = require "tacky.logger.init"
local range = require "tacky.range"
local traceback = require "tacky.traceback"

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

--- Reads metadata from the specified node, annotating the variable
-- @param log    The logger to print error messages to
-- @param node   The node we're reading from.
-- @param var    The variable this node defines, on which metadata should be stored.
-- @param start  The start offset of the node.
-- @param finish The finish offset of the node.
local function handleMetadata(log, node, var, start, finish)
	for i = start, finish do
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
			else
				errorPositions(log, child, "Unexpected modifier '" .. child.value .. "'")
			end
		else
			errorPositions(log, child, "Unexpected node of type " .. child.tag .. ", have you got too many values?")
		end
	end
end

local declaredSymbols = {
	-- Built in
	"lambda", "define", "define-macro", "define-native",
	"set!", "cond",
	"quote", "syntax-quote", "unquote", "unquote-splice",
	"import",
}

local rootScope = Scope.child()
rootScope.builtin = true

local builtins = {}
for i = 1, #declaredSymbols do
	local symbol = declaredSymbols[i]
	local var = Scope.add(rootScope, symbol, "builtin", nil)
	Scope.import(rootScope, "builtin/" .. symbol, var, true)
	builtins[symbol] = var
end

local declaredVars = {}
local declaredVariables = { "nil", "true", "false" }
for i = 1, #declaredVariables do
	local defined = declaredVariables[i]
	local var = Scope.add(rootScope, defined, "defined", nil)
	Scope.import(rootScope, "builtin/" .. defined, var, true)
	declaredVars[var] = true
	declaredVars[defined] = var
	builtins[defined] = var
end

local function getExecuteName(owner)
	if owner.var then
		return "macro '" .. owner.var.name .. "'"
	else
		return "unquote"
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
			errorPositions(state.logger, parent, "Invalid node of type '" .. ty .. "' from " .. getExecuteName(owner))
		end
	else
		errorPositions(state.logger, parent, "Invalid node of type '" .. ty .. "' from " .. getExecuteName(owner))
	end

	node.parent = parent

	-- We've already tagged this so continue
	if not node.range and not node.owner then
		node.owner = owner
	end

	if node.tag == "list" then
		for i = 1, node.n do
			node[i] = resolveExecuteResult(owner, node[i], node, scope, state)
		end
	elseif node.tag == "symbol" and type(node.var) == "string" then
		local var = state.variables[node.var]
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

function resolveNode(node, scope, state, root)
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
		state:require(node.var, node)
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
			local funcState = state:require(func, first)

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
				state:require(var, node[2])
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
				maxLength(log, node, 2, "unquote")
				local childState = State.create(state.variables, state.states, scope, state.logger, state.mappings)

				local built = resolveNode(node[2], scope, childState)

				-- We wrap the child state in a lambda in order to correctly handle errors inside the system
				childState:built({
					tag = "list", n = 3,
					range = built.range, owner = built.owner, parent = node,
					{ tag = "symbol", contents = "lambda", var = builtins["lambda"] },
					{ tag = "list", n = 0 },
					built
				})

				local func = childState:get()

				local success, replacement = xpcall(func, debug.traceback)
				if not success then
					replacement = traceback.remapTraceback(state.mappings, replacement)
					errorPositions(log, node, replacement)
				end

				if replacement == nil then
					replacement = { tag = "symbol", var = declaredVars["nil"] }
				end

				replacement = resolveExecuteResult(childState, replacement, node, scope, state)

				return resolveNode(replacement, scope, state, root)
			elseif func == builtins["unquote-splice"] then
				errorPositions(log, node[1] or node, "Unquote outside of syntax-quote")
			elseif func == builtins["define"] then
				if not root then errorPositions(log, first, "define can only be used on the top level") end
				expectType(log, node[2], node, "symbol", "name")
				expect(log, node[3], node, "value")

				local var = Scope.addVerbose(scope, node[2].contents, "defined", node, log)
				state:define(var)
				node.defVar = var

				handleMetadata(log, node, var, 3, node.n - 1)

				node[node.n] = resolveNode(node[node.n], scope, state)
				return node
			elseif func == builtins["define-macro"] then
				if not root then errorPositions(log, first, "define-macro can only be used on the top level") end
				expectType(log, node[2], node, "symbol", "name")
				expect(log, node[3], node, "value")

				local var = Scope.addVerbose(scope, node[2].contents, "macro", node, log)
				state:define(var)
				node.defVar = var

				handleMetadata(log, node, var, 3, node.n - 1)

				node[node.n] = resolveNode(node[node.n], scope, state)
				return node
			elseif func == builtins["define-native"] then
				if not root then errorPositions(log, first, "define-native can only be used on the top level") end
				expectType(log, node[2], node, "symbol", "name")

				local var = Scope.addVerbose(scope, node[2].contents, "native", node, log)
				state:define(var)
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
			elseif func.tag == "macro" then
				if not funcState then errorPositions(log, first, "Macro is not defined correctly") end
				local builder = funcState:get()
				if type(builder) ~= "function" then
					errorPositions(first, "Macro is of type " .. type(builder))
				end

				local success, replacement = xpcall(function() return builder(table.unpack(node, 2, #node)) end, debug.traceback)
				if not success then
					replacement = traceback.remapTraceback(state.mappings, replacement)
					errorPositions(log, first, replacement)
				end

				replacement = resolveExecuteResult(funcState, replacement, node, scope, state)

				return resolveNode(replacement, scope, state, root)
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
	for i = start, #list do
		list[i] = resolveNode(list[i], scope, state)
	end

	return list
end

return {
	createScope = function() return Scope.create(rootScope) end,
	rootScope = rootScope,
	builtins = builtins,
	declaredVars = declaredVars,
	resolveNode = resolveNode,
	resolveBlock = resolveBlock,
}
