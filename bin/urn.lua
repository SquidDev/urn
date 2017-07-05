#!/usr/bin/env lua
if not table.pack then table.pack = function(...) return { n = select("#", ...), ... } end end
if not table.unpack then table.unpack = unpack end
local load = load if _VERSION:find("5.1") then load = function(x, n, _, env) local f, e = loadstring(x, n) if not f then return f, e end if env then setfenv(f, env) end return f end end
local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error
local _libs = {}
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
_25_1 = function(...) local t = ... for i = 2, _select('#', ...) do t = t % _select(i, ...) end return t end
_2e2e_1 = function(...) local n = _select('#', ...) local t = _select(n, ...) for i = n - 1, 1, -1 do t = _select(i, ...) .. t end return t end
_5f_G1 = _G
arg_23_1 = arg
len_23_1 = function(v1) return #v1 end
error1 = error
getmetatable1 = getmetatable
load1 = load
next1 = next
pcall1 = pcall
print1 = print
getIdx1 = function(v1, v2) return v1[v2] end
setIdx_21_1 = function(v1, v2, v3) v1[v2] = v3 end
setmetatable1 = setmetatable
tonumber1 = tonumber
tostring1 = tostring
type_23_1 = type
xpcall1 = xpcall
n1 = (function(x)
	if type_23_1(x) == "table" then
		return x["n"]
	else
		return #x
	end
end)
slice1 = (function(xs, start, finish)
	if finish then
	else
		finish = xs["n"]
		if finish then
		else
			finish = #xs
		end
	end
	local len = (finish - start) + 1
	if len < 0 then
		len = 0
	end
	local out, i, j = ({["tag"]="list",["n"]=len}), 1, start
	while j <= finish do
		out[i] = xs[j]
		i, j = i + 1, j + 1
	end
	return out
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
list1 = (function(...)
	local xs = _pack(...) xs.tag = "list"
	return xs
end)
cons1 = (function(x, xs)
	local _offset, _result, _temp = 0, {tag="list",n=0}
	_result[1 + _offset] = x
	_temp = xs
	for _c = 1, _temp.n do _result[1 + _c + _offset] = _temp[_c] end
	_offset = _offset + _temp.n
	_result.n = _offset + 1
	return _result
end)
local counter = 0
gensym1 = (function(name)
	if type_23_1(name) == "table" and name["tag"] == "symbol" then
		name = "_" .. name["contents"]
	elseif name then
		name = "_" .. name
	else
		name = ""
	end
	counter = counter + 1
	return ({["tag"]="symbol",["display-name"]="temp",["contents"]=format1("r_%d%s", counter, name)})
end)
pretty1 = (function(value)
	local ty = type_23_1(value)
	if ty == "table" then
		local tag = value["tag"]
		if tag == "list" then
			local out = ({tag = "list", n = 0})
			local temp = n1(value)
			local temp1 = 1
			while temp1 <= temp do
				out[temp1] = pretty1(value[temp1])
				temp1 = temp1 + 1
			end
			return "(" .. concat1(out, " ") .. ")"
		elseif type_23_1(getmetatable1(value)) == "table" and type_23_1(getmetatable1(value)["--pretty-print"]) == "function" then
			return getmetatable1(value)["--pretty-print"](value)
		elseif tag == "list" then
			return value["contents"]
		elseif tag == "symbol" then
			return value["contents"]
		elseif tag == "key" then
			return ":" .. value["value"]
		elseif tag == "string" then
			return format1("%q", value["value"])
		elseif tag == "number" then
			return tostring1(value["value"])
		else
			local out = ({tag = "list", n = 0})
			local temp, v = next1(value)
			while temp ~= nil do
				out = cons1(pretty1(temp) .. " " .. pretty1(v), out)
				temp, v = next1(value, temp)
			end
			return "{" .. (concat1(out, " ") .. "}")
		end
	elseif ty == "string" then
		return format1("%q", value)
	else
		return tostring1(value)
	end
end)
if nil == arg_23_1 then
	arg1 = ({tag = "list", n = 0})
else
	arg_23_1["tag"] = "list"
	if arg_23_1["n"] then
	else
		arg_23_1["n"] = #arg_23_1
	end
	arg1 = arg_23_1
end
constVal1 = (function(val)
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
end)
empty_3f_1 = (function(x)
	local xt = type1(x)
	if xt == "list" then
		return n1(x) == 0
	elseif xt == "string" then
		return #x == 0
	else
		return false
	end
end)
string_3f_1 = (function(x)
	return type_23_1(x) == "string" or type_23_1(x) == "table" and x["tag"] == "string"
end)
number_3f_1 = (function(x)
	return type_23_1(x) == "number" or type_23_1(x) == "table" and x["tag"] == "number"
end)
atom_3f_1 = (function(x)
	return type_23_1(x) ~= "table" or type_23_1(x) == "table" and (x["tag"] == "symbol" or x["tag"] == "key")
end)
between_3f_1 = (function(val, min, max)
	return val >= min and val <= max
end)
type1 = (function(val)
	local ty = type_23_1(val)
	if ty == "table" then
		return val["tag"] or "table"
	else
		return ty
	end
end)
eq_3f_1 = (function(x, y)
	if x == y then
		return true
	else
		local typeX = type1(x)
		local typeY = type1(y)
		if typeX == "list" and (typeY == "list" and n1(x) == n1(y)) then
			local equal = true
			local temp = n1(x)
			local temp1 = 1
			while temp1 <= temp do
				if not eq_3f_1(x[temp1], (y[temp1])) then
					equal = false
				end
				temp1 = temp1 + 1
			end
			return equal
		elseif "table" == type_23_1(x) and getmetatable1(x) then
			return getmetatable1(x)["compare"](x, y)
		elseif "table" == typeX and "table" == typeY then
			local equal = true
			local temp, v = next1(x)
			while temp ~= nil do
				if not eq_3f_1(v, (y[temp])) then
					equal = false
				end
				temp, v = next1(x, temp)
			end
			return equal
		elseif "symbol" == typeX and "symbol" == typeY then
			return x["contents"] == y["contents"]
		elseif "key" == typeX and "key" == typeY then
			return x["value"] == y["value"]
		elseif "symbol" == typeX and "string" == typeY then
			return x["contents"] == y
		elseif "string" == typeX and "symbol" == typeY then
			return x == y["contents"]
		elseif "key" == typeX and "string" == typeY then
			return x["value"] == y
		elseif "string" == typeX and "key" == typeY then
			return x == y["value"]
		else
			return false
		end
	end
end)
abs1 = math.abs
huge1 = math.huge
max1 = math.max
min1 = math.min
modf1 = math.modf
car1 = (function(x)
	local temp = type1(x)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "x", "list", temp), 2)
	end
	return x[1]
end)
cdr1 = (function(x)
	local temp = type1(x)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "x", "list", temp), 2)
	end
	if empty_3f_1(x) then
		return ({tag = "list", n = 0})
	else
		return slice1(x, 2)
	end
end)
reduce1 = (function(f, z, xs)
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
end)
map1 = (function(fn, ...)
	local xss = _pack(...) xss.tag = "list"
	local ns
	local out = ({tag = "list", n = 0})
	local temp = n1(xss)
	local temp1 = 1
	while temp1 <= temp do
		if not (type1((nth1(xss, temp1))) == "list") then
			error1("not a list: " .. pretty1(nth1(xss, temp1)) .. " (it's a " .. type1(nth1(xss, temp1)) .. ")")
		end
		pushCdr_21_1(out, n1(nth1(xss, temp1)))
		temp1 = temp1 + 1
	end
	ns = out
	local out = ({tag = "list", n = 0})
	local temp = min1(unpack1(ns, 1, n1(ns)))
	local temp1 = 1
	while temp1 <= temp do
		pushCdr_21_1(out, (function(xs)
			return fn(unpack1(xs, 1, n1(xs)))
		end)(nths1(xss, temp1)))
		temp1 = temp1 + 1
	end
	return out
end)
filter1 = (function(p, xs)
	local temp = type1(p)
	if temp ~= "function" then
		error1(format1("bad argument %s (expected %s, got %s)", "p", "function", temp), 2)
	end
	local temp = type1(xs)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "xs", "list", temp), 2)
	end
	local out = ({tag = "list", n = 0})
	local temp = n1(xs)
	local temp1 = 1
	while temp1 <= temp do
		local x = nth1(xs, temp1)
		if p(x) then
			pushCdr_21_1(out, x)
		end
		temp1 = temp1 + 1
	end
	return out
end)
any1 = (function(p, xs)
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
end)
elem_3f_1 = (function(x, xs)
	local temp = type1(xs)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "xs", "list", temp), 2)
	end
	return any1((function(y)
		return eq_3f_1(x, y)
	end), xs)
end)
last1 = (function(xs)
	local temp = type1(xs)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "xs", "list", temp), 2)
	end
	return xs[n1(xs)]
end)
nth1 = (function(xs, idx)
	if idx >= 0 then
		return xs[idx]
	else
		return xs[xs["n"] + 1 + idx]
	end
end)
nths1 = (function(xss, idx)
	local out = ({tag = "list", n = 0})
	local temp = n1(xss)
	local temp1 = 1
	while temp1 <= temp do
		pushCdr_21_1(out, nth1(nth1(xss, temp1), idx))
		temp1 = temp1 + 1
	end
	return out
end)
pushCdr_21_1 = (function(xs, val)
	local temp = type1(xs)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "xs", "list", temp), 2)
	end
	local len = n1(xs) + 1
	xs["n"] = len
	xs[len] = val
	return xs
end)
popLast_21_1 = (function(xs)
	local temp = type1(xs)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "xs", "list", temp), 2)
	end
	local x = xs[n1(xs)]
	xs[n1(xs)] = nil
	xs["n"] = n1(xs) - 1
	return x
end)
removeNth_21_1 = (function(li, idx)
	local temp = type1(li)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "li", "list", temp), 2)
	end
	li["n"] = li["n"] - 1
	return remove1(li, idx)
end)
insertNth_21_1 = (function(li, idx, val)
	local temp = type1(li)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "li", "list", temp), 2)
	end
	li["n"] = li["n"] + 1
	return insert1(li, idx, val)
end)
append1 = (function(xs, ys)
	local _offset, _result, _temp = 0, {tag="list",n=0}
	_temp = xs
	for _c = 1, _temp.n do _result[0 + _c + _offset] = _temp[_c] end
	_offset = _offset + _temp.n
	_temp = ys
	for _c = 1, _temp.n do _result[0 + _c + _offset] = _temp[_c] end
	_offset = _offset + _temp.n
	_result.n = _offset + 0
	return _result
end)
cadr1 = (function(xs)
	local temp = type1(xs)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "xs", "list", temp), 2)
	end
	return xs[2]
end)
caar1 = (function(xs)
	local temp = type1(xs)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "xs", "list", temp), 2)
	end
	return xs[1][1]
end)
cadar1 = (function(xs)
	local temp = type1(xs)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "xs", "list", temp), 2)
	end
	return xs[1][2]
end)
split1 = (function(text, pattern, limit)
	local out = ({tag = "list", n = 0})
	local loop = true
	local start = 1
	while loop do
		local pos = list1(find1(text, pattern, start))
		local nstart = car1(pos)
		local nend = cadr1(pos)
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
end)
trim1 = (function(str)
	return (gsub1(gsub1(str, "^%s+", ""), "%s+$", ""))
end)
local escapes = ({})
local temp = 0
while temp <= 31 do
	escapes[char1(temp)] = "\\" .. tostring1(temp)
	temp = temp + 1
end
escapes["\n"] = "n"
quoted1 = (function(str)
	return (gsub1(format1("%q", str), ".", escapes))
end)
assoc1 = (function(list, key, orVal)
	while true do
		if not (type1(list) == "list") or empty_3f_1(list) then
			return orVal
		elseif eq_3f_1(caar1(list), key) then
			return cadar1(list)
		else
			list = cdr1(list)
		end
	end
end)
assoc_3f_1 = (function(list, key)
	while true do
		if not (type1(list) == "list") or empty_3f_1(list) then
			return false
		elseif eq_3f_1(caar1(list), key) then
			return true
		else
			list = cdr1(list)
		end
	end
end)
struct1 = (function(...)
	local entries = _pack(...) entries.tag = "list"
	if n1(entries) % 2 == 1 then
		error1("Expected an even number of arguments to struct", 2)
	end
	local out = ({})
	local temp = n1(entries)
	local temp1 = 1
	while temp1 <= temp do
		local key, val = entries[temp1], entries[1 + temp1]
		out[(function()
			if type1(key) == "key" then
				return key["value"]
			else
				return key
			end
		end)()
		] = val
		temp1 = temp1 + 2
	end
	return out
end)
iterPairs1 = (function(table, func)
	local temp, v = next1(table)
	while temp ~= nil do
		func(temp, v)
		temp, v = next1(table, temp)
	end
	return nil
end)
values1 = (function(st)
	local out = ({tag = "list", n = 0})
	local temp, v = next1(st)
	while temp ~= nil do
		pushCdr_21_1(out, v)
		temp, v = next1(st, temp)
	end
	return out
end)
createLookup1 = (function(values)
	local res = ({})
	local temp = n1(values)
	local temp1 = 1
	while temp1 <= temp do
		res[nth1(values, temp1)] = temp1
		temp1 = temp1 + 1
	end
	return res
end)
clock1 = os.clock
execute1 = os.execute
exit1 = os.exit
getenv1 = os.getenv
invokable_3f_1 = (function(x)
	while true do
		local temp = type1(x) == "function"
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
end)
lens1 = (function(view, over)
	return setmetatable1(({["tag"]="lens",["view"]=view,["over"]=over}), ({["__call"]=(function(t, x)
		return _5e2e_1(x, t)
	end)}))
end)
getter_3f_1 = (function(lens)
	return lens["tag"] == "lens" and type1((lens["view"])) == "function"
end)
setter_3f_1 = (function(lens)
	return lens["tag"] == "lens" and type1((lens["over"])) == "function"
end)
_5e2e_1 = (function(val, lens)
	if getter_3f_1(lens) then
		return lens["view"](val)
	else
		return error1(pretty1(lens) .. " is not a getter")
	end
end)
_5e7e_1 = (function(val, lens, f)
	if setter_3f_1(lens) then
		return lens["over"](f, val)
	else
		return error1(pretty1(lens) .. " is not a setter")
	end
end)
on1 = (function(k)
	return lens1((function(x)
		return x[k]
	end), (function(f, x)
		local out = ({})
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
	end))
end)
on_21_1 = (function(k)
	return lens1((function(x)
		return x[k]
	end), (function(f, x)
		x[k] = f(x[k])
		return x
	end))
end)
flush1 = io.flush
open1 = io.open
read1 = io.read
write1 = io.write
succ1 = (function(x)
	return x + 1
end)
symbol_2d3e_string1 = (function(x)
	if type1(x) == "symbol" then
		return x["contents"]
	else
		return nil
	end
end)
exit_21_1 = (function(reason, code)
	local code1
	if string_3f_1(reason) then
		code1 = code
	else
		code1 = reason
	end
	if string_3f_1(reason) then
		print1(reason)
	end
	return exit1(code1)
end)
id1 = (function(x)
	return x
end)
self1 = (function(x, key, ...)
	local args = _pack(...) args.tag = "list"
	return x[key](x, unpack1(args, 1, n1(args)))
end)
create1 = (function(description)
	return ({["desc"]=description,["flag-map"]=({}),["opt-map"]=({}),["opt"]=({tag = "list", n = 0}),["pos"]=({tag = "list", n = 0})})
end)
setAction1 = (function(arg, data, value)
	data[arg["name"]] = value
	return nil
end)
addAction1 = (function(arg, data, value)
	local lst = data[arg["name"]]
	if lst then
	else
		lst = ({tag = "list", n = 0})
		data[arg["name"]] = lst
	end
	return pushCdr_21_1(lst, value)
end)
setNumAction1 = (function(aspec, data, value, usage_21_)
	local val = tonumber1(value)
	if val then
		data[aspec["name"]] = val
		return nil
	else
		return usage_21_("Expected number for " .. car1(arg1["names"]) .. ", got " .. value)
	end
end)
addArgument_21_1 = (function(spec, names, ...)
	local options = _pack(...) options.tag = "list"
	local temp = type1(names)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "names", "list", temp), 2)
	end
	if empty_3f_1(names) then
		error1("Names list is empty")
	end
	if n1(options) % 2 == 0 then
	else
		error1("Options list should be a multiple of two")
	end
	local result = ({["names"]=names,["action"]=nil,["narg"]=0,["default"]=false,["help"]="",["value"]=true})
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
		result["default"] = ({tag = "list", n = 0})
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
		local key = nth1(options, temp1)
		result[key] = (nth1(options, temp1 + 1))
		temp1 = temp1 + 2
	end
	if result["var"] then
	else
		result["var"] = upper1(result["name"])
	end
	if result["action"] then
	else
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
end)
addHelp_21_1 = (function(spec)
	return addArgument_21_1(spec, ({tag = "list", n = 2, "--help", "-h"}), "help", "Show this help message", "default", nil, "value", nil, "action", (function(arg, result, value)
		help_21_1(spec)
		return exit_21_1(0)
	end))
end)
helpNarg_21_1 = (function(buffer, arg)
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
end)
usage_21_1 = (function(spec, name)
	if name then
	else
		name = nth1(arg1, 0) or (arg1[-1] or "?")
	end
	local usage = list1("usage: ", name)
	local temp = spec["opt"]
	local temp1 = n1(temp)
	local temp2 = 1
	while temp2 <= temp1 do
		local arg = temp[temp2]
		pushCdr_21_1(usage, " [" .. car1(arg["names"]))
		helpNarg_21_1(usage, arg)
		pushCdr_21_1(usage, "]")
		temp2 = temp2 + 1
	end
	local temp = spec["pos"]
	local temp1 = n1(temp)
	local temp2 = 1
	while temp2 <= temp1 do
		helpNarg_21_1(usage, (temp[temp2]))
		temp2 = temp2 + 1
	end
	return print1(concat1(usage))
end)
help_21_1 = (function(spec, name)
	if name then
	else
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
		local arg = temp[temp2]
		local len = n1(arg["var"])
		if len > max then
			max = len
		end
		temp2 = temp2 + 1
	end
	local temp = spec["opt"]
	local temp1 = n1(temp)
	local temp2 = 1
	while temp2 <= temp1 do
		local arg = temp[temp2]
		local len = n1(concat1(arg["names"], ", "))
		if len > max then
			max = len
		end
		temp2 = temp2 + 1
	end
	local fmt = " %-" .. tostring1(max + 1) .. "s %s"
	if empty_3f_1(spec["pos"]) then
	else
		print1()
		print1("Positional arguments")
		local temp = spec["pos"]
		local temp1 = n1(temp)
		local temp2 = 1
		while temp2 <= temp1 do
			local arg = temp[temp2]
			print1(format1(fmt, arg["var"], arg["help"]))
			temp2 = temp2 + 1
		end
	end
	if empty_3f_1(spec["opt"]) then
		return nil
	else
		print1()
		print1("Optional arguments")
		local temp = spec["opt"]
		local temp1 = n1(temp)
		local temp2 = 1
		while temp2 <= temp1 do
			local arg = temp[temp2]
			print1(format1(fmt, concat1(arg["names"], ", "), arg["help"]))
			temp2 = temp2 + 1
		end
		return nil
	end
end)
matcher1 = (function(pattern)
	return (function(x)
		local res = list1(match1(x, pattern))
		if car1(res) == nil then
			return nil
		else
			return res
		end
	end)
end)
parse_21_1 = (function(spec, args)
	if args then
	else
		args = arg1
	end
	local result = ({})
	local pos = spec["pos"]
	local idx = 1
	local len = n1(args)
	local usage_21_ = (function(msg)
		usage_21_1(spec, (nth1(args, 0)))
		print1(msg)
		return exit_21_1(1)
	end)
	local readArgs = (function(key, arg)
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
	end)
	while idx <= len do
		local temp = nth1(args, idx)
		local temp1
		local temp2 = matcher1("^%-%-([^=]+)=(.+)$")(temp)
		temp1 = type1(temp2) == "list" and (n1(temp2) >= 2 and (n1(temp2) <= 2 and true))
		if temp1 then
			local key = nth1(matcher1("^%-%-([^=]+)=(.+)$")(temp), 1)
			local val = nth1(matcher1("^%-%-([^=]+)=(.+)$")(temp), 2)
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
					local flags = nth1(matcher1("^%-(.+)$")(temp), 1)
					local i = 1
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
					local arg = car1(spec["pos"])
					if arg then
						arg["action"](arg, result, temp, usage_21_)
					else
						local msg = "Unknown argument " .. arg
						usage_21_1(spec, (nth1(args, 0)))
						print1(msg)
						exit_21_1(1)
					end
					idx = idx + 1
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
end)
putNodeError_21_1 = (function(logger, msg, node, explain, ...)
	local lines = _pack(...) lines.tag = "list"
	return self1(logger, "put-node-error!", msg, node, explain, lines)
end)
putNodeWarning_21_1 = (function(logger, msg, node, explain, ...)
	local lines = _pack(...) lines.tag = "list"
	return self1(logger, "put-node-warning!", msg, node, explain, lines)
end)
doNodeError_21_1 = (function(logger, msg, node, explain, ...)
	local lines = _pack(...) lines.tag = "list"
	self1(logger, "put-node-error!", msg, node, explain, lines)
	return error1(match1(msg, "^([^\n]+)\n") or msg, 0)
end)
formatRange1 = (function(range)
	if range["finish"] then
		return format1("%s:[%s .. %s]", range["name"], (function(pos)
			return pos["line"] .. ":" .. pos["column"]
		end)(range["start"]), (function(pos)
			return pos["line"] .. ":" .. pos["column"]
		end)(range["finish"]))
	else
		return format1("%s:[%s]", range["name"], (function(pos)
			return pos["line"] .. ":" .. pos["column"]
		end)(range["start"]))
	end
end)
formatNode1 = (function(node)
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
end)
getSource1 = (function(node)
	local result = nil
	while node and not result do
		result = node["range"]
		node = node["parent"]
	end
	return result
end)
create2 = coroutine.create
resume1 = coroutine.resume
status1 = coroutine.status
yield1 = coroutine.yield
child1 = (function(parent)
	return ({["parent"]=parent,["variables"]=({}),["exported"]=({}),["prefix"]=(function()
		if parent then
			return parent["prefix"]
		else
			return ""
		end
	end)()
	})
end)
get1 = (function(scope, name)
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
end)
getAlways_21_1 = (function(scope, name, user)
	return get1(scope, name) or yield1(({["tag"]="define",["name"]=name,["node"]=user,["scope"]=scope}))
end)
kinds1 = ({["defined"]=true,["native"]=true,["macro"]=true,["arg"]=true,["builtin"]=true})
add_21_1 = (function(scope, name, kind, node)
	local temp = type1(name)
	if temp ~= "string" then
		error1(format1("bad argument %s (expected %s, got %s)", "name", "string", temp), 2)
	end
	local temp = type1(kind)
	if temp ~= "string" then
		error1(format1("bad argument %s (expected %s, got %s)", "kind", "string", temp), 2)
	end
	if kinds1[kind] then
	else
		error1("Unknown kind " .. quoted1(kind))
	end
	if scope["variables"][name] then
		error1("Previous declaration of " .. name)
	end
	local var = ({["tag"]=kind,["name"]=name,["full-name"]=scope["prefix"] .. name,["scope"]=scope,["const"]=kind ~= "arg",["node"]=node})
	scope["variables"][name] = var
	scope["exported"][name] = var
	return var
end)
addVerbose_21_1 = (function(scope, name, kind, node, logger)
	local temp = type1(name)
	if temp ~= "string" then
		error1(format1("bad argument %s (expected %s, got %s)", "name", "string", temp), 2)
	end
	local temp = type1(kind)
	if temp ~= "string" then
		error1(format1("bad argument %s (expected %s, got %s)", "kind", "string", temp), 2)
	end
	if kinds1[kind] then
	else
		error1("Unknown kind " .. quoted1(kind))
	end
	local previous = scope["variables"][name]
	if previous then
		doNodeError_21_1(logger, "Previous declaration of " .. name, node, nil, getSource1(node), "new definition here", getSource1(previous["node"]), "old definition here")
	end
	return add_21_1(scope, name, kind, node)
end)
import_21_1 = (function(scope, name, var, export)
	if var then
	else
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
end)
importVerbose_21_1 = (function(scope, name, var, node, export, logger)
	if var then
	else
		error1("var is nil", 0)
	end
	if scope["variables"][name] and scope["variables"][name] ~= var then
		doNodeError_21_1(logger, "Previous declaration of " .. name, node, nil, getSource1(node), "imported here", getSource1(var["node"]), "new definition here", getSource1(scope["variables"][name]["node"]), "old definition here")
	end
	return import_21_1(scope, name, var, export)
end)
local scope = child1()
scope["builtin"] = true
rootScope1 = scope
builtins1 = ({})
builtinVars1 = ({})
local temp = ({tag = "list", n = 12, "define", "define-macro", "define-native", "lambda", "set!", "cond", "import", "struct-literal", "quote", "syntax-quote", "unquote", "unquote-splice"})
local temp1 = n1(temp)
local temp2 = 1
while temp2 <= temp1 do
	local symbol = temp[temp2]
	local var = add_21_1(rootScope1, symbol, "builtin", nil)
	import_21_1(rootScope1, "builtin/" .. symbol, var, true)
	builtins1[symbol] = var
	temp2 = temp2 + 1
