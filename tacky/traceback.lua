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
local _3d_1, _2f3d_1, _3c_1, _3c3d_1, _3e3d_1, _2b_1, error1, getIdx1, setIdx_21_1, tonumber1, type_23_1, char1, find1, format1, gsub1, len1, lower1, match1, sub1, concat1, list1, between_3f_1, type1, pushCdr_21_1, _2e2e_1, unmangleIdent1, remapError1, remapMessage1, remapTraceback1
_3d_1 = function(v1, v2) return (v1 == v2) end
_2f3d_1 = function(v1, v2) return (v1 ~= v2) end
_3c_1 = function(v1, v2) return (v1 < v2) end
_3c3d_1 = function(v1, v2) return (v1 <= v2) end
_3e3d_1 = function(v1, v2) return (v1 >= v2) end
_2b_1 = function(v1, v2) return (v1 + v2) end
error1 = error
getIdx1 = function(v1, v2) return v1[v2] end
setIdx_21_1 = function(v1, v2, v3) v1[v2] = v3 end
tonumber1 = tonumber
type_23_1 = type
char1 = string.char
find1 = string.find
format1 = string.format
gsub1 = string.gsub
len1 = string.len
lower1 = string.lower
match1 = string.match
sub1 = string.sub
concat1 = table.concat
list1 = (function(...)
	local xs1 = _pack(...) xs1.tag = "list"
	return xs1
end)
between_3f_1 = (function(val1, min1, max1)
	return ((val1 >= min1) and (val1 <= max1))
end)
type1 = (function(val2)
	local ty1 = type_23_1(val2)
	if (ty1 == "table") then
		return (val2["tag"] or "table")
	else
		return ty1
	end
end)
pushCdr_21_1 = (function(xs2, val3)
	local r_791 = type1(xs2)
	if (r_791 ~= "list") then
		error1(format1("bad argument %s (expected %s, got %s)", "xs", "list", r_791), 2)
	end
	local len2 = (xs2["n"] + 1)
	xs2["n"] = len2
	xs2[len2] = val3
	return xs2
end)
_2e2e_1 = (function(...)
	local args1 = _pack(...) args1.tag = "list"
	return concat1(args1)
end)
unmangleIdent1 = (function(ident1)
	local esc1 = match1(ident1, "^(.-)%d+$")
	if (esc1 == nil) then
		return ident1
	elseif (sub1(esc1, 1, 2) == "_e") then
		return sub1(ident1, 3)
	else
		local buffer1 = ({tag = "list", n = 0})
		local pos1 = 0
		local len3 = len1(esc1)
		local r_2151 = nil
		r_2151 = (function()
			if (pos1 <= len3) then
				local char2
				local x1 = pos1
				char2 = sub1(esc1, x1, x1)
				if (char2 == "_") then
					local r_2201 = list1(find1(esc1, "^_[%da-z]+_", pos1))
					if ((type1(r_2201) == "list") and ((r_2201["n"] >= 2) and ((r_2201["n"] <= 2) and true))) then
						local start1 = r_2201[1]
						local _eend1 = r_2201[2]
						pos1 = (pos1 + 1)
						local r_2451 = nil
						r_2451 = (function()
							if (pos1 < _eend1) then
								pushCdr_21_1(buffer1, char1(tonumber1(sub1(esc1, pos1, (pos1 + 1)), 16)))
								pos1 = (pos1 + 2)
								return r_2451()
							else
							end
						end)
						r_2451()
					else
						pushCdr_21_1(buffer1, "_")
					end
				elseif between_3f_1(char2, "A", "Z") then
					pushCdr_21_1(buffer1, "-")
					pushCdr_21_1(buffer1, lower1(char2))
				else
					pushCdr_21_1(buffer1, char2)
				end
				pos1 = (pos1 + 1)
				return r_2151()
			else
			end
		end)
		r_2151()
		return concat1(buffer1)
	end
end)
remapError1 = (function(msg1)
	return (gsub1(gsub1(gsub1(gsub1(msg1, "local '([^']+)'", (function(x2)
		return _2e2e_1("local '", unmangleIdent1(x2), "'")
	end)), "global '([^']+)'", (function(x3)
		return _2e2e_1("global '", unmangleIdent1(x3), "'")
	end)), "upvalue '([^']+)'", (function(x4)
		return _2e2e_1("upvalue '", unmangleIdent1(x4), "'")
	end)), "function '([^']+)'", (function(x5)
		return _2e2e_1("function '", unmangleIdent1(x5), "'")
	end)))
end)
remapMessage1 = (function(mappings1, msg2)
	local r_2301 = list1(match1(msg2, "^(.-):(%d+)(.*)$"))
	if ((type1(r_2301) == "list") and ((r_2301["n"] >= 3) and ((r_2301["n"] <= 3) and true))) then
		local file1 = r_2301[1]
		local line1 = r_2301[2]
		local extra1 = r_2301[3]
		local mapping1 = mappings1[file1]
		if mapping1 then
			local range1 = mapping1[tonumber1(line1)]
			if range1 then
				return _2e2e_1(range1, " (", file1, ":", line1, ")", remapError1(extra1))
			else
				return msg2
			end
		else
			return msg2
		end
	else
		return msg2
	end
end)
remapTraceback1 = (function(mappings2, msg3)
	return gsub1(gsub1(gsub1(gsub1(gsub1(gsub1(gsub1(msg3, "^([^\n:]-:%d+:[^\n]*)", (function(r_2441)
		return remapMessage1(mappings2, r_2441)
	end)), "\9([^\n:]-:%d+:)", (function(msg4)
		return _2e2e_1("\9", remapMessage1(mappings2, msg4))
	end)), "<([^\n:]-:%d+)>\n", (function(msg5)
		return _2e2e_1("<", remapMessage1(mappings2, msg5), ">\n")
	end)), "in local '([^']+)'\n", (function(x6)
		return _2e2e_1("in local '", unmangleIdent1(x6), "'\n")
	end)), "in global '([^']+)'\n", (function(x7)
		return _2e2e_1("in global '", unmangleIdent1(x7), "'\n")
	end)), "in upvalue '([^']+)'\n", (function(x8)
		return _2e2e_1("in upvalue '", unmangleIdent1(x8), "'\n")
	end)), "in function '([^']+)'\n", (function(x9)
		return _2e2e_1("in function '", unmangleIdent1(x9), "'\n")
	end))
end)
return ({["remapTraceback"]=remapTraceback1})
