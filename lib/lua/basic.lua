local counter = 0
local function pretty(x)
	if type(x) == 'table' and x.tag then
		if x.tag == 'list' then
			local y = {}
			for i = 1, x.n do
				y[i] = pretty(x[i])
			end
			return '(' .. table.concat(y, ' ') .. ')'
		elseif x.tag == 'symbol' or x.tag == 'key' or x.tag == 'string' or x.tag == 'number' then
			return x.contents
		else
			return tostring(x)
		end
	elseif type(x) == 'string' then
		return ("%q"):format(x)
	else
		return tostring(x)
	end
end

return {
	['='] = function(x, y) return x == y end,
	['/='] = function(x, y) return x ~= y end,
	['<'] = function(x, y) return x < y end,
	['<='] = function(x, y) return x <= y end,
	['>'] = function(x, y) return x > y end,
	['>='] = function(x, y) return x >= y end,

	['+'] = function(x, y) return x + y end,
	['-'] = function(x, y) return x - y end,
	['*'] = function(x, y) return x * y end,
	['/'] = function(x, y) return x / y end,
	['%'] = function(x, y) return x % y end,
	['^'] = function(x, y) return x ^ y end,
	['..'] = function(x, y) return x .. y end,
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
	_G = _G, _ENV = _ENV, _VERSION = _VERSION,
	assert = assert, collectgarbage = collectgarbage,
	dofile = dofile, error = error,
	getmetatable = getmetatable, ipairs = ipairs,
	load = load, loadfile = loadfile,
	next = next, pairs = pairs,
	pcall = pcall, print = print,
	rawequal = rawequal, rawget = rawget,
	rawlen = rawlen, rawset = rawset,
	require = require, select = select,
	setmetatable = setmetatable, tonumber = tonumber,
	tostring = tostring, ["type#"] = type,
	xpcall = xpcall,
	["get-idx"] = function(x, i) return x[i] end,
	["set-idx!"] = function(x, k, v) x[k] = v end
}
