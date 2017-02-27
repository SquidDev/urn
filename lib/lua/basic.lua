local counter = 0
local function pretty(x)
	if type(x) == 'table' and x.tag then
		if x.tag == 'list' then
			local y = {}
			for i = 1, x.n do
				y[i] = pretty(x[i])
			end
			return '(' .. table.concat(y, ' ') .. ')'
		elseif x.tag == 'symbol' then
			return x.contents
		elseif x.tag == 'key' then
			return ":" .. x.value
		elseif x.tag == 'string' then
			return (("%q"):format(x.value):gsub("\n", "n"):gsub("\t", "\\9"))
		elseif x.tag == 'number' then
			return tostring(x.value)
		elseif x.tag.tag and x.tag.tag == 'symbol' and x.tag.contents == 'pair' then
			return '(pair ' .. pretty(x.fst) .. ' ' .. pretty(x.snd) .. ')'
		elseif x.tag == 'thunk' then
			return '<<thunk>>'
		else
			return tostring(x)
		end
	elseif type(x) == 'string' then
		return ("%q"):format(x)
	else
		return tostring(x)
	end
end

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
	pretty = pretty,
	['gensym'] = function(name)
		if name then
			name = "_" .. tostring(name)
		else
			name = ""
		end
		counter = counter + 1
		return { tag = "symbol", contents = ("r_%d%s"):format(counter, name) }
	end,
	arg = arg,
}
