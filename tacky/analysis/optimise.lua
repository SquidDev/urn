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
	  setmetatable = setmetatable
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
	local ty1
	ty1 = type_23_1(val1)
	if (ty1 == "table") then
		local tag1
		tag1 = val1["tag"]
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
	local r_121
	r_121 = type1(li1)
	if (r_121 ~= "list") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_121), 2)
	else
	end
	local r_271
	r_271 = type1(idx1)
	if (r_271 ~= "number") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "idx", "number", r_271), 2)
	else
	end
	return li1[idx1]
end)
setNth_21_1 = (function(li2, idx2, val2)
	local r_131
	r_131 = type1(li2)
	if (r_131 ~= "list") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_131), 2)
	else
	end
	local r_281
	r_281 = type1(idx2)
	if (r_281 ~= "number") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "idx", "number", r_281), 2)
	else
	end
	li2[idx2] = val2
	return nil
end)
removeNth_21_1 = (function(li3, idx3)
	local r_141
	r_141 = type1(li3)
	if (r_141 ~= "list") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_141), 2)
	else
	end
	local r_291
	r_291 = type1(idx3)
	if (r_291 ~= "number") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "idx", "number", r_291), 2)
	else
	end
	li3["n"] = (li3["n"] - 1)
	return removeIdx_21_1(li3, idx3)
end)
_23_2 = (function(li4)
	local r_151
	r_151 = type1(li4)
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
	local r_181
	r_181 = type1(li6)
	if (r_181 ~= "list") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_181), 2)
	else
	end
	local len1
	len1 = (_23_1(li6) + 1)
	li6["n"] = len1
	li6[len1] = val3
	return li6
