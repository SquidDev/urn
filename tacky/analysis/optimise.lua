if not table.pack then table.pack = function(...) return { n = select("#", ...), ... } end end
if not table.unpack then table.unpack = unpack end
local load = load if _VERSION:find("5.1") then load = function(x, _, _, env) local f, e = loadstring(x); if not f then error(e, 1) end; return setfenv(f, env) end end
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
for k, v in pairs(_temp) do _libs["lib/lua/basic/".. k] = v end
local _3d_1, _2f3d_1, _3c_1, _3c3d_1, _3e_1, _3e3d_1, _2b_1, _2d_1, _25_1, _2e2e_1, slice1, error1, next1, pcall1, print1, getIdx1, setIdx_21_1, require1, tostring1, type_23_1, _23_1, find1, format1, len1, rep1, sub1, concat1, remove1, unpack1, emptyStruct1, iterPairs1, car1, cdr1, list1, cons1, _21_1, pretty1, pair1, snd1, list_3f_1, nil_3f_1, string_3f_1, number_3f_1, symbol_3f_1, key_3f_1, exists_3f_1, type1, car2, cdr2, foldr1, map1, all1, nth1, pushCdr_21_1, removeNth_21_1, reverse1, caar1, cadr1, charAt1, _2e2e_2, split1, getenv1, struct1, _23_keys1, succ1, pred1, fail_21_1, builtins1, visitQuote1, visitNode1, visitBlock1, builtins2, builtinVars1, createState1, getVar1, getNode1, addUsage_21_1, addDefinition_21_1, definitionsVisitor1, definitionsVisit1, usagesVisit1, builtins3, traverseQuote1, traverseNode1, traverseBlock1, traverseList1, config1, coloredAnsi1, colored_3f_1, colored1, abs1, huge1, max1, modf1, verbosity1, setVerbosity_21_1, showExplain1, setExplain_21_1, printError_21_1, printWarning_21_1, printVerbose_21_1, printDebug_21_1, formatPosition1, formatRange1, formatNode1, getSource1, putLines_21_1, putTrace_21_1, putExplain_21_1, errorPositions_21_1, builtins4, builtinVars2, hasSideEffect1, constant_3f_1, urn_2d3e_val1, val_2d3e_urn1, truthy_3f_1, makeProgn1, getConstantVal1, optimiseOnce1, optimise1
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
slice1 = _libs["lib/lua/basic/slice"]
error1 = error
next1 = next
pcall1 = pcall
print1 = print
getIdx1 = function(v1, v2) return v1[v2] end
setIdx_21_1 = function(v1, v2, v3) v1[v2] = v3 end
require1 = require
tostring1 = tostring
type_23_1 = type
_23_1 = (function(x1)
	return x1["n"]
end)
find1 = string.find
format1 = string.format
len1 = string.len
rep1 = string.rep
sub1 = string.sub
concat1 = table.concat
remove1 = table.remove
unpack1 = table.unpack
emptyStruct1 = function() return {} end
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
	return list1(x2, unpack1(xs4))
end)
_21_1 = (function(expr1)
	if expr1 then
		return false
	else
		return true
	end
end)
pretty1 = (function(value1)
	local ty1 = type_23_1(value1)
	if (ty1 == "table") then
		local tag1 = value1["tag"]
		if (tag1 == "list") then
			local out1 = {tag = "list", n = 0}
			local r_31 = _23_1(value1)
			local r_11 = nil
			r_11 = (function(r_21)
				if (r_21 <= r_31) then
					out1[r_21] = pretty1(value1[r_21])
					return r_11((r_21 + 1))
				else
				end
			end)
			r_11(1)
			return ("(" .. (concat1(out1, " ") .. ")"))
		elseif (tag1 == "list") then
			return value1["contents"]
		elseif (tag1 == "symbol") then
			return value1["contents"]
		elseif (tag1 == "key") then
			return (":" .. value1["contents"])
		elseif (tag1 == "key") then
			return (":" .. value1["contents"])
		elseif (tag1 == "string") then
			return format1("%q", value1["value"])
		elseif (tag1 == "number") then
			return tostring1(value1["value"])
		else
			return tostring1(value1)
		end
	elseif (ty1 == "string") then
		return format1("%q", value1)
	else
		return tostring1(value1)
	end
end)
pair1 = (function(x3, y1)
	local ret1 = {}
	ret1["tag"] = { tag="symbol", contents="pair"}
	ret1["fst"] = x3
	ret1["snd"] = y1
	return ret1
end)
snd1 = (function(x4)
	return x4["snd"]
end)
list_3f_1 = (function(x5)
	return (type1(x5) == "list")
end)
nil_3f_1 = (function(x6)
	if x6 then
		local r_81 = list_3f_1(x6)
		if r_81 then
			return (_23_1(x6) == 0)
		else
			return r_81
		end
	else
		return x6
	end
end)
string_3f_1 = (function(x7)
	return (type1(x7) == "string")
end)
number_3f_1 = (function(x8)
	return (type1(x8) == "number")
end)
symbol_3f_1 = (function(x9)
	return (type1(x9) == "symbol")
end)
key_3f_1 = (function(x10)
	return (type1(x10) == "key")
end)
exists_3f_1 = (function(x11)
	return _21_1((type1(x11) == "nil"))
end)
type1 = (function(val1)
	local ty2 = type_23_1(val1)
	if (ty2 == "table") then
		local tag2 = val1["tag"]
		if tag2 then
			return tag2
		else
			return "table"
		end
	else
		return ty2
	end
end)
car2 = (function(x12)
	local r_281 = type1(x12)
	if (r_281 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_281), 2)
	else
	end
	return car1(x12)
