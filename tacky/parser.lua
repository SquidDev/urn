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
end)
car1 = (function(xs2)
	return xs2[1]
end)
_21_1 = (function(expr1)
	if expr1 then
		return false
	else
		return true
	end
end)
key_3f_1 = (function(x1)
	return (type1(x1) == "key")
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
_23_2 = (function(li2)
	local r_151
	r_151 = type1(li2)
	if (r_151 ~= "list") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_151), 2)
	else
	end
	return _23_1(li2)
end)
car2 = (function(li3)
	return nth1(li3, 1)
end)
pushCdr_21_1 = (function(li4, val2)
	local r_181
	r_181 = type1(li4)
	if (r_181 ~= "list") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_181), 2)
	else
	end
	local len1
	len1 = (_23_1(li4) + 1)
	li4["n"] = len1
	li4[len1] = val2
	return li4
end)
popLast_21_1 = (function(li5)
	local r_191
	r_191 = type1(li5)
	if (r_191 ~= "list") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_191), 2)
	else
	end
	li5[_23_1(li5)] = nil
	li5["n"] = (_23_1(li5) - 1)
	return li5
end)
nil_3f_1 = (function(li6)
	return (_23_2(li6) == 0)
end)
last1 = (function(xs3)
	return nth1(xs3, _23_2(xs3))
end)
cadr1 = (function(x2)
	return nth1(x2, 2)
end)
concat1 = _libs["concat"]
find1 = _libs["find"]
format2 = _libs["format"]
rep1 = _libs["rep"]
sub1 = _libs["sub"]
_23_s1 = _libs["#s"]
charAt1 = (function(text1, pos1)
	return sub1(text1, pos1, pos1)
end)
_2e2e_1 = (function(...)
	local args1 = _pack(...) args1.tag = "list"
	return concat1(args1)
end)
split1 = (function(text2, pattern1, limit1)
	local out1, loop1, start1
	out1 = {tag = "list", n =0}
	loop1 = true
	start1 = 1
	local r_591
	r_591 = nil
	r_591 = (function()
		if loop1 then
			local pos2
			pos2 = find1(text2, pattern1, start1)
			if (function(r_601)
				if r_601 then
					return r_601
				else
					local r_611
					r_611 = limit1
					if r_611 then
						return (_23_1(out1) >= limit1)
					else
						return r_611
					end
				end
			end)
			(("nil" == type_23_1(pos2))) then
				loop1 = false
				pushCdr_21_1(out1, sub1(text2, start1, _23_s1(text2)))
				start1 = (_23_s1(text2) + 1)
			else
				pushCdr_21_1(out1, sub1(text2, start1, (car1(pos2) - 1)))
				start1 = (cadr1(pos2) + 1)
			end
			return r_591()
		else
		end
	end)
	r_591()
	return out1
end)
struct1 = (function(...)
	local keys1 = _pack(...) keys1.tag = "list"
	if ((_23_2(keys1) % 1) == 1) then
		error_21_1("Expected an even number of arguments to struct", 2)
	else
	end
	local contents1, out2
	contents1 = (function(key1)
		return sub1(key1["contents"], 2)
	end)
	out2 = {}
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
			local key2, val3
			key2 = keys1[i1]
			val3 = keys1[(1 + i1)]
			out2[(function()
				if key_3f_1(key2) then
					return contents1(key2)
				else
					return key2
				end
			end)()
			] = val3
			return r_641((r_651 + r_671))
		else
		end
	end)
	r_641(1)
	return out2