end
local temp = ({tag = "list", n = 3, "nil", "true", "false"})
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
builtin_3f_1 = (function(node, name)
	return type1(node) == "symbol" and node["var"] == builtins1[name]
end)
sideEffect_3f_1 = (function(node)
	local tag = type1(node)
	if tag == "number" or (tag == "string" or (tag == "key" or tag == "symbol")) then
		return false
	elseif tag == "list" then
		local fst = car1(node)
		if type1(fst) == "symbol" then
			local var = fst["var"]
			return var ~= builtins1["lambda"] and var ~= builtins1["quote"]
		else
			return true
		end
	else
		_error("unmatched item")
	end
end)
constant_3f_1 = (function(node)
	return string_3f_1(node) or (number_3f_1(node) or type1(node) == "key")
end)
urn_2d3e_val1 = (function(node)
	if string_3f_1(node) then
		return node["value"]
	elseif number_3f_1(node) then
		return node["value"]
	elseif type1(node) == "key" then
		return node["value"]
	else
		_error("unmatched item")
	end
end)
val_2d3e_urn1 = (function(val)
	if type_23_1(val) == "string" then
		return ({["tag"]="string",["value"]=val})
	elseif type_23_1(val) == "number" then
		return ({["tag"]="number",["value"]=val})
	elseif type_23_1(val) == "nil" then
		return ({["tag"]="symbol",["contents"]="nil",["var"]=builtins1["nil"]})
	elseif type_23_1(val) == "boolean" then
		return ({["tag"]="symbol",["contents"]=tostring1(val),["var"]=builtins1[tostring1(val)]})
	else
		return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(type_23_1(val)) .. ", but none matched.\n" .. "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"nil\"`\n  Tried: `\"boolean\"`")
	end
