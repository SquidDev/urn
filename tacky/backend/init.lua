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
car1 = (function(li3)
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
	local val3
	val3 = replace1(format2("%q", str1), "\n", "\\n")
	return val3
end)
struct1 = (function(...)
	local keys1 = _pack(...) keys1.tag = "list"
	if ((_23_2(keys1) % 1) == 1) then
		error_21_1("Expected an even number of arguments to struct", 2)
	else
	end
	local contents1, out1
	contents1 = (function(key1)
		return sub1(key1["contents"], 2)
	end)
	out1 = {}
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
			local key2, val4
			key2 = keys1[i1]
			val4 = keys1[(1 + i1)]
			out1[(function()
				if key_3f_1(key2) then
					return contents1(key2)
				else
					return key2
				end
			end)()
			] = val4
			return r_641((r_651 + r_671))
		else
		end
	end)
	r_641(1)
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
	local r_971
	r_971 = type1(text2)
	if (r_971 ~= "string") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "text", "string", r_971), 2)
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
	local out2
	out2 = {}
	local r_1021
	r_1021 = lst1
	local r_1051
	r_1051 = _23_2(r_1021)
	local r_1061
	r_1061 = 1
	local r_1031
	r_1031 = nil
	r_1031 = (function(r_1041)
		if (function()
			if (0 < 1) then
				return (r_1041 <= r_1051)
			else
				return (r_1041 >= r_1051)
			end
		end)()
		 then
			local r_1011
			r_1011 = r_1041
			local entry1
			entry1 = r_1021[r_1011]
			out2[entry1] = true
			return r_1031((r_1041 + r_1061))
		else
		end
	end)
	r_1031(1)
	return out2
