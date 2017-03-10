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
for k, v in pairs(_temp) do _libs["lua/basic-0/".. k] = v end
local _3d_1, _2f3d_1, _3c_1, _3c3d_1, _3e_1, _2b_1, _2d_1, _25_1, slice1, error1, getIdx1, setIdx_21_1, require1, tonumber1, tostring1, type_23_1, _23_1, byte1, char1, find1, format1, gsub1, len1, match1, rep1, sub1, upper1, concat1, sort1, unpack1, emptyStruct1, iterPairs1, car1, cdr1, list1, cons1, _21_1, list_3f_1, nil_3f_1, string_3f_1, number_3f_1, symbol_3f_1, key_3f_1, exists_3f_1, type1, car2, cdr2, map1, traverse1, last1, nth1, pushCdr_21_1, popLast_21_1, reverse1, charAt1, _2e2e_1, quoted1, struct1, succ1, pred1, fail_21_1, formatPosition1, formatRange1, formatNode1, getSource1, create1, append_21_1, line_21_1, indent_21_1, unindent_21_1, beginBlock_21_1, nextBlock_21_1, endBlock_21_1, pushNode_21_1, popNode_21_1, _2d3e_string1, createLookup1, keywords1, createState1, builtins1, builtinVars1, escape1, escapeVar1, statement_3f_1, literal_3f_1, truthy_3f_1, compileQuote1, compileExpression1, compileBlock1, prelude1, backend1, estimateLength1, expression1, block1, backend2, builtins2, tokens1, extractSignature1, parseDocstring1, Scope1, formatRange2, sortVars_21_1, formatDefinition1, formatSignature1, writeDocstring1, exported1, backend3, wrapGenerate1, wrapNormal1
_3d_1 = function(v1, v2) return (v1 == v2) end
_2f3d_1 = function(v1, v2) return (v1 ~= v2) end
_3c_1 = function(v1, v2) return (v1 < v2) end
_3c3d_1 = function(v1, v2) return (v1 <= v2) end
_3e_1 = function(v1, v2) return (v1 > v2) end
_2b_1 = function(v1, v2) return (v1 + v2) end
_2d_1 = function(v1, v2) return (v1 - v2) end
_25_1 = function(v1, v2) return (v1 % v2) end
slice1 = _libs["lua/basic-0/slice"]
error1 = error
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
	local r_361 = type1(x10)
	if (r_361 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_361), 2)
	else
	end
	return car1(x10)
end)
cdr2 = (function(x11)
	local r_371 = type1(x11)
	if (r_371 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_371), 2)
	else
	end
	if nil_3f_1(x11) then
		return {tag = "list", n = 0}
	else
		return cdr1(x11)
	end
end)
map1 = (function(f1, xs5, acc1)
	local r_391 = type1(f1)
	if (r_391 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "f", "function", r_391), 2)
	else
	end
	local r_561 = type1(xs5)
	if (r_561 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_561), 2)
	else
	end
	if _21_1(exists_3f_1(acc1)) then
		return map1(f1, xs5, {tag = "list", n = 0})
	elseif nil_3f_1(xs5) then
		return reverse1(acc1)
	else
		return map1(f1, cdr2(xs5), cons1(f1(car2(xs5)), acc1))
	end
end)
traverse1 = (function(xs6, f2)
	return map1(f2, xs6)
end)
last1 = (function(xs7)
	local r_451 = type1(xs7)
	if (r_451 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_451), 2)
	else
	end
	return xs7[_23_1(xs7)]
end)
nth1 = (function(xs8, idx1)
	return xs8[idx1]
end)
pushCdr_21_1 = (function(xs9, val2)
	local r_461 = type1(xs9)
	if (r_461 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_461), 2)
	else
	end
	local len2 = (_23_1(xs9) + 1)
	xs9["n"] = len2
	xs9[len2] = val2
	return xs9
end)
popLast_21_1 = (function(xs10)
	local r_471 = type1(xs10)
	if (r_471 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_471), 2)
	else
	end
	xs10[_23_1(xs10)] = nil
	xs10["n"] = (_23_1(xs10) - 1)
	return xs10
