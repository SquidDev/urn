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
for k, v in pairs(_temp) do _libs["urn/cli-16/".. k] = v end
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
				local out2 = ({tag = "list", n = 0})
				iterPairs1(value1, (function(k1, v1)
					out2 = cons1((pretty1(k1) .. (" " .. pretty1(v1))), out2)
					return nil
				end))
				return ("(struct " .. (concat1(out2, " ") .. ")"))
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
		local r_161
		local r_341 = list_3f_1(x5)
		r_161 = r_341 and (_23_1(x5) == 0)
		if r_161 then
			return r_161
		else
			local r_171 = string_3f_1(x5)
			return r_171 and (#(x5) == 0)
		end
	else
		return x5
	end
end)
string_3f_1 = (function(x6)
	local r_181 = (type_23_1(x6) == "string")
	if r_181 then
		return r_181
	else
		local r_191 = (type_23_1(x6) == "table")
		return r_191 and (x6["tag"] == "string")
	end
end)
number_3f_1 = (function(x7)
	local r_201 = (type_23_1(x7) == "number")
	if r_201 then
		return r_201
	else
		local r_211 = (type_23_1(x7) == "table")
		return r_211 and (x7["tag"] == "number")
	end
end)
symbol_3f_1 = (function(x8)
	return (type1(x8) == "symbol")
end)
key_3f_1 = (function(x9)
	return (type1(x9) == "key")
end)
atom_3f_1 = (function(x10)
	local r_241 = (type_23_1(x10) ~= "table")
	if r_241 then
		return r_241
	else
		local r_251 = (type_23_1(x10) == "table")
		if r_251 then
			local r_261 = (x10["tag"] == "symbol")
			return r_261 or (x10["tag"] == "key")
		else
			return r_251
		end
	end
end)
between_3f_1 = (function(val2, min1, max1)
	local r_271 = (val2 >= min1)
	return r_271 and (val2 <= max1)
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
eq_3f_1 = (function(x11, y1)
	if (x11 == y1) then
		return true
	else
		local typeX1 = type1(x11)
		local typeY1 = type1(y1)
		local temp2
		local r_281 = (typeX1 == "list")
		if r_281 then
			local r_291 = (typeY1 == "list")
			temp2 = r_291 and (_23_1(x11) == _23_1(y1))
		else
			temp2 = r_281
		end
		if temp2 then
			local equal1 = true
			local r_321 = _23_1(x11)
			local r_301 = nil
			r_301 = (function(r_311)
				if (r_311 <= r_321) then
					if neq_3f_1(x11[r_311], y1[r_311]) then
						equal1 = false
					else
					end
					return r_301((r_311 + 1))
				else
				end
			end)
			r_301(1)
			return equal1
		else
			local temp3
			local r_351 = ("symbol" == typeX1)
			temp3 = r_351 and ("symbol" == typeY1)
			if temp3 then
				return (x11["contents"] == y1["contents"])
			else
				local temp4
				local r_361 = ("key" == typeX1)
				temp4 = r_361 and ("key" == typeY1)
				if temp4 then
					return (x11["value"] == y1["value"])
				else
					local temp5
					local r_371 = ("symbol" == typeX1)
					temp5 = r_371 and ("string" == typeY1)
					if temp5 then
						return (x11["contents"] == y1)
					else
						local temp6
						local r_381 = ("string" == typeX1)
						temp6 = r_381 and ("symbol" == typeY1)
						if temp6 then
							return (x11 == y1["contents"])
						else
							local temp7
							local r_391 = ("key" == typeX1)
							temp7 = r_391 and ("string" == typeY1)
							if temp7 then
								return (x11["value"] == y1)
							else
								local temp8
								local r_401 = ("string" == typeX1)
								temp8 = r_401 and ("key" == typeY1)
								if temp8 then
									return (x11 == y1["value"])
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
neq_3f_1 = (function(x12, y2)
	return _21_1(eq_3f_1(x12, y2))
end)
abs1 = math.abs
huge1 = math.huge
max2 = math.max
modf1 = math.modf
car2 = (function(x13)
	local r_571 = type1(x13)
	if (r_571 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_571), 2)
	else
	end
	return car1(x13)
end)
cdr2 = (function(x14)
	local r_581 = type1(x14)
	if (r_581 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_581), 2)
	else
	end
	if nil_3f_1(x14) then
		return ({tag = "list", n = 0})
	else
		return cdr1(x14)
	end
end)
take1 = (function(xs5, n1)
	return slice1(xs5, 1, n1)
end)
foldr1 = (function(f1, z1, xs6)
	local r_591 = type1(f1)
	if (r_591 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "f", "function", r_591), 2)
	else
	end
	local r_601 = type1(xs6)
	if (r_601 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_601), 2)
	else
	end
	local accum1 = z1
	local r_631 = _23_1(xs6)
	local r_611 = nil
	r_611 = (function(r_621)
		if (r_621 <= r_631) then
			accum1 = f1(accum1, nth1(xs6, r_621))
			return r_611((r_621 + 1))
		else
		end
	end)
	r_611(1)
	return accum1
end)
map1 = (function(f2, xs7)
	local r_651 = type1(f2)
	if (r_651 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "f", "function", r_651), 2)
	else
	end
	local r_661 = type1(xs7)
	if (r_661 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_661), 2)
	else
	end
	local out3 = ({tag = "list", n = 0})
	local r_691 = _23_1(xs7)
	local r_671 = nil
	r_671 = (function(r_681)
		if (r_681 <= r_691) then
			pushCdr_21_1(out3, f2(nth1(xs7, r_681)))
			return r_671((r_681 + 1))
		else
		end
	end)
	r_671(1)
	return out3
end)
any1 = (function(p1, xs8)
	local r_771 = type1(p1)
	if (r_771 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "p", "function", r_771), 2)
	else
	end
	local r_781 = type1(xs8)
	if (r_781 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_781), 2)
	else
	end
	return accumulateWith1(p1, _2d_or1, false, xs8)
end)
all1 = (function(p2, xs9)
	local r_791 = type1(p2)
	if (r_791 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "p", "function", r_791), 2)
	else
	end
	local r_801 = type1(xs9)
	if (r_801 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_801), 2)
	else
	end
	return accumulateWith1(p2, _2d_and1, true, xs9)
end)
traverse1 = (function(xs10, f3)
	return map1(f3, xs10)
end)
last1 = (function(xs11)
	local r_831 = type1(xs11)
	if (r_831 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_831), 2)
	else
	end
	return xs11[_23_1(xs11)]
end)
nth1 = (function(xs12, idx1)
	return xs12[idx1]
end)
pushCdr_21_1 = (function(xs13, val4)
	local r_841 = type1(xs13)
	if (r_841 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_841), 2)
	else
	end
	local len2 = (_23_1(xs13) + 1)
	xs13["n"] = len2
	xs13[len2] = val4
	return xs13
end)
popLast_21_1 = (function(xs14)
	local r_851 = type1(xs14)
	if (r_851 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_851), 2)
	else
	end
	local x15 = xs14[_23_1(xs14)]
	xs14[_23_1(xs14)] = nil
	xs14["n"] = (_23_1(xs14) - 1)
	return x15
end)
removeNth_21_1 = (function(li1, idx2)
	local r_861 = type1(li1)
	if (r_861 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_861), 2)
	else
	end
	li1["n"] = (li1["n"] - 1)
	return remove1(li1, idx2)
end)
append1 = (function(xs15, ys1)
	return (function()
		local _offset, _result, _temp = 0, {tag="list",n=0}
		_temp = xs15
		for _c = 1, _temp.n do _result[0 + _c + _offset] = _temp[_c] end
		_offset = _offset + _temp.n
		_temp = ys1
		for _c = 1, _temp.n do _result[0 + _c + _offset] = _temp[_c] end
		_offset = _offset + _temp.n
		_result.n = _offset + 0
		return _result
	end)()
end)
accumulateWith1 = (function(f4, ac1, z2, xs16)
	local r_881 = type1(f4)
	if (r_881 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "f", "function", r_881), 2)
	else
	end
	local r_891 = type1(ac1)
	if (r_891 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "ac", "function", r_891), 2)
	else
	end
	return foldr1(ac1, z2, map1(f4, xs16))
