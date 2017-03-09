if not table.pack then table.pack = function(...) return { n = select("#", ...), ... } end end
if not table.unpack then table.unpack = unpack end
local load = load if _VERSION:find("5.1") then load = function(x, _, _, env) local f, e = loadstring(x); if not f then error(e, 1) end; return setfenv(f, env) end end
local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error
local _libs = {}
local _temp = (function()
	return {
		['slice'] = function(xs, start, finish)
			if not finish then finish = xs.n end
			if not finish then finish = #xs end
			return { tag = "list", n = finish - start + 1, table.unpack(xs, start, finish) }
		end,
	}
end)()
for k, v in pairs(_temp) do _libs["lua/basic-0/".. k] = v end
local _3d_1, _2f3d_1, _3c_1, _3c3d_1, _3e_1, _3e3d_1, _2b_1, _2d_1, _25_1, _2e2e_1, slice1, error1, getmetatable1, print1, getIdx1, setIdx_21_1, tostring1, type_23_1, _23_1, find1, format1, len1, rep1, sub1, concat1, emptyStruct1, car1, cdr1, list1, _21_1, pretty1, list_3f_1, nil_3f_1, string_3f_1, key_3f_1, type1, car2, cdr2, foldr1, nth1, pushCdr_21_1, cadr1, charAt1, _2e2e_2, split1, getenv1, struct1, succ1, formatPosition1, formatRange1, formatNode1, getSource1, config1, coloredAnsi1, colored_3f_1, colored1, printError_21_1, printWarning_21_1, printVerbose_21_1, printDebug_21_1, printExplain_21_1, abs1, max1, create1, putError_21_1, putWarning_21_1, putVerbose_21_1, putDebug_21_1, putNodeError_21_1, putNodeWarning_21_1, putLines_21_1, putTrace_21_1
_3d_1 = function(v1, v2) return (v1 == v2) end
_2f3d_1 = function(v1, v2) return (v1 ~= v2) end
_3c_1 = function(v1, v2) return (v1 < v2) end
_3c3d_1 = function(v1, v2) return (v1 <= v2) end
_3e_1 = function(v1, v2) return (v1 > v2) end
_3e3d_1 = function(v1, v2) return (v1 >= v2) end
_2b_1 = function(v1, v2) return (v1 + v2) end
_2d_1 = function(v1, v2) return (v1 - v2) end
_25_1 = function(v1, v2) return (v1 % v2) end
_2e2e_1 = function(v1, v2) return (v1 .. v2) end
slice1 = _libs["lua/basic-0/slice"]
error1 = error
getmetatable1 = getmetatable
print1 = print
getIdx1 = function(v1, v2) return v1[v2] end
setIdx_21_1 = function(v1, v2, v3) v1[v2] = v3 end
tostring1 = tostring
type_23_1 = type
_23_1 = (function(x1)
	return x1["n"]
end)
find1 = string.find
format1 = string.format
len1 = string.len
rep1 = string.rep
sub1 = string.sub
concat1 = table.concat
emptyStruct1 = function() return {} end
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
pretty1 = (function(value1)
	local ty1 = type_23_1(value1)
	if (ty1 == "table") then
		local tag1 = value1["tag"]
		if (tag1 == "list") then
			local out1 = {tag = "list", n = 0}
			local r_51 = _23_1(value1)
			local r_31 = nil
			r_31 = (function(r_41)
				if (r_41 <= r_51) then
					out1[r_41] = pretty1(value1[r_41])
					return r_31((r_41 + 1))
				else
				end
			end)
			r_31(1)
			return ("(" .. (concat1(out1, " ") .. ")"))
		else
			local temp1
			local r_71 = (type_23_1(getmetatable1(value1)) == "table")
			if r_71 then
				temp1 = (type_23_1(getmetatable1(value1)["--pretty-print"]) == "function")
			else
				temp1 = r_71
			end
			if temp1 then
				return getmetatable1(value1)["--pretty-print"](value1)
			elseif (tag1 == "list") then
				return value1["contents"]
			elseif (tag1 == "symbol") then
				return value1["contents"]
			elseif (tag1 == "key") then
				return (":" .. value1["contents"])
			elseif (tag1 == "string") then
				return format1("%q", value1["value"])
			elseif (tag1 == "number") then
				return tostring1(value1["value"])
			else
				return tostring1(value1)
			end
		end
	elseif (ty1 == "string") then
		return format1("%q", value1)
	else
		return tostring1(value1)
	end
end)
list_3f_1 = (function(x2)
	return (type1(x2) == "list")
end)
nil_3f_1 = (function(x3)
	if x3 then
		local r_161 = list_3f_1(x3)
		if r_161 then
			return (_23_1(x3) == 0)
		else
			return r_161
		end
	else
		return x3
	end
end)
string_3f_1 = (function(x4)
	return (type1(x4) == "string")
end)
key_3f_1 = (function(x5)
	return (type1(x5) == "key")
end)
type1 = (function(val1)
	local ty2 = type_23_1(val1)
	if (ty2 == "table") then
		local tag2 = val1["tag"]
		if tag2 then
			return tag2
		else
			return "table"
		end
	else
		return ty2
	end
end)
car2 = (function(x6)
	local r_361 = type1(x6)
	if (r_361 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_361), 2)
	else
	end
	return car1(x6)
