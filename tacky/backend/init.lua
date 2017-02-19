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
	  setmetatable = setmetatable,
	  ['iter-pairs'] = function(tbl, fun) for k, v in pairs(tbl) do fun(k, v) end end, -- TODO: Migrate to Urn somehow
	  next = next,
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
_2e2e_1 = _libs[".."]
getIdx1 = _libs["get-idx"]
setIdx_21_1 = _libs["set-idx!"]
format1 = _libs["format"]
error_21_1 = _libs["error!"]
type_23_1 = _libs["type#"]
emptyStruct1 = _libs["empty-struct"]
require1 = _libs["require"]
unpack1 = _libs["unpack"]
number_2d3e_string1 = _libs["number->string"]
_23_1 = (function(xs1)
	return xs1["n"]
end)
list1 = (function(...)
	local xs2 = _pack(...) xs2.tag = "list"
	return xs2
end)
_21_1 = (function(expr1)
	if expr1 then
		return false
	else
		return true
	end
end)
list_3f_1 = (function(x1)
	return (type1(x1) == "list")
end)
string_3f_1 = (function(x2)
	return (type1(x2) == "string")
end)
number_3f_1 = (function(x3)
	return (type1(x3) == "number")
end)
symbol_3f_1 = (function(x4)
	return (type1(x4) == "symbol")
end)
key_3f_1 = (function(x5)
	return (type1(x5) == "key")
end)
type1 = (function(val1)
	local ty1 = type_23_1(val1)
	if (ty1 == "table") then
		local tag1 = val1["tag"]
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
	local r_121 = type1(li1)
	if (r_121 ~= "list") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_121), 2)
	else
	end
	local r_271 = type1(idx1)
	if (r_271 ~= "number") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "idx", "number", r_271), 2)
	else
	end
	return li1[idx1]
end)
_23_2 = (function(li2)
	local r_151 = type1(li2)
	if (r_151 ~= "list") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_151), 2)
	else
	end
	return _23_1(li2)
end)
car1 = (function(li3)
	return nth1(li3, 1)
end)
pushCdr_21_1 = (function(li4, val2)
	local r_181 = type1(li4)
	if (r_181 ~= "list") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_181), 2)
	else
	end
	local len1 = (_23_1(li4) + 1)
	li4["n"] = len1
	li4[len1] = val2
	return li4
end)
nil_3f_1 = (function(li5)
	return (_23_2(li5) == 0)
end)
byte1 = _libs["byte"]
concat1 = _libs["concat"]
find1 = _libs["find"]
format2 = _libs["format"]
rep1 = _libs["rep"]
replace1 = _libs["replace"]
sub1 = _libs["sub"]
upper1 = _libs["upper"]
_23_s1 = _libs["#s"]
charAt1 = (function(text1, pos1)
	return sub1(text1, pos1, pos1)
end)
_2e2e_2 = (function(...)
	local args1 = _pack(...) args1.tag = "list"
	return concat1(args1)
end)
quoted1 = (function(str1)
	local val3 = replace1(format2("%q", str1), "\n", "\\n")
	return val3
end)
struct1 = (function(...)
	local keys1 = _pack(...) keys1.tag = "list"
	if ((_23_2(keys1) % 1) == 1) then
		error_21_1("Expected an even number of arguments to struct", 2)
	else
	end
	local contents1 = (function(key1)
		return sub1(key1["contents"], 2)
	end)
	local out1 = {}
	local r_671 = _23_1(keys1)
	local r_681 = 2
	local r_651 = nil
	r_651 = (function(r_661)
		local _temp
		if (0 < 2) then
			_temp = (r_661 <= r_671)
		else
			_temp = (r_661 >= r_671)
		end
		if _temp then
			local i1 = r_661
			local key2 = keys1[i1]
			local val4 = keys1[(1 + i1)]
			out1[(function()
				if key_3f_1(key2) then
					return contents1(key2)
				else
					return key2
				end
			end)()
			] = val4
			return r_651((r_661 + r_681))
		else
		end
	end)
	r_651(1)
	return out1
end)
fail1 = (function(msg1)
	return error_21_1(msg1, 0)
end)
succ1 = (function(x6)
	return (1 + x6)
end)
pred1 = (function(x7)
	return (x7 - 1)
end)
create1 = (function()
	return struct1("out", list1(), "indent", 0, "tabs-pending", false)
end)
append_21_1 = (function(writer1, text2)
	local r_981 = type1(text2)
	if (r_981 ~= "string") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "text", "string", r_981), 2)
	else
	end
	if writer1["tabs-pending"] then
		writer1["tabs-pending"] = false
		pushCdr_21_1(writer1["out"], rep1("\t", writer1["indent"]))
	else
	end
	return pushCdr_21_1(writer1["out"], text2)
