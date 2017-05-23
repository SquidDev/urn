#!/usr/bin/env lua
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
	local directory = arg[0]:gsub("\\", "/"):gsub("urn/cli%.lisp", ""):gsub("urn/cli$", ""):gsub("tacky/cli%.lua$", "")
	if directory ~= "" and directory:sub(-1, -1) ~= "/" then
		directory = directory .. "/"
	end
	package.path = package.path .. package.config:sub(3, 3) .. directory .. "?.lua"
	return {}
end)()
for k, v in pairs(_temp) do _libs["urn/cli-16/".. k] = v end
local _ENV = setmetatable({}, {__index=ENV or (getfenv and getfenv()) or _G}) if setfenv then setfenv(0, _ENV) end
_3d_1 = function(v1, v2) return (v1 == v2) end
_2f3d_1 = function(v1, v2) return (v1 ~= v2) end
_3c_1 = function(v1, v2) return (v1 < v2) end
_3c3d_1 = function(v1, v2) return (v1 <= v2) end
_3e_1 = function(v1, v2) return (v1 > v2) end
_3e3d_1 = function(v1, v2) return (v1 >= v2) end
_2b_1 = function(v1, v2, ...) local t = (v1 + v2) for i = 1, _select('#', ...) do t = (t + _select(i, ...)) end return t end
_2d_1 = function(v1, v2, ...) local t = (v1 - v2) for i = 1, _select('#', ...) do t = (t - _select(i, ...)) end return t end
_2a_1 = function(v1, v2, ...) local t = (v1 * v2) for i = 1, _select('#', ...) do t = (t * _select(i, ...)) end return t end
_2f_1 = function(v1, v2, ...) local t = (v1 / v2) for i = 1, _select('#', ...) do t = (t / _select(i, ...)) end return t end
_25_1 = function(v1, v2, ...) local t = (v1 % v2) for i = 1, _select('#', ...) do t = (t % _select(i, ...)) end return t end
_2e2e_1 = function(v1, v2, ...) local t = (v1 .. v2) for i = _select('#', ...), 1, -1 do t = (_select(i, ...) .. t) end return t end
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
n1 = (function(x1)
	if (type_23_1(x1) == "table") then
		return x1["n"]
	else
		return #(x1)
	end
end)
byte1 = string.byte
char1 = string.char
find1 = string.find
format1 = string.format
gsub1 = string.gsub
lower1 = string.lower
match1 = string.match
rep1 = string.rep
sub1 = string.sub
upper1 = string.upper
concat1 = table.concat
insert1 = table.insert
remove1 = table.remove
sort1 = table.sort
unpack1 = table.unpack
iterPairs1 = function(x, f) for k, v in pairs(x) do f(k, v) end end
list1 = (function(...)
	local xs1 = _pack(...) xs1.tag = "list"
	return xs1
end)
cons1 = (function(x2, xs2)
	local _offset, _result, _temp = 0, {tag="list",n=0}
	_result[1 + _offset] = x2
	_temp = xs2
	for _c = 1, _temp.n do _result[1 + _c + _offset] = _temp[_c] end
	_offset = _offset + _temp.n
	_result.n = _offset + 1
	return _result
end)
local counter1 = 0
gensym1 = (function(name1)
	if ((type_23_1(name1) == "table") and (name1["tag"] == "symbol")) then
		name1 = ("_" .. name1["contents"])
	elseif name1 then
		name1 = ("_" .. name1)
	else
		name1 = ""
	end
	counter1 = (counter1 + 1)
	return ({["tag"]="symbol",["contents"]=format1("r_%d%s", counter1, name1)})
end)
_2d_or1 = (function(a1, b1)
	return (a1 or b1)
end)
pretty1 = (function(value1)
	local ty1 = type_23_1(value1)
	if (ty1 == "table") then
		local tag1 = value1["tag"]
		if (tag1 == "list") then
			local out1 = ({tag = "list", n = 0})
			local r_51 = n1(value1)
			local r_31 = nil
			r_31 = (function(r_41)
				if (r_41 <= r_51) then
					out1[r_41] = pretty1(value1[r_41])
					return r_31((r_41 + 1))
				else
					return nil
				end
			end)
			r_31(1)
			return ("(" .. (concat1(out1, " ") .. ")"))
		elseif ((type_23_1(getmetatable1(value1)) == "table") and (type_23_1(getmetatable1(value1)["--pretty-print"]) == "function")) then
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
			return ("{" .. (concat1(out2, " ") .. "}"))
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
empty_3f_1 = (function(x3)
	local xt1 = type1(x3)
	if (xt1 == "list") then
		return (n1(x3) == 0)
	elseif (xt1 == "string") then
		return (#(x3) == 0)
	else
		return false
	end
end)
string_3f_1 = (function(x4)
	return ((type_23_1(x4) == "string") or ((type_23_1(x4) == "table") and (x4["tag"] == "string")))
end)
number_3f_1 = (function(x5)
	return ((type_23_1(x5) == "number") or ((type_23_1(x5) == "table") and (x5["tag"] == "number")))
end)
atom_3f_1 = (function(x6)
	return ((type_23_1(x6) ~= "table") or ((type_23_1(x6) == "table") and ((x6["tag"] == "symbol") or (x6["tag"] == "key"))))
end)
between_3f_1 = (function(val2, min1, max1)
	return ((val2 >= min1) and (val2 <= max1))
end)
type1 = (function(val3)
	local ty2 = type_23_1(val3)
	if (ty2 == "table") then
		return (val3["tag"] or "table")
	else
		return ty2
	end
end)
eq_3f_1 = (function(x7, y1)
	if (x7 == y1) then
		return true
	else
		local typeX1 = type1(x7)
		local typeY1 = type1(y1)
		if ((typeX1 == "list") and ((typeY1 == "list") and (n1(x7) == n1(y1)))) then
			local equal1 = true
			local r_291 = n1(x7)
			local r_271 = nil
			r_271 = (function(r_281)
				if (r_281 <= r_291) then
					if not eq_3f_1(x7[r_281], (y1[r_281])) then
						equal1 = false
					end
					return r_271((r_281 + 1))
				else
					return nil
				end
			end)
			r_271(1)
			return equal1
		elseif (("table" == type_23_1(x7)) and getmetatable1(x7)) then
			return getmetatable1(x7)["compare"](x7, y1)
		elseif (("table" == typeX1) and ("table" == typeY1)) then
			local equal2 = true
			iterPairs1(x7, (function(k2, v2)
				if not eq_3f_1(v2, (y1[k2])) then
					equal2 = false
					return nil
				else
					return nil
				end
			end))
			return equal2
		elseif (("symbol" == typeX1) and ("symbol" == typeY1)) then
			return (x7["contents"] == y1["contents"])
		elseif (("key" == typeX1) and ("key" == typeY1)) then
			return (x7["value"] == y1["value"])
		elseif (("symbol" == typeX1) and ("string" == typeY1)) then
			return (x7["contents"] == y1)
		elseif (("string" == typeX1) and ("symbol" == typeY1)) then
			return (x7 == y1["contents"])
		elseif (("key" == typeX1) and ("string" == typeY1)) then
			return (x7["value"] == y1)
		elseif (("string" == typeX1) and ("key" == typeY1)) then
			return (x7 == y1["value"])
		else
			return false
		end
	end
end)
abs1 = math.abs
huge1 = math.huge
max2 = math.max
min2 = math.min
modf1 = math.modf
car1 = (function(x8)
	local r_601 = type1(x8)
	if (r_601 ~= "list") then
		error1(format1("bad argument %s (expected %s, got %s)", "x", "list", r_601), 2)
	end
	return x8[1]
end)
cdr1 = (function(x9)
	local r_611 = type1(x9)
	if (r_611 ~= "list") then
		error1(format1("bad argument %s (expected %s, got %s)", "x", "list", r_611), 2)
	end
	if empty_3f_1(x9) then
		return ({tag = "list", n = 0})
	else
		return slice1(x9, 2)
	end
end)
foldl1 = (function(f1, z1, xs3)
	local r_621 = type1(f1)
	if (r_621 ~= "function") then
		error1(format1("bad argument %s (expected %s, got %s)", "f", "function", r_621), 2)
	end
	local r_631 = type1(xs3)
	if (r_631 ~= "list") then
		error1(format1("bad argument %s (expected %s, got %s)", "xs", "list", r_631), 2)
	end
	local accum1 = z1
	local r_661 = n1(xs3)
	local r_641 = nil
	r_641 = (function(r_651)
		if (r_651 <= r_661) then
			accum1 = f1(accum1, xs3[r_651])
			return r_641((r_651 + 1))
		else
			return nil
		end
	end)
	r_641(1)
	return accum1
end)
map1 = (function(fn1, ...)
	local xss1 = _pack(...) xss1.tag = "list"
	local ns1
	local out3 = ({tag = "list", n = 0})
	local r_701 = n1(xss1)
	local r_681 = nil
	r_681 = (function(r_691)
		if (r_691 <= r_701) then
			if not (type1((xss1[r_691])) == "list") then
				error1(("not a list: " .. (pretty1(xss1[r_691]) .. (" (it's a " .. (type1(xss1[r_691]) .. ")")))))
			else
			end
			pushCdr_21_1(out3, n1(xss1[r_691]))
			return r_681((r_691 + 1))
		else
			return nil
		end
	end)
	r_681(1)
	ns1 = out3
	local out4 = ({tag = "list", n = 0})
	local r_421 = min2(unpack1(ns1, 1, n1(ns1)))
	local r_401 = nil
	r_401 = (function(r_411)
		if (r_411 <= r_421) then
			pushCdr_21_1(out4, (function(xs4)
				return fn1(unpack1(xs4, 1, n1(xs4)))
			end)(nths1(xss1, r_411)))
			return r_401((r_411 + 1))
		else
			return nil
		end
	end)
	r_401(1)
	return out4
end)
filter1 = (function(p1, xs5)
	local r_761 = type1(p1)
	if (r_761 ~= "function") then
		error1(format1("bad argument %s (expected %s, got %s)", "p", "function", r_761), 2)
	end
	local r_771 = type1(xs5)
	if (r_771 ~= "list") then
		error1(format1("bad argument %s (expected %s, got %s)", "xs", "list", r_771), 2)
	end
	local out5 = ({tag = "list", n = 0})
	local r_801 = n1(xs5)
	local r_781 = nil
	r_781 = (function(r_791)
		if (r_791 <= r_801) then
			local x10 = xs5[r_791]
			if p1(x10) then
				pushCdr_21_1(out5, x10)
			end
			return r_781((r_791 + 1))
		else
			return nil
		end
	end)
	r_781(1)
	return out5
end)
any1 = (function(p2, xs6)
	local r_821 = type1(p2)
	if (r_821 ~= "function") then
		error1(format1("bad argument %s (expected %s, got %s)", "p", "function", r_821), 2)
	end
	local r_831 = type1(xs6)
	if (r_831 ~= "list") then
		error1(format1("bad argument %s (expected %s, got %s)", "xs", "list", r_831), 2)
	end
	return accumulateWith1(p2, _2d_or1, false, xs6)
end)
elem_3f_1 = (function(x11, xs7)
	local r_861 = type1(xs7)
	if (r_861 ~= "list") then
		error1(format1("bad argument %s (expected %s, got %s)", "xs", "list", r_861), 2)
	end
	return any1((function(y2)
		return eq_3f_1(x11, y2)
	end), xs7)
end)
last1 = (function(xs8)
	local r_891 = type1(xs8)
	if (r_891 ~= "list") then
		error1(format1("bad argument %s (expected %s, got %s)", "xs", "list", r_891), 2)
	end
	return xs8[n1(xs8)]
end)
nths1 = (function(xss2, idx1)
	local out6 = ({tag = "list", n = 0})
	local r_501 = n1(xss2)
	local r_481 = nil
	r_481 = (function(r_491)
		if (r_491 <= r_501) then
			pushCdr_21_1(out6, xss2[r_491][idx1])
			return r_481((r_491 + 1))
		else
			return nil
		end
	end)
	r_481(1)
	return out6
end)
pushCdr_21_1 = (function(xs9, val4)
	local r_911 = type1(xs9)
	if (r_911 ~= "list") then
		error1(format1("bad argument %s (expected %s, got %s)", "xs", "list", r_911), 2)
	end
	local len1 = (n1(xs9) + 1)
	xs9["n"] = len1
	xs9[len1] = val4
	return xs9
end)
popLast_21_1 = (function(xs10)
	local r_921 = type1(xs10)
	if (r_921 ~= "list") then
		error1(format1("bad argument %s (expected %s, got %s)", "xs", "list", r_921), 2)
	end
	local x12 = xs10[n1(xs10)]
	xs10[n1(xs10)] = nil
	xs10["n"] = (n1(xs10) - 1)
	return x12
end)
removeNth_21_1 = (function(li1, idx2)
	local r_931 = type1(li1)
	if (r_931 ~= "list") then
		error1(format1("bad argument %s (expected %s, got %s)", "li", "list", r_931), 2)
	end
	li1["n"] = (li1["n"] - 1)
	return remove1(li1, idx2)
end)
insertNth_21_1 = (function(li2, idx3, val5)
	local r_941 = type1(li2)
	if (r_941 ~= "list") then
		error1(format1("bad argument %s (expected %s, got %s)", "li", "list", r_941), 2)
	end
	li2["n"] = (li2["n"] + 1)
	return insert1(li2, idx3, val5)
end)
append1 = (function(xs11, ys1)
	local _offset, _result, _temp = 0, {tag="list",n=0}
	_temp = xs11
	for _c = 1, _temp.n do _result[0 + _c + _offset] = _temp[_c] end
	_offset = _offset + _temp.n
	_temp = ys1
	for _c = 1, _temp.n do _result[0 + _c + _offset] = _temp[_c] end
	_offset = _offset + _temp.n
	_result.n = _offset + 0
	return _result
end)
accumulateWith1 = (function(f2, ac1, z2, xs12)
	local r_961 = type1(f2)
	if (r_961 ~= "function") then
		error1(format1("bad argument %s (expected %s, got %s)", "f", "function", r_961), 2)
	end
	local r_971 = type1(ac1)
	if (r_971 ~= "function") then
		error1(format1("bad argument %s (expected %s, got %s)", "ac", "function", r_971), 2)
	end
	return foldl1(ac1, z2, map1(f2, xs12))
end)
_2e2e_2 = (function(...)
	local args1 = _pack(...) args1.tag = "list"
	return concat1(args1)
end)
split1 = (function(text1, pattern1, limit1)
	local out7 = ({tag = "list", n = 0})
	local loop1 = true
	local start1 = 1
	local r_1081 = nil
	r_1081 = (function()
		if loop1 then
			local pos1 = list1(find1(text1, pattern1, start1))
			local nstart1 = car1(pos1)
			local nend1 = car1(cdr1(pos1))
			if ((nstart1 == nil) or (limit1 and (n1(out7) >= limit1))) then
				loop1 = false
				pushCdr_21_1(out7, sub1(text1, start1, n1(text1)))
				start1 = (n1(text1) + 1)
			elseif (nstart1 > #(text1)) then
				if (start1 <= #(text1)) then
					pushCdr_21_1(out7, sub1(text1, start1, #(text1)))
				end
				loop1 = false
			elseif (nend1 < nstart1) then
				pushCdr_21_1(out7, sub1(text1, start1, nstart1))
				start1 = (nstart1 + 1)
			else
				pushCdr_21_1(out7, sub1(text1, start1, (nstart1 - 1)))
				start1 = (nend1 + 1)
			end
			return r_1081()
		else
			return nil
		end
	end)
	r_1081()
	return out7
end)
trim1 = (function(str1)
	return (gsub1(gsub1(str1, "^%s+", ""), "%s+$", ""))
end)
local escapes1 = ({})
local r_1041 = nil
r_1041 = (function(r_1051)
	if (r_1051 <= 31) then
		escapes1[char1(r_1051)] = _2e2e_2("\\", tostring1(r_1051))
		return r_1041((r_1051 + 1))
	else
		return nil
	end
end)
r_1041(0)
escapes1["\n"] = "n"
quoted1 = (function(str2)
	return (gsub1(format1("%q", str2), ".", escapes1))
end)
clock1 = os.clock
execute1 = os.execute
exit1 = os.exit
getenv1 = os.getenv
assoc1 = (function(list2, key1, orVal1)
	while true do
		if (not (type1(list2) == "list") or empty_3f_1(list2)) then
			return orVal1
		elseif eq_3f_1(car1(car1(list2)), key1) then
			return car1(cdr1(car1(list2)))
		else
			list2 = cdr1(list2)
		end
	end
end)
assoc_3f_1 = (function(list3, key2)
	while true do
		if (not (type1(list3) == "list") or empty_3f_1(list3)) then
			return false
		elseif eq_3f_1(car1(car1(list3)), key2) then
			return true
		else
			list3 = cdr1(list3)
		end
	end
end)
struct1 = (function(...)
	local entries1 = _pack(...) entries1.tag = "list"
	if ((n1(entries1) % 2) == 1) then
		error1("Expected an even number of arguments to struct", 2)
	end
	local out8 = ({})
	local r_1251 = n1(entries1)
	local r_1231 = nil
	r_1231 = (function(r_1241)
		if (r_1241 <= r_1251) then
			local key3 = entries1[r_1241]
			local val6 = entries1[(1 + r_1241)]
			out8[(function()
				if (type1(key3) == "key") then
					return key3["value"]
				else
					return key3
				end
			end)()
			] = val6
			return r_1231((r_1241 + 2))
		else
			return nil
		end
	end)
	r_1231(1)
	return out8
end)
values1 = (function(st1)
	local out9 = ({tag = "list", n = 0})
	iterPairs1(st1, (function(_5f_1, v3)
		return pushCdr_21_1(out9, v3)
	end))
	return out9
end)
createLookup1 = (function(values2)
	local res1 = ({})
	local r_1391 = n1(values2)
	local r_1371 = nil
	r_1371 = (function(r_1381)
		if (r_1381 <= r_1391) then
			res1[values2[r_1381]] = r_1381
			return r_1371((r_1381 + 1))
		else
			return nil
		end
	end)
	r_1371(1)
	return res1
end)
invokable_3f_1 = (function(x13)
	return ((type1(x13) == "function") or ((type_23_1(x13) == "table") and ((type_23_1((getmetatable1(x13))) == "table") and invokable_3f_1(getmetatable1(x13)["__call"]))))
end)
flush1 = io.flush
open1 = io.open
read1 = io.read
write1 = io.write
symbol_2d3e_string1 = (function(x14)
	if (type1(x14) == "symbol") then
		return x14["contents"]
	else
		return nil
	end
end)
fail_21_1 = (function(x15)
	return error1(x15, 0)
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
	end
	return exit1(code2)
end)
id1 = (function(x16)
	return x16
end)
self1 = (function(x17, key4, ...)
	local args2 = _pack(...) args2.tag = "list"
	return x17[key4](x17, unpack1(args2, 1, n1(args2)))
end)
create1 = (function(description1)
	return ({["desc"]=description1,["flag-map"]=({}),["opt-map"]=({}),["opt"]=({tag = "list", n = 0}),["pos"]=({tag = "list", n = 0})})
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
	local val7 = tonumber1(value4)
	if val7 then
		data3[aspec1["name"]] = val7
		return nil
	else
		return usage_21_1(_2e2e_2("Expected number for ", car1(arg1["names"]), ", got ", value4))
	end
end)
addArgument_21_1 = (function(spec1, names1, ...)
	local options1 = _pack(...) options1.tag = "list"
	local r_2561 = type1(names1)
	if (r_2561 ~= "list") then
		error1(format1("bad argument %s (expected %s, got %s)", "names", "list", r_2561), 2)
	end
	if empty_3f_1(names1) then
		error1("Names list is empty")
	end
	if ((n1(options1) % 2) == 0) then
	else
		error1("Options list should be a multiple of two")
	end
	local result1 = ({["names"]=names1,["action"]=nil,["narg"]=0,["default"]=false,["help"]="",["value"]=true})
	local first1 = car1(names1)
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
	local r_2611 = n1(names1)
	local r_2591 = nil
	r_2591 = (function(r_2601)
		if (r_2601 <= r_2611) then
			local name2 = names1[r_2601]
			if (sub1(name2, 1, 2) == "--") then
				spec1["opt-map"][sub1(name2, 3)] = result1
			elseif (sub1(name2, 1, 1) == "-") then
				spec1["flag-map"][sub1(name2, 2)] = result1
			end
			return r_2591((r_2601 + 1))
		else
			return nil
		end
	end)
	r_2591(1)
	local r_2651 = n1(options1)
	local r_2631 = nil
	r_2631 = (function(r_2641)
		if (r_2641 <= r_2651) then
			local key5 = options1[r_2641]
			result1[key5] = (options1[((r_2641 + 1))])
			return r_2631((r_2641 + 2))
		else
			return nil
		end
	end)
	r_2631(1)
	if result1["var"] then
	else
		result1["var"] = upper1(result1["name"])
	end
	if result1["action"] then
	else
		result1["action"] = (function()
			local temp1
			if number_3f_1(result1["narg"]) then
				temp1 = (result1["narg"] <= 1)
			else
				temp1 = (result1["narg"] == "?")
			end
			if temp1 then
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
	local r_3081 = arg5["narg"]
	if (r_3081 == "?") then
		return pushCdr_21_1(buffer1, _2e2e_2(" [", arg5["var"], "]"))
	elseif (r_3081 == "*") then
		return pushCdr_21_1(buffer1, _2e2e_2(" [", arg5["var"], "...]"))
	elseif (r_3081 == "+") then
		return pushCdr_21_1(buffer1, _2e2e_2(" ", arg5["var"], " [", arg5["var"], "...]"))
	else
		local r_3091 = nil
		r_3091 = (function(r_3101)
			if (r_3101 <= r_3081) then
				pushCdr_21_1(buffer1, _2e2e_2(" ", arg5["var"]))
				return r_3091((r_3101 + 1))
			else
				return nil
			end
		end)
		return r_3091(1)
	end
end)
usage_21_2 = (function(spec3, name3)
	if name3 then
	else
		name3 = (arg1[0] or (arg1[-1] or "?"))
	end
	local usage1 = list1("usage: ", name3)
	local r_2701 = spec3["opt"]
	local r_2731 = n1(r_2701)
	local r_2711 = nil
	r_2711 = (function(r_2721)
		if (r_2721 <= r_2731) then
			local arg6 = r_2701[r_2721]
			pushCdr_21_1(usage1, _2e2e_2(" [", car1(arg6["names"])))
			helpNarg_21_1(usage1, arg6)
			pushCdr_21_1(usage1, "]")
			return r_2711((r_2721 + 1))
		else
			return nil
		end
	end)
	r_2711(1)
	local r_2761 = spec3["pos"]
	local r_2791 = n1(r_2761)
	local r_2771 = nil
	r_2771 = (function(r_2781)
		if (r_2781 <= r_2791) then
			helpNarg_21_1(usage1, (r_2761[r_2781]))
			return r_2771((r_2781 + 1))
		else
			return nil
		end
	end)
	r_2771(1)
	return print1(concat1(usage1))
end)
help_21_1 = (function(spec4, name4)
	if name4 then
	else
		name4 = (arg1[0] or (arg1[-1] or "?"))
	end
	usage_21_2(spec4, name4)
	if spec4["desc"] then
		print1()
		print1(spec4["desc"])
	end
	local max3 = 0
	local r_2841 = spec4["pos"]
	local r_2871 = n1(r_2841)
	local r_2851 = nil
	r_2851 = (function(r_2861)
		if (r_2861 <= r_2871) then
			local arg7 = r_2841[r_2861]
			local len2 = n1(arg7["var"])
			if (len2 > max3) then
				max3 = len2
			end
			return r_2851((r_2861 + 1))
		else
			return nil
		end
	end)
	r_2851(1)
	local r_2901 = spec4["opt"]
	local r_2931 = n1(r_2901)
	local r_2911 = nil
	r_2911 = (function(r_2921)
		if (r_2921 <= r_2931) then
			local arg8 = r_2901[r_2921]
			local len3 = n1(concat1(arg8["names"], ", "))
			if (len3 > max3) then
				max3 = len3
			end
			return r_2911((r_2921 + 1))
		else
			return nil
		end
	end)
	r_2911(1)
	local fmt1 = _2e2e_2(" %-", tostring1((max3 + 1)), "s %s")
	if empty_3f_1(spec4["pos"]) then
	else
		print1()
		print1("Positional arguments")
		local r_2961 = spec4["pos"]
		local r_2991 = n1(r_2961)
		local r_2971 = nil
		r_2971 = (function(r_2981)
			if (r_2981 <= r_2991) then
				local arg9 = r_2961[r_2981]
				print1(format1(fmt1, arg9["var"], arg9["help"]))
				return r_2971((r_2981 + 1))
			else
				return nil
			end
		end)
		r_2971(1)
	end
	if empty_3f_1(spec4["opt"]) then
		return nil
	else
		print1()
		print1("Optional arguments")
		local r_3021 = spec4["opt"]
		local r_3051 = n1(r_3021)
		local r_3031 = nil
		r_3031 = (function(r_3041)
			if (r_3041 <= r_3051) then
				local arg10 = r_3021[r_3041]
				print1(format1(fmt1, concat1(arg10["names"], ", "), arg10["help"]))
				return r_3031((r_3041 + 1))
			else
				return nil
			end
		end)
		return r_3031(1)
	end
end)
matcher1 = (function(pattern2)
	return (function(x18)
		local res2 = list1(match1(x18, pattern2))
		if (car1(res2) == nil) then
			return nil
		else
			return res2
		end
	end)
end)
parse_21_1 = (function(spec5, args3)
	if args3 then
	else
		args3 = arg1
	end
	local result3 = ({})
	local pos2 = spec5["pos"]
	local idx4 = 1
	local len4 = n1(args3)
	local usage_21_3 = (function(msg1)
		usage_21_2(spec5, (args3[0]))
		print1(msg1)
		return exit_21_1(1)
	end)
	local readArgs1 = (function(key6, arg11)
		local r_3441 = arg11["narg"]
		if (r_3441 == "+") then
			idx4 = (idx4 + 1)
			local elem1 = args3[idx4]
			if (elem1 == nil) then
				local msg2 = _2e2e_2("Expected ", arg11["var"], " after --", key6, ", got nothing")
				usage_21_2(spec5, (args3[0]))
				print1(msg2)
				exit_21_1(1)
			elseif (not arg11["all"] and find1(elem1, "^%-")) then
				local msg3 = _2e2e_2("Expected ", arg11["var"], " after --", key6, ", got ", args3[idx4])
				usage_21_2(spec5, (args3[0]))
				print1(msg3)
				exit_21_1(1)
			else
				arg11["action"](arg11, result3, elem1, usage_21_3)
			end
			local running1 = true
			local r_3461 = nil
			r_3461 = (function()
				if running1 then
					idx4 = (idx4 + 1)
					local elem2 = args3[idx4]
					if (elem2 == nil) then
						running1 = false
					elseif (not arg11["all"] and find1(elem2, "^%-")) then
						running1 = false
					else
						arg11["action"](arg11, result3, elem2, usage_21_3)
					end
					return r_3461()
				else
					return nil
				end
			end)
			return r_3461()
		elseif (r_3441 == "*") then
			local running2 = true
			local r_3481 = nil
			r_3481 = (function()
				if running2 then
					idx4 = (idx4 + 1)
					local elem3 = args3[idx4]
					if (elem3 == nil) then
						running2 = false
					elseif (not arg11["all"] and find1(elem3, "^%-")) then
						running2 = false
					else
						arg11["action"](arg11, result3, elem3, usage_21_3)
					end
					return r_3481()
				else
					return nil
				end
			end)
			return r_3481()
		elseif (r_3441 == "?") then
			idx4 = (idx4 + 1)
			local elem4 = args3[idx4]
			if ((elem4 == nil) or (not arg11["all"] and find1(elem4, "^%-"))) then
				return arg11["action"](arg11, result3, arg11["value"])
			else
				idx4 = (idx4 + 1)
				return arg11["action"](arg11, result3, elem4, usage_21_3)
			end
		elseif (r_3441 == 0) then
			idx4 = (idx4 + 1)
			local value6 = arg11["value"]
			return arg11["action"](arg11, result3, value6, usage_21_3)
		else
			local r_3521 = nil
			r_3521 = (function(r_3531)
				if (r_3531 <= r_3441) then
					idx4 = (idx4 + 1)
					local elem5 = args3[idx4]
					if (elem5 == nil) then
						local msg4 = _2e2e_2("Expected ", r_3441, " args for ", key6, ", got ", (r_3531 - 1))
						usage_21_2(spec5, (args3[0]))
						print1(msg4)
						exit_21_1(1)
					elseif (not arg11["all"] and find1(elem5, "^%-")) then
						local msg5 = _2e2e_2("Expected ", r_3441, " for ", key6, ", got ", (r_3531 - 1))
						usage_21_2(spec5, (args3[0]))
						print1(msg5)
						exit_21_1(1)
					else
						arg11["action"](arg11, result3, elem5, usage_21_3)
					end
					return r_3521((r_3531 + 1))
				else
					return nil
				end
			end)
			r_3521(1)
			idx4 = (idx4 + 1)
			return nil
		end
	end)
	local r_3071 = nil
	r_3071 = (function()
		if (idx4 <= len4) then
			local r_3131 = args3[idx4]
			local temp2
			local r_3141 = matcher1("^%-%-([^=]+)=(.+)$")(r_3131)
			temp2 = ((type1(r_3141) == "list") and ((n1(r_3141) >= 2) and ((n1(r_3141) <= 2) and true)))
			if temp2 then
				local key7 = matcher1("^%-%-([^=]+)=(.+)$")(r_3131)[1]
				local val8 = matcher1("^%-%-([^=]+)=(.+)$")(r_3131)[2]
				local arg12 = spec5["opt-map"][key7]
				if (arg12 == nil) then
					local msg6 = _2e2e_2("Unknown argument ", key7, " in ", args3[idx4])
					usage_21_2(spec5, (args3[0]))
					print1(msg6)
					exit_21_1(1)
				elseif (not arg12["many"] and (nil ~= result3[arg12["name"]])) then
					local msg7 = _2e2e_2("Too may values for ", key7, " in ", args3[idx4])
					usage_21_2(spec5, (args3[0]))
					print1(msg7)
					exit_21_1(1)
				else
					local narg1 = arg12["narg"]
					if (number_3f_1(narg1) and (narg1 ~= 1)) then
						local msg8 = _2e2e_2("Expected ", tostring1(narg1), " values, got 1 in ", args3[idx4])
						usage_21_2(spec5, (args3[0]))
						print1(msg8)
						exit_21_1(1)
					end
					arg12["action"](arg12, result3, val8, usage_21_3)
				end
				idx4 = (idx4 + 1)
			else
				local temp3
				local r_3151 = matcher1("^%-%-(.*)$")(r_3131)
				temp3 = ((type1(r_3151) == "list") and ((n1(r_3151) >= 1) and ((n1(r_3151) <= 1) and true)))
				if temp3 then
					local key8 = matcher1("^%-%-(.*)$")(r_3131)[1]
					local arg13 = spec5["opt-map"][key8]
					if (arg13 == nil) then
						local msg9 = _2e2e_2("Unknown argument ", key8, " in ", args3[idx4])
						usage_21_2(spec5, (args3[0]))
						print1(msg9)
						exit_21_1(1)
					elseif (not arg13["many"] and (nil ~= result3[arg13["name"]])) then
						local msg10 = _2e2e_2("Too may values for ", key8, " in ", args3[idx4])
						usage_21_2(spec5, (args3[0]))
						print1(msg10)
						exit_21_1(1)
					else
						readArgs1(key8, arg13)
					end
				else
					local temp4
					local r_3161 = matcher1("^%-(.+)$")(r_3131)
					temp4 = ((type1(r_3161) == "list") and ((n1(r_3161) >= 1) and ((n1(r_3161) <= 1) and true)))
					if temp4 then
						local flags1 = matcher1("^%-(.+)$")(r_3131)[1]
						local i1 = 1
						local s1 = n1(flags1)
						local r_3301 = nil
						r_3301 = (function()
							if (i1 <= s1) then
								local key9
								local x19 = i1
								key9 = sub1(flags1, x19, x19)
								local arg14 = spec5["flag-map"][key9]
								if (arg14 == nil) then
									local msg11 = _2e2e_2("Unknown flag ", key9, " in ", args3[idx4])
									usage_21_2(spec5, (args3[0]))
									print1(msg11)
									exit_21_1(1)
								elseif (not arg14["many"] and (nil ~= result3[arg14["name"]])) then
									local msg12 = _2e2e_2("Too many occurances of ", key9, " in ", args3[idx4])
									usage_21_2(spec5, (args3[0]))
									print1(msg12)
									exit_21_1(1)
								else
									local narg2 = arg14["narg"]
									if (i1 == s1) then
										readArgs1(key9, arg14)
									elseif (narg2 == 0) then
										local value7 = arg14["value"]
										arg14["action"](arg14, result3, value7, usage_21_3)
									else
										local value8 = sub1(flags1, (i1 + 1))
										arg14["action"](arg14, result3, value8, usage_21_3)
										i1 = (s1 + 1)
										idx4 = (idx4 + 1)
									end
								end
								i1 = (i1 + 1)
								return r_3301()
							else
								return nil
							end
						end)
						r_3301()
					else
						local arg15 = car1(spec5["pos"])
						if arg15 then
							arg15["action"](arg15, result3, r_3131, usage_21_3)
						else
							local msg13 = _2e2e_2("Unknown argument ", arg15)
							usage_21_2(spec5, (args3[0]))
							print1(msg13)
							exit_21_1(1)
						end
						idx4 = (idx4 + 1)
					end
				end
			end
			return r_3071()
		else
			return nil
		end
	end)
	r_3071()
	local r_3331 = spec5["opt"]
	local r_3361 = n1(r_3331)
	local r_3341 = nil
	r_3341 = (function(r_3351)
		if (r_3351 <= r_3361) then
			local arg16 = r_3331[r_3351]
			if (result3[arg16["name"]] == nil) then
				result3[arg16["name"]] = arg16["default"]
			end
			return r_3341((r_3351 + 1))
		else
			return nil
		end
	end)
	r_3341(1)
	local r_3391 = spec5["pos"]
	local r_3421 = n1(r_3391)
	local r_3401 = nil
	r_3401 = (function(r_3411)
		if (r_3411 <= r_3421) then
			local arg17 = r_3391[r_3411]
			if (result3[arg17["name"]] == nil) then
				result3[arg17["name"]] = arg17["default"]
			end
			return r_3401((r_3411 + 1))
		else
			return nil
		end
	end)
	r_3401(1)
	return result3
end)
startTimer_21_1 = (function(timer1, name5, level1)
	local instance1 = timer1["timers"][name5]
	if instance1 then
	else
		instance1 = ({["name"]=name5,["level"]=(level1 or 1),["running"]=false,["total"]=0})
		timer1["timers"][name5] = instance1
	end
	if instance1["running"] then
		error1(_2e2e_2("Timer ", name5, " is already running"))
	end
	instance1["running"] = true
	instance1["start"] = clock1()
	return nil
end)
pauseTimer_21_1 = (function(timer2, name6)
	local instance2 = timer2["timers"][name6]
	if instance2 then
	else
		error1(_2e2e_2("Timer ", name6, " does not exist"))
	end
	if instance2["running"] then
	else
		error1(_2e2e_2("Timer ", name6, " is not running"))
	end
	instance2["running"] = false
	instance2["total"] = ((clock1() - instance2["start"]) + instance2["total"])
	return nil
end)
stopTimer_21_1 = (function(timer3, name7)
	local instance3 = timer3["timers"][name7]
	if instance3 then
	else
		error1(_2e2e_2("Timer ", name7, " does not exist"))
	end
	if instance3["running"] then
	else
		error1(_2e2e_2("Timer ", name7, " is not running"))
	end
	timer3["timers"][name7] = nil
	instance3["total"] = ((clock1() - instance3["start"]) + instance3["total"])
	return timer3["callback"](instance3["name"], instance3["total"], instance3["level"])
end)
void1 = ({["callback"]=(function()
	return nil
end),["timers"]=({})})
config1 = package.config
loaded1 = package.loaded
coloredAnsi1 = (function(col1, msg14)
	return _2e2e_2("\27[", col1, "m", msg14, "\27[0m")
end)
if (config1 and (sub1(config1, 1, 1) ~= "\\")) then
	colored_3f_1 = true
elseif (getenv1 and (getenv1("ANSICON") ~= nil)) then
	colored_3f_1 = true
else
	local temp5
	if getenv1 then
		local term1 = getenv1("TERM")
		if term1 then
			temp5 = find1(term1, "xterm")
		else
			temp5 = nil
		end
	else
		temp5 = false
	end
	if temp5 then
		colored_3f_1 = true
	else
		colored_3f_1 = false
	end
end
if colored_3f_1 then
	colored1 = coloredAnsi1
else
	colored1 = (function(col2, msg15)
		return msg15
	end)
end
putError_21_1 = (function(logger1, msg16)
	return self1(logger1, "put-error!", msg16)
end)
putWarning_21_1 = (function(logger2, msg17)
	return self1(logger2, "put-warning!", msg17)
end)
putVerbose_21_1 = (function(logger3, msg18)
	return self1(logger3, "put-verbose!", msg18)
end)
putDebug_21_1 = (function(logger4, msg19)
	return self1(logger4, "put-debug!", msg19)
end)
putNodeError_21_1 = (function(logger5, msg20, node1, explain1, ...)
	local lines1 = _pack(...) lines1.tag = "list"
	return self1(logger5, "put-node-error!", msg20, node1, explain1, lines1)
end)
putNodeWarning_21_1 = (function(logger6, msg21, node2, explain2, ...)
	local lines2 = _pack(...) lines2.tag = "list"
	return self1(logger6, "put-node-warning!", msg21, node2, explain2, lines2)
end)
doNodeError_21_1 = (function(logger7, msg22, node3, explain3, ...)
	local lines3 = _pack(...) lines3.tag = "list"
	self1(logger7, "put-node-error!", msg22, node3, explain3, lines3)
	return error1((match1(msg22, "^([^\n]+)\n") or msg22), 0)
end)
loaded1["tacky.logger.init"] = ({["startTimer"]=startTimer_21_1,["pauseTimer"]=pauseTimer_21_1,["stopTimer"]=stopTimer_21_1,["putError"]=putError_21_1,["putWarning"]=putWarning_21_1,["putVerbose"]=putVerbose_21_1,["putDebug"]=putDebug_21_1,["putNodeError"]=putNodeError_21_1,["putNodeWarning"]=putNodeWarning_21_1,["doNodeError"]=doNodeError_21_1,["colored"]=colored1})
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
formatNode1 = (function(node4)
	if (node4["range"] and node4["contents"]) then
		return format1("%s (%s)", formatRange1(node4["range"]), quoted1(node4["contents"]))
	elseif node4["range"] then
		return formatRange1(node4["range"])
	elseif node4["owner"] then
		local owner1 = node4["owner"]
		if owner1["var"] then
			return format1("macro expansion of %s (%s)", owner1["var"]["name"], formatNode1(owner1["node"]))
		else
			return format1("unquote expansion (%s)", formatNode1(owner1["node"]))
		end
	elseif (node4["start"] and node4["finish"]) then
		return formatRange1(node4)
	else
		return "?"
	end
end)
getSource1 = (function(node5)
	local result4 = nil
	local r_4021 = nil
	r_4021 = (function()
		if (node5 and not result4) then
			result4 = node5["range"]
			node5 = node5["parent"]
			return r_4021()
		else
			return nil
		end
	end)
	r_4021()
	return result4
end)
loaded1["tacky.range"] = ({["formatPosition"]=formatPosition1,["formatRange"]=formatRange1,["formatNode"]=formatNode1,["getSource"]=getSource1})
create2 = coroutine.create
resume1 = coroutine.resume
status1 = coroutine.status
yield1 = coroutine.yield
child1 = (function(parent1)
	return ({["parent"]=parent1,["variables"]=({}),["exported"]=({}),["prefix"]=(function()
		if parent1 then
			return parent1["prefix"]
		else
			return ""
		end
	end)()
	})
end)
get1 = (function(scope1, name8)
	if scope1 then
		return (scope1["variables"][name8] or get1(scope1["parent"], name8))
	else
		return nil
	end
end)
getAlways_21_1 = (function(scope2, name9, user1)
	return (get1(scope2, name9) or yield1(({["tag"]="define",["name"]=name9,["node"]=user1,["scope"]=scope2})))
end)
kinds1 = ({["defined"]=true,["native"]=true,["macro"]=true,["arg"]=true,["builtin"]=true})
add_21_1 = (function(scope3, name10, kind1, node6)
	local r_3891 = type1(name10)
	if (r_3891 ~= "string") then
		error1(format1("bad argument %s (expected %s, got %s)", "name", "string", r_3891), 2)
	end
	local r_3901 = type1(kind1)
	if (r_3901 ~= "string") then
		error1(format1("bad argument %s (expected %s, got %s)", "kind", "string", r_3901), 2)
	end
	if kinds1[kind1] then
	else
		error1(_2e2e_2("Unknown kind ", quoted1(kind1)))
	end
	if scope3["variables"][name10] then
		error1(_2e2e_2("Previous declaration of ", name10))
	end
	local var1 = ({["tag"]=kind1,["name"]=name10,["fullName"]=_2e2e_2(scope3["prefix"], name10),["scope"]=scope3,["const"]=(kind1 ~= "arg"),["node"]=node6})
	scope3["variables"][name10] = var1
	scope3["exported"][name10] = var1
	return var1
end)
addVerbose_21_1 = (function(scope4, name11, kind2, node7, logger8)
	local r_3911 = type1(name11)
	if (r_3911 ~= "string") then
		error1(format1("bad argument %s (expected %s, got %s)", "name", "string", r_3911), 2)
	end
	local r_3921 = type1(kind2)
	if (r_3921 ~= "string") then
		error1(format1("bad argument %s (expected %s, got %s)", "kind", "string", r_3921), 2)
	end
	if kinds1[kind2] then
	else
		error1(_2e2e_2("Unknown kind ", quoted1(kind2)))
	end
	local previous1 = scope4["variables"][name11]
	if previous1 then
		doNodeError_21_1(logger8, _2e2e_2("Previous declaration of ", name11), node7, nil, getSource1(node7), "new definition here", getSource1(previous1["node"]), "old definition here")
	end
	return add_21_1(scope4, name11, kind2, node7)
end)
import_21_1 = (function(scope5, name12, var2, export1)
	if var2 then
	else
		error1("var is nil", 0)
	end
	if (scope5["variables"][name12] and (scope5["variables"][name12] ~= var2)) then
		error1(_2e2e_2("Previous declaration of ", name12), 0)
	end
	scope5["variables"][name12] = var2
	if export1 then
		scope5["exported"][name12] = var2
	end
	return var2
end)
importVerbose_21_1 = (function(scope6, name13, var3, node8, export2, logger9)
	if var3 then
	else
		error1("var is nil", 0)
	end
	if (scope6["variables"][name13] and (scope6["variables"][name13] ~= var3)) then
		doNodeError_21_1(logger9, _2e2e_2("Previous declaration of ", name13), node8, nil, getSource1(node8), "imported here", getSource1(var3["node"]), "new definition here", getSource1(scope6["variables"][name13]["node"]), "old definition here")
	end
	return import_21_1(scope6, name13, var3, export2)
end)
loaded1["tacky.resolve.scope"] = ({["child"]=child1,["get"]=get1,["getAlways"]=getAlways_21_1,["add"]=add_21_1,["addVerbose"]=addVerbose_21_1,["import"]=import_21_1,["importVerbose"]=importVerbose_21_1})
local scope7 = child1()
scope7["builtin"] = true
rootScope1 = scope7
builtins1 = ({})
builtinVars1 = ({})
local r_3781 = ({tag = "list", n = 12, "define", "define-macro", "define-native", "lambda", "set!", "cond", "import", "struct-literal", "quote", "syntax-quote", "unquote", "unquote-splice"})
local r_3811 = n1(r_3781)
local r_3791 = nil
r_3791 = (function(r_3801)
	if (r_3801 <= r_3811) then
		local symbol1 = r_3781[r_3801]
		local var4 = add_21_1(rootScope1, symbol1, "builtin", nil)
		import_21_1(rootScope1, _2e2e_2("builtin/", symbol1), var4, true)
		builtins1[symbol1] = var4
		return r_3791((r_3801 + 1))
	else
		return nil
	end
end)
r_3791(1)
local r_3841 = ({tag = "list", n = 3, "nil", "true", "false"})
local r_3871 = n1(r_3841)
local r_3851 = nil
r_3851 = (function(r_3861)
	if (r_3861 <= r_3871) then
		local symbol2 = r_3841[r_3861]
		local var5 = add_21_1(rootScope1, symbol2, "defined", nil)
		import_21_1(rootScope1, _2e2e_2("builtin/", symbol2), var5, true)
		builtinVars1[var5] = true
		builtins1[symbol2] = var5
		return r_3851((r_3861 + 1))
	else
		return nil
	end
end)
r_3851(1)
createScope1 = (function()
	return child1(rootScope1)
end)
loaded1["tacky.resolve.builtins"] = ({["rootScope"]=rootScope1,["createScope"]=createScope1,["builtins"]=builtins1,["builtinVars"]=builtinVars1})
builtin_3f_1 = (function(node9, name14)
	return ((type1(node9) == "symbol") and (node9["var"] == builtins1[name14]))
end)
sideEffect_3f_1 = (function(node10)
	local tag3 = type1(node10)
	if ((tag3 == "number") or ((tag3 == "string") or ((tag3 == "key") or (tag3 == "symbol")))) then
		return false
	elseif (tag3 == "list") then
		local fst1 = car1(node10)
		if (type1(fst1) == "symbol") then
			local var6 = fst1["var"]
			return ((var6 ~= builtins1["lambda"]) and (var6 ~= builtins1["quote"]))
		else
			return true
		end
	else
		_error("unmatched item")
	end
end)
constant_3f_1 = (function(node11)
	return (string_3f_1(node11) or (number_3f_1(node11) or (type1(node11) == "key")))
end)
urn_2d3e_val1 = (function(node12)
	if string_3f_1(node12) then
		return node12["value"]
	elseif number_3f_1(node12) then
		return node12["value"]
	elseif (type1(node12) == "key") then
		return node12["value"]
	else
		_error("unmatched item")
	end
end)
val_2d3e_urn1 = (function(val9)
	if (type_23_1(val9) == "string") then
		return ({["tag"]="string",["value"]=val9})
	elseif (type_23_1(val9) == "number") then
		return ({["tag"]="number",["value"]=val9})
	elseif (type_23_1(val9) == "nil") then
		return ({["tag"]="symbol",["contents"]="nil",["var"]=builtins1["nil"]})
	elseif (type_23_1(val9) == "boolean") then
		return ({["tag"]="symbol",["contents"]=tostring1(val9),["var"]=builtins1[tostring1(val9)]})
	else
		return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(type_23_1(val9)), ", but none matched.\n", "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"nil\"`\n  Tried: `\"boolean\"`"))
	end
end)
urn_2d3e_bool1 = (function(node13)
	if (string_3f_1(node13) or ((type1(node13) == "key") or number_3f_1(node13))) then
		return true
	elseif (type1(node13) == "symbol") then
		if (builtins1["true"] == node13["var"]) then
			return true
		elseif (builtins1["false"] == node13["var"]) then
			return false
		elseif (builtins1["nil"] == node13["var"]) then
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
		_result[1 + _offset] = (function(var7)
			return ({["tag"]="symbol",["contents"]=var7["name"],["var"]=var7})
		end)(builtins1["lambda"])
		_result[2 + _offset] = ({tag = "list", n = 0})
		_temp = body1
		for _c = 1, _temp.n do _result[2 + _c + _offset] = _temp[_c] end
		_offset = _offset + _temp.n
		_result.n = _offset + 2
		return _result
	end)()
	})
end)
makeSymbol1 = (function(var8)
	return ({["tag"]="symbol",["contents"]=var8["name"],["var"]=var8})
end)
symbol_2d3e_var1 = (function(state1, symb1)
	local var9 = symb1["var"]
	if string_3f_1(var9) then
		return state1["variables"][var9]
	else
		return var9
	end
end)
local r_4051 = builtins1["nil"]
makeNil1 = (function()
	return ({["tag"]="symbol",["contents"]=r_4051["name"],["var"]=r_4051})
end)
fastAll1 = (function(fn2, li3, i2)
	while true do
		if (i2 > n1(li3)) then
			return true
		elseif fn2(li3[i2]) then
			i2 = (i2 + 1)
		else
			return false
		end
	end
end)
passEnabled_3f_1 = (function(pass1, options2)
	local override1 = options2["override"]
	if (override1[pass1["name"]] == true) then
		return true
	elseif (override1[pass1["name"]] == false) then
		return false
	elseif any1((function(cat1)
		return (override1[cat1] == true)
	end), pass1["cat"]) then
		return true
	elseif any1((function(cat2)
		return (override1[cat2] == false)
	end), pass1["cat"]) then
		return false
	else
		return ((pass1["on"] ~= false) and (options2["level"] >= (pass1["level"] or 1)))
	end
end)
runPass1 = (function(pass2, options3, tracker1, ...)
	local args4 = _pack(...) args4.tag = "list"
	if passEnabled_3f_1(pass2, options3) then
		local ptracker1 = ({["changed"]=false})
		local name15 = _2e2e_2("[", concat1(pass2["cat"], " "), "] ", pass2["name"])
		startTimer_21_1(options3["timer"], name15, 2)
		pass2["run"](ptracker1, options3, unpack1(args4, 1, n1(args4)))
		stopTimer_21_1(options3["timer"], name15)
		if ptracker1["changed"] then
			if options3["track"] then
				self1(options3["logger"], "put-verbose!", (_2e2e_2(name15, " did something.")))
			end
			if tracker1 then
				tracker1["changed"] = true
			end
		end
		return ptracker1["changed"]
	else
		return nil
	end
end)
traverseQuote1 = (function(node14, visitor1, level2)
	if (level2 == 0) then
		return traverseNode1(node14, visitor1)
	else
		local tag4 = node14["tag"]
		if ((tag4 == "string") or ((tag4 == "number") or ((tag4 == "key") or (tag4 == "symbol")))) then
			return node14
		elseif (tag4 == "list") then
			local first2 = node14[1]
			if (first2 and (first2["tag"] == "symbol")) then
				if ((first2["contents"] == "unquote") or (first2["contents"] == "unquote-splice")) then
					node14[2] = traverseQuote1(node14[2], visitor1, (level2 - 1))
					return node14
				elseif (first2["contents"] == "syntax-quote") then
					node14[2] = traverseQuote1(node14[2], visitor1, (level2 + 1))
					return node14
				else
					local r_4281 = n1(node14)
					local r_4261 = nil
					r_4261 = (function(r_4271)
						if (r_4271 <= r_4281) then
							node14[r_4271] = traverseQuote1(node14[r_4271], visitor1, level2)
							return r_4261((r_4271 + 1))
						else
							return nil
						end
					end)
					r_4261(1)
					return node14
				end
			else
				local r_4321 = n1(node14)
				local r_4301 = nil
				r_4301 = (function(r_4311)
					if (r_4311 <= r_4321) then
						node14[r_4311] = traverseQuote1(node14[r_4311], visitor1, level2)
						return r_4301((r_4311 + 1))
					else
						return nil
					end
				end)
				r_4301(1)
				return node14
			end
		elseif error1 then
			return _2e2e_2("Unknown tag ", tag4)
		else
			_error("unmatched item")
		end
	end
end)
traverseNode1 = (function(node15, visitor2)
	local tag5 = node15["tag"]
	if ((tag5 == "string") or ((tag5 == "number") or ((tag5 == "key") or (tag5 == "symbol")))) then
		return visitor2(node15, visitor2)
	elseif (tag5 == "list") then
		local first3 = car1(node15)
		first3 = visitor2(first3, visitor2)
		node15[1] = first3
		if (first3["tag"] == "symbol") then
			local func1 = first3["var"]
			local funct1 = func1["tag"]
			if (func1 == builtins1["lambda"]) then
				traverseBlock1(node15, 3, visitor2)
				return visitor2(node15, visitor2)
			elseif (func1 == builtins1["cond"]) then
				local r_4361 = n1(node15)
				local r_4341 = nil
				r_4341 = (function(r_4351)
					if (r_4351 <= r_4361) then
						local case1 = node15[r_4351]
						case1[1] = traverseNode1(case1[1], visitor2)
						traverseBlock1(case1, 2, visitor2)
						return r_4341((r_4351 + 1))
					else
						return nil
					end
				end)
				r_4341(2)
				return visitor2(node15, visitor2)
			elseif (func1 == builtins1["set!"]) then
				node15[3] = traverseNode1(node15[3], visitor2)
				return visitor2(node15, visitor2)
			elseif (func1 == builtins1["quote"]) then
				return visitor2(node15, visitor2)
			elseif (func1 == builtins1["syntax-quote"]) then
				node15[2] = traverseQuote1(node15[2], visitor2, 1)
				return visitor2(node15, visitor2)
			elseif ((func1 == builtins1["unquote"]) or (func1 == builtins1["unquote-splice"])) then
				return error1("unquote/unquote-splice should never appear head", 0)
			elseif ((func1 == builtins1["define"]) or (func1 == builtins1["define-macro"])) then
				node15[n1(node15)] = traverseNode1(node15[(n1(node15))], visitor2)
				return visitor2(node15, visitor2)
			elseif (func1 == builtins1["define-native"]) then
				return visitor2(node15, visitor2)
			elseif (func1 == builtins1["import"]) then
				return visitor2(node15, visitor2)
			elseif (func1 == builtins1["struct-literal"]) then
				traverseList1(node15, 2, visitor2)
				return visitor2(node15, visitor2)
			elseif ((funct1 == "defined") or ((funct1 == "arg") or ((funct1 == "native") or (funct1 == "macro")))) then
				traverseList1(node15, 1, visitor2)
				return visitor2(node15, visitor2)
			else
				return error1(_2e2e_2("Unknown kind ", funct1, " for variable ", func1["name"]), 0)
			end
		else
			traverseList1(node15, 1, visitor2)
			return visitor2(node15, visitor2)
		end
	else
		return error1(_2e2e_2("Unknown tag ", tag5))
	end
end)
traverseBlock1 = (function(node16, start2, visitor3)
	local r_4151 = n1(node16)
	local r_4131 = nil
	r_4131 = (function(r_4141)
		if (r_4141 <= r_4151) then
			node16[r_4141] = (traverseNode1(node16[((r_4141 + 0))], visitor3))
			return r_4131((r_4141 + 1))
		else
			return nil
		end
	end)
	r_4131(start2)
	return node16
end)
traverseList1 = (function(node17, start3, visitor4)
	local r_4191 = n1(node17)
	local r_4171 = nil
	r_4171 = (function(r_4181)
		if (r_4181 <= r_4191) then
			node17[r_4181] = traverseNode1(node17[r_4181], visitor4)
			return r_4171((r_4181 + 1))
		else
			return nil
		end
	end)
	r_4171(start3)
	return node17
end)
visitQuote1 = (function(node18, visitor5, level3)
	while true do
		if (level3 == 0) then
			return visitNode1(node18, visitor5)
		else
			local tag6 = node18["tag"]
			if ((tag6 == "string") or ((tag6 == "number") or ((tag6 == "key") or (tag6 == "symbol")))) then
				return nil
			elseif (tag6 == "list") then
				local first4 = node18[1]
				if (first4 and (first4["tag"] == "symbol")) then
					if ((first4["contents"] == "unquote") or (first4["contents"] == "unquote-splice")) then
						node18, level3 = node18[2], (level3 - 1)
					elseif (first4["contents"] == "syntax-quote") then
						node18, level3 = node18[2], (level3 + 1)
					else
						local r_4671 = n1(node18)
						local r_4651 = nil
						r_4651 = (function(r_4661)
							if (r_4661 <= r_4671) then
								visitQuote1(node18[r_4661], visitor5, level3)
								return r_4651((r_4661 + 1))
							else
								return nil
							end
						end)
						return r_4651(1)
					end
				else
					local r_4731 = n1(node18)
					local r_4711 = nil
					r_4711 = (function(r_4721)
						if (r_4721 <= r_4731) then
							visitQuote1(node18[r_4721], visitor5, level3)
							return r_4711((r_4721 + 1))
						else
							return nil
						end
					end)
					return r_4711(1)
				end
			elseif error1 then
				return _2e2e_2("Unknown tag ", tag6)
			else
				_error("unmatched item")
			end
		end
	end
end)
visitNode1 = (function(node19, visitor6)
	while true do
		if (visitor6(node19, visitor6) == false) then
			return nil
		else
			local tag7 = node19["tag"]
			if ((tag7 == "string") or ((tag7 == "number") or ((tag7 == "key") or (tag7 == "symbol")))) then
				return nil
			elseif (tag7 == "list") then
				local first5 = node19[1]
				if (first5["tag"] == "symbol") then
					local func2 = first5["var"]
					local funct2 = func2["tag"]
					if (func2 == builtins1["lambda"]) then
						return visitBlock1(node19, 3, visitor6)
					elseif (func2 == builtins1["cond"]) then
						local r_4771 = n1(node19)
						local r_4751 = nil
						r_4751 = (function(r_4761)
							if (r_4761 <= r_4771) then
								local case2 = node19[r_4761]
								visitNode1(case2[1], visitor6)
								visitBlock1(case2, 2, visitor6)
								return r_4751((r_4761 + 1))
							else
								return nil
							end
						end)
						return r_4751(2)
					elseif (func2 == builtins1["set!"]) then
						node19 = node19[3]
					elseif (func2 == builtins1["quote"]) then
						return nil
					elseif (func2 == builtins1["syntax-quote"]) then
						return visitQuote1(node19[2], visitor6, 1)
					elseif ((func2 == builtins1["unquote"]) or (func2 == builtins1["unquote-splice"])) then
						return error1("unquote/unquote-splice should never appear here", 0)
					elseif ((func2 == builtins1["define"]) or (func2 == builtins1["define-macro"])) then
						node19 = node19[(n1(node19))]
					elseif (func2 == builtins1["define-native"]) then
						return nil
					elseif (func2 == builtins1["import"]) then
						return nil
					elseif (func2 == builtins1["struct-literal"]) then
						return visitBlock1(node19, 2, visitor6)
					elseif ((funct2 == "defined") or ((funct2 == "arg") or ((funct2 == "native") or (funct2 == "macro")))) then
						return visitBlock1(node19, 1, visitor6)
					else
						return error1(_2e2e_2("Unknown kind ", funct2, " for variable ", func2["name"]), 0)
					end
				else
					return visitBlock1(node19, 1, visitor6)
				end
			else
				return error1(_2e2e_2("Unknown tag ", tag7))
			end
		end
	end
end)
visitBlock1 = (function(node20, start4, visitor7)
	local r_4561 = n1(node20)
	local r_4541 = nil
	r_4541 = (function(r_4551)
		if (r_4551 <= r_4561) then
			visitNode1(node20[r_4551], visitor7)
			return r_4541((r_4551 + 1))
		else
			return nil
		end
	end)
	return r_4541(start4)
end)
getVar1 = (function(state2, var10)
	local entry1 = state2["vars"][var10]
	if entry1 then
	else
		entry1 = ({["var"]=var10,["usages"]=({tag = "list", n = 0}),["defs"]=({tag = "list", n = 0}),["active"]=false})
		state2["vars"][var10] = entry1
	end
	return entry1
end)
addUsage_21_1 = (function(state3, var11, node21)
	local varMeta1 = getVar1(state3, var11)
	pushCdr_21_1(varMeta1["usages"], node21)
	varMeta1["active"] = true
	return nil
end)
addDefinition_21_1 = (function(state4, var12, node22, kind3, value9)
	return pushCdr_21_1(getVar1(state4, var12)["defs"], ({["tag"]=kind3,["node"]=node22,["value"]=value9}))
end)
definitionsVisitor1 = (function(state5, node23, visitor8)
	if ((type1(node23) == "list") and (type1((car1(node23))) == "symbol")) then
		local func3 = car1(node23)["var"]
		if (func3 == builtins1["lambda"]) then
			local r_4851 = node23[2]
			local r_4881 = n1(r_4851)
			local r_4861 = nil
			r_4861 = (function(r_4871)
				if (r_4871 <= r_4881) then
					local arg18 = r_4851[r_4871]
					addDefinition_21_1(state5, arg18["var"], arg18, "var", arg18["var"])
					return r_4861((r_4871 + 1))
				else
					return nil
				end
			end)
			return r_4861(1)
		elseif (func3 == builtins1["set!"]) then
			return addDefinition_21_1(state5, node23[2]["var"], node23, "val", node23[3])
		elseif ((func3 == builtins1["define"]) or (func3 == builtins1["define-macro"])) then
			return addDefinition_21_1(state5, node23["defVar"], node23, "val", node23[(n1(node23))])
		elseif (func3 == builtins1["define-native"]) then
			return addDefinition_21_1(state5, node23["defVar"], node23, "var", node23["defVar"])
		else
			return nil
		end
	elseif ((type1(node23) == "list") and ((type1((car1(node23))) == "list") and ((type1((car1(car1(node23)))) == "symbol") and (car1(car1(node23))["var"] == builtins1["lambda"])))) then
		local lam1 = car1(node23)
		local args5 = lam1[2]
		local offset1 = 1
		local i3 = 1
		local argLen1 = n1(args5)
		local r_4941 = nil
		r_4941 = (function()
			if (i3 <= argLen1) then
				local arg19 = args5[i3]
				local val10 = node23[((i3 + offset1))]
				if arg19["var"]["isVariadic"] then
					local count1 = (n1(node23) - n1(args5))
					if (count1 < 0) then
						count1 = 0
					end
					offset1 = count1
					addDefinition_21_1(state5, arg19["var"], arg19, "var", arg19["var"])
				elseif (((i3 + offset1) == n1(node23)) and ((i3 < argLen1) and (type1(val10) == "list"))) then
					local r_4971 = nil
					r_4971 = (function(r_4981)
						if (r_4981 <= argLen1) then
							local arg20 = args5[r_4981]
							addDefinition_21_1(state5, arg20["var"], arg20, "var", arg20)
							return r_4971((r_4981 + 1))
						else
							return nil
						end
					end)
					r_4971(i3)
					i3 = argLen1
				else
					addDefinition_21_1(state5, arg19["var"], arg19, "val", (val10 or ({["tag"]="symbol",["contents"]="nil",["var"]=builtins1["nil"]})))
				end
				i3 = (i3 + 1)
				return r_4941()
			else
				return nil
			end
		end)
		r_4941()
		visitBlock1(node23, 2, visitor8)
		visitBlock1(lam1, 3, visitor8)
		return false
	else
		return nil
	end
end)
definitionsVisit1 = (function(state6, nodes1)
	return visitBlock1(nodes1, 1, (function(r_5131, r_5141)
		return definitionsVisitor1(state6, r_5131, r_5141)
	end))
end)
usagesVisit1 = (function(state7, nodes2, pred1)
	if pred1 then
	else
		pred1 = (function()
			return true
		end)
	end
	local queue1 = ({tag = "list", n = 0})
	local visited1 = ({})
	local addUsage1 = (function(var13, user2)
		local varMeta2 = getVar1(state7, var13)
		if varMeta2["active"] then
		else
			local r_5071 = varMeta2["defs"]
			local r_5101 = n1(r_5071)
			local r_5081 = nil
			r_5081 = (function(r_5091)
				if (r_5091 <= r_5101) then
					local def1 = r_5071[r_5091]
					local val11 = def1["value"]
					if ((def1["tag"] == "val") and not visited1[val11]) then
						pushCdr_21_1(queue1, val11)
					end
					return r_5081((r_5091 + 1))
				else
					return nil
				end
			end)
			r_5081(1)
		end
		return addUsage_21_1(state7, var13, user2)
	end)
	local visit1 = (function(node24)
		if visited1[node24] then
			return false
		else
			visited1[node24] = true
			if (type1(node24) == "symbol") then
				addUsage1(node24["var"], node24)
				return true
			elseif ((type1(node24) == "list") and ((n1(node24) > 0) and (type1((car1(node24))) == "symbol"))) then
				local func4 = car1(node24)["var"]
				if ((func4 == builtins1["set!"]) or ((func4 == builtins1["define"]) or (func4 == builtins1["define-macro"]))) then
					if pred1(node24[3]) then
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
	end)
	local r_4481 = n1(nodes2)
	local r_4461 = nil
	r_4461 = (function(r_4471)
		if (r_4471 <= r_4481) then
			pushCdr_21_1(queue1, (nodes2[r_4471]))
			return r_4461((r_4471 + 1))
		else
			return nil
		end
	end)
	r_4461(1)
	local r_4501 = nil
	r_4501 = (function()
		if (n1(queue1) > 0) then
			visitNode1(popLast_21_1(queue1), visit1)
			return r_4501()
		else
			return nil
		end
	end)
	return r_4501()
end)
tagUsage1 = ({["name"]="tag-usage",["help"]="Gathers usage and definition data for all expressions in NODES, storing it in LOOKUP.",["cat"]=({tag = "list", n = 2, "tag", "usage"}),["run"]=(function(r_5151, state8, nodes3, lookup1)
	definitionsVisit1(lookup1, nodes3)
	return usagesVisit1(lookup1, nodes3, sideEffect_3f_1)
end)})
fusionPatterns1 = ({tag = "list", n = 0})
metavar_3f_1 = (function(x20)
	return ((x20["var"] == nil) and (sub1(symbol_2d3e_string1(x20), 1, 1) == "?"))
end)
genvar_3f_1 = (function(x21)
	return ((x21["var"] == nil) and (sub1(symbol_2d3e_string1(x21), 1, 1) == "%"))
end)
peq_3f_1 = (function(x22, y3, out10)
	if (x22 == y3) then
		return true
	else
		local tyX1 = type1(x22)
		local tyY1 = type1(y3)
		if ((tyX1 == "symbol") and metavar_3f_1(x22)) then
			out10[symbol_2d3e_string1(x22)] = y3
			return true
		elseif (tyX1 ~= tyY1) then
			return false
		elseif (tyX1 == "symbol") then
			return (x22["var"] == y3["var"])
		elseif (tyX1 == "string") then
			return (constVal1(x22) == constVal1(y3))
		elseif (tyX1 == "number") then
			return (constVal1(x22) == constVal1(y3))
		elseif (tyX1 == "key") then
			return (constVal1(x22) == constVal1(y3))
		elseif (tyX1 == "list") then
			if (n1(x22) == n1(y3)) then
				local ok1 = true
				local r_5211 = n1(x22)
				local r_5191 = nil
				r_5191 = (function(r_5201)
					if (r_5201 <= r_5211) then
						if (ok1 and not peq_3f_1(x22[r_5201], y3[r_5201], out10)) then
							ok1 = false
						end
						return r_5191((r_5201 + 1))
					else
						return nil
					end
				end)
				r_5191(1)
				return ok1
			else
				return false
			end
		else
			_error("unmatched item")
		end
	end
end)
substitute1 = (function(x23, subs1, syms1)
	local r_5241 = type1(x23)
	if (r_5241 == "string") then
		return x23
	elseif (r_5241 == "number") then
		return x23
	elseif (r_5241 == "key") then
		return x23
	elseif (r_5241 == "symbol") then
		if metavar_3f_1(x23) then
			local res3 = subs1[symbol_2d3e_string1(x23)]
			if (res3 == nil) then
				error1(_2e2e_2("Unknown capture ", pretty1(x23)), 0)
			end
			return res3
		elseif genvar_3f_1(x23) then
			local name16 = symbol_2d3e_string1(x23)
			local sym1 = syms1[name16]
			if sym1 then
			else
				sym1 = gensym1()
				sym1["var"] = ({["tag"]="arg",["name"]=symbol_2d3e_string1(sym1)})
				syms1[name16] = sym1
			end
			return sym1
		else
			local var14 = x23["var"]
			return ({["tag"]="symbol",["contents"]=var14["name"],["var"]=var14})
		end
	elseif (r_5241 == "list") then
		return map1((function(r_5281)
			return substitute1(r_5281, subs1, syms1)
		end), x23)
	else
		return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_5241), ", but none matched.\n", "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"key\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`"))
	end
end)
fixPattern_21_1 = (function(state9, ptrn1)
	local r_5261 = type1(ptrn1)
	if (r_5261 == "string") then
		return ptrn1
	elseif (r_5261 == "number") then
		return ptrn1
	elseif (r_5261 == "symbol") then
		if ptrn1["var"] then
			local var15 = symbol_2d3e_var1(state9, ptrn1)
			return ({["tag"]="symbol",["contents"]=var15["name"],["var"]=var15})
		else
			return ptrn1
		end
	elseif (r_5261 == "list") then
		return map1((function(r_5291)
			return fixPattern_21_1(state9, r_5291)
		end), ptrn1)
	else
		return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_5261), ", but none matched.\n", "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`"))
	end
end)
fixRule_21_1 = (function(state10, rule1)
	return ({["from"]=fixPattern_21_1(state10, rule1["from"]),["to"]=fixPattern_21_1(state10, rule1["to"])})
end)
fusion1 = ({["name"]="fusion",["help"]="Merges various loops together as specified by a pattern.",["cat"]=({tag = "list", n = 1, "opt"}),["on"]=false,["run"]=(function(r_5152, state11, nodes4)
	local patterns1 = map1((function(r_5361)
		return fixRule_21_1(state11["compiler"], r_5361)
	end), fusionPatterns1)
	return traverseBlock1(nodes4, 1, (function(node25)
		if (type1(node25) == "list") then
			local r_5341 = n1(patterns1)
			local r_5321 = nil
			r_5321 = (function(r_5331)
				if (r_5331 <= r_5341) then
					local ptrn2 = patterns1[r_5331]
					local subs2 = ({})
					if peq_3f_1(ptrn2["from"], node25, subs2) then
						r_5152["changed"] = true
						node25 = substitute1(ptrn2["to"], subs2, ({}))
					end
					return r_5321((r_5331 + 1))
				else
					return nil
				end
			end)
			r_5321(1)
		end
		return node25
	end))
end)})
addRule_21_1 = (function(rule2)
	local r_5271 = type1(rule2)
	if (r_5271 ~= "table") then
		error1(format1("bad argument %s (expected %s, got %s)", "rule", "table", r_5271), 2)
	end
	pushCdr_21_1(fusionPatterns1, rule2)
	return nil
end)
stripImport1 = ({["name"]="strip-import",["help"]="Strip all import expressions in NODES",["cat"]=({tag = "list", n = 1, "opt"}),["run"]=(function(r_5153, state12, nodes5)
	local r_5371 = nil
	r_5371 = (function(r_5381)
		if (r_5381 >= 1) then
			local node26 = nodes5[r_5381]
			if ((type1(node26) == "list") and ((n1(node26) > 0) and ((type1((car1(node26))) == "symbol") and (car1(node26)["var"] == builtins1["import"])))) then
				if (r_5381 == n1(nodes5)) then
					nodes5[r_5381] = makeNil1()
				else
					removeNth_21_1(nodes5, r_5381)
				end
				r_5153["changed"] = true
			end
			return r_5371((r_5381 + -1))
		else
			return nil
		end
	end)
	return r_5371(n1(nodes5))
end)})
stripPure1 = ({["name"]="strip-pure",["help"]="Strip all pure expressions in NODES (apart from the last one).",["cat"]=({tag = "list", n = 1, "opt"}),["run"]=(function(r_5154, state13, nodes6)
	local r_5441 = nil
	r_5441 = (function(r_5451)
		if (r_5451 >= 1) then
			if sideEffect_3f_1((nodes6[r_5451])) then
			else
				removeNth_21_1(nodes6, r_5451)
				r_5154["changed"] = true
			end
			return r_5441((r_5451 + -1))
		else
			return nil
		end
	end)
	return r_5441((n1(nodes6) - 1))
end)})
constantFold1 = ({["name"]="constant-fold",["help"]="A primitive constant folder\n\nThis simply finds function calls with constant functions and looks up the function.\nIf the function is native and pure then we'll execute it and replace the node with the\nresult. There are a couple of caveats:\n\n - If the function call errors then we will flag a warning and continue.\n - If this returns a decimal (or infinity or NaN) then we'll continue: we cannot correctly\n   accurately handle this.\n - If this doesn't return exactly one value then we will stop. This might be a future enhancement.",["cat"]=({tag = "list", n = 1, "opt"}),["run"]=(function(r_5155, state14, nodes7)
	return traverseList1(nodes7, 1, (function(node27)
		if ((type1(node27) == "list") and fastAll1(constant_3f_1, node27, 2)) then
			local head1 = car1(node27)
			local meta1 = ((type1(head1) == "symbol") and (not head1["folded"] and ((head1["var"]["tag"] == "native") and state14["meta"][head1["var"]["fullName"]])))
			if (meta1 and (meta1["pure"] and meta1["value"])) then
				local res4 = list1(pcall1(meta1["value"], unpack1(map1(urn_2d3e_val1, cdr1(node27)), 1, (n1(node27) - 1))))
				if car1(res4) then
					local val12 = res4[2]
					if ((n1(res4) ~= 2) or (number_3f_1(val12) and ((car1(cdr1((list1(modf1(val12))))) ~= 0) or (abs1(val12) == huge1)))) then
						head1["folded"] = true
						return node27
					else
						r_5155["changed"] = true
						return val_2d3e_urn1(val12)
					end
				else
					head1["folded"] = true
					putNodeWarning_21_1(state14["logger"], _2e2e_2("Cannot execute constant expression"), node27, nil, getSource1(node27), _2e2e_2("Executed ", pretty1(node27), ", failed with: ", res4[2]))
					return node27
				end
			else
				return node27
			end
		else
			return node27
		end
	end))
end)})
condFold1 = ({["name"]="cond-fold",["help"]="Simplify all `cond` nodes, removing `false` branches and killing\nall branches after a `true` one.",["cat"]=({tag = "list", n = 1, "opt"}),["run"]=(function(r_5156, state15, nodes8)
	return traverseList1(nodes8, 1, (function(node28)
		if ((type1(node28) == "list") and ((type1((car1(node28))) == "symbol") and (car1(node28)["var"] == builtins1["cond"]))) then
			local final1 = false
			local i4 = 2
			local r_5591 = nil
			r_5591 = (function()
				if (i4 <= n1(node28)) then
					local elem6 = node28[i4]
					if final1 then
						r_5156["changed"] = true
						removeNth_21_1(node28, i4)
					else
						local r_5601 = urn_2d3e_bool1(car1(elem6))
						if eq_3f_1(r_5601, false) then
							r_5156["changed"] = true
							removeNth_21_1(node28, i4)
						elseif eq_3f_1(r_5601, true) then
							final1 = true
							i4 = (i4 + 1)
						elseif eq_3f_1(r_5601, nil) then
							i4 = (i4 + 1)
						else
							error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_5601), ", but none matched.\n", "  Tried: `false`\n  Tried: `true`\n  Tried: `nil`"))
						end
					end
					return r_5591()
				else
					return nil
				end
			end)
			r_5591()
			if ((n1(node28) == 2) and (urn_2d3e_bool1(car1(node28[2])) == true)) then
				r_5156["changed"] = true
				local body2 = cdr1(node28[2])
				if (n1(body2) == 1) then
					return car1(body2)
				else
					return makeProgn1(cdr1(node28[2]))
				end
			else
				return node28
			end
		else
			return node28
		end
	end))
end)})
lambdaFold1 = ({["name"]="lambda-fold",["help"]="Simplify all directly called lambdas, inlining them were appropriate.",["cat"]=({tag = "list", n = 1, "opt"}),["run"]=(function(r_5157, state16, nodes9)
	return traverseList1(nodes9, 1, (function(node29)
		if ((type1(node29) == "list") and ((n1(node29) == 1) and ((type1((car1(node29))) == "list") and (builtin_3f_1(car1(car1(node29)), "lambda") and ((n1(car1(node29)) == 3) and empty_3f_1(car1(node29)[2])))))) then
			r_5157["changed"] = true
			return car1(node29)[3]
		else
			return node29
		end
	end))
end)})
getConstantVal1 = (function(lookup2, sym2)
	local var16 = sym2["var"]
	local def2 = getVar1(lookup2, sym2["var"])
	if (var16 == builtins1["true"]) then
		return sym2
	elseif (var16 == builtins1["false"]) then
		return sym2
	elseif (var16 == builtins1["nil"]) then
		return sym2
	elseif (n1(def2["defs"]) == 1) then
		local ent1 = car1(def2["defs"])
		local val13 = ent1["value"]
		local ty3 = ent1["tag"]
		if (string_3f_1(val13) or (number_3f_1(val13) or (type1(val13) == "key"))) then
			return val13
		elseif ((type1(val13) == "symbol") and (ty3 == "val")) then
			return (getConstantVal1(lookup2, val13) or sym2)
		else
			return sym2
		end
	else
		return nil
	end
end)
stripDefs1 = ({["name"]="strip-defs",["help"]="Strip all unused top level definitions.",["cat"]=({tag = "list", n = 2, "opt", "usage"}),["run"]=(function(r_5158, state17, nodes10, lookup3)
	local r_5711 = nil
	r_5711 = (function(r_5721)
		if (r_5721 >= 1) then
			local node30 = nodes10[r_5721]
			if (node30["defVar"] and not getVar1(lookup3, node30["defVar"])["active"]) then
				if (r_5721 == n1(nodes10)) then
					nodes10[r_5721] = makeNil1()
				else
					removeNth_21_1(nodes10, r_5721)
				end
				r_5158["changed"] = true
			end
			return r_5711((r_5721 + -1))
		else
			return nil
		end
	end)
	return r_5711(n1(nodes10))
end)})
stripArgs1 = ({["name"]="strip-args",["help"]="Strip all unused, pure arguments in directly called lambdas.",["cat"]=({tag = "list", n = 2, "opt", "usage"}),["run"]=(function(r_5159, state18, nodes11, lookup4)
	return visitBlock1(nodes11, 1, (function(node31)
		if ((type1(node31) == "list") and ((type1((car1(node31))) == "list") and ((type1((car1(car1(node31)))) == "symbol") and (car1(car1(node31))["var"] == builtins1["lambda"])))) then
			local lam2 = car1(node31)
			local args6 = lam2[2]
			local offset2 = 1
			local remOffset1 = 0
			local removed1 = ({})
			local r_5811 = n1(args6)
			local r_5791 = nil
			r_5791 = (function(r_5801)
				if (r_5801 <= r_5811) then
					local arg21 = args6[((r_5801 - remOffset1))]
					local val14 = node31[(((r_5801 + offset2) - remOffset1))]
					if arg21["var"]["isVariadic"] then
						local count2 = (n1(node31) - n1(args6))
						if (count2 < 0) then
							count2 = 0
						end
						offset2 = count2
					elseif (nil == val14) then
					elseif sideEffect_3f_1(val14) then
					elseif (n1(getVar1(lookup4, arg21["var"])["usages"]) > 0) then
					else
						r_5159["changed"] = true
						removed1[args6[((r_5801 - remOffset1))]["var"]] = true
						removeNth_21_1(args6, (r_5801 - remOffset1))
						removeNth_21_1(node31, ((r_5801 + offset2) - remOffset1))
						remOffset1 = (remOffset1 + 1)
					end
					return r_5791((r_5801 + 1))
				else
					return nil
				end
			end)
			r_5791(1)
			if (remOffset1 > 0) then
				return traverseList1(lam2, 3, (function(node32)
					if ((type1(node32) == "list") and (builtin_3f_1(car1(node32), "set!") and removed1[node32[2]["var"]])) then
						local val15 = node32[3]
						if sideEffect_3f_1(val15) then
							return makeProgn1(list1(val15, makeNil1()))
						else
							return makeNil1()
						end
					else
						return node32
					end
				end))
			else
				return nil
			end
		else
			return nil
		end
	end))
end)})
variableFold1 = ({["name"]="variable-fold",["help"]="Folds constant variable accesses",["cat"]=({tag = "list", n = 2, "opt", "usage"}),["run"]=(function(r_51510, state19, nodes12, lookup5)
	return traverseList1(nodes12, 1, (function(node33)
		if (type1(node33) == "symbol") then
			local var17 = getConstantVal1(lookup5, node33)
			if (var17 and (var17 ~= node33)) then
				r_51510["changed"] = true
				return var17
			else
				return node33
			end
		else
			return node33
		end
	end))
end)})
expressionFold1 = ({["name"]="expression-fold",["help"]="Folds basic variable accesses where execution order will not change.\n\nFor instance, converts ((lambda (x) (+ x 1)) (Y)) to (+ Y 1) in the case\nwhere Y is an arbitrary expression.\n\nThere are a couple of complexities in the implementation here. Firstly, we\nwant to ensure that the arguments are executed in the correct order and only\nonce.\n\nIn order to achieve this, we find the lambda forms and visit the body, stopping\nif we visit arguments in the wrong order or non-constant terms such as mutable\nvariables or other function calls. For simplicities sake, we fail if we hit\nother lambdas or conds as that makes analysing control flow significantly more\ncomplex.\n\nAnother source of added complexity is the case where where Y could return multiple\nvalues: namely in the last argument to function calls. Here it is an invalid optimisation\nto just place Y, as that could result in additional values being passed to the function.\n\nIn order to avoid this, Y will get converted to the form ((lambda (<tmp>) <tmp>) Y).\nThis is understood by the codegen and so is not as inefficient as it looks. However, we do\nhave to take additional steps to avoid trying to fold the above again and again.",["cat"]=({tag = "list", n = 2, "opt", "usage"}),["run"]=(function(r_51511, state20, nodes13, lookup6)
	return visitBlock1(nodes13, 1, (function(root1)
		if ((type1(root1) == "list") and ((type1((car1(root1))) == "list") and ((type1((car1(car1(root1)))) == "symbol") and (car1(car1(root1))["var"] == builtins1["lambda"])))) then
			local lam3
			local args7
			local len5
			local validate1
			lam3 = car1(root1)
			args7 = lam3[2]
			len5 = n1(args7)
			validate1 = (function(i5)
				if (i5 > len5) then
					return true
				else
					local arg22 = args7[i5]
					local var18 = arg22["var"]
					local entry2 = getVar1(lookup6, var18)
					if var18["isVariadic"] then
						return false
					elseif (n1(entry2["defs"]) ~= 1) then
						return false
					elseif (car1(entry2["defs"])["tag"] == "var") then
						return false
					elseif (n1(entry2["usages"]) ~= 1) then
						return false
					else
						return validate1((i5 + 1))
					end
				end
			end)
			if ((len5 > 0) and (((n1(root1) ~= 2) or ((len5 ~= 1) or ((n1(lam3) ~= 3) or (atom_3f_1(root1[2]) or (not (type1((lam3[3])) == "symbol") or (lam3[3]["var"] ~= car1(args7)["var"])))))) and validate1(1))) then
				local currentIdx1 = 1
				local argMap1 = ({})
				local wrapMap1 = ({})
				local ok2 = true
				local finished1 = false
				local r_6281 = n1(args7)
				local r_6261 = nil
				r_6261 = (function(r_6271)
					if (r_6271 <= r_6281) then
						argMap1[args7[r_6271]["var"]] = r_6271
						return r_6261((r_6271 + 1))
					else
						return nil
					end
				end)
				r_6261(1)
				visitBlock1(lam3, 3, (function(node34, visitor9)
					if ok2 then
						local r_6301 = type1(node34)
						if (r_6301 == "string") then
							return nil
						elseif (r_6301 == "number") then
							return nil
						elseif (r_6301 == "key") then
							return nil
						elseif (r_6301 == "symbol") then
							local idx5 = argMap1[node34["var"]]
							if (idx5 == nil) then
								if (n1(getVar1(lookup6, node34["var"])["defs"]) > 1) then
									ok2 = false
									return false
								else
									return nil
								end
							elseif (idx5 == currentIdx1) then
								currentIdx1 = (currentIdx1 + 1)
								if (currentIdx1 > len5) then
									finished1 = true
									return nil
								else
									return nil
								end
							else
								ok2 = false
								return false
							end
						elseif (r_6301 == "list") then
							local head2 = car1(node34)
							if (type1(head2) == "symbol") then
								local var19 = head2["var"]
								if (var19 == builtins1["set!"]) then
									visitNode1(node34[3], visitor9)
								elseif (var19 == builtins1["define"]) then
									visitNode1(last1(node34), visitor9)
								elseif (var19 == builtins1["define-macro"]) then
									visitNode1(last1(node34), visitor9)
								elseif (var19 == builtins1["define-native"]) then
								elseif (var19 == builtins1["cond"]) then
									visitNode1(car1(node34[2]), visitor9)
								elseif (var19 == builtins1["lambda"]) then
								elseif (var19 == builtins1["quote"]) then
								elseif (var19 == builtins1["import"]) then
								elseif (var19 == builtins1["syntax-quote"]) then
									visitQuote1(node34[2], visitor9, 1)
								elseif (var19 == builtins1["struct-literal"]) then
									visitBlock1(node34, 2, visitor9)
								else
									visitBlock1(node34, 1, visitor9)
								end
								if (n1(node34) > 1) then
									local last2 = node34[(n1(node34))]
									if (type1(last2) == "symbol") then
										local idx6 = argMap1[last2["var"]]
										if idx6 then
											if (type1(((root1[(idx6 + 1)]))) == "list") then
												wrapMap1[idx6] = true
											end
										end
									end
								end
								if finished1 then
								elseif (var19 == builtins1["set!"]) then
									ok2 = false
								elseif (var19 == builtins1["cond"]) then
									ok2 = false
								elseif (var19 == builtins1["lambda"]) then
									ok2 = false
								else
									ok2 = false
								end
								return false
							else
								ok2 = false
								return false
							end
						else
							return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_6301), ", but none matched.\n", "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"key\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`"))
						end
					else
						return false
					end
				end))
				if (ok2 and finished1) then
					r_51511["changed"] = true
					traverseList1(root1, 1, (function(child2)
						if (type1(child2) == "symbol") then
							local var20 = child2["var"]
							local i6 = argMap1[var20]
							if i6 then
								if wrapMap1[i6] then
									return ({tag = "list", n = 2, ({tag = "list", n = 3, (function(var21)
										return ({["tag"]="symbol",["contents"]=var21["name"],["var"]=var21})
									end)(builtins1["lambda"]), ({tag = "list", n = 1, ({["tag"]="symbol",["contents"]=var20["name"],["var"]=var20})}), ({["tag"]="symbol",["contents"]=var20["name"],["var"]=var20})}), root1[((i6 + 1))]})
								else
									return (root1[((i6 + 1))] or makeNil1())
								end
							else
								return child2
							end
						else
							return child2
						end
					end))
					local r_6331 = nil
					r_6331 = (function(r_6341)
						if (r_6341 >= 2) then
							removeNth_21_1(root1, r_6341)
							return r_6331((r_6341 + -1))
						else
							return nil
						end
					end)
					r_6331(n1(root1))
					local r_6371 = nil
					r_6371 = (function(r_6381)
						if (r_6381 >= 1) then
							removeNth_21_1(args7, r_6381)
							return r_6371((r_6381 + -1))
						else
							return nil
						end
					end)
					return r_6371(n1(args7))
				else
					return nil
				end
			else
				return nil
			end
		else
			return nil
		end
	end))
end)})
condEliminate1 = ({["name"]="cond-eliminate",["help"]="Replace variables with known truthy/falsey values with `true` or `false` when used in branches.",["cat"]=({tag = "list", n = 2, "opt", "usage"}),["run"]=(function(r_51512, state21, nodes14, varLookup1)
	local lookup7 = ({})
	return visitBlock1(nodes14, 1, (function(node35, visitor10, isCond1)
		local r_5891 = type1(node35)
		if (r_5891 == "symbol") then
			if isCond1 then
				local r_5901 = lookup7[node35["var"]]
				if eq_3f_1(r_5901, false) then
					local var22 = builtins1["false"]
					return ({["tag"]="symbol",["contents"]=var22["name"],["var"]=var22})
				elseif eq_3f_1(r_5901, true) then
					local var23 = builtins1["true"]
					return ({["tag"]="symbol",["contents"]=var23["name"],["var"]=var23})
				else
					return nil
				end
			else
				return nil
			end
		elseif (r_5891 == "list") then
			local head3 = car1(node35)
			local r_5911 = type1(head3)
			if (r_5911 == "symbol") then
				if builtin_3f_1(head3, "cond") then
					local vars1 = ({tag = "list", n = 0})
					local r_5941 = n1(node35)
					local r_5921 = nil
					r_5921 = (function(r_5931)
						if (r_5931 <= r_5941) then
							local entry3 = node35[r_5931]
							local test1 = car1(entry3)
							local len6 = n1(entry3)
							local var24 = ((type1(test1) == "symbol") and test1["var"])
							if var24 then
								if (lookup7[var24] ~= nil) then
									var24 = nil
								elseif (n1(getVar1(varLookup1, var24)["defs"]) > 1) then
									var24 = nil
								end
							end
							local r_5961 = visitor10(test1, visitor10, true)
							if eq_3f_1(r_5961, nil) then
								visitNode1(test1, visitor10)
							elseif eq_3f_1(r_5961, false) then
							else
								r_51512["changed"] = true
								entry3[1] = r_5961
							end
							if var24 then
								pushCdr_21_1(vars1, var24)
								lookup7[var24] = true
							end
							local r_5991 = (len6 - 1)
							local r_5971 = nil
							r_5971 = (function(r_5981)
								if (r_5981 <= r_5991) then
									visitNode1(entry3[r_5981], visitor10)
									return r_5971((r_5981 + 1))
								else
									return nil
								end
							end)
							r_5971(2)
							if (len6 > 1) then
								local last3 = entry3[len6]
								local r_6011 = visitor10(last3, visitor10, isCond1)
								if eq_3f_1(r_6011, nil) then
									visitNode1(last3, visitor10)
								elseif eq_3f_1(r_6011, false) then
								else
									r_51512["changed"] = true
									entry3[len6] = r_6011
								end
							end
							if var24 then
								lookup7[var24] = false
							end
							return r_5921((r_5931 + 1))
						else
							return nil
						end
					end)
					r_5921(2)
					local r_6071 = n1(vars1)
					local r_6051 = nil
					r_6051 = (function(r_6061)
						if (r_6061 <= r_6071) then
							lookup7[vars1[r_6061]] = nil
							return r_6051((r_6061 + 1))
						else
							return nil
						end
					end)
					r_6051(1)
					return false
				else
					return nil
				end
			elseif (r_5911 == "list") then
				if (isCond1 and builtin_3f_1(car1(head3), "lambda")) then
					local r_6121 = n1(node35)
					local r_6101 = nil
					r_6101 = (function(r_6111)
						if (r_6111 <= r_6121) then
							visitNode1(node35[r_6111], visitor10)
							return r_6101((r_6111 + 1))
						else
							return nil
						end
					end)
					r_6101(2)
					local len7 = n1(head3)
					local r_6161 = (len7 - 1)
					local r_6141 = nil
					r_6141 = (function(r_6151)
						if (r_6151 <= r_6161) then
							visitNode1(head3[r_6151], visitor10)
							return r_6141((r_6151 + 1))
						else
							return nil
						end
					end)
					r_6141(3)
					if (len7 > 2) then
						local last4 = head3[len7]
						local r_6181 = visitor10(last4, visitor10, isCond1)
						if eq_3f_1(r_6181, nil) then
							visitNode1(last4, visitor10)
						elseif eq_3f_1(r_6181, false) then
						else
							r_51512["changed"] = true
							node35[head3] = r_6181
						end
					end
					return false
				else
					return nil
				end
			else
				return nil
			end
		else
			return nil
		end
	end))
end)})
copyOf1 = (function(x24)
	local res5 = ({})
	iterPairs1(x24, (function(k3, v4)
		res5[k3] = v4
		return nil
	end))
	return res5
end)
getScope1 = (function(scope8, lookup8, n2)
	local newScope1 = lookup8["scopes"][scope8]
	if newScope1 then
		return newScope1
	else
		local newScope2 = child1()
		lookup8["scopes"][scope8] = newScope2
		return newScope2
	end
end)
getVar2 = (function(var25, lookup9)
	return (lookup9["vars"][var25] or var25)
end)
copyNode1 = (function(node36, lookup10)
	local r_6421 = type1(node36)
	if (r_6421 == "string") then
		return copyOf1(node36)
	elseif (r_6421 == "key") then
		return copyOf1(node36)
	elseif (r_6421 == "number") then
		return copyOf1(node36)
	elseif (r_6421 == "symbol") then
		local copy1 = copyOf1(node36)
		local oldVar1 = node36["var"]
		local newVar1 = getVar2(oldVar1, lookup10)
		if ((oldVar1 ~= newVar1) and (oldVar1["node"] == node36)) then
			newVar1["node"] = copy1
		end
		copy1["var"] = newVar1
		return copy1
	elseif (r_6421 == "list") then
		if builtin_3f_1(car1(node36), "lambda") then
			local args8 = car1(cdr1(node36))
			if empty_3f_1(args8) then
			else
				local newScope3 = child1(getScope1(car1(args8)["var"]["scope"], lookup10, node36))
				local r_6561 = n1(args8)
				local r_6541 = nil
				r_6541 = (function(r_6551)
					if (r_6551 <= r_6561) then
						local arg23 = args8[r_6551]
						local var26 = arg23["var"]
						local newVar2 = add_21_1(newScope3, var26["name"], var26["tag"], nil)
						newVar2["isVariadic"] = var26["isVariadic"]
						lookup10["vars"][var26] = newVar2
						return r_6541((r_6551 + 1))
					else
						return nil
					end
				end)
				r_6541(1)
			end
		end
		local res6 = copyOf1(node36)
		local r_6601 = n1(res6)
		local r_6581 = nil
		r_6581 = (function(r_6591)
			if (r_6591 <= r_6601) then
				res6[r_6591] = copyNode1(res6[r_6591], lookup10)
				return r_6581((r_6591 + 1))
			else
				return nil
			end
		end)
		r_6581(1)
		return res6
	else
		return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_6421), ", but none matched.\n", "  Tried: `\"string\"`\n  Tried: `\"key\"`\n  Tried: `\"number\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`"))
	end
end)
scoreNode1 = (function(node37)
	local r_6441 = type1(node37)
	if (r_6441 == "string") then
		return 0
	elseif (r_6441 == "key") then
		return 0
	elseif (r_6441 == "number") then
		return 0
	elseif (r_6441 == "symbol") then
		return 1
	elseif (r_6441 == "list") then
		if (type1(car1(node37)) == "symbol") then
			local func5 = car1(node37)["var"]
			if (func5 == builtins1["lambda"]) then
				return scoreNodes1(node37, 3, 10)
			elseif (func5 == builtins1["cond"]) then
				return scoreNodes1(node37, 2, 10)
			elseif (func5 == builtins1["set!"]) then
				return scoreNodes1(node37, 2, 5)
			elseif (func5 == builtins1["quote"]) then
				return scoreNodes1(node37, 2, 2)
			elseif (func5 == builtins1["quasi-quote"]) then
				return scoreNodes1(node37, 2, 3)
			elseif (func5 == builtins1["unquote-splice"]) then
				return scoreNodes1(node37, 2, 10)
			else
				return scoreNodes1(node37, 1, (n1(node37) + 1))
			end
		else
			return scoreNodes1(node37, 1, (n1(node37) + 1))
		end
	else
		return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_6441), ", but none matched.\n", "  Tried: `\"string\"`\n  Tried: `\"key\"`\n  Tried: `\"number\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`"))
	end
end)
getScore1 = (function(lookup11, node38)
	local score1 = lookup11[node38]
	if (score1 == nil) then
		score1 = 0
		local r_6471 = node38[2]
		local r_6501 = n1(r_6471)
		local r_6481 = nil
		r_6481 = (function(r_6491)
			if (r_6491 <= r_6501) then
				if r_6471[r_6491]["var"]["isVariadic"] then
					score1 = false
				end
				return r_6481((r_6491 + 1))
			else
				return nil
			end
		end)
		r_6481(1)
		if score1 then
			score1 = scoreNodes1(node38, 3, score1)
		end
		lookup11[node38] = score1
	end
	return (score1 or huge1)
end)
scoreNodes1 = (function(nodes15, start5, sum1)
	if (start5 > n1(nodes15)) then
		return sum1
	else
		local score2 = scoreNode1(nodes15[start5])
		if score2 then
			if (score2 > 20) then
				return score2
			else
				return scoreNodes1(nodes15, (start5 + 1), (sum1 + score2))
			end
		else
			return false
		end
	end
end)
inline1 = ({["name"]="inline",["help"]="Inline simple functions.",["cat"]=({tag = "list", n = 2, "opt", "usage"}),["level"]=2,["run"]=(function(r_51513, state22, nodes16, usage2)
	local scoreLookup1 = ({})
	return visitBlock1(nodes16, 1, (function(node39)
		if ((type1(node39) == "list") and (type1((car1(node39))) == "symbol")) then
			local func6 = car1(node39)["var"]
			local def3 = getVar1(usage2, func6)
			if (n1(def3["defs"]) == 1) then
				local ent2 = car1(def3["defs"])
				local val16 = ent2["value"]
				if ((type1(val16) == "list") and (builtin_3f_1(car1(val16), "lambda") and (getScore1(scoreLookup1, val16) <= 20))) then
					local copy2 = copyNode1(val16, ({["scopes"]=({}),["vars"]=({}),["root"]=func6["scope"]}))
					node39[1] = copy2
					r_51513["changed"] = true
					return nil
				else
					return nil
				end
			else
				return nil
			end
		else
			return nil
		end
	end))
end)})
optimiseOnce1 = (function(nodes17, state23)
	local tracker2 = ({["changed"]=false})
	local r_3581 = state23["pass"]["normal"]
	local r_3611 = n1(r_3581)
	local r_3591 = nil
	r_3591 = (function(r_3601)
		if (r_3601 <= r_3611) then
			runPass1(r_3581[r_3601], state23, tracker2, nodes17)
			return r_3591((r_3601 + 1))
		else
			return nil
		end
	end)
	r_3591(1)
	local lookup12 = ({["vars"]=({}),["nodes"]=({})})
	runPass1(tagUsage1, state23, tracker2, nodes17, lookup12)
	local r_6661 = state23["pass"]["usage"]
	local r_6691 = n1(r_6661)
	local r_6671 = nil
	r_6671 = (function(r_6681)
		if (r_6681 <= r_6691) then
			runPass1(r_6661[r_6681], state23, tracker2, nodes17, lookup12)
			return r_6671((r_6681 + 1))
		else
			return nil
		end
	end)
	r_6671(1)
	return tracker2["changed"]
end)
optimise1 = (function(nodes18, state24)
	local maxN1 = state24["max-n"]
	local maxT1 = state24["max-time"]
	local iteration1 = 0
	local finish1 = (clock1() + maxT1)
	local changed1 = true
	local r_3631 = nil
	r_3631 = (function()
		if (changed1 and (((maxN1 < 0) or (iteration1 < maxN1)) and ((maxT1 < 0) or (clock1() < finish1)))) then
			changed1 = optimiseOnce1(nodes18, state24)
			iteration1 = (iteration1 + 1)
			return r_3631()
		else
			return nil
		end
	end)
	return r_3631()
end)
default1 = (function()
	return ({["normal"]=list1(stripImport1, stripPure1, constantFold1, condFold1, lambdaFold1, fusion1),["usage"]=list1(stripDefs1, stripArgs1, variableFold1, condEliminate1, expressionFold1, inline1)})
end)
tokens1 = ({tag = "list", n = 7, ({tag = "list", n = 2, "arg", "(%f[%a]%u+%f[%A])"}), ({tag = "list", n = 2, "mono", "```[a-z]*\n([^`]*)\n```"}), ({tag = "list", n = 2, "mono", "`([^`]*)`"}), ({tag = "list", n = 2, "bolic", "(%*%*%*%w.-%w%*%*%*)"}), ({tag = "list", n = 2, "bold", "(%*%*%w.-%w%*%*)"}), ({tag = "list", n = 2, "italic", "(%*%w.-%w%*)"}), ({tag = "list", n = 2, "link", "%[%[(.-)%]%]"})})
extractSignature1 = (function(var27)
	local ty4 = type1(var27)
	if ((ty4 == "macro") or (ty4 == "defined")) then
		local root2 = var27["node"]
		local node40 = root2[(n1(root2))]
		if ((type1(node40) == "list") and ((type1((car1(node40))) == "symbol") and (car1(node40)["var"] == builtins1["lambda"]))) then
			return node40[2]
		else
			return nil
		end
	else
		return nil
	end
end)
parseDocstring1 = (function(str3)
	local out11 = ({tag = "list", n = 0})
	local pos7 = 1
	local len8 = n1(str3)
	local r_6811 = nil
	r_6811 = (function()
		if (pos7 <= len8) then
			local spos1 = len8
			local epos1 = nil
			local name17 = nil
			local ptrn3 = nil
			local r_6861 = n1(tokens1)
			local r_6841 = nil
			r_6841 = (function(r_6851)
				if (r_6851 <= r_6861) then
					local tok1 = tokens1[r_6851]
					local npos1 = list1(find1(str3, tok1[2], pos7))
					if (car1(npos1) and (car1(npos1) < spos1)) then
						spos1 = car1(npos1)
						epos1 = npos1[2]
						name17 = car1(tok1)
						ptrn3 = tok1[2]
					end
					return r_6841((r_6851 + 1))
				else
					return nil
				end
			end)
			r_6841(1)
			if name17 then
				if (pos7 < spos1) then
					pushCdr_21_1(out11, ({["tag"]="text",["contents"]=sub1(str3, pos7, (spos1 - 1))}))
				end
				pushCdr_21_1(out11, ({["tag"]=name17,["whole"]=sub1(str3, spos1, epos1),["contents"]=match1(sub1(str3, spos1, epos1), ptrn3)}))
				pos7 = (epos1 + 1)
			else
				pushCdr_21_1(out11, ({["tag"]="text",["contents"]=sub1(str3, pos7, len8)}))
				pos7 = (len8 + 1)
			end
			return r_6811()
		else
			return nil
		end
	end)
	r_6811()
	return out11
end)
checkArity1 = ({["name"]="check-arity",["help"]="Produce a warning if any NODE in NODES calls a function with too many arguments.\n\nLOOKUP is the variable usage lookup table.",["cat"]=({tag = "list", n = 2, "warn", "usage"}),["run"]=(function(r_51514, state25, nodes19, lookup13)
	local arity1
	local getArity1
	arity1 = ({})
	getArity1 = (function(symbol3)
		local var28 = getVar1(lookup13, symbol3["var"])
		local ari1 = arity1[var28]
		if (ari1 ~= nil) then
			return ari1
		elseif (n1(var28["defs"]) ~= 1) then
			return false
		else
			arity1[var28] = false
			local defData1 = car1(var28["defs"])
			local def4 = defData1["value"]
			if (defData1["tag"] == "var") then
				ari1 = false
			else
				if (type1(def4) == "symbol") then
					ari1 = getArity1(def4)
				elseif ((type1(def4) == "list") and ((type1((car1(def4))) == "symbol") and (car1(def4)["var"] == builtins1["lambda"]))) then
					local args9 = def4[2]
					if any1((function(x25)
						return x25["var"]["isVariadic"]
					end), args9) then
						ari1 = false
					else
						ari1 = n1(args9)
					end
				else
					ari1 = false
				end
			end
			arity1[var28] = ari1
			return ari1
		end
	end)
	return visitBlock1(nodes19, 1, (function(node41)
		if ((type1(node41) == "list") and (type1((car1(node41))) == "symbol")) then
			local arity2 = getArity1(car1(node41))
			if (arity2 and (arity2 < (n1(node41) - 1))) then
				return putNodeWarning_21_1(state25["logger"], _2e2e_2("Calling ", symbol_2d3e_string1(car1(node41)), " with ", tonumber1((n1(node41) - 1)), " arguments, expected ", tonumber1(arity2)), node41, nil, getSource1(node41), "Called here")
			else
				return nil
			end
		else
			return nil
		end
	end))
end)})
deprecated1 = ({["name"]="deprecated",["help"]="Produce a warning whenever a deprecated variable is used.",["cat"]=({tag = "list", n = 2, "warn", "usage"}),["run"]=(function(r_51515, state26, nodes20, lookup14)
	local r_6971 = n1(nodes20)
	local r_6951 = nil
	r_6951 = (function(r_6961)
		if (r_6961 <= r_6971) then
			local node42 = nodes20[r_6961]
			local defVar1 = node42["defVar"]
			visitNode1(node42, (function(node43)
				if (type1(node43) == "symbol") then
					local var29 = node43["var"]
					if ((var29 ~= defVar1) and var29["deprecated"]) then
						return putNodeWarning_21_1(state26["logger"], (function()
							if string_3f_1(var29["deprecated"]) then
								return format1("%s is deprecated: %s", node43["contents"], var29["deprecated"])
							else
								return format1("%s is deprecated.", node43["contents"])
							end
						end)()
						, node43, nil, getSource1(node43), "")
					else
						return nil
					end
				else
					return nil
				end
			end))
			return r_6951((r_6961 + 1))
		else
			return nil
		end
	end)
	return r_6951(1)
end)})
documentation1 = ({["name"]="documentation",["help"]="Ensure doc comments are valid.",["cat"]=({tag = "list", n = 1, "warn"}),["run"]=(function(r_51516, state27, nodes21)
	local r_7041 = n1(nodes21)
	local r_7021 = nil
	r_7021 = (function(r_7031)
		if (r_7031 <= r_7041) then
			local node44 = nodes21[r_7031]
			local var30 = node44["defVar"]
			if var30 then
				local doc1 = var30["doc"]
				if doc1 then
					local r_7131 = parseDocstring1(doc1)
					local r_7161 = n1(r_7131)
					local r_7141 = nil
					r_7141 = (function(r_7151)
						if (r_7151 <= r_7161) then
							local tok2 = r_7131[r_7151]
							if (type1(tok2) == "link") then
								if get1(var30["scope"], tok2["contents"]) then
								else
									putNodeWarning_21_1(state27["logger"], format1("%s is not defined.", quoted1(tok2["contents"])), node44, nil, getSource1(node44), "Referenced in docstring.")
								end
							end
							return r_7141((r_7151 + 1))
						else
							return nil
						end
					end)
					r_7141(1)
				else
				end
			else
			end
			return r_7021((r_7031 + 1))
		else
			return nil
		end
	end)
	return r_7021(1)
end)})
analyse1 = (function(nodes22, state28)
	local r_6731 = state28["pass"]["normal"]
	local r_6761 = n1(r_6731)
	local r_6741 = nil
	r_6741 = (function(r_6751)
		if (r_6751 <= r_6761) then
			runPass1(r_6731[r_6751], state28, nil, nodes22)
			return r_6741((r_6751 + 1))
		else
			return nil
		end
	end)
	r_6741(1)
	local lookup15 = ({["vars"]=({}),["nodes"]=({})})
	runPass1(tagUsage1, state28, nil, nodes22, lookup15)
	local r_7071 = state28["pass"]["usage"]
	local r_7101 = n1(r_7071)
	local r_7081 = nil
	r_7081 = (function(r_7091)
		if (r_7091 <= r_7101) then
			runPass1(r_7071[r_7091], state28, nil, nodes22, lookup15)
			return r_7081((r_7091 + 1))
		else
			return nil
		end
	end)
	return r_7081(1)
end)
create3 = (function()
	return ({["out"]=({tag = "list", n = 0}),["indent"]=0,["tabs-pending"]=false,["line"]=1,["lines"]=({}),["node-stack"]=({tag = "list", n = 0}),["active-pos"]=nil})
end)
append_21_1 = (function(writer1, text2)
	local r_7291 = type1(text2)
	if (r_7291 ~= "string") then
		error1(format1("bad argument %s (expected %s, got %s)", "text", "string", r_7291), 2)
	end
	local pos8 = writer1["active-pos"]
	if pos8 then
		local line1 = writer1["lines"][writer1["line"]]
		if line1 then
		else
			line1 = ({})
			writer1["lines"][writer1["line"]] = line1
		end
		line1[pos8] = true
	end
	if writer1["tabs-pending"] then
		writer1["tabs-pending"] = false
		pushCdr_21_1(writer1["out"], rep1("\9", writer1["indent"]))
	end
	return pushCdr_21_1(writer1["out"], text2)
end)
line_21_1 = (function(writer2, text3, force1)
	if text3 then
		append_21_1(writer2, text3)
	end
	if (force1 or not writer2["tabs-pending"]) then
		writer2["tabs-pending"] = true
		writer2["line"] = (writer2["line"] + 1)
		return pushCdr_21_1(writer2["out"], "\n")
	else
		return nil
	end
end)
indent_21_1 = (function(writer3)
	writer3["indent"] = (writer3["indent"] + 1)
	return nil
end)
unindent_21_1 = (function(writer4)
	writer4["indent"] = (writer4["indent"] - 1)
	return nil
end)
beginBlock_21_1 = (function(writer5, text4)
	line_21_1(writer5, text4)
	writer5["indent"] = (writer5["indent"] + 1)
	return nil
end)
nextBlock_21_1 = (function(writer6, text5)
	writer6["indent"] = (writer6["indent"] - 1)
	line_21_1(writer6, text5)
	writer6["indent"] = (writer6["indent"] + 1)
	return nil
end)
endBlock_21_1 = (function(writer7, text6)
	writer7["indent"] = (writer7["indent"] - 1)
	return line_21_1(writer7, text6)
end)
pushNode_21_1 = (function(writer8, node45)
	local range2 = getSource1(node45)
	if range2 then
		pushCdr_21_1(writer8["node-stack"], node45)
		writer8["active-pos"] = range2
		return nil
	else
		return nil
	end
end)
popNode_21_1 = (function(writer9, node46)
	if getSource1(node46) then
		local stack1 = writer9["node-stack"]
		local previous2 = last1(stack1)
		if (previous2 == node46) then
		else
			error1("Incorrect node popped")
		end
		popLast_21_1(stack1)
		writer9["arg-pos"] = last1(stack1)
		return nil
	else
		return nil
	end
end)
estimateLength1 = (function(node47, max4)
	local tag8 = node47["tag"]
	if ((tag8 == "string") or ((tag8 == "number") or ((tag8 == "symbol") or (tag8 == "key")))) then
		return n1(tostring1(node47["contents"]))
	elseif (tag8 == "list") then
		local sum2 = 2
		local i7 = 1
		local r_7211 = nil
		r_7211 = (function()
			if ((sum2 <= max4) and (i7 <= n1(node47))) then
				sum2 = (sum2 + estimateLength1(node47[i7], (max4 - sum2)))
				if (i7 > 1) then
					sum2 = (sum2 + 1)
				end
				i7 = (i7 + 1)
				return r_7211()
			else
				return nil
			end
		end)
		r_7211()
		return sum2
	else
		return error1(_2e2e_2("Unknown tag ", tag8), 0)
	end
end)
expression1 = (function(node48, writer10)
	local tag9 = node48["tag"]
	if (tag9 == "string") then
		return append_21_1(writer10, quoted1(node48["value"]))
	elseif (tag9 == "number") then
		return append_21_1(writer10, tostring1(node48["value"]))
	elseif (tag9 == "key") then
		return append_21_1(writer10, _2e2e_2(":", node48["value"]))
	elseif (tag9 == "symbol") then
		return append_21_1(writer10, node48["contents"])
	elseif (tag9 == "list") then
		append_21_1(writer10, "(")
		if empty_3f_1(node48) then
			return append_21_1(writer10, ")")
		else
			local newline1 = false
			local max5 = (60 - estimateLength1(car1(node48), 60))
			expression1(car1(node48), writer10)
			if (max5 <= 0) then
				newline1 = true
				writer10["indent"] = (writer10["indent"] + 1)
			end
			local r_7331 = n1(node48)
			local r_7311 = nil
			r_7311 = (function(r_7321)
				if (r_7321 <= r_7331) then
					local entry4 = node48[r_7321]
					if (not newline1 and (max5 > 0)) then
						max5 = (max5 - estimateLength1(entry4, max5))
						if (max5 <= 0) then
							newline1 = true
							writer10["indent"] = (writer10["indent"] + 1)
						end
					end
					if newline1 then
						line_21_1(writer10)
					else
						append_21_1(writer10, " ")
					end
					expression1(entry4, writer10)
					return r_7311((r_7321 + 1))
				else
					return nil
				end
			end)
			r_7311(2)
			if newline1 then
				writer10["indent"] = (writer10["indent"] - 1)
			end
			return append_21_1(writer10, ")")
		end
	else
		return error1(_2e2e_2("Unknown tag ", tag9), 0)
	end
end)
block1 = (function(list4, writer11)
	local r_7271 = n1(list4)
	local r_7251 = nil
	r_7251 = (function(r_7261)
		if (r_7261 <= r_7271) then
			expression1(list4[r_7261], writer11)
			line_21_1(writer11)
			return r_7251((r_7261 + 1))
		else
			return nil
		end
	end)
	return r_7251(1)
end)
cat3 = (function(category1, ...)
	local args10 = _pack(...) args10.tag = "list"
	return struct1("category", category1, unpack1(args10, 1, n1(args10)))
end)
partAll1 = (function(xs13, i8, e1, f3)
	while true do
		if (i8 > e1) then
			return true
		elseif f3(xs13[i8]) then
			i8 = (i8 + 1)
		else
			return false
		end
	end
end)
visitNode2 = (function(lookup16, node49, stmt1, test2, recur1)
	local cat4
	local r_7461 = type1(node49)
	if (r_7461 == "string") then
		cat4 = cat3("const")
	elseif (r_7461 == "number") then
		cat4 = cat3("const")
	elseif (r_7461 == "key") then
		cat4 = cat3("const")
	elseif (r_7461 == "symbol") then
		cat4 = cat3("const")
	elseif (r_7461 == "list") then
		local head4 = car1(node49)
		local r_7471 = type1(head4)
		if (r_7471 == "symbol") then
			local func7 = head4["var"]
			local funct3 = func7["tag"]
			if (func7 == builtins1["lambda"]) then
				visitNodes1(lookup16, node49, 3, true)
				cat4 = cat3("lambda")
			elseif (func7 == builtins1["cond"]) then
				local r_7761 = n1(node49)
				local r_7741 = nil
				r_7741 = (function(r_7751)
					if (r_7751 <= r_7761) then
						local case3 = node49[r_7751]
						visitNode2(lookup16, car1(case3), true, true)
						visitNodes1(lookup16, case3, 2, true, test2, recur1)
						return r_7741((r_7751 + 1))
					else
						return nil
					end
				end)
				r_7741(2)
				local temp6
				if (n1(node49) == 3) then
					local temp7
					local sub2 = node49[2]
					temp7 = ((n1(sub2) == 2) and builtin_3f_1(sub2[2], "false"))
					if temp7 then
						local sub3 = node49[3]
						temp6 = ((n1(sub3) == 2) and (builtin_3f_1(sub3[1], "true") and builtin_3f_1(sub3[2], "true")))
					else
						temp6 = false
					end
				else
					temp6 = false
				end
				if temp6 then
					cat4 = cat3("not", "stmt", lookup16[car1(node49[2])]["stmt"])
				else
					local temp8
					if (n1(node49) == 3) then
						local first6 = node49[2]
						local second1 = node49[3]
						local branch1 = car1(first6)
						local last5 = second1[2]
						temp8 = ((n1(first6) == 2) and ((n1(second1) == 2) and (not lookup16[first6[2]]["stmt"] and (builtin_3f_1(car1(second1), "true") and ((type1(last5) == "symbol") and (((type1(branch1) == "symbol") and (branch1["var"] == last5["var"])) or (test2 and (not lookup16[branch1]["stmt"] and (last5["var"] == builtins1["false"])))))))))
					else
						temp8 = false
					end
					if temp8 then
						cat4 = cat3("and")
					else
						local temp9
						if (n1(node49) >= 3) then
							if partAll1(node49, 2, (n1(node49) - 1), (function(branch2)
								local head5 = car1(branch2)
								local tail1 = branch2[2]
								return ((n1(branch2) == 2) and ((type1(tail1) == "symbol") and (((type1(head5) == "symbol") and (head5["var"] == tail1["var"])) or (test2 and (not lookup16[head5]["stmt"] and (tail1["var"] == builtins1["true"]))))))
							end)) then
								local branch3 = last1(node49)
								temp9 = ((n1(branch3) == 2) and (builtin_3f_1(car1(branch3), "true") and not lookup16[branch3[2]]["stmt"]))
							else
								temp9 = false
							end
						else
							temp9 = false
						end
						if temp9 then
							cat4 = cat3("or")
						else
							cat4 = cat3("cond", "stmt", true)
						end
					end
				end
			elseif (func7 == builtins1["set!"]) then
				visitNode2(lookup16, node49[3], true)
				cat4 = cat3("set!")
			elseif (func7 == builtins1["quote"]) then
				visitQuote2(lookup16, node49)
				cat4 = cat3("quote")
			elseif (func7 == builtins1["syntax-quote"]) then
				visitSyntaxQuote1(lookup16, node49[2], 1)
				cat4 = cat3("syntax-quote")
			elseif (func7 == builtins1["unquote"]) then
				cat4 = error1("unquote should never appear", 0)
			elseif (func7 == builtins1["unquote-splice"]) then
				cat4 = error1("unquote should never appear", 0)
			elseif ((func7 == builtins1["define"]) or (func7 == builtins1["define-macro"])) then
				local def5 = node49[(n1(node49))]
				if ((type1(def5) == "list") and builtin_3f_1(car1(def5), "lambda")) then
					local recur2 = ({["var"]=node49["defVar"],["def"]=def5})
					visitNodes1(lookup16, def5, 3, true, nil, recur2)
					lookup16[def5] = (function()
						if recur2["tail"] then
							return cat3("lambda", "recur", recur2)
						else
							return cat3("lambda")
						end
					end)()
				else
					visitNode2(lookup16, def5, true)
				end
				cat4 = cat3("define")
			elseif (func7 == builtins1["define-native"]) then
				cat4 = cat3("define-native")
			elseif (func7 == builtins1["import"]) then
				cat4 = cat3("import")
			elseif (func7 == builtins1["struct-literal"]) then
				visitNodes1(lookup16, node49, 2, false)
				cat4 = cat3("struct-literal")
			elseif (func7 == builtins1["true"]) then
				visitNodes1(lookup16, node49, 1, false)
				cat4 = cat3("call-literal")
			elseif (func7 == builtins1["false"]) then
				visitNodes1(lookup16, node49, 1, false)
				cat4 = cat3("call-literal")
			elseif (func7 == builtins1["nil"]) then
				visitNodes1(lookup16, node49, 1, false)
				cat4 = cat3("call-literal")
			else
				visitNodes1(lookup16, node49, 1, false)
				if (recur1 and (func7 == recur1["var"])) then
					recur1["tail"] = true
					cat4 = cat3("call-symbol", "recur", recur1, "stmt", recur1)
				else
					cat4 = cat3("call-symbol")
				end
			end
		elseif (r_7471 == "list") then
			if ((n1(node49) == 2) and (builtin_3f_1(car1(head4), "lambda") and ((n1(head4) == 3) and ((n1(head4[2]) == 1) and ((type1((head4[3])) == "symbol") and (head4[3]["var"] == car1(head4[2])["var"])))))) then
				if visitNode2(lookup16, node49[2], stmt1, test2)["stmt"] then
					visitNode2(lookup16, head4, true)
					if stmt1 then
						cat4 = cat3("call-lambda", "stmt", true)
					else
						cat4 = cat3("call")
					end
				else
					cat4 = cat3("wrap-value")
				end
			else
				local temp10
				if (n1(node49) == 2) then
					if builtin_3f_1(car1(head4), "lambda") then
						if (n1(head4) == 3) then
							if (n1(head4[2]) == 1) then
								local elem7 = head4[3]
								temp10 = ((type1(elem7) == "list") and (builtin_3f_1(car1(elem7), "cond") and ((type1((car1(elem7[2]))) == "symbol") and (car1(elem7[2])["var"] == car1(head4[2])["var"]))))
							else
								temp10 = false
							end
						else
							temp10 = false
						end
					else
						temp10 = false
					end
				else
					temp10 = false
				end
				if temp10 then
					if visitNode2(lookup16, node49[2], stmt1, test2)["stmt"] then
						lookup16[head4] = cat3("lambda")
						local r_8201 = n1(head4)
						local r_8181 = nil
						r_8181 = (function(r_8191)
							if (r_8191 <= r_8201) then
								visitNode2(lookup16, head4[r_8191], true, test2)
								return r_8181((r_8191 + 1))
							else
								return nil
							end
						end)
						r_8181(3)
						if stmt1 then
							cat4 = cat3("call-lambda", "stmt", true)
						else
							cat4 = cat3("call")
						end
					else
						local res7 = visitNode2(lookup16, head4[3], true, test2)
						local ty5 = res7["category"]
						lookup16[head4] = cat3("lambda")
						if (ty5 == "and") then
							cat4 = cat3("and-lambda")
						elseif (ty5 == "or") then
							cat4 = cat3("or-lambda")
						elseif stmt1 then
							cat4 = cat3("call-lambda", "stmt", true)
						else
							cat4 = cat3("call")
						end
					end
				elseif (stmt1 and builtin_3f_1(car1(head4), "lambda")) then
					visitNodes1(lookup16, car1(node49), 3, true, test2, recur1)
					local lam4 = car1(node49)
					local args11 = lam4[2]
					local offset3 = 1
					local r_8251 = n1(args11)
					local r_8231 = nil
					r_8231 = (function(r_8241)
						if (r_8241 <= r_8251) then
							if args11[r_8241]["var"]["isVariadic"] then
								local count3 = (n1(node49) - n1(args11))
								if (count3 < 0) then
									count3 = 0
								end
								local r_8291 = count3
								local r_8271 = nil
								r_8271 = (function(r_8281)
									if (r_8281 <= r_8291) then
										visitNode2(lookup16, node49[((r_8241 + r_8281))], false)
										return r_8271((r_8281 + 1))
									else
										return nil
									end
								end)
								r_8271(1)
								offset3 = count3
							else
								local val17 = node49[((r_8241 + offset3))]
								if val17 then
									visitNode2(lookup16, val17, true)
								end
							end
							return r_8231((r_8241 + 1))
						else
							return nil
						end
					end)
					r_8231(1)
					local r_8331 = n1(node49)
					local r_8311 = nil
					r_8311 = (function(r_8321)
						if (r_8321 <= r_8331) then
							visitNode2(lookup16, node49[r_8321], true)
							return r_8311((r_8321 + 1))
						else
							return nil
						end
					end)
					r_8311((n1(args11) + (offset3 + 1)))
					cat4 = cat3("call-lambda", "stmt", true)
				elseif (builtin_3f_1(car1(head4), "quote") or builtin_3f_1(car1(head4), "syntax-quote")) then
					visitNodes1(lookup16, node49, 1, false)
					cat4 = cat3("call-literal")
				else
					visitNodes1(lookup16, node49, 1, false)
					cat4 = cat3("call")
				end
			end
		elseif eq_3f_1(r_7471, true) then
			visitNodes1(lookup16, node49, 1, false)
			cat4 = cat3("call-literal")
		else
			cat4 = error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_7471), ", but none matched.\n", "  Tried: `\"symbol\"`\n  Tried: `\"list\"`\n  Tried: `true`"))
		end
	else
		cat4 = error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_7461), ", but none matched.\n", "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"key\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`"))
	end
	if (cat4 == nil) then
		error1(_2e2e_2("Node returned nil ", pretty1(node49)), 0)
	end
	lookup16[node49] = cat4
	return cat4
end)
visitNodes1 = (function(lookup17, nodes23, start6, stmt2, test3, recur3)
	local len9 = n1(nodes23)
	local r_7481 = nil
	r_7481 = (function(r_7491)
		if (r_7491 <= len9) then
			visitNode2(lookup17, nodes23[r_7491], stmt2, (test3 and (r_7491 == len9)), ((r_7491 == len9) and recur3))
			return r_7481((r_7491 + 1))
		else
			return nil
		end
	end)
	return r_7481(start6)
end)
visitSyntaxQuote1 = (function(lookup18, node50, level4)
	if (level4 == 0) then
		return visitNode2(lookup18, node50, false)
	else
		local cat5
		local r_7541 = type1(node50)
		if (r_7541 == "string") then
			cat5 = cat3("quote-const")
		elseif (r_7541 == "number") then
			cat5 = cat3("quote-const")
		elseif (r_7541 == "key") then
			cat5 = cat3("quote-const")
		elseif (r_7541 == "symbol") then
			cat5 = cat3("quote-const")
		elseif (r_7541 == "list") then
			local r_7551 = car1(node50)
			if eq_3f_1(r_7551, ({ tag="symbol", contents="unquote"})) then
				visitSyntaxQuote1(lookup18, node50[2], (level4 - 1))
				cat5 = cat3("unquote")
			elseif eq_3f_1(r_7551, ({ tag="symbol", contents="unquote-splice"})) then
				visitSyntaxQuote1(lookup18, node50[2], (level4 - 1))
				cat5 = cat3("unquote-splice")
			elseif eq_3f_1(r_7551, ({ tag="symbol", contents="syntax-quote"})) then
				local r_7601 = n1(node50)
				local r_7581 = nil
				r_7581 = (function(r_7591)
					if (r_7591 <= r_7601) then
						visitSyntaxQuote1(lookup18, node50[r_7591], (level4 + 1))
						return r_7581((r_7591 + 1))
					else
						return nil
					end
				end)
				r_7581(1)
				cat5 = cat3("quote-list")
			else
				local hasSplice1 = false
				local r_7661 = n1(node50)
				local r_7641 = nil
				r_7641 = (function(r_7651)
					if (r_7651 <= r_7661) then
						if (visitSyntaxQuote1(lookup18, node50[r_7651], level4)["category"] == "unquote-splice") then
							hasSplice1 = true
						end
						return r_7641((r_7651 + 1))
					else
						return nil
					end
				end)
				r_7641(1)
				if hasSplice1 then
					cat5 = cat3("quote-splice", "stmt", true)
				else
					cat5 = cat3("quote-list")
				end
			end
		else
			cat5 = error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_7541), ", but none matched.\n", "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"key\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`"))
		end
		if (cat5 == nil) then
			error1(_2e2e_2("Node returned nil ", pretty1(node50)), 0)
		end
		lookup18[node50] = cat5
		return cat5
	end
