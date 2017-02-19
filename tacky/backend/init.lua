if not table.pack then table.pack = function(...) return { n = select("#", ...), ... } end end
if not table.unpack then table.unpack = unpack end
if _VERSION:find("5.1") then local function load(x, _, _, env) local f, e = loadstring(x); if not f then error(e, 1) end; return setfenv(f, env) end end
local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error
local _libs = {}
local _temp = (function()
	local counter = 0
	local function pretty(x)
		if type(x) == 'table' and x.tag then
			if x.tag == 'list' then
				local y = {}
				for i = 1, #x do
					y[i] = pretty(x[i])
				end
				return '(' .. table.concat(y, ' ') .. ')'
			elseif x.tag == 'symbol' or x.tag == 'key' or x.tag == 'string' or x.tag == 'number' then
				return x.contents
			else
				return tostring(x)
			end
		elseif type(x) == 'string' then
			return ("%q"):format(x)
		else
			return tostring(x)
		end
	end
	local function pretty (x)
		if type(x) == 'table' and x.tag then
			if x.tag == 'list' then
				local y = {}
				for i = 1, #x do
					y[i] = pretty(x[i])
				end
				return '(' .. table.concat(y, ' ') .. ')'
			elseif x.tag == 'symbol' or x.tag == 'key' or x.tag == 'string' or x.tag == 'number' then
				return x.contents
			else
				return tostring(x)
			end
		elseif type(x) == 'string' then
			return ("%q"):format(x)
		else
			return tostring(x)
		end
	end
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
		pretty = pretty,
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
car2 = (function(x8)
	local r_141 = type1(x8)
	if (r_141 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_141), 2)
	else
	end
	return car1(x8)
end)
nth1 = rawget1
pushCdr_21_1 = (function(xs3, val2)
	local r_241 = type1(xs3)
	if (r_241 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_241), 2)
	else
	end
	local len2 = (_23_1(xs3) + 1)
	xs3["n"] = len2
	xs3[len2] = val2
	return xs3
