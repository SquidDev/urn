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
_e_46__46_1 = _libs[".."]
_eget_45_idx1 = _libs["get-idx"]
_eset_45_idx_33_1 = _libs["set-idx!"]
format1 = _libs["format"]
_eerror_33_1 = _libs["error!"]
_etype_35_1 = _libs["type#"]
_eempty_45_struct1 = _libs["empty-struct"]
_enumber_45__62_string1 = _libs["number->string"]
_e_35_1 = (function(xs1)
	return _eget_45_idx1(xs1, "n")
end);
_e_33_1 = (function(expr1)
	if expr1 then
		return false
	else
		return true
	end
end);
_ekey_63_1 = (function(x9)
	return _e_61__61_1(type1(x9), "key")
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
_enil_63_1 = (function(li5)
	return _e_61__61_1(_e_35_2(li5), 0)
end);
rep1 = _libs["rep"]
sub1 = _libs["sub"]
_e_35_s1 = _libs["#s"]
struct1 = (function(...)
	local keys3 = table.pack(...) keys3.tag = "list"
	if _e_61__61_1(_e_37_1(_e_35_2(keys3), 1), 1) then
		_eerror_33_1("Expected an even number of arguments to struct", 2)
	else
	end
	local contents1, out2
	contents1 = (function(key3)
		return sub1(_eget_45_idx1(key3, "contents"), 2)
	end);
	out2 = _eempty_45_struct1()
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
			_eset_45_idx_33_1(out2, (function()
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
	return out2
end);
fail1 = (function(msg1)
	return _eerror_33_1(msg1, 0)
end);
_e_61_1 = (function(x10, y1)
	return _e_61__61_1(x10, y1)
end);
succ1 = (function(x11)
	return _e_43_1(1, x11)
end);
pred1 = (function(x12)
	return _e_45_1(x12, 1)
end);
_eappend_33_1 = (function(writer1, text1)
	local r_971
	r_971 = type1(text1)
	if _e_126__61_1(r_971, "string") then
		_eerror_33_1(format1("bad argment %s (expected %s, got %s)", "text", "string", r_971), 2)
	else
	end
	if _eget_45_idx1(writer1, "tabs-pending") then
		_eset_45_idx_33_1(writer1, "tabs-pending", false)
		_epush_45_cdr_33_1(_eget_45_idx1(writer1, "out"), rep1("\t", _eget_45_idx1(writer1, "indent")))
	else
	end
	return _epush_45_cdr_33_1(_eget_45_idx1(writer1, "out"), text1)
end);
_eline_33_1 = (function(writer2, text2)
	if text2 then
		_eappend_33_1(writer2, text2)
	else
	end
	if _eget_45_idx1(writer2, "tabs-pending") then
	else
		_eset_45_idx_33_1(writer2, "tabs-pending", true)
		return _epush_45_cdr_33_1(_eget_45_idx1(writer2, "out"), "\n")
	end
end);
_eindent_33_1 = (function(writer3)
	return _eset_45_idx_33_1(writer3, "indent", succ1(_eget_45_idx1(writer3, "indent")))
end);
_eunindent_33_1 = (function(writer4)
	return _eset_45_idx_33_1(writer4, "indent", pred1(_eget_45_idx1(writer4, "indent")))
end);
_eestimate_45_length1 = (function(node1, max1)
	local tag2
	tag2 = _eget_45_idx1(node1, "tag")
	local _temp
	local r_851
	r_851 = _e_61_1(tag2, "string")
	if r_851 then
		_temp = r_851
	else
		local r_861
		r_861 = _e_61_1(tag2, "number")
		if r_861 then
			_temp = r_861
		else
			local r_871
			r_871 = _e_61_1(tag2, "symbol")
			if r_871 then
				_temp = r_871
			else
				_temp = _e_61_1(tag2, "key")
			end
		end
	end
	if _temp then
		return _e_35_s1(_enumber_45__62_string1(_eget_45_idx1(node1, "contents")))
	elseif _e_61_1(tag2, "list") then
		local sum1
		sum1 = 2
		local i4
		i4 = 1
		local r_1011
		r_1011 = nil
		r_1011 = (function()
			local _temp
			local r_1021
			r_1021 = _e_60__61_1(sum1, max1)
			if r_1021 then
				_temp = _e_60__61_1(i4, _e_35_2(node1))
			else
				_temp = r_1021
			end
			if _temp then
				sum1 = _e_43_1(sum1, _eestimate_45_length1(nth1(node1, i4), _e_45_1(max1, sum1)))
				if _e_62_1(i4, 1) then
					sum1 = _e_43_1(sum1, 1)
				else
				end
				i4 = _e_43_1(i4, 1)
				return r_1011()
			else
			end
		end);
		r_1011()
		return sum1
	else
		return fail1(_e_46__46_1("Unknown tag ", tag2))
	end
end);
expression1 = (function(node2, writer5)
	local tag3
	tag3 = _eget_45_idx1(node2, "tag")
	local _temp
	local r_881
	r_881 = _e_61_1(tag3, "string")
	if r_881 then
		_temp = r_881
	else
		local r_891
		r_891 = _e_61_1(tag3, "number")
		if r_891 then
			_temp = r_891
		else
			local r_901
			r_901 = _e_61_1(tag3, "symbol")
			if r_901 then
				_temp = r_901
			else
				_temp = _e_61_1(tag3, "key")
			end
		end
	end
	if _temp then
		return _eappend_33_1(writer5, _enumber_45__62_string1(_eget_45_idx1(node2, "contents")))
	elseif _e_61_1(tag3, "list") then
		_eappend_33_1(writer5, "(")
		if _enil_63_1(node2) then
			return _eappend_33_1(writer5, ")")
		else
			local newline1, max2
			newline1 = false
			max2 = _e_45_1(60, _eestimate_45_length1(car2(node2), 60))
			expression1(car2(node2), writer5)
			if _e_60__61_1(max2, 0) then
				newline1 = true
				_eindent_33_1(writer5)
			else
			end
			local r_1051
			r_1051 = _e_35_2(node2)
			local r_1061
			r_1061 = 1
			local r_1031
			r_1031 = nil
			r_1031 = (function(r_1041)
				local _temp
				if _e_60_1(0, 1) then
					_temp = _e_60__61_1(r_1041, r_1051)
				else
					_temp = _e_62__61_1(r_1041, r_1051)
				end
				if _temp then
					local i5
					i5 = r_1041
					local entry1
					entry1 = nth1(node2, i5)
					local _temp
					local r_1071
					r_1071 = _e_33_1(newline1)
					if r_1071 then
						_temp = _e_62_1(max2, 0)
					else
						_temp = r_1071
					end
					if _temp then
						max2 = _e_45_1(max2, _eestimate_45_length1(entry1, max2))
						if _e_60__61_1(max2, 0) then
							newline1 = true
							_eindent_33_1(writer5)
						else
						end
					else
					end
					if newline1 then
						_eline_33_1(writer5)
					else
						_eappend_33_1(writer5, " ")
					end
					expression1(entry1, writer5)
					return r_1031(_e_43_1(r_1041, r_1061))
				else
				end
			end);
			r_1031(2)
			if newline1 then
				_eunindent_33_1(writer5)
			else
			end
			return _eappend_33_1(writer5, ")")
		end
	else
		return fail1(_e_46__46_1("Unknown tag ", tag3))
	end
end);
block1 = (function(list1, writer6)
	local r_921
	r_921 = list1
	local r_951
	r_951 = _e_35_2(r_921)
	local r_961
	r_961 = 1
	local r_931
	r_931 = nil
	r_931 = (function(r_941)
		local _temp
		if _e_60_1(0, 1) then
			_temp = _e_60__61_1(r_941, r_951)
		else
			_temp = _e_62__61_1(r_941, r_951)
		end
		if _temp then
			local r_911
			r_911 = r_941
			local node3
			node3 = _eget_45_idx1(r_921, r_911)
			expression1(node3, writer6)
			_eline_33_1(writer6)
			return r_931(_e_43_1(r_941, r_961))
		else
		end
	end);
	return r_931(1)
end);
return struct1("expression", expression1, "block", block1)