end)
caar1 = (function(x16)
	return car2(car2(x16))
end)
cadr1 = (function(x17)
	return car2(cdr2(x17))
end)
cadar1 = (function(x18)
	return car2(cdr2(car2(x18)))
end)
charAt1 = (function(xs17, x19)
	return sub1(xs17, x19, x19)
end)
_2e2e_2 = (function(...)
	local args1 = _pack(...) args1.tag = "list"
	return concat1(args1)
end)
split1 = (function(text1, pattern1, limit1)
	local out4 = ({tag = "list", n = 0})
	local loop1 = true
	local start1 = 1
	local r_961 = nil
	r_961 = (function()
		if loop1 then
			local pos1 = list1(find1(text1, pattern1, start1))
			local nstart1 = car2(pos1)
			local nend1 = cadr1(pos1)
			local temp9
			local r_971 = (nstart1 == nil)
			temp9 = r_971 or limit1 and (_23_1(out4) >= limit1)
			if temp9 then
				loop1 = false
				pushCdr_21_1(out4, sub1(text1, start1, len1(text1)))
				start1 = (len1(text1) + 1)
			elseif (nstart1 > len1(text1)) then
				if (start1 <= len1(text1)) then
					pushCdr_21_1(out4, sub1(text1, start1, len1(text1)))
				else
				end
				loop1 = false
			elseif (nend1 < nstart1) then
				pushCdr_21_1(out4, sub1(text1, start1, nstart1))
				start1 = (nstart1 + 1)
			else
				pushCdr_21_1(out4, sub1(text1, start1, (nstart1 - 1)))
				start1 = (nend1 + 1)
			end
			return r_961()
		else
		end
	end)
	r_961()
	return out4
end)
local escapes1 = ({})
local r_921 = nil
r_921 = (function(r_931)
	if (r_931 <= 31) then
		escapes1[char1(r_931)] = _2e2e_2("\\", tostring1(r_931))
		return r_921((r_931 + 1))
	else
	end
end)
r_921(0)
escapes1["\n"] = "n"
quoted1 = (function(str1)
	return (gsub1(format1("%q", str1), ".", escapes1))
end)
clock1 = os.clock
execute1 = os.execute
exit1 = os.exit
getenv1 = os.getenv
assoc1 = (function(list2, key1, orVal1)
	local temp10
	local r_991 = _21_1(list_3f_1(list2))
	temp10 = r_991 or nil_3f_1(list2)
	if temp10 then
		return orVal1
	elseif eq_3f_1(caar1(list2), key1) then
		return cadar1(list2)
	else
		return assoc1(cdr2(list2), key1, orVal1)
	end
end)
assoc_3f_1 = (function(list3, key2)
	local temp11
	local r_1001 = _21_1(list_3f_1(list3))
	temp11 = r_1001 or nil_3f_1(list3)
	if temp11 then
		return false
	elseif eq_3f_1(caar1(list3), key2) then
		return true
	else
		return assoc_3f_1(cdr2(list3), key2)
	end
end)
struct1 = (function(...)
	local entries1 = _pack(...) entries1.tag = "list"
	if ((_23_1(entries1) % 1) == 1) then
		error1("Expected an even number of arguments to struct", 2)
	else
	end
	local out5 = ({})
	local r_1071 = _23_1(entries1)
	local r_1051 = nil
	r_1051 = (function(r_1061)
		if (r_1061 <= r_1071) then
			local key3 = entries1[r_1061]
			local val5 = entries1[(1 + r_1061)]
			out5[(function()
				if key_3f_1(key3) then
					return key3["contents"]
				else
					return key3
				end
			end)()
			] = val5
			return r_1051((r_1061 + 2))
		else
		end
	end)
	r_1051(1)
	return out5
end)
values1 = (function(st1)
	local out6 = ({tag = "list", n = 0})
	iterPairs1(st1, (function(_5f_1, v2)
		return pushCdr_21_1(out6, v2)
	end))
	return out6
end)
createLookup1 = (function(values2)
	local res1 = ({})
	local r_1191 = _23_1(values2)
	local r_1171 = nil
	r_1171 = (function(r_1181)
		if (r_1181 <= r_1191) then
			res1[nth1(values2, r_1181)] = r_1181
			return r_1171((r_1181 + 1))
		else
		end
	end)
	r_1171(1)
	return res1
end)
flush1 = io.flush
open1 = io.open
read1 = io.read
write1 = io.write
succ1 = (function(x20)
	return (x20 + 1)
end)
pred1 = (function(x21)
	return (x21 - 1)
end)
symbol_2d3e_string1 = (function(x22)
	if symbol_3f_1(x22) then
		return x22["contents"]
	else
		return nil
	end
end)
string_2d3e_symbol1 = (function(x23)
	return struct1("tag", "symbol", "contents", x23)
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
self1 = (function(x26, key4, ...)
	local args2 = _pack(...) args2.tag = "list"
	return x26[key4](x26, unpack1(args2, 1, _23_1(args2)))
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
	local r_2141 = type1(names1)
	if (r_2141 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "names", "list", r_2141), 2)
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
	local result1 = struct1("names", names1, "action", nil, "narg", 0, "default", false, "help", "", "value", true)
	local first1 = car2(names1)
	if (sub1(first1, 1, 2) == "--") then
		pushCdr_21_1(spec1["opt"], result1)
		result1["name"] = sub1(first1, 3)
	elseif (sub1(first1, 1, 1) == "-") then
		pushCdr_21_1(spec1["opt"], result1)
		result1["name"] = sub1(first1, 2)
	else
		result1["name"] = first1
		result1["narg"] = "*"
		result1["default"] = ({tag = "list", n = 0})
		pushCdr_21_1(spec1["pos"], result1)
	end
	local r_2191 = _23_1(names1)
	local r_2171 = nil
	r_2171 = (function(r_2181)
		if (r_2181 <= r_2191) then
			local name1 = names1[r_2181]
			if (sub1(name1, 1, 2) == "--") then
				spec1["opt-map"][sub1(name1, 3)] = result1
			elseif (sub1(name1, 1, 1) == "-") then
				spec1["flag-map"][sub1(name1, 2)] = result1
			else
			end
			return r_2171((r_2181 + 1))
		else
		end
	end)
	r_2171(1)
	local r_2231 = _23_1(options1)
	local r_2211 = nil
	r_2211 = (function(r_2221)
		if (r_2221 <= r_2231) then
			local key5 = nth1(options1, r_2221)
			result1[key5] = (nth1(options1, (r_2221 + 1)))
			return r_2211((r_2221 + 2))
		else
		end
	end)
	r_2211(1)
	if result1["var"] then
	else
		result1["var"] = upper1(result1["name"])
	end
	if result1["action"] then
	else
		result1["action"] = (function()
			local temp12
			if number_3f_1(result1["narg"]) then
				temp12 = (result1["narg"] <= 1)
			else
				temp12 = (result1["narg"] == "?")
			end
			if temp12 then
				return setAction1
			else
				return addAction1
			end
		end)()
	end
	return result1
end)
addHelp_21_1 = (function(spec2)
	return addArgument_21_1(spec2, ({tag = "list", n = 2, "--help", "-h"}), "help", "Show this help message", "default", nil, "value", nil, "action", (function(arg4, result2, value5)
		help_21_1(spec2)
		return exit_21_1(0)
	end))
end)
helpNarg_21_1 = (function(buffer1, arg5)
	local r_2661 = arg5["narg"]
	if (r_2661 == "?") then
		return pushCdr_21_1(buffer1, _2e2e_2(" [", arg5["var"], "]"))
	elseif (r_2661 == "*") then
		return pushCdr_21_1(buffer1, _2e2e_2(" [", arg5["var"], "...]"))
	elseif (r_2661 == "+") then
		return pushCdr_21_1(buffer1, _2e2e_2(" ", arg5["var"], " [", arg5["var"], "...]"))
	else
		local r_2671 = nil
		r_2671 = (function(r_2681)
			if (r_2681 <= r_2661) then
				pushCdr_21_1(buffer1, _2e2e_2(" ", arg5["var"]))
				return r_2671((r_2681 + 1))
			else
			end
		end)
		return r_2671(1)
	end
end)
usage_21_2 = (function(spec3, name2)
	if name2 then
	else
		local r_2251 = nth1(arg1, 0)
		if r_2251 then
			name2 = r_2251
		else
			local r_2261 = nth1(arg1, -1)
			name2 = r_2261 or "?"
		end
	end
	local usage1 = list1("usage: ", name2)
	local r_2281 = spec3["opt"]
	local r_2311 = _23_1(r_2281)
	local r_2291 = nil
	r_2291 = (function(r_2301)
		if (r_2301 <= r_2311) then
			local arg6 = r_2281[r_2301]
			pushCdr_21_1(usage1, _2e2e_2(" [", car2(arg6["names"])))
			helpNarg_21_1(usage1, arg6)
			pushCdr_21_1(usage1, "]")
			return r_2291((r_2301 + 1))
		else
		end
	end)
	r_2291(1)
	local r_2341 = spec3["pos"]
	local r_2371 = _23_1(r_2341)
	local r_2351 = nil
	r_2351 = (function(r_2361)
		if (r_2361 <= r_2371) then
			helpNarg_21_1(usage1, (r_2341[r_2361]))
			return r_2351((r_2361 + 1))
		else
		end
	end)
	r_2351(1)
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
		local r_2391 = nth1(arg1, 0)
		if r_2391 then
			name4 = r_2391
		else
			local r_2401 = nth1(arg1, -1)
			name4 = r_2401 or "?"
		end
	end
	usage_21_2(spec5, name4)
	if spec5["desc"] then
		print1()
		print1(spec5["desc"])
	else
	end
	local max3 = 0
	local r_2421 = spec5["pos"]
	local r_2451 = _23_1(r_2421)
	local r_2431 = nil
	r_2431 = (function(r_2441)
		if (r_2441 <= r_2451) then
			local arg7 = r_2421[r_2441]
			local len3 = len1(arg7["var"])
			if (len3 > max3) then
				max3 = len3
			else
			end
			return r_2431((r_2441 + 1))
		else
		end
	end)
	r_2431(1)
	local r_2481 = spec5["opt"]
	local r_2511 = _23_1(r_2481)
	local r_2491 = nil
	r_2491 = (function(r_2501)
		if (r_2501 <= r_2511) then
			local arg8 = r_2481[r_2501]
			local len4 = len1(concat1(arg8["names"], ", "))
			if (len4 > max3) then
				max3 = len4
			else
			end
			return r_2491((r_2501 + 1))
		else
		end
	end)
	r_2491(1)
	local fmt1 = _2e2e_2(" %-", tostring1((max3 + 1)), "s %s")
	if nil_3f_1(spec5["pos"]) then
	else
		print1()
		print1("Positional arguments")
		local r_2541 = spec5["pos"]
		local r_2571 = _23_1(r_2541)
		local r_2551 = nil
		r_2551 = (function(r_2561)
			if (r_2561 <= r_2571) then
				local arg9 = r_2541[r_2561]
				print1(format1(fmt1, arg9["var"], arg9["help"]))
				return r_2551((r_2561 + 1))
			else
			end
		end)
		r_2551(1)
	end
	if nil_3f_1(spec5["opt"]) then
	else
		print1()
		print1("Optional arguments")
		local r_2601 = spec5["opt"]
		local r_2631 = _23_1(r_2601)
		local r_2611 = nil
		r_2611 = (function(r_2621)
			if (r_2621 <= r_2631) then
				local arg10 = r_2601[r_2621]
				print1(format1(fmt1, concat1(arg10["names"], ", "), arg10["help"]))
				return r_2611((r_2621 + 1))
			else
			end
		end)
		return r_2611(1)
	end
end)
matcher1 = (function(pattern2)
	return (function(x27)
		local res2 = list1(match1(x27, pattern2))
		if (car2(res2) == nil) then
			return nil
		else
			return res2
		end
	end)
end)
parse_21_1 = (function(spec6, args3)
	if args3 then
	else
		args3 = arg1
	end
	local result3 = ({})
	local pos2 = spec6["pos"]
	local idx3 = 1
	local len5 = _23_1(args3)
	local usage_21_3 = (function(msg1)
		return usageError_21_1(spec6, nth1(args3, 0), msg1)
	end)
	local action1 = (function(arg11, value6)
		return arg11["action"](arg11, result3, value6, usage_21_3)
	end)
	local readArgs1 = (function(key6, arg12)
		local r_3021 = arg12["narg"]
		if (r_3021 == "+") then
			idx3 = (idx3 + 1)
			local elem1 = nth1(args3, idx3)
			if (elem1 == nil) then
				usage_21_3(_2e2e_2("Expected ", arg12["var"], " after --", key6, ", got nothing"))
			else
				local temp13
				local r_3031 = _21_1(arg12["all"])
				temp13 = r_3031 and find1(elem1, "^%-")
				if temp13 then
					usage_21_3(_2e2e_2("Expected ", arg12["var"], " after --", key6, ", got ", nth1(args3, idx3)))
				else
					action1(arg12, elem1)
				end
			end
			local running1 = true
			local r_3041 = nil
			r_3041 = (function()
				if running1 then
					idx3 = (idx3 + 1)
					local elem2 = nth1(args3, idx3)
					if (elem2 == nil) then
						running1 = false
					else
						local temp14
						local r_3051 = _21_1(arg12["all"])
						temp14 = r_3051 and find1(elem2, "^%-")
						if temp14 then
							running1 = false
						else
							action1(arg12, elem2)
						end
					end
					return r_3041()
				else
				end
			end)
			return r_3041()
		elseif (r_3021 == "*") then
			local running2 = true
			local r_3061 = nil
			r_3061 = (function()
				if running2 then
					idx3 = (idx3 + 1)
					local elem3 = nth1(args3, idx3)
					if (elem3 == nil) then
						running2 = false
					else
						local temp15
						local r_3071 = _21_1(arg12["all"])
						temp15 = r_3071 and find1(elem3, "^%-")
						if temp15 then
							running2 = false
						else
							action1(arg12, elem3)
						end
					end
					return r_3061()
				else
				end
			end)
			return r_3061()
		elseif (r_3021 == "?") then
			idx3 = (idx3 + 1)
			local elem4 = nth1(args3, idx3)
			local temp16
			local r_3081 = (elem4 == nil)
			if r_3081 then
				temp16 = r_3081
			else
				local r_3091 = _21_1(arg12["all"])
				temp16 = r_3091 and find1(elem4, "^%-")
			end
			if temp16 then
				return arg12["action"](arg12, result3, arg12["value"])
			else
				idx3 = (idx3 + 1)
				return action1(arg12, elem4)
			end
		elseif (r_3021 == 0) then
			idx3 = (idx3 + 1)
			return action1(arg12, arg12["value"])
		else
			local r_3101 = nil
			r_3101 = (function(r_3111)
				if (r_3111 <= r_3021) then
					idx3 = (idx3 + 1)
					local elem5 = nth1(args3, idx3)
					if (elem5 == nil) then
						usage_21_3(_2e2e_2("Expected ", r_3021, " args for ", key6, ", got ", pred1(r_3111)))
					else
						local temp17
						local r_3141 = _21_1(arg12["all"])
						temp17 = r_3141 and find1(elem5, "^%-")
						if temp17 then
							usage_21_3(_2e2e_2("Expected ", r_3021, " for ", key6, ", got ", pred1(r_3111)))
						else
							action1(arg12, elem5)
						end
					end
					return r_3101((r_3111 + 1))
				else
				end
			end)
			r_3101(1)
			idx3 = (idx3 + 1)
			return nil
		end
	end)
	local r_2651 = nil
	r_2651 = (function()
		if (idx3 <= len5) then
			local r_2711 = nth1(args3, idx3)
			local temp18
			local r_2721 = matcher1("^%-%-([^=]+)=(.+)$")(r_2711)
			local r_2751 = list_3f_1(r_2721)
			if r_2751 then
				local r_2761 = (_23_1(r_2721) >= 2)
				if r_2761 then
					local r_2771 = (_23_1(r_2721) <= 2)
					temp18 = r_2771 and true
				else
					temp18 = r_2761
				end
			else
				temp18 = r_2751
			end
			if temp18 then
				local key7 = nth1(matcher1("^%-%-([^=]+)=(.+)$")(r_2711), 1)
				local val7 = nth1(matcher1("^%-%-([^=]+)=(.+)$")(r_2711), 2)
				local arg13 = spec6["opt-map"][key7]
				if (arg13 == nil) then
					usage_21_3(_2e2e_2("Unknown argument ", key7, " in ", nth1(args3, idx3)))
				else
					local temp19
					local r_2791 = _21_1(arg13["many"])
					temp19 = r_2791 and (nil ~= result3[arg13["name"]])
					if temp19 then
						usage_21_3(_2e2e_2("Too may values for ", key7, " in ", nth1(args3, idx3)))
					else
						local narg1 = arg13["narg"]
						local temp20
						local r_2801 = number_3f_1(narg1)
						temp20 = r_2801 and (narg1 ~= 1)
						if temp20 then
							usage_21_3(_2e2e_2("Expected ", tostring1(narg1), " values, got 1 in ", nth1(args3, idx3)))
						else
						end
						action1(arg13, val7)
					end
				end
				idx3 = (idx3 + 1)
			else
				local temp21
				local r_2731 = matcher1("^%-%-(.*)$")(r_2711)
				local r_2811 = list_3f_1(r_2731)
				if r_2811 then
					local r_2821 = (_23_1(r_2731) >= 1)
					if r_2821 then
						local r_2831 = (_23_1(r_2731) <= 1)
						temp21 = r_2831 and true
					else
						temp21 = r_2821
					end
				else
					temp21 = r_2811
				end
				if temp21 then
					local key8 = nth1(matcher1("^%-%-(.*)$")(r_2711), 1)
					local arg14 = spec6["opt-map"][key8]
					if (arg14 == nil) then
						usage_21_3(_2e2e_2("Unknown argument ", key8, " in ", nth1(args3, idx3)))
					else
						local temp22
						local r_2841 = _21_1(arg14["many"])
						temp22 = r_2841 and (nil ~= result3[arg14["name"]])
						if temp22 then
							usage_21_3(_2e2e_2("Too may values for ", key8, " in ", nth1(args3, idx3)))
						else
							readArgs1(key8, arg14)
						end
					end
				else
					local temp23
					local r_2741 = matcher1("^%-(.+)$")(r_2711)
					local r_2851 = list_3f_1(r_2741)
					if r_2851 then
						local r_2861 = (_23_1(r_2741) >= 1)
						if r_2861 then
							local r_2871 = (_23_1(r_2741) <= 1)
							temp23 = r_2871 and true
						else
							temp23 = r_2861
						end
					else
						temp23 = r_2851
					end
					if temp23 then
						local flags1 = nth1(matcher1("^%-(.+)$")(r_2711), 1)
						local i1 = 1
						local s1 = len1(flags1)
						local r_2881 = nil
						r_2881 = (function()
							if (i1 <= s1) then
								local key9 = charAt1(flags1, i1)
								local arg15 = spec6["flag-map"][key9]
								if (arg15 == nil) then
									usage_21_3(_2e2e_2("Unknown flag ", key9, " in ", nth1(args3, idx3)))
								else
									local temp24
									local r_2891 = _21_1(arg15["many"])
									temp24 = r_2891 and (nil ~= result3[arg15["name"]])
									if temp24 then
										usage_21_3(_2e2e_2("Too many occurances of ", key9, " in ", nth1(args3, idx3)))
									else
										local narg2 = arg15["narg"]
										if (i1 == s1) then
											readArgs1(key9, arg15)
										elseif (narg2 == 0) then
											action1(arg15, arg15["value"])
										else
											action1(arg15, sub1(flags1, succ1(i1)))
											i1 = succ1(s1)
											idx3 = (idx3 + 1)
										end
									end
								end
								i1 = (i1 + 1)
								return r_2881()
							else
							end
						end)
						r_2881()
					else
						local arg16 = car2(spec6["pos"])
						if arg16 then
							action1(arg16, r_2711)
						else
							usage_21_3(_2e2e_2("Unknown argument ", arg16))
						end
						idx3 = (idx3 + 1)
					end
				end
			end
			return r_2651()
		else
		end
	end)
	r_2651()
	local r_2911 = spec6["opt"]
	local r_2941 = _23_1(r_2911)
	local r_2921 = nil
	r_2921 = (function(r_2931)
		if (r_2931 <= r_2941) then
			local arg17 = r_2911[r_2931]
			if (result3[arg17["name"]] == nil) then
				result3[arg17["name"]] = arg17["default"]
			else
			end
			return r_2921((r_2931 + 1))
		else
		end
	end)
	r_2921(1)
	local r_2971 = spec6["pos"]
	local r_3001 = _23_1(r_2971)
	local r_2981 = nil
	r_2981 = (function(r_2991)
		if (r_2991 <= r_3001) then
			local arg18 = r_2971[r_2991]
			if (result3[arg18["name"]] == nil) then
				result3[arg18["name"]] = arg18["default"]
			else
			end
			return r_2981((r_2991 + 1))
		else
		end
	end)
	r_2981(1)
	return result3
end)
builtins1 = require1("tacky.analysis.resolve")["builtins"]
builtinVars1 = require1("tacky.analysis.resolve")["declaredVars"]
builtin_3f_1 = (function(node1, name5)
	local r_3191 = symbol_3f_1(node1)
	return r_3191 and (node1["var"] == builtins1[name5])
end)
builtinVar_3f_1 = (function(node2, name6)
	local r_3201 = symbol_3f_1(node2)
	return r_3201 and (node2["var"] == builtinVars1[name6])
end)
sideEffect_3f_1 = (function(node3)
	local tag4 = type1(node3)
	local temp25
	local r_3211 = (tag4 == "number")
	if r_3211 then
		temp25 = r_3211
	else
		local r_3221 = (tag4 == "string")
		if r_3221 then
			temp25 = r_3221
		else
			local r_3231 = (tag4 == "key")
			temp25 = r_3231 or (tag4 == "symbol")
		end
	end
	if temp25 then
		return false
	elseif (tag4 == "list") then
		local fst1 = car2(node3)
		if (type1(fst1) == "symbol") then
			local var1 = fst1["var"]
			local r_3241 = (var1 ~= builtins1["lambda"])
			return r_3241 and (var1 ~= builtins1["quote"])
		else
			return true
		end
	else
		_error("unmatched item")
	end
end)
constant_3f_1 = (function(node4)
	local r_3251 = string_3f_1(node4)
	if r_3251 then
		return r_3251
	else
		local r_3261 = number_3f_1(node4)
		return r_3261 or key_3f_1(node4)
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
val_2d3e_urn1 = (function(val8)
	local ty3 = type_23_1(val8)
	if (ty3 == "string") then
		return {["tag"]="string",["value"]=val8}
	elseif (ty3 == "number") then
		return {["tag"]="number",["value"]=val8}
	elseif (ty3 == "nil") then
		return {["tag"]="symbol",["contents"]="nil",["var"]=builtinVars1["nil"]}
	elseif (ty3 == "boolean") then
		return {["tag"]="symbol",["contents"]=tostring1(val8),["var"]=builtinVars1[tostring1(val8)]}
	else
		_error("unmatched item")
	end
end)
urn_2d3e_bool1 = (function(node6)
	local temp26
	local r_3311 = string_3f_1(node6)
	if r_3311 then
		temp26 = r_3311
	else
		local r_3321 = key_3f_1(node6)
		temp26 = r_3321 or number_3f_1(node6)
	end
	if temp26 then
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
	return ({tag = "list", n = 1, (function()
		local _offset, _result, _temp = 0, {tag="list",n=0}
		_result[1 + _offset] = makeSymbol1(builtins1["lambda"])
		_result[2 + _offset] = ({tag = "list", n = 0})
		_temp = body1
		for _c = 1, _temp.n do _result[2 + _c + _offset] = _temp[_c] end
		_offset = _offset + _temp.n
		_result.n = _offset + 2
		return _result
	end)()
	})
end)
makeSymbol1 = (function(var2)
	return {["tag"]="symbol",["contents"]=var2["name"],["var"]=var2}
end)
local r_3351 = builtinVars1["nil"]
makeNil1 = (function()
	return makeSymbol1(r_3351)
end)
fastAll1 = (function(fn1, li2, i2)
	if (i2 > _23_1(li2)) then
		return true
	elseif fn1(nth1(li2, i2)) then
		return fastAll1(fn1, li2, (i2 + 1))
	else
		return false
	end
end)
create2 = (function(fn2)
	return {["callback"]=fn2,["timers"]=({})}
end)
startTimer_21_1 = (function(timer1, name7, level1)
	local instance1 = timer1["timers"][name7]
	if instance1 then
	else
		instance1 = {["name"]=name7,["level"]=level1 or 1,["running"]=false,["total"]=0}
		timer1["timers"][name7] = instance1
	end
	if instance1["running"] then
		error1(_2e2e_2("Timer ", name7, " is already running"))
	else
	end
	instance1["running"] = true
	instance1["start"] = clock1()
	return nil
end)
pauseTimer_21_1 = (function(timer2, name8)
	local instance2 = timer2["timers"][name8]
	if instance2 then
	else
		error1(_2e2e_2("Timer ", name8, " does not exist"))
	end
	if instance2["running"] then
	else
		error1(_2e2e_2("Timer ", name8, " is not running"))
	end
	instance2["running"] = false
	instance2["total"] = ((clock1() - instance2["start"]) + instance2["total"])
	return nil
end)
stopTimer_21_1 = (function(timer3, name9)
	local instance3 = timer3["timers"][name9]
	if instance3 then
	else
		error1(_2e2e_2("Timer ", name9, " does not exist"))
	end
	if instance3["running"] then
	else
		error1(_2e2e_2("Timer ", name9, " is not running"))
	end
	timer3["timers"][name9] = nil
	instance3["total"] = ((clock1() - instance3["start"]) + instance3["total"])
	return timer3["callback"](instance3["name"], instance3["total"], instance3["level"])
end)
void1 = create2((function()
end))
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
putTime_21_1 = (function(logger5, name10, time1, level2)
	return self1(logger5, "put-time!", name10, time1, level2)
end)
putNodeError_21_1 = (function(logger6, msg6, node7, explain1, ...)
	local lines1 = _pack(...) lines1.tag = "list"
	return self1(logger6, "put-node-error!", msg6, node7, explain1, lines1)
end)
putNodeWarning_21_1 = (function(logger7, msg7, node8, explain2, ...)
	local lines2 = _pack(...) lines2.tag = "list"
	return self1(logger7, "put-node-warning!", msg7, node8, explain2, lines2)
end)
doNodeError_21_1 = (function(logger8, msg8, node9, explain3, ...)
	local lines3 = _pack(...) lines3.tag = "list"
	self1(logger8, "put-node-error!", msg8, node9, explain3, lines3)
	return fail_21_1((function(r_3411)
		return r_3411 or msg8
	end)(match1(msg8, "^([^\n]+)\n")))
end)
struct1("startTimer", startTimer_21_1, "pauseTimer", pauseTimer_21_1, "stopTimer", stopTimer_21_1, "putError", putError_21_1, "putWarning", putWarning_21_1, "putVerbose", putVerbose_21_1, "putDebug", putDebug_21_1, "putNodeError", putNodeError_21_1, "putNodeWarning", putNodeWarning_21_1, "doNodeError", doNodeError_21_1)
createTracker1 = (function()
	return struct1("changed", false)
end)
changed_3f_1 = (function(tracker1)
	return tracker1["changed"]
end)
passEnabled_3f_1 = (function(pass1, options2)
	local override1 = options2["override"]
	local r_3381 = (options2["level"] >= (function(r_3401)
		return r_3401 or 1
	end)(pass1["level"]))
	if r_3381 then
		local r_3391
		if (pass1["on"] == false) then
			r_3391 = (override1[pass1["name"]] == true)
		else
			r_3391 = (override1[pass1["name"]] ~= false)
		end
		return r_3391 and all1((function(cat1)
			return (false ~= override1[cat1])
		end), pass1["cat"])
	else
		return r_3381
	end
end)
runPass1 = (function(pass2, options3, tracker2, ...)
	local args4 = _pack(...) args4.tag = "list"
	if passEnabled_3f_1(pass2, options3) then
		local ptracker1 = createTracker1()
		local name11 = _2e2e_2("[", concat1(pass2["cat"], " "), "] ", pass2["name"])
		startTimer_21_1(options3["timer"], name11, 2)
		pass2["run"](ptracker1, options3, unpack1(args4, 1, _23_1(args4)))
		stopTimer_21_1(options3["timer"], name11)
		if changed_3f_1(ptracker1) then
			if options3["track"] then
				putVerbose_21_1(options3["logger"], _2e2e_2(name11, " did something."))
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
traverseQuote1 = (function(node10, visitor1, level3)
	if (level3 == 0) then
		return traverseNode1(node10, visitor1)
	else
		local tag5 = node10["tag"]
		local temp27
		local r_3561 = (tag5 == "string")
		if r_3561 then
			temp27 = r_3561
		else
			local r_3571 = (tag5 == "number")
			if r_3571 then
				temp27 = r_3571
			else
				local r_3581 = (tag5 == "key")
				temp27 = r_3581 or (tag5 == "symbol")
			end
		end
		if temp27 then
			return node10
		elseif (tag5 == "list") then
			local first2 = nth1(node10, 1)
			if first2 and (first2["tag"] == "symbol") then
				local temp28
				local r_3601 = (first2["contents"] == "unquote")
				temp28 = r_3601 or (first2["contents"] == "unquote-splice")
				if temp28 then
					node10[2] = traverseQuote1(nth1(node10, 2), visitor1, pred1(level3))
					return node10
				elseif (first2["contents"] == "syntax-quote") then
					node10[2] = traverseQuote1(nth1(node10, 2), visitor1, succ1(level3))
					return node10
				else
					local r_3631 = _23_1(node10)
					local r_3611 = nil
					r_3611 = (function(r_3621)
						if (r_3621 <= r_3631) then
							node10[r_3621] = traverseQuote1(nth1(node10, r_3621), visitor1, level3)
							return r_3611((r_3621 + 1))
						else
						end
					end)
					r_3611(1)
					return node10
				end
			else
				local r_3671 = _23_1(node10)
				local r_3651 = nil
				r_3651 = (function(r_3661)
					if (r_3661 <= r_3671) then
						node10[r_3661] = traverseQuote1(nth1(node10, r_3661), visitor1, level3)
						return r_3651((r_3661 + 1))
					else
					end
				end)
				r_3651(1)
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
	local temp29
	local r_3451 = (tag6 == "string")
	if r_3451 then
		temp29 = r_3451
	else
		local r_3461 = (tag6 == "number")
		if r_3461 then
			temp29 = r_3461
		else
			local r_3471 = (tag6 == "key")
			temp29 = r_3471 or (tag6 == "symbol")
		end
	end
	if temp29 then
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
				local r_3711 = _23_1(node11)
				local r_3691 = nil
				r_3691 = (function(r_3701)
					if (r_3701 <= r_3711) then
						local case1 = nth1(node11, r_3701)
						case1[1] = traverseNode1(nth1(case1, 1), visitor2)
						traverseBlock1(case1, 2, visitor2)
						return r_3691((r_3701 + 1))
					else
					end
				end)
				r_3691(2)
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
				local temp30
				local r_3731 = (func1 == builtins2["unquote"])
				temp30 = r_3731 or (func1 == builtins2["unquote-splice"])
				if temp30 then
					return fail_21_1("unquote/unquote-splice should never appear head")
				else
					local temp31
					local r_3741 = (func1 == builtins2["define"])
					temp31 = r_3741 or (func1 == builtins2["define-macro"])
					if temp31 then
						node11[_23_1(node11)] = traverseNode1(nth1(node11, _23_1(node11)), visitor2)
						return visitor2(node11, visitor2)
					elseif (func1 == builtins2["define-native"]) then
						return visitor2(node11, visitor2)
					elseif (func1 == builtins2["import"]) then
						return visitor2(node11, visitor2)
					else
						local temp32
						local r_3751 = (funct1 == "defined")
						if r_3751 then
							temp32 = r_3751
						else
							local r_3761 = (funct1 == "arg")
							if r_3761 then
								temp32 = r_3761
							else
								local r_3771 = (funct1 == "native")
								temp32 = r_3771 or (funct1 == "macro")
							end
						end
						if temp32 then
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
traverseBlock1 = (function(node12, start2, visitor3)
	local r_3501 = _23_1(node12)
	local r_3481 = nil
	r_3481 = (function(r_3491)
		if (r_3491 <= r_3501) then
			node12[r_3491] = (traverseNode1(nth1(node12, (r_3491 + 0)), visitor3))
			return r_3481((r_3491 + 1))
		else
		end
	end)
	r_3481(start2)
	return node12
end)
traverseList1 = (function(node13, start3, visitor4)
	local r_3541 = _23_1(node13)
	local r_3521 = nil
	r_3521 = (function(r_3531)
		if (r_3531 <= r_3541) then
			node13[r_3531] = traverseNode1(nth1(node13, r_3531), visitor4)
			return r_3521((r_3531 + 1))
		else
		end
	end)
	r_3521(start3)
	return node13
end)
builtins3 = require1("tacky.analysis.resolve")["builtins"]
visitQuote1 = (function(node14, visitor5, level4)
	if (level4 == 0) then
		return visitNode1(node14, visitor5)
	else
		local tag7 = node14["tag"]
		local temp33
		local r_3971 = (tag7 == "string")
		if r_3971 then
			temp33 = r_3971
		else
			local r_3981 = (tag7 == "number")
			if r_3981 then
				temp33 = r_3981
			else
				local r_3991 = (tag7 == "key")
				temp33 = r_3991 or (tag7 == "symbol")
			end
		end
		if temp33 then
			return nil
		elseif (tag7 == "list") then
			local first4 = nth1(node14, 1)
			if first4 and (first4["tag"] == "symbol") then
				local temp34
				local r_4011 = (first4["contents"] == "unquote")
				temp34 = r_4011 or (first4["contents"] == "unquote-splice")
				if temp34 then
					return visitQuote1(nth1(node14, 2), visitor5, pred1(level4))
				elseif (first4["contents"] == "syntax-quote") then
					return visitQuote1(nth1(node14, 2), visitor5, succ1(level4))
				else
					local r_4061 = _23_1(node14)
					local r_4041 = nil
					r_4041 = (function(r_4051)
						if (r_4051 <= r_4061) then
							visitQuote1(node14[r_4051], visitor5, level4)
							return r_4041((r_4051 + 1))
						else
						end
					end)
					return r_4041(1)
				end
			else
				local r_4121 = _23_1(node14)
				local r_4101 = nil
				r_4101 = (function(r_4111)
					if (r_4111 <= r_4121) then
						visitQuote1(node14[r_4111], visitor5, level4)
						return r_4101((r_4111 + 1))
					else
					end
				end)
				return r_4101(1)
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
		local temp35
		local r_3901 = (tag8 == "string")
		if r_3901 then
			temp35 = r_3901
		else
			local r_3911 = (tag8 == "number")
			if r_3911 then
				temp35 = r_3911
			else
				local r_3921 = (tag8 == "key")
				temp35 = r_3921 or (tag8 == "symbol")
			end
		end
		if temp35 then
			return nil
		elseif (tag8 == "list") then
			local first5 = nth1(node15, 1)
			if (first5["tag"] == "symbol") then
				local func2 = first5["var"]
				local funct2 = func2["tag"]
				if (func2 == builtins3["lambda"]) then
					return visitBlock1(node15, 3, visitor6)
				elseif (func2 == builtins3["cond"]) then
					local r_4161 = _23_1(node15)
					local r_4141 = nil
					r_4141 = (function(r_4151)
						if (r_4151 <= r_4161) then
							local case2 = nth1(node15, r_4151)
							visitNode1(nth1(case2, 1), visitor6)
							visitBlock1(case2, 2, visitor6)
							return r_4141((r_4151 + 1))
						else
						end
					end)
					return r_4141(2)
				elseif (func2 == builtins3["set!"]) then
					return visitNode1(nth1(node15, 3), visitor6)
				elseif (func2 == builtins3["quote"]) then
				elseif (func2 == builtins3["syntax-quote"]) then
					return visitQuote1(nth1(node15, 2), visitor6, 1)
				else
					local temp36
					local r_4181 = (func2 == builtins3["unquote"])
					temp36 = r_4181 or (func2 == builtins3["unquote-splice"])
					if temp36 then
						return fail_21_1("unquote/unquote-splice should never appear head")
					else
						local temp37
						local r_4191 = (func2 == builtins3["define"])
						temp37 = r_4191 or (func2 == builtins3["define-macro"])
						if temp37 then
							return visitNode1(nth1(node15, _23_1(node15)), visitor6)
						elseif (func2 == builtins3["define-native"]) then
						elseif (func2 == builtins3["import"]) then
						else
							local temp38
							local r_4201 = (funct2 == "defined")
							if r_4201 then
								temp38 = r_4201
							else
								local r_4211 = (funct2 == "arg")
								if r_4211 then
									temp38 = r_4211
								else
									local r_4221 = (funct2 == "native")
									temp38 = r_4221 or (funct2 == "macro")
								end
							end
							if temp38 then
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
visitBlock1 = (function(node16, start4, visitor7)
	local r_3951 = _23_1(node16)
	local r_3931 = nil
	r_3931 = (function(r_3941)
		if (r_3941 <= r_3951) then
			visitNode1(nth1(node16, r_3941), visitor7)
			return r_3931((r_3941 + 1))
		else
		end
	end)
	return r_3931(start4)
end)
createState1 = (function()
	return {["vars"]=({}),["nodes"]=({})}
end)
getVar1 = (function(state1, var3)
	local entry1 = state1["vars"][var3]
	if entry1 then
	else
		entry1 = {["var"]=var3,["usages"]=({tag = "list", n = 0}),["defs"]=({tag = "list", n = 0}),["active"]=false}
		state1["vars"][var3] = entry1
	end
	return entry1
end)
addUsage_21_1 = (function(state2, var4, node17)
	local varMeta1 = getVar1(state2, var4)
	pushCdr_21_1(varMeta1["usages"], node17)
	varMeta1["active"] = true
	return nil
end)
addDefinition_21_1 = (function(state3, var5, node18, kind1, value7)
	local varMeta2 = getVar1(state3, var5)
	return pushCdr_21_1(varMeta2["defs"], {["tag"]=kind1,["node"]=node18,["value"]=value7})
end)
definitionsVisitor1 = (function(state4, node19, visitor8)
	local temp39
	local r_3821 = list_3f_1(node19)
	temp39 = r_3821 and symbol_3f_1(car2(node19))
	if temp39 then
		local func3 = car2(node19)["var"]
		if (func3 == builtins1["lambda"]) then
			local r_4241 = nth1(node19, 2)
			local r_4271 = _23_1(r_4241)
			local r_4251 = nil
			r_4251 = (function(r_4261)
				if (r_4261 <= r_4271) then
					local arg19 = r_4241[r_4261]
					addDefinition_21_1(state4, arg19["var"], arg19, "arg", arg19)
					return r_4251((r_4261 + 1))
				else
				end
			end)
			return r_4251(1)
		elseif (func3 == builtins1["set!"]) then
			return addDefinition_21_1(state4, node19[2]["var"], node19, "set", nth1(node19, 3))
		else
			local temp40
			local r_4291 = (func3 == builtins1["define"])
			temp40 = r_4291 or (func3 == builtins1["define-macro"])
			if temp40 then
				return addDefinition_21_1(state4, node19["defVar"], node19, "define", nth1(node19, _23_1(node19)))
			elseif (func3 == builtins1["define-native"]) then
				return addDefinition_21_1(state4, node19["defVar"], node19, "native")
			else
			end
		end
	else
		local temp41
		local r_4301 = list_3f_1(node19)
		if r_4301 then
			local r_4311 = list_3f_1(car2(node19))
			if r_4311 then
				local r_4321 = symbol_3f_1(caar1(node19))
				temp41 = r_4321 and (caar1(node19)["var"] == builtins1["lambda"])
			else
				temp41 = r_4311
			end
		else
			temp41 = r_4301
		end
		if temp41 then
			local lam1 = car2(node19)
			local args5 = nth1(lam1, 2)
			local offset1 = 1
			local r_4351 = _23_1(args5)
			local r_4331 = nil
			r_4331 = (function(r_4341)
				if (r_4341 <= r_4351) then
					local arg20 = nth1(args5, r_4341)
					local val9 = nth1(node19, (r_4341 + offset1))
					if arg20["var"]["isVariadic"] then
						local count1 = (_23_1(node19) - _23_1(args5))
						if (count1 < 0) then
							count1 = 0
						else
						end
						offset1 = count1
						addDefinition_21_1(state4, arg20["var"], arg20, "arg", arg20)
					else
						addDefinition_21_1(state4, arg20["var"], arg20, "let", val9 or struct1("tag", "symbol", "contents", "nil", "var", builtinVars1["nil"]))
					end
					return r_4331((r_4341 + 1))
				else
				end
			end)
			r_4331(1)
			visitBlock1(node19, 2, visitor8)
			visitBlock1(lam1, 3, visitor8)
			return false
		else
		end
	end
end)
definitionsVisit1 = (function(state5, nodes1)
	return visitBlock1(nodes1, 1, (function(r_4491, r_4501)
		return definitionsVisitor1(state5, r_4491, r_4501)
	end))
end)
usagesVisit1 = (function(state6, nodes2, pred2)
	if pred2 then
	else
		pred2 = (function()
			return true
		end)
	end
	local queue1 = ({tag = "list", n = 0})
	local visited1 = ({})
	local addUsage1 = (function(var6, user1)
		local varMeta3 = getVar1(state6, var6)
		if varMeta3["active"] then
		else
			local r_4431 = varMeta3["defs"]
			local r_4461 = _23_1(r_4431)
			local r_4441 = nil
			r_4441 = (function(r_4451)
				if (r_4451 <= r_4461) then
					local def1 = r_4431[r_4451]
					local val10 = def1["value"]
					if val10 and _21_1(visited1[val10]) then
						pushCdr_21_1(queue1, val10)
					else
					end
					return r_4441((r_4451 + 1))
				else
				end
			end)
			r_4441(1)
		end
		return addUsage_21_1(state6, var6, user1)
	end)
	local visit1 = (function(node20)
		if visited1[node20] then
			return false
		else
			visited1[node20] = true
			if symbol_3f_1(node20) then
				addUsage1(node20["var"], node20)
				return true
			else
				local temp42
				local r_4381 = list_3f_1(node20)
				if r_4381 then
					local r_4391 = (_23_1(node20) > 0)
					temp42 = r_4391 and symbol_3f_1(car2(node20))
				else
					temp42 = r_4381
				end
				if temp42 then
					local func4 = car2(node20)["var"]
					local temp43
					local r_4401 = (func4 == builtins1["set!"])
					if r_4401 then
						temp43 = r_4401
					else
						local r_4411 = (func4 == builtins1["define"])
						temp43 = r_4411 or (func4 == builtins1["define-macro"])
					end
					if temp43 then
						if pred2(nth1(node20, 3)) then
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
	local r_3871 = _23_1(nodes2)
	local r_3851 = nil
	r_3851 = (function(r_3861)
		if (r_3861 <= r_3871) then
			pushCdr_21_1(queue1, (nodes2[r_3861]))
			return r_3851((r_3861 + 1))
		else
		end
	end)
	r_3851(1)
	local r_3891 = nil
	r_3891 = (function()
		if (_23_1(queue1) > 0) then
			visitNode1(popLast_21_1(queue1), visit1)
			return r_3891()
		else
		end
	end)
	return r_3891()
end)
tagUsage1 = struct1("name", "tag-usage", "help", "Gathers usage and definition data for all expressions in NODES, storing it in LOOKUP.", "cat", ({tag = "list", n = 2, "tag", "usage"}), "run", (function(r_4511, state7, nodes3, lookup1)
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
	local temp44
	local r_4521 = node21["range"]
	temp44 = r_4521 and node21["contents"]
	if temp44 then
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
		local temp45
		local r_4531 = node21["start"]
		temp45 = r_4531 and node21["finish"]
		if temp45 then
			return formatRange1(node21)
		else
			return "?"
		end
	end
end)
getSource1 = (function(node22)
	local result4 = nil
	local r_4541 = nil
	r_4541 = (function()
		local temp46
		local r_4551 = node22
		temp46 = r_4551 and _21_1(result4)
		if temp46 then
			result4 = node22["range"]
			node22 = node22["parent"]
			return r_4541()
		else
		end
	end)
	r_4541()
	return result4
end)
struct1("formatPosition", formatPosition1, "formatRange", formatRange1, "formatNode", formatNode1, "getSource", getSource1)
stripImport1 = struct1("name", "strip-import", "help", "Strip all import expressions in NODES", "cat", ({tag = "list", n = 1, "opt"}), "run", (function(r_4512, state8, nodes4)
	local r_4561 = nil
	r_4561 = (function(r_4571)
		if (r_4571 >= 1) then
			local node23 = nth1(nodes4, r_4571)
			local temp47
			local r_4601 = list_3f_1(node23)
			if r_4601 then
				local r_4611 = (_23_1(node23) > 0)
				if r_4611 then
					local r_4621 = symbol_3f_1(car2(node23))
					temp47 = r_4621 and (car2(node23)["var"] == builtins1["import"])
				else
					temp47 = r_4611
				end
			else
				temp47 = r_4601
			end
			if temp47 then
				if (r_4571 == _23_1(nodes4)) then
					nodes4[r_4571] = makeNil1()
				else
					removeNth_21_1(nodes4, r_4571)
				end
				r_4512["changed"] = true
			else
			end
			return r_4561((r_4571 + -1))
		else
		end
	end)
	return r_4561(_23_1(nodes4))
end))
stripPure1 = struct1("name", "strip-pure", "help", "Strip all pure expressions in NODES (apart from the last one).", "cat", ({tag = "list", n = 1, "opt"}), "run", (function(r_4513, state9, nodes5)
	local r_4631 = nil
	r_4631 = (function(r_4641)
		if (r_4641 >= 1) then
			local node24 = nth1(nodes5, r_4641)
			if sideEffect_3f_1(node24) then
			else
				removeNth_21_1(nodes5, r_4641)
				r_4513["changed"] = true
			end
			return r_4631((r_4641 + -1))
		else
		end
	end)
	return r_4631(pred1(_23_1(nodes5)))
end))
constantFold1 = struct1("name", "constant-fold", "help", "A primitive constant folder\n\nThis simply finds function calls with constant functions and looks up the function.\nIf the function is native and pure then we'll execute it and replace the node with the\nresult. There are a couple of caveats:\n\n - If the function call errors then we will flag a warning and continue.\n - If this returns a decimal (or infinity or NaN) then we'll continue: we cannot correctly\n   accurately handle this.\n - If this doesn't return exactly one value then we will stop. This might be a future enhancement.", "cat", ({tag = "list", n = 1, "opt"}), "run", (function(r_4514, state10, nodes6)
	return traverseList1(nodes6, 1, (function(node25)
		local temp48
		local r_4671 = list_3f_1(node25)
		temp48 = r_4671 and fastAll1(constant_3f_1, node25, 2)
		if temp48 then
			local head1 = car2(node25)
			local meta1
			local r_4811 = symbol_3f_1(head1)
			if r_4811 then
				local r_4821 = _21_1(head1["folded"])
				if r_4821 then
					local r_4831 = (head1["var"]["tag"] == "native")
					meta1 = r_4831 and state10["meta"][head1["var"]["fullName"]]
				else
					meta1 = r_4821
				end
			else
				meta1 = r_4811
			end
			local temp49
			if meta1 then
				local r_4691 = meta1["pure"]
				temp49 = r_4691 and meta1["value"]
			else
				temp49 = meta1
			end
			if temp49 then
				local res3 = list1(pcall1(meta1["value"], unpack1(map1(urn_2d3e_val1, cdr2(node25)))))
				if car2(res3) then
					local val11 = nth1(res3, 2)
					local temp50
					local r_4701 = (_23_1(res3) ~= 2)
					if r_4701 then
						temp50 = r_4701
					else
						local r_4711 = number_3f_1(val11)
						if r_4711 then
							local r_4721 = (cadr1(list1(modf1(val11))) ~= 0)
							temp50 = r_4721 or (abs1(val11) == huge1)
						else
							temp50 = r_4711
						end
					end
					if temp50 then
						head1["folded"] = true
						return node25
					else
						r_4514["changed"] = true
						return val_2d3e_urn1(val11)
					end
				else
					head1["folded"] = true
					putNodeWarning_21_1(state10["logger"], _2e2e_2("Cannot execute constant expression"), node25, nil, getSource1(node25), _2e2e_2("Executed ", pretty1(node25), ", failed with: ", nth1(res3, 2)))
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
condFold1 = struct1("name", "cond-fold", "help", "Simplify all `cond` nodes, removing `false` branches and killing\nall branches after a `true` one.", "cat", ({tag = "list", n = 1, "opt"}), "run", (function(r_4515, state11, nodes7)
	return traverseList1(nodes7, 1, (function(node26)
		local temp51
		local r_4731 = list_3f_1(node26)
		if r_4731 then
			local r_4741 = symbol_3f_1(car2(node26))
			temp51 = r_4741 and (car2(node26)["var"] == builtins1["cond"])
		else
			temp51 = r_4731
		end
		if temp51 then
			local final1 = false
			local i3 = 2
			local r_4751 = nil
			r_4751 = (function()
				if (i3 <= _23_1(node26)) then
					local elem6 = nth1(node26, i3)
					if final1 then
						r_4515["changed"] = true
						removeNth_21_1(node26, i3)
					else
						local r_4841 = urn_2d3e_bool1(car2(elem6))
						if eq_3f_1(r_4841, false) then
							r_4515["changed"] = true
							removeNth_21_1(node26, i3)
						elseif eq_3f_1(r_4841, true) then
							final1 = true
							i3 = (i3 + 1)
						elseif eq_3f_1(r_4841, nil) then
							i3 = (i3 + 1)
						else
							error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_4841), ", but none matched.\n", "  Tried: `false`\n  Tried: `true`\n  Tried: `nil`"))
						end
					end
					return r_4751()
				else
				end
			end)
			r_4751()
			local temp52
			local r_4851 = (_23_1(node26) == 2)
			temp52 = r_4851 and (urn_2d3e_bool1(car2(nth1(node26, 2))) == true)
			if temp52 then
				r_4515["changed"] = true
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
lambdaFold1 = struct1("name", "lambda-fold", "help", "Simplify all directly called lambdas, inlining them were appropriate.", "cat", ({tag = "list", n = 1, "opt"}), "run", (function(r_4516, state12, nodes8)
	return traverseList1(nodes8, 1, (function(node27)
		local temp53
		local r_4761 = list_3f_1(node27)
		if r_4761 then
			local r_4771 = (_23_1(node27) == 1)
			if r_4771 then
				local r_4781 = list_3f_1(car2(node27))
				if r_4781 then
					local r_4791 = builtin_3f_1(caar1(node27), "lambda")
					if r_4791 then
						local r_4801 = (_23_1(car2(node27)) == 3)
						temp53 = r_4801 and nil_3f_1(nth1(car2(node27), 2))
					else
						temp53 = r_4791
					end
				else
					temp53 = r_4781
				end
			else
				temp53 = r_4771
			end
		else
			temp53 = r_4761
		end
		if temp53 then
			return nth1(car2(node27), 3)
		else
			return node27
		end
	end))
end))
getConstantVal1 = (function(lookup2, sym1)
	local var7 = sym1["var"]
	local def2 = getVar1(lookup2, sym1["var"])
	if (var7 == builtinVars1["true"]) then
		return sym1
	elseif (var7 == builtinVars1["false"]) then
		return sym1
	elseif (var7 == builtinVars1["nil"]) then
		return sym1
	elseif (_23_1(def2["defs"]) == 1) then
		local ent1 = car2(def2["defs"])
		local val12 = ent1["value"]
		local ty4 = ent1["tag"]
		local temp54
		local r_4861 = string_3f_1(val12)
		if r_4861 then
			temp54 = r_4861
		else
			local r_4871 = number_3f_1(val12)
			temp54 = r_4871 or key_3f_1(val12)
		end
		if temp54 then
			return val12
		else
			local temp55
			local r_4881 = symbol_3f_1(val12)
			if r_4881 then
				local r_4891 = (ty4 == "define")
				if r_4891 then
					temp55 = r_4891
				else
					local r_4901 = (ty4 == "set")
					temp55 = r_4901 or (ty4 == "let")
				end
			else
				temp55 = r_4881
			end
			if temp55 then
				local r_4911 = getConstantVal1(lookup2, val12)
				return r_4911 or sym1
			else
				return sym1
			end
		end
	else
		return nil
	end
end)
stripDefs1 = struct1("name", "strip-defs", "help", "Strip all unused top level definitions.", "cat", ({tag = "list", n = 2, "opt", "usage"}), "run", (function(r_4517, state13, nodes9, lookup3)
	local r_4921 = nil
	r_4921 = (function(r_4931)
		if (r_4931 >= 1) then
			local node28 = nth1(nodes9, r_4931)
			local temp56
			local r_4961 = node28["defVar"]
			temp56 = r_4961 and _21_1(getVar1(lookup3, node28["defVar"])["active"])
			if temp56 then
				if (r_4931 == _23_1(nodes9)) then
					nodes9[r_4931] = makeNil1()
				else
					removeNth_21_1(nodes9, r_4931)
				end
				r_4517["changed"] = true
			else
			end
			return r_4921((r_4931 + -1))
		else
		end
	end)
	return r_4921(_23_1(nodes9))
end))
stripArgs1 = struct1("name", "strip-args", "help", "Strip all unused, pure arguments in directly called lambdas.", "cat", ({tag = "list", n = 2, "opt", "usage"}), "run", (function(r_4518, state14, nodes10, lookup4)
	return visitBlock1(nodes10, 1, (function(node29)
		local temp57
		local r_4971 = list_3f_1(node29)
		if r_4971 then
			local r_4981 = list_3f_1(car2(node29))
			if r_4981 then
				local r_4991 = symbol_3f_1(caar1(node29))
				temp57 = r_4991 and (caar1(node29)["var"] == builtins1["lambda"])
			else
				temp57 = r_4981
			end
		else
			temp57 = r_4971
		end
		if temp57 then
			local lam2 = car2(node29)
			local args6 = nth1(lam2, 2)
			local offset2 = 1
			local remOffset1 = 0
			local removed1 = ({})
			local r_5021 = _23_1(args6)
			local r_5001 = nil
			r_5001 = (function(r_5011)
				if (r_5011 <= r_5021) then
					local arg21 = nth1(args6, (r_5011 - remOffset1))
					local val13 = nth1(node29, ((r_5011 + offset2) - remOffset1))
					if arg21["var"]["isVariadic"] then
						local count2 = (_23_1(node29) - _23_1(args6))
						if (count2 < 0) then
							count2 = 0
						else
						end
						offset2 = count2
					elseif (nil == val13) then
					elseif sideEffect_3f_1(val13) then
					elseif (_23_1(getVar1(lookup4, arg21["var"])["usages"]) > 0) then
					else
						r_4518["changed"] = true
						removed1[nth1(args6, (r_5011 - remOffset1))["var"]] = true
						removeNth_21_1(args6, (r_5011 - remOffset1))
						removeNth_21_1(node29, ((r_5011 + offset2) - remOffset1))
						remOffset1 = (remOffset1 + 1)
					end
					return r_5001((r_5011 + 1))
				else
				end
			end)
			r_5001(1)
			if (remOffset1 > 0) then
				return traverseList1(lam2, 3, (function(node30)
					local temp58
					local r_5041 = list_3f_1(node30)
					if r_5041 then
						local r_5051 = builtin_3f_1(car2(node30), "set!")
						temp58 = r_5051 and removed1[nth1(node30, 2)["var"]]
					else
						temp58 = r_5041
					end
					if temp58 then
						local val14 = nth1(node30, 3)
						if sideEffect_3f_1(val14) then
							return makeProgn1(list1(val14, makeNil1()))
						else
							return makeNil1()
						end
					else
						return node30
					end
				end))
			else
			end
		else
		end
	end))
end))
variableFold1 = struct1("name", "variable-fold", "help", "Folds constant variable accesses", "cat", ({tag = "list", n = 2, "opt", "usage"}), "run", (function(r_4519, state15, nodes11, lookup5)
	return traverseList1(nodes11, 1, (function(node31)
		if symbol_3f_1(node31) then
			local var8 = getConstantVal1(lookup5, node31)
			if var8 and (var8 ~= node31) then
				r_4519["changed"] = true
				return var8
			else
				return node31
			end
		else
			return node31
		end
	end))
end))
expressionFold1 = struct1("name", "expression-fold", "help", "Folds basic variable accesses where execution order will not change.\n\nFor instance, converts ((lambda (x) (+ x 1)) (Y)) to (+ Y 1) in the case\nwhere Y is an arbitrary expression.\n\nThere are a couple of complexities in the implementation here. Firstly, we\nwant to ensure that the arguments are executed in the correct order and only\nonce.\n\nIn order to achieve this, we find the lambda forms and visit the body, stopping\nif we visit arguments in the wrong order or non-constant terms such as mutable\nvariables or other function calls. For simplicities sake, we fail if we hit\nother lambdas or conds as that makes analysing control flow significantly more\ncomplex.\n\nAnother source of added complexity is the case where where Y could return multiple\nvalues: namely in the last argument to function calls. Here it is an invalid optimisation\nto just place Y, as that could result in additional values being passed to the function.\n\nIn order to avoid this, Y will get converted to the form ((lambda (<tmp>) <tmp>) Y).\nThis is understood by the codegen and so is not as inefficient as it looks. However, we do\nhave to take additional steps to avoid trying to fold the above again and again.", "cat", ({tag = "list", n = 2, "opt", "usage"}), "run", (function(r_45110, state16, nodes12, lookup6)
	return visitBlock1(nodes12, 1, (function(root1)
		local temp59
		local r_5071 = list_3f_1(root1)
		if r_5071 then
			local r_5081 = list_3f_1(car2(root1))
			if r_5081 then
				local r_5091 = symbol_3f_1(caar1(root1))
				temp59 = r_5091 and (caar1(root1)["var"] == builtins1["lambda"])
			else
				temp59 = r_5081
			end
		else
			temp59 = r_5071
		end
		if temp59 then
			local lam3
			local args7
			local len6
			local validate1
			lam3 = car2(root1)
			args7 = nth1(lam3, 2)
			len6 = _23_1(args7)
			validate1 = (function(i4)
				if (i4 > len6) then
					return true
				else
					local arg22 = nth1(args7, i4)
					local var9 = arg22["var"]
					local entry2 = getVar1(lookup6, var9)
					if var9["isVariadic"] then
						return false
					elseif (_23_1(entry2["defs"]) ~= 1) then
						return false
					elseif (_23_1(entry2["usages"]) ~= 1) then
						return false
					else
						return validate1(succ1(i4))
					end
				end
			end)
			local temp60
			local r_5101 = (len6 > 0)
			if r_5101 then
				local r_5111
				local r_5121 = (_23_1(root1) ~= 2)
				if r_5121 then
					r_5111 = r_5121
				else
					local r_5131 = (len6 ~= 1)
					if r_5131 then
						r_5111 = r_5131
					else
						local r_5141 = (_23_1(lam3) ~= 3)
						if r_5141 then
							r_5111 = r_5141
						else
							local r_5151 = atom_3f_1(nth1(root1, 2))
							if r_5151 then
								r_5111 = r_5151
							else
								local r_5161 = _21_1(symbol_3f_1(nth1(lam3, 3)))
								r_5111 = r_5161 or (nth1(lam3, 3)["var"] ~= car2(args7)["var"])
							end
						end
					end
				end
				temp60 = r_5111 and validate1(1)
			else
				temp60 = r_5101
			end
			if temp60 then
				local currentIdx1 = 1
				local argMap1 = ({})
				local wrapMap1 = ({})
				local ok1 = true
				local finished1 = false
				local r_5191 = _23_1(args7)
				local r_5171 = nil
				r_5171 = (function(r_5181)
					if (r_5181 <= r_5191) then
						argMap1[nth1(args7, r_5181)["var"]] = r_5181
						return r_5171((r_5181 + 1))
					else
					end
				end)
				r_5171(1)
				visitBlock1(lam3, 3, (function(node32, visitor9)
					if ok1 then
						local r_5211 = type1(node32)
						if (r_5211 == "string") then
						elseif (r_5211 == "number") then
						elseif (r_5211 == "key") then
						elseif (r_5211 == "symbol") then
							local idx4 = argMap1[node32["var"]]
							if (idx4 == nil) then
								if (_23_1(getVar1(lookup6, node32["var"])["defs"]) > 1) then
									ok1 = false
									return false
								else
								end
							elseif (idx4 == currentIdx1) then
								currentIdx1 = (currentIdx1 + 1)
								if (currentIdx1 > len6) then
									finished1 = true
									return nil
								else
								end
							else
								ok1 = false
								return false
							end
						elseif (r_5211 == "list") then
							local head2 = car2(node32)
							if symbol_3f_1(head2) then
								local var10 = node32["var"]
								visitBlock1(node32, 1, visitor9)
								if (_23_1(node32) > 1) then
									local last2 = nth1(node32, _23_1(node32))
									if symbol_3f_1(last2) then
										local idx5 = argMap1[last2["var"]]
										if idx5 then
											local val15 = root1[(idx5 + 1)]
											if list_3f_1(val15) then
												wrapMap1[idx5] = true
											else
											end
										else
										end
									else
									end
								else
								end
								if finished1 then
								elseif (var10 == builtins1["set!"]) then
									ok1 = false
								elseif (var10 == builtins1["cond"]) then
									ok1 = false
								elseif (var10 == builtins1["lambda"]) then
									ok1 = false
								else
									ok1 = false
								end
								return false
							else
								ok1 = false
								return false
							end
						else
							return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_5211), ", but none matched.\n", "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"key\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`"))
						end
					else
						return false
					end
				end))
				local temp61
				local r_5221 = ok1
				temp61 = r_5221 and finished1
				if temp61 then
					r_45110["changed"] = true
					traverseList1(root1, 1, (function(child1)
						if symbol_3f_1(child1) then
							local var11 = child1["var"]
							local i5 = argMap1[var11]
							if i5 then
								if wrapMap1[i5] then
									return ({tag = "list", n = 2, ({tag = "list", n = 3, makeSymbol1(builtins1["lambda"]), ({tag = "list", n = 1, makeSymbol1(var11)}), makeSymbol1(var11)}), nth1(root1, (i5 + 1))})
								else
									local r_5231 = nth1(root1, (i5 + 1))
									return r_5231 or makeNil1()
								end
							else
								return child1
							end
						else
							return child1
						end
					end))
					local r_5241 = nil
					r_5241 = (function(r_5251)
						if (r_5251 >= 2) then
							removeNth_21_1(root1, r_5251)
							return r_5241((r_5251 + -1))
						else
						end
					end)
					r_5241(_23_1(root1))
					local r_5281 = nil
					r_5281 = (function(r_5291)
						if (r_5291 >= 1) then
							removeNth_21_1(args7, r_5291)
							return r_5281((r_5291 + -1))
						else
						end
					end)
					return r_5281(_23_1(args7))
				else
				end
			else
			end
		else
		end
	end))
end))
scope_2f_child1 = require1("tacky.analysis.scope")["child"]
scope_2f_add_21_1 = require1("tacky.analysis.scope")["add"]
copyOf1 = (function(x28)
	local res4 = ({})
	iterPairs1(x28, (function(k2, v3)
		res4[k2] = v3
		return nil
	end))
	return res4
end)
getScope1 = (function(scope1, lookup7, n2)
	local newScope1 = lookup7["scopes"][scope1]
	if newScope1 then
		return newScope1
	else
		local newScope2 = scope_2f_child1()
		lookup7["scopes"][scope1] = newScope2
		return newScope2
	end
end)
getVar2 = (function(var12, lookup8)
	local r_5321 = lookup8["vars"][var12]
	return r_5321 or var12
end)
copyNode1 = (function(node33, lookup9)
	local r_5331 = type1(node33)
	if (r_5331 == "string") then
		return copyOf1(node33)
	elseif (r_5331 == "key") then
		return copyOf1(node33)
	elseif (r_5331 == "number") then
		return copyOf1(node33)
	elseif (r_5331 == "symbol") then
		local copy1 = copyOf1(node33)
		local oldVar1 = node33["var"]
		local newVar1 = getVar2(oldVar1, lookup9)
		local temp62
		local r_5341 = (oldVar1 ~= newVar1)
		temp62 = r_5341 and (oldVar1["node"] == node33)
		if temp62 then
			newVar1["node"] = copy1
		else
		end
		copy1["var"] = newVar1
		return copy1
	elseif (r_5331 == "list") then
		if builtin_3f_1(car2(node33), "lambda") then
			local args8 = cadr1(node33)
			if nil_3f_1(args8) then
			else
				local newScope3 = scope_2f_child1(getScope1(car2(args8)["var"]["scope"], lookup9, node33))
				local r_5471 = _23_1(args8)
				local r_5451 = nil
				r_5451 = (function(r_5461)
					if (r_5461 <= r_5471) then
						local arg23 = args8[r_5461]
						local var13 = arg23["var"]
						local newVar2 = scope_2f_add_21_1(newScope3, var13["name"], var13["tag"], nil)
						newVar2["isVariadic"] = var13["isVariadic"]
						lookup9["vars"][var13] = newVar2
						return r_5451((r_5461 + 1))
					else
					end
				end)
				r_5451(1)
			end
		else
		end
		local res5 = copyOf1(node33)
		local r_5511 = _23_1(res5)
		local r_5491 = nil
		r_5491 = (function(r_5501)
			if (r_5501 <= r_5511) then
				res5[r_5501] = copyNode1(nth1(res5, r_5501), lookup9)
				return r_5491((r_5501 + 1))
			else
			end
		end)
		r_5491(1)
		return res5
	else
		return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_5331), ", but none matched.\n", "  Tried: `\"string\"`\n  Tried: `\"key\"`\n  Tried: `\"number\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`"))
	end
end)
scoreNode1 = (function(node34)
	local r_5351 = type1(node34)
	if (r_5351 == "string") then
		return 0
	elseif (r_5351 == "key") then
		return 0
	elseif (r_5351 == "number") then
		return 0
	elseif (r_5351 == "symbol") then
		return 1
	elseif (r_5351 == "list") then
		local r_5361 = type1(car2(node34))
		if (r_5361 == "symbol") then
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
		return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_5351), ", but none matched.\n", "  Tried: `\"string\"`\n  Tried: `\"key\"`\n  Tried: `\"number\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`"))
	end
end)
getScore1 = (function(lookup10, node35)
	local score1 = lookup10[node35]
	if (score1 == nil) then
		score1 = 0
		local r_5381 = nth1(node35, 2)
		local r_5411 = _23_1(r_5381)
		local r_5391 = nil
		r_5391 = (function(r_5401)
			if (r_5401 <= r_5411) then
				local arg24 = r_5381[r_5401]
				if arg24["var"]["isVariadic"] then
					score1 = false
				else
				end
				return r_5391((r_5401 + 1))
			else
			end
		end)
		r_5391(1)
		if score1 then
			score1 = scoreNodes1(node35, 3, score1)
		else
		end
		lookup10[node35] = score1
	else
	end
	return score1 or huge1
end)
scoreNodes1 = (function(nodes13, start5, sum1)
	if (start5 > _23_1(nodes13)) then
		return sum1
	else
		local score2 = scoreNode1(nth1(nodes13, start5))
		if score2 then
			if (score2 > 20) then
				return score2
			else
				return scoreNodes1(nodes13, succ1(start5), (sum1 + score2))
			end
		else
			return false
		end
	end
end)
inline1 = struct1("name", "inline", "help", "Inline simple functions.", "cat", ({tag = "list", n = 2, "opt", "usage"}), "on", false, "run", (function(r_45111, state17, nodes14, usage2)
	local scoreLookup1 = ({})
	return visitBlock1(nodes14, 1, (function(node36)
		local temp63
		local r_5531 = list_3f_1(node36)
		temp63 = r_5531 and symbol_3f_1(car2(node36))
		if temp63 then
			local func6 = car2(node36)["var"]
			local def3 = getVar1(usage2, func6)
			if (_23_1(def3["defs"]) == 1) then
				local ent2 = car2(def3["defs"])
				local val16 = ent2["value"]
				local temp64
				local r_5541 = list_3f_1(val16)
				if r_5541 then
					local r_5551 = builtin_3f_1(car2(val16), "lambda")
					temp64 = r_5551 and (getScore1(scoreLookup1, val16) <= 20)
				else
					temp64 = r_5541
				end
				if temp64 then
					local copy2 = copyNode1(val16, struct1("scopes", ({}), "vars", ({}), "root", func6["scope"]))
					node36[1] = copy2
					r_45111["changed"] = true
					return nil
				else
				end
			else
			end
		else
		end
	end))
end))
optimiseOnce1 = (function(nodes15, state18)
	local tracker3 = createTracker1()
	runPass1(stripImport1, state18, tracker3, nodes15)
	runPass1(stripPure1, state18, tracker3, nodes15)
	runPass1(constantFold1, state18, tracker3, nodes15)
	runPass1(condFold1, state18, tracker3, nodes15)
	runPass1(lambdaFold1, state18, tracker3, nodes15)
	local lookup11 = createState1()
	runPass1(tagUsage1, state18, tracker3, nodes15, lookup11)
	runPass1(stripDefs1, state18, tracker3, nodes15, lookup11)
	runPass1(stripArgs1, state18, tracker3, nodes15, lookup11)
	runPass1(variableFold1, state18, tracker3, nodes15, lookup11)
	runPass1(expressionFold1, state18, tracker3, nodes15, lookup11)
	runPass1(inline1, state18, tracker3, nodes15, lookup11)
	return changed_3f_1(tracker3)
end)
optimise1 = (function(nodes16, state19)
	local maxN1 = state19["max-n"]
	local maxT1 = state19["max-time"]
	local iteration1 = 0
	local finish1 = (clock1() + maxT1)
	local changed1 = true
	local r_3151 = nil
	r_3151 = (function()
		local temp65
		local r_3161 = changed1
		if r_3161 then
			local r_3171
			local r_5561 = (maxN1 < 0)
			r_3171 = r_5561 or (iteration1 < maxN1)
			if r_3171 then
				local r_3181 = (maxT1 < 0)
				temp65 = r_3181 or (clock1() < finish1)
			else
				temp65 = r_3171
			end
		else
			temp65 = r_3161
		end
		if temp65 then
			changed1 = optimiseOnce1(nodes16, state19)
			iteration1 = (iteration1 + 1)
			return r_3151()
		else
		end
	end)
	r_3151()
	return nodes16
end)
checkArity1 = struct1("name", "check-arity", "help", "Produce a warning if any NODE in NODES calls a function with too many arguments.\n\nLOOKUP is the variable usage lookup table.", "cat", ({tag = "list", n = 2, "warn", "usage"}), "run", (function(r_45112, state20, nodes17, lookup12)
	local arity1
	local getArity1
	arity1 = ({})
	getArity1 = (function(symbol1)
		local var14 = getVar1(lookup12, symbol1["var"])
		local ari1 = arity1[var14]
		if (ari1 ~= nil) then
			return ari1
		elseif (_23_1(var14["defs"]) ~= 1) then
			return false
		else
			arity1[var14] = false
			local defData1 = car2(var14["defs"])
			local def4 = defData1["value"]
			if (defData1["tag"] == "arg") then
				ari1 = false
			else
				if symbol_3f_1(def4) then
					ari1 = getArity1(def4)
				else
					local temp66
					local r_5571 = list_3f_1(def4)
					if r_5571 then
						local r_5581 = symbol_3f_1(car2(def4))
						temp66 = r_5581 and (car2(def4)["var"] == builtins1["lambda"])
					else
						temp66 = r_5571
					end
					if temp66 then
						local args9 = nth1(def4, 2)
						if any1((function(x29)
							return x29["var"]["isVariadic"]
						end), args9) then
							ari1 = false
						else
							ari1 = _23_1(args9)
						end
					else
						ari1 = false
					end
				end
			end
			arity1[var14] = ari1
			return ari1
		end
	end)
	return visitBlock1(nodes17, 1, (function(node37)
		local temp67
		local r_5591 = list_3f_1(node37)
		temp67 = r_5591 and symbol_3f_1(car2(node37))
		if temp67 then
			local arity2 = getArity1(car2(node37))
			if arity2 and (arity2 < pred1(_23_1(node37))) then
				return putNodeWarning_21_1(state20["logger"], _2e2e_2("Calling ", symbol_2d3e_string1(car2(node37)), " with ", tonumber1(pred1(_23_1(node37))), " arguments, expected ", tonumber1(arity2)), node37, nil, getSource1(node37), "Called here")
			else
			end
		else
		end
	end))
end))
analyse1 = (function(nodes18, state21)
	local lookup13 = createState1()
	runPass1(tagUsage1, state21, nil, nodes18, lookup13)
	runPass1(checkArity1, state21, nil, nodes18, lookup13)
	return nodes18
end)
create3 = (function()
	return struct1("out", ({tag = "list", n = 0}), "indent", 0, "tabs-pending", false, "line", 1, "lines", ({}), "node-stack", ({tag = "list", n = 0}), "active-pos", nil)
end)
append_21_1 = (function(writer1, text2)
	local r_5721 = type1(text2)
	if (r_5721 ~= "string") then
		error1(format1("bad argment %s (expected %s, got %s)", "text", "string", r_5721), 2)
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
	if force1 or _21_1(writer2["tabs-pending"]) then
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
	local temp68
	local r_5611 = (tag9 == "string")
	if r_5611 then
		temp68 = r_5611
	else
		local r_5621 = (tag9 == "number")
		if r_5621 then
			temp68 = r_5621
		else
			local r_5631 = (tag9 == "symbol")
			temp68 = r_5631 or (tag9 == "key")
		end
	end
	if temp68 then
		return len1(tostring1(node40["contents"]))
	elseif (tag9 == "list") then
		local sum2 = 2
		local i6 = 1
		local r_5641 = nil
		r_5641 = (function()
			local temp69
			local r_5651 = (sum2 <= max4)
			temp69 = r_5651 and (i6 <= _23_1(node40))
			if temp69 then
				sum2 = (sum2 + estimateLength1(nth1(node40, i6), (max4 - sum2)))
				if (i6 > 1) then
					sum2 = (sum2 + 1)
				else
				end
				i6 = (i6 + 1)
				return r_5641()
			else
			end
		end)
		r_5641()
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
			local r_5761 = _23_1(node41)
			local r_5741 = nil
			r_5741 = (function(r_5751)
				if (r_5751 <= r_5761) then
					local entry3 = nth1(node41, r_5751)
					local temp70
					local r_5781 = _21_1(newline1)
					temp70 = r_5781 and (max5 > 0)
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
					return r_5741((r_5751 + 1))
				else
				end
			end)
			r_5741(2)
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
block1 = (function(list4, writer12)
	local r_5701 = _23_1(list4)
	local r_5681 = nil
	r_5681 = (function(r_5691)
		if (r_5691 <= r_5701) then
			expression1(list4[r_5691], writer12)
			line_21_1(writer12)
			return r_5681((r_5691 + 1))
		else
		end
	end)
	return r_5681(1)
end)
cat2 = (function(category1, ...)
	local args10 = _pack(...) args10.tag = "list"
	return struct1("category", category1, unpack1(args10, 1, _23_1(args10)))
end)
partAll1 = (function(xs18, i7, e1, f5)
	if (i7 > e1) then
		return true
	elseif f5(nth1(xs18, i7)) then
		return partAll1(xs18, (i7 + 1), e1, f5)
	else
		return false
	end
end)
visitNode2 = (function(lookup14, node42, stmt1)
	local cat3
	local r_5881 = type1(node42)
	if (r_5881 == "string") then
		cat3 = cat2("const")
	elseif (r_5881 == "number") then
		cat3 = cat2("const")
	elseif (r_5881 == "key") then
		cat3 = cat2("const")
	elseif (r_5881 == "symbol") then
		cat3 = cat2("const")
	elseif (r_5881 == "list") then
		local head3 = car2(node42)
		local r_5891 = type1(head3)
		if (r_5891 == "symbol") then
			local func7 = head3["var"]
			local funct3 = func7["tag"]
			if (func7 == builtins1["lambda"]) then
				visitNodes1(lookup14, node42, 3, true)
				cat3 = cat2("lambda")
			elseif (func7 == builtins1["cond"]) then
				local r_6031 = _23_1(node42)
				local r_6011 = nil
				r_6011 = (function(r_6021)
					if (r_6021 <= r_6031) then
						local case3 = nth1(node42, r_6021)
						visitNode2(lookup14, car2(case3), true)
						visitNodes1(lookup14, case3, 2, true)
						return r_6011((r_6021 + 1))
					else
					end
				end)
				r_6011(2)
				local temp71
				local r_6051 = (_23_1(node42) == 3)
				if r_6051 then
					local r_6061
					local sub2 = nth1(node42, 2)
					local r_6091 = (_23_1(sub2) == 2)
					r_6061 = r_6091 and builtinVar_3f_1(nth1(sub2, 2), "false")
					if r_6061 then
						local sub3 = nth1(node42, 3)
						local r_6071 = (_23_1(sub3) == 2)
						if r_6071 then
							local r_6081 = builtinVar_3f_1(nth1(sub3, 1), "true")
							temp71 = r_6081 and builtinVar_3f_1(nth1(sub3, 2), "true")
						else
							temp71 = r_6071
						end
					else
						temp71 = r_6061
					end
				else
					temp71 = r_6051
				end
				if temp71 then
					cat3 = cat2("not", "stmt", lookup14[car2(nth1(node42, 2))]["stmt"])
				else
					local temp72
					local r_6101 = (_23_1(node42) == 3)
					if r_6101 then
						local first6 = nth1(node42, 2)
						local second1 = nth1(node42, 3)
						local r_6111 = (_23_1(first6) == 2)
						if r_6111 then
							local r_6121 = (_23_1(second1) == 2)
							if r_6121 then
								local r_6131 = symbol_3f_1(car2(first6))
								if r_6131 then
									local r_6141 = _21_1(lookup14[nth1(first6, 2)]["stmt"])
									if r_6141 then
										local r_6151 = builtinVar_3f_1(car2(second1), "true")
										temp72 = r_6151 and eq_3f_1(car2(first6), nth1(second1, 2))
									else
										temp72 = r_6141
									end
								else
									temp72 = r_6131
								end
							else
								temp72 = r_6121
							end
						else
							temp72 = r_6111
						end
					else
						temp72 = r_6101
					end
					if temp72 then
						cat3 = cat2("and")
					else
						local temp73
						local r_6161 = (_23_1(node42) >= 3)
						if r_6161 then
							local r_6171 = partAll1(node42, 2, pred1(_23_1(node42)), (function(branch1)
								local r_6201 = (_23_1(branch1) == 2)
								if r_6201 then
									local r_6211 = symbol_3f_1(car2(branch1))
									return r_6211 and eq_3f_1(car2(branch1), nth1(branch1, 2))
								else
									return r_6201
								end
							end))
							if r_6171 then
								local branch2 = last1(node42)
								local r_6181 = (_23_1(branch2) == 2)
								if r_6181 then
									local r_6191 = builtinVar_3f_1(car2(branch2), "true")
									temp73 = r_6191 and _21_1(lookup14[nth1(branch2, 2)]["stmt"])
								else
									temp73 = r_6181
								end
							else
								temp73 = r_6171
							end
						else
							temp73 = r_6161
						end
						if temp73 then
							cat3 = cat2("or")
						else
							cat3 = cat2("cond", "stmt", true)
						end
					end
				end
			elseif (func7 == builtins1["set!"]) then
				visitNode2(lookup14, nth1(node42, 3), true)
				cat3 = cat2("set!")
			elseif (func7 == builtins1["quote"]) then
				cat3 = cat2("quote")
			elseif (func7 == builtins1["syntax-quote"]) then
				visitQuote2(lookup14, nth1(node42, 2), 1)
				cat3 = cat2("syntax-quote")
			elseif (func7 == builtins1["unquote"]) then
				cat3 = fail_21_1("unquote should never appear")
			elseif (func7 == builtins1["unquote-splice"]) then
				cat3 = fail_21_1("unquote should never appear")
			elseif (func7 == builtins1["define"]) then
				visitNode2(lookup14, nth1(node42, _23_1(node42)), true)
				cat3 = cat2("define")
			elseif (func7 == builtins1["define-macro"]) then
				visitNode2(lookup14, nth1(node42, _23_1(node42)), true)
				cat3 = cat2("define")
			elseif (func7 == builtins1["define-native"]) then
				cat3 = cat2("define-native")
			elseif (func7 == builtins1["import"]) then
				cat3 = cat2("import")
			elseif (func7 == builtinVars1["true"]) then
				visitNodes1(lookup14, node42, 1, false)
				cat3 = cat2("call-literal")
			elseif (func7 == builtinVars1["false"]) then
				visitNodes1(lookup14, node42, 1, false)
				cat3 = cat2("call-literal")
			elseif (func7 == builtinVars1["nil"]) then
				visitNodes1(lookup14, node42, 1, false)
				cat3 = cat2("call-literal")
			else
				visitNodes1(lookup14, node42, 1, false)
				cat3 = cat2("call-symbol")
			end
		elseif (r_5891 == "list") then
			local temp74
			local r_6221 = (_23_1(node42) == 2)
			if r_6221 then
				local r_6231 = builtin_3f_1(car2(head3), "lambda")
				if r_6231 then
					local r_6241 = (_23_1(nth1(head3, 2)) == 1)
					if r_6241 then
						local r_6251
						local val17 = nth1(node42, 2)
						local r_6311 = list_3f_1(arg1)
						if r_6311 then
							local r_6321 = (_23_1(val17) == 1)
							r_6251 = r_6321 and eq_3f_1(car2(val17), ({ tag="symbol", contents="empty-struct"}))
						else
							r_6251 = r_6311
						end
						if r_6251 then
							local arg25 = car2(nth1(head3, 2))
							local r_6261 = _21_1(arg25["isVariadic"])
							if r_6261 then
								local r_6271 = eq_3f_1(arg25, last1(head3))
								temp74 = r_6271 and partAll1(head3, 3, pred1(_23_1(head3)), (function(node43)
									local r_6281 = list_3f_1(node43)
									if r_6281 then
										local r_6291 = (_23_1(node43) == 4)
										if r_6291 then
											local r_6301 = eq_3f_1(car2(node43), ({ tag="symbol", contents="set-idx!"}))
											return r_6301 and eq_3f_1(nth1(node43, 2), arg25)
										else
											return r_6291
										end
									else
										return r_6281
									end
								end))
							else
								temp74 = r_6261
							end
						else
							temp74 = r_6251
						end
					else
						temp74 = r_6241
					end
				else
					temp74 = r_6231
				end
			else
				temp74 = r_6221
			end
			if temp74 then
				visitNodes1(lookup14, car2(node42), 3, false)
				cat3 = cat2("make-struct")
			else
				local temp75
				local r_6331 = (_23_1(node42) == 2)
				if r_6331 then
					local r_6341 = builtin_3f_1(car2(head3), "lambda")
					if r_6341 then
						local r_6351 = (_23_1(head3) == 3)
						if r_6351 then
							local r_6361 = (_23_1(nth1(head3, 2)) == 1)
							if r_6361 then
								local r_6371 = symbol_3f_1(nth1(head3, 3))
								temp75 = r_6371 and (nth1(head3, 3)["var"] == car2(nth1(head3, 2))["var"])
							else
								temp75 = r_6361
							end
						else
							temp75 = r_6351
						end
					else
						temp75 = r_6341
					end
				else
					temp75 = r_6331
				end
				if temp75 then
					local childCat1 = visitNode2(lookup14, nth1(node42, 2), stmt1)
					if childCat1["stmt"] then
						visitNode2(lookup14, head3, true)
						if stmt1 then
							cat3 = cat2("call-lambda", "stmt", true)
						else
							cat3 = cat2("call")
						end
					else
						cat3 = cat2("wrap-value")
					end
				elseif stmt1 and builtin_3f_1(car2(head3), "lambda") then
					visitNodes1(lookup14, car2(node42), 3, true)
					local lam4 = car2(node42)
					local args11 = nth1(lam4, 2)
					local offset3 = 1
					local r_6411 = _23_1(args11)
					local r_6391 = nil
					r_6391 = (function(r_6401)
						if (r_6401 <= r_6411) then
							local arg26 = nth1(args11, r_6401)
							if arg26["var"]["isVariadic"] then
								local count3 = (_23_1(node42) - _23_1(args11))
								if (count3 < 0) then
									count3 = 0
								else
								end
								local r_6451 = count3
								local r_6431 = nil
								r_6431 = (function(r_6441)
									if (r_6441 <= r_6451) then
										visitNode2(lookup14, nth1(node42, (r_6401 + r_6441)), false)
										return r_6431((r_6441 + 1))
									else
									end
								end)
								r_6431(1)
								offset3 = count3
							else
								local val18 = nth1(node42, (r_6401 + offset3))
								if val18 then
									visitNode2(lookup14, val18, true)
								else
								end
							end
							return r_6391((r_6401 + 1))
						else
						end
					end)
					r_6391(1)
					local r_6491 = _23_1(node42)
					local r_6471 = nil
					r_6471 = (function(r_6481)
						if (r_6481 <= r_6491) then
							visitNode2(lookup14, nth1(node42, r_6481), true)
							return r_6471((r_6481 + 1))
						else
						end
					end)
					r_6471((_23_1(args11) + (offset3 + 1)))
					cat3 = cat2("call-lambda", "stmt", true)
				else
					local temp76
					local r_6511 = builtin_3f_1(car2(head3), "quote")
					temp76 = r_6511 or builtin_3f_1(car2(head3), "syntax-quote")
					if temp76 then
						visitNodes1(lookup14, node42, 1, false)
						cat3 = cat2("call-literal")
					else
						visitNodes1(lookup14, node42, 1, false)
						cat3 = cat2("call")
					end
				end
			end
		elseif eq_3f_1(r_5891, true) then
			visitNodes1(lookup14, node42, 1, false)
			cat3 = cat2("call-literal")
		else
			cat3 = error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_5891), ", but none matched.\n", "  Tried: `\"symbol\"`\n  Tried: `\"list\"`\n  Tried: `true`"))
		end
	else
		cat3 = error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_5881), ", but none matched.\n", "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"key\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`"))
	end
	lookup14[node42] = cat3
	return cat3
end)
visitNodes1 = (function(lookup15, nodes19, start6, stmt2)
	local r_5921 = _23_1(nodes19)
	local r_5901 = nil
	r_5901 = (function(r_5911)
		if (r_5911 <= r_5921) then
			visitNode2(lookup15, nth1(nodes19, r_5911), stmt2)
			return r_5901((r_5911 + 1))
		else
		end
	end)
	return r_5901(start6)
end)
visitQuote2 = (function(lookup16, node44, level5)
	if (level5 == 0) then
		return visitNode2(lookup16, node44, false)
	else
		if list_3f_1(node44) then
			local r_5941 = car2(node44)
			if eq_3f_1(r_5941, ({ tag="symbol", contents="unquote"})) then
				return visitQuote2(lookup16, nth1(node44, 2), pred1(level5))
			elseif eq_3f_1(r_5941, ({ tag="symbol", contents="unquote-splice"})) then
				return visitQuote2(lookup16, nth1(node44, 2), pred1(level5))
			elseif eq_3f_1(r_5941, ({ tag="symbol", contents="syntax-quote"})) then
				return visitQuote2(lookup16, nth1(node44, 2), succ1(level5))
			else
				local r_5991 = _23_1(node44)
				local r_5971 = nil
				r_5971 = (function(r_5981)
					if (r_5981 <= r_5991) then
						visitQuote2(lookup16, node44[r_5981], level5)
						return r_5971((r_5981 + 1))
					else
					end
				end)
				return r_5971(1)
			end
		else
		end
	end
end)
categoriseNodes1 = struct1("name", "categorise-nodes", "help", "Categorise a group of NODES, annotating their appropriate node type.", "cat", ({tag = "list", n = 1, "categorise"}), "run", (function(r_45113, state22, nodes20, lookup17)
	return visitNodes1(lookup17, nodes20, 1, true)
end))
categoriseNode1 = struct1("name", "categorise-node", "help", "Categorise a NODE, annotating it's appropriate node type.", "cat", ({tag = "list", n = 1, "categorise"}), "run", (function(r_45114, state23, node45, lookup18, stmt3)
	return visitNode2(lookup18, node45, stmt3)
end))
keywords1 = createLookup1(({tag = "list", n = 21, "and", "break", "do", "else", "elseif", "end", "false", "for", "function", "if", "in", "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while"}))
escape1 = (function(name12)
	if keywords1[name12] then
		return _2e2e_2("_e", name12)
	elseif find1(name12, "^%w[_%w%d]*$") then
		return name12
	else
		local out7
		if find1(charAt1(name12, 1), "%d") then
			out7 = "_e"
		else
			out7 = ""
		end
		local upper2 = false
		local esc1 = false
		local r_6541 = len1(name12)
		local r_6521 = nil
		r_6521 = (function(r_6531)
			if (r_6531 <= r_6541) then
				local char2 = charAt1(name12, r_6531)
				local temp77
				local r_6561 = (char2 == "-")
				if r_6561 then
					local r_6571 = find1(charAt1(name12, pred1(r_6531)), "[%a%d']")
					temp77 = r_6571 and find1(charAt1(name12, succ1(r_6531)), "[%a%d']")
				else
					temp77 = r_6561
				end
				if temp77 then
					upper2 = true
				elseif find1(char2, "[^%w%d]") then
					char2 = format1("%02x", (byte1(char2)))
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
				return r_6521((r_6531 + 1))
			else
			end
		end)
		r_6521(1)
		if esc1 then
			out7 = _2e2e_2(out7, "_")
		else
		end
		return out7
	end
end)
escapeVar1 = (function(var15, state24)
	if builtinVars1[var15] then
		return var15["name"]
	else
		local v4 = escape1(var15["name"])
		local id2 = state24["var-lookup"][var15]
		if id2 then
		else
			id2 = succ1((function(r_6661)
				return r_6661 or 0
			end)(state24["ctr-lookup"][v4]))
			state24["ctr-lookup"][v4] = id2
			state24["var-lookup"][var15] = id2
		end
		return _2e2e_2(v4, tostring1(id2))
	end
end)
truthy_3f_1 = (function(node46)
	local r_5831 = symbol_3f_1(node46)
	return r_5831 and (builtinVars1["true"] == node46["var"])
end)
boringCategories1 = struct1("const", true, "quote", true, "not", true, "condtrue")
compileQuote1 = (function(node47, out8, state25, level6)
	if (level6 == 0) then
		return compileExpression1(node47, out8, state25)
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
			local first7 = car2(node47)
			local temp78
			local r_6671 = symbol_3f_1(first7)
			if r_6671 then
				local r_6681 = (first7["var"] == builtins1["unquote"])
				temp78 = r_6681 or ("var" == builtins1["unquote-splice"])
			else
				temp78 = r_6671
			end
			if temp78 then
				return compileQuote1(nth1(node47, 2), out8, state25, level6 and pred1(level6))
			else
				local temp79
				local r_6701 = symbol_3f_1(first7)
				temp79 = r_6701 and (first7["var"] == builtins1["syntax-quote"])
				if temp79 then
					return compileQuote1(nth1(node47, 2), out8, state25, level6 and succ1(level6))
				else
					pushNode_21_1(out8, node47)
					local containsUnsplice1 = false
					local r_6761 = _23_1(node47)
					local r_6741 = nil
					r_6741 = (function(r_6751)
						if (r_6751 <= r_6761) then
							local sub4 = node47[r_6751]
							local temp80
							local r_6781 = list_3f_1(sub4)
							if r_6781 then
								local r_6791 = symbol_3f_1(car2(sub4))
								temp80 = r_6791 and (sub4[1]["var"] == builtins1["unquote-splice"])
							else
								temp80 = r_6781
							end
							if temp80 then
								containsUnsplice1 = true
							else
							end
							return r_6741((r_6751 + 1))
						else
						end
					end)
					r_6741(1)
					if containsUnsplice1 then
						local offset4 = 0
						beginBlock_21_1(out8, "(function()")
						line_21_1(out8, "local _offset, _result, _temp = 0, {tag=\"list\",n=0}")
						local r_6821 = _23_1(node47)
						local r_6801 = nil
						r_6801 = (function(r_6811)
							if (r_6811 <= r_6821) then
								local sub5 = nth1(node47, r_6811)
								local temp81
								local r_6841 = list_3f_1(sub5)
								if r_6841 then
									local r_6851 = symbol_3f_1(car2(sub5))
									temp81 = r_6851 and (sub5[1]["var"] == builtins1["unquote-splice"])
								else
									temp81 = r_6841
								end
								if temp81 then
									offset4 = (offset4 + 1)
									append_21_1(out8, "_temp = ")
									compileQuote1(nth1(sub5, 2), out8, state25, pred1(level6))
									line_21_1(out8)
									line_21_1(out8, _2e2e_2("for _c = 1, _temp.n do _result[", tostring1((r_6811 - offset4)), " + _c + _offset] = _temp[_c] end"))
									line_21_1(out8, "_offset = _offset + _temp.n")
								else
									append_21_1(out8, _2e2e_2("_result[", tostring1((r_6811 - offset4)), " + _offset] = "))
									compileQuote1(sub5, out8, state25, level6)
									line_21_1(out8)
								end
								return r_6801((r_6811 + 1))
							else
							end
						end)
						r_6801(1)
						line_21_1(out8, _2e2e_2("_result.n = _offset + ", tostring1((_23_1(node47) - offset4))))
						line_21_1(out8, "return _result")
						endBlock_21_1(out8, "end)()")
					else
						append_21_1(out8, _2e2e_2("({tag = \"list\", n = ", tostring1(_23_1(node47))))
						local r_6901 = _23_1(node47)
						local r_6881 = nil
						r_6881 = (function(r_6891)
							if (r_6891 <= r_6901) then
								local sub6 = node47[r_6891]
								append_21_1(out8, ", ")
								compileQuote1(sub6, out8, state25, level6)
								return r_6881((r_6891 + 1))
							else
							end
						end)
						r_6881(1)
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
compileExpression1 = (function(node48, out9, state26, ret1)
	local catLookup1 = state26["cat-lookup"]
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
			if symbol_3f_1(node48) then
				append_21_1(out9, escapeVar1(node48["var"], state26))
			elseif string_3f_1(node48) then
				append_21_1(out9, quoted1(node48["value"]))
			elseif number_3f_1(node48) then
				append_21_1(out9, tostring1(node48["value"]))
			elseif key_3f_1(node48) then
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
			local args12 = nth1(node48, 2)
			local variadic1 = nil
			local i8 = 1
			append_21_1(out9, "(function(")
			local r_6931 = nil
			r_6931 = (function()
				local temp82
				local r_6941 = (i8 <= _23_1(args12))
				temp82 = r_6941 and _21_1(variadic1)
				if temp82 then
					if (i8 > 1) then
						append_21_1(out9, ", ")
					else
					end
					local var16 = args12[i8]["var"]
					if var16["isVariadic"] then
						append_21_1(out9, "...")
						variadic1 = i8
					else
						append_21_1(out9, escapeVar1(var16, state26))
					end
					i8 = (i8 + 1)
					return r_6931()
				else
				end
			end)
			r_6931()
			beginBlock_21_1(out9, ")")
			if variadic1 then
				local argsVar1 = escapeVar1(args12[variadic1]["var"], state26)
				if (variadic1 == _23_1(args12)) then
					line_21_1(out9, _2e2e_2("local ", argsVar1, " = _pack(...) ", argsVar1, ".tag = \"list\""))
				else
					local remaining1 = (_23_1(args12) - variadic1)
					line_21_1(out9, _2e2e_2("local _n = _select(\"#\", ...) - ", tostring1(remaining1)))
					append_21_1(out9, _2e2e_2("local ", argsVar1))
					local r_6971 = _23_1(args12)
					local r_6951 = nil
					r_6951 = (function(r_6961)
						if (r_6961 <= r_6971) then
							append_21_1(out9, ", ")
							append_21_1(out9, escapeVar1(args12[r_6961]["var"], state26))
							return r_6951((r_6961 + 1))
						else
						end
					end)
					r_6951(succ1(variadic1))
					line_21_1(out9)
					beginBlock_21_1(out9, "if _n > 0 then")
					append_21_1(out9, argsVar1)
					line_21_1(out9, " = { tag=\"list\", n=_n, _unpack(_pack(...), 1, _n)}")
					local r_7011 = _23_1(args12)
					local r_6991 = nil
					r_6991 = (function(r_7001)
						if (r_7001 <= r_7011) then
							append_21_1(out9, escapeVar1(args12[r_7001]["var"], state26))
							if (r_7001 < _23_1(args12)) then
								append_21_1(out9, ", ")
							else
							end
							return r_6991((r_7001 + 1))
						else
						end
					end)
					r_6991(succ1(variadic1))
					line_21_1(out9, " = select(_n + 1, ...)")
					nextBlock_21_1(out9, "else")
					append_21_1(out9, argsVar1)
					line_21_1(out9, " = { tag=\"list\", n=0}")
					local r_7051 = _23_1(args12)
					local r_7031 = nil
					r_7031 = (function(r_7041)
						if (r_7041 <= r_7051) then
							append_21_1(out9, escapeVar1(args12[r_7041]["var"], state26))
							if (r_7041 < _23_1(args12)) then
								append_21_1(out9, ", ")
							else
							end
							return r_7031((r_7041 + 1))
						else
						end
					end)
					r_7031(succ1(variadic1))
					line_21_1(out9, " = ...")
					endBlock_21_1(out9, "end")
				end
			else
			end
			compileBlock1(node48, out9, state26, 3, "return ")
			unindent_21_1(out9)
			append_21_1(out9, "end)")
		end
	elseif (catTag1 == "cond") then
		local closure1 = _21_1(ret1)
		local hadFinal1 = false
		local ends1 = 1
		if closure1 then
			beginBlock_21_1(out9, "(function()")
			ret1 = "return "
		else
		end
		local i9 = 2
		local r_7071 = nil
		r_7071 = (function()
			local temp83
			local r_7081 = _21_1(hadFinal1)
			temp83 = r_7081 and (i9 <= _23_1(node48))
			if temp83 then
				local item1 = nth1(node48, i9)
				local case4 = nth1(item1, 1)
				local isFinal1 = truthy_3f_1(case4)
				if isFinal1 then
					if (i9 == 2) then
						append_21_1(out9, "do")
					else
					end
				elseif catLookup1[case4]["stmt"] then
					if (i9 > 2) then
						indent_21_1(out9)
						line_21_1(out9)
						ends1 = (ends1 + 1)
					else
					end
					local tmp1 = escapeVar1(struct1("name", "temp"), state26)
					line_21_1(out9, _2e2e_2("local ", tmp1))
					compileExpression1(case4, out9, state26, _2e2e_2(tmp1, " = "))
					line_21_1(out9)
					line_21_1(out9, _2e2e_2("if ", tmp1, " then"))
				else
					append_21_1(out9, "if ")
					compileExpression1(case4, out9, state26)
					append_21_1(out9, " then")
				end
				indent_21_1(out9)
				line_21_1(out9)
				compileBlock1(item1, out9, state26, 2, ret1)
				unindent_21_1(out9)
				if isFinal1 then
					hadFinal1 = true
				else
					append_21_1(out9, "else")
				end
				i9 = (i9 + 1)
				return r_7071()
			else
			end
		end)
		r_7071()
		if hadFinal1 then
		else
			indent_21_1(out9)
			line_21_1(out9)
			append_21_1(out9, "_error(\"unmatched item\")")
			unindent_21_1(out9)
			line_21_1(out9)
		end
		local r_7111 = ends1
		local r_7091 = nil
		r_7091 = (function(r_7101)
			if (r_7101 <= r_7111) then
				append_21_1(out9, "end")
				if (r_7101 < ends1) then
					unindent_21_1(out9)
					line_21_1(out9)
				else
				end
				return r_7091((r_7101 + 1))
			else
			end
		end)
		r_7091(1)
		if closure1 then
			line_21_1(out9)
			endBlock_21_1(out9, "end)()")
		else
		end
	elseif (catTag1 == "not") then
		if ret1 then
			ret1 = _2e2e_2(ret1, "not ")
		else
			append_21_1(out9, "not ")
		end
		compileExpression1(car2(nth1(node48, 2)), out9, state26, ret1)
	elseif (catTag1 == "or") then
		if ret1 then
			append_21_1(out9, ret1)
		else
		end
		local r_7151 = _23_1(node48)
		local r_7131 = nil
		r_7131 = (function(r_7141)
			if (r_7141 <= r_7151) then
				if (r_7141 > 2) then
					append_21_1(out9, " or ")
				else
				end
				compileExpression1(nth1(nth1(node48, r_7141), 2), out9, state26)
				return r_7131((r_7141 + 1))
			else
			end
		end)
		r_7131(2)
	elseif (catTag1 == "and") then
		if ret1 then
			append_21_1(out9, ret1)
		else
		end
		compileExpression1(nth1(nth1(node48, 2), 1), out9, state26)
		append_21_1(out9, " and ")
		compileExpression1(nth1(nth1(node48, 2), 2), out9, state26)
	elseif (catTag1 == "set!") then
		compileExpression1(nth1(node48, 3), out9, state26, _2e2e_2(escapeVar1(node48[2]["var"], state26), " = "))
		local temp84
		local r_7171 = ret1
		temp84 = r_7171 and (ret1 ~= "")
		if temp84 then
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
		local body3 = car2(node48)
		local r_7201 = pred1(_23_1(body3))
		local r_7181 = nil
		r_7181 = (function(r_7191)
			if (r_7191 <= r_7201) then
				if (r_7191 > 3) then
					append_21_1(out9, ",")
				else
				end
				local entry4 = nth1(body3, r_7191)
				append_21_1(out9, "[")
				compileExpression1(nth1(entry4, 3), out9, state26)
				append_21_1(out9, "]=")
				compileExpression1(nth1(entry4, 4), out9, state26)
				return r_7181((r_7191 + 1))
			else
			end
		end)
		r_7181(3)
		append_21_1(out9, "}")
	elseif (catTag1 == "define") then
		compileExpression1(nth1(node48, _23_1(node48)), out9, state26, _2e2e_2(escapeVar1(node48["defVar"], state26), " = "))
	elseif (catTag1 == "define-native") then
		local meta2 = state26["meta"][node48["defVar"]["fullName"]]
		local ty6 = type1(meta2)
		if (ty6 == "nil") then
			append_21_1(out9, format1("%s = _libs[%q]", escapeVar1(node48["defVar"], state26), node48["defVar"]["fullName"]))
		elseif (ty6 == "var") then
			append_21_1(out9, format1("%s = %s", escapeVar1(node48["defVar"], state26), meta2["contents"]))
		else
			local temp85
			local r_7221 = (ty6 == "expr")
			temp85 = r_7221 or (ty6 == "stmt")
			if temp85 then
				local count4 = meta2["count"]
				append_21_1(out9, format1("%s = function(", escapeVar1(node48["defVar"], state26)))
				local r_7231 = nil
				r_7231 = (function(r_7241)
					if (r_7241 <= count4) then
						if (r_7241 == 1) then
						else
							append_21_1(out9, ", ")
						end
						append_21_1(out9, _2e2e_2("v", tonumber1(r_7241)))
						return r_7231((r_7241 + 1))
					else
					end
				end)
				r_7231(1)
				append_21_1(out9, ") ")
				if (ty6 == "expr") then
					append_21_1(out9, "return ")
				else
				end
				local r_7281 = meta2["contents"]
				local r_7311 = _23_1(r_7281)
				local r_7291 = nil
				r_7291 = (function(r_7301)
					if (r_7301 <= r_7311) then
						local entry5 = r_7281[r_7301]
						if number_3f_1(entry5) then
							append_21_1(out9, _2e2e_2("v", tonumber1(entry5)))
						else
							append_21_1(out9, entry5)
						end
						return r_7291((r_7301 + 1))
					else
					end
				end)
				r_7291(1)
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
			compileQuote1(nth1(node48, 2), out9, state26)
		end
	elseif (catTag1 == "syntax-quote") then
		if (ret1 == "") then
			append_21_1(out9, "local _ =")
		elseif ret1 then
			append_21_1(out9, ret1)
		else
		end
		compileQuote1(nth1(node48, 2), out9, state26, 1)
	elseif (catTag1 == "import") then
		if (ret1 == nil) then
			append_21_1(out9, "nil")
		elseif (ret1 ~= "") then
			append_21_1(out9, ret1)
			append_21_1(out9, "nil")
		else
		end
	elseif (catTag1 == "call-symbol") then
		local head4 = car2(node48)
		local meta3
		local r_7441 = symbol_3f_1(head4)
		if r_7441 then
			local r_7451 = (head4["var"]["tag"] == "native")
			meta3 = r_7451 and state26["meta"][head4["var"]["fullName"]]
		else
			meta3 = r_7441
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
		local temp86
		local r_7331 = meta3
		temp86 = r_7331 and (pred1(_23_1(node48)) == meta3["count"])
		if temp86 then
			local temp87
			local r_7341 = ret1
			temp87 = r_7341 and (meta3["tag"] == "expr")
			if temp87 then
				append_21_1(out9, ret1)
			else
			end
			local contents1 = meta3["contents"]
			local r_7371 = _23_1(contents1)
			local r_7351 = nil
			r_7351 = (function(r_7361)
				if (r_7361 <= r_7371) then
					local entry6 = nth1(contents1, r_7361)
					if number_3f_1(entry6) then
						compileExpression1(nth1(node48, succ1(entry6)), out9, state26)
					else
						append_21_1(out9, entry6)
					end
					return r_7351((r_7361 + 1))
				else
				end
			end)
			r_7351(1)
			local temp88
			local r_7391 = (meta3["tag"] ~= "expr")
			temp88 = r_7391 and (ret1 ~= "")
			if temp88 then
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
			compileExpression1(head4, out9, state26)
			append_21_1(out9, "(")
			local r_7421 = _23_1(node48)
			local r_7401 = nil
			r_7401 = (function(r_7411)
				if (r_7411 <= r_7421) then
					if (r_7411 > 2) then
						append_21_1(out9, ", ")
					else
					end
					compileExpression1(nth1(node48, r_7411), out9, state26)
					return r_7401((r_7411 + 1))
				else
				end
			end)
			r_7401(2)
			append_21_1(out9, ")")
		end
	elseif (catTag1 == "wrap-value") then
		if ret1 then
			append_21_1(out9, ret1)
		else
		end
		append_21_1(out9, "(")
		compileExpression1(nth1(node48, 2), out9, state26)
		append_21_1(out9, ")")
	elseif (catTag1 == "call-lambda") then
		if (ret1 == nil) then
			print1(pretty1(node48), " marked as call-lambda for ", ret1)
		else
		end
		local head5 = car2(node48)
		local args13 = nth1(head5, 2)
		local offset5 = 1
		local r_7481 = _23_1(args13)
		local r_7461 = nil
		r_7461 = (function(r_7471)
			if (r_7471 <= r_7481) then
				local var17 = args13[r_7471]["var"]
				local esc2 = escapeVar1(var17, state26)
				append_21_1(out9, _2e2e_2("local ", esc2))
				if var17["isVariadic"] then
					local count5 = (_23_1(node48) - _23_1(args13))
					if (count5 < 0) then
						count5 = 0
					else
					end
					local temp89
					local r_7501 = (count5 <= 0)
					temp89 = r_7501 or atom_3f_1(nth1(node48, (r_7471 + count5)))
					if temp89 then
						append_21_1(out9, " = { tag=\"list\", n=")
						append_21_1(out9, tostring1(count5))
						local r_7531 = count5
						local r_7511 = nil
						r_7511 = (function(r_7521)
							if (r_7521 <= r_7531) then
								append_21_1(out9, ", ")
								compileExpression1(nth1(node48, (r_7471 + r_7521)), out9, state26)
								return r_7511((r_7521 + 1))
							else
							end
						end)
						r_7511(1)
						line_21_1(out9, "}")
					else
						append_21_1(out9, " = _pack(")
						local r_7571 = count5
						local r_7551 = nil
						r_7551 = (function(r_7561)
							if (r_7561 <= r_7571) then
								if (r_7561 > 1) then
									append_21_1(out9, ", ")
								else
								end
								compileExpression1(nth1(node48, (r_7471 + r_7561)), out9, state26)
								return r_7551((r_7561 + 1))
							else
							end
						end)
						r_7551(1)
						line_21_1(out9, ")")
						line_21_1(out9, _2e2e_2(esc2, ".tag = \"list\""))
					end
					offset5 = count5
				else
					local expr2 = nth1(node48, (r_7471 + offset5))
					local name13 = escapeVar1(var17, state26)
					local ret2 = nil
					if expr2 then
						if catLookup1[expr2]["stmt"] then
							ret2 = _2e2e_2(name13, " = ")
							line_21_1(out9)
						else
							append_21_1(out9, " = ")
						end
						compileExpression1(expr2, out9, state26, ret2)
						line_21_1(out9)
					else
						line_21_1(out9)
					end
				end
				return r_7461((r_7471 + 1))
			else
			end
		end)
		r_7461(1)
		local r_7611 = _23_1(node48)
		local r_7591 = nil
		r_7591 = (function(r_7601)
			if (r_7601 <= r_7611) then
				compileExpression1(nth1(node48, r_7601), out9, state26, "")
				line_21_1(out9)
				return r_7591((r_7601 + 1))
			else
			end
		end)
		r_7591((_23_1(args13) + (offset5 + 1)))
		compileBlock1(head5, out9, state26, 3, ret1)
	elseif (catTag1 == "call-literal") then
		if ret1 then
			append_21_1(out9, ret1)
		else
		end
		append_21_1(out9, "(")
		compileExpression1(car2(node48), out9, state26)
		append_21_1(out9, ")(")
		local r_7651 = _23_1(node48)
		local r_7631 = nil
		r_7631 = (function(r_7641)
			if (r_7641 <= r_7651) then
				if (r_7641 > 2) then
					append_21_1(out9, ", ")
				else
				end
				compileExpression1(nth1(node48, r_7641), out9, state26)
				return r_7631((r_7641 + 1))
			else
			end
		end)
		r_7631(2)
		append_21_1(out9, ")")
	elseif (catTag1 == "call") then
		if ret1 then
			append_21_1(out9, ret1)
		else
		end
		compileExpression1(car2(node48), out9, state26)
		append_21_1(out9, "(")
		local r_7691 = _23_1(node48)
		local r_7671 = nil
		r_7671 = (function(r_7681)
			if (r_7681 <= r_7691) then
				if (r_7681 > 2) then
					append_21_1(out9, ", ")
				else
				end
				compileExpression1(nth1(node48, r_7681), out9, state26)
				return r_7671((r_7681 + 1))
			else
			end
		end)
		r_7671(2)
		append_21_1(out9, ")")
	else
		error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(catTag1), ", but none matched.\n", "  Tried: `\"const\"`\n  Tried: `\"lambda\"`\n  Tried: `\"cond\"`\n  Tried: `\"not\"`\n  Tried: `\"or\"`\n  Tried: `\"and\"`\n  Tried: `\"set!\"`\n  Tried: `\"make-struct\"`\n  Tried: `\"define\"`\n  Tried: `\"define-native\"`\n  Tried: `\"quote\"`\n  Tried: `\"syntax-quote\"`\n  Tried: `\"import\"`\n  Tried: `\"call-symbol\"`\n  Tried: `\"wrap-value\"`\n  Tried: `\"call-lambda\"`\n  Tried: `\"call-literal\"`\n  Tried: `\"call\"`"))
	end
	if boringCategories1[catTag1] then
	else
		return popNode_21_1(out9, node48)
	end
end)
compileBlock1 = (function(nodes21, out10, state27, start7, ret3)
	local r_5861 = _23_1(nodes21)
	local r_5841 = nil
	r_5841 = (function(r_5851)
		if (r_5851 <= r_5861) then
			local ret_27_1
			if (r_5851 == _23_1(nodes21)) then
				ret_27_1 = ret3
			else
				ret_27_1 = ""
			end
			compileExpression1(nth1(nodes21, r_5851), out10, state27, ret_27_1)
			line_21_1(out10)
			return r_5841((r_5851 + 1))
		else
		end
	end)
	return r_5841(start7)
end)
prelude1 = (function(out11)
	line_21_1(out11, "if not table.pack then table.pack = function(...) return { n = select(\"#\", ...), ... } end end")
	line_21_1(out11, "if not table.unpack then table.unpack = unpack end")
	line_21_1(out11, "local load = load if _VERSION:find(\"5.1\") then load = function(x, n, _, env) local f, e = loadstring(x, n) if not f then error(e, 2) end if env then setfenv(f, env) end return f end end")
	return line_21_1(out11, "local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error")
end)
expression2 = (function(node49, out12, state28, ret4)
	runPass1(categoriseNode1, state28, nil, node49, state28["cat-lookup"], (ret4 ~= nil))
	return compileExpression1(node49, out12, state28, ret4)
end)
block2 = (function(nodes22, out13, state29, start8, ret5)
	runPass1(categoriseNodes1, state29, nil, nodes22, state29["cat-lookup"])
	return compileBlock1(nodes22, out13, state29, start8, ret5)
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
		local len7 = len1(esc3)
		local r_7711 = nil
		r_7711 = (function()
			if (pos5 <= len7) then
				local char3 = charAt1(esc3, pos5)
				if (char3 == "_") then
					local r_7721 = list1(find1(esc3, "^_[%da-z]+_", pos5))
					local temp90
					local r_7741 = list_3f_1(r_7721)
					if r_7741 then
						local r_7751 = (_23_1(r_7721) >= 2)
						if r_7751 then
							local r_7761 = (_23_1(r_7721) <= 2)
							temp90 = r_7761 and true
						else
							temp90 = r_7751
						end
					else
						temp90 = r_7741
					end
					if temp90 then
						local start9 = nth1(r_7721, 1)
						local _eend1 = nth1(r_7721, 2)
						pos5 = (pos5 + 1)
						local r_7781 = nil
						r_7781 = (function()
							if (pos5 < _eend1) then
								pushCdr_21_1(buffer2, char1(tonumber1(sub1(esc3, pos5, succ1(pos5)), 16)))
								pos5 = (pos5 + 2)
								return r_7781()
							else
							end
						end)
						r_7781()
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
				return r_7711()
			else
			end
		end)
		r_7711()
		return concat1(buffer2)
	end
end)
remapError1 = (function(msg9)
	return (gsub1(gsub1(gsub1(gsub1(msg9, "local '([^']+)'", (function(x30)
		return _2e2e_2("local '", unmangleIdent1(x30), "'")
	end)), "global '([^']+)'", (function(x31)
		return _2e2e_2("global '", unmangleIdent1(x31), "'")
	end)), "upvalue '([^']+)'", (function(x32)
		return _2e2e_2("upvalue '", unmangleIdent1(x32), "'")
	end)), "function '([^']+)'", (function(x33)
		return _2e2e_2("function '", unmangleIdent1(x33), "'")
	end)))
end)
remapMessage1 = (function(mappings1, msg10)
	local r_7831 = list1(match1(msg10, "^(.-):(%d+)(.*)$"))
	local temp91
	local r_7851 = list_3f_1(r_7831)
	if r_7851 then
		local r_7861 = (_23_1(r_7831) >= 3)
		if r_7861 then
			local r_7871 = (_23_1(r_7831) <= 3)
			temp91 = r_7871 and true
		else
			temp91 = r_7861
		end
	else
		temp91 = r_7851
	end
	if temp91 then
		local file1 = nth1(r_7831, 1)
		local line2 = nth1(r_7831, 2)
		local extra1 = nth1(r_7831, 3)
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
	return gsub1(gsub1(gsub1(gsub1(gsub1(gsub1(gsub1(msg11, "^([^\n:]-:%d+:[^\n]*)", (function(r_7971)
		return remapMessage1(mappings2, r_7971)
	end)), "\9([^\n:]-:%d+:)", (function(msg12)
		return _2e2e_2("\9", remapMessage1(mappings2, msg12))
	end)), "<([^\n:]-:%d+)>\n", (function(msg13)
		return _2e2e_2("<", remapMessage1(mappings2, msg13), ">\n")
	end)), "in local '([^']+)'\n", (function(x34)
		return _2e2e_2("in local '", unmangleIdent1(x34), "'\n")
	end)), "in global '([^']+)'\n", (function(x35)
		return _2e2e_2("in global '", unmangleIdent1(x35), "'\n")
	end)), "in upvalue '([^']+)'\n", (function(x36)
		return _2e2e_2("in upvalue '", unmangleIdent1(x36), "'\n")
	end)), "in function '([^']+)'\n", (function(x37)
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
			local r_8001 = pos6["finish"]["line"]
			local r_7981 = nil
			r_7981 = (function(r_7991)
				if (r_7991 <= r_8001) then
					if rangeList1[r_7991] then
					else
						rangeList1["n"] = succ1(rangeList1["n"])
						rangeList1[r_7991] = true
						if (r_7991 < rangeList1["min"]) then
							rangeList1["min"] = r_7991
						else
						end
						if (r_7991 > rangeList1["max"]) then
							rangeList1["max"] = r_7991
						else
						end
					end
					return r_7981((r_7991 + 1))
				else
				end
			end)
			return r_7981(pos6["start"]["line"])
		end))
		local bestName1 = nil
		local bestLines1 = nil
		local bestCount1 = 0
		iterPairs1(rangeLists1, (function(name14, lines5)
			if (lines5["n"] > bestCount1) then
				bestName1 = name14
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
	local state30 = createState2(compiler1["libMeta"])
	local out14 = create3()
	if shebang1 then
		line_21_1(out14, _2e2e_2("#!/usr/bin/env ", shebang1))
	else
	end
	state30["trace"] = true
	prelude1(out14)
	line_21_1(out14, "local _libs = {}")
	local r_8241 = compiler1["libs"]
	local r_8271 = _23_1(r_8241)
	local r_8251 = nil
	r_8251 = (function(r_8261)
		if (r_8261 <= r_8271) then
			local lib1 = r_8241[r_8261]
			local prefix1 = quoted1(lib1["prefix"])
			local native1 = lib1["native"]
			if native1 then
				line_21_1(out14, "local _temp = (function()")
				local r_8301 = split1(native1, "\n")
				local r_8331 = _23_1(r_8301)
				local r_8311 = nil
				r_8311 = (function(r_8321)
					if (r_8321 <= r_8331) then
						local line4 = r_8301[r_8321]
						if (line4 ~= "") then
							append_21_1(out14, "\9")
							line_21_1(out14, line4)
						else
						end
						return r_8311((r_8321 + 1))
					else
					end
				end)
				r_8311(1)
				line_21_1(out14, "end)()")
				line_21_1(out14, _2e2e_2("for k, v in pairs(_temp) do _libs[", prefix1, ".. k] = v end"))
			else
			end
			return r_8251((r_8261 + 1))
		else
		end
	end)
	r_8251(1)
	local count6 = 0
	local r_8361 = compiler1["out"]
	local r_8391 = _23_1(r_8361)
	local r_8371 = nil
	r_8371 = (function(r_8381)
		if (r_8381 <= r_8391) then
			local node50 = r_8361[r_8381]
			local var18 = node50["defVar"]
			if var18 then
				count6 = (count6 + 1)
			else
			end
			return r_8371((r_8381 + 1))
		else
		end
	end)
	r_8371(1)
	if between_3f_1(count6, 1, 150) then
		append_21_1(out14, "local ")
		local first8 = true
		local r_8421 = compiler1["out"]
		local r_8451 = _23_1(r_8421)
		local r_8431 = nil
		r_8431 = (function(r_8441)
			if (r_8441 <= r_8451) then
				local node51 = r_8421[r_8441]
				local var19 = node51["defVar"]
				if var19 then
					if first8 then
						first8 = false
					else
						append_21_1(out14, ", ")
					end
					append_21_1(out14, escapeVar1(var19, state30))
				else
				end
				return r_8431((r_8441 + 1))
			else
			end
		end)
		r_8431(1)
		line_21_1(out14)
	else
	end
	block2(compiler1["out"], out14, state30, 1, "return ")
	return out14
end)
executeStates1 = (function(backState1, states1, global1, logger9)
	local stateList1 = ({tag = "list", n = 0})
	local nameList1 = ({tag = "list", n = 0})
	local exportList1 = ({tag = "list", n = 0})
	local escapeList1 = ({tag = "list", n = 0})
	local r_5791 = nil
	r_5791 = (function(r_5801)
		if (r_5801 >= 1) then
			local state31 = nth1(states1, r_5801)
			if (state31["stage"] == "executed") then
			else
				local node52
				if state31["node"] then
				else
					node52 = error1(_2e2e_2("State is in ", state31["stage"], " instead"), 0)
				end
				local var20
				local r_8471 = state31["var"]
				var20 = r_8471 or struct1("name", "temp")
				local escaped1 = escapeVar1(var20, backState1)
				local name15 = var20["name"]
				pushCdr_21_1(stateList1, state31)
				pushCdr_21_1(exportList1, _2e2e_2(escaped1, " = ", escaped1))
				pushCdr_21_1(nameList1, name15)
				pushCdr_21_1(escapeList1, escaped1)
			end
			return r_5791((r_5801 + -1))
		else
		end
	end)
	r_5791(_23_1(states1))
	if nil_3f_1(stateList1) then
	else
		local out15 = create3()
		local id3 = backState1["count"]
		local name16 = concat1(nameList1, ",")
		backState1["count"] = succ1(id3)
		if (len1(name16) > 20) then
			name16 = _2e2e_2(sub1(name16, 1, 17), "...")
		else
		end
		name16 = _2e2e_2("compile#", id3, "{", name16, "}")
		prelude1(out15)
		line_21_1(out15, _2e2e_2("local ", concat1(escapeList1, ", ")))
		local r_8501 = _23_1(stateList1)
		local r_8481 = nil
		r_8481 = (function(r_8491)
			if (r_8491 <= r_8501) then
				local state32 = nth1(stateList1, r_8491)
				expression2(state32["node"], out15, backState1, (function()
					if state32["var"] then
						return ""
					else
						return _2e2e_2(nth1(escapeList1, r_8491), "= ")
					end
				end)()
				)
				line_21_1(out15)
				return r_8481((r_8491 + 1))
			else
			end
		end)
		r_8481(1)
		line_21_1(out15, _2e2e_2("return { ", concat1(exportList1, ", "), "}"))
		local str2 = _2d3e_string1(out15)
		backState1["mappings"][name16] = generateMappings1(out15["lines"])
		local r_8521 = list1(load1(str2, _2e2e_2("=", name16), "t", global1))
		local temp92
		local r_8551 = list_3f_1(r_8521)
		if r_8551 then
			local r_8561 = (_23_1(r_8521) >= 2)
			if r_8561 then
				local r_8571 = (_23_1(r_8521) <= 2)
				if r_8571 then
					local r_8581 = eq_3f_1(nth1(r_8521, 1), nil)
					temp92 = r_8581 and true
				else
					temp92 = r_8571
				end
			else
				temp92 = r_8561
			end
		else
			temp92 = r_8551
		end
		if temp92 then
			local msg14 = nth1(r_8521, 2)
			local buffer3 = ({tag = "list", n = 0})
			local lines6 = split1(str2, "\n")
			local format2 = _2e2e_2("%", len1(tostring1(_23_1(lines6))), "d | %s")
			local r_8611 = _23_1(lines6)
			local r_8591 = nil
			r_8591 = (function(r_8601)
				if (r_8601 <= r_8611) then
					pushCdr_21_1(buffer3, format1(format2, r_8601, nth1(lines6, r_8601)))
					return r_8591((r_8601 + 1))
				else
				end
			end)
			r_8591(1)
			return fail_21_1(_2e2e_2(msg14, ":\n", concat1(buffer3, "\n")))
		else
			local temp93
			local r_8631 = list_3f_1(r_8521)
			if r_8631 then
				local r_8641 = (_23_1(r_8521) >= 1)
				if r_8641 then
					local r_8651 = (_23_1(r_8521) <= 1)
					temp93 = r_8651 and true
				else
					temp93 = r_8641
				end
			else
				temp93 = r_8631
			end
			if temp93 then
				local fun1 = nth1(r_8521, 1)
				local r_8661 = list1(xpcall1(fun1, traceback1))
				local temp94
				local r_8691 = list_3f_1(r_8661)
				if r_8691 then
					local r_8701 = (_23_1(r_8661) >= 2)
					if r_8701 then
						local r_8711 = (_23_1(r_8661) <= 2)
						if r_8711 then
							local r_8721 = eq_3f_1(nth1(r_8661, 1), false)
							temp94 = r_8721 and true
						else
							temp94 = r_8711
						end
					else
						temp94 = r_8701
					end
				else
					temp94 = r_8691
				end
				if temp94 then
					local msg15 = nth1(r_8661, 2)
					return fail_21_1(remapTraceback1(backState1["mappings"], msg15))
				else
					local temp95
					local r_8731 = list_3f_1(r_8661)
					if r_8731 then
						local r_8741 = (_23_1(r_8661) >= 2)
						if r_8741 then
							local r_8751 = (_23_1(r_8661) <= 2)
							if r_8751 then
								local r_8761 = eq_3f_1(nth1(r_8661, 1), true)
								temp95 = r_8761 and true
							else
								temp95 = r_8751
							end
						else
							temp95 = r_8741
						end
					else
						temp95 = r_8731
					end
					if temp95 then
						local tbl1 = nth1(r_8661, 2)
						local r_8791 = _23_1(stateList1)
						local r_8771 = nil
						r_8771 = (function(r_8781)
							if (r_8781 <= r_8791) then
								local state33 = nth1(stateList1, r_8781)
								local escaped2 = nth1(escapeList1, r_8781)
								local res6 = tbl1[escaped2]
								self1(state33, "executed", res6)
								if state33["var"] then
									global1[escaped2] = res6
								else
								end
								return r_8771((r_8781 + 1))
							else
							end
						end)
						return r_8771(1)
					else
						return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_8661), ", but none matched.\n", "  Tried: `(false ?msg)`\n  Tried: `(true ?tbl)`"))
					end
				end
			else
				return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_8521), ", but none matched.\n", "  Tried: `(nil ?msg)`\n  Tried: `(?fun)`"))
			end
		end
	end
end)
emitLua1 = struct1("name", "emit-lua", "setup", (function(spec7)
	addArgument_21_1(spec7, ({tag = "list", n = 1, "--emit-lua"}), "help", "Emit a Lua file.")
	addArgument_21_1(spec7, ({tag = "list", n = 1, "--shebang"}), "value", (function(r_8811)
		if r_8811 then
			return r_8811
		else
			local r_8821 = nth1(arg1, 0)
			return r_8821 or "lua"
		end
	end)(nth1(arg1, -1)), "help", "Set the executable to use for the shebang.", "narg", "?")
	return addArgument_21_1(spec7, ({tag = "list", n = 1, "--chmod"}), "help", "Run chmod +x on the resulting file")
end), "pred", (function(args14)
	return args14["emit-lua"]
end), "run", (function(compiler2, args15)
	if nil_3f_1(args15["input"]) then
		putError_21_1(compiler2["log"], "No inputs to compile.")
		exit_21_1(1)
	else
	end
	local out16 = file3(compiler2, args15["shebang"])
	local handle1 = open1(_2e2e_2(args15["output"], ".lua"), "w")
	self1(handle1, "write", _2d3e_string1(out16))
	self1(handle1, "close")
	if args15["chmod"] then
		return execute1(_2e2e_2("chmod +x ", quoted1(_2e2e_2(args15["output"], ".lua"))))
	else
	end
end))
emitLisp1 = struct1("name", "emit-lisp", "setup", (function(spec8)
	return addArgument_21_1(spec8, ({tag = "list", n = 1, "--emit-lisp"}), "help", "Emit a Lisp file.")
end), "pred", (function(args16)
	return args16["emit-lisp"]
end), "run", (function(compiler3, args17)
	if nil_3f_1(args17["input"]) then
		putError_21_1(compiler3["log"], "No inputs to compile.")
		exit_21_1(1)
	else
	end
	local writer13 = create3()
	block1(compiler3["out"], writer13)
	local handle2 = open1(_2e2e_2(args17["output"], ".lisp"), "w")
	self1(handle2, "write", _2d3e_string1(writer13))
	return self1(handle2, "close")
end))
passArg1 = (function(arg27, data4, value8, usage_21_4)
	local val19 = tonumber1(value8)
	local name17 = _2e2e_2(arg27["name"], "-override")
	local override2 = data4[name17]
	if override2 then
	else
		override2 = ({})
		data4[name17] = override2
	end
	if val19 then
		data4[arg27["name"]] = val19
		return nil
	elseif (charAt1(value8, 1) == "-") then
		override2[sub1(value8, 2)] = false
		return nil
	elseif (charAt1(value8, 1) == "+") then
		override2[sub1(value8, 2)] = true
		return nil
	else
		return usage_21_4(_2e2e_2("Expected number or enable/disable flag for --", arg27["name"], " , got ", value8))
	end
end)
passRun1 = (function(fun2, name18)
	return (function(compiler4, args18)
		return fun2(compiler4["out"], struct1("track", true, "level", args18[name18], "override", (function(r_2131)
			return r_2131 or ({})
		end)(args18[_2e2e_2(name18, "-override")]), "max-n", args18[_2e2e_2(name18, "-n")], "max-time", args18[_2e2e_2(name18, "-time")], "meta", compiler4["libMeta"], "logger", compiler4["log"], "timer", compiler4["timer"]))
	end)
end)
warning1 = struct1("name", "warning", "setup", (function(spec9)
	return addArgument_21_1(spec9, ({tag = "list", n = 2, "--warning", "-W"}), "help", "Either the warning level to use or an enable/disable flag for a pass.", "default", 1, "narg", 1, "var", "LEVEL", "action", passArg1)
end), "pred", (function(args19)
	return (args19["warning"] > 0)
end), "run", passRun1(analyse1, "warning"))
optimise2 = struct1("name", "optimise", "setup", (function(spec10)
	addArgument_21_1(spec10, ({tag = "list", n = 2, "--optimise", "-O"}), "help", "Either the optimiation level to use or an enable/disable flag for a pass.", "default", 1, "narg", 1, "var", "LEVEL", "action", passArg1)
	addArgument_21_1(spec10, ({tag = "list", n = 2, "--optimise-n", "--optn"}), "help", "The maximum number of iterations the optimiser should run for.", "default", 10, "narg", 1, "action", setNumAction1)
	return addArgument_21_1(spec10, ({tag = "list", n = 2, "--optimise-time", "--optt"}), "help", "The maximum time the optimiser should run for.", "default", -1, "narg", 1, "action", setNumAction1)
end), "pred", (function(args20)
	return (args20["optimise"] > 0)
end), "run", passRun1(optimise1, "optimise"))
builtins4 = require1("tacky.analysis.resolve")["builtins"]
tokens1 = ({tag = "list", n = 7, ({tag = "list", n = 2, "arg", "(%f[%a]%u+%f[%A])"}), ({tag = "list", n = 2, "mono", "```[a-z]*\n([^`]*)\n```"}), ({tag = "list", n = 2, "mono", "`([^`]*)`"}), ({tag = "list", n = 2, "bolic", "(%*%*%*%w.-%w%*%*%*)"}), ({tag = "list", n = 2, "bold", "(%*%*%w.-%w%*%*)"}), ({tag = "list", n = 2, "italic", "(%*%w.-%w%*)"}), ({tag = "list", n = 2, "link", "%[%[(.-)%]%]"})})
extractSignature1 = (function(var21)
	local ty7 = type1(var21)
	local temp96
	local r_8901 = (ty7 == "macro")
	temp96 = r_8901 or (ty7 == "defined")
	if temp96 then
		local root2 = var21["node"]
		local node53 = nth1(root2, _23_1(root2))
		local temp97
		local r_8911 = list_3f_1(node53)
		if r_8911 then
			local r_8921 = symbol_3f_1(car2(node53))
			temp97 = r_8921 and (car2(node53)["var"] == builtins4["lambda"])
		else
			temp97 = r_8911
		end
		if temp97 then
			return nth1(node53, 2)
		else
			return nil
		end
	else
		return nil
	end
end)
parseDocstring1 = (function(str3)
	local out17 = ({tag = "list", n = 0})
	local pos7 = 1
	local len8 = len1(str3)
	local r_8931 = nil
	r_8931 = (function()
		if (pos7 <= len8) then
			local spos1 = len8
			local epos1 = nil
			local name19 = nil
			local ptrn1 = nil
			local r_8981 = _23_1(tokens1)
			local r_8961 = nil
			r_8961 = (function(r_8971)
				if (r_8971 <= r_8981) then
					local tok1 = tokens1[r_8971]
					local npos1 = list1(find1(str3, nth1(tok1, 2), pos7))
					local temp98
					local r_9001 = car2(npos1)
					temp98 = r_9001 and (car2(npos1) < spos1)
					if temp98 then
						spos1 = car2(npos1)
						epos1 = nth1(npos1, 2)
						name19 = car2(tok1)
						ptrn1 = nth1(tok1, 2)
					else
					end
					return r_8961((r_8971 + 1))
				else
				end
			end)
			r_8961(1)
			if name19 then
				if (pos7 < spos1) then
					pushCdr_21_1(out17, struct1("tag", "text", "contents", sub1(str3, pos7, pred1(spos1))))
				else
				end
				pushCdr_21_1(out17, struct1("tag", name19, "whole", sub1(str3, spos1, epos1), "contents", match1(sub1(str3, spos1, epos1), ptrn1)))
				pos7 = succ1(epos1)
			else
				pushCdr_21_1(out17, struct1("tag", "text", "contents", sub1(str3, pos7, len8)))
				pos7 = succ1(len8)
			end
			return r_8931()
		else
		end
	end)
	r_8931()
	return out17
end)
Scope1 = require1("tacky.analysis.scope")
formatRange2 = (function(range5)
	return format1("%s:%s", range5["name"], formatPosition1(range5["start"]))
end)
sortVars_21_1 = (function(list5)
	return sort1(list5, (function(a3, b3)
		return (car2(a3) < car2(b3))
	end))
end)
formatDefinition1 = (function(var22)
	local ty8 = type1(var22)
	if (ty8 == "builtin") then
		return "Builtin term"
	elseif (ty8 == "macro") then
		return _2e2e_2("Macro defined at ", formatRange2(getSource1(var22["node"])))
	elseif (ty8 == "native") then
		return _2e2e_2("Native defined at ", formatRange2(getSource1(var22["node"])))
	elseif (ty8 == "defined") then
		return _2e2e_2("Defined at ", formatRange2(getSource1(var22["node"])))
	else
		_error("unmatched item")
	end
end)
formatSignature1 = (function(name20, var23)
	local sig1 = extractSignature1(var23)
	if (sig1 == nil) then
		return name20
	elseif nil_3f_1(sig1) then
		return _2e2e_2("(", name20, ")")
	else
		return _2e2e_2("(", name20, " ", concat1(traverse1(sig1, (function(r_8831)
			return r_8831["contents"]
		end)), " "), ")")
	end
end)
writeDocstring1 = (function(out18, str4, scope2)
	local r_8851 = parseDocstring1(str4)
	local r_8881 = _23_1(r_8851)
	local r_8861 = nil
	r_8861 = (function(r_8871)
		if (r_8871 <= r_8881) then
			local tok2 = r_8851[r_8871]
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
				local name21 = tok2["contents"]
				local ovar1 = Scope1["get"](scope2, name21)
				if ovar1 and ovar1["node"] then
					local loc1 = gsub1(gsub1(getSource1((ovar1["node"]))["name"], "%.lisp$", ""), "/", ".")
					local sig2 = extractSignature1(ovar1)
					append_21_1(out18, format1("[`%s`](%s.md#%s)", name21, loc1, gsub1((function()
						if (sig2 == nil) then
							return ovar1["name"]
						elseif nil_3f_1(sig2) then
							return ovar1["name"]
						else
							return _2e2e_2(name21, " ", concat1(traverse1(sig2, (function(r_9021)
								return r_9021["contents"]
							end)), " "))
						end
					end)()
					, "%A+", "-")))
				else
					append_21_1(out18, format1("`%s`", name21))
				end
			else
				_error("unmatched item")
			end
			return r_8861((r_8871 + 1))
		else
		end
	end)
	r_8861(1)
	return line_21_1(out18)
end)
exported1 = (function(out19, title1, primary1, vars1, scope3)
	local documented1 = ({tag = "list", n = 0})
	local undocumented1 = ({tag = "list", n = 0})
	iterPairs1(vars1, (function(name22, var24)
		return pushCdr_21_1((function()
			if var24["doc"] then
				return documented1
			else
				return undocumented1
			end
		end)()
		, list1(name22, var24))
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
	local r_9111 = _23_1(documented1)
	local r_9091 = nil
	r_9091 = (function(r_9101)
		if (r_9101 <= r_9111) then
			local entry7 = documented1[r_9101]
			local name23 = car2(entry7)
			local var25 = nth1(entry7, 2)
			line_21_1(out19, _2e2e_2("## `", formatSignature1(name23, var25), "`"))
			line_21_1(out19, _2e2e_2("*", formatDefinition1(var25), "*"))
			line_21_1(out19, "", true)
			writeDocstring1(out19, var25["doc"], var25["scope"])
			line_21_1(out19, "", true)
			return r_9091((r_9101 + 1))
		else
		end
	end)
	r_9091(1)
	if nil_3f_1(undocumented1) then
	else
		line_21_1(out19, "## Undocumented symbols")
	end
	local r_9171 = _23_1(undocumented1)
	local r_9151 = nil
	r_9151 = (function(r_9161)
		if (r_9161 <= r_9171) then
			local entry8 = undocumented1[r_9161]
			local name24 = car2(entry8)
			local var26 = nth1(entry8, 2)
			line_21_1(out19, _2e2e_2(" - `", formatSignature1(name24, var26), "` *", formatDefinition1(var26), "*"))
			return r_9151((r_9161 + 1))
		else
		end
	end)
	return r_9151(1)
end)
docs1 = (function(compiler5, args21)
	if nil_3f_1(args21["input"]) then
		putError_21_1(compiler5["log"], "No inputs to generate documentation for.")
		exit_21_1(1)
	else
	end
	local r_9201 = args21["input"]
	local r_9231 = _23_1(r_9201)
	local r_9211 = nil
	r_9211 = (function(r_9221)
		if (r_9221 <= r_9231) then
			local path1 = r_9201[r_9221]
			if (sub1(path1, -5) == ".lisp") then
				path1 = sub1(path1, 1, -6)
			else
			end
			local lib2 = compiler5["libCache"][path1]
			local writer14 = create3()
			exported1(writer14, lib2["name"], lib2["docs"], lib2["scope"]["exported"], lib2["scope"])
			local handle3 = open1(_2e2e_2(args21["docs"], "/", gsub1(path1, "/", "."), ".md"), "w")
			self1(handle3, "write", _2d3e_string1(writer14))
			self1(handle3, "close")
			return r_9211((r_9221 + 1))
		else
		end
	end)
	return r_9211(1)
end)
task1 = struct1("name", "docs", "setup", (function(spec11)
	return addArgument_21_1(spec11, ({tag = "list", n = 1, "--docs"}), "help", "Specify the folder to emit documentation to.", "default", nil, "narg", 1)
end), "pred", (function(args22)
	return (nil ~= args22["docs"])
end), "run", docs1)
config1 = package.config
coloredAnsi1 = (function(col1, msg16)
	return _2e2e_2("\27[", col1, "m", msg16, "\27[0m")
end)
if config1 and (charAt1(config1, 1) ~= "\\") then
	colored_3f_1 = true
elseif getenv1 and (getenv1("ANSICON") ~= nil) then
	colored_3f_1 = true
else
	local temp99
	if getenv1 then
		local term1 = getenv1("TERM")
		if term1 then
			temp99 = find1(term1, "xterm")
		else
			temp99 = nil
		end
	else
		temp99 = getenv1
	end
	if temp99 then
		colored_3f_1 = true
	else
		colored_3f_1 = false
	end
end
if colored_3f_1 then
	colored1 = coloredAnsi1
else
	colored1 = (function(col2, msg17)
		return msg17
	end)
end
create4 = coroutine.create
resume1 = coroutine.resume
status1 = coroutine.status
local discard1 = (function()
end)
void2 = struct1("put-error!", discard1, "put-warning!", discard1, "put-verbose!", discard1, "put-debug!", discard1, "put-time!", discard1, "put-node-error!", discard1, "put-node-warning!", discard1)
hexDigit_3f_1 = (function(char4)
	local r_9371 = between_3f_1(char4, "0", "9")
	if r_9371 then
		return r_9371
	else
		local r_9381 = between_3f_1(char4, "a", "f")
		return r_9381 or between_3f_1(char4, "A", "F")
	end
end)
binDigit_3f_1 = (function(char5)
	local r_9391 = (char5 == "0")
	return r_9391 or (char5 == "1")
end)
terminator_3f_1 = (function(char6)
	local r_9401 = (char6 == "\n")
	if r_9401 then
		return r_9401
	else
		local r_9411 = (char6 == " ")
		if r_9411 then
			return r_9411
		else
			local r_9421 = (char6 == "\9")
			if r_9421 then
				return r_9421
			else
				local r_9431 = (char6 == "(")
				if r_9431 then
					return r_9431
				else
					local r_9441 = (char6 == ")")
					if r_9441 then
						return r_9441
					else
						local r_9451 = (char6 == "[")
						if r_9451 then
							return r_9451
						else
							local r_9461 = (char6 == "]")
							if r_9461 then
								return r_9461
							else
								local r_9471 = (char6 == "{")
								if r_9471 then
									return r_9471
								else
									local r_9481 = (char6 == "}")
									return r_9481 or (char6 == "")
								end
							end
						end
					end
				end
			end
		end
	end
end)
digitError_21_1 = (function(logger10, pos8, name25, char7)
	return doNodeError_21_1(logger10, format1("Expected %s digit, got %s", name25, (function()
		if (char7 == "") then
			return "eof"
		else
			return quoted1(char7)
		end
	end)()
	), pos8, nil, pos8, "Invalid digit here")
end)
lex1 = (function(logger11, str5, name26)
	str5 = gsub1(str5, "\13\n?", "\n")
	local lines7 = split1(str5, "\n")
	local line5 = 1
	local column1 = 1
	local offset6 = 1
	local length1 = len1(str5)
	local out20 = ({tag = "list", n = 0})
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
		return {["line"]=line5,["column"]=column1,["offset"]=offset6}
	end)
	local range6 = (function(start10, finish2)
		return {["start"]=start10,["finish"]=finish2 or start10,["lines"]=lines7,["name"]=name26}
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
	local parseBase1 = (function(name27, p3, base1)
		local start14 = offset6
		local char8 = charAt1(str5, offset6)
		if p3(char8) then
		else
			digitError_21_1(logger11, range6(position1()), name27, char8)
		end
		char8 = charAt1(str5, succ1(offset6))
		local r_9871 = nil
		r_9871 = (function()
			if p3(char8) then
				consume_21_1()
				char8 = charAt1(str5, succ1(offset6))
				return r_9871()
			else
			end
		end)
		r_9871()
		return tonumber1(sub1(str5, start14, offset6), base1)
	end)
	local r_9491 = nil
	r_9491 = (function()
		if (offset6 <= length1) then
			local char9 = charAt1(str5, offset6)
			local temp100
			local r_9501 = (char9 == "\n")
			if r_9501 then
				temp100 = r_9501
			else
				local r_9511 = (char9 == "\9")
				temp100 = r_9511 or (char9 == " ")
			end
			if temp100 then
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
				if (charAt1(str5, succ1(offset6)) == "@") then
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
					char9 = charAt1(str5, offset6)
				else
				end
				local val20
				local temp101
				local r_9671 = (char9 == "0")
				temp101 = r_9671 and (charAt1(str5, succ1(offset6)) == "x")
				if temp101 then
					consume_21_1()
					consume_21_1()
					local res7 = parseBase1("hexadecimal", hexDigit_3f_1, 16)
					if negative1 then
						res7 = (0 - res7)
					else
					end
					val20 = res7
				else
					local temp102
					local r_9681 = (char9 == "0")
					temp102 = r_9681 and (charAt1(str5, succ1(offset6)) == "b")
					if temp102 then
						consume_21_1()
						consume_21_1()
						local res8 = parseBase1("binary", binDigit_3f_1, 2)
						if negative1 then
							res8 = (0 - res8)
						else
						end
						val20 = res8
					else
						local r_9691 = nil
						r_9691 = (function()
							if between_3f_1(charAt1(str5, succ1(offset6)), "0", "9") then
								consume_21_1()
								return r_9691()
							else
							end
						end)
						r_9691()
						if (charAt1(str5, succ1(offset6)) == ".") then
							consume_21_1()
							local r_9701 = nil
							r_9701 = (function()
								if between_3f_1(charAt1(str5, succ1(offset6)), "0", "9") then
									consume_21_1()
									return r_9701()
								else
								end
							end)
							r_9701()
						else
						end
						char9 = charAt1(str5, succ1(offset6))
						local temp103
						local r_9711 = (char9 == "e")
						temp103 = r_9711 or (char9 == "E")
						if temp103 then
							consume_21_1()
							char9 = charAt1(str5, succ1(offset6))
							local temp104
							local r_9721 = (char9 == "-")
							temp104 = r_9721 or (char9 == "+")
							if temp104 then
								consume_21_1()
							else
							end
							local r_9731 = nil
							r_9731 = (function()
								if between_3f_1(charAt1(str5, succ1(offset6)), "0", "9") then
									consume_21_1()
									return r_9731()
								else
								end
							end)
							r_9731()
						else
						end
						val20 = tonumber1(sub1(str5, start16["offset"], offset6))
					end
				end
				appendWith_21_1({["tag"]="number",["value"]=val20}, start16)
				char9 = charAt1(str5, succ1(offset6))
				if terminator_3f_1(char9) then
				else
					consume_21_1()
					doNodeError_21_1(logger11, format1("Expected digit, got %s", (function()
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
				local startCol1 = succ1(column1)
				local buffer4 = ({tag = "list", n = 0})
				consume_21_1()
				char9 = charAt1(str5, offset6)
				local r_9741 = nil
				r_9741 = (function()
					if (char9 ~= "\"") then
						if (column1 == 1) then
							local running3 = true
							local lineOff1 = offset6
							local r_9751 = nil
							r_9751 = (function()
								local temp105
								local r_9761 = running3
								temp105 = r_9761 and (column1 < startCol1)
								if temp105 then
									if (char9 == " ") then
										consume_21_1()
									elseif (char9 == "\n") then
										consume_21_1()
										pushCdr_21_1(buffer4, "\n")
										lineOff1 = offset6
									elseif (char9 == "") then
										running3 = false
									else
										putNodeWarning_21_1(logger11, format1("Expected leading indent, got %q", char9), range6(position1()), "You should try to align multi-line strings at the initial quote\nmark. This helps keep programs neat and tidy.", range6(start17), "String started with indent here", range6(position1()), "Mis-aligned character here")
										pushCdr_21_1(buffer4, sub1(str5, lineOff1, pred1(offset6)))
										running3 = false
									end
									char9 = charAt1(str5, offset6)
									return r_9751()
								else
								end
							end)
							r_9751()
						else
						end
						if (char9 == "") then
							local start18 = range6(start17)
							local finish6 = range6(position1())
							doNodeError_21_1(logger11, "Expected '\"', got eof", finish6, nil, start18, "string started here", finish6, "end of file here")
						elseif (char9 == "\\") then
							consume_21_1()
							char9 = charAt1(str5, offset6)
							if (char9 == "\n") then
							elseif (char9 == "a") then
								pushCdr_21_1(buffer4, "\7")
							elseif (char9 == "b") then
								pushCdr_21_1(buffer4, "\8")
							elseif (char9 == "f") then
								pushCdr_21_1(buffer4, "\12")
							elseif (char9 == "n") then
								pushCdr_21_1(buffer4, "\n")
							elseif (char9 == "r") then
								pushCdr_21_1(buffer4, "\13")
							elseif (char9 == "t") then
								pushCdr_21_1(buffer4, "\9")
							elseif (char9 == "v") then
								pushCdr_21_1(buffer4, "\11")
							elseif (char9 == "\"") then
								pushCdr_21_1(buffer4, "\"")
							elseif (char9 == "\\") then
								pushCdr_21_1(buffer4, "\\")
							else
								local temp106
								local r_9771 = (char9 == "x")
								if r_9771 then
									temp106 = r_9771
								else
									local r_9781 = (char9 == "X")
									temp106 = r_9781 or between_3f_1(char9, "0", "9")
								end
								if temp106 then
									local start19 = position1()
									local val21
									local temp107
									local r_9791 = (char9 == "x")
									temp107 = r_9791 or (char9 == "X")
									if temp107 then
										consume_21_1()
										local start20 = offset6
										if hexDigit_3f_1(charAt1(str5, offset6)) then
										else
											digitError_21_1(logger11, range6(position1()), "hexadecimal", charAt1(str5, offset6))
										end
										if hexDigit_3f_1(charAt1(str5, succ1(offset6))) then
											consume_21_1()
										else
										end
										val21 = tonumber1(sub1(str5, start20, offset6), 16)
									else
										local start21 = position1()
										local ctr1 = 0
										char9 = charAt1(str5, succ1(offset6))
										local r_9801 = nil
										r_9801 = (function()
											local temp108
											local r_9811 = (ctr1 < 2)
											temp108 = r_9811 and between_3f_1(char9, "0", "9")
											if temp108 then
												consume_21_1()
												char9 = charAt1(str5, succ1(offset6))
												ctr1 = (ctr1 + 1)
												return r_9801()
											else
											end
										end)
										r_9801()
										val21 = tonumber1(sub1(str5, start21["offset"], offset6))
									end
									if (val21 >= 256) then
										doNodeError_21_1(logger11, "Invalid escape code", range6(start19()), nil, range6(start19(), position1), _2e2e_2("Must be between 0 and 255, is ", val21))
									else
									end
									pushCdr_21_1(buffer4, char1(val21))
								elseif (char9 == "") then
									doNodeError_21_1(logger11, "Expected escape code, got eof", range6(position1()), nil, range6(position1()), "end of file here")
								else
									doNodeError_21_1(logger11, "Illegal escape character", range6(position1()), nil, range6(position1()), "Unknown escape character")
								end
							end
						else
							pushCdr_21_1(buffer4, char9)
						end
						consume_21_1()
						char9 = charAt1(str5, offset6)
						return r_9741()
					else
					end
				end)
				r_9741()
				appendWith_21_1({["tag"]="string",["value"]=concat1(buffer4)}, start17)
			elseif (char9 == ";") then
				local r_9831 = nil
				r_9831 = (function()
					local temp109
					local r_9841 = (offset6 <= length1)
					temp109 = r_9841 and (charAt1(str5, succ1(offset6)) ~= "\n")
					if temp109 then
						consume_21_1()
						return r_9831()
					else
					end
				end)
				r_9831()
			else
				local start22 = position1()
				local key10 = (char9 == ":")
				char9 = charAt1(str5, succ1(offset6))
				local r_9851 = nil
				r_9851 = (function()
					if _21_1(terminator_3f_1(char9)) then
						consume_21_1()
						char9 = charAt1(str5, succ1(offset6))
						return r_9851()
					else
					end
				end)
				r_9851()
				if key10 then
					appendWith_21_1({["tag"]="key",["value"]=sub1(str5, succ1(start22["offset"]), offset6)}, start22)
				else
					append_21_2("symbol", start22)
				end
			end
			consume_21_1()
			return r_9491()
		else
		end
	end)
	r_9491()
	append_21_2("eof")
	return out20
end)
parse1 = (function(logger12, toks1)
	local head6 = ({tag = "list", n = 0})
	local stack2 = ({tag = "list", n = 0})
	local append_21_3 = (function(node54)
		pushCdr_21_1(head6, node54)
		node54["parent"] = head6
		return nil
	end)
	local push_21_1 = (function()
		local next1 = ({tag = "list", n = 0})
		pushCdr_21_1(stack2, head6)
		append_21_3(next1)
		head6 = next1
		return nil
	end)
	local pop_21_1 = (function()
		head6["open"] = nil
		head6["close"] = nil
		head6["auto-close"] = nil
		head6["last-node"] = nil
		head6 = last1(stack2)
		return popLast_21_1(stack2)
	end)
	local r_9631 = _23_1(toks1)
	local r_9611 = nil
	r_9611 = (function(r_9621)
		if (r_9621 <= r_9631) then
			local tok3 = toks1[r_9621]
			local tag12 = tok3["tag"]
			local autoClose1 = false
			local previous2 = head6["last-node"]
			local tokPos1 = tok3["range"]
			local temp110
			local r_9651 = (tag12 ~= "eof")
			if r_9651 then
				local r_9661 = (tag12 ~= "close")
				if r_9661 then
					if head6["range"] then
						temp110 = (tokPos1["start"]["line"] ~= head6["range"]["start"]["line"])
					else
						temp110 = true
					end
				else
					temp110 = r_9661
				end
			else
				temp110 = r_9651
			end
			if temp110 then
				if previous2 then
					local prevPos1 = previous2["range"]
					if (tokPos1["start"]["line"] ~= prevPos1["start"]["line"]) then
						head6["last-node"] = tok3
						if (tokPos1["start"]["column"] ~= prevPos1["start"]["column"]) then
							putNodeWarning_21_1(logger12, "Different indent compared with previous expressions.", tok3, "You should try to maintain consistent indentation across a program,\ntry to ensure all expressions are lined up.\nIf this looks OK to you, check you're not missing a closing ')'.", prevPos1, "", tokPos1, "")
						else
						end
					else
					end
				else
					head6["last-node"] = tok3
				end
			else
			end
			local temp111
			local r_9941 = (tag12 == "string")
			if r_9941 then
				temp111 = r_9941
			else
				local r_9951 = (tag12 == "number")
				if r_9951 then
					temp111 = r_9951
				else
					local r_9961 = (tag12 == "symbol")
					temp111 = r_9961 or (tag12 == "key")
				end
			end
			if temp111 then
				append_21_3(tok3)
			elseif (tag12 == "open") then
				push_21_1()
				head6["open"] = tok3["contents"]
				head6["close"] = tok3["close"]
				head6["range"] = {["start"]=tok3["range"]["start"],["name"]=tok3["range"]["name"],["lines"]=tok3["range"]["lines"]}
			elseif (tag12 == "close") then
				if nil_3f_1(stack2) then
					doNodeError_21_1(logger12, format1("'%s' without matching '%s'", tok3["contents"], tok3["open"]), tok3, nil, getSource1(tok3), "")
				elseif head6["auto-close"] then
					doNodeError_21_1(logger12, format1("'%s' without matching '%s' inside quote", tok3["contents"], tok3["open"]), tok3, nil, head6["range"], "quote opened here", tok3["range"], "attempting to close here")
				elseif (head6["close"] ~= tok3["contents"]) then
					doNodeError_21_1(logger12, format1("Expected '%s', got '%s'", head6["close"], tok3["contents"]), tok3, nil, head6["range"], format1("block opened with '%s'", head6["open"]), tok3["range"], format1("'%s' used here", tok3["contents"]))
				else
					head6["range"]["finish"] = tok3["range"]["finish"]
					pop_21_1()
				end
			else
				local temp112
				local r_9981 = (tag12 == "quote")
				if r_9981 then
					temp112 = r_9981
				else
					local r_9991 = (tag12 == "unquote")
					if r_9991 then
						temp112 = r_9991
					else
						local r_10001 = (tag12 == "syntax-quote")
						if r_10001 then
							temp112 = r_10001
						else
							local r_10011 = (tag12 == "unquote-splice")
							temp112 = r_10011 or (tag12 == "quasiquote")
						end
					end
				end
				if temp112 then
					push_21_1()
					head6["range"] = {["start"]=tok3["range"]["start"],["name"]=tok3["range"]["name"],["lines"]=tok3["range"]["lines"]}
					append_21_3({["tag"]="symbol",["contents"]=tag12,["range"]=tok3["range"]})
					autoClose1 = true
					head6["auto-close"] = true
				elseif (tag12 == "eof") then
					if (0 ~= _23_1(stack2)) then
						doNodeError_21_1(logger12, "Expected ')', got eof", tok3, nil, head6["range"], "block opened here", tok3["range"], "end of file here")
					else
					end
				else
					error1(_2e2e_2("Unsupported type", tag12))
				end
			end
			if autoClose1 then
			else
				local r_10041 = nil
				r_10041 = (function()
					if head6["auto-close"] then
						if nil_3f_1(stack2) then
							doNodeError_21_1(logger12, format1("'%s' without matching '%s'", tok3["contents"], tok3["open"]), tok3, nil, getSource1(tok3), "")
						else
						end
						head6["range"]["finish"] = tok3["range"]["finish"]
						pop_21_1()
						return r_10041()
					else
					end
				end)
				r_10041()
			end
			return r_9611((r_9621 + 1))
		else
		end
	end)
	r_9611(1)
	return head6
end)
read2 = (function(x38, path2)
	return parse1(void2, lex1(void2, x38, path2 or ""))
end)
compile1 = require1("tacky.compile")["compile"]
Scope2 = require1("tacky.analysis.scope")
doParse1 = (function(compiler6, scope4, str6)
	local logger13 = compiler6["log"]
	return cadr1(list1(compile1(parse1(logger13, (lex1(logger13, str6, "<stdin>"))), compiler6["global"], compiler6["variables"], compiler6["states"], scope4, compiler6["compileState"], compiler6["loader"], logger13, executeStates1)))
end)
local clrs1 = getenv1("URN_COLOURS")
if clrs1 then
	local schemeAlist1 = read2(clrs1)
	replColourScheme1 = schemeAlist1 or nil
else
	replColourScheme1 = nil
end
colourFor1 = (function(elem7)
	if assoc_3f_1(replColourScheme1, string_2d3e_symbol1(elem7)) then
		return constVal1(assoc1(replColourScheme1, string_2d3e_symbol1(elem7)))
	else
		if (elem7 == "text") then
			return 0
		elseif (elem7 == "arg") then
			return 36
		elseif (elem7 == "mono") then
			return 97
		elseif (elem7 == "bold") then
			return 1
		elseif (elem7 == "italic") then
			return 3
		elseif (elem7 == "link") then
			return 94
		else
			return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(elem7), ", but none matched.\n", "  Tried: `\"text\"`\n  Tried: `\"arg\"`\n  Tried: `\"mono\"`\n  Tried: `\"bold\"`\n  Tried: `\"italic\"`\n  Tried: `\"link\"`"))
		end
	end
end)
printDocs_21_1 = (function(str7)
	local docs2 = parseDocstring1(str7)
	local r_9301 = _23_1(docs2)
	local r_9281 = nil
	r_9281 = (function(r_9291)
		if (r_9291 <= r_9301) then
			local tok4 = docs2[r_9291]
			local tag13 = tok4["tag"]
			if (tag13 == "bolic") then
				write1(colored1(colourFor1("bold"), colored1(colourFor1("italic"), tok4["contents"])))
			else
				write1(colored1(colourFor1(tag13), tok4["contents"]))
			end
			return r_9281((r_9291 + 1))
		else
		end
	end)
	r_9281(1)
	return print1()
end)
execCommand1 = (function(compiler7, scope5, args23)
	local logger14 = compiler7["log"]
	local command1 = car2(args23)
	local temp113
	local r_10061 = (command1 == "help")
	temp113 = r_10061 or (command1 == "h")
	if temp113 then
		return print1("REPL commands:\n[:d]oc NAME        Get documentation about a symbol\n:scope             Print out all variables in the scope\n[:s]earch QUERY    Search the current scope for symbols and documentation containing a string.\n:module NAME       Display a loaded module's docs and definitions.")
	else
		local temp114
		local r_10071 = (command1 == "doc")
		temp114 = r_10071 or (command1 == "d")
		if temp114 then
			local name28 = nth1(args23, 2)
			if name28 then
				local var27 = Scope2["get"](scope5, name28)
				if (var27 == nil) then
					return putError_21_1(logger14, _2e2e_2("Cannot find '", name28, "'"))
				elseif _21_1(var27["doc"]) then
					return putError_21_1(logger14, _2e2e_2("No documentation for '", name28, "'"))
				else
					local sig3 = extractSignature1(var27)
					local name29 = var27["fullName"]
					if sig3 then
						local buffer5 = list1(name29)
						local r_10121 = _23_1(sig3)
						local r_10101 = nil
						r_10101 = (function(r_10111)
							if (r_10111 <= r_10121) then
								pushCdr_21_1(buffer5, sig3[r_10111]["contents"])
								return r_10101((r_10111 + 1))
							else
							end
						end)
						r_10101(1)
						name29 = _2e2e_2("(", concat1(buffer5, " "), ")")
					else
					end
					print1(colored1(96, name29))
					return printDocs_21_1(var27["doc"])
				end
			else
				return putError_21_1(logger14, ":doc <variable>")
			end
		elseif (command1 == "module") then
			local name30 = nth1(args23, 2)
			if name30 then
				local mod1 = compiler7["libNames"][name30]
				if (mod1 == nil) then
					return putError_21_1(logger14, _2e2e_2("Cannot find '", name30, "'"))
				else
					print1(colored1(96, mod1["name"]))
					if mod1["docs"] then
						printDocs_21_1(mod1["docs"])
						print1()
					else
					end
					print1(colored1(92, "Exported symbols"))
					local vars2 = ({tag = "list", n = 0})
					iterPairs1(mod1["scope"]["exported"], (function(name31)
						return pushCdr_21_1(vars2, name31)
					end))
					sort1(vars2)
					return print1(concat1(vars2, "  "))
				end
			else
				return putError_21_1(logger14, ":module <variable>")
			end
		elseif (command1 == "scope") then
			local vars3 = ({tag = "list", n = 0})
			local varsSet1 = ({})
			local current1 = scope5
			local r_10141 = nil
			r_10141 = (function()
				if current1 then
					iterPairs1(current1["variables"], (function(name32, var28)
						if varsSet1[name32] then
						else
							pushCdr_21_1(vars3, name32)
							varsSet1[name32] = true
							return nil
						end
					end))
					current1 = current1["parent"]
					return r_10141()
				else
				end
			end)
			r_10141()
			sort1(vars3)
			return print1(concat1(vars3, "  "))
		else
			local temp115
			local r_10151 = (command1 == "search")
			temp115 = r_10151 or (command1 == "s")
			if temp115 then
				if (_23_1(args23) > 1) then
					local keywords2 = map1(lower1, cdr2(args23))
					local nameResults1 = ({tag = "list", n = 0})
					local docsResults1 = ({tag = "list", n = 0})
					local vars4 = ({tag = "list", n = 0})
					local varsSet2 = ({})
					local current2 = scope5
					local r_10161 = nil
					r_10161 = (function()
						if current2 then
							iterPairs1(current2["variables"], (function(name33, var29)
								if varsSet2[name33] then
								else
									pushCdr_21_1(vars4, name33)
									varsSet2[name33] = true
									return nil
								end
							end))
							current2 = current2["parent"]
							return r_10161()
						else
						end
					end)
					r_10161()
					local r_10211 = _23_1(vars4)
					local r_10191 = nil
					r_10191 = (function(r_10201)
						if (r_10201 <= r_10211) then
							local var30 = vars4[r_10201]
							local r_10271 = _23_1(keywords2)
							local r_10251 = nil
							r_10251 = (function(r_10261)
								if (r_10261 <= r_10271) then
									local keyword1 = keywords2[r_10261]
									if find1(var30, keyword1) then
										pushCdr_21_1(nameResults1, var30)
									else
									end
									return r_10251((r_10261 + 1))
								else
								end
							end)
							r_10251(1)
							local docVar1 = Scope2["get"](scope5, var30)
							if docVar1 then
								local tempDocs1 = docVar1["doc"]
								if tempDocs1 then
									local docs3 = lower1(tempDocs1)
									if docs3 then
										local keywordsFound1 = 0
										if keywordsFound1 then
											local r_10331 = _23_1(keywords2)
											local r_10311 = nil
											r_10311 = (function(r_10321)
												if (r_10321 <= r_10331) then
													local keyword2 = keywords2[r_10321]
													if find1(docs3, keyword2) then
														keywordsFound1 = (keywordsFound1 + 1)
													else
													end
													return r_10311((r_10321 + 1))
												else
												end
											end)
											r_10311(1)
											if eq_3f_1(keywordsFound1, _23_1(keywords2)) then
												pushCdr_21_1(docsResults1, var30)
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
							return r_10191((r_10201 + 1))
						else
						end
					end)
					r_10191(1)
					local temp116
					local r_10351 = nil_3f_1(nameResults1)
					temp116 = r_10351 and nil_3f_1(docsResults1)
					if temp116 then
						return putError_21_1(logger14, "No results")
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
					return putError_21_1(logger14, ":search <keywords>")
				end
			else
				return putError_21_1(logger14, _2e2e_2("Unknown command '", command1, "'"))
			end
		end
	end
end)
execString1 = (function(compiler8, scope6, string1)
	local state34 = doParse1(compiler8, scope6, string1)
	if (_23_1(state34) > 0) then
		local current3 = 0
		local exec1 = create4((function()
			local r_10401 = _23_1(state34)
			local r_10381 = nil
			r_10381 = (function(r_10391)
				if (r_10391 <= r_10401) then
					local elem8 = state34[r_10391]
					current3 = elem8
					self1(current3, "get")
					return r_10381((r_10391 + 1))
				else
				end
			end)
			return r_10381(1)
		end))
		local compileState1 = compiler8["compileState"]
		local rootScope1 = compiler8["rootScope"]
		local global2 = compiler8["global"]
		local logger15 = compiler8["log"]
		local run1 = true
		local r_9321 = nil
		r_9321 = (function()
			if run1 then
				local res9 = list1(resume1(exec1))
				if _21_1(car2(res9)) then
					putError_21_1(logger15, cadr1(res9))
					run1 = false
				elseif (status1(exec1) == "dead") then
					local lvl1 = self1(last1(state34), "get")
					print1(_2e2e_2("out = ", colored1(96, pretty1(lvl1))))
					global2[escapeVar1(Scope2["add"](scope6, "out", "defined", lvl1), compileState1)] = lvl1
					run1 = false
				else
					executeStates1(compileState1, cadr1(res9)["states"], global2, logger15)
				end
				return r_9321()
			else
			end
		end)
		return r_9321()
	else
	end
end)
repl1 = (function(compiler9)
	local scope7 = compiler9["rootScope"]
	local logger16 = compiler9["log"]
	local buffer6 = ({tag = "list", n = 0})
	local running4 = true
	local r_9331 = nil
	r_9331 = (function()
		if running4 then
			write1(colored1(92, (function()
				if nil_3f_1(buffer6) then
					return "> "
				else
					return ". "
				end
			end)()
			))
			flush1()
			local line6 = read1("*l")
			local temp117
			local r_10421 = _21_1(line6)
			temp117 = r_10421 and nil_3f_1(buffer6)
			if temp117 then
				running4 = false
			elseif line6 and (charAt1(line6, len1(line6)) == "\\") then
				pushCdr_21_1(buffer6, _2e2e_2(sub1(line6, 1, pred1(len1(line6))), "\n"))
			else
				local temp118
				if line6 then
					local r_10451 = (_23_1(buffer6) > 0)
					temp118 = r_10451 and (len1(line6) > 0)
				else
					temp118 = line6
				end
				if temp118 then
					pushCdr_21_1(buffer6, _2e2e_2(line6, "\n"))
				else
					local data6 = _2e2e_2(concat1(buffer6), line6 or "")
					buffer6 = ({tag = "list", n = 0})
					if (charAt1(data6, 1) == ":") then
						execCommand1(compiler9, scope7, split1(sub1(data6, 2), " "))
					else
						scope7 = Scope2["child"](scope7)
						scope7["isRoot"] = true
						local res10 = list1(pcall1(execString1, compiler9, scope7, data6))
						if car2(res10) then
						else
							putError_21_1(logger16, cadr1(res10))
						end
					end
				end
			end
			return r_9331()
		else
		end
	end)
	return r_9331()
end)
exec2 = (function(compiler10)
	local data7 = read1("*a")
	local scope8 = compiler10["rootScope"]
	local logger17 = compiler10["log"]
	local res11 = list1(pcall1(execString1, compiler10, scope8, data7))
	if car2(res11) then
	else
		putError_21_1(logger17, cadr1(res11))
	end
	return exit1(0)
end)
replTask1 = struct1("name", "repl", "setup", (function(spec12)
	return addArgument_21_1(spec12, ({tag = "list", n = 1, "--repl"}), "help", "Start an interactive session.")
end), "pred", (function(args24)
	return args24["repl"]
end), "run", repl1)
execTask1 = struct1("name", "exec", "setup", (function(spec13)
	return addArgument_21_1(spec13, ({tag = "list", n = 1, "--exec"}), "help", "Execute a program without compiling it.")
end), "pred", (function(args25)
	return args25["exec"]
end), "run", exec2)
profileCalls1 = (function(fn3, mappings3)
	local stats1 = ({})
	local callStack1 = ({tag = "list", n = 0})
	sethook1((function(action2)
		local info1 = getinfo1(2, "Sn")
		local start23 = clock1()
		if (action2 == "call") then
			local previous3 = nth1(callStack1, _23_1(callStack1))
			if previous3 then
				previous3["sum"] = (previous3["sum"] + (start23 - previous3["innerStart"]))
			else
			end
		else
		end
		if (action2 ~= "call") then
			if nil_3f_1(callStack1) then
			else
				local current4 = popLast_21_1(callStack1)
				local hash1 = (current4["source"] .. current4["linedefined"])
				local entry9 = stats1[hash1]
				if entry9 then
				else
					entry9 = {["source"]=current4["source"],["short-src"]=current4["short_src"],["line"]=current4["linedefined"],["name"]=current4["name"],["calls"]=0,["totalTime"]=0,["innerTime"]=0}
					stats1[hash1] = entry9
				end
				entry9["calls"] = (1 + entry9["calls"])
				entry9["totalTime"] = (entry9["totalTime"] + (start23 - current4["totalStart"]))
				entry9["innerTime"] = (entry9["innerTime"] + (current4["sum"] + (start23 - current4["innerStart"])))
			end
		else
		end
		if (action2 ~= "return") then
			info1["totalStart"] = start23
			info1["innerStart"] = start23
			info1["sum"] = 0
			pushCdr_21_1(callStack1, info1)
		else
		end
		if (action2 == "return") then
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
	local r_10611 = _23_1(out21)
	local r_10591 = nil
	r_10591 = (function(r_10601)
		if (r_10601 <= r_10611) then
			local entry10 = out21[r_10601]
			print1(format1("| %20s | %-60s | %8.5f | %8.5f | %7d | ", (function()
				if entry10["name"] then
					return unmangleIdent1(entry10["name"])
				else
					return "<unknown>"
				end
			end)()
			, remapMessage1(mappings3, _2e2e_2(entry10["short-src"], ":", entry10["line"])), entry10["totalTime"], entry10["innerTime"], entry10["calls"]))
			return r_10591((r_10601 + 1))
		else
		end
	end)
	r_10591(1)
	return stats1
end)
buildStack1 = (function(parent1, stack3, i10, history1, fold1)
	parent1["n"] = (parent1["n"] + 1)
	if (i10 >= 1) then
		local elem9 = nth1(stack3, i10)
		local hash2 = _2e2e_2(elem9["source"], "|", elem9["linedefined"])
		local previous4 = fold1 and history1[hash2]
		local child2 = parent1[hash2]
		if previous4 then
			parent1["n"] = (parent1["n"] - 1)
			child2 = previous4
		else
		end
		if child2 then
		else
			child2 = elem9
			elem9["n"] = 0
			parent1[hash2] = child2
		end
		if previous4 then
		else
			history1[hash2] = child2
		end
		buildStack1(child2, stack3, (i10 - 1), history1, fold1)
		if previous4 then
		else
			history1[hash2] = nil
			return nil
		end
	else
	end
end)
buildRevStack1 = (function(parent2, stack4, i11, history2, fold2)
	parent2["n"] = (parent2["n"] + 1)
	if (i11 <= _23_1(stack4)) then
		local elem10 = nth1(stack4, i11)
		local hash3 = _2e2e_2(elem10["source"], "|", elem10["linedefined"])
		local previous5 = fold2 and history2[hash3]
		local child3 = parent2[hash3]
		if previous5 then
			parent2["n"] = (parent2["n"] - 1)
			child3 = previous5
		else
		end
		if child3 then
		else
			child3 = elem10
			elem10["n"] = 0
			parent2[hash3] = child3
		end
		if previous5 then
		else
			history2[hash3] = child3
		end
		buildRevStack1(child3, stack4, (i11 + 1), history2, fold2)
		if previous5 then
		else
			history2[hash3] = nil
			return nil
		end
	else
	end
end)
finishStack1 = (function(element1)
	local children1 = ({tag = "list", n = 0})
	iterPairs1(element1, (function(k3, child4)
		if table_3f_1(child4) then
			return pushCdr_21_1(children1, child4)
		else
		end
	end))
	sort1(children1, (function(a5, b5)
		return (a5["n"] > b5["n"])
	end))
	element1["children"] = children1
	local r_10671 = _23_1(children1)
	local r_10651 = nil
	r_10651 = (function(r_10661)
		if (r_10661 <= r_10671) then
			finishStack1((children1[r_10661]))
			return r_10651((r_10661 + 1))
		else
		end
	end)
	return r_10651(1)
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
	local temp119
	if remaining2 then
		temp119 = (remaining2 >= 1)
	else
		temp119 = true
	end
	if temp119 then
		indent_21_1(out22)
		local r_10701 = stack5["children"]
		local r_10731 = _23_1(r_10701)
		local r_10711 = nil
		r_10711 = (function(r_10721)
			if (r_10721 <= r_10731) then
				showStack_21_1(out22, mappings4, total1, r_10701[r_10721], remaining2 and pred1(remaining2))
				return r_10711((r_10721 + 1))
			else
			end
		end)
		r_10711(1)
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
	local temp120
	if remaining3 then
		temp120 = (remaining3 >= 1)
	else
		temp120 = true
	end
	if temp120 then
		local whole1 = _2e2e_2(before1, renamed1, ";")
		local r_10501 = stack6["children"]
		local r_10531 = _23_1(r_10501)
		local r_10511 = nil
		r_10511 = (function(r_10521)
			if (r_10521 <= r_10531) then
				showFlame_21_1(mappings5, r_10501[r_10521], whole1, remaining3 and pred1(remaining3))
				return r_10511((r_10521 + 1))
			else
			end
		end)
		return r_10511(1)
	else
	end
end)
profileStack1 = (function(fn4, mappings6, args26)
	local stacks1 = ({tag = "list", n = 0})
	local top1 = getinfo1(2, "S")
	sethook1((function(action3)
		local pos9 = 3
		local stack7 = ({tag = "list", n = 0})
		local info2 = getinfo1(2, "Sn")
		local r_10761 = nil
		r_10761 = (function()
			if info2 then
				local temp121
				local r_10771 = (info2["source"] == top1["source"])
				temp121 = r_10771 and (info2["linedefined"] == top1["linedefined"])
				if temp121 then
					info2 = nil
				else
					pushCdr_21_1(stack7, info2)
					pos9 = (pos9 + 1)
					info2 = getinfo1(pos9, "Sn")
				end
				return r_10761()
			else
			end
		end)
		r_10761()
		return pushCdr_21_1(stacks1, stack7)
	end), "", 100000.0)
	fn4()
	sethook1()
	local folded1 = {["n"]=0,["name"]="<root>"}
	local r_11051 = _23_1(stacks1)
	local r_11031 = nil
	r_11031 = (function(r_11041)
		if (r_11041 <= r_11051) then
			local stack8 = stacks1[r_11041]
			if (args26["stack-kind"] == "reverse") then
				buildRevStack1(folded1, stack8, 1, ({}), args26["stack-fold"])
			else
				buildStack1(folded1, stack8, _23_1(stack8), ({}), args26["stack-fold"])
			end
			return r_11031((r_11041 + 1))
		else
		end
	end)
	r_11031(1)
	finishStack1(folded1)
	if (args26["stack-show"] == "flame") then
		return showFlame_21_1(mappings6, folded1, "", (function(r_11071)
			return r_11071 or 30
		end)(args26["stack-limit"]))
	else
		local writer15 = create3()
		showStack_21_1(writer15, mappings6, _23_1(stacks1), folded1, (function(r_11081)
			return r_11081 or 10
		end)(args26["stack-limit"]))
		return print1(_2d3e_string1(writer15))
	end
end)
runLua1 = (function(compiler11, args27)
	if nil_3f_1(args27["input"]) then
		putError_21_1(compiler11["log"], "No inputs to run.")
		exit_21_1(1)
	else
	end
	local out23 = file3(compiler11, false)
	local lines8 = generateMappings1(out23["lines"])
	local logger18 = compiler11["log"]
	local name34 = _2e2e_2((function(r_10991)
		return r_10991 or "out"
	end)(args27["output"]), ".lua")
	local r_10781 = list1(load1(_2d3e_string1(out23), _2e2e_2("=", name34)))
	local temp122
	local r_10811 = list_3f_1(r_10781)
	if r_10811 then
		local r_10821 = (_23_1(r_10781) >= 2)
		if r_10821 then
			local r_10831 = (_23_1(r_10781) <= 2)
			if r_10831 then
				local r_10841 = eq_3f_1(nth1(r_10781, 1), nil)
				temp122 = r_10841 and true
			else
				temp122 = r_10831
			end
		else
			temp122 = r_10821
		end
	else
		temp122 = r_10811
	end
	if temp122 then
		local msg18 = nth1(r_10781, 2)
		putError_21_1(logger18, "Cannot load compiled source.")
		print1(msg18)
		print1(_2d3e_string1(out23))
		return exit_21_1(1)
	else
		local temp123
		local r_10851 = list_3f_1(r_10781)
		if r_10851 then
			local r_10861 = (_23_1(r_10781) >= 1)
			if r_10861 then
				local r_10871 = (_23_1(r_10781) <= 1)
				temp123 = r_10871 and true
			else
				temp123 = r_10861
			end
		else
			temp123 = r_10851
		end
		if temp123 then
			local fun3 = nth1(r_10781, 1)
			_5f_G1["arg"] = args27["script-args"]
			_5f_G1["arg"][0] = car2(args27["input"])
			local exec3 = (function()
				local r_10891 = list1(xpcall1(fun3, traceback1))
				local temp124
				local r_10921 = list_3f_1(r_10891)
				if r_10921 then
					local r_10931 = (_23_1(r_10891) >= 1)
					if r_10931 then
						local r_10941 = eq_3f_1(nth1(r_10891, 1), true)
						temp124 = r_10941 and true
					else
						temp124 = r_10931
					end
				else
					temp124 = r_10921
				end
				if temp124 then
					local res12 = slice1(r_10891, 2)
				else
					local temp125
					local r_10951 = list_3f_1(r_10891)
					if r_10951 then
						local r_10961 = (_23_1(r_10891) >= 2)
						if r_10961 then
							local r_10971 = (_23_1(r_10891) <= 2)
							if r_10971 then
								local r_10981 = eq_3f_1(nth1(r_10891, 1), false)
								temp125 = r_10981 and true
							else
								temp125 = r_10971
							end
						else
							temp125 = r_10961
						end
					else
						temp125 = r_10951
					end
					if temp125 then
						local msg19 = nth1(r_10891, 2)
						putError_21_1(logger18, "Execution failed.")
						print1(remapTraceback1(struct1(name34, lines8), msg19))
						return exit_21_1(1)
					else
						return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_10891), ", but none matched.\n", "  Tried: `(true . ?res)`\n  Tried: `(false ?msg)`"))
					end
				end
			end)
			local r_10881 = args27["profile"]
			if (r_10881 == "none") then
				return exec3()
			elseif eq_3f_1(r_10881, nil) then
				return exec3()
			elseif (r_10881 == "call") then
				return profileCalls1(exec3, struct1(name34, lines8))
			elseif (r_10881 == "stack") then
				return profileStack1(exec3, struct1(name34, lines8), args27)
			else
				putError_21_1(logger18, _2e2e_2("Unknown profiler '", r_10881, "'"))
				return exit_21_1(1)
			end
		else
			return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_10781), ", but none matched.\n", "  Tried: `(nil ?msg)`\n  Tried: `(?fun)`"))
		end
	end
end)
task2 = struct1("name", "run", "setup", (function(spec14)
	addArgument_21_1(spec14, ({tag = "list", n = 2, "--run", "-r"}), "help", "Run the compiled code.")
	addArgument_21_1(spec14, ({tag = "list", n = 2, "--profile", "-p"}), "help", "Run the compiled code with the profiler.", "var", "none|call|stack", "default", nil, "value", "stack", "narg", "?")
	addArgument_21_1(spec14, ({tag = "list", n = 1, "--stack-kind"}), "help", "The kind of stack to emit when using the stack profiler. A reverse stack shows callers of that method instead.", "var", "forward|reverse", "default", "forward", "narg", 1)
	addArgument_21_1(spec14, ({tag = "list", n = 1, "--stack-show"}), "help", "The method to use to display the profiling results.", "var", "flame|term", "default", "term", "narg", 1)
	addArgument_21_1(spec14, ({tag = "list", n = 1, "--stack-limit"}), "help", "The maximum number of call frames to emit.", "var", "LIMIT", "default", nil, "action", setNumAction1, "narg", 1)
	addArgument_21_1(spec14, ({tag = "list", n = 1, "--stack-fold"}), "help", "Whether to fold recursive functions into themselves. This hopefully makes deep graphs easier to understand, but may result in less accurate graphs.", "value", true, "default", false)
	return addArgument_21_1(spec14, ({tag = "list", n = 1, "--"}), "name", "script-args", "help", "Arguments to pass to the compiled script.", "var", "ARG", "all", true, "default", ({tag = "list", n = 0}), "action", addAction1, "narg", "*")
end), "pred", (function(args28)
	local r_11001 = args28["run"]
	return r_11001 or args28["profile"]
end), "run", runLua1)
genNative1 = (function(compiler12, args29)
	if (_23_1(args29["input"]) ~= 1) then
		putError_21_1(compiler12["log"], "Expected just one input")
		exit_21_1(1)
	else
	end
	local prefix2 = args29["gen-native"]
	local qualifier1
	if string_3f_1(prefix2) then
		qualifier1 = _2e2e_2(prefix2, ".")
	else
		qualifier1 = ""
	end
	local lib3 = compiler12["libCache"][gsub1(last1(args29["input"]), "%.lisp$", "")]
	local maxName1 = 0
	local maxQuot1 = 0
	local maxPref1 = 0
	local natives1 = ({tag = "list", n = 0})
	local r_11111 = lib3["out"]
	local r_11141 = _23_1(r_11111)
	local r_11121 = nil
	r_11121 = (function(r_11131)
		if (r_11131 <= r_11141) then
			local node55 = r_11111[r_11131]
			local temp126
			local r_11161 = list_3f_1(node55)
			if r_11161 then
				local r_11171 = symbol_3f_1(car2(node55))
				temp126 = r_11171 and (car2(node55)["contents"] == "define-native")
			else
				temp126 = r_11161
			end
			if temp126 then
				local name35 = nth1(node55, 2)["contents"]
				pushCdr_21_1(natives1, name35)
				maxName1 = max2(maxName1, len1(quoted1(name35)))
				maxQuot1 = max2(maxQuot1, len1(quoted1(_2e2e_2(qualifier1, name35))))
				maxPref1 = max2(maxPref1, len1(_2e2e_2(qualifier1, name35)))
			else
			end
			return r_11121((r_11131 + 1))
		else
		end
	end)
	r_11121(1)
	sort1(natives1)
	local handle4 = open1(_2e2e_2(lib3["path"], ".meta.lua"), "w")
	local format3 = _2e2e_2("\9[%-", tostring1((maxName1 + 3)), "s { tag = \"var\", contents = %-", tostring1((maxQuot1 + 1)), "s value = %-", tostring1((maxPref1 + 1)), "s },\n")
	if handle4 then
	else
		putError_21_1(compiler12["log"], _2e2e_2("Cannot write to ", lib3["path"], ".meta.lua"))
		exit_21_1(1)
	end
	if string_3f_1(prefix2) then
		self1(handle4, "write", format1("local %s = %s or {}\n", prefix2, prefix2))
	else
	end
	self1(handle4, "write", "return {\n")
	local r_11221 = _23_1(natives1)
	local r_11201 = nil
	r_11201 = (function(r_11211)
		if (r_11211 <= r_11221) then
			local native2 = natives1[r_11211]
			self1(handle4, "write", format1(format3, _2e2e_2(quoted1(native2), "] ="), _2e2e_2(quoted1(_2e2e_2(qualifier1, native2)), ","), _2e2e_2(qualifier1, native2, ",")))
			return r_11201((r_11211 + 1))
		else
		end
	end)
	r_11201(1)
	self1(handle4, "write", "}\n")
	return self1(handle4, "close")
end)
task3 = struct1("name", "gen-native", "setup", (function(spec15)
	return addArgument_21_1(spec15, ({tag = "list", n = 1, "--gen-native"}), "help", "Generate native bindings for a file", "var", "PREFIX", "narg", "?")
end), "pred", (function(args30)
	return args30["gen-native"]
end), "run", genNative1)
scope_2f_child2 = require1("tacky.analysis.scope")["child"]
compile2 = require1("tacky.compile")["compile"]
simplifyPath1 = (function(path3, paths1)
	local current5 = path3
	local r_11281 = _23_1(paths1)
	local r_11261 = nil
	r_11261 = (function(r_11271)
		if (r_11271 <= r_11281) then
			local search1 = paths1[r_11271]
			local sub7 = match1(path3, _2e2e_2("^", gsub1(search1, "%?", "(.*)"), "$"))
			if sub7 and (len1(sub7) < len1(current5)) then
				current5 = sub7
			else
			end
			return r_11261((r_11271 + 1))
		else
		end
	end)
	r_11261(1)
	return current5
end)
readMeta1 = (function(state35, name36, entry11)
	local temp127
	local r_11311
	local r_11321 = (entry11["tag"] == "expr")
	r_11311 = r_11321 or (entry11["tag"] == "stmt")
	temp127 = r_11311 and string_3f_1(entry11["contents"])
	if temp127 then
		local buffer7 = ({tag = "list", n = 0})
		local str8 = entry11["contents"]
		local idx6 = 0
		local len9 = len1(str8)
		local r_11331 = nil
		r_11331 = (function()
			if (idx6 <= len9) then
				local r_11341 = list1(find1(str8, "%${(%d+)}", idx6))
				local temp128
				local r_11361 = list_3f_1(r_11341)
				if r_11361 then
					local r_11371 = (_23_1(r_11341) >= 2)
					temp128 = r_11371 and true
				else
					temp128 = r_11361
				end
				if temp128 then
					local start24 = nth1(r_11341, 1)
					local finish7 = nth1(r_11341, 2)
					if (start24 > idx6) then
						pushCdr_21_1(buffer7, sub1(str8, idx6, pred1(start24)))
					else
					end
					pushCdr_21_1(buffer7, tonumber1(sub1(str8, (start24 + 2), (finish7 - 1))))
					idx6 = succ1(finish7)
				else
					pushCdr_21_1(buffer7, sub1(str8, idx6, len9))
					idx6 = succ1(len9)
				end
				return r_11331()
			else
			end
		end)
		r_11331()
		entry11["contents"] = buffer7
	else
	end
	if (entry11["value"] == nil) then
		entry11["value"] = state35["libEnv"][name36]
	elseif (state35["libEnv"][name36] ~= nil) then
		fail_21_1(_2e2e_2("Duplicate value for ", name36, ": in native and meta file"))
	else
		state35["libEnv"][name36] = entry11["value"]
	end
	state35["libMeta"][name36] = entry11
	return entry11
end)
readLibrary1 = (function(state36, name37, path4, lispHandle1)
	putVerbose_21_1(state36["log"], _2e2e_2("Loading ", path4, " into ", name37))
	local prefix3 = _2e2e_2(name37, "-", _23_1(state36["libs"]), "/")
	local lib4 = struct1("name", name37, "prefix", prefix3, "path", path4)
	local contents2 = self1(lispHandle1, "read", "*a")
	self1(lispHandle1, "close")
	local handle5 = open1(_2e2e_2(path4, ".lua"), "r")
	if handle5 then
		local contents3 = self1(handle5, "read", "*a")
		self1(handle5, "close")
		lib4["native"] = contents3
		local r_11411 = list1(load1(contents3, _2e2e_2("@", name37)))
		local temp129
		local r_11441 = list_3f_1(r_11411)
		if r_11441 then
			local r_11451 = (_23_1(r_11411) >= 2)
			if r_11451 then
				local r_11461 = (_23_1(r_11411) <= 2)
				if r_11461 then
					local r_11471 = eq_3f_1(nth1(r_11411, 1), nil)
					temp129 = r_11471 and true
				else
					temp129 = r_11461
				end
			else
				temp129 = r_11451
			end
		else
			temp129 = r_11441
		end
		if temp129 then
			fail_21_1((nth1(r_11411, 2)))
		else
			local temp130
			local r_11481 = list_3f_1(r_11411)
			if r_11481 then
				local r_11491 = (_23_1(r_11411) >= 1)
				if r_11491 then
					local r_11501 = (_23_1(r_11411) <= 1)
					temp130 = r_11501 and true
				else
					temp130 = r_11491
				end
			else
				temp130 = r_11481
			end
			if temp130 then
				local fun4 = nth1(r_11411, 1)
				local res13 = fun4()
				if table_3f_1(res13) then
					iterPairs1(res13, (function(k4, v5)
						state36["libEnv"][_2e2e_2(prefix3, k4)] = v5
						return nil
					end))
				else
					fail_21_1(_2e2e_2(path4, ".lua returned a non-table value"))
				end
			else
				error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_11411), ", but none matched.\n", "  Tried: `(nil ?msg)`\n  Tried: `(?fun)`"))
			end
		end
	else
	end
	local handle6 = open1(_2e2e_2(path4, ".meta.lua"), "r")
	if handle6 then
		local contents4 = self1(handle6, "read", "*a")
		self1(handle6, "close")
		local r_11511 = list1(load1(contents4, _2e2e_2("@", name37)))
		local temp131
		local r_11541 = list_3f_1(r_11511)
		if r_11541 then
			local r_11551 = (_23_1(r_11511) >= 2)
			if r_11551 then
				local r_11561 = (_23_1(r_11511) <= 2)
				if r_11561 then
					local r_11571 = eq_3f_1(nth1(r_11511, 1), nil)
					temp131 = r_11571 and true
				else
					temp131 = r_11561
				end
			else
				temp131 = r_11551
			end
		else
			temp131 = r_11541
		end
		if temp131 then
			fail_21_1((nth1(r_11511, 2)))
		else
			local temp132
			local r_11581 = list_3f_1(r_11511)
			if r_11581 then
				local r_11591 = (_23_1(r_11511) >= 1)
				if r_11591 then
					local r_11601 = (_23_1(r_11511) <= 1)
					temp132 = r_11601 and true
				else
					temp132 = r_11591
				end
			else
				temp132 = r_11581
			end
			if temp132 then
				local fun5 = nth1(r_11511, 1)
				local res14 = fun5()
				if table_3f_1(res14) then
					iterPairs1(res14, (function(k5, v6)
						return readMeta1(state36, _2e2e_2(prefix3, k5), v6)
					end))
				else
					fail_21_1(_2e2e_2(path4, ".meta.lua returned a non-table value"))
				end
			else
				error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_11511), ", but none matched.\n", "  Tried: `(nil ?msg)`\n  Tried: `(?fun)`"))
			end
		end
	else
	end
	startTimer_21_1(state36["timer"], _2e2e_2("[parse] ", path4), 2)
	local lexed1 = lex1(state36["log"], contents2, _2e2e_2(path4, ".lisp"))
	local parsed1 = parse1(state36["log"], lexed1)
	local scope9 = scope_2f_child2(state36["rootScope"])
	scope9["isRoot"] = true
	scope9["prefix"] = prefix3
	lib4["scope"] = scope9
	stopTimer_21_1(state36["timer"], _2e2e_2("[parse] ", path4))
	local compiled1 = compile2(parsed1, state36["global"], state36["variables"], state36["states"], scope9, state36["compileState"], state36["loader"], state36["log"], executeStates1, state36["timer"], path4)
	pushCdr_21_1(state36["libs"], lib4)
	if string_3f_1(car2(compiled1)) then
		lib4["docs"] = constVal1(car2(compiled1))
		removeNth_21_1(compiled1, 1)
	else
	end
	lib4["out"] = compiled1
	local r_11651 = _23_1(compiled1)
	local r_11631 = nil
	r_11631 = (function(r_11641)
		if (r_11641 <= r_11651) then
			local node56 = compiled1[r_11641]
			pushCdr_21_1(state36["out"], node56)
			return r_11631((r_11641 + 1))
		else
		end
	end)
	r_11631(1)
	putVerbose_21_1(state36["log"], _2e2e_2("Loaded ", path4, " into ", name37))
	return lib4