end)
cdr2 = (function(x7)
	local r_371 = type1(x7)
	if (r_371 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "x", "list", r_371), 2)
	else
	end
	if nil_3f_1(x7) then
		return {tag = "list", n = 0}
	else
		return cdr1(x7)
	end
end)
foldr1 = (function(f1, z1, xs4)
	local r_381 = type1(f1)
	if (r_381 ~= "function") then
		error1(format1("bad argment %s (expected %s, got %s)", "f", "function", r_381), 2)
	else
	end
	local r_511 = type1(xs4)
	if (r_511 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_511), 2)
	else
	end
	local accum1 = z1
	local r_541 = _23_1(xs4)
	local r_521 = nil
	r_521 = (function(r_531)
		if (r_531 <= r_541) then
			accum1 = f1(accum1, nth1(xs4, r_531))
			return r_521((r_531 + 1))
		else
		end
	end)
	r_521(1)
	return accum1
end)
nth1 = (function(xs5, idx1)
	return xs5[idx1]
end)
pushCdr_21_1 = (function(xs6, val2)
	local r_461 = type1(xs6)
	if (r_461 ~= "list") then
		error1(format1("bad argment %s (expected %s, got %s)", "xs", "list", r_461), 2)
	else
	end
	local len2 = (_23_1(xs6) + 1)
	xs6["n"] = len2
	xs6[len2] = val2
	return xs6
end)
cadr1 = (function(x8)
	return car2(cdr2(x8))
end)
charAt1 = (function(xs7, x9)
	return sub1(xs7, x9, x9)
end)
_2e2e_2 = (function(...)
	local args1 = _pack(...) args1.tag = "list"
	return concat1(args1)
end)
split1 = (function(text1, pattern1, limit1)
	local out2 = {tag = "list", n = 0}
	local loop1 = true
	local start1 = 1
	local r_651 = nil
	r_651 = (function()
		if loop1 then
			local pos1 = list1(find1(text1, pattern1, start1))
			local nstart1 = car2(pos1)
			local nend1 = cadr1(pos1)
			local temp2
			local r_661 = (nstart1 == nil)
			if r_661 then
				temp2 = r_661
			else
				if limit1 then
					temp2 = (_23_1(out2) >= limit1)
				else
					temp2 = limit1
				end
			end
			if temp2 then
				loop1 = false
				pushCdr_21_1(out2, sub1(text1, start1, len1(text1)))
				start1 = (len1(text1) + 1)
			elseif (nstart1 > len1(text1)) then
				if (start1 <= len1(text1)) then
					pushCdr_21_1(out2, sub1(text1, start1, len1(text1)))
				else
				end
				loop1 = false
			elseif (nend1 < nstart1) then
				pushCdr_21_1(out2, sub1(text1, start1, nstart1))
				start1 = (nstart1 + 1)
			else
				pushCdr_21_1(out2, sub1(text1, start1, (nstart1 - 1)))
				start1 = (nend1 + 1)
			end
			return r_651()
		else
		end
	end)
	r_651()
	return out2
end)
getenv1 = os.getenv
struct1 = (function(...)
	local keys1 = _pack(...) keys1.tag = "list"
	if ((_23_1(keys1) % 1) == 1) then
		error1("Expected an even number of arguments to struct", 2)
	else
	end
	local contents1 = (function(key1)
		return key1["contents"]
	end)
	local out3 = {}
	local r_761 = _23_1(keys1)
	local r_741 = nil
	r_741 = (function(r_751)
		if (r_751 <= r_761) then
			local key2 = keys1[r_751]
			local val3 = keys1[(1 + r_751)]
			out3[(function()
				if key_3f_1(key2) then
					return contents1(key2)
				else
					return key2
				end
			end)()
			] = val3
			return r_741((r_751 + 2))
		else
		end
	end)
	r_741(1)
	return out3
end)
succ1 = (function(x10)
	return (x10 + 1)
end)
formatPosition1 = (function(pos2)
	return _2e2e_2(pos2["line"], ":", pos2["column"])
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
	local r_1481 = node1["range"]
	if r_1481 then
		temp3 = node1["contents"]
	else
		temp3 = r_1481
	end
	if temp3 then
		return format1("%s (%q)", formatRange1(node1["range"]), node1["contents"])
	elseif node1["range"] then
		return formatRange1(node1["range"])
	elseif node1["owner"] then
		local owner1 = node1["owner"]
		if owner1["var"] then
			return format1("macro expansion of %s (%s)", owner1["var"]["name"], formatNode1(owner1["node"]))
		else
			return format1("unquote expansion (%s)", formatNode1(owner1["node"]))
		end
	else
		local temp4
		local r_1511 = node1["start"]
		if r_1511 then
			temp4 = node1["finish"]
		else
			temp4 = r_1511
		end
		if temp4 then
			return formatRange1(node1)
		else
			return "?"
		end
	end
end)
getSource1 = (function(node2)
	local result1 = nil
	local r_1491 = nil
	r_1491 = (function()
		local temp5
		local r_1501 = node2
		if r_1501 then
			temp5 = _21_1(result1)
		else
			temp5 = r_1501
		end
		if temp5 then
			result1 = node2["range"]
			node2 = node2["parent"]
			return r_1491()
		else
		end
	end)
	r_1491()
	return result1
end)
struct1("formatPosition", formatPosition1, "formatRange", formatRange1, "formatNode", formatNode1, "getSource", getSource1)
config1 = package.config
coloredAnsi1 = (function(col1, msg1)
	return _2e2e_2("\27[", col1, "m", msg1, "\27[0m")
end)
local temp6
if config1 then
	temp6 = (charAt1(config1, 1) ~= "\\")
