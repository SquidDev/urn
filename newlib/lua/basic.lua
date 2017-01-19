local pprint = require 'tacky.pprint'
local counter = 0

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
	['gensym'] = function(name)
		if name then
			name = "_" .. tostring(name)
		else
			name = ""
		end
		counter = counter + 1
		return { tag = "symbol", contents = ("r_%d%s"):format(counter, name) }
	end,
	['get-idx'] = rawget, ['set-idx!'] = rawset
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
	tostring = tostring, type = type,
	xpcall = xpcall }