end)
urn_2d3e_bool1 = (function(node)
	if string_3f_1(node) or (type1(node) == "key" or number_3f_1(node)) then
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
end)
makeProgn1 = (function(body)
	return ({tag = "list", n = 1, (function()
		local _offset, _result, _temp = 0, {tag="list",n=0}
		_result[1 + _offset] = (function(var)
			return ({["tag"]="symbol",["contents"]=var["name"],["var"]=var})
		end)(builtins1["lambda"])
		_result[2 + _offset] = ({tag = "list", n = 0})
		_temp = body
		for _c = 1, _temp.n do _result[2 + _c + _offset] = _temp[_c] end
		_offset = _offset + _temp.n
		_result.n = _offset + 2
		return _result
	end)()
	})
end)
makeSymbol1 = (function(var)
	return ({["tag"]="symbol",["contents"]=var["name"],["var"]=var})
end)
symbol_2d3e_var1 = (function(state, symb)
	local var = symb["var"]
	if string_3f_1(var) then
		return state["variables"][var]
	else
		return var
	end
end)
local temp = builtins1["nil"]
makeNil1 = (function()
	return ({["tag"]="symbol",["contents"]=temp["name"],["var"]=temp})
end)
fastAll1 = (function(fn, li, i)
	while true do
		if i > n1(li) then
			return true
		elseif fn(nth1(li, i)) then
			i = i + 1
		else
			return false
		end
	end
end)
fastAny1 = (function(fn, li, i)
	while true do
		if i > n1(li) then
			return false
		elseif fn(nth1(li, i)) then
			return true
		else
			i = i + 1
		end
	end
end)
startTimer_21_1 = (function(timer, name, level)
	local instance = timer["timers"][name]
	if instance then
	else
		instance = ({["name"]=name,["level"]=level or 1,["running"]=false,["total"]=0})
		timer["timers"][name] = instance
	end
	if instance["running"] then
		error1("Timer " .. name .. " is already running")
	end
	instance["running"] = true
	instance["start"] = clock1()
	return nil
end)
pauseTimer_21_1 = (function(timer, name)
	local instance = timer["timers"][name]
	if instance then
	else
		error1("Timer " .. name .. " does not exist")
	end
	if instance["running"] then
	else
		error1("Timer " .. name .. " is not running")
	end
	instance["running"] = false
	instance["total"] = (clock1() - instance["start"]) + instance["total"]
	return nil
end)
stopTimer_21_1 = (function(timer, name)
	local instance = timer["timers"][name]
	if instance then
	else
		error1("Timer " .. name .. " does not exist")
	end
	if instance["running"] then
	else
		error1("Timer " .. name .. " is not running")
	end
	timer["timers"][name] = nil
	instance["total"] = (clock1() - instance["start"]) + instance["total"]
	return timer["callback"](instance["name"], instance["total"], instance["level"])
end)
void1 = ({["callback"]=(function()
	return nil
end),["timers"]=({})})
passEnabled_3f_1 = (function(pass, options)
	local override = options["override"]
	if override[pass["name"]] == true then
		return true
	elseif override[pass["name"]] == false then
		return false
	elseif any1((function(cat)
		return override[cat] == true
	end), pass["cat"]) then
		return true
	elseif any1((function(cat)
		return override[cat] == false
	end), pass["cat"]) then
		return false
	else
		return pass["on"] ~= false and options["level"] >= (pass["level"] or 1)
	end
end)
runPass1 = (function(pass, options, tracker, ...)
	local args = _pack(...) args.tag = "list"
	if passEnabled_3f_1(pass, options) then
		local ptracker, name = ({["changed"]=false}), "[" .. concat1(pass["cat"], " ") .. "] " .. pass["name"]
		startTimer_21_1(options["timer"], name, 2)
		pass["run"](ptracker, options, unpack1(args, 1, n1(args)))
		stopTimer_21_1(options["timer"], name)
		if ptracker["changed"] then
			if options["track"] then
				self1(options["logger"], "put-verbose!", (name .. " did something."))
			end
			if tracker then
				tracker["changed"] = true
			end
		end
		return ptracker["changed"]
	else
		return nil
	end
end)
traverseQuote1 = (function(node, visitor, level)
	if level == 0 then
		return traverseNode1(node, visitor)
	else
		local tag = node["tag"]
		if tag == "string" or (tag == "number" or (tag == "key" or tag == "symbol")) then
			return node
		elseif tag == "list" then
			local first = nth1(node, 1)
			if first and first["tag"] == "symbol" then
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
end)
traverseNode1 = (function(node, visitor)
	local tag = node["tag"]
	if tag == "string" or (tag == "number" or (tag == "key" or tag == "symbol")) then
		return visitor(node, visitor)
	elseif tag == "list" then
		local first = car1(node)
		first = visitor(first, visitor)
		node[1] = first
		if first["tag"] == "symbol" then
			local func = first["var"]
			local funct = func["tag"]
			if funct == "defined" or (funct == "arg" or (funct == "native" or funct == "macro")) then
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
end)
traverseBlock1 = (function(node, start, visitor)
	local temp = n1(node)
	local temp1 = start
	while temp1 <= temp do
		node[temp1] = (traverseNode1(nth1(node, temp1 + 0), visitor))
		temp1 = temp1 + 1
	end
	return node
end)
traverseList1 = (function(node, start, visitor)
	local temp = n1(node)
	local temp1 = start
	while temp1 <= temp do
		node[temp1] = traverseNode1(nth1(node, temp1), visitor)
		temp1 = temp1 + 1
	end
	return node
end)
visitQuote1 = (function(node, visitor, level)
	while true do
		if level == 0 then
			return visitNode1(node, visitor)
		else
			local tag = node["tag"]
			if tag == "string" or (tag == "number" or (tag == "key" or tag == "symbol")) then
				return nil
			elseif tag == "list" then
				local first = nth1(node, 1)
				if first and first["tag"] == "symbol" then
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
end)
visitNode1 = (function(node, visitor)
	while true do
		if visitor(node, visitor) == false then
			return nil
		else
			local tag = node["tag"]
			if tag == "string" or (tag == "number" or (tag == "key" or tag == "symbol")) then
				return nil
			elseif tag == "list" then
				local first = nth1(node, 1)
				if first["tag"] == "symbol" then
					local func = first["var"]
					local funct = func["tag"]
					if funct == "defined" or (funct == "arg" or (funct == "native" or funct == "macro")) then
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
end)
visitBlock1 = (function(node, start, visitor)
	local temp = n1(node)
	local temp1 = start
	while temp1 <= temp do
		visitNode1(nth1(node, temp1), visitor)
		temp1 = temp1 + 1
	end
	return nil
end)
visitBlocks1 = (function(nodes, func)
	func(nodes, 1)
	return visitBlock1(nodes, 1, (function(node)
		if type1(node) == "list" then
			local head = car1(node)
			if type1(head) == "symbol" then
				local var = head["var"]
				if var == builtins1["lambda"] then
					func(node, 3)
				elseif var == builtins1["cond"] then
					local temp = n1(node)
					local temp1 = 2
					while temp1 <= temp do
						func(nth1(node, temp1), 2)
						temp1 = temp1 + 1
					end
				end
			end
		end
		return nil
	end))
end)
getVar1 = (function(state, var)
	local entry = state["vars"][var]
	if entry then
	else
		entry = ({["var"]=var,["usages"]=({tag = "list", n = 0}),["defs"]=({tag = "list", n = 0}),["active"]=false})
		state["vars"][var] = entry
	end
	return entry
end)
addUsage_21_1 = (function(state, var, node)
	local varMeta = getVar1(state, var)
	pushCdr_21_1(varMeta["usages"], node)
	varMeta["active"] = true
	return nil
end)
addDefinition_21_1 = (function(state, var, node, kind, value)
	return pushCdr_21_1(getVar1(state, var)["defs"], ({["tag"]=kind,["node"]=node,["value"]=value}))
end)
definitionsVisitor1 = (function(state, node, visitor)
	if type1(node) == "list" and type1((car1(node))) == "symbol" then
		local func = car1(node)["var"]
		if func == builtins1["lambda"] then
			local temp = nth1(node, 2)
			local temp1 = n1(temp)
			local temp2 = 1
			while temp2 <= temp1 do
				local arg = temp[temp2]
				addDefinition_21_1(state, arg["var"], arg, "var", arg["var"])
				temp2 = temp2 + 1
			end
			return nil
		elseif func == builtins1["set!"] then
			return addDefinition_21_1(state, node[2]["var"], node, "val", nth1(node, 3))
		elseif func == builtins1["define"] or func == builtins1["define-macro"] then
			return addDefinition_21_1(state, node["def-var"], node, "val", nth1(node, n1(node)))
		elseif func == builtins1["define-native"] then
			return addDefinition_21_1(state, node["def-var"], node, "var", node["def-var"])
		else
			return nil
		end
	elseif type1(node) == "list" and (type1((car1(node))) == "list" and (type1((caar1(node))) == "symbol" and caar1(node)["var"] == builtins1["lambda"])) then
		local lam = car1(node)
		local args = nth1(lam, 2)
		local offset = 1
		local i = 1
		local argLen = n1(args)
		while i <= argLen do
			local arg, val = nth1(args, i), nth1(node, i + offset)
			if arg["var"]["is-variadic"] then
				local count = n1(node) - n1(args)
				if count < 0 then
					count = 0
				end
				offset = count
				addDefinition_21_1(state, arg["var"], arg, "var", arg["var"])
			elseif i + offset == n1(node) and (i < argLen and type1(val) == "list") then
				local temp = i
				while temp <= argLen do
					local arg2 = nth1(args, temp)
					addDefinition_21_1(state, arg2["var"], arg2, "var", arg2)
					temp = temp + 1
				end
				i = argLen
			else
				addDefinition_21_1(state, arg["var"], arg, "val", val or ({["tag"]="symbol",["contents"]="nil",["var"]=builtins1["nil"]}))
			end
			i = i + 1
		end
		visitBlock1(node, 2, visitor)
		visitBlock1(lam, 3, visitor)
		return false
	else
		return nil
	end
end)
definitionsVisit1 = (function(state, nodes)
	return visitBlock1(nodes, 1, (function(temp, temp1)
		return definitionsVisitor1(state, temp, temp1)
	end))
end)
usagesVisit1 = (function(state, nodes, pred)
	if pred then
	else
		pred = (function()
			return true
		end)
	end
	local queue = ({tag = "list", n = 0})
	local visited = ({})
	local addUsage = (function(var, user)
		local varMeta = getVar1(state, var)
		if varMeta["active"] then
		else
			local temp = varMeta["defs"]
			local temp1 = n1(temp)
			local temp2 = 1
			while temp2 <= temp1 do
				local def = temp[temp2]
				local val = def["value"]
				if def["tag"] == "val" and not visited[val] then
					pushCdr_21_1(queue, val)
				end
				temp2 = temp2 + 1
			end
		end
		return addUsage_21_1(state, var, user)
	end)
	local visit = (function(node)
		if visited[node] then
			return false
		else
			visited[node] = true
			if type1(node) == "symbol" then
				addUsage(node["var"], node)
				return true
			elseif type1(node) == "list" and (n1(node) > 0 and type1((car1(node))) == "symbol") then
				local func = car1(node)["var"]
				if func == builtins1["set!"] or (func == builtins1["define"] or func == builtins1["define-macro"]) then
					if pred(nth1(node, 3)) then
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
	local temp = n1(nodes)
	local temp1 = 1
	while temp1 <= temp do
		pushCdr_21_1(queue, (nodes[temp1]))
		temp1 = temp1 + 1
	end
	while n1(queue) > 0 do
		visitNode1(popLast_21_1(queue), visit)
	end
	return nil
end)
tagUsage1 = ({["name"]="tag-usage",["help"]="Gathers usage and definition data for all expressions in NODES, storing it in LOOKUP.",["cat"]=({tag = "list", n = 2, "tag", "usage"}),["run"]=(function(temp, state, nodes, lookup)
	definitionsVisit1(lookup, nodes)
	return usagesVisit1(lookup, nodes, sideEffect_3f_1)
end)})
fusionPatterns1 = ({tag = "list", n = 0})
metavar_3f_1 = (function(x)
	return x["var"] == nil and sub1(symbol_2d3e_string1(x), 1, 1) == "?"
end)
genvar_3f_1 = (function(x)
	return x["var"] == nil and sub1(symbol_2d3e_string1(x), 1, 1) == "%"
end)
peq_3f_1 = (function(x, y, out)
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
end)
substitute1 = (function(x, subs, syms)
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
			if sym then
			else
				sym = gensym1()
				sym["var"] = ({["tag"]="arg",["name"]=symbol_2d3e_string1(sym)})
				syms[name] = sym
			end
			return sym
		else
			local var = x["var"]
			return ({["tag"]="symbol",["contents"]=var["name"],["var"]=var})
		end
	elseif temp == "list" then
		return map1((function(temp1)
			return substitute1(temp1, subs, syms)
		end), x)
	else
		return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"key\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`")
	end
end)
fixPattern_21_1 = (function(state, ptrn)
	local temp = type1(ptrn)
	if temp == "string" then
		return ptrn
	elseif temp == "number" then
		return ptrn
	elseif temp == "symbol" then
		if ptrn["var"] then
			local var = symbol_2d3e_var1(state, ptrn)
			return ({["tag"]="symbol",["contents"]=var["name"],["var"]=var})
		else
			return ptrn
		end
	elseif temp == "list" then
		return map1((function(temp1)
			return fixPattern_21_1(state, temp1)
		end), ptrn)
	else
		return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`")
	end
end)
fixRule_21_1 = (function(state, rule)
	return ({["from"]=fixPattern_21_1(state, rule["from"]),["to"]=fixPattern_21_1(state, rule["to"])})
end)
fusion1 = ({["name"]="fusion",["help"]="Merges various loops together as specified by a pattern.",["cat"]=({tag = "list", n = 1, "opt"}),["on"]=false,["run"]=(function(temp, state, nodes)
	local patterns = map1((function(temp1)
		return fixRule_21_1(state["compiler"], temp1)
	end), fusionPatterns1)
	return traverseBlock1(nodes, 1, (function(node)
		if type1(node) == "list" then
			local temp1 = n1(patterns)
			local temp2 = 1
			while temp2 <= temp1 do
				local ptrn = patterns[temp2]
				local subs = ({})
				if peq_3f_1(ptrn["from"], node, subs) then
					temp["changed"] = true
					node = substitute1(ptrn["to"], subs, ({}))
				end
				temp2 = temp2 + 1
			end
		end
		return node
	end))
end)})
addRule_21_1 = (function(rule)
	local temp = type1(rule)
	if temp ~= "table" then
		error1(format1("bad argument %s (expected %s, got %s)", "rule", "table", temp), 2)
	end
	pushCdr_21_1(fusionPatterns1, rule)
	return nil
end)
stripImport1 = ({["name"]="strip-import",["help"]="Strip all import expressions in NODES",["cat"]=({tag = "list", n = 1, "opt"}),["run"]=(function(temp, state, nodes)
	return visitBlocks1(nodes, (function(nodes1, start)
		local temp1 = n1(nodes1)
		while temp1 >= start do
			local node = nth1(nodes1, temp1)
			if type1(node) == "list" and builtin_3f_1(car1(node), "import") then
				if temp1 == n1(nodes1) then
					nodes1[temp1] = makeNil1()
				else
					removeNth_21_1(nodes1, temp1)
				end
				temp["changed"] = true
			end
			temp1 = temp1 + -1
		end
		return nil
	end))
end)})
stripPure1 = ({["name"]="strip-pure",["help"]="Strip all pure expressions in NODES (apart from the last one).",["cat"]=({tag = "list", n = 1, "opt"}),["run"]=(function(temp, state, nodes)
	return visitBlocks1(nodes, (function(nodes1, start)
		local temp1 = n1(nodes1) - 1
		while temp1 >= start do
			if sideEffect_3f_1((nth1(nodes1, temp1))) then
			else
				removeNth_21_1(nodes1, temp1)
				temp["changed"] = true
			end
			temp1 = temp1 + -1
		end
		return nil
	end))
end)})
constantFold1 = ({["name"]="constant-fold",["help"]="A primitive constant folder\n\nThis simply finds function calls with constant functions and looks up the function.\nIf the function is native and pure then we'll execute it and replace the node with the\nresult. There are a couple of caveats:\n\n - If the function call errors then we will flag a warning and continue.\n - If this returns a decimal (or infinity or NaN) then we'll continue: we cannot correctly\n   accurately handle this.\n - If this doesn't return exactly one value then we will stop. This might be a future enhancement.",["cat"]=({tag = "list", n = 1, "opt"}),["run"]=(function(temp, state, nodes)
	return traverseList1(nodes, 1, (function(node)
		if type1(node) == "list" and fastAll1(constant_3f_1, node, 2) then
			local head = car1(node)
			local meta = type1(head) == "symbol" and (not head["folded"] and (head["var"]["tag"] == "native" and state["meta"][head["var"]["full-name"]]))
			if meta and (meta["pure"] and meta["value"]) then
				local res = list1(pcall1(meta["value"], unpack1(map1(urn_2d3e_val1, cdr1(node)), 1, n1(node) - 1)))
				if car1(res) then
					local val = nth1(res, 2)
					if n1(res) ~= 2 or number_3f_1(val) and (cadr1(list1(modf1(val))) ~= 0 or abs1(val) == huge1) then
						head["folded"] = true
						return node
					else
						temp["changed"] = true
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
	end))
end)})
condFold1 = ({["name"]="cond-fold",["help"]="Simplify all `cond` nodes, removing `false` branches and killing\nall branches after a `true` one.",["cat"]=({tag = "list", n = 1, "opt"}),["run"]=(function(temp, state, nodes)
	return traverseList1(nodes, 1, (function(node)
		if type1(node) == "list" and (type1((car1(node))) == "symbol" and car1(node)["var"] == builtins1["cond"]) then
			local final = false
			local i = 2
			while i <= n1(node) do
				local elem = nth1(node, i)
				if final then
					temp["changed"] = true
					removeNth_21_1(node, i)
				else
					local temp1 = urn_2d3e_bool1(car1(elem))
					if eq_3f_1(temp1, false) then
						temp["changed"] = true
						removeNth_21_1(node, i)
					elseif eq_3f_1(temp1, true) then
						final = true
						i = i + 1
					elseif eq_3f_1(temp1, nil) then
						i = i + 1
					else
						error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp1) .. ", but none matched.\n" .. "  Tried: `false`\n  Tried: `true`\n  Tried: `nil`")
					end
				end
			end
			if n1(node) == 2 and urn_2d3e_bool1(car1(nth1(node, 2))) == true then
				temp["changed"] = true
				local body = cdr1(nth1(node, 2))
				if n1(body) == 1 then
					return car1(body)
				else
					return makeProgn1(cdr1(nth1(node, 2)))
				end
			else
				return node
			end
		else
			return node
		end
	end))
end)})
lambdaFold1 = ({["name"]="lambda-fold",["help"]="Simplify all directly called lambdas without arguments, inlining them\nwere appropriate.",["cat"]=({tag = "list", n = 1, "opt"}),["run"]=(function(temp, state, nodes)
	traverseList1(nodes, 1, (function(node)
		if type1(node) == "list" and (n1(node) == 1 and (type1((car1(node))) == "list" and (builtin_3f_1(caar1(node), "lambda") and (n1(car1(node)) == 3 and empty_3f_1(nth1(car1(node), 2)))))) then
			temp["changed"] = true
			return nth1(car1(node), 3)
		else
			return node
		end
	end))
	return visitBlocks1(nodes, (function(nodes1, start)
		local i, len = start, n1(nodes1)
		while i <= len do
			local node = nth1(nodes1, i)
			if type1(node) == "list" and (n1(node) == 1 and (type1((car1(node))) == "list" and (builtin_3f_1(car1(car1(node)), "lambda") and empty_3f_1(nth1(car1(node), 2))))) then
				local body = car1(node)
				if n1(body) == 2 then
					removeNth_21_1(nodes1, i)
				else
					nodes1[i] = nth1(body, 3)
					local temp1 = n1(body)
					local temp2 = 4
					while temp2 <= temp1 do
						insertNth_21_1(nodes1, i + (temp2 - 3), nth1(body, temp2))
						temp2 = temp2 + 1
					end
				end
				len = len + (n1(node) - 1)
			else
				i = i + 1
			end
		end
		return nil
	end))
end)})
stripDefsFast1 = (function(nodes)
	local defs = ({})
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
	local visited = ({})
	local queue = ({tag = "list", n = 0})
	local visitor = (function(node)
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
	end)
	local temp = n1(nodes)
	local temp1 = 1
	while temp1 <= temp do
		local node = nodes[temp1]
		if node["def-var"] then
		else
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
end)
getConstantVal1 = (function(lookup, sym)
	local var = sym["var"]
	local def = getVar1(lookup, sym["var"])
	if var == builtins1["true"] then
		return sym
	elseif var == builtins1["false"] then
		return sym
	elseif var == builtins1["nil"] then
		return sym
	elseif n1(def["defs"]) == 1 then
		local ent = car1(def["defs"])
		local val = ent["value"]
		local ty = ent["tag"]
		if string_3f_1(val) or (number_3f_1(val) or type1(val) == "key") then
			return val
		elseif type1(val) == "symbol" and ty == "val" then
			return getConstantVal1(lookup, val) or sym
		else
			return sym
		end
	else
		return nil
	end
end)
stripDefs1 = ({["name"]="strip-defs",["help"]="Strip all unused top level definitions.",["cat"]=({tag = "list", n = 2, "opt", "usage"}),["run"]=(function(temp, state, nodes, lookup)
	local temp1 = n1(nodes)
	while temp1 >= 1 do
		local node = nth1(nodes, temp1)
		if node["def-var"] and not getVar1(lookup, node["def-var"])["active"] then
			if temp1 == n1(nodes) then
				nodes[temp1] = makeNil1()
			else
				removeNth_21_1(nodes, temp1)
			end
			temp["changed"] = true
		end
		temp1 = temp1 + -1
	end
	return nil
end)})
stripArgs1 = ({["name"]="strip-args",["help"]="Strip all unused, pure arguments in directly called lambdas.",["cat"]=({tag = "list", n = 2, "opt", "usage"}),["run"]=(function(temp, state, nodes, lookup)
	return visitBlock1(nodes, 1, (function(node)
		if type1(node) == "list" and (type1((car1(node))) == "list" and (type1((caar1(node))) == "symbol" and caar1(node)["var"] == builtins1["lambda"])) then
			local lam = car1(node)
			local args = nth1(lam, 2)
			local offset = 1
			local remOffset = 0
			local removed = ({})
			local temp1 = n1(args)
			local temp2 = 1
			while temp2 <= temp1 do
				local arg, val = nth1(args, temp2 - remOffset), nth1(node, (temp2 + offset) - remOffset)
				if arg["var"]["is-variadic"] then
					local count = n1(node) - n1(args)
					if count < 0 then
						count = 0
					end
					offset = count
				elseif nil == val then
				elseif sideEffect_3f_1(val) then
				elseif n1(getVar1(lookup, arg["var"])["usages"]) > 0 then
				else
					temp["changed"] = true
					removed[nth1(args, temp2 - remOffset)["var"]] = true
					removeNth_21_1(args, temp2 - remOffset)
					removeNth_21_1(node, (temp2 + offset) - remOffset)
					remOffset = remOffset + 1
				end
				temp2 = temp2 + 1
			end
			if remOffset > 0 then
				return traverseList1(lam, 3, (function(node1)
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
				end))
			else
				return nil
			end
		else
			return nil
		end
	end))
end)})
variableFold1 = ({["name"]="variable-fold",["help"]="Folds constant variable accesses",["cat"]=({tag = "list", n = 2, "opt", "usage"}),["run"]=(function(temp, state, nodes, lookup)
	return traverseList1(nodes, 1, (function(node)
		if type1(node) == "symbol" then
			local var = getConstantVal1(lookup, node)
			if var and var ~= node then
				temp["changed"] = true
				return var
			else
				return node
			end
		else
			return node
		end
	end))
end)})
expressionFold1 = ({["name"]="expression-fold",["help"]="Folds basic variable accesses where execution order will not change.\n\nFor instance, converts ((lambda (x) (+ x 1)) (Y)) to (+ Y 1) in the case\nwhere Y is an arbitrary expression.\n\nThere are a couple of complexities in the implementation here. Firstly, we\nwant to ensure that the arguments are executed in the correct order and only\nonce.\n\nIn order to achieve this, we find the lambda forms and visit the body, stopping\nif we visit arguments in the wrong order or non-constant terms such as mutable\nvariables or other function calls. For simplicities sake, we fail if we hit\nother lambdas or conds as that makes analysing control flow significantly more\ncomplex.\n\nAnother source of added complexity is the case where where Y could return multiple\nvalues: namely in the last argument to function calls. Here it is an invalid optimisation\nto just place Y, as that could result in additional values being passed to the function.\n\nIn order to avoid this, Y will get converted to the form ((lambda (<tmp>) <tmp>) Y).\nThis is understood by the codegen and so is not as inefficient as it looks. However, we do\nhave to take additional steps to avoid trying to fold the above again and again.",["cat"]=({tag = "list", n = 2, "opt", "usage"}),["run"]=(function(temp, state, nodes, lookup)
	return visitBlock1(nodes, 1, (function(root)
		if type1(root) == "list" and (type1((car1(root))) == "list" and (type1((caar1(root))) == "symbol" and caar1(root)["var"] == builtins1["lambda"])) then
			local lam, args, len, validate
			lam = car1(root)
			args = nth1(lam, 2)
			len = n1(args)
			validate = (function(i)
				while true do
					if i > len then
						return true
					else
						local arg = nth1(args, i)
						local var = arg["var"]
						local entry = getVar1(lookup, var)
						if var["is-variadic"] then
							return false
						elseif n1(entry["defs"]) ~= 1 then
							return false
						elseif car1(entry["defs"])["tag"] == "var" then
							return false
						elseif n1(entry["usages"]) ~= 1 then
							return false
						else
							i = i + 1
						end
					end
				end
			end)
			if len > 0 and ((n1(root) ~= 2 or (len ~= 1 or (n1(lam) ~= 3 or (atom_3f_1(nth1(root, 2)) or (not (type1((nth1(lam, 3))) == "symbol") or nth1(lam, 3)["var"] ~= car1(args)["var"]))))) and validate(1)) then
				local currentIdx, argMap, wrapMap, ok, finished = 1, ({}), ({}), true, false
				local temp1 = n1(args)
				local temp2 = 1
				while temp2 <= temp1 do
					argMap[nth1(args, temp2)["var"]] = temp2
					temp2 = temp2 + 1
				end
				visitBlock1(lam, 3, (function(node, visitor)
					if ok then
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
							if type1(head) == "symbol" then
								local var = head["var"]
								if var["tag"] ~= "builtin" then
									visitBlock1(node, 1, visitor)
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
									visitBlock1(node, 1, visitor)
								end
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
				end))
				if ok and finished then
					temp["changed"] = true
					traverseList1(root, 1, (function(child)
						if type1(child) == "symbol" then
							local var = child["var"]
							local i = argMap[var]
							if i then
								if wrapMap[i] then
									return ({tag = "list", n = 2, ({tag = "list", n = 3, (function(var1)
										return ({["tag"]="symbol",["contents"]=var1["name"],["var"]=var1})
									end)(builtins1["lambda"]), ({tag = "list", n = 1, ({["tag"]="symbol",["contents"]=var["name"],["var"]=var})}), ({["tag"]="symbol",["contents"]=var["name"],["var"]=var})}), nth1(root, i + 1)})
								else
									return nth1(root, i + 1) or makeNil1()
								end
							else
								return child
							end
						else
							return child
						end
					end))
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
		else
			return nil
		end
	end))
end)})
condEliminate1 = ({["name"]="cond-eliminate",["help"]="Replace variables with known truthy/falsey values with `true` or `false` when used in branches.",["cat"]=({tag = "list", n = 2, "opt", "usage"}),["run"]=(function(temp, state, nodes, varLookup)
	local lookup = ({})
	return visitBlock1(nodes, 1, (function(node, visitor, isCond)
		local temp1 = type1(node)
		if temp1 == "symbol" then
			if isCond then
				local temp2 = lookup[node["var"]]
				if eq_3f_1(temp2, false) then
					local var = builtins1["false"]
					return ({["tag"]="symbol",["contents"]=var["name"],["var"]=var})
				elseif eq_3f_1(temp2, true) then
					local var = builtins1["true"]
					return ({["tag"]="symbol",["contents"]=var["name"],["var"]=var})
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
					local vars = ({tag = "list", n = 0})
					local temp3 = n1(node)
					local temp4 = 2
					while temp4 <= temp3 do
						local entry = nth1(node, temp4)
						local test = car1(entry)
						local len = n1(entry)
						local var = type1(test) == "symbol" and test["var"]
						if var then
							if lookup[var] ~= nil then
								var = nil
							elseif n1(getVar1(varLookup, var)["defs"]) > 1 then
								var = nil
							end
						end
						local temp5 = visitor(test, visitor, true)
						if eq_3f_1(temp5, nil) then
							visitNode1(test, visitor)
						elseif eq_3f_1(temp5, false) then
						else
							temp["changed"] = true
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
							if eq_3f_1(temp5, nil) then
								visitNode1(last, visitor)
							elseif eq_3f_1(temp5, false) then
							else
								temp["changed"] = true
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
						if eq_3f_1(temp3, nil) then
							visitNode1(last, visitor)
						elseif eq_3f_1(temp3, false) then
						else
							temp["changed"] = true
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
	end))
end)})
copyOf1 = (function(x)
	local res = ({})
	local temp, v = next1(x)
	while temp ~= nil do
		res[temp] = v
		temp, v = next1(x, temp)
	end
	return res
end)
getScope1 = (function(scope, lookup, n)
	local newScope = lookup["scopes"][scope]
	if newScope then
		return newScope
	else
		local newScope1 = child1()
		lookup["scopes"][scope] = newScope1
		return newScope1
	end
end)
getVar2 = (function(var, lookup)
	return lookup["vars"][var] or var
end)
copyNode1 = (function(node, lookup)
	local temp = type1(node)
	if temp == "string" then
		return copyOf1(node)
	elseif temp == "key" then
		return copyOf1(node)
	elseif temp == "number" then
		return copyOf1(node)
	elseif temp == "symbol" then
		local copy = copyOf1(node)
		local oldVar = node["var"]
		local newVar = getVar2(oldVar, lookup)
		if oldVar ~= newVar and oldVar["node"] == node then
			newVar["node"] = copy
		end
		copy["var"] = newVar
		return copy
	elseif temp == "list" then
		if builtin_3f_1(car1(node), "lambda") then
			local args = cadr1(node)
			if empty_3f_1(args) then
			else
				local newScope = child1(getScope1(car1(args)["var"]["scope"], lookup, node))
				local temp1 = n1(args)
				local temp2 = 1
				while temp2 <= temp1 do
					local arg = args[temp2]
					local var = arg["var"]
					local newVar = add_21_1(newScope, var["name"], var["tag"], nil)
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
end)
scoreNode1 = (function(node)
	local temp = type1(node)
	if temp == "string" then
		return 0
	elseif temp == "key" then
		return 0
	elseif temp == "number" then
		return 0
	elseif temp == "symbol" then
		return 1
	elseif temp == "list" then
		if type1(car1(node)) == "symbol" then
			local func = car1(node)["var"]
			if func == builtins1["lambda"] then
				return scoreNodes1(node, 3, 10)
			elseif func == builtins1["cond"] then
				return scoreNodes1(node, 2, 10)
			elseif func == builtins1["set!"] then
				return scoreNodes1(node, 2, 5)
			elseif func == builtins1["quote"] then
				return scoreNodes1(node, 2, 2)
			elseif func == builtins1["quasi-quote"] then
				return scoreNodes1(node, 2, 3)
			elseif func == builtins1["unquote-splice"] then
				return scoreNodes1(node, 2, 10)
			else
				return scoreNodes1(node, 1, n1(node) + 1)
			end
		else
			return scoreNodes1(node, 1, n1(node) + 1)
		end
	else
		return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"string\"`\n  Tried: `\"key\"`\n  Tried: `\"number\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`")
	end
end)
getScore1 = (function(lookup, node)
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
			score = scoreNodes1(node, 3, score)
		end
		lookup[node] = score
	end
	return score or huge1
end)
scoreNodes1 = (function(nodes, start, sum)
	while true do
		if start > n1(nodes) then
			return sum
		else
			local score = scoreNode1(nth1(nodes, start))
			if score then
				if score > 20 then
					return score
				else
					start, sum = start + 1, sum + score
				end
			else
				return false
			end
		end
	end
end)
inline1 = ({["name"]="inline",["help"]="Inline simple functions.",["cat"]=({tag = "list", n = 2, "opt", "usage"}),["level"]=2,["run"]=(function(temp, state, nodes, usage)
	local scoreLookup = ({})
	return visitBlock1(nodes, 1, (function(node)
		if type1(node) == "list" and type1((car1(node))) == "symbol" then
			local func = car1(node)["var"]
			local def = getVar1(usage, func)
			if n1(def["defs"]) == 1 then
				local ent = car1(def["defs"])
				local val = ent["value"]
				if type1(val) == "list" and (builtin_3f_1(car1(val), "lambda") and getScore1(scoreLookup, val) <= 20) then
					node[1] = (copyNode1(val, ({["scopes"]=({}),["vars"]=({}),["root"]=func["scope"]})))
					temp["changed"] = true
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
optimiseOnce1 = (function(nodes, state)
	local tracker = ({["changed"]=false})
	local temp = state["pass"]["normal"]
	local temp1 = n1(temp)
	local temp2 = 1
	while temp2 <= temp1 do
		runPass1(temp[temp2], state, tracker, nodes)
		temp2 = temp2 + 1
	end
	local lookup = ({["vars"]=({}),["nodes"]=({})})
	runPass1(tagUsage1, state, tracker, nodes, lookup)
	local temp = state["pass"]["usage"]
	local temp1 = n1(temp)
	local temp2 = 1
	while temp2 <= temp1 do
		runPass1(temp[temp2], state, tracker, nodes, lookup)
		temp2 = temp2 + 1
	end
	return tracker["changed"]
end)
optimise1 = (function(nodes, state)
	stripDefsFast1(nodes)
	local maxN = state["max-n"]
	local maxT = state["max-time"]
	local iteration = 0
	local finish = clock1() + maxT
	local changed = true
	while changed and ((maxN < 0 or iteration < maxN) and (maxT < 0 or clock1() < finish)) do
		changed = optimiseOnce1(nodes, state)
		iteration = iteration + 1
	end
	return nil
end)
default1 = (function()
	return ({["normal"]=list1(stripImport1, stripPure1, constantFold1, condFold1, lambdaFold1, fusion1),["usage"]=list1(stripDefs1, stripArgs1, variableFold1, condEliminate1, expressionFold1, inline1)})
end)
tokens1 = ({tag = "list", n = 7, ({tag = "list", n = 2, "arg", "(%f[%a]%u+%f[%A])"}), ({tag = "list", n = 2, "mono", "```[a-z]*\n([^`]*)\n```"}), ({tag = "list", n = 2, "mono", "`([^`]*)`"}), ({tag = "list", n = 2, "bolic", "(%*%*%*%w.-%w%*%*%*)"}), ({tag = "list", n = 2, "bold", "(%*%*%w.-%w%*%*)"}), ({tag = "list", n = 2, "italic", "(%*%w.-%w%*)"}), ({tag = "list", n = 2, "link", "%[%[(.-)%]%]"})})
extractSignature1 = (function(var)
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
end)
parseDocstring1 = (function(str)
	local out, pos, len = ({tag = "list", n = 0}), 1, n1(str)
	while pos <= len do
		local spos = len
		local epos = nil
		local name = nil
		local ptrn = nil
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
				pushCdr_21_1(out, ({["tag"]="text",["contents"]=sub1(str, pos, spos - 1)}))
			end
			pushCdr_21_1(out, ({["tag"]=name,["whole"]=sub1(str, spos, epos),["contents"]=match1(sub1(str, spos, epos), ptrn)}))
			pos = epos + 1
		else
			pushCdr_21_1(out, ({["tag"]="text",["contents"]=sub1(str, pos, len)}))
			pos = len + 1
		end
	end
	return out
end)
checkArity1 = ({["name"]="check-arity",["help"]="Produce a warning if any NODE in NODES calls a function with too many arguments.\n\nLOOKUP is the variable usage lookup table.",["cat"]=({tag = "list", n = 2, "warn", "usage"}),["run"]=(function(temp, state, nodes, lookup)
	local arity, getArity
	arity = ({})
	getArity = (function(symbol)
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
			if defData["tag"] == "var" then
				ari = false
			else
				if type1(def) == "symbol" then
					ari = getArity(def)
				elseif type1(def) == "list" and (type1((car1(def))) == "symbol" and car1(def)["var"] == builtins1["lambda"]) then
					local args = nth1(def, 2)
					if any1((function(x)
						return x["var"]["is-variadic"]
					end), args) then
						ari = false
					else
						ari = n1(args)
					end
				else
					ari = false
				end
			end
			arity[var] = ari
			return ari
		end
	end)
	return visitBlock1(nodes, 1, (function(node)
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
	end))
end)})
deprecated1 = ({["name"]="deprecated",["help"]="Produce a warning whenever a deprecated variable is used.",["cat"]=({tag = "list", n = 2, "warn", "usage"}),["run"]=(function(temp, state, nodes, lookup)
	local temp1 = n1(nodes)
	local temp2 = 1
	while temp2 <= temp1 do
		local node = nodes[temp2]
		local defVar = node["def-var"]
		visitNode1(node, (function(node1)
			if type1(node1) == "symbol" then
				local var = node1["var"]
				if var ~= defVar and var["deprecated"] then
					return putNodeWarning_21_1(state["logger"], (function()
						if string_3f_1(var["deprecated"]) then
							return format1("%s is deprecated: %s", node1["contents"], var["deprecated"])
						else
							return format1("%s is deprecated.", node1["contents"])
						end
					end)()
					, node1, nil, getSource1(node1), "")
				else
					return nil
				end
			else
				return nil
			end
		end))
		temp2 = temp2 + 1
	end
	return nil
end)})
documentation1 = ({["name"]="documentation",["help"]="Ensure doc comments are valid.",["cat"]=({tag = "list", n = 1, "warn"}),["run"]=(function(temp, state, nodes)
	local temp1 = n1(nodes)
	local temp2 = 1
	while temp2 <= temp1 do
		local node = nodes[temp2]
		local var = node["def-var"]
		if var then
			local doc = var["doc"]
			if doc then
				local temp3 = parseDocstring1(doc)
				local temp4 = n1(temp3)
				local temp5 = 1
				while temp5 <= temp4 do
					local tok = temp3[temp5]
					if type1(tok) == "link" then
						if get1(var["scope"], tok["contents"]) then
						else
							putNodeWarning_21_1(state["logger"], format1("%s is not defined.", quoted1(tok["contents"])), node, nil, getSource1(node), "Referenced in docstring.")
						end
					end
					temp5 = temp5 + 1
				end
			end
		end
		temp2 = temp2 + 1
	end
	return nil
end)})
analyse1 = (function(nodes, state)
	local temp = state["pass"]["normal"]
	local temp1 = n1(temp)
	local temp2 = 1
	while temp2 <= temp1 do
		runPass1(temp[temp2], state, nil, nodes)
		temp2 = temp2 + 1
	end
	local lookup = ({["vars"]=({}),["nodes"]=({})})
	runPass1(tagUsage1, state, nil, nodes, lookup)
	local temp = state["pass"]["usage"]
	local temp1 = n1(temp)
	local temp2 = 1
	while temp2 <= temp1 do
		runPass1(temp[temp2], state, nil, nodes, lookup)
		temp2 = temp2 + 1
	end
	return nil
end)
create3 = (function()
	return ({["out"]=({tag = "list", n = 0}),["indent"]=0,["tabs-pending"]=false,["line"]=1,["lines"]=({}),["node-stack"]=({tag = "list", n = 0}),["active-pos"]=nil})
end)
append_21_1 = (function(writer, text)
	local temp = type1(text)
	if temp ~= "string" then
		error1(format1("bad argument %s (expected %s, got %s)", "text", "string", temp), 2)
	end
	local pos = writer["active-pos"]
	if pos then
		local line = writer["lines"][writer["line"]]
		if line then
		else
			line = ({})
			writer["lines"][writer["line"]] = line
		end
		line[pos] = true
	end
	if writer["tabs-pending"] then
		writer["tabs-pending"] = false
		pushCdr_21_1(writer["out"], rep1("\9", writer["indent"]))
	end
	return pushCdr_21_1(writer["out"], text)
end)
line_21_1 = (function(writer, text, force)
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
end)
indent_21_1 = (function(writer)
	return _5e7e_1(writer, on_21_1("indent"), succ1)
end)
unindent_21_1 = (function(writer)
	writer["indent"] = writer["indent"] - 1
	return nil
end)
beginBlock_21_1 = (function(writer, text)
	line_21_1(writer, text)
	return _5e7e_1(writer, on_21_1("indent"), succ1)
end)
nextBlock_21_1 = (function(writer, text)
	writer["indent"] = writer["indent"] - 1
	line_21_1(writer, text)
	return _5e7e_1(writer, on_21_1("indent"), succ1)
end)
endBlock_21_1 = (function(writer, text)
	writer["indent"] = writer["indent"] - 1
	return line_21_1(writer, text)
end)
pushNode_21_1 = (function(writer, node)
	local range = getSource1(node)
	if range then
		pushCdr_21_1(writer["node-stack"], node)
		writer["active-pos"] = range
		return nil
	else
		return nil
	end
end)
popNode_21_1 = (function(writer, node)
	if getSource1(node) then
		local stack = writer["node-stack"]
		if last1(stack) == node then
		else
			error1("Incorrect node popped")
		end
		popLast_21_1(stack)
		writer["arg-pos"] = last1(stack)
		return nil
	else
		return nil
	end
end)
estimateLength1 = (function(node, max)
	local tag = node["tag"]
	if tag == "string" or (tag == "number" or (tag == "symbol" or tag == "key")) then
		return n1(tostring1(node["contents"]))
	elseif tag == "list" then
		local sum = 2
		local i = 1
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
end)
expression1 = (function(node, writer)
	local tag = node["tag"]
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
end)
block1 = (function(list, writer)
	local temp = n1(list)
	local temp1 = 1
	while temp1 <= temp do
		expression1(list[temp1], writer)
		line_21_1(writer)
		temp1 = temp1 + 1
	end
	return nil
end)
nodeContainsVar_3f_1 = (function(node, var)
	local found = false
	visitNode1(node, (function(node1)
		if found then
			return false
		elseif type1(node1) == "symbol" then
			found = var == node1["var"]
			return nil
		else
			return nil
		end
	end))
	return found
end)
cat1 = (function(category, ...)
	local args = _pack(...) args.tag = "list"
	return struct1("category", category, unpack1(args, 1, n1(args)))
end)
partAll1 = (function(xs, i, e, f)
	while true do
		if i > e then
			return true
		elseif f(nth1(xs, i)) then
			i = i + 1
		else
			return false
		end
	end
end)
recurDirect_3f_1 = (function(state, var)
	local rec = state["rec-lookup"][var]
	return rec and (rec["var"] == 0 and rec["direct"] == 1)
end)
visitNode2 = (function(lookup, state, node, stmt, test, recur)
	local cat
	local temp = type1(node)
	if temp == "string" then
		cat = cat1("const")
	elseif temp == "number" then
		cat = cat1("const")
	elseif temp == "key" then
		cat = cat1("const")
	elseif temp == "symbol" then
		cat = cat1("const")
	elseif temp == "list" then
		local head = car1(node)
		local temp1 = type1(head)
		if temp1 == "symbol" then
			local func = head["var"]
			local funct = func["tag"]
			if func == builtins1["lambda"] then
				visitNodes1(lookup, state, node, 3, true)
				cat = cat1("lambda")
			elseif func == builtins1["cond"] then
				local temp2 = n1(node)
				local temp3 = 2
				while temp3 <= temp2 do
					local case = nth1(node, temp3)
					visitNode2(lookup, state, car1(case), true, true)
					visitNodes1(lookup, state, case, 2, true, test, recur)
					temp3 = temp3 + 1
				end
				local temp2
				if n1(node) == 3 then
					local temp3
					local sub = nth1(node, 2)
					temp3 = n1(sub) == 2 and builtin_3f_1(nth1(sub, 2), "false")
					if temp3 then
						local sub = nth1(node, 3)
						temp2 = n1(sub) == 2 and (builtin_3f_1(nth1(sub, 1), "true") and builtin_3f_1(nth1(sub, 2), "true"))
					else
						temp2 = false
					end
				else
					temp2 = false
				end
				if temp2 then
					addParen1(lookup, car1(nth1(node, 2)), 11)
					cat = cat1("not", "stmt", lookup[car1(nth1(node, 2))]["stmt"], "prec", 11)
				else
					local temp2
					if n1(node) == 3 then
						local first = nth1(node, 2)
						local second = nth1(node, 3)
						local branch = car1(first)
						local last = nth1(second, 2)
						temp2 = n1(first) == 2 and (n1(second) == 2 and (not lookup[nth1(first, 2)]["stmt"] and (builtin_3f_1(car1(second), "true") and (type1(last) == "symbol" and (type1(branch) == "symbol" and branch["var"] == last["var"] or test and (not lookup[branch]["stmt"] and last["var"] == builtins1["false"]))))))
					else
						temp2 = false
					end
					if temp2 then
						addParen1(lookup, nth1(nth1(node, 2), 1), 2)
						addParen1(lookup, nth1(nth1(node, 2), 2), 2)
						cat = cat1("and", "prec", 2)
					else
						local temp2
						if n1(node) >= 3 then
							if partAll1(node, 2, n1(node) - 1, (function(branch)
								local head1 = car1(branch)
								local tail = nth1(branch, 2)
								return n1(branch) == 2 and (type1(tail) == "symbol" and (type1(head1) == "symbol" and head1["var"] == tail["var"] or test and (not lookup[head1]["stmt"] and tail["var"] == builtins1["true"])))
							end)) then
								local branch = last1(node)
								temp2 = n1(branch) == 2 and (builtin_3f_1(car1(branch), "true") and not lookup[nth1(branch, 2)]["stmt"])
							else
								temp2 = false
							end
						else
							temp2 = false
						end
						if temp2 then
							local len = n1(node)
							local temp2 = 2
							while temp2 <= len do
								addParen1(lookup, nth1(nth1(node, temp2), (function()
									if temp2 == len then
										return 2
									else
										return 1
									end
								end)()
								), 1)
								temp2 = temp2 + 1
							end
							cat = cat1("or", "prec", 1)
						else
							cat = cat1("cond", "stmt", true)
						end
					end
				end
			elseif func == builtins1["set!"] then
				local def, var = nth1(node, 3), nth1(node, 2)["var"]
				local temp2
				if type1(def) == "list" then
					if builtin_3f_1(car1(def), "lambda") then
						local rec = state["rec-lookup"][var]
						temp2 = rec and rec["recur"] > 0
					else
						temp2 = false
					end
				else
					temp2 = false
				end
				if temp2 then
					local recur1 = ({["var"]=var,["def"]=def})
					visitNodes1(lookup, state, def, 3, true, nil, recur1)
					if recur1["tail"] then
					else
						error1("Expected tail recursive function from letrec")
					end
					lookup[def] = cat1("lambda", "recur", visitRecur1(lookup, recur1))
				else
					visitNode2(lookup, state, def, true)
				end
				cat = cat1("set!")
			elseif func == builtins1["quote"] then
				visitQuote2(lookup, node)
				cat = cat1("quote")
			elseif func == builtins1["syntax-quote"] then
				visitSyntaxQuote1(lookup, state, nth1(node, 2), 1)
				cat = cat1("syntax-quote")
			elseif func == builtins1["unquote"] then
				cat = error1("unquote should never appear", 0)
			elseif func == builtins1["unquote-splice"] then
				cat = error1("unquote should never appear", 0)
			elseif func == builtins1["define"] or func == builtins1["define-macro"] then
				local def = nth1(node, n1(node))
				if type1(def) == "list" and builtin_3f_1(car1(def), "lambda") then
					local recur1 = ({["var"]=node["def-var"],["def"]=def})
					visitNodes1(lookup, state, def, 3, true, nil, recur1)
					lookup[def] = (function()
						if recur1["tail"] then
							return cat1("lambda", "recur", visitRecur1(lookup, recur1))
						else
							return cat1("lambda")
						end
					end)()
				else
					visitNode2(lookup, state, def, true)
				end
				cat = cat1("define")
			elseif func == builtins1["define-native"] then
				cat = cat1("define-native")
			elseif func == builtins1["import"] then
				cat = cat1("import")
			elseif func == builtins1["struct-literal"] then
				visitNodes1(lookup, state, node, 2, false)
				cat = cat1("struct-literal")
			elseif func == builtins1["true"] then
				visitNodes1(lookup, state, node, 1, false)
				cat = cat1("call-literal")
			elseif func == builtins1["false"] then
				visitNodes1(lookup, state, node, 1, false)
				cat = cat1("call-literal")
			elseif func == builtins1["nil"] then
				visitNodes1(lookup, state, node, 1, false)
				cat = cat1("call-literal")
			else
				local meta = func["tag"] == "native" and state["meta"][func["full-name"]]
				local metaTy = type1(meta)
				if metaTy == "nil" then
				elseif metaTy == "boolean" then
				elseif metaTy == "expr" then
				elseif metaTy == "stmt" then
					if stmt then
					else
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
					local prec = meta["prec"]
					local precs = meta["precs"]
					if prec or precs then
						addParens1(lookup, node, 2, prec, precs)
					end
					cat = cat1("call-meta", "meta", meta, "stmt", metaTy == "stmt", "prec", prec)
				elseif recur and func == recur["var"] then
					recur["tail"] = true
					visitNodes1(lookup, state, node, 1, false)
					cat = cat1("call-tail", "recur", recur, "stmt", true)
				elseif stmt and recurDirect_3f_1(state, func) then
					local rec = state["rec-lookup"][func]
					local lam = rec["lambda"]
					local args = nth1(lam, 2)
					local offset = 1
					local recur1 = lookup[lam]["recur"]
					if recur1 then
					else
						print1("Cannot find recursion for ", func["name"])
					end
					local temp2 = n1(args)
					local temp3 = 1
					while temp3 <= temp2 do
						if nth1(args, temp3)["var"]["is-variadic"] then
							local count = n1(node) - n1(args)
							if count < 0 then
								count = 0
							end
							local temp4 = count
							local temp5 = 1
							while temp5 <= temp4 do
								visitNode2(lookup, state, nth1(node, temp3 + temp5), false)
								temp5 = temp5 + 1
							end
							offset = count
						else
							local val = nth1(node, temp3 + offset)
							if val then
								visitNode2(lookup, state, val, true)
							end
						end
						temp3 = temp3 + 1
					end
					local temp2 = n1(node)
					local temp3 = n1(args) + (offset + 1)
					while temp3 <= temp2 do
						visitNode2(lookup, state, nth1(node, temp3), true)
						temp3 = temp3 + 1
					end
					lookup[rec["set!"]] = cat1("void")
					state["var-skip"][func] = true
					cat = cat1("call-recur", "recur", recur1)
				else
					visitNodes1(lookup, state, node, 1, false)
					cat = cat1("call-symbol")
				end
			end
		elseif temp1 == "list" then
			if n1(node) == 2 and (builtin_3f_1(car1(head), "lambda") and (n1(head) == 3 and (n1(nth1(head, 2)) == 1 and (type1((nth1(head, 3))) == "symbol" and nth1(head, 3)["var"] == car1(nth1(head, 2))["var"])))) then
				if visitNode2(lookup, state, nth1(node, 2), stmt, test)["stmt"] then
					visitNode2(lookup, state, head, true)
					if stmt then
						cat = cat1("call-lambda", "stmt", true)
					else
						cat = cat1("call")
					end
				else
					cat = cat1("wrap-value")
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
					if visitNode2(lookup, state, nth1(node, 2), stmt, test)["stmt"] then
						lookup[head] = cat1("lambda")
						visitNode2(lookup, state, nth1(head, 3), true, test, recur)
						if stmt then
							cat = cat1("call-lambda", "stmt", true)
						else
							cat = cat1("call")
						end
					else
						local res = visitNode2(lookup, state, nth1(head, 3), true, test, recur)
						local ty = res["category"]
						local unused_3f_ = (function()
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
											if type1(sub) == "symbol" then
											else
												working = not nodeContainsVar_3f_1(sub, var)
											end
										end
										temp5 = temp5 + 1
									end
								end
								temp3 = temp3 + 1
							end
							return working
						end)
						lookup[head] = cat1("lambda")
						if ty == "and" and unused_3f_() then
							addParen1(lookup, nth1(node, 2), 2)
							cat = cat1("and-lambda", "prec", 2)
						elseif ty == "or" and unused_3f_() then
							addParen1(lookup, nth1(node, 2), 1)
							cat = cat1("or-lambda", "prec", 1)
						elseif stmt then
							cat = cat1("call-lambda", "stmt", true)
						else
							cat = cat1("call")
						end
					end
				elseif stmt and builtin_3f_1(car1(head), "lambda") then
					visitNodes1(lookup, state, car1(node), 3, true, test, recur)
					local lam = car1(node)
					local args = nth1(lam, 2)
					local offset = 1
					local temp2 = n1(args)
					local temp3 = 1
					while temp3 <= temp2 do
						if nth1(args, temp3)["var"]["is-variadic"] then
							local count = n1(node) - n1(args)
							if count < 0 then
								count = 0
							end
							local temp4 = count
							local temp5 = 1
							while temp5 <= temp4 do
								visitNode2(lookup, state, nth1(node, temp3 + temp5), false)
								temp5 = temp5 + 1
							end
							offset = count
						else
							local val = nth1(node, temp3 + offset)
							if val then
								visitNode2(lookup, state, val, true)
							end
						end
						temp3 = temp3 + 1
					end
					local temp2 = n1(node)
					local temp3 = n1(args) + (offset + 1)
					while temp3 <= temp2 do
						visitNode2(lookup, state, nth1(node, temp3), true)
						temp3 = temp3 + 1
					end
					cat = cat1("call-lambda", "stmt", true)
				elseif builtin_3f_1(car1(head), "quote") or builtin_3f_1(car1(head), "syntax-quote") then
					visitNodes1(lookup, state, node, 1, false)
					cat = cat1("call-literal")
				else
					visitNodes1(lookup, state, node, 1, false)
					addParen1(lookup, car1(node), 100)
					cat = cat1("call")
				end
			end
		elseif eq_3f_1(temp1, true) then
			visitNodes1(lookup, state, node, 1, false)
			cat = cat1("call-literal")
		else
			cat = error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp1) .. ", but none matched.\n" .. "  Tried: `\"symbol\"`\n  Tried: `\"list\"`\n  Tried: `true`")
		end
	else
		cat = error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"key\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`")
	end
	if cat == nil then
		error1("Node returned nil " .. pretty1(node), 0)
	end
	lookup[node] = cat
	return cat
end)
visitNodes1 = (function(lookup, state, nodes, start, stmt, test, recur)
	local len = n1(nodes)
	local temp = start
	while temp <= len do
		visitNode2(lookup, state, nth1(nodes, temp), stmt, test and temp == len, temp == len and recur)
		temp = temp + 1
	end
	return nil
end)
visitSyntaxQuote1 = (function(lookup, state, node, level)
	if level == 0 then
		return visitNode2(lookup, state, node, false)
	else
		local cat
		local temp = type1(node)
		if temp == "string" then
			cat = cat1("quote-const")
		elseif temp == "number" then
			cat = cat1("quote-const")
		elseif temp == "key" then
			cat = cat1("quote-const")
		elseif temp == "symbol" then
			cat = cat1("quote-const")
		elseif temp == "list" then
			local temp1 = car1(node)
			if eq_3f_1(temp1, ({ tag="symbol", contents="unquote"})) then
				visitSyntaxQuote1(lookup, state, nth1(node, 2), level - 1)
				cat = cat1("unquote")
			elseif eq_3f_1(temp1, ({ tag="symbol", contents="unquote-splice"})) then
				visitSyntaxQuote1(lookup, state, nth1(node, 2), level - 1)
				cat = cat1("unquote-splice")
			elseif eq_3f_1(temp1, ({ tag="symbol", contents="syntax-quote"})) then
				local temp2 = n1(node)
				local temp3 = 1
				while temp3 <= temp2 do
					visitSyntaxQuote1(lookup, state, node[temp3], level + 1)
					temp3 = temp3 + 1
				end
				cat = cat1("quote-list")
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
					cat = cat1("quote-splice", "stmt", true)
				else
					cat = cat1("quote-list")
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
end)
visitQuote2 = (function(lookup, node)
	if type1(node) == "list" then
		local temp = n1(node)
		local temp1 = 1
		while temp1 <= temp do
			visitQuote2(lookup, (node[temp1]))
			temp1 = temp1 + 1
		end
		lookup[node] = cat1("quote-list")
		return nil
	else
		lookup[node] = cat1("quote-const")
		return nil
	end
end)
visitRecur1 = (function(lookup, recur)
	local lam = recur["def"]
	local temp
	if n1(lam) == 3 then
		local child = nth1(lam, 3)
		temp = type1(child) == "list" and (builtin_3f_1(car1(child), "cond") and (n1(child) == 3 and (builtin_3f_1(car1(nth1(child, 3)), "true") and not lookup[car1(nth1(child, 2))]["stmt"])))
	else
		temp = false
	end
	if temp then
		local fstCase = nth1(nth1(lam, 3), 2)
		local sndCase = nth1(nth1(lam, 3), 3)
		local fst = n1(fstCase) >= 2 and justRecur_3f_1(lookup, last1(fstCase), recur)
		local snd = n1(sndCase) >= 2 and justRecur_3f_1(lookup, last1(sndCase), recur)
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
end)
justRecur_3f_1 = (function(lookup, node, recur)
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
end)
addParens1 = (function(lookup, nodes, start, prec, precs)
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
		end)()
		 then
			childCat["parens"] = true
		end
		temp1 = temp1 + 1
	end
	return nil
end)
addParen1 = (function(lookup, node, prec)
	local childCat = lookup[node]
	if childCat["prec"] and childCat["prec"] <= prec then
		childCat["parens"] = true
		return nil
	else
		return nil
	end
end)
categoriseNodes1 = ({["name"]="categorise-nodes",["help"]="Categorise a group of NODES, annotating their appropriate node type.",["cat"]=({tag = "list", n = 1, "categorise"}),["run"]=(function(temp, compiler, nodes, state)
	return visitNodes1(state["cat-lookup"], state, nodes, 1, true)
end)})
categoriseNode1 = ({["name"]="categorise-node",["help"]="Categorise a NODE, annotating it's appropriate node type.",["cat"]=({tag = "list", n = 1, "categorise"}),["run"]=(function(temp, compiler, node, state, stmt)
	return visitNode2(state["cat-lookup"], state, node, stmt)
end)})
visitQuote3 = (function(node, level, lookup)
	while true do
		if level == 0 then
			return visitNode3(node, nil, nil, lookup)
		else
			local tag = node["tag"]
			if tag == "string" or (tag == "number" or (tag == "key" or tag == "symbol")) then
				return nil
			elseif tag == "list" then
				local first = nth1(node, 1)
				if first and first["tag"] == "symbol" then
					if first["contents"] == "unquote" or first["contents"] == "unquote-splice" then
						node, level = nth1(node, 2), level - 1
					elseif first["contents"] == "syntax-quote" then
						node, level = nth1(node, 2), level + 1
					else
						local temp = n1(node)
						local temp1 = 1
						while temp1 <= temp do
							visitQuote3(node[temp1], level, lookup)
							temp1 = temp1 + 1
						end
						return nil
					end
				else
					local temp = n1(node)
					local temp1 = 1
					while temp1 <= temp do
						visitQuote3(node[temp1], level, lookup)
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
end)
visitNode3 = (function(node, parents, active, lookup)
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
				local funct = func["tag"]
				if func["tag"] ~= "builtin" then
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
					return visitBlock2(node, 3, nil, nil, lookup)
				elseif func == builtins1["set!"] then
					local var = nth1(node, 2)["var"]
					local state = lookup[var]
					local val = nth1(node, 3)
					if state and (state["lambda"] == nil and (parents and (parents[state["parent"]] and (type1(val) == "list" and builtin_3f_1(car1(val), "lambda"))))) then
						state["lambda"] = val
						state["set!"] = node
						return visitBlock2(val, 3, nil, state, lookup)
					else
						lookup[var] = nil
						node, parents, active = val, nil, nil
					end
				elseif func == builtins1["cond"] then
					local temp2 = n1(node)
					local temp3 = 2
					while temp3 <= temp2 do
						local case = nth1(node, temp3)
						visitNode3(car1(case), nil, nil, lookup)
						visitBlock2(case, 2, nil, active, lookup)
						temp3 = temp3 + 1
					end
					return nil
				elseif func == builtins1["quote"] then
					return nil
				elseif func == builtins1["syntax-quote"] then
					return visitQuote3(nth1(node, 2), 1, lookup)
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
							lookup[nth1(args, temp3)["var"]] = ({["recur"]=0,["var"]=0,["direct"]=0,["parent"]=node,["set!"]=nil,["lambda"]=nil})
						end
						temp3 = temp3 + 1
					end
					if parents then
						parents[node] = true
					else
						parents = ({[node]=true})
					end
					visitBlock2(first, 3, parents, active, lookup)
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
end)
visitNodes2 = (function(node, start, parents, lookup)
	local temp = n1(node)
	local temp1 = start
	while temp1 <= temp do
		visitNode3(nth1(node, temp1), parents, nil, lookup)
		temp1 = temp1 + 1
	end
	return nil
end)
visitBlock2 = (function(node, start, parents, active, lookup)
	local temp = n1(node) - 1
	local temp1 = start
	while temp1 <= temp do
		visitNode3(nth1(node, temp1), parents, nil, lookup)
		temp1 = temp1 + 1
	end
	if n1(node) >= start then
		return visitNode3(last1(node), parents, active, lookup)
	else
		return nil
	end
end)
letrecNodes1 = ({["name"]="letrec-nodes",["help"]="Find letrec constructs in a list of NODES",["cat"]=({tag = "list", n = 1, "categorise"}),["run"]=(function(temp, compiler, nodes, state)
	return visitNodes2(nodes, 1, nil, state["rec-lookup"])
end)})
letrecNode1 = ({["name"]="letrec-node",["help"]="Find letrec constructs in a node",["cat"]=({tag = "list", n = 1, "categorise"}),["run"]=(function(temp, compiler, node, state, stmt)
	return visitNode3(node, nil, nil, state["rec-lookup"])
end)})
keywords1 = createLookup1(({tag = "list", n = 21, "and", "break", "do", "else", "elseif", "end", "false", "for", "function", "if", "in", "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while"}))
escape1 = (function(name)
	if name == "" then
		return "_e"
	elseif keywords1[name] then
		return "_e" .. name
	elseif find1(name, "^%w[_%w%d]*$") then
		return name
	else
		local out
		if find1(sub1(name, 1, 1), "%d") then
			out = "_e"
		else
			out = ""
		end
		local upper = false
		local esc = false
		local temp = n1(name)
		local temp1 = 1
		while temp1 <= temp do
			local char = sub1(name, temp1, temp1)
			if char == "-" and (find1((function(x)
				return sub1(name, x, x)
			end)(temp1 - 1), "[%a%d']") and find1((function(x)
				return sub1(name, x, x)
			end)(temp1 + 1), "[%a%d']")) then
				upper = true
			elseif find1(char, "[^%w%d]") then
				char = format1("%02x", (byte1(char)))
				upper = false
				if esc then
				else
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
end)
pushEscapeVar_21_1 = (function(var, state, forceNum)
	local temp = state["var-lookup"][var]
	if temp then
		return temp
	else
		local esc = escape1(var["display-name"] or var["name"])
		local existing = state["var-cache"][esc]
		if forceNum or existing then
			local ctr = 1
			local finding = true
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
end)
popEscapeVar_21_1 = (function(var, state)
	local esc = state["var-lookup"][var]
	if esc then
	else
		error1(var["name"] .. " has not been escaped (when popping).", 0)
	end
	state["var-cache"][esc] = nil
	state["var-lookup"][var] = nil
	return nil
end)
escapeVar1 = (function(var, state)
	if builtinVars1[var] then
		return var["name"]
	else
		local esc = state["var-lookup"][var]
		if esc then
		else
			error1(var["name"] .. " has not been escaped (at " .. (function()
				if var["node"] then
					return formatNode1(var["node"])
				else
					return "?"
				end
			end)()
			 .. ")", 0)
		end
		return esc
	end
end)
createPassState1 = (function(state)
	return ({["meta"]=state["meta"],["var-cache"]=state["var-cache"],["var-lookup"]=state["var-lookup"],["var-skip"]=({}),["cat-lookup"]=({}),["rec-lookup"]=({})})
end)
truthy_3f_1 = (function(node)
	return type1(node) == "symbol" and builtins1["true"] == node["var"]
end)
boringCategories1 = ({["const"]=true,["quote"]=true,["not"]=true,["cond"]=true})
breakCategories1 = ({["cond"]=true,["call-lambda"]=true,["call-tail"]=true})
constCategories1 = ({["const"]=true,["quote"]=true,["quote-const"]=true})
compileNative1 = (function(out, meta)
	local ty = type1(meta)
	if ty == "var" then
		return append_21_1(out, meta["contents"])
	elseif ty == "expr" or ty == "stmt" then
		append_21_1(out, "function(")
		if meta["fold"] then
			append_21_1(out, "...")
		else
			local temp = meta["count"]
			local temp1 = 1
			while temp1 <= temp do
				if temp1 == 1 then
				else
					append_21_1(out, ", ")
				end
				append_21_1(out, "v" .. tonumber1(temp1))
				temp1 = temp1 + 1
			end
		end
		append_21_1(out, ") ")
		local temp = meta["fold"]
		if eq_3f_1(temp, nil) then
			if meta["tag"] ~= "stmt" then
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
end)
compileExpression1 = (function(node, out, state, ret, _ebreak)
	local catLookup = state["cat-lookup"]
	local cat = catLookup[node]
	local _5f_
	if cat then
		_5f_ = nil
	else
		_5f_ = print1("Cannot find", pretty1(node), formatNode1(node))
	end
	local catTag = cat["category"]
	if boringCategories1[catTag] then
	else
		pushNode_21_1(out, node)
	end
	if catTag == "void" then
		if ret == "" then
		else
			if ret then
				append_21_1(out, ret)
			end
			append_21_1(out, "nil")
		end
	elseif catTag == "const" then
		if ret == "" then
		else
			if ret then
				append_21_1(out, ret)
			end
			if type1(node) == "symbol" then
				append_21_1(out, escapeVar1(node["var"], state))
			elseif string_3f_1(node) then
				append_21_1(out, quoted1(node["value"]))
			elseif number_3f_1(node) then
				append_21_1(out, tostring1(node["value"]))
			elseif type1(node) == "key" then
				append_21_1(out, quoted1(node["value"]))
			else
				error1("Unknown type: " .. type1(node))
			end
		end
	elseif catTag == "lambda" then
		if ret == "" then
		else
			if ret then
				append_21_1(out, ret)
			end
			local args = nth1(node, 2)
			local variadic = nil
			local i = 1
			append_21_1(out, "(function(")
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
					local remaining = n1(args) - variadic
					line_21_1(out, "local _n = _select(\"#\", ...) - " .. tostring1(remaining))
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
					line_21_1(out, " = { tag=\"list\", n=_n, _unpack(_pack(...), 1, _n)}")
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
					line_21_1(out, " = { tag=\"list\", n=0}")
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
					out["indent"] = out["indent"] - 1
					line_21_1(out, "end")
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
			append_21_1(out, "end)")
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
			local isFinal = truthy_3f_1(case)
			if i > 2 and (not isFinal or (ret ~= "" or (_ebreak or n1(item) ~= 1 and fastAny1((function(x)
				return not constCategories1[catLookup[x]["category"]]
			end), item, 2)))) then
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
				local var = ({["name"]="temp"})
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
		if hadFinal then
		else
			append_21_1(out, "else")
			_5e7e_1(out, on_21_1("indent"), succ1)
			line_21_1(out)
			append_21_1(out, "_error(\"unmatched item\")")
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
			line_21_1(out, "end)()")
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
		local temp = 2
		while temp <= len do
			if temp > 2 then
				append_21_1(out, " or ")
			end
			compileExpression1(nth1(nth1(node, temp), (function()
				if temp == len then
					return 2
				else
					return 1
				end
			end)()
			), out, state)
			temp = temp + 1
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
		local temp = 3
		while temp <= len do
			append_21_1(out, " or ")
			compileExpression1(nth1(nth1(branch, temp), (function()
				if temp == len then
					return 2
				else
					return 1
				end
			end)()
			), out, state)
			temp = temp + 1
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
		append_21_1(out, "({")
		local temp = n1(node)
		local temp1 = 2
		while temp1 <= temp do
			if temp1 > 2 then
				append_21_1(out, ",")
			end
			append_21_1(out, "[")
			compileExpression1(nth1(node, temp1), out, state)
			append_21_1(out, "]=")
			compileExpression1(nth1(node, temp1 + 1), out, state)
			temp1 = temp1 + 2
		end
		append_21_1(out, "})")
	elseif catTag == "define" then
		compileExpression1(nth1(node, n1(node)), out, state, pushEscapeVar_21_1(node["def-var"], state) .. " = ")
	elseif catTag == "define-native" then
		local meta = state["meta"][node["def-var"]["full-name"]]
		if meta == nil then
			append_21_1(out, format1("%s = _libs[%q]", escapeVar1(node["def-var"], state), node["def-var"]["full-name"]))
		else
			append_21_1(out, format1("%s = ", escapeVar1(node["def-var"], state)))
			compileNative1(out, meta)
		end
	elseif catTag == "quote" then
		if ret == "" then
		else
			if ret then
				append_21_1(out, ret)
			end
			compileExpression1(nth1(node, 2), out, state)
		end
	elseif catTag == "quote-const" then
		if ret == "" then
		else
			if ret then
				append_21_1(out, ret)
			end
			local temp = type1(node)
			if temp == "string" then
				append_21_1(out, quoted1(node["value"]))
			elseif temp == "number" then
				append_21_1(out, tostring1(node["value"]))
			elseif temp == "symbol" then
				append_21_1(out, "({ tag=\"symbol\", contents=" .. quoted1(node["contents"]))
				if node["var"] then
					append_21_1(out, ", var=" .. quoted1(tostring1(node["var"])))
				end
				append_21_1(out, "})")
			elseif temp == "key" then
				append_21_1(out, "({tag=\"key\", value=" .. quoted1(node["value"]) .. "})")
			else
				error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"symbol\"`\n  Tried: `\"key\"`")
			end
		end
	elseif catTag == "quote-list" then
		if ret == "" then
			append_21_1(out, "local _ = ")
		elseif ret then
			append_21_1(out, ret)
		end
		append_21_1(out, "({tag = \"list\", n = " .. tostring1(n1(node)))
		local temp = n1(node)
		local temp1 = 1
		while temp1 <= temp do
			local sub = node[temp1]
			append_21_1(out, ", ")
			compileExpression1(sub, out, state)
			temp1 = temp1 + 1
		end
		append_21_1(out, "})")
	elseif catTag == "quote-splice" then
		if ret then
		else
			line_21_1(out, "(function()")
			_5e7e_1(out, on_21_1("indent"), succ1)
		end
		line_21_1(out, "local _offset, _result, _temp = 0, {tag=\"list\",n=0}")
		local offset = 0
		local temp = n1(node)
		local temp1 = 1
		while temp1 <= temp do
			local sub = nth1(node, temp1)
			local cat2 = state["cat-lookup"][sub]
			if cat2 then
			else
				print1("Cannot find", pretty1(sub), formatNode1(sub))
			end
			if cat2["category"] == "unquote-splice" then
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
			out["indent"] = out["indent"] - 1
			line_21_1(out, "end)()")
		end
	elseif catTag == "syntax-quote" then
		compileExpression1(nth1(node, 2), out, state, ret)
	elseif catTag == "unquote" then
		compileExpression1(nth1(node, 2), out, state, ret)
	elseif catTag == "unquote-splice" then
		error1("Should neve have explicit unquote-splice", 0)
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
		local contents = meta["contents"]
		local fold = meta["fold"]
		local count = meta["count"]
		local build
		build = (function(start, _eend)
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
		end)
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
		local head = cat["recur"]["def"]
		local args = nth1(head, 2)
		compileBind1(args, node, 1, 2, out, state)
		if ret == "return " then
			compileRecur1(cat["recur"], out, state, "return ")
		else
			compileRecur1(cat["recur"], out, state, ret, cat["recur"])
		end
		local temp = n1(args)
		local temp1 = 1
		while temp1 <= temp do
			local arg = args[temp1]
			if state["var-skip"][arg["var"]] then
			else
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
		local head = cat["recur"]["def"]
		local args = nth1(head, 2)
		if n1(args) > 0 then
			local packName = nil
			local offset = 1
			local done = false
			local temp = n1(args)
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
			append_21_1(out, " = ")
			local offset = 1
			local done = false
			local temp = n1(args)
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
					if compilePack1(node, out, state, temp1, count) then
						packName = escapeVar1(var, state)
					end
					offset = count
				else
					local expr = nth1(node, temp1 + offset)
					if expr and (not (type1(expr) == "symbol") or expr["var"] ~= var) then
						if done then
							append_21_1(out, ", ")
						else
							done = true
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
		if ret == nil then
			print1(pretty1(node), " marked as call-lambda for ", ret)
		end
		local head = car1(node)
		local args = nth1(head, 2)
		compileBind1(args, node, 1, 2, out, state)
		compileBlock1(head, out, state, 3, ret)
		local temp = n1(args)
		local temp1 = 1
		while temp1 <= temp do
			local arg = args[temp1]
			if state["var-skip"][arg["var"]] then
			else
				popEscapeVar_21_1(arg["var"], state)
			end
			temp1 = temp1 + 1
		end
	elseif catTag == "call-literal" then
		if ret then
			append_21_1(out, ret)
		end
		append_21_1(out, "(")
		compileExpression1(car1(node), out, state)
		append_21_1(out, ")(")
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
		error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(catTag) .. ", but none matched.\n" .. "  Tried: `\"void\"`\n  Tried: `\"const\"`\n  Tried: `\"lambda\"`\n  Tried: `\"cond\"`\n  Tried: `\"not\"`\n  Tried: `\"or\"`\n  Tried: `\"or-lambda\"`\n  Tried: `\"and\"`\n  Tried: `\"and-lambda\"`\n  Tried: `\"set!\"`\n  Tried: `\"struct-literal\"`\n  Tried: `\"define\"`\n  Tried: `\"define-native\"`\n  Tried: `\"quote\"`\n  Tried: `\"quote-const\"`\n  Tried: `\"quote-list\"`\n  Tried: `\"quote-splice\"`\n  Tried: `\"syntax-quote\"`\n  Tried: `\"unquote\"`\n  Tried: `\"unquote-splice\"`\n  Tried: `\"import\"`\n  Tried: `\"call-symbol\"`\n  Tried: `\"call-meta\"`\n  Tried: `\"call-recur\"`\n  Tried: `\"call-tail\"`\n  Tried: `\"wrap-value\"`\n  Tried: `\"call-lambda\"`\n  Tried: `\"call-literal\"`\n  Tried: `\"call\"`")
	end
	if boringCategories1[catTag] then
		return nil
	else
		return popNode_21_1(out, node)
	end
