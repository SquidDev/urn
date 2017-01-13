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
_e_3e3d_1 = _libs[">="]
_e_2b_1 = _libs["+"]
_e1 = _libs["-"]
_e_25_1 = _libs["%"]
_e_2e2e_1 = _libs[".."]
_egetIdx1 = _libs["get-idx"]
_esetIdx_21_1 = _libs["set-idx!"]
format1 = _libs["format"]
_eerror_21_1 = _libs["error!"]
_etype_23_1 = _libs["type#"]
_eemptyStruct1 = _libs["empty-struct"]
require1 = _libs["require"]
_e_23_1 = (function(xs1)
	return _egetIdx1(xs1, "n")
end);
_ekey_3f_1 = (function(x5)
	return _e_3d3d_1(type1(x5), "key")
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
sub1 = _libs["sub"]
struct1 = (function(...)
	local keys2 = table.pack(...) keys2.tag = "list"
	if _e_3d3d_1(_e_25_1(_e_23_2(keys2), 1), 1) then
		_eerror_21_1("Expected an even number of arguments to struct", 2)
	else
	end
	local contents1, out2
	contents1 = (function(key2)
		return sub1(_egetIdx1(key2, "contents"), 2)
	end);
	out2 = _eemptyStruct1()
	local r_731
	r_731 = _e_23_1(keys2)
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
			local i2
			i2 = r_721
			local key3, val2
			key3 = _egetIdx1(keys2, i2)
			val2 = _egetIdx1(keys2, _e_2b_1(1, i2))
			_esetIdx_21_1(out2, (function()
				if _ekey_3f_1(key3) then
					return contents1(key3)
				else
					return key3
				end
			end)(), val2)
			return r_711(_e_2b_1(r_721, r_741))
		else
		end
	end);
	r_711(1)
	return out2
end);
fail1 = (function(msg1)
	return _eerror_21_1(msg1, 0)
end);
_e_3d_1 = (function(x6, y1)
	return _e_3d3d_1(x6, y1)
end);
succ1 = (function(x7)
	return _e_2b_1(1, x7)
end);
pred1 = (function(x8)
	return _e1(x8, 1)
end);
builtins1 = _egetIdx1(require1("tacky.analysis.resolve"), "builtins")
_evisitQuote1 = (function(node1, visitor1, level1)
	if _e_3d3d_1(level1, 0) then
		return _evisitNode1(node1, visitor1)
	else
		local tag2
		tag2 = _egetIdx1(node1, "tag")
		local _temp
		local r_891
		r_891 = _e_3d_1(tag2, "string")
		if r_891 then
			_temp = r_891
		else
			local r_901
			r_901 = _e_3d_1(tag2, "number")
			if r_901 then
				_temp = r_901
			else
				local r_911
				r_911 = _e_3d_1(tag2, "key")
				if r_911 then
					_temp = r_911
				else
					_temp = _e_3d_1(tag2, "symbol")
				end
			end
		end
		if _temp then
			return nil
		elseif _e_3d_1(tag2, "list") then
			local first1
			first1 = nth1(node1, 1)
			local _temp
			local r_921
			r_921 = first1
			if r_921 then
				_temp = _e_3d_1(_egetIdx1(first1, "tag"), "symbol")
			else
				_temp = r_921
			end
			if _temp then
				local _temp
				local r_971
				r_971 = _e_3d_1(_egetIdx1(first1, "contents"), "unquote")
				if r_971 then
					_temp = r_971
				else
					_temp = _e_3d_1(_egetIdx1(first1, "contents"), "unquote-splice")
				end
				if _temp then
					return _evisitQuote1(nth1(node1, 2), visitor1, pred1(level1))
				elseif _e_3d_1(_egetIdx1(first1, "contents"), "quasiquote") then
					return _evisitQuote1(nth1(node1, 2), visitor1(), succ1(level1))
				else
					local r_991
					r_991 = node1
					local r_1021
					r_1021 = _e_23_2(r_991)
					local r_1031
					r_1031 = 1
					local r_1001
					r_1001 = nil
					r_1001 = (function(r_1011)
						local _temp
						if _e_3c_1(0, 1) then
							_temp = _e_3c3d_1(r_1011, r_1021)
						else
							_temp = _e_3e3d_1(r_1011, r_1021)
						end
						if _temp then
							local r_981
							r_981 = r_1011
							local sub2
							sub2 = _egetIdx1(r_991, r_981)
							_evisitQuote1(sub2, visitor1, level1)
							return r_1001(_e_2b_1(r_1011, r_1031))
						else
						end
					end);
					return r_1001(1)
				end
			else
				local r_1051
				r_1051 = node1
				local r_1081
				r_1081 = _e_23_2(r_1051)
				local r_1091
				r_1091 = 1
				local r_1061
				r_1061 = nil
				r_1061 = (function(r_1071)
					local _temp
					if _e_3c_1(0, 1) then
						_temp = _e_3c3d_1(r_1071, r_1081)
					else
						_temp = _e_3e3d_1(r_1071, r_1081)
					end
					if _temp then
						local r_1041
						r_1041 = r_1071
						local sub3
						sub3 = _egetIdx1(r_1051, r_1041)
						_evisitQuote1(sub3, visitor1, level1)
						return r_1061(_e_2b_1(r_1071, r_1091))
					else
					end
				end);
				return r_1061(1)
			end
		elseif _eerror_21_1 then
			return _e_2e2e_1("Unknown tag ", tag2)
		else
			error('unmatched item')
		end
	end
end);
_evisitNode1 = (function(node2, visitor2)
	if _e_3d_1(visitor2(node2), false) then
	else
		local tag3
		tag3 = _egetIdx1(node2, "tag")
		local _temp
		local r_931
		r_931 = _e_3d_1(tag3, "string")
		if r_931 then
			_temp = r_931
		else
			local r_941
			r_941 = _e_3d_1(tag3, "number")
			if r_941 then
				_temp = r_941
			else
				local r_951
				r_951 = _e_3d_1(tag3, "key")
				if r_951 then
					_temp = r_951
				else
					_temp = _e_3d_1(tag3, "symbol")
				end
			end
		end
		if _temp then
			return nil
		elseif _e_3d_1(tag3, "list") then
			local first2
			first2 = nth1(node2, 1)
			local _temp
			local r_961
			r_961 = first2
			if r_961 then
				_temp = _e_3d_1(_egetIdx1(first2, "tag"), "symbol")
			else
				_temp = r_961
			end
			if _temp then
				local func1
				func1 = _egetIdx1(first2, "var")
				local funct1
				funct1 = _egetIdx1(func1, "tag")
				if _e_3d_1(func1, _egetIdx1(builtins1, "lambda")) then
					return _evisitBlock1(node2, 3, visitor2)
				elseif _e_3d_1(func1, _egetIdx1(builtins1, "cond")) then
					local r_1121
					r_1121 = _e_23_2(node2)
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
							local i3
							i3 = r_1111
							local case1
							case1 = nth1(node2, i3)
							_evisitNode1(nth1(case1, 1), visitor2)
							_evisitBlock1(case1, 2, visitor2)
							return r_1101(_e_2b_1(r_1111, r_1131))
						else
						end
					end);
					return r_1101(2)
				elseif _e_3d_1(func1, _egetIdx1(builtins1, "set!")) then
					return _evisitNode1(nth1(node2, 3), visitor2)
				elseif _e_3d_1(func1, _egetIdx1(builtins1, "quote")) then
				elseif _e_3d_1(func1, _egetIdx1(builtins1, "quasiquote")) then
					return _evisitQuote1(nth1(node2, 2), visitor2, 1)
				else
					local _temp
					local r_1141
					r_1141 = _e_3d_1(func1, _egetIdx1(builtins1, "unquote"))
					if r_1141 then
						_temp = r_1141
					else
						_temp = _e_3d_1(func1, _egetIdx1(builtins1, "unquote-splice"))
					end
					if _temp then
						return fail1("unquote/unquote-splice should never appear head")
					else
						local _temp
						local r_1151
						r_1151 = _e_3d_1(func1, _egetIdx1(builtins1, "define"))
						if r_1151 then
							_temp = r_1151
						else
							_temp = _e_3d_1(func1, _egetIdx1(builtins1, "define-macro"))
						end
						if _temp then
							return _evisitBlock1(node2, 3, visitor2)
						elseif _e_3d_1(func1, _egetIdx1(builtins1, "define-native")) then
						elseif _e_3d_1(func1, _egetIdx1(builtins1, "import")) then
						elseif _e_3d_1(funct1, "macro") then
							return fail1("Macros should have been expanded")
						else
							local _temp
							local r_1161
							r_1161 = _e_3d_1(funct1, "defined")
							if r_1161 then
								_temp = r_1161
							else
								_temp = _e_3d_1(funct1, "arg")
							end
							if _temp then
								return _evisitBlock1(node2, 1, visitor2)
							else
								return fail1(_e_2e2e_1("Unknown kind ", func1, " for variable ", _egetIdx1(func1, "name")))
							end
						end
					end
				end
			else
				return _evisitBlock1(node2, 1, visitor2)
			end
		elseif _eerror_21_1 then
			return _e_2e2e_1("Unknown tag ", tag3)
		else
			error('unmatched item')
		end
	end
end);
_evisitBlock1 = (function(node3, start3, visitor3)
	local r_871
	r_871 = _e_23_2(node3)
	local r_881
	r_881 = 1
	local r_851
	r_851 = nil
	r_851 = (function(r_861)
		local _temp
		if _e_3c_1(0, 1) then
			_temp = _e_3c3d_1(r_861, r_871)
		else
			_temp = _e_3e3d_1(r_861, r_871)
		end
		if _temp then
			local i4
			i4 = r_861
			_evisitNode1(nth1(node3, i4), visitor3)
			return r_851(_e_2b_1(r_861, r_881))
		else
		end
	end);
	return r_851(start3)
end);
return struct1("visitNode", _evisitNode1, "visitBlock", _evisitBlock1, "visitList", _evisitBlock1)
