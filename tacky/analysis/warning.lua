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
local _3d_1, _2f3d_1, _3c_1, _3c3d_1, _3e_1, _3e3d_1, _2b_1, _2d_1, _25_1, _2e2e_1, slice1, error1, next1, print1, getIdx1, setIdx_21_1, require1, tonumber1, tostring1, type_23_1, _23_1, find1, format1, len1, rep1, sub1, concat1, remove1, unpack1, emptyStruct1, iterPairs1, car1, cdr1, list1, cons1, _21_1, pretty1, list_3f_1, nil_3f_1, string_3f_1, symbol_3f_1, key_3f_1, exists_3f_1, type1, car2, cdr2, foldr1, map1, any1, nth1, pushCdr_21_1, removeNth_21_1, reverse1, caar1, cadr1, charAt1, _2e2e_2, split1, getenv1, struct1, _23_keys1, succ1, pred1, symbol_2d3e_string1, fail_21_1, builtins1, visitQuote1, visitNode1, visitBlock1, builtins2, builtinVars1, createState1, getVar1, getNode1, addUsage_21_1, addDefinition_21_1, definitionsVisitor1, definitionsVisit1, usagesVisit1, config1, coloredAnsi1, colored_3f_1, colored1, abs1, max1, verbosity1, setVerbosity_21_1, showExplain1, setExplain_21_1, printError_21_1, printWarning_21_1, printVerbose_21_1, printDebug_21_1, formatPosition1, formatRange1, formatNode1, getSource1, putLines_21_1, putTrace_21_1, putExplain_21_1, errorPositions_21_1, builtins3, sideEffect_3f_1, warnArity1, analyse1
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
print1 = print
getIdx1 = function(v1, v2) return v1[v2] end
setIdx_21_1 = function(v1, v2, v3) v1[v2] = v3 end
require1 = require
tonumber1 = tonumber
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
list_3f_1 = (function(x3)
	return (type1(x3) == "list")
end)
nil_3f_1 = (function(x4)
	if x4 then
		local r_81 = list_3f_1(x4)
		if r_81 then
			return (_23_1(x4) == 0)
		else
			return r_81
		end
	else
		return x4
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
car2 = (function(x9)
	local r_281 = type1(x9)
	if (r_281 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_281), 2)
	else
	end
	return car1(x9)
end)
cdr2 = (function(x10)
	local r_291 = type1(x10)
	if (r_291 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_291), 2)
	else
	end
	if nil_3f_1(x10) then
		return {tag = "list", n = 0}
	else
		return cdr1(x10)
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
any1 = (function(p1, xs7)
	local r_331 = type1(p1)
	if (r_331 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "p", "function", r_331), 2)
	else
	end
	local r_451 = type1(xs7)
	if (r_451 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_451), 2)
	else
	end
	return foldr1((function(x11, y1)
		if x11 then
			return x11
		else
			return y1
		end
	end), false, map1(p1, xs7))
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
caar1 = (function(x12)
	return car2(car2(x12))
end)
cadr1 = (function(x13)
	return car2(cdr2(x13))
end)
charAt1 = (function(xs11, x14)
	return sub1(xs11, x14, x14)
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
succ1 = (function(x15)
	return (x15 + 1)
end)
pred1 = (function(x16)
	return (x16 - 1)
end)
symbol_2d3e_string1 = (function(x17)
	if symbol_3f_1(x17) then
		return x17["contents"]
	else
		return nil
	end
end)
fail_21_1 = (function(x18)
	return error1(x18, 0)
end)
builtins1 = require1("tacky.analysis.resolve")["builtins"]
visitQuote1 = (function(node1, visitor1, level1)
	if (level1 == 0) then
		return visitNode1(node1, visitor1)
	else
		local tag3 = node1["tag"]
		local temp2
		local r_1151 = (tag3 == "string")
		if r_1151 then
			temp2 = r_1151
		else
			local r_1161 = (tag3 == "number")
			if r_1161 then
				temp2 = r_1161
			else
				local r_1171 = (tag3 == "key")
				if r_1171 then
					temp2 = r_1171
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
				local r_1191 = (first1["contents"] == "unquote")
				if r_1191 then
					temp4 = r_1191
				else
					temp4 = (first1["contents"] == "unquote-splice")
				end
				if temp4 then
					return visitQuote1(nth1(node1, 2), visitor1, pred1(level1))
				elseif (first1["contents"] == "syntax-quote") then
					return visitQuote1(nth1(node1, 2), visitor1, succ1(level1))
				else
					local r_1241 = _23_1(node1)
					local r_1221 = nil
					r_1221 = (function(r_1231)
						if (r_1231 <= r_1241) then
							local sub2 = node1[r_1231]
							visitQuote1(sub2, visitor1, level1)
							return r_1221((r_1231 + 1))
						else
						end
					end)
					return r_1221(1)
				end
			else
				local r_1301 = _23_1(node1)
				local r_1281 = nil
				r_1281 = (function(r_1291)
					if (r_1291 <= r_1301) then
						local sub3 = node1[r_1291]
						visitQuote1(sub3, visitor1, level1)
						return r_1281((r_1291 + 1))
					else
					end
				end)
				return r_1281(1)
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
		local r_1321 = (tag4 == "string")
		if r_1321 then
			temp5 = r_1321
		else
			local r_1331 = (tag4 == "number")
			if r_1331 then
				temp5 = r_1331
			else
				local r_1341 = (tag4 == "key")
				if r_1341 then
					temp5 = r_1341
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
					local r_1371 = _23_1(node2)
					local r_1351 = nil
					r_1351 = (function(r_1361)
						if (r_1361 <= r_1371) then
							local case1 = nth1(node2, r_1361)
							visitNode1(nth1(case1, 1), visitor2)
							visitBlock1(case1, 2, visitor2)
							return r_1351((r_1361 + 1))
						else
						end
					end)
					return r_1351(2)
				elseif (func1 == builtins1["set!"]) then
					return visitNode1(nth1(node2, 3), visitor2)
				elseif (func1 == builtins1["quote"]) then
				elseif (func1 == builtins1["syntax-quote"]) then
					return visitQuote1(nth1(node2, 2), visitor2, 1)
				else
					local temp6
					local r_1391 = (func1 == builtins1["unquote"])
					if r_1391 then
						temp6 = r_1391
					else
						temp6 = (func1 == builtins1["unquote-splice"])
					end
					if temp6 then
						return fail_21_1("unquote/unquote-splice should never appear head")
					else
						local temp7
						local r_1401 = (func1 == builtins1["define"])
						if r_1401 then
							temp7 = r_1401
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
							local r_1411 = (funct1 == "defined")
							if r_1411 then
								temp8 = r_1411
							else
								local r_1421 = (funct1 == "arg")
								if r_1421 then
									temp8 = r_1421
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
	local r_1131 = _23_1(node3)
	local r_1111 = nil
	r_1111 = (function(r_1121)
		if (r_1121 <= r_1131) then
			visitNode1(nth1(node3, r_1121), visitor3)
			return r_1111((r_1121 + 1))
		else
		end
	end)
	return r_1111(start2)
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
	local r_1001 = list_3f_1(node7)
	if r_1001 then
		temp9 = symbol_3f_1(car2(node7))
	else
		temp9 = r_1001
	end
	if temp9 then
		local func2 = car2(node7)["var"]
		if (func2 == builtins2["lambda"]) then
			local r_1021 = nth1(node7, 2)
			local r_1051 = _23_1(r_1021)
			local r_1031 = nil
			r_1031 = (function(r_1041)
				if (r_1041 <= r_1051) then
					local arg1 = r_1021[r_1041]
					addDefinition_21_1(state5, arg1["var"], arg1, "arg", arg1)
					return r_1031((r_1041 + 1))
				else
				end
			end)
			return r_1031(1)
		elseif (func2 == builtins2["set!"]) then
			return addDefinition_21_1(state5, node7[2]["var"], node7, "set", nth1(node7, 3))
		else
			local temp10
			local r_1071 = (func2 == builtins2["define"])
			if r_1071 then
				temp10 = r_1071
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
		local r_1081 = list_3f_1(node7)
		if r_1081 then
			local r_1091 = list_3f_1(car2(node7))
			if r_1091 then
				local r_1101 = symbol_3f_1(caar1(node7))
				if r_1101 then
					temp11 = (caar1(node7)["var"] == builtins2["lambda"])
				else
					temp11 = r_1101
				end
			else
				temp11 = r_1091
			end
		else
			temp11 = r_1081
		end
		if temp11 then
			local lam1 = car2(node7)
			local args2 = nth1(lam1, 2)
			local offset1 = 1
			local r_1451 = _23_1(args2)
			local r_1431 = nil
			r_1431 = (function(r_1441)
				if (r_1441 <= r_1451) then
					local arg2 = nth1(args2, r_1441)
					local val4 = nth1(node7, (r_1441 + offset1))
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
					return r_1431((r_1441 + 1))
				else
				end
			end)
			r_1431(1)
			visitBlock1(node7, 2, visitor4)
			visitBlock1(lam1, 3, visitor4)
			return false
		else
		end
	end
end)
definitionsVisit1 = (function(state6, nodes1)
	return visitBlock1(nodes1, 1, (function(r_1551, r_1561)
		return definitionsVisitor1(state6, r_1551, r_1561)
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
				local r_1571 = list_3f_1(node8)
				if r_1571 then
					local r_1581 = (_23_1(node8) > 0)
					if r_1581 then
						temp13 = symbol_3f_1(car2(node8))
					else
						temp13 = r_1581
					end
				else
					temp13 = r_1571
				end
				if temp13 then
					local func3 = car2(node8)["var"]
					local temp14
					local r_1591 = (func3 == builtins2["set!"])
					if r_1591 then
						temp14 = r_1591
					else
						local r_1601 = (func3 == builtins2["define"])
						if r_1601 then
							temp14 = r_1601
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
	local r_1521 = _23_1(nodes2)
	local r_1501 = nil
	r_1501 = (function(r_1511)
		if (r_1511 <= r_1521) then
			local node9 = nodes2[r_1511]
			pushCdr_21_1(queue1, node9)
			return r_1501((r_1511 + 1))
		else
		end
	end)
	r_1501(1)
	local r_1541 = nil
	r_1541 = (function()
		if (_23_1(queue1) > 0) then
			visitNode1(removeNth_21_1(queue1, 1), visit1)
			return r_1541()
		else
		end
	end)
	return r_1541()
end)
config1 = package.config
coloredAnsi1 = (function(col1, msg1)
	return _2e2e_2("\27[", col1, "m", msg1, "\27[0m")
end)
local temp15
if config1 then
	temp15 = (charAt1(config1, 1) ~= "\\")
else
	temp15 = config1
end
if temp15 then
	colored_3f_1 = true
else
	local temp16
	if getenv1 then
		temp16 = (getenv1("ANSICON") ~= nil)
	else
		temp16 = getenv1
	end
	if temp16 then
		colored_3f_1 = true
	else
		local temp17
		if getenv1 then
			local term1 = getenv1("TERM")
			if term1 then
				temp17 = find1(term1, "xterm")
			else
				temp17 = nil
			end
		else
			temp17 = getenv1
		end
		if temp17 then
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
max1 = math.max
verbosity1 = struct1("value", 0)
setVerbosity_21_1 = (function(level2)
	verbosity1["value"] = level2
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
formatNode1 = (function(node10)
	local temp18
	local r_1621 = node10["range"]
	if r_1621 then
		temp18 = node10["contents"]
	else
		temp18 = r_1621
	end
	if temp18 then
		return format1("%s (%q)", formatRange1(node10["range"]), node10["contents"])
	elseif node10["range"] then
		return formatRange1(node10["range"])
	elseif node10["macro"] then
		local macro1 = node10["macro"]
		return format1("macro expansion of %s (%s)", macro1["var"]["name"], formatNode1(macro1["node"]))
	else
		local temp19
		local r_1751 = node10["start"]
		if r_1751 then
			temp19 = node10["finish"]
		else
			temp19 = r_1751
		end
		if temp19 then
			return formatRange1(node10)
		else
			return "?"
		end
	end
end)
getSource1 = (function(node11)
	local result1 = nil
	local r_1631 = nil
	r_1631 = (function()
		local temp20
		local r_1641 = node11
		if r_1641 then
			temp20 = _21_1(result1)
		else
			temp20 = r_1641
		end
		if temp20 then
			result1 = node11["range"]
			node11 = node11["parent"]
			return r_1631()
		else
		end
	end)
	r_1631()
	return result1
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
	local maxLine1 = foldr1((function(node12, max2)
		if string_3f_1(node12) then
			return max2
		else
			return max1(max2, node12["start"]["line"])
		end
	end), 0, entries1)
	local code1 = _2e2e_2(colored1(92, _2e2e_2(" %", len1(tostring1(maxLine1)), "s |")), " %s")
	local r_1781 = _23_1(entries1)
	local r_1761 = nil
	r_1761 = (function(r_1771)
		if (r_1771 <= r_1781) then
			local position1 = entries1[r_1771]
			local message1 = entries1[succ1(r_1771)]
			if (file1 ~= position1["name"]) then
				file1 = position1["name"]
				print1(colored1(95, _2e2e_2(" ", file1)))
			else
				local temp21
				local r_1801 = (previous1 ~= -1)
				if r_1801 then
					temp21 = (abs1((position1["start"]["line"] - previous1)) > 2)
				else
					temp21 = r_1801
				end
				if temp21 then
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
				local temp22
				local r_1811 = position1["finish"]
				if r_1811 then
					temp22 = (position1["start"]["line"] == position1["finish"]["line"])
				else
					temp22 = r_1811
				end
				if temp22 then
					pointer1 = rep1("^", succ1((position1["finish"]["column"] - position1["start"]["column"])))
				else
					pointer1 = "^..."
				end
			end
			print1(format1(code1, "", _2e2e_2(rep1(" ", (position1["start"]["column"] - 1)), pointer1, " ", message1)))
			return r_1761((r_1771 + 2))
		else
		end
	end)
	return r_1761(1)
end)
putTrace_21_1 = (function(node13)
	local previous2 = nil
	local r_1651 = nil
	r_1651 = (function()
		if node13 then
			local formatted1 = formatNode1(node13)
			if (previous2 == nil) then
				print1(colored1(96, _2e2e_2("  => ", formatted1)))
			elseif (previous2 ~= formatted1) then
				print1(_2e2e_2("  in ", formatted1))
			else
			end
			previous2 = formatted1
			node13 = node13["parent"]
			return r_1651()
		else
		end
	end)
	return r_1651()
end)
putExplain_21_1 = (function(...)
	local lines3 = _pack(...) lines3.tag = "list"
	if showExplain1["value"] then
		local r_1701 = _23_1(lines3)
		local r_1681 = nil
		r_1681 = (function(r_1691)
			if (r_1691 <= r_1701) then
				local line1 = lines3[r_1691]
				print1(_2e2e_2("  ", line1))
				return r_1681((r_1691 + 1))
			else
			end
		end)
		return r_1681(1)
	else
	end
end)
errorPositions_21_1 = (function(node14, msg7)
	printError_21_1(msg7)
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
	local tag5 = type1(node15)
	local temp23
	local r_961 = (tag5 == "number")
	if r_961 then
		temp23 = r_961
	else
		local r_971 = (tag5 == "string")
		if r_971 then
			temp23 = r_971
		else
			local r_981 = (tag5 == "key")
			if r_981 then
				temp23 = r_981
			else
				temp23 = (tag5 == "symbol")
			end
		end
	end
	if temp23 then
		return false
	elseif (tag5 == "list") then
		local fst1 = car2(node15)
		if (type1(fst1) == "symbol") then
			local var5 = fst1["var"]
			local r_991 = (var5 ~= builtins3["lambda"])
			if r_991 then
				return (var5 ~= builtins3["quote"])
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
warnArity1 = (function(lookup1, nodes3)
	local arity1
	local getArity1
	arity1 = {}
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
					local temp24
					local r_1821 = list_3f_1(def2)
					if r_1821 then
						local r_1831 = symbol_3f_1(car2(def2))
						if r_1831 then
							temp24 = (car2(def2)["var"] == builtins3["lambda"])
						else
							temp24 = r_1831
						end
					else
						temp24 = r_1821
					end
					if temp24 then
						local args3 = nth1(def2, 2)
						if any1((function(x19)
							return x19["var"]["isVariadic"]
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
		local temp25
		local r_1841 = list_3f_1(node16)
		if r_1841 then
			temp25 = symbol_3f_1(car2(node16))
		else
			temp25 = r_1841
		end
		if temp25 then
			local arity2 = getArity1(car2(node16))
			local temp26
			if arity2 then
				temp26 = (arity2 < pred1(_23_1(node16)))
			else
				temp26 = arity2
			end
			if temp26 then
				printWarning_21_1(_2e2e_2("Calling ", symbol_2d3e_string1(car2(node16)), " with ", tonumber1(pred1(_23_1(node16))), " arguments, expected ", tonumber1(arity2)))
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
