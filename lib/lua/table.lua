return {
	['empty-struct'] = function() return {} end,
	['iter-pairs'] = function(xs, f)
		for k, v in pairs(xs) do
			f(k, v)
		end
	end,
}
