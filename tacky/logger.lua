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
getIdx1 = _libs["get-idx"]
setIdx_21_1 = _libs["set-idx!"]
format1 = _libs["format"]
print_21_1 = _libs["print!"]
error_21_1 = _libs["error!"]
type_23_1 = _libs["type#"]
emptyStruct1 = _libs["empty-struct"]
number_2d3e_string1 = _libs["number->string"]
_23_1 = (function(xs1)
	return xs1["n"]
end)
car1 = (function(xs2)
	return xs2[1]
end)
_21_1 = (function(expr1)
	if expr1 then
		return false
	else
		return true
	end
end)
key_3f_1 = (function(x1)
	return (type1(x1) == "key")
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
car2 = (function(li3)
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
cadr1 = (function(x2)
	return nth1(x2, 2)
end)
concat1 = _libs["concat"]
find1 = _libs["find"]
format2 = _libs["format"]
rep1 = _libs["rep"]
sub1 = _libs["sub"]
_23_s1 = _libs["#s"]
_2e2e_1 = (function(...)
	local args1 = _pack(...) args1.tag = "list"
	return concat1(args1)
end)
split1 = (function(text1, pattern1, limit1)
	local out1, loop1, start1
	out1 = {tag = "list", n =0}
	loop1 = true
	start1 = 1
	local r_591
	r_591 = nil
	r_591 = (function()
		if loop1 then
			local pos1
			pos1 = find1(text1, pattern1, start1)
			local _temp
			local r_601
			r_601 = ("nil" == type_23_1(pos1))
			if r_601 then
				_temp = r_601
			else
				local r_611
				r_611 = limit1
				if r_611 then
					_temp = (_23_1(out1) >= limit1)
				else
					_temp = r_611
				end
			end
			if _temp then
				loop1 = false
				pushCdr_21_1(out1, sub1(text1, start1, _23_s1(text1)))
				start1 = (_23_s1(text1) + 1)
			else
				pushCdr_21_1(out1, sub1(text1, start1, (car1(pos1) - 1)))
				start1 = (cadr1(pos1) + 1)
			end
			return r_591()
		else
		end
	end)
	r_591()
	return out1
end)
struct1 = (function(...)
	local keys1 = _pack(...) keys1.tag = "list"
	if ((_23_2(keys1) % 1) == 1) then
		error_21_1("Expected an even number of arguments to struct", 2)
	else
	end
	local contents1, out2
	contents1 = (function(key1)
		return sub1(key1["contents"], 2)
	end)
	out2 = {}
	local r_661
	r_661 = _23_1(keys1)
	local r_671
	r_671 = 2
	local r_641
	r_641 = nil
	r_641 = (function(r_651)
		local _temp
		if (0 < 2) then
			_temp = (r_651 <= r_661)
		else
			_temp = (r_651 >= r_661)
		end
		if _temp then
			local i1
			i1 = r_651
			local key2, val3
			key2 = keys1[i1]
			val3 = keys1[(1 + i1)]
			out2[(function()
				if key_3f_1(key2) then
					return contents1(key2)
				else
					return key2
				end
			end)()
			] = val3
			return r_641((r_651 + r_671))
		else
		end
	end)
	r_641(1)
	return out2
end)
fail1 = (function(msg1)
	return error_21_1(msg1, 0)
end)
succ1 = (function(x3)
	return (1 + x3)
end)
pred1 = (function(x4)
	return (x4 - 1)
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
colored1 = (function(col1, msg2)
	return _2e2e_1("\27[", col1, "m", msg2, "\27[0m")
end)
printError_21_1 = (function(msg3)
	local lines1
	lines1 = split1(msg3, "\n", 1)
	print_21_1(colored1(31, _2e2e_1("[ERROR] ", car2(lines1))))
	if cadr1(lines1) then
		return print_21_1(cadr1(lines1))
	else
	end
end)
printWarning_21_1 = (function(msg4)
	local lines2
	lines2 = split1(msg4, "\n", 1)
	print_21_1(colored1(33, _2e2e_1("[WARN] ", car2(lines2))))
	if cadr1(lines2) then
		return print_21_1(cadr1(lines2))
	else
	end
end)
printVerbose_21_1 = (function(msg5)
	if (verbosity1["value"] > 0) then
		return print_21_1(_2e2e_1("[VERBOSE] ", msg5))
	else
	end
end)
printDebug_21_1 = (function(msg6)
	if (verbosity1["value"] > 1) then
		return print_21_1(_2e2e_1("[DEBUG] ", msg6))
	else
	end
end)
formatPosition1 = (function(pos2)
	return _2e2e_1(pos2["line"], ":", pos2["column"])
end)
formatRange1 = (function(range1)
	if range1["finish"] then
		return format2("%s %s-%s", range1["name"], formatPosition1(range1["start"]), formatPosition1(range1["finish"]))
	else
		return format2("%s %s", range1["name"], formatPosition1(range1["start"]))
	end
end)
formatNode1 = (function(node1)
	local _temp
	local r_971
	r_971 = node1["range"]
	if r_971 then
		_temp = node1["contents"]
	else
		_temp = r_971
	end
	if _temp then
		return format2("%s (%q)", formatRange1(node1["range"]), node1["contents"])
	elseif node1["range"] then
		return formatRange1(node1["range"])
	elseif node1["macro"] then
		local macro1
		macro1 = node1["macro"]
		return format2("macro expansion of %s (%s)", macro1["var"]["name"], formatNode1(macro1["node"]))
	else
		return "?"
	end
end)
getSource1 = (function(node2)
	local result1
	result1 = nil
	local r_981
	r_981 = nil
	r_981 = (function()
		local _temp
		local r_991
		r_991 = node2
		if r_991 then
			_temp = _21_1(result1)
		else
			_temp = r_991
		end
		if _temp then
			result1 = node2["range"]
			node2 = node2["parent"]
			return r_981()
		else
		end
	end)
	r_981()
	return result1
end)
putLines_21_1 = (function(range2, ...)
	local entries1 = _pack(...) entries1.tag = "list"
	if nil_3f_1(entries1) then
		error_21_1("Positions cannot be empty")
	else
	end
	if ((_23_2(entries1) % 2) ~= 0) then
		error_21_1(_2e2e_1("Positions must be a multiple of 2, is ", _23_2(entries1)))
	else
	end
	local previous1
	previous1 = -1
	local maxLine1
	maxLine1 = entries1[pred1(_23_2(entries1))]["start"]["line"]
	local code1
	code1 = _2e2e_1("\27[92m %", _23_s1(number_2d3e_string1(maxLine1)), "s |\27[0m %s")
	local r_1091
	r_1091 = _23_2(entries1)
	local r_1101
	r_1101 = 2
	local r_1071
	r_1071 = nil
	r_1071 = (function(r_1081)
		local _temp
		if (0 < 2) then
			_temp = (r_1081 <= r_1091)
		else
			_temp = (r_1081 >= r_1091)
		end
		if _temp then
			local i2
			i2 = r_1081
			local position1, message1
			position1 = entries1[i2]
			message1 = entries1[succ1(i2)]
			local _temp
			local r_1111
			r_1111 = (previous1 ~= -1)
			if r_1111 then
				_temp = ((position1["start"]["line"] - previous1) > 2)
			else
				_temp = r_1111
			end
			if _temp then
				print_21_1(" \27[92m...\27[0m")
			else
			end
			previous1 = position1["start"]["line"]
			print_21_1(format2(code1, number_2d3e_string1(position1["start"]["line"]), position1["lines"][position1["start"]["line"]]))
			local pointer1
			if _21_1(range2) then
				pointer1 = "^"
			else
				local _temp
				local r_1121
				r_1121 = position1["finish"]
				if r_1121 then
					_temp = (position1["start"]["line"] == position1["finish"]["line"])
				else
					_temp = r_1121
				end
				if _temp then
					pointer1 = rep1("^", _2d_1(position1["finish"]["column"], position1["start"]["column"], -1))
				else
					pointer1 = "^..."
				end
			end
			print_21_1(format2(code1, "", _2e2e_1(rep1(" ", (position1["start"]["column"] - 1)), pointer1, " ", message1)))
			return r_1071((r_1081 + r_1101))
		else
		end
	end)
	return r_1071(1)
end)
putTrace_21_1 = (function(node3)
	local previous2
	previous2 = nil
	local r_1001
	r_1001 = nil
	r_1001 = (function()
		if node3 then
			local formatted1
			formatted1 = formatNode1(node3)
			if (previous2 == nil) then
				print_21_1(colored1(96, _2e2e_1("  => ", formatted1)))
			elseif (previous2 ~= formatted1) then
				print_21_1(_2e2e_1("  in ", formatted1))
			else
			end
			previous2 = formatted1
			node3 = node3["parent"]
			return r_1001()
		else
		end
	end)
	return r_1001()
end)
putExplain_21_1 = (function(...)
	local lines3 = _pack(...) lines3.tag = "list"
	if showExplain1["value"] then
		local r_1021
		r_1021 = lines3
		local r_1051
		r_1051 = _23_2(r_1021)
		local r_1061
		r_1061 = 1
		local r_1031
		r_1031 = nil
		r_1031 = (function(r_1041)
			local _temp
			if (0 < 1) then
				_temp = (r_1041 <= r_1051)
			else
				_temp = (r_1041 >= r_1051)
			end
			if _temp then
				local r_1011
				r_1011 = r_1041
				local line1
				line1 = r_1021[r_1011]
				print_21_1(_2e2e_1("  ", line1))
				return r_1031((r_1041 + r_1061))
			else
			end
		end)
		return r_1031(1)
	else
	end
end)
errorPositions_21_1 = (function(node4, msg7)
	printError_21_1(msg7)
	putTrace_21_1(node4)
	local source1
	source1 = getSource1(node4)
	if source1 then
		putLines_21_1(true, source1, "")
	else
	end
	return fail1("An error occured")
end)
return struct1("formatPosition", formatPosition1, "formatRange", formatRange1, "formatNode", formatNode1, "putLines", putLines_21_1, "putTrace", putTrace_21_1, "putInfo", putExplain_21_1, "getSource", getSource1, "printWarning", printWarning_21_1, "printError", printError_21_1, "printVerbose", printVerbose_21_1, "printDebug", printDebug_21_1, "errorPositions", errorPositions_21_1, "setVerbosity", setVerbosity_21_1, "setExplain", setExplain_21_1)
