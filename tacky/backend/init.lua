if not table.pack then table.pack = function(...) return { n = select("#", ...), ... } end end
if not table.unpack then table.unpack = unpack end
local load = load if _VERSION:find("5.1") then load = function(x, _, _, env) local f, e = loadstring(x); if not f then error(e, 1) end; return setfenv(f, env) end end
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
local _temp = (function()
	return math
end)()
for k, v in pairs(_temp) do _libs["lib/lua/math/".. k] = v end
local _3d_1, _2f3d_1, _3c_1, _3c3d_1, _3e_1, _3e3d_1, _2b_1, _2d_1, _25_1, slice1, error1, print1, getIdx1, setIdx_21_1, require1, tostring1, type_23_1, _23_1, concat1, sort1, unpack1, emptyStruct1, iterPairs1, car1, cdr1, list1, cons1, _21_1, byte1, find1, format1, gsub1, len1, match1, rep1, sub1, upper1, list_3f_1, nil_3f_1, string_3f_1, number_3f_1, symbol_3f_1, key_3f_1, exists_3f_1, type1, car2, cdr2, foldr1, map1, traverse1, nth1, pushCdr_21_1, reverse1, cadr1, charAt1, _2e2e_1, _23_s1, split1, quoted1, struct1, succ1, pred1, number_2d3e_string1, error_21_1, print_21_1, fail_21_1, create1, append_21_1, line_21_1, indent_21_1, unindent_21_1, beginBlock_21_1, nextBlock_21_1, endBlock_21_1, _2d3e_string1, createLookup1, keywords1, createState1, builtins1, builtinVars1, escape1, escapeVar1, statement_3f_1, truthy_3f_1, compileQuote1, compileExpression1, compileBlock1, prelude1, backend1, estimateLength1, expression1, block1, backend2, abs1, max3, builtins2, tokens1, extractSignature1, parseDocstring1, verbosity1, setVerbosity_21_1, showExplain1, setExplain_21_1, colored1, printError_21_1, printWarning_21_1, printVerbose_21_1, printDebug_21_1, formatPosition1, formatRange1, formatNode1, getSource1, putLines_21_1, putTrace_21_1, putExplain_21_1, errorPositions_21_1, formatRange2, sortVars_21_1, formatDefinition1, formatSignature1, exported1, backend3, wrapGenerate1, wrapNormal1
_3d_1 = _libs["lib/lua/basic/="]
_2f3d_1 = _libs["lib/lua/basic//="]
_3c_1 = _libs["lib/lua/basic/<"]
_3c3d_1 = _libs["lib/lua/basic/<="]
_3e_1 = _libs["lib/lua/basic/>"]
_3e3d_1 = _libs["lib/lua/basic/>="]
_2b_1 = _libs["lib/lua/basic/+"]
_2d_1 = _libs["lib/lua/basic/-"]
_25_1 = _libs["lib/lua/basic/%"]
slice1 = _libs["lib/lua/basic/slice"]
error1 = _libs["lib/lua/basic/error"]
print1 = _libs["lib/lua/basic/print"]
getIdx1 = _libs["lib/lua/basic/get-idx"]
setIdx_21_1 = _libs["lib/lua/basic/set-idx!"]
require1 = _libs["lib/lua/basic/require"]
tostring1 = _libs["lib/lua/basic/tostring"]
type_23_1 = _libs["lib/lua/basic/type#"]
_23_1 = (function(x1)
	return x1["n"]
end)
concat1 = _libs["lib/lua/table/concat"]
sort1 = _libs["lib/lua/table/sort"]
unpack1 = _libs["lib/lua/table/unpack"]
emptyStruct1 = _libs["lib/lua/table/empty-struct"]
iterPairs1 = _libs["lib/lua/table/iter-pairs"]
car1 = (function(xs1)
	return xs1[1]
end)
cdr1 = (function(xs2)
	return slice1(xs2, 2)
end)
list1 = (function(...)
	local xs3 = _pack(...) xs3.tag = "list"
	return xs3
end)
cons1 = (function(x2, xs4)
	return list1(x2, unpack1(xs4))
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
match1 = _libs["lib/lua/string/match"]
rep1 = _libs["lib/lua/string/rep"]
sub1 = _libs["lib/lua/string/sub"]
upper1 = _libs["lib/lua/string/upper"]
list_3f_1 = (function(x3)
	return (type1(x3) == "list")
end)
nil_3f_1 = (function(x4)
	local r_31 = x4
	if r_31 then
		local r_41 = list_3f_1(x4)
		if r_41 then
			return (_23_1(x4) == 0)
		else
			return r_41
		end
	else
		return r_31
	end
end)
string_3f_1 = (function(x5)
	return (type1(x5) == "string")
end)
number_3f_1 = (function(x6)
	return (type1(x6) == "number")
end)
symbol_3f_1 = (function(x7)
	return (type1(x7) == "symbol")
end)
key_3f_1 = (function(x8)
	return (type1(x8) == "key")
end)
exists_3f_1 = (function(x9)
	return _21_1((type1(x9) == "nil"))
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
car2 = (function(x10)
	local r_241 = type1(x10)
	if (r_241 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_241), 2)
	else
	end
	return car1(x10)
end)
cdr2 = (function(x11)
	local r_251 = type1(x11)
	if (r_251 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_251), 2)
	else
	end
	if nil_3f_1(x11) then
		return {tag = "list", n =0}
	else
		return cdr1(x11)
	end
end)
foldr1 = (function(f1, z1, xs5)
	local r_261 = type1(f1)
	if (r_261 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "f", "function", r_261), 2)
	else
	end
	local r_381 = type1(xs5)
	if (r_381 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_381), 2)
	else
	end
	if nil_3f_1(xs5) then
		return z1
	else
		local head1 = car2(xs5)
		local tail1 = cdr2(xs5)
		return f1(head1, foldr1(f1, z1, tail1))
	end
end)
map1 = (function(f2, xs6, acc1)
	local r_271 = type1(f2)
	if (r_271 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "f", "function", r_271), 2)
	else
	end
	local r_391 = type1(xs6)
	if (r_391 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_391), 2)
	else
	end
	if _21_1(exists_3f_1(acc1)) then
		return map1(f2, xs6, {tag = "list", n =0})
	elseif nil_3f_1(xs6) then
		return reverse1(acc1)
	else
		return map1(f2, cdr2(xs6), cons1(f2(car2(xs6)), acc1))
	end
