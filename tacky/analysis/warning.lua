if not table.pack then table.pack = function(...) return { n = select("#", ...), ... } end end
if not table.unpack then table.unpack = unpack end
local load = load if _VERSION:find("5.1") then load = function(x, _, _, env) local f, e = loadstring(x); if not f then error(e, 1) end; return setfenv(f, env) end end
local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error
local _libs = {}
local _temp = (function()
	local counter = 0
	local function pretty(x)
		if type(x) == 'table' and x.tag then
			if x.tag == 'list' then
				local y = {}
				for i = 1, x.n do
					y[i] = pretty(x[i])
				end
				return '(' .. table.concat(y, ' ') .. ')'
			elseif x.tag == 'symbol' then
				return x.contents
			elseif x.tag == 'key' then
				return ":" .. x.value
			elseif x.tag == 'string' then
				return (("%q"):format(x.value):gsub("\n", "n"):gsub("\t", "\\9"))
			elseif x.tag == 'number' then
				return tostring(x.value)
			elseif x.tag.tag and x.tag.tag == 'symbol' and x.tag.contents == 'pair' then
				return '(pair ' .. pretty(x.fst) .. ' ' .. pretty(x.snd) .. ')'
			elseif x.tag == 'thunk' then
				return '<<thunk>>'
			else
				return tostring(x)
			end
		elseif type(x) == 'string' then
			return ("%q"):format(x)
		else
			return tostring(x)
		end
	end
	if arg then
		if not arg.n then arg.n = #arg end
		if not arg.tag then arg.tag = "list" end
	else
		arg = { tag = "list", n = 0 }
	end
	return {
		['='] = function(x, y) return x == y end,
		['/='] = function(x, y) return x ~= y end,
		['<'] = function(x, y) return x < y end,
		['<='] = function(x, y) return x <= y end,
		['>'] = function(x, y) return x > y end,
		['>='] = function(x, y) return x >= y end,
		['+'] = function(x, y) return x + y end,
		['-'] = function(x, y) return x - y end,
		['*'] = function(x, y) return x * y end,
		['/'] = function(x, y) return x / y end,
		['%'] = function(x, y) return x % y end,
		['^'] = function(x, y) return x ^ y end,
		['..'] = function(x, y) return x .. y end,
		['slice'] = function(xs, start, finish)
			if not finish then finish = xs.n end
			if not finish then finish = #xs end
			return { tag = "list", n = finish - start + 1, table.unpack(xs, start, finish) }
		end,
		pretty = pretty,
		['gensym'] = function(name)
			if name then
				name = "_" .. tostring(name)
			else
				name = ""
			end
			counter = counter + 1
			return { tag = "symbol", contents = ("r_%d%s"):format(counter, name) }
		end,
		_G = _G, _ENV = _ENV, _VERSION = _VERSION, arg = arg,
		assert = assert, collectgarbage = collectgarbage,
		dofile = dofile, error = error,
		getmetatable = getmetatable, ipairs = ipairs,
		load = load, loadfile = loadfile,
		next = next, pairs = pairs,
		pcall = pcall, print = print,
		rawequal = rawequal, rawget = rawget,
		rawlen = rawlen, rawset = rawset,
		require = require, select = select,
		setmetatable = setmetatable, tonumber = tonumber,
		tostring = tostring, ["type#"] = type,
		xpcall = xpcall,
		["get-idx"] = function(x, i) return x[i] end,
		["set-idx!"] = function(x, k, v) x[k] = v end
	}
end)()
for k, v in pairs(_temp) do _libs["lib/lua/basic/".. k] = v end
local _temp = (function()
	return {
		['empty-struct'] = function() return {} end,
		['unpack'] = table.unpack or unpack,
		['iter-pairs'] = function(xs, f)
			for k, v in pairs(xs) do
				f(k, v)
			end
		end,
		concat = table.concat,
		insert = table.insert,
		move = table.move,
		pack = table.pack,
		remove = table.remove,
		sort = table.sort,
	}
end)()
for k, v in pairs(_temp) do _libs["lib/lua/table/".. k] = v end
local _temp = (function()
	return {
		byte = string.byte,
		char = string.char,
		dump = string.dump,
		find = string.find,
		format = string.format,
		gsub = string.gsub,
		len = string.len,
		lower = string.lower,
		match = string.match,
		rep = string.rep,
		reverse = string.reverse,
		sub = string.sub,
		upper = string.upper,
	}
end)()
for k, v in pairs(_temp) do _libs["lib/lua/string/".. k] = v end
local _temp = (function()
	return os
end)()
for k, v in pairs(_temp) do _libs["lib/lua/os/".. k] = v end
local _temp = (function()
	return io
end)()
for k, v in pairs(_temp) do _libs["lib/lua/io/".. k] = v end
local _temp = (function()
	return math
end)()
for k, v in pairs(_temp) do _libs["lib/lua/math/".. k] = v end
local _3d_1, _2f3d_1, _3c_1, _3c3d_1, _3e_1, _3e3d_1, _2b_1, _2d_1, _25_1, slice1, error1, next1, print1, getIdx1, setIdx_21_1, require1, tonumber1, tostring1, type_23_1, _23_1, concat1, remove1, unpack1, emptyStruct1, iterPairs1, car1, cdr1, list1, cons1, _21_1, find1, format1, len1, rep1, sub1, list_3f_1, nil_3f_1, string_3f_1, symbol_3f_1, key_3f_1, exists_3f_1, type1, car2, cdr2, foldr1, map1, any1, nth1, pushCdr_21_1, removeNth_21_1, reverse1, caar1, cadr1, _2e2e_1, _23_s1, split1, struct1, _23_keys1, succ1, pred1, string_2d3e_number1, number_2d3e_string1, symbol_2d3e_string1, error_21_1, print_21_1, fail_21_1, builtins1, visitQuote1, visitNode1, visitBlock1, visitList1, builtins2, builtinVars1, createState1, getVar1, getNode1, addUsage_21_1, addDefinition_21_1, definitionsVisitor1, definitionsVisit1, usagesVisit1, abs1, max1, verbosity1, setVerbosity_21_1, showExplain1, setExplain_21_1, colored1, printError_21_1, printWarning_21_1, printVerbose_21_1, printDebug_21_1, formatPosition1, formatRange1, formatNode1, getSource1, putLines_21_1, putTrace_21_1, putExplain_21_1, errorPositions_21_1, builtins3, sideEffect_3f_1, warnArity1, analyse1
_3d_1 = _libs["lib/lua/basic/="]
_2f3d_1 = _libs["lib/lua/basic//="]
_3c_1 = _libs["lib/lua/basic/<"]
_3c3d_1 = _libs["lib/lua/basic/<="]
_3e_1 = _libs["lib/lua/basic/>"]
_3e3d_1 = _libs["lib/lua/basic/>="]
_2b_1 = _libs["lib/lua/basic/+"]
_2d_1 = _libs["lib/lua/basic/-"]
_25_1 = _libs["lib/lua/basic/%"]
slice1 = _libs["lib/lua/basic/slice"]
error1 = _libs["lib/lua/basic/error"]
next1 = _libs["lib/lua/basic/next"]
print1 = _libs["lib/lua/basic/print"]
getIdx1 = _libs["lib/lua/basic/get-idx"]
setIdx_21_1 = _libs["lib/lua/basic/set-idx!"]
require1 = _libs["lib/lua/basic/require"]
tonumber1 = _libs["lib/lua/basic/tonumber"]
tostring1 = _libs["lib/lua/basic/tostring"]
type_23_1 = _libs["lib/lua/basic/type#"]
_23_1 = (function(x1)
	return x1["n"]
end)
concat1 = _libs["lib/lua/table/concat"]
remove1 = _libs["lib/lua/table/remove"]
unpack1 = _libs["lib/lua/table/unpack"]
emptyStruct1 = _libs["lib/lua/table/empty-struct"]
iterPairs1 = _libs["lib/lua/table/iter-pairs"]
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
	return list1(x2, unpack1(xs4))
