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
	return not expr1
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
			local out1 = ({tag = "list", n = 0})
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
boolean_3f_1 = (function(x9)
	return (type1(x9) == "boolean")
end)
function_3f_1 = (function(x10)
	return (type1(x10) == "function")
end)
key_3f_1 = (function(x11)
	return (type1(x11) == "key")
end)
atom_3f_1 = (function(x12)
	local r_171 = boolean_3f_1(x12)
	if r_171 then
		return r_171
	else
		local r_181 = string_3f_1(x12)
		if r_181 then
			return r_181
		else
			local r_191 = number_3f_1(x12)
			if r_191 then
				return r_191
			else
				local r_201 = symbol_3f_1(x12)
				if r_201 then
					return r_201
				else
					local r_211 = function_3f_1(x12)
					if r_211 then
						return r_211
					else
						return key_3f_1(x12)
					end
				end
			end
		end
	end
end)
exists_3f_1 = (function(x13)
	return _21_1((type1(x13) == "nil"))
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
eq_3f_1 = (function(x14, y1)
	local temp2
	local r_231 = exists_3f_1(x14)
	if r_231 then
		temp2 = exists_3f_1(y1)
	else
		temp2 = r_231
	end
	if temp2 then
		local temp3
		local r_241 = symbol_3f_1(x14)
		if r_241 then
			temp3 = symbol_3f_1(y1)
		else
			temp3 = r_241
		end
		if temp3 then
			return (x14["contents"] == y1["contents"])
		else
			local temp4
			local r_251 = symbol_3f_1(x14)
			if r_251 then
				temp4 = string_3f_1(y1)
			else
				temp4 = r_251
			end
			if temp4 then
				return (x14["contents"] == y1)
			else
				local temp5
				local r_261 = string_3f_1(x14)
				if r_261 then
					temp5 = symbol_3f_1(y1)
				else
					temp5 = r_261
				end
				if temp5 then
					return (y1["contents"] == x14)
				else
					local temp6
					local r_271 = key_3f_1(x14)
					if r_271 then
						temp6 = key_3f_1(y1)
					else
						temp6 = r_271
					end
					if temp6 then
						return (x14["value"] == y1["value"])
					else
						local temp7
						local r_281 = key_3f_1(x14)
						if r_281 then
							temp7 = string_3f_1(y1)
						else
							temp7 = r_281
						end
						if temp7 then
							return (x14["value"] == y1)
						else
							local temp8
							local r_291 = string_3f_1(x14)
							if r_291 then
								temp8 = key_3f_1(y1)
							else
								temp8 = r_291
							end
							if temp8 then
								return (y1["value"] == x14)
							else
								local temp9
								local r_301 = nil_3f_1(x14)
								if r_301 then
									temp9 = nil_3f_1(y1)
								else
									temp9 = r_301
								end
								if temp9 then
									return true
								else
									local temp10
									local r_311 = list_3f_1(x14)
									if r_311 then
										temp10 = list_3f_1(y1)
									else
										temp10 = r_311
									end
									if temp10 then
										local r_321 = eq_3f_1(car1(x14), car1(y1))
										if r_321 then
											return eq_3f_1(cdr1(x14), cdr1(y1))
										else
											return r_321
										end
									else
										return (x14 == y1)
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
		local r_331 = exists_3f_1(x14)
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
				temp12 = _21_1(exists_3f_1(x14))
			else
				temp12 = r_341
			end
			if temp12 then
				return false
			else
				local r_351 = _21_1(x14)
				if r_351 then
					return _21_1(y1)
				else
					return r_351
				end
			end
		end
	end
end)
car2 = (function(x15)
	local r_361 = type1(x15)
	if (r_361 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_361), 2)
	else
	end
	return car1(x15)
end)
cdr2 = (function(x16)
	local r_371 = type1(x16)
	if (r_371 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_371), 2)
	else
	end
	if nil_3f_1(x16) then
		return ({tag = "list", n = 0})
	else
		return cdr1(x16)
	end
end)
take1 = (function(xs5, n1)
	return slice1(xs5, 1, n1)
end)
foldr1 = (function(f1, z1, xs6)
	local r_381 = type1(f1)
	if (r_381 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "f", "function", r_381), 2)
	else
	end
	local r_511 = type1(xs6)
	if (r_511 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_511), 2)
	else
	end
	local accum1 = z1
	local r_541 = _23_1(xs6)
	local r_521 = nil
	r_521 = (function(r_531)
		if (r_531 <= r_541) then
			accum1 = f1(accum1, nth1(xs6, r_531))
			return r_521((r_531 + 1))
		else
		end
	end)
	r_521(1)
	return accum1
end)
map1 = (function(f2, xs7, acc1)
	local r_391 = type1(f2)
	if (r_391 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "f", "function", r_391), 2)
	else
	end
	local r_561 = type1(xs7)
	if (r_561 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_561), 2)
	else
	end
	if _21_1(exists_3f_1(acc1)) then
		return map1(f2, xs7, ({tag = "list", n = 0}))
	elseif nil_3f_1(xs7) then
		return reverse1(acc1)
	else
		return map1(f2, cdr2(xs7), cons1(f2(car2(xs7)), acc1))
	end
end)
any1 = (function(p1, xs8)
	local r_411 = type1(p1)
	if (r_411 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "p", "function", r_411), 2)
	else
	end
	local r_581 = type1(xs8)
	if (r_581 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_581), 2)
	else
	end
	return accumulateWith1(p1, _2d_or1, false, xs8)
end)
all1 = (function(p2, xs9)
	local r_421 = type1(p2)
	if (r_421 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "p", "function", r_421), 2)
	else
	end
	local r_591 = type1(xs9)
	if (r_591 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_591), 2)
	else
	end
	return accumulateWith1(p2, _2d_and1, true, xs9)
end)
traverse1 = (function(xs10, f3)
	return map1(f3, xs10)
end)
last1 = (function(xs11)
	local r_451 = type1(xs11)
	if (r_451 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_451), 2)
	else
	end
	return xs11[_23_1(xs11)]
end)
nth1 = (function(xs12, idx1)
	return xs12[idx1]
end)
pushCdr_21_1 = (function(xs13, val4)
	local r_461 = type1(xs13)
	if (r_461 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_461), 2)
	else
	end
	local len2 = (_23_1(xs13) + 1)
	xs13["n"] = len2
	xs13[len2] = val4
	return xs13
