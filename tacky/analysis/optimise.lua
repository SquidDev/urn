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

_e_61_1 = _libs["="]
_e_47__61_1 = _libs["/="]
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
_eremove_45_idx_33_1 = _libs["remove-idx!"]
slice1 = _libs["slice"]
format1 = _libs["format"]
_eerror_33_1 = _libs["error!"]
_etype_35_1 = _libs["type#"]
_eempty_45_struct1 = _libs["empty-struct"]
require1 = _libs["require"]
gensym1 = _libs["gensym"]
_e_35_1 = (function(xs1)
	return _eget_45_idx1(xs1, "n")
end);
car1 = (function(xs2)
	return _eget_45_idx1(xs2, 1)
end);
cdr1 = (function(xs3)
	return slice1(xs3, 2)
end);
map1 = (function(fn1, li1)
	local out1
	out1 = {tag = "list", n = 0}
	_eset_45_idx_33_1(out1, "n", _e_35_1(li1))
	local r_31
	r_31 = _e_35_1(li1)
	local r_41
	r_41 = 1
	local r_11
	r_11 = nil
	r_11 = (function(r_21)
		local _temp
		if _e_60_1(0, 1) then
			_temp = _e_60__61_1(r_21, r_31)
		else
			_temp = _e_62__61_1(r_21, r_31)
		end
		if _temp then
			local i1
			i1 = r_21
			_eset_45_idx_33_1(out1, i1, fn1(_eget_45_idx1(li1, i1)))
			return r_11(_e_43_1(r_21, r_41))
		else
		end
	end);
	r_11(1)
	return out1
end);
_e_33_1 = (function(expr1)
	if expr1 then
		return false
	else
		return true
	end
end);
_elist_63_1 = (function(x6)
	return _e_61_1(type1(x6), "list")
end);
_esymbol_63_1 = (function(x7)
	return _e_61_1(type1(x7), "symbol")
end);
_ekey_63_1 = (function(x8)
	return _e_61_1(type1(x8), "key")
end);
type1 = (function(val1)
	local ty2
	ty2 = _etype_35_1(val1)
	if _e_61_1(ty2, "table") then
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
	if _e_47__61_1(r_51, "list") then
		_eerror_33_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_51), 2)
	else
	end
	local r_201
	r_201 = type1(idx1)
	if _e_47__61_1(r_201, "number") then
		_eerror_33_1(format1("bad argment %s (expected %s, got %s)", "idx", "number", r_201), 2)
	else
	end
	return _eget_45_idx1(li4, idx1)
end);
_eset_45_nth_33_1 = (function(li9, idx2, val2)
	local r_61
	r_61 = type1(li9)
	if _e_47__61_1(r_61, "list") then
		_eerror_33_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_61), 2)
	else
	end
	local r_211
	r_211 = type1(idx2)
	if _e_47__61_1(r_211, "number") then
		_eerror_33_1(format1("bad argment %s (expected %s, got %s)", "idx", "number", r_211), 2)
	else
	end
	return _eset_45_idx_33_1(li9, idx2, val2)
end);
_eremove_45_nth_33_1 = (function(li10, idx3)
	local r_71
	r_71 = type1(li10)
	if _e_47__61_1(r_71, "list") then
		_eerror_33_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_71), 2)
	else
	end
	local r_221
	r_221 = type1(idx3)
	if _e_47__61_1(r_221, "number") then
		_eerror_33_1(format1("bad argment %s (expected %s, got %s)", "idx", "number", r_221), 2)
	else
	end
	_eremove_45_idx_33_1(li10, idx3)
	return _eset_45_idx_33_1(li10, "n", _e_45_1(_eget_45_idx1(li10, "n"), 1))
end);
_e_35_2 = (function(li6)
	local r_81
	r_81 = type1(li6)
	if _e_47__61_1(r_81, "list") then
		_eerror_33_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_81), 2)
	else
	end
	return _e_35_1(li6)
end);
car2 = (function(li3)
	return nth1(li3, 1)
end);
slice2 = (function(li8, start2, finish1)
	local r_91
	r_91 = type1(li8)
	if _e_47__61_1(r_91, "list") then
		_eerror_33_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_91), 2)
	else
	end
	local r_231
	r_231 = type1(start2)
	if _e_47__61_1(r_231, "number") then
		_eerror_33_1(format1("bad argment %s (expected %s, got %s)", "start", "number", r_231), 2)
	else
	end
	return slice1(li8, start2, finish1)
