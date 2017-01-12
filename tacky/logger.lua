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
_ekey_63_1 = (function(x6)
	return _e_61__61_1(type1(x6), "key")
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
	local r_191
	r_191 = type1(idx1)
	if _e_126__61_1(r_191, "number") then
		_eerror_33_1(format1("bad argment %s (expected %s, got %s)", "idx", "number", r_191), 2)
	else
	end
	return _eget_45_idx1(li4, idx1)
end);
_e_35_2 = (function(li6)
	local r_71
	r_71 = type1(li6)
	if _e_126__61_1(r_71, "list") then
		_eerror_33_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_71), 2)
	else
	end
	return _e_35_1(li6)
end);
car2 = (function(li3)
	return nth1(li3, 1)
end);
_epush_45_cdr_33_1 = (function(li9, val2)
	local r_101
	r_101 = type1(li9)
	if _e_126__61_1(r_101, "list") then
		_eerror_33_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_101), 2)
	else
	end
	local len1
	len1 = _e_43_1(_e_35_1(li9), 1)
	_eset_45_idx_33_1(li9, "n", len1)
	_eset_45_idx_33_1(li9, len1, val2)
	return li9
end);
_enil_63_1 = (function(li5)
	return _e_61__61_1(_e_35_2(li5), 0)
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
_e_46__46_1 = (function(...)
	local args3 = table.pack(...) args3.tag = "list"
	return concat1(args3)
end);
split1 = (function(text1, pattern1, limit1)
	local out2, loop1, start3
	out2 = {tag = "list", n = 0}
	loop1 = true
	start3 = 1
	local r_731
	r_731 = nil
	r_731 = (function()
		if loop1 then
			local pos1
			pos1 = find1(text1, pattern1, start3)
			if (function(r_741)
				if r_741 then
					return r_741
				else
					local r_751
					r_751 = limit1
					if r_751 then
						return _e_62__61_1(_e_35_1(out2), limit1)
					else
						return r_751
					end
				end
			end)(_e_61__61_1("nil", _etype_35_1(pos1))) then
				loop1 = false
				_epush_45_cdr_33_1(out2, sub1(text1, start3, _e_35_s1(text1)))
				start3 = _e_43_1(_e_35_s1(text1), 1)
			else
				_epush_45_cdr_33_1(out2, sub1(text1, start3, _e_45_1(car1(pos1), 1)))
				start3 = _e_43_1(cadr1(pos1), 1)
			end
			return r_731()
		else
		end
	end);
	r_731()
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
	local r_711
	r_711 = _e_35_1(keys3)
	local r_721
	r_721 = 2
	local r_691
	r_691 = nil
	r_691 = (function(r_701)
		local _temp
		if _e_60_1(0, 2) then
			_temp = _e_60__61_1(r_701, r_711)
		else
			_temp = _e_62__61_1(r_701, r_711)
		end
		if _temp then
			local i3
			i3 = r_701
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
			return r_691(_e_43_1(r_701, r_721))
		else
		end
	end);
	r_691(1)
	return out3
end);
fail1 = (function(msg1)
	return _eerror_33_1(msg1, 0)
end);
_e_47__61_1 = (function(x7, y1)
	return _e_126__61_1(x7, y1)
end);
_e_61_1 = (function(x8, y2)
	return _e_61__61_1(x8, y2)
end);
succ1 = (function(x9)
	return _e_43_1(1, x9)
end);
pred1 = (function(x10)
	return _e_45_1(x10, 1)
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
_eformat_45_position1 = (function(pos2)
	return _e_46__46_1(_eget_45_idx1(pos2, "line"), ":", _eget_45_idx1(pos2, "column"))
end);
_eformat_45_range1 = (function(range1)
	if _eget_45_idx1(range1, "finish") then
		return format2("%s %s-%s", _eget_45_idx1(range1, "name"), _eformat_45_position1(_eget_45_idx1(range1, "start")), _eformat_45_position1(_eget_45_idx1(range1, "finish")))
	else
		return format2("%s %s", _eget_45_idx1(range1, "name"), _eformat_45_position1(_eget_45_idx1(range1, "start")))
	end
end);
_eformat_45_node1 = (function(node1)
	if (function(r_831)
		if r_831 then
			return _eget_45_idx1(node1, "contents")
		else
			return r_831
		end
	end)(_eget_45_idx1(node1, "range")) then
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
	local r_841
	r_841 = nil
	r_841 = (function()
		if (function(r_851)
			if r_851 then
				return _e_33_1(result1)
			else
				return r_851
			end
		end)(node2) then
			result1 = _eget_45_idx1(node2, "range")
			node2 = _eget_45_idx1(node2, "parent")
			return r_841()
		else
		end
	end);
	r_841()
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
	local r_891
	r_891 = _e_35_2(entries1)
	local r_901
	r_901 = 2
	local r_871
	r_871 = nil
	r_871 = (function(r_881)
		local _temp
		if _e_60_1(0, 2) then
			_temp = _e_60__61_1(r_881, r_891)
		else
			_temp = _e_62__61_1(r_881, r_891)
		end
		if _temp then
			local i4
			i4 = r_881
			local position1, message1
			position1 = _eget_45_idx1(entries1, i4)
			message1 = _eget_45_idx1(entries1, succ1(i4))
			if (function(r_911)
				if r_911 then
					return _e_62_1(_e_45_1(_eget_45_idx1(_eget_45_idx1(position1, "start"), "line"), previous1), 2)
				else
					return r_911
				end
			end)(_e_47__61_1(previous1, -1)) then
				_eprint_33_1(" \27[92m...\27[0m")
			else
			end
			previous1 = _eget_45_idx1(_eget_45_idx1(position1, "start"), "line")
			_eprint_33_1(format2(code1, _enumber_45__62_string1(_eget_45_idx1(_eget_45_idx1(position1, "start"), "line")), _eget_45_idx1(_eget_45_idx1(position1, "lines"), _eget_45_idx1(_eget_45_idx1(position1, "start"), "line"))))
			local pointer1
			if _e_33_1(range2) then
				pointer1 = "^"
			elseif (function(r_981)
				if r_981 then
					return _e_61_1(_eget_45_idx1(_eget_45_idx1(position1, "start"), "line"), _eget_45_idx1(_eget_45_idx1(position1, "finish"), "line"))
				else
					return r_981
				end
			end)(_eget_45_idx1(position1, "finish")) then
				pointer1 = rep1("^", _e_45_1(_eget_45_idx1(_eget_45_idx1(position1, "finish"), "column"), _eget_45_idx1(_eget_45_idx1(position1, "start"), "column"), -1))
			else
				pointer1 = "^..."
			end
			_eprint_33_1(format2(code1, "", _e_46__46_1(rep1(" ", _e_45_1(_eget_45_idx1(_eget_45_idx1(position1, "start"), "column"), 1)), pointer1, " ", message1)))
			return r_871(_e_43_1(r_881, r_901))
		else
		end
	end);
	return r_871(1)
end);
_eput_45_trace_33_1 = (function(node3)
	local previous2
	previous2 = nil
	local r_861
	r_861 = nil
	r_861 = (function()
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
			return r_861()
		else
		end
	end);
	return r_861()
end);
_eput_45_explain_33_1 = (function(...)
	local lines3 = table.pack(...) lines3.tag = "list"
	if _eget_45_idx1(_eshow_45_explain1, "value") then
		local r_931
		r_931 = lines3
		local r_961
		r_961 = _e_35_2(r_931)
		local r_971
		r_971 = 1
		local r_941
		r_941 = nil
		r_941 = (function(r_951)
			local _temp
			if _e_60_1(0, 1) then
				_temp = _e_60__61_1(r_951, r_961)
			else
				_temp = _e_62__61_1(r_951, r_961)
			end
			if _temp then
				local r_921
				r_921 = r_951
				local line1
				line1 = _eget_45_idx1(r_931, r_921)
				_eprint_33_1(_e_46__46_1("  ", line1))
				return r_941(_e_43_1(r_951, r_971))
			else
			end
		end);
		return r_941(1)
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
return struct1("formatPosition", _eformat_45_position1, "formatRange", _eformat_45_range1, "formatNode", _eformat_45_node1, "putLines", _eput_45_lines_33_1, "putTrace", _eput_45_trace_33_1, "putInfo", _eput_45_explain_33_1, "getSource", _eget_45_source1, "printWarning", _eprint_45_warning_33_1, "printError", _eprint_45_error_33_1, "printVerbose", _eprint_45_verbose_33_1, "printDebug", _eprint_45_debug_33_1, "errorPositions", _eerror_45_positions_33_1, "setVerbosity", _eset_45_verbosity_33_1, "setExplain", _eset_45_explain_33_1)
