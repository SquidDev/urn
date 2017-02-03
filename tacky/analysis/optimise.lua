if not table.pack then table.pack = function(...) return { n = select("#", ...), ... } end end
if not table.unpack then table.unpack = unpack end
if _VERSION:find("5.1") then local function load(x, _, _, env) local f, e = loadstring(x); if not f then error(e, 1) end; return setfenv(f, env) end end
local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error
local _libs = {}
local _temp = (function()
	-- base is an internal version of core methods without any extensions or assertions.
	-- You should not use this unless you are building core libraries.
	-- Native methods in base should do the bare minimum: you should try to move as much
	-- as possible to Urn
	local pprint = require "tacky.pprint"
	local randCtr = 0
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
		['get-idx'] = rawget,
		['set-idx!'] = rawset,
		['remove-idx!'] = table.remove,
		['slice'] = function(xs, start, finish)
			if not finish then finish = xs.n end
			return { tag = "list", n = finish - start + 1, table.unpack(xs, start, finish) }
		end,
		['print!'] = print,
		['pretty'] = function (x) return pprint.tostring(x, pprint.nodeConfig) end,
		['error!'] = error,
		['type#'] = type,
		['empty-struct'] = function() return {} end,
		['format'] = string.format,
		['xpcall'] = xpcall,
		['traceback'] = debug.traceback,
		['require'] = require,
		['string->number'] = tonumber,
		['number->string'] = tostring,
		['clock'] = os.clock,
		['exit'] = os.exit,
		['unpack'] = function(li) return table.unpack(li, 1, li.n) end,
		['gensym'] = function(name)
			if name then
				name = "_" .. tostring(name)
			else
				name = ""
			end
			randCtr = randCtr + 1
			return { tag = "symbol", contents = ("r_%d%s"):format(randCtr, name) }
		end,
		_G = _G, _ENV = _ENV
	}
end)()
for k, v in pairs(_temp) do _libs[k] = v end
local _temp = (function()
	return {
		byte    = string.byte,
		char    = string.char,
		concat  = table.concat,
		find    = function(text, pattern, offset, plaintext)
			local start, finish = string.find(text, pattern, offset, plaintext)
			if start then
				return { tag = "list", n = 2, start, finish }
			else
				return nil
			end
		end,
		format  = string.format,
		lower   = string.lower,
		reverse = string.reverse,
		rep     = string.rep,
		replace = string.gsub,
		sub     = string.sub,
		upper   = string.upper,
		['#s']   = string.len,
	}
end)()
for k, v in pairs(_temp) do _libs[k] = v end
local _temp = (function()
	return {
	  getmetatable = getmetatable,
	  setmetatable = setmetatable,
	  ['iter-pairs'] = function(tbl, fun) for k, v in pairs(tbl) do fun(k, v) end end, -- TODO: Migrate to Urn somehow
	  next = next,
	}
end)()
for k, v in pairs(_temp) do _libs[k] = v end
local _temp = (function()
	return io
end)()
for k, v in pairs(_temp) do _libs[k] = v end

_3d_1 = _libs["="]
_2f3d_1 = _libs["/="]
_3c_1 = _libs["<"]
_3c3d_1 = _libs["<="]
_3e_1 = _libs[">"]
_3e3d_1 = _libs[">="]
_2b_1 = _libs["+"]
_2d_1 = _libs["-"]
_25_1 = _libs["%"]
_2e2e_1 = _libs[".."]
getIdx1 = _libs["get-idx"]
setIdx_21_1 = _libs["set-idx!"]
removeIdx_21_1 = _libs["remove-idx!"]
format1 = _libs["format"]
error_21_1 = _libs["error!"]
type_23_1 = _libs["type#"]
emptyStruct1 = _libs["empty-struct"]
require1 = _libs["require"]
_23_1 = (function(xs1)
	return xs1["n"]
end)
_21_1 = (function(expr1)
	if expr1 then
		return false
	else
		return true
	end
end)
list_3f_1 = (function(x1)
	return (type1(x1) == "list")
end)
symbol_3f_1 = (function(x2)
	return (type1(x2) == "symbol")
end)
key_3f_1 = (function(x3)
	return (type1(x3) == "key")
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
nth1 = (function(li1, idx1)
	local r_121 = type1(li1)
	if (r_121 ~= "list") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_121), 2)
	else
	end
	local r_271 = type1(idx1)
	if (r_271 ~= "number") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "idx", "number", r_271), 2)
	else
	end
	return li1[idx1]