end)
compileBind1 = (function(args, vals, argIdx, valIdx, out, state)
	local argLen = n1(args)
	local valLen = n1(vals)
	local skip = state["var-skip"]
	local catLookup = state["cat-lookup"]
	while argIdx <= argLen or valIdx <= valLen do
		local arg = args[argIdx]
		if not arg then
			compileExpression1(nth1(vals, argIdx), out, state, "")
			argIdx = argIdx + 1
		elseif arg["var"]["is-variadic"] then
			local esc = pushEscapeVar_21_1(arg["var"], state)
			local count = valLen - argLen
			append_21_1(out, "local " .. esc)
			if count < 0 then
				count = 0
			end
			append_21_1(out, " = ")
			if compilePack1(vals, out, state, argIdx, count) then
				append_21_1(out, " " .. esc .. ".tag = \"list\"")
			end
			line_21_1(out)
			argIdx = argIdx + 1
			valIdx = count + valIdx
		elseif skip[arg["var"]] then
			argIdx = argIdx + 1
			valIdx = valIdx + 1
		elseif valIdx == valLen then
			local argList = ({tag = "list", n = 0})
			local val = nth1(vals, valIdx)
			local ret = nil
			while argIdx <= argLen do
				local var = nth1(args, argIdx)["var"]
				if not skip[var] then
					pushCdr_21_1(argList, pushEscapeVar_21_1(var, state))
				elseif argIdx < argLen then
					pushCdr_21_1(argList, "_")
				end
				argIdx = argIdx + 1
			end
			append_21_1(out, "local ")
			append_21_1(out, concat1(argList, ", "))
			if catLookup[val]["stmt"] then
				ret = concat1(argList, ", ") .. " = "
				line_21_1(out)
			else
				append_21_1(out, " = ")
			end
			compileExpression1(val, out, state, ret)
			valIdx = valIdx + 1
		else
			local argStart = argIdx
			local valStart = valIdx
			local working = true
			while working and (argIdx <= argLen or valIdx <= valLen) do
				local arg2 = nth1(args, argIdx)
				local val = nth1(vals, valIdx)
				if arg2 and arg2["var"]["is-variadic"] then
					working = false
				elseif val and catLookup[val]["stmt"] then
					working = false
				else
					if argIdx <= argLen then
						argIdx = argIdx + 1
					end
					if valIdx <= valLen then
						valIdx = valIdx + 1
					end
				end
			end
			if argStart == argIdx then
				local expr = nth1(vals, valIdx)
				local var = arg["var"]
				local esc = pushEscapeVar_21_1(var, state)
				local ret = nil
				append_21_1(out, "local " .. esc)
				if expr then
					if catLookup[expr]["stmt"] then
						ret = esc .. " = "
						line_21_1(out)
					else
						append_21_1(out, " = ")
					end
					compileExpression1(expr, out, state, ret)
				else
					line_21_1(out)
				end
				argIdx = argIdx + 1
				valIdx = valIdx + 1
			else
				append_21_1(out, "local ")
				local temp = argIdx - 1
				local temp1 = argStart
				while temp1 <= temp do
					local var = nth1(args, temp1)["var"]
					if skip[var] then
					else
						if temp1 > argStart then
							append_21_1(out, ", ")
						end
						append_21_1(out, pushEscapeVar_21_1(var, state))
					end
					temp1 = temp1 + 1
				end
				if valStart < valIdx then
					append_21_1(out, " = ")
					local temp = valIdx - 1
					local temp1 = valStart
					while temp1 <= temp do
						if skip[nth1(args, (temp1 - valStart) + argStart)["var"]] then
						else
							if temp1 > valStart then
								append_21_1(out, ", ")
							end
							compileExpression1(nth1(vals, temp1), out, state)
						end
						temp1 = temp1 + 1
					end
				end
			end
		end
		line_21_1(out)
	end
	return nil
end)
compilePack1 = (function(node, out, state, start, count)
	if count <= 0 or atom_3f_1(nth1(node, start + count)) then
		append_21_1(out, "{ tag=\"list\", n=")
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
end)
compileRecur1 = (function(recur, out, state, ret, _ebreak)
	local temp = recur["category"]
	if temp == "while" then
		local node = nth1(recur["def"], 3)
		append_21_1(out, "while ")
		compileExpression1(car1(nth1(node, 2)), out, state)
		line_21_1(out, " do")
		_5e7e_1(out, on_21_1("indent"), succ1)
		compileBlock1(nth1(node, 2), out, state, 2, ret, _ebreak)
		out["indent"] = out["indent"] - 1
		line_21_1(out, "end")
		return compileBlock1(nth1(node, 3), out, state, 2, ret)
	elseif temp == "while-not" then
		local node = nth1(recur["def"], 3)
		append_21_1(out, "while not (")
		compileExpression1(car1(nth1(node, 2)), out, state)
		line_21_1(out, ") do")
		_5e7e_1(out, on_21_1("indent"), succ1)
		compileBlock1(nth1(node, 3), out, state, 2, ret, _ebreak)
		out["indent"] = out["indent"] - 1
		line_21_1(out, "end")
		return compileBlock1(nth1(node, 2), out, state, 2, ret)
	elseif temp == "forever" then
		line_21_1(out, "while true do")
		_5e7e_1(out, on_21_1("indent"), succ1)
		compileBlock1(recur["def"], out, state, 3, ret, _ebreak)
		out["indent"] = out["indent"] - 1
		return line_21_1(out, "end")
	else
		return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"while\"`\n  Tried: `\"while-not\"`\n  Tried: `\"forever\"`")
	end
