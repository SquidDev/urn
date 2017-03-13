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
for k, v in pairs(_temp) do _libs["urn/cli-14/".. k] = v end
_3d_1 = function(v1, v2) return (v1 == v2) end
_2f3d_1 = function(v1, v2) return (v1 ~= v2) end
_3c_1 = function(v1, v2) return (v1 < v2) end
_3c3d_1 = function(v1, v2) return (v1 <= v2) end
_3e_1 = function(v1, v2) return (v1 > v2) end
_3e3d_1 = function(v1, v2) return (v1 >= v2) end
_2b_1 = function(v1, v2) return (v1 + v2) end
_2d_1 = function(v1, v2) return (v1 - v2) end
_25_1 = function(v1, v2) return (v1 % v2) end
_2e2e_1 = function(v1, v2) return (v1 .. v2) end
_5f_G1 = _G
arg_23_1 = arg
len_23_1 = function(v1) return #(v1) end
slice1 = _libs["lua/basic-0/slice"]
error1 = error
getmetatable1 = getmetatable
load1 = load
next1 = next
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
_23_1 = (function(x1)
	return x1["n"]
end)
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
car1 = (function(xs1)
	return xs1[1]
end)
cdr1 = (function(xs2)
	return slice1(xs2, 2)
end)
list1 = (function(...)
	local xs3 = _pack(...) xs3.tag = "list"
	return xs3
end)
cons1 = (function(x2, xs4)
	return (function()
		local _offset, _result, _temp = 0, {tag="list",n=0}
		_result[1 + _offset] = x2
		_temp = xs4
		for _c = 1, _temp.n do _result[1 + _c + _offset] = _temp[_c] end
		_offset = _offset + _temp.n
		_result.n = _offset + 1
		return _result
	end)()
end)
_21_1 = (function(expr1)
	if expr1 then
		return false
	else
		return true
	end
end)
_2d_or1 = (function(a1, b1)
	if a1 then
		return a1
	else
		return b1
	end
end)
_2d_and1 = (function(a2, b2)
	if a2 then
		return b2
	else
		return a2
	end
end)
pretty1 = (function(value1)
	local ty1 = type_23_1(value1)
	if (ty1 == "table") then
		local tag1 = value1["tag"]
		if (tag1 == "list") then
			local out1 = {tag = "list", n = 0}
			local r_51 = _23_1(value1)
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
			if r_71 then
				temp1 = (type_23_1(getmetatable1(value1)["--pretty-print"]) == "function")
			else
				temp1 = r_71
			end
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
	arg1 = {tag = "list", n = 0}
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
table_3f_1 = (function(x3)
	return (type_23_1(x3) == "table")
end)
list_3f_1 = (function(x4)
	return (type1(x4) == "list")
end)
nil_3f_1 = (function(x5)
	if x5 then
		local r_161 = list_3f_1(x5)
		if r_161 then
			return (_23_1(x5) == 0)
		else
			return r_161
		end
	else
		return x5
	end
end)
string_3f_1 = (function(x6)
	return (type1(x6) == "string")
end)
number_3f_1 = (function(x7)
	return (type1(x7) == "number")
end)
symbol_3f_1 = (function(x8)
	return (type1(x8) == "symbol")
end)
key_3f_1 = (function(x9)
	return (type1(x9) == "key")
end)
exists_3f_1 = (function(x10)
	return _21_1((type1(x10) == "nil"))
end)
between_3f_1 = (function(val2, min1, max1)
	local r_221 = (val2 >= min1)
	if r_221 then
		return (val2 <= max1)
	else
		return r_221
	end
end)
type1 = (function(val3)
	local ty2 = type_23_1(val3)
	if (ty2 == "table") then
		local tag3 = val3["tag"]
		if tag3 then
			return tag3
		else
			return "table"
		end
	else
		return ty2
	end
end)
eq_3f_1 = (function(x11, y1)
	local temp2
	local r_231 = exists_3f_1(x11)
	if r_231 then
		temp2 = exists_3f_1(y1)
	else
		temp2 = r_231
	end
	if temp2 then
		local temp3
		local r_241 = symbol_3f_1(x11)
		if r_241 then
			temp3 = symbol_3f_1(y1)
		else
			temp3 = r_241
		end
		if temp3 then
			return (x11["contents"] == y1["contents"])
		else
			local temp4
			local r_251 = symbol_3f_1(x11)
			if r_251 then
				temp4 = string_3f_1(y1)
			else
				temp4 = r_251
			end
			if temp4 then
				return (x11["contents"] == y1)
			else
				local temp5
				local r_261 = string_3f_1(x11)
				if r_261 then
					temp5 = symbol_3f_1(y1)
				else
					temp5 = r_261
				end
				if temp5 then
					return (y1["contents"] == x11)
				else
					local temp6
					local r_271 = key_3f_1(x11)
					if r_271 then
						temp6 = key_3f_1(y1)
					else
						temp6 = r_271
					end
					if temp6 then
						return (x11["value"] == y1["value"])
					else
						local temp7
						local r_281 = key_3f_1(x11)
						if r_281 then
							temp7 = string_3f_1(y1)
						else
							temp7 = r_281
						end
						if temp7 then
							return (x11["value"] == y1)
						else
							local temp8
							local r_291 = string_3f_1(x11)
							if r_291 then
								temp8 = key_3f_1(y1)
							else
								temp8 = r_291
							end
							if temp8 then
								return (y1["value"] == x11)
							else
								local temp9
								local r_301 = nil_3f_1(x11)
								if r_301 then
									temp9 = nil_3f_1(y1)
								else
									temp9 = r_301
								end
								if temp9 then
									return true
								else
									local temp10
									local r_311 = list_3f_1(x11)
									if r_311 then
										temp10 = list_3f_1(y1)
									else
										temp10 = r_311
									end
									if temp10 then
										local r_321 = eq_3f_1(car1(x11), car1(y1))
										if r_321 then
											return eq_3f_1(cdr1(x11), cdr1(y1))
										else
											return r_321
										end
									else
										return (x11 == y1)
									end
								end
							end
						end
					end
				end
			end
		end
	else
		local temp11
		local r_331 = exists_3f_1(x11)
		if r_331 then
			temp11 = _21_1(exists_3f_1(y1))
		else
			temp11 = r_331
		end
		if temp11 then
			return false
		else
			local temp12
			local r_341 = exists_3f_1(y1)
			if r_341 then
				temp12 = _21_1(exists_3f_1(x11))
			else
				temp12 = r_341
			end
			if temp12 then
				return false
			else
				local r_351 = _21_1(x11)
				if r_351 then
					return _21_1(y1)
				else
					return r_351
				end
			end
		end
	end
end)
car2 = (function(x12)
	local r_361 = type1(x12)
	if (r_361 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_361), 2)
	else
	end
	return car1(x12)
end)
cdr2 = (function(x13)
	local r_371 = type1(x13)
	if (r_371 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_371), 2)
	else
	end
	if nil_3f_1(x13) then
		return {tag = "list", n = 0}
	else
		return cdr1(x13)
	end
end)
foldr1 = (function(f1, z1, xs5)
	local r_381 = type1(f1)
	if (r_381 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "f", "function", r_381), 2)
	else
	end
	local r_511 = type1(xs5)
	if (r_511 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_511), 2)
	else
	end
	local accum1 = z1
	local r_541 = _23_1(xs5)
	local r_521 = nil
	r_521 = (function(r_531)
		if (r_531 <= r_541) then
			accum1 = f1(accum1, nth1(xs5, r_531))
			return r_521((r_531 + 1))
		else
		end
	end)
	r_521(1)
	return accum1
end)
map1 = (function(f2, xs6, acc1)
	local r_391 = type1(f2)
	if (r_391 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "f", "function", r_391), 2)
	else
	end
	local r_561 = type1(xs6)
	if (r_561 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_561), 2)
	else
	end
	if _21_1(exists_3f_1(acc1)) then
		return map1(f2, xs6, {tag = "list", n = 0})
	elseif nil_3f_1(xs6) then
		return reverse1(acc1)
	else
		return map1(f2, cdr2(xs6), cons1(f2(car2(xs6)), acc1))
	end
end)
any1 = (function(p1, xs7)
	local r_411 = type1(p1)
	if (r_411 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "p", "function", r_411), 2)
	else
	end
	local r_581 = type1(xs7)
	if (r_581 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_581), 2)
	else
	end
	return accumulateWith1(p1, _2d_or1, false, xs7)
end)
all1 = (function(p2, xs8)
	local r_421 = type1(p2)
	if (r_421 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "p", "function", r_421), 2)
	else
	end
	local r_591 = type1(xs8)
	if (r_591 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_591), 2)
	else
	end
	return accumulateWith1(p2, _2d_and1, true, xs8)
end)
traverse1 = (function(xs9, f3)
	return map1(f3, xs9)
end)
last1 = (function(xs10)
	local r_451 = type1(xs10)
	if (r_451 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_451), 2)
	else
	end
	return xs10[_23_1(xs10)]
end)
nth1 = (function(xs11, idx1)
	return xs11[idx1]
end)
pushCdr_21_1 = (function(xs12, val4)
	local r_461 = type1(xs12)
	if (r_461 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_461), 2)
	else
	end
	local len2 = (_23_1(xs12) + 1)
	xs12["n"] = len2
	xs12[len2] = val4
	return xs12
end)
popLast_21_1 = (function(xs13)
	local r_471 = type1(xs13)
	if (r_471 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_471), 2)
	else
	end
	xs13[_23_1(xs13)] = nil
	xs13["n"] = (_23_1(xs13) - 1)
	return xs13
end)
removeNth_21_1 = (function(li1, idx2)
	local r_481 = type1(li1)
	if (r_481 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_481), 2)
	else
	end
	li1["n"] = (li1["n"] - 1)
	return remove1(li1, idx2)
end)
append1 = (function(xs14, ys1)
	if nil_3f_1(xs14) then
		return ys1
	else
		return cons1(car2(xs14), append1(cdr2(xs14), ys1))
	end
end)
reverse1 = (function(xs15, acc2)
	if _21_1(exists_3f_1(acc2)) then
		return reverse1(xs15, {tag = "list", n = 0})
	elseif nil_3f_1(xs15) then
		return acc2
	else
		return reverse1(cdr2(xs15), cons1(car2(xs15), acc2))
	end
end)
accumulateWith1 = (function(f4, ac1, z2, xs16)
	local r_501 = type1(f4)
	if (r_501 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "f", "function", r_501), 2)
	else
	end
	local r_601 = type1(ac1)
	if (r_601 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "ac", "function", r_601), 2)
	else
	end
	return foldr1(ac1, z2, map1(f4, xs16))
end)
caar1 = (function(x14)
	return car2(car2(x14))
end)
cadr1 = (function(x15)
	return car2(cdr2(x15))
end)
charAt1 = (function(xs17, x16)
	return sub1(xs17, x16, x16)
end)
_2e2e_2 = (function(...)
	local args1 = _pack(...) args1.tag = "list"
	return concat1(args1)
end)
split1 = (function(text1, pattern1, limit1)
	local out2 = {tag = "list", n = 0}
	local loop1 = true
	local start1 = 1
	local r_671 = nil
	r_671 = (function()
		if loop1 then
			local pos1 = list1(find1(text1, pattern1, start1))
			local nstart1 = car2(pos1)
			local nend1 = cadr1(pos1)
			local temp13
			local r_681 = (nstart1 == nil)
			if r_681 then
				temp13 = r_681
			else
				if limit1 then
					temp13 = (_23_1(out2) >= limit1)
				else
					temp13 = limit1
				end
			end
			if temp13 then
				loop1 = false
				pushCdr_21_1(out2, sub1(text1, start1, len1(text1)))
				start1 = (len1(text1) + 1)
			elseif (nstart1 > len1(text1)) then
				if (start1 <= len1(text1)) then
					pushCdr_21_1(out2, sub1(text1, start1, len1(text1)))
				else
				end
				loop1 = false
			elseif (nend1 < nstart1) then
				pushCdr_21_1(out2, sub1(text1, start1, nstart1))
				start1 = (nstart1 + 1)
			else
				pushCdr_21_1(out2, sub1(text1, start1, (nstart1 - 1)))
				start1 = (nend1 + 1)
			end
			return r_671()
		else
		end
	end)
	r_671()
	return out2
end)
local escapes1 = ({})
local r_631 = nil
r_631 = (function(r_641)
	if (r_641 <= 31) then
		escapes1[char1(r_641)] = _2e2e_2("\\", tostring1(r_641))
		return r_631((r_641 + 1))
	else
	end
end)
r_631(0)
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
	local keys1 = _pack(...) keys1.tag = "list"
	if ((_23_1(keys1) % 1) == 1) then
		error1("Expected an even number of arguments to struct", 2)
	else
	end
	local contents1 = (function(key1)
		return key1["contents"]
	end)
	local out3 = ({})
	local r_781 = _23_1(keys1)
	local r_761 = nil
	r_761 = (function(r_771)
		if (r_771 <= r_781) then
			local key2 = keys1[r_771]
			local val5 = keys1[(1 + r_771)]
			out3[(function()
				if key_3f_1(key2) then
					return contents1(key2)
				else
					return key2
				end
			end)()
			] = val5
			return r_761((r_771 + 2))
		else
		end
	end)
	r_761(1)
	return out3
