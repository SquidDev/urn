#!/usr/bin/env lua5.3
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
local _temp = (function()
	-- A horrible hacky script to ensure that package.path is correct
	local directory = arg[0]:gsub("urn/cli%.lisp", ""):gsub("urn/cli$", ""):gsub("tacky/cli%.lua$", "")
	if directory ~= "" and directory:sub(-1, -1) ~= "/" then
		directory = directory .. "/"
	end
	package.path = package.path .. package.config:sub(3, 3) .. directory .. "?.lua"
	return {}
end)()
for k, v in pairs(_temp) do _libs["urn/cli-15/".. k] = v end
_3d_1 = function(v1, v2) return (v1 == v2) end
_2f3d_1 = function(v1, v2) return (v1 ~= v2) end
_3c_1 = function(v1, v2) return (v1 < v2) end
_3c3d_1 = function(v1, v2) return (v1 <= v2) end
_3e_1 = function(v1, v2) return (v1 > v2) end
_3e3d_1 = function(v1, v2) return (v1 >= v2) end
_2b_1 = function(v1, v2) return (v1 + v2) end
_2d_1 = function(v1, v2) return (v1 - v2) end
_2a_1 = function(v1, v2) return (v1 * v2) end
_2f_1 = function(v1, v2) return (v1 / v2) end
_25_1 = function(v1, v2) return (v1 % v2) end
_2e2e_1 = function(v1, v2) return (v1 .. v2) end
_5f_G1 = _G
arg_23_1 = arg
len_23_1 = function(v1) return #(v1) end
slice1 = _libs["lua/basic-0/slice"]
error1 = error
getmetatable1 = getmetatable
load1 = load
pcall1 = pcall
print1 = print
getIdx1 = function(v1, v2) return v1[v2] end
setIdx_21_1 = function(v1, v2, v3) v1[v2] = v3 end
require1 = require
setmetatable1 = setmetatable
tonumber1 = tonumber
tostring1 = tostring
type_23_1 = type
xpcall1 = xpcall
byte1 = string.byte
char1 = string.char
find1 = string.find
format1 = string.format
gsub1 = string.gsub
len1 = string.len
lower1 = string.lower
match1 = string.match
rep1 = string.rep
sub1 = string.sub
upper1 = string.upper
concat1 = table.concat
remove1 = table.remove
sort1 = table.sort
unpack1 = table.unpack
emptyStruct1 = function() return ({}) end
iterPairs1 = function(x, f) for k, v in pairs(x) do f(k, v) end end
list1 = (function(...)
	local xs1 = _pack(...) xs1.tag = "list"
	return xs1
end)
_2d_or1 = (function(a1, b1)
	return a1 or b1
end)
_2d_and1 = (function(a2, b2)
	return a2 and b2
end)
pretty1 = (function(value1)
	local ty1 = type_23_1(value1)
	if (ty1 == "table") then
		local tag1 = value1["tag"]
		if (tag1 == "list") then
			local out1 = ({tag = "list", n = 0})
			local r_51 = value1["n"]
			local r_31 = nil
			r_31 = (function(r_41)
				if (r_41 <= r_51) then
					out1[r_41] = pretty1(value1[r_41])
					return r_31((r_41 + 1))
				else
				end
			end)
			r_31(1)
			return ("(" .. (concat1(out1, " ") .. ")"))
		else
			local temp1
			local r_71 = (type_23_1(getmetatable1(value1)) == "table")
			temp1 = r_71 and (type_23_1(getmetatable1(value1)["--pretty-print"]) == "function")
			if temp1 then
				return getmetatable1(value1)["--pretty-print"](value1)
			elseif (tag1 == "list") then
				return value1["contents"]
			elseif (tag1 == "symbol") then
				return value1["contents"]
			elseif (tag1 == "key") then
				return (":" .. value1["value"])
			elseif (tag1 == "string") then
				return format1("%q", value1["value"])
			elseif (tag1 == "number") then
				return tostring1(value1["value"])
			else
				return tostring1(value1)
			end
		end
	elseif (ty1 == "string") then
		return format1("%q", value1)
	else
		return tostring1(value1)
	end
end)
if (nil == arg_23_1) then
	arg1 = ({tag = "list", n = 0})
else
	arg_23_1["tag"] = "list"
	if arg_23_1["n"] then
	else
		arg_23_1["n"] = #(arg_23_1)
	end
	arg1 = arg_23_1
end
constVal1 = (function(val1)
	if (type_23_1(val1) == "table") then
		local tag2 = val1["tag"]
		if (tag2 == "number") then
			return val1["value"]
		elseif (tag2 == "string") then
			return val1["value"]
		else
			return val1
		end
	else
		return val1
	end
end)
nil_3f_1 = (function(x1)
	if x1 then
		local r_161 = (type1(x1) == "list")
		return r_161 and (x1["n"] == 0)
	else
		return x1
	end
end)
string_3f_1 = (function(x2)
	local r_171 = (type_23_1(x2) == "string")
	if r_171 then
		return r_171
	else
		local r_181 = (type_23_1(x2) == "table")
		return r_181 and (x2["tag"] == "string")
	end
end)
number_3f_1 = (function(x3)
	local r_191 = (type_23_1(x3) == "number")
	if r_191 then
		return r_191
	else
		local r_201 = (type_23_1(x3) == "table")
		return r_201 and (x3["tag"] == "number")
	end
end)
atom_3f_1 = (function(x4)
	local r_231 = (type_23_1(x4) ~= "table")
	if r_231 then
		return r_231
	else
		local r_241 = (type_23_1(x4) == "table")
		if r_241 then
			local r_251 = (x4["tag"] == "symbol")
			return r_251 or (x4["tag"] == "key")
		else
			return r_241
		end
	end
end)
between_3f_1 = (function(val2, min1, max1)
	local r_261 = (val2 >= min1)
	return r_261 and (val2 <= max1)
end)
type1 = (function(val3)
	local ty2 = type_23_1(val3)
	if (ty2 == "table") then
		local tag3 = val3["tag"]
		return tag3 or "table"
	else
		return ty2
	end
end)
eq_3f_1 = (function(x5, y1)
	if (x5 == y1) then
		return true
	else
		local typeX1 = type1(x5)
		local typeY1 = type1(y1)
		local temp2
		local r_271 = (typeX1 == "list")
		if r_271 then
			local r_281 = (typeY1 == "list")
			temp2 = r_281 and (x5["n"] == y1["n"])
		else
			temp2 = r_271
		end
		if temp2 then
			local equal1 = true
			local r_311 = x5["n"]
			local r_291 = nil
			r_291 = (function(r_301)
				if (r_301 <= r_311) then
					local temp3
					local x6 = x5[r_301]
					local y2 = y1[r_301]
					local expr1 = eq_3f_1(x6, y2)
					temp3 = not expr1
					if temp3 then
						equal1 = false
					else
					end
					return r_291((r_301 + 1))
				else
				end
			end)
			r_291(1)
			return equal1
		else
			local temp4
			local r_331 = ("symbol" == typeX1)
			temp4 = r_331 and ("symbol" == typeY1)
			if temp4 then
				return (x5["contents"] == y1["contents"])
			else
				local temp5
				local r_341 = ("key" == typeX1)
				temp5 = r_341 and ("key" == typeY1)
				if temp5 then
					return (x5["value"] == y1["value"])
				else
					local temp6
					local r_351 = ("symbol" == typeX1)
					temp6 = r_351 and ("string" == typeY1)
					if temp6 then
						return (x5["contents"] == y1)
					else
						local temp7
						local r_361 = ("string" == typeX1)
						temp7 = r_361 and ("symbol" == typeY1)
						if temp7 then
							return (x5 == y1["contents"])
						else
							local temp8
							local r_371 = ("key" == typeX1)
							temp8 = r_371 and ("string" == typeY1)
							if temp8 then
								return (x5["value"] == y1)
							else
								local temp9
								local r_381 = ("string" == typeX1)
								temp9 = r_381 and ("key" == typeY1)
								if temp9 then
									return (x5 == y1["value"])
								else
									return false
								end
							end
						end
					end
				end
			end
		end
	end
end)
abs1 = math.abs
huge1 = math.huge
max2 = math.max
modf1 = math.modf
car1 = (function(x7)
	local r_551 = type1(x7)
	if (r_551 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_551), 2)
	else
	end
	return x7[1]
end)
cdr1 = (function(x8)
	local r_561 = type1(x8)
	if (r_561 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_561), 2)
	else
	end
	if nil_3f_1(x8) then
		return ({tag = "list", n = 0})
	else
		return slice1(x8, 2)
	end
end)
foldr1 = (function(f1, z1, xs2)
	local r_571 = type1(f1)
	if (r_571 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "f", "function", r_571), 2)
	else
	end
	local r_581 = type1(xs2)
	if (r_581 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_581), 2)
	else
	end
	local accum1 = z1
	local r_611 = xs2["n"]
	local r_591 = nil
	r_591 = (function(r_601)
		if (r_601 <= r_611) then
			accum1 = f1(accum1, xs2[r_601])
			return r_591((r_601 + 1))
		else
		end
	end)
	r_591(1)
	return accum1
end)
map1 = (function(f2, xs3)
	local r_631 = type1(f2)
	if (r_631 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "f", "function", r_631), 2)
	else
	end
	local r_641 = type1(xs3)
	if (r_641 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_641), 2)
	else
	end
	local out2 = ({tag = "list", n = 0})
	local r_671 = xs3["n"]
	local r_651 = nil
	r_651 = (function(r_661)
		if (r_661 <= r_671) then
			pushCdr_21_1(out2, f2(xs3[r_661]))
			return r_651((r_661 + 1))
		else
		end
	end)
	r_651(1)
	return out2
end)
any1 = (function(p1, xs4)
	local r_751 = type1(p1)
	if (r_751 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "p", "function", r_751), 2)
	else
	end
	local r_761 = type1(xs4)
	if (r_761 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_761), 2)
	else
	end
	return accumulateWith1(p1, _2d_or1, false, xs4)
end)
all1 = (function(p2, xs5)
	local r_771 = type1(p2)
	if (r_771 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "p", "function", r_771), 2)
	else
	end
	local r_781 = type1(xs5)
	if (r_781 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_781), 2)
	else
	end
	return accumulateWith1(p2, _2d_and1, true, xs5)
end)
last1 = (function(xs6)
	local r_811 = type1(xs6)
	if (r_811 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_811), 2)
	else
	end
	return xs6[xs6["n"]]
end)
pushCdr_21_1 = (function(xs7, val4)
	local r_821 = type1(xs7)
	if (r_821 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_821), 2)
	else
	end
	local len2 = (xs7["n"] + 1)
	xs7["n"] = len2
	xs7[len2] = val4
	return xs7
end)
popLast_21_1 = (function(xs8)
	local r_831 = type1(xs8)
	if (r_831 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_831), 2)
	else
	end
	local x9 = xs8[xs8["n"]]
	xs8[xs8["n"]] = nil
	xs8["n"] = (xs8["n"] - 1)
	return x9
end)
removeNth_21_1 = (function(li1, idx1)
	local r_841 = type1(li1)
	if (r_841 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_841), 2)
	else
	end
	li1["n"] = (li1["n"] - 1)
	return remove1(li1, idx1)
end)
append1 = (function(xs9, ys1)
	return (function()
		local _offset, _result, _temp = 0, {tag="list",n=0}
		_temp = xs9
		for _c = 1, _temp.n do _result[0 + _c + _offset] = _temp[_c] end
		_offset = _offset + _temp.n
		_temp = ys1
		for _c = 1, _temp.n do _result[0 + _c + _offset] = _temp[_c] end
		_offset = _offset + _temp.n
		_result.n = _offset + 0
		return _result
	end)()
end)
accumulateWith1 = (function(f3, ac1, z2, xs10)
	local r_861 = type1(f3)
	if (r_861 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "f", "function", r_861), 2)
	else
	end
	local r_871 = type1(ac1)
	if (r_871 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "ac", "function", r_871), 2)
	else
	end
	return foldr1(ac1, z2, map1(f3, xs10))
end)
_2e2e_2 = (function(...)
	local args1 = _pack(...) args1.tag = "list"
	return concat1(args1)
end)
split1 = (function(text1, pattern1, limit1)
	local out3 = ({tag = "list", n = 0})
	local loop1 = true
	local start1 = 1
	local r_941 = nil
	r_941 = (function()
		if loop1 then
			local pos1 = list1(find1(text1, pattern1, start1))
			local nstart1 = car1(pos1)
			local nend1 = car1(cdr1(pos1))
			local temp10
			local r_951 = (nstart1 == nil)
			temp10 = r_951 or limit1 and (out3["n"] >= limit1)
			if temp10 then
				loop1 = false
				pushCdr_21_1(out3, sub1(text1, start1, len1(text1)))
				start1 = (len1(text1) + 1)
			elseif (nstart1 > len1(text1)) then
				if (start1 <= len1(text1)) then
					pushCdr_21_1(out3, sub1(text1, start1, len1(text1)))
				else
				end
				loop1 = false
			elseif (nend1 < nstart1) then
				pushCdr_21_1(out3, sub1(text1, start1, nstart1))
				start1 = (nstart1 + 1)
			else
				pushCdr_21_1(out3, sub1(text1, start1, (nstart1 - 1)))
				start1 = (nend1 + 1)
			end
			return r_941()
		else
		end
	end)
	r_941()
	return out3
end)
local escapes1 = ({})
local r_901 = nil
r_901 = (function(r_911)
	if (r_911 <= 31) then
		escapes1[char1(r_911)] = _2e2e_2("\\", tostring1(r_911))
		return r_901((r_911 + 1))
	else
	end
end)
r_901(0)
escapes1["\n"] = "n"
quoted1 = (function(str1)
	local result1 = gsub1(format1("%q", str1), ".", escapes1)
	return result1
end)
clock1 = os.clock
execute1 = os.execute
exit1 = os.exit
getenv1 = os.getenv
struct1 = (function(...)
	local entries1 = _pack(...) entries1.tag = "list"
	if ((entries1["n"] % 1) == 1) then
		error1("Expected an even number of arguments to struct", 2)
	else
	end
	local out4 = ({})
	local r_1051 = entries1["n"]
	local r_1031 = nil
	r_1031 = (function(r_1041)
		if (r_1041 <= r_1051) then
			local key1 = entries1[r_1041]
			local val5 = entries1[(1 + r_1041)]
			out4[(function()
				if (type1(key1) == "key") then
					return key1["contents"]
				else
					return key1
				end
			end)()
			] = val5
			return r_1031((r_1041 + 2))
		else
		end
	end)
	r_1031(1)
	return out4
end)
values1 = (function(st1)
	local out5 = ({tag = "list", n = 0})
	iterPairs1(st1, (function(_5f_1, v1)
		return pushCdr_21_1(out5, v1)
	end))
	return out5
end)
flush1 = io.flush
open1 = io.open
read1 = io.read
write1 = io.write
symbol_2d3e_string1 = (function(x10)
	if (type1(x10) == "symbol") then
		return x10["contents"]
	else
		return nil
	end
end)
exit_21_1 = (function(reason1, code1)
	local code2
	if string_3f_1(reason1) then
		code2 = code1
	else
		code2 = reason1
	end
	if string_3f_1(reason1) then
		print1(reason1)
	else
	end
	return exit1(code2)
end)
id1 = (function(x11)
	return x11
end)
self1 = (function(x12, key2, ...)
	local args2 = _pack(...) args2.tag = "list"
	return x12[key2](x12, unpack1(args2, 1, args2["n"]))
end)
create1 = (function(description1)
	return struct1("desc", description1, "flag-map", ({}), "opt-map", ({}), "opt", ({tag = "list", n = 0}), "pos", ({tag = "list", n = 0}))
end)
setAction1 = (function(arg2, data1, value2)
	data1[arg2["name"]] = value2
	return nil
end)
addAction1 = (function(arg3, data2, value3)
	local lst1 = data2[arg3["name"]]
	if lst1 then
	else
		lst1 = ({tag = "list", n = 0})
		data2[arg3["name"]] = lst1
	end
	return pushCdr_21_1(lst1, value3)
end)
setNumAction1 = (function(aspec1, data3, value4, usage_21_1)
	local val6 = tonumber1(value4)
	if val6 then
		data3[aspec1["name"]] = val6
		return nil
	else
		return usage_21_1(_2e2e_2("Expected number for ", car1(arg1["names"]), ", got ", value4))
	end
end)
addArgument_21_1 = (function(spec1, names1, ...)
	local options1 = _pack(...) options1.tag = "list"
	local r_1961 = type1(names1)
	if (r_1961 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "names", "list", r_1961), 2)
	else
	end
	if nil_3f_1(names1) then
		error1("Names list is empty")
	else
	end
	if ((options1["n"] % 2) == 0) then
	else
		error1("Options list should be a multiple of two")
	end
	local result2 = struct1("names", names1, "action", nil, "narg", 0, "default", false, "help", "", "value", true)
	local first1 = car1(names1)
	if (sub1(first1, 1, 2) == "--") then
		pushCdr_21_1(spec1["opt"], result2)
		result2["name"] = sub1(first1, 3)
	elseif (sub1(first1, 1, 1) == "-") then
		pushCdr_21_1(spec1["opt"], result2)
		result2["name"] = sub1(first1, 2)
	else
		result2["name"] = first1
		result2["narg"] = "*"
		result2["default"] = ({tag = "list", n = 0})
		pushCdr_21_1(spec1["pos"], result2)
	end
	local r_2011 = names1["n"]
	local r_1991 = nil
	r_1991 = (function(r_2001)
		if (r_2001 <= r_2011) then
			local name1 = names1[r_2001]
			if (sub1(name1, 1, 2) == "--") then
				spec1["opt-map"][sub1(name1, 3)] = result2
			elseif (sub1(name1, 1, 1) == "-") then
				spec1["flag-map"][sub1(name1, 2)] = result2
			else
			end
			return r_1991((r_2001 + 1))
		else
		end
	end)
	r_1991(1)
	local r_2051 = options1["n"]
	local r_2031 = nil
	r_2031 = (function(r_2041)
		if (r_2041 <= r_2051) then
			local key3 = options1[r_2041]
			local val7
			local idx2 = (r_2041 + 1)
			val7 = options1[idx2]
			result2[key3] = val7
			return r_2031((r_2041 + 2))
		else
		end
	end)
	r_2031(1)
	if result2["var"] then
	else
		result2["var"] = upper1(result2["name"])
	end
	if result2["action"] then
	else
		result2["action"] = (function()
			local temp11
			if number_3f_1(result2["narg"]) then
				temp11 = (result2["narg"] <= 1)
			else
				temp11 = (result2["narg"] == "?")
			end
			if temp11 then
				return setAction1
			else
				return addAction1
			end
		end)()
	end
	return result2
