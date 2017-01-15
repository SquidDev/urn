-- base is an internal version of core methods without any extensions or assertions.
-- You should not use this unless you are building core libraries.

-- Native methods in base should do the bare minimum: you should try to move as much
-- as possible to Urn

local pprint = require "tacky.pprint"

local randCtr = 0
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

	['get-idx'] = rawget,
	['set-idx!'] = rawset,
	['remove-idx!'] = table.remove,
	['slice'] = function(xs, start, finish)
		if not finish then finish = xs.n end
		return { tag = "list", n = finish - start + 1, table.unpack(xs, start, finish) }
	end,

	['print!'] = print,
	['pretty'] = function (x) return pprint.tostring(x, pprint.nodeConfig) end,
	['error!'] = error,
	['type#'] = type,
	['empty-struct'] = function() return {} end,
	['format'] = string.format,
	['xpcall'] = xpcall,
	['traceback'] = debug.traceback,
	['require'] = require,
	['string->number'] = tonumber,
	['number->string'] = tostring,
	['clock'] = os.clock,
	['exit'] = os.exit,
	['unpack'] = function(li) return table.unpack(li, 1, li.n) end,

	['gensym'] = function(name)
		if name then
			name = "_" .. tostring(name)
		else
			name = ""
		end

		randCtr = randCtr + 1
		return { tag = "symbol", contents = ("r_%d%s"):format(randCtr, name) }
	end,
	_G = _G, _ENV = _ENV
}
