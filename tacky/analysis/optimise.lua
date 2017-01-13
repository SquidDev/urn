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

		['gensym'] = function(name)
			if name then
				name = "_" .. tostring(name)
			else
				name = ""
			end

			randCtr = randCtr + 1
			return { tag = "symbol", contents = ("r_%d%s"):format(randCtr, name) }
		end,
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
end);
_21_1 = (function(expr1)
	if expr1 then
		return false
	else
		return true
	end
end);
list_3f_1 = (function(x6)
	return (type1(x6) == "list")
end);
symbol_3f_1 = (function(x7)
	return (type1(x7) == "symbol")
end);
key_3f_1 = (function(x8)
	return (type1(x8) == "key")
end);
type1 = (function(val1)
	local ty2
	ty2 = type_23_1(val1)
	if (ty2 == "table") then
		local tag1
		tag1 = val1["tag"]
		if tag1 then
			return tag1
		else
			return "table"
		end
	else
		return ty2
	end
end);
nth1 = (function(li4, idx1)
	local r_51
	r_51 = type1(li4)
	if (r_51 ~= "list") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_51), 2)
	else
	end
	local r_201
	r_201 = type1(idx1)
	if (r_201 ~= "number") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "idx", "number", r_201), 2)
	else
	end
	return li4[idx1]
end);
setNth_21_1 = (function(li9, idx2, val2)
	local r_61
	r_61 = type1(li9)
	if (r_61 ~= "list") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_61), 2)
	else
	end
	local r_211
	r_211 = type1(idx2)
	if (r_211 ~= "number") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "idx", "number", r_211), 2)
	else
	end
	li9[idx2] = val2
	return nil
end);
removeNth_21_1 = (function(li10, idx3)
	local r_71
	r_71 = type1(li10)
	if (r_71 ~= "list") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_71), 2)
	else
	end
	local r_221
	r_221 = type1(idx3)
	if (r_221 ~= "number") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "idx", "number", r_221), 2)
	else
	end
	li10["n"] = (li10["n"] - 1)
	return removeIdx_21_1(li10, idx3)
end);
_23_2 = (function(li5)
	local r_81
	r_81 = type1(li5)
	if (r_81 ~= "list") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_81), 2)
	else
	end
	return _23_1(li5)
end);
car2 = (function(li3)
	return nth1(li3, 1)
end);
pushCdr_21_1 = (function(li11, val3)
	local r_111
	r_111 = type1(li11)
	if (r_111 ~= "list") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_111), 2)
	else
	end
	local len1
	len1 = (_23_1(li11) + 1)
	li11["n"] = len1
	li11[len1] = val3
	return li11