end)
addHelp_21_1 = (function(spec2)
	return addArgument_21_1(spec2, ({tag = "list", n = 2, "--help", "-h"}), "help", "Show this help message", "default", nil, "value", nil, "action", (function(arg4, result3, value5)
		help_21_1(spec2)
		return exit_21_1(0)
	end))
end)
helpNarg_21_1 = (function(buffer1, arg5)
	local r_2481 = arg5["narg"]
	if (r_2481 == "?") then
		return pushCdr_21_1(buffer1, _2e2e_2(" [", arg5["var"], "]"))
	elseif (r_2481 == "*") then
		return pushCdr_21_1(buffer1, _2e2e_2(" [", arg5["var"], "...]"))
	elseif (r_2481 == "+") then
		return pushCdr_21_1(buffer1, _2e2e_2(" ", arg5["var"], " [", arg5["var"], "...]"))
	else
		local r_2491 = nil
		r_2491 = (function(r_2501)
			if (r_2501 <= r_2481) then
				pushCdr_21_1(buffer1, _2e2e_2(" ", arg5["var"]))
				return r_2491((r_2501 + 1))
			else
			end
		end)
		return r_2491(1)
	end
end)
usage_21_2 = (function(spec3, name2)
	if name2 then
	else
		local r_2071 = arg1[0]
		if r_2071 then
			name2 = r_2071
		else
			local r_2081 = arg1[-1]
			name2 = r_2081 or "?"
		end
	end
	local usage1 = list1("usage: ", name2)
	local r_2101 = spec3["opt"]
	local r_2131 = r_2101["n"]
	local r_2111 = nil
	r_2111 = (function(r_2121)
		if (r_2121 <= r_2131) then
			local arg6 = r_2101[r_2121]
			pushCdr_21_1(usage1, _2e2e_2(" [", car1(arg6["names"])))
			helpNarg_21_1(usage1, arg6)
			pushCdr_21_1(usage1, "]")
			return r_2111((r_2121 + 1))
		else
		end
	end)
	r_2111(1)
	local r_2161 = spec3["pos"]
	local r_2191 = r_2161["n"]
	local r_2171 = nil
	r_2171 = (function(r_2181)
		if (r_2181 <= r_2191) then
			local arg7 = r_2161[r_2181]
			helpNarg_21_1(usage1, arg7)
			return r_2171((r_2181 + 1))
		else
		end
	end)
	r_2171(1)
	return print1(concat1(usage1))
end)
help_21_1 = (function(spec4, name3)
	if name3 then
	else
		local r_2211 = arg1[0]
		if r_2211 then
			name3 = r_2211
		else
			local r_2221 = arg1[-1]
			name3 = r_2221 or "?"
		end
	end
	usage_21_2(spec4, name3)
	if spec4["desc"] then
		print1()
		print1(spec4["desc"])
	else
	end
	local max3 = 0
	local r_2241 = spec4["pos"]
	local r_2271 = r_2241["n"]
	local r_2251 = nil
	r_2251 = (function(r_2261)
		if (r_2261 <= r_2271) then
			local arg8 = r_2241[r_2261]
			local len3 = len1(arg8["var"])
			if (len3 > max3) then
				max3 = len3
			else
			end
			return r_2251((r_2261 + 1))
		else
		end
	end)
	r_2251(1)
	local r_2301 = spec4["opt"]
	local r_2331 = r_2301["n"]
	local r_2311 = nil
	r_2311 = (function(r_2321)
		if (r_2321 <= r_2331) then
			local arg9 = r_2301[r_2321]
			local len4 = len1(concat1(arg9["names"], ", "))
			if (len4 > max3) then
				max3 = len4
			else
			end
			return r_2311((r_2321 + 1))
		else
		end
	end)
	r_2311(1)
	local fmt1 = _2e2e_2(" %-", tostring1((max3 + 1)), "s %s")
	if nil_3f_1(spec4["pos"]) then
	else
		print1()
		print1("Positional arguments")
		local r_2361 = spec4["pos"]
		local r_2391 = r_2361["n"]
		local r_2371 = nil
		r_2371 = (function(r_2381)
			if (r_2381 <= r_2391) then
				local arg10 = r_2361[r_2381]
				print1(format1(fmt1, arg10["var"], arg10["help"]))
				return r_2371((r_2381 + 1))
			else
			end
		end)
		r_2371(1)
	end
	if nil_3f_1(spec4["opt"]) then
	else
		print1()
		print1("Optional arguments")
		local r_2421 = spec4["opt"]
		local r_2451 = r_2421["n"]
		local r_2431 = nil
		r_2431 = (function(r_2441)
			if (r_2441 <= r_2451) then
				local arg11 = r_2421[r_2441]
				print1(format1(fmt1, concat1(arg11["names"], ", "), arg11["help"]))
				return r_2431((r_2441 + 1))
			else
			end
		end)
		return r_2431(1)
	end
end)
matcher1 = (function(pattern2)
	return (function(x13)
		local res1 = list1(match1(x13, pattern2))
		if (car1(res1) == nil) then
			return nil
		else
			return res1
		end
	end)
end)
parse_21_1 = (function(spec5, args3)
	if args3 then
	else
		args3 = arg1
	end
	local result4 = ({})
	local pos2 = spec5["pos"]
	local idx3 = 1
	local len5
	local x14 = args3
	len5 = x14["n"]
	local usage_21_3 = (function(msg1)
		local name4
		local xs11 = args3
		name4 = xs11[0]
		usage_21_2(spec5, name4)
		print1(msg1)
		return exit_21_1(1)
	end)
	local readArgs1 = (function(key4, arg12)
		local r_2841 = arg12["narg"]
		if (r_2841 == "+") then
			idx3 = (idx3 + 1)
			local elem1
			local xs12 = args3
			local idx4 = idx3
			elem1 = xs12[idx4]
			if (elem1 == nil) then
				local msg2 = _2e2e_2("Expected ", arg12["var"], " after --", key4, ", got nothing")
				local name5
				local xs13 = args3
				name5 = xs13[0]
				usage_21_2(spec5, name5)
				print1(msg2)
				exit_21_1(1)
			else
				local temp12
				local r_2851
				local expr2 = arg12["all"]
				r_2851 = not expr2
				temp12 = r_2851 and find1(elem1, "^%-")
				if temp12 then
					local msg3 = _2e2e_2("Expected ", arg12["var"], " after --", key4, ", got ", (function(xs14, idx5)
						return xs14[idx5]
					end)(args3, idx3))
					local name6
					local xs15 = args3
					name6 = xs15[0]
					usage_21_2(spec5, name6)
					print1(msg3)
					exit_21_1(1)
				else
					arg12["action"](arg12, result4, elem1, usage_21_3)
				end
			end
			local running1 = true
			local r_2861 = nil
			r_2861 = (function()
				if running1 then
					idx3 = (idx3 + 1)
					local elem2
					local xs16 = args3
					local idx6 = idx3
					elem2 = xs16[idx6]
					if (elem2 == nil) then
						running1 = false
					else
						local temp13
						local r_2871
						local expr3 = arg12["all"]
						r_2871 = not expr3
						temp13 = r_2871 and find1(elem2, "^%-")
						if temp13 then
							running1 = false
						else
							arg12["action"](arg12, result4, elem2, usage_21_3)
						end
					end
					return r_2861()
				else
				end
			end)
			return r_2861()
		elseif (r_2841 == "*") then
			local running2 = true
			local r_2881 = nil
			r_2881 = (function()
				if running2 then
					idx3 = (idx3 + 1)
					local elem3
					local xs17 = args3
					local idx7 = idx3
					elem3 = xs17[idx7]
					if (elem3 == nil) then
						running2 = false
					else
						local temp14
						local r_2891
						local expr4 = arg12["all"]
						r_2891 = not expr4
						temp14 = r_2891 and find1(elem3, "^%-")
						if temp14 then
							running2 = false
						else
							arg12["action"](arg12, result4, elem3, usage_21_3)
						end
					end
					return r_2881()
				else
				end
			end)
			return r_2881()
		elseif (r_2841 == "?") then
			idx3 = (idx3 + 1)
			local elem4
			local xs18 = args3
			local idx8 = idx3
			elem4 = xs18[idx8]
			local temp15
			local r_2901 = (elem4 == nil)
			if r_2901 then
				temp15 = r_2901
			else
				local r_2911
				local expr5 = arg12["all"]
				r_2911 = not expr5
				temp15 = r_2911 and find1(elem4, "^%-")
			end
			if temp15 then
				return arg12["action"](arg12, result4, arg12["value"])
			else
				idx3 = (idx3 + 1)
				return arg12["action"](arg12, result4, elem4, usage_21_3)
			end
		elseif (r_2841 == 0) then
			idx3 = (idx3 + 1)
			local value6 = arg12["value"]
			return arg12["action"](arg12, result4, value6, usage_21_3)
		else
			local r_2921 = nil
			r_2921 = (function(r_2931)
				if (r_2931 <= r_2841) then
					idx3 = (idx3 + 1)
					local elem5
					local xs19 = args3
					local idx9 = idx3
					elem5 = xs19[idx9]
					if (elem5 == nil) then
						local msg4 = _2e2e_2("Expected ", r_2841, " args for ", key4, ", got ", (r_2931 - 1))
						local name7
						local xs20 = args3
						name7 = xs20[0]
						usage_21_2(spec5, name7)
						print1(msg4)
						exit_21_1(1)
					else
						local temp16
						local r_2961
						local expr6 = arg12["all"]
						r_2961 = not expr6
						temp16 = r_2961 and find1(elem5, "^%-")
						if temp16 then
							local msg5 = _2e2e_2("Expected ", r_2841, " for ", key4, ", got ", (r_2931 - 1))
							local name8
							local xs21 = args3
							name8 = xs21[0]
							usage_21_2(spec5, name8)
							print1(msg5)
							exit_21_1(1)
						else
							arg12["action"](arg12, result4, elem5, usage_21_3)
						end
					end
					return r_2921((r_2931 + 1))
				else
				end
			end)
			r_2921(1)
			idx3 = (idx3 + 1)
			return nil
		end
	end)
	local r_2471 = nil
	r_2471 = (function()
		if (idx3 <= len5) then
			local r_2531
			local xs22 = args3
			local idx10 = idx3
			r_2531 = xs22[idx10]
			local temp17
			local r_2541 = matcher1("^%-%-([^=]+)=(.+)$")(r_2531)
			local r_2571 = (type1(r_2541) == "list")
			if r_2571 then
				local r_2581 = (r_2541["n"] >= 2)
				if r_2581 then
					local r_2591 = (r_2541["n"] <= 2)
					temp17 = r_2591 and true
				else
					temp17 = r_2581
				end
			else
				temp17 = r_2571
			end
			if temp17 then
				local key5
				local xs23 = matcher1("^%-%-([^=]+)=(.+)$")(r_2531)
				key5 = xs23[1]
				local val8
				local xs24 = matcher1("^%-%-([^=]+)=(.+)$")(r_2531)
				val8 = xs24[2]
				local arg13 = spec5["opt-map"][key5]
				if (arg13 == nil) then
					local msg6 = _2e2e_2("Unknown argument ", key5, " in ", (function(xs25, idx11)
						return xs25[idx11]
					end)(args3, idx3))
					local name9
					local xs26 = args3
					name9 = xs26[0]
					usage_21_2(spec5, name9)
					print1(msg6)
					exit_21_1(1)
				else
					local temp18
					local r_2611
					local expr7 = arg13["many"]
					r_2611 = not expr7
					temp18 = r_2611 and (nil ~= result4[arg13["name"]])
					if temp18 then
						local msg7 = _2e2e_2("Too may values for ", key5, " in ", (function(xs27, idx12)
							return xs27[idx12]
						end)(args3, idx3))
						local name10
						local xs28 = args3
						name10 = xs28[0]
						usage_21_2(spec5, name10)
						print1(msg7)
						exit_21_1(1)
					else
						local narg1 = arg13["narg"]
						local temp19
						local r_2621 = number_3f_1(narg1)
						temp19 = r_2621 and (narg1 ~= 1)
						if temp19 then
							local msg8 = _2e2e_2("Expected ", tostring1(narg1), " values, got 1 in ", (function(xs29, idx13)
								return xs29[idx13]
							end)(args3, idx3))
							local name11
							local xs30 = args3
							name11 = xs30[0]
							usage_21_2(spec5, name11)
							print1(msg8)
							exit_21_1(1)
						else
						end
						arg13["action"](arg13, result4, val8, usage_21_3)
					end
				end
				idx3 = (idx3 + 1)
			else
				local temp20
				local r_2551 = matcher1("^%-%-(.*)$")(r_2531)
				local r_2631 = (type1(r_2551) == "list")
				if r_2631 then
					local r_2641 = (r_2551["n"] >= 1)
					if r_2641 then
						local r_2651 = (r_2551["n"] <= 1)
						temp20 = r_2651 and true
					else
						temp20 = r_2641
					end
				else
					temp20 = r_2631
				end
				if temp20 then
					local key6
					local xs31 = matcher1("^%-%-(.*)$")(r_2531)
					key6 = xs31[1]
					local arg14 = spec5["opt-map"][key6]
					if (arg14 == nil) then
						local msg9 = _2e2e_2("Unknown argument ", key6, " in ", (function(xs32, idx14)
							return xs32[idx14]
						end)(args3, idx3))
						local name12
						local xs33 = args3
						name12 = xs33[0]
						usage_21_2(spec5, name12)
						print1(msg9)
						exit_21_1(1)
					else
						local temp21
						local r_2661
						local expr8 = arg14["many"]
						r_2661 = not expr8
						temp21 = r_2661 and (nil ~= result4[arg14["name"]])
						if temp21 then
							local msg10 = _2e2e_2("Too may values for ", key6, " in ", (function(xs34, idx15)
								return xs34[idx15]
							end)(args3, idx3))
							local name13
							local xs35 = args3
							name13 = xs35[0]
							usage_21_2(spec5, name13)
							print1(msg10)
							exit_21_1(1)
						else
							readArgs1(key6, arg14)
						end
					end
				else
					local temp22
					local r_2561 = matcher1("^%-(.+)$")(r_2531)
					local r_2671 = (type1(r_2561) == "list")
					if r_2671 then
						local r_2681 = (r_2561["n"] >= 1)
						if r_2681 then
							local r_2691 = (r_2561["n"] <= 1)
							temp22 = r_2691 and true
						else
							temp22 = r_2681
						end
					else
						temp22 = r_2671
					end
					if temp22 then
						local flags1
						local xs36 = matcher1("^%-(.+)$")(r_2531)
						flags1 = xs36[1]
						local i1 = 1
						local s1 = len1(flags1)
						local r_2701 = nil
						r_2701 = (function()
							if (i1 <= s1) then
								local key7
								local x15 = i1
								key7 = sub1(flags1, x15, x15)
								local arg15 = spec5["flag-map"][key7]
								if (arg15 == nil) then
									local msg11 = _2e2e_2("Unknown flag ", key7, " in ", (function(xs37, idx16)
										return xs37[idx16]
									end)(args3, idx3))
									local name14
									local xs38 = args3
									name14 = xs38[0]
									usage_21_2(spec5, name14)
									print1(msg11)
									exit_21_1(1)
								else
									local temp23
									local r_2711
									local expr9 = arg15["many"]
									r_2711 = not expr9
									temp23 = r_2711 and (nil ~= result4[arg15["name"]])
									if temp23 then
										local msg12 = _2e2e_2("Too many occurances of ", key7, " in ", (function(xs39, idx17)
											return xs39[idx17]
										end)(args3, idx3))
										local name15
										local xs40 = args3
										name15 = xs40[0]
										usage_21_2(spec5, name15)
										print1(msg12)
										exit_21_1(1)
									else
										local narg2 = arg15["narg"]
										if (i1 == s1) then
											readArgs1(key7, arg15)
										elseif (narg2 == 0) then
											local value7 = arg15["value"]
											arg15["action"](arg15, result4, value7, usage_21_3)
										else
											local value8 = sub1(flags1, (function(x16)
												return (x16 + 1)
											end)(i1))
											arg15["action"](arg15, result4, value8, usage_21_3)
											i1 = (s1 + 1)
											idx3 = (idx3 + 1)
										end
									end
								end
								i1 = (i1 + 1)
								return r_2701()
							else
							end
						end)
						r_2701()
					else
						local arg16 = car1(spec5["pos"])
						if arg16 then
							arg16["action"](arg16, result4, r_2531, usage_21_3)
						else
							local msg13 = _2e2e_2("Unknown argument ", arg16)
							local name16
							local xs41 = args3
							name16 = xs41[0]
							usage_21_2(spec5, name16)
							print1(msg13)
							exit_21_1(1)
						end
						idx3 = (idx3 + 1)
					end
				end
			end
			return r_2471()
		else
		end
	end)
	r_2471()
	local r_2731 = spec5["opt"]
	local r_2761 = r_2731["n"]
	local r_2741 = nil
	r_2741 = (function(r_2751)
		if (r_2751 <= r_2761) then
			local arg17 = r_2731[r_2751]
			if (result4[arg17["name"]] == nil) then
				result4[arg17["name"]] = arg17["default"]
			else
			end
			return r_2741((r_2751 + 1))
		else
		end
	end)
	r_2741(1)
	local r_2791 = spec5["pos"]
	local r_2821 = r_2791["n"]
	local r_2801 = nil
	r_2801 = (function(r_2811)
		if (r_2811 <= r_2821) then
			local arg18 = r_2791[r_2811]
			if (result4[arg18["name"]] == nil) then
				result4[arg18["name"]] = arg18["default"]
			else
			end
			return r_2801((r_2811 + 1))
		else
		end
	end)
	r_2801(1)
	return result4
end)
builtins1 = require1("tacky.analysis.resolve")["builtins"]
builtinVars1 = require1("tacky.analysis.resolve")["declaredVars"]
builtin_3f_1 = (function(node1, name17)
	local r_3011 = (type1(node1) == "symbol")
	return r_3011 and (node1["var"] == builtins1[name17])
end)
builtinVar_3f_1 = (function(node2, name18)
	local r_3021 = (type1(node2) == "symbol")
	return r_3021 and (node2["var"] == builtinVars1[name18])
end)
sideEffect_3f_1 = (function(node3)
	local tag4 = type1(node3)
	local temp24
	local r_3031 = (tag4 == "number")
	if r_3031 then
		temp24 = r_3031
	else
		local r_3041 = (tag4 == "string")
		if r_3041 then
			temp24 = r_3041
		else
			local r_3051 = (tag4 == "key")
			temp24 = r_3051 or (tag4 == "symbol")
		end
	end
	if temp24 then
		return false
	elseif (tag4 == "list") then
		local fst1 = car1(node3)
		if (type1(fst1) == "symbol") then
			local var1 = fst1["var"]
			local r_3061 = (var1 ~= builtins1["lambda"])
			return r_3061 and (var1 ~= builtins1["quote"])
		else
			return true
		end
	else
		_error("unmatched item")
	end
end)
constant_3f_1 = (function(node4)
	local r_3071 = string_3f_1(node4)
	if r_3071 then
		return r_3071
	else
		local r_3081 = number_3f_1(node4)
		return r_3081 or (type1(node4) == "key")
	end
end)
urn_2d3e_val1 = (function(node5)
	if string_3f_1(node5) then
		return node5["value"]
	elseif number_3f_1(node5) then
		return node5["value"]
	elseif (type1(node5) == "key") then
		return node5["value"]
	else
		_error("unmatched item")
	end
end)
val_2d3e_urn1 = (function(val9)
	local ty3 = type_23_1(val9)
	if (ty3 == "string") then
		return struct1("tag", "string", "value", val9)
	elseif (ty3 == "number") then
		return struct1("tag", "number", "value", val9)
	elseif (ty3 == "nil") then
		return struct1("tag", "symbol", "contents", "nil", "var", builtinVars1["nil"])
	elseif (ty3 == "boolean") then
		return struct1("tag", "symbol", "contents", tostring1(val9), "var", builtinVars1[tostring1(val9)])
	else
		_error("unmatched item")
	end
end)
urn_2d3e_bool1 = (function(node6)
	local temp25
	local r_3091 = string_3f_1(node6)
	if r_3091 then
		temp25 = r_3091
	else
		local r_3101 = (type1(node6) == "key")
		temp25 = r_3101 or number_3f_1(node6)
	end
	if temp25 then
		return true
	elseif (type1(node6) == "symbol") then
		if (builtinVars1["true"] == node6["var"]) then
			return true
		elseif (builtinVars1["false"] == node6["var"]) then
			return false
		elseif (builtinVars1["nil"] == node6["var"]) then
			return false
		else
			return nil
		end
	else
		return nil
	end
end)
makeProgn1 = (function(body1)
	local lambda1 = struct1("tag", "symbol", "contents", "lambda", "var", builtins1["lambda"])
	return ({tag = "list", n = 1, (function()
		local _offset, _result, _temp = 0, {tag="list",n=0}
		_result[1 + _offset] = lambda1
		_result[2 + _offset] = ({tag = "list", n = 0})
		_temp = body1
		for _c = 1, _temp.n do _result[2 + _c + _offset] = _temp[_c] end
		_offset = _offset + _temp.n
		_result.n = _offset + 2
		return _result
	end)()
	})
end)
create2 = (function(fn1)
	return {["callback"]=fn1,["timers"]=({})}
end)
startTimer_21_1 = (function(timer1, name19, level1)
	local instance1 = timer1["timers"][name19]
	if instance1 then
	else
		instance1 = {["name"]=name19,["level"]=level1 or 1,["running"]=false,["total"]=0}
		timer1["timers"][name19] = instance1
	end
	if instance1["running"] then
		error1(_2e2e_2("Timer ", name19, " is already running"))
	else
	end
	instance1["running"] = true
	instance1["start"] = clock1()
	return nil
end)
pauseTimer_21_1 = (function(timer2, name20)
	local instance2 = timer2["timers"][name20]
	if instance2 then
	else
		error1(_2e2e_2("Timer ", name20, " does not exist"))
	end
	if instance2["running"] then
	else
		error1(_2e2e_2("Timer ", name20, " is not running"))
	end
	instance2["running"] = false
	instance2["total"] = ((clock1() - instance2["start"]) + instance2["total"])
	return nil
end)
stopTimer_21_1 = (function(timer3, name21)
	local instance3 = timer3["timers"][name21]
	if instance3 then
	else
		error1(_2e2e_2("Timer ", name21, " does not exist"))
	end
	if instance3["running"] then
	else
		error1(_2e2e_2("Timer ", name21, " is not running"))
	end
	timer3["timers"][name21] = nil
	instance3["total"] = ((clock1() - instance3["start"]) + instance3["total"])
	return timer3["callback"](instance3["name"], instance3["total"], instance3["level"])
end)
void1 = create2((function()
end))
putError_21_1 = (function(logger1, msg14)
	return self1(logger1, "put-error!", msg14)
end)
putWarning_21_1 = (function(logger2, msg15)
	return self1(logger2, "put-warning!", msg15)
end)
putVerbose_21_1 = (function(logger3, msg16)
	return self1(logger3, "put-verbose!", msg16)
end)
putDebug_21_1 = (function(logger4, msg17)
	return self1(logger4, "put-debug!", msg17)
end)
putNodeError_21_1 = (function(logger5, msg18, node7, explain1, ...)
	local lines1 = _pack(...) lines1.tag = "list"
	return self1(logger5, "put-node-error!", msg18, node7, explain1, lines1)
end)
putNodeWarning_21_1 = (function(logger6, msg19, node8, explain2, ...)
	local lines2 = _pack(...) lines2.tag = "list"
	return self1(logger6, "put-node-warning!", msg19, node8, explain2, lines2)
end)
doNodeError_21_1 = (function(logger7, msg20, node9, explain3, ...)
	local lines3 = _pack(...) lines3.tag = "list"
	self1(logger7, "put-node-error!", msg20, node9, explain3, lines3)
	local x17
	local r_3161 = match1(msg20, "^([^\n]+)\n")
	x17 = r_3161 or msg20
	return error1(x17, 0)
end)
struct1("startTimer", startTimer_21_1, "pauseTimer", pauseTimer_21_1, "stopTimer", stopTimer_21_1, "putError", putError_21_1, "putWarning", putWarning_21_1, "putVerbose", putVerbose_21_1, "putDebug", putDebug_21_1, "putNodeError", putNodeError_21_1, "putNodeWarning", putNodeWarning_21_1, "doNodeError", doNodeError_21_1)
passEnabled_3f_1 = (function(pass1, options2)
	local override1 = options2["override"]
	local r_3131 = (options2["level"] >= (function(r_3151)
		return r_3151 or 1
	end)(pass1["level"]))
	if r_3131 then
		local r_3141
		if (pass1["on"] == false) then
			r_3141 = (override1[pass1["name"]] == true)
		else
			r_3141 = (override1[pass1["name"]] ~= false)
		end
		return r_3141 and all1((function(cat1)
			return (false ~= override1[cat1])
		end), pass1["cat"])
	else
		return r_3131
	end
end)
runPass1 = (function(pass2, options3, tracker1, ...)
	local args4 = _pack(...) args4.tag = "list"
	if passEnabled_3f_1(pass2, options3) then
		local ptracker1 = struct1("changed", false)
		local name22 = _2e2e_2("[", concat1(pass2["cat"], " "), "] ", pass2["name"])
		startTimer_21_1(options3["timer"], name22, 2)
		pass2["run"](ptracker1, options3, unpack1(args4, 1, args4["n"]))
		stopTimer_21_1(options3["timer"], name22)
		if ptracker1["changed"] then
			if options3["track"] then
				local logger8 = options3["logger"]
				local msg21 = _2e2e_2(name22, " did something.")
				self1(logger8, "put-verbose!", msg21)
			else
			end
			if tracker1 then
				tracker1["changed"] = true
			else
			end
		else
		end
		return ptracker1["changed"]
	else
	end
end)
builtins2 = require1("tacky.analysis.resolve")["builtins"]
traverseQuote1 = (function(node10, visitor1, level2)
	if (level2 == 0) then
		return traverseNode1(node10, visitor1)
	else
		local tag5 = node10["tag"]
		local temp26
		local r_3311 = (tag5 == "string")
		if r_3311 then
			temp26 = r_3311
		else
			local r_3321 = (tag5 == "number")
			if r_3321 then
				temp26 = r_3321
			else
				local r_3331 = (tag5 == "key")
				temp26 = r_3331 or (tag5 == "symbol")
			end
		end
		if temp26 then
			return node10
		elseif (tag5 == "list") then
			local first2 = node10[1]
			if first2 and (first2["tag"] == "symbol") then
				local temp27
				local r_3351 = (first2["contents"] == "unquote")
				temp27 = r_3351 or (first2["contents"] == "unquote-splice")
				if temp27 then
					node10[2] = traverseQuote1(node10[2], visitor1, (level2 - 1))
					return node10
				elseif (first2["contents"] == "syntax-quote") then
					node10[2] = traverseQuote1(node10[2], visitor1, (level2 + 1))
					return node10
				else
					local r_3381 = node10["n"]
					local r_3361 = nil
					r_3361 = (function(r_3371)
						if (r_3371 <= r_3381) then
							node10[r_3371] = traverseQuote1(node10[r_3371], visitor1, level2)
							return r_3361((r_3371 + 1))
						else
						end
					end)
					r_3361(1)
					return node10
				end
			else
				local r_3421 = node10["n"]
				local r_3401 = nil
				r_3401 = (function(r_3411)
					if (r_3411 <= r_3421) then
						node10[r_3411] = traverseQuote1(node10[r_3411], visitor1, level2)
						return r_3401((r_3411 + 1))
					else
					end
				end)
				r_3401(1)
				return node10
			end
		elseif error1 then
			return _2e2e_2("Unknown tag ", tag5)
		else
			_error("unmatched item")
		end
	end
end)
traverseNode1 = (function(node11, visitor2)
	local tag6 = node11["tag"]
	local temp28
	local r_3201 = (tag6 == "string")
	if r_3201 then
		temp28 = r_3201
	else
		local r_3211 = (tag6 == "number")
		if r_3211 then
			temp28 = r_3211
		else
			local r_3221 = (tag6 == "key")
			temp28 = r_3221 or (tag6 == "symbol")
		end
	end
	if temp28 then
		return visitor2(node11, visitor2)
	elseif (tag6 == "list") then
		local first3 = car1(node11)
		first3 = visitor2(first3, visitor2)
		node11[1] = first3
		if (first3["tag"] == "symbol") then
			local func1 = first3["var"]
			local funct1 = func1["tag"]
			if (func1 == builtins2["lambda"]) then
				traverseBlock1(node11, 3, visitor2)
				return visitor2(node11, visitor2)
			elseif (func1 == builtins2["cond"]) then
				local r_3461 = node11["n"]
				local r_3441 = nil
				r_3441 = (function(r_3451)
					if (r_3451 <= r_3461) then
						local case1 = node11[r_3451]
						case1[1] = traverseNode1(case1[1], visitor2)
						traverseBlock1(case1, 2, visitor2)
						return r_3441((r_3451 + 1))
					else
					end
				end)
				r_3441(2)
				return visitor2(node11, visitor2)
			elseif (func1 == builtins2["set!"]) then
				node11[3] = traverseNode1(node11[3], visitor2)
				return visitor2(node11, visitor2)
			elseif (func1 == builtins2["quote"]) then
				return visitor2(node11, visitor2)
			elseif (func1 == builtins2["syntax-quote"]) then
				node11[2] = traverseQuote1(node11[2], visitor2, 1)
				return visitor2(node11, visitor2)
			else
				local temp29
				local r_3481 = (func1 == builtins2["unquote"])
				temp29 = r_3481 or (func1 == builtins2["unquote-splice"])
				if temp29 then
					return error1("unquote/unquote-splice should never appear head", 0)
				else
					local temp30
					local r_3491 = (func1 == builtins2["define"])
					temp30 = r_3491 or (func1 == builtins2["define-macro"])
					if temp30 then
						node11[node11["n"]] = traverseNode1((function(idx18)
							return node11[idx18]
						end)(node11["n"]), visitor2)
						return visitor2(node11, visitor2)
					elseif (func1 == builtins2["define-native"]) then
						return visitor2(node11, visitor2)
					elseif (func1 == builtins2["import"]) then
						return visitor2(node11, visitor2)
					else
						local temp31
						local r_3501 = (funct1 == "defined")
						if r_3501 then
							temp31 = r_3501
						else
							local r_3511 = (funct1 == "arg")
							if r_3511 then
								temp31 = r_3511
							else
								local r_3521 = (funct1 == "native")
								temp31 = r_3521 or (funct1 == "macro")
							end
						end
						if temp31 then
							traverseList1(node11, 1, visitor2)
							return visitor2(node11, visitor2)
						else
							local x18 = _2e2e_2("Unknown kind ", funct1, " for variable ", func1["name"])
							return error1(x18, 0)
						end
					end
				end
			end
		else
			traverseList1(node11, 1, visitor2)
			return visitor2(node11, visitor2)
		end
	else
		return error1(_2e2e_2("Unknown tag ", tag6))
	end
end)
traverseBlock1 = (function(node12, start2, visitor3)
	local r_3251 = node12["n"]
	local r_3231 = nil
	r_3231 = (function(r_3241)
		if (r_3241 <= r_3251) then
			local result5 = traverseNode1((function(idx19)
				return node12[idx19]
			end)((r_3241 + 0)), visitor3)
			node12[r_3241] = result5
			return r_3231((r_3241 + 1))
		else
		end
	end)
	r_3231(start2)
	return node12
end)
traverseList1 = (function(node13, start3, visitor4)
	local r_3291 = node13["n"]
	local r_3271 = nil
	r_3271 = (function(r_3281)
		if (r_3281 <= r_3291) then
			node13[r_3281] = traverseNode1(node13[r_3281], visitor4)
			return r_3271((r_3281 + 1))
		else
		end
	end)
	r_3271(start3)
	return node13
end)
builtins3 = require1("tacky.analysis.resolve")["builtins"]
visitQuote1 = (function(node14, visitor5, level3)
	if (level3 == 0) then
		return visitNode1(node14, visitor5)
	else
		local tag7 = node14["tag"]
		local temp32
		local r_3721 = (tag7 == "string")
		if r_3721 then
			temp32 = r_3721
		else
			local r_3731 = (tag7 == "number")
			if r_3731 then
				temp32 = r_3731
			else
				local r_3741 = (tag7 == "key")
				temp32 = r_3741 or (tag7 == "symbol")
			end
		end
		if temp32 then
			return nil
		elseif (tag7 == "list") then
			local first4 = node14[1]
			if first4 and (first4["tag"] == "symbol") then
				local temp33
				local r_3761 = (first4["contents"] == "unquote")
				temp33 = r_3761 or (first4["contents"] == "unquote-splice")
				if temp33 then
					return visitQuote1(node14[2], visitor5, (level3 - 1))
				elseif (first4["contents"] == "syntax-quote") then
					return visitQuote1(node14[2], visitor5, (level3 + 1))
				else
					local r_3811 = node14["n"]
					local r_3791 = nil
					r_3791 = (function(r_3801)
						if (r_3801 <= r_3811) then
							local sub2 = node14[r_3801]
							visitQuote1(sub2, visitor5, level3)
							return r_3791((r_3801 + 1))
						else
						end
					end)
					return r_3791(1)
				end
			else
				local r_3871 = node14["n"]
				local r_3851 = nil
				r_3851 = (function(r_3861)
					if (r_3861 <= r_3871) then
						local sub3 = node14[r_3861]
						visitQuote1(sub3, visitor5, level3)
						return r_3851((r_3861 + 1))
					else
					end
				end)
				return r_3851(1)
			end
		elseif error1 then
			return _2e2e_2("Unknown tag ", tag7)
		else
			_error("unmatched item")
		end
	end
end)
visitNode1 = (function(node15, visitor6)
	if (visitor6(node15, visitor6) == false) then
	else
		local tag8 = node15["tag"]
		local temp34
		local r_3651 = (tag8 == "string")
		if r_3651 then
			temp34 = r_3651
		else
			local r_3661 = (tag8 == "number")
			if r_3661 then
				temp34 = r_3661
			else
				local r_3671 = (tag8 == "key")
				temp34 = r_3671 or (tag8 == "symbol")
			end
		end
		if temp34 then
			return nil
		elseif (tag8 == "list") then
			local first5 = node15[1]
			if (first5["tag"] == "symbol") then
				local func2 = first5["var"]
				local funct2 = func2["tag"]
				if (func2 == builtins3["lambda"]) then
					return visitBlock1(node15, 3, visitor6)
				elseif (func2 == builtins3["cond"]) then
					local r_3911 = node15["n"]
					local r_3891 = nil
					r_3891 = (function(r_3901)
						if (r_3901 <= r_3911) then
							local case2 = node15[r_3901]
							visitNode1(case2[1], visitor6)
							visitBlock1(case2, 2, visitor6)
							return r_3891((r_3901 + 1))
						else
						end
					end)
					return r_3891(2)
				elseif (func2 == builtins3["set!"]) then
					return visitNode1(node15[3], visitor6)
				elseif (func2 == builtins3["quote"]) then
				elseif (func2 == builtins3["syntax-quote"]) then
					return visitQuote1(node15[2], visitor6, 1)
				else
					local temp35
					local r_3931 = (func2 == builtins3["unquote"])
					temp35 = r_3931 or (func2 == builtins3["unquote-splice"])
					if temp35 then
						return error1("unquote/unquote-splice should never appear head", 0)
					else
						local temp36
						local r_3941 = (func2 == builtins3["define"])
						temp36 = r_3941 or (func2 == builtins3["define-macro"])
						if temp36 then
							return visitNode1((function(idx20)
								return node15[idx20]
							end)(node15["n"]), visitor6)
						elseif (func2 == builtins3["define-native"]) then
						elseif (func2 == builtins3["import"]) then
						else
							local temp37
							local r_3951 = (funct2 == "defined")
							if r_3951 then
								temp37 = r_3951
							else
								local r_3961 = (funct2 == "arg")
								if r_3961 then
									temp37 = r_3961
								else
									local r_3971 = (funct2 == "native")
									temp37 = r_3971 or (funct2 == "macro")
								end
							end
							if temp37 then
								return visitBlock1(node15, 1, visitor6)
							else
								local x19 = _2e2e_2("Unknown kind ", funct2, " for variable ", func2["name"])
								return error1(x19, 0)
							end
						end
					end
				end
			else
				return visitBlock1(node15, 1, visitor6)
			end
		else
			return error1(_2e2e_2("Unknown tag ", tag8))
		end
	end
end)
visitBlock1 = (function(node16, start4, visitor7)
	local r_3701 = node16["n"]
	local r_3681 = nil
	r_3681 = (function(r_3691)
		if (r_3691 <= r_3701) then
			visitNode1(node16[r_3691], visitor7)
			return r_3681((r_3691 + 1))
		else
		end
	end)
	return r_3681(start4)
end)
createState1 = (function()
	return {["vars"]=({}),["nodes"]=({})}
end)
getVar1 = (function(state1, var2)
	local entry1 = state1["vars"][var2]
	if entry1 then
	else
		entry1 = {["var"]=var2,["usages"]=({tag = "list", n = 0}),["defs"]=({tag = "list", n = 0}),["active"]=false}
		state1["vars"][var2] = entry1
	end
	return entry1
end)
addUsage_21_1 = (function(state2, var3, node17)
	local varMeta1 = getVar1(state2, var3)
	pushCdr_21_1(varMeta1["usages"], node17)
	varMeta1["active"] = true
	return nil
end)
addDefinition_21_1 = (function(state3, var4, node18, kind1, value9)
	local varMeta2 = getVar1(state3, var4)
	return pushCdr_21_1(varMeta2["defs"], {["tag"]=kind1,["node"]=node18,["value"]=value9})
end)
definitionsVisitor1 = (function(state4, node19, visitor8)
	local temp38
	local r_3571 = (type1(node19) == "list")
	if r_3571 then
		local x20 = car1(node19)
		temp38 = (type1(x20) == "symbol")
	else
		temp38 = r_3571
	end
	if temp38 then
		local func3 = car1(node19)["var"]
		if (func3 == builtins1["lambda"]) then
			local r_3991 = node19[2]
			local r_4021 = r_3991["n"]
			local r_4001 = nil
			r_4001 = (function(r_4011)
				if (r_4011 <= r_4021) then
					local arg19 = r_3991[r_4011]
					addDefinition_21_1(state4, arg19["var"], arg19, "arg", arg19)
					return r_4001((r_4011 + 1))
				else
				end
			end)
			return r_4001(1)
		elseif (func3 == builtins1["set!"]) then
			return addDefinition_21_1(state4, node19[2]["var"], node19, "set", node19[3])
		else
			local temp39
			local r_4041 = (func3 == builtins1["define"])
			temp39 = r_4041 or (func3 == builtins1["define-macro"])
			if temp39 then
				return addDefinition_21_1(state4, node19["defVar"], node19, "define", (function(idx21)
					return node19[idx21]
				end)(node19["n"]))
			elseif (func3 == builtins1["define-native"]) then
				return addDefinition_21_1(state4, node19["defVar"], node19, "native")
			else
			end
		end
	else
		local temp40
		local r_4051 = (type1(node19) == "list")
		if r_4051 then
			local r_4061
			local x21 = car1(node19)
			r_4061 = (type1(x21) == "list")
			if r_4061 then
				local r_4071
				local x22 = car1(car1(node19))
				r_4071 = (type1(x22) == "symbol")
				temp40 = r_4071 and (car1(car1(node19))["var"] == builtins1["lambda"])
			else
				temp40 = r_4061
			end
		else
			temp40 = r_4051
		end
		if temp40 then
			local lam1 = car1(node19)
			local args5 = lam1[2]
			local offset1 = 1
			local r_4101 = args5["n"]
			local r_4081 = nil
			r_4081 = (function(r_4091)
				if (r_4091 <= r_4101) then
					local arg20 = args5[r_4091]
					local val10
					local idx22 = (r_4091 + offset1)
					val10 = node19[idx22]
					if arg20["var"]["isVariadic"] then
						local count1 = (node19["n"] - args5["n"])
						if (count1 < 0) then
							count1 = 0
						else
						end
						offset1 = count1
						addDefinition_21_1(state4, arg20["var"], arg20, "arg", arg20)
					else
						addDefinition_21_1(state4, arg20["var"], arg20, "let", val10 or struct1("tag", "symbol", "contents", "nil", "var", builtinVars1["nil"]))
					end
					return r_4081((r_4091 + 1))
				else
				end
			end)
			r_4081(1)
			visitBlock1(node19, 2, visitor8)
			visitBlock1(lam1, 3, visitor8)
			return false
		else
		end
	end
end)
definitionsVisit1 = (function(state5, nodes1)
	return visitBlock1(nodes1, 1, (function(r_4241, r_4251)
		return definitionsVisitor1(state5, r_4241, r_4251)
	end))
end)
usagesVisit1 = (function(state6, nodes2, pred1)
	if pred1 then
	else
		pred1 = (function()
			return true
		end)
	end
	local queue1 = ({tag = "list", n = 0})
	local visited1 = ({})
	local addUsage1 = (function(var5, user1)
		local varMeta3 = getVar1(state6, var5)
		if varMeta3["active"] then
		else
			local r_4181 = varMeta3["defs"]
			local r_4211 = r_4181["n"]
			local r_4191 = nil
			r_4191 = (function(r_4201)
				if (r_4201 <= r_4211) then
					local def1 = r_4181[r_4201]
					local val11 = def1["value"]
					local temp41
					if val11 then
						local expr10 = visited1[val11]
						temp41 = not expr10
					else
						temp41 = val11
					end
					if temp41 then
						pushCdr_21_1(queue1, val11)
					else
					end
					return r_4191((r_4201 + 1))
				else
				end
			end)
			r_4191(1)
		end
		return addUsage_21_1(state6, var5, user1)
	end)
	local visit1 = (function(node20)
		if visited1[node20] then
			return false
		else
			visited1[node20] = true
			if (type1(node20) == "symbol") then
				addUsage1(node20["var"], node20)
				return true
			else
				local temp42
				local r_4131 = (type1(node20) == "list")
				if r_4131 then
					local r_4141 = (node20["n"] > 0)
					if r_4141 then
						local x23 = car1(node20)
						temp42 = (type1(x23) == "symbol")
					else
						temp42 = r_4141
					end
				else
					temp42 = r_4131
				end
				if temp42 then
					local func4 = car1(node20)["var"]
					local temp43
					local r_4151 = (func4 == builtins1["set!"])
					if r_4151 then
						temp43 = r_4151
					else
						local r_4161 = (func4 == builtins1["define"])
						temp43 = r_4161 or (func4 == builtins1["define-macro"])
					end
					if temp43 then
						if pred1(node20[3]) then
							return true
						else
							return false
						end
					else
						return true
					end
				else
					return true
				end
			end
		end
	end)
	local r_3621 = nodes2["n"]
	local r_3601 = nil
	r_3601 = (function(r_3611)
		if (r_3611 <= r_3621) then
			local node21 = nodes2[r_3611]
			pushCdr_21_1(queue1, node21)
			return r_3601((r_3611 + 1))
		else
		end
	end)
	r_3601(1)
	local r_3641 = nil
	r_3641 = (function()
		if (queue1["n"] > 0) then
			visitNode1(popLast_21_1(queue1), visit1)
			return r_3641()
		else
		end
	end)
	return r_3641()
end)
tagUsage1 = struct1("name", "tag-usage", "help", "Gathers usage and definition data for all expressions in NODES, storing it in LOOKUP.", "cat", ({tag = "list", n = 2, "tag", "usage"}), "run", (function(r_4261, state7, nodes3, lookup1)
	definitionsVisit1(lookup1, nodes3)
	return usagesVisit1(lookup1, nodes3, sideEffect_3f_1)
end))
formatPosition1 = (function(pos3)
	return _2e2e_2(pos3["line"], ":", pos3["column"])
end)
formatRange1 = (function(range1)
	if range1["finish"] then
		return format1("%s:[%s .. %s]", range1["name"], (function(pos4)
			return _2e2e_2(pos4["line"], ":", pos4["column"])
		end)(range1["start"]), (function(pos5)
			return _2e2e_2(pos5["line"], ":", pos5["column"])
		end)(range1["finish"]))
	else
		return format1("%s:[%s]", range1["name"], (function(pos6)
			return _2e2e_2(pos6["line"], ":", pos6["column"])
		end)(range1["start"]))
	end
end)
formatNode1 = (function(node22)
	local temp44
	local r_4271 = node22["range"]
	temp44 = r_4271 and node22["contents"]
	if temp44 then
		return format1("%s (%q)", formatRange1(node22["range"]), node22["contents"])
	elseif node22["range"] then
		return formatRange1(node22["range"])
	elseif node22["owner"] then
		local owner1 = node22["owner"]
		if owner1["var"] then
			return format1("macro expansion of %s (%s)", owner1["var"]["name"], formatNode1(owner1["node"]))
		else
			return format1("unquote expansion (%s)", formatNode1(owner1["node"]))
		end
	else
		local temp45
		local r_4281 = node22["start"]
		temp45 = r_4281 and node22["finish"]
		if temp45 then
			return formatRange1(node22)
		else
			return "?"
		end
	end
end)
getSource1 = (function(node23)
	local result6 = nil
	local r_4291 = nil
	r_4291 = (function()
		local temp46
		local r_4301 = node23
		if r_4301 then
			local expr11 = result6
			temp46 = not expr11
		else
			temp46 = r_4301
		end
		if temp46 then
			result6 = node23["range"]
			node23 = node23["parent"]
			return r_4291()
		else
		end
	end)
	r_4291()
	return result6
end)
struct1("formatPosition", formatPosition1, "formatRange", formatRange1, "formatNode", formatNode1, "getSource", getSource1)
stripImport1 = struct1("name", "strip-import", "help", "Strip all import expressions in NODES", "cat", ({tag = "list", n = 1, "opt"}), "run", (function(r_4262, state8, nodes4)
	local r_4311 = nil
	r_4311 = (function(r_4321)
		if (r_4321 >= 1) then
			local node24 = nodes4[r_4321]
			local temp47
			local r_4351 = (type1(node24) == "list")
			if r_4351 then
				local r_4361 = (node24["n"] > 0)
				if r_4361 then
					local r_4371
					local x24 = car1(node24)
					r_4371 = (type1(x24) == "symbol")
					temp47 = r_4371 and (car1(node24)["var"] == builtins1["import"])
				else
					temp47 = r_4361
				end
			else
				temp47 = r_4351
			end
			if temp47 then
				if (r_4321 == nodes4["n"]) then
					nodes4[r_4321] = struct1("tag", "symbol", "contents", "nil", "var", builtinVars1["nil"])
				else
					removeNth_21_1(nodes4, r_4321)
				end
				r_4262["changed"] = true
			else
			end
			return r_4311((r_4321 + -1))
		else
		end
	end)
	return r_4311(nodes4["n"])
end))
stripPure1 = struct1("name", "strip-pure", "help", "Strip all pure expressions in NODES (apart from the last one).", "cat", ({tag = "list", n = 1, "opt"}), "run", (function(r_4263, state9, nodes5)
	local r_4381 = nil
	r_4381 = (function(r_4391)
		if (r_4391 >= 1) then
			local node25 = nodes5[r_4391]
			if sideEffect_3f_1(node25) then
			else
				removeNth_21_1(nodes5, r_4391)
				r_4263["changed"] = true
			end
			return r_4381((r_4391 + -1))
		else
		end
	end)
	return r_4381((function(x25)
		return (x25 - 1)
	end)(nodes5["n"]))
end))
fastAll1 = (function(fn2, li2, i2)
	if (i2 > li2["n"]) then
		return true
	elseif fn2(li2[i2]) then
		return fastAll1(fn2, li2, (i2 + 1))
	else
		return false
	end
end)
constantFold1 = struct1("name", "constant-fold", "help", "A primitive constant folder\n\nThis simply finds function calls with constant functions and looks up the function.\nIf the function is native and pure then we'll execute it and replace the node with the\nresult. There are a couple of caveats:\n\n - If the function call errors then we will flag a warning and continue.\n - If this returns a decimal (or infinity or NaN) then we'll continue: we cannot correctly\n   accurately handle this.\n - If this doesn't return exactly one value then we will stop. This might be a future enhancement.", "cat", ({tag = "list", n = 1, "opt"}), "run", (function(r_4264, state10, nodes6)
	return traverseList1(nodes6, 1, (function(node26)
		local temp48
		local r_4421 = (type1(node26) == "list")
		temp48 = r_4421 and fastAll1(constant_3f_1, node26, 2)
		if temp48 then
			local head1 = car1(node26)
			local meta1
			local r_4561 = (type1(head1) == "symbol")
			if r_4561 then
				local r_4571
				local expr12 = head1["folded"]
				r_4571 = not expr12
				if r_4571 then
					local r_4581 = (head1["var"]["tag"] == "native")
					meta1 = r_4581 and state10["meta"][head1["var"]["fullName"]]
				else
					meta1 = r_4571
				end
			else
				meta1 = r_4561
			end
			local temp49
			if meta1 then
				local r_4441 = meta1["pure"]
				temp49 = r_4441 and meta1["value"]
			else
				temp49 = meta1
			end
			if temp49 then
				local res2 = list1(pcall1(meta1["value"], unpack1(map1(urn_2d3e_val1, cdr1(node26)))))
				if car1(res2) then
					local val12 = res2[2]
					local temp50
					local r_4451 = (res2["n"] ~= 2)
					if r_4451 then
						temp50 = r_4451
					else
						local r_4461 = number_3f_1(val12)
						if r_4461 then
							local r_4471 = ((function(x26)
								return car1(cdr1(x26))
							end)(list1(modf1(val12))) ~= 0)
							temp50 = r_4471 or (abs1(val12) == huge1)
						else
							temp50 = r_4461
						end
					end
					if temp50 then
						head1["folded"] = true
						return node26
					else
						r_4264["changed"] = true
						return val_2d3e_urn1(val12)
					end
				else
					head1["folded"] = true
					putNodeWarning_21_1(state10["logger"], _2e2e_2("Cannot execute constant expression"), node26, nil, getSource1(node26), _2e2e_2("Executed ", pretty1(node26), ", failed with: ", res2[2]))
					return node26
				end
			else
				return node26
			end
		else
			return node26
		end
	end))
end))
condFold1 = struct1("name", "cond-fold", "help", "Simplify all `cond` nodes, removing `false` branches and killing\nall branches after a `true` one.", "cat", ({tag = "list", n = 1, "opt"}), "run", (function(r_4265, state11, nodes7)
	return traverseList1(nodes7, 1, (function(node27)
		local temp51
		local r_4481 = (type1(node27) == "list")
		if r_4481 then
			local r_4491
			local x27 = car1(node27)
			r_4491 = (type1(x27) == "symbol")
			temp51 = r_4491 and (car1(node27)["var"] == builtins1["cond"])
		else
			temp51 = r_4481
		end
		if temp51 then
			local final1 = false
			local i3 = 2
			local r_4501 = nil
			r_4501 = (function()
				if (i3 <= node27["n"]) then
					local elem6
					local idx23 = i3
					elem6 = node27[idx23]
					if final1 then
						r_4265["changed"] = true
						removeNth_21_1(node27, i3)
					else
						local r_4591 = urn_2d3e_bool1(car1(elem6))
						if eq_3f_1(r_4591, false) then
							r_4265["changed"] = true
							removeNth_21_1(node27, i3)
						elseif eq_3f_1(r_4591, true) then
							final1 = true
							i3 = (i3 + 1)
						elseif eq_3f_1(r_4591, nil) then
							i3 = (i3 + 1)
						else
							error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_4591), ", but none matched.\n", "  Tried: `false`\n  Tried: `true`\n  Tried: `nil`"))
						end
					end
					return r_4501()
				else
				end
			end)
			r_4501()
			local temp52
			local r_4601 = (node27["n"] == 2)
			temp52 = r_4601 and (urn_2d3e_bool1(car1(node27[2])) == true)
			if temp52 then
				r_4265["changed"] = true
				local body2 = cdr1(node27[2])
				if (body2["n"] == 1) then
					return car1(body2)
				else
					return makeProgn1(cdr1(node27[2]))
				end
			else
				return node27
			end
		else
			return node27
		end
	end))