end)
popLast_21_1 = (function(xs14)
	local r_471 = type1(xs14)
	if (r_471 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_471), 2)
	else
	end
	local x17 = xs14[_23_1(xs14)]
	xs14[_23_1(xs14)] = nil
	xs14["n"] = (_23_1(xs14) - 1)
	return x17
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
append1 = (function(xs15, ys1)
	if nil_3f_1(xs15) then
		return ys1
	else
		return cons1(car2(xs15), append1(cdr2(xs15), ys1))
	end
end)
reverse1 = (function(xs16, acc2)
	if _21_1(exists_3f_1(acc2)) then
		return reverse1(xs16, ({tag = "list", n = 0}))
	elseif nil_3f_1(xs16) then
		return acc2
	else
		return reverse1(cdr2(xs16), cons1(car2(xs16), acc2))
	end
end)
accumulateWith1 = (function(f4, ac1, z2, xs17)
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
	return foldr1(ac1, z2, map1(f4, xs17))
end)
caar1 = (function(x18)
	return car2(car2(x18))
end)
cadr1 = (function(x19)
	return car2(cdr2(x19))
end)
charAt1 = (function(xs18, x20)
	return sub1(xs18, x20, x20)
end)
_2e2e_2 = (function(...)
	local args1 = _pack(...) args1.tag = "list"
	return concat1(args1)
end)
split1 = (function(text1, pattern1, limit1)
	local out2 = ({tag = "list", n = 0})
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
values1 = (function(st2)
	local out4 = ({tag = "list", n = 0})
	iterPairs1(st2, (function(_5f_1, v1)
		return pushCdr_21_1(out4, v1)
	end))
	return out4
end)
flush1 = io.flush
open1 = io.open
read1 = io.read
write1 = io.write
abs1 = math.abs
huge1 = math.huge
max2 = math.max
modf1 = math.modf
succ1 = (function(x21)
	return (x21 + 1)
end)
pred1 = (function(x22)
	return (x22 - 1)
end)
symbol_2d3e_string1 = (function(x23)
	if symbol_3f_1(x23) then
		return x23["contents"]
	else
		return nil
	end
end)
fail_21_1 = (function(x24)
	return error1(x24, 0)
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
id1 = (function(x25)
	return x25
end)
self1 = (function(x26, key3, ...)
	local args2 = _pack(...) args2.tag = "list"
	return x26[key3](x26, unpack1(args2, 1, _23_1(args2)))
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
		result2["default"] = ({tag = "list", n = 0})
		pushCdr_21_1(spec1["pos"], result2)
	end
	local r_1651 = _23_1(names1)
	local r_1631 = nil
	r_1631 = (function(r_1641)
		if (r_1641 <= r_1651) then
			local name1 = names1[r_1641]
			if (sub1(name1, 1, 2) == "--") then
				spec1["opt-map"][sub1(name1, 3)] = result2
			elseif (sub1(name1, 1, 1) == "-") then
				spec1["flag-map"][sub1(name1, 2)] = result2
			else
			end
			return r_1631((r_1641 + 1))
		else
		end
	end)
	r_1631(1)
	local r_1691 = _23_1(options1)
	local r_1671 = nil
	r_1671 = (function(r_1681)
		if (r_1681 <= r_1691) then
			local key4 = nth1(options1, r_1681)
			local val7 = nth1(options1, (r_1681 + 1))
			result2[key4] = val7
			return r_1671((r_1681 + 2))
		else
		end
	end)
	r_1671(1)
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
	return addArgument_21_1(spec2, ({tag = "list", n = 2, "--help", "-h"}), "help", "Show this help message", "default", nil, "value", nil, "action", (function(arg4, result3, value5)
		help_21_1(spec2)
		return exit_21_1(0)
	end))
end)
helpNarg_21_1 = (function(buffer1, arg5)
	local r_2121 = arg5["narg"]
	if eq_3f_1(r_2121, "?") then
		return pushCdr_21_1(buffer1, _2e2e_2(" [", arg5["var"], "]"))
	elseif eq_3f_1(r_2121, "*") then
		return pushCdr_21_1(buffer1, _2e2e_2(" [", arg5["var"], "...]"))
	elseif eq_3f_1(r_2121, "+") then
		return pushCdr_21_1(buffer1, _2e2e_2(" ", arg5["var"], " [", arg5["var"], "...]"))
	else
		local r_2131 = nil
		r_2131 = (function(r_2141)
			if (r_2141 <= r_2121) then
				pushCdr_21_1(buffer1, _2e2e_2(" ", arg5["var"]))
				return r_2131((r_2141 + 1))
			else
			end
		end)
		return r_2131(1)
	end
end)
usage_21_2 = (function(spec3, name2)
	if name2 then
	else
		local r_1711 = nth1(arg1, 0)
		if r_1711 then
			name2 = r_1711
		else
			local r_1721 = nth1(arg1, -1)
			if r_1721 then
				name2 = r_1721
			else
				name2 = "?"
			end
		end
	end
	local usage1 = list1("usage: ", name2)
	local r_1741 = spec3["opt"]
	local r_1771 = _23_1(r_1741)
	local r_1751 = nil
	r_1751 = (function(r_1761)
		if (r_1761 <= r_1771) then
			local arg6 = r_1741[r_1761]
			pushCdr_21_1(usage1, _2e2e_2(" [", car2(arg6["names"])))
			helpNarg_21_1(usage1, arg6)
			pushCdr_21_1(usage1, "]")
			return r_1751((r_1761 + 1))
		else
		end
	end)
	r_1751(1)
	local r_1801 = spec3["pos"]
	local r_1831 = _23_1(r_1801)
	local r_1811 = nil
	r_1811 = (function(r_1821)
		if (r_1821 <= r_1831) then
			local arg7 = r_1801[r_1821]
			helpNarg_21_1(usage1, arg7)
			return r_1811((r_1821 + 1))
		else
		end
	end)
	r_1811(1)
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
		local r_1851 = nth1(arg1, 0)
		if r_1851 then
			name4 = r_1851
		else
			local r_1861 = nth1(arg1, -1)
			if r_1861 then
				name4 = r_1861
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
	local r_1881 = spec5["pos"]
	local r_1911 = _23_1(r_1881)
	local r_1891 = nil
	r_1891 = (function(r_1901)
		if (r_1901 <= r_1911) then
			local arg8 = r_1881[r_1901]
			local len3 = len1(arg8["var"])
			if (len3 > max3) then
				max3 = len3
			else
			end
			return r_1891((r_1901 + 1))
		else
		end
	end)
	r_1891(1)
	local r_1941 = spec5["opt"]
	local r_1971 = _23_1(r_1941)
	local r_1951 = nil
	r_1951 = (function(r_1961)
		if (r_1961 <= r_1971) then
			local arg9 = r_1941[r_1961]
			local len4 = len1(concat1(arg9["names"], ", "))
			if (len4 > max3) then
				max3 = len4
			else
			end
			return r_1951((r_1961 + 1))
		else
		end
	end)
	r_1951(1)
	local fmt1 = _2e2e_2(" %-", tostring1((max3 + 1)), "s %s")
	if nil_3f_1(spec5["pos"]) then
	else
		print1()
		print1("Positional arguments")
		local r_2001 = spec5["pos"]
		local r_2031 = _23_1(r_2001)
		local r_2011 = nil
		r_2011 = (function(r_2021)
			if (r_2021 <= r_2031) then
				local arg10 = r_2001[r_2021]
				print1(format1(fmt1, arg10["var"], arg10["help"]))
				return r_2011((r_2021 + 1))
			else
			end
		end)
		r_2011(1)
	end
	if nil_3f_1(spec5["opt"]) then
	else
		print1()
		print1("Optional arguments")
		local r_2061 = spec5["opt"]
		local r_2091 = _23_1(r_2061)
		local r_2071 = nil
		r_2071 = (function(r_2081)
			if (r_2081 <= r_2091) then
				local arg11 = r_2061[r_2081]
				print1(format1(fmt1, concat1(arg11["names"], ", "), arg11["help"]))
				return r_2071((r_2081 + 1))
			else
			end
		end)
		return r_2071(1)
	end
end)
matcher1 = (function(pattern2)
	return (function(x27)
		local res1 = list1(match1(x27, pattern2))
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
	local r_2111 = nil
	r_2111 = (function()
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
			return r_2111()
		else
		end
	end)
	r_2111()
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
builtin_3f_1 = (function(node1, name5)
	local r_2621 = symbol_3f_1(node1)
	if r_2621 then
		return (node1["var"] == builtins1[name5])
	else
		return r_2621
	end
end)
builtinVar_3f_1 = (function(node2, name6)
	local r_2631 = symbol_3f_1(node2)
	if r_2631 then
		return (node2["var"] == builtinVars1[name6])
	else
		return r_2631
	end
end)
sideEffect_3f_1 = (function(node3)
	local tag4 = type1(node3)
	local temp27
	local r_2641 = (tag4 == "number")
	if r_2641 then
		temp27 = r_2641
	else
		local r_2651 = (tag4 == "string")
		if r_2651 then
			temp27 = r_2651
		else
			local r_2661 = (tag4 == "key")
			if r_2661 then
				temp27 = r_2661
			else
				temp27 = (tag4 == "symbol")
			end
		end
	end
	if temp27 then
		return false
	elseif (tag4 == "list") then
		local fst1 = car2(node3)
		if (type1(fst1) == "symbol") then
			local var1 = fst1["var"]
			local r_2671 = (var1 ~= builtins1["lambda"])
			if r_2671 then
				return (var1 ~= builtins1["quote"])
			else
				return r_2671
			end
		else
			return true
		end
	else
		_error("unmatched item")
	end
end)
constant_3f_1 = (function(node4)
	local r_2681 = string_3f_1(node4)
	if r_2681 then
		return r_2681
	else
		local r_2691 = number_3f_1(node4)
		if r_2691 then
			return r_2691
		else
			return key_3f_1(node4)
		end
	end
end)
urn_2d3e_val1 = (function(node5)
	if string_3f_1(node5) then
		return node5["value"]
	elseif number_3f_1(node5) then
		return node5["value"]
	elseif key_3f_1(node5) then
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
	local temp28
	local r_2701 = string_3f_1(node6)
	if r_2701 then
		temp28 = r_2701
	else
		local r_2711 = key_3f_1(node6)
		if r_2711 then
			temp28 = r_2711
		else
			temp28 = number_3f_1(node6)
		end
	end
	if temp28 then
		return true
	elseif symbol_3f_1(node6) then
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
putNodeError_21_1 = (function(logger5, msg6, node7, explain1, ...)
	local lines1 = _pack(...) lines1.tag = "list"
	return self1(logger5, "put-node-error!", msg6, node7, explain1, lines1)
end)
putNodeWarning_21_1 = (function(logger6, msg7, node8, explain2, ...)
	local lines2 = _pack(...) lines2.tag = "list"
	return self1(logger6, "put-node-warning!", msg7, node8, explain2, lines2)
end)
doNodeError_21_1 = (function(logger7, msg8, node9, explain3, ...)
	local lines3 = _pack(...) lines3.tag = "list"
	self1(logger7, "put-node-error!", msg8, node9, explain3, lines3)
	return fail_21_1((function(r_2771)
		if r_2771 then
			return r_2771
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
	local r_2741 = (options2["level"] >= (function(r_2761)
		if r_2761 then
			return r_2761
		else
			return 1
		end
	end)(pass1["level"]))
	if r_2741 then
		local r_2751
		if (pass1["on"] == false) then
			r_2751 = (override1[pass1["name"]] == true)
		else
			r_2751 = (override1[pass1["name"]] ~= false)
		end
		if r_2751 then
			return all1((function(cat1)
				return (false ~= override1[cat1])
			end), pass1["cat"])
		else
			return r_2751
		end
	else
		return r_2741
	end
end)
runPass1 = (function(pass2, options3, tracker2, ...)
	local args4 = _pack(...) args4.tag = "list"
	if passEnabled_3f_1(pass2, options3) then
		local start2 = clock1()
		local ptracker1 = createTracker1()
		local name7 = _2e2e_2("[", concat1(pass2["cat"], " "), "] ", pass2["name"])
		pass2["run"](ptracker1, options3, unpack1(args4, 1, _23_1(args4)))
		if options3["time"] then
			putVerbose_21_1(options3["logger"], _2e2e_2(name7, " took ", (clock1() - start2), "."))
		else
		end
		if changed_3f_1(ptracker1) then
			if options3["track"] then
				putVerbose_21_1(options3["logger"], _2e2e_2(name7, " did something."))
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
traverseQuote1 = (function(node10, visitor1, level1)
	if (level1 == 0) then
		return traverseNode1(node10, visitor1)
	else
		local tag5 = node10["tag"]
		local temp29
		local r_2891 = (tag5 == "string")
		if r_2891 then
			temp29 = r_2891
		else
			local r_2901 = (tag5 == "number")
			if r_2901 then
				temp29 = r_2901
			else
				local r_2911 = (tag5 == "key")
				if r_2911 then
					temp29 = r_2911
				else
					temp29 = (tag5 == "symbol")
				end
			end
		end
		if temp29 then
			return node10
		elseif (tag5 == "list") then
			local first2 = nth1(node10, 1)
			local temp30
			if first2 then
				temp30 = (first2["tag"] == "symbol")
			else
				temp30 = first2
			end
			if temp30 then
				local temp31
				local r_2931 = (first2["contents"] == "unquote")
				if r_2931 then
					temp31 = r_2931
				else
					temp31 = (first2["contents"] == "unquote-splice")
				end
				if temp31 then
					node10[2] = traverseQuote1(nth1(node10, 2), visitor1, pred1(level1))
					return node10
				elseif (first2["contents"] == "syntax-quote") then
					node10[2] = traverseQuote1(nth1(node10, 2), visitor1, succ1(level1))
					return node10
				else
					local r_2961 = _23_1(node10)
					local r_2941 = nil
					r_2941 = (function(r_2951)
						if (r_2951 <= r_2961) then
							node10[r_2951] = traverseQuote1(nth1(node10, r_2951), visitor1, level1)
							return r_2941((r_2951 + 1))
						else
						end
					end)
					r_2941(1)
					return node10
				end
			else
				local r_3001 = _23_1(node10)
				local r_2981 = nil
				r_2981 = (function(r_2991)
					if (r_2991 <= r_3001) then
						node10[r_2991] = traverseQuote1(nth1(node10, r_2991), visitor1, level1)
						return r_2981((r_2991 + 1))
					else
					end
				end)
				r_2981(1)
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
	local temp32
	local r_2781 = (tag6 == "string")
	if r_2781 then
		temp32 = r_2781
	else
		local r_2791 = (tag6 == "number")
		if r_2791 then
			temp32 = r_2791
		else
			local r_2801 = (tag6 == "key")
			if r_2801 then
				temp32 = r_2801
			else
				temp32 = (tag6 == "symbol")
			end
		end
	end
	if temp32 then
		return visitor2(node11, visitor2)
	elseif (tag6 == "list") then
		local first3 = car2(node11)
		first3 = visitor2(first3, visitor2)
		node11[1] = first3
		if (first3["tag"] == "symbol") then
			local func1 = first3["var"]
			local funct1 = func1["tag"]
			if (func1 == builtins2["lambda"]) then
				traverseBlock1(node11, 3, visitor2)
				return visitor2(node11, visitor2)
			elseif (func1 == builtins2["cond"]) then
				local r_3041 = _23_1(node11)
				local r_3021 = nil
				r_3021 = (function(r_3031)
					if (r_3031 <= r_3041) then
						local case1 = nth1(node11, r_3031)
						case1[1] = traverseNode1(nth1(case1, 1), visitor2)
						traverseBlock1(case1, 2, visitor2)
						return r_3021((r_3031 + 1))
					else
					end
				end)
				r_3021(2)
				return visitor2(node11, visitor2)
			elseif (func1 == builtins2["set!"]) then
				node11[3] = traverseNode1(nth1(node11, 3), visitor2)
				return visitor2(node11, visitor2)
			elseif (func1 == builtins2["quote"]) then
				return visitor2(node11, visitor2)
			elseif (func1 == builtins2["syntax-quote"]) then
				node11[2] = traverseQuote1(nth1(node11, 2), visitor2, 1)
				return visitor2(node11, visitor2)
			else
				local temp33
				local r_3061 = (func1 == builtins2["unquote"])
				if r_3061 then
					temp33 = r_3061
				else
					temp33 = (func1 == builtins2["unquote-splice"])
				end
				if temp33 then
					return fail_21_1("unquote/unquote-splice should never appear head")
				else
					local temp34
					local r_3071 = (func1 == builtins2["define"])
					if r_3071 then
						temp34 = r_3071
					else
						temp34 = (func1 == builtins2["define-macro"])
					end
					if temp34 then
						node11[_23_1(node11)] = traverseNode1(nth1(node11, _23_1(node11)), visitor2)
						return visitor2(node11, visitor2)
					elseif (func1 == builtins2["define-native"]) then
						return visitor2(node11, visitor2)
					elseif (func1 == builtins2["import"]) then
						return visitor2(node11, visitor2)
					else
						local temp35
						local r_3081 = (funct1 == "defined")
						if r_3081 then
							temp35 = r_3081
						else
							local r_3091 = (funct1 == "arg")
							if r_3091 then
								temp35 = r_3091
							else
								local r_3101 = (funct1 == "native")
								if r_3101 then
									temp35 = r_3101
								else
									temp35 = (funct1 == "macro")
								end
							end
						end
						if temp35 then
							traverseList1(node11, 1, visitor2)
							return visitor2(node11, visitor2)
						else
							return fail_21_1(_2e2e_2("Unknown kind ", funct1, " for variable ", func1["name"]))
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
traverseBlock1 = (function(node12, start3, visitor3)
	local r_2831 = _23_1(node12)
	local r_2811 = nil
	r_2811 = (function(r_2821)
		if (r_2821 <= r_2831) then
			local result5 = traverseNode1(nth1(node12, (r_2821 + 0)), visitor3)
			node12[r_2821] = result5
			return r_2811((r_2821 + 1))
		else
		end
	end)
	r_2811(start3)
	return node12
end)
traverseList1 = (function(node13, start4, visitor4)
	local r_2871 = _23_1(node13)
	local r_2851 = nil
	r_2851 = (function(r_2861)
		if (r_2861 <= r_2871) then
			node13[r_2861] = traverseNode1(nth1(node13, r_2861), visitor4)
			return r_2851((r_2861 + 1))
		else
		end
	end)
	r_2851(start4)
	return node13
end)
builtins3 = require1("tacky.analysis.resolve")["builtins"]
visitQuote1 = (function(node14, visitor5, level2)
	if (level2 == 0) then
		return visitNode1(node14, visitor5)
	else
		local tag7 = node14["tag"]
		local temp36
		local r_3261 = (tag7 == "string")
		if r_3261 then
			temp36 = r_3261
		else
			local r_3271 = (tag7 == "number")
			if r_3271 then
				temp36 = r_3271
			else
				local r_3281 = (tag7 == "key")
				if r_3281 then
					temp36 = r_3281
				else
					temp36 = (tag7 == "symbol")
				end
			end
		end
		if temp36 then
			return nil
		elseif (tag7 == "list") then
			local first4 = nth1(node14, 1)
			local temp37
			if first4 then
				temp37 = (first4["tag"] == "symbol")
			else
				temp37 = first4
			end
			if temp37 then
				local temp38
				local r_3301 = (first4["contents"] == "unquote")
				if r_3301 then
					temp38 = r_3301
				else
					temp38 = (first4["contents"] == "unquote-splice")
				end
				if temp38 then
					return visitQuote1(nth1(node14, 2), visitor5, pred1(level2))
				elseif (first4["contents"] == "syntax-quote") then
					return visitQuote1(nth1(node14, 2), visitor5, succ1(level2))
				else
					local r_3351 = _23_1(node14)
					local r_3331 = nil
					r_3331 = (function(r_3341)
						if (r_3341 <= r_3351) then
							local sub2 = node14[r_3341]
							visitQuote1(sub2, visitor5, level2)
							return r_3331((r_3341 + 1))
						else
						end
					end)
					return r_3331(1)
				end
			else
				local r_3411 = _23_1(node14)
				local r_3391 = nil
				r_3391 = (function(r_3401)
					if (r_3401 <= r_3411) then
						local sub3 = node14[r_3401]
						visitQuote1(sub3, visitor5, level2)
						return r_3391((r_3401 + 1))
					else
					end
				end)
				return r_3391(1)
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
		local temp39
		local r_3191 = (tag8 == "string")
		if r_3191 then
			temp39 = r_3191
		else
			local r_3201 = (tag8 == "number")
			if r_3201 then
				temp39 = r_3201
			else
				local r_3211 = (tag8 == "key")
				if r_3211 then
					temp39 = r_3211
				else
					temp39 = (tag8 == "symbol")
				end
			end
		end
		if temp39 then
			return nil
		elseif (tag8 == "list") then
			local first5 = nth1(node15, 1)
			if (first5["tag"] == "symbol") then
				local func2 = first5["var"]
				local funct2 = func2["tag"]
				if (func2 == builtins3["lambda"]) then
					return visitBlock1(node15, 3, visitor6)
				elseif (func2 == builtins3["cond"]) then
					local r_3451 = _23_1(node15)
					local r_3431 = nil
					r_3431 = (function(r_3441)
						if (r_3441 <= r_3451) then
							local case2 = nth1(node15, r_3441)
							visitNode1(nth1(case2, 1), visitor6)
							visitBlock1(case2, 2, visitor6)
							return r_3431((r_3441 + 1))
						else
						end
					end)
					return r_3431(2)
				elseif (func2 == builtins3["set!"]) then
					return visitNode1(nth1(node15, 3), visitor6)
				elseif (func2 == builtins3["quote"]) then
				elseif (func2 == builtins3["syntax-quote"]) then
					return visitQuote1(nth1(node15, 2), visitor6, 1)
				else
					local temp40
					local r_3471 = (func2 == builtins3["unquote"])
					if r_3471 then
						temp40 = r_3471
					else
						temp40 = (func2 == builtins3["unquote-splice"])
					end
					if temp40 then
						return fail_21_1("unquote/unquote-splice should never appear head")
					else
						local temp41
						local r_3481 = (func2 == builtins3["define"])
						if r_3481 then
							temp41 = r_3481
						else
							temp41 = (func2 == builtins3["define-macro"])
						end
						if temp41 then
							return visitNode1(nth1(node15, _23_1(node15)), visitor6)
						elseif (func2 == builtins3["define-native"]) then
						elseif (func2 == builtins3["import"]) then
						else
							local temp42
							local r_3491 = (funct2 == "defined")
							if r_3491 then
								temp42 = r_3491
							else
								local r_3501 = (funct2 == "arg")
								if r_3501 then
									temp42 = r_3501
								else
									local r_3511 = (funct2 == "native")
									if r_3511 then
										temp42 = r_3511
									else
										temp42 = (funct2 == "macro")
									end
								end
							end
							if temp42 then
								return visitBlock1(node15, 1, visitor6)
							else
								return fail_21_1(_2e2e_2("Unknown kind ", funct2, " for variable ", func2["name"]))
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
visitBlock1 = (function(node16, start5, visitor7)
	local r_3241 = _23_1(node16)
	local r_3221 = nil
	r_3221 = (function(r_3231)
		if (r_3231 <= r_3241) then
			visitNode1(nth1(node16, r_3231), visitor7)
			return r_3221((r_3231 + 1))
		else
		end
	end)
	return r_3221(start5)
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
getNode1 = (function(state2, node17)
	local entry2 = state2["nodes"][node17]
	if entry2 then
	else
		entry2 = struct1("uses", ({tag = "list", n = 0}))
		state2["nodes"][node17] = entry2
	end
	return entry2
end)
addUsage_21_1 = (function(state3, var3, node18)
	local varMeta1 = getVar1(state3, var3)
	local nodeMeta1 = getNode1(state3, node18)
	varMeta1["usages"][node18] = true
	varMeta1["active"] = true
	nodeMeta1["uses"][var3] = true
	return nil
end)
addDefinition_21_1 = (function(state4, var4, node19, kind1, value7)
	local varMeta2 = getVar1(state4, var4)
	varMeta2["defs"][node19] = struct1("tag", kind1, "value", value7)
	return nil
end)
definitionsVisitor1 = (function(state5, node20, visitor8)
	local temp43
	local r_3111 = list_3f_1(node20)
	if r_3111 then
		temp43 = symbol_3f_1(car2(node20))
	else
		temp43 = r_3111
	end
	if temp43 then
		local func3 = car2(node20)["var"]
		if (func3 == builtins1["lambda"]) then
			local r_3531 = nth1(node20, 2)
			local r_3561 = _23_1(r_3531)
			local r_3541 = nil
			r_3541 = (function(r_3551)
				if (r_3551 <= r_3561) then
					local arg20 = r_3531[r_3551]
					addDefinition_21_1(state5, arg20["var"], arg20, "arg", arg20)
					return r_3541((r_3551 + 1))
				else
				end
			end)
			return r_3541(1)
		elseif (func3 == builtins1["set!"]) then
			return addDefinition_21_1(state5, node20[2]["var"], node20, "set", nth1(node20, 3))
		else
			local temp44
			local r_3581 = (func3 == builtins1["define"])
			if r_3581 then
				temp44 = r_3581
			else
				temp44 = (func3 == builtins1["define-macro"])
			end
			if temp44 then
				return addDefinition_21_1(state5, node20["defVar"], node20, "define", nth1(node20, _23_1(node20)))
			elseif (func3 == builtins1["define-native"]) then
				return addDefinition_21_1(state5, node20["defVar"], node20, "native")
			else
			end
		end
	else
		local temp45
		local r_3591 = list_3f_1(node20)
		if r_3591 then
			local r_3601 = list_3f_1(car2(node20))
			if r_3601 then
				local r_3611 = symbol_3f_1(caar1(node20))
				if r_3611 then
					temp45 = (caar1(node20)["var"] == builtins1["lambda"])
				else
					temp45 = r_3611
				end
			else
				temp45 = r_3601
			end
		else
			temp45 = r_3591
		end
		if temp45 then
			local lam1 = car2(node20)
			local args5 = nth1(lam1, 2)
			local offset1 = 1
			local r_3641 = _23_1(args5)
			local r_3621 = nil
			r_3621 = (function(r_3631)
				if (r_3631 <= r_3641) then
					local arg21 = nth1(args5, r_3631)
					local val10 = nth1(node20, (r_3631 + offset1))
					if arg21["var"]["isVariadic"] then
						local count1 = (_23_1(node20) - _23_1(args5))
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
						end)()
						)
					end
					return r_3621((r_3631 + 1))
				else
				end
			end)
			r_3621(1)
			visitBlock1(node20, 2, visitor8)
			visitBlock1(lam1, 3, visitor8)
			return false
		else
		end
	end
end)
definitionsVisit1 = (function(state6, nodes1)
	return visitBlock1(nodes1, 1, (function(r_3721, r_3731)
		return definitionsVisitor1(state6, r_3721, r_3731)
	end))
end)
usagesVisit1 = (function(state7, nodes2, pred2)
	if pred2 then
	else
		pred2 = (function()
			return true
		end)
	end
	local queue1 = ({tag = "list", n = 0})
	local visited1 = ({})
	local addUsage1 = (function(var5, user1)
		addUsage_21_1(state7, var5, user1)
		local varMeta3 = getVar1(state7, var5)
		if varMeta3["active"] then
			return iterPairs1(varMeta3["defs"], (function(_5f_2, def1)
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
	local visit1 = (function(node21)
		if visited1[node21] then
			return false
		else
			visited1[node21] = true
			if symbol_3f_1(node21) then
				addUsage1(node21["var"], node21)
				return true
			else
				local temp47
				local r_3671 = list_3f_1(node21)
				if r_3671 then
					local r_3681 = (_23_1(node21) > 0)
					if r_3681 then
						temp47 = symbol_3f_1(car2(node21))
					else
						temp47 = r_3681
					end
				else
					temp47 = r_3671
				end
				if temp47 then
					local func4 = car2(node21)["var"]
					local temp48
					local r_3691 = (func4 == builtins1["set!"])
					if r_3691 then
						temp48 = r_3691
					else
						local r_3701 = (func4 == builtins1["define"])
						if r_3701 then
							temp48 = r_3701
						else
							temp48 = (func4 == builtins1["define-macro"])
						end
					end
					if temp48 then
						if pred2(nth1(node21, 3)) then
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
	local r_3161 = _23_1(nodes2)
	local r_3141 = nil
	r_3141 = (function(r_3151)
		if (r_3151 <= r_3161) then
			local node22 = nodes2[r_3151]
			pushCdr_21_1(queue1, node22)
			return r_3141((r_3151 + 1))
		else
		end
	end)
	r_3141(1)
	local r_3181 = nil
	r_3181 = (function()
		if (_23_1(queue1) > 0) then
			visitNode1(removeNth_21_1(queue1, 1), visit1)
			return r_3181()
		else
		end
	end)
	return r_3181()
end)
tagUsage1 = struct1("name", "tag-usage", "help", "Gathers usage and definition data for all expressions in NODES, storing it in LOOKUP.", "cat", ({tag = "list", n = 2, "tag", "usage"}), "run", (function(r_3741, state8, nodes3, lookup1)
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
formatNode1 = (function(node23)
	local temp49
	local r_3751 = node23["range"]
	if r_3751 then
		temp49 = node23["contents"]
	else
		temp49 = r_3751
	end
	if temp49 then
		return format1("%s (%q)", formatRange1(node23["range"]), node23["contents"])
	elseif node23["range"] then
		return formatRange1(node23["range"])
	elseif node23["owner"] then
		local owner1 = node23["owner"]
		if owner1["var"] then
			return format1("macro expansion of %s (%s)", owner1["var"]["name"], formatNode1(owner1["node"]))
		else
			return format1("unquote expansion (%s)", formatNode1(owner1["node"]))
		end
	else
		local temp50
		local r_3761 = node23["start"]
		if r_3761 then
			temp50 = node23["finish"]
		else
			temp50 = r_3761
		end
		if temp50 then
			return formatRange1(node23)
		else
			return "?"
		end
	end
end)
getSource1 = (function(node24)
	local result6 = nil
	local r_3771 = nil
	r_3771 = (function()
		local temp51
		local r_3781 = node24
		if r_3781 then
			temp51 = _21_1(result6)
		else
			temp51 = r_3781
		end
		if temp51 then
			result6 = node24["range"]
			node24 = node24["parent"]
			return r_3771()
		else
		end
	end)
	r_3771()
	return result6
end)
struct1("formatPosition", formatPosition1, "formatRange", formatRange1, "formatNode", formatNode1, "getSource", getSource1)
stripImport1 = struct1("name", "strip-import", "help", "Strip all import expressions in NODES", "cat", ({tag = "list", n = 1, "opt"}), "run", (function(r_3742, state9, nodes4)
	local r_3791 = nil
	r_3791 = (function(r_3801)
		if (r_3801 >= 1) then
			local node25 = nth1(nodes4, r_3801)
			local temp52
			local r_3831 = list_3f_1(node25)
			if r_3831 then
				local r_3841 = (_23_1(node25) > 0)
				if r_3841 then
					local r_3851 = symbol_3f_1(car2(node25))
					if r_3851 then
						temp52 = (car2(node25)["var"] == builtins1["import"])
					else
						temp52 = r_3851
					end
				else
					temp52 = r_3841
				end
			else
				temp52 = r_3831
			end
			if temp52 then
				if (r_3801 == _23_1(nodes4)) then
					nodes4[r_3801] = struct1("tag", "symbol", "contents", "nil", "var", builtinVars1["nil"])
				else
					removeNth_21_1(nodes4, r_3801)
				end
				r_3742["changed"] = true
			else
			end
			return r_3791((r_3801 + -1))
		else
		end
	end)
	return r_3791(_23_1(nodes4))
end))
stripPure1 = struct1("name", "strip-pure", "help", "Strip all pure expressions in NODES (apart from the last one).", "cat", ({tag = "list", n = 1, "opt"}), "run", (function(r_3743, state10, nodes5)
	local r_3861 = nil
	r_3861 = (function(r_3871)
		if (r_3871 >= 1) then
			local node26 = nth1(nodes5, r_3871)
			if sideEffect_3f_1(node26) then
			else
				removeNth_21_1(nodes5, r_3871)
				r_3743["changed"] = true
			end
			return r_3861((r_3871 + -1))
		else
		end
	end)
	return r_3861(pred1(_23_1(nodes5)))
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
constantFold1 = struct1("name", "constant-fold", "help", "A primitive constant folder\n\nThis simply finds function calls with constant functions and looks up the function.\nIf the function is native and pure then we'll execute it and replace the node with the\nresult. There are a couple of caveats:\n\n - If the function call errors then we will flag a warning and continue.\n - If this returns a decimal (or infinity or NaN) then we'll continue: we cannot correctly\n   accurately handle this.\n - If this doesn't return exactly one value then we will stop. This might be a future enhancement.", "cat", ({tag = "list", n = 1, "opt"}), "run", (function(r_3744, state11, nodes6)
	return traverseList1(nodes6, 1, (function(node27)
		local temp53
		local r_3901 = list_3f_1(node27)
		if r_3901 then
			temp53 = fastAll1(constant_3f_1, node27, 2)
		else
			temp53 = r_3901
		end
		if temp53 then
			local head1 = car2(node27)
			local meta1
			local r_4041 = symbol_3f_1(head1)
			if r_4041 then
				local r_4051 = _21_1(head1["folded"])
				if r_4051 then
					local r_4061 = (head1["var"]["tag"] == "native")
					if r_4061 then
						meta1 = state11["meta"][head1["var"]["fullName"]]
					else
						meta1 = r_4061
					end
				else
					meta1 = r_4051
				end
			else
				meta1 = r_4041
			end
			local temp54
			if meta1 then
				local r_3921 = meta1["pure"]
				if r_3921 then
					temp54 = meta1["value"]
				else
					temp54 = r_3921
				end
			else
				temp54 = meta1
			end
			if temp54 then
				local res2 = list1(pcall1(meta1["value"], unpack1(map1(urn_2d3e_val1, cdr2(node27)))))
				if car2(res2) then
					local val12 = nth1(res2, 2)
					local temp55
					local r_3931 = (_23_1(res2) ~= 2)
					if r_3931 then
						temp55 = r_3931
					else
						local r_3941 = number_3f_1(val12)
						if r_3941 then
							local r_3951 = (cadr1(list1(modf1(val12))) ~= 0)
							if r_3951 then
								temp55 = r_3951
							else
								temp55 = (abs1(val12) == huge1)
							end
						else
							temp55 = r_3941
						end
					end
					if temp55 then
						head1["folded"] = true
						return node27
					else
						r_3744["changed"] = true
						return val_2d3e_urn1(val12)
					end
				else
					head1["folded"] = true
					putNodeWarning_21_1(state11["logger"], _2e2e_2("Cannot execute constant expression"), node27, nil, getSource1(node27), _2e2e_2("Executed ", pretty1(node27), ", failed with: ", nth1(res2, 2)))
					return node27
				end
			else
				return node27
			end
		else
			return node27
		end
	end))
end))
condFold1 = struct1("name", "cond-fold", "help", "Simplify all `cond` nodes, removing `false` branches and killing\nall branches after a `true` one.", "cat", ({tag = "list", n = 1, "opt"}), "run", (function(r_3745, state12, nodes7)
	return traverseList1(nodes7, 1, (function(node28)
		local temp56
		local r_3961 = list_3f_1(node28)
		if r_3961 then
			local r_3971 = symbol_3f_1(car2(node28))
			if r_3971 then
				temp56 = (car2(node28)["var"] == builtins1["cond"])
			else
				temp56 = r_3971
			end
		else
			temp56 = r_3961
		end
		if temp56 then
			local final1 = false
			local i3 = 2
			local r_3981 = nil
			r_3981 = (function()
				if (i3 <= _23_1(node28)) then
					local elem6 = nth1(node28, i3)
					if final1 then
						r_3745["changed"] = true
						removeNth_21_1(node28, i3)
					else
						local r_4071 = urn_2d3e_bool1(car2(elem6))
						if eq_3f_1(r_4071, false) then
							r_3745["changed"] = true
							removeNth_21_1(node28, i3)
						elseif eq_3f_1(r_4071, true) then
							final1 = true
							i3 = (i3 + 1)
						elseif eq_3f_1(r_4071, nil) then
							i3 = (i3 + 1)
						else
							error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_4071), ", but none matched.\n", "  Tried: `false`\n  Tried: `true`\n  Tried: `nil`"))
						end
					end
					return r_3981()
				else
				end
			end)
			r_3981()
			local temp57
			local r_4081 = (_23_1(node28) == 2)
			if r_4081 then
				temp57 = (urn_2d3e_bool1(car2(nth1(node28, 2))) == true)
			else
				temp57 = r_4081
			end
			if temp57 then
				r_3745["changed"] = true
				local body2 = cdr2(nth1(node28, 2))
				if (_23_1(body2) == 1) then
					return car2(body2)
				else
					return makeProgn1(cdr2(nth1(node28, 2)))
				end
			else
				return node28
			end
		else
			return node28
		end
	end))
end))
lambdaFold1 = struct1("name", "lambda-fold", "help", "Simplify all directly called lambdas, inlining them were appropriate.", "cat", ({tag = "list", n = 1, "opt"}), "run", (function(r_3746, state13, nodes8)
	return traverseList1(nodes8, 1, (function(node29)
		local temp58
		local r_3991 = list_3f_1(node29)
		if r_3991 then
			local r_4001 = (_23_1(node29) == 1)
			if r_4001 then
				local r_4011 = list_3f_1(car2(node29))
				if r_4011 then
					local r_4021 = builtin_3f_1(caar1(node29), "lambda")
					if r_4021 then
						local r_4031 = (_23_1(car2(node29)) == 3)
						if r_4031 then
							temp58 = nil_3f_1(nth1(car2(node29), 2))
						else
							temp58 = r_4031
						end
					else
						temp58 = r_4021
					end
				else
					temp58 = r_4011
				end
			else
				temp58 = r_4001
			end
		else
			temp58 = r_3991
		end
		if temp58 then
			return nth1(car2(node29), 3)
		else
			return node29
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
		local temp59
		local r_4091 = string_3f_1(val13)
		if r_4091 then
			temp59 = r_4091
		else
			local r_4101 = number_3f_1(val13)
			if r_4101 then
				temp59 = r_4101
			else
				temp59 = key_3f_1(val13)
			end
		end
		if temp59 then
			return val13
		else
			local temp60
			local r_4111 = symbol_3f_1(val13)
			if r_4111 then
				local r_4121 = (ty4 == "define")
				if r_4121 then
					temp60 = r_4121
				else
					local r_4131 = (ty4 == "set")
					if r_4131 then
						temp60 = r_4131
					else
						temp60 = (ty4 == "let")
					end
				end
			else
				temp60 = r_4111
			end
			if temp60 then
				local r_4141 = getConstantVal1(lookup2, val13)
				if r_4141 then
					return r_4141
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
stripDefs1 = struct1("name", "strip-defs", "help", "Strip all unused top level definitions.", "cat", ({tag = "list", n = 2, "opt", "usage"}), "run", (function(r_3747, state14, nodes9, lookup3)
	local r_4151 = nil
	r_4151 = (function(r_4161)
		if (r_4161 >= 1) then
			local node30 = nth1(nodes9, r_4161)
			local temp61
			local r_4191 = node30["defVar"]
			if r_4191 then
				temp61 = _21_1(getVar1(lookup3, node30["defVar"])["active"])
			else
				temp61 = r_4191
			end
			if temp61 then
				if (r_4161 == _23_1(nodes9)) then
					nodes9[r_4161] = struct1("tag", "symbol", "contents", "nil", "var", builtinVars1["nil"])
				else
					removeNth_21_1(nodes9, r_4161)
				end
				r_3747["changed"] = true
			else
			end
			return r_4151((r_4161 + -1))
		else
		end
	end)
	return r_4151(_23_1(nodes9))
end))
stripArgs1 = struct1("name", "strip-args", "help", "Strip all unused, pure arguments in directly called lambdas.", "cat", ({tag = "list", n = 2, "opt", "usage"}), "run", (function(r_3748, state15, nodes10, lookup4)
	return visitBlock1(nodes10, 1, (function(node31)
		local temp62
		local r_4201 = list_3f_1(node31)
		if r_4201 then
			local r_4211 = list_3f_1(car2(node31))
			if r_4211 then
				local r_4221 = symbol_3f_1(caar1(node31))
				if r_4221 then
					temp62 = (caar1(node31)["var"] == builtins1["lambda"])
				else
					temp62 = r_4221
				end
			else
				temp62 = r_4211
			end
		else
			temp62 = r_4201
		end
		if temp62 then
			local lam2 = car2(node31)
			local args6 = nth1(lam2, 2)
			local offset2 = 1
			local remOffset1 = 0
			local r_4251 = _23_1(args6)
			local r_4231 = nil
			r_4231 = (function(r_4241)
				if (r_4241 <= r_4251) then
					local arg22 = nth1(args6, (r_4241 - remOffset1))
					local val14 = nth1(node31, ((r_4241 + offset2) - remOffset1))
					if arg22["var"]["isVariadic"] then
						local count2 = (_23_1(node31) - _23_1(args6))
						if (count2 < 0) then
							count2 = 0
						else
						end
						offset2 = count2
					elseif (nil == val14) then
					elseif sideEffect_3f_1(val14) then
					elseif (_23_keys1(getVar1(lookup4, arg22["var"])["usages"]) > 0) then
					else
						r_3748["changed"] = true
						removeNth_21_1(args6, (r_4241 - remOffset1))
						removeNth_21_1(node31, ((r_4241 + offset2) - remOffset1))
						remOffset1 = (remOffset1 + 1)
					end
					return r_4231((r_4241 + 1))
				else
				end
			end)
			return r_4231(1)
		else
		end
	end))
end))
variableFold1 = struct1("name", "variable-fold", "help", "Folds variables", "cat", ({tag = "list", n = 2, "opt", "usage"}), "run", (function(r_3749, state16, nodes11, lookup5)
	return traverseList1(nodes11, 1, (function(node32)
		if symbol_3f_1(node32) then
			local var7 = getConstantVal1(lookup5, node32)
			local temp63
			if var7 then
				temp63 = (var7 ~= node32)
			else
				temp63 = var7
			end
			if temp63 then
				r_3749["changed"] = true
				return var7
			else
				return node32
			end
		else
			return node32
		end
	end))
end))
scope_2f_child1 = require1("tacky.analysis.scope")["child"]
scope_2f_add_21_1 = require1("tacky.analysis.scope")["add"]
copyOf1 = (function(x28)
	local res3 = ({})
	iterPairs1(x28, (function(k1, v2)
		res3[k1] = v2
		return nil
	end))
	return res3
end)
getScope1 = (function(scope1, lookup6, n2)
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
	local r_4281 = lookup7["vars"][var8]
	if r_4281 then
		return r_4281
	else
		return var8
	end
end)
copyNode1 = (function(node33, lookup8)
	local r_4291 = type1(node33)
	if eq_3f_1(r_4291, "string") then
		return copyOf1(node33)
	elseif eq_3f_1(r_4291, "key") then
		return copyOf1(node33)
	elseif eq_3f_1(r_4291, "number") then
		return copyOf1(node33)
	elseif eq_3f_1(r_4291, "symbol") then
		local copy1 = copyOf1(node33)
		local oldVar1 = node33["var"]
		local newVar1 = getVar2(oldVar1, lookup8)
		local temp64
		local r_4301 = (oldVar1 ~= newVar1)
		if r_4301 then
			temp64 = (oldVar1["node"] == node33)
		else
			temp64 = r_4301
		end
		if temp64 then
			newVar1["node"] = copy1
		else
		end
		copy1["var"] = newVar1
		return copy1
	elseif eq_3f_1(r_4291, "list") then
		if builtin_3f_1(car2(node33), "lambda") then
			local args7 = cadr1(node33)
			if nil_3f_1(args7) then
			else
				local newScope3 = scope_2f_child1(getScope1(car2(args7)["var"]["scope"], lookup8, node33))
				local r_4431 = _23_1(args7)
				local r_4411 = nil
				r_4411 = (function(r_4421)
					if (r_4421 <= r_4431) then
						local arg23 = args7[r_4421]
						local var9 = arg23["var"]
						local newVar2 = scope_2f_add_21_1(newScope3, var9["name"], var9["tag"], nil)
						newVar2["isVariadic"] = var9["isVariadic"]
						lookup8["vars"][var9] = newVar2
						return r_4411((r_4421 + 1))
					else
					end
				end)
				r_4411(1)
			end
		else
		end
		local res4 = copyOf1(node33)
		local r_4471 = _23_1(res4)
		local r_4451 = nil
		r_4451 = (function(r_4461)
			if (r_4461 <= r_4471) then
				res4[r_4461] = copyNode1(nth1(res4, r_4461), lookup8)
				return r_4451((r_4461 + 1))
			else
			end
		end)
		r_4451(1)
		return res4
	else
		return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_4291), ", but none matched.\n", "  Tried: `\"string\"`\n  Tried: `\"key\"`\n  Tried: `\"number\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`"))
	end
end)
scoreNode1 = (function(node34)
	local r_4311 = type1(node34)
	if eq_3f_1(r_4311, "string") then
		return 0
	elseif eq_3f_1(r_4311, "key") then
		return 0
	elseif eq_3f_1(r_4311, "number") then
		return 0
	elseif eq_3f_1(r_4311, "symbol") then
		return 1
	elseif eq_3f_1(r_4311, "list") then
		local r_4321 = type1(car2(node34))
		if eq_3f_1(r_4321, "symbol") then
			local func5 = car2(node34)["var"]
			if (func5 == builtins1["lambda"]) then
				return scoreNodes1(node34, 3, 10)
			elseif (func5 == builtins1["cond"]) then
				return scoreNodes1(node34, 2, 10)
			elseif (func5 == builtins1["set!"]) then
				return scoreNodes1(node34, 2, 5)
			elseif (func5 == builtins1["quote"]) then
				return scoreNodes1(node34, 2, 2)
			elseif (func5 == builtins1["quasi-quote"]) then
				return scoreNodes1(node34, 2, 3)
			elseif (func5 == builtins1["unquote-splice"]) then
				return scoreNodes1(node34, 2, 10)
			else
				return scoreNodes1(node34, 1, (_23_1(node34) + 1))
			end
		else
			return scoreNodes1(node34, 1, (_23_1(node34) + 1))
		end
	else
		return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_4311), ", but none matched.\n", "  Tried: `\"string\"`\n  Tried: `\"key\"`\n  Tried: `\"number\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`"))
	end
end)
getScore1 = (function(lookup9, node35)
	local score1 = lookup9[node35]
	if (score1 == nil) then
		score1 = 0
		local r_4341 = nth1(node35, 2)
		local r_4371 = _23_1(r_4341)
		local r_4351 = nil
		r_4351 = (function(r_4361)
			if (r_4361 <= r_4371) then
				local arg24 = r_4341[r_4361]
				if arg24["var"]["isVariadic"] then
					score1 = false
				else
				end
				return r_4351((r_4361 + 1))
			else
			end
		end)
		r_4351(1)
		if score1 then
			score1 = scoreNodes1(node35, 3, score1)
		else
		end
		lookup9[node35] = score1
	else
	end
	if score1 then
		return score1
	else
		return huge1
	end
end)
scoreNodes1 = (function(nodes12, start6, sum1)
	if (start6 > _23_1(nodes12)) then
		return sum1
	else
		local score2 = scoreNode1(nth1(nodes12, start6))
		if score2 then
			if (score2 > 20) then
				return score2
			else
				return scoreNodes1(nodes12, succ1(start6), (sum1 + score2))
			end
		else
			return false
		end
	end
end)
inline1 = struct1("name", "inline", "help", "Inline simple functions.", "cat", ({tag = "list", n = 2, "opt", "usage"}), "on", false, "run", (function(r_37410, state17, nodes13, usage2)
	local scoreLookup1 = ({})
	return visitBlock1(nodes13, 1, (function(node36)
		local temp65
		local r_4491 = list_3f_1(node36)
		if r_4491 then
			temp65 = symbol_3f_1(car2(node36))
		else
			temp65 = r_4491
		end
		if temp65 then
			local func6 = car2(node36)["var"]
			local def3 = getVar1(usage2, func6)
			if (_23_keys1(def3["defs"]) == 1) then
				local ent2 = nth1(list1(next1(def3["defs"])), 2)
				local val15 = ent2["value"]
				local temp66
				local r_4501 = list_3f_1(val15)
				if r_4501 then
					local r_4511 = builtin_3f_1(car2(val15), "lambda")
					if r_4511 then
						temp66 = (getScore1(scoreLookup1, val15) <= 20)
					else
						temp66 = r_4511
					end
				else
					temp66 = r_4501
				end
				if temp66 then
					local copy2 = copyNode1(val15, struct1("scopes", ({}), "vars", ({}), "root", func6["scope"]))
					node36[1] = copy2
					r_37410["changed"] = true
					return nil
				else
				end
			else
			end
		else
		end
	end))
end))
optimiseOnce1 = (function(nodes14, state18)
	local tracker3 = createTracker1()
	runPass1(stripImport1, state18, tracker3, nodes14)
	runPass1(stripPure1, state18, tracker3, nodes14)
	runPass1(constantFold1, state18, tracker3, nodes14)
	runPass1(condFold1, state18, tracker3, nodes14)
	runPass1(lambdaFold1, state18, tracker3, nodes14)
	local lookup10 = createState1()
	runPass1(tagUsage1, state18, tracker3, nodes14, lookup10)
	runPass1(stripDefs1, state18, tracker3, nodes14, lookup10)
	runPass1(stripArgs1, state18, tracker3, nodes14, lookup10)
	runPass1(variableFold1, state18, tracker3, nodes14, lookup10)
	runPass1(inline1, state18, tracker3, nodes14, lookup10)
	return changed_3f_1(tracker3)
end)
optimise1 = (function(nodes15, state19)
	local maxN1 = state19["max-n"]
	local maxT1 = state19["max-time"]
	local iteration1 = 0
	local finish1 = (clock1() + maxT1)
	local changed1 = true
	local r_2581 = nil
	r_2581 = (function()
		local temp67
		local r_2591 = changed1
		if r_2591 then
			local r_2601
			local r_4521 = (maxN1 < 0)
			if r_4521 then
				r_2601 = r_4521
			else
				r_2601 = (iteration1 < maxN1)
			end
			if r_2601 then
				local r_2611 = (maxT1 < 0)
				if r_2611 then
					temp67 = r_2611
				else
					temp67 = (clock1() < finish1)
				end
			else
				temp67 = r_2601
			end
		else
			temp67 = r_2591
		end
		if temp67 then
			changed1 = optimiseOnce1(nodes15, state19)
			iteration1 = (iteration1 + 1)
			return r_2581()
		else
		end
	end)
	r_2581()
	return nodes15
end)
checkArity1 = struct1("name", "check-arity", "help", "Produce a warning if any NODE in NODES calls a function with too many arguments.\n\nLOOKUP is the variable usage lookup table.", "cat", ({tag = "list", n = 2, "warn", "usage"}), "run", (function(r_37411, state20, nodes16, lookup11)
	local arity1
	local getArity1
	arity1 = ({})
	getArity1 = (function(symbol1)
		local var10 = getVar1(lookup11, symbol1["var"])
		local ari1 = arity1[var10]
		if (ari1 ~= nil) then
			return ari1
		elseif (_23_keys1(var10["defs"]) ~= 1) then
			return false
		else
			arity1[var10] = false
			local defData1 = cadr1(list1(next1(var10["defs"])))
			local def4 = defData1["value"]
			if (defData1["tag"] == "arg") then
				ari1 = false
			else
				if symbol_3f_1(def4) then
					ari1 = getArity1(def4)
				else
					local temp68
					local r_4531 = list_3f_1(def4)
					if r_4531 then
						local r_4541 = symbol_3f_1(car2(def4))
						if r_4541 then
							temp68 = (car2(def4)["var"] == builtins1["lambda"])
						else
							temp68 = r_4541
						end
					else
						temp68 = r_4531
					end
					if temp68 then
						local args8 = nth1(def4, 2)
						if any1((function(x29)
							return x29["var"]["isVariadic"]
						end), args8) then
							ari1 = false
						else
							ari1 = _23_1(args8)
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
	return visitBlock1(nodes16, 1, (function(node37)
		local temp69
		local r_4551 = list_3f_1(node37)
		if r_4551 then
			temp69 = symbol_3f_1(car2(node37))
		else
			temp69 = r_4551
		end
		if temp69 then
			local arity2 = getArity1(car2(node37))
			local temp70
			if arity2 then
				temp70 = (arity2 < pred1(_23_1(node37)))
			else
				temp70 = arity2
			end
			if temp70 then
				return putNodeWarning_21_1(state20["logger"], _2e2e_2("Calling ", symbol_2d3e_string1(car2(node37)), " with ", tonumber1(pred1(_23_1(node37))), " arguments, expected ", tonumber1(arity2)), node37, nil, getSource1(node37), "Called here")
			else
			end
		else
		end
	end))
end))
analyse1 = (function(nodes17, state21)
	local lookup12 = createState1()
	runPass1(tagUsage1, state21, nil, nodes17, lookup12)
	runPass1(checkArity1, state21, nil, nodes17, lookup12)
	return nodes17
end)
create2 = (function()
	return struct1("out", ({tag = "list", n = 0}), "indent", 0, "tabs-pending", false, "line", 1, "lines", ({}), "node-stack", ({tag = "list", n = 0}), "active-pos", nil)
end)
append_21_1 = (function(writer1, text2)
	local r_4681 = type1(text2)
	if (r_4681 ~= "string") then
		error1(format1("bad argment %s (expected %s, got %s)", "text", "string", r_4681), 2)
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
	local temp71
	if force1 then
		temp71 = force1
	else
		temp71 = _21_1(writer2["tabs-pending"])
	end
	if temp71 then
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
pushNode_21_1 = (function(writer8, node38)
	local range2 = getSource1(node38)
	if range2 then
		pushCdr_21_1(writer8["node-stack"], node38)
		writer8["active-pos"] = range2
		return nil
	else
	end
end)
popNode_21_1 = (function(writer9, node39)
	local range3 = getSource1(node39)
	if range3 then
		local stack1 = writer9["node-stack"]
		local previous1 = last1(stack1)
		if (previous1 == node39) then
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
estimateLength1 = (function(node40, max4)
	local tag9 = node40["tag"]
	local temp72
	local r_4571 = (tag9 == "string")
	if r_4571 then
		temp72 = r_4571
	else
		local r_4581 = (tag9 == "number")
		if r_4581 then
			temp72 = r_4581
		else
			local r_4591 = (tag9 == "symbol")
			if r_4591 then
				temp72 = r_4591
			else
				temp72 = (tag9 == "key")
			end
		end
	end
	if temp72 then
		return len1(tostring1(node40["contents"]))
	elseif (tag9 == "list") then
		local sum2 = 2
		local i4 = 1
		local r_4601 = nil
		r_4601 = (function()
			local temp73
			local r_4611 = (sum2 <= max4)
			if r_4611 then
				temp73 = (i4 <= _23_1(node40))
			else
				temp73 = r_4611
			end
			if temp73 then
				sum2 = (sum2 + estimateLength1(nth1(node40, i4), (max4 - sum2)))
				if (i4 > 1) then
					sum2 = (sum2 + 1)
				else
				end
				i4 = (i4 + 1)
				return r_4601()
			else
			end
		end)
		r_4601()
		return sum2
	else
		return fail_21_1(_2e2e_2("Unknown tag ", tag9))
	end
end)
expression1 = (function(node41, writer11)
	local tag10 = node41["tag"]
	if (tag10 == "string") then
		return append_21_1(writer11, quoted1(node41["value"]))
	elseif (tag10 == "number") then
		return append_21_1(writer11, tostring1(node41["value"]))
	elseif (tag10 == "key") then
		return append_21_1(writer11, _2e2e_2(":", node41["value"]))
	elseif (tag10 == "symbol") then
		return append_21_1(writer11, node41["contents"])
	elseif (tag10 == "list") then
		append_21_1(writer11, "(")
		if nil_3f_1(node41) then
			return append_21_1(writer11, ")")
		else
			local newline1 = false
			local max5 = (60 - estimateLength1(car2(node41), 60))
			expression1(car2(node41), writer11)
			if (max5 <= 0) then
				newline1 = true
				indent_21_1(writer11)
			else
			end
			local r_4721 = _23_1(node41)
			local r_4701 = nil
			r_4701 = (function(r_4711)
				if (r_4711 <= r_4721) then
					local entry3 = nth1(node41, r_4711)
					local temp74
					local r_4741 = _21_1(newline1)
					if r_4741 then
						temp74 = (max5 > 0)
					else
						temp74 = r_4741
					end
					if temp74 then
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
					return r_4701((r_4711 + 1))
				else
				end
			end)
			r_4701(2)
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
	local r_4661 = _23_1(list2)
	local r_4641 = nil
	r_4641 = (function(r_4651)
		if (r_4651 <= r_4661) then
			local node42 = list2[r_4651]
			expression1(node42, writer12)
			line_21_1(writer12)
			return r_4641((r_4651 + 1))
		else
		end
	end)
	return r_4641(1)
end)
cat2 = (function(category1, ...)
	local args9 = _pack(...) args9.tag = "list"
	return struct1("category", category1, unpack1(args9, 1, _23_1(args9)))
end)
visitNode2 = (function(lookup13, node43, stmt1)
	local cat3
	local r_4851 = type1(node43)
	if eq_3f_1(r_4851, "string") then
		cat3 = cat2("const")
	elseif eq_3f_1(r_4851, "number") then
		cat3 = cat2("const")
	elseif eq_3f_1(r_4851, "key") then
		cat3 = cat2("const")
	elseif eq_3f_1(r_4851, "symbol") then
		cat3 = cat2("const")
	elseif eq_3f_1(r_4851, "list") then
		local head2 = car2(node43)
		local r_4861 = type1(head2)
		if eq_3f_1(r_4861, "symbol") then
			local func7 = head2["var"]
			local funct3 = func7["tag"]
			if (func7 == builtins1["lambda"]) then
				visitNodes1(lookup13, node43, 3, true)
				cat3 = cat2("lambda")
			elseif (func7 == builtins1["cond"]) then
				local r_5001 = _23_1(node43)
				local r_4981 = nil
				r_4981 = (function(r_4991)
					if (r_4991 <= r_5001) then
						local case3 = nth1(node43, r_4991)
						visitNode2(lookup13, car2(case3), true)
						visitNodes1(lookup13, case3, 2, true)
						return r_4981((r_4991 + 1))
					else
					end
				end)
				r_4981(2)
				local temp75
				local r_5021 = (_23_1(node43) == 3)
				if r_5021 then
					local r_5031
					local sub4 = nth1(node43, 2)
					local r_5061 = (_23_1(sub4) == 2)
					if r_5061 then
						r_5031 = builtinVar_3f_1(nth1(sub4, 2), "false")
					else
						r_5031 = r_5061
					end
					if r_5031 then
						local sub5 = nth1(node43, 3)
						local r_5041 = (_23_1(sub5) == 2)
						if r_5041 then
							local r_5051 = builtinVar_3f_1(nth1(sub5, 1), "true")
							if r_5051 then
								temp75 = builtinVar_3f_1(nth1(sub5, 2), "true")
							else
								temp75 = r_5051
							end
						else
							temp75 = r_5041
						end
					else
						temp75 = r_5031
					end
				else
					temp75 = r_5021
				end
				if temp75 then
					cat3 = cat2("not", "stmt", true)
				else
					cat3 = cat2("cond", "stmt", true)
				end
			elseif (func7 == builtins1["set!"]) then
				visitNode2(lookup13, nth1(node43, 3), true)
				cat3 = cat2("set!")
			elseif (func7 == builtins1["quote"]) then
				cat3 = cat2("quote")
			elseif (func7 == builtins1["syntax-quote"]) then
				visitQuote2(lookup13, nth1(node43, 2), 1)
				cat3 = cat2("syntax-quote")
			elseif (func7 == builtins1["unquote"]) then
				cat3 = fail_21_1("unquote should never appear")
			elseif (func7 == builtins1["unquote-splice"]) then
				cat3 = fail_21_1("unquote should never appear")
			elseif (func7 == builtins1["define"]) then
				visitNode2(lookup13, nth1(node43, _23_1(node43)), true)
				cat3 = cat2("define")
			elseif (func7 == builtins1["define-macro"]) then
				visitNode2(lookup13, nth1(node43, _23_1(node43)), true)
				cat3 = cat2("define")
			elseif (func7 == builtins1["define-native"]) then
				cat3 = cat2("define-native")
			elseif (func7 == builtins1["import"]) then
				cat3 = cat2("import")
			elseif (func7 == builtinVars1["true"]) then
				visitNodes1(lookup13, node43, 1, false)
				cat3 = cat2("call-literal")
			elseif (func7 == builtinVars1["false"]) then
				visitNodes1(lookup13, node43, 1, false)
				cat3 = cat2("call-literal")
			elseif (func7 == builtinVars1["nil"]) then
				visitNodes1(lookup13, node43, 1, false)
				cat3 = cat2("call-literal")
			else
				visitNodes1(lookup13, node43, 1, false)
				cat3 = cat2("call-symbol")
			end
		elseif eq_3f_1(r_4861, "list") then
			local temp76
			if stmt1 then
				temp76 = builtin_3f_1(car2(head2), "lambda")
			else
				temp76 = stmt1
			end
			if temp76 then
				visitNodes1(lookup13, car2(node43), 3, true)
				local args10 = nth1(car2(node43), 2)
				local offset3 = 1
				local r_5101 = _23_1(args10)
				local r_5081 = nil
				r_5081 = (function(r_5091)
					if (r_5091 <= r_5101) then
						local arg25 = nth1(args10, r_5091)
						if arg25["var"]["isVariadic"] then
							local count3 = (_23_1(node43) - _23_1(args10))
							if (count3 < 0) then
								count3 = 0
							else
							end
							local r_5141 = count3
							local r_5121 = nil
							r_5121 = (function(r_5131)
								if (r_5131 <= r_5141) then
									if (nil == nth1(node43, (r_5091 + r_5131))) then
										print1("Var", pretty1(node43), r_5091, r_5131)
									else
									end
									visitNode2(lookup13, nth1(node43, (r_5091 + r_5131)), false)
									return r_5121((r_5131 + 1))
								else
								end
							end)
							r_5121(1)
							offset3 = count3
						else
							local val16 = nth1(node43, (r_5091 + offset3))
							if val16 then
								visitNode2(lookup13, val16, true)
							else
							end
						end
						return r_5081((r_5091 + 1))
					else
					end
				end)
				r_5081(1)
				local r_5181 = _23_1(node43)
				local r_5161 = nil
				r_5161 = (function(r_5171)
					if (r_5171 <= r_5181) then
						visitNode2(lookup13, nth1(node43, r_5171), true)
						return r_5161((r_5171 + 1))
					else
					end
				end)
				r_5161((_23_1(args10) + (offset3 + 1)))
				cat3 = cat2("call-lambda", "stmt", true)
			else
				local temp77
				local r_5201 = builtin_3f_1(car2(head2), "quote")
				if r_5201 then
					temp77 = r_5201
				else
					temp77 = builtin_3f_1(car2(head2), "syntax-quote")
				end
				if temp77 then
					visitNodes1(lookup13, node43, 1, false)
					cat3 = cat2("call-literal")
				else
					visitNodes1(lookup13, node43, 1, false)
					cat3 = cat2("call")
				end
			end
		elseif eq_3f_1(r_4861, true) then
			visitNodes1(lookup13, node43, 1, false)
			cat3 = cat2("call-literal")
		else
			cat3 = error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_4861), ", but none matched.\n", "  Tried: `\"symbol\"`\n  Tried: `\"list\"`\n  Tried: `true`"))
		end
	else
		cat3 = error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_4851), ", but none matched.\n", "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"key\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`"))
	end
	lookup13[node43] = cat3
	return cat3
end)
visitNodes1 = (function(lookup14, nodes18, start7, stmt2)
	local r_4891 = _23_1(nodes18)
	local r_4871 = nil
	r_4871 = (function(r_4881)
		if (r_4881 <= r_4891) then
			visitNode2(lookup14, nth1(nodes18, r_4881), stmt2)
			return r_4871((r_4881 + 1))
		else
		end
	end)
	return r_4871(start7)
end)
visitQuote2 = (function(lookup15, node44, level3)
	if (level3 == 0) then
		return visitNode2(lookup15, node44, false)
	else
		if list_3f_1(node44) then
			local r_4911 = car2(node44)
			if eq_3f_1(r_4911, ({ tag="symbol", contents="unquote"})) then
				return visitQuote2(lookup15, nth1(node44, 2), pred1(level3))
			elseif eq_3f_1(r_4911, ({ tag="symbol", contents="unquote-splice"})) then
				return visitQuote2(lookup15, nth1(node44, 2), pred1(level3))
			elseif eq_3f_1(r_4911, ({ tag="symbol", contents="syntax-quote"})) then
				return visitQuote2(lookup15, nth1(node44, 2), succ1(level3))
			else
				local r_4961 = _23_1(node44)
				local r_4941 = nil
				r_4941 = (function(r_4951)
					if (r_4951 <= r_4961) then
						local child1 = node44[r_4951]
						visitQuote2(lookup15, child1, level3)
						return r_4941((r_4951 + 1))
					else
					end
				end)
				return r_4941(1)
			end
		else
		end
	end
end)
categoriseNodes1 = struct1("name", "categorise-nodes", "help", "Categorise a group of NODES, annotating their appropriate node type.", "cat", ({tag = "list", n = 1, "categorise"}), "run", (function(r_37412, state22, nodes19, lookup16)
	return visitNodes1(lookup16, nodes19, 1, true)
end))
categoriseNode1 = struct1("name", "categorise-node", "help", "Categorise a NODE, annotating it's appropriate node type.", "cat", ({tag = "list", n = 1, "categorise"}), "run", (function(r_37413, state23, node45, lookup17, stmt3)
	return visitNode2(lookup17, node45, stmt3)
end))
createLookup1 = (function(...)
	local lst2 = _pack(...) lst2.tag = "list"
	local out5 = ({})
	local r_5251 = _23_1(lst2)
	local r_5231 = nil
	r_5231 = (function(r_5241)
		if (r_5241 <= r_5251) then
			local entry4 = lst2[r_5241]
			out5[entry4] = true
			return r_5231((r_5241 + 1))
		else
		end
	end)
	r_5231(1)
	return out5
end)
keywords1 = createLookup1("and", "break", "do", "else", "elseif", "end", "false", "for", "function", "if", "in", "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while")
escape1 = (function(name8)
	if keywords1[name8] then
		return _2e2e_2("_e", name8)
	elseif find1(name8, "^%w[_%w%d]*$") then
		return name8
	else
		local out6
		local temp78
		local r_5401 = charAt1(name8, 1)
		temp78 = find1(r_5401, "%d")
		if temp78 then
			out6 = "_e"
		else
			out6 = ""
		end
		local upper2 = false
		local esc1 = false
		local r_5291 = len1(name8)
		local r_5271 = nil
		r_5271 = (function(r_5281)
			if (r_5281 <= r_5291) then
				local char2 = charAt1(name8, r_5281)
				local temp79
				local r_5311 = (char2 == "-")
				if r_5311 then
					local r_5321
					local r_5361 = charAt1(name8, pred1(r_5281))
					r_5321 = find1(r_5361, "[%a%d']")
					if r_5321 then
						local r_5341 = charAt1(name8, succ1(r_5281))
						temp79 = find1(r_5341, "[%a%d']")
					else
						temp79 = r_5321
					end
				else
					temp79 = r_5311
				end
				if temp79 then
					upper2 = true
				elseif find1(char2, "[^%w%d]") then
					local r_5381
					local r_5371 = char2
					r_5381 = byte1(r_5371)
					char2 = format1("%02x", r_5381)
					if esc1 then
					else
						esc1 = true
						out6 = _2e2e_2(out6, "_")
					end
					out6 = _2e2e_2(out6, char2)
				else
					if esc1 then
						esc1 = false
						out6 = _2e2e_2(out6, "_")
					else
					end
					if upper2 then
						upper2 = false
						char2 = upper1(char2)
					else
					end
					out6 = _2e2e_2(out6, char2)
				end
				return r_5271((r_5281 + 1))
			else
			end
		end)
		r_5271(1)
		if esc1 then
			out6 = _2e2e_2(out6, "_")
		else
		end
		return out6
	end
end)
escapeVar1 = (function(var11, state24)
	if builtinVars1[var11] then
		return var11["name"]
	else
		local v3 = escape1(var11["name"])
		local id2 = state24["var-lookup"][var11]
		if id2 then
		else
			id2 = succ1((function(r_5411)
				if r_5411 then
					return r_5411
				else
					return 0
				end
			end)(state24["ctr-lookup"][v3]))
			state24["ctr-lookup"][v3] = id2
			state24["var-lookup"][var11] = id2
		end
		return _2e2e_2(v3, tostring1(id2))
	end
end)
truthy_3f_1 = (function(node46)
	local r_4801 = symbol_3f_1(node46)
	if r_4801 then
		return (builtinVars1["true"] == node46["var"])
	else
		return r_4801
	end
end)
boringCategories1 = struct1("const", true, "quote", true, "not", true, "condtrue")
compileQuote1 = (function(node47, out7, state25, level4)
	if (level4 == 0) then
		return compileExpression1(node47, out7, state25)
	else
		local ty5 = type1(node47)
		if (ty5 == "string") then
			return append_21_1(out7, quoted1(node47["value"]))
		elseif (ty5 == "number") then
			return append_21_1(out7, tostring1(node47["value"]))
		elseif (ty5 == "symbol") then
			append_21_1(out7, _2e2e_2("({ tag=\"symbol\", contents=", quoted1(node47["contents"])))
			if node47["var"] then
				append_21_1(out7, _2e2e_2(", var=", quoted1(tostring1(node47["var"]))))
			else
			end
			return append_21_1(out7, "})")
		elseif (ty5 == "key") then
			return append_21_1(out7, _2e2e_2("({tag=\"key\", value=", quoted1(node47["value"]), "})"))
		elseif (ty5 == "list") then
			local first6 = car2(node47)
			local temp80
			local r_5421 = symbol_3f_1(first6)
			if r_5421 then
				local r_5431 = (first6["var"] == builtins1["unquote"])
				if r_5431 then
					temp80 = r_5431
				else
					temp80 = ("var" == builtins1["unquote-splice"])
				end
			else
				temp80 = r_5421
			end
			if temp80 then
				return compileQuote1(nth1(node47, 2), out7, state25, (function()
					if level4 then
						return pred1(level4)
					else
						return level4
					end
				end)()
				)
			else
				local temp81
				local r_5451 = symbol_3f_1(first6)
				if r_5451 then
					temp81 = (first6["var"] == builtins1["syntax-quote"])
				else
					temp81 = r_5451
				end
				if temp81 then
					return compileQuote1(nth1(node47, 2), out7, state25, (function()
						if level4 then
							return succ1(level4)
						else
							return level4
						end
					end)()
					)
				else
					pushNode_21_1(out7, node47)
					local containsUnsplice1 = false
					local r_5511 = _23_1(node47)
					local r_5491 = nil
					r_5491 = (function(r_5501)
						if (r_5501 <= r_5511) then
							local sub6 = node47[r_5501]
							local temp82
							local r_5531 = list_3f_1(sub6)
							if r_5531 then
								local r_5541 = symbol_3f_1(car2(sub6))
								if r_5541 then
									temp82 = (sub6[1]["var"] == builtins1["unquote-splice"])
								else
									temp82 = r_5541
								end
							else
								temp82 = r_5531
							end
							if temp82 then
								containsUnsplice1 = true
							else
							end
							return r_5491((r_5501 + 1))
						else
						end
					end)
					r_5491(1)
					if containsUnsplice1 then
						local offset4 = 0
						beginBlock_21_1(out7, "(function()")
						line_21_1(out7, "local _offset, _result, _temp = 0, {tag=\"list\",n=0}")
						local r_5571 = _23_1(node47)
						local r_5551 = nil
						r_5551 = (function(r_5561)
							if (r_5561 <= r_5571) then
								local sub7 = nth1(node47, r_5561)
								local temp83
								local r_5591 = list_3f_1(sub7)
								if r_5591 then
									local r_5601 = symbol_3f_1(car2(sub7))
									if r_5601 then
										temp83 = (sub7[1]["var"] == builtins1["unquote-splice"])
									else
										temp83 = r_5601
									end
								else
									temp83 = r_5591
								end
								if temp83 then
									offset4 = (offset4 + 1)
									append_21_1(out7, "_temp = ")
									compileQuote1(nth1(sub7, 2), out7, state25, pred1(level4))
									line_21_1(out7)
									line_21_1(out7, _2e2e_2("for _c = 1, _temp.n do _result[", tostring1((r_5561 - offset4)), " + _c + _offset] = _temp[_c] end"))
									line_21_1(out7, "_offset = _offset + _temp.n")
								else
									append_21_1(out7, _2e2e_2("_result[", tostring1((r_5561 - offset4)), " + _offset] = "))
									compileQuote1(sub7, out7, state25, level4)
									line_21_1(out7)
								end
								return r_5551((r_5561 + 1))
							else
							end
						end)
						r_5551(1)
						line_21_1(out7, _2e2e_2("_result.n = _offset + ", tostring1((_23_1(node47) - offset4))))
						line_21_1(out7, "return _result")
						endBlock_21_1(out7, "end)()")
					else
						append_21_1(out7, _2e2e_2("({tag = \"list\", n = ", tostring1(_23_1(node47))))
						local r_5651 = _23_1(node47)
						local r_5631 = nil
						r_5631 = (function(r_5641)
							if (r_5641 <= r_5651) then
								local sub8 = node47[r_5641]
								append_21_1(out7, ", ")
								compileQuote1(sub8, out7, state25, level4)
								return r_5631((r_5641 + 1))
							else
							end
						end)
						r_5631(1)
						append_21_1(out7, "})")
					end
					return popNode_21_1(out7, node47)
				end
			end
		else
			return error1(_2e2e_2("Unknown type ", ty5))
		end
	end
end)
compileExpression1 = (function(node48, out8, state26, ret1)
	local catLookup1 = state26["cat-lookup"]
	local cat4 = catLookup1[node48]
	local _5f_3
	if cat4 then
	else
		_5f_3 = print1("Cannot find", pretty1(node48), formatNode1(node48))
	end
	local catTag1 = cat4["category"]
	if boringCategories1[catTag1] then
	else
		pushNode_21_1(out8, node48)
	end
	if eq_3f_1(catTag1, "const") then
		if (ret1 == "") then
		else
			if ret1 then
				append_21_1(out8, ret1)
			else
			end
			if symbol_3f_1(node48) then
				append_21_1(out8, escapeVar1(node48["var"], state26))
			elseif string_3f_1(node48) then
				append_21_1(out8, quoted1(node48["value"]))
			elseif number_3f_1(node48) then
				append_21_1(out8, tostring1(node48["value"]))
			elseif key_3f_1(node48) then
				append_21_1(out8, quoted1(node48["value"]))
			else
				error1(_2e2e_2("Unknown type: ", type1(node48)))
			end
		end
	elseif eq_3f_1(catTag1, "lambda") then
		if (ret1 == "") then
		else
			if ret1 then
				append_21_1(out8, ret1)
			else
			end
			local args11 = nth1(node48, 2)
			local variadic1 = nil
			local i5 = 1
			append_21_1(out8, "(function(")
			local r_5681 = nil
			r_5681 = (function()
				local temp84
				local r_5691 = (i5 <= _23_1(args11))
				if r_5691 then
					temp84 = _21_1(variadic1)
				else
					temp84 = r_5691
				end
				if temp84 then
					if (i5 > 1) then
						append_21_1(out8, ", ")
					else
					end
					local var12 = args11[i5]["var"]
					if var12["isVariadic"] then
						append_21_1(out8, "...")
						variadic1 = i5
					else
						append_21_1(out8, escapeVar1(var12, state26))
					end
					i5 = (i5 + 1)
					return r_5681()
				else
				end
			end)
			r_5681()
			beginBlock_21_1(out8, ")")
			if variadic1 then
				local argsVar1 = escapeVar1(args11[variadic1]["var"], state26)
				if (variadic1 == _23_1(args11)) then
					line_21_1(out8, _2e2e_2("local ", argsVar1, " = _pack(...) ", argsVar1, ".tag = \"list\""))
				else
					local remaining1 = (_23_1(args11) - variadic1)
					line_21_1(out8, _2e2e_2("local _n = _select(\"#\", ...) - ", tostring1(remaining1)))
					append_21_1(out8, _2e2e_2("local ", argsVar1))
					local r_5721 = _23_1(args11)
					local r_5701 = nil
					r_5701 = (function(r_5711)
						if (r_5711 <= r_5721) then
							append_21_1(out8, ", ")
							append_21_1(out8, escapeVar1(args11[r_5711]["var"], state26))
							return r_5701((r_5711 + 1))
						else
						end
					end)
					r_5701(succ1(variadic1))
					line_21_1(out8)
					beginBlock_21_1(out8, "if _n > 0 then")
					append_21_1(out8, argsVar1)
					line_21_1(out8, " = { tag=\"list\", n=_n, _unpack(_pack(...), 1, _n)}")
					local r_5761 = _23_1(args11)
					local r_5741 = nil
					r_5741 = (function(r_5751)
						if (r_5751 <= r_5761) then
							append_21_1(out8, escapeVar1(args11[r_5751]["var"], state26))
							if (r_5751 < _23_1(args11)) then
								append_21_1(out8, ", ")
							else
							end
							return r_5741((r_5751 + 1))
						else
						end
					end)
					r_5741(succ1(variadic1))
					line_21_1(out8, " = select(_n + 1, ...)")
					nextBlock_21_1(out8, "else")
					append_21_1(out8, argsVar1)
					line_21_1(out8, " = { tag=\"list\", n=0}")
					local r_5801 = _23_1(args11)
					local r_5781 = nil
					r_5781 = (function(r_5791)
						if (r_5791 <= r_5801) then
							append_21_1(out8, escapeVar1(args11[r_5791]["var"], state26))
							if (r_5791 < _23_1(args11)) then
								append_21_1(out8, ", ")
							else
							end
							return r_5781((r_5791 + 1))
						else
						end
					end)
					r_5781(succ1(variadic1))
					line_21_1(out8, " = ...")
					endBlock_21_1(out8, "end")
				end
			else
			end
			compileBlock1(node48, out8, state26, 3, "return ")
			unindent_21_1(out8)
			append_21_1(out8, "end)")
		end
	elseif eq_3f_1(catTag1, "cond") then
		local closure1 = _21_1(ret1)
		local hadFinal1 = false
		local ends1 = 1
		if closure1 then
			beginBlock_21_1(out8, "(function()")
			ret1 = "return "
		else
		end
		local i6 = 2
		local r_5821 = nil
		r_5821 = (function()
			local temp85
			local r_5831 = _21_1(hadFinal1)
			if r_5831 then
				temp85 = (i6 <= _23_1(node48))
			else
				temp85 = r_5831
			end
			if temp85 then
				local item1 = nth1(node48, i6)
				local case4 = nth1(item1, 1)
				local isFinal1 = truthy_3f_1(case4)
				if isFinal1 then
					if (i6 == 2) then
						append_21_1(out8, "do")
					else
					end
				elseif catLookup1[case4]["stmt"] then
					if (i6 > 2) then
						indent_21_1(out8)
						line_21_1(out8)
						ends1 = (ends1 + 1)
					else
					end
					local tmp1 = escapeVar1(struct1("name", "temp"), state26)
					line_21_1(out8, _2e2e_2("local ", tmp1))
					compileExpression1(case4, out8, state26, _2e2e_2(tmp1, " = "))
					line_21_1(out8)
					line_21_1(out8, _2e2e_2("if ", tmp1, " then"))
				else
					append_21_1(out8, "if ")
					compileExpression1(case4, out8, state26)
					append_21_1(out8, " then")
				end
				indent_21_1(out8)
				line_21_1(out8)
				compileBlock1(item1, out8, state26, 2, ret1)
				unindent_21_1(out8)
				if isFinal1 then
					hadFinal1 = true
				else
					append_21_1(out8, "else")
				end
				i6 = (i6 + 1)
				return r_5821()
			else
			end
		end)
		r_5821()
		if hadFinal1 then
		else
			indent_21_1(out8)
			line_21_1(out8)
			append_21_1(out8, "_error(\"unmatched item\")")
			unindent_21_1(out8)
			line_21_1(out8)
		end
		local r_5861 = ends1
		local r_5841 = nil
		r_5841 = (function(r_5851)
			if (r_5851 <= r_5861) then
				append_21_1(out8, "end")
				if (r_5851 < ends1) then
					unindent_21_1(out8)
					line_21_1(out8)
				else
				end
				return r_5841((r_5851 + 1))
			else
			end
		end)
		r_5841(1)
		if closure1 then
			line_21_1(out8)
			endBlock_21_1(out8, "end)()")
		else
		end
	elseif eq_3f_1(catTag1, "not") then
		if ret1 then
			ret1 = _2e2e_2(ret1, "not ")
		else
			append_21_1(out8, "not ")
		end
		compileExpression1(car2(nth1(node48, 2)), out8, state26, ret1)
	elseif eq_3f_1(catTag1, "set!") then
		compileExpression1(nth1(node48, 3), out8, state26, _2e2e_2(escapeVar1(node48[2]["var"], state26), " = "))
		local temp86
		local r_5881 = ret1
		if r_5881 then
			temp86 = (ret1 ~= "")
		else
			temp86 = r_5881
		end
		if temp86 then
			line_21_1(out8)
			append_21_1(out8, ret1)
			append_21_1(out8, "nil")
		else
		end
	elseif eq_3f_1(catTag1, "define") then
		compileExpression1(nth1(node48, _23_1(node48)), out8, state26, _2e2e_2(escapeVar1(node48["defVar"], state26), " = "))
	elseif eq_3f_1(catTag1, "define-native") then
		local meta2 = state26["meta"][node48["defVar"]["fullName"]]
		local ty6 = type1(meta2)
		if (ty6 == "nil") then
			append_21_1(out8, format1("%s = _libs[%q]", escapeVar1(node48["defVar"], state26), node48["defVar"]["fullName"]))
		elseif (ty6 == "var") then
			append_21_1(out8, format1("%s = %s", escapeVar1(node48["defVar"], state26), meta2["contents"]))
		else
			local temp87
			local r_5891 = (ty6 == "expr")
			if r_5891 then
				temp87 = r_5891
			else
				temp87 = (ty6 == "stmt")
			end
			if temp87 then
				local count4 = meta2["count"]
				append_21_1(out8, format1("%s = function(", escapeVar1(node48["defVar"], state26)))
				local r_5901 = nil
				r_5901 = (function(r_5911)
					if (r_5911 <= count4) then
						if (r_5911 == 1) then
						else
							append_21_1(out8, ", ")
						end
						append_21_1(out8, _2e2e_2("v", tonumber1(r_5911)))
						return r_5901((r_5911 + 1))
					else
					end
				end)
				r_5901(1)
				append_21_1(out8, ") ")
				if (ty6 == "expr") then
					append_21_1(out8, "return ")
				else
				end
				local r_5951 = meta2["contents"]
				local r_5981 = _23_1(r_5951)
				local r_5961 = nil
				r_5961 = (function(r_5971)
					if (r_5971 <= r_5981) then
						local entry5 = r_5951[r_5971]
						if number_3f_1(entry5) then
							append_21_1(out8, _2e2e_2("v", tonumber1(entry5)))
						else
							append_21_1(out8, entry5)
						end
						return r_5961((r_5971 + 1))
					else
					end
				end)
				r_5961(1)
				append_21_1(out8, " end")
			else
				_error("unmatched item")
			end
		end
	elseif eq_3f_1(catTag1, "quote") then
		if (ret1 == "") then
		else
			if ret1 then
				append_21_1(out8, ret1)
			else
			end
			compileQuote1(nth1(node48, 2), out8, state26)
		end
	elseif eq_3f_1(catTag1, "syntax-quote") then
		if (ret1 == "") then
			append_21_1(out8, "local _ =")
		elseif ret1 then
			append_21_1(out8, ret1)
		else
		end
		compileQuote1(nth1(node48, 2), out8, state26, 1)
	elseif eq_3f_1(catTag1, "import") then
		if (ret1 == nil) then
			append_21_1(out8, "nil")
		elseif (ret1 ~= "") then
			append_21_1(out8, ret1)
			append_21_1(out8, "nil")
		else
		end
	elseif eq_3f_1(catTag1, "call-symbol") then
		local head3 = car2(node48)
		local meta3
		local r_6111 = symbol_3f_1(head3)
		if r_6111 then
			local r_6121 = (head3["var"]["tag"] == "native")
			if r_6121 then
				meta3 = state26["meta"][head3["var"]["fullName"]]
			else
				meta3 = r_6121
			end
		else
			meta3 = r_6111
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
		local temp88
		local r_6001 = meta3
		if r_6001 then
			temp88 = (pred1(_23_1(node48)) == meta3["count"])
		else
			temp88 = r_6001
		end
		if temp88 then
			local temp89
			local r_6011 = ret1
			if r_6011 then
				temp89 = (meta3["tag"] == "expr")
			else
				temp89 = r_6011
			end
			if temp89 then
				append_21_1(out8, ret1)
			else
			end
			local contents2 = meta3["contents"]
			local r_6041 = _23_1(contents2)
			local r_6021 = nil
			r_6021 = (function(r_6031)
				if (r_6031 <= r_6041) then
					local entry6 = nth1(contents2, r_6031)
					if number_3f_1(entry6) then
						compileExpression1(nth1(node48, succ1(entry6)), out8, state26)
					else
						append_21_1(out8, entry6)
					end
					return r_6021((r_6031 + 1))
				else
				end
			end)
			r_6021(1)
			local temp90
			local r_6061 = (meta3["tag"] ~= "expr")
			if r_6061 then
				temp90 = (ret1 ~= "")
			else
				temp90 = r_6061
			end
			if temp90 then
				line_21_1(out8)
				append_21_1(out8, ret1)
				append_21_1(out8, "nil")
				line_21_1(out8)
			else
			end
		else
			if ret1 then
				append_21_1(out8, ret1)
			else
			end
			compileExpression1(head3, out8, state26)
			append_21_1(out8, "(")
			local r_6091 = _23_1(node48)
			local r_6071 = nil
			r_6071 = (function(r_6081)
				if (r_6081 <= r_6091) then
					if (r_6081 > 2) then
						append_21_1(out8, ", ")
					else
					end
					compileExpression1(nth1(node48, r_6081), out8, state26)
					return r_6071((r_6081 + 1))
				else
				end
			end)
			r_6071(2)
			append_21_1(out8, ")")
		end
	elseif eq_3f_1(catTag1, "call-lambda") then
		if (ret1 == nil) then
			print1(pretty1(node48), " marked as call-lambda for ", ret1)
		else
		end
		local head4 = car2(node48)
		local args12 = nth1(head4, 2)
		local offset5 = 1
		local r_6151 = _23_1(args12)
		local r_6131 = nil
		r_6131 = (function(r_6141)
			if (r_6141 <= r_6151) then
				local var13 = args12[r_6141]["var"]
				local esc2 = escapeVar1(var13, state26)
				append_21_1(out8, _2e2e_2("local ", esc2))
				if var13["isVariadic"] then
					local count5 = (_23_1(node48) - _23_1(args12))
					if (count5 < 0) then
						count5 = 0
					else
					end
					local temp91
					local r_6171 = (count5 <= 0)
					if r_6171 then
						temp91 = r_6171
					else
						temp91 = atom_3f_1(nth1(node48, (r_6141 + count5)))
					end
					if temp91 then
						append_21_1(out8, " = { tag=\"list\", n=")
						append_21_1(out8, tostring1(count5))
						local r_6201 = count5
						local r_6181 = nil
						r_6181 = (function(r_6191)
							if (r_6191 <= r_6201) then
								append_21_1(out8, ", ")
								compileExpression1(nth1(node48, (r_6141 + r_6191)), out8, state26)
								return r_6181((r_6191 + 1))
							else
							end
						end)
						r_6181(1)
						line_21_1(out8, "}")
					else
						append_21_1(out8, " = _pack(")
						local r_6241 = count5
						local r_6221 = nil
						r_6221 = (function(r_6231)
							if (r_6231 <= r_6241) then
								if (r_6231 > 1) then
									append_21_1(out8, ", ")
								else
								end
								compileExpression1(nth1(node48, (r_6141 + r_6231)), out8, state26)
								return r_6221((r_6231 + 1))
							else
							end
						end)
						r_6221(1)
						line_21_1(out8, ")")
						line_21_1(out8, _2e2e_2(esc2, ".tag = \"list\""))
					end
					offset5 = count5
				else
					local expr2 = nth1(node48, (r_6141 + offset5))
					local name9 = escapeVar1(var13, state26)
					local ret2 = nil
					if expr2 then
						if catLookup1[expr2]["stmt"] then
							ret2 = _2e2e_2(name9, " = ")
							line_21_1(out8)
						else
							append_21_1(out8, " = ")
						end
						compileExpression1(expr2, out8, state26, ret2)
						line_21_1(out8)
					else
						line_21_1(out8)
					end
				end
				return r_6131((r_6141 + 1))
			else
			end
		end)
		r_6131(1)
		local r_6281 = _23_1(node48)
		local r_6261 = nil
		r_6261 = (function(r_6271)
			if (r_6271 <= r_6281) then
				compileExpression1(nth1(node48, r_6271), out8, state26, "")
				line_21_1(out8)
				return r_6261((r_6271 + 1))
			else
			end
		end)
		r_6261((_23_1(args12) + (offset5 + 1)))
		compileBlock1(head4, out8, state26, 3, ret1)
	elseif eq_3f_1(catTag1, "call-literal") then
		if ret1 then
			append_21_1(out8, ret1)
		else
		end
		append_21_1(out8, "(")
		compileExpression1(car2(node48), out8, state26)
		append_21_1(out8, ")(")
		local r_6321 = _23_1(node48)
		local r_6301 = nil
		r_6301 = (function(r_6311)
			if (r_6311 <= r_6321) then
				if (r_6311 > 2) then
					append_21_1(out8, ", ")
				else
				end
				compileExpression1(nth1(node48, r_6311), out8, state26)
				return r_6301((r_6311 + 1))
			else
			end
		end)
		r_6301(2)
		append_21_1(out8, ")")
	elseif eq_3f_1(catTag1, "call") then
		if ret1 then
			append_21_1(out8, ret1)
		else
		end
		compileExpression1(car2(node48), out8, state26)
		append_21_1(out8, "(")
		local r_6361 = _23_1(node48)
		local r_6341 = nil
		r_6341 = (function(r_6351)
			if (r_6351 <= r_6361) then
				if (r_6351 > 2) then
					append_21_1(out8, ", ")
				else
				end
				compileExpression1(nth1(node48, r_6351), out8, state26)
				return r_6341((r_6351 + 1))
			else
			end
		end)
		r_6341(2)
		append_21_1(out8, ")")
	else
		error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(catTag1), ", but none matched.\n", "  Tried: `\"const\"`\n  Tried: `\"lambda\"`\n  Tried: `\"cond\"`\n  Tried: `\"not\"`\n  Tried: `\"set!\"`\n  Tried: `\"define\"`\n  Tried: `\"define-native\"`\n  Tried: `\"quote\"`\n  Tried: `\"syntax-quote\"`\n  Tried: `\"import\"`\n  Tried: `\"call-symbol\"`\n  Tried: `\"call-lambda\"`\n  Tried: `\"call-literal\"`\n  Tried: `\"call\"`"))
	end
	if boringCategories1[catTag1] then
	else
		return popNode_21_1(out8, node48)
	end
end)
compileBlock1 = (function(nodes20, out9, state27, start8, ret3)
	local r_4831 = _23_1(nodes20)
	local r_4811 = nil
	r_4811 = (function(r_4821)
		if (r_4821 <= r_4831) then
			local ret_27_1
			if (r_4821 == _23_1(nodes20)) then
				ret_27_1 = ret3
			else
				ret_27_1 = ""
			end
			compileExpression1(nth1(nodes20, r_4821), out9, state27, ret_27_1)
			line_21_1(out9)
			return r_4811((r_4821 + 1))
		else
		end
	end)
	return r_4811(start8)
end)
prelude1 = (function(out10)
	line_21_1(out10, "if not table.pack then table.pack = function(...) return { n = select(\"#\", ...), ... } end end")
	line_21_1(out10, "if not table.unpack then table.unpack = unpack end")
	line_21_1(out10, "local load = load if _VERSION:find(\"5.1\") then load = function(x, n, _, env) local f, e = loadstring(x, n) if not f then error(e, 2) end if env then setfenv(f, env) end return f end end")
	return line_21_1(out10, "local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error")
end)
expression2 = (function(node49, out11, state28, ret4)
	runPass1(categoriseNode1, state28, nil, node49, state28["cat-lookup"], (ret4 ~= nil))
	return compileExpression1(node49, out11, state28, ret4)
end)
block2 = (function(nodes21, out12, state29, start9, ret5)
	runPass1(categoriseNodes1, state29, nil, nodes21, state29["cat-lookup"])
	return compileBlock1(nodes21, out12, state29, start9, ret5)
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
		local pos5 = 0
		local len6 = len1(esc3)
		local r_6381 = nil
		r_6381 = (function()
			if (pos5 <= len6) then
				local char3 = charAt1(esc3, pos5)
				if (char3 == "_") then
					local r_6391 = list1(find1(esc3, "^_[%da-z]+_", pos5))
					local temp92
					local r_6411 = list_3f_1(r_6391)
					if r_6411 then
						local r_6421 = (_23_1(r_6391) == 2)
						if r_6421 then
							temp92 = true
						else
							temp92 = r_6421
						end
					else
						temp92 = r_6411
					end
					if temp92 then
						local start10 = nth1(r_6391, 1)
						local _eend1 = nth1(r_6391, 2)
						pos5 = (pos5 + 1)
						local r_6441 = nil
						r_6441 = (function()
							if (pos5 < _eend1) then
								pushCdr_21_1(buffer2, char1(tonumber1(sub1(esc3, pos5, succ1(pos5)), 16)))
								pos5 = (pos5 + 2)
								return r_6441()
							else
							end
						end)
						r_6441()
					else
						pushCdr_21_1(buffer2, "_")
					end
				elseif between_3f_1(char3, "A", "Z") then
					pushCdr_21_1(buffer2, "-")
					pushCdr_21_1(buffer2, lower1(char3))
				else
					pushCdr_21_1(buffer2, char3)
				end
				pos5 = (pos5 + 1)
				return r_6381()
			else
			end
		end)
		r_6381()
		return concat1(buffer2)
	end
end)
remapError1 = (function(msg9)
	local res5
	local r_6481
	local r_6471
	local r_6461 = gsub1(msg9, "local '([^']+)'", (function(x30)
		return _2e2e_2("local '", unmangleIdent1(x30), "'")
	end))
	r_6471 = gsub1(r_6461, "global '([^']+)'", (function(x31)
		return _2e2e_2("global '", unmangleIdent1(x31), "'")
	end))
	r_6481 = gsub1(r_6471, "upvalue '([^']+)'", (function(x32)
		return _2e2e_2("upvalue '", unmangleIdent1(x32), "'")
	end))
	res5 = gsub1(r_6481, "function '([^']+)'", (function(x33)
		return _2e2e_2("function '", unmangleIdent1(x33), "'")
	end))
	return res5
end)
remapMessage1 = (function(mappings1, msg10)
	local r_6491 = list1(match1(msg10, "^(.-):(%d+)(.*)$"))
	local temp93
	local r_6511 = list_3f_1(r_6491)
	if r_6511 then
		local r_6521 = (_23_1(r_6491) == 3)
		if r_6521 then
			temp93 = true
		else
			temp93 = r_6521
		end
	else
		temp93 = r_6511
	end
	if temp93 then
		local file1 = nth1(r_6491, 1)
		local line2 = nth1(r_6491, 2)
		local extra1 = nth1(r_6491, 3)
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
	local r_6611
	local r_6601
	local r_6591
	local r_6581
	local r_6571
	local r_6561 = gsub1(msg11, "^([^\n:]-:%d+:[^\n]*)", (function(r_6621)
		return remapMessage1(mappings2, r_6621)
	end))
	r_6571 = gsub1(r_6561, "\9([^\n:]-:%d+:)", (function(msg12)
		return _2e2e_2("\9", remapMessage1(mappings2, msg12))
	end))
	r_6581 = gsub1(r_6571, "<([^\n:]-:%d+)>\n", (function(msg13)
		return _2e2e_2("<", remapMessage1(mappings2, msg13), ">\n")
	end))
	r_6591 = gsub1(r_6581, "in local '([^']+)'\n", (function(x34)
		return _2e2e_2("in local '", unmangleIdent1(x34), "'\n")
	end))
	r_6601 = gsub1(r_6591, "in global '([^']+)'\n", (function(x35)
		return _2e2e_2("in global '", unmangleIdent1(x35), "'\n")
	end))
	r_6611 = gsub1(r_6601, "in upvalue '([^']+)'\n", (function(x36)
		return _2e2e_2("in upvalue '", unmangleIdent1(x36), "'\n")
	end))
	return gsub1(r_6611, "in function '([^']+)'\n", (function(x37)
		return _2e2e_2("in function '", unmangleIdent1(x37), "'\n")
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
			local r_6651 = pos6["finish"]["line"]
			local r_6631 = nil
			r_6631 = (function(r_6641)
				if (r_6641 <= r_6651) then
					if rangeList1[r_6641] then
					else
						rangeList1["n"] = succ1(rangeList1["n"])
						rangeList1[r_6641] = true
						if (r_6641 < rangeList1["min"]) then
							rangeList1["min"] = r_6641
						else
						end
						if (r_6641 > rangeList1["max"]) then
							rangeList1["max"] = r_6641
						else
						end
					end
					return r_6631((r_6641 + 1))
				else
				end
			end)
			return r_6631(pos6["start"]["line"])
		end))
		local bestName1 = nil
		local bestLines1 = nil
		local bestCount1 = 0
		iterPairs1(rangeLists1, (function(name10, lines5)
			if (lines5["n"] > bestCount1) then
				bestName1 = name10
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
	return struct1("level", 1, "override", ({}), "count", 0, "mappings", ({}), "cat-lookup", ({}), "ctr-lookup", ({}), "var-lookup", ({}), "meta", (function()
		if meta4 then
			return meta4
		else
			return ({})
		end
	end)()
	)
end)
file3 = (function(compiler1, shebang1)
	local state30 = createState2(compiler1["libMeta"])
	local out13 = create2()
	if shebang1 then
		line_21_1(out13, _2e2e_2("#!/usr/bin/env ", shebang1))
	else
	end
	state30["trace"] = true
	prelude1(out13)
	line_21_1(out13, "local _libs = {}")
	local r_6881 = compiler1["libs"]
	local r_6911 = _23_1(r_6881)
	local r_6891 = nil
	r_6891 = (function(r_6901)
		if (r_6901 <= r_6911) then
			local lib1 = r_6881[r_6901]
			local prefix1 = quoted1(lib1["prefix"])
			local native1 = lib1["native"]
			if native1 then
				line_21_1(out13, "local _temp = (function()")
				local r_6941 = split1(native1, "\n")
				local r_6971 = _23_1(r_6941)
				local r_6951 = nil
				r_6951 = (function(r_6961)
					if (r_6961 <= r_6971) then
						local line4 = r_6941[r_6961]
						if (line4 ~= "") then
							append_21_1(out13, "\9")
							line_21_1(out13, line4)
						else
						end
						return r_6951((r_6961 + 1))
					else
					end
				end)
				r_6951(1)
				line_21_1(out13, "end)()")
				line_21_1(out13, _2e2e_2("for k, v in pairs(_temp) do _libs[", prefix1, ".. k] = v end"))
			else
			end
			return r_6891((r_6901 + 1))
		else
		end
	end)
	r_6891(1)
	local count6 = 0
	local r_7001 = compiler1["out"]
	local r_7031 = _23_1(r_7001)
	local r_7011 = nil
	r_7011 = (function(r_7021)
		if (r_7021 <= r_7031) then
			local node50 = r_7001[r_7021]
			local var14 = node50["defVar"]
			if var14 then
				count6 = (count6 + 1)
			else
			end
			return r_7011((r_7021 + 1))
		else
		end
	end)
	r_7011(1)
	if between_3f_1(count6, 1, 150) then
		append_21_1(out13, "local ")
		local first7 = true
		local r_7061 = compiler1["out"]
		local r_7091 = _23_1(r_7061)
		local r_7071 = nil
		r_7071 = (function(r_7081)
			if (r_7081 <= r_7091) then
				local node51 = r_7061[r_7081]
				local var15 = node51["defVar"]
				if var15 then
					if first7 then
						first7 = false
					else
						append_21_1(out13, ", ")
					end
					append_21_1(out13, escapeVar1(var15, state30))
				else
				end
				return r_7071((r_7081 + 1))
			else
			end
		end)
		r_7071(1)
		line_21_1(out13)
	else
	end
	block2(compiler1["out"], out13, state30, 1, "return ")
	return out13
end)
executeStates1 = (function(backState1, states1, global1, logger8)
	local stateList1 = ({tag = "list", n = 0})
	local nameList1 = ({tag = "list", n = 0})
	local exportList1 = ({tag = "list", n = 0})
	local escapeList1 = ({tag = "list", n = 0})
	local r_4761 = nil
	r_4761 = (function(r_4771)
		if (r_4771 >= 1) then
			local state31 = nth1(states1, r_4771)
			if (state31["stage"] == "executed") then
			else
				local node52
				if state31["node"] then
				else
					node52 = error1(_2e2e_2("State is in ", state31["stage"], " instead"), 0)
				end
				local var16
				local r_7111 = state31["var"]
				if r_7111 then
					var16 = r_7111
				else
					var16 = struct1("name", "temp")
				end
				local escaped1 = escapeVar1(var16, backState1)
				local name11 = var16["name"]
				pushCdr_21_1(stateList1, state31)
				pushCdr_21_1(exportList1, _2e2e_2(escaped1, " = ", escaped1))
				pushCdr_21_1(nameList1, name11)
				pushCdr_21_1(escapeList1, escaped1)
			end
			return r_4761((r_4771 + -1))
		else
		end
	end)
	r_4761(_23_1(states1))
	if nil_3f_1(stateList1) then
	else
		local out14 = create2()
		local id3 = backState1["count"]
		local name12 = concat1(nameList1, ",")
		backState1["count"] = succ1(id3)
		if (20 > len1(name12)) then
			name12 = _2e2e_2(sub1(name12, 1, 17), "...")
		else
		end
		name12 = _2e2e_2("compile#", id3, "{", name12, "}")
		prelude1(out14)
		line_21_1(out14, _2e2e_2("local ", concat1(escapeList1, ", ")))
		local r_7141 = _23_1(stateList1)
		local r_7121 = nil
		r_7121 = (function(r_7131)
			if (r_7131 <= r_7141) then
				local state32 = nth1(stateList1, r_7131)
				expression2(state32["node"], out14, backState1, (function()
					if state32["var"] then
						return ""
					else
						return _2e2e_2(nth1(escapeList1, r_7131), "= ")
					end
				end)()
				)
				line_21_1(out14)
				return r_7121((r_7131 + 1))
			else
			end
		end)
		r_7121(1)
		line_21_1(out14, _2e2e_2("return { ", concat1(exportList1, ", "), "}"))
		local str2 = _2d3e_string1(out14)
		backState1["mappings"][name12] = generateMappings1(out14["lines"])
		local r_7161 = list1(load1(str2, _2e2e_2("=", name12), "t", global1))
		local temp94
		local r_7191 = list_3f_1(r_7161)
		if r_7191 then
			local r_7201 = (_23_1(r_7161) == 2)
			if r_7201 then
				local r_7211 = eq_3f_1(nth1(r_7161, 1), nil)
				if r_7211 then
					temp94 = true
				else
					temp94 = r_7211
				end
			else
				temp94 = r_7201
			end
		else
			temp94 = r_7191
		end
		if temp94 then
			local msg14 = nth1(r_7161, 2)
			return fail_21_1(_2e2e_2(msg14, ":\n", str2))
		else
			local temp95
			local r_7221 = list_3f_1(r_7161)
			if r_7221 then
				local r_7231 = (_23_1(r_7161) == 1)
				if r_7231 then
					temp95 = true
				else
					temp95 = r_7231
				end
			else
				temp95 = r_7221
			end
			if temp95 then
				local fun1 = nth1(r_7161, 1)
				local r_7241 = list1(xpcall1(fun1, traceback1))
				local temp96
				local r_7271 = list_3f_1(r_7241)
				if r_7271 then
					local r_7281 = (_23_1(r_7241) == 2)
					if r_7281 then
						local r_7291 = eq_3f_1(nth1(r_7241, 1), false)
						if r_7291 then
							temp96 = true
						else
							temp96 = r_7291
						end
					else
						temp96 = r_7281
					end
				else
					temp96 = r_7271
				end
				if temp96 then
					local msg15 = nth1(r_7241, 2)
					return fail_21_1(remapTraceback1(backState1["mappings"], msg15))
				else
					local temp97
					local r_7301 = list_3f_1(r_7241)
					if r_7301 then
						local r_7311 = (_23_1(r_7241) == 2)
						if r_7311 then
							local r_7321 = eq_3f_1(nth1(r_7241, 1), true)
							if r_7321 then
								temp97 = true
							else
								temp97 = r_7321
							end
						else
							temp97 = r_7311
						end
					else
						temp97 = r_7301
					end
					if temp97 then
						local tbl1 = nth1(r_7241, 2)
						local r_7351 = _23_1(stateList1)
						local r_7331 = nil
						r_7331 = (function(r_7341)
							if (r_7341 <= r_7351) then
								local state33 = nth1(stateList1, r_7341)
								local escaped2 = nth1(escapeList1, r_7341)
								local res6 = tbl1[escaped2]
								self1(state33, "executed", res6)
								if state33["var"] then
									global1[escaped2] = res6
								else
								end
								return r_7331((r_7341 + 1))
							else
							end
						end)
						return r_7331(1)
					else
						return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_7241), ", but none matched.\n", "  Tried: `(false ?msg)`\n  Tried: `(true ?tbl)`"))
					end
				end
			else
				return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_7161), ", but none matched.\n", "  Tried: `(nil ?msg)`\n  Tried: `(?fun)`"))
			end
		end
	end
end)
emitLua1 = struct1("name", "emit-lua", "setup", (function(spec7)
	addArgument_21_1(spec7, ({tag = "list", n = 1, "--emit-lua"}), "help", "Emit a Lua file.")
	addArgument_21_1(spec7, ({tag = "list", n = 1, "--shebang"}), "value", (function(r_7371)
		if r_7371 then
			return r_7371
		else
			local r_7381 = nth1(arg1, 0)
			if r_7381 then
				return r_7381
			else
				return "lua"
			end
		end
	end)(nth1(arg1, -1)), "help", "Set the executable to use for the shebang.", "narg", "?")
	return addArgument_21_1(spec7, ({tag = "list", n = 1, "--chmod"}), "help", "Run chmod +x on the resulting file")
end), "pred", (function(args13)
	return args13["emit-lua"]
end), "run", (function(compiler2, args14)
	if nil_3f_1(args14["input"]) then
		putError_21_1(compiler2["log"], "No inputs to compile.")
		exit_21_1(1)
	else
	end
	local out15 = file3(compiler2, args14["shebang"])
	local handle1 = open1(_2e2e_2(args14["output"], ".lua"), "w")
	self1(handle1, "write", _2d3e_string1(out15))
	self1(handle1, "close")
	if args14["chmod"] then
		return execute1(_2e2e_2("chmod +x ", quoted1(_2e2e_2(args14["output"], ".lua"))))
	else
	end
end))
emitLisp1 = struct1("name", "emit-lisp", "setup", (function(spec8)
	return addArgument_21_1(spec8, ({tag = "list", n = 1, "--emit-lisp"}), "help", "Emit a Lisp file.")
end), "pred", (function(args15)
	return args15["emit-lisp"]
end), "run", (function(compiler3, args16)
	if nil_3f_1(args16["input"]) then
		putError_21_1(compiler3["log"], "No inputs to compile.")
		exit_21_1(1)
	else
	end
	local writer13 = create2()
	block1(compiler3["out"], writer13)
	local handle2 = open1(_2e2e_2(args16["output"], ".lisp"), "w")
	self1(handle2, "write", _2d3e_string1(writer13))
	return self1(handle2, "close")
end))
passArg1 = (function(arg26, data4, value8, usage_21_4)
	local val17 = tonumber1(value8)
	local name13 = _2e2e_2(arg26["name"], "-override")
	local override2 = data4[name13]
	if override2 then
	else
		override2 = ({})
		data4[name13] = override2
	end
	if val17 then
		data4[arg26["name"]] = val17
		return nil
	elseif (charAt1(value8, 1) == "-") then
		override2[sub1(value8, 2)] = false
		return nil
	elseif (charAt1(value8, 1) == "+") then
		override2[sub1(value8, 2)] = true
		return nil
	else
		return usage_21_4(_2e2e_2("Expected number or enable/disable flag for --", arg26["name"], " , got ", value8))
	end
end)
passRun1 = (function(fun2, name14)
	return (function(compiler4, args17)
		return fun2(compiler4["out"], struct1("track", true, "level", args17[name14], "override", (function(r_1591)
			if r_1591 then
				return r_1591
			else
				return ({})
			end
		end)(args17[_2e2e_2(name14, "-override")]), "time", args17["time"], "max-n", args17[_2e2e_2(name14, "-n")], "max-time", args17[_2e2e_2(name14, "-time")], "meta", compiler4["libMeta"], "logger", compiler4["log"]))
	end)
end)
warning1 = struct1("name", "warning", "setup", (function(spec9)
	return addArgument_21_1(spec9, ({tag = "list", n = 2, "--warning", "-W"}), "help", "Either the warning level to use or an enable/disable flag for a pass.", "default", 1, "narg", 1, "var", "LEVEL", "action", passArg1)
end), "pred", (function(args18)
	return (args18["warning"] > 0)
end), "run", passRun1(analyse1, "warning"))
optimise2 = struct1("name", "optimise", "setup", (function(spec10)
	addArgument_21_1(spec10, ({tag = "list", n = 2, "--optimise", "-O"}), "help", "Either the optimiation level to use or an enable/disable flag for a pass.", "default", 1, "narg", 1, "var", "LEVEL", "action", passArg1)
	addArgument_21_1(spec10, ({tag = "list", n = 2, "--optimise-n", "--optn"}), "help", "The maximum number of iterations the optimiser should run for.", "default", 10, "narg", 1, "action", setNumAction1)
	return addArgument_21_1(spec10, ({tag = "list", n = 2, "--optimise-time", "--optt"}), "help", "The maximum time the optimiser should run for.", "default", -1, "narg", 1, "action", setNumAction1)
end), "pred", (function(args19)
	return (args19["optimise"] > 0)
end), "run", passRun1(optimise1, "optimise"))
builtins4 = require1("tacky.analysis.resolve")["builtins"]
tokens1 = ({tag = "list", n = 7, ({tag = "list", n = 2, "arg", "(%f[%a]%u+%f[%A])"}), ({tag = "list", n = 2, "mono", "```[a-z]*\n([^`]*)\n```"}), ({tag = "list", n = 2, "mono", "`([^`]*)`"}), ({tag = "list", n = 2, "bolic", "(%*%*%*%w.-%w%*%*%*)"}), ({tag = "list", n = 2, "bold", "(%*%*%w.-%w%*%*)"}), ({tag = "list", n = 2, "italic", "(%*%w.-%w%*)"}), ({tag = "list", n = 2, "link", "%[%[(.-)%]%]"})})
extractSignature1 = (function(var17)
	local ty7 = type1(var17)
	local temp98
	local r_7461 = (ty7 == "macro")
	if r_7461 then
		temp98 = r_7461
	else
		temp98 = (ty7 == "defined")
	end
	if temp98 then
		local root1 = var17["node"]
		local node53 = nth1(root1, _23_1(root1))
		local temp99
		local r_7471 = list_3f_1(node53)
		if r_7471 then
			local r_7481 = symbol_3f_1(car2(node53))
			if r_7481 then
				temp99 = (car2(node53)["var"] == builtins4["lambda"])
			else
				temp99 = r_7481
			end
		else
			temp99 = r_7471
		end
		if temp99 then
			return nth1(node53, 2)
		else
			return nil
		end
	else
		return nil
	end
end)
parseDocstring1 = (function(str3)
	local out16 = ({tag = "list", n = 0})
	local pos7 = 1
	local len7 = len1(str3)
	local r_7491 = nil
	r_7491 = (function()
		if (pos7 <= len7) then
			local spos1 = len7
			local epos1 = nil
			local name15 = nil
			local ptrn1 = nil
			local r_7541 = _23_1(tokens1)
			local r_7521 = nil
			r_7521 = (function(r_7531)
				if (r_7531 <= r_7541) then
					local tok1 = tokens1[r_7531]
					local npos1 = list1(find1(str3, nth1(tok1, 2), pos7))
					local temp100
					local r_7561 = car2(npos1)
					if r_7561 then
						temp100 = (car2(npos1) < spos1)
					else
						temp100 = r_7561
					end
					if temp100 then
						spos1 = car2(npos1)
						epos1 = nth1(npos1, 2)
						name15 = car2(tok1)
						ptrn1 = nth1(tok1, 2)
					else
					end
					return r_7521((r_7531 + 1))
				else
				end
			end)
			r_7521(1)
			if name15 then
				if (pos7 < spos1) then
					pushCdr_21_1(out16, struct1("tag", "text", "contents", sub1(str3, pos7, pred1(spos1))))
				else
				end
				pushCdr_21_1(out16, struct1("tag", name15, "whole", sub1(str3, spos1, epos1), "contents", match1(sub1(str3, spos1, epos1), ptrn1)))
				pos7 = succ1(epos1)
			else
				pushCdr_21_1(out16, struct1("tag", "text", "contents", sub1(str3, pos7, len7)))
				pos7 = succ1(len7)
			end
			return r_7491()
		else
		end
	end)
	r_7491()
	return out16
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
formatSignature1 = (function(name16, var19)
	local sig1 = extractSignature1(var19)
	if (sig1 == nil) then
		return name16
	elseif nil_3f_1(sig1) then
		return _2e2e_2("(", name16, ")")
	else
		return _2e2e_2("(", name16, " ", concat1(traverse1(sig1, (function(r_7391)
			return r_7391["contents"]
		end)), " "), ")")
	end
end)
writeDocstring1 = (function(out17, str4, scope2)
	local r_7411 = parseDocstring1(str4)
	local r_7441 = _23_1(r_7411)
	local r_7421 = nil
	r_7421 = (function(r_7431)
		if (r_7431 <= r_7441) then
			local tok2 = r_7411[r_7431]
			local ty9 = type1(tok2)
			if (ty9 == "text") then
				append_21_1(out17, tok2["contents"])
			elseif (ty9 == "boldic") then
				append_21_1(out17, tok2["contents"])
			elseif (ty9 == "bold") then
				append_21_1(out17, tok2["contents"])
			elseif (ty9 == "italic") then
				append_21_1(out17, tok2["contents"])
			elseif (ty9 == "arg") then
				append_21_1(out17, _2e2e_2("`", tok2["contents"], "`"))
			elseif (ty9 == "mono") then
				append_21_1(out17, tok2["whole"])
			elseif (ty9 == "link") then
				local name17 = tok2["contents"]
				local ovar1 = Scope1["get"](scope2, name17)
				local temp101
				if ovar1 then
					temp101 = ovar1["node"]
				else
					temp101 = ovar1
				end
				if temp101 then
					local loc1
					local r_7621
					local r_7611
					local r_7601
					local r_7591 = ovar1["node"]
					r_7601 = getSource1(r_7591)
					r_7611 = r_7601["name"]
					r_7621 = gsub1(r_7611, "%.lisp$", "")
					loc1 = gsub1(r_7621, "/", ".")
					local sig2 = extractSignature1(ovar1)
					local hash1
					if (sig2 == nil) then
						hash1 = ovar1["name"]
					elseif nil_3f_1(sig2) then
						hash1 = ovar1["name"]
					else
						hash1 = _2e2e_2(name17, " ", concat1(traverse1(sig2, (function(r_7581)
							return r_7581["contents"]
						end)), " "))
					end
					append_21_1(out17, format1("[`%s`](%s.md#%s)", name17, loc1, gsub1(hash1, "%A+", "-")))
				else
					append_21_1(out17, format1("`%s`", name17))
				end
			else
				_error("unmatched item")
			end
			return r_7421((r_7431 + 1))
		else
		end
	end)
	r_7421(1)
	return line_21_1(out17)
end)
exported1 = (function(out18, title1, primary1, vars1, scope3)
	local documented1 = ({tag = "list", n = 0})
	local undocumented1 = ({tag = "list", n = 0})
	iterPairs1(vars1, (function(name18, var20)
		return pushCdr_21_1((function()
			if var20["doc"] then
				return documented1
			else
				return undocumented1
			end
		end)()
		, list1(name18, var20))
	end))
	sortVars_21_1(documented1)
	sortVars_21_1(undocumented1)
	line_21_1(out18, "---")
	line_21_1(out18, _2e2e_2("title: ", title1))
	line_21_1(out18, "---")
	line_21_1(out18, _2e2e_2("# ", title1))
	if primary1 then
		writeDocstring1(out18, primary1, scope3)
		line_21_1(out18, "", true)
	else
	end
	local r_7671 = _23_1(documented1)
	local r_7651 = nil
	r_7651 = (function(r_7661)
		if (r_7661 <= r_7671) then
			local entry7 = documented1[r_7661]
			local name19 = car2(entry7)
			local var21 = nth1(entry7, 2)
			line_21_1(out18, _2e2e_2("## `", formatSignature1(name19, var21), "`"))
			line_21_1(out18, _2e2e_2("*", formatDefinition1(var21), "*"))
			line_21_1(out18, "", true)
			writeDocstring1(out18, var21["doc"], var21["scope"])
			line_21_1(out18, "", true)
			return r_7651((r_7661 + 1))
		else
		end
	end)
	r_7651(1)
	if nil_3f_1(undocumented1) then
	else
		line_21_1(out18, "## Undocumented symbols")
	end
	local r_7731 = _23_1(undocumented1)
	local r_7711 = nil
	r_7711 = (function(r_7721)
		if (r_7721 <= r_7731) then
			local entry8 = undocumented1[r_7721]
			local name20 = car2(entry8)
			local var22 = nth1(entry8, 2)
			line_21_1(out18, _2e2e_2(" - `", formatSignature1(name20, var22), "` *", formatDefinition1(var22), "*"))
			return r_7711((r_7721 + 1))
		else
		end
	end)
	return r_7711(1)
end)
docs1 = (function(compiler5, args20)
	if nil_3f_1(args20["input"]) then
		putError_21_1(compiler5["log"], "No inputs to generate documentation for.")
		exit_21_1(1)
	else
	end
	local r_7761 = args20["input"]
	local r_7791 = _23_1(r_7761)
	local r_7771 = nil
	r_7771 = (function(r_7781)
		if (r_7781 <= r_7791) then
			local path1 = r_7761[r_7781]
			if (sub1(path1, -5) == ".lisp") then
				path1 = sub1(path1, 1, -6)
			else
			end
			local lib2 = compiler5["libCache"][path1]
			local writer14 = create2()
			exported1(writer14, lib2["name"], lib2["docs"], lib2["scope"]["exported"], lib2["scope"])
			local handle3 = open1(_2e2e_2(args20["docs"], "/", gsub1(path1, "/", "."), ".md"), "w")
			self1(handle3, "write", _2d3e_string1(writer14))
			self1(handle3, "close")
			return r_7771((r_7781 + 1))
		else
		end
	end)
	return r_7771(1)
end)
task1 = struct1("name", "docs", "setup", (function(spec11)
	return addArgument_21_1(spec11, ({tag = "list", n = 1, "--docs"}), "help", "Specify the folder to emit documentation to.", "default", nil, "narg", 1)
end), "pred", (function(args21)
	return (nil ~= args21["docs"])
end), "run", docs1)
config1 = package.config
coloredAnsi1 = (function(col1, msg16)
	return _2e2e_2("\27[", col1, "m", msg16, "\27[0m")
end)
local temp102
if config1 then
	temp102 = (charAt1(config1, 1) ~= "\\")
else
	temp102 = config1
end
if temp102 then
	colored_3f_1 = true
else
	local temp103
	if getenv1 then
		temp103 = (getenv1("ANSICON") ~= nil)
	else
		temp103 = getenv1
	end
	if temp103 then
		colored_3f_1 = true
	else
		local temp104
		if getenv1 then
			local term1 = getenv1("TERM")
			if term1 then
				temp104 = find1(term1, "xterm")
			else
				temp104 = nil
			end
		else
			temp104 = getenv1
		end
		if temp104 then
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
	local r_7861 = between_3f_1(char4, "0", "9")
	if r_7861 then
		return r_7861
	else
		local r_7871 = between_3f_1(char4, "a", "f")
		if r_7871 then
			return r_7871
		else
			return between_3f_1(char4, "A", "F")
		end
	end
end)
binDigit_3f_1 = (function(char5)
	local r_7881 = (char5 == "0")
	if r_7881 then
		return r_7881
	else
		return (char5 == "1")
	end
end)
terminator_3f_1 = (function(char6)
	local r_7891 = (char6 == "\n")
	if r_7891 then
		return r_7891
	else
		local r_7901 = (char6 == " ")
		if r_7901 then
			return r_7901
		else
			local r_7911 = (char6 == "\9")
			if r_7911 then
				return r_7911
			else
				local r_7921 = (char6 == "(")
				if r_7921 then
					return r_7921
				else
					local r_7931 = (char6 == ")")
					if r_7931 then
						return r_7931
					else
						local r_7941 = (char6 == "[")
						if r_7941 then
							return r_7941
						else
							local r_7951 = (char6 == "]")
							if r_7951 then
								return r_7951
							else
								local r_7961 = (char6 == "{")
								if r_7961 then
									return r_7961
								else
									local r_7971 = (char6 == "}")
									if r_7971 then
										return r_7971
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
digitError_21_1 = (function(logger9, pos8, name21, char7)
	return doNodeError_21_1(logger9, format1("Expected %s digit, got %s", name21, (function()
		if (char7 == "") then
			return "eof"
		else
			return quoted1(char7)
		end
	end)()
	), pos8, nil, pos8, "Invalid digit here")
end)
lex1 = (function(logger10, str5, name22)
	str5 = gsub1(str5, "\13\n?", "\n")
	local lines6 = split1(str5, "\n")
	local line5 = 1
	local column1 = 1
	local offset6 = 1
	local length1 = len1(str5)
	local out19 = ({tag = "list", n = 0})
	local consume_21_1 = (function()
		if (charAt1(str5, offset6) == "\n") then
			line5 = (line5 + 1)
			column1 = 1
		else
			column1 = (column1 + 1)
		end
		offset6 = (offset6 + 1)
		return nil
	end)
	local position1 = (function()
		return struct1("line", line5, "column", column1, "offset", offset6)
	end)
	local range6 = (function(start11, finish2)
		return struct1("start", start11, "finish", (function()
			if finish2 then
				return finish2
			else
				return start11
			end
		end)()
		, "lines", lines6, "name", name22)
	end)
	local appendWith_21_1 = (function(data5, start12, finish3)
		local start13
		if start12 then
			start13 = start12
		else
			start13 = position1()
		end
		local finish4
		if finish3 then
			finish4 = finish3
		else
			finish4 = position1()
		end
		data5["range"] = range6(start13, finish4)
		data5["contents"] = sub1(str5, start13["offset"], finish4["offset"])
		return pushCdr_21_1(out19, data5)
	end)
	local append_21_2 = (function(tag11, start14, finish5)
		return appendWith_21_1(struct1("tag", tag11), start14, finish5)
	end)
	local parseBase1 = (function(name23, p3, base1)
		local start15 = offset6
		local char8 = charAt1(str5, offset6)
		if p3(char8) then
		else
			digitError_21_1(logger10, range6(position1()), name23, char8)
		end
		char8 = charAt1(str5, succ1(offset6))
		local r_8271 = nil
		r_8271 = (function()
			if p3(char8) then
				consume_21_1()
				char8 = charAt1(str5, succ1(offset6))
				return r_8271()
			else
			end
		end)
		r_8271()
		return tonumber1(sub1(str5, start15, offset6), base1)
	end)
	local r_7981 = nil
	r_7981 = (function()
		if (offset6 <= length1) then
			local char9 = charAt1(str5, offset6)
			local temp105
			local r_7991 = (char9 == "\n")
			if r_7991 then
				temp105 = r_7991
			else
				local r_8001 = (char9 == "\9")
				if r_8001 then
					temp105 = r_8001
				else
					temp105 = (char9 == " ")
				end
			end
			if temp105 then
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
				if (charAt1(str5, succ1(offset6)) == "@") then
					local start16 = position1()
					consume_21_1()
					append_21_2("unquote-splice", start16)
				else
					append_21_2("unquote")
				end
			elseif find1(str5, "^%-?%.?[0-9]", offset6) then
				local start17 = position1()
				local negative1 = (char9 == "-")
				if negative1 then
					consume_21_1()
					char9 = charAt1(str5, offset6)
				else
				end
				local val18
				local temp106
				local r_8091 = (char9 == "0")
				if r_8091 then
					temp106 = (charAt1(str5, succ1(offset6)) == "x")
				else
					temp106 = r_8091
				end
				if temp106 then
					consume_21_1()
					consume_21_1()
					local res7 = parseBase1("hexadecimal", hexDigit_3f_1, 16)
					if negative1 then
						res7 = (0 - res7)
					else
					end
					val18 = res7
				else
					local temp107
					local r_8101 = (char9 == "0")
					if r_8101 then
						temp107 = (charAt1(str5, succ1(offset6)) == "b")
					else
						temp107 = r_8101
					end
					if temp107 then
						consume_21_1()
						consume_21_1()
						local res8 = parseBase1("binary", binDigit_3f_1, 2)
						if negative1 then
							res8 = (0 - res8)
						else
						end
						val18 = res8
					else
						local r_8111 = nil
						r_8111 = (function()
							if between_3f_1(charAt1(str5, succ1(offset6)), "0", "9") then
								consume_21_1()
								return r_8111()
							else
							end
						end)
						r_8111()
						if (charAt1(str5, succ1(offset6)) == ".") then
							consume_21_1()
							local r_8121 = nil
							r_8121 = (function()
								if between_3f_1(charAt1(str5, succ1(offset6)), "0", "9") then
									consume_21_1()
									return r_8121()
								else
								end
							end)
							r_8121()
						else
						end
						char9 = charAt1(str5, succ1(offset6))
						local temp108
						local r_8131 = (char9 == "e")
						if r_8131 then
							temp108 = r_8131
						else
							temp108 = (char9 == "E")
						end
						if temp108 then
							consume_21_1()
							char9 = charAt1(str5, succ1(offset6))
							local temp109
							local r_8141 = (char9 == "-")
							if r_8141 then
								temp109 = r_8141
							else
								temp109 = (char9 == "+")
							end
							if temp109 then
								consume_21_1()
							else
							end
							local r_8151 = nil
							r_8151 = (function()
								if between_3f_1(charAt1(str5, succ1(offset6)), "0", "9") then
									consume_21_1()
									return r_8151()
								else
								end
							end)
							r_8151()
						else
						end
						val18 = tonumber1(sub1(str5, start17["offset"], offset6))
					end
				end
				appendWith_21_1(struct1("tag", "number", "value", val18), start17)
				char9 = charAt1(str5, succ1(offset6))
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
				local start18 = position1()
				local startCol1 = succ1(column1)
				local buffer3 = ({tag = "list", n = 0})
				consume_21_1()
				char9 = charAt1(str5, offset6)
				local r_8161 = nil
				r_8161 = (function()
					if (char9 ~= "\"") then
						if (column1 == 1) then
							local running3 = true
							local lineOff1 = offset6
							local r_8171 = nil
							r_8171 = (function()
								local temp110
								local r_8181 = running3
								if r_8181 then
									temp110 = (column1 < startCol1)
								else
									temp110 = r_8181
								end
								if temp110 then
									if (char9 == " ") then
										consume_21_1()
									elseif (char9 == "\n") then
										consume_21_1()
										pushCdr_21_1(buffer3, "\n")
										lineOff1 = offset6
									elseif (char9 == "") then
										running3 = false
									else
										putNodeWarning_21_1(logger10, format1("Expected leading indent, got %q", char9), range6(position1()), "You should try to align multi-line strings at the initial quote\nmark. This helps keep programs neat and tidy.", range6(start18), "String started with indent here", range6(position1()), "Mis-aligned character here")
										pushCdr_21_1(buffer3, sub1(str5, lineOff1, pred1(offset6)))
										running3 = false
									end
									char9 = charAt1(str5, offset6)
									return r_8171()
								else
								end
							end)
							r_8171()
						else
						end
						if (char9 == "") then
							local start19 = range6(start18)
							local finish6 = range6(position1())
							doNodeError_21_1(logger10, "Expected '\"', got eof", finish6, nil, start19, "string started here", finish6, "end of file here")
						elseif (char9 == "\\") then
							consume_21_1()
							char9 = charAt1(str5, offset6)
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
								local temp111
								local r_8191 = (char9 == "x")
								if r_8191 then
									temp111 = r_8191
								else
									local r_8201 = (char9 == "X")
									if r_8201 then
										temp111 = r_8201
									else
										temp111 = between_3f_1(char9, "0", "9")
									end
								end
								if temp111 then
									local start20 = position1()
									local val19
									local temp112
									local r_8211 = (char9 == "x")
									if r_8211 then
										temp112 = r_8211
									else
										temp112 = (char9 == "X")
									end
									if temp112 then
										consume_21_1()
										local start21 = offset6
										if hexDigit_3f_1(charAt1(str5, offset6)) then
										else
											digitError_21_1(logger10, range6(position1()), "hexadecimal", charAt1(str5, offset6))
										end
										if hexDigit_3f_1(charAt1(str5, succ1(offset6))) then
											consume_21_1()
										else
										end
										val19 = tonumber1(sub1(str5, start21, offset6), 16)
									else
										local start22 = position1()
										local ctr1 = 0
										char9 = charAt1(str5, succ1(offset6))
										local r_8221 = nil
										r_8221 = (function()
											local temp113
											local r_8231 = (ctr1 < 2)
											if r_8231 then
												temp113 = between_3f_1(char9, "0", "9")
											else
												temp113 = r_8231
											end
											if temp113 then
												consume_21_1()
												char9 = charAt1(str5, succ1(offset6))
												ctr1 = (ctr1 + 1)
												return r_8221()
											else
											end
										end)
										r_8221()
										val19 = tonumber1(sub1(str5, start22["offset"], offset6))
									end
									if (val19 >= 256) then
										doNodeError_21_1(logger10, "Invalid escape code", range6(start20()), nil, range6(start20(), position1), _2e2e_2("Must be between 0 and 255, is ", val19))
									else
									end
									pushCdr_21_1(buffer3, char1(val19))
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
						char9 = charAt1(str5, offset6)
						return r_8161()
					else
					end
				end)
				r_8161()
				appendWith_21_1(struct1("tag", "string", "value", concat1(buffer3)), start18)
			elseif (char9 == ";") then
				local r_8241 = nil
				r_8241 = (function()
					local temp114
					local r_8251 = (offset6 <= length1)
					if r_8251 then
						temp114 = (charAt1(str5, succ1(offset6)) ~= "\n")
					else
						temp114 = r_8251
					end
					if temp114 then
						consume_21_1()
						return r_8241()
					else
					end
				end)
				r_8241()
			else
				local start23 = position1()
				local key9 = (char9 == ":")
				char9 = charAt1(str5, succ1(offset6))
				local r_8261 = nil
				r_8261 = (function()
					if _21_1(terminator_3f_1(char9)) then
						consume_21_1()
						char9 = charAt1(str5, succ1(offset6))
						return r_8261()
					else
					end
				end)
				r_8261()
				if key9 then
					appendWith_21_1(struct1("tag", "key", "value", sub1(str5, succ1(start23["offset"]), offset6)), start23)
				else
					append_21_2("symbol", start23)
				end
			end
			consume_21_1()
			return r_7981()
		else
		end
	end)
	r_7981()
	append_21_2("eof")
	return out19
end)
parse1 = (function(logger11, toks1)
	local head5 = ({tag = "list", n = 0})
	local stack2 = ({tag = "list", n = 0})
	local append_21_3 = (function(node54)
		pushCdr_21_1(head5, node54)
		node54["parent"] = head5
		return nil
	end)
	local push_21_1 = (function()
		local next2 = ({tag = "list", n = 0})
		pushCdr_21_1(stack2, head5)
		append_21_3(next2)
		head5 = next2
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
	local r_8051 = _23_1(toks1)
	local r_8031 = nil
	r_8031 = (function(r_8041)
		if (r_8041 <= r_8051) then
			local tok3 = toks1[r_8041]
			local tag12 = tok3["tag"]
			local autoClose1 = false
			local previous2 = head5["last-node"]
			local tokPos1 = tok3["range"]
			local temp115
			local r_8071 = (tag12 ~= "eof")
			if r_8071 then
				local r_8081 = (tag12 ~= "close")
				if r_8081 then
					if head5["range"] then
						temp115 = (tokPos1["start"]["line"] ~= head5["range"]["start"]["line"])
					else
						temp115 = true
					end
				else
					temp115 = r_8081
				end
			else
				temp115 = r_8071
			end
			if temp115 then
				if previous2 then
					local prevPos1 = previous2["range"]
					if (tokPos1["start"]["line"] ~= prevPos1["start"]["line"]) then
						head5["last-node"] = tok3
						if (tokPos1["start"]["column"] ~= prevPos1["start"]["column"]) then
							putNodeWarning_21_1(logger11, "Different indent compared with previous expressions.", tok3, "You should try to maintain consistent indentation across a program,\ntry to ensure all expressions are lined up.\nIf this looks OK to you, check you're not missing a closing ')'.", prevPos1, "", tokPos1, "")
						else
						end
					else
					end
				else
					head5["last-node"] = tok3
				end
			else
			end
			local temp116
			local r_8311 = (tag12 == "string")
			if r_8311 then
				temp116 = r_8311
			else
				local r_8321 = (tag12 == "number")
				if r_8321 then
					temp116 = r_8321
				else
					local r_8331 = (tag12 == "symbol")
					if r_8331 then
						temp116 = r_8331
					else
						temp116 = (tag12 == "key")
					end
				end
			end
			if temp116 then
				append_21_3(tok3)
			elseif (tag12 == "open") then
				push_21_1()
				head5["open"] = tok3["contents"]
				head5["close"] = tok3["close"]
				head5["range"] = struct1("start", tok3["range"]["start"], "name", tok3["range"]["name"], "lines", tok3["range"]["lines"])
			elseif (tag12 == "close") then
				if nil_3f_1(stack2) then
					doNodeError_21_1(logger11, format1("'%s' without matching '%s'", tok3["contents"], tok3["open"]), tok3, nil, getSource1(tok3), "")
				elseif head5["auto-close"] then
					doNodeError_21_1(logger11, format1("'%s' without matching '%s' inside quote", tok3["contents"], tok3["open"]), tok3, nil, head5["range"], "quote opened here", tok3["range"], "attempting to close here")
				elseif (head5["close"] ~= tok3["contents"]) then
					doNodeError_21_1(logger11, format1("Expected '%s', got '%s'", head5["close"], tok3["contents"]), tok3, nil, head5["range"], format1("block opened with '%s'", head5["open"]), tok3["range"], format1("'%s' used here", tok3["contents"]))
				else
					head5["range"]["finish"] = tok3["range"]["finish"]
					pop_21_1()
				end
			else
				local temp117
				local r_8341 = (tag12 == "quote")
				if r_8341 then
					temp117 = r_8341
				else
					local r_8351 = (tag12 == "unquote")
					if r_8351 then
						temp117 = r_8351
					else
						local r_8361 = (tag12 == "syntax-quote")
						if r_8361 then
							temp117 = r_8361
						else
							local r_8371 = (tag12 == "unquote-splice")
							if r_8371 then
								temp117 = r_8371
							else
								temp117 = (tag12 == "quasiquote")
							end
						end
					end
				end
				if temp117 then
					push_21_1()
					head5["range"] = struct1("start", tok3["range"]["start"], "name", tok3["range"]["name"], "lines", tok3["range"]["lines"])
					append_21_3(struct1("tag", "symbol", "contents", tag12, "range", tok3["range"]))
					autoClose1 = true
					head5["auto-close"] = true
				elseif (tag12 == "eof") then
					if (0 ~= _23_1(stack2)) then
						doNodeError_21_1(logger11, "Expected ')', got eof", tok3, nil, head5["range"], "block opened here", tok3["range"], "end of file here")
					else
					end
				else
					error1(_2e2e_2("Unsupported type", tag12))
				end
			end
			if autoClose1 then
			else
				local r_8381 = nil
				r_8381 = (function()
					if head5["auto-close"] then
						if nil_3f_1(stack2) then
							doNodeError_21_1(logger11, format1("'%s' without matching '%s'", tok3["contents"], tok3["open"]), tok3, nil, getSource1(tok3), "")
						else
						end
						head5["range"]["finish"] = tok3["range"]["finish"]
						pop_21_1()
						return r_8381()
					else
					end
				end)
				r_8381()
			end
			return r_8031((r_8041 + 1))
		else
		end
	end)
	r_8031(1)
	return head5
end)
read2 = (function(x38, path2)
	return parse1(void1, lex1(void1, x38, (function()
		if path2 then
			return path2
		else
			return ""
		end
	end)()
	))
end)
struct1("lex", lex1, "parse", parse1, "read", read2)
compile1 = require1("tacky.compile")["compile"]
Scope2 = require1("tacky.analysis.scope")
doParse1 = (function(compiler6, scope4, str6)
	local logger12 = compiler6["log"]
	local lexed1 = lex1(logger12, str6, "<stdin>")
	local parsed1 = parse1(logger12, lexed1)
	return cadr1(list1(compile1(parsed1, compiler6["global"], compiler6["variables"], compiler6["states"], scope4, compiler6["compileState"], compiler6["loader"], logger12, executeStates1)))
end)
execCommand1 = (function(compiler7, scope5, args22)
	local logger13 = compiler7["log"]
	local command1 = car2(args22)
	if (command1 == nil) then
		return putError_21_1(logger13, "Expected command after ':'")
	elseif (command1 == "help") then
		return print1("REPL commands:\n:doc NAME        Get documentation about a symbol\n:scope           Print out all variables in the scope\n:search QUERY    Search the current scope for symbols and documentation containing a string.")
	elseif (command1 == "doc") then
		local name24 = nth1(args22, 2)
		if name24 then
			local var23 = Scope2["get"](scope5, name24)
			if (var23 == nil) then
				return putError_21_1(logger13, _2e2e_2("Cannot find '", name24, "'"))
			elseif _21_1(var23["doc"]) then
				return putError_21_1(logger13, _2e2e_2("No documentation for '", name24, "'"))
			else
				local sig3 = extractSignature1(var23)
				local name25 = var23["fullName"]
				local docs2 = parseDocstring1(var23["doc"])
				if sig3 then
					local buffer4 = list1(name25)
					local r_8441 = _23_1(sig3)
					local r_8421 = nil
					r_8421 = (function(r_8431)
						if (r_8431 <= r_8441) then
							local arg27 = sig3[r_8431]
							pushCdr_21_1(buffer4, arg27["contents"])
							return r_8421((r_8431 + 1))
						else
						end
					end)
					r_8421(1)
					name25 = _2e2e_2("(", concat1(buffer4, " "), ")")
				else
				end
				print1(colored1(96, name25))
				local r_8501 = _23_1(docs2)
				local r_8481 = nil
				r_8481 = (function(r_8491)
					if (r_8491 <= r_8501) then
						local tok4 = docs2[r_8491]
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
						return r_8481((r_8491 + 1))
					else
					end
				end)
				r_8481(1)
				return print1()
			end
		else
			return putError_21_1(logger13, ":command <variable>")
		end
	elseif (command1 == "scope") then
		local vars2 = ({tag = "list", n = 0})
		local varsSet1 = ({})
		local current1 = scope5
		local r_8521 = nil
		r_8521 = (function()
			if current1 then
				iterPairs1(current1["variables"], (function(name26, var24)
					if varsSet1[name26] then
					else
						pushCdr_21_1(vars2, name26)
						varsSet1[name26] = true
						return nil
					end
				end))
				current1 = current1["parent"]
				return r_8521()
			else
			end
		end)
		r_8521()
		sort1(vars2)
		return print1(concat1(vars2, "  "))
	elseif (command1 == "search") then
		if (_23_1(args22) > 1) then
			local keywords2 = map1(lower1, cdr2(args22))
			local nameResults1 = ({tag = "list", n = 0})
			local docsResults1 = ({tag = "list", n = 0})
			local vars3 = ({tag = "list", n = 0})
			local varsSet2 = ({})
			local current2 = scope5
			local r_8531 = nil
			r_8531 = (function()
				if current2 then
					iterPairs1(current2["variables"], (function(name27, var25)
						if varsSet2[name27] then
						else
							pushCdr_21_1(vars3, name27)
							varsSet2[name27] = true
							return nil
						end
					end))
					current2 = current2["parent"]
					return r_8531()
				else
				end
			end)
			r_8531()
			local r_8581 = _23_1(vars3)
			local r_8561 = nil
			r_8561 = (function(r_8571)
				if (r_8571 <= r_8581) then
					local var26 = vars3[r_8571]
					local r_8641 = _23_1(keywords2)
					local r_8621 = nil
					r_8621 = (function(r_8631)
						if (r_8631 <= r_8641) then
							local keyword1 = keywords2[r_8631]
							if find1(var26, keyword1) then
								pushCdr_21_1(nameResults1, var26)
							else
							end
							return r_8621((r_8631 + 1))
						else
						end
					end)
					r_8621(1)
					local docVar1 = Scope2["get"](scope5, var26)
					if docVar1 then
						local tempDocs1 = docVar1["doc"]
						if tempDocs1 then
							local docs3 = lower1(tempDocs1)
							if docs3 then
								local keywordsFound1 = 0
								if keywordsFound1 then
									local r_8811 = _23_1(keywords2)
									local r_8791 = nil
									r_8791 = (function(r_8801)
										if (r_8801 <= r_8811) then
											local keyword2 = keywords2[r_8801]
											if find1(docs3, keyword2) then
												keywordsFound1 = (keywordsFound1 + 1)
											else
											end
											return r_8791((r_8801 + 1))
										else
										end
									end)
									r_8791(1)
									if eq_3f_1(keywordsFound1, _23_1(keywords2)) then
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
					return r_8561((r_8571 + 1))
				else
				end
			end)
			r_8561(1)
			local temp118
			local r_8831 = nil_3f_1(nameResults1)
			if r_8831 then
				temp118 = nil_3f_1(docsResults1)
			else
				temp118 = r_8831
			end
			if temp118 then
				return putError_21_1(logger13, "No results")
			else
				if _21_1(nil_3f_1(nameResults1)) then
					print1(colored1(92, "Search by function name:"))
					if (_23_1(nameResults1) > 20) then
						print1(_2e2e_2(concat1(take1(nameResults1, 20), "  "), "  ..."))
					else
						print1(concat1(nameResults1, "  "))
					end
				else
				end
				if _21_1(nil_3f_1(docsResults1)) then
					print1(colored1(92, "Search by function docs:"))
					if (_23_1(docsResults1) > 20) then
						return print1(_2e2e_2(concat1(take1(docsResults1, 20), "  "), "  ..."))
					else
						return print1(concat1(docsResults1, "  "))
					end
				else
				end
			end
		else
			return putError_21_1(logger13, ":search <keywords>")
		end
	else
		return putError_21_1(logger13, _2e2e_2("Unknown command '", command1, "'"))
	end
end)
execString1 = (function(compiler8, scope6, string1)
	local state34 = doParse1(compiler8, scope6, string1)
	if (_23_1(state34) > 0) then
		local current3 = 0
		local exec1 = create3((function()
			local r_8701 = _23_1(state34)
			local r_8681 = nil
			r_8681 = (function(r_8691)
				if (r_8691 <= r_8701) then
					local elem7 = state34[r_8691]
					current3 = elem7
					self1(current3, "get")
					return r_8681((r_8691 + 1))
				else
				end
			end)
			return r_8681(1)
		end))
		local compileState1 = compiler8["compileState"]
		local rootScope1 = compiler8["rootScope"]
		local global2 = compiler8["global"]
		local logger14 = compiler8["log"]
		local run1 = true
		local r_7811 = nil
		r_7811 = (function()
			if run1 then
				local res9 = list1(resume1(exec1))
				if _21_1(car2(res9)) then
					putError_21_1(logger14, cadr1(res9))
					run1 = false
				elseif (status1(exec1) == "dead") then
					local lvl1 = self1(last1(state34), "get")
					print1(_2e2e_2("out = ", colored1(96, pretty1(lvl1))))
					global2[escapeVar1(Scope2["add"](scope6, "out", "defined", lvl1), compileState1)] = lvl1
					run1 = false
				else
					local states2 = cadr1(res9)["states"]
					executeStates1(compileState1, states2, global2, logger14)
				end
				return r_7811()
			else
			end
		end)
		return r_7811()
	else
	end
end)
repl1 = (function(compiler9)
	local scope7 = compiler9["rootScope"]
	local logger15 = compiler9["log"]
	local buffer5 = ({tag = "list", n = 0})
	local running4 = true
	local r_7821 = nil
	r_7821 = (function()
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
			local temp119
			local r_8721 = _21_1(line6)
			if r_8721 then
				temp119 = nil_3f_1(buffer5)
			else
				temp119 = r_8721
			end
			if temp119 then
				running4 = false
			else
				local temp120
				if line6 then
					temp120 = (charAt1(line6, len1(line6)) == "\\")
				else
					temp120 = line6
				end
				if temp120 then
					pushCdr_21_1(buffer5, _2e2e_2(sub1(line6, 1, pred1(len1(line6))), "\n"))
				else
					local temp121
					if line6 then
						local r_8751 = (_23_1(buffer5) > 0)
						if r_8751 then
							temp121 = (len1(line6) > 0)
						else
							temp121 = r_8751
						end
					else
						temp121 = line6
					end
					if temp121 then
						pushCdr_21_1(buffer5, _2e2e_2(line6, "\n"))
					else
						local data6 = _2e2e_2(concat1(buffer5), (function()
							if line6 then
								return line6
							else
								return ""
							end
						end)()
						)
						buffer5 = ({tag = "list", n = 0})
						if (charAt1(data6, 1) == ":") then
							execCommand1(compiler9, scope7, split1(sub1(data6, 2), " "))
						else
							scope7 = Scope2["child"](scope7)
							scope7["isRoot"] = true
							local res10 = list1(pcall1(execString1, compiler9, scope7, data6))
							if car2(res10) then
							else
								putError_21_1(logger15, cadr1(res10))
							end
						end
					end
				end
			end
			return r_7821()
		else
		end
	end)
	return r_7821()
end)
task2 = struct1("name", "repl", "setup", (function(spec12)
	return addArgument_21_1(spec12, ({tag = "list", n = 1, "--repl"}), "help", "Start an interactive session.")
end), "pred", (function(args23)
	return args23["repl"]
end), "run", repl1)
runWithProfiler1 = (function(fn2, mappings3)
	local stats1 = ({})
	local callStack1 = ({tag = "list", n = 0})
	sethook1((function(action2)
		local info1 = getinfo1(2, "Sn")
		local start24 = clock1()
		if (action2 == "call") then
			local previous3 = nth1(callStack1, _23_1(callStack1))
			if previous3 then
				previous3["sum"] = (previous3["sum"] + (start24 - previous3["innerStart"]))
			else
			end
		else
		end
		if (action2 ~= "call") then
			if nil_3f_1(callStack1) then
			else
				local current4 = popLast_21_1(callStack1)
				local hash2 = (current4["source"] .. current4["linedefined"])
				local entry9 = stats1[hash2]
				if entry9 then
				else
					entry9 = struct1("source", current4["source"], "short-src", current4["short_src"], "line", current4["linedefined"], "name", current4["name"], "calls", 0, "totalTime", 0, "innerTime", 0)
					stats1[hash2] = entry9
				end
				entry9["calls"] = (1 + entry9["calls"])
				entry9["totalTime"] = (entry9["totalTime"] + (start24 - current4["totalStart"]))
				entry9["innerTime"] = (entry9["innerTime"] + (current4["sum"] + (start24 - current4["innerStart"])))
			end
		else
		end
		if (action2 ~= "return") then
			info1["totalStart"] = start24
			info1["innerStart"] = start24
			info1["sum"] = 0
			pushCdr_21_1(callStack1, info1)
		else
		end
		if (action2 == "return") then
			local next3 = last1(callStack1)
			if next3 then
				next3["innerStart"] = start24
				return nil
			else
			end
		else
		end
	end), "cr")
	fn2()
	sethook1(nil)
	local out20 = values1(stats1)
	sort1(out20, (function(a4, b4)
		return (a4["innerTime"] > b4["innerTime"])
	end))
	print1("|               Method | Location                                                     |    Total |    Inner |   Calls |")
	print1("| -------------------- | ------------------------------------------------------------ | -------- | -------- | ------- |")
	local r_8881 = _23_1(out20)
	local r_8861 = nil
	r_8861 = (function(r_8871)
		if (r_8871 <= r_8881) then
			local entry10 = out20[r_8871]
			print1(format1("| %20s | %-60s | %8.5f | %8.5f | %7d | ", (function()
				if entry10["name"] then
					return unmangleIdent1(entry10["name"])
				else
					return "<unknown>"
				end
			end)()
			, remapMessage1(mappings3, _2e2e_2(entry10["short-src"], ":", entry10["line"])), entry10["totalTime"], entry10["innerTime"], entry10["calls"]))
			return r_8861((r_8871 + 1))
		else
		end
	end)
	r_8861(1)
	return stats1
end)
runLua1 = (function(compiler10, args24)
	if nil_3f_1(args24["input"]) then
		putError_21_1(compiler10["log"], "No inputs to run.")
		exit_21_1(1)
	else
	end
	local out21 = file3(compiler10, false)
	local lines7 = generateMappings1(out21["lines"])
	local logger16 = compiler10["log"]
	local name28 = _2e2e_2((function(r_9071)
		if r_9071 then
			return r_9071
		else
			return "out"
		end
	end)(args24["output"]), ".lua")
	local r_8901 = list1(load1(_2d3e_string1(out21), _2e2e_2("=", name28)))
	local temp122
	local r_8931 = list_3f_1(r_8901)
	if r_8931 then
		local r_8941 = (_23_1(r_8901) == 2)
		if r_8941 then
			local r_8951 = eq_3f_1(nth1(r_8901, 1), nil)
			if r_8951 then
				temp122 = true
			else
				temp122 = r_8951
			end
		else
			temp122 = r_8941
		end
	else
		temp122 = r_8931
	end
	if temp122 then
		local msg18 = nth1(r_8901, 2)
		putError_21_1(logger16, "Cannot load compiled source.")
		print1(msg18)
		print1(_2d3e_string1(out21))
		return exit_21_1(1)
	else
		local temp123
		local r_8961 = list_3f_1(r_8901)
		if r_8961 then
			local r_8971 = (_23_1(r_8901) == 1)
			if r_8971 then
				temp123 = true
			else
				temp123 = r_8971
			end
		else
			temp123 = r_8961
		end
		if temp123 then
			local fun3 = nth1(r_8901, 1)
			_5f_G1["arg"] = args24["script-args"]
			_5f_G1["arg"][0] = car2(args24["input"])
			local exec2 = (function()
				local r_8981 = list1(xpcall1(fun3, traceback1))
				local temp124
				local r_9011 = list_3f_1(r_8981)
				if r_9011 then
					local r_9021 = (_23_1(r_8981) >= 1)
					if r_9021 then
						local r_9031 = eq_3f_1(nth1(r_8981, 1), true)
						if r_9031 then
							temp124 = true
						else
							temp124 = r_9031
						end
					else
						temp124 = r_9021
					end
				else
					temp124 = r_9011
				end
				if temp124 then
					local res11 = slice1(r_8981, 2)
				else
					local temp125
					local r_9041 = list_3f_1(r_8981)
					if r_9041 then
						local r_9051 = (_23_1(r_8981) == 2)
						if r_9051 then
							local r_9061 = eq_3f_1(nth1(r_8981, 1), false)
							if r_9061 then
								temp125 = true
							else
								temp125 = r_9061
							end
						else
							temp125 = r_9051
						end
					else
						temp125 = r_9041
					end
					if temp125 then
						local msg19 = nth1(r_8981, 2)
						putError_21_1(logger16, "Execution failed.")
						print1(remapTraceback1(struct1(name28, lines7), msg19))
						return exit_21_1(1)
					else
						return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_8981), ", but none matched.\n", "  Tried: `(true . ?res)`\n  Tried: `(false ?msg)`"))
					end
				end
			end)
			if args24["profile"] then
				return runWithProfiler1(exec2, struct1(name28, lines7))
			else
				return exec2()
			end
		else
			return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_8901), ", but none matched.\n", "  Tried: `(nil ?msg)`\n  Tried: `(?fun)`"))
		end
	end
end)
task3 = struct1("name", "run", "setup", (function(spec13)
	addArgument_21_1(spec13, ({tag = "list", n = 2, "--run", "-r"}), "help", "Run the compiled code.")
	addArgument_21_1(spec13, ({tag = "list", n = 2, "--profile", "-p"}), "help", "Run the compiled code with the profiler.")
	return addArgument_21_1(spec13, ({tag = "list", n = 1, "--"}), "name", "script-args", "help", "Arguments to pass to the compiled script.", "var", "ARG", "all", true, "default", ({tag = "list", n = 0}), "action", addAction1, "narg", "*")
end), "pred", (function(args25)
	local r_9081 = args25["run"]
	if r_9081 then
		return r_9081
	else
		return args25["profile"]
	end
end), "run", runLua1)
genNative1 = (function(compiler11, args26)
	if (_23_1(args26["input"]) ~= 1) then
		putError_21_1(compiler11["log"], "Expected just one input")
		exit_21_1(1)
	else
	end
	local prefix2 = args26["gen-native"]
	local qualifier1
	if string_3f_1(prefix2) then
		qualifier1 = _2e2e_2(prefix2, ".")
	else
		qualifier1 = ""
	end
	local lib3 = compiler11["libCache"][gsub1(last1(args26["input"]), "%.lisp$", "")]
	local maxName1 = 0
	local maxQuot1 = 0
	local maxPref1 = 0
	local natives1 = ({tag = "list", n = 0})
	local r_9101 = lib3["out"]
	local r_9131 = _23_1(r_9101)
	local r_9111 = nil
	r_9111 = (function(r_9121)
		if (r_9121 <= r_9131) then
			local node55 = r_9101[r_9121]
			local temp126
			local r_9151 = list_3f_1(node55)
			if r_9151 then
				local r_9161 = symbol_3f_1(car2(node55))
				if r_9161 then
					temp126 = (car2(node55)["contents"] == "define-native")
				else
					temp126 = r_9161
				end
			else
				temp126 = r_9151
			end
			if temp126 then
				local name29 = nth1(node55, 2)["contents"]
				pushCdr_21_1(natives1, name29)
				maxName1 = max2(maxName1, len1(quoted1(name29)))
				maxQuot1 = max2(maxQuot1, len1(quoted1(_2e2e_2(qualifier1, name29))))
				maxPref1 = max2(maxPref1, len1(_2e2e_2(qualifier1, name29)))
			else
			end
			return r_9111((r_9121 + 1))
		else
		end
	end)
	r_9111(1)
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
	local r_9211 = _23_1(natives1)
	local r_9191 = nil
	r_9191 = (function(r_9201)
		if (r_9201 <= r_9211) then
			local native2 = natives1[r_9201]
			self1(handle4, "write", format1(format2, _2e2e_2(quoted1(native2), "] ="), _2e2e_2(quoted1(_2e2e_2(qualifier1, native2)), ","), _2e2e_2(qualifier1, native2, ",")))
			return r_9191((r_9201 + 1))
		else
		end
	end)
	r_9191(1)
	self1(handle4, "write", "}\n")
	return self1(handle4, "close")
end)
task4 = struct1("name", "gen-native", "setup", (function(spec14)
	return addArgument_21_1(spec14, ({tag = "list", n = 1, "--gen-native"}), "help", "Generate native bindings for a file", "var", "PREFIX", "narg", "?")
end), "pred", (function(args27)
	return args27["gen-native"]
end), "run", genNative1)
scope_2f_child2 = require1("tacky.analysis.scope")["child"]
compile2 = require1("tacky.compile")["compile"]
simplifyPath1 = (function(path3, paths1)
	local current5 = path3
	local r_9271 = _23_1(paths1)
	local r_9251 = nil
	r_9251 = (function(r_9261)
		if (r_9261 <= r_9271) then
			local search1 = paths1[r_9261]
			local sub9 = match1(path3, _2e2e_2("^", gsub1(search1, "%?", "(.*)"), "$"))
			local temp127
			if sub9 then
				temp127 = (len1(sub9) < len1(current5))
			else
				temp127 = sub9
			end
			if temp127 then
				current5 = sub9
			else
			end
			return r_9251((r_9261 + 1))
		else
		end
	end)
	r_9251(1)
	return current5
end)
readMeta1 = (function(state35, name30, entry11)
	local temp128
	local r_9301
	local r_9311 = (entry11["tag"] == "expr")
	if r_9311 then
		r_9301 = r_9311
	else
		r_9301 = (entry11["tag"] == "stmt")
	end
	if r_9301 then
		temp128 = string_3f_1(entry11["contents"])
	else
		temp128 = r_9301
	end
	if temp128 then
		local buffer6 = ({tag = "list", n = 0})
		local str7 = entry11["contents"]
		local idx4 = 0
		local len8 = len1(str7)
		local r_9321 = nil
		r_9321 = (function()
			if (idx4 <= len8) then
				local r_9331 = list1(find1(str7, "%${(%d+)}", idx4))
				local temp129
				local r_9351 = list_3f_1(r_9331)
				if r_9351 then
					local r_9361 = (_23_1(r_9331) >= 2)
					if r_9361 then
						temp129 = true
					else
						temp129 = r_9361
					end
				else
					temp129 = r_9351
				end
				if temp129 then
					local start25 = nth1(r_9331, 1)
					local finish7 = nth1(r_9331, 2)
					if (start25 > idx4) then
						pushCdr_21_1(buffer6, sub1(str7, idx4, pred1(start25)))
					else
					end
					pushCdr_21_1(buffer6, tonumber1(sub1(str7, (start25 + 2), (finish7 - 1))))
					idx4 = succ1(finish7)
				else
					pushCdr_21_1(buffer6, sub1(str7, idx4, len8))
					idx4 = succ1(len8)
				end
				return r_9321()
			else
			end
		end)
		r_9321()
		entry11["contents"] = buffer6
	else
	end
	if (entry11["value"] == nil) then
		entry11["value"] = state35["libEnv"][name30]
	elseif (state35["libEnv"][name30] ~= nil) then
		fail_21_1(_2e2e_2("Duplicate value for ", name30, ": in native and meta file"))
	else
		state35["libEnv"][name30] = entry11["value"]
	end
	state35["libMeta"][name30] = entry11
	return entry11
end)
readLibrary1 = (function(state36, name31, path4, lispHandle1)
	putVerbose_21_1(state36["log"], _2e2e_2("Loading ", path4, " into ", name31))
	local prefix3 = _2e2e_2(name31, "-", _23_1(state36["libs"]), "/")
	local lib4 = struct1("name", name31, "prefix", prefix3, "path", path4)
	local contents3 = self1(lispHandle1, "read", "*a")
	self1(lispHandle1, "close")
	local handle5 = open1(_2e2e_2(path4, ".lua"), "r")
	if handle5 then
		local contents4 = self1(handle5, "read", "*a")
		self1(handle5, "close")
		lib4["native"] = contents4
		local r_9401 = list1(load1(contents4, _2e2e_2("@", name31)))
		local temp130
		local r_9431 = list_3f_1(r_9401)
		if r_9431 then
			local r_9441 = (_23_1(r_9401) == 2)
			if r_9441 then
				local r_9451 = eq_3f_1(nth1(r_9401, 1), nil)
				if r_9451 then
					temp130 = true
				else
					temp130 = r_9451
				end
			else
				temp130 = r_9441
			end
		else
			temp130 = r_9431
		end
		if temp130 then
			local msg20 = nth1(r_9401, 2)
			fail_21_1(msg20)
		else
			local temp131
			local r_9461 = list_3f_1(r_9401)
			if r_9461 then
				local r_9471 = (_23_1(r_9401) == 1)
				if r_9471 then
					temp131 = true
				else
					temp131 = r_9471
				end
			else
				temp131 = r_9461
			end
			if temp131 then
				local fun4 = nth1(r_9401, 1)
				local res12 = fun4()
				if table_3f_1(res12) then
					iterPairs1(res12, (function(k2, v4)
						state36["libEnv"][_2e2e_2(prefix3, k2)] = v4
						return nil
					end))
				else
					fail_21_1(_2e2e_2(path4, ".lua returned a non-table value"))
				end
			else
				error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_9401), ", but none matched.\n", "  Tried: `(nil ?msg)`\n  Tried: `(?fun)`"))
			end
		end
	else
	end
	local handle6 = open1(_2e2e_2(path4, ".meta.lua"), "r")
	if handle6 then
		local contents5 = self1(handle6, "read", "*a")
		self1(handle6, "close")
		local r_9481 = list1(load1(contents5, _2e2e_2("@", name31)))
		local temp132
		local r_9511 = list_3f_1(r_9481)
		if r_9511 then
			local r_9521 = (_23_1(r_9481) == 2)
			if r_9521 then
				local r_9531 = eq_3f_1(nth1(r_9481, 1), nil)
				if r_9531 then
					temp132 = true
				else
					temp132 = r_9531
				end
			else
				temp132 = r_9521
			end
		else
			temp132 = r_9511
		end
		if temp132 then
			local msg21 = nth1(r_9481, 2)
			fail_21_1(msg21)
		else
			local temp133
			local r_9541 = list_3f_1(r_9481)
			if r_9541 then
				local r_9551 = (_23_1(r_9481) == 1)
				if r_9551 then
					temp133 = true
				else
					temp133 = r_9551
				end
			else
				temp133 = r_9541
			end
			if temp133 then
				local fun5 = nth1(r_9481, 1)
				local res13 = fun5()
				if table_3f_1(res13) then
					iterPairs1(res13, (function(k3, v5)
						return readMeta1(state36, _2e2e_2(prefix3, k3), v5)
					end))
				else
					fail_21_1(_2e2e_2(path4, ".meta.lua returned a non-table value"))
				end
			else
				error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_9481), ", but none matched.\n", "  Tried: `(nil ?msg)`\n  Tried: `(?fun)`"))
			end
		end
	else
	end
	local lexed2 = lex1(state36["log"], contents3, _2e2e_2(path4, ".lisp"))
	local parsed2 = parse1(state36["log"], lexed2)
	local scope8 = scope_2f_child2(state36["rootScope"])
	scope8["isRoot"] = true
	scope8["prefix"] = prefix3
	lib4["scope"] = scope8
	local compiled1 = compile2(parsed2, state36["global"], state36["variables"], state36["states"], scope8, state36["compileState"], state36["loader"], state36["log"], executeStates1)
	pushCdr_21_1(state36["libs"], lib4)
	if string_3f_1(car2(compiled1)) then
		lib4["docs"] = constVal1(car2(compiled1))
		removeNth_21_1(compiled1, 1)
	else
	end
	lib4["out"] = compiled1
	local r_9601 = _23_1(compiled1)
	local r_9581 = nil
	r_9581 = (function(r_9591)
		if (r_9591 <= r_9601) then
			local node56 = compiled1[r_9591]
			pushCdr_21_1(state36["out"], node56)
			return r_9581((r_9591 + 1))
		else
		end
	end)
	r_9581(1)
	putVerbose_21_1(state36["log"], _2e2e_2("Loaded ", path4, " into ", name31))
	return lib4
