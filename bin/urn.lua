#!/usr/bin/env lua
if not table.pack then table.pack = function(...) return { n = select("#", ...), ... } end end
if not table.unpack then table.unpack = unpack end
local load = load if _VERSION:find("5.1") then load = function(x, n, _, env) local f, e = loadstring(x, n) if not f then return f, e end if env then setfenv(f, env) end return f end end
local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error
local _libs = {}
local getIdx1, _3d_1, n1, nth1, _2b_1, setIdx_21_1, _2e2e_1, _3c3d_1, type1, append_21_1, car1, error1, _2f3d_1, builtins1, pushCdr_21_1, _2d_1, sub1, line_21_1, format1, self2, _3e_1, list1, _3e3d_1, pretty1, print1, next1, getSource1, compileExpression1, builtin_3f_1, concat1, empty_3f_1, _3c_1, doNodeError_21_2, gsub1, string_3f_1, quoted1, addArgument_21_1, cadr1, exit_21_1, find1, tostring1, succ1, _5e7e_1, on_21_1, removeNth_21_1, visitNode1, coloured1, type_23_1, tonumber1, last1, visitBlock1, unpack1, pushEscapeVar_21_1, doNodeError_21_1, visitNodes1, getVar1, visitNode3, open1, constVal1, map2, resolveNode1, usage_21_1, getenv1, addParen1, escapeVar1, number_3f_1, apply1, slice1, sort1, compileBlock1, arg1, putNodeWarning_21_1, pcall1, split1, expectType_21_1, runPass1, between_3f_1, unmangleIdent1, formatOutput_21_1, get1, symbol_2d3e_string1, any1, len_23_1, scoreNodes1, makeNil1, visitNode4, popLast_21_1, formatNode1, expect_21_1, eq_3f_1, match1, sethook1, lower1, endBlock_21_1, write1, _2f_1, visitNode2, void1, matcher2, traverseNode1
local _ENV = setmetatable({}, {__index=ENV or (getfenv and getfenv()) or _G}) if setfenv then setfenv(0, _ENV) end
_3d_1 = function(v1, v2) return v1 == v2 end
_2f3d_1 = function(v1, v2) return v1 ~= v2 end
_3c_1 = function(v1, v2) return v1 < v2 end
_3c3d_1 = function(v1, v2) return v1 <= v2 end
_3e_1 = function(v1, v2) return v1 > v2 end
_3e3d_1 = function(v1, v2) return v1 >= v2 end
_2b_1 = function(...) local t = ... for i = 2, _select('#', ...) do t = t + _select(i, ...) end return t end
_2d_1 = function(...) local t = ... for i = 2, _select('#', ...) do t = t - _select(i, ...) end return t end
_2a_1 = function(...) local t = ... for i = 2, _select('#', ...) do t = t * _select(i, ...) end return t end
_2f_1 = function(...) local t = ... for i = 2, _select('#', ...) do t = t / _select(i, ...) end return t end
mod1 = function(...) local t = ... for i = 2, _select('#', ...) do t = t % _select(i, ...) end return t end
expt1 = function(...) local t = ... for i = 2, _select('#', ...) do t = t ^ _select(i, ...) end return t end
_2e2e_1 = function(...) local n = _select('#', ...) local t = _select(n, ...) for i = n - 1, 1, -1 do t = _select(i, ...) .. t end return t end
_5f_G1 = _G
arg_23_1 = arg or {...}
len_23_1 = function(v1) return #v1 end
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
byte1 = string.byte
char1 = string.char
find1 = string.find
format1 = string.format
gsub1 = string.gsub
lower1 = string.lower
match1 = string.match
rep1 = string.rep
reverse1 = string.reverse
sub1 = string.sub
upper1 = string.upper
concat1 = table.concat
insert1 = table.insert
remove1 = table.remove
sort1 = table.sort
unpack1 = table.unpack
n1 = function(x)
	if type_23_1(x) == "table" then
		return x["n"]
	else
		return #x
	end
end
slice1 = function(xs, start, finish)
	if not finish then
		finish = xs["n"]
		if not finish then
			finish = #xs
		end
	end
	local len, _ = (finish - start) + 1
	if len < 0 then
		len = 0
	end
	local out, i, j = {["tag"]="list", ["n"]=len}, 1, start
	while j <= finish do
		out[i] = xs[j]
		i, j = i + 1, j + 1
	end
	return out
end
list1 = function(...)
	local xs = _pack(...) xs.tag = "list"
	return xs
end
if nil == arg_23_1 then
	arg1 = {tag="list", n=0}
else
	arg_23_1["tag"] = "list"
	if not arg_23_1["n"] then
		arg_23_1["n"] = #arg_23_1
	end
	arg1 = arg_23_1
end
constVal1 = function(val)
	if type_23_1(val) == "table" then
		local tag = val["tag"]
		if tag == "number" then
			return val["value"]
		elseif tag == "string" then
			return val["value"]
		else
			return val
		end
	else
		return val
	end
end
apply1 = function(f, ...)
	local _n = _select("#", ...) - 1
	local xss, xs
	if _n > 0 then
		xss = {tag="list", n=_n, _unpack(_pack(...), 1, _n)}
		xs = select(_n + 1, ...)
	else
		xss = {tag="list", n=0}
		xs = ...
	end
	local args = (function()
		local _offset, _result, _temp = 0, {tag="list"}
		_temp = xss
		for _c = 1, _temp.n do _result[0 + _c + _offset] = _temp[_c] end
		_offset = _offset + _temp.n
		_temp = xs
		for _c = 1, _temp.n do _result[0 + _c + _offset] = _temp[_c] end
		_offset = _offset + _temp.n
		_result.n = _offset + 0
		return _result
	end)()
	return f(unpack1(args, 1, n1(args)))
end
first1 = function(...)
	local rest = _pack(...) rest.tag = "list"
	return rest[1]
end
empty_3f_1 = function(x)
	local xt = type1(x)
	if xt == "list" then
		return x["n"] == 0
	elseif xt == "string" then
		return #x == 0
	else
		return false
	end
end
string_3f_1 = function(x)
	return type_23_1(x) == "string" or type_23_1(x) == "table" and x["tag"] == "string"
end
number_3f_1 = function(x)
	return type_23_1(x) == "number" or type_23_1(x) == "table" and x["tag"] == "number"
end
function_3f_1 = function(x)
	return type1(x) == "function" or type1(x) == "multimethod"
end
atom_3f_1 = function(x)
	local temp = type_23_1(x) ~= "table"
	if temp then
		return temp
	else
		local temp1 = type_23_1(x) == "table"
		if temp1 then
			local tag = x["tag"]
			return tag == "symbol" or (tag == "key" or (tag == "number" or tag == "string"))
		else
			return temp1
		end
	end
end
between_3f_1 = function(val, min, max)
	return val >= min and val <= max
end
type1 = function(val)
	local ty = type_23_1(val)
	if ty == "table" then
		return val["tag"] or "table"
	else
		return ty
	end
end
neq_3f_1 = function(x, y)
	return not eq_3f_1(x, y)
end
map1 = function(f, x)
	local out = {tag="list", n=0}
	local temp = n1(x)
	local temp1 = 1
	while temp1 <= temp do
		out[temp1] = f(x[temp1])
		temp1 = temp1 + 1
	end
	out["n"] = n1(x)
	return out
end
put_21_1 = function(t, typs, l)
	local len = n1(typs)
	local temp = len - 1
	local temp1 = 1
	while temp1 <= temp do
		local x = typs[temp1]
		local y = t[x]
		if not y then
			y = {}
			t[x] = y
		end
		t = y
		temp1 = temp1 + 1
	end
	t[typs[len]] = l
	return nil
end
local eq_3f_
local tempThis = {["lookup"]={["list"]={["list"]=function(x, y)
	if n1(x) ~= n1(y) then
		return false
	else
		local equal = true
		local temp = n1(x)
		local temp1 = 1
		while temp1 <= temp do
			if neq_3f_1(x[temp1], y[temp1]) then
				equal = false
			end
			temp1 = temp1 + 1
		end
		return equal
	end
end}, ["table"]={["table"]=function(x, y)
	local equal = true
	local temp, v = next1(x)
	while temp ~= nil do
		if neq_3f_1(v, y[temp]) then
			equal = false
		end
		temp, v = next1(x, temp)
	end
	return equal
end}, ["symbol"]={["symbol"]=function(x, y)
	return x["contents"] == y["contents"]
end, ["string"]=function(x, y)
	return x["contents"] == y
end}, ["string"]={["symbol"]=function(x, y)
	return x == y["contents"]
end, ["key"]=function(x, y)
	return x == y["value"]
end, ["string"]=function(x, y)
	return constVal1(x) == constVal1(y)
end}, ["key"]={["string"]=function(x, y)
	return x["value"] == y
end, ["key"]=function(x, y)
	return x["value"] == y["value"]
end}, ["number"]={["number"]=function(x, y)
	return constVal1(x) == constVal1(y)
end}, ["rational"]={["rational"]=function(x, y)
	local xn, xd = normalisedRationalComponents1(x)
	local yn, yd = normalisedRationalComponents1(y)
	return xn == yn and xd == yd
end}}, ["tag"]="multimethod", ["default"]=function(x, y)
	return false
end}
eq_3f_ = setmetatable1(tempThis, {["__call"]=(function()
	local myself
	local myself1 = function(x, y)
		local tempMethod = (tempThis["lookup"][type1(x)] or {})[type1(y)] or tempThis["default"]
		if not tempMethod then
			error1("No matching method to call for (" .. concat1(list1("eq?", type1(x), type1(y)), " ") .. ")")
		end
		return tempMethod(x, y)
	end
	myself = function(x, y)
		if x == y then
			return true
		else
			return myself1(x, y)
		end
	end
	return function(tempThis1, x, y)
		return myself(x, y)
	end
end)(), ["name"]="eq?", ["args"]=list1("x", "y")})
put_21_1(eq_3f_, list1("lookup", "number", "rational"), (eq_3f_["lookup"]["rational"] or {})["rational"])
put_21_1(eq_3f_, list1("lookup", "rational", "number"), (eq_3f_["lookup"]["rational"] or {})["rational"])
eq_3f_1 = eq_3f_
local tempThis = {["lookup"]={["list"]=function(xs)
	return "(" .. concat1(map1(pretty1, xs), " ") .. ")"
end, ["symbol"]=function(x)
	return x["contents"]
end, ["key"]=function(x)
	return ":" .. x["value"]
end, ["number"]=function(x)
	return format1("%g", constVal1(x))
end, ["string"]=function(x)
	return format1("%q", constVal1(x))
end, ["table"]=function(x)
	local out = {tag="list", n=0}
	local temp, v = next1(x)
	while temp ~= nil do
		local _offset, _result, _temp = 0, {tag="list"}
		_result[1 + _offset] = pretty1(temp) .. " " .. pretty1(v)
		_temp = out
		for _c = 1, _temp.n do _result[1 + _c + _offset] = _temp[_c] end
		_offset = _offset + _temp.n
		_result.n = _offset + 1
		out = _result
		temp, v = next1(x, temp)
	end
	return "{" .. (concat1(out, " ") .. "}")
end, ["multimethod"]=function(x)
	return "«method: (" .. getmetatable1(x)["name"] .. " " .. concat1(getmetatable1(x)["args"], " ") .. ")»"
end, ["rational"]=function(x)
	local xn, xd = normalisedRationalComponents1(x)
	return formatOutput_21_1(nil, "" .. format1("%d", xn) .. "/" .. format1("%d", xd))
end}, ["tag"]="multimethod", ["default"]=function(x)
	if type_23_1(x) == "table" then
		return pretty1["lookup"]["table"](x)
	else
		return tostring1(x)
	end
end}
pretty1 = setmetatable1(tempThis, {["__call"]=(function()
	local myself = function(x)
		local tempMethod = tempThis["lookup"][type1(x)] or tempThis["default"]
		if not tempMethod then
			error1("No matching method to call for (" .. concat1(list1("pretty", type1(x)), " ") .. ")")
		end
		return tempMethod(x)
	end
	return function(tempThis1, x)
		return myself(x)
	end
end)(), ["name"]="pretty", ["args"]=list1("x")})
abs1 = math.abs
huge1 = math.huge
max1 = math.max
min1 = math.min
modf1 = math.modf
car1 = function(x)
	local temp = type1(x)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "x", "list", temp), 2)
	end
	return x[1]
end
cdr1 = function(x)
	local temp = type1(x)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "x", "list", temp), 2)
	end
	if empty_3f_1(x) then
		return {tag="list", n=0}
	else
		return slice1(x, 2)
	end
end
reduce1 = function(f, z, xs)
	local temp = type1(f)
	if temp ~= "function" then
		error1(format1("bad argument %s (expected %s, got %s)", "f", "function", temp), 2)
	end
	local start = 1
	if type_23_1(xs) == "nil" and type1(z) == "list" then
		start = 2
		xs = z
		z = car1(z)
	end
	local temp = type1(xs)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "xs", "list", temp), 2)
	end
	local accum = z
	local temp = n1(xs)
	local temp1 = start
	while temp1 <= temp do
		accum = f(accum, nth1(xs, temp1))
		temp1 = temp1 + 1
	end
	return accum
end
map2 = function(fn, ...)
	local xss = _pack(...) xss.tag = "list"
	local ns
	local out = {tag="list", n=0}
	local temp = n1(xss)
	local temp1 = 1
	while temp1 <= temp do
		if not (type1((nth1(xss, temp1))) == "list") then
			error1("that's no list! " .. pretty1(nth1(xss, temp1)) .. " (it's a " .. type1(nth1(xss, temp1)) .. "!)")
		end
		pushCdr_21_1(out, n1(nth1(xss, temp1)))
		temp1 = temp1 + 1
	end
	ns = out
	local out = {tag="list", n=0}
	local temp = apply1(min1, ns)
	local temp1 = 1
	while temp1 <= temp do
		pushCdr_21_1(out, apply1(fn, nths1(xss, temp1)))
		temp1 = temp1 + 1
	end
	return out
end
partition1 = function(p, xs)
	local temp = type1(p)
	if temp ~= "function" then
		error1(format1("bad argument %s (expected %s, got %s)", "p", "function", temp), 2)
	end
	local temp = type1(xs)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "xs", "list", temp), 2)
	end
	local passed, failed = {tag="list", n=0}, {tag="list", n=0}
	local temp = n1(xs)
	local temp1 = 1
	while temp1 <= temp do
		local x = nth1(xs, temp1)
		pushCdr_21_1((function()
			if p(x) then
				return passed
			else
				return failed
			end
		end)(), x)
		temp1 = temp1 + 1
	end
	return unpack1(list1(passed, failed), 1, 2)
end
any1 = function(p, xs)
	local temp = type1(p)
	if temp ~= "function" then
		error1(format1("bad argument %s (expected %s, got %s)", "p", "function", temp), 2)
	end
	local temp = type1(xs)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "xs", "list", temp), 2)
	end
	local len = n1(xs)
	local i = 1
	while true do
		if i > len then
			return false
		elseif p(nth1(xs, i)) then
			return true
		else
			i = i + 1
		end
	end
end
all1 = function(p, xs)
	local temp = type1(p)
	if temp ~= "function" then
		error1(format1("bad argument %s (expected %s, got %s)", "p", "function", temp), 2)
	end
	local temp = type1(xs)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "xs", "list", temp), 2)
	end
	local len = n1(xs)
	local i = 1
	while true do
		if i > len then
			return true
		elseif p(nth1(xs, i)) then
			i = i + 1
		else
			return false
		end
	end
end
elem_3f_1 = function(x, xs)
	local temp = type1(xs)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "xs", "list", temp), 2)
	end
	return any1(function(y)
		return eq_3f_1(x, y)
	end, xs)
end
last1 = function(xs)
	local temp = type1(xs)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "xs", "list", temp), 2)
	end
	return xs[n1(xs)]
end
nth1 = function(xs, idx)
	if idx >= 0 then
		return xs[idx]
	else
		return xs[xs["n"] + 1 + idx]
	end
end
nths1 = function(xss, idx)
	local out = {tag="list", n=0}
	local temp = n1(xss)
	local temp1 = 1
	while temp1 <= temp do
		pushCdr_21_1(out, nth1(nth1(xss, temp1), idx))
		temp1 = temp1 + 1
	end
	return out
end
pushCdr_21_1 = function(xs, val)
	local temp = type1(xs)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "xs", "list", temp), 2)
	end
	local len = n1(xs) + 1
	xs["n"] = len
	xs[len] = val
	return xs
end
popLast_21_1 = function(xs)
	local temp = type1(xs)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "xs", "list", temp), 2)
	end
	local x = xs[n1(xs)]
	xs[n1(xs)] = nil
	xs["n"] = n1(xs) - 1
	return x
end
removeNth_21_1 = function(li, idx)
	local temp = type1(li)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "li", "list", temp), 2)
	end
	li["n"] = li["n"] - 1
	return remove1(li, idx)
end
insertNth_21_1 = function(li, idx, val)
	local temp = type1(li)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "li", "list", temp), 2)
	end
	li["n"] = li["n"] + 1
	return insert1(li, idx, val)
end
append1 = function(xs, ys)
	local _offset, _result, _temp = 0, {tag="list"}
	_temp = xs
	for _c = 1, _temp.n do _result[0 + _c + _offset] = _temp[_c] end
	_offset = _offset + _temp.n
	_temp = ys
	for _c = 1, _temp.n do _result[0 + _c + _offset] = _temp[_c] end
	_offset = _offset + _temp.n
	_result.n = _offset + 0
	return _result
end
range1 = function(...)
	local args = _pack(...) args.tag = "list"
	local x
	local out = {}
	if n1(args) % 2 == 1 then
		error1("Expected an even number of arguments to range", 2)
	end
	local temp = n1(args)
	local temp1 = 1
	while temp1 <= temp do
		out[args[temp1]] = args[temp1 + 1]
		temp1 = temp1 + 2
	end
	x = out
	local st, ed = x["from"] or 1, 1 + x["to"] or error1("Expected end index, got nothing")
	local inc = (x["by"] or 1 + st) - st
	local tst
	if st >= ed then
		tst = _3e_1
	else
		tst = _3c_1
	end
	local c, out = st, {tag="list", n=0}
	while tst(c, ed) do
		pushCdr_21_1(out, c)
		c = c + inc
	end
	return out
end
caar1 = function(xs)
	local temp = type1(xs)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "xs", "list", temp), 2)
	end
	return car1(xs[1])
end
caadr1 = function(xs)
	local temp = type1(xs)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "xs", "list", temp), 2)
	end
	return car1(xs[2])
end
cadr1 = function(xs)
	local temp = type1(xs)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "xs", "list", temp), 2)
	end
	return xs[2]
end
cadar1 = function(xs)
	local temp = type1(xs)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "xs", "list", temp), 2)
	end
	return cadr1(xs[1])
end
split1 = function(text, pattern, limit)
	local out, loop, start = {tag="list", n=0}, true, 1
	while loop do
		local pos = list1(find1(text, pattern, start))
		local nstart, nend = car1(pos), cadr1(pos)
		if nstart == nil or limit and n1(out) >= limit then
			loop = false
			pushCdr_21_1(out, sub1(text, start, n1(text)))
			start = n1(text) + 1
		elseif nstart > #text then
			if start <= #text then
				pushCdr_21_1(out, sub1(text, start, #text))
			end
			loop = false
		elseif nend < nstart then
			pushCdr_21_1(out, sub1(text, start, nstart))
			start = nstart + 1
		else
			pushCdr_21_1(out, sub1(text, start, nstart - 1))
			start = nend + 1
		end
	end
	return out
end
trim1 = function(str)
	return (gsub1(gsub1(str, "^%s+", ""), "%s+$", ""))
end
local escapes = {}
local temp = 0
while temp <= 31 do
	escapes[char1(temp)] = "\\" .. tostring1(temp)
	temp = temp + 1
end
escapes["\n"] = "n"
quoted1 = function(str)
	return (gsub1(format1("%q", str), ".", escapes))
end
endsWith_3f_1 = function(str, suffix)
	return sub1(str, 0 - #suffix) == suffix
end
iterPairs1 = function(table, func)
	local temp, v = next1(table)
	while temp ~= nil do
		func(temp, v)
		temp, v = next1(table, temp)
	end
	return nil
end
copyOf1 = function(struct)
	local out = {}
	local temp, v = next1(struct)
	while temp ~= nil do
		out[temp] = v
		temp, v = next1(struct, temp)
	end
	return out
end
merge1 = function(...)
	local structs = _pack(...) structs.tag = "list"
	local out = {}
	local temp = n1(structs)
	local temp1 = 1
	while temp1 <= temp do
		local st = structs[temp1]
		local temp2, v = next1(st)
		while temp2 ~= nil do
			out[temp2] = v
			temp2, v = next1(st, temp2)
		end
		temp1 = temp1 + 1
	end
	return out
end
keys1 = function(st)
	local out = {tag="list", n=0}
	local temp, _5f_ = next1(st)
	while temp ~= nil do
		pushCdr_21_1(out, temp)
		temp, _5f_ = next1(st, temp)
	end
	return out
end
values1 = function(st)
	local out = {tag="list", n=0}
	local temp, v = next1(st)
	while temp ~= nil do
		pushCdr_21_1(out, v)
		temp, v = next1(st, temp)
	end
	return out
end
createLookup1 = function(values)
	local res = {}
	local temp = n1(values)
	local temp1 = 1
	while temp1 <= temp do
		res[nth1(values, temp1)] = temp1
		temp1 = temp1 + 1
	end
	return res
end
symbol_2d3e_string1 = function(x)
	if type1(x) == "symbol" then
		return x["contents"]
	else
		return nil
	end
end
clock1 = os.clock
execute1 = os.execute
exit1 = os.exit
getenv1 = os.getenv
flush1 = io.flush
open1 = io.open
read1 = io.read
write1 = io.write
exit_21_1 = function(reason, code)
	local code1
	if string_3f_1(reason) then
		code1 = code
	else
		code1 = reason
	end
	if exit1 then
		if string_3f_1(reason) then
			print1(reason)
		end
		return exit1(code1)
	elseif string_3f_1(reason) then
		return error1(reason, 0)
	else
		return error1(nil, 0)
	end
end
sprintf1 = function(fmt, ...)
	local args = _pack(...) args.tag = "list"
	return apply1(format1, fmt, args)
end
assoc1 = function(list, key, orVal)
	while true do
		if not (type1(list) == "list") or empty_3f_1(list) then
			return orVal
		elseif eq_3f_1(caar1(list), key) then
			return cadar1(list)
		else
			list = cdr1(list)
		end
	end
end
assoc_3f_1 = function(list, key)
	while true do
		if not (type1(list) == "list") or empty_3f_1(list) then
			return false
		elseif eq_3f_1(caar1(list), key) then
			return true
		else
			list = cdr1(list)
		end
	end
end
formatOutput_21_1 = function(out, buf)
	if out == nil then
		return buf
	elseif out == true then
		return print1(buf)
	elseif number_3f_1(out) then
		return error1(buf, out)
	elseif function_3f_1(out) then
		return out(buf)
	else
		return self1(out, "write", buf)
	end
end
self1 = function(x, key, ...)
	local args = _pack(...) args.tag = "list"
	return x[key](x, unpack1(args, 1, n1(args)))
end
invokable_3f_1 = function(x)
	while true do
		local temp = function_3f_1(x)
		if temp then
			return temp
		else
			local temp1 = type_23_1(x) == "table"
			if temp1 then
				local temp2 = type_23_1((getmetatable1(x))) == "table"
				if temp2 then
					x = getmetatable1(x)["__call"]
				else
					return temp2
				end
			else
				return temp1
			end
		end
	end
end
compose1 = function(f, g)
	if invokable_3f_1(f) and invokable_3f_1(g) then
		return function(x)
			return f(g(x))
		end
	else
		return nil
	end
end
comp1 = function(...)
	local fs = _pack(...) fs.tag = "list"
	return reduce1(compose1, function(x)
		return x
	end, fs)
end
id1 = function(x)
	return x
end
self2 = function(x, key, ...)
	local args = _pack(...) args.tag = "list"
	return apply1(x[key], x, args)
end
lens1 = function(view, over)
	return setmetatable1({["tag"]="lens", ["view"]=view, ["over"]=over}, {["__call"]=function(t, x)
		return _5e2e_1(x, t)
	end})
end
getter_3f_1 = function(lens)
	return type1(lens) == "lens" and function_3f_1(lens["view"])
end
setter_3f_1 = function(lens)
	return type1(lens) == "lens" and function_3f_1(lens["over"])
end
_5e2e_1 = function(val, lens)
	if getter_3f_1(lens) then
		return lens["view"](val)
	else
		return error1(pretty1(lens) .. " is not a getter")
	end
end
_5e7e_1 = function(val, lens, f)
	if setter_3f_1(lens) then
		return lens["over"](f, val)
	else
		return error1(pretty1(lens) .. " is not a setter")
	end
end
on1 = function(k)
	return lens1(function(x)
		return x[k]
	end, function(f, x)
		local out = {}
		local temp, v = next1(x)
		while temp ~= nil do
			if k == temp then
				out[temp] = f(v)
			else
				out[temp] = v
			end
			temp, v = next1(x, temp)
		end
		return out
	end)
end
on_21_1 = function(k)
	return lens1(function(x)
		return x[k]
	end, function(f, x)
		x[k] = f(x[k])
		return x
	end)
end
gcd1 = function(x, y)
	local x1, y1 = abs1(x), abs1(y)
	while not (y1 == 0) do
		x1, y1 = y1, x1 % y1
	end
	return x1
end
succ1 = function(x)
	return x + 1
end
_2d3e_ratComponents1 = function(y)
	local i, f = modf1(y)
	local f_27_ = 10 ^ (n1(tostring1(f)) - 2)
	if 0 == f then
		return unpack1(list1(y, 1), 1, 2)
	else
		local n = y * f_27_
		local g = gcd1(n, f_27_)
		return unpack1(list1((n / g), (f_27_ / g)), 1, 2)
	end
end
normalisedRationalComponents1 = function(x)
	if number_3f_1(x) then
		return _2d3e_ratComponents1(x)
	else
		return unpack1(list1((x["numerator"]), (x["denominator"])), 1, 2)
	end
end
config1 = package.config
colouredAnsi1 = function(col, msg)
	return "\27[" .. col .. "m" .. msg .. "\27[0m"
end
local termTy = lower1(getenv1 and getenv1("TERM") or "")
if termTy == "dumb" then
	coloured_3f_1 = false
elseif find1(termTy, "xterm") then
	coloured_3f_1 = true
elseif config1 and sub1(config1, 1, 1) == "/" then
	coloured_3f_1 = true
elseif getenv1 and getenv1("ANSICON") ~= nil then
	coloured_3f_1 = true
else
	coloured_3f_1 = false
end
if coloured_3f_1 then
	coloured1 = colouredAnsi1
else
	coloured1 = function(_5f_, msg)
		return msg
	end
end
create1 = function(description)
	return {["desc"]=description, ["flag-map"]={}, ["opt-map"]={}, ["cats"]={tag="list", n=0}, ["opt"]={tag="list", n=0}, ["pos"]={tag="list", n=0}}
end
setAction1 = function(arg, data, value)
	data[arg["name"]] = value
	return nil
end
addAction1 = function(arg, data, value)
	local lst = data[arg["name"]]
	if not lst then
		lst = {tag="list", n=0}
		data[arg["name"]] = lst
	end
	return pushCdr_21_1(lst, value)
end
setNumAction1 = function(aspec, data, value, usage_21_)
	local val = tonumber1(value)
	if val then
		data[aspec["name"]] = val
		return nil
	else
		return usage_21_("Expected number for " .. car1(arg1["names"]) .. ", got " .. value)
	end
end
addArgument_21_1 = function(spec, names, ...)
	local options = _pack(...) options.tag = "list"
	local temp = type1(names)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "names", "list", temp), 2)
	end
	if empty_3f_1(names) then
		error1("Names list is empty")
	end
	if not (n1(options) % 2 == 0) then
		error1("Options list should be a multiple of two")
	end
	local result = {["names"]=names, ["action"]=nil, ["narg"]=0, ["default"]=false, ["help"]="", ["value"]=true}
	local first = car1(names)
	if sub1(first, 1, 2) == "--" then
		pushCdr_21_1(spec["opt"], result)
		result["name"] = sub1(first, 3)
	elseif sub1(first, 1, 1) == "-" then
		pushCdr_21_1(spec["opt"], result)
		result["name"] = sub1(first, 2)
	else
		result["name"] = first
		result["narg"] = "*"
		result["default"] = {tag="list", n=0}
		pushCdr_21_1(spec["pos"], result)
	end
	local temp = n1(names)
	local temp1 = 1
	while temp1 <= temp do
		local name = names[temp1]
		if sub1(name, 1, 2) == "--" then
			spec["opt-map"][sub1(name, 3)] = result
		elseif sub1(name, 1, 1) == "-" then
			spec["flag-map"][sub1(name, 2)] = result
		end
		temp1 = temp1 + 1
	end
	local temp = n1(options)
	local temp1 = 1
	while temp1 <= temp do
		result[nth1(options, temp1)] = (nth1(options, temp1 + 1))
		temp1 = temp1 + 2
	end
	if not result["var"] then
		result["var"] = upper1(result["name"])
	end
	if not result["action"] then
		result["action"] = (function()
			local temp
			if number_3f_1(result["narg"]) then
				temp = result["narg"] <= 1
			else
				temp = result["narg"] == "?"
			end
			if temp then
				return setAction1
			else
				return addAction1
			end
		end)()
	end
	return result
end
addHelp_21_1 = function(spec)
	return addArgument_21_1(spec, {tag="list", n=2, "--help", "-h"}, "help", "Show this help message", "default", nil, "value", nil, "action", function()
		help_21_1(spec)
		return exit_21_1(0)
	end)
end
addCategory_21_1 = function(spec, id, name, description)
	local temp = type1(id)
	if temp ~= "string" then
		error1(format1("bad argument %s (expected %s, got %s)", "id", "string", temp), 2)
	end
	local temp = type1(name)
	if temp ~= "string" then
		error1(format1("bad argument %s (expected %s, got %s)", "name", "string", temp), 2)
	end
	pushCdr_21_1(spec["cats"], {["id"]=id, ["name"]=name, ["desc"]=description})
	return spec
end
usageNarg_21_1 = function(buffer, arg)
	local temp = arg["narg"]
	if temp == "?" then
		return pushCdr_21_1(buffer, " [" .. arg["var"] .. "]")
	elseif temp == "*" then
		return pushCdr_21_1(buffer, " [" .. arg["var"] .. "...]")
	elseif temp == "+" then
		return pushCdr_21_1(buffer, " " .. arg["var"] .. " [" .. arg["var"] .. "...]")
	else
		local temp1 = 1
		while temp1 <= temp do
			pushCdr_21_1(buffer, " " .. arg["var"])
			temp1 = temp1 + 1
		end
		return nil
	end
end
usage_21_1 = function(spec, name)
	if not name then
		name = nth1(arg1, 0) or (arg1[-1] or "?")
	end
	local usage = list1("usage: ", name)
	local temp = spec["opt"]
	local temp1 = n1(temp)
	local temp2 = 1
	while temp2 <= temp1 do
		local arg = temp[temp2]
		pushCdr_21_1(usage, " [" .. car1(arg["names"]))
		usageNarg_21_1(usage, arg)
		pushCdr_21_1(usage, "]")
		temp2 = temp2 + 1
	end
	local temp = spec["pos"]
	local temp1 = n1(temp)
	local temp2 = 1
	while temp2 <= temp1 do
		usageNarg_21_1(usage, (temp[temp2]))
		temp2 = temp2 + 1
	end
	return print1(concat1(usage))
end
helpArgs_21_1 = function(pos, opt, format)
	if (empty_3f_1(pos) and empty_3f_1(opt)) then
		return nil
	else
		print1()
		local temp = n1(pos)
		local temp1 = 1
		while temp1 <= temp do
			local arg = pos[temp1]
			print1(format1(format, arg["var"], arg["help"]))
			temp1 = temp1 + 1
		end
		local temp = n1(opt)
		local temp1 = 1
		while temp1 <= temp do
			local arg = opt[temp1]
			print1(format1(format, concat1(arg["names"], ", "), arg["help"]))
			temp1 = temp1 + 1
		end
		return nil
	end
end
help_21_1 = function(spec, name)
	if not name then
		name = nth1(arg1, 0) or (arg1[-1] or "?")
	end
	usage_21_1(spec, name)
	if spec["desc"] then
		print1()
		print1(spec["desc"])
	end
	local max = 0
	local temp = spec["pos"]
	local temp1 = n1(temp)
	local temp2 = 1
	while temp2 <= temp1 do
		local len = n1(temp[temp2]["var"])
		if len > max then
			max = len
		end
		temp2 = temp2 + 1
	end
	local temp = spec["opt"]
	local temp1 = n1(temp)
	local temp2 = 1
	while temp2 <= temp1 do
		local len = n1(concat1(temp[temp2]["names"], ", "))
		if len > max then
			max = len
		end
		temp2 = temp2 + 1
	end
	local fmt = " %-" .. tostring1(max + 1) .. "s %s"
	helpArgs_21_1(first1(partition1(function(x)
		return x["cat"] == nil
	end, (spec["pos"]))), first1(partition1(function(x)
		return x["cat"] == nil
	end, (spec["opt"]))), fmt)
	local temp = spec["cats"]
	local temp1 = n1(temp)
	local temp2 = 1
	while temp2 <= temp1 do
		local cat = temp[temp2]
		print1()
		print1(coloured1("4", cat["name"]))
		local desc = cat["desc"]
		if desc then
			print1(desc)
		end
		helpArgs_21_1(first1(partition1(function(x)
			return x["cat"] == cat["id"]
		end, (spec["pos"]))), first1(partition1(function(x)
			return x["cat"] == cat["id"]
		end, (spec["opt"]))), fmt)
		temp2 = temp2 + 1
	end
	return nil
end
matcher1 = function(pattern)
	return function(x)
		local res = list1(match1(x, pattern))
		if car1(res) == nil then
			return nil
		else
			return res
		end
	end
end
parse_21_1 = function(spec, args)
	if not args then
		args = arg1
	end
	local result, pos, posIdx, idx, len, usage_21_ = {}, spec["pos"], 1, 1, n1(args), function(msg)
		usage_21_1(spec, (nth1(args, 0)))
		print1(msg)
		return exit_21_1(1)
	end
	local readArgs = function(key, arg)
		local temp = arg["narg"]
		if temp == "+" then
			idx = idx + 1
			local elem = nth1(args, idx)
			if elem == nil then
				local msg = "Expected " .. arg["var"] .. " after --" .. key .. ", got nothing"
				usage_21_1(spec, (nth1(args, 0)))
				print1(msg)
				exit_21_1(1)
			elseif not arg["all"] and find1(elem, "^%-") then
				local msg = "Expected " .. arg["var"] .. " after --" .. key .. ", got " .. nth1(args, idx)
				usage_21_1(spec, (nth1(args, 0)))
				print1(msg)
				exit_21_1(1)
			else
				arg["action"](arg, result, elem, usage_21_)
			end
			local running = true
			while running do
				idx = idx + 1
				local elem = nth1(args, idx)
				if elem == nil then
					running = false
				elseif not arg["all"] and find1(elem, "^%-") then
					running = false
				else
					arg["action"](arg, result, elem, usage_21_)
				end
			end
			return nil
		elseif temp == "*" then
			local running = true
			while running do
				idx = idx + 1
				local elem = nth1(args, idx)
				if elem == nil then
					running = false
				elseif not arg["all"] and find1(elem, "^%-") then
					running = false
				else
					arg["action"](arg, result, elem, usage_21_)
				end
			end
			return nil
		elseif temp == "?" then
			idx = idx + 1
			local elem = nth1(args, idx)
			if elem == nil or not arg["all"] and find1(elem, "^%-") then
				return arg["action"](arg, result, arg["value"])
			else
				idx = idx + 1
				return arg["action"](arg, result, elem, usage_21_)
			end
		elseif temp == 0 then
			idx = idx + 1
			local value = arg["value"]
			return arg["action"](arg, result, value, usage_21_)
		else
			local temp1 = 1
			while temp1 <= temp do
				idx = idx + 1
				local elem = nth1(args, idx)
				if elem == nil then
					local msg = "Expected " .. temp .. " args for " .. key .. ", got " .. temp1 - 1
					usage_21_1(spec, (nth1(args, 0)))
					print1(msg)
					exit_21_1(1)
				elseif not arg["all"] and find1(elem, "^%-") then
					local msg = "Expected " .. temp .. " for " .. key .. ", got " .. temp1 - 1
					usage_21_1(spec, (nth1(args, 0)))
					print1(msg)
					exit_21_1(1)
				else
					arg["action"](arg, result, elem, usage_21_)
				end
				temp1 = temp1 + 1
			end
			idx = idx + 1
			return nil
		end
	end
	while idx <= len do
		local temp = nth1(args, idx)
		local temp1
		local temp2 = matcher1("^%-%-([^=]+)=(.+)$")(temp)
		temp1 = type1(temp2) == "list" and (n1(temp2) >= 2 and (n1(temp2) <= 2 and true))
		if temp1 then
			local key, val = nth1(matcher1("^%-%-([^=]+)=(.+)$")(temp), 1), nth1(matcher1("^%-%-([^=]+)=(.+)$")(temp), 2)
			local arg = spec["opt-map"][key]
			if arg == nil then
				local msg = "Unknown argument " .. key .. " in " .. nth1(args, idx)
				usage_21_1(spec, (nth1(args, 0)))
				print1(msg)
				exit_21_1(1)
			elseif not arg["many"] and nil ~= result[arg["name"]] then
				local msg = "Too may values for " .. key .. " in " .. nth1(args, idx)
				usage_21_1(spec, (nth1(args, 0)))
				print1(msg)
				exit_21_1(1)
			else
				local narg = arg["narg"]
				if number_3f_1(narg) and narg ~= 1 then
					local msg = "Expected " .. tostring1(narg) .. " values, got 1 in " .. nth1(args, idx)
					usage_21_1(spec, (nth1(args, 0)))
					print1(msg)
					exit_21_1(1)
				end
				arg["action"](arg, result, val, usage_21_)
			end
			idx = idx + 1
		else
			local temp1
			local temp2 = matcher1("^%-%-(.*)$")(temp)
			temp1 = type1(temp2) == "list" and (n1(temp2) >= 1 and (n1(temp2) <= 1 and true))
			if temp1 then
				local key = nth1(matcher1("^%-%-(.*)$")(temp), 1)
				local arg = spec["opt-map"][key]
				if arg == nil then
					local msg = "Unknown argument " .. key .. " in " .. nth1(args, idx)
					usage_21_1(spec, (nth1(args, 0)))
					print1(msg)
					exit_21_1(1)
				elseif not arg["many"] and nil ~= result[arg["name"]] then
					local msg = "Too may values for " .. key .. " in " .. nth1(args, idx)
					usage_21_1(spec, (nth1(args, 0)))
					print1(msg)
					exit_21_1(1)
				else
					readArgs(key, arg)
				end
			else
				local temp1
				local temp2 = matcher1("^%-(.+)$")(temp)
				temp1 = type1(temp2) == "list" and (n1(temp2) >= 1 and (n1(temp2) <= 1 and true))
				if temp1 then
					local flags, i = nth1(matcher1("^%-(.+)$")(temp), 1), 1
					local s = n1(flags)
					while i <= s do
						local key
						local x = i
						key = sub1(flags, x, x)
						local arg = spec["flag-map"][key]
						if arg == nil then
							local msg = "Unknown flag " .. key .. " in " .. nth1(args, idx)
							usage_21_1(spec, (nth1(args, 0)))
							print1(msg)
							exit_21_1(1)
						elseif not arg["many"] and nil ~= result[arg["name"]] then
							local msg = "Too many occurances of " .. key .. " in " .. nth1(args, idx)
							usage_21_1(spec, (nth1(args, 0)))
							print1(msg)
							exit_21_1(1)
						else
							local narg = arg["narg"]
							if i == s then
								readArgs(key, arg)
							elseif narg == 0 then
								local value = arg["value"]
								arg["action"](arg, result, value, usage_21_)
							else
								local value = sub1(flags, i + 1)
								arg["action"](arg, result, value, usage_21_)
								i = s + 1
								idx = idx + 1
							end
						end
						i = i + 1
					end
				else
					local arg = nth1(pos, posIdx)
					if arg then
						idx = idx - 1
						readArgs(arg["var"], arg)
						if not arg["many"] then
							posIdx = posIdx + 1
						end
					else
						local msg = "Unknown argument " .. any1
						usage_21_1(spec, (nth1(args, 0)))
						print1(msg)
						exit_21_1(1)
					end
				end
			end
		end
	end
	local temp = spec["opt"]
	local temp1 = n1(temp)
	local temp2 = 1
	while temp2 <= temp1 do
		local arg = temp[temp2]
		if result[arg["name"]] == nil then
			result[arg["name"]] = arg["default"]
		end
		temp2 = temp2 + 1
	end
	local temp = spec["pos"]
	local temp1 = n1(temp)
	local temp2 = 1
	while temp2 <= temp1 do
		local arg = temp[temp2]
		if result[arg["name"]] == nil then
			result[arg["name"]] = arg["default"]
		end
		temp2 = temp2 + 1
	end
	return result
end
formatRange1 = function(range)
	if range["finish"] then
		return format1("%s:[%s .. %s]", range["name"], (function()
			local pos = range["start"]
			return pos["line"] .. ":" .. pos["column"]
		end)(), (function()
			local pos = range["finish"]
			return pos["line"] .. ":" .. pos["column"]
		end)())
	else
		return format1("%s:[%s]", range["name"], (function()
			local pos = range["start"]
			return pos["line"] .. ":" .. pos["column"]
		end)())
	end
end
formatNode1 = function(node)
	if node["range"] and node["contents"] then
		return format1("%s (%s)", formatRange1(node["range"]), quoted1(node["contents"]))
	elseif node["range"] then
		return formatRange1(node["range"])
	elseif node["owner"] then
		local owner = node["owner"]
		if owner["var"] then
			return format1("macro expansion of %s (%s)", owner["var"]["name"], formatNode1(owner["node"]))
		else
			return format1("unquote expansion (%s)", formatNode1(owner["node"]))
		end
	elseif node["start"] and node["finish"] then
		return formatRange1(node)
	else
		return "?"
	end
end
getSource1 = function(node)
	local result = nil
	while node and not result do
		result = node["range"]
		node = node["parent"]
	end
	return result
end
putNodeError_21_1 = function(logger, msg, node, explain, ...)
	local lines = _pack(...) lines.tag = "list"
	return self2(logger, "put-node-error!", msg, node, explain, lines)
end
putNodeWarning_21_1 = function(logger, msg, node, explain, ...)
	local lines = _pack(...) lines.tag = "list"
	return self2(logger, "put-node-warning!", msg, node, explain, lines)
end
doNodeError_21_1 = function(logger, msg, node, explain, ...)
	local lines = _pack(...) lines.tag = "list"
	self2(logger, "put-node-error!", msg, node, explain, lines)
	return error1(match1(msg, "^([^\n]+)\n") or msg, 0)
end
gethook1 = debug.gethook
getinfo1 = debug.getinfo
sethook1 = debug.sethook
traceback1 = debug.traceback
sentinel1 = {}
doNodeError_21_2 = function(logger, msg, node, explain, ...)
	local lines = _pack(...) lines.tag = "list"
	apply1(putNodeError_21_1, logger, msg, node, explain, lines)
	return error1(sentinel1, 0)
end
traceback2 = function(err)
	if err == sentinel1 then
		return err
	elseif string_3f_1(err) then
		return traceback1(err, 2)
	else
		return traceback1(pretty1(err), 2)
	end
end
create2 = coroutine.create
resume1 = coroutine.resume
status1 = coroutine.status
yield1 = coroutine.yield
child1 = function(parent)
	return {["parent"]=parent, ["variables"]={}, ["exported"]={}, ["prefix"]=(function()
		if parent then
			return parent["prefix"]
		else
			return ""
		end
	end)(), ["unique-prefix"]=(function()
		if parent then
			return parent["unique-prefix"]
		else
			return ""
		end
	end)()}
end
get1 = function(scope, name)
	while true do
		if scope then
			local var = scope["variables"][name]
			if var then
				return var
			else
				scope = scope["parent"]
			end
		else
			return nil
		end
	end
end
getAlways_21_1 = function(scope, name, user)
	return get1(scope, name) or yield1({["tag"]="define", ["name"]=name, ["node"]=user, ["scope"]=scope})
end
kinds1 = {["defined"]=true, ["native"]=true, ["macro"]=true, ["arg"]=true, ["builtin"]=true}
add_21_1 = function(scope, name, kind, node)
	local temp = type1(name)
	if temp ~= "string" then
		error1(format1("bad argument %s (expected %s, got %s)", "name", "string", temp), 2)
	end
	local temp = type1(kind)
	if temp ~= "string" then
		error1(format1("bad argument %s (expected %s, got %s)", "kind", "string", temp), 2)
	end
	if not kinds1[kind] then
		error1("Unknown kind " .. quoted1(kind))
	end
	if scope["variables"][name] then
		error1("Previous declaration of " .. quoted1(name))
	end
	if name == "_" and scope["is-root"] then
		error1("Cannot declare \"_\" as a top level definition", 0)
	end
	local var = {["tag"]="var", ["kind"]=kind, ["name"]=name, ["full-name"]=scope["prefix"] .. name, ["unique-name"]=scope["unique-prefix"] .. name, ["scope"]=scope, ["const"]=kind ~= "arg", ["node"]=node}
	if not (name == "_") then
		scope["variables"][name] = var
		scope["exported"][name] = var
	end
	return var
end
addVerbose_21_1 = function(scope, name, kind, node, logger)
	local temp = type1(name)
	if temp ~= "string" then
		error1(format1("bad argument %s (expected %s, got %s)", "name", "string", temp), 2)
	end
	local temp = type1(kind)
	if temp ~= "string" then
		error1(format1("bad argument %s (expected %s, got %s)", "kind", "string", temp), 2)
	end
	if not kinds1[kind] then
		error1("Unknown kind " .. quoted1(kind))
	end
	local previous = scope["variables"][name]
	if previous then
		doNodeError_21_2(logger, "Previous declaration of " .. quoted1(name), node, nil, getSource1(node), "new definition here", getSource1(previous["node"]), "old definition here")
	end
	if name == "_" and scope["is-root"] then
		doNodeError_21_2(logger, "Cannot declare \"_\" as a top level definition", node, nil, getSource1(node), "declared here")
	end
	return add_21_1(scope, name, kind, node)
end
import_21_1 = function(scope, name, var, export)
	if not var then
		error1("var is nil", 0)
	end
	if scope["variables"][name] and scope["variables"][name] ~= var then
		error1("Previous declaration of " .. name, 0)
	end
	scope["variables"][name] = var
	if export then
		scope["exported"][name] = var
	end
	return var
end
importVerbose_21_1 = function(scope, name, var, node, export, logger)
	if not var then
		error1("var is nil", 0)
	end
	if scope["variables"][name] and scope["variables"][name] ~= var then
		doNodeError_21_2(logger, "Previous declaration of " .. name, node, nil, getSource1(node), "imported here", getSource1(var["node"]), "new definition here", getSource1(scope["variables"][name]["node"]), "old definition here")
	end
	return import_21_1(scope, name, var, export)
end
local scope = child1()
scope["builtin"] = true
rootScope1 = scope
builtins1 = {}
builtinVars1 = {}
local temp = {tag="list", n=12, "define", "define-macro", "define-native", "lambda", "set!", "cond", "import", "struct-literal", "quote", "syntax-quote", "unquote", "unquote-splice"}
local temp1 = n1(temp)
local temp2 = 1
while temp2 <= temp1 do
	local symbol = temp[temp2]
	local var = add_21_1(rootScope1, symbol, "builtin", nil)
	import_21_1(rootScope1, "builtin/" .. symbol, var, true)
	builtins1[symbol] = var
	temp2 = temp2 + 1
end
local temp = {tag="list", n=3, "nil", "true", "false"}
local temp1 = n1(temp)
local temp2 = 1
while temp2 <= temp1 do
	local symbol = temp[temp2]
	local var = add_21_1(rootScope1, symbol, "defined", nil)
	import_21_1(rootScope1, "builtin/" .. symbol, var, true)
	builtinVars1[var] = true
	builtins1[symbol] = var
	temp2 = temp2 + 1
end
builtin_3f_1 = function(node, name)
	return type1(node) == "symbol" and node["var"] == builtins1[name]
end
sideEffect_3f_1 = function(node)
	local tag = type1(node)
	if tag == "number" or tag == "string" or tag == "key" or tag == "symbol" then
		return false
	elseif tag == "list" then
		local head = car1(node)
		local temp = type1(head) ~= "symbol"
		if temp then
			return temp
		else
			local var = head["var"]
			if var["kind"] ~= "builtin" then
				return true
			elseif var == builtins1["lambda"] then
				return false
			elseif var == builtins1["quote"] then
				return false
			elseif var == builtins1["struct-literal"] then
				return n1(node) ~= 1
			else
				return true
			end
		end
	else
		_error("unmatched item")
	end
end
constant_3f_1 = function(node)
	return string_3f_1(node) or (number_3f_1(node) or type1(node) == "key")
end
urn_2d3e_val1 = function(node)
	if string_3f_1(node) then
		return node["value"]
	elseif number_3f_1(node) then
		return node["value"]
	elseif type1(node) == "key" then
		return node["value"]
	else
		_error("unmatched item")
	end
end
val_2d3e_urn1 = function(val)
	local ty = type_23_1(val)
	if ty == "string" then
		return {["tag"]="string", ["value"]=val}
	elseif ty == "number" then
		return {["tag"]="number", ["value"]=val}
	elseif ty == "nil" then
		return {["tag"]="symbol", ["contents"]="nil", ["var"]=builtins1["nil"]}
	elseif ty == "boolean" then
		return {["tag"]="symbol", ["contents"]=tostring1(val), ["var"]=builtins1[tostring1(val)]}
	else
		return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(ty) .. ", but none matched.\n" .. "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"nil\"`\n  Tried: `\"boolean\"`")
	end
end
urn_2d3e_bool1 = function(node)
	if string_3f_1(node) or type1(node) == "key" or number_3f_1(node) then
		return true
	elseif type1(node) == "symbol" then
		if builtins1["true"] == node["var"] then
			return true
		elseif builtins1["false"] == node["var"] then
			return false
		elseif builtins1["nil"] == node["var"] then
			return false
		else
			return nil
		end
	else
		return nil
	end
end
makeProgn1 = function(body)
	return {tag="list", n=1, (function()
		local _offset, _result, _temp = 0, {tag="list"}
		_result[1 + _offset] = (function()
			local var = builtins1["lambda"]
			return {["tag"]="symbol", ["contents"]=var["name"], ["var"]=var}
		end)()
		_result[2 + _offset] = {tag="list", n=0}
		_temp = body
		for _c = 1, _temp.n do _result[2 + _c + _offset] = _temp[_c] end
		_offset = _offset + _temp.n
		_result.n = _offset + 2
		return _result
	end)()
	}
end
makeSymbol1 = function(var)
	return {["tag"]="symbol", ["contents"]=var["name"], ["var"]=var}
end
symbol_2d3e_var1 = function(state, symb)
	local var = symb["var"]
	if string_3f_1(var) then
		return state["variables"][var]
	else
		return var
	end
end
local temp = builtins1["nil"]
makeNil1 = function()
	return {["tag"]="symbol", ["contents"]=temp["name"], ["var"]=temp}
end
simpleBinding_3f_1 = function(node)
	local temp = type1(node) == "list"
	if temp then
		local lam = car1(node)
		return type1(lam) == "list" and (builtin_3f_1(car1(lam), "lambda") and all1(function(x)
			return not x["var"]["is-variadic"]
		end, nth1(lam, 2)))
	else
		return temp
	end
end
singleReturn_3f_1 = function(node)
	local temp = not (type1(node) == "list")
	if temp then
		return temp
	else
		local head = car1(node)
		if type1(head) == "symbol" then
			local func = head["var"]
			if func["kind"] ~= "builtin" then
				return false
			elseif func == builtins1["lambda"] then
				return true
			elseif func == builtins1["struct-literal"] then
				return true
			elseif func == builtins1["quote"] then
				return true
			elseif func == builtins1["syntax-quote"] then
				return true
			else
				return false
			end
		else
			return false
		end
	end
end
fastAll1 = function(fn, li, i)
	while true do
		if i > n1(li) then
			return true
		elseif fn(nth1(li, i)) then
			i = i + 1
		else
			return false
		end
	end
end
fastAny1 = function(fn, li, i)
	while true do
		if i > n1(li) then
			return false
		elseif fn(nth1(li, i)) then
			return true
		else
			i = i + 1
		end
	end
end
zipArgs1 = function(args, argsStart, vals, valsStart)
	local res, an, vn, _ = {tag="list", n=0}, n1(args), n1(vals)
	local ai, vi = argsStart, valsStart
	while true do
		if ai > an and vi > vn then
			return res
		else
			local arg = args[ai]
			if not arg then
				pushCdr_21_1(res, list1({tag="list", n=0}, list1(nth1(vals, vi))))
				vi = vi + 1
			elseif vi > vn then
				pushCdr_21_1(res, list1(list1(arg), {tag="list", n=0}))
				ai = ai + 1
			elseif arg["var"]["is-variadic"] then
				if singleReturn_3f_1(nth1(vals, vn)) then
					local vEnd = vn - (an - ai)
					if vEnd < vi then
						vEnd = vi - 1
					end
					pushCdr_21_1(res, list1(list1(arg), slice1(vals, vi, vEnd)))
					ai, vi = ai + 1, vEnd + 1
				else
					return pushCdr_21_1(res, list1(slice1(args, ai), slice1(vals, vi)))
				end
			elseif vi < vn or singleReturn_3f_1(nth1(vals, vi)) then
				pushCdr_21_1(res, list1(list1(arg), list1(nth1(vals, vi))))
				ai, vi = ai + 1, vi + 1
			else
				return pushCdr_21_1(res, list1(slice1(args, ai), list1(nth1(vals, vi))))
			end
		end
	end
end
startTimer_21_1 = function(timer, name, level)
	local instance = timer["timers"][name]
	if not instance then
		instance = {["name"]=name, ["level"]=level or 1, ["running"]=false, ["total"]=0}
		timer["timers"][name] = instance
	end
	if instance["running"] then
		error1("Timer " .. name .. " is already running")
	end
	instance["running"] = true
	instance["start"] = clock1()
	return nil
end
pauseTimer_21_1 = function(timer, name)
	local instance = timer["timers"][name]
	if not instance then
		error1("Timer " .. name .. " does not exist")
	end
	if not instance["running"] then
		error1("Timer " .. name .. " is not running")
	end
	instance["running"] = false
	instance["total"] = (clock1() - instance["start"]) + instance["total"]
	return nil
end
stopTimer_21_1 = function(timer, name)
	local instance = timer["timers"][name]
	if not instance then
		error1("Timer " .. name .. " does not exist")
	end
	if not instance["running"] then
		error1("Timer " .. name .. " is not running")
	end
	timer["timers"][name] = nil
	instance["total"] = (clock1() - instance["start"]) + instance["total"]
	return timer["callback"](instance["name"], instance["total"], instance["level"])
end
passEnabled_3f_1 = function(pass, options)
	local override = options["override"]
	if override[pass["name"]] == true then
		return true
	elseif override[pass["name"]] == false then
		return false
	elseif any1(function(cat)
		return override[cat] == true
	end, pass["cat"]) then
		return true
	elseif any1(function(cat)
		return override[cat] == false
	end, pass["cat"]) then
		return false
	else
		return pass["on"] ~= false and options["level"] >= (pass["level"] or 1)
	end
end
filterPasses1 = function(passes, options)
	local res = {}
	local temp, v = next1(passes)
	while temp ~= nil do
		res[temp] = first1(partition1(function(temp1)
			return passEnabled_3f_1(temp1, options)
		end, v))
		temp, v = next1(passes, temp)
	end
	return res
end
runPass1 = function(pass, options, tracker, ...)
	local args = _pack(...) args.tag = "list"
	local ptracker, name = {["changed"]=0}, "[" .. concat1(pass["cat"], " ") .. "] " .. pass["name"]
	startTimer_21_1(options["timer"], name, 2)
	pass["run"](ptracker, options, unpack1(args, 1, n1(args)))
	stopTimer_21_1(options["timer"], name)
	if options["track"] then
		self2(options["logger"], "put-verbose!", (sprintf1("%s made %d changes", name, ptracker["changed"])))
	end
	if tracker then
		tracker["changed"] = tracker["changed"] + ptracker["changed"]
	end
	return ptracker["changed"] > 0
end
getVar1 = function(state, var)
	local vars = state["usage-vars"]
	local entry = vars[var]
	if not entry then
		entry = {["var"]=var, ["usages"]={tag="list", n=0}, ["soft"]={tag="list", n=0}, ["defs"]={tag="list", n=0}, ["active"]=false}
		vars[var] = entry
	end
	return entry
end
addUsage_21_1 = function(state, var, node)
	local varMeta = getVar1(state, var)
	pushCdr_21_1(varMeta["usages"], node)
	varMeta["active"] = true
	return nil
end
removeUsage_21_1 = function(state, var, node)
	local varMeta = getVar1(state, var)
	local users = varMeta["usages"]
	local temp = n1(users)
	while temp >= 1 do
		if nth1(users, temp) == node then
			removeNth_21_1(users, temp)
			if empty_3f_1(users) then
				varMeta["active"] = false
			end
		end
		temp = temp + -1
	end
	return nil
end
addDefinition_21_1 = function(state, var, node, kind, value)
	return pushCdr_21_1(getVar1(state, var)["defs"], {["tag"]=kind, ["node"]=node, ["value"]=value})
end
replaceDefinition_21_1 = function(state, var, oldValue, newKind, newValue)
	local varMeta = state["usage-vars"][var]
	if varMeta then
		local temp = varMeta["defs"]
		local temp1 = n1(temp)
		local temp2 = 1
		while temp2 <= temp1 do
			local def = temp[temp2]
			if def["value"] == oldValue then
				def["tag"] = newKind
				def["value"] = newValue
			end
			temp2 = temp2 + 1
		end
		return nil
	else
		return nil
	end
end
populateDefinitions1 = function(state, nodes, visit_3f_)
	if not visit_3f_ then
		visit_3f_ = function()
			return true
		end
	end
	local queue, lazyDefs, addCheckedUsage_21_, addLazyDef_21_, visitQuote, visitNode = {tag="list", n=0}, {}
	addCheckedUsage_21_ = function(var, user)
		if not getVar1(state, var)["active"] then
			local defs = lazyDefs[var]
			if defs then
				local temp = n1(defs)
				local temp1 = 1
				while temp1 <= temp do
					pushCdr_21_1(queue, (defs[temp1]))
					temp1 = temp1 + 1
				end
			end
		end
		return addUsage_21_1(state, var, user)
	end
	addLazyDef_21_ = function(var, node)
		if getVar1(state, var)["active"] then
			return true
		else
			local defs = lazyDefs[var]
			if not defs then
				defs = {tag="list", n=0}
				lazyDefs[var] = defs
			end
			pushCdr_21_1(defs, node)
			return false
		end
	end
	visitQuote = function(node, level)
		while true do
			if level == 0 then
				return visitNode(node)
			else
				local temp = type1(node)
				if temp == "string" then
					return nil
				elseif temp == "number" then
					return nil
				elseif temp == "key" then
					return nil
				elseif temp == "symbol" then
					local var = node["var"]
					if var then
						return pushCdr_21_1(getVar1(state, var)["soft"], node)
					else
						return nil
					end
				elseif temp == "list" then
					local first = nth1(node, 1)
					if type1(first) ~= "symbol" then
						local temp1 = n1(node)
						local temp2 = 1
						while temp2 <= temp1 do
							local sub = node[temp2]
							visitQuote(sub, level)
							temp2 = temp2 + 1
						end
						return nil
					elseif first["contents"] == "unquote" or first["contents"] == "unquote-splice" then
						node, level = nth1(node, 2), level - 1
					elseif first["contents"] == "syntax-quote" then
						node, level = nth1(node, 2), level + 1
					else
						local temp1 = n1(node)
						local temp2 = 1
						while temp2 <= temp1 do
							local sub = node[temp2]
							visitQuote(sub, level)
							temp2 = temp2 + 1
						end
						return nil
					end
				else
					return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"key\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`")
				end
			end
		end
	end
	visitNode = function(node)
		while true do
			local temp = type1(node)
			if temp == "string" then
				return nil
			elseif temp == "number" then
				return nil
			elseif temp == "key" then
				return nil
			elseif temp == "symbol" then
				return addCheckedUsage_21_(node["var"], node)
			elseif temp == "list" then
				local head = car1(node)
				local temp1 = type1(head)
				if temp1 == "symbol" then
					local func = head["var"]
					if func["kind"] ~= "builtin" then
						local temp2 = n1(node)
						local temp3 = 1
						while temp3 <= temp2 do
							visitNode(nth1(node, temp3))
							temp3 = temp3 + 1
						end
						return nil
					elseif func == builtins1["lambda"] then
						local temp2 = nth1(node, 2)
						local temp3 = n1(temp2)
						local temp4 = 1
						while temp4 <= temp3 do
							local arg = temp2[temp4]
							addDefinition_21_1(state, arg["var"], arg, "var", arg["var"])
							temp4 = temp4 + 1
						end
						local temp2 = n1(node)
						local temp3 = 3
						while temp3 <= temp2 do
							visitNode(nth1(node, temp3))
							temp3 = temp3 + 1
						end
						return nil
					elseif func == builtins1["define-native"] then
						return addDefinition_21_1(state, node["def-var"], node, "var", node["def-var"])
					elseif func == builtins1["set!"] then
						local var, val = nth1(node, 2)["var"], nth1(node, 3)
						addDefinition_21_1(state, var, node, "val", val)
						if visit_3f_(val, var, node) or addLazyDef_21_(var, val) then
							node = val
						else
							return nil
						end
					elseif func == builtins1["define"] or func == builtins1["define-macro"] then
						local var, val = node["def-var"], last1(node)
						addDefinition_21_1(state, var, node, "val", val)
						if visit_3f_(val, var, node) or addLazyDef_21_(var, val) then
							node = val
						else
							return nil
						end
					elseif func == builtins1["cond"] then
						local temp2 = n1(node)
						local temp3 = 2
						while temp3 <= temp2 do
							local temp4 = nth1(node, temp3)
							local temp5 = n1(temp4)
							local temp6 = 1
							while temp6 <= temp5 do
								local child = temp4[temp6]
								visitNode(child)
								temp6 = temp6 + 1
							end
							temp3 = temp3 + 1
						end
						return nil
					elseif func == builtins1["quote"] then
						return nil
					elseif func == builtins1["syntax-quote"] then
						return visitQuote(nth1(node, 2), 1)
					elseif func == builtins1["import"] then
						return nil
					elseif func == builtins1["struct-literal"] then
						local temp2 = n1(node)
						local temp3 = 2
						while temp3 <= temp2 do
							visitNode(nth1(node, temp3))
							temp3 = temp3 + 1
						end
						return nil
					else
						return error1("Unhandled variable " .. func["name"], 0)
					end
				elseif temp1 == "list" then
					if builtin_3f_1(car1(head), "lambda") then
						local temp2 = zipArgs1(cadar1(node), 1, node, 2)
						local temp3 = n1(temp2)
						local temp4 = 1
						while temp4 <= temp3 do
							local zipped = temp2[temp4]
							local args, vals = car1(zipped), cadr1(zipped)
							if n1(args) == 1 and (n1(vals) <= 1 and not car1(args)["var"]["is-variadic"]) then
								local var, val = car1(args)["var"], car1(vals) or makeNil1()
								addDefinition_21_1(state, var, car1(args), "val", val)
								if visit_3f_(val, var, node) or addLazyDef_21_(var, val) then
									visitNode(val)
								end
							else
								local temp5 = n1(args)
								local temp6 = 1
								while temp6 <= temp5 do
									local arg = args[temp6]
									addDefinition_21_1(state, arg["var"], arg, "var", arg["var"])
									temp6 = temp6 + 1
								end
								local temp5 = n1(vals)
								local temp6 = 1
								while temp6 <= temp5 do
									local val = vals[temp6]
									visitNode(val)
									temp6 = temp6 + 1
								end
							end
							temp4 = temp4 + 1
						end
						local temp2 = n1(head)
						local temp3 = 3
						while temp3 <= temp2 do
							visitNode(nth1(head, temp3))
							temp3 = temp3 + 1
						end
						return nil
					else
						local temp2 = n1(node)
						local temp3 = 1
						while temp3 <= temp2 do
							visitNode(nth1(node, temp3))
							temp3 = temp3 + 1
						end
						return nil
					end
				else
					local temp2 = n1(node)
					local temp3 = 1
					while temp3 <= temp2 do
						visitNode(nth1(node, temp3))
						temp3 = temp3 + 1
					end
					return nil
				end
			else
				return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"key\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`")
			end
		end
	end
	local temp = n1(nodes)
	local temp1 = 1
	while temp1 <= temp do
		pushCdr_21_1(queue, (nodes[temp1]))
		temp1 = temp1 + 1
	end
	while n1(queue) > 0 do
		visitNode(popLast_21_1(queue))
	end
	return nil
end
visitLazyDefinition_3f_1 = function(val, _5f_, node)
	return node["def-var"] == nil and not (type1(val) == "list" and builtin_3f_1(car1(val), "lambda"))
end
visitEagerExported_3f_1 = function(val, _5f_, node)
	local def = node["def-var"]
	return def and (def["kind"] == "macro" or def["scope"]["exported"][def["name"]]) or (not (type1(val) == "list") or not builtin_3f_1(car1(val), "lambda"))
end
tagUsage1 = {["name"]="tag-usage", ["help"]="Gathers usage and definition data for all expressions in NODES, storing it in LOOKUP.", ["cat"]={tag="list", n=2, "tag", "usage"}, ["run"]=function(temp, state, nodes, lookup, visit_3f_)
	local visit_3f_1
	if visit_3f_ == nil then
		visit_3f_1 = visitLazyDefinition_3f_1
	else
		visit_3f_1 = visit_3f_
	end
	lookup["usage-vars"] = {}
	return populateDefinitions1(lookup, nodes, visit_3f_1)
end}
transform1 = function(nodes, transformers, lookup)
	local pre, post, preBlock, postBlock, preBind, postBind, transformQuote, transformNode = transformers["pre"], transformers["post"], transformers["pre-block"], transformers["post-block"], transformers["pre-bind"], transformers["post-bind"]
	transformQuote = function(node, level)
		if level == 0 then
			return transformNode(node)
		else
			local tag = type1(node)
			if tag == "string" or tag == "number" or tag == "key" or tag == "symbol" then
			elseif tag == "list" then
				local first = nth1(node, 1)
				if first and type1(first) == "symbol" then
					if first["contents"] == "unquote" or first["contents"] == "unquote-splice" then
						node[2] = transformQuote(nth1(node, 2), level - 1)
					elseif first["contents"] == "syntax-quote" then
						node[2] = transformQuote(nth1(node, 2), level + 1)
					else
						local temp = n1(node)
						local temp1 = 1
						while temp1 <= temp do
							node[temp1] = transformQuote(nth1(node, temp1), level)
							temp1 = temp1 + 1
						end
					end
				else
					local temp = n1(node)
					local temp1 = 1
					while temp1 <= temp do
						node[temp1] = transformQuote(nth1(node, temp1), level)
						temp1 = temp1 + 1
					end
				end
			else
				error1("Unknown tag " .. tag)
			end
			return node
		end
	end
	transformNode = function(node)
		local temp = n1(pre)
		local temp1 = 1
		while temp1 <= temp do
			node = pre[temp1](node)
			temp1 = temp1 + 1
		end
		local temp = type1(node)
		if temp == "string" then
		elseif temp == "number" then
		elseif temp == "key" then
		elseif temp == "symbol" then
		elseif temp == "list" then
			local head = car1(node)
			local temp1 = type1(head)
			if temp1 == "symbol" then
				local func = head["var"]
				if func["kind"] ~= "builtin" then
					local temp2 = n1(node)
					local temp3 = 1
					while temp3 <= temp2 do
						node[temp3] = transformNode(nth1(node, temp3))
						temp3 = temp3 + 1
					end
				elseif func == builtins1["lambda"] then
					local temp2 = n1(preBlock)
					local temp3 = 1
					while temp3 <= temp2 do
						preBlock[temp3](node, 3)
						temp3 = temp3 + 1
					end
					local temp2 = n1(node)
					local temp3 = 3
					while temp3 <= temp2 do
						node[temp3] = transformNode(nth1(node, temp3))
						temp3 = temp3 + 1
					end
					local temp2 = n1(postBlock)
					local temp3 = 1
					while temp3 <= temp2 do
						postBlock[temp3](node, 3)
						temp3 = temp3 + 1
					end
				elseif func == builtins1["cond"] then
					local temp2 = n1(node)
					local temp3 = 2
					while temp3 <= temp2 do
						local branch = nth1(node, temp3)
						branch[1] = transformNode(nth1(branch, 1))
						local temp4 = n1(preBlock)
						local temp5 = 1
						while temp5 <= temp4 do
							preBlock[temp5](branch, 2)
							temp5 = temp5 + 1
						end
						local temp4 = n1(branch)
						local temp5 = 2
						while temp5 <= temp4 do
							branch[temp5] = transformNode(nth1(branch, temp5))
							temp5 = temp5 + 1
						end
						local temp4 = n1(postBlock)
						local temp5 = 1
						while temp5 <= temp4 do
							postBlock[temp5](branch, 2)
							temp5 = temp5 + 1
						end
						temp3 = temp3 + 1
					end
				elseif func == builtins1["set!"] then
					local old = nth1(node, 3)
					local new = transformNode(old)
					if old ~= new then
						replaceDefinition_21_1(lookup, nth1(node, 2)["var"], old, "val", new)
						node[3] = new
					end
				elseif func == builtins1["quote"] then
				elseif func == builtins1["syntax-quote"] then
					node[2] = transformQuote(nth1(node, 2), 1)
				elseif func == builtins1["unquote"] or func == builtins1["unquote-splice"] then
					error1("unquote/unquote-splice should never appear head", 0)
				elseif func == builtins1["define"] or func == builtins1["define-macro"] then
					local len = n1(node)
					local old = nth1(node, len)
					local new = transformNode(old)
					if old ~= new then
						replaceDefinition_21_1(lookup, node["def-var"], old, "val", new)
						node[len] = new
					end
				elseif func == builtins1["define-native"] then
				elseif func == builtins1["import"] then
				elseif func == builtins1["struct-literal"] then
					local temp2 = n1(node)
					local temp3 = 1
					while temp3 <= temp2 do
						node[temp3] = transformNode(nth1(node, temp3))
						temp3 = temp3 + 1
					end
				else
					error1("Unknown variable " .. func["name"], 0)
				end
			elseif temp1 == "list" then
				if builtin_3f_1(car1(head), "lambda") then
					local temp2 = n1(preBind)
					local temp3 = 1
					while temp3 <= temp2 do
						preBind[temp3](node)
						temp3 = temp3 + 1
					end
					local valI, temp2 = 2, zipArgs1(nth1(head, 2), 1, node, 2)
					local temp3 = n1(temp2)
					local temp4 = 1
					while temp4 <= temp3 do
						local zipped = temp2[temp4]
						local args, vals = car1(zipped), cadr1(zipped)
						if n1(args) == 1 and (n1(vals) == 1 and not car1(args)["var"]["is-variadic"]) then
							local old = car1(vals)
							local new = transformNode(old)
							if old ~= new then
								replaceDefinition_21_1(lookup, car1(args)["var"], old, "val", new)
								node[valI] = new
							end
							valI = valI + 1
						else
							local temp5 = n1(vals)
							local temp6 = 1
							while temp6 <= temp5 do
								local val = vals[temp6]
								node[valI] = transformNode(val)
								valI = valI + 1
								temp6 = temp6 + 1
							end
						end
						temp4 = temp4 + 1
					end
					local temp2 = n1(preBlock)
					local temp3 = 1
					while temp3 <= temp2 do
						preBlock[temp3](head, 3)
						temp3 = temp3 + 1
					end
					local temp2 = n1(head)
					local temp3 = 3
					while temp3 <= temp2 do
						head[temp3] = transformNode(nth1(head, temp3))
						temp3 = temp3 + 1
					end
					local temp2 = n1(postBlock)
					local temp3 = 1
					while temp3 <= temp2 do
						postBlock[temp3](head, 2)
						temp3 = temp3 + 1
					end
					local temp2 = n1(postBind)
					local temp3 = 1
					while temp3 <= temp2 do
						postBind[temp3](node)
						temp3 = temp3 + 1
					end
				else
					local temp2 = n1(node)
					local temp3 = 1
					while temp3 <= temp2 do
						node[temp3] = transformNode(nth1(node, temp3))
						temp3 = temp3 + 1
					end
				end
			else
				local temp2 = n1(node)
				local temp3 = 1
				while temp3 <= temp2 do
					node[temp3] = transformNode(nth1(node, temp3))
					temp3 = temp3 + 1
				end
			end
		else
			error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"key\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`")
		end
		local temp = n1(post)
		local temp1 = 1
		while temp1 <= temp do
			node = post[temp1](node)
			temp1 = temp1 + 1
		end
		return node
	end
	local temp = n1(preBlock)
	local temp1 = 1
	while temp1 <= temp do
		preBlock[temp1](nodes, 1)
		temp1 = temp1 + 1
	end
	local temp = n1(nodes)
	local temp1 = 1
	while temp1 <= temp do
		nodes[temp1] = transformNode(nth1(nodes, temp1))
		temp1 = temp1 + 1
	end
	local temp = n1(postBlock)
	local temp1 = 1
	while temp1 <= temp do
		postBlock[temp1](nodes, 1)
		temp1 = temp1 + 1
	end
	return nil
end
emptyTransformers1 = function()
	return {["pre"]={tag="list", n=0}, ["pre-block"]={tag="list", n=0}, ["pre-bind"]={tag="list", n=0}, ["post"]={tag="list", n=0}, ["post-block"]={tag="list", n=0}, ["post-bind"]={tag="list", n=0}}
end
transformer1 = {["name"]="transformer", ["help"]="Run the given TRANSFORMERS on the provides NODES with the given\nLOOKUP information.", ["cat"]={tag="list", n=2, "opt", "usage"}, ["run"]=function(temp, state, nodes, lookup, transformers)
	local trackers, transLookup = {tag="list", n=0}, emptyTransformers1()
	local temp1 = n1(transformers)
	local temp2 = 1
	while temp2 <= temp1 do
		local trans, tracker = transformers[temp2], {["changed"]=0}
		local run = trans["run"]
		pushCdr_21_1(trackers, tracker)
		local temp3 = trans["cat"]
		local temp4 = n1(temp3)
		local temp5 = 1
		while temp5 <= temp4 do
			local cat = temp3[temp5]
			local group = match1(cat, "^transform%-(.*)")
			if group then
				if not transLookup[group] then
					error1("Unknown category " .. cat .. " for " .. trans["name"])
				end
				if endsWith_3f_1(group, "-block") then
					pushCdr_21_1(transLookup[group], function(node, start)
						return run(tracker, state, node, start, lookup)
					end)
				else
					pushCdr_21_1(transLookup[group], function(node)
						return run(tracker, state, node, lookup)
					end)
				end
			end
			temp5 = temp5 + 1
		end
		temp2 = temp2 + 1
	end
	transform1(nodes, transLookup, lookup)
	local temp1 = n1(trackers)
	local temp2 = 1
	while temp2 <= temp1 do
		temp["changed"] = temp["changed"] + nth1(trackers, temp2)["changed"]
		if state["track"] then
			self2(state["logger"], "put-verbose!", (sprintf1("%s made %d changes", "[" .. concat1(nth1(transformers, temp2)["cat"], " ") .. "] " .. nth1(transformers, temp2)["name"], nth1(trackers, temp2)["changed"])))
		end
		temp2 = temp2 + 1
	end
	return nil
end}
traverseQuote1 = function(node, visitor, level)
	if level == 0 then
		return traverseNode1(node, visitor)
	else
		local tag = type1(node)
		if tag == "string" or tag == "number" or tag == "key" or tag == "symbol" then
			return node
		elseif tag == "list" then
			local first = nth1(node, 1)
			if type1(first) == "symbol" then
				if first["contents"] == "unquote" or first["contents"] == "unquote-splice" then
					node[2] = traverseQuote1(nth1(node, 2), visitor, level - 1)
					return node
				elseif first["contents"] == "syntax-quote" then
					node[2] = traverseQuote1(nth1(node, 2), visitor, level + 1)
					return node
				else
					local temp = n1(node)
					local temp1 = 1
					while temp1 <= temp do
						node[temp1] = traverseQuote1(nth1(node, temp1), visitor, level)
						temp1 = temp1 + 1
					end
					return node
				end
			else
				local temp = n1(node)
				local temp1 = 1
				while temp1 <= temp do
					node[temp1] = traverseQuote1(nth1(node, temp1), visitor, level)
					temp1 = temp1 + 1
				end
				return node
			end
		elseif error1 then
			return "Unknown tag " .. tag
		else
			_error("unmatched item")
		end
	end
end
traverseNode1 = function(node, visitor)
	local tag = type1(node)
	if tag == "string" or tag == "number" or tag == "key" or tag == "symbol" then
		return visitor(node, visitor)
	elseif tag == "list" then
		local first = car1(node)
		first = visitor(first, visitor)
		node[1] = first
		if type1(first) == "symbol" then
			local func = first["var"]
			local funct = func["kind"]
			if funct == "defined" or funct == "arg" or funct == "native" or funct == "macro" then
				traverseList1(node, 1, visitor)
				return visitor(node, visitor)
			elseif func == builtins1["lambda"] then
				traverseBlock1(node, 3, visitor)
				return visitor(node, visitor)
			elseif func == builtins1["cond"] then
				local temp = n1(node)
				local temp1 = 2
				while temp1 <= temp do
					local case = nth1(node, temp1)
					case[1] = traverseNode1(nth1(case, 1), visitor)
					traverseBlock1(case, 2, visitor)
					temp1 = temp1 + 1
				end
				return visitor(node, visitor)
			elseif func == builtins1["set!"] then
				node[3] = traverseNode1(nth1(node, 3), visitor)
				return visitor(node, visitor)
			elseif func == builtins1["quote"] then
				return visitor(node, visitor)
			elseif func == builtins1["syntax-quote"] then
				node[2] = traverseQuote1(nth1(node, 2), visitor, 1)
				return visitor(node, visitor)
			elseif func == builtins1["unquote"] or func == builtins1["unquote-splice"] then
				return error1("unquote/unquote-splice should never appear head", 0)
			elseif func == builtins1["define"] or func == builtins1["define-macro"] then
				node[n1(node)] = traverseNode1(nth1(node, n1(node)), visitor)
				return visitor(node, visitor)
			elseif func == builtins1["define-native"] then
				return visitor(node, visitor)
			elseif func == builtins1["import"] then
				return visitor(node, visitor)
			elseif func == builtins1["struct-literal"] then
				traverseList1(node, 2, visitor)
				return visitor(node, visitor)
			else
				return error1("Unknown kind " .. funct .. " for variable " .. func["name"], 0)
			end
		else
			traverseList1(node, 1, visitor)
			return visitor(node, visitor)
		end
	else
		return error1("Unknown tag " .. tag)
	end
end
traverseBlock1 = function(node, start, visitor)
	local temp = n1(node)
	local temp1 = start
	while temp1 <= temp do
		node[temp1] = (traverseNode1(nth1(node, temp1 + 0), visitor))
		temp1 = temp1 + 1
	end
	return node
end
traverseList1 = function(node, start, visitor)
	local temp = n1(node)
	local temp1 = start
	while temp1 <= temp do
		node[temp1] = traverseNode1(nth1(node, temp1), visitor)
		temp1 = temp1 + 1
	end
	return node
end
fusionPatterns1 = {tag="list", n=0}
metavar_3f_1 = function(x)
	return x["var"] == nil and sub1(symbol_2d3e_string1(x), 1, 1) == "?"
end
genvar_3f_1 = function(x)
	return x["var"] == nil and sub1(symbol_2d3e_string1(x), 1, 1) == "%"
end
peq_3f_1 = function(x, y, out)
	if x == y then
		return true
	else
		local tyX, tyY = type1(x), type1(y)
		if tyX == "symbol" and metavar_3f_1(x) then
			out[symbol_2d3e_string1(x)] = y
			return true
		elseif tyX ~= tyY then
			return false
		elseif tyX == "symbol" then
			return x["var"] == y["var"]
		elseif tyX == "string" then
			return constVal1(x) == constVal1(y)
		elseif tyX == "number" then
			return constVal1(x) == constVal1(y)
		elseif tyX == "key" then
			return constVal1(x) == constVal1(y)
		elseif tyX == "list" then
			if n1(x) == n1(y) then
				local ok = true
				local temp = n1(x)
				local temp1 = 1
				while temp1 <= temp do
					if ok and not peq_3f_1(nth1(x, temp1), nth1(y, temp1), out) then
						ok = false
					end
					temp1 = temp1 + 1
				end
				return ok
			else
				return false
			end
		else
			_error("unmatched item")
		end
	end
end
substitute1 = function(x, subs, syms)
	local temp = type1(x)
	if temp == "string" then
		return x
	elseif temp == "number" then
		return x
	elseif temp == "key" then
		return x
	elseif temp == "symbol" then
		if metavar_3f_1(x) then
			local res = subs[symbol_2d3e_string1(x)]
			if res == nil then
				error1("Unknown capture " .. pretty1(x), 0)
			end
			return res
		elseif genvar_3f_1(x) then
			local name = symbol_2d3e_string1(x)
			local sym = syms[name]
			if not sym then
				sym = {["tag"]="symbol", ["name"]=name, ["var"]={["tag"]="var", ["kind"]="arg", ["name"]=name}}
				syms[name] = sym
			end
			return sym
		else
			local var = x["var"]
			return {["tag"]="symbol", ["contents"]=var["name"], ["var"]=var}
		end
	elseif temp == "list" then
		return map2(function(temp1)
			return substitute1(temp1, subs, syms)
		end, x)
	else
		return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"key\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`")
	end
end
fixPattern_21_1 = function(state, ptrn)
	local temp = type1(ptrn)
	if temp == "string" then
		return ptrn
	elseif temp == "number" then
		return ptrn
	elseif temp == "symbol" then
		if ptrn["var"] then
			local var = symbol_2d3e_var1(state, ptrn)
			return {["tag"]="symbol", ["contents"]=var["name"], ["var"]=var}
		else
			return ptrn
		end
	elseif temp == "list" then
		return map2(function(temp1)
			return fixPattern_21_1(state, temp1)
		end, ptrn)
	else
		return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`")
	end
end
fixRule_21_1 = function(state, rule)
	return {["from"]=fixPattern_21_1(state, rule["from"]), ["to"]=fixPattern_21_1(state, rule["to"])}
end
fusion1 = {["name"]="fusion", ["help"]="Merges various loops together as specified by a pattern.", ["cat"]={tag="list", n=1, "opt"}, ["on"]=false, ["run"]=function(temp, state, nodes)
	local patterns = map2(function(temp1)
		return fixRule_21_1(state["compiler"], temp1)
	end, fusionPatterns1)
	return traverseBlock1(nodes, 1, function(node)
		if type1(node) == "list" then
			local temp1 = n1(patterns)
			local temp2 = 1
			while temp2 <= temp1 do
				local ptrn, subs = patterns[temp2], {}
				if peq_3f_1(ptrn["from"], node, subs) then
					temp["changed"] = temp["changed"] + 1
					node = substitute1(ptrn["to"], subs, {})
				end
				temp2 = temp2 + 1
			end
		end
		return node
	end)
end}
addRule_21_1 = function(rule)
	local temp = type1(rule)
	if temp ~= "table" then
		error1(format1("bad argument %s (expected %s, got %s)", "rule", "table", temp), 2)
	end
	pushCdr_21_1(fusionPatterns1, rule)
	return nil
end
visitQuote1 = function(node, visitor, level)
	while true do
		if level == 0 then
			return visitNode1(node, visitor)
		else
			local tag = type1(node)
			if tag == "string" or tag == "number" or tag == "key" or tag == "symbol" then
				return nil
			elseif tag == "list" then
				local first = nth1(node, 1)
				if type1(first) == "symbol" then
					if first["contents"] == "unquote" or first["contents"] == "unquote-splice" then
						node, level = nth1(node, 2), level - 1
					elseif first["contents"] == "syntax-quote" then
						node, level = nth1(node, 2), level + 1
					else
						local temp = n1(node)
						local temp1 = 1
						while temp1 <= temp do
							visitQuote1(node[temp1], visitor, level)
							temp1 = temp1 + 1
						end
						return nil
					end
				else
					local temp = n1(node)
					local temp1 = 1
					while temp1 <= temp do
						visitQuote1(node[temp1], visitor, level)
						temp1 = temp1 + 1
					end
					return nil
				end
			elseif error1 then
				return "Unknown tag " .. tag
			else
				_error("unmatched item")
			end
		end
	end
end
visitNode1 = function(node, visitor)
	while true do
		if (visitor(node, visitor) == false) then
			return nil
		else
			local tag = type1(node)
			if tag == "string" or tag == "number" or tag == "key" or tag == "symbol" then
				return nil
			elseif tag == "list" then
				local first = nth1(node, 1)
				if type1(first) == "symbol" then
					local func = first["var"]
					local funct = func["kind"]
					if funct == "defined" or funct == "arg" or funct == "native" or funct == "macro" then
						return visitBlock1(node, 1, visitor)
					elseif func == builtins1["lambda"] then
						return visitBlock1(node, 3, visitor)
					elseif func == builtins1["cond"] then
						local temp = n1(node)
						local temp1 = 2
						while temp1 <= temp do
							local case = nth1(node, temp1)
							visitNode1(nth1(case, 1), visitor)
							visitBlock1(case, 2, visitor)
							temp1 = temp1 + 1
						end
						return nil
					elseif func == builtins1["set!"] then
						node = nth1(node, 3)
					elseif func == builtins1["quote"] then
						return nil
					elseif func == builtins1["syntax-quote"] then
						return visitQuote1(nth1(node, 2), visitor, 1)
					elseif func == builtins1["unquote"] or func == builtins1["unquote-splice"] then
						return error1("unquote/unquote-splice should never appear here", 0)
					elseif func == builtins1["define"] or func == builtins1["define-macro"] then
						node = nth1(node, n1(node))
					elseif func == builtins1["define-native"] then
						return nil
					elseif func == builtins1["import"] then
						return nil
					elseif func == builtins1["struct-literal"] then
						return visitBlock1(node, 2, visitor)
					else
						return error1("Unknown kind " .. funct .. " for variable " .. func["name"], 0)
					end
				else
					return visitBlock1(node, 1, visitor)
				end
			else
				return error1("Unknown tag " .. tag)
			end
		end
	end
end
visitBlock1 = function(node, start, visitor)
	local temp = n1(node)
	local temp1 = start
	while temp1 <= temp do
		visitNode1(nth1(node, temp1), visitor)
		temp1 = temp1 + 1
	end
	return nil
end
nodeContainsVar_3f_1 = function(node, var)
	local found = false
	visitNode1(node, function(node1)
		if found then
			return false
		elseif type1(node1) == "list" and builtin_3f_1(car1(node1), "set!") then
			found = var == nth1(node1, 2)["var"]
			return nil
		elseif type1(node1) == "symbol" then
			found = var == node1["var"]
			return nil
		else
			return nil
		end
	end)
	return found
end
nodeContainsVars_3f_1 = function(node, vars)
	local found = false
	visitNode1(node, function(node1)
		if found then
			return false
		elseif type1(node1) == "list" and builtin_3f_1(car1(node1), "set!") then
			found = vars[nth1(node1, 2)["var"]]
			return nil
		elseif type1(node1) == "symbol" then
			found = vars[node1["var"]]
			return nil
		else
			return nil
		end
	end)
	return found
end
stripImport1 = {["name"]="strip-import", ["help"]="Strip all import expressions in NODES", ["cat"]={tag="list", n=2, "opt", "transform-pre-block"}, ["run"]=function(temp, state, nodes, start)
	local temp1 = n1(nodes)
	while temp1 >= start do
		local node = nth1(nodes, temp1)
		if type1(node) == "list" and builtin_3f_1(car1(node), "import") then
			if temp1 == n1(nodes) then
				nodes[temp1] = makeNil1()
			else
				removeNth_21_1(nodes, temp1)
			end
			temp["changed"] = temp["changed"] + 1
		end
		temp1 = temp1 + -1
	end
	return nil
end}
stripPure1 = {["name"]="strip-pure", ["help"]="Strip all pure expressions in NODES (apart from the last one).", ["cat"]={tag="list", n=2, "opt", "transform-pre-block"}, ["run"]=function(temp, state, nodes, start)
	local temp1 = n1(nodes) - 1
	while temp1 >= start do
		if not sideEffect_3f_1((nth1(nodes, temp1))) then
			removeNth_21_1(nodes, temp1)
			temp["changed"] = temp["changed"] + 1
		end
		temp1 = temp1 + -1
	end
	return nil
end}
constantFold1 = {["name"]="constant-fold", ["help"]="A primitive constant folder\n\nThis simply finds function calls with constant functions and looks up the function.\nIf the function is native and pure then we'll execute it and replace the node with the\nresult. There are a couple of caveats:\n\n - If the function call errors then we will flag a warning and continue.\n - If this returns a decimal (or infinity or NaN) then we'll continue: we cannot correctly\n   accurately handle this.\n - If this doesn't return exactly one value then we will stop. This might be a future enhancement.", ["cat"]={tag="list", n=2, "opt", "transform-post"}, ["run"]=function(temp, state, node)
	if type1(node) == "list" and fastAll1(constant_3f_1, node, 2) then
		local head = car1(node)
		local meta = type1(head) == "symbol" and (not head["folded"] and (head["var"]["kind"] == "native" and state["meta"][head["var"]["unique-name"]]))
		if meta and (meta["pure"] and meta["value"]) then
			local res = list1(pcall1(meta["value"], unpack1(map2(urn_2d3e_val1, cdr1(node)), 1, n1(node) - 1)))
			if car1(res) then
				local val = nth1(res, 2)
				if n1(res) ~= 2 or number_3f_1(val) and (cadr1(list1(modf1(val))) ~= 0 or abs1(val) == huge1) then
					head["folded"] = true
					return node
				else
					temp["changed"] = temp["changed"] + 1
					return val_2d3e_urn1(val)
				end
			else
				head["folded"] = true
				putNodeWarning_21_1(state["logger"], "Cannot execute constant expression", node, nil, getSource1(node), "Executed " .. pretty1(node) .. ", failed with: " .. nth1(res, 2))
				return node
			end
		else
			return node
		end
	else
		return node
	end
end}
condFold1 = {["name"]="cond-fold", ["help"]="Simplify all `cond` nodes, removing `false` branches and killing\nall branches after a `true` one.", ["cat"]={tag="list", n=2, "opt", "transform-post"}, ["run"]=function(temp, state, node)
	if type1(node) == "list" and builtin_3f_1(car1(node), "cond") then
		local final, i = false, 2
		while i <= n1(node) do
			local elem = nth1(node, i)
			if final then
				temp["changed"] = temp["changed"] + 1
				removeNth_21_1(node, i)
			else
				local temp1 = urn_2d3e_bool1(car1(elem))
				if temp1 == false then
					temp["changed"] = temp["changed"] + 1
					removeNth_21_1(node, i)
				elseif temp1 == true then
					if not builtin_3f_1(car1(elem), "true") then
						temp["changed"] = temp["changed"] + 1
						elem[1] = (function()
							local var = builtins1["true"]
							return {["tag"]="symbol", ["contents"]=var["name"], ["var"]=var}
						end)()
					end
					final = true
					i = i + 1
				elseif temp1 == nil then
					i = i + 1
				else
					error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp1) .. ", but none matched.\n" .. "  Tried: `false`\n  Tried: `true`\n  Tried: `nil`")
				end
			end
		end
		if n1(node) == 2 and builtin_3f_1(car1(nth1(node, 2)), "true") then
			temp["changed"] = temp["changed"] + 1
			local body = cdr1(nth1(node, 2))
			if n1(body) == 1 then
				return car1(body)
			else
				return makeProgn1(cdr1(nth1(node, 2)))
			end
		else
			local temp1
			if n1(node) > 1 then
				local branch = last1(node)
				temp1 = n1(branch) == 2 and (builtin_3f_1(car1(branch), "true") and (type1((cadr1(branch))) == "list" and builtin_3f_1(caadr1(branch), "cond")))
			else
				temp1 = false
			end
			if temp1 then
				local childCond = nth1(popLast_21_1(node), 2)
				local temp1 = n1(childCond)
				local temp2 = 2
				while temp2 <= temp1 do
					pushCdr_21_1(node, nth1(childCond, temp2))
					temp2 = temp2 + 1
				end
				temp["changed"] = temp["changed"] + 1
				return node
			else
				return node
			end
		end
	else
		return node
	end
end}
lambdaFold1 = {["name"]="lambda-fold", ["help"]="Simplify all directly called lambdas without arguments, inlining them\nwere appropriate.", ["cat"]={tag="list", n=3, "opt", "deforest", "transform-post-bind"}, ["run"]=function(temp, state, node)
	if simpleBinding_3f_1(node) then
		local vars, nodeLam = {}, car1(node)
		local nodeArgs = nth1(nodeLam, 2)
		local argN, valN, i = n1(nodeArgs), n1(node) - 1, 1
		if valN <= argN then
			local temp1 = n1(nodeArgs)
			local temp2 = 1
			while temp2 <= temp1 do
				vars[nodeArgs[temp2]["var"]] = true
				temp2 = temp2 + 1
			end
			while i <= valN and not builtin_3f_1(nth1(node, i + 1), "nil") do
				i = i + 1
			end
			if i <= argN then
				while not ((i > argN)) do
					local head = nth1(nodeLam, 3)
					if type1(head) == "list" and (builtin_3f_1(car1(head), "set!") and (nth1(head, 2)["var"] == nth1(nodeArgs, i)["var"] and not nodeContainsVars_3f_1(nth1(head, 3), vars))) then
						while valN < i do
							pushCdr_21_1(node, makeNil1())
							valN = valN + 1
						end
						removeNth_21_1(nodeLam, 3)
						node[i + 1] = nth1(head, 3)
						temp["changed"] = temp["changed"] + 1
					end
					i = i + 1
				end
			end
		end
	end
	if simpleBinding_3f_1(node) then
		local vars, nodeLam = {}, car1(node)
		local nodeArgs = nth1(nodeLam, 2)
		local temp1 = n1(nodeArgs)
		local temp2 = 1
		while temp2 <= temp1 do
			vars[nodeArgs[temp2]["var"]] = true
			temp2 = temp2 + 1
		end
		local child = nth1(nodeLam, 3)
		while true do
			if (not simpleBinding_3f_1(child) or n1(nodeArgs) ~= n1(node) - 1 or n1(nodeLam) > 3) then
				return nil
			else
				local args = nth1(car1(child), 2)
				while true do
					local val = nth1(child, 2)
					if empty_3f_1(args) then
						break
					elseif not val then
						local temp1 = n1(args)
						local temp2 = 1
						while temp2 <= temp1 do
							temp["changed"] = temp["changed"] + 1
							local arg = removeNth_21_1(args, 1)
							pushCdr_21_1(nodeArgs, arg)
							vars[arg["var"]] = true
							temp2 = temp2 + 1
						end
						break
					elseif nodeContainsVars_3f_1(val, vars) then
						break
					else
						temp["changed"] = temp["changed"] + 1
						pushCdr_21_1(node, removeNth_21_1(child, 2))
						local arg = removeNth_21_1(args, 1)
						pushCdr_21_1(nodeArgs, arg)
						vars[arg["var"]] = true
					end
				end
				if empty_3f_1(args) and n1(child) == 1 then
					removeNth_21_1(nodeLam, 3)
					local lam = car1(child)
					local temp1 = n1(lam)
					local temp2 = 3
					while temp2 <= temp1 do
						insertNth_21_1(nodeLam, temp2, nth1(lam, temp2))
						temp2 = temp2 + 1
					end
					child = nth1(nodeLam, 3)
				else
					return nil
				end
			end
		end
	else
		return nil
	end
end}
prognFoldExpr1 = {["name"]="progn-fold-expr", ["help"]="Reduce [[progn]]-like nodes with a single body element into a single\nexpression.", ["cat"]={tag="list", n=3, "opt", "deforest", "transform-post"}, ["run"]=function(temp, state, node)
	if type1(node) == "list" and (n1(node) == 1 and (type1((car1(node))) == "list" and (builtin_3f_1(caar1(node), "lambda") and (n1(car1(node)) == 3 and empty_3f_1(nth1(car1(node), 2)))))) then
		temp["changed"] = temp["changed"] + 1
		return nth1(car1(node), 3)
	else
		return node
	end
end}
prognFoldBlock1 = {["name"]="progn-fold-block", ["help"]="Reduce [[progn]]-like nodes with a single body element into a single\nexpression.", ["cat"]={tag="list", n=3, "opt", "deforest", "transform-post-block"}, ["run"]=function(temp, state, nodes, start)
	local i, len = start, n1(nodes)
	while i <= len do
		local node = nth1(nodes, i)
		if type1(node) == "list" and (n1(node) == 1 and (type1((car1(node))) == "list" and (builtin_3f_1(car1(car1(node)), "lambda") and empty_3f_1(nth1(car1(node), 2))))) then
			local body = car1(node)
			temp["changed"] = temp["changed"] + 1
			if n1(body) == 2 then
				removeNth_21_1(nodes, i)
			else
				nodes[i] = nth1(body, 3)
				local temp1 = n1(body)
				local temp2 = 4
				while temp2 <= temp1 do
					insertNth_21_1(nodes, i + (temp2 - 3), nth1(body, temp2))
					temp2 = temp2 + 1
				end
			end
			len = len + (n1(node) - 1)
		else
			i = i + 1
		end
	end
	return nil
end}
stripDefsFast1 = function(nodes)
	local defs = {}
	local temp = n1(nodes)
	local temp1 = 1
	while temp1 <= temp do
		local node = nodes[temp1]
		if type1(node) == "list" then
			local var = node["def-var"]
			if var then
				defs[var] = node
			end
		end
		temp1 = temp1 + 1
	end
	local visited, queue = {}, {tag="list", n=0}
	local visitor = function(node)
		if type1(node) == "symbol" then
			local var = node["var"]
			local def = defs[var]
			if def and not visited[var] then
				visited[var] = true
				return pushCdr_21_1(queue, def)
			else
				return nil
			end
		else
			return nil
		end
	end
	local temp = n1(nodes)
	local temp1 = 1
	while temp1 <= temp do
		local node = nodes[temp1]
		if not node["def-var"] then
			visitNode1(node, visitor)
		end
		temp1 = temp1 + 1
	end
	while n1(queue) > 0 do
		visitNode1(popLast_21_1(queue), visitor)
	end
	local temp = n1(nodes)
	while temp >= 1 do
		local var = nth1(nodes, temp)["def-var"]
		if var and not visited[var] then
			if temp == n1(nodes) then
				nodes[temp] = makeNil1()
			else
				removeNth_21_1(nodes, temp)
			end
		end
		temp = temp + -1
	end
	return nil
end
getConstantVal1 = function(lookup, sym)
	local var, def = sym["var"], getVar1(lookup, sym["var"])
	if var == builtins1["true"] then
		return sym
	elseif var == builtins1["false"] then
		return sym
	elseif var == builtins1["nil"] then
		return sym
	elseif n1(def["defs"]) == 1 then
		local ent = car1(def["defs"])
		local val, ty = ent["value"], type1(ent)
		if string_3f_1(val) or number_3f_1(val) or type1(val) == "key" then
			return val
		elseif type1(val) == "symbol" and ty == "val" then
			return getConstantVal1(lookup, val) or sym
		else
			return sym
		end
	else
		return nil
	end
end
stripDefs1 = {["name"]="strip-defs", ["help"]="Strip all unused top level definitions.", ["cat"]={tag="list", n=2, "opt", "usage"}, ["run"]=function(temp, state, nodes, lookup)
	local temp1 = n1(nodes)
	while temp1 >= 1 do
		local node = nth1(nodes, temp1)
		if node["def-var"] and not getVar1(lookup, node["def-var"])["active"] then
			if temp1 == n1(nodes) then
				nodes[temp1] = makeNil1()
			else
				removeNth_21_1(nodes, temp1)
			end
			temp["changed"] = temp["changed"] + 1
		end
		temp1 = temp1 + -1
	end
	return nil
end}
stripArgs1 = {["name"]="strip-args", ["help"]="Strip all unused, pure arguments in directly called lambdas.", ["cat"]={tag="list", n=3, "opt", "usage", "transform-post-bind"}, ["run"]=function(temp, state, node, lookup)
	local lam = car1(node)
	local lamArgs, argOffset, valOffset, removed = nth1(lam, 2), 1, 2, {}
	local temp1 = zipArgs1(lamArgs, 1, node, 2)
	local temp2 = n1(temp1)
	local temp3 = 1
	while temp3 <= temp2 do
		local zipped = temp1[temp3]
		local args = car1(zipped)
		local arg, vals = car1(args), cadr1(zipped)
		if n1(args) > 1 or arg and n1(getVar1(lookup, arg["var"])["usages"]) > 0 or any1(sideEffect_3f_1, vals) then
			argOffset = argOffset + n1(args)
			valOffset = argOffset + n1(vals)
		else
			temp["changed"] = temp["changed"] + 1
			if arg then
				removed[arg["var"]] = true
				removeNth_21_1(lamArgs, argOffset)
			end
			local temp4 = n1(vals)
			local temp5 = 1
			while temp5 <= temp4 do
				local val = vals[temp5]
				removeNth_21_1(node, valOffset)
				temp5 = temp5 + 1
			end
		end
		temp3 = temp3 + 1
	end
	if (not next1(removed)) then
		return nil
	else
		return traverseList1(lam, 3, function(node1)
			if type1(node1) == "list" and (builtin_3f_1(car1(node1), "set!") and removed[nth1(node1, 2)["var"]]) then
				local val = nth1(node1, 3)
				if sideEffect_3f_1(val) then
					return makeProgn1(list1(val, makeNil1()))
				else
					return makeNil1()
				end
			else
				return node1
			end
		end)
	end
end}
variableFold1 = {["name"]="variable-fold", ["help"]="Folds constant variable accesses", ["cat"]={tag="list", n=3, "opt", "usage", "transform-pre"}, ["run"]=function(temp, state, node, lookup)
	if type1(node) == "symbol" then
		local replace = getConstantVal1(lookup, node)
		if replace and replace ~= node then
			removeUsage_21_1(lookup, node["var"], node)
			if type1(replace) == "symbol" then
				replace = copyOf1(replace)
				addUsage_21_1(lookup, replace["var"], replace)
			end
			temp["changed"] = temp["changed"] + 1
			return replace
		else
			return node
		end
	else
		return node
	end
end}
expressionFold1 = {["name"]="expression-fold", ["help"]="Folds basic variable accesses where execution order will not change.\n\nFor instance, converts ((lambda (x) (+ x 1)) (Y)) to (+ Y 1) in the\ncase where Y is an arbitrary expression.\n\nThere are a couple of complexities in the implementation\nhere. Firstly, we want to ensure that the arguments are executed in\nthe correct order and only once.\n\nIn order to achieve this, we find the lambda forms and visit the body,\nstopping if we visit arguments in the wrong order or non-constant\nterms such as mutable variables or other function calls. For\nsimplicity's sake, we fail if we hit other lambdas or conds as that\nmakes analysing control flow significantly more complex.\n\nAnother source of added complexity is the case where where Y could\nreturn multiple values: namely in the last argument to function\ncalls. Here it is an invalid optimisation to just place Y, as that\ncould result in additional values being passed to the function.\n\nIn order to avoid this, Y will get converted to the\nform ((lambda (<tmp>) <tmp>) Y).  This is understood by the codegen\nand so is not as inefficient as it looks. However, we do have to take\nadditional steps to avoid trying to fold the above again and again.\n\nWe use post-bind rather than pre-bind as that enables us to benefit\nfrom any optimisations inside the node. We're not going to be moving\nany simple, constant-foldable expressions around. After all, that's\ncovered by [[variable-fold]].", ["cat"]={tag="list", n=3, "opt", "usage", "transform-post-bind"}, ["run"]=function(temp, state, root, lookup)
	local lam, args, len, validate = car1(root)
	args = nth1(lam, 2)
	len = n1(args)
	validate = function(i)
		while true do
			if i > len then
				return true
			else
				local var = nth1(args, i)["var"]
				local entry = getVar1(lookup, var)
				if var["is-variadic"] then
					return false
				elseif n1(entry["defs"]) ~= 1 then
					return false
				elseif type1(car1(entry["defs"])) == "var" then
					return false
				elseif n1(entry["usages"]) ~= 1 then
					return false
				else
					i = i + 1
				end
			end
		end
	end
	if len > 0 and ((n1(root) ~= 2 or len ~= 1 or n1(lam) ~= 3 or singleReturn_3f_1(nth1(root, 2)) or not (type1((nth1(lam, 3))) == "symbol") or nth1(lam, 3)["var"] ~= car1(args)["var"]) and validate(1)) then
		local currentIdx, argMap, wrapMap, ok, finished = 1, {}, {}, true, false
		local temp1 = n1(args)
		local temp2 = 1
		while temp2 <= temp1 do
			argMap[nth1(args, temp2)["var"]] = temp2
			temp2 = temp2 + 1
		end
		visitBlock1(lam, 3, function(node, visitor)
			if ok and not finished then
				local temp1 = type1(node)
				if temp1 == "string" then
					return nil
				elseif temp1 == "number" then
					return nil
				elseif temp1 == "key" then
					return nil
				elseif temp1 == "symbol" then
					local idx = argMap[node["var"]]
					if idx == nil then
						if n1(getVar1(lookup, node["var"])["defs"]) > 1 then
							ok = false
							return false
						else
							return nil
						end
					elseif idx == currentIdx then
						currentIdx = currentIdx + 1
						if currentIdx > len then
							finished = true
							return nil
						else
							return nil
						end
					else
						ok = false
						return false
					end
				elseif temp1 == "list" then
					local head = car1(node)
					local temp2 = type1(head)
					if temp2 == "symbol" then
						local var = head["var"]
						if var["kind"] ~= "builtin" then
							visitBlock1(node, 1, visitor)
							if n1(node) > 1 then
								local last = nth1(node, n1(node))
								if type1(last) == "symbol" then
									local idx = argMap[last["var"]]
									if idx then
										if type1(((root[idx + 1]))) == "list" then
											wrapMap[idx] = true
										end
									end
								end
							end
						elseif var == builtins1["set!"] then
							visitNode1(nth1(node, 3), visitor)
						elseif var == builtins1["define"] then
							visitNode1(last1(node), visitor)
						elseif var == builtins1["define-macro"] then
							visitNode1(last1(node), visitor)
						elseif var == builtins1["define-native"] then
						elseif var == builtins1["cond"] then
							visitNode1(car1(nth1(node, 2)), visitor)
						elseif var == builtins1["lambda"] then
						elseif var == builtins1["quote"] then
						elseif var == builtins1["import"] then
						elseif var == builtins1["syntax-quote"] then
							visitQuote1(nth1(node, 2), visitor, 1)
						elseif var == builtins1["struct-literal"] then
							visitBlock1(node, 2, visitor)
						else
							_error("unmatched item")
						end
						if finished then
						elseif var == builtins1["set!"] then
							ok = false
						elseif var == builtins1["cond"] then
							ok = false
						elseif var == builtins1["lambda"] then
							ok = false
						else
							ok = false
						end
						return false
					elseif temp2 == "list" then
						if builtin_3f_1(car1(head), "lambda") then
							visitBlock1(node, 2, visitor)
							visitBlock1(head, 3, visitor)
							return false
						else
							ok = false
							return false
						end
					else
						ok = false
						return false
					end
				else
					return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp1) .. ", but none matched.\n" .. "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"key\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`")
				end
			else
				return false
			end
		end)
		if ok and finished then
			temp["changed"] = temp["changed"] + 1
			traverseList1(root, 1, function(child)
				if type1(child) == "symbol" then
					local var = child["var"]
					local i = argMap[var]
					if i then
						if wrapMap[i] then
							return {tag="list", n=2, {tag="list", n=3, (function()
								local var1 = builtins1["lambda"]
								return {["tag"]="symbol", ["contents"]=var1["name"], ["var"]=var1}
							end)(), {tag="list", n=1, {["tag"]="symbol", ["contents"]=var["name"], ["var"]=var}}, {["tag"]="symbol", ["contents"]=var["name"], ["var"]=var}}, nth1(root, i + 1)}
						else
							return nth1(root, i + 1) or makeNil1()
						end
					else
						return child
					end
				else
					return child
				end
			end)
			local temp1 = n1(root)
			while temp1 >= 2 do
				removeNth_21_1(root, temp1)
				temp1 = temp1 + -1
			end
			local temp1 = n1(args)
			while temp1 >= 1 do
				removeNth_21_1(args, temp1)
				temp1 = temp1 + -1
			end
			return nil
		else
			return nil
		end
	else
		return nil
	end
end}
condEliminate1 = {["name"]="cond-eliminate", ["help"]="Replace variables with known truthy/falsey values with `true` or\n`false` when used in branches.", ["cat"]={tag="list", n=2, "opt", "usage"}, ["run"]=function(temp, state, nodes, varLookup)
	local lookup = {}
	return visitBlock1(nodes, 1, function(node, visitor, isCond)
		local temp1 = type1(node)
		if temp1 == "symbol" then
			if isCond then
				local temp2 = lookup[node["var"]]
				if temp2 == false then
					if node["var"] ~= builtins1["false"] then
						local var = builtins1["false"]
						return {["tag"]="symbol", ["contents"]=var["name"], ["var"]=var}
					else
						return nil
					end
				elseif temp2 == true then
					if node["var"] ~= builtins1["true"] then
						local var = builtins1["true"]
						return {["tag"]="symbol", ["contents"]=var["name"], ["var"]=var}
					else
						return nil
					end
				else
					return nil
				end
			else
				return nil
			end
		elseif temp1 == "list" then
			local head = car1(node)
			local temp2 = type1(head)
			if temp2 == "symbol" then
				if builtin_3f_1(head, "cond") then
					local vars = {tag="list", n=0}
					local temp3 = n1(node)
					local temp4 = 2
					while temp4 <= temp3 do
						local entry = nth1(node, temp4)
						local test, len = car1(entry), n1(entry)
						local var = type1(test) == "symbol" and test["var"]
						if var then
							if lookup[var] ~= nil then
								var = nil
							elseif n1(getVar1(varLookup, var)["defs"]) > 1 then
								var = nil
							end
						end
						local temp5 = visitor(test, visitor, true)
						if temp5 == nil then
							visitNode1(test, visitor)
						elseif temp5 == false then
						else
							temp["changed"] = temp["changed"] + 1
							entry[1] = temp5
						end
						if var then
							pushCdr_21_1(vars, var)
							lookup[var] = true
						end
						local temp5 = len - 1
						local temp6 = 2
						while temp6 <= temp5 do
							visitNode1(nth1(entry, temp6), visitor)
							temp6 = temp6 + 1
						end
						if len > 1 then
							local last = nth1(entry, len)
							local temp5 = visitor(last, visitor, isCond)
							if temp5 == nil then
								visitNode1(last, visitor)
							elseif temp5 == false then
							else
								temp["changed"] = temp["changed"] + 1
								entry[len] = temp5
							end
						end
						if var then
							lookup[var] = false
						end
						temp4 = temp4 + 1
					end
					local temp3 = n1(vars)
					local temp4 = 1
					while temp4 <= temp3 do
						lookup[vars[temp4]] = nil
						temp4 = temp4 + 1
					end
					return false
				else
					return nil
				end
			elseif temp2 == "list" then
				if isCond and builtin_3f_1(car1(head), "lambda") then
					local temp3 = n1(node)
					local temp4 = 2
					while temp4 <= temp3 do
						visitNode1(nth1(node, temp4), visitor)
						temp4 = temp4 + 1
					end
					local len = n1(head)
					local temp3 = len - 1
					local temp4 = 3
					while temp4 <= temp3 do
						visitNode1(nth1(head, temp4), visitor)
						temp4 = temp4 + 1
					end
					if len > 2 then
						local last = nth1(head, len)
						local temp3 = visitor(last, visitor, isCond)
						if temp3 == nil then
							visitNode1(last, visitor)
						elseif temp3 == false then
						else
							temp["changed"] = temp["changed"] + 1
							node[head] = temp3
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
	end)
end}
getScope1 = function(scope, lookup)
	local newScope = lookup["scopes"][scope]
	if newScope then
		return newScope
	else
		local newScope1 = child1()
		lookup["scopes"][scope] = newScope1
		return newScope1
	end
end
getVar2 = function(var, lookup)
	return lookup["vars"][var] or var
end
copyNode1 = function(node, lookup)
	local temp = type1(node)
	if temp == "string" then
		return copyOf1(node)
	elseif temp == "key" then
		return copyOf1(node)
	elseif temp == "number" then
		return copyOf1(node)
	elseif temp == "symbol" then
		local copy, oldVar = copyOf1(node), node["var"]
		local newVar = getVar2(oldVar, lookup)
		if oldVar ~= newVar and oldVar["node"] == node then
			newVar["node"] = copy
		end
		copy["var"] = newVar
		return copy
	elseif temp == "list" then
		if builtin_3f_1(car1(node), "lambda") then
			local args = cadr1(node)
			if not empty_3f_1(args) then
				local newScope, temp1 = child1(getScope1(car1(args)["var"]["scope"], lookup)), n1(args)
				local temp2 = 1
				while temp2 <= temp1 do
					local var = args[temp2]["var"]
					local newVar = add_21_1(newScope, var["name"], var["kind"], nil)
					newVar["is-variadic"] = var["is-variadic"]
					lookup["vars"][var] = newVar
					temp2 = temp2 + 1
				end
			end
		end
		local res = copyOf1(node)
		local temp1 = n1(res)
		local temp2 = 1
		while temp2 <= temp1 do
			res[temp2] = copyNode1(nth1(res, temp2), lookup)
			temp2 = temp2 + 1
		end
		return res
	else
		return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"string\"`\n  Tried: `\"key\"`\n  Tried: `\"number\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`")
	end
end
scoreNode1 = function(node, cumulative, threshold)
	while true do
		local temp = type1(node)
		if temp == "string" then
			return cumulative
		elseif temp == "key" then
			return cumulative
		elseif temp == "number" then
			return cumulative
		elseif temp == "symbol" then
			return cumulative + 1
		elseif temp == "list" then
			local temp1 = type1(car1(node))
			if temp1 == "symbol" then
				local func = car1(node)["var"]
				if func["kind"] ~= "builtin" then
					return scoreNodes1(node, 1, cumulative + n1(node) + 1, threshold)
				elseif func == builtins1["lambda"] then
					return scoreNodes1(node, 3, cumulative + 10, threshold)
				elseif func == builtins1["cond"] then
					cumulative = cumulative + 3
					local len, _ = n1(node)
					local i = 2
					while true do
						if (i > len) then
							break
						else
							cumulative = cumulative + 4
							if cumulative <= threshold then
								cumulative = scoreNodes1(nth1(node, i), 1, cumulative, threshold)
								i = i + 1
							else
								break
							end
						end
					end
					return cumulative
				elseif func == builtins1["set!"] then
					node, cumulative = nth1(node, 3), cumulative + 5
				elseif func == builtins1["quote"] then
					if type1((nth1(node, 2))) == "list" then
						return cumulative + n1(node)
					else
						return cumulative
					end
				elseif func == builtins1["import"] then
					return cumulative
				elseif func == builtins1["syntax-quote"] then
					node, cumulative = nth1(node, 2), cumulative + 3
				elseif func == builtins1["unquote"] then
					node = nth1(node, 2)
				elseif func == builtins1["unquote-splice"] then
					node, cumulative = nth1(node, 2), cumulative + 10
				elseif func == builtins1["struct-literal"] then
					return scoreNodes1(node, 2, cumulative + (n1(node) - 1) / 2 + 3, threshold)
				else
					_error("unmatched item")
				end
			elseif temp1 == "list" then
				if builtin_3f_1(caar1(node), "lambda") then
					local temp2 = scoreNodes1(node, 2, cumulative, threshold)
					return scoreNodes1(car1(node), 3, temp2, threshold)
				else
					return scoreNodes1(node, 1, cumulative + n1(node) + 1, threshold)
				end
			else
				return scoreNodes1(node, 1, cumulative + n1(node) + 1, threshold)
			end
		else
			return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"string\"`\n  Tried: `\"key\"`\n  Tried: `\"number\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`")
		end
	end
end
scoreNodes1 = function(nodes, start, cumulative, threshold)
	local len, _ = n1(nodes)
	local i = start
	while true do
		if i > len then
			break
		elseif cumulative <= threshold then
			cumulative = scoreNode1(nth1(nodes, i), cumulative, threshold)
			i = i + 1
		else
			break
		end
	end
	return cumulative
end
getScore1 = function(lookup, node)
	local score = lookup[node]
	if score == nil then
		score = 0
		local temp = nth1(node, 2)
		local temp1 = n1(temp)
		local temp2 = 1
		while temp2 <= temp1 do
			if temp[temp2]["var"]["is-variadic"] then
				score = false
			end
			temp2 = temp2 + 1
		end
		if score then
			score = scoreNodes1(node, 3, score, 20)
		end
		lookup[node] = score
	end
	return score or huge1
end
inline1 = {["name"]="inline", ["help"]="Inline simple functions.", ["cat"]={tag="list", n=2, "opt", "usage"}, ["level"]=2, ["run"]=function(temp, state, nodes, usage)
	local scoreLookup = {}
	return visitBlock1(nodes, 1, function(node)
		if type1(node) == "list" and type1((car1(node))) == "symbol" then
			local func = car1(node)["var"]
			local def = getVar1(usage, func)
			if n1(def["defs"]) == 1 then
				local val = car1(def["defs"])["value"]
				if type1(val) == "list" and (builtin_3f_1(car1(val), "lambda") and getScore1(scoreLookup, val) <= 20) then
					node[1] = (copyNode1(val, {["scopes"]={}, ["vars"]={}, ["root"]=func["scope"]}))
					temp["changed"] = temp["changed"] + 1
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
	end)
end}
optimiseOnce1 = function(nodes, state, passes)
	local tracker, lookup = {["changed"]=0}, {}
	local temp = passes["normal"]
	local temp1 = n1(temp)
	local temp2 = 1
	while temp2 <= temp1 do
		runPass1(temp[temp2], state, tracker, nodes, lookup)
		temp2 = temp2 + 1
	end
	runPass1(tagUsage1, state, tracker, nodes, lookup)
	runPass1(transformer1, state, tracker, nodes, lookup, passes["transform"])
	local temp = passes["usage"]
	local temp1 = n1(temp)
	local temp2 = 1
	while temp2 <= temp1 do
		runPass1(temp[temp2], state, tracker, nodes, lookup)
		temp2 = temp2 + 1
	end
	return tracker["changed"] > 0
end
optimise1 = function(nodes, state, passes)
	stripDefsFast1(nodes)
	local maxN, maxT, iteration = state["max-n"], state["max-time"], 0
	local finish, changed = clock1() + maxT, true
	while changed and ((maxN < 0 or iteration < maxN) and (maxT < 0 or clock1() < finish)) do
		changed = optimiseOnce1(nodes, state, passes)
		iteration = iteration + 1
	end
	return nil
end
default1 = function()
	return {["normal"]=list1(fusion1), ["usage"]=list1(stripDefs1, condEliminate1, inline1), ["transform"]=list1(stripImport1, stripPure1, constantFold1, condFold1, prognFoldExpr1, prognFoldBlock1, variableFold1, stripArgs1, lambdaFold1, expressionFold1)}
end
tokens1 = {tag="list", n=7, {tag="list", n=2, "arg", "(%f[%a][%u-]+%f[^%a%d%-])"}, {tag="list", n=2, "mono", "```[^\n]*\n(.-)\n```"}, {tag="list", n=2, "mono", "`([^`]*)`"}, {tag="list", n=2, "bolic", "(%*%*%*%w.-%w%*%*%*)"}, {tag="list", n=2, "bold", "(%*%*%w.-%w%*%*)"}, {tag="list", n=2, "italic", "(%*%w.-%w%*)"}, {tag="list", n=2, "link", "%[%[(.-)%]%]"}}
extractSignature1 = function(var)
	local ty = type1(var)
	if ty == "macro" or ty == "defined" then
		local root = var["node"]
		local node = nth1(root, n1(root))
		if type1(node) == "list" and (type1((car1(node))) == "symbol" and car1(node)["var"] == builtins1["lambda"]) then
			return nth1(node, 2)
		else
			return nil
		end
	else
		return nil
	end
end
parseDocstring1 = function(str)
	local out, pos, len = {tag="list", n=0}, 1, n1(str)
	while pos <= len do
		local spos, epos, name, ptrn = len, nil, nil, nil
		local temp = n1(tokens1)
		local temp1 = 1
		while temp1 <= temp do
			local tok = tokens1[temp1]
			local npos = list1(find1(str, nth1(tok, 2), pos))
			if car1(npos) and car1(npos) < spos then
				spos = car1(npos)
				epos = nth1(npos, 2)
				name = car1(tok)
				ptrn = nth1(tok, 2)
			end
			temp1 = temp1 + 1
		end
		if name then
			if pos < spos then
				pushCdr_21_1(out, {["kind"]="text", ["contents"]=sub1(str, pos, spos - 1)})
			end
			pushCdr_21_1(out, {["kind"]=name, ["whole"]=sub1(str, spos, epos), ["contents"]=match1(sub1(str, spos, epos), ptrn)})
			pos = epos + 1
		else
			pushCdr_21_1(out, {["kind"]="text", ["contents"]=sub1(str, pos, len)})
			pos = len + 1
		end
	end
	return out
end
visitQuote2 = function(defined, logger, node, level)
	while true do
		if level == 0 then
			return visitNode2(defined, logger, node)
		elseif type1(node) == "list" then
			local first = nth1(node, 1)
			if type1(first) == "symbol" then
				if first["contents"] == "unquote" or first["contents"] == "unquote-splice" then
					node, level = nth1(node, 2), level - 1
				elseif first["contents"] == "syntax-quote" then
					node, level = nth1(node, 2), level + 1
				else
					local temp = n1(node)
					local temp1 = 1
					while temp1 <= temp do
						visitQuote2(defined, logger, node[temp1], level)
						temp1 = temp1 + 1
					end
					return nil
				end
			else
				local temp = n1(node)
				local temp1 = 1
				while temp1 <= temp do
					visitQuote2(defined, logger, node[temp1], level)
					temp1 = temp1 + 1
				end
				return nil
			end
		else
			return nil
		end
	end
end
visitNode2 = function(defined, logger, node, last)
	while true do
		local temp = type1(node)
		if temp == "string" then
			return nil
		elseif temp == "number" then
			return nil
		elseif temp == "key" then
			return nil
		elseif temp == "symbol" then
			if node["var"]["scope"]["is-root"] and not defined[node["var"]] then
				return putNodeWarning_21_1(logger, node["contents"] .. " has not been defined yet", node, "This symbol is not defined until later in the program, but is accessed here.\nConsequently, it's value may be undefined when executing the program.", getSource1(node), "")
			else
				return nil
			end
		elseif temp == "list" then
			local first = nth1(node, 1)
			local firstTy = type1(first)
			if firstTy == "symbol" then
				local func = first["var"]
				local funcTy = func["kind"]
				if funcTy == "defined" or funcTy == "arg" or funcTy == "native" or funcTy == "macro" then
					return visitList1(defined, logger, node, 1)
				elseif func == builtins1["lambda"] then
					if last then
						return nil
					else
						return visitBlock2(defined, logger, node, 3)
					end
				elseif func == builtins1["cond"] then
					local temp1 = n1(node)
					local temp2 = 2
					while temp2 <= temp1 do
						local case = nth1(node, temp2)
						visitNode2(defined, logger, nth1(case, 1))
						visitBlock2(defined, logger, case, 2, last)
						temp2 = temp2 + 1
					end
					return nil
				elseif func == builtins1["set!"] then
					node, last = nth1(node, 3)
				elseif func == builtins1["struct-literal"] then
					return visitList1(defined, logger, node, 2)
				elseif func == builtins1["syntax-quote"] then
					return visitQuote2(defined, logger, nth1(node, 2), 1)
				elseif func == builtins1["define"] or func == builtins1["define-macro"] then
					visitNode2(defined, logger, nth1(node, n1(node)), true)
					defined[node["def-var"]] = true
					return nil
				elseif func == builtins1["define-native"] then
					defined[node["def-var"]] = true
					return nil
				elseif func == builtins1["quote"] then
					return nil
				elseif func == builtins1["import"] then
					return nil
				elseif func == builtins1["unquote"] or func == builtins1["unquote-splice"] then
					return error1("unquote/unquote-splice should never appear here", 0)
				else
					return error1("Unknown kind " .. funcTy .. " for variable " .. func["name"], 0)
				end
			elseif firstTy == "list" and builtin_3f_1(car1(first), "lambda") then
				visitList1(defined, logger, node, 2)
				return visitBlock2(defined, logger, first, 3, last)
			else
				return visitList1(defined, logger, node, 1)
			end
		else
			return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"key\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`")
		end
	end
end
visitBlock2 = function(defined, logger, node, start, last)
	local temp = n1(node) - 1
	local temp1 = start
	while temp1 <= temp do
		visitNode2(defined, logger, nth1(node, temp1))
		temp1 = temp1 + 1
	end
	if n1(node) >= start then
		return visitNode2(defined, logger, nth1(node, n1(node)), last)
	else
		return nil
	end
end
visitList1 = function(defined, logger, node, start)
	local temp = n1(node)
	local temp1 = start
	while temp1 <= temp do
		visitNode2(defined, logger, nth1(node, temp1))
		temp1 = temp1 + 1
	end
	return nil
end
checkOrder1 = {["name"]="check-order", ["help"]="Check each node only eagerly accesses nodes defined after it.", ["cat"]={tag="list", n=1, "warn"}, ["run"]=function(temp, state, nodes)
	return visitList1({}, state["logger"], nodes, 1)
end}
checkArity1 = {["name"]="check-arity", ["help"]="Produce a warning if any NODE in NODES calls a function with too many arguments.\n\nLOOKUP is the variable usage lookup table.", ["cat"]={tag="list", n=2, "warn", "usage"}, ["run"]=function(temp, state, nodes, lookup)
	local arity, getArity = {}
	getArity = function(symbol)
		local var = getVar1(lookup, symbol["var"])
		local ari = arity[var]
		if ari ~= nil then
			return ari
		elseif n1(var["defs"]) ~= 1 then
			return false
		else
			arity[var] = false
			local defData = car1(var["defs"])
			local def = defData["value"]
			if type1(defData) == "var" then
				ari = false
			elseif type1(def) == "symbol" then
				ari = getArity(def)
			elseif type1(def) == "list" and (type1((car1(def))) == "symbol" and car1(def)["var"] == builtins1["lambda"]) then
				local args = nth1(def, 2)
				if any1(function(x)
					return x["var"]["is-variadic"]
				end, args) then
					ari = false
				else
					ari = n1(args)
				end
			else
				ari = false
			end
			arity[var] = ari
			return ari
		end
	end
	return visitBlock1(nodes, 1, function(node)
		if type1(node) == "list" and type1((car1(node))) == "symbol" then
			local arity1 = getArity(car1(node))
			if arity1 and arity1 < n1(node) - 1 then
				return putNodeWarning_21_1(state["logger"], "Calling " .. symbol_2d3e_string1(car1(node)) .. " with " .. tonumber1(n1(node) - 1) .. " arguments, expected " .. tonumber1(arity1), node, nil, getSource1(node), "Called here")
			else
				return nil
			end
		else
			return nil
		end
	end)
end}
deprecated1 = {["name"]="deprecated", ["help"]="Produce a warning whenever a deprecated variable is used.", ["cat"]={tag="list", n=2, "warn", "usage"}, ["run"]=function(temp, state, nodes)
	local temp1 = n1(nodes)
	local temp2 = 1
	while temp2 <= temp1 do
		local node = nodes[temp2]
		local defVar = node["def-var"]
		visitNode1(node, function(node1)
			if type1(node1) == "symbol" then
				local var = node1["var"]
				if var ~= defVar and var["deprecated"] then
					return putNodeWarning_21_1(state["logger"], (function()
						if string_3f_1(var["deprecated"]) then
							return format1("%s is deprecated: %s", node1["contents"], var["deprecated"])
						else
							return format1("%s is deprecated.", node1["contents"])
						end
					end)(), node1, nil, getSource1(node1), "")
				else
					return nil
				end
			else
				return nil
			end
		end)
		temp2 = temp2 + 1
	end
	return nil
end}
documentation1 = {["name"]="documentation", ["help"]="Ensure doc comments are valid.", ["cat"]={tag="list", n=1, "warn"}, ["run"]=function(temp, state, nodes)
	local validate, temp1 = function(node, var, doc, kind)
		local temp2 = parseDocstring1(doc)
		local temp3 = n1(temp2)
		local temp4 = 1
		while temp4 <= temp3 do
			local tok = temp2[temp4]
			if tok["kind"] == "link" then
				if not get1(var["scope"], tok["contents"]) then
					putNodeWarning_21_1(state["logger"], format1("%s is not defined.", quoted1(tok["contents"])), node, nil, getSource1(node), format1("Referenced in %s.", kind))
				end
			end
			temp4 = temp4 + 1
		end
		return nil
	end, n1(nodes)
	local temp2 = 1
	while temp2 <= temp1 do
		local node = nodes[temp2]
		local var = node["def-var"]
		if var then
			if string_3f_1(var["doc"]) then
				validate(node, var, var["doc"], "docstring")
			end
			if string_3f_1(var["deprecated"]) then
				validate(node, var, var["deprecated"], "deprecation message")
			end
		end
		temp2 = temp2 + 1
	end
	return nil
end}
unusedVars1 = {["name"]="unused-vars", ["help"]="Ensure all non-exported NODES are used.", ["cat"]={tag="list", n=1, "warn"}, ["level"]=2, ["run"]=function(temp, state, _5f_, lookup)
	local unused = {tag="list", n=0}
	local temp1 = lookup["usage-vars"]
	local temp2, entry = next1(temp1)
	while temp2 ~= nil do
		if not (n1(entry["usages"]) > 0 or n1(entry["soft"]) > 0 or temp2["name"] == "_" or temp2["display-name"] ~= nil or empty_3f_1(entry["defs"])) then
			local def = car1(entry["defs"])["node"]
			if def["def-var"] == nil or temp2["kind"] ~= "macro" and not temp2["scope"]["exported"][temp2["name"]] then
				pushCdr_21_1(unused, list1(temp2, def))
			end
		end
		temp2, entry = next1(temp1, temp2)
	end
	sort1(unused, function(node1, node2)
		local source1, source2 = getSource1(cadr1(node1)), getSource1(cadr1(node2))
		if source1["name"] == source2["name"] then
			if source1["start"]["line"] == source2["start"]["line"] then
				return source1["start"]["column"] < source2["start"]["column"]
			else
				return source1["start"]["line"] < source2["start"]["line"]
			end
		else
			return source1["name"] < source2["name"]
		end
	end)
	local temp1 = n1(unused)
	local temp2 = 1
	while temp2 <= temp1 do
		local pair = unused[temp2]
		putNodeWarning_21_1(state["logger"], format1("%s is not used.", quoted1(car1(pair)["name"])), cadr1(pair), nil, getSource1(cadr1(pair)), "Defined here")
		temp2 = temp2 + 1
	end
	return nil
end}
macroUsage1 = {["name"]="macro-usage", ["help"]="Determines whether any macro is used.", ["cat"]={tag="list", n=1, "warn"}, ["run"]=function(temp, state, nodes)
	return visitBlock1(nodes, 1, function(node)
		if type1(node) == "symbol" then
			if node["var"]["kind"] == "macro" then
				return putNodeWarning_21_1(state["logger"], format1("The macro %s is not expanded", quoted1(node["contents"])), node, "This macro is used in such a way that it'll be called as a normal function\ninstead of expanding into executable code. Sometimes this may be intentional,\nbut more often than not it is the result of a misspelled variable name.", getSource1(node), "macro used here")
			else
				return nil
			end
		else
			return nil
		end
	end)
end}
analyse1 = function(nodes, state, passes)
	local lookup = {}
	local temp = passes["normal"]
	local temp1 = n1(temp)
	local temp2 = 1
	while temp2 <= temp1 do
		runPass1(temp[temp2], state, nil, nodes, lookup)
		temp2 = temp2 + 1
	end
	runPass1(tagUsage1, state, nil, nodes, lookup, visitEagerExported_3f_1)
	local temp = passes["usage"]
	local temp1 = n1(temp)
	local temp2 = 1
	while temp2 <= temp1 do
		runPass1(temp[temp2], state, nil, nodes, lookup)
		temp2 = temp2 + 1
	end
	return nil
end
default2 = function()
	return {["normal"]=list1(documentation1, checkOrder1, deprecated1, macroUsage1), ["usage"]=list1(checkArity1, unusedVars1)}
end
append_21_1 = function(writer, text, position)
	local temp = type1(text)
	if temp ~= "string" then
		error1(format1("bad argument %s (expected %s, got %s)", "text", "string", temp), 2)
	end
	if position then
		local line = writer["lines"][writer["line"]]
		if not line then
			line = {}
			writer["lines"][writer["line"]] = line
		end
		line[position] = true
	end
	if writer["tabs-pending"] then
		writer["tabs-pending"] = false
		pushCdr_21_1(writer["out"], rep1("\9", writer["indent"]))
	end
	return pushCdr_21_1(writer["out"], text)
end
line_21_1 = function(writer, text, force)
	if text then
		append_21_1(writer, text)
	end
	if force or not writer["tabs-pending"] then
		writer["tabs-pending"] = true
		_5e7e_1(writer, on_21_1("line"), succ1)
		return pushCdr_21_1(writer["out"], "\n")
	else
		return nil
	end
end
nextBlock_21_1 = function(writer, text)
	writer["indent"] = writer["indent"] - 1
	line_21_1(writer, text)
	return _5e7e_1(writer, on_21_1("indent"), succ1)
end
endBlock_21_1 = function(writer, text)
	writer["indent"] = writer["indent"] - 1
	return line_21_1(writer, text)
end
pushNode_21_1 = function(writer, node)
	local range = getSource1(node)
	if range then
		pushCdr_21_1(writer["node-stack"], range)
		writer["active-pos"] = range
		return nil
	else
		return nil
	end
end
popNode_21_1 = function(writer, node)
	local range = getSource1(node)
	if range then
		local stack = writer["node-stack"]
		if last1(stack) ~= range then
			error1("Incorrect node popped")
		end
		popLast_21_1(stack)
		writer["active-pos"] = last1(stack)
		return nil
	else
		return nil
	end
end
estimateLength1 = function(node, max)
	local tag = type1(node)
	if tag == "string" or tag == "number" or tag == "symbol" or tag == "key" then
		return n1(tostring1(node["contents"]))
	elseif tag == "list" then
		local sum, i = 2, 1
		while sum <= max and i <= n1(node) do
			sum = sum + estimateLength1(nth1(node, i), max - sum)
			if i > 1 then
				sum = sum + 1
			end
			i = i + 1
		end
		return sum
	else
		return error1("Unknown tag " .. tag, 0)
	end
end
expression1 = function(node, writer)
	local tag = type1(node)
	if tag == "string" then
		return append_21_1(writer, quoted1(node["value"]))
	elseif tag == "number" then
		return append_21_1(writer, tostring1(node["value"]))
	elseif tag == "key" then
		return append_21_1(writer, ":" .. node["value"])
	elseif tag == "symbol" then
		return append_21_1(writer, node["contents"])
	elseif tag == "list" then
		append_21_1(writer, "(")
		if empty_3f_1(node) then
			return append_21_1(writer, ")")
		else
			local newline, max = false, 60 - estimateLength1(car1(node), 60)
			expression1(car1(node), writer)
			if max <= 0 then
				newline = true
				_5e7e_1(writer, on_21_1("indent"), succ1)
			end
			local temp = n1(node)
			local temp1 = 2
			while temp1 <= temp do
				local entry = nth1(node, temp1)
				if not newline and max > 0 then
					max = max - estimateLength1(entry, max)
					if max <= 0 then
						newline = true
						_5e7e_1(writer, on_21_1("indent"), succ1)
					end
				end
				if newline then
					line_21_1(writer)
				else
					append_21_1(writer, " ")
				end
				expression1(entry, writer)
				temp1 = temp1 + 1
			end
			if newline then
				writer["indent"] = writer["indent"] - 1
			end
			return append_21_1(writer, ")")
		end
	else
		return error1("Unknown tag " .. tag, 0)
	end
end
block1 = function(list, writer)
	local temp = n1(list)
	local temp1 = 1
	while temp1 <= temp do
		expression1(list[temp1], writer)
		line_21_1(writer)
		temp1 = temp1 + 1
	end
	return nil
end
partAll1 = function(xs, i, e, f)
	while true do
		if i > e then
			return true
		elseif f(nth1(xs, i)) then
			i = i + 1
		else
			return false
		end
	end
end
recurDirect_3f_1 = function(state, var)
	local rec = state["rec-lookup"][var]
	return rec and (rec["var"] == 0 and rec["direct"] == 1)
end
notCond_3f_1 = function(first, second)
	return n1(first) == 2 and (builtin_3f_1(nth1(first, 2), "false") and (n1(second) == 2 and (builtin_3f_1(nth1(second, 1), "true") and builtin_3f_1(nth1(second, 2), "true"))))
end
andCond_3f_1 = function(lookup, first, second, test)
	local branch, last, temp = car1(first), nth1(second, 2), n1(first) == 2
	return temp and (n1(second) == 2 and (not lookup[nth1(first, 2)]["stmt"] and (builtin_3f_1(car1(second), "true") and (type1(last) == "symbol" and (type1(branch) == "symbol" and branch["var"] == last["var"] or test and (not lookup[branch]["stmt"] and last["var"] == builtins1["false"]))))))
end
orCond_3f_1 = function(lookup, branch, test)
	local head, tail, temp = car1(branch), nth1(branch, 2), n1(branch) == 2
	return temp and (type1(tail) == "symbol" and (type1(head) == "symbol" and head["var"] == tail["var"] or test and (not lookup[head]["stmt"] and tail["var"] == builtins1["true"])))
end
visitNode3 = function(lookup, state, node, stmt, test, recur)
	local cat
	local temp = type1(node)
	if temp == "string" then
		cat = {["category"]="const", ["prec"]=100}
	elseif temp == "number" then
		cat = {["category"]="const", ["prec"]=100}
	elseif temp == "key" then
		cat = {["category"]="const", ["prec"]=100}
	elseif temp == "symbol" then
		cat = {["category"]="const"}
	elseif temp == "list" then
		local head = car1(node)
		local temp1 = type1(head)
		if temp1 == "symbol" then
			local func = head["var"]
			if func == builtins1["lambda"] then
				visitNodes1(lookup, state, node, 3, true)
				cat = {["category"]="lambda", ["prec"]=100}
			elseif func == builtins1["cond"] then
				local temp2 = n1(node)
				local temp3 = 2
				while temp3 <= temp2 do
					local case = nth1(node, temp3)
					visitNode3(lookup, state, car1(case), true, true)
					visitNodes1(lookup, state, case, 2, true, test, recur)
					temp3 = temp3 + 1
				end
				if n1(node) == 3 and notCond_3f_1(nth1(node, 2), nth1(node, 3)) then
					addParen1(lookup, car1(nth1(node, 2)), 11)
					cat = {["category"]="not", ["stmt"]=lookup[car1(nth1(node, 2))]["stmt"], ["prec"]=11}
				elseif n1(node) == 3 and andCond_3f_1(lookup, nth1(node, 2), nth1(node, 3), test) then
					addParen1(lookup, nth1(nth1(node, 2), 1), 2)
					addParen1(lookup, nth1(nth1(node, 2), 2), 2)
					cat = {["category"]="and", ["prec"]=2}
				else
					local temp2
					if n1(node) >= 3 then
						if partAll1(node, 2, n1(node) - 2, function(temp3)
							return orCond_3f_1(lookup, temp3, test)
						end) then
							local first, second = nth1(node, n1(node) - 1), nth1(node, n1(node))
							temp2 = notCond_3f_1(first, second) or andCond_3f_1(lookup, first, second, test) or orCond_3f_1(lookup, first, test) and (n1(second) == 2 and (builtin_3f_1(car1(second), "true") and not lookup[nth1(second, 2)]["stmt"]))
						else
							temp2 = false
						end
					else
						temp2 = false
					end
					if temp2 then
						local len, first, second = n1(node), nth1(node, n1(node) - 1), nth1(node, n1(node))
						local temp2 = len - 2
						local temp3 = 2
						while temp3 <= temp2 do
							addParen1(lookup, car1(nth1(node, temp3)), 1)
							temp3 = temp3 + 1
						end
						if notCond_3f_1(first, second) then
							addParen1(lookup, nth1(first, 1), 11)
							cat = {["category"]="or", ["prec"]=1, ["kind"]="not"}
						elseif andCond_3f_1(lookup, first, second, test) then
							addParen1(lookup, nth1(first, 1), 2)
							addParen1(lookup, nth1(first, 2), 2)
							cat = {["category"]="or", ["prec"]=1, ["kind"]="and"}
						else
							addParen1(lookup, nth1(first, 1), 1)
							addParen1(lookup, nth1(second, 2), 1)
							cat = {["category"]="or", ["prec"]=1, ["kind"]="or"}
						end
					elseif n1(node) == 3 and (n1(nth1(node, 2)) == 1 and (builtin_3f_1(car1(nth1(node, 3)), "true") and n1(nth1(node, 3)) > 1)) then
						addParen1(lookup, car1(nth1(node, 2)), 11)
						cat = {["category"]="unless", ["stmt"]=true}
					else
						cat = {["category"]="cond", ["stmt"]=true}
					end
				end
			elseif func == builtins1["set!"] then
				local def, var = nth1(node, 3), nth1(node, 2)["var"]
				if type1(def) == "list" and (builtin_3f_1(car1(def), "lambda") and state["rec-lookup"][var]) then
					local recur1 = {["var"]=var, ["def"]=def}
					visitNodes1(lookup, state, def, 3, true, nil, recur1)
					if not recur1["tail"] then
						error1("Expected tail recursive function from letrec")
					end
					lookup[def] = {["category"]="lambda", ["prec"]=100, ["recur"]=visitRecur1(lookup, recur1)}
				else
					visitNode3(lookup, state, def, true)
				end
				cat = {["category"]="set!"}
			elseif func == builtins1["quote"] then
				visitQuote3(lookup, node)
				cat = {["category"]="quote", ["prec"]=100}
			elseif func == builtins1["syntax-quote"] then
				visitSyntaxQuote1(lookup, state, nth1(node, 2), 1)
				cat = {["category"]="syntax-quote", ["prec"]=100}
			elseif func == builtins1["unquote"] then
				cat = error1("unquote should never appear", 0)
			elseif func == builtins1["unquote-splice"] then
				cat = error1("unquote should never appear", 0)
			elseif func == builtins1["define"] or func == builtins1["define-macro"] then
				local def = nth1(node, n1(node))
				if type1(def) == "list" and builtin_3f_1(car1(def), "lambda") then
					local recur1 = {["var"]=node["def-var"], ["def"]=def}
					visitNodes1(lookup, state, def, 3, true, nil, recur1)
					lookup[def] = (function()
						if recur1["tail"] then
							return {["category"]="lambda", ["prec"]=100, ["recur"]=visitRecur1(lookup, recur1)}
						else
							return {["category"]="lambda", ["prec"]=100}
						end
					end)()
				else
					visitNode3(lookup, state, def, true)
				end
				cat = {["category"]="define"}
			elseif func == builtins1["define-native"] then
				cat = {["category"]="define-native"}
			elseif func == builtins1["import"] then
				cat = {["category"]="import"}
			elseif func == builtins1["struct-literal"] then
				visitNodes1(lookup, state, node, 2, false)
				cat = {["category"]="struct-literal", ["prec"]=100}
			elseif func == builtins1["true"] then
				visitNodes1(lookup, state, node, 1, false)
				lookup[head]["parens"] = true
				cat = {["category"]="call"}
			elseif func == builtins1["false"] then
				visitNodes1(lookup, state, node, 1, false)
				lookup[head]["parens"] = true
				cat = {["category"]="call"}
			elseif func == builtins1["nil"] then
				visitNodes1(lookup, state, node, 1, false)
				lookup[head]["parens"] = true
				cat = {["category"]="call"}
			else
				local meta = func["kind"] == "native" and state["meta"][func["unique-name"]]
				local metaTy = type1(meta)
				if metaTy == "nil" then
				elseif metaTy == "boolean" then
				elseif metaTy == "expr" then
				elseif metaTy == "stmt" then
					if not stmt then
						meta = nil
					end
				elseif metaTy == "var" then
					meta = nil
				else
					error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(metaTy) .. ", but none matched.\n" .. "  Tried: `\"nil\"`\n  Tried: `\"boolean\"`\n  Tried: `\"expr\"`\n  Tried: `\"stmt\"`\n  Tried: `\"var\"`")
				end
				local temp2
				if meta then
					if meta["fold"] then
						temp2 = n1(node) - 1 >= meta["count"]
					else
						temp2 = n1(node) - 1 == meta["count"]
					end
				else
					temp2 = false
				end
				if temp2 then
					visitNodes1(lookup, state, node, 1, false)
					local prec, precs = meta["prec"], meta["precs"]
					if prec or precs then
						addParens1(lookup, node, 2, prec, precs)
					end
					cat = {["category"]="call-meta", ["meta"]=meta, ["stmt"]=metaTy == "stmt", ["prec"]=prec}
				elseif recur and func == recur["var"] then
					recur["tail"] = true
					visitNodes1(lookup, state, node, 1, false)
					cat = {["category"]="call-tail", ["recur"]=recur, ["stmt"]=true}
				elseif stmt and recurDirect_3f_1(state, func) then
					local rec = state["rec-lookup"][func]
					local lam = rec["lambda"]
					local recur1 = lookup[lam]["recur"]
					if not recur1 then
						print1("Cannot find recursion for ", func["name"])
					end
					local temp2 = zipArgs1(cadr1(lam), 1, node, 2)
					local temp3 = n1(temp2)
					local temp4 = 1
					while temp4 <= temp3 do
						local zip = temp2[temp4]
						local args, vals = car1(zip), cadr1(zip)
						if n1(vals) == 0 then
						elseif n1(vals) > 1 or car1(args)["is-variadic"] then
							local temp5 = n1(vals)
							local temp6 = 1
							while temp6 <= temp5 do
								visitNode3(lookup, state, vals[temp6], false)
								temp6 = temp6 + 1
							end
						else
							visitNode3(lookup, state, car1(vals), true)
						end
						temp4 = temp4 + 1
					end
					lookup[rec["set!"]] = {["category"]="void"}
					state["var-skip"][func] = true
					cat = {["category"]="call-recur", ["recur"]=recur1}
				else
					visitNodes1(lookup, state, node, 1, false)
					cat = {["category"]="call-symbol"}
				end
			end
		elseif temp1 == "list" then
			if n1(node) == 2 and (builtin_3f_1(car1(head), "lambda") and (n1(head) == 3 and (n1(nth1(head, 2)) == 1 and (type1((nth1(head, 3))) == "symbol" and nth1(head, 3)["var"] == car1(nth1(head, 2))["var"])))) then
				if visitNode3(lookup, state, nth1(node, 2), stmt, test)["stmt"] then
					lookup[head] = {["category"]="lambda", ["prec"]=100, ["parens"]=true}
					visitNode3(lookup, state, nth1(head, 3), true, false)
					cat = {["category"]="call-lambda", ["stmt"]=stmt}
				else
					cat = {["category"]="wrap-value"}
				end
			else
				local temp2
				if n1(node) == 2 then
					if builtin_3f_1(car1(head), "lambda") then
						if n1(head) == 3 then
							if n1(nth1(head, 2)) == 1 then
								local elem = nth1(head, 3)
								temp2 = type1(elem) == "list" and (builtin_3f_1(car1(elem), "cond") and (type1((car1(nth1(elem, 2)))) == "symbol" and car1(nth1(elem, 2))["var"] == car1(nth1(head, 2))["var"]))
							else
								temp2 = false
							end
						else
							temp2 = false
						end
					else
						temp2 = false
					end
				else
					temp2 = false
				end
				if temp2 then
					if visitNode3(lookup, state, nth1(node, 2), stmt, test)["stmt"] then
						lookup[head] = {["category"]="lambda", ["prec"]=100, ["parens"]=true}
						visitNode3(lookup, state, nth1(head, 3), true, test, recur)
						cat = {["category"]="call-lambda", ["stmt"]=stmt}
					else
						local res = visitNode3(lookup, state, nth1(head, 3), true, test, recur)
						local ty, unused_3f_ = res["category"], function()
							local condNode, var, working = nth1(head, 3), car1(nth1(head, 2))["var"], true
							local temp2 = n1(condNode)
							local temp3 = 2
							while temp3 <= temp2 do
								if working then
									local case = nth1(condNode, temp3)
									local temp4 = n1(case)
									local temp5 = 2
									while temp5 <= temp4 do
										if working then
											local sub = nth1(case, temp5)
											if not (type1(sub) == "symbol") then
												working = not nodeContainsVar_3f_1(sub, var)
											end
										end
										temp5 = temp5 + 1
									end
								end
								temp3 = temp3 + 1
							end
							return working
						end
						lookup[head] = {["category"]="lambda", ["prec"]=100, ["parens"]=true}
						if ty == "and" and unused_3f_() then
							addParen1(lookup, nth1(node, 2), 2)
							cat = {["category"]="and-lambda", ["prec"]=2}
						elseif ty == "or" and unused_3f_() then
							addParen1(lookup, nth1(node, 2), 1)
							cat = {["category"]="or-lambda", ["prec"]=1, ["kind"]=res["kind"]}
						else
							cat = {["category"]="call-lambda", ["stmt"]=stmt}
						end
					end
				elseif builtin_3f_1(car1(head), "lambda") then
					visitNodes1(lookup, state, head, 3, true, test, recur)
					local temp2 = zipArgs1(cadr1(head), 1, node, 2)
					local temp3 = n1(temp2)
					local temp4 = 1
					while temp4 <= temp3 do
						local zip = temp2[temp4]
						local args, vals = car1(zip), cadr1(zip)
						if n1(vals) == 0 then
						elseif n1(vals) > 1 or car1(args)["is-variadic"] then
							local temp5 = n1(vals)
							local temp6 = 1
							while temp6 <= temp5 do
								visitNode3(lookup, state, vals[temp6], false)
								temp6 = temp6 + 1
							end
						else
							visitNode3(lookup, state, car1(vals), true)
						end
						temp4 = temp4 + 1
					end
					cat = {["category"]="call-lambda", ["stmt"]=stmt}
				else
					visitNodes1(lookup, state, node, 1, false)
					addParen1(lookup, car1(node), 100)
					cat = {["category"]="call"}
				end
			end
		else
			visitNodes1(lookup, state, node, 1, false)
			lookup[car1(node)]["parens"] = true
			cat = {["category"]="call"}
		end
	else
		cat = error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"key\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`")
	end
	if cat == nil then
		error1("Node returned nil " .. pretty1(node), 0)
	end
	lookup[node] = cat
	return cat
end
visitNodes1 = function(lookup, state, nodes, start, stmt, test, recur)
	local len = n1(nodes)
	local temp = start
	while temp <= len do
		visitNode3(lookup, state, nth1(nodes, temp), stmt, test and temp == len, temp == len and recur)
		temp = temp + 1
	end
	return nil
end
visitSyntaxQuote1 = function(lookup, state, node, level)
	if level == 0 then
		return visitNode3(lookup, state, node, false)
	else
		local cat
		local temp = type1(node)
		if temp == "string" then
			cat = {["category"]="quote-const"}
		elseif temp == "number" then
			cat = {["category"]="quote-const"}
		elseif temp == "key" then
			cat = {["category"]="quote-const"}
		elseif temp == "symbol" then
			cat = {["category"]="quote-const"}
		elseif temp == "list" then
			local temp1 = car1(node)
			if eq_3f_1(temp1, {tag="symbol", contents="unquote"}) then
				visitSyntaxQuote1(lookup, state, nth1(node, 2), level - 1)
				cat = {["category"]="unquote"}
			elseif eq_3f_1(temp1, {tag="symbol", contents="unquote-splice"}) then
				visitSyntaxQuote1(lookup, state, nth1(node, 2), level - 1)
				cat = {["category"]="unquote-splice"}
			elseif eq_3f_1(temp1, {tag="symbol", contents="syntax-quote"}) then
				local temp2 = n1(node)
				local temp3 = 1
				while temp3 <= temp2 do
					visitSyntaxQuote1(lookup, state, node[temp3], level + 1)
					temp3 = temp3 + 1
				end
				cat = {["category"]="quote-list"}
			else
				local hasSplice = false
				local temp2 = n1(node)
				local temp3 = 1
				while temp3 <= temp2 do
					if visitSyntaxQuote1(lookup, state, node[temp3], level)["category"] == "unquote-splice" then
						hasSplice = true
					end
					temp3 = temp3 + 1
				end
				if hasSplice then
					cat = {["category"]="quote-splice", ["stmt"]=true}
				else
					cat = {["category"]="quote-list"}
				end
			end
		else
			cat = error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"key\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`")
		end
		if cat == nil then
			error1("Node returned nil " .. pretty1(node), 0)
		end
		lookup[node] = cat
		return cat
	end
end
visitQuote3 = function(lookup, node)
	if type1(node) == "list" then
		local temp = n1(node)
		local temp1 = 1
		while temp1 <= temp do
			visitQuote3(lookup, (node[temp1]))
			temp1 = temp1 + 1
		end
		lookup[node] = {["category"]="quote-list"}
		return nil
	else
		lookup[node] = {["category"]="quote-const"}
		return nil
	end
end
visitRecur1 = function(lookup, recur)
	local lam = recur["def"]
	local temp
	if n1(lam) == 3 then
		local child = nth1(lam, 3)
		temp = type1(child) == "list" and (builtin_3f_1(car1(child), "cond") and (n1(child) == 3 and (builtin_3f_1(car1(nth1(child, 3)), "true") and not lookup[car1(nth1(child, 2))]["stmt"])))
	else
		temp = false
	end
	if temp then
		local fstCase, sndCase = nth1(nth1(lam, 3), 2), nth1(nth1(lam, 3), 3)
		local fst, snd = n1(fstCase) >= 2 and justRecur_3f_1(lookup, last1(fstCase), recur), n1(sndCase) >= 2 and justRecur_3f_1(lookup, last1(sndCase), recur)
		if fst and snd then
			recur["category"] = "forever"
		elseif fst then
			recur["category"] = "while"
		elseif snd then
			recur["category"] = "while-not"
		else
			recur["category"] = "forever"
		end
	else
		recur["category"] = "forever"
	end
	return recur
end
justRecur_3f_1 = function(lookup, node, recur)
	while true do
		if type1(node) == "list" then
			local cat, head = lookup[node], car1(node)
			if cat["category"] == "call-tail" then
				if cat["recur"] ~= recur then
					error1("Incorrect recur")
				end
				return true
			elseif type1(head) == "list" and builtin_3f_1(car1(head), "lambda") then
				local temp = n1(head) >= 3
				if temp then
					node = last1(head)
				else
					return temp
				end
			elseif builtin_3f_1(head, "cond") then
				local found = true
				local temp = n1(node)
				local temp1 = 2
				while temp1 <= temp do
					if found then
						local case = nth1(node, temp1)
						found = n1(case) >= 2 and justRecur_3f_1(lookup, last1(case), recur)
					end
					temp1 = temp1 + 1
				end
				return found
			else
				return false
			end
		else
			return false
		end
	end
end
addParens1 = function(lookup, nodes, start, prec, precs)
	local temp = n1(nodes)
	local temp1 = start
	while temp1 <= temp do
		local childCat = lookup[nth1(nodes, temp1)]
		if childCat["prec"] and childCat["prec"] <= (function()
			if precs then
				return nth1(precs, temp1 - 1)
			else
				return prec
			end
		end)() then
			childCat["parens"] = true
		end
		temp1 = temp1 + 1
	end
	return nil
end
addParen1 = function(lookup, node, prec)
	local childCat = lookup[node]
	if childCat["prec"] and childCat["prec"] <= prec then
		childCat["parens"] = true
		return nil
	else
		return nil
	end
end
categoriseNodes1 = {["name"]="categorise-nodes", ["help"]="Categorise a group of NODES, annotating their appropriate node type.", ["cat"]={tag="list", n=1, "categorise"}, ["run"]=function(temp, compiler, nodes, state)
	return visitNodes1(state["cat-lookup"], state, nodes, 1, true)
end}
categoriseNode1 = {["name"]="categorise-node", ["help"]="Categorise a NODE, annotating it's appropriate node type.", ["cat"]={tag="list", n=1, "categorise"}, ["run"]=function(temp, compiler, node, state, stmt)
	return visitNode3(state["cat-lookup"], state, node, stmt)
end}
visitQuote4 = function(node, level, lookup)
	while true do
		if level == 0 then
			return visitNode4(node, nil, nil, lookup)
		else
			local tag = type1(node)
			if tag == "string" or tag == "number" or tag == "key" or tag == "symbol" then
				return nil
			elseif tag == "list" then
				local first = nth1(node, 1)
				if type1(node) == "symbol" then
					if first["contents"] == "unquote" or first["contents"] == "unquote-splice" then
						node, level = nth1(node, 2), level - 1
					elseif first["contents"] == "syntax-quote" then
						node, level = nth1(node, 2), level + 1
					else
						local temp = n1(node)
						local temp1 = 1
						while temp1 <= temp do
							visitQuote4(node[temp1], level, lookup)
							temp1 = temp1 + 1
						end
						return nil
					end
				else
					local temp = n1(node)
					local temp1 = 1
					while temp1 <= temp do
						visitQuote4(node[temp1], level, lookup)
						temp1 = temp1 + 1
					end
					return nil
				end
			elseif error1 then
				return "Unknown tag " .. tag
			else
				_error("unmatched item")
			end
		end
	end
end
visitNode4 = function(node, parents, active, lookup)
	while true do
		local temp = type1(node)
		if temp == "string" then
			return nil
		elseif temp == "number" then
			return nil
		elseif temp == "key" then
			return nil
		elseif temp == "symbol" then
			local state = lookup[node["var"]]
			if state then
				return _5e7e_1(state, on_21_1("var"), succ1)
			else
				return nil
			end
		elseif temp == "list" then
			local head = car1(node)
			local temp1 = type1(head)
			if temp1 == "symbol" then
				local func = head["var"]
				if func["kind"] ~= "builtin" then
					local state = lookup[func]
					if not state then
					elseif active == state then
						_5e7e_1(state, on_21_1("recur"), succ1)
					elseif parents and parents[state["parent"]] then
						_5e7e_1(state, on_21_1("direct"), succ1)
					else
						_5e7e_1(state, on_21_1("var"), succ1)
					end
					return visitNodes2(node, 2, nil, lookup)
				elseif func == builtins1["lambda"] then
					return visitBlock3(node, 3, nil, nil, lookup)
				elseif func == builtins1["set!"] then
					local var = nth1(node, 2)["var"]
					local state, val = lookup[var], nth1(node, 3)
					if state and (state["lambda"] == nil and (parents and (parents[state["parent"]] and (type1(val) == "list" and builtin_3f_1(car1(val), "lambda"))))) then
						state["lambda"] = val
						state["set!"] = node
						visitBlock3(val, 3, nil, state, lookup)
						if state["recur"] == 0 then
							lookup[var] = nil
							return nil
						else
							return nil
						end
					else
						lookup[var] = nil
						node, parents, active = val, nil, nil
					end
				elseif func == builtins1["cond"] then
					local temp2 = n1(node)
					local temp3 = 2
					while temp3 <= temp2 do
						local case = nth1(node, temp3)
						visitNode4(car1(case), nil, nil, lookup)
						visitBlock3(case, 2, nil, active, lookup)
						temp3 = temp3 + 1
					end
					return nil
				elseif func == builtins1["quote"] then
					return nil
				elseif func == builtins1["syntax-quote"] then
					return visitQuote4(nth1(node, 2), 1, lookup)
				elseif func == builtins1["unquote"] or func == builtins1["unquote-splice"] then
					return error1("unquote/unquote-splice should never appear here", 0)
				elseif func == builtins1["define"] or func == builtins1["define-macro"] then
					node, parents, active = nth1(node, n1(node)), nil, nil
				elseif func == builtins1["define-native"] then
					return nil
				elseif func == builtins1["import"] then
					return nil
				elseif func == builtins1["struct-literal"] then
					return visitNodes2(node, 2, nil, lookup)
				else
					return error1("Unknown builtin for variable " .. func["name"], 0)
				end
			elseif temp1 == "list" then
				local first = car1(node)
				if type1(first) == "list" and builtin_3f_1(car1(first), "lambda") then
					local args = nth1(first, 2)
					local temp2 = n1(args)
					local temp3 = 1
					while temp3 <= temp2 do
						local val = nth1(node, temp3 + 1)
						if val == nil or builtin_3f_1(val, "nil") then
							lookup[nth1(args, temp3)["var"]] = {["recur"]=0, ["var"]=0, ["direct"]=0, ["parent"]=node, ["set!"]=nil, ["lambda"]=nil}
						end
						temp3 = temp3 + 1
					end
					if parents then
						parents[node] = true
					else
						parents = {[node]=true}
					end
					visitBlock3(first, 3, parents, active, lookup)
					parents[node] = nil
					return visitNodes2(node, 2, nil, lookup)
				else
					return visitNodes2(node, 1, nil, lookup)
				end
			else
				return visitNodes2(node, 1, nil, lookup)
			end
		else
			return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"key\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`")
		end
	end
end
visitNodes2 = function(node, start, parents, lookup)
	local temp = n1(node)
	local temp1 = start
	while temp1 <= temp do
		visitNode4(nth1(node, temp1), parents, nil, lookup)
		temp1 = temp1 + 1
	end
	return nil
end
visitBlock3 = function(node, start, parents, active, lookup)
	local temp = n1(node) - 1
	local temp1 = start
	while temp1 <= temp do
		visitNode4(nth1(node, temp1), parents, nil, lookup)
		temp1 = temp1 + 1
	end
	if n1(node) >= start then
		return visitNode4(last1(node), parents, active, lookup)
	else
		return nil
	end
end
letrecNodes1 = {["name"]="letrec-nodes", ["help"]="Find letrec constructs in a list of NODES", ["cat"]={tag="list", n=1, "categorise"}, ["run"]=function(temp, compiler, nodes, state)
	return visitNodes2(nodes, 1, nil, state["rec-lookup"])
end}
letrecNode1 = {["name"]="letrec-node", ["help"]="Find letrec constructs in a node", ["cat"]={tag="list", n=1, "categorise"}, ["run"]=function(temp, compiler, node, state)
	return visitNode4(node, nil, nil, state["rec-lookup"])
end}
keywords1 = createLookup1({tag="list", n=21, "and", "break", "do", "else", "elseif", "end", "false", "for", "function", "if", "in", "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while"})
escape1 = function(name)
	if name == "" then
		return "_e"
	elseif keywords1[name] then
		return "_e" .. name
	elseif find1(name, "^%a%w*$") then
		return name
	else
		local out
		if find1(sub1(name, 1, 1), "%d") then
			out = "_e"
		else
			out = ""
		end
		local upper, esc = false, false
		local temp = n1(name)
		local temp1 = 1
		while temp1 <= temp do
			local char = sub1(name, temp1, temp1)
			if char == "-" and (find1((function()
				local x = temp1 - 1
				return sub1(name, x, x)
			end)(), "[%a%d']") and find1((function()
				local x = temp1 + 1
				return sub1(name, x, x)
			end)(), "[%a%d']")) then
				upper = true
			elseif find1(char, "[^%w%d]") then
				char = format1("%02x", (byte1(char)))
				upper = false
				if not esc then
					esc = true
					out = out .. "_"
				end
				out = out .. char
			else
				if esc then
					esc = false
					out = out .. "_"
				end
				if upper then
					upper = false
					char = upper1(char)
				end
				out = out .. char
			end
			temp1 = temp1 + 1
		end
		if esc then
			out = out .. "_"
		end
		return out
	end
end
pushEscapeVar_21_1 = function(var, state, forceNum)
	local temp = state["var-lookup"][var]
	if temp then
		return temp
	else
		local esc = escape1(var["display-name"] or var["name"])
		local existing = state["var-cache"][esc]
		if forceNum or existing then
			local ctr, finding = 1, true
			while finding do
				local esc_27_ = esc .. ctr
				if state["var-cache"][esc_27_] then
					ctr = ctr + 1
				else
					finding = false
					esc = esc_27_
				end
			end
		end
		state["var-cache"][esc] = true
		state["var-lookup"][var] = esc
		return esc
	end
end
popEscapeVar_21_1 = function(var, state)
	local esc = state["var-lookup"][var]
	if not esc then
		error1(var["name"] .. " has not been escaped (when popping).", 0)
	end
	state["var-cache"][esc] = nil
	state["var-lookup"][var] = nil
	return nil
end
escapeVar1 = function(var, state)
	if builtinVars1[var] then
		return var["name"]
	else
		local esc = state["var-lookup"][var]
		if not esc then
			error1(var["name"] .. " has not been escaped (at " .. (function()
				if var["node"] then
					return formatNode1(var["node"])
				else
					return "?"
				end
			end)() .. ")", 0)
		end
		return esc
	end
end
createPassState1 = function(state)
	return {["meta"]=state["meta"], ["var-cache"]=state["var-cache"], ["var-lookup"]=state["var-lookup"], ["var-skip"]={}, ["cat-lookup"]={}, ["rec-lookup"]={}}
end
breakCategories1 = {["cond"]=true, ["unless"]=true, ["call-lambda"]=true, ["call-tail"]=true}
constCategories1 = {["const"]=true, ["quote"]=true, ["quote-const"]=true}
compileNative1 = function(out, meta)
	local ty = type1(meta)
	if ty == "var" then
		return append_21_1(out, meta["contents"], out["active-pos"])
	elseif ty == "expr" or ty == "stmt" then
		append_21_1(out, "function(")
		if meta["fold"] then
			append_21_1(out, "...")
		else
			local temp = meta["count"]
			local temp1 = 1
			while temp1 <= temp do
				if not (temp1 == 1) then
					append_21_1(out, ", ")
				end
				append_21_1(out, "v" .. tonumber1(temp1))
				temp1 = temp1 + 1
			end
		end
		append_21_1(out, ") ")
		local temp = meta["fold"]
		if temp == nil then
			if type1(meta) ~= "stmt" then
				append_21_1(out, "return ")
			end
			local temp1 = meta["contents"]
			local temp2 = n1(temp1)
			local temp3 = 1
			while temp3 <= temp2 do
				local entry = temp1[temp3]
				if number_3f_1(entry) then
					append_21_1(out, "v" .. tonumber1(entry))
				else
					append_21_1(out, entry)
				end
				temp3 = temp3 + 1
			end
		elseif temp == "l" then
			append_21_1(out, "local t = ... for i = 2, _select('#', ...) do t = ")
			local temp1 = meta["contents"]
			local temp2 = n1(temp1)
			local temp3 = 1
			while temp3 <= temp2 do
				local node = temp1[temp3]
				if node == 1 then
					append_21_1(out, "t")
				elseif node == 2 then
					append_21_1(out, "_select(i, ...)")
				elseif string_3f_1(node) then
					append_21_1(out, node)
				else
					error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(node) .. ", but none matched.\n" .. "  Tried: `1`\n  Tried: `2`\n  Tried: `string?`")
				end
				temp3 = temp3 + 1
			end
			append_21_1(out, " end return t")
		elseif temp == "r" then
			append_21_1(out, "local n = _select('#', ...) local t = _select(n, ...) for i = n - 1, 1, -1 do t = ")
			local temp1 = meta["contents"]
			local temp2 = n1(temp1)
			local temp3 = 1
			while temp3 <= temp2 do
				local node = temp1[temp3]
				if node == 1 then
					append_21_1(out, "_select(i, ...)")
				elseif node == 2 then
					append_21_1(out, "t")
				elseif string_3f_1(node) then
					append_21_1(out, node)
				else
					error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(node) .. ", but none matched.\n" .. "  Tried: `1`\n  Tried: `2`\n  Tried: `string?`")
				end
				temp3 = temp3 + 1
			end
			append_21_1(out, " end return t")
		else
			error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `nil`\n  Tried: `\"l\"`\n  Tried: `\"r\"`")
		end
		return append_21_1(out, " end")
	else
		_error("unmatched item")
	end
end
compileExpression1 = function(node, out, state, ret, _ebreak)
	local catLookup = state["cat-lookup"]
	local cat = catLookup[node]
	local _5f_
	if cat then
		_5f_ = nil
	else
		_5f_ = print1("Cannot find", pretty1(node), formatNode1(node))
	end
	local catTag = cat["category"]
	pushNode_21_1(out, node)
	if catTag == "void" then
		if not (ret == "") then
			if ret then
				append_21_1(out, ret)
			end
			append_21_1(out, "nil")
		end
	elseif catTag == "const" then
		if not (ret == "") then
			if ret then
				append_21_1(out, ret, out["active-pos"])
			end
			if cat["parens"] then
				append_21_1(out, "(")
			end
			if type1(node) == "symbol" then
				append_21_1(out, escapeVar1(node["var"], state), out["active-pos"])
			elseif string_3f_1(node) then
				append_21_1(out, quoted1(node["value"]), out["active-pos"])
			elseif number_3f_1(node) then
				append_21_1(out, tostring1(node["value"]), out["active-pos"])
			elseif type1(node) == "key" then
				append_21_1(out, quoted1(node["value"]), out["active-pos"])
			else
				error1("Unknown type: " .. type1(node))
			end
			if cat["parens"] then
				append_21_1(out, ")")
			end
		end
	elseif catTag == "lambda" then
		if not (ret == "") then
			if ret then
				local pos = getSource1(node)
				append_21_1(out, ret, pos and merge1(pos, {["finish"]=pos["start"]}))
			end
			local args, variadic, i = nth1(node, 2), nil, 1
			if cat["parens"] then
				append_21_1(out, "(")
			end
			append_21_1(out, "function(")
			while i <= n1(args) and not variadic do
				if i > 1 then
					append_21_1(out, ", ")
				end
				local var = args[i]["var"]
				if var["is-variadic"] then
					append_21_1(out, "...")
					variadic = i
				else
					append_21_1(out, pushEscapeVar_21_1(var, state))
				end
				i = i + 1
			end
			line_21_1(out, ")")
			_5e7e_1(out, on_21_1("indent"), succ1)
			if variadic then
				local argsVar = pushEscapeVar_21_1(args[variadic]["var"], state)
				if variadic == n1(args) then
					line_21_1(out, "local " .. argsVar .. " = _pack(...) " .. argsVar .. ".tag = \"list\"")
				else
					line_21_1(out, "local _n = _select(\"#\", ...) - " .. tostring1((n1(args) - variadic)))
					append_21_1(out, "local " .. argsVar)
					local temp = n1(args)
					local temp1 = variadic + 1
					while temp1 <= temp do
						append_21_1(out, ", ")
						append_21_1(out, pushEscapeVar_21_1(args[temp1]["var"], state))
						temp1 = temp1 + 1
					end
					line_21_1(out)
					line_21_1(out, "if _n > 0 then")
					_5e7e_1(out, on_21_1("indent"), succ1)
					append_21_1(out, argsVar)
					line_21_1(out, " = {tag=\"list\", n=_n, _unpack(_pack(...), 1, _n)}")
					local temp = n1(args)
					local temp1 = variadic + 1
					while temp1 <= temp do
						append_21_1(out, escapeVar1(args[temp1]["var"], state))
						if temp1 < n1(args) then
							append_21_1(out, ", ")
						end
						temp1 = temp1 + 1
					end
					line_21_1(out, " = select(_n + 1, ...)")
					nextBlock_21_1(out, "else")
					append_21_1(out, argsVar)
					line_21_1(out, " = {tag=\"list\", n=0}")
					local temp = n1(args)
					local temp1 = variadic + 1
					while temp1 <= temp do
						append_21_1(out, escapeVar1(args[temp1]["var"], state))
						if temp1 < n1(args) then
							append_21_1(out, ", ")
						end
						temp1 = temp1 + 1
					end
					line_21_1(out, " = ...")
					endBlock_21_1(out, "end")
				end
			end
			if cat["recur"] then
				compileRecur1(cat["recur"], out, state, "return ")
			else
				compileBlock1(node, out, state, 3, "return ")
			end
			out["indent"] = out["indent"] - 1
			local temp = n1(args)
			local temp1 = 1
			while temp1 <= temp do
				popEscapeVar_21_1(args[temp1]["var"], state)
				temp1 = temp1 + 1
			end
			append_21_1(out, "end")
			if cat["parens"] then
				append_21_1(out, ")")
			end
		end
	elseif catTag == "cond" then
		local closure, hadFinal, ends = not ret, false, 1
		if closure then
			line_21_1(out, "(function()")
			_5e7e_1(out, on_21_1("indent"), succ1)
			ret = "return "
		end
		local i = 2
		while not hadFinal and i <= n1(node) do
			local item = nth1(node, i)
			local case = nth1(item, 1)
			local isFinal = builtin_3f_1(case, "true")
			if i > 2 and (not isFinal or ret ~= "" or _ebreak or n1(item) ~= 1 and fastAny1(function(x)
				return not constCategories1[catLookup[x]["category"]]
			end, item, 2)) then
				append_21_1(out, "else")
			end
			if isFinal then
				if i == 2 then
					append_21_1(out, "do")
				end
			elseif catLookup[case]["stmt"] then
				if i > 2 then
					_5e7e_1(out, on_21_1("indent"), succ1)
					line_21_1(out)
					ends = ends + 1
				end
				local var = {["name"]="temp"}
				local tmp = pushEscapeVar_21_1(var, state)
				line_21_1(out, "local " .. tmp)
				compileExpression1(case, out, state, tmp .. " = ")
				line_21_1(out)
				popEscapeVar_21_1(var, state)
				line_21_1(out, "if " .. tmp .. " then")
			else
				append_21_1(out, "if ")
				compileExpression1(case, out, state)
				append_21_1(out, " then")
			end
			_5e7e_1(out, on_21_1("indent"), succ1)
			line_21_1(out)
			compileBlock1(item, out, state, 2, ret, _ebreak)
			out["indent"] = out["indent"] - 1
			if isFinal then
				hadFinal = true
			end
			i = i + 1
		end
		if not hadFinal then
			append_21_1(out, "else")
			_5e7e_1(out, on_21_1("indent"), succ1)
			line_21_1(out)
			local source = getSource1(node)
			append_21_1(out, "_error(\"unmatched item\")", source and merge1(source, {["finish"]=source["start"]}))
			out["indent"] = out["indent"] - 1
			line_21_1(out)
		end
		local temp = ends
		local temp1 = 1
		while temp1 <= temp do
			append_21_1(out, "end")
			if temp1 < ends then
				out["indent"] = out["indent"] - 1
				line_21_1(out)
			end
			temp1 = temp1 + 1
		end
		if closure then
			line_21_1(out)
			out["indent"] = out["indent"] - 1
			append_21_1(out, "end)()")
		end
	elseif catTag == "unless" then
		local closure = not ret
		if closure then
			line_21_1(out, "(function()")
			_5e7e_1(out, on_21_1("indent"), succ1)
			ret = "return "
		end
		local test = car1(nth1(node, 2))
		if catLookup[test]["stmt"] then
			local var = {["name"]="temp"}
			local tmp = pushEscapeVar_21_1(var, state)
			line_21_1(out, "local " .. tmp)
			compileExpression1(test, out, state, tmp .. " = ")
			line_21_1(out)
			popEscapeVar_21_1(var, state)
			if _ebreak or ret and ret ~= "" then
				line_21_1(out, (formatOutput_21_1(nil, "if " .. tmp .. " then")))
				_5e7e_1(out, on_21_1("indent"), succ1)
				compileBlock1(nth1(node, 2), out, state, 2, ret, _ebreak)
				nextBlock_21_1(out, "else")
			else
				line_21_1(out, (formatOutput_21_1(nil, "if not " .. tmp .. " then")))
				_5e7e_1(out, on_21_1("indent"), succ1)
			end
		elseif _ebreak or ret and ret ~= "" then
			append_21_1(out, "if ")
			compileExpression1(test, out, state)
			line_21_1(out, " then")
			_5e7e_1(out, on_21_1("indent"), succ1)
			compileBlock1(nth1(node, 2), out, state, 2, ret, _ebreak)
			nextBlock_21_1(out, "else")
		else
			append_21_1(out, "if not ")
			compileExpression1(test, out, state)
			line_21_1(out, " then")
			_5e7e_1(out, on_21_1("indent"), succ1)
		end
		compileBlock1(nth1(node, 3), out, state, 2, ret, _ebreak)
		endBlock_21_1(out, "end")
		if closure then
			line_21_1(out)
			out["indent"] = out["indent"] - 1
			append_21_1(out, "end)()")
		end
	elseif catTag == "not" then
		if cat["parens"] then
			append_21_1(out, "(")
		end
		if ret then
			ret = ret .. "not "
		else
			append_21_1(out, "not ")
		end
		compileExpression1(car1(nth1(node, 2)), out, state, ret)
		if cat["parens"] then
			append_21_1(out, ")")
		end
	elseif catTag == "or" then
		if ret then
			append_21_1(out, ret)
		end
		if cat["parens"] then
			append_21_1(out, "(")
		end
		local len = n1(node)
		local temp = len - 2
		local temp1 = 2
		while temp1 <= temp do
			compileExpression1(car1(nth1(node, temp1)), out, state)
			append_21_1(out, " or ")
			temp1 = temp1 + 1
		end
		local temp = cat["kind"]
		if temp == "not" then
			append_21_1(out, "not ")
			compileExpression1(nth1(nth1(node, len - 1), 1), out, state)
		elseif temp == "and" then
			compileExpression1(nth1(nth1(node, len - 1), 1), out, state)
			append_21_1(out, " and ")
			compileExpression1(nth1(nth1(node, len - 1), 2), out, state)
		elseif temp == "or" then
			compileExpression1(nth1(nth1(node, len - 1), 1), out, state)
			append_21_1(out, " or ")
			compileExpression1(nth1(nth1(node, len), 2), out, state)
		else
			error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"not\"`\n  Tried: `\"and\"`\n  Tried: `\"or\"`")
		end
		if cat["parens"] then
			append_21_1(out, ")")
		end
	elseif catTag == "or-lambda" then
		if ret then
			append_21_1(out, ret)
		end
		if cat["parens"] then
			append_21_1(out, "(")
		end
		compileExpression1(nth1(node, 2), out, state)
		local branch = nth1(car1(node), 3)
		local len = n1(branch)
		append_21_1(out, " or ")
		local temp = len - 2
		local temp1 = 3
		while temp1 <= temp do
			compileExpression1(car1(nth1(branch, temp1)), out, state)
			append_21_1(out, " or ")
			temp1 = temp1 + 1
		end
		local temp = cat["kind"]
		if temp == "not" then
			append_21_1(out, "not ")
			compileExpression1(nth1(nth1(branch, len - 1), 1), out, state)
		elseif temp == "and" then
			compileExpression1(nth1(nth1(branch, len - 1), 1), out, state)
			append_21_1(out, " and ")
			compileExpression1(nth1(nth1(branch, len - 1), 2), out, state)
		elseif temp == "or" then
			if len > 3 then
				compileExpression1(nth1(nth1(branch, len - 1), 1), out, state)
				append_21_1(out, " or ")
			end
			compileExpression1(nth1(nth1(branch, len), 2), out, state)
		else
			error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"not\"`\n  Tried: `\"and\"`\n  Tried: `\"or\"`")
		end
		if cat["parens"] then
			append_21_1(out, ")")
		end
	elseif catTag == "and" then
		if ret then
			append_21_1(out, ret)
		end
		if cat["parens"] then
			append_21_1(out, "(")
		end
		compileExpression1(nth1(nth1(node, 2), 1), out, state)
		append_21_1(out, " and ")
		compileExpression1(nth1(nth1(node, 2), 2), out, state)
		if cat["parens"] then
			append_21_1(out, ")")
		end
	elseif catTag == "and-lambda" then
		if ret then
			append_21_1(out, ret)
		end
		if cat["parens"] then
			append_21_1(out, "(")
		end
		compileExpression1(nth1(node, 2), out, state)
		append_21_1(out, " and ")
		compileExpression1(nth1(nth1(nth1(car1(node), 3), 2), 2), out, state)
		if cat["parens"] then
			append_21_1(out, ")")
		end
	elseif catTag == "set!" then
		compileExpression1(nth1(node, 3), out, state, escapeVar1(node[2]["var"], state) .. " = ")
		if ret and ret ~= "" then
			line_21_1(out)
			append_21_1(out, ret)
			append_21_1(out, "nil")
		end
	elseif catTag == "struct-literal" then
		if ret == "" then
			append_21_1(out, "local _ = ")
		elseif ret then
			append_21_1(out, ret)
		end
		if cat["parens"] then
			append_21_1(out, "(")
		end
		local temp = n1(node)
		if temp == 1 then
			append_21_1(out, "{}", out["active-pos"])
		else
			append_21_1(out, "{")
			local temp1 = 2
			while temp1 <= temp do
				if temp1 > 2 then
					append_21_1(out, ", ")
				end
				append_21_1(out, "[")
				compileExpression1(nth1(node, temp1), out, state)
				append_21_1(out, "]=")
				compileExpression1(nth1(node, temp1 + 1), out, state)
				temp1 = temp1 + 2
			end
			append_21_1(out, "}")
		end
		if cat["parens"] then
			append_21_1(out, ")")
		end
	elseif catTag == "define" then
		compileExpression1(nth1(node, n1(node)), out, state, pushEscapeVar_21_1(node["def-var"], state) .. " = ")
	elseif catTag == "define-native" then
		local meta = state["meta"][node["def-var"]["unique-name"]]
		if meta == nil then
			append_21_1(out, format1("%s = _libs[%q]", escapeVar1(node["def-var"], state), node["def-var"]["unique-name"]), out["active-pos"])
		else
			append_21_1(out, format1("%s = ", escapeVar1(node["def-var"], state)), out["active-pos"])
			compileNative1(out, meta)
		end
	elseif catTag == "quote" then
		if not (ret == "") then
			if ret then
				append_21_1(out, ret)
			end
			if cat["parens"] then
				append_21_1(out, "(")
			end
			compileExpression1(nth1(node, 2), out, state)
			if cat["parens"] then
				append_21_1(out, ")")
			end
		end
	elseif catTag == "quote-const" then
		if not (ret == "") then
			if ret then
				append_21_1(out, ret)
			end
			if cat["parens"] then
				append_21_1(out, "(")
			end
			local temp = type1(node)
			if temp == "string" then
				append_21_1(out, quoted1(node["value"]), out["active-pos"])
			elseif temp == "number" then
				append_21_1(out, tostring1(node["value"]), out["active-pos"])
			elseif temp == "symbol" then
				append_21_1(out, "{tag=\"symbol\", contents=" .. quoted1(node["contents"]), out["active-pos"])
				if node["var"] then
					append_21_1(out, ", var=" .. quoted1(tostring1(node["var"])), out["active-pos"])
				end
				append_21_1(out, "}", out["active-pos"])
			elseif temp == "key" then
				append_21_1(out, "{tag=\"key\", value=" .. quoted1(node["value"]) .. "}", out["active-pos"])
			else
				error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"symbol\"`\n  Tried: `\"key\"`")
			end
			if cat["parens"] then
				append_21_1(out, ")")
			end
		end
	elseif catTag == "quote-list" then
		if ret == "" then
			append_21_1(out, "local _ = ")
		elseif ret then
			append_21_1(out, ret)
		end
		local temp = n1(node)
		if temp == 0 then
			append_21_1(out, "{tag=\"list\", n=0}", out["active-pos"])
		else
			append_21_1(out, "{tag=\"list\", n=" .. tostring1(temp))
			local temp1 = n1(node)
			local temp2 = 1
			while temp2 <= temp1 do
				local sub = node[temp2]
				append_21_1(out, ", ")
				compileExpression1(sub, out, state)
				temp2 = temp2 + 1
			end
			append_21_1(out, "}")
		end
	elseif catTag == "quote-splice" then
		if not ret then
			line_21_1(out, "(function()")
			_5e7e_1(out, on_21_1("indent"), succ1)
		end
		line_21_1(out, "local _offset, _result, _temp = 0, {tag=\"list\"}")
		local offset = 0
		local temp = n1(node)
		local temp1 = 1
		while temp1 <= temp do
			local sub = nth1(node, temp1)
			local cat1 = state["cat-lookup"][sub]
			if not cat1 then
				print1("Cannot find", pretty1(sub), formatNode1(sub))
			end
			if cat1["category"] == "unquote-splice" then
				offset = offset + 1
				append_21_1(out, "_temp = ")
				compileExpression1(nth1(sub, 2), out, state)
				line_21_1(out)
				line_21_1(out, "for _c = 1, _temp.n do _result[" .. tostring1(temp1 - offset) .. " + _c + _offset] = _temp[_c] end")
				line_21_1(out, "_offset = _offset + _temp.n")
			else
				append_21_1(out, "_result[" .. tostring1(temp1 - offset) .. " + _offset] = ")
				compileExpression1(sub, out, state)
				line_21_1(out)
			end
			temp1 = temp1 + 1
		end
		line_21_1(out, "_result.n = _offset + " .. tostring1(n1(node) - offset))
		if ret == "" then
		elseif ret then
			append_21_1(out, ret .. "_result")
		else
			line_21_1(out, "return _result")
			endBlock_21_1(out, "end)()")
		end
	elseif catTag == "syntax-quote" then
		if cat["parens"] then
			append_21_1(out, "(")
		end
		compileExpression1(nth1(node, 2), out, state, ret)
		if cat["parens"] then
			append_21_1(out, ")")
		end
	elseif catTag == "unquote" then
		compileExpression1(nth1(node, 2), out, state, ret)
	elseif catTag == "unquote-splice" then
		error1("Should never have explicit unquote-splice", 0)
	elseif catTag == "import" then
		if ret == nil then
			append_21_1(out, "nil")
		elseif ret ~= "" then
			append_21_1(out, ret)
			append_21_1(out, "nil")
		end
	elseif catTag == "call-symbol" then
		local head = car1(node)
		if ret then
			append_21_1(out, ret)
		end
		compileExpression1(head, out, state)
		append_21_1(out, "(")
		local temp = n1(node)
		local temp1 = 2
		while temp1 <= temp do
			if temp1 > 2 then
				append_21_1(out, ", ")
			end
			compileExpression1(nth1(node, temp1), out, state)
			temp1 = temp1 + 1
		end
		append_21_1(out, ")")
	elseif catTag == "call-meta" then
		local meta = cat["meta"]
		if meta["tag"] == "expr" then
			if ret == "" then
				append_21_1(out, "local _ = ")
			elseif ret then
				append_21_1(out, ret)
			end
		end
		if cat["parens"] then
			append_21_1(out, "(")
		end
		local contents, fold, count, build = meta["contents"], meta["fold"], meta["count"]
		build = function(start, _eend)
			local temp = n1(contents)
			local temp1 = 1
			while temp1 <= temp do
				local entry = contents[temp1]
				if string_3f_1(entry) then
					append_21_1(out, entry)
				elseif fold == "l" and (entry == 1 and start < _eend) then
					build(start, _eend - 1)
					start = _eend
				elseif fold == "r" and (entry == 2 and start < _eend) then
					build(start + 1, _eend)
				else
					compileExpression1(nth1(node, entry + start), out, state)
				end
				temp1 = temp1 + 1
			end
			return nil
		end
		build(1, n1(node) - count)
		if cat["parens"] then
			append_21_1(out, ")")
		end
		if meta["tag"] ~= "expr" and ret ~= "" then
			line_21_1(out)
			append_21_1(out, ret)
			append_21_1(out, "nil")
			line_21_1(out)
		end
	elseif catTag == "call-recur" then
		if ret == nil then
			print1(pretty1(node), " marked as call-recur for ", ret)
		end
		local args = nth1(cat["recur"]["def"], 2)
		compileBind1(args, 1, node, 2, out, state)
		if ret == "return " then
			compileRecur1(cat["recur"], out, state, "return ")
		else
			compileRecur1(cat["recur"], out, state, ret, cat["recur"])
		end
		local temp = n1(args)
		local temp1 = 1
		while temp1 <= temp do
			local arg = args[temp1]
			if not state["var-skip"][arg["var"]] then
				popEscapeVar_21_1(arg["var"], state)
			end
			temp1 = temp1 + 1
		end
	elseif catTag == "call-tail" then
		if ret == nil then
			print1(pretty1(node), " marked as call-tail for ", ret)
		end
		if _ebreak and _ebreak ~= cat["recur"] then
			print1(pretty1(node) .. " Got a different break then defined for.\n  Expected: " .. pretty1(cat["recur"]["def"]) .. "\n       Got: " .. pretty1(_ebreak["def"]))
		end
		local args = nth1(cat["recur"]["def"], 2)
		if n1(args) > 0 then
			local packName, done = nil, false
			local offset, temp = 1, n1(args)
			local temp1 = 1
			while temp1 <= temp do
				local var = args[temp1]["var"]
				if var["is-variadic"] then
					local count = n1(node) - n1(args)
					if count < 0 then
						count = 0
					end
					if done then
						append_21_1(out, ", ")
					else
						done = true
					end
					append_21_1(out, escapeVar1(var, state))
					offset = count
				else
					local expr = nth1(node, temp1 + offset)
					if not (type1(expr) == "symbol") or expr["var"] ~= var then
						if done then
							append_21_1(out, ", ")
						else
							done = true
						end
						append_21_1(out, escapeVar1(var, state))
					end
				end
				temp1 = temp1 + 1
			end
			if done then
				append_21_1(out, " = ")
				local offset, done1 = 1, false
				local temp = n1(args)
				local temp1 = 1
				while temp1 <= temp do
					local var = args[temp1]["var"]
					if var["is-variadic"] then
						local count = n1(node) - n1(args)
						if count < 0 then
							count = 0
						end
						if done1 then
							append_21_1(out, ", ")
						else
							done1 = true
						end
						if compilePack1(node, out, state, temp1, count) then
							packName = escapeVar1(var, state)
						end
						offset = count
					else
						local expr = nth1(node, temp1 + offset)
						if expr and (not (type1(expr) == "symbol") or expr["var"] ~= var) then
							if done1 then
								append_21_1(out, ", ")
							else
								done1 = true
							end
							compileExpression1(nth1(node, temp1 + offset), out, state)
						end
					end
					temp1 = temp1 + 1
				end
				local temp = n1(node)
				local temp1 = n1(args) + (offset + 1)
				while temp1 <= temp do
					if temp1 > 1 then
						append_21_1(out, ", ")
					end
					compileExpression1(nth1(node, temp1), out, state)
					temp1 = temp1 + 1
				end
			else
				local temp = n1(node)
				local temp1 = 2
				while temp1 <= temp do
					if temp1 > 1 then
						line_21_1(out)
					end
					compileExpression1(nth1(node, temp1), out, state, "")
					temp1 = temp1 + 1
				end
			end
			line_21_1(out)
			if packName then
				line_21_1(packName .. ".tag = \"list\"")
			end
		else
			local temp = n1(node)
			local temp1 = 1
			while temp1 <= temp do
				if temp1 > 1 then
					append_21_1(out, ", ")
				end
				compileExpression1(nth1(node, temp1), out, state, "")
				line_21_1(out)
				temp1 = temp1 + 1
			end
		end
	elseif catTag == "wrap-value" then
		if ret then
			append_21_1(out, ret)
		end
		append_21_1(out, "(")
		compileExpression1(nth1(node, 2), out, state)
		append_21_1(out, ")")
	elseif catTag == "call-lambda" then
		local empty = ret == nil
		if empty then
			ret = "return "
			line_21_1(out, "(function()")
			_5e7e_1(out, on_21_1("indent"), succ1)
		end
		local head = car1(node)
		local args = nth1(head, 2)
		compileBind1(args, 1, node, 2, out, state)
		compileBlock1(head, out, state, 3, ret, _ebreak)
		local temp = n1(args)
		local temp1 = 1
		while temp1 <= temp do
			local arg = args[temp1]
			if not state["var-skip"][arg["var"]] then
				popEscapeVar_21_1(arg["var"], state)
			end
			temp1 = temp1 + 1
		end
		if empty then
			out["indent"] = out["indent"] - 1
			append_21_1(out, "end)()")
		end
	elseif catTag == "call" then
		if ret then
			append_21_1(out, ret)
		end
		compileExpression1(car1(node), out, state)
		append_21_1(out, "(")
		local temp = n1(node)
		local temp1 = 2
		while temp1 <= temp do
			if temp1 > 2 then
				append_21_1(out, ", ")
			end
			compileExpression1(nth1(node, temp1), out, state)
			temp1 = temp1 + 1
		end
		append_21_1(out, ")")
	else
		error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(catTag) .. ", but none matched.\n" .. "  Tried: `\"void\"`\n  Tried: `\"const\"`\n  Tried: `\"lambda\"`\n  Tried: `\"cond\"`\n  Tried: `\"unless\"`\n  Tried: `\"not\"`\n  Tried: `\"or\"`\n  Tried: `\"or-lambda\"`\n  Tried: `\"and\"`\n  Tried: `\"and-lambda\"`\n  Tried: `\"set!\"`\n  Tried: `\"struct-literal\"`\n  Tried: `\"define\"`\n  Tried: `\"define-native\"`\n  Tried: `\"quote\"`\n  Tried: `\"quote-const\"`\n  Tried: `\"quote-list\"`\n  Tried: `\"quote-splice\"`\n  Tried: `\"syntax-quote\"`\n  Tried: `\"unquote\"`\n  Tried: `\"unquote-splice\"`\n  Tried: `\"import\"`\n  Tried: `\"call-symbol\"`\n  Tried: `\"call-meta\"`\n  Tried: `\"call-recur\"`\n  Tried: `\"call-tail\"`\n  Tried: `\"wrap-value\"`\n  Tried: `\"call-lambda\"`\n  Tried: `\"call\"`")
	end
	return popNode_21_1(out, node)
end
compileBind1 = function(args, argsStart, vals, valsStart, out, state)
	local zipped = zipArgs1(args, argsStart, vals, valsStart)
	local zippedN, zippedI, skip, catLookup = n1(zipped), 1, state["var-skip"], state["cat-lookup"]
	while zippedI <= zippedN do
		local zip = nth1(zipped, zippedI)
		local args1, vals1 = car1(zip), cadr1(zip)
		if empty_3f_1(args1) then
			local temp = n1(vals1)
			local temp1 = 1
			while temp1 <= temp do
				compileExpression1(vals1[temp1], out, state, "")
				line_21_1(out)
				temp1 = temp1 + 1
			end
		elseif car1(args1)["var"]["is-variadic"] or n1(args1) > 1 and any1(function(temp)
			return temp["var"]["is-variadic"]
		end, args1) then
			if n1(args1) > 1 then
				local varIdx
				local i = 1
				while not (nth1(args1, i)["var"]["is-variadic"]) do
					i = i + 1
				end
				varIdx = i
				local varEsc, nargs = pushEscapeVar_21_1(nth1(args1, varIdx)["var"], state), n1(args1)
				append_21_1(out, "local _p = _pack(")
				local temp = n1(vals1)
				local temp1 = 1
				while temp1 <= temp do
					if temp1 > 1 then
						append_21_1(out, ", ")
					end
					compileExpression1(nth1(vals1, temp1), out, state)
					temp1 = temp1 + 1
				end
				append_21_1(out, ")")
				line_21_1(out)
				line_21_1(out, "local _n = _p.n")
				append_21_1(out, "local ")
				local temp = 1
				while temp <= nargs do
					if temp > 1 then
						append_21_1(out, ", ")
					end
					append_21_1(out, pushEscapeVar_21_1(nth1(args1, temp)["var"], state))
					temp = temp + 1
				end
				if varIdx > 1 then
					append_21_1(out, " = ")
					local temp = varIdx - 1
					local temp1 = 1
					while temp1 <= temp do
						if temp1 > 1 then
							append_21_1(out, ", ")
						end
						append_21_1(out, format1("_p[%d]", temp1))
						temp1 = temp1 + 1
					end
				end
				line_21_1(out)
				line_21_1(out, (format1("if _n > %d then", nargs - 1)))
				_5e7e_1(out, on_21_1("indent"), succ1)
				line_21_1(out, format1("%s = {tag=\"list\",n=_n-%d}", varEsc, nargs - 1))
				line_21_1(out, format1("for i = %d, _n-%d do %s[i-%d]=_p[i] end", varIdx, nargs - varIdx, varEsc, varIdx - 1))
				if varIdx < nargs then
					local temp = varIdx + 1
					while temp <= nargs do
						if temp > varIdx + 1 then
							append_21_1(out, ", ")
						end
						append_21_1(out, escapeVar1(nth1(args1, temp)["var"], state))
						temp = temp + 1
					end
					append_21_1(out, " = ")
					local temp = varIdx + 1
					while temp <= nargs do
						if temp > varIdx + 1 then
							append_21_1(out, ", ")
						end
						append_21_1(out, format1("_p[_n-%d]", nargs - temp))
						temp = temp + 1
					end
					line_21_1(out)
				end
				nextBlock_21_1(out, "else")
				line_21_1(out, format1("%s = {tag=\"list\",n=0}", varEsc))
				if varIdx < nargs then
					local temp = varIdx + 1
					while temp <= nargs do
						if temp > varIdx + 1 then
							append_21_1(out, ", ")
						end
						append_21_1(out, escapeVar1(nth1(args1, temp)["var"], state))
						temp = temp + 1
					end
					append_21_1(out, " = ")
					local temp = varIdx + 1
					while temp <= nargs do
						if temp > varIdx + 1 then
							append_21_1(out, ", ")
						end
						append_21_1(out, format1("_p[%d]", temp - 1))
						temp = temp + 1
					end
					line_21_1(out)
				end
				endBlock_21_1(out, "end")
			elseif empty_3f_1(vals1) or singleReturn_3f_1(last1(vals1)) then
				append_21_1(out, "local ")
				append_21_1(out, pushEscapeVar_21_1(car1(args1)["var"], state))
				append_21_1(out, " = {tag=\"list\", n=")
				append_21_1(out, tostring1(n1(vals1)))
				local temp = n1(vals1)
				local temp1 = 1
				while temp1 <= temp do
					append_21_1(out, ", ")
					compileExpression1(nth1(vals1, temp1), out, state)
					temp1 = temp1 + 1
				end
				append_21_1(out, "}")
				line_21_1(out)
			else
				local name = pushEscapeVar_21_1(car1(args1)["var"], state)
				append_21_1(out, "local ")
				append_21_1(out, name)
				append_21_1(out, " = _pack(")
				local temp = n1(vals1)
				local temp1 = 1
				while temp1 <= temp do
					if temp1 > 1 then
						append_21_1(out, ", ")
					end
					compileExpression1(nth1(vals1, temp1), out, state)
					temp1 = temp1 + 1
				end
				append_21_1(out, ") ")
				append_21_1(out, name)
				append_21_1(out, ".tag = \"list\"")
				line_21_1(out)
			end
		elseif n1(args1) == 1 and skip[car1(args1)["var"]] then
		else
			local zippedLim, working = zippedI, true
			while working and zippedLim <= zippedN do
				local zip1 = nth1(zipped, zippedLim)
				local args2, vals2 = car1(zip1), cadr1(zip1)
				if empty_3f_1(args2) then
					working = false
				elseif car1(args2)["var"]["is-variadic"] or n1(args2) > 1 and any1(function(temp)
					return temp["var"]["is-variadic"]
				end, args2) then
					working = false
				elseif n1(vals2) == 1 and catLookup[car1(vals2)]["stmt"] then
					working = false
				else
					zippedLim = zippedLim + 1
				end
			end
			if zippedLim == zippedI then
				local esc
				if n1(args1) == 1 then
					esc = pushEscapeVar_21_1(car1(args1)["var"], state)
				else
					local escs = {tag="list", n=0}
					local temp = n1(args1)
					local temp1 = 1
					while temp1 <= temp do
						pushCdr_21_1(escs, pushEscapeVar_21_1(args1[temp1]["var"], state))
						temp1 = temp1 + 1
					end
					esc = concat1(escs, ", ")
				end
				if not (n1(vals1) == 1 and catLookup[car1(vals1)]["stmt"]) then
					error1("Expected statement, got something " .. pretty1(zip))
				end
				line_21_1(out, "local " .. esc)
				compileExpression1(car1(vals1), out, state, esc .. " = ")
				line_21_1(out)
			else
				local hasVal = false
				append_21_1(out, "local ")
				local first, temp = true, zippedLim - 1
				local temp1 = zippedI
				while temp1 <= temp do
					local zip1 = nth1(zipped, temp1)
					local args2 = car1(zip1)
					if not empty_3f_1((cadr1(zip1))) then
						hasVal = true
					end
					if not (n1(args2) == 1 and skip[car1(args2)["var"]]) then
						local temp2 = n1(args2)
						local temp3 = 1
						while temp3 <= temp2 do
							local arg = args2[temp3]
							if first then
								first = false
							else
								append_21_1(out, ", ")
							end
							local var = arg["var"]
							if skip[var] then
								append_21_1(out, "_")
							else
								append_21_1(out, pushEscapeVar_21_1(var, state))
							end
							temp3 = temp3 + 1
						end
					end
					temp1 = temp1 + 1
				end
				if hasVal then
					append_21_1(out, " = ")
					local first, temp = true, zippedLim - 1
					local temp1 = zippedI
					while temp1 <= temp do
						local zip1 = nth1(zipped, temp1)
						local args2, vals2 = car1(zip1), cadr1(zip1)
						if not (n1(args2) == 1 and skip[car1(args2)["var"]]) then
							local temp2 = n1(vals2)
							local temp3 = 1
							while temp3 <= temp2 do
								local val = vals2[temp3]
								if first then
									first = false
								else
									append_21_1(out, ", ")
								end
								compileExpression1(val, out, state)
								temp3 = temp3 + 1
							end
						end
						temp1 = temp1 + 1
					end
				end
				line_21_1(out)
				zippedI = zippedLim - 1
			end
		end
		zippedI = zippedI + 1
	end
	return nil
end
compilePack1 = function(node, out, state, start, count)
	if count <= 0 or atom_3f_1(nth1(node, start + count)) then
		append_21_1(out, "{tag=\"list\", n=")
		append_21_1(out, tostring1(count))
		local temp = 1
		while temp <= count do
			append_21_1(out, ", ")
			compileExpression1(nth1(node, start + temp), out, state)
			temp = temp + 1
		end
		append_21_1(out, "}")
		return false
	else
		append_21_1(out, " _pack(")
		local temp = 1
		while temp <= count do
			if temp > 1 then
				append_21_1(out, ", ")
			end
			compileExpression1(nth1(node, start + temp), out, state)
			temp = temp + 1
		end
		append_21_1(out, ")")
		return true
	end
end
compileRecur1 = function(recur, out, state, ret, _ebreak)
	local temp = recur["category"]
	if temp == "while" then
		local node = nth1(recur["def"], 3)
		append_21_1(out, "while ")
		compileExpression1(car1(nth1(node, 2)), out, state)
		line_21_1(out, " do")
		_5e7e_1(out, on_21_1("indent"), succ1)
		compileBlock1(nth1(node, 2), out, state, 2, ret, _ebreak)
		endBlock_21_1(out, "end")
		return compileBlock1(nth1(node, 3), out, state, 2, ret)
	elseif temp == "while-not" then
		local node = nth1(recur["def"], 3)
		append_21_1(out, "while not (")
		compileExpression1(car1(nth1(node, 2)), out, state)
		line_21_1(out, ") do")
		_5e7e_1(out, on_21_1("indent"), succ1)
		compileBlock1(nth1(node, 3), out, state, 2, ret, _ebreak)
		endBlock_21_1(out, "end")
		return compileBlock1(nth1(node, 2), out, state, 2, ret)
	elseif temp == "forever" then
		line_21_1(out, "while true do")
		_5e7e_1(out, on_21_1("indent"), succ1)
		compileBlock1(recur["def"], out, state, 3, ret, _ebreak)
		return endBlock_21_1(out, "end")
	else
		return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"while\"`\n  Tried: `\"while-not\"`\n  Tried: `\"forever\"`")
	end
end
compileBlock1 = function(nodes, out, state, start, ret, _ebreak)
	local len = n1(nodes)
	local temp = len - 1
	local temp1 = start
	while temp1 <= temp do
		compileExpression1(nth1(nodes, temp1), out, state, "")
		line_21_1(out)
		temp1 = temp1 + 1
	end
	if len >= start then
		local node = nth1(nodes, len)
		compileExpression1(node, out, state, ret, _ebreak)
		line_21_1(out)
		if _ebreak and not breakCategories1[state["cat-lookup"][node]["category"]] then
			return line_21_1(out, "break")
		else
			return nil
		end
	else
		if ret and ret ~= "" then
			append_21_1(out, ret)
			line_21_1(out, "nil")
		end
		if _ebreak then
			return line_21_1(out, "break")
		else
			return nil
		end
	end
end
prelude1 = function(out)
	line_21_1(out, "if not table.pack then table.pack = function(...) return { n = select(\"#\", ...), ... } end end")
	line_21_1(out, "if not table.unpack then table.unpack = unpack end")
	line_21_1(out, "local load = load if _VERSION:find(\"5.1\") then load = function(x, n, _, env) local f, e = loadstring(x, n) if not f then return f, e end if env then setfenv(f, env) end return f end end")
	return line_21_1(out, "local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error")
end
expression2 = function(node, out, state, ret)
	local passState = createPassState1(state)
	runPass1(letrecNode1, state, nil, node, passState)
	runPass1(categoriseNode1, state, nil, node, passState, ret ~= nil)
	return compileExpression1(node, out, passState, ret)
end
block2 = function(nodes, out, state, start, ret)
	local passState = createPassState1(state)
	runPass1(letrecNodes1, state, nil, nodes, passState)
	runPass1(categoriseNodes1, state, nil, nodes, passState)
	return compileBlock1(nodes, out, passState, start, ret)
end
create3 = function(scope, compiler)
	if not scope then
		error1("scope cannot be nil")
	end
	if not compiler then
		error1("compiler cannot be nil")
	end
	return {["scope"]=scope, ["compiler"]=compiler, ["logger"]=compiler["log"], ["mappings"]=compiler["compile-state"]["mappings"], ["required"]={tag="list", n=0}, ["required-set"]={}, ["stage"]="parsed", ["var"]=nil, ["node"]=nil, ["value"]=nil}
end
require_21_1 = function(state, var, user)
	if state["stage"] ~= "parsed" then
		error1("Cannot add requirement when in stage " .. state["stage"])
	end
	if not var then
		error1("var is nil")
	end
	if not user then
		error1("user is nil")
	end
	if var["scope"]["is-root"] then
		local other = state["compiler"]["states"][var]
		if other and not state["required-set"][other] then
			state["required-set"][other] = user
			pushCdr_21_1(state["required"], other)
		end
		return other
	else
		return nil
	end
end
define_21_1 = function(state, var)
	if state["stage"] ~= "parsed" then
		error1("Cannot add definition when in stage " .. state["stage"])
	end
	if var["scope"] ~= state["scope"] then
		error1("Defining variable in different scope")
	end
	if state["var"] then
		error1("Cannot redeclare variable for given state")
	end
	state["var"] = var
	state["compiler"]["states"][var] = state
	state["compiler"]["variables"][tostring1(var)] = var
	return nil
end
built_21_1 = function(state, node)
	if not node then
		error1("node cannot be nil")
	end
	if state["stage"] ~= "parsed" then
		error1("Cannot transition from " .. state["stage"] .. " to built")
	end
	if node["def-var"] ~= state["var"] then
		error1("Variables are different")
	end
	state["node"] = node
	state["stage"] = "built"
	return nil
end
executed_21_1 = function(state, value)
	if state["stage"] ~= "built" then
		error1("Cannot transition from " .. state["stage"] .. " to executed")
	end
	state["value"] = value
	state["stage"] = "executed"
	return nil
end
get_21_1 = function(state)
	if state["stage"] == "executed" then
		return state["value"]
	else
		local required, requiredSet = {tag="list", n=0}, {}
		local visit
		visit = function(state1, stack, stackHash)
			local idx = stackHash[state1]
			if idx then
				if state1["var"]["kind"] == "macro" then
					pushCdr_21_1(stack, state1)
					local states, nodes, firstNode = {tag="list", n=0}, {tag="list", n=0}, nil
					local temp = n1(stack)
					local temp1 = idx
					while temp1 <= temp do
						local current, previous = nth1(stack, temp1), nth1(stack, temp1 - 1)
						pushCdr_21_1(states, current["var"]["name"])
						if previous then
							local user = previous["required-set"][current]
							if not firstNode then
								firstNode = user
							end
							pushCdr_21_1(nodes, getSource1(user))
							pushCdr_21_1(nodes, current["var"]["name"] .. " used in " .. previous["var"]["name"])
						end
						temp1 = temp1 + 1
					end
					return doNodeError_21_2(state1["logger"], "Loop in macros " .. concat1(states, " -> "), firstNode, nil, unpack1(nodes, 1, n1(nodes)))
				else
					return nil
				end
			elseif state1["stage"] == "executed" then
				return nil
			else
				pushCdr_21_1(stack, state1)
				stackHash[state1] = n1(stack)
				if not requiredSet[state1] then
					requiredSet[state1] = true
					pushCdr_21_1(required, state1)
				end
				local visited = {}
				local temp = state1["required"]
				local temp1 = n1(temp)
				local temp2 = 1
				while temp2 <= temp1 do
					local inner = temp[temp2]
					visited[inner] = true
					visit(inner, stack, stackHash)
					temp2 = temp2 + 1
				end
				if state1["stage"] == "parsed" then
					yield1({["tag"]="build", ["state"]=state1})
				end
				local temp = state1["required"]
				local temp1 = n1(temp)
				local temp2 = 1
				while temp2 <= temp1 do
					local inner = temp[temp2]
					if not visited[inner] then
						visit(inner, stack, stackHash)
					end
					temp2 = temp2 + 1
				end
				popLast_21_1(stack)
				stackHash[state1] = nil
				return nil
			end
		end
		visit(state, {tag="list", n=0}, {})
		yield1({["tag"]="execute", ["states"]=required})
		return state["value"]
	end
end
name1 = function(state)
	if state["var"] then
		return "macro " .. quoted1(state["var"]["name"])
	else
		return "unquote"
	end
end
traceback3 = function(msg)
	if not string_3f_1(msg) then
		msg = pretty1(msg)
	end
	return traceback1(msg, 2)
end
unmangleIdent1 = function(ident)
	local esc = match1(ident, "^(.-)%d+$")
	if esc == nil then
		return ident
	elseif sub1(esc, 1, 2) == "_e" then
		return sub1(ident, 3)
	else
		local buffer, pos, len = {tag="list", n=0}, 0, n1(esc)
		while pos <= len do
			local char
			local x = pos
			char = sub1(esc, x, x)
			if char == "_" then
				local temp = list1(find1(esc, "^_[%da-z]+_", pos))
				if type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and true)) then
					local start, _eend = nth1(temp, 1), nth1(temp, 2)
					pos = pos + 1
					while pos < _eend do
						pushCdr_21_1(buffer, char1(tonumber1(sub1(esc, pos, pos + 1), 16)))
						pos = pos + 2
					end
				else
					pushCdr_21_1(buffer, "_")
				end
			elseif between_3f_1(char, "A", "Z") then
				pushCdr_21_1(buffer, "-")
				pushCdr_21_1(buffer, lower1(char))
			else
				pushCdr_21_1(buffer, char)
			end
			pos = pos + 1
		end
		return concat1(buffer)
	end
end
remapError1 = function(msg)
	return (gsub1(gsub1(gsub1(gsub1(msg, "local '([^']+)'", function(x)
		return "local '" .. unmangleIdent1(x) .. "'"
	end), "global '([^']+)'", function(x)
		return "global '" .. unmangleIdent1(x) .. "'"
	end), "upvalue '([^']+)'", function(x)
		return "upvalue '" .. unmangleIdent1(x) .. "'"
	end), "function '([^']+)'", function(x)
		return "function '" .. unmangleIdent1(x) .. "'"
	end))
end
remapMessage1 = function(mappings, msg)
	local temp = list1(match1(msg, "^(.-):(%d+)(.*)$"))
	if type1(temp) == "list" and (n1(temp) >= 3 and (n1(temp) <= 3 and true)) then
		local file, line, extra = nth1(temp, 1), nth1(temp, 2), nth1(temp, 3)
		local mapping = mappings[file]
		if mapping then
			local range = mapping[tonumber1(line)]
			if range then
				return range .. " (" .. file .. ":" .. line .. ")" .. remapError1(extra)
			else
				return msg
			end
		else
			return msg
		end
	else
		return msg
	end
end
remapTraceback1 = function(mappings, msg)
	return gsub1(gsub1(gsub1(gsub1(gsub1(gsub1(gsub1(msg, "^([^\n:]-:%d+:[^\n]*)", function(temp)
		return remapMessage1(mappings, temp)
	end), "\9([^\n:]-:%d+:)", function(msg1)
		return "\9" .. remapMessage1(mappings, msg1)
	end), "<([^\n:]-:%d+)>\n", function(msg1)
		return "<" .. remapMessage1(mappings, msg1) .. ">\n"
	end), "in local '([^']+)'\n", function(x)
		return "in local '" .. unmangleIdent1(x) .. "'\n"
	end), "in global '([^']+)'\n", function(x)
		return "in global '" .. unmangleIdent1(x) .. "'\n"
	end), "in upvalue '([^']+)'\n", function(x)
		return "in upvalue '" .. unmangleIdent1(x) .. "'\n"
	end), "in function '([^']+)'\n", function(x)
		return "in function '" .. unmangleIdent1(x) .. "'\n"
	end)
end
generateMappings1 = function(lines)
	local outLines = {}
	local temp, ranges = next1(lines)
	while temp ~= nil do
		local rangeLists = {}
		local temp1 = next1(ranges)
		while temp1 ~= nil do
			local file = temp1["name"]
			local rangeList = rangeLists[file]
			if not rangeList then
				rangeList = {["n"]=0, ["min"]=huge1, ["max"]=0 - huge1}
				rangeLists[file] = rangeList
			end
			local temp2 = temp1["finish"]["line"]
			local temp3 = temp1["start"]["line"]
			while temp3 <= temp2 do
				if not rangeList[temp3] then
					rangeList["n"] = rangeList["n"] + 1
					rangeList[temp3] = true
					if temp3 < rangeList["min"] then
						rangeList["min"] = temp3
					end
					if temp3 > rangeList["max"] then
						rangeList["max"] = temp3
					end
				end
				temp3 = temp3 + 1
			end
			temp1 = next1(ranges, temp1)
		end
		local bestName, bestLines, bestCount = nil, nil, 0
		local temp1, lines1 = next1(rangeLists)
		while temp1 ~= nil do
			if lines1["n"] > bestCount then
				bestName = temp1
				bestLines = lines1
				bestCount = lines1["n"]
			end
			temp1, lines1 = next1(rangeLists, temp1)
		end
		outLines[temp] = (function()
			if bestLines["min"] == bestLines["max"] then
				return format1("%s:%d", bestName, bestLines["min"])
			else
				return format1("%s:%d-%d", bestName, bestLines["min"], bestLines["max"])
			end
		end)()
		temp, ranges = next1(lines, temp)
	end
	return outLines
end
createState1 = function(meta)
	return {["timer"]={["callback"]=function()
		return nil
	end, ["timers"]={}}, ["count"]=0, ["mappings"]={}, ["var-cache"]={}, ["var-lookup"]={}, ["meta"]=meta or {}}
end
file1 = function(compiler, shebang)
	local state, out = createState1(compiler["lib-meta"]), {["out"]={tag="list", n=0}, ["indent"]=0, ["tabs-pending"]=false, ["line"]=1, ["lines"]={}, ["node-stack"]={tag="list", n=0}, ["active-pos"]=nil}
	if shebang then
		line_21_1(out, "#!/usr/bin/env " .. shebang)
	end
	state["trace"] = true
	prelude1(out)
	line_21_1(out, "local _libs = {}")
	local temp = compiler["libs"]
	local temp1 = n1(temp)
	local temp2 = 1
	while temp2 <= temp1 do
		local lib = temp[temp2]
		local prefix, native = quoted1(lib["prefix"]), lib["native"]
		if native then
			line_21_1(out, "local _temp = (function()")
			local temp3 = split1(native, "\n")
			local temp4 = n1(temp3)
			local temp5 = 1
			while temp5 <= temp4 do
				local line = temp3[temp5]
				if line ~= "" then
					append_21_1(out, "\9")
					line_21_1(out, line)
				end
				temp5 = temp5 + 1
			end
			line_21_1(out, "end)()")
			line_21_1(out, "for k, v in pairs(_temp) do _libs[" .. prefix .. ".. k] = v end")
		end
		temp2 = temp2 + 1
	end
	local count = 0
	local temp = compiler["out"]
	local temp1 = n1(temp)
	local temp2 = 1
	while temp2 <= temp1 do
		if temp[temp2]["def-var"] then
			count = count + 1
		end
		temp2 = temp2 + 1
	end
	local temp = compiler["out"]
	local temp1 = n1(temp)
	local temp2 = 1
	while temp2 <= temp1 do
		local var = temp[temp2]["def-var"]
		if var then
			pushEscapeVar_21_1(var, state, true)
		end
		temp2 = temp2 + 1
	end
	if count == 0 then
	elseif count <= 100 then
		append_21_1(out, "local ")
		local first, temp = true, compiler["out"]
		local temp1 = n1(temp)
		local temp2 = 1
		while temp2 <= temp1 do
			local var = temp[temp2]["def-var"]
			if var then
				if first then
					first = false
				else
					append_21_1(out, ", ")
				end
				append_21_1(out, escapeVar1(var, state))
			end
			temp2 = temp2 + 1
		end
		line_21_1(out)
	else
		local counts, vars = {}, {tag="list", n=0}
		local temp = compiler["out"]
		local temp1 = n1(temp)
		local temp2 = 1
		while temp2 <= temp1 do
			local var = temp[temp2]["def-var"]
			if var then
				counts[var] = 0
				pushCdr_21_1(vars, var)
			end
			temp2 = temp2 + 1
		end
		visitBlock1(compiler["out"], 1, function(x)
			if type1(x) == "symbol" then
				local var = x["var"]
				local count1 = counts[var]
				if count1 then
					counts[var] = count1 + 1
					return nil
				else
					return nil
				end
			else
				return nil
			end
		end)
		sort1(vars, function(x, y)
			return counts[x] > counts[y]
		end)
		append_21_1(out, "local ")
		local temp = 1
		while temp <= 100 do
			if temp > 1 then
				append_21_1(out, ", ")
			end
			append_21_1(out, escapeVar1(nth1(vars, temp), state))
			temp = temp + 1
		end
		line_21_1(out)
		line_21_1(out, "local _ENV = setmetatable({}, {__index=ENV or (getfenv and getfenv()) or _G}) if setfenv then setfenv(0, _ENV) end")
	end
	block2(compiler["out"], out, state, 1, "return ")
	return out
end
executeStates1 = function(backState, states, global)
	local stateList, nameList, exportList, escapeList = {tag="list", n=0}, {tag="list", n=0}, {tag="list", n=0}, {tag="list", n=0}
	local temp = n1(states)
	while temp >= 1 do
		local state = nth1(states, temp)
		if not (state["stage"] == "executed") then
			if not state["node"] then
				error1("State is in " .. state["stage"] .. " instead", 0)
			end
			local var = state["var"] or {["name"]="temp"}
			local escaped, name = pushEscapeVar_21_1(var, backState, true), var["name"]
			pushCdr_21_1(stateList, state)
			pushCdr_21_1(exportList, escaped .. " = " .. escaped)
			pushCdr_21_1(nameList, name)
			pushCdr_21_1(escapeList, escaped)
		end
		temp = temp + -1
	end
	if empty_3f_1(stateList) then
		return nil
	else
		local out, id, name = {["out"]={tag="list", n=0}, ["indent"]=0, ["tabs-pending"]=false, ["line"]=1, ["lines"]={}, ["node-stack"]={tag="list", n=0}, ["active-pos"]=nil}, backState["count"], concat1(nameList, ",")
		backState["count"] = id + 1
		if n1(name) > 20 then
			name = sub1(name, 1, 17) .. "..."
		end
		name = "compile#" .. id .. "{" .. name .. "}"
		prelude1(out)
		line_21_1(out, "local " .. concat1(escapeList, ", "))
		local temp = n1(stateList)
		local temp1 = 1
		while temp1 <= temp do
			local state = nth1(stateList, temp1)
			expression2(state["node"], out, backState, (function()
				if state["var"] then
					return ""
				else
					return nth1(escapeList, temp1) .. "= "
				end
			end)())
			line_21_1(out)
			temp1 = temp1 + 1
		end
		line_21_1(out, "return { " .. concat1(exportList, ", ") .. "}")
		local str = concat1(out["out"])
		backState["mappings"][name] = generateMappings1(out["lines"])
		local temp = list1(load1(str, "=" .. name, "t", global))
		if type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (nth1(temp, 1) == nil and true))) then
			local msg, buffer, lines = nth1(temp, 2), {tag="list", n=0}, split1(str, "\n")
			local fmt = "%" .. n1(tostring1(n1(lines))) .. "d | %s"
			local temp1 = n1(lines)
			local temp2 = 1
			while temp2 <= temp1 do
				pushCdr_21_1(buffer, sprintf1(fmt, temp2, nth1(lines, temp2)))
				temp2 = temp2 + 1
			end
			return error1(msg .. ":\n" .. concat1(buffer, "\n"), 0)
		elseif type1(temp) == "list" and (n1(temp) >= 1 and (n1(temp) <= 1 and true)) then
			local temp1 = list1(xpcall1(nth1(temp, 1), traceback3))
			if type1(temp1) == "list" and (n1(temp1) >= 2 and (n1(temp1) <= 2 and (nth1(temp1, 1) == false and true))) then
				local msg = nth1(temp1, 2)
				return error1(remapTraceback1(backState["mappings"], msg), 0)
			elseif type1(temp1) == "list" and (n1(temp1) >= 2 and (n1(temp1) <= 2 and (nth1(temp1, 1) == true and true))) then
				local tbl, temp2 = nth1(temp1, 2), n1(stateList)
				local temp3 = 1
				while temp3 <= temp2 do
					local state, escaped = nth1(stateList, temp3), nth1(escapeList, temp3)
					local res = tbl[escaped]
					executed_21_1(state, res)
					if state["var"] then
						global[escaped] = res
					end
					temp3 = temp3 + 1
				end
				return nil
			else
				return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp1) .. ", but none matched.\n" .. "  Tried: `(false ?msg)`\n  Tried: `(true ?tbl)`")
			end
		else
			return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `(nil ?msg)`\n  Tried: `(?fun)`")
		end
	end
end
native1 = function(meta, global)
	local out = {["out"]={tag="list", n=0}, ["indent"]=0, ["tabs-pending"]=false, ["line"]=1, ["lines"]={}, ["node-stack"]={tag="list", n=0}, ["active-pos"]=nil}
	prelude1(out)
	append_21_1(out, "return ")
	compileNative1(out, meta)
	local temp = list1(load1(concat1(out["out"]), "=" .. meta["name"], "t", global))
	if type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (nth1(temp, 1) == nil and true))) then
		local msg = nth1(temp, 2)
		return error1("Cannot compile meta " .. meta["name"] .. ":\n" .. msg, 0)
	elseif type1(temp) == "list" and (n1(temp) >= 1 and (n1(temp) <= 1 and true)) then
		return nth1(temp, 1)()
	else
		return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `(nil ?msg)`\n  Tried: `(?fun)`")
	end
end
emitLua1 = {["name"]="emit-lua", ["setup"]=function(spec)
	addArgument_21_1(spec, {tag="list", n=1, "--emit-lua"}, "help", "Emit a Lua file.", "narg", "?", "var", "OUTPUT", "value", true, "cat", "out")
	addArgument_21_1(spec, {tag="list", n=1, "--shebang"}, "help", "Set the executable to use for the shebang.", "cat", "out", "value", arg1[-1] or (arg1[0] or "lua"), "narg", "?")
	return addArgument_21_1(spec, {tag="list", n=1, "--chmod"}, "help", "Run chmod +x on the resulting file", "cat", "out")
end, ["pred"]=function(args)
	return args["emit-lua"]
end, ["run"]=function(compiler, args)
	if empty_3f_1(args["input"]) then
		self2(compiler["log"], "put-error!", "No inputs to compile.")
		exit_21_1(1)
	end
	local out = file1(compiler, args["shebang"])
	local name
	if string_3f_1(args["emit-lua"]) then
		name = args["emit-lua"]
	else
		name = args["output"] .. ".lua"
	end
	local handle, error = open1(name, "w")
	if not handle then
		self2(compiler["log"], "put-error!", (sprintf1("Cannot open %q (%s)", name, error)))
		exit_21_1(1)
	end
	self2(handle, "write", concat1(out["out"]))
	self2(handle, "close")
	if args["chmod"] then
		return execute1("chmod +x " .. quoted1(name))
	else
		return nil
	end
end}
emitLisp1 = {["name"]="emit-lisp", ["setup"]=function(spec)
	return addArgument_21_1(spec, {tag="list", n=1, "--emit-lisp"}, "help", "Emit a Lisp file.", "narg", "?", "var", "OUTPUT", "value", true, "cat", "out")
end, ["pred"]=function(args)
	return args["emit-lisp"]
end, ["run"]=function(compiler, args)
	if empty_3f_1(args["input"]) then
		self2(compiler["log"], "put-error!", "No inputs to compile.")
		exit_21_1(1)
	end
	local writer = {["out"]={tag="list", n=0}, ["indent"]=0, ["tabs-pending"]=false, ["line"]=1, ["lines"]={}, ["node-stack"]={tag="list", n=0}, ["active-pos"]=nil}
	local name
	if string_3f_1(args["emit-lisp"]) then
		name = args["emit-lisp"]
	else
		name = args["output"] .. ".lisp"
	end
	block1(compiler["out"], writer)
	local handle, error = open1(name, "w")
	if not handle then
		self2(compiler["log"], "put-error!", (sprintf1("Cannot open %q (%s)", args["output"] .. ".lisp", error)))
		exit_21_1(1)
	end
	self2(handle, "write", concat1(writer["out"]))
	return self2(handle, "close")
end}
passArg1 = function(arg, data, value, usage_21_)
	local val, name = tonumber1(value), arg["name"] .. "-override"
	local override = data[name]
	if not override then
		override = {}
		data[name] = override
	end
	if val then
		data[arg["name"]] = val
		return nil
	elseif sub1(value, 1, 1) == "-" then
		override[sub1(value, 2)] = false
		return nil
	elseif sub1(value, 1, 1) == "+" then
		override[sub1(value, 2)] = true
		return nil
	else
		return usage_21_("Expected number or enable/disable flag for --" .. arg["name"] .. " , got " .. value)
	end
end
passRun1 = function(fun, name)
	return function(compiler, args)
		local options = {["track"]=true, ["level"]=args[name], ["override"]=args[name .. "-override"] or {}, ["max-n"]=args[name .. "-n"], ["max-time"]=args[name .. "-time"], ["compiler"]=compiler, ["meta"]=compiler["lib-meta"], ["libs"]=compiler["libs"], ["logger"]=compiler["log"], ["timer"]=compiler["timer"]}
		return fun(compiler["out"], options, filterPasses1(compiler[name], options))
	end
end
warning1 = {["name"]="warning", ["setup"]=function(spec)
	return addArgument_21_1(spec, {tag="list", n=2, "--warning", "-W"}, "help", "Either the warning level to use or an enable/disable flag for a pass.", "default", 1, "narg", 1, "var", "LEVEL", "many", true, "action", passArg1)
end, ["pred"]=function()
	return true
end, ["run"]=passRun1(analyse1, "warning")}
optimise2 = {["name"]="optimise", ["setup"]=function(spec)
	addCategory_21_1(spec, "optimise", "Optimisation", "Various controls for how the source code is optimised.")
	addArgument_21_1(spec, {tag="list", n=2, "--optimise", "-O"}, "help", "Either the optimisation level to use or an enable/disable flag for a pass.", "cat", "optimise", "default", 1, "narg", 1, "var", "LEVEL", "many", true, "action", passArg1)
	addArgument_21_1(spec, {tag="list", n=2, "--optimise-n", "--optn"}, "help", "The maximum number of iterations the optimiser should run for.", "cat", "optimise", "default", 10, "narg", 1, "action", setNumAction1)
	return addArgument_21_1(spec, {tag="list", n=2, "--optimise-time", "--optt"}, "help", "The maximum time the optimiser should run for.", "cat", "optimise", "default", -1, "narg", 1, "action", setNumAction1)
end, ["pred"]=function()
	return true
end, ["run"]=passRun1(optimise1, "optimise")}
formatRange2 = function(range)
	return format1("%s:%s", range["name"], (function()
		local pos = range["start"]
		return pos["line"] .. ":" .. pos["column"]
	end)())
end
sortVars_21_1 = function(list)
	sort1(list, function(a, b)
		return car1(a) < car1(b)
	end)
	return list
end
formatDefinition1 = function(var)
	local temp = var["kind"]
	if temp == "builtin" then
		return "Builtin term"
	elseif temp == "macro" then
		return "Macro defined at " .. formatRange2(getSource1(var["node"]))
	elseif temp == "native" then
		return "Native defined at " .. formatRange2(getSource1(var["node"]))
	elseif temp == "defined" then
		return "Defined at " .. formatRange2(getSource1(var["node"]))
	else
		return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"builtin\"`\n  Tried: `\"macro\"`\n  Tried: `\"native\"`\n  Tried: `\"defined\"`")
	end
end
formatSignature1 = function(name, var)
	local sig = extractSignature1(var)
	if sig == nil then
		return name
	elseif empty_3f_1(sig) then
		return "(" .. name .. ")"
	else
		return "(" .. name .. " " .. concat1(map2(on1("contents"), sig), " ") .. ")"
	end
end
writeDocstring1 = function(out, str, scope)
	local temp = parseDocstring1(str)
	local temp1 = n1(temp)
	local temp2 = 1
	while temp2 <= temp1 do
		local tok = temp[temp2]
		local ty = tok["kind"]
		if ty == "text" then
			append_21_1(out, tok["contents"])
		elseif ty == "boldic" then
			append_21_1(out, tok["contents"])
		elseif ty == "bold" then
			append_21_1(out, tok["contents"])
		elseif ty == "italic" then
			append_21_1(out, tok["contents"])
		elseif ty == "arg" then
			append_21_1(out, "`" .. tok["contents"] .. "`")
		elseif ty == "mono" then
			append_21_1(out, gsub1(tok["whole"], "^```(%S+)[^\n]*", "```%1"))
		elseif ty == "link" then
			local name = tok["contents"]
			local ovar = get1(scope, name)
			if ovar and ovar["node"] then
				local loc, sig = gsub1(gsub1(getSource1((ovar["node"]))["name"], "%.lisp$", ""), "/", "."), extractSignature1(ovar)
				append_21_1(out, format1("[`%s`](%s.md#%s)", name, loc, gsub1((function()
					if sig == nil then
						return ovar["name"]
					elseif empty_3f_1(sig) then
						return ovar["name"]
					else
						return name .. " " .. concat1(map2(on1("contents"), sig), " ")
					end
				end)(), "%A+", "-")))
			else
				append_21_1(out, format1("`%s`", name))
			end
		else
			_error("unmatched item")
		end
		temp2 = temp2 + 1
	end
	return line_21_1(out)
end
exported1 = function(out, title, primary, vars, scope)
	local documented, undocumented = {tag="list", n=0}, {tag="list", n=0}
	iterPairs1(vars, function(name, var)
		return pushCdr_21_1((function()
			if var["doc"] then
				return documented
			else
				return undocumented
			end
		end)(), list1(name, var))
	end)
	sortVars_21_1(documented)
	sortVars_21_1(undocumented)
	line_21_1(out, "---")
	line_21_1(out, "title: " .. title)
	line_21_1(out, "---")
	line_21_1(out, "# " .. title)
	if primary then
		writeDocstring1(out, primary, scope)
		line_21_1(out, "", true)
	end
	local temp = n1(documented)
	local temp1 = 1
	while temp1 <= temp do
		local entry = documented[temp1]
		local name, var = car1(entry), nth1(entry, 2)
		line_21_1(out, "## `" .. formatSignature1(name, var) .. "`")
		line_21_1(out, "*" .. formatDefinition1(var) .. "*")
		line_21_1(out, "", true)
		if var["deprecated"] then
			if string_3f_1(var["deprecated"]) then
				append_21_1(out, format1(">**Warning:** %s is deprecated: ", name))
				writeDocstring1(out, var["deprecated"], var["scope"])
			else
				append_21_1(out, format1(">**Warning:** %s is deprecated.", name))
			end
			line_21_1(out, "", true)
		end
		writeDocstring1(out, var["doc"], var["scope"])
		line_21_1(out, "", true)
		temp1 = temp1 + 1
	end
	if not empty_3f_1(undocumented) then
		line_21_1(out, "## Undocumented symbols")
	end
	local temp = n1(undocumented)
	local temp1 = 1
	while temp1 <= temp do
		local entry = undocumented[temp1]
		local name, var = car1(entry), nth1(entry, 2)
		line_21_1(out, " - `" .. formatSignature1(name, var) .. "` *" .. formatDefinition1(var) .. "*")
		temp1 = temp1 + 1
	end
	return nil
end
docs1 = function(compiler, args)
	if empty_3f_1(args["input"]) then
		self2(compiler["log"], "put-error!", "No inputs to generate documentation for.")
		exit_21_1(1)
	end
	local temp = args["input"]
	local temp1 = n1(temp)
	local temp2 = 1
	while temp2 <= temp1 do
		local path = temp[temp2]
		if sub1(path, -5) == ".lisp" then
			path = sub1(path, 1, -6)
		end
		local lib, writer = compiler["lib-cache"][path], {["out"]={tag="list", n=0}, ["indent"]=0, ["tabs-pending"]=false, ["line"]=1, ["lines"]={}, ["node-stack"]={tag="list", n=0}, ["active-pos"]=nil}
		exported1(writer, lib["name"], lib["docs"], lib["scope"]["exported"], lib["scope"])
		local handle = open1(args["docs"] .. "/" .. gsub1(path, "/", ".") .. ".md", "w")
		self2(handle, "write", concat1(writer["out"]))
		self2(handle, "close")
		temp2 = temp2 + 1
	end
	return nil
end
task1 = {["name"]="docs", ["setup"]=function(spec)
	return addArgument_21_1(spec, {tag="list", n=1, "--docs"}, "help", "Specify the folder to emit documentation to.", "cat", "out", "default", nil, "narg", 1)
end, ["pred"]=function(args)
	return nil ~= args["docs"]
end, ["run"]=docs1}
local discard = function()
	return nil
end
void1 = {["put-error!"]=discard, ["put-warning!"]=discard, ["put-verbose!"]=discard, ["put-debug!"]=discard, ["put-time!"]=discard, ["put-node-error!"]=discard, ["put-node-warning!"]=discard}
_2a_romanDigits_2a_1 = {["I"]=1, ["V"]=5, ["X"]=10, ["L"]=50, ["C"]=100, ["D"]=500, ["M"]=1000}
romanDigit_3f_1 = function(char)
	return _2a_romanDigits_2a_1[char] or false
end
hexDigit_3f_1 = function(char)
	return between_3f_1(char, "0", "9") or (between_3f_1(char, "a", "f") or between_3f_1(char, "A", "F"))
end
binDigit_3f_1 = function(char)
	return char == "0" or char == "1"
end
terminator_3f_1 = function(char)
	return char == "\n" or (char == " " or (char == "\9" or (char == ";" or (char == "(" or (char == ")" or (char == "[" or (char == "]" or (char == "{" or (char == "}" or char == "")))))))))
end
digitError_21_1 = function(logger, pos, name, char)
	return doNodeError_21_1(logger, format1("Expected %s digit, got %s", name, (function()
		if char == "" then
			return "eof"
		else
			return quoted1(char)
		end
	end)()), pos, nil, pos, "Invalid digit here")
end
eofError_21_1 = function(context, tokens, logger, msg, node, explain, ...)
	local lines = _pack(...) lines.tag = "list"
	if context then
		return error1({["msg"]=msg, ["context"]=context, ["tokens"]=tokens}, 0)
	else
		return doNodeError_21_1(logger, msg, node, explain, unpack1(lines, 1, n1(lines)))
	end
end
lex1 = function(logger, str, name, cont)
	str = gsub1(str, "\13\n?", "\n")
	local lines, line, column, offset, length, out = split1(str, "\n"), 1, 1, 1, n1(str), {tag="list", n=0}
	local consume_21_, range = function()
		if (function()
			local xs, x = str, offset
			return sub1(xs, x, x)
		end)() == "\n" then
			line = line + 1
			column = 1
		else
			column = column + 1
		end
		offset = offset + 1
		return nil
	end, function(start, finish)
		return {["start"]=start, ["finish"]=finish or start, ["lines"]=lines, ["name"]=name}
	end
	local appendWith_21_, parseRoman, parseBase = function(data, start, finish)
		local start1, finish1 = start or {["line"]=line, ["column"]=column, ["offset"]=offset}, finish or {["line"]=line, ["column"]=column, ["offset"]=offset}
		data["range"] = range(start1, finish1)
		data["contents"] = sub1(str, start1["offset"], finish1["offset"])
		return pushCdr_21_1(out, data)
	end, function()
		local start = offset
		local char
		local xs, x = str, offset
		char = sub1(xs, x, x)
		if not romanDigit_3f_1(char) then
			digitError_21_1(logger, range({["line"]=line, ["column"]=column, ["offset"]=offset}), "roman", char)
		end
		local xs, x = str, offset + 1
		char = sub1(xs, x, x)
		while romanDigit_3f_1(char) or char == "'" do
			consume_21_()
			local xs, x = str, offset + 1
			char = sub1(xs, x, x)
		end
		local str1 = apply1(_2e2e_1, split1(reverse1(sub1(str, start, offset)), "'"))
		return car1(reduce1(function(temp1, temp2, ...)
			local tempRemainingArguments = _pack(...) tempRemainingArguments.tag = "list"
			local temp = append1(list1(temp1, temp2), tempRemainingArguments)
			local temp3
			if type1(temp) == "list" then
				if n1(temp) >= 2 then
					if n1(temp) <= 2 then
						local temp4
						local temp5 = nth1(temp, 1)
						temp4 = type1(temp5) == "list" and (n1(temp5) >= 2 and (n1(temp5) <= 2 and true))
						if temp4 then
							temp3 = true
						else
							temp3 = false
						end
					else
						temp3 = false
					end
				else
					temp3 = false
				end
			else
				temp3 = false
			end
			if temp3 then
				local acc, prev, n = nth1(nth1(temp, 1), 1), nth1(nth1(temp, 1), 2), nth1(temp, 2)
				return list1((function()
					if n < prev then
						return _2d_1
					else
						return _2b_1
					end
				end)()(acc, n), max1(n, prev))
			else
				return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `((?acc ?prev) ?n)`")
			end
		end, list1(0, 0), map2(comp1(function(temp)
			return _2a_romanDigits_2a_1[temp]
		end, upper1, function(temp)
			return sub1(str1, temp, temp)
		end), range1("from", 1, "to", n1(str1)))))
	end, function(name2, p, base)
		local start = offset
		local char
		local xs, x = str, offset
		char = sub1(xs, x, x)
		if not p(char) then
			digitError_21_1(logger, range({["line"]=line, ["column"]=column, ["offset"]=offset}), name2, char)
		end
		local xs, x = str, offset + 1
		char = sub1(xs, x, x)
		while p(char) or "'" == char do
			consume_21_()
			local xs, x = str, offset + 1
			char = sub1(xs, x, x)
		end
		return tonumber1(apply1(_2e2e_1, split1(sub1(str, start, offset), "'")), base)
	end
	while offset <= length do
		local char
		local xs, x = str, offset
		char = sub1(xs, x, x)
		if char == "\n" or char == "\9" or char == " " then
		elseif char == "(" then
			appendWith_21_({["tag"]="open", ["close"]=")"})
		elseif char == ")" then
			appendWith_21_({["tag"]="close", ["open"]="("})
		elseif char == "[" then
			appendWith_21_({["tag"]="open", ["close"]="]"})
		elseif char == "]" then
			appendWith_21_({["tag"]="close", ["open"]="["})
		elseif char == "{" then
			appendWith_21_({["tag"]="open-struct", ["close"]="}"})
		elseif char == "}" then
			appendWith_21_({["tag"]="close", ["open"]="{"})
		elseif char == "'" then
			appendWith_21_({["tag"]="quote"}, nil, nil)
		elseif char == "`" then
			appendWith_21_({["tag"]="syntax-quote"}, nil, nil)
		elseif char == "~" then
			appendWith_21_({["tag"]="quasiquote"}, nil, nil)
		elseif char == "," then
			if (function()
				local xs, x = str, offset + 1
				return sub1(xs, x, x)
			end)() == "@" then
				local start = {["line"]=line, ["column"]=column, ["offset"]=offset}
				consume_21_()
				appendWith_21_({["tag"]="unquote-splice"}, start, nil)
			else
				appendWith_21_({["tag"]="unquote"}, nil, nil)
			end
		elseif find1(str, "^%-?%.?[#0-9]", offset) then
			local start, negative = {["line"]=line, ["column"]=column, ["offset"]=offset}, char == "-"
			if negative then
				consume_21_()
				local xs, x = str, offset
				char = sub1(xs, x, x)
			end
			if char == "#" and lower1((function()
				local xs, x = str, offset + 1
				return sub1(xs, x, x)
			end)()) == "x" then
				consume_21_()
				consume_21_()
				local res = parseBase("hexadecimal", hexDigit_3f_1, 16)
				if negative then
					res = 0 - res
				end
				appendWith_21_({["tag"]="number", ["value"]=res}, start)
			elseif char == "#" and lower1((function()
				local xs, x = str, offset + 1
				return sub1(xs, x, x)
			end)()) == "b" then
				consume_21_()
				consume_21_()
				local res = parseBase("binary", binDigit_3f_1, 2)
				if negative then
					res = 0 - res
				end
				appendWith_21_({["tag"]="number", ["value"]=res}, start)
			elseif char == "#" and lower1((function()
				local xs, x = str, offset + 1
				return sub1(xs, x, x)
			end)()) == "r" then
				consume_21_()
				consume_21_()
				local res = parseRoman()
				if negative then
					res = 0 - res
				end
				appendWith_21_({["tag"]="number", ["value"]=res}, start)
			elseif char == "#" and terminator_3f_1(lower1((function()
				local xs, x = str, offset + 1
				return sub1(xs, x, x)
			end)())) then
				doNodeError_21_1(logger, "Expected hexadecimal (#x), binary (#b), or Roman (#r) digit specifier.", range({["line"]=line, ["column"]=column, ["offset"]=offset}), "The '#' character is used for various number representations, such as binary\nand hexadecimal digits.\n\nIf you're looking for the '#' function, this has been replaced with 'n'. We\napologise for the inconvenience.", range({["line"]=line, ["column"]=column, ["offset"]=offset}), "# must be followed by x, b or r")
			elseif char == "#" then
				consume_21_()
				doNodeError_21_1(logger, "Expected hexadecimal (#x), binary (#b), or Roman (#r) digit specifier.", range({["line"]=line, ["column"]=column, ["offset"]=offset}), "The '#' character is used for various number representations, namely binary,\nhexadecimal and roman numbers.", range({["line"]=line, ["column"]=column, ["offset"]=offset}), "# must be followed by x, b or r")
			else
				while between_3f_1((function()
					local xs, x = str, offset + 1
					return sub1(xs, x, x)
				end)(), "0", "9") or (function()
					local xs, x = str, offset + 1
					return sub1(xs, x, x)
				end)() == "'" do
					consume_21_()
				end
				if (function()
					local xs, x = str, offset + 1
					return sub1(xs, x, x)
				end)() == "/" then
					local numEnd, _5f_, _5f_1, domStart = {["line"]=line, ["column"]=column, ["offset"]=offset}, consume_21_(), consume_21_(), {["line"]=line, ["column"]=column, ["offset"]=offset}
					if not (between_3f_1((function()
						local xs, x = str, offset
						return sub1(xs, x, x)
					end)(), "0", "9") or (function()
						local xs, x = str, offset
						return sub1(xs, x, x)
					end)() == "'") then
						doNodeError_21_1(logger, formatOutput_21_1(nil, "Expected digit, got " .. quoted1((function()
							local xs, x = str, offset
							return sub1(xs, x, x)
						end)())), range(domStart), "", range(domStart), "")
					end
					while between_3f_1((function()
						local xs, x = str, offset + 1
						return sub1(xs, x, x)
					end)(), "0", "9") or (function()
						local xs, x = str, offset + 1
						return sub1(xs, x, x)
					end)() == "'" do
						consume_21_()
					end
					local domEnd, num = {["line"]=line, ["column"]=column, ["offset"]=offset}, tonumber1(gsub1(sub1(str, start["offset"], numEnd["offset"]), "'", ""), 10)
					local dom = tonumber1(gsub1(sub1(str, domStart["offset"], domEnd["offset"]), "'", ""), 10)
					if not num then
						doNodeError_21_1(logger, "Invalid numerator in rational literal", range(start, numEnd), "", range(start, numEnd), "There should be at least one number before the division symbol.")
					end
					if not dom then
						doNodeError_21_1(logger, "Invalid denominator in rational literal", range(domStart, domEnd), "", range(domStart, domEnd), "There should be at least one number after the division symbol.")
					end
					appendWith_21_({["tag"]="rational", ["num"]={["tag"]="number", ["value"]=num, ["range"]=range(start, numEnd)}, ["dom"]={["tag"]="number", ["value"]=dom, ["range"]=range(domStart, domEnd)}}, start)
				else
					if (function()
						local xs, x = str, offset + 1
						return sub1(xs, x, x)
					end)() == "." then
						consume_21_()
						while between_3f_1((function()
							local xs, x = str, offset + 1
							return sub1(xs, x, x)
						end)(), "0", "9") or (function()
							local xs, x = str, offset + 1
							return sub1(xs, x, x)
						end)() == "'" do
							consume_21_()
						end
					end
					local xs, x = str, offset + 1
					char = sub1(xs, x, x)
					if char == "e" or char == "E" then
						consume_21_()
						local xs, x = str, offset + 1
						char = sub1(xs, x, x)
						if char == "-" or char == "+" then
							consume_21_()
						end
						while between_3f_1((function()
							local xs, x = str, offset + 1
							return sub1(xs, x, x)
						end)(), "0", "9") or (function()
							local xs, x = str, offset + 1
							return sub1(xs, x, x)
						end)() == "'" do
							consume_21_()
						end
					end
					appendWith_21_({["tag"]="number", ["value"]=tonumber1((gsub1(sub1(str, start["offset"], offset), "'", "")))}, start)
				end
			end
			local xs, x = str, offset + 1
			char = sub1(xs, x, x)
			if not terminator_3f_1(char) then
				consume_21_()
				doNodeError_21_1(logger, format1("Expected digit, got %s", (function()
					if char == "" then
						return "eof"
					else
						return char
					end
				end)()), range({["line"]=line, ["column"]=column, ["offset"]=offset}), nil, range({["line"]=line, ["column"]=column, ["offset"]=offset}), "Illegal character here. Are you missing whitespace?")
			end
		elseif char == "\"" or char == "$" and (function()
			local xs, x = str, offset + 1
			return sub1(xs, x, x)
		end)() == "\"" then
			local start, startCol, buffer, interpolate = {["line"]=line, ["column"]=column, ["offset"]=offset}, column + 1, {tag="list", n=0}, char == "$"
			if interpolate then
				consume_21_()
			end
			consume_21_()
			local xs, x = str, offset
			char = sub1(xs, x, x)
			while char ~= "\"" do
				if column == 1 then
					local running, lineOff = true, offset
					while running and column < startCol do
						if char == " " then
							consume_21_()
						elseif char == "\n" then
							consume_21_()
							pushCdr_21_1(buffer, "\n")
							lineOff = offset
						elseif char == "" then
							running = false
						else
							putNodeWarning_21_1(logger, format1("Expected leading indent, got %q", char), range({["line"]=line, ["column"]=column, ["offset"]=offset}), "You should try to align multi-line strings at the initial quote\nmark. This helps keep programs neat and tidy.", range(start), "String started with indent here", range({["line"]=line, ["column"]=column, ["offset"]=offset}), "Mis-aligned character here")
							pushCdr_21_1(buffer, sub1(str, lineOff, offset - 1))
							running = false
						end
						local xs, x = str, offset
						char = sub1(xs, x, x)
					end
				end
				if char == "" then
					local start1, finish = range(start), range({["line"]=line, ["column"]=column, ["offset"]=offset})
					eofError_21_1(cont and "string", out, logger, "Expected '\"', got eof", finish, nil, start1, "string started here", finish, "end of file here")
				elseif char == "\\" then
					consume_21_()
					local xs, x = str, offset
					char = sub1(xs, x, x)
					if char == "\n" then
					elseif char == "a" then
						pushCdr_21_1(buffer, "\7")
					elseif char == "b" then
						pushCdr_21_1(buffer, "\8")
					elseif char == "f" then
						pushCdr_21_1(buffer, "\12")
					elseif char == "n" then
						pushCdr_21_1(buffer, "\n")
					elseif char == "r" then
						pushCdr_21_1(buffer, "\13")
					elseif char == "t" then
						pushCdr_21_1(buffer, "\9")
					elseif char == "v" then
						pushCdr_21_1(buffer, "\11")
					elseif char == "\"" then
						pushCdr_21_1(buffer, "\"")
					elseif char == "\\" then
						pushCdr_21_1(buffer, "\\")
					elseif char == "x" or char == "X" or between_3f_1(char, "0", "9") then
						local start1 = {["line"]=line, ["column"]=column, ["offset"]=offset}
						local val
						if char == "x" or char == "X" then
							consume_21_()
							local start2 = offset
							if not hexDigit_3f_1((function()
								local xs, x = str, offset
								return sub1(xs, x, x)
							end)()) then
								digitError_21_1(logger, range({["line"]=line, ["column"]=column, ["offset"]=offset}), "hexadecimal", (function()
									local xs, x = str, offset
									return sub1(xs, x, x)
								end)())
							end
							if hexDigit_3f_1((function()
								local xs, x = str, offset + 1
								return sub1(xs, x, x)
							end)()) then
								consume_21_()
							end
							val = tonumber1(sub1(str, start2, offset), 16)
						else
							local start2, ctr = {["line"]=line, ["column"]=column, ["offset"]=offset}, 0
							local xs, x = str, offset + 1
							char = sub1(xs, x, x)
							while ctr < 2 and between_3f_1(char, "0", "9") do
								consume_21_()
								local xs, x = str, offset + 1
								char = sub1(xs, x, x)
								ctr = ctr + 1
							end
							val = tonumber1(sub1(str, start2["offset"], offset))
						end
						if val >= 256 then
							doNodeError_21_1(logger, "Invalid escape code", range(start1), nil, range(start1, {["line"]=line, ["column"]=column, ["offset"]=offset}), "Must be between 0 and 255, is " .. val)
						end
						pushCdr_21_1(buffer, char1(val))
					elseif char == "" then
						eofError_21_1(cont and "string", out, logger, "Expected escape code, got eof", range({["line"]=line, ["column"]=column, ["offset"]=offset}), nil, range({["line"]=line, ["column"]=column, ["offset"]=offset}), "end of file here")
					else
						doNodeError_21_1(logger, "Illegal escape character", range({["line"]=line, ["column"]=column, ["offset"]=offset}), nil, range({["line"]=line, ["column"]=column, ["offset"]=offset}), "Unknown escape character")
					end
				else
					pushCdr_21_1(buffer, char)
				end
				consume_21_()
				local xs, x = str, offset
				char = sub1(xs, x, x)
			end
			if interpolate then
				local value, sections, len = concat1(buffer), {tag="list", n=0}, n1(str)
				local i = 1
				while true do
					local rs, re, rm = find1(value, "~%{([^%} ]+)%}", i)
					local is, ie, im = find1(value, "%$%{([^%} ]+)%}", i)
					if rs and (not is or rs < is) then
						pushCdr_21_1(sections, sub1(value, i, rs - 1))
						pushCdr_21_1(sections, "{#" .. rm .. "}")
						i = re + 1
					elseif is then
						pushCdr_21_1(sections, sub1(value, i, is - 1))
						pushCdr_21_1(sections, "{#" .. im .. ":id}")
						i = ie + 1
					else
						pushCdr_21_1(sections, sub1(value, i, len))
						break
					end
				end
				putNodeWarning_21_1(logger, "The $ syntax is deprecated and should be replaced with format.", range(start, {["line"]=line, ["column"]=column, ["offset"]=offset}), nil, range(start, {["line"]=line, ["column"]=column, ["offset"]=offset}), "Can be replaced with (format nil " .. quoted1(concat1(sections)) .. ")")
				appendWith_21_({["tag"]="interpolate", ["value"]=value}, start)
			else
				appendWith_21_({["tag"]="string", ["value"]=concat1(buffer)}, start)
			end
		elseif char == ";" then
			while offset <= length and (function()
				local xs, x = str, offset + 1
				return sub1(xs, x, x)
			end)() ~= "\n" do
				consume_21_()
			end
		else
			local start, key = {["line"]=line, ["column"]=column, ["offset"]=offset}, char == ":"
			local xs, x = str, offset + 1
			char = sub1(xs, x, x)
			while not terminator_3f_1(char) do
				consume_21_()
				local xs, x = str, offset + 1
				char = sub1(xs, x, x)
			end
			if key then
				appendWith_21_({["tag"]="key", ["value"]=sub1(str, start["offset"] + 1, offset)}, start)
			else
				appendWith_21_({["tag"]="symbol"}, start, nil)
			end
		end
		consume_21_()
	end
	appendWith_21_({["tag"]="eof"}, nil, nil)
	return out
end
parse1 = function(logger, toks, cont)
	local head, stack = {tag="list", n=0}, {tag="list", n=0}
	local pop_21_ = function()
		head["open"] = nil
		head["close"] = nil
		head["auto-close"] = nil
		head["last-node"] = nil
		head = last1(stack)
		return popLast_21_1(stack)
	end
	local temp = n1(toks)
	local temp1 = 1
	while temp1 <= temp do
		local tok = toks[temp1]
		local tag, autoClose = type1(tok), false
		local previous, tokPos = head["last-node"], tok["range"]
		local temp2
		if tag ~= "eof" then
			if tag ~= "close" then
				if head["range"] then
					temp2 = tokPos["start"]["line"] ~= head["range"]["start"]["line"]
				else
					temp2 = true
				end
			else
				temp2 = false
			end
		else
			temp2 = false
		end
		if temp2 then
			if previous then
				local prevPos = previous["range"]
				if tokPos["start"]["line"] ~= prevPos["start"]["line"] then
					head["last-node"] = tok
					if tokPos["start"]["column"] ~= prevPos["start"]["column"] then
						putNodeWarning_21_1(logger, "Different indent compared with previous expressions.", tok, "You should try to maintain consistent indentation across a program,\ntry to ensure all expressions are lined up.\nIf this looks OK to you, check you're not missing a closing ')'.", prevPos, "", tokPos, "")
					end
				end
			else
				head["last-node"] = tok
			end
		end
		if tag == "string" or tag == "number" or tag == "symbol" or tag == "key" then
			pushCdr_21_1(head, tok)
		elseif tag == "interpolate" then
			local node = {["tag"]="list", ["n"]=2, ["range"]=tok["range"], [1]={["tag"]="symbol", ["contents"]="$", ["range"]={["start"]=tok["range"]["start"], ["finish"]=tok["range"]["start"], ["name"]=tok["range"]["name"], ["lines"]=tok["range"]["lines"]}}, [2]={["tag"]="string", ["value"]=tok["value"], ["range"]=tok["range"]}}
			pushCdr_21_1(head, node)
		elseif tag == "rational" then
			local node = {["tag"]="list", ["n"]=3, ["range"]=tok["range"], [1]={["tag"]="symbol", ["contents"]="rational", ["range"]=tok["range"]}, [2]=tok["num"], [3]=tok["dom"]}
			pushCdr_21_1(head, node)
		elseif tag == "open" then
			local next = {tag="list", n=0}
			pushCdr_21_1(stack, head)
			pushCdr_21_1(head, next)
			head = next
			head["open"] = tok["contents"]
			head["close"] = tok["close"]
			head["range"] = {["start"]=tok["range"]["start"], ["name"]=tok["range"]["name"], ["lines"]=tok["range"]["lines"]}
		elseif tag == "open-struct" then
			local next = {tag="list", n=0}
			pushCdr_21_1(stack, head)
			pushCdr_21_1(head, next)
			head = next
			head["open"] = tok["contents"]
			head["close"] = tok["close"]
			head["range"] = {["start"]=tok["range"]["start"], ["name"]=tok["range"]["name"], ["lines"]=tok["range"]["lines"]}
			local node = {["tag"]="symbol", ["contents"]="struct-literal", ["range"]=head["range"]}
			pushCdr_21_1(head, node)
		elseif tag == "close" then
			if empty_3f_1(stack) then
				doNodeError_21_1(logger, format1("'%s' without matching '%s'", tok["contents"], tok["open"]), tok, nil, getSource1(tok), "")
			elseif head["auto-close"] then
				doNodeError_21_1(logger, format1("'%s' without matching '%s' inside quote", tok["contents"], tok["open"]), tok, nil, head["range"], "quote opened here", tok["range"], "attempting to close here")
			elseif head["close"] ~= tok["contents"] then
				doNodeError_21_1(logger, format1("Expected '%s', got '%s'", head["close"], tok["contents"]), tok, nil, head["range"], format1("block opened with '%s'", head["open"]), tok["range"], format1("'%s' used here", tok["contents"]))
			else
				head["range"]["finish"] = tok["range"]["finish"]
				pop_21_()
			end
		elseif tag == "quote" or tag == "unquote" or tag == "syntax-quote" or tag == "unquote-splice" or tag == "quasiquote" then
			local next = {tag="list", n=0}
			pushCdr_21_1(stack, head)
			pushCdr_21_1(head, next)
			head = next
			head["range"] = {["start"]=tok["range"]["start"], ["name"]=tok["range"]["name"], ["lines"]=tok["range"]["lines"]}
			local node = {["tag"]="symbol", ["contents"]=tag, ["range"]=tok["range"]}
			pushCdr_21_1(head, node)
			autoClose = true
			head["auto-close"] = true
		elseif tag == "eof" then
			if 0 ~= n1(stack) then
				eofError_21_1(cont and "list", toks, logger, format1("Expected '%s', got 'eof'", head["close"]), tok, nil, head["range"], "block opened here", tok["range"], "end of file here")
			end
		else
			error1("Unsupported type " .. tag)
		end
		if not autoClose then
			while head["auto-close"] do
				if empty_3f_1(stack) then
					doNodeError_21_1(logger, format1("'%s' without matching '%s'", tok["contents"], tok["open"]), tok, nil, getSource1(tok), "")
				end
				head["range"]["finish"] = tok["range"]["finish"]
				pop_21_()
			end
		end
		temp1 = temp1 + 1
	end
	return head
end
read2 = function(x, path)
	return parse1(void1, lex1(void1, x, path or ""))
end
expectType_21_1 = function(log, node, parent, expectedType, name)
	if type1(node) ~= expectedType then
		local node1, message = node or parent, "Expected " .. (name or expectedType) .. ", got " .. (function()
			if node then
				return type1(node)
			else
				return "nothing"
			end
		end)()
		return doNodeError_21_2(log, message, node1, nil, getSource1(node1), "")
	else
		return nil
	end
end
expect_21_1 = function(log, node, parent, name)
	if node then
		return nil
	else
		return doNodeError_21_2(log, "Expected " .. name .. ", got nothing", parent, nil, getSource1(parent), "")
	end
end
maxLength_21_1 = function(log, node, len, name)
	if n1(node) > len then
		local node1, message = nth1(node, len + 1), "Unexpected node in '" .. name .. "' (expected " .. len .. " values, got " .. n1(node) .. ")"
		return doNodeError_21_2(log, message, node1, nil, getSource1(node1), "")
	else
		return nil
	end
end
errorInternal_21_1 = function(log, node, message)
	return doNodeError_21_2(log, "[Internal]" .. message, node, nil, getSource1(node), "")
end
handleMetadata1 = function(log, node, var, start, finish)
	local i = start
	while i <= finish do
		local child = nth1(node, i)
		local temp = type1(child)
		if temp == "nil" then
			expect_21_1(log, child, node, "variable metadata")
		elseif temp == "string" then
			if var["doc"] then
				doNodeError_21_2(log, "Multiple doc strings in definition", child, nil, getSource1(child), "")
			end
			var["doc"] = child["value"]
		elseif temp == "key" then
			local temp1 = child["value"]
			if temp1 == "hidden" then
				var["scope"]["exported"][var["name"]] = nil
			elseif temp1 == "deprecated" then
				local message = true
				if i < finish and string_3f_1(nth1(node, i + 1)) then
					message = nth1(node, i + 1)["value"]
					i = i + 1
				end
				var["deprecated"] = message
			else
				doNodeError_21_2(log, "Unexpected modifier '" .. pretty1(child) .. "'", child, nil, getSource1(child), "")
			end
		else
			doNodeError_21_2(log, "Unexpected node of type " .. temp .. ", have you got too many values", child, nil, getSource1(child), "")
		end
		i = i + 1
	end
	return nil
end
resolveExecuteResult1 = function(owner, node, parent, scope, state)
	local temp = type_23_1(node)
	if temp == "string" then
		node = {["tag"]="string", ["value"]=node}
	elseif temp == "number" then
		node = {["tag"]="number", ["value"]=node}
	elseif temp == "boolean" then
		node = {["tag"]="symbol", ["contents"]=tostring1(node), ["var"]=builtins1[node]}
	elseif temp == "table" then
		local tag = type1(node)
		if tag == "symbol" or tag == "string" or tag == "number" or tag == "key" or tag == "list" then
			local copy = {}
			local temp1 = node
			local temp2, v = next1(temp1)
			while temp2 ~= nil do
				copy[temp2] = v
				temp2, v = next1(temp1, temp2)
			end
			node = copy
		else
			doNodeError_21_2(state["logger"], "Invalid node of type " .. type1(node) .. " from " .. name1(owner), parent, nil, getSource1(parent), "")
		end
	else
		doNodeError_21_2(state["logger"], "Invalid node of type " .. type1(node) .. " from " .. name1(owner), parent, nil, getSource1(parent), "")
	end
	if not (node["range"] or node["parent"]) then
		node["owner"] = owner
		node["parent"] = parent
	end
	local temp = type1(node)
	if temp == "list" then
		local temp1 = n1(node)
		local temp2 = 1
		while temp2 <= temp1 do
			node[temp2] = resolveExecuteResult1(owner, nth1(node, temp2), node, scope, state)
			temp2 = temp2 + 1
		end
	elseif temp == "symbol" then
		if string_3f_1(node["var"]) then
			local var = state["compiler"]["variables"][node["var"]]
			if not var then
				local log, node1, message = state["logger"], node, "Invalid variable key " .. quoted1(node["var"]) .. " for " .. pretty1(node)
				doNodeError_21_2(log, message, node1, nil, getSource1(node1), "")
			end
			node["var"] = var
		end
	end
	return node
end
resolveQuote1 = function(node, scope, state, level)
	if level == 0 then
		return resolveNode1(node, scope, state)
	else
		local temp = type1(node)
		if temp == "string" then
			return node
		elseif temp == "number" then
			return node
		elseif temp == "key" then
			return node
		elseif temp == "symbol" then
			if not node["var"] then
				node["var"] = getAlways_21_1(scope, node["contents"], node)
				if not (node["var"]["scope"]["is-root"] or node["var"]["scope"]["builtin"]) then
					doNodeError_21_2(state["logger"], "Cannot use non-top level definition '" .. node["var"]["name"] .. "' in syntax-quote", node, nil, getSource1(node), "")
				end
			end
			return node
		elseif temp == "list" then
			local first = car1(node)
			if first then
				node[1] = resolveQuote1(first, scope, state, level)
				if type1(first) == "symbol" then
					if first["var"] == builtins1["unquote"] then
						level = level - 1
					elseif first["var"] == builtins1["unquote-splice"] then
						level = level - 1
					elseif first["var"] == builtins1["syntax-quote"] then
						level = level + 1
					end
				end
			end
			local temp1 = n1(node)
			local temp2 = 2
			while temp2 <= temp1 do
				node[temp2] = resolveQuote1(nth1(node, temp2), scope, state, level)
				temp2 = temp2 + 1
			end
			return node
		else
			return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"key\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`")
		end
	end
end
resolveNode1 = function(node, scope, state, root, many)
	while true do
		local temp = type1(node)
		if temp == "number" then
			return node
		elseif temp == "string" then
			return node
		elseif temp == "key" then
			return node
		elseif temp == "symbol" then
			if not node["var"] then
				node["var"] = getAlways_21_1(scope, node["contents"], node)
			end
			if node["var"]["kind"] == "builtin" then
				doNodeError_21_2(state["logger"], "Cannot have a raw builtin.", node, nil, getSource1(node), "")
			end
			require_21_1(state, node["var"], node)
			return node
		elseif temp == "list" then
			local first = car1(node)
			local temp1 = type1(first)
			if temp1 == "symbol" then
				if not first["var"] then
					first["var"] = getAlways_21_1(scope, first["contents"], first)
				end
				local func = first["var"]
				local funcState, temp2 = require_21_1(state, func, first), func["kind"]
				if temp2 == "builtin" then
					if func == builtins1["lambda"] then
						expectType_21_1(state["logger"], nth1(node, 2), node, "list", "argument list")
						local childScope, args, hasVariadic = child1(scope), nth1(node, 2), false
						local temp3 = n1(args)
						local temp4 = 1
						while temp4 <= temp3 do
							expectType_21_1(state["logger"], nth1(args, temp4), args, "symbol", "argument")
							local arg = nth1(args, temp4)
							local name = arg["contents"]
							local isVar = sub1(name, 1, 1) == "&"
							if isVar then
								if hasVariadic then
									doNodeError_21_2(state["logger"], "Cannot have multiple variadic arguments", args, nil, getSource1(args), "")
								elseif n1(name) == 1 then
									doNodeError_21_2(state["logger"], (function()
										if temp4 < n1(args) then
											local nextArg = nth1(args, temp4 + 1)
											if type1(args) == "symbol" and sub1(nextArg["contents"], 1, 1) ~= "&" then
												return "\nDid you mean '&" .. nextArg["contents"] .. "'?"
											else
												return ""
											end
										else
											return ""
										end
									end)(), arg, nil, getSource1(arg), "")
								else
									name = sub1(name, 2)
									hasVariadic = true
								end
							end
							local var = addVerbose_21_1(childScope, name, "arg", arg, state["logger"])
							var["display-name"] = arg["display-name"]
							arg["var"] = var
							var["is-variadic"] = isVar
							temp4 = temp4 + 1
						end
						return resolveBlock1(node, 3, childScope, state)
					elseif func == builtins1["cond"] then
						local temp3 = n1(node)
						local temp4 = 2
						while temp4 <= temp3 do
							local case = nth1(node, temp4)
							expectType_21_1(state["logger"], case, node, "list", "case expression")
							expect_21_1(state["logger"], car1(case), case, "condition")
							case[1] = resolveNode1(car1(case), scope, state)
							resolveBlock1(case, 2, scope, state)
							temp4 = temp4 + 1
						end
						return node
					elseif func == builtins1["set!"] then
						expectType_21_1(state["logger"], nth1(node, 2), node, "symbol")
						expect_21_1(state["logger"], nth1(node, 3), node, "value")
						maxLength_21_1(state["logger"], node, 3, "set!")
						local var = getAlways_21_1(scope, nth1(node, 2)["contents"], nth1(node, 2))
						require_21_1(state, var, nth1(node, 2))
						node[2]["var"] = var
						if var["const"] then
							doNodeError_21_2(state["logger"], "Cannot rebind constant " .. var["name"], node, nil, getSource1(node), "")
						end
						node[3] = resolveNode1(nth1(node, 3), scope, state)
						return node
					elseif func == builtins1["quote"] then
						expect_21_1(state["logger"], nth1(node, 2), node, "value")
						maxLength_21_1(state["logger"], node, 2, "quote")
						return node
					elseif func == builtins1["syntax-quote"] then
						expect_21_1(state["logger"], nth1(node, 2), node, "value")
						maxLength_21_1(state["logger"], node, 2, "syntax-quote")
						node[2] = resolveQuote1(nth1(node, 2), scope, state, 1)
						return node
					elseif func == builtins1["unquote"] then
						expect_21_1(state["logger"], nth1(node, 2), node, "value")
						local result, states = {tag="list", n=0}, {tag="list", n=0}
						local temp3 = n1(node)
						local temp4 = 2
						while temp4 <= temp3 do
							local childState = create3(scope, state["compiler"])
							local built = resolveNode1(nth1(node, temp4), scope, childState)
							built_21_1(childState, {["tag"]="list", ["n"]=3, ["range"]=built["range"], ["owner"]=built["owner"], ["parent"]=node, [1]={["tag"]="symbol", ["contents"]="lambda", ["var"]=builtins1["lambda"]}, [2]={tag="list", n=0}, [3]=built})
							local func1 = get_21_1(childState)
							state["compiler"]["active-scope"] = scope
							state["compiler"]["active-node"] = built
							local temp5 = list1(xpcall1(func1, traceback3))
							if type1(temp5) == "list" and (n1(temp5) >= 2 and (n1(temp5) <= 2 and (nth1(temp5, 1) == false and true))) then
								local msg = nth1(temp5, 2)
								doNodeError_21_2(state["logger"], remapTraceback1(state["mappings"], msg), node, nil, getSource1(node), "")
							elseif type1(temp5) == "list" and (n1(temp5) >= 1 and (nth1(temp5, 1) == true and true)) then
								local replacement = slice1(temp5, 2)
								if temp4 == n1(node) then
									local temp6 = n1(replacement)
									local temp7 = 1
									while temp7 <= temp6 do
										local child = replacement[temp7]
										pushCdr_21_1(result, child)
										pushCdr_21_1(states, childState)
										temp7 = temp7 + 1
									end
								elseif n1(replacement) == 1 then
									pushCdr_21_1(result, car1(replacement))
									pushCdr_21_1(states, childState)
								else
									local log, node1, message = state["logger"], nth1(node, temp4), "Expected one value, got " .. n1(replacement)
									doNodeError_21_2(log, message, node1, nil, getSource1(node1), "")
								end
							else
								error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp5) .. ", but none matched.\n" .. "  Tried: `(false ?msg)`\n  Tried: `(true . ?replacement)`")
							end
							temp4 = temp4 + 1
						end
						if n1(result) == 0 or n1(result) == 1 and car1(result) == nil then
							result = list1({["tag"]="symbol", ["contents"]="nil", ["var"]=builtins1["nil"]})
						end
						local temp3 = n1(result)
						local temp4 = 1
						while temp4 <= temp3 do
							result[temp4] = resolveExecuteResult1(nth1(states, temp4), nth1(result, temp4), node, scope, state)
							temp4 = temp4 + 1
						end
						if n1(result) == 1 then
							node = car1(result)
						elseif many then
							result["tag"] = "many"
							return result
						else
							return doNodeError_21_2(state["logger"], "Multiple values returned in a non block context", node, nil, getSource1(node), "")
						end
					elseif func == builtins1["unquote-splice"] then
						maxLength_21_1(state["logger"], node, 2, "unquote-splice")
						local childState = create3(scope, state["compiler"])
						local built = resolveNode1(nth1(node, 2), scope, childState)
						built_21_1(childState, {["tag"]="list", ["n"]=3, ["range"]=built["range"], ["owner"]=built["owner"], ["parent"]=node, [1]={["tag"]="symbol", ["contents"]="lambda", ["var"]=builtins1["lambda"]}, [2]={tag="list", n=0}, [3]=built})
						local func1 = get_21_1(childState)
						state["compiler"]["active-scope"] = scope
						state["compiler"]["active-node"] = built
						local temp3 = list1(xpcall1(func1, traceback3))
						if type1(temp3) == "list" and (n1(temp3) >= 2 and (n1(temp3) <= 2 and (nth1(temp3, 1) == false and true))) then
							local msg = nth1(temp3, 2)
							return doNodeError_21_2(state["logger"], remapTraceback1(state["mappings"], msg), node, nil, getSource1(node), "")
						elseif type1(temp3) == "list" and (n1(temp3) >= 1 and (nth1(temp3, 1) == true and true)) then
							local result = car1((slice1(temp3, 2)))
							if not (type1(result) == "list") then
								doNodeError_21_2(state["logger"], "Expected list from unquote-splice, got '" .. type1(result) .. "'", node, nil, getSource1(node), "")
							end
							if n1(result) == 0 then
								result = list1({["tag"]="symbol", ["contents"]="nil", ["var"]=builtins1["nil"]})
							end
							local temp4 = n1(result)
							local temp5 = 1
							while temp5 <= temp4 do
								result[temp5] = resolveExecuteResult1(childState, nth1(result, temp5), node, scope, state)
								temp5 = temp5 + 1
							end
							if n1(result) == 1 then
								node = car1(result)
							elseif many then
								result["tag"] = "many"
								return result
							else
								return doNodeError_21_2(state["logger"], "Multiple values returned in a non-block context", node, nil, getSource1(node), "")
							end
						else
							return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp3) .. ", but none matched.\n" .. "  Tried: `(false ?msg)`\n  Tried: `(true . ?replacement)`")
						end
					elseif func == builtins1["define"] then
						if not root then
							doNodeError_21_2(state["logger"], "define can only be used on the top level", first, nil, getSource1(first), "")
						end
						expectType_21_1(state["logger"], nth1(node, 2), node, "symbol", "name")
						expect_21_1(state["logger"], nth1(node, 3), node, "value")
						local var = addVerbose_21_1(scope, nth1(node, 2)["contents"], "defined", node, state["logger"])
						var["display-name"] = nth1(node, 2)["display-name"]
						define_21_1(state, var)
						node["def-var"] = var
						handleMetadata1(state["logger"], node, var, 3, n1(node) - 1)
						node[n1(node)] = resolveNode1(nth1(node, n1(node)), scope, state)
						return node
					elseif func == builtins1["define-macro"] then
						if not root then
							doNodeError_21_2(state["logger"], "define-macro can only be used on the top level", first, nil, getSource1(first), "")
						end
						expectType_21_1(state["logger"], nth1(node, 2), node, "symbol", "name")
						expect_21_1(state["logger"], nth1(node, 3), node, "value")
						local var = addVerbose_21_1(scope, nth1(node, 2)["contents"], "macro", node, state["logger"])
						var["display-name"] = nth1(node, 2)["display-name"]
						define_21_1(state, var)
						node["def-var"] = var
						handleMetadata1(state["logger"], node, var, 3, n1(node) - 1)
						node[n1(node)] = resolveNode1(nth1(node, n1(node)), scope, state)
						return node
					elseif func == builtins1["define-native"] then
						if not root then
							doNodeError_21_2(state["logger"], "define-native can only be used on the top level", first, nil, getSource1(first), "")
						end
						expectType_21_1(state["logger"], nth1(node, 2), node, "symbol", "name")
						local var = addVerbose_21_1(scope, nth1(node, 2)["contents"], "native", node, state["logger"])
						var["display-name"] = nth1(node, 2)["display-name"]
						define_21_1(state, var)
						node["def-var"] = var
						handleMetadata1(state["logger"], node, var, 3, n1(node))
						return node
					elseif func == builtins1["import"] then
						expectType_21_1(state["logger"], nth1(node, 2), node, "symbol", "module name")
						local as, symbols, exportIdx, qualifier = nil, nil, nil, nth1(node, 3)
						local temp3 = type1(qualifier)
						if temp3 == "symbol" then
							exportIdx = 4
							as = qualifier["contents"]
							symbols = nil
						elseif temp3 == "list" then
							exportIdx = 4
							as = nil
							if n1(qualifier) == 0 then
								symbols = nil
							else
								symbols = {}
								local temp4 = n1(qualifier)
								local temp5 = 1
								while temp5 <= temp4 do
									local entry = qualifier[temp5]
									expectType_21_1(state["logger"], entry, qualifier, "symbol")
									symbols[entry["contents"]] = entry
									temp5 = temp5 + 1
								end
							end
						elseif temp3 == "nil" then
							exportIdx = 3
							as = nth1(node, 2)["contents"]
							symbols = nil
						elseif temp3 == "key" then
							exportIdx = 3
							as = nth1(node, 2)["contents"]
							symbols = nil
						else
							expectType_21_1(state["logger"], nth1(node, 3), node, "symbol", "alias name of import list")
						end
						maxLength_21_1(state["logger"], node, exportIdx, "import")
						yield1({["tag"]="import", ["module"]=nth1(node, 2)["contents"], ["as"]=as, ["symbols"]=symbols, ["export"]=(function()
							local export = nth1(node, exportIdx)
							if export then
								expectType_21_1(state["logger"], export, node, "key", "import modifier")
								if export["value"] == "export" then
									return true
								else
									return doNodeError_21_2(state["logger"], "unknown import modifier", export, nil, getSource1(export), "")
								end
							else
								return export
							end
						end)(), ["scope"]=scope})
						return node
					elseif func == builtins1["struct-literal"] then
						if n1(node) % 2 ~= 1 then
							doNodeError_21_2(state["logger"], "Expected an even number of arguments, got " .. n1(node) - 1, node, nil, getSource1(node), "")
						end
						return resolveList1(node, 2, scope, state)
					else
						return errorInternal_21_1(state["logger"], node, "Unknown builtin " .. (function()
							if func then
								return func["name"]
							else
								return "?"
							end
						end)())
					end
				elseif temp2 == "macro" then
					if not funcState then
						errorInternal_21_1(state["logger"], first, "Macro is not defined correctly")
					end
					local builder = get_21_1(funcState)
					if type1(builder) ~= "function" then
						doNodeError_21_2(state["logger"], "Macro is of type " .. type1(builder), first, nil, getSource1(first), "")
					end
					state["compiler"]["active-scope"] = scope
					state["compiler"]["active-node"] = node
					local temp3 = list1(xpcall1(function()
						return builder(unpack1(node, 2, n1(node)))
					end, traceback3))
					if type1(temp3) == "list" and (n1(temp3) >= 2 and (n1(temp3) <= 2 and (nth1(temp3, 1) == false and true))) then
						local msg = nth1(temp3, 2)
						return doNodeError_21_2(state["logger"], remapTraceback1(state["mappings"], msg), first, nil, getSource1(first), "")
					elseif type1(temp3) == "list" and (n1(temp3) >= 1 and (nth1(temp3, 1) == true and true)) then
						local replacement = slice1(temp3, 2)
						local temp4 = n1(replacement)
						local temp5 = 1
						while temp5 <= temp4 do
							replacement[temp5] = resolveExecuteResult1(funcState, nth1(replacement, temp5), first, scope, state)
							temp5 = temp5 + 1
						end
						if n1(replacement) == 0 then
							return doNodeError_21_2(state["logger"], "Expected some value from " .. name1(funcState) .. ", got nothing", node, nil, getSource1(node), "")
						elseif n1(replacement) == 1 then
							node = car1(replacement)
						elseif many then
							replacement["tag"] = "many"
							return replacement
						else
							return doNodeError_21_2(state["logger"], "Multiple values returned in a non-block context.", node, nil, getSource1(node), "")
						end
					else
						return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp3) .. ", but none matched.\n" .. "  Tried: `(false ?msg)`\n  Tried: `(true . ?replacement)`")
					end
				else
					return resolveList1(node, 1, scope, state)
				end
			elseif temp1 == "list" then
				return resolveList1(node, 1, scope, state)
			else
				local log, node1, message = state["logger"], first or node, "Cannot invoke a non-function type '" .. temp1 .. "'"
				return doNodeError_21_2(log, message, node1, nil, getSource1(node1), "")
			end
		else
			return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"number\"`\n  Tried: `\"string\"`\n  Tried: `\"key\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`")
		end
	end
end
resolveList1 = function(nodes, start, scope, state)
	local temp = n1(nodes)
	local temp1 = start
	while temp1 <= temp do
		nodes[temp1] = resolveNode1(nth1(nodes, temp1), scope, state)
		temp1 = temp1 + 1
	end
	return nodes
end
resolveBlock1 = function(nodes, start, scope, state)
	local len, i = n1(nodes), start
	while i <= len do
		local node = resolveNode1(nth1(nodes, i), scope, state, false, true)
		if node["tag"] == "many" then
			nodes[i] = nth1(node, 1)
			local temp = n1(node)
			local temp1 = 2
			while temp1 <= temp do
				insertNth_21_1(nodes, i + (temp1 - 1), nth1(node, temp1))
				temp1 = temp1 + 1
			end
			len = len + (n1(node) - 1)
		else
			nodes[i] = node
			i = i + 1
		end
	end
	return nodes
end
resolve1 = function(node, scope, state)
	node = resolveNode1(node, scope, state, true, true)
	while node["tag"] == "many" and n1(node) == 1 do
		node = resolveNode1(car1(node), scope, state, true, true)
	end
	return node
end
distance1 = function(a, b)
	if a == b then
		return 0
	elseif n1(a) == 0 then
		return n1(b)
	elseif n1(b) == 0 then
		return n1(a)
	else
		local v0, v1 = {tag="list", n=0}, {tag="list", n=0}
		local temp = n1(b) + 1
		local temp1 = 1
		while temp1 <= temp do
			pushCdr_21_1(v0, temp1 - 1)
			pushCdr_21_1(v1, 0)
			temp1 = temp1 + 1
		end
		local temp = n1(a)
		local temp1 = 1
		while temp1 <= temp do
			v1[1] = temp1
			local temp2 = n1(b)
			local temp3 = 1
			while temp3 <= temp2 do
				local subCost, delCost, addCost, aChar, bChar = 1, 1, 1, sub1(a, temp1, temp1), sub1(b, temp3, temp3)
				if aChar == bChar then
					subCost = 0
				end
				if aChar == "-" or aChar == "/" then
					delCost = 0.5
				end
				if bChar == "-" or bChar == "/" then
					addCost = 0.5
				end
				if n1(a) <= 5 or n1(b) <= 5 then
					subCost = subCost * 2
					delCost = delCost + 0.5
				end
				v1[temp3 + 1] = min1(nth1(v1, temp3) + delCost, nth1(v0, temp3 + 1) + addCost, nth1(v0, temp3) + subCost)
				temp3 = temp3 + 1
			end
			local temp2 = n1(v0)
			local temp3 = 1
			while temp3 <= temp2 do
				v0[temp3] = nth1(v1, temp3)
				temp3 = temp3 + 1
			end
			temp1 = temp1 + 1
		end
		return nth1(v1, n1(b) + 1)
	end
end
compile1 = function(compiler, nodes, scope, name)
	local queue, states, loader, logger, timer = {tag="list", n=0}, {tag="list", n=0}, compiler["loader"], compiler["log"], compiler["timer"]
	if name then
		name = "[resolve] " .. name
	end
	local temp = list1(gethook1())
	if type1(temp) == "list" and (n1(temp) >= 3 and (n1(temp) <= 3 and true)) then
		local hook, hookMask, hookCount = nth1(temp, 1), nth1(temp, 2), nth1(temp, 3)
		local temp1 = n1(nodes)
		local temp2 = 1
		while temp2 <= temp1 do
			local node, state, co = nth1(nodes, temp2), create3(scope, compiler), create2(resolve1)
			pushCdr_21_1(states, state)
			if hook then
				sethook1(co, hook, hookMask, hookCount)
			end
			pushCdr_21_1(queue, {["tag"]="init", ["node"]=node, ["_co"]=co, ["_state"]=state, ["_node"]=node, ["_idx"]=temp2})
			temp2 = temp2 + 1
		end
		local skipped = 0
		local resume = function(action, ...)
			local args = _pack(...) args.tag = "list"
			skipped = 0
			compiler["active-scope"] = action["_active-scope"]
			compiler["active-node"] = action["_active-node"]
			local temp1 = list1(resume1(action["_co"], unpack1(args, 1, n1(args))))
			if type1(temp1) == "list" and (n1(temp1) >= 2 and (n1(temp1) <= 2 and true)) then
				local status, result = nth1(temp1, 1), nth1(temp1, 2)
				if not status then
					error1(result, 0)
				elseif status1(action["_co"]) == "dead" then
					if result["tag"] == "many" then
						local baseIdx = action["_idx"]
						self2(logger, "put-debug!", "  Got multiple nodes as a result. Adding to queue")
						local temp2 = n1(queue)
						local temp3 = 1
						while temp3 <= temp2 do
							local elem = queue[temp3]
							if elem["_idx"] > action["_idx"] then
								elem["_idx"] = elem["_idx"] + (n1(result) - 1)
							end
							temp3 = temp3 + 1
						end
						local temp2 = n1(result)
						local temp3 = 1
						while temp3 <= temp2 do
							local state = create3(scope, compiler)
							if temp3 == 1 then
								states[baseIdx] = state
							else
								insertNth_21_1(states, baseIdx + (temp3 - 1), state)
							end
							local co = create2(resolve1)
							if hook then
								sethook1(co, hook, hookMask, hookCount)
							end
							pushCdr_21_1(queue, {["tag"]="init", ["node"]=nth1(result, temp3), ["_co"]=co, ["_state"]=state, ["_node"]=nth1(result, temp3), ["_idx"]=baseIdx + (temp3 - 1)})
							temp3 = temp3 + 1
						end
					else
						built_21_1(action["_state"], result)
					end
				else
					result["_co"] = action["_co"]
					result["_state"] = action["_state"]
					result["_node"] = action["_node"]
					result["_idx"] = action["_idx"]
					result["_active-scope"] = compiler["active-scope"]
					result["_active-node"] = compiler["active-node"]
					pushCdr_21_1(queue, result)
				end
			else
				error1("Pattern matching failure! Can not match the pattern `(?status ?result)` against `" .. pretty1(temp1) .. "`.")
			end
			compiler["active-scope"] = nil
			compiler["active-node"] = nil
			return nil
		end
		if name then
			startTimer_21_1(timer, name, 2)
		end
		while n1(queue) > 0 and skipped <= n1(queue) do
			local head = removeNth_21_1(queue, 1)
			self2(logger, "put-debug!", (type1(head) .. " for " .. head["_state"]["stage"] .. " at " .. formatNode1(head["_node"]) .. " (" .. (function()
				if head["_state"]["var"] then
					return head["_state"]["var"]["name"]
				else
					return "?"
				end
			end)() .. ")"))
			local temp1 = type1(head)
			if temp1 == "init" then
				resume(head, head["node"], scope, head["_state"])
			elseif temp1 == "define" then
				if scope["variables"][head["name"]] then
					resume(head, scope["variables"][head["name"]])
				else
					self2(logger, "put-debug!", ("  Awaiting definiion of " .. head["name"]))
					skipped = skipped + 1
					pushCdr_21_1(queue, head)
				end
			elseif temp1 == "build" then
				if head["state"]["stage"] ~= "parsed" then
					resume(head)
				else
					self2(logger, "put-debug!", ("  Awaiting building of node " .. (function()
						if head["state"]["var"] then
							return head["state"]["var"]["name"]
						else
							return "?"
						end
					end)()))
					skipped = skipped + 1
					pushCdr_21_1(queue, head)
				end
			elseif temp1 == "execute" then
				executeStates1(compiler["compile-state"], head["states"], compiler["global"])
				resume(head)
			elseif temp1 == "import" then
				if name then
					pauseTimer_21_1(timer, name)
				end
				local result = loader(head["module"])
				local module = car1(result)
				if name then
					startTimer_21_1(timer, name)
				end
				if not module then
					doNodeError_21_2(logger, nth1(result, 2), head["_node"], nil, getSource1(head["_node"]), "")
				end
				local export, scope1, node, temp2 = head["export"], head["scope"], head["_node"], module["scope"]["exported"]
				local temp3, var = next1(temp2)
				while temp3 ~= nil do
					if head["as"] then
						importVerbose_21_1(scope1, head["as"] .. "/" .. temp3, var, node, export, logger)
					elseif head["symbols"] then
						if head["symbols"][temp3] then
							importVerbose_21_1(scope1, temp3, var, node, export, logger)
						end
					else
						importVerbose_21_1(scope1, temp3, var, node, export, logger)
					end
					temp3, var = next1(temp2, temp3)
				end
				if head["symbols"] then
					local failed = false
					local temp2 = head["symbols"]
					local temp3, nameNode = next1(temp2)
					while temp3 ~= nil do
						if not module["scope"]["exported"][temp3] then
							failed = true
							putNodeError_21_1(logger, "Cannot find " .. temp3, nameNode, nil, getSource1(head["_node"]), "Importing here", getSource1(nameNode), "Required here")
						end
						temp3, nameNode = next1(temp2, temp3)
					end
					if failed then
						error1(sentinel1, 0)
					end
				end
				resume(head)
			else
				error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp1) .. ", but none matched.\n" .. "  Tried: `\"init\"`\n  Tried: `\"define\"`\n  Tried: `\"build\"`\n  Tried: `\"execute\"`\n  Tried: `\"import\"`")
			end
		end
	else
		error1("Pattern matching failure! Can not match the pattern `(?hook ?hook-mask ?hook-count)` against `" .. pretty1(temp) .. "`.")
	end
	if n1(queue) > 0 then
		local temp = n1(queue)
		local temp1 = 1
		while temp1 <= temp do
			local entry = queue[temp1]
			local temp2 = type1(entry)
			if temp2 == "define" then
				local info, suggestions = nil, ""
				local scope1 = entry["scope"]
				if scope1 then
					local vars, varDis, varSet, distances = {tag="list", n=0}, {tag="list", n=0}, {}, {}
					while scope1 do
						local temp3 = scope1["variables"]
						local temp4, _5f_ = next1(temp3)
						while temp4 ~= nil do
							if not varSet[temp4] then
								varSet[temp4] = "true"
								pushCdr_21_1(vars, temp4)
								local parlen = n1(entry["name"])
								local lendiff = abs1(n1(temp4) - parlen)
								if parlen <= 5 or lendiff <= parlen * 0.3 then
									local dis = distance1(temp4, entry["name"]) / parlen
									if parlen <= 5 then
										dis = dis / 2
									end
									pushCdr_21_1(varDis, temp4)
									distances[temp4] = dis
								end
							end
							temp4, _5f_ = next1(temp3, temp4)
						end
						scope1 = scope1["parent"]
					end
					sort1(vars, nil)
					sort1(varDis, function(a, b)
						return distances[a] < distances[b]
					end)
					local elems
					local temp3
					local xs = first1(partition1(function(x)
						return distances[x] <= 0.5
					end, varDis))
					temp3 = slice1(xs, 1, min1(5, n1(xs)))
					elems = map2(function(temp4)
						return coloured1("1;32", temp4)
					end, temp3)
					local temp3 = n1(elems)
					if temp3 == 0 then
					elseif temp3 == 1 then
						suggestions = "\nDid you mean '" .. car1(elems) .. "'?"
					else
						suggestions = "\nDid you mean any of these?" .. "\n  •" .. concat1(elems, "\n  •")
					end
					info = "Variables in scope are " .. concat1(vars, ", ")
				end
				putNodeError_21_1(logger, "Cannot find variable '" .. entry["name"] .. "'" .. suggestions, entry["node"] or entry["_node"], info, getSource1(entry["node"] or entry["_node"]), "")
			elseif temp2 == "build" then
				local var, node = entry["state"]["var"], entry["state"]["node"]
				self2(logger, "put-error!", ("Could not build " .. (function()
					if var then
						return var["name"]
					elseif node then
						return formatNode1(node)
					else
						return "unknown node"
					end
				end)()))
			else
				error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp2) .. ", but none matched.\n" .. "  Tried: `\"define\"`\n  Tried: `\"build\"`")
			end
			temp1 = temp1 + 1
		end
		error1(sentinel1, 0)
	end
	if name then
		stopTimer_21_1(timer, name)
	end
	return unpack1(list1(map2(on1("node"), states), states))
end
pathEscape1 = {["?"]="(.*)", ["."]="%.", ["%"]="%%", ["^"]="%^", ["$"]="%$", ["+"]="%+", ["-"]="%-", ["*"]="%*", ["["]="%[", ["]"]="%]", ["("]="%)", [")"]="%)"}
lispExtensions1 = {tag="list", n=3, ".lisp", ".cl", ".urn"}
tryHandle1 = function(name)
	local i = 1
	while true do
		if (i > n1(lispExtensions1)) then
			return nil
		else
			local temp = open1(name .. nth1(lispExtensions1, i), "r")
			if temp then
				return temp
			else
				i = i + 1
			end
		end
	end
end
simplifyPath1 = function(path, paths)
	local current = path
	local temp = n1(paths)
	local temp1 = 1
	while temp1 <= temp do
		local sub = match1(path, "^" .. gsub1(paths[temp1], ".", pathEscape1) .. "$")
		if sub and n1(sub) < n1(current) then
			current = sub
		end
		temp1 = temp1 + 1
	end
	return current
end
readMeta1 = function(state, name, entry)
	if (type1(entry) == "expr" or type1(entry) == "stmt") and string_3f_1(entry["contents"]) then
		local buffer, str, idx, max = {tag="list", n=0}, entry["contents"], 0, 0
		local len = n1(str)
		while idx <= len do
			local temp = list1(find1(str, "%${(%d+)}", idx))
			if type1(temp) == "list" and (n1(temp) >= 2 and true) then
				local start, finish = nth1(temp, 1), nth1(temp, 2)
				if start > idx then
					pushCdr_21_1(buffer, sub1(str, idx, start - 1))
				end
				local val = tonumber1(sub1(str, start + 2, finish - 1))
				pushCdr_21_1(buffer, val)
				if val > max then
					max = val
				end
				idx = finish + 1
			else
				pushCdr_21_1(buffer, sub1(str, idx, len))
				idx = len + 1
			end
		end
		if not entry["count"] then
			entry["count"] = max
		end
		entry["contents"] = buffer
	end
	local fold = entry["fold"]
	if fold then
		if type1(entry) ~= "expr" then
			error1("Cannot have fold for non-expression " .. name, 0)
		end
		if fold ~= "l" and fold ~= "r" then
			error1("Unknown fold " .. fold .. " for " .. name, 0)
		end
		if entry["count"] ~= 2 then
			error1("Cannot have fold for length " .. entry["count"] .. " for " .. name, 0)
		end
	end
	entry["name"] = name
	if entry["value"] == nil then
		local value = state["lib-env"][name]
		if value == nil then
			local temp = list1(pcall1(native1, entry, state["global"]))
			if type1(temp) == "list" and (n1(temp) >= 1 and (nth1(temp, 1) == true and true)) then
				value = car1((slice1(temp, 2)))
			elseif type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (nth1(temp, 1) == false and true))) then
			else
				error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `(true . ?res)`\n  Tried: `(false _)`")
			end
			state["lib-env"][name] = value
		end
		entry["value"] = value
	elseif state["lib-env"][name] ~= nil then
		error1("Duplicate value for " .. name .. ": in native and meta file", 0)
	else
		state["lib-env"][name] = entry["value"]
	end
	state["lib-meta"][name] = entry
	return entry
end
readLibrary1 = function(state, name, path, lispHandle)
	self2(state["log"], "put-verbose!", ("Loading " .. path .. " into " .. name))
	local prefix = name .. "-" .. n1(state["libs"]) .. "/"
	local lib, contents = {["name"]=name, ["prefix"]=prefix, ["path"]=path}, self2(lispHandle, "read", "*a")
	self2(lispHandle, "close")
	lib["lisp"] = contents
	local handle = open1(path .. ".lib.lua", "r")
	if handle then
		local contents1 = self2(handle, "read", "*a")
		self2(handle, "close")
		lib["native"] = contents1
		local temp = list1(load1(contents1, "@" .. name))
		if type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (nth1(temp, 1) == nil and true))) then
			error1((nth1(temp, 2)), 0)
		elseif type1(temp) == "list" and (n1(temp) >= 1 and (n1(temp) <= 1 and true)) then
			local res = nth1(temp, 1)()
			if type_23_1(res) == "table" then
				local temp1, v = next1(res)
				while temp1 ~= nil do
					state["lib-env"][prefix .. temp1] = v
					temp1, v = next1(res, temp1)
				end
			else
				error1(path .. ".lib.lua returned a non-table value", 0)
			end
		else
			error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `(nil ?msg)`\n  Tried: `(?fun)`")
		end
	end
	local handle = open1(path .. ".meta.lua", "r")
	if handle then
		local contents1 = self2(handle, "read", "*a")
		self2(handle, "close")
		local temp = list1(load1(contents1, "@" .. name))
		if type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (nth1(temp, 1) == nil and true))) then
			error1((nth1(temp, 2)), 0)
		elseif type1(temp) == "list" and (n1(temp) >= 1 and (n1(temp) <= 1 and true)) then
			local res = nth1(temp, 1)()
			if type_23_1(res) == "table" then
				local temp1, v = next1(res)
				while temp1 ~= nil do
					readMeta1(state, prefix .. temp1, v)
					temp1, v = next1(res, temp1)
				end
			else
				error1(path .. ".meta.lua returned a non-table value", 0)
			end
		else
			error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `(nil ?msg)`\n  Tried: `(?fun)`")
		end
	end
	startTimer_21_1(state["timer"], "[parse] " .. path, 2)
	local lexed = lex1(state["log"], contents, path .. ".lisp")
	local parsed, scope = parse1(state["log"], lexed), child1(state["root-scope"])
	scope["is-root"] = true
	scope["prefix"] = name .. "/"
	scope["unique-prefix"] = prefix
	lib["scope"] = scope
	stopTimer_21_1(state["timer"], "[parse] " .. path)
	local compiled = compile1(state, parsed, scope, path)
	pushCdr_21_1(state["libs"], lib)
	if string_3f_1(car1(compiled)) then
		lib["docs"] = constVal1(car1(compiled))
		removeNth_21_1(compiled, 1)
	end
	lib["out"] = compiled
	local temp = n1(compiled)
	local temp1 = 1
	while temp1 <= temp do
		local node = compiled[temp1]
		pushCdr_21_1(state["out"], node)
		temp1 = temp1 + 1
	end
	self2(state["log"], "put-verbose!", ("Loaded " .. path .. " into " .. name))
	return lib
end
pathLocator1 = function(state, name)
	local searched, paths, _ = {tag="list", n=0}, state["paths"]
	local i = 1
	while true do
		if i > n1(paths) then
			return list1(nil, "Cannot find " .. quoted1(name) .. ".\nLooked in " .. concat1(searched, ", "))
		else
			local path = gsub1(nth1(paths, i), "%?", name)
			local cached = state["lib-cache"][path]
			pushCdr_21_1(searched, path)
			if cached == nil then
				local handle = tryHandle1(path)
				if handle then
					state["lib-cache"][path] = true
					state["lib-names"][name] = true
					local lib = readLibrary1(state, simplifyPath1(path, paths), path, handle)
					state["lib-cache"][path] = lib
					state["lib-names"][name] = lib
					return list1(lib)
				else
					i = i + 1
				end
			elseif cached == true then
				return list1(nil, "Already loading " .. name)
			else
				return list1(cached)
			end
		end
	end
end
loader1 = function(state, name, shouldResolve)
	if shouldResolve then
		local cached = state["lib-names"][name]
		if cached == nil then
			return pathLocator1(state, name)
		elseif cached == true then
			return list1(nil, "Already loading " .. name)
		else
			return list1(cached)
		end
	else
		local path = name
		local i = 1
		while true do
			if (i > n1(lispExtensions1)) then
				break
			else
				local suffix = nth1(lispExtensions1, i)
				if endsWith_3f_1(path, suffix) then
					name = sub1(name, 1, -1 - n1(suffix))
					break
				else
					i = i + 1
				end
			end
		end
		local temp = state["lib-cache"][path]
		if temp == nil then
			local handle
			if name == path then
				handle = tryHandle1(name)
			else
				handle = open1(path, "r")
			end
			if handle then
				state["lib-cache"][name] = true
				local lib = readLibrary1(state, simplifyPath1(name, state["paths"]), name, handle)
				state["lib-cache"][name] = lib
				return list1(lib)
			else
				return list1(nil, "Cannot find " .. quoted1(path))
			end
		elseif temp == true then
			return list1(nil, "Already loading " .. name)
		else
			return list1(temp)
		end
	end
end
local home = getenv1 and (getenv1("HOME") or (getenv1("USERPROFILE") or (getenv1("HOMEDRIVE") or getenv1("HOMEPATH"))))
if home then
	historyPath1 = home .. "/.urn_history"
else
	historyPath1 = ".urn_history"
end
local read, providers = nil, list1(function()
	local ffiOk, ffi = pcall1(require1, "ffi")
	if ffiOk then
		local ok, readline = pcall1(ffi["load"], "readline")
		if ok then
			ffi["cdef"]("void* malloc(size_t bytes); // Required to allocate strings for completions\nvoid free(void *); // Required to free strings returned by readline\nchar *readline (const char *prompt); // Read a line with the given prompt\nconst char * rl_readline_name; // Set the program name\n\n// History manipulation\nvoid using_history();\nvoid add_history(const char *line);\nvoid read_history(const char *filename);\n\n// Hooks\ntypedef int rl_hook_func_t (void);\nrl_hook_func_t *rl_startup_hook;\n\n// Completion\ntypedef char *rl_compentry_func_t (const char *, int);\ntypedef char **rl_completion_func_t (const char *, int, int);\nchar **rl_completion_matches (const char *text, rl_compentry_func_t *entry_func);\nint rl_attempted_completion_over;\nchar * rl_line_buffer;\nconst char* rl_basic_word_break_characters;\nrl_completion_func_t * rl_attempted_completion_function;\n\nint rl_insert_text (const char *text);")
			local currentInitial, previous, currentCompleter = "", "", nil
			readline["rl_readline_name"] = "urn"
			readline["rl_startup_hook"] = function()
				if n1(currentInitial) > 0 then
					readline["rl_insert_text"](currentInitial)
				end
				return 0
			end
			readline["using_history"]()
			readline["read_history"](historyPath1)
			readline["rl_basic_word_break_characters"] = "\n \9;()[]{},@`'"
			readline["rl_attempted_completion_function"] = function(str, start, finish)
				readline["rl_attempted_completion_over"] = 1
				local results, resultsIdx = nil, 0
				return readline["rl_completion_matches"](str, function(str1, idx)
					if idx == 0 then
						if currentCompleter then
							results = currentCompleter(ffi["string"](readline["rl_line_buffer"], finish))
						else
							results = {tag="list", n=0}
						end
					end
					resultsIdx = resultsIdx + 1
					local resPartial = nth1(results, resultsIdx)
					if resPartial then
						local resStr = ffi["string"](str1) .. resPartial
						local resBuf = ffi["C"]["malloc"](n1(resStr) + 1)
						ffi["copy"](resBuf, resStr, n1(resStr) + 1)
						return resBuf
					else
						return nil
					end
				end)
			end
			return function(prompt, initial, complete)
				currentInitial = initial or ""
				currentCompleter = complete
				prompt = gsub1(prompt, "(\27%[%A*%a)", "\1%1\2")
				local res = readline["readline"](prompt)
				if res == nil then
					return nil
				else
					local str = ffi["string"](res)
					if find1(str, "%S") and previous ~= str then
						previous = str
						readline["add_history"](res)
						local out = open1(historyPath1, "a")
						if out then
							self2(out, "write", str, "\n")
							self2(out, "close")
						end
					end
					ffi["C"]["free"](res)
					return str
				end
			end
		else
			return nil
		end
	else
		return nil
	end
end, function()
	local readlineOk, readline = pcall1(require1, "readline")
	if readlineOk then
		local previous = nil
		readline["set_options"]({["histfile"]=historyPath1, ["completion"]=false})
		return function(prompt, initial, complete)
			prompt = gsub1(prompt, "(\27%[%A*%a)", "\1%1\2")
			local res = readline["readline"](prompt)
			if res and (find1(res, "%S") and previous ~= res) then
				previous = res
				local out = open1(historyPath1, "a")
				if out then
					self2(out, "write", res, "\n")
					self2(out, "close")
				end
			end
			return res
		end
	else
		return nil
	end
end, function()
	local linenoiseOk, linenoise = pcall1(require1, "linenoise")
	if linenoiseOk then
		local previous = nil
		linenoise["historysetmaxlen"](1000)
		linenoise["historyload"](historyPath1)
		return function(prompt, initial, complete)
			prompt = gsub1(prompt, "(\27%[%A*%a)", "")
			if complete then
				linenoise["setcompletion"](function(obj, line)
					local temp = complete(line)
					local temp1 = n1(temp)
					local temp2 = 1
					while temp2 <= temp1 do
						local completion = temp[temp2]
						linenoise["addcompletion"](obj, line .. completion .. " ")
						temp2 = temp2 + 1
					end
					return nil
				end)
			else
				linenoise["setcompletion"](nil)
			end
			local res = linenoise["linenoise"](prompt)
			if res and (find1(res, "%S") and previous ~= res) then
				previous = res
				linenoise["historyadd"](res)
				local out = open1(historyPath1, "a")
				if out then
					self2(out, "write", res, "\n")
					self2(out, "close")
				end
			end
			return res
		end
	else
		return nil
	end
end, function()
	return function(prompt, initial, complete)
		write1(prompt)
		flush1()
		return read1("*l")
	end
end)
readLine_21_1 = function(prompt, initial, complete)
	if not read then
		local i = 1
		while true do
			local provider = nth1(providers, i)()
			if provider then
				read = provider
				break
			else
				i = i + 1
			end
		end
	end
	return read(prompt, initial, complete)
end
requiresInput1 = function(str)
	local temp = list1(pcall1(function()
		return parse1(void1, lex1(void1, str, "<stdin>", true), true)
	end))
	if type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (nth1(temp, 1) == true and true))) then
		return false
	elseif type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (nth1(temp, 1) == false and type_23_1((nth1(temp, 2))) == "table"))) then
		if nth1(temp, 2)["context"] then
			return true
		else
			return false
		end
	elseif type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (nth1(temp, 1) == false and true))) then
		local x = nth1(temp, 2)
		return nil
	else
		return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `(true _)`\n  Tried: `(false (table? @ ?x))`\n  Tried: `(false ?x)`")
	end
end
getIndent1 = function(str)
	local toks
	local temp = list1(pcall1(lex1, void1, str, "<stdin>", true))
	if type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (nth1(temp, 1) == true and true))) then
		toks = (nth1(temp, 2))
	elseif type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (nth1(temp, 1) == false and type_23_1((nth1(temp, 2))) == "table"))) then
		toks = nth1(temp, 2)["tokens"] or {tag="list", n=0}
	else
		toks = error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `(true ?x)`\n  Tried: `(false (table? @ ?x))`")
	end
	local stack = {tag="list", n=1, 1}
	local temp = n1(toks)
	local temp1 = 1
	while temp1 <= temp do
		local tok = toks[temp1]
		local temp2 = type1(tok)
		if temp2 == "open" then
			pushCdr_21_1(stack, tok["range"]["start"]["column"] + 2)
		elseif temp2 == "close" then
			popLast_21_1(stack)
		end
		temp1 = temp1 + 1
	end
	return rep1(" ", last1(stack) - 1)
end
getComplete1 = function(str, scope)
	local temp = list1(pcall1(lex1, void1, str, "<stdin>", true))
	if type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (nth1(temp, 1) == true and true))) then
		local toks = nth1(temp, 2)
		local last = nth1(toks, n1(toks) - 1)
		local contents
		if last == nil then
			contents = ""
		elseif last["range"]["finish"]["offset"] < n1(str) then
			contents = ""
		elseif type1(last) == "symbol" then
			contents = symbol_2d3e_string1(last)
		else
			contents = nil
		end
		if contents then
			local visited, vars = {}, {tag="list", n=0}
			local scope1 = scope
			while not ((scope1 == nil)) do
				local temp1 = scope1["variables"]
				local temp2, _5f_ = next1(temp1)
				while temp2 ~= nil do
					if sub1(temp2, 1, #contents) == contents and not visited[temp2] then
						visited[temp2] = true
						pushCdr_21_1(vars, sub1(temp2, n1(contents) + 1))
					end
					temp2, _5f_ = next1(temp1, temp2)
				end
				scope1 = scope1["parent"]
			end
			sort1(vars, nil)
			return vars
		else
			return {tag="list", n=0}
		end
	else
		return {tag="list", n=0}
	end
end
if getenv1 then
	local clrs = getenv1("URN_COLOURS")
	if clrs then
		replColourScheme1 = read2(clrs) or nil
	else
		replColourScheme1 = nil
	end
else
	replColourScheme1 = nil
end
colourFor1 = function(elem)
	if assoc_3f_1(replColourScheme1, {["tag"]="symbol", ["contents"]=elem}) then
		return constVal1(assoc1(replColourScheme1, {["tag"]="symbol", ["contents"]=elem}))
	elseif elem == "text" then
		return 0
	elseif elem == "arg" then
		return 36
	elseif elem == "mono" then
		return 97
	elseif elem == "bold" then
		return 1
	elseif elem == "italic" then
		return 3
	elseif elem == "link" then
		return 94
	elseif elem == "comment" then
		return 90
	elseif elem == "string" then
		return 32
	elseif elem == "number" then
		return 0
	elseif elem == "key" then
		return 36
	elseif elem == "symbol" then
		return 0
	elseif elem == "keyword" then
		return 35
	elseif elem == "operator" then
		return 0
	else
		return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(elem) .. ", but none matched.\n" .. "  Tried: `\"text\"`\n  Tried: `\"arg\"`\n  Tried: `\"mono\"`\n  Tried: `\"bold\"`\n  Tried: `\"italic\"`\n  Tried: `\"link\"`\n  Tried: `\"comment\"`\n  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"key\"`\n  Tried: `\"symbol\"`\n  Tried: `\"keyword\"`\n  Tried: `\"operator\"`")
	end
end
tokenMapping1 = {["string"]="string", ["interpolate"]="string", ["number"]="number", ["key"]="key", ["symbol"]="symbol", ["open"]="operator", ["close"]="operator", ["open-struct"]="operator", ["close-struct"]="operator", ["quote"]="operator", ["quasi-quote"]="operator", ["syntax-quote"]="operator", ["unquote"]="operator", ["unquote-splice"]="operator"}
keywords2 = createLookup1({tag="list", n=33, "define", "define-macro", "define-native", "lambda", "set!", "cond", "import", "struct-literal", "quote", "syntax-quote", "unquote", "unquote-splice", "defun", "defmacro", "car", "cdr", "list", "cons", "progn", "if", "when", "unless", "let", "let*", "with", "not", "gensym", "for", "while", "and", "or", "loop", "case"})
printDocs_21_1 = function(str)
	local docs = parseDocstring1(str)
	local temp = n1(docs)
	local temp1 = 1
	while temp1 <= temp do
		local tok = docs[temp1]
		local tag = tok["kind"]
		if tag == "bolic" then
			write1(coloured1(colourFor1("bold"), coloured1(colourFor1("italic"), tok["contents"])))
		else
			write1(coloured1(colourFor1(tag), tok["contents"]))
		end
		temp1 = temp1 + 1
	end
	return print1()
end
execCommand1 = function(compiler, scope, args)
	local logger, command = compiler["log"], car1(args)
	if command == "help" or command == "h" then
		return print1("REPL commands:\n[:d]oc NAME        Get documentation about a symbol\n:module NAME       Display a loaded module's docs and definitions.\n:scope             Print out all variables in the scope\n[:s]earch QUERY    Search the current scope for symbols and documentation containing a string.\n[:v]iew NAME       Display the definition of a symbol.\n[:q]uit            Exit the REPL cleanly.")
	elseif command == "doc" or command == "d" then
		local name = nth1(args, 2)
		if name then
			local var = get1(scope, name)
			if var == nil then
				return self2(logger, "put-error!", ("Cannot find '" .. name .. "'"))
			else
				local sig, name2 = extractSignature1(var), var["full-name"]
				if sig then
					local buffer = list1(name2)
					local temp = n1(sig)
					local temp1 = 1
					while temp1 <= temp do
						pushCdr_21_1(buffer, sig[temp1]["contents"])
						temp1 = temp1 + 1
					end
					name2 = "(" .. concat1(buffer, " ") .. ")"
				end
				print1(coloured1(96, name2))
				if var["doc"] then
					return printDocs_21_1(var["doc"])
				else
					return self2(logger, "put-error!", ("No documentation for '" .. name2 .. "'"))
				end
			end
		else
			return self2(logger, "put-error!", ":doc <variable>")
		end
	elseif command == "module" then
		local name = nth1(args, 2)
		if name then
			local mod = compiler["lib-names"][name]
			if mod == nil then
				return self2(logger, "put-error!", ("Cannot find '" .. name .. "'"))
			else
				print1(coloured1(96, mod["name"]))
				print1("Located at " .. mod["path"])
				if mod["docs"] then
					printDocs_21_1(mod["docs"])
					print1()
				end
				print1(coloured1(92, "Exported symbols"))
				local vars = {tag="list", n=0}
				local temp = mod["scope"]["exported"]
				local temp1 = next1(temp)
				while temp1 ~= nil do
					pushCdr_21_1(vars, temp1)
					temp1 = next1(temp, temp1)
				end
				sort1(vars, nil)
				return print1(concat1(vars, "  "))
			end
		else
			return self2(logger, "put-error!", ":module <variable>")
		end
	elseif command == "search" or command == "s" then
		if n1(args) > 1 then
			local keywords, nameResults, docsResults, vars, varsSet, current = map2(lower1, cdr1(args)), {tag="list", n=0}, {tag="list", n=0}, {tag="list", n=0}, {}, scope
			while current do
				local temp = current["variables"]
				local temp1, var = next1(temp)
				while temp1 ~= nil do
					if not varsSet[temp1] then
						pushCdr_21_1(vars, temp1)
						varsSet[temp1] = true
					end
					temp1, var = next1(temp, temp1)
				end
				current = current["parent"]
			end
			local temp = n1(vars)
			local temp1 = 1
			while temp1 <= temp do
				local var = vars[temp1]
				local temp2 = n1(keywords)
				local temp3 = 1
				while temp3 <= temp2 do
					if find1(var, (keywords[temp3])) then
						pushCdr_21_1(nameResults, var)
					end
					temp3 = temp3 + 1
				end
				local docVar = get1(scope, var)
				if docVar then
					local tempDocs = docVar["doc"]
					if tempDocs then
						local docs = lower1(tempDocs)
						if docs then
							local keywordsFound = 0
							if keywordsFound then
								local temp2 = n1(keywords)
								local temp3 = 1
								while temp3 <= temp2 do
									if find1(docs, (keywords[temp3])) then
										keywordsFound = keywordsFound + 1
									end
									temp3 = temp3 + 1
								end
								if eq_3f_1(keywordsFound, n1(keywords)) then
									pushCdr_21_1(docsResults, var)
								end
							end
						end
					end
				end
				temp1 = temp1 + 1
			end
			if empty_3f_1(nameResults) and empty_3f_1(docsResults) then
				return self2(logger, "put-error!", "No results")
			else
				if not empty_3f_1(nameResults) then
					print1(coloured1(92, "Search by function name:"))
					if n1(nameResults) > 20 then
						print1(concat1(slice1(nameResults, 1, min1(20, n1(nameResults))), "  ") .. "  ...")
					else
						print1(concat1(nameResults, "  "))
					end
				end
				if not empty_3f_1(docsResults) then
					print1(coloured1(92, "Search by function docs:"))
					if n1(docsResults) > 20 then
						return print1(concat1(slice1(docsResults, 1, min1(20, n1(docsResults))), "  ") .. "  ...")
					else
						return print1(concat1(docsResults, "  "))
					end
				else
					return nil
				end
			end
		else
			return self2(logger, "put-error!", ":search <keywords>")
		end
	elseif command == "scope" then
		local vars, varsSet, current = {tag="list", n=0}, {}, scope
		while current do
			local temp = current["variables"]
			local temp1, var = next1(temp)
			while temp1 ~= nil do
				if not varsSet[temp1] then
					pushCdr_21_1(vars, temp1)
					varsSet[temp1] = true
				end
				temp1, var = next1(temp, temp1)
			end
			current = current["parent"]
		end
		sort1(vars, nil)
		return print1(concat1(vars, "  "))
	elseif command == "view" or command == "v" then
		local name = nth1(args, 2)
		if name then
			local var = get1(scope, name)
			if var ~= nil then
				local node = var["node"]
				local range = node and getSource1(node)
				if range ~= nil then
					local lines, start, finish, buffer = range["lines"], range["start"], range["finish"], {tag="list", n=0}
					local temp = finish["line"]
					local temp1 = start["line"]
					while temp1 <= temp do
						pushCdr_21_1(buffer, sub1(lines[temp1], (function()
							if temp1 == start["line"] then
								return start["column"]
							else
								return 1
							end
						end)(), (function()
							if temp1 == finish["line"] then
								return finish["column"]
							else
								return -1
							end
						end)()))
						temp1 = temp1 + 1
					end
					local contents, previous = concat1(buffer, "\n"), 0
					local temp = lex1(void1, contents, "stdin")
					local temp1 = n1(temp)
					local temp2 = 1
					while temp2 <= temp1 do
						local tok = temp[temp2]
						local start1 = tok["range"]["start"]["offset"]
						if start1 ~= previous then
							write1(coloured1(colourFor1("comment"), sub1(contents, previous, start1 - 1)))
						end
						local tag = type1(tok)
						if tag == "eof" then
						elseif tag == "symbol" and keywords2[tok["contents"]] then
							write1(coloured1(colourFor1("keyword"), tok["contents"]))
						else
							write1(coloured1(colourFor1(tokenMapping1[type1(tok)]), tok["contents"]))
						end
						previous = tok["range"]["finish"]["offset"] + 1
						temp2 = temp2 + 1
					end
					return write1("\n")
				else
					return self2(logger, "put-error!", ("Cannot extract source code for " .. quoted1(name)))
				end
			else
				return self2(logger, "put-error!", ("Cannot find " .. quoted1(name)))
			end
		else
			return self2(logger, "put-error!", ":view <variable>")
		end
	elseif command == "quit" or command == "q" then
		print1("Goodbye.")
		return exit1(0)
	else
		return self2(logger, "put-error!", ("Unknown command '" .. command .. "'"))
	end
end
execString1 = function(compiler, scope, string)
	local logger = compiler["log"]
	local state = cadr1(list1(compile1(compiler, parse1(logger, (lex1(logger, string, "<stdin>"))), scope)))
	if n1(state) > 0 then
		local current = 0
		local exec, compileState, global, logger1, run = create2(function()
			local temp = n1(state)
			local temp1 = 1
			while temp1 <= temp do
				current = state[temp1]
				get_21_1(current)
				temp1 = temp1 + 1
			end
			return nil
		end), compiler["compile-state"], compiler["global"], compiler["log"], true
		while run do
			local res = list1(resume1(exec))
			if not car1(res) then
				self2(logger1, "put-error!", (cadr1(res)))
				run = false
			elseif status1(exec) == "dead" then
				local lvl = get_21_1(last1(state))
				local prettyFun = pretty1
				local prettyVar = get1(scope, "pretty")
				if prettyVar then
					prettyFun = get_21_1(compiler["states"][prettyVar])
				end
				print1("out = " .. coloured1(96, prettyFun(lvl)))
				global[pushEscapeVar_21_1(add_21_1(scope, "out", "defined", lvl), compileState)] = lvl
				run = false
			else
				local states = cadr1(res)["states"]
				local latest, co, task = car1(states), create2(executeStates1), nil
				while run and status1(co) ~= "dead" do
					compiler["active-node"] = latest["node"]
					compiler["active-scope"] = latest["scope"]
					local res1
					if task then
						res1 = list1(resume1(co))
					else
						res1 = list1(resume1(co, compileState, states, global))
					end
					compiler["active-node"] = nil
					compiler["active-scope"] = nil
					if type1(res1) == "list" and (n1(res1) >= 2 and (n1(res1) <= 2 and (nth1(res1, 1) == false and true))) then
						error1((nth1(res1, 2)), 0)
					elseif type1(res1) == "list" and (n1(res1) >= 1 and (n1(res1) <= 1 and nth1(res1, 1) == true)) then
					elseif type1(res1) == "list" and (n1(res1) >= 2 and (n1(res1) <= 2 and (nth1(res1, 1) == true and true))) then
						local arg = nth1(res1, 2)
						if status1(co) ~= "dead" then
							task = arg
							local temp = type1(task)
							if temp == "execute" then
								executeStates1(compileState, task["states"], global)
							else
								local _ = "Cannot handle " .. temp
							end
						end
					else
						error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(res1) .. ", but none matched.\n" .. "  Tried: `(false ?msg)`\n  Tried: `(true)`\n  Tried: `(true ?arg)`")
					end
				end
			end
		end
		return nil
	else
		return nil
	end
end
repl1 = function(compiler, args)
	local scope, logger, buffer, running = compiler["root-scope"], compiler["log"], "", true
	local temp = args["input"]
	local temp1 = n1(temp)
	local temp2 = 1
	while temp2 <= temp1 do
		local library = car1(loader1(compiler, temp[temp2], false))
		local temp3 = library["scope"]["exported"]
		local temp4, var = next1(temp3)
		while temp4 ~= nil do
			if scope["variables"][temp4] then
				import_21_1(scope, library["name"] .. "/" .. temp4, var)
			else
				import_21_1(scope, temp4, var)
			end
			temp4, var = next1(temp3, temp4)
		end
		temp2 = temp2 + 1
	end
	while running do
		local line = readLine_21_1(coloured1(92, (function()
			if empty_3f_1(buffer) then
				return "> "
			else
				return ". "
			end
		end)()), getIndent1(buffer), function(x)
			return getComplete1(buffer .. x, scope)
		end)
		if not line and empty_3f_1(buffer) then
			running = false
		else
			local data
			if line then
				data = buffer .. line .. "\n"
			else
				data = buffer
			end
			if sub1(data, 1, 1) == ":" then
				buffer = ""
				execCommand1(compiler, scope, map2(trim1, split1(sub1(data, 2), " ")))
			elseif line and (n1(line) > 0 and requiresInput1(data)) then
				buffer = data
			else
				buffer = ""
				scope = child1(scope)
				scope["is-root"] = true
				local res = list1(pcall1(execString1, compiler, scope, data))
				compiler["active-node"] = nil
				compiler["active-scope"] = nil
				if not (car1(res) or cadr1(res) == sentinel1) then
					self2(logger, "put-error!", (cadr1(res)))
				end
			end
		end
	end
	return nil
end
exec1 = function(compiler)
	local data, scope, logger = read1("*a"), compiler["root-scope"], compiler["log"]
	local res = list1(pcall1(execString1, compiler, scope, data))
	if not (car1(res) or cadr1(res) == sentinel1) then
		self2(logger, "put-error!", (cadr1(res)))
	end
	return exit1(0)
end
replTask1 = {["name"]="repl", ["setup"]=function(spec)
	return addArgument_21_1(spec, {tag="list", n=1, "--repl"}, "help", "Start an interactive session.")
end, ["pred"]=function(args)
	return args["repl"]
end, ["run"]=repl1}
execTask1 = {["name"]="exec", ["setup"]=function(spec)
	return addArgument_21_1(spec, {tag="list", n=1, "--exec"}, "help", "Execute a program from stdin without compiling it. This acts as if it were input in one go via the REPL.")
end, ["pred"]=function(args)
	return args["exec"]
end, ["run"]=exec1}
profileCalls1 = function(fn, mappings)
	local stats, callStack = {}, {tag="list", n=0}
	sethook1(function(action)
		local info, start = getinfo1(2, "Sn"), clock1()
		if action == "call" then
			local previous = nth1(callStack, n1(callStack))
			if previous then
				previous["sum"] = previous["sum"] + (start - previous["inner-start"])
			end
		end
		if action ~= "call" then
			if not empty_3f_1(callStack) then
				local current = popLast_21_1(callStack)
				local hash = current["source"] .. current["linedefined"]
				local entry = stats[hash]
				if not entry then
					entry = {["source"]=current["source"], ["short-src"]=current["short_src"], ["line"]=current["linedefined"], ["name"]=current["name"], ["calls"]=0, ["total-time"]=0, ["inner-time"]=0}
					stats[hash] = entry
				end
				entry["calls"] = 1 + entry["calls"]
				entry["total-time"] = entry["total-time"] + (start - current["total-start"])
				entry["inner-time"] = entry["inner-time"] + (current["sum"] + (start - current["inner-start"]))
			end
		end
		if action ~= "return" then
			info["total-start"] = start
			info["inner-start"] = start
			info["sum"] = 0
			pushCdr_21_1(callStack, info)
		end
		if action == "return" then
			local next = last1(callStack)
			if next then
				next["inner-start"] = start
				return nil
			else
				return nil
			end
		else
			return nil
		end
	end, "cr")
	fn()
	sethook1()
	local out = values1(stats)
	sort1(out, function(a, b)
		return a["inner-time"] > b["inner-time"]
	end)
	print1("|               Method | Location                                                     |    Total |    Inner |   Calls |")
	print1("| -------------------- | ------------------------------------------------------------ | -------- | -------- | ------- |")
	local temp = n1(out)
	local temp1 = 1
	while temp1 <= temp do
		local entry = out[temp1]
		print1(format1("| %20s | %-60s | %8.5f | %8.5f | %7d | ", (function()
			if entry["name"] then
				return unmangleIdent1(entry["name"])
			else
				return "<unknown>"
			end
		end)(), remapMessage1(mappings, entry["short-src"] .. ":" .. entry["line"]), entry["total-time"], entry["inner-time"], entry["calls"]))
		temp1 = temp1 + 1
	end
	return stats
end
buildStack1 = function(parent, stack, i, history, fold)
	parent["n"] = parent["n"] + 1
	if i >= 1 then
		local elem = nth1(stack, i)
		local hash = elem["source"] .. "|" .. elem["linedefined"]
		local previous, child = fold and history[hash], parent[hash]
		if previous then
			parent["n"] = parent["n"] - 1
			child = previous
		end
		if not child then
			child = elem
			elem["n"] = 0
			parent[hash] = child
		end
		if not previous then
			history[hash] = child
		end
		buildStack1(child, stack, i - 1, history, fold)
		if previous then
			return nil
		else
			history[hash] = nil
			return nil
		end
	else
		return nil
	end
end
buildRevStack1 = function(parent, stack, i, history, fold)
	parent["n"] = parent["n"] + 1
	if i <= n1(stack) then
		local elem = nth1(stack, i)
		local hash = elem["source"] .. "|" .. elem["linedefined"]
		local previous, child = fold and history[hash], parent[hash]
		if previous then
			parent["n"] = parent["n"] - 1
			child = previous
		end
		if not child then
			child = elem
			elem["n"] = 0
			parent[hash] = child
		end
		if not previous then
			history[hash] = child
		end
		buildRevStack1(child, stack, i + 1, history, fold)
		if previous then
			return nil
		else
			history[hash] = nil
			return nil
		end
	else
		return nil
	end
end
finishStack1 = function(element)
	local children = {tag="list", n=0}
	local temp, child = next1(element)
	while temp ~= nil do
		if type_23_1(child) == "table" then
			pushCdr_21_1(children, child)
		end
		temp, child = next1(element, temp)
	end
	sort1(children, function(a, b)
		return a["n"] > b["n"]
	end)
	element["children"] = children
	local temp = n1(children)
	local temp1 = 1
	while temp1 <= temp do
		finishStack1((children[temp1]))
		temp1 = temp1 + 1
	end
	return nil
end
showStack_21_1 = function(out, mappings, total, stack, remaining)
	line_21_1(out, format1("└ %s %s %d (%2.5f%%)", (function()
		if stack["name"] then
			return unmangleIdent1(stack["name"])
		else
			return "<unknown>"
		end
	end)(), (function()
		if stack["short_src"] then
			return remapMessage1(mappings, stack["short_src"] .. ":" .. stack["linedefined"])
		else
			return ""
		end
	end)(), stack["n"], (stack["n"] / total) * 100))
	local temp
	if remaining then
		temp = remaining >= 1
	else
		temp = true
	end
	if temp then
		_5e7e_1(out, on_21_1("indent"), succ1)
		local temp = stack["children"]
		local temp1 = n1(temp)
		local temp2 = 1
		while temp2 <= temp1 do
			showStack_21_1(out, mappings, total, temp[temp2], remaining and remaining - 1)
			temp2 = temp2 + 1
		end
		out["indent"] = out["indent"] - 1
		return nil
	else
		return nil
	end
end
showFlame_21_1 = function(mappings, stack, before, remaining)
	local renamed = (function()
		if stack["name"] then
			return unmangleIdent1(stack["name"])
		else
			return "?"
		end
	end)() .. "`" .. (function()
		if stack["short_src"] then
			return remapMessage1(mappings, stack["short_src"] .. ":" .. stack["linedefined"])
		else
			return ""
		end
	end)()
	print1(format1("%s%s %d", before, renamed, stack["n"]))
	local temp
	if remaining then
		temp = remaining >= 1
	else
		temp = true
	end
	if temp then
		local whole, temp = before .. renamed .. ";", stack["children"]
		local temp1 = n1(temp)
		local temp2 = 1
		while temp2 <= temp1 do
			showFlame_21_1(mappings, temp[temp2], whole, remaining and remaining - 1)
			temp2 = temp2 + 1
		end
		return nil
	else
		return nil
	end
end
profileStack1 = function(fn, mappings, args)
	local stacks, top = {tag="list", n=0}, getinfo1(2, "S")
	sethook1(function(action)
		local pos, stack, info = 2, {tag="list", n=0}, getinfo1(2, "Sn")
		while info do
			if info["source"] == top["source"] and info["linedefined"] == top["linedefined"] then
				info = nil
			else
				pushCdr_21_1(stack, info)
				pos = pos + 1
				info = getinfo1(pos, "Sn")
			end
		end
		return pushCdr_21_1(stacks, stack)
	end, "", 100000.0)
	fn()
	sethook1()
	local folded = {["n"]=0, ["name"]="<root>"}
	local temp = n1(stacks)
	local temp1 = 1
	while temp1 <= temp do
		local stack = stacks[temp1]
		if args["stack-kind"] == "reverse" then
			buildRevStack1(folded, stack, 1, {}, args["stack-fold"])
		else
			buildStack1(folded, stack, n1(stack), {}, args["stack-fold"])
		end
		temp1 = temp1 + 1
	end
	finishStack1(folded)
	if args["stack-show"] == "flame" then
		return showFlame_21_1(mappings, folded, "", args["stack-limit"] or 30)
	else
		local writer = {["out"]={tag="list", n=0}, ["indent"]=0, ["tabs-pending"]=false, ["line"]=1, ["lines"]={}, ["node-stack"]={tag="list", n=0}, ["active-pos"]=nil}
		showStack_21_1(writer, mappings, n1(stacks), folded, args["stack-limit"] or 10)
		return print1(concat1(writer["out"]))
	end
end
matcher2 = function(pattern)
	return function(x)
		local res = list1(match1(x, pattern))
		if car1(res) == nil then
			return nil
		else
			return res
		end
	end
end
addCount_21_1 = function(counts, name, line, count)
	local fileCounts = counts[name]
	if not fileCounts then
		fileCounts = {["max"]=0}
		counts[name] = fileCounts
	end
	if line > fileCounts["max"] then
		fileCounts["max"] = line
	end
	fileCounts[line] = (fileCounts[line] or 0) + count
	return nil
end
readStats_21_1 = function(fileName, output)
	if not output then
		output = {}
	end
	local file = open1(fileName, "r")
	if file then
		while true do
			local max = self2(file, "read", "*n")
			if max then
				if self2(file, "read", 1) == ":" then
					local name = self2(file, "read", "*l")
					if name then
						local data = output[name]
						if not data then
							data = {["max"]=max}
							output[name] = data
						elseif max > data["max"] then
							data["max"] = max
						end
						local line = 1
						while true do
							if (line > max) then
								break
							else
								local count = self2(file, "read", "*n")
								if count then
									if self2(file, "read", 1) == " " then
										if count > 0 then
											data[line] = (data[line] or 0) + count
										end
										line = line + 1
									else
										break
									end
								else
									break
								end
							end
						end
					else
						break
					end
				else
					break
				end
			else
				break
			end
		end
		(getmetatable1(file) and getmetatable1(file)["--finalise"] or (file["close"] or function()
			return nil
		end))(file)
	end
	return output
end
writeStats_21_1 = function(compiler, fileName, output)
	local handle, err = open1(fileName, "w")
	if not handle then
		self2(compiler["log"], "put-error!", (formatOutput_21_1(nil, "Cannot open stats file " .. err)))
		exit_21_1(1)
	end
	local names = keys1(output)
	sort1(names, nil)
	local temp = n1(names)
	local temp1 = 1
	while temp1 <= temp do
		local name = names[temp1]
		local data = output[name]
		self2(handle, "write", data["max"], ":", name, "\n")
		local temp2 = data["max"]
		local temp3 = 1
		while temp3 <= temp2 do
			self2(handle, "write", data[temp3] or 0, " ")
			temp3 = temp3 + 1
		end
		self2(handle, "write", "\n")
		temp1 = temp1 + 1
	end
	return self2(handle, "close")
end
profileCoverage1 = function(fn, mappings, compiler)
	local visited = {}
	sethook1(function(action, line)
		local source = getinfo1(2, "S")["short_src"]
		local visitedLines = visited[source]
		if not visitedLines then
			visitedLines = {}
			visited[source] = visitedLines
		end
		local current = (visitedLines[line] or 0) + 1
		visitedLines[line] = current
		return nil
	end, "l")
	fn()
	sethook1()
	visited[getinfo1(1, "S")["short_src"]] = nil
	local result = readStats_21_1("luacov.stats.out")
	local temp, visitedLines = next1(visited)
	while temp ~= nil do
		local thisMappings = mappings[temp]
		if thisMappings then
			local temp1, count = next1(visitedLines)
			while temp1 ~= nil do
				local mapped = thisMappings[temp1]
				if mapped == nil then
				else
					local temp2
					local temp3 = matcher2("^(.-):(%d+)%-(%d+)$")(mapped)
					temp2 = type1(temp3) == "list" and (n1(temp3) >= 3 and (n1(temp3) <= 3 and true))
					if temp2 then
						local file, start, temp2 = nth1(matcher2("^(.-):(%d+)%-(%d+)$")(mapped), 1), nth1(matcher2("^(.-):(%d+)%-(%d+)$")(mapped), 2), tonumber1((nth1(matcher2("^(.-):(%d+)%-(%d+)$")(mapped), 3)))
						local temp3 = tonumber1(start)
						while temp3 <= temp2 do
							addCount_21_1(result, file, tonumber1(temp3), count)
							temp3 = temp3 + 1
						end
					else
						local temp2
						local temp3 = matcher2("^(.-):(%d+)$")(mapped)
						temp2 = type1(temp3) == "list" and (n1(temp3) >= 2 and (n1(temp3) <= 2 and true))
						if temp2 then
							addCount_21_1(result, nth1(matcher2("^(.-):(%d+)$")(mapped), 1), tonumber1((nth1(matcher2("^(.-):(%d+)$")(mapped), 2))), count)
						else
							error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(mapped) .. ", but none matched.\n" .. "  Tried: `nil`\n  Tried: `((matcher \"^(.-):(%d+)%-(%d+)$\") -> (?file ?start ?end))`\n  Tried: `((matcher \"^(.-):(%d+)$\") -> (?file ?line))`")
						end
					end
				end
				temp1, count = next1(visitedLines, temp1)
			end
		else
			local temp1, count = next1(visitedLines)
			while temp1 ~= nil do
				addCount_21_1(result, temp, temp1, count)
				temp1, count = next1(visitedLines, temp1)
			end
		end
		temp, visitedLines = next1(visited, temp)
	end
	return writeStats_21_1(compiler, "luacov.stats.out", result)
end
formatCoverage1 = function(hits, misses)
	if hits == 0 and misses == 0 then
		return "100%"
	else
		return format1("%2.f%%", 100 * (hits / (hits + misses)))
	end
end
genCoverageReport1 = function(compiler, args)
	if empty_3f_1(args["input"]) then
		self2(compiler["log"], "put-error!", "No inputs to generate a report for.")
		exit_21_1(1)
	end
	local stats, logger, max = readStats_21_1("luacov.stats.out"), compiler["log"], 0
	local temp, counts = next1(stats)
	while temp ~= nil do
		local temp1, count = next1(counts)
		while temp1 ~= nil do
			if number_3f_1(temp1) and count > max then
				max = count
			end
			temp1, count = next1(counts, temp1)
		end
		temp, counts = next1(stats, temp)
	end
	local maxSize = n1(format1("%d", max))
	local fmtZero, fmtNone, fmtNum, handle, err = rep1("*", maxSize) .. "0", rep1(" ", maxSize + 1), "%" .. maxSize + 1 .. "d", open1(args["gen-coverage"] or "luacov.report.out", "w")
	local summary, totalHits, totalMisses = {tag="list", n=0}, 0, 0
	if not handle then
		self2(logger, "put-error!", (formatOutput_21_1(nil, "Cannot open report file " .. err)))
		exit_21_1(1)
	end
	local temp = args["input"]
	local temp1 = n1(temp)
	local temp2 = 1
	while temp2 <= temp1 do
		local path = temp[temp2]
		self2(handle, "write", "==============================================================================", "\n")
		self2(handle, "write", path, "\n")
		self2(handle, "write", "==============================================================================", "\n")
		local lib = compiler["lib-cache"][gsub1(path, "%.lisp$", "")]
		local lines = split1(lib["lisp"], "\n")
		local nLines, counts, active, hits, misses = n1(lines), stats[path], {}, 0, 0
		visitBlock1(lib["out"], 1, function(node)
			local temp3
			if not (type1(node) == "list") then
				temp3 = true
			else
				local head = car1(node)
				local temp4 = type1(head)
				if temp4 == "symbol" then
					local var = head["var"]
					temp3 = var ~= builtins1["lambda"] and (var ~= builtins1["cond"] and (var ~= builtins1["import"] and (var ~= builtins1["define"] and (var ~= builtins1["define-macro"] and var ~= builtins1["define-native"]))))
				elseif temp4 == "list" then
					temp3 = not builtin_3f_1(car1(head), "lambda")
				else
					temp3 = true
				end
			end
			if temp3 then
				local source = getSource1(node)
				if source["name"] == path then
					local temp3 = source["finish"]["line"]
					local temp4 = source["start"]["line"]
					while temp4 <= temp3 do
						active[temp4] = true
						temp4 = temp4 + 1
					end
					return nil
				else
					return nil
				end
			else
				return nil
			end
		end)
		local temp3 = 1
		while temp3 <= nLines do
			local line, isActive, count = nth1(lines, temp3), active[temp3], counts and counts[temp3] or 0
			if not isActive and count > 0 then
				self2(logger, "put-warning!", (formatOutput_21_1(nil, "" .. path .. ":" .. temp3 .. " is not active but has count " .. count)))
			end
			if not isActive then
				if line == "" then
					self2(handle, "write", "\n")
				else
					self2(handle, "write", fmtNone, " ", line, "\n")
				end
			elseif count > 0 then
				hits = hits + 1
				self2(handle, "write", format1(fmtNum, count), " ", line, "\n")
			else
				misses = misses + 1
				self2(handle, "write", fmtZero, " ", line, "\n")
			end
			temp3 = temp3 + 1
		end
		pushCdr_21_1(summary, list1(path, format1("%d", hits), format1("%d", misses), formatCoverage1(hits, misses)))
		totalHits = totalHits + hits
		totalMisses = totalMisses + misses
		temp2 = temp2 + 1
	end
	self2(handle, "write", "==============================================================================", "\n")
	self2(handle, "write", "Summary\n")
	self2(handle, "write", "==============================================================================", "\n\n")
	local headings = {tag="list", n=4, "File", "Hits", "Misses", "Coverage"}
	local widths, total = map2(n1, headings), list1("Total", format1("%d", totalHits), format1("%d", totalMisses), formatCoverage1(totalHits, totalMisses))
	local temp = n1(summary)
	local temp1 = 1
	while temp1 <= temp do
		local row = summary[temp1]
		local temp2 = n1(row)
		local temp3 = 1
		while temp3 <= temp2 do
			local width = n1(row[temp3])
			if width > widths[temp3] then
				widths[temp3] = width
			end
			temp3 = temp3 + 1
		end
		temp1 = temp1 + 1
	end
	local temp = n1(total)
	local temp1 = 1
	while temp1 <= temp do
		if n1(total[temp1]) > widths[temp1] then
			widths = temp1
		end
		temp1 = temp1 + 1
	end
	local format = "%-" .. concat1(widths, "s %-") .. "s\n"
	local separator = rep1("-", n1(apply1(format1, format, headings))) .. "\n"
	self2(handle, "write", apply1(format1, format, headings))
	self2(handle, "write", separator)
	local temp = n1(summary)
	local temp1 = 1
	while temp1 <= temp do
		self2(handle, "write", apply1(format1, format, (summary[temp1])))
		temp1 = temp1 + 1
	end
	self2(handle, "write", separator)
	self2(handle, "write", apply1(format1, format, total))
	return self2(handle, "close")
end
runLua1 = function(compiler, args)
	if empty_3f_1(args["input"]) then
		self2(compiler["log"], "put-error!", "No inputs to run.")
		exit_21_1(1)
	end
	local out = file1(compiler, false)
	local lines, logger = generateMappings1(out["lines"]), compiler["log"]
	local name
	if string_3f_1(args["emit-lua"]) then
		name = args["emit-lua"]
	else
		name = args["output"] .. ".lua"
	end
	local temp = list1(load1(concat1(out["out"]), "=" .. name))
	if type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (nth1(temp, 1) == nil and true))) then
		local msg = nth1(temp, 2)
		self2(logger, "put-error!", "Cannot load compiled source.")
		print1(msg)
		print1(concat1(out["out"]))
		return exit_21_1(1)
	elseif type1(temp) == "list" and (n1(temp) >= 1 and (n1(temp) <= 1 and true)) then
		local fun = nth1(temp, 1)
		_5f_G1["arg"] = args["script-args"]
		_5f_G1["arg"][0] = car1(args["input"])
		local exec, temp1 = function()
			local temp2 = list1(xpcall1(function()
				return apply1(fun, args["script-args"])
			end, traceback3))
			if type1(temp2) == "list" and (n1(temp2) >= 1 and (nth1(temp2, 1) == true and true)) then
				return nil
			elseif type1(temp2) == "list" and (n1(temp2) >= 2 and (n1(temp2) <= 2 and (nth1(temp2, 1) == false and true))) then
				local msg = nth1(temp2, 2)
				self2(logger, "put-error!", "Execution failed.")
				print1(remapTraceback1({[name]=lines}, msg))
				return exit_21_1(1)
			else
				return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp2) .. ", but none matched.\n" .. "  Tried: `(true . _)`\n  Tried: `(false ?msg)`")
			end
		end, args["profile"]
		if temp1 == "none" then
			return exec()
		elseif temp1 == nil then
			return exec()
		elseif temp1 == "call" then
			return profileCalls1(exec, {[name]=lines})
		elseif temp1 == "stack" then
			return profileStack1(exec, {[name]=lines}, args)
		elseif temp1 == "coverage" then
			return profileCoverage1(exec, {[name]=lines}, compiler)
		else
			self2(logger, "put-error!", ("Unknown profiler '" .. temp1 .. "'"))
			return exit_21_1(1)
		end
	else
		return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `(nil ?msg)`\n  Tried: `(?fun)`")
	end
end
task2 = {["name"]="run", ["setup"]=function(spec)
	addCategory_21_1(spec, "run", "Running files", "Provides a way to running the compiled script, along with various extensions such as profiling tools.")
	addArgument_21_1(spec, {tag="list", n=2, "--run", "-r"}, "help", "Run the compiled code.", "cat", "run")
	addArgument_21_1(spec, {tag="list", n=1, "--"}, "name", "script-args", "cat", "run", "help", "Arguments to pass to the compiled script.", "var", "ARG", "all", true, "default", {tag="list", n=0}, "action", addAction1, "narg", "*")
	addArgument_21_1(spec, {tag="list", n=2, "--profile", "-p"}, "help", "Run the compiled code with the profiler.", "cat", "run", "var", "none|call|stack", "default", nil, "value", "stack", "narg", "?")
	addArgument_21_1(spec, {tag="list", n=1, "--stack-kind"}, "help", "The kind of stack to emit when using the stack profiler. A reverse stack shows callers of that method instead.", "cat", "run", "var", "forward|reverse", "default", "forward", "narg", 1)
	addArgument_21_1(spec, {tag="list", n=1, "--stack-show"}, "help", "The method to use to display the profiling results.", "cat", "run", "var", "flame|term", "default", "term", "narg", 1)
	addArgument_21_1(spec, {tag="list", n=1, "--stack-limit"}, "help", "The maximum number of call frames to emit.", "cat", "run", "var", "LIMIT", "default", nil, "action", setNumAction1, "narg", 1)
	return addArgument_21_1(spec, {tag="list", n=1, "--stack-fold"}, "help", "Whether to fold recursive functions into themselves. This hopefully makes deep graphs easier to understand, but may result in less accurate graphs.", "cat", "run", "value", true, "default", false)
end, ["pred"]=function(args)
	return args["run"] or args["profile"]
end, ["run"]=runLua1}
coverageReport1 = {["name"]="coverage-report", ["setup"]=function(spec)
	return addArgument_21_1(spec, {tag="list", n=1, "--gen-coverage"}, "help", "Specify the folder to emit documentation to.", "cat", "run", "default", nil, "value", "luacov.report.out", "narg", "?")
end, ["pred"]=function(args)
	return nil ~= args["gen-coverage"]
end, ["run"]=genCoverageReport1}
dotQuote1 = function(prefix, name)
	if find1(name, "^[%w_][%d%w_]*$") then
		if string_3f_1(prefix) then
			return prefix .. "." .. name
		else
			return name
		end
	elseif string_3f_1(prefix) then
		return prefix .. "[" .. quoted1(name) .. "]"
	else
		return "_ENV[" .. quoted1(name) .. "]"
	end
end
genNative1 = function(compiler, args)
	if n1(args["input"]) ~= 1 then
		self2(compiler["log"], "put-error!", "Expected just one input")
		exit_21_1(1)
	end
	local prefix, lib = args["gen-native"], compiler["lib-cache"][gsub1(last1(args["input"]), "%.lisp$", "")]
	local escaped
	if string_3f_1(prefix) then
		escaped = escape1(last1(split1(lib["name"], "/")))
	else
		escaped = nil
	end
	local maxName, maxQuot, maxPref, natives = 0, 0, 0, {tag="list", n=0}
	local temp = lib["out"]
	local temp1 = n1(temp)
	local temp2 = 1
	while temp2 <= temp1 do
		local node = temp[temp2]
		if type1(node) == "list" and (type1((car1(node))) == "symbol" and car1(node)["contents"] == "define-native") then
			local name = nth1(node, 2)["contents"]
			pushCdr_21_1(natives, name)
			maxName = max1(maxName, n1(quoted1(name)))
			maxQuot = max1(maxQuot, n1(quoted1(dotQuote1(prefix, name))))
			maxPref = max1(maxPref, n1(dotQuote1(escaped, name)))
		end
		temp2 = temp2 + 1
	end
	sort1(natives, nil)
	local handle, format = open1(lib["path"] .. ".meta.lua", "w"), "\9[%-" .. tostring1(maxName + 3) .. "s { tag = \"var\", contents = %-" .. tostring1(maxQuot + 1) .. "s value = %-" .. tostring1(maxPref + 1) .. "s },\n"
	if not handle then
		self2(compiler["log"], "put-error!", ("Cannot write to " .. lib["path"] .. ".meta.lua"))
		exit_21_1(1)
	end
	if string_3f_1(prefix) then
		self2(handle, "write", format1("local %s = %s or {}\n", escaped, prefix))
	end
	self2(handle, "write", "return {\n")
	local temp = n1(natives)
	local temp1 = 1
	while temp1 <= temp do
		local native = natives[temp1]
		self2(handle, "write", format1(format, quoted1(native) .. "] =", quoted1(dotQuote1(prefix, native)) .. ",", dotQuote1(escaped, native) .. ","))
		temp1 = temp1 + 1
	end
	self2(handle, "write", "}\n")
	return self2(handle, "close")
end
task3 = {["name"]="gen-native", ["setup"]=function(spec)
	return addArgument_21_1(spec, {tag="list", n=1, "--gen-native"}, "help", "Generate native bindings for a file", "var", "PREFIX", "narg", "?")
end, ["pred"]=function(args)
	return args["gen-native"]
end, ["run"]=genNative1}
printError_21_1 = function(msg)
	if not string_3f_1(msg) then
		msg = pretty1(msg)
	end
	local lines = split1(msg, "\n", 1)
	print1(coloured1(31, "[ERROR] " .. car1(lines)))
	if cadr1(lines) then
		return print1(cadr1(lines))
	else
		return nil
	end
end
printWarning_21_1 = function(msg)
	local lines = split1(msg, "\n", 1)
	print1(coloured1(33, "[WARN] " .. car1(lines)))
	if cadr1(lines) then
		return print1(cadr1(lines))
	else
		return nil
	end
end
printVerbose_21_1 = function(verbosity, msg)
	if verbosity > 0 then
		return formatOutput_21_1(true, "[VERBOSE] " .. msg)
	else
		return nil
	end
end
printDebug_21_1 = function(verbosity, msg)
	if verbosity > 1 then
		return formatOutput_21_1(true, "[DEBUG] " .. msg)
	else
		return nil
	end
end
printTime_21_1 = function(maximum, name, time, level)
	if level <= maximum then
		return formatOutput_21_1(true, "[TIME] " .. name .. " took " .. time)
	else
		return nil
	end
end
printExplain_21_1 = function(explain, lines)
	if explain then
		local temp = split1(lines, "\n")
		local temp1 = n1(temp)
		local temp2 = 1
		while temp2 <= temp1 do
			print1("  " .. (temp[temp2]))
			temp2 = temp2 + 1
		end
		return nil
	else
		return nil
	end
end
create4 = function(verbosity, explain, time)
	return {["verbosity"]=verbosity or 0, ["explain"]=explain == true, ["time"]=time or 0, ["put-error!"]=putError_21_1, ["put-warning!"]=putWarning_21_1, ["put-verbose!"]=putVerbose_21_1, ["put-debug!"]=putDebug_21_1, ["put-time!"]=putTime_21_1, ["put-node-error!"]=putNodeError_21_2, ["put-node-warning!"]=putNodeWarning_21_2}
end
putError_21_1 = function(logger, msg)
	return printError_21_1(msg)
end
putWarning_21_1 = function(logger, msg)
	return printWarning_21_1(msg)
end
putVerbose_21_1 = function(logger, msg)
	return printVerbose_21_1(logger["verbosity"], msg)
end
putDebug_21_1 = function(logger, msg)
	return printDebug_21_1(logger["verbosity"], msg)
end
putTime_21_1 = function(logger, name, time, level)
	return printTime_21_1(logger["time"], name, time, level)
end
putNodeError_21_2 = function(logger, msg, node, explain, lines)
	printError_21_1(msg)
	putTrace_21_1(node)
	if explain then
		printExplain_21_1(logger["explain"], explain)
	end
	return putLines_21_1(true, lines)
end
putNodeWarning_21_2 = function(logger, msg, node, explain, lines)
	printWarning_21_1(msg)
	putTrace_21_1(node)
	if explain then
		printExplain_21_1(logger["explain"], explain)
	end
	return putLines_21_1(true, lines)
end
putLines_21_1 = function(range, entries)
	if empty_3f_1(entries) then
		error1("Positions cannot be empty")
	end
	if n1(entries) % 2 ~= 0 then
		error1("Positions must be a multiple of 2, is " .. n1(entries))
	end
	local previous, file, code, temp = -1, nth1(entries, 1)["name"], coloured1(92, " %" .. n1(tostring1((reduce1(function(max, node)
		if string_3f_1(node) then
			return max
		else
			return max1(max, node["start"]["line"])
		end
	end, 0, entries)))) .. "s │") .. " %s", n1(entries)
	local temp1 = 1
	while temp1 <= temp do
		local position, message = entries[temp1], entries[temp1 + 1]
		if file ~= position["name"] then
			file = position["name"]
			print1(coloured1(95, " " .. file))
		elseif previous ~= -1 and abs1(position["start"]["line"] - previous) > 2 then
			print1(coloured1(92, " ..."))
		end
		previous = position["start"]["line"]
		print1(format1(code, tostring1(position["start"]["line"]), position["lines"][position["start"]["line"]]))
		local pointer
		if not range then
			pointer = "^"
		elseif position["finish"] and position["start"]["line"] == position["finish"]["line"] then
			pointer = rep1("^", (position["finish"]["column"] - position["start"]["column"]) + 1)
		else
			pointer = "^..."
		end
		print1(format1(code, "", rep1(" ", position["start"]["column"] - 1) .. pointer .. " " .. message))
		temp1 = temp1 + 2
	end
	return nil
end
putTrace_21_1 = function(node)
	local previous = nil
	while node do
		local formatted = formatNode1(node)
		if previous == nil then
			print1(coloured1(96, "  => " .. formatted))
		elseif previous ~= formatted then
			print1("  in " .. formatted)
		end
		previous = formatted
		node = node["parent"]
	end
	return nil
end
createPluginState1 = function(compiler)
	local logger, variables, states, warnings, optimise, activeScope, activeNode = compiler["log"], compiler["variables"], compiler["states"], compiler["warning"], compiler["optimise"], function()
		return compiler["active-scope"]
	end, function()
		return compiler["active-node"]
	end
	return {["logger/put-error!"]=function(temp)
		return self2(logger, "put-error!", temp)
	end, ["logger/put-warning!"]=function(temp)
		return self2(logger, "put-warning!", temp)
	end, ["logger/put-verbose!"]=function(temp)
		return self2(logger, "put-verbose!", temp)
	end, ["logger/put-debug!"]=function(temp)
		return self2(logger, "put-debug!", temp)
	end, ["logger/put-node-error!"]=function(msg, node, explain, ...)
		local lines = _pack(...) lines.tag = "list"
		return putNodeError_21_1(logger, msg, node, explain, unpack1(lines, 1, n1(lines)))
	end, ["logger/put-node-warning!"]=function(msg, node, explain, ...)
		local lines = _pack(...) lines.tag = "list"
		return putNodeWarning_21_1(logger, msg, node, explain, unpack1(lines, 1, n1(lines)))
	end, ["logger/do-node-error!"]=function(msg, node, explain, ...)
		local lines = _pack(...) lines.tag = "list"
		return doNodeError_21_1(logger, msg, node, explain, unpack1(lines, 1, n1(lines)))
	end, ["range/get-source"]=getSource1, ["flags"]=function()
		return map2(id1, compiler["flags"])
	end, ["flag?"]=function(temp)
		return elem_3f_1(temp, compiler["flags"])
	end, ["visit-node"]=visitNode1, ["visit-nodes"]=visitBlock1, ["traverse-nodes"]=traverseNode1, ["traverse-nodes"]=traverseList1, ["symbol->var"]=function(x)
		local var = x["var"]
		if string_3f_1(var) then
			return variables[var]
		else
			return var
		end
	end, ["var->symbol"]=makeSymbol1, ["builtin"]=function(temp)
		return builtins1[temp]
	end, ["builtin?"]=builtin_3f_1, ["constant?"]=constant_3f_1, ["node->val"]=urn_2d3e_val1, ["val->node"]=val_2d3e_urn1, ["node-contains-var?"]=nodeContainsVar_3f_1, ["node-contains-vars?"]=nodeContainsVars_3f_1, ["fusion/add-rule!"]=addRule_21_1, ["add-pass!"]=function(pass)
		local temp = type1(pass)
		if temp ~= "table" then
			error1(format1("bad argument %s (expected %s, got %s)", "pass", "table", temp), 2)
		end
		if not string_3f_1(pass["name"]) then
			error1("Expected string for name, got " .. type1(pass["name"]))
		end
		if not invokable_3f_1(pass["run"]) then
			error1("Expected function for run, got " .. type1(pass["run"]))
		end
		if not (type1((pass["cat"])) == "list") then
			error1("Expected list for cat, got " .. type1(pass["cat"]))
		end
		local func = pass["run"]
		pass["run"] = function(...)
			local args = _pack(...) args.tag = "list"
			local temp = list1(xpcall1(function()
				return apply1(func, args)
			end, traceback3))
			if type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (nth1(temp, 1) == false and true))) then
				local msg = nth1(temp, 2)
				return error1(remapTraceback1(compiler["compile-state"]["mappings"], msg), 0)
			elseif type1(temp) == "list" and (n1(temp) >= 1 and (nth1(temp, 1) == true and true)) then
				local rest = slice1(temp, 2)
				return unpack1(rest, 1, n1(rest))
			else
				return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `(false ?msg)`\n  Tried: `(true . ?rest)`")
			end
		end
		local cats = pass["cat"]
		if elem_3f_1("opt", cats) then
			if any1(function(temp)
				return sub1(temp, 1, 10) == "transform-"
			end, cats) then
				pushCdr_21_1(optimise["transform"], pass)
			elseif elem_3f_1("usage", cats) then
				pushCdr_21_1(optimise["usage"], pass)
			else
				pushCdr_21_1(optimise["normal"], pass)
			end
		elseif elem_3f_1("warn", cats) then
			if elem_3f_1("usage", cats) then
				pushCdr_21_1(warnings["usage"], pass)
			else
				pushCdr_21_1(warnings["normal"], pass)
			end
		else
			error1("Cannot register " .. pretty1(pass["name"]) .. " (do not know how to process " .. pretty1(cats) .. ")")
		end
		return nil
	end, ["var-usage"]=getVar1, ["active-scope"]=activeScope, ["active-node"]=activeNode, ["active-module"]=function()
		local scp = compiler["active-scope"]
		while not (scp["is-root"]) do
			scp = scp["parent"]
		end
		return scp
	end, ["scope-vars"]=function(scp)
		if not scp then
			return compiler["active-scope"]["variables"]
		else
			return scp["variables"]
		end
	end, ["var-lookup"]=function(symb, scope)
		local temp = type1(symb)
		if temp ~= "symbol" then
			error1(format1("bad argument %s (expected %s, got %s)", "symb", "symbol", temp), 2)
		end
		if compiler["active-node"] == nil then
			error1("Not currently resolving")
		end
		if not scope then
			scope = compiler["active-scope"]
		end
		return getAlways_21_1(scope, symbol_2d3e_string1(symb), compiler["active-node"])
	end, ["try-var-lookup"]=function(symb, scope)
		local temp = type1(symb)
		if temp ~= "symbol" then
			error1(format1("bad argument %s (expected %s, got %s)", "symb", "symbol", temp), 2)
		end
		if compiler["active-node"] == nil then
			error1("Not currently resolving")
		end
		if not scope then
			scope = compiler["active-scope"]
		end
		return get1(scope, symbol_2d3e_string1(symb))
	end, ["var-definition"]=function(var)
		if compiler["active-node"] == nil then
			error1("Not currently resolving")
		end
		local state = states[var]
		if state then
			if state["stage"] == "parsed" then
				yield1({["tag"]="build", ["state"]=state})
			end
			return state["node"]
		else
			return nil
		end
	end, ["var-value"]=function(var)
		if compiler["active-node"] == nil then
			error1("Not currently resolving")
		end
		local state = states[var]
		if state then
			return get_21_1(state)
		else
			return nil
		end
	end, ["var-docstring"]=function(var)
		return var["doc"]
	end}
end
normalisePath1 = function(path, trailing)
	path = gsub1(path, "\\", "/")
	if trailing and (path ~= "" and sub1(path, -1, -1) ~= "/") then
		path = path .. "/"
	end
	while sub1(path, 1, 2) == "./" do
		path = sub1(path, 3)
	end
	return path
end
local spec = create1("The compiler and REPL for the Urn programming language.")
local directory
local dir = getenv1("URN_STDLIB")
if dir then
	directory = normalisePath1(dir, true)
else
	local path = arg1[0]
	if find1(path, "urn[/\\]cli%.lisp$") then
		path = gsub1(path, "urn[/\\]cli%.lisp$", "")
	elseif find1(path, "bin[/\\][^/\\]*$") then
		path = gsub1(path, "bin[/\\][^/\\]*$", "")
	else
		path = gsub1(path, "[^/\\]*$", "")
	end
	directory = normalisePath1(path, true) .. "lib/"
end
local paths, tasks = list1("?", "?/init", directory .. "?", directory .. "?/init"), list1(coverageReport1, task1, task3, warning1, optimise2, emitLisp1, emitLua1, task2, execTask1, replTask1)
addHelp_21_1(spec)
addCategory_21_1(spec, "out", "Output", "Customise what is emitted, as well as where and how it is generated.")
addArgument_21_1(spec, {tag="list", n=2, "--explain", "-e"}, "help", "Explain error messages in more detail.")
addArgument_21_1(spec, {tag="list", n=2, "--time", "-t"}, "help", "Time how long each task takes to execute. Multiple usages will show more detailed timings.", "many", true, "default", 0, "action", function(arg, data)
	data[arg["name"]] = (data[arg["name"]] or 0) + 1
	return nil
end)
addArgument_21_1(spec, {tag="list", n=2, "--verbose", "-v"}, "help", "Make the output more verbose. Can be used multiple times", "many", true, "default", 0, "action", function(arg, data)
	data[arg["name"]] = (data[arg["name"]] or 0) + 1
	return nil
end)
addArgument_21_1(spec, {tag="list", n=2, "--include", "-i"}, "help", "Add an additional argument to the include path.", "many", true, "narg", 1, "default", {tag="list", n=0}, "action", addAction1)
addArgument_21_1(spec, {tag="list", n=2, "--prelude", "-p"}, "help", "A custom prelude path to use.", "narg", 1, "default", directory .. "prelude")
addArgument_21_1(spec, {tag="list", n=3, "--output", "--out", "-o"}, "help", "The destination to output to.", "cat", "Output", "narg", 1, "default", "out", "action", function(arg, data, value)
	data[arg["name"]] = gsub1(value, "%.lua$", "")
	return nil
end)
addArgument_21_1(spec, {tag="list", n=2, "--wrapper", "-w"}, "help", "A wrapper script to launch Urn with", "narg", 1, "action", function(a, b, value)
	local args, i = map2(id1, arg1), 1
	local len = n1(args)
	while i <= len do
		local item = nth1(args, i)
		if item == "--wrapper" or item == "-w" then
			removeNth_21_1(args, i)
			removeNth_21_1(args, i)
			i = len + 1
		elseif find1(item, "^%-%-wrapper=.*$") then
			removeNth_21_1(args, i)
			i = len + 1
		elseif find1(item, "^%-[^-]+w$") then
			args[i] = sub1(item, 1, -2)
			removeNth_21_1(args, i + 1)
			i = len + 1
		end
	end
	local command = list1(value)
	local interp = arg1[-1]
	if interp then
		pushCdr_21_1(command, interp)
	end
	pushCdr_21_1(command, arg1[0])
	local temp = list1(execute1(concat1(append1(command, args), " ")))
	if type1(temp) == "list" and (n1(temp) >= 1 and (number_3f_1(nth1(temp, 1)) and true)) then
		return exit1((nth1(temp, 1)))
	elseif type1(temp) == "list" and (n1(temp) >= 3 and (n1(temp) <= 3 and true)) then
		return exit1((nth1(temp, 3)))
	else
		return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `((number? @ ?code) . _)`\n  Tried: `(_ _ ?code)`")
	end
end)
addArgument_21_1(spec, {tag="list", n=1, "--plugin"}, "help", "Specify a compiler plugin to load.", "var", "FILE", "default", {tag="list", n=0}, "narg", 1, "many", true, "action", addAction1)
addArgument_21_1(spec, {tag="list", n=2, "--flag", "-f"}, "help", "Turn on a compiler flag, enabling or disabling a specific feature.", "default", {tag="list", n=0}, "narg", 1, "many", true, "action", addAction1)
addArgument_21_1(spec, {tag="list", n=1, "input"}, "help", "The file(s) to load.", "var", "FILE", "narg", "*")
local temp = n1(tasks)
local temp1 = 1
while temp1 <= temp do
	local task = tasks[temp1]
	task["setup"](spec)
	temp1 = temp1 + 1
end
local args = parse_21_1(spec)
local logger = create4(args["verbose"], args["explain"], args["time"])
local temp = args["include"]
local temp1 = n1(temp)
local temp2 = 1
while temp2 <= temp1 do
	local path = temp[temp2]
	if find1(path, "%?") then
		pushCdr_21_1(paths, normalisePath1(path, false))
	else
		path = normalisePath1(path, true)
		pushCdr_21_1(paths, path .. "?")
		pushCdr_21_1(paths, path .. "?/init")
	end
	temp2 = temp2 + 1
end
self2(logger, "put-verbose!", ("Using path: " .. pretty1(paths)))
if args["prelude"] == directory .. "prelude" and empty_3f_1(args["plugin"]) then
	pushCdr_21_1(args["plugin"], directory .. "../plugins/fold-defgeneric.lisp")
end
if empty_3f_1(args["input"]) then
	args["repl"] = true
elseif not args["emit-lua"] then
	args["emit-lua"] = true
end
local compiler = {["log"]=logger, ["timer"]={["callback"]=function(temp, temp1, temp2)
	return self2(logger, "put-time!", temp, temp1, temp2)
end, ["timers"]={}}, ["paths"]=paths, ["flags"]=args["flag"], ["lib-env"]={}, ["lib-meta"]={}, ["libs"]={tag="list", n=0}, ["lib-cache"]={}, ["lib-names"]={}, ["warning"]=default2(), ["optimise"]=default1(), ["root-scope"]=rootScope1, ["variables"]={}, ["states"]={}, ["out"]={tag="list", n=0}}
compiler["compile-state"] = createState1(compiler["lib-meta"])
compiler["loader"] = function(name)
	return loader1(compiler, name, true)
end
compiler["global"] = setmetatable1({["_libs"]=compiler["lib-env"], ["_compiler"]=createPluginState1(compiler)}, {["__index"]=_5f_G1})
local temp = compiler["root-scope"]["variables"]
local temp1, var = next1(temp)
while temp1 ~= nil do
	compiler["variables"][tostring1(var)] = var
	temp1, var = next1(temp, temp1)
end
startTimer_21_1(compiler["timer"], "loading")
local doLoad_21_ = function(name)
	local temp = list1(xpcall1(function()
		return loader1(compiler, name, false)
	end, traceback2))
	if type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (nth1(temp, 1) == false and nth1(temp, 2) == sentinel1))) then
		return exit_21_1(1)
	elseif type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (nth1(temp, 1) == false and true))) then
		return error1((nth1(temp, 2)), 0)
	else
		local temp1
		if type1(temp) == "list" then
			if n1(temp) >= 2 then
				if n1(temp) <= 2 then
					if nth1(temp, 1) == true then
						local temp2 = nth1(temp, 2)
						temp1 = type1(temp2) == "list" and (n1(temp2) >= 2 and (n1(temp2) <= 2 and (nth1(temp2, 1) == nil and true)))
					else
						temp1 = false
					end
				else
					temp1 = false
				end
			else
				temp1 = false
			end
		else
			temp1 = false
		end
		if temp1 then
			self2(logger, "put-error!", ((nth1(nth1(temp, 2), 2))))
			return exit_21_1(1)
		else
			local temp1
			if type1(temp) == "list" then
				if n1(temp) >= 2 then
					if n1(temp) <= 2 then
						if nth1(temp, 1) == true then
							local temp2 = nth1(temp, 2)
							temp1 = type1(temp2) == "list" and (n1(temp2) >= 1 and (n1(temp2) <= 1 and true))
						else
							temp1 = false
						end
					else
						temp1 = false
					end
				else
					temp1 = false
				end
			else
				temp1 = false
			end
			if temp1 then
				return (nth1(nth1(temp, 2), 1))
			else
				return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `(false error/resolver-error?)`\n  Tried: `(false ?error-message)`\n  Tried: `(true (nil ?error-message))`\n  Tried: `(true (?lib))`")
			end
		end
	end
end
local lib = doLoad_21_(args["prelude"])
compiler["root-scope"] = child1(compiler["root-scope"])
local temp = lib["scope"]["exported"]
local temp1, var = next1(temp)
while temp1 ~= nil do
	import_21_1(compiler["root-scope"], temp1, var)
	temp1, var = next1(temp, temp1)
end
local temp = append1(args["plugin"], args["input"])
local temp1 = n1(temp)
local temp2 = 1
while temp2 <= temp1 do
	doLoad_21_((temp[temp2]))
	temp2 = temp2 + 1
end
stopTimer_21_1(compiler["timer"], "loading")
local temp = n1(tasks)
local temp1 = 1
while temp1 <= temp do
	local task = tasks[temp1]
	if task["pred"](args) then
		startTimer_21_1(compiler["timer"], task["name"], 1)
		task["run"](compiler, args)
		stopTimer_21_1(compiler["timer"], task["name"])
	end
	temp1 = temp1 + 1
end
return nil