end))
lambdaFold1 = struct1("name", "lambda-fold", "help", "Simplify all directly called lambdas, inlining them were appropriate.", "cat", ({tag = "list", n = 1, "opt"}), "run", (function(r_4266, state12, nodes8)
	return traverseList1(nodes8, 1, (function(node28)
		local temp53
		local r_4511 = (type1(node28) == "list")
		if r_4511 then
			local r_4521 = (node28["n"] == 1)
			if r_4521 then
				local r_4531
				local x28 = car1(node28)
				r_4531 = (type1(x28) == "list")
				if r_4531 then
					local r_4541 = builtin_3f_1(car1(car1(node28)), "lambda")
					if r_4541 then
						local r_4551 = ((function(x29)
							return x29["n"]
						end)(car1(node28)) == 3)
						temp53 = r_4551 and nil_3f_1((function(xs42)
							return xs42[2]
						end)(car1(node28)))
					else
						temp53 = r_4541
					end
				else
					temp53 = r_4531
				end
			else
				temp53 = r_4521
			end
		else
			temp53 = r_4511
		end
		if temp53 then
			local xs43 = car1(node28)
			return xs43[3]
		else
			return node28
		end
	end))
end))
getConstantVal1 = (function(lookup2, sym1)
	local var6 = sym1["var"]
	local def2 = getVar1(lookup2, sym1["var"])
	if (var6 == builtinVars1["true"]) then
		return sym1
	elseif (var6 == builtinVars1["false"]) then
		return sym1
	elseif (var6 == builtinVars1["nil"]) then
		return sym1
	elseif ((function(x30)
		return x30["n"]
	end)(def2["defs"]) == 1) then
		local ent1 = car1(def2["defs"])
		local val13 = ent1["value"]
		local ty4 = ent1["tag"]
		local temp54
		local r_4611 = string_3f_1(val13)
		if r_4611 then
			temp54 = r_4611
		else
			local r_4621 = number_3f_1(val13)
			temp54 = r_4621 or (type1(val13) == "key")
		end
		if temp54 then
			return val13
		else
			local temp55
			local r_4631 = (type1(val13) == "symbol")
			if r_4631 then
				local r_4641 = (ty4 == "define")
				if r_4641 then
					temp55 = r_4641
				else
					local r_4651 = (ty4 == "set")
					temp55 = r_4651 or (ty4 == "let")
				end
			else
				temp55 = r_4631
			end
			if temp55 then
				local r_4661 = getConstantVal1(lookup2, val13)
				return r_4661 or sym1
			else
				return sym1
			end
		end
	else
		return nil
	end
end)
stripDefs1 = struct1("name", "strip-defs", "help", "Strip all unused top level definitions.", "cat", ({tag = "list", n = 2, "opt", "usage"}), "run", (function(r_4267, state13, nodes9, lookup3)
	local r_4671 = nil
	r_4671 = (function(r_4681)
		if (r_4681 >= 1) then
			local node29 = nodes9[r_4681]
			local temp56
			local r_4711 = node29["defVar"]
			if r_4711 then
				local expr13 = getVar1(lookup3, node29["defVar"])["active"]
				temp56 = not expr13
			else
				temp56 = r_4711
			end
			if temp56 then
				if (r_4681 == nodes9["n"]) then
					nodes9[r_4681] = struct1("tag", "symbol", "contents", "nil", "var", builtinVars1["nil"])
				else
					removeNth_21_1(nodes9, r_4681)
				end
				r_4267["changed"] = true
			else
			end
			return r_4671((r_4681 + -1))
		else
		end
	end)
	return r_4671(nodes9["n"])
end))
stripArgs1 = struct1("name", "strip-args", "help", "Strip all unused, pure arguments in directly called lambdas.", "cat", ({tag = "list", n = 2, "opt", "usage"}), "run", (function(r_4268, state14, nodes10, lookup4)
	return visitBlock1(nodes10, 1, (function(node30)
		local temp57
		local r_4721 = (type1(node30) == "list")
		if r_4721 then
			local r_4731
			local x31 = car1(node30)
			r_4731 = (type1(x31) == "list")
			if r_4731 then
				local r_4741
				local x32 = car1(car1(node30))
				r_4741 = (type1(x32) == "symbol")
				temp57 = r_4741 and (car1(car1(node30))["var"] == builtins1["lambda"])
			else
				temp57 = r_4731
			end
		else
			temp57 = r_4721
		end
		if temp57 then
			local lam2 = car1(node30)
			local args6 = lam2[2]
			local offset2 = 1
			local remOffset1 = 0
			local r_4771 = args6["n"]
			local r_4751 = nil
			r_4751 = (function(r_4761)
				if (r_4761 <= r_4771) then
					local arg21
					local idx24 = (r_4761 - remOffset1)
					arg21 = args6[idx24]
					local val14
					local idx25 = ((r_4761 + offset2) - remOffset1)
					val14 = node30[idx25]
					if arg21["var"]["isVariadic"] then
						local count2 = (node30["n"] - args6["n"])
						if (count2 < 0) then
							count2 = 0
						else
						end
						offset2 = count2
					elseif (nil == val14) then
					elseif sideEffect_3f_1(val14) then
					elseif ((function(x33)
						return x33["n"]
					end)(getVar1(lookup4, arg21["var"])["usages"]) > 0) then
					else
						r_4268["changed"] = true
						removeNth_21_1(args6, (r_4761 - remOffset1))
						removeNth_21_1(node30, ((r_4761 + offset2) - remOffset1))
						remOffset1 = (remOffset1 + 1)
					end
					return r_4751((r_4761 + 1))
				else
				end
			end)
			return r_4751(1)
		else
		end
	end))
end))
variableFold1 = struct1("name", "variable-fold", "help", "Folds variables", "cat", ({tag = "list", n = 2, "opt", "usage"}), "run", (function(r_4269, state15, nodes11, lookup5)
	return traverseList1(nodes11, 1, (function(node31)
		if (type1(node31) == "symbol") then
			local var7 = getConstantVal1(lookup5, node31)
			if var7 and (var7 ~= node31) then
				r_4269["changed"] = true
				return var7
			else
				return node31
			end
		else
			return node31
		end
	end))
end))
scope_2f_child1 = require1("tacky.analysis.scope")["child"]
scope_2f_add_21_1 = require1("tacky.analysis.scope")["add"]
copyOf1 = (function(x34)
	local res3 = ({})
	iterPairs1(x34, (function(k1, v2)
		res3[k1] = v2
		return nil
	end))
	return res3
end)
getScope1 = (function(scope1, lookup6, n1)
	local newScope1 = lookup6["scopes"][scope1]
	if newScope1 then
		return newScope1
	else
		local newScope2 = scope_2f_child1()
		lookup6["scopes"][scope1] = newScope2
		return newScope2
	end
end)
getVar2 = (function(var8, lookup7)
	local r_4801 = lookup7["vars"][var8]
	return r_4801 or var8
end)
copyNode1 = (function(node32, lookup8)
	local r_4811 = type1(node32)
	if (r_4811 == "string") then
		return copyOf1(node32)
	elseif (r_4811 == "key") then
		return copyOf1(node32)
	elseif (r_4811 == "number") then
		return copyOf1(node32)
	elseif (r_4811 == "symbol") then
		local copy1 = copyOf1(node32)
		local oldVar1 = node32["var"]
		local newVar1 = getVar2(oldVar1, lookup8)
		local temp58
		local r_4821 = (oldVar1 ~= newVar1)
		temp58 = r_4821 and (oldVar1["node"] == node32)
		if temp58 then
			newVar1["node"] = copy1
		else
		end
		copy1["var"] = newVar1
		return copy1
	elseif (r_4811 == "list") then
		if builtin_3f_1(car1(node32), "lambda") then
			local args7 = car1(cdr1(node32))
			if nil_3f_1(args7) then
			else
				local newScope3 = scope_2f_child1(getScope1(car1(args7)["var"]["scope"], lookup8, node32))
				local r_4951 = args7["n"]
				local r_4931 = nil
				r_4931 = (function(r_4941)
					if (r_4941 <= r_4951) then
						local arg22 = args7[r_4941]
						local var9 = arg22["var"]
						local newVar2 = scope_2f_add_21_1(newScope3, var9["name"], var9["tag"], nil)
						newVar2["isVariadic"] = var9["isVariadic"]
						lookup8["vars"][var9] = newVar2
						return r_4931((r_4941 + 1))
					else
					end
				end)
				r_4931(1)
			end
		else
		end
		local res4 = copyOf1(node32)
		local r_4991 = res4["n"]
		local r_4971 = nil
		r_4971 = (function(r_4981)
			if (r_4981 <= r_4991) then
				res4[r_4981] = copyNode1(res4[r_4981], lookup8)
				return r_4971((r_4981 + 1))
			else
			end
		end)
		r_4971(1)
		return res4
	else
		return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_4811), ", but none matched.\n", "  Tried: `\"string\"`\n  Tried: `\"key\"`\n  Tried: `\"number\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`"))
	end
end)
scoreNode1 = (function(node33)
	local r_4831 = type1(node33)
	if (r_4831 == "string") then
		return 0
	elseif (r_4831 == "key") then
		return 0
	elseif (r_4831 == "number") then
		return 0
	elseif (r_4831 == "symbol") then
		return 1
	elseif (r_4831 == "list") then
		local r_4841 = type1(car1(node33))
		if (r_4841 == "symbol") then
			local func5 = car1(node33)["var"]
			if (func5 == builtins1["lambda"]) then
				return scoreNodes1(node33, 3, 10)
			elseif (func5 == builtins1["cond"]) then
				return scoreNodes1(node33, 2, 10)
			elseif (func5 == builtins1["set!"]) then
				return scoreNodes1(node33, 2, 5)
			elseif (func5 == builtins1["quote"]) then
				return scoreNodes1(node33, 2, 2)
			elseif (func5 == builtins1["quasi-quote"]) then
				return scoreNodes1(node33, 2, 3)
			elseif (func5 == builtins1["unquote-splice"]) then
				return scoreNodes1(node33, 2, 10)
			else
				return scoreNodes1(node33, 1, (node33["n"] + 1))
			end
		else
			return scoreNodes1(node33, 1, (node33["n"] + 1))
		end
	else
		return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_4831), ", but none matched.\n", "  Tried: `\"string\"`\n  Tried: `\"key\"`\n  Tried: `\"number\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`"))
	end
