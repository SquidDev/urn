local builtins = require "tacky.analysis.resolve".builtins

local visitNode, visitBlock, visitQuote

function visitQuote(node, visitor, level)
	if level == 0 then
		return visitNode(node, visitor)
	end

	if node.tag == "string" or node.tag == "number" or node.tag == "key" or node.tag == "symbol" then
		return
	elseif node.tag == "list" then
		local first = node[1]
		if first and first.tag == "symbol" then
			if first.contents == "unquote" or first.contents == "unquote-splice" then
				return visitQuote(node[2], visitor, level - 1)
			elseif first.contents == "quasiquote" then
				return visitQuote(node[2], visitor, level + 1)
			end
		end

		for i = 1, #node do
			visitQuote(node[i], visitor, level)
		end
	else
		error("Unknown tag " .. expr.tag)
	end
end

function visitNode(node, visitor)
	-- Visit the node, if we return false then we won't go any further
	if visitor(node) == false then return end

	local kind = node.tag
	if kind == "number" or kind == "boolean" or kind == "string" or node.tag == "key" or kind == "symbol" then
		-- Do nothing: this is a constant term after all
	elseif kind == "list" then
		local first = node[1]
		if first and first.tag == "symbol" then
			local func = first.var
			if func == builtins["lambda"] then
				visitBlock(node, 3, visitor)
			elseif func == builtins["cond"] then
				for i = 2, #node do
					local case = node[i]
					visitNode(case[1], visitor)
					visitBlock(case, 2, visitor)
				end
			elseif func == builtins["set!"] then
				visitNode(node[3], visitor)
			elseif func == builtins["quote"] then
				-- Nothing doing
			elseif func == builtins["quasiquote"] then
				visitQuote(node[2], visitor, 1)
			elseif func == builtins["unquote"] or func == builtins["unquote-splice"] then
				-- This should never happen
				error("unquote/unquote-splice is illegal: this should have been caught already")
			elseif func == builtins["define"] or func == builtins["define-macro"] then
				visitNode(node[3], visitor)
			elseif func == builtins["define-native"] then
				-- Can't really do anything here
			elseif func == builtins["import"] then
				-- This isn't emitted at all so we don't have to do anything
			elseif func.tag == "macro" then
				-- This should never happen: we'll have expanded it
				error("Macros should have been expanded")
			elseif func.tag == "defined" or func.tag == "arg" then
				visitList(node, 1, visitor)
			else
				error("Unknown kind " .. tostring(func.tag) .. " for variable " .. func.name)
			end
		else
			return visitList(node, 1, visitor)
		end
	else
		error("Unknown type " .. tostring(kind))
	end
end

function visitList(list, start, visitor)
	for i = start, #list do
		visitNode(list[i], visitor)
	end

	return list
end

function visitBlock(list, start, visitor)
	for i = start, #list do
		visitNode(list[i], visitor)
	end

	return list
end

return {
	visitNode = visitNode,
	visitBlock = visitBlock,
	visitList = visitList,
}