end)
_23_keys1 = (function(st1)
	local cnt1 = 0
	iterPairs1(st1, (function()
		cnt1 = (cnt1 + 1)
		return nil
	end))
	return cnt1
end)
flush1 = io.flush
open1 = io.open
read1 = io.read
write1 = io.write
succ1 = (function(x17)
	return (x17 + 1)
end)
pred1 = (function(x18)
	return (x18 - 1)
end)
symbol_2d3e_string1 = (function(x19)
	if symbol_3f_1(x19) then
		return x19["contents"]
	else
		return nil
	end
end)
fail_21_1 = (function(x20)
	return error1(x20, 0)
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
id1 = (function(x21)
	return x21
end)
self1 = (function(x22, key3, ...)
	local args2 = _pack(...) args2.tag = "list"
	return x22[key3](x22, unpack1(args2, 1, _23_1(args2)))
end)
abs1 = math.abs
huge1 = math.huge
max2 = math.max
modf1 = math.modf
create1 = (function(description1)
	return struct1("desc", description1, "flag-map", ({}), "opt-map", ({}), "opt", {tag = "list", n = 0}, "pos", {tag = "list", n = 0})
end)
setAction1 = (function(arg2, data1, value2)
	data1[arg2["name"]] = value2
	return nil
end)
addAction1 = (function(arg3, data2, value3)
	local lst1 = data2[arg3["name"]]
	if lst1 then
	else
		lst1 = {tag = "list", n = 0}
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
		return usage_21_1(_2e2e_2("Expected number for ", car2(arg1["names"]), ", got ", value4))
	end
end)
addArgument_21_1 = (function(spec1, names1, ...)
	local options1 = _pack(...) options1.tag = "list"
	local r_1601 = type1(names1)
	if (r_1601 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "names", "list", r_1601), 2)
	else
	end
	if nil_3f_1(names1) then
		error1("Names list is empty")
	else
	end
	if ((_23_1(options1) % 2) == 0) then
	else
		error1("Options list should be a multiple of two")
	end
	local result2 = struct1("names", names1, "action", nil, "narg", 0, "default", false, "help", "", "value", true)
	local first1 = car2(names1)
	if (sub1(first1, 1, 2) == "--") then
		pushCdr_21_1(spec1["opt"], result2)
		result2["name"] = sub1(first1, 3)
	elseif (sub1(first1, 1, 1) == "-") then
		pushCdr_21_1(spec1["opt"], result2)
		result2["name"] = sub1(first1, 2)
	else
		result2["name"] = first1
		result2["narg"] = "*"
		result2["default"] = {tag = "list", n = 0}
		pushCdr_21_1(spec1["pos"], result2)
	end
	local r_1991 = _23_1(names1)
	local r_1971 = nil
	r_1971 = (function(r_1981)
		if (r_1981 <= r_1991) then
			local name1 = names1[r_1981]
			if (sub1(name1, 1, 2) == "--") then
				spec1["opt-map"][sub1(name1, 3)] = result2
			elseif (sub1(name1, 1, 1) == "-") then
				spec1["flag-map"][sub1(name1, 2)] = result2
			else
			end
			return r_1971((r_1981 + 1))
		else
		end
	end)
	r_1971(1)
	local r_2031 = _23_1(options1)
	local r_2011 = nil
	r_2011 = (function(r_2021)
		if (r_2021 <= r_2031) then
			local key4 = nth1(options1, r_2021)
			local val7 = nth1(options1, (r_2021 + 1))
			result2[key4] = val7
			return r_2011((r_2021 + 2))
		else
		end
	end)
	r_2011(1)
	if result2["var"] then
	else
		result2["var"] = upper1(result2["name"])
	end
	if result2["action"] then
	else
		result2["action"] = (function()
			local temp14
			if number_3f_1(result2["narg"]) then
				temp14 = (result2["narg"] <= 1)
			else
				temp14 = (result2["narg"] == "?")
			end
			if temp14 then
				return setAction1
			else
				return addAction1
			end
		end)()
	end
	return result2
end)
addHelp_21_1 = (function(spec2)
	return addArgument_21_1(spec2, {tag = "list", n = 2, "--help", "-h"}, "help", "Show this help message", "default", nil, "value", nil, "action", (function(arg4, result3, value5)
		help_21_1(spec2)
		return exit_21_1(0)
	end))
end)
helpNarg_21_1 = (function(buffer1, arg5)
	local r_2051 = arg5["narg"]
	if eq_3f_1(r_2051, "?") then
		return pushCdr_21_1(buffer1, _2e2e_2(" [", arg5["var"], "]"))
	elseif eq_3f_1(r_2051, "*") then
		return pushCdr_21_1(buffer1, _2e2e_2(" [", arg5["var"], "...]"))
	elseif eq_3f_1(r_2051, "+") then
		return pushCdr_21_1(buffer1, _2e2e_2(" ", arg5["var"], " [", arg5["var"], "...]"))
	else
		local r_2061 = nil
		r_2061 = (function(r_2071)
			if (r_2071 <= r_2051) then
				pushCdr_21_1(buffer1, _2e2e_2(" ", arg5["var"]))
				return r_2061((r_2071 + 1))
			else
			end
		end)
		return r_2061(1)
	end
end)
usage_21_2 = (function(spec3, name2)
	if name2 then
	else
		local r_1611 = nth1(arg1, 0)
		if r_1611 then
			name2 = r_1611
		else
			local r_1621 = nth1(arg1, -1)
			if r_1621 then
				name2 = r_1621
			else
				name2 = "?"
			end
		end
	end
	local usage1 = list1("usage: ", name2)
	local r_1641 = spec3["opt"]
	local r_1671 = _23_1(r_1641)
	local r_1651 = nil
	r_1651 = (function(r_1661)
		if (r_1661 <= r_1671) then
			local arg6 = r_1641[r_1661]
			pushCdr_21_1(usage1, _2e2e_2(" [", car2(arg6["names"])))
			helpNarg_21_1(usage1, arg6)
			pushCdr_21_1(usage1, "]")
			return r_1651((r_1661 + 1))
		else
		end
	end)
	r_1651(1)
	local r_1701 = spec3["pos"]
	local r_1731 = _23_1(r_1701)
	local r_1711 = nil
	r_1711 = (function(r_1721)
		if (r_1721 <= r_1731) then
			local arg7 = r_1701[r_1721]
			helpNarg_21_1(usage1, arg7)
			return r_1711((r_1721 + 1))
		else
		end
	end)
	r_1711(1)
	return print1(concat1(usage1))
end)
usageError_21_1 = (function(spec4, name3, error2)
	usage_21_2(spec4, name3)
	print1(error2)
	return exit_21_1(1)
end)
help_21_1 = (function(spec5, name4)
	if name4 then
	else
		local r_1751 = nth1(arg1, 0)
		if r_1751 then
			name4 = r_1751
		else
			local r_1761 = nth1(arg1, -1)
			if r_1761 then
				name4 = r_1761
			else
				name4 = "?"
			end
		end
	end
	usage_21_2(spec5, name4)
	if spec5["desc"] then
		print1()
		print1(spec5["desc"])
	else
	end
	local max3 = 0
	local r_1781 = spec5["pos"]
	local r_1811 = _23_1(r_1781)
	local r_1791 = nil
	r_1791 = (function(r_1801)
		if (r_1801 <= r_1811) then
			local arg8 = r_1781[r_1801]
			local len3 = len1(arg8["var"])
			if (len3 > max3) then
				max3 = len3
			else
			end
			return r_1791((r_1801 + 1))
		else
		end
	end)
	r_1791(1)
	local r_1841 = spec5["opt"]
	local r_1871 = _23_1(r_1841)
	local r_1851 = nil
	r_1851 = (function(r_1861)
		if (r_1861 <= r_1871) then
			local arg9 = r_1841[r_1861]
			local len4 = len1(concat1(arg9["names"], ", "))
			if (len4 > max3) then
				max3 = len4
			else
			end
			return r_1851((r_1861 + 1))
		else
		end
	end)
	r_1851(1)
	local fmt1 = _2e2e_2(" %-", tostring1((max3 + 1)), "s %s")
	if nil_3f_1(spec5["pos"]) then
	else
		print1()
		print1("Positional arguments")
		local r_1901 = spec5["pos"]
		local r_1931 = _23_1(r_1901)
		local r_1911 = nil
		r_1911 = (function(r_1921)
			if (r_1921 <= r_1931) then
				local arg10 = r_1901[r_1921]
				print1(format1(fmt1, arg10["var"], arg10["help"]))
				return r_1911((r_1921 + 1))
			else
			end
		end)
		r_1911(1)
	end
	if nil_3f_1(spec5["opt"]) then
	else
		print1()
		print1("Optional arguments")
		local r_2111 = spec5["opt"]
		local r_2141 = _23_1(r_2111)
		local r_2121 = nil
		r_2121 = (function(r_2131)
			if (r_2131 <= r_2141) then
				local arg11 = r_2111[r_2131]
				print1(format1(fmt1, concat1(arg11["names"], ", "), arg11["help"]))
				return r_2121((r_2131 + 1))
			else
			end
		end)
		return r_2121(1)
	end
end)
matcher1 = (function(pattern2)
	return (function(x23)
		local res1 = list1(match1(x23, pattern2))
		if (car2(res1) == nil) then
			return nil
		else
			return res1
		end
	end)
end)
parse_21_1 = (function(spec6, args3)
	if args3 then
	else
		args3 = arg1
	end
	local result4 = ({})
	local pos2 = spec6["pos"]
	local idx3 = 1
	local len5 = _23_1(args3)
	local usage_21_3 = (function(msg1)
		return usageError_21_1(spec6, nth1(args3, 0), msg1)
	end)
	local action1 = (function(arg12, value6)
		return arg12["action"](arg12, result4, value6, usage_21_3)
	end)
	local readArgs1 = (function(key5, arg13)
		local r_2451 = arg13["narg"]
		if eq_3f_1(r_2451, "+") then
			idx3 = (idx3 + 1)
			local elem1 = nth1(args3, idx3)
			if (elem1 == nil) then
				usage_21_3(_2e2e_2("Expected ", arg13["var"], " after --", key5, ", got nothing"))
			else
				local temp15
				local r_2461 = _21_1(arg13["all"])
				if r_2461 then
					temp15 = find1(elem1, "^%-")
				else
					temp15 = r_2461
				end
				if temp15 then
					usage_21_3(_2e2e_2("Expected ", arg13["var"], " after --", key5, ", got ", nth1(args3, idx3)))
				else
					action1(arg13, elem1)
				end
			end
			local running1 = true
			local r_2471 = nil
			r_2471 = (function()
				if running1 then
					idx3 = (idx3 + 1)
					local elem2 = nth1(args3, idx3)
					if (elem2 == nil) then
						running1 = false
					else
						local temp16
						local r_2481 = _21_1(arg13["all"])
						if r_2481 then
							temp16 = find1(elem2, "^%-")
						else
							temp16 = r_2481
						end
						if temp16 then
							running1 = false
						else
							action1(arg13, elem2)
						end
					end
					return r_2471()
				else
				end
			end)
			return r_2471()
		elseif eq_3f_1(r_2451, "*") then
			local running2 = true
			local r_2491 = nil
			r_2491 = (function()
				if running2 then
					idx3 = (idx3 + 1)
					local elem3 = nth1(args3, idx3)
					if (elem3 == nil) then
						running2 = false
					else
						local temp17
						local r_2501 = _21_1(arg13["all"])
						if r_2501 then
							temp17 = find1(elem3, "^%-")
						else
							temp17 = r_2501
						end
						if temp17 then
							running2 = false
						else
							action1(arg13, elem3)
						end
					end
					return r_2491()
				else
				end
			end)
			return r_2491()
		elseif eq_3f_1(r_2451, "?") then
			idx3 = (idx3 + 1)
			local elem4 = nth1(args3, idx3)
			local temp18
			local r_2511 = (elem4 == nil)
			if r_2511 then
				temp18 = r_2511
			else
				local r_2521 = _21_1(arg13["all"])
				if r_2521 then
					temp18 = find1(elem4, "^%-")
				else
					temp18 = r_2521
				end
			end
			if temp18 then
				return arg13["action"](arg13, result4, arg13["value"])
			else
				idx3 = (idx3 + 1)
				return action1(arg13, elem4)
			end
		elseif eq_3f_1(r_2451, 0) then
			idx3 = (idx3 + 1)
			return action1(arg13, arg13["value"])
		else
			local r_2531 = nil
			r_2531 = (function(r_2541)
				if (r_2541 <= r_2451) then
					idx3 = (idx3 + 1)
					local elem5 = nth1(args3, idx3)
					if (elem5 == nil) then
						usage_21_3(_2e2e_2("Expected ", r_2451, " args for ", key5, ", got ", pred1(r_2541)))
					else
						local temp19
						local r_2571 = _21_1(arg13["all"])
						if r_2571 then
							temp19 = find1(elem5, "^%-")
						else
							temp19 = r_2571
						end
						if temp19 then
							usage_21_3(_2e2e_2("Expected ", r_2451, " for ", key5, ", got ", pred1(r_2541)))
						else
							action1(arg13, elem5)
						end
					end
					return r_2531((r_2541 + 1))
				else
				end
			end)
			r_2531(1)
			idx3 = (idx3 + 1)
			return nil
		end
	end)
	local r_2161 = nil
	r_2161 = (function()
		if (idx3 <= len5) then
			local r_2171 = nth1(args3, idx3)
			local temp20
			local r_2181 = matcher1("^%-%-([^=]+)=(.+)$")(r_2171)
			local r_2211 = list_3f_1(r_2181)
			if r_2211 then
				local r_2221 = (_23_1(r_2181) == 2)
				if r_2221 then
					temp20 = true
				else
					temp20 = r_2221
				end
			else
				temp20 = r_2211
			end
			if temp20 then
				local key6 = nth1(matcher1("^%-%-([^=]+)=(.+)$")(r_2171), 1)
				local val8 = nth1(matcher1("^%-%-([^=]+)=(.+)$")(r_2171), 2)
				local arg14 = spec6["opt-map"][key6]
				if (arg14 == nil) then
					usage_21_3(_2e2e_2("Unknown argument ", key6, " in ", nth1(args3, idx3)))
				else
					local temp21
					local r_2241 = _21_1(arg14["many"])
					if r_2241 then
						temp21 = (nil ~= result4[arg14["name"]])
					else
						temp21 = r_2241
					end
					if temp21 then
						usage_21_3(_2e2e_2("Too may values for ", key6, " in ", nth1(args3, idx3)))
					else
						local narg1 = arg14["narg"]
						local temp22
						local r_2251 = number_3f_1(narg1)
						if r_2251 then
							temp22 = (narg1 ~= 1)
						else
							temp22 = r_2251
						end
						if temp22 then
							usage_21_3(_2e2e_2("Expected ", tostring1(narg1), " values, got 1 in ", nth1(args3, idx3)))
						else
						end
						action1(arg14, val8)
					end
				end
				idx3 = (idx3 + 1)
			else
				local temp23
				local r_2191 = matcher1("^%-%-(.*)$")(r_2171)
				local r_2261 = list_3f_1(r_2191)
				if r_2261 then
					local r_2271 = (_23_1(r_2191) == 1)
					if r_2271 then
						temp23 = true
					else
						temp23 = r_2271
					end
				else
					temp23 = r_2261
				end
				if temp23 then
					local key7 = nth1(matcher1("^%-%-(.*)$")(r_2171), 1)
					local arg15 = spec6["opt-map"][key7]
					if (arg15 == nil) then
						usage_21_3(_2e2e_2("Unknown argument ", key7, " in ", nth1(args3, idx3)))
					else
						local temp24
						local r_2281 = _21_1(arg15["many"])
						if r_2281 then
							temp24 = (nil ~= result4[arg15["name"]])
						else
							temp24 = r_2281
						end
						if temp24 then
							usage_21_3(_2e2e_2("Too may values for ", key7, " in ", nth1(args3, idx3)))
						else
							readArgs1(key7, arg15)
						end
					end
				else
					local temp25
					local r_2201 = matcher1("^%-(.+)$")(r_2171)
					local r_2291 = list_3f_1(r_2201)
					if r_2291 then
						local r_2301 = (_23_1(r_2201) == 1)
						if r_2301 then
							temp25 = true
						else
							temp25 = r_2301
						end
					else
						temp25 = r_2291
					end
					if temp25 then
						local flags1 = nth1(matcher1("^%-(.+)$")(r_2171), 1)
						local i1 = 1
						local s1 = len1(flags1)
						local r_2311 = nil
						r_2311 = (function()
							if (i1 <= s1) then
								local key8 = charAt1(flags1, i1)
								local arg16 = spec6["flag-map"][key8]
								if (arg16 == nil) then
									usage_21_3(_2e2e_2("Unknown flag ", key8, " in ", nth1(args3, idx3)))
								else
									local temp26
									local r_2321 = _21_1(arg16["many"])
									if r_2321 then
										temp26 = (nil ~= result4[arg16["name"]])
									else
										temp26 = r_2321
									end
									if temp26 then
										usage_21_3(_2e2e_2("Too many occurances of ", key8, " in ", nth1(args3, idx3)))
									else
										local narg2 = arg16["narg"]
										if (i1 == s1) then
											readArgs1(key8, arg16)
										elseif (narg2 == 0) then
											action1(arg16, arg16["value"])
										else
											action1(arg16, sub1(flags1, succ1(i1)))
											i1 = succ1(s1)
											idx3 = (idx3 + 1)
										end
									end
								end
								i1 = (i1 + 1)
								return r_2311()
							else
							end
						end)
						r_2311()
					else
						local arg17 = car2(spec6["pos"])
						if arg17 then
							action1(arg17, r_2171)
						else
							usage_21_3(_2e2e_2("Unknown argument ", arg17))
						end
						idx3 = (idx3 + 1)
					end
				end
			end
			return r_2161()
		else
		end
	end)
	r_2161()
	local r_2341 = spec6["opt"]
	local r_2371 = _23_1(r_2341)
	local r_2351 = nil
	r_2351 = (function(r_2361)
		if (r_2361 <= r_2371) then
			local arg18 = r_2341[r_2361]
			if (result4[arg18["name"]] == nil) then
				result4[arg18["name"]] = arg18["default"]
			else
			end
			return r_2351((r_2361 + 1))
		else
		end
	end)
	r_2351(1)
	local r_2401 = spec6["pos"]
	local r_2431 = _23_1(r_2401)
	local r_2411 = nil
	r_2411 = (function(r_2421)
		if (r_2421 <= r_2431) then
			local arg19 = r_2401[r_2421]
			if (result4[arg19["name"]] == nil) then
				result4[arg19["name"]] = arg19["default"]
			else
			end
			return r_2411((r_2421 + 1))
		else
		end
	end)
	r_2411(1)
	return result4
end)
builtins1 = require1("tacky.analysis.resolve")["builtins"]
builtinVars1 = require1("tacky.analysis.resolve")["declaredVars"]
sideEffect_3f_1 = (function(node1)
	local tag4 = type1(node1)
	local temp27
	local r_2621 = (tag4 == "number")
	if r_2621 then
		temp27 = r_2621
	else
		local r_2631 = (tag4 == "string")
		if r_2631 then
			temp27 = r_2631
		else
			local r_2641 = (tag4 == "key")
			if r_2641 then
				temp27 = r_2641
			else
				temp27 = (tag4 == "symbol")
			end
		end
	end
	if temp27 then
		return false
	elseif (tag4 == "list") then
		local fst1 = car2(node1)
		if (type1(fst1) == "symbol") then
			local var1 = fst1["var"]
			local r_2651 = (var1 ~= builtins1["lambda"])
			if r_2651 then
				return (var1 ~= builtins1["quote"])
			else
				return r_2651
			end
		else
			return true
		end
	else
		_error("unmatched item")
	end
end)
constant_3f_1 = (function(node2)
	local r_2661 = string_3f_1(node2)
	if r_2661 then
		return r_2661
	else
		local r_2671 = number_3f_1(node2)
		if r_2671 then
			return r_2671
		else
			return key_3f_1(node2)
		end
	end
end)
urn_2d3e_val1 = (function(node3)
	if string_3f_1(node3) then
		return node3["value"]
	elseif number_3f_1(node3) then
		return node3["value"]
	elseif key_3f_1(node3) then
		return node3["value"]
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
urn_2d3e_bool1 = (function(node4)
	local temp28
	local r_2681 = string_3f_1(node4)
	if r_2681 then
		temp28 = r_2681
	else
		local r_2691 = key_3f_1(node4)
		if r_2691 then
			temp28 = r_2691
		else
			temp28 = number_3f_1(node4)
		end
	end
	if temp28 then
		return true
	elseif symbol_3f_1(node4) then
		if (builtinVars1["true"] == node4["var"]) then
			return true
		elseif (builtinVars1["false"] == node4["var"]) then
			return false
		elseif (builtinVars1["nil"] == node4["var"]) then
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
	return {tag = "list", n = 1, (function()
		local _offset, _result, _temp = 0, {tag="list",n=0}
		_result[1 + _offset] = lambda1
		_result[2 + _offset] = {tag = "list", n = 0}
		_temp = body1
		for _c = 1, _temp.n do _result[2 + _c + _offset] = _temp[_c] end
		_offset = _offset + _temp.n
		_result.n = _offset + 2
		return _result
	end)()
	}
end)
putError_21_1 = (function(logger1, msg2)
	return self1(logger1, "put-error!", msg2)
end)
putWarning_21_1 = (function(logger2, msg3)
	return self1(logger2, "put-warning!", msg3)
end)
putVerbose_21_1 = (function(logger3, msg4)
	return self1(logger3, "put-verbose!", msg4)
end)
putDebug_21_1 = (function(logger4, msg5)
	return self1(logger4, "put-debug!", msg5)
end)
putNodeError_21_1 = (function(logger5, msg6, node5, explain1, ...)
	local lines1 = _pack(...) lines1.tag = "list"
	return self1(logger5, "put-node-error!", msg6, node5, explain1, lines1)
end)
putNodeWarning_21_1 = (function(logger6, msg7, node6, explain2, ...)
	local lines2 = _pack(...) lines2.tag = "list"
	return self1(logger6, "put-node-warning!", msg7, node6, explain2, lines2)
end)
doNodeError_21_1 = (function(logger7, msg8, node7, explain3, ...)
	local lines3 = _pack(...) lines3.tag = "list"
	self1(logger7, "put-node-error!", msg8, node7, explain3, lines3)
	return fail_21_1((function(r_2751)
		if r_2751 then
			return r_2751
		else
			return msg8
		end
	end)(match1(msg8, "^([^\n]+)\n")))
end)
struct1("putError", putError_21_1, "putWarning", putWarning_21_1, "putVerbose", putVerbose_21_1, "putDebug", putDebug_21_1, "putNodeError", putNodeError_21_1, "putNodeWarning", putNodeWarning_21_1, "doNodeError", doNodeError_21_1)
createTracker1 = (function()
	return struct1("changed", false)
end)
changed_3f_1 = (function(tracker1)
	return tracker1["changed"]
end)
passEnabled_3f_1 = (function(pass1, options2)
	local override1 = options2["override"]
	local r_2721 = (options2["level"] >= (function(r_2741)
		if r_2741 then
			return r_2741
		else
			return 1
		end
	end)(pass1["level"]))
	if r_2721 then
		local r_2731
		if (pass1["on"] == false) then
			r_2731 = (override1[pass1["name"]] == true)
		else
			r_2731 = (override1[pass1["name"]] ~= false)
		end
		if r_2731 then
			return all1((function(cat1)
				return (false ~= override1[cat1])
			end), pass1["cat"])
		else
			return r_2731
		end
	else
		return r_2721
	end
end)
runPass1 = (function(pass2, options3, tracker2, ...)
	local args4 = _pack(...) args4.tag = "list"
	if passEnabled_3f_1(pass2, options3) then
		local start2 = clock1()
		local ptracker1 = createTracker1()
		local name5 = _2e2e_2("[", concat1(pass2["cat"], " "), "] ", pass2["name"])
		pass2["run"](ptracker1, options3, unpack1(args4, 1, _23_1(args4)))
		if options3["time"] then
			putVerbose_21_1(options3["logger"], _2e2e_2(name5, " took ", (clock1() - start2), "."))
		else
		end
		if changed_3f_1(ptracker1) then
			if options3["track"] then
				putVerbose_21_1(options3["logger"], _2e2e_2(name5, " did something."))
			else
			end
			if tracker2 then
				tracker2["changed"] = true
			else
			end
		else
		end
		return changed_3f_1(ptracker1)
	else
	end
end)
builtins2 = require1("tacky.analysis.resolve")["builtins"]
traverseQuote1 = (function(node8, visitor1, level1)
	if (level1 == 0) then
		return traverseNode1(node8, visitor1)
	else
		local tag5 = node8["tag"]
		local temp29
		local r_2871 = (tag5 == "string")
		if r_2871 then
			temp29 = r_2871
		else
			local r_2881 = (tag5 == "number")
			if r_2881 then
				temp29 = r_2881
			else
				local r_2891 = (tag5 == "key")
				if r_2891 then
					temp29 = r_2891
				else
					temp29 = (tag5 == "symbol")
				end
			end
		end
		if temp29 then
			return node8
		elseif (tag5 == "list") then
			local first2 = nth1(node8, 1)
			local temp30
			if first2 then
				temp30 = (first2["tag"] == "symbol")
			else
				temp30 = first2
			end
			if temp30 then
				local temp31
				local r_2911 = (first2["contents"] == "unquote")
				if r_2911 then
					temp31 = r_2911
				else
					temp31 = (first2["contents"] == "unquote-splice")
				end
				if temp31 then
					node8[2] = traverseQuote1(nth1(node8, 2), visitor1, pred1(level1))
					return node8
				elseif (first2["contents"] == "syntax-quote") then
					node8[2] = traverseQuote1(nth1(node8, 2), visitor1, succ1(level1))
					return node8
				else
					local r_2941 = _23_1(node8)
					local r_2921 = nil
					r_2921 = (function(r_2931)
						if (r_2931 <= r_2941) then
							node8[r_2931] = traverseQuote1(nth1(node8, r_2931), visitor1, level1)
							return r_2921((r_2931 + 1))
						else
						end
					end)
					r_2921(1)
					return node8
				end
			else
				local r_2981 = _23_1(node8)
				local r_2961 = nil
				r_2961 = (function(r_2971)
					if (r_2971 <= r_2981) then
						node8[r_2971] = traverseQuote1(nth1(node8, r_2971), visitor1, level1)
						return r_2961((r_2971 + 1))
					else
					end
				end)
				r_2961(1)
				return node8
			end
		elseif error1 then
			return _2e2e_2("Unknown tag ", tag5)
		else
			_error("unmatched item")
		end
	end
end)
traverseNode1 = (function(node9, visitor2)
	local tag6 = node9["tag"]
	local temp32
	local r_2761 = (tag6 == "string")
	if r_2761 then
		temp32 = r_2761
	else
		local r_2771 = (tag6 == "number")
		if r_2771 then
			temp32 = r_2771
		else
			local r_2781 = (tag6 == "key")
			if r_2781 then
				temp32 = r_2781
			else
				temp32 = (tag6 == "symbol")
			end
		end
	end
	if temp32 then
		return visitor2(node9, visitor2)
	elseif (tag6 == "list") then
		local first3 = car2(node9)
		first3 = visitor2(first3, visitor2)
		node9[1] = first3
		if (first3["tag"] == "symbol") then
			local func1 = first3["var"]
			local funct1 = func1["tag"]
			if (func1 == builtins2["lambda"]) then
				traverseBlock1(node9, 3, visitor2)
				return visitor2(node9, visitor2)
			elseif (func1 == builtins2["cond"]) then
				local r_3021 = _23_1(node9)
				local r_3001 = nil
				r_3001 = (function(r_3011)
					if (r_3011 <= r_3021) then
						local case1 = nth1(node9, r_3011)
						case1[1] = traverseNode1(nth1(case1, 1), visitor2)
						traverseBlock1(case1, 2, visitor2)
						return r_3001((r_3011 + 1))
					else
					end
				end)
				r_3001(2)
				return visitor2(node9, visitor2)
			elseif (func1 == builtins2["set!"]) then
				node9[3] = traverseNode1(nth1(node9, 3), visitor2)
				return visitor2(node9, visitor2)
			elseif (func1 == builtins2["quote"]) then
				return visitor2(node9, visitor2)
			elseif (func1 == builtins2["syntax-quote"]) then
				node9[2] = traverseQuote1(nth1(node9, 2), visitor2, 1)
				return visitor2(node9, visitor2)
			else
				local temp33
				local r_3041 = (func1 == builtins2["unquote"])
				if r_3041 then
					temp33 = r_3041
				else
					temp33 = (func1 == builtins2["unquote-splice"])
				end
				if temp33 then
					return fail_21_1("unquote/unquote-splice should never appear head")
				else
					local temp34
					local r_3051 = (func1 == builtins2["define"])
					if r_3051 then
						temp34 = r_3051
					else
						temp34 = (func1 == builtins2["define-macro"])
					end
					if temp34 then
						node9[_23_1(node9)] = traverseNode1(nth1(node9, _23_1(node9)), visitor2)
						return visitor2(node9, visitor2)
					elseif (func1 == builtins2["define-native"]) then
						return visitor2(node9, visitor2)
					elseif (func1 == builtins2["import"]) then
						return visitor2(node9, visitor2)
					else
						local temp35
						local r_3061 = (funct1 == "defined")
						if r_3061 then
							temp35 = r_3061
						else
							local r_3071 = (funct1 == "arg")
							if r_3071 then
								temp35 = r_3071
							else
								local r_3081 = (funct1 == "native")
								if r_3081 then
									temp35 = r_3081
								else
									temp35 = (funct1 == "macro")
								end
							end
						end
						if temp35 then
							traverseList1(node9, 1, visitor2)
							return visitor2(node9, visitor2)
						else
							return fail_21_1(_2e2e_2("Unknown kind ", funct1, " for variable ", func1["name"]))
						end
					end
				end
			end
		else
			traverseList1(node9, 1, visitor2)
			return visitor2(node9, visitor2)
		end
	else
		return error1(_2e2e_2("Unknown tag ", tag6))
	end
end)
traverseBlock1 = (function(node10, start3, visitor3)
	local r_2811 = _23_1(node10)
	local r_2791 = nil
	r_2791 = (function(r_2801)
		if (r_2801 <= r_2811) then
			local result5 = traverseNode1(nth1(node10, (r_2801 + 0)), visitor3)
			node10[r_2801] = result5
			return r_2791((r_2801 + 1))
		else
		end
	end)
	r_2791(start3)
	return node10
end)
traverseList1 = (function(node11, start4, visitor4)
	local r_2851 = _23_1(node11)
	local r_2831 = nil
	r_2831 = (function(r_2841)
		if (r_2841 <= r_2851) then
			node11[r_2841] = traverseNode1(nth1(node11, r_2841), visitor4)
			return r_2831((r_2841 + 1))
		else
		end
	end)
	r_2831(start4)
	return node11
end)
builtins3 = require1("tacky.analysis.resolve")["builtins"]
visitQuote1 = (function(node12, visitor5, level2)
	if (level2 == 0) then
		return visitNode1(node12, visitor5)
	else
		local tag7 = node12["tag"]
		local temp36
		local r_3241 = (tag7 == "string")
		if r_3241 then
			temp36 = r_3241
		else
			local r_3251 = (tag7 == "number")
			if r_3251 then
				temp36 = r_3251
			else
				local r_3261 = (tag7 == "key")
				if r_3261 then
					temp36 = r_3261
				else
					temp36 = (tag7 == "symbol")
				end
			end
		end
		if temp36 then
			return nil
		elseif (tag7 == "list") then
			local first4 = nth1(node12, 1)
			local temp37
			if first4 then
				temp37 = (first4["tag"] == "symbol")
			else
				temp37 = first4
			end
			if temp37 then
				local temp38
				local r_3281 = (first4["contents"] == "unquote")
				if r_3281 then
					temp38 = r_3281
				else
					temp38 = (first4["contents"] == "unquote-splice")
				end
				if temp38 then
					return visitQuote1(nth1(node12, 2), visitor5, pred1(level2))
				elseif (first4["contents"] == "syntax-quote") then
					return visitQuote1(nth1(node12, 2), visitor5, succ1(level2))
				else
					local r_3331 = _23_1(node12)
					local r_3311 = nil
					r_3311 = (function(r_3321)
						if (r_3321 <= r_3331) then
							local sub2 = node12[r_3321]
							visitQuote1(sub2, visitor5, level2)
							return r_3311((r_3321 + 1))
						else
						end
					end)
					return r_3311(1)
				end
			else
				local r_3391 = _23_1(node12)
				local r_3371 = nil
				r_3371 = (function(r_3381)
					if (r_3381 <= r_3391) then
						local sub3 = node12[r_3381]
						visitQuote1(sub3, visitor5, level2)
						return r_3371((r_3381 + 1))
					else
					end
				end)
				return r_3371(1)
			end
		elseif error1 then
			return _2e2e_2("Unknown tag ", tag7)
		else
			_error("unmatched item")
		end
	end
end)
visitNode1 = (function(node13, visitor6)
	if (visitor6(node13, visitor6) == false) then
	else
		local tag8 = node13["tag"]
		local temp39
		local r_3171 = (tag8 == "string")
		if r_3171 then
			temp39 = r_3171
		else
			local r_3181 = (tag8 == "number")
			if r_3181 then
				temp39 = r_3181
			else
				local r_3191 = (tag8 == "key")
				if r_3191 then
					temp39 = r_3191
				else
					temp39 = (tag8 == "symbol")
				end
			end
		end
		if temp39 then
			return nil
		elseif (tag8 == "list") then
			local first5 = nth1(node13, 1)
			if (first5["tag"] == "symbol") then
				local func2 = first5["var"]
				local funct2 = func2["tag"]
				if (func2 == builtins3["lambda"]) then
					return visitBlock1(node13, 3, visitor6)
				elseif (func2 == builtins3["cond"]) then
					local r_3431 = _23_1(node13)
					local r_3411 = nil
					r_3411 = (function(r_3421)
						if (r_3421 <= r_3431) then
							local case2 = nth1(node13, r_3421)
							visitNode1(nth1(case2, 1), visitor6)
							visitBlock1(case2, 2, visitor6)
							return r_3411((r_3421 + 1))
						else
						end
					end)
					return r_3411(2)
				elseif (func2 == builtins3["set!"]) then
					return visitNode1(nth1(node13, 3), visitor6)
				elseif (func2 == builtins3["quote"]) then
				elseif (func2 == builtins3["syntax-quote"]) then
					return visitQuote1(nth1(node13, 2), visitor6, 1)
				else
					local temp40
					local r_3451 = (func2 == builtins3["unquote"])
					if r_3451 then
						temp40 = r_3451
					else
						temp40 = (func2 == builtins3["unquote-splice"])
					end
					if temp40 then
						return fail_21_1("unquote/unquote-splice should never appear head")
					else
						local temp41
						local r_3461 = (func2 == builtins3["define"])
						if r_3461 then
							temp41 = r_3461
						else
							temp41 = (func2 == builtins3["define-macro"])
						end
						if temp41 then
							return visitNode1(nth1(node13, _23_1(node13)), visitor6)
						elseif (func2 == builtins3["define-native"]) then
						elseif (func2 == builtins3["import"]) then
						else
							local temp42
							local r_3471 = (funct2 == "defined")
							if r_3471 then
								temp42 = r_3471
							else
								local r_3481 = (funct2 == "arg")
								if r_3481 then
									temp42 = r_3481
								else
									local r_3491 = (funct2 == "native")
									if r_3491 then
										temp42 = r_3491
									else
										temp42 = (funct2 == "macro")
									end
								end
							end
							if temp42 then
								return visitBlock1(node13, 1, visitor6)
							else
								return fail_21_1(_2e2e_2("Unknown kind ", funct2, " for variable ", func2["name"]))
							end
						end
					end
				end
			else
				return visitBlock1(node13, 1, visitor6)
			end
		else
			return error1(_2e2e_2("Unknown tag ", tag8))
		end
	end
end)
visitBlock1 = (function(node14, start5, visitor7)
	local r_3221 = _23_1(node14)
	local r_3201 = nil
	r_3201 = (function(r_3211)
		if (r_3211 <= r_3221) then
			visitNode1(nth1(node14, r_3211), visitor7)
			return r_3201((r_3211 + 1))
		else
		end
	end)
	return r_3201(start5)
end)
createState1 = (function()
	return struct1("vars", ({}), "nodes", ({}))
end)
getVar1 = (function(state1, var2)
	local entry1 = state1["vars"][var2]
	if entry1 then
	else
		entry1 = struct1("var", var2, "usages", struct1(), "defs", struct1(), "active", false)
		state1["vars"][var2] = entry1
	end
	return entry1
end)
getNode1 = (function(state2, node15)
	local entry2 = state2["nodes"][node15]
	if entry2 then
	else
		entry2 = struct1("uses", {tag = "list", n = 0})
		state2["nodes"][node15] = entry2
	end
	return entry2
end)
addUsage_21_1 = (function(state3, var3, node16)
	local varMeta1 = getVar1(state3, var3)
	local nodeMeta1 = getNode1(state3, node16)
	varMeta1["usages"][node16] = true
	varMeta1["active"] = true
	nodeMeta1["uses"][var3] = true
	return nil
end)
addDefinition_21_1 = (function(state4, var4, node17, kind1, value7)
	local varMeta2 = getVar1(state4, var4)
	varMeta2["defs"][node17] = struct1("tag", kind1, "value", value7)
	return nil
end)
definitionsVisitor1 = (function(state5, node18, visitor8)
	local temp43
	local r_3091 = list_3f_1(node18)
	if r_3091 then
		temp43 = symbol_3f_1(car2(node18))
	else
		temp43 = r_3091
	end
	if temp43 then
		local func3 = car2(node18)["var"]
		if (func3 == builtins1["lambda"]) then
			local r_3511 = nth1(node18, 2)
			local r_3541 = _23_1(r_3511)
			local r_3521 = nil
			r_3521 = (function(r_3531)
				if (r_3531 <= r_3541) then
					local arg20 = r_3511[r_3531]
					addDefinition_21_1(state5, arg20["var"], arg20, "arg", arg20)
					return r_3521((r_3531 + 1))
				else
				end
			end)
			return r_3521(1)
		elseif (func3 == builtins1["set!"]) then
			return addDefinition_21_1(state5, node18[2]["var"], node18, "set", nth1(node18, 3))
		else
			local temp44
			local r_3561 = (func3 == builtins1["define"])
			if r_3561 then
				temp44 = r_3561
			else
				temp44 = (func3 == builtins1["define-macro"])
			end
			if temp44 then
				return addDefinition_21_1(state5, node18["defVar"], node18, "define", nth1(node18, _23_1(node18)))
			elseif (func3 == builtins1["define-native"]) then
				return addDefinition_21_1(state5, node18["defVar"], node18, "native")
			else
			end
		end
	else
		local temp45
		local r_3571 = list_3f_1(node18)
		if r_3571 then
			local r_3581 = list_3f_1(car2(node18))
			if r_3581 then
				local r_3591 = symbol_3f_1(caar1(node18))
				if r_3591 then
					temp45 = (caar1(node18)["var"] == builtins1["lambda"])
				else
					temp45 = r_3591
				end
			else
				temp45 = r_3581
			end
		else
			temp45 = r_3571
		end
		if temp45 then
			local lam1 = car2(node18)
			local args5 = nth1(lam1, 2)
			local offset1 = 1
			local r_3621 = _23_1(args5)
			local r_3601 = nil
			r_3601 = (function(r_3611)
				if (r_3611 <= r_3621) then
					local arg21 = nth1(args5, r_3611)
					local val10 = nth1(node18, (r_3611 + offset1))
					if arg21["var"]["isVariadic"] then
						local count1 = (_23_1(node18) - _23_1(args5))
						if (count1 < 0) then
							count1 = 0
						else
						end
						offset1 = count1
						addDefinition_21_1(state5, arg21["var"], arg21, "arg", arg21)
					else
						addDefinition_21_1(state5, arg21["var"], arg21, "let", (function()
							if val10 then
								return val10
							else
								return struct1("tag", "symbol", "contents", "nil", "var", builtinVars1["nil"])
							end
						end)())
					end
					return r_3601((r_3611 + 1))
				else
				end
			end)
			r_3601(1)
			visitBlock1(node18, 2, visitor8)
			visitBlock1(lam1, 3, visitor8)
			return false
		else
		end
	end
end)
definitionsVisit1 = (function(state6, nodes1)
	return visitBlock1(nodes1, 1, (function(r_3701, r_3711)
		return definitionsVisitor1(state6, r_3701, r_3711)
	end))
end)
usagesVisit1 = (function(state7, nodes2, pred2)
	if pred2 then
	else
		pred2 = (function()
			return true
		end)
	end
	local queue1 = {tag = "list", n = 0}
	local visited1 = ({})
	local addUsage1 = (function(var5, user1)
		addUsage_21_1(state7, var5, user1)
		local varMeta3 = getVar1(state7, var5)
		if varMeta3["active"] then
			return iterPairs1(varMeta3["defs"], (function(_5f_1, def1)
				local val11 = def1["value"]
				local temp46
				if val11 then
					temp46 = _21_1(visited1[val11])
				else
					temp46 = val11
				end
				if temp46 then
					return pushCdr_21_1(queue1, val11)
				else
				end
			end))
		else
		end
	end)
	local visit1 = (function(node19)
		if visited1[node19] then
			return false
		else
			visited1[node19] = true
			if symbol_3f_1(node19) then
				addUsage1(node19["var"], node19)
				return true
			else
				local temp47
				local r_3651 = list_3f_1(node19)
				if r_3651 then
					local r_3661 = (_23_1(node19) > 0)
					if r_3661 then
						temp47 = symbol_3f_1(car2(node19))
					else
						temp47 = r_3661
					end
				else
					temp47 = r_3651
				end
				if temp47 then
					local func4 = car2(node19)["var"]
					local temp48
					local r_3671 = (func4 == builtins1["set!"])
					if r_3671 then
						temp48 = r_3671
					else
						local r_3681 = (func4 == builtins1["define"])
						if r_3681 then
							temp48 = r_3681
						else
							temp48 = (func4 == builtins1["define-macro"])
						end
					end
					if temp48 then
						if pred2(nth1(node19, 3)) then
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
	local r_3141 = _23_1(nodes2)
	local r_3121 = nil
	r_3121 = (function(r_3131)
		if (r_3131 <= r_3141) then
			local node20 = nodes2[r_3131]
			pushCdr_21_1(queue1, node20)
			return r_3121((r_3131 + 1))
		else
		end
	end)
	r_3121(1)
	local r_3161 = nil
	r_3161 = (function()
		if (_23_1(queue1) > 0) then
			visitNode1(removeNth_21_1(queue1, 1), visit1)
			return r_3161()
		else
		end
	end)
	return r_3161()
end)
tagUsage1 = struct1("name", "tag-usage", "help", "Gathers usage and definition data for all expressions in NODES, storing it in LOOKUP.", "cat", {tag = "list", n = 2, "tag", "usage"}, "run", (function(r_3721, state8, nodes3, lookup1)
	definitionsVisit1(lookup1, nodes3)
	return usagesVisit1(lookup1, nodes3, sideEffect_3f_1)
end))
formatPosition1 = (function(pos3)
	return _2e2e_2(pos3["line"], ":", pos3["column"])
end)
formatRange1 = (function(range1)
	if range1["finish"] then
		return format1("%s:[%s .. %s]", range1["name"], formatPosition1(range1["start"]), formatPosition1(range1["finish"]))
	else
		return format1("%s:[%s]", range1["name"], formatPosition1(range1["start"]))
	end
end)
formatNode1 = (function(node21)
	local temp49
	local r_3731 = node21["range"]
	if r_3731 then
		temp49 = node21["contents"]
	else
		temp49 = r_3731
	end
	if temp49 then
		return format1("%s (%q)", formatRange1(node21["range"]), node21["contents"])
	elseif node21["range"] then
		return formatRange1(node21["range"])
	elseif node21["owner"] then
		local owner1 = node21["owner"]
		if owner1["var"] then
			return format1("macro expansion of %s (%s)", owner1["var"]["name"], formatNode1(owner1["node"]))
		else
			return format1("unquote expansion (%s)", formatNode1(owner1["node"]))
		end
	else
		local temp50
		local r_3761 = node21["start"]
		if r_3761 then
			temp50 = node21["finish"]
		else
			temp50 = r_3761
		end
		if temp50 then
			return formatRange1(node21)
		else
			return "?"
		end
	end
end)
getSource1 = (function(node22)
	local result6 = nil
	local r_3741 = nil
	r_3741 = (function()
		local temp51
		local r_3751 = node22
		if r_3751 then
			temp51 = _21_1(result6)
		else
			temp51 = r_3751
		end
		if temp51 then
			result6 = node22["range"]
			node22 = node22["parent"]
			return r_3741()
		else
		end
	end)
	r_3741()
	return result6
end)
struct1("formatPosition", formatPosition1, "formatRange", formatRange1, "formatNode", formatNode1, "getSource", getSource1)
stripImport1 = struct1("name", "strip-import", "help", "Strip all import expressions in NODES", "cat", {tag = "list", n = 1, "opt"}, "run", (function(r_3722, state9, nodes4)
	local r_3771 = nil
	r_3771 = (function(r_3781)
		if (r_3781 >= 1) then
			local node23 = nth1(nodes4, r_3781)
			local temp52
			local r_3811 = list_3f_1(node23)
			if r_3811 then
				local r_3821 = (_23_1(node23) > 0)
				if r_3821 then
					local r_3831 = symbol_3f_1(car2(node23))
					if r_3831 then
						temp52 = (car2(node23)["var"] == builtins1["import"])
					else
						temp52 = r_3831
					end
				else
					temp52 = r_3821
				end
			else
				temp52 = r_3811
			end
			if temp52 then
				if (r_3781 == _23_1(nodes4)) then
					nodes4[r_3781] = struct1("tag", "symbol", "contents", "nil", "var", builtinVars1["nil"])
				else
					removeNth_21_1(nodes4, r_3781)
				end
				r_3722["changed"] = true
			else
			end
			return r_3771((r_3781 + -1))
		else
		end
	end)
	return r_3771(_23_1(nodes4))
end))
stripPure1 = struct1("name", "strip-pure", "help", "Strip all pure expressions in NODES (apart from the last one).", "cat", {tag = "list", n = 1, "opt"}, "run", (function(r_3723, state10, nodes5)
	local r_3841 = nil
	r_3841 = (function(r_3851)
		if (r_3851 >= 1) then
			local node24 = nth1(nodes5, r_3851)
			if sideEffect_3f_1(node24) then
			else
				removeNth_21_1(nodes5, r_3851)
				r_3723["changed"] = true
			end
			return r_3841((r_3851 + -1))
		else
		end
	end)
	return r_3841(pred1(_23_1(nodes5)))
end))
fastAll1 = (function(fn1, li2, i2)
	if (i2 > _23_1(li2)) then
		return true
	elseif fn1(nth1(li2, i2)) then
		return fastAll1(fn1, li2, (i2 + 1))
	else
		return false
	end
end)
constantFold1 = struct1("name", "constant-fold", "help", "A primitive constant folder\n\nThis simply finds function calls with constant functions and looks up the function.\nIf the function is native and pure then we'll execute it and replace the node with the\nresult. There are a couple of caveats:\n\n - If the function call errors then we will flag a warning and continue.\n - If this returns a decimal (or infinity or NaN) then we'll continue: we cannot correctly\n   accurately handle this.", "cat", {tag = "list", n = 1, "opt"}, "run", (function(r_3724, state11, nodes6)
	return traverseList1(nodes6, 1, (function(node25)
		local temp53
		local r_3881 = list_3f_1(node25)
		if r_3881 then
			temp53 = fastAll1(constant_3f_1, node25, 2)
		else
			temp53 = r_3881
		end
		if temp53 then
			local head1 = car2(node25)
			local meta1
			local r_3961 = symbol_3f_1(head1)
			if r_3961 then
				local r_3971 = _21_1(head1["folded"])
				if r_3971 then
					local r_3981 = (head1["var"]["tag"] == "native")
					if r_3981 then
						meta1 = state11["meta"][head1["var"]["fullName"]]
					else
						meta1 = r_3981
					end
				else
					meta1 = r_3971
				end
			else
				meta1 = r_3961
			end
			local temp54
			if meta1 then
				local r_3901 = meta1["pure"]
				if r_3901 then
					temp54 = meta1["value"]
				else
					temp54 = r_3901
				end
			else
				temp54 = meta1
			end
			if temp54 then
				local res2 = list1(pcall1(meta1["value"], unpack1(map1(urn_2d3e_val1, cdr2(node25)))))
				if car2(res2) then
					local val12 = nth1(res2, 2)
					local temp55
					local r_3911 = number_3f_1(val12)
					if r_3911 then
						local r_3921 = (cadr1(list1(modf1(val12))) ~= 0)
						if r_3921 then
							temp55 = r_3921
						else
							temp55 = (abs1(val12) == huge1)
						end
					else
						temp55 = r_3911
					end
					if temp55 then
						head1["folded"] = true
						return node25
					else
						r_3724["changed"] = true
						return val_2d3e_urn1(val12)
					end
				else
					head1["folded"] = true
					putNodeWarning_21_1(state11["logger"], _2e2e_2("Cannot execute constant expression"), node25, nil, getSource1(node25), _2e2e_2("Executed ", pretty1(node25), ", failed with: ", nth1(res2, 2)))
					return node25
				end
			else
				return node25
			end
		else
			return node25
		end
	end))
end))
condFold1 = struct1("name", "cond-fold", "help", "Simplify all `cond` nodes, removing `false` branches and killing\nall branches after a `true` one.", "cat", {tag = "list", n = 1, "opt"}, "run", (function(r_3725, state12, nodes7)
	return traverseList1(nodes7, 1, (function(node26)
		local temp56
		local r_3931 = list_3f_1(node26)
		if r_3931 then
			local r_3941 = symbol_3f_1(car2(node26))
			if r_3941 then
				temp56 = (car2(node26)["var"] == builtins1["cond"])
			else
				temp56 = r_3941
			end
		else
			temp56 = r_3931
		end
		if temp56 then
			local final1 = false
			local i3 = 2
			local r_3951 = nil
			r_3951 = (function()
				if (i3 <= _23_1(node26)) then
					local elem6 = nth1(node26, i3)
					if final1 then
						r_3725["changed"] = true
						removeNth_21_1(node26, i3)
					else
						local r_3991 = urn_2d3e_bool1(car2(elem6))
						if eq_3f_1(r_3991, false) then
							r_3725["changed"] = true
							removeNth_21_1(node26, i3)
						elseif eq_3f_1(r_3991, true) then
							final1 = true
							i3 = (i3 + 1)
						elseif eq_3f_1(r_3991, nil) then
							i3 = (i3 + 1)
						else
							error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_3991), ", but none matched.\n", "  Tried: `false`\n  Tried: `true`\n  Tried: `nil`"))
						end
					end
					return r_3951()
				else
				end
			end)
			r_3951()
			local temp57
			local r_4001 = (_23_1(node26) == 2)
			if r_4001 then
				temp57 = (urn_2d3e_bool1(car2(nth1(node26, 2))) == true)
			else
				temp57 = r_4001
			end
			if temp57 then
				r_3725["changed"] = true
				local body2 = cdr2(nth1(node26, 2))
				if (_23_1(body2) == 1) then
					return car2(body2)
				else
					return makeProgn1(cdr2(nth1(node26, 2)))
				end
			else
				return node26
			end
		else
			return node26
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
	elseif (_23_keys1(def2["defs"]) == 1) then
		local ent1 = nth1(list1(next1(def2["defs"])), 2)
		local val13 = ent1["value"]
		local ty4 = ent1["tag"]
		local temp58
		local r_4011 = string_3f_1(val13)
		if r_4011 then
			temp58 = r_4011
		else
			local r_4021 = number_3f_1(val13)
			if r_4021 then
				temp58 = r_4021
			else
				temp58 = key_3f_1(val13)
			end
		end
		if temp58 then
			return val13
		else
			local temp59
			local r_4031 = symbol_3f_1(val13)
			if r_4031 then
				local r_4041 = (ty4 == "define")
				if r_4041 then
					temp59 = r_4041
				else
					local r_4051 = (ty4 == "set")
					if r_4051 then
						temp59 = r_4051
					else
						temp59 = (ty4 == "let")
					end
				end
			else
				temp59 = r_4031
			end
			if temp59 then
				local r_4061 = getConstantVal1(lookup2, val13)
				if r_4061 then
					return r_4061
				else
					return sym1
				end
			else
				return sym1
			end
		end
	else
		return nil
	end
end)
stripDefs1 = struct1("name", "strip-defs", "help", "Strip all unused top level definitions.", "cat", {tag = "list", n = 2, "opt", "usage"}, "run", (function(r_3726, state13, nodes8, lookup3)
	local r_4071 = nil
	r_4071 = (function(r_4081)
		if (r_4081 >= 1) then
			local node27 = nth1(nodes8, r_4081)
			local temp60
			local r_4111 = node27["defVar"]
			if r_4111 then
				temp60 = _21_1(getVar1(lookup3, node27["defVar"])["active"])
			else
				temp60 = r_4111
			end
			if temp60 then
				if (r_4081 == _23_1(nodes8)) then
					nodes8[r_4081] = struct1("tag", "symbol", "contents", "nil", "var", builtinVars1["nil"])
				else
					removeNth_21_1(nodes8, r_4081)
				end
				r_3726["changed"] = true
			else
			end
			return r_4071((r_4081 + -1))
		else
		end
	end)
	return r_4071(_23_1(nodes8))
end))
stripArgs1 = struct1("name", "strip-args", "help", "Strip all unused, pure arguments in directly called lambdas.", "cat", {tag = "list", n = 2, "opt", "usage"}, "run", (function(r_3727, state14, nodes9, lookup4)
	return visitBlock1(nodes9, 1, (function(node28)
		local temp61
		local r_4121 = list_3f_1(node28)
		if r_4121 then
			local r_4131 = list_3f_1(car2(node28))
			if r_4131 then
				local r_4141 = symbol_3f_1(caar1(node28))
				if r_4141 then
					temp61 = (caar1(node28)["var"] == builtins1["lambda"])
				else
					temp61 = r_4141
				end
			else
				temp61 = r_4131
			end
		else
			temp61 = r_4121
		end
		if temp61 then
			local lam2 = car2(node28)
			local args6 = nth1(lam2, 2)
			local offset2 = 1
			local remOffset1 = 0
			local r_4171 = _23_1(args6)
			local r_4151 = nil
			r_4151 = (function(r_4161)
				if (r_4161 <= r_4171) then
					local arg22 = nth1(args6, (r_4161 - remOffset1))
					local val14 = nth1(node28, ((r_4161 + offset2) - remOffset1))
					if arg22["var"]["isVariadic"] then
						local count2 = (_23_1(node28) - _23_1(args6))
						if (count2 < 0) then
							count2 = 0
						else
						end
						offset2 = count2
					elseif (nil == val14) then
					elseif sideEffect_3f_1(val14) then
					elseif (_23_keys1(getVar1(lookup4, arg22["var"])["usages"]) > 0) then
					else
						r_3727["changed"] = true
						removeNth_21_1(args6, (r_4161 - remOffset1))
						removeNth_21_1(node28, ((r_4161 + offset2) - remOffset1))
						remOffset1 = (remOffset1 + 1)
					end
					return r_4151((r_4161 + 1))
				else
				end
			end)
			return r_4151(1)
		else
		end
	end))
end))
variableFold1 = struct1("name", "variable-fold", "help", "Folds variables", "cat", {tag = "list", n = 2, "opt", "usage"}, "run", (function(r_3728, state15, nodes10, lookup5)
	return traverseList1(nodes10, 1, (function(node29)
		if symbol_3f_1(node29) then
			local var7 = getConstantVal1(lookup5, node29)
			local temp62
			if var7 then
				temp62 = (var7 ~= node29)
			else
				temp62 = var7
			end
			if temp62 then
				r_3728["changed"] = true
				return var7
			else
				return node29
			end
		else
			return node29
		end
	end))
end))
optimiseOnce1 = (function(nodes11, state16)
	local tracker3 = createTracker1()
	runPass1(stripImport1, state16, tracker3, nodes11)
	runPass1(stripPure1, state16, tracker3, nodes11)
	runPass1(constantFold1, state16, tracker3, nodes11)
	runPass1(condFold1, state16, tracker3, nodes11)
	local lookup6 = createState1()
	runPass1(tagUsage1, state16, tracker3, nodes11, lookup6)
	runPass1(stripDefs1, state16, tracker3, nodes11, lookup6)
	runPass1(stripArgs1, state16, tracker3, nodes11, lookup6)
	runPass1(variableFold1, state16, tracker3, nodes11, lookup6)
	return changed_3f_1(tracker3)
end)
optimise1 = (function(nodes12, state17)
	local maxN1 = state17["max-n"]
	local maxT1 = state17["max-time"]
	local iteration1 = 0
	local finish1 = (clock1() + maxT1)
	local changed1 = true
	local r_2581 = nil
	r_2581 = (function()
		local temp63
		local r_2591 = changed1
		if r_2591 then
			local r_2601
			local r_4201 = (maxN1 < 0)
			if r_4201 then
				r_2601 = r_4201
			else
				r_2601 = (iteration1 < maxN1)
			end
			if r_2601 then
				local r_2611 = (maxT1 < 0)
				if r_2611 then
					temp63 = r_2611
				else
					temp63 = (clock1() < finish1)
				end
			else
				temp63 = r_2601
			end
		else
			temp63 = r_2591
		end
		if temp63 then
			changed1 = optimiseOnce1(nodes12, state17)
			iteration1 = (iteration1 + 1)
			return r_2581()
		else
		end
	end)
	r_2581()
	return nodes12
end)
checkArity1 = struct1("name", "check-arity", "help", "Produce a warning if any NODE in NODES calls a function with too many arguments.\n\nLOOKUP is the variable usage lookup table.", "cat", {tag = "list", n = 2, "warn", "usage"}, "run", (function(r_3729, state18, nodes13, lookup7)
	local arity1
	local getArity1
	arity1 = ({})
	getArity1 = (function(symbol1)
		local var8 = getVar1(lookup7, symbol1["var"])
		local ari1 = arity1[var8]
		if (ari1 ~= nil) then
			return ari1
		elseif (_23_keys1(var8["defs"]) ~= 1) then
			return false
		else
			arity1[var8] = false
			local defData1 = cadr1(list1(next1(var8["defs"])))
			local def3 = defData1["value"]
			if (defData1["tag"] == "arg") then
				ari1 = false
			else
				if symbol_3f_1(def3) then
					ari1 = getArity1(def3)
				else
					local temp64
					local r_4211 = list_3f_1(def3)
					if r_4211 then
						local r_4221 = symbol_3f_1(car2(def3))
						if r_4221 then
							temp64 = (car2(def3)["var"] == builtins1["lambda"])
						else
							temp64 = r_4221
						end
					else
						temp64 = r_4211
					end
					if temp64 then
						local args7 = nth1(def3, 2)
						if any1((function(x24)
							return x24["var"]["isVariadic"]
						end), args7) then
							ari1 = false
						else
							ari1 = _23_1(args7)
						end
					else
						ari1 = false
					end
				end
			end
			arity1[var8] = ari1
			return ari1
		end
	end)
	return visitBlock1(nodes13, 1, (function(node30)
		local temp65
		local r_4231 = list_3f_1(node30)
		if r_4231 then
			temp65 = symbol_3f_1(car2(node30))
		else
			temp65 = r_4231
		end
		if temp65 then
			local arity2 = getArity1(car2(node30))
			local temp66
			if arity2 then
				temp66 = (arity2 < pred1(_23_1(node30)))
			else
				temp66 = arity2
			end
			if temp66 then
				return putNodeWarning_21_1(state18["logger"], _2e2e_2("Calling ", symbol_2d3e_string1(car2(node30)), " with ", tonumber1(pred1(_23_1(node30))), " arguments, expected ", tonumber1(arity2)), node30, nil, getSource1(node30), "Called here")
			else
			end
		else
		end
	end))
end))
analyse1 = (function(nodes14, state19)
	local lookup8 = createState1()
	runPass1(tagUsage1, state19, nil, nodes14, lookup8)
	runPass1(checkArity1, state19, nil, nodes14, lookup8)
	return nodes14
end)
create2 = (function()
	return struct1("out", {tag = "list", n = 0}, "indent", 0, "tabs-pending", false, "line", 1, "lines", ({}), "node-stack", {tag = "list", n = 0}, "active-pos", nil)
end)
append_21_1 = (function(writer1, text2)
	local r_4361 = type1(text2)
	if (r_4361 ~= "string") then
		error1(format1("bad argment %s (expected %s, got %s)", "text", "string", r_4361), 2)
	else
	end
	local pos4 = writer1["active-pos"]
	if pos4 then
		local line1 = writer1["lines"][writer1["line"]]
		if line1 then
		else
			line1 = ({})
			writer1["lines"][writer1["line"]] = line1
		end
		line1[pos4] = true
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
	local temp67
	if force1 then
		temp67 = force1
	else
		temp67 = _21_1(writer2["tabs-pending"])
	end
	if temp67 then
		writer2["tabs-pending"] = true
		writer2["line"] = succ1(writer2["line"])
		return pushCdr_21_1(writer2["out"], "\n")
	else
	end
end)
indent_21_1 = (function(writer3)
	writer3["indent"] = succ1(writer3["indent"])
	return nil
end)
unindent_21_1 = (function(writer4)
	writer4["indent"] = pred1(writer4["indent"])
	return nil
end)
beginBlock_21_1 = (function(writer5, text4)
	line_21_1(writer5, text4)
	return indent_21_1(writer5)
end)
nextBlock_21_1 = (function(writer6, text5)
	unindent_21_1(writer6)
	line_21_1(writer6, text5)
	return indent_21_1(writer6)
end)
endBlock_21_1 = (function(writer7, text6)
	unindent_21_1(writer7)
	return line_21_1(writer7, text6)
end)
pushNode_21_1 = (function(writer8, node31)
	local range2 = getSource1(node31)
	if range2 then
		pushCdr_21_1(writer8["node-stack"], node31)
		writer8["active-pos"] = range2
		return nil
	else
	end
end)
popNode_21_1 = (function(writer9, node32)
	local range3 = getSource1(node32)
	if range3 then
		local stack1 = writer9["node-stack"]
		local previous1 = last1(stack1)
		if (previous1 == node32) then
		else
			error1("Incorrect node popped")
		end
		popLast_21_1(stack1)
		writer9["arg-pos"] = last1(stack1)
		return nil
	else
	end
end)
_2d3e_string1 = (function(writer10)
	return concat1(writer10["out"])
end)
estimateLength1 = (function(node33, max4)
	local tag9 = node33["tag"]
	local temp68
	local r_4251 = (tag9 == "string")
	if r_4251 then
		temp68 = r_4251
	else
		local r_4261 = (tag9 == "number")
		if r_4261 then
			temp68 = r_4261
		else
			local r_4271 = (tag9 == "symbol")
			if r_4271 then
				temp68 = r_4271
			else
				temp68 = (tag9 == "key")
			end
		end
	end
	if temp68 then
		return len1(tostring1(node33["contents"]))
	elseif (tag9 == "list") then
		local sum1 = 2
		local i4 = 1
		local r_4281 = nil
		r_4281 = (function()
			local temp69
			local r_4291 = (sum1 <= max4)
			if r_4291 then
				temp69 = (i4 <= _23_1(node33))
			else
				temp69 = r_4291
			end
			if temp69 then
				sum1 = (sum1 + estimateLength1(nth1(node33, i4), (max4 - sum1)))
				if (i4 > 1) then
					sum1 = (sum1 + 1)
				else
				end
				i4 = (i4 + 1)
				return r_4281()
			else
			end
		end)
		r_4281()
		return sum1
	else
		return fail_21_1(_2e2e_2("Unknown tag ", tag9))
	end
end)
expression1 = (function(node34, writer11)
	local tag10 = node34["tag"]
	if (tag10 == "string") then
		return append_21_1(writer11, quoted1(node34["value"]))
	elseif (tag10 == "number") then
		return append_21_1(writer11, tostring1(node34["value"]))
	elseif (tag10 == "key") then
		return append_21_1(writer11, _2e2e_2(":", node34["value"]))
	elseif (tag10 == "symbol") then
		return append_21_1(writer11, node34["contents"])
	elseif (tag10 == "list") then
		append_21_1(writer11, "(")
		if nil_3f_1(node34) then
			return append_21_1(writer11, ")")
		else
			local newline1 = false
			local max5 = (60 - estimateLength1(car2(node34), 60))
			expression1(car2(node34), writer11)
			if (max5 <= 0) then
				newline1 = true
				indent_21_1(writer11)
			else
			end
			local r_4401 = _23_1(node34)
			local r_4381 = nil
			r_4381 = (function(r_4391)
				if (r_4391 <= r_4401) then
					local entry3 = nth1(node34, r_4391)
					local temp70
					local r_4421 = _21_1(newline1)
					if r_4421 then
						temp70 = (max5 > 0)
					else
						temp70 = r_4421
					end
					if temp70 then
						max5 = (max5 - estimateLength1(entry3, max5))
						if (max5 <= 0) then
							newline1 = true
							indent_21_1(writer11)
						else
						end
					else
					end
					if newline1 then
						line_21_1(writer11)
					else
						append_21_1(writer11, " ")
					end
					expression1(entry3, writer11)
					return r_4381((r_4391 + 1))
				else
				end
			end)
			r_4381(2)
			if newline1 then
				unindent_21_1(writer11)
			else
			end
			return append_21_1(writer11, ")")
		end
	else
		return fail_21_1(_2e2e_2("Unknown tag ", tag10))
	end
end)
block1 = (function(list2, writer12)
	local r_4341 = _23_1(list2)
	local r_4321 = nil
	r_4321 = (function(r_4331)
		if (r_4331 <= r_4341) then
			local node35 = list2[r_4331]
			expression1(node35, writer12)
			line_21_1(writer12)
			return r_4321((r_4331 + 1))
		else
		end
	end)
	return r_4321(1)
end)
traceback1 = debug.traceback
unmangleIdent1 = (function(ident1)
	local esc1 = match1(ident1, "^(.-)%d+$")
	if (esc1 == nil) then
		return ident1
	elseif (sub1(esc1, 1, 2) == "_e") then
		return sub1(ident1, 3)
	else
		local buffer2 = {tag = "list", n = 0}
		local pos5 = 0
		local len6 = len1(esc1)
		local r_4701 = nil
		r_4701 = (function()
			if (pos5 <= len6) then
				local char2 = charAt1(esc1, pos5)
				if (char2 == "_") then
					local r_4711 = list1(find1(esc1, "^_[%da-z]+_", pos5))
					local temp71
					local r_4731 = list_3f_1(r_4711)
					if r_4731 then
						local r_4741 = (_23_1(r_4711) == 2)
						if r_4741 then
							temp71 = true
						else
							temp71 = r_4741
						end
					else
						temp71 = r_4731
					end
					if temp71 then
						local start6 = nth1(r_4711, 1)
						local _eend1 = nth1(r_4711, 2)
						pos5 = (pos5 + 1)
						local r_4761 = nil
						r_4761 = (function()
							if (pos5 < _eend1) then
								pushCdr_21_1(buffer2, char1(tonumber1(sub1(esc1, pos5, succ1(pos5)), 16)))
								pos5 = (pos5 + 2)
								return r_4761()
							else
							end
						end)
						r_4761()
					else
						pushCdr_21_1(buffer2, "_")
					end
				elseif between_3f_1(char2, "A", "Z") then
					pushCdr_21_1(buffer2, "-")
					pushCdr_21_1(buffer2, lower1(char2))
				else
					pushCdr_21_1(buffer2, char2)
				end
				pos5 = (pos5 + 1)
				return r_4701()
			else
			end
		end)
		r_4701()
		return concat1(buffer2)
	end
end)
remapError1 = (function(msg9)
	local res3
	local r_4801
	local r_4791
	local r_4781
	r_4781 = gsub1(msg9, "local '([^']+)'", (function(x25)
		return _2e2e_2("local '", unmangleIdent1(x25), "'")
	end))
	r_4791 = gsub1(r_4781, "global '([^']+)'", (function(x26)
		return _2e2e_2("global '", unmangleIdent1(x26), "'")
	end))
	r_4801 = gsub1(r_4791, "upvalue '([^']+)'", (function(x27)
		return _2e2e_2("upvalue '", unmangleIdent1(x27), "'")
	end))
	res3 = gsub1(r_4801, "function '([^']+)'", (function(x28)
		return _2e2e_2("function '", unmangleIdent1(x28), "'")
	end))
	return res3
end)
remapMessage1 = (function(mappings1, msg10)
	local r_4641 = list1(match1(msg10, "^(.-):(%d+)(.*)$"))
	local temp72
	local r_4661 = list_3f_1(r_4641)
	if r_4661 then
		local r_4671 = (_23_1(r_4641) == 3)
		if r_4671 then
			temp72 = true
		else
			temp72 = r_4671
		end
	else
		temp72 = r_4661
	end
	if temp72 then
		local file1 = nth1(r_4641, 1)
		local line2 = nth1(r_4641, 2)
		local extra1 = nth1(r_4641, 3)
		local mapping1 = mappings1[file1]
		if mapping1 then
			local range4 = mapping1[tonumber1(line2)]
			if range4 then
				return _2e2e_2(range4, " (", file1, ":", line2, ")", remapError1(extra1))
			else
				return msg10
			end
		else
			return msg10
		end
	else
		return msg10
	end
end)
remapTraceback1 = (function(mappings2, msg11)
	local r_4871
	local r_4861
	local r_4851
	local r_4841
	local r_4831
	local r_4821
	r_4821 = gsub1(msg11, "^([^\n:]-:%d+:[^\n]*)", (function(r_4881)
		return remapMessage1(mappings2, r_4881)
	end))
	r_4831 = gsub1(r_4821, "\9([^\n:]-:%d+:)", (function(msg12)
		return _2e2e_2("\9", remapMessage1(mappings2, msg12))
	end))
	r_4841 = gsub1(r_4831, "<([^\n:]-:%d+)>\n", (function(msg13)
		return _2e2e_2("<", remapMessage1(mappings2, msg13), ">\n")
	end))
	r_4851 = gsub1(r_4841, "in local '([^']+)'\n", (function(x29)
		return _2e2e_2("in local '", unmangleIdent1(x29), "'\n")
	end))
	r_4861 = gsub1(r_4851, "in global '([^']+)'\n", (function(x30)
		return _2e2e_2("in global '", unmangleIdent1(x30), "'\n")
	end))
	r_4871 = gsub1(r_4861, "in upvalue '([^']+)'\n", (function(x31)
		return _2e2e_2("in upvalue '", unmangleIdent1(x31), "'\n")
	end))
	return gsub1(r_4871, "in function '([^']+)'\n", (function(x32)
		return _2e2e_2("in function '", unmangleIdent1(x32), "'\n")
	end))
end)
generateMappings1 = (function(lines4)
	local outLines1 = ({})
	iterPairs1(lines4, (function(line3, ranges1)
		local rangeLists1 = ({})
		iterPairs1(ranges1, (function(pos6)
			local file2 = pos6["name"]
			local rangeList1 = rangeLists1["file"]
			if rangeList1 then
			else
				rangeList1 = struct1("n", 0, "min", huge1, "max", (0 - huge1))
				rangeLists1[file2] = rangeList1
			end
			local r_4911 = pos6["finish"]["line"]
			local r_4891 = nil
			r_4891 = (function(r_4901)
				if (r_4901 <= r_4911) then
					if rangeList1[r_4901] then
					else
						rangeList1["n"] = succ1(rangeList1["n"])
						rangeList1[r_4901] = true
						if (r_4901 < rangeList1["min"]) then
							rangeList1["min"] = r_4901
						else
						end
						if (r_4901 > rangeList1["max"]) then
							rangeList1["max"] = r_4901
						else
						end
					end
					return r_4891((r_4901 + 1))
				else
				end
			end)
			return r_4891(pos6["start"]["line"])
		end))
		local bestName1 = nil
		local bestLines1 = nil
		local bestCount1 = 0
		iterPairs1(rangeLists1, (function(name6, lines5)
			if (lines5["n"] > bestCount1) then
				bestName1 = name6
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
createLookup1 = (function(...)
	local lst2 = _pack(...) lst2.tag = "list"
	local out4 = ({})
	local r_4471 = _23_1(lst2)
	local r_4451 = nil
	r_4451 = (function(r_4461)
		if (r_4461 <= r_4471) then
			local entry4 = lst2[r_4461]
			out4[entry4] = true
			return r_4451((r_4461 + 1))
		else
		end
	end)
	r_4451(1)
	return out4
end)
keywords1 = createLookup1("and", "break", "do", "else", "elseif", "end", "false", "for", "function", "if", "in", "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while")
createState2 = (function(meta2)
	return struct1("count", 0, "mappings", ({}), "ctr-lookup", ({}), "var-lookup", ({}), "meta", (function()
		if meta2 then
			return meta2
		else
			return ({})
		end
	end)())
end)
builtins4 = require1("tacky.analysis.resolve")["builtins"]
builtinVars2 = require1("tacky.analysis.resolve")["declaredVars"]
escape1 = (function(name7)
	if keywords1[name7] then
		return _2e2e_2("_e", name7)
	elseif find1(name7, "^%w[_%w%d]*$") then
		return name7
	else
		local out5
		local temp73
		local r_5261
		r_5261 = charAt1(name7, 1)
		temp73 = find1(r_5261, "%d")
		if temp73 then
			out5 = "_e"
		else
			out5 = ""
		end
		local upper2 = false
		local esc2 = false
		local r_5151 = len1(name7)
		local r_5131 = nil
		r_5131 = (function(r_5141)
			if (r_5141 <= r_5151) then
				local char3 = charAt1(name7, r_5141)
				local temp74
				local r_5171 = (char3 == "-")
				if r_5171 then
					local r_5181
					local r_5221
					r_5221 = charAt1(name7, pred1(r_5141))
					r_5181 = find1(r_5221, "[%a%d']")
					if r_5181 then
						local r_5201
						r_5201 = charAt1(name7, succ1(r_5141))
						temp74 = find1(r_5201, "[%a%d']")
					else
						temp74 = r_5181
					end
				else
					temp74 = r_5171
				end
				if temp74 then
					upper2 = true
				elseif find1(char3, "[^%w%d]") then
					local r_5241
					local r_5231 = char3
					r_5241 = byte1(r_5231)
					char3 = format1("%02x", r_5241)
					if esc2 then
					else
						esc2 = true
						out5 = _2e2e_2(out5, "_")
					end
					out5 = _2e2e_2(out5, char3)
				else
					if esc2 then
						esc2 = false
						out5 = _2e2e_2(out5, "_")
					else
					end
					if upper2 then
						upper2 = false
						char3 = upper1(char3)
					else
					end
					out5 = _2e2e_2(out5, char3)
				end
				return r_5131((r_5141 + 1))
			else
			end
		end)
		r_5131(1)
		if esc2 then
			out5 = _2e2e_2(out5, "_")
		else
		end
		return out5
	end
end)
escapeVar1 = (function(var9, state20)
	if builtinVars2[var9] then
		return var9["name"]
	else
		local v1 = escape1(var9["name"])
		local id2 = state20["var-lookup"][var9]
		if id2 then
		else
			id2 = succ1((function(r_4501)
				if r_4501 then
					return r_4501
				else
					return 0
				end
			end)(state20["ctr-lookup"][v1]))
			state20["ctr-lookup"][v1] = id2
			state20["var-lookup"][var9] = id2
		end
		return _2e2e_2(v1, tostring1(id2))
	end
end)
statement_3f_1 = (function(node36)
	if list_3f_1(node36) then
		local first6 = car2(node36)
		if symbol_3f_1(first6) then
			return (first6["var"] == builtins4["cond"])
		elseif list_3f_1(first6) then
			local func5 = car2(first6)
			local r_4511 = symbol_3f_1(func5)
			if r_4511 then
				return (func5["var"] == builtins4["lambda"])
			else
				return r_4511
			end
		else
			return false
		end
	else
		return false
	end
end)
literal_3f_1 = (function(node37)
	if list_3f_1(node37) then
		local first7 = car2(node37)
		local r_4521 = symbol_3f_1(first7)
		if r_4521 then
			local r_4531 = (first7["var"] == builtins4["quote"])
			if r_4531 then
				return r_4531
			else
				return (first7["var"] == builtins4["syntax-quote"])
			end
		else
			return r_4521
		end
	elseif symbol_3f_1(node37) then
		return builtinVars2[node37["var"]]
	else
		return true
	end
end)
truthy_3f_1 = (function(node38)
	local r_4541 = symbol_3f_1(node38)
	if r_4541 then
		return (builtinVars2["true"] == node38["var"])
	else
		return r_4541
	end
end)
compileQuote1 = (function(node39, out6, state21, level3)
	if (level3 == 0) then
		return compileExpression1(node39, out6, state21)
	else
		local ty5 = type1(node39)
		if (ty5 == "string") then
			return append_21_1(out6, quoted1(node39["value"]))
		elseif (ty5 == "number") then
			return append_21_1(out6, tostring1(node39["value"]))
		elseif (ty5 == "symbol") then
			append_21_1(out6, _2e2e_2("{ tag=\"symbol\", contents=", quoted1(node39["contents"])))
			if node39["var"] then
				append_21_1(out6, _2e2e_2(", var=", quoted1(tostring1(node39["var"]))))
			else
			end
			return append_21_1(out6, "}")
		elseif (ty5 == "key") then
			return append_21_1(out6, _2e2e_2("{tag=\"key\", value=", quoted1(node39["value"]), "}"))
		elseif (ty5 == "list") then
			local first8 = car2(node39)
			local temp75
			local r_5271 = symbol_3f_1(first8)
			if r_5271 then
				local r_5281 = (first8["var"] == builtins4["unquote"])
				if r_5281 then
					temp75 = r_5281
				else
					temp75 = ("var" == builtins4["unquote-splice"])
				end
			else
				temp75 = r_5271
			end
			if temp75 then
				return compileQuote1(nth1(node39, 2), out6, state21, (function()
					if level3 then
						return pred1(level3)
					else
						return level3
					end
				end)())
			else
				local temp76
				local r_5301 = symbol_3f_1(first8)
				if r_5301 then
					temp76 = (first8["var"] == builtins4["syntax-quote"])
				else
					temp76 = r_5301
				end
				if temp76 then
					return compileQuote1(nth1(node39, 2), out6, state21, (function()
						if level3 then
							return succ1(level3)
						else
							return level3
						end
					end)())
				else
					pushNode_21_1(out6, node39)
					local containsUnsplice1 = false
					local r_5361 = _23_1(node39)
					local r_5341 = nil
					r_5341 = (function(r_5351)
						if (r_5351 <= r_5361) then
							local sub4 = node39[r_5351]
							local temp77
							local r_5381 = list_3f_1(sub4)
							if r_5381 then
								local r_5391 = symbol_3f_1(car2(sub4))
								if r_5391 then
									temp77 = (sub4[1]["var"] == builtins4["unquote-splice"])
								else
									temp77 = r_5391
								end
							else
								temp77 = r_5381
							end
							if temp77 then
								containsUnsplice1 = true
							else
							end
							return r_5341((r_5351 + 1))
						else
						end
					end)
					r_5341(1)
					if containsUnsplice1 then
						local offset3 = 0
						beginBlock_21_1(out6, "(function()")
						line_21_1(out6, "local _offset, _result, _temp = 0, {tag=\"list\",n=0}")
						local r_5421 = _23_1(node39)
						local r_5401 = nil
						r_5401 = (function(r_5411)
							if (r_5411 <= r_5421) then
								local sub5 = nth1(node39, r_5411)
								local temp78
								local r_5441 = list_3f_1(sub5)
								if r_5441 then
									local r_5451 = symbol_3f_1(car2(sub5))
									if r_5451 then
										temp78 = (sub5[1]["var"] == builtins4["unquote-splice"])
									else
										temp78 = r_5451
									end
								else
									temp78 = r_5441
								end
								if temp78 then
									offset3 = (offset3 + 1)
									append_21_1(out6, "_temp = ")
									compileQuote1(nth1(sub5, 2), out6, state21, pred1(level3))
									line_21_1(out6)
									line_21_1(out6, _2e2e_2("for _c = 1, _temp.n do _result[", tostring1((r_5411 - offset3)), " + _c + _offset] = _temp[_c] end"))
									line_21_1(out6, "_offset = _offset + _temp.n")
								else
									append_21_1(out6, _2e2e_2("_result[", tostring1((r_5411 - offset3)), " + _offset] = "))
									compileQuote1(sub5, out6, state21, level3)
									line_21_1(out6)
								end
								return r_5401((r_5411 + 1))
							else
							end
						end)
						r_5401(1)
						line_21_1(out6, _2e2e_2("_result.n = _offset + ", tostring1((_23_1(node39) - offset3))))
						line_21_1(out6, "return _result")
						endBlock_21_1(out6, "end)()")
					else
						append_21_1(out6, _2e2e_2("{tag = \"list\", n = ", tostring1(_23_1(node39))))
						local r_5501 = _23_1(node39)
						local r_5481 = nil
						r_5481 = (function(r_5491)
							if (r_5491 <= r_5501) then
								local sub6 = node39[r_5491]
								append_21_1(out6, ", ")
								compileQuote1(sub6, out6, state21, level3)
								return r_5481((r_5491 + 1))
							else
							end
						end)
						r_5481(1)
						append_21_1(out6, "}")
					end
					return popNode_21_1(out6, node39)
				end
			end
		else
			return error1(_2e2e_2("Unknown type ", ty5))
		end
	end
end)
compileExpression1 = (function(node40, out7, state22, ret1)
	if list_3f_1(node40) then
		pushNode_21_1(out7, node40)
		local head2 = car2(node40)
		if symbol_3f_1(head2) then
			local var10 = head2["var"]
			if (var10 == builtins4["lambda"]) then
				if (ret1 == "") then
				else
					if ret1 then
						append_21_1(out7, ret1)
					else
					end
					local args8 = nth1(node40, 2)
					local variadic1 = nil
					local i5 = 1
					append_21_1(out7, "(function(")
					local r_5521 = nil
					r_5521 = (function()
						local temp79
						local r_5531 = (i5 <= _23_1(args8))
						if r_5531 then
							temp79 = _21_1(variadic1)
						else
							temp79 = r_5531
						end
						if temp79 then
							if (i5 > 1) then
								append_21_1(out7, ", ")
							else
							end
							local var11 = args8[i5]["var"]
							if var11["isVariadic"] then
								append_21_1(out7, "...")
								variadic1 = i5
							else
								append_21_1(out7, escapeVar1(var11, state22))
							end
							i5 = (i5 + 1)
							return r_5521()
						else
						end
					end)
					r_5521()
					beginBlock_21_1(out7, ")")
					if variadic1 then
						local argsVar1 = escapeVar1(args8[variadic1]["var"], state22)
						if (variadic1 == _23_1(args8)) then
							line_21_1(out7, _2e2e_2("local ", argsVar1, " = _pack(...) ", argsVar1, ".tag = \"list\""))
						else
							local remaining1 = (_23_1(args8) - variadic1)
							line_21_1(out7, _2e2e_2("local _n = _select(\"#\", ...) - ", tostring1(remaining1)))
							append_21_1(out7, _2e2e_2("local ", argsVar1))
							local r_5561 = _23_1(args8)
							local r_5541 = nil
							r_5541 = (function(r_5551)
								if (r_5551 <= r_5561) then
									append_21_1(out7, ", ")
									append_21_1(out7, escapeVar1(args8[r_5551]["var"], state22))
									return r_5541((r_5551 + 1))
								else
								end
							end)
							r_5541(succ1(variadic1))
							line_21_1(out7)
							beginBlock_21_1(out7, "if _n > 0 then")
							append_21_1(out7, argsVar1)
							line_21_1(out7, " = { tag=\"list\", n=_n, _unpack(_pack(...), 1, _n)}")
							local r_5601 = _23_1(args8)
							local r_5581 = nil
							r_5581 = (function(r_5591)
								if (r_5591 <= r_5601) then
									append_21_1(out7, escapeVar1(args8[r_5591]["var"], state22))
									if (r_5591 < _23_1(args8)) then
										append_21_1(out7, ", ")
									else
									end
									return r_5581((r_5591 + 1))
								else
								end
							end)
							r_5581(succ1(variadic1))
							line_21_1(out7, " = select(_n + 1, ...)")
							nextBlock_21_1(out7, "else")
							append_21_1(out7, argsVar1)
							line_21_1(out7, " = { tag=\"list\", n=0}")
							local r_5641 = _23_1(args8)
							local r_5621 = nil
							r_5621 = (function(r_5631)
								if (r_5631 <= r_5641) then
									append_21_1(out7, escapeVar1(args8[r_5631]["var"], state22))
									if (r_5631 < _23_1(args8)) then
										append_21_1(out7, ", ")
									else
									end
									return r_5621((r_5631 + 1))
								else
								end
							end)
							r_5621(succ1(variadic1))
							line_21_1(out7, " = ...")
							endBlock_21_1(out7, "end")
						end
					else
					end
					compileBlock1(node40, out7, state22, 3, "return ")
					unindent_21_1(out7)
					append_21_1(out7, "end)")
				end
			elseif (var10 == builtins4["cond"]) then
				local closure1 = _21_1(ret1)
				local hadFinal1 = false
				local ends1 = 1
				if closure1 then
					beginBlock_21_1(out7, "(function()")
					ret1 = "return "
				else
				end
				local i6 = 2
				local r_5661 = nil
				r_5661 = (function()
					local temp80
					local r_5671 = _21_1(hadFinal1)
					if r_5671 then
						temp80 = (i6 <= _23_1(node40))
					else
						temp80 = r_5671
					end
					if temp80 then
						local item1 = nth1(node40, i6)
						local case3 = nth1(item1, 1)
						local isFinal1 = truthy_3f_1(case3)
						if isFinal1 then
							if (i6 == 2) then
								append_21_1(out7, "do")
							else
							end
						elseif statement_3f_1(case3) then
							if (i6 > 2) then
								indent_21_1(out7)
								line_21_1(out7)
								ends1 = (ends1 + 1)
							else
							end
							local tmp1 = escapeVar1(struct1("name", "temp"), state22)
							line_21_1(out7, _2e2e_2("local ", tmp1))
							compileExpression1(case3, out7, state22, _2e2e_2(tmp1, " = "))
							line_21_1(out7)
							line_21_1(out7, _2e2e_2("if ", tmp1, " then"))
						else
							append_21_1(out7, "if ")
							compileExpression1(case3, out7, state22)
							append_21_1(out7, " then")
						end
						indent_21_1(out7)
						line_21_1(out7)
						compileBlock1(item1, out7, state22, 2, ret1)
						unindent_21_1(out7)
						if isFinal1 then
							hadFinal1 = true
						else
							append_21_1(out7, "else")
						end
						i6 = (i6 + 1)
						return r_5661()
					else
					end
				end)
				r_5661()
				if hadFinal1 then
				else
					indent_21_1(out7)
					line_21_1(out7)
					append_21_1(out7, "_error(\"unmatched item\")")
					unindent_21_1(out7)
					line_21_1(out7)
				end
				local r_5701 = ends1
				local r_5681 = nil
				r_5681 = (function(r_5691)
					if (r_5691 <= r_5701) then
						append_21_1(out7, "end")
						if (r_5691 < ends1) then
							unindent_21_1(out7)
							line_21_1(out7)
						else
						end
						return r_5681((r_5691 + 1))
					else
					end
				end)
				r_5681(1)
				if closure1 then
					line_21_1(out7)
					endBlock_21_1(out7, "end)()")
				else
				end
			elseif (var10 == builtins4["set!"]) then
				compileExpression1(nth1(node40, 3), out7, state22, _2e2e_2(escapeVar1(node40[2]["var"], state22), " = "))
				local temp81
				local r_5721 = ret1
				if r_5721 then
					temp81 = (ret1 ~= "")
				else
					temp81 = r_5721
				end
				if temp81 then
					line_21_1(out7)
					append_21_1(out7, ret1)
					append_21_1(out7, "nil")
				else
				end
			elseif (var10 == builtins4["define"]) then
				compileExpression1(nth1(node40, _23_1(node40)), out7, state22, _2e2e_2(escapeVar1(node40["defVar"], state22), " = "))
			elseif (var10 == builtins4["define-macro"]) then
				compileExpression1(nth1(node40, _23_1(node40)), out7, state22, _2e2e_2(escapeVar1(node40["defVar"], state22), " = "))
			elseif (var10 == builtins4["define-native"]) then
				local meta3 = state22["meta"][node40["defVar"]["fullName"]]
				local ty6 = type1(meta3)
				if (ty6 == "nil") then
					append_21_1(out7, format1("%s = _libs[%q]", escapeVar1(node40["defVar"], state22), node40["defVar"]["fullName"]))
				elseif (ty6 == "var") then
					append_21_1(out7, format1("%s = %s", escapeVar1(node40["defVar"], state22), meta3["contents"]))
				else
					local temp82
					local r_5731 = (ty6 == "expr")
					if r_5731 then
						temp82 = r_5731
					else
						temp82 = (ty6 == "stmt")
					end
					if temp82 then
						local count3 = meta3["count"]
						append_21_1(out7, format1("%s = function(", escapeVar1(node40["defVar"], state22)))
						local r_5741 = nil
						r_5741 = (function(r_5751)
							if (r_5751 <= count3) then
								if (r_5751 == 1) then
								else
									append_21_1(out7, ", ")
								end
								append_21_1(out7, _2e2e_2("v", tonumber1(r_5751)))
								return r_5741((r_5751 + 1))
							else
							end
						end)
						r_5741(1)
						append_21_1(out7, ") ")
						if (ty6 == "expr") then
							append_21_1(out7, "return ")
						else
						end
						local r_5791 = meta3["contents"]
						local r_5821 = _23_1(r_5791)
						local r_5801 = nil
						r_5801 = (function(r_5811)
							if (r_5811 <= r_5821) then
								local entry5 = r_5791[r_5811]
								if number_3f_1(entry5) then
									append_21_1(out7, _2e2e_2("v", tonumber1(entry5)))
								else
									append_21_1(out7, entry5)
								end
								return r_5801((r_5811 + 1))
							else
							end
						end)
						r_5801(1)
						append_21_1(out7, " end")
					else
						_error("unmatched item")
					end
				end
			elseif (var10 == builtins4["quote"]) then
				if (ret1 == "") then
				else
					if ret1 then
						append_21_1(out7, ret1)
					else
					end
					compileQuote1(nth1(node40, 2), out7, state22)
				end
			elseif (var10 == builtins4["syntax-quote"]) then
				if (ret1 == "") then
					append_21_1(out7, "local _ =")
				elseif ret1 then
					append_21_1(out7, ret1)
				else
				end
				compileQuote1(nth1(node40, 2), out7, state22, 1)
			elseif (var10 == builtins4["unquote"]) then
				fail_21_1("unquote outside of syntax-quote")
			elseif (var10 == builtins4["unquote-splice"]) then
				fail_21_1("unquote-splice outside of syntax-quote")
			elseif (var10 == builtins4["import"]) then
				if (ret1 == nil) then
					append_21_1(out7, "nil")
				elseif (ret1 ~= "") then
					append_21_1(out7, ret1)
					append_21_1(out7, "nil")
				else
				end
			else
				local meta4
				local r_5951 = symbol_3f_1(head2)
				if r_5951 then
					local r_5961 = (head2["var"]["tag"] == "native")
					if r_5961 then
						meta4 = state22["meta"][head2["var"]["fullName"]]
					else
						meta4 = r_5961
					end
				else
					meta4 = r_5951
				end
				local metaTy1 = type1(meta4)
				if (metaTy1 == "nil") then
				elseif (metaTy1 == "boolean") then
				elseif (metaTy1 == "expr") then
				elseif (metaTy1 == "stmt") then
					if ret1 then
					else
						meta4 = nil
					end
				elseif (metaTy1 == "var") then
					meta4 = nil
				else
					_error("unmatched item")
				end
				local temp83
				local r_5841 = meta4
				if r_5841 then
					temp83 = (pred1(_23_1(node40)) == meta4["count"])
				else
					temp83 = r_5841
				end
				if temp83 then
					local temp84
					local r_5851 = ret1
					if r_5851 then
						temp84 = (meta4["tag"] == "expr")
					else
						temp84 = r_5851
					end
					if temp84 then
						append_21_1(out7, ret1)
					else
					end
					local contents2 = meta4["contents"]
					local r_5881 = _23_1(contents2)
					local r_5861 = nil
					r_5861 = (function(r_5871)
						if (r_5871 <= r_5881) then
							local entry6 = nth1(contents2, r_5871)
							if number_3f_1(entry6) then
								compileExpression1(nth1(node40, succ1(entry6)), out7, state22)
							else
								append_21_1(out7, entry6)
							end
							return r_5861((r_5871 + 1))
						else
						end
					end)
					r_5861(1)
					local temp85
					local r_5901 = (meta4["tag"] ~= "expr")
					if r_5901 then
						temp85 = (ret1 ~= "")
					else
						temp85 = r_5901
					end
					if temp85 then
						line_21_1(out7)
						append_21_1(out7, ret1)
						append_21_1(out7, "nil")
						line_21_1(out7)
					else
					end
				else
					if ret1 then
						append_21_1(out7, ret1)
					else
					end
					if literal_3f_1(head2) then
						append_21_1(out7, "(")
						compileExpression1(head2, out7, state22)
						append_21_1(out7, ")")
					else
						compileExpression1(head2, out7, state22)
					end
					append_21_1(out7, "(")
					local r_5931 = _23_1(node40)
					local r_5911 = nil
					r_5911 = (function(r_5921)
						if (r_5921 <= r_5931) then
							if (r_5921 > 2) then
								append_21_1(out7, ", ")
							else
							end
							compileExpression1(nth1(node40, r_5921), out7, state22)
							return r_5911((r_5921 + 1))
						else
						end
					end)
					r_5911(2)
					append_21_1(out7, ")")
				end
			end
		else
			local temp86
			local r_5971 = ret1
			if r_5971 then
				local r_5981 = list_3f_1(head2)
				if r_5981 then
					local r_5991 = symbol_3f_1(car2(head2))
					if r_5991 then
						temp86 = (head2[1]["var"] == builtins4["lambda"])
					else
						temp86 = r_5991
					end
				else
					temp86 = r_5981
				end
			else
				temp86 = r_5971
			end
			if temp86 then
				local args9 = nth1(head2, 2)
				local offset4 = 1
				local r_6021 = _23_1(args9)
				local r_6001 = nil
				r_6001 = (function(r_6011)
					if (r_6011 <= r_6021) then
						local var12 = args9[r_6011]["var"]
						append_21_1(out7, _2e2e_2("local ", escapeVar1(var12, state22)))
						if var12["isVariadic"] then
							local count4 = (_23_1(node40) - _23_1(args9))
							if (count4 < 0) then
								count4 = 0
							else
							end
							append_21_1(out7, " = { tag=\"list\", n=")
							append_21_1(out7, tostring1(count4))
							local r_6061 = count4
							local r_6041 = nil
							r_6041 = (function(r_6051)
								if (r_6051 <= r_6061) then
									append_21_1(out7, ", ")
									compileExpression1(nth1(node40, (r_6011 + r_6051)), out7, state22)
									return r_6041((r_6051 + 1))
								else
								end
							end)
							r_6041(1)
							offset4 = count4
							line_21_1(out7, "}")
						else
							local expr2 = nth1(node40, (r_6011 + offset4))
							local name8 = escapeVar1(var12, state22)
							local ret2 = nil
							if expr2 then
								if statement_3f_1(expr2) then
									ret2 = _2e2e_2(name8, " = ")
									line_21_1(out7)
								else
									append_21_1(out7, " = ")
								end
								compileExpression1(expr2, out7, state22, ret2)
								line_21_1(out7)
							else
								line_21_1(out7)
							end
						end
						return r_6001((r_6011 + 1))
					else
					end
				end)
				r_6001(1)
				local r_6101 = _23_1(node40)
				local r_6081 = nil
				r_6081 = (function(r_6091)
					if (r_6091 <= r_6101) then
						compileExpression1(nth1(node40, r_6091), out7, state22, "")
						line_21_1(out7)
						return r_6081((r_6091 + 1))
					else
					end
				end)
				r_6081((_23_1(args9) + (offset4 + 1)))
				compileBlock1(head2, out7, state22, 3, ret1)
			else
				if ret1 then
					append_21_1(out7, ret1)
				else
				end
				if literal_3f_1(car2(node40)) then
					append_21_1(out7, "(")
					compileExpression1(car2(node40), out7, state22)
					append_21_1(out7, ")")
				else
					compileExpression1(car2(node40), out7, state22)
				end
				append_21_1(out7, "(")
				local r_6141 = _23_1(node40)
				local r_6121 = nil
				r_6121 = (function(r_6131)
					if (r_6131 <= r_6141) then
						if (r_6131 > 2) then
							append_21_1(out7, ", ")
						else
						end
						compileExpression1(nth1(node40, r_6131), out7, state22)
						return r_6121((r_6131 + 1))
					else
					end
				end)
				r_6121(2)
				append_21_1(out7, ")")
			end
		end
		return popNode_21_1(out7, node40)
	else
		if (ret1 == "") then
		else
			if ret1 then
				append_21_1(out7, ret1)
			else
			end
			if symbol_3f_1(node40) then
				return append_21_1(out7, escapeVar1(node40["var"], state22))
			elseif string_3f_1(node40) then
				return append_21_1(out7, quoted1(node40["value"]))
			elseif number_3f_1(node40) then
				return append_21_1(out7, tostring1(node40["value"]))
			elseif key_3f_1(node40) then
				return append_21_1(out7, quoted1(node40["value"]))
			else
				return error1(_2e2e_2("Unknown type: ", type1(node40)))
			end
		end
	end
end)
compileBlock1 = (function(nodes15, out8, state23, start7, ret3)
	local r_4571 = _23_1(nodes15)
	local r_4551 = nil
	r_4551 = (function(r_4561)
		if (r_4561 <= r_4571) then
			local ret_27_1
			if (r_4561 == _23_1(nodes15)) then
				ret_27_1 = ret3
			else
				ret_27_1 = ""
			end
			compileExpression1(nth1(nodes15, r_4561), out8, state23, ret_27_1)
			line_21_1(out8)
			return r_4551((r_4561 + 1))
		else
		end
	end)
	return r_4551(start7)
end)
prelude1 = (function(out9)
	line_21_1(out9, "if not table.pack then table.pack = function(...) return { n = select(\"#\", ...), ... } end end")
	line_21_1(out9, "if not table.unpack then table.unpack = unpack end")
	line_21_1(out9, "local load = load if _VERSION:find(\"5.1\") then load = function(x, n, _, env) local f, e = loadstring(x, n) if not f then error(e, 2) end if env then setfenv(f, env) end return f end end")
	return line_21_1(out9, "local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error")
end)
file3 = (function(compiler1, shebang1)
	local state24 = createState2(compiler1["libMeta"])
	local out10 = create2()
	if shebang1 then
		line_21_1(out10, _2e2e_2("#!/usr/bin/env ", shebang1))
	else
	end
	prelude1(out10)
	line_21_1(out10, "local _libs = {}")
	local r_6171 = compiler1["libs"]
	local r_6201 = _23_1(r_6171)
	local r_6181 = nil
	r_6181 = (function(r_6191)
		if (r_6191 <= r_6201) then
			local lib1 = r_6171[r_6191]
			local prefix1 = quoted1(lib1["prefix"])
			local native1 = lib1["native"]
			if native1 then
				line_21_1(out10, "local _temp = (function()")
				local r_6231 = split1(native1, "\n")
				local r_6261 = _23_1(r_6231)
				local r_6241 = nil
				r_6241 = (function(r_6251)
					if (r_6251 <= r_6261) then
						local line4 = r_6231[r_6251]
						if (line4 ~= "") then
							append_21_1(out10, "\9")
							line_21_1(out10, line4)
						else
						end
						return r_6241((r_6251 + 1))
					else
					end
				end)
				r_6241(1)
				line_21_1(out10, "end)()")
				line_21_1(out10, _2e2e_2("for k, v in pairs(_temp) do _libs[", prefix1, ".. k] = v end"))
			else
			end
			return r_6181((r_6191 + 1))
		else
		end
	end)
	r_6181(1)
	local count5 = 0
	local r_6291 = compiler1["out"]
	local r_6321 = _23_1(r_6291)
	local r_6301 = nil
	r_6301 = (function(r_6311)
		if (r_6311 <= r_6321) then
			local node41 = r_6291[r_6311]
			local var13 = node41["defVar"]
			if var13 then
				count5 = (count5 + 1)
			else
			end
			return r_6301((r_6311 + 1))
		else
		end
	end)
	r_6301(1)
	if between_3f_1(count5, 1, 150) then
		append_21_1(out10, "local ")
		local first9 = true
		local r_6351 = compiler1["out"]
		local r_6381 = _23_1(r_6351)
		local r_6361 = nil
		r_6361 = (function(r_6371)
			if (r_6371 <= r_6381) then
				local node42 = r_6351[r_6371]
				local var14 = node42["defVar"]
				if var14 then
					if first9 then
						first9 = false
					else
						append_21_1(out10, ", ")
					end
					append_21_1(out10, escapeVar1(var14, state24))
				else
				end
				return r_6361((r_6371 + 1))
			else
			end
		end)
		r_6361(1)
		line_21_1(out10)
	else
	end
	compileBlock1(compiler1["out"], out10, state24, 1, "return ")
	return out10
end)
executeStates1 = (function(backState1, states1, global1, logger8)
	local stateList1 = {tag = "list", n = 0}
	local nameList1 = {tag = "list", n = 0}
	local exportList1 = {tag = "list", n = 0}
	local escapeList1 = {tag = "list", n = 0}
	local r_4591 = nil
	r_4591 = (function(r_4601)
		if (r_4601 >= 1) then
			local state25 = nth1(states1, r_4601)
			if (state25["stage"] == "executed") then
			else
				local node43
				if state25["node"] then
				else
					node43 = error1(_2e2e_2("State is in ", state25["stage"], " instead"), 0)
				end
				local var15
				local r_4631 = state25["var"]
				if r_4631 then
					var15 = r_4631
				else
					var15 = struct1("name", "temp")
				end
				local escaped1 = escapeVar1(var15, backState1)
				local name9 = var15["name"]
				pushCdr_21_1(stateList1, state25)
				pushCdr_21_1(exportList1, _2e2e_2(escaped1, " = ", escaped1))
				pushCdr_21_1(nameList1, name9)
				pushCdr_21_1(escapeList1, escaped1)
			end
			return r_4591((r_4601 + -1))
		else
		end
	end)
	r_4591(_23_1(states1))
	if nil_3f_1(stateList1) then
	else
		local out11 = create2()
		local id3 = backState1["count"]
		local name10 = concat1(nameList1, ", ")
		backState1["count"] = succ1(id3)
		if (20 > len1(name10)) then
			name10 = _2e2e_2(sub1(name10, 1, 17), "...")
		else
		end
		name10 = _2e2e_2("compile#", id3, "{", name10, "}")
		prelude1(out11)
		line_21_1(out11, _2e2e_2("local ", concat1(escapeList1, ", ")))
		local r_6421 = _23_1(stateList1)
		local r_6401 = nil
		r_6401 = (function(r_6411)
			if (r_6411 <= r_6421) then
				local state26 = nth1(stateList1, r_6411)
				compileExpression1(state26["node"], out11, backState1, (function()
					if state26["var"] then
						return ""
					else
						return _2e2e_2(nth1(escapeList1, r_6411), "= ")
					end
				end)()
				)
				line_21_1(out11)
				return r_6401((r_6411 + 1))
			else
			end
		end)
		r_6401(1)
		line_21_1(out11, _2e2e_2("return { ", concat1(exportList1, ", "), "}"))
		local str2 = _2d3e_string1(out11)
		backState1["mappings"][name10] = generateMappings1(out11["lines"])
		local r_6441 = list1(load1(str2, _2e2e_2("=", name10), "t", global1))
		local temp87
		local r_6471 = list_3f_1(r_6441)
		if r_6471 then
			local r_6481 = (_23_1(r_6441) == 2)
			if r_6481 then
				local r_6491 = eq_3f_1(nth1(r_6441, 1), nil)
				if r_6491 then
					temp87 = true
				else
					temp87 = r_6491
				end
			else
				temp87 = r_6481
			end
		else
			temp87 = r_6471
		end
		if temp87 then
			local msg14 = nth1(r_6441, 2)
			return fail_21_1(_2e2e_2(msg14, ":\n", str2))
		else
			local temp88
			local r_6501 = list_3f_1(r_6441)
			if r_6501 then
				local r_6511 = (_23_1(r_6441) == 1)
				if r_6511 then
					temp88 = true
				else
					temp88 = r_6511
				end
			else
				temp88 = r_6501
			end
			if temp88 then
				local fun1 = nth1(r_6441, 1)
				local r_6521 = list1(xpcall1(fun1, traceback1))
				local temp89
				local r_6551 = list_3f_1(r_6521)
				if r_6551 then
					local r_6561 = (_23_1(r_6521) == 2)
					if r_6561 then
						local r_6571 = eq_3f_1(nth1(r_6521, 1), false)
						if r_6571 then
							temp89 = true
						else
							temp89 = r_6571
						end
					else
						temp89 = r_6561
					end
				else
					temp89 = r_6551
				end
				if temp89 then
					local msg15 = nth1(r_6521, 2)
					return fail_21_1(remapTraceback1(backState1["mappings"], msg15))
				else
					local temp90
					local r_6581 = list_3f_1(r_6521)
					if r_6581 then
						local r_6591 = (_23_1(r_6521) == 2)
						if r_6591 then
							local r_6601 = eq_3f_1(nth1(r_6521, 1), true)
							if r_6601 then
								temp90 = true
							else
								temp90 = r_6601
							end
						else
							temp90 = r_6591
						end
					else
						temp90 = r_6581
					end
					if temp90 then
						local tbl1 = nth1(r_6521, 2)
						local r_6631 = _23_1(stateList1)
						local r_6611 = nil
						r_6611 = (function(r_6621)
							if (r_6621 <= r_6631) then
								local state27 = nth1(stateList1, r_6621)
								local escaped2 = nth1(escapeList1, r_6621)
								local res4 = tbl1[escaped2]
								self1(state27, "executed", res4)
								if state27["var"] then
									global1[escaped2] = res4
								else
								end
								return r_6611((r_6621 + 1))
							else
							end
						end)
						return r_6611(1)
					else
						return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_6521), ", but none matched.\n", "  Tried: `(false ?msg)`\n  Tried: `(true ?tbl)`"))
					end
				end
			else
				return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_6441), ", but none matched.\n", "  Tried: `(nil ?msg)`\n  Tried: `(?fun)`"))
			end
		end
	end
end)
emitLua1 = struct1("name", "emit-lua", "setup", (function(spec7)
	addArgument_21_1(spec7, {tag = "list", n = 1, "--emit-lua"}, "help", "Emit a Lua file.")
	addArgument_21_1(spec7, {tag = "list", n = 1, "--shebang"}, "value", (function(r_6651)
		if r_6651 then
			return r_6651
		else
			local r_6661 = nth1(arg1, 0)
			if r_6661 then
				return r_6661
			else
				return "lua"
			end
		end
	end)(nth1(arg1, -1)), "help", "Set the executable to use for the shebang.", "narg", "?")
	return addArgument_21_1(spec7, {tag = "list", n = 1, "--chmod"}, "help", "Run chmod +x on the resulting file")
end), "pred", (function(args10)
	return args10["emit-lua"]
end), "run", (function(compiler2, args11)
	if nil_3f_1(args11["input"]) then
		putError_21_1(compiler2["log"], "No inputs to compile.")
		exit_21_1(1)
	else
	end
	local out12 = file3(compiler2, args11["shebang"])
	local handle1 = open1(_2e2e_2(args11["output"], ".lua"), "w")
	self1(handle1, "write", _2d3e_string1(out12))
	self1(handle1, "close")
	if args11["chmod"] then
		return execute1(_2e2e_2("chmod +x ", quoted1(_2e2e_2(args11["output"], ".lua"))))
	else
	end
end))
emitLisp1 = struct1("name", "emit-lisp", "setup", (function(spec8)
	return addArgument_21_1(spec8, {tag = "list", n = 1, "--emit-lisp"}, "help", "Emit a Lisp file.")
end), "pred", (function(args12)
	return args12["emit-lisp"]
end), "run", (function(compiler3, args13)
	if nil_3f_1(args13["input"]) then
		putError_21_1(compiler3["log"], "No inputs to compile.")
		exit_21_1(1)
	else
	end
	local writer13 = create2()
	block1(compiler3["out"], writer13)
	local handle2 = open1(_2e2e_2(args13["output"], ".lisp"), "w")
	self1(handle2, "write", _2d3e_string1(writer13))
	return self1(handle2, "close")
end))
passArg1 = (function(arg23, data4, value8, usage_21_4)
	local val15 = tonumber1(value8)
	local name11 = _2e2e_2(arg23["name"], "-override")
	local override2 = data4[name11]
	if override2 then
	else
		override2 = ({})
		data4[name11] = override2
	end
	if val15 then
		data4[arg23["name"]] = val15
		return nil
	elseif (charAt1(value8, 1) == "-") then
		override2[sub1(value8, 2)] = false
		return nil
	elseif (charAt1(value8, 1) == "+") then
		override2[sub1(value8, 2)] = true
		return nil
	else
		return usage_21_4(_2e2e_2("Expected number or enable/disable flag for --", arg23["name"], " , got ", value8))
	end
end)
passRun1 = (function(fun2, name12)
	return (function(compiler4, args14)
		return fun2(compiler4["out"], struct1("track", true, "level", args14[name12], "override", (function(r_1591)
			if r_1591 then
				return r_1591
			else
				return ({})
			end
		end)(args14[_2e2e_2(name12, "-override")]), "time", args14["time"], "max-n", args14[_2e2e_2(name12, "-n")], "max-time", args14[_2e2e_2(name12, "-time")], "meta", compiler4["libMeta"], "logger", compiler4["log"]))
	end)
end)
warning1 = struct1("name", "warning", "setup", (function(spec9)
	return addArgument_21_1(spec9, {tag = "list", n = 2, "--warning", "-W"}, "help", "Either the warning level to use or an enable/disable flag for a pass.", "default", 1, "narg", 1, "var", "LEVEL", "action", passArg1)
end), "pred", (function(args15)
	return (args15["warning"] > 0)
end), "run", passRun1(analyse1, "warning"))
optimise2 = struct1("name", "optimise", "setup", (function(spec10)
	addArgument_21_1(spec10, {tag = "list", n = 2, "--optimise", "-O"}, "help", "Either the optimiation level to use or an enable/disable flag for a pass.", "default", 1, "narg", 1, "var", "LEVEL", "action", passArg1)
	addArgument_21_1(spec10, {tag = "list", n = 2, "--optimise-n", "--optn"}, "help", "The maximum number of iterations the optimiser should run for.", "default", 10, "narg", 1, "action", setNumAction1)
	return addArgument_21_1(spec10, {tag = "list", n = 2, "--optimise-time", "--optt"}, "help", "The maximum time the optimiser should run for.", "default", -1, "narg", 1, "action", setNumAction1)
end), "pred", (function(args16)
	return (args16["optimise"] > 0)
end), "run", passRun1(optimise1, "optimise"))
builtins5 = require1("tacky.analysis.resolve")["builtins"]
tokens1 = {tag = "list", n = 7, {tag = "list", n = 2, "arg", "(%f[%a]%u+%f[%A])"}, {tag = "list", n = 2, "mono", "```[a-z]*\n([^`]*)\n```"}, {tag = "list", n = 2, "mono", "`([^`]*)`"}, {tag = "list", n = 2, "bolic", "(%*%*%*%w.-%w%*%*%*)"}, {tag = "list", n = 2, "bold", "(%*%*%w.-%w%*%*)"}, {tag = "list", n = 2, "italic", "(%*%w.-%w%*)"}, {tag = "list", n = 2, "link", "%[%[(.-)%]%]"}}
extractSignature1 = (function(var16)
	local ty7 = type1(var16)
	local temp91
	local r_6741 = (ty7 == "macro")
	if r_6741 then
		temp91 = r_6741
	else
		temp91 = (ty7 == "defined")
	end
	if temp91 then
		local root1 = var16["node"]
		local node44 = nth1(root1, _23_1(root1))
		local temp92
		local r_6751 = list_3f_1(node44)
		if r_6751 then
			local r_6761 = symbol_3f_1(car2(node44))
			if r_6761 then
				temp92 = (car2(node44)["var"] == builtins5["lambda"])
			else
				temp92 = r_6761
			end
		else
			temp92 = r_6751
		end
		if temp92 then
			return nth1(node44, 2)
		else
			return nil
		end
	else
		return nil
	end
end)
parseDocstring1 = (function(str3)
	local out13 = {tag = "list", n = 0}
	local pos7 = 1
	local len7 = len1(str3)
	local r_6771 = nil
	r_6771 = (function()
		if (pos7 <= len7) then
			local spos1 = len7
			local epos1 = nil
			local name13 = nil
			local ptrn1 = nil
			local r_6821 = _23_1(tokens1)
			local r_6801 = nil
			r_6801 = (function(r_6811)
				if (r_6811 <= r_6821) then
					local tok1 = tokens1[r_6811]
					local npos1 = list1(find1(str3, nth1(tok1, 2), pos7))
					local temp93
					local r_6841 = car2(npos1)
					if r_6841 then
						temp93 = (car2(npos1) < spos1)
					else
						temp93 = r_6841
					end
					if temp93 then
						spos1 = car2(npos1)
						epos1 = nth1(npos1, 2)
						name13 = car2(tok1)
						ptrn1 = nth1(tok1, 2)
					else
					end
					return r_6801((r_6811 + 1))
				else
				end
			end)
			r_6801(1)
			if name13 then
				if (pos7 < spos1) then
					pushCdr_21_1(out13, struct1("tag", "text", "contents", sub1(str3, pos7, pred1(spos1))))
				else
				end
				pushCdr_21_1(out13, struct1("tag", name13, "whole", sub1(str3, spos1, epos1), "contents", match1(sub1(str3, spos1, epos1), ptrn1)))
				pos7 = succ1(epos1)
			else
				pushCdr_21_1(out13, struct1("tag", "text", "contents", sub1(str3, pos7, len7)))
				pos7 = succ1(len7)
			end
			return r_6771()
		else
		end
	end)
	r_6771()
	return out13
end)
Scope1 = require1("tacky.analysis.scope")
formatRange2 = (function(range5)
	return format1("%s:%s", range5["name"], formatPosition1(range5["start"]))
end)
sortVars_21_1 = (function(list3)
	return sort1(list3, (function(a3, b3)
		return (car2(a3) < car2(b3))
	end))
end)
formatDefinition1 = (function(var17)
	local ty8 = type1(var17)
	if (ty8 == "builtin") then
		return "Builtin term"
	elseif (ty8 == "macro") then
		return _2e2e_2("Macro defined at ", formatRange2(getSource1(var17["node"])))
	elseif (ty8 == "native") then
		return _2e2e_2("Native defined at ", formatRange2(getSource1(var17["node"])))
	elseif (ty8 == "defined") then
		return _2e2e_2("Defined at ", formatRange2(getSource1(var17["node"])))
	else
		_error("unmatched item")
	end
end)
formatSignature1 = (function(name14, var18)
	local sig1 = extractSignature1(var18)
	if (sig1 == nil) then
		return name14
	elseif nil_3f_1(sig1) then
		return _2e2e_2("(", name14, ")")
	else
		return _2e2e_2("(", name14, " ", concat1(traverse1(sig1, (function(r_6671)
			return r_6671["contents"]
		end)), " "), ")")
	end
end)
writeDocstring1 = (function(out14, str4, scope1)
	local r_6691 = parseDocstring1(str4)
	local r_6721 = _23_1(r_6691)
	local r_6701 = nil
	r_6701 = (function(r_6711)
		if (r_6711 <= r_6721) then
			local tok2 = r_6691[r_6711]
			local ty9 = type1(tok2)
			if (ty9 == "text") then
				append_21_1(out14, tok2["contents"])
			elseif (ty9 == "boldic") then
				append_21_1(out14, tok2["contents"])
			elseif (ty9 == "bold") then
				append_21_1(out14, tok2["contents"])
			elseif (ty9 == "italic") then
				append_21_1(out14, tok2["contents"])
			elseif (ty9 == "arg") then
				append_21_1(out14, _2e2e_2("`", tok2["contents"], "`"))
			elseif (ty9 == "mono") then
				append_21_1(out14, tok2["whole"])
			elseif (ty9 == "link") then
				local name15 = tok2["contents"]
				local ovar1 = Scope1["get"](scope1, name15)
				local temp94
				if ovar1 then
					temp94 = ovar1["node"]
				else
					temp94 = ovar1
				end
				if temp94 then
					local loc1
					local r_6901
					local r_6891
					local r_6881
					local r_6871 = ovar1["node"]
					r_6881 = getSource1(r_6871)
					r_6891 = r_6881["name"]
					r_6901 = gsub1(r_6891, "%.lisp$", "")
					loc1 = gsub1(r_6901, "/", ".")
					local sig2 = extractSignature1(ovar1)
					local hash1
					if (sig2 == nil) then
						hash1 = ovar1["name"]
					elseif nil_3f_1(sig2) then
						hash1 = ovar1["name"]
					else
						hash1 = _2e2e_2(name15, " ", concat1(traverse1(sig2, (function(r_6861)
							return r_6861["contents"]
						end)), " "))
					end
					append_21_1(out14, format1("[`%s`](%s.md#%s)", name15, loc1, gsub1(hash1, "%A+", "-")))
				else
					append_21_1(out14, format1("`%s`", name15))
				end
			else
				_error("unmatched item")
			end
			return r_6701((r_6711 + 1))
		else
		end
	end)
	r_6701(1)
	return line_21_1(out14)
end)
exported1 = (function(out15, title1, primary1, vars1, scope2)
	local documented1 = {tag = "list", n = 0}
	local undocumented1 = {tag = "list", n = 0}
	iterPairs1(vars1, (function(name16, var19)
		return pushCdr_21_1((function()
			if var19["doc"] then
				return documented1
			else
				return undocumented1
			end
		end)()
		, list1(name16, var19))
	end))
	sortVars_21_1(documented1)
	sortVars_21_1(undocumented1)
	line_21_1(out15, "---")
	line_21_1(out15, _2e2e_2("title: ", title1))
	line_21_1(out15, "---")
	line_21_1(out15, _2e2e_2("# ", title1))
	if primary1 then
		writeDocstring1(out15, primary1, scope2)
		line_21_1(out15, "", true)
	else
	end
	local r_6951 = _23_1(documented1)
	local r_6931 = nil
	r_6931 = (function(r_6941)
		if (r_6941 <= r_6951) then
			local entry7 = documented1[r_6941]
			local name17 = car2(entry7)
			local var20 = nth1(entry7, 2)
			line_21_1(out15, _2e2e_2("## `", formatSignature1(name17, var20), "`"))
			line_21_1(out15, _2e2e_2("*", formatDefinition1(var20), "*"))
			line_21_1(out15, "", true)
			writeDocstring1(out15, var20["doc"], var20["scope"])
			line_21_1(out15, "", true)
			return r_6931((r_6941 + 1))
		else
		end
	end)
	r_6931(1)
	if nil_3f_1(undocumented1) then
	else
		line_21_1(out15, "## Undocumented symbols")
	end
	local r_7011 = _23_1(undocumented1)
	local r_6991 = nil
	r_6991 = (function(r_7001)
		if (r_7001 <= r_7011) then
			local entry8 = undocumented1[r_7001]
			local name18 = car2(entry8)
			local var21 = nth1(entry8, 2)
			line_21_1(out15, _2e2e_2(" - `", formatSignature1(name18, var21), "` *", formatDefinition1(var21), "*"))
			return r_6991((r_7001 + 1))
		else
		end
	end)
	return r_6991(1)
end)
docs1 = (function(compiler5, args17)
	if nil_3f_1(args17["input"]) then
		putError_21_1(compiler5["log"], "No inputs to generate documentation for.")
		exit_21_1(1)
	else
	end
	local r_7041 = args17["input"]
	local r_7071 = _23_1(r_7041)
	local r_7051 = nil
	r_7051 = (function(r_7061)
		if (r_7061 <= r_7071) then
			local path1 = r_7041[r_7061]
			if (sub1(path1, -5) == ".lisp") then
				path1 = sub1(path1, 1, -6)
			else
			end
			local lib2 = compiler5["libCache"][path1]
			local writer14 = create2()
			exported1(writer14, lib2["name"], lib2["docs"], lib2["scope"]["exported"], lib2["scope"])
			local handle3 = open1(_2e2e_2(args17["docs"], "/", gsub1(path1, "/", "."), ".md"), "w")
			self1(handle3, "write", _2d3e_string1(writer14))
			self1(handle3, "close")
			return r_7051((r_7061 + 1))
		else
		end
	end)
	return r_7051(1)
end)
task1 = struct1("name", "docs", "setup", (function(spec11)
	return addArgument_21_1(spec11, {tag = "list", n = 1, "--docs"}, "help", "Specify the folder to emit documentation to.", "default", nil, "narg", 1)
end), "pred", (function(args18)
	return (nil ~= args18["docs"])
end), "run", docs1)
config1 = package.config
coloredAnsi1 = (function(col1, msg16)
	return _2e2e_2("\27[", col1, "m", msg16, "\27[0m")
end)
local temp95
if config1 then
	temp95 = (charAt1(config1, 1) ~= "\\")
else
	temp95 = config1
end
if temp95 then
	colored_3f_1 = true
else
	local temp96
	if getenv1 then
		temp96 = (getenv1("ANSICON") ~= nil)
	else
		temp96 = getenv1
	end
	if temp96 then
		colored_3f_1 = true
	else
		local temp97
		if getenv1 then
			local term1 = getenv1("TERM")
			if term1 then
				temp97 = find1(term1, "xterm")
			else
				temp97 = nil
			end
		else
			temp97 = getenv1
		end
		if temp97 then
			colored_3f_1 = true
		else
			colored_3f_1 = false
		end
	end
end
if colored_3f_1 then
	colored1 = coloredAnsi1
else
	colored1 = (function(col2, msg17)
		return msg17
	end)
end
create3 = coroutine.create
resume1 = coroutine.resume
status1 = coroutine.status
local discard1 = (function()
end)
void1 = struct1("put-error!", discard1, "put-warning!", discard1, "put-verbose!", discard1, "put-debug!", discard1, "put-node-error!", discard1, "put-node-warning!", discard1)
hexDigit_3f_1 = (function(char4)
	local r_7141 = between_3f_1(char4, "0", "9")
	if r_7141 then
		return r_7141
	else
		local r_7151 = between_3f_1(char4, "a", "f")
		if r_7151 then
			return r_7151
		else
			return between_3f_1(char4, "A", "F")
		end
	end
end)
binDigit_3f_1 = (function(char5)
	local r_7161 = (char5 == "0")
	if r_7161 then
		return r_7161
	else
		return (char5 == "1")
	end
end)
terminator_3f_1 = (function(char6)
	local r_7171 = (char6 == "\n")
	if r_7171 then
		return r_7171
	else
		local r_7181 = (char6 == " ")
		if r_7181 then
			return r_7181
		else
			local r_7191 = (char6 == "\9")
			if r_7191 then
				return r_7191
			else
				local r_7201 = (char6 == "(")
				if r_7201 then
					return r_7201
				else
					local r_7211 = (char6 == ")")
					if r_7211 then
						return r_7211
					else
						local r_7221 = (char6 == "[")
						if r_7221 then
							return r_7221
						else
							local r_7231 = (char6 == "]")
							if r_7231 then
								return r_7231
							else
								local r_7241 = (char6 == "{")
								if r_7241 then
									return r_7241
								else
									local r_7251 = (char6 == "}")
									if r_7251 then
										return r_7251
									else
										return (char6 == "")
									end
								end
							end
						end
					end
				end
			end
		end
	end
end)
digitError_21_1 = (function(logger9, pos8, name19, char7)
	return doNodeError_21_1(logger9, format1("Expected %s digit, got %s", name19, (function()
		if (char7 == "") then
			return "eof"
		else
			return quoted1(char7)
		end
	end)()
	), pos8, nil, pos8, "Invalid digit here")
end)
lex1 = (function(logger10, str5, name20)
	str5 = gsub1(str5, "\13\n?", "\n")
	local lines6 = split1(str5, "\n")
	local line5 = 1
	local column1 = 1
	local offset5 = 1
	local length1 = len1(str5)
	local out16 = {tag = "list", n = 0}
	local consume_21_1 = (function()
		if (charAt1(str5, offset5) == "\n") then
			line5 = (line5 + 1)
			column1 = 1
		else
			column1 = (column1 + 1)
		end
		offset5 = (offset5 + 1)
		return nil
	end)
	local position1 = (function()
		return struct1("line", line5, "column", column1, "offset", offset5)
	end)
	local range6 = (function(start8, finish2)
		return struct1("start", start8, "finish", (function()
			if finish2 then
				return finish2
			else
				return start8
			end
		end)(), "lines", lines6, "name", name20)
	end)
	local appendWith_21_1 = (function(data5, start9, finish3)
		local start10
		if start9 then
			start10 = start9
		else
			start10 = position1()
		end
		local finish4
		if finish3 then
			finish4 = finish3
		else
			finish4 = position1()
		end
		data5["range"] = range6(start10, finish4)
		data5["contents"] = sub1(str5, start10["offset"], finish4["offset"])
		return pushCdr_21_1(out16, data5)
	end)
	local append_21_2 = (function(tag11, start11, finish5)
		return appendWith_21_1(struct1("tag", tag11), start11, finish5)
	end)
	local parseBase1 = (function(name21, p3, base1)
		local start12 = offset5
		local char8 = charAt1(str5, offset5)
		if p3(char8) then
		else
			digitError_21_1(logger10, range6(position1()), name21, char8)
		end
		char8 = charAt1(str5, succ1(offset5))
		local r_7551 = nil
		r_7551 = (function()
			if p3(char8) then
				consume_21_1()
				char8 = charAt1(str5, succ1(offset5))
				return r_7551()
			else
			end
		end)
		r_7551()
		return tonumber1(sub1(str5, start12, offset5), base1)
	end)
	local r_7341 = nil
	r_7341 = (function()
		if (offset5 <= length1) then
			local char9 = charAt1(str5, offset5)
			local temp98
			local r_7351 = (char9 == "\n")
			if r_7351 then
				temp98 = r_7351
			else
				local r_7361 = (char9 == "\9")
				if r_7361 then
					temp98 = r_7361
				else
					temp98 = (char9 == " ")
				end
			end
			if temp98 then
			elseif (char9 == "(") then
				appendWith_21_1(struct1("tag", "open", "close", ")"))
			elseif (char9 == ")") then
				appendWith_21_1(struct1("tag", "close", "open", "("))
			elseif (char9 == "[") then
				appendWith_21_1(struct1("tag", "open", "close", "]"))
			elseif (char9 == "]") then
				appendWith_21_1(struct1("tag", "close", "open", "["))
			elseif (char9 == "{") then
				appendWith_21_1(struct1("tag", "open", "close", "}"))
			elseif (char9 == "}") then
				appendWith_21_1(struct1("tag", "close", "open", "{"))
			elseif (char9 == "'") then
				append_21_2("quote")
			elseif (char9 == "`") then
				append_21_2("syntax-quote")
			elseif (char9 == "~") then
				append_21_2("quasiquote")
			elseif (char9 == ",") then
				if (charAt1(str5, succ1(offset5)) == "@") then
					local start13 = position1()
					consume_21_1()
					append_21_2("unquote-splice", start13)
				else
					append_21_2("unquote")
				end
			elseif find1(str5, "^%-?%.?[0-9]", offset5) then
				local start14 = position1()
				local negative1 = (char9 == "-")
				if negative1 then
					consume_21_1()
					char9 = charAt1(str5, offset5)
				else
				end
				local val16
				local temp99
				local r_7371 = (char9 == "0")
				if r_7371 then
					temp99 = (charAt1(str5, succ1(offset5)) == "x")
				else
					temp99 = r_7371
				end
				if temp99 then
					consume_21_1()
					consume_21_1()
					local res5 = parseBase1("hexadecimal", hexDigit_3f_1, 16)
					if negative1 then
						res5 = (0 - res5)
					else
					end
					val16 = res5
				else
					local temp100
					local r_7381 = (char9 == "0")
					if r_7381 then
						temp100 = (charAt1(str5, succ1(offset5)) == "b")
					else
						temp100 = r_7381
					end
					if temp100 then
						consume_21_1()
						consume_21_1()
						local res6 = parseBase1("binary", binDigit_3f_1, 2)
						if negative1 then
							res6 = (0 - res6)
						else
						end
						val16 = res6
					else
						local r_7391 = nil
						r_7391 = (function()
							if between_3f_1(charAt1(str5, succ1(offset5)), "0", "9") then
								consume_21_1()
								return r_7391()
							else
							end
						end)
						r_7391()
						if (charAt1(str5, succ1(offset5)) == ".") then
							consume_21_1()
							local r_7401 = nil
							r_7401 = (function()
								if between_3f_1(charAt1(str5, succ1(offset5)), "0", "9") then
									consume_21_1()
									return r_7401()
								else
								end
							end)
							r_7401()
						else
						end
						char9 = charAt1(str5, succ1(offset5))
						local temp101
						local r_7411 = (char9 == "e")
						if r_7411 then
							temp101 = r_7411
						else
							temp101 = (char9 == "E")
						end
						if temp101 then
							consume_21_1()
							char9 = charAt1(str5, succ1(offset5))
							local temp102
							local r_7421 = (char9 == "-")
							if r_7421 then
								temp102 = r_7421
							else
								temp102 = (char9 == "+")
							end
							if temp102 then
								consume_21_1()
							else
							end
							local r_7431 = nil
							r_7431 = (function()
								if between_3f_1(charAt1(str5, succ1(offset5)), "0", "9") then
									consume_21_1()
									return r_7431()
								else
								end
							end)
							r_7431()
						else
						end
						val16 = tonumber1(sub1(str5, start14["offset"], offset5))
					end
				end
				appendWith_21_1(struct1("tag", "number", "value", val16), start14)
				char9 = charAt1(str5, succ1(offset5))
				if terminator_3f_1(char9) then
				else
					consume_21_1()
					doNodeError_21_1(logger10, format1("Expected digit, got %s", (function()
						if (char9 == "") then
							return "eof"
						else
							return char9
						end
					end)()
					), range6(position1()), nil, range6(position1()), "Illegal character here. Are you missing whitespace?")
				end
			elseif (char9 == "\"") then
				local start15 = position1()
				local startCol1 = succ1(column1)
				local buffer3 = {tag = "list", n = 0}
				consume_21_1()
				char9 = charAt1(str5, offset5)
				local r_7441 = nil
				r_7441 = (function()
					if (char9 ~= "\"") then
						if (column1 == 1) then
							local running3 = true
							local lineOff1 = offset5
							local r_7451 = nil
							r_7451 = (function()
								local temp103
								local r_7461 = running3
								if r_7461 then
									temp103 = (column1 < startCol1)
								else
									temp103 = r_7461
								end
								if temp103 then
									if (char9 == " ") then
										consume_21_1()
									elseif (char9 == "\n") then
										consume_21_1()
										pushCdr_21_1(buffer3, "\n")
										lineOff1 = offset5
									elseif (char9 == "") then
										running3 = false
									else
										putNodeWarning_21_1(logger10, format1("Expected leading indent, got %q", char9), range6(position1()), "You should try to align multi-line strings at the initial quote\nmark. This helps keep programs neat and tidy.", range6(start15), "String started with indent here", range6(position1()), "Mis-aligned character here")
										pushCdr_21_1(buffer3, sub1(str5, lineOff1, pred1(offset5)))
										running3 = false
									end
									char9 = charAt1(str5, offset5)
									return r_7451()
								else
								end
							end)
							r_7451()
						else
						end
						if (char9 == "") then
							local start16 = range6(start15)
							local finish6 = range6(position1())
							doNodeError_21_1(logger10, "Expected '\"', got eof", finish6, nil, start16, "string started here", finish6, "end of file here")
						elseif (char9 == "\\") then
							consume_21_1()
							char9 = charAt1(str5, offset5)
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
								local temp104
								local r_7471 = (char9 == "x")
								if r_7471 then
									temp104 = r_7471
								else
									local r_7481 = (char9 == "X")
									if r_7481 then
										temp104 = r_7481
									else
										temp104 = between_3f_1(char9, "0", "9")
									end
								end
								if temp104 then
									local start17 = position1()
									local val17
									local temp105
									local r_7491 = (char9 == "x")
									if r_7491 then
										temp105 = r_7491
									else
										temp105 = (char9 == "X")
									end
									if temp105 then
										consume_21_1()
										local start18 = offset5
										if hexDigit_3f_1(charAt1(str5, offset5)) then
										else
											digitError_21_1(logger10, range6(position1()), "hexadecimal", charAt1(str5, offset5))
										end
										if hexDigit_3f_1(charAt1(str5, succ1(offset5))) then
											consume_21_1()
										else
										end
										val17 = tonumber1(sub1(str5, start18, offset5), 16)
									else
										local start19 = position1()
										local ctr1 = 0
										char9 = charAt1(str5, succ1(offset5))
										local r_7501 = nil
										r_7501 = (function()
											local temp106
											local r_7511 = (ctr1 < 2)
											if r_7511 then
												temp106 = between_3f_1(char9, "0", "9")
											else
												temp106 = r_7511
											end
											if temp106 then
												consume_21_1()
												char9 = charAt1(str5, succ1(offset5))
												ctr1 = (ctr1 + 1)
												return r_7501()
											else
											end
										end)
										r_7501()
										val17 = tonumber1(sub1(str5, start19["offset"], offset5))
									end
									if (val17 >= 256) then
										doNodeError_21_1(logger10, "Invalid escape code", range6(start17()), nil, range6(start17(), position1), _2e2e_2("Must be between 0 and 255, is ", val17))
									else
									end
									pushCdr_21_1(buffer3, char1(val17))
								elseif (char9 == "") then
									doNodeError_21_1(logger10, "Expected escape code, got eof", range6(position1()), nil, range6(position1()), "end of file here")
								else
									doNodeError_21_1(logger10, "Illegal escape character", range6(position1()), nil, range6(position1()), "Unknown escape character")
								end
							end
						else
							pushCdr_21_1(buffer3, char9)
						end
						consume_21_1()
						char9 = charAt1(str5, offset5)
						return r_7441()
					else
					end
				end)
				r_7441()
				appendWith_21_1(struct1("tag", "string", "value", concat1(buffer3)), start15)
			elseif (char9 == ";") then
				local r_7521 = nil
				r_7521 = (function()
					local temp107
					local r_7531 = (offset5 <= length1)
					if r_7531 then
						temp107 = (charAt1(str5, succ1(offset5)) ~= "\n")
					else
						temp107 = r_7531
					end
					if temp107 then
						consume_21_1()
						return r_7521()
					else
					end
				end)
				r_7521()
			else
				local start20 = position1()
				local key9 = (char9 == ":")
				char9 = charAt1(str5, succ1(offset5))
				local r_7541 = nil
				r_7541 = (function()
					if _21_1(terminator_3f_1(char9)) then
						consume_21_1()
						char9 = charAt1(str5, succ1(offset5))
						return r_7541()
					else
					end
				end)
				r_7541()
				if key9 then
					appendWith_21_1(struct1("tag", "key", "value", sub1(str5, succ1(start20["offset"]), offset5)), start20)
				else
					append_21_2("symbol", start20)
				end
			end
			consume_21_1()
			return r_7341()
		else
		end
	end)
	r_7341()
	append_21_2("eof")
	return out16
end)
parse1 = (function(logger11, toks1)
	local head3 = {tag = "list", n = 0}
	local stack2 = {tag = "list", n = 0}
	local append_21_3 = (function(node45)
		pushCdr_21_1(head3, node45)
		node45["parent"] = head3
		return nil
	end)
	local push_21_1 = (function()
		local next2 = {tag = "list", n = 0}
		pushCdr_21_1(stack2, head3)
		append_21_3(next2)
		head3 = next2
		return nil
	end)
	local pop_21_1 = (function()
		head3["open"] = nil
		head3["close"] = nil
		head3["auto-close"] = nil
		head3["last-node"] = nil
		head3 = last1(stack2)
		return popLast_21_1(stack2)
	end)
	local r_7301 = _23_1(toks1)
	local r_7281 = nil
	r_7281 = (function(r_7291)
		if (r_7291 <= r_7301) then
			local tok3 = toks1[r_7291]
			local tag12 = tok3["tag"]
			local autoClose1 = false
			local previous2 = head3["last-node"]
			local tokPos1 = tok3["range"]
			local temp108
			local r_7321 = (tag12 ~= "eof")
			if r_7321 then
				local r_7331 = (tag12 ~= "close")
				if r_7331 then
					if head3["range"] then
						temp108 = (tokPos1["start"]["line"] ~= head3["range"]["start"]["line"])
					else
						temp108 = true
					end
				else
					temp108 = r_7331
				end
			else
				temp108 = r_7321
			end
			if temp108 then
				if previous2 then
					local prevPos1 = previous2["range"]
					if (tokPos1["start"]["line"] ~= prevPos1["start"]["line"]) then
						head3["last-node"] = tok3
						if (tokPos1["start"]["column"] ~= prevPos1["start"]["column"]) then
							putNodeWarning_21_1(logger11, "Different indent compared with previous expressions.", tok3, "You should try to maintain consistent indentation across a program,\ntry to ensure all expressions are lined up.\nIf this looks OK to you, check you're not missing a closing ')'.", prevPos1, "", tokPos1, "")
						else
						end
					else
					end
				else
					head3["last-node"] = tok3
				end
			else
			end
			local temp109
			local r_7591 = (tag12 == "string")
			if r_7591 then
				temp109 = r_7591
			else
				local r_7601 = (tag12 == "number")
				if r_7601 then
					temp109 = r_7601
				else
					local r_7611 = (tag12 == "symbol")
					if r_7611 then
						temp109 = r_7611
					else
						temp109 = (tag12 == "key")
					end
				end
			end
			if temp109 then
				append_21_3(tok3)
			elseif (tag12 == "open") then
				push_21_1()
				head3["open"] = tok3["contents"]
				head3["close"] = tok3["close"]
				head3["range"] = struct1("start", tok3["range"]["start"], "name", tok3["range"]["name"], "lines", tok3["range"]["lines"])
			elseif (tag12 == "close") then
				if nil_3f_1(stack2) then
					doNodeError_21_1(logger11, format1("'%s' without matching '%s'", tok3["contents"], tok3["open"]), tok3, nil, getSource1(tok3), "")
				elseif head3["auto-close"] then
					doNodeError_21_1(logger11, format1("'%s' without matching '%s' inside quote", tok3["contents"], tok3["open"]), tok3, nil, head3["range"], "quote opened here", tok3["range"], "attempting to close here")
				elseif (head3["close"] ~= tok3["contents"]) then
					doNodeError_21_1(logger11, format1("Expected '%s', got '%s'", head3["close"], tok3["contents"]), tok3, nil, head3["range"], format1("block opened with '%s'", head3["open"]), tok3["range"], format1("'%s' used here", tok3["contents"]))
				else
					head3["range"]["finish"] = tok3["range"]["finish"]
					pop_21_1()
				end
			else
				local temp110
				local r_7621 = (tag12 == "quote")
				if r_7621 then
					temp110 = r_7621
				else
					local r_7631 = (tag12 == "unquote")
					if r_7631 then
						temp110 = r_7631
					else
						local r_7641 = (tag12 == "syntax-quote")
						if r_7641 then
							temp110 = r_7641
						else
							local r_7651 = (tag12 == "unquote-splice")
							if r_7651 then
								temp110 = r_7651
							else
								temp110 = (tag12 == "quasiquote")
							end
						end
					end
				end
				if temp110 then
					push_21_1()
					head3["range"] = struct1("start", tok3["range"]["start"], "name", tok3["range"]["name"], "lines", tok3["range"]["lines"])
					append_21_3(struct1("tag", "symbol", "contents", tag12, "range", tok3["range"]))
					autoClose1 = true
					head3["auto-close"] = true
				elseif (tag12 == "eof") then
					if (0 ~= _23_1(stack2)) then
						doNodeError_21_1(logger11, "Expected ')', got eof", tok3, nil, head3["range"], "block opened here", tok3["range"], "end of file here")
					else
					end
				else
					error1(_2e2e_2("Unsupported type", tag12))
				end
			end
			if autoClose1 then
			else
				local r_7661 = nil
				r_7661 = (function()
					if head3["auto-close"] then
						if nil_3f_1(stack2) then
							doNodeError_21_1(logger11, format1("'%s' without matching '%s'", tok3["contents"], tok3["open"]), tok3, nil, getSource1(tok3), "")
						else
						end
						head3["range"]["finish"] = tok3["range"]["finish"]
						pop_21_1()
						return r_7661()
					else
					end
				end)
				r_7661()
			end
			return r_7281((r_7291 + 1))
		else
		end
	end)
	r_7281(1)
	return head3
end)
read2 = (function(x33, path2)
	return parse1(void1, lex1(void1, x33, (function()
		if path2 then
			return path2
		else
			return ""
		end
	end)()))
end)
struct1("lex", lex1, "parse", parse1, "read", read2)
compile1 = require1("tacky.compile")["compile"]
executeStates2 = require1("tacky.compile")["executeStates"]
Scope2 = require1("tacky.analysis.scope")
doParse1 = (function(compiler6, scope3, str6)
	local logger12 = compiler6["log"]
	local lexed1 = lex1(logger12, str6, "<stdin>")
	local parsed1 = parse1(logger12, lexed1)
	return cadr1(list1(compile1(parsed1, compiler6["global"], compiler6["variables"], compiler6["states"], scope3, compiler6["compileState"], compiler6["loader"], logger12, executeStates1)))
end)
execCommand1 = (function(compiler7, scope4, args19)
	local logger13 = compiler7["log"]
	local command1 = car2(args19)
	if (command1 == nil) then
		return putError_21_1(logger13, "Expected command after ':'")
	elseif (command1 == "doc") then
		local name22 = nth1(args19, 2)
		if name22 then
			local var22 = Scope2["get"](scope4, name22)
			if (var22 == nil) then
				return putError_21_1(logger13, _2e2e_2("Cannot find '", name22, "'"))
			elseif _21_1(var22["doc"]) then
				return putError_21_1(logger13, _2e2e_2("No documentation for '", name22, "'"))
			else
				local sig3 = extractSignature1(var22)
				local name23 = var22["fullName"]
				local docs2 = parseDocstring1(var22["doc"])
				if sig3 then
					local buffer4 = list1(name23)
					local r_7721 = _23_1(sig3)
					local r_7701 = nil
					r_7701 = (function(r_7711)
						if (r_7711 <= r_7721) then
							local arg24 = sig3[r_7711]
							pushCdr_21_1(buffer4, arg24["contents"])
							return r_7701((r_7711 + 1))
						else
						end
					end)
					r_7701(1)
					name23 = _2e2e_2("(", concat1(buffer4, " "), ")")
				else
				end
				print1(colored1(96, name23))
				local r_7781 = _23_1(docs2)
				local r_7761 = nil
				r_7761 = (function(r_7771)
					if (r_7771 <= r_7781) then
						local tok4 = docs2[r_7771]
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
						return r_7761((r_7771 + 1))
					else
					end
				end)
				r_7761(1)
				return print1()
			end
		else
			return putError_21_1(logger13, ":command <variable>")
		end
	elseif (command1 == "scope") then
		local vars2 = {tag = "list", n = 0}
		local varsSet1 = ({})
		local current1 = scope4
		local r_7801 = nil
		r_7801 = (function()
			if current1 then
				iterPairs1(current1["variables"], (function(name24, var23)
					if varsSet1[name24] then
					else
						pushCdr_21_1(vars2, name24)
						varsSet1[name24] = true
						return nil
					end
				end))
				current1 = current1["parent"]
				return r_7801()
			else
			end
		end)
		r_7801()
		sort1(vars2)
		return print1(concat1(vars2, " "))
	else
		return putError_21_1(logger13, _2e2e_2("Unknown command '", command1, "'"))
	end
end)
execString1 = (function(compiler8, scope5, string1)
	local state28 = doParse1(compiler8, scope5, string1)
	if (_23_1(state28) > 0) then
		local current2 = 0
		local exec1 = create3((function()
			local r_7851 = _23_1(state28)
			local r_7831 = nil
			r_7831 = (function(r_7841)
				if (r_7841 <= r_7851) then
					local elem7 = state28[r_7841]
					current2 = elem7
					self1(current2, "get")
					return r_7831((r_7841 + 1))
				else
				end
			end)
			return r_7831(1)
		end))
		local compileState1 = compiler8["compileState"]
		local global2 = compiler8["global"]
		local logger14 = compiler8["log"]
		local run1 = true
		local r_7091 = nil
		r_7091 = (function()
			if run1 then
				local res7 = list1(resume1(exec1))
				if _21_1(car2(res7)) then
					putError_21_1(logger14, cadr1(res7))
					run1 = false
				elseif (status1(exec1) == "dead") then
					print1(colored1(96, pretty1(self1(last1(state28), "get"))))
					run1 = false
				else
					local states2 = cadr1(res7)["states"]
					executeStates2(compileState1, states2, global2, logger14)
				end
				return r_7091()
			else
			end
		end)
		return r_7091()
	else
	end
end)
repl1 = (function(compiler9)
	local scope6 = compiler9["rootScope"]
	local logger15 = compiler9["log"]
	local buffer5 = {tag = "list", n = 0}
	local running4 = true
	local r_7101 = nil
	r_7101 = (function()
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
			local temp111
			local r_7871 = _21_1(line6)
			if r_7871 then
				temp111 = nil_3f_1(buffer5)
			else
				temp111 = r_7871
			end
			if temp111 then
				running4 = false
			else
				local temp112
				if line6 then
					temp112 = (charAt1(line6, len1(line6)) == "\\")
				else
					temp112 = line6
				end
				if temp112 then
					pushCdr_21_1(buffer5, _2e2e_2(sub1(line6, 1, pred1(len1(line6))), "\n"))
				else
					local temp113
					if line6 then
						local r_7901 = (_23_1(buffer5) > 0)
						if r_7901 then
							temp113 = (len1(line6) > 0)
						else
							temp113 = r_7901
						end
					else
						temp113 = line6
					end
					if temp113 then
						pushCdr_21_1(buffer5, _2e2e_2(line6, "\n"))
					else
						local data6 = _2e2e_2(concat1(buffer5), (function()
							if line6 then
								return line6
							else
								return ""
							end
						end)())
						buffer5 = {tag = "list", n = 0}
						if (charAt1(data6, 1) == ":") then
							execCommand1(compiler9, scope6, split1(sub1(data6, 2), " "))
						else
							scope6 = Scope2["child"](scope6)
							scope6["isRoot"] = true
							local res8 = list1(pcall1(execString1, compiler9, scope6, data6))
							if car2(res8) then
							else
								putError_21_1(logger15, cadr1(res8))
							end
						end
					end
				end
			end
			return r_7101()
		else
		end
	end)
	return r_7101()
end)
task2 = struct1("name", "repl", "setup", (function(spec12)
	return addArgument_21_1(spec12, {tag = "list", n = 1, "--repl"}, "help", "Start an interactive session.")
end), "pred", (function(args20)
	return args20["repl"]
end), "run", repl1)
runLua1 = (function(compiler10, args21)
	if nil_3f_1(args21["input"]) then
		putError_21_1(compiler10["log"], "No inputs to run.")
		exit_21_1(1)
	else
	end
	local out17 = file3(compiler10, false)
	local lines7 = generateMappings1(out17["lines"])
	local logger16 = compiler10["log"]
	local name25 = _2e2e_2((function(r_8091)
		if r_8091 then
			return r_8091
		else
			return "out"
		end
	end)(args21["output"]), ".lua")
	local r_7921 = list1(load1(_2d3e_string1(out17), _2e2e_2("=", name25)))
	local temp114
	local r_7951 = list_3f_1(r_7921)
	if r_7951 then
		local r_7961 = (_23_1(r_7921) == 2)
		if r_7961 then
			local r_7971 = eq_3f_1(nth1(r_7921, 1), nil)
			if r_7971 then
				temp114 = true
			else
				temp114 = r_7971
			end
		else
			temp114 = r_7961
		end
	else
		temp114 = r_7951
	end
	if temp114 then
		local msg18 = nth1(r_7921, 2)
		putError_21_1(logger16, "Cannot load compiled source.")
		print1(msg18)
		print1(_2d3e_string1(out17))
		return exit_21_1(1)
	else
		local temp115
		local r_7981 = list_3f_1(r_7921)
		if r_7981 then
			local r_7991 = (_23_1(r_7921) == 1)
			if r_7991 then
				temp115 = true
			else
				temp115 = r_7991
			end
		else
			temp115 = r_7981
		end
		if temp115 then
			local fun3 = nth1(r_7921, 1)
			_5f_G1["arg"] = args21["script-args"]
			_5f_G1["arg"][0] = car2(args21["input"])
			local r_8001 = list1(xpcall1(fun3, traceback1))
			local temp116
			local r_8031 = list_3f_1(r_8001)
			if r_8031 then
				local r_8041 = (_23_1(r_8001) >= 1)
				if r_8041 then
					local r_8051 = eq_3f_1(nth1(r_8001, 1), true)
					if r_8051 then
						temp116 = true
					else
						temp116 = r_8051
					end
				else
					temp116 = r_8041
				end
			else
				temp116 = r_8031
			end
			if temp116 then
				local res9 = slice1(r_8001, 2)
			else
				local temp117
				local r_8061 = list_3f_1(r_8001)
				if r_8061 then
					local r_8071 = (_23_1(r_8001) == 2)
					if r_8071 then
						local r_8081 = eq_3f_1(nth1(r_8001, 1), false)
						if r_8081 then
							temp117 = true
						else
							temp117 = r_8081
						end
					else
						temp117 = r_8071
					end
				else
					temp117 = r_8061
				end
				if temp117 then
					local msg19 = nth1(r_8001, 2)
					putError_21_1(logger16, "Execution failed.")
					print1(remapTraceback1(struct1(name25, lines7), msg19))
					return exit_21_1(1)
				else
					return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_8001), ", but none matched.\n", "  Tried: `(true . ?res)`\n  Tried: `(false ?msg)`"))
				end
			end
		else
			return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_7921), ", but none matched.\n", "  Tried: `(nil ?msg)`\n  Tried: `(?fun)`"))
		end
	end
