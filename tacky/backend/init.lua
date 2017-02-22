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
				for i = 1, x.n do
					y[i] = pretty(x[i])
				end
				return '(' .. table.concat(y, ' ') .. ')'
			elseif x.tag == 'symbol' then
				return x.contents
			elseif x.tag == 'key' then
				return ":" .. x.value
			elseif x.tag == 'string' then
				return (("%q"):format(x.value):gsub("\n", "n"):gsub("\t", "\\9"))
			elseif x.tag == 'number' then
				return tostring(x.value)
			elseif x.tag.tag and x.tag.tag == 'symbol' and x.tag.contents == 'pair' then
				return '(pair ' .. pretty(x.fst) .. ' ' .. pretty(x.snd) .. ')'
			elseif x.tag == 'thunk' then
				return '<<thunk>>'
			else
				return tostring(x)
			end
		elseif type(x) == 'string' then
			return ("%q"):format(x)
		else
			return tostring(x)
		end
	end
	if arg then
		if not arg.n then arg.n = #arg end
		if not arg.tag then arg.tag = "list" end
	else
		arg = { tag = "list", n = 0 }
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
		_G = _G, _ENV = _ENV, _VERSION = _VERSION, arg = arg,
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
		xpcall = xpcall,
		["get-idx"] = function(x, i) return x[i] end,
		["set-idx!"] = function(x, k, v) x[k] = v end
	}
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
local _3d_1, _2f3d_1, _3c_1, _3c3d_1, _3e_1, _2b_1, _2d_1, _25_1, error1, getIdx1, setIdx_21_1, require1, tostring1, type_23_1, _23_1, concat1, unpack1, emptyStruct1, car1, list1, _21_1, byte1, find1, format1, gsub1, len1, rep1, sub1, upper1, list_3f_1, nil_3f_1, string_3f_1, number_3f_1, symbol_3f_1, key_3f_1, type1, car2, nth1, pushCdr_21_1, charAt1, _2e2e_1, _23_s1, quoted1, struct1, succ1, pred1, number_2d3e_string1, error_21_1, fail_21_1, create1, append_21_1, line_21_1, indent_21_1, unindent_21_1, beginBlock_21_1, nextBlock_21_1, endBlock_21_1, _2d3e_string1, createLookup1, keywords1, createState1, builtins1, builtinVars1, escape1, escapeVar1, statement_3f_1, truthy_3f_1, compileQuote1, compileExpression1, compileBlock1, prelude1, backend1, estimateLength1, expression1, block1, backend2, wrapGenerate1, wrapNormal1
_3d_1 = _libs["lib/lua/basic/="]
_2f3d_1 = _libs["lib/lua/basic//="]
_3c_1 = _libs["lib/lua/basic/<"]
_3c3d_1 = _libs["lib/lua/basic/<="]
_3e_1 = _libs["lib/lua/basic/>"]
_2b_1 = _libs["lib/lua/basic/+"]
_2d_1 = _libs["lib/lua/basic/-"]
_25_1 = _libs["lib/lua/basic/%"]
error1 = _libs["lib/lua/basic/error"]
getIdx1 = _libs["lib/lua/basic/get-idx"]
setIdx_21_1 = _libs["lib/lua/basic/set-idx!"]
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
	local r_31 = x3
	if r_31 then
		local r_41 = list_3f_1(x3)
		if r_41 then
			return (_23_1(x3) == 0)
		else
			return r_41
		end
	else
		return r_31
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
	local r_241 = type1(x8)
	if (r_241 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_241), 2)
	else
	end
	return car1(x8)
