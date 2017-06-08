return {
	['slice'] = function(xs, start, finish)
		if not finish then finish = xs.n end
		if not finish then finish = #xs end
		local len = finish - start + 1
		if len < 0 then len = 0 end
		return { tag = "list", n = len, table.unpack(xs, start, finish) }
	end,
}
