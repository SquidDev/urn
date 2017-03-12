#!/usr/bin/env tacky/cli.lua
if not table.pack then table.pack = function(...) return { n = select("#", ...), ... } end end
if not table.unpack then table.unpack = unpack end
local load = load if _VERSION:find("5.1") then load = function(x, n, _, env) local f, e = loadstring(x, n) if not f then error(e, 2) end return setfenv(f, env) end end
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
local _3d_1, _2f3d_1, _3c_1, _3c3d_1, _3e_1, _3e3d_1, _2b_1, _2d_1, _25_1, slice1, error1, getIdx1, setIdx_21_1, tonumber1, tostring1, type_23_1, _23_1, char1, find1, format1, gsub1, len1, match1, sub1, concat1, unpack1, emptyStruct1, car1, cdr1, list1, _21_1, list_3f_1, nil_3f_1, key_3f_1, between_3f_1, type1, car2, cdr2, last1, pushCdr_21_1, popLast_21_1, cadr1, charAt1, _2e2e_1, split1, quoted1, struct1, succ1, pred1, fail_21_1, self1, putError_21_1, putWarning_21_1, putVerbose_21_1, putDebug_21_1, putNodeError_21_1, putNodeWarning_21_1, doNodeError_21_1, void1, formatPosition1, formatRange1, formatNode1, getSource1, hexDigit_3f_1, binDigit_3f_1, terminator_3f_1, digitError_21_1, lex1, parse1, read1
_3d_1 = function(v1, v2) return (v1 == v2) end
_2f3d_1 = function(v1, v2) return (v1 ~= v2) end
_3c_1 = function(v1, v2) return (v1 < v2) end
_3c3d_1 = function(v1, v2) return (v1 <= v2) end
_3e_1 = function(v1, v2) return (v1 > v2) end
_3e3d_1 = function(v1, v2) return (v1 >= v2) end
_2b_1 = function(v1, v2) return (v1 + v2) end
_2d_1 = function(v1, v2) return (v1 - v2) end
_25_1 = function(v1, v2) return (v1 % v2) end
slice1 = _libs["lua/basic-0/slice"]
error1 = error
getIdx1 = function(v1, v2) return v1[v2] end
setIdx_21_1 = function(v1, v2, v3) v1[v2] = v3 end
tonumber1 = tonumber
tostring1 = tostring
type_23_1 = type
_23_1 = (function(x1)
	return x1["n"]
end)
char1 = string.char
find1 = string.find
format1 = string.format
gsub1 = string.gsub
len1 = string.len
match1 = string.match
sub1 = string.sub
concat1 = table.concat
unpack1 = table.unpack
emptyStruct1 = function() return ({}) end
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
_21_1 = (function(expr1)
	if expr1 then
		return false
	else
		return true
	end
end)
list_3f_1 = (function(x2)
	return (type1(x2) == "list")
end)
nil_3f_1 = (function(x3)
	if x3 then
		local r_161 = list_3f_1(x3)
		if r_161 then
			return (_23_1(x3) == 0)
		else
			return r_161
		end
	else
		return x3
	end
end)
key_3f_1 = (function(x4)
	return (type1(x4) == "key")
end)
between_3f_1 = (function(val1, min1, max1)
	local r_221 = (val1 >= min1)
	if r_221 then
		return (val1 <= max1)
	else
		return r_221
	end
end)
type1 = (function(val2)
	local ty1 = type_23_1(val2)
	if (ty1 == "table") then
		local tag1 = val2["tag"]
		if tag1 then
			return tag1
		else
			return "table"
		end
	else
		return ty1
	end
end)
car2 = (function(x5)
	local r_361 = type1(x5)
	if (r_361 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_361), 2)
	else
	end
	return car1(x5)
end)
cdr2 = (function(x6)
	local r_371 = type1(x6)
	if (r_371 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_371), 2)
	else
	end
	if nil_3f_1(x6) then
		return {tag = "list", n = 0}
	else
		return cdr1(x6)
	end
end)
last1 = (function(xs4)
	local r_451 = type1(xs4)
	if (r_451 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_451), 2)
	else
	end
	return xs4[_23_1(xs4)]
end)
pushCdr_21_1 = (function(xs5, val3)
	local r_461 = type1(xs5)
	if (r_461 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_461), 2)
	else
	end
	local len2 = (_23_1(xs5) + 1)
	xs5["n"] = len2
	xs5[len2] = val3
	return xs5