end)
task3 = struct1("name", "run", "setup", (function(spec13)
	addArgument_21_1(spec13, {tag = "list", n = 2, "--run", "-r"}, "help", "Run the compiled code")
	return addArgument_21_1(spec13, {tag = "list", n = 1, "--"}, "name", "script-args", "help", "Arguments to pass to the compiled script.", "var", "ARG", "all", true, "default", {tag = "list", n = 0}, "action", addAction1, "narg", "*")
end), "pred", (function(args22)
	return args22["run"]
end), "run", runLua1)
genNative1 = (function(compiler11, args23)
	if (_23_1(args23["input"]) ~= 1) then
		putError_21_1(compiler11["log"], "Expected just one input")
		exit_21_1(1)
	else
	end
	local prefix2 = args23["gen-native"]
	local qualifier1
	if string_3f_1(prefix2) then
		qualifier1 = _2e2e_2(prefix2, ".")
	else
		qualifier1 = ""
	end
	local lib3 = compiler11["libCache"][gsub1(last1(args23["input"]), "%.lisp$", "")]
	local maxName1 = 0
	local maxQuot1 = 0
	local maxPref1 = 0
	local natives1 = {tag = "list", n = 0}
	local r_8111 = lib3["out"]
	local r_8141 = _23_1(r_8111)
	local r_8121 = nil
	r_8121 = (function(r_8131)
		if (r_8131 <= r_8141) then
			local node46 = r_8111[r_8131]
			local temp118
			local r_8161 = list_3f_1(node46)
			if r_8161 then
				local r_8171 = symbol_3f_1(car2(node46))
				if r_8171 then
					temp118 = (car2(node46)["contents"] == "define-native")
				else
					temp118 = r_8171
				end
			else
				temp118 = r_8161
			end
			if temp118 then
				local name26 = nth1(node46, 2)["contents"]
				pushCdr_21_1(natives1, name26)
				maxName1 = max2(maxName1, len1(quoted1(name26)))
				maxQuot1 = max2(maxQuot1, len1(quoted1(_2e2e_2(qualifier1, name26))))
				maxPref1 = max2(maxPref1, len1(_2e2e_2(qualifier1, name26)))
			else
			end
			return r_8121((r_8131 + 1))
		else
		end
	end)
	r_8121(1)
	sort1(natives1)
	local handle4 = open1(_2e2e_2(lib3["path"], ".meta.lua"), "w")
	local format2 = _2e2e_2("\9[%-", tostring1((maxName1 + 3)), "s { tag = \"var\", contents = %-", tostring1((maxQuot1 + 1)), "s value = %-", tostring1((maxPref1 + 1)), "s },\n")
	if handle4 then
	else
		putError_21_1(compiler11["log"], _2e2e_2("Cannot write to ", lib3["path"], ".meta.lua"))
		exit_21_1(1)
	end
	if string_3f_1(prefix2) then
		self1(handle4, "write", format1("local %s = %s or {}\n", prefix2, prefix2))
	else
	end
	self1(handle4, "write", "return {\n")
	local r_8221 = _23_1(natives1)
	local r_8201 = nil
	r_8201 = (function(r_8211)
		if (r_8211 <= r_8221) then
			local native2 = natives1[r_8211]
			self1(handle4, "write", format1(format2, _2e2e_2(quoted1(native2), "] ="), _2e2e_2(quoted1(_2e2e_2(qualifier1, native2)), ","), _2e2e_2(qualifier1, native2, ",")))
			return r_8201((r_8211 + 1))
		else
		end
	end)
	r_8201(1)
	self1(handle4, "write", "}\n")
	return self1(handle4, "close")
end)
task4 = struct1("name", "gen-native", "setup", (function(spec14)
	return addArgument_21_1(spec14, {tag = "list", n = 1, "--gen-native"}, "help", "Generate native bindings for a file", "var", "PREFIX", "narg", "?")
end), "pred", (function(args24)
	return args24["gen-native"]
end), "run", genNative1)
scope_2f_child1 = require1("tacky.analysis.scope")["child"]
compile2 = require1("tacky.compile")["compile"]
simplifyPath1 = (function(path3, paths1)
	local current3 = path3
	local r_8281 = _23_1(paths1)
	local r_8261 = nil
	r_8261 = (function(r_8271)
		if (r_8271 <= r_8281) then
			local search1 = paths1[r_8271]
			local sub7 = match1(path3, _2e2e_2("^", gsub1(search1, "%?", "(.*)"), "$"))
			local temp119
			if sub7 then
				temp119 = (len1(sub7) < len1(current3))
			else
				temp119 = sub7
			end
			if temp119 then
				current3 = sub7
			else
			end
			return r_8261((r_8271 + 1))
		else
		end
	end)
	r_8261(1)
	return current3
end)
readMeta1 = (function(state29, name27, entry9)
	local temp120
	local r_8311
	local r_8321 = (entry9["tag"] == "expr")
	if r_8321 then
		r_8311 = r_8321
	else
		r_8311 = (entry9["tag"] == "stmt")
	end
	if r_8311 then
		temp120 = string_3f_1(entry9["contents"])
	else
		temp120 = r_8311
	end
	if temp120 then
		local buffer6 = {tag = "list", n = 0}
		local str7 = entry9["contents"]
		local idx4 = 0
		local len8 = len1(str7)
		local r_8331 = nil
		r_8331 = (function()
			if (idx4 <= len8) then
				local r_8341 = list1(find1(str7, "%${(%d+)}", idx4))
				local temp121
				local r_8361 = list_3f_1(r_8341)
				if r_8361 then
					local r_8371 = (_23_1(r_8341) >= 2)
					if r_8371 then
						temp121 = true
					else
						temp121 = r_8371
					end
				else
					temp121 = r_8361
				end
				if temp121 then
					local start21 = nth1(r_8341, 1)
					local finish7 = nth1(r_8341, 2)
					if (start21 > idx4) then
						pushCdr_21_1(buffer6, sub1(str7, idx4, pred1(start21)))
					else
					end
					pushCdr_21_1(buffer6, tonumber1(sub1(str7, (start21 + 2), (finish7 - 1))))
					idx4 = succ1(finish7)
				else
					pushCdr_21_1(buffer6, sub1(str7, idx4, len8))
					idx4 = succ1(len8)
				end
				return r_8331()
			else
			end
		end)
		r_8331()
		entry9["contents"] = buffer6
	else
	end
	if (entry9["value"] == nil) then
		entry9["value"] = state29["libEnv"][name27]
	elseif (state29["libEnv"][name27] ~= nil) then
		fail_21_1(_2e2e_2("Duplicate value for ", name27, ": in native and meta file"))
	else
		state29["libEnv"][name27] = entry9["value"]
	end
	state29["libMeta"][name27] = entry9
	return entry9
end)
readLibrary1 = (function(state30, name28, path4, lispHandle1)
	putVerbose_21_1(state30["log"], _2e2e_2("Loading ", path4, " into ", name28))
	local prefix3 = _2e2e_2(name28, "-", _23_1(state30["libs"]), "/")
	local lib4 = struct1("name", name28, "prefix", prefix3, "path", path4)
	local contents3 = self1(lispHandle1, "read", "*a")
	self1(lispHandle1, "close")
	local handle5 = open1(_2e2e_2(path4, ".lua"), "r")
	if handle5 then
		local contents4 = self1(handle5, "read", "*a")
		self1(handle5, "close")
		lib4["native"] = contents4
		local r_8401 = list1(load1(contents4, _2e2e_2("@", name28)))
		local temp122
		local r_8431 = list_3f_1(r_8401)
		if r_8431 then
			local r_8441 = (_23_1(r_8401) == 2)
			if r_8441 then
				local r_8451 = eq_3f_1(nth1(r_8401, 1), nil)
				if r_8451 then
					temp122 = true
				else
					temp122 = r_8451
				end
			else
				temp122 = r_8441
			end
		else
			temp122 = r_8431
		end
		if temp122 then
			local msg20 = nth1(r_8401, 2)
			fail_21_1(msg20)
		else
			local temp123
			local r_8461 = list_3f_1(r_8401)
			if r_8461 then
				local r_8471 = (_23_1(r_8401) == 1)
				if r_8471 then
					temp123 = true
				else
					temp123 = r_8471
				end
			else
				temp123 = r_8461
			end
			if temp123 then
				local fun4 = nth1(r_8401, 1)
				local res10 = fun4()
				if table_3f_1(res10) then
					iterPairs1(res10, (function(k1, v2)
						state30["libEnv"][_2e2e_2(prefix3, k1)] = v2
						return nil
					end))
				else
					fail_21_1(_2e2e_2(path4, ".lua returned a non-table value"))
				end
			else
				error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_8401), ", but none matched.\n", "  Tried: `(nil ?msg)`\n  Tried: `(?fun)`"))
			end
		end
	else
	end
	local handle6 = open1(_2e2e_2(path4, ".meta.lua"), "r")
	if handle6 then
		local contents5 = self1(handle6, "read", "*a")
		self1(handle6, "close")
		local r_8481 = list1(load1(contents5, _2e2e_2("@", name28)))
		local temp124
		local r_8511 = list_3f_1(r_8481)
		if r_8511 then
			local r_8521 = (_23_1(r_8481) == 2)
			if r_8521 then
				local r_8531 = eq_3f_1(nth1(r_8481, 1), nil)
				if r_8531 then
					temp124 = true
				else
					temp124 = r_8531
				end
			else
				temp124 = r_8521
			end
		else
			temp124 = r_8511
		end
		if temp124 then
			local msg21 = nth1(r_8481, 2)
			fail_21_1(msg21)
		else
			local temp125
			local r_8541 = list_3f_1(r_8481)
			if r_8541 then
				local r_8551 = (_23_1(r_8481) == 1)
				if r_8551 then
					temp125 = true
				else
					temp125 = r_8551
				end
			else
				temp125 = r_8541
			end
			if temp125 then
				local fun5 = nth1(r_8481, 1)
				local res11 = fun5()
				if table_3f_1(res11) then
					iterPairs1(res11, (function(k2, v3)
						return readMeta1(state30, _2e2e_2(prefix3, k2), v3)
					end))
				else
					fail_21_1(_2e2e_2(path4, ".meta.lua returned a non-table value"))
				end
			else
				error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_8481), ", but none matched.\n", "  Tried: `(nil ?msg)`\n  Tried: `(?fun)`"))
			end
		end
	else
	end
	local lexed2 = lex1(state30["log"], contents3, _2e2e_2(path4, ".lisp"))
	local parsed2 = parse1(state30["log"], lexed2)
	local scope7 = scope_2f_child1(state30["rootScope"])
	scope7["isRoot"] = true
	scope7["prefix"] = prefix3
	lib4["scope"] = scope7
	local compiled1 = compile2(parsed2, state30["global"], state30["variables"], state30["states"], scope7, state30["compileState"], state30["loader"], state30["log"], executeStates1)
	pushCdr_21_1(state30["libs"], lib4)
	if string_3f_1(car2(compiled1)) then
		lib4["docs"] = constVal1(car2(compiled1))
		removeNth_21_1(compiled1, 1)
	else
	end
	lib4["out"] = compiled1
	local r_8601 = _23_1(compiled1)
	local r_8581 = nil
	r_8581 = (function(r_8591)
		if (r_8591 <= r_8601) then
			local node47 = compiled1[r_8591]
			pushCdr_21_1(state30["out"], node47)
			return r_8581((r_8591 + 1))
		else
		end
	end)
	r_8581(1)
	putVerbose_21_1(state30["log"], _2e2e_2("Loaded ", path4, " into ", name28))
	return lib4