end);
cdr2 = (function(li7)
	local r_101
	r_101 = type1(li7)
	if _e_47__61_1(r_101, "list") then
		_eerror_33_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_101), 2)
	else
	end
	return slice2(li7, 2)
end);
_epush_45_cdr_33_1 = (function(li11, val3)
	local r_111
	r_111 = type1(li11)
	if _e_47__61_1(r_111, "list") then
		_eerror_33_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_111), 2)
	else
	end
	local len1
	len1 = _e_43_1(_e_35_1(li11), 1)
	_eset_45_idx_33_1(li11, "n", len1)
	_eset_45_idx_33_1(li11, len1, val3)
	return li11
end);
_enil_63_1 = (function(li5)
	return _e_61_1(_e_35_2(li5), 0)
end);
map2 = (function(fn2, li2)
	local r_141
	r_141 = type1(fn2)
	if _e_47__61_1(r_141, "function") then
		_eerror_33_1(format1("bad argment %s (expected %s, got %s)", "fn", "function", r_141), 2)
	else
	end
	local r_291
	r_291 = type1(li2)
	if _e_47__61_1(r_291, "list") then
		_eerror_33_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_291), 2)
	else
	end
	return map1(fn2, li2)
end);
caar1 = (function(x2)
	return car2(car2(x2))
end);
cadr1 = (function(x1)
	return nth1(x1, 2)
end);
cdar1 = (function(x9)
	return cdr2(car2(x9))
end);
cddr1 = (function(x10)
	return slice2(x10, 3)
end);
caaar1 = (function(x11)
	return car2(car2(car2(x11)))
end);
caadr1 = (function(x12)
	return car2(car2(cdr2(x12)))
end);
cadar1 = (function(x3)
	return car2(cdr2(car2(x3)))
end);
caddr1 = (function(x13)
	return car2(cdr2(cdr2(x13)))
end);
cdaar1 = (function(x14)
	return cdr2(car2(car2(x14)))
end);
cdadr1 = (function(x15)
	return cdr2(car2(cdr2(x15)))
end);
cddar1 = (function(x16)
	return cdr2(cdr2(car2(x16)))
end);
cdddr1 = (function(x17)
	return cdr2(cdr2(cdr2(x17)))
end);
caaaar1 = (function(x18)
	return car2(car2(car2(car2(x18))))
end);
caaadr1 = (function(x19)
	return car2(car2(car2(cdr2(x19))))
end);
caadar1 = (function(x20)
	return car2(car2(cdr2(car2(x20))))
end);
caaddr1 = (function(x21)
	return car2(car2(cdr2(cdr2(x21))))
end);
cadaar1 = (function(x22)
	return car2(cdr2(car2(car2(x22))))
end);
cadadr1 = (function(x23)
	return car2(cdr2(car2(cdr2(x23))))
end);
caddar1 = (function(x24)
	return car2(cdr2(cdr2(car2(x24))))
end);
cadddr1 = (function(x25)
	return car2(cdr2(cdr2(cdr2(x25))))
end);
cdaaar1 = (function(x26)
	return cdr2(car2(car2(car2(x26))))
end);
cdaadr1 = (function(x27)
	return cdr2(car2(car2(cdr2(x27))))
end);
cdadar1 = (function(x28)
	return cdr2(car2(cdr2(car2(x28))))
end);
cdaddr1 = (function(x29)
	return cdr2(car2(cdr2(cdr2(x29))))
end);
cddaar1 = (function(x30)
	return cdr2(cdr2(car2(car2(x30))))
end);
cddadr1 = (function(x31)
	return cdr2(cdr2(car2(cdr2(x31))))
end);
cdddar1 = (function(x32)
	return cdr2(cdr2(cdr2(car2(x32))))
end);
cddddr1 = (function(x33)
	return cdr2(cdr2(cdr2(cdr2(x33))))
end);
cars1 = (function(xs4)
	return map2(car2, xs4)
end);
cadrs1 = (function(xs5)
	return map2(cadr1, xs5)
end);
any1 = (function(fn3, li12)
	local r_161
	r_161 = type1(fn3)
	if _e_47__61_1(r_161, "function") then
		_eerror_33_1(format1("bad argment %s (expected %s, got %s)", "fn", "function", r_161), 2)
	else
	end
	local r_351
	r_351 = type1(li12)
	if _e_47__61_1(r_351, "list") then
		_eerror_33_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_351), 2)
	else
	end
	local _eany_45_impl1
	_eany_45_impl1 = (function(i3)
		if _e_62_1(i3, _e_35_1(li12)) then
			return false
		elseif fn3(_eget_45_idx1(li12, i3)) then
			return true
		else
			return _eany_45_impl1(_e_43_1(i3, 1))
		end
	end);
	return _eany_45_impl1(1)