end)
pathLocator1 = (function(state37, name32)
	local searched1
	local paths2
	local searcher1
	searched1 = ({tag = "list", n = 0})
	paths2 = state37["paths"]
	searcher1 = (function(i7)
		if (i7 > _23_1(paths2)) then
			return list1(nil, _2e2e_2("Cannot find ", quoted1(name32), ".\nLooked in ", concat1(searched1, ", ")))
		else
			local path5 = gsub1(nth1(paths2, i7), "%?", name32)
			local cached1 = state37["libCache"][path5]
			pushCdr_21_1(searched1, path5)
			if (cached1 == nil) then
				local handle7 = open1(_2e2e_2(path5, ".lisp"), "r")
				if handle7 then
					state37["libCache"][path5] = true
					local lib5 = readLibrary1(state37, simplifyPath1(path5, paths2), path5, handle7)
					state37["libCache"][path5] = lib5
					return list1(lib5)
				else
					return searcher1((i7 + 1))
				end
			elseif (cached1 == true) then
				return list1(nil, _2e2e_2("Already loading ", name32))
			else
				return list1(cached1)
			end
		end
	end)
	return searcher1(1)
end)
loader1 = (function(state38, name33, shouldResolve1)
	if shouldResolve1 then
		return pathLocator1(state38, name33)
	else
		name33 = gsub1(name33, "%.lisp$", "")
		local r_9391 = state38["libCache"][name33]
		if eq_3f_1(r_9391, nil) then
			local handle8 = open1(_2e2e_2(name33, ".lisp"))
			if handle8 then
				state38["libCache"][name33] = true
				local lib6 = readLibrary1(state38, simplifyPath1(name33, state38["paths"]), name33, handle8)
				state38["libCache"][name33] = lib6
				return list1(lib6)
			else
				return list1(nil, _2e2e_2("Cannot find ", quoted1(name33)))
			end
		elseif eq_3f_1(r_9391, true) then
			return list1(nil, _2e2e_2("Already loading ", name33))
		else
			return list1(r_9391)
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
		local r_9691 = split1(lines10, "\n")
		local r_9721 = _23_1(r_9691)
		local r_9701 = nil
		r_9701 = (function(r_9711)
			if (r_9711 <= r_9721) then
				local line7 = r_9691[r_9711]
				print1(_2e2e_2("  ", line7))
				return r_9701((r_9711 + 1))
			else
			end
		end)
		return r_9701(1)
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
	end)()
	, "explain", (explain5 == true), "put-error!", putError_21_2, "put-warning!", putWarning_21_2, "put-verbose!", putVerbose_21_2, "put-debug!", putDebug_21_2, "put-node-error!", putNodeError_21_2, "put-node-warning!", putNodeWarning_21_2)
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
putNodeError_21_2 = (function(logger17, msg30, node57, explain6, lines11)
	printError_21_1(msg30)
	putTrace_21_1(node57)
	if explain6 then
		printExplain_21_1(logger17["explain"], explain6)
	else
	end
	return putLines_21_1(true, lines11)
end)
putNodeWarning_21_2 = (function(logger18, msg31, node58, explain7, lines12)
	printWarning_21_1(msg31)
	putTrace_21_1(node58)
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
	local previous4 = -1
	local file4 = nth1(entries1, 1)["name"]
	local maxLine1 = foldr1((function(max6, node59)
		if string_3f_1(node59) then
			return max6
		else
			return max2(max6, node59["start"]["line"])
		end
	end), 0, entries1)
	local code3 = _2e2e_2(colored1(92, _2e2e_2(" %", len1(tostring1(maxLine1)), "s |")), " %s")
	local r_9651 = _23_1(entries1)
	local r_9631 = nil
	r_9631 = (function(r_9641)
		if (r_9641 <= r_9651) then
			local position2 = entries1[r_9641]
			local message1 = entries1[succ1(r_9641)]
			if (file4 ~= position2["name"]) then
				file4 = position2["name"]
				print1(colored1(95, _2e2e_2(" ", file4)))
			else
				local temp134
				local r_9741 = (previous4 ~= -1)
				if r_9741 then
					temp134 = (abs1((position2["start"]["line"] - previous4)) > 2)
				else
					temp134 = r_9741
				end
				if temp134 then
					print1(colored1(92, " ..."))
				else
				end
			end
			previous4 = position2["start"]["line"]
			print1(format1(code3, tostring1(position2["start"]["line"]), position2["lines"][position2["start"]["line"]]))
			local pointer1
			if _21_1(range7) then
				pointer1 = "^"
			else
				local temp135
				local r_9751 = position2["finish"]
				if r_9751 then
					temp135 = (position2["start"]["line"] == position2["finish"]["line"])
				else
					temp135 = r_9751
				end
				if temp135 then
					pointer1 = rep1("^", succ1((position2["finish"]["column"] - position2["start"]["column"])))
				else
					pointer1 = "^..."
				end
			end
			print1(format1(code3, "", _2e2e_2(rep1(" ", (position2["start"]["column"] - 1)), pointer1, " ", message1)))
			return r_9631((r_9641 + 2))
		else
		end
	end)
	return r_9631(1)
end)
putTrace_21_1 = (function(node60)
	local previous5 = nil
	local r_9671 = nil
	r_9671 = (function()
		if node60 then
			local formatted1 = formatNode1(node60)
			if (previous5 == nil) then
				print1(colored1(96, _2e2e_2("  => ", formatted1)))
			elseif (previous5 ~= formatted1) then
				print1(_2e2e_2("  in ", formatted1))
			else
			end
			previous5 = formatted1
			node60 = node60["parent"]
			return r_9671()
		else
		end
	end)
	return r_9671()
end)
rootScope2 = require1("tacky.analysis.resolve")["rootScope"]
scope_2f_child3 = require1("tacky.analysis.scope")["child"]
scope_2f_import_21_1 = require1("tacky.analysis.scope")["import"]
local spec15 = create1()
local directory1
local dir1 = nth1(arg1, 0)
dir1 = gsub1(dir1, "urn/cli%.lisp$", "")
dir1 = gsub1(dir1, "urn/cli$", "")
dir1 = gsub1(dir1, "tacky/cli%.lua$", "")
local temp136
local r_10251 = (dir1 ~= "")
if r_10251 then
	temp136 = (charAt1(dir1, -1) ~= "/")