end)
visitQuote2 = (function(lookup19, node51)
	if (type1(node51) == "list") then
		local r_7721 = n1(node51)
		local r_7701 = nil
		r_7701 = (function(r_7711)
			if (r_7711 <= r_7721) then
				visitQuote2(lookup19, (node51[r_7711]))
				return r_7701((r_7711 + 1))
			else
				return nil
			end
		end)
		r_7701(1)
		lookup19[node51] = cat3("quote-list")
		return nil
	else
		lookup19[node51] = cat3("quote-const")
		return nil
	end
end)
categoriseNodes1 = ({["name"]="categorise-nodes",["help"]="Categorise a group of NODES, annotating their appropriate node type.",["cat"]=({tag = "list", n = 1, "categorise"}),["run"]=(function(r_51517, state29, nodes24, lookup20)
	return visitNodes1(lookup20, nodes24, 1, true)
end)})
categoriseNode1 = ({["name"]="categorise-node",["help"]="Categorise a NODE, annotating it's appropriate node type.",["cat"]=({tag = "list", n = 1, "categorise"}),["run"]=(function(r_51518, state30, node52, lookup21, stmt3)
	return visitNode2(lookup21, node52, stmt3)
end)})
keywords1 = createLookup1(({tag = "list", n = 21, "and", "break", "do", "else", "elseif", "end", "false", "for", "function", "if", "in", "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while"}))
escape1 = (function(name18)
	if (name18 == "") then
		return "_e"
	elseif keywords1[name18] then
		return _2e2e_2("_e", name18)
	elseif find1(name18, "^%w[_%w%d]*$") then
		return name18
	else
		local out12
		if find1(sub1(name18, 1, 1), "%d") then
			out12 = "_e"
		else
			out12 = ""
		end
		local upper2 = false
		local esc1 = false
		local r_8381 = n1(name18)
		local r_8361 = nil
		r_8361 = (function(r_8371)
			if (r_8371 <= r_8381) then
				local char2 = sub1(name18, r_8371, r_8371)
				if ((char2 == "-") and (find1((function(x26)
					return sub1(name18, x26, x26)
				end)((r_8371 - 1)), "[%a%d']") and find1((function(x27)
					return sub1(name18, x27, x27)
				end)((r_8371 + 1)), "[%a%d']"))) then
					upper2 = true
				elseif find1(char2, "[^%w%d]") then
					char2 = format1("%02x", (byte1(char2)))
					upper2 = false
					if esc1 then
					else
						esc1 = true
						out12 = _2e2e_2(out12, "_")
					end
					out12 = _2e2e_2(out12, char2)
				else
					if esc1 then
						esc1 = false
						out12 = _2e2e_2(out12, "_")
					end
					if upper2 then
						upper2 = false
						char2 = upper1(char2)
					end
					out12 = _2e2e_2(out12, char2)
				end
				return r_8361((r_8371 + 1))
			else
				return nil
			end
		end)
		r_8361(1)
		if esc1 then
			out12 = _2e2e_2(out12, "_")
		end
		return out12
	end
end)
escapeVar1 = (function(var31, state31)
	if builtinVars1[var31] then
		return var31["name"]
	else
		local v5 = escape1(var31["name"])
		local id2 = state31["var-lookup"][var31]
		if id2 then
		else
			id2 = ((state31["ctr-lookup"][v5] or 0) + 1)
			state31["ctr-lookup"][v5] = id2
			state31["var-lookup"][var31] = id2
		end
		return _2e2e_2(v5, tostring1(id2))
	end
end)
truthy_3f_1 = (function(node53)
	return ((type1(node53) == "symbol") and (builtins1["true"] == node53["var"]))
end)
boringCategories1 = ({["const"]=true,["quote"]=true,["not"]=true,["cond"]=true})
compileNative1 = (function(out13, meta2)
	local ty6 = type1(meta2)
	if (ty6 == "var") then
		return append_21_1(out13, meta2["contents"])
	elseif ((ty6 == "expr") or (ty6 == "stmt")) then
		append_21_1(out13, "function(")
		local r_8501 = meta2["count"]
		local r_8481 = nil
		r_8481 = (function(r_8491)
			if (r_8491 <= r_8501) then
				if (r_8491 == 1) then
				else
					append_21_1(out13, ", ")
				end
				append_21_1(out13, _2e2e_2("v", tonumber1(r_8491)))
				return r_8481((r_8491 + 1))
			else
				return nil
			end
		end)
		r_8481(1)
		if meta2["fold"] then
			append_21_1(out13, ", ...")
		end
		append_21_1(out13, ") ")
		if (meta2["tag"] == "stmt") then
		elseif meta2["fold"] then
			append_21_1(out13, "local t = ")
		else
			append_21_1(out13, "return ")
		end
		local r_8531 = meta2["contents"]
		local r_8561 = n1(r_8531)
		local r_8541 = nil
		r_8541 = (function(r_8551)
			if (r_8551 <= r_8561) then
				local entry5 = r_8531[r_8551]
				if number_3f_1(entry5) then
					append_21_1(out13, _2e2e_2("v", tonumber1(entry5)))
				else
					append_21_1(out13, entry5)
				end
				return r_8541((r_8551 + 1))
			else
				return nil
			end
		end)
		r_8541(1)
		local r_8581 = meta2["fold"]
		if eq_3f_1(r_8581, nil) then
		elseif (r_8581 == "l") then
			append_21_1(out13, " for i = 1, _select('#', ...) do t = ")
			local r_8601 = meta2["contents"]
			local r_8631 = n1(r_8601)
			local r_8611 = nil
			r_8611 = (function(r_8621)
				if (r_8621 <= r_8631) then
					local node54 = r_8601[r_8621]
					if (node54 == 1) then
						append_21_1(out13, "t")
					elseif (node54 == 2) then
						append_21_1(out13, "_select(i, ...)")
					elseif string_3f_1(node54) then
						append_21_1(out13, node54)
					else
						error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(node54), ", but none matched.\n", "  Tried: `1`\n  Tried: `2`\n  Tried: `string?`"))
					end
					return r_8611((r_8621 + 1))
				else
					return nil
				end
			end)
			r_8611(1)
			append_21_1(out13, " end return t")
		elseif (r_8581 == "r") then
			append_21_1(out13, " for i = _select('#', ...), 1, -1 do t = ")
			local r_8671 = meta2["contents"]
			local r_8701 = n1(r_8671)
			local r_8681 = nil
			r_8681 = (function(r_8691)
				if (r_8691 <= r_8701) then
					local node55 = r_8671[r_8691]
					if (node55 == 1) then
						append_21_1(out13, "_select(i, ...)")
					elseif (node55 == 2) then
						append_21_1(out13, "t")
					elseif string_3f_1(node55) then
						append_21_1(out13, node55)
					else
						error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(node55), ", but none matched.\n", "  Tried: `1`\n  Tried: `2`\n  Tried: `string?`"))
					end
					return r_8681((r_8691 + 1))
				else
					return nil
				end
			end)
			r_8681(1)
			append_21_1(out13, " end return t")
		else
			error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_8581), ", but none matched.\n", "  Tried: `nil`\n  Tried: `\"l\"`\n  Tried: `\"r\"`"))
		end
		return append_21_1(out13, " end")
	else
		_error("unmatched item")
	end