end)
_21_1 = (function(expr1)
	if expr1 then
		return false
	else
		return true
	end
end)
find1 = _libs["lib/lua/string/find"]
format1 = _libs["lib/lua/string/format"]
len1 = _libs["lib/lua/string/len"]
rep1 = _libs["lib/lua/string/rep"]
sub1 = _libs["lib/lua/string/sub"]
list_3f_1 = (function(x3)
	return (type1(x3) == "list")
end)
nil_3f_1 = (function(x4)
	local r_31 = x4
	if r_31 then
		local r_41 = list_3f_1(x4)
		if r_41 then
			return (_23_1(x4) == 0)
		else
			return r_41
		end
	else
		return r_31
	end
end)
string_3f_1 = (function(x5)
	return (type1(x5) == "string")
end)
symbol_3f_1 = (function(x6)
	return (type1(x6) == "symbol")
end)
key_3f_1 = (function(x7)
	return (type1(x7) == "key")
end)
exists_3f_1 = (function(x8)
	return _21_1((type1(x8) == "nil"))
end)
type1 = (function(val1)
	local ty1 = type_23_1(val1)
	if (ty1 == "table") then
		local tag1 = val1["tag"]
		if tag1 then
			return tag1
		else
			return "table"
		end
	else
		return ty1
	end
end)
car2 = (function(x9)
	local r_241 = type1(x9)
	if (r_241 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_241), 2)
	else
	end
	return car1(x9)