end)
pathLocator1 = (function(state37, name38)
	local searched1
	local paths2
	local searcher1
	searched1 = ({tag = "list", n = 0})
	paths2 = state37["paths"]
	searcher1 = (function(i12)
		if (i12 > _23_1(paths2)) then
			return list1(nil, _2e2e_2("Cannot find ", quoted1(name38), ".\nLooked in ", concat1(searched1, ", ")))
		else
			local path5 = gsub1(nth1(paths2, i12), "%?", name38)
			local cached1 = state37["libCache"][path5]
			pushCdr_21_1(searched1, path5)
			if (cached1 == nil) then
				local handle7 = open1(_2e2e_2(path5, ".lisp"), "r")
				if handle7 then
					state37["libCache"][path5] = true
					state37["libNames"][name38] = true
					local lib5 = readLibrary1(state37, simplifyPath1(path5, paths2), path5, handle7)
					state37["libCache"][path5] = lib5
					state37["libNames"][name38] = lib5
					return list1(lib5)
				else
					return searcher1((i12 + 1))
				end
			elseif (cached1 == true) then
				return list1(nil, _2e2e_2("Already loading ", name38))
			else
				return list1(cached1)
			end
		end
	end)
	return searcher1(1)
end)
loader1 = (function(state38, name39, shouldResolve1)
	if shouldResolve1 then
		local cached2 = state38["libNames"][name39]
		if (cached2 == nil) then
			return pathLocator1(state38, name39)
		elseif (cached2 == true) then
			return list1(nil, _2e2e_2("Already loading ", name39))
		else
			return list1(cached2)
		end
	else
		name39 = gsub1(name39, "%.lisp$", "")
		local r_11401 = state38["libCache"][name39]
		if eq_3f_1(r_11401, nil) then
			local handle8 = open1(_2e2e_2(name39, ".lisp"))
			if handle8 then
				state38["libCache"][name39] = true
				local lib6 = readLibrary1(state38, simplifyPath1(name39, state38["paths"]), name39, handle8)
				state38["libCache"][name39] = lib6
				return list1(lib6)
			else
				return list1(nil, _2e2e_2("Cannot find ", quoted1(name39)))
			end
		elseif eq_3f_1(r_11401, true) then
			return list1(nil, _2e2e_2("Already loading ", name39))
		else
			return list1(r_11401)
		end
	end
end)
printError_21_1 = (function(msg20)
	if string_3f_1(msg20) then
	else
		msg20 = pretty1(msg20)
	end
	local lines9 = split1(msg20, "\n", 1)
	print1(colored1(31, _2e2e_2("[ERROR] ", car2(lines9))))
	if cadr1(lines9) then
		return print1(cadr1(lines9))
	else
	end
end)
printWarning_21_1 = (function(msg21)
	local lines10 = split1(msg21, "\n", 1)
	print1(colored1(33, _2e2e_2("[WARN] ", car2(lines10))))
	if cadr1(lines10) then
		return print1(cadr1(lines10))
	else
	end
end)
printVerbose_21_1 = (function(verbosity1, msg22)
	if (verbosity1 > 0) then
		return print1(_2e2e_2("[VERBOSE] ", msg22))
	else
	end
end)
printDebug_21_1 = (function(verbosity2, msg23)
	if (verbosity2 > 1) then
		return print1(_2e2e_2("[DEBUG] ", msg23))
	else
	end
end)
printTime_21_1 = (function(maximum1, name40, time2, level7)
	if (level7 <= maximum1) then
		return print1(_2e2e_2("[TIME] ", name40, " took ", time2))
	else
	end
end)
printExplain_21_1 = (function(explain4, lines11)
	if explain4 then
		local r_11751 = split1(lines11, "\n")
		local r_11781 = _23_1(r_11751)
		local r_11761 = nil
		r_11761 = (function(r_11771)
			if (r_11771 <= r_11781) then
				print1(_2e2e_2("  ", (r_11751[r_11771])))
				return r_11761((r_11771 + 1))
			else
			end
		end)
		return r_11761(1)
	else
	end
end)
create5 = (function(verbosity3, explain5, time3)
	return struct1("verbosity", verbosity3 or 0, "explain", (explain5 == true), "time", time3 or 0, "put-error!", putError_21_2, "put-warning!", putWarning_21_2, "put-verbose!", putVerbose_21_2, "put-debug!", putDebug_21_2, "put-time!", putTime_21_2, "put-node-error!", putNodeError_21_2, "put-node-warning!", putNodeWarning_21_2)
end)
putError_21_2 = (function(logger19, msg24)
	return printError_21_1(msg24)
end)
putWarning_21_2 = (function(logger20, msg25)
	return printWarning_21_1(msg25)
end)
putVerbose_21_2 = (function(logger21, msg26)
	return printVerbose_21_1(logger21["verbosity"], msg26)
end)
putDebug_21_2 = (function(logger22, msg27)
	return printDebug_21_1(logger22["verbosity"], msg27)
end)
putTime_21_2 = (function(logger23, name41, time4, level8)
	return printTime_21_1(logger23["time"], name41, time4, level8)
end)
putNodeError_21_2 = (function(logger24, msg28, node57, explain6, lines12)
	printError_21_1(msg28)
	putTrace_21_1(node57)
	if explain6 then
		printExplain_21_1(logger24["explain"], explain6)
	else
	end
	return putLines_21_1(true, lines12)
end)
putNodeWarning_21_2 = (function(logger25, msg29, node58, explain7, lines13)
	printWarning_21_1(msg29)
	putTrace_21_1(node58)
	if explain7 then
		printExplain_21_1(logger25["explain"], explain7)
	else
	end
	return putLines_21_1(true, lines13)
end)
putLines_21_1 = (function(range7, entries2)
	if nil_3f_1(entries2) then
		error1("Positions cannot be empty")
	else
	end
	if ((_23_1(entries2) % 2) ~= 0) then
		error1(_2e2e_2("Positions must be a multiple of 2, is ", _23_1(entries2)))
	else
	end
	local previous6 = -1
	local file4 = nth1(entries2, 1)["name"]
	local maxLine1 = foldr1((function(max6, node59)
		if string_3f_1(node59) then
			return max6
		else
			return max2(max6, node59["start"]["line"])
		end
	end), 0, entries2)
	local code3 = _2e2e_2(colored1(92, _2e2e_2(" %", len1(tostring1(maxLine1)), "s |")), " %s")
	local r_11711 = _23_1(entries2)
	local r_11691 = nil
	r_11691 = (function(r_11701)
		if (r_11701 <= r_11711) then
			local position2 = entries2[r_11701]
			local message1 = entries2[succ1(r_11701)]
			if (file4 ~= position2["name"]) then
				file4 = position2["name"]
				print1(colored1(95, _2e2e_2(" ", file4)))
			else
				local temp133
				local r_11801 = (previous6 ~= -1)
				temp133 = r_11801 and (abs1((position2["start"]["line"] - previous6)) > 2)
				if temp133 then
					print1(colored1(92, " ..."))
				else
				end
			end
			previous6 = position2["start"]["line"]
			print1(format1(code3, tostring1(position2["start"]["line"]), position2["lines"][position2["start"]["line"]]))
			local pointer1
			if _21_1(range7) then
				pointer1 = "^"
			else
				local temp134
				local r_11811 = position2["finish"]
				temp134 = r_11811 and (position2["start"]["line"] == position2["finish"]["line"])
				if temp134 then
					pointer1 = rep1("^", succ1((position2["finish"]["column"] - position2["start"]["column"])))
				else
					pointer1 = "^..."
				end
			end
			print1(format1(code3, "", _2e2e_2(rep1(" ", (position2["start"]["column"] - 1)), pointer1, " ", message1)))
			return r_11691((r_11701 + 2))
		else
		end
	end)
	return r_11691(1)
end)
putTrace_21_1 = (function(node60)
	local previous7 = nil
	local r_11731 = nil
	r_11731 = (function()
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
			return r_11731()
		else
		end
	end)
	return r_11731()
end)
rootScope2 = require1("tacky.analysis.resolve")["rootScope"]
scope_2f_child3 = require1("tacky.analysis.scope")["child"]
scope_2f_import_21_1 = require1("tacky.analysis.scope")["import"]
local spec16 = create1()
local directory1
local dir1 = nth1(arg1, 0)
dir1 = gsub1(dir1, "urn/cli%.lisp$", "")
dir1 = gsub1(dir1, "urn/cli$", "")
dir1 = gsub1(dir1, "tacky/cli%.lua$", "")
local temp135
local r_12401 = (dir1 ~= "")
temp135 = r_12401 and (charAt1(dir1, -1) ~= "/")
if temp135 then
	dir1 = _2e2e_2(dir1, "/")
