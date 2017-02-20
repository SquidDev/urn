if not table.pack then table.pack = function(...) return { n = select("#", ...), ... } end end
if not table.unpack then table.unpack = unpack end
if _VERSION:find("5.1") then local function load(x, _, _, env) local f, e = loadstring(x); if not f then error(e, 1) end; return setfenv(f, env) end end
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
			elseif x.tag == 'symbol' or x.tag == 'key' or x.tag == 'string' or x.tag == 'number' then
				return x.contents
			else
				return tostring(x)
			end
		elseif type(x) == 'string' then
			return ("%q"):format(x)
		else
			return tostring(x)
		end
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
		_G = _G, _ENV = _ENV, _VERSION = _VERSION,
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
local _3d_1, _2f3d_1, _3c_1, _3c3d_1, _3e_1, _3e3d_1, _2b_1, _2d_1, _25_1, slice1, error1, getIdx1, setIdx_21_1, require1, type_23_1, _23_1, concat1, remove1, emptyStruct1, iterPairs1, car1, cdr1, _21_1, format1, sub1, list_3f_1, string_3f_1, number_3f_1, symbol_3f_1, key_3f_1, type1, car2, cdr2, nth1, pushCdr_21_1, removeNth_21_1, _2e2e_1, struct1, succ1, pred1, error_21_1, fail_21_1, builtins1, visitQuote1, visitNode1, visitBlock1, builtins2, createState1, getVar1, getNode1, addUsage_21_1, addDefinition_21_1, definitionsVisitor1, definitionsVisit1, usagesVisit1, builtins3, traverseQuote1, traverseNode1, traverseBlock1, traverseList1, builtins4, builtinVars1, hasSideEffect1, truthy_3f_1, makeProgn1, optimiseOnce1, optimise1
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
getIdx1 = _libs["lib/lua/basic/get-idx"]
setIdx_21_1 = _libs["lib/lua/basic/set-idx!"]
require1 = _libs["lib/lua/basic/require"]
type_23_1 = _libs["lib/lua/basic/type#"]
_23_1 = (function(x1)
	return x1["n"]
end)
concat1 = _libs["lib/lua/table/concat"]
remove1 = _libs["lib/lua/table/remove"]
emptyStruct1 = _libs["lib/lua/table/empty-struct"]
iterPairs1 = _libs["lib/lua/table/iter-pairs"]
car1 = (function(xs1)
	return xs1[1]
end)
cdr1 = (function(xs2)
	return slice1(xs2, 2)
end)
_21_1 = (function(expr1)
	if expr1 then
		return false
	else
		return true
	end
end)
format1 = _libs["lib/lua/string/format"]
sub1 = _libs["lib/lua/string/sub"]
list_3f_1 = (function(x2)
	return (type1(x2) == "list")
end)
string_3f_1 = (function(x3)
	return (type1(x3) == "string")
end)
number_3f_1 = (function(x4)
	return (type1(x4) == "number")
end)
symbol_3f_1 = (function(x5)
	return (type1(x5) == "symbol")
end)
key_3f_1 = (function(x6)
	return (type1(x6) == "key")
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
car2 = (function(x7)
	local r_171 = type1(x7)
	if (r_171 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_171), 2)
	else
	end
	return car1(x7)
end)
cdr2 = (function(x8)
	local r_181 = type1(x8)
	if (r_181 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_181), 2)
	else
	end
	return cdr1(x8)
end)
nth1 = getIdx1
pushCdr_21_1 = (function(xs3, val2)
	local r_271 = type1(xs3)
	if (r_271 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_271), 2)
	else
	end
	local len1 = (_23_1(xs3) + 1)
	xs3["n"] = len1
	xs3[len1] = val2
	return xs3
end)
removeNth_21_1 = (function(li1, idx1)
	local r_291 = type1(li1)
	if (r_291 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_291), 2)
	else
	end
	li1["n"] = (li1["n"] - 1)
	return remove1(li1, idx1)
