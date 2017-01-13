local _libs = {}
local _temp = (function()
	-- base is an internal version of core methods without any extensions or assertions.
	-- You should not use this unless you are building core libraries.

	-- Native methods in base should do the bare minimum: you should try to move as much
	-- as possible to Urn

	local pprint = require "tacky.pprint"

	local randCtr = 0
	return {
		['=='] = function(x, y) return x == y end,
		['~='] = function(x, y) return x ~= y end,
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

_e_3d3d_1 = _libs["=="]
_e_7e3d_1 = _libs["~="]
_e_3c_1 = _libs["<"]
_e_3c3d_1 = _libs["<="]
_e_3e_1 = _libs[">"]
_e_3e3d_1 = _libs[">="]
_e_2b_1 = _libs["+"]
_e1 = _libs["-"]
_e_25_1 = _libs["%"]
_egetIdx1 = _libs["get-idx"]
_esetIdx_21_1 = _libs["set-idx!"]
format1 = _libs["format"]
_eprint_21_1 = _libs["print!"]
_eerror_21_1 = _libs["error!"]
_etype_23_1 = _libs["type#"]
_eemptyStruct1 = _libs["empty-struct"]
_enumber_3e_String1 = _libs["number->string"]
_e_23_1 = (function(xs1)
	return _egetIdx1(xs1, "n")
end);
car1 = (function(xs2)
	return _egetIdx1(xs2, 1)
end);
_e_21_1 = (function(expr1)
	if expr1 then
		return false
	else
		return true
	end
end);
_ekey_3f_1 = (function(x7)
	return _e_3d3d_1(type1(x7), "key")
end);
type1 = (function(val1)
	local ty2
	ty2 = _etype_23_1(val1)
	if _e_3d3d_1(ty2, "table") then
		local tag1
		tag1 = _egetIdx1(val1, "tag")
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
	if _e_7e3d_1(r_51, "list") then
		_eerror_21_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_51), 2)
	else
	end
	local r_201
	r_201 = type1(idx1)
	if _e_7e3d_1(r_201, "number") then
		_eerror_21_1(format1("bad argment %s (expected %s, got %s)", "idx", "number", r_201), 2)
	else
	end
	return _egetIdx1(li4, idx1)
end);
_e_23_2 = (function(li6)
	local r_81
	r_81 = type1(li6)
	if _e_7e3d_1(r_81, "list") then
		_eerror_21_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_81), 2)
	else
	end
	return _e_23_1(li6)
end);
car2 = (function(li3)
	return nth1(li3, 1)
end);
_epushCdr_21_1 = (function(li9, val2)
	local r_111
	r_111 = type1(li9)
	if _e_7e3d_1(r_111, "list") then
		_eerror_21_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_111), 2)
	else
	end
	local len1
	len1 = _e_2b_1(_e_23_1(li9), 1)
	_esetIdx_21_1(li9, "n", len1)
	_esetIdx_21_1(li9, len1, val2)
	return li9
end);
_epopLast_21_1 = (function(li10)
	local r_121
	r_121 = type1(li10)
	if _e_7e3d_1(r_121, "list") then
		_eerror_21_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_121), 2)
	else
	end
	_esetIdx_21_1(li10, _e_23_1(li10), nil)
	_esetIdx_21_1(li10, "n", _e1(_e_23_1(li10), 1))
	return li10