end)
getScore1 = (function(lookup9, node34)
	local score1 = lookup9[node34]
	if (score1 == nil) then
		score1 = 0
		local r_4861 = node34[2]
		local r_4891 = r_4861["n"]
		local r_4871 = nil
		r_4871 = (function(r_4881)
			if (r_4881 <= r_4891) then
				local arg23 = r_4861[r_4881]
				if arg23["var"]["isVariadic"] then
					score1 = false
				else
				end
				return r_4871((r_4881 + 1))
			else
			end
		end)
		r_4871(1)
		if score1 then
			score1 = scoreNodes1(node34, 3, score1)
		else
		end
		lookup9[node34] = score1
	else
	end
	return score1 or huge1
end)
scoreNodes1 = (function(nodes12, start5, sum1)
	if (start5 > nodes12["n"]) then
		return sum1
	else
		local score2 = scoreNode1(nodes12[start5])
		if score2 then
			if (score2 > 20) then
				return score2
			else
				return scoreNodes1(nodes12, (start5 + 1), (sum1 + score2))
			end
		else
			return false
		end
	end
end)
inline1 = struct1("name", "inline", "help", "Inline simple functions.", "cat", ({tag = "list", n = 2, "opt", "usage"}), "on", false, "run", (function(r_42610, state16, nodes13, usage2)
	local scoreLookup1 = ({})
	return visitBlock1(nodes13, 1, (function(node35)
		local temp59
		local r_5011 = (type1(node35) == "list")
		if r_5011 then
			local x35 = car1(node35)
			temp59 = (type1(x35) == "symbol")
		else
			temp59 = r_5011
		end
		if temp59 then
			local func6 = car1(node35)["var"]
			local def3 = getVar1(usage2, func6)
			if ((function(x36)
				return x36["n"]
			end)(def3["defs"]) == 1) then
				local ent2 = car1(def3["defs"])
				local val15 = ent2["value"]
				local temp60
				local r_5021 = (type1(val15) == "list")
				if r_5021 then
					local r_5031 = builtin_3f_1(car1(val15), "lambda")
					temp60 = r_5031 and (getScore1(scoreLookup1, val15) <= 20)
				else
					temp60 = r_5021
				end
				if temp60 then
					local copy2 = copyNode1(val15, struct1("scopes", ({}), "vars", ({}), "root", func6["scope"]))
					node35[1] = copy2
					r_42610["changed"] = true
					return nil
				else
				end
			else
			end
		else
		end
	end))
end))
optimiseOnce1 = (function(nodes14, state17)
	local tracker2 = struct1("changed", false)
	runPass1(stripImport1, state17, tracker2, nodes14)
	runPass1(stripPure1, state17, tracker2, nodes14)
	runPass1(constantFold1, state17, tracker2, nodes14)
	runPass1(condFold1, state17, tracker2, nodes14)
	runPass1(lambdaFold1, state17, tracker2, nodes14)
	local lookup10 = createState1()
	runPass1(tagUsage1, state17, tracker2, nodes14, lookup10)
	runPass1(stripDefs1, state17, tracker2, nodes14, lookup10)
	runPass1(stripArgs1, state17, tracker2, nodes14, lookup10)
	runPass1(variableFold1, state17, tracker2, nodes14, lookup10)
	runPass1(inline1, state17, tracker2, nodes14, lookup10)
	return tracker2["changed"]
end)
optimise1 = (function(nodes15, state18)
	local maxN1 = state18["max-n"]
	local maxT1 = state18["max-time"]
	local iteration1 = 0
	local finish1 = (clock1() + maxT1)
	local changed1 = true
	local r_2971 = nil
	r_2971 = (function()
		local temp61
		local r_2981 = changed1
		if r_2981 then
			local r_2991
			local r_5041 = (maxN1 < 0)
			r_2991 = r_5041 or (iteration1 < maxN1)
			if r_2991 then
				local r_3001 = (maxT1 < 0)
				temp61 = r_3001 or (clock1() < finish1)
			else
				temp61 = r_2991
			end
		else
			temp61 = r_2981
		end
		if temp61 then
			changed1 = optimiseOnce1(nodes15, state18)
			iteration1 = (iteration1 + 1)
			return r_2971()
		else
		end
	end)
	r_2971()
	return nodes15
end)
checkArity1 = struct1("name", "check-arity", "help", "Produce a warning if any NODE in NODES calls a function with too many arguments.\n\nLOOKUP is the variable usage lookup table.", "cat", ({tag = "list", n = 2, "warn", "usage"}), "run", (function(r_42611, state19, nodes16, lookup11)
	local arity1
	local getArity1
	arity1 = ({})
	getArity1 = (function(symbol1)
		local var10 = getVar1(lookup11, symbol1["var"])
		local ari1 = arity1[var10]
		if (ari1 ~= nil) then
			return ari1
		elseif ((function(x37)
			return x37["n"]
		end)(var10["defs"]) ~= 1) then
			return false
		else
			arity1[var10] = false
			local defData1 = car1(var10["defs"])
			local def4 = defData1["value"]
			if (defData1["tag"] == "arg") then
				ari1 = false
			else
				if (type1(def4) == "symbol") then
					ari1 = getArity1(def4)
				else
					local temp62
					local r_5051 = (type1(def4) == "list")
					if r_5051 then
						local r_5061
						local x38 = car1(def4)
						r_5061 = (type1(x38) == "symbol")
						temp62 = r_5061 and (car1(def4)["var"] == builtins1["lambda"])
					else
						temp62 = r_5051
					end
					if temp62 then
						local args8 = def4[2]
						if any1((function(x39)
							return x39["var"]["isVariadic"]
						end), args8) then
							ari1 = false
						else
							ari1 = args8["n"]
						end
					else
						ari1 = false
					end
				end
			end
			arity1[var10] = ari1
			return ari1
		end
	end)
	return visitBlock1(nodes16, 1, (function(node36)
		local temp63
		local r_5071 = (type1(node36) == "list")
		if r_5071 then
			local x40 = car1(node36)
			temp63 = (type1(x40) == "symbol")
		else
			temp63 = r_5071
		end
		if temp63 then
			local arity2 = getArity1(car1(node36))
			if arity2 and (arity2 < (function(x41)
				return (x41 - 1)
			end)(node36["n"])) then
				return putNodeWarning_21_1(state19["logger"], _2e2e_2("Calling ", symbol_2d3e_string1(car1(node36)), " with ", tonumber1((function(x42)
					return (x42 - 1)
				end)(node36["n"])), " arguments, expected ", tonumber1(arity2)), node36, nil, getSource1(node36), "Called here")
			else
			end
		else
		end
	end))
end))
analyse1 = (function(nodes17, state20)
	local lookup12 = createState1()
	runPass1(tagUsage1, state20, nil, nodes17, lookup12)
	runPass1(checkArity1, state20, nil, nodes17, lookup12)
	return nodes17
end)
create3 = (function()
	return struct1("out", ({tag = "list", n = 0}), "indent", 0, "tabs-pending", false, "line", 1, "lines", ({}), "node-stack", ({tag = "list", n = 0}), "active-pos", nil)
end)
append_21_1 = (function(writer1, text2)
	local r_5201 = type1(text2)
	if (r_5201 ~= "string") then
		error1(format1("bad argment %s (expected %s, got %s)", "text", "string", r_5201), 2)
	else
	end
	local pos7 = writer1["active-pos"]
	if pos7 then
		local line1 = writer1["lines"][writer1["line"]]
		if line1 then
		else
			line1 = ({})
			writer1["lines"][writer1["line"]] = line1
		end
		line1[pos7] = true
	else
	end
	if writer1["tabs-pending"] then
		writer1["tabs-pending"] = false
		pushCdr_21_1(writer1["out"], rep1("\9", writer1["indent"]))
	else
	end
	return pushCdr_21_1(writer1["out"], text2)
end)
line_21_1 = (function(writer2, text3, force1)
	if text3 then
		append_21_1(writer2, text3)
	else
	end
	local temp64
	if force1 then
		temp64 = force1
	else
		local expr14 = writer2["tabs-pending"]
		temp64 = not expr14
	end
	if temp64 then
		writer2["tabs-pending"] = true
		writer2["line"] = (function(x43)
			return (x43 + 1)
		end)(writer2["line"])
		return pushCdr_21_1(writer2["out"], "\n")
	else
	end
end)
indent_21_1 = (function(writer3)
	writer3["indent"] = (function(x44)
		return (x44 + 1)
	end)(writer3["indent"])
	return nil
end)
unindent_21_1 = (function(writer4)
	writer4["indent"] = (function(x45)
		return (x45 - 1)
	end)(writer4["indent"])
	return nil
end)
pushNode_21_1 = (function(writer5, node37)
	local range2 = getSource1(node37)
	if range2 then
		pushCdr_21_1(writer5["node-stack"], node37)
		writer5["active-pos"] = range2
		return nil
	else
	end
end)
popNode_21_1 = (function(writer6, node38)
	local range3 = getSource1(node38)
	if range3 then
		local stack1 = writer6["node-stack"]
		local previous1 = last1(stack1)
		if (previous1 == node38) then
		else
			error1("Incorrect node popped")
		end
		popLast_21_1(stack1)
		writer6["arg-pos"] = last1(stack1)
		return nil
	else
	end
end)
estimateLength1 = (function(node39, max4)
	local tag9 = node39["tag"]
	local temp65
	local r_5091 = (tag9 == "string")
	if r_5091 then
		temp65 = r_5091
	else
		local r_5101 = (tag9 == "number")
		if r_5101 then
			temp65 = r_5101
		else
			local r_5111 = (tag9 == "symbol")
			temp65 = r_5111 or (tag9 == "key")
		end
	end
	if temp65 then
		return len1(tostring1(node39["contents"]))
	elseif (tag9 == "list") then
		local sum2 = 2
		local i4 = 1
		local r_5121 = nil
		r_5121 = (function()
			local temp66
			local r_5131 = (sum2 <= max4)
			temp66 = r_5131 and (i4 <= node39["n"])
			if temp66 then
				sum2 = (sum2 + estimateLength1((function(idx26)
					return node39[idx26]
				end)(i4), (max4 - sum2)))
				if (i4 > 1) then
					sum2 = (sum2 + 1)
				else
				end
				i4 = (i4 + 1)
				return r_5121()
			else
			end
		end)
		r_5121()
		return sum2
	else
		local x46 = _2e2e_2("Unknown tag ", tag9)
		return error1(x46, 0)
	end
end)
expression1 = (function(node40, writer7)
	local tag10 = node40["tag"]
	if (tag10 == "string") then
		return append_21_1(writer7, quoted1(node40["value"]))
	elseif (tag10 == "number") then
		return append_21_1(writer7, tostring1(node40["value"]))
	elseif (tag10 == "key") then
		return append_21_1(writer7, _2e2e_2(":", node40["value"]))
	elseif (tag10 == "symbol") then
		return append_21_1(writer7, node40["contents"])
	elseif (tag10 == "list") then
		append_21_1(writer7, "(")
		if nil_3f_1(node40) then
			return append_21_1(writer7, ")")
		else
			local newline1 = false
			local max5 = (60 - estimateLength1(car1(node40), 60))
			expression1(car1(node40), writer7)
			if (max5 <= 0) then
				newline1 = true
				indent_21_1(writer7)
			else
			end
			local r_5241 = node40["n"]
			local r_5221 = nil
			r_5221 = (function(r_5231)
				if (r_5231 <= r_5241) then
					local entry2 = node40[r_5231]
					local temp67
					local r_5261
					local expr15 = newline1
					r_5261 = not expr15
					temp67 = r_5261 and (max5 > 0)
					if temp67 then
						max5 = (max5 - estimateLength1(entry2, max5))
						if (max5 <= 0) then
							newline1 = true
							indent_21_1(writer7)
						else
						end
					else
					end
					if newline1 then
						line_21_1(writer7)
					else
						append_21_1(writer7, " ")
					end
					expression1(entry2, writer7)
					return r_5221((r_5231 + 1))
				else
				end
			end)
			r_5221(2)
			if newline1 then
				unindent_21_1(writer7)
			else
			end
			return append_21_1(writer7, ")")
		end
	else
		local x47 = _2e2e_2("Unknown tag ", tag10)
		return error1(x47, 0)
	end
end)
block1 = (function(list2, writer8)
	local r_5181 = list2["n"]
	local r_5161 = nil
	r_5161 = (function(r_5171)
		if (r_5171 <= r_5181) then
			local node41 = list2[r_5171]
			expression1(node41, writer8)
			line_21_1(writer8)
			return r_5161((r_5171 + 1))
		else
		end
	end)
	return r_5161(1)
end)
cat2 = (function(category1, ...)
	local args9 = _pack(...) args9.tag = "list"
	return struct1("category", category1, unpack1(args9, 1, args9["n"]))
end)
partAll1 = (function(xs44, i5, e1, f4)
	if (i5 > e1) then
		return true
	elseif f4(xs44[i5]) then
		return partAll1(xs44, (i5 + 1), e1, f4)
	else
		return false
	end
end)
visitNode2 = (function(lookup13, node42, stmt1)
	local cat3
	local r_5361 = type1(node42)
	if (r_5361 == "string") then
		cat3 = cat2("const")
	elseif (r_5361 == "number") then
		cat3 = cat2("const")
	elseif (r_5361 == "key") then
		cat3 = cat2("const")
	elseif (r_5361 == "symbol") then
		cat3 = cat2("const")
	elseif (r_5361 == "list") then
		local head2 = car1(node42)
		local r_5371 = type1(head2)
		if (r_5371 == "symbol") then
			local func7 = head2["var"]
			local funct3 = func7["tag"]
			if (func7 == builtins1["lambda"]) then
				visitNodes1(lookup13, node42, 3, true)
				cat3 = cat2("lambda")
			elseif (func7 == builtins1["cond"]) then
				local r_5511 = node42["n"]
				local r_5491 = nil
				r_5491 = (function(r_5501)
					if (r_5501 <= r_5511) then
						local case3 = node42[r_5501]
						visitNode2(lookup13, car1(case3), true)
						visitNodes1(lookup13, case3, 2, true)
						return r_5491((r_5501 + 1))
					else
					end
				end)
				r_5491(2)
				local temp68
				local r_5531 = (node42["n"] == 3)
				if r_5531 then
					local r_5541
					local sub4 = node42[2]
					local r_5571 = (sub4["n"] == 2)
					r_5541 = r_5571 and builtinVar_3f_1(sub4[2], "false")
					if r_5541 then
						local sub5 = node42[3]
						local r_5551 = (sub5["n"] == 2)
						if r_5551 then
							local r_5561 = builtinVar_3f_1(sub5[1], "true")
							temp68 = r_5561 and builtinVar_3f_1(sub5[2], "true")
						else
							temp68 = r_5551
						end
					else
						temp68 = r_5541
					end
				else
					temp68 = r_5531
				end
				if temp68 then
					cat3 = cat2("not", "stmt", lookup13[car1(node42[2])]["stmt"])
				else
					local temp69
					local r_5581 = (node42["n"] == 3)
					if r_5581 then
						local first6 = node42[2]
						local second1 = node42[3]
						local r_5591 = (first6["n"] == 2)
						if r_5591 then
							local r_5601 = (second1["n"] == 2)
							if r_5601 then
								local r_5611
								local x48 = car1(first6)
								r_5611 = (type1(x48) == "symbol")
								if r_5611 then
									local r_5621
									local expr16 = lookup13[first6[2]]["stmt"]
									r_5621 = not expr16
									if r_5621 then
										local r_5631 = builtinVar_3f_1(car1(second1), "true")
										temp69 = r_5631 and eq_3f_1(car1(first6), second1[2])
									else
										temp69 = r_5621
									end
								else
									temp69 = r_5611
								end
							else
								temp69 = r_5601
							end
						else
							temp69 = r_5591
						end
					else
						temp69 = r_5581
					end
					if temp69 then
						cat3 = cat2("and")
					else
						local temp70
						local r_5641 = (node42["n"] >= 3)
						if r_5641 then
							local r_5651 = partAll1(node42, 2, (function(x49)
								return (x49 - 1)
							end)(node42["n"]), (function(branch1)
								local r_5681 = (branch1["n"] == 2)
								if r_5681 then
									local r_5691
									local x50 = car1(branch1)
									r_5691 = (type1(x50) == "symbol")
									return r_5691 and eq_3f_1(car1(branch1), branch1[2])
								else
									return r_5681
								end
							end))
							if r_5651 then
								local branch2 = last1(node42)
								local r_5661 = (branch2["n"] == 2)
								if r_5661 then
									local r_5671 = builtinVar_3f_1(car1(branch2), "true")
									if r_5671 then
										local expr17 = lookup13[branch2[2]]["stmt"]
										temp70 = not expr17
									else
										temp70 = r_5671
									end
								else
									temp70 = r_5661
								end
							else
								temp70 = r_5651
							end
						else
							temp70 = r_5641
						end
						if temp70 then
							cat3 = cat2("or")
						else
							cat3 = cat2("cond", "stmt", true)
						end
					end
				end
			elseif (func7 == builtins1["set!"]) then
				visitNode2(lookup13, node42[3], true)
				cat3 = cat2("set!")
			elseif (func7 == builtins1["quote"]) then
				cat3 = cat2("quote")
			elseif (func7 == builtins1["syntax-quote"]) then
				visitQuote2(lookup13, node42[2], 1)
				cat3 = cat2("syntax-quote")
			elseif (func7 == builtins1["unquote"]) then
				cat3 = error1("unquote should never appear", 0)
			elseif (func7 == builtins1["unquote-splice"]) then
				cat3 = error1("unquote should never appear", 0)
			elseif (func7 == builtins1["define"]) then
				visitNode2(lookup13, (function(idx27)
					return node42[idx27]
				end)(node42["n"]), true)
				cat3 = cat2("define")
			elseif (func7 == builtins1["define-macro"]) then
				visitNode2(lookup13, (function(idx28)
					return node42[idx28]
				end)(node42["n"]), true)
				cat3 = cat2("define")
			elseif (func7 == builtins1["define-native"]) then
				cat3 = cat2("define-native")
			elseif (func7 == builtins1["import"]) then
				cat3 = cat2("import")
			elseif (func7 == builtinVars1["true"]) then
				visitNodes1(lookup13, node42, 1, false)
				cat3 = cat2("call-literal")
			elseif (func7 == builtinVars1["false"]) then
				visitNodes1(lookup13, node42, 1, false)
				cat3 = cat2("call-literal")
			elseif (func7 == builtinVars1["nil"]) then
				visitNodes1(lookup13, node42, 1, false)
				cat3 = cat2("call-literal")
			else
				visitNodes1(lookup13, node42, 1, false)
				cat3 = cat2("call-symbol")
			end
		elseif (r_5371 == "list") then
			local temp71
			local r_5701 = (node42["n"] == 2)
			if r_5701 then
				local r_5711 = builtin_3f_1(car1(head2), "lambda")
				if r_5711 then
					local r_5721 = ((function(x51)
						return x51["n"]
					end)(head2[2]) == 1)
					if r_5721 then
						local r_5731
						local val16 = node42[2]
						local r_5791 = (type1(arg1) == "list")
						if r_5791 then
							local r_5801 = (val16["n"] == 1)
							r_5731 = r_5801 and eq_3f_1(car1(val16), ({ tag="symbol", contents="empty-struct"}))
						else
							r_5731 = r_5791
						end
						if r_5731 then
							local arg24 = car1(head2[2])
							local r_5741
							local expr18 = arg24["isVariadic"]
							r_5741 = not expr18
							if r_5741 then
								local r_5751 = eq_3f_1(arg24, last1(head2))
								temp71 = r_5751 and partAll1(head2, 3, (function(x52)
									return (x52 - 1)
								end)(head2["n"]), (function(node43)
									local r_5761 = (type1(node43) == "list")
									if r_5761 then
										local r_5771 = (node43["n"] == 4)
										if r_5771 then
											local r_5781 = eq_3f_1(car1(node43), ({ tag="symbol", contents="set-idx!"}))
											return r_5781 and eq_3f_1(node43[2], arg24)
										else
											return r_5771
										end
									else
										return r_5761
									end
								end))
							else
								temp71 = r_5741
							end
						else
							temp71 = r_5731
						end
					else
						temp71 = r_5721
					end
				else
					temp71 = r_5711
				end
			else
				temp71 = r_5701
			end
			if temp71 then
				visitNodes1(lookup13, car1(node42), 3, false)
				cat3 = cat2("make-struct")
			elseif stmt1 and builtin_3f_1(car1(head2), "lambda") then
				visitNodes1(lookup13, car1(node42), 3, true)
				local args10
				local xs45 = car1(node42)
				args10 = xs45[2]
				local offset3 = 1
				local r_5841 = args10["n"]
				local r_5821 = nil
				r_5821 = (function(r_5831)
					if (r_5831 <= r_5841) then
						local arg25 = args10[r_5831]
						if arg25["var"]["isVariadic"] then
							local count3 = (node42["n"] - args10["n"])
							if (count3 < 0) then
								count3 = 0
							else
							end
							local r_5881 = count3
							local r_5861 = nil
							r_5861 = (function(r_5871)
								if (r_5871 <= r_5881) then
									visitNode2(lookup13, (function(idx29)
										return node42[idx29]
									end)((r_5831 + r_5871)), false)
									return r_5861((r_5871 + 1))
								else
								end
							end)
							r_5861(1)
							offset3 = count3
						else
							local val17
							local idx30 = (r_5831 + offset3)
							val17 = node42[idx30]
							if val17 then
								visitNode2(lookup13, val17, true)
							else
							end
						end
						return r_5821((r_5831 + 1))
					else
					end
				end)
				r_5821(1)
				local r_5921 = node42["n"]
				local r_5901 = nil
				r_5901 = (function(r_5911)
					if (r_5911 <= r_5921) then
						visitNode2(lookup13, node42[r_5911], true)
						return r_5901((r_5911 + 1))
					else
					end
				end)
				r_5901((args10["n"] + (offset3 + 1)))
				cat3 = cat2("call-lambda", "stmt", true)
			else
				local temp72
				local r_5941 = builtin_3f_1(car1(head2), "quote")
				temp72 = r_5941 or builtin_3f_1(car1(head2), "syntax-quote")
				if temp72 then
					visitNodes1(lookup13, node42, 1, false)
					cat3 = cat2("call-literal")
				else
					visitNodes1(lookup13, node42, 1, false)
					cat3 = cat2("call")
				end
			end
		elseif eq_3f_1(r_5371, true) then
			visitNodes1(lookup13, node42, 1, false)
			cat3 = cat2("call-literal")
		else
			cat3 = error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_5371), ", but none matched.\n", "  Tried: `\"symbol\"`\n  Tried: `\"list\"`\n  Tried: `true`"))
		end
	else
		cat3 = error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_5361), ", but none matched.\n", "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"key\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`"))
	end
	lookup13[node42] = cat3
	return cat3
end)
visitNodes1 = (function(lookup14, nodes18, start6, stmt2)
	local r_5401 = nodes18["n"]
	local r_5381 = nil
	r_5381 = (function(r_5391)
		if (r_5391 <= r_5401) then
			visitNode2(lookup14, nodes18[r_5391], stmt2)
			return r_5381((r_5391 + 1))
		else
		end
	end)
	return r_5381(start6)
end)
visitQuote2 = (function(lookup15, node44, level4)
	if (level4 == 0) then
		return visitNode2(lookup15, node44, false)
	else
		if (type1(node44) == "list") then
			local r_5421 = car1(node44)
			if eq_3f_1(r_5421, ({ tag="symbol", contents="unquote"})) then
				return visitQuote2(lookup15, node44[2], (level4 - 1))
			elseif eq_3f_1(r_5421, ({ tag="symbol", contents="unquote-splice"})) then
				return visitQuote2(lookup15, node44[2], (level4 - 1))
			elseif eq_3f_1(r_5421, ({ tag="symbol", contents="syntax-quote"})) then
				return visitQuote2(lookup15, node44[2], (level4 + 1))
			else
				local r_5471 = node44["n"]
				local r_5451 = nil
				r_5451 = (function(r_5461)
					if (r_5461 <= r_5471) then
						local child1 = node44[r_5461]
						visitQuote2(lookup15, child1, level4)
						return r_5451((r_5461 + 1))
					else
					end
				end)
				return r_5451(1)
			end
		else
		end
	end
end)
categoriseNodes1 = struct1("name", "categorise-nodes", "help", "Categorise a group of NODES, annotating their appropriate node type.", "cat", ({tag = "list", n = 1, "categorise"}), "run", (function(r_42612, state21, nodes19, lookup16)
	return visitNodes1(lookup16, nodes19, 1, true)
end))
categoriseNode1 = struct1("name", "categorise-node", "help", "Categorise a NODE, annotating it's appropriate node type.", "cat", ({tag = "list", n = 1, "categorise"}), "run", (function(r_42613, state22, node45, lookup17, stmt3)
	return visitNode2(lookup17, node45, stmt3)
end))
createLookup1 = (function(...)
	local lst2 = _pack(...) lst2.tag = "list"
	local out6 = ({})
	local r_5991 = lst2["n"]
	local r_5971 = nil
	r_5971 = (function(r_5981)
		if (r_5981 <= r_5991) then
			local entry3 = lst2[r_5981]
			out6[entry3] = true
			return r_5971((r_5981 + 1))
		else
		end
	end)
	r_5971(1)
	return out6
end)
keywords1 = createLookup1("and", "break", "do", "else", "elseif", "end", "false", "for", "function", "if", "in", "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while")
escape1 = (function(name23)
	if keywords1[name23] then
		return _2e2e_2("_e", name23)
	elseif find1(name23, "^%w[_%w%d]*$") then
		return name23
	else
		local out7
		local temp73
		local r_6141 = sub1(name23, 1, 1)
		temp73 = find1(r_6141, "%d")
		if temp73 then
			out7 = "_e"
		else
			out7 = ""
		end
		local upper2 = false
		local esc1 = false
		local r_6031 = len1(name23)
		local r_6011 = nil
		r_6011 = (function(r_6021)
			if (r_6021 <= r_6031) then
				local char2 = sub1(name23, r_6021, r_6021)
				local temp74
				local r_6051 = (char2 == "-")
				if r_6051 then
					local r_6061
					local r_6101
					local x53 = (r_6021 - 1)
					r_6101 = sub1(name23, x53, x53)
					r_6061 = find1(r_6101, "[%a%d']")
					if r_6061 then
						local r_6081
						local x54 = (r_6021 + 1)
						r_6081 = sub1(name23, x54, x54)
						temp74 = find1(r_6081, "[%a%d']")
					else
						temp74 = r_6061
					end
				else
					temp74 = r_6051
				end
				if temp74 then
					upper2 = true
				elseif find1(char2, "[^%w%d]") then
					local r_6121
					local r_6111 = char2
					r_6121 = byte1(r_6111)
					char2 = format1("%02x", r_6121)
					if esc1 then
					else
						esc1 = true
						out7 = _2e2e_2(out7, "_")
					end
					out7 = _2e2e_2(out7, char2)
				else
					if esc1 then
						esc1 = false
						out7 = _2e2e_2(out7, "_")
					else
					end
					if upper2 then
						upper2 = false
						char2 = upper1(char2)
					else
					end
					out7 = _2e2e_2(out7, char2)
				end
				return r_6011((r_6021 + 1))
			else
			end
		end)
		r_6011(1)
		if esc1 then
			out7 = _2e2e_2(out7, "_")
		else
		end
		return out7
	end
end)
escapeVar1 = (function(var11, state23)
	if builtinVars1[var11] then
		return var11["name"]
	else
		local v3 = escape1(var11["name"])
		local id2 = state23["var-lookup"][var11]
		if id2 then
		else
			local x55
			local r_6151 = state23["ctr-lookup"][v3]
			x55 = r_6151 or 0
			id2 = (x55 + 1)
			state23["ctr-lookup"][v3] = id2
			state23["var-lookup"][var11] = id2
		end
		return _2e2e_2(v3, tostring1(id2))
	end
end)
truthy_3f_1 = (function(node46)
	local r_5311 = (type1(node46) == "symbol")
	return r_5311 and (builtinVars1["true"] == node46["var"])
end)
boringCategories1 = struct1("const", true, "quote", true, "not", true, "condtrue")
compileQuote1 = (function(node47, out8, state24, level5)
	if (level5 == 0) then
		return compileExpression1(node47, out8, state24)
	else
		local ty5 = type1(node47)
		if (ty5 == "string") then
			return append_21_1(out8, quoted1(node47["value"]))
		elseif (ty5 == "number") then
			return append_21_1(out8, tostring1(node47["value"]))
		elseif (ty5 == "symbol") then
			append_21_1(out8, _2e2e_2("({ tag=\"symbol\", contents=", quoted1(node47["contents"])))
			if node47["var"] then
				append_21_1(out8, _2e2e_2(", var=", quoted1(tostring1(node47["var"]))))
			else
			end
			return append_21_1(out8, "})")
		elseif (ty5 == "key") then
			return append_21_1(out8, _2e2e_2("({tag=\"key\", value=", quoted1(node47["value"]), "})"))
		elseif (ty5 == "list") then
			local first7 = car1(node47)
			local temp75
			local r_6161 = (type1(first7) == "symbol")
			if r_6161 then
				local r_6171 = (first7["var"] == builtins1["unquote"])
				temp75 = r_6171 or ("var" == builtins1["unquote-splice"])
			else
				temp75 = r_6161
			end
			if temp75 then
				return compileQuote1(node47[2], out8, state24, level5 and (level5 - 1))
			else
				local temp76
				local r_6191 = (type1(first7) == "symbol")
				temp76 = r_6191 and (first7["var"] == builtins1["syntax-quote"])
				if temp76 then
					return compileQuote1(node47[2], out8, state24, level5 and (level5 + 1))
				else
					pushNode_21_1(out8, node47)
					local containsUnsplice1 = false
					local r_6251 = node47["n"]
					local r_6231 = nil
					r_6231 = (function(r_6241)
						if (r_6241 <= r_6251) then
							local sub6 = node47[r_6241]
							local temp77
							local r_6271 = (type1(sub6) == "list")
							if r_6271 then
								local r_6281
								local x56 = car1(sub6)
								r_6281 = (type1(x56) == "symbol")
								temp77 = r_6281 and (sub6[1]["var"] == builtins1["unquote-splice"])
							else
								temp77 = r_6271
							end
							if temp77 then
								containsUnsplice1 = true
							else
							end
							return r_6231((r_6241 + 1))
						else
						end
					end)
					r_6231(1)
					if containsUnsplice1 then
						local offset4 = 0
						line_21_1(out8, "(function()")
						indent_21_1(out8)
						line_21_1(out8, "local _offset, _result, _temp = 0, {tag=\"list\",n=0}")
						local r_6311 = node47["n"]
						local r_6291 = nil
						r_6291 = (function(r_6301)
							if (r_6301 <= r_6311) then
								local sub7 = node47[r_6301]
								local temp78
								local r_6331 = (type1(sub7) == "list")
								if r_6331 then
									local r_6341
									local x57 = car1(sub7)
									r_6341 = (type1(x57) == "symbol")
									temp78 = r_6341 and (sub7[1]["var"] == builtins1["unquote-splice"])
								else
									temp78 = r_6331
								end
								if temp78 then
									offset4 = (offset4 + 1)
									append_21_1(out8, "_temp = ")
									compileQuote1(sub7[2], out8, state24, (level5 - 1))
									line_21_1(out8)
									line_21_1(out8, _2e2e_2("for _c = 1, _temp.n do _result[", tostring1((r_6301 - offset4)), " + _c + _offset] = _temp[_c] end"))
									line_21_1(out8, "_offset = _offset + _temp.n")
								else
									append_21_1(out8, _2e2e_2("_result[", tostring1((r_6301 - offset4)), " + _offset] = "))
									compileQuote1(sub7, out8, state24, level5)
									line_21_1(out8)
								end
								return r_6291((r_6301 + 1))
							else
							end
						end)
						r_6291(1)
						line_21_1(out8, _2e2e_2("_result.n = _offset + ", tostring1((node47["n"] - offset4))))
						line_21_1(out8, "return _result")
						unindent_21_1(out8)
						line_21_1(out8, "end)()")
					else
						append_21_1(out8, _2e2e_2("({tag = \"list\", n = ", tostring1(node47["n"])))
						local r_6391 = node47["n"]
						local r_6371 = nil
						r_6371 = (function(r_6381)
							if (r_6381 <= r_6391) then
								local sub8 = node47[r_6381]
								append_21_1(out8, ", ")
								compileQuote1(sub8, out8, state24, level5)
								return r_6371((r_6381 + 1))
							else
							end
						end)
						r_6371(1)
						append_21_1(out8, "})")
					end
					return popNode_21_1(out8, node47)
				end
			end
		else
			return error1(_2e2e_2("Unknown type ", ty5))
		end
	end
end)
compileExpression1 = (function(node48, out9, state25, ret1)
	local catLookup1 = state25["cat-lookup"]
	local cat4 = catLookup1[node48]
	local _5f_2
	if cat4 then
	else
		_5f_2 = print1("Cannot find", pretty1(node48), formatNode1(node48))
	end
	local catTag1 = cat4["category"]
	if boringCategories1[catTag1] then
	else
		pushNode_21_1(out9, node48)
	end
	if (catTag1 == "const") then
		if (ret1 == "") then
		else
			if ret1 then
				append_21_1(out9, ret1)
			else
			end
			if (type1(node48) == "symbol") then
				append_21_1(out9, escapeVar1(node48["var"], state25))
			elseif string_3f_1(node48) then
				append_21_1(out9, quoted1(node48["value"]))
			elseif number_3f_1(node48) then
				append_21_1(out9, tostring1(node48["value"]))
			elseif (type1(node48) == "key") then
				append_21_1(out9, quoted1(node48["value"]))
			else
				error1(_2e2e_2("Unknown type: ", type1(node48)))
			end
		end
	elseif (catTag1 == "lambda") then
		if (ret1 == "") then
		else
			if ret1 then
				append_21_1(out9, ret1)
			else
			end
			local args11 = node48[2]
			local variadic1 = nil
			local i6 = 1
			append_21_1(out9, "(function(")
			local r_6421 = nil
			r_6421 = (function()
				local temp79
				local r_6431 = (i6 <= args11["n"])
				if r_6431 then
					local expr19 = variadic1
					temp79 = not expr19
				else
					temp79 = r_6431
				end
				if temp79 then
					if (i6 > 1) then
						append_21_1(out9, ", ")
					else
					end
					local var12 = args11[i6]["var"]
					if var12["isVariadic"] then
						append_21_1(out9, "...")
						variadic1 = i6
					else
						append_21_1(out9, escapeVar1(var12, state25))
					end
					i6 = (i6 + 1)
					return r_6421()
				else
				end
			end)
			r_6421()
			line_21_1(out9, ")")
			indent_21_1(out9)
			if variadic1 then
				local argsVar1 = escapeVar1(args11[variadic1]["var"], state25)
				if (variadic1 == args11["n"]) then
					line_21_1(out9, _2e2e_2("local ", argsVar1, " = _pack(...) ", argsVar1, ".tag = \"list\""))
				else
					local remaining1 = (args11["n"] - variadic1)
					line_21_1(out9, _2e2e_2("local _n = _select(\"#\", ...) - ", tostring1(remaining1)))
					append_21_1(out9, _2e2e_2("local ", argsVar1))
					local r_6461 = args11["n"]
					local r_6441 = nil
					r_6441 = (function(r_6451)
						if (r_6451 <= r_6461) then
							append_21_1(out9, ", ")
							append_21_1(out9, escapeVar1(args11[r_6451]["var"], state25))
							return r_6441((r_6451 + 1))
						else
						end
					end)
					r_6441((function(x58)
						return (x58 + 1)
					end)(variadic1))
					line_21_1(out9)
					line_21_1(out9, "if _n > 0 then")
					indent_21_1(out9)
					append_21_1(out9, argsVar1)
					line_21_1(out9, " = { tag=\"list\", n=_n, _unpack(_pack(...), 1, _n)}")
					local r_6501 = args11["n"]
					local r_6481 = nil
					r_6481 = (function(r_6491)
						if (r_6491 <= r_6501) then
							append_21_1(out9, escapeVar1(args11[r_6491]["var"], state25))
							if (r_6491 < args11["n"]) then
								append_21_1(out9, ", ")
							else
							end
							return r_6481((r_6491 + 1))
						else
						end
					end)
					r_6481((function(x59)
						return (x59 + 1)
					end)(variadic1))
					line_21_1(out9, " = select(_n + 1, ...)")
					unindent_21_1(out9)
					line_21_1(out9, "else")
					indent_21_1(out9)
					append_21_1(out9, argsVar1)
					line_21_1(out9, " = { tag=\"list\", n=0}")
					local r_6541 = args11["n"]
					local r_6521 = nil
					r_6521 = (function(r_6531)
						if (r_6531 <= r_6541) then
							append_21_1(out9, escapeVar1(args11[r_6531]["var"], state25))
							if (r_6531 < args11["n"]) then
								append_21_1(out9, ", ")
							else
							end
							return r_6521((r_6531 + 1))
						else
						end
					end)
					r_6521((function(x60)
						return (x60 + 1)
					end)(variadic1))
					line_21_1(out9, " = ...")
					unindent_21_1(out9)
					line_21_1(out9, "end")
				end
			else
			end
			compileBlock1(node48, out9, state25, 3, "return ")
			unindent_21_1(out9)
			append_21_1(out9, "end)")
		end
	elseif (catTag1 == "cond") then
		local closure1
		local expr20 = ret1
		closure1 = not expr20
		local hadFinal1 = false
		local ends1 = 1
		if closure1 then
			line_21_1(out9, "(function()")
			indent_21_1(out9)
			ret1 = "return "
		else
		end
		local i7 = 2
		local r_6561 = nil
		r_6561 = (function()
			local temp80
			local r_6571
			local expr21 = hadFinal1
			r_6571 = not expr21
			temp80 = r_6571 and (i7 <= node48["n"])
			if temp80 then
				local item1
				local idx31 = i7
				item1 = node48[idx31]
				local case4 = item1[1]
				local isFinal1 = truthy_3f_1(case4)
				if isFinal1 then
					if (i7 == 2) then
						append_21_1(out9, "do")
					else
					end
				elseif catLookup1[case4]["stmt"] then
					if (i7 > 2) then
						indent_21_1(out9)
						line_21_1(out9)
						ends1 = (ends1 + 1)
					else
					end
					local tmp1 = escapeVar1(struct1("name", "temp"), state25)
					line_21_1(out9, _2e2e_2("local ", tmp1))
					compileExpression1(case4, out9, state25, _2e2e_2(tmp1, " = "))
					line_21_1(out9)
					line_21_1(out9, _2e2e_2("if ", tmp1, " then"))
				else
					append_21_1(out9, "if ")
					compileExpression1(case4, out9, state25)
					append_21_1(out9, " then")
				end
				indent_21_1(out9)
				line_21_1(out9)
				compileBlock1(item1, out9, state25, 2, ret1)
				unindent_21_1(out9)
				if isFinal1 then
					hadFinal1 = true
				else
					append_21_1(out9, "else")
				end
				i7 = (i7 + 1)
				return r_6561()
			else
			end
		end)
		r_6561()
		if hadFinal1 then
		else
			indent_21_1(out9)
			line_21_1(out9)
			append_21_1(out9, "_error(\"unmatched item\")")
			unindent_21_1(out9)
			line_21_1(out9)
		end
		local r_6601 = ends1
		local r_6581 = nil
		r_6581 = (function(r_6591)
			if (r_6591 <= r_6601) then
				append_21_1(out9, "end")
				if (r_6591 < ends1) then
					unindent_21_1(out9)
					line_21_1(out9)
				else
				end
				return r_6581((r_6591 + 1))
			else
			end
		end)
		r_6581(1)
		if closure1 then
			line_21_1(out9)
			unindent_21_1(out9)
			line_21_1(out9, "end)()")
		else
		end
	elseif (catTag1 == "not") then
		if ret1 then
			ret1 = _2e2e_2(ret1, "not ")
		else
			append_21_1(out9, "not ")
		end
		compileExpression1(car1(node48[2]), out9, state25, ret1)
	elseif (catTag1 == "or") then
		if ret1 then
			append_21_1(out9, ret1)
		else
		end
		local r_6641 = node48["n"]
		local r_6621 = nil
		r_6621 = (function(r_6631)
			if (r_6631 <= r_6641) then
				if (r_6631 > 2) then
					append_21_1(out9, " or ")
				else
				end
				compileExpression1((function(xs46)
					return xs46[2]
				end)(node48[r_6631]), out9, state25)
				return r_6621((r_6631 + 1))
			else
			end
		end)
		r_6621(2)
	elseif (catTag1 == "and") then
		if ret1 then
			append_21_1(out9, ret1)
		else
		end
		compileExpression1((function(xs47)
			return xs47[1]
		end)(node48[2]), out9, state25)
		append_21_1(out9, " and ")
		compileExpression1((function(xs48)
			return xs48[2]
		end)(node48[2]), out9, state25)
	elseif (catTag1 == "set!") then
		compileExpression1(node48[3], out9, state25, _2e2e_2(escapeVar1(node48[2]["var"], state25), " = "))
		local temp81
		local r_6661 = ret1
		temp81 = r_6661 and (ret1 ~= "")
		if temp81 then
			line_21_1(out9)
			append_21_1(out9, ret1)
			append_21_1(out9, "nil")
		else
		end
	elseif (catTag1 == "make-struct") then
		if ret1 then
			append_21_1(out9, ret1)
		else
		end
		append_21_1(out9, "{")
		local body3 = car1(node48)
		local r_6691
		local x61 = body3["n"]
		r_6691 = (x61 - 1)
		local r_6671 = nil
		r_6671 = (function(r_6681)
			if (r_6681 <= r_6691) then
				if (r_6681 > 3) then
					append_21_1(out9, ",")
				else
				end
				local entry4 = body3[r_6681]
				append_21_1(out9, "[")
				compileExpression1(entry4[3], out9, state25)
				append_21_1(out9, "]=")
				compileExpression1(entry4[4], out9, state25)
				return r_6671((r_6681 + 1))
			else
			end
		end)
		r_6671(3)
		append_21_1(out9, "}")
	elseif (catTag1 == "define") then
		compileExpression1((function(idx32)
			return node48[idx32]
		end)(node48["n"]), out9, state25, _2e2e_2(escapeVar1(node48["defVar"], state25), " = "))
	elseif (catTag1 == "define-native") then
		local meta2 = state25["meta"][node48["defVar"]["fullName"]]
		local ty6 = type1(meta2)
		if (ty6 == "nil") then
			append_21_1(out9, format1("%s = _libs[%q]", escapeVar1(node48["defVar"], state25), node48["defVar"]["fullName"]))
		elseif (ty6 == "var") then
			append_21_1(out9, format1("%s = %s", escapeVar1(node48["defVar"], state25), meta2["contents"]))
		else
			local temp82
			local r_6711 = (ty6 == "expr")
			temp82 = r_6711 or (ty6 == "stmt")
			if temp82 then
				local count4 = meta2["count"]
				append_21_1(out9, format1("%s = function(", escapeVar1(node48["defVar"], state25)))
				local r_6721 = nil
				r_6721 = (function(r_6731)
					if (r_6731 <= count4) then
						if (r_6731 == 1) then
						else
							append_21_1(out9, ", ")
						end
						append_21_1(out9, _2e2e_2("v", tonumber1(r_6731)))
						return r_6721((r_6731 + 1))
					else
					end
				end)
				r_6721(1)
				append_21_1(out9, ") ")
				if (ty6 == "expr") then
					append_21_1(out9, "return ")
				else
				end
				local r_6771 = meta2["contents"]
				local r_6801 = r_6771["n"]
				local r_6781 = nil
				r_6781 = (function(r_6791)
					if (r_6791 <= r_6801) then
						local entry5 = r_6771[r_6791]
						if number_3f_1(entry5) then
							append_21_1(out9, _2e2e_2("v", tonumber1(entry5)))
						else
							append_21_1(out9, entry5)
						end
						return r_6781((r_6791 + 1))
					else
					end
				end)
				r_6781(1)
				append_21_1(out9, " end")
			else
				_error("unmatched item")
			end
		end
	elseif (catTag1 == "quote") then
		if (ret1 == "") then
		else
			if ret1 then
				append_21_1(out9, ret1)
			else
			end
			compileQuote1(node48[2], out9, state25)
		end
	elseif (catTag1 == "syntax-quote") then
		if (ret1 == "") then
			append_21_1(out9, "local _ =")
		elseif ret1 then
			append_21_1(out9, ret1)
		else
		end
		compileQuote1(node48[2], out9, state25, 1)
	elseif (catTag1 == "import") then
		if (ret1 == nil) then
			append_21_1(out9, "nil")
		elseif (ret1 ~= "") then
			append_21_1(out9, ret1)
			append_21_1(out9, "nil")
		else
		end
	elseif (catTag1 == "call-symbol") then
		local head3 = car1(node48)
		local meta3
		local r_6931 = (type1(head3) == "symbol")
		if r_6931 then
			local r_6941 = (head3["var"]["tag"] == "native")
			meta3 = r_6941 and state25["meta"][head3["var"]["fullName"]]
		else
			meta3 = r_6931
		end
		local metaTy1 = type1(meta3)
		if (metaTy1 == "nil") then
		elseif (metaTy1 == "boolean") then
		elseif (metaTy1 == "expr") then
		elseif (metaTy1 == "stmt") then
			if ret1 then
			else
				meta3 = nil
			end
		elseif (metaTy1 == "var") then
			meta3 = nil
		else
			_error("unmatched item")
		end
		local temp83
		local r_6821 = meta3
		temp83 = r_6821 and ((function(x62)
			return (x62 - 1)
		end)(node48["n"]) == meta3["count"])
		if temp83 then
			local temp84
			local r_6831 = ret1
			temp84 = r_6831 and (meta3["tag"] == "expr")
			if temp84 then
				append_21_1(out9, ret1)
			else
			end
			local contents1 = meta3["contents"]
			local r_6861 = contents1["n"]
			local r_6841 = nil
			r_6841 = (function(r_6851)
				if (r_6851 <= r_6861) then
					local entry6 = contents1[r_6851]
					if number_3f_1(entry6) then
						compileExpression1((function(idx33)
							return node48[idx33]
						end)((entry6 + 1)), out9, state25)
					else
						append_21_1(out9, entry6)
					end
					return r_6841((r_6851 + 1))
				else
				end
			end)
			r_6841(1)
			local temp85
			local r_6881 = (meta3["tag"] ~= "expr")
			temp85 = r_6881 and (ret1 ~= "")
			if temp85 then
				line_21_1(out9)
				append_21_1(out9, ret1)
				append_21_1(out9, "nil")
				line_21_1(out9)
			else
			end
		else
			if ret1 then
				append_21_1(out9, ret1)
			else
			end
			compileExpression1(head3, out9, state25)
			append_21_1(out9, "(")
			local r_6911 = node48["n"]
			local r_6891 = nil
			r_6891 = (function(r_6901)
				if (r_6901 <= r_6911) then
					if (r_6901 > 2) then
						append_21_1(out9, ", ")
					else
					end
					compileExpression1(node48[r_6901], out9, state25)
					return r_6891((r_6901 + 1))
				else
				end
			end)
			r_6891(2)
			append_21_1(out9, ")")
		end
	elseif (catTag1 == "call-lambda") then
		if (ret1 == nil) then
			print1(pretty1(node48), " marked as call-lambda for ", ret1)
		else
		end
		local head4 = car1(node48)
		local args12 = head4[2]
		local offset5 = 1
		local r_6971 = args12["n"]
		local r_6951 = nil
		r_6951 = (function(r_6961)
			if (r_6961 <= r_6971) then
				local var13 = args12[r_6961]["var"]
				local esc2 = escapeVar1(var13, state25)
				append_21_1(out9, _2e2e_2("local ", esc2))
				if var13["isVariadic"] then
					local count5 = (node48["n"] - args12["n"])
					if (count5 < 0) then
						count5 = 0
					else
					end
					local temp86
					local r_6991 = (count5 <= 0)
					temp86 = r_6991 or atom_3f_1((function(idx34)
						return node48[idx34]
					end)((r_6961 + count5)))
					if temp86 then
						append_21_1(out9, " = { tag=\"list\", n=")
						append_21_1(out9, tostring1(count5))
						local r_7021 = count5
						local r_7001 = nil
						r_7001 = (function(r_7011)
							if (r_7011 <= r_7021) then
								append_21_1(out9, ", ")
								compileExpression1((function(idx35)
									return node48[idx35]
								end)((r_6961 + r_7011)), out9, state25)
								return r_7001((r_7011 + 1))
							else
							end
						end)
						r_7001(1)
						line_21_1(out9, "}")
					else
						append_21_1(out9, " = _pack(")
						local r_7061 = count5
						local r_7041 = nil
						r_7041 = (function(r_7051)
							if (r_7051 <= r_7061) then
								if (r_7051 > 1) then
									append_21_1(out9, ", ")
								else
								end
								compileExpression1((function(idx36)
									return node48[idx36]
								end)((r_6961 + r_7051)), out9, state25)
								return r_7041((r_7051 + 1))
							else
							end
						end)
						r_7041(1)
						line_21_1(out9, ")")
						line_21_1(out9, _2e2e_2(esc2, ".tag = \"list\""))
					end
					offset5 = count5
				else
					local expr22
					local idx37 = (r_6961 + offset5)
					expr22 = node48[idx37]
					local name24 = escapeVar1(var13, state25)
					local ret2 = nil
					if expr22 then
						if catLookup1[expr22]["stmt"] then
							ret2 = _2e2e_2(name24, " = ")
							line_21_1(out9)
						else
							append_21_1(out9, " = ")
						end
						compileExpression1(expr22, out9, state25, ret2)
						line_21_1(out9)
					else
						line_21_1(out9)
					end
				end
				return r_6951((r_6961 + 1))
			else
			end
		end)
		r_6951(1)
		local r_7101 = node48["n"]
		local r_7081 = nil
		r_7081 = (function(r_7091)
			if (r_7091 <= r_7101) then
				compileExpression1(node48[r_7091], out9, state25, "")
				line_21_1(out9)
				return r_7081((r_7091 + 1))
			else
			end
		end)
		r_7081((args12["n"] + (offset5 + 1)))
		compileBlock1(head4, out9, state25, 3, ret1)
	elseif (catTag1 == "call-literal") then
		if ret1 then
			append_21_1(out9, ret1)
		else
		end
		append_21_1(out9, "(")
		compileExpression1(car1(node48), out9, state25)
		append_21_1(out9, ")(")
		local r_7141 = node48["n"]
		local r_7121 = nil
		r_7121 = (function(r_7131)
			if (r_7131 <= r_7141) then
				if (r_7131 > 2) then
					append_21_1(out9, ", ")
				else
				end
				compileExpression1(node48[r_7131], out9, state25)
				return r_7121((r_7131 + 1))
			else
			end
		end)
		r_7121(2)
		append_21_1(out9, ")")
	elseif (catTag1 == "call") then
		if ret1 then
			append_21_1(out9, ret1)
		else
		end
		compileExpression1(car1(node48), out9, state25)
		append_21_1(out9, "(")
		local r_7181 = node48["n"]
		local r_7161 = nil
		r_7161 = (function(r_7171)
			if (r_7171 <= r_7181) then
				if (r_7171 > 2) then
					append_21_1(out9, ", ")
				else
				end
				compileExpression1(node48[r_7171], out9, state25)
				return r_7161((r_7171 + 1))
			else
			end
		end)
		r_7161(2)
		append_21_1(out9, ")")
	else
		error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(catTag1), ", but none matched.\n", "  Tried: `\"const\"`\n  Tried: `\"lambda\"`\n  Tried: `\"cond\"`\n  Tried: `\"not\"`\n  Tried: `\"or\"`\n  Tried: `\"and\"`\n  Tried: `\"set!\"`\n  Tried: `\"make-struct\"`\n  Tried: `\"define\"`\n  Tried: `\"define-native\"`\n  Tried: `\"quote\"`\n  Tried: `\"syntax-quote\"`\n  Tried: `\"import\"`\n  Tried: `\"call-symbol\"`\n  Tried: `\"call-lambda\"`\n  Tried: `\"call-literal\"`\n  Tried: `\"call\"`"))
	end
	if boringCategories1[catTag1] then
	else
		return popNode_21_1(out9, node48)
	end