end)
_2e2e_1 = (function(...)
	local args1 = _pack(...) args1.tag = "list"
	return concat1(args1)
end)
struct1 = (function(...)
	local keys1 = _pack(...) keys1.tag = "list"
	if ((_23_1(keys1) % 1) == 1) then
		error1("Expected an even number of arguments to struct", 2)
	else
	end
	local contents1 = (function(key1)
		return sub1(key1["contents"], 2)
	end)
	local out1 = emptyStruct1()
	local r_521 = _23_1(keys1)
	local r_531 = 2
	local r_501 = nil
	r_501 = (function(r_511)
		local temp1
		if (0 < 2) then
			temp1 = (r_511 <= r_521)
		else
			temp1 = (r_511 >= r_521)
		end
		if temp1 then
			local i1 = r_511
			local key2 = keys1[i1]
			local val3 = keys1[(1 + i1)]
			out1[(function()
				if key_3f_1(key2) then
					return contents1(key2)
				else
					return key2
				end
			end)()
			] = val3
			return r_501((r_511 + r_531))
		else
		end
	end)
	r_501(1)
	return out1
end)
succ1 = (function(x9)
	return (x9 + 1)
end)
pred1 = (function(x10)
	return (x10 - 1)
end)
error_21_1 = error1
fail_21_1 = (function(x11)
	return error_21_1(x11, 0)
end)
builtins1 = require1("tacky.analysis.resolve")["builtins"]
visitQuote1 = (function(node1, visitor1, level1)
	if (level1 == 0) then
		return visitNode1(node1, visitor1)
	else
		local tag2 = node1["tag"]
		local temp2
		local r_1141 = (tag2 == "string")
		if r_1141 then
			temp2 = r_1141
		else
			local r_1151 = (tag2 == "number")
			if r_1151 then
				temp2 = r_1151
			else
				local r_1161 = (tag2 == "key")
				if r_1161 then
					temp2 = r_1161
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
			local r_1171 = first1
			if r_1171 then
				temp3 = (first1["tag"] == "symbol")
			else
				temp3 = r_1171
			end
			if temp3 then
				local temp4
				local r_1181 = (first1["contents"] == "unquote")
				if r_1181 then
					temp4 = r_1181
				else
					temp4 = (first1["contents"] == "unquote-splice")
				end
				if temp4 then
					return visitQuote1(nth1(node1, 2), visitor1, pred1(level1))
				elseif (first1["contents"] == "quasiquote") then
					return visitQuote1(nth1(node1, 2), visitor1, succ1(level1))
				else
					local r_1201 = node1
					local r_1231 = _23_1(r_1201)
					local r_1241 = 1
					local r_1211 = nil
					r_1211 = (function(r_1221)
						local temp5
						if (0 < 1) then
							temp5 = (r_1221 <= r_1231)
						else
							temp5 = (r_1221 >= r_1231)
						end
						if temp5 then
							local r_1191 = r_1221
							local sub2 = r_1201[r_1191]
							visitQuote1(sub2, visitor1, level1)
							return r_1211((r_1221 + r_1241))
						else
						end
					end)
					return r_1211(1)
				end
			else
				local r_1261 = node1
				local r_1291 = _23_1(r_1261)
				local r_1301 = 1
				local r_1271 = nil
				r_1271 = (function(r_1281)
					local temp6
					if (0 < 1) then
						temp6 = (r_1281 <= r_1291)
					else
						temp6 = (r_1281 >= r_1291)
					end
					if temp6 then
						local r_1251 = r_1281
						local sub3 = r_1261[r_1251]
						visitQuote1(sub3, visitor1, level1)
						return r_1271((r_1281 + r_1301))
					else
					end
				end)
				return r_1271(1)
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
		local temp7
		local r_1311 = (tag3 == "string")
		if r_1311 then
			temp7 = r_1311
		else
			local r_1321 = (tag3 == "number")
			if r_1321 then
				temp7 = r_1321
			else
				local r_1331 = (tag3 == "key")
				if r_1331 then
					temp7 = r_1331
				else
					temp7 = (tag3 == "symbol")
				end
			end
		end
		if temp7 then
			return nil
		elseif (tag3 == "list") then
			local first2 = nth1(node2, 1)
			if (first2["tag"] == "symbol") then
				local func1 = first2["var"]
				local funct1 = func1["tag"]
				if (func1 == builtins1["lambda"]) then
					return visitBlock1(node2, 3, visitor2)
				elseif (func1 == builtins1["cond"]) then
					local r_1361 = _23_1(node2)
					local r_1371 = 1
					local r_1341 = nil
					r_1341 = (function(r_1351)
						local temp8
						if (0 < 1) then
							temp8 = (r_1351 <= r_1361)
						else
							temp8 = (r_1351 >= r_1361)
						end
						if temp8 then
							local i2 = r_1351
							local case1 = nth1(node2, i2)
							visitNode1(nth1(case1, 1), visitor2)
							visitBlock1(case1, 2, visitor2)
							return r_1341((r_1351 + r_1371))
						else
						end
					end)
					return r_1341(2)
				elseif (func1 == builtins1["set!"]) then
					return visitNode1(nth1(node2, 3), visitor2)
				elseif (func1 == builtins1["quote"]) then
				elseif (func1 == builtins1["quasiquote"]) then
					return visitQuote1(nth1(node2, 2), visitor2, 1)
				else
					local temp9
					local r_1381 = (func1 == builtins1["unquote"])
					if r_1381 then
						temp9 = r_1381
					else
						temp9 = (func1 == builtins1["unquote-splice"])
					end
					if temp9 then
						return fail_21_1("unquote/unquote-splice should never appear head")
					else
						local temp10
						local r_1391 = (func1 == builtins1["define"])
						if r_1391 then
							temp10 = r_1391
						else
							temp10 = (func1 == builtins1["define-macro"])
						end
						if temp10 then
							return visitNode1(nth1(node2, 3), visitor2)
						elseif (func1 == builtins1["define-native"]) then
						elseif (func1 == builtins1["import"]) then
						elseif (funct1 == "macro") then
							return fail_21_1("Macros should have been expanded")
						else
							local temp11
							local r_1401 = (funct1 == "defined")
							if r_1401 then
								temp11 = r_1401
							else
								local r_1411 = (funct1 == "arg")
								if r_1411 then
									temp11 = r_1411
								else
									temp11 = (funct1 == "native")
								end
							end
							if temp11 then
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
visitBlock1 = (function(node3, start1, visitor3)
	local r_1121 = _23_1(node3)
	local r_1131 = 1
	local r_1101 = nil
	r_1101 = (function(r_1111)
		local temp12
		if (0 < 1) then
			temp12 = (r_1111 <= r_1121)
		else
			temp12 = (r_1111 >= r_1121)
		end
		if temp12 then
			local i3 = r_1111
			visitNode1(nth1(node3, i3), visitor3)
			return r_1101((r_1111 + r_1131))
		else
		end
	end)
	return r_1101(start1)
end)
builtins2 = require1("tacky.analysis.resolve")["builtins"]
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
	local temp13
	local r_1011 = list_3f_1(node7)
	if r_1011 then
		local r_1021 = (_23_1(node7) > 0)
		if r_1021 then
			temp13 = symbol_3f_1(car2(node7))
		else
			temp13 = r_1021
		end
	else
		temp13 = r_1011
	end
	if temp13 then
		local func2 = car2(node7)["var"]
		if (func2 == builtins2["lambda"]) then
			local r_1041 = nth1(node7, 2)
			local r_1071 = _23_1(r_1041)
			local r_1081 = 1
			local r_1051 = nil
			r_1051 = (function(r_1061)
				local temp14
				if (0 < 1) then
					temp14 = (r_1061 <= r_1071)
				else
					temp14 = (r_1061 >= r_1071)
				end
				if temp14 then
					local r_1031 = r_1061
					local arg1 = r_1041[r_1031]
					addDefinition_21_1(state5, arg1["var"], arg1, "arg", arg1)
					return r_1051((r_1061 + r_1081))
				else
				end
			end)
			return r_1051(1)
		elseif (func2 == builtins2["set!"]) then
			return addDefinition_21_1(state5, node7[2]["var"], node7, "set", nth1(node7, 3))
		else
			local temp15
			local r_1091 = (func2 == builtins2["define"])
			if r_1091 then
				temp15 = r_1091
			else
				temp15 = (func2 == builtins2["define-macro"])
			end
			if temp15 then
				return addDefinition_21_1(state5, node7["defVar"], node7, "define", nth1(node7, 3))
			elseif (func2 == builtins2["define-native"]) then
				return addDefinition_21_1(state5, node7["defVar"], node7, "native")
			else
			end
		end
	else
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
				local val4 = def1["value"]
				local temp16
				local r_1531 = val4
				if r_1531 then
					temp16 = _21_1(visited1[val4])
				else
					temp16 = r_1531
				end
				if temp16 then
					return pushCdr_21_1(queue1, val4)
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
				local temp17
				local r_1491 = list_3f_1(node8)
				if r_1491 then
					local r_1501 = (_23_1(node8) > 0)
					if r_1501 then
						temp17 = symbol_3f_1(car2(node8))
					else
						temp17 = r_1501
					end
				else
					temp17 = r_1491
				end
				if temp17 then
					local func3 = car2(node8)["var"]
					local temp18
					local r_1511 = (func3 == builtins2["set!"])
					if r_1511 then
						temp18 = r_1511
					else
						local r_1521 = (func3 == builtins2["define"])
						if r_1521 then
							temp18 = r_1521
						else
							temp18 = (func3 == builtins2["define-macro"])
						end
					end
					if temp18 then
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
	local r_1431 = nodes2
	local r_1461 = _23_1(r_1431)
	local r_1471 = 1
	local r_1441 = nil
	r_1441 = (function(r_1451)
		local temp19
		if (0 < 1) then
			temp19 = (r_1451 <= r_1461)
		else
			temp19 = (r_1451 >= r_1461)
		end
		if temp19 then
			local r_1421 = r_1451
			local node9 = r_1431[r_1421]
			pushCdr_21_1(queue1, node9)
			return r_1441((r_1451 + r_1471))
		else
		end
	end)
	r_1441(1)
	local r_1481 = nil
	r_1481 = (function()
		if (_23_1(queue1) > 0) then
			visitNode1(removeNth_21_1(queue1, 1), visit1)
			return r_1481()
		else
		end
	end)
	return r_1481()
end)
builtins3 = require1("tacky.analysis.resolve")["builtins"]
traverseQuote1 = (function(node10, visitor4, level2)
	if (level2 == 0) then
		return traverseNode1(node10, visitor4)
	else
		local tag4 = node10["tag"]
		local temp20
		local r_1661 = (tag4 == "string")
		if r_1661 then
			temp20 = r_1661
		else
			local r_1671 = (tag4 == "number")
			if r_1671 then
				temp20 = r_1671
			else
				local r_1681 = (tag4 == "key")
				if r_1681 then
					temp20 = r_1681
				else
					temp20 = (tag4 == "symbol")
				end
			end
		end
		if temp20 then
			return visitor4(node10)
		elseif (tag4 == "list") then
			local first3 = nth1(node10, 1)
			local temp21
			local r_1691 = first3
			if r_1691 then
				temp21 = (first3["tag"] == "symbol")
			else
				temp21 = r_1691
			end
			if temp21 then
				local temp22
				local r_1701 = (first3["contents"] == "unquote")
				if r_1701 then
					temp22 = r_1701
				else
					temp22 = (first3["contents"] == "unquote-splice")
				end
				if temp22 then
					node10[2] = traverseQuote1(nth1(node10, 2), visitor4, pred1(level2))
					return visitor4(node10)
				elseif (first3["contents"] == "quasiquote") then
					node10[2] = traverseQuote1(nth1(node10, 2), visitor4, succ1(level2))
					return visitor4(node10)
				else
					local r_1731 = _23_1(node10)
					local r_1741 = 1
					local r_1711 = nil
					r_1711 = (function(r_1721)
						local temp23
						if (0 < 1) then
							temp23 = (r_1721 <= r_1731)
						else
							temp23 = (r_1721 >= r_1731)
						end
						if temp23 then
							local i4 = r_1721
							node10[i4][node10] = traverseQuote1(nth1(node10, i4), visitor4, level2)
							return r_1711((r_1721 + r_1741))
						else
						end
					end)
					r_1711(1)
					return visitor4(node10)
				end
			else
				local r_1771 = _23_1(node10)
				local r_1781 = 1
				local r_1751 = nil
				r_1751 = (function(r_1761)
					local temp24
					if (0 < 1) then
						temp24 = (r_1761 <= r_1771)
					else
						temp24 = (r_1761 >= r_1771)
					end
					if temp24 then
						local i5 = r_1761
						node10[i5][node10] = traverseQuote1(nth1(node10, i5), visitor4, level2)
						return r_1751((r_1761 + r_1781))
					else
					end
				end)
				r_1751(1)
				return visitor4(node10)
			end
		elseif error_21_1 then
			return _2e2e_1("Unknown tag ", tag4)
		else
			_error("unmatched item")
		end
	end
end)
traverseNode1 = (function(node11, visitor5)
	local tag5 = node11["tag"]
	local temp25
	local r_1551 = (tag5 == "string")
	if r_1551 then
		temp25 = r_1551
	else
		local r_1561 = (tag5 == "number")
		if r_1561 then
			temp25 = r_1561
		else
			local r_1571 = (tag5 == "key")
			if r_1571 then
				temp25 = r_1571
			else
				temp25 = (tag5 == "symbol")
			end
		end
	end
	if temp25 then
		return visitor5(node11)
	elseif (tag5 == "list") then
		local first4 = car2(node11)
		first4 = visitor5(first4)
		node11[1] = first4
		if (first4["tag"] == "symbol") then
			local func4 = first4["var"]
			local funct2 = func4["tag"]
			if (func4 == builtins3["lambda"]) then
				traverseBlock1(node11, 3, visitor5)
				return visitor5(node11)
			elseif (func4 == builtins3["cond"]) then
				local r_1811 = _23_1(node11)
				local r_1821 = 1
				local r_1791 = nil
				r_1791 = (function(r_1801)
					local temp26
					if (0 < 1) then
						temp26 = (r_1801 <= r_1811)
					else
						temp26 = (r_1801 >= r_1811)
					end
					if temp26 then
						local i6 = r_1801
						local case2 = nth1(node11, i6)
						case2[1] = traverseNode1(nth1(case2, 1), visitor5)
						traverseBlock1(case2, 2, visitor5)
						return r_1791((r_1801 + r_1821))
					else
					end
				end)
				r_1791(2)
				return visitor5(node11)
			elseif (func4 == builtins3["set!"]) then
				node11[3] = traverseNode1(nth1(node11, 3), visitor5)
				return visitor5(node11)
			elseif (func4 == builtins3["quote"]) then
				return visitor5(node11)
			elseif (func4 == builtins3["quasiquote"]) then
				node11[2] = traverseQuote1(nth1(node11, 2), visitor5, 1)
				return visitor5(node11)
			else
				local temp27
				local r_1831 = (func4 == builtins3["unquote"])
				if r_1831 then
					temp27 = r_1831
				else
					temp27 = (func4 == builtins3["unquote-splice"])
				end
				if temp27 then
					return fail_21_1("unquote/unquote-splice should never appear head")
				else
					local temp28
					local r_1841 = (func4 == builtins3["define"])
					if r_1841 then
						temp28 = r_1841
					else
						temp28 = (func4 == builtins3["define-macro"])
					end
					if temp28 then
						node11[3] = traverseNode1(nth1(node11, 3), visitor5)
						return visitor5(node11)
					elseif (func4 == builtins3["define-native"]) then
						return visitor5(node11)
					elseif (func4 == builtins3["import"]) then
						return visitor5(node11)
					else
						local temp29
						local r_1851 = (funct2 == "defined")
						if r_1851 then
							temp29 = r_1851
						else
							local r_1861 = (funct2 == "arg")
							if r_1861 then
								temp29 = r_1861
							else
								local r_1871 = (funct2 == "native")
								if r_1871 then
									temp29 = r_1871
								else
									temp29 = (funct2 == "macro")
								end
							end
						end
						if temp29 then
							traverseList1(node11, 1, visitor5)
							return visitor5(node11)
						else
							return fail_21_1(_2e2e_1("Unknown kind ", funct2, " for variable ", func4["name"]))
						end
					end
				end
			end
		else
			traverseList1(node11, 1, visitor5)
			return visitor5(node11)
		end
	else
		return error_21_1(_2e2e_1("Unknown tag ", tag5))
	end
end)
traverseBlock1 = (function(node12, start2, visitor6)
	local offset1 = 0
	local r_1601 = _23_1(node12)
	local r_1611 = 1
	local r_1581 = nil
	r_1581 = (function(r_1591)
		local temp30
		if (0 < 1) then
			temp30 = (r_1591 <= r_1601)
		else
			temp30 = (r_1591 >= r_1601)
		end
		if temp30 then
			local i7 = r_1591
			local result1 = traverseNode1(nth1(node12, (i7 + offset1)), visitor6)
			node12[i7] = result1
			return r_1581((r_1591 + r_1611))
		else
		end
	end)
	r_1581(start2)
	return node12
end)
traverseList1 = (function(node13, start3, visitor7)
	local r_1641 = _23_1(node13)
	local r_1651 = 1
	local r_1621 = nil
	r_1621 = (function(r_1631)
		local temp31
		if (0 < 1) then
			temp31 = (r_1631 <= r_1641)
		else
			temp31 = (r_1631 >= r_1641)
		end
		if temp31 then
			local i8 = r_1631
			node13[i8] = traverseNode1(nth1(node13, i8), visitor7)
			return r_1621((r_1631 + r_1651))
		else
		end
	end)
	r_1621(start3)
	return node13
end)
builtins4 = require1("tacky.analysis.resolve")["builtins"]
builtinVars1 = require1("tacky.analysis.resolve")["declaredVars"]
hasSideEffect1 = (function(node14)
	local tag6 = type1(node14)
	local temp32
	local r_821 = (tag6 == "number")
	if r_821 then
		temp32 = r_821
	else
		local r_831 = (tag6 == "string")
		if r_831 then
			temp32 = r_831
		else
			local r_841 = (tag6 == "key")
			if r_841 then
				temp32 = r_841
			else
				temp32 = (tag6 == "symbol")
			end
		end
	end
	if temp32 then
		return false
	elseif (tag6 == "list") then
		local fst1 = car2(node14)
		if (type1(fst1) == "symbol") then
			local var5 = fst1["var"]
			local r_851 = (var5 ~= builtins4["lambda"])
			if r_851 then
				return (var5 ~= builtins4["quote"])
			else
				return r_851
			end
		else
			return true
		end
	else
		_error("unmatched item")
	end
end)
truthy_3f_1 = (function(node15)
	local temp33
	local r_861 = string_3f_1(node15)
	if r_861 then
		temp33 = r_861
	else
		local r_871 = key_3f_1(node15)
		if r_871 then
			temp33 = r_871
		else
			temp33 = number_3f_1(node15)
		end
	end
	if temp33 then
		return true
	elseif symbol_3f_1(node15) then
		return (builtinVars1["true"] == node15["var"])
	else
		return false
	end
end)
makeProgn1 = (function(body1)
	local lambda1 = struct1("tag", "symbol", "contents", "lambda", "var", builtins4["lambda"])
	return {tag = "list", n =1, (function()
		local _offset, _result, _temp = 0, {tag="list",n=0}
		_result[1 + _offset] = lambda1
		_result[2 + _offset] = {tag = "list", n =0}
		_temp = body1
		for _c = 1, _temp.n do _result[2 + _c + _offset] = _temp[_c] end
		_offset = _offset + _temp.n
		_result.n = _offset + 2
		return _result
	end)()
	}
end)
optimiseOnce1 = (function(nodes3)
	local changed1 = false
	local r_901 = 1
	local r_911 = -1
	local r_881 = nil
	r_881 = (function(r_891)
		local temp34
		if (0 < -1) then
			temp34 = (r_891 <= r_901)
		else
			temp34 = (r_891 >= r_901)
		end
		if temp34 then
			local i9 = r_891
			local node16 = nth1(nodes3, i9)
			local temp35
			local r_921 = list_3f_1(node16)
			if r_921 then
				local r_931 = (_23_1(node16) > 0)
				if r_931 then
					local r_941 = symbol_3f_1(car2(node16))
					if r_941 then
						temp35 = (car2(node16)["var"] == builtins4["import"])
					else
						temp35 = r_941
					end
				else
					temp35 = r_931
				end
			else
				temp35 = r_921
			end
			if temp35 then
				if (i9 == _23_1(nodes3)) then
					nodes3[i9] = struct1("tag", "symbol", "contents", "nil", "var", builtinVars1["nil"])
				else
					removeNth_21_1(nodes3, i9)
				end
				changed1 = true
			else
			end
			return r_881((r_891 + r_911))
		else
		end
	end)
	r_881(_23_1(nodes3))
	local r_971 = 1
	local r_981 = -1
	local r_951 = nil
	r_951 = (function(r_961)
		local temp36
		if (0 < -1) then
			temp36 = (r_961 <= r_971)
		else
			temp36 = (r_961 >= r_971)
		end
		if temp36 then
			local i10 = r_961
			local node17 = nth1(nodes3, i10)
			if _21_1(hasSideEffect1(node17)) then
				removeNth_21_1(nodes3, i10)
				changed1 = true
			else
			end
			return r_951((r_961 + r_981))
		else
		end
	end)
	r_951(pred1(_23_1(nodes3)))
	traverseList1(nodes3, 1, (function(node18)
		local temp37
		local r_1881 = list_3f_1(node18)
		if r_1881 then
			local r_1891 = symbol_3f_1(car2(node18))
			if r_1891 then
				temp37 = (car2(node18)["var"] == builtins4["cond"])
			else
				temp37 = r_1891
			end
		else
			temp37 = r_1881
		end
		if temp37 then
			local final1 = nil
			local r_1921 = _23_1(node18)
			local r_1931 = 1
			local r_1901 = nil
			r_1901 = (function(r_1911)
				local temp38
				if (0 < 1) then
					temp38 = (r_1911 <= r_1921)
				else
					temp38 = (r_1911 >= r_1921)
				end
				if temp38 then
					local i11 = r_1911
					local case3 = nth1(node18, i11)
					if final1 then
						changed1 = true
						removeNth_21_1(node18, final1)
					elseif truthy_3f_1(car2(nth1(node18, i11))) then
						final1 = succ1(i11)
					else
					end
					return r_1901((r_1911 + r_1931))
				else
				end
			end)
			r_1901(2)
			local temp39
			local r_1941 = (_23_1(node18) == 2)
			if r_1941 then
				temp39 = truthy_3f_1(car2(nth1(node18, 2)))
			else
				temp39 = r_1941
			end
			if temp39 then
				changed1 = true
				local body2 = cdr2(nth1(node18, 2))
				if (_23_1(body2) == 1) then
					return car2(body2)
				else
					return makeProgn1(cdr2(nth1(node18, 2)))
				end
			else
				return node18
			end
		else
			return node18
		end
	end))
	local lookup1 = createState1()
	definitionsVisit1(lookup1, nodes3)
	usagesVisit1(lookup1, nodes3, hasSideEffect1)
	local r_1971 = 1
	local r_1981 = -1
	local r_1951 = nil
	r_1951 = (function(r_1961)
		local temp40
		if (0 < -1) then
			temp40 = (r_1961 <= r_1971)
		else
			temp40 = (r_1961 >= r_1971)
		end
		if temp40 then
			local i12 = r_1961
			local node19 = nth1(nodes3, i12)
			local temp41
			local r_1991 = node19["defVar"]
			if r_1991 then
				temp41 = _21_1(getVar1(lookup1, node19["defVar"])["active"])
			else
				temp41 = r_1991
			end
			if temp41 then
				if (i12 == _23_1(nodes3)) then
					nodes3[i12] = struct1("tag", "symbol", "contents", "nil", "var", builtinVars1["nil"])
				else
					removeNth_21_1(nodes3, i12)
				end
				changed1 = true
			else
			end
			return r_1951((r_1961 + r_1981))
		else
		end
	end)
	r_1951(_23_1(nodes3))
	return changed1
end)
optimise1 = (function(nodes4)
	local iteration1 = 0
	local changed2 = true
	local r_991 = nil
	r_991 = (function()
		local temp42
		local r_1001 = changed2
		if r_1001 then
			temp42 = (iteration1 < 10)
		else
			temp42 = r_1001
		end
		if temp42 then
			changed2 = optimiseOnce1(nodes4)
			iteration1 = (iteration1 + 1)
			return r_991()
		else
		end
	end)
	r_991()
	return nodes4
end)
return optimise1
