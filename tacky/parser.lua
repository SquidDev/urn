table.pack = function(...) return { n = select("#", ...), ... } end
table.unpack = unpack
local function load(x, _, _, env) local f, e = loadstring(x); if not f then error(e, 1) end; return setfenv(f, env) end
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
getIdx1 = _libs["get-idx"]
setIdx_21_1 = _libs["set-idx!"]
format1 = _libs["format"]
print_21_1 = _libs["print!"]
error_21_1 = _libs["error!"]
type_23_1 = _libs["type#"]
emptyStruct1 = _libs["empty-struct"]
number_2d3e_string1 = _libs["number->string"]
_23_1 = (function(xs1)
	return xs1["n"]
end);
car1 = (function(xs2)
	return xs2[1]
end);
_21_1 = (function(expr1)
	if expr1 then
		return false
	else
		return true
	end
end);
key_3f_1 = (function(x7)
	return (type1(x7) == "key")
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
pushCdr_21_1 = (function(li9, val2)
	local r_111
	r_111 = type1(li9)
	if (r_111 ~= "list") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_111), 2)
	else
	end
	local len1
	len1 = (_23_1(li9) + 1)
	li9["n"] = len1
	li9[len1] = val2
	return li9
end);
popLast_21_1 = (function(li10)
	local r_121
	r_121 = type1(li10)
	if (r_121 ~= "list") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_121), 2)
	else
	end
	li10[_23_1(li10)] = nil
	li10["n"] = (_23_1(li10) - 1)
	return li10
end);
nil_3f_1 = (function(li6)
	return (_23_2(li6) == 0)
end);
last1 = (function(xs6)
	return nth1(xs6, _23_2(xs6))
end);
cadr1 = (function(x1)
	return nth1(x1, 2)
end);
concat1 = _libs["concat"]
find1 = _libs["find"]
format2 = _libs["format"]
rep1 = _libs["rep"]
sub1 = _libs["sub"]
_23_s1 = _libs["#s"]
charAt1 = (function(text1, pos1)
	return sub1(text1, pos1, pos1)
end);
_2e2e_1 = (function(...)
	local args3 = table.pack(...) args3.tag = "list"
	return concat1(args3)
end);
split1 = (function(text2, pattern1, limit1)
	local out2, loop1, start3
	out2 = {tag = "list", n = 0}
	loop1 = true
	start3 = 1
	local r_511
	r_511 = nil
	r_511 = (function()
		if loop1 then
			local pos2
			pos2 = find1(text2, pattern1, start3)
			local _temp
			local r_521
			r_521 = ("nil" == type_23_1(pos2))
			if r_521 then
				_temp = r_521
			else
				local r_531
				r_531 = limit1
				if r_531 then
					_temp = (_23_1(out2) >= limit1)
				else
					_temp = r_531
				end
			end
			if _temp then
				loop1 = false
				pushCdr_21_1(out2, sub1(text2, start3, _23_s1(text2)))
				start3 = (_23_s1(text2) + 1)
			else
				pushCdr_21_1(out2, sub1(text2, start3, (car1(pos2) - 1)))
				start3 = (cadr1(pos2) + 1)
			end
			return r_511()
		else
		end
	end);
	r_511()
	return out2
end);
struct1 = (function(...)
	local keys3 = table.pack(...) keys3.tag = "list"
	if ((_23_2(keys3) % 1) == 1) then
		error_21_1("Expected an even number of arguments to struct", 2)
	else
	end
	local contents1, out3
	contents1 = (function(key3)
		return sub1(key3["contents"], 2)
	end);
	out3 = {}
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
			local key4, val3
			key4 = keys3[i3]
			val3 = keys3[(1 + i3)]
			out3[(function()
				if key_3f_1(key4) then
					return contents1(key4)
				else
					return key4
				end
			end)()] = val3
			return r_601((r_611 + r_631))
		else
		end
	end);
	r_601(1)
	return out3