end)
compileExpression1 = (function(node56, out14, state32, ret1)
	local catLookup1 = state32["cat-lookup"]
	local cat6 = catLookup1[node56]
	local _5f_2
	if cat6 then
		_5f_2 = nil
	else
		_5f_2 = print1("Cannot find", pretty1(node56), formatNode1(node56))
	end
	local catTag1 = cat6["category"]
	if boringCategories1[catTag1] then
	else
		pushNode_21_1(out14, node56)
	end
	if (catTag1 == "const") then
		if (ret1 == "") then
		else
			if ret1 then
				append_21_1(out14, ret1)
			end
			if (type1(node56) == "symbol") then
				append_21_1(out14, escapeVar1(node56["var"], state32))
			elseif string_3f_1(node56) then
				append_21_1(out14, quoted1(node56["value"]))
			elseif number_3f_1(node56) then
				append_21_1(out14, tostring1(node56["value"]))
			elseif (type1(node56) == "key") then
				append_21_1(out14, quoted1(node56["value"]))
			else
				error1(_2e2e_2("Unknown type: ", type1(node56)))
			end
		end
	elseif (catTag1 == "lambda") then
		if (ret1 == "") then
		else
			if ret1 then
				append_21_1(out14, ret1)
			end
			local args12 = node56[2]
			local variadic1 = nil
			local i9 = 1
			append_21_1(out14, "(function(")
			local r_8741 = nil
			r_8741 = (function()
				if ((i9 <= n1(args12)) and not variadic1) then
					if (i9 > 1) then
						append_21_1(out14, ", ")
					end
					local var32 = args12[i9]["var"]
					if var32["isVariadic"] then
						append_21_1(out14, "...")
						variadic1 = i9
					else
						append_21_1(out14, escapeVar1(var32, state32))
					end
					i9 = (i9 + 1)
					return r_8741()
				else
					return nil
				end
			end)
			r_8741()
			line_21_1(out14, ")")
			out14["indent"] = (out14["indent"] + 1)
			if variadic1 then
				local argsVar1 = escapeVar1(args12[variadic1]["var"], state32)
				if (variadic1 == n1(args12)) then
					line_21_1(out14, _2e2e_2("local ", argsVar1, " = _pack(...) ", argsVar1, ".tag = \"list\""))
				else
					local remaining1 = (n1(args12) - variadic1)
					line_21_1(out14, _2e2e_2("local _n = _select(\"#\", ...) - ", tostring1(remaining1)))
					append_21_1(out14, _2e2e_2("local ", argsVar1))
					local r_8781 = n1(args12)
					local r_8761 = nil
					r_8761 = (function(r_8771)
						if (r_8771 <= r_8781) then
							append_21_1(out14, ", ")
							append_21_1(out14, escapeVar1(args12[r_8771]["var"], state32))
							return r_8761((r_8771 + 1))
						else
							return nil
						end
					end)
					r_8761((variadic1 + 1))
					line_21_1(out14)
					line_21_1(out14, "if _n > 0 then")
					out14["indent"] = (out14["indent"] + 1)
					append_21_1(out14, argsVar1)
					line_21_1(out14, " = { tag=\"list\", n=_n, _unpack(_pack(...), 1, _n)}")
					local r_8821 = n1(args12)
					local r_8801 = nil
					r_8801 = (function(r_8811)
						if (r_8811 <= r_8821) then
							append_21_1(out14, escapeVar1(args12[r_8811]["var"], state32))
							if (r_8811 < n1(args12)) then
								append_21_1(out14, ", ")
							end
							return r_8801((r_8811 + 1))
						else
							return nil
						end
					end)
					r_8801((variadic1 + 1))
					line_21_1(out14, " = select(_n + 1, ...)")
					out14["indent"] = (out14["indent"] - 1)
					line_21_1(out14, "else")
					out14["indent"] = (out14["indent"] + 1)
					append_21_1(out14, argsVar1)
					line_21_1(out14, " = { tag=\"list\", n=0}")
					local r_8861 = n1(args12)
					local r_8841 = nil
					r_8841 = (function(r_8851)
						if (r_8851 <= r_8861) then
							append_21_1(out14, escapeVar1(args12[r_8851]["var"], state32))
							if (r_8851 < n1(args12)) then
								append_21_1(out14, ", ")
							end
							return r_8841((r_8851 + 1))
						else
							return nil
						end
					end)
					r_8841((variadic1 + 1))
					line_21_1(out14, " = ...")
					out14["indent"] = (out14["indent"] - 1)
					line_21_1(out14, "end")
				end
			end
			if cat6["recur"] then
				line_21_1(out14, "while true do")
				out14["indent"] = (out14["indent"] + 1)
			end
			compileBlock1(node56, out14, state32, 3, "return ")
			if cat6["recur"] then
				out14["indent"] = (out14["indent"] - 1)
				line_21_1(out14, "end")
			end
			out14["indent"] = (out14["indent"] - 1)
			append_21_1(out14, "end)")
		end
	elseif (catTag1 == "cond") then
		local closure1 = not ret1
		local hadFinal1 = false
		local ends1 = 1
		if closure1 then
			line_21_1(out14, "(function()")
			out14["indent"] = (out14["indent"] + 1)
			ret1 = "return "
		end
		local i10 = 2
		local r_8881 = nil
		r_8881 = (function()
			if (not hadFinal1 and (i10 <= n1(node56))) then
				local item1 = node56[i10]
				local case4 = item1[1]
				local isFinal1 = truthy_3f_1(case4)
				if ((i10 > 2) and (not isFinal1 or ((ret1 ~= "") or (n1(item1) ~= 1)))) then
					append_21_1(out14, "else")
				end
				if isFinal1 then
					if (i10 == 2) then
						append_21_1(out14, "do")
					end
				elseif catLookup1[case4]["stmt"] then
					if (i10 > 2) then
						out14["indent"] = (out14["indent"] + 1)
						line_21_1(out14)
						ends1 = (ends1 + 1)
					end
					local tmp1 = escapeVar1(({["name"]="temp"}), state32)
					line_21_1(out14, _2e2e_2("local ", tmp1))
					compileExpression1(case4, out14, state32, _2e2e_2(tmp1, " = "))
					line_21_1(out14)
					line_21_1(out14, _2e2e_2("if ", tmp1, " then"))
				else
					append_21_1(out14, "if ")
					compileExpression1(case4, out14, state32)
					append_21_1(out14, " then")
				end
				out14["indent"] = (out14["indent"] + 1)
				line_21_1(out14)
				compileBlock1(item1, out14, state32, 2, ret1)
				out14["indent"] = (out14["indent"] - 1)
				if isFinal1 then
					hadFinal1 = true
				end
				i10 = (i10 + 1)
				return r_8881()
			else
				return nil
			end
		end)
		r_8881()
		if hadFinal1 then
		else
			append_21_1(out14, "else")
			out14["indent"] = (out14["indent"] + 1)
			line_21_1(out14)
			append_21_1(out14, "_error(\"unmatched item\")")
			out14["indent"] = (out14["indent"] - 1)
			line_21_1(out14)
		end
		local r_8951 = ends1
		local r_8931 = nil
		r_8931 = (function(r_8941)
			if (r_8941 <= r_8951) then
				append_21_1(out14, "end")
				if (r_8941 < ends1) then
					out14["indent"] = (out14["indent"] - 1)
					line_21_1(out14)
				end
				return r_8931((r_8941 + 1))
			else
				return nil
			end
		end)
		r_8931(1)
		if closure1 then
			line_21_1(out14)
			out14["indent"] = (out14["indent"] - 1)
			line_21_1(out14, "end)()")
		end
	elseif (catTag1 == "not") then
		if ret1 then
			ret1 = _2e2e_2(ret1, "not ")
		else
			append_21_1(out14, "not ")
		end
		compileExpression1(car1(node56[2]), out14, state32, ret1)
	elseif (catTag1 == "or") then
		if ret1 then
			append_21_1(out14, ret1)
		end
		append_21_1(out14, "(")
		local len10 = n1(node56)
		local r_8971 = nil
		r_8971 = (function(r_8981)
			if (r_8981 <= len10) then
				if (r_8981 > 2) then
					append_21_1(out14, " or ")
				end
				compileExpression1(node56[r_8981][(function(idx7)
					return idx7
				end)((function()
					if (r_8981 == len10) then
						return 2
					else
						return 1
					end
				end)()
				)], out14, state32)
				return r_8971((r_8981 + 1))
			else
				return nil
			end
		end)
		r_8971(2)
		append_21_1(out14, ")")
	elseif (catTag1 == "or-lambda") then
		if ret1 then
			append_21_1(out14, ret1)
		end
		append_21_1(out14, "(")
		compileExpression1(node56[2], out14, state32)
		local branch4 = car1(node56)[3]
		local len11 = n1(branch4)
		local r_9011 = nil
		r_9011 = (function(r_9021)
			if (r_9021 <= len11) then
				append_21_1(out14, " or ")
				compileExpression1(branch4[r_9021][(function(idx8)
					return idx8
				end)((function()
					if (r_9021 == len11) then
						return 2
					else
						return 1
					end
				end)()
				)], out14, state32)
				return r_9011((r_9021 + 1))
			else
				return nil
			end
		end)
		r_9011(3)
		append_21_1(out14, ")")
	elseif (catTag1 == "and") then
		if ret1 then
			append_21_1(out14, ret1)
		end
		append_21_1(out14, "(")
		compileExpression1(node56[2][1], out14, state32)
		append_21_1(out14, " and ")
		compileExpression1(node56[2][2], out14, state32)
		append_21_1(out14, ")")
	elseif (catTag1 == "and-lambda") then
		if ret1 then
			append_21_1(out14, ret1)
		end
		append_21_1(out14, "(")
		compileExpression1(node56[2], out14, state32)
		append_21_1(out14, " and ")
		compileExpression1(car1(node56)[3][2][2], out14, state32)
		append_21_1(out14, ")")
	elseif (catTag1 == "set!") then
		compileExpression1(node56[3], out14, state32, _2e2e_2(escapeVar1(node56[2]["var"], state32), " = "))
		if (ret1 and (ret1 ~= "")) then
			line_21_1(out14)
			append_21_1(out14, ret1)
			append_21_1(out14, "nil")
		end
	elseif (catTag1 == "struct-literal") then
		if (ret1 == "") then
			append_21_1(out14, "local _ = ")
		elseif ret1 then
			append_21_1(out14, ret1)
		end
		append_21_1(out14, "({")
		local r_9081 = n1(node56)
		local r_9061 = nil
		r_9061 = (function(r_9071)
			if (r_9071 <= r_9081) then
				if (r_9071 > 2) then
					append_21_1(out14, ",")
				end
				append_21_1(out14, "[")
				compileExpression1(node56[r_9071], out14, state32)
				append_21_1(out14, "]=")
				compileExpression1(node56[((r_9071 + 1))], out14, state32)
				return r_9061((r_9071 + 2))
			else
				return nil
			end
		end)
		r_9061(2)
		append_21_1(out14, "})")
	elseif (catTag1 == "define") then
		compileExpression1(node56[(n1(node56))], out14, state32, _2e2e_2(escapeVar1(node56["defVar"], state32), " = "))
	elseif (catTag1 == "define-native") then
		local meta3 = state32["meta"][node56["defVar"]["fullName"]]
		if (meta3 == nil) then
			append_21_1(out14, format1("%s = _libs[%q]", escapeVar1(node56["defVar"], state32), node56["defVar"]["fullName"]))
		else
			append_21_1(out14, format1("%s = ", escapeVar1(node56["defVar"], state32)))
			compileNative1(out14, meta3)
		end
	elseif (catTag1 == "quote") then
		if (ret1 == "") then
		else
			if ret1 then
				append_21_1(out14, ret1)
			end
			compileExpression1(node56[2], out14, state32)
		end
	elseif (catTag1 == "quote-const") then
		if (ret1 == "") then
		else
			if ret1 then
				append_21_1(out14, ret1)
			end
			local r_9101 = type1(node56)
			if (r_9101 == "string") then
				append_21_1(out14, quoted1(node56["value"]))
			elseif (r_9101 == "number") then
				append_21_1(out14, tostring1(node56["value"]))
			elseif (r_9101 == "symbol") then
				append_21_1(out14, _2e2e_2("({ tag=\"symbol\", contents=", quoted1(node56["contents"])))
				if node56["var"] then
					append_21_1(out14, _2e2e_2(", var=", quoted1(tostring1(node56["var"]))))
				end
				append_21_1(out14, "})")
			elseif (r_9101 == "key") then
				append_21_1(out14, _2e2e_2("({tag=\"key\", value=", quoted1(node56["value"]), "})"))
			else
				error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_9101), ", but none matched.\n", "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"symbol\"`\n  Tried: `\"key\"`"))
			end
		end
	elseif (catTag1 == "quote-list") then
		if ret1 then
			append_21_1(out14, ret1)
		end
		append_21_1(out14, _2e2e_2("({tag = \"list\", n = ", tostring1(n1(node56))))
		local r_9151 = n1(node56)
		local r_9131 = nil
		r_9131 = (function(r_9141)
			if (r_9141 <= r_9151) then
				local sub4 = node56[r_9141]
				append_21_1(out14, ", ")
				compileExpression1(sub4, out14, state32)
				return r_9131((r_9141 + 1))
			else
				return nil
			end
		end)
		r_9131(1)
		append_21_1(out14, "})")
	elseif (catTag1 == "quote-splice") then
		if ret1 then
		else
			line_21_1(out14, "(function()")
			out14["indent"] = (out14["indent"] + 1)
		end
		line_21_1(out14, "local _offset, _result, _temp = 0, {tag=\"list\",n=0}")
		local offset4 = 0
		local r_9191 = n1(node56)
		local r_9171 = nil
		r_9171 = (function(r_9181)
			if (r_9181 <= r_9191) then
				local sub5 = node56[r_9181]
				local cat7 = state32["cat-lookup"][sub5]
				if cat7 then
				else
					print1("Cannot find", pretty1(sub5), formatNode1(sub5))
				end
				if (cat7["category"] == "unquote-splice") then
					offset4 = (offset4 + 1)
					append_21_1(out14, "_temp = ")
					compileExpression1(sub5[2], out14, state32)
					line_21_1(out14)
					line_21_1(out14, _2e2e_2("for _c = 1, _temp.n do _result[", tostring1((r_9181 - offset4)), " + _c + _offset] = _temp[_c] end"))
					line_21_1(out14, "_offset = _offset + _temp.n")
				else
					append_21_1(out14, _2e2e_2("_result[", tostring1((r_9181 - offset4)), " + _offset] = "))
					compileExpression1(sub5, out14, state32)
					line_21_1(out14)
				end
				return r_9171((r_9181 + 1))
			else
				return nil
			end
		end)
		r_9171(1)
		line_21_1(out14, _2e2e_2("_result.n = _offset + ", tostring1((n1(node56) - offset4))))
		if (ret1 == "") then
		elseif ret1 then
			append_21_1(out14, _2e2e_2(ret1, "_result"))
		else
			line_21_1(out14, "return _result")
			out14["indent"] = (out14["indent"] - 1)
			line_21_1(out14, "end)()")
		end
	elseif (catTag1 == "syntax-quote") then
		compileExpression1(node56[2], out14, state32, ret1)
	elseif (catTag1 == "unquote") then
		compileExpression1(node56[2], out14, state32, ret1)
	elseif (catTag1 == "unquote-splice") then
		error1("Should neve have explicit unquote-splice", 0)
	elseif (catTag1 == "import") then
		if (ret1 == nil) then
			append_21_1(out14, "nil")
		elseif (ret1 ~= "") then
			append_21_1(out14, ret1)
			append_21_1(out14, "nil")
		end
	elseif (catTag1 == "call-symbol") then
		local head6 = car1(node56)
		local meta4 = ((type1(head6) == "symbol") and ((head6["var"]["tag"] == "native") and state32["meta"][head6["var"]["fullName"]]))
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
		local temp11
		if meta4 then
			if meta4["fold"] then
				temp11 = ((n1(node56) - 1) >= meta4["count"])
			else
				temp11 = ((n1(node56) - 1) == meta4["count"])
			end
		else
			temp11 = false
		end
		if temp11 then
			if (meta4["tag"] == "expr") then
				if (ret1 == "") then
					append_21_1(out14, "local _ = ")
				elseif ret1 then
					append_21_1(out14, ret1)
				end
			end
			local contents1 = meta4["contents"]
			local fold1 = meta4["fold"]
			local count4 = meta4["count"]
			local build1
			build1 = (function(start7, _eend1)
				local r_9361 = n1(contents1)
				local r_9341 = nil
				r_9341 = (function(r_9351)
					if (r_9351 <= r_9361) then
						local entry6 = contents1[r_9351]
						if string_3f_1(entry6) then
							append_21_1(out14, entry6)
						elseif ((fold1 == "l") and ((entry6 == 1) and (start7 < _eend1))) then
							build1(start7, (_eend1 - 1))
							start7 = _eend1
						elseif ((fold1 == "r") and ((entry6 == 2) and (start7 < _eend1))) then
							build1((start7 + 1), _eend1)
						else
							compileExpression1(node56[((entry6 + start7))], out14, state32)
						end
						return r_9341((r_9351 + 1))
					else
						return nil
					end
				end)
				return r_9341(1)
			end)
			build1(1, (n1(node56) - count4))
			if ((meta4["tag"] ~= "expr") and (ret1 ~= "")) then
				line_21_1(out14)
				append_21_1(out14, ret1)
				append_21_1(out14, "nil")
				line_21_1(out14)
			end
		elseif cat6["recur"] then
			if (ret1 == nil) then
				print1(pretty1(node56), " marked as :recur for ", ret1)
			end
			local head7 = cat6["recur"]["def"]
			local args13 = head7[2]
			if (n1(args13) > 0) then
				local packName1 = nil
				local offset5 = 1
				local done1 = false
				local r_9451 = n1(args13)
				local r_9431 = nil
				r_9431 = (function(r_9441)
					if (r_9441 <= r_9451) then
						local var33 = args13[r_9441]["var"]
						if var33["isVariadic"] then
							local count5 = (n1(node56) - n1(args13))
							if (count5 < 0) then
								count5 = 0
							end
							if done1 then
								append_21_1(out14, ", ")
							else
								done1 = true
							end
							append_21_1(out14, escapeVar1(var33, state32))
							offset5 = count5
						else
							local expr1 = node56[((r_9441 + offset5))]
							if (expr1 and (not (type1(expr1) == "symbol") or (expr1["var"] ~= var33))) then
								if done1 then
									append_21_1(out14, ", ")
								else
									done1 = true
								end
								append_21_1(out14, escapeVar1(var33, state32))
							end
						end
						return r_9431((r_9441 + 1))
					else
						return nil
					end
				end)
				r_9431(1)
				append_21_1(out14, " = ")
				local offset6 = 1
				local done2 = false
				local r_9511 = n1(args13)
				local r_9491 = nil
				r_9491 = (function(r_9501)
					if (r_9501 <= r_9511) then
						local var34 = args13[r_9501]["var"]
						if var34["isVariadic"] then
							local count6 = (n1(node56) - n1(args13))
							if (count6 < 0) then
								count6 = 0
							end
							if done2 then
								append_21_1(out14, ", ")
							else
								done2 = true
							end
							if compilePack1(node56, out14, state32, r_9501, count6) then
								packName1 = escapeVar1(var34, state32)
							end
							offset6 = count6
						else
							local expr2 = node56[((r_9501 + offset6))]
							if (expr2 and (not (type1(expr2) == "symbol") or (expr2["var"] ~= var34))) then
								if done2 then
									append_21_1(out14, ", ")
								else
									done2 = true
								end
								compileExpression1(node56[((r_9501 + offset6))], out14, state32)
							end
						end
						return r_9491((r_9501 + 1))
					else
						return nil
					end
				end)
				r_9491(1)
				local r_9571 = n1(node56)
				local r_9551 = nil
				r_9551 = (function(r_9561)
					if (r_9561 <= r_9571) then
						if (r_9561 > 1) then
							append_21_1(out14, ", ")
						end
						compileExpression1(node56[r_9561], out14, state32)
						return r_9551((r_9561 + 1))
					else
						return nil
					end
				end)
				r_9551((n1(args13) + (offset6 + 1)))
				line_21_1(out14)
				if packName1 then
					line_21_1(_2e2e_2(packName1, ".tag = \"list\""))
				end
			else
				local r_9611 = n1(node56)
				local r_9591 = nil
				r_9591 = (function(r_9601)
					if (r_9601 <= r_9611) then
						if (r_9601 > 1) then
							append_21_1(out14, ", ")
						end
						compileExpression1(node56[r_9601], out14, state32, "")
						line_21_1(out14)
						return r_9591((r_9601 + 1))
					else
						return nil
					end
				end)
				r_9591(1)
			end
		else
			if ret1 then
				append_21_1(out14, ret1)
			end
			compileExpression1(head6, out14, state32)
			append_21_1(out14, "(")
			local r_9651 = n1(node56)
			local r_9631 = nil
			r_9631 = (function(r_9641)
				if (r_9641 <= r_9651) then
					if (r_9641 > 2) then
						append_21_1(out14, ", ")
					end
					compileExpression1(node56[r_9641], out14, state32)
					return r_9631((r_9641 + 1))
				else
					return nil
				end
			end)
			r_9631(2)
			append_21_1(out14, ")")
		end
	elseif (catTag1 == "wrap-value") then
		if ret1 then
			append_21_1(out14, ret1)
		end
		append_21_1(out14, "(")
		compileExpression1(node56[2], out14, state32)
		append_21_1(out14, ")")
	elseif (catTag1 == "call-lambda") then
		if (ret1 == nil) then
			print1(pretty1(node56), " marked as call-lambda for ", ret1)
		end
		local head8 = car1(node56)
		local args14 = head8[2]
		local argIdx1 = 1
		local valIdx1 = 2
		local argLen2 = n1(args14)
		local valLen1 = n1(node56)
		local r_9691 = nil
		r_9691 = (function()
			if ((argIdx1 <= argLen2) or (valIdx1 <= valLen1)) then
				local arg24 = args14[argIdx1]
				if not arg24 then
					compileExpression1(node56[argIdx1], out14, state32, "")
					argIdx1 = (argIdx1 + 1)
				elseif arg24["var"]["isVariadic"] then
					local esc2 = escapeVar1(arg24["var"], state32)
					local count7 = (valLen1 - argLen2)
					append_21_1(out14, _2e2e_2("local ", esc2))
					if (count7 < 0) then
						count7 = 0
					end
					append_21_1(out14, " = ")
					if compilePack1(node56, out14, state32, argIdx1, count7) then
						append_21_1(out14, _2e2e_2(" ", esc2, ".tag = \"list\""))
					end
					line_21_1(out14)
					argIdx1 = (argIdx1 + 1)
					valIdx1 = (count7 + valIdx1)
				elseif (valIdx1 == valLen1) then
					local argList1 = ({tag = "list", n = 0})
					local val18 = node56[valIdx1]
					local ret2 = nil
					local r_9711 = nil
					r_9711 = (function()
						if (argIdx1 <= argLen2) then
							pushCdr_21_1(argList1, escapeVar1(args14[argIdx1]["var"], state32))
							argIdx1 = (argIdx1 + 1)
							return r_9711()
						else
							return nil
						end
					end)
					r_9711()
					append_21_1(out14, "local ")
					append_21_1(out14, concat1(argList1, ", "))
					if catLookup1[val18]["stmt"] then
						ret2 = _2e2e_2(concat1(argList1, ", "), " = ")
						line_21_1(out14)
					else
						append_21_1(out14, " = ")
					end
					compileExpression1(val18, out14, state32, ret2)
					valIdx1 = (valIdx1 + 1)
				else
					local expr3 = node56[valIdx1]
					local var35 = arg24["var"]
					local esc3 = escapeVar1(var35, state32)
					local ret3 = nil
					append_21_1(out14, _2e2e_2("local ", esc3))
					if expr3 then
						if catLookup1[expr3]["stmt"] then
							ret3 = _2e2e_2(esc3, " = ")
							line_21_1(out14)
						else
							append_21_1(out14, " = ")
						end
						compileExpression1(expr3, out14, state32, ret3)
						line_21_1(out14)
					else
						line_21_1(out14)
					end
					argIdx1 = (argIdx1 + 1)
					valIdx1 = (valIdx1 + 1)
				end
				line_21_1(out14)
				return r_9691()
			else
				return nil
			end
		end)
		r_9691()
		compileBlock1(head8, out14, state32, 3, ret1)
	elseif (catTag1 == "call-literal") then
		if ret1 then
			append_21_1(out14, ret1)
		end
		append_21_1(out14, "(")
		compileExpression1(car1(node56), out14, state32)
		append_21_1(out14, ")(")
		local r_9741 = n1(node56)
		local r_9721 = nil
		r_9721 = (function(r_9731)
			if (r_9731 <= r_9741) then
				if (r_9731 > 2) then
					append_21_1(out14, ", ")
				end
				compileExpression1(node56[r_9731], out14, state32)
				return r_9721((r_9731 + 1))
			else
				return nil
			end
		end)
		r_9721(2)
		append_21_1(out14, ")")
	elseif (catTag1 == "call") then
		if ret1 then
			append_21_1(out14, ret1)
		end
		compileExpression1(car1(node56), out14, state32)
		append_21_1(out14, "(")
		local r_9781 = n1(node56)
		local r_9761 = nil
		r_9761 = (function(r_9771)
			if (r_9771 <= r_9781) then
				if (r_9771 > 2) then
					append_21_1(out14, ", ")
				end
				compileExpression1(node56[r_9771], out14, state32)
				return r_9761((r_9771 + 1))
			else
				return nil
			end
		end)
		r_9761(2)
		append_21_1(out14, ")")
	else
		error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(catTag1), ", but none matched.\n", "  Tried: `\"const\"`\n  Tried: `\"lambda\"`\n  Tried: `\"cond\"`\n  Tried: `\"not\"`\n  Tried: `\"or\"`\n  Tried: `\"or-lambda\"`\n  Tried: `\"and\"`\n  Tried: `\"and-lambda\"`\n  Tried: `\"set!\"`\n  Tried: `\"struct-literal\"`\n  Tried: `\"define\"`\n  Tried: `\"define-native\"`\n  Tried: `\"quote\"`\n  Tried: `\"quote-const\"`\n  Tried: `\"quote-list\"`\n  Tried: `\"quote-splice\"`\n  Tried: `\"syntax-quote\"`\n  Tried: `\"unquote\"`\n  Tried: `\"unquote-splice\"`\n  Tried: `\"import\"`\n  Tried: `\"call-symbol\"`\n  Tried: `\"wrap-value\"`\n  Tried: `\"call-lambda\"`\n  Tried: `\"call-literal\"`\n  Tried: `\"call\"`"))
	end
	if boringCategories1[catTag1] then
		return nil
	else
		return popNode_21_1(out14, node56)
	end