end)
setNth_21_1 = (function(li2, idx2, val2)
	local r_131 = type1(li2)
	if (r_131 ~= "list") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_131), 2)
	else
	end
	local r_281 = type1(idx2)
	if (r_281 ~= "number") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "idx", "number", r_281), 2)
	else
	end
	li2[idx2] = val2
	return nil
end)
removeNth_21_1 = (function(li3, idx3)
	local r_141 = type1(li3)
	if (r_141 ~= "list") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_141), 2)
	else
	end
	local r_291 = type1(idx3)
	if (r_291 ~= "number") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "idx", "number", r_291), 2)
	else
	end
	li3["n"] = (li3["n"] - 1)
	return removeIdx_21_1(li3, idx3)
end)
_23_2 = (function(li4)
	local r_151 = type1(li4)
	if (r_151 ~= "list") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_151), 2)
	else
	end
	return _23_1(li4)
end)
car1 = (function(li5)
	return nth1(li5, 1)
end)
pushCdr_21_1 = (function(li6, val3)
	local r_181 = type1(li6)
	if (r_181 ~= "list") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_181), 2)
	else
	end
	local len1 = (_23_1(li6) + 1)
	li6["n"] = len1
	li6[len1] = val3
	return li6
end)
sub1 = _libs["sub"]
iterPairs1 = _libs["iter-pairs"]
struct1 = (function(...)
	local keys1 = _pack(...) keys1.tag = "list"
	if ((_23_2(keys1) % 1) == 1) then
		error_21_1("Expected an even number of arguments to struct", 2)
	else
	end
	local contents1 = (function(key1)
		return sub1(key1["contents"], 2)
	end)
	local out1 = {}
	local r_661 = _23_1(keys1)
	local r_671 = 2
	local r_641 = nil
	r_641 = (function(r_651)
		local _temp
		if (0 < 2) then
			_temp = (r_651 <= r_661)
		else
			_temp = (r_651 >= r_661)
		end
		if _temp then
			local i1 = r_651
			local key2 = keys1[i1]
			local val4 = keys1[(1 + i1)]
			out1[(function()
				if key_3f_1(key2) then
					return contents1(key2)
				else
					return key2
				end
			end)()
			] = val4
			return r_641((r_651 + r_671))
		else
		end
	end)
	r_641(1)
	return out1
end)
fail1 = (function(msg1)
	return error_21_1(msg1, 0)
end)
succ1 = (function(x4)
	return (1 + x4)
end)
pred1 = (function(x5)
	return (x5 - 1)
end)
builtins1 = require1("tacky.analysis.resolve")["builtins"]
visitQuote1 = (function(node1, visitor1, level1)
	if (level1 == 0) then
		return visitNode1(node1, visitor1)
	else
		local tag2 = node1["tag"]
		local _temp
		local r_1251 = (tag2 == "string")
		if r_1251 then
			_temp = r_1251
		else
			local r_1261 = (tag2 == "number")
			if r_1261 then
				_temp = r_1261
			else
				local r_1271 = (tag2 == "key")
				if r_1271 then
					_temp = r_1271
				else
					_temp = (tag2 == "symbol")
				end
			end
		end
		if _temp then
			return nil
		elseif (tag2 == "list") then
			local first1 = nth1(node1, 1)
			local _temp
			local r_1281 = first1
			if r_1281 then
				_temp = (first1["tag"] == "symbol")
			else
				_temp = r_1281
			end
			if _temp then
				local _temp
				local r_1291 = (first1["contents"] == "unquote")
				if r_1291 then
					_temp = r_1291
				else
					_temp = (first1["contents"] == "unquote-splice")
				end
				if _temp then
					return visitQuote1(nth1(node1, 2), visitor1, pred1(level1))
				elseif (first1["contents"] == "quasiquote") then
					return visitQuote1(nth1(node1, 2), visitor1, succ1(level1))
				else
					local r_1311 = node1
					local r_1341 = _23_2(r_1311)
					local r_1351 = 1
					local r_1321 = nil
					r_1321 = (function(r_1331)
						local _temp
						if (0 < 1) then
							_temp = (r_1331 <= r_1341)
						else
							_temp = (r_1331 >= r_1341)
						end
						if _temp then
							local r_1301 = r_1331
							local sub2 = r_1311[r_1301]
							visitQuote1(sub2, visitor1, level1)
							return r_1321((r_1331 + r_1351))
						else
						end
					end)
					return r_1321(1)
				end
			else
				local r_1371 = node1
				local r_1401 = _23_2(r_1371)
				local r_1411 = 1
				local r_1381 = nil
				r_1381 = (function(r_1391)
					local _temp
					if (0 < 1) then
						_temp = (r_1391 <= r_1401)
					else
						_temp = (r_1391 >= r_1401)
					end
					if _temp then
						local r_1361 = r_1391
						local sub3 = r_1371[r_1361]
						visitQuote1(sub3, visitor1, level1)
						return r_1381((r_1391 + r_1411))
					else
					end
				end)
				return r_1381(1)
			end
		elseif error_21_1 then
			return ("Unknown tag " .. tag2)
		else
			_error("unmatched item")
		end
	end
end)
visitNode1 = (function(node2, visitor2)
	if (visitor2(node2) == false) then
	else
		local tag3 = node2["tag"]
		local _temp
		local r_1421 = (tag3 == "string")
		if r_1421 then
			_temp = r_1421
		else
			local r_1431 = (tag3 == "number")
			if r_1431 then
				_temp = r_1431
			else
				local r_1441 = (tag3 == "key")
				if r_1441 then
					_temp = r_1441
				else
					_temp = (tag3 == "symbol")
				end
			end
		end
		if _temp then
			return nil
		elseif (tag3 == "list") then
			local first2 = nth1(node2, 1)
			local _temp
			local r_1451 = first2
			if r_1451 then
				_temp = (first2["tag"] == "symbol")
			else
				_temp = r_1451
			end
			if _temp then
				local func1 = first2["var"]
				local funct1 = func1["tag"]
				if (func1 == builtins1["lambda"]) then
					return visitBlock1(node2, 3, visitor2)
				elseif (func1 == builtins1["cond"]) then
					local r_1481 = _23_2(node2)
					local r_1491 = 1
					local r_1461 = nil
					r_1461 = (function(r_1471)
						local _temp
						if (0 < 1) then
							_temp = (r_1471 <= r_1481)
						else
							_temp = (r_1471 >= r_1481)
						end
						if _temp then
							local i2 = r_1471
							local case1 = nth1(node2, i2)
							visitNode1(nth1(case1, 1), visitor2)
							visitBlock1(case1, 2, visitor2)
							return r_1461((r_1471 + r_1491))
						else
						end
					end)
					return r_1461(2)
				elseif (func1 == builtins1["set!"]) then
					return visitNode1(nth1(node2, 3), visitor2)
				elseif (func1 == builtins1["quote"]) then
				elseif (func1 == builtins1["quasiquote"]) then
					return visitQuote1(nth1(node2, 2), visitor2, 1)
				else
					local _temp
					local r_1501 = (func1 == builtins1["unquote"])
					if r_1501 then
						_temp = r_1501
					else
						_temp = (func1 == builtins1["unquote-splice"])
					end
					if _temp then
						return fail1("unquote/unquote-splice should never appear head")
					else
						local _temp
						local r_1511 = (func1 == builtins1["define"])
						if r_1511 then
							_temp = r_1511
						else
							_temp = (func1 == builtins1["define-macro"])
						end
						if _temp then
							return visitBlock1(node2, 3, visitor2)
						elseif (func1 == builtins1["define-native"]) then
						elseif (func1 == builtins1["import"]) then
						elseif (funct1 == "macro") then
							return fail1("Macros should have been expanded")
						else
							local _temp
							local r_1521 = (funct1 == "defined")
							if r_1521 then
								_temp = r_1521
							else
								local r_1531 = (funct1 == "arg")
								if r_1531 then
									_temp = r_1531
								else
									_temp = (funct1 == "native")
								end
							end
							if _temp then
								return visitBlock1(node2, 1, visitor2)
							else
								return fail1(_2e2e_1("Unknown kind ", funct1, " for variable ", func1["name"]))
							end
						end
					end
				end
			else
				return visitBlock1(node2, 1, visitor2)
			end
		else
			return error_21_1(("Unknown tag " .. tag3))
		end
	end
end)
visitBlock1 = (function(node3, start1, visitor3)
	local r_1231 = _23_2(node3)
	local r_1241 = 1
	local r_1211 = nil
	r_1211 = (function(r_1221)
		local _temp
		if (0 < 1) then
			_temp = (r_1221 <= r_1231)
		else
			_temp = (r_1221 >= r_1231)
		end
		if _temp then
			local i3 = r_1221
			visitNode1(nth1(node3, i3), visitor3)
			return r_1211((r_1221 + r_1241))
		else
		end
	end)
	return r_1211(start1)
end)
struct1("visitNode", visitNode1, "visitBlock", visitBlock1, "visitList", visitBlock1)
builtins2 = require1("tacky.analysis.resolve")["builtins"]
createState1 = (function()
	return struct1("vars", {}, "nodes", {})
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
		if nodeMeta2["definesr"] then
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
	local _temp
	local r_1121 = list_3f_1(node7)
	if r_1121 then
		local r_1131 = (_23_2(node7) > 0)
		if r_1131 then
			_temp = symbol_3f_1(car1(node7))
		else
			_temp = r_1131
		end
	else
		_temp = r_1121
	end
	if _temp then
		local func2 = car1(node7)["var"]
		if (func2 == builtins2["lambda"]) then
			local r_1151 = nth1(node7, 2)
			local r_1181 = _23_2(r_1151)
			local r_1191 = 1
			local r_1161 = nil
			r_1161 = (function(r_1171)
				local _temp
				if (0 < 1) then
					_temp = (r_1171 <= r_1181)
				else
					_temp = (r_1171 >= r_1181)
				end
				if _temp then
					local r_1141 = r_1171
					local arg1 = r_1151[r_1141]
					addDefinition_21_1(state5, arg1["var"], arg1, "arg", arg1)
					return r_1161((r_1171 + r_1191))
				else
				end
			end)
			return r_1161(1)
		elseif (func2 == builtins2["set!"]) then
			return addDefinition_21_1(state5, node7[2]["var"], node7, "set", nth1(node7, 3))
		else
			local _temp
			local r_1201 = (func2 == builtins2["define"])
			if r_1201 then
				_temp = r_1201
			else
				_temp = (func2 == builtins2["define-macro"])
			end
			if _temp then
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
	return visitBlock1(nodes1, 1, (function(r_1661)
		return definitionsVisitor1(state6, r_1661)
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
	local visited1 = {}
	local addUsage1 = (function(var4, user1)
		addUsage_21_1(state7, var4, user1)
		local varMeta3 = getVar1(state7, var4)
		if varMeta3["active"] then
			return iterPairs1(varMeta3["defs"], (function(_5f_1, def1)
				local val5 = def1["value"]
				local _temp
				local r_1651 = val5
				if r_1651 then
					_temp = _21_1(visited1[val5])
				else
					_temp = r_1651
				end
				if _temp then
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
				local _temp
				local r_1611 = list_3f_1(node8)
				if r_1611 then
					local r_1621 = (_23_2(node8) > 0)
					if r_1621 then
						_temp = symbol_3f_1(car1(node8))
					else
						_temp = r_1621
					end
				else
					_temp = r_1611
				end
				if _temp then
					local func3 = car1(node8)["var"]
					local _temp
					local r_1631 = (func3 == builtins2["set!"])
					if r_1631 then
						_temp = r_1631
					else
						local r_1641 = (func3 == builtins2["define"])
						if r_1641 then
							_temp = r_1641
						else
							_temp = (func3 == builtins2["define-macro"])
						end
					end
					if _temp then
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
	local r_1551 = nodes2
	local r_1581 = _23_2(r_1551)
	local r_1591 = 1
	local r_1561 = nil
	r_1561 = (function(r_1571)
		local _temp
		if (0 < 1) then
			_temp = (r_1571 <= r_1581)
		else
			_temp = (r_1571 >= r_1581)
		end
		if _temp then
			local r_1541 = r_1571
			local node9 = r_1551[r_1541]
			pushCdr_21_1(queue1, node9)
			return r_1561((r_1571 + r_1591))
		else
		end
	end)
	r_1561(1)
	local r_1601 = nil
	r_1601 = (function()
		if (_23_2(queue1) > 0) then
			visitNode1(removeNth_21_1(queue1, 1), visit1)
			return r_1601()
		else
		end
	end)
	return r_1601()
end)
builtins3 = require1("tacky.analysis.resolve")["builtins"]
builtinVars1 = require1("tacky.analysis.resolve")["declaredVars"]
hasSideEffect1 = (function(node10)
	local tag4 = type1(node10)
	local _temp
	local r_971 = (tag4 == "number")
	if r_971 then
		_temp = r_971
	else
		local r_981 = (tag4 == "string")
		if r_981 then
			_temp = r_981
		else
			local r_991 = (tag4 == "key")
			if r_991 then
				_temp = r_991
			else
				_temp = (tag4 == "symbol")
			end
		end
	end
	if _temp then
		return false
	elseif (tag4 == "list") then
		local fst1 = car1(node10)
		if (type1(fst1) == "symbol") then
			local var5 = fst1["var"]
			local r_1001 = (var5 ~= builtins3["lambda"])
			if r_1001 then
				return (var5 ~= builtins3["quote"])
			else
				return r_1001
			end
		else
			return true
		end
	else
		_error("unmatched item")
	end
end)
optimise1 = (function(nodes3)
	local r_1031 = 1
	local r_1041 = -1
	local r_1011 = nil
	r_1011 = (function(r_1021)
		local _temp
		if (0 < -1) then
			_temp = (r_1021 <= r_1031)
		else
			_temp = (r_1021 >= r_1031)
		end
		if _temp then
			local i4 = r_1021
			local node11 = nth1(nodes3, i4)
			local _temp
			local r_1051 = list_3f_1(node11)
			if r_1051 then
				local r_1061 = (_23_2(node11) > 0)
				if r_1061 then
					local r_1071 = symbol_3f_1(car1(node11))
					if r_1071 then
						_temp = (car1(node11)["var"] == builtins3["import"])
					else
						_temp = r_1071
					end
				else
					_temp = r_1061
				end
			else
				_temp = r_1051
			end
			if _temp then
				if (i4 == _23_2(nodes3)) then
					setNth_21_1(nodes3, i4, struct1("tag", "symbol", "contents", "nil", "var", builtinVars1["nil"]))
				else
					removeNth_21_1(nodes3, i4)
				end
			else
			end
			return r_1011((r_1021 + r_1041))
		else
		end
	end)
	r_1011(_23_2(nodes3))
	local r_1101 = 1
	local r_1111 = -1
	local r_1081 = nil
	r_1081 = (function(r_1091)
		local _temp
		if (0 < -1) then
			_temp = (r_1091 <= r_1101)
		else
			_temp = (r_1091 >= r_1101)
		end
		if _temp then
			local i5 = r_1091
			local node12 = nth1(nodes3, i5)
			if _21_1(hasSideEffect1(node12)) then
				removeNth_21_1(nodes3, i5)
			else
			end
			return r_1081((r_1091 + r_1111))
		else
		end
	end)
	r_1081(pred1(_23_2(nodes3)))
	local lookup1 = createState1()
	definitionsVisit1(lookup1, nodes3)
	usagesVisit1(lookup1, nodes3, hasSideEffect1)
	local r_1691 = 1
	local r_1701 = -1
	local r_1671 = nil
	r_1671 = (function(r_1681)
		local _temp
		if (0 < -1) then
			_temp = (r_1681 <= r_1691)
		else
			_temp = (r_1681 >= r_1691)
		end
		if _temp then
			local i6 = r_1681
			local node13 = nth1(nodes3, i6)
			local _temp
			local r_1711 = node13["defVar"]
			if r_1711 then
				_temp = _21_1(getVar1(lookup1, node13["defVar"])["active"])
			else
				_temp = r_1711
			end
			if _temp then
				if (i6 == _23_2(nodes3)) then
					setNth_21_1(nodes3, i6, struct1("tag", "symbol", "contents", "nil", "var", builtinVars1["nil"]))
				else
					removeNth_21_1(nodes3, i6)
				end
			else
			end
			return r_1671((r_1681 + r_1701))
		else
		end
	end)
	r_1671(_23_2(nodes3))
	return nodes3
end)
return optimise1