end)
compileBlock1 = (function(nodes20, out10, state26, start7, ret3)
	local r_5341 = nodes20["n"]
	local r_5321 = nil
	r_5321 = (function(r_5331)
		if (r_5331 <= r_5341) then
			local ret_27_1
			if (r_5331 == nodes20["n"]) then
				ret_27_1 = ret3
			else
				ret_27_1 = ""
			end
			compileExpression1(nodes20[r_5331], out10, state26, ret_27_1)
			line_21_1(out10)
			return r_5321((r_5331 + 1))
		else
		end
	end)
	return r_5321(start7)
end)
prelude1 = (function(out11)
	line_21_1(out11, "if not table.pack then table.pack = function(...) return { n = select(\"#\", ...), ... } end end")
	line_21_1(out11, "if not table.unpack then table.unpack = unpack end")
	line_21_1(out11, "local load = load if _VERSION:find(\"5.1\") then load = function(x, n, _, env) local f, e = loadstring(x, n) if not f then error(e, 2) end if env then setfenv(f, env) end return f end end")
	return line_21_1(out11, "local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error")
end)
expression2 = (function(node49, out12, state27, ret4)
	runPass1(categoriseNode1, state27, nil, node49, state27["cat-lookup"], (ret4 ~= nil))
	return compileExpression1(node49, out12, state27, ret4)
end)
block2 = (function(nodes21, out13, state28, start8, ret5)
	runPass1(categoriseNodes1, state28, nil, nodes21, state28["cat-lookup"])
	return compileBlock1(nodes21, out13, state28, start8, ret5)
end)
getinfo1 = debug.getinfo
sethook1 = debug.sethook
traceback1 = debug.traceback
unmangleIdent1 = (function(ident1)
	local esc3 = match1(ident1, "^(.-)%d+$")
	if (esc3 == nil) then
		return ident1
	elseif (sub1(esc3, 1, 2) == "_e") then
		return sub1(ident1, 3)
	else
		local buffer2 = ({tag = "list", n = 0})
		local pos8 = 0
		local len6 = len1(esc3)
		local r_7201 = nil
		r_7201 = (function()
			if (pos8 <= len6) then
				local char3
				local x63 = pos8
				char3 = sub1(esc3, x63, x63)
				if (char3 == "_") then
					local r_7211 = list1(find1(esc3, "^_[%da-z]+_", pos8))
					local temp87
					local r_7231 = (type1(r_7211) == "list")
					if r_7231 then
						local r_7241 = (r_7211["n"] >= 2)
						if r_7241 then
							local r_7251 = (r_7211["n"] <= 2)
							temp87 = r_7251 and true
						else
							temp87 = r_7241
						end
					else
						temp87 = r_7231
					end
					if temp87 then
						local start9 = r_7211[1]
						local _eend1 = r_7211[2]
						pos8 = (pos8 + 1)
						local r_7271 = nil
						r_7271 = (function()
							if (pos8 < _eend1) then
								pushCdr_21_1(buffer2, char1(tonumber1(sub1(esc3, pos8, (function(x64)
									return (x64 + 1)
								end)(pos8)), 16)))
								pos8 = (pos8 + 2)
								return r_7271()
							else
							end
						end)
						r_7271()
					else
						pushCdr_21_1(buffer2, "_")
					end
				elseif between_3f_1(char3, "A", "Z") then
					pushCdr_21_1(buffer2, "-")
					pushCdr_21_1(buffer2, lower1(char3))
				else
					pushCdr_21_1(buffer2, char3)
				end
				pos8 = (pos8 + 1)
				return r_7201()
			else
			end
		end)
		r_7201()
		return concat1(buffer2)
	end
end)
remapError1 = (function(msg22)
	local res5
	local r_7311
	local r_7301
	local r_7291 = gsub1(msg22, "local '([^']+)'", (function(x65)
		return _2e2e_2("local '", unmangleIdent1(x65), "'")
	end))
	r_7301 = gsub1(r_7291, "global '([^']+)'", (function(x66)
		return _2e2e_2("global '", unmangleIdent1(x66), "'")
	end))
	r_7311 = gsub1(r_7301, "upvalue '([^']+)'", (function(x67)
		return _2e2e_2("upvalue '", unmangleIdent1(x67), "'")
	end))
	res5 = gsub1(r_7311, "function '([^']+)'", (function(x68)
		return _2e2e_2("function '", unmangleIdent1(x68), "'")
	end))
	return res5
end)
remapMessage1 = (function(mappings1, msg23)
	local r_7321 = list1(match1(msg23, "^(.-):(%d+)(.*)$"))
	local temp88
	local r_7341 = (type1(r_7321) == "list")
	if r_7341 then
		local r_7351 = (r_7321["n"] >= 3)
		if r_7351 then
			local r_7361 = (r_7321["n"] <= 3)
			temp88 = r_7361 and true
		else
			temp88 = r_7351
		end
	else
		temp88 = r_7341
	end
	if temp88 then
		local file1 = r_7321[1]
		local line2 = r_7321[2]
		local extra1 = r_7321[3]
		local mapping1 = mappings1[file1]
		if mapping1 then
			local range4 = mapping1[tonumber1(line2)]
			if range4 then
				return _2e2e_2(range4, " (", file1, ":", line2, ")", remapError1(extra1))
			else
				return msg23
			end
		else
			return msg23
		end
	else
		return msg23
	end
end)
remapTraceback1 = (function(mappings2, msg24)
	local r_7451
	local r_7441
	local r_7431
	local r_7421
	local r_7411
	local r_7401 = gsub1(msg24, "^([^\n:]-:%d+:[^\n]*)", (function(r_7461)
		return remapMessage1(mappings2, r_7461)
	end))
	r_7411 = gsub1(r_7401, "\9([^\n:]-:%d+:)", (function(msg25)
		return _2e2e_2("\9", remapMessage1(mappings2, msg25))
	end))
	r_7421 = gsub1(r_7411, "<([^\n:]-:%d+)>\n", (function(msg26)
		return _2e2e_2("<", remapMessage1(mappings2, msg26), ">\n")
	end))
	r_7431 = gsub1(r_7421, "in local '([^']+)'\n", (function(x69)
		return _2e2e_2("in local '", unmangleIdent1(x69), "'\n")
	end))
	r_7441 = gsub1(r_7431, "in global '([^']+)'\n", (function(x70)
		return _2e2e_2("in global '", unmangleIdent1(x70), "'\n")
	end))
	r_7451 = gsub1(r_7441, "in upvalue '([^']+)'\n", (function(x71)
		return _2e2e_2("in upvalue '", unmangleIdent1(x71), "'\n")
	end))
	return gsub1(r_7451, "in function '([^']+)'\n", (function(x72)
		return _2e2e_2("in function '", unmangleIdent1(x72), "'\n")
	end))
end)
generateMappings1 = (function(lines4)
	local outLines1 = ({})
	iterPairs1(lines4, (function(line3, ranges1)
		local rangeLists1 = ({})
		iterPairs1(ranges1, (function(pos9)
			local file2 = pos9["name"]
			local rangeList1 = rangeLists1["file"]
			if rangeList1 then
			else
				rangeList1 = struct1("n", 0, "min", huge1, "max", (0 - huge1))
				rangeLists1[file2] = rangeList1
			end
			local r_7491 = pos9["finish"]["line"]
			local r_7471 = nil
			r_7471 = (function(r_7481)
				if (r_7481 <= r_7491) then
					if rangeList1[r_7481] then
					else
						rangeList1["n"] = (function(x73)
							return (x73 + 1)
						end)(rangeList1["n"])
						rangeList1[r_7481] = true
						if (r_7481 < rangeList1["min"]) then
							rangeList1["min"] = r_7481
						else
						end
						if (r_7481 > rangeList1["max"]) then
							rangeList1["max"] = r_7481
						else
						end
					end
					return r_7471((r_7481 + 1))
				else
				end
			end)
			return r_7471(pos9["start"]["line"])
		end))
		local bestName1 = nil
		local bestLines1 = nil
		local bestCount1 = 0
		iterPairs1(rangeLists1, (function(name25, lines5)
			if (lines5["n"] > bestCount1) then
				bestName1 = name25
				bestLines1 = lines5
				bestCount1 = lines5["n"]
				return nil
			else
			end
		end))
		outLines1[line3] = (function()
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
struct1("remapTraceback", remapTraceback1)
createState2 = (function(meta4)
	return struct1("level", 1, "override", ({}), "timer", void1, "count", 0, "mappings", ({}), "cat-lookup", ({}), "ctr-lookup", ({}), "var-lookup", ({}), "meta", meta4 or ({}))
end)
file3 = (function(compiler1, shebang1)
	local state29 = createState2(compiler1["libMeta"])
	local out14 = create3()
	if shebang1 then
		line_21_1(out14, _2e2e_2("#!/usr/bin/env ", shebang1))
	else
	end
	state29["trace"] = true
	prelude1(out14)
	line_21_1(out14, "local _libs = {}")
	local r_7731 = compiler1["libs"]
	local r_7761 = r_7731["n"]
	local r_7741 = nil
	r_7741 = (function(r_7751)
		if (r_7751 <= r_7761) then
			local lib1 = r_7731[r_7751]
			local prefix1 = quoted1(lib1["prefix"])
			local native1 = lib1["native"]
			if native1 then
				line_21_1(out14, "local _temp = (function()")
				local r_7791 = split1(native1, "\n")
				local r_7821 = r_7791["n"]
				local r_7801 = nil
				r_7801 = (function(r_7811)
					if (r_7811 <= r_7821) then
						local line4 = r_7791[r_7811]
						if (line4 ~= "") then
							append_21_1(out14, "\9")
							line_21_1(out14, line4)
						else
						end
						return r_7801((r_7811 + 1))
					else
					end
				end)
				r_7801(1)
				line_21_1(out14, "end)()")
				line_21_1(out14, _2e2e_2("for k, v in pairs(_temp) do _libs[", prefix1, ".. k] = v end"))
			else
			end
			return r_7741((r_7751 + 1))
		else
		end
	end)
	r_7741(1)
	local count6 = 0
	local r_7851 = compiler1["out"]
	local r_7881 = r_7851["n"]
	local r_7861 = nil
	r_7861 = (function(r_7871)
		if (r_7871 <= r_7881) then
			local node50 = r_7851[r_7871]
			local var14 = node50["defVar"]
			if var14 then
				count6 = (count6 + 1)
			else
			end
			return r_7861((r_7871 + 1))
		else
		end
	end)
	r_7861(1)
	if between_3f_1(count6, 1, 150) then
		append_21_1(out14, "local ")
		local first8 = true
		local r_7911 = compiler1["out"]
		local r_7941 = r_7911["n"]
		local r_7921 = nil
		r_7921 = (function(r_7931)
			if (r_7931 <= r_7941) then
				local node51 = r_7911[r_7931]
				local var15 = node51["defVar"]
				if var15 then
					if first8 then
						first8 = false
					else
						append_21_1(out14, ", ")
					end
					append_21_1(out14, escapeVar1(var15, state29))
				else
				end
				return r_7921((r_7931 + 1))
			else
			end
		end)
		r_7921(1)
		line_21_1(out14)
	else
	end
	block2(compiler1["out"], out14, state29, 1, "return ")
	return out14
end)
executeStates1 = (function(backState1, states1, global1, logger9)
	local stateList1 = ({tag = "list", n = 0})
	local nameList1 = ({tag = "list", n = 0})
	local exportList1 = ({tag = "list", n = 0})
	local escapeList1 = ({tag = "list", n = 0})
	local r_5271 = nil
	r_5271 = (function(r_5281)
		if (r_5281 >= 1) then
			local state30 = states1[r_5281]
			if (state30["stage"] == "executed") then
			else
				local node52
				if state30["node"] then
				else
					node52 = error1(_2e2e_2("State is in ", state30["stage"], " instead"), 0)
				end
				local var16
				local r_7961 = state30["var"]
				var16 = r_7961 or struct1("name", "temp")
				local escaped1 = escapeVar1(var16, backState1)
				local name26 = var16["name"]
				pushCdr_21_1(stateList1, state30)
				pushCdr_21_1(exportList1, _2e2e_2(escaped1, " = ", escaped1))
				pushCdr_21_1(nameList1, name26)
				pushCdr_21_1(escapeList1, escaped1)
			end
			return r_5271((r_5281 + -1))
		else
		end
	end)
	r_5271(states1["n"])
	if nil_3f_1(stateList1) then
	else
		local out15 = create3()
		local id3 = backState1["count"]
		local name27 = concat1(nameList1, ",")
		backState1["count"] = (id3 + 1)
		if (20 > len1(name27)) then
			name27 = _2e2e_2(sub1(name27, 1, 17), "...")
		else
		end
		name27 = _2e2e_2("compile#", id3, "{", name27, "}")
		prelude1(out15)
		line_21_1(out15, _2e2e_2("local ", concat1(escapeList1, ", ")))
		local r_7991 = stateList1["n"]
		local r_7971 = nil
		r_7971 = (function(r_7981)
			if (r_7981 <= r_7991) then
				local state31 = stateList1[r_7981]
				expression2(state31["node"], out15, backState1, (function()
					if state31["var"] then
						return ""
					else
						return _2e2e_2(escapeList1[r_7981], "= ")
					end
				end)()
				)
				line_21_1(out15)
				return r_7971((r_7981 + 1))
			else
			end
		end)
		r_7971(1)
		line_21_1(out15, _2e2e_2("return { ", concat1(exportList1, ", "), "}"))
		local str2 = concat1(out15["out"])
		backState1["mappings"][name27] = generateMappings1(out15["lines"])
		local r_8011 = list1(load1(str2, _2e2e_2("=", name27), "t", global1))
		local temp89
		local r_8041 = (type1(r_8011) == "list")
		if r_8041 then
			local r_8051 = (r_8011["n"] >= 2)
			if r_8051 then
				local r_8061 = (r_8011["n"] <= 2)
				if r_8061 then
					local r_8071 = eq_3f_1(r_8011[1], nil)
					temp89 = r_8071 and true
				else
					temp89 = r_8061
				end
			else
				temp89 = r_8051
			end
		else
			temp89 = r_8041
		end
		if temp89 then
			local msg27 = r_8011[2]
			local x74 = _2e2e_2(msg27, ":\n", str2)
			return error1(x74, 0)
		else
			local temp90
			local r_8081 = (type1(r_8011) == "list")
			if r_8081 then
				local r_8091 = (r_8011["n"] >= 1)
				if r_8091 then
					local r_8101 = (r_8011["n"] <= 1)
					temp90 = r_8101 and true
				else
					temp90 = r_8091
				end
			else
				temp90 = r_8081
			end
			if temp90 then
				local fun1 = r_8011[1]
				local r_8111 = list1(xpcall1(fun1, traceback1))
				local temp91
				local r_8141 = (type1(r_8111) == "list")
				if r_8141 then
					local r_8151 = (r_8111["n"] >= 2)
					if r_8151 then
						local r_8161 = (r_8111["n"] <= 2)
						if r_8161 then
							local r_8171 = eq_3f_1(r_8111[1], false)
							temp91 = r_8171 and true
						else
							temp91 = r_8161
						end
					else
						temp91 = r_8151
					end
				else
					temp91 = r_8141
				end
				if temp91 then
					local msg28 = r_8111[2]
					local x75 = remapTraceback1(backState1["mappings"], msg28)
					return error1(x75, 0)
				else
					local temp92
					local r_8181 = (type1(r_8111) == "list")
					if r_8181 then
						local r_8191 = (r_8111["n"] >= 2)
						if r_8191 then
							local r_8201 = (r_8111["n"] <= 2)
							if r_8201 then
								local r_8211 = eq_3f_1(r_8111[1], true)
								temp92 = r_8211 and true
							else
								temp92 = r_8201
							end
						else
							temp92 = r_8191
						end
					else
						temp92 = r_8181
					end
					if temp92 then
						local tbl1 = r_8111[2]
						local r_8241 = stateList1["n"]
						local r_8221 = nil
						r_8221 = (function(r_8231)
							if (r_8231 <= r_8241) then
								local state32 = stateList1[r_8231]
								local escaped2 = escapeList1[r_8231]
								local res6 = tbl1[escaped2]
								self1(state32, "executed", res6)
								if state32["var"] then
									global1[escaped2] = res6
								else
								end
								return r_8221((r_8231 + 1))
							else
							end
						end)
						return r_8221(1)
					else
						return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_8111), ", but none matched.\n", "  Tried: `(false ?msg)`\n  Tried: `(true ?tbl)`"))
					end
				end
			else
				return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_8011), ", but none matched.\n", "  Tried: `(nil ?msg)`\n  Tried: `(?fun)`"))
			end
		end
	end
