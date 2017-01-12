local Scope = require "tacky.analysis.scope"
local errorPositions = require "tacky.logger".errorPositions

local function expectType(node, parent, type, name)
	if not node or node.tag ~= type then
		errorPositions(node or parent, "Expected " .. (name or type) .. ", got " .. (node and node.tag or "nothing"))
	end
end

local function expect(node, parent, name)
	if not node then
		errorPositions(parent, "Expected " .. name .. ", got nothing")
	end
end

local declaredSymbols = {
	-- Built in
	"lambda", "define", "define-macro", "define-native",
	"set!", "cond",
	"quote", "quasiquote", "unquote", "unquote-splice",
	"import",
}

local rootScope = Scope.child()
rootScope.builtin = true

local builtins = {}
for i = 1, #declaredSymbols do
	local symbol = declaredSymbols[i]
	builtins[symbol] = rootScope:add(symbol, "builtin", nil)
end

local declaredVars = {}
local declaredVariables = { "nil", "true", "false" }
for i = 1, #declaredVariables do
	local defined = declaredVariables[i]
	declaredVars[rootScope:add(defined, "defined", nil)] = true
end

local function resolveMacroResult(macro, node, parent, scope, state)
	if not node then
		return
	end

	local ty = type(node)
	if ty == "string" then
		node = { tag = "string", contents = ("%q"):format(node) }
	elseif ty == "number" then
		node = { tag = "number", contents = node }
	elseif ty == "boolean" then
		node = { tag = "symbol", contents = node and declaredVars["true"] or declaredVars["false"] }
	elseif ty == "function" then
		error("Returned function from macro")
	end

	node.parent = parent

	-- We've already tagged this so continue
	if not node.range and not node.macro then
		node.macro = macro
	end

	if node.tag == "list" then
		for i = 1, node.n do
			node[i] = resolveMacroResult(macro, node[i], node, scope, state)
		end
	elseif node.tag == "symbol" and type(node.var) == "string" then
		node.var = assert(state.variables[node.var], "Invalid variable key '" .. node.var .. "'")
	end

	return node
end

local resolveNode, resolveBlock, resolveQuote

function resolveQuote(node, scope, state, level)
	if level == 0 then
		return resolveNode(node, scope, state)
	end

	if node.tag == "string" or node.tag == "number" or node.tag == "key" then
		return node
	elseif node.tag == "symbol" then
		if not node.var then
			node.var = scope:get(node.contents, node)

			if not node.var.scope.isRoot and not node.var.scope.builtin then
				errorPositions(node, "Cannot use non-top level definition in quasiquote")
			end
		end
		return node
	elseif node.tag == "list" then
		local first = node[1]
		if first and first.tag == "symbol" then
			if first.contents == "unquote" or first.contents == "unquote-splice" then
				node[2] = resolveQuote(node[2], scope, state, level - 1)
				return node
			elseif first.contents == "quasiquote" then
				node[2] = resolveQuote(node[2], scope, state, level + 1)
				return node
			end
		end

		for i = 1, #node do
			node[i] = resolveQuote(node[i], scope, state, level)
		end

		return node
	else
		error("Unknown tag " .. expr.tag)
	end
end

