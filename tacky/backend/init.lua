if not table.pack then table.pack = function(...) return { n = select("#", ...), ... } end end
if not table.unpack then table.unpack = unpack end
if _VERSION:find("5.1") then local function load(x, _, _, env) local f, e = loadstring(x); if not f then error(e, 1) end; return setfenv(f, env) end end
local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error
local _libs = {}
local _temp = (function()
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
	}
end)() 
for k, v in pairs(_temp) do _libs[k] = v end
local _temp = (function()
	return {
		byte    = string.byte,
		char    = string.char,
		concat  = table.concat,
		find    = function(text, pattern, offset, plaintext)
			local start, finish = string.find(text, pattern, offset, plaintext)
			if start then
				return { tag = "list", n = 2, start, finish }
			else
				return nil
			end
		end,
		format  = string.format,
		lower   = string.lower,
		reverse = string.reverse,
		rep     = string.rep,
		replace = string.gsub,
		sub     = string.sub,
		upper   = string.upper,
		['#s']   = string.len,
	}
end)() 
for k, v in pairs(_temp) do _libs[k] = v end
local _temp = (function()
	return {
	  getmetatable = getmetatable,
	  setmetatable = setmetatable
	}
end)() 
for k, v in pairs(_temp) do _libs[k] = v end

_3d_1 = _libs["="]
_2f3d_1 = _libs["/="]
_3c_1 = _libs["<"]
_3c3d_1 = _libs["<="]
_3e3d_1 = _libs[">="]
_2b_1 = _libs["+"]
_25_1 = _libs["%"]
_2e2e_1 = _libs[".."]
getIdx1 = _libs["get-idx"]
setIdx_21_1 = _libs["set-idx!"]
format1 = _libs["format"]
error_21_1 = _libs["error!"]
type_23_1 = _libs["type#"]
emptyStruct1 = _libs["empty-struct"]
require1 = _libs["require"]
unpack1 = _libs["unpack"]
_23_1 = (function(xs1)
	return xs1["n"]
end);
key_3f_1 = (function(x8)
	return (type1(x8) == "key")
end);
type1 = (function(val1)
	local ty2
	ty2 = type_23_1(val1)
	if (ty2 == "table") then
		local tag1
		tag1 = val1["tag"]
		if tag1 then
			return tag1
		else
			return "table"
		end
	else
		return ty2
	end
end);
list1 = (function(...)
	local entries1 = _pack(...) entries1.tag = "list"
	return entries1
end);
_23_2 = (function(li5)
	local r_81
	r_81 = type1(li5)
	if (r_81 ~= "list") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_81), 2)
	else
	end
	return _23_1(li5)
end);
concat1 = _libs["concat"]
sub1 = _libs["sub"]
struct1 = (function(...)
	local keys3 = _pack(...) keys3.tag = "list"
	if ((_23_2(keys3) % 1) == 1) then
		error_21_1("Expected an even number of arguments to struct", 2)
	else
	end
	local contents1, out2
	contents1 = (function(key3)
		return sub1(key3["contents"], 2)
	end);
	out2 = {}
	local r_621
	r_621 = _23_1(keys3)
	local r_631
	r_631 = 2
	local r_601
	r_601 = nil
	r_601 = (function(r_611)
		local _temp
		if (0 < 2) then
			_temp = (r_611 <= r_621)
		else
			_temp = (r_611 >= r_621)
		end
		if _temp then
			local i3
			i3 = r_611
			local key4, val2
			key4 = keys3[i3]
			val2 = keys3[(1 + i3)]
			out2[(function()
				if key_3f_1(key4) then
					return contents1(key4)
				else
					return key4
				end
			end)()] = val2
			return r_601((r_611 + r_631))
		else
		end
	end);
	r_601(1)
	return out2
end);
create1 = (function()
	return struct1("out", list1(), "indent", 0, "tabs-pending", false)
end);
_2d3e_string1 = (function(writer1)
	return concat1(writer1["out"])
end);
oldWriter1 = require1("tacky.backend.writer")
wrapGenerate1 = (function(func1, newStyle1)
	if newStyle1 then
		return (function(node1, ...)
			local args3 = _pack(...) args3.tag = "list"
			local writer2
			writer2 = create1()
			func1(node1, writer2, unpack1(args3))
			return _2d3e_string1(writer2)
		end);
	else
		return (function(node2, ...)
			local args4 = _pack(...) args4.tag = "list"
			local writer3
			writer3 = oldWriter1()
			func1(node2, writer3, unpack1(args4))
			return writer3["toString"]()
		end);
	end
end);
local backends1
backends1 = {}
local r_921
r_921 = {tag = "list", n = 2, "lisp", "lua"}
local r_951
r_951 = _23_2(r_921)
local r_961
r_961 = 1
local r_931
r_931 = nil
r_931 = (function(r_941)
	local _temp
	if (0 < 1) then
		_temp = (r_941 <= r_951)
	else
		_temp = (r_941 >= r_951)
	end
	if _temp then
		local r_911
		r_911 = r_941
		local backend1
		backend1 = r_921[r_911]
		local module1
		module1 = require1(("tacky.backend." .. backend1))
		local newStyle2
		newStyle2 = (backend1 == "lisp")
		backends1[backend1] = struct1("expression", wrapGenerate1(module1["expression"], newStyle2), "block", wrapGenerate1(module1["block"], newStyle2), "prelude", (function(r_1011)
			if r_1011 then
				return wrapGenerate1(module1["prelude"], newStyle2)
			else
				return r_1011
			end
		end)(module1["prelude"]), "backend", module1)
		return r_931((r_941 + r_961))
	else
	end
end);
r_931(1)
return backends1