end)
compilePack1 = (function(node57, out15, state33, start8, count8)
	if ((count8 <= 0) or atom_3f_1(node57[((start8 + count8))])) then
		append_21_1(out15, "{ tag=\"list\", n=")
		append_21_1(out15, tostring1(count8))
		local r_9211 = nil
		r_9211 = (function(r_9221)
			if (r_9221 <= count8) then
				append_21_1(out15, ", ")
				compileExpression1(node57[((start8 + r_9221))], out15, state33)
				return r_9211((r_9221 + 1))
			else
				return nil
			end
		end)
		r_9211(1)
		append_21_1(out15, "}")
		return false
	else
		append_21_1(out15, " _pack(")
		local r_9251 = nil
		r_9251 = (function(r_9261)
			if (r_9261 <= count8) then
				if (r_9261 > 1) then
					append_21_1(out15, ", ")
				end
				compileExpression1(node57[((start8 + r_9261))], out15, state33)
				return r_9251((r_9261 + 1))
			else
				return nil
			end
		end)
		r_9251(1)
		append_21_1(out15, ")")
		return true
	end
end)
compileBlock1 = (function(nodes25, out16, state34, start9, ret4)
	local r_7441 = n1(nodes25)
	local r_7421 = nil
	r_7421 = (function(r_7431)
		if (r_7431 <= r_7441) then
			local ret_27_1
			if (r_7431 == n1(nodes25)) then
				ret_27_1 = ret4
			else
				ret_27_1 = ""
			end
			compileExpression1(nodes25[r_7431], out16, state34, ret_27_1)
			line_21_1(out16)
			return r_7421((r_7431 + 1))
		else
			return nil
		end
	end)
	r_7421(start9)
	if ((n1(nodes25) < start9) and (ret4 and (ret4 ~= ""))) then
		append_21_1(out16, ret4)
		return line_21_1(out16, "nil")
	else
		return nil
	end
end)
prelude1 = (function(out17)
	line_21_1(out17, "if not table.pack then table.pack = function(...) return { n = select(\"#\", ...), ... } end end")
	line_21_1(out17, "if not table.unpack then table.unpack = unpack end")
	line_21_1(out17, "local load = load if _VERSION:find(\"5.1\") then load = function(x, n, _, env) local f, e = loadstring(x, n) if not f then error(e, 2) end if env then setfenv(f, env) end return f end end")
	return line_21_1(out17, "local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error")
end)
expression2 = (function(node58, out18, state35, ret5)
	runPass1(categoriseNode1, state35, nil, node58, state35["cat-lookup"], (ret5 ~= nil))
	return compileExpression1(node58, out18, state35, ret5)
end)
block2 = (function(nodes26, out19, state36, start10, ret6)
	runPass1(categoriseNodes1, state36, nil, nodes26, state36["cat-lookup"])
	return compileBlock1(nodes26, out19, state36, start10, ret6)
end)
create4 = (function(scope9, compiler1)
	if scope9 then
	else
		error1("scope cannot be nil")
	end
	if compiler1 then
	else
		error1("compiler cannot be nil")
	end
	return ({["scope"]=scope9,["compiler"]=compiler1,["logger"]=compiler1["log"],["mappings"]=compiler1["compileState"]["mappings"],["required"]=({tag = "list", n = 0}),["requiredSet"]=({}),["stage"]="parsed",["var"]=nil,["node"]=nil,["value"]=nil})
end)
require_21_1 = (function(state37, var36, user3)
	if (state37["stage"] ~= "parsed") then
		error1(_2e2e_2("Cannot add requirement when in stage ", state37["stage"]))
	end
	if var36 then
	else
		error1("var is nil")
	end
	if user3 then
	else
		error1("user is nil")
	end
	if var36["scope"]["isRoot"] then
		local other1 = state37["compiler"]["states"][var36]
		if (other1 and not state37["requiredSet"][other1]) then
			state37["requiredSet"][other1] = user3
			pushCdr_21_1(state37["required"], other1)
		end
		return other1
	else
		return nil
	end
end)
define_21_1 = (function(state38, var37)
	if (state38["stage"] ~= "parsed") then
		error1(_2e2e_2("Cannot add definition when in stage ", state38["stage"]))
	end
	if (var37["scope"] ~= state38["scope"]) then
		error1("Defining variable in different scope")
	end
	if state38["var"] then
		error1("Cannot redeclare variable for given state")
	end
	state38["var"] = var37
	state38["compiler"]["states"][var37] = state38
	state38["compiler"]["variables"][tostring1(var37)] = var37
	return nil
end)
built_21_1 = (function(state39, node59)
	if node59 then
	else
		error1("node cannot be nil")
	end
	if (state39["stage"] ~= "parsed") then
		error1(_2e2e_2("Cannot transition from ", state39["stage"], " to built"))
	end
	if (node59["defVar"] ~= state39["var"]) then
		error1("Variables are different")
	end
	state39["node"] = node59
	state39["stage"] = "built"
	return nil
end)
executed_21_1 = (function(state40, value10)
	if (state40["stage"] ~= "built") then
		error1(_2e2e_2("Cannot transition from ", state40["stage"], " to executed"))
	end
	state40["value"] = value10
	state40["stage"] = "executed"
	return nil
end)
get_21_1 = (function(state41)
	if (state41["stage"] == "executed") then
		return state41["value"]
	else
		local required1 = ({tag = "list", n = 0})
		local requiredSet1 = ({})
		local visit2
		visit2 = (function(state42, stack2, stackHash1)
			local idx9 = stackHash1[state42]
			if idx9 then
				if (state42["var"]["tag"] == "macro") then
					pushCdr_21_1(stack2, state42)
					local states1 = ({tag = "list", n = 0})
					local nodes27 = ({tag = "list", n = 0})
					local firstNode1 = nil
					local r_9831 = n1(stack2)
					local r_9811 = nil
					r_9811 = (function(r_9821)
						if (r_9821 <= r_9831) then
							local current1 = stack2[r_9821]
							local previous3 = stack2[((r_9821 - 1))]
							pushCdr_21_1(states1, current1["var"]["name"])
							if previous3 then
								local user4 = previous3["requiredSet"][current1]
								if firstNode1 then
								else
									firstNode1 = user4
								end
								pushCdr_21_1(nodes27, getSource1(user4))
								pushCdr_21_1(nodes27, _2e2e_2(current1["var"]["name"], " used in ", previous3["var"]["name"]))
							end
							return r_9811((r_9821 + 1))
						else
							return nil
						end
					end)
					r_9811(idx9)
					return doNodeError_21_1(state42["logger"], _2e2e_2("Loop in macros ", concat1(states1, " -> ")), firstNode1, nil, unpack1(nodes27, 1, n1(nodes27)))
				else
					return nil
				end
			elseif (state42["stage"] == "executed") then
				return nil
			else
				pushCdr_21_1(stack2, state42)
				stackHash1[state42] = n1(stack2)
				if requiredSet1[state42] then
				else
					requiredSet1[state42] = true
					pushCdr_21_1(required1, state42)
				end
				local visited2 = ({})
				local r_9861 = state42["required"]
				local r_9891 = n1(r_9861)
				local r_9871 = nil
				r_9871 = (function(r_9881)
					if (r_9881 <= r_9891) then
						local inner1 = r_9861[r_9881]
						visited2[inner1] = true
						visit2(inner1, stack2, stackHash1)
						return r_9871((r_9881 + 1))
					else
						return nil
					end
				end)
				r_9871(1)
				if (state42["stage"] == "parsed") then
					yield1(({["tag"]="build",["state"]=state42}))
				end
				local r_9921 = state42["required"]
				local r_9951 = n1(r_9921)
				local r_9931 = nil
				r_9931 = (function(r_9941)
					if (r_9941 <= r_9951) then
						local inner2 = r_9921[r_9941]
						if visited2[inner2] then
						else
							visit2(inner2, stack2, stackHash1)
						end
						return r_9931((r_9941 + 1))
					else
						return nil
					end
				end)
				r_9931(1)
				popLast_21_1(stack2)
				stackHash1[state42] = nil
				return nil
			end
		end)
		visit2(state41, ({tag = "list", n = 0}), ({}))
		yield1(({["tag"]="execute",["states"]=required1}))
		return state41["value"]
	end
end)
name19 = (function(state43)
	if state43["var"] then
		return _2e2e_2("macro ", quoted1(state43["var"]["name"]))
	else
		return "unquote"
	end
end)
loaded1["tacky.resolve.state"] = ({["create"]=create4,["require"]=require_21_1,["define"]=define_21_1,["built"]=built_21_1,["executed"]=executed_21_1,["get"]=get_21_1,["name"]=name19})
gethook1 = debug.gethook
getinfo1 = debug.getinfo
sethook1 = debug.sethook
traceback1 = debug.traceback
unmangleIdent1 = (function(ident1)
	local esc4 = match1(ident1, "^(.-)%d+$")
	if (esc4 == nil) then
		return ident1
	elseif (sub1(esc4, 1, 2) == "_e") then
		return sub1(ident1, 3)
	else
		local buffer2 = ({tag = "list", n = 0})
		local pos9 = 0
		local len12 = n1(esc4)
		local r_9971 = nil
		r_9971 = (function()
			if (pos9 <= len12) then
				local char3
				local x28 = pos9
				char3 = sub1(esc4, x28, x28)
				if (char3 == "_") then
					local r_9981 = list1(find1(esc4, "^_[%da-z]+_", pos9))
					if ((type1(r_9981) == "list") and ((n1(r_9981) >= 2) and ((n1(r_9981) <= 2) and true))) then
						local start11 = r_9981[1]
						local _eend2 = r_9981[2]
						pos9 = (pos9 + 1)
						local r_10041 = nil
						r_10041 = (function()
							if (pos9 < _eend2) then
								pushCdr_21_1(buffer2, char1(tonumber1(sub1(esc4, pos9, (pos9 + 1)), 16)))
								pos9 = (pos9 + 2)
								return r_10041()
							else
								return nil
							end
						end)
						r_10041()
					else
						pushCdr_21_1(buffer2, "_")
					end
				elseif between_3f_1(char3, "A", "Z") then
					pushCdr_21_1(buffer2, "-")
					pushCdr_21_1(buffer2, lower1(char3))
				else
					pushCdr_21_1(buffer2, char3)
				end
				pos9 = (pos9 + 1)
				return r_9971()
			else
				return nil
			end
		end)
		r_9971()
		return concat1(buffer2)
	end
end)
remapError1 = (function(msg23)
	return (gsub1(gsub1(gsub1(gsub1(msg23, "local '([^']+)'", (function(x29)
		return _2e2e_2("local '", unmangleIdent1(x29), "'")
	end)), "global '([^']+)'", (function(x30)
		return _2e2e_2("global '", unmangleIdent1(x30), "'")
	end)), "upvalue '([^']+)'", (function(x31)
		return _2e2e_2("upvalue '", unmangleIdent1(x31), "'")
	end)), "function '([^']+)'", (function(x32)
		return _2e2e_2("function '", unmangleIdent1(x32), "'")
	end)))
end)
remapMessage1 = (function(mappings1, msg24)
	local r_10091 = list1(match1(msg24, "^(.-):(%d+)(.*)$"))
	if ((type1(r_10091) == "list") and ((n1(r_10091) >= 3) and ((n1(r_10091) <= 3) and true))) then
		local file1 = r_10091[1]
		local line2 = r_10091[2]
		local extra1 = r_10091[3]
		local mapping1 = mappings1[file1]
		if mapping1 then
			local range3 = mapping1[tonumber1(line2)]
			if range3 then
				return _2e2e_2(range3, " (", file1, ":", line2, ")", remapError1(extra1))
			else
				return msg24
			end
		else
			return msg24
		end
	else
		return msg24
	end
end)
remapTraceback1 = (function(mappings2, msg25)
	return gsub1(gsub1(gsub1(gsub1(gsub1(gsub1(gsub1(msg25, "^([^\n:]-:%d+:[^\n]*)", (function(r_10231)
		return remapMessage1(mappings2, r_10231)
	end)), "\9([^\n:]-:%d+:)", (function(msg26)
		return _2e2e_2("\9", remapMessage1(mappings2, msg26))
	end)), "<([^\n:]-:%d+)>\n", (function(msg27)
		return _2e2e_2("<", remapMessage1(mappings2, msg27), ">\n")
	end)), "in local '([^']+)'\n", (function(x33)
		return _2e2e_2("in local '", unmangleIdent1(x33), "'\n")
	end)), "in global '([^']+)'\n", (function(x34)
		return _2e2e_2("in global '", unmangleIdent1(x34), "'\n")
	end)), "in upvalue '([^']+)'\n", (function(x35)
		return _2e2e_2("in upvalue '", unmangleIdent1(x35), "'\n")
	end)), "in function '([^']+)'\n", (function(x36)
		return _2e2e_2("in function '", unmangleIdent1(x36), "'\n")
	end))
end)
generateMappings1 = (function(lines4)
	local outLines1 = ({})
	iterPairs1(lines4, (function(line3, ranges1)
		local rangeLists1 = ({})
		iterPairs1(ranges1, (function(pos10)
			local file2 = pos10["name"]
			local rangeList1 = rangeLists1["file"]
			if rangeList1 then
			else
				rangeList1 = ({["n"]=0,["min"]=huge1,["max"]=(0 - huge1)})
				rangeLists1[file2] = rangeList1
			end
			local r_10261 = pos10["finish"]["line"]
			local r_10241 = nil
			r_10241 = (function(r_10251)
				if (r_10251 <= r_10261) then
					if rangeList1[r_10251] then
					else
						rangeList1["n"] = (rangeList1["n"] + 1)
						rangeList1[r_10251] = true
						if (r_10251 < rangeList1["min"]) then
							rangeList1["min"] = r_10251
						end
						if (r_10251 > rangeList1["max"]) then
							rangeList1["max"] = r_10251
						end
					end
					return r_10241((r_10251 + 1))
				else
					return nil
				end
			end)
			return r_10241(pos10["start"]["line"])
		end))
		local bestName1 = nil
		local bestLines1 = nil
		local bestCount1 = 0
		iterPairs1(rangeLists1, (function(name20, lines5)
			if (lines5["n"] > bestCount1) then
				bestName1 = name20
				bestLines1 = lines5
				bestCount1 = lines5["n"]
				return nil
			else
				return nil
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
loaded1["tacky.traceback"] = ({["remapTraceback"]=remapTraceback1})
createState1 = (function(meta5)
	return ({["level"]=1,["override"]=({}),["timer"]=void1,["count"]=0,["mappings"]=({}),["cat-lookup"]=({}),["ctr-lookup"]=({}),["var-lookup"]=({}),["meta"]=(meta5 or ({}))})
end)
file3 = (function(compiler2, shebang1)
	local state44 = createState1(compiler2["libMeta"])
	local out20 = create3()
	if shebang1 then
		line_21_1(out20, _2e2e_2("#!/usr/bin/env ", shebang1))
	end
	state44["trace"] = true
	prelude1(out20)
	line_21_1(out20, "local _libs = {}")
	local r_10491 = compiler2["libs"]
	local r_10521 = n1(r_10491)
	local r_10501 = nil
	r_10501 = (function(r_10511)
		if (r_10511 <= r_10521) then
			local lib1 = r_10491[r_10511]
			local prefix1 = quoted1(lib1["prefix"])
			local native1 = lib1["native"]
			if native1 then
				line_21_1(out20, "local _temp = (function()")
				local r_10551 = split1(native1, "\n")
				local r_10581 = n1(r_10551)
				local r_10561 = nil
				r_10561 = (function(r_10571)
					if (r_10571 <= r_10581) then
						local line4 = r_10551[r_10571]
						if (line4 ~= "") then
							append_21_1(out20, "\9")
							line_21_1(out20, line4)
						end
						return r_10561((r_10571 + 1))
					else
						return nil
					end
				end)
				r_10561(1)
				line_21_1(out20, "end)()")
				line_21_1(out20, _2e2e_2("for k, v in pairs(_temp) do _libs[", prefix1, ".. k] = v end"))
			end
			return r_10501((r_10511 + 1))
		else
			return nil
		end
	end)
	r_10501(1)
	local count9 = 0
	local r_10611 = compiler2["out"]
	local r_10641 = n1(r_10611)
	local r_10621 = nil
	r_10621 = (function(r_10631)
		if (r_10631 <= r_10641) then
			if r_10611[r_10631]["defVar"] then
				count9 = (count9 + 1)
			end
			return r_10621((r_10631 + 1))
		else
			return nil
		end
	end)
	r_10621(1)
	if between_3f_1(count9, 1, 150) then
		append_21_1(out20, "local ")
		local first7 = true
		local r_10671 = compiler2["out"]
		local r_10701 = n1(r_10671)
		local r_10681 = nil
		r_10681 = (function(r_10691)
			if (r_10691 <= r_10701) then
				local node60 = r_10671[r_10691]
				local var38 = node60["defVar"]
				if var38 then
					if first7 then
						first7 = false
					else
						append_21_1(out20, ", ")
					end
					append_21_1(out20, escapeVar1(var38, state44))
				end
				return r_10681((r_10691 + 1))
			else
				return nil
			end
		end)
		r_10681(1)
		line_21_1(out20)
	else
		line_21_1(out20, "local _ENV = setmetatable({}, {__index=ENV or (getfenv and getfenv()) or _G}) if setfenv then setfenv(0, _ENV) end")
	end
	block2(compiler2["out"], out20, state44, 1, "return ")
	return out20
end)
executeStates1 = (function(backState1, states2, global1, logger10)
	local stateList1 = ({tag = "list", n = 0})
	local nameList1 = ({tag = "list", n = 0})
	local exportList1 = ({tag = "list", n = 0})
	local escapeList1 = ({tag = "list", n = 0})
	local r_7361 = nil
	r_7361 = (function(r_7371)
		if (r_7371 >= 1) then
			local state45 = states2[r_7371]
			if (state45["stage"] == "executed") then
			else
				local node61
				if state45["node"] then
					node61 = nil
				else
					node61 = error1(_2e2e_2("State is in ", state45["stage"], " instead"), 0)
				end
				local var39 = (state45["var"] or ({["name"]="temp"}))
				local escaped1 = escapeVar1(var39, backState1)
				local name21 = var39["name"]
				pushCdr_21_1(stateList1, state45)
				pushCdr_21_1(exportList1, _2e2e_2(escaped1, " = ", escaped1))
				pushCdr_21_1(nameList1, name21)
				pushCdr_21_1(escapeList1, escaped1)
			end
			return r_7361((r_7371 + -1))
		else
			return nil
		end
	end)
	r_7361(n1(states2))
	if empty_3f_1(stateList1) then
		return nil
	else
		local out21 = create3()
		local id3 = backState1["count"]
		local name22 = concat1(nameList1, ",")
		backState1["count"] = (id3 + 1)
		if (n1(name22) > 20) then
			name22 = _2e2e_2(sub1(name22, 1, 17), "...")
		end
		name22 = _2e2e_2("compile#", id3, "{", name22, "}")
		prelude1(out21)
		line_21_1(out21, _2e2e_2("local ", concat1(escapeList1, ", ")))
		local r_10851 = n1(stateList1)
		local r_10831 = nil
		r_10831 = (function(r_10841)
			if (r_10841 <= r_10851) then
				local state46 = stateList1[r_10841]
				expression2(state46["node"], out21, backState1, (function()
					if state46["var"] then
						return ""
					else
						return _2e2e_2(escapeList1[r_10841], "= ")
					end
				end)()
				)
				line_21_1(out21)
				return r_10831((r_10841 + 1))
			else
				return nil
			end
		end)
		r_10831(1)
		line_21_1(out21, _2e2e_2("return { ", concat1(exportList1, ", "), "}"))
		local str4 = concat1(out21["out"])
		backState1["mappings"][name22] = generateMappings1(out21["lines"])
		local r_10871 = list1(load1(str4, _2e2e_2("=", name22), "t", global1))
		if ((type1(r_10871) == "list") and ((n1(r_10871) >= 2) and ((n1(r_10871) <= 2) and (eq_3f_1(r_10871[1], nil) and true)))) then
			local msg28 = r_10871[2]
			local buffer3 = ({tag = "list", n = 0})
			local lines6 = split1(str4, "\n")
			local format2 = _2e2e_2("%", n1(tostring1(n1(lines6))), "d | %s")
			local r_10961 = n1(lines6)
			local r_10941 = nil
			r_10941 = (function(r_10951)
				if (r_10951 <= r_10961) then
					pushCdr_21_1(buffer3, format1(format2, r_10951, lines6[r_10951]))
					return r_10941((r_10951 + 1))
				else
					return nil
				end
			end)
			r_10941(1)
			return error1(_2e2e_2(msg28, ":\n", concat1(buffer3, "\n")), 0)
		elseif ((type1(r_10871) == "list") and ((n1(r_10871) >= 1) and ((n1(r_10871) <= 1) and true))) then
			local fun1 = r_10871[1]
			local r_11011 = list1(xpcall1(fun1, traceback1))
			if ((type1(r_11011) == "list") and ((n1(r_11011) >= 2) and ((n1(r_11011) <= 2) and (eq_3f_1(r_11011[1], false) and true)))) then
				local msg29 = r_11011[2]
				return error1(remapTraceback1(backState1["mappings"], msg29), 0)
			elseif ((type1(r_11011) == "list") and ((n1(r_11011) >= 2) and ((n1(r_11011) <= 2) and (eq_3f_1(r_11011[1], true) and true)))) then
				local tbl1 = r_11011[2]
				local r_11141 = n1(stateList1)
				local r_11121 = nil
				r_11121 = (function(r_11131)
					if (r_11131 <= r_11141) then
						local state47 = stateList1[r_11131]
						local escaped2 = escapeList1[r_11131]
						local res8 = tbl1[escaped2]
						executed_21_1(state47, res8)
						if state47["var"] then
							global1[escaped2] = res8
						end
						return r_11121((r_11131 + 1))
					else
						return nil
					end
				end)
				return r_11121(1)
			else
				return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_11011), ", but none matched.\n", "  Tried: `(false ?msg)`\n  Tried: `(true ?tbl)`"))
			end
		else
			return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_10871), ", but none matched.\n", "  Tried: `(nil ?msg)`\n  Tried: `(?fun)`"))
		end
	end