function resolveNode(node, scope, state)
	local kind = node.tag
	if kind == "number" or kind == "boolean" or kind == "string" or node.tag == "key" then
		-- Do nothing: this is a constant term after all
		return node
	elseif kind == "symbol" then
		if not node.var then
			node.var = scope:get(node.contents, node)
		end
		state:require(node.var)
		return node
	elseif kind == "list" then
		local first = node[1]
		if first and first.tag == "symbol" then
			if not first.var then
				first.var = scope:get(first.contents, first)
			end

			local func = first.var
			local funcState = state:require(func)

			if func == builtins["lambda"] then
				expectType(node[2], node, "list", "argument list")

				local childScope = scope:child()

				local args = node[2]

				local hasVariadic
				for i = 1, #args do
					expectType(args[i], args, "symbol", "argument")
					local name = args[i].contents

					-- Strip "&" for variadic arguments.
					local isVar = name:sub(1, 1) == "&"
					if isVar then
						if hasVariadic then
							errorPositions(args[i], "Cannot have multiple variadic arguments")
						else
							name = name:sub(2)
							hasVariadic = true
						end
					end

					args[i].var = childScope:add(name, "arg", args[i])
					args[i].var.isVariadic = isVar
				end

				resolveBlock(node, 3, childScope, state)
				return node
			elseif func == builtins["cond"] then
				for i = 2, #node do
					local case = node[i]
					expectType(case, node, "list", "case expression")
					expect(case[1], case, "condition")

					case[1] = resolveNode(case[1], scope, state)

					local childScope = scope:child()
					resolveBlock(case, 2, childScope, state)
				end

				return node
			elseif func == builtins["set!"] then
				expectType(node[2], node, "symbol")
				expect(node[3], node, "value")

				local var = scope:get(node[2].contents, node[2])
				state:require(var)
				node[2].var = var
				if var.const then
					errorPositions(node, "Cannot rebind constant " .. var.name)
				end

				node[3] = resolveNode(node[3], scope, state)
				return node
			elseif func == builtins["quote"] then
				expect(node[2], node, "value")
				return node
			elseif func == builtins["quasiquote"] then
				expect(node[2], node, "value")

				node[2] = resolveQuote(node[2], scope, state, 1)
				return node
			elseif func == builtins["unquote"] or func == builtins["unquote-splice"] then
				errorPositions(node[1] or node, "Unquote outside of quasiquote")
			elseif func == builtins["define"] then
				expectType(node[2], node, "symbol", "name")
				expect(node[3], node, "value")

				node.defVar = scope:add(node[2].contents, "defined", node)
				state:define(node.defVar)

				node[3] = resolveNode(node[3], scope, state)
				return node
			elseif func == builtins["define-macro"] then
				expectType(node[2], node, "symbol", "name")
				expect(node[3], node, "value")

				node.defVar = scope:add(node[2].contents, "macro", node)
				state:define(node.defVar)

				node[3] = resolveNode(node[3], scope, state)
				return node
			elseif func == builtins["define-native"] then
				expectType(node[2], node, "symbol", "name")

				node.defVar = scope:add(node[2].contents, "defined", node)
				state:define(node.defVar)
				return node
			elseif func == builtins["import"] then
				expectType(node[2], node, "symbol", "module name")

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
								expectType(entry, node[3], "symbol")

								symbols[entry.contents] = true
							end
						end
					else
						expectType(node[3], node, "symbol", "alias name or import list")
					end
				else
					as = node[2].contents
					symbols = nil
				end

				coroutine.yield({
					tag = "import",
					module = node[2].contents,
					as = as,
					symbols = symbols
				})
				return node
			elseif func.tag == "macro" then
				if not funcState then errorPositions(first, "Macro is not defined correctly") end
				local builder = funcState:get()
				if type(builder) ~= "function" then
					errorPositions(first, "Macro is of type " .. type(builder))
				end

				local success, replacement = xpcall(function() return builder(table.unpack(node, 2, #node)) end, debug.traceback)
				if not success then
					errorPositions(first, replacement)
				elseif replacement == nil then
					errorPositions(first, "Macro " .. func.name .. " returned empty node")
				end

				replacement = resolveMacroResult(funcState, replacement, node, scope, state)

				return resolveNode(replacement, scope, state)
			elseif func.tag == "defined" or func.tag == "arg" then
				return resolveList(node, 1, scope, state)
			else
				error("Unknown kind " .. tostring(func.tag) .. " for variable " .. func.name)
			end
		else
			return resolveList(node, 1, scope, state)
		end
	else
		error("Unknown type " .. tostring(kind))
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
	createScope = function() return rootScope:child() end,
	rootScope = rootScope,
	builtins = builtins,
	declaredVars = declaredVars,
	resolveNode = resolveNode,
	resolveBlock = resolveBlock,
}
