if arg then
	if not arg.n then arg.n = #arg end
	if not arg.tag then arg.tag = "list" end
else
	arg = { tag = "list", n = 0 }
end

return {
	['slice'] = function(xs, start, finish)
		if not finish then finish = xs.n end
		if not finish then finish = #xs end
		return { tag = "list", n = finish - start + 1, table.unpack(xs, start, finish) }
	end,
	arg = arg,
}
