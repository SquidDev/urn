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
slice1 = _libs["lib/lua/basic/slice"]
error1 = _libs["lib/lua/basic/error"]
print1 = _libs["lib/lua/basic/print"]
rawget1 = _libs["lib/lua/basic/rawget"]
rawset1 = _libs["lib/lua/basic/rawset"]
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
find1 = _libs["lib/lua/string/find"]
format1 = _libs["lib/lua/string/format"]
len1 = _libs["lib/lua/string/len"]
rep1 = _libs["lib/lua/string/rep"]
sub1 = _libs["lib/lua/string/sub"]
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
key_3f_1 = (function(x4)
	return (type1(x4) == "key")
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
pushCdr_21_1 = (function(xs4, val2)
	local len2 = (_23_1(xs4) + 1)
	xs4["n"] = len2
	xs4[len2] = val2
	return xs4
end)
cadr1 = (function(x5)
	return car1(cdr1(x5))
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
	local r_111 = nil
	r_111 = (function()
		if loop1 then
			local pos1 = list1(find1(text1, pattern1, start1))
			local _temp
			local r_121 = ("nil" == type_23_1(pos1))
			if r_121 then
				_temp = r_121
			else
				local r_131 = limit1
				if r_131 then
					_temp = (_23_1(out1) >= limit1)
				else
					_temp = r_131
				end
			end
			if _temp then
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
			return r_111()
		else
		end
	end)
	r_111()
	return out1
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
	local out2 = emptyStruct1()
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
			out2[(function()
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
	return out2
end)
succ1 = (function(x6)
	return (x6 + 1)
end)
pred1 = (function(x7)
	return (x7 - 1)
end)
number_2d3e_string1 = tostring1
error_21_1 = error1
print_21_1 = print1
fail_21_1 = (function(x8)
	return error_21_1(x8, 0)
end)
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
	print_21_1(colored1(31, _2e2e_1("[ERROR] ", car1(lines1))))
	if cadr1(lines1) then
		return print_21_1(cadr1(lines1))
	else
	end
end)
printWarning_21_1 = (function(msg3)
	local lines2 = split1(msg3, "\n", 1)
	print_21_1(colored1(33, _2e2e_1("[WARN] ", car1(lines2))))
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
		return format1("%s %s-%s", range1["name"], formatPosition1(range1["start"]), formatPosition1(range1["finish"]))
	else
		return format1("%s %s", range1["name"], formatPosition1(range1["start"]))
	end
end)
formatNode1 = (function(node1)
	local _temp
	local r_541 = node1["range"]
	if r_541 then
		_temp = node1["contents"]
	else
		_temp = r_541
	end
	if _temp then
		return format1("%s (%q)", formatRange1(node1["range"]), node1["contents"])
	elseif node1["range"] then
		return formatRange1(node1["range"])
	elseif node1["macro"] then
		local macro1 = node1["macro"]
		return format1("macro expansion of %s (%s)", macro1["var"]["name"], formatNode1(macro1["node"]))
	else
		return "?"
	end
end)
getSource1 = (function(node2)
	local result1 = nil
	local r_551 = nil
	r_551 = (function()
		local _temp
		local r_561 = node2
		if r_561 then
			_temp = _21_1(result1)
		else
			_temp = r_561
		end
		if _temp then
			result1 = node2["range"]
			node2 = node2["parent"]
			return r_551()
		else
		end
	end)
	r_551()
	return result1
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
	local maxLine1 = entries1[pred1(_23_1(entries1))]["start"]["line"]
	local code1 = _2e2e_1("\27[92m %", _23_s1(number_2d3e_string1(maxLine1)), "s |\27[0m %s")
	local r_661 = _23_1(entries1)
	local r_671 = 2
	local r_641 = nil
	r_641 = (function(r_651)
		local _temp
		if (0 < 2) then
			_temp = (r_651 <= r_661)
		else
			_temp = (r_651 >= r_661)
		end
		if _temp then
			local i2 = r_651
			local position1 = entries1[i2]
			local message1 = entries1[succ1(i2)]
			local _temp
			local r_681 = (previous1 ~= -1)
			if r_681 then
				_temp = ((position1["start"]["line"] - previous1) > 2)
			else
				_temp = r_681
			end
			if _temp then
				print_21_1(" \27[92m...\27[0m")
			else
			end
			previous1 = position1["start"]["line"]
			print_21_1(format1(code1, number_2d3e_string1(position1["start"]["line"]), position1["lines"][position1["start"]["line"]]))
			local pointer1
			if _21_1(range2) then
				pointer1 = "^"
			else
				local _temp
				local r_691 = position1["finish"]
				if r_691 then
					_temp = (position1["start"]["line"] == position1["finish"]["line"])
				else
					_temp = r_691
				end
				if _temp then
					pointer1 = rep1("^", _2d_1(position1["finish"]["column"], position1["start"]["column"], -1))
				else
					pointer1 = "^..."
				end
			end
			print_21_1(format1(code1, "", _2e2e_1(rep1(" ", (position1["start"]["column"] - 1)), pointer1, " ", message1)))
			return r_641((r_651 + r_671))
		else
		end
	end)
	return r_641(1)
end)
putTrace_21_1 = (function(node3)
	local previous2 = nil
	local r_571 = nil
	r_571 = (function()
		if node3 then
			local formatted1 = formatNode1(node3)
			if (previous2 == nil) then
				print_21_1(colored1(96, _2e2e_1("  => ", formatted1)))
			elseif (previous2 ~= formatted1) then
				print_21_1(_2e2e_1("  in ", formatted1))
			else
			end
			previous2 = formatted1
			node3 = node3["parent"]
			return r_571()
		else
		end
	end)
	return r_571()
end)
putExplain_21_1 = (function(...)
	local lines3 = _pack(...) lines3.tag = "list"
	if showExplain1["value"] then
		local r_591 = lines3
		local r_621 = _23_1(r_591)
		local r_631 = 1
		local r_601 = nil
		r_601 = (function(r_611)
			local _temp
			if (0 < 1) then
				_temp = (r_611 <= r_621)
			else
				_temp = (r_611 >= r_621)
			end
			if _temp then
				local r_581 = r_611
				local line1 = r_591[r_581]
				print_21_1(_2e2e_1("  ", line1))
				return r_601((r_611 + r_631))
			else
			end
		end)
		return r_601(1)
	else
	end
end)
errorPositions_21_1 = (function(node4, msg6)
	printError_21_1(msg6)
	putTrace_21_1(node4)
	local source1 = getSource1(node4)
	if source1 then
		putLines_21_1(true, source1, "")
	else
	end
	return fail_21_1("An error occured")
end)
return struct1("formatPosition", formatPosition1, "formatRange", formatRange1, "formatNode", formatNode1, "putLines", putLines_21_1, "putTrace", putTrace_21_1, "putInfo", putExplain_21_1, "getSource", getSource1, "printWarning", printWarning_21_1, "printError", printError_21_1, "printVerbose", printVerbose_21_1, "printDebug", printDebug_21_1, "errorPositions", errorPositions_21_1, "setVerbosity", setVerbosity_21_1, "setExplain", setExplain_21_1)
