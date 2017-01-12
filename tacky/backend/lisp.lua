local writer = require "tacky.backend.writer"
local pp = require "tacky.pprint"

local function estimateLength(node, max)
	local tag = node.tag
	if tag == "string" or tag == "number" or tag == "symbol" then
		return #(tostring(node.contents))
	else
		local sum = 2
		for i = 1, #node do
			sum = sum + estimateLength(node[i], max - sum)

			-- Include "gap" between entries
			if i > 1 then sum = sum + 1 end

			if sum > max then break end
		end
		return sum
	end
end
local function expression(node, writer)
	local tag = node.tag
	if tag == "string" or tag == "number" or tag == "symbol" or node.tag == "key" then
		writer.add(tostring(node.contents))
	elseif tag == "list" then
		writer.add("(")

		if node[1] == nil then
			writer.add(")")
			return
		end

		local newLine = false
		expression(node[1], writer)

		local max = 60 - estimateLength(node[1], 60)
		if max <= 0 then
			newLine = true
			writer.indent()
		end

		for i = 2, #node do
			local entry = node[i]

			if not newLine and max > 0 then
				max = max - estimateLength(entry, max)
				if max <= 0 then
					newLine = true
					writer.indent()
				end
			end

			if newLine then
				writer.line()
			else
				writer.add(" ")
			end
			expression(entry, writer)
		end

		if newLine then writer.unindent() end
		writer.add(")")
	else
		error("Unsuported type " .. tag)
	end
end

local function block(list, writer)
	for i = 1, #list do
		expression(list[i], writer)
		writer.line()
	end
end


return {
	expression = expression,
	block = block,
}