end)
emitLua1 = struct1("name", "emit-lua", "setup", (function(spec6)
	addArgument_21_1(spec6, ({tag = "list", n = 1, "--emit-lua"}), "help", "Emit a Lua file.")
	addArgument_21_1(spec6, ({tag = "list", n = 1, "--shebang"}), "value", (function(r_8261)
		if r_8261 then
			return r_8261
		else
			local r_8271 = arg1[0]
			return r_8271 or "lua"
		end
	end)(arg1[-1]), "help", "Set the executable to use for the shebang.", "narg", "?")
	return addArgument_21_1(spec6, ({tag = "list", n = 1, "--chmod"}), "help", "Run chmod +x on the resulting file")
end), "pred", (function(args13)
	return args13["emit-lua"]
end), "run", (function(compiler2, args14)
	if nil_3f_1(args14["input"]) then
		local logger10 = compiler2["log"]
		self1(logger10, "put-error!", "No inputs to compile.")
		exit_21_1(1)
	else
	end
	local out16 = file3(compiler2, args14["shebang"])
	local handle1 = open1(_2e2e_2(args14["output"], ".lua"), "w")
	self1(handle1, "write", concat1(out16["out"]))
	self1(handle1, "close")
	if args14["chmod"] then
		return execute1(_2e2e_2("chmod +x ", quoted1(_2e2e_2(args14["output"], ".lua"))))
	else
	end
end))
emitLisp1 = struct1("name", "emit-lisp", "setup", (function(spec7)
	return addArgument_21_1(spec7, ({tag = "list", n = 1, "--emit-lisp"}), "help", "Emit a Lisp file.")
end), "pred", (function(args15)
	return args15["emit-lisp"]
end), "run", (function(compiler3, args16)
	if nil_3f_1(args16["input"]) then
		local logger11 = compiler3["log"]
		self1(logger11, "put-error!", "No inputs to compile.")
		exit_21_1(1)
	else
	end
	local writer9 = create3()
	block1(compiler3["out"], writer9)
	local handle2 = open1(_2e2e_2(args16["output"], ".lisp"), "w")
	self1(handle2, "write", concat1(writer9["out"]))
	return self1(handle2, "close")
end))
passArg1 = (function(arg26, data4, value10, usage_21_4)
	local val18 = tonumber1(value10)
	local name28 = _2e2e_2(arg26["name"], "-override")
	local override2 = data4[name28]
	if override2 then
	else
		override2 = ({})
		data4[name28] = override2
	end
	if val18 then
		data4[arg26["name"]] = val18
		return nil
	elseif (sub1(value10, 1, 1) == "-") then
		override2[sub1(value10, 2)] = false
		return nil
	elseif (sub1(value10, 1, 1) == "+") then
		override2[sub1(value10, 2)] = true
		return nil
	else
		return usage_21_4(_2e2e_2("Expected number or enable/disable flag for --", arg26["name"], " , got ", value10))
	end
end)
passRun1 = (function(fun2, name29)
	return (function(compiler4, args17)
		return fun2(compiler4["out"], struct1("track", true, "level", args17[name29], "override", (function(r_1951)
			return r_1951 or ({})
		end)(args17[_2e2e_2(name29, "-override")]), "max-n", args17[_2e2e_2(name29, "-n")], "max-time", args17[_2e2e_2(name29, "-time")], "meta", compiler4["libMeta"], "logger", compiler4["log"], "timer", compiler4["timer"]))
	end)
end)
warning1 = struct1("name", "warning", "setup", (function(spec8)
	return addArgument_21_1(spec8, ({tag = "list", n = 2, "--warning", "-W"}), "help", "Either the warning level to use or an enable/disable flag for a pass.", "default", 1, "narg", 1, "var", "LEVEL", "action", passArg1)
end), "pred", (function(args18)
	return (args18["warning"] > 0)
end), "run", passRun1(analyse1, "warning"))
optimise2 = struct1("name", "optimise", "setup", (function(spec9)
	addArgument_21_1(spec9, ({tag = "list", n = 2, "--optimise", "-O"}), "help", "Either the optimiation level to use or an enable/disable flag for a pass.", "default", 1, "narg", 1, "var", "LEVEL", "action", passArg1)
	addArgument_21_1(spec9, ({tag = "list", n = 2, "--optimise-n", "--optn"}), "help", "The maximum number of iterations the optimiser should run for.", "default", 10, "narg", 1, "action", setNumAction1)
	return addArgument_21_1(spec9, ({tag = "list", n = 2, "--optimise-time", "--optt"}), "help", "The maximum time the optimiser should run for.", "default", -1, "narg", 1, "action", setNumAction1)
end), "pred", (function(args19)
	return (args19["optimise"] > 0)
end), "run", passRun1(optimise1, "optimise"))
builtins4 = require1("tacky.analysis.resolve")["builtins"]
tokens1 = ({tag = "list", n = 7, ({tag = "list", n = 2, "arg", "(%f[%a]%u+%f[%A])"}), ({tag = "list", n = 2, "mono", "```[a-z]*\n([^`]*)\n```"}), ({tag = "list", n = 2, "mono", "`([^`]*)`"}), ({tag = "list", n = 2, "bolic", "(%*%*%*%w.-%w%*%*%*)"}), ({tag = "list", n = 2, "bold", "(%*%*%w.-%w%*%*)"}), ({tag = "list", n = 2, "italic", "(%*%w.-%w%*)"}), ({tag = "list", n = 2, "link", "%[%[(.-)%]%]"})})
extractSignature1 = (function(var17)
	local ty7 = type1(var17)
	local temp93
	local r_8351 = (ty7 == "macro")
	temp93 = r_8351 or (ty7 == "defined")
	if temp93 then
		local root1 = var17["node"]
		local node53
		local idx38 = root1["n"]
		node53 = root1[idx38]
		local temp94
		local r_8361 = (type1(node53) == "list")
		if r_8361 then
			local r_8371
			local x76 = car1(node53)
			r_8371 = (type1(x76) == "symbol")
			temp94 = r_8371 and (car1(node53)["var"] == builtins4["lambda"])
		else
			temp94 = r_8361
		end
		if temp94 then
			return node53[2]
		else
			return nil
		end
	else
		return nil
	end
end)
parseDocstring1 = (function(str3)
	local out17 = ({tag = "list", n = 0})
	local pos10 = 1
	local len7 = len1(str3)
	local r_8381 = nil
	r_8381 = (function()
		if (pos10 <= len7) then
			local spos1 = len7
			local epos1 = nil
			local name30 = nil
			local ptrn1 = nil
			local r_8431 = tokens1["n"]
			local r_8411 = nil
			r_8411 = (function(r_8421)
				if (r_8421 <= r_8431) then
					local tok1 = tokens1[r_8421]
					local npos1 = list1(find1(str3, tok1[2], pos10))
					local temp95
					local r_8451 = car1(npos1)
					temp95 = r_8451 and (car1(npos1) < spos1)
					if temp95 then
						spos1 = car1(npos1)
						epos1 = npos1[2]
						name30 = car1(tok1)
						ptrn1 = tok1[2]
					else
					end
					return r_8411((r_8421 + 1))
				else
				end
			end)
			r_8411(1)
			if name30 then
				if (pos10 < spos1) then
					pushCdr_21_1(out17, struct1("tag", "text", "contents", sub1(str3, pos10, (function(x77)
						return (x77 - 1)
					end)(spos1))))
				else
				end
				pushCdr_21_1(out17, struct1("tag", name30, "whole", sub1(str3, spos1, epos1), "contents", match1(sub1(str3, spos1, epos1), ptrn1)))
				local x78 = epos1
				pos10 = (x78 + 1)
			else
				pushCdr_21_1(out17, struct1("tag", "text", "contents", sub1(str3, pos10, len7)))
				pos10 = (len7 + 1)
			end
			return r_8381()
		else
		end
	end)
	r_8381()
	return out17
end)
Scope1 = require1("tacky.analysis.scope")
formatRange2 = (function(range5)
	return format1("%s:%s", range5["name"], (function(pos11)
		return _2e2e_2(pos11["line"], ":", pos11["column"])
	end)(range5["start"]))
end)
sortVars_21_1 = (function(list3)
	return sort1(list3, (function(a3, b3)
		return (car1(a3) < car1(b3))
	end))
end)
formatDefinition1 = (function(var18)
	local ty8 = type1(var18)
	if (ty8 == "builtin") then
		return "Builtin term"
	elseif (ty8 == "macro") then
		return _2e2e_2("Macro defined at ", formatRange2(getSource1(var18["node"])))
	elseif (ty8 == "native") then
		return _2e2e_2("Native defined at ", formatRange2(getSource1(var18["node"])))
	elseif (ty8 == "defined") then
		return _2e2e_2("Defined at ", formatRange2(getSource1(var18["node"])))
	else
		_error("unmatched item")
	end
end)
formatSignature1 = (function(name31, var19)
	local sig1 = extractSignature1(var19)
	if (sig1 == nil) then
		return name31
	elseif nil_3f_1(sig1) then
		return _2e2e_2("(", name31, ")")
	else
		return _2e2e_2("(", name31, " ", concat1((function(f5)
			return map1(f5, sig1)
		end)((function(r_8281)
			return r_8281["contents"]
		end)), " "), ")")
	end
end)
writeDocstring1 = (function(out18, str4, scope2)
	local r_8301 = parseDocstring1(str4)
	local r_8331 = r_8301["n"]
	local r_8311 = nil
	r_8311 = (function(r_8321)
		if (r_8321 <= r_8331) then
			local tok2 = r_8301[r_8321]
			local ty9 = type1(tok2)
			if (ty9 == "text") then
				append_21_1(out18, tok2["contents"])
			elseif (ty9 == "boldic") then
				append_21_1(out18, tok2["contents"])
			elseif (ty9 == "bold") then
				append_21_1(out18, tok2["contents"])
			elseif (ty9 == "italic") then
				append_21_1(out18, tok2["contents"])
			elseif (ty9 == "arg") then
				append_21_1(out18, _2e2e_2("`", tok2["contents"], "`"))
			elseif (ty9 == "mono") then
				append_21_1(out18, tok2["whole"])
			elseif (ty9 == "link") then
				local name32 = tok2["contents"]
				local ovar1 = Scope1["get"](scope2, name32)
				if ovar1 and ovar1["node"] then
					local loc1
					local r_8511
					local r_8501
					local r_8491
					local r_8481 = ovar1["node"]
					r_8491 = getSource1(r_8481)
					r_8501 = r_8491["name"]
					r_8511 = gsub1(r_8501, "%.lisp$", "")
					loc1 = gsub1(r_8511, "/", ".")
					local sig2 = extractSignature1(ovar1)
					local hash1
					if (sig2 == nil) then
						hash1 = ovar1["name"]
					elseif nil_3f_1(sig2) then
						hash1 = ovar1["name"]
					else
						hash1 = _2e2e_2(name32, " ", concat1((function(f6)
							return map1(f6, sig2)
						end)((function(r_8471)
							return r_8471["contents"]
						end)), " "))
					end
					append_21_1(out18, format1("[`%s`](%s.md#%s)", name32, loc1, gsub1(hash1, "%A+", "-")))
				else
					append_21_1(out18, format1("`%s`", name32))
				end
			else
				_error("unmatched item")
			end
			return r_8311((r_8321 + 1))
		else
		end
	end)
	r_8311(1)
	return line_21_1(out18)
end)
exported1 = (function(out19, title1, primary1, vars1, scope3)
	local documented1 = ({tag = "list", n = 0})
	local undocumented1 = ({tag = "list", n = 0})
	iterPairs1(vars1, (function(name33, var20)
		return pushCdr_21_1((function()
			if var20["doc"] then
				return documented1
			else
				return undocumented1
			end
		end)()
		, list1(name33, var20))
	end))
	sortVars_21_1(documented1)
	sortVars_21_1(undocumented1)
	line_21_1(out19, "---")
	line_21_1(out19, _2e2e_2("title: ", title1))
	line_21_1(out19, "---")
	line_21_1(out19, _2e2e_2("# ", title1))
	if primary1 then
		writeDocstring1(out19, primary1, scope3)
		line_21_1(out19, "", true)
	else
	end
	local r_8561 = documented1["n"]
	local r_8541 = nil
	r_8541 = (function(r_8551)
		if (r_8551 <= r_8561) then
			local entry7 = documented1[r_8551]
			local name34 = car1(entry7)
			local var21 = entry7[2]
			line_21_1(out19, _2e2e_2("## `", formatSignature1(name34, var21), "`"))
			line_21_1(out19, _2e2e_2("*", formatDefinition1(var21), "*"))
			line_21_1(out19, "", true)
			writeDocstring1(out19, var21["doc"], var21["scope"])
			line_21_1(out19, "", true)
			return r_8541((r_8551 + 1))
		else
		end
	end)
	r_8541(1)
	if nil_3f_1(undocumented1) then
	else
		line_21_1(out19, "## Undocumented symbols")
	end
	local r_8621 = undocumented1["n"]
	local r_8601 = nil
	r_8601 = (function(r_8611)
		if (r_8611 <= r_8621) then
			local entry8 = undocumented1[r_8611]
			local name35 = car1(entry8)
			local var22 = entry8[2]
			line_21_1(out19, _2e2e_2(" - `", formatSignature1(name35, var22), "` *", formatDefinition1(var22), "*"))
			return r_8601((r_8611 + 1))
		else
		end
	end)
	return r_8601(1)
end)
docs1 = (function(compiler5, args20)
	if nil_3f_1(args20["input"]) then
		local logger12 = compiler5["log"]
		self1(logger12, "put-error!", "No inputs to generate documentation for.")
		exit_21_1(1)
	else
	end
	local r_8651 = args20["input"]
	local r_8681 = r_8651["n"]
	local r_8661 = nil
	r_8661 = (function(r_8671)
		if (r_8671 <= r_8681) then
			local path1 = r_8651[r_8671]
			if (sub1(path1, -5) == ".lisp") then
				path1 = sub1(path1, 1, -6)
			else
			end
			local lib2 = compiler5["libCache"][path1]
			local writer10 = create3()
			exported1(writer10, lib2["name"], lib2["docs"], lib2["scope"]["exported"], lib2["scope"])
			local handle3 = open1(_2e2e_2(args20["docs"], "/", gsub1(path1, "/", "."), ".md"), "w")
			self1(handle3, "write", concat1(writer10["out"]))
			self1(handle3, "close")
			return r_8661((r_8671 + 1))
		else
		end
	end)
	return r_8661(1)
end)
task1 = struct1("name", "docs", "setup", (function(spec10)
	return addArgument_21_1(spec10, ({tag = "list", n = 1, "--docs"}), "help", "Specify the folder to emit documentation to.", "default", nil, "narg", 1)
end), "pred", (function(args21)
	return (nil ~= args21["docs"])
end), "run", docs1)
config1 = package.config
coloredAnsi1 = (function(col1, msg29)
	return _2e2e_2("\27[", col1, "m", msg29, "\27[0m")
end)
if config1 and (sub1(config1, 1, 1) ~= "\\") then
	colored_3f_1 = true
elseif getenv1 and (getenv1("ANSICON") ~= nil) then
	colored_3f_1 = true
else
	local temp96
	if getenv1 then
		local term1 = getenv1("TERM")
		if term1 then
			temp96 = find1(term1, "xterm")
		else
			temp96 = nil
		end
	else
		temp96 = getenv1
	end
	if temp96 then
		colored_3f_1 = true
	else
		colored_3f_1 = false
	end
end
if colored_3f_1 then
	colored1 = coloredAnsi1
else
	colored1 = (function(col2, msg30)
		return msg30
	end)
