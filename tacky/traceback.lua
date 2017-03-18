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
local _3d_1, _2f3d_1, _3c_1, _3c3d_1, _3e3d_1, _2b_1, _25_1, error1, getIdx1, setIdx_21_1, tonumber1, type_23_1, char1, find1, format1, gsub1, len1, lower1, match1, sub1, concat1, emptyStruct1, list1, between_3f_1, type1, pushCdr_21_1, _2e2e_1, struct1, unmangleIdent1, remapError1, remapMessage1, remapTraceback1
_3d_1 = function(v1, v2) return (v1 == v2) end
_2f3d_1 = function(v1, v2) return (v1 ~= v2) end
_3c_1 = function(v1, v2) return (v1 < v2) end
_3c3d_1 = function(v1, v2) return (v1 <= v2) end
_3e3d_1 = function(v1, v2) return (v1 >= v2) end
_2b_1 = function(v1, v2) return (v1 + v2) end
_25_1 = function(v1, v2) return (v1 % v2) end
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
emptyStruct1 = function() return ({}) end
list1 = (function(...)
	local xs1 = _pack(...) xs1.tag = "list"
	return xs1
end)
between_3f_1 = (function(val1, min1, max1)
	local r_271 = (val1 >= min1)
	return r_271 and (val1 <= max1)
end)
type1 = (function(val2)
	local ty1 = type_23_1(val2)
	if (ty1 == "table") then
		local tag1 = val2["tag"]
		return tag1 or "table"
	else
		return ty1
	end
end)
pushCdr_21_1 = (function(xs2, val3)
	local r_841 = type1(xs2)
	if (r_841 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_841), 2)
	else
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
struct1 = (function(...)
	local entries1 = _pack(...) entries1.tag = "list"
	if ((entries1["n"] % 1) == 1) then
		error1("Expected an even number of arguments to struct", 2)
	else
	end
	local out1 = ({})
	local r_1071 = entries1["n"]
	local r_1051 = nil
	r_1051 = (function(r_1061)
		if (r_1061 <= r_1071) then
			local key1 = entries1[r_1061]
			local val4 = entries1[(1 + r_1061)]
			out1[(function()
				if (type1(key1) == "key") then
					return key1["contents"]
				else
					return key1
				end
			end)()
			] = val4
			return r_1051((r_1061 + 2))
		else
		end
	end)
	r_1051(1)
	return out1
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
		local r_2091 = nil
		r_2091 = (function()
			if (pos1 <= len3) then
				local char2
				local x1 = pos1
				char2 = sub1(esc1, x1, x1)
				if (char2 == "_") then
					local r_2141 = list1(find1(esc1, "^_[%da-z]+_", pos1))
					local temp1
					local r_2161 = (type1(r_2141) == "list")
					if r_2161 then
						local r_2171 = (r_2141["n"] >= 2)
						if r_2171 then
							local r_2181 = (r_2141["n"] <= 2)
							temp1 = r_2181 and true
						else
							temp1 = r_2171
						end
					else
						temp1 = r_2161
					end
					if temp1 then
						local start1 = r_2141[1]
						local _eend1 = r_2141[2]
						local x2 = pos1
						pos1 = (x2 + 1)
						local r_2391 = nil
						r_2391 = (function()
							if (pos1 < _eend1) then
								pushCdr_21_1(buffer1, char1(tonumber1(sub1(esc1, pos1, (function(x3)
									return (x3 + 1)
								end)(pos1)), 16)))
								pos1 = (pos1 + 2)
								return r_2391()
							else
							end
						end)
						r_2391()
					else
						pushCdr_21_1(buffer1, "_")
					end
				elseif between_3f_1(char2, "A", "Z") then
					pushCdr_21_1(buffer1, "-")
					pushCdr_21_1(buffer1, lower1(char2))
				else
					pushCdr_21_1(buffer1, char2)
				end
				local x4 = pos1
				pos1 = (x4 + 1)
				return r_2091()
			else
			end
		end)
		r_2091()
		return concat1(buffer1)
	end
end)
remapError1 = (function(msg1)
	local res1
	local r_2231
	local r_2221
	local r_2211 = gsub1(msg1, "local '([^']+)'", (function(x5)
		return _2e2e_1("local '", unmangleIdent1(x5), "'")
	end))
	r_2221 = gsub1(r_2211, "global '([^']+)'", (function(x6)
		return _2e2e_1("global '", unmangleIdent1(x6), "'")
	end))
	r_2231 = gsub1(r_2221, "upvalue '([^']+)'", (function(x7)
		return _2e2e_1("upvalue '", unmangleIdent1(x7), "'")
	end))
	res1 = gsub1(r_2231, "function '([^']+)'", (function(x8)
		return _2e2e_1("function '", unmangleIdent1(x8), "'")
	end))
	return res1
end)
remapMessage1 = (function(mappings1, msg2)
	local r_2241 = list1(match1(msg2, "^(.-):(%d+)(.*)$"))
	local temp2
	local r_2261 = (type1(r_2241) == "list")
	if r_2261 then
		local r_2271 = (r_2241["n"] >= 3)
		if r_2271 then
			local r_2281 = (r_2241["n"] <= 3)
			temp2 = r_2281 and true
		else
			temp2 = r_2271
		end
	else
		temp2 = r_2261
	end
	if temp2 then
		local file1 = r_2241[1]
		local line1 = r_2241[2]
		local extra1 = r_2241[3]
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
	local r_2371
	local r_2361
	local r_2351
	local r_2341
	local r_2331
	local r_2321 = gsub1(msg3, "^([^\n:]-:%d+:[^\n]*)", (function(r_2381)
		return remapMessage1(mappings2, r_2381)
	end))
	r_2331 = gsub1(r_2321, "\9([^\n:]-:%d+:)", (function(msg4)
		return _2e2e_1("\9", remapMessage1(mappings2, msg4))
	end))
	r_2341 = gsub1(r_2331, "<([^\n:]-:%d+)>\n", (function(msg5)
		return _2e2e_1("<", remapMessage1(mappings2, msg5), ">\n")
	end))
	r_2351 = gsub1(r_2341, "in local '([^']+)'\n", (function(x9)
		return _2e2e_1("in local '", unmangleIdent1(x9), "'\n")
	end))
	r_2361 = gsub1(r_2351, "in global '([^']+)'\n", (function(x10)
		return _2e2e_1("in global '", unmangleIdent1(x10), "'\n")
	end))
	r_2371 = gsub1(r_2361, "in upvalue '([^']+)'\n", (function(x11)
		return _2e2e_1("in upvalue '", unmangleIdent1(x11), "'\n")
	end))
	return gsub1(r_2371, "in function '([^']+)'\n", (function(x12)
		return _2e2e_1("in function '", unmangleIdent1(x12), "'\n")
	end))
end)
return struct1("remapTraceback", remapTraceback1)