end)
fail1 = (function(msg1)
	return error_21_1(msg1, 0)
end)
between_3f_1 = (function(val4, min1, max1)
	local r_961
	r_961 = (val4 >= min1)
	if r_961 then
		return (val4 <= max1)
	else
		return r_961
	end
end)
succ1 = (function(x3)
	return (1 + x3)
end)
pred1 = (function(x4)
	return (x4 - 1)
end)
verbosity1 = struct1("value", 0)
setVerbosity_21_1 = (function(level1)
	verbosity1["value"] = level1
	return nil
end)
showExplain1 = struct1("value", false)
setExplain_21_1 = (function(value1)
	showExplain1["value"] = value1
	return nil
end)
colored1 = (function(col1, msg2)
	return _2e2e_1("\27[", col1, "m", msg2, "\27[0m")
end)
printError_21_1 = (function(msg3)
	local lines1
	lines1 = split1(msg3, "\n", 1)
	print_21_1(colored1(31, _2e2e_1("[ERROR] ", car2(lines1))))
	if cadr1(lines1) then
		return print_21_1(cadr1(lines1))
	else
	end
end)
printWarning_21_1 = (function(msg4)
	local lines2
	lines2 = split1(msg4, "\n", 1)
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
		return format2("%s %s-%s", range1["name"], formatPosition1(range1["start"]), formatPosition1(range1["finish"]))
	else
		return format2("%s %s", range1["name"], formatPosition1(range1["start"]))
	end
end)
formatNode1 = (function(node1)
	if (function(r_1121)
		if r_1121 then
			return node1["contents"]
		else
			return r_1121
		end
	end)
	(node1["range"]) then
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
end)
getSource1 = (function(node2)
	local result1
	result1 = nil
	local r_1131
	r_1131 = nil
	r_1131 = (function()
		if (function(r_1141)
			if r_1141 then
				return _21_1(result1)
			else
				return r_1141
			end
		end)
		(node2) then
			result1 = node2["range"]
			node2 = node2["parent"]
			return r_1131()
		else
		end
	end)
	r_1131()
	return result1
end)
putLines_21_1 = (function(range2, ...)
	local entries1 = _pack(...) entries1.tag = "list"
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
	local r_1241
	r_1241 = _23_2(entries1)
	local r_1251
	r_1251 = 2
	local r_1221
	r_1221 = nil
	r_1221 = (function(r_1231)
		if (function()
			if (0 < 2) then
				return (r_1231 <= r_1241)
			else
				return (r_1231 >= r_1241)
			end
		end)()
		 then
			local i2
			i2 = r_1231
			local position1, message1
			position1 = entries1[i2]
			message1 = entries1[succ1(i2)]
			if (function(r_1261)
				if r_1261 then
					return ((position1["start"]["line"] - previous1) > 2)
				else
					return r_1261
				end
			end)
			((previous1 ~= -1)) then
				print_21_1(" \27[92m...\27[0m")
			else
			end
			previous1 = position1["start"]["line"]
			print_21_1(format2(code1, number_2d3e_string1(position1["start"]["line"]), position1["lines"][position1["start"]["line"]]))
			local pointer1
			if _21_1(range2) then
				pointer1 = "^"
			elseif (function(r_1271)
				if r_1271 then
					return (position1["start"]["line"] == position1["finish"]["line"])
				else
					return r_1271
				end
			end)
			(position1["finish"]) then
				pointer1 = rep1("^", _2d_1(position1["finish"]["column"], position1["start"]["column"], -1))
			else
				pointer1 = "^..."
			end
			print_21_1(format2(code1, "", _2e2e_1(rep1(" ", (position1["start"]["column"] - 1)), pointer1, " ", message1)))
			return r_1221((r_1231 + r_1251))
		else
		end
	end)
	return r_1221(1)
end)
putTrace_21_1 = (function(node3)
	local previous2
	previous2 = nil
	local r_1151
	r_1151 = nil
	r_1151 = (function()
		if node3 then
			local formatted1
			formatted1 = formatNode1(node3)
			if (previous2 == nil) then
				print_21_1(colored1(96, _2e2e_1("  => ", formatted1)))
			elseif (previous2 ~= formatted1) then
				print_21_1(_2e2e_1("  in ", formatted1))
			else
			end
			previous2 = formatted1
			node3 = node3["parent"]
			return r_1151()
		else
		end
	end)
	return r_1151()
end)
putExplain_21_1 = (function(...)
	local lines3 = _pack(...) lines3.tag = "list"
	if showExplain1["value"] then
		local r_1171
		r_1171 = lines3
		local r_1201
		r_1201 = _23_2(r_1171)
		local r_1211
		r_1211 = 1
		local r_1181
		r_1181 = nil
		r_1181 = (function(r_1191)
			if (function()
				if (0 < 1) then
					return (r_1191 <= r_1201)
				else
					return (r_1191 >= r_1201)
				end
			end)()
			 then
				local r_1161
				r_1161 = r_1191
				local line1
				line1 = r_1171[r_1161]
				print_21_1(_2e2e_1("  ", line1))
				return r_1181((r_1191 + r_1211))
			else
			end
		end)
		return r_1181(1)
	else
	end
end)
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
end)
struct1("formatPosition", formatPosition1, "formatRange", formatRange1, "formatNode", formatNode1, "putLines", putLines_21_1, "putTrace", putTrace_21_1, "putInfo", putExplain_21_1, "getSource", getSource1, "printWarning", printWarning_21_1, "printError", printError_21_1, "printVerbose", printVerbose_21_1, "printDebug", printDebug_21_1, "errorPositions", errorPositions_21_1, "setVerbosity", setVerbosity_21_1, "setExplain", setExplain_21_1)
lex1 = (function(str1, name1)
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
	local out3
	out3 = {tag = "list", n =0}
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
	end)
	local position2
	position2 = (function()
		return struct1("line", line2, "column", column1, "offset", offset1)
	end)
	local range3
	range3 = (function(start2, finish1)
		return struct1("start", start2, "finish", finish1, "lines", lines4, "name", name1)
	end)
	local appendWith_21_1
	appendWith_21_1 = (function(data1, start3, finish2)
		local start4, finish3
		local r_1451
		r_1451 = start3
		if r_1451 then
			start4 = r_1451
		else
			start4 = position2()
		end
		local r_1461
		r_1461 = finish2
		if r_1461 then
			finish3 = r_1461
		else
			finish3 = position2()
		end
		data1["range"] = range3(start4, finish3)
		data1["contents"] = sub1(str1, start4["offset"], finish3["offset"])
		return pushCdr_21_1(out3, data1)
	end)
	local append_21_1
	append_21_1 = (function(tag2, start5, finish4)
		return appendWith_21_1(struct1("tag", tag2), start5, finish4)
	end)
	local r_971
	r_971 = nil
	r_971 = (function()
		if (offset1 <= length1) then
			local char1
			char1 = charAt1(str1, offset1)
			if (function(r_981)
				if r_981 then
					return r_981
				else
					local r_991
					r_991 = (char1 == "\t")
					if r_991 then
						return r_991
					else
						return (char1 == " ")
					end
				end
			end)
			((char1 == "\n")) then
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
					local start6
					start6 = position2()
					consume_21_1()
					append_21_1("unquote-splice", start6)
				else
					append_21_1("unquote")
				end
			elseif (function(r_1281)
				if r_1281 then
					return r_1281
				else
					local r_1291
					r_1291 = (char1 == "-")
					if r_1291 then
						return between_3f_1(charAt1(str1, succ1(offset1)), "0", "9")
					else
						return r_1291
					end
				end
			end)
			(between_3f_1(char1, "0", "9")) then
				local start7
				start7 = position2()
				local r_1301
				r_1301 = nil
				r_1301 = (function()
					if find1(charAt1(str1, succ1(offset1)), "[0-9.e+-]") then
						consume_21_1()
						return r_1301()
					else
					end
				end)
				r_1301()
				append_21_1("number", start7)
			elseif (char1 == "\"") then
				local start8
				start8 = position2()
				consume_21_1()
				char1 = charAt1(str1, offset1)
				local r_1311
				r_1311 = nil
				r_1311 = (function()
					if (char1 ~= "\"") then
						if (function(r_1321)
							if r_1321 then
								return r_1321
							else
								return (char1 == "")
							end
						end)
						((char1 == nil)) then
							printError_21_1("Expected '\"', got eof")
							local start9, finish5
							start9 = range3(start8)
							finish5 = range3(position2())
							putTrace_21_1(struct1("range", finish5))
							putLines_21_1(false, start9, "string started here", finish5, "end of file here")
							fail1("Lexing failed")
						elseif (char1 == "\\") then
							consume_21_1()
						else
						end
						consume_21_1()
						char1 = charAt1(str1, offset1)
						return r_1311()
					else
					end
				end)
				r_1311()
				append_21_1("string", start8)
			elseif (char1 == ";") then
				local r_1331
				r_1331 = nil
				r_1331 = (function()
					if (function(r_1341)
						if r_1341 then
							return (charAt1(str1, succ1(offset1)) ~= "\n")
						else
							return r_1341
						end
					end)
					((offset1 <= length1)) then
						consume_21_1()
						return r_1331()
					else
					end
				end)
				r_1331()
			else
				local start10, tag3
				start10 = position2()
				if (char1 == ":") then
					tag3 = "key"
				else
					tag3 = "symbol"
				end
				char1 = charAt1(str1, succ1(offset1))
				local r_1351
				r_1351 = nil
				r_1351 = (function()
					if (function(r_1361)
						if r_1361 then
							local r_1371
							r_1371 = (char1 ~= " ")
							if r_1371 then
								local r_1381
								r_1381 = (char1 ~= "\t")
								if r_1381 then
									local r_1391
									r_1391 = (char1 ~= "(")
									if r_1391 then
										local r_1401
										r_1401 = (char1 ~= ")")
										if r_1401 then
											local r_1411
											r_1411 = (char1 ~= "[")
											if r_1411 then
												local r_1421
												r_1421 = (char1 ~= "]")
												if r_1421 then
													local r_1431
													r_1431 = (char1 ~= "{")
													if r_1431 then
														local r_1441
														r_1441 = (char1 ~= "}")
														if r_1441 then
															return (char1 ~= "")
														else
															return r_1441
														end
													else
														return r_1431
													end
												else
													return r_1421
												end
											else
												return r_1411
											end
										else
											return r_1401
										end
									else
										return r_1391
									end
								else
									return r_1381
								end
							else
								return r_1371
							end
						else
							return r_1361
						end
					end)
					((char1 ~= "\n")) then
						consume_21_1()
						char1 = charAt1(str1, succ1(offset1))
						return r_1351()
					else
					end
				end)
				r_1351()
				append_21_1(tag3, start10)
			end
			consume_21_1()
			return r_971()
		else
		end
	end)
	r_971()
	append_21_1("eof")
	return out3