end)
cdr2 = (function(x10)
	local r_251 = type1(x10)
	if (r_251 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_251), 2)
	else
	end
	if nil_3f_1(x10) then
		return {tag = "list", n =0}
	else
		return cdr1(x10)
	end
end)
foldr1 = (function(f1, z1, xs5)
	local r_261 = type1(f1)
	if (r_261 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "f", "function", r_261), 2)
	else
	end
	local r_381 = type1(xs5)
	if (r_381 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_381), 2)
	else
	end
	if nil_3f_1(xs5) then
		return z1
	else
		local head1 = car2(xs5)
		local tail1 = cdr2(xs5)
		return f1(head1, foldr1(f1, z1, tail1))
	end
end)
map1 = (function(f2, xs6, acc1)
	local r_271 = type1(f2)
	if (r_271 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "f", "function", r_271), 2)
	else
	end
	local r_391 = type1(xs6)
	if (r_391 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_391), 2)
	else
	end
	if _21_1(exists_3f_1(acc1)) then
		return map1(f2, xs6, {tag = "list", n =0})
	elseif nil_3f_1(xs6) then
		return reverse1(acc1)
	else
		return map1(f2, cdr2(xs6), cons1(f2(car2(xs6)), acc1))
	end
end)
any1 = (function(p1, xs7)
	local r_291 = type1(p1)
	if (r_291 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "p", "function", r_291), 2)
	else
	end
	local r_411 = type1(xs7)
	if (r_411 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_411), 2)
	else
	end
	return foldr1((function(x11, y1)
		local r_421 = x11
		if r_421 then
			return r_421
		else
			return y1
		end
	end), false, map1(p1, xs7))
end)
nth1 = (function(xs8, idx1)
	return xs8[idx1]
end)
pushCdr_21_1 = (function(xs9, val2)
	local r_341 = type1(xs9)
	if (r_341 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_341), 2)
	else
	end
	local len2 = (_23_1(xs9) + 1)
	xs9["n"] = len2
	xs9[len2] = val2
	return xs9
end)
removeNth_21_1 = (function(li1, idx2)
	local r_361 = type1(li1)
	if (r_361 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_361), 2)
	else
	end
	li1["n"] = (li1["n"] - 1)
	return remove1(li1, idx2)