end)
pathLocator1 = (function(state31, name29)
	local searched1
	local paths2
	local searcher1
	searched1 = {tag = "list", n = 0}
	paths2 = state31["paths"]
	searcher1 = (function(i7)
		if (i7 > _23_1(paths2)) then
			return list1(nil, _2e2e_2("Cannot find ", quoted1(name29), ".\nLooked in ", concat1(searched1, ", ")))
		else
			local path5 = gsub1(nth1(paths2, i7), "%?", name29)
			local cached1 = state31["libCache"][path5]
			pushCdr_21_1(searched1, path5)
			if (cached1 == nil) then
				local handle7 = open1(_2e2e_2(path5, ".lisp"), "r")
				if handle7 then
					state31["libCache"][path5] = true
					local lib5 = readLibrary1(state31, simplifyPath1(path5, paths2), path5, handle7)
					state31["libCache"][path5] = lib5
					return list1(lib5)
				else
					return searcher1((i7 + 1))
				end
			elseif (cached1 == true) then
				return list1(nil, _2e2e_2("Already loading ", name29))
			else
				return list1(cached1)
			end
		end
	end)
	return searcher1(1)
end)
loader1 = (function(state32, name30, shouldResolve1)
	if shouldResolve1 then
		return pathLocator1(state32, name30)
	else
		name30 = gsub1(name30, "%.lisp$", "")
		local r_8621 = state32["libCache"][name30]
		if eq_3f_1(r_8621, nil) then
			local handle8 = open1(_2e2e_2(name30, ".lisp"))
			if handle8 then
				state32["libCache"][name30] = true
				local lib6 = readLibrary1(state32, simplifyPath1(name30, state32["paths"]), name30, handle8)
				state32["libCache"][name30] = lib6
				return list1(lib6)
			else
				return list1(nil, _2e2e_2("Cannot find ", quoted1(name30)))
			end
		elseif eq_3f_1(r_8621, true) then
			return list1(nil, _2e2e_2("Already loading ", name30))
		else
			return list1(r_8621)
		end
	end
end)
printError_21_1 = (function(msg22)
	if string_3f_1(msg22) then
	else
		msg22 = pretty1(msg22)
	end
	local lines8 = split1(msg22, "\n", 1)
	print1(colored1(31, _2e2e_2("[ERROR] ", car2(lines8))))
	if cadr1(lines8) then
		return print1(cadr1(lines8))
	else
	end
end)
printWarning_21_1 = (function(msg23)
	local lines9 = split1(msg23, "\n", 1)
	print1(colored1(33, _2e2e_2("[WARN] ", car2(lines9))))
	if cadr1(lines9) then
		return print1(cadr1(lines9))
	else
	end
end)
printVerbose_21_1 = (function(verbosity1, msg24)
	if (verbosity1 > 0) then
		return print1(_2e2e_2("[VERBOSE] ", msg24))
	else
	end
end)
printDebug_21_1 = (function(verbosity2, msg25)
	if (verbosity2 > 1) then
		return print1(_2e2e_2("[DEBUG] ", msg25))
	else
	end
end)
printExplain_21_1 = (function(explain4, lines10)
	if explain4 then
		local r_8661 = split1(lines10, "\n")
		local r_8691 = _23_1(r_8661)
		local r_8671 = nil
		r_8671 = (function(r_8681)
			if (r_8681 <= r_8691) then
				local line7 = r_8661[r_8681]
				print1(_2e2e_2("  ", line7))
				return r_8671((r_8681 + 1))
			else
			end
		end)
		return r_8671(1)
	else
	end
end)
create4 = (function(verbosity3, explain5)
	return struct1("verbosity", (function()
		if verbosity3 then
			return verbosity3
		else
			return 0
		end
	end)(), "explain", (explain5 == true), "put-error!", putError_21_2, "put-warning!", putWarning_21_2, "put-verbose!", putVerbose_21_2, "put-debug!", putDebug_21_2, "put-node-error!", putNodeError_21_2, "put-node-warning!", putNodeWarning_21_2)
end)
putError_21_2 = (function(messenger1, msg26)
	return printError_21_1(msg26)
end)
putWarning_21_2 = (function(messenger2, msg27)
	return printWarning_21_1(msg27)
end)
putVerbose_21_2 = (function(messenger3, msg28)
	return printVerbose_21_1(messenger3["verbosity"], msg28)
end)
putDebug_21_2 = (function(messenger4, msg29)
	return printDebug_21_1(messenger4["verbosity"], msg29)
end)
putNodeError_21_2 = (function(logger17, msg30, node48, explain6, lines11)
	printError_21_1(msg30)
	putTrace_21_1(node48)
	if explain6 then
		printExplain_21_1(logger17["explain"], explain6)
	else
	end
	return putLines_21_1(true, lines11)
end)
putNodeWarning_21_2 = (function(logger18, msg31, node49, explain7, lines12)
	printWarning_21_1(msg31)
	putTrace_21_1(node49)
	if explain7 then
		printExplain_21_1(logger18["explain"], explain7)
	else
	end
	return putLines_21_1(true, lines12)
end)
putLines_21_1 = (function(range7, entries1)
	if nil_3f_1(entries1) then
		error1("Positions cannot be empty")
	else
	end
	if ((_23_1(entries1) % 2) ~= 0) then
		error1(_2e2e_2("Positions must be a multiple of 2, is ", _23_1(entries1)))
	else
	end
	local previous3 = -1
	local file4 = nth1(entries1, 1)["name"]
	local maxLine1 = foldr1((function(max6, node50)
		if string_3f_1(node50) then
			return max6
		else
			return max2(max6, node50["start"]["line"])
		end
	end), 0, entries1)
	local code3 = _2e2e_2(colored1(92, _2e2e_2(" %", len1(tostring1(maxLine1)), "s |")), " %s")
	local r_8731 = _23_1(entries1)
	local r_8711 = nil
	r_8711 = (function(r_8721)
		if (r_8721 <= r_8731) then
			local position2 = entries1[r_8721]
			local message1 = entries1[succ1(r_8721)]
			if (file4 ~= position2["name"]) then
				file4 = position2["name"]
				print1(colored1(95, _2e2e_2(" ", file4)))
			else
				local temp126
				local r_8751 = (previous3 ~= -1)
				if r_8751 then
					temp126 = (abs1((position2["start"]["line"] - previous3)) > 2)
				else
					temp126 = r_8751
				end
				if temp126 then
					print1(colored1(92, " ..."))
				else
				end
			end
			previous3 = position2["start"]["line"]
			print1(format1(code3, tostring1(position2["start"]["line"]), position2["lines"][position2["start"]["line"]]))
			local pointer1
			if _21_1(range7) then
				pointer1 = "^"
			else
				local temp127
				local r_8761 = position2["finish"]
				if r_8761 then
					temp127 = (position2["start"]["line"] == position2["finish"]["line"])
				else
					temp127 = r_8761
				end
				if temp127 then
					pointer1 = rep1("^", succ1((position2["finish"]["column"] - position2["start"]["column"])))
				else
					pointer1 = "^..."
				end
			end
			print1(format1(code3, "", _2e2e_2(rep1(" ", (position2["start"]["column"] - 1)), pointer1, " ", message1)))
			return r_8711((r_8721 + 2))
		else
		end
	end)
	return r_8711(1)
end)
putTrace_21_1 = (function(node51)
	local previous4 = nil
	local r_8641 = nil
	r_8641 = (function()
		if node51 then
			local formatted1 = formatNode1(node51)
			if (previous4 == nil) then
				print1(colored1(96, _2e2e_2("  => ", formatted1)))
			elseif (previous4 ~= formatted1) then
				print1(_2e2e_2("  in ", formatted1))
			else
			end
			previous4 = formatted1
			node51 = node51["parent"]
			return r_8641()
		else
		end
	end)
	return r_8641()
end)
rootScope1 = require1("tacky.analysis.resolve")["rootScope"]
scope_2f_child2 = require1("tacky.analysis.scope")["child"]
scope_2f_import_21_1 = require1("tacky.analysis.scope")["import"]
local spec15 = create1()
local directory1
local dir1 = nth1(arg1, 0)
dir1 = gsub1(dir1, "urn/cli%.lisp$", "")
dir1 = gsub1(dir1, "urn/cli$", "")
dir1 = gsub1(dir1, "tacky/cli%.lua$", "")
local temp128
local r_9261 = (dir1 ~= "")
if r_9261 then
	temp128 = (charAt1(dir1, -1) ~= "/")