end)
traverse1 = (function(xs7, f3)
	return map1(f3, xs7)
end)
nth1 = getIdx1
pushCdr_21_1 = (function(xs8, val2)
	local r_341 = type1(xs8)
	if (r_341 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_341), 2)
	else
	end
	local len2 = (_23_1(xs8) + 1)
	xs8["n"] = len2
	xs8[len2] = val2
	return xs8
end)
reverse1 = (function(xs9, acc2)
	if _21_1(exists_3f_1(acc2)) then
		return reverse1(xs9, {tag = "list", n =0})
	elseif nil_3f_1(xs9) then
		return acc2
	else
		return reverse1(cdr2(xs9), cons1(car2(xs9), acc2))
	end
end)
cadr1 = (function(x12)
	return car2(cdr2(x12))
end)
charAt1 = (function(xs10, x13)
	return sub1(xs10, x13, x13)
end)
_2e2e_1 = (function(...)
	local args1 = _pack(...) args1.tag = "list"
	return concat1(args1)
end)
_23_s1 = len1
split1 = (function(text1, pattern1, limit1)
	local out1 = {tag = "list", n =0}
	local loop1 = true
	local start1 = 1
	local r_451 = nil
	r_451 = (function()
		if loop1 then
			local pos1 = list1(find1(text1, pattern1, start1))
			local temp1
			local r_461 = ("nil" == type_23_1(pos1))
			if r_461 then
				temp1 = r_461
			else
				local r_471 = (nth1(pos1, 1) == nil)
				if r_471 then
					temp1 = r_471
				else
					local r_481 = limit1
					if r_481 then
						temp1 = (_23_1(out1) >= limit1)
					else
						temp1 = r_481
					end
				end
			end
			if temp1 then
				loop1 = false
				pushCdr_21_1(out1, sub1(text1, start1, _23_s1(text1)))
				start1 = (_23_s1(text1) + 1)
			else
				if car1(pos1) then
					pushCdr_21_1(out1, sub1(text1, start1, (car1(pos1) - 1)))
					start1 = (cadr1(pos1) + 1)
				else
					loop1 = false
				end
			end
			return r_451()
		else
		end
	end)
	r_451()
	return out1
end)
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
	local out2 = emptyStruct1()
	local r_591 = _23_1(keys1)
	local r_601 = 2
	local r_571 = nil
	r_571 = (function(r_581)
		if (r_581 <= r_591) then
			local i1 = r_581
			local key2 = keys1[i1]
			local val3 = keys1[(1 + i1)]
			out2[(function()
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
	return out2
end)
succ1 = (function(x14)
	return (x14 + 1)
end)
pred1 = (function(x15)
	return (x15 - 1)
end)
number_2d3e_string1 = tostring1
error_21_1 = error1
print_21_1 = print1
fail_21_1 = (function(x16)
	return error_21_1(x16, 0)
end)
create1 = (function()
	return struct1("out", list1(), "indent", 0, "tabs-pending", false)
end)
append_21_1 = (function(writer1, text2)
	local r_891 = type1(text2)
	if (r_891 ~= "string") then
		error1(format1("bad argment %s (expected %s, got %s)", "text", "string", r_891), 2)
	else
	end
	if writer1["tabs-pending"] then
		writer1["tabs-pending"] = false
		pushCdr_21_1(writer1["out"], rep1("\9", writer1["indent"]))
	else
	end
	return pushCdr_21_1(writer1["out"], text2)
end)
line_21_1 = (function(writer2, text3, force1)
	if text3 then
		append_21_1(writer2, text3)
	else
	end
	local temp2
	local r_901 = force1
	if r_901 then
		temp2 = r_901
	else
		temp2 = _21_1(writer2["tabs-pending"])
	end
	if temp2 then
		writer2["tabs-pending"] = true
		return pushCdr_21_1(writer2["out"], "\n")
	else
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
	local out3 = emptyStruct1()
	local r_921 = lst1
	local r_951 = _23_1(r_921)
	local r_961 = 1
	local r_931 = nil
	r_931 = (function(r_941)
		if (r_941 <= r_951) then
			local r_911 = r_941
			local entry1 = r_921[r_911]
			out3[entry1] = true
			return r_931((r_941 + 1))
		else
		end
	end)
	r_931(1)
	return out3
end)
keywords1 = createLookup1("and", "break", "do", "else", "elseif", "end", "false", "for", "function", "if", "in", "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while")
createState1 = (function(meta1)
	return struct1("ctr-lookup", emptyStruct1(), "var-lookup", emptyStruct1(), "meta", (function(r_971)
		if r_971 then
			return r_971
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
		local out4
		if find1(charAt1(name1, 1), "%d") then
			out4 = "_e"
		else
			out4 = ""
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
				local temp3
				local r_1081 = (char1 == "-")
				if r_1081 then
					local r_1091 = find1(charAt1(name1, pred1(i2)), "[%a%d']")
					if r_1091 then
						temp3 = find1(charAt1(name1, succ1(i2)), "[%a%d']")
					else
						temp3 = r_1091
					end
				else
					temp3 = r_1081
				end
				if temp3 then
					upper2 = true
				elseif find1(char1, "[^%w%d]") then
					char1 = format1("%02x", byte1(char1))
					if esc1 then
					else
						esc1 = true
						out4 = _2e2e_1(out4, "_")
					end
					out4 = _2e2e_1(out4, char1)
				else
					if esc1 then
						esc1 = false
						out4 = _2e2e_1(out4, "_")
					else
					end
					if upper2 then
						upper2 = false
						char1 = upper1(char1)
					else
					end
					out4 = _2e2e_1(out4, char1)
				end
				return r_1041((r_1051 + 1))
			else
			end
		end)
		r_1041(1)
		if esc1 then
			out4 = _2e2e_1(out4, "_")
		else
		end
		return out4
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
			id1 = succ1((function(r_1101)
				if r_1101 then
					return r_1101
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
compileQuote1 = (function(node3, out5, state2, level1)
	if (level1 == 0) then
		return compileExpression1(node3, out5, state2)
	else
		local ty2 = type1(node3)
		if (ty2 == "string") then
			return append_21_1(out5, quoted1(node3["value"]))
		elseif (ty2 == "number") then
			return append_21_1(out5, number_2d3e_string1(node3["value"]))
		elseif (ty2 == "symbol") then
			append_21_1(out5, _2e2e_1("{ tag=\"symbol\", contents=", quoted1(node3["contents"])))
			if node3["var"] then
				append_21_1(out5, _2e2e_1(", var=", quoted1(number_2d3e_string1(node3["var"]))))
			else
			end
			return append_21_1(out5, "}")
		elseif (ty2 == "key") then
			return append_21_1(out5, _2e2e_1("{tag=\"key\", value=", quoted1(node3["value"]), "}"))
		elseif (ty2 == "list") then
			local first2 = car2(node3)
			local temp4
			local r_1111 = symbol_3f_1(first2)
			if r_1111 then
				local r_1121 = (first2["var"] == builtins1["unquote"])
				if r_1121 then
					temp4 = r_1121
				else
					temp4 = ("var" == builtins1["unquote-splice"])
				end
			else
				temp4 = r_1111
			end
			if temp4 then
				return compileQuote1(nth1(node3, 2), out5, state2, (function(r_1131)
					if r_1131 then
						return pred1(level1)
					else
						return r_1131
					end
				end)(level1))
			else
				local temp5
				local r_1141 = symbol_3f_1(first2)
				if r_1141 then
					temp5 = (first2["var"] == builtins1["quasiquote"])
				else
					temp5 = r_1141
				end
				if temp5 then
					return compileQuote1(nth1(node3, 2), out5, state2, (function(r_1151)
						if r_1151 then
							return succ1(level1)
						else
							return r_1151
						end
					end)(level1))
				else
					local containsUnsplice1 = false
					local r_1171 = node3
					local r_1201 = _23_1(r_1171)
					local r_1211 = 1
					local r_1181 = nil
					r_1181 = (function(r_1191)
						if (r_1191 <= r_1201) then
							local r_1161 = r_1191
							local sub2 = r_1171[r_1161]
							local temp6
							local r_1221 = list_3f_1(sub2)
							if r_1221 then
								local r_1231 = symbol_3f_1(car2(sub2))
								if r_1231 then
									temp6 = (sub2[1]["var"] == builtins1["unquote-splice"])
								else
									temp6 = r_1231
								end
							else
								temp6 = r_1221
							end
							if temp6 then
								containsUnsplice1 = true
							else
							end
							return r_1181((r_1191 + 1))
						else
						end
					end)
					r_1181(1)
					if containsUnsplice1 then
						local offset1 = 0
						beginBlock_21_1(out5, "(function()")
						line_21_1(out5, "local _offset, _result, _temp = 0, {tag=\"list\",n=0}")
						local r_1261 = _23_1(node3)
						local r_1271 = 1
						local r_1241 = nil
						r_1241 = (function(r_1251)
							if (r_1251 <= r_1261) then
								local i3 = r_1251
								local sub3 = nth1(node3, i3)
								local temp7
								local r_1281 = list_3f_1(sub3)
								if r_1281 then
									local r_1291 = symbol_3f_1(car2(sub3))
									if r_1291 then
										temp7 = (sub3[1]["var"] == builtins1["unquote-splice"])
									else
										temp7 = r_1291
									end
								else
									temp7 = r_1281
								end
								if temp7 then
									offset1 = (offset1 + 1)
									append_21_1(out5, "_temp = ")
									compileQuote1(nth1(sub3, 2), out5, state2, pred1(level1))
									line_21_1(out5)
									line_21_1(out5, _2e2e_1("for _c = 1, _temp.n do _result[", number_2d3e_string1((i3 - offset1)), " + _c + _offset] = _temp[_c] end"))
									line_21_1(out5, "_offset = _offset + _temp.n")
								else
									append_21_1(out5, _2e2e_1("_result[", number_2d3e_string1((i3 - offset1)), " + _offset] = "))
									compileQuote1(sub3, out5, state2, level1)
									line_21_1(out5)
								end
								return r_1241((r_1251 + 1))
							else
							end
						end)
						r_1241(1)
						line_21_1(out5, _2e2e_1("_result.n = _offset + ", number_2d3e_string1((_23_1(node3) - offset1))))
						line_21_1(out5, "return _result")
						return endBlock_21_1(out5, "end)()")
					else
						append_21_1(out5, _2e2e_1("{tag = \"list\", n =", number_2d3e_string1(_23_1(node3))))
						local r_1331 = node3
						local r_1361 = _23_1(r_1331)
						local r_1371 = 1
						local r_1341 = nil
						r_1341 = (function(r_1351)
							if (r_1351 <= r_1361) then
								local r_1321 = r_1351
								local sub4 = r_1331[r_1321]
								append_21_1(out5, ", ")
								compileQuote1(sub4, out5, state2, level1)
								return r_1341((r_1351 + 1))
							else
							end
						end)
						r_1341(1)
						return append_21_1(out5, "}")
					end
				end
			end
		else
			return error_21_1(_2e2e_1("Unknown type ", ty2))
		end
	end
end)
compileExpression1 = (function(node4, out6, state3, ret1)
	if list_3f_1(node4) then
		local head2 = car2(node4)
		if symbol_3f_1(head2) then
			local var2 = head2["var"]
			if (var2 == builtins1["lambda"]) then
				if (ret1 == "") then
				else
					if ret1 then
						append_21_1(out6, ret1)
					else
					end
					local args2 = nth1(node4, 2)
					local variadic1 = nil
					local i4 = 1
					append_21_1(out6, "(function(")
					local r_1301 = nil
					r_1301 = (function()
						local temp8
						local r_1311 = (i4 <= _23_1(args2))
						if r_1311 then
							temp8 = _21_1(variadic1)
						else
							temp8 = r_1311
						end
						if temp8 then
							if (i4 > 1) then
								append_21_1(out6, ", ")
							else
							end
							local var3 = args2[i4]["var"]
							if var3["isVariadic"] then
								append_21_1(out6, "...")
								variadic1 = i4
							else
								append_21_1(out6, escapeVar1(var3, state3))
							end
							i4 = (i4 + 1)
							return r_1301()
						else
						end
					end)
					r_1301()
					beginBlock_21_1(out6, ")")
					if variadic1 then
						local argsVar1 = escapeVar1(args2[variadic1]["var"], state3)
						if (variadic1 == _23_1(args2)) then
							line_21_1(out6, _2e2e_1("local ", argsVar1, " = _pack(...) ", argsVar1, ".tag = \"list\""))
						else
							local remaining1 = (_23_1(args2) - variadic1)
							line_21_1(out6, _2e2e_1("local _n = _select(\"#\", ...) - ", number_2d3e_string1(remaining1)))
							append_21_1(out6, _2e2e_1("local ", argsVar1))
							local r_1401 = _23_1(args2)
							local r_1411 = 1
							local r_1381 = nil
							r_1381 = (function(r_1391)
								if (r_1391 <= r_1401) then
									local i5 = r_1391
									append_21_1(out6, ", ")
									append_21_1(out6, escapeVar1(args2[i5]["var"], state3))
									return r_1381((r_1391 + 1))
								else
								end
							end)
							r_1381(succ1(variadic1))
							line_21_1(out6)
							beginBlock_21_1(out6, "if _n > 0 then")
							append_21_1(out6, argsVar1)
							line_21_1(out6, " = { tag=\"list\", n=_n, _unpack(_pack(...), 1, _n)}")
							local r_1441 = _23_1(args2)
							local r_1451 = 1
							local r_1421 = nil
							r_1421 = (function(r_1431)
								if (r_1431 <= r_1441) then
									local i6 = r_1431
									append_21_1(out6, escapeVar1(args2[i6]["var"], state3))
									if (i6 < _23_1(args2)) then
										append_21_1(out6, ", ")
									else
									end
									return r_1421((r_1431 + 1))
								else
								end
							end)
							r_1421(succ1(variadic1))
							line_21_1(out6, " = select(_n + 1, ...)")
							nextBlock_21_1(out6, "else")
							append_21_1(out6, argsVar1)
							line_21_1(out6, " = { tag=\"list\", n=0}")
							local r_1481 = _23_1(args2)
							local r_1491 = 1
							local r_1461 = nil
							r_1461 = (function(r_1471)
								if (r_1471 <= r_1481) then
									local i7 = r_1471
									append_21_1(out6, escapeVar1(args2[i7]["var"], state3))
									if (i7 < _23_1(args2)) then
										append_21_1(out6, ", ")
									else
									end
									return r_1461((r_1471 + 1))
								else
								end
							end)
							r_1461(succ1(variadic1))
							line_21_1(out6, " = ...")
							endBlock_21_1(out6, "end")
						end
					else
					end
					compileBlock1(node4, out6, state3, 3, "return ")
					unindent_21_1(out6)
					return append_21_1(out6, "end)")
				end
			elseif (var2 == builtins1["cond"]) then
				local closure1 = _21_1(ret1)
				local hadFinal1 = false
				local ends1 = 1
				if closure1 then
					beginBlock_21_1(out6, "(function()")
					ret1 = "return "
				else
				end
				local i8 = 2
				local r_1501 = nil
				r_1501 = (function()
					local temp9
					local r_1511 = _21_1(hadFinal1)
					if r_1511 then
						temp9 = (i8 <= _23_1(node4))
					else
						temp9 = r_1511
					end
					if temp9 then
						local item1 = nth1(node4, i8)
						local case1 = nth1(item1, 1)
						local isFinal1 = truthy_3f_1(case1)
						if isFinal1 then
							if (i8 == 2) then
								append_21_1(out6, "do")
							else
							end
						elseif statement_3f_1(case1) then
							if (i8 > 2) then
								indent_21_1(out6)
								line_21_1(out6)
								ends1 = (ends1 + 1)
							else
							end
							local tmp1 = escapeVar1(struct1("name", "temp"), state3)
							line_21_1(out6, _2e2e_1("local ", tmp1))
							compileExpression1(case1, out6, state3, _2e2e_1(tmp1, " = "))
							line_21_1(out6)
							line_21_1(out6, _2e2e_1("if ", tmp1, " then"))
						else
							append_21_1(out6, "if ")
							compileExpression1(case1, out6, state3)
							append_21_1(out6, " then")
						end
						indent_21_1(out6)
						line_21_1(out6)
						compileBlock1(item1, out6, state3, 2, ret1)
						unindent_21_1(out6)
						if isFinal1 then
							hadFinal1 = true
						else
							append_21_1(out6, "else")
						end
						i8 = (i8 + 1)
						return r_1501()
					else
					end
				end)
				r_1501()
				if hadFinal1 then
				else
					indent_21_1(out6)
					line_21_1(out6)
					append_21_1(out6, "_error(\"unmatched item\")")
					unindent_21_1(out6)
					line_21_1(out6)
				end
				local r_1541 = ends1
				local r_1551 = 1
				local r_1521 = nil
				r_1521 = (function(r_1531)
					if (r_1531 <= r_1541) then
						local i9 = r_1531
						append_21_1(out6, "end")
						if (i9 < ends1) then
							unindent_21_1(out6)
							line_21_1(out6)
						else
						end
						return r_1521((r_1531 + 1))
					else
					end
				end)
				r_1521(1)
				if closure1 then
					line_21_1(out6)
					return endBlock_21_1(out6, "end)()")
				else
				end
			elseif (var2 == builtins1["set!"]) then
				compileExpression1(nth1(node4, 3), out6, state3, _2e2e_1(escapeVar1(node4[2]["var"], state3), " = "))
				local temp10
				local r_1561 = ret1
				if r_1561 then
					temp10 = (ret1 ~= "")
				else
					temp10 = r_1561
				end
				if temp10 then
					line_21_1(out6)
					append_21_1(out6, ret1)
					return append_21_1(out6, "nil")
				else
				end
			elseif (var2 == builtins1["define"]) then
				return compileExpression1(nth1(node4, _23_1(node4)), out6, state3, _2e2e_1(escapeVar1(node4["defVar"], state3), " = "))
			elseif (var2 == builtins1["define-macro"]) then
				return compileExpression1(nth1(node4, _23_1(node4)), out6, state3, _2e2e_1(escapeVar1(node4["defVar"], state3), " = "))
			elseif (var2 == builtins1["define-native"]) then
				return append_21_1(out6, format1("%s = _libs[%q]", escapeVar1(node4["defVar"], state3), node4["defVar"]["fullName"]))
			elseif (var2 == builtins1["quote"]) then
				if (ret1 == "") then
				else
					if ret1 then
						append_21_1(out6, ret1)
					else
					end
					return compileQuote1(nth1(node4, 2), out6, state3)
				end
			elseif (var2 == builtins1["quasiquote"]) then
				if (ret1 == "") then
					append_21_1(out6, "local _ =")
				elseif ret1 then
					append_21_1(out6, ret1)
				else
				end
				return compileQuote1(nth1(node4, 2), out6, state3, 1)
			elseif (var2 == builtins1["unquote"]) then
				return fail_21_1("unquote outside of quasiquote")
			elseif (var2 == builtins1["unquote-splice"]) then
				return fail_21_1("unquote-splice outside of quasiquote")
			elseif (var2 == builtins1["import"]) then
				if (ret1 == nil) then
					return append_21_1(out6, "nil")
				elseif (ret1 ~= "") then
					append_21_1(out6, ret1)
					return append_21_1(out6, "nil")
				else
				end
			else
				local meta2
				local r_1701 = symbol_3f_1(head2)
				if r_1701 then
					local r_1711 = (head2["var"]["tag"] == "native")
					if r_1711 then
						meta2 = state3["meta"][head2["var"]["fullName"]]
					else
						meta2 = r_1711
					end
				else
					meta2 = r_1701
				end
				local temp11
				local r_1571 = meta2
				if r_1571 then
					local r_1581
					local r_1591 = ret1
					if r_1591 then
						r_1581 = r_1591
					else
						r_1581 = (meta2["tag"] == "expr")
					end
					if r_1581 then
						temp11 = (pred1(_23_1(node4)) == meta2["count"])
					else
						temp11 = r_1581
					end
				else
					temp11 = r_1571
				end
				if temp11 then
					local temp12
					local r_1601 = ret1
					if r_1601 then
						temp12 = (meta2["tag"] == "expr")
					else
						temp12 = r_1601
					end
					if temp12 then
						append_21_1(out6, ret1)
					else
					end
					local contents2 = meta2["contents"]
					local r_1631 = _23_1(contents2)
					local r_1641 = 1
					local r_1611 = nil
					r_1611 = (function(r_1621)
						if (r_1621 <= r_1631) then
							local i10 = r_1621
							local entry2 = nth1(contents2, i10)
							if number_3f_1(entry2) then
								compileExpression1(nth1(node4, succ1(entry2)), out6, state3)
							else
								append_21_1(out6, entry2)
							end
							return r_1611((r_1621 + 1))
						else
						end
					end)
					r_1611(1)
					local temp13
					local r_1651 = (meta2["tag"] ~= "expr")
					if r_1651 then
						temp13 = (ret1 ~= "")
					else
						temp13 = r_1651
					end
					if temp13 then
						line_21_1(out6)
						append_21_1(out6, ret1)
						append_21_1(out6, "nil")
						return line_21_1(out6)
					else
					end
				else
					if ret1 then
						append_21_1(out6, ret1)
					else
					end
					compileExpression1(head2, out6, state3)
					append_21_1(out6, "(")
					local r_1681 = _23_1(node4)
					local r_1691 = 1
					local r_1661 = nil
					r_1661 = (function(r_1671)
						if (r_1671 <= r_1681) then
							local i11 = r_1671
							if (i11 > 2) then
								append_21_1(out6, ", ")
							else
							end
							compileExpression1(nth1(node4, i11), out6, state3)
							return r_1661((r_1671 + 1))
						else
						end
					end)
					r_1661(2)
					return append_21_1(out6, ")")
				end
			end
		else
			local temp14
			local r_1721 = ret1
			if r_1721 then
				local r_1731 = list_3f_1(head2)
				if r_1731 then
					local r_1741 = symbol_3f_1(car2(head2))
					if r_1741 then
						temp14 = (head2[1]["var"] == builtins1["lambda"])
					else
						temp14 = r_1741
					end
				else
					temp14 = r_1731
				end
			else
				temp14 = r_1721
			end
			if temp14 then
				local args3 = nth1(head2, 2)
				local offset2 = 1
				local r_1771 = _23_1(args3)
				local r_1781 = 1
				local r_1751 = nil
				r_1751 = (function(r_1761)
					if (r_1761 <= r_1771) then
						local i12 = r_1761
						local var4 = args3[i12]["var"]
						append_21_1(out6, _2e2e_1("local ", escapeVar1(var4, state3)))
						if var4["isVariadic"] then
							local count1 = (_23_1(node4) - _23_1(args3))
							if (count1 < 0) then
								count1 = 0
							else
							end
							append_21_1(out6, " = { tag=\"list\", n=")
							append_21_1(out6, number_2d3e_string1(count1))
							local r_1811 = count1
							local r_1821 = 1
							local r_1791 = nil
							r_1791 = (function(r_1801)
								if (r_1801 <= r_1811) then
									local j1 = r_1801
									append_21_1(out6, ", ")
									compileExpression1(nth1(node4, (i12 + j1)), out6, state3)
									return r_1791((r_1801 + 1))
								else
								end
							end)
							r_1791(1)
							offset2 = count1
							line_21_1(out6, "}")
						else
							local expr2 = nth1(node4, (i12 + offset2))
							local name2 = escapeVar1(var4, state3)
							local ret2 = nil
							if expr2 then
								if statement_3f_1(expr2) then
									ret2 = _2e2e_1(name2, " = ")
									line_21_1(out6)
								else
									append_21_1(out6, " = ")
								end
								compileExpression1(expr2, out6, state3, ret2)
								line_21_1(out6)
							else
								line_21_1(out6)
							end
						end
						return r_1751((r_1761 + 1))
					else
					end
				end)
				r_1751(1)
				local r_1851 = _23_1(node4)
				local r_1861 = 1
				local r_1831 = nil
				r_1831 = (function(r_1841)
					if (r_1841 <= r_1851) then
						local i13 = r_1841
						compileExpression1(nth1(node4, i13), out6, state3, "")
						line_21_1(out6)
						return r_1831((r_1841 + 1))
					else
					end
				end)
				r_1831((_23_1(args3) + (offset2 + 1)))
				return compileBlock1(head2, out6, state3, 3, ret1)
			else
				if ret1 then
					append_21_1(out6, ret1)
				else
				end
				compileExpression1(car2(node4), out6, state3)
				append_21_1(out6, "(")
				local r_1891 = _23_1(node4)
				local r_1901 = 1
				local r_1871 = nil
				r_1871 = (function(r_1881)
					if (r_1881 <= r_1891) then
						local i14 = r_1881
						if (i14 > 2) then
							append_21_1(out6, ", ")
						else
						end
						compileExpression1(nth1(node4, i14), out6, state3)
						return r_1871((r_1881 + 1))
					else
					end
				end)
				r_1871(2)
				return append_21_1(out6, ")")
			end
		end
	else
		if (ret1 == "") then
		else
			if ret1 then
				append_21_1(out6, ret1)
			else
			end
			if symbol_3f_1(node4) then
				return append_21_1(out6, escapeVar1(node4["var"], state3))
			elseif string_3f_1(node4) then
				return append_21_1(out6, quoted1(node4["value"]))
			elseif number_3f_1(node4) then
				return append_21_1(out6, number_2d3e_string1(node4["value"]))
			elseif key_3f_1(node4) then
				return append_21_1(out6, quoted1(node4["value"]))
			else
				return error_21_1(_2e2e_1("Unknown type: ", type1(node4)))
			end
		end
	end
end)
compileBlock1 = (function(nodes1, out7, state4, start2, ret3)
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
			compileExpression1(nth1(nodes1, i15), out7, state4, ret_27_1)
			line_21_1(out7)
			return r_1001((r_1011 + 1))
		else
		end
	end)
	return r_1001(start2)
end)
prelude1 = (function(out8)
	line_21_1(out8, "if not table.pack then table.pack = function(...) return { n = select(\"#\", ...), ... } end end")
	line_21_1(out8, "if not table.unpack then table.unpack = unpack end")
	line_21_1(out8, "local load = load if _VERSION:find(\"5.1\") then load = function(x, _, _, env) local f, e = loadstring(x); if not f then error(e, 1) end; return setfenv(f, env) end end")
	return line_21_1(out8, "local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error")
end)
backend1 = struct1("createState", createState1, "escape", escape1, "escapeVar", escapeVar1, "block", compileBlock1, "expression", compileExpression1, "prelude", prelude1)
estimateLength1 = (function(node5, max1)
	local tag2 = node5["tag"]
	local temp15
	local r_1911 = (tag2 == "string")
	if r_1911 then
		temp15 = r_1911
	else
		local r_1921 = (tag2 == "number")
		if r_1921 then
			temp15 = r_1921
		else
			local r_1931 = (tag2 == "symbol")
			if r_1931 then
				temp15 = r_1931
			else
				temp15 = (tag2 == "key")
			end
		end
	end
	if temp15 then
		return _23_s1(number_2d3e_string1(node5["contents"]))
	elseif (tag2 == "list") then
		local sum1 = 2
		local i16 = 1
		local r_2031 = nil
		r_2031 = (function()
			local temp16
			local r_2041 = (sum1 <= max1)
			if r_2041 then
				temp16 = (i16 <= _23_1(node5))
			else
				temp16 = r_2041
			end
			if temp16 then
				sum1 = (sum1 + estimateLength1(nth1(node5, i16), (max1 - sum1)))
				if (i16 > 1) then
					sum1 = (sum1 + 1)
				else
				end
				i16 = (i16 + 1)
				return r_2031()
			else
			end
		end)
		r_2031()
		return sum1
	else
		return fail_21_1(_2e2e_1("Unknown tag ", tag2))
	end
end)
expression1 = (function(node6, writer9)
	local tag3 = node6["tag"]
	local temp17
	local r_1941 = (tag3 == "string")
	if r_1941 then
		temp17 = r_1941
	else
		local r_1951 = (tag3 == "number")
		if r_1951 then
			temp17 = r_1951
		else
			local r_1961 = (tag3 == "symbol")
			if r_1961 then
				temp17 = r_1961
			else
				temp17 = (tag3 == "key")
			end
		end
	end
	if temp17 then
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
			local r_2071 = _23_1(node6)
			local r_2081 = 1
			local r_2051 = nil
			r_2051 = (function(r_2061)
				if (r_2061 <= r_2071) then
					local i17 = r_2061
					local entry3 = nth1(node6, i17)
					local temp18
					local r_2091 = _21_1(newline1)
					if r_2091 then
						temp18 = (max2 > 0)
					else
						temp18 = r_2091
					end
					if temp18 then
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
					return r_2051((r_2061 + 1))
				else
				end
			end)
			r_2051(2)
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
	local r_1981 = list2
	local r_2011 = _23_1(r_1981)
	local r_2021 = 1
	local r_1991 = nil
	r_1991 = (function(r_2001)
		if (r_2001 <= r_2011) then
			local r_1971 = r_2001
			local node7 = r_1981[r_1971]
			expression1(node7, writer10)
			line_21_1(writer10)
			return r_1991((r_2001 + 1))
		else
		end
	end)
	return r_1991(1)
end)
backend2 = struct1("expression", expression1, "block", block1)
abs1 = _libs["lib/lua/math/abs"]
max3 = _libs["lib/lua/math/max"]
builtins2 = require1("tacky.analysis.resolve")["builtins"]
tokens1 = {tag = "list", n =3, {tag = "list", n =2, "arg", "(%f[%a]%u+%f[%A])"}, {tag = "list", n =2, "mono", "`([^`]*)`"}, {tag = "list", n =2, "link", "%[%[(.-)%]%]"}}
extractSignature1 = (function(var5)
	local ty3 = type1(var5)
	local temp19
	local r_2101 = (ty3 == "macro")
	if r_2101 then
		temp19 = r_2101
	else
		temp19 = (ty3 == "defined")
	end
	if temp19 then
		local root1 = var5["node"]
		local node8 = nth1(root1, _23_1(root1))
		local temp20
		local r_2111 = list_3f_1(node8)
		if r_2111 then
			local r_2121 = symbol_3f_1(car2(node8))
			if r_2121 then
				temp20 = (car2(node8)["var"] == builtins2["lambda"])
			else
				temp20 = r_2121
			end
		else
			temp20 = r_2111
		end
		if temp20 then
			return nth1(node8, 2)
		else
			return nil
		end
	else
		return nil
	end
end)
parseDocstring1 = (function(str2)
	local out9 = {tag = "list", n =0}
	local pos2 = 1
	local len3 = _23_s1(str2)
	local r_2131 = nil
	r_2131 = (function()
		if (pos2 <= len3) then
			local spos1 = len3
			local epos1 = nil
			local name3 = nil
			local ptrn1 = nil
			local r_2151 = tokens1
			local r_2181 = _23_1(r_2151)
			local r_2191 = 1
			local r_2161 = nil
			r_2161 = (function(r_2171)
				if (r_2171 <= r_2181) then
					local r_2141 = r_2171
					local tok1 = r_2151[r_2141]
					local npos1 = list1(find1(str2, nth1(tok1, 2), pos2))
					local temp21
					local r_2201 = car2(npos1)
					if r_2201 then
						temp21 = (car2(npos1) < spos1)
					else
						temp21 = r_2201
					end
					if temp21 then
						spos1 = car2(npos1)
						epos1 = nth1(npos1, 2)
						name3 = car2(tok1)
						ptrn1 = nth1(tok1, 2)
					else
					end
					return r_2161((r_2171 + 1))
				else
				end
			end)
			r_2161(1)
			if name3 then
				if (pos2 < spos1) then
					pushCdr_21_1(out9, struct1("tag", "text", "contents", sub1(str2, pos2, pred1(spos1))))
				else
				end
				pushCdr_21_1(out9, struct1("tag", name3, "contents", match1(sub1(str2, spos1, epos1), ptrn1)))
				pos2 = succ1(epos1)
			else
				pushCdr_21_1(out9, struct1("tag", "text", "contents", sub1(str2, pos2, len3)))
				pos2 = succ1(len3)
			end
			return r_2131()
		else
		end
	end)
	r_2131()
	return out9
end)
struct1("parseDocs", parseDocstring1, "extractSignature", extractSignature1)
verbosity1 = struct1("value", 0)
setVerbosity_21_1 = (function(level2)
	verbosity1["value"] = level2
	return nil
end)
showExplain1 = struct1("value", false)
setExplain_21_1 = (function(value1)
	showExplain1["value"] = value1
	return nil
end)
colored1 = (function(col1, msg1)
	return _2e2e_1("\27[", col1, "m", msg1, "\27[0m")
end)
printError_21_1 = (function(msg2)
	local lines1 = split1(msg2, "\n", 1)
	print_21_1(colored1(31, _2e2e_1("[ERROR] ", car2(lines1))))
	if cadr1(lines1) then
		return print_21_1(cadr1(lines1))
	else
	end
end)
printWarning_21_1 = (function(msg3)
	local lines2 = split1(msg3, "\n", 1)
	print_21_1(colored1(33, _2e2e_1("[WARN] ", car2(lines2))))
	if cadr1(lines2) then
		return print_21_1(cadr1(lines2))
	else
	end
end)
printVerbose_21_1 = (function(msg4)
	if (verbosity1["value"] > 0) then
		return print_21_1(_2e2e_1("[VERBOSE] ", msg4))
	else
	end
end)
printDebug_21_1 = (function(msg5)
	if (verbosity1["value"] > 1) then
		return print_21_1(_2e2e_1("[DEBUG] ", msg5))
	else
	end
end)
formatPosition1 = (function(pos3)
	return _2e2e_1(pos3["line"], ":", pos3["column"])
end)
formatRange1 = (function(range1)
	if range1["finish"] then
		return format1("%s:[%s .. %s]", range1["name"], formatPosition1(range1["start"]), formatPosition1(range1["finish"]))
	else
		return format1("%s:[%s]", range1["name"], formatPosition1(range1["start"]))
	end
end)
formatNode1 = (function(node9)
	local temp22
	local r_2211 = node9["range"]
	if r_2211 then
		temp22 = node9["contents"]
	else
		temp22 = r_2211
	end
	if temp22 then
		return format1("%s (%q)", formatRange1(node9["range"]), node9["contents"])
	elseif node9["range"] then
		return formatRange1(node9["range"])
	elseif node9["macro"] then
		local macro1 = node9["macro"]
		return format1("macro expansion of %s (%s)", macro1["var"]["name"], formatNode1(macro1["node"]))
	else
		local temp23
		local r_2311 = node9["start"]
		if r_2311 then
			temp23 = node9["finish"]
		else
			temp23 = r_2311
		end
		if temp23 then
			return formatRange1(node9)
		else
			return "?"
		end
	end
end)
getSource1 = (function(node10)
	local result2 = nil
	local r_2221 = nil
	r_2221 = (function()
		local temp24
		local r_2231 = node10
		if r_2231 then
			temp24 = _21_1(result2)
		else
			temp24 = r_2231
		end
		if temp24 then
			result2 = node10["range"]
			node10 = node10["parent"]
			return r_2221()
		else
		end
	end)
	r_2221()
	return result2
end)
putLines_21_1 = (function(range2, ...)
	local entries1 = _pack(...) entries1.tag = "list"
	if nil_3f_1(entries1) then
		error_21_1("Positions cannot be empty")
	else
	end
	if ((_23_1(entries1) % 2) ~= 0) then
		error_21_1(_2e2e_1("Positions must be a multiple of 2, is ", _23_1(entries1)))
	else
	end
	local previous1 = -1
	local file1 = nth1(entries1, 1)["name"]
	local maxLine1 = foldr1((function(node11, max4)
		if string_3f_1(node11) then
			return max4
		else
			return max3(max4, node11["start"]["line"])
		end
	end), 0, entries1)
	local code1 = _2e2e_1("\27[92m %", _23_s1(number_2d3e_string1(maxLine1)), "s |\27[0m %s")
	local r_2341 = _23_1(entries1)
	local r_2351 = 2
	local r_2321 = nil
	r_2321 = (function(r_2331)
		if (r_2331 <= r_2341) then
			local i18 = r_2331
			local position1 = entries1[i18]
			local message1 = entries1[succ1(i18)]
			if (file1 ~= position1["name"]) then
				file1 = position1["name"]
				print_21_1(_2e2e_1("\27[95m ", file1, "\27[0m"))
			else
				local temp25
				local r_2361 = (previous1 ~= -1)
				if r_2361 then
					temp25 = (abs1((position1["start"]["line"] - previous1)) > 2)
				else
					temp25 = r_2361
				end
				if temp25 then
					print_21_1(" \27[92m...\27[0m")
				else
				end
			end
			previous1 = position1["start"]["line"]
			print_21_1(format1(code1, number_2d3e_string1(position1["start"]["line"]), position1["lines"][position1["start"]["line"]]))
			local pointer1
			if _21_1(range2) then
				pointer1 = "^"
			else
				local temp26
				local r_2371 = position1["finish"]
				if r_2371 then
					temp26 = (position1["start"]["line"] == position1["finish"]["line"])
				else
					temp26 = r_2371
				end
				if temp26 then
					pointer1 = rep1("^", succ1((position1["finish"]["column"] - position1["start"]["column"])))
				else
					pointer1 = "^..."
				end
			end
			print_21_1(format1(code1, "", _2e2e_1(rep1(" ", (position1["start"]["column"] - 1)), pointer1, " ", message1)))
			return r_2321((r_2331 + 2))
		else
		end
	end)
	return r_2321(1)
end)
putTrace_21_1 = (function(node12)
	local previous2 = nil
	local r_2241 = nil
	r_2241 = (function()
		if node12 then
			local formatted1 = formatNode1(node12)
			if (previous2 == nil) then
				print_21_1(colored1(96, _2e2e_1("  => ", formatted1)))
			elseif (previous2 ~= formatted1) then
				print_21_1(_2e2e_1("  in ", formatted1))
			else
			end
			previous2 = formatted1
			node12 = node12["parent"]
			return r_2241()
		else
		end
	end)
	return r_2241()
end)
putExplain_21_1 = (function(...)
	local lines3 = _pack(...) lines3.tag = "list"
	if showExplain1["value"] then
		local r_2261 = lines3
		local r_2291 = _23_1(r_2261)
		local r_2301 = 1
		local r_2271 = nil
		r_2271 = (function(r_2281)
			if (r_2281 <= r_2291) then
				local r_2251 = r_2281
				local line1 = r_2261[r_2251]
				print_21_1(_2e2e_1("  ", line1))
				return r_2271((r_2281 + 1))
			else
			end
		end)
		return r_2271(1)
	else
	end
end)
errorPositions_21_1 = (function(node13, msg6)
	printError_21_1(msg6)
	putTrace_21_1(node13)
	local source1 = getSource1(node13)
	if source1 then
		putLines_21_1(true, source1, "")
	else
	end
	return fail_21_1("An error occured")
end)
struct1("colored", colored1, "formatPosition", formatPosition1, "formatRange", formatRange1, "formatNode", formatNode1, "putLines", putLines_21_1, "putTrace", putTrace_21_1, "putInfo", putExplain_21_1, "getSource", getSource1, "printWarning", printWarning_21_1, "printError", printError_21_1, "printVerbose", printVerbose_21_1, "printDebug", printDebug_21_1, "errorPositions", errorPositions_21_1, "setVerbosity", setVerbosity_21_1, "setExplain", setExplain_21_1)
formatRange2 = (function(range3)
	return format1("%s:%s", range3["name"], formatPosition1(range3["start"]))
end)
sortVars_21_1 = (function(list3)
	return sort1(list3, (function(a1, b1)
		return (car2(a1) < car2(b1))
	end))
end)
formatDefinition1 = (function(var6)
	local ty4 = type1(var6)
	if (ty4 == "builtin") then
		return "Builtin term"
	elseif (ty4 == "macro") then
		return _2e2e_1("Macro defined at ", formatRange2(getSource1(var6["node"])))
	elseif (ty4 == "native") then
		return _2e2e_1("Native defined at ", formatRange2(getSource1(var6["node"])))
	elseif (ty4 == "defined") then
		return _2e2e_1("Defined at ", formatRange2(getSource1(var6["node"])))
	else
		_error("unmatched item")
	end
end)
formatSignature1 = (function(name4, var7)
	local sig1 = extractSignature1(var7)
	if (sig1 == nil) then
		return name4
	elseif nil_3f_1(sig1) then
		return _2e2e_1("(", name4, _2e2e_1, ")")
	else
		return _2e2e_1("(", name4, " ", concat1(traverse1(sig1, (function(r_2381)
			return r_2381["contents"]
		end)), " "), ")")
	end
end)
exported1 = (function(out10, title1, vars1)
	local documented1 = {tag = "list", n =0}
	local undocumented1 = {tag = "list", n =0}
	iterPairs1(vars1, (function(name5, var8)
		return pushCdr_21_1((function()
			if var8["doc"] then
				return documented1
			else
				return undocumented1
			end
		end)()
		, list1(name5, var8))
	end))
	sortVars_21_1(documented1)
	sortVars_21_1(undocumented1)
	line_21_1(out10, "---")
	line_21_1(out10, _2e2e_1("title: ", title1))
	line_21_1(out10, "---")
	line_21_1(out10, _2e2e_1("# ", title1))
	local r_2401 = documented1
	local r_2431 = _23_1(r_2401)
	local r_2441 = 1
	local r_2411 = nil
	r_2411 = (function(r_2421)
		if (r_2421 <= r_2431) then
			local r_2391 = r_2421
			local entry4 = r_2401[r_2391]
			local name6 = car2(entry4)
			local var9 = nth1(entry4, 2)
			line_21_1(out10, _2e2e_1("## `", formatSignature1(name6, var9), "`"))
			line_21_1(out10, _2e2e_1("*", formatDefinition1(var9), "*"))
			line_21_1(out10, "", true)
			local r_2461 = parseDocstring1(var9["doc"])
			local r_2491 = _23_1(r_2461)
			local r_2501 = 1
			local r_2471 = nil
			r_2471 = (function(r_2481)
				if (r_2481 <= r_2491) then
					local r_2451 = r_2481
					local tok2 = r_2461[r_2451]
					local ty5 = type1(tok2)
					if (ty5 == "text") then
						append_21_1(out10, tok2["contents"])
					elseif (ty5 == "arg") then
						append_21_1(out10, _2e2e_1("`", tok2["contents"], "`"))
					elseif (ty5 == "mono") then
						append_21_1(out10, _2e2e_1("`", tok2["contents"], "`"))
					elseif (ty5 == "link") then
						local name7 = tok2["contents"]
						local scope1 = var9["scope"]
						local ovar1 = scope1["get"](scope1, name7, nil, true)
						if ovar1 then
							local loc1 = gsub1(gsub1(getSource1(ovar1["node"])["name"], "%.lisp$", ""), "/", ".")
							local sig2 = extractSignature1(ovar1)
							local hash1
							if (sig2 == nil) then
								hash1 = ovar1["name"]
							elseif nil_3f_1(sig2) then
								hash1 = ovar1["name"]
							else
								hash1 = _2e2e_1(name7, " ", concat1(traverse1(sig2, (function(r_2511)
									return r_2511["contents"]
								end)), " "))
							end
							append_21_1(out10, format1("[`%s`](%s.md#%s)", name7, loc1, gsub1(hash1, "%A+", "-")))
						else
							append_21_1(out10, format1("`%s`", name7))
						end
					else
						_error("unmatched item")
					end
					return r_2471((r_2481 + 1))
				else
				end
			end)
			r_2471(1)
			line_21_1(out10)
			line_21_1(out10, "", true)
			return r_2411((r_2421 + 1))
		else
		end
	end)
	r_2411(1)
	if nil_3f_1(undocumented1) then
	else
		line_21_1(out10, "## Undocumented symbols")
	end
	local r_2531 = undocumented1
	local r_2561 = _23_1(r_2531)
	local r_2571 = 1
	local r_2541 = nil
	r_2541 = (function(r_2551)
		if (r_2551 <= r_2561) then
			local r_2521 = r_2551
			local entry5 = r_2531[r_2521]
			local name8 = car2(entry5)
			local var10 = nth1(entry5, 2)
			line_21_1(out10, _2e2e_1(" - `", formatSignature1(name8, var10), "` *", formatDefinition1(var10), "*"))
			return r_2541((r_2551 + 1))
		else
		end
	end)
	return r_2541(1)
end)
backend3 = struct1("exported", exported1)
wrapGenerate1 = (function(func2)
	return (function(node14, ...)
		local args4 = _pack(...) args4.tag = "list"
		local writer11 = create1()
		func2(node14, writer11, unpack1(args4))
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
return struct1("lua", struct1("expression", wrapGenerate1(compileExpression1), "block", wrapGenerate1(compileBlock1), "prelude", wrapNormal1(prelude1), "backend", backend1), "lisp", struct1("expression", wrapGenerate1(expression1), "block", wrapGenerate1(block1), "backend", backend2), "markdown", struct1("exported", wrapNormal1(exported1), "backend", backend3))
