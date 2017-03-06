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
for k, v in pairs(_temp) do _libs["lua/basic-0/".. k] = v end
local _3d_1, _3c3d_1, _2b_1, _25_1, error1, getIdx1, setIdx_21_1, type_23_1, _23_1, format1, concat1, emptyStruct1, _21_1, key_3f_1, type1, _2e2e_1, struct1, formatPosition1, formatRange1, formatNode1, getSource1
_3d_1 = function(v1, v2) return (v1 == v2) end
_3c3d_1 = function(v1, v2) return (v1 <= v2) end
_2b_1 = function(v1, v2) return (v1 + v2) end
_25_1 = function(v1, v2) return (v1 % v2) end
error1 = error
getIdx1 = function(v1, v2) return v1[v2] end
setIdx_21_1 = function(v1, v2, v3) v1[v2] = v3 end
type_23_1 = type
_23_1 = (function(x1)
	return x1["n"]
end)
format1 = string.format
concat1 = table.concat
emptyStruct1 = function() return {} end
_21_1 = (function(expr1)
	if expr1 then
		return false
	else
		return true
	end
end)
key_3f_1 = (function(x2)
	return (type1(x2) == "key")
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
_2e2e_1 = (function(...)
	local args1 = _pack(...) args1.tag = "list"
	return concat1(args1)
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
	local r_741 = _23_1(keys1)
	local r_721 = nil
	r_721 = (function(r_731)
		if (r_731 <= r_741) then
			local key2 = keys1[r_731]
			local val2 = keys1[(1 + r_731)]
			out1[(function()
				if key_3f_1(key2) then
					return contents1(key2)
				else
					return key2
				end
			end)()
			] = val2
			return r_721((r_731 + 2))
		else
		end
	end)
	r_721(1)
	return out1
end)
formatPosition1 = (function(pos1)
	return _2e2e_1(pos1["line"], ":", pos1["column"])
end)
formatRange1 = (function(range1)
	if range1["finish"] then
		return format1("%s:[%s .. %s]", range1["name"], formatPosition1(range1["start"]), formatPosition1(range1["finish"]))
	else
		return format1("%s:[%s]", range1["name"], formatPosition1(range1["start"]))
	end
end)
formatNode1 = (function(node1)
	local temp1
	local r_1441 = node1["range"]
	if r_1441 then
		temp1 = node1["contents"]
	else
		temp1 = r_1441
	end
	if temp1 then
		return format1("%s (%q)", formatRange1(node1["range"]), node1["contents"])
	elseif node1["range"] then
		return formatRange1(node1["range"])
	elseif node1["macro"] then
		local macro1 = node1["macro"]
		return format1("macro expansion of %s (%s)", macro1["var"]["name"], formatNode1(macro1["node"]))
	else
		local temp2
		local r_1471 = node1["start"]
		if r_1471 then
			temp2 = node1["finish"]
		else
			temp2 = r_1471
		end
		if temp2 then
			return formatRange1(node1)
		else
			return "?"
		end
	end
end)
getSource1 = (function(node2)
	local result1 = nil
	local r_1451 = nil
	r_1451 = (function()
		local temp3
		local r_1461 = node2
		if r_1461 then
			temp3 = _21_1(result1)
		else
			temp3 = r_1461
		end
		if temp3 then
			result1 = node2["range"]
			node2 = node2["parent"]
			return r_1451()
		else
		end
	end)
	r_1451()
	return result1
end)
return struct1("formatPosition", formatPosition1, "formatRange", formatRange1, "formatNode", formatNode1, "getSource", getSource1)