end)
nth1 = getIdx1
pushCdr_21_1 = (function(xs3, val2)
	local r_341 = type1(xs3)
	if (r_341 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_341), 2)
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
local escapes1 = emptyStruct1()
escapes1["\9"] = "\\9"
escapes1["\n"] = "n"
quoted1 = (function(str1)
	local result1 = gsub1(format1("%q", str1), ".", escapes1)
	return result1
end)
struct1 = (function(...)
	local keys1 = _pack(...) keys1.tag = "list"
	if ((_23_1(keys1) % 1) == 1) then
		error1("Expected an even number of arguments to struct", 2)
	else
	end
	local contents1 = (function(key1)
		return key1["contents"]
	end)
	local out1 = emptyStruct1()
	local r_591 = _23_1(keys1)
	local r_601 = 2
	local r_571 = nil
	r_571 = (function(r_581)
		if (r_581 <= r_591) then
			local i1 = r_581
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
			return r_571((r_581 + 2))
		else
		end
	end)
	r_571(1)
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
	local r_891 = type1(text1)
	if (r_891 ~= "string") then
		error1(format1("bad argment %s (expected %s, got %s)", "text", "string", r_891), 2)
	else
	end
	if writer1["tabs-pending"] then
		writer1["tabs-pending"] = false
		pushCdr_21_1(writer1["out"], rep1("\9", writer1["indent"]))
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
	local r_911 = lst1
	local r_941 = _23_1(r_911)
	local r_951 = 1
	local r_921 = nil
	r_921 = (function(r_931)
		if (r_931 <= r_941) then
			local r_901 = r_931
			local entry1 = r_911[r_901]
			out2[entry1] = true
			return r_921((r_931 + 1))
		else
		end
	end)
	r_921(1)
	return out2
end)
keywords1 = createLookup1("and", "break", "do", "else", "elseif", "end", "false", "for", "function", "if", "in", "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while")
createState1 = (function(meta1)
	return struct1("ctr-lookup", emptyStruct1(), "var-lookup", emptyStruct1(), "meta", (function(r_961)
		if r_961 then
			return r_961
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
		local r_1061 = _23_s1(name1)
		local r_1071 = 1
		local r_1041 = nil
		r_1041 = (function(r_1051)
			if (r_1051 <= r_1061) then
				local i2 = r_1051
				local char1 = charAt1(name1, i2)
				local temp1
				local r_1081 = (char1 == "-")
				if r_1081 then
					local r_1091 = find1(charAt1(name1, pred1(i2)), "[%a%d']")
					if r_1091 then
						temp1 = find1(charAt1(name1, succ1(i2)), "[%a%d']")
					else
						temp1 = r_1091
					end
				else
					temp1 = r_1081
				end
				if temp1 then
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
				return r_1041((r_1051 + 1))
			else
			end
		end)
		r_1041(1)
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
			id1 = succ1((function(r_971)
				if r_971 then
					return r_971
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
statement_3f_1 = (function(node1)
	if list_3f_1(node1) then
		local first1 = car2(node1)
		if symbol_3f_1(first1) then
			return (first1["var"] == builtins1["cond"])
		elseif list_3f_1(first1) then
			local func1 = car2(first1)
			local r_981 = symbol_3f_1(func1)
			if r_981 then
				return (func1["var"] == builtins1["lambda"])
			else
				return r_981
			end
		else
			return false
		end
	else
		return false
	end
end)
truthy_3f_1 = (function(node2)
	local r_991 = symbol_3f_1(node2)
	if r_991 then
		return (builtinVars1["true"] == node2["var"])
	else
		return r_991
	end
end)
compileQuote1 = (function(node3, out4, state2, level1)
	if (level1 == 0) then
		return compileExpression1(node3, out4, state2)
	else
		local ty2 = type1(node3)
		if (ty2 == "string") then
			return append_21_1(out4, quoted1(node3["value"]))
		elseif (ty2 == "number") then
			return append_21_1(out4, number_2d3e_string1(node3["value"]))
		elseif (ty2 == "symbol") then
			append_21_1(out4, _2e2e_1("{ tag=\"symbol\", contents=", quoted1(node3["contents"])))
			if node3["var"] then
				append_21_1(out4, _2e2e_1(", var=", quoted1(number_2d3e_string1(node3["var"]))))
			else
			end
			return append_21_1(out4, "}")
		elseif (ty2 == "key") then
			return append_21_1(out4, _2e2e_1("{tag=\"key\", value=", quoted1(node3["value"]), "}"))
		elseif (ty2 == "list") then
			local first2 = car2(node3)
			local temp2
			local r_1101 = symbol_3f_1(first2)
			if r_1101 then
				local r_1111 = (first2["var"] == builtins1["unquote"])
				if r_1111 then
					temp2 = r_1111
				else
					temp2 = ("var" == builtins1["unquote-splice"])
				end
			else
				temp2 = r_1101
			end
			if temp2 then
				return compileQuote1(nth1(node3, 2), out4, state2, (function(r_1121)
					if r_1121 then
						return pred1(level1)
					else
						return r_1121
					end
				end)(level1))
			else
				local temp3
				local r_1131 = symbol_3f_1(first2)
				if r_1131 then
					temp3 = (first2["var"] == builtins1["quasiquote"])
				else
					temp3 = r_1131
				end
				if temp3 then
					return compileQuote1(nth1(node3, 2), out4, state2, (function(r_1141)
						if r_1141 then
							return succ1(level1)
						else
							return r_1141
						end
					end)(level1))
				else
					local containsUnsplice1 = false
					local r_1161 = node3
					local r_1191 = _23_1(r_1161)
					local r_1201 = 1
					local r_1171 = nil
					r_1171 = (function(r_1181)
						if (r_1181 <= r_1191) then
							local r_1151 = r_1181
							local sub2 = r_1161[r_1151]
							local temp4
							local r_1211 = list_3f_1(sub2)
							if r_1211 then
								local r_1221 = symbol_3f_1(car2(sub2))
								if r_1221 then
									temp4 = (sub2[1]["var"] == builtins1["unquote-splice"])
								else
									temp4 = r_1221
								end
							else
								temp4 = r_1211
							end
							if temp4 then
								containsUnsplice1 = true
							else
							end
							return r_1171((r_1181 + 1))
						else
						end
					end)
					r_1171(1)
					if containsUnsplice1 then
						local offset1 = 0
						beginBlock_21_1(out4, "(function()")
						line_21_1(out4, "local _offset, _result, _temp = 0, {tag=\"list\",n=0}")
						local r_1251 = _23_1(node3)
						local r_1261 = 1
						local r_1231 = nil
						r_1231 = (function(r_1241)
							if (r_1241 <= r_1251) then
								local i3 = r_1241
								local sub3 = nth1(node3, i3)
								local temp5
								local r_1271 = list_3f_1(sub3)
								if r_1271 then
									local r_1281 = symbol_3f_1(car2(sub3))
									if r_1281 then
										temp5 = (sub3[1]["var"] == builtins1["unquote-splice"])
									else
										temp5 = r_1281
									end
								else
									temp5 = r_1271
								end
								if temp5 then
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
								return r_1231((r_1241 + 1))
							else
							end
						end)
						r_1231(1)
						line_21_1(out4, _2e2e_1("_result.n = _offset + ", number_2d3e_string1((_23_1(node3) - offset1))))
						line_21_1(out4, "return _result")
						return endBlock_21_1(out4, "end)()")
					else
						append_21_1(out4, _2e2e_1("{tag = \"list\", n =", number_2d3e_string1(_23_1(node3))))
						local r_1321 = node3
						local r_1351 = _23_1(r_1321)
						local r_1361 = 1
						local r_1331 = nil
						r_1331 = (function(r_1341)
							if (r_1341 <= r_1351) then
								local r_1311 = r_1341
								local sub4 = r_1321[r_1311]
								append_21_1(out4, ", ")
								compileQuote1(sub4, out4, state2, level1)
								return r_1331((r_1341 + 1))
							else
							end
						end)
						r_1331(1)
						return append_21_1(out4, "}")
					end
				end
			end
		else
			return error_21_1(_2e2e_1("Unknown type ", ty2))
		end
	end
end)
compileExpression1 = (function(node4, out5, state3, ret1)
	if list_3f_1(node4) then
		local head1 = car2(node4)
		if symbol_3f_1(head1) then
			local var2 = head1["var"]
			if (var2 == builtins1["lambda"]) then
				if (ret1 == "") then
				else
					if ret1 then
						append_21_1(out5, ret1)
					else
					end
					local args2 = nth1(node4, 2)
					local variadic1 = nil
					local i4 = 1
					append_21_1(out5, "(function(")
					local r_1291 = nil
					r_1291 = (function()
						local temp6
						local r_1301 = (i4 <= _23_1(args2))
						if r_1301 then
							temp6 = _21_1(variadic1)
						else
							temp6 = r_1301
						end
						if temp6 then
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
							return r_1291()
						else
						end
					end)
					r_1291()
					beginBlock_21_1(out5, ")")
					if variadic1 then
						local argsVar1 = escapeVar1(args2[variadic1]["var"], state3)
						if (variadic1 == _23_1(args2)) then
							line_21_1(out5, _2e2e_1("local ", argsVar1, " = _pack(...) ", argsVar1, ".tag = \"list\""))
						else
							local remaining1 = (_23_1(args2) - variadic1)
							line_21_1(out5, _2e2e_1("local _n = _select(\"#\", ...) - ", number_2d3e_string1(remaining1)))
							append_21_1(out5, _2e2e_1("local ", argsVar1))
							local r_1391 = _23_1(args2)
							local r_1401 = 1
							local r_1371 = nil
							r_1371 = (function(r_1381)
								if (r_1381 <= r_1391) then
									local i5 = r_1381
									append_21_1(out5, ", ")
									append_21_1(out5, escapeVar1(args2[i5]["var"], state3))
									return r_1371((r_1381 + 1))
								else
								end
							end)
							r_1371(succ1(variadic1))
							line_21_1(out5)
							beginBlock_21_1(out5, "if _n > 0 then")
							append_21_1(out5, argsVar1)
							line_21_1(out5, " = { tag=\"list\", n=_n, _unpack(_pack(...), 1, _n)}")
							local r_1431 = _23_1(args2)
							local r_1441 = 1
							local r_1411 = nil
							r_1411 = (function(r_1421)
								if (r_1421 <= r_1431) then
									local i6 = r_1421
									append_21_1(out5, escapeVar1(args2[i6]["var"], state3))
									if (i6 < _23_1(args2)) then
										append_21_1(out5, ", ")
									else
									end
									return r_1411((r_1421 + 1))
								else
								end
							end)
							r_1411(succ1(variadic1))
							line_21_1(out5, " = select(_n + 1, ...)")
							nextBlock_21_1(out5, "else")
							append_21_1(out5, argsVar1)
							line_21_1(out5, " = { tag=\"list\", n=0}")
							local r_1471 = _23_1(args2)
							local r_1481 = 1
							local r_1451 = nil
							r_1451 = (function(r_1461)
								if (r_1461 <= r_1471) then
									local i7 = r_1461
									append_21_1(out5, escapeVar1(args2[i7]["var"], state3))
									if (i7 < _23_1(args2)) then
										append_21_1(out5, ", ")
									else
									end
									return r_1451((r_1461 + 1))
								else
								end
							end)
							r_1451(succ1(variadic1))
							line_21_1(out5, " = ...")
							endBlock_21_1(out5, "end")
						end
					else
					end
					compileBlock1(node4, out5, state3, 3, "return ")
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
				local r_1491 = nil
				r_1491 = (function()
					local temp7
					local r_1501 = _21_1(hadFinal1)
					if r_1501 then
						temp7 = (i8 <= _23_1(node4))
					else
						temp7 = r_1501
					end
					if temp7 then
						local item1 = nth1(node4, i8)
						local case1 = nth1(item1, 1)
						local isFinal1 = truthy_3f_1(case1)
						if isFinal1 then
							if (i8 == 2) then
								append_21_1(out5, "do")
							else
							end
						elseif statement_3f_1(case1) then
							if (i8 > 2) then
								indent_21_1(out5)
								line_21_1(out5)
								ends1 = (ends1 + 1)
							else
							end
							local tmp1 = escapeVar1(struct1("name", "temp"), state3)
							line_21_1(out5, _2e2e_1("local ", tmp1))
							compileExpression1(case1, out5, state3, _2e2e_1(tmp1, " = "))
							line_21_1(out5)
							line_21_1(out5, _2e2e_1("if ", tmp1, " then"))
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
						return r_1491()
					else
					end
				end)
				r_1491()
				if hadFinal1 then
				else
					indent_21_1(out5)
					line_21_1(out5)
					append_21_1(out5, "_error(\"unmatched item\")")
					unindent_21_1(out5)
					line_21_1(out5)
				end
				local r_1531 = ends1
				local r_1541 = 1
				local r_1511 = nil
				r_1511 = (function(r_1521)
					if (r_1521 <= r_1531) then
						local i9 = r_1521
						append_21_1(out5, "end")
						if (i9 < ends1) then
							unindent_21_1(out5)
							line_21_1(out5)
						else
						end
						return r_1511((r_1521 + 1))
					else
					end
				end)
				r_1511(1)
				if closure1 then
					line_21_1(out5)
					return endBlock_21_1(out5, "end)()")
				else
				end
			elseif (var2 == builtins1["set!"]) then
				compileExpression1(nth1(node4, 3), out5, state3, _2e2e_1(escapeVar1(node4[2]["var"], state3), " = "))
				local temp8
				local r_1551 = ret1
				if r_1551 then
					temp8 = (ret1 ~= "")
				else
					temp8 = r_1551
				end
				if temp8 then
					line_21_1(out5)
					append_21_1(out5, ret1)
					return append_21_1(out5, "nil")
				else
				end
			elseif (var2 == builtins1["define"]) then
				return compileExpression1(nth1(node4, _23_1(node4)), out5, state3, _2e2e_1(escapeVar1(node4["defVar"], state3), " = "))
			elseif (var2 == builtins1["define-macro"]) then
				return compileExpression1(nth1(node4, _23_1(node4)), out5, state3, _2e2e_1(escapeVar1(node4["defVar"], state3), " = "))
			elseif (var2 == builtins1["define-native"]) then
				return append_21_1(out5, format1("%s = _libs[%q]", escapeVar1(node4["defVar"], state3), node4["defVar"]["fullName"]))
			elseif (var2 == builtins1["quote"]) then
				if (ret1 == "") then
				else
					if ret1 then
						append_21_1(out5, ret1)
					else
					end
					return compileQuote1(nth1(node4, 2), out5, state3)
				end
			elseif (var2 == builtins1["quasiquote"]) then
				if (ret1 == "") then
					append_21_1(out5, "local _ =")
				elseif ret1 then
					append_21_1(out5, ret1)
				else
				end
				return compileQuote1(nth1(node4, 2), out5, state3, 1)
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
				local r_1691 = symbol_3f_1(head1)
				if r_1691 then
					local r_1701 = (head1["var"]["tag"] == "native")
					if r_1701 then
						meta2 = state3["meta"][head1["var"]["fullName"]]
					else
						meta2 = r_1701
					end
				else
					meta2 = r_1691
				end
				local temp9
				local r_1561 = meta2
				if r_1561 then
					local r_1571
					local r_1581 = ret1
					if r_1581 then
						r_1571 = r_1581
					else
						r_1571 = (meta2["tag"] == "expr")
					end
					if r_1571 then
						temp9 = (pred1(_23_1(node4)) == meta2["count"])
					else
						temp9 = r_1571
					end
				else
					temp9 = r_1561
				end
				if temp9 then
					local temp10
					local r_1591 = ret1
					if r_1591 then
						temp10 = (meta2["tag"] == "expr")
					else
						temp10 = r_1591
					end
					if temp10 then
						append_21_1(out5, ret1)
					else
					end
					local contents2 = meta2["contents"]
					local r_1621 = _23_1(contents2)
					local r_1631 = 1
					local r_1601 = nil
					r_1601 = (function(r_1611)
						if (r_1611 <= r_1621) then
							local i10 = r_1611
							local entry2 = nth1(contents2, i10)
							if number_3f_1(entry2) then
								compileExpression1(nth1(node4, succ1(entry2)), out5, state3)
							else
								append_21_1(out5, entry2)
							end
							return r_1601((r_1611 + 1))
						else
						end
					end)
					r_1601(1)
					local temp11
					local r_1641 = (meta2["tag"] ~= "expr")
					if r_1641 then
						temp11 = (ret1 ~= "")
					else
						temp11 = r_1641
					end
					if temp11 then
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
					local r_1671 = _23_1(node4)
					local r_1681 = 1
					local r_1651 = nil
					r_1651 = (function(r_1661)
						if (r_1661 <= r_1671) then
							local i11 = r_1661
							if (i11 > 2) then
								append_21_1(out5, ", ")
							else
							end
							compileExpression1(nth1(node4, i11), out5, state3)
							return r_1651((r_1661 + 1))
						else
						end
					end)
					r_1651(2)
					return append_21_1(out5, ")")
				end
			end
		else
			local temp12
			local r_1711 = ret1
			if r_1711 then
				local r_1721 = list_3f_1(head1)
				if r_1721 then
					local r_1731 = symbol_3f_1(car2(head1))
					if r_1731 then
						temp12 = (head1[1]["var"] == builtins1["lambda"])
					else
						temp12 = r_1731
					end
				else
					temp12 = r_1721
				end
			else
				temp12 = r_1711
			end
			if temp12 then
				local args3 = nth1(head1, 2)
				local offset2 = 1
				local r_1761 = _23_1(args3)
				local r_1771 = 1
				local r_1741 = nil
				r_1741 = (function(r_1751)
					if (r_1751 <= r_1761) then
						local i12 = r_1751
						local var4 = args3[i12]["var"]
						append_21_1(out5, _2e2e_1("local ", escapeVar1(var4, state3)))
						if var4["isVariadic"] then
							local count1 = (_23_1(node4) - _23_1(args3))
							if (count1 < 0) then
								count1 = 0
							else
							end
							append_21_1(out5, " = { tag=\"list\", n=")
							append_21_1(out5, number_2d3e_string1(count1))
							local r_1801 = count1
							local r_1811 = 1
							local r_1781 = nil
							r_1781 = (function(r_1791)
								if (r_1791 <= r_1801) then
									local j1 = r_1791
									append_21_1(out5, ", ")
									compileExpression1(nth1(node4, (i12 + j1)), out5, state3)
									return r_1781((r_1791 + 1))
								else
								end
							end)
							r_1781(1)
							offset2 = count1
							line_21_1(out5, "}")
						else
							local expr2 = nth1(node4, (i12 + offset2))
							local name2 = escapeVar1(var4, state3)
							local ret2 = nil
							if expr2 then
								if statement_3f_1(expr2) then
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
						return r_1741((r_1751 + 1))
					else
					end
				end)
				r_1741(1)
				local r_1841 = _23_1(node4)
				local r_1851 = 1
				local r_1821 = nil
				r_1821 = (function(r_1831)
					if (r_1831 <= r_1841) then
						local i13 = r_1831
						compileExpression1(nth1(node4, i13), out5, state3, "")
						line_21_1(out5)
						return r_1821((r_1831 + 1))
					else
					end
				end)
				r_1821((_23_1(args3) + (offset2 + 1)))
				return compileBlock1(head1, out5, state3, 3, ret1)
			else
				if ret1 then
					append_21_1(out5, ret1)
				else
				end
				compileExpression1(car2(node4), out5, state3)
				append_21_1(out5, "(")
				local r_1881 = _23_1(node4)
				local r_1891 = 1
				local r_1861 = nil
				r_1861 = (function(r_1871)
					if (r_1871 <= r_1881) then
						local i14 = r_1871
						if (i14 > 2) then
							append_21_1(out5, ", ")
						else
						end
						compileExpression1(nth1(node4, i14), out5, state3)
						return r_1861((r_1871 + 1))
					else
					end
				end)
				r_1861(2)
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
			if symbol_3f_1(node4) then
				return append_21_1(out5, escapeVar1(node4["var"], state3))
			elseif string_3f_1(node4) then
				return append_21_1(out5, quoted1(node4["value"]))
			elseif number_3f_1(node4) then
				return append_21_1(out5, number_2d3e_string1(node4["value"]))
			elseif key_3f_1(node4) then
				return append_21_1(out5, quoted1(node4["value"]))
			else
				return error_21_1(_2e2e_1("Unknown type: ", type1(node4)))
			end
		end
	end
end)
compileBlock1 = (function(nodes1, out6, state4, start1, ret3)
	local r_1021 = _23_1(nodes1)
	local r_1031 = 1
	local r_1001 = nil
	r_1001 = (function(r_1011)
		if (r_1011 <= r_1021) then
			local i15 = r_1011
			local ret_27_1
			if (i15 == _23_1(nodes1)) then
				ret_27_1 = ret3
			else
				ret_27_1 = ""
			end
			compileExpression1(nth1(nodes1, i15), out6, state4, ret_27_1)
			line_21_1(out6)
			return r_1001((r_1011 + 1))
		else
		end
	end)
	return r_1001(start1)
end)
prelude1 = (function(out7)
	line_21_1(out7, "if not table.pack then table.pack = function(...) return { n = select(\"#\", ...), ... } end end")
	line_21_1(out7, "if not table.unpack then table.unpack = unpack end")
	line_21_1(out7, "if _VERSION:find(\"5.1\") then local function load(x, _, _, env) local f, e = loadstring(x); if not f then error(e, 1) end; return setfenv(f, env) end end")
	return line_21_1(out7, "local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error")
end)
backend1 = struct1("createState", createState1, "escape", escape1, "escapeVar", escapeVar1, "block", compileBlock1, "expression", compileExpression1, "prelude", prelude1)
estimateLength1 = (function(node5, max1)
	local tag2 = node5["tag"]
	local temp13
	local r_1901 = (tag2 == "string")
	if r_1901 then
		temp13 = r_1901
	else
		local r_1911 = (tag2 == "number")
		if r_1911 then
			temp13 = r_1911
		else
			local r_1921 = (tag2 == "symbol")
			if r_1921 then
				temp13 = r_1921
			else
				temp13 = (tag2 == "key")
			end
		end
	end
	if temp13 then
		return _23_s1(number_2d3e_string1(node5["contents"]))
	elseif (tag2 == "list") then
		local sum1 = 2
		local i16 = 1
		local r_2021 = nil
		r_2021 = (function()
			local temp14
			local r_2031 = (sum1 <= max1)
			if r_2031 then
				temp14 = (i16 <= _23_1(node5))
			else
				temp14 = r_2031
			end
			if temp14 then
				sum1 = (sum1 + estimateLength1(nth1(node5, i16), (max1 - sum1)))
				if (i16 > 1) then
					sum1 = (sum1 + 1)
				else
				end
				i16 = (i16 + 1)
				return r_2021()
			else
			end
		end)
		r_2021()
		return sum1
	else
		return fail_21_1(_2e2e_1("Unknown tag ", tag2))
	end
end)
expression1 = (function(node6, writer9)
	local tag3 = node6["tag"]
	local temp15
	local r_1931 = (tag3 == "string")
	if r_1931 then
		temp15 = r_1931
	else
		local r_1941 = (tag3 == "number")
		if r_1941 then
			temp15 = r_1941
		else
			local r_1951 = (tag3 == "symbol")
			if r_1951 then
				temp15 = r_1951
			else
				temp15 = (tag3 == "key")
			end
		end
	end
	if temp15 then
		return append_21_1(writer9, number_2d3e_string1(node6["contents"]))
	elseif (tag3 == "list") then
		append_21_1(writer9, "(")
		if nil_3f_1(node6) then
			return append_21_1(writer9, ")")
		else
			local newline1 = false
			local max2 = (60 - estimateLength1(car2(node6), 60))
			expression1(car2(node6), writer9)
			if (max2 <= 0) then
				newline1 = true
				indent_21_1(writer9)
			else
			end
			local r_2061 = _23_1(node6)
			local r_2071 = 1
			local r_2041 = nil
			r_2041 = (function(r_2051)
				if (r_2051 <= r_2061) then
					local i17 = r_2051
					local entry3 = nth1(node6, i17)
					local temp16
					local r_2081 = _21_1(newline1)
					if r_2081 then
						temp16 = (max2 > 0)
					else
						temp16 = r_2081
					end
					if temp16 then
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
					return r_2041((r_2051 + 1))
				else
				end
			end)
			r_2041(2)
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
	local r_1971 = list2
	local r_2001 = _23_1(r_1971)
	local r_2011 = 1
	local r_1981 = nil
	r_1981 = (function(r_1991)
		if (r_1991 <= r_2001) then
			local r_1961 = r_1991
			local node7 = r_1971[r_1961]
			expression1(node7, writer10)
			line_21_1(writer10)
			return r_1981((r_1991 + 1))
		else
		end
	end)
	return r_1981(1)
end)
backend2 = struct1("expression", expression1, "block", block1)
wrapGenerate1 = (function(func2)
	return (function(node8, ...)
		local args4 = _pack(...) args4.tag = "list"
		local writer11 = create1()
		func2(node8, writer11, unpack1(args4))
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
