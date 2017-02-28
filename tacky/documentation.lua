if not table.pack then table.pack = function(...) return { n = select("#", ...), ... } end end
if not table.unpack then table.unpack = unpack end
local load = load if _VERSION:find("5.1") then load = function(x, _, _, env) local f, e = loadstring(x); if not f then error(e, 1) end; return setfenv(f, env) end end
local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error
local _libs = {}
local _temp = (function()
	return {
		['slice'] = function(xs, start, finish)
			if not finish then finish = xs.n end
			if not finish then finish = #xs end
			return { tag = "list", n = finish - start + 1, table.unpack(xs, start, finish) }
		end,
	}
end)()
for k, v in pairs(_temp) do _libs["lib/lua/basic/".. k] = v end
local _3d_1, _2f3d_1, _3c_1, _3c3d_1, _2b_1, _2d_1, _25_1, error1, getIdx1, setIdx_21_1, require1, type_23_1, _23_1, find1, format1, len1, match1, sub1, emptyStruct1, car1, list1, list_3f_1, symbol_3f_1, key_3f_1, type1, car2, nth1, pushCdr_21_1, struct1, succ1, pred1, builtins1, tokens1, extractSignature1, parseDocstring1
_3d_1 = function(v1, v2) return (v1 == v2) end
_2f3d_1 = function(v1, v2) return (v1 ~= v2) end
_3c_1 = function(v1, v2) return (v1 < v2) end
_3c3d_1 = function(v1, v2) return (v1 <= v2) end
_2b_1 = function(v1, v2) return (v1 + v2) end
_2d_1 = function(v1, v2) return (v1 - v2) end
_25_1 = function(v1, v2) return (v1 % v2) end
error1 = error
getIdx1 = function(v1, v2) return v1[v2] end
setIdx_21_1 = function(v1, v2, v3) v1[v2] = v3 end
require1 = require
type_23_1 = type
_23_1 = (function(x1)
	return x1["n"]
end)
find1 = string.find
format1 = string.format
len1 = string.len
match1 = string.match
sub1 = string.sub
emptyStruct1 = function() return {} end
car1 = (function(xs1)
	return xs1[1]
end)
list1 = (function(...)
	local xs2 = _pack(...) xs2.tag = "list"
	return xs2
end)
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
	local r_281 = type1(x5)
	if (r_281 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_281), 2)
	else
	end
	return car1(x5)
end)
nth1 = (function(xs3, idx1)
	return xs3[idx1]
end)
pushCdr_21_1 = (function(xs4, val2)
	local r_381 = type1(xs4)
	if (r_381 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_381), 2)
	else
	end
	local len2 = (_23_1(xs4) + 1)
	xs4["n"] = len2
	xs4[len2] = val2
	return xs4
end)
struct1 = (function(...)
	local keys1 = _pack(...) keys1.tag = "list"
	if ((_23_1(keys1) % 1) == 1) then
		error1("Expected an even number of arguments to struct", 2)
	else
	end
	local contents1 = (function(key1)
		return key1["contents"]
	end)
	local out1 = {}
	local r_601 = _23_1(keys1)
	local r_581 = nil
	r_581 = (function(r_591)
		if (r_591 <= r_601) then
			local key2 = keys1[r_591]
			local val3 = keys1[(1 + r_591)]
			out1[(function()
				if key_3f_1(key2) then
					return contents1(key2)
				else
					return key2
				end
			end)()
			] = val3
			return r_581((r_591 + 2))
		else
		end
	end)
	r_581(1)
	return out1
end)
succ1 = (function(x6)
	return (x6 + 1)
end)
pred1 = (function(x7)
	return (x7 - 1)
end)
builtins1 = require1("tacky.analysis.resolve")["builtins"]
tokens1 = {tag = "list", n = 4, {tag = "list", n = 2, "arg", "(%f[%a]%u+%f[%A])"}, {tag = "list", n = 2, "mono", "```[a-z]*\n([^`]*)\n```"}, {tag = "list", n = 2, "mono", "`([^`]*)`"}, {tag = "list", n = 2, "link", "%[%[(.-)%]%]"}}
extractSignature1 = (function(var1)
	local ty2 = type1(var1)
	local temp1
	local r_921 = (ty2 == "macro")
	if r_921 then
		temp1 = r_921
	else
		temp1 = (ty2 == "defined")
	end
	if temp1 then
		local root1 = var1["node"]
		local node1 = nth1(root1, _23_1(root1))
		local temp2
		local r_941 = list_3f_1(node1)
		if r_941 then
			local r_951 = symbol_3f_1(car2(node1))
			if r_951 then
				temp2 = (car2(node1)["var"] == builtins1["lambda"])
			else
				temp2 = r_951
			end
		else
			temp2 = r_941
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
	local out2 = {tag = "list", n = 0}
	local pos1 = 1
	local len3 = len1(str1)
	local r_931 = nil
	r_931 = (function()
		if (pos1 <= len3) then
			local spos1 = len3
			local epos1 = nil
			local name1 = nil
			local ptrn1 = nil
			local r_1001 = _23_1(tokens1)
			local r_981 = nil
			r_981 = (function(r_991)
				if (r_991 <= r_1001) then
					local tok1 = tokens1[r_991]
					local npos1 = list1(find1(str1, nth1(tok1, 2), pos1))
					local temp3
					local r_1021 = car2(npos1)
					if r_1021 then
						temp3 = (car2(npos1) < spos1)
					else
						temp3 = r_1021
					end
					if temp3 then
						spos1 = car2(npos1)
						epos1 = nth1(npos1, 2)
						name1 = car2(tok1)
						ptrn1 = nth1(tok1, 2)
					else
					end
					return r_981((r_991 + 1))
				else
				end
			end)
			r_981(1)
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
			return r_931()
		else
		end
	end)
	r_931()
	return out2
end)
return struct1("parseDocs", parseDocstring1, "extractSignature", extractSignature1)
