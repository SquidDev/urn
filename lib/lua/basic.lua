return {
	['slice'] = function(xs, start, finish)
		if not finish then finish = xs.n end
		if not finish then finish = #xs end
		return { tag = "list", n = finish - start + 1, table.unpack(xs, start, finish) }
	end,
}