else
	temp128 = r_9261
end
if temp128 then
	dir1 = _2e2e_2(dir1, "/")
else
end
local r_9271 = nil
r_9271 = (function()
	if (sub1(dir1, 1, 2) == "./") then
		dir1 = sub1(dir1, 3)
		return r_9271()
	else
	end
end)
r_9271()
directory1 = dir1
local paths3 = list1("?", "?/init", _2e2e_2(directory1, "lib/?"), _2e2e_2(directory1, "lib/?/init"))
local tasks1 = list1(warning1, optimise2, emitLisp1, emitLua1, task1, task4, task3, task2)
addHelp_21_1(spec15)
addArgument_21_1(spec15, {tag = "list", n = 2, "--explain", "-e"}, "help", "Explain error messages in more detail.")
addArgument_21_1(spec15, {tag = "list", n = 2, "--time", "-t"}, "help", "Time how long each task takes to execute.")
addArgument_21_1(spec15, {tag = "list", n = 2, "--verbose", "-v"}, "help", "Make the output more verbose. Can be used multiple times", "many", true, "default", 0, "action", (function(arg25, data7)
	data7[arg25["name"]] = succ1((function(r_8771)
		if r_8771 then
			return r_8771
		else
			return 0
		end
	end)(data7[arg25["name"]]))
	return nil
end))
addArgument_21_1(spec15, {tag = "list", n = 2, "--include", "-i"}, "help", "Add an additional argument to the include path.", "many", true, "narg", 1, "default", {tag = "list", n = 0}, "action", addAction1)
addArgument_21_1(spec15, {tag = "list", n = 2, "--prelude", "-p"}, "help", "A custom prelude path to use.", "narg", 1, "default", _2e2e_2(directory1, "lib/prelude"))
addArgument_21_1(spec15, {tag = "list", n = 3, "--output", "--out", "-o"}, "help", "The destination to output to.", "narg", 1, "default", "out")
addArgument_21_1(spec15, {tag = "list", n = 2, "--wrapper", "-w"}, "help", "A wrapper script to launch Urn with", "narg", 1, "action", (function(a4, b4, value9)
	local args25 = map1(id1, arg1)
	local i8 = 1
	local len9 = _23_1(args25)
	local r_8781 = nil
	r_8781 = (function()
		if (i8 <= len9) then
			local item2 = nth1(args25, i8)
			local temp129
			local r_8791 = (item2 == "--wrapper")
			if r_8791 then
				temp129 = r_8791
			else
				temp129 = (item2 == "-w")
			end
			if temp129 then
				removeNth_21_1(args25, i8)
				removeNth_21_1(args25, i8)
				i8 = succ1(len9)
			elseif find1(item2, "^%-%-wrapper=.*$") then
				removeNth_21_1(args25, i8)
				i8 = succ1(len9)
			elseif find1(item2, "^%-[^-]+w$") then
				args25[i8] = sub1(item2, 1, -2)
				removeNth_21_1(args25, succ1(i8))
				i8 = succ1(len9)
			else
			end
			return r_8781()
		else
		end
	end)
	r_8781()
	local command2 = list1(value9)
	local interp1 = nth1(arg1, -1)
	if interp1 then
		pushCdr_21_1(command2, interp1)
	else
	end
	pushCdr_21_1(command2, nth1(arg1, 0))
	local r_8801 = list1(execute1(concat1(append1(command2, args25), " ")))
	local temp130
	local r_8821 = list_3f_1(r_8801)
	if r_8821 then
		local r_8831 = (_23_1(r_8801) == 3)
		if r_8831 then
			temp130 = true
		else
			temp130 = r_8831
		end
	else
		temp130 = r_8821
	end
	if temp130 then
		local code4 = nth1(r_8801, 3)
		return exit1(code4)
	else
		return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_8801), ", but none matched.\n", "  Tried: `(_ _ ?code)`"))
	end