end);
sub1 = _libs["sub"]
struct1 = (function(...)
	local keys3 = table.pack(...) keys3.tag = "list"
	if ((_23_2(keys3) % 1) == 1) then
		error_21_1("Expected an even number of arguments to struct", 2)
	else
	end
	local contents1, out2
	contents1 = (function(key3)
		return sub1(key3["contents"], 2)
	end);
	out2 = {}
	local r_621
	r_621 = _23_1(keys3)
	local r_631
	r_631 = 2
	local r_601
	r_601 = nil
	r_601 = (function(r_611)
		local _temp
		if (0 < 2) then
			_temp = (r_611 <= r_621)
		else
			_temp = (r_611 >= r_621)
		end
		if _temp then
			local i3
			i3 = r_611
			local key4, val4
			key4 = keys3[i3]
			val4 = keys3[(1 + i3)]
			out2[(function()
				if key_3f_1(key4) then
					return contents1(key4)
				else
					return key4
				end
			end)()] = val4
			return r_601((r_611 + r_631))
		else
		end
	end);
	r_601(1)
	return out2
end);
fail1 = (function(msg1)
	return error_21_1(msg1, 0)
end);
succ1 = (function(x9)
	return (1 + x9)
end);
pred1 = (function(x10)
	return (x10 - 1)
end);
builtins1 = require1("tacky.analysis.resolve")["builtins"]
visitQuote1 = (function(node1, visitor1, level1)
	if (level1 == 0) then
		return visitNode1(node1, visitor1)
	else
		local tag2
		tag2 = node1["tag"]
		local _temp
		local r_1221
		r_1221 = (tag2 == "string")
		if r_1221 then
			_temp = r_1221
		else
			local r_1231
			r_1231 = (tag2 == "number")
			if r_1231 then
				_temp = r_1231
			else
				local r_1241
				r_1241 = (tag2 == "key")
				if r_1241 then
					_temp = r_1241
				else
					_temp = (tag2 == "symbol")
				end
			end
		end
		if _temp then
			return nil
		elseif (tag2 == "list") then
			local first1
			first1 = nth1(node1, 1)
			local _temp
			local r_1251
			r_1251 = first1
			if r_1251 then
				_temp = (first1["tag"] == "symbol")
			else
				_temp = r_1251
			end
			if _temp then
				local _temp
				local r_1261
				r_1261 = (first1["contents"] == "unquote")
				if r_1261 then
					_temp = r_1261
				else
					_temp = (first1["contents"] == "unquote-splice")
				end
				if _temp then
					return visitQuote1(nth1(node1, 2), visitor1, pred1(level1))
				elseif (first1["contents"] == "quasiquote") then
					return visitQuote1(nth1(node1, 2), visitor1(), succ1(level1))
				else
					local r_1281
					r_1281 = node1
					local r_1311
					r_1311 = _23_2(r_1281)
					local r_1321
					r_1321 = 1
					local r_1291
					r_1291 = nil
					r_1291 = (function(r_1301)
						local _temp
						if (0 < 1) then
							_temp = (r_1301 <= r_1311)
						else
							_temp = (r_1301 >= r_1311)
						end
						if _temp then
							local r_1271
							r_1271 = r_1301
							local sub2
							sub2 = r_1281[r_1271]
							visitQuote1(sub2, visitor1, level1)
							return r_1291((r_1301 + r_1321))
						else
						end
					end);
					return r_1291(1)
				end
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
					local _temp
					if (0 < 1) then
						_temp = (r_1361 <= r_1371)
					else
						_temp = (r_1361 >= r_1371)
					end
					if _temp then
						local r_1331
						r_1331 = r_1361
						local sub3
						sub3 = r_1341[r_1331]
						visitQuote1(sub3, visitor1, level1)
						return r_1351((r_1361 + r_1381))
					else
					end
				end);
				return r_1351(1)
			end
		elseif error_21_1 then
			return ("Unknown tag " .. tag2)
		else
			error('unmatched item')
		end
	end