end);
_enil_3f_1 = (function(li5)
	return _e_3d3d_1(_e_23_2(li5), 0)
end);
last1 = (function(xs6)
	return nth1(xs6, _e_23_2(xs6))
end);
cadr1 = (function(x1)
	return nth1(x1, 2)
end);
concat1 = _libs["concat"]
find1 = _libs["find"]
format2 = _libs["format"]
rep1 = _libs["rep"]
sub1 = _libs["sub"]
_e_23_s1 = _libs["#s"]
_echarAt1 = (function(text1, pos1)
	return sub1(text1, pos1, pos1)
end);
_e_2e2e_1 = (function(...)
	local args3 = table.pack(...) args3.tag = "list"
	return concat1(args3)
end);
split1 = (function(text2, pattern1, limit1)
	local out2, loop1, start3
	out2 = {tag = "list", n = 0}
	loop1 = true
	start3 = 1
	local r_751
	r_751 = nil
	r_751 = (function()
		if loop1 then
			local pos2
			pos2 = find1(text2, pattern1, start3)
			local _temp
			local r_761
			r_761 = _e_3d3d_1("nil", _etype_23_1(pos2))
			if r_761 then
				_temp = r_761
			else
				local r_771
				r_771 = limit1
				if r_771 then
					_temp = _e_3e3d_1(_e_23_1(out2), limit1)
				else
					_temp = r_771
				end
			end
			if _temp then
				loop1 = false
				_epushCdr_21_1(out2, sub1(text2, start3, _e_23_s1(text2)))
				start3 = _e_2b_1(_e_23_s1(text2), 1)
			else
				_epushCdr_21_1(out2, sub1(text2, start3, _e1(car1(pos2), 1)))
				start3 = _e_2b_1(cadr1(pos2), 1)
			end
			return r_751()
		else
		end
	end);
	r_751()
	return out2
end);
struct1 = (function(...)
	local keys3 = table.pack(...) keys3.tag = "list"
	if _e_3d3d_1(_e_25_1(_e_23_2(keys3), 1), 1) then
		_eerror_21_1("Expected an even number of arguments to struct", 2)
	else
	end
	local contents1, out3
	contents1 = (function(key3)
		return sub1(_egetIdx1(key3, "contents"), 2)
	end);
	out3 = _eemptyStruct1()
	local r_731
	r_731 = _e_23_1(keys3)
	local r_741
	r_741 = 2
	local r_711
	r_711 = nil
	r_711 = (function(r_721)
		local _temp
		if _e_3c_1(0, 2) then
			_temp = _e_3c3d_1(r_721, r_731)
		else
			_temp = _e_3e3d_1(r_721, r_731)
		end
		if _temp then
			local i3
			i3 = r_721
			local key4, val3
			key4 = _egetIdx1(keys3, i3)
			val3 = _egetIdx1(keys3, _e_2b_1(1, i3))
			_esetIdx_21_1(out3, (function()
				if _ekey_3f_1(key4) then
					return contents1(key4)
				else
					return key4
				end
			end)(), val3)
			return r_711(_e_2b_1(r_721, r_741))
		else
		end
	end);
	r_711(1)
	return out3
end);
fail1 = (function(msg1)
	return _eerror_21_1(msg1, 0)
end);
_ebetween_3f_1 = (function(val4, min1, max1)
	local r_841
	r_841 = _e_3e3d_1(val4, min1)
	if r_841 then
		return _e_3c3d_1(val4, max1)
	else
		return r_841
	end
end);
_e_2f3d_1 = (function(x8, y1)
	return _e_7e3d_1(x8, y1)
end);
_e_3d_1 = (function(x9, y2)
	return _e_3d3d_1(x9, y2)
end);
succ1 = (function(x10)
	return _e_2b_1(1, x10)
end);
pred1 = (function(x11)
	return _e1(x11, 1)
end);
verbosity1 = struct1("value", 0)
_esetVerbosity_21_1 = (function(level1)
	return _esetIdx_21_1(verbosity1, "value", level1)
end);
_eshowExplain1 = struct1("value", false)
_esetExplain_21_1 = (function(value2)
	return _esetIdx_21_1(_eshowExplain1, "value", value2)
end);
colored1 = (function(col1, msg2)
	return _e_2e2e_1("\27[", col1, "m", msg2, "\27[0m")
end);
_eprintError_21_1 = (function(msg3)
	local lines1
	lines1 = split1(msg3, "\n", 1)
	_eprint_21_1(colored1(31, _e_2e2e_1("[ERROR] ", car2(lines1))))
	if cadr1(lines1) then
		return _eprint_21_1(cadr1(lines1))
	else
	end
end);
_eprintWarning_21_1 = (function(msg4)
	local lines2
	lines2 = split1(msg4, "\n", 1)
	_eprint_21_1(colored1(33, _e_2e2e_1("[WARN] ", car2(lines2))))
	if cadr1(lines2) then
		return _eprint_21_1(cadr1(lines2))
	else
	end
end);
_eprintVerbose_21_1 = (function(msg5)
	if _e_3e_1(_egetIdx1(verbosity1, "value"), 0) then
		return _eprint_21_1(_e_2e2e_1("[VERBOSE] ", msg5))
	else
	end
end);
_eprintDebug_21_1 = (function(msg6)
	if _e_3e_1(_egetIdx1(verbosity1, "value"), 1) then
		return _eprint_21_1(_e_2e2e_1("[DEBUG] ", msg6))
	else
	end
end);
_eformatPosition1 = (function(pos3)
	return _e_2e2e_1(_egetIdx1(pos3, "line"), ":", _egetIdx1(pos3, "column"))
end);
_eformatRange1 = (function(range1)
	if _egetIdx1(range1, "finish") then
		return format2("%s %s-%s", _egetIdx1(range1, "name"), _eformatPosition1(_egetIdx1(range1, "start")), _eformatPosition1(_egetIdx1(range1, "finish")))
	else
		return format2("%s %s", _egetIdx1(range1, "name"), _eformatPosition1(_egetIdx1(range1, "start")))
	end
end);
_eformatNode1 = (function(node1)
	local _temp
	local r_991
	r_991 = _egetIdx1(node1, "range")
	if r_991 then
		_temp = _egetIdx1(node1, "contents")
	else
		_temp = r_991
	end
	if _temp then
		return format2("%s (%q)", _eformatRange1(_egetIdx1(node1, "range")), _egetIdx1(node1, "contents"))
	elseif _egetIdx1(node1, "range") then
		return _eformatRange1(_egetIdx1(node1, "range"))
	elseif _egetIdx1(node1, "macro") then
		local macro1
		macro1 = _egetIdx1(node1, "macro")
		return format2("macro expansion of %s (%s)", _egetIdx1(_egetIdx1(macro1, "var"), "name"), _eformatNode1(_egetIdx1(macro1, "node")))
	else
		return "?"
	end
end);
_egetSource1 = (function(node2)
	local result1
	result1 = nil
	local r_1001
	r_1001 = nil
	r_1001 = (function()
		local _temp
		local r_1011
		r_1011 = node2
		if r_1011 then
			_temp = _e_21_1(result1)
		else
			_temp = r_1011
		end
		if _temp then
			result1 = _egetIdx1(node2, "range")
			node2 = _egetIdx1(node2, "parent")
			return r_1001()
		else
		end
	end);
	r_1001()
	return result1
end);
_eputLines_21_1 = (function(range2, ...)
	local entries1 = table.pack(...) entries1.tag = "list"
	if _enil_3f_1(entries1) then
		_eerror_21_1("Positions cannot be empty")
	else
	end
	if _e_2f3d_1(_e_25_1(_e_23_2(entries1), 2), 0) then
		_eerror_21_1(_e_2e2e_1("Positions must be a multiple of 2, is ", _e_23_2(entries1)))
	else
	end
	local previous1
	previous1 = -1
	local _emaxLine1
	_emaxLine1 = _egetIdx1(_egetIdx1(_egetIdx1(entries1, pred1(_e_23_2(entries1))), "start"), "line")
	local code1
	code1 = _e_2e2e_1("\27[92m %", _e_23_s1(_enumber_3e_String1(_emaxLine1)), "s |\27[0m %s")
	local r_1051
	r_1051 = _e_23_2(entries1)
	local r_1061
	r_1061 = 2
	local r_1031
	r_1031 = nil
	r_1031 = (function(r_1041)
		local _temp
		if _e_3c_1(0, 2) then
			_temp = _e_3c3d_1(r_1041, r_1051)
		else
			_temp = _e_3e3d_1(r_1041, r_1051)
		end
		if _temp then
			local i4
			i4 = r_1041
			local position1, message1
			position1 = _egetIdx1(entries1, i4)
			message1 = _egetIdx1(entries1, succ1(i4))
			local _temp
			local r_1071
			r_1071 = _e_2f3d_1(previous1, -1)
			if r_1071 then
				_temp = _e_3e_1(_e1(_egetIdx1(_egetIdx1(position1, "start"), "line"), previous1), 2)
			else
				_temp = r_1071
			end
			if _temp then
				_eprint_21_1(" \27[92m...\27[0m")
			else
			end
			previous1 = _egetIdx1(_egetIdx1(position1, "start"), "line")
			_eprint_21_1(format2(code1, _enumber_3e_String1(_egetIdx1(_egetIdx1(position1, "start"), "line")), _egetIdx1(_egetIdx1(position1, "lines"), _egetIdx1(_egetIdx1(position1, "start"), "line"))))
			local pointer1
			if _e_21_1(range2) then
				pointer1 = "^"
			else
				local _temp
				local r_1141
				r_1141 = _egetIdx1(position1, "finish")
				if r_1141 then
					_temp = _e_3d_1(_egetIdx1(_egetIdx1(position1, "start"), "line"), _egetIdx1(_egetIdx1(position1, "finish"), "line"))
				else
					_temp = r_1141
				end
				if _temp then
					pointer1 = rep1("^", _e1(_egetIdx1(_egetIdx1(position1, "finish"), "column"), _egetIdx1(_egetIdx1(position1, "start"), "column"), -1))
				else
					pointer1 = "^..."
				end
			end
			_eprint_21_1(format2(code1, "", _e_2e2e_1(rep1(" ", _e1(_egetIdx1(_egetIdx1(position1, "start"), "column"), 1)), pointer1, " ", message1)))
			return r_1031(_e_2b_1(r_1041, r_1061))
		else
		end
	end);
	return r_1031(1)
end);
_eputTrace_21_1 = (function(node3)
	local previous2
	previous2 = nil
	local r_1021
	r_1021 = nil
	r_1021 = (function()
		if node3 then
			local formatted1
			formatted1 = _eformatNode1(node3)
			if _e_3d_1(previous2, nil) then
				_eprint_21_1(colored1(96, _e_2e2e_1("  => ", formatted1)))
			elseif _e_2f3d_1(previous2, formatted1) then
				_eprint_21_1(_e_2e2e_1("  in ", formatted1))
			else
				local _ = nil
			end
			previous2 = formatted1
			node3 = _egetIdx1(node3, "parent")
			return r_1021()
		else
		end
	end);
	return r_1021()
end);
_eputExplain_21_1 = (function(...)
	local lines3 = table.pack(...) lines3.tag = "list"
	if _egetIdx1(_eshowExplain1, "value") then
		local r_1091
		r_1091 = lines3
		local r_1121
		r_1121 = _e_23_2(r_1091)
		local r_1131
		r_1131 = 1
		local r_1101
		r_1101 = nil
		r_1101 = (function(r_1111)
			local _temp
			if _e_3c_1(0, 1) then
				_temp = _e_3c3d_1(r_1111, r_1121)
			else
				_temp = _e_3e3d_1(r_1111, r_1121)
			end
			if _temp then
				local r_1081
				r_1081 = r_1111
				local line1
				line1 = _egetIdx1(r_1091, r_1081)
				_eprint_21_1(_e_2e2e_1("  ", line1))
				return r_1101(_e_2b_1(r_1111, r_1131))
			else
			end
		end);
		return r_1101(1)
	else
	end
end);
_eerrorPositions_21_1 = (function(node4, msg7)
	_eprintError_21_1(msg7)
	_eputTrace_21_1(node4)
	local source1
	source1 = _egetSource1(node4)
	if source1 then
		_eputLines_21_1(true, source1, "")
	else
	end
	return fail1("An error occured")
end);
struct1("formatPosition", _eformatPosition1, "formatRange", _eformatRange1, "formatNode", _eformatNode1, "putLines", _eputLines_21_1, "putTrace", _eputTrace_21_1, "putInfo", _eputExplain_21_1, "getSource", _egetSource1, "printWarning", _eprintWarning_21_1, "printError", _eprintError_21_1, "printVerbose", _eprintVerbose_21_1, "printDebug", _eprintDebug_21_1, "errorPositions", _eerrorPositions_21_1, "setVerbosity", _esetVerbosity_21_1, "setExplain", _esetExplain_21_1)
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
	length1 = _e_23_s1(str1)
	local out4
	out4 = {tag = "list", n = 0}
	local _econsume_21_1
	_econsume_21_1 = (function()
		if _e_3d_1(_echarAt1(str1, offset1), "\n") then
			line2 = _e_2b_1(line2, 1)
			column1 = 1
		else
			column1 = _e_2b_1(column1, 1)
		end
		offset1 = _e_2b_1(offset1, 1)
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
	local _eappendWith_21_1
	_eappendWith_21_1 = (function(data1, start5, finish3)
		local start6, finish4
		local r_1321
		r_1321 = start5
		if r_1321 then
			start6 = r_1321
		else
			start6 = position2()
		end
		local r_1331
		r_1331 = finish3
		if r_1331 then
			finish4 = r_1331
		else
			finish4 = position2()
		end
		_esetIdx_21_1(data1, "range", range3(start6, finish4))
		_esetIdx_21_1(data1, "contents", sub1(str1, _egetIdx1(start6, "offset"), _egetIdx1(finish4, "offset")))
		return _epushCdr_21_1(out4, data1)
	end);
	local _eappend_21_1
	_eappend_21_1 = (function(tag2, start7, finish5)
		return _eappendWith_21_1(struct1("tag", tag2), start7, finish5)
	end);
	local r_851
	r_851 = nil
	r_851 = (function()
		if _e_3c3d_1(offset1, length1) then
			local char1
			char1 = _echarAt1(str1, offset1)
			local _temp
			local r_861
			r_861 = _e_3d_1(char1, "\n")
			if r_861 then
				_temp = r_861
			else
				local r_871
				r_871 = _e_3d_1(char1, "\t")
				if r_871 then
					_temp = r_871
				else
					_temp = _e_3d_1(char1, " ")
				end
			end
			if _temp then
			elseif _e_3d_1(char1, "(") then
				_eappendWith_21_1(struct1("tag", "open", "close", ")"))
			elseif _e_3d_1(char1, ")") then
				_eappendWith_21_1(struct1("tag", "close", "open", "("))
			elseif _e_3d_1(char1, "[") then
				_eappendWith_21_1(struct1("tag", "open", "close", "]"))
			elseif _e_3d_1(char1, "]") then
				_eappendWith_21_1(struct1("tag", "close", "open", "["))
			elseif _e_3d_1(char1, "{") then
				_eappendWith_21_1(struct1("tag", "open", "close", "}"))
			elseif _e_3d_1(char1, "}") then
				_eappendWith_21_1(struct1("tag", "close", "open", "{"))
			elseif _e_3d_1(char1, "'") then
				_eappend_21_1("quote")
			elseif _e_3d_1(char1, "`") then
				_eappend_21_1("quasiquote")
			elseif _e_3d_1(char1, ",") then
				if _e_3d_1(_echarAt1(str1, succ1(offset1)), "@") then
					local start8
					start8 = position2()
					_econsume_21_1()
					_eappend_21_1("unquote-splice", start8)
				else
					_eappend_21_1("unquote")
				end
			else
				local _temp
				local r_1151
				r_1151 = _ebetween_3f_1(char1, "0", "9")
				if r_1151 then
					_temp = r_1151
				else
					local r_1161
					r_1161 = _e_3d_1(char1, "-")
					if r_1161 then
						_temp = _ebetween_3f_1(_echarAt1(str1, succ1(offset1)), "0", "9")
					else
						_temp = r_1161
					end
				end
				if _temp then
					local start9
					start9 = position2()
					local r_1171
					r_1171 = nil
					r_1171 = (function()
						if find1(_echarAt1(str1, succ1(offset1)), "[0-9.e+-]") then
							_econsume_21_1()
							return r_1171()
						else
						end
					end);
					r_1171()
					_eappend_21_1("number", start9)
				elseif _e_3d_1(char1, "\"") then
					local start10
					start10 = position2()
					_econsume_21_1()
					char1 = _echarAt1(str1, offset1)
					local r_1181
					r_1181 = nil
					r_1181 = (function()
						if _e_2f3d_1(char1, "\"") then
							local _temp
							local r_1191
							r_1191 = _e_3d_1(char1, nil)
							if r_1191 then
								_temp = r_1191
							else
								_temp = _e_3d_1(char1, "")
							end
							if _temp then
								_eprintError_21_1("Expected '\"', got eof")
								local start11, finish6
								start11 = range3(start10)
								finish6 = range3(position2())
								_eputTrace_21_1(struct1("range", finish6))
								_eputLines_21_1(false, start11, "string started here", finish6, "end of file here")
								fail1("Lexing failed")
							elseif _e_3d_1(char1, "\\") then
								_econsume_21_1()
							else
							end
							_econsume_21_1()
							char1 = _echarAt1(str1, offset1)
							return r_1181()
						else
						end
					end);
					r_1181()
					_eappend_21_1("string", start10)
				elseif _e_3d_1(char1, ";") then
					local r_1201
					r_1201 = nil
					r_1201 = (function()
						local _temp
						local r_1211
						r_1211 = _e_3c3d_1(offset1, length1)
						if r_1211 then
							_temp = _e_2f3d_1(_echarAt1(str1, succ1(offset1)), "\n")
						else
							_temp = r_1211
						end
						if _temp then
							_econsume_21_1()
							return r_1201()
						else
						end
					end);
					r_1201()
				else
					local start12, tag3
					start12 = position2()
					if _e_3d_1(char1, ":") then
						tag3 = "key"
					else
						tag3 = "symbol"
					end
					char1 = _echarAt1(str1, succ1(offset1))
					local r_1221
					r_1221 = nil
					r_1221 = (function()
						local _temp
						local r_1231
						r_1231 = _e_2f3d_1(char1, "\n")
						if r_1231 then
							local r_1241
							r_1241 = _e_2f3d_1(char1, " ")
							if r_1241 then
								local r_1251
								r_1251 = _e_2f3d_1(char1, "\t")
								if r_1251 then
									local r_1261
									r_1261 = _e_2f3d_1(char1, "(")
									if r_1261 then
										local r_1271
										r_1271 = _e_2f3d_1(char1, ")")
										if r_1271 then
											local r_1281
											r_1281 = _e_2f3d_1(char1, "[")
											if r_1281 then
												local r_1291
												r_1291 = _e_2f3d_1(char1, "]")
												if r_1291 then
													local r_1301
													r_1301 = _e_2f3d_1(char1, "{")
													if r_1301 then
														local r_1311
														r_1311 = _e_2f3d_1(char1, "}")
														if r_1311 then
															_temp = _e_2f3d_1(char1, "")
														else
															_temp = r_1311
														end
													else
														_temp = r_1301
													end
												else
													_temp = r_1291
												end
											else
												_temp = r_1281
											end
										else
											_temp = r_1271
										end
									else
										_temp = r_1261
									end
								else
									_temp = r_1251
								end
							else
								_temp = r_1241
							end
						else
							_temp = r_1231
						end
						if _temp then
							_econsume_21_1()
							char1 = _echarAt1(str1, succ1(offset1))
							return r_1221()
						else
						end
					end);
					r_1221()
					_eappend_21_1(tag3, start12)
				end
			end
			_econsume_21_1()
			return r_851()
		else
		end
	end);
	r_851()
	_eappend_21_1("eof")
	return out4
end);
parse1 = (function(toks1)
	local index1
	index1 = 1
	local head1
	head1 = {tag = "list", n = 0}
	local stack1
	stack1 = {tag = "list", n = 0}
	local _eappend_21_2
	_eappend_21_2 = (function(node5)
		local next1
		next1 = {tag = "list", n = 0}
		_epushCdr_21_1(head1, node5)
		return _esetIdx_21_1(node5, "parent", head1)
	end);
	local _epush_21_1
	_epush_21_1 = (function()
		local next2
		next2 = {tag = "list", n = 0}
		_epushCdr_21_1(stack1, head1)
		_eappend_21_2(next2)
		head1 = next2
		return nil
	end);
	local _epop_21_1
	_epop_21_1 = (function()
		_esetIdx_21_1(head1, "open", nil)
		_esetIdx_21_1(head1, "close", nil)
		_esetIdx_21_1(head1, "auto-close", nil)
		head1 = last1(stack1)
		return _epopLast_21_1(stack1)
	end);
	local r_891
	r_891 = toks1
	local r_921
	r_921 = _e_23_2(r_891)
	local r_931
	r_931 = 1
	local r_901
	r_901 = nil
	r_901 = (function(r_911)
		local _temp
		if _e_3c_1(0, 1) then
			_temp = _e_3c3d_1(r_911, r_921)
		else
			_temp = _e_3e3d_1(r_911, r_921)
		end
		if _temp then
			local r_881
			r_881 = r_911
			local tok1
			tok1 = _egetIdx1(r_891, r_881)
			local tag4
			tag4 = _egetIdx1(tok1, "tag")
			local _eautoClose1
			_eautoClose1 = false
			local _temp
			local r_941
			r_941 = _e_3d_1(tag4, "string")
			if r_941 then
				_temp = r_941
			else
				local r_951
				r_951 = _e_3d_1(tag4, "number")
				if r_951 then
					_temp = r_951
				else
					local r_961
					r_961 = _e_3d_1(tag4, "symbol")
					if r_961 then
						_temp = r_961
					else
						_temp = _e_3d_1(tag4, "key")
					end
				end
			end
			if _temp then
				_eappend_21_2(tok1)
			elseif _e_3d_1(tag4, "open") then
				local previous3
				previous3 = last1(head1)
				local _temp
				local r_971
				r_971 = previous3
				if r_971 then
					local r_981
					r_981 = _egetIdx1(head1, "range")
					if r_981 then
						_temp = _e_2f3d_1(_egetIdx1(_egetIdx1(_egetIdx1(previous3, "range"), "start"), "line"), _egetIdx1(_egetIdx1(_egetIdx1(head1, "range"), "start"), "line"))
					else
						_temp = r_981
					end
				else
					_temp = r_971
				end
				if _temp then
					local _eprevPos1, _etokPos1
					_eprevPos1 = _egetIdx1(previous3, "range")
					_etokPos1 = _egetIdx1(tok1, "range")
					local _temp
					local r_1341
					r_1341 = _e_2f3d_1(_egetIdx1(_egetIdx1(_eprevPos1, "start"), "column"), _egetIdx1(_egetIdx1(_etokPos1, "start"), "column"))
					if r_1341 then
						_temp = _e_2f3d_1(_egetIdx1(_egetIdx1(_eprevPos1, "start"), "line"), _egetIdx1(_egetIdx1(_etokPos1, "start"), "line"))
					else
						_temp = r_1341
					end
					if _temp then
						_eprintWarning_21_1("Different indent compared with previous expressions.")
						_eputTrace_21_1(tok1)
						_eputExplain_21_1("You should try to maintain consistent indentation across a program,", "try to ensure all expressions are lined up.", "If this looks OK to you, check you're not missing a closing ')'.")
						_eputLines_21_1(false, _eprevPos1, "", _etokPos1, "")
					else
					end
				else
				end
				_epush_21_1()
				_esetIdx_21_1(head1, "open", _egetIdx1(tok1, "contents"))
				_esetIdx_21_1(head1, "close", _egetIdx1(tok1, "close"))
				_esetIdx_21_1(head1, "range", struct1("start", _egetIdx1(_egetIdx1(tok1, "range"), "start"), "name", _egetIdx1(_egetIdx1(tok1, "range"), "name"), "lines", _egetIdx1(_egetIdx1(tok1, "range"), "lines")))
			elseif _e_3d_1(tag4, "close") then
				if _enil_3f_1(stack1) then
					_eerrorPositions_21_1(tok1, format2("'%s' without matching '%s'", _egetIdx1(tok1, "contents"), _egetIdx1(tok1, "open")))
				elseif _egetIdx1(head1, "auto-close") then
					_eprintError_21_1(format2("'%s' without matching '%s' inside quote", _egetIdx1(tok1, "contents"), _egetIdx1(tok1, "open")))
					_eputTrace_21_1(tok1)
					_eputLines_21_1(false, _egetIdx1(head1, "range"), "quote opened here", _egetIdx1(tok1, "range"), "attempting to close here")
					fail1("Parsing failed")
				elseif _e_2f3d_1(_egetIdx1(head1, "close"), _egetIdx1(tok1, "contents")) then
					_eprintError_21_1(format2("Expected '%s', got '%s'", _egetIdx1(head1, "close"), _egetIdx1(tok1, "contents")))
					_eputTrace_21_1(tok1)
					_eputLines_21_1(false, _egetIdx1(head1, "range"), format2("block opened with '%s'", _egetIdx1(head1, "open")), _egetIdx1(tok1, "range"), format2("'%s' used here", _egetIdx1(tok1, "contents")))
					fail1("Parsing failed")
				else
					_esetIdx_21_1(_egetIdx1(head1, "range"), "finish", _egetIdx1(_egetIdx1(tok1, "range"), "finish"))
					_epop_21_1()
				end
			else
				local _temp
				local r_1351
				r_1351 = _e_3d_1(tag4, "quote")
				if r_1351 then
					_temp = r_1351
				else
					local r_1361
					r_1361 = _e_3d_1(tag4, "unquote")
					if r_1361 then
						_temp = r_1361
					else
						local r_1371
						r_1371 = _e_3d_1(tag4, "quasiquote")
						if r_1371 then
							_temp = r_1371
						else
							_temp = _e_3d_1(tag4, "unquote-splice")
						end
					end
				end
				if _temp then
					_epush_21_1()
					_esetIdx_21_1(head1, "range", struct1("start", _egetIdx1(_egetIdx1(tok1, "range"), "start"), "name", _egetIdx1(_egetIdx1(tok1, "range"), "name"), "lines", _egetIdx1(_egetIdx1(tok1, "range"), "lines")))
					_eappend_21_2(struct1("tag", "symbol", "contents", tag4, "range", _egetIdx1(tok1, "range")))
					_eautoClose1 = true
					_esetIdx_21_1(head1, "auto-close", true)
				elseif _e_3d_1(tag4, "eof") then
					if _e_2f3d_1(0, _e_23_2(stack1)) then
						_eprintError_21_1("Expected ')', got eof")
						_eputTrace_21_1(tok1)
						_eputLines_21_1(false, _egetIdx1(head1, "range"), "block opened here", _egetIdx1(tok1, "range"), "end of file here")
						fail1("Parsing failed")
					else
					end
				else
					_eerror_21_1(_e_2e2e_1("Unsupported type", tag4))
				end
			end
			if _eautoClose1 then
			else
				local r_1381
				r_1381 = nil
				r_1381 = (function()
					if _egetIdx1(head1, "auto-close") then
						if _enil_3f_1(stack1) then
							_eerrorPositions_21_1(tok1, format2("'%s' without matching '%s'", _egetIdx1(tok1, "contents"), _egetIdx1(tok1, "open")))
							fail1("Parsing failed")
						else
						end
						_esetIdx_21_1(_egetIdx1(head1, "range"), "finish", _egetIdx1(_egetIdx1(tok1, "range"), "finish"))
						_epop_21_1()
						return r_1381()
					else
					end
				end);
				r_1381()
			end
			return r_901(_e_2b_1(r_911, r_931))
		else
		end
	end);
	r_901(1)
	return head1
end);
return struct1("lex", lex1, "parse", parse1)
