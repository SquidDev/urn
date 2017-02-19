return {
	['empty-struct'] = function() return {} end,
	['unpack'] = table.unpack or unpack,
	['iter-pairs'] = function(xs, f)
		for k, v in pairs(xs) do
			f(k, v)
		end
	end,

	concat = table.concat,
	insert = table.insert,
	move = table.move,
	pack = table.pack,
	remove = table.remove,
	sort = table.sort,
}