end)
sub1 = _libs["sub"]
struct1 = (function(...)
	local keys1 = _pack(...) keys1.tag = "list"
	if ((_23_2(keys1) % 1) == 1) then
		error_21_1("Expected an even number of arguments to struct", 2)
	else
	end
	local contents1, out1
	contents1 = (function(key1)
		return sub1(key1["contents"], 2)
	end)
	out1 = {}
	local r_661
	r_661 = _23_1(keys1)
	local r_671
	r_671 = 2
	local r_641
	r_641 = nil
	r_641 = (function(r_651)
		if (function()
			if (0 < 2) then
				return (r_651 <= r_661)
			else
				return (r_651 >= r_661)
			end
		end)()
		 then
			local i1
			i1 = r_651
			local key2, val4
			key2 = keys1[i1]
			val4 = keys1[(1 + i1)]
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
		local tag2
		tag2 = node1["tag"]
		if (function(r_1281)
			if r_1281 then
				return r_1281
			else
				local r_1291
				r_1291 = (tag2 == "number")
				if r_1291 then
					return r_1291
				else
					local r_1301
					r_1301 = (tag2 == "key")
					if r_1301 then
						return r_1301
					else
						return (tag2 == "symbol")
					end
				end
			end
		end)
		((tag2 == "string")) then
			return nil
		elseif (tag2 == "list") then
			local first1
			first1 = nth1(node1, 1)
			if (function(r_1311)
				if r_1311 then
					return (first1["tag"] == "symbol")
				else
					return r_1311
				end
			end)
			(first1) then
				if (function(r_1321)
					if r_1321 then
						return r_1321
					else
						return (first1["contents"] == "unquote-splice")
					end
				end)
				((first1["contents"] == "unquote")) then
					return visitQuote1(nth1(node1, 2), visitor1, pred1(level1))
				elseif (first1["contents"] == "quasiquote") then
					return visitQuote1(nth1(node1, 2), visitor1, succ1(level1))
				else
					local r_1341
					r_1341 = node1
					local r_1371
					r_1371 = _23_2(r_1341)
					local r_1381
					r_1381 = 1
					local r_1351
					r_1351 = nil
					r_1351 = (function(r_1361)
						if (function()
							if (0 < 1) then
								return (r_1361 <= r_1371)
							else
								return (r_1361 >= r_1371)
							end
						end)()
						 then
							local r_1331
							r_1331 = r_1361
							local sub2
							sub2 = r_1341[r_1331]
							visitQuote1(sub2, visitor1, level1)
							return r_1351((r_1361 + r_1381))
						else
						end
					end)
					return r_1351(1)
				end
			else
				local r_1401
				r_1401 = node1
				local r_1431
				r_1431 = _23_2(r_1401)
				local r_1441
				r_1441 = 1
				local r_1411
				r_1411 = nil
				r_1411 = (function(r_1421)
					if (function()
						if (0 < 1) then
							return (r_1421 <= r_1431)
						else
							return (r_1421 >= r_1431)
						end
					end)()
					 then
						local r_1391
						r_1391 = r_1421
						local sub3
						sub3 = r_1401[r_1391]
						visitQuote1(sub3, visitor1, level1)
						return r_1411((r_1421 + r_1441))
					else
					end
				end)
				return r_1411(1)
			end
		elseif error_21_1 then
			return ("Unknown tag " .. tag2)
		else
			_error("unmatched item")end
		end
	end)
	visitNode1 = (function(node2, visitor2)
		if (visitor2(node2) == false) then
		else
			local tag3
			tag3 = node2["tag"]
			if (function(r_1451)
				if r_1451 then
					return r_1451
				else
					local r_1461
					r_1461 = (tag3 == "number")
					if r_1461 then
						return r_1461
					else
						local r_1471
						r_1471 = (tag3 == "key")
						if r_1471 then
							return r_1471
						else
							return (tag3 == "symbol")
						end
					end
				end
			end)
			((tag3 == "string")) then
				return nil
			elseif (tag3 == "list") then
				local first2
				first2 = nth1(node2, 1)
				if (function(r_1481)
					if r_1481 then
						return (first2["tag"] == "symbol")
					else
						return r_1481
					end
				end)
				(first2) then
					local func1
					func1 = first2["var"]
					local funct1
					funct1 = func1["tag"]
					if (func1 == builtins1["lambda"]) then
						return visitBlock1(node2, 3, visitor2)
					elseif (func1 == builtins1["cond"]) then
						local r_1511
						r_1511 = _23_2(node2)
						local r_1521
						r_1521 = 1
						local r_1491
						r_1491 = nil
						r_1491 = (function(r_1501)
							if (function()
								if (0 < 1) then
									return (r_1501 <= r_1511)
								else
									return (r_1501 >= r_1511)
								end
							end)()
							 then
								local i2
								i2 = r_1501
								local case1
								case1 = nth1(node2, i2)
								visitNode1(nth1(case1, 1), visitor2)
								visitBlock1(case1, 2, visitor2)
								return r_1491((r_1501 + r_1521))
							else
							end
						end)
						return r_1491(2)
					elseif (func1 == builtins1["set!"]) then
						return visitNode1(nth1(node2, 3), visitor2)
					elseif (func1 == builtins1["quote"]) then
					elseif (func1 == builtins1["quasiquote"]) then
						return visitQuote1(nth1(node2, 2), visitor2, 1)
					elseif (function(r_1531)
						if r_1531 then
							return r_1531
						else
							return (func1 == builtins1["unquote-splice"])
						end
					end)
					((func1 == builtins1["unquote"])) then
						return fail1("unquote/unquote-splice should never appear head")
					elseif (function(r_1541)
						if r_1541 then
							return r_1541
						else
							return (func1 == builtins1["define-macro"])
						end
					end)
					((func1 == builtins1["define"])) then
						return visitBlock1(node2, 3, visitor2)
					elseif (func1 == builtins1["define-native"]) then
					elseif (func1 == builtins1["import"]) then
					elseif (funct1 == "macro") then
						return fail1("Macros should have been expanded")
					elseif (function(r_1551)
						if r_1551 then
							return r_1551
						else
							local r_1561
							r_1561 = (funct1 == "arg")
							if r_1561 then
								return r_1561
							else
								return (funct1 == "native")
							end
						end
					end)
					((funct1 == "defined")) then
						return visitBlock1(node2, 1, visitor2)
					else
						return fail1(_2e2e_1("Unknown kind ", funct1, " for variable ", func1["name"]))
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
		local r_1261
		r_1261 = _23_2(node3)
		local r_1271
		r_1271 = 1
		local r_1241
		r_1241 = nil
		r_1241 = (function(r_1251)
			if (function()
				if (0 < 1) then
					return (r_1251 <= r_1261)
				else
					return (r_1251 >= r_1261)
				end
			end)()
			 then
				local i3
				i3 = r_1251
				visitNode1(nth1(node3, i3), visitor3)
				return r_1241((r_1251 + r_1271))
			else
			end
		end)
		return r_1241(start1)
	end)
	struct1("visitNode", visitNode1, "visitBlock", visitBlock1, "visitList", visitBlock1)
	builtins2 = require1("tacky.analysis.resolve")["builtins"]
	builtinVars1 = require1("tacky.analysis.resolve")["declaredVars"]
	hasSideEffect1 = (function(node4)
		local tag4
		tag4 = type1(node4)
		if (function(r_971)
			if r_971 then
				return r_971
			else
				local r_981
				r_981 = (tag4 == "string")
				if r_981 then
					return r_981
				else
					local r_991
					r_991 = (tag4 == "key")
					if r_991 then
						return r_991
					else
						return (tag4 == "symbol")
					end
				end
			end
		end)
		((tag4 == "number")) then
			return false
		elseif (tag4 == "list") then
			local fst1
			fst1 = car1(node4)
			if (type1(fst1) == "symbol") then
				local var1
				var1 = fst1["var"]
				local r_1001
				r_1001 = (var1 ~= builtins2["lambda"])
				if r_1001 then
					return (var1 ~= builtins2["quote"])
				else
					return r_1001
				end
			else
				return true
			end
		else
			_error("unmatched item")end
		end)
		getVarEntry1 = (function(lookup1, var2)
			local entry1
			entry1 = lookup1[var2]
			if entry1 then
			else
				entry1 = struct1("var", var2, "usages", {tag = "list", n =0}, "defs", {tag = "list", n =0}, "active", false)
				lookup1[var2] = entry1
			end
			return entry1
		end)
		gatherDefinitions1 = (function(nodes1, lookup2)
			local addDefinition1
			addDefinition1 = (function(var3, def1)
				return pushCdr_21_1(getVarEntry1(lookup2, var3)["defs"], def1)
			end)
			return visitBlock1(nodes1, 1, (function(node5)
				if (function(r_1571)
					if r_1571 then
						local r_1581
						r_1581 = (_23_2(node5) > 0)
						if r_1581 then
							return symbol_3f_1(car1(node5))
						else
							return r_1581
						end
					else
						return r_1571
					end
				end)
				(list_3f_1(node5)) then
					local func2
					func2 = car1(node5)["var"]
					if (func2 == builtins2["lambda"]) then
						local r_1601
						r_1601 = nth1(node5, 2)
						local r_1631
						r_1631 = _23_2(r_1601)
						local r_1641
						r_1641 = 1
						local r_1611
						r_1611 = nil
						r_1611 = (function(r_1621)
							if (function()
								if (0 < 1) then
									return (r_1621 <= r_1631)
								else
									return (r_1621 >= r_1631)
								end
							end)()
							 then
								local r_1591
								r_1591 = r_1621
								local arg1
								arg1 = r_1601[r_1591]
								addDefinition1(arg1["var"], struct1("tag", "arg", "value", arg1, "node", node5))
								return r_1611((r_1621 + r_1641))
							else
							end
						end)
						return r_1611(1)
					elseif (func2 == builtins2["set!"]) then
						return addDefinition1(node5[2]["var"], struct1("tag", "set", "value", nth1(node5, 3), "node", node5))
					elseif (function(r_1651)
						if r_1651 then
							return r_1651
						else
							return (func2 == builtins2["define-macro"])
						end
					end)
					((func2 == builtins2["define"])) then
						return addDefinition1(node5["defVar"], struct1("tag", "define", "value", nth1(node5, 3), "node", node5))
					elseif (func2 == builtins2["define-native"]) then
						return addDefinition1(node5["defVar"], struct1("tag", "native", "node", node5))
					else
					end
				else
				end
			end)
			)
		end)
		gatherUsages1 = (function(nodes2, lookup3)
			local queue1
			queue1 = {tag = "list", n =0}
			local addUsage1
			addUsage1 = (function(var4, user1)
				local entry2
				entry2 = lookup3[var4]
				if entry2 then
					if entry2["active"] then
					else
						entry2["active"] = true
						local r_1721
						r_1721 = entry2["defs"]
						local r_1751
						r_1751 = _23_2(r_1721)
						local r_1761
						r_1761 = 1
						local r_1731
						r_1731 = nil
						r_1731 = (function(r_1741)
							if (function()
								if (0 < 1) then
									return (r_1741 <= r_1751)
								else
									return (r_1741 >= r_1751)
								end
							end)()
							 then
								local r_1711
								r_1711 = r_1741
								local def2
								def2 = r_1721[r_1711]
								local val5
								val5 = def2["value"]
								if val5 then
									pushCdr_21_1(queue1, val5)
								else
								end
								return r_1731((r_1741 + r_1761))
							else
							end
						end)
						r_1731(1)
					end
					return pushCdr_21_1(entry2["usages"], user1)
				else
				end
			end)
			local visit1
			visit1 = (function(node6)
				if symbol_3f_1(node6) then
					addUsage1(node6["var"], node6)
					return true
				elseif (function(r_1661)
					if r_1661 then
						local r_1671
						r_1671 = (_23_2(node6) > 0)
						if r_1671 then
							return symbol_3f_1(car1(node6))
						else
							return r_1671
						end
					else
						return r_1661
					end
				end)
				(list_3f_1(node6)) then
					local func3
					func3 = car1(node6)["var"]
					if (function(r_1681)
						if r_1681 then
							return r_1681
						else
							local r_1691
							r_1691 = (func3 == builtins2["define"])
							if r_1691 then
								return r_1691
							else
								return (func3 == builtins2["define-macro"])
							end
						end
					end)
					((func3 == builtins2["set!"])) then
						if hasSideEffect1(nth1(node6, 3)) then
							local entry3
							entry3 = lookup3["var"]
							return _21_1((function(r_1701)
								if r_1701 then
									return entry3["active"]
								else
									return r_1701
								end
							end)
							(entry3))
						else
							return false
						end
					else
						return true
					end
				else
					return true
				end
			end)
			local r_1021
			r_1021 = nodes2
			local r_1051
			r_1051 = _23_2(r_1021)
			local r_1061
			r_1061 = 1
			local r_1031
			r_1031 = nil
			r_1031 = (function(r_1041)
				if (function()
					if (0 < 1) then
						return (r_1041 <= r_1051)
					else
						return (r_1041 >= r_1051)
					end
				end)()
				 then
					local r_1011
					r_1011 = r_1041
					local node7
					node7 = r_1021[r_1011]
					pushCdr_21_1(queue1, node7)
					return r_1031((r_1041 + r_1061))
				else
				end
			end)
			r_1031(1)
			local r_1071
			r_1071 = nil
			r_1071 = (function()
				if (_23_2(queue1) > 0) then
					visitNode1(removeNth_21_1(queue1, 1), visit1)
					return r_1071()
				else
				end
			end)
			return r_1071()
		end)
		optimise1 = (function(nodes3)
			local r_1101
			r_1101 = 1
			local r_1111
			r_1111 = -1
			local r_1081
			r_1081 = nil
			r_1081 = (function(r_1091)
				if (function()
					if (0 < -1) then
						return (r_1091 <= r_1101)
					else
						return (r_1091 >= r_1101)
					end
				end)()
				 then
					local i4
					i4 = r_1091
					local node8
					node8 = nth1(nodes3, i4)
					if (function(r_1121)
						if r_1121 then
							local r_1131
							r_1131 = (_23_2(node8) > 0)
							if r_1131 then
								local r_1141
								r_1141 = symbol_3f_1(car1(node8))
								if r_1141 then
									return (car1(node8)["var"] == builtins2["import"])
								else
									return r_1141
								end
							else
								return r_1131
							end
						else
							return r_1121
						end
					end)
					(list_3f_1(node8)) then
						if (i4 == _23_2(nodes3)) then
							setNth_21_1(nodes3, i4, struct1("tag", "symbol", "contents", "nil", "var", builtinVars1["nil"]))
						else
							removeNth_21_1(nodes3, i4)
						end
					else
					end
					return r_1081((r_1091 + r_1111))
				else
				end
			end)
			r_1081(_23_2(nodes3))
			local r_1171
			r_1171 = 1
			local r_1181
			r_1181 = -1
			local r_1151
			r_1151 = nil
			r_1151 = (function(r_1161)
				if (function()
					if (0 < -1) then
						return (r_1161 <= r_1171)
					else
						return (r_1161 >= r_1171)
					end
				end)()
				 then
					local i5
					i5 = r_1161
					local node9
					node9 = nth1(nodes3, i5)
					if _21_1(hasSideEffect1(node9)) then
						removeNth_21_1(nodes3, i5)
					else
					end
					return r_1151((r_1161 + r_1181))
				else
				end
			end)
			r_1151(pred1(_23_2(nodes3)))
			local lookup4
			lookup4 = {}
			gatherDefinitions1(nodes3, lookup4)
			gatherUsages1(nodes3, lookup4)
			local r_1211
			r_1211 = 1
			local r_1221
			r_1221 = -1
			local r_1191
			r_1191 = nil
			r_1191 = (function(r_1201)
				if (function()
					if (0 < -1) then
						return (r_1201 <= r_1211)
					else
						return (r_1201 >= r_1211)
					end
				end)()
				 then
					local i6
					i6 = r_1201
					local node10
					node10 = nth1(nodes3, i6)
					if (function(r_1231)
						if r_1231 then
							return _21_1(lookup4[node10["defVar"]]["active"])
						else
							return r_1231
						end
					end)
					(node10["defVar"]) then
						if (i6 == _23_2(nodes3)) then
							setNth_21_1(nodes3, i6, struct1("tag", "symbol", "contents", "nil", "var", builtinVars1["nil"]))
						else
							removeNth_21_1(nodes3, i6)
						end
					else
					end
					return r_1191((r_1201 + r_1221))
				else
				end
			end)
			r_1191(_23_2(nodes3))
			return nodes3
		end)
		return optimise1
