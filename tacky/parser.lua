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
local _3d_1, _2f3d_1, _3c_1, _3c3d_1, _3e_1, _3e3d_1, _2b_1, _2d_1, _25_1, slice1, error1, getmetatable1, print1, getIdx1, setIdx_21_1, tonumber1, tostring1, type_23_1, _23_1, concat1, emptyStruct1, car1, cdr1, list1, _21_1, char1, find1, format1, gsub1, len1, rep1, sub1, table_3f_1, list_3f_1, nil_3f_1, string_3f_1, function_3f_1, key_3f_1, between_3f_1, type1, car2, cdr2, foldr1, last1, nth1, pushCdr_21_1, popLast_21_1, cadr1, charAt1, _2e2e_1, _23_s1, split1, quoted1, struct1, invokable_3f_1, compose1, succ1, pred1, string_2d3e_number1, number_2d3e_string1, error_21_1, print_21_1, fail_21_1, abs1, max2, verbosity1, setVerbosity_21_1, showExplain1, setExplain_21_1, colored1, printError_21_1, printWarning_21_1, printVerbose_21_1, printDebug_21_1, formatPosition1, formatRange1, formatNode1, getSource1, putLines_21_1, putTrace_21_1, putExplain_21_1, errorPositions_21_1, hexDigit_3f_1, binDigit_3f_1, terminator_3f_1, digitError_21_1, lex1, parse1, read1
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
getmetatable1 = _libs["lib/lua/basic/getmetatable"]
print1 = _libs["lib/lua/basic/print"]
getIdx1 = _libs["lib/lua/basic/get-idx"]
setIdx_21_1 = _libs["lib/lua/basic/set-idx!"]
tonumber1 = _libs["lib/lua/basic/tonumber"]
tostring1 = _libs["lib/lua/basic/tostring"]
type_23_1 = _libs["lib/lua/basic/type#"]
_23_1 = (function(x1)
	return x1["n"]
end)
concat1 = _libs["lib/lua/table/concat"]
emptyStruct1 = _libs["lib/lua/table/empty-struct"]
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
_21_1 = (function(expr1)
	if expr1 then
		return false
	else
		return true
	end
end)
char1 = _libs["lib/lua/string/char"]
find1 = _libs["lib/lua/string/find"]
format1 = _libs["lib/lua/string/format"]
gsub1 = _libs["lib/lua/string/gsub"]
len1 = _libs["lib/lua/string/len"]
rep1 = _libs["lib/lua/string/rep"]
sub1 = _libs["lib/lua/string/sub"]
table_3f_1 = (function(x2)
	return (type_23_1(x2) == "table")
end)
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
function_3f_1 = (function(x6)
	return (type1(x6) == "function")
end)
key_3f_1 = (function(x7)
	return (type1(x7) == "key")
end)
between_3f_1 = (function(val1, min1, max1)
	local r_51 = (val1 >= min1)
	if r_51 then
		return (val1 <= max1)
	else
		return r_51
	end
end)
type1 = (function(val2)
	local ty1 = type_23_1(val2)
	if (ty1 == "table") then
		local tag1 = val2["tag"]
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
cdr2 = (function(x9)
	local r_251 = type1(x9)
	if (r_251 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_251), 2)
	else
	end
	if nil_3f_1(x9) then
		return {tag = "list", n =0}
	else
		return cdr1(x9)
	end
end)
foldr1 = (function(f1, z1, xs4)
	local r_261 = type1(f1)
	if (r_261 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "f", "function", r_261), 2)
	else
	end
	local r_381 = type1(xs4)
	if (r_381 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_381), 2)
	else
	end
	if nil_3f_1(xs4) then
		return z1
	else
		local head1 = car2(xs4)
		local tail1 = cdr2(xs4)
		return f1(head1, foldr1(f1, z1, tail1))
	end
end)
last1 = (function(xs5)
	local r_331 = type1(xs5)
	if (r_331 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_331), 2)
	else
	end
	return xs5[_23_1(xs5)]
end)
nth1 = (function(xs6, idx1)
	return xs6[idx1]
end)
pushCdr_21_1 = (function(xs7, val3)
	local r_341 = type1(xs7)
	if (r_341 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_341), 2)
	else
	end
	local len2 = (_23_1(xs7) + 1)
	xs7["n"] = len2
	xs7[len2] = val3
	return xs7
