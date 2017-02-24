if not table.pack then table.pack = function(...) return { n = select("#", ...), ... } end end
if not table.unpack then table.unpack = unpack end
local load = load if _VERSION:find("5.1") then load = function(x, _, _, env) local f, e = loadstring(x); if not f then error(e, 1) end; return setfenv(f, env) end end
local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error
local _libs = {}
local _temp = (function()
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
		_G = _G, _ENV = _ENV, _VERSION = _VERSION, arg = arg,
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
end)()
for k, v in pairs(_temp) do _libs["lib/lua/basic/".. k] = v end
local _temp = (function()
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
end)()
for k, v in pairs(_temp) do _libs["lib/lua/table/".. k] = v end
local _temp = (function()
	return {
		byte = string.byte,
		char = string.char,
		dump = string.dump,
		find = string.find,
		format = string.format,
		gsub = string.gsub,
		len = string.len,
		lower = string.lower,
		match = string.match,
		rep = string.rep,
		reverse = string.reverse,
		sub = string.sub,
		upper = string.upper,
	}
end)()
for k, v in pairs(_temp) do _libs["lib/lua/string/".. k] = v end
local _temp = (function()
	return os
end)()
for k, v in pairs(_temp) do _libs["lib/lua/os/".. k] = v end
local _temp = (function()
	return io
end)()
for k, v in pairs(_temp) do _libs["lib/lua/io/".. k] = v end
local _temp = (function()
	return math
end)()
for k, v in pairs(_temp) do _libs["lib/lua/math/".. k] = v end
local _3d_1, _2f3d_1, _3c_1, _3c3d_1, _2b_1, _2d_1, _25_1, error1, getIdx1, setIdx_21_1, require1, type_23_1, _23_1, emptyStruct1, car1, list1, find1, format1, len1, match1, sub1, list_3f_1, symbol_3f_1, key_3f_1, type1, car2, nth1, pushCdr_21_1, _23_s1, struct1, succ1, pred1, builtins1, tokens1, extractSignature1, parseDocstring1
_3d_1 = _libs["lib/lua/basic/="]
_2f3d_1 = _libs["lib/lua/basic//="]
_3c_1 = _libs["lib/lua/basic/<"]
_3c3d_1 = _libs["lib/lua/basic/<="]
_2b_1 = _libs["lib/lua/basic/+"]
_2d_1 = _libs["lib/lua/basic/-"]
_25_1 = _libs["lib/lua/basic/%"]
error1 = _libs["lib/lua/basic/error"]
getIdx1 = _libs["lib/lua/basic/get-idx"]
setIdx_21_1 = _libs["lib/lua/basic/set-idx!"]
require1 = _libs["lib/lua/basic/require"]
type_23_1 = _libs["lib/lua/basic/type#"]
_23_1 = (function(x1)
	return x1["n"]
end)
emptyStruct1 = _libs["lib/lua/table/empty-struct"]
car1 = (function(xs1)
	return xs1[1]
end)
list1 = (function(...)
	local xs2 = _pack(...) xs2.tag = "list"
	return xs2
end)
find1 = _libs["lib/lua/string/find"]
format1 = _libs["lib/lua/string/format"]
len1 = _libs["lib/lua/string/len"]
match1 = _libs["lib/lua/string/match"]
sub1 = _libs["lib/lua/string/sub"]
list_3f_1 = (function(x2)
	return (type1(x2) == "list")
end)
symbol_3f_1 = (function(x3)
	return (type1(x3) == "symbol")
end)
key_3f_1 = (function(x4)
	return (type1(x4) == "key")
end)
type1 = (function(val1)
	local ty1 = type_23_1(val1)
	if (ty1 == "table") then
		local tag1 = val1["tag"]
		if tag1 then
			return tag1
		else
			return "table"
		end
	else
		return ty1
	end
end)
car2 = (function(x5)
	local r_241 = type1(x5)
	if (r_241 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_241), 2)
	else
	end
	return car1(x5)
end)
nth1 = (function(xs3, idx1)
	return xs3[idx1]
end)
pushCdr_21_1 = (function(xs4, val2)
	local r_341 = type1(xs4)
	if (r_341 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_341), 2)
	else
	end
	local len2 = (_23_1(xs4) + 1)
	xs4["n"] = len2
	xs4[len2] = val2
	return xs4