end)
reverse1 = (function(xs10, acc2)
	if _21_1(exists_3f_1(acc2)) then
		return reverse1(xs10, {tag = "list", n =0})
	elseif nil_3f_1(xs10) then
		return acc2
	else
		return reverse1(cdr2(xs10), cons1(car2(xs10), acc2))
	end
end)
caar1 = (function(x12)
	return car2(car2(x12))
end)
cadr1 = (function(x13)
	return car2(cdr2(x13))
end)
_2e2e_1 = (function(...)
	local args1 = _pack(...) args1.tag = "list"
	return concat1(args1)
end)
_23_s1 = len1
split1 = (function(text1, pattern1, limit1)
	local out1 = {tag = "list", n =0}
	local loop1 = true
	local start1 = 1
	local r_451 = nil
	r_451 = (function()
		if loop1 then
			local pos1 = list1(find1(text1, pattern1, start1))
			local temp1
			local r_461 = ("nil" == type_23_1(pos1))
			if r_461 then
				temp1 = r_461
			else
				local r_471 = (nth1(pos1, 1) == nil)
				if r_471 then
					temp1 = r_471
				else
					local r_481 = limit1
					if r_481 then
						temp1 = (_23_1(out1) >= limit1)
					else
						temp1 = r_481
					end
				end
			end
			if temp1 then
				loop1 = false
				pushCdr_21_1(out1, sub1(text1, start1, _23_s1(text1)))
				start1 = (_23_s1(text1) + 1)
			else
				if car1(pos1) then
					pushCdr_21_1(out1, sub1(text1, start1, (car1(pos1) - 1)))
					start1 = (cadr1(pos1) + 1)
				else
					loop1 = false
				end
			end
			return r_451()
		else
		end
	end)
	r_451()
	return out1
end)
struct1 = (function(...)
	local keys1 = _pack(...) keys1.tag = "list"
	if ((_23_1(keys1) % 1) == 1) then
		error1("Expected an even number of arguments to struct", 2)
	else
	end
	local contents1 = (function(key1)
		return key1["contents"]
	end)
	local out2 = emptyStruct1()
	local r_591 = _23_1(keys1)
	local r_601 = 2
	local r_571 = nil
	r_571 = (function(r_581)
		if (r_581 <= r_591) then
			local i1 = r_581
			local key2 = keys1[i1]
			local val3 = keys1[(1 + i1)]
			out2[(function()
				if key_3f_1(key2) then
					return contents1(key2)
				else
					return key2
				end
			end)()
			] = val3
			return r_571((r_581 + 2))
		else
		end
	end)
	r_571(1)
	return out2
end)
_23_keys1 = (function(st1)
	local cnt1 = 0
	iterPairs1(st1, (function()
		cnt1 = (cnt1 + 1)
		return nil
	end))
	return cnt1
end)
succ1 = (function(x14)
	return (x14 + 1)
end)
pred1 = (function(x15)
	return (x15 - 1)
end)
string_2d3e_number1 = tonumber1
number_2d3e_string1 = tostring1
symbol_2d3e_string1 = (function(x16)
	if symbol_3f_1(x16) then
		return x16["contents"]
	else
		return nil
	end
end)
error_21_1 = error1
print_21_1 = print1
fail_21_1 = (function(x17)
	return error_21_1(x17, 0)
end)
builtins1 = require1("tacky.analysis.resolve")["builtins"]
visitQuote1 = (function(node1, visitor1, level1)
	if (level1 == 0) then
		return visitNode1(node1, visitor1)
	else
		local tag2 = node1["tag"]
		local temp2
		local r_1131 = (tag2 == "string")
		if r_1131 then
			temp2 = r_1131
		else
			local r_1141 = (tag2 == "number")
			if r_1141 then
				temp2 = r_1141
			else
				local r_1151 = (tag2 == "key")
				if r_1151 then
					temp2 = r_1151
				else
					temp2 = (tag2 == "symbol")
				end
			end
		end
		if temp2 then
			return nil
		elseif (tag2 == "list") then
			local first1 = nth1(node1, 1)
			local temp3
			local r_1161 = first1
			if r_1161 then
				temp3 = (first1["tag"] == "symbol")
			else
				temp3 = r_1161
			end
			if temp3 then
				local temp4
				local r_1171 = (first1["contents"] == "unquote")
				if r_1171 then
					temp4 = r_1171
				else
					temp4 = (first1["contents"] == "unquote-splice")
				end
				if temp4 then
					return visitQuote1(nth1(node1, 2), visitor1, pred1(level1))
				elseif (first1["contents"] == "quasiquote") then
					return visitQuote1(nth1(node1, 2), visitor1, succ1(level1))
				else
					local r_1191 = node1
					local r_1221 = _23_1(r_1191)
					local r_1231 = 1
					local r_1201 = nil
					r_1201 = (function(r_1211)
						if (r_1211 <= r_1221) then
							local r_1181 = r_1211
							local sub2 = r_1191[r_1181]
							visitQuote1(sub2, visitor1, level1)
							return r_1201((r_1211 + 1))
						else
						end
					end)
					return r_1201(1)
				end
			else
				local r_1251 = node1
				local r_1281 = _23_1(r_1251)
				local r_1291 = 1
				local r_1261 = nil
				r_1261 = (function(r_1271)
					if (r_1271 <= r_1281) then
						local r_1241 = r_1271
						local sub3 = r_1251[r_1241]
						visitQuote1(sub3, visitor1, level1)
						return r_1261((r_1271 + 1))
					else
					end
				end)
				return r_1261(1)
			end
		elseif error_21_1 then
			return _2e2e_1("Unknown tag ", tag2)
		else
			_error("unmatched item")
		end
	end
end)
visitNode1 = (function(node2, visitor2)
	if (visitor2(node2) == false) then
	else
		local tag3 = node2["tag"]
		local temp5
		local r_1301 = (tag3 == "string")
		if r_1301 then
			temp5 = r_1301
		else
			local r_1311 = (tag3 == "number")
			if r_1311 then
				temp5 = r_1311
			else
				local r_1321 = (tag3 == "key")
				if r_1321 then
					temp5 = r_1321
				else
					temp5 = (tag3 == "symbol")
				end
			end
		end
		if temp5 then
			return nil
		elseif (tag3 == "list") then
			local first2 = nth1(node2, 1)
			if (first2["tag"] == "symbol") then
				local func1 = first2["var"]
				local funct1 = func1["tag"]
				if (func1 == builtins1["lambda"]) then
					return visitBlock1(node2, 3, visitor2)
				elseif (func1 == builtins1["cond"]) then
					local r_1351 = _23_1(node2)
					local r_1361 = 1
					local r_1331 = nil
					r_1331 = (function(r_1341)
						if (r_1341 <= r_1351) then
							local i2 = r_1341
							local case1 = nth1(node2, i2)
							visitNode1(nth1(case1, 1), visitor2)
							visitBlock1(case1, 2, visitor2)
							return r_1331((r_1341 + 1))
						else
						end
					end)
					return r_1331(2)
				elseif (func1 == builtins1["set!"]) then
					return visitNode1(nth1(node2, 3), visitor2)
				elseif (func1 == builtins1["quote"]) then
				elseif (func1 == builtins1["quasiquote"]) then
					return visitQuote1(nth1(node2, 2), visitor2, 1)
				else
					local temp6
					local r_1371 = (func1 == builtins1["unquote"])
					if r_1371 then
						temp6 = r_1371
					else
						temp6 = (func1 == builtins1["unquote-splice"])
					end
					if temp6 then
						return fail_21_1("unquote/unquote-splice should never appear head")
					else
						local temp7
						local r_1381 = (func1 == builtins1["define"])
						if r_1381 then
							temp7 = r_1381
						else
							temp7 = (func1 == builtins1["define-macro"])
						end
						if temp7 then
							return visitNode1(nth1(node2, _23_1(node2)), visitor2)
						elseif (func1 == builtins1["define-native"]) then
						elseif (func1 == builtins1["import"]) then
						elseif (funct1 == "macro") then
							return fail_21_1("Macros should have been expanded")
						else
							local temp8
							local r_1391 = (funct1 == "defined")
							if r_1391 then
								temp8 = r_1391
							else
								local r_1401 = (funct1 == "arg")
								if r_1401 then
									temp8 = r_1401
								else
									temp8 = (funct1 == "native")
								end
							end
							if temp8 then
								return visitBlock1(node2, 1, visitor2)
							else
								return fail_21_1(_2e2e_1("Unknown kind ", funct1, " for variable ", func1["name"]))
							end
						end
					end
				end
			else
				return visitBlock1(node2, 1, visitor2)
			end
		else
			return error_21_1(_2e2e_1("Unknown tag ", tag3))
		end
	end
end)
visitBlock1 = (function(node3, start2, visitor3)
	local r_1111 = _23_1(node3)
	local r_1121 = 1
	local r_1091 = nil
	r_1091 = (function(r_1101)
		if (r_1101 <= r_1111) then
			local i3 = r_1101
			visitNode1(nth1(node3, i3), visitor3)
			return r_1091((r_1101 + 1))
		else
		end
	end)
	return r_1091(start2)
end)
visitList1 = visitBlock1
builtins2 = require1("tacky.analysis.resolve")["builtins"]
builtinVars1 = require1("tacky.analysis.resolve")["declaredVars"]
createState1 = (function()
	return struct1("vars", emptyStruct1(), "nodes", emptyStruct1())
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
		entry2 = struct1("uses", {tag = "list", n =0})
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
addDefinition_21_1 = (function(state4, var3, node6, kind1, value1)
	local varMeta2 = getVar1(state4, var3)
	if value1 then
		local nodeMeta2 = getNode1(state4, value1)
		if nodeMeta2["defines"] then
			error_21_1("Value defines multiple variables")
		else
		end
		nodeMeta2["defines"] = var3
	else
	end
	varMeta2["defs"][node6] = struct1("tag", kind1, "value", value1)
	return nil
end)
definitionsVisitor1 = (function(state5, node7)
	local temp9
	local r_931 = list_3f_1(node7)
	if r_931 then
		temp9 = symbol_3f_1(car2(node7))
	else
		temp9 = r_931
	end
	if temp9 then
		local func2 = car2(node7)["var"]
		if (func2 == builtins2["lambda"]) then
			local r_951 = nth1(node7, 2)
			local r_981 = _23_1(r_951)
			local r_991 = 1
			local r_961 = nil
			r_961 = (function(r_971)
				if (r_971 <= r_981) then
					local r_941 = r_971
					local arg1 = r_951[r_941]
					addDefinition_21_1(state5, arg1["var"], arg1, "arg", arg1)
					return r_961((r_971 + 1))
				else
				end
			end)
			return r_961(1)
		elseif (func2 == builtins2["set!"]) then
			return addDefinition_21_1(state5, node7[2]["var"], node7, "set", nth1(node7, 3))
		else
			local temp10
			local r_1001 = (func2 == builtins2["define"])
			if r_1001 then
				temp10 = r_1001
			else
				temp10 = (func2 == builtins2["define-macro"])
			end
			if temp10 then
				return addDefinition_21_1(state5, node7["defVar"], node7, "define", nth1(node7, _23_1(node7)))
			elseif (func2 == builtins2["define-native"]) then
				return addDefinition_21_1(state5, node7["defVar"], node7, "native")
			else
			end
		end
	else
		local temp11
		local r_1011 = list_3f_1(node7)
		if r_1011 then
			local r_1021 = list_3f_1(car2(node7))
			if r_1021 then
				local r_1031 = symbol_3f_1(caar1(node7))
				if r_1031 then
					temp11 = (caar1(node7)["var"] == builtins2["lambda"])
				else
					temp11 = r_1031
				end
			else
				temp11 = r_1021
			end
		else
			temp11 = r_1011
		end
		if temp11 then
			local lam1 = car2(node7)
			local args2 = nth1(lam1, 2)
			local offset1 = 1
			local r_1061 = _23_1(args2)
			local r_1071 = 1
			local r_1041 = nil
			r_1041 = (function(r_1051)
				if (r_1051 <= r_1061) then
					local i4 = r_1051
					local arg2 = nth1(args2, i4)
					local val4 = nth1(node7, (i4 + offset1))
					if arg2["var"]["isVariadic"] then
						local count1 = (_23_1(node7) - _23_1(args2))
						if (count1 < 0) then
							count1 = 0
						else
						end
						offset1 = count1
						addDefinition_21_1(state5, arg2["var"], arg2, "arg", arg2)
					else
						addDefinition_21_1(state5, arg2["var"], arg2, "let", (function(r_1081)
							if r_1081 then
								return r_1081
							else
								return struct1("tag", "symbol", "contents", "nil", "var", builtinVars1["nil"])
							end
						end)(val4))
					end
					return r_1041((r_1051 + 1))
				else
				end
			end)
			r_1041(1)
			local visitor4 = (function(r_1531)
				return definitionsVisitor1(state5, r_1531)
			end)
			visitList1(node7, 2, visitor4)
			visitBlock1(lam1, 3, visitor4)
			return false
		else
		end
	end
end)
definitionsVisit1 = (function(state6, nodes1)
	return visitBlock1(nodes1, 1, (function(r_1541)
		return definitionsVisitor1(state6, r_1541)
	end))
end)
usagesVisit1 = (function(state7, nodes2, pred2)
	if pred2 then
	else
		pred2 = (function()
			return true
		end)
	end
	local queue1 = {tag = "list", n =0}
	local visited1 = emptyStruct1()
	local addUsage1 = (function(var4, user1)
		addUsage_21_1(state7, var4, user1)
		local varMeta3 = getVar1(state7, var4)
		if varMeta3["active"] then
			return iterPairs1(varMeta3["defs"], (function(_5f_1, def1)
				local val5 = def1["value"]
				local temp12
				local r_1521 = val5
				if r_1521 then
					temp12 = _21_1(visited1[val5])
				else
					temp12 = r_1521
				end
				if temp12 then
					return pushCdr_21_1(queue1, val5)
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
				local temp13
				local r_1481 = list_3f_1(node8)
				if r_1481 then
					local r_1491 = (_23_1(node8) > 0)
					if r_1491 then
						temp13 = symbol_3f_1(car2(node8))
					else
						temp13 = r_1491
					end
				else
					temp13 = r_1481
				end
				if temp13 then
					local func3 = car2(node8)["var"]
					local temp14
					local r_1501 = (func3 == builtins2["set!"])
					if r_1501 then
						temp14 = r_1501
					else
						local r_1511 = (func3 == builtins2["define"])
						if r_1511 then
							temp14 = r_1511
						else
							temp14 = (func3 == builtins2["define-macro"])
						end
					end
					if temp14 then
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
	local r_1421 = nodes2
	local r_1451 = _23_1(r_1421)
	local r_1461 = 1
	local r_1431 = nil
	r_1431 = (function(r_1441)
		if (r_1441 <= r_1451) then
			local r_1411 = r_1441
			local node9 = r_1421[r_1411]
			pushCdr_21_1(queue1, node9)
			return r_1431((r_1441 + 1))
		else
		end
	end)
	r_1431(1)
	local r_1471 = nil
	r_1471 = (function()
		if (_23_1(queue1) > 0) then
			visitNode1(removeNth_21_1(queue1, 1), visit1)
			return r_1471()
		else
		end
	end)
	return r_1471()
end)
abs1 = _libs["lib/lua/math/abs"]
max1 = _libs["lib/lua/math/max"]
verbosity1 = struct1("value", 0)
setVerbosity_21_1 = (function(level2)
	verbosity1["value"] = level2
	return nil
end)
showExplain1 = struct1("value", false)
setExplain_21_1 = (function(value2)
	showExplain1["value"] = value2
	return nil
end)
colored1 = (function(col1, msg1)
	return _2e2e_1("\27[", col1, "m", msg1, "\27[0m")
end)
printError_21_1 = (function(msg2)
	local lines1 = split1(msg2, "\n", 1)
	print_21_1(colored1(31, _2e2e_1("[ERROR] ", car2(lines1))))
	if cadr1(lines1) then
		return print_21_1(cadr1(lines1))
	else
	end
end)
printWarning_21_1 = (function(msg3)
	local lines2 = split1(msg3, "\n", 1)
	print_21_1(colored1(33, _2e2e_1("[WARN] ", car2(lines2))))
	if cadr1(lines2) then
		return print_21_1(cadr1(lines2))
	else
	end
end)
printVerbose_21_1 = (function(msg4)
	if (verbosity1["value"] > 0) then
		return print_21_1(_2e2e_1("[VERBOSE] ", msg4))
	else
	end
end)
printDebug_21_1 = (function(msg5)
	if (verbosity1["value"] > 1) then
		return print_21_1(_2e2e_1("[DEBUG] ", msg5))
	else
	end
end)
formatPosition1 = (function(pos2)
	return _2e2e_1(pos2["line"], ":", pos2["column"])
end)
formatRange1 = (function(range1)
	if range1["finish"] then
		return format1("%s:[%s .. %s]", range1["name"], formatPosition1(range1["start"]), formatPosition1(range1["finish"]))
	else
		return format1("%s:[%s]", range1["name"], formatPosition1(range1["start"]))
	end
end)
formatNode1 = (function(node10)
	local temp15
	local r_1551 = node10["range"]
	if r_1551 then
		temp15 = node10["contents"]
	else
		temp15 = r_1551
	end
	if temp15 then
		return format1("%s (%q)", formatRange1(node10["range"]), node10["contents"])
	elseif node10["range"] then
		return formatRange1(node10["range"])
	elseif node10["macro"] then
		local macro1 = node10["macro"]
		return format1("macro expansion of %s (%s)", macro1["var"]["name"], formatNode1(macro1["node"]))
	else
		local temp16
		local r_1651 = node10["start"]
		if r_1651 then
			temp16 = node10["finish"]
		else
			temp16 = r_1651
		end
		if temp16 then
			return formatRange1(node10)
		else
			return "?"
		end
	end
end)
getSource1 = (function(node11)
	local result1 = nil
	local r_1561 = nil
	r_1561 = (function()
		local temp17
		local r_1571 = node11
		if r_1571 then
			temp17 = _21_1(result1)
		else
			temp17 = r_1571
		end
		if temp17 then
			result1 = node11["range"]
			node11 = node11["parent"]
			return r_1561()
		else
		end
	end)
	r_1561()
	return result1
end)
putLines_21_1 = (function(range2, ...)
	local entries1 = _pack(...) entries1.tag = "list"
	if nil_3f_1(entries1) then
		error_21_1("Positions cannot be empty")
	else
	end
	if ((_23_1(entries1) % 2) ~= 0) then
		error_21_1(_2e2e_1("Positions must be a multiple of 2, is ", _23_1(entries1)))
	else
	end
	local previous1 = -1
	local file1 = nth1(entries1, 1)["name"]
	local maxLine1 = foldr1((function(node12, max2)
		if string_3f_1(node12) then
			return max2
		else
			return max1(max2, node12["start"]["line"])
		end
	end), 0, entries1)
	local code1 = _2e2e_1("\27[92m %", _23_s1(number_2d3e_string1(maxLine1)), "s |\27[0m %s")
	local r_1681 = _23_1(entries1)
	local r_1691 = 2
	local r_1661 = nil
	r_1661 = (function(r_1671)
		if (r_1671 <= r_1681) then
			local i5 = r_1671
			local position1 = entries1[i5]
			local message1 = entries1[succ1(i5)]
			if (file1 ~= position1["name"]) then
				file1 = position1["name"]
				print_21_1(_2e2e_1("\27[95m ", file1, "\27[0m"))
			else
				local temp18
				local r_1701 = (previous1 ~= -1)
				if r_1701 then
					temp18 = (abs1((position1["start"]["line"] - previous1)) > 2)
				else
					temp18 = r_1701
				end
				if temp18 then
					print_21_1(" \27[92m...\27[0m")
				else
				end
			end
			previous1 = position1["start"]["line"]
			print_21_1(format1(code1, number_2d3e_string1(position1["start"]["line"]), position1["lines"][position1["start"]["line"]]))
			local pointer1
			if _21_1(range2) then
				pointer1 = "^"
			else
				local temp19
				local r_1711 = position1["finish"]
				if r_1711 then
					temp19 = (position1["start"]["line"] == position1["finish"]["line"])
				else
					temp19 = r_1711
				end
				if temp19 then
					pointer1 = rep1("^", succ1((position1["finish"]["column"] - position1["start"]["column"])))
				else
					pointer1 = "^..."
				end
			end
			print_21_1(format1(code1, "", _2e2e_1(rep1(" ", (position1["start"]["column"] - 1)), pointer1, " ", message1)))
			return r_1661((r_1671 + 2))
		else
		end
	end)
	return r_1661(1)
end)
putTrace_21_1 = (function(node13)
	local previous2 = nil
	local r_1581 = nil
	r_1581 = (function()
		if node13 then
			local formatted1 = formatNode1(node13)
			if (previous2 == nil) then
				print_21_1(colored1(96, _2e2e_1("  => ", formatted1)))
			elseif (previous2 ~= formatted1) then
				print_21_1(_2e2e_1("  in ", formatted1))
			else
			end
			previous2 = formatted1
			node13 = node13["parent"]
			return r_1581()
		else
		end
	end)
	return r_1581()
end)
putExplain_21_1 = (function(...)
	local lines3 = _pack(...) lines3.tag = "list"
	if showExplain1["value"] then
		local r_1601 = lines3
		local r_1631 = _23_1(r_1601)
		local r_1641 = 1
		local r_1611 = nil
		r_1611 = (function(r_1621)
			if (r_1621 <= r_1631) then
				local r_1591 = r_1621
				local line1 = r_1601[r_1591]
				print_21_1(_2e2e_1("  ", line1))
				return r_1611((r_1621 + 1))
			else
			end
		end)
		return r_1611(1)
	else
	end
end)
errorPositions_21_1 = (function(node14, msg6)
	printError_21_1(msg6)
	putTrace_21_1(node14)
	local source1 = getSource1(node14)
	if source1 then
		putLines_21_1(true, source1, "")
	else
	end
	return fail_21_1("An error occured")
end)
struct1("colored", colored1, "formatPosition", formatPosition1, "formatRange", formatRange1, "formatNode", formatNode1, "putLines", putLines_21_1, "putTrace", putTrace_21_1, "putInfo", putExplain_21_1, "getSource", getSource1, "printWarning", printWarning_21_1, "printError", printError_21_1, "printVerbose", printVerbose_21_1, "printDebug", printDebug_21_1, "errorPositions", errorPositions_21_1, "setVerbosity", setVerbosity_21_1, "setExplain", setExplain_21_1)
builtins3 = require1("tacky.analysis.resolve")["builtins"]
sideEffect_3f_1 = (function(node15)
	local tag4 = type1(node15)
	local temp20
	local r_891 = (tag4 == "number")
	if r_891 then
		temp20 = r_891
	else
		local r_901 = (tag4 == "string")
		if r_901 then
			temp20 = r_901
		else
			local r_911 = (tag4 == "key")
			if r_911 then
				temp20 = r_911
			else
				temp20 = (tag4 == "symbol")
			end
		end
	end
	if temp20 then
		return false
	elseif (tag4 == "list") then
		local fst1 = car2(node15)
		if (type1(fst1) == "symbol") then
			local var5 = fst1["var"]
			local r_921 = (var5 ~= builtins3["lambda"])
			if r_921 then
				return (var5 ~= builtins3["quote"])
			else
				return r_921
			end
		else
			return true
		end
	else
		_error("unmatched item")
	end
end)
warnArity1 = (function(lookup1, nodes3)
	local arity1
	local getArity1
	arity1 = emptyStruct1()
	getArity1 = (function(symbol1)
		local var6 = getVar1(lookup1, symbol1["var"])
		local ari1 = arity1[var6]
		if (ari1 ~= nil) then
			return ari1
		elseif (_23_keys1(var6["defs"]) ~= 1) then
			return false
		else
			arity1[var6] = false
			local defData1 = cadr1(list1(next1(var6["defs"])))
			local def2 = defData1["value"]
			if (defData1["tag"] == "arg") then
				ari1 = false
			else
				if symbol_3f_1(def2) then
					ari1 = getArity1(def2)
				else
					local temp21
					local r_1721 = list_3f_1(def2)
					if r_1721 then
						local r_1731 = symbol_3f_1(car2(def2))
						if r_1731 then
							temp21 = (car2(def2)["var"] == builtins3["lambda"])
						else
							temp21 = r_1731
						end
					else
						temp21 = r_1721
					end
					if temp21 then
						local args3 = nth1(def2, 2)
						if any1((function(x18)
							return x18["var"]["isVariadic"]
						end), args3) then
							ari1 = false
						else
							ari1 = _23_1(args3)
						end
					else
						ari1 = false
					end
				end
			end
			arity1[var6] = ari1
			return ari1
		end
	end)
	return visitBlock1(nodes3, 1, (function(node16)
		local temp22
		local r_1741 = list_3f_1(node16)
		if r_1741 then
			temp22 = symbol_3f_1(car2(node16))
		else
			temp22 = r_1741
		end
		if temp22 then
			local arity2 = getArity1(car2(node16))
			local temp23
			local r_1751 = arity2
			if r_1751 then
				temp23 = (arity2 < pred1(_23_1(node16)))
			else
				temp23 = r_1751
			end
			if temp23 then
				printWarning_21_1(_2e2e_1("Calling ", symbol_2d3e_string1(car2(node16)), " with ", string_2d3e_number1(pred1(_23_1(node16))), " arguments, expected ", string_2d3e_number1(arity2)))
				putTrace_21_1(node16)
				return putLines_21_1(true, getSource1(node16), "Called here")
			else
			end
		else
		end
	end))
end)
analyse1 = (function(nodes4)
	local lookup2 = createState1()
	definitionsVisit1(lookup2, nodes4)
	usagesVisit1(lookup2, nodes4, sideEffect_3f_1)
	warnArity1(lookup2, nodes4)
	return nodes4
end)
return struct1("analyse", analyse1)
