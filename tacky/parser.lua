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

_e_61__61_1 = _libs["=="]
_e_126__61_1 = _libs["~="]
_e_60_1 = _libs["<"]
_e_60__61_1 = _libs["<="]
_e_62_1 = _libs[">"]
_e_62__61_1 = _libs[">="]
_e_43_1 = _libs["+"]
_e_45_1 = _libs["-"]
_e_37_1 = _libs["%"]
_eget_45_idx1 = _libs["get-idx"]
_eset_45_idx_33_1 = _libs["set-idx!"]
format1 = _libs["format"]
_eprint_33_1 = _libs["print!"]
_eerror_33_1 = _libs["error!"]
_etype_35_1 = _libs["type#"]
_eempty_45_struct1 = _libs["empty-struct"]
_enumber_45__62_string1 = _libs["number->string"]
_e_35_1 = (function(xs1)
	return _eget_45_idx1(xs1, "n")
end);
car1 = (function(xs2)
	return _eget_45_idx1(xs2, 1)
end);
_e_33_1 = (function(expr1)
	if expr1 then
		return false
	else
		return true
	end
end);
_ekey_63_1 = (function(x7)
	return _e_61__61_1(type1(x7), "key")
end);
type1 = (function(val1)
	local ty2
	ty2 = _etype_35_1(val1)
	if _e_61__61_1(ty2, "table") then
		local tag1
		tag1 = _eget_45_idx1(val1, "tag")
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
	if _e_126__61_1(r_51, "list") then
		_eerror_33_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_51), 2)
	else
	end
	local r_201
	r_201 = type1(idx1)
	if _e_126__61_1(r_201, "number") then
		_eerror_33_1(format1("bad argment %s (expected %s, got %s)", "idx", "number", r_201), 2)
	else
	end
	return _eget_45_idx1(li4, idx1)
end);
_e_35_2 = (function(li6)
	local r_81
	r_81 = type1(li6)
	if _e_126__61_1(r_81, "list") then
		_eerror_33_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_81), 2)
	else
	end
	return _e_35_1(li6)
end);
car2 = (function(li3)
	return nth1(li3, 1)
end);
_epush_45_cdr_33_1 = (function(li9, val2)
	local r_111
	r_111 = type1(li9)
	if _e_126__61_1(r_111, "list") then
		_eerror_33_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_111), 2)
	else
	end
	local len1
	len1 = _e_43_1(_e_35_1(li9), 1)
	_eset_45_idx_33_1(li9, "n", len1)
	_eset_45_idx_33_1(li9, len1, val2)
	return li9
end);
_epop_45_last_33_1 = (function(li10)
	local r_121
	r_121 = type1(li10)
	if _e_126__61_1(r_121, "list") then
		_eerror_33_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_121), 2)
	else
	end
	_eset_45_idx_33_1(li10, _e_35_1(li10), nil)
	_eset_45_idx_33_1(li10, "n", _e_45_1(_e_35_1(li10), 1))
	return li10