end
create4 = coroutine.create
resume1 = coroutine.resume
status1 = coroutine.status
hexDigit_3f_1 = (function(char4)
	local r_8751 = between_3f_1(char4, "0", "9")
	if r_8751 then
		return r_8751
	else
		local r_8761 = between_3f_1(char4, "a", "f")
		return r_8761 or between_3f_1(char4, "A", "F")
	end
end)
binDigit_3f_1 = (function(char5)
	local r_8771 = (char5 == "0")
	return r_8771 or (char5 == "1")
end)
terminator_3f_1 = (function(char6)
	local r_8781 = (char6 == "\n")
	if r_8781 then
		return r_8781
	else
		local r_8791 = (char6 == " ")
		if r_8791 then
			return r_8791
		else
			local r_8801 = (char6 == "\9")
			if r_8801 then
				return r_8801
			else
				local r_8811 = (char6 == "(")
				if r_8811 then
					return r_8811
				else
					local r_8821 = (char6 == ")")
					if r_8821 then
						return r_8821
					else
						local r_8831 = (char6 == "[")
						if r_8831 then
							return r_8831
						else
							local r_8841 = (char6 == "]")
							if r_8841 then
								return r_8841
							else
								local r_8851 = (char6 == "{")
								if r_8851 then
									return r_8851
								else
									local r_8861 = (char6 == "}")
									return r_8861 or (char6 == "")
								end
							end
						end
					end
				end
			end
		end
	end
end)
digitError_21_1 = (function(logger13, pos12, name36, char7)
	return doNodeError_21_1(logger13, format1("Expected %s digit, got %s", name36, (function()
		if (char7 == "") then
			return "eof"
		else
			return quoted1(char7)
		end
	end)()
	), pos12, nil, pos12, "Invalid digit here")
end)
lex1 = (function(logger14, str5, name37)
	str5 = gsub1(str5, "\13\n?", "\n")
	local lines6 = split1(str5, "\n")
	local line5 = 1
	local column1 = 1
	local offset6 = 1
	local length1 = len1(str5)
	local out20 = ({tag = "list", n = 0})
	local consume_21_1 = (function()
		if ((function(xs49, x79)
			return sub1(xs49, x79, x79)
		end)(str5, offset6) == "\n") then
			line5 = (line5 + 1)
			column1 = 1
		else
			column1 = (column1 + 1)
		end
		offset6 = (offset6 + 1)
		return nil
	end)
	local position1 = (function()
		return {["line"]=line5,["column"]=column1,["offset"]=offset6}
	end)
	local range6 = (function(start10, finish2)
		return {["start"]=start10,["finish"]=finish2 or start10,["lines"]=lines6,["name"]=name37}
	end)
	local appendWith_21_1 = (function(data5, start11, finish3)
		local start12 = start11 or position1()
		local finish4 = finish3 or position1()
		data5["range"] = range6(start12, finish4)
		data5["contents"] = sub1(str5, start12["offset"], finish4["offset"])
		return pushCdr_21_1(out20, data5)
	end)
	local append_21_2 = (function(tag11, start13, finish5)
		return appendWith_21_1({["tag"]=tag11}, start13, finish5)
	end)
	local parseBase1 = (function(name38, p3, base1)
		local start14 = offset6
		local char8
		local xs50 = str5
		local x80 = offset6
		char8 = sub1(xs50, x80, x80)
		if p3(char8) then
		else
			digitError_21_1(logger14, range6(position1()), name38, char8)
		end
		local xs51 = str5
		local x81
		local x82 = offset6
		x81 = (x82 + 1)
		char8 = sub1(xs51, x81, x81)
		local r_9251 = nil
		r_9251 = (function()
			if p3(char8) then
				consume_21_1()
				local xs52 = str5
				local x83
				local x84 = offset6
				x83 = (x84 + 1)
				char8 = sub1(xs52, x83, x83)
				return r_9251()
			else
			end
		end)
		r_9251()
		return tonumber1(sub1(str5, start14, offset6), base1)
	end)
	local r_8871 = nil
	r_8871 = (function()
		if (offset6 <= length1) then
			local char9
			local xs53 = str5
			local x85 = offset6
			char9 = sub1(xs53, x85, x85)
			local temp97
			local r_8881 = (char9 == "\n")
			if r_8881 then
				temp97 = r_8881
			else
				local r_8891 = (char9 == "\9")
				temp97 = r_8891 or (char9 == " ")
			end
			if temp97 then
			elseif (char9 == "(") then
				appendWith_21_1({["tag"]="open",["close"]=")"})
			elseif (char9 == ")") then
				appendWith_21_1({["tag"]="close",["open"]="("})
			elseif (char9 == "[") then
				appendWith_21_1({["tag"]="open",["close"]="]"})
			elseif (char9 == "]") then
				appendWith_21_1({["tag"]="close",["open"]="["})
			elseif (char9 == "{") then
				appendWith_21_1({["tag"]="open",["close"]="}"})
			elseif (char9 == "}") then
				appendWith_21_1({["tag"]="close",["open"]="{"})
			elseif (char9 == "'") then
				append_21_2("quote")
			elseif (char9 == "`") then
				append_21_2("syntax-quote")
			elseif (char9 == "~") then
				append_21_2("quasiquote")
			elseif (char9 == ",") then
				if ((function(xs54, x86)
					return sub1(xs54, x86, x86)
				end)(str5, (function(x87)
					return (x87 + 1)
				end)(offset6)) == "@") then
					local start15 = position1()
					consume_21_1()
					append_21_2("unquote-splice", start15)
				else
					append_21_2("unquote")
				end
			elseif find1(str5, "^%-?%.?[0-9]", offset6) then
				local start16 = position1()
				local negative1 = (char9 == "-")
				if negative1 then
					consume_21_1()
					local xs55 = str5
					local x88 = offset6
					char9 = sub1(xs55, x88, x88)
				else
				end
				local val19
				local temp98
				local r_9051 = (char9 == "0")
				temp98 = r_9051 and ((function(xs56, x89)
					return sub1(xs56, x89, x89)
				end)(str5, (function(x90)
					return (x90 + 1)
				end)(offset6)) == "x")
				if temp98 then
					consume_21_1()
					consume_21_1()
					local res7 = parseBase1("hexadecimal", hexDigit_3f_1, 16)
					if negative1 then
						res7 = (0 - res7)
					else
					end
					val19 = res7
				else
					local temp99
					local r_9061 = (char9 == "0")
					temp99 = r_9061 and ((function(xs57, x91)
						return sub1(xs57, x91, x91)
					end)(str5, (function(x92)
						return (x92 + 1)
					end)(offset6)) == "b")
					if temp99 then
						consume_21_1()
						consume_21_1()
						local res8 = parseBase1("binary", binDigit_3f_1, 2)
						if negative1 then
							res8 = (0 - res8)
						else
						end
						val19 = res8
					else
						local r_9071 = nil
						r_9071 = (function()
							if between_3f_1((function(xs58, x93)
								return sub1(xs58, x93, x93)
							end)(str5, (function(x94)
								return (x94 + 1)
							end)(offset6)), "0", "9") then
								consume_21_1()
								return r_9071()
							else
							end
						end)
						r_9071()
						if ((function(xs59, x95)
							return sub1(xs59, x95, x95)
						end)(str5, (function(x96)
							return (x96 + 1)
						end)(offset6)) == ".") then
							consume_21_1()
							local r_9081 = nil
							r_9081 = (function()
								if between_3f_1((function(xs60, x97)
									return sub1(xs60, x97, x97)
								end)(str5, (function(x98)
									return (x98 + 1)
								end)(offset6)), "0", "9") then
									consume_21_1()
									return r_9081()
								else
								end
							end)
							r_9081()
						else
						end
						local xs61 = str5
						local x99
						local x100 = offset6
						x99 = (x100 + 1)
						char9 = sub1(xs61, x99, x99)
						local temp100
						local r_9091 = (char9 == "e")
						temp100 = r_9091 or (char9 == "E")
						if temp100 then
							consume_21_1()
							local xs62 = str5
							local x101
							local x102 = offset6
							x101 = (x102 + 1)
							char9 = sub1(xs62, x101, x101)
							local temp101
							local r_9101 = (char9 == "-")
							temp101 = r_9101 or (char9 == "+")
							if temp101 then
								consume_21_1()
							else
							end
							local r_9111 = nil
							r_9111 = (function()
								if between_3f_1((function(xs63, x103)
									return sub1(xs63, x103, x103)
								end)(str5, (function(x104)
									return (x104 + 1)
								end)(offset6)), "0", "9") then
									consume_21_1()
									return r_9111()
								else
								end
							end)
							r_9111()
						else
						end
						val19 = tonumber1(sub1(str5, start16["offset"], offset6))
					end
				end
				appendWith_21_1({["tag"]="number",["value"]=val19}, start16)
				local xs64 = str5
				local x105
				local x106 = offset6
				x105 = (x106 + 1)
				char9 = sub1(xs64, x105, x105)
				if terminator_3f_1(char9) then
				else
					consume_21_1()
					doNodeError_21_1(logger14, format1("Expected digit, got %s", (function()
						if (char9 == "") then
							return "eof"
						else
							return char9
						end
					end)()
					), range6(position1()), nil, range6(position1()), "Illegal character here. Are you missing whitespace?")
				end
			elseif (char9 == "\"") then
				local start17 = position1()
				local startCol1
				local x107 = column1
				startCol1 = (x107 + 1)
				local buffer3 = ({tag = "list", n = 0})
				consume_21_1()
				local xs65 = str5
				local x108 = offset6
				char9 = sub1(xs65, x108, x108)
				local r_9121 = nil
				r_9121 = (function()
					if (char9 ~= "\"") then
						if (column1 == 1) then
							local running3 = true
							local lineOff1 = offset6
							local r_9131 = nil
							r_9131 = (function()
								local temp102
								local r_9141 = running3
								temp102 = r_9141 and (column1 < startCol1)
								if temp102 then
									if (char9 == " ") then
										consume_21_1()
									elseif (char9 == "\n") then
										consume_21_1()
										pushCdr_21_1(buffer3, "\n")
										lineOff1 = offset6
									elseif (char9 == "") then
										running3 = false
									else
										putNodeWarning_21_1(logger14, format1("Expected leading indent, got %q", char9), range6(position1()), "You should try to align multi-line strings at the initial quote\nmark. This helps keep programs neat and tidy.", range6(start17), "String started with indent here", range6(position1()), "Mis-aligned character here")
										pushCdr_21_1(buffer3, sub1(str5, lineOff1, (function(x109)
											return (x109 - 1)
										end)(offset6)))
										running3 = false
									end
									local xs66 = str5
									local x110 = offset6
									char9 = sub1(xs66, x110, x110)
									return r_9131()
								else
								end
							end)
							r_9131()
						else
						end
						if (char9 == "") then
							local start18 = range6(start17)
							local finish6 = range6(position1())
							doNodeError_21_1(logger14, "Expected '\"', got eof", finish6, nil, start18, "string started here", finish6, "end of file here")
						elseif (char9 == "\\") then
							consume_21_1()
							local xs67 = str5
							local x111 = offset6
							char9 = sub1(xs67, x111, x111)
							if (char9 == "\n") then
							elseif (char9 == "a") then
								pushCdr_21_1(buffer3, "\7")
							elseif (char9 == "b") then
								pushCdr_21_1(buffer3, "\8")
							elseif (char9 == "f") then
								pushCdr_21_1(buffer3, "\12")
							elseif (char9 == "n") then
								pushCdr_21_1(buffer3, "\n")
							elseif (char9 == "r") then
								pushCdr_21_1(buffer3, "\13")
							elseif (char9 == "t") then
								pushCdr_21_1(buffer3, "\9")
							elseif (char9 == "v") then
								pushCdr_21_1(buffer3, "\11")
							elseif (char9 == "\"") then
								pushCdr_21_1(buffer3, "\"")
							elseif (char9 == "\\") then
								pushCdr_21_1(buffer3, "\\")
							else
								local temp103
								local r_9151 = (char9 == "x")
								if r_9151 then
									temp103 = r_9151
								else
									local r_9161 = (char9 == "X")
									temp103 = r_9161 or between_3f_1(char9, "0", "9")
								end
								if temp103 then
									local start19 = position1()
									local val20
									local temp104
									local r_9171 = (char9 == "x")
									temp104 = r_9171 or (char9 == "X")
									if temp104 then
										consume_21_1()
										local start20 = offset6
										if hexDigit_3f_1((function(xs68, x112)
											return sub1(xs68, x112, x112)
										end)(str5, offset6)) then
										else
											digitError_21_1(logger14, range6(position1()), "hexadecimal", (function(xs69, x113)
												return sub1(xs69, x113, x113)
											end)(str5, offset6))
										end
										if hexDigit_3f_1((function(xs70, x114)
											return sub1(xs70, x114, x114)
										end)(str5, (function(x115)
											return (x115 + 1)
										end)(offset6))) then
											consume_21_1()
										else
										end
										val20 = tonumber1(sub1(str5, start20, offset6), 16)
									else
										local start21 = position1()
										local ctr1 = 0
										local xs71 = str5
										local x116
										local x117 = offset6
										x116 = (x117 + 1)
										char9 = sub1(xs71, x116, x116)
										local r_9181 = nil
										r_9181 = (function()
											local temp105
											local r_9191 = (ctr1 < 2)
											temp105 = r_9191 and between_3f_1(char9, "0", "9")
											if temp105 then
												consume_21_1()
												local xs72 = str5
												local x118
												local x119 = offset6
												x118 = (x119 + 1)
												char9 = sub1(xs72, x118, x118)
												ctr1 = (ctr1 + 1)
												return r_9181()
											else
											end
										end)
										r_9181()
										val20 = tonumber1(sub1(str5, start21["offset"], offset6))
									end
									if (val20 >= 256) then
										doNodeError_21_1(logger14, "Invalid escape code", range6(start19()), nil, range6(start19(), position1), _2e2e_2("Must be between 0 and 255, is ", val20))
									else
									end
									pushCdr_21_1(buffer3, char1(val20))
								elseif (char9 == "") then
									doNodeError_21_1(logger14, "Expected escape code, got eof", range6(position1()), nil, range6(position1()), "end of file here")
								else
									doNodeError_21_1(logger14, "Illegal escape character", range6(position1()), nil, range6(position1()), "Unknown escape character")
								end
							end
						else
							pushCdr_21_1(buffer3, char9)
						end
						consume_21_1()
						local xs73 = str5
						local x120 = offset6
						char9 = sub1(xs73, x120, x120)
						return r_9121()
					else
					end
				end)
				r_9121()
				appendWith_21_1({["tag"]="string",["value"]=concat1(buffer3)}, start17)
			elseif (char9 == ";") then
				local r_9211 = nil
				r_9211 = (function()
					local temp106
					local r_9221 = (offset6 <= length1)
					temp106 = r_9221 and ((function(xs74, x121)
						return sub1(xs74, x121, x121)
					end)(str5, (function(x122)
						return (x122 + 1)
					end)(offset6)) ~= "\n")
					if temp106 then
						consume_21_1()
						return r_9211()
					else
					end
				end)
				r_9211()
			else
				local start22 = position1()
				local key8 = (char9 == ":")
				local xs75 = str5
				local x123
				local x124 = offset6
				x123 = (x124 + 1)
				char9 = sub1(xs75, x123, x123)
				local r_9231 = nil
				r_9231 = (function()
					local temp107
					local expr23 = terminator_3f_1(char9)
					temp107 = not expr23
					if temp107 then
						consume_21_1()
						local xs76 = str5
						local x125
						local x126 = offset6
						x125 = (x126 + 1)
						char9 = sub1(xs76, x125, x125)
						return r_9231()
					else
					end
				end)
				r_9231()
				if key8 then
					appendWith_21_1({["tag"]="key",["value"]=sub1(str5, (function(x127)
						return (x127 + 1)
					end)(start22["offset"]), offset6)}, start22)
				else
					append_21_2("symbol", start22)
				end
			end
			consume_21_1()
			return r_8871()
		else
		end
	end)
	r_8871()
	append_21_2("eof")
	return out20
end)
parse1 = (function(logger15, toks1)
	local head5 = ({tag = "list", n = 0})
	local stack2 = ({tag = "list", n = 0})
	local append_21_3 = (function(node54)
		pushCdr_21_1(head5, node54)
		node54["parent"] = head5
		return nil
	end)
	local push_21_1 = (function()
		local next1 = ({tag = "list", n = 0})
		pushCdr_21_1(stack2, head5)
		append_21_3(next1)
		head5 = next1
		return nil
	end)
	local pop_21_1 = (function()
		head5["open"] = nil
		head5["close"] = nil
		head5["auto-close"] = nil
		head5["last-node"] = nil
		head5 = last1(stack2)
		return popLast_21_1(stack2)
	end)
	local r_9011 = toks1["n"]
	local r_8991 = nil
	r_8991 = (function(r_9001)
		if (r_9001 <= r_9011) then
			local tok3 = toks1[r_9001]
			local tag12 = tok3["tag"]
			local autoClose1 = false
			local previous2 = head5["last-node"]
			local tokPos1 = tok3["range"]
			local temp108
			local r_9031 = (tag12 ~= "eof")
			if r_9031 then
				local r_9041 = (tag12 ~= "close")
				if r_9041 then
					if head5["range"] then
						temp108 = (tokPos1["start"]["line"] ~= head5["range"]["start"]["line"])
					else
						temp108 = true
					end
				else
					temp108 = r_9041
				end
			else
				temp108 = r_9031
			end
			if temp108 then
				if previous2 then
					local prevPos1 = previous2["range"]
					if (tokPos1["start"]["line"] ~= prevPos1["start"]["line"]) then
						head5["last-node"] = tok3
						if (tokPos1["start"]["column"] ~= prevPos1["start"]["column"]) then
							putNodeWarning_21_1(logger15, "Different indent compared with previous expressions.", tok3, "You should try to maintain consistent indentation across a program,\ntry to ensure all expressions are lined up.\nIf this looks OK to you, check you're not missing a closing ')'.", prevPos1, "", tokPos1, "")
						else
						end
					else
					end
				else
					head5["last-node"] = tok3
				end
			else
			end
			local temp109
			local r_9321 = (tag12 == "string")
			if r_9321 then
				temp109 = r_9321
			else
				local r_9331 = (tag12 == "number")
				if r_9331 then
					temp109 = r_9331
				else
					local r_9341 = (tag12 == "symbol")
					temp109 = r_9341 or (tag12 == "key")
				end
			end
			if temp109 then
				append_21_3(tok3)
			elseif (tag12 == "open") then
				push_21_1()
				head5["open"] = tok3["contents"]
				head5["close"] = tok3["close"]
				head5["range"] = {["start"]=tok3["range"]["start"],["name"]=tok3["range"]["name"],["lines"]=tok3["range"]["lines"]}
			elseif (tag12 == "close") then
				if nil_3f_1(stack2) then
					doNodeError_21_1(logger15, format1("'%s' without matching '%s'", tok3["contents"], tok3["open"]), tok3, nil, getSource1(tok3), "")
				elseif head5["auto-close"] then
					doNodeError_21_1(logger15, format1("'%s' without matching '%s' inside quote", tok3["contents"], tok3["open"]), tok3, nil, head5["range"], "quote opened here", tok3["range"], "attempting to close here")
				elseif (head5["close"] ~= tok3["contents"]) then
					doNodeError_21_1(logger15, format1("Expected '%s', got '%s'", head5["close"], tok3["contents"]), tok3, nil, head5["range"], format1("block opened with '%s'", head5["open"]), tok3["range"], format1("'%s' used here", tok3["contents"]))
				else
					head5["range"]["finish"] = tok3["range"]["finish"]
					pop_21_1()
				end
			else
				local temp110
				local r_9361 = (tag12 == "quote")
				if r_9361 then
					temp110 = r_9361
				else
					local r_9371 = (tag12 == "unquote")
					if r_9371 then
						temp110 = r_9371
					else
						local r_9381 = (tag12 == "syntax-quote")
						if r_9381 then
							temp110 = r_9381
						else
							local r_9391 = (tag12 == "unquote-splice")
							temp110 = r_9391 or (tag12 == "quasiquote")
						end
					end
				end
				if temp110 then
					push_21_1()
					head5["range"] = {["start"]=tok3["range"]["start"],["name"]=tok3["range"]["name"],["lines"]=tok3["range"]["lines"]}
					append_21_3({["tag"]="symbol",["contents"]=tag12,["range"]=tok3["range"]})
					autoClose1 = true
					head5["auto-close"] = true
				elseif (tag12 == "eof") then
					if (0 ~= stack2["n"]) then
						doNodeError_21_1(logger15, "Expected ')', got eof", tok3, nil, head5["range"], "block opened here", tok3["range"], "end of file here")
					else
					end
				else
					error1(_2e2e_2("Unsupported type", tag12))
				end
			end
			if autoClose1 then
			else
				local r_9421 = nil
				r_9421 = (function()
					if head5["auto-close"] then
						if nil_3f_1(stack2) then
							doNodeError_21_1(logger15, format1("'%s' without matching '%s'", tok3["contents"], tok3["open"]), tok3, nil, getSource1(tok3), "")
						else
						end
						head5["range"]["finish"] = tok3["range"]["finish"]
						pop_21_1()
						return r_9421()
					else
					end
				end)
				r_9421()
			end
			return r_8991((r_9001 + 1))
		else
		end
	end)
	r_8991(1)
	return head5
end)
compile1 = require1("tacky.compile")["compile"]
Scope2 = require1("tacky.analysis.scope")
doParse1 = (function(compiler6, scope4, str6)
	local logger16 = compiler6["log"]
	local lexed1 = lex1(logger16, str6, "<stdin>")
	local parsed1 = parse1(logger16, lexed1)
	local x128 = list1(compile1(parsed1, compiler6["global"], compiler6["variables"], compiler6["states"], scope4, compiler6["compileState"], compiler6["loader"], logger16, executeStates1))
	return car1(cdr1(x128))
end)
execCommand1 = (function(compiler7, scope5, args22)
	local logger17 = compiler7["log"]
	local command1 = car1(args22)
	if (command1 == nil) then
		return self1(logger17, "put-error!", "Expected command after ':'")
	elseif (command1 == "help") then
		return print1("REPL commands:\n:doc NAME        Get documentation about a symbol\n:scope           Print out all variables in the scope\n:search QUERY    Search the current scope for symbols and documentation containing a string.")
	elseif (command1 == "doc") then
		local name39 = args22[2]
		if name39 then
			local var23 = Scope2["get"](scope5, name39)
			if (var23 == nil) then
				local msg31 = _2e2e_2("Cannot find '", name39, "'")
				return self1(logger17, "put-error!", msg31)
			else
				local temp111
				local expr24 = var23["doc"]
				temp111 = not expr24
				if temp111 then
					local msg32 = _2e2e_2("No documentation for '", name39, "'")
					return self1(logger17, "put-error!", msg32)
				else
					local sig3 = extractSignature1(var23)
					local name40 = var23["fullName"]
					local docs2 = parseDocstring1(var23["doc"])
					if sig3 then
						local buffer4 = list1(name40)
						local r_9481 = sig3["n"]
						local r_9461 = nil
						r_9461 = (function(r_9471)
							if (r_9471 <= r_9481) then
								local arg27 = sig3[r_9471]
								pushCdr_21_1(buffer4, arg27["contents"])
								return r_9461((r_9471 + 1))
							else
							end
						end)
						r_9461(1)
						name40 = _2e2e_2("(", concat1(buffer4, " "), ")")
					else
					end
					print1(colored1(96, name40))
					local r_9541 = docs2["n"]
					local r_9521 = nil
					r_9521 = (function(r_9531)
						if (r_9531 <= r_9541) then
							local tok4 = docs2[r_9531]
							local tag13 = tok4["tag"]
							if (tag13 == "text") then
								write1(tok4["contents"])
							elseif (tag13 == "arg") then
								write1(colored1(36, tok4["contents"]))
							elseif (tag13 == "mono") then
								write1(colored1(97, tok4["contents"]))
							elseif (tag13 == "arg") then
								write1(colored1(97, tok4["contents"]))
							elseif (tag13 == "bolic") then
								write1(colored1(3, colored1(1, tok4["contents"])))
							elseif (tag13 == "bold") then
								write1(colored1(1, tok4["contents"]))
							elseif (tag13 == "italic") then
								write1(colored1(3, tok4["contents"]))
							elseif (tag13 == "link") then
								write1(colored1(94, tok4["contents"]))
							else
								_error("unmatched item")
							end
							return r_9521((r_9531 + 1))
						else
						end
					end)
					r_9521(1)
					return print1()
				end
			end
		else
			return self1(logger17, "put-error!", ":command <variable>")
		end
	elseif (command1 == "scope") then
		local vars2 = ({tag = "list", n = 0})
		local varsSet1 = ({})
		local current1 = scope5
		local r_9561 = nil
		r_9561 = (function()
			if current1 then
				iterPairs1(current1["variables"], (function(name41, var24)
					if varsSet1[name41] then
					else
						pushCdr_21_1(vars2, name41)
						varsSet1[name41] = true
						return nil
					end
				end))
				current1 = current1["parent"]
				return r_9561()
			else
			end
		end)
		r_9561()
		sort1(vars2)
		return print1(concat1(vars2, "  "))
	elseif (command1 == "search") then
		if (args22["n"] > 1) then
			local keywords2 = map1(lower1, cdr1(args22))
			local nameResults1 = ({tag = "list", n = 0})
			local docsResults1 = ({tag = "list", n = 0})
			local vars3 = ({tag = "list", n = 0})
			local varsSet2 = ({})
			local current2 = scope5
			local r_9571 = nil
			r_9571 = (function()
				if current2 then
					iterPairs1(current2["variables"], (function(name42, var25)
						if varsSet2[name42] then
						else
							pushCdr_21_1(vars3, name42)
							varsSet2[name42] = true
							return nil
						end
					end))
					current2 = current2["parent"]
					return r_9571()
				else
				end
			end)
			r_9571()
			local r_9621 = vars3["n"]
			local r_9601 = nil
			r_9601 = (function(r_9611)
				if (r_9611 <= r_9621) then
					local var26 = vars3[r_9611]
					local r_9681 = keywords2["n"]
					local r_9661 = nil
					r_9661 = (function(r_9671)
						if (r_9671 <= r_9681) then
							local keyword1 = keywords2[r_9671]
							if find1(var26, keyword1) then
								pushCdr_21_1(nameResults1, var26)
							else
							end
							return r_9661((r_9671 + 1))
						else
						end
					end)
					r_9661(1)
					local docVar1 = Scope2["get"](scope5, var26)
					if docVar1 then
						local tempDocs1 = docVar1["doc"]
						if tempDocs1 then
							local docs3 = lower1(tempDocs1)
							if docs3 then
								local keywordsFound1 = 0
								if keywordsFound1 then
									local r_9851 = keywords2["n"]
									local r_9831 = nil
									r_9831 = (function(r_9841)
										if (r_9841 <= r_9851) then
											local keyword2 = keywords2[r_9841]
											if find1(docs3, keyword2) then
												keywordsFound1 = (keywordsFound1 + 1)
											else
											end
											return r_9831((r_9841 + 1))
										else
										end
									end)
									r_9831(1)
									if eq_3f_1(keywordsFound1, keywords2["n"]) then
										pushCdr_21_1(docsResults1, var26)
									else
									end
								else
								end
							else
							end
						else
						end
					else
					end
					return r_9601((r_9611 + 1))
				else
				end
			end)
			r_9601(1)
			local temp112
			local r_9871 = nil_3f_1(nameResults1)
			temp112 = r_9871 and nil_3f_1(docsResults1)
			if temp112 then
				return self1(logger17, "put-error!", "No results")
			else
				local temp113
				local expr25 = nil_3f_1(nameResults1)
				temp113 = not expr25
				if temp113 then
					print1(colored1(92, "Search by function name:"))
					if (nameResults1["n"] > 20) then
						print1(_2e2e_2(concat1(slice1(nameResults1, 1, 20), "  "), "  ..."))
					else
						print1(concat1(nameResults1, "  "))
					end
				else
				end
				local temp114
				local expr26 = nil_3f_1(docsResults1)
				temp114 = not expr26
				if temp114 then
					print1(colored1(92, "Search by function docs:"))
					if (docsResults1["n"] > 20) then
						return print1(_2e2e_2(concat1(slice1(docsResults1, 1, 20), "  "), "  ..."))
					else
						return print1(concat1(docsResults1, "  "))
					end
				else
				end
			end
		else
			return self1(logger17, "put-error!", ":search <keywords>")
		end
	else
		local msg33 = _2e2e_2("Unknown command '", command1, "'")
		return self1(logger17, "put-error!", msg33)
	end
end)
execString1 = (function(compiler8, scope6, string1)
	local state33 = doParse1(compiler8, scope6, string1)
	if (state33["n"] > 0) then
		local current3 = 0
		local exec1 = create4((function()
			local r_9741 = state33["n"]
			local r_9721 = nil
			r_9721 = (function(r_9731)
				if (r_9731 <= r_9741) then
					local elem7 = state33[r_9731]
					current3 = elem7
					self1(current3, "get")
					return r_9721((r_9731 + 1))
				else
				end
			end)
			return r_9721(1)
		end))
		local compileState1 = compiler8["compileState"]
		local rootScope1 = compiler8["rootScope"]
		local global2 = compiler8["global"]
		local logger18 = compiler8["log"]
		local run1 = true
		local r_8701 = nil
		r_8701 = (function()
			if run1 then
				local res9 = list1(resume1(exec1))
				local temp115
				local expr27 = car1(res9)
				temp115 = not expr27
				if temp115 then
					local msg34 = car1(cdr1(res9))
					self1(logger18, "put-error!", msg34)
					run1 = false
				elseif (status1(exec1) == "dead") then
					local lvl1 = self1(last1(state33), "get")
					print1(_2e2e_2("out = ", colored1(96, pretty1(lvl1))))
					global2[escapeVar1(Scope2["add"](scope6, "out", "defined", lvl1), compileState1)] = lvl1
					run1 = false
				else
					local states2 = car1(cdr1(res9))["states"]
					executeStates1(compileState1, states2, global2, logger18)
				end
				return r_8701()
			else
			end
		end)
		return r_8701()
	else
	end
end)
repl1 = (function(compiler9)
	local scope7 = compiler9["rootScope"]
	local logger19 = compiler9["log"]
	local buffer5 = ({tag = "list", n = 0})
	local running4 = true
	local r_8711 = nil
	r_8711 = (function()
		if running4 then
			write1(colored1(92, (function()
				if nil_3f_1(buffer5) then
					return "> "
				else
					return ". "
				end
			end)()
			))
			flush1()
			local line6 = read1("*l")
			local temp116
			local r_9761 = not line6
			temp116 = r_9761 and nil_3f_1(buffer5)
			if temp116 then
				running4 = false
			elseif line6 and ((function(x129)
				return sub1(line6, x129, x129)
			end)(len1(line6)) == "\\") then
				pushCdr_21_1(buffer5, _2e2e_2(sub1(line6, 1, (function(x130)
					return (x130 - 1)
				end)(len1(line6))), "\n"))
			else
				local temp117
				if line6 then
					local r_9791 = ((function(x131)
						return x131["n"]
					end)(buffer5) > 0)
					temp117 = r_9791 and (len1(line6) > 0)
				else
					temp117 = line6
				end
				if temp117 then
					pushCdr_21_1(buffer5, _2e2e_2(line6, "\n"))
				else
					local data6 = _2e2e_2(concat1(buffer5), line6 or "")
					buffer5 = ({tag = "list", n = 0})
					if (sub1(data6, 1, 1) == ":") then
						execCommand1(compiler9, scope7, split1(sub1(data6, 2), " "))
					else
						scope7 = Scope2["child"](scope7)
						scope7["isRoot"] = true
						local res10 = list1(pcall1(execString1, compiler9, scope7, data6))
						if car1(res10) then
						else
							local msg35 = car1(cdr1(res10))
							self1(logger19, "put-error!", msg35)
						end
					end
				end
			end
			return r_8711()
		else
		end
	end)
	return r_8711()
end)
task2 = struct1("name", "repl", "setup", (function(spec11)
	return addArgument_21_1(spec11, ({tag = "list", n = 1, "--repl"}), "help", "Start an interactive session.")
end), "pred", (function(args23)
	return args23["repl"]
end), "run", repl1)
profileCalls1 = (function(fn3, mappings3)
	local stats1 = ({})
	local callStack1 = ({tag = "list", n = 0})
	sethook1((function(action1)
		local info1 = getinfo1(2, "Sn")
		local start23 = clock1()
		if (action1 == "call") then
			local previous3
			local idx39 = callStack1["n"]
			previous3 = callStack1[idx39]
			if previous3 then
				previous3["sum"] = (previous3["sum"] + (start23 - previous3["innerStart"]))
			else
			end
		else
		end
		if (action1 ~= "call") then
			if nil_3f_1(callStack1) then
			else
				local current4 = popLast_21_1(callStack1)
				local hash2 = (current4["source"] .. current4["linedefined"])
				local entry9 = stats1[hash2]
				if entry9 then
				else
					entry9 = {["source"]=current4["source"],["short-src"]=current4["short_src"],["line"]=current4["linedefined"],["name"]=current4["name"],["calls"]=0,["totalTime"]=0,["innerTime"]=0}
					stats1[hash2] = entry9
				end
				entry9["calls"] = (1 + entry9["calls"])
				entry9["totalTime"] = (entry9["totalTime"] + (start23 - current4["totalStart"]))
				entry9["innerTime"] = (entry9["innerTime"] + (current4["sum"] + (start23 - current4["innerStart"])))
			end
		else
		end
		if (action1 ~= "return") then
			info1["totalStart"] = start23
			info1["innerStart"] = start23
			info1["sum"] = 0
			pushCdr_21_1(callStack1, info1)
		else
		end
		if (action1 == "return") then
			local next2 = last1(callStack1)
			if next2 then
				next2["innerStart"] = start23
				return nil
			else
			end
		else
		end
	end), "cr")
	fn3()
	sethook1()
	local out21 = values1(stats1)
	sort1(out21, (function(a4, b4)
		return (a4["innerTime"] > b4["innerTime"])
	end))
	print1("|               Method | Location                                                     |    Total |    Inner |   Calls |")
	print1("| -------------------- | ------------------------------------------------------------ | -------- | -------- | ------- |")
	local r_10021 = out21["n"]
	local r_10001 = nil
	r_10001 = (function(r_10011)
		if (r_10011 <= r_10021) then
			local entry10 = out21[r_10011]
			print1(format1("| %20s | %-60s | %8.5f | %8.5f | %7d | ", (function()
				if entry10["name"] then
					return unmangleIdent1(entry10["name"])
				else
					return "<unknown>"
				end
			end)()
			, remapMessage1(mappings3, _2e2e_2(entry10["short-src"], ":", entry10["line"])), entry10["totalTime"], entry10["innerTime"], entry10["calls"]))
			return r_10001((r_10011 + 1))
		else
		end
	end)
	r_10001(1)
	return stats1
end)
buildStack1 = (function(parent1, stack3, i8, history1, fold1)
	parent1["n"] = (parent1["n"] + 1)
	if (i8 >= 1) then
		local elem8 = stack3[i8]
		local hash3 = _2e2e_2(elem8["source"], "|", elem8["linedefined"])
		local previous4 = fold1 and history1[hash3]
		local child2 = parent1[hash3]
		if previous4 then
			parent1["n"] = (parent1["n"] - 1)
			child2 = previous4
		else
		end
		if child2 then
		else
			child2 = elem8
			elem8["n"] = 0
			parent1[hash3] = child2
		end
		if previous4 then
		else
			history1[hash3] = child2
		end
		buildStack1(child2, stack3, (i8 - 1), history1, fold1)
		if previous4 then
		else
			history1[hash3] = nil
			return nil
		end
	else
	end
end)
buildRevStack1 = (function(parent2, stack4, i9, history2, fold2)
	parent2["n"] = (parent2["n"] + 1)
	if (i9 <= stack4["n"]) then
		local elem9 = stack4[i9]
		local hash4 = _2e2e_2(elem9["source"], "|", elem9["linedefined"])
		local previous5 = fold2 and history2[hash4]
		local child3 = parent2[hash4]
		if previous5 then
			parent2["n"] = (parent2["n"] - 1)
			child3 = previous5
		else
		end
		if child3 then
		else
			child3 = elem9
			elem9["n"] = 0
			parent2[hash4] = child3
		end
		if previous5 then
		else
			history2[hash4] = child3
		end
		buildRevStack1(child3, stack4, (i9 + 1), history2, fold2)
		if previous5 then
		else
			history2[hash4] = nil
			return nil
		end
	else
	end
end)
finishStack1 = (function(element1)
	local children1 = ({tag = "list", n = 0})
	iterPairs1(element1, (function(k2, child4)
		if (type_23_1(child4) == "table") then
			return pushCdr_21_1(children1, child4)
		else
		end
	end))
	sort1(children1, (function(a5, b5)
		return (a5["n"] > b5["n"])
	end))
	element1["children"] = children1
	local r_10081 = children1["n"]
	local r_10061 = nil
	r_10061 = (function(r_10071)
		if (r_10071 <= r_10081) then
			local child5 = children1[r_10071]
			finishStack1(child5)
			return r_10061((r_10071 + 1))
		else
		end
	end)
	return r_10061(1)
end)
showStack_21_1 = (function(out22, mappings4, total1, stack5, remaining2)
	line_21_1(out22, format1("└ %s %s %d (%2.5f%%)", (function()
		if stack5["name"] then
			return unmangleIdent1(stack5["name"])
		else
			return "<unknown>"
		end
	end)()
	, remapMessage1(mappings4, _2e2e_2(stack5["short_src"], ":", stack5["linedefined"])), stack5["n"], ((stack5["n"] / total1) * 100)))
	local temp118
	if remaining2 then
		temp118 = (remaining2 >= 1)
	else
		temp118 = true
	end
	if temp118 then
		indent_21_1(out22)
		local r_10111 = stack5["children"]
		local r_10141 = r_10111["n"]
		local r_10121 = nil
		r_10121 = (function(r_10131)
			if (r_10131 <= r_10141) then
				local child6 = r_10111[r_10131]
				showStack_21_1(out22, mappings4, total1, child6, remaining2 and (remaining2 - 1))
				return r_10121((r_10131 + 1))
			else
			end
		end)
		r_10121(1)
		return unindent_21_1(out22)
	else
	end
end)
showFlame_21_1 = (function(mappings5, stack6, before1, remaining3)
	local renamed1 = _2e2e_2((function()
		if stack6["name"] then
			return unmangleIdent1(stack6["name"])
		else
			return "?"
		end
	end)()
	, "`", remapMessage1(mappings5, _2e2e_2(stack6["short_src"], ":", stack6["linedefined"])))
	print1(format1("%s%s %d", before1, renamed1, stack6["n"]))
	local temp119
	if remaining3 then
		temp119 = (remaining3 >= 1)
	else
		temp119 = true
	end
	if temp119 then
		local whole1 = _2e2e_2(before1, renamed1, ";")
		local r_9911 = stack6["children"]
		local r_9941 = r_9911["n"]
		local r_9921 = nil
		r_9921 = (function(r_9931)
			if (r_9931 <= r_9941) then
				local child7 = r_9911[r_9931]
				showFlame_21_1(mappings5, child7, whole1, remaining3 and (remaining3 - 1))
				return r_9921((r_9931 + 1))
			else
			end
		end)
		return r_9921(1)
	else
	end
end)
profileStack1 = (function(fn4, mappings6, args24)
	local stacks1 = ({tag = "list", n = 0})
	local top1 = getinfo1(2, "S")
	sethook1((function(action2)
		local pos13 = 3
		local stack7 = ({tag = "list", n = 0})
		local info2 = getinfo1(2, "Sn")
		local r_10171 = nil
		r_10171 = (function()
			if info2 then
				local temp120
				local r_10181 = (info2["source"] == top1["source"])
				temp120 = r_10181 and (info2["linedefined"] == top1["linedefined"])
				if temp120 then
					info2 = nil
				else
					pushCdr_21_1(stack7, info2)
					pos13 = (pos13 + 1)
					info2 = getinfo1(pos13, "Sn")
				end
				return r_10171()
			else
			end
		end)
		r_10171()
		return pushCdr_21_1(stacks1, stack7)
	end), "", 100000.0)
	fn4()
	sethook1()
	local folded1 = {["n"]=0,["name"]="<root>"}
	local r_10461 = stacks1["n"]
	local r_10441 = nil
	r_10441 = (function(r_10451)
		if (r_10451 <= r_10461) then
			local stack8 = stacks1[r_10451]
			if (args24["stack-kind"] == "reverse") then
				buildRevStack1(folded1, stack8, 1, ({}), args24["stack-fold"])
			else
				buildStack1(folded1, stack8, stack8["n"], ({}), args24["stack-fold"])
			end
			return r_10441((r_10451 + 1))
		else
		end
	end)
	r_10441(1)
	finishStack1(folded1)
	if (args24["stack-show"] == "flame") then
		return showFlame_21_1(mappings6, folded1, "", (function(r_10481)
			return r_10481 or 30
		end)(args24["stack-limit"]))
	else
		local writer11 = create3()
		showStack_21_1(writer11, mappings6, stacks1["n"], folded1, (function(r_10491)
			return r_10491 or 10
		end)(args24["stack-limit"]))
		return print1(concat1(writer11["out"]))
	end
end)
runLua1 = (function(compiler10, args25)
	if nil_3f_1(args25["input"]) then
		local logger20 = compiler10["log"]
		self1(logger20, "put-error!", "No inputs to run.")
		exit_21_1(1)
	else
	end
	local out23 = file3(compiler10, false)
	local lines7 = generateMappings1(out23["lines"])
	local logger21 = compiler10["log"]
	local name43 = _2e2e_2((function(r_10401)
		return r_10401 or "out"
	end)(args25["output"]), ".lua")
	local r_10191 = list1(load1(concat1(out23["out"]), _2e2e_2("=", name43)))
	local temp121
	local r_10221 = (type1(r_10191) == "list")
	if r_10221 then
		local r_10231 = (r_10191["n"] >= 2)
		if r_10231 then
			local r_10241 = (r_10191["n"] <= 2)
			if r_10241 then
				local r_10251 = eq_3f_1(r_10191[1], nil)
				temp121 = r_10251 and true
			else
				temp121 = r_10241
			end
		else
			temp121 = r_10231
		end
	else
		temp121 = r_10221
	end
	if temp121 then
		local msg36 = r_10191[2]
		self1(logger21, "put-error!", "Cannot load compiled source.")
		print1(msg36)
		print1(concat1(out23["out"]))
		return exit_21_1(1)
	else
		local temp122
		local r_10261 = (type1(r_10191) == "list")
		if r_10261 then
			local r_10271 = (r_10191["n"] >= 1)
			if r_10271 then
				local r_10281 = (r_10191["n"] <= 1)
				temp122 = r_10281 and true
			else
				temp122 = r_10271
			end
		else
			temp122 = r_10261
		end
		if temp122 then
			local fun3 = r_10191[1]
			_5f_G1["arg"] = args25["script-args"]
			_5f_G1["arg"][0] = car1(args25["input"])
			local exec2 = (function()
				local r_10301 = list1(xpcall1(fun3, traceback1))
				local temp123
				local r_10331 = (type1(r_10301) == "list")
				if r_10331 then
					local r_10341 = (r_10301["n"] >= 1)
					if r_10341 then
						local r_10351 = eq_3f_1(r_10301[1], true)
						temp123 = r_10351 and true
					else
						temp123 = r_10341
					end
				else
					temp123 = r_10331
				end
				if temp123 then
					local res11 = slice1(r_10301, 2)
				else
					local temp124
					local r_10361 = (type1(r_10301) == "list")
					if r_10361 then
						local r_10371 = (r_10301["n"] >= 2)
						if r_10371 then
							local r_10381 = (r_10301["n"] <= 2)
							if r_10381 then
								local r_10391 = eq_3f_1(r_10301[1], false)
								temp124 = r_10391 and true
							else
								temp124 = r_10381
							end
						else
							temp124 = r_10371
						end
					else
						temp124 = r_10361
					end
					if temp124 then
						local msg37 = r_10301[2]
						self1(logger21, "put-error!", "Execution failed.")
						print1(remapTraceback1(struct1(name43, lines7), msg37))
						return exit_21_1(1)
					else
						return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_10301), ", but none matched.\n", "  Tried: `(true . ?res)`\n  Tried: `(false ?msg)`"))
					end
				end
			end)
			local r_10291 = args25["profile"]
			if (r_10291 == "none") then
				return exec2()
			elseif eq_3f_1(r_10291, nil) then
				return exec2()
			elseif (r_10291 == "call") then
				return profileCalls1(exec2, struct1(name43, lines7))
			elseif (r_10291 == "stack") then
				return profileStack1(exec2, struct1(name43, lines7), args25)
			else
				local msg38 = _2e2e_2("Unknown profiler '", r_10291, "'")
				self1(logger21, "put-error!", msg38)
				return exit_21_1(1)
			end
		else
			return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_10191), ", but none matched.\n", "  Tried: `(nil ?msg)`\n  Tried: `(?fun)`"))
		end
	end