end)
compileBlock1 = (function(nodes, out, state, start, ret, _ebreak)
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
end)
prelude1 = (function(out)
	line_21_1(out, "if not table.pack then table.pack = function(...) return { n = select(\"#\", ...), ... } end end")
	line_21_1(out, "if not table.unpack then table.unpack = unpack end")
	line_21_1(out, "local load = load if _VERSION:find(\"5.1\") then load = function(x, n, _, env) local f, e = loadstring(x, n) if not f then return f, e end if env then setfenv(f, env) end return f end end")
	return line_21_1(out, "local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error")
end)
expression2 = (function(node, out, state, ret)
	local passState = createPassState1(state)
	runPass1(letrecNode1, state, nil, node, passState)
	runPass1(categoriseNode1, state, nil, node, passState, ret ~= nil)
	return compileExpression1(node, out, passState, ret)
end)
block2 = (function(nodes, out, state, start, ret)
	local passState = createPassState1(state)
	runPass1(letrecNodes1, state, nil, nodes, passState)
	runPass1(categoriseNodes1, state, nil, nodes, passState)
	return compileBlock1(nodes, out, passState, start, ret)
end)
create4 = (function(scope, compiler)
	if scope then
	else
		error1("scope cannot be nil")
	end
	if compiler then
	else
		error1("compiler cannot be nil")
	end
	return ({["scope"]=scope,["compiler"]=compiler,["logger"]=compiler["log"],["mappings"]=compiler["compile-state"]["mappings"],["required"]=({tag = "list", n = 0}),["required-set"]=({}),["stage"]="parsed",["var"]=nil,["node"]=nil,["value"]=nil})
end)
require_21_1 = (function(state, var, user)
	if state["stage"] ~= "parsed" then
		error1("Cannot add requirement when in stage " .. state["stage"])
	end
	if var then
	else
		error1("var is nil")
	end
	if user then
	else
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
end)
define_21_1 = (function(state, var)
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
end)
built_21_1 = (function(state, node)
	if node then
	else
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
end)
executed_21_1 = (function(state, value)
	if state["stage"] ~= "built" then
		error1("Cannot transition from " .. state["stage"] .. " to executed")
	end
	state["value"] = value
	state["stage"] = "executed"
	return nil
end)
get_21_1 = (function(state)
	if state["stage"] == "executed" then
		return state["value"]
	else
		local required, requiredSet = ({tag = "list", n = 0}), ({})
		local visit
		visit = (function(state1, stack, stackHash)
			local idx = stackHash[state1]
			if idx then
				if state1["var"]["tag"] == "macro" then
					pushCdr_21_1(stack, state1)
					local states, nodes, firstNode = ({tag = "list", n = 0}), ({tag = "list", n = 0}), nil
					local temp = n1(stack)
					local temp1 = idx
					while temp1 <= temp do
						local current, previous = nth1(stack, temp1), nth1(stack, temp1 - 1)
						pushCdr_21_1(states, current["var"]["name"])
						if previous then
							local user = previous["required-set"][current]
							if firstNode then
							else
								firstNode = user
							end
							pushCdr_21_1(nodes, getSource1(user))
							pushCdr_21_1(nodes, current["var"]["name"] .. " used in " .. previous["var"]["name"])
						end
						temp1 = temp1 + 1
					end
					return doNodeError_21_1(state1["logger"], "Loop in macros " .. concat1(states, " -> "), firstNode, nil, unpack1(nodes, 1, n1(nodes)))
				else
					return nil
				end
			elseif state1["stage"] == "executed" then
				return nil
			else
				pushCdr_21_1(stack, state1)
				stackHash[state1] = n1(stack)
				if requiredSet[state1] then
				else
					requiredSet[state1] = true
					pushCdr_21_1(required, state1)
				end
				local visited = ({})
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
					yield1(({["tag"]="build",["state"]=state1}))
				end
				local temp = state1["required"]
				local temp1 = n1(temp)
				local temp2 = 1
				while temp2 <= temp1 do
					local inner = temp[temp2]
					if visited[inner] then
					else
						visit(inner, stack, stackHash)
					end
					temp2 = temp2 + 1
				end
				popLast_21_1(stack)
				stackHash[state1] = nil
				return nil
			end
		end)
		visit(state, ({tag = "list", n = 0}), ({}))
		yield1(({["tag"]="execute",["states"]=required}))
		return state["value"]
	end
end)
name1 = (function(state)
	if state["var"] then
		return "macro " .. quoted1(state["var"]["name"])
	else
		return "unquote"
	end
end)
unmangleIdent1 = (function(ident)
	local esc = match1(ident, "^(.-)%d+$")
	if esc == nil then
		return ident
	elseif sub1(esc, 1, 2) == "_e" then
		return sub1(ident, 3)
	else
		local buffer = ({tag = "list", n = 0})
		local pos = 0
		local len = n1(esc)
		while pos <= len do
			local char
			local x = pos
			char = sub1(esc, x, x)
			if char == "_" then
				local temp = list1(find1(esc, "^_[%da-z]+_", pos))
				if type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and true)) then
					local start = nth1(temp, 1)
					local _eend = nth1(temp, 2)
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
end)
remapError1 = (function(msg)
	return (gsub1(gsub1(gsub1(gsub1(msg, "local '([^']+)'", (function(x)
		return "local '" .. unmangleIdent1(x) .. "'"
	end)), "global '([^']+)'", (function(x)
		return "global '" .. unmangleIdent1(x) .. "'"
	end)), "upvalue '([^']+)'", (function(x)
		return "upvalue '" .. unmangleIdent1(x) .. "'"
	end)), "function '([^']+)'", (function(x)
		return "function '" .. unmangleIdent1(x) .. "'"
	end)))
end)
remapMessage1 = (function(mappings, msg)
	local temp = list1(match1(msg, "^(.-):(%d+)(.*)$"))
	if type1(temp) == "list" and (n1(temp) >= 3 and (n1(temp) <= 3 and true)) then
		local file = nth1(temp, 1)
		local line = nth1(temp, 2)
		local extra = nth1(temp, 3)
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
end)
remapTraceback1 = (function(mappings, msg)
	return gsub1(gsub1(gsub1(gsub1(gsub1(gsub1(gsub1(msg, "^([^\n:]-:%d+:[^\n]*)", (function(temp)
		return remapMessage1(mappings, temp)
	end)), "\9([^\n:]-:%d+:)", (function(msg1)
		return "\9" .. remapMessage1(mappings, msg1)
	end)), "<([^\n:]-:%d+)>\n", (function(msg1)
		return "<" .. remapMessage1(mappings, msg1) .. ">\n"
	end)), "in local '([^']+)'\n", (function(x)
		return "in local '" .. unmangleIdent1(x) .. "'\n"
	end)), "in global '([^']+)'\n", (function(x)
		return "in global '" .. unmangleIdent1(x) .. "'\n"
	end)), "in upvalue '([^']+)'\n", (function(x)
		return "in upvalue '" .. unmangleIdent1(x) .. "'\n"
	end)), "in function '([^']+)'\n", (function(x)
		return "in function '" .. unmangleIdent1(x) .. "'\n"
	end))
end)
generateMappings1 = (function(lines)
	local outLines = ({})
	local temp, ranges = next1(lines)
	while temp ~= nil do
		local rangeLists = ({})
		local temp1 = next1(ranges)
		while temp1 ~= nil do
			local file = temp1["name"]
			local rangeList = rangeLists["file"]
			if rangeList then
			else
				rangeList = ({["n"]=0,["min"]=huge1,["max"]=0 - huge1})
				rangeLists[file] = rangeList
			end
			local temp2 = temp1["finish"]["line"]
			local temp3 = temp1["start"]["line"]
			while temp3 <= temp2 do
				if rangeList[temp3] then
				else
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
		local bestName = nil
		local bestLines = nil
		local bestCount = 0
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
end)
gethook1 = debug.gethook
getinfo1 = debug.getinfo
sethook1 = debug.sethook
traceback1 = debug.traceback
createState1 = (function(meta)
	return ({["level"]=1,["override"]=({}),["timer"]=void1,["count"]=0,["mappings"]=({}),["var-cache"]=({}),["var-lookup"]=({}),["meta"]=meta or ({})})
end)
file1 = (function(compiler, shebang)
	local state = createState1(compiler["lib-meta"])
	local out = create3()
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
		local prefix = quoted1(lib["prefix"])
		local native = lib["native"]
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
		local node = temp[temp2]
		local var = node["def-var"]
		if var then
			pushEscapeVar_21_1(var, state, true)
		end
		temp2 = temp2 + 1
	end
	if between_3f_1(count, 1, 150) then
		append_21_1(out, "local ")
		local first = true
		local temp = compiler["out"]
		local temp1 = n1(temp)
		local temp2 = 1
		while temp2 <= temp1 do
			local node = temp[temp2]
			local var = node["def-var"]
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
		line_21_1(out, "local _ENV = setmetatable({}, {__index=ENV or (getfenv and getfenv()) or _G}) if setfenv then setfenv(0, _ENV) end")
	end
	block2(compiler["out"], out, state, 1, "return ")
	return out
end)
executeStates1 = (function(backState, states, global, logger)
	local stateList = ({tag = "list", n = 0})
	local nameList = ({tag = "list", n = 0})
	local exportList = ({tag = "list", n = 0})
	local escapeList = ({tag = "list", n = 0})
	local temp = n1(states)
	while temp >= 1 do
		local state = nth1(states, temp)
		if state["stage"] == "executed" then
		else
			local node
			if state["node"] then
				node = nil
			else
				node = error1("State is in " .. state["stage"] .. " instead", 0)
			end
			local var = state["var"] or ({["name"]="temp"})
			local escaped = pushEscapeVar_21_1(var, backState, true)
			local name = var["name"]
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
		local out = create3()
		local id = backState["count"]
		local name = concat1(nameList, ",")
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
			end)()
			)
			line_21_1(out)
			temp1 = temp1 + 1
		end
		line_21_1(out, "return { " .. concat1(exportList, ", ") .. "}")
		local str = concat1(out["out"])
		backState["mappings"][name] = generateMappings1(out["lines"])
		local temp = list1(load1(str, "=" .. name, "t", global))
		if type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (eq_3f_1(nth1(temp, 1), nil) and true))) then
			local msg = nth1(temp, 2)
			local buffer = ({tag = "list", n = 0})
			local lines = split1(str, "\n")
			local format = "%" .. n1(tostring1(n1(lines))) .. "d | %s"
			local temp1 = n1(lines)
			local temp2 = 1
			while temp2 <= temp1 do
				pushCdr_21_1(buffer, format1(format, temp2, nth1(lines, temp2)))
				temp2 = temp2 + 1
			end
			return error1(msg .. ":\n" .. concat1(buffer, "\n"), 0)
		elseif type1(temp) == "list" and (n1(temp) >= 1 and (n1(temp) <= 1 and true)) then
			local fun = nth1(temp, 1)
			local temp1 = list1(xpcall1(fun, traceback1))
			if type1(temp1) == "list" and (n1(temp1) >= 2 and (n1(temp1) <= 2 and (eq_3f_1(nth1(temp1, 1), false) and true))) then
				local msg = nth1(temp1, 2)
				return error1(remapTraceback1(backState["mappings"], msg), 0)
			elseif type1(temp1) == "list" and (n1(temp1) >= 2 and (n1(temp1) <= 2 and (eq_3f_1(nth1(temp1, 1), true) and true))) then
				local tbl = nth1(temp1, 2)
				local temp2 = n1(stateList)
				local temp3 = 1
				while temp3 <= temp2 do
					local state = nth1(stateList, temp3)
					local escaped = nth1(escapeList, temp3)
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
end)
native1 = (function(meta, global)
	local out = create3()
	prelude1(out)
	append_21_1(out, "return ")
	compileNative1(out, meta)
	local temp = list1(load1(concat1(out["out"]), "=" .. meta["name"], "t", global))
	if type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (eq_3f_1(nth1(temp, 1), nil) and true))) then
		local msg = nth1(temp, 2)
		return error1("Cannot compile meta " .. meta["name"] .. ":\n" .. msg, 0)
	elseif type1(temp) == "list" and (n1(temp) >= 1 and (n1(temp) <= 1 and true)) then
		return nth1(temp, 1)()
	else
		return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `(nil ?msg)`\n  Tried: `(?fun)`")
	end
end)
emitLua1 = ({["name"]="emit-lua",["setup"]=(function(spec)
	addArgument_21_1(spec, ({tag = "list", n = 1, "--emit-lua"}), "help", "Emit a Lua file.")
	addArgument_21_1(spec, ({tag = "list", n = 1, "--shebang"}), "value", arg1[-1] or (arg1[0] or "lua"), "help", "Set the executable to use for the shebang.", "narg", "?")
	return addArgument_21_1(spec, ({tag = "list", n = 1, "--chmod"}), "help", "Run chmod +x on the resulting file")
end),["pred"]=(function(args)
	return args["emit-lua"]
end),["run"]=(function(compiler, args)
	if empty_3f_1(args["input"]) then
		self1(compiler["log"], "put-error!", "No inputs to compile.")
		exit_21_1(1)
	end
	local out = file1(compiler, args["shebang"])
	local handle = open1(args["output"] .. ".lua", "w")
	self1(handle, "write", concat1(out["out"]))
	self1(handle, "close")
	if args["chmod"] then
		return execute1("chmod +x " .. quoted1(args["output"] .. ".lua"))
	else
		return nil
	end
end)})
emitLisp1 = ({["name"]="emit-lisp",["setup"]=(function(spec)
	return addArgument_21_1(spec, ({tag = "list", n = 1, "--emit-lisp"}), "help", "Emit a Lisp file.")
end),["pred"]=(function(args)
	return args["emit-lisp"]
end),["run"]=(function(compiler, args)
	if empty_3f_1(args["input"]) then
		self1(compiler["log"], "put-error!", "No inputs to compile.")
		exit_21_1(1)
	end
	local writer = create3()
	block1(compiler["out"], writer)
	local handle = open1(args["output"] .. ".lisp", "w")
	self1(handle, "write", concat1(writer["out"]))
	return self1(handle, "close")
end)})
passArg1 = (function(arg, data, value, usage_21_)
	local val = tonumber1(value)
	local name = arg["name"] .. "-override"
	local override = data[name]
	if override then
	else
		override = ({})
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
end)
passRun1 = (function(fun, name, passes)
	return (function(compiler, args)
		return fun(compiler["out"], ({["track"]=true,["level"]=args[name],["override"]=args[name .. "-override"] or ({}),["pass"]=compiler[name],["max-n"]=args[name .. "-n"],["max-time"]=args[name .. "-time"],["compiler"]=compiler,["meta"]=compiler["lib-meta"],["libs"]=compiler["libs"],["logger"]=compiler["log"],["timer"]=compiler["timer"]}))
	end)
end)
warning1 = ({["name"]="warning",["setup"]=(function(spec)
	return addArgument_21_1(spec, ({tag = "list", n = 2, "--warning", "-W"}), "help", "Either the warning level to use or an enable/disable flag for a pass.", "default", 1, "narg", 1, "var", "LEVEL", "many", true, "action", passArg1)
end),["pred"]=(function()
	return true
end),["run"]=passRun1(analyse1, "warning")})
optimise2 = ({["name"]="optimise",["setup"]=(function(spec)
	addArgument_21_1(spec, ({tag = "list", n = 2, "--optimise", "-O"}), "help", "Either the optimisation level to use or an enable/disable flag for a pass.", "default", 1, "narg", 1, "var", "LEVEL", "many", true, "action", passArg1)
	addArgument_21_1(spec, ({tag = "list", n = 2, "--optimise-n", "--optn"}), "help", "The maximum number of iterations the optimiser should run for.", "default", 10, "narg", 1, "action", setNumAction1)
	return addArgument_21_1(spec, ({tag = "list", n = 2, "--optimise-time", "--optt"}), "help", "The maximum time the optimiser should run for.", "default", -1, "narg", 1, "action", setNumAction1)
end),["pred"]=(function()
	return true
end),["run"]=passRun1(optimise1, "optimise")})
formatRange2 = (function(range)
	return format1("%s:%s", range["name"], (function(pos)
		return pos["line"] .. ":" .. pos["column"]
	end)(range["start"]))
end)
sortVars_21_1 = (function(list)
	return sort1(list, (function(a, b)
		return car1(a) < car1(b)
	end))
end)
formatDefinition1 = (function(var)
	local ty = type1(var)
	if ty == "builtin" then
		return "Builtin term"
	elseif ty == "macro" then
		return "Macro defined at " .. formatRange2(getSource1(var["node"]))
	elseif ty == "native" then
		return "Native defined at " .. formatRange2(getSource1(var["node"]))
	elseif ty == "defined" then
		return "Defined at " .. formatRange2(getSource1(var["node"]))
	else
		_error("unmatched item")
	end
end)
formatSignature1 = (function(name, var)
	local sig = extractSignature1(var)
	if sig == nil then
		return name
	elseif empty_3f_1(sig) then
		return "(" .. name .. ")"
	else
		return "(" .. name .. " " .. concat1(map1(on1("contents"), sig), " ") .. ")"
	end
end)
writeDocstring1 = (function(out, str, scope)
	local temp = parseDocstring1(str)
	local temp1 = n1(temp)
	local temp2 = 1
	while temp2 <= temp1 do
		local tok = temp[temp2]
		local ty = type1(tok)
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
			append_21_1(out, tok["whole"])
		elseif ty == "link" then
			local name = tok["contents"]
			local ovar = get1(scope, name)
			if ovar and ovar["node"] then
				local loc = gsub1(gsub1(getSource1((ovar["node"]))["name"], "%.lisp$", ""), "/", ".")
				local sig = extractSignature1(ovar)
				append_21_1(out, format1("[`%s`](%s.md#%s)", name, loc, gsub1((function()
					if sig == nil then
						return ovar["name"]
					elseif empty_3f_1(sig) then
						return ovar["name"]
					else
						return name .. " " .. concat1(map1(on1("contents"), sig), " ")
					end
				end)()
				, "%A+", "-")))
			else
				append_21_1(out, format1("`%s`", name))
			end
		else
			_error("unmatched item")
		end
		temp2 = temp2 + 1
	end
	return line_21_1(out)
end)
exported1 = (function(out, title, primary, vars, scope)
	local documented = ({tag = "list", n = 0})
	local undocumented = ({tag = "list", n = 0})
	iterPairs1(vars, (function(name, var)
		return pushCdr_21_1((function()
			if var["doc"] then
				return documented
			else
				return undocumented
			end
		end)()
		, list1(name, var))
	end))
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
		local name = car1(entry)
		local var = nth1(entry, 2)
		line_21_1(out, "## `" .. formatSignature1(name, var) .. "`")
		line_21_1(out, "*" .. formatDefinition1(var) .. "*")
		line_21_1(out, "", true)
		if var["deprecated"] then
			line_21_1(out, (function()
				if string_3f_1(var["deprecated"]) then
					return format1("> **Warning:** %s is deprecated: %s", name, var["deprecated"])
				else
					return format1("> **Warning:** %s is deprecated.", name)
				end
			end)()
			)
			line_21_1(out, "", true)
		end
		writeDocstring1(out, var["doc"], var["scope"])
		line_21_1(out, "", true)
		temp1 = temp1 + 1
	end
	if empty_3f_1(undocumented) then
	else
		line_21_1(out, "## Undocumented symbols")
	end
	local temp = n1(undocumented)
	local temp1 = 1
	while temp1 <= temp do
		local entry = undocumented[temp1]
		local name = car1(entry)
		local var = nth1(entry, 2)
		line_21_1(out, " - `" .. formatSignature1(name, var) .. "` *" .. formatDefinition1(var) .. "*")
		temp1 = temp1 + 1
	end
	return nil
end)
docs1 = (function(compiler, args)
	if empty_3f_1(args["input"]) then
		self1(compiler["log"], "put-error!", "No inputs to generate documentation for.")
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
		local lib = compiler["lib-cache"][path]
		local writer = create3()
		exported1(writer, lib["name"], lib["docs"], lib["scope"]["exported"], lib["scope"])
		local handle = open1(args["docs"] .. "/" .. gsub1(path, "/", ".") .. ".md", "w")
		self1(handle, "write", concat1(writer["out"]))
		self1(handle, "close")
		temp2 = temp2 + 1
	end
	return nil
end)
task1 = ({["name"]="docs",["setup"]=(function(spec)
	return addArgument_21_1(spec, ({tag = "list", n = 1, "--docs"}), "help", "Specify the folder to emit documentation to.", "default", nil, "narg", 1)
end),["pred"]=(function(args)
	return nil ~= args["docs"]
end),["run"]=docs1})
config1 = package.config
coloredAnsi1 = (function(col, msg)
	return "\27[" .. col .. "m" .. msg .. "\27[0m"
end)
if config1 and sub1(config1, 1, 1) ~= "\\" then
	colored_3f_1 = true