end))
addArgument_21_1(spec15, {tag = "list", n = 1, "input"}, "help", "The file(s) to load.", "var", "FILE", "narg", "*")
local r_8901 = _23_1(tasks1)
local r_8881 = nil
r_8881 = (function(r_8891)
	if (r_8891 <= r_8901) then
		local task5 = tasks1[r_8891]
		task5["setup"](spec15)
		return r_8881((r_8891 + 1))
	else
	end
end)
r_8881(1)
local args26 = parse_21_1(spec15)
local logger19 = create4(args26["verbose"], args26["explain"])
local r_8931 = args26["include"]
local r_8961 = _23_1(r_8931)
local r_8941 = nil
r_8941 = (function(r_8951)
	if (r_8951 <= r_8961) then
		local path6 = r_8931[r_8951]
		path6 = gsub1(path6, "\\", "/")
		path6 = gsub1(path6, "^%./", "")
		if find1(path6, "%?") then
		else
			path6 = _2e2e_2(path6, (function()
				if (charAt1(path6, -1) == "/") then
					return "?"
				else
					return "/?"
				end
			end)()
			)
		end
		pushCdr_21_1(paths3, path6)
		return r_8941((r_8951 + 1))
	else
	end
end)
r_8941(1)
putVerbose_21_1(logger19, _2e2e_2("Using path: ", pretty1(paths3)))
if nil_3f_1(args26["input"]) then
	args26["repl"] = true