else
	temp136 = r_10251
end
if temp136 then
	dir1 = _2e2e_2(dir1, "/")
else
end
local r_10261 = nil
r_10261 = (function()
	if (sub1(dir1, 1, 2) == "./") then
		dir1 = sub1(dir1, 3)
		return r_10261()
	else
	end
end)
r_10261()
directory1 = dir1
local paths3 = list1("?", "?/init", _2e2e_2(directory1, "lib/?"), _2e2e_2(directory1, "lib/?/init"))
local tasks1 = list1(warning1, optimise2, emitLisp1, emitLua1, task1, task4, task3, task2)
addHelp_21_1(spec15)
addArgument_21_1(spec15, ({tag = "list", n = 2, "--explain", "-e"}), "help", "Explain error messages in more detail.")
addArgument_21_1(spec15, ({tag = "list", n = 2, "--time", "-t"}), "help", "Time how long each task takes to execute.")
addArgument_21_1(spec15, ({tag = "list", n = 2, "--verbose", "-v"}), "help", "Make the output more verbose. Can be used multiple times", "many", true, "default", 0, "action", (function(arg28, data7)
	data7[arg28["name"]] = succ1((function(r_9761)
		if r_9761 then
			return r_9761
		else
			return 0
		end
	end)(data7[arg28["name"]]))
	return nil
end))
addArgument_21_1(spec15, ({tag = "list", n = 2, "--include", "-i"}), "help", "Add an additional argument to the include path.", "many", true, "narg", 1, "default", ({tag = "list", n = 0}), "action", addAction1)
addArgument_21_1(spec15, ({tag = "list", n = 2, "--prelude", "-p"}), "help", "A custom prelude path to use.", "narg", 1, "default", _2e2e_2(directory1, "lib/prelude"))
addArgument_21_1(spec15, ({tag = "list", n = 3, "--output", "--out", "-o"}), "help", "The destination to output to.", "narg", 1, "default", "out")
addArgument_21_1(spec15, ({tag = "list", n = 2, "--wrapper", "-w"}), "help", "A wrapper script to launch Urn with", "narg", 1, "action", (function(a5, b5, value9)
	local args28 = map1(id1, arg1)
	local i8 = 1
	local len9 = _23_1(args28)
	local r_9771 = nil
	r_9771 = (function()
		if (i8 <= len9) then
			local item2 = nth1(args28, i8)
			local temp137
			local r_9781 = (item2 == "--wrapper")
			if r_9781 then
				temp137 = r_9781
			else
				temp137 = (item2 == "-w")
			end
			if temp137 then
				removeNth_21_1(args28, i8)
				removeNth_21_1(args28, i8)
				i8 = succ1(len9)
			elseif find1(item2, "^%-%-wrapper=.*$") then
				removeNth_21_1(args28, i8)
				i8 = succ1(len9)
			elseif find1(item2, "^%-[^-]+w$") then
				args28[i8] = sub1(item2, 1, -2)
				removeNth_21_1(args28, succ1(i8))
				i8 = succ1(len9)
			else
			end
			return r_9771()
		else
		end
	end)
	r_9771()
	local command2 = list1(value9)
	local interp1 = nth1(arg1, -1)
	if interp1 then
		pushCdr_21_1(command2, interp1)
	else
	end
	pushCdr_21_1(command2, nth1(arg1, 0))
	local r_9791 = list1(execute1(concat1(append1(command2, args28), " ")))
	local temp138
	local r_9811 = list_3f_1(r_9791)
	if r_9811 then
		local r_9821 = (_23_1(r_9791) == 3)
		if r_9821 then
			temp138 = true
		else
			temp138 = r_9821
		end
	else
		temp138 = r_9811
	end
	if temp138 then
		local code4 = nth1(r_9791, 3)
		return exit1(code4)
	else
		return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_9791), ", but none matched.\n", "  Tried: `(_ _ ?code)`"))
	end
