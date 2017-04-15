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
local getIdx1, format1, concat1, _2e2e_1, formatPosition1, formatRange1, formatNode1, getSource1
getIdx1 = function(v1, v2) return v1[v2] end
format1 = string.format
concat1 = table.concat
_2e2e_1 = (function(...)
	local args1 = _pack(...) args1.tag = "list"
	return concat1(args1)
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
		return format1("%s (%q)", formatRange1(node1["range"]), node1["contents"])
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
	local r_2171 = nil
	r_2171 = (function()
		if (node2 and not result1) then
			result1 = node2["range"]
			node2 = node2["parent"]
			return r_2171()
		else
		end
	end)
	r_2171()
	return result1
end)
return ({["formatPosition"]=formatPosition1,["formatRange"]=formatRange1,["formatNode"]=formatNode1,["getSource"]=getSource1})