end)
parse1 = (function(toks1)
	local index1
	index1 = 1
	local head1
	head1 = {tag = "list", n =0}
	local stack1
	stack1 = {tag = "list", n =0}
	local append_21_2
	append_21_2 = (function(node5)
		local next1
		next1 = {tag = "list", n =0}
		pushCdr_21_1(head1, node5)
		node5["parent"] = head1
		return nil
	end)
	local push_21_1
	push_21_1 = (function()
		local next2
		next2 = {tag = "list", n =0}
		pushCdr_21_1(stack1, head1)
		append_21_2(next2)
		head1 = next2
		return nil
	end)
	local pop_21_1
	pop_21_1 = (function()
		head1["open"] = nil
		head1["close"] = nil
		head1["auto-close"] = nil
		head1 = last1(stack1)
		return popLast_21_1(stack1)
	end)
	local r_1011
	r_1011 = toks1
	local r_1041
	r_1041 = _23_2(r_1011)
	local r_1051
	r_1051 = 1
	local r_1021
	r_1021 = nil
	r_1021 = (function(r_1031)
		if (function()
			if (0 < 1) then
				return (r_1031 <= r_1041)
			else
				return (r_1031 >= r_1041)
			end
		end)()
		 then
			local r_1001
			r_1001 = r_1031
			local tok1
			tok1 = r_1011[r_1001]
			local tag4
			tag4 = tok1["tag"]
			local autoClose1
			autoClose1 = false
			if (function(r_1061)
				if r_1061 then
					return r_1061
				else
					local r_1071
					r_1071 = (tag4 == "number")
					if r_1071 then
						return r_1071
					else
						local r_1081
						r_1081 = (tag4 == "symbol")
						if r_1081 then
							return r_1081
						else
							return (tag4 == "key")
						end
					end
				end
			end)
			((tag4 == "string")) then
				append_21_2(tok1)
			elseif (tag4 == "open") then
				local previous3
				previous3 = last1(head1)
				if (function(r_1091)
					if r_1091 then
						local r_1101
						r_1101 = head1["range"]
						if r_1101 then
							return (previous3["range"]["start"]["line"] ~= head1["range"]["start"]["line"])
						else
							return r_1101
						end
					else
						return r_1091
					end
				end)
				(previous3) then
					local prevPos1, tokPos1
					prevPos1 = previous3["range"]
					tokPos1 = tok1["range"]
					if (function(r_1111)
						if r_1111 then
							return (prevPos1["start"]["line"] ~= tokPos1["start"]["line"])
						else
							return r_1111
						end
					end)
					((prevPos1["start"]["column"] ~= tokPos1["start"]["column"])) then
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
			elseif (function(r_1471)
				if r_1471 then
					return r_1471
				else
					local r_1481
					r_1481 = (tag4 == "unquote")
					if r_1481 then
						return r_1481
					else
						local r_1491
						r_1491 = (tag4 == "quasiquote")
						if r_1491 then
							return r_1491
						else
							return (tag4 == "unquote-splice")
						end
					end
				end
			end)
			((tag4 == "quote")) then
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
			if autoClose1 then
			else
				local r_1501
				r_1501 = nil
				r_1501 = (function()
					if head1["auto-close"] then
						if nil_3f_1(stack1) then
							errorPositions_21_1(tok1, format2("'%s' without matching '%s'", tok1["contents"], tok1["open"]))
							fail1("Parsing failed")
						else
						end
						head1["range"]["finish"] = tok1["range"]["finish"]
						pop_21_1()
						return r_1501()
					else
					end
				end)
				r_1501()
			end
			return r_1021((r_1031 + r_1051))
		else
		end
	end)
	r_1021(1)
	return head1
end)
return struct1("lex", lex1, "parse", parse1)