end)
popLast_21_1 = (function(xs6)
	local r_471 = type1(xs6)
	if (r_471 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_471), 2)
	else
	end
	xs6[_23_1(xs6)] = nil
	xs6["n"] = (_23_1(xs6) - 1)
	return xs6
end)
cadr1 = (function(x7)
	return car2(cdr2(x7))
end)
charAt1 = (function(xs7, x8)
	return sub1(xs7, x8, x8)
end)
_2e2e_1 = (function(...)
	local args1 = _pack(...) args1.tag = "list"
	return concat1(args1)
end)
split1 = (function(text1, pattern1, limit1)
	local out1 = {tag = "list", n = 0}
	local loop1 = true
	local start1 = 1
	local r_651 = nil
	r_651 = (function()
		if loop1 then
			local pos1 = list1(find1(text1, pattern1, start1))
			local nstart1 = car2(pos1)
			local nend1 = cadr1(pos1)
			local temp1
			local r_661 = (nstart1 == nil)
			if r_661 then
				temp1 = r_661
			else
				if limit1 then
					temp1 = (_23_1(out1) >= limit1)
				else
					temp1 = limit1
				end
			end
			if temp1 then
				loop1 = false
				pushCdr_21_1(out1, sub1(text1, start1, len1(text1)))
				start1 = (len1(text1) + 1)
			elseif (nstart1 > len1(text1)) then
				if (start1 <= len1(text1)) then
					pushCdr_21_1(out1, sub1(text1, start1, len1(text1)))
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
			return r_651()
		else
		end
	end)
	r_651()
	return out1
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
	local out2 = ({})
	local r_761 = _23_1(keys1)
	local r_741 = nil
	r_741 = (function(r_751)
		if (r_751 <= r_761) then
			local key2 = keys1[r_751]
			local val4 = keys1[(1 + r_751)]
			out2[(function()
				if key_3f_1(key2) then
					return contents1(key2)
				else
					return key2
				end
			end)()
			] = val4
			return r_741((r_751 + 2))
		else
		end
	end)
	r_741(1)
	return out2
end)
succ1 = (function(x9)
	return (x9 + 1)
end)
pred1 = (function(x10)
	return (x10 - 1)
end)
fail_21_1 = (function(x11)
	return error1(x11, 0)
end)
self1 = (function(x12, key3, ...)
	local args2 = _pack(...) args2.tag = "list"
	return x12[key3](x12, unpack1(args2, 1, _23_1(args2)))
end)
putError_21_1 = (function(logger1, msg1)
	return self1(logger1, "put-error!", msg1)
end)
putWarning_21_1 = (function(logger2, msg2)
	return self1(logger2, "put-warning!", msg2)
end)
putVerbose_21_1 = (function(logger3, msg3)
	return self1(logger3, "put-verbose!", msg3)
end)
putDebug_21_1 = (function(logger4, msg4)
	return self1(logger4, "put-debug!", msg4)
end)
putNodeError_21_1 = (function(logger5, msg5, node1, explain1, ...)
	local lines1 = _pack(...) lines1.tag = "list"
	return self1(logger5, "put-node-error!", msg5, node1, explain1, lines1)
end)
putNodeWarning_21_1 = (function(logger6, msg6, node2, explain2, ...)
	local lines2 = _pack(...) lines2.tag = "list"
	return self1(logger6, "put-node-warning!", msg6, node2, explain2, lines2)
end)
doNodeError_21_1 = (function(logger7, msg7, node3, explain3, ...)
	local lines3 = _pack(...) lines3.tag = "list"
	self1(logger7, "put-node-error!", msg7, node3, explain3, lines3)
	return fail_21_1((function(r_1691)
		if r_1691 then
			return r_1691
		else
			return msg7
		end
	end)(match1(msg7, "^([^\n]+)\n")))
end)
struct1("putError", putError_21_1, "putWarning", putWarning_21_1, "putVerbose", putVerbose_21_1, "putDebug", putDebug_21_1, "putNodeError", putNodeError_21_1, "putNodeWarning", putNodeWarning_21_1, "doNodeError", doNodeError_21_1)
local discard1 = (function()
end)
void1 = struct1("put-error!", discard1, "put-warning!", discard1, "put-verbose!", discard1, "put-debug!", discard1, "put-node-error!", discard1, "put-node-warning!", discard1)
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
formatNode1 = (function(node4)
	local temp2
	local r_1701 = node4["range"]
	if r_1701 then
		temp2 = node4["contents"]
	else
		temp2 = r_1701
	end
	if temp2 then
		return format1("%s (%q)", formatRange1(node4["range"]), node4["contents"])
	elseif node4["range"] then
		return formatRange1(node4["range"])
	elseif node4["owner"] then
		local owner1 = node4["owner"]
		if owner1["var"] then
			return format1("macro expansion of %s (%s)", owner1["var"]["name"], formatNode1(owner1["node"]))
		else
			return format1("unquote expansion (%s)", formatNode1(owner1["node"]))
		end
	else
		local temp3
		local r_1731 = node4["start"]
		if r_1731 then
			temp3 = node4["finish"]
		else
			temp3 = r_1731
		end
		if temp3 then
			return formatRange1(node4)
		else
			return "?"
		end
	end
end)
getSource1 = (function(node5)
	local result2 = nil
	local r_1711 = nil
	r_1711 = (function()
		local temp4
		local r_1721 = node5
		if r_1721 then
			temp4 = _21_1(result2)
		else
			temp4 = r_1721
		end
		if temp4 then
			result2 = node5["range"]
			node5 = node5["parent"]
			return r_1711()
		else
		end
	end)
	r_1711()
	return result2
end)
struct1("formatPosition", formatPosition1, "formatRange", formatRange1, "formatNode", formatNode1, "getSource", getSource1)
hexDigit_3f_1 = (function(char2)
	local r_1571 = between_3f_1(char2, "0", "9")
	if r_1571 then
		return r_1571
	else
		local r_1581 = between_3f_1(char2, "a", "f")
		if r_1581 then
			return r_1581
		else
			return between_3f_1(char2, "A", "F")
		end
	end
end)
binDigit_3f_1 = (function(char3)
	local r_1591 = (char3 == "0")
	if r_1591 then
		return r_1591
	else
		return (char3 == "1")
	end
end)
terminator_3f_1 = (function(char4)
	local r_1601 = (char4 == "\n")
	if r_1601 then
		return r_1601
	else
		local r_1611 = (char4 == " ")
		if r_1611 then
			return r_1611
		else
			local r_1621 = (char4 == "\9")
			if r_1621 then
				return r_1621
			else
				local r_1631 = (char4 == "(")
				if r_1631 then
					return r_1631
				else
					local r_1641 = (char4 == ")")
					if r_1641 then
						return r_1641
					else
						local r_1651 = (char4 == "[")
						if r_1651 then
							return r_1651
						else
							local r_1661 = (char4 == "]")
							if r_1661 then
								return r_1661
							else
								local r_1671 = (char4 == "{")
								if r_1671 then
									return r_1671
								else
									local r_1681 = (char4 == "}")
									if r_1681 then
										return r_1681
									else
										return (char4 == "")
									end
								end
							end
						end
					end
				end
			end
		end
	end
end)
digitError_21_1 = (function(logger8, pos3, name1, char5)
	return doNodeError_21_1(logger8, format1("Expected %s digit, got %s", name1, (function()
		if (char5 == "") then
			return "eof"
		else
			return quoted1(char5)
		end
	end)()
	), pos3, nil, pos3, "Invalid digit here")
end)
lex1 = (function(logger9, str2, name2)
	local lines4 = split1(str2, "\n")
	local line1 = 1
	local column1 = 1
	local offset1 = 1
	local length1 = len1(str2)
	local out3 = {tag = "list", n = 0}
	local consume_21_1 = (function()
		if (charAt1(str2, offset1) == "\n") then
			line1 = (line1 + 1)
			column1 = 1
		else
			column1 = (column1 + 1)
		end
		offset1 = (offset1 + 1)
		return nil
	end)
	local position1 = (function()
		return struct1("line", line1, "column", column1, "offset", offset1)
	end)
	local range2 = (function(start2, finish1)
		return struct1("start", start2, "finish", (function()
			if finish1 then
				return finish1
			else
				return start2
			end
		end)(), "lines", lines4, "name", name2)
	end)
	local appendWith_21_1 = (function(data1, start3, finish2)
		local start4
		if start3 then
			start4 = start3
		else
			start4 = position1()
		end
		local finish3
		if finish2 then
			finish3 = finish2
		else
			finish3 = position1()
		end
		data1["range"] = range2(start4, finish3)
		data1["contents"] = sub1(str2, start4["offset"], finish3["offset"])
		return pushCdr_21_1(out3, data1)
	end)
	local append_21_1 = (function(tag2, start5, finish4)
		return appendWith_21_1(struct1("tag", tag2), start5, finish4)
	end)
	local parseBase1 = (function(name3, p1, base1)
		local start6 = offset1
		local char6 = charAt1(str2, offset1)
		if p1(char6) then
		else
			digitError_21_1(logger9, range2(position1()), name3, char6)
		end
		char6 = charAt1(str2, succ1(offset1))
		local r_2121 = nil
		r_2121 = (function()
			if p1(char6) then
				consume_21_1()
				char6 = charAt1(str2, succ1(offset1))
				return r_2121()
			else
			end
		end)
		r_2121()
		return tonumber1(sub1(str2, start6, offset1), base1)
	end)
	local r_1741 = nil
	r_1741 = (function()
		if (offset1 <= length1) then
			local char7 = charAt1(str2, offset1)
			local temp5
			local r_1751 = (char7 == "\n")
			if r_1751 then
				temp5 = r_1751
			else
				local r_1761 = (char7 == "\9")
				if r_1761 then
					temp5 = r_1761
				else
					temp5 = (char7 == " ")
				end
			end
			if temp5 then
			elseif (char7 == "(") then
				appendWith_21_1(struct1("tag", "open", "close", ")"))
			elseif (char7 == ")") then
				appendWith_21_1(struct1("tag", "close", "open", "("))
			elseif (char7 == "[") then
				appendWith_21_1(struct1("tag", "open", "close", "]"))
			elseif (char7 == "]") then
				appendWith_21_1(struct1("tag", "close", "open", "["))
			elseif (char7 == "{") then
				appendWith_21_1(struct1("tag", "open", "close", "}"))
			elseif (char7 == "}") then
				appendWith_21_1(struct1("tag", "close", "open", "{"))
			elseif (char7 == "'") then
				append_21_1("quote")
			elseif (char7 == "`") then
				append_21_1("syntax-quote")
			elseif (char7 == "~") then
				append_21_1("quasiquote")
			elseif (char7 == ",") then
				if (charAt1(str2, succ1(offset1)) == "@") then
					local start7 = position1()
					consume_21_1()
					append_21_1("unquote-splice", start7)
				else
					append_21_1("unquote")
				end
			elseif find1(str2, "^%-?%.?[0-9]", offset1) then
				local start8 = position1()
				local negative1 = (char7 == "-")
				if negative1 then
					consume_21_1()
					char7 = charAt1(str2, offset1)
				else
				end
				local val5
				local temp6
				local r_1771 = (char7 == "0")
				if r_1771 then
					temp6 = (charAt1(str2, succ1(offset1)) == "x")
				else
					temp6 = r_1771
				end
				if temp6 then
					consume_21_1()
					consume_21_1()
					local res1 = parseBase1("hexadecimal", hexDigit_3f_1, 16)
					if negative1 then
						res1 = (0 - res1)
					else
					end
					val5 = res1
				else
					local temp7
					local r_1781 = (char7 == "0")
					if r_1781 then
						temp7 = (charAt1(str2, succ1(offset1)) == "b")
					else
						temp7 = r_1781
					end
					if temp7 then
						consume_21_1()
						consume_21_1()
						local res2 = parseBase1("binary", binDigit_3f_1, 2)
						if negative1 then
							res2 = (0 - res2)
						else
						end
						val5 = res2
					else
						local r_1791 = nil
						r_1791 = (function()
							if between_3f_1(charAt1(str2, succ1(offset1)), "0", "9") then
								consume_21_1()
								return r_1791()
							else
							end
						end)
						r_1791()
						if (charAt1(str2, succ1(offset1)) == ".") then
							consume_21_1()
							local r_1801 = nil
							r_1801 = (function()
								if between_3f_1(charAt1(str2, succ1(offset1)), "0", "9") then
									consume_21_1()
									return r_1801()
								else
								end
							end)
							r_1801()
						else
						end
						char7 = charAt1(str2, succ1(offset1))
						local temp8
						local r_1811 = (char7 == "e")
						if r_1811 then
							temp8 = r_1811
						else
							temp8 = (char7 == "E")
						end
						if temp8 then
							consume_21_1()
							char7 = charAt1(str2, succ1(offset1))
							local temp9
							local r_1821 = (char7 == "-")
							if r_1821 then
								temp9 = r_1821
							else
								temp9 = (char7 == "+")
							end
							if temp9 then
								consume_21_1()
							else
							end
							local r_1831 = nil
							r_1831 = (function()
								if between_3f_1(charAt1(str2, succ1(offset1)), "0", "9") then
									consume_21_1()
									return r_1831()
								else
								end
							end)
							r_1831()
						else
						end
						val5 = tonumber1(sub1(str2, start8["offset"], offset1))
					end
				end
				appendWith_21_1(struct1("tag", "number", "value", val5), start8)
				char7 = charAt1(str2, succ1(offset1))
				if terminator_3f_1(char7) then
				else
					consume_21_1()
					doNodeError_21_1(logger9, format1("Expected digit, got %s", (function()
						if (char7 == "") then
							return "eof"
						else
							return char7
						end
					end)()
					), range2(position1()), nil, range2(position1()), "Illegal character here. Are you missing whitespace?")
				end
			elseif (char7 == "\"") then
				local start9 = position1()
				local startCol1 = succ1(column1)
				local buffer1 = {tag = "list", n = 0}
				consume_21_1()
				char7 = charAt1(str2, offset1)
				local r_1841 = nil
				r_1841 = (function()
					if (char7 ~= "\"") then
						if (column1 == 1) then
							local running1 = true
							local lineOff1 = offset1
							local r_1851 = nil
							r_1851 = (function()
								local temp10
								local r_1861 = running1
								if r_1861 then
									temp10 = (column1 < startCol1)
								else
									temp10 = r_1861
								end
								if temp10 then
									if (char7 == " ") then
										consume_21_1()
									elseif (char7 == "\n") then
										consume_21_1()
										pushCdr_21_1(buffer1, "\n")
										lineOff1 = offset1
									elseif (char7 == "") then
										running1 = false
									else
										putNodeWarning_21_1(logger9, format1("Expected leading indent, got %q", char7), range2(position1()), "You should try to align multi-line strings at the initial quote\nmark. This helps keep programs neat and tidy.", range2(start9), "String started with indent here", range2(position1()), "Mis-aligned character here")
										pushCdr_21_1(buffer1, sub1(str2, lineOff1, pred1(offset1)))
										running1 = false
									end
									char7 = charAt1(str2, offset1)
									return r_1851()
								else
								end
							end)
							r_1851()
						else
						end
						if (char7 == "") then
							local start10 = range2(start9)
							local finish5 = range2(position1())
							doNodeError_21_1(logger9, "Expected '\"', got eof", finish5, nil, start10, "string started here", finish5, "end of file here")
						elseif (char7 == "\\") then
							consume_21_1()
							char7 = charAt1(str2, offset1)
							if (char7 == "\n") then
							elseif (char7 == "a") then
								pushCdr_21_1(buffer1, "\7")
							elseif (char7 == "b") then
								pushCdr_21_1(buffer1, "\8")
							elseif (char7 == "f") then
								pushCdr_21_1(buffer1, "\12")
							elseif (char7 == "n") then
								pushCdr_21_1(buffer1, "\n")
							elseif (char7 == "t") then
								pushCdr_21_1(buffer1, "\9")
							elseif (char7 == "v") then
								pushCdr_21_1(buffer1, "\11")
							elseif (char7 == "\"") then
								pushCdr_21_1(buffer1, "\"")
							elseif (char7 == "\\") then
								pushCdr_21_1(buffer1, "\\")
							else
								local temp11
								local r_1871 = (char7 == "x")
								if r_1871 then
									temp11 = r_1871
								else
									local r_1881 = (char7 == "X")
									if r_1881 then
										temp11 = r_1881
									else
										temp11 = between_3f_1(char7, "0", "9")
									end
								end
								if temp11 then
									local start11 = position1()
									local val6
									local temp12
									local r_1891 = (char7 == "x")
									if r_1891 then
										temp12 = r_1891
									else
										temp12 = (char7 == "X")
									end
									if temp12 then
										consume_21_1()
										local start12 = offset1
										if hexDigit_3f_1(charAt1(str2, offset1)) then
										else
											digitError_21_1(logger9, range2(position1()), "hexadecimal", charAt1(str2, offset1))
										end
										if hexDigit_3f_1(charAt1(str2, succ1(offset1))) then
											consume_21_1()
										else
										end
										val6 = tonumber1(sub1(str2, start12, offset1), 16)
									else
										local start13 = position1()
										local ctr1 = 0
										char7 = charAt1(str2, succ1(offset1))
										local r_2071 = nil
										r_2071 = (function()
											local temp13
											local r_2081 = (ctr1 < 2)
											if r_2081 then
												temp13 = between_3f_1(char7, "0", "9")
											else
												temp13 = r_2081
											end
											if temp13 then
												consume_21_1()
												char7 = charAt1(str2, succ1(offset1))
												ctr1 = (ctr1 + 1)
												return r_2071()
											else
											end
										end)
										r_2071()
										val6 = tonumber1(sub1(str2, start13["offset"], offset1))
									end
									if (val6 >= 256) then
										doNodeError_21_1(logger9, "Invalid escape code", range2(start11()), nil, range2(start11(), position1), _2e2e_1("Must be between 0 and 255, is ", val6))
									else
									end
									pushCdr_21_1(buffer1, char1(val6))
								elseif (char7 == "") then
									doNodeError_21_1(logger9, "Expected escape code, got eof", range2(position1()), nil, range2(position1()), "end of file here")
								else
									doNodeError_21_1(logger9, "Illegal escape character", range2(position1()), nil, range2(position1()), "Unknown escape character")
								end
							end
						else
							pushCdr_21_1(buffer1, char7)
						end
						consume_21_1()
						char7 = charAt1(str2, offset1)
						return r_1841()
					else
					end
				end)
				r_1841()
				appendWith_21_1(struct1("tag", "string", "value", concat1(buffer1)), start9)
			elseif (char7 == ";") then
				local r_2091 = nil
				r_2091 = (function()
					local temp14
					local r_2101 = (offset1 <= length1)
					if r_2101 then
						temp14 = (charAt1(str2, succ1(offset1)) ~= "\n")
					else
						temp14 = r_2101
					end
					if temp14 then
						consume_21_1()
						return r_2091()
					else
					end
				end)
				r_2091()
			else
				local start14 = position1()
				local key4 = (char7 == ":")
				char7 = charAt1(str2, succ1(offset1))
				local r_2111 = nil
				r_2111 = (function()
					if _21_1(terminator_3f_1(char7)) then
						consume_21_1()
						char7 = charAt1(str2, succ1(offset1))
						return r_2111()
					else
					end
				end)
				r_2111()
				if key4 then
					appendWith_21_1(struct1("tag", "key", "value", sub1(str2, succ1(start14["offset"]), offset1)), start14)
				else
					append_21_1("symbol", start14)
				end
			end
			consume_21_1()
			return r_1741()
		else
		end
	end)
	r_1741()
	append_21_1("eof")
	return out3
end)
parse1 = (function(logger10, toks1)
	local head1 = {tag = "list", n = 0}
	local stack1 = {tag = "list", n = 0}
	local append_21_2 = (function(node6)
		pushCdr_21_1(head1, node6)
		node6["parent"] = head1
		return nil
	end)
	local push_21_1 = (function()
		local next1 = {tag = "list", n = 0}
		pushCdr_21_1(stack1, head1)
		append_21_2(next1)
		head1 = next1
		return nil
	end)
	local pop_21_1 = (function()
		head1["open"] = nil
		head1["close"] = nil
		head1["auto-close"] = nil
		head1["last-node"] = nil
		head1 = last1(stack1)
		return popLast_21_1(stack1)
	end)
	local r_1941 = _23_1(toks1)
	local r_1921 = nil
	r_1921 = (function(r_1931)
		if (r_1931 <= r_1941) then
			local tok1 = toks1[r_1931]
			local tag3 = tok1["tag"]
			local autoClose1 = false
			local previous1 = head1["last-node"]
			local tokPos1 = tok1["range"]
			local temp15
			local r_1961 = (tag3 ~= "eof")
			if r_1961 then
				local r_1971 = (tag3 ~= "close")
				if r_1971 then
					if head1["range"] then
						temp15 = (tokPos1["start"]["line"] ~= head1["range"]["start"]["line"])
					else
						temp15 = true
					end
				else
					temp15 = r_1971
				end
			else
				temp15 = r_1961
			end
			if temp15 then
				if previous1 then
					local prevPos1 = previous1["range"]
					if (tokPos1["start"]["line"] ~= prevPos1["start"]["line"]) then
						head1["last-node"] = tok1
						if (tokPos1["start"]["column"] ~= prevPos1["start"]["column"]) then
							putNodeWarning_21_1(logger10, "Different indent compared with previous expressions.", tok1, "You should try to maintain consistent indentation across a program,\ntry to ensure all expressions are lined up.\nIf this looks OK to you, check you're not missing a closing ')'.", prevPos1, "", tokPos1, "")
						else
						end
					else
					end
				else
					head1["last-node"] = tok1
				end
			else
			end
			local temp16
			local r_1981 = (tag3 == "string")
			if r_1981 then
				temp16 = r_1981
			else
				local r_1991 = (tag3 == "number")
				if r_1991 then
					temp16 = r_1991
				else
					local r_2001 = (tag3 == "symbol")
					if r_2001 then
						temp16 = r_2001
					else
						temp16 = (tag3 == "key")
					end
				end
			end
			if temp16 then
				append_21_2(tok1)
			elseif (tag3 == "open") then
				push_21_1()
				head1["open"] = tok1["contents"]
				head1["close"] = tok1["close"]
				head1["range"] = struct1("start", tok1["range"]["start"], "name", tok1["range"]["name"], "lines", tok1["range"]["lines"])
			elseif (tag3 == "close") then
				if nil_3f_1(stack1) then
					doNodeError_21_1(logger10, format1("'%s' without matching '%s'", tok1["contents"], tok1["open"]), tok1, nil, getSource1(tok1), "")
				elseif head1["auto-close"] then
					doNodeError_21_1(logger10, format1("'%s' without matching '%s' inside quote", tok1["contents"], tok1["open"]), tok1, nil, head1["range"], "quote opened here", tok1["range"], "attempting to close here")
				elseif (head1["close"] ~= tok1["contents"]) then
					doNodeError_21_1(logger10, format1("Expected '%s', got '%s'", head1["close"], tok1["contents"]), tok1, nil, head1["range"], format1("block opened with '%s'", head1["open"]), tok1["range"], format1("'%s' used here", tok1["contents"]))
				else
					head1["range"]["finish"] = tok1["range"]["finish"]
					pop_21_1()
				end
			else
				local temp17
				local r_2011 = (tag3 == "quote")
				if r_2011 then
					temp17 = r_2011
				else
					local r_2021 = (tag3 == "unquote")
					if r_2021 then
						temp17 = r_2021
					else
						local r_2031 = (tag3 == "syntax-quote")
						if r_2031 then
							temp17 = r_2031
						else
							local r_2041 = (tag3 == "unquote-splice")
							if r_2041 then
								temp17 = r_2041
							else
								temp17 = (tag3 == "quasiquote")
							end
						end
					end
				end
				if temp17 then
					push_21_1()
					head1["range"] = struct1("start", tok1["range"]["start"], "name", tok1["range"]["name"], "lines", tok1["range"]["lines"])
					append_21_2(struct1("tag", "symbol", "contents", tag3, "range", tok1["range"]))
					autoClose1 = true
					head1["auto-close"] = true
				elseif (tag3 == "eof") then
					if (0 ~= _23_1(stack1)) then
						doNodeError_21_1(logger10, "Expected ')', got eof", tok1, nil, head1["range"], "block opened here", tok1["range"], "end of file here")
					else
					end
				else
					error1(_2e2e_1("Unsupported type", tag3))
				end
			end
			if autoClose1 then
			else
				local r_2051 = nil
				r_2051 = (function()
					if head1["auto-close"] then
						if nil_3f_1(stack1) then
							doNodeError_21_1(logger10, format1("'%s' without matching '%s'", tok1["contents"], tok1["open"]), tok1, nil, getSource1(tok1), "")
						else
						end
						head1["range"]["finish"] = tok1["range"]["finish"]
						pop_21_1()
						return r_2051()
					else
					end
				end)
				r_2051()
			end
			return r_1921((r_1931 + 1))
		else
		end
	end)
	r_1921(1)
	return head1
end)
read1 = (function(x13, path1)
	return parse1(void1, lex1(void1, x13, (function()
		if path1 then
			return path1
		else
			return ""
		end
	end)()))
end)
return struct1("lex", lex1, "parse", parse1, "read", read1)
