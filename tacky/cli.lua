#!/usr/bin/env tacky/cli.lua
if not table.pack then table.pack = function(...) return { n = select("#", ...), ... } end end
if not table.unpack then table.unpack = unpack end
local load = load if _VERSION:find("5.1") then load = function(x, n, _, env) local f, e = loadstring(x, n) if not f then error(e, 2) end return setfenv(f, env) end end
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
	local logger = require "tacky.logger"
	local Scope = require "tacky.analysis.scope"
	local compile = require "tacky.compile"
	local resolve = require "tacky.analysis.resolve"
	local parser = require "tacky.parser"
	local function libLoader(state, name, shouldResolve)
		local termLogger = state.log
		local libs = state.libs
		local paths = state.paths
		local libCache = state.libCache
		local libEnv = state.libEnv
		local libMeta = state.libMeta
		if name:sub(-5) == ".lisp" then
			name = name:sub(1, -6)
		end
		local current = libCache[name]
		if current == true then
			error("Loop: already loading " .. name, 2)
		elseif current ~= nil then
			return true, current.scope.exported
		end
		logger.putVerbose(termLogger, "Loading " .. name)
		libCache[name] = true
		local lib = { id = name, name = name }
		local path, handle
		local looked = {}
		if shouldResolve == false then
			path = name
			looked[#looked + 1] = path
			local current = name
			for i = 1, #paths do
				local sub = name:match("^" .. paths[i]:gsub("%?", "(.*)") .. "$")
				if sub and #sub < #current then
					current = sub
				end
			end
			lib.name = current
			handle = io.open(path .. ".lisp", "r")
		else
			for i = 1, #paths do
				path = paths[i]:gsub("%?", name)
				looked[#looked + 1] = path
				handle = io.open(path .. ".lisp", "r")
				if handle then
					break
				end
			end
		end
		if not handle then return false, "Cannot find " .. name .. " (looked at " .. table.concat(looked, ", ") .. ")" end
		lib.lisp = handle:read("*a")
		lib.path = path
		handle:close()
		for i = 1, #libs do
			local tempLib = libs[i]
			if tempLib.path == path then
				logger.putVerbose(termLogger, "Reusing " .. tempLib.id .. " for " .. name)
				local current = libCache[tempLib.id]
				libCache[name] = current
				return true, current.scope.exported
			end
		end
		local prefix = lib.name .. "-" .. #libs .. "/"
		lib.prefix = prefix
		-- Load the native file
		local handle = io.open(path .. ".lua", "r")
		if handle then
			lib.native = handle:read("*a")
			handle:close()
			local fun, msg = load(lib.native, "@" .. lib.name, "t", _ENV)
			if not fun then error(msg, 0) end
			for k, v in pairs(fun()) do
				libEnv[prefix .. k] = v
			end
		end
		-- Parse the meta info
		local metaHadle = io.open(path .. ".meta.lua", "r")
		if metaHadle then
			local meta = metaHadle:read("*a")
			metaHadle:close()
			local fun, msg = load(meta, "@" .. lib.name .. ".meta", "t", _ENV)
			if not fun then error(msg, 0) end
			for name, entry in pairs(fun()) do
				local full = prefix .. name
				if (entry.tag == "expr" or entry.tag == "stmt") and type(entry.contents) == "string" then
					local buffer = {tag="list"}
					local str = entry.contents
					local current = 1
					while current <= #str do
						local start, finish = str:find("%${(%d+)}", current)
						if not start then
							buffer[#buffer + 1] = str:sub(current, #str)
							current = #str + 1
						else
							if start > current then
								buffer[#buffer + 1] = str:sub(current, start - 1)
							end
							buffer[#buffer + 1] = tonumber(str:sub(start + 2, finish - 1))
							current = finish + 1
						end
					end
					buffer.n = #buffer
					entry.contents = buffer
				end
				-- Extract the value from one of the nodes
				if entry.value == nil then
					entry.value = libEnv[full]
				elseif entry.value ~= nil then
					if libEnv[full] ~= nil then error("Duplicate value for " .. full .. " (in native and meta file)", 0) end
					libEnv[full] = entry.value
				end
				libMeta[full] = entry
			end
		end
		local lexed = parser.lex(termLogger, lib.lisp, lib.path .. ".lisp")
		local parsed = parser.parse(termLogger, lexed, lib.lisp)
		local scope = Scope.child(state.rootScope)
		scope.isRoot = true
		scope.prefix = prefix
		lib.scope = scope
		local compiled, _ = compile.compile(
			parsed,
			state.global, state.variables, state.states,
			scope,
			state.compileState, function(name) return libLoader(state, name, true) end,
			termLogger
		)
		libs[libs.n + 1] = lib
		libs.n = libs.n + 1
		libCache[name] = lib
		-- Extract the documentation node if it is there.
		if compiled[1] and compiled[1].tag == "string" then
			lib.docs = compiled[1].value
			table.remove(compiled, 1)
		end
		for i = 1, #compiled do
			state.out[state.out.n + 1] = compiled[i]
			state.out.n = state.out.n + 1
		end
		logger.putVerbose(termLogger, "Loaded " .. name)
		return true, scope.exported
	end
	return {
		['lib-loader'] = libLoader,
		['root-scope'] = resolve.rootScope,
		['scope/child']  = Scope.child,
		['scope/import!'] = Scope.import,
	}
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
local counter1 = 0
gensym1 = (function(name1)
	if name1 then
		name1 = ("_" .. name1)
	else
		name1 = ""
	end
	counter1 = (counter1 + 1)
	local res1 = ({})
	res1["tag"] = "symbol"
	res1["contents"] = format1("r_%d%s", counter1, name1)
	return res1
end)
_eor1 = (function(a1, b1, ...)
	local rest1 = _pack(...) rest1.tag = "list"
	local symb1 = gensym1()
	return {tag = "list", n = 3, { tag="symbol", contents="with", var="table: 0x1ccc030"}, {tag = "list", n = 2, symb1, a1}, {tag = "list", n = 4, { tag="symbol", contents="if", var="table: 0x1ca7f30"}, symb1, symb1, (function()
		if (_23_1(rest1) == 0) then
			return b1
		else
			return (function()
				local _offset, _result, _temp = 0, {tag="list",n=0}
				_result[1 + _offset] = { tag="symbol", contents="or", var="table: 0x1cd86a0"}
				_result[2 + _offset] = b1
				_temp = rest1
				for _c = 1, _temp.n do _result[2 + _c + _offset] = _temp[_c] end
				_offset = _offset + _temp.n
				_result.n = _offset + 2
				return _result
			end)()
		end
	end)()
	}}
end)
_2d_or1 = (function(a2, b2)
	if a2 then
		return a2
	else
		return b2
	end
end)
_2d_and1 = (function(a3, b3)
	if a3 then
		return b3
	else
		return a3
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
list_3f_1 = (function(x3)
	return (type1(x3) == "list")
end)
nil_3f_1 = (function(x4)
	if x4 then
		local r_161 = list_3f_1(x4)
		if r_161 then
			return (_23_1(x4) == 0)
		else
			return r_161
		end
	else
		return x4
	end
end)
string_3f_1 = (function(x5)
	return (type1(x5) == "string")
end)
number_3f_1 = (function(x6)
	return (type1(x6) == "number")
end)
symbol_3f_1 = (function(x7)
	return (type1(x7) == "symbol")
end)
key_3f_1 = (function(x8)
	return (type1(x8) == "key")
end)
exists_3f_1 = (function(x9)
	return _21_1((type1(x9) == "nil"))
end)
between_3f_1 = (function(val1, min1, max1)
	local r_221 = (val1 >= min1)
	if r_221 then
		return (val1 <= max1)
	else
		return r_221
	end
end)
type1 = (function(val2)
	local ty2 = type_23_1(val2)
	if (ty2 == "table") then
		local tag2 = val2["tag"]
		if tag2 then
			return tag2
		else
			return "table"
		end
	else
		return ty2
	end
end)
eq_3f_1 = (function(x10, y1)
	local temp2
	local r_231 = exists_3f_1(x10)
	if r_231 then
		temp2 = exists_3f_1(y1)
	else
		temp2 = r_231
	end
	if temp2 then
		local temp3
		local r_241 = symbol_3f_1(x10)
		if r_241 then
			temp3 = symbol_3f_1(y1)
		else
			temp3 = r_241
		end
		if temp3 then
			return (x10["contents"] == y1["contents"])
		else
			local temp4
			local r_251 = symbol_3f_1(x10)
			if r_251 then
				temp4 = string_3f_1(y1)
			else
				temp4 = r_251
			end
			if temp4 then
				return (x10["contents"] == y1)
			else
				local temp5
				local r_261 = string_3f_1(x10)
				if r_261 then
					temp5 = symbol_3f_1(y1)
				else
					temp5 = r_261
				end
				if temp5 then
					return (y1["contents"] == x10)
				else
					local temp6
					local r_271 = key_3f_1(x10)
					if r_271 then
						temp6 = key_3f_1(y1)
					else
						temp6 = r_271
					end
					if temp6 then
						return (x10["value"] == y1["value"])
					else
						local temp7
						local r_281 = key_3f_1(x10)
						if r_281 then
							temp7 = string_3f_1(y1)
						else
							temp7 = r_281
						end
						if temp7 then
							return (x10["value"] == y1)
						else
							local temp8
							local r_291 = string_3f_1(x10)
							if r_291 then
								temp8 = key_3f_1(y1)
							else
								temp8 = r_291
							end
							if temp8 then
								return (y1["value"] == x10)
							else
								local temp9
								local r_301 = nil_3f_1(x10)
								if r_301 then
									temp9 = nil_3f_1(y1)
								else
									temp9 = r_301
								end
								if temp9 then
									return true
								else
									local temp10
									local r_311 = list_3f_1(x10)
									if r_311 then
										temp10 = list_3f_1(y1)
									else
										temp10 = r_311
									end
									if temp10 then
										local r_321 = eq_3f_1(car1(x10), car1(y1))
										if r_321 then
											return eq_3f_1(cdr1(x10), cdr1(y1))
										else
											return r_321
										end
									else
										return (x10 == y1)
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
		local r_331 = exists_3f_1(x10)
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
				temp12 = _21_1(exists_3f_1(x10))
			else
				temp12 = r_341
			end
			if temp12 then
				return false
			else
				local r_351 = _21_1(x10)
				if r_351 then
					return _21_1(y1)
				else
					return r_351
				end
			end
		end
	end
end)
car2 = (function(x11)
	local r_361 = type1(x11)
	if (r_361 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_361), 2)
	else
	end
	return car1(x11)
end)
cdr2 = (function(x12)
	local r_371 = type1(x12)
	if (r_371 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_371), 2)
	else
	end
	if nil_3f_1(x12) then
		return {tag = "list", n = 0}
	else
		return cdr1(x12)
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
pushCdr_21_1 = (function(xs12, val3)
	local r_461 = type1(xs12)
	if (r_461 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_461), 2)
	else
	end
	local len2 = (_23_1(xs12) + 1)
	xs12["n"] = len2
	xs12[len2] = val3
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
reverse1 = (function(xs14, acc2)
	if _21_1(exists_3f_1(acc2)) then
		return reverse1(xs14, {tag = "list", n = 0})
	elseif nil_3f_1(xs14) then
		return acc2
	else
		return reverse1(cdr2(xs14), cons1(car2(xs14), acc2))
	end
end)
accumulateWith1 = (function(f4, ac1, z2, xs15)
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
	return foldr1(ac1, z2, map1(f4, xs15))
end)
caar1 = (function(x13)
	return car2(car2(x13))
end)
cadr1 = (function(x14)
	return car2(cdr2(x14))
end)
charAt1 = (function(xs16, x15)
	return sub1(xs16, x15, x15)
end)
_2e2e_2 = (function(...)
	local args1 = _pack(...) args1.tag = "list"
	return concat1(args1)
end)
split1 = (function(text1, pattern1, limit1)
	local out2 = {tag = "list", n = 0}
	local loop1 = true
	local start1 = 1
	local r_651 = nil
	r_651 = (function()
		if loop1 then
			local pos1 = list1(find1(text1, pattern1, start1))
			local nstart1 = car2(pos1)
			local nend1 = cadr1(pos1)
			local temp13
			local r_661 = (nstart1 == nil)
			if r_661 then
				temp13 = r_661
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
			return r_651()
		else
		end
	end)
	r_651()
	return out2
end)
local escapes1 = ({})
local r_611 = nil
r_611 = (function(r_621)
	if (r_621 <= 31) then
		escapes1[char1(r_621)] = _2e2e_2("\\", tostring1(r_621))
		return r_611((r_621 + 1))
	else
	end
end)
r_611(0)
escapes1["\n"] = "n"
quoted1 = (function(str1)
	local result1 = gsub1(format1("%q", str1), ".", escapes1)
	return result1
end)
clock1 = os.clock
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
	local r_761 = _23_1(keys1)
	local r_741 = nil
	r_741 = (function(r_751)
		if (r_751 <= r_761) then
			local key2 = keys1[r_751]
			local val4 = keys1[(1 + r_751)]
			out3[(function()
				if key_3f_1(key2) then
					return contents1(key2)
				else
					return key2
				end
			end)()
			] = val4
			return r_741((r_751 + 2))
		else
		end
	end)
	r_741(1)
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
succ1 = (function(x16)
	return (x16 + 1)
end)
pred1 = (function(x17)
	return (x17 - 1)
end)
symbol_2d3e_string1 = (function(x18)
	if symbol_3f_1(x18) then
		return x18["contents"]
	else
		return nil
	end
end)
fail_21_1 = (function(x19)
	return error1(x19, 0)
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
self1 = (function(x20, key3, ...)
	local args2 = _pack(...) args2.tag = "list"
	return x20[key3](x20, unpack1(args2, 1, _23_1(args2)))
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
addArgument_21_1 = (function(spec1, names1, ...)
	local options1 = _pack(...) options1.tag = "list"
	local r_1571 = type1(names1)
	if (r_1571 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "names", "list", r_1571), 2)
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
	local r_1961 = _23_1(names1)
	local r_1941 = nil
	r_1941 = (function(r_1951)
		if (r_1951 <= r_1961) then
			local name2 = names1[r_1951]
			if (sub1(name2, 1, 2) == "--") then
				spec1["opt-map"][sub1(name2, 3)] = result2
			elseif (sub1(name2, 1, 1) == "-") then
				spec1["flag-map"][sub1(name2, 2)] = result2
			else
			end
			return r_1941((r_1951 + 1))
		else
		end
	end)
	r_1941(1)
	local r_2001 = _23_1(options1)
	local r_1981 = nil
	r_1981 = (function(r_1991)
		if (r_1991 <= r_2001) then
			local key4 = nth1(options1, r_1991)
			local val5 = nth1(options1, (r_1991 + 1))
			result2[key4] = val5
			return r_1981((r_1991 + 2))
		else
		end
	end)
	r_1981(1)
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
				temp14 = (arg1["narg"] == "?")
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
	return addArgument_21_1(spec2, {tag = "list", n = 2, "--help", "-h"}, "help", "Show this help message", "default", nil, "value", nil, "action", (function(arg4, result3, value4)
		help_21_1(spec2)
		return exit_21_1(0)
	end))
end)
helpNarg_21_1 = (function(buffer1, arg5)
	local r_2021 = arg5["narg"]
	if eq_3f_1(r_2021, "?") then
		return pushCdr_21_1(buffer1, _2e2e_2(" [", arg5["var"], "]"))
	elseif eq_3f_1(r_2021, "*") then
		return pushCdr_21_1(buffer1, _2e2e_2(" [", arg5["var"], "...]"))
	elseif eq_3f_1(r_2021, "+") then
		return pushCdr_21_1(buffer1, _2e2e_2(" ", arg5["var"], " [", arg5["var"], "...]"))
	else
		local r_2031 = nil
		r_2031 = (function(r_2041)
			if (r_2041 <= r_2021) then
				pushCdr_21_1(buffer1, _2e2e_2(" ", arg5["var"]))
				return r_2031((r_2041 + 1))
			else
			end
		end)
		return r_2031(1)
	end
end)
usage_21_1 = (function(spec3, name3)
	if name3 then
	else
		local r_1581 = nth1(arg1, 0)
		if r_1581 then
			name3 = r_1581
		else
			local r_1591 = nth1(arg1, -1)
			if r_1591 then
				name3 = r_1591
			else
				name3 = "?"
			end
		end
	end
	local usage1 = list1("usage: ", name3)
	local r_1611 = spec3["opt"]
	local r_1641 = _23_1(r_1611)
	local r_1621 = nil
	r_1621 = (function(r_1631)
		if (r_1631 <= r_1641) then
			local arg6 = r_1611[r_1631]
			pushCdr_21_1(usage1, _2e2e_2(" [", car2(arg6["names"])))
			helpNarg_21_1(usage1, arg6)
			pushCdr_21_1(usage1, "]")
			return r_1621((r_1631 + 1))
		else
		end
	end)
	r_1621(1)
	local r_1671 = spec3["pos"]
	local r_1701 = _23_1(r_1671)
	local r_1681 = nil
	r_1681 = (function(r_1691)
		if (r_1691 <= r_1701) then
			local arg7 = r_1671[r_1691]
			helpNarg_21_1(usage1, arg7)
			return r_1681((r_1691 + 1))
		else
		end
	end)
	r_1681(1)
	return print1(concat1(usage1))
end)
usageError_21_1 = (function(spec4, name4, error2)
	usage_21_1(spec4, name4)
	print1(error2)
	return exit_21_1(1)
end)
help_21_1 = (function(spec5, name5)
	if name5 then
	else
		local r_1721 = nth1(arg1, 0)
		if r_1721 then
			name5 = r_1721
		else
			local r_1731 = nth1(arg1, -1)
			if r_1731 then
				name5 = r_1731
			else
				name5 = "?"
			end
		end
	end
	usage_21_1(spec5, name5)
	if spec5["desc"] then
		print1()
		print1(spec5["desc"])
	else
	end
	local max3 = 0
	local r_1751 = spec5["pos"]
	local r_1781 = _23_1(r_1751)
	local r_1761 = nil
	r_1761 = (function(r_1771)
		if (r_1771 <= r_1781) then
			local arg8 = r_1751[r_1771]
			local len3 = len1(arg8["var"])
			if (len3 > max3) then
				max3 = len3
			else
			end
			return r_1761((r_1771 + 1))
		else
		end
	end)
	r_1761(1)
	local r_1811 = spec5["opt"]
	local r_1841 = _23_1(r_1811)
	local r_1821 = nil
	r_1821 = (function(r_1831)
		if (r_1831 <= r_1841) then
			local arg9 = r_1811[r_1831]
			local len4 = len1(concat1(arg9["names"], ", "))
			if (len4 > max3) then
				max3 = len4
			else
			end
			return r_1821((r_1831 + 1))
		else
		end
	end)
	r_1821(1)
	local fmt1 = _2e2e_2(" %-", tostring1((max3 + 1)), "s %s")
	if nil_3f_1(spec5["pos"]) then
	else
		print1()
		print1("Positional arguments")
		local r_1871 = spec5["pos"]
		local r_1901 = _23_1(r_1871)
		local r_1881 = nil
		r_1881 = (function(r_1891)
			if (r_1891 <= r_1901) then
				local arg10 = r_1871[r_1891]
				print1(format1(fmt1, arg10["var"], arg10["help"]))
				return r_1881((r_1891 + 1))
			else
			end
		end)
		r_1881(1)
	end
	if nil_3f_1(spec5["opt"]) then
	else
		print1()
		print1("Optional arguments")
		local r_2081 = spec5["opt"]
		local r_2111 = _23_1(r_2081)
		local r_2091 = nil
		r_2091 = (function(r_2101)
			if (r_2101 <= r_2111) then
				local arg11 = r_2081[r_2101]
				print1(format1(fmt1, concat1(arg11["names"], ", "), arg11["help"]))
				return r_2091((r_2101 + 1))
			else
			end
		end)
		return r_2091(1)
	end
end)
matcher1 = (function(pattern2)
	return (function(x21)
		local res2 = list1(match1(x21, pattern2))
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
	local result4 = ({})
	local pos2 = spec6["pos"]
	local idx3 = 1
	local len5 = _23_1(args3)
	local usage_21_2 = (function(msg1)
		return usageError_21_1(spec6, nth1(args3, 0), msg1)
	end)
	local readArgs1 = (function(key5, arg12)
		local r_2451 = arg12["narg"]
		if eq_3f_1(r_2451, "+") then
			idx3 = (idx3 + 1)
			local elem1 = nth1(args3, idx3)
			if (elem1 == nil) then
				print1(_2e2e_2("Expected ", arg12["var"], " after --", key5, ", got nothing"))
			else
				local temp15
				local r_2461 = _21_1(arg12["all"])
				if r_2461 then
					temp15 = find1(elem1, "^%-")
				else
					temp15 = r_2461
				end
				if temp15 then
					print1(_2e2e_2("Expected ", arg12["var"], " after --", key5, ", got ", nth1(args3, idx3)))
				else
					arg12["action"](arg12, result4, elem1)
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
						local r_2481 = _21_1(arg12["all"])
						if r_2481 then
							temp16 = find1(elem2, "^%-")
						else
							temp16 = r_2481
						end
						if temp16 then
							running1 = false
						else
							arg12["action"](arg12, result4, elem2)
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
						local r_2501 = _21_1(arg12["all"])
						if r_2501 then
							temp17 = find1(elem3, "^%-")
						else
							temp17 = r_2501
						end
						if temp17 then
							running2 = false
						else
							arg12["action"](arg12, result4, elem3)
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
			if (elem4 == nil) then
			else
				local temp18
				local r_2511 = _21_1(arg12["all"])
				if r_2511 then
					temp18 = find1(elem4, "^%-")
				else
					temp18 = r_2511
				end
				if temp18 then
				else
					idx3 = (idx3 + 1)
					return arg12["action"](arg12, result4, elem4)
				end
			end
		elseif eq_3f_1(r_2451, 0) then
			idx3 = (idx3 + 1)
			return arg12["action"](arg12, result4, arg12["value"])
		else
			local r_2521 = nil
			r_2521 = (function(r_2531)
				if (r_2531 <= r_2451) then
					idx3 = (idx3 + 1)
					local elem5 = nth1(args3, idx3)
					if (elem5 == nil) then
						print1(_2e2e_2("Expected ", r_2451, " args for ", key5, ", got ", pred1(r_2531)))
					else
						local temp19
						local r_2561 = _21_1(arg12["all"])
						if r_2561 then
							temp19 = find1(elem5, "^%-")
						else
							temp19 = r_2561
						end
						if temp19 then
							print1(_2e2e_2("Expected ", r_2451, " for ", key5, ", got ", pred1(r_2531)))
						else
							arg12["action"](arg12, result4, elem5)
						end
					end
					return r_2521((r_2531 + 1))
				else
				end
			end)
			r_2521(1)
			idx3 = (idx3 + 1)
			return nil
		end
	end)
	local r_2131 = nil
	r_2131 = (function()
		if (idx3 <= len5) then
			local r_2141 = nth1(args3, idx3)
			local temp20
			local r_2151 = matcher1("^%-%-([^=]+)=(.+)$")(r_2141)
			local r_2181 = list_3f_1(r_2151)
			if r_2181 then
				local r_2191 = (_23_1(r_2151) == 2)
				if r_2191 then
					temp20 = true
				else
					temp20 = r_2191
				end
			else
				temp20 = r_2181
			end
			if temp20 then
				local key6 = nth1(matcher1("^%-%-([^=]+)=(.+)$")(r_2141), 1)
				local val6 = nth1(matcher1("^%-%-([^=]+)=(.+)$")(r_2141), 2)
				local arg13 = spec6["opt-map"][key6]
				if (arg13 == nil) then
					usage_21_2(_2e2e_2("Unknown argument ", key6, " in ", nth1(args3, idx3)))
				else
					local temp21
					local r_2211 = _21_1(arg13["many"])
					if r_2211 then
						temp21 = (nil ~= result4[arg13["name"]])
					else
						temp21 = r_2211
					end
					if temp21 then
						usage_21_2(_2e2e_2("Too may values for ", key6, " in ", nth1(args3, idx3)))
					else
						local narg1 = arg13["narg"]
						local temp22
						local r_2221 = number_3f_1(narg1)
						if r_2221 then
							temp22 = (narg1 ~= 1)
						else
							temp22 = r_2221
						end
						if temp22 then
							usage_21_2(_2e2e_2("Expected ", tostring1(narg1), " values, got 1 in ", nth1(args3, idx3)))
						else
						end
						arg13["action"](arg13, result4, val6)
					end
				end
				idx3 = (idx3 + 1)
			else
				local temp23
				local r_2161 = matcher1("^%-%-(.*)$")(r_2141)
				local r_2231 = list_3f_1(r_2161)
				if r_2231 then
					local r_2241 = (_23_1(r_2161) == 1)
					if r_2241 then
						temp23 = true
					else
						temp23 = r_2241
					end
				else
					temp23 = r_2231
				end
				if temp23 then
					local key7 = nth1(matcher1("^%-%-(.*)$")(r_2141), 1)
					local arg14 = spec6["opt-map"][key7]
					if (arg14 == nil) then
						usage_21_2(_2e2e_2("Unknown argument ", key7, " in ", nth1(args3, idx3)))
					else
						local temp24
						local r_2251 = _21_1(arg14["many"])
						if r_2251 then
							temp24 = (nil ~= result4[arg14["name"]])
						else
							temp24 = r_2251
						end
						if temp24 then
							usage_21_2(_2e2e_2("Too may values for ", key7, " in ", nth1(args3, idx3)))
						else
							readArgs1(key7, arg14)
						end
					end
				else
					local temp25
					local r_2171 = matcher1("^%-(.+)$")(r_2141)
					local r_2261 = list_3f_1(r_2171)
					if r_2261 then
						local r_2271 = (_23_1(r_2171) == 1)
						if r_2271 then
							temp25 = true
						else
							temp25 = r_2271
						end
					else
						temp25 = r_2261
					end
					if temp25 then
						local flags1 = nth1(matcher1("^%-(.+)$")(r_2141), 1)
						local r_2301 = len1(flags1)
						local r_2281 = nil
						r_2281 = (function(r_2291)
							if (r_2291 <= r_2301) then
								local key8 = charAt1(flags1, r_2291)
								local arg15 = spec6["flag-map"][key8]
								if (arg15 == nil) then
									usage_21_2(_2e2e_2("Unknown flag ", key8, " in ", nth1(args3, idx3)))
								else
									local temp26
									local r_2321 = _21_1(arg15["many"])
									if r_2321 then
										temp26 = (nil ~= result4[arg15["name"]])
									else
										temp26 = r_2321
									end
									if temp26 then
										usage_21_2(_2e2e_2("Too many occurances of ", key8, " in ", nth1(args3, idx3)))
									else
										local narg2 = arg15["narg"]
										if (r_2291 == len1(flags1)) then
											readArgs1(key8, arg15)
										elseif (narg2 == 0) then
											arg15["action"](arg15, result4, arg15["value"])
										else
											usage_21_2(_2e2e_2("Expected arguments for ", key8, " in ", nth1(args3, idx3)))
										end
									end
								end
								return r_2281((r_2291 + 1))
							else
							end
						end)
						r_2281(1)
					else
						local arg16 = car2(spec6["pos"])
						if arg16 then
							arg16["action"](arg16, result4, r_2141)
						else
							usage_21_2(_2e2e_2("Unknown argument ", arg16))
						end
						idx3 = (idx3 + 1)
					end
				end
			end
			return r_2131()
		else
		end
	end)
	r_2131()
	local r_2341 = spec6["opt"]
	local r_2371 = _23_1(r_2341)
	local r_2351 = nil
	r_2351 = (function(r_2361)
		if (r_2361 <= r_2371) then
			local arg17 = r_2341[r_2361]
			if (result4[arg17["name"]] == nil) then
				result4[arg17["name"]] = arg17["default"]
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
			local arg18 = r_2401[r_2421]
			if (result4[arg18["name"]] == nil) then
				result4[arg18["name"]] = arg18["default"]
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
visitQuote1 = (function(node1, visitor1, level1)
	if (level1 == 0) then
		return visitNode1(node1, visitor1)
	else
		local tag3 = node1["tag"]
		local temp27
		local r_3141 = (tag3 == "string")
		if r_3141 then
			temp27 = r_3141
		else
			local r_3151 = (tag3 == "number")
			if r_3151 then
				temp27 = r_3151
			else
				local r_3161 = (tag3 == "key")
				if r_3161 then
					temp27 = r_3161
				else
					temp27 = (tag3 == "symbol")
				end
			end
		end
		if temp27 then
			return nil
		elseif (tag3 == "list") then
			local first2 = nth1(node1, 1)
			local temp28
			if first2 then
				temp28 = (first2["tag"] == "symbol")
			else
				temp28 = first2
			end
			if temp28 then
				local temp29
				local r_3181 = (first2["contents"] == "unquote")
				if r_3181 then
					temp29 = r_3181
				else
					temp29 = (first2["contents"] == "unquote-splice")
				end
				if temp29 then
					return visitQuote1(nth1(node1, 2), visitor1, pred1(level1))
				elseif (first2["contents"] == "syntax-quote") then
					return visitQuote1(nth1(node1, 2), visitor1, succ1(level1))
				else
					local r_3231 = _23_1(node1)
					local r_3211 = nil
					r_3211 = (function(r_3221)
						if (r_3221 <= r_3231) then
							local sub2 = node1[r_3221]
							visitQuote1(sub2, visitor1, level1)
							return r_3211((r_3221 + 1))
						else
						end
					end)
					return r_3211(1)
				end
			else
				local r_3291 = _23_1(node1)
				local r_3271 = nil
				r_3271 = (function(r_3281)
					if (r_3281 <= r_3291) then
						local sub3 = node1[r_3281]
						visitQuote1(sub3, visitor1, level1)
						return r_3271((r_3281 + 1))
					else
					end
				end)
				return r_3271(1)
			end
		elseif error1 then
			return _2e2e_2("Unknown tag ", tag3)
		else
			_error("unmatched item")
		end
	end
end)
visitNode1 = (function(node2, visitor2)
	if (visitor2(node2, visitor2) == false) then
	else
		local tag4 = node2["tag"]
		local temp30
		local r_3071 = (tag4 == "string")
		if r_3071 then
			temp30 = r_3071
		else
			local r_3081 = (tag4 == "number")
			if r_3081 then
				temp30 = r_3081
			else
				local r_3091 = (tag4 == "key")
				if r_3091 then
					temp30 = r_3091
				else
					temp30 = (tag4 == "symbol")
				end
			end
		end
		if temp30 then
			return nil
		elseif (tag4 == "list") then
			local first3 = nth1(node2, 1)
			if (first3["tag"] == "symbol") then
				local func1 = first3["var"]
				local funct1 = func1["tag"]
				if (func1 == builtins1["lambda"]) then
					return visitBlock1(node2, 3, visitor2)
				elseif (func1 == builtins1["cond"]) then
					local r_3331 = _23_1(node2)
					local r_3311 = nil
					r_3311 = (function(r_3321)
						if (r_3321 <= r_3331) then
							local case1 = nth1(node2, r_3321)
							visitNode1(nth1(case1, 1), visitor2)
							visitBlock1(case1, 2, visitor2)
							return r_3311((r_3321 + 1))
						else
						end
					end)
					return r_3311(2)
				elseif (func1 == builtins1["set!"]) then
					return visitNode1(nth1(node2, 3), visitor2)
				elseif (func1 == builtins1["quote"]) then
				elseif (func1 == builtins1["syntax-quote"]) then
					return visitQuote1(nth1(node2, 2), visitor2, 1)
				else
					local temp31
					local r_3351 = (func1 == builtins1["unquote"])
					if r_3351 then
						temp31 = r_3351
					else
						temp31 = (func1 == builtins1["unquote-splice"])
					end
					if temp31 then
						return fail_21_1("unquote/unquote-splice should never appear head")
					else
						local temp32
						local r_3361 = (func1 == builtins1["define"])
						if r_3361 then
							temp32 = r_3361
						else
							temp32 = (func1 == builtins1["define-macro"])
						end
						if temp32 then
							return visitNode1(nth1(node2, _23_1(node2)), visitor2)
						elseif (func1 == builtins1["define-native"]) then
						elseif (func1 == builtins1["import"]) then
						else
							local temp33
							local r_3371 = (funct1 == "defined")
							if r_3371 then
								temp33 = r_3371
							else
								local r_3381 = (funct1 == "arg")
								if r_3381 then
									temp33 = r_3381
								else
									local r_3391 = (funct1 == "native")
									if r_3391 then
										temp33 = r_3391
									else
										temp33 = (funct1 == "macro")
									end
								end
							end
							if temp33 then
								return visitBlock1(node2, 1, visitor2)
							else
								return fail_21_1(_2e2e_2("Unknown kind ", funct1, " for variable ", func1["name"]))
							end
						end
					end
				end
			else
				return visitBlock1(node2, 1, visitor2)
			end
		else
			return error1(_2e2e_2("Unknown tag ", tag4))
		end
	end
end)
visitBlock1 = (function(node3, start2, visitor3)
	local r_3121 = _23_1(node3)
	local r_3101 = nil
	r_3101 = (function(r_3111)
		if (r_3111 <= r_3121) then
			visitNode1(nth1(node3, r_3111), visitor3)
			return r_3101((r_3111 + 1))
		else
		end
	end)
	return r_3101(start2)
end)
builtins2 = require1("tacky.analysis.resolve")["builtins"]
builtinVars1 = require1("tacky.analysis.resolve")["declaredVars"]
createState1 = (function()
	return struct1("vars", ({}), "nodes", ({}))
end)
getVar1 = (function(state1, var1)
	local entry1 = state1["vars"][var1]
	if entry1 then
	else
		entry1 = struct1("var", var1, "usages", struct1(), "defs", struct1(), "active", false)
		state1["vars"][var1] = entry1
	end
	return entry1
end)
getNode1 = (function(state2, node4)
	local entry2 = state2["nodes"][node4]
	if entry2 then
	else
		entry2 = struct1("uses", {tag = "list", n = 0})
		state2["nodes"][node4] = entry2
	end
	return entry2
end)
addUsage_21_1 = (function(state3, var2, node5)
	local varMeta1 = getVar1(state3, var2)
	local nodeMeta1 = getNode1(state3, node5)
	varMeta1["usages"][node5] = true
	varMeta1["active"] = true
	nodeMeta1["uses"][var2] = true
	return nil
end)
addDefinition_21_1 = (function(state4, var3, node6, kind1, value5)
	local varMeta2 = getVar1(state4, var3)
	varMeta2["defs"][node6] = struct1("tag", kind1, "value", value5)
	return nil
end)
definitionsVisitor1 = (function(state5, node7, visitor4)
	local temp34
	local r_2841 = list_3f_1(node7)
	if r_2841 then
		temp34 = symbol_3f_1(car2(node7))
	else
		temp34 = r_2841
	end
	if temp34 then
		local func2 = car2(node7)["var"]
		if (func2 == builtins2["lambda"]) then
			local r_2861 = nth1(node7, 2)
			local r_2891 = _23_1(r_2861)
			local r_2871 = nil
			r_2871 = (function(r_2881)
				if (r_2881 <= r_2891) then
					local arg19 = r_2861[r_2881]
					addDefinition_21_1(state5, arg19["var"], arg19, "arg", arg19)
					return r_2871((r_2881 + 1))
				else
				end
			end)
			return r_2871(1)
		elseif (func2 == builtins2["set!"]) then
			return addDefinition_21_1(state5, node7[2]["var"], node7, "set", nth1(node7, 3))
		else
			local temp35
			local r_2911 = (func2 == builtins2["define"])
			if r_2911 then
				temp35 = r_2911
			else
				temp35 = (func2 == builtins2["define-macro"])
			end
			if temp35 then
				return addDefinition_21_1(state5, node7["defVar"], node7, "define", nth1(node7, _23_1(node7)))
			elseif (func2 == builtins2["define-native"]) then
				return addDefinition_21_1(state5, node7["defVar"], node7, "native")
			else
			end
		end
	else
		local temp36
		local r_2921 = list_3f_1(node7)
		if r_2921 then
			local r_2931 = list_3f_1(car2(node7))
			if r_2931 then
				local r_2941 = symbol_3f_1(caar1(node7))
				if r_2941 then
					temp36 = (caar1(node7)["var"] == builtins2["lambda"])
				else
					temp36 = r_2941
				end
			else
				temp36 = r_2931
			end
		else
			temp36 = r_2921
		end
		if temp36 then
			local lam1 = car2(node7)
			local args4 = nth1(lam1, 2)
			local offset1 = 1
			local r_2971 = _23_1(args4)
			local r_2951 = nil
			r_2951 = (function(r_2961)
				if (r_2961 <= r_2971) then
					local arg20 = nth1(args4, r_2961)
					local val7 = nth1(node7, (r_2961 + offset1))
					if arg20["var"]["isVariadic"] then
						local count1 = (_23_1(node7) - _23_1(args4))
						if (count1 < 0) then
							count1 = 0
						else
						end
						offset1 = count1
						addDefinition_21_1(state5, arg20["var"], arg20, "arg", arg20)
					else
						addDefinition_21_1(state5, arg20["var"], arg20, "let", (function()
							if val7 then
								return val7
							else
								return struct1("tag", "symbol", "contents", "nil", "var", builtinVars1["nil"])
							end
						end)())
					end
					return r_2951((r_2961 + 1))
				else
				end
			end)
			r_2951(1)
			visitBlock1(node7, 2, visitor4)
			visitBlock1(lam1, 3, visitor4)
			return false
		else
		end
	end
end)
definitionsVisit1 = (function(state6, nodes1)
	return visitBlock1(nodes1, 1, (function(r_3401, r_3411)
		return definitionsVisitor1(state6, r_3401, r_3411)
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
	local addUsage1 = (function(var4, user1)
		addUsage_21_1(state7, var4, user1)
		local varMeta3 = getVar1(state7, var4)
		if varMeta3["active"] then
			return iterPairs1(varMeta3["defs"], (function(_5f_1, def1)
				local val8 = def1["value"]
				local temp37
				if val8 then
					temp37 = _21_1(visited1[val8])
				else
					temp37 = val8
				end
				if temp37 then
					return pushCdr_21_1(queue1, val8)
				else
				end
			end))
		else
		end
	end)
	local visit1 = (function(node8)
		if visited1[node8] then
			return false
		else
			visited1[node8] = true
			if symbol_3f_1(node8) then
				addUsage1(node8["var"], node8)
				return true
			else
				local temp38
				local r_3421 = list_3f_1(node8)
				if r_3421 then
					local r_3431 = (_23_1(node8) > 0)
					if r_3431 then
						temp38 = symbol_3f_1(car2(node8))
					else
						temp38 = r_3431
					end
				else
					temp38 = r_3421
				end
				if temp38 then
					local func3 = car2(node8)["var"]
					local temp39
					local r_3441 = (func3 == builtins2["set!"])
					if r_3441 then
						temp39 = r_3441
					else
						local r_3451 = (func3 == builtins2["define"])
						if r_3451 then
							temp39 = r_3451
						else
							temp39 = (func3 == builtins2["define-macro"])
						end
					end
					if temp39 then
						if pred2(nth1(node8, 3)) then
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
	local r_3041 = _23_1(nodes2)
	local r_3021 = nil
	r_3021 = (function(r_3031)
		if (r_3031 <= r_3041) then
			local node9 = nodes2[r_3031]
			pushCdr_21_1(queue1, node9)
			return r_3021((r_3031 + 1))
		else
		end
	end)
	r_3021(1)
	local r_3061 = nil
	r_3061 = (function()
		if (_23_1(queue1) > 0) then
			visitNode1(removeNth_21_1(queue1, 1), visit1)
			return r_3061()
		else
		end
	end)
	return r_3061()
end)
builtins3 = require1("tacky.analysis.resolve")["builtins"]
traverseQuote1 = (function(node10, visitor5, level2)
	if (level2 == 0) then
		return traverseNode1(node10, visitor5)
	else
		local tag5 = node10["tag"]
		local temp40
		local r_3581 = (tag5 == "string")
		if r_3581 then
			temp40 = r_3581
		else
			local r_3591 = (tag5 == "number")
			if r_3591 then
				temp40 = r_3591
			else
				local r_3601 = (tag5 == "key")
				if r_3601 then
					temp40 = r_3601
				else
					temp40 = (tag5 == "symbol")
				end
			end
		end
		if temp40 then
			return node10
		elseif (tag5 == "list") then
			local first4 = nth1(node10, 1)
			local temp41
			if first4 then
				temp41 = (first4["tag"] == "symbol")
			else
				temp41 = first4
			end
			if temp41 then
				local temp42
				local r_3621 = (first4["contents"] == "unquote")
				if r_3621 then
					temp42 = r_3621
				else
					temp42 = (first4["contents"] == "unquote-splice")
				end
				if temp42 then
					node10[2] = traverseQuote1(nth1(node10, 2), visitor5, pred1(level2))
					return node10
				elseif (first4["contents"] == "syntax-quote") then
					node10[2] = traverseQuote1(nth1(node10, 2), visitor5, succ1(level2))
					return node10
				else
					local r_3651 = _23_1(node10)
					local r_3631 = nil
					r_3631 = (function(r_3641)
						if (r_3641 <= r_3651) then
							node10[r_3641] = traverseQuote1(nth1(node10, r_3641), visitor5, level2)
							return r_3631((r_3641 + 1))
						else
						end
					end)
					r_3631(1)
					return node10
				end
			else
				local r_3691 = _23_1(node10)
				local r_3671 = nil
				r_3671 = (function(r_3681)
					if (r_3681 <= r_3691) then
						node10[r_3681] = traverseQuote1(nth1(node10, r_3681), visitor5, level2)
						return r_3671((r_3681 + 1))
					else
					end
				end)
				r_3671(1)
				return node10
			end
		elseif error1 then
			return _2e2e_2("Unknown tag ", tag5)
		else
			_error("unmatched item")
		end
	end
end)
traverseNode1 = (function(node11, visitor6)
	local tag6 = node11["tag"]
	local temp43
	local r_3471 = (tag6 == "string")
	if r_3471 then
		temp43 = r_3471
	else
		local r_3481 = (tag6 == "number")
		if r_3481 then
			temp43 = r_3481
		else
			local r_3491 = (tag6 == "key")
			if r_3491 then
				temp43 = r_3491
			else
				temp43 = (tag6 == "symbol")
			end
		end
	end
	if temp43 then
		return visitor6(node11, visitor6)
	elseif (tag6 == "list") then
		local first5 = car2(node11)
		first5 = visitor6(first5, visitor6)
		node11[1] = first5
		if (first5["tag"] == "symbol") then
			local func4 = first5["var"]
			local funct2 = func4["tag"]
			if (func4 == builtins3["lambda"]) then
				traverseBlock1(node11, 3, visitor6)
				return visitor6(node11, visitor6)
			elseif (func4 == builtins3["cond"]) then
				local r_3731 = _23_1(node11)
				local r_3711 = nil
				r_3711 = (function(r_3721)
					if (r_3721 <= r_3731) then
						local case2 = nth1(node11, r_3721)
						case2[1] = traverseNode1(nth1(case2, 1), visitor6)
						traverseBlock1(case2, 2, visitor6)
						return r_3711((r_3721 + 1))
					else
					end
				end)
				r_3711(2)
				return visitor6(node11, visitor6)
			elseif (func4 == builtins3["set!"]) then
				node11[3] = traverseNode1(nth1(node11, 3), visitor6)
				return visitor6(node11, visitor6)
			elseif (func4 == builtins3["quote"]) then
				return visitor6(node11, visitor6)
			elseif (func4 == builtins3["syntax-quote"]) then
				node11[2] = traverseQuote1(nth1(node11, 2), visitor6, 1)
				return visitor6(node11, visitor6)
			else
				local temp44
				local r_3751 = (func4 == builtins3["unquote"])
				if r_3751 then
					temp44 = r_3751
				else
					temp44 = (func4 == builtins3["unquote-splice"])
				end
				if temp44 then
					return fail_21_1("unquote/unquote-splice should never appear head")
				else
					local temp45
					local r_3761 = (func4 == builtins3["define"])
					if r_3761 then
						temp45 = r_3761
					else
						temp45 = (func4 == builtins3["define-macro"])
					end
					if temp45 then
						node11[_23_1(node11)] = traverseNode1(nth1(node11, _23_1(node11)), visitor6)
						return visitor6(node11, visitor6)
					elseif (func4 == builtins3["define-native"]) then
						return visitor6(node11, visitor6)
					elseif (func4 == builtins3["import"]) then
						return visitor6(node11, visitor6)
					else
						local temp46
						local r_3771 = (funct2 == "defined")
						if r_3771 then
							temp46 = r_3771
						else
							local r_3781 = (funct2 == "arg")
							if r_3781 then
								temp46 = r_3781
							else
								local r_3791 = (funct2 == "native")
								if r_3791 then
									temp46 = r_3791
								else
									temp46 = (funct2 == "macro")
								end
							end
						end
						if temp46 then
							traverseList1(node11, 1, visitor6)
							return visitor6(node11, visitor6)
						else
							return fail_21_1(_2e2e_2("Unknown kind ", funct2, " for variable ", func4["name"]))
						end
					end
				end
			end
		else
			traverseList1(node11, 1, visitor6)
			return visitor6(node11, visitor6)
		end
	else
		return error1(_2e2e_2("Unknown tag ", tag6))
	end
end)
traverseBlock1 = (function(node12, start3, visitor7)
	local r_3521 = _23_1(node12)
	local r_3501 = nil
	r_3501 = (function(r_3511)
		if (r_3511 <= r_3521) then
			local result5 = traverseNode1(nth1(node12, (r_3511 + 0)), visitor7)
			node12[r_3511] = result5
			return r_3501((r_3511 + 1))
		else
		end
	end)
	r_3501(start3)
	return node12
end)
traverseList1 = (function(node13, start4, visitor8)
	local r_3561 = _23_1(node13)
	local r_3541 = nil
	r_3541 = (function(r_3551)
		if (r_3551 <= r_3561) then
			node13[r_3551] = traverseNode1(nth1(node13, r_3551), visitor8)
			return r_3541((r_3551 + 1))
		else
		end
	end)
	r_3541(start4)
	return node13
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
putNodeError_21_1 = (function(logger5, msg6, node14, explain1, ...)
	local lines1 = _pack(...) lines1.tag = "list"
	return self1(logger5, "put-node-error!", msg6, node14, explain1, lines1)
end)
putNodeWarning_21_1 = (function(logger6, msg7, node15, explain2, ...)
	local lines2 = _pack(...) lines2.tag = "list"
	return self1(logger6, "put-node-warning!", msg7, node15, explain2, lines2)
end)
doNodeError_21_1 = (function(logger7, msg8, node16, explain3, ...)
	local lines3 = _pack(...) lines3.tag = "list"
	self1(logger7, "put-node-error!", msg8, node16, explain3, lines3)
	return fail_21_1((function(r_3801)
		if r_3801 then
			return r_3801
		else
			return msg8
		end
	end)(match1(msg8, "^([^\n]+)\n")))
end)
struct1("putError", putError_21_1, "putWarning", putWarning_21_1, "putVerbose", putVerbose_21_1, "putDebug", putDebug_21_1, "putNodeError", putNodeError_21_1, "putNodeWarning", putNodeWarning_21_1, "doNodeError", doNodeError_21_1)
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
formatNode1 = (function(node17)
	local temp47
	local r_3811 = node17["range"]
	if r_3811 then
		temp47 = node17["contents"]
	else
		temp47 = r_3811
	end
	if temp47 then
		return format1("%s (%q)", formatRange1(node17["range"]), node17["contents"])
	elseif node17["range"] then
		return formatRange1(node17["range"])
	elseif node17["owner"] then
		local owner1 = node17["owner"]
		if owner1["var"] then
			return format1("macro expansion of %s (%s)", owner1["var"]["name"], formatNode1(owner1["node"]))
		else
			return format1("unquote expansion (%s)", formatNode1(owner1["node"]))
		end
	else
		local temp48
		local r_3841 = node17["start"]
		if r_3841 then
			temp48 = node17["finish"]
		else
			temp48 = r_3841
		end
		if temp48 then
			return formatRange1(node17)
		else
			return "?"
		end
	end
end)
getSource1 = (function(node18)
	local result6 = nil
	local r_3821 = nil
	r_3821 = (function()
		local temp49
		local r_3831 = node18
		if r_3831 then
			temp49 = _21_1(result6)
		else
			temp49 = r_3831
		end
		if temp49 then
			result6 = node18["range"]
			node18 = node18["parent"]
			return r_3821()
		else
		end
	end)
	r_3821()
	return result6
end)
struct1("formatPosition", formatPosition1, "formatRange", formatRange1, "formatNode", formatNode1, "getSource", getSource1)
builtins4 = require1("tacky.analysis.resolve")["builtins"]
builtinVars2 = require1("tacky.analysis.resolve")["declaredVars"]
hasSideEffect1 = (function(node19)
	local tag7 = type1(node19)
	local temp50
	local r_2571 = (tag7 == "number")
	if r_2571 then
		temp50 = r_2571
	else
		local r_2581 = (tag7 == "string")
		if r_2581 then
			temp50 = r_2581
		else
			local r_2591 = (tag7 == "key")
			if r_2591 then
				temp50 = r_2591
			else
				temp50 = (tag7 == "symbol")
			end
		end
	end
	if temp50 then
		return false
	elseif (tag7 == "list") then
		local fst1 = car2(node19)
		if (type1(fst1) == "symbol") then
			local var5 = fst1["var"]
			local r_2601 = (var5 ~= builtins4["lambda"])
			if r_2601 then
				return (var5 ~= builtins4["quote"])
			else
				return r_2601
			end
		else
			return true
		end
	else
		_error("unmatched item")
	end
end)
constant_3f_1 = (function(node20)
	local r_2611 = string_3f_1(node20)
	if r_2611 then
		return r_2611
	else
		local r_2621 = number_3f_1(node20)
		if r_2621 then
			return r_2621
		else
			return key_3f_1(node20)
		end
	end
end)
urn_2d3e_val1 = (function(node21)
	if string_3f_1(node21) then
		return node21["value"]
	elseif number_3f_1(node21) then
		return node21["value"]
	elseif key_3f_1(node21) then
		return node21["value"]
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
		return struct1("tag", "symbol", "contents", "nil", "var", builtinVars2["nil"])
	elseif (ty3 == "boolean") then
		return struct1("tag", "symbol", "contents", tostring1(val9), "var", builtinVars2[tostring1(val9)])
	else
		_error("unmatched item")
	end
end)
truthy_3f_1 = (function(node22)
	local temp51
	local r_2631 = string_3f_1(node22)
	if r_2631 then
		temp51 = r_2631
	else
		local r_2641 = key_3f_1(node22)
		if r_2641 then
			temp51 = r_2641
		else
			temp51 = number_3f_1(node22)
		end
	end
	if temp51 then
		return true
	elseif symbol_3f_1(node22) then
		return (builtinVars2["true"] == node22["var"])
	else
		return false
	end
end)
makeProgn1 = (function(body1)
	local lambda1 = struct1("tag", "symbol", "contents", "lambda", "var", builtins4["lambda"])
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
getConstantVal1 = (function(lookup1, sym1)
	local var6 = sym1["var"]
	local def2 = getVar1(lookup1, sym1["var"])
	if (var6 == builtinVars2["true"]) then
		return sym1
	elseif (var6 == builtinVars2["false"]) then
		return sym1
	elseif (var6 == builtinVars2["nil"]) then
		return sym1
	elseif (_23_keys1(def2["defs"]) == 1) then
		local ent1 = nth1(list1(next1(def2["defs"])), 2)
		local val10 = ent1["value"]
		local ty4 = ent1["tag"]
		local temp52
		local r_2651 = string_3f_1(val10)
		if r_2651 then
			temp52 = r_2651
		else
			local r_2661 = number_3f_1(val10)
			if r_2661 then
				temp52 = r_2661
			else
				temp52 = key_3f_1(val10)
			end
		end
		if temp52 then
			return val10
		else
			local temp53
			local r_2671 = symbol_3f_1(val10)
			if r_2671 then
				local r_2681 = (ty4 == "define")
				if r_2681 then
					temp53 = r_2681
				else
					local r_2691 = (ty4 == "set")
					if r_2691 then
						temp53 = r_2691
					else
						temp53 = (ty4 == "let")
					end
				end
			else
				temp53 = r_2671
			end
			if temp53 then
				local r_2701 = getConstantVal1(lookup1, val10)
				if r_2701 then
					return r_2701
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
optimiseOnce1 = (function(nodes3, state8)
	local changed1 = false
	local r_2711 = nil
	r_2711 = (function(r_2721)
		local temp54
		if false then
			temp54 = (r_2721 <= 1)
		else
			temp54 = (r_2721 >= 1)
		end
		if temp54 then
			local node23 = nth1(nodes3, r_2721)
			local temp55
			local r_2751 = list_3f_1(node23)
			if r_2751 then
				local r_2761 = (_23_1(node23) > 0)
				if r_2761 then
					local r_2771 = symbol_3f_1(car2(node23))
					if r_2771 then
						temp55 = (car2(node23)["var"] == builtins4["import"])
					else
						temp55 = r_2771
					end
				else
					temp55 = r_2761
				end
			else
				temp55 = r_2751
			end
			if temp55 then
				if (r_2721 == _23_1(nodes3)) then
					nodes3[r_2721] = struct1("tag", "symbol", "contents", "nil", "var", builtinVars2["nil"])
				else
					removeNth_21_1(nodes3, r_2721)
				end
				changed1 = true
			else
			end
			return r_2711((r_2721 + -1))
		else
		end
	end)
	r_2711(_23_1(nodes3))
	local r_2781 = nil
	r_2781 = (function(r_2791)
		local temp56
		if false then
			temp56 = (r_2791 <= 1)
		else
			temp56 = (r_2791 >= 1)
		end
		if temp56 then
			local node24 = nth1(nodes3, r_2791)
			if _21_1(hasSideEffect1(node24)) then
				removeNth_21_1(nodes3, r_2791)
				changed1 = true
			else
			end
			return r_2781((r_2791 + -1))
		else
		end
	end)
	r_2781(pred1(_23_1(nodes3)))
	traverseList1(nodes3, 1, (function(node25)
		local temp57
		local r_3851 = list_3f_1(node25)
		if r_3851 then
			temp57 = all1(constant_3f_1, cdr2(node25))
		else
			temp57 = r_3851
		end
		if temp57 then
			local head1 = car2(node25)
			local meta1
			local r_3901 = symbol_3f_1(head1)
			if r_3901 then
				local r_3911 = _21_1(head1["folded"])
				if r_3911 then
					local r_3921 = (head1["var"]["tag"] == "native")
					if r_3921 then
						meta1 = state8["meta"][head1["var"]["fullName"]]
					else
						meta1 = r_3921
					end
				else
					meta1 = r_3911
				end
			else
				meta1 = r_3901
			end
			local temp58
			if meta1 then
				local r_3871 = meta1["pure"]
				if r_3871 then
					temp58 = meta1["value"]
				else
					temp58 = r_3871
				end
			else
				temp58 = meta1
			end
			if temp58 then
				local res3 = list1(pcall1(meta1["value"], unpack1(map1(urn_2d3e_val1, cdr2(node25)))))
				if car2(res3) then
					local val11 = nth1(res3, 2)
					local temp59
					local r_3881 = number_3f_1(val11)
					if r_3881 then
						local r_3891 = (cadr1(list1(modf1(val11))) ~= 0)
						if r_3891 then
							temp59 = r_3891
						else
							temp59 = (abs1(val11) == huge1)
						end
					else
						temp59 = r_3881
					end
					if temp59 then
						head1["folded"] = true
						return node25
					else
						return val_2d3e_urn1(val11)
					end
				else
					head1["folded"] = true
					putNodeWarning_21_1(state8["logger"], _2e2e_2("Cannot execute constant expression"), node25, nil, getSource1(node25), _2e2e_2("Executed ", pretty1(node25), ", failed with: ", nth1(res3, 2)))
					return node25
				end
			else
				return node25
			end
		else
			return node25
		end
	end))
	traverseList1(nodes3, 1, (function(node26)
		local temp60
		local r_3931 = list_3f_1(node26)
		if r_3931 then
			local r_3941 = symbol_3f_1(car2(node26))
			if r_3941 then
				temp60 = (car2(node26)["var"] == builtins4["cond"])
			else
				temp60 = r_3941
			end
		else
			temp60 = r_3931
		end
		if temp60 then
			local final1 = nil
			local r_3971 = _23_1(node26)
			local r_3951 = nil
			r_3951 = (function(r_3961)
				if (r_3961 <= r_3971) then
					local case3 = nth1(node26, r_3961)
					if final1 then
						changed1 = true
						removeNth_21_1(node26, final1)
					elseif truthy_3f_1(car2(nth1(node26, r_3961))) then
						final1 = succ1(r_3961)
					else
					end
					return r_3951((r_3961 + 1))
				else
				end
			end)
			r_3951(2)
			local temp61
			local r_3991 = (_23_1(node26) == 2)
			if r_3991 then
				temp61 = truthy_3f_1(car2(nth1(node26, 2)))
			else
				temp61 = r_3991
			end
			if temp61 then
				changed1 = true
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
	local lookup2 = createState1()
	definitionsVisit1(lookup2, nodes3)
	usagesVisit1(lookup2, nodes3, hasSideEffect1)
	local r_4001 = nil
	r_4001 = (function(r_4011)
		local temp62
		if false then
			temp62 = (r_4011 <= 1)
		else
			temp62 = (r_4011 >= 1)
		end
		if temp62 then
			local node27 = nth1(nodes3, r_4011)
			local temp63
			local r_4041 = node27["defVar"]
			if r_4041 then
				temp63 = _21_1(getVar1(lookup2, node27["defVar"])["active"])
			else
				temp63 = r_4041
			end
			if temp63 then
				if (r_4011 == _23_1(nodes3)) then
					nodes3[r_4011] = struct1("tag", "symbol", "contents", "nil", "var", builtinVars2["nil"])
				else
					removeNth_21_1(nodes3, r_4011)
				end
				changed1 = true
			else
			end
			return r_4001((r_4011 + -1))
		else
		end
	end)
	r_4001(_23_1(nodes3))
	visitBlock1(nodes3, 1, (function(node28)
		local temp64
		local r_4051 = list_3f_1(node28)
		if r_4051 then
			local r_4061 = list_3f_1(car2(node28))
			if r_4061 then
				local r_4071 = symbol_3f_1(caar1(node28))
				if r_4071 then
					temp64 = (caar1(node28)["var"] == builtins4["lambda"])
				else
					temp64 = r_4071
				end
			else
				temp64 = r_4061
			end
		else
			temp64 = r_4051
		end
		if temp64 then
			local lam2 = car2(node28)
			local args5 = nth1(lam2, 2)
			local offset2 = 1
			local remOffset1 = 0
			local r_4101 = _23_1(args5)
			local r_4081 = nil
			r_4081 = (function(r_4091)
				if (r_4091 <= r_4101) then
					local arg21 = nth1(args5, (r_4091 - remOffset1))
					local val12 = nth1(node28, ((r_4091 + offset2) - remOffset1))
					if arg21["var"]["isVariadic"] then
						local count2 = (_23_1(node28) - _23_1(args5))
						if (count2 < 0) then
							count2 = 0
						else
						end
						offset2 = count2
					elseif (nil == val12) then
					elseif hasSideEffect1(val12) then
					elseif (_23_keys1(getVar1(lookup2, arg21["var"])["usages"]) > 0) then
					else
						removeNth_21_1(args5, (r_4091 - remOffset1))
						removeNth_21_1(node28, ((r_4091 + offset2) - remOffset1))
						remOffset1 = (remOffset1 + 1)
					end
					return r_4081((r_4091 + 1))
				else
				end
			end)
			return r_4081(1)
		else
		end
	end))
	traverseList1(nodes3, 1, (function(node29)
		if symbol_3f_1(node29) then
			local var7 = getConstantVal1(lookup2, node29)
			local temp65
			if var7 then
				temp65 = (var7 ~= node29)
			else
				temp65 = var7
			end
			if temp65 then
				changed1 = true
				return var7
			else
				return node29
			end
		else
			return node29
		end
	end))
	return changed1
end)
optimise1 = (function(nodes4, state9)
	if state9 then
	else
		state9 = struct1("meta", ({}))
	end
	local iteration1 = 0
	local changed2 = true
	local r_2821 = nil
	r_2821 = (function()
		local temp66
		local r_2831 = changed2
		if r_2831 then
			temp66 = (iteration1 < 10)
		else
			temp66 = r_2831
		end
		if temp66 then
			changed2 = optimiseOnce1(nodes4, state9)
			iteration1 = (iteration1 + 1)
			return r_2821()
		else
		end
	end)
	r_2821()
	return nodes4
end)
builtins5 = require1("tacky.analysis.resolve")["builtins"]
sideEffect_3f_1 = (function(node30)
	local tag8 = type1(node30)
	local temp67
	local r_4131 = (tag8 == "number")
	if r_4131 then
		temp67 = r_4131
	else
		local r_4141 = (tag8 == "string")
		if r_4141 then
			temp67 = r_4141
		else
			local r_4151 = (tag8 == "key")
			if r_4151 then
				temp67 = r_4151
			else
				temp67 = (tag8 == "symbol")
			end
		end
	end
	if temp67 then
		return false
	elseif (tag8 == "list") then
		local fst2 = car2(node30)
		if (type1(fst2) == "symbol") then
			local var8 = fst2["var"]
			local r_4161 = (var8 ~= builtins5["lambda"])
			if r_4161 then
				return (var8 ~= builtins5["quote"])
			else
				return r_4161
			end
		else
			return true
		end
	else
		_error("unmatched item")
	end
end)
warnArity1 = (function(lookup3, nodes5, state10)
	local arity1
	local getArity1
	arity1 = ({})
	getArity1 = (function(symbol1)
		local var9 = getVar1(lookup3, symbol1["var"])
		local ari1 = arity1[var9]
		if (ari1 ~= nil) then
			return ari1
		elseif (_23_keys1(var9["defs"]) ~= 1) then
			return false
		else
			arity1[var9] = false
			local defData1 = cadr1(list1(next1(var9["defs"])))
			local def3 = defData1["value"]
			if (defData1["tag"] == "arg") then
				ari1 = false
			else
				if symbol_3f_1(def3) then
					ari1 = getArity1(def3)
				else
					local temp68
					local r_4171 = list_3f_1(def3)
					if r_4171 then
						local r_4181 = symbol_3f_1(car2(def3))
						if r_4181 then
							temp68 = (car2(def3)["var"] == builtins5["lambda"])
						else
							temp68 = r_4181
						end
					else
						temp68 = r_4171
					end
					if temp68 then
						local args6 = nth1(def3, 2)
						if any1((function(x22)
							return x22["var"]["isVariadic"]
						end), args6) then
							ari1 = false
						else
							ari1 = _23_1(args6)
						end
					else
						ari1 = false
					end
				end
			end
			arity1[var9] = ari1
			return ari1
		end
	end)
	return visitBlock1(nodes5, 1, (function(node31)
		local temp69
		local r_4191 = list_3f_1(node31)
		if r_4191 then
			temp69 = symbol_3f_1(car2(node31))
		else
			temp69 = r_4191
		end
		if temp69 then
			local arity2 = getArity1(car2(node31))
			local temp70
			if arity2 then
				temp70 = (arity2 < pred1(_23_1(node31)))
			else
				temp70 = arity2
			end
			if temp70 then
				return putNodeWarning_21_1(state10["logger"], _2e2e_2("Calling ", symbol_2d3e_string1(car2(node31)), " with ", tonumber1(pred1(_23_1(node31))), " arguments, expected ", tonumber1(arity2)), node31, nil, getSource1(node31), "Called here")
			else
			end
		else
		end
	end))
end)
analyse1 = (function(nodes6, state11)
	local lookup4 = createState1()
	definitionsVisit1(lookup4, nodes6)
	usagesVisit1(lookup4, nodes6, sideEffect_3f_1)
	warnArity1(lookup4, nodes6, state11)
	return nodes6
end)
create2 = (function()
	return struct1("out", {tag = "list", n = 0}, "indent", 0, "tabs-pending", false, "line", 1, "lines", ({}), "node-stack", {tag = "list", n = 0}, "active-pos", nil)
end)
append_21_1 = (function(writer1, text2)
	local r_4321 = type1(text2)
	if (r_4321 ~= "string") then
		error1(format1("bad argment %s (expected %s, got %s)", "text", "string", r_4321), 2)
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
pushNode_21_1 = (function(writer8, node32)
	local range2 = getSource1(node32)
	if range2 then
		pushCdr_21_1(writer8["node-stack"], node32)
		writer8["active-pos"] = range2
		return nil
	else
	end
end)
popNode_21_1 = (function(writer9, node33)
	local range3 = getSource1(node33)
	if range3 then
		local stack1 = writer9["node-stack"]
		local previous1 = last1(stack1)
		if (previous1 == node33) then
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
estimateLength1 = (function(node34, max4)
	local tag9 = node34["tag"]
	local temp72
	local r_4211 = (tag9 == "string")
	if r_4211 then
		temp72 = r_4211
	else
		local r_4221 = (tag9 == "number")
		if r_4221 then
			temp72 = r_4221
		else
			local r_4231 = (tag9 == "symbol")
			if r_4231 then
				temp72 = r_4231
			else
				temp72 = (tag9 == "key")
			end
		end
	end
	if temp72 then
		return len1(tostring1(node34["contents"]))
	elseif (tag9 == "list") then
		local sum1 = 2
		local i1 = 1
		local r_4241 = nil
		r_4241 = (function()
			local temp73
			local r_4251 = (sum1 <= max4)
			if r_4251 then
				temp73 = (i1 <= _23_1(node34))
			else
				temp73 = r_4251
			end
			if temp73 then
				sum1 = (sum1 + estimateLength1(nth1(node34, i1), (max4 - sum1)))
				if (i1 > 1) then
					sum1 = (sum1 + 1)
				else
				end
				i1 = (i1 + 1)
				return r_4241()
			else
			end
		end)
		r_4241()
		return sum1
	else
		return fail_21_1(_2e2e_2("Unknown tag ", tag9))
	end
end)
expression1 = (function(node35, writer11)
	local tag10 = node35["tag"]
	if (tag10 == "string") then
		return append_21_1(writer11, quoted1(node35["value"]))
	elseif (tag10 == "number") then
		return append_21_1(writer11, tostring1(node35["value"]))
	elseif (tag10 == "key") then
		return append_21_1(writer11, _2e2e_2(":", node35["value"]))
	elseif (tag10 == "symbol") then
		return append_21_1(writer11, node35["contents"])
	elseif (tag10 == "list") then
		append_21_1(writer11, "(")
		if nil_3f_1(node35) then
			return append_21_1(writer11, ")")
		else
			local newline1 = false
			local max5 = (60 - estimateLength1(car2(node35), 60))
			expression1(car2(node35), writer11)
			if (max5 <= 0) then
				newline1 = true
				indent_21_1(writer11)
			else
			end
			local r_4361 = _23_1(node35)
			local r_4341 = nil
			r_4341 = (function(r_4351)
				if (r_4351 <= r_4361) then
					local entry3 = nth1(node35, r_4351)
					local temp74
					local r_4381 = _21_1(newline1)
					if r_4381 then
						temp74 = (max5 > 0)
					else
						temp74 = r_4381
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
					return r_4341((r_4351 + 1))
				else
				end
			end)
			r_4341(2)
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
	local r_4301 = _23_1(list2)
	local r_4281 = nil
	r_4281 = (function(r_4291)
		if (r_4291 <= r_4301) then
			local node36 = list2[r_4291]
			expression1(node36, writer12)
			line_21_1(writer12)
			return r_4281((r_4291 + 1))
		else
		end
	end)
	return r_4281(1)
end)
createLookup1 = (function(...)
	local lst2 = _pack(...) lst2.tag = "list"
	local out4 = ({})
	local r_4431 = _23_1(lst2)
	local r_4411 = nil
	r_4411 = (function(r_4421)
		if (r_4421 <= r_4431) then
			local entry4 = lst2[r_4421]
			out4[entry4] = true
			return r_4411((r_4421 + 1))
		else
		end
	end)
	r_4411(1)
	return out4
end)
keywords1 = createLookup1("and", "break", "do", "else", "elseif", "end", "false", "for", "function", "if", "in", "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while")
createState2 = (function(meta2)
	return struct1("ctr-lookup", ({}), "var-lookup", ({}), "meta", (function()
		if meta2 then
			return meta2
		else
			return ({})
		end
	end)())
end)
builtins6 = require1("tacky.analysis.resolve")["builtins"]
builtinVars3 = require1("tacky.analysis.resolve")["declaredVars"]
escape1 = (function(name6)
	if keywords1[name6] then
		return _2e2e_2("_e", name6)
	elseif find1(name6, "^%w[_%w%d]*$") then
		return name6
	else
		local out5
		local temp75
		local r_5811
		r_5811 = charAt1(name6, 1)
		temp75 = find1(r_5811, "%d")
		if temp75 then
			out5 = "_e"
		else
			out5 = ""
		end
		local upper2 = false
		local esc1 = false
		local r_4571 = len1(name6)
		local r_4551 = nil
		r_4551 = (function(r_4561)
			if (r_4561 <= r_4571) then
				local char2 = charAt1(name6, r_4561)
				local temp76
				local r_4591 = (char2 == "-")
				if r_4591 then
					local r_4601
					local r_5771
					r_5771 = charAt1(name6, pred1(r_4561))
					r_4601 = find1(r_5771, "[%a%d']")
					if r_4601 then
						local r_5751
						r_5751 = charAt1(name6, succ1(r_4561))
						temp76 = find1(r_5751, "[%a%d']")
					else
						temp76 = r_4601
					end
				else
					temp76 = r_4591
				end
				if temp76 then
					upper2 = true
				elseif find1(char2, "[^%w%d]") then
					local r_5791
					local r_5781 = char2
					r_5791 = byte1(r_5781)
					char2 = format1("%02x", r_5791)
					if esc1 then
					else
						esc1 = true
						out5 = _2e2e_2(out5, "_")
					end
					out5 = _2e2e_2(out5, char2)
				else
					if esc1 then
						esc1 = false
						out5 = _2e2e_2(out5, "_")
					else
					end
					if upper2 then
						upper2 = false
						char2 = upper1(char2)
					else
					end
					out5 = _2e2e_2(out5, char2)
				end
				return r_4551((r_4561 + 1))
			else
			end
		end)
		r_4551(1)
		if esc1 then
			out5 = _2e2e_2(out5, "_")
		else
		end
		return out5
	end
end)
escapeVar1 = (function(var10, state12)
	if builtinVars3[var10] then
		return var10["name"]
	else
		local v1 = escape1(var10["name"])
		local id1 = state12["var-lookup"][var10]
		if id1 then
		else
			id1 = succ1((function(r_4461)
				if r_4461 then
					return r_4461
				else
					return 0
				end
			end)(state12["ctr-lookup"][v1]))
			state12["ctr-lookup"][v1] = id1
			state12["var-lookup"][var10] = id1
		end
		return _2e2e_2(v1, tostring1(id1))
	end
end)
statement_3f_1 = (function(node37)
	if list_3f_1(node37) then
		local first6 = car2(node37)
		if symbol_3f_1(first6) then
			return (first6["var"] == builtins6["cond"])
		elseif list_3f_1(first6) then
			local func5 = car2(first6)
			local r_4471 = symbol_3f_1(func5)
			if r_4471 then
				return (func5["var"] == builtins6["lambda"])
			else
				return r_4471
			end
		else
			return false
		end
	else
		return false
	end
end)
literal_3f_1 = (function(node38)
	if list_3f_1(node38) then
		local first7 = car2(node38)
		local r_4481 = symbol_3f_1(first7)
		if r_4481 then
			local r_4491 = (first7["var"] == builtins6["quote"])
			if r_4491 then
				return r_4491
			else
				return (first7["var"] == builtins6["syntax-quote"])
			end
		else
			return r_4481
		end
	elseif symbol_3f_1(node38) then
		return builtinVars3[node38["var"]]
	else
		return true
	end
end)
truthy_3f_2 = (function(node39)
	local r_4501 = symbol_3f_1(node39)
	if r_4501 then
		return (builtinVars3["true"] == node39["var"])
	else
		return r_4501
	end
end)
compileQuote1 = (function(node40, out6, state13, level3)
	if (level3 == 0) then
		return compileExpression1(node40, out6, state13)
	else
		local ty5 = type1(node40)
		if (ty5 == "string") then
			return append_21_1(out6, quoted1(node40["value"]))
		elseif (ty5 == "number") then
			return append_21_1(out6, tostring1(node40["value"]))
		elseif (ty5 == "symbol") then
			append_21_1(out6, _2e2e_2("{ tag=\"symbol\", contents=", quoted1(node40["contents"])))
			if node40["var"] then
				append_21_1(out6, _2e2e_2(", var=", quoted1(tostring1(node40["var"]))))
			else
			end
			return append_21_1(out6, "}")
		elseif (ty5 == "key") then
			return append_21_1(out6, _2e2e_2("{tag=\"key\", value=", quoted1(node40["value"]), "}"))
		elseif (ty5 == "list") then
			local first8 = car2(node40)
			local temp77
			local r_4611 = symbol_3f_1(first8)
			if r_4611 then
				local r_4621 = (first8["var"] == builtins6["unquote"])
				if r_4621 then
					temp77 = r_4621
				else
					temp77 = ("var" == builtins6["unquote-splice"])
				end
			else
				temp77 = r_4611
			end
			if temp77 then
				return compileQuote1(nth1(node40, 2), out6, state13, (function()
					if level3 then
						return pred1(level3)
					else
						return level3
					end
				end)())
			else
				local temp78
				local r_4641 = symbol_3f_1(first8)
				if r_4641 then
					temp78 = (first8["var"] == builtins6["syntax-quote"])
				else
					temp78 = r_4641
				end
				if temp78 then
					return compileQuote1(nth1(node40, 2), out6, state13, (function()
						if level3 then
							return succ1(level3)
						else
							return level3
						end
					end)())
				else
					pushNode_21_1(out6, node40)
					local containsUnsplice1 = false
					local r_4701 = _23_1(node40)
					local r_4681 = nil
					r_4681 = (function(r_4691)
						if (r_4691 <= r_4701) then
							local sub4 = node40[r_4691]
							local temp79
							local r_4721 = list_3f_1(sub4)
							if r_4721 then
								local r_4731 = symbol_3f_1(car2(sub4))
								if r_4731 then
									temp79 = (sub4[1]["var"] == builtins6["unquote-splice"])
								else
									temp79 = r_4731
								end
							else
								temp79 = r_4721
							end
							if temp79 then
								containsUnsplice1 = true
							else
							end
							return r_4681((r_4691 + 1))
						else
						end
					end)
					r_4681(1)
					if containsUnsplice1 then
						local offset3 = 0
						beginBlock_21_1(out6, "(function()")
						line_21_1(out6, "local _offset, _result, _temp = 0, {tag=\"list\",n=0}")
						local r_4761 = _23_1(node40)
						local r_4741 = nil
						r_4741 = (function(r_4751)
							if (r_4751 <= r_4761) then
								local sub5 = nth1(node40, r_4751)
								local temp80
								local r_4781 = list_3f_1(sub5)
								if r_4781 then
									local r_4791 = symbol_3f_1(car2(sub5))
									if r_4791 then
										temp80 = (sub5[1]["var"] == builtins6["unquote-splice"])
									else
										temp80 = r_4791
									end
								else
									temp80 = r_4781
								end
								if temp80 then
									offset3 = (offset3 + 1)
									append_21_1(out6, "_temp = ")
									compileQuote1(nth1(sub5, 2), out6, state13, pred1(level3))
									line_21_1(out6)
									line_21_1(out6, _2e2e_2("for _c = 1, _temp.n do _result[", tostring1((r_4751 - offset3)), " + _c + _offset] = _temp[_c] end"))
									line_21_1(out6, "_offset = _offset + _temp.n")
								else
									append_21_1(out6, _2e2e_2("_result[", tostring1((r_4751 - offset3)), " + _offset] = "))
									compileQuote1(sub5, out6, state13, level3)
									line_21_1(out6)
								end
								return r_4741((r_4751 + 1))
							else
							end
						end)
						r_4741(1)
						line_21_1(out6, _2e2e_2("_result.n = _offset + ", tostring1((_23_1(node40) - offset3))))
						line_21_1(out6, "return _result")
						endBlock_21_1(out6, "end)()")
					else
						append_21_1(out6, _2e2e_2("{tag = \"list\", n = ", tostring1(_23_1(node40))))
						local r_4841 = _23_1(node40)
						local r_4821 = nil
						r_4821 = (function(r_4831)
							if (r_4831 <= r_4841) then
								local sub6 = node40[r_4831]
								append_21_1(out6, ", ")
								compileQuote1(sub6, out6, state13, level3)
								return r_4821((r_4831 + 1))
							else
							end
						end)
						r_4821(1)
						append_21_1(out6, "}")
					end
					return popNode_21_1(out6, node40)
				end
			end
		else
			return error1(_2e2e_2("Unknown type ", ty5))
		end
	end
end)
compileExpression1 = (function(node41, out7, state14, ret1)
	if list_3f_1(node41) then
		pushNode_21_1(out7, node41)
		local head2 = car2(node41)
		if symbol_3f_1(head2) then
			local var11 = head2["var"]
			if (var11 == builtins6["lambda"]) then
				if (ret1 == "") then
				else
					if ret1 then
						append_21_1(out7, ret1)
					else
					end
					local args7 = nth1(node41, 2)
					local variadic1 = nil
					local i2 = 1
					append_21_1(out7, "(function(")
					local r_4861 = nil
					r_4861 = (function()
						local temp81
						local r_4871 = (i2 <= _23_1(args7))
						if r_4871 then
							temp81 = _21_1(variadic1)
						else
							temp81 = r_4871
						end
						if temp81 then
							if (i2 > 1) then
								append_21_1(out7, ", ")
							else
							end
							local var12 = args7[i2]["var"]
							if var12["isVariadic"] then
								append_21_1(out7, "...")
								variadic1 = i2
							else
								append_21_1(out7, escapeVar1(var12, state14))
							end
							i2 = (i2 + 1)
							return r_4861()
						else
						end
					end)
					r_4861()
					beginBlock_21_1(out7, ")")
					if variadic1 then
						local argsVar1 = escapeVar1(args7[variadic1]["var"], state14)
						if (variadic1 == _23_1(args7)) then
							line_21_1(out7, _2e2e_2("local ", argsVar1, " = _pack(...) ", argsVar1, ".tag = \"list\""))
						else
							local remaining1 = (_23_1(args7) - variadic1)
							line_21_1(out7, _2e2e_2("local _n = _select(\"#\", ...) - ", tostring1(remaining1)))
							append_21_1(out7, _2e2e_2("local ", argsVar1))
							local r_4901 = _23_1(args7)
							local r_4881 = nil
							r_4881 = (function(r_4891)
								if (r_4891 <= r_4901) then
									append_21_1(out7, ", ")
									append_21_1(out7, escapeVar1(args7[r_4891]["var"], state14))
									return r_4881((r_4891 + 1))
								else
								end
							end)
							r_4881(succ1(variadic1))
							line_21_1(out7)
							beginBlock_21_1(out7, "if _n > 0 then")
							append_21_1(out7, argsVar1)
							line_21_1(out7, " = { tag=\"list\", n=_n, _unpack(_pack(...), 1, _n)}")
							local r_4941 = _23_1(args7)
							local r_4921 = nil
							r_4921 = (function(r_4931)
								if (r_4931 <= r_4941) then
									append_21_1(out7, escapeVar1(args7[r_4931]["var"], state14))
									if (r_4931 < _23_1(args7)) then
										append_21_1(out7, ", ")
									else
									end
									return r_4921((r_4931 + 1))
								else
								end
							end)
							r_4921(succ1(variadic1))
							line_21_1(out7, " = select(_n + 1, ...)")
							nextBlock_21_1(out7, "else")
							append_21_1(out7, argsVar1)
							line_21_1(out7, " = { tag=\"list\", n=0}")
							local r_4981 = _23_1(args7)
							local r_4961 = nil
							r_4961 = (function(r_4971)
								if (r_4971 <= r_4981) then
									append_21_1(out7, escapeVar1(args7[r_4971]["var"], state14))
									if (r_4971 < _23_1(args7)) then
										append_21_1(out7, ", ")
									else
									end
									return r_4961((r_4971 + 1))
								else
								end
							end)
							r_4961(succ1(variadic1))
							line_21_1(out7, " = ...")
							endBlock_21_1(out7, "end")
						end
					else
					end
					compileBlock1(node41, out7, state14, 3, "return ")
					unindent_21_1(out7)
					append_21_1(out7, "end)")
				end
			elseif (var11 == builtins6["cond"]) then
				local closure1 = _21_1(ret1)
				local hadFinal1 = false
				local ends1 = 1
				if closure1 then
					beginBlock_21_1(out7, "(function()")
					ret1 = "return "
				else
				end
				local i3 = 2
				local r_5001 = nil
				r_5001 = (function()
					local temp82
					local r_5011 = _21_1(hadFinal1)
					if r_5011 then
						temp82 = (i3 <= _23_1(node41))
					else
						temp82 = r_5011
					end
					if temp82 then
						local item1 = nth1(node41, i3)
						local case4 = nth1(item1, 1)
						local isFinal1 = truthy_3f_2(case4)
						if isFinal1 then
							if (i3 == 2) then
								append_21_1(out7, "do")
							else
							end
						elseif statement_3f_1(case4) then
							if (i3 > 2) then
								indent_21_1(out7)
								line_21_1(out7)
								ends1 = (ends1 + 1)
							else
							end
							local tmp1 = escapeVar1(struct1("name", "temp"), state14)
							line_21_1(out7, _2e2e_2("local ", tmp1))
							compileExpression1(case4, out7, state14, _2e2e_2(tmp1, " = "))
							line_21_1(out7)
							line_21_1(out7, _2e2e_2("if ", tmp1, " then"))
						else
							append_21_1(out7, "if ")
							compileExpression1(case4, out7, state14)
							append_21_1(out7, " then")
						end
						indent_21_1(out7)
						line_21_1(out7)
						compileBlock1(item1, out7, state14, 2, ret1)
						unindent_21_1(out7)
						if isFinal1 then
							hadFinal1 = true
						else
							append_21_1(out7, "else")
						end
						i3 = (i3 + 1)
						return r_5001()
					else
					end
				end)
				r_5001()
				if hadFinal1 then
				else
					indent_21_1(out7)
					line_21_1(out7)
					append_21_1(out7, "_error(\"unmatched item\")")
					unindent_21_1(out7)
					line_21_1(out7)
				end
				local r_5041 = ends1
				local r_5021 = nil
				r_5021 = (function(r_5031)
					if (r_5031 <= r_5041) then
						append_21_1(out7, "end")
						if (r_5031 < ends1) then
							unindent_21_1(out7)
							line_21_1(out7)
						else
						end
						return r_5021((r_5031 + 1))
					else
					end
				end)
				r_5021(1)
				if closure1 then
					line_21_1(out7)
					endBlock_21_1(out7, "end)()")
				else
				end
			elseif (var11 == builtins6["set!"]) then
				compileExpression1(nth1(node41, 3), out7, state14, _2e2e_2(escapeVar1(node41[2]["var"], state14), " = "))
				local temp83
				local r_5061 = ret1
				if r_5061 then
					temp83 = (ret1 ~= "")
				else
					temp83 = r_5061
				end
				if temp83 then
					line_21_1(out7)
					append_21_1(out7, ret1)
					append_21_1(out7, "nil")
				else
				end
			elseif (var11 == builtins6["define"]) then
				compileExpression1(nth1(node41, _23_1(node41)), out7, state14, _2e2e_2(escapeVar1(node41["defVar"], state14), " = "))
			elseif (var11 == builtins6["define-macro"]) then
				compileExpression1(nth1(node41, _23_1(node41)), out7, state14, _2e2e_2(escapeVar1(node41["defVar"], state14), " = "))
			elseif (var11 == builtins6["define-native"]) then
				local meta3 = state14["meta"][node41["defVar"]["fullName"]]
				local ty6 = type1(meta3)
				if (ty6 == "nil") then
					append_21_1(out7, format1("%s = _libs[%q]", escapeVar1(node41["defVar"], state14), node41["defVar"]["fullName"]))
				elseif (ty6 == "var") then
					append_21_1(out7, format1("%s = %s", escapeVar1(node41["defVar"], state14), meta3["contents"]))
				else
					local temp84
					local r_5071 = (ty6 == "expr")
					if r_5071 then
						temp84 = r_5071
					else
						temp84 = (ty6 == "stmt")
					end
					if temp84 then
						local count3 = meta3["count"]
						append_21_1(out7, format1("%s = function(", escapeVar1(node41["defVar"], state14)))
						local r_5081 = nil
						r_5081 = (function(r_5091)
							if (r_5091 <= count3) then
								if (r_5091 == 1) then
								else
									append_21_1(out7, ", ")
								end
								append_21_1(out7, _2e2e_2("v", tonumber1(r_5091)))
								return r_5081((r_5091 + 1))
							else
							end
						end)
						r_5081(1)
						append_21_1(out7, ") ")
						if (ty6 == "expr") then
							append_21_1(out7, "return ")
						else
						end
						local r_5131 = meta3["contents"]
						local r_5161 = _23_1(r_5131)
						local r_5141 = nil
						r_5141 = (function(r_5151)
							if (r_5151 <= r_5161) then
								local entry5 = r_5131[r_5151]
								if number_3f_1(entry5) then
									append_21_1(out7, _2e2e_2("v", tonumber1(entry5)))
								else
									append_21_1(out7, entry5)
								end
								return r_5141((r_5151 + 1))
							else
							end
						end)
						r_5141(1)
						append_21_1(out7, " end")
					else
						_error("unmatched item")
					end
				end
			elseif (var11 == builtins6["quote"]) then
				if (ret1 == "") then
				else
					if ret1 then
						append_21_1(out7, ret1)
					else
					end
					compileQuote1(nth1(node41, 2), out7, state14)
				end
			elseif (var11 == builtins6["syntax-quote"]) then
				if (ret1 == "") then
					append_21_1(out7, "local _ =")
				elseif ret1 then
					append_21_1(out7, ret1)
				else
				end
				compileQuote1(nth1(node41, 2), out7, state14, 1)
			elseif (var11 == builtins6["unquote"]) then
				fail_21_1("unquote outside of syntax-quote")
			elseif (var11 == builtins6["unquote-splice"]) then
				fail_21_1("unquote-splice outside of syntax-quote")
			elseif (var11 == builtins6["import"]) then
				if (ret1 == nil) then
					append_21_1(out7, "nil")
				elseif (ret1 ~= "") then
					append_21_1(out7, ret1)
					append_21_1(out7, "nil")
				else
				end
			else
				local meta4
				local r_5291 = symbol_3f_1(head2)
				if r_5291 then
					local r_5301 = (head2["var"]["tag"] == "native")
					if r_5301 then
						meta4 = state14["meta"][head2["var"]["fullName"]]
					else
						meta4 = r_5301
					end
				else
					meta4 = r_5291
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
				local temp85
				local r_5181 = meta4
				if r_5181 then
					temp85 = (pred1(_23_1(node41)) == meta4["count"])
				else
					temp85 = r_5181
				end
				if temp85 then
					local temp86
					local r_5191 = ret1
					if r_5191 then
						temp86 = (meta4["tag"] == "expr")
					else
						temp86 = r_5191
					end
					if temp86 then
						append_21_1(out7, ret1)
					else
					end
					local contents2 = meta4["contents"]
					local r_5221 = _23_1(contents2)
					local r_5201 = nil
					r_5201 = (function(r_5211)
						if (r_5211 <= r_5221) then
							local entry6 = nth1(contents2, r_5211)
							if number_3f_1(entry6) then
								compileExpression1(nth1(node41, succ1(entry6)), out7, state14)
							else
								append_21_1(out7, entry6)
							end
							return r_5201((r_5211 + 1))
						else
						end
					end)
					r_5201(1)
					local temp87
					local r_5241 = (meta4["tag"] ~= "expr")
					if r_5241 then
						temp87 = (ret1 ~= "")
					else
						temp87 = r_5241
					end
					if temp87 then
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
						compileExpression1(head2, out7, state14)
						append_21_1(out7, ")")
					else
						compileExpression1(head2, out7, state14)
					end
					append_21_1(out7, "(")
					local r_5271 = _23_1(node41)
					local r_5251 = nil
					r_5251 = (function(r_5261)
						if (r_5261 <= r_5271) then
							if (r_5261 > 2) then
								append_21_1(out7, ", ")
							else
							end
							compileExpression1(nth1(node41, r_5261), out7, state14)
							return r_5251((r_5261 + 1))
						else
						end
					end)
					r_5251(2)
					append_21_1(out7, ")")
				end
			end
		else
			local temp88
			local r_5311 = ret1
			if r_5311 then
				local r_5321 = list_3f_1(head2)
				if r_5321 then
					local r_5331 = symbol_3f_1(car2(head2))
					if r_5331 then
						temp88 = (head2[1]["var"] == builtins6["lambda"])
					else
						temp88 = r_5331
					end
				else
					temp88 = r_5321
				end
			else
				temp88 = r_5311
			end
			if temp88 then
				local args8 = nth1(head2, 2)
				local offset4 = 1
				local r_5361 = _23_1(args8)
				local r_5341 = nil
				r_5341 = (function(r_5351)
					if (r_5351 <= r_5361) then
						local var13 = args8[r_5351]["var"]
						append_21_1(out7, _2e2e_2("local ", escapeVar1(var13, state14)))
						if var13["isVariadic"] then
							local count4 = (_23_1(node41) - _23_1(args8))
							if (count4 < 0) then
								count4 = 0
							else
							end
							append_21_1(out7, " = { tag=\"list\", n=")
							append_21_1(out7, tostring1(count4))
							local r_5401 = count4
							local r_5381 = nil
							r_5381 = (function(r_5391)
								if (r_5391 <= r_5401) then
									append_21_1(out7, ", ")
									compileExpression1(nth1(node41, (r_5351 + r_5391)), out7, state14)
									return r_5381((r_5391 + 1))
								else
								end
							end)
							r_5381(1)
							offset4 = count4
							line_21_1(out7, "}")
						else
							local expr2 = nth1(node41, (r_5351 + offset4))
							local name7 = escapeVar1(var13, state14)
							local ret2 = nil
							if expr2 then
								if statement_3f_1(expr2) then
									ret2 = _2e2e_2(name7, " = ")
									line_21_1(out7)
								else
									append_21_1(out7, " = ")
								end
								compileExpression1(expr2, out7, state14, ret2)
								line_21_1(out7)
							else
								line_21_1(out7)
							end
						end
						return r_5341((r_5351 + 1))
					else
					end
				end)
				r_5341(1)
				local r_5441 = _23_1(node41)
				local r_5421 = nil
				r_5421 = (function(r_5431)
					if (r_5431 <= r_5441) then
						compileExpression1(nth1(node41, r_5431), out7, state14, "")
						line_21_1(out7)
						return r_5421((r_5431 + 1))
					else
					end
				end)
				r_5421((_23_1(args8) + (offset4 + 1)))
				compileBlock1(head2, out7, state14, 3, ret1)
			else
				if ret1 then
					append_21_1(out7, ret1)
				else
				end
				if literal_3f_1(car2(node41)) then
					append_21_1(out7, "(")
					compileExpression1(car2(node41), out7, state14)
					append_21_1(out7, ")")
				else
					compileExpression1(car2(node41), out7, state14)
				end
				append_21_1(out7, "(")
				local r_5481 = _23_1(node41)
				local r_5461 = nil
				r_5461 = (function(r_5471)
					if (r_5471 <= r_5481) then
						if (r_5471 > 2) then
							append_21_1(out7, ", ")
						else
						end
						compileExpression1(nth1(node41, r_5471), out7, state14)
						return r_5461((r_5471 + 1))
					else
					end
				end)
				r_5461(2)
				append_21_1(out7, ")")
			end
		end
		return popNode_21_1(out7, node41)
	else
		if (ret1 == "") then
		else
			if ret1 then
				append_21_1(out7, ret1)
			else
			end
			if symbol_3f_1(node41) then
				return append_21_1(out7, escapeVar1(node41["var"], state14))
			elseif string_3f_1(node41) then
				return append_21_1(out7, quoted1(node41["value"]))
			elseif number_3f_1(node41) then
				return append_21_1(out7, tostring1(node41["value"]))
			elseif key_3f_1(node41) then
				return append_21_1(out7, quoted1(node41["value"]))
			else
				return error1(_2e2e_2("Unknown type: ", type1(node41)))
			end
		end
	end
end)
compileBlock1 = (function(nodes7, out8, state15, start5, ret3)
	local r_4531 = _23_1(nodes7)
	local r_4511 = nil
	r_4511 = (function(r_4521)
		if (r_4521 <= r_4531) then
			local ret_27_1
			if (r_4521 == _23_1(nodes7)) then
				ret_27_1 = ret3
			else
				ret_27_1 = ""
			end
			compileExpression1(nth1(nodes7, r_4521), out8, state15, ret_27_1)
			line_21_1(out8)
			return r_4511((r_4521 + 1))
		else
		end
	end)
	return r_4511(start5)
end)
prelude1 = (function(out9)
	line_21_1(out9, "if not table.pack then table.pack = function(...) return { n = select(\"#\", ...), ... } end end")
	line_21_1(out9, "if not table.unpack then table.unpack = unpack end")
	line_21_1(out9, "local load = load if _VERSION:find(\"5.1\") then load = function(x, n, _, env) local f, e = loadstring(x, n) if not f then error(e, 2) end return setfenv(f, env) end end")
	return line_21_1(out9, "local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error")
end)
file1 = (function(compiler1, shebang1)
	local state16 = createState2(compiler1["libMeta"])
	local out10 = create2()
	if shebang1 then
		line_21_1(out10, _2e2e_2("#!/usr/bin/env ", shebang1))
	else
	end
	prelude1(out10)
	line_21_1(out10, "local _libs = {}")
	local r_5511 = compiler1["libs"]
	local r_5541 = _23_1(r_5511)
	local r_5521 = nil
	r_5521 = (function(r_5531)
		if (r_5531 <= r_5541) then
			local lib1 = r_5511[r_5531]
			local prefix1 = quoted1(lib1["prefix"])
			local native1 = lib1["native"]
			if native1 then
				line_21_1(out10, "local _temp = (function()")
				local r_5571 = split1(native1, "\n")
				local r_5601 = _23_1(r_5571)
				local r_5581 = nil
				r_5581 = (function(r_5591)
					if (r_5591 <= r_5601) then
						local line2 = r_5571[r_5591]
						if (line2 ~= "") then
							append_21_1(out10, "\9")
							line_21_1(out10, line2)
						else
						end
						return r_5581((r_5591 + 1))
					else
					end
				end)
				r_5581(1)
				line_21_1(out10, "end)()")
				line_21_1(out10, _2e2e_2("for k, v in pairs(_temp) do _libs[", prefix1, ".. k] = v end"))
			else
			end
			return r_5521((r_5531 + 1))
		else
		end
	end)
	r_5521(1)
	local count5 = 0
	local r_5631 = compiler1["out"]
	local r_5661 = _23_1(r_5631)
	local r_5641 = nil
	r_5641 = (function(r_5651)
		if (r_5651 <= r_5661) then
			local node42 = r_5631[r_5651]
			local var14 = node42["defVar"]
			if var14 then
				count5 = (count5 + 1)
			else
			end
			return r_5641((r_5651 + 1))
		else
		end
	end)
	r_5641(1)
	if between_3f_1(count5, 1, 150) then
		append_21_1(out10, "local ")
		local first9 = true
		local r_5691 = compiler1["out"]
		local r_5721 = _23_1(r_5691)
		local r_5701 = nil
		r_5701 = (function(r_5711)
			if (r_5711 <= r_5721) then
				local node43 = r_5691[r_5711]
				local var15 = node43["defVar"]
				if var15 then
					if first9 then
						first9 = false
					else
						append_21_1(out10, ", ")
					end
					append_21_1(out10, escapeVar1(var15, state16))
				else
				end
				return r_5701((r_5711 + 1))
			else
			end
		end)
		r_5701(1)
		line_21_1(out10)
	else
	end
	compileBlock1(compiler1["out"], out10, state16, 1, "return ")
	return out10
end)
emitLua1 = struct1("name", "emit-lua", "setup", (function(spec7)
	addArgument_21_1(spec7, {tag = "list", n = 1, "--emit-lua"}, "help", "Emit a Lua file.")
	return addArgument_21_1(spec7, {tag = "list", n = 1, "--shebang"}, "default", (function(r_5821)
		if r_5821 then
			return r_5821
		else
			local r_5831 = nth1(arg1, -1)
			if r_5831 then
				return r_5831
			else
				if _eor1 then
					return _eor1
				else
					return "lua"
				end
			end
		end
	end)(nth1(arg1, 0)), "help", "Set the executable to use for the shebang.", "narg", "?")
end), "pred", (function(args9)
	return args9["emit-lua"]
end), "run", (function(compiler2, args10)
	if nil_3f_1(args10["input"]) then
		putError_21_1("No inputs to compille.")
		exit_21_1(1)
	else
	end
	local out11 = file1(compiler2, args10["shebang"])
	local handle1 = open1(_2e2e_2(args10["output"], ".lua"), "w")
	self1(handle1, "write", _2d3e_string1(out11))
	return self1(handle1, "close")
end))
emitLisp1 = struct1("name", "emit-lisp", "setup", (function(spec8)
	return addArgument_21_1(spec8, {tag = "list", n = 1, "--emit-lisp"}, "help", "Emit a Lisp file.")
end), "pred", (function(args11)
	return args11["emit-lisp"]
end), "run", (function(compiler3, args12)
	if nil_3f_1(args12["input"]) then
		putError_21_1("No inputs to compille.")
		exit_21_1(1)
	else
	end
	local writer13 = create2()
	block1(compiler3["out"], writer13)
	local handle2 = open1(_2e2e_2(args12["output"], ".lisp"), "w")
	self1(handle2, "write", _2d3e_string1(writer13))
	return self1(handle2, "close")
end))
warning1 = struct1("name", "warning", "setup", (function(spec9)
	return addArgument_21_1(spec9, {tag = "list", n = 2, "--warning", "-W"}, "help", "The warning level to use.", "default", 1, "narg", 1)
end), "pred", (function(args13)
	return (args13["warning"] > 0)
end), "run", (function(compiler4, args14)
	return analyse1(compiler4["out"], struct1("meta", compiler4["libMeta"], "logger", compiler4["log"]))
end))
optimise2 = struct1("name", "optimise", "setup", (function(spec10)
	return addArgument_21_1(spec10, {tag = "list", n = 2, "--optimise", "-O"}, "help", "The optimiation level to use.", "default", 1, "narg", 1)
end), "pred", (function(args15)
	return (args15["optimise"] > 0)
end), "run", (function(compiler5, args16)
	return optimise1(compiler5["out"], struct1("meta", compiler5["libMeta"], "logger", compiler5["log"]))
end))
builtins7 = require1("tacky.analysis.resolve")["builtins"]
tokens1 = {tag = "list", n = 4, {tag = "list", n = 2, "arg", "(%f[%a]%u+%f[%A])"}, {tag = "list", n = 2, "mono", "```[a-z]*\n([^`]*)\n```"}, {tag = "list", n = 2, "mono", "`([^`]*)`"}, {tag = "list", n = 2, "link", "%[%[(.-)%]%]"}}
extractSignature1 = (function(var16)
	local ty7 = type1(var16)
	local temp89
	local r_5981 = (ty7 == "macro")
	if r_5981 then
		temp89 = r_5981
	else
		temp89 = (ty7 == "defined")
	end
	if temp89 then
		local root1 = var16["node"]
		local node44 = nth1(root1, _23_1(root1))
		local temp90
		local r_5991 = list_3f_1(node44)
		if r_5991 then
			local r_6001 = symbol_3f_1(car2(node44))
			if r_6001 then
				temp90 = (car2(node44)["var"] == builtins7["lambda"])
			else
				temp90 = r_6001
			end
		else
			temp90 = r_5991
		end
		if temp90 then
			return nth1(node44, 2)
		else
			return nil
		end
	else
		return nil
	end
end)
parseDocstring1 = (function(str2)
	local out12 = {tag = "list", n = 0}
	local pos5 = 1
	local len6 = len1(str2)
	local r_6011 = nil
	r_6011 = (function()
		if (pos5 <= len6) then
			local spos1 = len6
			local epos1 = nil
			local name8 = nil
			local ptrn1 = nil
			local r_6061 = _23_1(tokens1)
			local r_6041 = nil
			r_6041 = (function(r_6051)
				if (r_6051 <= r_6061) then
					local tok1 = tokens1[r_6051]
					local npos1 = list1(find1(str2, nth1(tok1, 2), pos5))
					local temp91
					local r_6081 = car2(npos1)
					if r_6081 then
						temp91 = (car2(npos1) < spos1)
					else
						temp91 = r_6081
					end
					if temp91 then
						spos1 = car2(npos1)
						epos1 = nth1(npos1, 2)
						name8 = car2(tok1)
						ptrn1 = nth1(tok1, 2)
					else
					end
					return r_6041((r_6051 + 1))
				else
				end
			end)
			r_6041(1)
			if name8 then
				if (pos5 < spos1) then
					pushCdr_21_1(out12, struct1("tag", "text", "contents", sub1(str2, pos5, pred1(spos1))))
				else
				end
				pushCdr_21_1(out12, struct1("tag", name8, "whole", sub1(str2, spos1, epos1), "contents", match1(sub1(str2, spos1, epos1), ptrn1)))
				pos5 = succ1(epos1)
			else
				pushCdr_21_1(out12, struct1("tag", "text", "contents", sub1(str2, pos5, len6)))
				pos5 = succ1(len6)
			end
			return r_6011()
		else
		end
	end)
	r_6011()
	return out12
end)
Scope1 = require1("tacky.analysis.scope")
formatRange2 = (function(range4)
	return format1("%s:%s", range4["name"], formatPosition1(range4["start"]))
end)
sortVars_21_1 = (function(list3)
	return sort1(list3, (function(a4, b4)
		return (car2(a4) < car2(b4))
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
formatSignature1 = (function(name9, var18)
	local sig1 = extractSignature1(var18)
	if (sig1 == nil) then
		return name9
	elseif nil_3f_1(sig1) then
		return _2e2e_2("(", name9, ")")
	else
		return _2e2e_2("(", name9, " ", concat1(traverse1(sig1, (function(r_5911)
			return r_5911["contents"]
		end)), " "), ")")
	end
end)
writeDocstring1 = (function(out13, str3, scope1)
	local r_5931 = parseDocstring1(str3)
	local r_5961 = _23_1(r_5931)
	local r_5941 = nil
	r_5941 = (function(r_5951)
		if (r_5951 <= r_5961) then
			local tok2 = r_5931[r_5951]
			local ty9 = type1(tok2)
			if (ty9 == "text") then
				append_21_1(out13, tok2["contents"])
			elseif (ty9 == "arg") then
				append_21_1(out13, _2e2e_2("`", tok2["contents"], "`"))
			elseif (ty9 == "mono") then
				append_21_1(out13, tok2["whole"])
			elseif (ty9 == "link") then
				local name10 = tok2["contents"]
				local ovar1 = Scope1["get"](scope1, name10)
				local temp92
				if ovar1 then
					temp92 = ovar1["node"]
				else
					temp92 = ovar1
				end
				if temp92 then
					local loc1
					local r_6141
					local r_6131
					local r_6121
					local r_6111 = ovar1["node"]
					r_6121 = getSource1(r_6111)
					r_6131 = r_6121["name"]
					r_6141 = gsub1(r_6131, "%.lisp$", "")
					loc1 = gsub1(r_6141, "/", ".")
					local sig2 = extractSignature1(ovar1)
					local hash1
					if (sig2 == nil) then
						hash1 = ovar1["name"]
					elseif nil_3f_1(sig2) then
						hash1 = ovar1["name"]
					else
						hash1 = _2e2e_2(name10, " ", concat1(traverse1(sig2, (function(r_6101)
							return r_6101["contents"]
						end)), " "))
					end
					append_21_1(out13, format1("[`%s`](%s.md#%s)", name10, loc1, gsub1(hash1, "%A+", "-")))
				else
					append_21_1(out13, format1("`%s`", name10))
				end
			else
				_error("unmatched item")
			end
			return r_5941((r_5951 + 1))
		else
		end
	end)
	r_5941(1)
	return line_21_1(out13)
end)
exported1 = (function(out14, title1, primary1, vars1, scope2)
	local documented1 = {tag = "list", n = 0}
	local undocumented1 = {tag = "list", n = 0}
	iterPairs1(vars1, (function(name11, var19)
		return pushCdr_21_1((function()
			if var19["doc"] then
				return documented1
			else
				return undocumented1
			end
		end)()
		, list1(name11, var19))
	end))
	sortVars_21_1(documented1)
	sortVars_21_1(undocumented1)
	line_21_1(out14, "---")
	line_21_1(out14, _2e2e_2("title: ", title1))
	line_21_1(out14, "---")
	line_21_1(out14, _2e2e_2("# ", title1))
	if primary1 then
		writeDocstring1(out14, primary1, scope2)
		line_21_1(out14, "", true)
	else
	end
	local r_6191 = _23_1(documented1)
	local r_6171 = nil
	r_6171 = (function(r_6181)
		if (r_6181 <= r_6191) then
			local entry7 = documented1[r_6181]
			local name12 = car2(entry7)
			local var20 = nth1(entry7, 2)
			line_21_1(out14, _2e2e_2("## `", formatSignature1(name12, var20), "`"))
			line_21_1(out14, _2e2e_2("*", formatDefinition1(var20), "*"))
			line_21_1(out14, "", true)
			writeDocstring1(out14, var20["doc"], var20["scope"])
			line_21_1(out14, "", true)
			return r_6171((r_6181 + 1))
		else
		end
	end)
	r_6171(1)
	if nil_3f_1(undocumented1) then
	else
		line_21_1(out14, "## Undocumented symbols")
	end
	local r_6251 = _23_1(undocumented1)
	local r_6231 = nil
	r_6231 = (function(r_6241)
		if (r_6241 <= r_6251) then
			local entry8 = undocumented1[r_6241]
			local name13 = car2(entry8)
			local var21 = nth1(entry8, 2)
			line_21_1(out14, _2e2e_2(" - `", formatSignature1(name13, var21), "` *", formatDefinition1(var21), "*"))
			return r_6231((r_6241 + 1))
		else
		end
	end)
	return r_6231(1)
end)
docs1 = (function(compiler6, args17)
	local r_5861 = args17["input"]
	local r_5891 = _23_1(r_5861)
	local r_5871 = nil
	r_5871 = (function(r_5881)
		if (r_5881 <= r_5891) then
			local path1 = r_5861[r_5881]
			if (sub1(path1, -5) == ".lisp") then
				path1 = sub1(path1, 1, -6)
			else
			end
			local lib2 = compiler6["libCache"][path1]
			local writer14 = create2()
			exported1(writer14, path1, lib2["docs"], lib2["scope"]["exported"], lib2["scope"])
			local handle3 = open1(_2e2e_2(args17["docs"], "/", gsub1(path1, "/", "."), ".md"), "w")
			self1(handle3, "write", _2d3e_string1(writer14))
			self1(handle3, "close")
			return r_5871((r_5881 + 1))
		else
		end
	end)
	return r_5871(1)
end)
task1 = struct1("name", "docs", "setup", (function(spec11)
	return addArgument_21_1(spec11, {tag = "list", n = 1, "--docs"}, "help", "Specify the folder to emit documentation to.", "default", nil, "narg", 1)
end), "pred", (function(args18)
	return (nil ~= args18["docs"])
end), "run", docs1)
config1 = package.config
coloredAnsi1 = (function(col1, msg9)
	return _2e2e_2("\27[", col1, "m", msg9, "\27[0m")
end)
local temp93
if config1 then
	temp93 = (charAt1(config1, 1) ~= "\\")
else
	temp93 = config1
end
if temp93 then
	colored_3f_1 = true
else
	local temp94
	if getenv1 then
		temp94 = (getenv1("ANSICON") ~= nil)
	else
		temp94 = getenv1
	end
	if temp94 then
		colored_3f_1 = true
	else
		local temp95
		if getenv1 then
			local term1 = getenv1("TERM")
			if term1 then
				temp95 = find1(term1, "xterm")
			else
				temp95 = nil
			end
		else
			temp95 = getenv1
		end
		if temp95 then
			colored_3f_1 = true
		else
			colored_3f_1 = false
		end
	end
end
if colored_3f_1 then
	colored1 = coloredAnsi1
else
	colored1 = (function(col2, msg10)
		return msg10
	end)
end
create3 = coroutine.create
resume1 = coroutine.resume
status1 = coroutine.status
traceback1 = debug.traceback
local discard1 = (function()
end)
void1 = struct1("put-error!", discard1, "put-warning!", discard1, "put-verbose!", discard1, "put-debug!", discard1, "put-node-error!", discard1, "put-node-warning!", discard1)
hexDigit_3f_1 = (function(char3)
	local r_6321 = between_3f_1(char3, "0", "9")
	if r_6321 then
		return r_6321
	else
		local r_6331 = between_3f_1(char3, "a", "f")
		if r_6331 then
			return r_6331
		else
			return between_3f_1(char3, "A", "F")
		end
	end
end)
binDigit_3f_1 = (function(char4)
	local r_6341 = (char4 == "0")
	if r_6341 then
		return r_6341
	else
		return (char4 == "1")
	end
end)
terminator_3f_1 = (function(char5)
	local r_6351 = (char5 == "\n")
	if r_6351 then
		return r_6351
	else
		local r_6361 = (char5 == " ")
		if r_6361 then
			return r_6361
		else
			local r_6371 = (char5 == "\9")
			if r_6371 then
				return r_6371
			else
				local r_6381 = (char5 == "(")
				if r_6381 then
					return r_6381
				else
					local r_6391 = (char5 == ")")
					if r_6391 then
						return r_6391
					else
						local r_6401 = (char5 == "[")
						if r_6401 then
							return r_6401
						else
							local r_6411 = (char5 == "]")
							if r_6411 then
								return r_6411
							else
								local r_6421 = (char5 == "{")
								if r_6421 then
									return r_6421
								else
									local r_6431 = (char5 == "}")
									if r_6431 then
										return r_6431
									else
										return (char5 == "")
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
digitError_21_1 = (function(logger8, pos6, name14, char6)
	return doNodeError_21_1(logger8, format1("Expected %s digit, got %s", name14, (function()
		if (char6 == "") then
			return "eof"
		else
			return quoted1(char6)
		end
	end)()
	), pos6, nil, pos6, "Invalid digit here")
end)
lex1 = (function(logger9, str4, name15)
	local lines4 = split1(str4, "\n")
	local line3 = 1
	local column1 = 1
	local offset5 = 1
	local length1 = len1(str4)
	local out15 = {tag = "list", n = 0}
	local consume_21_1 = (function()
		if (charAt1(str4, offset5) == "\n") then
			line3 = (line3 + 1)
			column1 = 1
		else
			column1 = (column1 + 1)
		end
		offset5 = (offset5 + 1)
		return nil
	end)
	local position1 = (function()
		return struct1("line", line3, "column", column1, "offset", offset5)
	end)
	local range5 = (function(start6, finish1)
		return struct1("start", start6, "finish", (function()
			if finish1 then
				return finish1
			else
				return start6
			end
		end)(), "lines", lines4, "name", name15)
	end)
	local appendWith_21_1 = (function(data3, start7, finish2)
		local start8
		if start7 then
			start8 = start7
		else
			start8 = position1()
		end
		local finish3
		if finish2 then
			finish3 = finish2
		else
			finish3 = position1()
		end
		data3["range"] = range5(start8, finish3)
		data3["contents"] = sub1(str4, start8["offset"], finish3["offset"])
		return pushCdr_21_1(out15, data3)
	end)
	local append_21_2 = (function(tag11, start9, finish4)
		return appendWith_21_1(struct1("tag", tag11), start9, finish4)
	end)
	local parseBase1 = (function(name16, p3, base1)
		local start10 = offset5
		local char7 = charAt1(str4, offset5)
		if p3(char7) then
		else
			digitError_21_1(logger9, range5(position1()), name16, char7)
		end
		char7 = charAt1(str4, succ1(offset5))
		local r_6731 = nil
		r_6731 = (function()
			if p3(char7) then
				consume_21_1()
				char7 = charAt1(str4, succ1(offset5))
				return r_6731()
			else
			end
		end)
		r_6731()
		return tonumber1(sub1(str4, start10, offset5), base1)
	end)
	local r_6441 = nil
	r_6441 = (function()
		if (offset5 <= length1) then
			local char8 = charAt1(str4, offset5)
			local temp96
			local r_6451 = (char8 == "\n")
			if r_6451 then
				temp96 = r_6451
			else
				local r_6461 = (char8 == "\9")
				if r_6461 then
					temp96 = r_6461
				else
					temp96 = (char8 == " ")
				end
			end
			if temp96 then
			elseif (char8 == "(") then
				appendWith_21_1(struct1("tag", "open", "close", ")"))
			elseif (char8 == ")") then
				appendWith_21_1(struct1("tag", "close", "open", "("))
			elseif (char8 == "[") then
				appendWith_21_1(struct1("tag", "open", "close", "]"))
			elseif (char8 == "]") then
				appendWith_21_1(struct1("tag", "close", "open", "["))
			elseif (char8 == "{") then
				appendWith_21_1(struct1("tag", "open", "close", "}"))
			elseif (char8 == "}") then
				appendWith_21_1(struct1("tag", "close", "open", "{"))
			elseif (char8 == "'") then
				append_21_2("quote")
			elseif (char8 == "`") then
				append_21_2("syntax-quote")
			elseif (char8 == "~") then
				append_21_2("quasiquote")
			elseif (char8 == ",") then
				if (charAt1(str4, succ1(offset5)) == "@") then
					local start11 = position1()
					consume_21_1()
					append_21_2("unquote-splice", start11)
				else
					append_21_2("unquote")
				end
			elseif find1(str4, "^%-?%.?[0-9]", offset5) then
				local start12 = position1()
				local negative1 = (char8 == "-")
				if negative1 then
					consume_21_1()
					char8 = charAt1(str4, offset5)
				else
				end
				local val13
				local temp97
				local r_6551 = (char8 == "0")
				if r_6551 then
					temp97 = (charAt1(str4, succ1(offset5)) == "x")
				else
					temp97 = r_6551
				end
				if temp97 then
					consume_21_1()
					consume_21_1()
					local res4 = parseBase1("hexadecimal", hexDigit_3f_1, 16)
					if negative1 then
						res4 = (0 - res4)
					else
					end
					val13 = res4
				else
					local temp98
					local r_6561 = (char8 == "0")
					if r_6561 then
						temp98 = (charAt1(str4, succ1(offset5)) == "b")
					else
						temp98 = r_6561
					end
					if temp98 then
						consume_21_1()
						consume_21_1()
						local res5 = parseBase1("binary", binDigit_3f_1, 2)
						if negative1 then
							res5 = (0 - res5)
						else
						end
						val13 = res5
					else
						local r_6571 = nil
						r_6571 = (function()
							if between_3f_1(charAt1(str4, succ1(offset5)), "0", "9") then
								consume_21_1()
								return r_6571()
							else
							end
						end)
						r_6571()
						if (charAt1(str4, succ1(offset5)) == ".") then
							consume_21_1()
							local r_6581 = nil
							r_6581 = (function()
								if between_3f_1(charAt1(str4, succ1(offset5)), "0", "9") then
									consume_21_1()
									return r_6581()
								else
								end
							end)
							r_6581()
						else
						end
						char8 = charAt1(str4, succ1(offset5))
						local temp99
						local r_6591 = (char8 == "e")
						if r_6591 then
							temp99 = r_6591
						else
							temp99 = (char8 == "E")
						end
						if temp99 then
							consume_21_1()
							char8 = charAt1(str4, succ1(offset5))
							local temp100
							local r_6601 = (char8 == "-")
							if r_6601 then
								temp100 = r_6601
							else
								temp100 = (char8 == "+")
							end
							if temp100 then
								consume_21_1()
							else
							end
							local r_6611 = nil
							r_6611 = (function()
								if between_3f_1(charAt1(str4, succ1(offset5)), "0", "9") then
									consume_21_1()
									return r_6611()
								else
								end
							end)
							r_6611()
						else
						end
						val13 = tonumber1(sub1(str4, start12["offset"], offset5))
					end
				end
				appendWith_21_1(struct1("tag", "number", "value", val13), start12)
				char8 = charAt1(str4, succ1(offset5))
				if terminator_3f_1(char8) then
				else
					consume_21_1()
					doNodeError_21_1(logger9, format1("Expected digit, got %s", (function()
						if (char8 == "") then
							return "eof"
						else
							return char8
						end
					end)()
					), range5(position1()), nil, range5(position1()), "Illegal character here. Are you missing whitespace?")
				end
			elseif (char8 == "\"") then
				local start13 = position1()
				local startCol1 = succ1(column1)
				local buffer2 = {tag = "list", n = 0}
				consume_21_1()
				char8 = charAt1(str4, offset5)
				local r_6621 = nil
				r_6621 = (function()
					if (char8 ~= "\"") then
						if (column1 == 1) then
							local running3 = true
							local lineOff1 = offset5
							local r_6631 = nil
							r_6631 = (function()
								local temp101
								local r_6641 = running3
								if r_6641 then
									temp101 = (column1 < startCol1)
								else
									temp101 = r_6641
								end
								if temp101 then
									if (char8 == " ") then
										consume_21_1()
									elseif (char8 == "\n") then
										consume_21_1()
										pushCdr_21_1(buffer2, "\n")
										lineOff1 = offset5
									elseif (char8 == "") then
										running3 = false
									else
										putNodeWarning_21_1(logger9, format1("Expected leading indent, got %q", char8), range5(position1()), "You should try to align multi-line strings at the initial quote\nmark. This helps keep programs neat and tidy.", range5(start13), "String started with indent here", range5(position1()), "Mis-aligned character here")
										pushCdr_21_1(buffer2, sub1(str4, lineOff1, pred1(offset5)))
										running3 = false
									end
									char8 = charAt1(str4, offset5)
									return r_6631()
								else
								end
							end)
							r_6631()
						else
						end
						if (char8 == "") then
							local start14 = range5(start13)
							local finish5 = range5(position1())
							doNodeError_21_1(logger9, "Expected '\"', got eof", finish5, nil, start14, "string started here", finish5, "end of file here")
						elseif (char8 == "\\") then
							consume_21_1()
							char8 = charAt1(str4, offset5)
							if (char8 == "\n") then
							elseif (char8 == "a") then
								pushCdr_21_1(buffer2, "\7")
							elseif (char8 == "b") then
								pushCdr_21_1(buffer2, "\8")
							elseif (char8 == "f") then
								pushCdr_21_1(buffer2, "\12")
							elseif (char8 == "n") then
								pushCdr_21_1(buffer2, "\n")
							elseif (char8 == "t") then
								pushCdr_21_1(buffer2, "\9")
							elseif (char8 == "v") then
								pushCdr_21_1(buffer2, "\11")
							elseif (char8 == "\"") then
								pushCdr_21_1(buffer2, "\"")
							elseif (char8 == "\\") then
								pushCdr_21_1(buffer2, "\\")
							else
								local temp102
								local r_6651 = (char8 == "x")
								if r_6651 then
									temp102 = r_6651
								else
									local r_6661 = (char8 == "X")
									if r_6661 then
										temp102 = r_6661
									else
										temp102 = between_3f_1(char8, "0", "9")
									end
								end
								if temp102 then
									local start15 = position1()
									local val14
									local temp103
									local r_6671 = (char8 == "x")
									if r_6671 then
										temp103 = r_6671
									else
										temp103 = (char8 == "X")
									end
									if temp103 then
										consume_21_1()
										local start16 = offset5
										if hexDigit_3f_1(charAt1(str4, offset5)) then
										else
											digitError_21_1(logger9, range5(position1()), "hexadecimal", charAt1(str4, offset5))
										end
										if hexDigit_3f_1(charAt1(str4, succ1(offset5))) then
											consume_21_1()
										else
										end
										val14 = tonumber1(sub1(str4, start16, offset5), 16)
									else
										local start17 = position1()
										local ctr1 = 0
										char8 = charAt1(str4, succ1(offset5))
										local r_6681 = nil
										r_6681 = (function()
											local temp104
											local r_6691 = (ctr1 < 2)
											if r_6691 then
												temp104 = between_3f_1(char8, "0", "9")
											else
												temp104 = r_6691
											end
											if temp104 then
												consume_21_1()
												char8 = charAt1(str4, succ1(offset5))
												ctr1 = (ctr1 + 1)
												return r_6681()
											else
											end
										end)
										r_6681()
										val14 = tonumber1(sub1(str4, start17["offset"], offset5))
									end
									if (val14 >= 256) then
										doNodeError_21_1(logger9, "Invalid escape code", range5(start15()), nil, range5(start15(), position1), _2e2e_2("Must be between 0 and 255, is ", val14))
									else
									end
									pushCdr_21_1(buffer2, char1(val14))
								elseif (char8 == "") then
									doNodeError_21_1(logger9, "Expected escape code, got eof", range5(position1()), nil, range5(position1()), "end of file here")
								else
									doNodeError_21_1(logger9, "Illegal escape character", range5(position1()), nil, range5(position1()), "Unknown escape character")
								end
							end
						else
							pushCdr_21_1(buffer2, char8)
						end
						consume_21_1()
						char8 = charAt1(str4, offset5)
						return r_6621()
					else
					end
				end)
				r_6621()
				appendWith_21_1(struct1("tag", "string", "value", concat1(buffer2)), start13)
			elseif (char8 == ";") then
				local r_6701 = nil
				r_6701 = (function()
					local temp105
					local r_6711 = (offset5 <= length1)
					if r_6711 then
						temp105 = (charAt1(str4, succ1(offset5)) ~= "\n")
					else
						temp105 = r_6711
					end
					if temp105 then
						consume_21_1()
						return r_6701()
					else
					end
				end)
				r_6701()
			else
				local start18 = position1()
				local key9 = (char8 == ":")
				char8 = charAt1(str4, succ1(offset5))
				local r_6721 = nil
				r_6721 = (function()
					if _21_1(terminator_3f_1(char8)) then
						consume_21_1()
						char8 = charAt1(str4, succ1(offset5))
						return r_6721()
					else
					end
				end)
				r_6721()
				if key9 then
					appendWith_21_1(struct1("tag", "key", "value", sub1(str4, succ1(start18["offset"]), offset5)), start18)
				else
					append_21_2("symbol", start18)
				end
			end
			consume_21_1()
			return r_6441()
		else
		end
	end)
	r_6441()
	append_21_2("eof")
	return out15
end)
parse1 = (function(logger10, toks1)
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
	local r_6511 = _23_1(toks1)
	local r_6491 = nil
	r_6491 = (function(r_6501)
		if (r_6501 <= r_6511) then
			local tok3 = toks1[r_6501]
			local tag12 = tok3["tag"]
			local autoClose1 = false
			local previous2 = head3["last-node"]
			local tokPos1 = tok3["range"]
			local temp106
			local r_6531 = (tag12 ~= "eof")
			if r_6531 then
				local r_6541 = (tag12 ~= "close")
				if r_6541 then
					if head3["range"] then
						temp106 = (tokPos1["start"]["line"] ~= head3["range"]["start"]["line"])
					else
						temp106 = true
					end
				else
					temp106 = r_6541
				end
			else
				temp106 = r_6531
			end
			if temp106 then
				if previous2 then
					local prevPos1 = previous2["range"]
					if (tokPos1["start"]["line"] ~= prevPos1["start"]["line"]) then
						head3["last-node"] = tok3
						if (tokPos1["start"]["column"] ~= prevPos1["start"]["column"]) then
							putNodeWarning_21_1(logger10, "Different indent compared with previous expressions.", tok3, "You should try to maintain consistent indentation across a program,\ntry to ensure all expressions are lined up.\nIf this looks OK to you, check you're not missing a closing ')'.", prevPos1, "", tokPos1, "")
						else
						end
					else
					end
				else
					head3["last-node"] = tok3
				end
			else
			end
			local temp107
			local r_6771 = (tag12 == "string")
			if r_6771 then
				temp107 = r_6771
			else
				local r_6781 = (tag12 == "number")
				if r_6781 then
					temp107 = r_6781
				else
					local r_6791 = (tag12 == "symbol")
					if r_6791 then
						temp107 = r_6791
					else
						temp107 = (tag12 == "key")
					end
				end
			end
			if temp107 then
				append_21_3(tok3)
			elseif (tag12 == "open") then
				push_21_1()
				head3["open"] = tok3["contents"]
				head3["close"] = tok3["close"]
				head3["range"] = struct1("start", tok3["range"]["start"], "name", tok3["range"]["name"], "lines", tok3["range"]["lines"])
			elseif (tag12 == "close") then
				if nil_3f_1(stack2) then
					doNodeError_21_1(logger10, format1("'%s' without matching '%s'", tok3["contents"], tok3["open"]), tok3, nil, getSource1(tok3), "")
				elseif head3["auto-close"] then
					doNodeError_21_1(logger10, format1("'%s' without matching '%s' inside quote", tok3["contents"], tok3["open"]), tok3, nil, head3["range"], "quote opened here", tok3["range"], "attempting to close here")
				elseif (head3["close"] ~= tok3["contents"]) then
					doNodeError_21_1(logger10, format1("Expected '%s', got '%s'", head3["close"], tok3["contents"]), tok3, nil, head3["range"], format1("block opened with '%s'", head3["open"]), tok3["range"], format1("'%s' used here", tok3["contents"]))
				else
					head3["range"]["finish"] = tok3["range"]["finish"]
					pop_21_1()
				end
			else
				local temp108
				local r_6801 = (tag12 == "quote")
				if r_6801 then
					temp108 = r_6801
				else
					local r_6811 = (tag12 == "unquote")
					if r_6811 then
						temp108 = r_6811
					else
						local r_6821 = (tag12 == "syntax-quote")
						if r_6821 then
							temp108 = r_6821
						else
							local r_6831 = (tag12 == "unquote-splice")
							if r_6831 then
								temp108 = r_6831
							else
								temp108 = (tag12 == "quasiquote")
							end
						end
					end
				end
				if temp108 then
					push_21_1()
					head3["range"] = struct1("start", tok3["range"]["start"], "name", tok3["range"]["name"], "lines", tok3["range"]["lines"])
					append_21_3(struct1("tag", "symbol", "contents", tag12, "range", tok3["range"]))
					autoClose1 = true
					head3["auto-close"] = true
				elseif (tag12 == "eof") then
					if (0 ~= _23_1(stack2)) then
						doNodeError_21_1(logger10, "Expected ')', got eof", tok3, nil, head3["range"], "block opened here", tok3["range"], "end of file here")
					else
					end
				else
					error1(_2e2e_2("Unsupported type", tag12))
				end
			end
			if autoClose1 then
			else
				local r_6841 = nil
				r_6841 = (function()
					if head3["auto-close"] then
						if nil_3f_1(stack2) then
							doNodeError_21_1(logger10, format1("'%s' without matching '%s'", tok3["contents"], tok3["open"]), tok3, nil, getSource1(tok3), "")
						else
						end
						head3["range"]["finish"] = tok3["range"]["finish"]
						pop_21_1()
						return r_6841()
					else
					end
				end)
				r_6841()
			end
			return r_6491((r_6501 + 1))
		else
		end
	end)
	r_6491(1)
	return head3
end)
read2 = (function(x23, path2)
	return parse1(void1, lex1(void1, x23, (function()
		if path2 then
			return path2
		else
			return ""
		end
	end)()))
end)
struct1("lex", lex1, "parse", parse1, "read", read2)
compile1 = require1("tacky.compile")["compile"]
executeStates1 = require1("tacky.compile")["executeStates"]
Scope2 = require1("tacky.analysis.scope")
doParse1 = (function(compiler7, scope3, str5)
	local logger11 = compiler7["log"]
	local lexed1 = lex1(logger11, str5, "<stdin>")
	local parsed1 = parse1(logger11, lexed1)
	return cadr1(list1(compile1(parsed1, compiler7["global"], compiler7["variables"], compiler7["states"], scope3, compiler7["compileState"], compiler7["loader"], logger11)))
end)
execCommand1 = (function(compiler8, scope4, args19)
	local logger12 = compiler8["log"]
	local command1 = car2(args19)
	if (command1 == nil) then
		return putError_21_1(logger12, "Expected command after ':'")
	elseif (command1 == "doc") then
		local name17 = nth1(args19, 2)
		if name17 then
			local var22 = Scope2["get"](scope4, name17)
			if (var22 == nil) then
				return putError_21_1(logger12, _2e2e_2("Cannot find '", name17, "'"))
			elseif _21_1(var22["doc"]) then
				return putError_21_1(logger12, _2e2e_2("No documentation for '", name17, "'"))
			else
				local sig3 = extractSignature1(var22)
				local name18 = var22["fullName"]
				local docs2 = parseDocstring1(var22["doc"])
				if sig3 then
					local buffer3 = list1(name18)
					local r_6901 = _23_1(sig3)
					local r_6881 = nil
					r_6881 = (function(r_6891)
						if (r_6891 <= r_6901) then
							local arg22 = sig3[r_6891]
							pushCdr_21_1(buffer3, arg22["contents"])
							return r_6881((r_6891 + 1))
						else
						end
					end)
					r_6881(1)
					name18 = _2e2e_2("(", concat1(buffer3, " "), ")")
				else
				end
				print1(colored1(96, name18))
				local r_6961 = _23_1(docs2)
				local r_6941 = nil
				r_6941 = (function(r_6951)
					if (r_6951 <= r_6961) then
						local tok4 = docs2[r_6951]
						local tag13 = tok4["tag"]
						if (tag13 == "text") then
							write1(tok4["contents"])
						elseif (tag13 == "arg") then
							write1(colored1(36, tok4["contents"]))
						elseif (tag13 == "mono") then
							write1(colored1(97, tok4["contents"]))
						elseif (tag13 == "arg") then
							write1(colored1(97, tok4["contents"]))
						elseif (tag13 == "link") then
							write1(colored1(94, tok4["contents"]))
						else
							_error("unmatched item")
						end
						return r_6941((r_6951 + 1))
					else
					end
				end)
				r_6941(1)
				return print1()
			end
		else
			return putError_21_1(logger12, ":command <variable>")
		end
	elseif (command1 == "scope") then
		local vars2 = {tag = "list", n = 0}
		local varsSet1 = ({})
		local current1 = scope4
		local r_6981 = nil
		r_6981 = (function()
			if current1 then
				iterPairs1(current1["variables"], (function(name19, var23)
					if varsSet1[name19] then
					else
						pushCdr_21_1(vars2, name19)
						varsSet1[name19] = true
						return nil
					end
				end))
				current1 = current1["parent"]
				return r_6981()
			else
			end
		end)
		r_6981()
		sort1(vars2)
		return print1(concat1(vars2, " "))
	else
		return putError_21_1(logger12, _2e2e_2("Unknown command '", command1, "'"))
	end
end)
execString1 = (function(compiler9, scope5, string1)
	local state17 = doParse1(compiler9, scope5, string1)
	if (_23_1(state17) > 0) then
		local current2 = 0
		local exec1 = create3((function()
			local r_7031 = _23_1(state17)
			local r_7011 = nil
			r_7011 = (function(r_7021)
				if (r_7021 <= r_7031) then
					local elem6 = state17[r_7021]
					current2 = elem6
					self1(current2, "get")
					return r_7011((r_7021 + 1))
				else
				end
			end)
			return r_7011(1)
		end))
		local compileState1 = compiler9["compileState"]
		local global1 = compiler9["global"]
		local logger13 = compiler9["log"]
		local run1 = true
		local r_6271 = nil
		r_6271 = (function()
			if run1 then
				local res6 = list1(resume1(exec1))
				if _21_1(car2(res6)) then
					putError_21_1(logger13, cadr1(res6))
					run1 = false
				elseif (status1(exec1) == "dead") then
					print1(colored1(96, pretty1(self1(last1(state17), "get"))))
					run1 = false
				else
					local states1 = cadr1(res6)["states"]
					executeStates1(compileState1, states1, global1, logger13)
				end
				return r_6271()
			else
			end
		end)
		return r_6271()
	else
	end
end)
repl1 = (function(compiler10)
	local scope6 = compiler10["rootScope"]
	local logger14 = compiler10["log"]
	local buffer4 = {tag = "list", n = 0}
	local running4 = true
	local r_6281 = nil
	r_6281 = (function()
		if running4 then
			write1(colored1(92, (function()
				if nil_3f_1(buffer4) then
					return "> "
				else
					return ". "
				end
			end)()
			))
			flush1()
			local line4 = read1("*l")
			local temp109
			local r_7051 = _21_1(line4)
			if r_7051 then
				temp109 = nil_3f_1(buffer4)
			else
				temp109 = r_7051
			end
			if temp109 then
				running4 = false
			else
				local temp110
				if line4 then
					temp110 = (charAt1(line4, len1(line4)) == "\\")
				else
					temp110 = line4
				end
				if temp110 then
					pushCdr_21_1(buffer4, _2e2e_2(sub1(line4, 1, pred1(len1(line4))), "\n"))
				else
					local temp111
					if line4 then
						local r_7081 = (_23_1(buffer4) > 0)
						if r_7081 then
							temp111 = (len1(line4) > 0)
						else
							temp111 = r_7081
						end
					else
						temp111 = line4
					end
					if temp111 then
						pushCdr_21_1(buffer4, _2e2e_2(line4, "\n"))
					else
						local data4 = _2e2e_2(concat1(buffer4), (function()
							if line4 then
								return line4
							else
								return ""
							end
						end)())
						buffer4 = {tag = "list", n = 0}
						if (charAt1(data4, 1) == ":") then
							execCommand1(compiler10, scope6, split1(sub1(data4, 2), " "))
						else
							scope6 = Scope2["child"](scope6)
							scope6["isRoot"] = true
							local res7 = list1(pcall1(execString1, compiler10, scope6, data4))
							if car2(res7) then
							else
								putError_21_1(logger14, cadr1(res7))
							end
						end
					end
				end
			end
			return r_6281()
		else
		end
	end)
	return r_6281()
end)
task2 = struct1("name", "repl", "setup", (function(spec12)
	return addArgument_21_1(spec12, {tag = "list", n = 1, "--repl"}, "help", "Start an interactive session.")
end), "pred", (function(args20)
	return args20["repl"]
end), "run", repl1)
unmangleIdent1 = (function(ident1)
	local esc2 = match1(ident1, "^(.-)%d+$")
	if (esc2 == nil) then
		return ident1
	elseif (sub1(esc2, 1, 2) == "_e") then
		return sub1(ident1, 3)
	else
		local buffer5 = {tag = "list", n = 0}
		local pos7 = 0
		local len7 = len1(esc2)
		local r_7271 = nil
		r_7271 = (function()
			if (pos7 <= len7) then
				local char9 = charAt1(esc2, pos7)
				if (char9 == "_") then
					local r_7281 = list1(find1(esc2, "^_[%da-z]+_", pos7))
					local temp112
					local r_7301 = list_3f_1(r_7281)
					if r_7301 then
						local r_7311 = (_23_1(r_7281) == 2)
						if r_7311 then
							temp112 = true
						else
							temp112 = r_7311
						end
					else
						temp112 = r_7301
					end
					if temp112 then
						local start19 = nth1(r_7281, 1)
						local _eend1 = nth1(r_7281, 2)
						pos7 = (pos7 + 1)
						local r_7331 = nil
						r_7331 = (function()
							if (pos7 < _eend1) then
								pushCdr_21_1(buffer5, char1(tonumber1(sub1(esc2, pos7, succ1(pos7)), 16)))
								pos7 = (pos7 + 2)
								return r_7331()
							else
							end
						end)
						r_7331()
					else
						pushCdr_21_1(buffer5, "_")
					end
				elseif between_3f_1(char9, "A", "Z") then
					pushCdr_21_1(buffer5, "-")
					pushCdr_21_1(buffer5, lower1(char9))
				else
					pushCdr_21_1(buffer5, char9)
				end
				pos7 = (pos7 + 1)
				return r_7271()
			else
			end
		end)
		r_7271()
		return concat1(buffer5)
	end
end)
remapError1 = (function(msg11)
	local res8
	local r_7131
	local r_7121
	local r_7111
	r_7111 = gsub1(msg11, "local '([^']+)'", (function(x24)
		return _2e2e_2("local '", unmangleIdent1(x24), "'")
	end))
	r_7121 = gsub1(r_7111, "global '([^']+)'", (function(x25)
		return _2e2e_2("global '", unmangleIdent1(x25), "'")
	end))
	r_7131 = gsub1(r_7121, "upvalue '([^']+)'", (function(x26)
		return _2e2e_2("upvalue '", unmangleIdent1(x26), "'")
	end))
	res8 = gsub1(r_7131, "function '([^']+)'", (function(x27)
		return _2e2e_2("function '", unmangleIdent1(x27), "'")
	end))
	return res8
end)
remapMessage1 = (function(mappings1, msg12)
	local r_7141 = list1(match1(msg12, "^(.-):(%d+)(.*)$"))
	local temp113
	local r_7161 = list_3f_1(r_7141)
	if r_7161 then
		local r_7171 = (_23_1(r_7141) == 3)
		if r_7171 then
			temp113 = true
		else
			temp113 = r_7171
		end
	else
		temp113 = r_7161
	end
	if temp113 then
		local file2 = nth1(r_7141, 1)
		local line5 = nth1(r_7141, 2)
		local extra1 = nth1(r_7141, 3)
		local mapping1 = mappings1[file2]
		if mapping1 then
			local range6 = mapping1[tonumber1(line5)]
			if range6 then
				return _2e2e_2(range6, " (", file2, ":", line5, ")", remapError1(extra1))
			else
				return msg12
			end
		else
			return msg12
		end
	else
		return msg12
	end
end)
remapTraceback1 = (function(mappings2, msg13)
	local r_7261
	local r_7251
	local r_7241
	local r_7231
	local r_7221
	local r_7211
	r_7211 = gsub1(msg13, "^([^\n:]-:%d+:[^\n]*)", (function(r_7341)
		return remapMessage1(mappings2, r_7341)
	end))
	r_7221 = gsub1(r_7211, "\9([^\n:]-:%d+:)", (function(msg14)
		return _2e2e_2("\9", remapMessage1(mappings2, msg14))
	end))
	r_7231 = gsub1(r_7221, "<([^\n:]-:%d+)>\n", (function(msg15)
		return _2e2e_2("<", remapMessage1(mappings2, msg15), ">\n")
	end))
	r_7241 = gsub1(r_7231, "in local '([^']+)'\n", (function(x28)
		return _2e2e_2("in local '", unmangleIdent1(x28), "'\n")
	end))
	r_7251 = gsub1(r_7241, "in global '([^']+)'\n", (function(x29)
		return _2e2e_2("in global '", unmangleIdent1(x29), "'\n")
	end))
	r_7261 = gsub1(r_7251, "in upvalue '([^']+)'\n", (function(x30)
		return _2e2e_2("in upvalue '", unmangleIdent1(x30), "'\n")
	end))
	return gsub1(r_7261, "in function '([^']+)'\n", (function(x31)
		return _2e2e_2("in function '", unmangleIdent1(x31), "'\n")
	end))
end)
generateMappings1 = (function(lines5)
	local outLines1 = ({})
	iterPairs1(lines5, (function(line6, ranges1)
		local rangeLists1 = ({})
		iterPairs1(ranges1, (function(pos8)
			local file3 = pos8["name"]
			local rangeList1 = rangeLists1["file"]
			if rangeList1 then
			else
				rangeList1 = struct1("n", 0, "min", huge1, "max", (0 - huge1))
				rangeLists1[file3] = rangeList1
			end
			local r_7371 = pos8["finish"]["line"]
			local r_7351 = nil
			r_7351 = (function(r_7361)
				if (r_7361 <= r_7371) then
					if rangeList1[r_7361] then
					else
						rangeList1["n"] = succ1(rangeList1["n"])
						rangeList1[r_7361] = true
						if (r_7361 < rangeList1["min"]) then
							rangeList1["min"] = r_7361
						else
						end
						if (r_7361 > rangeList1["max"]) then
							rangeList1["max"] = r_7361
						else
						end
					end
					return r_7351((r_7361 + 1))
				else
				end
			end)
			return r_7351(pos8["start"]["line"])
		end))
		local bestName1 = nil
		local bestLines1 = nil
		local bestCount1 = 0
		iterPairs1(rangeLists1, (function(name20, lines6)
			if (lines6["n"] > bestCount1) then
				bestName1 = name20
				bestLines1 = lines6
				bestCount1 = lines6["n"]
				return nil
			else
			end
		end))
		outLines1[line6] = (function()
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
struct1("remapMessage", remapMessage1, "remapTraceback", remapTraceback1, "generate", generateMappings1)
runLua1 = (function(compiler11, args21)
	if nil_3f_1(args21["input"]) then
		putError_21_1("No inputs to run")
		exit_21_1(1)
	else
	end
	local out16 = file1(compiler11, false)
	local lines7 = generateMappings1(out16["lines"])
	local logger15 = compiler11["log"]
	local name21 = _2e2e_2((function(r_7561)
		if r_7561 then
			return r_7561
		else
			return "out"
		end
	end)(args21["output"]), ".lua")
	local r_7391 = list1(load1(_2d3e_string1(out16), _2e2e_2("=", name21)))
	local temp114
	local r_7421 = list_3f_1(r_7391)
	if r_7421 then
		local r_7431 = (_23_1(r_7391) == 2)
		if r_7431 then
			local r_7441 = eq_3f_1(nth1(r_7391, 1), nil)
			if r_7441 then
				temp114 = true
			else
				temp114 = r_7441
			end
		else
			temp114 = r_7431
		end
	else
		temp114 = r_7421
	end
	if temp114 then
		local msg16 = nth1(r_7391, 2)
		putError_21_1(logger15, "Cannot load compiled source")
		print1(msg16)
		print1(_2d3e_string1(out16))
		return exit_21_1(1)
	else
		local temp115
		local r_7451 = list_3f_1(r_7391)
		if r_7451 then
			local r_7461 = (_23_1(r_7391) == 1)
			if r_7461 then
				temp115 = true
			else
				temp115 = r_7461
			end
		else
			temp115 = r_7451
		end
		if temp115 then
			local fun1 = nth1(r_7391, 1)
			_5f_G1[args21["script-args"]] = args21
			local r_7471 = list1(xpcall1(fun1, traceback1))
			local temp116
			local r_7501 = list_3f_1(r_7471)
			if r_7501 then
				local r_7511 = (_23_1(r_7471) >= 1)
				if r_7511 then
					local r_7521 = eq_3f_1(nth1(r_7471, 1), true)
					if r_7521 then
						temp116 = true
					else
						temp116 = r_7521
					end
				else
					temp116 = r_7511
				end
			else
				temp116 = r_7501
			end
			if temp116 then
				local res9 = slice1(r_7471, 2)
			else
				local temp117
				local r_7531 = list_3f_1(r_7471)
				if r_7531 then
					local r_7541 = (_23_1(r_7471) == 2)
					if r_7541 then
						local r_7551 = eq_3f_1(nth1(r_7471, 1), false)
						if r_7551 then
							temp117 = true
						else
							temp117 = r_7551
						end
					else
						temp117 = r_7541
					end
				else
					temp117 = r_7531
				end
				if temp117 then
					local msg17 = nth1(r_7471, 2)
					putError_21_1(logger15, "Execution failed")
					print1(remapTraceback1(struct1(name21, lines7), msg17))
					return exit_21_1(1)
				else
					return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_7471), ", but none matched.\n", "  Tried: `(true . ?res)`\n  Tried: `(false ?msg)`"))
				end
			end
		else
			return error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_7391), ", but none matched.\n", "  Tried: `(nil ?msg)`\n  Tried: `(?fun)`"))
		end
	end
end)
task3 = struct1("name", "run", "setup", (function(spec13)
	addArgument_21_1(spec13, {tag = "list", n = 2, "--run", "-r"}, "help", "Run the compiled code")
	return addArgument_21_1(spec13, {tag = "list", n = 1, "--"}, "name", "script-args", "help", "Arguments to pass to the compiled script.", "var", "ARG", "all", true, "default", {tag = "list", n = 0}, "action", addAction1, "narg", "*")
end), "pred", (function(args22)
	return args22["run"]
end), "run", runLua1)
printError_21_1 = (function(msg18)
	if string_3f_1(msg18) then
	else
		msg18 = pretty1(msg18)
	end
	local lines8 = split1(msg18, "\n", 1)
	print1(colored1(31, _2e2e_2("[ERROR] ", car2(lines8))))
	if cadr1(lines8) then
		return print1(cadr1(lines8))
	else
	end
end)
printWarning_21_1 = (function(msg19)
	local lines9 = split1(msg19, "\n", 1)
	print1(colored1(33, _2e2e_2("[WARN] ", car2(lines9))))
	if cadr1(lines9) then
		return print1(cadr1(lines9))
	else
	end
end)
printVerbose_21_1 = (function(verbosity1, msg20)
	if (verbosity1 > 0) then
		return print1(_2e2e_2("[VERBOSE] ", msg20))
	else
	end
end)
printDebug_21_1 = (function(verbosity2, msg21)
	if (verbosity2 > 1) then
		return print1(_2e2e_2("[DEBUG] ", msg21))
	else
	end
end)
printExplain_21_1 = (function(explain4, lines10)
	if explain4 then
		local r_7601 = split1(lines10, "\n")
		local r_7631 = _23_1(r_7601)
		local r_7611 = nil
		r_7611 = (function(r_7621)
			if (r_7621 <= r_7631) then
				local line7 = r_7601[r_7621]
				print1(_2e2e_2("  ", line7))
				return r_7611((r_7621 + 1))
			else
			end
		end)
		return r_7611(1)
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
putError_21_2 = (function(messenger1, msg22)
	return printError_21_1(msg22)
end)
putWarning_21_2 = (function(messenger2, msg23)
	return printWarning_21_1(msg23)
end)
putVerbose_21_2 = (function(messenger3, msg24)
	return printVerbose_21_1(messenger3["verbosity"], msg24)
end)
putDebug_21_2 = (function(messenger4, msg25)
	return printDebug_21_1(messenger4["verbosity"], msg25)
end)
putNodeError_21_2 = (function(logger16, msg26, node46, explain6, lines11)
	printError_21_1(msg26)
	putTrace_21_1(node46)
	if explain6 then
		printExplain_21_1(logger16["explain"], explain6)
	else
	end
	return putLines_21_1(true, lines11)
end)
putNodeWarning_21_2 = (function(logger17, msg27, node47, explain7, lines12)
	printWarning_21_1(msg27)
	putTrace_21_1(node47)
	if explain7 then
		printExplain_21_1(logger17["explain"], explain7)
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
	local maxLine1 = foldr1((function(max6, node48)
		if string_3f_1(node48) then
			return max6
		else
			return max2(max6, node48["start"]["line"])
		end
	end), 0, entries1)
	local code3 = _2e2e_2(colored1(92, _2e2e_2(" %", len1(tostring1(maxLine1)), "s |")), " %s")
	local r_7671 = _23_1(entries1)
	local r_7651 = nil
	r_7651 = (function(r_7661)
		if (r_7661 <= r_7671) then
			local position2 = entries1[r_7661]
			local message1 = entries1[succ1(r_7661)]
			if (file4 ~= position2["name"]) then
				file4 = position2["name"]
				print1(colored1(95, _2e2e_2(" ", file4)))
			else
				local temp118
				local r_7691 = (previous3 ~= -1)
				if r_7691 then
					temp118 = (abs1((position2["start"]["line"] - previous3)) > 2)
				else
					temp118 = r_7691
				end
				if temp118 then
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
				local temp119
				local r_7701 = position2["finish"]
				if r_7701 then
					temp119 = (position2["start"]["line"] == position2["finish"]["line"])
				else
					temp119 = r_7701
				end
				if temp119 then
					pointer1 = rep1("^", succ1((position2["finish"]["column"] - position2["start"]["column"])))
				else
					pointer1 = "^..."
				end
			end
			print1(format1(code3, "", _2e2e_2(rep1(" ", (position2["start"]["column"] - 1)), pointer1, " ", message1)))
			return r_7651((r_7661 + 2))
		else
		end
	end)
	return r_7651(1)
end)
putTrace_21_1 = (function(node49)
	local previous4 = nil
	local r_7581 = nil
	r_7581 = (function()
		if node49 then
			local formatted1 = formatNode1(node49)
			if (previous4 == nil) then
				print1(colored1(96, _2e2e_2("  => ", formatted1)))
			elseif (previous4 ~= formatted1) then
				print1(_2e2e_2("  in ", formatted1))
			else
			end
			previous4 = formatted1
			node49 = node49["parent"]
			return r_7581()
		else
		end
	end)
	return r_7581()
end)
libLoader1 = _libs["urn/cli-14/lib-loader"]
rootScope1 = _libs["urn/cli-14/root-scope"]
scope_2f_child1 = _libs["urn/cli-14/scope/child"]
scope_2f_import_21_1 = _libs["urn/cli-14/scope/import!"]
local spec14 = create1()
local directory1
local dir1 = nth1(arg1, 0)
dir1 = gsub1(dir1, "urn/cli%.lisp$", "")
dir1 = gsub1(dir1, "urn/cli$", "")
dir1 = gsub1(dir1, "tacky/cli%.lua$", "")
local temp120
local r_8101 = (dir1 ~= "")
if r_8101 then
	temp120 = (charAt1(dir1, -1) ~= "/")
else
	temp120 = r_8101
end
if temp120 then
	dir1 = _2e2e_2(dir1, "/")
else
end
local r_8111 = nil
r_8111 = (function()
	if (sub1(dir1, 1, 2) == "./") then
		dir1 = sub1(dir1, 3)
		return r_8111()
	else
	end
end)
r_8111()
directory1 = dir1
local paths1 = list1("?", "?/init", _2e2e_2(directory1, "lib/?"), _2e2e_2(directory1, "lib/?/init"))
local tasks1 = list1(warning1, optimise2, emitLisp1, emitLua1, task1, task3, task2)
addHelp_21_1(spec14)
addArgument_21_1(spec14, {tag = "list", n = 2, "--explain", "-e"}, "help", "Explain error messages in more detail.")
addArgument_21_1(spec14, {tag = "list", n = 2, "--time", "-t"}, "help", "Time how long each task takes to execute.")
addArgument_21_1(spec14, {tag = "list", n = 2, "--verbose", "-v"}, "help", "Make the output more verbose. Can be used multiple times", "many", true, "default", 0, "action", (function(arg23, data5)
	data5[arg23["name"]] = succ1((function(r_7711)
		if r_7711 then
			return r_7711
		else
			return 0
		end
	end)(data5[arg23["name"]]))
	return nil
end))
addArgument_21_1(spec14, {tag = "list", n = 2, "--include", "-i"}, "help", "Add an additional argument to the include path.", "many", true, "narg", 1, "default", {tag = "list", n = 0}, "action", addAction1)
addArgument_21_1(spec14, {tag = "list", n = 2, "--prelude", "-p"}, "help", "A custom prelude path to use.", "narg", 1, "default", _2e2e_2(directory1, "lib/prelude"))
addArgument_21_1(spec14, {tag = "list", n = 3, "--output", "--out", "-o"}, "help", "The destination to output to.", "narg", 1, "default", "out")
addArgument_21_1(spec14, {tag = "list", n = 1, "input"}, "help", "The file(s) to load.", "var", "FILE", "narg", "*")
local r_7761 = _23_1(tasks1)
local r_7741 = nil
r_7741 = (function(r_7751)
	if (r_7751 <= r_7761) then
		local task4 = tasks1[r_7751]
		task4["setup"](spec14)
		return r_7741((r_7751 + 1))
	else
	end
end)
r_7741(1)
local args23 = parse_21_1(spec14)
local logger18 = create4(args23["verbose"], args23["explain"])
local r_7791 = args23["include"]
local r_7821 = _23_1(r_7791)
local r_7801 = nil
r_7801 = (function(r_7811)
	if (r_7811 <= r_7821) then
		local path3 = r_7791[r_7811]
		path3 = gsub1(path3, "\\", "/")
		path3 = gsub1(path3, "^%./", "")
		if find1(path3, "%?") then
		else
			path3 = _2e2e_2(path3, (function()
				if (charAt1(path3, -1) == "/") then
					return "?"
				else
					return "/?"
				end
			end)()
			)
		end
		pushCdr_21_1(paths1, path3)
		return r_7801((r_7811 + 1))
	else
	end
end)
r_7801(1)
putVerbose_21_1(logger18, _2e2e_2("Using path: ", pretty1(paths1)))
if nil_3f_1(args23["input"]) then
	args23["repl"] = true
else
	args23["emit-lua"] = true
end
local compiler12 = struct1("log", logger18, "paths", paths1, "libEnv", ({}), "libMeta", ({}), "libs", {tag = "list", n = 0}, "libCache", ({}), "rootScope", rootScope1, "variables", ({}), "states", ({}), "out", {tag = "list", n = 0})
compiler12["compileState"] = createState2(compiler12["libMeta"])
compiler12["compileState"]["count"] = 0
compiler12["compileState"]["mappings"] = ({})
compiler12["global"] = setmetatable1(struct1("_libs", compiler12["libEnv"]), struct1("__index", _5f_G1))
iterPairs1(compiler12["rootScope"]["variables"], (function(_5f_2, var24)
	compiler12["variables"][tostring1(var24)] = var24
	return nil
end))
local start20 = clock1()
local r_7841 = list1(libLoader1(compiler12, args23["prelude"], false))
local temp121
local r_7871 = list_3f_1(r_7841)
if r_7871 then
	local r_7881 = (_23_1(r_7841) == 2)
	if r_7881 then
		local r_7891 = eq_3f_1(nth1(r_7841, 1), false)
		if r_7891 then
			temp121 = true
		else
			temp121 = r_7891
		end
	else
		temp121 = r_7881
	end
else
	temp121 = r_7871
end
if temp121 then
	local errorMessage1 = nth1(r_7841, 2)
	putError_21_1(logger18, errorMessage1)
	exit_21_1(1)
else
	local temp122
	local r_7901 = list_3f_1(r_7841)
	if r_7901 then
		local r_7911 = (_23_1(r_7841) == 2)
		if r_7911 then
			local r_7921 = eq_3f_1(nth1(r_7841, 1), true)
			if r_7921 then
				temp122 = true
			else
				temp122 = r_7921
			end
		else
			temp122 = r_7911
		end
	else
		temp122 = r_7901
	end
	if temp122 then
		local preludeVars1 = nth1(r_7841, 2)
		compiler12["rootScope"] = scope_2f_child1(compiler12["rootScope"])
		iterPairs1(preludeVars1, (function(name22, var25)
			return scope_2f_import_21_1(compiler12["rootScope"], name22, var25)
		end))
		local r_7941 = args23["input"]
		local r_7971 = _23_1(r_7941)
		local r_7951 = nil
		r_7951 = (function(r_7961)
			if (r_7961 <= r_7971) then
				local input1 = r_7941[r_7961]
				local r_7991 = list1(libLoader1(compiler12, input1, false))
				local temp123
				local r_8011 = list_3f_1(r_7991)
				if r_8011 then
					local r_8021 = (_23_1(r_7991) == 2)
					if r_8021 then
						local r_8031 = eq_3f_1(nth1(r_7991, 1), false)
						if r_8031 then
							temp123 = true
						else
							temp123 = r_8031
						end
					else
						temp123 = r_8021
					end
				else
					temp123 = r_8011
				end
				if temp123 then
					local errorMessage2 = nth1(r_7991, 2)
					putError_21_1(logger18, errorMessage2)
					exit_21_1(1)
				else
				end
				return r_7951((r_7961 + 1))
			else
			end
		end)
		r_7951(1)
	else
		error1(_2e2e_2("Pattern matching failure!\nTried to match the following patterns against ", pretty1(r_7841), ", but none matched.\n", "  Tried: `(false ?error-message)`\n  Tried: `(true ?prelude-vars)`"))
	end
end
if args23["time"] then
	print1(_2e2e_2("parsing took ", (clock1() - start20)))
else
end
local r_8081 = _23_1(tasks1)
local r_8061 = nil
r_8061 = (function(r_8071)
	if (r_8071 <= r_8081) then
		local task5 = tasks1[r_8071]
		if task5["pred"](args23) then
			local start21 = clock1()
			task5["run"](compiler12, args23)
			if args23["time"] then
				print1(_2e2e_2(task5["name"], " took ", (clock1() - start21)))
			else
			end
		else
		end
		return r_8061((r_8071 + 1))
	else
	end
end)
return r_8061(1)