end)
reverse1 = (function(xs11, acc2)
	if _21_1(exists_3f_1(acc2)) then
		return reverse1(xs11, {tag = "list", n = 0})
	elseif nil_3f_1(xs11) then
		return acc2
	else
		return reverse1(cdr2(xs11), cons1(car2(xs11), acc2))
	end
end)
charAt1 = (function(xs12, x12)
	return sub1(xs12, x12, x12)
end)
_2e2e_1 = (function(...)
	local args1 = _pack(...) args1.tag = "list"
	return concat1(args1)
end)
local escapes1 = ({})
local r_611 = nil
r_611 = (function(r_621)
	if (r_621 <= 31) then
		escapes1[char1(r_621)] = _2e2e_1("\\", tostring1(r_621))
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
struct1 = (function(...)
	local keys1 = _pack(...) keys1.tag = "list"
	if ((_23_1(keys1) % 1) == 1) then
		error1("Expected an even number of arguments to struct", 2)
	else
	end
	local contents1 = (function(key1)
		return key1["contents"]
	end)
	local out1 = ({})
	local r_761 = _23_1(keys1)
	local r_741 = nil
	r_741 = (function(r_751)
		if (r_751 <= r_761) then
			local key2 = keys1[r_751]
			local val3 = keys1[(1 + r_751)]
			out1[(function()
				if key_3f_1(key2) then
					return contents1(key2)
				else
					return key2
				end
			end)()
			] = val3
			return r_741((r_751 + 2))
		else
		end
	end)
	r_741(1)
	return out1
end)
succ1 = (function(x13)
	return (x13 + 1)
end)
pred1 = (function(x14)
	return (x14 - 1)
end)
fail_21_1 = (function(x15)
	return error1(x15, 0)
end)
formatPosition1 = (function(pos1)
	return _2e2e_1(pos1["line"], ":", pos1["column"])
end)
formatRange1 = (function(range1)
	if range1["finish"] then
		return format1("%s:[%s .. %s]", range1["name"], formatPosition1(range1["start"]), formatPosition1(range1["finish"]))
	else
		return format1("%s:[%s]", range1["name"], formatPosition1(range1["start"]))
	end
end)
formatNode1 = (function(node1)
	local temp1
	local r_1481 = node1["range"]
	if r_1481 then
		temp1 = node1["contents"]
	else
		temp1 = r_1481
	end
	if temp1 then
		return format1("%s (%q)", formatRange1(node1["range"]), node1["contents"])
	elseif node1["range"] then
		return formatRange1(node1["range"])
	elseif node1["owner"] then
		local owner1 = node1["owner"]
		if owner1["var"] then
			return format1("macro expansion of %s (%s)", owner1["var"]["name"], formatNode1(owner1["node"]))
		else
			return format1("unquote expansion (%s)", formatNode1(owner1["node"]))
		end
	else
		local temp2
		local r_1511 = node1["start"]
		if r_1511 then
			temp2 = node1["finish"]
		else
			temp2 = r_1511
		end
		if temp2 then
			return formatRange1(node1)
		else
			return "?"
		end
	end
end)
getSource1 = (function(node2)
	local result2 = nil
	local r_1491 = nil
	r_1491 = (function()
		local temp3
		local r_1501 = node2
		if r_1501 then
			temp3 = _21_1(result2)
		else
			temp3 = r_1501
		end
		if temp3 then
			result2 = node2["range"]
			node2 = node2["parent"]
			return r_1491()
		else
		end
	end)
	r_1491()
	return result2
end)
struct1("formatPosition", formatPosition1, "formatRange", formatRange1, "formatNode", formatNode1, "getSource", getSource1)
create1 = (function()
	return struct1("out", {tag = "list", n = 0}, "indent", 0, "tabs-pending", false, "line", 1, "lines", ({}), "node-stack", {tag = "list", n = 0}, "active-pos", nil)
end)
append_21_1 = (function(writer1, text1)
	local r_1461 = type1(text1)
	if (r_1461 ~= "string") then
		error1(format1("bad argment %s (expected %s, got %s)", "text", "string", r_1461), 2)
	else
	end
	local pos2 = writer1["active-pos"]
	if pos2 then
		local line1 = writer1["lines"][writer1["line"]]
		if line1 then
		else
			line1 = ({})
			writer1["lines"][writer1["line"]] = line1
		end
		line1[pos2] = true
	else
	end
	if writer1["tabs-pending"] then
		writer1["tabs-pending"] = false
		pushCdr_21_1(writer1["out"], rep1("\9", writer1["indent"]))
	else
	end
	return pushCdr_21_1(writer1["out"], text1)
end)
line_21_1 = (function(writer2, text2, force1)
	if text2 then
		append_21_1(writer2, text2)
	else
	end
	local temp4
	if force1 then
		temp4 = force1
	else
		temp4 = _21_1(writer2["tabs-pending"])
	end
	if temp4 then
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
beginBlock_21_1 = (function(writer5, text3)
	line_21_1(writer5, text3)
	return indent_21_1(writer5)
end)
nextBlock_21_1 = (function(writer6, text4)
	unindent_21_1(writer6)
	line_21_1(writer6, text4)
	return indent_21_1(writer6)
end)
endBlock_21_1 = (function(writer7, text5)
	unindent_21_1(writer7)
	return line_21_1(writer7, text5)
end)
pushNode_21_1 = (function(writer8, node3)
	local range2 = getSource1(node3)
	if range2 then
		pushCdr_21_1(writer8["node-stack"], node3)
		writer8["active-pos"] = range2
		return nil
	else
	end
end)
popNode_21_1 = (function(writer9, node4)
	local range3 = getSource1(node4)
	if range3 then
		local stack1 = writer9["node-stack"]
		local previous1 = last1(stack1)
		if (previous1 == node4) then
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
createLookup1 = (function(...)
	local lst1 = _pack(...) lst1.tag = "list"
	local out2 = ({})
	local r_1561 = _23_1(lst1)
	local r_1541 = nil
	r_1541 = (function(r_1551)
		if (r_1551 <= r_1561) then
			local entry1 = lst1[r_1551]
			out2[entry1] = true
			return r_1541((r_1551 + 1))
		else
		end
	end)
	r_1541(1)
	return out2
end)
keywords1 = createLookup1("and", "break", "do", "else", "elseif", "end", "false", "for", "function", "if", "in", "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while")
createState1 = (function(meta1)
	return struct1("ctr-lookup", ({}), "var-lookup", ({}), "meta", (function()
		if meta1 then
			return meta1
		else
			return ({})
		end
	end)())
end)
builtins1 = require1("tacky.analysis.resolve")["builtins"]
builtinVars1 = require1("tacky.analysis.resolve")["declaredVars"]
escape1 = (function(name1)
	if keywords1[name1] then
		return _2e2e_1("_e", name1)
	elseif find1(name1, "^%w[_%w%d]*$") then
		return name1
	else
		local out3
		local temp5
		local r_2021
		r_2021 = charAt1(name1, 1)
		temp5 = find1(r_2021, "%d")
		if temp5 then
			out3 = "_e"
		else
			out3 = ""
		end
		local upper2 = false
		local esc1 = false
		local r_1701 = len1(name1)
		local r_1681 = nil
		r_1681 = (function(r_1691)
			if (r_1691 <= r_1701) then
				local char2 = charAt1(name1, r_1691)
				local temp6
				local r_1721 = (char2 == "-")
				if r_1721 then
					local r_1731
					local r_1981
					r_1981 = charAt1(name1, pred1(r_1691))
					r_1731 = find1(r_1981, "[%a%d']")
					if r_1731 then
						local r_1961
						r_1961 = charAt1(name1, succ1(r_1691))
						temp6 = find1(r_1961, "[%a%d']")
					else
						temp6 = r_1731
					end
				else
					temp6 = r_1721
				end
				if temp6 then
					upper2 = true
				elseif find1(char2, "[^%w%d]") then
					local r_2001
					local r_1991 = char2
					r_2001 = byte1(r_1991)
					char2 = format1("%02x", r_2001)
					if esc1 then
					else
						esc1 = true
						out3 = _2e2e_1(out3, "_")
					end
					out3 = _2e2e_1(out3, char2)
				else
					if esc1 then
						esc1 = false
						out3 = _2e2e_1(out3, "_")
					else
					end
					if upper2 then
						upper2 = false
						char2 = upper1(char2)
					else
					end
					out3 = _2e2e_1(out3, char2)
				end
				return r_1681((r_1691 + 1))
			else
			end
		end)
		r_1681(1)
		if esc1 then
			out3 = _2e2e_1(out3, "_")
		else
		end
		return out3
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
			id1 = succ1((function(r_1591)
				if r_1591 then
					return r_1591
				else
					return 0
				end
			end)(state1["ctr-lookup"][v1]))
			state1["ctr-lookup"][v1] = id1
			state1["var-lookup"][var1] = id1
		end
		return _2e2e_1(v1, tostring1(id1))
	end
end)
statement_3f_1 = (function(node5)
	if list_3f_1(node5) then
		local first1 = car2(node5)
		if symbol_3f_1(first1) then
			return (first1["var"] == builtins1["cond"])
		elseif list_3f_1(first1) then
			local func1 = car2(first1)
			local r_1601 = symbol_3f_1(func1)
			if r_1601 then
				return (func1["var"] == builtins1["lambda"])
			else
				return r_1601
			end
		else
			return false
		end
	else
		return false
	end
end)
literal_3f_1 = (function(node6)
	if list_3f_1(node6) then
		local first2 = car2(node6)
		local r_1611 = symbol_3f_1(first2)
		if r_1611 then
			local r_1621 = (first2["var"] == builtins1["quote"])
			if r_1621 then
				return r_1621
			else
				return (first2["var"] == builtins1["syntax-quote"])
			end
		else
			return r_1611
		end
	elseif symbol_3f_1(node6) then
		return builtinVars1[node6["var"]]
	else
		return true
	end
end)
truthy_3f_1 = (function(node7)
	local r_1631 = symbol_3f_1(node7)
	if r_1631 then
		return (builtinVars1["true"] == node7["var"])
	else
		return r_1631
	end
end)
compileQuote1 = (function(node8, out4, state2, level1)
	if (level1 == 0) then
		return compileExpression1(node8, out4, state2)
	else
		local ty2 = type1(node8)
		if (ty2 == "string") then
			return append_21_1(out4, quoted1(node8["value"]))
		elseif (ty2 == "number") then
			return append_21_1(out4, tostring1(node8["value"]))
		elseif (ty2 == "symbol") then
			append_21_1(out4, _2e2e_1("{ tag=\"symbol\", contents=", quoted1(node8["contents"])))
			if node8["var"] then
				append_21_1(out4, _2e2e_1(", var=", quoted1(tostring1(node8["var"]))))
			else
			end
			return append_21_1(out4, "}")
		elseif (ty2 == "key") then
			return append_21_1(out4, _2e2e_1("{tag=\"key\", value=", quoted1(node8["value"]), "}"))
		elseif (ty2 == "list") then
			local first3 = car2(node8)
			local temp7
			local r_1741 = symbol_3f_1(first3)
			if r_1741 then
				local r_1751 = (first3["var"] == builtins1["unquote"])
				if r_1751 then
					temp7 = r_1751
				else
					temp7 = ("var" == builtins1["unquote-splice"])
				end
			else
				temp7 = r_1741
			end
			if temp7 then
				return compileQuote1(nth1(node8, 2), out4, state2, (function()
					if level1 then
						return pred1(level1)
					else
						return level1
					end
				end)())
			else
				local temp8
				local r_1771 = symbol_3f_1(first3)
				if r_1771 then
					temp8 = (first3["var"] == builtins1["syntax-quote"])
				else
					temp8 = r_1771
				end
				if temp8 then
					return compileQuote1(nth1(node8, 2), out4, state2, (function()
						if level1 then
							return succ1(level1)
						else
							return level1
						end
					end)())
				else
					pushNode_21_1(out4, node8)
					local containsUnsplice1 = false
					local r_1831 = _23_1(node8)
					local r_1811 = nil
					r_1811 = (function(r_1821)
						if (r_1821 <= r_1831) then
							local sub2 = node8[r_1821]
							local temp9
							local r_1851 = list_3f_1(sub2)
							if r_1851 then
								local r_1861 = symbol_3f_1(car2(sub2))
								if r_1861 then
									temp9 = (sub2[1]["var"] == builtins1["unquote-splice"])
								else
									temp9 = r_1861
								end
							else
								temp9 = r_1851
							end
							if temp9 then
								containsUnsplice1 = true
							else
							end
							return r_1811((r_1821 + 1))
						else
						end
					end)
					r_1811(1)
					if containsUnsplice1 then
						local offset1 = 0
						beginBlock_21_1(out4, "(function()")
						line_21_1(out4, "local _offset, _result, _temp = 0, {tag=\"list\",n=0}")
						local r_1891 = _23_1(node8)
						local r_1871 = nil
						r_1871 = (function(r_1881)
							if (r_1881 <= r_1891) then
								local sub3 = nth1(node8, r_1881)
								local temp10
								local r_1911 = list_3f_1(sub3)
								if r_1911 then
									local r_1921 = symbol_3f_1(car2(sub3))
									if r_1921 then
										temp10 = (sub3[1]["var"] == builtins1["unquote-splice"])
									else
										temp10 = r_1921
									end
								else
									temp10 = r_1911
								end
								if temp10 then
									offset1 = (offset1 + 1)
									append_21_1(out4, "_temp = ")
									compileQuote1(nth1(sub3, 2), out4, state2, pred1(level1))
									line_21_1(out4)
									line_21_1(out4, _2e2e_1("for _c = 1, _temp.n do _result[", tostring1((r_1881 - offset1)), " + _c + _offset] = _temp[_c] end"))
									line_21_1(out4, "_offset = _offset + _temp.n")
								else
									append_21_1(out4, _2e2e_1("_result[", tostring1((r_1881 - offset1)), " + _offset] = "))
									compileQuote1(sub3, out4, state2, level1)
									line_21_1(out4)
								end
								return r_1871((r_1881 + 1))
							else
							end
						end)
						r_1871(1)
						line_21_1(out4, _2e2e_1("_result.n = _offset + ", tostring1((_23_1(node8) - offset1))))
						line_21_1(out4, "return _result")
						endBlock_21_1(out4, "end)()")
					else
						append_21_1(out4, _2e2e_1("{tag = \"list\", n = ", tostring1(_23_1(node8))))
						local r_2071 = _23_1(node8)
						local r_2051 = nil
						r_2051 = (function(r_2061)
							if (r_2061 <= r_2071) then
								local sub4 = node8[r_2061]
								append_21_1(out4, ", ")
								compileQuote1(sub4, out4, state2, level1)
								return r_2051((r_2061 + 1))
							else
							end
						end)
						r_2051(1)
						append_21_1(out4, "}")
					end
					return popNode_21_1(out4, node8)
				end
			end
		else
			return error1(_2e2e_1("Unknown type ", ty2))
		end
	end
end)
compileExpression1 = (function(node9, out5, state3, ret1)
	if list_3f_1(node9) then
		pushNode_21_1(out5, node9)
		local head1 = car2(node9)
		if symbol_3f_1(head1) then
			local var2 = head1["var"]
			if (var2 == builtins1["lambda"]) then
				if (ret1 == "") then
				else
					if ret1 then
						append_21_1(out5, ret1)
					else
					end
					local args2 = nth1(node9, 2)
					local variadic1 = nil
					local i1 = 1
					append_21_1(out5, "(function(")
					local r_1931 = nil
					r_1931 = (function()
						local temp11
						local r_1941 = (i1 <= _23_1(args2))
						if r_1941 then
							temp11 = _21_1(variadic1)
						else
							temp11 = r_1941
						end
						if temp11 then
							if (i1 > 1) then
								append_21_1(out5, ", ")
							else
							end
							local var3 = args2[i1]["var"]
							if var3["isVariadic"] then
								append_21_1(out5, "...")
								variadic1 = i1
							else
								append_21_1(out5, escapeVar1(var3, state3))
							end
							i1 = (i1 + 1)
							return r_1931()
						else
						end
					end)
					r_1931()
					beginBlock_21_1(out5, ")")
					if variadic1 then
						local argsVar1 = escapeVar1(args2[variadic1]["var"], state3)
						if (variadic1 == _23_1(args2)) then
							line_21_1(out5, _2e2e_1("local ", argsVar1, " = _pack(...) ", argsVar1, ".tag = \"list\""))
						else
							local remaining1 = (_23_1(args2) - variadic1)
							line_21_1(out5, _2e2e_1("local _n = _select(\"#\", ...) - ", tostring1(remaining1)))
							append_21_1(out5, _2e2e_1("local ", argsVar1))
							local r_2111 = _23_1(args2)
							local r_2091 = nil
							r_2091 = (function(r_2101)
								if (r_2101 <= r_2111) then
									append_21_1(out5, ", ")
									append_21_1(out5, escapeVar1(args2[r_2101]["var"], state3))
									return r_2091((r_2101 + 1))
								else
								end
							end)
							r_2091(succ1(variadic1))
							line_21_1(out5)
							beginBlock_21_1(out5, "if _n > 0 then")
							append_21_1(out5, argsVar1)
							line_21_1(out5, " = { tag=\"list\", n=_n, _unpack(_pack(...), 1, _n)}")
							local r_2151 = _23_1(args2)
							local r_2131 = nil
							r_2131 = (function(r_2141)
								if (r_2141 <= r_2151) then
									append_21_1(out5, escapeVar1(args2[r_2141]["var"], state3))
									if (r_2141 < _23_1(args2)) then
										append_21_1(out5, ", ")
									else
									end
									return r_2131((r_2141 + 1))
								else
								end
							end)
							r_2131(succ1(variadic1))
							line_21_1(out5, " = select(_n + 1, ...)")
							nextBlock_21_1(out5, "else")
							append_21_1(out5, argsVar1)
							line_21_1(out5, " = { tag=\"list\", n=0}")
							local r_2191 = _23_1(args2)
							local r_2171 = nil
							r_2171 = (function(r_2181)
								if (r_2181 <= r_2191) then
									append_21_1(out5, escapeVar1(args2[r_2181]["var"], state3))
									if (r_2181 < _23_1(args2)) then
										append_21_1(out5, ", ")
									else
									end
									return r_2171((r_2181 + 1))
								else
								end
							end)
							r_2171(succ1(variadic1))
							line_21_1(out5, " = ...")
							endBlock_21_1(out5, "end")
						end
					else
					end
					compileBlock1(node9, out5, state3, 3, "return ")
					unindent_21_1(out5)
					append_21_1(out5, "end)")
				end
			elseif (var2 == builtins1["cond"]) then
				local closure1 = _21_1(ret1)
				local hadFinal1 = false
				local ends1 = 1
				if closure1 then
					beginBlock_21_1(out5, "(function()")
					ret1 = "return "
				else
				end
				local i2 = 2
				local r_2211 = nil
				r_2211 = (function()
					local temp12
					local r_2221 = _21_1(hadFinal1)
					if r_2221 then
						temp12 = (i2 <= _23_1(node9))
					else
						temp12 = r_2221
					end
					if temp12 then
						local item1 = nth1(node9, i2)
						local case1 = nth1(item1, 1)
						local isFinal1 = truthy_3f_1(case1)
						if isFinal1 then
							if (i2 == 2) then
								append_21_1(out5, "do")
							else
							end
						elseif statement_3f_1(case1) then
							if (i2 > 2) then
								indent_21_1(out5)
								line_21_1(out5)
								ends1 = (ends1 + 1)
							else
							end
							local tmp1 = escapeVar1(struct1("name", "temp"), state3)
							line_21_1(out5, _2e2e_1("local ", tmp1))
							compileExpression1(case1, out5, state3, _2e2e_1(tmp1, " = "))
							line_21_1(out5)
							line_21_1(out5, _2e2e_1("if ", tmp1, " then"))
						else
							append_21_1(out5, "if ")
							compileExpression1(case1, out5, state3)
							append_21_1(out5, " then")
						end
						indent_21_1(out5)
						line_21_1(out5)
						compileBlock1(item1, out5, state3, 2, ret1)
						unindent_21_1(out5)
						if isFinal1 then
							hadFinal1 = true
						else
							append_21_1(out5, "else")
						end
						i2 = (i2 + 1)
						return r_2211()
					else
					end
				end)
				r_2211()
				if hadFinal1 then
				else
					indent_21_1(out5)
					line_21_1(out5)
					append_21_1(out5, "_error(\"unmatched item\")")
					unindent_21_1(out5)
					line_21_1(out5)
				end
				local r_2251 = ends1
				local r_2231 = nil
				r_2231 = (function(r_2241)
					if (r_2241 <= r_2251) then
						append_21_1(out5, "end")
						if (r_2241 < ends1) then
							unindent_21_1(out5)
							line_21_1(out5)
						else
						end
						return r_2231((r_2241 + 1))
					else
					end
				end)
				r_2231(1)
				if closure1 then
					line_21_1(out5)
					endBlock_21_1(out5, "end)()")
				else
				end
			elseif (var2 == builtins1["set!"]) then
				compileExpression1(nth1(node9, 3), out5, state3, _2e2e_1(escapeVar1(node9[2]["var"], state3), " = "))
				local temp13
				local r_2271 = ret1
				if r_2271 then
					temp13 = (ret1 ~= "")
				else
					temp13 = r_2271
				end
				if temp13 then
					line_21_1(out5)
					append_21_1(out5, ret1)
					append_21_1(out5, "nil")
				else
				end
			elseif (var2 == builtins1["define"]) then
				compileExpression1(nth1(node9, _23_1(node9)), out5, state3, _2e2e_1(escapeVar1(node9["defVar"], state3), " = "))
			elseif (var2 == builtins1["define-macro"]) then
				compileExpression1(nth1(node9, _23_1(node9)), out5, state3, _2e2e_1(escapeVar1(node9["defVar"], state3), " = "))
			elseif (var2 == builtins1["define-native"]) then
				local meta2 = state3["meta"][node9["defVar"]["fullName"]]
				local ty3 = type1(meta2)
				if (ty3 == "nil") then
					append_21_1(out5, format1("%s = _libs[%q]", escapeVar1(node9["defVar"], state3), node9["defVar"]["fullName"]))
				elseif (ty3 == "var") then
					append_21_1(out5, format1("%s = %s", escapeVar1(node9["defVar"], state3), meta2["contents"]))
				else
					local temp14
					local r_2281 = (ty3 == "expr")
					if r_2281 then
						temp14 = r_2281
					else
						temp14 = (ty3 == "stmt")
					end
					if temp14 then
						local count1 = meta2["count"]
						append_21_1(out5, format1("%s = function(", escapeVar1(node9["defVar"], state3)))
						local r_2291 = nil
						r_2291 = (function(r_2301)
							if (r_2301 <= count1) then
								if (r_2301 == 1) then
								else
									append_21_1(out5, ", ")
								end
								append_21_1(out5, _2e2e_1("v", tonumber1(r_2301)))
								return r_2291((r_2301 + 1))
							else
							end
						end)
						r_2291(1)
						append_21_1(out5, ") ")
						if (ty3 == "expr") then
							append_21_1(out5, "return ")
						else
						end
						local r_2341 = meta2["contents"]
						local r_2371 = _23_1(r_2341)
						local r_2351 = nil
						r_2351 = (function(r_2361)
							if (r_2361 <= r_2371) then
								local entry2 = r_2341[r_2361]
								if number_3f_1(entry2) then
									append_21_1(out5, _2e2e_1("v", tonumber1(entry2)))
								else
									append_21_1(out5, entry2)
								end
								return r_2351((r_2361 + 1))
							else
							end
						end)
						r_2351(1)
						append_21_1(out5, " end")
					else
						_error("unmatched item")
					end
				end
			elseif (var2 == builtins1["quote"]) then
				if (ret1 == "") then
				else
					if ret1 then
						append_21_1(out5, ret1)
					else
					end
					compileQuote1(nth1(node9, 2), out5, state3)
				end
			elseif (var2 == builtins1["syntax-quote"]) then
				if (ret1 == "") then
					append_21_1(out5, "local _ =")
				elseif ret1 then
					append_21_1(out5, ret1)
				else
				end
				compileQuote1(nth1(node9, 2), out5, state3, 1)
			elseif (var2 == builtins1["unquote"]) then
				fail_21_1("unquote outside of syntax-quote")
			elseif (var2 == builtins1["unquote-splice"]) then
				fail_21_1("unquote-splice outside of syntax-quote")
			elseif (var2 == builtins1["import"]) then
				if (ret1 == nil) then
					append_21_1(out5, "nil")
				elseif (ret1 ~= "") then
					append_21_1(out5, ret1)
					append_21_1(out5, "nil")
				else
				end
			else
				local meta3
				local r_2501 = symbol_3f_1(head1)
				if r_2501 then
					local r_2511 = (head1["var"]["tag"] == "native")
					if r_2511 then
						meta3 = state3["meta"][head1["var"]["fullName"]]
					else
						meta3 = r_2511
					end
				else
					meta3 = r_2501
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
				local temp15
				local r_2391 = meta3
				if r_2391 then
					temp15 = (pred1(_23_1(node9)) == meta3["count"])
				else
					temp15 = r_2391
				end
				if temp15 then
					local temp16
					local r_2401 = ret1
					if r_2401 then
						temp16 = (meta3["tag"] == "expr")
					else
						temp16 = r_2401
					end
					if temp16 then
						append_21_1(out5, ret1)
					else
					end
					local contents2 = meta3["contents"]
					local r_2431 = _23_1(contents2)
					local r_2411 = nil
					r_2411 = (function(r_2421)
						if (r_2421 <= r_2431) then
							local entry3 = nth1(contents2, r_2421)
							if number_3f_1(entry3) then
								compileExpression1(nth1(node9, succ1(entry3)), out5, state3)
							else
								append_21_1(out5, entry3)
							end
							return r_2411((r_2421 + 1))
						else
						end
					end)
					r_2411(1)
					local temp17
					local r_2451 = (meta3["tag"] ~= "expr")
					if r_2451 then
						temp17 = (ret1 ~= "")
					else
						temp17 = r_2451
					end
					if temp17 then
						line_21_1(out5)
						append_21_1(out5, ret1)
						append_21_1(out5, "nil")
						line_21_1(out5)
					else
					end
				else
					if ret1 then
						append_21_1(out5, ret1)
					else
					end
					if literal_3f_1(head1) then
						append_21_1(out5, "(")
						compileExpression1(head1, out5, state3)
						append_21_1(out5, ")")
					else
						compileExpression1(head1, out5, state3)
					end
					append_21_1(out5, "(")
					local r_2481 = _23_1(node9)
					local r_2461 = nil
					r_2461 = (function(r_2471)
						if (r_2471 <= r_2481) then
							if (r_2471 > 2) then
								append_21_1(out5, ", ")
							else
							end
							compileExpression1(nth1(node9, r_2471), out5, state3)
							return r_2461((r_2471 + 1))
						else
						end
					end)
					r_2461(2)
					append_21_1(out5, ")")
				end
			end
		else
			local temp18
			local r_2521 = ret1
			if r_2521 then
				local r_2531 = list_3f_1(head1)
				if r_2531 then
					local r_2541 = symbol_3f_1(car2(head1))
					if r_2541 then
						temp18 = (head1[1]["var"] == builtins1["lambda"])
					else
						temp18 = r_2541
					end
				else
					temp18 = r_2531
				end
			else
				temp18 = r_2521
			end
			if temp18 then
				local args3 = nth1(head1, 2)
				local offset2 = 1
				local r_2571 = _23_1(args3)
				local r_2551 = nil
				r_2551 = (function(r_2561)
					if (r_2561 <= r_2571) then
						local var4 = args3[r_2561]["var"]
						append_21_1(out5, _2e2e_1("local ", escapeVar1(var4, state3)))
						if var4["isVariadic"] then
							local count2 = (_23_1(node9) - _23_1(args3))
							if (count2 < 0) then
								count2 = 0
							else
							end
							append_21_1(out5, " = { tag=\"list\", n=")
							append_21_1(out5, tostring1(count2))
							local r_2611 = count2
							local r_2591 = nil
							r_2591 = (function(r_2601)
								if (r_2601 <= r_2611) then
									append_21_1(out5, ", ")
									compileExpression1(nth1(node9, (r_2561 + r_2601)), out5, state3)
									return r_2591((r_2601 + 1))
								else
								end
							end)
							r_2591(1)
							offset2 = count2
							line_21_1(out5, "}")
						else
							local expr2 = nth1(node9, (r_2561 + offset2))
							local name2 = escapeVar1(var4, state3)
							local ret2 = nil
							if expr2 then
								if statement_3f_1(expr2) then
									ret2 = _2e2e_1(name2, " = ")
									line_21_1(out5)
								else
									append_21_1(out5, " = ")
								end
								compileExpression1(expr2, out5, state3, ret2)
								line_21_1(out5)
							else
								line_21_1(out5)
							end
						end
						return r_2551((r_2561 + 1))
					else
					end
				end)
				r_2551(1)
				local r_2651 = _23_1(node9)
				local r_2631 = nil
				r_2631 = (function(r_2641)
					if (r_2641 <= r_2651) then
						compileExpression1(nth1(node9, r_2641), out5, state3, "")
						line_21_1(out5)
						return r_2631((r_2641 + 1))
					else
					end
				end)
				r_2631((_23_1(args3) + (offset2 + 1)))
				compileBlock1(head1, out5, state3, 3, ret1)
			else
				if ret1 then
					append_21_1(out5, ret1)
				else
				end
				if literal_3f_1(car2(node9)) then
					append_21_1(out5, "(")
					compileExpression1(car2(node9), out5, state3)
					append_21_1(out5, ")")
				else
					compileExpression1(car2(node9), out5, state3)
				end
				append_21_1(out5, "(")
				local r_2691 = _23_1(node9)
				local r_2671 = nil
				r_2671 = (function(r_2681)
					if (r_2681 <= r_2691) then
						if (r_2681 > 2) then
							append_21_1(out5, ", ")
						else
						end
						compileExpression1(nth1(node9, r_2681), out5, state3)
						return r_2671((r_2681 + 1))
					else
					end
				end)
				r_2671(2)
				append_21_1(out5, ")")
			end
		end
		return popNode_21_1(out5, node9)
	else
		if (ret1 == "") then
		else
			if ret1 then
				append_21_1(out5, ret1)
			else
			end
			if symbol_3f_1(node9) then
				return append_21_1(out5, escapeVar1(node9["var"], state3))
			elseif string_3f_1(node9) then
				return append_21_1(out5, quoted1(node9["value"]))
			elseif number_3f_1(node9) then
				return append_21_1(out5, tostring1(node9["value"]))
			elseif key_3f_1(node9) then
				return append_21_1(out5, quoted1(node9["value"]))
			else
				return error1(_2e2e_1("Unknown type: ", type1(node9)))
			end
		end
	end
end)
compileBlock1 = (function(nodes1, out6, state4, start1, ret3)
	local r_1661 = _23_1(nodes1)
	local r_1641 = nil
	r_1641 = (function(r_1651)
		if (r_1651 <= r_1661) then
			local ret_27_1
			if (r_1651 == _23_1(nodes1)) then
				ret_27_1 = ret3
			else
				ret_27_1 = ""
			end
			compileExpression1(nth1(nodes1, r_1651), out6, state4, ret_27_1)
			line_21_1(out6)
			return r_1641((r_1651 + 1))
		else
		end
	end)
	return r_1641(start1)
end)
prelude1 = (function(out7)
	line_21_1(out7, "if not table.pack then table.pack = function(...) return { n = select(\"#\", ...), ... } end end")
	line_21_1(out7, "if not table.unpack then table.unpack = unpack end")
	line_21_1(out7, "local load = load if _VERSION:find(\"5.1\") then load = function(x, _, _, env) local f, e = loadstring(x); if not f then error(e, 1) end; return setfenv(f, env) end end")
	return line_21_1(out7, "local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error")
end)
backend1 = struct1("createState", createState1, "escape", escape1, "escapeVar", escapeVar1, "block", compileBlock1, "expression", compileExpression1, "prelude", prelude1)
estimateLength1 = (function(node10, max1)
	local tag2 = node10["tag"]
	local temp19
	local r_2711 = (tag2 == "string")
	if r_2711 then
		temp19 = r_2711
	else
		local r_2721 = (tag2 == "number")
		if r_2721 then
			temp19 = r_2721
		else
			local r_2731 = (tag2 == "symbol")
			if r_2731 then
				temp19 = r_2731
			else
				temp19 = (tag2 == "key")
			end
		end
	end
	if temp19 then
		return len1(tostring1(node10["contents"]))
	elseif (tag2 == "list") then
		local sum1 = 2
		local i3 = 1
		local r_2741 = nil
		r_2741 = (function()
			local temp20
			local r_2751 = (sum1 <= max1)
			if r_2751 then
				temp20 = (i3 <= _23_1(node10))
			else
				temp20 = r_2751
			end
			if temp20 then
				sum1 = (sum1 + estimateLength1(nth1(node10, i3), (max1 - sum1)))
				if (i3 > 1) then
					sum1 = (sum1 + 1)
				else
				end
				i3 = (i3 + 1)
				return r_2741()
			else
			end
		end)
		r_2741()
		return sum1
	else
		return fail_21_1(_2e2e_1("Unknown tag ", tag2))
	end
end)
expression1 = (function(node11, writer11)
	local tag3 = node11["tag"]
	if (tag3 == "string") then
		return append_21_1(writer11, quoted1(node11["value"]))
	elseif (tag3 == "number") then
		return append_21_1(writer11, tostring1(node11["value"]))
	elseif (tag3 == "key") then
		return append_21_1(writer11, _2e2e_1(":", node11["value"]))
	elseif (tag3 == "symbol") then
		return append_21_1(writer11, node11["contents"])
	elseif (tag3 == "list") then
		append_21_1(writer11, "(")
		if nil_3f_1(node11) then
			return append_21_1(writer11, ")")
		else
			local newline1 = false
			local max2 = (60 - estimateLength1(car2(node11), 60))
			expression1(car2(node11), writer11)
			if (max2 <= 0) then
				newline1 = true
				indent_21_1(writer11)
			else
			end
			local r_2841 = _23_1(node11)
			local r_2821 = nil
			r_2821 = (function(r_2831)
				if (r_2831 <= r_2841) then
					local entry4 = nth1(node11, r_2831)
					local temp21
					local r_2861 = _21_1(newline1)
					if r_2861 then
						temp21 = (max2 > 0)
					else
						temp21 = r_2861
					end
					if temp21 then
						max2 = (max2 - estimateLength1(entry4, max2))
						if (max2 <= 0) then
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
					expression1(entry4, writer11)
					return r_2821((r_2831 + 1))
				else
				end
			end)
			r_2821(2)
			if newline1 then
				unindent_21_1(writer11)
			else
			end
			return append_21_1(writer11, ")")
		end
	else
		return fail_21_1(_2e2e_1("Unknown tag ", tag3))
	end
end)
block1 = (function(list2, writer12)
	local r_2801 = _23_1(list2)
	local r_2781 = nil
	r_2781 = (function(r_2791)
		if (r_2791 <= r_2801) then
			local node12 = list2[r_2791]
			expression1(node12, writer12)
			line_21_1(writer12)
			return r_2781((r_2791 + 1))
		else
		end
	end)
	return r_2781(1)
end)
backend2 = struct1("expression", expression1, "block", block1)
builtins2 = require1("tacky.analysis.resolve")["builtins"]
tokens1 = {tag = "list", n = 4, {tag = "list", n = 2, "arg", "(%f[%a]%u+%f[%A])"}, {tag = "list", n = 2, "mono", "```[a-z]*\n([^`]*)\n```"}, {tag = "list", n = 2, "mono", "`([^`]*)`"}, {tag = "list", n = 2, "link", "%[%[(.-)%]%]"}}
extractSignature1 = (function(var5)
	local ty4 = type1(var5)
	local temp22
	local r_2931 = (ty4 == "macro")
	if r_2931 then
		temp22 = r_2931
	else
		temp22 = (ty4 == "defined")
	end
	if temp22 then
		local root1 = var5["node"]
		local node13 = nth1(root1, _23_1(root1))
		local temp23
		local r_2941 = list_3f_1(node13)
		if r_2941 then
			local r_2951 = symbol_3f_1(car2(node13))
			if r_2951 then
				temp23 = (car2(node13)["var"] == builtins2["lambda"])
			else
				temp23 = r_2951
			end
		else
			temp23 = r_2941
		end
		if temp23 then
			return nth1(node13, 2)
		else
			return nil
		end
	else
		return nil
	end
end)
parseDocstring1 = (function(str2)
	local out8 = {tag = "list", n = 0}
	local pos3 = 1
	local len3 = len1(str2)
	local r_2961 = nil
	r_2961 = (function()
		if (pos3 <= len3) then
			local spos1 = len3
			local epos1 = nil
			local name3 = nil
			local ptrn1 = nil
			local r_3011 = _23_1(tokens1)
			local r_2991 = nil
			r_2991 = (function(r_3001)
				if (r_3001 <= r_3011) then
					local tok1 = tokens1[r_3001]
					local npos1 = list1(find1(str2, nth1(tok1, 2), pos3))
					local temp24
					local r_3031 = car2(npos1)
					if r_3031 then
						temp24 = (car2(npos1) < spos1)
					else
						temp24 = r_3031
					end
					if temp24 then
						spos1 = car2(npos1)
						epos1 = nth1(npos1, 2)
						name3 = car2(tok1)
						ptrn1 = nth1(tok1, 2)
					else
					end
					return r_2991((r_3001 + 1))
				else
				end
			end)
			r_2991(1)
			if name3 then
				if (pos3 < spos1) then
					pushCdr_21_1(out8, struct1("tag", "text", "contents", sub1(str2, pos3, pred1(spos1))))
				else
				end
				pushCdr_21_1(out8, struct1("tag", name3, "whole", sub1(str2, spos1, epos1), "contents", match1(sub1(str2, spos1, epos1), ptrn1)))
				pos3 = succ1(epos1)
			else
				pushCdr_21_1(out8, struct1("tag", "text", "contents", sub1(str2, pos3, len3)))
				pos3 = succ1(len3)
			end
			return r_2961()
		else
		end
	end)
	r_2961()
	return out8
end)
struct1("parseDocs", parseDocstring1, "extractSignature", extractSignature1)
Scope1 = require1("tacky.analysis.scope")
formatRange2 = (function(range4)
	return format1("%s:%s", range4["name"], formatPosition1(range4["start"]))
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
		return _2e2e_1("(", name4, ")")
	else
		return _2e2e_1("(", name4, " ", concat1(traverse1(sig1, (function(r_3041)
			return r_3041["contents"]
		end)), " "), ")")
	end
end)
writeDocstring1 = (function(out9, str3, scope1)
	local r_2881 = parseDocstring1(str3)
	local r_2911 = _23_1(r_2881)
	local r_2891 = nil
	r_2891 = (function(r_2901)
		if (r_2901 <= r_2911) then
			local tok2 = r_2881[r_2901]
			local ty6 = type1(tok2)
			if (ty6 == "text") then
				append_21_1(out9, tok2["contents"])
			elseif (ty6 == "arg") then
				append_21_1(out9, _2e2e_1("`", tok2["contents"], "`"))
			elseif (ty6 == "mono") then
				append_21_1(out9, tok2["whole"])
			elseif (ty6 == "link") then
				local name5 = tok2["contents"]
				local ovar1 = Scope1["get"](scope1, name5)
				local temp25
				if ovar1 then
					temp25 = ovar1["node"]
				else
					temp25 = ovar1
				end
				if temp25 then
					local loc1
					local r_3101
					local r_3091
					local r_3081
					local r_3071 = ovar1["node"]
					r_3081 = getSource1(r_3071)
					r_3091 = r_3081["name"]
					r_3101 = gsub1(r_3091, "%.lisp$", "")
					loc1 = gsub1(r_3101, "/", ".")
					local sig2 = extractSignature1(ovar1)
					local hash1
					if (sig2 == nil) then
						hash1 = ovar1["name"]
					elseif nil_3f_1(sig2) then
						hash1 = ovar1["name"]
					else
						hash1 = _2e2e_1(name5, " ", concat1(traverse1(sig2, (function(r_3061)
							return r_3061["contents"]
						end)), " "))
					end
					append_21_1(out9, format1("[`%s`](%s.md#%s)", name5, loc1, gsub1(hash1, "%A+", "-")))
				else
					append_21_1(out9, format1("`%s`", name5))
				end
			else
				_error("unmatched item")
			end
			return r_2891((r_2901 + 1))
		else
		end
	end)
	r_2891(1)
	return line_21_1(out9)
end)
exported1 = (function(out10, title1, primary1, vars1, scope2)
	local documented1 = {tag = "list", n = 0}
	local undocumented1 = {tag = "list", n = 0}
	iterPairs1(vars1, (function(name6, var8)
		return pushCdr_21_1((function()
			if var8["doc"] then
				return documented1
			else
				return undocumented1
			end
		end)()
		, list1(name6, var8))
	end))
	sortVars_21_1(documented1)
	sortVars_21_1(undocumented1)
	line_21_1(out10, "---")
	line_21_1(out10, _2e2e_1("title: ", title1))
	line_21_1(out10, "---")
	line_21_1(out10, _2e2e_1("# ", title1))
	if primary1 then
		writeDocstring1(out10, primary1, scope2)
		line_21_1(out10, "", true)
	else
	end
	local r_3151 = _23_1(documented1)
	local r_3131 = nil
	r_3131 = (function(r_3141)
		if (r_3141 <= r_3151) then
			local entry5 = documented1[r_3141]
			local name7 = car2(entry5)
			local var9 = nth1(entry5, 2)
			line_21_1(out10, _2e2e_1("## `", formatSignature1(name7, var9), "`"))
			line_21_1(out10, _2e2e_1("*", formatDefinition1(var9), "*"))
			line_21_1(out10, "", true)
			writeDocstring1(out10, var9["doc"], var9["scope"])
			line_21_1(out10, "", true)
			return r_3131((r_3141 + 1))
		else
		end
	end)
	r_3131(1)
	if nil_3f_1(undocumented1) then
	else
		line_21_1(out10, "## Undocumented symbols")
	end
	local r_3211 = _23_1(undocumented1)
	local r_3191 = nil
	r_3191 = (function(r_3201)
		if (r_3201 <= r_3211) then
			local entry6 = undocumented1[r_3201]
			local name8 = car2(entry6)
			local var10 = nth1(entry6, 2)
			line_21_1(out10, _2e2e_1(" - `", formatSignature1(name8, var10), "` *", formatDefinition1(var10), "*"))
			return r_3191((r_3201 + 1))
		else
		end
	end)
	return r_3191(1)
end)
backend3 = struct1("exported", exported1)
wrapGenerate1 = (function(func2)
	return (function(node14, ...)
		local args4 = _pack(...) args4.tag = "list"
		local writer13 = create1()
		func2(node14, writer13, unpack1(args4, 1, _23_1(args4)))
		return _2d3e_string1(writer13)
	end)
end)
wrapNormal1 = (function(func3)
	return (function(...)
		local args5 = _pack(...) args5.tag = "list"
		local writer14 = create1()
		func3(writer14, unpack1(args5, 1, _23_1(args5)))
		return _2d3e_string1(writer14)
	end)
end)
return struct1("lua", struct1("expression", wrapGenerate1(compileExpression1), "block", wrapGenerate1(compileBlock1), "prelude", wrapNormal1(prelude1), "backend", backend1), "lisp", struct1("expression", wrapGenerate1(expression1), "block", wrapGenerate1(block1), "backend", backend2), "markdown", struct1("exported", wrapNormal1(exported1), "backend", backend3), "writer", struct1("create", create1, "append", append_21_1, "line", line_21_1, "tostring", _2d3e_string1))