end)
_23_s1 = len1
struct1 = (function(...)
	local keys1 = _pack(...) keys1.tag = "list"
	if ((_23_1(keys1) % 1) == 1) then
		error1("Expected an even number of arguments to struct", 2)
	else
	end
	local contents1 = (function(key1)
		return key1["contents"]
	end)
	local out1 = emptyStruct1()
	local r_581 = _23_1(keys1)
	local r_591 = 2
	local r_561 = nil
	r_561 = (function(r_571)
		if (r_571 <= r_581) then
			local i1 = r_571
			local key2 = keys1[i1]
			local val3 = keys1[(1 + i1)]
			out1[(function()
				if key_3f_1(key2) then
					return contents1(key2)
				else
					return key2
				end
			end)()
			] = val3
			return r_561((r_571 + 2))
		else
		end
	end)
	r_561(1)
	return out1
end)
succ1 = (function(x6)
	return (x6 + 1)
end)
pred1 = (function(x7)
	return (x7 - 1)
end)
builtins1 = require1("tacky.analysis.resolve")["builtins"]
tokens1 = {tag = "list", n =4, {tag = "list", n =2, "arg", "(%f[%a]%u+%f[%A])"}, {tag = "list", n =2, "mono", "```[a-z]*\n([^`]*)\n```"}, {tag = "list", n =2, "mono", "`([^`]*)`"}, {tag = "list", n =2, "link", "%[%[(.-)%]%]"}}
extractSignature1 = (function(var1)
	local ty2 = type1(var1)
	local temp1
	local r_881 = (ty2 == "macro")
	if r_881 then
		temp1 = r_881
	else
		temp1 = (ty2 == "defined")
	end
	if temp1 then
		local root1 = var1["node"]
		local node1 = nth1(root1, _23_1(root1))
		local temp2
		local r_891 = list_3f_1(node1)
		if r_891 then
			local r_901 = symbol_3f_1(car2(node1))
			if r_901 then
				temp2 = (car2(node1)["var"] == builtins1["lambda"])
			else
				temp2 = r_901
			end
		else
			temp2 = r_891
		end
		if temp2 then
			return nth1(node1, 2)
		else
			return nil
		end
	else
		return nil
	end
end)
parseDocstring1 = (function(str1)
	local out2 = {tag = "list", n =0}
	local pos1 = 1
	local len3 = _23_s1(str1)
	local r_911 = nil
	r_911 = (function()
		if (pos1 <= len3) then
			local spos1 = len3
			local epos1 = nil
			local name1 = nil
			local ptrn1 = nil
			local r_931 = tokens1
			local r_961 = _23_1(r_931)
			local r_971 = 1
			local r_941 = nil
			r_941 = (function(r_951)
				if (r_951 <= r_961) then
					local r_921 = r_951
					local tok1 = r_931[r_921]
					local npos1 = list1(find1(str1, nth1(tok1, 2), pos1))
					local temp3
					local r_981 = car2(npos1)
					if r_981 then
						temp3 = (car2(npos1) < spos1)
					else
						temp3 = r_981
					end
					if temp3 then
						spos1 = car2(npos1)
						epos1 = nth1(npos1, 2)
						name1 = car2(tok1)
						ptrn1 = nth1(tok1, 2)
					else
					end
					return r_941((r_951 + 1))
				else
				end
			end)
			r_941(1)
			if name1 then
				if (pos1 < spos1) then
					pushCdr_21_1(out2, struct1("tag", "text", "contents", sub1(str1, pos1, pred1(spos1))))
				else
				end
				pushCdr_21_1(out2, struct1("tag", name1, "whole", sub1(str1, spos1, epos1), "contents", match1(sub1(str1, spos1, epos1), ptrn1)))
				pos1 = succ1(epos1)
			else
				pushCdr_21_1(out2, struct1("tag", "text", "contents", sub1(str1, pos1, len3)))
				pos1 = succ1(len3)
			end
			return r_911()
		else
		end
	end)
	r_911()
	return out2
end)
return struct1("parseDocs", parseDocstring1, "extractSignature", extractSignature1)