end)
line_21_1 = (function(writer2, text3)
	if text3 then
		append_21_1(writer2, text3)
	else
	end
	if writer2["tabs-pending"] then
	else
		writer2["tabs-pending"] = true
		return pushCdr_21_1(writer2["out"], "\n")
	end
end)
indent_21_1 = (function(writer3)
	writer3["indent"] = succ1(writer3["indent"])
	return nil
end)
unindent_21_1 = (function(writer4)
	writer4["indent"] = pred1(writer4["indent"])
	return nil
end)
beginBlock_21_1 = (function(writer5, text4)
	line_21_1(writer5, text4)
	return indent_21_1(writer5)
end)
nextBlock_21_1 = (function(writer6, text5)
	unindent_21_1(writer6)
	line_21_1(writer6, text5)
	return indent_21_1(writer6)
end)
endBlock_21_1 = (function(writer7, text6)
	unindent_21_1(writer7)
	return line_21_1(writer7, text6)
end)
_2d3e_string1 = (function(writer8)
	return concat1(writer8["out"])
end)
createLookup1 = (function(...)
	local lst1 = _pack(...) lst1.tag = "list"
	local out2 = {}
	local r_1031 = lst1
	local r_1061 = _23_2(r_1031)
	local r_1071 = 1
	local r_1041 = nil
	r_1041 = (function(r_1051)
		local _temp
		if (0 < 1) then
			_temp = (r_1051 <= r_1061)
		else
			_temp = (r_1051 >= r_1061)
		end
		if _temp then
			local r_1021 = r_1051
			local entry1 = r_1031[r_1021]
			out2[entry1] = true
			return r_1041((r_1051 + r_1071))
		else
		end
	end)
	r_1041(1)
	return out2
end)
keywords1 = createLookup1("and", "break", "do", "else", "elseif", "end", "false", "for", "function", "if", "in", "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while")
createState1 = (function(meta1)
	return struct1("ctr-lookup", {}, "var-lookup", {}, "meta", (function(r_1081)
		if r_1081 then
			return r_1081
		else
			return {}
		end
	end)(meta1))
end)
builtins1 = require1("tacky.analysis.resolve")["builtins"]
builtinVars1 = require1("tacky.analysis.resolve")["declaredVars"]
escape1 = (function(name1)
	if keywords1[name1] then
		return ("_e" .. name1)
	elseif find1(name1, "^%w[_%w%d]*$") then
		return name1
	else
		local out3
		if find1(charAt1(name1, 1), "%d") then
			out3 = "_e"
		else
			out3 = ""
		end
		local upper2 = false
		local esc1 = false
		local r_1171 = _23_s1(name1)
		local r_1181 = 1
		local r_1151 = nil
		r_1151 = (function(r_1161)
			local _temp
			if (0 < 1) then
				_temp = (r_1161 <= r_1171)
			else
				_temp = (r_1161 >= r_1171)
			end
			if _temp then
				local i2 = r_1161
				local char1 = charAt1(name1, i2)
				local _temp
				local r_1191 = (char1 == "-")
				if r_1191 then
					local r_1201 = find1(charAt1(name1, pred1(i2)), "[%a%d']")
					if r_1201 then
						_temp = find1(charAt1(name1, succ1(i2)), "[%a%d']")
					else
						_temp = r_1201
					end
				else
					_temp = r_1191
				end
				if _temp then
					upper2 = true
				elseif find1(char1, "[^%w%d]") then
					char1 = format2("%02x", byte1(char1))
					if esc1 then
					else
						esc1 = true
						out3 = (out3 .. "_")
					end
					out3 = (out3 .. char1)
				else
					if esc1 then
						esc1 = false
						out3 = (out3 .. "_")
					else
					end
					if upper2 then
						upper2 = false
						char1 = upper1(char1)
					else
					end
					out3 = (out3 .. char1)
				end
				return r_1151((r_1161 + r_1181))
			else
			end
		end)
		r_1151(1)
		if esc1 then
			out3 = (out3 .. "_")
		else
		end
		return out3
	end
end)
escapeVar1 = (function(var1, state1)
	if builtinVars1[var1] then
		return var1["name"]
	else
		local v1 = escape1(var1["name"])
		local id1 = state1["var-lookup"][var1]
		if id1 then
		else
			id1 = succ1((function(r_1091)
				if r_1091 then
					return r_1091
				else
					return 0
				end
			end)(state1["ctr-lookup"][v1]))
			state1["ctr-lookup"][v1] = id1
			state1["var-lookup"][var1] = id1
		end
		return (v1 .. number_2d3e_string1(id1))
	end
end)
isStatement1 = (function(node1)
	if list_3f_1(node1) then
		local first1 = car1(node1)
		if symbol_3f_1(first1) then
			return (first1["var"] == builtins1["cond"])
		elseif list_3f_1(first1) then
			local func1 = car1(first1)
			local r_1101 = symbol_3f_1(func1)
			if r_1101 then
				return (func1["var"] == builtins1["lambda"])
			else
				return r_1101
			end
		else
			return false
		end
	else
		return false
	end
end)
compileQuote1 = (function(node2, out4, state2, level1)
	if (level1 == 0) then
		return compileExpression1(node2, out4, state2)
	else
		local ty2 = type1(node2)
		if (ty2 == "string") then
			return append_21_1(out4, node2["contents"])
		elseif (ty2 == "number") then
			return append_21_1(out4, node2["contents"])
		elseif (ty2 == "symbol") then
			append_21_1(out4, ("{ tag=\"symbol\", contents=" .. quoted1(node2["contents"])))
			if node2["var"] then
				append_21_1(out4, (", var=" .. quoted1(number_2d3e_string1(node2["var"]))))
			else
			end
			return append_21_1(out4, "}")
		elseif (ty2 == "key") then
			return append_21_1(out4, _2e2e_2("{tag=\"key\", contents=", quoted1(node2["contents"]), "}"))
		elseif (ty2 == "list") then
			local first2 = car1(node2)
			local _temp
			local r_1211 = symbol_3f_1(first2)
			if r_1211 then
				local r_1221 = (first2["var"] == builtins1["unquote"])
				if r_1221 then
					_temp = r_1221
				else
					_temp = ("var" == builtins1["unquote-splice"])
				end
			else
				_temp = r_1211
			end
			if _temp then
				return compileQuote1(nth1(node2, 2), out4, state2, (function(r_1231)
					if r_1231 then
						return pred1(level1)
					else
						return r_1231
					end
				end)(level1))
			else
				local _temp
				local r_1241 = symbol_3f_1(first2)
				if r_1241 then
					_temp = (first2["var"] == builtins1["quasiquote"])
				else
					_temp = r_1241
				end
				if _temp then
					return compileQuote1(nth1(node2, 2), out4, state2, (function(r_1251)
						if r_1251 then
							return succ1(level1)
						else
							return r_1251
						end
					end)(level1))
				else
					local containsUnsplice1 = false
					local r_1271 = node2
					local r_1301 = _23_2(r_1271)
					local r_1311 = 1
					local r_1281 = nil
					r_1281 = (function(r_1291)
						local _temp
						if (0 < 1) then
							_temp = (r_1291 <= r_1301)
						else
							_temp = (r_1291 >= r_1301)
						end
						if _temp then
							local r_1261 = r_1291
							local sub2 = r_1271[r_1261]
							local _temp
							local r_1321 = list_3f_1(sub2)
							if r_1321 then
								local r_1331 = symbol_3f_1(car1(sub2))
								if r_1331 then
									_temp = (sub2[1]["var"] == builtins1["unquote-splice"])
								else
									_temp = r_1331
								end
							else
								_temp = r_1321
							end
							if _temp then
								containsUnsplice1 = true
							else
							end
							return r_1281((r_1291 + r_1311))
						else
						end
					end)
					r_1281(1)
					if containsUnsplice1 then
						local offset1 = 0
						beginBlock_21_1(out4, "(function()")
						line_21_1(out4, "local _offset, _result, _temp = 0, {tag=\"list\",n=0}")
						local r_1361 = _23_2(node2)
						local r_1371 = 1
						local r_1341 = nil
						r_1341 = (function(r_1351)
							local _temp
							if (0 < 1) then
								_temp = (r_1351 <= r_1361)
							else
								_temp = (r_1351 >= r_1361)
							end
							if _temp then
								local i3 = r_1351
								local sub3 = nth1(node2, i3)
								local _temp
								local r_1381 = list_3f_1(sub3)
								if r_1381 then
									local r_1391 = symbol_3f_1(car1(sub3))
									if r_1391 then
										_temp = (sub3[1]["var"] == builtins1["unquote-splice"])
									else
										_temp = r_1391
									end
								else
									_temp = r_1381
								end
								if _temp then
									offset1 = (offset1 + 1)
									append_21_1(out4, "_temp = ")
									compileQuote1(nth1(sub3, 2), out4, state2, pred1(level1))
									line_21_1(out4)
									line_21_1(out4, _2e2e_2("for _c = 1, _temp.n do _result[", number_2d3e_string1((i3 - offset1)), " + _c + _offset] = _temp[_c] end"))
									line_21_1(out4, "_offset = _offset + _temp.n")
								else
									append_21_1(out4, _2e2e_2("_result[", number_2d3e_string1((i3 - offset1)), " + _offset] = "))
									compileQuote1(sub3, out4, state2, level1)
									line_21_1(out4)
								end
								return r_1341((r_1351 + r_1371))
							else
							end
						end)
						r_1341(1)
						line_21_1(out4, ("_result.n = _offset + " .. number_2d3e_string1((_23_2(node2) - offset1))))
						line_21_1(out4, "return _result")
						return endBlock_21_1(out4, "end)()")
					else
						append_21_1(out4, ("{tag = \"list\", n =" .. number_2d3e_string1(_23_2(node2))))
						local r_1431 = node2
						local r_1461 = _23_2(r_1431)
						local r_1471 = 1
						local r_1441 = nil
						r_1441 = (function(r_1451)
							local _temp
							if (0 < 1) then
								_temp = (r_1451 <= r_1461)
							else
								_temp = (r_1451 >= r_1461)
							end
							if _temp then
								local r_1421 = r_1451
								local sub4 = r_1431[r_1421]
								append_21_1(out4, ", ")
								compileQuote1(sub4, out4, state2, level1)
								return r_1441((r_1451 + r_1471))
							else
							end
						end)
						r_1441(1)
						return append_21_1(out4, "}")
					end
				end
			end
		else
			return error_21_1(("Unknown type " .. ty2))
		end
	end
end)
compileExpression1 = (function(node3, out5, state3, ret1)
	if list_3f_1(node3) then
		local head1 = car1(node3)
		if symbol_3f_1(head1) then
			local var2 = head1["var"]
			if (var2 == builtins1["lambda"]) then
				if (ret1 == "") then
				else
					if ret1 then
						append_21_1(out5, ret1)
					else
					end
					local args2 = nth1(node3, 2)
					local variadic1 = nil
					local i4 = 1
					append_21_1(out5, "(function(")
					local r_1401 = nil
					r_1401 = (function()
						local _temp
						local r_1411 = (i4 <= _23_2(args2))
						if r_1411 then
							_temp = _21_1(variadic1)
						else
							_temp = r_1411
						end
						if _temp then
							if (i4 > 1) then
								append_21_1(out5, ", ")
							else
							end
							local var3 = args2[i4]["var"]
							if var3["isVariadic"] then
								append_21_1(out5, "...")
								variadic1 = i4
							else
								append_21_1(out5, escapeVar1(var3, state3))
							end
							i4 = (i4 + 1)
							return r_1401()
						else
						end
					end)
					r_1401()
					beginBlock_21_1(out5, ")")
					if variadic1 then
						local argsVar1 = escapeVar1(args2[variadic1]["var"], state3)
						if (variadic1 == _23_2(args2)) then
							line_21_1(out5, _2e2e_2("local ", argsVar1, " = _pack(...) ", argsVar1, ".tag = \"list\""))
						else
							local remaining1 = (_23_2(args2) - variadic1)
							line_21_1(out5, ("local _n = _select(\"#\", ...) - " .. number_2d3e_string1(remaining1)))
							append_21_1(out5, ("local " .. argsVar1))
							local r_1501 = _23_2(args2)
							local r_1511 = 1
							local r_1481 = nil
							r_1481 = (function(r_1491)
								local _temp
								if (0 < 1) then
									_temp = (r_1491 <= r_1501)
								else
									_temp = (r_1491 >= r_1501)
								end
								if _temp then
									local i5 = r_1491
									append_21_1(out5, ", ")
									append_21_1(out5, escapeVar1(args2[i5]["var"], state3))
									return r_1481((r_1491 + r_1511))
								else
								end
							end)
							r_1481(succ1(variadic1))
							line_21_1(out5)
							beginBlock_21_1(out5, "if _n > 0 then")
							append_21_1(out5, argsVar1)
							line_21_1(out5, " = { tag=\"list\", n=_n, _unpack(_pack(...), 1, _n)}")
							local r_1541 = _23_2(args2)
							local r_1551 = 1
							local r_1521 = nil
							r_1521 = (function(r_1531)
								local _temp
								if (0 < 1) then
									_temp = (r_1531 <= r_1541)
								else
									_temp = (r_1531 >= r_1541)
								end
								if _temp then
									local i6 = r_1531
									append_21_1(out5, escapeVar1(args2[i6]["var"], state3))
									if (i6 < _23_2(args2)) then
										append_21_1(out5, ", ")
									else
									end
									return r_1521((r_1531 + r_1551))
								else
								end
							end)
							r_1521(succ1(variadic1))
							line_21_1(out5, " = select(_n + 1, ...)")
							nextBlock_21_1(out5, "else")
							append_21_1(out5, argsVar1)
							line_21_1(out5, " = { tag=\"list\", n=0}")
							local r_1581 = _23_2(args2)
							local r_1591 = 1
							local r_1561 = nil
							r_1561 = (function(r_1571)
								local _temp
								if (0 < 1) then
									_temp = (r_1571 <= r_1581)
								else
									_temp = (r_1571 >= r_1581)
								end
								if _temp then
									local i7 = r_1571
									append_21_1(out5, escapeVar1(args2[i7]["var"], state3))
									if (i7 < _23_2(args2)) then
										append_21_1(out5, ", ")
									else
									end
									return r_1561((r_1571 + r_1591))
								else
								end
							end)
							r_1561(succ1(variadic1))
							line_21_1(out5, " = ...")
							endBlock_21_1(out5, "end")
						end
					else
					end
					compileBlock1(node3, out5, state3, 3, "return ")
					unindent_21_1(out5)
					return append_21_1(out5, "end)")
				end
			elseif (var2 == builtins1["cond"]) then
				local closure1 = _21_1(ret1)
				local hadFinal1 = false
				local ends1 = 1
				if closure1 then
					beginBlock_21_1(out5, "(function()")
					ret1 = "return "
				else
				end
				local i8 = 2
				local r_1601 = nil
				r_1601 = (function()
					if (i8 <= _23_2(node3)) then
						local item1 = nth1(node3, i8)
						local case1 = nth1(item1, 1)
						local isFinal1
						local r_1611 = symbol_3f_1(case1)
						if r_1611 then
							isFinal1 = (case1["var"] == builtinVars1["true"])
						else
							isFinal1 = r_1611
						end
						if isFinal1 then
							if (i8 == 2) then
								append_21_1(out5, "do")
							else
							end
						elseif isStatement1(case1) then
							if (i8 > 2) then
								indent_21_1(out5)
								line_21_1(out5)
								ends1 = (ends1 + 1)
							else
							end
							line_21_1(out5, "local _temp")
							compileExpression1(case1, out5, state3, "_temp = ")
							line_21_1(out5)
							line_21_1(out5, "if _temp then")
						else
							append_21_1(out5, "if ")
							compileExpression1(case1, out5, state3)
							append_21_1(out5, " then")
						end
						indent_21_1(out5)
						line_21_1(out5)
						compileBlock1(item1, out5, state3, 2, ret1)
						unindent_21_1(out5)
						if isFinal1 then
							hadFinal1 = true
						else
							append_21_1(out5, "else")
						end
						i8 = (i8 + 1)
						return r_1601()
					else
					end
				end)
				r_1601()
				if hadFinal1 then
				else
					indent_21_1(out5)
					line_21_1(out5)
					append_21_1(out5, "_error(\"unmatched item\")")
					unindent_21_1(out5)
					line_21_1(out5)
				end
				local r_1641 = ends1
				local r_1651 = 1
				local r_1621 = nil
				r_1621 = (function(r_1631)
					local _temp
					if (0 < 1) then
						_temp = (r_1631 <= r_1641)
					else
						_temp = (r_1631 >= r_1641)
					end
					if _temp then
						local i9 = r_1631
						append_21_1(out5, "end")
						if (i9 < ends1) then
							unindent_21_1(out5)
							line_21_1(out5)
						else
						end
						return r_1621((r_1631 + r_1651))
					else
					end
				end)
				r_1621(1)
				if closure1 then
					line_21_1(out5)
					return endBlock_21_1(out5, "end)()")
				else
				end
			elseif (var2 == builtins1["set!"]) then
				compileExpression1(nth1(node3, 3), out5, state3, (escapeVar1(node3[2]["var"], state3) .. " = "))
				local _temp
				local r_1661 = ret1
				if r_1661 then
					_temp = (ret1 ~= "")
				else
					_temp = r_1661
				end
				if _temp then
					line_21_1(out5)
					append_21_1(out5, ret1)
					return append_21_1(out5, "nil")
				else
				end
			elseif (var2 == builtins1["define"]) then
				return compileExpression1(nth1(node3, 3), out5, state3, (escapeVar1(node3["defVar"], state3) .. " = "))
			elseif (var2 == builtins1["define-macro"]) then
				return compileExpression1(nth1(node3, 3), out5, state3, (escapeVar1(node3["defVar"], state3) .. " = "))
			elseif (var2 == builtins1["define-native"]) then
				return append_21_1(out5, format2("%s = _libs[%q]", escapeVar1(node3["defVar"], state3), node3["defVar"]["fullName"]))
			elseif (var2 == builtins1["quote"]) then
				if (ret1 == "") then
				else
					if ret1 then
						append_21_1(out5, ret1)
					else
					end
					return compileQuote1(nth1(node3, 2), out5, state3)
				end
			elseif (var2 == builtins1["quasiquote"]) then
				if (ret1 == "") then
					append_21_1(out5, "local _ =")
				elseif ret1 then
					append_21_1(out5, ret1)
				else
					_error("unmatched item")
				end
				return compileQuote1(nth1(node3, 2), out5, state3, 1)
			elseif (var2 == builtins1["unquote"]) then
				return fail1("unquote outside of quasiquote")
			elseif (var2 == builtins1["unquote-splice"]) then
				return fail1("unquote-splice outside of quasiquote")
			elseif (var2 == builtins1["import"]) then
				if (ret1 == nil) then
					return append_21_1(out5, "nil")
				elseif (ret1 ~= "") then
					append_21_1(out5, ret1)
					return append_21_1(out5, "nil")
				else
				end
			else
				local meta2
				local r_1801 = symbol_3f_1(head1)
				if r_1801 then
					local r_1811 = (head1["var"]["tag"] == "native")
					if r_1811 then
						meta2 = state3["meta"][head1["var"]["fullName"]]
					else
						meta2 = r_1811
					end
				else
					meta2 = r_1801
				end
				local _temp
				local r_1671 = meta2
				if r_1671 then
					local r_1681
					local r_1691 = ret1
					if r_1691 then
						r_1681 = r_1691
					else
						r_1681 = (meta2["tag"] == "expr")
					end
					if r_1681 then
						_temp = (pred1(_23_2(node3)) == meta2["count"])
					else
						_temp = r_1681
					end
				else
					_temp = r_1671
				end
				if _temp then
					local _temp
					local r_1701 = ret1
					if r_1701 then
						_temp = (meta2["tag"] == "expr")
					else
						_temp = r_1701
					end
					if _temp then
						append_21_1(out5, ret1)
					else
					end
					local contents2 = meta2["contents"]
					local r_1731 = _23_2(contents2)
					local r_1741 = 1
					local r_1711 = nil
					r_1711 = (function(r_1721)
						local _temp
						if (0 < 1) then
							_temp = (r_1721 <= r_1731)
						else
							_temp = (r_1721 >= r_1731)
						end
						if _temp then
							local i10 = r_1721
							local entry2 = nth1(contents2, i10)
							if number_3f_1(entry2) then
								compileExpression1(nth1(node3, succ1(entry2)), out5, state3)
							else
								append_21_1(out5, entry2)
							end
							return r_1711((r_1721 + r_1741))
						else
						end
					end)
					r_1711(1)
					local _temp
					local r_1751 = (meta2["tag"] ~= "expr")
					if r_1751 then
						_temp = (ret1 ~= "")
					else
						_temp = r_1751
					end
					if _temp then
						line_21_1(out5)
						append_21_1(out5, ret1)
						append_21_1(out5, "nil")
						return line_21_1(out5)
					else
					end
				else
					if ret1 then
						append_21_1(out5, ret1)
					else
					end
					compileExpression1(head1, out5, state3)
					append_21_1(out5, "(")
					local r_1781 = _23_2(node3)
					local r_1791 = 1
					local r_1761 = nil
					r_1761 = (function(r_1771)
						local _temp
						if (0 < 1) then
							_temp = (r_1771 <= r_1781)
						else
							_temp = (r_1771 >= r_1781)
						end
						if _temp then
							local i11 = r_1771
							if (i11 > 2) then
								append_21_1(out5, ", ")
							else
							end
							compileExpression1(nth1(node3, i11), out5, state3)
							return r_1761((r_1771 + r_1791))
						else
						end
					end)
					r_1761(2)
					return append_21_1(out5, ")")
				end
			end
		else
			local _temp
			local r_1821 = ret1
			if r_1821 then
				local r_1831 = list_3f_1(head1)
				if r_1831 then
					local r_1841 = symbol_3f_1(car1(head1))
					if r_1841 then
						_temp = (head1[1]["var"] == builtins1["lambda"])
					else
						_temp = r_1841
					end
				else
					_temp = r_1831
				end
			else
				_temp = r_1821
			end
			if _temp then
				local args3 = nth1(head1, 2)
				local offset2 = 1
				local r_1871 = _23_2(args3)
				local r_1881 = 1
				local r_1851 = nil
				r_1851 = (function(r_1861)
					local _temp
					if (0 < 1) then
						_temp = (r_1861 <= r_1871)
					else
						_temp = (r_1861 >= r_1871)
					end
					if _temp then
						local i12 = r_1861
						local var4 = args3[i12]["var"]
						append_21_1(out5, ("local " .. escapeVar1(var4, state3)))
						if var4["isVariadic"] then
							local count1 = (_23_2(node3) - _23_2(args3))
							if (count1 < 0) then
								count1 = 0
							else
							end
							append_21_1(out5, " = { tag=\"list\", n=")
							append_21_1(out5, number_2d3e_string1(count1))
							local r_1911 = count1
							local r_1921 = 1
							local r_1891 = nil
							r_1891 = (function(r_1901)
								local _temp
								if (0 < 1) then
									_temp = (r_1901 <= r_1911)
								else
									_temp = (r_1901 >= r_1911)
								end
								if _temp then
									local j1 = r_1901
									append_21_1(out5, ", ")
									compileExpression1(nth1(node3, (i12 + j1)), out5, state3)
									return r_1891((r_1901 + r_1921))
								else
								end
							end)
							r_1891(1)
							offset2 = count1
							line_21_1(out5, "}")
						else
							local expr2 = nth1(node3, (i12 + offset2))
							local name2 = escapeVar1(var4, state3)
							local ret2 = nil
							if expr2 then
								if isStatement1(expr2) then
									ret2 = (name2 .. " = ")
									line_21_1(out5)
								else
									append_21_1(out5, " = ")
								end
								compileExpression1(expr2, out5, state3, ret2)
								line_21_1(out5)
							else
								line_21_1(out5)
							end
						end
						return r_1851((r_1861 + r_1881))
					else
					end
				end)
				r_1851(1)
				local r_1951 = _23_2(node3)
				local r_1961 = 1
				local r_1931 = nil
				r_1931 = (function(r_1941)
					local _temp
					if (0 < 1) then
						_temp = (r_1941 <= r_1951)
					else
						_temp = (r_1941 >= r_1951)
					end
					if _temp then
						local i13 = r_1941
						compileExpression1(nth1(node3, i13), out5, state3, "")
						line_21_1(out5)
						return r_1931((r_1941 + r_1961))
					else
					end
				end)
				r_1931((_23_2(args3) + (offset2 + 1)))
				return compileBlock1(head1, out5, state3, 3, ret1)
			else
				if ret1 then
					append_21_1(out5, ret1)
				else
				end
				compileExpression1(car1(node3), out5, state3)
				append_21_1(out5, "(")
				local r_1991 = _23_2(node3)
				local r_2001 = 1
				local r_1971 = nil
				r_1971 = (function(r_1981)
					local _temp
					if (0 < 1) then
						_temp = (r_1981 <= r_1991)
					else
						_temp = (r_1981 >= r_1991)
					end
					if _temp then
						local i14 = r_1981
						if (i14 > 2) then
							append_21_1(out5, ", ")
						else
						end
						compileExpression1(nth1(node3, i14), out5, state3)
						return r_1971((r_1981 + r_2001))
					else
					end
				end)
				r_1971(2)
				return append_21_1(out5, ")")
			end
		end
	else
		if (ret1 == "") then
		else
			if ret1 then
				append_21_1(out5, ret1)
			else
			end
			if symbol_3f_1(node3) then
				return append_21_1(out5, escapeVar1(node3["var"], state3))
			elseif string_3f_1(node3) then
				return append_21_1(out5, node3["contents"])
			elseif number_3f_1(node3) then
				return append_21_1(out5, number_2d3e_string1(node3["contents"]))
			elseif key_3f_1(node3) then
				return append_21_1(out5, quoted1(sub1(node3["contents"], 2)))
			else
				return error_21_1(("Unknown type: " .. type1(node3)))
			end
		end
	end
end)
compileBlock1 = (function(nodes1, out6, state4, start1, ret3)
	local r_1131 = _23_2(nodes1)
	local r_1141 = 1
	local r_1111 = nil
	r_1111 = (function(r_1121)
		local _temp
		if (0 < 1) then
			_temp = (r_1121 <= r_1131)
		else
			_temp = (r_1121 >= r_1131)
		end
		if _temp then
			local i15 = r_1121
			local ret_27_1
			if (i15 == _23_2(nodes1)) then
				ret_27_1 = ret3
			else
				ret_27_1 = ""
			end
			compileExpression1(nth1(nodes1, i15), out6, state4, ret_27_1)
			line_21_1(out6)
			return r_1111((r_1121 + r_1141))
		else
		end
	end)
	return r_1111(start1)
end)
prelude1 = (function(out7)
	line_21_1(out7, "if not table.pack then table.pack = function(...) return { n = select(\"#\", ...), ... } end end")
	line_21_1(out7, "if not table.unpack then table.unpack = unpack end")
	line_21_1(out7, "if _VERSION:find(\"5.1\") then local function load(x, _, _, env) local f, e = loadstring(x); if not f then error(e, 1) end; return setfenv(f, env) end end")
	return line_21_1(out7, "local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error")
end)
backend1 = struct1("createState", createState1, "escape", escape1, "escapeVar", escapeVar1, "block", compileBlock1, "expression", compileExpression1, "prelude", prelude1)
estimateLength1 = (function(node4, max1)
	local tag2 = node4["tag"]
	local _temp
	local r_2011 = (tag2 == "string")
	if r_2011 then
		_temp = r_2011
	else
		local r_2021 = (tag2 == "number")
		if r_2021 then
			_temp = r_2021
		else
			local r_2031 = (tag2 == "symbol")
			if r_2031 then
				_temp = r_2031
			else
				_temp = (tag2 == "key")
			end
		end
	end
	if _temp then
		return _23_s1(number_2d3e_string1(node4["contents"]))
	elseif (tag2 == "list") then
		local sum1 = 2
		local i16 = 1
		local r_2131 = nil
		r_2131 = (function()
			local _temp
			local r_2141 = (sum1 <= max1)
			if r_2141 then
				_temp = (i16 <= _23_2(node4))
			else
				_temp = r_2141
			end
			if _temp then
				sum1 = (sum1 + estimateLength1(nth1(node4, i16), (max1 - sum1)))
				if (i16 > 1) then
					sum1 = (sum1 + 1)
				else
				end
				i16 = (i16 + 1)
				return r_2131()
			else
			end
		end)
		r_2131()
		return sum1
	else
		return fail1(("Unknown tag " .. tag2))
	end
end)
expression1 = (function(node5, writer9)
	local tag3 = node5["tag"]
	local _temp
	local r_2041 = (tag3 == "string")
	if r_2041 then
		_temp = r_2041
	else
		local r_2051 = (tag3 == "number")
		if r_2051 then
			_temp = r_2051
		else
			local r_2061 = (tag3 == "symbol")
			if r_2061 then
				_temp = r_2061
			else
				_temp = (tag3 == "key")
			end
		end
	end
	if _temp then
		return append_21_1(writer9, number_2d3e_string1(node5["contents"]))
	elseif (tag3 == "list") then
		append_21_1(writer9, "(")
		if nil_3f_1(node5) then
			return append_21_1(writer9, ")")
		else
			local newline1 = false
			local max2 = (60 - estimateLength1(car1(node5), 60))
			expression1(car1(node5), writer9)
			if (max2 <= 0) then
				newline1 = true
				indent_21_1(writer9)
			else
			end
			local r_2171 = _23_2(node5)
			local r_2181 = 1
			local r_2151 = nil
			r_2151 = (function(r_2161)
				local _temp
				if (0 < 1) then
					_temp = (r_2161 <= r_2171)
				else
					_temp = (r_2161 >= r_2171)
				end
				if _temp then
					local i17 = r_2161
					local entry3 = nth1(node5, i17)
					local _temp
					local r_2191 = _21_1(newline1)
					if r_2191 then
						_temp = (max2 > 0)
					else
						_temp = r_2191
					end
					if _temp then
						max2 = (max2 - estimateLength1(entry3, max2))
						if (max2 <= 0) then
							newline1 = true
							indent_21_1(writer9)
						else
						end
					else
					end
					if newline1 then
						line_21_1(writer9)
					else
						append_21_1(writer9, " ")
					end
					expression1(entry3, writer9)
					return r_2151((r_2161 + r_2181))
				else
				end
			end)
			r_2151(2)
			if newline1 then
				unindent_21_1(writer9)
			else
			end
			return append_21_1(writer9, ")")
		end
	else
		return fail1(("Unknown tag " .. tag3))
	end
end)
block1 = (function(list2, writer10)
	local r_2081 = list2
	local r_2111 = _23_2(r_2081)
	local r_2121 = 1
	local r_2091 = nil
	r_2091 = (function(r_2101)
		local _temp
		if (0 < 1) then
			_temp = (r_2101 <= r_2111)
		else
			_temp = (r_2101 >= r_2111)
		end
		if _temp then
			local r_2071 = r_2101
			local node6 = r_2081[r_2071]
			expression1(node6, writer10)
			line_21_1(writer10)
			return r_2091((r_2101 + r_2121))
		else
		end
	end)
	return r_2091(1)
end)
backend2 = struct1("expression", expression1, "block", block1)
wrapGenerate1 = (function(func2)
	return (function(node7, ...)
		local args4 = _pack(...) args4.tag = "list"
		local writer11 = create1()
		func2(node7, writer11, unpack1(args4))
		return _2d3e_string1(writer11)
	end)
end)
wrapNormal1 = (function(func3)
	return (function(...)
		local args5 = _pack(...) args5.tag = "list"
		local writer12 = create1()
		func3(writer12, unpack1(args5))
		return _2d3e_string1(writer12)
	end)
end)
return struct1("lua", struct1("expression", wrapGenerate1(compileExpression1), "block", wrapGenerate1(compileBlock1), "prelude", wrapNormal1(prelude1), "backend", backend1), "lisp", struct1("expression", wrapGenerate1(expression1), "block", wrapGenerate1(block1), "backend", backend2))