else
	temp6 = config1
end
if temp6 then
	colored_3f_1 = true
else
	local temp7
	if getenv1 then
		temp7 = (getenv1("ANSICON") ~= nil)
	else
		temp7 = getenv1
	end
	if temp7 then
		colored_3f_1 = true
	else
		local temp8
		if getenv1 then
			local term1 = getenv1("TERM")
			if term1 then
				temp8 = find1(term1, "xterm")
			else
				temp8 = nil
			end
		else
			temp8 = getenv1
		end
		if temp8 then
			colored_3f_1 = true
		else
			colored_3f_1 = false
		end
	end
end
if colored_3f_1 then
	colored1 = coloredAnsi1
else
	colored1 = (function(col2, msg2)
		return msg2
	end)
end
printError_21_1 = (function(msg3)
	if string_3f_1(msg3) then
	else
		msg3 = pretty1(msg3)
	end
	local lines1 = split1(msg3, "\n", 1)
	print1(colored1(31, _2e2e_2("[ERROR] ", car2(lines1))))
	if cadr1(lines1) then
		return print1(cadr1(lines1))
	else
	end
end)
printWarning_21_1 = (function(msg4)
	local lines2 = split1(msg4, "\n", 1)
	print1(colored1(33, _2e2e_2("[WARN] ", car2(lines2))))
	if cadr1(lines2) then
		return print1(cadr1(lines2))
	else
	end
end)
printVerbose_21_1 = (function(verbosity1, msg5)
	if (verbosity1 > 0) then
		return print1(_2e2e_2("[VERBOSE] ", msg5))
	else
	end
end)
printDebug_21_1 = (function(verbosity2, msg6)
	if (verbosity2 > 1) then
		return print1(_2e2e_2("[DEBUG] ", msg6))
	else
	end
end)
printExplain_21_1 = (function(explain1, lines3)
	if explain1 then
		local r_1531 = split1(lines3, "\n")
		local r_1561 = _23_1(r_1531)
		local r_1541 = nil
		r_1541 = (function(r_1551)
			if (r_1551 <= r_1561) then
				local line1 = r_1531[r_1551]
				print1(_2e2e_2("  ", line1))
				return r_1541((r_1551 + 1))
			else
			end
		end)
		return r_1541(1)
	else
	end
end)
abs1 = math.abs
max1 = math.max
create1 = (function(verbosity3, explain2)
	return struct1("verbosity", (function()
		if verbosity3 then
			return verbosity3
		else
			return 0
		end
	end)(), "explain", (explain2 == true), "put-error!", putError_21_1, "put-warning!", putWarning_21_1, "put-verbose!", putVerbose_21_1, "put-debug!", putDebug_21_1, "put-node-error!", putNodeError_21_1, "put-node-warning!", putNodeWarning_21_1)
end)
putError_21_1 = (function(messenger1, msg7)
	return printError_21_1(msg7)
end)
putWarning_21_1 = (function(messenger2, msg8)
	return printWarning_21_1(msg8)
end)
putVerbose_21_1 = (function(messenger3, msg9)
	return printVerbose_21_1(messenger3["verbosity"], msg9)
end)
putDebug_21_1 = (function(messenger4, msg10)
	return printDebug_21_1(messenger4["verbosity"], msg10)
end)
putNodeError_21_1 = (function(logger1, msg11, node3, explain3, lines4)
	printError_21_1(msg11)
	putTrace_21_1(node3)
	if explain3 then
		printExplain_21_1(logger1["explain"], explain3)
	else
	end
	return putLines_21_1(true, lines4)
end)
putNodeWarning_21_1 = (function(logger2, msg12, node4, explain4, lines5)
	printWarning_21_1(msg12)
	putTrace_21_1(node4)
	if explain4 then
		printExplain_21_1(logger2["explain"], explain4)
	else
	end
	return putLines_21_1(true, lines5)
end)
putLines_21_1 = (function(range2, entries1)
	if nil_3f_1(entries1) then
		error1("Positions cannot be empty")
	else
	end
	if ((_23_1(entries1) % 2) ~= 0) then
		error1(_2e2e_2("Positions must be a multiple of 2, is ", _23_1(entries1)))
	else
	end
	local previous1 = -1
	local file1 = nth1(entries1, 1)["name"]
	local maxLine1 = foldr1((function(max2, node5)
		if string_3f_1(node5) then
			return max2
		else
			return max1(max2, node5["start"]["line"])
		end
	end), 0, entries1)
	local code1 = _2e2e_2(colored1(92, _2e2e_2(" %", len1(tostring1(maxLine1)), "s |")), " %s")
	local r_1631 = _23_1(entries1)
	local r_1611 = nil
	r_1611 = (function(r_1621)
		if (r_1621 <= r_1631) then
			local position1 = entries1[r_1621]
			local message1 = entries1[succ1(r_1621)]
			if (file1 ~= position1["name"]) then
				file1 = position1["name"]
				print1(colored1(95, _2e2e_2(" ", file1)))
			else
				local temp9
				local r_1651 = (previous1 ~= -1)
				if r_1651 then
					temp9 = (abs1((position1["start"]["line"] - previous1)) > 2)
				else
					temp9 = r_1651
				end
				if temp9 then
					print1(colored1(92, " ..."))
				else
				end
			end
			previous1 = position1["start"]["line"]
			print1(format1(code1, tostring1(position1["start"]["line"]), position1["lines"][position1["start"]["line"]]))
			local pointer1
			if _21_1(range2) then
				pointer1 = "^"
			else
				local temp10
				local r_1661 = position1["finish"]
				if r_1661 then
					temp10 = (position1["start"]["line"] == position1["finish"]["line"])
				else
					temp10 = r_1661
				end
				if temp10 then
					pointer1 = rep1("^", succ1((position1["finish"]["column"] - position1["start"]["column"])))
				else
					pointer1 = "^..."
				end
			end
			print1(format1(code1, "", _2e2e_2(rep1(" ", (position1["start"]["column"] - 1)), pointer1, " ", message1)))
			return r_1611((r_1621 + 2))
		else
		end
	end)
	return r_1611(1)
end)
putTrace_21_1 = (function(node6)
	local previous2 = nil
	local r_1471 = nil
	r_1471 = (function()
		if node6 then
			local formatted1 = formatNode1(node6)
			if (previous2 == nil) then
				print1(colored1(96, _2e2e_2("  => ", formatted1)))
			elseif (previous2 ~= formatted1) then
				print1(_2e2e_2("  in ", formatted1))
			else
			end
			previous2 = formatted1
			node6 = node6["parent"]
			return r_1471()
		else
		end
	end)
	return r_1471()
end)
return struct1("create", create1, "colored", colored1)
