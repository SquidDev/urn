if not table.pack then table.pack = function(...) return { n = select("#", ...), ... } end end
if not table.unpack then table.unpack = unpack end
if _VERSION:find("5.1") then local function load(x, _, _, env) local f, e = loadstring(x); if not f then error(e, 1) end; return setfenv(f, env) end end
local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error
local _libs = {}
local _temp = (function()
	local pprint = require 'tacky.pprint'
	local counter = 0
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
		['slice'] = function(xs, start, finish)
			if not finish then finish = xs.n end
			if not finish then finish = #xs end
			return { tag = "list", n = finish - start + 1, table.unpack(xs, start, finish) }
		end,
		['pretty'] = function (x) return pprint.tostring(x, pprint.nodeConfig) end,
		['gensym'] = function(name)
			if name then
				name = "_" .. tostring(name)
			else
				name = ""
			end
			counter = counter + 1
			return { tag = "symbol", contents = ("r_%d%s"):format(counter, name) }
		end,
		_G = _G, _ENV = _ENV, _VERSION = _VERSION,
		assert = assert, collectgarbage = collectgarbage,
		dofile = dofile, error = error,
		getmetatable = getmetatable, ipairs = ipairs,
		load = load, loadfile = loadfile,
		next = next, pairs = pairs,
		pcall = pcall, print = print,
		rawequal = rawequal, rawget = rawget,
		rawlen = rawlen, rawset = rawset,
		require = require, select = select,
		setmetatable = setmetatable, tonumber = tonumber,
		tostring = tostring, ["type#"] = type,
		xpcall = xpcall }
end)()
for k, v in pairs(_temp) do _libs["lib/lua/basic/".. k] = v end
local _temp = (function()
	return {
		['empty-struct'] = function() return {} end,
		['unpack'] = table.unpack or unpack,
		['iter-pairs'] = function(xs, f)
			for k, v in pairs(xs) do
				f(k, v)
			end
		end,
		concat = table.concat,
		insert = table.insert,
		move = table.move,
		pack = table.pack,
		remove = table.remove,
		sort = table.sort,
	}
end)()
for k, v in pairs(_temp) do _libs["lib/lua/table/".. k] = v end
local _temp = (function()
	return {
		byte = string.byte,
		char = string.char,
		dump = string.dump,
		find = string.find,
		format = string.format,
		gsub = string.gsub,
		len = string.len,
		lower = string.lower,
		match = string.match,
		rep = string.rep,
		reverse = string.reverse,
		sub = string.sub,
		upper = string.upper,
	}
end)()
for k, v in pairs(_temp) do _libs["lib/lua/string/".. k] = v end
local _temp = (function()
	return os
end)()
for k, v in pairs(_temp) do _libs["lib/lua/os/".. k] = v end
local _temp = (function()
	return io
end)()
for k, v in pairs(_temp) do _libs["lib/lua/io/".. k] = v end

