return function()
	local out, n = {}, 0

	local indent, tabsPending = 0, false

	function out.line(txt)
		if txt then out.add(txt) end

		-- Don't write empty lines
		if tabsPending then return end

		tabsPending = true
		n = n + 1
		out[n] = "\n"
	end

	function out.indent() indent = indent + 1 end
	function out.unindent() indent = indent - 1 end

	function out.add(txt)
		if type(txt) ~= "string" then error(tostring(txt) .. " isn't a string", 2) end
		if tabsPending then
			tabsPending = false
			n = n + 1
			out[n] = ("\t"):rep(indent)
		end

		n = n + 1
		out[n] = txt
	end

	function out.beginBlock(txt)
		out.add(txt)
		out.line()
		out.indent()
	end

	function out.splitBlock(txt)
		out.unindent()
		out.add(txt)
		out.line()
		out.indent()
	end

	function out.endBlock(txt)
		out.unindent()
		out.add(txt)
		out.line()
	end

	function out.toString() return table.concat(out) end

	return out
end
