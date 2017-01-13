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
_2e2e_1 = _libs[".."]
getIdx1 = _libs["get-idx"]
setIdx_21_1 = _libs["set-idx!"]
format1 = _libs["format"]
error_21_1 = _libs["error!"]
type_23_1 = _libs["type#"]
emptyStruct1 = _libs["empty-struct"]
number_2d3e_string1 = _libs["number->string"]
_23_1 = (function(xs1)
	return xs1["n"]
end);
_21_1 = (function(expr1)
	if expr1 then
		return false
	else
		return true
	end
end);
key_3f_1 = (function(x9)
	return (type1(x9) == "key")
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
nil_3f_1 = (function(li6)
	return (_23_2(li6) == 0)
end);
rep1 = _libs["rep"]
sub1 = _libs["sub"]
_23_s1 = _libs["#s"]
struct1 = (function(...)
	local keys3 = table.pack(...) keys3.tag = "list"
	if ((_23_2(keys3) % 1) == 1) then
		error_21_1("Expected an even number of arguments to struct", 2)
	else
	end
	local contents1, out2
	contents1 = (function(key3)
		return sub1(key3["contents"], 2)
	end);
	out2 = {}
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
			out2[(function()
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
	return out2
end);
fail1 = (function(msg1)
	return error_21_1(msg1, 0)
end);
succ1 = (function(x10)
	return (1 + x10)
end);
pred1 = (function(x11)
	return (x11 - 1)
end);
append_21_1 = (function(writer1, text1)
	local r_1031
	r_1031 = type1(text1)
	if (r_1031 ~= "string") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "text", "string", r_1031), 2)
	else
	end
	if writer1["tabs-pending"] then
		writer1["tabs-pending"] = false
		pushCdr_21_1(writer1["out"], rep1("\t", writer1["indent"]))
	else
	end
	return pushCdr_21_1(writer1["out"], text1)
end);
line_21_1 = (function(writer2, text2)
	if text2 then
		append_21_1(writer2, text2)
	else
	end
	if writer2["tabs-pending"] then
	else
		writer2["tabs-pending"] = true
		return pushCdr_21_1(writer2["out"], "\n")
	end
end);
indent_21_1 = (function(writer3)
	writer3["indent"] = succ1(writer3["indent"])
	return nil
end);
unindent_21_1 = (function(writer4)
	writer4["indent"] = pred1(writer4["indent"])
	return nil
end);
estimateLength1 = (function(node1, max1)
	local tag2
	tag2 = node1["tag"]
	local _temp
	local r_911
	r_911 = (tag2 == "string")
	if r_911 then
		_temp = r_911
	else
		local r_921
		r_921 = (tag2 == "number")
		if r_921 then
			_temp = r_921
		else
			local r_931
			r_931 = (tag2 == "symbol")
			if r_931 then
				_temp = r_931
			else
				_temp = (tag2 == "key")
			end
		end
	end
	if _temp then
		return _23_s1(number_2d3e_string1(node1["contents"]))
	elseif (tag2 == "list") then
		local sum1
		sum1 = 2
		local i4
		i4 = 1
		local r_1071
		r_1071 = nil
		r_1071 = (function()
			local _temp
			local r_1081
			r_1081 = (sum1 <= max1)
			if r_1081 then
				_temp = (i4 <= _23_2(node1))
			else
				_temp = r_1081
			end
			if _temp then
				sum1 = (sum1 + estimateLength1(nth1(node1, i4), (max1 - sum1)))
				if (i4 > 1) then
					sum1 = (sum1 + 1)
				else
				end
				i4 = (i4 + 1)
				return r_1071()
			else
			end
		end);
		r_1071()
		return sum1
	else
		return fail1(("Unknown tag " .. tag2))
	end
end);
expression1 = (function(node2, writer5)
	local tag3
	tag3 = node2["tag"]
	local _temp
	local r_941
	r_941 = (tag3 == "string")
	if r_941 then
		_temp = r_941
	else
		local r_951
		r_951 = (tag3 == "number")
		if r_951 then
			_temp = r_951
		else
			local r_961
			r_961 = (tag3 == "symbol")
			if r_961 then
				_temp = r_961
			else
				_temp = (tag3 == "key")
			end
		end
	end
	if _temp then
		return append_21_1(writer5, number_2d3e_string1(node2["contents"]))
	elseif (tag3 == "list") then
		append_21_1(writer5, "(")
		if nil_3f_1(node2) then
			return append_21_1(writer5, ")")
		else
			local newline1, max2
			newline1 = false
			max2 = (60 - estimateLength1(car2(node2), 60))
			expression1(car2(node2), writer5)
			if (max2 <= 0) then
				newline1 = true
				indent_21_1(writer5)
			else
			end
			local r_1111
			r_1111 = _23_2(node2)
			local r_1121
			r_1121 = 1
			local r_1091
			r_1091 = nil
			r_1091 = (function(r_1101)
				local _temp
				if (0 < 1) then
					_temp = (r_1101 <= r_1111)
				else
					_temp = (r_1101 >= r_1111)
				end
				if _temp then
					local i5
					i5 = r_1101
					local entry1
					entry1 = nth1(node2, i5)
					local _temp
					local r_1131
					r_1131 = _21_1(newline1)
					if r_1131 then
						_temp = (max2 > 0)
					else
						_temp = r_1131
					end
					if _temp then
						max2 = (max2 - estimateLength1(entry1, max2))
						if (max2 <= 0) then
							newline1 = true
							indent_21_1(writer5)
						else
						end
					else
					end
					if newline1 then
						line_21_1(writer5)
					else
						append_21_1(writer5, " ")
					end
					expression1(entry1, writer5)
					return r_1091((r_1101 + r_1121))
				else
				end
			end);
			r_1091(2)
			if newline1 then
				unindent_21_1(writer5)
			else
			end
			return append_21_1(writer5, ")")
		end
	else
		return fail1(("Unknown tag " .. tag3))
	end
end);
block1 = (function(list1, writer6)
	local r_981
	r_981 = list1
	local r_1011
	r_1011 = _23_2(r_981)
	local r_1021
	r_1021 = 1
	local r_991
	r_991 = nil
	r_991 = (function(r_1001)
		local _temp
		if (0 < 1) then
			_temp = (r_1001 <= r_1011)
		else
			_temp = (r_1001 >= r_1011)
		end
		if _temp then
			local r_971
			r_971 = r_1001
			local node3
			node3 = r_981[r_971]
			expression1(node3, writer6)
			line_21_1(writer6)
			return r_991((r_1001 + r_1021))
		else
		end
	end);
	return r_991(1)
end);
return struct1("expression", expression1, "block", block1)