end)
popLast_21_1 = (function(xs8)
	local r_351 = type1(xs8)
	if (r_351 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_351), 2)
	else
	end
	xs8[_23_1(xs8)] = nil
	xs8["n"] = (_23_1(xs8) - 1)
	return xs8
end)
cadr1 = (function(x10)
	return car2(cdr2(x10))
end)
charAt1 = (function(xs9, x11)
	return sub1(xs9, x11, x11)
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
			local nstart1 = car2(pos1)
			local nend1 = cadr1(pos1)
			local temp1
			local r_461 = (nstart1 == nil)
			if r_461 then
				temp1 = r_461
			else
				local r_471 = limit1
				if r_471 then
					temp1 = (_23_1(out1) >= limit1)
				else
					temp1 = r_471
				end
			end
			if temp1 then
				loop1 = false
				pushCdr_21_1(out1, sub1(text1, start1, _23_s1(text1)))
				start1 = (_23_s1(text1) + 1)
			elseif (nstart1 > _23_s1(text1)) then
				if (start1 <= _23_s1(text1)) then
					pushCdr_21_1(out1, sub1(text1, start1, _23_s1(text1)))
				else
				end
				loop1 = false
			elseif (nend1 < nstart1) then
				pushCdr_21_1(out1, sub1(text1, start1, nstart1))
				start1 = (nstart1 + 1)
			else
				pushCdr_21_1(out1, sub1(text1, start1, (nstart1 - 1)))
				start1 = (nend1 + 1)
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
	local r_581 = _23_1(keys1)
	local r_591 = 2
	local r_561 = nil
	r_561 = (function(r_571)
		if (r_571 <= r_581) then
			local i1 = r_571
			local key2 = keys1[i1]
			local val4 = keys1[(1 + i1)]
			out2[(function()
				if key_3f_1(key2) then
					return contents1(key2)
				else
					return key2
				end
			end)()
			] = val4
			return r_561((r_571 + 2))
		else
		end
	end)
	r_561(1)
	return out2
end)
invokable_3f_1 = (function(x12)
	local r_841 = function_3f_1(x12)
	if r_841 then
		return r_841
	else
		local r_851 = table_3f_1(x12)
		if r_851 then
			local r_861 = table_3f_1(getmetatable1(x12))
			if r_861 then
				return function_3f_1(getmetatable1(x12)["__call"])
			else
				return r_861
			end
		else
			return r_851
		end
	end
end)
compose1 = (function(f2, g1)
	local temp2
	local r_871 = invokable_3f_1(f2)
	if r_871 then
		temp2 = invokable_3f_1(g1)
	else
		temp2 = r_871
	end
	if temp2 then
		return (function(x13)
			return f2(g1(x13))
		end)
	else
		return nil
	end
end)
succ1 = (function(x14)
	return (x14 + 1)
end)
pred1 = (function(x15)
	return (x15 - 1)
end)
string_2d3e_number1 = tonumber1
number_2d3e_string1 = tostring1
error_21_1 = error1
print_21_1 = print1
fail_21_1 = (function(x16)
	return error_21_1(x16, 0)
end)
abs1 = _libs["lib/lua/math/abs"]
max2 = _libs["lib/lua/math/max"]
verbosity1 = struct1("value", 0)
setVerbosity_21_1 = (function(level1)
	verbosity1["value"] = level1
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
formatPosition1 = (function(pos2)
	return _2e2e_1(pos2["line"], ":", pos2["column"])
end)
formatRange1 = (function(range1)
	if range1["finish"] then
		return format1("%s:[%s .. %s]", range1["name"], formatPosition1(range1["start"]), formatPosition1(range1["finish"]))
	else
		return format1("%s:[%s]", range1["name"], formatPosition1(range1["start"]))
	end
end)
formatNode1 = (function(node1)
	local temp3
	local r_1111 = node1["range"]
	if r_1111 then
		temp3 = node1["contents"]
	else
		temp3 = r_1111
	end
	if temp3 then
		return format1("%s (%q)", formatRange1(node1["range"]), node1["contents"])
	elseif node1["range"] then
		return formatRange1(node1["range"])
	elseif node1["macro"] then
		local macro1 = node1["macro"]
		return format1("macro expansion of %s (%s)", macro1["var"]["name"], formatNode1(macro1["node"]))
	else
		local temp4
		local r_1211 = node1["start"]
		if r_1211 then
			temp4 = node1["finish"]
		else
			temp4 = r_1211
		end
		if temp4 then
			return formatRange1(node1)
		else
			return "?"
		end
	end
end)
getSource1 = (function(node2)
	local result2 = nil
	local r_1121 = nil
	r_1121 = (function()
		local temp5
		local r_1131 = node2
		if r_1131 then
			temp5 = _21_1(result2)
		else
			temp5 = r_1131
		end
		if temp5 then
			result2 = node2["range"]
			node2 = node2["parent"]
			return r_1121()
		else
		end
	end)
	r_1121()
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
	local maxLine1 = foldr1((function(node3, max3)
		if string_3f_1(node3) then
			return max3
		else
			return max2(max3, node3["start"]["line"])
		end
	end), 0, entries1)
	local code1 = _2e2e_1("\27[92m %", _23_s1(number_2d3e_string1(maxLine1)), "s |\27[0m %s")
	local r_1241 = _23_1(entries1)
	local r_1251 = 2
	local r_1221 = nil
	r_1221 = (function(r_1231)
		if (r_1231 <= r_1241) then
			local i2 = r_1231
			local position1 = entries1[i2]
			local message1 = entries1[succ1(i2)]
			if (file1 ~= position1["name"]) then
				file1 = position1["name"]
				print_21_1(_2e2e_1("\27[95m ", file1, "\27[0m"))
			else
				local temp6
				local r_1261 = (previous1 ~= -1)
				if r_1261 then
					temp6 = (abs1((position1["start"]["line"] - previous1)) > 2)
				else
					temp6 = r_1261
				end
				if temp6 then
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
				local temp7
				local r_1271 = position1["finish"]
				if r_1271 then
					temp7 = (position1["start"]["line"] == position1["finish"]["line"])
				else
					temp7 = r_1271
				end
				if temp7 then
					pointer1 = rep1("^", succ1((position1["finish"]["column"] - position1["start"]["column"])))
				else
					pointer1 = "^..."
				end
			end
			print_21_1(format1(code1, "", _2e2e_1(rep1(" ", (position1["start"]["column"] - 1)), pointer1, " ", message1)))
			return r_1221((r_1231 + 2))
		else
		end
	end)
	return r_1221(1)
end)
putTrace_21_1 = (function(node4)
	local previous2 = nil
	local r_1141 = nil
	r_1141 = (function()
		if node4 then
			local formatted1 = formatNode1(node4)
			if (previous2 == nil) then
				print_21_1(colored1(96, _2e2e_1("  => ", formatted1)))
			elseif (previous2 ~= formatted1) then
				print_21_1(_2e2e_1("  in ", formatted1))
			else
			end
			previous2 = formatted1
			node4 = node4["parent"]
			return r_1141()
		else
		end
	end)
	return r_1141()
end)
putExplain_21_1 = (function(...)
	local lines3 = _pack(...) lines3.tag = "list"
	if showExplain1["value"] then
		local r_1161 = lines3
		local r_1191 = _23_1(r_1161)
		local r_1201 = 1
		local r_1171 = nil
		r_1171 = (function(r_1181)
			if (r_1181 <= r_1191) then
				local r_1151 = r_1181
				local line1 = r_1161[r_1151]
				print_21_1(_2e2e_1("  ", line1))
				return r_1171((r_1181 + 1))
			else
			end
		end)
		return r_1171(1)
	else
	end
end)
errorPositions_21_1 = (function(node5, msg6)
	printError_21_1(msg6)
	putTrace_21_1(node5)
	local source1 = getSource1(node5)
	if source1 then
		putLines_21_1(true, source1, "")
	else
	end
	return fail_21_1("An error occured")
end)
struct1("colored", colored1, "formatPosition", formatPosition1, "formatRange", formatRange1, "formatNode", formatNode1, "putLines", putLines_21_1, "putTrace", putTrace_21_1, "putInfo", putExplain_21_1, "getSource", getSource1, "printWarning", printWarning_21_1, "printError", printError_21_1, "printVerbose", printVerbose_21_1, "printDebug", printDebug_21_1, "errorPositions", errorPositions_21_1, "setVerbosity", setVerbosity_21_1, "setExplain", setExplain_21_1)
hexDigit_3f_1 = (function(char2)
	local r_881 = between_3f_1(char2, "0", "9")
	if r_881 then
		return r_881
	else
		local r_891 = between_3f_1(char2, "a", "f")
		if r_891 then
			return r_891
		else
			return between_3f_1(char2, "A", "F")
		end
	end
end)
binDigit_3f_1 = (function(char3)
	local r_901 = (char3 == "0")
	if r_901 then
		return r_901
	else
		return (char3 == "1")
	end
end)
terminator_3f_1 = (function(char4)
	local r_911 = (char4 == "\n")
	if r_911 then
		return r_911
	else
		local r_921 = (char4 == " ")
		if r_921 then
			return r_921
		else
			local r_931 = (char4 == "\9")
			if r_931 then
				return r_931
			else
				local r_941 = (char4 == "(")
				if r_941 then
					return r_941
				else
					local r_951 = (char4 == ")")
					if r_951 then
						return r_951
					else
						local r_961 = (char4 == "[")
						if r_961 then
							return r_961
						else
							local r_971 = (char4 == "]")
							if r_971 then
								return r_971
							else
								local r_981 = (char4 == "{")
								if r_981 then
									return r_981
								else
									local r_991 = (char4 == "}")
									if r_991 then
										return r_991
									else
										return (char4 == "")
									end
								end
							end
						end
					end
				end
			end
		end
	end
end)
digitError_21_1 = (function(pos3, name1, char5)
	printError_21_1(format1("Expected %s digit, got %s", name1, (function()
		if (char5 == "") then
			return "eof"
		else
			return quoted1(char5)
		end
	end)()
	))
	putTrace_21_1(pos3)
	putLines_21_1(false, pos3, "Invalid digit here")
	return fail_21_1("Lexing failed")
end)
lex1 = (function(str2, name2)
	local lines4 = split1(str2, "\n")
	local line2 = 1
	local column1 = 1
	local offset1 = 1
	local length1 = _23_s1(str2)
	local out3 = {tag = "list", n =0}
	local consume_21_1 = (function()
		if (charAt1(str2, offset1) == "\n") then
			line2 = (line2 + 1)
			column1 = 1
		else
			column1 = (column1 + 1)
		end
		offset1 = (offset1 + 1)
		return nil
	end)
	local position2 = (function()
		return struct1("line", line2, "column", column1, "offset", offset1)
	end)
	local range3 = (function(start2, finish1)
		return struct1("start", start2, "finish", (function(r_1561)
			if r_1561 then
				return r_1561
			else
				return start2
			end
		end)(finish1), "lines", lines4, "name", name2)
	end)
	local appendWith_21_1 = (function(data1, start3, finish2)
		local start4
		local r_1541 = start3
		if r_1541 then
			start4 = r_1541
		else
			start4 = position2()
		end
		local finish3
		local r_1551 = finish2
		if r_1551 then
			finish3 = r_1551
		else
			finish3 = position2()
		end
		data1["range"] = range3(start4, finish3)
		data1["contents"] = sub1(str2, start4["offset"], finish3["offset"])
		return pushCdr_21_1(out3, data1)
	end)
	local append_21_1 = (function(tag2, start5, finish4)
		return appendWith_21_1(struct1("tag", tag2), start5, finish4)
	end)
	local parseBase1 = (function(name3, p1, base1)
		local start6 = offset1
		local char6 = charAt1(str2, offset1)
		if p1(char6) then
		else
			digitError_21_1(range3(position2()), name3, char6)
		end
		char6 = charAt1(str2, succ1(offset1))
		local r_1531 = nil
		r_1531 = (function()
			if p1(char6) then
				consume_21_1()
				char6 = charAt1(str2, succ1(offset1))
				return r_1531()
			else
			end
		end)
		r_1531()
		return string_2d3e_number1(sub1(str2, start6, offset1), base1)
	end)
	local r_1001 = nil
	r_1001 = (function()
		if (offset1 <= length1) then
			local char7 = charAt1(str2, offset1)
			local temp8
			local r_1011 = (char7 == "\n")
			if r_1011 then
				temp8 = r_1011
			else
				local r_1021 = (char7 == "\9")
				if r_1021 then
					temp8 = r_1021
				else
					temp8 = (char7 == " ")
				end
			end
			if temp8 then
			elseif (char7 == "(") then
				appendWith_21_1(struct1("tag", "open", "close", ")"))
			elseif (char7 == ")") then
				appendWith_21_1(struct1("tag", "close", "open", "("))
			elseif (char7 == "[") then
				appendWith_21_1(struct1("tag", "open", "close", "]"))
			elseif (char7 == "]") then
				appendWith_21_1(struct1("tag", "close", "open", "["))
			elseif (char7 == "{") then
				appendWith_21_1(struct1("tag", "open", "close", "}"))
			elseif (char7 == "}") then
				appendWith_21_1(struct1("tag", "close", "open", "{"))
			elseif (char7 == "'") then
				append_21_1("quote")
			elseif (char7 == "`") then
				append_21_1("quasiquote")
			elseif (char7 == ",") then
				if (charAt1(str2, succ1(offset1)) == "@") then
					local start7 = position2()
					consume_21_1()
					append_21_1("unquote-splice", start7)
				else
					append_21_1("unquote")
				end
			elseif find1(str2, "^%-?%.?[0-9]", offset1) then
				local start8 = position2()
				local negative1 = (char7 == "-")
				if negative1 then
					consume_21_1()
					char7 = charAt1(str2, offset1)
				else
				end
				local val5
				local temp9
				local r_1341 = (char7 == "0")
				if r_1341 then
					temp9 = (charAt1(str2, succ1(offset1)) == "x")
				else
					temp9 = r_1341
				end
				if temp9 then
					consume_21_1()
					consume_21_1()
					local res1 = parseBase1("hexadecimal", hexDigit_3f_1, 16)
					if negative1 then
						res1 = (0 - res1)
						val5 = res1
					else
					end
				else
					local temp10
					local r_1351 = (char7 == "0")
					if r_1351 then
						temp10 = (charAt1(str2, succ1(offset1)) == "b")
					else
						temp10 = r_1351
					end
					if temp10 then
						consume_21_1()
						consume_21_1()
						local res2 = parseBase1("binary", binDigit_3f_1, 2)
						if negative1 then
							res2 = (0 - res2)
							val5 = res2
						else
						end
					else
						local r_1361 = nil
						r_1361 = (function()
							if between_3f_1(charAt1(str2, succ1(offset1)), "0", "9") then
								consume_21_1()
								return r_1361()
							else
							end
						end)
						r_1361()
						if (charAt1(str2, succ1(offset1)) == ".") then
							consume_21_1()
							local r_1371 = nil
							r_1371 = (function()
								if between_3f_1(charAt1(str2, succ1(offset1)), "0", "9") then
									consume_21_1()
									return r_1371()
								else
								end
							end)
							r_1371()
						else
						end
						char7 = charAt1(str2, succ1(offset1))
						local temp11
						local r_1381 = (char7 == "e")
						if r_1381 then
							temp11 = r_1381
						else
							temp11 = (char7 == "E")
						end
						if temp11 then
							consume_21_1()
							char7 = charAt1(str2, succ1(offset1))
							local temp12
							local r_1391 = (char7 == "-")
							if r_1391 then
								temp12 = r_1391
							else
								temp12 = (char7 == "+")
							end
							if temp12 then
								consume_21_1()
							else
							end
							local r_1401 = nil
							r_1401 = (function()
								if between_3f_1(charAt1(str2, succ1(offset1)), "0", "9") then
									consume_21_1()
									return r_1401()
								else
								end
							end)
							r_1401()
						else
						end
						val5 = string_2d3e_number1(sub1(str2, start8["offset"], offset1))
					end
				end
				appendWith_21_1(struct1("tag", "number", "value", val5), start8)
				char7 = charAt1(str2, succ1(offset1))
				if terminator_3f_1(char7) then
				else
					consume_21_1()
					printError_21_1(format1("Expected digit, got %s", (function()
						if (char7 == "") then
							return "eof"
						else
							return char7
						end
					end)()
					))
					putTrace_21_1(range3(position2()))
					putLines_21_1(false, range3(position2()), "Illegal character here. Are you missing whitespace?")
					fail_21_1("Lexing failed")
				end
			elseif (char7 == "\"") then
				local start9 = position2()
				local startCol1 = succ1(column1)
				local buffer1 = {tag = "list", n =0}
				consume_21_1()
				char7 = charAt1(str2, offset1)
				local r_1411 = nil
				r_1411 = (function()
					if (char7 ~= "\"") then
						if (column1 == 1) then
							local running1 = true
							local lineOff1 = offset1
							local r_1421 = nil
							r_1421 = (function()
								local temp13
								local r_1431 = running1
								if r_1431 then
									temp13 = (column1 < startCol1)
								else
									temp13 = r_1431
								end
								if temp13 then
									if (char7 == " ") then
										consume_21_1()
									elseif (char7 == "\n") then
										consume_21_1()
										pushCdr_21_1(buffer1, "\n")
										lineOff1 = offset1
									elseif (char7 == "") then
										running1 = false
									else
										printWarning_21_1(format1("Expected leading indent, got %q", char7))
										putTrace_21_1(range3(position2()))
										putExplain_21_1("You should try to align multi-line strings at the initial quote", "mark. This helps keep programs neat and tidy.")
										putLines_21_1(false, range3(start9), "String started with indent here", range3(position2()), "Mis-aligned character here")
										pushCdr_21_1(buffer1, sub1(str2, lineOff1, pred1(offset1)))
										running1 = false
									end
									char7 = charAt1(str2, offset1)
									return r_1421()
								else
								end
							end)
							r_1421()
						else
						end
						if (char7 == "") then
							printError_21_1("Expected '\"', got eof")
							local start10 = range3(start9)
							local finish5 = range3(position2())
							putTrace_21_1(finish5)
							putLines_21_1(false, start10, "string started here", finish5, "end of file here")
							fail_21_1("Lexing failed")
						elseif (char7 == "\\") then
							consume_21_1()
							char7 = charAt1(str2, offset1)
							if (char7 == "\n") then
							elseif (char7 == "a") then
								pushCdr_21_1(buffer1, "\7")
							elseif (char7 == "b") then
								pushCdr_21_1(buffer1, "\8")
							elseif (char7 == "f") then
								pushCdr_21_1(buffer1, "\12")
							elseif (char7 == "n") then
								pushCdr_21_1(buffer1, "\n")
							elseif (char7 == "t") then
								pushCdr_21_1(buffer1, "\9")
							elseif (char7 == "v") then
								pushCdr_21_1(buffer1, "\11")
							elseif (char7 == "\"") then
								pushCdr_21_1(buffer1, "\"")
							elseif (char7 == "\\") then
								pushCdr_21_1(buffer1, "\\")
							else
								local temp14
								local r_1441 = (char7 == "x")
								if r_1441 then
									temp14 = r_1441
								else
									local r_1451 = (char7 == "X")
									if r_1451 then
										temp14 = r_1451
									else
										temp14 = between_3f_1(char7, "0", "9")
									end
								end
								if temp14 then
									local start11 = position2()
									local val6
									local temp15
									local r_1461 = (char7 == "x")
									if r_1461 then
										temp15 = r_1461
									else
										temp15 = (char7 == "X")
									end
									if temp15 then
										consume_21_1()
										local start12 = offset1
										if hexDigit_3f_1(charAt1(str2, offset1)) then
										else
											digitError_21_1(range3(position2()), "hexadecimal", charAt1(str2, offset1))
										end
										if hexDigit_3f_1(charAt1(str2, succ1(offset1))) then
											consume_21_1()
										else
										end
										val6 = string_2d3e_number1(sub1(str2, start12, offset1), 16)
									else
										local start13 = position2()
										local ctr1 = 0
										char7 = charAt1(str2, succ1(offset1))
										local r_1481 = nil
										r_1481 = (function()
											local temp16
											local r_1491 = (ctr1 < 2)
											if r_1491 then
												temp16 = between_3f_1(char7, "0", "9")
											else
												temp16 = r_1491
											end
											if temp16 then
												consume_21_1()
												char7 = charAt1(str2, succ1(offset1))
												ctr1 = (ctr1 + 1)
												return r_1481()
											else
											end
										end)
										r_1481()
										val6 = string_2d3e_number1(sub1(str2, start13["offset"], offset1))
									end
									if (val6 >= 256) then
										printError_21_1("Invalid escape code")
										putTrace_21_1(range3(start11))
										putLines_21_1(true, range3(start11, position2()), _2e2e_1("Must be between 0 and 255, is ", val6))
										fail_21_1("Lexing failed")
									else
									end
									pushCdr_21_1(buffer1, char1(val6))
								elseif (char7 == "") then
									printError_21_1("Expected escape code, got eof")
									putTrace_21_1(range3(position2()))
									putLines_21_1(false, range3(position2()), "end of file here")
									fail_21_1("Lexing failed")
								else
									printError_21_1("Illegal escape character")
									putTrace_21_1(range3(position2()))
									putLines_21_1(false, range3(position2()), "Unknown escape character")
									fail_21_1("Lexing failed")
								end
							end
						else
							pushCdr_21_1(buffer1, char7)
						end
						consume_21_1()
						char7 = charAt1(str2, offset1)
						return r_1411()
					else
					end
				end)
				r_1411()
				appendWith_21_1(struct1("tag", "string", "value", concat1(buffer1)), start9)
			elseif (char7 == ";") then
				local r_1501 = nil
				r_1501 = (function()
					local temp17
					local r_1511 = (offset1 <= length1)
					if r_1511 then
						temp17 = (charAt1(str2, succ1(offset1)) ~= "\n")
					else
						temp17 = r_1511
					end
					if temp17 then
						consume_21_1()
						return r_1501()
					else
					end
				end)
				r_1501()
			else
				local start14 = position2()
				local key3 = (char7 == ":")
				char7 = charAt1(str2, succ1(offset1))
				local r_1521 = nil
				r_1521 = (function()
					if _21_1(terminator_3f_1(char7)) then
						consume_21_1()
						char7 = charAt1(str2, succ1(offset1))
						return r_1521()
					else
					end
				end)
				r_1521()
				if key3 then
					appendWith_21_1(struct1("tag", "key", "value", sub1(str2, succ1(start14["offset"]), offset1)), start14)
				else
					append_21_1("symbol", start14)
				end
			end
			consume_21_1()
			return r_1001()
		else
		end
	end)
	r_1001()
	append_21_1("eof")
	return out3
end)
parse1 = (function(toks1)
	local index1 = 1
	local head2 = {tag = "list", n =0}
	local stack1 = {tag = "list", n =0}
	local append_21_2 = (function(node6)
		local next1 = {tag = "list", n =0}
		pushCdr_21_1(head2, node6)
		node6["parent"] = head2
		return nil
	end)
	local push_21_1 = (function()
		local next2 = {tag = "list", n =0}
		pushCdr_21_1(stack1, head2)
		append_21_2(next2)
		head2 = next2
		return nil
	end)
	local pop_21_1 = (function()
		head2["open"] = nil
		head2["close"] = nil
		head2["auto-close"] = nil
		head2["last-node"] = nil
		head2 = last1(stack1)
		return popLast_21_1(stack1)
	end)
	local r_1041 = toks1
	local r_1071 = _23_1(r_1041)
	local r_1081 = 1
	local r_1051 = nil
	r_1051 = (function(r_1061)
		if (r_1061 <= r_1071) then
			local r_1031 = r_1061
			local tok1 = r_1041[r_1031]
			local tag3 = tok1["tag"]
			local autoClose1 = false
			local previous3 = head2["last-node"]
			local tokPos1 = tok1["range"]
			local temp18
			local r_1091 = (tag3 ~= "eof")
			if r_1091 then
				local r_1101 = (tag3 ~= "close")
				if r_1101 then
					if head2["range"] then
						temp18 = (tokPos1["start"]["line"] ~= head2["range"]["start"]["line"])
					else
						temp18 = true
					end
				else
					temp18 = r_1101
				end
			else
				temp18 = r_1091
			end
			if temp18 then
				if previous3 then
					local prevPos1 = previous3["range"]
					if (tokPos1["start"]["line"] ~= prevPos1["start"]["line"]) then
						head2["last-node"] = tok1
						if (tokPos1["start"]["column"] ~= prevPos1["start"]["column"]) then
							printWarning_21_1("Different indent compared with previous expressions.")
							putTrace_21_1(tok1)
							putExplain_21_1("You should try to maintain consistent indentation across a program,", "try to ensure all expressions are lined up.", "If this looks OK to you, check you're not missing a closing ')'.")
							putLines_21_1(false, prevPos1, "", tokPos1, "")
						else
						end
					else
					end
				else
					head2["last-node"] = tok1
				end
			else
			end
			local temp19
			local r_1281 = (tag3 == "string")
			if r_1281 then
				temp19 = r_1281
			else
				local r_1291 = (tag3 == "number")
				if r_1291 then
					temp19 = r_1291
				else
					local r_1301 = (tag3 == "symbol")
					if r_1301 then
						temp19 = r_1301
					else
						temp19 = (tag3 == "key")
					end
				end
			end
			if temp19 then
				append_21_2(tok1)
			elseif (tag3 == "open") then
				push_21_1()
				head2["open"] = tok1["contents"]
				head2["close"] = tok1["close"]
				head2["range"] = struct1("start", tok1["range"]["start"], "name", tok1["range"]["name"], "lines", tok1["range"]["lines"])
			elseif (tag3 == "close") then
				if nil_3f_1(stack1) then
					errorPositions_21_1(tok1, format1("'%s' without matching '%s'", tok1["contents"], tok1["open"]))
				elseif head2["auto-close"] then
					printError_21_1(format1("'%s' without matching '%s' inside quote", tok1["contents"], tok1["open"]))
					putTrace_21_1(tok1)
					putLines_21_1(false, head2["range"], "quote opened here", tok1["range"], "attempting to close here")
					fail_21_1("Parsing failed")
				elseif (head2["close"] ~= tok1["contents"]) then
					printError_21_1(format1("Expected '%s', got '%s'", head2["close"], tok1["contents"]))
					putTrace_21_1(tok1)
					putLines_21_1(false, head2["range"], format1("block opened with '%s'", head2["open"]), tok1["range"], format1("'%s' used here", tok1["contents"]))
					fail_21_1("Parsing failed")
				else
					head2["range"]["finish"] = tok1["range"]["finish"]
					pop_21_1()
				end
			else
				local temp20
				local r_1311 = (tag3 == "quote")
				if r_1311 then
					temp20 = r_1311
				else
					local r_1321 = (tag3 == "unquote")
					if r_1321 then
						temp20 = r_1321
					else
						local r_1331 = (tag3 == "quasiquote")
						if r_1331 then
							temp20 = r_1331
						else
							temp20 = (tag3 == "unquote-splice")
						end
					end
				end
				if temp20 then
					push_21_1()
					head2["range"] = struct1("start", tok1["range"]["start"], "name", tok1["range"]["name"], "lines", tok1["range"]["lines"])
					append_21_2(struct1("tag", "symbol", "contents", tag3, "range", tok1["range"]))
					autoClose1 = true
					head2["auto-close"] = true
				elseif (tag3 == "eof") then
					if (0 ~= _23_1(stack1)) then
						printError_21_1("Expected ')', got eof")
						putTrace_21_1(tok1)
						putLines_21_1(false, head2["range"], "block opened here", tok1["range"], "end of file here")
						fail_21_1("Parsing failed")
					else
					end
				else
					error_21_1(_2e2e_1("Unsupported type", tag3))
				end
			end
			if autoClose1 then
			else
				local r_1471 = nil
				r_1471 = (function()
					if head2["auto-close"] then
						if nil_3f_1(stack1) then
							errorPositions_21_1(tok1, format1("'%s' without matching '%s'", tok1["contents"], tok1["open"]))
							fail_21_1("Parsing failed")
						else
						end
						head2["range"]["finish"] = tok1["range"]["finish"]
						pop_21_1()
						return r_1471()
					else
					end
				end)
				r_1471()
			end
			return r_1051((r_1061 + 1))
		else
		end
	end)
	r_1051(1)
	return head2
end)
read1 = compose1(parse1, lex1)
return struct1("lex", lex1, "parse", parse1, "read", read1)