end)
native2 = (function(meta6, global2)
	local out22 = create3()
	prelude1(out22)
	append_21_1(out22, "return ")
	compileNative1(out22, meta6)
	local r_10731 = list1(load1(concat1(out22["out"]), _2e2e_2("=", meta6["name"]), "t", global2))
	if ((type1(r_10731) == "list") and ((n1(r_10731) >= 2) and ((n1(r_10731) <= 2) and (eq_3f_1(r_10731[1], nil) and true)))) then
		local msg30 = r_10731[2]
		return error1(_2e2e_2("Cannot compile meta ", meta6["name"], ":\n", msg30), 0)
	elseif ((type1(r_10731) == "list") and ((n1(r_10731) >= 1) and ((n1(r_10731) <= 1) and true))) then
		return r_10731[1]()
	else
		return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_10731), ", but none matched.\n", "  Tried: `(nil ?msg)`\n  Tried: `(?fun)`"))
	end
end)
emitLua1 = ({["name"]="emit-lua",["setup"]=(function(spec6)
	addArgument_21_1(spec6, ({tag = "list", n = 1, "--emit-lua"}), "help", "Emit a Lua file.")
	addArgument_21_1(spec6, ({tag = "list", n = 1, "--shebang"}), "value", (arg1[-1] or (arg1[0] or "lua")), "help", "Set the executable to use for the shebang.", "narg", "?")
	return addArgument_21_1(spec6, ({tag = "list", n = 1, "--chmod"}), "help", "Run chmod +x on the resulting file")
end),["pred"]=(function(args15)
	return args15["emit-lua"]
end),["run"]=(function(compiler3, args16)
	if empty_3f_1(args16["input"]) then
		self1(compiler3["log"], "put-error!", "No inputs to compile.")
		exit_21_1(1)
	end
	local out23 = file3(compiler3, args16["shebang"])
	local handle1 = open1(_2e2e_2(args16["output"], ".lua"), "w")
	self1(handle1, "write", concat1(out23["out"]))
	self1(handle1, "close")
	if args16["chmod"] then
		return execute1(_2e2e_2("chmod +x ", quoted1(_2e2e_2(args16["output"], ".lua"))))
	else
		return nil
	end
end)})
emitLisp1 = ({["name"]="emit-lisp",["setup"]=(function(spec7)
	return addArgument_21_1(spec7, ({tag = "list", n = 1, "--emit-lisp"}), "help", "Emit a Lisp file.")
end),["pred"]=(function(args17)
	return args17["emit-lisp"]
end),["run"]=(function(compiler4, args18)
	if empty_3f_1(args18["input"]) then
		self1(compiler4["log"], "put-error!", "No inputs to compile.")
		exit_21_1(1)
	end
	local writer12 = create3()
	block1(compiler4["out"], writer12)
	local handle2 = open1(_2e2e_2(args18["output"], ".lisp"), "w")
	self1(handle2, "write", concat1(writer12["out"]))
	return self1(handle2, "close")
end)})
passArg1 = (function(arg25, data4, value11, usage_21_4)
	local val19 = tonumber1(value11)
	local name23 = _2e2e_2(arg25["name"], "-override")
	local override2 = data4[name23]
	if override2 then
	else
		override2 = ({})
		data4[name23] = override2
	end
	if val19 then
		data4[arg25["name"]] = val19
		return nil
	elseif (sub1(value11, 1, 1) == "-") then
		override2[sub1(value11, 2)] = false
		return nil
	elseif (sub1(value11, 1, 1) == "+") then
		override2[sub1(value11, 2)] = true
		return nil
	else
		return usage_21_4(_2e2e_2("Expected number or enable/disable flag for --", arg25["name"], " , got ", value11))
	end
end)
passRun1 = (function(fun2, name24, passes1)
	return (function(compiler5, args19)
		return fun2(compiler5["out"], ({["track"]=true,["level"]=args19[name24],["override"]=(args19[_2e2e_2(name24, "-override")] or ({})),["pass"]=compiler5[name24],["max-n"]=args19[_2e2e_2(name24, "-n")],["max-time"]=args19[_2e2e_2(name24, "-time")],["compiler"]=compiler5,["meta"]=compiler5["libMeta"],["libs"]=compiler5["libs"],["logger"]=compiler5["log"],["timer"]=compiler5["timer"]}))
	end)
end)
warning1 = ({["name"]="warning",["setup"]=(function(spec8)
	return addArgument_21_1(spec8, ({tag = "list", n = 2, "--warning", "-W"}), "help", "Either the warning level to use or an enable/disable flag for a pass.", "default", 1, "narg", 1, "var", "LEVEL", "many", true, "action", passArg1)
end),["pred"]=(function(args20)
	return (args20["warning"] > 0)
end),["run"]=passRun1(analyse1, "warning")})
optimise2 = ({["name"]="optimise",["setup"]=(function(spec9)
	addArgument_21_1(spec9, ({tag = "list", n = 2, "--optimise", "-O"}), "help", "Either the optimiation level to use or an enable/disable flag for a pass.", "default", 1, "narg", 1, "var", "LEVEL", "many", true, "action", passArg1)
	addArgument_21_1(spec9, ({tag = "list", n = 2, "--optimise-n", "--optn"}), "help", "The maximum number of iterations the optimiser should run for.", "default", 10, "narg", 1, "action", setNumAction1)
	return addArgument_21_1(spec9, ({tag = "list", n = 2, "--optimise-time", "--optt"}), "help", "The maximum time the optimiser should run for.", "default", -1, "narg", 1, "action", setNumAction1)
end),["pred"]=(function(args21)
	return (args21["optimise"] > 0)
end),["run"]=passRun1(optimise1, "optimise")})
formatRange2 = (function(range4)
	return format1("%s:%s", range4["name"], (function(pos11)
		return _2e2e_2(pos11["line"], ":", pos11["column"])
	end)(range4["start"]))
end)
sortVars_21_1 = (function(list5)
	return sort1(list5, (function(a2, b2)
		return (car1(a2) < car1(b2))
	end))
end)
formatDefinition1 = (function(var40)
	local ty7 = type1(var40)
	if (ty7 == "builtin") then
		return "Builtin term"
	elseif (ty7 == "macro") then
		return _2e2e_2("Macro defined at ", formatRange2(getSource1(var40["node"])))
	elseif (ty7 == "native") then
		return _2e2e_2("Native defined at ", formatRange2(getSource1(var40["node"])))
	elseif (ty7 == "defined") then
		return _2e2e_2("Defined at ", formatRange2(getSource1(var40["node"])))
	else
		_error("unmatched item")
	end
end)
formatSignature1 = (function(name25, var41)
	local sig1 = extractSignature1(var41)
	if (sig1 == nil) then
		return name25
	elseif empty_3f_1(sig1) then
		return _2e2e_2("(", name25, ")")
	else
		return _2e2e_2("(", name25, " ", concat1(map1((function(r_11181)
			return r_11181["contents"]
		end), sig1), " "), ")")
	end
end)
writeDocstring1 = (function(out24, str5, scope10)
	local r_11201 = parseDocstring1(str5)
	local r_11231 = n1(r_11201)
	local r_11211 = nil
	r_11211 = (function(r_11221)
		if (r_11221 <= r_11231) then
			local tok3 = r_11201[r_11221]
			local ty8 = type1(tok3)
			if (ty8 == "text") then
				append_21_1(out24, tok3["contents"])
			elseif (ty8 == "boldic") then
				append_21_1(out24, tok3["contents"])
			elseif (ty8 == "bold") then
				append_21_1(out24, tok3["contents"])
			elseif (ty8 == "italic") then
				append_21_1(out24, tok3["contents"])
			elseif (ty8 == "arg") then
				append_21_1(out24, _2e2e_2("`", tok3["contents"], "`"))
			elseif (ty8 == "mono") then
				append_21_1(out24, tok3["whole"])
			elseif (ty8 == "link") then
				local name26 = tok3["contents"]
				local ovar1 = get1(scope10, name26)
				if (ovar1 and ovar1["node"]) then
					local loc1 = gsub1(gsub1(getSource1((ovar1["node"]))["name"], "%.lisp$", ""), "/", ".")
					local sig2 = extractSignature1(ovar1)
					append_21_1(out24, format1("[`%s`](%s.md#%s)", name26, loc1, gsub1((function()
						if (sig2 == nil) then
							return ovar1["name"]
						elseif empty_3f_1(sig2) then
							return ovar1["name"]
						else
							return _2e2e_2(name26, " ", concat1(map1((function(r_11261)
								return r_11261["contents"]
							end), sig2), " "))
						end
					end)()
					, "%A+", "-")))
				else
					append_21_1(out24, format1("`%s`", name26))
				end
			else
				_error("unmatched item")
			end
			return r_11211((r_11221 + 1))
		else
			return nil
		end
	end)
	r_11211(1)
	return line_21_1(out24)
end)
exported1 = (function(out25, title1, primary1, vars2, scope11)
	local documented1 = ({tag = "list", n = 0})
	local undocumented1 = ({tag = "list", n = 0})
	iterPairs1(vars2, (function(name27, var42)
		return pushCdr_21_1((function()
			if var42["doc"] then
				return documented1
			else
				return undocumented1
			end
		end)()
		, list1(name27, var42))
	end))
	sortVars_21_1(documented1)
	sortVars_21_1(undocumented1)
	line_21_1(out25, "---")
	line_21_1(out25, _2e2e_2("title: ", title1))
	line_21_1(out25, "---")
	line_21_1(out25, _2e2e_2("# ", title1))
	if primary1 then
		writeDocstring1(out25, primary1, scope11)
		line_21_1(out25, "", true)
	end
	local r_11351 = n1(documented1)
	local r_11331 = nil
	r_11331 = (function(r_11341)
		if (r_11341 <= r_11351) then
			local entry7 = documented1[r_11341]
			local name28 = car1(entry7)
			local var43 = entry7[2]
			line_21_1(out25, _2e2e_2("## `", formatSignature1(name28, var43), "`"))
			line_21_1(out25, _2e2e_2("*", formatDefinition1(var43), "*"))
			line_21_1(out25, "", true)
			if var43["deprecated"] then
				line_21_1(out25, (function()
					if string_3f_1(var43["deprecated"]) then
						return format1("> **Warning:** %s is deprecated: %s", name28, var43["deprecated"])
					else
						return format1("> **Warning:** %s is deprecated.", name28)
					end
				end)()
				)
				line_21_1(out25, "", true)
			end
			writeDocstring1(out25, var43["doc"], var43["scope"])
			line_21_1(out25, "", true)
			return r_11331((r_11341 + 1))
		else
			return nil
		end
	end)
	r_11331(1)
	if empty_3f_1(undocumented1) then
	else
		line_21_1(out25, "## Undocumented symbols")
	end
	local r_11411 = n1(undocumented1)
	local r_11391 = nil
	r_11391 = (function(r_11401)
		if (r_11401 <= r_11411) then
			local entry8 = undocumented1[r_11401]
			local name29 = car1(entry8)
			local var44 = entry8[2]
			line_21_1(out25, _2e2e_2(" - `", formatSignature1(name29, var44), "` *", formatDefinition1(var44), "*"))
			return r_11391((r_11401 + 1))
		else
			return nil
		end
	end)
	return r_11391(1)
end)
docs1 = (function(compiler6, args22)
	if empty_3f_1(args22["input"]) then
		self1(compiler6["log"], "put-error!", "No inputs to generate documentation for.")
		exit_21_1(1)
	end
	local r_11441 = args22["input"]
	local r_11471 = n1(r_11441)
	local r_11451 = nil
	r_11451 = (function(r_11461)
		if (r_11461 <= r_11471) then
			local path1 = r_11441[r_11461]
			if (sub1(path1, -5) == ".lisp") then
				path1 = sub1(path1, 1, -6)
			end
			local lib2 = compiler6["libCache"][path1]
			local writer13 = create3()
			exported1(writer13, lib2["name"], lib2["docs"], lib2["scope"]["exported"], lib2["scope"])
			local handle3 = open1(_2e2e_2(args22["docs"], "/", gsub1(path1, "/", "."), ".md"), "w")
			self1(handle3, "write", concat1(writer13["out"]))
			self1(handle3, "close")
			return r_11451((r_11461 + 1))
		else
			return nil
		end
	end)
	return r_11451(1)
end)
task1 = ({["name"]="docs",["setup"]=(function(spec10)
	return addArgument_21_1(spec10, ({tag = "list", n = 1, "--docs"}), "help", "Specify the folder to emit documentation to.", "default", nil, "narg", 1)
end),["pred"]=(function(args23)
	return (nil ~= args23["docs"])
end),["run"]=docs1})
local discard1 = (function()
	return nil
end)
void2 = ({["put-error!"]=discard1,["put-warning!"]=discard1,["put-verbose!"]=discard1,["put-debug!"]=discard1,["put-time!"]=discard1,["put-node-error!"]=discard1,["put-node-warning!"]=discard1})
hexDigit_3f_1 = (function(char4)
	return (between_3f_1(char4, "0", "9") or (between_3f_1(char4, "a", "f") or between_3f_1(char4, "A", "F")))
end)
binDigit_3f_1 = (function(char5)
	return ((char5 == "0") or (char5 == "1"))
end)
terminator_3f_1 = (function(char6)
	return ((char6 == "\n") or ((char6 == " ") or ((char6 == "\9") or ((char6 == ";") or ((char6 == "(") or ((char6 == ")") or ((char6 == "[") or ((char6 == "]") or ((char6 == "{") or ((char6 == "}") or (char6 == "")))))))))))
end)
digitError_21_1 = (function(logger11, pos12, name30, char7)
	return doNodeError_21_1(logger11, format1("Expected %s digit, got %s", name30, (function()
		if (char7 == "") then
			return "eof"
		else
			return quoted1(char7)
		end
	end)()
	), pos12, nil, pos12, "Invalid digit here")
end)
eofError_21_1 = (function(cont1, logger12, msg31, node62, explain4, ...)
	local lines7 = _pack(...) lines7.tag = "list"
	if cont1 then
		return error1(({["msg"]=msg31,["cont"]=true}), 0)
	else
		return doNodeError_21_1(logger12, msg31, node62, explain4, unpack1(lines7, 1, n1(lines7)))
	end
end)
lex1 = (function(logger13, str6, name31, cont2)
	str6 = gsub1(str6, "\13\n?", "\n")
	local lines8 = split1(str6, "\n")
	local line5 = 1
	local column1 = 1
	local offset7 = 1
	local length1 = n1(str6)
	local out26 = ({tag = "list", n = 0})
	local consume_21_1 = (function()
		if ((function(xs14, x37)
			return sub1(xs14, x37, x37)
		end)(str6, offset7) == "\n") then
			line5 = (line5 + 1)
			column1 = 1
		else
			column1 = (column1 + 1)
		end
		offset7 = (offset7 + 1)
		return nil
	end)
	local range5 = (function(start12, finish2)
		return ({["start"]=start12,["finish"]=(finish2 or start12),["lines"]=lines8,["name"]=name31})
	end)
	local appendWith_21_1 = (function(data5, start13, finish3)
		local start14 = (start13 or ({["line"]=line5,["column"]=column1,["offset"]=offset7}))
		local finish4 = (finish3 or ({["line"]=line5,["column"]=column1,["offset"]=offset7}))
		data5["range"] = range5(start14, finish4)
		data5["contents"] = sub1(str6, start14["offset"], finish4["offset"])
		return pushCdr_21_1(out26, data5)
	end)
	local parseBase1 = (function(name32, p3, base1)
		local start15 = offset7
		local char8
		local xs15 = str6
		local x38 = offset7
		char8 = sub1(xs15, x38, x38)
		if p3(char8) then
		else
			digitError_21_1(logger13, range5(({["line"]=line5,["column"]=column1,["offset"]=offset7})), name32, char8)
		end
		local xs16 = str6
		local x39 = (offset7 + 1)
		char8 = sub1(xs16, x39, x39)
		local r_12171 = nil
		r_12171 = (function()
			if p3(char8) then
				consume_21_1()
				local xs17 = str6
				local x40 = (offset7 + 1)
				char8 = sub1(xs17, x40, x40)
				return r_12171()
			else
				return nil
			end
		end)
		r_12171()
		return tonumber1(sub1(str6, start15, offset7), base1)
	end)
	local r_11871 = nil
	r_11871 = (function()
		if (offset7 <= length1) then
			local char9
			local xs18 = str6
			local x41 = offset7
			char9 = sub1(xs18, x41, x41)
			if ((char9 == "\n") or ((char9 == "\9") or (char9 == " "))) then
			elseif (char9 == "(") then
				appendWith_21_1(({["tag"]="open",["close"]=")"}))
			elseif (char9 == ")") then
				appendWith_21_1(({["tag"]="close",["open"]="("}))
			elseif (char9 == "[") then
				appendWith_21_1(({["tag"]="open",["close"]="]"}))
			elseif (char9 == "]") then
				appendWith_21_1(({["tag"]="close",["open"]="["}))
			elseif (char9 == "{") then
				appendWith_21_1(({["tag"]="open-struct",["close"]="}"}))
			elseif (char9 == "}") then
				appendWith_21_1(({["tag"]="close",["open"]="{"}))
			elseif (char9 == "'") then
				local start16
				local finish5
				appendWith_21_1(({["tag"]="quote"}), nil, nil)
			elseif (char9 == "`") then
				local start17
				local finish6
				appendWith_21_1(({["tag"]="syntax-quote"}), nil, nil)
			elseif (char9 == "~") then
				local start18
				local finish7
				appendWith_21_1(({["tag"]="quasiquote"}), nil, nil)
			elseif (char9 == ",") then
				if ((function(xs19, x42)
					return sub1(xs19, x42, x42)
				end)(str6, (offset7 + 1)) == "@") then
					local start19 = ({["line"]=line5,["column"]=column1,["offset"]=offset7})
					consume_21_1()
					local finish8
					appendWith_21_1(({["tag"]="unquote-splice"}), start19, nil)
				else
					local start20
					local finish9
					appendWith_21_1(({["tag"]="unquote"}), nil, nil)
				end
			elseif find1(str6, "^%-?%.?[#0-9]", offset7) then
				local start21 = ({["line"]=line5,["column"]=column1,["offset"]=offset7})
				local negative1 = (char9 == "-")
				if negative1 then
					consume_21_1()
					local xs20 = str6
					local x43 = offset7
					char9 = sub1(xs20, x43, x43)
				end
				local val20
				if ((char9 == "#") and (lower1((function(xs21, x44)
					return sub1(xs21, x44, x44)
				end)(str6, (offset7 + 1))) == "x")) then
					consume_21_1()
					consume_21_1()
					local res9 = parseBase1("hexadecimal", hexDigit_3f_1, 16)
					if negative1 then
						res9 = (0 - res9)
					end
					val20 = res9
				elseif ((char9 == "#") and (lower1((function(xs22, x45)
					return sub1(xs22, x45, x45)
				end)(str6, (offset7 + 1))) == "b")) then
					consume_21_1()
					consume_21_1()
					local res10 = parseBase1("binary", binDigit_3f_1, 2)
					if negative1 then
						res10 = (0 - res10)
					end
					val20 = res10
				elseif ((char9 == "#") and terminator_3f_1(lower1((function(xs23, x46)
					return sub1(xs23, x46, x46)
				end)(str6, (offset7 + 1))))) then
					val20 = doNodeError_21_1(logger13, "Expected hexadecimal (#x) or binary (#b) digit.", range5(({["line"]=line5,["column"]=column1,["offset"]=offset7})), "The '#' character is used for various number representations, such as binary\nand hexadecimal digits.\n\nIf you're looking for the '#' function, this has been replaced with 'n'. We\napologise for the inconvenience.", range5(({["line"]=line5,["column"]=column1,["offset"]=offset7})), "# must be followed by x or b")
				elseif (char9 == "#") then
					consume_21_1()
					val20 = doNodeError_21_1(logger13, "Expected hexadecimal (#x) or binary (#b) digit specifier.", range5(({["line"]=line5,["column"]=column1,["offset"]=offset7})), "The '#' character is used for various number representations, namely binary\nand hexadecimal digits.", range5(({["line"]=line5,["column"]=column1,["offset"]=offset7})), "# must be followed by x or b")
				else
					local r_12011 = nil
					r_12011 = (function()
						if between_3f_1((function(xs24, x47)
							return sub1(xs24, x47, x47)
						end)(str6, (offset7 + 1)), "0", "9") then
							consume_21_1()
							return r_12011()
						else
							return nil
						end
					end)
					r_12011()
					if ((function(xs25, x48)
						return sub1(xs25, x48, x48)
					end)(str6, (offset7 + 1)) == ".") then
						consume_21_1()
						local r_12021 = nil
						r_12021 = (function()
							if between_3f_1((function(xs26, x49)
								return sub1(xs26, x49, x49)
							end)(str6, (offset7 + 1)), "0", "9") then
								consume_21_1()
								return r_12021()
							else
								return nil
							end
						end)
						r_12021()
					end
					local xs27 = str6
					local x50 = (offset7 + 1)
					char9 = sub1(xs27, x50, x50)
					if ((char9 == "e") or (char9 == "E")) then
						consume_21_1()
						local xs28 = str6
						local x51 = (offset7 + 1)
						char9 = sub1(xs28, x51, x51)
						if ((char9 == "-") or (char9 == "+")) then
							consume_21_1()
						end
						local r_12051 = nil
						r_12051 = (function()
							if between_3f_1((function(xs29, x52)
								return sub1(xs29, x52, x52)
							end)(str6, (offset7 + 1)), "0", "9") then
								consume_21_1()
								return r_12051()
							else
								return nil
							end
						end)
						r_12051()
					end
					val20 = tonumber1(sub1(str6, start21["offset"], offset7))
				end
				appendWith_21_1(({["tag"]="number",["value"]=val20}), start21)
				local xs30 = str6
				local x53 = (offset7 + 1)
				char9 = sub1(xs30, x53, x53)
				if terminator_3f_1(char9) then
				else
					consume_21_1()
					doNodeError_21_1(logger13, format1("Expected digit, got %s", (function()
						if (char9 == "") then
							return "eof"
						else
							return char9
						end
					end)()
					), range5(({["line"]=line5,["column"]=column1,["offset"]=offset7})), nil, range5(({["line"]=line5,["column"]=column1,["offset"]=offset7})), "Illegal character here. Are you missing whitespace?")
				end
			elseif (char9 == "\"") then
				local start22 = ({["line"]=line5,["column"]=column1,["offset"]=offset7})
				local startCol1 = (column1 + 1)
				local buffer4 = ({tag = "list", n = 0})
				consume_21_1()
				local xs31 = str6
				local x54 = offset7
				char9 = sub1(xs31, x54, x54)
				local r_12061 = nil
				r_12061 = (function()
					if (char9 ~= "\"") then
						if (column1 == 1) then
							local running3 = true
							local lineOff1 = offset7
							local r_12071 = nil
							r_12071 = (function()
								if (running3 and (column1 < startCol1)) then
									if (char9 == " ") then
										consume_21_1()
									elseif (char9 == "\n") then
										consume_21_1()
										pushCdr_21_1(buffer4, "\n")
										lineOff1 = offset7
									elseif (char9 == "") then
										running3 = false
									else
										putNodeWarning_21_1(logger13, format1("Expected leading indent, got %q", char9), range5(({["line"]=line5,["column"]=column1,["offset"]=offset7})), "You should try to align multi-line strings at the initial quote\nmark. This helps keep programs neat and tidy.", range5(start22), "String started with indent here", range5(({["line"]=line5,["column"]=column1,["offset"]=offset7})), "Mis-aligned character here")
										pushCdr_21_1(buffer4, sub1(str6, lineOff1, (offset7 - 1)))
										running3 = false
									end
									local xs32 = str6
									local x55 = offset7
									char9 = sub1(xs32, x55, x55)
									return r_12071()
								else
									return nil
								end
							end)
							r_12071()
						end
						if (char9 == "") then
							local start23 = range5(start22)
							local finish10 = range5(({["line"]=line5,["column"]=column1,["offset"]=offset7}))
							eofError_21_1(cont2, logger13, "Expected '\"', got eof", finish10, nil, start23, "string started here", finish10, "end of file here")
						elseif (char9 == "\\") then
							consume_21_1()
							local xs33 = str6
							local x56 = offset7
							char9 = sub1(xs33, x56, x56)
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
							elseif ((char9 == "x") or ((char9 == "X") or between_3f_1(char9, "0", "9"))) then
								local start24 = ({["line"]=line5,["column"]=column1,["offset"]=offset7})
								local val21
								if ((char9 == "x") or (char9 == "X")) then
									consume_21_1()
									local start25 = offset7
									if hexDigit_3f_1((function(xs34, x57)
										return sub1(xs34, x57, x57)
									end)(str6, offset7)) then
									else
										digitError_21_1(logger13, range5(({["line"]=line5,["column"]=column1,["offset"]=offset7})), "hexadecimal", (function(xs35, x58)
											return sub1(xs35, x58, x58)
										end)(str6, offset7))
									end
									if hexDigit_3f_1((function(xs36, x59)
										return sub1(xs36, x59, x59)
									end)(str6, (offset7 + 1))) then
										consume_21_1()
									end
									val21 = tonumber1(sub1(str6, start25, offset7), 16)
								else
									local start26 = ({["line"]=line5,["column"]=column1,["offset"]=offset7})
									local ctr1 = 0
									local xs37 = str6
									local x60 = (offset7 + 1)
									char9 = sub1(xs37, x60, x60)
									local r_12121 = nil
									r_12121 = (function()
										if ((ctr1 < 2) and between_3f_1(char9, "0", "9")) then
											consume_21_1()
											local xs38 = str6
											local x61 = (offset7 + 1)
											char9 = sub1(xs38, x61, x61)
											ctr1 = (ctr1 + 1)
											return r_12121()
										else
											return nil
										end
									end)
									r_12121()
									val21 = tonumber1(sub1(str6, start26["offset"], offset7))
								end
								if (val21 >= 256) then
									doNodeError_21_1(logger13, "Invalid escape code", range5(start24), nil, range5(start24, ({["line"]=line5,["column"]=column1,["offset"]=offset7})), _2e2e_2("Must be between 0 and 255, is ", val21))
								end
								pushCdr_21_1(buffer4, char1(val21))
							elseif (char9 == "") then
								eofError_21_1(cont2, logger13, "Expected escape code, got eof", range5(({["line"]=line5,["column"]=column1,["offset"]=offset7})), nil, range5(({["line"]=line5,["column"]=column1,["offset"]=offset7})), "end of file here")
							else
								doNodeError_21_1(logger13, "Illegal escape character", range5(({["line"]=line5,["column"]=column1,["offset"]=offset7})), nil, range5(({["line"]=line5,["column"]=column1,["offset"]=offset7})), "Unknown escape character")
							end
						else
							pushCdr_21_1(buffer4, char9)
						end
						consume_21_1()
						local xs39 = str6
						local x62 = offset7
						char9 = sub1(xs39, x62, x62)
						return r_12061()
					else
						return nil
					end
				end)
				r_12061()
				appendWith_21_1(({["tag"]="string",["value"]=concat1(buffer4)}), start22)
			elseif (char9 == ";") then
				local r_12141 = nil
				r_12141 = (function()
					if ((offset7 <= length1) and ((function(xs40, x63)
						return sub1(xs40, x63, x63)
					end)(str6, (offset7 + 1)) ~= "\n")) then
						consume_21_1()
						return r_12141()
					else
						return nil
					end
				end)
				r_12141()
			else
				local start27 = ({["line"]=line5,["column"]=column1,["offset"]=offset7})
				local key10 = (char9 == ":")
				local xs41 = str6
				local x64 = (offset7 + 1)
				char9 = sub1(xs41, x64, x64)
				local r_12161 = nil
				r_12161 = (function()
					if not terminator_3f_1(char9) then
						consume_21_1()
						local xs42 = str6
						local x65 = (offset7 + 1)
						char9 = sub1(xs42, x65, x65)
						return r_12161()
					else
						return nil
					end
				end)
				r_12161()
				if key10 then
					appendWith_21_1(({["tag"]="key",["value"]=sub1(str6, (start27["offset"] + 1), offset7)}), start27)
				else
					local finish11
					appendWith_21_1(({["tag"]="symbol"}), start27, nil)
				end
			end
			consume_21_1()
			return r_11871()
		else
			return nil
		end
	end)
	r_11871()
	local start28
	local finish12
	appendWith_21_1(({["tag"]="eof"}), nil, nil)
	return out26
end)
parse1 = (function(logger14, toks1, cont3)
	local head9 = ({tag = "list", n = 0})
	local stack3 = ({tag = "list", n = 0})
	local push_21_1 = (function()
		local next1 = ({tag = "list", n = 0})
		pushCdr_21_1(stack3, head9)
		pushCdr_21_1(head9, next1)
		head9 = next1
		return nil
	end)
	local pop_21_1 = (function()
		head9["open"] = nil
		head9["close"] = nil
		head9["auto-close"] = nil
		head9["last-node"] = nil
		head9 = last1(stack3)
		return popLast_21_1(stack3)
	end)
	local r_11941 = n1(toks1)
	local r_11921 = nil
	r_11921 = (function(r_11931)
		if (r_11931 <= r_11941) then
			local tok4 = toks1[r_11931]
			local tag10 = tok4["tag"]
			local autoClose1 = false
			local previous4 = head9["last-node"]
			local tokPos1 = tok4["range"]
			local temp12
			if (tag10 ~= "eof") then
				if (tag10 ~= "close") then
					if head9["range"] then
						temp12 = (tokPos1["start"]["line"] ~= head9["range"]["start"]["line"])
					else
						temp12 = true
					end
				else
					temp12 = false
				end
			else
				temp12 = false
			end
			if temp12 then
				if previous4 then
					local prevPos1 = previous4["range"]
					if (tokPos1["start"]["line"] ~= prevPos1["start"]["line"]) then
						head9["last-node"] = tok4
						if (tokPos1["start"]["column"] ~= prevPos1["start"]["column"]) then
							putNodeWarning_21_1(logger14, "Different indent compared with previous expressions.", tok4, "You should try to maintain consistent indentation across a program,\ntry to ensure all expressions are lined up.\nIf this looks OK to you, check you're not missing a closing ')'.", prevPos1, "", tokPos1, "")
						end
					end
				else
					head9["last-node"] = tok4
				end
			end
			if ((tag10 == "string") or ((tag10 == "number") or ((tag10 == "symbol") or (tag10 == "key")))) then
				pushCdr_21_1(head9, tok4)
			elseif (tag10 == "open") then
				push_21_1()
				head9["open"] = tok4["contents"]
				head9["close"] = tok4["close"]
				head9["range"] = ({["start"]=tok4["range"]["start"],["name"]=tok4["range"]["name"],["lines"]=tok4["range"]["lines"]})
			elseif (tag10 == "open-struct") then
				push_21_1()
				head9["open"] = tok4["contents"]
				head9["close"] = tok4["close"]
				head9["range"] = ({["start"]=tok4["range"]["start"],["name"]=tok4["range"]["name"],["lines"]=tok4["range"]["lines"]})
				local node63 = ({["tag"]="symbol",["contents"]="struct-literal",["range"]=head9["range"]})
				pushCdr_21_1(head9, node63)
			elseif (tag10 == "close") then
				if empty_3f_1(stack3) then
					doNodeError_21_1(logger14, format1("'%s' without matching '%s'", tok4["contents"], tok4["open"]), tok4, nil, getSource1(tok4), "")
				elseif head9["auto-close"] then
					doNodeError_21_1(logger14, format1("'%s' without matching '%s' inside quote", tok4["contents"], tok4["open"]), tok4, nil, head9["range"], "quote opened here", tok4["range"], "attempting to close here")
				elseif (head9["close"] ~= tok4["contents"]) then
					doNodeError_21_1(logger14, format1("Expected '%s', got '%s'", head9["close"], tok4["contents"]), tok4, nil, head9["range"], format1("block opened with '%s'", head9["open"]), tok4["range"], format1("'%s' used here", tok4["contents"]))
				else
					head9["range"]["finish"] = tok4["range"]["finish"]
					pop_21_1()
				end
			elseif ((tag10 == "quote") or ((tag10 == "unquote") or ((tag10 == "syntax-quote") or ((tag10 == "unquote-splice") or (tag10 == "quasiquote"))))) then
				push_21_1()
				head9["range"] = ({["start"]=tok4["range"]["start"],["name"]=tok4["range"]["name"],["lines"]=tok4["range"]["lines"]})
				local node64 = ({["tag"]="symbol",["contents"]=tag10,["range"]=tok4["range"]})
				pushCdr_21_1(head9, node64)
				autoClose1 = true
				head9["auto-close"] = true
			elseif (tag10 == "eof") then
				if (0 ~= n1(stack3)) then
					eofError_21_1(cont3, logger14, format1("Expected '%s', got 'eof'", head9["close"]), tok4, nil, head9["range"], "block opened here", tok4["range"], "end of file here")
				end
			else
				error1(_2e2e_2("Unsupported type", tag10))
			end
			if autoClose1 then
			else
				local r_12281 = nil
				r_12281 = (function()
					if head9["auto-close"] then
						if empty_3f_1(stack3) then
							doNodeError_21_1(logger14, format1("'%s' without matching '%s'", tok4["contents"], tok4["open"]), tok4, nil, getSource1(tok4), "")
						end
						head9["range"]["finish"] = tok4["range"]["finish"]
						pop_21_1()
						return r_12281()
					else
						return nil
					end
				end)
				r_12281()
			end
			return r_11921((r_11931 + 1))
		else
			return nil
		end
	end)
	r_11921(1)
	return head9
end)
read2 = (function(x66, path2)
	return parse1(void2, lex1(void2, x66, (path2 or "")))
end)
local resolver1 = nil
resolve_2f_resolve1 = (function(...)
	local args24 = _pack(...) args24.tag = "list"
	if resolver1 then
	else
		resolver1 = require1("tacky.analysis.resolve")["resolve"]
	end
	return resolver1(unpack1(args24, 1, n1(args24)))
end)
distance1 = (function(a3, b3)
	if (a3 == b3) then
		return 0
	elseif (n1(a3) == 0) then
		return n1(b3)
	elseif (n1(b3) == 0) then
		return n1(a3)
	else
		local v01 = ({tag = "list", n = 0})
		local v11 = ({tag = "list", n = 0})
		local r_12321 = (n1(b3) + 1)
		local r_12301 = nil
		r_12301 = (function(r_12311)
			if (r_12311 <= r_12321) then
				pushCdr_21_1(v01, (r_12311 - 1))
				pushCdr_21_1(v11, 0)
				return r_12301((r_12311 + 1))
			else
				return nil
			end
		end)
		r_12301(1)
		local r_12361 = n1(a3)
		local r_12341 = nil
		r_12341 = (function(r_12351)
			if (r_12351 <= r_12361) then
				v11[1] = r_12351
				local r_12401 = n1(b3)
				local r_12381 = nil
				r_12381 = (function(r_12391)
					if (r_12391 <= r_12401) then
						local subCost1 = 1
						local delCost1 = 1
						local addCost1 = 1
						local aChar1 = sub1(a3, r_12351, r_12351)
						local bChar1 = sub1(b3, r_12391, r_12391)
						if (aChar1 == bChar1) then
							subCost1 = 0
						end
						if ((aChar1 == "-") or (aChar1 == "/")) then
							delCost1 = 0.5
						end
						if ((bChar1 == "-") or (bChar1 == "/")) then
							addCost1 = 0.5
						end
						if ((n1(a3) <= 5) or (n1(b3) <= 5)) then
							subCost1 = (subCost1 * 2)
							delCost1 = (delCost1 + 0.5)
						end
						v11[(r_12391 + 1)] = min2((v11[r_12391] + delCost1), (v01[((r_12391 + 1))] + addCost1), (v01[r_12391] + subCost1))
						return r_12381((r_12391 + 1))
					else
						return nil
					end
				end)
				r_12381(1)
				local r_12471 = n1(v01)
				local r_12451 = nil
				r_12451 = (function(r_12461)
					if (r_12461 <= r_12471) then
						v01[r_12461] = v11[r_12461]
						return r_12451((r_12461 + 1))
					else
						return nil
					end
				end)
				r_12451(1)
				return r_12341((r_12351 + 1))
			else
				return nil
			end
		end)
		r_12341(1)
		return v11[((n1(b3) + 1))]
	end
end)
compile1 = (function(compiler7, nodes28, scope12, name33)
	local queue2 = ({tag = "list", n = 0})
	local states3 = ({tag = "list", n = 0})
	local loader1 = compiler7["loader"]
	local logger15 = compiler7["log"]
	local timer4 = compiler7["timer"]
	if name33 then
		name33 = _2e2e_2("[resolve] ", name33)
	end
	local r_12491 = list1(gethook1())
	if ((type1(r_12491) == "list") and ((n1(r_12491) >= 3) and ((n1(r_12491) <= 3) and true))) then
		local hook1 = r_12491[1]
		local hookMask1 = r_12491[2]
		local hookCount1 = r_12491[3]
		local r_12581 = n1(nodes28)
		local r_12561 = nil
		r_12561 = (function(r_12571)
			if (r_12571 <= r_12581) then
				local node65 = nodes28[r_12571]
				local state48 = create4(scope12, compiler7)
				local co1 = create2(resolve_2f_resolve1)
				pushCdr_21_1(states3, state48)
				if hook1 then
					sethook1(co1, hook1, hookMask1, hookCount1)
				end
				pushCdr_21_1(queue2, ({["tag"]="init",["node"]=node65,["_co"]=co1,["_state"]=state48,["_node"]=node65,["_idx"]=r_12571}))
				return r_12561((r_12571 + 1))
			else
				return nil
			end
		end)
		r_12561(1)
		local skipped1 = 0
		local resume2 = (function(action1, ...)
			local args25 = _pack(...) args25.tag = "list"
			skipped1 = 0
			compiler7["active-scope"] = action1["_active-scope"]
			compiler7["active-node"] = action1["_active-node"]
			local r_12631 = list1(resume1(action1["_co"], unpack1(args25, 1, n1(args25))))
			if ((type1(r_12631) == "list") and ((n1(r_12631) >= 2) and ((n1(r_12631) <= 2) and true))) then
				local status2 = r_12631[1]
				local result5 = r_12631[2]
				if not status2 then
					error1(result5, 0)
				elseif (status1(action1["_co"]) == "dead") then
					if (result5["tg"] == "many") then
						local baseIdx1 = action1["_idx"]
						self1(logger15, "put-debug!", "  Got multiple nodes as a result. Adding to queue")
						local r_12731 = n1(queue2)
						local r_12711 = nil
						r_12711 = (function(r_12721)
							if (r_12721 <= r_12731) then
								local elem8 = queue2[r_12721]
								if (elem8["_idx"] > 1) then
									elem8["_idx"] = (elem8["_idx"] + (n1(result5) - 1))
								end
								return r_12711((r_12721 + 1))
							else
								return nil
							end
						end)
						r_12711(1)
						local r_12771 = n1(result5)
						local r_12751 = nil
						r_12751 = (function(r_12761)
							if (r_12761 <= r_12771) then
								local state49 = create4(scope12, compiler7)
								if (r_12761 == 1) then
									states3[baseIdx1] = state49
								else
									insertNth_21_1(states3, (baseIdx1 + (r_12761 - 1)), state49)
								end
								local co2 = create2(resolve_2f_resolve1)
								if hook1 then
									sethook1(co2, hook1, hookMask1, hookCount1)
								end
								pushCdr_21_1(queue2, ({["tag"]="init",["node"]=result5[r_12761],["_co"]=co2,["_state"]=state49,["_node"]=result5[r_12761],["_idx"]=(baseIdx1 + (r_12761 - 1))}))
								return r_12751((r_12761 + 1))
							else
								return nil
							end
						end)
						r_12751(1)
					else
						built_21_1(action1["_state"], result5)
					end
				else
					result5["_co"] = action1["_co"]
					result5["_state"] = action1["_state"]
					result5["_node"] = action1["_node"]
					result5["_idx"] = action1["_idx"]
					result5["_active-scope"] = compiler7["active-scope"]
					result5["_active-node"] = compiler7["active-node"]
					pushCdr_21_1(queue2, result5)
				end
			else
				error1(_2e2e_2("Pattern matching failure! Can not match the pattern `(?status ?result)` against `", pretty1(r_12631), "`."))
			end
			compiler7["active-scope"] = nil
			compiler7["active-node"] = nil
			return nil
		end)
		if timer4 then
			startTimer_21_1(timer4, name33, 2)
		end
		local r_12601 = nil
		r_12601 = (function()
			if ((n1(queue2) > 0) and (skipped1 <= n1(queue2))) then
				local head10 = removeNth_21_1(queue2, 1)
				self1(logger15, "put-debug!", (_2e2e_2(head10["tag"], " for ", head10["_state"]["stage"], " at ", formatNode1(head10["_node"]), " (", (function()
					if head10["_state"]["var"] then
						return head10["_state"]["var"]["name"]
					else
						return "?"
					end
				end)()
				, "?")))
				local r_12621 = head10["tag"]
				if (r_12621 == "init") then
					resume2(head10, head10["node"], scope12, head10["_state"])
				elseif (r_12621 == "define") then
					if scope12["variables"][head10["name"]] then
						resume2(head10, scope12["variables"][head10["name"]])
					else
						self1(logger15, "put-debug!", (_2e2e_2("  Awaiting definiion of ", head10["name"])))
						skipped1 = (skipped1 + 1)
						pushCdr_21_1(queue2, head10)
					end
				elseif (r_12621 == "build") then
					if (head10["state"]["stage"] ~= "parsed") then
						resume2(head10)
					else
						self1(logger15, "put-debug!", (_2e2e_2("  Awaiting building of node ", (function()
							if head10["state"]["var"] then
								return head10["state"]["var"]["name"]
							else
								return "?"
							end
						end)()
						)))
						skipped1 = (skipped1 + 1)
						pushCdr_21_1(queue2, head10)
					end
				elseif (r_12621 == "execute") then
					executeStates1(compiler7["compileState"], head10["states"], compiler7["global"], logger15)
					resume2(head10)
				elseif (r_12621 == "import") then
					if name33 then
						pauseTimer_21_1(timer4, name33)
					end
					local result6 = loader1(head10["module"])
					local module1 = car1(result6)
					if name33 then
						startTimer_21_1(timer4, name33)
					end
					if module1 then
					else
						doNodeError_21_1(logger15, result6[2], head10["_node"], nil, getSource1(head10["_node"]), "")
					end
					local export3 = head10["export"]
					local scope13 = head10["scope"]
					iterPairs1(module1["scope"]["exported"], (function(name34, var45)
						if head10["as"] then
							return importVerbose_21_1(scope13, _2e2e_2(head10["as"], "/", name34), var45, head10["node"], export3, logger15)
						elseif head10["symbols"] then
							if head10["symbols"][name34] then
								return importVerbose_21_1(scope13, name34, var45, head10["node"], export3, logger15)
							else
								return nil
							end
						else
							return importVerbose_21_1(scope13, name34, var45, head10["node"], export3, logger15)
						end
					end))
					if head10["symbols"] then
						iterPairs1(head10["symbols"], (function(name35, nameNode1)
							if module1["scope"]["exported"][name35] then
								return nil
							else
								return putNodeError_21_1(logger15, _2e2e_2("Cannot find ", name35), nameNode1, nil, getSource1(head10["_node"]), "Importing here", getSource1(nameNode1), "Required here")
							end
						end))
					end
					resume2(head10)
				else
					error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_12621), ", but none matched.\n", "  Tried: `\"init\"`\n  Tried: `\"define\"`\n  Tried: `\"build\"`\n  Tried: `\"execute\"`\n  Tried: `\"import\"`"))
				end
				return r_12601()
			else
				return nil
			end
		end)
		r_12601()
	else
		error1(_2e2e_2("Pattern matching failure! Can not match the pattern `(?hook ?hook-mask ?hook-count)` against `", pretty1(r_12491), "`."))
	end
	if (n1(queue2) > 0) then
		local r_12831 = n1(queue2)
		local r_12811 = nil
		r_12811 = (function(r_12821)
			if (r_12821 <= r_12831) then
				local entry9 = queue2[r_12821]
				local r_12851 = entry9["tag"]
				if (r_12851 == "define") then
					local info1 = nil
					local suggestions1 = ""
					local scope14 = entry9["scope"]
					if scope14 then
						local vars3 = ({tag = "list", n = 0})
						local varDis1 = ({tag = "list", n = 0})
						local varSet1 = ({})
						local distances1 = ({})
						local r_12861 = nil
						r_12861 = (function()
							if scope14 then
								iterPairs1(scope14["variables"], (function(name36, _5f_3)
									if varSet1[name36] then
										return nil
									else
										varSet1[name36] = "true"
										pushCdr_21_1(vars3, name36)
										local parlen1 = n1(entry9["name"])
										local lendiff1 = abs1((n1(name36) - parlen1))
										if ((parlen1 <= 5) or (lendiff1 <= (parlen1 * 0.3))) then
											local dis1 = (distance1(name36, entry9["name"]) / parlen1)
											if (parlen1 <= 5) then
												dis1 = (dis1 / 2)
											end
											pushCdr_21_1(varDis1, name36)
											distances1[name36] = dis1
											return nil
										else
											return nil
										end
									end
								end))
								scope14 = scope14["parent"]
								return r_12861()
							else
								return nil
							end
						end)
						r_12861()
						sort1(vars3)
						sort1(varDis1, (function(a4, b4)
							return (distances1[a4] < distances1[b4])
						end))
						local elems1
						local r_12911
						local r_12901 = filter1((function(x67)
							return (distances1[x67] <= 0.5)
						end), varDis1)
						r_12911 = (function(n3)
							return slice1(5, 1, nil)
						end)()(r_12901)
						elems1 = map1((function(r_12921)
							return colored1("1;32", r_12921)
						end), r_12911)
						local r_12881 = n1(elems1)
						if (r_12881 == 0) then
						elseif (r_12881 == 1) then
							suggestions1 = _2e2e_2("\nDid you mean '", car1(elems1), "'?")
						else
							suggestions1 = _2e2e_2("\nDid you mean any of these?", "\n  •", concat1(elems1, "\n  •"))
						end
						info1 = _2e2e_2("Variables in scope are ", concat1(vars3, ", "))
					end
					putNodeError_21_1(logger15, _2e2e_2("Cannot find variable '", entry9["name"], "'", suggestions1), (entry9["node"] or entry9["_node"]), info1, getSource1((entry9["node"] or entry9["_node"])), "")
				elseif (r_12851 == "build") then
					local var46 = entry9["state"]["var"]
					local node66 = entry9["state"]["node"]
					self1(logger15, "put-error!", (_2e2e_2("Could not build ", (function()
						if var46 then
							return var46["name"]
						elseif node66 then
							return formatNode1(node66)
						else
							return "unknown node"
						end
					end)()
					)))
				else
					error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_12851), ", but none matched.\n", "  Tried: `\"define\"`\n  Tried: `\"build\"`"))
				end
				return r_12811((r_12821 + 1))
			else
				return nil
			end
		end)
		r_12811(1)
		error1("Node resolution railed", 0)
	end
	if name33 then
		stopTimer_21_1(timer4, name33)
	end
	return unpack1(list1(map1((function(r_12951)
		return r_12951["node"]
	end), states3), states3))