elseif getenv1 and getenv1("ANSICON") ~= nil then
	colored_3f_1 = true
else
	local temp
	if getenv1 then
		local term = getenv1("TERM")
		if term then
			temp = find1(term, "xterm")
		else
			temp = nil
		end
	else
		temp = false
	end
	if temp then
		colored_3f_1 = true
	else
		colored_3f_1 = false
	end
end
if colored_3f_1 then
	colored1 = coloredAnsi1
else
	colored1 = (function(col, msg)
		return msg
	end)
end
local discard = (function()
	return nil
end)
void2 = ({["put-error!"]=discard,["put-warning!"]=discard,["put-verbose!"]=discard,["put-debug!"]=discard,["put-time!"]=discard,["put-node-error!"]=discard,["put-node-warning!"]=discard})
hexDigit_3f_1 = (function(char)
	return between_3f_1(char, "0", "9") or (between_3f_1(char, "a", "f") or between_3f_1(char, "A", "F"))
end)
binDigit_3f_1 = (function(char)
	return char == "0" or char == "1"
end)
terminator_3f_1 = (function(char)
	return char == "\n" or (char == " " or (char == "\9" or (char == ";" or (char == "(" or (char == ")" or (char == "[" or (char == "]" or (char == "{" or (char == "}" or char == "")))))))))
end)
digitError_21_1 = (function(logger, pos, name, char)
	return doNodeError_21_1(logger, format1("Expected %s digit, got %s", name, (function()
		if char == "" then
			return "eof"
		else
			return quoted1(char)
		end
	end)()
	), pos, nil, pos, "Invalid digit here")
end)
eofError_21_1 = (function(cont, logger, msg, node, explain, ...)
	local lines = _pack(...) lines.tag = "list"
	if cont then
		return error1(({["msg"]=msg,["cont"]=true}), 0)
	else
		return doNodeError_21_1(logger, msg, node, explain, unpack1(lines, 1, n1(lines)))
	end
end)
lex1 = (function(logger, str, name, cont)
	str = gsub1(str, "\13\n?", "\n")
	local lines = split1(str, "\n")
	local line = 1
	local column = 1
	local offset = 1
	local length = n1(str)
	local out = ({tag = "list", n = 0})
	local consume_21_ = (function()
		if (function(xs, x)
			return sub1(xs, x, x)
		end)(str, offset) == "\n" then
			line = line + 1
			column = 1
		else
			column = column + 1
		end
		offset = offset + 1
		return nil
	end)
	local range = (function(start, finish)
		return ({["start"]=start,["finish"]=finish or start,["lines"]=lines,["name"]=name})
	end)
	local appendWith_21_ = (function(data, start, finish)
		local start1, finish1 = start or ({["line"]=line,["column"]=column,["offset"]=offset}), finish or ({["line"]=line,["column"]=column,["offset"]=offset})
		data["range"] = range(start1, finish1)
		data["contents"] = sub1(str, start1["offset"], finish1["offset"])
		return pushCdr_21_1(out, data)
	end)
	local parseBase = (function(name2, p, base)
		local start = offset
		local char
		local xs, x = str, offset
		char = sub1(xs, x, x)
		if p(char) then
		else
			digitError_21_1(logger, range(({["line"]=line,["column"]=column,["offset"]=offset})), name2, char)
		end
		local xs, x = str, offset + 1
		char = sub1(xs, x, x)
		while p(char) do
			consume_21_()
			local xs, x = str, offset + 1
			char = sub1(xs, x, x)
		end
		return tonumber1(sub1(str, start, offset), base)
	end)
	while offset <= length do
		local char
		local xs, x = str, offset
		char = sub1(xs, x, x)
		if char == "\n" or (char == "\9" or char == " ") then
		elseif char == "(" then
			appendWith_21_(({["tag"]="open",["close"]=")"}))
		elseif char == ")" then
			appendWith_21_(({["tag"]="close",["open"]="("}))
		elseif char == "[" then
			appendWith_21_(({["tag"]="open",["close"]="]"}))
		elseif char == "]" then
			appendWith_21_(({["tag"]="close",["open"]="["}))
		elseif char == "{" then
			appendWith_21_(({["tag"]="open-struct",["close"]="}"}))
		elseif char == "}" then
			appendWith_21_(({["tag"]="close",["open"]="{"}))
		elseif char == "'" then
			local start, finish
			appendWith_21_(({["tag"]="quote"}), nil, nil)
		elseif char == "`" then
			local start, finish
			appendWith_21_(({["tag"]="syntax-quote"}), nil, nil)
		elseif char == "~" then
			local start, finish
			appendWith_21_(({["tag"]="quasiquote"}), nil, nil)
		elseif char == "," then
			if (function(xs, x)
				return sub1(xs, x, x)
			end)(str, offset + 1) == "@" then
				local start = ({["line"]=line,["column"]=column,["offset"]=offset})
				consume_21_()
				local finish
				appendWith_21_(({["tag"]="unquote-splice"}), start, nil)
			else
				local start, finish
				appendWith_21_(({["tag"]="unquote"}), nil, nil)
			end
		elseif find1(str, "^%-?%.?[#0-9]", offset) then
			local start, negative = ({["line"]=line,["column"]=column,["offset"]=offset}), char == "-"
			if negative then
				consume_21_()
				local xs, x = str, offset
				char = sub1(xs, x, x)
			end
			local val
			if char == "#" and lower1((function(xs, x)
				return sub1(xs, x, x)
			end)(str, offset + 1)) == "x" then
				consume_21_()
				consume_21_()
				local res = parseBase("hexadecimal", hexDigit_3f_1, 16)
				if negative then
					res = 0 - res
				end
				val = res
			elseif char == "#" and lower1((function(xs, x)
				return sub1(xs, x, x)
			end)(str, offset + 1)) == "b" then
				consume_21_()
				consume_21_()
				local res = parseBase("binary", binDigit_3f_1, 2)
				if negative then
					res = 0 - res
				end
				val = res
			elseif char == "#" and terminator_3f_1(lower1((function(xs, x)
				return sub1(xs, x, x)
			end)(str, offset + 1))) then
				val = doNodeError_21_1(logger, "Expected hexadecimal (#x) or binary (#b) digit.", range(({["line"]=line,["column"]=column,["offset"]=offset})), "The '#' character is used for various number representations, such as binary\nand hexadecimal digits.\n\nIf you're looking for the '#' function, this has been replaced with 'n'. We\napologise for the inconvenience.", range(({["line"]=line,["column"]=column,["offset"]=offset})), "# must be followed by x or b")
			elseif char == "#" then
				consume_21_()
				val = doNodeError_21_1(logger, "Expected hexadecimal (#x) or binary (#b) digit specifier.", range(({["line"]=line,["column"]=column,["offset"]=offset})), "The '#' character is used for various number representations, namely binary\nand hexadecimal digits.", range(({["line"]=line,["column"]=column,["offset"]=offset})), "# must be followed by x or b")
			else
				while between_3f_1((function(xs, x)
					return sub1(xs, x, x)
				end)(str, offset + 1), "0", "9") do
					consume_21_()
				end
				if (function(xs, x)
					return sub1(xs, x, x)
				end)(str, offset + 1) == "." then
					consume_21_()
					while between_3f_1((function(xs, x)
						return sub1(xs, x, x)
					end)(str, offset + 1), "0", "9") do
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
					while between_3f_1((function(xs, x)
						return sub1(xs, x, x)
					end)(str, offset + 1), "0", "9") do
						consume_21_()
					end
				end
				val = tonumber1(sub1(str, start["offset"], offset))
			end
			appendWith_21_(({["tag"]="number",["value"]=val}), start)
			local xs, x = str, offset + 1
			char = sub1(xs, x, x)
			if terminator_3f_1(char) then
			else
				consume_21_()
				doNodeError_21_1(logger, format1("Expected digit, got %s", (function()
					if char == "" then
						return "eof"
					else
						return char
					end
				end)()
				), range(({["line"]=line,["column"]=column,["offset"]=offset})), nil, range(({["line"]=line,["column"]=column,["offset"]=offset})), "Illegal character here. Are you missing whitespace?")
			end
		elseif char == "\"" or char == "$" and (function(xs, x)
			return sub1(xs, x, x)
		end)(str, offset + 1) == "\"" then
			local start = ({["line"]=line,["column"]=column,["offset"]=offset})
			local startCol = column + 1
			local buffer = ({tag = "list", n = 0})
			local interpolate = char == "$"
			if interpolate then
				consume_21_()
			end
			consume_21_()
			local xs, x = str, offset
			char = sub1(xs, x, x)
			while char ~= "\"" do
				if column == 1 then
					local running = true
					local lineOff = offset
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
							putNodeWarning_21_1(logger, format1("Expected leading indent, got %q", char), range(({["line"]=line,["column"]=column,["offset"]=offset})), "You should try to align multi-line strings at the initial quote\nmark. This helps keep programs neat and tidy.", range(start), "String started with indent here", range(({["line"]=line,["column"]=column,["offset"]=offset})), "Mis-aligned character here")
							pushCdr_21_1(buffer, sub1(str, lineOff, offset - 1))
							running = false
						end
						local xs, x = str, offset
						char = sub1(xs, x, x)
					end
				end
				if char == "" then
					local start1, finish = range(start), range(({["line"]=line,["column"]=column,["offset"]=offset}))
					eofError_21_1(cont, logger, "Expected '\"', got eof", finish, nil, start1, "string started here", finish, "end of file here")
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
					elseif char == "x" or (char == "X" or between_3f_1(char, "0", "9")) then
						local start1 = ({["line"]=line,["column"]=column,["offset"]=offset})
						local val
						if char == "x" or char == "X" then
							consume_21_()
							local start2 = offset
							if hexDigit_3f_1((function(xs, x)
								return sub1(xs, x, x)
							end)(str, offset)) then
							else
								digitError_21_1(logger, range(({["line"]=line,["column"]=column,["offset"]=offset})), "hexadecimal", (function(xs, x)
									return sub1(xs, x, x)
								end)(str, offset))
							end
							if hexDigit_3f_1((function(xs, x)
								return sub1(xs, x, x)
							end)(str, offset + 1)) then
								consume_21_()
							end
							val = tonumber1(sub1(str, start2, offset), 16)
						else
							local start2, ctr = ({["line"]=line,["column"]=column,["offset"]=offset}), 0
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
							doNodeError_21_1(logger, "Invalid escape code", range(start1), nil, range(start1, ({["line"]=line,["column"]=column,["offset"]=offset})), "Must be between 0 and 255, is " .. val)
						end
						pushCdr_21_1(buffer, char1(val))
					elseif char == "" then
						eofError_21_1(cont, logger, "Expected escape code, got eof", range(({["line"]=line,["column"]=column,["offset"]=offset})), nil, range(({["line"]=line,["column"]=column,["offset"]=offset})), "end of file here")
					else
						doNodeError_21_1(logger, "Illegal escape character", range(({["line"]=line,["column"]=column,["offset"]=offset})), nil, range(({["line"]=line,["column"]=column,["offset"]=offset})), "Unknown escape character")
					end
				else
					pushCdr_21_1(buffer, char)
				end
				consume_21_()
				local xs, x = str, offset
				char = sub1(xs, x, x)
			end
			if interpolate then
				appendWith_21_(({["tag"]="interpolate",["value"]=concat1(buffer)}), start)
			else
				appendWith_21_(({["tag"]="string",["value"]=concat1(buffer)}), start)
			end
		elseif char == ";" then
			while offset <= length and (function(xs, x)
				return sub1(xs, x, x)
			end)(str, offset + 1) ~= "\n" do
				consume_21_()
			end
		else
			local start, key = ({["line"]=line,["column"]=column,["offset"]=offset}), char == ":"
			local xs, x = str, offset + 1
			char = sub1(xs, x, x)
			while not terminator_3f_1(char) do
				consume_21_()
				local xs, x = str, offset + 1
				char = sub1(xs, x, x)
			end
			if key then
				appendWith_21_(({["tag"]="key",["value"]=sub1(str, start["offset"] + 1, offset)}), start)
			else
				local finish
				appendWith_21_(({["tag"]="symbol"}), start, nil)
			end
		end
		consume_21_()
	end
	local start, finish
	appendWith_21_(({["tag"]="eof"}), nil, nil)
	return out
end)
parse1 = (function(logger, toks, cont)
	local head = ({tag = "list", n = 0})
	local stack = ({tag = "list", n = 0})
	local push_21_ = (function()
		local next = ({tag = "list", n = 0})
		pushCdr_21_1(stack, head)
		pushCdr_21_1(head, next)
		head = next
		return nil
	end)
	local pop_21_ = (function()
		head["open"] = nil
		head["close"] = nil
		head["auto-close"] = nil
		head["last-node"] = nil
		head = last1(stack)
		return popLast_21_1(stack)
	end)
	local temp = n1(toks)
	local temp1 = 1
	while temp1 <= temp do
		local tok = toks[temp1]
		local tag = tok["tag"]
		local autoClose = false
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
		if tag == "string" or (tag == "number" or (tag == "symbol" or tag == "key")) then
			pushCdr_21_1(head, tok)
		elseif tag == "interpolate" then
			local node = ({["tag"]="list",["n"]=2,["range"]=tok["range"],[1]=({["tag"]="symbol",["contents"]="$",["range"]=({["start"]=tok["range"]["start"],["finish"]=tok["range"]["start"],["name"]=tok["range"]["name"],["lines"]=tok["range"]["lines"]})}),[2]=({["tag"]="string",["value"]=tok["value"],["range"]=tok["range"]})})
			pushCdr_21_1(head, node)
		elseif tag == "open" then
			push_21_()
			head["open"] = tok["contents"]
			head["close"] = tok["close"]
			head["range"] = ({["start"]=tok["range"]["start"],["name"]=tok["range"]["name"],["lines"]=tok["range"]["lines"]})
		elseif tag == "open-struct" then
			push_21_()
			head["open"] = tok["contents"]
			head["close"] = tok["close"]
			head["range"] = ({["start"]=tok["range"]["start"],["name"]=tok["range"]["name"],["lines"]=tok["range"]["lines"]})
			local node = ({["tag"]="symbol",["contents"]="struct-literal",["range"]=head["range"]})
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
		elseif tag == "quote" or (tag == "unquote" or (tag == "syntax-quote" or (tag == "unquote-splice" or tag == "quasiquote"))) then
			push_21_()
			head["range"] = ({["start"]=tok["range"]["start"],["name"]=tok["range"]["name"],["lines"]=tok["range"]["lines"]})
			local node = ({["tag"]="symbol",["contents"]=tag,["range"]=tok["range"]})
			pushCdr_21_1(head, node)
			autoClose = true
			head["auto-close"] = true
		elseif tag == "eof" then
			if 0 ~= n1(stack) then
				eofError_21_1(cont, logger, format1("Expected '%s', got 'eof'", head["close"]), tok, nil, head["range"], "block opened here", tok["range"], "end of file here")
			end
		else
			error1("Unsupported type" .. tag)
		end
		if autoClose then
		else
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
end)
read2 = (function(x, path)
	return parse1(void2, lex1(void2, x, path or ""))
end)
expectType_21_1 = (function(log, node, parent, type, name)
	if not node or node["tag"] ~= type then
		local node1, message = node or parent, "Expected " .. (name or type) .. ", got " .. (function()
			if node then
				return node["tag"]
			else
				return "nothing"
			end
		end)()
		return doNodeError_21_1(log, message, node1, nil, getSource1(node1), "")
	else
		return nil
	end
end)
expect_21_1 = (function(log, node, parent, name)
	if node then
		return nil
	else
		return doNodeError_21_1(log, "Expected " .. name .. ", got nothing", parent, nil, getSource1(parent), "")
	end
end)
maxLength_21_1 = (function(log, node, len, name)
	if n1(node) > len then
		local node1, message = nth1(node, len + 1), "Unexpected node in '" .. name .. "' (expected " .. len .. " values, got " .. n1(node) .. ")"
		return doNodeError_21_1(log, message, node1, nil, getSource1(node1), "")
	else
		return nil
	end
end)
errorInternal_21_1 = (function(log, node, message)
	return doNodeError_21_1(log, "[Internal]" .. message, node, nil, getSource1(node), "")
end)
handleMetadata1 = (function(log, node, var, start, finish)
	local i = start
	while i <= finish do
		local child = nth1(node, i)
		local temp = type1(child)
		if temp == "nil" then
			expect_21_1(log, child, node, "variable metadata")
		elseif temp == "string" then
			if var["doc"] then
				doNodeError_21_1(log, "Multiple doc strings in definition", child, nil, getSource1(child), "")
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
				doNodeError_21_1(log, "Unexpected modifier '" .. pretty1(child) .. "'", child, nil, getSource1(child), "")
			end
		else
			doNodeError_21_1(log, "Unexpected node of type " .. temp .. ", have you got too many values", child, nil, getSource1(child), "")
		end
		i = i + 1
	end
	return nil
end)
resolveExecuteResult1 = (function(owner, node, parent, scope, state)
	local temp = type_23_1(node)
	if temp == "string" then
		node = ({["tag"]="string",["value"]=node})
	elseif temp == "number" then
		node = ({["tag"]="number",["value"]=node})
	elseif temp == "boolean" then
		node = ({["tag"]="symbol",["contents"]=tostring1(node),["var"]=builtins1[node]})
	elseif temp == "table" then
		local tag = node["tag"]
		if tag == "symbol" or (tag == "string" or (tag == "number" or (tag == "key" or tag == "list"))) then
			local copy = ({})
			local temp1 = node
			local temp2, v = next1(temp1)
			while temp2 ~= nil do
				copy[temp2] = v
				temp2, v = next1(temp1, temp2)
			end
			node = copy
		else
			doNodeError_21_1(state["logger"], "Invalid node of type " .. type1(node) .. " from " .. name1(owner), parent, nil, getSource1(parent), "")
		end
	else
		doNodeError_21_1(state["logger"], "Invalid node of type " .. type1(node) .. " from " .. name1(owner), parent, nil, getSource1(parent), "")
	end
	if node["range"] or node["parent"] then
	else
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
			if var then
			else
				local log, node1, message = state["logger"], node, "Invalid variable key " .. quoted1(node["var"]) .. " for " .. pretty1(node)
				doNodeError_21_1(log, message, node1, nil, getSource1(node1), "")
			end
			node["var"] = var
		end
	end
	return node
end)
resolveQuote1 = (function(node, scope, state, level)
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
			if node["var"] then
			else
				node["var"] = getAlways_21_1(scope, node["contents"], node)
				if node["var"]["scope"]["is-root"] or node["var"]["scope"]["builtin"] then
				else
					doNodeError_21_1(state["logger"], "Cannot use non-top level definition '" .. node["var"]["name"] .. "' in syntax-quote", node, nil, getSource1(node), "")
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
end)
resolveNode1 = (function(node, scope, state, root, many)
	while true do
		local temp = type1(node)
		if temp == "number" then
			return node
		elseif temp == "string" then
			return node
		elseif temp == "key" then
			return node
		elseif temp == "symbol" then
			if node["var"] then
			else
				node["var"] = getAlways_21_1(scope, node["contents"], node)
			end
			if node["var"]["tag"] == "builtin" then
				doNodeError_21_1(state["logger"], "Cannot have a raw builtin.", node, nil, getSource1(node), "")
			end
			require_21_1(state, node["var"], node)
			return node
		elseif temp == "list" then
			local first = car1(node)
			local temp1 = type1(first)
			if temp1 == "symbol" then
				if first["var"] then
				else
					first["var"] = getAlways_21_1(scope, first["contents"], first)
				end
				local func = first["var"]
				local funcState = require_21_1(state, func, first)
				local temp2 = func["tag"]
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
									doNodeError_21_1(state["logger"], "Cannot have multiple variadic arguments", args, nil, getSource1(args), "")
								elseif n1(name) == 1 then
									doNodeError_21_1(state["logger"], (function()
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
									end)()
									, arg, nil, getSource1(arg), "")
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
							doNodeError_21_1(state["logger"], "Cannot rebind constant " .. var["name"], node, nil, getSource1(node), "")
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
						local result, states = ({tag = "list", n = 0}), ({tag = "list", n = 0})
						local temp3 = n1(node)
						local temp4 = 2
						while temp4 <= temp3 do
							local childState = create4(scope, state["compiler"])
							local built = resolveNode1(nth1(node, temp4), scope, childState)
							built_21_1(childState, ({["tag"]="list",["n"]=3,["range"]=built["range"],["owner"]=built["owner"],["parent"]=node,[1]=({["tag"]="symbol",["contents"]="lambda",["var"]=builtins1["lambda"]}),[2]=({tag = "list", n = 0}),[3]=built}))
							local func1 = get_21_1(childState)
							state["compiler"]["active-scope"] = scope
							state["compiler"]["active-node"] = built
							local temp5 = list1(xpcall1(func1, traceback1))
							if type1(temp5) == "list" and (n1(temp5) >= 2 and (n1(temp5) <= 2 and (eq_3f_1(nth1(temp5, 1), false) and true))) then
								local msg = nth1(temp5, 2)
								doNodeError_21_1(state["logger"], remapTraceback1(state["mappings"], msg), node, nil, getSource1(node), "")
							elseif type1(temp5) == "list" and (n1(temp5) >= 1 and (eq_3f_1(nth1(temp5, 1), true) and true)) then
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
									doNodeError_21_1(log, message, node1, nil, getSource1(node1), "")
								end
							else
								error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp5) .. ", but none matched.\n" .. "  Tried: `(false ?msg)`\n  Tried: `(true . ?replacement)`")
							end
							temp4 = temp4 + 1
						end
						if n1(result) == 0 or n1(result) == 1 and car1(result) == nil then
							result = list1(({["tag"]="symbol",["contents"]="nil",["var"]=builtins1["nil"]}))
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
							return doNodeError_21_1(state["logger"], "Multiple values returned in a non block context", node, nil, getSource1(node), "")
						end
					elseif func == builtins1["unquote-splice"] then
						maxLength_21_1(state["logger"], node, 2, "unquote-splice")
						local childState = create4(scope, state["compiler"])
						local built = resolveNode1(nth1(node, 2), scope, childState)
						built_21_1(childState, ({["tag"]="list",["n"]=3,["range"]=built["range"],["owner"]=built["owner"],["parent"]=node,[1]=({["tag"]="symbol",["contents"]="lambda",["var"]=builtins1["lambda"]}),[2]=({tag = "list", n = 0}),[3]=built}))
						local func1 = get_21_1(childState)
						state["compiler"]["active-scope"] = scope
						state["compiler"]["active-node"] = built
						local temp3 = list1(xpcall1(func1, traceback1))
						if type1(temp3) == "list" and (n1(temp3) >= 2 and (n1(temp3) <= 2 and (eq_3f_1(nth1(temp3, 1), false) and true))) then
							local msg = nth1(temp3, 2)
							return doNodeError_21_1(state["logger"], remapTraceback1(state["mappings"], msg), node, nil, getSource1(node), "")
						elseif type1(temp3) == "list" and (n1(temp3) >= 1 and (eq_3f_1(nth1(temp3, 1), true) and true)) then
							local replacement = slice1(temp3, 2)
							local result = car1(replacement)
							if type1(result) == "list" then
							else
								doNodeError_21_1(state["logger"], "Expected list from unquote-splice, got '" .. type1(result) .. "'", node, nil, getSource1(node), "")
							end
							if n1(result) == 0 then
								result = list1(({["tag"]="symbol",["contents"]="nil",["var"]=builtins1["nil"]}))
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
								return doNodeError_21_1(state["logger"], "Multiple values returned in a non-block context", node, nil, getSource1(node), "")
							end
						else
							return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp3) .. ", but none matched.\n" .. "  Tried: `(false ?msg)`\n  Tried: `(true . ?replacement)`")
						end
					elseif func == builtins1["define"] then
						if root then
						else
							doNodeError_21_1(state["logger"], "define can only be used on the top level", first, nil, getSource1(first), "")
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
						if root then
						else
							doNodeError_21_1(state["logger"], "define-macro can only be used on the top level", first, nil, getSource1(first), "")
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
						if root then
						else
							doNodeError_21_1(state["logger"], "define-native can only be used on the top level", first, nil, getSource1(first), "")
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
								symbols = ({})
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
						yield1(({["tag"]="import",["module"]=nth1(node, 2)["contents"],["as"]=as,["symbols"]=symbols,["export"]=(function(export)
							if export then
								expectType_21_1(state["logger"], export, node, "key", "import modifier")
								if export["value"] == "export" then
									return true
								else
									return doNodeError_21_1(state["logger"], "unknown import modifier", export, nil, getSource1(export), "")
								end
							else
								return export
							end
						end)(nth1(node, exportIdx)),["scope"]=scope}))
						return node
					elseif func == builtins1["struct-literal"] then
						if n1(node) % 2 ~= 1 then
							doNodeError_21_1(state["logger"], "Expected an even number of arguments, got " .. n1(node) - 1, node, nil, getSource1(node), "")
						end
						return resolveList1(node, 2, scope, state)
					else
						return errorInternal_21_1(state["logger"], node, "Unknown builtin " .. (function()
							if func then
								return func["name"]
							else
								return "?"
							end
						end)()
						)
					end
				elseif temp2 == "macro" then
					if funcState then
					else
						errorInternal_21_1(state["logger"], first, "Macro is not defined correctly")
					end
					local builder = get_21_1(funcState)
					if type1(builder) ~= "function" then
						doNodeError_21_1(state["logger"], "Macro is of type " .. type1(builder), first, nil, getSource1(first), "")
					end
					state["compiler"]["active-scope"] = scope
					state["compiler"]["active-node"] = node
					local temp3 = list1(xpcall1((function()
						return builder(unpack1(node, 2, n1(node)))
					end), traceback1))
					if type1(temp3) == "list" and (n1(temp3) >= 2 and (n1(temp3) <= 2 and (eq_3f_1(nth1(temp3, 1), false) and true))) then
						local msg = nth1(temp3, 2)
						return doNodeError_21_1(state["logger"], remapTraceback1(state["mappings"], msg), first, nil, getSource1(first), "")
					elseif type1(temp3) == "list" and (n1(temp3) >= 1 and (eq_3f_1(nth1(temp3, 1), true) and true)) then
						local replacement = slice1(temp3, 2)
						local temp4 = n1(replacement)
						local temp5 = 1
						while temp5 <= temp4 do
							replacement[temp5] = resolveExecuteResult1(funcState, nth1(replacement, temp5), node, scope, state)
							temp5 = temp5 + 1
						end
						if n1(replacement) == 0 then
							return doNodeError_21_1(state["logger"], "Expected some value from " .. name1(funcState) .. ", got nothing", node, nil, getSource1(node), "")
						elseif n1(replacement) == 1 then
							node = car1(replacement)
						elseif many then
							replacement["tag"] = "many"
							return replacement
						else
							return doNodeError_21_1(state["logger"], "Multiple values returned in a non-block context.", node, nil, getSource1(node), "")
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
				return doNodeError_21_1(log, message, node1, nil, getSource1(node1), "")
			end
		else
			return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"number\"`\n  Tried: `\"string\"`\n  Tried: `\"key\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`")
		end
	end