end);
_eslot_63_1 = (function(symb3)
	local r_471
	r_471 = _esymbol_63_1(symb3)
	if r_471 then
		return _e_61_1(_eget_45_idx1(symb3, "contents"), "<>")
	else
		return r_471
	end
end);
concat1 = _libs["concat"]
find1 = _libs["find"]
sub1 = _libs["sub"]
_e_35_s1 = _libs["#s"]
struct1 = (function(...)
	local keys3 = table.pack(...) keys3.tag = "list"
	if _e_61_1(_e_37_1(_e_35_2(keys3), 1), 1) then
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
			local i4
			i4 = r_721
			local key4, val4
			key4 = _eget_45_idx1(keys3, i4)
			val4 = _eget_45_idx1(keys3, _e_43_1(1, i4))
			_eset_45_idx_33_1(out2, (function()
				if _ekey_63_1(key4) then
					return contents1(key4)
				else
					return key4
				end
			end)(), val4)
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
succ1 = (function(x34)
	return _e_43_1(1, x34)
end);
pred1 = (function(x35)
	return _e_45_1(x35, 1)
end);
builtins1 = _eget_45_idx1(require1("tacky.analysis.resolve"), "builtins")
_evisit_45_quote1 = (function(node1, visitor1, level1)
	if _e_61_1(level1, 0) then
		return _evisit_45_node1(node1, visitor1)
	else
		local tag2
		tag2 = _eget_45_idx1(node1, "tag")
		local _temp
		local r_1081
		r_1081 = _e_61_1(tag2, "string")
		if r_1081 then
			_temp = r_1081
		else
			local r_1091
			r_1091 = _e_61_1(tag2, "number")
			if r_1091 then
				_temp = r_1091
			else
				local r_1101
				r_1101 = _e_61_1(tag2, "key")
				if r_1101 then
					_temp = r_1101
				else
					_temp = _e_61_1(tag2, "symbol")
				end
			end
		end
		if _temp then
			return nil
		elseif _e_61_1(tag2, "list") then
			local first1
			first1 = nth1(node1, 1)
			local _temp
			local r_1111
			r_1111 = first1
			if r_1111 then
				_temp = _e_61_1(_eget_45_idx1(first1, "tag"), "symbol")
			else
				_temp = r_1111
			end
			if _temp then
				local _temp
				local r_1161
				r_1161 = _e_61_1(_eget_45_idx1(first1, "contents"), "unquote")
				if r_1161 then
					_temp = r_1161
				else
					_temp = _e_61_1(_eget_45_idx1(first1, "contents"), "unquote-splice")
				end
				if _temp then
					return _evisit_45_quote1(nth1(node1, 2), visitor1, pred1(level1))
				elseif _e_61_1(_eget_45_idx1(first1, "contents"), "quasiquote") then
					return _evisit_45_quote1(nth1(node1, 2), visitor1(), succ1(level1))
				else
					local r_1181
					r_1181 = node1
					local r_1211
					r_1211 = _e_35_2(r_1181)
					local r_1221
					r_1221 = 1
					local r_1191
					r_1191 = nil
					r_1191 = (function(r_1201)
						local _temp
						if _e_60_1(0, 1) then
							_temp = _e_60__61_1(r_1201, r_1211)
						else
							_temp = _e_62__61_1(r_1201, r_1211)
						end
						if _temp then
							local r_1171
							r_1171 = r_1201
							local sub2
							sub2 = _eget_45_idx1(r_1181, r_1171)
							_evisit_45_quote1(sub2, visitor1, level1)
							return r_1191(_e_43_1(r_1201, r_1221))
						else
						end
					end);
					return r_1191(1)
				end
			else
				local r_1241
				r_1241 = node1
				local r_1271
				r_1271 = _e_35_2(r_1241)
				local r_1281
				r_1281 = 1
				local r_1251
				r_1251 = nil
				r_1251 = (function(r_1261)
					local _temp
					if _e_60_1(0, 1) then
						_temp = _e_60__61_1(r_1261, r_1271)
					else
						_temp = _e_62__61_1(r_1261, r_1271)
					end
					if _temp then
						local r_1231
						r_1231 = r_1261
						local sub3
						sub3 = _eget_45_idx1(r_1241, r_1231)
						_evisit_45_quote1(sub3, visitor1, level1)
						return r_1251(_e_43_1(r_1261, r_1281))
					else
					end
				end);
				return r_1251(1)
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
		local _temp
		local r_1121
		r_1121 = _e_61_1(tag3, "string")
		if r_1121 then
			_temp = r_1121
		else
			local r_1131
			r_1131 = _e_61_1(tag3, "number")
			if r_1131 then
				_temp = r_1131
			else
				local r_1141
				r_1141 = _e_61_1(tag3, "key")
				if r_1141 then
					_temp = r_1141
				else
					_temp = _e_61_1(tag3, "symbol")
				end
			end
		end
		if _temp then
			return nil
		elseif _e_61_1(tag3, "list") then
			local first2
			first2 = nth1(node2, 1)
			local _temp
			local r_1151
			r_1151 = first2
			if r_1151 then
				_temp = _e_61_1(_eget_45_idx1(first2, "tag"), "symbol")
			else
				_temp = r_1151
			end
			if _temp then
				local func1
				func1 = _eget_45_idx1(first2, "var")
				local funct1
				funct1 = _eget_45_idx1(func1, "tag")
				if _e_61_1(func1, _eget_45_idx1(builtins1, "lambda")) then
					return _evisit_45_block1(node2, 3, visitor2)
				elseif _e_61_1(func1, _eget_45_idx1(builtins1, "cond")) then
					local r_1311
					r_1311 = _e_35_2(node2)
					local r_1321
					r_1321 = 1
					local r_1291
					r_1291 = nil
					r_1291 = (function(r_1301)
						local _temp
						if _e_60_1(0, 1) then
							_temp = _e_60__61_1(r_1301, r_1311)
						else
							_temp = _e_62__61_1(r_1301, r_1311)
						end
						if _temp then
							local i5
							i5 = r_1301
							local case1
							case1 = nth1(node2, i5)
							_evisit_45_node1(nth1(case1, 1), visitor2)
							_evisit_45_block1(case1, 2, visitor2)
							return r_1291(_e_43_1(r_1301, r_1321))
						else
						end
					end);
					return r_1291(2)
				elseif _e_61_1(func1, _eget_45_idx1(builtins1, "set!")) then
					return _evisit_45_node1(nth1(node2, 3), visitor2)
				elseif _e_61_1(func1, _eget_45_idx1(builtins1, "quote")) then
				elseif _e_61_1(func1, _eget_45_idx1(builtins1, "quasiquote")) then
					return _evisit_45_quote1(nth1(node2, 2), visitor2, 1)
				else
					local _temp
					local r_1331
					r_1331 = _e_61_1(func1, _eget_45_idx1(builtins1, "unquote"))
					if r_1331 then
						_temp = r_1331
					else
						_temp = _e_61_1(func1, _eget_45_idx1(builtins1, "unquote-splice"))
					end
					if _temp then
						return fail1("unquote/unquote-splice should never appear head")
					else
						local _temp
						local r_1341
						r_1341 = _e_61_1(func1, _eget_45_idx1(builtins1, "define"))
						if r_1341 then
							_temp = r_1341
						else
							_temp = _e_61_1(func1, _eget_45_idx1(builtins1, "define-macro"))
						end
						if _temp then
							return _evisit_45_block1(node2, 3, visitor2)
						elseif _e_61_1(func1, _eget_45_idx1(builtins1, "define-native")) then
						elseif _e_61_1(func1, _eget_45_idx1(builtins1, "import")) then
						elseif _e_61_1(funct1, "macro") then
							return fail1("Macros should have been expanded")
						else
							local _temp
							local r_1351
							r_1351 = _e_61_1(funct1, "defined")
							if r_1351 then
								_temp = r_1351
							else
								_temp = _e_61_1(funct1, "arg")
							end
							if _temp then
								return _evisit_45_block1(node2, 1, visitor2)
							else
								return fail1(_e_46__46_1("Unknown kind ", func1, " for variable ", _eget_45_idx1(func1, "name")))
							end
						end
					end
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
	local r_1061
	r_1061 = _e_35_2(node3)
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
			local i6
			i6 = r_1051
			_evisit_45_node1(nth1(node3, i6), visitor3)
			return r_1041(_e_43_1(r_1051, r_1071))
		else
		end
	end);
	return r_1041(start3)
end);
struct1("visitNode", _evisit_45_node1, "visitBlock", _evisit_45_block1, "visitList", _evisit_45_block1)
builtins2 = _eget_45_idx1(require1("tacky.analysis.resolve"), "builtins")
_ehas_45_side_45_effect1 = (function(node4)
	local tag4
	tag4 = type1(node4)
	local _temp
	local r_851
	r_851 = _e_61_1(tag4, "number")
	if r_851 then
		_temp = r_851
	else
		local r_861
		r_861 = _e_61_1(tag4, "string")
		if r_861 then
			_temp = r_861
		else
			local r_871
			r_871 = _e_61_1(tag4, "key")
			if r_871 then
				_temp = r_871
			else
				_temp = _e_61_1(tag4, "symbol")
			end
		end
	end
	if _temp then
		return false
	elseif _e_61_1(tag4, "list") then
		local fst1
		fst1 = cdr2(node4)
		local _temp
		local r_881
		r_881 = fst1
		if r_881 then
			_temp = _e_61_1(type1(fst1), "symbol")
		else
			_temp = r_881
		end
		if _temp then
			local var5
			var5 = _eget_45_idx1(fst1, "var")
			local r_891
			r_891 = _e_47__61_1(var5, _eget_45_idx1(builtins2, "lambda"))
			if r_891 then
				return _e_47__61_1(var5, _eget_45_idx1(builtins2, "quote"))
			else
				return r_891
			end
		else
			return true
		end
	else
		error('unmatched item')
	end
end);
_eget_45_var_45_entry1 = (function(lookup1, var6)
	local entry1
	entry1 = _eget_45_idx1(lookup1, var6)
	if entry1 then
	else
		entry1 = struct1("var", var6, "usages", {tag = "list", n = 0}, "defs", {tag = "list", n = 0}, "active", false)
		_eset_45_idx_33_1(lookup1, var6, entry1)
	end
	return entry1
end);
_egather_45_definitions1 = (function(nodes1, lookup2)
	local _eadd_45_definition1
	_eadd_45_definition1 = (function(var7, def1)
		return _epush_45_cdr_33_1(_eget_45_idx1(_eget_45_var_45_entry1(lookup2, var7), "defs"), def1)
	end);
	return _evisit_45_block1(nodes1, 1, (function(node5)
		local _temp
		local r_1361
		r_1361 = _elist_63_1(node5)
		if r_1361 then
			local r_1371
			r_1371 = _e_62_1(_e_35_2(node5), 0)
			if r_1371 then
				_temp = _esymbol_63_1(car2(node5))
			else
				_temp = r_1371
			end
		else
			_temp = r_1361
		end
		if _temp then
			local func2
			func2 = _eget_45_idx1(car2(node5), "var")
			if _e_61_1(func2, _eget_45_idx1(builtins2, "lambda")) then
				local r_1391
				r_1391 = nth1(node5, 2)
				local r_1421
				r_1421 = _e_35_2(r_1391)
				local r_1431
				r_1431 = 1
				local r_1401
				r_1401 = nil
				r_1401 = (function(r_1411)
					local _temp
					if _e_60_1(0, 1) then
						_temp = _e_60__61_1(r_1411, r_1421)
					else
						_temp = _e_62__61_1(r_1411, r_1421)
					end
					if _temp then
						local r_1381
						r_1381 = r_1411
						local arg2
						arg2 = _eget_45_idx1(r_1391, r_1381)
						local _ = 1
						_eadd_45_definition1(_eget_45_idx1(arg2, "var"), struct1("tag", "arg", "value", arg2, "node", node5))
						return r_1401(_e_43_1(r_1411, r_1431))
					else
					end
				end);
				return r_1401(1)
			elseif _e_61_1(func2, _eget_45_idx1(builtins2, "set!")) then
				return _eadd_45_definition1(_eget_45_idx1(_eget_45_idx1(node5, 2), "var"), struct1("tag", "set", "value", nth1(node5, 3), "node", node5))
			else
				local _temp
				local r_1441
				r_1441 = _e_61_1(func2, _eget_45_idx1(builtins2, "define"))
				if r_1441 then
					_temp = r_1441
				else
					_temp = _e_61_1(func2, _eget_45_idx1(builtins2, "define-macro"))
				end
				if _temp then
					return _eadd_45_definition1(_eget_45_idx1(node5, "defVar"), struct1("tag", "define", "value", nth1(node5, 3), "node", node5))
				elseif _e_61_1(func2, _eget_45_idx1(builtins2, "define-native")) then
					return _eadd_45_definition1(_eget_45_idx1(node5, "defVar"), struct1("tag", "native", "node", node5))
				else
				end
			end
		else
		end
	end))
end);
_egather_45_usages1 = (function(nodes2, lookup3)
	local queue1
	queue1 = {tag = "list", n = 0}
	local _eadd_45_usage1
	_eadd_45_usage1 = (function(var8, user1)
		local entry2
		entry2 = _eget_45_idx1(lookup3, var8)
		if entry2 then
			if _eget_45_idx1(entry2, "active") then
			else
				_eset_45_idx_33_1(entry2, "active", true)
				local r_1511
				r_1511 = _eget_45_idx1(entry2, "defs")
				local r_1541
				r_1541 = _e_35_2(r_1511)
				local r_1551
				r_1551 = 1
				local r_1521
				r_1521 = nil
				r_1521 = (function(r_1531)
					local _temp
					if _e_60_1(0, 1) then
						_temp = _e_60__61_1(r_1531, r_1541)
					else
						_temp = _e_62__61_1(r_1531, r_1541)
					end
					if _temp then
						local r_1501
						r_1501 = r_1531
						local def2
						def2 = _eget_45_idx1(r_1511, r_1501)
						local val5
						val5 = _eget_45_idx1(def2, "val")
						if val5 then
							_epush_45_cdr_33_1(queue1, val5)
						else
						end
						return r_1521(_e_43_1(r_1531, r_1551))
					else
					end
				end);
				r_1521(1)
			end
			return _epush_45_cdr_33_1(_eget_45_idx1(entry2, "usages"), user1)
		else
		end
	end);
	local visit1
	visit1 = (function(node6)
		if _esymbol_63_1(node6) then
			_eadd_45_usage1(_eget_45_idx1(node6, "var"), node6)
			return true
		else
			local _temp
			local r_1451
			r_1451 = _elist_63_1(node6)
			if r_1451 then
				local r_1461
				r_1461 = _e_62_1(_e_35_2(node6), 0)
				if r_1461 then
					_temp = _esymbol_63_1(car2(node6))
				else
					_temp = r_1461
				end
			else
				_temp = r_1451
			end
			if _temp then
				local func3
				func3 = _eget_45_idx1(car2(node6), "var")
				local _temp
				local r_1471
				r_1471 = _e_61_1(func3, _eget_45_idx1(builtins2, "set!"))
				if r_1471 then
					_temp = r_1471
				else
					local r_1481
					r_1481 = _e_61_1(func3, _eget_45_idx1(builtins2, "define"))
					if r_1481 then
						_temp = r_1481
					else
						_temp = _e_61_1(func3, _eget_45_idx1(builtins2, "define-macro"))
					end
				end
				if _temp then
					if _ehas_45_side_45_effect1(nth1(node6, 3)) then
						local entry3
						entry3 = _eget_45_idx1(lookup3, "var")
						return _e_33_1((function(r_1491)
							if r_1491 then
								return _eget_45_idx1(entry3, "active")
							else
								return r_1491
							end
						end)(entry3))
					else
						return false
					end
				else
					return true
				end
			else
				return true
			end
		end
	end);
	local r_911
	r_911 = nodes2
	local r_941
	r_941 = _e_35_2(r_911)
	local r_951
	r_951 = 1
	local r_921
	r_921 = nil
	r_921 = (function(r_931)
		local _temp
		if _e_60_1(0, 1) then
			_temp = _e_60__61_1(r_931, r_941)
		else
			_temp = _e_62__61_1(r_931, r_941)
		end
		if _temp then
			local r_901
			r_901 = r_931
			local node7
			node7 = _eget_45_idx1(r_911, r_901)
			_epush_45_cdr_33_1(queue1, node7)
			return r_921(_e_43_1(r_931, r_951))
		else
		end
	end);
	r_921(1)
	local r_961
	r_961 = nil
	r_961 = (function()
		if _e_62_1(_e_35_2(queue1), 0) then
			_evisit_45_node1(_eremove_45_nth_33_1(queue1, 1), visit1)
			return r_961()
		else
		end
	end);
	return r_961()
end);
optimise1 = (function(nodes3)
	local r_991
	r_991 = 1
	local r_1001
	r_1001 = -1
	local r_971
	r_971 = nil
	r_971 = (function(r_981)
		local _temp
		if _e_60_1(0, -1) then
			_temp = _e_60__61_1(r_981, r_991)
		else
			_temp = _e_62__61_1(r_981, r_991)
		end
		if _temp then
			local i7
			i7 = r_981
			local node8
			node8 = nth1(nodes3, i7)
			local _temp
			local r_1011
			r_1011 = _elist_63_1(node8)
			if r_1011 then
				local r_1021
				r_1021 = _e_62_1(_e_35_2(node8), 0)
				if r_1021 then
					local r_1031
					r_1031 = _esymbol_63_1(car2(node8))
					if r_1031 then
						_temp = _e_61_1(_eget_45_idx1(car2(node8), "var"), _eget_45_idx1(builtins2, "import"))
					else
						_temp = r_1031
					end
				else
					_temp = r_1021
				end
			else
				_temp = r_1011
			end
			if _temp then
				if _e_61_1(i7, _e_35_2(nodes3)) then
					_eset_45_nth_33_1(nodes3, i7, {tag = "symbol", contents = "nil", var = "table: 0x16a7df0"})
				else
					_eremove_45_nth_33_1(nodes3, i7)
				end
			else
			end
			return r_971(_e_43_1(r_981, r_1001))
		else
		end
	end);
	r_971(_e_35_2(nodes3))
	local r_1581
	r_1581 = 1
	local r_1591
	r_1591 = -1
	local r_1561
	r_1561 = nil
	r_1561 = (function(r_1571)
		local _temp
		if _e_60_1(0, -1) then
			_temp = _e_60__61_1(r_1571, r_1581)
		else
			_temp = _e_62__61_1(r_1571, r_1581)
		end
		if _temp then
			local i8
			i8 = r_1571
			local node9
			node9 = nth1(nodes3, i8)
			local _temp
			local r_1601
			r_1601 = _elist_63_1(node9)
			if r_1601 then
				local r_1611
				r_1611 = _e_62_1(_e_35_2(node9), 0)
				if r_1611 then
					local r_1621
					r_1621 = _esymbol_63_1(car2(node9))
					if r_1621 then
						_temp = _e_61_1(_eget_45_idx1(car2(node9), "var"), _eget_45_idx1(builtins2, "import"))
					else
						_temp = r_1621
					end
				else
					_temp = r_1611
				end
			else
				_temp = r_1601
			end
			if _temp then
				_eremove_45_nth_33_1(nodes3, i8)
			else
			end
			return r_1561(_e_43_1(r_1571, r_1591))
		else
		end
	end);
	r_1561(pred1(_e_35_2(nodes3)))
	local lookup4
	lookup4 = _eempty_45_struct1()
	_egather_45_definitions1(nodes3, lookup4)
	_egather_45_usages1(nodes3, lookup4)
	local r_1651
	r_1651 = 1
	local r_1661
	r_1661 = -1
	local r_1631
	r_1631 = nil
	r_1631 = (function(r_1641)
		local _temp
		if _e_60_1(0, -1) then
			_temp = _e_60__61_1(r_1641, r_1651)
		else
			_temp = _e_62__61_1(r_1641, r_1651)
		end
		if _temp then
			local i9
			i9 = r_1641
			local node10
			node10 = nth1(nodes3, i9)
			local _temp
			local r_1671
			r_1671 = _eget_45_idx1(node10, "defVar")
			if r_1671 then
				_temp = _e_33_1(_eget_45_idx1(_eget_45_idx1(lookup4, _eget_45_idx1(node10, "defVar")), "active"))
			else
				_temp = r_1671
			end
			if _temp then
				if _e_61_1(i9, _e_35_2(nodes3)) then
					_eset_45_nth_33_1(nodes3, i9, {tag = "symbol", contents = "nil", var = "table: 0x16a7df0"})
				else
					_eremove_45_nth_33_1(nodes3, i9)
				end
			else
			end
			return r_1631(_e_43_1(r_1641, r_1661))
		else
		end
	end);
	r_1631(_e_35_2(nodes3))
	return nodes3
end);
return optimise1