end)
requiresInput1 = (function(str7)
	local r_11491 = list1(pcall1((function()
		return parse1(void2, lex1(void2, str7, "<stdin>", true), true)
	end)))
	if ((type1(r_11491) == "list") and ((n1(r_11491) >= 2) and ((n1(r_11491) <= 2) and (eq_3f_1(r_11491[1], true) and true)))) then
		return false
	elseif ((type1(r_11491) == "list") and ((n1(r_11491) >= 2) and ((n1(r_11491) <= 2) and (eq_3f_1(r_11491[1], false) and (type_23_1((r_11491[2])) == "table"))))) then
		if r_11491[2]["cont"] then
			return true
		else
			return false
		end
	elseif ((type1(r_11491) == "list") and ((n1(r_11491) >= 2) and ((n1(r_11491) <= 2) and (eq_3f_1(r_11491[1], false) and true)))) then
		local x68 = r_11491[2]
		print1(("x = " .. pretty1(x68)))
		return nil
	else
		return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_11491), ", but none matched.\n", "  Tried: `(true _)`\n  Tried: `(false (table? @ ?x))`\n  Tried: `(false ?x)`"))
	end
end)
doResolve1 = (function(compiler8, scope15, str8)
	local logger16 = compiler8["log"]
	local lexed1 = lex1(logger16, str8, "<stdin>")
	return car1(cdr1((list1(compile1(compiler8, parse1(logger16, lexed1), scope15)))))
end)
if getenv1 then
	local clrs1 = getenv1("URN_COLOURS")
	if clrs1 then
		replColourScheme1 = (read2(clrs1) or nil)
	else
		replColourScheme1 = nil
	end