end)
resolveList1 = (function(nodes, start, scope, state)
	local temp = n1(nodes)
	local temp1 = start
	while temp1 <= temp do
		nodes[temp1] = resolveNode1(nth1(nodes, temp1), scope, state)
		temp1 = temp1 + 1
	end
	return nodes
end)
resolveBlock1 = (function(nodes, start, scope, state)
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
end)
resolve1 = (function(node, scope, state)
	node = resolveNode1(node, scope, state, true, true)
	while node["tag"] == "many" and n1(node) == 1 do
		node = resolveNode1(car1(node), scope, state, true, true)
	end
	return node
end)
distance1 = (function(a, b)
	if a == b then
		return 0
	elseif n1(a) == 0 then
		return n1(b)
	elseif n1(b) == 0 then
		return n1(a)
	else
		local v0, v1 = ({tag = "list", n = 0}), ({tag = "list", n = 0})
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
end)
compile1 = (function(compiler, nodes, scope, name)
	local queue, states, loader, logger, timer = ({tag = "list", n = 0}), ({tag = "list", n = 0}), compiler["loader"], compiler["log"], compiler["timer"]
	if name then
		name = "[resolve] " .. name
	end
	local temp = list1(gethook1())
	if type1(temp) == "list" and (n1(temp) >= 3 and (n1(temp) <= 3 and true)) then
		local hook = nth1(temp, 1)
		local hookMask = nth1(temp, 2)
		local hookCount = nth1(temp, 3)
		local temp1 = n1(nodes)
		local temp2 = 1
		while temp2 <= temp1 do
			local node, state, co = nth1(nodes, temp2), create4(scope, compiler), create2(resolve1)
			pushCdr_21_1(states, state)
			if hook then
				sethook1(co, hook, hookMask, hookCount)
			end
			pushCdr_21_1(queue, ({["tag"]="init",["node"]=node,["_co"]=co,["_state"]=state,["_node"]=node,["_idx"]=temp2}))
			temp2 = temp2 + 1
		end
		local skipped = 0
		local resume = (function(action, ...)
			local args = _pack(...) args.tag = "list"
			skipped = 0
			compiler["active-scope"] = action["_active-scope"]
			compiler["active-node"] = action["_active-node"]
			local temp1 = list1(resume1(action["_co"], unpack1(args, 1, n1(args))))
			if type1(temp1) == "list" and (n1(temp1) >= 2 and (n1(temp1) <= 2 and true)) then
				local status = nth1(temp1, 1)
				local result = nth1(temp1, 2)
				if not status then
					error1(result, 0)
				elseif status1(action["_co"]) == "dead" then
					if result["tag"] == "many" then
						local baseIdx = action["_idx"]
						self1(logger, "put-debug!", "  Got multiple nodes as a result. Adding to queue")
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
							local state = create4(scope, compiler)
							if temp3 == 1 then
								states[baseIdx] = state
							else
								insertNth_21_1(states, baseIdx + (temp3 - 1), state)
							end
							local co = create2(resolve1)
							if hook then
								sethook1(co, hook, hookMask, hookCount)
							end
							pushCdr_21_1(queue, ({["tag"]="init",["node"]=nth1(result, temp3),["_co"]=co,["_state"]=state,["_node"]=nth1(result, temp3),["_idx"]=baseIdx + (temp3 - 1)}))
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
		end)
		if name then
			startTimer_21_1(timer, name, 2)
		end
		while n1(queue) > 0 and skipped <= n1(queue) do
			local head = removeNth_21_1(queue, 1)
			self1(logger, "put-debug!", (head["tag"] .. " for " .. head["_state"]["stage"] .. " at " .. formatNode1(head["_node"]) .. " (" .. (function()
				if head["_state"]["var"] then
					return head["_state"]["var"]["name"]
				else
					return "?"
				end
			end)()
			 .. ")"))
			local temp1 = head["tag"]
			if temp1 == "init" then
				resume(head, head["node"], scope, head["_state"])
			elseif temp1 == "define" then
				if scope["variables"][head["name"]] then
					resume(head, scope["variables"][head["name"]])
				else
					self1(logger, "put-debug!", ("  Awaiting definiion of " .. head["name"]))
					skipped = skipped + 1
					pushCdr_21_1(queue, head)
				end
			elseif temp1 == "build" then
				if head["state"]["stage"] ~= "parsed" then
					resume(head)
				else
					self1(logger, "put-debug!", ("  Awaiting building of node " .. (function()
						if head["state"]["var"] then
							return head["state"]["var"]["name"]
						else
							return "?"
						end
					end)()
					))
					skipped = skipped + 1
					pushCdr_21_1(queue, head)
				end
			elseif temp1 == "execute" then
				executeStates1(compiler["compile-state"], head["states"], compiler["global"], logger)
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
				if module then
				else
					doNodeError_21_1(logger, nth1(result, 2), head["_node"], nil, getSource1(head["_node"]), "")
				end
				local export = head["export"]
				local scope1 = head["scope"]
				local node = head["_node"]
				local temp2 = module["scope"]["exported"]
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
					local temp2 = head["symbols"]
					local temp3, nameNode = next1(temp2)
					while temp3 ~= nil do
						if module["scope"]["exported"][temp3] then
						else
							putNodeError_21_1(logger, "Cannot find " .. temp3, nameNode, nil, getSource1(head["_node"]), "Importing here", getSource1(nameNode), "Required here")
						end
						temp3, nameNode = next1(temp2, temp3)
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
			local temp2 = entry["tag"]
			if temp2 == "define" then
				local info = nil
				local suggestions = ""
				local scope1 = entry["scope"]
				if scope1 then
					local vars, varDis, varSet, distances = ({tag = "list", n = 0}), ({tag = "list", n = 0}), ({}), ({})
					while scope1 do
						local temp3 = scope1["variables"]
						local temp4, _5f_ = next1(temp3)
						while temp4 ~= nil do
							if varSet[temp4] then
							else
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
					sort1(vars)
					sort1(varDis, (function(a, b)
						return distances[a] < distances[b]
					end))
					local elems
					local temp3
					local xs = filter1((function(x)
						return distances[x] <= 0.5
					end), varDis)
					temp3 = slice1(xs, 1, min1(5, n1(xs)))
					elems = map1((function(temp4)
						return colored1("1;32", temp4)
					end), temp3)
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
				self1(logger, "put-error!", ("Could not build " .. (function()
					if var then
						return var["name"]
					elseif node then
						return formatNode1(node)
					else
						return "unknown node"
					end
				end)()
				))
			else
				error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp2) .. ", but none matched.\n" .. "  Tried: `\"define\"`\n  Tried: `\"build\"`")
			end
			temp1 = temp1 + 1
		end
		error1("Node resolution failed", 0)
	end
	if name then
		stopTimer_21_1(timer, name)
	end
	return unpack1(list1(map1(on1("node"), states), states))
end)
requiresInput1 = (function(str)
	local temp = list1(pcall1((function()
		return parse1(void2, lex1(void2, str, "<stdin>", true), true)
	end)))
	if type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (eq_3f_1(nth1(temp, 1), true) and true))) then
		return false
	elseif type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (eq_3f_1(nth1(temp, 1), false) and type_23_1((nth1(temp, 2))) == "table"))) then
		if nth1(temp, 2)["cont"] then
			return true
		else
			return false
		end
	elseif type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (eq_3f_1(nth1(temp, 1), false) and true))) then
		print1("x = " .. pretty1((nth1(temp, 2))))
		return nil
	else
		return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `(true _)`\n  Tried: `(false (table? @ ?x))`\n  Tried: `(false ?x)`")
	end
end)
doResolve1 = (function(compiler, scope, str)
	local logger = compiler["log"]
	return cadr1(list1(compile1(compiler, parse1(logger, (lex1(logger, str, "<stdin>"))), scope)))
end)
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
colourFor1 = (function(elem)
	if assoc_3f_1(replColourScheme1, ({["tag"]="symbol",["contents"]=elem})) then
		return constVal1(assoc1(replColourScheme1, ({["tag"]="symbol",["contents"]=elem})))
	else
		if elem == "text" then
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
		else
			return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(elem) .. ", but none matched.\n" .. "  Tried: `\"text\"`\n  Tried: `\"arg\"`\n  Tried: `\"mono\"`\n  Tried: `\"bold\"`\n  Tried: `\"italic\"`\n  Tried: `\"link\"`")
		end
	end
end)
printDocs_21_1 = (function(str)
	local docs = parseDocstring1(str)
	local temp = n1(docs)
	local temp1 = 1
	while temp1 <= temp do
		local tok = docs[temp1]
		local tag = tok["tag"]
		if tag == "bolic" then
			write1(colored1(colourFor1("bold"), colored1(colourFor1("italic"), tok["contents"])))
		else
			write1(colored1(colourFor1(tag), tok["contents"]))
		end
		temp1 = temp1 + 1
	end
	return print1()
end)
execCommand1 = (function(compiler, scope, args)
	local logger = compiler["log"]
	local command = car1(args)
	if command == "help" or command == "h" then
		return print1("REPL commands:\n[:d]oc NAME        Get documentation about a symbol\n:scope             Print out all variables in the scope\n[:s]earch QUERY    Search the current scope for symbols and documentation containing a string.\n:module NAME       Display a loaded module's docs and definitions.")
	elseif command == "doc" or command == "d" then
		local name = nth1(args, 2)
		if name then
			local var = get1(scope, name)
			if var == nil then
				return self1(logger, "put-error!", ("Cannot find '" .. name .. "'"))
			elseif not var["doc"] then
				return self1(logger, "put-error!", ("No documentation for '" .. name .. "'"))
			else
				local sig = extractSignature1(var)
				local name2 = var["full-name"]
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
				print1(colored1(96, name2))
				return printDocs_21_1(var["doc"])
			end
		else
			return self1(logger, "put-error!", ":doc <variable>")
		end
	elseif command == "module" then
		local name = nth1(args, 2)
		if name then
			local mod = compiler["lib-names"][name]
			if mod == nil then
				return self1(logger, "put-error!", ("Cannot find '" .. name .. "'"))
			else
				print1(colored1(96, mod["name"]))
				if mod["docs"] then
					printDocs_21_1(mod["docs"])
					print1()
				end
				print1(colored1(92, "Exported symbols"))
				local vars = ({tag = "list", n = 0})
				local temp = mod["scope"]["exported"]
				local temp1 = next1(temp)
				while temp1 ~= nil do
					pushCdr_21_1(vars, temp1)
					temp1 = next1(temp, temp1)
				end
				sort1(vars)
				return print1(concat1(vars, "  "))
			end
		else
			return self1(logger, "put-error!", ":module <variable>")
		end
	elseif command == "scope" then
		local vars = ({tag = "list", n = 0})
		local varsSet = ({})
		local current = scope
		while current do
			local temp = current["variables"]
			local temp1, var = next1(temp)
			while temp1 ~= nil do
				if varsSet[temp1] then
				else
					pushCdr_21_1(vars, temp1)
					varsSet[temp1] = true
				end
				temp1, var = next1(temp, temp1)
			end
			current = current["parent"]
		end
		sort1(vars)
		return print1(concat1(vars, "  "))
	elseif command == "search" or command == "s" then
		if n1(args) > 1 then
			local keywords = map1(lower1, cdr1(args))
			local nameResults = ({tag = "list", n = 0})
			local docsResults = ({tag = "list", n = 0})
			local vars = ({tag = "list", n = 0})
			local varsSet = ({})
			local current = scope
			while current do
				local temp = current["variables"]
				local temp1, var = next1(temp)
				while temp1 ~= nil do
					if varsSet[temp1] then
					else
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
				return self1(logger, "put-error!", "No results")
			else
				if not empty_3f_1(nameResults) then
					print1(colored1(92, "Search by function name:"))
					if n1(nameResults) > 20 then
						print1(concat1(slice1(nameResults, 1, min1(20, n1(nameResults))), "  ") .. "  ...")
					else
						print1(concat1(nameResults, "  "))
					end
				end
				if not empty_3f_1(docsResults) then
					print1(colored1(92, "Search by function docs:"))
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
			return self1(logger, "put-error!", ":search <keywords>")
		end
	else
		return self1(logger, "put-error!", ("Unknown command '" .. command .. "'"))
	end
end)
execString1 = (function(compiler, scope, string)
	local state = doResolve1(compiler, scope, string)
	if n1(state) > 0 then
		local current = 0
		local exec = create2((function()
			local temp = n1(state)
			local temp1 = 1
			while temp1 <= temp do
				local elem = state[temp1]
				current = elem
				get_21_1(current)
				temp1 = temp1 + 1
			end
			return nil
		end))
		local compileState = compiler["compile-state"]
		local rootScope = compiler["root-scope"]
		local global = compiler["global"]
		local logger = compiler["log"]
		local run = true
		while run do
			local res = list1(resume1(exec))
			if not car1(res) then
				self1(logger, "put-error!", (cadr1(res)))
				run = false
			elseif status1(exec) == "dead" then
				local lvl = get_21_1(last1(state))
				print1("out = " .. colored1(96, pretty1(lvl)))
				global[pushEscapeVar_21_1(add_21_1(scope, "out", "defined", lvl), compileState)] = lvl
				run = false
			else
				local states = cadr1(res)["states"]
				local latest = car1(states)
				local co = create2(executeStates1)
				local task = nil
				while run and status1(co) ~= "dead" do
					compiler["active-node"] = latest["node"]
					compiler["active-scope"] = latest["scope"]
					local res1
					if task then
						res1 = list1(resume1(co))
					else
						res1 = list1(resume1(co, compileState, states, global, logger))
					end
					compiler["active-node"] = nil
					compiler["active-scope"] = nil
					if type1(res1) == "list" and (n1(res1) >= 2 and (n1(res1) <= 2 and (eq_3f_1(nth1(res1, 1), false) and true))) then
						error1((nth1(res1, 2)), 0)
					elseif type1(res1) == "list" and (n1(res1) >= 1 and (n1(res1) <= 1 and eq_3f_1(nth1(res1, 1), true))) then
					elseif type1(res1) == "list" and (n1(res1) >= 2 and (n1(res1) <= 2 and (eq_3f_1(nth1(res1, 1), true) and true))) then
						local arg = nth1(res1, 2)
						if status1(co) ~= "dead" then
							task = arg
							local temp = task["tag"]
							if temp == "execute" then
								executeStates1(compileState, task["states"], global, logger)
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
end)
repl1 = (function(compiler)
	local scope = compiler["root-scope"]
	local logger = compiler["log"]
	local buffer = ""
	local running = true
	while running do
		write1(colored1(92, (function()
			if empty_3f_1(buffer) then
				return "> "
			else
				return ". "
			end
		end)()
		))
		flush1()
		local line = read1("*l")
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
				execCommand1(compiler, scope, map1(trim1, split1(sub1(data, 2), " ")))
			elseif line and (n1(line) > 0 and requiresInput1(data)) then
				buffer = data
			else
				buffer = ""
				scope = child1(scope)
				scope["is-root"] = true
				local res = list1(pcall1(execString1, compiler, scope, data))
				compiler["active-node"] = nil
				compiler["active-scope"] = nil
				if car1(res) then
				else
					self1(logger, "put-error!", (cadr1(res)))
				end
			end
		end
	end
	return nil
end)
exec1 = (function(compiler)
	local data = read1("*a")
	local scope = compiler["root-scope"]
	local logger = compiler["log"]
	local res = list1(pcall1(execString1, compiler, scope, data))
	if car1(res) then
	else
		self1(logger, "put-error!", (cadr1(res)))
	end
	return exit1(0)
end)
replTask1 = ({["name"]="repl",["setup"]=(function(spec)
	return addArgument_21_1(spec, ({tag = "list", n = 1, "--repl"}), "help", "Start an interactive session.")
end),["pred"]=(function(args)
	return args["repl"]
end),["run"]=repl1})
execTask1 = ({["name"]="exec",["setup"]=(function(spec)
	return addArgument_21_1(spec, ({tag = "list", n = 1, "--exec"}), "help", "Execute a program without compiling it.")
end),["pred"]=(function(args)
	return args["exec"]
end),["run"]=exec1})
profileCalls1 = (function(fn, mappings)
	local stats = ({})
	local callStack = ({tag = "list", n = 0})
	sethook1((function(action)
		local info = getinfo1(2, "Sn")
		local start = clock1()
		if action == "call" then
			local previous = nth1(callStack, n1(callStack))
			if previous then
				previous["sum"] = previous["sum"] + (start - previous["inner-start"])
			end
		end
		if action ~= "call" then
			if empty_3f_1(callStack) then
			else
				local current = popLast_21_1(callStack)
				local hash = current["source"] .. current["linedefined"]
				local entry = stats[hash]
				if entry then
				else
					entry = ({["source"]=current["source"],["short-src"]=current["short_src"],["line"]=current["linedefined"],["name"]=current["name"],["calls"]=0,["total-time"]=0,["inner-time"]=0})
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
	end), "cr")
	fn()
	sethook1()
	local out = values1(stats)
	sort1(out, (function(a, b)
		return a["inner-time"] > b["inner-time"]
	end))
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
		end)()
		, remapMessage1(mappings, entry["short-src"] .. ":" .. entry["line"]), entry["total-time"], entry["inner-time"], entry["calls"]))
		temp1 = temp1 + 1
	end
	return stats
end)
buildStack1 = (function(parent, stack, i, history, fold)
	parent["n"] = parent["n"] + 1
	if i >= 1 then
		local elem = nth1(stack, i)
		local hash = elem["source"] .. "|" .. elem["linedefined"]
		local previous = fold and history[hash]
		local child = parent[hash]
		if previous then
			parent["n"] = parent["n"] - 1
			child = previous
		end
		if child then
		else
			child = elem
			elem["n"] = 0
			parent[hash] = child
		end
		if previous then
		else
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
end)
buildRevStack1 = (function(parent, stack, i, history, fold)
	parent["n"] = parent["n"] + 1
	if i <= n1(stack) then
		local elem = nth1(stack, i)
		local hash = elem["source"] .. "|" .. elem["linedefined"]
		local previous = fold and history[hash]
		local child = parent[hash]
		if previous then
			parent["n"] = parent["n"] - 1
			child = previous
		end
		if child then
		else
			child = elem
			elem["n"] = 0
			parent[hash] = child
		end
		if previous then
		else
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
end)
finishStack1 = (function(element)
	local children = ({tag = "list", n = 0})
	local temp, child = next1(element)
	while temp ~= nil do
		if type_23_1(child) == "table" then
			pushCdr_21_1(children, child)
		end
		temp, child = next1(element, temp)
	end
	sort1(children, (function(a, b)
		return a["n"] > b["n"]
	end))
	element["children"] = children
	local temp = n1(children)
	local temp1 = 1
	while temp1 <= temp do
		finishStack1((children[temp1]))
		temp1 = temp1 + 1
	end
	return nil
end)
showStack_21_1 = (function(out, mappings, total, stack, remaining)
	line_21_1(out, format1("└ %s %s %d (%2.5f%%)", (function()
		if stack["name"] then
			return unmangleIdent1(stack["name"])
		else
			return "<unknown>"
		end
	end)()
	, (function()
		if stack["short_src"] then
			return remapMessage1(mappings, stack["short_src"] .. ":" .. stack["linedefined"])
		else
			return ""
		end
	end)()
	, stack["n"], (stack["n"] / total) * 100))
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
end)
showFlame_21_1 = (function(mappings, stack, before, remaining)
	local renamed = (function()
		if stack["name"] then
			return unmangleIdent1(stack["name"])
		else
			return "?"
		end
	end)()
	 .. "`" .. (function()
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
		local whole = before .. renamed .. ";"
		local temp = stack["children"]
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
end)
profileStack1 = (function(fn, mappings, args)
	local stacks = ({tag = "list", n = 0})
	local top = getinfo1(2, "S")
	sethook1((function(action)
		local pos = 3
		local stack = ({tag = "list", n = 0})
		local info = getinfo1(2, "Sn")
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
	end), "", 100000.0)
	fn()
	sethook1()
	local folded = ({["n"]=0,["name"]="<root>"})
	local temp = n1(stacks)
	local temp1 = 1
	while temp1 <= temp do
		local stack = stacks[temp1]
		if args["stack-kind"] == "reverse" then
			buildRevStack1(folded, stack, 1, ({}), args["stack-fold"])
		else
			buildStack1(folded, stack, n1(stack), ({}), args["stack-fold"])
		end
		temp1 = temp1 + 1
	end
	finishStack1(folded)
	if args["stack-show"] == "flame" then
		return showFlame_21_1(mappings, folded, "", args["stack-limit"] or 30)
	else
		local writer = create3()
		showStack_21_1(writer, mappings, n1(stacks), folded, args["stack-limit"] or 10)
		return print1(concat1(writer["out"]))
	end
end)
runLua1 = (function(compiler, args)
	if empty_3f_1(args["input"]) then
		self1(compiler["log"], "put-error!", "No inputs to run.")
		exit_21_1(1)
	end
	local out = file1(compiler, false)
	local lines = generateMappings1(out["lines"])
	local logger = compiler["log"]
	local name = (args["output"] or "out") .. ".lua"
	local temp = list1(load1(concat1(out["out"]), "=" .. name))
	if type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (eq_3f_1(nth1(temp, 1), nil) and true))) then
		local msg = nth1(temp, 2)
		self1(logger, "put-error!", "Cannot load compiled source.")
		print1(msg)
		print1(concat1(out["out"]))
		return exit_21_1(1)
	elseif type1(temp) == "list" and (n1(temp) >= 1 and (n1(temp) <= 1 and true)) then
		local fun = nth1(temp, 1)
		_5f_G1["arg"] = args["script-args"]
		_5f_G1["arg"][0] = car1(args["input"])
		local exec = (function()
			local temp1 = list1(xpcall1(fun, traceback1))
			if type1(temp1) == "list" and (n1(temp1) >= 1 and (eq_3f_1(nth1(temp1, 1), true) and true)) then
				local res = slice1(temp1, 2)
				return nil
			elseif type1(temp1) == "list" and (n1(temp1) >= 2 and (n1(temp1) <= 2 and (eq_3f_1(nth1(temp1, 1), false) and true))) then
				local msg = nth1(temp1, 2)
				self1(logger, "put-error!", "Execution failed.")
				print1(remapTraceback1(({[name]=lines}), msg))
				return exit_21_1(1)
			else
				return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp1) .. ", but none matched.\n" .. "  Tried: `(true . ?res)`\n  Tried: `(false ?msg)`")
			end
		end)
		local temp1 = args["profile"]
		if temp1 == "none" then
			return exec()
		elseif eq_3f_1(temp1, nil) then
			return exec()
		elseif temp1 == "call" then
			return profileCalls1(exec, ({[name]=lines}))
		elseif temp1 == "stack" then
			return profileStack1(exec, ({[name]=lines}), args)
		else
			self1(logger, "put-error!", ("Unknown profiler '" .. temp1 .. "'"))
			return exit_21_1(1)
		end
	else
		return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `(nil ?msg)`\n  Tried: `(?fun)`")
	end
