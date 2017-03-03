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
local _3d_1, _2f3d_1, _3c_1, _3c3d_1, _3e_1, _3e3d_1, _2b_1, _2d_1, _25_1, _2e2e_1, slice1, error1, getmetatable1, print1, getIdx1, setIdx_21_1, tonumber1, tostring1, type_23_1, _23_1, char1, find1, format1, gsub1, len1, rep1, sub1, concat1, emptyStruct1, car1, cdr1, list1, _21_1, pretty1, table_3f_1, list_3f_1, nil_3f_1, string_3f_1, function_3f_1, key_3f_1, between_3f_1, type1, car2, cdr2, foldr1, last1, nth1, pushCdr_21_1, popLast_21_1, cadr1, charAt1, _2e2e_2, split1, quoted1, getenv1, struct1, invokable_3f_1, compose1, succ1, pred1, fail_21_1, config1, coloredAnsi1, colored_3f_1, colored1, abs1, max2, verbosity1, setVerbosity_21_1, showExplain1, setExplain_21_1, printError_21_1, printWarning_21_1, printVerbose_21_1, printDebug_21_1, formatPosition1, formatRange1, formatNode1, getSource1, putLines_21_1, putTrace_21_1, putExplain_21_1, errorPositions_21_1, hexDigit_3f_1, binDigit_3f_1, terminator_3f_1, digitError_21_1, lex1, parse1, read1
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
getmetatable1 = getmetatable
print1 = print
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
rep1 = string.rep
sub1 = string.sub
concat1 = table.concat
emptyStruct1 = function() return {} end
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
table_3f_1 = (function(x2)
	return (type_23_1(x2) == "table")
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
function_3f_1 = (function(x6)
	return (type1(x6) == "function")
end)
key_3f_1 = (function(x7)
	return (type1(x7) == "key")
end)
between_3f_1 = (function(val1, min1, max1)
	local r_91 = (val1 >= min1)
	if r_91 then
		return (val1 <= max1)
	else
		return r_91
	end
end)
type1 = (function(val2)
	local ty2 = type_23_1(val2)
	if (ty2 == "table") then
		local tag2 = val2["tag"]
		if tag2 then
			return tag2
		else
			return "table"
		end
	else
		return ty2
	end
end)
car2 = (function(x8)
	local r_281 = type1(x8)
	if (r_281 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_281), 2)
	else
	end
	return car1(x8)
end)
cdr2 = (function(x9)
	local r_291 = type1(x9)
	if (r_291 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_291), 2)
	else
	end
	if nil_3f_1(x9) then
		return {tag = "list", n = 0}
	else
		return cdr1(x9)
	end
end)
foldr1 = (function(f1, z1, xs4)
	local r_301 = type1(f1)
	if (r_301 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "f", "function", r_301), 2)
	else
	end
	local r_421 = type1(xs4)
	if (r_421 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_421), 2)
	else
	end
	if nil_3f_1(xs4) then
		return z1
	else
		local head1 = car2(xs4)
		local tail1 = cdr2(xs4)
		return f1(head1, foldr1(f1, z1, tail1))
	end
end)
last1 = (function(xs5)
	local r_371 = type1(xs5)
	if (r_371 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_371), 2)
	else
	end
	return xs5[_23_1(xs5)]
end)
nth1 = (function(xs6, idx1)
	return xs6[idx1]
end)
pushCdr_21_1 = (function(xs7, val3)
	local r_381 = type1(xs7)
	if (r_381 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_381), 2)
	else
	end
	local len2 = (_23_1(xs7) + 1)
	xs7["n"] = len2
	xs7[len2] = val3
	return xs7
end)
popLast_21_1 = (function(xs8)
	local r_391 = type1(xs8)
	if (r_391 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_391), 2)
	else
	end
	xs8[_23_1(xs8)] = nil
	xs8["n"] = (_23_1(xs8) - 1)
	return xs8
end)
cadr1 = (function(x10)
	return car2(cdr2(x10))
end)
charAt1 = (function(xs9, x11)
	return sub1(xs9, x11, x11)
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
			local val4 = keys1[(1 + r_631)]
			out3[(function()
				if key_3f_1(key2) then
					return contents1(key2)
				else
					return key2
				end
			end)()
			] = val4
			return r_621((r_631 + 2))
		else
		end
	end)
	r_621(1)
	return out3