end);
_enil_63_1 = (function(li5)
	return _e_61__61_1(_e_35_2(li5), 0)
end);
last1 = (function(xs6)
	return nth1(xs6, _e_35_2(xs6))
end);
cadr1 = (function(x1)
	return nth1(x1, 2)
end);
concat1 = _libs["concat"]
find1 = _libs["find"]
format2 = _libs["format"]
rep1 = _libs["rep"]
sub1 = _libs["sub"]
_e_35_s1 = _libs["#s"]
_echar_45_at1 = (function(text1, pos1)
	return sub1(text1, pos1, pos1)
end);
_e_46__46_1 = (function(...)
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
			r_761 = _e_61__61_1("nil", _etype_35_1(pos2))
			if r_761 then
				_temp = r_761
			else
				local r_771
				r_771 = limit1
				if r_771 then
					_temp = _e_62__61_1(_e_35_1(out2), limit1)
				else
					_temp = r_771
				end
			end
			if _temp then
				loop1 = false
				_epush_45_cdr_33_1(out2, sub1(text2, start3, _e_35_s1(text2)))
				start3 = _e_43_1(_e_35_s1(text2), 1)
			else
				_epush_45_cdr_33_1(out2, sub1(text2, start3, _e_45_1(car1(pos2), 1)))
				start3 = _e_43_1(cadr1(pos2), 1)
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
	if _e_61__61_1(_e_37_1(_e_35_2(keys3), 1), 1) then
		_eerror_33_1("Expected an even number of arguments to struct", 2)
	else
	end
	local contents1, out3
	contents1 = (function(key3)
		return sub1(_eget_45_idx1(key3, "contents"), 2)
	end);
	out3 = _eempty_45_struct1()
	local r_731
	r_731 = _e_35_1(keys3)
	local r_741
	r_741 = 2
	local r_711
	r_711 = nil
	r_711 = (function(r_721)
		local _temp
		if _e_60_1(0, 2) then
			_temp = _e_60__61_1(r_721, r_731)
		else
			_temp = _e_62__61_1(r_721, r_731)
		end
		if _temp then
			local i3
			i3 = r_721
			local key4, val3
			key4 = _eget_45_idx1(keys3, i3)
			val3 = _eget_45_idx1(keys3, _e_43_1(1, i3))
			_eset_45_idx_33_1(out3, (function()
				if _ekey_63_1(key4) then
					return contents1(key4)
				else
					return key4
				end
			end)(), val3)
			return r_711(_e_43_1(r_721, r_741))
		else
		end
	end);
	r_711(1)
	return out3
end);
fail1 = (function(msg1)
	return _eerror_33_1(msg1, 0)
end);
_ebetween_63_1 = (function(val4, min1, max1)
	local r_841
	r_841 = _e_62__61_1(val4, min1)
	if r_841 then
		return _e_60__61_1(val4, max1)
	else
		return r_841
	end
end);
_e_47__61_1 = (function(x8, y1)
	return _e_126__61_1(x8, y1)
end);
_e_61_1 = (function(x9, y2)
	return _e_61__61_1(x9, y2)
end);
succ1 = (function(x10)
	return _e_43_1(1, x10)
end);
pred1 = (function(x11)
	return _e_45_1(x11, 1)
end);
verbosity1 = struct1("value", 0)
_eset_45_verbosity_33_1 = (function(level1)
	return _eset_45_idx_33_1(verbosity1, "value", level1)
end);
_eshow_45_explain1 = struct1("value", false)
_eset_45_explain_33_1 = (function(value2)
	return _eset_45_idx_33_1(_eshow_45_explain1, "value", value2)
end);
colored1 = (function(col1, msg2)
	return _e_46__46_1("\27[", col1, "m", msg2, "\27[0m")
end);
_eprint_45_error_33_1 = (function(msg3)
	local lines1
	lines1 = split1(msg3, "\n", 1)
	_eprint_33_1(colored1(31, _e_46__46_1("[ERROR] ", car2(lines1))))
	if cadr1(lines1) then
		return _eprint_33_1(cadr1(lines1))
	else
	end
end);
_eprint_45_warning_33_1 = (function(msg4)
	local lines2
	lines2 = split1(msg4, "\n", 1)
	_eprint_33_1(colored1(33, _e_46__46_1("[WARN] ", car2(lines2))))
	if cadr1(lines2) then
		return _eprint_33_1(cadr1(lines2))
	else
	end
end);
_eprint_45_verbose_33_1 = (function(msg5)
	if _e_62_1(_eget_45_idx1(verbosity1, "value"), 0) then
		return _eprint_33_1(_e_46__46_1("[VERBOSE] ", msg5))
	else
	end
end);
_eprint_45_debug_33_1 = (function(msg6)
	if _e_62_1(_eget_45_idx1(verbosity1, "value"), 1) then
		return _eprint_33_1(_e_46__46_1("[DEBUG] ", msg6))
	else
	end
end);
_eformat_45_position1 = (function(pos3)
	return _e_46__46_1(_eget_45_idx1(pos3, "line"), ":", _eget_45_idx1(pos3, "column"))
end);
_eformat_45_range1 = (function(range1)
	if _eget_45_idx1(range1, "finish") then
		return format2("%s %s-%s", _eget_45_idx1(range1, "name"), _eformat_45_position1(_eget_45_idx1(range1, "start")), _eformat_45_position1(_eget_45_idx1(range1, "finish")))
	else
		return format2("%s %s", _eget_45_idx1(range1, "name"), _eformat_45_position1(_eget_45_idx1(range1, "start")))
	end
end);
_eformat_45_node1 = (function(node1)
	local _temp
	local r_991
	r_991 = _eget_45_idx1(node1, "range")
	if r_991 then
		_temp = _eget_45_idx1(node1, "contents")
	else
		_temp = r_991
	end
	if _temp then
		return format2("%s (%q)", _eformat_45_range1(_eget_45_idx1(node1, "range")), _eget_45_idx1(node1, "contents"))
	elseif _eget_45_idx1(node1, "range") then
		return _eformat_45_range1(_eget_45_idx1(node1, "range"))
	elseif _eget_45_idx1(node1, "macro") then
		local macro1
		macro1 = _eget_45_idx1(node1, "macro")
		return format2("macro expansion of %s (%s)", _eget_45_idx1(_eget_45_idx1(macro1, "var"), "name"), _eformat_45_node1(_eget_45_idx1(macro1, "node")))
	else
		return "?"
	end
end);
_eget_45_source1 = (function(node2)
	local result1
	result1 = nil
	local r_1001
	r_1001 = nil
	r_1001 = (function()
		local _temp
		local r_1011
		r_1011 = node2
		if r_1011 then
			_temp = _e_33_1(result1)
		else
			_temp = r_1011
		end
		if _temp then
			result1 = _eget_45_idx1(node2, "range")
			node2 = _eget_45_idx1(node2, "parent")
			return r_1001()
		else
		end
	end);
	r_1001()
	return result1
end);
_eput_45_lines_33_1 = (function(range2, ...)
	local entries1 = table.pack(...) entries1.tag = "list"
	if _enil_63_1(entries1) then
		_eerror_33_1("Positions cannot be empty")
	else
	end
	if _e_47__61_1(_e_37_1(_e_35_2(entries1), 2), 0) then
		_eerror_33_1(_e_46__46_1("Positions must be a multiple of 2, is ", _e_35_2(entries1)))
	else
	end
	local previous1
	previous1 = -1
	local _emax_45_line1
	_emax_45_line1 = _eget_45_idx1(_eget_45_idx1(_eget_45_idx1(entries1, pred1(_e_35_2(entries1))), "start"), "line")
	local code1
	code1 = _e_46__46_1("\27[92m %", _e_35_s1(_enumber_45__62_string1(_emax_45_line1)), "s |\27[0m %s")
	local r_1051
	r_1051 = _e_35_2(entries1)
	local r_1061
	r_1061 = 2
	local r_1031
	r_1031 = nil
	r_1031 = (function(r_1041)
		local _temp
		if _e_60_1(0, 2) then
			_temp = _e_60__61_1(r_1041, r_1051)
		else
			_temp = _e_62__61_1(r_1041, r_1051)
		end
		if _temp then
			local i4
			i4 = r_1041
			local position1, message1
			position1 = _eget_45_idx1(entries1, i4)
			message1 = _eget_45_idx1(entries1, succ1(i4))
			local _temp
			local r_1071
			r_1071 = _e_47__61_1(previous1, -1)
			if r_1071 then
				_temp = _e_62_1(_e_45_1(_eget_45_idx1(_eget_45_idx1(position1, "start"), "line"), previous1), 2)
			else
				_temp = r_1071
			end
			if _temp then
				_eprint_33_1(" \27[92m...\27[0m")
			else
			end
			previous1 = _eget_45_idx1(_eget_45_idx1(position1, "start"), "line")
			_eprint_33_1(format2(code1, _enumber_45__62_string1(_eget_45_idx1(_eget_45_idx1(position1, "start"), "line")), _eget_45_idx1(_eget_45_idx1(position1, "lines"), _eget_45_idx1(_eget_45_idx1(position1, "start"), "line"))))
			local pointer1
			if _e_33_1(range2) then
				pointer1 = "^"
			else
				local _temp
				local r_1141
				r_1141 = _eget_45_idx1(position1, "finish")
				if r_1141 then
					_temp = _e_61_1(_eget_45_idx1(_eget_45_idx1(position1, "start"), "line"), _eget_45_idx1(_eget_45_idx1(position1, "finish"), "line"))
				else
					_temp = r_1141
				end
				if _temp then
					pointer1 = rep1("^", _e_45_1(_eget_45_idx1(_eget_45_idx1(position1, "finish"), "column"), _eget_45_idx1(_eget_45_idx1(position1, "start"), "column"), -1))
				else
					pointer1 = "^..."
				end
			end
			_eprint_33_1(format2(code1, "", _e_46__46_1(rep1(" ", _e_45_1(_eget_45_idx1(_eget_45_idx1(position1, "start"), "column"), 1)), pointer1, " ", message1)))
			return r_1031(_e_43_1(r_1041, r_1061))
		else
		end
	end);
	return r_1031(1)
end);
_eput_45_trace_33_1 = (function(node3)
	local previous2
	previous2 = nil
	local r_1021
	r_1021 = nil
	r_1021 = (function()
		if node3 then
			local formatted1
			formatted1 = _eformat_45_node1(node3)
			if _e_61_1(previous2, nil) then
				_eprint_33_1(colored1(96, _e_46__46_1("  => ", formatted1)))
			elseif _e_47__61_1(previous2, formatted1) then
				_eprint_33_1(_e_46__46_1("  in ", formatted1))
			else
				local _ = nil
			end
			previous2 = formatted1
			node3 = _eget_45_idx1(node3, "parent")
			return r_1021()
		else
		end
	end);
	return r_1021()
end);
_eput_45_explain_33_1 = (function(...)
	local lines3 = table.pack(...) lines3.tag = "list"
	if _eget_45_idx1(_eshow_45_explain1, "value") then
		local r_1091
		r_1091 = lines3
		local r_1121
		r_1121 = _e_35_2(r_1091)
		local r_1131
		r_1131 = 1
		local r_1101
		r_1101 = nil
		r_1101 = (function(r_1111)
			local _temp
			if _e_60_1(0, 1) then
				_temp = _e_60__61_1(r_1111, r_1121)
			else
				_temp = _e_62__61_1(r_1111, r_1121)
			end
			if _temp then
				local r_1081
				r_1081 = r_1111
				local line1
				line1 = _eget_45_idx1(r_1091, r_1081)
				_eprint_33_1(_e_46__46_1("  ", line1))
				return r_1101(_e_43_1(r_1111, r_1131))
			else
			end
		end);
		return r_1101(1)
	else
	end
end);
_eerror_45_positions_33_1 = (function(node4, msg7)
	_eprint_45_error_33_1(msg7)
	_eput_45_trace_33_1(node4)
	local source1
	source1 = _eget_45_source1(node4)
	if source1 then
		_eput_45_lines_33_1(true, source1, "")
	else
	end
	return fail1("An error occured")
end);
struct1("formatPosition", _eformat_45_position1, "formatRange", _eformat_45_range1, "formatNode", _eformat_45_node1, "putLines", _eput_45_lines_33_1, "putTrace", _eput_45_trace_33_1, "putInfo", _eput_45_explain_33_1, "getSource", _eget_45_source1, "printWarning", _eprint_45_warning_33_1, "printError", _eprint_45_error_33_1, "printVerbose", _eprint_45_verbose_33_1, "printDebug", _eprint_45_debug_33_1, "errorPositions", _eerror_45_positions_33_1, "setVerbosity", _eset_45_verbosity_33_1, "setExplain", _eset_45_explain_33_1)
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
	length1 = _e_35_s1(str1)
	local out4
	out4 = {tag = "list", n = 0}
	local _econsume_33_1
	_econsume_33_1 = (function()
		if _e_61_1(_echar_45_at1(str1, offset1), "\n") then
			line2 = _e_43_1(line2, 1)
			column1 = 1
		else
			column1 = _e_43_1(column1, 1)
		end
		offset1 = _e_43_1(offset1, 1)
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
	local _eappend_45_with_33_1
	_eappend_45_with_33_1 = (function(data1, start5, finish3)
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
		_eset_45_idx_33_1(data1, "range", range3(start6, finish4))
		_eset_45_idx_33_1(data1, "contents", sub1(str1, _eget_45_idx1(start6, "offset"), _eget_45_idx1(finish4, "offset")))
		return _epush_45_cdr_33_1(out4, data1)
	end);
	local _eappend_33_1
	_eappend_33_1 = (function(tag2, start7, finish5)
		return _eappend_45_with_33_1(struct1("tag", tag2), start7, finish5)
	end);
	local r_851
	r_851 = nil
	r_851 = (function()
		if _e_60__61_1(offset1, length1) then
			local char1
			char1 = _echar_45_at1(str1, offset1)
			local _temp
			local r_861
			r_861 = _e_61_1(char1, "\n")
			if r_861 then
				_temp = r_861
			else
				local r_871
				r_871 = _e_61_1(char1, "\t")
				if r_871 then
					_temp = r_871
				else
					_temp = _e_61_1(char1, " ")
				end
			end
			if _temp then
			elseif _e_61_1(char1, "(") then
				_eappend_45_with_33_1(struct1("tag", "open", "close", ")"))
			elseif _e_61_1(char1, ")") then
				_eappend_45_with_33_1(struct1("tag", "close", "open", "("))
			elseif _e_61_1(char1, "[") then
				_eappend_45_with_33_1(struct1("tag", "open", "close", "]"))
			elseif _e_61_1(char1, "]") then
				_eappend_45_with_33_1(struct1("tag", "close", "open", "["))
			elseif _e_61_1(char1, "{") then
				_eappend_45_with_33_1(struct1("tag", "open", "close", "}"))
			elseif _e_61_1(char1, "}") then
				_eappend_45_with_33_1(struct1("tag", "close", "open", "{"))
			elseif _e_61_1(char1, "'") then
				_eappend_33_1("quote")
			elseif _e_61_1(char1, "`") then
				_eappend_33_1("quasiquote")
			elseif _e_61_1(char1, ",") then
				if _e_61_1(_echar_45_at1(str1, succ1(offset1)), "@") then
					local start8
					start8 = position2()
					_econsume_33_1()
					_eappend_33_1("unquote-splice", start8)
				else
					_eappend_33_1("unquote")
				end
			else
				local _temp
				local r_1151
				r_1151 = _ebetween_63_1(char1, "0", "9")
				if r_1151 then
					_temp = r_1151
				else
					local r_1161
					r_1161 = _e_61_1(char1, "-")
					if r_1161 then
						_temp = _ebetween_63_1(_echar_45_at1(str1, succ1(offset1)), "0", "9")
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
						if find1(_echar_45_at1(str1, succ1(offset1)), "[0-9.e+-]") then
							_econsume_33_1()
							return r_1171()
						else
						end
					end);
					r_1171()
					_eappend_33_1("number", start9)
				elseif _e_61_1(char1, "\"") then
					local start10
					start10 = position2()
					_econsume_33_1()
					char1 = _echar_45_at1(str1, offset1)
					local r_1181
					r_1181 = nil
					r_1181 = (function()
						if _e_47__61_1(char1, "\"") then
							local _temp
							local r_1191
							r_1191 = _e_61_1(char1, nil)
							if r_1191 then
								_temp = r_1191
							else
								_temp = _e_61_1(char1, "")
							end
							if _temp then
								_eprint_45_error_33_1("Expected '\"', got eof")
								local start11, finish6
								start11 = range3(start10)
								finish6 = range3(position2())
								_eput_45_trace_33_1(struct1("range", finish6))
								_eput_45_lines_33_1(false, start11, "string started here", finish6, "end of file here")
								fail1("Lexing failed")
							elseif _e_61_1(char1, "\\") then
								_econsume_33_1()
							else
							end
							_econsume_33_1()
							char1 = _echar_45_at1(str1, offset1)
							return r_1181()
						else
						end
					end);
					r_1181()
					_eappend_33_1("string", start10)
				elseif _e_61_1(char1, ";") then
					local r_1201
					r_1201 = nil
					r_1201 = (function()
						local _temp
						local r_1211
						r_1211 = _e_60__61_1(offset1, length1)
						if r_1211 then
							_temp = _e_47__61_1(_echar_45_at1(str1, succ1(offset1)), "\n")
						else
							_temp = r_1211
						end
						if _temp then
							_econsume_33_1()
							return r_1201()
						else
						end
					end);
					r_1201()
				else
					local start12, tag3
					start12 = position2()
					if _e_61_1(char1, ":") then
						tag3 = "key"
					else
						tag3 = "symbol"
					end
					char1 = _echar_45_at1(str1, succ1(offset1))
					local r_1221
					r_1221 = nil
					r_1221 = (function()
						local _temp
						local r_1231
						r_1231 = _e_47__61_1(char1, "\n")
						if r_1231 then
							local r_1241
							r_1241 = _e_47__61_1(char1, " ")
							if r_1241 then
								local r_1251
								r_1251 = _e_47__61_1(char1, "\t")
								if r_1251 then
									local r_1261
									r_1261 = _e_47__61_1(char1, "(")
									if r_1261 then
										local r_1271
										r_1271 = _e_47__61_1(char1, ")")
										if r_1271 then
											local r_1281
											r_1281 = _e_47__61_1(char1, "[")
											if r_1281 then
												local r_1291
												r_1291 = _e_47__61_1(char1, "]")
												if r_1291 then
													local r_1301
													r_1301 = _e_47__61_1(char1, "{")
													if r_1301 then
														local r_1311
														r_1311 = _e_47__61_1(char1, "}")
														if r_1311 then
															_temp = _e_47__61_1(char1, "")
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
							_econsume_33_1()
							char1 = _echar_45_at1(str1, succ1(offset1))
							return r_1221()
						else
						end
					end);
					r_1221()
					_eappend_33_1(tag3, start12)
				end
			end
			_econsume_33_1()
			return r_851()
		else
		end
	end);
	r_851()
	_eappend_33_1("eof")
	return out4