end))
addArgument_21_1(spec15, ({tag = "list", n = 1, "input"}), "help", "The file(s) to load.", "var", "FILE", "narg", "*")
local r_9891 = _23_1(tasks1)
local r_9871 = nil
r_9871 = (function(r_9881)
	if (r_9881 <= r_9891) then
		local task5 = tasks1[r_9881]
		task5["setup"](spec15)
		return r_9871((r_9881 + 1))
	else
	end
end)
r_9871(1)
local args29 = parse_21_1(spec15)
local logger19 = create4(args29["verbose"], args29["explain"])
local r_9921 = args29["include"]
local r_9951 = _23_1(r_9921)
local r_9931 = nil
r_9931 = (function(r_9941)
	if (r_9941 <= r_9951) then
		local path6 = r_9921[r_9941]
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
		return r_9931((r_9941 + 1))
	else
	end
end)
r_9931(1)
putVerbose_21_1(logger19, _2e2e_2("Using path: ", pretty1(paths3)))
if nil_3f_1(args29["input"]) then
	args29["repl"] = true
else
	args29["emit-lua"] = true
end
local compiler12 = struct1("log", logger19, "paths", paths3, "libEnv", ({}), "libMeta", ({}), "libs", ({tag = "list", n = 0}), "libCache", ({}), "rootScope", rootScope2, "variables", ({}), "states", ({}), "out", ({tag = "list", n = 0}))
compiler12["compileState"] = createState2(compiler12["libMeta"])
compiler12["loader"] = (function(name34)
	return loader1(compiler12, name34, true)
end)
compiler12["global"] = setmetatable1(struct1("_libs", compiler12["libEnv"]), struct1("__index", _5f_G1))
iterPairs1(compiler12["rootScope"]["variables"], (function(_5f_4, var27)
	compiler12["variables"][tostring1(var27)] = var27
	return nil
end))
local start26 = clock1()
local r_9971 = loader1(compiler12, args29["prelude"], false)
local temp139
local r_10001 = list_3f_1(r_9971)
if r_10001 then
	local r_10011 = (_23_1(r_9971) == 2)
	if r_10011 then
		local r_10021 = eq_3f_1(nth1(r_9971, 1), nil)
		if r_10021 then
			temp139 = true
		else
			temp139 = r_10021
		end
	else
		temp139 = r_10011
	end
