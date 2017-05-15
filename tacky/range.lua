if not table.pack then table.pack = function(...) return { n = select("#", ...), ... } end end
if not table.unpack then table.unpack = unpack end
local load = load if _VERSION:find("5.1") then load = function(x, n, _, env) local f, e = loadstring(x, n) if not f then error(e, 2) end if env then setfenv(f, env) end return f end end
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
local _3c3d_1, _2b_1, getIdx1, setIdx_21_1, tostring1, char1, format1, gsub1, concat1, _2e2e_1, quoted1, formatPosition1, formatRange1, formatNode1, getSource1
_3c3d_1 = function(v1, v2) return (v1 <= v2) end
_2b_1 = function(v1, v2, ...) local t = (v1 + v2) for i = 1, _select('#', ...) do t = (t + _select(i, ...)) end return t end
getIdx1 = function(v1, v2) return v1[v2] end
setIdx_21_1 = function(v1, v2, v3) v1[v2] = v3 end
tostring1 = tostring
char1 = string.char
format1 = string.format
gsub1 = string.gsub
concat1 = table.concat
_2e2e_1 = (function(...)
	local args1 = _pack(...) args1.tag = "list"
	return concat1(args1)
end)
local escapes1 = ({})
local r_1031 = nil
r_1031 = (function(r_1041)
	if (r_1041 <= 31) then
		escapes1[char1(r_1041)] = _2e2e_1("\\", tostring1(r_1041))
		return r_1031((r_1041 + 1))
	else
		return nil
	end
end)
r_1031(0)
escapes1["\n"] = "n"
quoted1 = (function(str1)
	return (gsub1(format1("%q", str1), ".", escapes1))
end)
formatPosition1 = (function(pos1)
	return _2e2e_1(pos1["line"], ":", pos1["column"])
end)
formatRange1 = (function(range1)
	if range1["finish"] then
		return format1("%s:[%s .. %s]", range1["name"], (function(pos2)
			return _2e2e_1(pos2["line"], ":", pos2["column"])
		end)(range1["start"]), (function(pos3)
			return _2e2e_1(pos3["line"], ":", pos3["column"])
		end)(range1["finish"]))
	else
		return format1("%s:[%s]", range1["name"], (function(pos4)
			return _2e2e_1(pos4["line"], ":", pos4["column"])
		end)(range1["start"]))
	end
end)
formatNode1 = (function(node1)
	if (node1["range"] and node1["contents"]) then
		return format1("%s (%s)", formatRange1(node1["range"]), quoted1(node1["contents"]))
	elseif node1["range"] then
		return formatRange1(node1["range"])
	elseif node1["owner"] then
		local owner1 = node1["owner"]
		if owner1["var"] then
			return format1("macro expansion of %s (%s)", owner1["var"]["name"], formatNode1(owner1["node"]))
		else
			return format1("unquote expansion (%s)", formatNode1(owner1["node"]))
		end
	elseif (node1["start"] and node1["finish"]) then
		return formatRange1(node1)
	else
		return "?"
	end
end)
getSource1 = (function(node2)
	local result1 = nil
	local r_2561 = nil
	r_2561 = (function()
		if (node2 and not result1) then
			result1 = node2["range"]
			node2 = node2["parent"]
			return r_2561()
		else
			return nil
		end
	end)
	r_2561()
	return result1
end)
return ({["formatPosition"]=formatPosition1,["formatRange"]=formatRange1,["formatNode"]=formatNode1,["getSource"]=getSource1})