end)
task3 = struct1("name", "run", "setup", (function(spec12)
	addArgument_21_1(spec12, ({tag = "list", n = 2, "--run", "-r"}), "help", "Run the compiled code.")
	addArgument_21_1(spec12, ({tag = "list", n = 2, "--profile", "-p"}), "help", "Run the compiled code with the profiler.", "var", "none|call|stack", "default", nil, "value", "stack", "narg", "?")
	addArgument_21_1(spec12, ({tag = "list", n = 1, "--stack-kind"}), "help", "The kind of stack to emit when using the stack profiler. A reverse stack shows callers of that method instead.", "var", "forward|reverse", "default", "forward", "narg", 1)
	addArgument_21_1(spec12, ({tag = "list", n = 1, "--stack-show"}), "help", "The method to use to display the profiling results.", "var", "flame|term", "default", "term", "narg", 1)
	addArgument_21_1(spec12, ({tag = "list", n = 1, "--stack-limit"}), "help", "The maximum number of call frames to emit.", "var", "LIMIT", "default", nil, "action", setNumAction1, "narg", 1)
	addArgument_21_1(spec12, ({tag = "list", n = 1, "--stack-fold"}), "help", "Whether to fold recursive functions into themselves. This hopefully makes deep graphs easier to understand, but may result in less accurate graphs.", "value", true, "default", false)
	return addArgument_21_1(spec12, ({tag = "list", n = 1, "--"}), "name", "script-args", "help", "Arguments to pass to the compiled script.", "var", "ARG", "all", true, "default", ({tag = "list", n = 0}), "action", addAction1, "narg", "*")
end), "pred", (function(args26)
	local r_10411 = args26["run"]
	return r_10411 or args26["profile"]
end), "run", runLua1)
genNative1 = (function(compiler11, args27)
	if ((function(x132)
		return x132["n"]
	end)(args27["input"]) ~= 1) then
		local logger22 = compiler11["log"]
		self1(logger22, "put-error!", "Expected just one input")
		exit_21_1(1)
	else
	end
	local prefix2 = args27["gen-native"]
	local qualifier1
	if string_3f_1(prefix2) then
		qualifier1 = _2e2e_2(prefix2, ".")
	else
		qualifier1 = ""
	end
	local lib3 = compiler11["libCache"][gsub1(last1(args27["input"]), "%.lisp$", "")]
	local maxName1 = 0
	local maxQuot1 = 0
	local maxPref1 = 0
	local natives1 = ({tag = "list", n = 0})
	local r_10521 = lib3["out"]
	local r_10551 = r_10521["n"]
	local r_10531 = nil
	r_10531 = (function(r_10541)
		if (r_10541 <= r_10551) then
			local node55 = r_10521[r_10541]
			local temp125
			local r_10571 = (type1(node55) == "list")
			if r_10571 then
				local r_10581
				local x133 = car1(node55)
				r_10581 = (type1(x133) == "symbol")
				temp125 = r_10581 and (car1(node55)["contents"] == "define-native")
			else
				temp125 = r_10571
			end
			if temp125 then
				local name44 = node55[2]["contents"]
				pushCdr_21_1(natives1, name44)
				maxName1 = max2(maxName1, len1(quoted1(name44)))
				maxQuot1 = max2(maxQuot1, len1(quoted1(_2e2e_2(qualifier1, name44))))
				maxPref1 = max2(maxPref1, len1(_2e2e_2(qualifier1, name44)))
			else
			end
			return r_10531((r_10541 + 1))
		else
		end
	end)
	r_10531(1)
	sort1(natives1)
	local handle4 = open1(_2e2e_2(lib3["path"], ".meta.lua"), "w")
	local format2 = _2e2e_2("\9[%-", tostring1((maxName1 + 3)), "s { tag = \"var\", contents = %-", tostring1((maxQuot1 + 1)), "s value = %-", tostring1((maxPref1 + 1)), "s },\n")
	if handle4 then
	else
		local logger23 = compiler11["log"]
		local msg39 = _2e2e_2("Cannot write to ", lib3["path"], ".meta.lua")
		self1(logger23, "put-error!", msg39)
		exit_21_1(1)
	end
	if string_3f_1(prefix2) then
		self1(handle4, "write", format1("local %s = %s or {}\n", prefix2, prefix2))
	else
	end
	self1(handle4, "write", "return {\n")
	local r_10631 = natives1["n"]
	local r_10611 = nil
	r_10611 = (function(r_10621)
		if (r_10621 <= r_10631) then
			local native2 = natives1[r_10621]
			self1(handle4, "write", format1(format2, _2e2e_2(quoted1(native2), "] ="), _2e2e_2(quoted1(_2e2e_2(qualifier1, native2)), ","), _2e2e_2(qualifier1, native2, ",")))
			return r_10611((r_10621 + 1))
		else
		end
	end)
	r_10611(1)
	self1(handle4, "write", "}\n")
	return self1(handle4, "close")
end)
task4 = struct1("name", "gen-native", "setup", (function(spec13)
	return addArgument_21_1(spec13, ({tag = "list", n = 1, "--gen-native"}), "help", "Generate native bindings for a file", "var", "PREFIX", "narg", "?")
end), "pred", (function(args28)
	return args28["gen-native"]
end), "run", genNative1)
scope_2f_child2 = require1("tacky.analysis.scope")["child"]
compile2 = require1("tacky.compile")["compile"]
simplifyPath1 = (function(path2, paths1)
	local current5 = path2
	local r_10691 = paths1["n"]
	local r_10671 = nil
	r_10671 = (function(r_10681)
		if (r_10681 <= r_10691) then
			local search1 = paths1[r_10681]
			local sub9 = match1(path2, _2e2e_2("^", gsub1(search1, "%?", "(.*)"), "$"))
			if sub9 and (len1(sub9) < len1(current5)) then
				current5 = sub9
			else
			end
			return r_10671((r_10681 + 1))
		else
		end
	end)
	r_10671(1)
	return current5
end)
readMeta1 = (function(state34, name45, entry11)
	local temp126
	local r_10721
	local r_10731 = (entry11["tag"] == "expr")
	r_10721 = r_10731 or (entry11["tag"] == "stmt")
	temp126 = r_10721 and string_3f_1(entry11["contents"])
	if temp126 then
		local buffer6 = ({tag = "list", n = 0})
		local str7 = entry11["contents"]
		local idx40 = 0
		local len8 = len1(str7)
		local r_10741 = nil
		r_10741 = (function()
			if (idx40 <= len8) then
				local r_10751 = list1(find1(str7, "%${(%d+)}", idx40))
				local temp127
				local r_10771 = (type1(r_10751) == "list")
				if r_10771 then
					local r_10781 = (r_10751["n"] >= 2)
					temp127 = r_10781 and true
				else
					temp127 = r_10771
				end
				if temp127 then
					local start24 = r_10751[1]
					local finish7 = r_10751[2]
					if (start24 > idx40) then
						pushCdr_21_1(buffer6, sub1(str7, idx40, (start24 - 1)))
					else
					end
					pushCdr_21_1(buffer6, tonumber1(sub1(str7, (start24 + 2), (finish7 - 1))))
					idx40 = (finish7 + 1)
				else
					pushCdr_21_1(buffer6, sub1(str7, idx40, len8))
					idx40 = (len8 + 1)
				end
				return r_10741()
			else
			end
		end)
		r_10741()
		entry11["contents"] = buffer6
	else
	end
	if (entry11["value"] == nil) then
		entry11["value"] = state34["libEnv"][name45]
	elseif (state34["libEnv"][name45] ~= nil) then
		local x134 = _2e2e_2("Duplicate value for ", name45, ": in native and meta file")
		error1(x134, 0)
	else
		state34["libEnv"][name45] = entry11["value"]
	end
	state34["libMeta"][name45] = entry11
	return entry11
end)
readLibrary1 = (function(state35, name46, path3, lispHandle1)
	local logger24 = state35["log"]
	local msg40 = _2e2e_2("Loading ", path3, " into ", name46)
	self1(logger24, "put-verbose!", msg40)
	local prefix3 = _2e2e_2(name46, "-", (function(x135)
		return x135["n"]
	end)(state35["libs"]), "/")
	local lib4 = struct1("name", name46, "prefix", prefix3, "path", path3)
	local contents2 = self1(lispHandle1, "read", "*a")
	self1(lispHandle1, "close")
	local handle5 = open1(_2e2e_2(path3, ".lua"), "r")
	if handle5 then
		local contents3 = self1(handle5, "read", "*a")
		self1(handle5, "close")
		lib4["native"] = contents3
		local r_10821 = list1(load1(contents3, _2e2e_2("@", name46)))
		local temp128
		local r_10851 = (type1(r_10821) == "list")
		if r_10851 then
			local r_10861 = (r_10821["n"] >= 2)
			if r_10861 then
				local r_10871 = (r_10821["n"] <= 2)
				if r_10871 then
					local r_10881 = eq_3f_1(r_10821[1], nil)
					temp128 = r_10881 and true
				else
					temp128 = r_10871
				end
			else
				temp128 = r_10861
			end
		else
			temp128 = r_10851
		end
		if temp128 then
			local msg41 = r_10821[2]
			error1(msg41, 0)
		else
			local temp129
			local r_10891 = (type1(r_10821) == "list")
			if r_10891 then
				local r_10901 = (r_10821["n"] >= 1)
				if r_10901 then
					local r_10911 = (r_10821["n"] <= 1)
					temp129 = r_10911 and true
				else
					temp129 = r_10901
				end
			else
				temp129 = r_10891
			end
			if temp129 then
				local fun4 = r_10821[1]
				local res12 = fun4()
				if (type_23_1(res12) == "table") then
					iterPairs1(res12, (function(k3, v4)
						state35["libEnv"][_2e2e_2(prefix3, k3)] = v4
						return nil
					end))
				else
					local x136 = _2e2e_2(path3, ".lua returned a non-table value")
					error1(x136, 0)
				end
			else
				error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_10821), ", but none matched.\n", "  Tried: `(nil ?msg)`\n  Tried: `(?fun)`"))
			end
		end
	else
	end
	local handle6 = open1(_2e2e_2(path3, ".meta.lua"), "r")
	if handle6 then
		local contents4 = self1(handle6, "read", "*a")
		self1(handle6, "close")
		local r_10921 = list1(load1(contents4, _2e2e_2("@", name46)))
		local temp130
		local r_10951 = (type1(r_10921) == "list")
		if r_10951 then
			local r_10961 = (r_10921["n"] >= 2)
			if r_10961 then
				local r_10971 = (r_10921["n"] <= 2)
				if r_10971 then
					local r_10981 = eq_3f_1(r_10921[1], nil)
					temp130 = r_10981 and true
				else
					temp130 = r_10971
				end
			else
				temp130 = r_10961
			end
		else
			temp130 = r_10951
		end
		if temp130 then
			local msg42 = r_10921[2]
			error1(msg42, 0)
		else
			local temp131
			local r_10991 = (type1(r_10921) == "list")
			if r_10991 then
				local r_11001 = (r_10921["n"] >= 1)
				if r_11001 then
					local r_11011 = (r_10921["n"] <= 1)
					temp131 = r_11011 and true
				else
					temp131 = r_11001
				end
			else
				temp131 = r_10991
			end
			if temp131 then
				local fun5 = r_10921[1]
				local res13 = fun5()
				if (type_23_1(res13) == "table") then
					iterPairs1(res13, (function(k4, v5)
						return readMeta1(state35, _2e2e_2(prefix3, k4), v5)
					end))
				else
					local x137 = _2e2e_2(path3, ".meta.lua returned a non-table value")
					error1(x137, 0)
				end
			else
				error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_10921), ", but none matched.\n", "  Tried: `(nil ?msg)`\n  Tried: `(?fun)`"))
			end
		end
	else
	end
	startTimer_21_1(state35["timer"], _2e2e_2("[parse] ", path3), 2)
	local lexed2 = lex1(state35["log"], contents2, _2e2e_2(path3, ".lisp"))
	local parsed2 = parse1(state35["log"], lexed2)
	local scope8 = scope_2f_child2(state35["rootScope"])
	scope8["isRoot"] = true
	scope8["prefix"] = prefix3
	lib4["scope"] = scope8
	stopTimer_21_1(state35["timer"], _2e2e_2("[parse] ", path3))
	local compiled1 = compile2(parsed2, state35["global"], state35["variables"], state35["states"], scope8, state35["compileState"], state35["loader"], state35["log"], executeStates1, state35["timer"], path3)
	pushCdr_21_1(state35["libs"], lib4)
	if string_3f_1(car1(compiled1)) then
		lib4["docs"] = constVal1(car1(compiled1))
		removeNth_21_1(compiled1, 1)
	else
	end
	lib4["out"] = compiled1
	local r_11061 = compiled1["n"]
	local r_11041 = nil
	r_11041 = (function(r_11051)
		if (r_11051 <= r_11061) then
			local node56 = compiled1[r_11051]
			pushCdr_21_1(state35["out"], node56)
			return r_11041((r_11051 + 1))
		else
		end
	end)
	r_11041(1)
	local logger25 = state35["log"]
	local msg43 = _2e2e_2("Loaded ", path3, " into ", name46)
	self1(logger25, "put-verbose!", msg43)
	return lib4
end)
pathLocator1 = (function(state36, name47)
	local searched1
	local paths2
	local searcher1
	searched1 = ({tag = "list", n = 0})
	paths2 = state36["paths"]
	searcher1 = (function(i10)
		if (i10 > (function(x138)
			return x138["n"]
		end)(paths2)) then
			return list1(nil, _2e2e_2("Cannot find ", quoted1(name47), ".\nLooked in ", concat1(searched1, ", ")))
		else
			local path4 = gsub1((function(xs77)
				return xs77[i10]
			end)(paths2), "%?", name47)
			local cached1 = state36["libCache"][path4]
			pushCdr_21_1(searched1, path4)
			if (cached1 == nil) then
				local handle7 = open1(_2e2e_2(path4, ".lisp"), "r")
				if handle7 then
					state36["libCache"][path4] = true
					local lib5 = readLibrary1(state36, simplifyPath1(path4, paths2), path4, handle7)
					state36["libCache"][path4] = lib5
					return list1(lib5)
				else
					return searcher1((i10 + 1))
				end
			elseif (cached1 == true) then
				return list1(nil, _2e2e_2("Already loading ", name47))
			else
				return list1(cached1)
			end
		end
	end)
	return searcher1(1)
end)
loader1 = (function(state37, name48, shouldResolve1)
	if shouldResolve1 then
		return pathLocator1(state37, name48)
	else
		name48 = gsub1(name48, "%.lisp$", "")
		local r_10811 = state37["libCache"][name48]
		if eq_3f_1(r_10811, nil) then
			local handle8 = open1(_2e2e_2(name48, ".lisp"))
			if handle8 then
				state37["libCache"][name48] = true
				local lib6 = readLibrary1(state37, simplifyPath1(name48, state37["paths"]), name48, handle8)
				state37["libCache"][name48] = lib6
				return list1(lib6)
			else
				return list1(nil, _2e2e_2("Cannot find ", quoted1(name48)))
			end
		elseif eq_3f_1(r_10811, true) then
			return list1(nil, _2e2e_2("Already loading ", name48))
		else
			return list1(r_10811)
		end
	end
end)
printError_21_1 = (function(msg44)
	if string_3f_1(msg44) then
	else
		msg44 = pretty1(msg44)
	end
	local lines8 = split1(msg44, "\n", 1)
	print1(colored1(31, _2e2e_2("[ERROR] ", car1(lines8))))
	if car1(cdr1(lines8)) then
		return print1(car1(cdr1(lines8)))
	else
	end
end)
printWarning_21_1 = (function(msg45)
	local lines9 = split1(msg45, "\n", 1)
	print1(colored1(33, _2e2e_2("[WARN] ", car1(lines9))))
	if car1(cdr1(lines9)) then
		return print1(car1(cdr1(lines9)))
	else
	end
end)
printVerbose_21_1 = (function(verbosity1, msg46)
	if (verbosity1 > 0) then
		return print1(_2e2e_2("[VERBOSE] ", msg46))
	else
	end
end)
printDebug_21_1 = (function(verbosity2, msg47)
	if (verbosity2 > 1) then
		return print1(_2e2e_2("[DEBUG] ", msg47))
	else
	end
end)
printTime_21_1 = (function(maximum1, name49, time1, level6)
	if (level6 <= maximum1) then
		return print1(_2e2e_2("[TIME] ", name49, " took ", time1))
	else
	end
end)
printExplain_21_1 = (function(explain4, lines10)
	if explain4 then
		local r_11161 = split1(lines10, "\n")
		local r_11191 = r_11161["n"]
		local r_11171 = nil
		r_11171 = (function(r_11181)
			if (r_11181 <= r_11191) then
				local line7 = r_11161[r_11181]
				print1(_2e2e_2("  ", line7))
				return r_11171((r_11181 + 1))
			else
			end
		end)
		return r_11171(1)
	else
	end
end)
create5 = (function(verbosity3, explain5, time2)
	return struct1("verbosity", verbosity3 or 0, "explain", (explain5 == true), "time", time2 or 0, "put-error!", putError_21_2, "put-warning!", putWarning_21_2, "put-verbose!", putVerbose_21_2, "put-debug!", putDebug_21_2, "put-time!", putTime_21_1, "put-node-error!", putNodeError_21_2, "put-node-warning!", putNodeWarning_21_2)
end)
putError_21_2 = (function(logger26, msg48)
	return printError_21_1(msg48)
end)
putWarning_21_2 = (function(logger27, msg49)
	return printWarning_21_1(msg49)
end)
putVerbose_21_2 = (function(logger28, msg50)
	return printVerbose_21_1(logger28["verbosity"], msg50)
end)
putDebug_21_2 = (function(logger29, msg51)
	return printDebug_21_1(logger29["verbosity"], msg51)
end)
putTime_21_1 = (function(logger30, name50, time3, level7)
	return printTime_21_1(logger30["time"], name50, time3, level7)
end)
putNodeError_21_2 = (function(logger31, msg52, node57, explain6, lines11)
	printError_21_1(msg52)
	putTrace_21_1(node57)
	if explain6 then
		printExplain_21_1(logger31["explain"], explain6)
	else
	end
	return putLines_21_1(true, lines11)
end)
putNodeWarning_21_2 = (function(logger32, msg53, node58, explain7, lines12)
	printWarning_21_1(msg53)
	putTrace_21_1(node58)
	if explain7 then
		printExplain_21_1(logger32["explain"], explain7)
	else
	end
	return putLines_21_1(true, lines12)
end)
putLines_21_1 = (function(range7, entries2)
	if nil_3f_1(entries2) then
		error1("Positions cannot be empty")
	else
	end
	if ((entries2["n"] % 2) ~= 0) then
		error1(_2e2e_2("Positions must be a multiple of 2, is ", entries2["n"]))
	else
	end
	local previous6 = -1
	local file4 = entries2[1]["name"]
	local maxLine1 = foldr1((function(max6, node59)
		if string_3f_1(node59) then
			return max6
		else
			return max2(max6, node59["start"]["line"])
		end
	end), 0, entries2)
	local code3 = _2e2e_2(colored1(92, _2e2e_2(" %", len1(tostring1(maxLine1)), "s |")), " %s")
	local r_11121 = entries2["n"]
	local r_11101 = nil
	r_11101 = (function(r_11111)
		if (r_11111 <= r_11121) then
			local position2 = entries2[r_11111]
			local message1 = entries2[(r_11111 + 1)]
			if (file4 ~= position2["name"]) then
				file4 = position2["name"]
				print1(colored1(95, _2e2e_2(" ", file4)))
			else
				local temp132
				local r_11211 = (previous6 ~= -1)
				temp132 = r_11211 and (abs1((position2["start"]["line"] - previous6)) > 2)
				if temp132 then
					print1(colored1(92, " ..."))
				else
				end
			end
			previous6 = position2["start"]["line"]
			print1(format1(code3, tostring1(position2["start"]["line"]), position2["lines"][position2["start"]["line"]]))
			local pointer1
			if not range7 then
				pointer1 = "^"
			else
				local temp133
				local r_11221 = position2["finish"]
				temp133 = r_11221 and (position2["start"]["line"] == position2["finish"]["line"])
				if temp133 then
					pointer1 = rep1("^", (function(x139)
						return (x139 + 1)
					end)((position2["finish"]["column"] - position2["start"]["column"])))
				else
					pointer1 = "^..."
				end
			end
			print1(format1(code3, "", _2e2e_2(rep1(" ", (position2["start"]["column"] - 1)), pointer1, " ", message1)))
			return r_11101((r_11111 + 2))
		else
		end
	end)
	return r_11101(1)
end)
putTrace_21_1 = (function(node60)
	local previous7 = nil
	local r_11141 = nil
	r_11141 = (function()
		if node60 then
			local formatted1 = formatNode1(node60)
			if (previous7 == nil) then
				print1(colored1(96, _2e2e_2("  => ", formatted1)))
			elseif (previous7 ~= formatted1) then
				print1(_2e2e_2("  in ", formatted1))
			else
			end
			previous7 = formatted1
			node60 = node60["parent"]
			return r_11141()
		else
		end
	end)
	return r_11141()
end)
rootScope2 = require1("tacky.analysis.resolve")["rootScope"]
scope_2f_child3 = require1("tacky.analysis.scope")["child"]
scope_2f_import_21_1 = require1("tacky.analysis.scope")["import"]
local spec14 = create1()
local directory1
local dir1 = arg1[0]
dir1 = gsub1(dir1, "urn/cli%.lisp$", "")
dir1 = gsub1(dir1, "urn/cli$", "")
dir1 = gsub1(dir1, "tacky/cli%.lua$", "")
local temp134
local r_11811 = (dir1 ~= "")
temp134 = r_11811 and ((function(xs78)
	return sub1(xs78, -1, -1)
end)(dir1) ~= "/")
if temp134 then
	dir1 = _2e2e_2(dir1, "/")
else
end
local r_11821 = nil
r_11821 = (function()
	if (sub1(dir1, 1, 2) == "./") then
		dir1 = sub1(dir1, 3)
		return r_11821()
	else
	end
end)
r_11821()
directory1 = dir1
local paths3 = list1("?", "?/init", _2e2e_2(directory1, "lib/?"), _2e2e_2(directory1, "lib/?/init"))
local tasks1 = list1(warning1, optimise2, emitLisp1, emitLua1, task1, task4, task3, task2)
addHelp_21_1(spec14)
addArgument_21_1(spec14, ({tag = "list", n = 2, "--explain", "-e"}), "help", "Explain error messages in more detail.")
addArgument_21_1(spec14, ({tag = "list", n = 2, "--time", "-t"}), "help", "Time how long each task takes to execute. Multiple usages will show more detailed timings.", "many", true, "default", 0, "action", (function(arg28, data7)
	data7[arg28["name"]] = (function(x140)
		return (x140 + 1)
	end)((function(r_11231)
		return r_11231 or 0
	end)(data7[arg28["name"]]))
	return nil
end))
addArgument_21_1(spec14, ({tag = "list", n = 2, "--verbose", "-v"}), "help", "Make the output more verbose. Can be used multiple times", "many", true, "default", 0, "action", (function(arg29, data8)
	data8[arg29["name"]] = (function(x141)
		return (x141 + 1)
	end)((function(r_11241)
		return r_11241 or 0
	end)(data8[arg29["name"]]))
	return nil
end))
addArgument_21_1(spec14, ({tag = "list", n = 2, "--include", "-i"}), "help", "Add an additional argument to the include path.", "many", true, "narg", 1, "default", ({tag = "list", n = 0}), "action", addAction1)
addArgument_21_1(spec14, ({tag = "list", n = 2, "--prelude", "-p"}), "help", "A custom prelude path to use.", "narg", 1, "default", _2e2e_2(directory1, "lib/prelude"))
addArgument_21_1(spec14, ({tag = "list", n = 3, "--output", "--out", "-o"}), "help", "The destination to output to.", "narg", 1, "default", "out")
addArgument_21_1(spec14, ({tag = "list", n = 2, "--wrapper", "-w"}), "help", "A wrapper script to launch Urn with", "narg", 1, "action", (function(a6, b6, value11)
	local args29 = map1(id1, arg1)
	local i11 = 1
	local len9 = args29["n"]
	local r_11251 = nil
	r_11251 = (function()
		if (i11 <= len9) then
			local item2
			local idx41 = i11
			item2 = args29[idx41]
			local temp135
			local r_11261 = (item2 == "--wrapper")
			temp135 = r_11261 or (item2 == "-w")
			if temp135 then
				removeNth_21_1(args29, i11)
				removeNth_21_1(args29, i11)
				i11 = (len9 + 1)
			elseif find1(item2, "^%-%-wrapper=.*$") then
				removeNth_21_1(args29, i11)
				i11 = (len9 + 1)
			elseif find1(item2, "^%-[^-]+w$") then
				args29[i11] = sub1(item2, 1, -2)
				removeNth_21_1(args29, (function(x142)
					return (x142 + 1)
				end)(i11))
				i11 = (len9 + 1)
			else
			end
			return r_11251()
		else
		end
	end)
	r_11251()
	local command2 = list1(value11)
	local interp1 = arg1[-1]
	if interp1 then
		pushCdr_21_1(command2, interp1)
	else
	end
	pushCdr_21_1(command2, arg1[0])
	local r_11271 = list1(execute1(concat1(append1(command2, args29), " ")))
	local temp136
	local r_11291 = (type1(r_11271) == "list")
	if r_11291 then
		local r_11301 = (r_11271["n"] >= 3)
		if r_11301 then
			local r_11311 = (r_11271["n"] <= 3)
			temp136 = r_11311 and true
		else
			temp136 = r_11301
		end
	else
		temp136 = r_11291
	end
	if temp136 then
		local code4 = r_11271[3]
		return exit1(code4)
	else
		return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_11271), ", but none matched.\n", "  Tried: `(_ _ ?code)`"))
	end
end))
addArgument_21_1(spec14, ({tag = "list", n = 1, "input"}), "help", "The file(s) to load.", "var", "FILE", "narg", "*")
local r_11381 = tasks1["n"]
local r_11361 = nil
r_11361 = (function(r_11371)
	if (r_11371 <= r_11381) then
		local task5 = tasks1[r_11371]
		task5["setup"](spec14)
		return r_11361((r_11371 + 1))
	else
	end
end)
r_11361(1)
local args30 = parse_21_1(spec14)
local logger33 = create5(args30["verbose"], args30["explain"], args30["time"])
local r_11411 = args30["include"]
local r_11441 = r_11411["n"]
local r_11421 = nil
r_11421 = (function(r_11431)
	if (r_11431 <= r_11441) then
		local path5 = r_11411[r_11431]
		path5 = gsub1(path5, "\\", "/")
		path5 = gsub1(path5, "^%./", "")
		if find1(path5, "%?") then
		else
			path5 = _2e2e_2(path5, (function()
				if ((function(xs79)
					return sub1(xs79, -1, -1)
				end)(path5) == "/") then
					return "?"
				else
					return "/?"
				end
			end)()
			)
		end
		pushCdr_21_1(paths3, path5)
		return r_11421((r_11431 + 1))
	else
	end
end)
r_11421(1)
local msg54 = _2e2e_2("Using path: ", pretty1(paths3))
self1(logger33, "put-verbose!", msg54)
if nil_3f_1(args30["input"]) then
	args30["repl"] = true
else
	args30["emit-lua"] = true
end
local compiler12 = struct1("log", logger33, "timer", create2((function(r_11781, r_11791, r_11801)
	return self1(logger33, "put-time!", r_11781, r_11791, r_11801)
end)), "paths", paths3, "libEnv", ({}), "libMeta", ({}), "libs", ({tag = "list", n = 0}), "libCache", ({}), "rootScope", rootScope2, "variables", ({}), "states", ({}), "out", ({tag = "list", n = 0}))
compiler12["compileState"] = createState2(compiler12["libMeta"])
compiler12["loader"] = (function(name51)
	return loader1(compiler12, name51, true)
end)
compiler12["global"] = setmetatable1(struct1("_libs", compiler12["libEnv"]), struct1("__index", _5f_G1))
iterPairs1(compiler12["rootScope"]["variables"], (function(_5f_3, var27)
	compiler12["variables"][tostring1(var27)] = var27
	return nil
end))
startTimer_21_1(compiler12["timer"], "loading")
local r_11461 = loader1(compiler12, args30["prelude"], false)
local temp137
local r_11491 = (type1(r_11461) == "list")
if r_11491 then
	local r_11501 = (r_11461["n"] >= 2)
	if r_11501 then
		local r_11511 = (r_11461["n"] <= 2)
		if r_11511 then
			local r_11521 = eq_3f_1(r_11461[1], nil)
			temp137 = r_11521 and true
		else
			temp137 = r_11511
		end
	else
		temp137 = r_11501
	end
else
	temp137 = r_11491
end
if temp137 then
	local errorMessage1 = r_11461[2]
	self1(logger33, "put-error!", errorMessage1)
	exit_21_1(1)
else
	local temp138
	local r_11531 = (type1(r_11461) == "list")
	if r_11531 then
		local r_11541 = (r_11461["n"] >= 1)
		if r_11541 then
			local r_11551 = (r_11461["n"] <= 1)
			temp138 = r_11551 and true
		else
			temp138 = r_11541
		end
	else
		temp138 = r_11531
	end
	if temp138 then
		local lib7 = r_11461[1]
		compiler12["rootScope"] = scope_2f_child3(compiler12["rootScope"])
		iterPairs1(lib7["scope"]["exported"], (function(name52, var28)
			return scope_2f_import_21_1(compiler12["rootScope"], name52, var28)
		end))
		local r_11571 = args30["input"]
		local r_11601 = r_11571["n"]
		local r_11581 = nil
		r_11581 = (function(r_11591)
			if (r_11591 <= r_11601) then
				local input1 = r_11571[r_11591]
				local r_11621 = loader1(compiler12, input1, false)
				local temp139
				local r_11651 = (type1(r_11621) == "list")
				if r_11651 then
					local r_11661 = (r_11621["n"] >= 2)
					if r_11661 then
						local r_11671 = (r_11621["n"] <= 2)
						if r_11671 then
							local r_11681 = eq_3f_1(r_11621[1], nil)
							temp139 = r_11681 and true
						else
							temp139 = r_11671
						end
					else
						temp139 = r_11661
					end
				else
					temp139 = r_11651
				end
				if temp139 then
					local errorMessage2 = r_11621[2]
					self1(logger33, "put-error!", errorMessage2)
					exit_21_1(1)
				else
					local temp140
					local r_11691 = (type1(r_11621) == "list")
					if r_11691 then
						local r_11701 = (r_11621["n"] >= 1)
						if r_11701 then
							local r_11711 = (r_11621["n"] <= 1)
							temp140 = r_11711 and true
						else
							temp140 = r_11701
						end
					else
						temp140 = r_11691
					end
					if temp140 then
					else
						error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_11621), ", but none matched.\n", "  Tried: `(nil ?error-message)`\n  Tried: `(_)`"))
					end
				end
				return r_11581((r_11591 + 1))
			else
			end
		end)
		r_11581(1)
	else
		error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_11461), ", but none matched.\n", "  Tried: `(nil ?error-message)`\n  Tried: `(?lib)`"))
	end
end
stopTimer_21_1(compiler12["timer"], "loading")
local r_11761 = tasks1["n"]
local r_11741 = nil
r_11741 = (function(r_11751)
	if (r_11751 <= r_11761) then
		local task6 = tasks1[r_11751]
		if task6["pred"](args30) then
			startTimer_21_1(compiler12["timer"], task6["name"], 1)
			task6["run"](compiler12, args30)
			stopTimer_21_1(compiler12["timer"], task6["name"])
		else
		end
		return r_11741((r_11751 + 1))
	else
	end
end)
return r_11741(1)
