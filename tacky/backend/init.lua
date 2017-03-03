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
local _3d_1, _2f3d_1, _3c_1, _3c3d_1, _3e_1, _3e3d_1, _2b_1, _2d_1, _25_1, _2e2e_1, slice1, error1, print1, getIdx1, setIdx_21_1, require1, tonumber1, tostring1, type_23_1, _23_1, byte1, char1, find1, format1, gsub1, len1, match1, rep1, sub1, upper1, concat1, sort1, unpack1, emptyStruct1, iterPairs1, car1, cdr1, list1, cons1, _21_1, pretty1, list_3f_1, nil_3f_1, string_3f_1, number_3f_1, symbol_3f_1, key_3f_1, exists_3f_1, type1, car2, cdr2, foldr1, map1, traverse1, nth1, pushCdr_21_1, reverse1, cadr1, charAt1, _2e2e_2, split1, quoted1, getenv1, struct1, succ1, pred1, fail_21_1, create1, append_21_1, line_21_1, indent_21_1, unindent_21_1, beginBlock_21_1, nextBlock_21_1, endBlock_21_1, _2d3e_string1, createLookup1, keywords1, createState1, builtins1, builtinVars1, escape1, escapeVar1, statement_3f_1, truthy_3f_1, compileQuote1, compileExpression1, compileBlock1, prelude1, backend1, estimateLength1, expression1, block1, backend2, abs1, max3, builtins2, tokens1, extractSignature1, parseDocstring1, config1, coloredAnsi1, colored_3f_1, colored1, verbosity1, setVerbosity_21_1, showExplain1, setExplain_21_1, printError_21_1, printWarning_21_1, printVerbose_21_1, printDebug_21_1, formatPosition1, formatRange1, formatNode1, getSource1, putLines_21_1, putTrace_21_1, putExplain_21_1, errorPositions_21_1, formatRange2, sortVars_21_1, formatDefinition1, formatSignature1, exported1, backend3, wrapGenerate1, wrapNormal1
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
char1 = string.char
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
		return {tag = "list", n = 0}
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
		return map1(f2, xs6, {tag = "list", n = 0})
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
		return reverse1(xs10, {tag = "list", n = 0})
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
local escapes1 = {}
local r_491 = nil
r_491 = (function(r_501)
	if (r_501 <= 31) then
		escapes1[char1(r_501)] = _2e2e_2("\\", tostring1(r_501))
		return r_491((r_501 + 1))
	else
	end
end)
r_491(0)
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
succ1 = (function(x14)
	return (x14 + 1)
end)
pred1 = (function(x15)
	return (x15 - 1)
end)
fail_21_1 = (function(x16)
	return error1(x16, 0)
end)
create1 = (function()
	return struct1("out", list1(), "indent", 0, "tabs-pending", false)
end)
append_21_1 = (function(writer1, text2)
	local r_961 = type1(text2)
	if (r_961 ~= "string") then
		error1(format1("bad argment %s (expected %s, got %s)", "text", "string", r_961), 2)
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
	if force1 then
		temp2 = force1
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
	local out4 = {}
	local r_1021 = _23_1(lst1)
	local r_1001 = nil
	r_1001 = (function(r_1011)
		if (r_1011 <= r_1021) then
			local entry1 = lst1[r_1011]
			out4[entry1] = true
			return r_1001((r_1011 + 1))
		else
		end
	end)
	r_1001(1)
	return out4
end)
keywords1 = createLookup1("and", "break", "do", "else", "elseif", "end", "false", "for", "function", "if", "in", "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while")
createState1 = (function(meta1)
	return struct1("ctr-lookup", {}, "var-lookup", {}, "meta", (function()
		if meta1 then
			return meta1
		else
			return {}
		end
	end)())
end)
builtins1 = require1("tacky.analysis.resolve")["builtins"]
builtinVars1 = require1("tacky.analysis.resolve")["declaredVars"]
escape1 = (function(name1)
	if keywords1[name1] then
		return _2e2e_2("_e", name1)
	elseif find1(name1, "^%w[_%w%d]*$") then
		return name1
	else
		local out5
		local temp3
		local r_1461
		r_1461 = charAt1(name1, 1)
		temp3 = find1(r_1461, "%d")
		if temp3 then
			out5 = "_e"
		else
			out5 = ""
		end
		local upper2 = false
		local esc1 = false
		local r_1341 = len1(name1)
		local r_1321 = nil
		r_1321 = (function(r_1331)
			if (r_1331 <= r_1341) then
				local char2 = charAt1(name1, r_1331)
				local temp4
				local r_1361 = (char2 == "-")
				if r_1361 then
					local r_1371
					local r_1421
					r_1421 = charAt1(name1, pred1(r_1331))
					r_1371 = find1(r_1421, "[%a%d']")
					if r_1371 then
						local r_1401
						r_1401 = charAt1(name1, succ1(r_1331))
						temp4 = find1(r_1401, "[%a%d']")
					else
						temp4 = r_1371
					end
				else
					temp4 = r_1361
				end
				if temp4 then
					upper2 = true
				elseif find1(char2, "[^%w%d]") then
					local r_1441
					local r_1431 = char2
					r_1441 = byte1(r_1431)
					char2 = format1("%02x", r_1441)
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
				return r_1321((r_1331 + 1))
			else
			end
		end)
		r_1321(1)
		if esc1 then
			out5 = _2e2e_2(out5, "_")
		else
		end
		return out5
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
			id1 = succ1((function(r_1381)
				if r_1381 then
					return r_1381
				else
					return 0
				end
			end)(state1["ctr-lookup"][v1]))
			state1["ctr-lookup"][v1] = id1
			state1["var-lookup"][var1] = id1
		end
		return _2e2e_2(v1, tostring1(id1))
	end
end)
statement_3f_1 = (function(node1)
	if list_3f_1(node1) then
		local first1 = car2(node1)
		if symbol_3f_1(first1) then
			return (first1["var"] == builtins1["cond"])
		elseif list_3f_1(first1) then
			local func1 = car2(first1)
			local r_1051 = symbol_3f_1(func1)
			if r_1051 then
				return (func1["var"] == builtins1["lambda"])
			else
				return r_1051
			end
		else
			return false
		end
	else
		return false
	end
end)
truthy_3f_1 = (function(node2)
	local r_1061 = symbol_3f_1(node2)
	if r_1061 then
		return (builtinVars1["true"] == node2["var"])
	else
		return r_1061
	end
end)
compileQuote1 = (function(node3, out6, state2, level1)
	if (level1 == 0) then
		return compileExpression1(node3, out6, state2)
	else
		local ty3 = type1(node3)
		if (ty3 == "string") then
			return append_21_1(out6, quoted1(node3["value"]))
		elseif (ty3 == "number") then
			return append_21_1(out6, tostring1(node3["value"]))
		elseif (ty3 == "symbol") then
			append_21_1(out6, _2e2e_2("{ tag=\"symbol\", contents=", quoted1(node3["contents"])))
			if node3["var"] then
				append_21_1(out6, _2e2e_2(", var=", quoted1(tostring1(node3["var"]))))
			else
			end
			return append_21_1(out6, "}")
		elseif (ty3 == "key") then
			return append_21_1(out6, _2e2e_2("{tag=\"key\", value=", quoted1(node3["value"]), "}"))
		elseif (ty3 == "list") then
			local first2 = car2(node3)
			local temp5
			local r_1111 = symbol_3f_1(first2)
			if r_1111 then
				local r_1121 = (first2["var"] == builtins1["unquote"])
				if r_1121 then
					temp5 = r_1121
				else
					temp5 = ("var" == builtins1["unquote-splice"])
				end
			else
				temp5 = r_1111
			end
			if temp5 then
				return compileQuote1(nth1(node3, 2), out6, state2, (function()
					if level1 then
						return pred1(level1)
					else
						return level1
					end
				end)())
			else
				local temp6
				local r_1141 = symbol_3f_1(first2)
				if r_1141 then
					temp6 = (first2["var"] == builtins1["syntax-quote"])
				else
					temp6 = r_1141
				end
				if temp6 then
					return compileQuote1(nth1(node3, 2), out6, state2, (function()
						if level1 then
							return succ1(level1)
						else
							return level1
						end
					end)())
				else
					local containsUnsplice1 = false
					local r_1201 = _23_1(node3)
					local r_1181 = nil
					r_1181 = (function(r_1191)
						if (r_1191 <= r_1201) then
							local sub2 = node3[r_1191]
							local temp7
							local r_1221 = list_3f_1(sub2)
							if r_1221 then
								local r_1231 = symbol_3f_1(car2(sub2))
								if r_1231 then
									temp7 = (sub2[1]["var"] == builtins1["unquote-splice"])
								else
									temp7 = r_1231
								end
							else
								temp7 = r_1221
							end
							if temp7 then
								containsUnsplice1 = true
							else
							end
							return r_1181((r_1191 + 1))
						else
						end
					end)
					r_1181(1)
					if containsUnsplice1 then
						local offset1 = 0
						beginBlock_21_1(out6, "(function()")
						line_21_1(out6, "local _offset, _result, _temp = 0, {tag=\"list\",n=0}")
						local r_1261 = _23_1(node3)
						local r_1241 = nil
						r_1241 = (function(r_1251)
							if (r_1251 <= r_1261) then
								local sub3 = nth1(node3, r_1251)
								local temp8
								local r_1281 = list_3f_1(sub3)
								if r_1281 then
									local r_1291 = symbol_3f_1(car2(sub3))
									if r_1291 then
										temp8 = (sub3[1]["var"] == builtins1["unquote-splice"])
									else
										temp8 = r_1291
									end
								else
									temp8 = r_1281
								end
								if temp8 then
									offset1 = (offset1 + 1)
									append_21_1(out6, "_temp = ")
									compileQuote1(nth1(sub3, 2), out6, state2, pred1(level1))
									line_21_1(out6)
									line_21_1(out6, _2e2e_2("for _c = 1, _temp.n do _result[", tostring1((r_1251 - offset1)), " + _c + _offset] = _temp[_c] end"))
									line_21_1(out6, "_offset = _offset + _temp.n")
								else
									append_21_1(out6, _2e2e_2("_result[", tostring1((r_1251 - offset1)), " + _offset] = "))
									compileQuote1(sub3, out6, state2, level1)
									line_21_1(out6)
								end
								return r_1241((r_1251 + 1))
							else
							end
						end)
						r_1241(1)
						line_21_1(out6, _2e2e_2("_result.n = _offset + ", tostring1((_23_1(node3) - offset1))))
						line_21_1(out6, "return _result")
						return endBlock_21_1(out6, "end)()")
					else
						append_21_1(out6, _2e2e_2("{tag = \"list\", n = ", tostring1(_23_1(node3))))
						local r_1511 = _23_1(node3)
						local r_1491 = nil
						r_1491 = (function(r_1501)
							if (r_1501 <= r_1511) then
								local sub4 = node3[r_1501]
								append_21_1(out6, ", ")
								compileQuote1(sub4, out6, state2, level1)
								return r_1491((r_1501 + 1))
							else
							end
						end)
						r_1491(1)
						return append_21_1(out6, "}")
					end
				end
			end
		else
			return error1(_2e2e_2("Unknown type ", ty3))
		end
	end
end)
compileExpression1 = (function(node4, out7, state3, ret1)
	if list_3f_1(node4) then
		local head2 = car2(node4)
		if symbol_3f_1(head2) then
			local var2 = head2["var"]
			if (var2 == builtins1["lambda"]) then
				if (ret1 == "") then
				else
					if ret1 then
						append_21_1(out7, ret1)
					else
					end
					local args2 = nth1(node4, 2)
					local variadic1 = nil
					local i1 = 1
					append_21_1(out7, "(function(")
					local r_1301 = nil
					r_1301 = (function()
						local temp9
						local r_1311 = (i1 <= _23_1(args2))
						if r_1311 then
							temp9 = _21_1(variadic1)
						else
							temp9 = r_1311
						end
						if temp9 then
							if (i1 > 1) then
								append_21_1(out7, ", ")
							else
							end
							local var3 = args2[i1]["var"]
							if var3["isVariadic"] then
								append_21_1(out7, "...")
								variadic1 = i1
							else
								append_21_1(out7, escapeVar1(var3, state3))
							end
							i1 = (i1 + 1)
							return r_1301()
						else
						end
					end)
					r_1301()
					beginBlock_21_1(out7, ")")
					if variadic1 then
						local argsVar1 = escapeVar1(args2[variadic1]["var"], state3)
						if (variadic1 == _23_1(args2)) then
							line_21_1(out7, _2e2e_2("local ", argsVar1, " = _pack(...) ", argsVar1, ".tag = \"list\""))
						else
							local remaining1 = (_23_1(args2) - variadic1)
							line_21_1(out7, _2e2e_2("local _n = _select(\"#\", ...) - ", tostring1(remaining1)))
							append_21_1(out7, _2e2e_2("local ", argsVar1))
							local r_1551 = _23_1(args2)
							local r_1531 = nil
							r_1531 = (function(r_1541)
								if (r_1541 <= r_1551) then
									append_21_1(out7, ", ")
									append_21_1(out7, escapeVar1(args2[r_1541]["var"], state3))
									return r_1531((r_1541 + 1))
								else
								end
							end)
							r_1531(succ1(variadic1))
							line_21_1(out7)
							beginBlock_21_1(out7, "if _n > 0 then")
							append_21_1(out7, argsVar1)
							line_21_1(out7, " = { tag=\"list\", n=_n, _unpack(_pack(...), 1, _n)}")
							local r_1591 = _23_1(args2)
							local r_1571 = nil
							r_1571 = (function(r_1581)
								if (r_1581 <= r_1591) then
									append_21_1(out7, escapeVar1(args2[r_1581]["var"], state3))
									if (r_1581 < _23_1(args2)) then
										append_21_1(out7, ", ")
									else
									end
									return r_1571((r_1581 + 1))
								else
								end
							end)
							r_1571(succ1(variadic1))
							line_21_1(out7, " = select(_n + 1, ...)")
							nextBlock_21_1(out7, "else")
							append_21_1(out7, argsVar1)
							line_21_1(out7, " = { tag=\"list\", n=0}")
							local r_1631 = _23_1(args2)
							local r_1611 = nil
							r_1611 = (function(r_1621)
								if (r_1621 <= r_1631) then
									append_21_1(out7, escapeVar1(args2[r_1621]["var"], state3))
									if (r_1621 < _23_1(args2)) then
										append_21_1(out7, ", ")
									else
									end
									return r_1611((r_1621 + 1))
								else
								end
							end)
							r_1611(succ1(variadic1))
							line_21_1(out7, " = ...")
							endBlock_21_1(out7, "end")
						end
					else
					end
					compileBlock1(node4, out7, state3, 3, "return ")
					unindent_21_1(out7)
					return append_21_1(out7, "end)")
				end
			elseif (var2 == builtins1["cond"]) then
				local closure1 = _21_1(ret1)
				local hadFinal1 = false
				local ends1 = 1
				if closure1 then
					beginBlock_21_1(out7, "(function()")
					ret1 = "return "
				else
				end
				local i2 = 2
				local r_1651 = nil
				r_1651 = (function()
					local temp10
					local r_1661 = _21_1(hadFinal1)
					if r_1661 then
						temp10 = (i2 <= _23_1(node4))
					else
						temp10 = r_1661
					end
					if temp10 then
						local item1 = nth1(node4, i2)
						local case1 = nth1(item1, 1)
						local isFinal1 = truthy_3f_1(case1)
						if isFinal1 then
							if (i2 == 2) then
								append_21_1(out7, "do")
							else
							end
						elseif statement_3f_1(case1) then
							if (i2 > 2) then
								indent_21_1(out7)
								line_21_1(out7)
								ends1 = (ends1 + 1)
							else
							end
							local tmp1 = escapeVar1(struct1("name", "temp"), state3)
							line_21_1(out7, _2e2e_2("local ", tmp1))
							compileExpression1(case1, out7, state3, _2e2e_2(tmp1, " = "))
							line_21_1(out7)
							line_21_1(out7, _2e2e_2("if ", tmp1, " then"))
						else
							append_21_1(out7, "if ")
							compileExpression1(case1, out7, state3)
							append_21_1(out7, " then")
						end
						indent_21_1(out7)
						line_21_1(out7)
						compileBlock1(item1, out7, state3, 2, ret1)
						unindent_21_1(out7)
						if isFinal1 then
							hadFinal1 = true
						else
							append_21_1(out7, "else")
						end
						i2 = (i2 + 1)
						return r_1651()
					else
					end
				end)
				r_1651()
				if hadFinal1 then
				else
					indent_21_1(out7)
					line_21_1(out7)
					append_21_1(out7, "_error(\"unmatched item\")")
					unindent_21_1(out7)
					line_21_1(out7)
				end
				local r_1691 = ends1
				local r_1671 = nil
				r_1671 = (function(r_1681)
					if (r_1681 <= r_1691) then
						append_21_1(out7, "end")
						if (r_1681 < ends1) then
							unindent_21_1(out7)
							line_21_1(out7)
						else
						end
						return r_1671((r_1681 + 1))
					else
					end
				end)
				r_1671(1)
				if closure1 then
					line_21_1(out7)
					return endBlock_21_1(out7, "end)()")
				else
				end
			elseif (var2 == builtins1["set!"]) then
				compileExpression1(nth1(node4, 3), out7, state3, _2e2e_2(escapeVar1(node4[2]["var"], state3), " = "))
				local temp11
				local r_1711 = ret1
				if r_1711 then
					temp11 = (ret1 ~= "")
				else
					temp11 = r_1711
				end
				if temp11 then
					line_21_1(out7)
					append_21_1(out7, ret1)
					return append_21_1(out7, "nil")
				else
				end
			elseif (var2 == builtins1["define"]) then
				return compileExpression1(nth1(node4, _23_1(node4)), out7, state3, _2e2e_2(escapeVar1(node4["defVar"], state3), " = "))
			elseif (var2 == builtins1["define-macro"]) then
				return compileExpression1(nth1(node4, _23_1(node4)), out7, state3, _2e2e_2(escapeVar1(node4["defVar"], state3), " = "))
			elseif (var2 == builtins1["define-native"]) then
				local meta2 = state3["meta"][node4["defVar"]["fullName"]]
				local ty4 = type1(meta2)
				if (ty4 == "nil") then
					return append_21_1(out7, format1("%s = _libs[%q]", escapeVar1(node4["defVar"], state3), node4["defVar"]["fullName"]))
				elseif (ty4 == "var") then
					return append_21_1(out7, format1("%s = %s", escapeVar1(node4["defVar"], state3), meta2["contents"]))
				else
					local temp12
					local r_1721 = (ty4 == "expr")
					if r_1721 then
						temp12 = r_1721
					else
						temp12 = (ty4 == "stmt")
					end
					if temp12 then
						local count1 = meta2["count"]
						append_21_1(out7, format1("%s = function(", escapeVar1(node4["defVar"], state3)))
						local r_1731 = nil
						r_1731 = (function(r_1741)
							if (r_1741 <= count1) then
								if (r_1741 == 1) then
								else
									append_21_1(out7, ", ")
								end
								append_21_1(out7, _2e2e_2("v", tonumber1(r_1741)))
								return r_1731((r_1741 + 1))
							else
							end
						end)
						r_1731(1)
						append_21_1(out7, ") ")
						if (ty4 == "expr") then
							append_21_1(out7, "return ")
						else
						end
						local r_1781 = meta2["contents"]
						local r_1811 = _23_1(r_1781)
						local r_1791 = nil
						r_1791 = (function(r_1801)
							if (r_1801 <= r_1811) then
								local entry2 = r_1781[r_1801]
								if number_3f_1(entry2) then
									append_21_1(out7, _2e2e_2("v", tonumber1(entry2)))
								else
									append_21_1(out7, entry2)
								end
								return r_1791((r_1801 + 1))
							else
							end
						end)
						r_1791(1)
						return append_21_1(out7, " end")
					else
						_error("unmatched item")
					end
				end
			elseif (var2 == builtins1["quote"]) then
				if (ret1 == "") then
				else
					if ret1 then
						append_21_1(out7, ret1)
					else
					end
					return compileQuote1(nth1(node4, 2), out7, state3)
				end
			elseif (var2 == builtins1["syntax-quote"]) then
				if (ret1 == "") then
					append_21_1(out7, "local _ =")
				elseif ret1 then
					append_21_1(out7, ret1)
				else
				end
				return compileQuote1(nth1(node4, 2), out7, state3, 1)
			elseif (var2 == builtins1["unquote"]) then
				return fail_21_1("unquote outside of syntax-quote")
			elseif (var2 == builtins1["unquote-splice"]) then
				return fail_21_1("unquote-splice outside of syntax-quote")
			elseif (var2 == builtins1["import"]) then
				if (ret1 == nil) then
					return append_21_1(out7, "nil")
				elseif (ret1 ~= "") then
					append_21_1(out7, ret1)
					return append_21_1(out7, "nil")
				else
				end
			else
				local meta3
				local r_1941 = symbol_3f_1(head2)
				if r_1941 then
					local r_1951 = (head2["var"]["tag"] == "native")
					if r_1951 then
						meta3 = state3["meta"][head2["var"]["fullName"]]
					else
						meta3 = r_1951
					end
				else
					meta3 = r_1941
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
				local r_1831 = meta3
				if r_1831 then
					temp13 = (pred1(_23_1(node4)) == meta3["count"])
				else
					temp13 = r_1831
				end
				if temp13 then
					local temp14
					local r_1841 = ret1
					if r_1841 then
						temp14 = (meta3["tag"] == "expr")
					else
						temp14 = r_1841
					end
					if temp14 then
						append_21_1(out7, ret1)
					else
					end
					local contents2 = meta3["contents"]
					local r_1871 = _23_1(contents2)
					local r_1851 = nil
					r_1851 = (function(r_1861)
						if (r_1861 <= r_1871) then
							local entry3 = nth1(contents2, r_1861)
							if number_3f_1(entry3) then
								compileExpression1(nth1(node4, succ1(entry3)), out7, state3)
							else
								append_21_1(out7, entry3)
							end
							return r_1851((r_1861 + 1))
						else
						end
					end)
					r_1851(1)
					local temp15
					local r_1891 = (meta3["tag"] ~= "expr")
					if r_1891 then
						temp15 = (ret1 ~= "")
					else
						temp15 = r_1891
					end
					if temp15 then
						line_21_1(out7)
						append_21_1(out7, ret1)
						append_21_1(out7, "nil")
						return line_21_1(out7)
					else
					end
				else
					if ret1 then
						append_21_1(out7, ret1)
					else
					end
					compileExpression1(head2, out7, state3)
					append_21_1(out7, "(")
					local r_1921 = _23_1(node4)
					local r_1901 = nil
					r_1901 = (function(r_1911)
						if (r_1911 <= r_1921) then
							if (r_1911 > 2) then
								append_21_1(out7, ", ")
							else
							end
							compileExpression1(nth1(node4, r_1911), out7, state3)
							return r_1901((r_1911 + 1))
						else
						end
					end)
					r_1901(2)
					return append_21_1(out7, ")")
				end
			end
		else
			local temp16
			local r_1961 = ret1
			if r_1961 then
				local r_1971 = list_3f_1(head2)
				if r_1971 then
					local r_1981 = symbol_3f_1(car2(head2))
					if r_1981 then
						temp16 = (head2[1]["var"] == builtins1["lambda"])
					else
						temp16 = r_1981
					end
				else
					temp16 = r_1971
				end
			else
				temp16 = r_1961
			end
			if temp16 then
				local args3 = nth1(head2, 2)
				local offset2 = 1
				local r_2011 = _23_1(args3)
				local r_1991 = nil
				r_1991 = (function(r_2001)
					if (r_2001 <= r_2011) then
						local var4 = args3[r_2001]["var"]
						append_21_1(out7, _2e2e_2("local ", escapeVar1(var4, state3)))
						if var4["isVariadic"] then
							local count2 = (_23_1(node4) - _23_1(args3))
							if (count2 < 0) then
								count2 = 0
							else
							end
							append_21_1(out7, " = { tag=\"list\", n=")
							append_21_1(out7, tostring1(count2))
							local r_2051 = count2
							local r_2031 = nil
							r_2031 = (function(r_2041)
								if (r_2041 <= r_2051) then
									append_21_1(out7, ", ")
									compileExpression1(nth1(node4, (r_2001 + r_2041)), out7, state3)
									return r_2031((r_2041 + 1))
								else
								end
							end)
							r_2031(1)
							offset2 = count2
							line_21_1(out7, "}")
						else
							local expr2 = nth1(node4, (r_2001 + offset2))
							local name2 = escapeVar1(var4, state3)
							local ret2 = nil
							if expr2 then
								if statement_3f_1(expr2) then
									ret2 = _2e2e_2(name2, " = ")
									line_21_1(out7)
								else
									append_21_1(out7, " = ")
								end
								compileExpression1(expr2, out7, state3, ret2)
								line_21_1(out7)
							else
								line_21_1(out7)
							end
						end
						return r_1991((r_2001 + 1))
					else
					end
				end)
				r_1991(1)
				local r_2091 = _23_1(node4)
				local r_2071 = nil
				r_2071 = (function(r_2081)
					if (r_2081 <= r_2091) then
						compileExpression1(nth1(node4, r_2081), out7, state3, "")
						line_21_1(out7)
						return r_2071((r_2081 + 1))
					else
					end
				end)
				r_2071((_23_1(args3) + (offset2 + 1)))
				return compileBlock1(head2, out7, state3, 3, ret1)
			else
				if ret1 then
					append_21_1(out7, ret1)
				else
				end
				compileExpression1(car2(node4), out7, state3)
				append_21_1(out7, "(")
				local r_2131 = _23_1(node4)
				local r_2111 = nil
				r_2111 = (function(r_2121)
					if (r_2121 <= r_2131) then
						if (r_2121 > 2) then
							append_21_1(out7, ", ")
						else
						end
						compileExpression1(nth1(node4, r_2121), out7, state3)
						return r_2111((r_2121 + 1))
					else
					end
				end)
				r_2111(2)
				return append_21_1(out7, ")")
			end
		end
	else
		if (ret1 == "") then
		else
			if ret1 then
				append_21_1(out7, ret1)
			else
			end
			if symbol_3f_1(node4) then
				return append_21_1(out7, escapeVar1(node4["var"], state3))
			elseif string_3f_1(node4) then
				return append_21_1(out7, quoted1(node4["value"]))
			elseif number_3f_1(node4) then
				return append_21_1(out7, tostring1(node4["value"]))
			elseif key_3f_1(node4) then
				return append_21_1(out7, quoted1(node4["value"]))
			else
				return error1(_2e2e_2("Unknown type: ", type1(node4)))
			end
		end
	end
end)
compileBlock1 = (function(nodes1, out8, state4, start2, ret3)
	local r_1091 = _23_1(nodes1)
	local r_1071 = nil
	r_1071 = (function(r_1081)
		if (r_1081 <= r_1091) then
			local ret_27_1
			if (r_1081 == _23_1(nodes1)) then
				ret_27_1 = ret3
			else
				ret_27_1 = ""
			end
			compileExpression1(nth1(nodes1, r_1081), out8, state4, ret_27_1)
			line_21_1(out8)
			return r_1071((r_1081 + 1))
		else
		end
	end)
	return r_1071(start2)
end)
prelude1 = (function(out9)
	line_21_1(out9, "if not table.pack then table.pack = function(...) return { n = select(\"#\", ...), ... } end end")
	line_21_1(out9, "if not table.unpack then table.unpack = unpack end")
	line_21_1(out9, "local load = load if _VERSION:find(\"5.1\") then load = function(x, _, _, env) local f, e = loadstring(x); if not f then error(e, 1) end; return setfenv(f, env) end end")
	return line_21_1(out9, "local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error")
end)
backend1 = struct1("createState", createState1, "escape", escape1, "escapeVar", escapeVar1, "block", compileBlock1, "expression", compileExpression1, "prelude", prelude1)
estimateLength1 = (function(node5, max1)
	local tag3 = node5["tag"]
	local temp17
	local r_2151 = (tag3 == "string")
	if r_2151 then
		temp17 = r_2151
	else
		local r_2161 = (tag3 == "number")
		if r_2161 then
			temp17 = r_2161
		else
			local r_2171 = (tag3 == "symbol")
			if r_2171 then
				temp17 = r_2171
			else
				temp17 = (tag3 == "key")
			end
		end
	end
	if temp17 then
		return len1(tostring1(node5["contents"]))
	elseif (tag3 == "list") then
		local sum1 = 2
		local i3 = 1
		local r_2181 = nil
		r_2181 = (function()
			local temp18
			local r_2191 = (sum1 <= max1)
			if r_2191 then
				temp18 = (i3 <= _23_1(node5))
			else
				temp18 = r_2191
			end
			if temp18 then
				sum1 = (sum1 + estimateLength1(nth1(node5, i3), (max1 - sum1)))
				if (i3 > 1) then
					sum1 = (sum1 + 1)
				else
				end
				i3 = (i3 + 1)
				return r_2181()
			else
			end
		end)
		r_2181()
		return sum1
	else
		return fail_21_1(_2e2e_2("Unknown tag ", tag3))
	end
end)
expression1 = (function(node6, writer9)
	local tag4 = node6["tag"]
	if (tag4 == "string") then
		return append_21_1(writer9, quoted1(node6["value"]))
	elseif (tag4 == "number") then
		return append_21_1(writer9, tostring1(node6["value"]))
	elseif (tag4 == "key") then
		return append_21_1(writer9, _2e2e_2(":", node6["value"]))
	elseif (tag4 == "symbol") then
		return append_21_1(writer9, node6["contents"])
	elseif (tag4 == "list") then
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
			local r_2281 = _23_1(node6)
			local r_2261 = nil
			r_2261 = (function(r_2271)
				if (r_2271 <= r_2281) then
					local entry4 = nth1(node6, r_2271)
					local temp19
					local r_2301 = _21_1(newline1)
					if r_2301 then
						temp19 = (max2 > 0)
					else
						temp19 = r_2301
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
					return r_2261((r_2271 + 1))
				else
				end
			end)
			r_2261(2)
			if newline1 then
				unindent_21_1(writer9)
			else
			end
			return append_21_1(writer9, ")")
		end
	else
		return fail_21_1(_2e2e_2("Unknown tag ", tag4))
	end
end)
block1 = (function(list2, writer10)
	local r_2241 = _23_1(list2)
	local r_2221 = nil
	r_2221 = (function(r_2231)
		if (r_2231 <= r_2241) then
			local node7 = list2[r_2231]
			expression1(node7, writer10)
			line_21_1(writer10)
			return r_2221((r_2231 + 1))
		else
		end
	end)
	return r_2221(1)
end)
backend2 = struct1("expression", expression1, "block", block1)
abs1 = math.abs
max3 = math.max
builtins2 = require1("tacky.analysis.resolve")["builtins"]
tokens1 = {tag = "list", n = 4, {tag = "list", n = 2, "arg", "(%f[%a]%u+%f[%A])"}, {tag = "list", n = 2, "mono", "```[a-z]*\n([^`]*)\n```"}, {tag = "list", n = 2, "mono", "`([^`]*)`"}, {tag = "list", n = 2, "link", "%[%[(.-)%]%]"}}
extractSignature1 = (function(var5)
	local ty5 = type1(var5)
	local temp20
	local r_2311 = (ty5 == "macro")
	if r_2311 then
		temp20 = r_2311
	else
		temp20 = (ty5 == "defined")
	end
	if temp20 then
		local root1 = var5["node"]
		local node8 = nth1(root1, _23_1(root1))
		local temp21
		local r_2321 = list_3f_1(node8)
		if r_2321 then
			local r_2331 = symbol_3f_1(car2(node8))
			if r_2331 then
				temp21 = (car2(node8)["var"] == builtins2["lambda"])
			else
				temp21 = r_2331
			end
		else
			temp21 = r_2321
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
	local out10 = {tag = "list", n = 0}
	local pos2 = 1
	local len3 = len1(str2)
	local r_2341 = nil
	r_2341 = (function()
		if (pos2 <= len3) then
			local spos1 = len3
			local epos1 = nil
			local name3 = nil
			local ptrn1 = nil
			local r_2391 = _23_1(tokens1)
			local r_2371 = nil
			r_2371 = (function(r_2381)
				if (r_2381 <= r_2391) then
					local tok1 = tokens1[r_2381]
					local npos1 = list1(find1(str2, nth1(tok1, 2), pos2))
					local temp22
					local r_2411 = car2(npos1)
					if r_2411 then
						temp22 = (car2(npos1) < spos1)
					else
						temp22 = r_2411
					end
					if temp22 then
						spos1 = car2(npos1)
						epos1 = nth1(npos1, 2)
						name3 = car2(tok1)
						ptrn1 = nth1(tok1, 2)
					else
					end
					return r_2371((r_2381 + 1))
				else
				end
			end)
			r_2371(1)
			if name3 then
				if (pos2 < spos1) then
					pushCdr_21_1(out10, struct1("tag", "text", "contents", sub1(str2, pos2, pred1(spos1))))
				else
				end
				pushCdr_21_1(out10, struct1("tag", name3, "whole", sub1(str2, spos1, epos1), "contents", match1(sub1(str2, spos1, epos1), ptrn1)))
				pos2 = succ1(epos1)
			else
				pushCdr_21_1(out10, struct1("tag", "text", "contents", sub1(str2, pos2, len3)))
				pos2 = succ1(len3)
			end
			return r_2341()
		else
		end
	end)
	r_2341()
	return out10
end)
struct1("parseDocs", parseDocstring1, "extractSignature", extractSignature1)
config1 = package.config
coloredAnsi1 = (function(col1, msg1)
	return _2e2e_2("\27[", col1, "m", msg1, "\27[0m")
end)
local temp23
if config1 then
	temp23 = (charAt1(config1, 1) ~= "\\")
