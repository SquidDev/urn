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
local _3d_1, _3c_1, _3c3d_1, _3e_1, _2b_1, _2d_1, _25_1, error1, getIdx1, setIdx_21_1, tonumber1, type_23_1, _23_1, format1, gsub1, match1, concat1, emptyStruct1, iterPairs1, list1, list_3f_1, key_3f_1, type1, nth1, _2e2e_1, struct1, succ1, huge1, remapMessage1, remapTraceback1, generateMappings1
_3d_1 = function(v1, v2) return (v1 == v2) end
_3c_1 = function(v1, v2) return (v1 < v2) end
_3c3d_1 = function(v1, v2) return (v1 <= v2) end
_3e_1 = function(v1, v2) return (v1 > v2) end
_2b_1 = function(v1, v2) return (v1 + v2) end
_2d_1 = function(v1, v2) return (v1 - v2) end
_25_1 = function(v1, v2) return (v1 % v2) end
error1 = error
getIdx1 = function(v1, v2) return v1[v2] end
setIdx_21_1 = function(v1, v2, v3) v1[v2] = v3 end
tonumber1 = tonumber
type_23_1 = type
_23_1 = (function(x1)
	return x1["n"]
end)
format1 = string.format
gsub1 = string.gsub
match1 = string.match
concat1 = table.concat
emptyStruct1 = function() return {} end
iterPairs1 = function(x, f) for k, v in pairs(x) do f(k, v) end end
list1 = (function(...)
	local xs1 = _pack(...) xs1.tag = "list"
	return xs1
end)
list_3f_1 = (function(x2)
	return (type1(x2) == "list")
end)
key_3f_1 = (function(x3)
	return (type1(x3) == "key")
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
nth1 = (function(xs2, idx1)
	return xs2[idx1]
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
succ1 = (function(x4)
	return (x4 + 1)
end)
huge1 = math.huge
remapMessage1 = (function(mappings1, msg1)
	local r_1441 = list1(match1(msg1, "^(.-):(%d+)(.*)$"))
	local temp1
	local r_1461 = list_3f_1(r_1441)
	if r_1461 then
		local r_1471 = (_23_1(r_1441) == 3)
		if r_1471 then
			temp1 = true
		else
			temp1 = r_1471
		end
	else
		temp1 = r_1461
	end
	if temp1 then
		local file1 = nth1(r_1441, 1)
		local line1 = nth1(r_1441, 2)
		local extra1 = nth1(r_1441, 3)
		local mapping1 = mappings1[file1]
		if mapping1 then
			local range1 = mapping1[tonumber1(line1)]
			if range1 then
				return _2e2e_1(range1, " (", file1, ":", line1, ")", extra1)
			else
				return msg1
			end
		else
			return msg1
		end
	else
		return msg1
	end
end)
remapTraceback1 = (function(mappings2, msg2)
	local r_1521
	local r_1511
	r_1511 = gsub1(msg2, "^([^\n:]-:%d+:)", (function(r_1531)
		return remapMessage1(mappings2, r_1531)
	end))
	r_1521 = gsub1(r_1511, "\9([^\n:]-:%d+:)", (function(msg3)
		return _2e2e_1("\9", remapMessage1(mappings2, msg3))
	end))
	return gsub1(r_1521, "<([^\n:]-:%d+)>", (function(msg4)
		return _2e2e_1("<", remapMessage1(mappings2, msg4), ">")
	end))
end)
generateMappings1 = (function(lines1)
	local outLines1 = {}
	iterPairs1(lines1, (function(line2, ranges1)
		local rangeLists1 = {}
		iterPairs1(ranges1, (function(pos1)
			local file2 = pos1["name"]
			local rangeList1 = rangeLists1["file"]
			if rangeList1 then
			else
				rangeList1 = struct1("n", 0, "min", huge1, "max", (0 - huge1))
				rangeLists1[file2] = rangeList1
			end
			local r_1561 = pos1["finish"]["line"]
			local r_1541 = nil
			r_1541 = (function(r_1551)
				if (r_1551 <= r_1561) then
					if rangeList1[r_1551] then
					else
						rangeList1["n"] = succ1(rangeList1["n"])
						rangeList1[r_1551] = true
						if (r_1551 < rangeList1["min"]) then
							rangeList1["min"] = r_1551
						else
						end
						if (r_1551 > rangeList1["max"]) then
							rangeList1["max"] = r_1551
						else
						end
					end
					return r_1541((r_1551 + 1))
				else
				end
			end)
			return r_1541(pos1["start"]["line"])
		end))
		local bestName1 = nil
		local bestLines1 = nil
		local bestCount1 = 0
		iterPairs1(rangeLists1, (function(name1, lines2)
			if (lines2["n"] > bestCount1) then
				bestName1 = name1
				bestLines1 = lines2
				bestCount1 = lines2["n"]
				return nil
			else
			end
		end))
		outLines1[line2] = (function()
			if (bestLines1["min"] == bestLines1["max"]) then
				return format1("%s:%d", bestName1, bestLines1["min"])
			else
				return format1("%s:%d-%d", bestName1, bestLines1["min"], bestLines1["max"])
			end
		end)()
		return nil
	end))
	return outLines1
end)
return struct1("remapMessage", remapMessage1, "remapTraceback", remapTraceback1, "generate", generateMappings1)