else
end
local r_12411 = nil
r_12411 = (function()
	if (sub1(dir1, 1, 2) == "./") then
		dir1 = sub1(dir1, 3)
		return r_12411()
	else
	end
end)
r_12411()
directory1 = dir1
local paths3 = list1("?", "?/init", _2e2e_2(directory1, "lib/?"), _2e2e_2(directory1, "lib/?/init"))
local tasks1 = list1(warning1, optimise2, emitLisp1, emitLua1, task1, task3, task2, execTask1, replTask1)
addHelp_21_1(spec16)
addArgument_21_1(spec16, ({tag = "list", n = 2, "--explain", "-e"}), "help", "Explain error messages in more detail.")
addArgument_21_1(spec16, ({tag = "list", n = 2, "--time", "-t"}), "help", "Time how long each task takes to execute. Multiple usages will show more detailed timings.", "many", true, "default", 0, "action", (function(arg28, data8)
	data8[arg28["name"]] = succ1((function(r_11821)
		return r_11821 or 0
	end)(data8[arg28["name"]]))
	return nil
end))
addArgument_21_1(spec16, ({tag = "list", n = 2, "--verbose", "-v"}), "help", "Make the output more verbose. Can be used multiple times", "many", true, "default", 0, "action", (function(arg29, data9)
	data9[arg29["name"]] = succ1((function(r_11831)
		return r_11831 or 0
	end)(data9[arg29["name"]]))
	return nil
end))
addArgument_21_1(spec16, ({tag = "list", n = 2, "--include", "-i"}), "help", "Add an additional argument to the include path.", "many", true, "narg", 1, "default", ({tag = "list", n = 0}), "action", addAction1)
addArgument_21_1(spec16, ({tag = "list", n = 2, "--prelude", "-p"}), "help", "A custom prelude path to use.", "narg", 1, "default", _2e2e_2(directory1, "lib/prelude"))
addArgument_21_1(spec16, ({tag = "list", n = 3, "--output", "--out", "-o"}), "help", "The destination to output to.", "narg", 1, "default", "out")
addArgument_21_1(spec16, ({tag = "list", n = 2, "--wrapper", "-w"}), "help", "A wrapper script to launch Urn with", "narg", 1, "action", (function(a6, b6, value9)
	local args31 = map1(id1, arg1)
	local i13 = 1
	local len10 = _23_1(args31)
	local r_11841 = nil
	r_11841 = (function()
		if (i13 <= len10) then
			local item2 = nth1(args31, i13)
			local temp136
			local r_11851 = (item2 == "--wrapper")
			temp136 = r_11851 or (item2 == "-w")
			if temp136 then
				removeNth_21_1(args31, i13)
				removeNth_21_1(args31, i13)
				i13 = succ1(len10)
			elseif find1(item2, "^%-%-wrapper=.*$") then
				removeNth_21_1(args31, i13)
				i13 = succ1(len10)
			elseif find1(item2, "^%-[^-]+w$") then
				args31[i13] = sub1(item2, 1, -2)
				removeNth_21_1(args31, succ1(i13))
				i13 = succ1(len10)
			else
			end
			return r_11841()
		else
		end
	end)
	r_11841()
	local command2 = list1(value9)
	local interp1 = nth1(arg1, -1)
	if interp1 then
		pushCdr_21_1(command2, interp1)
	else
	end
	pushCdr_21_1(command2, nth1(arg1, 0))
	local r_11861 = list1(execute1(concat1(append1(command2, args31), " ")))
	local temp137
	local r_11881 = list_3f_1(r_11861)
	if r_11881 then
		local r_11891 = (_23_1(r_11861) >= 3)
		if r_11891 then
			local r_11901 = (_23_1(r_11861) <= 3)
			temp137 = r_11901 and true
		else
			temp137 = r_11891
		end
	else
		temp137 = r_11881
	end
	if temp137 then
		return exit1((nth1(r_11861, 3)))
	else
		return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_11861), ", but none matched.\n", "  Tried: `(_ _ ?code)`"))
	end