else
	replColourScheme1 = nil
end
colourFor1 = (function(elem9)
	if assoc_3f_1(replColourScheme1, ({["tag"]="symbol",["contents"]=elem9})) then
		return constVal1(assoc1(replColourScheme1, ({["tag"]="symbol",["contents"]=elem9})))
	else
		if (elem9 == "text") then
			return 0
		elseif (elem9 == "arg") then
			return 36
		elseif (elem9 == "mono") then
			return 97
		elseif (elem9 == "bold") then
			return 1
		elseif (elem9 == "italic") then
			return 3
		elseif (elem9 == "link") then
			return 94
		else
			return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(elem9), ", but none matched.\n", "  Tried: `\"text\"`\n  Tried: `\"arg\"`\n  Tried: `\"mono\"`\n  Tried: `\"bold\"`\n  Tried: `\"italic\"`\n  Tried: `\"link\"`"))
		end
	end
end)
printDocs_21_1 = (function(str9)
	local docs2 = parseDocstring1(str9)
	local r_11701 = n1(docs2)
	local r_11681 = nil
	r_11681 = (function(r_11691)
		if (r_11691 <= r_11701) then
			local tok5 = docs2[r_11691]
			local tag11 = tok5["tag"]
			if (tag11 == "bolic") then
				write1(colored1(colourFor1("bold"), colored1(colourFor1("italic"), tok5["contents"])))
			else
				write1(colored1(colourFor1(tag11), tok5["contents"]))
			end
			return r_11681((r_11691 + 1))
		else
			return nil
		end
	end)
	r_11681(1)
	return print1()
end)
execCommand1 = (function(compiler9, scope16, args26)
	local logger17 = compiler9["log"]
	local command1 = car1(args26)
	if ((command1 == "help") or (command1 == "h")) then
		return print1("REPL commands:\n[:d]oc NAME        Get documentation about a symbol\n:scope             Print out all variables in the scope\n[:s]earch QUERY    Search the current scope for symbols and documentation containing a string.\n:module NAME       Display a loaded module's docs and definitions.")
	elseif ((command1 == "doc") or (command1 == "d")) then
		local name37 = args26[2]
		if name37 then
			local var47 = get1(scope16, name37)
			if (var47 == nil) then
				return self1(logger17, "put-error!", (_2e2e_2("Cannot find '", name37, "'")))
			elseif not var47["doc"] then
				return self1(logger17, "put-error!", (_2e2e_2("No documentation for '", name37, "'")))
			else
				local sig3 = extractSignature1(var47)
				local name38 = var47["fullName"]
				if sig3 then
					local buffer5 = list1(name38)
					local r_13031 = n1(sig3)
					local r_13011 = nil
					r_13011 = (function(r_13021)
						if (r_13021 <= r_13031) then
							pushCdr_21_1(buffer5, sig3[r_13021]["contents"])
							return r_13011((r_13021 + 1))
						else
							return nil
						end
					end)
					r_13011(1)
					name38 = _2e2e_2("(", concat1(buffer5, " "), ")")
				end
				print1(colored1(96, name38))
				return printDocs_21_1(var47["doc"])
			end
		else
			return self1(logger17, "put-error!", ":doc <variable>")
		end
	elseif (command1 == "module") then
		local name39 = args26[2]
		if name39 then
			local mod1 = compiler9["libNames"][name39]
			if (mod1 == nil) then
				return self1(logger17, "put-error!", (_2e2e_2("Cannot find '", name39, "'")))
			else
				print1(colored1(96, mod1["name"]))
				if mod1["docs"] then
					printDocs_21_1(mod1["docs"])
					print1()
				end
				print1(colored1(92, "Exported symbols"))
				local vars4 = ({tag = "list", n = 0})
				iterPairs1(mod1["scope"]["exported"], (function(name40)
					return pushCdr_21_1(vars4, name40)
				end))
				sort1(vars4)
				return print1(concat1(vars4, "  "))
			end
		else
			return self1(logger17, "put-error!", ":module <variable>")
		end
	elseif (command1 == "scope") then
		local vars5 = ({tag = "list", n = 0})
		local varsSet1 = ({})
		local current2 = scope16
		local r_13051 = nil
		r_13051 = (function()
			if current2 then
				iterPairs1(current2["variables"], (function(name41, var48)
					if varsSet1[name41] then
						return nil
					else
						pushCdr_21_1(vars5, name41)
						varsSet1[name41] = true
						return nil
					end
				end))
				current2 = current2["parent"]
				return r_13051()
			else
				return nil
			end
		end)
		r_13051()
		sort1(vars5)
		return print1(concat1(vars5, "  "))
	elseif ((command1 == "search") or (command1 == "s")) then
		if (n1(args26) > 1) then
			local keywords2 = map1(lower1, cdr1(args26))
			local nameResults1 = ({tag = "list", n = 0})
			local docsResults1 = ({tag = "list", n = 0})
			local vars6 = ({tag = "list", n = 0})
			local varsSet2 = ({})
			local current3 = scope16
			local r_13071 = nil
			r_13071 = (function()
				if current3 then
					iterPairs1(current3["variables"], (function(name42, var49)
						if varsSet2[name42] then
							return nil
						else
							pushCdr_21_1(vars6, name42)
							varsSet2[name42] = true
							return nil
						end
					end))
					current3 = current3["parent"]
					return r_13071()
				else
					return nil
				end
			end)
			r_13071()
			local r_13121 = n1(vars6)
			local r_13101 = nil
			r_13101 = (function(r_13111)
				if (r_13111 <= r_13121) then
					local var50 = vars6[r_13111]
					local r_13181 = n1(keywords2)
					local r_13161 = nil
					r_13161 = (function(r_13171)
						if (r_13171 <= r_13181) then
							if find1(var50, (keywords2[r_13171])) then
								pushCdr_21_1(nameResults1, var50)
							end
							return r_13161((r_13171 + 1))
						else
							return nil
						end
					end)
					r_13161(1)
					local docVar1 = get1(scope16, var50)
					if docVar1 then
						local tempDocs1 = docVar1["doc"]
						if tempDocs1 then
							local docs3 = lower1(tempDocs1)
							if docs3 then
								local keywordsFound1 = 0
								if keywordsFound1 then
									local r_13241 = n1(keywords2)
									local r_13221 = nil
									r_13221 = (function(r_13231)
										if (r_13231 <= r_13241) then
											if find1(docs3, (keywords2[r_13231])) then
												keywordsFound1 = (keywordsFound1 + 1)
											end
											return r_13221((r_13231 + 1))
										else
											return nil
										end
									end)
									r_13221(1)
									if eq_3f_1(keywordsFound1, n1(keywords2)) then
										pushCdr_21_1(docsResults1, var50)
									end
								else
								end
							else
							end
						else
						end
					else
					end
					return r_13101((r_13111 + 1))
				else
					return nil
				end
			end)
			r_13101(1)
			if (empty_3f_1(nameResults1) and empty_3f_1(docsResults1)) then
				return self1(logger17, "put-error!", "No results")
			else
				if not empty_3f_1(nameResults1) then
					print1(colored1(92, "Search by function name:"))
					if (n1(nameResults1) > 20) then
						print1(_2e2e_2(concat1(slice1(nameResults1, 1, 20), "  "), "  ..."))
					else
						print1(concat1(nameResults1, "  "))
					end
				end
				if not empty_3f_1(docsResults1) then
					print1(colored1(92, "Search by function docs:"))
					if (n1(docsResults1) > 20) then
						return print1(_2e2e_2(concat1(slice1(docsResults1, 1, 20), "  "), "  ..."))
					else
						return print1(concat1(docsResults1, "  "))
					end
				else
					return nil
				end
			end
		else
			return self1(logger17, "put-error!", ":search <keywords>")
		end
	else
		return self1(logger17, "put-error!", (_2e2e_2("Unknown command '", command1, "'")))
	end
end)
execString1 = (function(compiler10, scope17, string1)
	local state50 = doResolve1(compiler10, scope17, string1)
	if (n1(state50) > 0) then
		local current4 = 0
		local exec1 = create2((function()
			local r_13491 = n1(state50)
			local r_13471 = nil
			r_13471 = (function(r_13481)
				if (r_13481 <= r_13491) then
					local elem10 = state50[r_13481]
					current4 = elem10
					get_21_1(current4)
					return r_13471((r_13481 + 1))
				else
					return nil
				end
			end)
			return r_13471(1)
		end))
		local compileState1 = compiler10["compileState"]
		local rootScope2 = compiler10["rootScope"]
		local global3 = compiler10["global"]
		local logger18 = compiler10["log"]
		local run1 = true
		local r_11721 = nil
		r_11721 = (function()
			if run1 then
				local res11 = list1(resume1(exec1))
				if not car1(res11) then
					self1(logger18, "put-error!", (car1(cdr1(res11))))
					run1 = false
				elseif (status1(exec1) == "dead") then
					local lvl1 = get_21_1(last1(state50))
					print1(_2e2e_2("out = ", colored1(96, pretty1(lvl1))))
					global3[escapeVar1(add_21_1(scope17, "out", "defined", lvl1), compileState1)] = lvl1
					run1 = false
				else
					local states4 = car1(cdr1(res11))["states"]
					local latest1 = car1(states4)
					local co3 = create2(executeStates1)
					local task2 = nil
					local r_13271 = nil
					r_13271 = (function()
						if (run1 and (status1(co3) ~= "dead")) then
							compiler10["active-node"] = latest1["node"]
							compiler10["active-scope"] = latest1["scope"]
							local res12
							if task2 then
								res12 = list1(resume1(co3))
							else
								res12 = list1(resume1(co3, compileState1, states4, global3, logger18))
							end
							compiler10["active-node"] = nil
							compiler10["active-scope"] = nil
							if ((type1(res12) == "list") and ((n1(res12) >= 2) and ((n1(res12) <= 2) and (eq_3f_1(res12[1], false) and true)))) then
								error1((res12[2]), 0)
							elseif ((type1(res12) == "list") and ((n1(res12) >= 1) and ((n1(res12) <= 1) and eq_3f_1(res12[1], true)))) then
							elseif ((type1(res12) == "list") and ((n1(res12) >= 2) and ((n1(res12) <= 2) and (eq_3f_1(res12[1], true) and true)))) then
								local arg26 = res12[2]
								if (status1(co3) ~= "dead") then
									task2 = arg26
									local r_13441 = task2["tag"]
									if (r_13441 == "execute") then
										executeStates1(compileState1, task2["states"], global3, logger18)
									else
										_2e2e_2("Cannot handle ", r_13441)
									end
								end
							else
								error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(res12), ", but none matched.\n", "  Tried: `(false ?msg)`\n  Tried: `(true)`\n  Tried: `(true ?arg)`"))
							end
							return r_13271()
						else
							return nil
						end
					end)
					r_13271()
				end
				return r_11721()
			else
				return nil
			end
		end)
		return r_11721()
	else
		return nil
	end
end)
repl1 = (function(compiler11)
	local scope18 = compiler11["rootScope"]
	local logger19 = compiler11["log"]
	local buffer6 = ""
	local running4 = true
	local r_11731 = nil
	r_11731 = (function()
		if running4 then
			write1(colored1(92, (function()
				if empty_3f_1(buffer6) then
					return "> "
				else
					return ". "
				end
			end)()
			))
			flush1()
			local line6 = read1("*l")
			if (not line6 and empty_3f_1(buffer6)) then
				running4 = false
			else
				local data6
				if line6 then
					data6 = _2e2e_2(buffer6, line6, "\n")
				else
					data6 = buffer6
				end
				if (sub1(data6, 1, 1) == ":") then
					buffer6 = ""
					execCommand1(compiler11, scope18, map1(trim1, split1(sub1(data6, 2), " ")))
				elseif (line6 and ((n1(line6) > 0) and requiresInput1(data6))) then
					buffer6 = data6
				else
					buffer6 = ""
					scope18 = child1(scope18)
					scope18["isRoot"] = true
					local res13 = list1(pcall1(execString1, compiler11, scope18, data6))
					compiler11["active-node"] = nil
					compiler11["active-scope"] = nil
					if car1(res13) then
					else
						self1(logger19, "put-error!", (car1(cdr1(res13))))
					end
				end
			end
			return r_11731()
		else
			return nil
		end
	end)
	return r_11731()
end)
exec2 = (function(compiler12)
	local data7 = read1("*a")
	local scope19 = compiler12["rootScope"]
	local logger20 = compiler12["log"]
	local res14 = list1(pcall1(execString1, compiler12, scope19, data7))
	if car1(res14) then
	else
		self1(logger20, "put-error!", (car1(cdr1(res14))))
	end
	return exit1(0)
end)
replTask1 = ({["name"]="repl",["setup"]=(function(spec11)
	return addArgument_21_1(spec11, ({tag = "list", n = 1, "--repl"}), "help", "Start an interactive session.")
end),["pred"]=(function(args27)
	return args27["repl"]
end),["run"]=repl1})
execTask1 = ({["name"]="exec",["setup"]=(function(spec12)
	return addArgument_21_1(spec12, ({tag = "list", n = 1, "--exec"}), "help", "Execute a program without compiling it.")
end),["pred"]=(function(args28)
	return args28["exec"]
end),["run"]=exec2})
profileCalls1 = (function(fn3, mappings3)
	local stats1 = ({})
	local callStack1 = ({tag = "list", n = 0})
	sethook1((function(action2)
		local info2 = getinfo1(2, "Sn")
		local start29 = clock1()
		if (action2 == "call") then
			local previous5 = callStack1[(n1(callStack1))]
			if previous5 then
				previous5["sum"] = (previous5["sum"] + (start29 - previous5["innerStart"]))
			end
		end
		if (action2 ~= "call") then
			if empty_3f_1(callStack1) then
			else
				local current5 = popLast_21_1(callStack1)
				local hash1 = (current5["source"] .. current5["linedefined"])
				local entry10 = stats1[hash1]
				if entry10 then
				else
					entry10 = ({["source"]=current5["source"],["short-src"]=current5["short_src"],["line"]=current5["linedefined"],["name"]=current5["name"],["calls"]=0,["totalTime"]=0,["innerTime"]=0})
					stats1[hash1] = entry10
				end
				entry10["calls"] = (1 + entry10["calls"])
				entry10["totalTime"] = (entry10["totalTime"] + (start29 - current5["totalStart"]))
				entry10["innerTime"] = (entry10["innerTime"] + (current5["sum"] + (start29 - current5["innerStart"])))
			end
		end
		if (action2 ~= "return") then
			info2["totalStart"] = start29
			info2["innerStart"] = start29
			info2["sum"] = 0
			pushCdr_21_1(callStack1, info2)
		end
		if (action2 == "return") then
			local next2 = last1(callStack1)
			if next2 then
				next2["innerStart"] = start29
				return nil
			else
				return nil
			end
		else
			return nil
		end
	end), "cr")
	fn3()
	sethook1()
	local out27 = values1(stats1)
	sort1(out27, (function(a5, b5)
		return (a5["innerTime"] > b5["innerTime"])
	end))
	print1("|               Method | Location                                                     |    Total |    Inner |   Calls |")
	print1("| -------------------- | ------------------------------------------------------------ | -------- | -------- | ------- |")
	local r_13671 = n1(out27)
	local r_13651 = nil
	r_13651 = (function(r_13661)
		if (r_13661 <= r_13671) then
			local entry11 = out27[r_13661]
			print1(format1("| %20s | %-60s | %8.5f | %8.5f | %7d | ", (function()
				if entry11["name"] then
					return unmangleIdent1(entry11["name"])
				else
					return "<unknown>"
				end
			end)()
			, remapMessage1(mappings3, _2e2e_2(entry11["short-src"], ":", entry11["line"])), entry11["totalTime"], entry11["innerTime"], entry11["calls"]))
			return r_13651((r_13661 + 1))
		else
			return nil
		end
	end)
	r_13651(1)
	return stats1
end)
buildStack1 = (function(parent2, stack4, i11, history1, fold2)
	parent2["n"] = (parent2["n"] + 1)
	if (i11 >= 1) then
		local elem11 = stack4[i11]
		local hash2 = _2e2e_2(elem11["source"], "|", elem11["linedefined"])
		local previous6 = (fold2 and history1[hash2])
		local child3 = parent2[hash2]
		if previous6 then
			parent2["n"] = (parent2["n"] - 1)
			child3 = previous6
		end
		if child3 then
		else
			child3 = elem11
			elem11["n"] = 0
			parent2[hash2] = child3
		end
		if previous6 then
		else
			history1[hash2] = child3
		end
		buildStack1(child3, stack4, (i11 - 1), history1, fold2)
		if previous6 then
			return nil
		else
			history1[hash2] = nil
			return nil
		end
	else
		return nil
	end
end)
buildRevStack1 = (function(parent3, stack5, i12, history2, fold3)
	parent3["n"] = (parent3["n"] + 1)
	if (i12 <= n1(stack5)) then
		local elem12 = stack5[i12]
		local hash3 = _2e2e_2(elem12["source"], "|", elem12["linedefined"])
		local previous7 = (fold3 and history2[hash3])
		local child4 = parent3[hash3]
		if previous7 then
			parent3["n"] = (parent3["n"] - 1)
			child4 = previous7
		end
		if child4 then
		else
			child4 = elem12
			elem12["n"] = 0
			parent3[hash3] = child4
		end
		if previous7 then
		else
			history2[hash3] = child4
		end
		buildRevStack1(child4, stack5, (i12 + 1), history2, fold3)
		if previous7 then
			return nil
		else
			history2[hash3] = nil
			return nil
		end
	else
		return nil
	end
end)
finishStack1 = (function(element1)
	local children1 = ({tag = "list", n = 0})
	iterPairs1(element1, (function(k4, child5)
		if (type_23_1(child5) == "table") then
			return pushCdr_21_1(children1, child5)
		else
			return nil
		end
	end))
	sort1(children1, (function(a6, b6)
		return (a6["n"] > b6["n"])
	end))
	element1["children"] = children1
	local r_13731 = n1(children1)
	local r_13711 = nil
	r_13711 = (function(r_13721)
		if (r_13721 <= r_13731) then
			finishStack1((children1[r_13721]))
			return r_13711((r_13721 + 1))
		else
			return nil
		end
	end)
	return r_13711(1)
end)
showStack_21_1 = (function(out28, mappings4, total1, stack6, remaining2)
	line_21_1(out28, format1("└ %s %s %d (%2.5f%%)", (function()
		if stack6["name"] then
			return unmangleIdent1(stack6["name"])
		else
			return "<unknown>"
		end
	end)()
	, remapMessage1(mappings4, _2e2e_2(stack6["short_src"], ":", stack6["linedefined"])), stack6["n"], ((stack6["n"] / total1) * 100)))
	local temp13
	if remaining2 then
		temp13 = (remaining2 >= 1)
	else
		temp13 = true
	end
	if temp13 then
		out28["indent"] = (out28["indent"] + 1)
		local r_13761 = stack6["children"]
		local r_13791 = n1(r_13761)
		local r_13771 = nil
		r_13771 = (function(r_13781)
			if (r_13781 <= r_13791) then
				showStack_21_1(out28, mappings4, total1, r_13761[r_13781], (remaining2 and (remaining2 - 1)))
				return r_13771((r_13781 + 1))
			else
				return nil
			end
		end)
		r_13771(1)
		out28["indent"] = (out28["indent"] - 1)
		return nil
	else
		return nil
	end
end)
showFlame_21_1 = (function(mappings5, stack7, before1, remaining3)
	local renamed1 = _2e2e_2((function()
		if stack7["name"] then
			return unmangleIdent1(stack7["name"])
		else
			return "?"
		end
	end)()
	, "`", remapMessage1(mappings5, _2e2e_2(stack7["short_src"], ":", stack7["linedefined"])))
	print1(format1("%s%s %d", before1, renamed1, stack7["n"]))
	local temp14
	if remaining3 then
		temp14 = (remaining3 >= 1)
	else
		temp14 = true
	end
	if temp14 then
		local whole1 = _2e2e_2(before1, renamed1, ";")
		local r_13571 = stack7["children"]
		local r_13601 = n1(r_13571)
		local r_13581 = nil
		r_13581 = (function(r_13591)
			if (r_13591 <= r_13601) then
				showFlame_21_1(mappings5, r_13571[r_13591], whole1, (remaining3 and (remaining3 - 1)))
				return r_13581((r_13591 + 1))
			else
				return nil
			end
		end)
		return r_13581(1)
	else
		return nil
	end
end)
profileStack1 = (function(fn4, mappings6, args29)
	local stacks1 = ({tag = "list", n = 0})
	local top1 = getinfo1(2, "S")
	sethook1((function(action3)
		local pos13 = 3
		local stack8 = ({tag = "list", n = 0})
		local info3 = getinfo1(2, "Sn")
		local r_13821 = nil
		r_13821 = (function()
			if info3 then
				if ((info3["source"] == top1["source"]) and (info3["linedefined"] == top1["linedefined"])) then
					info3 = nil
				else
					pushCdr_21_1(stack8, info3)
					pos13 = (pos13 + 1)
					info3 = getinfo1(pos13, "Sn")
				end
				return r_13821()
			else
				return nil
			end
		end)
		r_13821()
		return pushCdr_21_1(stacks1, stack8)
	end), "", 100000.0)
	fn4()
	sethook1()
	local folded1 = ({["n"]=0,["name"]="<root>"})
	local r_13881 = n1(stacks1)
	local r_13861 = nil
	r_13861 = (function(r_13871)
		if (r_13871 <= r_13881) then
			local stack9 = stacks1[r_13871]
			if (args29["stack-kind"] == "reverse") then
				buildRevStack1(folded1, stack9, 1, ({}), args29["stack-fold"])
			else
				buildStack1(folded1, stack9, n1(stack9), ({}), args29["stack-fold"])
			end
			return r_13861((r_13871 + 1))
		else
			return nil
		end
	end)
	r_13861(1)
	finishStack1(folded1)
	if (args29["stack-show"] == "flame") then
		return showFlame_21_1(mappings6, folded1, "", (args29["stack-limit"] or 30))
	else
		local writer14 = create3()
		showStack_21_1(writer14, mappings6, n1(stacks1), folded1, (args29["stack-limit"] or 10))
		return print1(concat1(writer14["out"]))
	end
end)
runLua1 = (function(compiler13, args30)
	if empty_3f_1(args30["input"]) then
		self1(compiler13["log"], "put-error!", "No inputs to run.")
		exit_21_1(1)
	end
	local out29 = file3(compiler13, false)
	local lines9 = generateMappings1(out29["lines"])
	local logger21 = compiler13["log"]
	local name43 = _2e2e_2((args30["output"] or "out"), ".lua")
	local r_13921 = list1(load1(concat1(out29["out"]), _2e2e_2("=", name43)))
	if ((type1(r_13921) == "list") and ((n1(r_13921) >= 2) and ((n1(r_13921) <= 2) and (eq_3f_1(r_13921[1], nil) and true)))) then
		local msg32 = r_13921[2]
		self1(logger21, "put-error!", "Cannot load compiled source.")
		print1(msg32)
		print1(concat1(out29["out"]))
		return exit_21_1(1)
	elseif ((type1(r_13921) == "list") and ((n1(r_13921) >= 1) and ((n1(r_13921) <= 1) and true))) then
		local fun3 = r_13921[1]
		_5f_G1["arg"] = args30["script-args"]
		_5f_G1["arg"][0] = car1(args30["input"])
		iterPairs1(loaded1, (function(k5, v6)
			if (sub1(k5, 1, 6) == "tacky.") then
				loaded1[k5] = nil
				return nil
			else
				return nil
			end
		end))
		local exec3 = (function()
			local r_14031 = list1(xpcall1(fun3, traceback1))
			if ((type1(r_14031) == "list") and ((n1(r_14031) >= 1) and (eq_3f_1(r_14031[1], true) and true))) then
				local res15 = slice1(r_14031, 2)
				return nil
			elseif ((type1(r_14031) == "list") and ((n1(r_14031) >= 2) and ((n1(r_14031) <= 2) and (eq_3f_1(r_14031[1], false) and true)))) then
				local msg33 = r_14031[2]
				self1(logger21, "put-error!", "Execution failed.")
				print1(remapTraceback1(({[name43]=lines9}), msg33))
				return exit_21_1(1)
			else
				return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_14031), ", but none matched.\n", "  Tried: `(true . ?res)`\n  Tried: `(false ?msg)`"))
			end
		end)
		local r_14021 = args30["profile"]
		if (r_14021 == "none") then
			return exec3()
		elseif eq_3f_1(r_14021, nil) then
			return exec3()
		elseif (r_14021 == "call") then
			return profileCalls1(exec3, ({[name43]=lines9}))
		elseif (r_14021 == "stack") then
			return profileStack1(exec3, ({[name43]=lines9}), args30)
		else
			self1(logger21, "put-error!", (_2e2e_2("Unknown profiler '", r_14021, "'")))
			return exit_21_1(1)
		end
	else
		return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_13921), ", but none matched.\n", "  Tried: `(nil ?msg)`\n  Tried: `(?fun)`"))
	end
