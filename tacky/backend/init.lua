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
local _3d_1, _2f3d_1, _3c_1, _3c3d_1, _3e_1, _3e3d_1, _2b_1, _2d_1, _25_1, slice1, error1, print1, getIdx1, setIdx_21_1, require1, tonumber1, tostring1, type_23_1, _23_1, byte1, find1, format1, gsub1, len1, match1, rep1, sub1, upper1, concat1, sort1, unpack1, emptyStruct1, iterPairs1, car1, cdr1, list1, cons1, _21_1, list_3f_1, nil_3f_1, string_3f_1, number_3f_1, symbol_3f_1, key_3f_1, exists_3f_1, type1, car2, cdr2, foldr1, map1, traverse1, nth1, pushCdr_21_1, reverse1, cadr1, charAt1, _2e2e_1, _23_s1, split1, quoted1, getenv1, struct1, succ1, pred1, string_2d3e_number1, number_2d3e_string1, error_21_1, print_21_1, fail_21_1, create1, append_21_1, line_21_1, indent_21_1, unindent_21_1, beginBlock_21_1, nextBlock_21_1, endBlock_21_1, _2d3e_string1, createLookup1, keywords1, createState1, builtins1, builtinVars1, escape1, escapeVar1, statement_3f_1, truthy_3f_1, compileQuote1, compileExpression1, compileBlock1, prelude1, backend1, estimateLength1, expression1, block1, backend2, abs1, max3, builtins2, tokens1, extractSignature1, parseDocstring1, config1, coloredAnsi1, colored_3f_1, colored1, verbosity1, setVerbosity_21_1, showExplain1, setExplain_21_1, printError_21_1, printWarning_21_1, printVerbose_21_1, printDebug_21_1, formatPosition1, formatRange1, formatNode1, getSource1, putLines_21_1, putTrace_21_1, putExplain_21_1, errorPositions_21_1, formatRange2, sortVars_21_1, formatDefinition1, formatSignature1, exported1, backend3, wrapGenerate1, wrapNormal1
_3d_1 = function(v1, v2) return (v1 == v2) end
_2f3d_1 = function(v1, v2) return (v1 ~= v2) end
_3c_1 = function(v1, v2) return (v1 < v2) end
_3c3d_1 = function(v1, v2) return (v1 <= v2) end
_3e_1 = function(v1, v2) return (v1 > v2) end
_3e3d_1 = function(v1, v2) return (v1 >= v2) end
_2b_1 = function(v1, v2) return (v1 + v2) end
_2d_1 = function(v1, v2) return (v1 - v2) end
_25_1 = function(v1, v2) return (v1 % v2) end
slice1 = _libs["lib/lua/basic/slice"]
error1 = error
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
byte1 = string.byte
find1 = string.find
format1 = string.format
gsub1 = string.gsub
len1 = string.len
match1 = string.match
rep1 = string.rep
sub1 = string.sub
upper1 = string.upper
concat1 = table.concat
sort1 = table.sort
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
list_3f_1 = (function(x3)
	return (type1(x3) == "list")
end)
nil_3f_1 = (function(x4)
	local r_71 = x4
	if r_71 then
		local r_81 = list_3f_1(x4)
		if r_81 then
			return (_23_1(x4) == 0)
		else
			return r_81
		end
	else
		return r_71
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
car2 = (function(x10)
	local r_281 = type1(x10)
	if (r_281 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_281), 2)
	else
	end
	return car1(x10)
end)
cdr2 = (function(x11)
	local r_291 = type1(x11)
	if (r_291 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_291), 2)
	else
	end
	if nil_3f_1(x11) then
		return {tag = "list", n =0}
	else
		return cdr1(x11)
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
		return map1(f2, xs6, {tag = "list", n =0})
	elseif nil_3f_1(xs6) then
		return reverse1(acc1)
	else
		return map1(f2, cdr2(xs6), cons1(f2(car2(xs6)), acc1))
	end