end)
invokable_3f_1 = (function(x12)
	local r_921 = function_3f_1(x12)
	if r_921 then
		return r_921
	else
		local r_931 = table_3f_1(x12)
		if r_931 then
			local r_941 = table_3f_1(getmetatable1(x12))
			if r_941 then
				return function_3f_1(getmetatable1(x12)["__call"])
			else
				return r_941
			end
		else
			return r_931
		end
	end
end)
compose1 = (function(f2, g1)
	local temp2
	local r_951 = invokable_3f_1(f2)
	if r_951 then
		temp2 = invokable_3f_1(g1)
	else
		temp2 = r_951
	end
	if temp2 then
		return (function(x13)
			return f2(g1(x13))
		end)
	else
		return nil
	end
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
config1 = package.config
coloredAnsi1 = (function(col1, msg1)
	return _2e2e_2("\27[", col1, "m", msg1, "\27[0m")
end)
local temp3
if config1 then
	temp3 = (charAt1(config1, 1) ~= "\\")
else
	temp3 = config1
end
if temp3 then
	colored_3f_1 = true
else
	local temp4
	if getenv1 then
		temp4 = (getenv1("ANSICON") ~= nil)
	else
		temp4 = getenv1
	end
	if temp4 then
		colored_3f_1 = true
	else
		local temp5
		if getenv1 then
			local term1 = getenv1("TERM")
			if term1 then
				temp5 = find1(term1, "xterm")
			else
				temp5 = nil
			end
		else
			temp5 = getenv1
		end
		if temp5 then
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
max2 = math.max
verbosity1 = struct1("value", 0)
setVerbosity_21_1 = (function(level1)
	verbosity1["value"] = level1
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
formatNode1 = (function(node1)
	local temp6
	local r_1081 = node1["range"]
	if r_1081 then
		temp6 = node1["contents"]
	else
		temp6 = r_1081
	end
	if temp6 then
		return format1("%s (%q)", formatRange1(node1["range"]), node1["contents"])
	elseif node1["range"] then
		return formatRange1(node1["range"])
	elseif node1["macro"] then
		local macro1 = node1["macro"]
		return format1("macro expansion of %s (%s)", macro1["var"]["name"], formatNode1(macro1["node"]))
	else
		local temp7
		local r_1211 = node1["start"]
		if r_1211 then
			temp7 = node1["finish"]
		else
			temp7 = r_1211
		end
		if temp7 then
			return formatRange1(node1)
		else
			return "?"
		end
	end
end)
getSource1 = (function(node2)
	local result2 = nil
	local r_1091 = nil
	r_1091 = (function()
		local temp8
		local r_1101 = node2
		if r_1101 then
			temp8 = _21_1(result2)
		else
			temp8 = r_1101
		end
		if temp8 then
			result2 = node2["range"]
			node2 = node2["parent"]
			return r_1091()
		else
		end
	end)
	r_1091()
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
	local maxLine1 = foldr1((function(node3, max3)
		if string_3f_1(node3) then
			return max3
		else
			return max2(max3, node3["start"]["line"])
		end
	end), 0, entries1)
	local code1 = _2e2e_2(colored1(92, _2e2e_2(" %", len1(tostring1(maxLine1)), "s |")), " %s")
	local r_1241 = _23_1(entries1)
	local r_1221 = nil
	r_1221 = (function(r_1231)
		if (r_1231 <= r_1241) then
			local position1 = entries1[r_1231]
			local message1 = entries1[succ1(r_1231)]
			if (file1 ~= position1["name"]) then
				file1 = position1["name"]
				print1(colored1(95, _2e2e_2(" ", file1)))
			else
				local temp9
				local r_1261 = (previous1 ~= -1)
				if r_1261 then
					temp9 = (abs1((position1["start"]["line"] - previous1)) > 2)
				else
					temp9 = r_1261
				end
				if temp9 then
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
				local temp10
				local r_1271 = position1["finish"]
				if r_1271 then
					temp10 = (position1["start"]["line"] == position1["finish"]["line"])
				else
					temp10 = r_1271
				end
				if temp10 then
					pointer1 = rep1("^", succ1((position1["finish"]["column"] - position1["start"]["column"])))
				else
					pointer1 = "^..."
				end
			end
			print1(format1(code1, "", _2e2e_2(rep1(" ", (position1["start"]["column"] - 1)), pointer1, " ", message1)))
			return r_1221((r_1231 + 2))
		else
		end
	end)
	return r_1221(1)
end)
putTrace_21_1 = (function(node4)
	local previous2 = nil
	local r_1111 = nil
	r_1111 = (function()
		if node4 then
			local formatted1 = formatNode1(node4)
			if (previous2 == nil) then
				print1(colored1(96, _2e2e_2("  => ", formatted1)))
			elseif (previous2 ~= formatted1) then
				print1(_2e2e_2("  in ", formatted1))
			else
			end
			previous2 = formatted1
			node4 = node4["parent"]
			return r_1111()
		else
		end
	end)
	return r_1111()
end)
putExplain_21_1 = (function(...)
	local lines3 = _pack(...) lines3.tag = "list"
	if showExplain1["value"] then
		local r_1161 = _23_1(lines3)
		local r_1141 = nil
		r_1141 = (function(r_1151)
			if (r_1151 <= r_1161) then
				local line1 = lines3[r_1151]
				print1(_2e2e_2("  ", line1))
				return r_1141((r_1151 + 1))
			else
			end
		end)
		return r_1141(1)
	else
	end
end)
errorPositions_21_1 = (function(node5, msg7)
	printError_21_1(msg7)
	putTrace_21_1(node5)
	local source1 = getSource1(node5)
	if source1 then
		putLines_21_1(true, source1, "")
	else
	end
	return fail_21_1("An error occured")
end)
struct1("colored", colored1, "formatPosition", formatPosition1, "formatRange", formatRange1, "formatNode", formatNode1, "putLines", putLines_21_1, "putTrace", putTrace_21_1, "putInfo", putExplain_21_1, "getSource", getSource1, "printWarning", printWarning_21_1, "printError", printError_21_1, "printVerbose", printVerbose_21_1, "printDebug", printDebug_21_1, "errorPositions", errorPositions_21_1, "setVerbosity", setVerbosity_21_1, "setExplain", setExplain_21_1)
hexDigit_3f_1 = (function(char2)
	local r_961 = between_3f_1(char2, "0", "9")
	if r_961 then
		return r_961
	else
		local r_971 = between_3f_1(char2, "a", "f")
		if r_971 then
			return r_971
		else
			return between_3f_1(char2, "A", "F")
		end
	end
end)
binDigit_3f_1 = (function(char3)
	local r_981 = (char3 == "0")
	if r_981 then
		return r_981
	else
		return (char3 == "1")
	end
end)
terminator_3f_1 = (function(char4)
	local r_991 = (char4 == "\n")
	if r_991 then
		return r_991
	else
		local r_1001 = (char4 == " ")
		if r_1001 then
			return r_1001
		else
			local r_1011 = (char4 == "\9")
			if r_1011 then
				return r_1011
			else
				local r_1021 = (char4 == "(")
				if r_1021 then
					return r_1021
				else
					local r_1031 = (char4 == ")")
					if r_1031 then
						return r_1031
					else
						local r_1041 = (char4 == "[")
						if r_1041 then
							return r_1041
						else
							local r_1051 = (char4 == "]")
							if r_1051 then
								return r_1051
							else
								local r_1061 = (char4 == "{")
								if r_1061 then
									return r_1061
								else
									local r_1071 = (char4 == "}")
									if r_1071 then
										return r_1071
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
digitError_21_1 = (function(pos3, name1, char5)
	printError_21_1(format1("Expected %s digit, got %s", name1, (function()
		if (char5 == "") then
			return "eof"
		else
			return quoted1(char5)
		end
	end)()
	))
	putTrace_21_1(pos3)
	putLines_21_1(false, pos3, "Invalid digit here")
	return fail_21_1("Lexing failed")
end)
lex1 = (function(str2, name2)
	local lines4 = split1(str2, "\n")
	local line2 = 1
	local column1 = 1
	local offset1 = 1
	local length1 = len1(str2)
	local out4 = {tag = "list", n = 0}
	local consume_21_1 = (function()
		if (charAt1(str2, offset1) == "\n") then
			line2 = (line2 + 1)
			column1 = 1
		else
			column1 = (column1 + 1)
		end
		offset1 = (offset1 + 1)
		return nil
	end)
	local position2 = (function()
		return struct1("line", line2, "column", column1, "offset", offset1)
	end)
	local range3 = (function(start2, finish1)
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
			start4 = position2()
		end
		local finish3
		if finish2 then
			finish3 = finish2
		else
			finish3 = position2()
		end
		data1["range"] = range3(start4, finish3)
		data1["contents"] = sub1(str2, start4["offset"], finish3["offset"])
		return pushCdr_21_1(out4, data1)
	end)
	local append_21_1 = (function(tag3, start5, finish4)
		return appendWith_21_1(struct1("tag", tag3), start5, finish4)
	end)
	local parseBase1 = (function(name3, p1, base1)
		local start6 = offset1
		local char6 = charAt1(str2, offset1)
		if p1(char6) then
		else
			digitError_21_1(range3(position2()), name3, char6)
		end
		char6 = charAt1(str2, succ1(offset1))
		local r_1641 = nil
		r_1641 = (function()
			if p1(char6) then
				consume_21_1()
				char6 = charAt1(str2, succ1(offset1))
				return r_1641()
			else
			end
		end)
		r_1641()
		return tonumber1(sub1(str2, start6, offset1), base1)
	end)
	local r_1281 = nil
	r_1281 = (function()
		if (offset1 <= length1) then
			local char7 = charAt1(str2, offset1)
			local temp11
			local r_1291 = (char7 == "\n")
			if r_1291 then
				temp11 = r_1291
			else
				local r_1301 = (char7 == "\9")
				if r_1301 then
					temp11 = r_1301
				else
					temp11 = (char7 == " ")
				end
			end
			if temp11 then
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
			elseif (char7 == ",") then
				if (charAt1(str2, succ1(offset1)) == "@") then
					local start7 = position2()
					consume_21_1()
					append_21_1("unquote-splice", start7)
				else
					append_21_1("unquote")
				end
			elseif find1(str2, "^%-?%.?[0-9]", offset1) then
				local start8 = position2()
				local negative1 = (char7 == "-")
				if negative1 then
					consume_21_1()
					char7 = charAt1(str2, offset1)
				else
				end
				local val5
				local temp12
				local r_1311 = (char7 == "0")
				if r_1311 then
					temp12 = (charAt1(str2, succ1(offset1)) == "x")
				else
					temp12 = r_1311
				end
				if temp12 then
					consume_21_1()
					consume_21_1()
					local res1 = parseBase1("hexadecimal", hexDigit_3f_1, 16)
					if negative1 then
						res1 = (0 - res1)
						val5 = res1
					else
					end
				else
					local temp13
					local r_1321 = (char7 == "0")
					if r_1321 then
						temp13 = (charAt1(str2, succ1(offset1)) == "b")
					else
						temp13 = r_1321
					end
					if temp13 then
						consume_21_1()
						consume_21_1()
						local res2 = parseBase1("binary", binDigit_3f_1, 2)
						if negative1 then
							res2 = (0 - res2)
							val5 = res2
						else
						end
					else
						local r_1331 = nil
						r_1331 = (function()
							if between_3f_1(charAt1(str2, succ1(offset1)), "0", "9") then
								consume_21_1()
								return r_1331()
							else
							end
						end)
						r_1331()
						if (charAt1(str2, succ1(offset1)) == ".") then
							consume_21_1()
							local r_1341 = nil
							r_1341 = (function()
								if between_3f_1(charAt1(str2, succ1(offset1)), "0", "9") then
									consume_21_1()
									return r_1341()
								else
								end
							end)
							r_1341()
						else
						end
						char7 = charAt1(str2, succ1(offset1))
						local temp14
						local r_1351 = (char7 == "e")
						if r_1351 then
							temp14 = r_1351
						else
							temp14 = (char7 == "E")
						end
						if temp14 then
							consume_21_1()
							char7 = charAt1(str2, succ1(offset1))
							local temp15
							local r_1361 = (char7 == "-")
							if r_1361 then
								temp15 = r_1361
							else
								temp15 = (char7 == "+")
							end
							if temp15 then
								consume_21_1()
							else
							end
							local r_1371 = nil
							r_1371 = (function()
								if between_3f_1(charAt1(str2, succ1(offset1)), "0", "9") then
									consume_21_1()
									return r_1371()
								else
								end
							end)
							r_1371()
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
					printError_21_1(format1("Expected digit, got %s", (function()
						if (char7 == "") then
							return "eof"
						else
							return char7
						end
					end)()
					))
					putTrace_21_1(range3(position2()))
					putLines_21_1(false, range3(position2()), "Illegal character here. Are you missing whitespace?")
					fail_21_1("Lexing failed")
				end
			elseif (char7 == "\"") then
				local start9 = position2()
				local startCol1 = succ1(column1)
				local buffer1 = {tag = "list", n = 0}
				consume_21_1()
				char7 = charAt1(str2, offset1)
				local r_1381 = nil
				r_1381 = (function()
					if (char7 ~= "\"") then
						if (column1 == 1) then
							local running1 = true
							local lineOff1 = offset1
							local r_1391 = nil
							r_1391 = (function()
								local temp16
								local r_1401 = running1
								if r_1401 then
									temp16 = (column1 < startCol1)
								else
									temp16 = r_1401
								end
								if temp16 then
									if (char7 == " ") then
										consume_21_1()
									elseif (char7 == "\n") then
										consume_21_1()
										pushCdr_21_1(buffer1, "\n")
										lineOff1 = offset1
									elseif (char7 == "") then
										running1 = false
									else
										printWarning_21_1(format1("Expected leading indent, got %q", char7))
										putTrace_21_1(range3(position2()))
										putExplain_21_1("You should try to align multi-line strings at the initial quote", "mark. This helps keep programs neat and tidy.")
										putLines_21_1(false, range3(start9), "String started with indent here", range3(position2()), "Mis-aligned character here")
										pushCdr_21_1(buffer1, sub1(str2, lineOff1, pred1(offset1)))
										running1 = false
									end
									char7 = charAt1(str2, offset1)
									return r_1391()
								else
								end
							end)
							r_1391()
						else
						end
						if (char7 == "") then
							printError_21_1("Expected '\"', got eof")
							local start10 = range3(start9)
							local finish5 = range3(position2())
							putTrace_21_1(finish5)
							putLines_21_1(false, start10, "string started here", finish5, "end of file here")
							fail_21_1("Lexing failed")
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
								local temp17
								local r_1411 = (char7 == "x")
								if r_1411 then
									temp17 = r_1411
								else
									local r_1421 = (char7 == "X")
									if r_1421 then
										temp17 = r_1421
									else
										temp17 = between_3f_1(char7, "0", "9")
									end
								end
								if temp17 then
									local start11 = position2()
									local val6
									local temp18
									local r_1431 = (char7 == "x")
									if r_1431 then
										temp18 = r_1431
									else
										temp18 = (char7 == "X")
									end
									if temp18 then
										consume_21_1()
										local start12 = offset1
										if hexDigit_3f_1(charAt1(str2, offset1)) then
										else
											digitError_21_1(range3(position2()), "hexadecimal", charAt1(str2, offset1))
										end
										if hexDigit_3f_1(charAt1(str2, succ1(offset1))) then
											consume_21_1()
										else
										end
										val6 = tonumber1(sub1(str2, start12, offset1), 16)
									else
										local start13 = position2()
										local ctr1 = 0
										char7 = charAt1(str2, succ1(offset1))
										local r_1591 = nil
										r_1591 = (function()
											local temp19
											local r_1601 = (ctr1 < 2)
											if r_1601 then
												temp19 = between_3f_1(char7, "0", "9")
											else
												temp19 = r_1601
											end
											if temp19 then
												consume_21_1()
												char7 = charAt1(str2, succ1(offset1))
												ctr1 = (ctr1 + 1)
												return r_1591()
											else
											end
										end)
										r_1591()
										val6 = tonumber1(sub1(str2, start13["offset"], offset1))
									end
									if (val6 >= 256) then
										printError_21_1("Invalid escape code")
										putTrace_21_1(range3(start11))
										putLines_21_1(true, range3(start11, position2()), _2e2e_2("Must be between 0 and 255, is ", val6))
										fail_21_1("Lexing failed")
									else
									end
									pushCdr_21_1(buffer1, char1(val6))
								elseif (char7 == "") then
									printError_21_1("Expected escape code, got eof")
									putTrace_21_1(range3(position2()))
									putLines_21_1(false, range3(position2()), "end of file here")
									fail_21_1("Lexing failed")
								else
									printError_21_1("Illegal escape character")
									putTrace_21_1(range3(position2()))
									putLines_21_1(false, range3(position2()), "Unknown escape character")
									fail_21_1("Lexing failed")
								end
							end
						else
							pushCdr_21_1(buffer1, char7)
						end
						consume_21_1()
						char7 = charAt1(str2, offset1)
						return r_1381()
					else
					end
				end)
				r_1381()
				appendWith_21_1(struct1("tag", "string", "value", concat1(buffer1)), start9)
			elseif (char7 == ";") then
				local r_1611 = nil
				r_1611 = (function()
					local temp20
					local r_1621 = (offset1 <= length1)
					if r_1621 then
						temp20 = (charAt1(str2, succ1(offset1)) ~= "\n")
					else
						temp20 = r_1621
					end
					if temp20 then
						consume_21_1()
						return r_1611()
					else
					end
				end)
				r_1611()
			else
				local start14 = position2()
				local key3 = (char7 == ":")
				char7 = charAt1(str2, succ1(offset1))
				local r_1631 = nil
				r_1631 = (function()
					if _21_1(terminator_3f_1(char7)) then
						consume_21_1()
						char7 = charAt1(str2, succ1(offset1))
						return r_1631()
					else
					end
				end)
				r_1631()
				if key3 then
					appendWith_21_1(struct1("tag", "key", "value", sub1(str2, succ1(start14["offset"]), offset1)), start14)
				else
					append_21_1("symbol", start14)
				end
			end
			consume_21_1()
			return r_1281()
		else
		end
	end)
	r_1281()
	append_21_1("eof")
	return out4
end)
parse1 = (function(toks1)
	local head2 = {tag = "list", n = 0}
	local stack1 = {tag = "list", n = 0}
	local append_21_2 = (function(node6)
		pushCdr_21_1(head2, node6)
		node6["parent"] = head2
		return nil
	end)
	local push_21_1 = (function()
		local next1 = {tag = "list", n = 0}
		pushCdr_21_1(stack1, head2)
		append_21_2(next1)
		head2 = next1
		return nil
	end)
	local pop_21_1 = (function()
		head2["open"] = nil
		head2["close"] = nil
		head2["auto-close"] = nil
		head2["last-node"] = nil
		head2 = last1(stack1)
		return popLast_21_1(stack1)
	end)
	local r_1481 = _23_1(toks1)
	local r_1461 = nil
	r_1461 = (function(r_1471)
		if (r_1471 <= r_1481) then
			local tok1 = toks1[r_1471]
			local tag4 = tok1["tag"]
			local autoClose1 = false
			local previous3 = head2["last-node"]
			local tokPos1 = tok1["range"]
			local temp21
			local r_1501 = (tag4 ~= "eof")
			if r_1501 then
				local r_1511 = (tag4 ~= "close")
				if r_1511 then
					if head2["range"] then
						temp21 = (tokPos1["start"]["line"] ~= head2["range"]["start"]["line"])
					else
						temp21 = true
					end
				else
					temp21 = r_1511
				end
			else
				temp21 = r_1501
			end
			if temp21 then
				if previous3 then
					local prevPos1 = previous3["range"]
					if (tokPos1["start"]["line"] ~= prevPos1["start"]["line"]) then
						head2["last-node"] = tok1
						if (tokPos1["start"]["column"] ~= prevPos1["start"]["column"]) then
							printWarning_21_1("Different indent compared with previous expressions.")
							putTrace_21_1(tok1)
							putExplain_21_1("You should try to maintain consistent indentation across a program,", "try to ensure all expressions are lined up.", "If this looks OK to you, check you're not missing a closing ')'.")
							putLines_21_1(false, prevPos1, "", tokPos1, "")
						else
						end
					else
					end
				else
					head2["last-node"] = tok1
				end
			else
			end
			local temp22
			local r_1521 = (tag4 == "string")
			if r_1521 then
				temp22 = r_1521
			else
				local r_1531 = (tag4 == "number")
				if r_1531 then
					temp22 = r_1531
				else
					local r_1541 = (tag4 == "symbol")
					if r_1541 then
						temp22 = r_1541
					else
						temp22 = (tag4 == "key")
					end
				end
			end
			if temp22 then
				append_21_2(tok1)
			elseif (tag4 == "open") then
				push_21_1()
				head2["open"] = tok1["contents"]
				head2["close"] = tok1["close"]
				head2["range"] = struct1("start", tok1["range"]["start"], "name", tok1["range"]["name"], "lines", tok1["range"]["lines"])
			elseif (tag4 == "close") then
				if nil_3f_1(stack1) then
					errorPositions_21_1(tok1, format1("'%s' without matching '%s'", tok1["contents"], tok1["open"]))
				elseif head2["auto-close"] then
					printError_21_1(format1("'%s' without matching '%s' inside quote", tok1["contents"], tok1["open"]))
					putTrace_21_1(tok1)
					putLines_21_1(false, head2["range"], "quote opened here", tok1["range"], "attempting to close here")
					fail_21_1("Parsing failed")
				elseif (head2["close"] ~= tok1["contents"]) then
					printError_21_1(format1("Expected '%s', got '%s'", head2["close"], tok1["contents"]))
					putTrace_21_1(tok1)
					putLines_21_1(false, head2["range"], format1("block opened with '%s'", head2["open"]), tok1["range"], format1("'%s' used here", tok1["contents"]))
					fail_21_1("Parsing failed")
				else
					head2["range"]["finish"] = tok1["range"]["finish"]
					pop_21_1()
				end
			else
				local temp23
				local r_1551 = (tag4 == "quote")
				if r_1551 then
					temp23 = r_1551
				else
					local r_1561 = (tag4 == "unquote")
					if r_1561 then
						temp23 = r_1561
					else
						local r_1571 = (tag4 == "syntax-quote")
						if r_1571 then
							temp23 = r_1571
						else
							temp23 = (tag4 == "unquote-splice")
						end
					end
				end
				if temp23 then
					push_21_1()
					head2["range"] = struct1("start", tok1["range"]["start"], "name", tok1["range"]["name"], "lines", tok1["range"]["lines"])
					append_21_2(struct1("tag", "symbol", "contents", tag4, "range", tok1["range"]))
					autoClose1 = true
					head2["auto-close"] = true
				elseif (tag4 == "eof") then
					if (0 ~= _23_1(stack1)) then
						printError_21_1("Expected ')', got eof")
						putTrace_21_1(tok1)
						putLines_21_1(false, head2["range"], "block opened here", tok1["range"], "end of file here")
						fail_21_1("Parsing failed")
					else
					end
				else
					error1(_2e2e_2("Unsupported type", tag4))
				end
			end
			if autoClose1 then
			else
				local r_1581 = nil
				r_1581 = (function()
					if head2["auto-close"] then
						if nil_3f_1(stack1) then
							errorPositions_21_1(tok1, format1("'%s' without matching '%s'", tok1["contents"], tok1["open"]))
							fail_21_1("Parsing failed")
						else
						end
						head2["range"]["finish"] = tok1["range"]["finish"]
						pop_21_1()
						return r_1581()
					else
					end
				end)
				r_1581()
			end
			return r_1461((r_1471 + 1))
		else
		end
	end)
	r_1461(1)
	return head2
end)
read1 = compose1(parse1, lex1)
return struct1("lex", lex1, "parse", parse1, "read", read1)