end)
charAt1 = (function(xs4, x9)
	return sub1(xs4, x9, x9)
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
	local r_491 = _23_1(keys1)
	local r_501 = 2
	local r_471 = nil
	r_471 = (function(r_481)
		local _temp
		if (0 < 2) then
			_temp = (r_481 <= r_491)
		else
			_temp = (r_481 >= r_491)
		end
		if _temp then
			local i1 = r_481
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
			return r_471((r_481 + r_501))
		else
		end
	end)
	r_471(1)
	return out1
end)
succ1 = (function(x10)
	return (x10 + 1)
end)
pred1 = (function(x11)
	return (x11 - 1)
end)
number_2d3e_string1 = tostring1
error_21_1 = error1
fail_21_1 = (function(x12)
	return error_21_1(x12, 0)
end)
create1 = (function()
	return struct1("out", list1(), "indent", 0, "tabs-pending", false)
end)
append_21_1 = (function(writer1, text1)
	local r_791 = type1(text1)
	if (r_791 ~= "string") then
		error1(format1("bad argment %s (expected %s, got %s)", "text", "string", r_791), 2)
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
	local r_811 = lst1
	local r_841 = _23_1(r_811)
	local r_851 = 1
	local r_821 = nil
	r_821 = (function(r_831)
		local _temp
		if (0 < 1) then
			_temp = (r_831 <= r_841)
		else
			_temp = (r_831 >= r_841)
		end
		if _temp then
			local r_801 = r_831
			local entry1 = r_811[r_801]
			out2[entry1] = true
			return r_821((r_831 + r_851))
		else
		end
	end)
	r_821(1)
	return out2
end)
keywords1 = createLookup1("and", "break", "do", "else", "elseif", "end", "false", "for", "function", "if", "in", "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while")
createState1 = (function(meta1)
	return struct1("ctr-lookup", emptyStruct1(), "var-lookup", emptyStruct1(), "meta", (function(r_861)
		if r_861 then
			return r_861
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
		local r_1161 = _23_s1(name1)
		local r_1171 = 1
		local r_1141 = nil
		r_1141 = (function(r_1151)
			local _temp
			if (0 < 1) then
				_temp = (r_1151 <= r_1161)
			else
				_temp = (r_1151 >= r_1161)
			end
			if _temp then
				local i2 = r_1151
				local char1 = charAt1(name1, i2)
				local _temp
				local r_1181 = (char1 == "-")
				if r_1181 then
					local r_1191 = find1(charAt1(name1, pred1(i2)), "[%a%d']")
					if r_1191 then
						_temp = find1(charAt1(name1, succ1(i2)), "[%a%d']")
					else
						_temp = r_1191
					end
				else
					_temp = r_1181
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
				return r_1141((r_1151 + r_1171))
			else
			end
		end)
		r_1141(1)
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
			id1 = succ1((function(r_921)
				if r_921 then
					return r_921
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
		local first1 = car2(node1)
		if symbol_3f_1(first1) then
			return (first1["var"] == builtins1["cond"])
		elseif list_3f_1(first1) then
			local func1 = car2(first1)
			local r_871 = symbol_3f_1(func1)
			if r_871 then
				return (func1["var"] == builtins1["lambda"])
			else
				return r_871
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
			local first2 = car2(node2)
			local _temp
			local r_931 = symbol_3f_1(first2)
			if r_931 then
				local r_941 = (first2["var"] == builtins1["unquote"])
				if r_941 then
					_temp = r_941
				else
					_temp = ("var" == builtins1["unquote-splice"])
				end
			else
				_temp = r_931
			end
			if _temp then
				return compileQuote1(nth1(node2, 2), out4, state2, (function(r_951)
					if r_951 then
						return pred1(level1)
					else
						return r_951
					end
				end)(level1))
			else
				local _temp
				local r_961 = symbol_3f_1(first2)
				if r_961 then
					_temp = (first2["var"] == builtins1["quasiquote"])
				else
					_temp = r_961
				end
				if _temp then
					return compileQuote1(nth1(node2, 2), out4, state2, (function(r_971)
						if r_971 then
							return succ1(level1)
						else
							return r_971
						end
					end)(level1))
				else
					local containsUnsplice1 = false
					local r_991 = node2
					local r_1021 = _23_1(r_991)
					local r_1031 = 1
					local r_1001 = nil
					r_1001 = (function(r_1011)
						local _temp
						if (0 < 1) then
							_temp = (r_1011 <= r_1021)
						else
							_temp = (r_1011 >= r_1021)
						end
						if _temp then
							local r_981 = r_1011
							local sub2 = r_991[r_981]
							local _temp
							local r_1041 = list_3f_1(sub2)
							if r_1041 then
								local r_1051 = symbol_3f_1(car2(sub2))
								if r_1051 then
									_temp = (sub2[1]["var"] == builtins1["unquote-splice"])
								else
									_temp = r_1051
								end
							else
								_temp = r_1041
							end
							if _temp then
								containsUnsplice1 = true
							else
							end
							return r_1001((r_1011 + r_1031))
						else
						end
					end)
					r_1001(1)
					if containsUnsplice1 then
						local offset1 = 0
						beginBlock_21_1(out4, "(function()")
						line_21_1(out4, "local _offset, _result, _temp = 0, {tag=\"list\",n=0}")
						local r_1081 = _23_1(node2)
						local r_1091 = 1
						local r_1061 = nil
						r_1061 = (function(r_1071)
							local _temp
							if (0 < 1) then
								_temp = (r_1071 <= r_1081)
							else
								_temp = (r_1071 >= r_1081)
							end
							if _temp then
								local i3 = r_1071
								local sub3 = nth1(node2, i3)
								local _temp
								local r_1101 = list_3f_1(sub3)
								if r_1101 then
									local r_1111 = symbol_3f_1(car2(sub3))
									if r_1111 then
										_temp = (sub3[1]["var"] == builtins1["unquote-splice"])
									else
										_temp = r_1111
									end
								else
									_temp = r_1101
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
								return r_1061((r_1071 + r_1091))
							else
							end
						end)
						r_1061(1)
						line_21_1(out4, _2e2e_1("_result.n = _offset + ", number_2d3e_string1((_23_1(node2) - offset1))))
						line_21_1(out4, "return _result")
						return endBlock_21_1(out4, "end)()")
					else
						append_21_1(out4, _2e2e_1("{tag = \"list\", n =", number_2d3e_string1(_23_1(node2))))
						local r_1211 = node2
						local r_1241 = _23_1(r_1211)
						local r_1251 = 1
						local r_1221 = nil
						r_1221 = (function(r_1231)
							local _temp
							if (0 < 1) then
								_temp = (r_1231 <= r_1241)
							else
								_temp = (r_1231 >= r_1241)
							end
							if _temp then
								local r_1201 = r_1231
								local sub4 = r_1211[r_1201]
								append_21_1(out4, ", ")
								compileQuote1(sub4, out4, state2, level1)
								return r_1221((r_1231 + r_1251))
							else
							end
						end)
						r_1221(1)
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
		local head1 = car2(node3)
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
					local r_1121 = nil
					r_1121 = (function()
						local _temp
						local r_1131 = (i4 <= _23_1(args2))
						if r_1131 then
							_temp = _21_1(variadic1)
						else
							_temp = r_1131
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
							return r_1121()
						else
						end
					end)
					r_1121()
					beginBlock_21_1(out5, ")")
					if variadic1 then
						local argsVar1 = escapeVar1(args2[variadic1]["var"], state3)
						if (variadic1 == _23_1(args2)) then
							line_21_1(out5, _2e2e_1("local ", argsVar1, " = _pack(...) ", argsVar1, ".tag = \"list\""))
						else
							local remaining1 = (_23_1(args2) - variadic1)
							line_21_1(out5, _2e2e_1("local _n = _select(\"#\", ...) - ", number_2d3e_string1(remaining1)))
							append_21_1(out5, _2e2e_1("local ", argsVar1))
							local r_1281 = _23_1(args2)
							local r_1291 = 1
							local r_1261 = nil
							r_1261 = (function(r_1271)
								local _temp
								if (0 < 1) then
									_temp = (r_1271 <= r_1281)
								else
									_temp = (r_1271 >= r_1281)
								end
								if _temp then
									local i5 = r_1271
									append_21_1(out5, ", ")
									append_21_1(out5, escapeVar1(args2[i5]["var"], state3))
									return r_1261((r_1271 + r_1291))
								else
								end
							end)
							r_1261(succ1(variadic1))
							line_21_1(out5)
							beginBlock_21_1(out5, "if _n > 0 then")
							append_21_1(out5, argsVar1)
							line_21_1(out5, " = { tag=\"list\", n=_n, _unpack(_pack(...), 1, _n)}")
							local r_1321 = _23_1(args2)
							local r_1331 = 1
							local r_1301 = nil
							r_1301 = (function(r_1311)
								local _temp
								if (0 < 1) then
									_temp = (r_1311 <= r_1321)
								else
									_temp = (r_1311 >= r_1321)
								end
								if _temp then
									local i6 = r_1311
									append_21_1(out5, escapeVar1(args2[i6]["var"], state3))
									if (i6 < _23_1(args2)) then
										append_21_1(out5, ", ")
									else
									end
									return r_1301((r_1311 + r_1331))
								else
								end
							end)
							r_1301(succ1(variadic1))
							line_21_1(out5, " = select(_n + 1, ...)")
							nextBlock_21_1(out5, "else")
							append_21_1(out5, argsVar1)
							line_21_1(out5, " = { tag=\"list\", n=0}")
							local r_1361 = _23_1(args2)
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
									local i7 = r_1351
									append_21_1(out5, escapeVar1(args2[i7]["var"], state3))
									if (i7 < _23_1(args2)) then
										append_21_1(out5, ", ")
									else
									end
									return r_1341((r_1351 + r_1371))
								else
								end
							end)
							r_1341(succ1(variadic1))
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
				local r_1381 = nil
				r_1381 = (function()
					if (i8 <= _23_1(node3)) then
						local item1 = nth1(node3, i8)
						local case1 = nth1(item1, 1)
						local isFinal1
						local r_1391 = symbol_3f_1(case1)
						if r_1391 then
							isFinal1 = (case1["var"] == builtinVars1["true"])
						else
							isFinal1 = r_1391
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
						return r_1381()
					else
					end
				end)
				r_1381()
				if hadFinal1 then
				else
					indent_21_1(out5)
					line_21_1(out5)
					append_21_1(out5, "_error(\"unmatched item\")")
					unindent_21_1(out5)
					line_21_1(out5)
				end
				local r_1421 = ends1
				local r_1431 = 1
				local r_1401 = nil
				r_1401 = (function(r_1411)
					local _temp
					if (0 < 1) then
						_temp = (r_1411 <= r_1421)
					else
						_temp = (r_1411 >= r_1421)
					end
					if _temp then
						local i9 = r_1411
						append_21_1(out5, "end")
						if (i9 < ends1) then
							unindent_21_1(out5)
							line_21_1(out5)
						else
						end
						return r_1401((r_1411 + r_1431))
					else
					end
				end)
				r_1401(1)
				if closure1 then
					line_21_1(out5)
					return endBlock_21_1(out5, "end)()")
				else
				end
			elseif (var2 == builtins1["set!"]) then
				compileExpression1(nth1(node3, 3), out5, state3, _2e2e_1(escapeVar1(node3[2]["var"], state3), " = "))
				local _temp
				local r_1441 = ret1
				if r_1441 then
					_temp = (ret1 ~= "")
				else
					_temp = r_1441
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
				local r_1581 = symbol_3f_1(head1)
				if r_1581 then
					local r_1591 = (head1["var"]["tag"] == "native")
					if r_1591 then
						meta2 = state3["meta"][head1["var"]["fullName"]]
					else
						meta2 = r_1591
					end
				else
					meta2 = r_1581
				end
				local _temp
				local r_1451 = meta2
				if r_1451 then
					local r_1461
					local r_1471 = ret1
					if r_1471 then
						r_1461 = r_1471
					else
						r_1461 = (meta2["tag"] == "expr")
					end
					if r_1461 then
						_temp = (pred1(_23_1(node3)) == meta2["count"])
					else
						_temp = r_1461
					end
				else
					_temp = r_1451
				end
				if _temp then
					local _temp
					local r_1481 = ret1
					if r_1481 then
						_temp = (meta2["tag"] == "expr")
					else
						_temp = r_1481
					end
					if _temp then
						append_21_1(out5, ret1)
					else
					end
					local contents2 = meta2["contents"]
					local r_1511 = _23_1(contents2)
					local r_1521 = 1
					local r_1491 = nil
					r_1491 = (function(r_1501)
						local _temp
						if (0 < 1) then
							_temp = (r_1501 <= r_1511)
						else
							_temp = (r_1501 >= r_1511)
						end
						if _temp then
							local i10 = r_1501
							local entry2 = nth1(contents2, i10)
							if number_3f_1(entry2) then
								compileExpression1(nth1(node3, succ1(entry2)), out5, state3)
							else
								append_21_1(out5, entry2)
							end
							return r_1491((r_1501 + r_1521))
						else
						end
					end)
					r_1491(1)
					local _temp
					local r_1531 = (meta2["tag"] ~= "expr")
					if r_1531 then
						_temp = (ret1 ~= "")
					else
						_temp = r_1531
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
					local r_1561 = _23_1(node3)
					local r_1571 = 1
					local r_1541 = nil
					r_1541 = (function(r_1551)
						local _temp
						if (0 < 1) then
							_temp = (r_1551 <= r_1561)
						else
							_temp = (r_1551 >= r_1561)
						end
						if _temp then
							local i11 = r_1551
							if (i11 > 2) then
								append_21_1(out5, ", ")
							else
							end
							compileExpression1(nth1(node3, i11), out5, state3)
							return r_1541((r_1551 + r_1571))
						else
						end
					end)
					r_1541(2)
					return append_21_1(out5, ")")
				end
			end
		else
			local _temp
			local r_1601 = ret1
			if r_1601 then
				local r_1611 = list_3f_1(head1)
				if r_1611 then
					local r_1621 = symbol_3f_1(car2(head1))
					if r_1621 then
						_temp = (head1[1]["var"] == builtins1["lambda"])
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
				local args3 = nth1(head1, 2)
				local offset2 = 1
				local r_1651 = _23_1(args3)
				local r_1661 = 1
				local r_1631 = nil
				r_1631 = (function(r_1641)
					local _temp
					if (0 < 1) then
						_temp = (r_1641 <= r_1651)
					else
						_temp = (r_1641 >= r_1651)
					end
					if _temp then
						local i12 = r_1641
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
							local r_1691 = count1
							local r_1701 = 1
							local r_1671 = nil
							r_1671 = (function(r_1681)
								local _temp
								if (0 < 1) then
									_temp = (r_1681 <= r_1691)
								else
									_temp = (r_1681 >= r_1691)
								end
								if _temp then
									local j1 = r_1681
									append_21_1(out5, ", ")
									compileExpression1(nth1(node3, (i12 + j1)), out5, state3)
									return r_1671((r_1681 + r_1701))
								else
								end
							end)
							r_1671(1)
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
						return r_1631((r_1641 + r_1661))
					else
					end
				end)
				r_1631(1)
				local r_1731 = _23_1(node3)
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
						local i13 = r_1721
						compileExpression1(nth1(node3, i13), out5, state3, "")
						line_21_1(out5)
						return r_1711((r_1721 + r_1741))
					else
					end
				end)
				r_1711((_23_1(args3) + (offset2 + 1)))
				return compileBlock1(head1, out5, state3, 3, ret1)
			else
				if ret1 then
					append_21_1(out5, ret1)
				else
				end
				compileExpression1(car2(node3), out5, state3)
				append_21_1(out5, "(")
				local r_1771 = _23_1(node3)
				local r_1781 = 1
				local r_1751 = nil
				r_1751 = (function(r_1761)
					local _temp
					if (0 < 1) then
						_temp = (r_1761 <= r_1771)
					else
						_temp = (r_1761 >= r_1771)
					end
					if _temp then
						local i14 = r_1761
						if (i14 > 2) then
							append_21_1(out5, ", ")
						else
						end
						compileExpression1(nth1(node3, i14), out5, state3)
						return r_1751((r_1761 + r_1781))
					else
					end
				end)
				r_1751(2)
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
	local r_901 = _23_1(nodes1)
	local r_911 = 1
	local r_881 = nil
	r_881 = (function(r_891)
		local _temp
		if (0 < 1) then
			_temp = (r_891 <= r_901)
		else
			_temp = (r_891 >= r_901)
		end
		if _temp then
			local i15 = r_891
			local ret_27_1
			if (i15 == _23_1(nodes1)) then
				ret_27_1 = ret3
			else
				ret_27_1 = ""
			end
			compileExpression1(nth1(nodes1, i15), out6, state4, ret_27_1)
			line_21_1(out6)
			return r_881((r_891 + r_911))
		else
		end
	end)
	return r_881(start1)
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
	local r_1791 = (tag2 == "string")
	if r_1791 then
		_temp = r_1791
	else
		local r_1801 = (tag2 == "number")
		if r_1801 then
			_temp = r_1801
		else
			local r_1811 = (tag2 == "symbol")
			if r_1811 then
				_temp = r_1811
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
		local r_1911 = nil
		r_1911 = (function()
			local _temp
			local r_1921 = (sum1 <= max1)
			if r_1921 then
				_temp = (i16 <= _23_1(node4))
			else
				_temp = r_1921
			end
			if _temp then
				sum1 = (sum1 + estimateLength1(nth1(node4, i16), (max1 - sum1)))
				if (i16 > 1) then
					sum1 = (sum1 + 1)
				else
				end
				i16 = (i16 + 1)
				return r_1911()
			else
			end
		end)
		r_1911()
		return sum1
	else
		return fail_21_1(_2e2e_1("Unknown tag ", tag2))
	end
end)
expression1 = (function(node5, writer9)
	local tag3 = node5["tag"]
	local _temp
	local r_1821 = (tag3 == "string")
	if r_1821 then
		_temp = r_1821
	else
		local r_1831 = (tag3 == "number")
		if r_1831 then
			_temp = r_1831
		else
			local r_1841 = (tag3 == "symbol")
			if r_1841 then
				_temp = r_1841
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
			local max2 = (60 - estimateLength1(car2(node5), 60))
			expression1(car2(node5), writer9)
			if (max2 <= 0) then
				newline1 = true
				indent_21_1(writer9)
			else
			end
			local r_1951 = _23_1(node5)
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
					local i17 = r_1941
					local entry3 = nth1(node5, i17)
					local _temp
					local r_1971 = _21_1(newline1)
					if r_1971 then
						_temp = (max2 > 0)
					else
						_temp = r_1971
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
					return r_1931((r_1941 + r_1961))
				else
				end
			end)
			r_1931(2)
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
	local r_1861 = list2
	local r_1891 = _23_1(r_1861)
	local r_1901 = 1
	local r_1871 = nil
	r_1871 = (function(r_1881)
		local _temp
		if (0 < 1) then
			_temp = (r_1881 <= r_1891)
		else
			_temp = (r_1881 >= r_1891)
		end
		if _temp then
			local r_1851 = r_1881
			local node6 = r_1861[r_1851]
			expression1(node6, writer10)
			line_21_1(writer10)
			return r_1871((r_1881 + r_1901))
		else
		end
	end)
	return r_1871(1)
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