end);
fail1 = (function(msg1)
	return error_21_1(msg1, 0)
end);
between_3f_1 = (function(val4, min1, max1)
	local r_901
	r_901 = (val4 >= min1)
	if r_901 then
		return (val4 <= max1)
	else
		return r_901
	end
end);
succ1 = (function(x8)
	return (1 + x8)
end);
pred1 = (function(x9)
	return (x9 - 1)
end);
verbosity1 = struct1("value", 0)
setVerbosity_21_1 = (function(level1)
	verbosity1["value"] = level1
	return nil
end);
showExplain1 = struct1("value", false)
setExplain_21_1 = (function(value2)
	showExplain1["value"] = value2
	return nil
end);
colored1 = (function(col1, msg2)
	return _2e2e_1("\27[", col1, "m", msg2, "\27[0m")
end);
printError_21_1 = (function(msg3)
	local lines1
	lines1 = split1(msg3, "\n", 1)
	print_21_1(colored1(31, _2e2e_1("[ERROR] ", car2(lines1))))
	if cadr1(lines1) then
		return print_21_1(cadr1(lines1))
	else
	end
end);
printWarning_21_1 = (function(msg4)
	local lines2
	lines2 = split1(msg4, "\n", 1)
	print_21_1(colored1(33, _2e2e_1("[WARN] ", car2(lines2))))
	if cadr1(lines2) then
		return print_21_1(cadr1(lines2))
	else
	end
end);
printVerbose_21_1 = (function(msg5)
	if (verbosity1["value"] > 0) then
		return print_21_1(_2e2e_1("[VERBOSE] ", msg5))
	else
	end
end);
printDebug_21_1 = (function(msg6)
	if (verbosity1["value"] > 1) then
		return print_21_1(_2e2e_1("[DEBUG] ", msg6))
	else
	end
end);
formatPosition1 = (function(pos3)
	return _2e2e_1(pos3["line"], ":", pos3["column"])
end);
formatRange1 = (function(range1)
	if range1["finish"] then
		return format2("%s %s-%s", range1["name"], formatPosition1(range1["start"]), formatPosition1(range1["finish"]))
	else
		return format2("%s %s", range1["name"], formatPosition1(range1["start"]))
	end
end);
formatNode1 = (function(node1)
	local _temp
	local r_1061
	r_1061 = node1["range"]
	if r_1061 then
		_temp = node1["contents"]
	else
		_temp = r_1061
	end
	if _temp then
		return format2("%s (%q)", formatRange1(node1["range"]), node1["contents"])
	elseif node1["range"] then
		return formatRange1(node1["range"])
	elseif node1["macro"] then
		local macro1
		macro1 = node1["macro"]
		return format2("macro expansion of %s (%s)", macro1["var"]["name"], formatNode1(macro1["node"]))
	else
		return "?"
	end
end);
getSource1 = (function(node2)
	local result1
	result1 = nil
	local r_1071
	r_1071 = nil
	r_1071 = (function()
		local _temp
		local r_1081
		r_1081 = node2
		if r_1081 then
			_temp = _21_1(result1)
		else
			_temp = r_1081
		end
		if _temp then
			result1 = node2["range"]
			node2 = node2["parent"]
			return r_1071()
		else
		end
	end);
	r_1071()
	return result1
end);
putLines_21_1 = (function(range2, ...)
	local entries1 = table.pack(...) entries1.tag = "list"
	if nil_3f_1(entries1) then
		error_21_1("Positions cannot be empty")
	else
	end
	if ((_23_2(entries1) % 2) ~= 0) then
		error_21_1(_2e2e_1("Positions must be a multiple of 2, is ", _23_2(entries1)))
	else
	end
	local previous1
	previous1 = -1
	local maxLine1
	maxLine1 = entries1[pred1(_23_2(entries1))]["start"]["line"]
	local code1
	code1 = _2e2e_1("\27[92m %", _23_s1(number_2d3e_string1(maxLine1)), "s |\27[0m %s")
	local r_1181
	r_1181 = _23_2(entries1)
	local r_1191
	r_1191 = 2
	local r_1161
	r_1161 = nil
	r_1161 = (function(r_1171)
		local _temp
		if (0 < 2) then
			_temp = (r_1171 <= r_1181)
		else
			_temp = (r_1171 >= r_1181)
		end
		if _temp then
			local i4
			i4 = r_1171
			local position1, message1
			position1 = entries1[i4]
			message1 = entries1[succ1(i4)]
			local _temp
			local r_1201
			r_1201 = (previous1 ~= -1)
			if r_1201 then
				_temp = ((position1["start"]["line"] - previous1) > 2)
			else
				_temp = r_1201
			end
			if _temp then
				print_21_1(" \27[92m...\27[0m")
			else
			end
			previous1 = position1["start"]["line"]
			print_21_1(format2(code1, number_2d3e_string1(position1["start"]["line"]), position1["lines"][position1["start"]["line"]]))
			local pointer1
			if _21_1(range2) then
				pointer1 = "^"
			else
				local _temp
				local r_1211
				r_1211 = position1["finish"]
				if r_1211 then
					_temp = (position1["start"]["line"] == position1["finish"]["line"])
				else
					_temp = r_1211
				end
				if _temp then
					pointer1 = rep1("^", _2d_1(position1["finish"]["column"], position1["start"]["column"], -1))
				else
					pointer1 = "^..."
				end
			end
			print_21_1(format2(code1, "", _2e2e_1(rep1(" ", (position1["start"]["column"] - 1)), pointer1, " ", message1)))
			return r_1161((r_1171 + r_1191))
		else
		end
	end);
	return r_1161(1)
end);
putTrace_21_1 = (function(node3)
	local previous2
	previous2 = nil
	local r_1091
	r_1091 = nil
	r_1091 = (function()
		if node3 then
			local formatted1
			formatted1 = formatNode1(node3)
			if (previous2 == nil) then
				print_21_1(colored1(96, _2e2e_1("  => ", formatted1)))
			elseif (previous2 ~= formatted1) then
				print_21_1(_2e2e_1("  in ", formatted1))
			else
				local _ = nil
			end
			previous2 = formatted1
			node3 = node3["parent"]
			return r_1091()
		else
		end
	end);
	return r_1091()
end);
putExplain_21_1 = (function(...)
	local lines3 = table.pack(...) lines3.tag = "list"
	if showExplain1["value"] then
		local r_1111
		r_1111 = lines3
		local r_1141
		r_1141 = _23_2(r_1111)
		local r_1151
		r_1151 = 1
		local r_1121
		r_1121 = nil
		r_1121 = (function(r_1131)
			local _temp
			if (0 < 1) then
				_temp = (r_1131 <= r_1141)
			else
				_temp = (r_1131 >= r_1141)
			end
			if _temp then
				local r_1101
				r_1101 = r_1131
				local line1
				line1 = r_1111[r_1101]
				print_21_1(_2e2e_1("  ", line1))
				return r_1121((r_1131 + r_1151))
			else
			end
		end);
		return r_1121(1)
	else
	end
end);
errorPositions_21_1 = (function(node4, msg7)
	printError_21_1(msg7)
	putTrace_21_1(node4)
	local source1
	source1 = getSource1(node4)
	if source1 then
		putLines_21_1(true, source1, "")
	else
	end
	return fail1("An error occured")
end);
struct1("formatPosition", formatPosition1, "formatRange", formatRange1, "formatNode", formatNode1, "putLines", putLines_21_1, "putTrace", putTrace_21_1, "putInfo", putExplain_21_1, "getSource", getSource1, "printWarning", printWarning_21_1, "printError", printError_21_1, "printVerbose", printVerbose_21_1, "printDebug", printDebug_21_1, "errorPositions", errorPositions_21_1, "setVerbosity", setVerbosity_21_1, "setExplain", setExplain_21_1)
lex1 = (function(str1, name3)
	local lines4
	lines4 = split1(str1, "\n")
	local line2
	line2 = 1
	local column1
	column1 = 1
	local offset1
	offset1 = 1
	local length1
	length1 = _23_s1(str1)
	local out4
	out4 = {tag = "list", n = 0}
	local consume_21_1
	consume_21_1 = (function()
		if (charAt1(str1, offset1) == "\n") then
			line2 = (line2 + 1)
			column1 = 1
		else
			column1 = (column1 + 1)
		end
		offset1 = (offset1 + 1)
		return nil
	end);
	local position2
	position2 = (function()
		return struct1("line", line2, "column", column1, "offset", offset1)
	end);
	local range3
	range3 = (function(start4, finish2)
		return struct1("start", start4, "finish", finish2, "lines", lines4, "name", name3)
	end);
	local appendWith_21_1
	appendWith_21_1 = (function(data1, start5, finish3)
		local start6, finish4
		local r_1391
		r_1391 = start5
		if r_1391 then
			start6 = r_1391
		else
			start6 = position2()
		end
		local r_1401
		r_1401 = finish3
		if r_1401 then
			finish4 = r_1401
		else
			finish4 = position2()
		end
		data1["range"] = range3(start6, finish4)
		data1["contents"] = sub1(str1, start6["offset"], finish4["offset"])
		return pushCdr_21_1(out4, data1)
	end);
	local append_21_1
	append_21_1 = (function(tag2, start7, finish5)
		return appendWith_21_1(struct1("tag", tag2), start7, finish5)
	end);
	local r_911
	r_911 = nil
	r_911 = (function()
		if (offset1 <= length1) then
			local char1
			char1 = charAt1(str1, offset1)
			local _temp
			local r_921
			r_921 = (char1 == "\n")
			if r_921 then
				_temp = r_921
			else
				local r_931
				r_931 = (char1 == "\t")
				if r_931 then
					_temp = r_931
				else
					_temp = (char1 == " ")
				end
			end
			if _temp then
			elseif (char1 == "(") then
				appendWith_21_1(struct1("tag", "open", "close", ")"))
			elseif (char1 == ")") then
				appendWith_21_1(struct1("tag", "close", "open", "("))
			elseif (char1 == "[") then
				appendWith_21_1(struct1("tag", "open", "close", "]"))
			elseif (char1 == "]") then
				appendWith_21_1(struct1("tag", "close", "open", "["))
			elseif (char1 == "{") then
				appendWith_21_1(struct1("tag", "open", "close", "}"))
			elseif (char1 == "}") then
				appendWith_21_1(struct1("tag", "close", "open", "{"))
			elseif (char1 == "'") then
				append_21_1("quote")
			elseif (char1 == "`") then
				append_21_1("quasiquote")
			elseif (char1 == ",") then
				if (charAt1(str1, succ1(offset1)) == "@") then
					local start8
					start8 = position2()
					consume_21_1()
					append_21_1("unquote-splice", start8)
				else
					append_21_1("unquote")
				end
			else
				local _temp
				local r_1221
				r_1221 = between_3f_1(char1, "0", "9")
				if r_1221 then
					_temp = r_1221
				else
					local r_1231
					r_1231 = (char1 == "-")
					if r_1231 then
						_temp = between_3f_1(charAt1(str1, succ1(offset1)), "0", "9")
					else
						_temp = r_1231
					end
				end
				if _temp then
					local start9
					start9 = position2()
					local r_1241
					r_1241 = nil
					r_1241 = (function()
						if find1(charAt1(str1, succ1(offset1)), "[0-9.e+-]") then
							consume_21_1()
							return r_1241()
						else
						end
					end);
					r_1241()
					append_21_1("number", start9)
				elseif (char1 == "\"") then
					local start10
					start10 = position2()
					consume_21_1()
					char1 = charAt1(str1, offset1)
					local r_1251
					r_1251 = nil
					r_1251 = (function()
						if (char1 ~= "\"") then
							local _temp
							local r_1261
							r_1261 = (char1 == nil)
							if r_1261 then
								_temp = r_1261
							else
								_temp = (char1 == "")
							end
							if _temp then
								printError_21_1("Expected '\"', got eof")
								local start11, finish6
								start11 = range3(start10)
								finish6 = range3(position2())
								putTrace_21_1(struct1("range", finish6))
								putLines_21_1(false, start11, "string started here", finish6, "end of file here")
								fail1("Lexing failed")
							elseif (char1 == "\\") then
								consume_21_1()
							else
							end
							consume_21_1()
							char1 = charAt1(str1, offset1)
							return r_1251()
						else
						end
					end);
					r_1251()
					append_21_1("string", start10)
				elseif (char1 == ";") then
					local r_1271
					r_1271 = nil
					r_1271 = (function()
						local _temp
						local r_1281
						r_1281 = (offset1 <= length1)
						if r_1281 then
							_temp = (charAt1(str1, succ1(offset1)) ~= "\n")
						else
							_temp = r_1281
						end
						if _temp then
							consume_21_1()
							return r_1271()
						else
						end
					end);
					r_1271()
				else
					local start12, tag3
					start12 = position2()
					if (char1 == ":") then
						tag3 = "key"
					else
						tag3 = "symbol"
					end
					char1 = charAt1(str1, succ1(offset1))
					local r_1291
					r_1291 = nil
					r_1291 = (function()
						local _temp
						local r_1301
						r_1301 = (char1 ~= "\n")
						if r_1301 then
							local r_1311
							r_1311 = (char1 ~= " ")
							if r_1311 then
								local r_1321
								r_1321 = (char1 ~= "\t")
								if r_1321 then
									local r_1331
									r_1331 = (char1 ~= "(")
									if r_1331 then
										local r_1341
										r_1341 = (char1 ~= ")")
										if r_1341 then
											local r_1351
											r_1351 = (char1 ~= "[")
											if r_1351 then
												local r_1361
												r_1361 = (char1 ~= "]")
												if r_1361 then
													local r_1371
													r_1371 = (char1 ~= "{")
													if r_1371 then
														local r_1381
														r_1381 = (char1 ~= "}")
														if r_1381 then
															_temp = (char1 ~= "")
														else
															_temp = r_1381
														end
													else
														_temp = r_1371
													end
												else
													_temp = r_1361
												end
											else
												_temp = r_1351
											end
										else
											_temp = r_1341
										end
									else
										_temp = r_1331
									end
								else
									_temp = r_1321
								end
							else
								_temp = r_1311
							end
						else
							_temp = r_1301
						end
						if _temp then
							consume_21_1()
							char1 = charAt1(str1, succ1(offset1))
							return r_1291()
						else
						end
					end);
					r_1291()
					append_21_1(tag3, start12)
				end
			end
			consume_21_1()
			return r_911()
		else
		end
	end);
	r_911()
	append_21_1("eof")
	return out4
end);
parse1 = (function(toks1)
	local index1
	index1 = 1
	local head1
	head1 = {tag = "list", n = 0}
	local stack1
	stack1 = {tag = "list", n = 0}
	local append_21_2
	append_21_2 = (function(node5)
		local next1
		next1 = {tag = "list", n = 0}
		pushCdr_21_1(head1, node5)
		node5["parent"] = head1
		return nil
	end);
	local push_21_1
	push_21_1 = (function()
		local next2
		next2 = {tag = "list", n = 0}
		pushCdr_21_1(stack1, head1)
		append_21_2(next2)
		head1 = next2
		return nil
	end);
	local pop_21_1
	pop_21_1 = (function()
		head1["open"] = nil
		head1["close"] = nil
		head1["auto-close"] = nil
		head1 = last1(stack1)
		return popLast_21_1(stack1)
	end);
	local r_951
	r_951 = toks1
	local r_981
	r_981 = _23_2(r_951)
	local r_991
	r_991 = 1
	local r_961
	r_961 = nil
	r_961 = (function(r_971)
		local _temp
		if (0 < 1) then
			_temp = (r_971 <= r_981)
		else
			_temp = (r_971 >= r_981)
		end
		if _temp then
			local r_941
			r_941 = r_971
			local tok1
			tok1 = r_951[r_941]
			local tag4
			tag4 = tok1["tag"]
			local autoClose1
			autoClose1 = false
			local _temp
			local r_1001
			r_1001 = (tag4 == "string")
			if r_1001 then
				_temp = r_1001
			else
				local r_1011
				r_1011 = (tag4 == "number")
				if r_1011 then
					_temp = r_1011
				else
					local r_1021
					r_1021 = (tag4 == "symbol")
					if r_1021 then
						_temp = r_1021
					else
						_temp = (tag4 == "key")
					end
				end
			end
			if _temp then
				append_21_2(tok1)
			elseif (tag4 == "open") then
				local previous3
				previous3 = last1(head1)
				local _temp
				local r_1031
				r_1031 = previous3
				if r_1031 then
					local r_1041
					r_1041 = head1["range"]
					if r_1041 then
						_temp = (previous3["range"]["start"]["line"] ~= head1["range"]["start"]["line"])
					else
						_temp = r_1041
					end
				else
					_temp = r_1031
				end
				if _temp then
					local prevPos1, tokPos1
					prevPos1 = previous3["range"]
					tokPos1 = tok1["range"]
					local _temp
					local r_1051
					r_1051 = (prevPos1["start"]["column"] ~= tokPos1["start"]["column"])
					if r_1051 then
						_temp = (prevPos1["start"]["line"] ~= tokPos1["start"]["line"])
					else
						_temp = r_1051
					end
					if _temp then
						printWarning_21_1("Different indent compared with previous expressions.")
						putTrace_21_1(tok1)
						putExplain_21_1("You should try to maintain consistent indentation across a program,", "try to ensure all expressions are lined up.", "If this looks OK to you, check you're not missing a closing ')'.")
						putLines_21_1(false, prevPos1, "", tokPos1, "")
					else
					end
				else
				end
				push_21_1()
				head1["open"] = tok1["contents"]
				head1["close"] = tok1["close"]
				head1["range"] = struct1("start", tok1["range"]["start"], "name", tok1["range"]["name"], "lines", tok1["range"]["lines"])
			elseif (tag4 == "close") then
				if nil_3f_1(stack1) then
					errorPositions_21_1(tok1, format2("'%s' without matching '%s'", tok1["contents"], tok1["open"]))
				elseif head1["auto-close"] then
					printError_21_1(format2("'%s' without matching '%s' inside quote", tok1["contents"], tok1["open"]))
					putTrace_21_1(tok1)
					putLines_21_1(false, head1["range"], "quote opened here", tok1["range"], "attempting to close here")
					fail1("Parsing failed")
				elseif (head1["close"] ~= tok1["contents"]) then
					printError_21_1(format2("Expected '%s', got '%s'", head1["close"], tok1["contents"]))
					putTrace_21_1(tok1)
					putLines_21_1(false, head1["range"], format2("block opened with '%s'", head1["open"]), tok1["range"], format2("'%s' used here", tok1["contents"]))
					fail1("Parsing failed")
				else
					head1["range"]["finish"] = tok1["range"]["finish"]
					pop_21_1()
				end
			else
				local _temp
				local r_1411
				r_1411 = (tag4 == "quote")
				if r_1411 then
					_temp = r_1411
				else
					local r_1421
					r_1421 = (tag4 == "unquote")
					if r_1421 then
						_temp = r_1421
					else
						local r_1431
						r_1431 = (tag4 == "quasiquote")
						if r_1431 then
							_temp = r_1431
						else
							_temp = (tag4 == "unquote-splice")
						end
					end
				end
				if _temp then
					push_21_1()
					head1["range"] = struct1("start", tok1["range"]["start"], "name", tok1["range"]["name"], "lines", tok1["range"]["lines"])
					append_21_2(struct1("tag", "symbol", "contents", tag4, "range", tok1["range"]))
					autoClose1 = true
					head1["auto-close"] = true
				elseif (tag4 == "eof") then
					if (0 ~= _23_2(stack1)) then
						printError_21_1("Expected ')', got eof")
						putTrace_21_1(tok1)
						putLines_21_1(false, head1["range"], "block opened here", tok1["range"], "end of file here")
						fail1("Parsing failed")
					else
					end
				else
					error_21_1(_2e2e_1("Unsupported type", tag4))
				end
			end
			if autoClose1 then
			else
				local r_1441
				r_1441 = nil
				r_1441 = (function()
					if head1["auto-close"] then
						if nil_3f_1(stack1) then
							errorPositions_21_1(tok1, format2("'%s' without matching '%s'", tok1["contents"], tok1["open"]))
							fail1("Parsing failed")
						else
						end
						head1["range"]["finish"] = tok1["range"]["finish"]
						pop_21_1()
						return r_1441()
					else
					end
				end);
				r_1441()
			end
			return r_961((r_971 + r_991))
		else
		end
	end);
	r_961(1)
	return head1
end);
return struct1("lex", lex1, "parse", parse1)