end)
cdr2 = (function(x13)
	local r_291 = type1(x13)
	if (r_291 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_291), 2)
	else
	end
	if nil_3f_1(x13) then
		return {tag = "list", n = 0}
	else
		return cdr1(x13)
	end
end)
foldr1 = (function(f1, z1, xs5)
	local r_301 = type1(f1)
	if (r_301 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "f", "function", r_301), 2)
	else
	end
	local r_421 = type1(xs5)
	if (r_421 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_421), 2)
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
	local r_311 = type1(f2)
	if (r_311 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "f", "function", r_311), 2)
	else
	end
	local r_431 = type1(xs6)
	if (r_431 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_431), 2)
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
all1 = (function(p1, xs7)
	local r_341 = type1(p1)
	if (r_341 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "p", "function", r_341), 2)
	else
	end
	local r_471 = type1(xs7)
	if (r_471 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_471), 2)
	else
	end
	return foldr1((function(x14, y2)
		if x14 then
			return y2
		else
			return x14
		end
	end), true, map1(p1, xs7))
end)
nth1 = (function(xs8, idx1)
	return xs8[idx1]
end)
pushCdr_21_1 = (function(xs9, val2)
	local r_381 = type1(xs9)
	if (r_381 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_381), 2)
	else
	end
	local len2 = (_23_1(xs9) + 1)
	xs9["n"] = len2
	xs9[len2] = val2
	return xs9
end)
removeNth_21_1 = (function(li1, idx2)
	local r_401 = type1(li1)
	if (r_401 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_401), 2)
	else
	end
	li1["n"] = (li1["n"] - 1)
	return remove1(li1, idx2)