else
	args26["emit-lua"] = true
end
local compiler12 = struct1("log", logger19, "paths", paths3, "libEnv", ({}), "libMeta", ({}), "libs", {tag = "list", n = 0}, "libCache", ({}), "rootScope", rootScope1, "variables", ({}), "states", ({}), "out", {tag = "list", n = 0})
compiler12["compileState"] = createState2(compiler12["libMeta"])
compiler12["loader"] = (function(name31)
	return loader1(compiler12, name31, true)
end)
compiler12["global"] = setmetatable1(struct1("_libs", compiler12["libEnv"]), struct1("__index", _5f_G1))
iterPairs1(compiler12["rootScope"]["variables"], (function(_5f_2, var24)
	compiler12["variables"][tostring1(var24)] = var24
	return nil
end))
local start22 = clock1()
local r_8981 = loader1(compiler12, args26["prelude"], false)
local temp131
local r_9011 = list_3f_1(r_8981)
if r_9011 then
	local r_9021 = (_23_1(r_8981) == 2)
	if r_9021 then
		local r_9031 = eq_3f_1(nth1(r_8981, 1), nil)
		if r_9031 then
			temp131 = true
		else
			temp131 = r_9031
		end
	else
		temp131 = r_9021
	end
else
	temp131 = r_9011