end)
task3 = ({["name"]="run",["setup"]=(function(spec13)
	addArgument_21_1(spec13, ({tag = "list", n = 2, "--run", "-r"}), "help", "Run the compiled code.")
	addArgument_21_1(spec13, ({tag = "list", n = 2, "--profile", "-p"}), "help", "Run the compiled code with the profiler.", "var", "none|call|stack", "default", nil, "value", "stack", "narg", "?")
	addArgument_21_1(spec13, ({tag = "list", n = 1, "--stack-kind"}), "help", "The kind of stack to emit when using the stack profiler. A reverse stack shows callers of that method instead.", "var", "forward|reverse", "default", "forward", "narg", 1)
	addArgument_21_1(spec13, ({tag = "list", n = 1, "--stack-show"}), "help", "The method to use to display the profiling results.", "var", "flame|term", "default", "term", "narg", 1)
	addArgument_21_1(spec13, ({tag = "list", n = 1, "--stack-limit"}), "help", "The maximum number of call frames to emit.", "var", "LIMIT", "default", nil, "action", setNumAction1, "narg", 1)
	addArgument_21_1(spec13, ({tag = "list", n = 1, "--stack-fold"}), "help", "Whether to fold recursive functions into themselves. This hopefully makes deep graphs easier to understand, but may result in less accurate graphs.", "value", true, "default", false)
	return addArgument_21_1(spec13, ({tag = "list", n = 1, "--"}), "name", "script-args", "help", "Arguments to pass to the compiled script.", "var", "ARG", "all", true, "default", ({tag = "list", n = 0}), "action", addAction1, "narg", "*")
end),["pred"]=(function(args31)
	return (args31["run"] or args31["profile"])
end),["run"]=runLua1})
dotQuote1 = (function(prefix2, name44)
	if find1(name44, "^[%w_][%d%w_]*$") then
		if string_3f_1(prefix2) then
			return _2e2e_2(prefix2, ".", name44)
		else
			return name44
		end
	else
		if string_3f_1(prefix2) then
			return _2e2e_2(prefix2, "[", quoted1(name44), "]")
		else
			return _2e2e_2("_ENV[", quoted1(name44), "]")
		end
	end
end)
genNative1 = (function(compiler14, args32)
	if (n1(args32["input"]) ~= 1) then
		self1(compiler14["log"], "put-error!", "Expected just one input")
		exit_21_1(1)
	end
	local prefix3 = args32["gen-native"]
	local lib3 = compiler14["libCache"][gsub1(last1(args32["input"]), "%.lisp$", "")]
	local escaped3
	if string_3f_1(prefix3) then
		escaped3 = escape1(last1(split1(lib3["name"], "/")))
	else
		escaped3 = nil
	end
	local maxName1 = 0
	local maxQuot1 = 0
	local maxPref1 = 0
	local natives1 = ({tag = "list", n = 0})
	local r_14161 = lib3["out"]
	local r_14191 = n1(r_14161)
	local r_14171 = nil
	r_14171 = (function(r_14181)
		if (r_14181 <= r_14191) then
			local node67 = r_14161[r_14181]
			if ((type1(node67) == "list") and ((type1((car1(node67))) == "symbol") and (car1(node67)["contents"] == "define-native"))) then
				local name45 = node67[2]["contents"]
				pushCdr_21_1(natives1, name45)
				maxName1 = max2(maxName1, n1(quoted1(name45)))
				maxQuot1 = max2(maxQuot1, n1(quoted1(dotQuote1(prefix3, name45))))
				maxPref1 = max2(maxPref1, n1(dotQuote1(escaped3, name45)))
			end
			return r_14171((r_14181 + 1))
		else
			return nil
		end
	end)
	r_14171(1)
	sort1(natives1)
	local handle4 = open1(_2e2e_2(lib3["path"], ".meta.lua"), "w")
	local format3 = _2e2e_2("\9[%-", tostring1((maxName1 + 3)), "s { tag = \"var\", contents = %-", tostring1((maxQuot1 + 1)), "s value = %-", tostring1((maxPref1 + 1)), "s },\n")
	if handle4 then
	else
		self1(compiler14["log"], "put-error!", (_2e2e_2("Cannot write to ", lib3["path"], ".meta.lua")))
		exit_21_1(1)
	end
	if string_3f_1(prefix3) then
		self1(handle4, "write", format1("local %s = %s or {}\n", escaped3, prefix3))
	end
	self1(handle4, "write", "return {\n")
	local r_14271 = n1(natives1)
	local r_14251 = nil
	r_14251 = (function(r_14261)
		if (r_14261 <= r_14271) then
			local native3 = natives1[r_14261]
			self1(handle4, "write", format1(format3, _2e2e_2(quoted1(native3), "] ="), _2e2e_2(quoted1(dotQuote1(prefix3, native3)), ","), _2e2e_2(dotQuote1(escaped3, native3), ",")))
			return r_14251((r_14261 + 1))
		else
			return nil
		end
	end)
	r_14251(1)
	self1(handle4, "write", "}\n")
	return self1(handle4, "close")
end)
task4 = ({["name"]="gen-native",["setup"]=(function(spec14)
	return addArgument_21_1(spec14, ({tag = "list", n = 1, "--gen-native"}), "help", "Generate native bindings for a file", "var", "PREFIX", "narg", "?")
end),["pred"]=(function(args33)
	return args33["gen-native"]
end),["run"]=genNative1})
simplifyPath1 = (function(path3, paths1)
	local current6 = path3
	local r_14331 = n1(paths1)
	local r_14311 = nil
	r_14311 = (function(r_14321)
		if (r_14321 <= r_14331) then
			local search1 = paths1[r_14321]
			local sub6 = match1(path3, _2e2e_2("^", gsub1(search1, "%?", "(.*)"), "$"))
			if (sub6 and (n1(sub6) < n1(current6))) then
				current6 = sub6
			end
			return r_14311((r_14321 + 1))
		else
			return nil
		end
	end)
	r_14311(1)
	return current6
end)
readMeta1 = (function(state51, name46, entry12)
	if (((entry12["tag"] == "expr") or (entry12["tag"] == "stmt")) and string_3f_1(entry12["contents"])) then
		local buffer7 = ({tag = "list", n = 0})
		local str10 = entry12["contents"]
		local idx10 = 0
		local max6 = 0
		local len13 = n1(str10)
		local r_14381 = nil
		r_14381 = (function()
			if (idx10 <= len13) then
				local r_14391 = list1(find1(str10, "%${(%d+)}", idx10))
				if ((type1(r_14391) == "list") and ((n1(r_14391) >= 2) and true)) then
					local start30 = r_14391[1]
					local finish13 = r_14391[2]
					if (start30 > idx10) then
						pushCdr_21_1(buffer7, sub1(str10, idx10, (start30 - 1)))
					end
					local val22 = tonumber1(sub1(str10, (start30 + 2), (finish13 - 1)))
					pushCdr_21_1(buffer7, val22)
					if (val22 > max6) then
						max6 = val22
					end
					idx10 = (finish13 + 1)
				else
					pushCdr_21_1(buffer7, sub1(str10, idx10, len13))
					idx10 = (len13 + 1)
				end
				return r_14381()
			else
				return nil
			end
		end)
		r_14381()
		if entry12["count"] then
		else
			entry12["count"] = max6
		end
		entry12["contents"] = buffer7
	end
	local fold4 = entry12["fold"]
	if fold4 then
		if (entry12["tag"] ~= "expr") then
			error1(_2e2e_2("Cannot have fold for non-expression ", name46), 0)
		end
		if ((fold4 ~= "l") and (fold4 ~= "r")) then
			error1(_2e2e_2("Unknown fold ", fold4, " for ", name46), 0)
		end
		if (entry12["count"] ~= 2) then
			error1(_2e2e_2("Cannot have fold for length ", entry12["count"], " for ", name46), 0)
		end
	end
	entry12["name"] = name46
	if (entry12["value"] == nil) then
		local value12 = state51["libEnv"][name46]
		if (value12 == nil) then
			local r_14461 = list1(pcall1(native2, entry12, state51["global"]))
			if ((type1(r_14461) == "list") and ((n1(r_14461) >= 1) and (eq_3f_1(r_14461[1], true) and true))) then
				value12 = car1((slice1(r_14461, 2)))
			elseif ((type1(r_14461) == "list") and ((n1(r_14461) >= 2) and ((n1(r_14461) <= 2) and (eq_3f_1(r_14461[1], false) and true)))) then
			else
				error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_14461), ", but none matched.\n", "  Tried: `(true . ?res)`\n  Tried: `(false _)`"))
			end
			state51["libEnv"][name46] = value12
		end
		entry12["value"] = value12
	elseif (state51["libEnv"][name46] ~= nil) then
		error1(_2e2e_2("Duplicate value for ", name46, ": in native and meta file"), 0)
	else
		state51["libEnv"][name46] = entry12["value"]
	end
	state51["libMeta"][name46] = entry12
	return entry12
end)
readLibrary1 = (function(state52, name47, path4, lispHandle1)
	self1(state52["log"], "put-verbose!", (_2e2e_2("Loading ", path4, " into ", name47)))
	local prefix4 = _2e2e_2(name47, "-", n1(state52["libs"]), "/")
	local lib4 = ({["name"]=name47,["prefix"]=prefix4,["path"]=path4})
	local contents2 = self1(lispHandle1, "read", "*a")
	self1(lispHandle1, "close")
	local handle5 = open1(_2e2e_2(path4, ".lua"), "r")
	if handle5 then
		local contents3 = self1(handle5, "read", "*a")
		self1(handle5, "close")
		lib4["native"] = contents3
		local r_14571 = list1(load1(contents3, _2e2e_2("@", name47)))
		if ((type1(r_14571) == "list") and ((n1(r_14571) >= 2) and ((n1(r_14571) <= 2) and (eq_3f_1(r_14571[1], nil) and true)))) then
			error1((r_14571[2]), 0)
		elseif ((type1(r_14571) == "list") and ((n1(r_14571) >= 1) and ((n1(r_14571) <= 1) and true))) then
			local fun4 = r_14571[1]
			local res16 = fun4()
			if (type_23_1(res16) == "table") then
				iterPairs1(res16, (function(k6, v7)
					state52["libEnv"][_2e2e_2(prefix4, k6)] = v7
					return nil
				end))
			else
				error1(_2e2e_2(path4, ".lua returned a non-table value"), 0)
			end
		else
			error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_14571), ", but none matched.\n", "  Tried: `(nil ?msg)`\n  Tried: `(?fun)`"))
		end
	end
	local handle6 = open1(_2e2e_2(path4, ".meta.lua"), "r")
	if handle6 then
		local contents4 = self1(handle6, "read", "*a")
		self1(handle6, "close")
		local r_14671 = list1(load1(contents4, _2e2e_2("@", name47)))
		if ((type1(r_14671) == "list") and ((n1(r_14671) >= 2) and ((n1(r_14671) <= 2) and (eq_3f_1(r_14671[1], nil) and true)))) then
			error1((r_14671[2]), 0)
		elseif ((type1(r_14671) == "list") and ((n1(r_14671) >= 1) and ((n1(r_14671) <= 1) and true))) then
			local fun5 = r_14671[1]
			local res17 = fun5()
			if (type_23_1(res17) == "table") then
				iterPairs1(res17, (function(k7, v8)
					return readMeta1(state52, _2e2e_2(prefix4, k7), v8)
				end))
			else
				error1(_2e2e_2(path4, ".meta.lua returned a non-table value"), 0)
			end
		else
			error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_14671), ", but none matched.\n", "  Tried: `(nil ?msg)`\n  Tried: `(?fun)`"))
		end
	end
	startTimer_21_1(state52["timer"], _2e2e_2("[parse] ", path4), 2)
	local lexed2 = lex1(state52["log"], contents2, _2e2e_2(path4, ".lisp"))
	local parsed1 = parse1(state52["log"], lexed2)
	local scope20 = child1(state52["rootScope"])
	scope20["isRoot"] = true
	scope20["prefix"] = prefix4
	lib4["scope"] = scope20
	stopTimer_21_1(state52["timer"], _2e2e_2("[parse] ", path4))
	local compiled1 = compile1(state52, parsed1, scope20, path4)
	pushCdr_21_1(state52["libs"], lib4)
	if string_3f_1(car1(compiled1)) then
		lib4["docs"] = constVal1(car1(compiled1))
		removeNth_21_1(compiled1, 1)
	end
	lib4["out"] = compiled1
	local r_14811 = n1(compiled1)
	local r_14791 = nil
	r_14791 = (function(r_14801)
		if (r_14801 <= r_14811) then
			local node68 = compiled1[r_14801]
			pushCdr_21_1(state52["out"], node68)
			return r_14791((r_14801 + 1))
		else
			return nil
		end
	end)
	r_14791(1)
	self1(state52["log"], "put-verbose!", (_2e2e_2("Loaded ", path4, " into ", name47)))
	return lib4
end)
pathLocator1 = (function(state53, name48)
	local searched1
	local paths2
	local searcher1
	searched1 = ({tag = "list", n = 0})
	paths2 = state53["paths"]
	searcher1 = (function(i13)
		if (i13 > n1(paths2)) then
			return list1(nil, _2e2e_2("Cannot find ", quoted1(name48), ".\nLooked in ", concat1(searched1, ", ")))
		else
			local path5 = gsub1(paths2[i13], "%?", name48)
			local cached1 = state53["libCache"][path5]
			pushCdr_21_1(searched1, path5)
			if (cached1 == nil) then
				local handle7 = open1(_2e2e_2(path5, ".lisp"), "r")
				if handle7 then
					state53["libCache"][path5] = true
					state53["libNames"][name48] = true
					local lib5 = readLibrary1(state53, simplifyPath1(path5, paths2), path5, handle7)
					state53["libCache"][path5] = lib5
					state53["libNames"][name48] = lib5
					return list1(lib5)
				else
					return searcher1((i13 + 1))
				end
			elseif (cached1 == true) then
				return list1(nil, _2e2e_2("Already loading ", name48))
			else
				return list1(cached1)
			end
		end
	end)
	return searcher1(1)
end)
loader2 = (function(state54, name49, shouldResolve1)
	if shouldResolve1 then
		local cached2 = state54["libNames"][name49]
		if (cached2 == nil) then
			return pathLocator1(state54, name49)
		elseif (cached2 == true) then
			return list1(nil, _2e2e_2("Already loading ", name49))
		else
			return list1(cached2)
		end
	else
		name49 = gsub1(name49, "%.lisp$", "")
		local r_14561 = state54["libCache"][name49]
		if eq_3f_1(r_14561, nil) then
			local handle8 = open1(_2e2e_2(name49, ".lisp"))
			if handle8 then
				state54["libCache"][name49] = true
				local lib6 = readLibrary1(state54, simplifyPath1(name49, state54["paths"]), name49, handle8)
				state54["libCache"][name49] = lib6
				return list1(lib6)
			else
				return list1(nil, _2e2e_2("Cannot find ", quoted1(name49)))
			end
		elseif eq_3f_1(r_14561, true) then
			return list1(nil, _2e2e_2("Already loading ", name49))
		else
			return list1(r_14561)
		end
	end
end)
printError_21_1 = (function(msg34)
	if string_3f_1(msg34) then
	else
		msg34 = pretty1(msg34)
	end
	local lines10 = split1(msg34, "\n", 1)
	print1(colored1(31, _2e2e_2("[ERROR] ", car1(lines10))))
	if car1(cdr1(lines10)) then
		return print1(car1(cdr1(lines10)))
	else
		return nil
	end
end)
printWarning_21_1 = (function(msg35)
	local lines11 = split1(msg35, "\n", 1)
	print1(colored1(33, _2e2e_2("[WARN] ", car1(lines11))))
	if car1(cdr1(lines11)) then
		return print1(car1(cdr1(lines11)))
	else
		return nil
	end
end)
printVerbose_21_1 = (function(verbosity1, msg36)
	if (verbosity1 > 0) then
		return print1(_2e2e_2("[VERBOSE] ", msg36))
	else
		return nil
	end
end)
printDebug_21_1 = (function(verbosity2, msg37)
	if (verbosity2 > 1) then
		return print1(_2e2e_2("[DEBUG] ", msg37))
	else
		return nil
	end
end)
printTime_21_1 = (function(maximum1, name50, time1, level5)
	if (level5 <= maximum1) then
		return print1(_2e2e_2("[TIME] ", name50, " took ", time1))
	else
		return nil
	end
end)
printExplain_21_1 = (function(explain5, lines12)
	if explain5 then
		local r_14911 = split1(lines12, "\n")
		local r_14941 = n1(r_14911)
		local r_14921 = nil
		r_14921 = (function(r_14931)
			if (r_14931 <= r_14941) then
				print1(_2e2e_2("  ", (r_14911[r_14931])))
				return r_14921((r_14931 + 1))
			else
				return nil
			end
		end)
		return r_14921(1)
	else
		return nil
	end
end)
create5 = (function(verbosity3, explain6, time2)
	return ({["verbosity"]=(verbosity3 or 0),["explain"]=(explain6 == true),["time"]=(time2 or 0),["put-error!"]=putError_21_2,["put-warning!"]=putWarning_21_2,["put-verbose!"]=putVerbose_21_2,["put-debug!"]=putDebug_21_2,["put-time!"]=putTime_21_1,["put-node-error!"]=putNodeError_21_2,["put-node-warning!"]=putNodeWarning_21_2})
end)
putError_21_2 = (function(logger22, msg38)
	return printError_21_1(msg38)
end)
putWarning_21_2 = (function(logger23, msg39)
	return printWarning_21_1(msg39)
end)
putVerbose_21_2 = (function(logger24, msg40)
	return printVerbose_21_1(logger24["verbosity"], msg40)
end)
putDebug_21_2 = (function(logger25, msg41)
	return printDebug_21_1(logger25["verbosity"], msg41)
end)
putTime_21_1 = (function(logger26, name51, time3, level6)
	return printTime_21_1(logger26["time"], name51, time3, level6)
end)
putNodeError_21_2 = (function(logger27, msg42, node69, explain7, lines13)
	printError_21_1(msg42)
	putTrace_21_1(node69)
	if explain7 then
		printExplain_21_1(logger27["explain"], explain7)
	end
	return putLines_21_1(true, lines13)
end)
putNodeWarning_21_2 = (function(logger28, msg43, node70, explain8, lines14)
	printWarning_21_1(msg43)
	putTrace_21_1(node70)
	if explain8 then
		printExplain_21_1(logger28["explain"], explain8)
	end
	return putLines_21_1(true, lines14)
end)
putLines_21_1 = (function(range6, entries2)
	if empty_3f_1(entries2) then
		error1("Positions cannot be empty")
	end
	if ((n1(entries2) % 2) ~= 0) then
		error1(_2e2e_2("Positions must be a multiple of 2, is ", n1(entries2)))
	end
	local previous8 = -1
	local file4 = entries2[1]["name"]
	local maxLine1 = foldl1((function(max7, node71)
		if string_3f_1(node71) then
			return max7
		else
			return max2(max7, node71["start"]["line"])
		end
	end), 0, entries2)
	local code3 = _2e2e_2(colored1(92, _2e2e_2(" %", n1(tostring1(maxLine1)), "s │")), " %s")
	local r_14871 = n1(entries2)
	local r_14851 = nil
	r_14851 = (function(r_14861)
		if (r_14861 <= r_14871) then
			local position1 = entries2[r_14861]
			local message1 = entries2[(r_14861 + 1)]
			if (file4 ~= position1["name"]) then
				file4 = position1["name"]
				print1(colored1(95, _2e2e_2(" ", file4)))
			elseif ((previous8 ~= -1) and (abs1((position1["start"]["line"] - previous8)) > 2)) then
				print1(colored1(92, " ..."))
			end
			previous8 = position1["start"]["line"]
			print1(format1(code3, tostring1(position1["start"]["line"]), position1["lines"][position1["start"]["line"]]))
			local pointer1
			if not range6 then
				pointer1 = "^"
			elseif (position1["finish"] and (position1["start"]["line"] == position1["finish"]["line"])) then
				pointer1 = rep1("^", ((position1["finish"]["column"] - position1["start"]["column"]) + 1))
			else
				pointer1 = "^..."
			end
			print1(format1(code3, "", _2e2e_2(rep1(" ", (position1["start"]["column"] - 1)), pointer1, " ", message1)))
			return r_14851((r_14861 + 2))
		else
			return nil
		end
	end)
	return r_14851(1)
end)
putTrace_21_1 = (function(node72)
	local previous9 = nil
	local r_14891 = nil
	r_14891 = (function()
		if node72 then
			local formatted1 = formatNode1(node72)
			if (previous9 == nil) then
				print1(colored1(96, _2e2e_2("  => ", formatted1)))
			elseif (previous9 ~= formatted1) then
				print1(_2e2e_2("  in ", formatted1))
			else
			end
			previous9 = formatted1
			node72 = node72["parent"]
			return r_14891()
		else
			return nil
		end
	end)
	return r_14891()
end)
createPluginState1 = (function(compiler15)
	local logger29 = compiler15["log"]
	local variables1 = compiler15["variables"]
	local states5 = compiler15["states"]
	local warnings1 = compiler15["warning"]
	local optimise3 = compiler15["optimise"]
	local activeScope1 = (function()
		return compiler15["active-scope"]
	end)
	local activeNode1 = (function()
		return compiler15["active-node"]
	end)
	return ({["add-categoriser!"]=(function()
		return error1("add-categoriser! is not yet implemented", 0)
	end),["categorise-node"]=visitNode2,["categorise-nodes"]=visitNodes1,["cat"]=cat3,["writer/append!"]=append_21_1,["writer/line!"]=line_21_1,["writer/indent!"]=indent_21_1,["writer/unindent!"]=unindent_21_1,["writer/begin-block!"]=beginBlock_21_1,["writer/next-block!"]=nextBlock_21_1,["writer/end-block!"]=endBlock_21_1,["add-emitter!"]=(function()
		return error1("add-emitter! is not yet implemented", 0)
	end),["emit-node"]=expression2,["emit-block"]=block2,["logger/put-error!"]=(function(r_14981)
		return self1(logger29, "put-error!", r_14981)
	end),["logger/put-warning!"]=(function(r_14991)
		return self1(logger29, "put-warning!", r_14991)
	end),["logger/put-verbose!"]=(function(r_15001)
		return self1(logger29, "put-verbose!", r_15001)
	end),["logger/put-debug!"]=(function(r_15011)
		return self1(logger29, "put-debug!", r_15011)
	end),["logger/put-node-error!"]=(function(msg44, node73, explain9, ...)
		local lines15 = _pack(...) lines15.tag = "list"
		return putNodeError_21_1(logger29, msg44, node73, explain9, unpack1(lines15, 1, n1(lines15)))
	end),["logger/put-node-warning!"]=(function(msg45, node74, explain10, ...)
		local lines16 = _pack(...) lines16.tag = "list"
		return putNodeWarning_21_1(logger29, msg45, node74, explain10, unpack1(lines16, 1, n1(lines16)))
	end),["logger/do-node-error!"]=(function(msg46, node75, explain11, ...)
		local lines17 = _pack(...) lines17.tag = "list"
		return doNodeError_21_1(logger29, msg46, node75, explain11, unpack1(lines17, 1, n1(lines17)))
	end),["range/get-source"]=getSource1,["visit-node"]=visitNode1,["visit-nodes"]=visitBlock1,["traverse-nodes"]=traverseNode1,["traverse-nodes"]=traverseList1,["symbol->var"]=(function(x69)
		local var51 = x69["var"]
		if string_3f_1(var51) then
			return variables1[var51]
		else
			return var51
		end
	end),["var->symbol"]=makeSymbol1,["builtin?"]=builtin_3f_1,["constant?"]=constant_3f_1,["node->val"]=urn_2d3e_val1,["val->node"]=val_2d3e_urn1,["fusion/add-rule!"]=addRule_21_1,["add-pass!"]=(function(pass3)
		local r_15021 = type1(pass3)
		if (r_15021 ~= "table") then
			error1(format1("bad argument %s (expected %s, got %s)", "pass", "table", r_15021), 2)
		end
		if string_3f_1(pass3["name"]) then
		else
			error1(_2e2e_2("Expected string for name, got ", type1(pass3["name"])))
		end
		if invokable_3f_1(pass3["run"]) then
		else
			error1(_2e2e_2("Expected function for run, got ", type1(pass3["run"])))
		end
		if (type1((pass3["cat"])) == "list") then
		else
			error1(_2e2e_2("Expected list for cat, got ", type1(pass3["cat"])))
		end
		local func8 = pass3["run"]
		pass3["run"] = (function(...)
			local args34 = _pack(...) args34.tag = "list"
			local r_15031 = list1(xpcall1((function()
				return func8(unpack1(args34, 1, n1(args34)))
			end), traceback1))
			if ((type1(r_15031) == "list") and ((n1(r_15031) >= 2) and ((n1(r_15031) <= 2) and (eq_3f_1(r_15031[1], false) and true)))) then
				local msg47 = r_15031[2]
				return error1(remapTraceback1(compiler15["compileState"]["mappings"], msg47), 0)
			elseif ((type1(r_15031) == "list") and ((n1(r_15031) >= 1) and (eq_3f_1(r_15031[1], true) and true))) then
				local rest1 = slice1(r_15031, 2)
				return unpack1(rest1, 1, n1(rest1))
			else
				return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_15031), ", but none matched.\n", "  Tried: `(false ?msg)`\n  Tried: `(true . ?rest)`"))
			end
		end)
		local cats1 = pass3["cat"]
		local group1
		if elem_3f_1("usage", cats1) then
			group1 = "usage"
		else
			group1 = "normal"
		end
		if elem_3f_1("opt", cats1) then
			pushCdr_21_1(optimise3[group1], pass3)
		elseif elem_3f_1("warn", cats1) then
			pushCdr_21_1(warnings1[group1], pass3)
		else
			error1(_2e2e_2("Cannot register ", pretty1(pass3["name"]), " (do not know how to process ", pretty1(cats1), ")"))
		end
		return nil
	end),["var-usage"]=getVar1,["active-scope"]=activeScope1,["active-node"]=activeNode1,["active-module"]=(function()
		local get2
		get2 = (function(scp1)
			if scp1["isRoot"] then
				return scp1
			else
				return get2(scp1["parent"])
			end
		end)
		return get2(compiler15["active-scope"])
	end),["scope-vars"]=(function(scp2)
		if not scp2 then
			return compiler15["active-scope"]["variables"]
		else
			return scp2["variables"]
		end
	end),["var-lookup"]=(function(symb2, scope21)
		local r_15131 = type1(symb2)
		if (r_15131 ~= "symbol") then
			error1(format1("bad argument %s (expected %s, got %s)", "symb", "symbol", r_15131), 2)
		end
		if (compiler15["active-node"] == nil) then
			error1("Not currently resolving")
		end
		if scope21 then
		else
			scope21 = compiler15["active-scope"]
		end
		return getAlways_21_1(scope21, symbol_2d3e_string1(symb2), compiler15["active-node"])
	end),["var-definition"]=(function(var52)
		if (compiler15["active-node"] == nil) then
			error1("Not currently resolving")
		end
		local state55 = states5[var52]
		if state55 then
			if (state55["stage"] == "parsed") then
				yield1(({["tag"]="build",["state"]=state55}))
			end
			return state55["node"]
		else
			return nil
		end
	end),["var-value"]=(function(var53)
		if (compiler15["active-node"] == nil) then
			error1("Not currently resolving")
		end
		local state56 = states5[var53]
		if state56 then
			return get_21_1(state56)
		else
			return nil
		end
	end),["var-docstring"]=(function(var54)
		return var54["doc"]
	end)})
end)
local spec15 = create1()
local directory1
local dir1 = arg1[0]
dir1 = gsub1(dir1, "\\", "/")
dir1 = gsub1(dir1, "urn/cli%.lisp$", "")
dir1 = gsub1(dir1, "urn/cli$", "")
dir1 = gsub1(dir1, "tacky/cli%.lua$", "")
if ((dir1 ~= "") and (sub1(dir1, -1, -1) ~= "/")) then
	dir1 = _2e2e_2(dir1, "/")
end
local r_15771 = nil
r_15771 = (function()
	if (sub1(dir1, 1, 2) == "./") then
		dir1 = sub1(dir1, 3)
		return r_15771()
	else
		return nil
	end
end)
r_15771()
directory1 = dir1
local paths3 = list1("?", "?/init", _2e2e_2(directory1, "lib/?"), _2e2e_2(directory1, "lib/?/init"))
local tasks1 = list1(warning1, optimise2, emitLisp1, emitLua1, task1, task4, task3, execTask1, replTask1)
addHelp_21_1(spec15)
addArgument_21_1(spec15, ({tag = "list", n = 2, "--explain", "-e"}), "help", "Explain error messages in more detail.")
addArgument_21_1(spec15, ({tag = "list", n = 2, "--time", "-t"}), "help", "Time how long each task takes to execute. Multiple usages will show more detailed timings.", "many", true, "default", 0, "action", (function(arg27, data8)
	data8[arg27["name"]] = ((data8[arg27["name"]] or 0) + 1)
	return nil
end))
addArgument_21_1(spec15, ({tag = "list", n = 2, "--verbose", "-v"}), "help", "Make the output more verbose. Can be used multiple times", "many", true, "default", 0, "action", (function(arg28, data9)
	data9[arg28["name"]] = ((data9[arg28["name"]] or 0) + 1)
	return nil
end))
addArgument_21_1(spec15, ({tag = "list", n = 2, "--include", "-i"}), "help", "Add an additional argument to the include path.", "many", true, "narg", 1, "default", ({tag = "list", n = 0}), "action", addAction1)
addArgument_21_1(spec15, ({tag = "list", n = 2, "--prelude", "-p"}), "help", "A custom prelude path to use.", "narg", 1, "default", _2e2e_2(directory1, "lib/prelude"))
addArgument_21_1(spec15, ({tag = "list", n = 3, "--output", "--out", "-o"}), "help", "The destination to output to.", "narg", 1, "default", "out")
addArgument_21_1(spec15, ({tag = "list", n = 2, "--wrapper", "-w"}), "help", "A wrapper script to launch Urn with", "narg", 1, "action", (function(a7, b7, value13)
	local args35 = map1(id1, arg1)
	local i14 = 1
	local len14 = n1(args35)
	local r_15161 = nil
	r_15161 = (function()
		if (i14 <= len14) then
			local item2 = args35[i14]
			if ((item2 == "--wrapper") or (item2 == "-w")) then
				removeNth_21_1(args35, i14)
				removeNth_21_1(args35, i14)
				i14 = (len14 + 1)
			elseif find1(item2, "^%-%-wrapper=.*$") then
				removeNth_21_1(args35, i14)
				i14 = (len14 + 1)
			elseif find1(item2, "^%-[^-]+w$") then
				args35[i14] = sub1(item2, 1, -2)
				removeNth_21_1(args35, (i14 + 1))
				i14 = (len14 + 1)
			end
			return r_15161()
		else
			return nil
		end
	end)
	r_15161()
	local command2 = list1(value13)
	local interp1 = arg1[-1]
	if interp1 then
		pushCdr_21_1(command2, interp1)
	end
	pushCdr_21_1(command2, arg1[0])
	local r_15181 = list1(execute1(concat1(append1(command2, args35), " ")))
	if ((type1(r_15181) == "list") and ((n1(r_15181) >= 1) and (number_3f_1(r_15181[1]) and true))) then
		return exit1((r_15181[1]))
	elseif ((type1(r_15181) == "list") and ((n1(r_15181) >= 3) and ((n1(r_15181) <= 3) and true))) then
		return exit1((r_15181[3]))
	else
		return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_15181), ", but none matched.\n", "  Tried: `((number? @ ?code) . _)`\n  Tried: `(_ _ ?code)`"))
	end
end))
addArgument_21_1(spec15, ({tag = "list", n = 1, "--plugin"}), "help", "Specify a compiler plugin to load.", "var", "FILE", "default", ({tag = "list", n = 0}), "narg", 1, "many", true, "action", addAction1)
addArgument_21_1(spec15, ({tag = "list", n = 1, "input"}), "help", "The file(s) to load.", "var", "FILE", "narg", "*")
local r_15331 = n1(tasks1)
local r_15311 = nil
r_15311 = (function(r_15321)
	if (r_15321 <= r_15331) then
		local task5 = tasks1[r_15321]
		task5["setup"](spec15)
		return r_15311((r_15321 + 1))
	else
		return nil
	end
end)
r_15311(1)
local args36 = parse_21_1(spec15)
local logger30 = create5(args36["verbose"], args36["explain"], args36["time"])
local r_15361 = args36["include"]
local r_15391 = n1(r_15361)
local r_15371 = nil
r_15371 = (function(r_15381)
	if (r_15381 <= r_15391) then
		local path6 = r_15361[r_15381]
		path6 = gsub1(path6, "\\", "/")
		path6 = gsub1(path6, "^%./", "")
		if find1(path6, "%?") then
		else
			path6 = _2e2e_2(path6, (function()
				if (sub1(path6, -1, -1) == "/") then
					return "?"
				else
					return "/?"
				end
			end)()
			)
		end
		pushCdr_21_1(paths3, path6)
		return r_15371((r_15381 + 1))
	else
		return nil
	end
end)
r_15371(1)
self1(logger30, "put-verbose!", (_2e2e_2("Using path: ", pretty1(paths3))))
if empty_3f_1(args36["input"]) then
	args36["repl"] = true
else
	args36["emit-lua"] = true
end
local compiler16 = ({["log"]=logger30,["timer"]=({["callback"]=(function(r_15731, r_15741, r_15751)
	return self1(logger30, "put-time!", r_15731, r_15741, r_15751)
end),["timers"]=({})}),["paths"]=paths3,["libEnv"]=({}),["libMeta"]=({}),["libs"]=({tag = "list", n = 0}),["libCache"]=({}),["libNames"]=({}),["warning"]=({["normal"]=list1(documentation1),["usage"]=list1(checkArity1, deprecated1)}),["optimise"]=default1(),["rootScope"]=rootScope1,["variables"]=({}),["states"]=({}),["out"]=({tag = "list", n = 0})})
compiler16["compileState"] = createState1(compiler16["libMeta"])
compiler16["loader"] = (function(name52)
	return loader2(compiler16, name52, true)
end)
compiler16["global"] = setmetatable1(({["_libs"]=compiler16["libEnv"],["_compiler"]=createPluginState1(compiler16)}), ({["__index"]=_5f_G1}))
iterPairs1(compiler16["rootScope"]["variables"], (function(_5f_4, var55)
	compiler16["variables"][tostring1(var55)] = var55
	return nil
end))
startTimer_21_1(compiler16["timer"], "loading")
local r_15411 = loader2(compiler16, args36["prelude"], false)
if ((type1(r_15411) == "list") and ((n1(r_15411) >= 2) and ((n1(r_15411) <= 2) and (eq_3f_1(r_15411[1], nil) and true)))) then
	local errorMessage1 = r_15411[2]
	self1(logger30, "put-error!", errorMessage1)
	exit_21_1(1)
elseif ((type1(r_15411) == "list") and ((n1(r_15411) >= 1) and ((n1(r_15411) <= 1) and true))) then
	local lib7 = r_15411[1]
	compiler16["rootScope"] = child1(compiler16["rootScope"])
	iterPairs1(lib7["scope"]["exported"], (function(name53, var56)
		return import_21_1(compiler16["rootScope"], name53, var56)
	end))
	local r_15521 = append1(args36["plugin"], args36["input"])
	local r_15551 = n1(r_15521)
	local r_15531 = nil
	r_15531 = (function(r_15541)
		if (r_15541 <= r_15551) then
			local input1 = r_15521[r_15541]
			local r_15571 = loader2(compiler16, input1, false)
			if ((type1(r_15571) == "list") and ((n1(r_15571) >= 2) and ((n1(r_15571) <= 2) and (eq_3f_1(r_15571[1], nil) and true)))) then
				local errorMessage2 = r_15571[2]
				self1(logger30, "put-error!", errorMessage2)
				exit_21_1(1)
			elseif ((type1(r_15571) == "list") and ((n1(r_15571) >= 1) and ((n1(r_15571) <= 1) and true))) then
			else
				error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_15571), ", but none matched.\n", "  Tried: `(nil ?error-message)`\n  Tried: `(_)`"))
			end
			return r_15531((r_15541 + 1))
		else
			return nil
		end
	end)
	r_15531(1)
else
	error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_15411), ", but none matched.\n", "  Tried: `(nil ?error-message)`\n  Tried: `(?lib)`"))
end
stopTimer_21_1(compiler16["timer"], "loading")
local r_15711 = n1(tasks1)
local r_15691 = nil
r_15691 = (function(r_15701)
	if (r_15701 <= r_15711) then
		local task6 = tasks1[r_15701]
		if task6["pred"](args36) then
			startTimer_21_1(compiler16["timer"], task6["name"], 1)
			task6["run"](compiler16, args36)
			stopTimer_21_1(compiler16["timer"], task6["name"])
		end
		return r_15691((r_15701 + 1))
	else
		return nil
	end
end)
return r_15691(1)