end)
keywords1 = createLookup1("and", "break", "do", "else", "elseif", "end", "false", "for", "function", "if", "in", "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while")
createState1 = (function(meta1)
	return struct1("ctr-lookup", {}, "var-lookup", {}, "meta", (function(r_1071)
		if r_1071 then
			return r_1071
		else
			return {}
		end
	end)
	(meta1))
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
		local upper2
		upper2 = false
		local esc1
		esc1 = false
		local r_1161
		r_1161 = _23_s1(name1)
		local r_1171
		r_1171 = 1
		local r_1141
		r_1141 = nil
		r_1141 = (function(r_1151)
			if (function()
				if (0 < 1) then
					return (r_1151 <= r_1161)
				else
					return (r_1151 >= r_1161)
				end
			end)()
			 then
				local i2
				i2 = r_1151
				local char1
				char1 = charAt1(name1, i2)
				if (function(r_1181)
					if r_1181 then
						local r_1191
						r_1191 = find1(charAt1(name1, pred1(i2)), "[%a%d']")
						if r_1191 then
							return find1(charAt1(name1, succ1(i2)), "[%a%d']")
						else
							return r_1191
						end
					else
						return r_1181
					end
				end)
				((char1 == "-")) then
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
				return r_1141((r_1151 + r_1171))
			else
			end
		end)
		r_1141(1)
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
		local v1
		v1 = escape1(var1["name"])
		local id1
		id1 = state1["var-lookup"][var1]
		if id1 then
		else
			id1 = succ1((function(r_1081)
				if r_1081 then
					return r_1081
				else
					return 0
				end
			end)
			(state1["ctr-lookup"][v1]))
			state1["ctr-lookup"][v1] = id1
			state1["var-lookup"][var1] = id1
		end
		return (v1 .. number_2d3e_string1(id1))
	end
end)
isStatement1 = (function(node1)
	if list_3f_1(node1) then
		local first1
		first1 = car1(node1)
		if symbol_3f_1(first1) then
			return (first1["var"] == builtins1["cond"])
		elseif list_3f_1(first1) then
			local func1
			func1 = car1(first1)
			local r_1091
			r_1091 = symbol_3f_1(func1)
			if r_1091 then
				return (func1["var"] == builtins1["lambda"])
			else
				return r_1091
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
		local ty2
		ty2 = type1(node2)
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
			return append_21_1(out4, _2e2e_2("{tag=\"key\" contents=", quoted1(node2["contents"]), "}"))
		elseif (ty2 == "list") then
			local first2
			first2 = car1(node2)
			if (function(r_1201)
				if r_1201 then
					local r_1211
					r_1211 = (first2["var"] == builtins1["unquote"])
					if r_1211 then
						return r_1211
					else
						return ("var" == builtins1["unquote-splice"])
					end
				else
					return r_1201
				end
			end)
			(symbol_3f_1(first2)) then
				return compileQuote1(nth1(node2, 2), out4, state2, (function(r_1221)
					if r_1221 then
						return pred1(level1)
					else
						return r_1221
					end
				end)
				(level1))
			elseif (function(r_1231)
				if r_1231 then
					return (first2["var"] == builtins1["quasiquote"])
				else
					return r_1231
				end
			end)
			(symbol_3f_1(first2)) then
				return compileQuote1(nth1(node2, 2), out4, state2, (function(r_1241)
					if r_1241 then
						return succ1(level1)
					else
						return r_1241
					end
				end)
				(level1))
			else
				local containsUnsplice1
				containsUnsplice1 = false
				local r_1261
				r_1261 = node2
				local r_1291
				r_1291 = _23_2(r_1261)
				local r_1301
				r_1301 = 1
				local r_1271
				r_1271 = nil
				r_1271 = (function(r_1281)
					if (function()
						if (0 < 1) then
							return (r_1281 <= r_1291)
						else
							return (r_1281 >= r_1291)
						end
					end)()
					 then
						local r_1251
						r_1251 = r_1281
						local sub2
						sub2 = r_1261[r_1251]
						if (function(r_1311)
							if r_1311 then
								local r_1321
								r_1321 = symbol_3f_1(car1(sub2))
								if r_1321 then
									return (sub2[1]["var"] == builtins1["unquote-splice"])
								else
									return r_1321
								end
							else
								return r_1311
							end
						end)
						(list_3f_1(sub2)) then
							containsUnsplice1 = true
						else
						end
						return r_1271((r_1281 + r_1301))
					else
					end
				end)
				r_1271(1)
				if containsUnsplice1 then
					local offset1
					offset1 = 0
					beginBlock_21_1(out4, "(function()")
					line_21_1(out4, "local _offset, _result, _temp = 0, {tag=\"list\",n=0}")
					local r_1351
					r_1351 = _23_2(node2)
					local r_1361
					r_1361 = 1
					local r_1331
					r_1331 = nil
					r_1331 = (function(r_1341)
						if (function()
							if (0 < 1) then
								return (r_1341 <= r_1351)
							else
								return (r_1341 >= r_1351)
							end
						end)()
						 then
							local i3
							i3 = r_1341
							local sub3
							sub3 = nth1(node2, i3)
							if (function(r_1371)
								if r_1371 then
									local r_1381
									r_1381 = symbol_3f_1(car1(sub3))
									if r_1381 then
										return (sub3[1]["var"] == builtins1["unquote-splice"])
									else
										return r_1381
									end
								else
									return r_1371
								end
							end)
							(list_3f_1(sub3)) then
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
							return r_1331((r_1341 + r_1361))
						else
						end
					end)
					r_1331(1)
					line_21_1(out4, ("_result.n = _offset + " .. number_2d3e_string1((_23_2(node2) - offset1))))
					line_21_1(out4, "return _result")
					return endBlock_21_1(out4, "end)()")
				else
					append_21_1(out4, ("{tag = \"list\", n =" .. number_2d3e_string1(_23_2(node2))))
					local r_1421
					r_1421 = node2
					local r_1451
					r_1451 = _23_2(r_1421)
					local r_1461
					r_1461 = 1
					local r_1431
					r_1431 = nil
					r_1431 = (function(r_1441)
						if (function()
							if (0 < 1) then
								return (r_1441 <= r_1451)
							else
								return (r_1441 >= r_1451)
							end
						end)()
						 then
							local r_1411
							r_1411 = r_1441
							local sub4
							sub4 = r_1421[r_1411]
							append_21_1(out4, ", ")
							compileQuote1(sub4, out4, state2, level1)
							return r_1431((r_1441 + r_1461))
						else
						end
					end)
					r_1431(1)
					return append_21_1(out4, "}")
				end
			end
		else
			return error_21_1(("Unknown type " .. ty2))
		end
	end
end)
compileExpression1 = (function(node3, out5, state3, ret1)
	if list_3f_1(node3) then
		local head1
		head1 = car1(node3)
		if symbol_3f_1(head1) then
			local var2
			var2 = head1["var"]
			if (var2 == builtins1["lambda"]) then
				if (ret1 == "") then
				else
					if ret1 then
						append_21_1(out5, ret1)
					else
					end
					local args2
					args2 = nth1(node3, 2)
					local variadic1
					variadic1 = nil
					local i4
					i4 = 1
					append_21_1(out5, "(function(")
					local r_1391
					r_1391 = nil
					r_1391 = (function()
						if (function(r_1401)
							if r_1401 then
								return _21_1(variadic1)
							else
								return r_1401
							end
						end)
						((i4 <= _23_2(args2))) then
							if (i4 > 1) then
								append_21_1(out5, ", ")
							else
							end
							local var3
							var3 = args2[i4]["var"]
							if var3["isVariadic"] then
								append_21_1(out5, "...")
								variadic1 = i4
							else
								append_21_1(out5, escapeVar1(var3, state3))
							end
							i4 = (i4 + 1)
							return r_1391()
						else
						end
					end)
					r_1391()
					beginBlock_21_1(out5, ")")
					if variadic1 then
						local argsVar1
						argsVar1 = escapeVar1(args2[variadic1]["var"], state3)
						if (variadic1 == _23_2(args2)) then
							line_21_1(out5, _2e2e_2("local ", argsVar1, " = _pack(...) ", argsVar1, ".tag = \"list\""))
						else
							local remaining1
							remaining1 = (_23_2(args2) - variadic1)
							line_21_1(out5, ("local _n = _select(\"#\", ...) - " .. number_2d3e_string1(remaining1)))
							append_21_1(out5, ("local " .. argsVar1))
							local r_1491
							r_1491 = _23_2(args2)
							local r_1501
							r_1501 = 1
							local r_1471
							r_1471 = nil
							r_1471 = (function(r_1481)
								if (function()
									if (0 < 1) then
										return (r_1481 <= r_1491)
									else
										return (r_1481 >= r_1491)
									end
								end)()
								 then
									local i5
									i5 = r_1481
									append_21_1(out5, ", ")
									append_21_1(out5, escapeVar1(args2[i5]["var"], state3))
									return r_1471((r_1481 + r_1501))
								else
								end
							end)
							r_1471(succ1(variadic1))
							line_21_1(out5)
							beginBlock_21_1(out5, "if _n > 0 then")
							append_21_1(out5, argsVar1)
							line_21_1(out5, " = { tag=\"list\", n=_n, _unpack(_pack(...), 1, _n)}")
							local r_1531
							r_1531 = _23_2(args2)
							local r_1541
							r_1541 = 1
							local r_1511
							r_1511 = nil
							r_1511 = (function(r_1521)
								if (function()
									if (0 < 1) then
										return (r_1521 <= r_1531)
									else
										return (r_1521 >= r_1531)
									end
								end)()
								 then
									local i6
									i6 = r_1521
									append_21_1(out5, escapeVar1(args2[i6]["var"], state3))
									if (i6 < _23_2(args2)) then
										append_21_1(out5, ", ")
									else
									end
									return r_1511((r_1521 + r_1541))
								else
								end
							end)
							r_1511(succ1(variadic1))
							line_21_1(out5, " = select(_n + 1, ...)")
							nextBlock_21_1(out5, "else")
							append_21_1(out5, argsVar1)
							line_21_1(out5, " = { tag=\"list\", n=0}")
							local r_1571
							r_1571 = _23_2(args2)
							local r_1581
							r_1581 = 1
							local r_1551
							r_1551 = nil
							r_1551 = (function(r_1561)
								if (function()
									if (0 < 1) then
										return (r_1561 <= r_1571)
									else
										return (r_1561 >= r_1571)
									end
								end)()
								 then
									local i7
									i7 = r_1561
									append_21_1(out5, escapeVar1(args2[i7]["var"], state3))
									if (i7 < _23_2(args2)) then
										append_21_1(out5, ", ")
									else
									end
									return r_1551((r_1561 + r_1581))
								else
								end
							end)
							r_1551(succ1(variadic1))
							line_21_1(out5, " = ...")
							endBlock_21_1(out5, "end")
						end
					else
					end
					compileBlock1(node3, out5, state3, 3, "return ")
					return endBlock_21_1(out5, "end)")
				end
			elseif (var2 == builtins1["cond"]) then
				local closure1, hadFinal1, ends1
				closure1 = _21_1(ret1)
				hadFinal1 = false
				ends1 = 1
				if closure1 then
					beginBlock_21_1(out5, "(function()")
					ret1 = "return "
				else
				end
				local i8
				i8 = 2
				local r_1591
				r_1591 = nil
				r_1591 = (function()
					if (i8 <= _23_2(node3)) then
						local item1
						item1 = nth1(node3, i8)
						local case1
						case1 = nth1(item1, 1)
						local isFinal1
						local r_1601
						r_1601 = symbol_3f_1(case1)
						if r_1601 then
							isFinal1 = (case1["var"] == builtinVars1["true"])
						else
							isFinal1 = r_1601
						end
						if isFinal1 then
							if (i8 == 2) then
								append_21_1(out5, "do")
							else
							end
						elseif isStatement1(cond1) then
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
						return r_1591()
					else
					end
				end)
				r_1591()
				if hadFinal1 then
				else
					indent_21_1(out5)
					line_21_1(out5)
					append_21_1(out5, "_error(\"unmatched item\")")
				end
				local r_1631
				r_1631 = ends1
				local r_1641
				r_1641 = 1
				local r_1611
				r_1611 = nil
				r_1611 = (function(r_1621)
					if (function()
						if (0 < 1) then
							return (r_1621 <= r_1631)
						else
							return (r_1621 >= r_1631)
						end
					end)()
					 then
						local i9
						i9 = r_1621
						append_21_1(out5, "end")
						if (i9 < ends1) then
							unindent_21_1(out5)
							line_21_1(out5)
						else
						end
						return r_1611((r_1621 + r_1641))
					else
					end
				end)
				r_1611(1)
				if closure1 then
					line_21_1(out5)
					return endBlock_21_1(out5, "end)()")
				else
				end
			elseif (var2 == builtins1["set!"]) then
				compileExpression1(nth1(node3, 3), out5, state3, (escapeVar1(node3[2]["var"], state3) .. " = "))
				if (function(r_1651)
					if r_1651 then
						return (ret1 ~= "")
					else
						return r_1651
					end
				end)
				(ret1) then
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
				return append_21_1(out5, format2("%s = _libs[%q]", escapeVar1(node3["defVar"], state3), node3[2]["contents"]))
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
					_error("unmatched item")end
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
					local r_1791
					r_1791 = symbol_3f_1(head1)
					if r_1791 then
						local r_1801
						r_1801 = (head1["var"]["tag"] == "native")
						if r_1801 then
							meta2 = state3["meta"][head1["var"]["name"]]
						else
							meta2 = r_1801
						end
					else
						meta2 = r_1791
					end
					if (function(r_1661)
						if r_1661 then
							local r_1671
							local r_1681
							r_1681 = ret1
							if r_1681 then
								r_1671 = r_1681
							else
								r_1671 = (meta2["tag"] == "expr")
							end
							if r_1671 then
								return (pred1(_23_2(node3)) == meta2["count"])
							else
								return r_1671
							end
						else
							return r_1661
						end
					end)
					(meta2) then
						if (function(r_1691)
							if r_1691 then
								return (meta2["tag"] == "expr")
							else
								return r_1691
							end
						end)
						(ret1) then
							append_21_1(out5, ret1)
						else
						end
						local contents2
						contents2 = meta2["contents"]
						local r_1721
						r_1721 = _23_2(contents2)
						local r_1731
						r_1731 = 1
						local r_1701
						r_1701 = nil
						r_1701 = (function(r_1711)
							if (function()
								if (0 < 1) then
									return (r_1711 <= r_1721)
								else
									return (r_1711 >= r_1721)
								end
							end)()
							 then
								local i10
								i10 = r_1711
								local entry2
								entry2 = nth1(contents2, i10)
								if number_3f_1(entry2) then
									compileExpression1(nth1(node3, succ1(entry2)), out5, state3)
								else
									append_21_1(out5, entry2)
								end
								return r_1701((r_1711 + r_1731))
							else
							end
						end)
						r_1701(1)
						if (function(r_1741)
							if r_1741 then
								return (ret1 ~= "")
							else
								return r_1741
							end
						end)
						((meta2["tag"] ~= "expr")) then
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
						local r_1771
						r_1771 = _23_2(node3)
						local r_1781
						r_1781 = 1
						local r_1751
						r_1751 = nil
						r_1751 = (function(r_1761)
							if (function()
								if (0 < 1) then
									return (r_1761 <= r_1771)
								else
									return (r_1761 >= r_1771)
								end
							end)()
							 then
								local i11
								i11 = r_1761
								if (i11 > 2) then
									append_21_1(out5, ", ")
								else
								end
								compileExpression1(nth1(node3, i11), out5, state3)
								return r_1751((r_1761 + r_1781))
							else
							end
						end)
						r_1751(2)
						return append_21_1(out5, ")")
					end
				end
			elseif (function(r_1811)
				if r_1811 then
					local r_1821
					r_1821 = list_3f_1(head1)
					if r_1821 then
						local r_1831
						r_1831 = symbol_3f_1(car1(head1))
						if r_1831 then
							return (head1[1]["var"] == builtins1["lambda"])
						else
							return r_1831
						end
					else
						return r_1821
					end
				else
					return r_1811
				end
			end)
			(ret1) then
				local args3
				args3 = nth1(head1, 2)
				if (_23_2(args3) > 0) then
					append_21_1(out5, "local ")
					local r_1861
					r_1861 = _23_2(args3)
					local r_1871
					r_1871 = 1
					local r_1841
					r_1841 = nil
					r_1841 = (function(r_1851)
						if (function()
							if (0 < 1) then
								return (r_1851 <= r_1861)
							else
								return (r_1851 >= r_1861)
							end
						end)()
						 then
							local i12
							i12 = r_1851
							if (i12 > 1) then
								append_21_1(out5, ", ")
							else
							end
							append_21_1(out5, escapeVar1(args3[i12]["var"], state3))
							return r_1841((r_1851 + r_1871))
						else
						end
					end)
					r_1841(1)
					line_21_1(out5)
				else
				end
				local offset2
				offset2 = 1
				local r_1901
				r_1901 = _23_2(args3)
				local r_1911
				r_1911 = 1
				local r_1881
				r_1881 = nil
				r_1881 = (function(r_1891)
					if (function()
						if (0 < 1) then
							return (r_1891 <= r_1901)
						else
							return (r_1891 >= r_1901)
						end
					end)()
					 then
						local i13
						i13 = r_1891
						local var4
						var4 = args3[i13]["var"]
						if var4["isVariadic"] then
							local count1
							count1 = (_23_2(node3) - _23_2(args3))
							if (count1 < 0) then
								count1 = 0
							else
							end
							append_21_1(out5, escapeVar1(var4, state3))
							append_21_1(out5, " = { tag=\"list\", n=")
							append_21_1(out5, number_2d3e_string1(count1))
							local r_1941
							r_1941 = count1
							local r_1951
							r_1951 = 1
							local r_1921
							r_1921 = nil
							r_1921 = (function(r_1931)
								if (function()
									if (0 < 1) then
										return (r_1931 <= r_1941)
									else
										return (r_1931 >= r_1941)
									end
								end)()
								 then
									local j1
									j1 = r_1931
									append_21_1(out5, ", ")
									compileExpression1(nth1(node3, (i13 + j1)), out5, state3)
									return r_1921((r_1931 + r_1951))
								else
								end
							end)
							r_1921(1)
							offset2 = count1
							line_21_1(out5, "}")
						else
							local expr2
							expr2 = nth1(node3, (i13 + offset2))
							if expr2 then
								compileExpression1(expr2, out5, state3, (escapeVar1(var4, state3) .. " = "))
								line_21_1(out5)
							else
							end
						end
						return r_1881((r_1891 + r_1911))
					else
					end
				end)
				r_1881(1)
				local r_1981
				r_1981 = _23_2(node3)
				local r_1991
				r_1991 = 1
				local r_1961
				r_1961 = nil
				r_1961 = (function(r_1971)
					if (function()
						if (0 < 1) then
							return (r_1971 <= r_1981)
						else
							return (r_1971 >= r_1981)
						end
					end)()
					 then
						local i14
						i14 = r_1971
						compileExpression1(nth1(node3, i14), out5, state3, "")
						line_21_1(out5)
						return r_1961((r_1971 + r_1991))
					else
					end
				end)
				r_1961((_23_2(args3) + (offset2 + 1)))
				return compileBlock1(head1, out5, state3, 3, ret1)
			else
				if ret1 then
					append_21_1(out5, ret1)
				else
				end
				compileExpression1(car1(node3), out5, state3)
				append_21_1(out5, "(")
				local r_2021
				r_2021 = _23_2(node3)
				local r_2031
				r_2031 = 1
				local r_2001
				r_2001 = nil
				r_2001 = (function(r_2011)
					if (function()
						if (0 < 1) then
							return (r_2011 <= r_2021)
						else
							return (r_2011 >= r_2021)
						end
					end)()
					 then
						local i15
						i15 = r_2011
						if (i15 > 2) then
							append_21_1(out5, ", ")
						else
						end
						compileExpression1(nth1(node3, i15), out5, state3)
						return r_2001((r_2011 + r_2031))
					else
					end
				end)
				r_2001(2)
				return append_21_1(out5, ")")
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
	compileBlock1 = (function(nodes1, out6, state4, start1, ret2)
		local r_1121
		r_1121 = _23_2(nodes1)
		local r_1131
		r_1131 = 1
		local r_1101
		r_1101 = nil
		r_1101 = (function(r_1111)
			if (function()
				if (0 < 1) then
					return (r_1111 <= r_1121)
				else
					return (r_1111 >= r_1121)
				end
			end)()
			 then
				local i16
				i16 = r_1111
				local ret_27_1
				if (i16 == _23_2(nodes1)) then
					ret_27_1 = ret2
				else
					ret_27_1 = ""
				end
				compileExpression1(nth1(nodes1, i16), out6, state4, ret_27_1)
				line_21_1(out6)
				return r_1101((r_1111 + r_1131))
			else
			end
		end)
		return r_1101(start1)
	end)
	prelude1 = (function(out7)
		line_21_1(out7, "if not table.pack then table.pack = function(...) return { n = select(\"#\", ...), ... } end end")
		line_21_1(out7, "if not table.unpack then table.unpack = unpack end")
		line_21_1(out7, "if _VERSION:find(\"5.1\") then local function load(x, _, _, env) local f, e = loadstring(x); if not f then error(e, 1) end; return setfenv(f, env) end end")
		return line_21_1(out7, "local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error")
	end)
	backend1 = struct1("createState", createState1, "escape", escape1, "escapeVar", escapeVar1, "block", compileBlock1, "expression", compileExpression1, "prelude", prelude1)
	estimateLength1 = (function(node4, max1)
		local tag2
		tag2 = node4["tag"]
		if (function(r_2041)
			if r_2041 then
				return r_2041
			else
				local r_2051
				r_2051 = (tag2 == "number")
				if r_2051 then
					return r_2051
				else
					local r_2061
					r_2061 = (tag2 == "symbol")
					if r_2061 then
						return r_2061
					else
						return (tag2 == "key")
					end
				end
			end
		end)
		((tag2 == "string")) then
			return _23_s1(number_2d3e_string1(node4["contents"]))
		elseif (tag2 == "list") then
			local sum1
			sum1 = 2
			local i17
			i17 = 1
			local r_2161
			r_2161 = nil
			r_2161 = (function()
				if (function(r_2171)
					if r_2171 then
						return (i17 <= _23_2(node4))
					else
						return r_2171
					end
				end)
				((sum1 <= max1)) then
					sum1 = (sum1 + estimateLength1(nth1(node4, i17), (max1 - sum1)))
					if (i17 > 1) then
						sum1 = (sum1 + 1)
					else
					end
					i17 = (i17 + 1)
					return r_2161()
				else
				end
			end)
			r_2161()
			return sum1
		else
			return fail1(("Unknown tag " .. tag2))
		end
	end)
	expression1 = (function(node5, writer9)
		local tag3
		tag3 = node5["tag"]
		if (function(r_2071)
			if r_2071 then
				return r_2071
			else
				local r_2081
				r_2081 = (tag3 == "number")
				if r_2081 then
					return r_2081
				else
					local r_2091
					r_2091 = (tag3 == "symbol")
					if r_2091 then
						return r_2091
					else
						return (tag3 == "key")
					end
				end
			end
		end)
		((tag3 == "string")) then
			return append_21_1(writer9, number_2d3e_string1(node5["contents"]))
		elseif (tag3 == "list") then
			append_21_1(writer9, "(")
			if nil_3f_1(node5) then
				return append_21_1(writer9, ")")
			else
				local newline1, max2
				newline1 = false
				max2 = (60 - estimateLength1(car1(node5), 60))
				expression1(car1(node5), writer9)
				if (max2 <= 0) then
					newline1 = true
					indent_21_1(writer9)
				else
				end
				local r_2201
				r_2201 = _23_2(node5)
				local r_2211
				r_2211 = 1
				local r_2181
				r_2181 = nil
				r_2181 = (function(r_2191)
					if (function()
						if (0 < 1) then
							return (r_2191 <= r_2201)
						else
							return (r_2191 >= r_2201)
						end
					end)()
					 then
						local i18
						i18 = r_2191
						local entry3
						entry3 = nth1(node5, i18)
						if (function(r_2221)
							if r_2221 then
								return (max2 > 0)
							else
								return r_2221
							end
						end)
						(_21_1(newline1)) then
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
						return r_2181((r_2191 + r_2211))
					else
					end
				end)
				r_2181(2)
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
		local r_2111
		r_2111 = list2
		local r_2141
		r_2141 = _23_2(r_2111)
		local r_2151
		r_2151 = 1
		local r_2121
		r_2121 = nil
		r_2121 = (function(r_2131)
			if (function()
				if (0 < 1) then
					return (r_2131 <= r_2141)
				else
					return (r_2131 >= r_2141)
				end
			end)()
			 then
				local r_2101
				r_2101 = r_2131
				local node6
				node6 = r_2111[r_2101]
				expression1(node6, writer10)
				line_21_1(writer10)
				return r_2121((r_2131 + r_2151))
			else
			end
		end)
		return r_2121(1)
	end)
	backend2 = struct1("expression", expression1, "block", block1)
	wrapGenerate1 = (function(func2)
		return (function(node7, ...)
			local args4 = _pack(...) args4.tag = "list"
			local writer11
			writer11 = create1()
			func2(node7, writer11, unpack1(args4))
			return _2d3e_string1(writer11)
		end)
	end)
	wrapNormal1 = (function(func3)
		return (function(...)
			local args5 = _pack(...) args5.tag = "list"
			local writer12
			writer12 = create1()
			func3(writer12, unpack1(args5))
			return _2d3e_string1(writer12)
		end)
	end)
	return struct1("lua", struct1("expression", wrapGenerate1(compileExpression1), "block", wrapGenerate1(compileBlock1), "prelude", wrapNormal1(prelude1), "backend", backend1), "lisp", struct1("expression", wrapGenerate1(expression1), "block", wrapGenerate1(block1), "backend", backend2))