end
if temp131 then
	local errorMessage1 = nth1(r_8981, 2)
	putError_21_1(logger19, errorMessage1)
	exit_21_1(1)
else
	local temp132
	local r_9041 = list_3f_1(r_8981)
	if r_9041 then
		local r_9051 = (_23_1(r_8981) == 1)
		if r_9051 then
			temp132 = true
		else
			temp132 = r_9051
		end
	else
		temp132 = r_9041
	end
	if temp132 then
		local lib7 = nth1(r_8981, 1)
		compiler12["rootScope"] = scope_2f_child2(compiler12["rootScope"])
		iterPairs1(lib7["scope"]["exported"], (function(name32, var25)
			return scope_2f_import_21_1(compiler12["rootScope"], name32, var25)
		end))
		local r_9071 = args26["input"]
		local r_9101 = _23_1(r_9071)
		local r_9081 = nil
		r_9081 = (function(r_9091)
			if (r_9091 <= r_9101) then
				local input1 = r_9071[r_9091]
				local r_9121 = loader1(compiler12, input1, false)
				local temp133
				local r_9151 = list_3f_1(r_9121)
				if r_9151 then
					local r_9161 = (_23_1(r_9121) == 2)
					if r_9161 then
						local r_9171 = eq_3f_1(nth1(r_9121, 1), nil)
						if r_9171 then
							temp133 = true
						else
							temp133 = r_9171
						end
					else
						temp133 = r_9161
					end
				else
					temp133 = r_9151
				end
				if temp133 then
					local errorMessage2 = nth1(r_9121, 2)
					putError_21_1(logger19, errorMessage2)
					exit_21_1(1)
				else
					local temp134
					local r_9181 = list_3f_1(r_9121)
					if r_9181 then
						local r_9191 = (_23_1(r_9121) == 1)
						if r_9191 then
							temp134 = true
						else
							temp134 = r_9191
						end
					else
						temp134 = r_9181
					end
					if temp134 then
					else
						error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_9121), ", but none matched.\n", "  Tried: `(nil ?error-message)`\n  Tried: `(_)`"))
					end
				end
				return r_9081((r_9091 + 1))
			else
			end
		end)
		r_9081(1)
	else
		error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_8981), ", but none matched.\n", "  Tried: `(nil ?error-message)`\n  Tried: `(?lib)`"))
	end
end
if args26["time"] then
	print1(_2e2e_2("parsing took ", (clock1() - start22)))
else
end
local r_9241 = _23_1(tasks1)
local r_9221 = nil
r_9221 = (function(r_9231)
	if (r_9231 <= r_9241) then
		local task6 = tasks1[r_9231]
		if task6["pred"](args26) then
			local start23 = clock1()
			task6["run"](compiler12, args26)
			if args26["time"] then
				print1(_2e2e_2(task6["name"], " took ", (clock1() - start23)))
			else
			end
		else
		end
		return r_9221((r_9231 + 1))
	else
	end
end)
return r_9221(1)