end);
parse1 = (function(toks1)
	local index1
	index1 = 1
	local head1
	head1 = {tag = "list", n = 0}
	local stack1
	stack1 = {tag = "list", n = 0}
	local _eappend_33_2
	_eappend_33_2 = (function(node5)
		local next1
		next1 = {tag = "list", n = 0}
		_epush_45_cdr_33_1(head1, node5)
		return _eset_45_idx_33_1(node5, "parent", head1)
	end);
	local _epush_33_1
	_epush_33_1 = (function()
		local next2
		next2 = {tag = "list", n = 0}
		_epush_45_cdr_33_1(stack1, head1)
		_eappend_33_2(next2)
		head1 = next2
		return nil
	end);
	local _epop_33_1
	_epop_33_1 = (function()
		_eset_45_idx_33_1(head1, "open", nil)
		_eset_45_idx_33_1(head1, "close", nil)
		_eset_45_idx_33_1(head1, "auto-close", nil)
		head1 = last1(stack1)
		return _epop_45_last_33_1(stack1)
	end);
	local r_891
	r_891 = toks1
	local r_921
	r_921 = _e_35_2(r_891)
	local r_931
	r_931 = 1
	local r_901
	r_901 = nil
	r_901 = (function(r_911)
		local _temp
		if _e_60_1(0, 1) then
			_temp = _e_60__61_1(r_911, r_921)
		else
			_temp = _e_62__61_1(r_911, r_921)
		end
		if _temp then
			local r_881
			r_881 = r_911
			local tok1
			tok1 = _eget_45_idx1(r_891, r_881)
			local tag4
			tag4 = _eget_45_idx1(tok1, "tag")
			local _eauto_45_close1
			_eauto_45_close1 = false
			local _temp
			local r_941
			r_941 = _e_61_1(tag4, "string")
			if r_941 then
				_temp = r_941
			else
				local r_951
				r_951 = _e_61_1(tag4, "number")
				if r_951 then
					_temp = r_951
				else
					local r_961
					r_961 = _e_61_1(tag4, "symbol")
					if r_961 then
						_temp = r_961
					else
						_temp = _e_61_1(tag4, "key")
					end
				end
			end
			if _temp then
				_eappend_33_2(tok1)
			elseif _e_61_1(tag4, "open") then
				local previous3
				previous3 = last1(head1)
				local _temp
				local r_971
				r_971 = previous3
				if r_971 then
					local r_981
					r_981 = _eget_45_idx1(head1, "range")
					if r_981 then
						_temp = _e_47__61_1(_eget_45_idx1(_eget_45_idx1(_eget_45_idx1(previous3, "range"), "start"), "line"), _eget_45_idx1(_eget_45_idx1(_eget_45_idx1(head1, "range"), "start"), "line"))
					else
						_temp = r_981
					end
				else
					_temp = r_971
				end
				if _temp then
					local _eprev_45_pos1, _etok_45_pos1
					_eprev_45_pos1 = _eget_45_idx1(previous3, "range")
					_etok_45_pos1 = _eget_45_idx1(tok1, "range")
					local _temp
					local r_1341
					r_1341 = _e_47__61_1(_eget_45_idx1(_eget_45_idx1(_eprev_45_pos1, "start"), "column"), _eget_45_idx1(_eget_45_idx1(_etok_45_pos1, "start"), "column"))
					if r_1341 then
						_temp = _e_47__61_1(_eget_45_idx1(_eget_45_idx1(_eprev_45_pos1, "start"), "line"), _eget_45_idx1(_eget_45_idx1(_etok_45_pos1, "start"), "line"))
					else
						_temp = r_1341
					end
					if _temp then
						_eprint_45_warning_33_1("Different indent compared with previous expressions.")
						_eput_45_trace_33_1(tok1)
						_eput_45_explain_33_1("You should try to maintain consistent indentation across a program,", "try to ensure all expressions are lined up.", "If this looks OK to you, check you're not missing a closing ')'.")
						_eput_45_lines_33_1(false, _eprev_45_pos1, "", _etok_45_pos1, "")
					else
					end
				else
				end
				_epush_33_1()
				_eset_45_idx_33_1(head1, "open", _eget_45_idx1(tok1, "contents"))
				_eset_45_idx_33_1(head1, "close", _eget_45_idx1(tok1, "close"))
				_eset_45_idx_33_1(head1, "range", struct1("start", _eget_45_idx1(_eget_45_idx1(tok1, "range"), "start"), "name", _eget_45_idx1(_eget_45_idx1(tok1, "range"), "name"), "lines", _eget_45_idx1(_eget_45_idx1(tok1, "range"), "lines")))
			elseif _e_61_1(tag4, "close") then
				if _enil_63_1(stack1) then
					_eerror_45_positions_33_1(tok1, format2("'%s' without matching '%s'", _eget_45_idx1(tok1, "contents"), _eget_45_idx1(tok1, "open")))
				elseif _eget_45_idx1(head1, "auto-close") then
					_eprint_45_error_33_1(format2("'%s' without matching '%s' inside quote", _eget_45_idx1(tok1, "contents"), _eget_45_idx1(tok1, "open")))
					_eput_45_trace_33_1(tok1)
					_eput_45_lines_33_1(false, _eget_45_idx1(head1, "range"), "quote opened here", _eget_45_idx1(tok1, "range"), "attempting to close here")
					fail1("Parsing failed")
				elseif _e_47__61_1(_eget_45_idx1(head1, "close"), _eget_45_idx1(tok1, "contents")) then
					_eprint_45_error_33_1(format2("Expected '%s', got '%s'", _eget_45_idx1(head1, "close"), _eget_45_idx1(tok1, "contents")))
					_eput_45_trace_33_1(tok1)
					_eput_45_lines_33_1(false, _eget_45_idx1(head1, "range"), format2("block opened with '%s'", _eget_45_idx1(head1, "open")), _eget_45_idx1(tok1, "range"), format2("'%s' used here", _eget_45_idx1(tok1, "contents")))
					fail1("Parsing failed")
				else
					_eset_45_idx_33_1(_eget_45_idx1(head1, "range"), "finish", _eget_45_idx1(_eget_45_idx1(tok1, "range"), "finish"))
					_epop_33_1()
				end
			else
				local _temp
				local r_1351
				r_1351 = _e_61_1(tag4, "quote")
				if r_1351 then
					_temp = r_1351
				else
					local r_1361
					r_1361 = _e_61_1(tag4, "unquote")
					if r_1361 then
						_temp = r_1361
					else
						local r_1371
						r_1371 = _e_61_1(tag4, "quasiquote")
						if r_1371 then
							_temp = r_1371
						else
							_temp = _e_61_1(tag4, "unquote-splice")
						end
					end
				end
				if _temp then
					_epush_33_1()
					_eset_45_idx_33_1(head1, "range", struct1("start", _eget_45_idx1(_eget_45_idx1(tok1, "range"), "start"), "name", _eget_45_idx1(_eget_45_idx1(tok1, "range"), "name"), "lines", _eget_45_idx1(_eget_45_idx1(tok1, "range"), "lines")))
					_eappend_33_2(struct1("tag", "symbol", "contents", tag4, "range", _eget_45_idx1(tok1, "range")))
					_eauto_45_close1 = true
					_eset_45_idx_33_1(head1, "auto-close", true)
				elseif _e_61_1(tag4, "eof") then
					if _e_47__61_1(0, _e_35_2(stack1)) then
						_eprint_45_error_33_1("Expected ')', got eof")
						_eput_45_trace_33_1(tok1)
						_eput_45_lines_33_1(false, _eget_45_idx1(head1, "range"), "block opened here", _eget_45_idx1(tok1, "range"), "end of file here")
						fail1("Parsing failed")
					else
					end
				else
					_eerror_33_1(_e_46__46_1("Unsupported type", tag4))
				end
			end
			if _eauto_45_close1 then
			else
				local r_1381
				r_1381 = nil
				r_1381 = (function()
					if _eget_45_idx1(head1, "auto-close") then
						if _enil_63_1(stack1) then
							_eerror_45_positions_33_1(tok1, format2("'%s' without matching '%s'", _eget_45_idx1(tok1, "contents"), _eget_45_idx1(tok1, "open")))
							fail1("Parsing failed")
						else
						end
						_eset_45_idx_33_1(_eget_45_idx1(head1, "range"), "finish", _eget_45_idx1(_eget_45_idx1(tok1, "range"), "finish"))
						_epop_33_1()
						return r_1381()
					else
					end
				end);
				r_1381()
			end
			return r_901(_e_43_1(r_911, r_931))
		else
		end
	end);
	r_901(1)
	return head1
end);
return struct1("lex", lex1, "parse", parse1)