_3d_1 = _libs["lib/lua/basic/="]
_2f3d_1 = _libs["lib/lua/basic//="]
_3c_1 = _libs["lib/lua/basic/<"]
_3c3d_1 = _libs["lib/lua/basic/<="]
_3e_1 = _libs["lib/lua/basic/>"]
_3e3d_1 = _libs["lib/lua/basic/>="]
_2b_1 = _libs["lib/lua/basic/+"]
_2d_1 = _libs["lib/lua/basic/-"]
_25_1 = _libs["lib/lua/basic/%"]
error1 = _libs["lib/lua/basic/error"]
rawget1 = _libs["lib/lua/basic/rawget"]
rawset1 = _libs["lib/lua/basic/rawset"]
require1 = _libs["lib/lua/basic/require"]
tostring1 = _libs["lib/lua/basic/tostring"]
type_23_1 = _libs["lib/lua/basic/type#"]
_23_1 = (function(x1)
	return x1["n"]
end)
concat1 = _libs["lib/lua/table/concat"]
unpack1 = _libs["lib/lua/table/unpack"]
emptyStruct1 = _libs["lib/lua/table/empty-struct"]
car1 = (function(xs1)
	return xs1[1]
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
byte1 = _libs["lib/lua/string/byte"]
find1 = _libs["lib/lua/string/find"]
format1 = _libs["lib/lua/string/format"]
gsub1 = _libs["lib/lua/string/gsub"]
len1 = _libs["lib/lua/string/len"]
rep1 = _libs["lib/lua/string/rep"]
sub1 = _libs["lib/lua/string/sub"]
upper1 = _libs["lib/lua/string/upper"]
list_3f_1 = (function(x2)
	return (type1(x2) == "list")
end)
nil_3f_1 = (function(x3)
	local r_11 = x3
	if r_11 then
		local r_21 = list_3f_1(x3)
		if r_21 then
			return (_23_1(x3) == 0)
		else
			return r_21
		end
	else
		return r_11
	end
end)
string_3f_1 = (function(x4)
	return (type1(x4) == "string")
end)
number_3f_1 = (function(x5)
	return (type1(x5) == "number")
end)
symbol_3f_1 = (function(x6)
	return (type1(x6) == "symbol")
end)
key_3f_1 = (function(x7)
	return (type1(x7) == "key")
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
nth1 = rawget1
pushCdr_21_1 = (function(xs3, val2)
	local len2 = (_23_1(xs3) + 1)
	xs3["n"] = len2
	xs3[len2] = val2
	return xs3
end)
charAt1 = (function(xs4, x8)
	return sub1(xs4, x8, x8)
end)
_2e2e_1 = (function(...)
	local args1 = _pack(...) args1.tag = "list"
	return concat1(args1)
end)
_23_s1 = len1
quoted1 = (function(str1)
	local result1 = gsub1(format1("%q", str1), "\n", "\\n")
	return result1
end)
struct1 = (function(...)
	local keys1 = _pack(...) keys1.tag = "list"
	if ((_23_1(keys1) % 1) == 1) then
		error1("Expected an even number of arguments to struct", 2)
	else
	end
	local contents1 = (function(key1)
		return sub1(key1["contents"], 2)
	end)
	local out1 = emptyStruct1()
	local r_241 = _23_1(keys1)
	local r_251 = 2
	local r_221 = nil
	r_221 = (function(r_231)
		local _temp
		if (0 < 2) then
			_temp = (r_231 <= r_241)
		else
			_temp = (r_231 >= r_241)
		end
		if _temp then
			local i1 = r_231
			local key2 = keys1[i1]
			local val3 = keys1[(1 + i1)]
			out1[(function()
				if key_3f_1(key2) then
					return contents1(key2)
				else
					return key2
				end
			end)()
			] = val3
			return r_221((r_231 + r_251))
		else
		end
	end)
	r_221(1)
	return out1
end)
succ1 = (function(x9)
	return (x9 + 1)
end)
pred1 = (function(x10)
	return (x10 - 1)
end)
number_2d3e_string1 = tostring1
error_21_1 = error1
fail_21_1 = (function(x11)
	return error_21_1(x11, 0)
end)
create1 = (function()
	return struct1("out", list1(), "indent", 0, "tabs-pending", false)
end)
append_21_1 = (function(writer1, text1)
	local r_541 = type1(text1)
	if (r_541 ~= "string") then
		error1(format1("bad argment %s (expected %s, got %s)", "text", "string", r_541), 2)
	else
	end
	if writer1["tabs-pending"] then
		writer1["tabs-pending"] = false
		pushCdr_21_1(writer1["out"], rep1("\t", writer1["indent"]))
	else
	end
	return pushCdr_21_1(writer1["out"], text1)
end)
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
end)
indent_21_1 = (function(writer3)
	writer3["indent"] = succ1(writer3["indent"])
	return nil
end)
unindent_21_1 = (function(writer4)
	writer4["indent"] = pred1(writer4["indent"])
	return nil
end)
beginBlock_21_1 = (function(writer5, text3)
	line_21_1(writer5, text3)
	return indent_21_1(writer5)
end)
nextBlock_21_1 = (function(writer6, text4)
	unindent_21_1(writer6)
	line_21_1(writer6, text4)
	return indent_21_1(writer6)
end)
endBlock_21_1 = (function(writer7, text5)
	unindent_21_1(writer7)
	return line_21_1(writer7, text5)
end)
_2d3e_string1 = (function(writer8)
	return concat1(writer8["out"])
end)
createLookup1 = (function(...)
	local lst1 = _pack(...) lst1.tag = "list"
	local out2 = emptyStruct1()
	local r_561 = lst1
	local r_591 = _23_1(r_561)
	local r_601 = 1
	local r_571 = nil
	r_571 = (function(r_581)
		local _temp
		if (0 < 1) then
			_temp = (r_581 <= r_591)
		else
			_temp = (r_581 >= r_591)
		end
		if _temp then
			local r_551 = r_581
			local entry1 = r_561[r_551]
			out2[entry1] = true
			return r_571((r_581 + r_601))
		else
		end
	end)
	r_571(1)
	return out2
end)
keywords1 = createLookup1("and", "break", "do", "else", "elseif", "end", "false", "for", "function", "if", "in", "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while")
createState1 = (function(meta1)
	return struct1("ctr-lookup", emptyStruct1(), "var-lookup", emptyStruct1(), "meta", (function(r_611)
		if r_611 then
			return r_611
		else
			return emptyStruct1()
		end
	end)(meta1))
end)
builtins1 = require1("tacky.analysis.resolve")["builtins"]
builtinVars1 = require1("tacky.analysis.resolve")["declaredVars"]
escape1 = (function(name1)
	if keywords1[name1] then
		return _2e2e_1("_e", name1)
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
		local r_911 = _23_s1(name1)
		local r_921 = 1
		local r_891 = nil
		r_891 = (function(r_901)
			local _temp
			if (0 < 1) then
				_temp = (r_901 <= r_911)
			else
				_temp = (r_901 >= r_911)
			end
			if _temp then
				local i2 = r_901
				local char1 = charAt1(name1, i2)
				local _temp
				local r_931 = (char1 == "-")
				if r_931 then
					local r_941 = find1(charAt1(name1, pred1(i2)), "[%a%d']")
					if r_941 then
						_temp = find1(charAt1(name1, succ1(i2)), "[%a%d']")
					else
						_temp = r_941
					end
				else
					_temp = r_931
				end
				if _temp then
					upper2 = true
				elseif find1(char1, "[^%w%d]") then
					char1 = format1("%02x", byte1(char1))
					if esc1 then
					else
						esc1 = true
						out3 = _2e2e_1(out3, "_")
					end
					out3 = _2e2e_1(out3, char1)
				else
					if esc1 then
						esc1 = false
						out3 = _2e2e_1(out3, "_")
					else
					end
					if upper2 then
						upper2 = false
						char1 = upper1(char1)
					else
					end
					out3 = _2e2e_1(out3, char1)
				end
				return r_891((r_901 + r_921))
			else
			end
		end)
		r_891(1)
		if esc1 then
			out3 = _2e2e_1(out3, "_")
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
			id1 = succ1((function(r_671)
				if r_671 then
					return r_671
				else
					return 0
				end
			end)(state1["ctr-lookup"][v1]))
			state1["ctr-lookup"][v1] = id1
			state1["var-lookup"][var1] = id1
		end
		return _2e2e_1(v1, number_2d3e_string1(id1))
	end
end)
isStatement1 = (function(node1)
	if list_3f_1(node1) then
		local first1 = car1(node1)
		if symbol_3f_1(first1) then
			return (first1["var"] == builtins1["cond"])
		elseif list_3f_1(first1) then
			local func1 = car1(first1)
			local r_621 = symbol_3f_1(func1)
			if r_621 then
				return (func1["var"] == builtins1["lambda"])
			else
				return r_621
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
			append_21_1(out4, _2e2e_1("{ tag=\"symbol\", contents=", quoted1(node2["contents"])))
			if node2["var"] then
				append_21_1(out4, _2e2e_1(", var=", quoted1(number_2d3e_string1(node2["var"]))))
			else
			end
			return append_21_1(out4, "}")
		elseif (ty2 == "key") then
			return append_21_1(out4, _2e2e_1("{tag=\"key\", contents=", quoted1(node2["contents"]), "}"))
		elseif (ty2 == "list") then
			local first2 = car1(node2)
			local _temp
			local r_681 = symbol_3f_1(first2)
			if r_681 then
				local r_691 = (first2["var"] == builtins1["unquote"])
				if r_691 then
					_temp = r_691
				else
					_temp = ("var" == builtins1["unquote-splice"])
				end
			else
				_temp = r_681
			end
			if _temp then
				return compileQuote1(nth1(node2, 2), out4, state2, (function(r_701)
					if r_701 then
						return pred1(level1)
					else
						return r_701
					end
				end)(level1))
			else
				local _temp
				local r_711 = symbol_3f_1(first2)
				if r_711 then
					_temp = (first2["var"] == builtins1["quasiquote"])
				else
					_temp = r_711
				end
				if _temp then
					return compileQuote1(nth1(node2, 2), out4, state2, (function(r_721)
						if r_721 then
							return succ1(level1)
						else
							return r_721
						end
					end)(level1))
				else
					local containsUnsplice1 = false
					local r_741 = node2
					local r_771 = _23_1(r_741)
					local r_781 = 1
					local r_751 = nil
					r_751 = (function(r_761)
						local _temp
						if (0 < 1) then
							_temp = (r_761 <= r_771)
						else
							_temp = (r_761 >= r_771)
						end
						if _temp then
							local r_731 = r_761
							local sub2 = r_741[r_731]
							local _temp
							local r_791 = list_3f_1(sub2)
							if r_791 then
								local r_801 = symbol_3f_1(car1(sub2))
								if r_801 then
									_temp = (sub2[1]["var"] == builtins1["unquote-splice"])
								else
									_temp = r_801
								end
							else
								_temp = r_791
							end
							if _temp then
								containsUnsplice1 = true
							else
							end
							return r_751((r_761 + r_781))
						else
						end
					end)
					r_751(1)
					if containsUnsplice1 then
						local offset1 = 0
						beginBlock_21_1(out4, "(function()")
						line_21_1(out4, "local _offset, _result, _temp = 0, {tag=\"list\",n=0}")
						local r_831 = _23_1(node2)
						local r_841 = 1
						local r_811 = nil
						r_811 = (function(r_821)
							local _temp
							if (0 < 1) then
								_temp = (r_821 <= r_831)
							else
								_temp = (r_821 >= r_831)
							end
							if _temp then
								local i3 = r_821
								local sub3 = nth1(node2, i3)
								local _temp
								local r_851 = list_3f_1(sub3)
								if r_851 then
									local r_861 = symbol_3f_1(car1(sub3))
									if r_861 then
										_temp = (sub3[1]["var"] == builtins1["unquote-splice"])
									else
										_temp = r_861
									end
								else
									_temp = r_851
								end
								if _temp then
									offset1 = (offset1 + 1)
									append_21_1(out4, "_temp = ")
									compileQuote1(nth1(sub3, 2), out4, state2, pred1(level1))
									line_21_1(out4)
									line_21_1(out4, _2e2e_1("for _c = 1, _temp.n do _result[", number_2d3e_string1((i3 - offset1)), " + _c + _offset] = _temp[_c] end"))
									line_21_1(out4, "_offset = _offset + _temp.n")
								else
									append_21_1(out4, _2e2e_1("_result[", number_2d3e_string1((i3 - offset1)), " + _offset] = "))
									compileQuote1(sub3, out4, state2, level1)
									line_21_1(out4)
								end
								return r_811((r_821 + r_841))
							else
							end
						end)
						r_811(1)
						line_21_1(out4, _2e2e_1("_result.n = _offset + ", number_2d3e_string1((_23_1(node2) - offset1))))
						line_21_1(out4, "return _result")
						return endBlock_21_1(out4, "end)()")
					else
						append_21_1(out4, _2e2e_1("{tag = \"list\", n =", number_2d3e_string1(_23_1(node2))))
						local r_961 = node2
						local r_991 = _23_1(r_961)
						local r_1001 = 1
						local r_971 = nil
						r_971 = (function(r_981)
							local _temp
							if (0 < 1) then
								_temp = (r_981 <= r_991)
							else
								_temp = (r_981 >= r_991)
							end
							if _temp then
								local r_951 = r_981
								local sub4 = r_961[r_951]
								append_21_1(out4, ", ")
								compileQuote1(sub4, out4, state2, level1)
								return r_971((r_981 + r_1001))
							else
							end
						end)
						r_971(1)
						return append_21_1(out4, "}")
					end
				end
			end
		else
			return error_21_1(_2e2e_1("Unknown type ", ty2))
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
					local r_871 = nil
					r_871 = (function()
						local _temp
						local r_881 = (i4 <= _23_1(args2))
						if r_881 then
							_temp = _21_1(variadic1)
						else
							_temp = r_881
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
							return r_871()
						else
						end
					end)
					r_871()
					beginBlock_21_1(out5, ")")
					if variadic1 then
						local argsVar1 = escapeVar1(args2[variadic1]["var"], state3)
						if (variadic1 == _23_1(args2)) then
							line_21_1(out5, _2e2e_1("local ", argsVar1, " = _pack(...) ", argsVar1, ".tag = \"list\""))
						else
							local remaining1 = (_23_1(args2) - variadic1)
							line_21_1(out5, _2e2e_1("local _n = _select(\"#\", ...) - ", number_2d3e_string1(remaining1)))
							append_21_1(out5, _2e2e_1("local ", argsVar1))
							local r_1031 = _23_1(args2)
							local r_1041 = 1
							local r_1011 = nil
							r_1011 = (function(r_1021)
								local _temp
								if (0 < 1) then
									_temp = (r_1021 <= r_1031)
								else
									_temp = (r_1021 >= r_1031)
								end
								if _temp then
									local i5 = r_1021
									append_21_1(out5, ", ")
									append_21_1(out5, escapeVar1(args2[i5]["var"], state3))
									return r_1011((r_1021 + r_1041))
								else
								end
							end)
							r_1011(succ1(variadic1))
							line_21_1(out5)
							beginBlock_21_1(out5, "if _n > 0 then")
							append_21_1(out5, argsVar1)
							line_21_1(out5, " = { tag=\"list\", n=_n, _unpack(_pack(...), 1, _n)}")
							local r_1071 = _23_1(args2)
							local r_1081 = 1
							local r_1051 = nil
							r_1051 = (function(r_1061)
								local _temp
								if (0 < 1) then
									_temp = (r_1061 <= r_1071)
								else
									_temp = (r_1061 >= r_1071)
								end
								if _temp then
									local i6 = r_1061
									append_21_1(out5, escapeVar1(args2[i6]["var"], state3))
									if (i6 < _23_1(args2)) then
										append_21_1(out5, ", ")
									else
									end
									return r_1051((r_1061 + r_1081))
								else
								end
							end)
							r_1051(succ1(variadic1))
							line_21_1(out5, " = select(_n + 1, ...)")
							nextBlock_21_1(out5, "else")
							append_21_1(out5, argsVar1)
							line_21_1(out5, " = { tag=\"list\", n=0}")
							local r_1111 = _23_1(args2)
							local r_1121 = 1
							local r_1091 = nil
							r_1091 = (function(r_1101)
								local _temp
								if (0 < 1) then
									_temp = (r_1101 <= r_1111)
								else
									_temp = (r_1101 >= r_1111)
								end
								if _temp then
									local i7 = r_1101
									append_21_1(out5, escapeVar1(args2[i7]["var"], state3))
									if (i7 < _23_1(args2)) then
										append_21_1(out5, ", ")
									else
									end
									return r_1091((r_1101 + r_1121))
								else
								end
							end)
							r_1091(succ1(variadic1))
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
				local r_1131 = nil
				r_1131 = (function()
					if (i8 <= _23_1(node3)) then
						local item1 = nth1(node3, i8)
						local case1 = nth1(item1, 1)
						local isFinal1
						local r_1141 = symbol_3f_1(case1)
						if r_1141 then
							isFinal1 = (case1["var"] == builtinVars1["true"])
						else
							isFinal1 = r_1141
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
						return r_1131()
					else
					end
				end)
				r_1131()
				if hadFinal1 then
				else
					indent_21_1(out5)
					line_21_1(out5)
					append_21_1(out5, "_error(\"unmatched item\")")
					unindent_21_1(out5)
					line_21_1(out5)
				end
				local r_1171 = ends1
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
						local i9 = r_1161
						append_21_1(out5, "end")
						if (i9 < ends1) then
							unindent_21_1(out5)
							line_21_1(out5)
						else
						end
						return r_1151((r_1161 + r_1181))
					else
					end
				end)
				r_1151(1)
				if closure1 then
					line_21_1(out5)
					return endBlock_21_1(out5, "end)()")
				else
				end
			elseif (var2 == builtins1["set!"]) then
				compileExpression1(nth1(node3, 3), out5, state3, _2e2e_1(escapeVar1(node3[2]["var"], state3), " = "))
				local _temp
				local r_1191 = ret1
				if r_1191 then
					_temp = (ret1 ~= "")
				else
					_temp = r_1191
				end
				if _temp then
					line_21_1(out5)
					append_21_1(out5, ret1)
					return append_21_1(out5, "nil")
				else
				end
			elseif (var2 == builtins1["define"]) then
				return compileExpression1(nth1(node3, 3), out5, state3, _2e2e_1(escapeVar1(node3["defVar"], state3), " = "))
			elseif (var2 == builtins1["define-macro"]) then
				return compileExpression1(nth1(node3, 3), out5, state3, _2e2e_1(escapeVar1(node3["defVar"], state3), " = "))
			elseif (var2 == builtins1["define-native"]) then
				return append_21_1(out5, format1("%s = _libs[%q]", escapeVar1(node3["defVar"], state3), node3["defVar"]["fullName"]))
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
				end
				return compileQuote1(nth1(node3, 2), out5, state3, 1)
			elseif (var2 == builtins1["unquote"]) then
				return fail_21_1("unquote outside of quasiquote")
			elseif (var2 == builtins1["unquote-splice"]) then
				return fail_21_1("unquote-splice outside of quasiquote")
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
				local r_1331 = symbol_3f_1(head1)
				if r_1331 then
					local r_1341 = (head1["var"]["tag"] == "native")
					if r_1341 then
						meta2 = state3["meta"][head1["var"]["fullName"]]
					else
						meta2 = r_1341
					end
				else
					meta2 = r_1331
				end
				local _temp
				local r_1201 = meta2
				if r_1201 then
					local r_1211
					local r_1221 = ret1
					if r_1221 then
						r_1211 = r_1221
					else
						r_1211 = (meta2["tag"] == "expr")
					end
					if r_1211 then
						_temp = (pred1(_23_1(node3)) == meta2["count"])
					else
						_temp = r_1211
					end
				else
					_temp = r_1201
				end
				if _temp then
					local _temp
					local r_1231 = ret1
					if r_1231 then
						_temp = (meta2["tag"] == "expr")
					else
						_temp = r_1231
					end
					if _temp then
						append_21_1(out5, ret1)
					else
					end
					local contents2 = meta2["contents"]
					local r_1261 = _23_1(contents2)
					local r_1271 = 1
					local r_1241 = nil
					r_1241 = (function(r_1251)
						local _temp
						if (0 < 1) then
							_temp = (r_1251 <= r_1261)
						else
							_temp = (r_1251 >= r_1261)
						end
						if _temp then
							local i10 = r_1251
							local entry2 = nth1(contents2, i10)
							if number_3f_1(entry2) then
								compileExpression1(nth1(node3, succ1(entry2)), out5, state3)
							else
								append_21_1(out5, entry2)
							end
							return r_1241((r_1251 + r_1271))
						else
						end
					end)
					r_1241(1)
					local _temp
					local r_1281 = (meta2["tag"] ~= "expr")
					if r_1281 then
						_temp = (ret1 ~= "")
					else
						_temp = r_1281
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
					local r_1311 = _23_1(node3)
					local r_1321 = 1
					local r_1291 = nil
					r_1291 = (function(r_1301)
						local _temp
						if (0 < 1) then
							_temp = (r_1301 <= r_1311)
						else
							_temp = (r_1301 >= r_1311)
						end
						if _temp then
							local i11 = r_1301
							if (i11 > 2) then
								append_21_1(out5, ", ")
							else
							end
							compileExpression1(nth1(node3, i11), out5, state3)
							return r_1291((r_1301 + r_1321))
						else
						end
					end)
					r_1291(2)
					return append_21_1(out5, ")")
				end
			end
		else
			local _temp
			local r_1351 = ret1
			if r_1351 then
				local r_1361 = list_3f_1(head1)
				if r_1361 then
					local r_1371 = symbol_3f_1(car1(head1))
					if r_1371 then
						_temp = (head1[1]["var"] == builtins1["lambda"])
					else
						_temp = r_1371
					end
				else
					_temp = r_1361
				end
			else
				_temp = r_1351
			end
			if _temp then
				local args3 = nth1(head1, 2)
				local offset2 = 1
				local r_1401 = _23_1(args3)
				local r_1411 = 1
				local r_1381 = nil
				r_1381 = (function(r_1391)
					local _temp
					if (0 < 1) then
						_temp = (r_1391 <= r_1401)
					else
						_temp = (r_1391 >= r_1401)
					end
					if _temp then
						local i12 = r_1391
						local var4 = args3[i12]["var"]
						append_21_1(out5, _2e2e_1("local ", escapeVar1(var4, state3)))
						if var4["isVariadic"] then
							local count1 = (_23_1(node3) - _23_1(args3))
							if (count1 < 0) then
								count1 = 0
							else
							end
							append_21_1(out5, " = { tag=\"list\", n=")
							append_21_1(out5, number_2d3e_string1(count1))
							local r_1441 = count1
							local r_1451 = 1
							local r_1421 = nil
							r_1421 = (function(r_1431)
								local _temp
								if (0 < 1) then
									_temp = (r_1431 <= r_1441)
								else
									_temp = (r_1431 >= r_1441)
								end
								if _temp then
									local j1 = r_1431
									append_21_1(out5, ", ")
									compileExpression1(nth1(node3, (i12 + j1)), out5, state3)
									return r_1421((r_1431 + r_1451))
								else
								end
							end)
							r_1421(1)
							offset2 = count1
							line_21_1(out5, "}")
						else
							local expr2 = nth1(node3, (i12 + offset2))
							local name2 = escapeVar1(var4, state3)
							local ret2 = nil
							if expr2 then
								if isStatement1(expr2) then
									ret2 = _2e2e_1(name2, " = ")
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
						return r_1381((r_1391 + r_1411))
					else
					end
				end)
				r_1381(1)
				local r_1481 = _23_1(node3)
				local r_1491 = 1
				local r_1461 = nil
				r_1461 = (function(r_1471)
					local _temp
					if (0 < 1) then
						_temp = (r_1471 <= r_1481)
					else
						_temp = (r_1471 >= r_1481)
					end
					if _temp then
						local i13 = r_1471
						compileExpression1(nth1(node3, i13), out5, state3, "")
						line_21_1(out5)
						return r_1461((r_1471 + r_1491))
					else
					end
				end)
				r_1461((_23_1(args3) + (offset2 + 1)))
				return compileBlock1(head1, out5, state3, 3, ret1)
			else
				if ret1 then
					append_21_1(out5, ret1)
				else
				end
				compileExpression1(car1(node3), out5, state3)
				append_21_1(out5, "(")
				local r_1521 = _23_1(node3)
				local r_1531 = 1
				local r_1501 = nil
				r_1501 = (function(r_1511)
					local _temp
					if (0 < 1) then
						_temp = (r_1511 <= r_1521)
					else
						_temp = (r_1511 >= r_1521)
					end
					if _temp then
						local i14 = r_1511
						if (i14 > 2) then
							append_21_1(out5, ", ")
						else
						end
						compileExpression1(nth1(node3, i14), out5, state3)
						return r_1501((r_1511 + r_1531))
					else
					end
				end)
				r_1501(2)
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
				return error_21_1(_2e2e_1("Unknown type: ", type1(node3)))
			end
		end
	end
end)
compileBlock1 = (function(nodes1, out6, state4, start1, ret3)
	local r_651 = _23_1(nodes1)
	local r_661 = 1
	local r_631 = nil
	r_631 = (function(r_641)
		local _temp
		if (0 < 1) then
			_temp = (r_641 <= r_651)
		else
			_temp = (r_641 >= r_651)
		end
		if _temp then
			local i15 = r_641
			local ret_27_1
			if (i15 == _23_1(nodes1)) then
				ret_27_1 = ret3
			else
				ret_27_1 = ""
			end
			compileExpression1(nth1(nodes1, i15), out6, state4, ret_27_1)
			line_21_1(out6)
			return r_631((r_641 + r_661))
		else
		end
	end)
	return r_631(start1)
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
	local r_1541 = (tag2 == "string")
	if r_1541 then
		_temp = r_1541
	else
		local r_1551 = (tag2 == "number")
		if r_1551 then
			_temp = r_1551
		else
			local r_1561 = (tag2 == "symbol")
			if r_1561 then
				_temp = r_1561
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
		local r_1661 = nil
		r_1661 = (function()
			local _temp
			local r_1671 = (sum1 <= max1)
			if r_1671 then
				_temp = (i16 <= _23_1(node4))
			else
				_temp = r_1671
			end
			if _temp then
				sum1 = (sum1 + estimateLength1(nth1(node4, i16), (max1 - sum1)))
				if (i16 > 1) then
					sum1 = (sum1 + 1)
				else
				end
				i16 = (i16 + 1)
				return r_1661()
			else
			end
		end)
		r_1661()
		return sum1
	else
		return fail_21_1(_2e2e_1("Unknown tag ", tag2))
	end
end)
expression1 = (function(node5, writer9)
	local tag3 = node5["tag"]
	local _temp
	local r_1571 = (tag3 == "string")
	if r_1571 then
		_temp = r_1571
	else
		local r_1581 = (tag3 == "number")
		if r_1581 then
			_temp = r_1581
		else
			local r_1591 = (tag3 == "symbol")
			if r_1591 then
				_temp = r_1591
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
			local r_1701 = _23_1(node5)
			local r_1711 = 1
			local r_1681 = nil
			r_1681 = (function(r_1691)
				local _temp
				if (0 < 1) then
					_temp = (r_1691 <= r_1701)
				else
					_temp = (r_1691 >= r_1701)
				end
				if _temp then
					local i17 = r_1691
					local entry3 = nth1(node5, i17)
					local _temp
					local r_1721 = _21_1(newline1)
					if r_1721 then
						_temp = (max2 > 0)
					else
						_temp = r_1721
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
					return r_1681((r_1691 + r_1711))
				else
				end
			end)
			r_1681(2)
			if newline1 then
				unindent_21_1(writer9)
			else
			end
			return append_21_1(writer9, ")")
		end
	else
		return fail_21_1(_2e2e_1("Unknown tag ", tag3))
	end
end)
block1 = (function(list2, writer10)
	local r_1611 = list2
	local r_1641 = _23_1(r_1611)
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
			local r_1601 = r_1631
			local node6 = r_1611[r_1601]
			expression1(node6, writer10)
			line_21_1(writer10)
			return r_1621((r_1631 + r_1651))
		else
		end
	end)
	return r_1621(1)
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