end)
reverse1 = (function(xs10, acc2)
	if _21_1(exists_3f_1(acc2)) then
		return reverse1(xs10, {tag = "list", n = 0})
	elseif nil_3f_1(xs10) then
		return acc2
	else
		return reverse1(cdr2(xs10), cons1(car2(xs10), acc2))
	end
end)
caar1 = (function(x15)
	return car2(car2(x15))
end)
cadr1 = (function(x16)
	return car2(cdr2(x16))
end)
charAt1 = (function(xs11, x17)
	return sub1(xs11, x17, x17)
end)
_2e2e_2 = (function(...)
	local args1 = _pack(...) args1.tag = "list"
	return concat1(args1)
end)
split1 = (function(text1, pattern1, limit1)
	local out2 = {tag = "list", n = 0}
	local loop1 = true
	local start1 = 1
	local r_531 = nil
	r_531 = (function()
		if loop1 then
			local pos1 = list1(find1(text1, pattern1, start1))
			local nstart1 = car2(pos1)
			local nend1 = cadr1(pos1)
			local temp1
			local r_541 = (nstart1 == nil)
			if r_541 then
				temp1 = r_541
			else
				if limit1 then
					temp1 = (_23_1(out2) >= limit1)
				else
					temp1 = limit1
				end
			end
			if temp1 then
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
			return r_531()
		else
		end
	end)
	r_531()
	return out2
end)
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
	local out3 = {}
	local r_641 = _23_1(keys1)
	local r_621 = nil
	r_621 = (function(r_631)
		if (r_631 <= r_641) then
			local key2 = keys1[r_631]
			local val3 = keys1[(1 + r_631)]
			out3[(function()
				if key_3f_1(key2) then
					return contents1(key2)
				else
					return key2
				end
			end)()
			] = val3
			return r_621((r_631 + 2))
		else
		end
	end)
	r_621(1)
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
succ1 = (function(x18)
	return (x18 + 1)
end)
pred1 = (function(x19)
	return (x19 - 1)
end)
fail_21_1 = (function(x20)
	return error1(x20, 0)
end)
builtins1 = require1("tacky.analysis.resolve")["builtins"]
visitQuote1 = (function(node1, visitor1, level1)
	if (level1 == 0) then
		return visitNode1(node1, visitor1)
	else
		local tag3 = node1["tag"]
		local temp2
		local r_1261 = (tag3 == "string")
		if r_1261 then
			temp2 = r_1261
		else
			local r_1271 = (tag3 == "number")
			if r_1271 then
				temp2 = r_1271
			else
				local r_1281 = (tag3 == "key")
				if r_1281 then
					temp2 = r_1281
				else
					temp2 = (tag3 == "symbol")
				end
			end
		end
		if temp2 then
			return nil
		elseif (tag3 == "list") then
			local first1 = nth1(node1, 1)
			local temp3
			if first1 then
				temp3 = (first1["tag"] == "symbol")
			else
				temp3 = first1
			end
			if temp3 then
				local temp4
				local r_1301 = (first1["contents"] == "unquote")
				if r_1301 then
					temp4 = r_1301
				else
					temp4 = (first1["contents"] == "unquote-splice")
				end
				if temp4 then
					return visitQuote1(nth1(node1, 2), visitor1, pred1(level1))
				elseif (first1["contents"] == "syntax-quote") then
					return visitQuote1(nth1(node1, 2), visitor1, succ1(level1))
				else
					local r_1351 = _23_1(node1)
					local r_1331 = nil
					r_1331 = (function(r_1341)
						if (r_1341 <= r_1351) then
							local sub2 = node1[r_1341]
							visitQuote1(sub2, visitor1, level1)
							return r_1331((r_1341 + 1))
						else
						end
					end)
					return r_1331(1)
				end
			else
				local r_1411 = _23_1(node1)
				local r_1391 = nil
				r_1391 = (function(r_1401)
					if (r_1401 <= r_1411) then
						local sub3 = node1[r_1401]
						visitQuote1(sub3, visitor1, level1)
						return r_1391((r_1401 + 1))
					else
					end
				end)
				return r_1391(1)
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
		local temp5
		local r_1431 = (tag4 == "string")
		if r_1431 then
			temp5 = r_1431
		else
			local r_1441 = (tag4 == "number")
			if r_1441 then
				temp5 = r_1441
			else
				local r_1451 = (tag4 == "key")
				if r_1451 then
					temp5 = r_1451
				else
					temp5 = (tag4 == "symbol")
				end
			end
		end
		if temp5 then
			return nil
		elseif (tag4 == "list") then
			local first2 = nth1(node2, 1)
			if (first2["tag"] == "symbol") then
				local func1 = first2["var"]
				local funct1 = func1["tag"]
				if (func1 == builtins1["lambda"]) then
					return visitBlock1(node2, 3, visitor2)
				elseif (func1 == builtins1["cond"]) then
					local r_1481 = _23_1(node2)
					local r_1461 = nil
					r_1461 = (function(r_1471)
						if (r_1471 <= r_1481) then
							local case1 = nth1(node2, r_1471)
							visitNode1(nth1(case1, 1), visitor2)
							visitBlock1(case1, 2, visitor2)
							return r_1461((r_1471 + 1))
						else
						end
					end)
					return r_1461(2)
				elseif (func1 == builtins1["set!"]) then
					return visitNode1(nth1(node2, 3), visitor2)
				elseif (func1 == builtins1["quote"]) then
				elseif (func1 == builtins1["syntax-quote"]) then
					return visitQuote1(nth1(node2, 2), visitor2, 1)
				else
					local temp6
					local r_1501 = (func1 == builtins1["unquote"])
					if r_1501 then
						temp6 = r_1501
					else
						temp6 = (func1 == builtins1["unquote-splice"])
					end
					if temp6 then
						return fail_21_1("unquote/unquote-splice should never appear head")
					else
						local temp7
						local r_1511 = (func1 == builtins1["define"])
						if r_1511 then
							temp7 = r_1511
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
							local r_1521 = (funct1 == "defined")
							if r_1521 then
								temp8 = r_1521
							else
								local r_1531 = (funct1 == "arg")
								if r_1531 then
									temp8 = r_1531
								else
									temp8 = (funct1 == "native")
								end
							end
							if temp8 then
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
	local r_1241 = _23_1(node3)
	local r_1221 = nil
	r_1221 = (function(r_1231)
		if (r_1231 <= r_1241) then
			visitNode1(nth1(node3, r_1231), visitor3)
			return r_1221((r_1231 + 1))
		else
		end
	end)
	return r_1221(start2)
end)
builtins2 = require1("tacky.analysis.resolve")["builtins"]
builtinVars1 = require1("tacky.analysis.resolve")["declaredVars"]
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
addDefinition_21_1 = (function(state4, var3, node6, kind1, value2)
	local varMeta2 = getVar1(state4, var3)
	varMeta2["defs"][node6] = struct1("tag", kind1, "value", value2)
	return nil
end)
definitionsVisitor1 = (function(state5, node7, visitor4)
	local temp9
	local r_1111 = list_3f_1(node7)
	if r_1111 then
		temp9 = symbol_3f_1(car2(node7))
	else
		temp9 = r_1111
	end
	if temp9 then
		local func2 = car2(node7)["var"]
		if (func2 == builtins2["lambda"]) then
			local r_1131 = nth1(node7, 2)
			local r_1161 = _23_1(r_1131)
			local r_1141 = nil
			r_1141 = (function(r_1151)
				if (r_1151 <= r_1161) then
					local arg1 = r_1131[r_1151]
					addDefinition_21_1(state5, arg1["var"], arg1, "arg", arg1)
					return r_1141((r_1151 + 1))
				else
				end
			end)
			return r_1141(1)
		elseif (func2 == builtins2["set!"]) then
			return addDefinition_21_1(state5, node7[2]["var"], node7, "set", nth1(node7, 3))
		else
			local temp10
			local r_1181 = (func2 == builtins2["define"])
			if r_1181 then
				temp10 = r_1181
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
		local r_1191 = list_3f_1(node7)
		if r_1191 then
			local r_1201 = list_3f_1(car2(node7))
			if r_1201 then
				local r_1211 = symbol_3f_1(caar1(node7))
				if r_1211 then
					temp11 = (caar1(node7)["var"] == builtins2["lambda"])
				else
					temp11 = r_1211
				end
			else
				temp11 = r_1201
			end
		else
			temp11 = r_1191
		end
		if temp11 then
			local lam1 = car2(node7)
			local args2 = nth1(lam1, 2)
			local offset1 = 1
			local r_1561 = _23_1(args2)
			local r_1541 = nil
			r_1541 = (function(r_1551)
				if (r_1551 <= r_1561) then
					local arg2 = nth1(args2, r_1551)
					local val4 = nth1(node7, (r_1551 + offset1))
					if arg2["var"]["isVariadic"] then
						local count1 = (_23_1(node7) - _23_1(args2))
						if (count1 < 0) then
							count1 = 0
						else
						end
						offset1 = count1
						addDefinition_21_1(state5, arg2["var"], arg2, "arg", arg2)
					else
						addDefinition_21_1(state5, arg2["var"], arg2, "let", (function()
							if val4 then
								return val4
							else
								return struct1("tag", "symbol", "contents", "nil", "var", builtinVars1["nil"])
							end
						end)())
					end
					return r_1541((r_1551 + 1))
				else
				end
			end)
			r_1541(1)
			visitBlock1(node7, 2, visitor4)
			visitBlock1(lam1, 3, visitor4)
			return false
		else
		end
	end
end)
definitionsVisit1 = (function(state6, nodes1)
	return visitBlock1(nodes1, 1, (function(r_1661, r_1671)
		return definitionsVisitor1(state6, r_1661, r_1671)
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
	local visited1 = {}
	local addUsage1 = (function(var4, user1)
		addUsage_21_1(state7, var4, user1)
		local varMeta3 = getVar1(state7, var4)
		if varMeta3["active"] then
			return iterPairs1(varMeta3["defs"], (function(_5f_1, def1)
				local val5 = def1["value"]
				local temp12
				if val5 then
					temp12 = _21_1(visited1[val5])
				else
					temp12 = val5
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
				local r_1681 = list_3f_1(node8)
				if r_1681 then
					local r_1691 = (_23_1(node8) > 0)
					if r_1691 then
						temp13 = symbol_3f_1(car2(node8))
					else
						temp13 = r_1691
					end
				else
					temp13 = r_1681
				end
				if temp13 then
					local func3 = car2(node8)["var"]
					local temp14
					local r_1701 = (func3 == builtins2["set!"])
					if r_1701 then
						temp14 = r_1701
					else
						local r_1711 = (func3 == builtins2["define"])
						if r_1711 then
							temp14 = r_1711
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
	local r_1631 = _23_1(nodes2)
	local r_1611 = nil
	r_1611 = (function(r_1621)
		if (r_1621 <= r_1631) then
			local node9 = nodes2[r_1621]
			pushCdr_21_1(queue1, node9)
			return r_1611((r_1621 + 1))
		else
		end
	end)
	r_1611(1)
	local r_1651 = nil
	r_1651 = (function()
		if (_23_1(queue1) > 0) then
			visitNode1(removeNth_21_1(queue1, 1), visit1)
			return r_1651()
		else
		end
	end)
	return r_1651()
end)
builtins3 = require1("tacky.analysis.resolve")["builtins"]
traverseQuote1 = (function(node10, visitor5, level2)
	if (level2 == 0) then
		return traverseNode1(node10, visitor5)
	else
		local tag5 = node10["tag"]
		local temp15
		local r_1841 = (tag5 == "string")
		if r_1841 then
			temp15 = r_1841
		else
			local r_1851 = (tag5 == "number")
			if r_1851 then
				temp15 = r_1851
			else
				local r_1861 = (tag5 == "key")
				if r_1861 then
					temp15 = r_1861
				else
					temp15 = (tag5 == "symbol")
				end
			end
		end
		if temp15 then
			return node10
		elseif (tag5 == "list") then
			local first3 = nth1(node10, 1)
			local temp16
			if first3 then
				temp16 = (first3["tag"] == "symbol")
			else
				temp16 = first3
			end
			if temp16 then
				local temp17
				local r_1881 = (first3["contents"] == "unquote")
				if r_1881 then
					temp17 = r_1881
				else
					temp17 = (first3["contents"] == "unquote-splice")
				end
				if temp17 then
					node10[2] = traverseQuote1(nth1(node10, 2), visitor5, pred1(level2))
					return node10
				elseif (first3["contents"] == "syntax-quote") then
					node10[2] = traverseQuote1(nth1(node10, 2), visitor5, succ1(level2))
					return node10
				else
					local r_1911 = _23_1(node10)
					local r_1891 = nil
					r_1891 = (function(r_1901)
						if (r_1901 <= r_1911) then
							node10[r_1901] = traverseQuote1(nth1(node10, r_1901), visitor5, level2)
							return r_1891((r_1901 + 1))
						else
						end
					end)
					r_1891(1)
					return node10
				end
			else
				local r_1951 = _23_1(node10)
				local r_1931 = nil
				r_1931 = (function(r_1941)
					if (r_1941 <= r_1951) then
						node10[r_1941] = traverseQuote1(nth1(node10, r_1941), visitor5, level2)
						return r_1931((r_1941 + 1))
					else
					end
				end)
				r_1931(1)
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
	local temp18
	local r_1731 = (tag6 == "string")
	if r_1731 then
		temp18 = r_1731
	else
		local r_1741 = (tag6 == "number")
		if r_1741 then
			temp18 = r_1741
		else
			local r_1751 = (tag6 == "key")
			if r_1751 then
				temp18 = r_1751
			else
				temp18 = (tag6 == "symbol")
			end
		end
	end
	if temp18 then
		return visitor6(node11, visitor6)
	elseif (tag6 == "list") then
		local first4 = car2(node11)
		first4 = visitor6(first4, visitor6)
		node11[1] = first4
		if (first4["tag"] == "symbol") then
			local func4 = first4["var"]
			local funct2 = func4["tag"]
			if (func4 == builtins3["lambda"]) then
				traverseBlock1(node11, 3, visitor6)
				return visitor6(node11, visitor6)
			elseif (func4 == builtins3["cond"]) then
				local r_1991 = _23_1(node11)
				local r_1971 = nil
				r_1971 = (function(r_1981)
					if (r_1981 <= r_1991) then
						local case2 = nth1(node11, r_1981)
						case2[1] = traverseNode1(nth1(case2, 1), visitor6)
						traverseBlock1(case2, 2, visitor6)
						return r_1971((r_1981 + 1))
					else
					end
				end)
				r_1971(2)
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
				local temp19
				local r_2011 = (func4 == builtins3["unquote"])
				if r_2011 then
					temp19 = r_2011
				else
					temp19 = (func4 == builtins3["unquote-splice"])
				end
				if temp19 then
					return fail_21_1("unquote/unquote-splice should never appear head")
				else
					local temp20
					local r_2021 = (func4 == builtins3["define"])
					if r_2021 then
						temp20 = r_2021
					else
						temp20 = (func4 == builtins3["define-macro"])
					end
					if temp20 then
						node11[_23_1(node11)] = traverseNode1(nth1(node11, _23_1(node11)), visitor6)
						return visitor6(node11, visitor6)
					elseif (func4 == builtins3["define-native"]) then
						return visitor6(node11, visitor6)
					elseif (func4 == builtins3["import"]) then
						return visitor6(node11, visitor6)
					else
						local temp21
						local r_2031 = (funct2 == "defined")
						if r_2031 then
							temp21 = r_2031
						else
							local r_2041 = (funct2 == "arg")
							if r_2041 then
								temp21 = r_2041
							else
								local r_2051 = (funct2 == "native")
								if r_2051 then
									temp21 = r_2051
								else
									temp21 = (funct2 == "macro")
								end
							end
						end
						if temp21 then
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
	local r_1781 = _23_1(node12)
	local r_1761 = nil
	r_1761 = (function(r_1771)
		if (r_1771 <= r_1781) then
			local result1 = traverseNode1(nth1(node12, (r_1771 + 0)), visitor7)
			node12[r_1771] = result1
			return r_1761((r_1771 + 1))
		else
		end
	end)
	r_1761(start3)
	return node12
end)
traverseList1 = (function(node13, start4, visitor8)
	local r_1821 = _23_1(node13)
	local r_1801 = nil
	r_1801 = (function(r_1811)
		if (r_1811 <= r_1821) then
			node13[r_1811] = traverseNode1(nth1(node13, r_1811), visitor8)
			return r_1801((r_1811 + 1))
		else
		end
	end)
	r_1801(start4)
	return node13
end)
config1 = package.config
coloredAnsi1 = (function(col1, msg1)
	return _2e2e_2("\27[", col1, "m", msg1, "\27[0m")
end)
local temp22
if config1 then
	temp22 = (charAt1(config1, 1) ~= "\\")
else
	temp22 = config1
end
if temp22 then
	colored_3f_1 = true
else
	local temp23
	if getenv1 then
		temp23 = (getenv1("ANSICON") ~= nil)
	else
		temp23 = getenv1
	end
	if temp23 then
		colored_3f_1 = true
	else
		local temp24
		if getenv1 then
			local term1 = getenv1("TERM")
			if term1 then
				temp24 = find1(term1, "xterm")
			else
				temp24 = nil
			end
		else
			temp24 = getenv1
		end
		if temp24 then
			colored_3f_1 = true
		else
			colored_3f_1 = false
		end
	end
end
if colored_3f_1 then
	colored1 = coloredAnsi1
else
	colored1 = (function(col2, msg2)
		return msg2
	end)
end
abs1 = math.abs
huge1 = math.huge
max1 = math.max
modf1 = math.modf
verbosity1 = struct1("value", 0)
setVerbosity_21_1 = (function(level3)
	verbosity1["value"] = level3
	return nil
end)
showExplain1 = struct1("value", false)
setExplain_21_1 = (function(value3)
	showExplain1["value"] = value3
	return nil
end)
printError_21_1 = (function(msg3)
	if string_3f_1(msg3) then
	else
		msg3 = pretty1(msg3)
	end
	local lines1 = split1(msg3, "\n", 1)
	print1(colored1(31, _2e2e_2("[ERROR] ", car2(lines1))))
	if cadr1(lines1) then
		return print1(cadr1(lines1))
	else
	end
end)
printWarning_21_1 = (function(msg4)
	local lines2 = split1(msg4, "\n", 1)
	print1(colored1(33, _2e2e_2("[WARN] ", car2(lines2))))
	if cadr1(lines2) then
		return print1(cadr1(lines2))
	else
	end
end)
printVerbose_21_1 = (function(msg5)
	if (verbosity1["value"] > 0) then
		return print1(_2e2e_2("[VERBOSE] ", msg5))
	else
	end
end)
printDebug_21_1 = (function(msg6)
	if (verbosity1["value"] > 1) then
		return print1(_2e2e_2("[DEBUG] ", msg6))
	else
	end
end)
formatPosition1 = (function(pos2)
	return _2e2e_2(pos2["line"], ":", pos2["column"])
end)
formatRange1 = (function(range1)
	if range1["finish"] then
		return format1("%s:[%s .. %s]", range1["name"], formatPosition1(range1["start"]), formatPosition1(range1["finish"]))
	else
		return format1("%s:[%s]", range1["name"], formatPosition1(range1["start"]))
	end
end)
formatNode1 = (function(node14)
	local temp25
	local r_2061 = node14["range"]
	if r_2061 then
		temp25 = node14["contents"]
	else
		temp25 = r_2061
	end
	if temp25 then
		return format1("%s (%q)", formatRange1(node14["range"]), node14["contents"])
	elseif node14["range"] then
		return formatRange1(node14["range"])
	elseif node14["macro"] then
		local macro1 = node14["macro"]
		return format1("macro expansion of %s (%s)", macro1["var"]["name"], formatNode1(macro1["node"]))
	else
		local temp26
		local r_2191 = node14["start"]
		if r_2191 then
			temp26 = node14["finish"]
		else
			temp26 = r_2191
		end
		if temp26 then
			return formatRange1(node14)
		else
			return "?"
		end
	end
end)
getSource1 = (function(node15)
	local result2 = nil
	local r_2071 = nil
	r_2071 = (function()
		local temp27
		local r_2081 = node15
		if r_2081 then
			temp27 = _21_1(result2)
		else
			temp27 = r_2081
		end
		if temp27 then
			result2 = node15["range"]
			node15 = node15["parent"]
			return r_2071()
		else
		end
	end)
	r_2071()
	return result2
end)
putLines_21_1 = (function(range2, ...)
	local entries1 = _pack(...) entries1.tag = "list"
	if nil_3f_1(entries1) then
		error1("Positions cannot be empty")
	else
	end
	if ((_23_1(entries1) % 2) ~= 0) then
		error1(_2e2e_2("Positions must be a multiple of 2, is ", _23_1(entries1)))
	else
	end
	local previous1 = -1
	local file1 = nth1(entries1, 1)["name"]
	local maxLine1 = foldr1((function(node16, max2)
		if string_3f_1(node16) then
			return max2
		else
			return max1(max2, node16["start"]["line"])
		end
	end), 0, entries1)
	local code1 = _2e2e_2(colored1(92, _2e2e_2(" %", len1(tostring1(maxLine1)), "s |")), " %s")
	local r_2221 = _23_1(entries1)
	local r_2201 = nil
	r_2201 = (function(r_2211)
		if (r_2211 <= r_2221) then
			local position1 = entries1[r_2211]
			local message1 = entries1[succ1(r_2211)]
			if (file1 ~= position1["name"]) then
				file1 = position1["name"]
				print1(colored1(95, _2e2e_2(" ", file1)))
			else
				local temp28
				local r_2241 = (previous1 ~= -1)
				if r_2241 then
					temp28 = (abs1((position1["start"]["line"] - previous1)) > 2)
				else
					temp28 = r_2241
				end
				if temp28 then
					print1(colored1(92, " ..."))
				else
				end
			end
			previous1 = position1["start"]["line"]
			print1(format1(code1, tostring1(position1["start"]["line"]), position1["lines"][position1["start"]["line"]]))
			local pointer1
			if _21_1(range2) then
				pointer1 = "^"
			else
				local temp29
				local r_2251 = position1["finish"]
				if r_2251 then
					temp29 = (position1["start"]["line"] == position1["finish"]["line"])
				else
					temp29 = r_2251
				end
				if temp29 then
					pointer1 = rep1("^", succ1((position1["finish"]["column"] - position1["start"]["column"])))
				else
					pointer1 = "^..."
				end
			end
			print1(format1(code1, "", _2e2e_2(rep1(" ", (position1["start"]["column"] - 1)), pointer1, " ", message1)))
			return r_2201((r_2211 + 2))
		else
		end
	end)
	return r_2201(1)
end)
putTrace_21_1 = (function(node17)
	local previous2 = nil
	local r_2091 = nil
	r_2091 = (function()
		if node17 then
			local formatted1 = formatNode1(node17)
			if (previous2 == nil) then
				print1(colored1(96, _2e2e_2("  => ", formatted1)))
			elseif (previous2 ~= formatted1) then
				print1(_2e2e_2("  in ", formatted1))
			else
			end
			previous2 = formatted1
			node17 = node17["parent"]
			return r_2091()
		else
		end
	end)
	return r_2091()
end)
putExplain_21_1 = (function(...)
	local lines3 = _pack(...) lines3.tag = "list"
	if showExplain1["value"] then
		local r_2141 = _23_1(lines3)
		local r_2121 = nil
		r_2121 = (function(r_2131)
			if (r_2131 <= r_2141) then
				local line1 = lines3[r_2131]
				print1(_2e2e_2("  ", line1))
				return r_2121((r_2131 + 1))
			else
			end
		end)
		return r_2121(1)
	else
	end
end)
errorPositions_21_1 = (function(node18, msg7)
	printError_21_1(msg7)
	putTrace_21_1(node18)
	local source1 = getSource1(node18)
	if source1 then
		putLines_21_1(true, source1, "")
	else
	end
	return fail_21_1("An error occured")
end)
struct1("colored", colored1, "formatPosition", formatPosition1, "formatRange", formatRange1, "formatNode", formatNode1, "putLines", putLines_21_1, "putTrace", putTrace_21_1, "putInfo", putExplain_21_1, "getSource", getSource1, "printWarning", printWarning_21_1, "printError", printError_21_1, "printVerbose", printVerbose_21_1, "printDebug", printDebug_21_1, "errorPositions", errorPositions_21_1, "setVerbosity", setVerbosity_21_1, "setExplain", setExplain_21_1)
builtins4 = require1("tacky.analysis.resolve")["builtins"]
builtinVars2 = require1("tacky.analysis.resolve")["declaredVars"]
hasSideEffect1 = (function(node19)
	local tag7 = type1(node19)
	local temp30
	local r_961 = (tag7 == "number")
	if r_961 then
		temp30 = r_961
	else
		local r_971 = (tag7 == "string")
		if r_971 then
			temp30 = r_971
		else
			local r_981 = (tag7 == "key")
			if r_981 then
				temp30 = r_981
			else
				temp30 = (tag7 == "symbol")
			end
		end
	end
	if temp30 then
		return false
	elseif (tag7 == "list") then
		local fst1 = car2(node19)
		if (type1(fst1) == "symbol") then
			local var5 = fst1["var"]
			local r_991 = (var5 ~= builtins4["lambda"])
			if r_991 then
				return (var5 ~= builtins4["quote"])
			else
				return r_991
			end
		else
			return true
		end
	else
		_error("unmatched item")
	end
end)
constant_3f_1 = (function(node20)
	local r_1001 = string_3f_1(node20)
	if r_1001 then
		return r_1001
	else
		local r_1011 = number_3f_1(node20)
		if r_1011 then
			return r_1011
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
val_2d3e_urn1 = (function(val6)
	local ty3 = type_23_1(val6)
	if (ty3 == "string") then
		return struct1("tag", "string", "value", val6)
	elseif (ty3 == "number") then
		return struct1("tag", "number", "value", val6)
	elseif (ty3 == "nil") then
		return struct1("tag", "symbol", "contents", "nil", "var", builtinVars2["nil"])
	elseif (ty3 == "boolean") then
		return struct1("tag", "symbol", "contents", tostring1(val6), "var", builtinVars2[tostring1(val6)])
	else
		_error("unmatched item")
	end
end)
truthy_3f_1 = (function(node22)
	local temp31
	local r_1021 = string_3f_1(node22)
	if r_1021 then
		temp31 = r_1021
	else
		local r_1031 = key_3f_1(node22)
		if r_1031 then
			temp31 = r_1031
		else
			temp31 = number_3f_1(node22)
		end
	end
	if temp31 then
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
	local def2 = getVar1(lookup1, sym1["var"])
	if (1 == _23_keys1(def2["defs"])) then
		local ent1 = nth1(list1(next1(def2["defs"])), 2)
		local val7 = ent1["value"]
		local ty4 = ent1["tag"]
		local temp32
		local r_2261 = string_3f_1(val7)
		if r_2261 then
			temp32 = r_2261
		else
			local r_2271 = number_3f_1(val7)
			if r_2271 then
				temp32 = r_2271
			else
				temp32 = key_3f_1(val7)
			end
		end
		if temp32 then
			return val7
		else
			local temp33
			local r_2281 = symbol_3f_1(val7)
			if r_2281 then
				local r_2291 = (ty4 == "define")
				if r_2291 then
					temp33 = r_2291
				else
					local r_2301 = (ty4 == "set")
					if r_2301 then
						temp33 = r_2301
					else
						temp33 = (ty4 == "let")
					end
				end
			else
				temp33 = r_2281
			end
			if temp33 then
				local r_2311 = getConstantVal1(lookup1, val7)
				if r_2311 then
					return r_2311
				else
					return sym1
				end
			else
				return sym1
			end
		end
	else
	end
end)
optimiseOnce1 = (function(nodes3, state8)
	local changed1 = false
	local r_1041 = nil
	r_1041 = (function(r_1051)
		local temp34
		if false then
			temp34 = (r_1051 <= 1)
		else
			temp34 = (r_1051 >= 1)
		end
		if temp34 then
			local node23 = nth1(nodes3, r_1051)
			local temp35
			local r_1081 = list_3f_1(node23)
			if r_1081 then
				local r_1091 = (_23_1(node23) > 0)
				if r_1091 then
					local r_1101 = symbol_3f_1(car2(node23))
					if r_1101 then
						temp35 = (car2(node23)["var"] == builtins4["import"])
					else
						temp35 = r_1101
					end
				else
					temp35 = r_1091
				end
			else
				temp35 = r_1081
			end
			if temp35 then
				if (r_1051 == _23_1(nodes3)) then
					nodes3[r_1051] = struct1("tag", "symbol", "contents", "nil", "var", builtinVars2["nil"])
				else
					removeNth_21_1(nodes3, r_1051)
				end
				changed1 = true
			else
			end
			return r_1041((r_1051 + -1))
		else
		end
	end)
	r_1041(_23_1(nodes3))
	local r_2321 = nil
	r_2321 = (function(r_2331)
		local temp36
		if false then
			temp36 = (r_2331 <= 1)
		else
			temp36 = (r_2331 >= 1)
		end
		if temp36 then
			local node24 = nth1(nodes3, r_2331)
			if _21_1(hasSideEffect1(node24)) then
				removeNth_21_1(nodes3, r_2331)
				changed1 = true
			else
			end
			return r_2321((r_2331 + -1))
		else
		end
	end)
	r_2321(pred1(_23_1(nodes3)))
	traverseList1(nodes3, 1, (function(node25)
		local temp37
		local r_2361 = list_3f_1(node25)
		if r_2361 then
			temp37 = all1(constant_3f_1, cdr2(node25))
		else
			temp37 = r_2361
		end
		if temp37 then
			local head2 = car2(node25)
			local meta1
			local r_2411 = symbol_3f_1(head2)
			if r_2411 then
				local r_2421 = _21_1(head2["folded"])
				if r_2421 then
					local r_2431 = (head2["var"]["tag"] == "native")
					if r_2431 then
						meta1 = state8["meta"][head2["var"]["fullName"]]
					else
						meta1 = r_2431
					end
				else
					meta1 = r_2421
				end
			else
				meta1 = r_2411
			end
			local temp38
			if meta1 then
				local r_2381 = meta1["pure"]
				if r_2381 then
					temp38 = meta1["value"]
				else
					temp38 = r_2381
				end
			else
				temp38 = meta1
			end
			if temp38 then
				local res1 = list1(pcall1(meta1["value"], unpack1(map1(urn_2d3e_val1, cdr2(node25)))))
				if car2(res1) then
					local val8 = nth1(res1, 2)
					local temp39
					local r_2391 = number_3f_1(val8)
					if r_2391 then
						local r_2401 = (snd1(pair1(modf1(val8))) ~= 0)
						if r_2401 then
							temp39 = r_2401
						else
							temp39 = (abs1(val8) == huge1)
						end
					else
						temp39 = r_2391
					end
					if temp39 then
						head2["folded"] = true
						return node25
					else
						return val_2d3e_urn1(val8)
					end
				else
					head2["folded"] = true
					printWarning_21_1(_2e2e_2("Cannot execute constant expression"))
					putTrace_21_1(node25)
					putLines_21_1(true, getSource1(node25), _2e2e_2("Executed ", pretty1(node25), ", failed with: ", nth1(res1, 2)))
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
		local temp40
		local r_2441 = list_3f_1(node26)
		if r_2441 then
			local r_2451 = symbol_3f_1(car2(node26))
			if r_2451 then
				temp40 = (car2(node26)["var"] == builtins4["cond"])
			else
				temp40 = r_2451
			end
		else
			temp40 = r_2441
		end
		if temp40 then
			local final1 = nil
			local r_2481 = _23_1(node26)
			local r_2461 = nil
			r_2461 = (function(r_2471)
				if (r_2471 <= r_2481) then
					local case3 = nth1(node26, r_2471)
					if final1 then
						changed1 = true
						removeNth_21_1(node26, final1)
					elseif truthy_3f_1(car2(nth1(node26, r_2471))) then
						final1 = succ1(r_2471)
					else
					end
					return r_2461((r_2471 + 1))
				else
				end
			end)
			r_2461(2)
			local temp41
			local r_2501 = (_23_1(node26) == 2)
			if r_2501 then
				temp41 = truthy_3f_1(car2(nth1(node26, 2)))
			else
				temp41 = r_2501
			end
			if temp41 then
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
	local r_2511 = nil
	r_2511 = (function(r_2521)
		local temp42
		if false then
			temp42 = (r_2521 <= 1)
		else
			temp42 = (r_2521 >= 1)
		end
		if temp42 then
			local node27 = nth1(nodes3, r_2521)
			local temp43
			local r_2551 = node27["defVar"]
			if r_2551 then
				temp43 = _21_1(getVar1(lookup2, node27["defVar"])["active"])
			else
				temp43 = r_2551
			end
			if temp43 then
				if (r_2521 == _23_1(nodes3)) then
					nodes3[r_2521] = struct1("tag", "symbol", "contents", "nil", "var", builtinVars2["nil"])
				else
					removeNth_21_1(nodes3, r_2521)
				end
				changed1 = true
			else
			end
			return r_2511((r_2521 + -1))
		else
		end
	end)
	r_2511(_23_1(nodes3))
	visitBlock1(nodes3, 1, (function(node28)
		local temp44
		local r_2561 = list_3f_1(node28)
		if r_2561 then
			local r_2571 = list_3f_1(car2(node28))
			if r_2571 then
				local r_2581 = symbol_3f_1(caar1(node28))
				if r_2581 then
					temp44 = (caar1(node28)["var"] == builtins4["lambda"])
				else
					temp44 = r_2581
				end
			else
				temp44 = r_2571
			end
		else
			temp44 = r_2561
		end
		if temp44 then
			local lam2 = car2(node28)
			local args3 = nth1(lam2, 2)
			local offset2 = 1
			local remOffset1 = 0
			local r_2611 = _23_1(args3)
			local r_2591 = nil
			r_2591 = (function(r_2601)
				if (r_2601 <= r_2611) then
					local arg3 = nth1(args3, (r_2601 - remOffset1))
					local val9 = nth1(node28, ((r_2601 + offset2) - remOffset1))
					if arg3["var"]["isVariadic"] then
						local count2 = (_23_1(node28) - _23_1(args3))
						if (count2 < 0) then
							count2 = 0
						else
						end
						offset2 = count2
					elseif (nil == val9) then
					elseif hasSideEffect1(val9) then
					elseif (_23_keys1(getVar1(lookup2, arg3["var"])["usages"]) > 0) then
					else
						removeNth_21_1(args3, (r_2601 - remOffset1))
						removeNth_21_1(node28, ((r_2601 + offset2) - remOffset1))
						remOffset1 = (remOffset1 + 1)
					end
					return r_2591((r_2601 + 1))
				else
				end
			end)
			return r_2591(1)
		else
		end
	end))
	traverseList1(nodes3, 1, (function(node29)
		if symbol_3f_1(node29) then
			local var6 = getConstantVal1(lookup2, node29)
			local temp45
			if var6 then
				temp45 = (var6 ~= node29)
			else
				temp45 = var6
			end
			if temp45 then
				changed1 = true
				return var6
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
		state9 = struct1("meta", {})
	end
	local iteration1 = 0
	local changed2 = true
	local r_2631 = nil
	r_2631 = (function()
		local temp46
		local r_2641 = changed2
		if r_2641 then
			temp46 = (iteration1 < 10)
		else
			temp46 = r_2641
		end
		if temp46 then
			changed2 = optimiseOnce1(nodes4, state9)
			iteration1 = (iteration1 + 1)
			return r_2631()
		else
		end
	end)
	r_2631()
	return nodes4
end)
return optimise1