end))
addArgument_21_1(spec16, ({tag = "list", n = 1, "input"}), "help", "The file(s) to load.", "var", "FILE", "narg", "*")
local r_11971 = _23_1(tasks1)
local r_11951 = nil
r_11951 = (function(r_11961)
	if (r_11961 <= r_11971) then
		local task4 = tasks1[r_11961]
		task4["setup"](spec16)
		return r_11951((r_11961 + 1))
	else
	end
end)
r_11951(1)
local args32 = parse_21_1(spec16)
local logger26 = create5(args32["verbose"], args32["explain"], args32["time"])
local r_12001 = args32["include"]
local r_12031 = _23_1(r_12001)
local r_12011 = nil
r_12011 = (function(r_12021)
	if (r_12021 <= r_12031) then
		local path6 = r_12001[r_12021]
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
		return r_12011((r_12021 + 1))
	else
	end
end)
r_12011(1)
putVerbose_21_1(logger26, _2e2e_2("Using path: ", pretty1(paths3)))
if nil_3f_1(args32["input"]) then
	args32["repl"] = true
else
	args32["emit-lua"] = true
end
local compiler13 = struct1("log", logger26, "timer", create2((function(r_12371, r_12381, r_12391)
	return putTime_21_1(logger26, r_12371, r_12381, r_12391)
end)), "paths", paths3, "libEnv", ({}), "libMeta", ({}), "libs", ({tag = "list", n = 0}), "libCache", ({}), "libNames", ({}), "rootScope", rootScope2, "variables", ({}), "states", ({}), "out", ({tag = "list", n = 0}))
compiler13["compileState"] = createState2(compiler13["libMeta"])
compiler13["loader"] = (function(name42)
	return loader1(compiler13, name42, true)
end)
compiler13["global"] = setmetatable1(struct1("_libs", compiler13["libEnv"]), struct1("__index", _5f_G1))
iterPairs1(compiler13["rootScope"]["variables"], (function(_5f_3, var31)
	compiler13["variables"][tostring1(var31)] = var31
	return nil
end))
startTimer_21_1(compiler13["timer"], "loading")
local r_12051 = loader1(compiler13, args32["prelude"], false)
local temp138
local r_12081 = list_3f_1(r_12051)
if r_12081 then
	local r_12091 = (_23_1(r_12051) >= 2)
	if r_12091 then
		local r_12101 = (_23_1(r_12051) <= 2)
		if r_12101 then
			local r_12111 = eq_3f_1(nth1(r_12051, 1), nil)
			temp138 = r_12111 and true
		else
			temp138 = r_12101
		end
	else
		temp138 = r_12091
	end