else
	temp23 = config1
end
if temp23 then
	colored_3f_1 = true
else
	local temp24
	if getenv1 then
		temp24 = (getenv1("ANSICON") ~= nil)
	else
		temp24 = getenv1
	end
	if temp24 then
		colored_3f_1 = true
	else
		local temp25
		if getenv1 then
			local term1 = getenv1("TERM")
			if term1 then
				temp25 = find1(term1, "xterm")
			else
				temp25 = nil
			end
		else
			temp25 = getenv1
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
setExplain_21_1 = (function(value2)
	showExplain1["value"] = value2
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
formatNode1 = (function(node9)
	local temp26
	local r_2421 = node9["range"]
	if r_2421 then
		temp26 = node9["contents"]
	else
		temp26 = r_2421
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
		local r_2551 = node9["start"]
		if r_2551 then
			temp27 = node9["finish"]
		else
			temp27 = r_2551
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
	local r_2431 = nil
	r_2431 = (function()
		local temp28
		local r_2441 = node10
		if r_2441 then
			temp28 = _21_1(result2)
		else
			temp28 = r_2441
		end
		if temp28 then
			result2 = node10["range"]
			node10 = node10["parent"]
			return r_2431()
		else
		end
	end)
	r_2431()
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
	local maxLine1 = foldr1((function(node11, max4)
		if string_3f_1(node11) then
			return max4
		else
			return max3(max4, node11["start"]["line"])
		end
	end), 0, entries1)
	local code1 = _2e2e_2(colored1(92, _2e2e_2(" %", len1(tostring1(maxLine1)), "s |")), " %s")
	local r_2581 = _23_1(entries1)
	local r_2561 = nil
	r_2561 = (function(r_2571)
		if (r_2571 <= r_2581) then
			local position1 = entries1[r_2571]
			local message1 = entries1[succ1(r_2571)]
			if (file1 ~= position1["name"]) then
				file1 = position1["name"]
				print1(colored1(95, _2e2e_2(" ", file1)))
			else
				local temp29
				local r_2601 = (previous1 ~= -1)
				if r_2601 then
					temp29 = (abs1((position1["start"]["line"] - previous1)) > 2)
				else
					temp29 = r_2601
				end
				if temp29 then
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
				local temp30
				local r_2611 = position1["finish"]
				if r_2611 then
					temp30 = (position1["start"]["line"] == position1["finish"]["line"])
				else
					temp30 = r_2611
				end
				if temp30 then
					pointer1 = rep1("^", succ1((position1["finish"]["column"] - position1["start"]["column"])))
				else
					pointer1 = "^..."
				end
			end
			print1(format1(code1, "", _2e2e_2(rep1(" ", (position1["start"]["column"] - 1)), pointer1, " ", message1)))
			return r_2561((r_2571 + 2))
		else
		end
	end)
	return r_2561(1)
end)
putTrace_21_1 = (function(node12)
	local previous2 = nil
	local r_2451 = nil
	r_2451 = (function()
		if node12 then
			local formatted1 = formatNode1(node12)
			if (previous2 == nil) then
				print1(colored1(96, _2e2e_2("  => ", formatted1)))
			elseif (previous2 ~= formatted1) then
				print1(_2e2e_2("  in ", formatted1))
			else
			end
			previous2 = formatted1
			node12 = node12["parent"]
			return r_2451()
		else
		end
	end)
	return r_2451()
end)
putExplain_21_1 = (function(...)
	local lines3 = _pack(...) lines3.tag = "list"
	if showExplain1["value"] then
		local r_2501 = _23_1(lines3)
		local r_2481 = nil
		r_2481 = (function(r_2491)
			if (r_2491 <= r_2501) then
				local line1 = lines3[r_2491]
				print1(_2e2e_2("  ", line1))
				return r_2481((r_2491 + 1))
			else
			end
		end)
		return r_2481(1)
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
	local ty6 = type1(var6)
	if (ty6 == "builtin") then
		return "Builtin term"
	elseif (ty6 == "macro") then
		return _2e2e_2("Macro defined at ", formatRange2(getSource1(var6["node"])))
	elseif (ty6 == "native") then
		return _2e2e_2("Native defined at ", formatRange2(getSource1(var6["node"])))
	elseif (ty6 == "defined") then
		return _2e2e_2("Defined at ", formatRange2(getSource1(var6["node"])))
	else
		_error("unmatched item")
	end
end)
formatSignature1 = (function(name4, var7)
	local sig1 = extractSignature1(var7)
	if (sig1 == nil) then
		return name4
	elseif nil_3f_1(sig1) then
		return _2e2e_2("(", name4, ")")
	else
		return _2e2e_2("(", name4, " ", concat1(traverse1(sig1, (function(r_2621)
			return r_2621["contents"]
		end)), " "), ")")
	end
end)
exported1 = (function(out11, title1, primary1, vars1)
	local documented1 = {tag = "list", n = 0}
	local undocumented1 = {tag = "list", n = 0}
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
	line_21_1(out11, "---")
	line_21_1(out11, _2e2e_2("title: ", title1))
	line_21_1(out11, "---")
	line_21_1(out11, _2e2e_2("# ", title1))
	if primary1 then
		line_21_1(out11, primary1)
	else
	end
	local r_2671 = _23_1(documented1)
	local r_2651 = nil
	r_2651 = (function(r_2661)
		if (r_2661 <= r_2671) then
			local entry5 = documented1[r_2661]
			local name6 = car2(entry5)
			local var9 = nth1(entry5, 2)
			line_21_1(out11, _2e2e_2("## `", formatSignature1(name6, var9), "`"))
			line_21_1(out11, _2e2e_2("*", formatDefinition1(var9), "*"))
			line_21_1(out11, "", true)
			local r_2701 = parseDocstring1(var9["doc"])
			local r_2731 = _23_1(r_2701)
			local r_2711 = nil
			r_2711 = (function(r_2721)
				if (r_2721 <= r_2731) then
					local tok2 = r_2701[r_2721]
					local ty7 = type1(tok2)
					if (ty7 == "text") then
						append_21_1(out11, tok2["contents"])
					elseif (ty7 == "arg") then
						append_21_1(out11, _2e2e_2("`", tok2["contents"], "`"))
					elseif (ty7 == "mono") then
						append_21_1(out11, tok2["whole"])
					elseif (ty7 == "link") then
						local name7 = tok2["contents"]
						local scope1 = var9["scope"]
						local ovar1 = scope1["get"](scope1, name7, nil, true)
						if ovar1 then
							local loc1
							local r_2791
							local r_2781
							local r_2771
							local r_2761 = ovar1["node"]
							r_2771 = getSource1(r_2761)
							r_2781 = r_2771["name"]
							r_2791 = gsub1(r_2781, "%.lisp$", "")
							loc1 = gsub1(r_2791, "/", ".")
							local sig2 = extractSignature1(ovar1)
							local hash1
							if (sig2 == nil) then
								hash1 = ovar1["name"]
							elseif nil_3f_1(sig2) then
								hash1 = ovar1["name"]
							else
								hash1 = _2e2e_2(name7, " ", concat1(traverse1(sig2, (function(r_2751)
									return r_2751["contents"]
								end)), " "))
							end
							append_21_1(out11, format1("[`%s`](%s.md#%s)", name7, loc1, gsub1(hash1, "%A+", "-")))
						else
							append_21_1(out11, format1("`%s`", name7))
						end
					else
						_error("unmatched item")
					end
					return r_2711((r_2721 + 1))
				else
				end
			end)
			r_2711(1)
			line_21_1(out11)
			line_21_1(out11, "", true)
			return r_2651((r_2661 + 1))
		else
		end
	end)
	r_2651(1)
	if nil_3f_1(undocumented1) then
	else
		line_21_1(out11, "## Undocumented symbols")
	end
	local r_2841 = _23_1(undocumented1)
	local r_2821 = nil
	r_2821 = (function(r_2831)
		if (r_2831 <= r_2841) then
			local entry6 = undocumented1[r_2831]
			local name8 = car2(entry6)
			local var10 = nth1(entry6, 2)
			line_21_1(out11, _2e2e_2(" - `", formatSignature1(name8, var10), "` *", formatDefinition1(var10), "*"))
			return r_2821((r_2831 + 1))
		else
		end
	end)
	return r_2821(1)
end)
backend3 = struct1("exported", exported1)
wrapGenerate1 = (function(func2)
	return (function(node14, ...)
		local args4 = _pack(...) args4.tag = "list"
		local writer11 = create1()
		func2(node14, writer11, unpack1(args4, 1, _23_1(args4)))
		return _2d3e_string1(writer11)
	end)
end)
wrapNormal1 = (function(func3)
	return (function(...)
		local args5 = _pack(...) args5.tag = "list"
		local writer12 = create1()
		func3(writer12, unpack1(args5, 1, _23_1(args5)))
		return _2d3e_string1(writer12)
	end)
end)
return struct1("lua", struct1("expression", wrapGenerate1(compileExpression1), "block", wrapGenerate1(compileBlock1), "prelude", wrapNormal1(prelude1), "backend", backend1), "lisp", struct1("expression", wrapGenerate1(expression1), "block", wrapGenerate1(block1), "backend", backend2), "markdown", struct1("exported", wrapNormal1(exported1), "backend", backend3))