else
	temp139 = r_10001
end
if temp139 then
	local errorMessage1 = nth1(r_9971, 2)
	putError_21_1(logger19, errorMessage1)
	exit_21_1(1)
else
	local temp140
	local r_10031 = list_3f_1(r_9971)
	if r_10031 then
		local r_10041 = (_23_1(r_9971) == 1)
		if r_10041 then
			temp140 = true
		else
			temp140 = r_10041
		end
	else
		temp140 = r_10031
	end
	if temp140 then
		local lib7 = nth1(r_9971, 1)
		compiler12["rootScope"] = scope_2f_child3(compiler12["rootScope"])
		iterPairs1(lib7["scope"]["exported"], (function(name35, var28)
			return scope_2f_import_21_1(compiler12["rootScope"], name35, var28)
		end))
		local r_10061 = args29["input"]
		local r_10091 = _23_1(r_10061)
		local r_10071 = nil
		r_10071 = (function(r_10081)
			if (r_10081 <= r_10091) then
				local input1 = r_10061[r_10081]
				local r_10111 = loader1(compiler12, input1, false)
				local temp141
				local r_10141 = list_3f_1(r_10111)
				if r_10141 then
					local r_10151 = (_23_1(r_10111) == 2)
					if r_10151 then
						local r_10161 = eq_3f_1(nth1(r_10111, 1), nil)
						if r_10161 then
							temp141 = true
						else
							temp141 = r_10161
						end
					else
						temp141 = r_10151
					end
				else
					temp141 = r_10141
				end
				if temp141 then
					local errorMessage2 = nth1(r_10111, 2)
					putError_21_1(logger19, errorMessage2)
					exit_21_1(1)
				else
					local temp142
					local r_10171 = list_3f_1(r_10111)
					if r_10171 then
						local r_10181 = (_23_1(r_10111) == 1)
						if r_10181 then
							temp142 = true
						else
							temp142 = r_10181
						end
					else
						temp142 = r_10171
					end
					if temp142 then
					else
						error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_10111), ", but none matched.\n", "  Tried: `(nil ?error-message)`\n  Tried: `(_)`"))
					end
				end
				return r_10071((r_10081 + 1))
			else
			end
		end)
		r_10071(1)
	else
		error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_9971), ", but none matched.\n", "  Tried: `(nil ?error-message)`\n  Tried: `(?lib)`"))
	end
end
if args29["time"] then
	print1(_2e2e_2("parsing took ", (clock1() - start26)))
else
end
local r_10231 = _23_1(tasks1)
local r_10211 = nil
r_10211 = (function(r_10221)
	if (r_10221 <= r_10231) then
		local task6 = tasks1[r_10221]
		if task6["pred"](args29) then
			local start27 = clock1()
			task6["run"](compiler12, args29)
			if args29["time"] then
				print1(_2e2e_2(task6["name"], " took ", (clock1() - start27)))
			else
			end
		else
		end
		return r_10211((r_10221 + 1))
	else
	end
end)
return r_10211(1)