else
	temp138 = r_12081
end
if temp138 then
	local errorMessage1 = nth1(r_12051, 2)
	putError_21_1(logger26, errorMessage1)
	exit_21_1(1)
else
	local temp139
	local r_12121 = list_3f_1(r_12051)
	if r_12121 then
		local r_12131 = (_23_1(r_12051) >= 1)
		if r_12131 then
			local r_12141 = (_23_1(r_12051) <= 1)
			temp139 = r_12141 and true
		else
			temp139 = r_12131
		end
	else
		temp139 = r_12121
	end
	if temp139 then
		local lib7 = nth1(r_12051, 1)
		compiler13["rootScope"] = scope_2f_child3(compiler13["rootScope"])
		iterPairs1(lib7["scope"]["exported"], (function(name43, var32)
			return scope_2f_import_21_1(compiler13["rootScope"], name43, var32)
		end))
		local r_12161 = args32["input"]
		local r_12191 = _23_1(r_12161)
		local r_12171 = nil
		r_12171 = (function(r_12181)
			if (r_12181 <= r_12191) then
				local input1 = r_12161[r_12181]
				local r_12211 = loader1(compiler13, input1, false)
				local temp140
				local r_12241 = list_3f_1(r_12211)
				if r_12241 then
					local r_12251 = (_23_1(r_12211) >= 2)
					if r_12251 then
						local r_12261 = (_23_1(r_12211) <= 2)
						if r_12261 then
							local r_12271 = eq_3f_1(nth1(r_12211, 1), nil)
							temp140 = r_12271 and true
						else
							temp140 = r_12261
						end
					else
						temp140 = r_12251
					end
				else
					temp140 = r_12241
				end
				if temp140 then
					local errorMessage2 = nth1(r_12211, 2)
					putError_21_1(logger26, errorMessage2)
					exit_21_1(1)
				else
					local temp141
					local r_12281 = list_3f_1(r_12211)
					if r_12281 then
						local r_12291 = (_23_1(r_12211) >= 1)
						if r_12291 then
							local r_12301 = (_23_1(r_12211) <= 1)
							temp141 = r_12301 and true
						else
							temp141 = r_12291
						end
					else
						temp141 = r_12281
					end
					if temp141 then
					else
						error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_12211), ", but none matched.\n", "  Tried: `(nil ?error-message)`\n  Tried: `(_)`"))
					end
				end
				return r_12171((r_12181 + 1))
			else
			end
		end)
		r_12171(1)
	else
		error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_12051), ", but none matched.\n", "  Tried: `(nil ?error-message)`\n  Tried: `(?lib)`"))
	end
end
stopTimer_21_1(compiler13["timer"], "loading")
local r_12351 = _23_1(tasks1)
local r_12331 = nil
r_12331 = (function(r_12341)
	if (r_12341 <= r_12351) then
		local task5 = tasks1[r_12341]
		if task5["pred"](args32) then
			startTimer_21_1(compiler13["timer"], task5["name"], 1)
			task5["run"](compiler13, args32)
			stopTimer_21_1(compiler13["timer"], task5["name"])
		else
		end
		return r_12331((r_12341 + 1))
	else
	end
end)
return r_12331(1)