end)
task2 = ({["name"]="run",["setup"]=(function(spec)
	addArgument_21_1(spec, ({tag = "list", n = 2, "--run", "-r"}), "help", "Run the compiled code.")
	addArgument_21_1(spec, ({tag = "list", n = 2, "--profile", "-p"}), "help", "Run the compiled code with the profiler.", "var", "none|call|stack", "default", nil, "value", "stack", "narg", "?")
	addArgument_21_1(spec, ({tag = "list", n = 1, "--stack-kind"}), "help", "The kind of stack to emit when using the stack profiler. A reverse stack shows callers of that method instead.", "var", "forward|reverse", "default", "forward", "narg", 1)
	addArgument_21_1(spec, ({tag = "list", n = 1, "--stack-show"}), "help", "The method to use to display the profiling results.", "var", "flame|term", "default", "term", "narg", 1)
	addArgument_21_1(spec, ({tag = "list", n = 1, "--stack-limit"}), "help", "The maximum number of call frames to emit.", "var", "LIMIT", "default", nil, "action", setNumAction1, "narg", 1)
	addArgument_21_1(spec, ({tag = "list", n = 1, "--stack-fold"}), "help", "Whether to fold recursive functions into themselves. This hopefully makes deep graphs easier to understand, but may result in less accurate graphs.", "value", true, "default", false)
	return addArgument_21_1(spec, ({tag = "list", n = 1, "--"}), "name", "script-args", "help", "Arguments to pass to the compiled script.", "var", "ARG", "all", true, "default", ({tag = "list", n = 0}), "action", addAction1, "narg", "*")
end),["pred"]=(function(args)
	return args["run"] or args["profile"]
end),["run"]=runLua1})
dotQuote1 = (function(prefix, name)
	if find1(name, "^[%w_][%d%w_]*$") then
		if string_3f_1(prefix) then
			return prefix .. "." .. name
		else
			return name
		end
	else
		if string_3f_1(prefix) then
			return prefix .. "[" .. quoted1(name) .. "]"
		else
			return "_ENV[" .. quoted1(name) .. "]"
		end
	end
end)
genNative1 = (function(compiler, args)
	if n1(args["input"]) ~= 1 then
		self1(compiler["log"], "put-error!", "Expected just one input")
		exit_21_1(1)
	end
	local prefix = args["gen-native"]
	local lib = compiler["lib-cache"][gsub1(last1(args["input"]), "%.lisp$", "")]
	local escaped
	if string_3f_1(prefix) then
		escaped = escape1(last1(split1(lib["name"], "/")))
	else
		escaped = nil
	end
	local maxName = 0
	local maxQuot = 0
	local maxPref = 0
	local natives = ({tag = "list", n = 0})
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
	sort1(natives)
	local handle = open1(lib["path"] .. ".meta.lua", "w")
	local format = "\9[%-" .. tostring1(maxName + 3) .. "s { tag = \"var\", contents = %-" .. tostring1(maxQuot + 1) .. "s value = %-" .. tostring1(maxPref + 1) .. "s },\n"
	if handle then
	else
		self1(compiler["log"], "put-error!", ("Cannot write to " .. lib["path"] .. ".meta.lua"))
		exit_21_1(1)
	end
	if string_3f_1(prefix) then
		self1(handle, "write", format1("local %s = %s or {}\n", escaped, prefix))
	end
	self1(handle, "write", "return {\n")
	local temp = n1(natives)
	local temp1 = 1
	while temp1 <= temp do
		local native = natives[temp1]
		self1(handle, "write", format1(format, quoted1(native) .. "] =", quoted1(dotQuote1(prefix, native)) .. ",", dotQuote1(escaped, native) .. ","))
		temp1 = temp1 + 1
	end
	self1(handle, "write", "}\n")
	return self1(handle, "close")
end)
task3 = ({["name"]="gen-native",["setup"]=(function(spec)
	return addArgument_21_1(spec, ({tag = "list", n = 1, "--gen-native"}), "help", "Generate native bindings for a file", "var", "PREFIX", "narg", "?")
end),["pred"]=(function(args)
	return args["gen-native"]
end),["run"]=genNative1})
simplifyPath1 = (function(path, paths)
	local current = path
	local temp = n1(paths)
	local temp1 = 1
	while temp1 <= temp do
		local search = paths[temp1]
		local sub = match1(path, "^" .. gsub1(search, "%?", "(.*)") .. "$")
		if sub and n1(sub) < n1(current) then
			current = sub
		end
		temp1 = temp1 + 1
	end
	return current
end)
readMeta1 = (function(state, name, entry)
	if (entry["tag"] == "expr" or entry["tag"] == "stmt") and string_3f_1(entry["contents"]) then
		local buffer = ({tag = "list", n = 0})
		local str = entry["contents"]
		local idx = 0
		local max = 0
		local len = n1(str)
		while idx <= len do
			local temp = list1(find1(str, "%${(%d+)}", idx))
			if type1(temp) == "list" and (n1(temp) >= 2 and true) then
				local start = nth1(temp, 1)
				local finish = nth1(temp, 2)
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
		if entry["count"] then
		else
			entry["count"] = max
		end
		entry["contents"] = buffer
	end
	local fold = entry["fold"]
	if fold then
		if entry["tag"] ~= "expr" then
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
			if type1(temp) == "list" and (n1(temp) >= 1 and (eq_3f_1(nth1(temp, 1), true) and true)) then
				value = car1((slice1(temp, 2)))
			elseif type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (eq_3f_1(nth1(temp, 1), false) and true))) then
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
end)
readLibrary1 = (function(state, name, path, lispHandle)
	self1(state["log"], "put-verbose!", ("Loading " .. path .. " into " .. name))
	local prefix = name .. "-" .. n1(state["libs"]) .. "/"
	local lib = ({["name"]=name,["prefix"]=prefix,["path"]=path})
	local contents = self1(lispHandle, "read", "*a")
	self1(lispHandle, "close")
	local handle = open1(path .. ".lua", "r")
	if handle then
		local contents1 = self1(handle, "read", "*a")
		self1(handle, "close")
		lib["native"] = contents1
		local temp = list1(load1(contents1, "@" .. name))
		if type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (eq_3f_1(nth1(temp, 1), nil) and true))) then
			error1((nth1(temp, 2)), 0)
		elseif type1(temp) == "list" and (n1(temp) >= 1 and (n1(temp) <= 1 and true)) then
			local fun = nth1(temp, 1)
			local res = fun()
			if type_23_1(res) == "table" then
				local temp1, v = next1(res)
				while temp1 ~= nil do
					state["lib-env"][prefix .. temp1] = v
					temp1, v = next1(res, temp1)
				end
			else
				error1(path .. ".lua returned a non-table value", 0)
			end
		else
			error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `(nil ?msg)`\n  Tried: `(?fun)`")
		end
	end
	local handle = open1(path .. ".meta.lua", "r")
	if handle then
		local contents1 = self1(handle, "read", "*a")
		self1(handle, "close")
		local temp = list1(load1(contents1, "@" .. name))
		if type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (eq_3f_1(nth1(temp, 1), nil) and true))) then
			error1((nth1(temp, 2)), 0)
		elseif type1(temp) == "list" and (n1(temp) >= 1 and (n1(temp) <= 1 and true)) then
			local fun = nth1(temp, 1)
			local res = fun()
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
	local parsed = parse1(state["log"], lexed)
	local scope = child1(state["root-scope"])
	scope["is-root"] = true
	scope["prefix"] = prefix
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
	self1(state["log"], "put-verbose!", ("Loaded " .. path .. " into " .. name))
	return lib
end)
pathLocator1 = (function(state, name)
	local searched, paths
	searched = ({tag = "list", n = 0})
	paths = state["paths"]
	local i = 1
	while true do
		if i > n1(paths) then
			return list1(nil, "Cannot find " .. quoted1(name) .. ".\nLooked in " .. concat1(searched, ", "))
		else
			local path = gsub1(nth1(paths, i), "%?", name)
			local cached = state["lib-cache"][path]
			pushCdr_21_1(searched, path)
			if cached == nil then
				local handle = open1(path .. ".lisp", "r")
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
end)
loader1 = (function(state, name, shouldResolve)
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
		name = gsub1(name, "%.lisp$", "")
		local temp = state["lib-cache"][name]
		if eq_3f_1(temp, nil) then
			local handle = open1(name .. ".lisp")
			if handle then
				state["lib-cache"][name] = true
				local lib = readLibrary1(state, simplifyPath1(name, state["paths"]), name, handle)
				state["lib-cache"][name] = lib
				return list1(lib)
			else
				return list1(nil, "Cannot find " .. quoted1(name))
			end
		elseif eq_3f_1(temp, true) then
			return list1(nil, "Already loading " .. name)
		else
			return list1(temp)
		end
	end
end)
printError_21_1 = (function(msg)
	if string_3f_1(msg) then
	else
		msg = pretty1(msg)
	end
	local lines = split1(msg, "\n", 1)
	print1(colored1(31, "[ERROR] " .. car1(lines)))
	if cadr1(lines) then
		return print1(cadr1(lines))
	else
		return nil
	end
end)
printWarning_21_1 = (function(msg)
	local lines = split1(msg, "\n", 1)
	print1(colored1(33, "[WARN] " .. car1(lines)))
	if cadr1(lines) then
		return print1(cadr1(lines))
	else
		return nil
	end
end)
printVerbose_21_1 = (function(verbosity, msg)
	if verbosity > 0 then
		return print1("[VERBOSE] " .. msg)
	else
		return nil
	end
end)
printDebug_21_1 = (function(verbosity, msg)
	if verbosity > 1 then
		return print1("[DEBUG] " .. msg)
	else
		return nil
	end
end)
printTime_21_1 = (function(maximum, name, time, level)
	if level <= maximum then
		return print1("[TIME] " .. name .. " took " .. time)
	else
		return nil
	end
end)
printExplain_21_1 = (function(explain, lines)
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
end)
create5 = (function(verbosity, explain, time)
	return ({["verbosity"]=verbosity or 0,["explain"]=explain == true,["time"]=time or 0,["put-error!"]=putError_21_1,["put-warning!"]=putWarning_21_1,["put-verbose!"]=putVerbose_21_1,["put-debug!"]=putDebug_21_1,["put-time!"]=putTime_21_1,["put-node-error!"]=putNodeError_21_2,["put-node-warning!"]=putNodeWarning_21_2})
end)
putError_21_1 = (function(logger, msg)
	return printError_21_1(msg)
end)
putWarning_21_1 = (function(logger, msg)
	return printWarning_21_1(msg)
end)
putVerbose_21_1 = (function(logger, msg)
	return printVerbose_21_1(logger["verbosity"], msg)
end)
putDebug_21_1 = (function(logger, msg)
	return printDebug_21_1(logger["verbosity"], msg)
end)
putTime_21_1 = (function(logger, name, time, level)
	return printTime_21_1(logger["time"], name, time, level)
end)
putNodeError_21_2 = (function(logger, msg, node, explain, lines)
	printError_21_1(msg)
	putTrace_21_1(node)
	if explain then
		printExplain_21_1(logger["explain"], explain)
	end
	return putLines_21_1(true, lines)
end)
putNodeWarning_21_2 = (function(logger, msg, node, explain, lines)
	printWarning_21_1(msg)
	putTrace_21_1(node)
	if explain then
		printExplain_21_1(logger["explain"], explain)
	end
	return putLines_21_1(true, lines)
end)
putLines_21_1 = (function(range, entries)
	if empty_3f_1(entries) then
		error1("Positions cannot be empty")
	end
	if n1(entries) % 2 ~= 0 then
		error1("Positions must be a multiple of 2, is " .. n1(entries))
	end
	local previous = -1
	local file = nth1(entries, 1)["name"]
	local maxLine = reduce1((function(max, node)
		if string_3f_1(node) then
			return max
		else
			return max1(max, node["start"]["line"])
		end
	end), 0, entries)
	local code = colored1(92, " %" .. n1(tostring1(maxLine)) .. "s │") .. " %s"
	local temp = n1(entries)
	local temp1 = 1
	while temp1 <= temp do
		local position, message = entries[temp1], entries[temp1 + 1]
		if file ~= position["name"] then
			file = position["name"]
			print1(colored1(95, " " .. file))
		elseif previous ~= -1 and abs1(position["start"]["line"] - previous) > 2 then
			print1(colored1(92, " ..."))
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
end)
putTrace_21_1 = (function(node)
	local previous = nil
	while node do
		local formatted = formatNode1(node)
		if previous == nil then
			print1(colored1(96, "  => " .. formatted))
		elseif previous ~= formatted then
			print1("  in " .. formatted)
		end
		previous = formatted
		node = node["parent"]
	end
	return nil
end)
createPluginState1 = (function(compiler)
	local logger = compiler["log"]
	local variables = compiler["variables"]
	local states = compiler["states"]
	local warnings = compiler["warning"]
	local optimise = compiler["optimise"]
	local activeScope = (function()
		return compiler["active-scope"]
	end)
	local activeNode = (function()
		return compiler["active-node"]
	end)
	return ({["add-categoriser!"]=(function()
		return error1("add-categoriser! is not yet implemented", 0)
	end),["categorise-node"]=visitNode2,["categorise-nodes"]=visitNodes1,["cat"]=cat1,["writer/append!"]=append_21_1,["writer/line!"]=line_21_1,["writer/indent!"]=indent_21_1,["writer/unindent!"]=unindent_21_1,["writer/begin-block!"]=beginBlock_21_1,["writer/next-block!"]=nextBlock_21_1,["writer/end-block!"]=endBlock_21_1,["add-emitter!"]=(function()
		return error1("add-emitter! is not yet implemented", 0)
	end),["emit-node"]=expression2,["emit-block"]=block2,["logger/put-error!"]=(function(temp)
		return self1(logger, "put-error!", temp)
	end),["logger/put-warning!"]=(function(temp)
		return self1(logger, "put-warning!", temp)
	end),["logger/put-verbose!"]=(function(temp)
		return self1(logger, "put-verbose!", temp)
	end),["logger/put-debug!"]=(function(temp)
		return self1(logger, "put-debug!", temp)
	end),["logger/put-node-error!"]=(function(msg, node, explain, ...)
		local lines = _pack(...) lines.tag = "list"
		return putNodeError_21_1(logger, msg, node, explain, unpack1(lines, 1, n1(lines)))
	end),["logger/put-node-warning!"]=(function(msg, node, explain, ...)
		local lines = _pack(...) lines.tag = "list"
		return putNodeWarning_21_1(logger, msg, node, explain, unpack1(lines, 1, n1(lines)))
	end),["logger/do-node-error!"]=(function(msg, node, explain, ...)
		local lines = _pack(...) lines.tag = "list"
		return doNodeError_21_1(logger, msg, node, explain, unpack1(lines, 1, n1(lines)))
	end),["range/get-source"]=getSource1,["visit-node"]=visitNode1,["visit-nodes"]=visitBlock1,["traverse-nodes"]=traverseNode1,["traverse-nodes"]=traverseList1,["symbol->var"]=(function(x)
		local var = x["var"]
		if string_3f_1(var) then
			return variables[var]
		else
			return var
		end
	end),["var->symbol"]=makeSymbol1,["builtin?"]=builtin_3f_1,["constant?"]=constant_3f_1,["node->val"]=urn_2d3e_val1,["val->node"]=val_2d3e_urn1,["fusion/add-rule!"]=addRule_21_1,["add-pass!"]=(function(pass)
		local temp = type1(pass)
		if temp ~= "table" then
			error1(format1("bad argument %s (expected %s, got %s)", "pass", "table", temp), 2)
		end
		if string_3f_1(pass["name"]) then
		else
			error1("Expected string for name, got " .. type1(pass["name"]))
		end
		if invokable_3f_1(pass["run"]) then
		else
			error1("Expected function for run, got " .. type1(pass["run"]))
		end
		if type1((pass["cat"])) == "list" then
		else
			error1("Expected list for cat, got " .. type1(pass["cat"]))
		end
		local func = pass["run"]
		pass["run"] = (function(...)
			local args = _pack(...) args.tag = "list"
			local temp = list1(xpcall1((function()
				return func(unpack1(args, 1, n1(args)))
			end), traceback1))
			if type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (eq_3f_1(nth1(temp, 1), false) and true))) then
				local msg = nth1(temp, 2)
				return error1(remapTraceback1(compiler["compile-state"]["mappings"], msg), 0)
			elseif type1(temp) == "list" and (n1(temp) >= 1 and (eq_3f_1(nth1(temp, 1), true) and true)) then
				local rest = slice1(temp, 2)
				return unpack1(rest, 1, n1(rest))
			else
				return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `(false ?msg)`\n  Tried: `(true . ?rest)`")
			end
		end)
		local cats = pass["cat"]
		local group
		if elem_3f_1("usage", cats) then
			group = "usage"
		else
			group = "normal"
		end
		if elem_3f_1("opt", cats) then
			pushCdr_21_1(optimise[group], pass)
		elseif elem_3f_1("warn", cats) then
			pushCdr_21_1(warnings[group], pass)
		else
			error1("Cannot register " .. pretty1(pass["name"]) .. " (do not know how to process " .. pretty1(cats) .. ")")
		end
		return nil
	end),["var-usage"]=getVar1,["active-scope"]=activeScope,["active-node"]=activeNode,["active-module"]=(function()
		local scp = compiler["active-scope"]
		while not (scp["is-root"]) do
			scp = scp["parent"]
		end
		return scp
	end),["scope-vars"]=(function(scp)
		if not scp then
			return compiler["active-scope"]["variables"]
		else
			return scp["variables"]
		end
	end),["var-lookup"]=(function(symb, scope)
		local temp = type1(symb)
		if temp ~= "symbol" then
			error1(format1("bad argument %s (expected %s, got %s)", "symb", "symbol", temp), 2)
		end
		if compiler["active-node"] == nil then
			error1("Not currently resolving")
		end
		if scope then
		else
			scope = compiler["active-scope"]
		end
		return getAlways_21_1(scope, symbol_2d3e_string1(symb), compiler["active-node"])
	end),["try-var-lookup"]=(function(symb, scope)
		local temp = type1(symb)
		if temp ~= "symbol" then
			error1(format1("bad argument %s (expected %s, got %s)", "symb", "symbol", temp), 2)
		end
		if compiler["active-node"] == nil then
			error1("Not currently resolving")
		end
		if scope then
		else
			scope = compiler["active-scope"]
		end
		return get1(scope, symbol_2d3e_string1(symb))
	end),["var-definition"]=(function(var)
		if compiler["active-node"] == nil then
			error1("Not currently resolving")
		end
		local state = states[var]
		if state then
			if state["stage"] == "parsed" then
				yield1(({["tag"]="build",["state"]=state}))
			end
			return state["node"]
		else
			return nil
		end
	end),["var-value"]=(function(var)
		if compiler["active-node"] == nil then
			error1("Not currently resolving")
		end
		local state = states[var]
		if state then
			return get_21_1(state)
		else
			return nil
		end
	end),["var-docstring"]=(function(var)
		return var["doc"]
	end)})
end)
local spec = create1()
local directory
local dir = nth1(arg1, 0)
dir = gsub1(dir, "\\", "/")
dir = gsub1(dir, "urn/cli%.lisp$", "")
dir = gsub1(dir, "urn/cli$", "")
dir = gsub1(dir, "bin/urn%.lua$", "")
dir = gsub1(dir, "bin/urn$", "")
if dir ~= "" and sub1(dir, -1, -1) ~= "/" then
	dir = dir .. "/"
end
while sub1(dir, 1, 2) == "./" do
	dir = sub1(dir, 3)
end
directory = dir
local paths = list1("?", "?/init", directory .. "lib/?", directory .. "lib/?/init")
local tasks = list1(warning1, optimise2, emitLisp1, emitLua1, task1, task3, task2, execTask1, replTask1)
addHelp_21_1(spec)
addArgument_21_1(spec, ({tag = "list", n = 2, "--explain", "-e"}), "help", "Explain error messages in more detail.")
addArgument_21_1(spec, ({tag = "list", n = 2, "--time", "-t"}), "help", "Time how long each task takes to execute. Multiple usages will show more detailed timings.", "many", true, "default", 0, "action", (function(arg, data)
	data[arg["name"]] = (data[arg["name"]] or 0) + 1
	return nil
end))
addArgument_21_1(spec, ({tag = "list", n = 2, "--verbose", "-v"}), "help", "Make the output more verbose. Can be used multiple times", "many", true, "default", 0, "action", (function(arg, data)
	data[arg["name"]] = (data[arg["name"]] or 0) + 1
	return nil
end))
addArgument_21_1(spec, ({tag = "list", n = 2, "--include", "-i"}), "help", "Add an additional argument to the include path.", "many", true, "narg", 1, "default", ({tag = "list", n = 0}), "action", addAction1)
addArgument_21_1(spec, ({tag = "list", n = 2, "--prelude", "-p"}), "help", "A custom prelude path to use.", "narg", 1, "default", directory .. "lib/prelude")
addArgument_21_1(spec, ({tag = "list", n = 3, "--output", "--out", "-o"}), "help", "The destination to output to.", "narg", 1, "default", "out")
addArgument_21_1(spec, ({tag = "list", n = 2, "--wrapper", "-w"}), "help", "A wrapper script to launch Urn with", "narg", 1, "action", (function(a, b, value)
	local args = map1(id1, arg1)
	local i = 1
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
end))
addArgument_21_1(spec, ({tag = "list", n = 1, "--plugin"}), "help", "Specify a compiler plugin to load.", "var", "FILE", "default", ({tag = "list", n = 0}), "narg", 1, "many", true, "action", addAction1)
addArgument_21_1(spec, ({tag = "list", n = 1, "input"}), "help", "The file(s) to load.", "var", "FILE", "narg", "*")
local temp = n1(tasks)
local temp1 = 1
while temp1 <= temp do
	local task = tasks[temp1]
	task["setup"](spec)
	temp1 = temp1 + 1
end
local args = parse_21_1(spec)
local logger = create5(args["verbose"], args["explain"], args["time"])
local temp = args["include"]
local temp1 = n1(temp)
local temp2 = 1
while temp2 <= temp1 do
	local path = temp[temp2]
	path = gsub1(path, "\\", "/")
	path = gsub1(path, "^%./", "")
	if find1(path, "%?") then
	else
		path = path .. (function()
			if sub1(path, -1, -1) == "/" then
				return "?"
			else
				return "/?"
			end
		end)()
	end
	pushCdr_21_1(paths, path)
	temp2 = temp2 + 1
end
self1(logger, "put-verbose!", ("Using path: " .. pretty1(paths)))
if empty_3f_1(args["input"]) then
	args["repl"] = true
else
	args["emit-lua"] = true
end
local compiler = ({["log"]=logger,["timer"]=({["callback"]=(function(temp, temp1, temp2)
	return self1(logger, "put-time!", temp, temp1, temp2)
end),["timers"]=({})}),["paths"]=paths,["lib-env"]=({}),["lib-meta"]=({}),["libs"]=({tag = "list", n = 0}),["lib-cache"]=({}),["lib-names"]=({}),["warning"]=({["normal"]=list1(documentation1),["usage"]=list1(checkArity1, deprecated1)}),["optimise"]=default1(),["root-scope"]=rootScope1,["variables"]=({}),["states"]=({}),["out"]=({tag = "list", n = 0})})
compiler["compile-state"] = createState1(compiler["lib-meta"])
compiler["loader"] = (function(name)
	return loader1(compiler, name, true)
end)
compiler["global"] = setmetatable1(({["_libs"]=compiler["lib-env"],["_compiler"]=createPluginState1(compiler)}), ({["__index"]=_5f_G1}))
local temp = compiler["root-scope"]["variables"]
local temp1, var = next1(temp)
while temp1 ~= nil do
	compiler["variables"][tostring1(var)] = var
	temp1, var = next1(temp, temp1)
end
startTimer_21_1(compiler["timer"], "loading")
local temp = loader1(compiler, args["prelude"], false)
if type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (eq_3f_1(nth1(temp, 1), nil) and true))) then
	self1(logger, "put-error!", ((nth1(temp, 2))))
	exit_21_1(1)
elseif type1(temp) == "list" and (n1(temp) >= 1 and (n1(temp) <= 1 and true)) then
	local lib = nth1(temp, 1)
	compiler["root-scope"] = child1(compiler["root-scope"])
	local temp1 = lib["scope"]["exported"]
	local temp2, var = next1(temp1)
	while temp2 ~= nil do
		import_21_1(compiler["root-scope"], temp2, var)
		temp2, var = next1(temp1, temp2)
	end
	local temp1 = append1(args["plugin"], args["input"])
	local temp2 = n1(temp1)
	local temp3 = 1
	while temp3 <= temp2 do
		local input = temp1[temp3]
		local temp4 = loader1(compiler, input, false)
		if type1(temp4) == "list" and (n1(temp4) >= 2 and (n1(temp4) <= 2 and (eq_3f_1(nth1(temp4, 1), nil) and true))) then
			self1(logger, "put-error!", ((nth1(temp4, 2))))
			exit_21_1(1)
		elseif type1(temp4) == "list" and (n1(temp4) >= 1 and (n1(temp4) <= 1 and true)) then
		else
			error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp4) .. ", but none matched.\n" .. "  Tried: `(nil ?error-message)`\n  Tried: `(_)`")
		end
		temp3 = temp3 + 1
	end
else
	error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `(nil ?error-message)`\n  Tried: `(?lib)`")
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
