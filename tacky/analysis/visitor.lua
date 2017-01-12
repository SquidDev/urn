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
require1 = _libs["require"]
_e_35_1 = (function(xs1)
	return _eget_45_idx1(xs1, "n")
end);
_ekey_63_1 = (function(x5)
	return _e_61__61_1(type1(x5), "key")
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
sub1 = _libs["sub"]
struct1 = (function(...)
	local keys2 = table.pack(...) keys2.tag = "list"
	if _e_61__61_1(_e_37_1(_e_35_2(keys2), 1), 1) then
		_eerror_33_1("Expected an even number of arguments to struct", 2)
	else
	end
	local contents1, out2
	contents1 = (function(key2)
		return sub1(_eget_45_idx1(key2, "contents"), 2)
	end);
	out2 = _eempty_45_struct1()
	local r_711
	r_711 = _e_35_1(keys2)
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
			local i2
			i2 = r_701
			local key3, val2
			key3 = _eget_45_idx1(keys2, i2)
			val2 = _eget_45_idx1(keys2, _e_43_1(1, i2))
			_eset_45_idx_33_1(out2, (function()
				if _ekey_63_1(key3) then
					return contents1(key3)
				else
					return key3
				end
			end)(), val2)
			return r_691(_e_43_1(r_701, r_721))
		else
		end
	end);
	r_691(1)
	return out2
end);
fail1 = (function(msg1)
	return _eerror_33_1(msg1, 0)
end);
_e_61_1 = (function(x6, y1)
	return _e_61__61_1(x6, y1)
end);
succ1 = (function(x7)
	return _e_43_1(1, x7)
end);
pred1 = (function(x8)
	return _e_45_1(x8, 1)
end);
builtins1 = _eget_45_idx1(require1("tacky.analysis.resolve"), "builtins")
_evisit_45_quote1 = (function(node1, visitor1, level1)
	if _e_61__61_1(level1, 0) then
		return _evisit_45_node1(node1, visitor1)
	else
		local tag2
		tag2 = _eget_45_idx1(node1, "tag")
		if (function(r_871)
			if r_871 then
				return r_871
			else
				local r_881
				r_881 = _e_61_1(tag2, "number")
				if r_881 then
					return r_881
				else
					local r_891
					r_891 = _e_61_1(tag2, "key")
					if r_891 then
						return r_891
					else
						return _e_61_1(tag2, "symbol")
					end
				end
			end
		end)(_e_61_1(tag2, "string")) then
			return nil
		elseif _e_61_1(tag2, "list") then
			local first1
			first1 = nth1(node1, 1)
			if (function(r_901)
				if r_901 then
					return _e_61_1(_eget_45_idx1(first1, "tag"), "symbol")
				else
					return r_901
				end
			end)(first1) then
				if (function(r_951)
					if r_951 then
						return r_951
					else
						return _e_61_1(_eget_45_idx1(first1, "contents"), "unquote-splice")
					end
				end)(_e_61_1(_eget_45_idx1(first1, "contents"), "unquote")) then
					return _evisit_45_quote1(nth1(node1, 2), visitor1, pred1(level1))
				elseif _e_61_1(_eget_45_idx1(first1, "contents"), "quasiquote") then
					return _evisit_45_quote1(nth1(node1, 2), visitor1(), succ1(level1))
				else
					local r_971
					r_971 = node1
					local r_1001
					r_1001 = _e_35_2(r_971)
					local r_1011
					r_1011 = 1
					local r_981
					r_981 = nil
					r_981 = (function(r_991)
						local _temp
						if _e_60_1(0, 1) then
							_temp = _e_60__61_1(r_991, r_1001)
						else
							_temp = _e_62__61_1(r_991, r_1001)
						end
						if _temp then
							local r_961
							r_961 = r_991
							local sub2
							sub2 = _eget_45_idx1(r_971, r_961)
							_evisit_45_quote1(sub2, visitor1, level1)
							return r_981(_e_43_1(r_991, r_1011))
						else
						end
					end);
					return r_981(1)
				end
			else
				local r_1031
				r_1031 = node1
				local r_1061
				r_1061 = _e_35_2(r_1031)
				local r_1071
				r_1071 = 1
				local r_1041
				r_1041 = nil
				r_1041 = (function(r_1051)
					local _temp
					if _e_60_1(0, 1) then
						_temp = _e_60__61_1(r_1051, r_1061)
					else
						_temp = _e_62__61_1(r_1051, r_1061)
					end
					if _temp then
						local r_1021
						r_1021 = r_1051
						local sub3
						sub3 = _eget_45_idx1(r_1031, r_1021)
						_evisit_45_quote1(sub3, visitor1, level1)
						return r_1041(_e_43_1(r_1051, r_1071))
					else
					end
				end);
				return r_1041(1)
			end
		elseif _eerror_33_1 then
			return _e_46__46_1("Unknown tag ", tag2)
		else
			error('unmatched item')
		end
	end
end);
_evisit_45_node1 = (function(node2, visitor2)
	if _e_61_1(visitor2(node2), false) then
	else
		local tag3
		tag3 = _eget_45_idx1(node2, "tag")
		if (function(r_911)
			if r_911 then
				return r_911
			else
				local r_921
				r_921 = _e_61_1(tag3, "number")
				if r_921 then
					return r_921
				else
					local r_931
					r_931 = _e_61_1(tag3, "key")
					if r_931 then
						return r_931
					else
						return _e_61_1(tag3, "symbol")
					end
				end
			end
		end)(_e_61_1(tag3, "string")) then
			return nil
		elseif _e_61_1(tag3, "list") then
			local first2
			first2 = nth1(node2, 1)
			if (function(r_941)
				if r_941 then
					return _e_61_1(_eget_45_idx1(first2, "tag"), "symbol")
				else
					return r_941
				end
			end)(first2) then
				local func1
				func1 = _eget_45_idx1(first2, "var")
				local funct1
				funct1 = _eget_45_idx1(func1, "tag")
				if _e_61_1(func1, _eget_45_idx1(builtins1, "lambda")) then
					return _evisit_45_block1(node2, 3, visitor2)
				elseif _e_61_1(func1, _eget_45_idx1(builtins1, "cond")) then
					local r_1101
					r_1101 = _e_35_2(node2)
					local r_1111
					r_1111 = 1
					local r_1081
					r_1081 = nil
					r_1081 = (function(r_1091)
						local _temp
						if _e_60_1(0, 1) then
							_temp = _e_60__61_1(r_1091, r_1101)
						else
							_temp = _e_62__61_1(r_1091, r_1101)
						end
						if _temp then
							local i3
							i3 = r_1091
							local case1
							case1 = nth1(node2, i3)
							_evisit_45_node1(nth1(case1, 1), visitor2)
							_evisit_45_block1(case1, 2, visitor2)
							return r_1081(_e_43_1(r_1091, r_1111))
						else
						end
					end);
					return r_1081(2)
				elseif _e_61_1(func1, _eget_45_idx1(builtins1, "set!")) then
					return _evisit_45_node1(nth1(node2, 3), visitor2)
				elseif _e_61_1(func1, _eget_45_idx1(builtins1, "quote")) then
				elseif _e_61_1(func1, _eget_45_idx1(builtins1, "quasiquote")) then
					return _evisit_45_quote1(nth1(node2, 2), visitor2, 1)
				elseif (function(r_1121)
					if r_1121 then
						return r_1121
					else
						return _e_61_1(func1, _eget_45_idx1(builtins1, "unquote-splice"))
					end
				end)(_e_61_1(func1, _eget_45_idx1(builtins1, "unquote"))) then
					return fail1("unquote/unquote-splice should never appear head")
				elseif (function(r_1131)
					if r_1131 then
						return r_1131
					else
						return _e_61_1(func1, _eget_45_idx1(builtins1, "define-macro"))
					end
				end)(_e_61_1(func1, _eget_45_idx1(builtins1, "define"))) then
					return _evisit_45_block1(node2, 3, visitor2)
				elseif _e_61_1(func1, _eget_45_idx1(builtins1, "define-native")) then
				elseif _e_61_1(func1, _eget_45_idx1(builtins1, "import")) then
				elseif _e_61_1(funct1, "macro") then
					return fail1("Macros should have been expanded")
				elseif (function(r_1141)
					if r_1141 then
						return r_1141
					else
						return _e_61_1(funct1, "arg")
					end
				end)(_e_61_1(funct1, "defined")) then
					return _evisit_45_block1(node2, 1, visitor2)
				else
					return fail1(_e_46__46_1("Unknown kind ", func1, " for variable ", _eget_45_idx1(func1, "name")))
				end
			else
				return _evisit_45_block1(node2, 1, visitor2)
			end
		elseif _eerror_33_1 then
			return _e_46__46_1("Unknown tag ", tag3)
		else
			error('unmatched item')
		end
	end
end);
_evisit_45_block1 = (function(node3, start3, visitor3)
	local r_851
	r_851 = _e_35_2(node3)
	local r_861
	r_861 = 1
	local r_831
	r_831 = nil
	r_831 = (function(r_841)
		local _temp
		if _e_60_1(0, 1) then
			_temp = _e_60__61_1(r_841, r_851)
		else
			_temp = _e_62__61_1(r_841, r_851)
		end
		if _temp then
			local i4
			i4 = r_841
			_evisit_45_node1(nth1(node3, i4), visitor3)
			return r_831(_e_43_1(r_841, r_861))
		else
		end
	end);
	return r_831(start3)
end);
return struct1("visitNode", _evisit_45_node1, "visitBlock", _evisit_45_block1, "visitList", _evisit_45_block1)