end)
traverse1 = (function(xs7, f3)
	return map1(f3, xs7)
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
reverse1 = (function(xs10, acc2)
	if _21_1(exists_3f_1(acc2)) then
		return reverse1(xs10, {tag = "list", n =0})
	elseif nil_3f_1(xs10) then
		return acc2
	else
		return reverse1(cdr2(xs10), cons1(car2(xs10), acc2))
	end
end)
cadr1 = (function(x12)
	return car2(cdr2(x12))
end)
charAt1 = (function(xs11, x13)
	return sub1(xs11, x13, x13)
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
	local r_491 = nil
	r_491 = (function()
		if loop1 then
			local pos1 = list1(find1(text1, pattern1, start1))
			local nstart1 = car2(pos1)
			local nend1 = cadr1(pos1)
			local temp1
			local r_501 = (nstart1 == nil)
			if r_501 then
				temp1 = r_501
			else
				local r_511 = limit1
				if r_511 then
					temp1 = (_23_1(out1) >= limit1)
				else
					temp1 = r_511
				end
			end
			if temp1 then
				loop1 = false
				pushCdr_21_1(out1, sub1(text1, start1, _23_s1(text1)))
				start1 = (_23_s1(text1) + 1)
			elseif (nstart1 > _23_s1(text1)) then
				if (start1 <= _23_s1(text1)) then
					pushCdr_21_1(out1, sub1(text1, start1, _23_s1(text1)))
				else
				end
				loop1 = false
			elseif (nend1 < nstart1) then
				pushCdr_21_1(out1, sub1(text1, start1, nstart1))
				start1 = (nstart1 + 1)
			else
				pushCdr_21_1(out1, sub1(text1, start1, (nstart1 - 1)))
				start1 = (nend1 + 1)
			end
			return r_491()
		else
		end
	end)
	r_491()
	return out1
end)
local escapes1 = {}
escapes1["\9"] = "\\9"
escapes1["\n"] = "n"
quoted1 = (function(str1)
	local result1 = gsub1(format1("%q", str1), ".", escapes1)
	return result1
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
	local out2 = {}
	local r_601 = _23_1(keys1)
	local r_611 = 2
	local r_581 = nil
	r_581 = (function(r_591)
		if (r_591 <= r_601) then
			local i1 = r_591
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
			return r_581((r_591 + 2))
		else
		end
	end)
	r_581(1)
	return out2
end)
succ1 = (function(x14)
	return (x14 + 1)
end)
pred1 = (function(x15)
	return (x15 - 1)
end)
string_2d3e_number1 = tonumber1
number_2d3e_string1 = tostring1
error_21_1 = error1
print_21_1 = print1
fail_21_1 = (function(x16)
	return error_21_1(x16, 0)
end)
create1 = (function()
	return struct1("out", list1(), "indent", 0, "tabs-pending", false)
end)
append_21_1 = (function(writer1, text2)
	local r_921 = type1(text2)
	if (r_921 ~= "string") then
		error1(format1("bad argment %s (expected %s, got %s)", "text", "string", r_921), 2)
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
	local temp2
	local r_931 = force1
	if r_931 then
		temp2 = r_931
	else
		temp2 = _21_1(writer2["tabs-pending"])
	end
	if temp2 then
		writer2["tabs-pending"] = true
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
_2d3e_string1 = (function(writer8)
	return concat1(writer8["out"])
end)
createLookup1 = (function(...)
	local lst1 = _pack(...) lst1.tag = "list"
	local out3 = {}
	local r_951 = lst1
	local r_981 = _23_1(r_951)
	local r_991 = 1
	local r_961 = nil
	r_961 = (function(r_971)
		if (r_971 <= r_981) then
			local r_941 = r_971
			local entry1 = r_951[r_941]
			out3[entry1] = true
			return r_961((r_971 + 1))
		else
		end
	end)
	r_961(1)
	return out3
end)
keywords1 = createLookup1("and", "break", "do", "else", "elseif", "end", "false", "for", "function", "if", "in", "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while")
createState1 = (function(meta1)
	return struct1("ctr-lookup", {}, "var-lookup", {}, "meta", (function(r_1001)
		if r_1001 then
			return r_1001
		else
			return {}
		end
	end)(meta1))
end)
builtins1 = require1("tacky.analysis.resolve")["builtins"]
builtinVars1 = require1("tacky.analysis.resolve")["declaredVars"]
escape1 = (function(name1)
	if keywords1[name1] then
		return _2e2e_1("_e", name1)
	elseif find1(name1, "^%w[_%w%d]*$") then
		return name1
	else
		local out4
		local temp3
		local r_1421
		local r_1411 = name1
		r_1421 = charAt1(r_1411, 1)
		temp3 = find1(r_1421, "%d")
		if temp3 then
			out4 = "_e"
		else
			out4 = ""
		end
		local upper2 = false
		local esc1 = false
		local r_1301 = _23_s1(name1)
		local r_1311 = 1
		local r_1281 = nil
		r_1281 = (function(r_1291)
			if (r_1291 <= r_1301) then
				local i2 = r_1291
				local char1 = charAt1(name1, i2)
				local temp4
				local r_1321 = (char1 == "-")
				if r_1321 then
					local r_1331
					local r_1381
					local r_1371 = name1
					r_1381 = charAt1(r_1371, pred1(i2))
					r_1331 = find1(r_1381, "[%a%d']")
					if r_1331 then
						local r_1361
						local r_1351 = name1
						r_1361 = charAt1(r_1351, succ1(i2))
						temp4 = find1(r_1361, "[%a%d']")
					else
						temp4 = r_1331
					end
				else
					temp4 = r_1321
				end
				if temp4 then
					upper2 = true
				elseif find1(char1, "[^%w%d]") then
					local r_1401
					local r_1391 = char1
					r_1401 = byte1(r_1391)
					char1 = format1("%02x", r_1401)
					if esc1 then
					else
						esc1 = true
						out4 = _2e2e_1(out4, "_")
					end
					out4 = _2e2e_1(out4, char1)
				else
					if esc1 then
						esc1 = false
						out4 = _2e2e_1(out4, "_")
					else
					end
					if upper2 then
						upper2 = false
						char1 = upper1(char1)
					else
					end
					out4 = _2e2e_1(out4, char1)
				end
				return r_1281((r_1291 + 1))
			else
			end
		end)
		r_1281(1)
		if esc1 then
			out4 = _2e2e_1(out4, "_")
		else
		end
		return out4
	end
end)
escapeVar1 = (function(var1, state1)
	if builtinVars1[var1] then
		return var1["name"]
	else
		local v1 = escape1(var1["name"])
		local id1 = state1["var-lookup"][var1]
		if id1 then
		else
			id1 = succ1((function(r_1341)
				if r_1341 then
					return r_1341
				else
					return 0
				end
			end)(state1["ctr-lookup"][v1]))
			state1["ctr-lookup"][v1] = id1
			state1["var-lookup"][var1] = id1
		end
		return _2e2e_1(v1, number_2d3e_string1(id1))
	end
end)
statement_3f_1 = (function(node1)
	if list_3f_1(node1) then
		local first1 = car2(node1)
		if symbol_3f_1(first1) then
			return (first1["var"] == builtins1["cond"])
		elseif list_3f_1(first1) then
			local func1 = car2(first1)
			local r_1011 = symbol_3f_1(func1)
			if r_1011 then
				return (func1["var"] == builtins1["lambda"])
			else
				return r_1011
			end
		else
			return false
		end
	else
		return false
	end
end)
truthy_3f_1 = (function(node2)
	local r_1021 = symbol_3f_1(node2)
	if r_1021 then
		return (builtinVars1["true"] == node2["var"])
	else
		return r_1021
	end
end)
compileQuote1 = (function(node3, out5, state2, level1)
	if (level1 == 0) then
		return compileExpression1(node3, out5, state2)
	else
		local ty2 = type1(node3)
		if (ty2 == "string") then
			return append_21_1(out5, quoted1(node3["value"]))
		elseif (ty2 == "number") then
			return append_21_1(out5, number_2d3e_string1(node3["value"]))
		elseif (ty2 == "symbol") then
			append_21_1(out5, _2e2e_1("{ tag=\"symbol\", contents=", quoted1(node3["contents"])))
			if node3["var"] then
				append_21_1(out5, _2e2e_1(", var=", quoted1(number_2d3e_string1(node3["var"]))))
			else
			end
			return append_21_1(out5, "}")
		elseif (ty2 == "key") then
			return append_21_1(out5, _2e2e_1("{tag=\"key\", value=", quoted1(node3["value"]), "}"))
		elseif (ty2 == "list") then
			local first2 = car2(node3)
			local temp5
			local r_1071 = symbol_3f_1(first2)
			if r_1071 then
				local r_1081 = (first2["var"] == builtins1["unquote"])
				if r_1081 then
					temp5 = r_1081
				else
					temp5 = ("var" == builtins1["unquote-splice"])
				end
			else
				temp5 = r_1071
			end
			if temp5 then
				return compileQuote1(nth1(node3, 2), out5, state2, (function(r_1091)
					if r_1091 then
						return pred1(level1)
					else
						return r_1091
					end
				end)(level1))
			else
				local temp6
				local r_1101 = symbol_3f_1(first2)
				if r_1101 then
					temp6 = (first2["var"] == builtins1["quasiquote"])
				else
					temp6 = r_1101
				end
				if temp6 then
					return compileQuote1(nth1(node3, 2), out5, state2, (function(r_1111)
						if r_1111 then
							return succ1(level1)
						else
							return r_1111
						end
					end)(level1))
				else
					local containsUnsplice1 = false
					local r_1131 = node3
					local r_1161 = _23_1(r_1131)
					local r_1171 = 1
					local r_1141 = nil
					r_1141 = (function(r_1151)
						if (r_1151 <= r_1161) then
							local r_1121 = r_1151
							local sub2 = r_1131[r_1121]
							local temp7
							local r_1181 = list_3f_1(sub2)
							if r_1181 then
								local r_1191 = symbol_3f_1(car2(sub2))
								if r_1191 then
									temp7 = (sub2[1]["var"] == builtins1["unquote-splice"])
								else
									temp7 = r_1191
								end
							else
								temp7 = r_1181
							end
							if temp7 then
								containsUnsplice1 = true
							else
							end
							return r_1141((r_1151 + 1))
						else
						end
					end)
					r_1141(1)
					if containsUnsplice1 then
						local offset1 = 0
						beginBlock_21_1(out5, "(function()")
						line_21_1(out5, "local _offset, _result, _temp = 0, {tag=\"list\",n=0}")
						local r_1221 = _23_1(node3)
						local r_1231 = 1
						local r_1201 = nil
						r_1201 = (function(r_1211)
							if (r_1211 <= r_1221) then
								local i3 = r_1211
								local sub3 = nth1(node3, i3)
								local temp8
								local r_1241 = list_3f_1(sub3)
								if r_1241 then
									local r_1251 = symbol_3f_1(car2(sub3))
									if r_1251 then
										temp8 = (sub3[1]["var"] == builtins1["unquote-splice"])
									else
										temp8 = r_1251
									end
								else
									temp8 = r_1241
								end
								if temp8 then
									offset1 = (offset1 + 1)
									append_21_1(out5, "_temp = ")
									compileQuote1(nth1(sub3, 2), out5, state2, pred1(level1))
									line_21_1(out5)
									line_21_1(out5, _2e2e_1("for _c = 1, _temp.n do _result[", number_2d3e_string1((i3 - offset1)), " + _c + _offset] = _temp[_c] end"))
									line_21_1(out5, "_offset = _offset + _temp.n")
								else
									append_21_1(out5, _2e2e_1("_result[", number_2d3e_string1((i3 - offset1)), " + _offset] = "))
									compileQuote1(sub3, out5, state2, level1)
									line_21_1(out5)
								end
								return r_1201((r_1211 + 1))
							else
							end
						end)
						r_1201(1)
						line_21_1(out5, _2e2e_1("_result.n = _offset + ", number_2d3e_string1((_23_1(node3) - offset1))))
						line_21_1(out5, "return _result")
						return endBlock_21_1(out5, "end)()")
					else
						append_21_1(out5, _2e2e_1("{tag = \"list\", n =", number_2d3e_string1(_23_1(node3))))
						local r_1441 = node3
						local r_1471 = _23_1(r_1441)
						local r_1481 = 1
						local r_1451 = nil
						r_1451 = (function(r_1461)
							if (r_1461 <= r_1471) then
								local r_1431 = r_1461
								local sub4 = r_1441[r_1431]
								append_21_1(out5, ", ")
								compileQuote1(sub4, out5, state2, level1)
								return r_1451((r_1461 + 1))
							else
							end
						end)
						r_1451(1)
						return append_21_1(out5, "}")
					end
				end
			end
		else
			return error_21_1(_2e2e_1("Unknown type ", ty2))
		end
	end
end)
compileExpression1 = (function(node4, out6, state3, ret1)
	if list_3f_1(node4) then
		local head2 = car2(node4)
		if symbol_3f_1(head2) then
			local var2 = head2["var"]
			if (var2 == builtins1["lambda"]) then
				if (ret1 == "") then
				else
					if ret1 then
						append_21_1(out6, ret1)
					else
					end
					local args2 = nth1(node4, 2)
					local variadic1 = nil
					local i4 = 1
					append_21_1(out6, "(function(")
					local r_1261 = nil
					r_1261 = (function()
						local temp9
						local r_1271 = (i4 <= _23_1(args2))
						if r_1271 then
							temp9 = _21_1(variadic1)
						else
							temp9 = r_1271
						end
						if temp9 then
							if (i4 > 1) then
								append_21_1(out6, ", ")
							else
							end
							local var3 = args2[i4]["var"]
							if var3["isVariadic"] then
								append_21_1(out6, "...")
								variadic1 = i4
							else
								append_21_1(out6, escapeVar1(var3, state3))
							end
							i4 = (i4 + 1)
							return r_1261()
						else
						end
					end)
					r_1261()
					beginBlock_21_1(out6, ")")
					if variadic1 then
						local argsVar1 = escapeVar1(args2[variadic1]["var"], state3)
						if (variadic1 == _23_1(args2)) then
							line_21_1(out6, _2e2e_1("local ", argsVar1, " = _pack(...) ", argsVar1, ".tag = \"list\""))
						else
							local remaining1 = (_23_1(args2) - variadic1)
							line_21_1(out6, _2e2e_1("local _n = _select(\"#\", ...) - ", number_2d3e_string1(remaining1)))
							append_21_1(out6, _2e2e_1("local ", argsVar1))
							local r_1511 = _23_1(args2)
							local r_1521 = 1
							local r_1491 = nil
							r_1491 = (function(r_1501)
								if (r_1501 <= r_1511) then
									local i5 = r_1501
									append_21_1(out6, ", ")
									append_21_1(out6, escapeVar1(args2[i5]["var"], state3))
									return r_1491((r_1501 + 1))
								else
								end
							end)
							r_1491(succ1(variadic1))
							line_21_1(out6)
							beginBlock_21_1(out6, "if _n > 0 then")
							append_21_1(out6, argsVar1)
							line_21_1(out6, " = { tag=\"list\", n=_n, _unpack(_pack(...), 1, _n)}")
							local r_1551 = _23_1(args2)
							local r_1561 = 1
							local r_1531 = nil
							r_1531 = (function(r_1541)
								if (r_1541 <= r_1551) then
									local i6 = r_1541
									append_21_1(out6, escapeVar1(args2[i6]["var"], state3))
									if (i6 < _23_1(args2)) then
										append_21_1(out6, ", ")
									else
									end
									return r_1531((r_1541 + 1))
								else
								end
							end)
							r_1531(succ1(variadic1))
							line_21_1(out6, " = select(_n + 1, ...)")
							nextBlock_21_1(out6, "else")
							append_21_1(out6, argsVar1)
							line_21_1(out6, " = { tag=\"list\", n=0}")
							local r_1591 = _23_1(args2)
							local r_1601 = 1
							local r_1571 = nil
							r_1571 = (function(r_1581)
								if (r_1581 <= r_1591) then
									local i7 = r_1581
									append_21_1(out6, escapeVar1(args2[i7]["var"], state3))
									if (i7 < _23_1(args2)) then
										append_21_1(out6, ", ")
									else
									end
									return r_1571((r_1581 + 1))
								else
								end
							end)
							r_1571(succ1(variadic1))
							line_21_1(out6, " = ...")
							endBlock_21_1(out6, "end")
						end
					else
					end
					compileBlock1(node4, out6, state3, 3, "return ")
					unindent_21_1(out6)
					return append_21_1(out6, "end)")
				end
			elseif (var2 == builtins1["cond"]) then
				local closure1 = _21_1(ret1)
				local hadFinal1 = false
				local ends1 = 1
				if closure1 then
					beginBlock_21_1(out6, "(function()")
					ret1 = "return "
				else
				end
				local i8 = 2
				local r_1611 = nil
				r_1611 = (function()
					local temp10
					local r_1621 = _21_1(hadFinal1)
					if r_1621 then
						temp10 = (i8 <= _23_1(node4))
					else
						temp10 = r_1621
					end
					if temp10 then
						local item1 = nth1(node4, i8)
						local case1 = nth1(item1, 1)
						local isFinal1 = truthy_3f_1(case1)
						if isFinal1 then
							if (i8 == 2) then
								append_21_1(out6, "do")
							else
							end
						elseif statement_3f_1(case1) then
							if (i8 > 2) then
								indent_21_1(out6)
								line_21_1(out6)
								ends1 = (ends1 + 1)
							else
							end
							local tmp1 = escapeVar1(struct1("name", "temp"), state3)
							line_21_1(out6, _2e2e_1("local ", tmp1))
							compileExpression1(case1, out6, state3, _2e2e_1(tmp1, " = "))
							line_21_1(out6)
							line_21_1(out6, _2e2e_1("if ", tmp1, " then"))
						else
							append_21_1(out6, "if ")
							compileExpression1(case1, out6, state3)
							append_21_1(out6, " then")
						end
						indent_21_1(out6)
						line_21_1(out6)
						compileBlock1(item1, out6, state3, 2, ret1)
						unindent_21_1(out6)
						if isFinal1 then
							hadFinal1 = true
						else
							append_21_1(out6, "else")
						end
						i8 = (i8 + 1)
						return r_1611()
					else
					end
				end)
				r_1611()
				if hadFinal1 then
				else
					indent_21_1(out6)
					line_21_1(out6)
					append_21_1(out6, "_error(\"unmatched item\")")
					unindent_21_1(out6)
					line_21_1(out6)
				end
				local r_1651 = ends1
				local r_1661 = 1
				local r_1631 = nil
				r_1631 = (function(r_1641)
					if (r_1641 <= r_1651) then
						local i9 = r_1641
						append_21_1(out6, "end")
						if (i9 < ends1) then
							unindent_21_1(out6)
							line_21_1(out6)
						else
						end
						return r_1631((r_1641 + 1))
					else
					end
				end)
				r_1631(1)
				if closure1 then
					line_21_1(out6)
					return endBlock_21_1(out6, "end)()")
				else
				end
			elseif (var2 == builtins1["set!"]) then
				compileExpression1(nth1(node4, 3), out6, state3, _2e2e_1(escapeVar1(node4[2]["var"], state3), " = "))
				local temp11
				local r_1671 = ret1
				if r_1671 then
					temp11 = (ret1 ~= "")
				else
					temp11 = r_1671
				end
				if temp11 then
					line_21_1(out6)
					append_21_1(out6, ret1)
					return append_21_1(out6, "nil")
				else
				end
			elseif (var2 == builtins1["define"]) then
				return compileExpression1(nth1(node4, _23_1(node4)), out6, state3, _2e2e_1(escapeVar1(node4["defVar"], state3), " = "))
			elseif (var2 == builtins1["define-macro"]) then
				return compileExpression1(nth1(node4, _23_1(node4)), out6, state3, _2e2e_1(escapeVar1(node4["defVar"], state3), " = "))
			elseif (var2 == builtins1["define-native"]) then
				local meta2 = state3["meta"][node4["defVar"]["fullName"]]
				local ty3 = type1(meta2)
				if (ty3 == "nil") then
					return append_21_1(out6, format1("%s = _libs[%q]", escapeVar1(node4["defVar"], state3), node4["defVar"]["fullName"]))
				elseif (ty3 == "var") then
					return append_21_1(out6, format1("%s = %s", escapeVar1(node4["defVar"], state3), meta2["contents"]))
				else
					local temp12
					local r_1681 = (ty3 == "expr")
					if r_1681 then
						temp12 = r_1681
					else
						temp12 = (ty3 == "stmt")
					end
					if temp12 then
						local count1 = meta2["count"]
						append_21_1(out6, format1("%s = function(", escapeVar1(node4["defVar"], state3)))
						local r_1711 = count1
						local r_1721 = 1
						local r_1691 = nil
						r_1691 = (function(r_1701)
							if (r_1701 <= r_1711) then
								local i10 = r_1701
								if (i10 == 1) then
								else
									append_21_1(out6, ", ")
								end
								append_21_1(out6, _2e2e_1("v", string_2d3e_number1(i10)))
								return r_1691((r_1701 + 1))
							else
							end
						end)
						r_1691(1)
						append_21_1(out6, ") ")
						if (ty3 == "expr") then
							append_21_1(out6, "return ")
						else
						end
						local r_1741 = meta2["contents"]
						local r_1771 = _23_1(r_1741)
						local r_1781 = 1
						local r_1751 = nil
						r_1751 = (function(r_1761)
							if (r_1761 <= r_1771) then
								local r_1731 = r_1761
								local entry2 = r_1741[r_1731]
								if number_3f_1(entry2) then
									append_21_1(out6, _2e2e_1("v", string_2d3e_number1(entry2)))
								else
									append_21_1(out6, entry2)
								end
								return r_1751((r_1761 + 1))
							else
							end
						end)
						r_1751(1)
						return append_21_1(out6, " end")
					else
						_error("unmatched item")
					end
				end
			elseif (var2 == builtins1["quote"]) then
				if (ret1 == "") then
				else
					if ret1 then
						append_21_1(out6, ret1)
					else
					end
					return compileQuote1(nth1(node4, 2), out6, state3)
				end
			elseif (var2 == builtins1["quasiquote"]) then
				if (ret1 == "") then
					append_21_1(out6, "local _ =")
				elseif ret1 then
					append_21_1(out6, ret1)
				else
				end
				return compileQuote1(nth1(node4, 2), out6, state3, 1)
			elseif (var2 == builtins1["unquote"]) then
				return fail_21_1("unquote outside of quasiquote")
			elseif (var2 == builtins1["unquote-splice"]) then
				return fail_21_1("unquote-splice outside of quasiquote")
			elseif (var2 == builtins1["import"]) then
				if (ret1 == nil) then
					return append_21_1(out6, "nil")
				elseif (ret1 ~= "") then
					append_21_1(out6, ret1)
					return append_21_1(out6, "nil")
				else
				end
			else
				local meta3
				local r_1901 = symbol_3f_1(head2)
				if r_1901 then
					local r_1911 = (head2["var"]["tag"] == "native")
					if r_1911 then
						meta3 = state3["meta"][head2["var"]["fullName"]]
					else
						meta3 = r_1911
					end
				else
					meta3 = r_1901
				end
				local metaTy1 = type1(meta3)
				if (metaTy1 == "nil") then
				elseif (metaTy1 == "boolean") then
				elseif (metaTy1 == "expr") then
				elseif (metaTy1 == "stmt") then
					if ret1 then
					else
						meta3 = nil
					end
				elseif (metaTy1 == "var") then
					meta3 = nil
				else
					_error("unmatched item")
				end
				local temp13
				local r_1791 = meta3
				if r_1791 then
					temp13 = (pred1(_23_1(node4)) == meta3["count"])
				else
					temp13 = r_1791
				end
				if temp13 then
					local temp14
					local r_1801 = ret1
					if r_1801 then
						temp14 = (meta3["tag"] == "expr")
					else
						temp14 = r_1801
					end
					if temp14 then
						append_21_1(out6, ret1)
					else
					end
					local contents2 = meta3["contents"]
					local r_1831 = _23_1(contents2)
					local r_1841 = 1
					local r_1811 = nil
					r_1811 = (function(r_1821)
						if (r_1821 <= r_1831) then
							local i11 = r_1821
							local entry3 = nth1(contents2, i11)
							if number_3f_1(entry3) then
								compileExpression1(nth1(node4, succ1(entry3)), out6, state3)
							else
								append_21_1(out6, entry3)
							end
							return r_1811((r_1821 + 1))
						else
						end
					end)
					r_1811(1)
					local temp15
					local r_1851 = (meta3["tag"] ~= "expr")
					if r_1851 then
						temp15 = (ret1 ~= "")
					else
						temp15 = r_1851
					end
					if temp15 then
						line_21_1(out6)
						append_21_1(out6, ret1)
						append_21_1(out6, "nil")
						return line_21_1(out6)
					else
					end
				else
					if ret1 then
						append_21_1(out6, ret1)
					else
					end
					compileExpression1(head2, out6, state3)
					append_21_1(out6, "(")
					local r_1881 = _23_1(node4)
					local r_1891 = 1
					local r_1861 = nil
					r_1861 = (function(r_1871)
						if (r_1871 <= r_1881) then
							local i12 = r_1871
							if (i12 > 2) then
								append_21_1(out6, ", ")
							else
							end
							compileExpression1(nth1(node4, i12), out6, state3)
							return r_1861((r_1871 + 1))
						else
						end
					end)
					r_1861(2)
					return append_21_1(out6, ")")
				end
			end
		else
			local temp16
			local r_1921 = ret1
			if r_1921 then
				local r_1931 = list_3f_1(head2)
				if r_1931 then
					local r_1941 = symbol_3f_1(car2(head2))
					if r_1941 then
						temp16 = (head2[1]["var"] == builtins1["lambda"])
					else
						temp16 = r_1941
					end
				else
					temp16 = r_1931
				end
			else
				temp16 = r_1921
			end
			if temp16 then
				local args3 = nth1(head2, 2)
				local offset2 = 1
				local r_1971 = _23_1(args3)
				local r_1981 = 1
				local r_1951 = nil
				r_1951 = (function(r_1961)
					if (r_1961 <= r_1971) then
						local i13 = r_1961
						local var4 = args3[i13]["var"]
						append_21_1(out6, _2e2e_1("local ", escapeVar1(var4, state3)))
						if var4["isVariadic"] then
							local count2 = (_23_1(node4) - _23_1(args3))
							if (count2 < 0) then
								count2 = 0
							else
							end
							append_21_1(out6, " = { tag=\"list\", n=")
							append_21_1(out6, number_2d3e_string1(count2))
							local r_2011 = count2
							local r_2021 = 1
							local r_1991 = nil
							r_1991 = (function(r_2001)
								if (r_2001 <= r_2011) then
									local j1 = r_2001
									append_21_1(out6, ", ")
									compileExpression1(nth1(node4, (i13 + j1)), out6, state3)
									return r_1991((r_2001 + 1))
								else
								end
							end)
							r_1991(1)
							offset2 = count2
							line_21_1(out6, "}")
						else
							local expr2 = nth1(node4, (i13 + offset2))
							local name2 = escapeVar1(var4, state3)
							local ret2 = nil
							if expr2 then
								if statement_3f_1(expr2) then
									ret2 = _2e2e_1(name2, " = ")
									line_21_1(out6)
								else
									append_21_1(out6, " = ")
								end
								compileExpression1(expr2, out6, state3, ret2)
								line_21_1(out6)
							else
								line_21_1(out6)
							end
						end
						return r_1951((r_1961 + 1))
					else
					end
				end)
				r_1951(1)
				local r_2051 = _23_1(node4)
				local r_2061 = 1
				local r_2031 = nil
				r_2031 = (function(r_2041)
					if (r_2041 <= r_2051) then
						local i14 = r_2041
						compileExpression1(nth1(node4, i14), out6, state3, "")
						line_21_1(out6)
						return r_2031((r_2041 + 1))
					else
					end
				end)
				r_2031((_23_1(args3) + (offset2 + 1)))
				return compileBlock1(head2, out6, state3, 3, ret1)
			else
				if ret1 then
					append_21_1(out6, ret1)
				else
				end
				compileExpression1(car2(node4), out6, state3)
				append_21_1(out6, "(")
				local r_2091 = _23_1(node4)
				local r_2101 = 1
				local r_2071 = nil
				r_2071 = (function(r_2081)
					if (r_2081 <= r_2091) then
						local i15 = r_2081
						if (i15 > 2) then
							append_21_1(out6, ", ")
						else
						end
						compileExpression1(nth1(node4, i15), out6, state3)
						return r_2071((r_2081 + 1))
					else
					end
				end)
				r_2071(2)
				return append_21_1(out6, ")")
			end
		end
	else
		if (ret1 == "") then
		else
			if ret1 then
				append_21_1(out6, ret1)
			else
			end
			if symbol_3f_1(node4) then
				return append_21_1(out6, escapeVar1(node4["var"], state3))
			elseif string_3f_1(node4) then
				return append_21_1(out6, quoted1(node4["value"]))
			elseif number_3f_1(node4) then
				return append_21_1(out6, number_2d3e_string1(node4["value"]))
			elseif key_3f_1(node4) then
				return append_21_1(out6, quoted1(node4["value"]))
			else
				return error_21_1(_2e2e_1("Unknown type: ", type1(node4)))
			end
		end
	end
end)
compileBlock1 = (function(nodes1, out7, state4, start2, ret3)
	local r_1051 = _23_1(nodes1)
	local r_1061 = 1
	local r_1031 = nil
	r_1031 = (function(r_1041)
		if (r_1041 <= r_1051) then
			local i16 = r_1041
			local ret_27_1
			if (i16 == _23_1(nodes1)) then
				ret_27_1 = ret3
			else
				ret_27_1 = ""
			end
			compileExpression1(nth1(nodes1, i16), out7, state4, ret_27_1)
			line_21_1(out7)
			return r_1031((r_1041 + 1))
		else
		end
	end)
	return r_1031(start2)
end)
prelude1 = (function(out8)
	line_21_1(out8, "if not table.pack then table.pack = function(...) return { n = select(\"#\", ...), ... } end end")
	line_21_1(out8, "if not table.unpack then table.unpack = unpack end")
	line_21_1(out8, "local load = load if _VERSION:find(\"5.1\") then load = function(x, _, _, env) local f, e = loadstring(x); if not f then error(e, 1) end; return setfenv(f, env) end end")
	return line_21_1(out8, "local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error")
end)
backend1 = struct1("createState", createState1, "escape", escape1, "escapeVar", escapeVar1, "block", compileBlock1, "expression", compileExpression1, "prelude", prelude1)
estimateLength1 = (function(node5, max1)
	local tag2 = node5["tag"]
	local temp17
	local r_2111 = (tag2 == "string")
	if r_2111 then
		temp17 = r_2111
	else
		local r_2121 = (tag2 == "number")
		if r_2121 then
			temp17 = r_2121
		else
			local r_2131 = (tag2 == "symbol")
			if r_2131 then
				temp17 = r_2131
			else
				temp17 = (tag2 == "key")
			end
		end
	end
	if temp17 then
		return _23_s1(number_2d3e_string1(node5["contents"]))
	elseif (tag2 == "list") then
		local sum1 = 2
		local i17 = 1
		local r_2141 = nil
		r_2141 = (function()
			local temp18
			local r_2151 = (sum1 <= max1)
			if r_2151 then
				temp18 = (i17 <= _23_1(node5))
			else
				temp18 = r_2151
			end
			if temp18 then
				sum1 = (sum1 + estimateLength1(nth1(node5, i17), (max1 - sum1)))
				if (i17 > 1) then
					sum1 = (sum1 + 1)
				else
				end
				i17 = (i17 + 1)
				return r_2141()
			else
			end
		end)
		r_2141()
		return sum1
	else
		return fail_21_1(_2e2e_1("Unknown tag ", tag2))
	end
end)
expression1 = (function(node6, writer9)
	local tag3 = node6["tag"]
	if (tag3 == "string") then
		return append_21_1(writer9, quoted1(node6["value"]))
	elseif (tag3 == "number") then
		return append_21_1(writer9, number_2d3e_string1(node6["value"]))
	elseif (tag3 == "key") then
		return append_21_1(writer9, _2e2e_1(":", node6["value"]))
	elseif (tag3 == "symbol") then
		return append_21_1(writer9, node6["contents"])
	elseif (tag3 == "list") then
		append_21_1(writer9, "(")
		if nil_3f_1(node6) then
			return append_21_1(writer9, ")")
		else
			local newline1 = false
			local max2 = (60 - estimateLength1(car2(node6), 60))
			expression1(car2(node6), writer9)
			if (max2 <= 0) then
				newline1 = true
				indent_21_1(writer9)
			else
			end
			local r_2241 = _23_1(node6)
			local r_2251 = 1
			local r_2221 = nil
			r_2221 = (function(r_2231)
				if (r_2231 <= r_2241) then
					local i18 = r_2231
					local entry4 = nth1(node6, i18)
					local temp19
					local r_2261 = _21_1(newline1)
					if r_2261 then
						temp19 = (max2 > 0)
					else
						temp19 = r_2261
					end
					if temp19 then
						max2 = (max2 - estimateLength1(entry4, max2))
						if (max2 <= 0) then
							newline1 = true
							indent_21_1(writer9)
						else
						end
					else
					end
					if newline1 then
						line_21_1(writer9)
					else
						append_21_1(writer9, " ")
					end
					expression1(entry4, writer9)
					return r_2221((r_2231 + 1))
				else
				end
			end)
			r_2221(2)
			if newline1 then
				unindent_21_1(writer9)
			else
			end
			return append_21_1(writer9, ")")
		end
	else
		return fail_21_1(_2e2e_1("Unknown tag ", tag3))
	end
end)
block1 = (function(list2, writer10)
	local r_2171 = list2
	local r_2201 = _23_1(r_2171)
	local r_2211 = 1
	local r_2181 = nil
	r_2181 = (function(r_2191)
		if (r_2191 <= r_2201) then
			local r_2161 = r_2191
			local node7 = r_2171[r_2161]
			expression1(node7, writer10)
			line_21_1(writer10)
			return r_2181((r_2191 + 1))
		else
		end
	end)
	return r_2181(1)
end)
backend2 = struct1("expression", expression1, "block", block1)
abs1 = math.abs
max3 = math.max
builtins2 = require1("tacky.analysis.resolve")["builtins"]
tokens1 = {tag = "list", n =4, {tag = "list", n =2, "arg", "(%f[%a]%u+%f[%A])"}, {tag = "list", n =2, "mono", "```[a-z]*\n([^`]*)\n```"}, {tag = "list", n =2, "mono", "`([^`]*)`"}, {tag = "list", n =2, "link", "%[%[(.-)%]%]"}}
extractSignature1 = (function(var5)
	local ty4 = type1(var5)
	local temp20
	local r_2271 = (ty4 == "macro")
	if r_2271 then
		temp20 = r_2271
	else
		temp20 = (ty4 == "defined")
	end
	if temp20 then
		local root1 = var5["node"]
		local node8 = nth1(root1, _23_1(root1))
		local temp21
		local r_2281 = list_3f_1(node8)
		if r_2281 then
			local r_2291 = symbol_3f_1(car2(node8))
			if r_2291 then
				temp21 = (car2(node8)["var"] == builtins2["lambda"])
			else
				temp21 = r_2291
			end
		else
			temp21 = r_2281
		end
		if temp21 then
			return nth1(node8, 2)
		else
			return nil
		end
	else
		return nil
	end
end)
parseDocstring1 = (function(str2)
	local out9 = {tag = "list", n =0}
	local pos2 = 1
	local len3 = _23_s1(str2)
	local r_2301 = nil
	r_2301 = (function()
		if (pos2 <= len3) then
			local spos1 = len3
			local epos1 = nil
			local name3 = nil
			local ptrn1 = nil
			local r_2321 = tokens1
			local r_2351 = _23_1(r_2321)
			local r_2361 = 1
			local r_2331 = nil
			r_2331 = (function(r_2341)
				if (r_2341 <= r_2351) then
					local r_2311 = r_2341
					local tok1 = r_2321[r_2311]
					local npos1 = list1(find1(str2, nth1(tok1, 2), pos2))
					local temp22
					local r_2371 = car2(npos1)
					if r_2371 then
						temp22 = (car2(npos1) < spos1)
					else
						temp22 = r_2371
					end
					if temp22 then
						spos1 = car2(npos1)
						epos1 = nth1(npos1, 2)
						name3 = car2(tok1)
						ptrn1 = nth1(tok1, 2)
					else
					end
					return r_2331((r_2341 + 1))
				else
				end
			end)
			r_2331(1)
			if name3 then
				if (pos2 < spos1) then
					pushCdr_21_1(out9, struct1("tag", "text", "contents", sub1(str2, pos2, pred1(spos1))))
				else
				end
				pushCdr_21_1(out9, struct1("tag", name3, "whole", sub1(str2, spos1, epos1), "contents", match1(sub1(str2, spos1, epos1), ptrn1)))
				pos2 = succ1(epos1)
			else
				pushCdr_21_1(out9, struct1("tag", "text", "contents", sub1(str2, pos2, len3)))
				pos2 = succ1(len3)
			end
			return r_2301()
		else
		end
	end)
	r_2301()
	return out9
end)
struct1("parseDocs", parseDocstring1, "extractSignature", extractSignature1)
config1 = package.config
coloredAnsi1 = (function(col1, msg1)
	return _2e2e_1("\27[", col1, "m", msg1, "\27[0m")
end)
local temp23
local r_2481 = config1
if r_2481 then
	temp23 = (charAt1(config1, 1) ~= "\\")
else
	temp23 = r_2481
end
if temp23 then
	colored_3f_1 = true
else
	local temp24
	local r_2491 = getenv1
	if r_2491 then
		temp24 = (getenv1("ANSICON") ~= nil)
	else
		temp24 = r_2491
	end
	if temp24 then
		colored_3f_1 = true
	else
		local temp25
		local r_2501 = getenv1
		if r_2501 then
			local term1 = getenv1("TERM")
			if term1 then
				temp25 = find1(term1, "xterm")
			else
				temp25 = nil
			end
		else
			temp25 = r_2501
		end
		if temp25 then
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
verbosity1 = struct1("value", 0)
setVerbosity_21_1 = (function(level2)
	verbosity1["value"] = level2
	return nil
end)
showExplain1 = struct1("value", false)
setExplain_21_1 = (function(value1)
	showExplain1["value"] = value1
	return nil
end)
printError_21_1 = (function(msg3)
	local lines1 = split1(msg3, "\n", 1)
	print_21_1(colored1(31, _2e2e_1("[ERROR] ", car2(lines1))))
	if cadr1(lines1) then
		return print_21_1(cadr1(lines1))
	else
	end
end)
printWarning_21_1 = (function(msg4)
	local lines2 = split1(msg4, "\n", 1)
	print_21_1(colored1(33, _2e2e_1("[WARN] ", car2(lines2))))
	if cadr1(lines2) then
		return print_21_1(cadr1(lines2))
	else
	end
end)
printVerbose_21_1 = (function(msg5)
	if (verbosity1["value"] > 0) then
		return print_21_1(_2e2e_1("[VERBOSE] ", msg5))
	else
	end
end)
printDebug_21_1 = (function(msg6)
	if (verbosity1["value"] > 1) then
		return print_21_1(_2e2e_1("[DEBUG] ", msg6))
	else
	end
end)
formatPosition1 = (function(pos3)
	return _2e2e_1(pos3["line"], ":", pos3["column"])
end)
formatRange1 = (function(range1)
	if range1["finish"] then
		return format1("%s:[%s .. %s]", range1["name"], formatPosition1(range1["start"]), formatPosition1(range1["finish"]))
	else
		return format1("%s:[%s]", range1["name"], formatPosition1(range1["start"]))
	end
end)
formatNode1 = (function(node9)
	local temp26
	local r_2381 = node9["range"]
	if r_2381 then
		temp26 = node9["contents"]
	else
		temp26 = r_2381
	end
	if temp26 then
		return format1("%s (%q)", formatRange1(node9["range"]), node9["contents"])
	elseif node9["range"] then
		return formatRange1(node9["range"])
	elseif node9["macro"] then
		local macro1 = node9["macro"]
		return format1("macro expansion of %s (%s)", macro1["var"]["name"], formatNode1(macro1["node"]))
	else
		local temp27
		local r_2511 = node9["start"]
		if r_2511 then
			temp27 = node9["finish"]
		else
			temp27 = r_2511
		end
		if temp27 then
			return formatRange1(node9)
		else
			return "?"
		end
	end
end)
getSource1 = (function(node10)
	local result2 = nil
	local r_2391 = nil
	r_2391 = (function()
		local temp28
		local r_2401 = node10
		if r_2401 then
			temp28 = _21_1(result2)
		else
			temp28 = r_2401
		end
		if temp28 then
			result2 = node10["range"]
			node10 = node10["parent"]
			return r_2391()
		else
		end
	end)
	r_2391()
	return result2
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
	local maxLine1 = foldr1((function(node11, max4)
		if string_3f_1(node11) then
			return max4
		else
			return max3(max4, node11["start"]["line"])
		end
	end), 0, entries1)
	local code1 = _2e2e_1("\27[92m %", _23_s1(number_2d3e_string1(maxLine1)), "s |\27[0m %s")
	local r_2541 = _23_1(entries1)
	local r_2551 = 2
	local r_2521 = nil
	r_2521 = (function(r_2531)
		if (r_2531 <= r_2541) then
			local i19 = r_2531
			local position1 = entries1[i19]
			local message1 = entries1[succ1(i19)]
			if (file1 ~= position1["name"]) then
				file1 = position1["name"]
				print_21_1(_2e2e_1("\27[95m ", file1, "\27[0m"))
			else
				local temp29
				local r_2561 = (previous1 ~= -1)
				if r_2561 then
					temp29 = (abs1((position1["start"]["line"] - previous1)) > 2)
				else
					temp29 = r_2561
				end
				if temp29 then
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
				local temp30
				local r_2571 = position1["finish"]
				if r_2571 then
					temp30 = (position1["start"]["line"] == position1["finish"]["line"])
				else
					temp30 = r_2571
				end
				if temp30 then
					pointer1 = rep1("^", succ1((position1["finish"]["column"] - position1["start"]["column"])))
				else
					pointer1 = "^..."
				end
			end
			print_21_1(format1(code1, "", _2e2e_1(rep1(" ", (position1["start"]["column"] - 1)), pointer1, " ", message1)))
			return r_2521((r_2531 + 2))
		else
		end
	end)
	return r_2521(1)
end)
putTrace_21_1 = (function(node12)
	local previous2 = nil
	local r_2411 = nil
	r_2411 = (function()
		if node12 then
			local formatted1 = formatNode1(node12)
			if (previous2 == nil) then
				print_21_1(colored1(96, _2e2e_1("  => ", formatted1)))
			elseif (previous2 ~= formatted1) then
				print_21_1(_2e2e_1("  in ", formatted1))
			else
			end
			previous2 = formatted1
			node12 = node12["parent"]
			return r_2411()
		else
		end
	end)
	return r_2411()
end)
putExplain_21_1 = (function(...)
	local lines3 = _pack(...) lines3.tag = "list"
	if showExplain1["value"] then
		local r_2431 = lines3
		local r_2461 = _23_1(r_2431)
		local r_2471 = 1
		local r_2441 = nil
		r_2441 = (function(r_2451)
			if (r_2451 <= r_2461) then
				local r_2421 = r_2451
				local line1 = r_2431[r_2421]
				print_21_1(_2e2e_1("  ", line1))
				return r_2441((r_2451 + 1))
			else
			end
		end)
		return r_2441(1)
	else
	end
end)
errorPositions_21_1 = (function(node13, msg7)
	printError_21_1(msg7)
	putTrace_21_1(node13)
	local source1 = getSource1(node13)
	if source1 then
		putLines_21_1(true, source1, "")
	else
	end
	return fail_21_1("An error occured")
end)
struct1("colored", colored1, "formatPosition", formatPosition1, "formatRange", formatRange1, "formatNode", formatNode1, "putLines", putLines_21_1, "putTrace", putTrace_21_1, "putInfo", putExplain_21_1, "getSource", getSource1, "printWarning", printWarning_21_1, "printError", printError_21_1, "printVerbose", printVerbose_21_1, "printDebug", printDebug_21_1, "errorPositions", errorPositions_21_1, "setVerbosity", setVerbosity_21_1, "setExplain", setExplain_21_1)
formatRange2 = (function(range3)
	return format1("%s:%s", range3["name"], formatPosition1(range3["start"]))
end)
sortVars_21_1 = (function(list3)
	return sort1(list3, (function(a1, b1)
		return (car2(a1) < car2(b1))
	end))
end)
formatDefinition1 = (function(var6)
	local ty5 = type1(var6)
	if (ty5 == "builtin") then
		return "Builtin term"
	elseif (ty5 == "macro") then
		return _2e2e_1("Macro defined at ", formatRange2(getSource1(var6["node"])))
	elseif (ty5 == "native") then
		return _2e2e_1("Native defined at ", formatRange2(getSource1(var6["node"])))
	elseif (ty5 == "defined") then
		return _2e2e_1("Defined at ", formatRange2(getSource1(var6["node"])))
	else
		_error("unmatched item")
	end
end)
formatSignature1 = (function(name4, var7)
	local sig1 = extractSignature1(var7)
	if (sig1 == nil) then
		return name4
	elseif nil_3f_1(sig1) then
		return _2e2e_1("(", name4, _2e2e_1, ")")
	else
		return _2e2e_1("(", name4, " ", concat1(traverse1(sig1, (function(r_2581)
			return r_2581["contents"]
		end)), " "), ")")
	end
end)
exported1 = (function(out10, title1, vars1)
	local documented1 = {tag = "list", n =0}
	local undocumented1 = {tag = "list", n =0}
	iterPairs1(vars1, (function(name5, var8)
		return pushCdr_21_1((function()
			if var8["doc"] then
				return documented1
			else
				return undocumented1
			end
		end)()
		, list1(name5, var8))
	end))
	sortVars_21_1(documented1)
	sortVars_21_1(undocumented1)
	line_21_1(out10, "---")
	line_21_1(out10, _2e2e_1("title: ", title1))
	line_21_1(out10, "---")
	line_21_1(out10, _2e2e_1("# ", title1))
	local r_2601 = documented1
	local r_2631 = _23_1(r_2601)
	local r_2641 = 1
	local r_2611 = nil
	r_2611 = (function(r_2621)
		if (r_2621 <= r_2631) then
			local r_2591 = r_2621
			local entry5 = r_2601[r_2591]
			local name6 = car2(entry5)
			local var9 = nth1(entry5, 2)
			line_21_1(out10, _2e2e_1("## `", formatSignature1(name6, var9), "`"))
			line_21_1(out10, _2e2e_1("*", formatDefinition1(var9), "*"))
			line_21_1(out10, "", true)
			local r_2661 = parseDocstring1(var9["doc"])
			local r_2691 = _23_1(r_2661)
			local r_2701 = 1
			local r_2671 = nil
			r_2671 = (function(r_2681)
				if (r_2681 <= r_2691) then
					local r_2651 = r_2681
					local tok2 = r_2661[r_2651]
					local ty6 = type1(tok2)
					if (ty6 == "text") then
						append_21_1(out10, tok2["contents"])
					elseif (ty6 == "arg") then
						append_21_1(out10, _2e2e_1("`", tok2["contents"], "`"))
					elseif (ty6 == "mono") then
						append_21_1(out10, tok2["whole"])
					elseif (ty6 == "link") then
						local name7 = tok2["contents"]
						local scope1 = var9["scope"]
						local ovar1 = scope1["get"](scope1, name7, nil, true)
						if ovar1 then
							local loc1
							local r_2751
							local r_2741
							local r_2731
							local r_2721 = ovar1["node"]
							r_2731 = getSource1(r_2721)
							r_2741 = r_2731["name"]
							r_2751 = gsub1(r_2741, "%.lisp$", "")
							loc1 = gsub1(r_2751, "/", ".")
							local sig2 = extractSignature1(ovar1)
							local hash1
							if (sig2 == nil) then
								hash1 = ovar1["name"]
							elseif nil_3f_1(sig2) then
								hash1 = ovar1["name"]
							else
								hash1 = _2e2e_1(name7, " ", concat1(traverse1(sig2, (function(r_2711)
									return r_2711["contents"]
								end)), " "))
							end
							append_21_1(out10, format1("[`%s`](%s.md#%s)", name7, loc1, gsub1(hash1, "%A+", "-")))
						else
							append_21_1(out10, format1("`%s`", name7))
						end
					else
						_error("unmatched item")
					end
					return r_2671((r_2681 + 1))
				else
				end
			end)
			r_2671(1)
			line_21_1(out10)
			line_21_1(out10, "", true)
			return r_2611((r_2621 + 1))
		else
		end
	end)
	r_2611(1)
	if nil_3f_1(undocumented1) then
	else
		line_21_1(out10, "## Undocumented symbols")
	end
	local r_2771 = undocumented1
	local r_2801 = _23_1(r_2771)
	local r_2811 = 1
	local r_2781 = nil
	r_2781 = (function(r_2791)
		if (r_2791 <= r_2801) then
			local r_2761 = r_2791
			local entry6 = r_2771[r_2761]
			local name8 = car2(entry6)
			local var10 = nth1(entry6, 2)
			line_21_1(out10, _2e2e_1(" - `", formatSignature1(name8, var10), "` *", formatDefinition1(var10), "*"))
			return r_2781((r_2791 + 1))
		else
		end
	end)
	return r_2781(1)
end)
backend3 = struct1("exported", exported1)
wrapGenerate1 = (function(func2)
	return (function(node14, ...)
		local args4 = _pack(...) args4.tag = "list"
		local writer11 = create1()
		func2(node14, writer11, unpack1(args4))
		return _2d3e_string1(writer11)
	end)
end)
wrapNormal1 = (function(func3)
	return (function(...)
		local args5 = _pack(...) args5.tag = "list"
		local writer12 = create1()
		func3(writer12, unpack1(args5))
		return _2d3e_string1(writer12)
	end)
end)
return struct1("lua", struct1("expression", wrapGenerate1(compileExpression1), "block", wrapGenerate1(compileBlock1), "prelude", wrapNormal1(prelude1), "backend", backend1), "lisp", struct1("expression", wrapGenerate1(expression1), "block", wrapGenerate1(block1), "backend", backend2), "markdown", struct1("exported", wrapNormal1(exported1), "backend", backend3))