end);
visitNode1 = (function(node2, visitor2)
	if (visitor2(node2) == false) then
	else
		local tag3
		tag3 = node2["tag"]
		local _temp
		local r_1391
		r_1391 = (tag3 == "string")
		if r_1391 then
			_temp = r_1391
		else
			local r_1401
			r_1401 = (tag3 == "number")
			if r_1401 then
				_temp = r_1401
			else
				local r_1411
				r_1411 = (tag3 == "key")
				if r_1411 then
					_temp = r_1411
				else
					_temp = (tag3 == "symbol")
				end
			end
		end
		if _temp then
			return nil
		elseif (tag3 == "list") then
			local first2
			first2 = nth1(node2, 1)
			local _temp
			local r_1421
			r_1421 = first2
			if r_1421 then
				_temp = (first2["tag"] == "symbol")
			else
				_temp = r_1421
			end
			if _temp then
				local func1
				func1 = first2["var"]
				local funct1
				funct1 = func1["tag"]
				if (func1 == builtins1["lambda"]) then
					return visitBlock1(node2, 3, visitor2)
				elseif (func1 == builtins1["cond"]) then
					local r_1451
					r_1451 = _23_2(node2)
					local r_1461
					r_1461 = 1
					local r_1431
					r_1431 = nil
					r_1431 = (function(r_1441)
						local _temp
						if (0 < 1) then
							_temp = (r_1441 <= r_1451)
						else
							_temp = (r_1441 >= r_1451)
						end
						if _temp then
							local i4
							i4 = r_1441
							local case1
							case1 = nth1(node2, i4)
							visitNode1(nth1(case1, 1), visitor2)
							visitBlock1(case1, 2, visitor2)
							return r_1431((r_1441 + r_1461))
						else
						end
					end);
					return r_1431(2)
				elseif (func1 == builtins1["set!"]) then
					return visitNode1(nth1(node2, 3), visitor2)
				elseif (func1 == builtins1["quote"]) then
				elseif (func1 == builtins1["quasiquote"]) then
					return visitQuote1(nth1(node2, 2), visitor2, 1)
				else
					local _temp
					local r_1471
					r_1471 = (func1 == builtins1["unquote"])
					if r_1471 then
						_temp = r_1471
					else
						_temp = (func1 == builtins1["unquote-splice"])
					end
					if _temp then
						return fail1("unquote/unquote-splice should never appear head")
					else
						local _temp
						local r_1481
						r_1481 = (func1 == builtins1["define"])
						if r_1481 then
							_temp = r_1481
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
							local r_1491
							r_1491 = (funct1 == "defined")
							if r_1491 then
								_temp = r_1491
							else
								local r_1501
								r_1501 = (funct1 == "arg")
								if r_1501 then
									_temp = r_1501
								else
									_temp = (funct1 == "native")
								end
							end
							if _temp then
								return visitBlock1(node2, 1, visitor2)
							else
								return fail1(_2e2e_1("Unknown kind ", func1, " for variable ", func1["name"]))
							end
						end
					end
				end
			else
				return visitBlock1(node2, 1, visitor2)
			end
		elseif error_21_1 then
			return ("Unknown tag " .. tag3)
		else
			error('unmatched item')
		end
	end
end);
visitBlock1 = (function(node3, start3, visitor3)
	local r_1201
	r_1201 = _23_2(node3)
	local r_1211
	r_1211 = 1
	local r_1181
	r_1181 = nil
	r_1181 = (function(r_1191)
		local _temp
		if (0 < 1) then
			_temp = (r_1191 <= r_1201)
		else
			_temp = (r_1191 >= r_1201)
		end
		if _temp then
			local i5
			i5 = r_1191
			visitNode1(nth1(node3, i5), visitor3)
			return r_1181((r_1191 + r_1211))
		else
		end
	end);
	return r_1181(start3)
end);
struct1("visitNode", visitNode1, "visitBlock", visitBlock1, "visitList", visitBlock1)
builtins2 = require1("tacky.analysis.resolve")["builtins"]
hasSideEffect1 = (function(node4)
	local tag4
	tag4 = type1(node4)
	local _temp
	local r_911
	r_911 = (tag4 == "number")
	if r_911 then
		_temp = r_911
	else
		local r_921
		r_921 = (tag4 == "string")
		if r_921 then
			_temp = r_921
		else
			local r_931
			r_931 = (tag4 == "key")
			if r_931 then
				_temp = r_931
			else
				_temp = (tag4 == "symbol")
			end
		end
	end
	if _temp then
		return false
	elseif (tag4 == "list") then
		local fst1
		fst1 = car2(node4)
		if (type1(fst1) == "symbol") then
			local var5
			var5 = fst1["var"]
			local r_941
			r_941 = (var5 ~= builtins2["lambda"])
			if r_941 then
				return (var5 ~= builtins2["quote"])
			else
				return r_941
			end
		else
			return true
		end
	else
		error('unmatched item')
	end
end);
getVarEntry1 = (function(lookup1, var6)
	local entry1
	entry1 = lookup1[var6]
	if entry1 then
	else
		entry1 = struct1("var", var6, "usages", {tag = "list", n = 0}, "defs", {tag = "list", n = 0}, "active", false)
		lookup1[var6] = entry1
	end
	return entry1
end);
gatherDefinitions1 = (function(nodes1, lookup2)
	local addDefinition1
	addDefinition1 = (function(var7, def1)
		return pushCdr_21_1(getVarEntry1(lookup2, var7)["defs"], def1)
	end);
	return visitBlock1(nodes1, 1, (function(node5)
		local _temp
		local r_1511
		r_1511 = list_3f_1(node5)
		if r_1511 then
			local r_1521
			r_1521 = (_23_2(node5) > 0)
			if r_1521 then
				_temp = symbol_3f_1(car2(node5))
			else
				_temp = r_1521
			end
		else
			_temp = r_1511
		end
		if _temp then
			local func2
			func2 = car2(node5)["var"]
			if (func2 == builtins2["lambda"]) then
				local r_1541
				r_1541 = nth1(node5, 2)
				local r_1571
				r_1571 = _23_2(r_1541)
				local r_1581
				r_1581 = 1
				local r_1551
				r_1551 = nil
				r_1551 = (function(r_1561)
					local _temp
					if (0 < 1) then
						_temp = (r_1561 <= r_1571)
					else
						_temp = (r_1561 >= r_1571)
					end
					if _temp then
						local r_1531
						r_1531 = r_1561
						local arg2
						arg2 = r_1541[r_1531]
						local _ = 1
						addDefinition1(arg2["var"], struct1("tag", "arg", "value", arg2, "node", node5))
						return r_1551((r_1561 + r_1581))
					else
					end
				end);
				return r_1551(1)
			elseif (func2 == builtins2["set!"]) then
				return addDefinition1(node5[2]["var"], struct1("tag", "set", "value", nth1(node5, 3), "node", node5))
			else
				local _temp
				local r_1591
				r_1591 = (func2 == builtins2["define"])
				if r_1591 then
					_temp = r_1591
				else
					_temp = (func2 == builtins2["define-macro"])
				end
				if _temp then
					return addDefinition1(node5["defVar"], struct1("tag", "define", "value", nth1(node5, 3), "node", node5))
				elseif (func2 == builtins2["define-native"]) then
					return addDefinition1(node5["defVar"], struct1("tag", "native", "node", node5))
				else
				end
			end
		else
		end
	end))
end);
gatherUsages1 = (function(nodes2, lookup3)
	local queue1
	queue1 = {tag = "list", n = 0}
	local addUsage1
	addUsage1 = (function(var8, user1)
		local entry2
		entry2 = lookup3[var8]
		if entry2 then
			if entry2["active"] then
			else
				entry2["active"] = true
				local r_1661
				r_1661 = entry2["defs"]
				local r_1691
				r_1691 = _23_2(r_1661)
				local r_1701
				r_1701 = 1
				local r_1671
				r_1671 = nil
				r_1671 = (function(r_1681)
					local _temp
					if (0 < 1) then
						_temp = (r_1681 <= r_1691)
					else
						_temp = (r_1681 >= r_1691)
					end
					if _temp then
						local r_1651
						r_1651 = r_1681
						local def2
						def2 = r_1661[r_1651]
						local val5
						val5 = def2["value"]
						if val5 then
							pushCdr_21_1(queue1, val5)
						else
						end
						return r_1671((r_1681 + r_1701))
					else
					end
				end);
				r_1671(1)
			end
			return pushCdr_21_1(entry2["usages"], user1)
		else
		end
	end);
	local visit1
	visit1 = (function(node6)
		if symbol_3f_1(node6) then
			addUsage1(node6["var"], node6)
			return true
		else
			local _temp
			local r_1601
			r_1601 = list_3f_1(node6)
			if r_1601 then
				local r_1611
				r_1611 = (_23_2(node6) > 0)
				if r_1611 then
					_temp = symbol_3f_1(car2(node6))
				else
					_temp = r_1611
				end
			else
				_temp = r_1601
			end
			if _temp then
				local func3
				func3 = car2(node6)["var"]
				local _temp
				local r_1621
				r_1621 = (func3 == builtins2["set!"])
				if r_1621 then
					_temp = r_1621
				else
					local r_1631
					r_1631 = (func3 == builtins2["define"])
					if r_1631 then
						_temp = r_1631
					else
						_temp = (func3 == builtins2["define-macro"])
					end
				end
				if _temp then
					if hasSideEffect1(nth1(node6, 3)) then
						local entry3
						entry3 = lookup3["var"]
						return _21_1((function(r_1641)
							if r_1641 then
								return entry3["active"]
							else
								return r_1641
							end
						end)(entry3))
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
	end);
	local r_961
	r_961 = nodes2
	local r_991
	r_991 = _23_2(r_961)
	local r_1001
	r_1001 = 1
	local r_971
	r_971 = nil
	r_971 = (function(r_981)
		local _temp
		if (0 < 1) then
			_temp = (r_981 <= r_991)
		else
			_temp = (r_981 >= r_991)
		end
		if _temp then
			local r_951
			r_951 = r_981
			local node7
			node7 = r_961[r_951]
			pushCdr_21_1(queue1, node7)
			return r_971((r_981 + r_1001))
		else
		end
	end);
	r_971(1)
	local r_1011
	r_1011 = nil
	r_1011 = (function()
		if (_23_2(queue1) > 0) then
			visitNode1(removeNth_21_1(queue1, 1), visit1)
			return r_1011()
		else
		end
	end);
	return r_1011()
end);
optimise1 = (function(nodes3)
	local r_1041
	r_1041 = 1
	local r_1051
	r_1051 = -1
	local r_1021
	r_1021 = nil
	r_1021 = (function(r_1031)
		local _temp
		if (0 < -1) then
			_temp = (r_1031 <= r_1041)
		else
			_temp = (r_1031 >= r_1041)
		end
		if _temp then
			local i6
			i6 = r_1031
			local node8
			node8 = nth1(nodes3, i6)
			local _temp
			local r_1061
			r_1061 = list_3f_1(node8)
			if r_1061 then
				local r_1071
				r_1071 = (_23_2(node8) > 0)
				if r_1071 then
					local r_1081
					r_1081 = symbol_3f_1(car2(node8))
					if r_1081 then
						_temp = (car2(node8)["var"] == builtins2["import"])
					else
						_temp = r_1081
					end
				else
					_temp = r_1071
				end
			else
				_temp = r_1061
			end
			if _temp then
				if (i6 == _23_2(nodes3)) then
					setNth_21_1(nodes3, i6, {tag = "symbol", contents = "nil", var = "table: 00000000029050c0"})
				else
					removeNth_21_1(nodes3, i6)
				end
			else
			end
			return r_1021((r_1031 + r_1051))
		else
		end
	end);
	r_1021(_23_2(nodes3))
	local r_1111
	r_1111 = 1
	local r_1121
	r_1121 = -1
	local r_1091
	r_1091 = nil
	r_1091 = (function(r_1101)
		local _temp
		if (0 < -1) then
			_temp = (r_1101 <= r_1111)
		else
			_temp = (r_1101 >= r_1111)
		end
		if _temp then
			local i7
			i7 = r_1101
			local node9
			node9 = nth1(nodes3, i7)
			if _21_1(hasSideEffect1(node9)) then
				removeNth_21_1(nodes3, i7)
			else
			end
			return r_1091((r_1101 + r_1121))
		else
		end
	end);
	r_1091(pred1(_23_2(nodes3)))
	local lookup4
	lookup4 = {}
	gatherDefinitions1(nodes3, lookup4)
	gatherUsages1(nodes3, lookup4)
	local r_1151
	r_1151 = 1
	local r_1161
	r_1161 = -1
	local r_1131
	r_1131 = nil
	r_1131 = (function(r_1141)
		local _temp
		if (0 < -1) then
			_temp = (r_1141 <= r_1151)
		else
			_temp = (r_1141 >= r_1151)
		end
		if _temp then
			local i8
			i8 = r_1141
			local node10
			node10 = nth1(nodes3, i8)
			local _temp
			local r_1171
			r_1171 = node10["defVar"]
			if r_1171 then
				_temp = _21_1(lookup4[node10["defVar"]]["active"])
			else
				_temp = r_1171
			end
			if _temp then
				if (i8 == _23_2(nodes3)) then
					setNth_21_1(nodes3, i8, {tag = "symbol", contents = "nil", var = "table: 00000000029050c0"})
				else
					removeNth_21_1(nodes3, i8)
				end
			else
			end
			return r_1131((r_1141 + r_1161))
		else
		end
	end);
	r_1131(_23_2(nodes3))
	return nodes3
end);
return optimise1
