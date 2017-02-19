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
type_23_1 = _libs["lib/lua/basic/type#"]
_23_1 = (function(x1)
	return x1["n"]
end)
concat1 = _libs["lib/lua/table/concat"]
remove1 = _libs["lib/lua/table/remove"]
emptyStruct1 = _libs["lib/lua/table/empty-struct"]
iterPairs1 = _libs["lib/lua/table/iter-pairs"]
car1 = (function(xs1)
	return xs1[1]
end)
_21_1 = (function(expr1)
	if expr1 then
		return false
	else
		return true
	end
end)
sub1 = _libs["lib/lua/string/sub"]
list_3f_1 = (function(x2)
	return (type1(x2) == "list")
end)
symbol_3f_1 = (function(x3)
	return (type1(x3) == "symbol")
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
nth1 = rawget1
pushCdr_21_1 = (function(xs2, val2)
	local len1 = (_23_1(xs2) + 1)
	xs2["n"] = len1
	xs2[len1] = val2
	return xs2
end)
removeNth_21_1 = (function(li1, idx1)
	li1["n"] = (li1["n"] - 1)
	return remove1(li1, idx1)
end)
_2e2e_1 = (function(...)
	local args1 = _pack(...) args1.tag = "list"
	return concat1(args1)
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
succ1 = (function(x5)
	return (x5 + 1)
end)
pred1 = (function(x6)
	return (x6 - 1)
end)
error_21_1 = error1
fail_21_1 = (function(x7)
	return error_21_1(x7, 0)
end)
builtins1 = require1("tacky.analysis.resolve")["builtins"]
visitQuote1 = (function(node1, visitor1, level1)
	if (level1 == 0) then
		return visitNode1(node1, visitor1)
	else
		local tag2 = node1["tag"]
		local _temp
		local r_661 = (tag2 == "string")
		if r_661 then
			_temp = r_661
		else
			local r_671 = (tag2 == "number")
			if r_671 then
				_temp = r_671
			else
				local r_681 = (tag2 == "key")
				if r_681 then
					_temp = r_681
				else
					_temp = (tag2 == "symbol")
				end
			end
		end
		if _temp then
			return nil
		elseif (tag2 == "list") then
			local first1 = nth1(node1, 1)
			local _temp
			local r_691 = first1
			if r_691 then
				_temp = (first1["tag"] == "symbol")
			else
				_temp = r_691
			end
			if _temp then
				local _temp
				local r_701 = (first1["contents"] == "unquote")
				if r_701 then
					_temp = r_701
				else
					_temp = (first1["contents"] == "unquote-splice")
				end
				if _temp then
					return visitQuote1(nth1(node1, 2), visitor1, pred1(level1))
				elseif (first1["contents"] == "quasiquote") then
					return visitQuote1(nth1(node1, 2), visitor1, succ1(level1))
				else
					local r_721 = node1
					local r_751 = _23_1(r_721)
					local r_761 = 1
					local r_731 = nil
					r_731 = (function(r_741)
						local _temp
						if (0 < 1) then
							_temp = (r_741 <= r_751)
						else
							_temp = (r_741 >= r_751)
						end
						if _temp then
							local r_711 = r_741
							local sub2 = r_721[r_711]
							visitQuote1(sub2, visitor1, level1)
							return r_731((r_741 + r_761))
						else
						end
					end)
					return r_731(1)
				end
			else
				local r_781 = node1
				local r_811 = _23_1(r_781)
				local r_821 = 1
				local r_791 = nil
				r_791 = (function(r_801)
					local _temp
					if (0 < 1) then
						_temp = (r_801 <= r_811)
					else
						_temp = (r_801 >= r_811)
					end
					if _temp then
						local r_771 = r_801
						local sub3 = r_781[r_771]
						visitQuote1(sub3, visitor1, level1)
						return r_791((r_801 + r_821))
					else
					end
				end)
				return r_791(1)
			end
		elseif error_21_1 then
			return _2e2e_1("Unknown tag ", tag2)
		else
			_error("unmatched item")
		end
	end
end)
visitNode1 = (function(node2, visitor2)
	if (visitor2(node2) == false) then
	else
		local tag3 = node2["tag"]
		local _temp
		local r_831 = (tag3 == "string")
		if r_831 then
			_temp = r_831
		else
			local r_841 = (tag3 == "number")
			if r_841 then
				_temp = r_841
			else
				local r_851 = (tag3 == "key")
				if r_851 then
					_temp = r_851
				else
					_temp = (tag3 == "symbol")
				end
			end
		end
		if _temp then
			return nil
		elseif (tag3 == "list") then
			local first2 = nth1(node2, 1)
			local _temp
			local r_861 = first2
			if r_861 then
				_temp = (first2["tag"] == "symbol")
			else
				_temp = r_861
			end
			if _temp then
				local func1 = first2["var"]
				local funct1 = func1["tag"]
				if (func1 == builtins1["lambda"]) then
					return visitBlock1(node2, 3, visitor2)
				elseif (func1 == builtins1["cond"]) then
					local r_891 = _23_1(node2)
					local r_901 = 1
					local r_871 = nil
					r_871 = (function(r_881)
						local _temp
						if (0 < 1) then
							_temp = (r_881 <= r_891)
						else
							_temp = (r_881 >= r_891)
						end
						if _temp then
							local i2 = r_881
							local case1 = nth1(node2, i2)
							visitNode1(nth1(case1, 1), visitor2)
							visitBlock1(case1, 2, visitor2)
							return r_871((r_881 + r_901))
						else
						end
					end)
					return r_871(2)
				elseif (func1 == builtins1["set!"]) then
					return visitNode1(nth1(node2, 3), visitor2)
				elseif (func1 == builtins1["quote"]) then
				elseif (func1 == builtins1["quasiquote"]) then
					return visitQuote1(nth1(node2, 2), visitor2, 1)
				else
					local _temp
					local r_911 = (func1 == builtins1["unquote"])
					if r_911 then
						_temp = r_911
					else
						_temp = (func1 == builtins1["unquote-splice"])
					end
					if _temp then
						return fail_21_1("unquote/unquote-splice should never appear head")
					else
						local _temp
						local r_921 = (func1 == builtins1["define"])
						if r_921 then
							_temp = r_921
						else
							_temp = (func1 == builtins1["define-macro"])
						end
						if _temp then
							return visitBlock1(node2, 3, visitor2)
						elseif (func1 == builtins1["define-native"]) then
						elseif (func1 == builtins1["import"]) then
						elseif (funct1 == "macro") then
							return fail_21_1("Macros should have been expanded")
						else
							local _temp
							local r_931 = (funct1 == "defined")
							if r_931 then
								_temp = r_931
							else
								local r_941 = (funct1 == "arg")
								if r_941 then
									_temp = r_941
								else
									_temp = (funct1 == "native")
								end
							end
							if _temp then
								return visitBlock1(node2, 1, visitor2)
							else
								return fail_21_1(_2e2e_1("Unknown kind ", funct1, " for variable ", func1["name"]))
							end
						end
					end
				end
			else
				return visitBlock1(node2, 1, visitor2)
			end
		else
			return error_21_1(_2e2e_1("Unknown tag ", tag3))
		end
	end
end)
visitBlock1 = (function(node3, start1, visitor3)
	local r_641 = _23_1(node3)
	local r_651 = 1
	local r_621 = nil
	r_621 = (function(r_631)
		local _temp
		if (0 < 1) then
			_temp = (r_631 <= r_641)
		else
			_temp = (r_631 >= r_641)
		end
		if _temp then
			local i3 = r_631
			visitNode1(nth1(node3, i3), visitor3)
			return r_621((r_631 + r_651))
		else
		end
	end)
	return r_621(start1)
end)
struct1("visitNode", visitNode1, "visitBlock", visitBlock1, "visitList", visitBlock1)
builtins2 = require1("tacky.analysis.resolve")["builtins"]
createState1 = (function()
	return struct1("vars", emptyStruct1(), "nodes", emptyStruct1())
end)
getVar1 = (function(state1, var1)
	local entry1 = state1["vars"][var1]
	if entry1 then
	else
		entry1 = struct1("var", var1, "usages", struct1(), "defs", struct1(), "active", false)
		state1["vars"][var1] = entry1
	end
	return entry1
end)
getNode1 = (function(state2, node4)
	local entry2 = state2["nodes"][node4]
	if entry2 then
	else
		entry2 = struct1("uses", {tag = "list", n =0})
		state2["nodes"][node4] = entry2
	end
	return entry2
end)
addUsage_21_1 = (function(state3, var2, node5)
	local varMeta1 = getVar1(state3, var2)
	local nodeMeta1 = getNode1(state3, node5)
	varMeta1["usages"][node5] = true
	varMeta1["active"] = true
	nodeMeta1["uses"][var2] = true
	return nil
end)
addDefinition_21_1 = (function(state4, var3, node6, kind1, value1)
	local varMeta2 = getVar1(state4, var3)
	if value1 then
		local nodeMeta2 = getNode1(state4, value1)
		if nodeMeta2["definesr"] then
			error_21_1("Value defines multiple variables")
		else
		end
		nodeMeta2["defines"] = var3
	else
	end
	varMeta2["defs"][node6] = struct1("tag", kind1, "value", value1)
	return nil
end)
definitionsVisitor1 = (function(state5, node7)
	local _temp
	local r_951 = list_3f_1(node7)
	if r_951 then
		local r_961 = (_23_1(node7) > 0)
		if r_961 then
			_temp = symbol_3f_1(car1(node7))
		else
			_temp = r_961
		end
	else
		_temp = r_951
	end
	if _temp then
		local func2 = car1(node7)["var"]
		if (func2 == builtins2["lambda"]) then
			local r_981 = nth1(node7, 2)
			local r_1011 = _23_1(r_981)
			local r_1021 = 1
			local r_991 = nil
			r_991 = (function(r_1001)
				local _temp
				if (0 < 1) then
					_temp = (r_1001 <= r_1011)
				else
					_temp = (r_1001 >= r_1011)
				end
				if _temp then
					local r_971 = r_1001
					local arg1 = r_981[r_971]
					addDefinition_21_1(state5, arg1["var"], arg1, "arg", arg1)
					return r_991((r_1001 + r_1021))
				else
				end
			end)
			return r_991(1)
		elseif (func2 == builtins2["set!"]) then
			return addDefinition_21_1(state5, node7[2]["var"], node7, "set", nth1(node7, 3))
		else
			local _temp
			local r_1031 = (func2 == builtins2["define"])
			if r_1031 then
				_temp = r_1031
			else
				_temp = (func2 == builtins2["define-macro"])
			end
			if _temp then
				return addDefinition_21_1(state5, node7["defVar"], node7, "define", nth1(node7, 3))
			elseif (func2 == builtins2["define-native"]) then
				return addDefinition_21_1(state5, node7["defVar"], node7, "native")
			else
			end
		end
	else
	end
end)
definitionsVisit1 = (function(state6, nodes1)
	return visitBlock1(nodes1, 1, (function(r_1111)
		return definitionsVisitor1(state6, r_1111)
	end))
end)
usagesVisit1 = (function(state7, nodes2, pred2)
	if pred2 then
	else
		pred2 = (function()
			return true
		end)
	end
	local queue1 = {tag = "list", n =0}
	local visited1 = emptyStruct1()
	local addUsage1 = (function(var4, user1)
		addUsage_21_1(state7, var4, user1)
		local varMeta3 = getVar1(state7, var4)
		if varMeta3["active"] then
			return iterPairs1(varMeta3["defs"], (function(_5f_1, def1)
				local val4 = def1["value"]
				local _temp
				local r_1161 = val4
				if r_1161 then
					_temp = _21_1(visited1[val4])
				else
					_temp = r_1161
				end
				if _temp then
					return pushCdr_21_1(queue1, val4)
				else
				end
			end))
		else
		end
	end)
	local visit1 = (function(node8)
		if visited1[node8] then
			return false
		else
			visited1[node8] = true
			if symbol_3f_1(node8) then
				addUsage1(node8["var"], node8)
				return true
			else
				local _temp
				local r_1121 = list_3f_1(node8)
				if r_1121 then
					local r_1131 = (_23_1(node8) > 0)
					if r_1131 then
						_temp = symbol_3f_1(car1(node8))
					else
						_temp = r_1131
					end
				else
					_temp = r_1121
				end
				if _temp then
					local func3 = car1(node8)["var"]
					local _temp
					local r_1141 = (func3 == builtins2["set!"])
					if r_1141 then
						_temp = r_1141
					else
						local r_1151 = (func3 == builtins2["define"])
						if r_1151 then
							_temp = r_1151
						else
							_temp = (func3 == builtins2["define-macro"])
						end
					end
					if _temp then
						if pred2(nth1(node8, 3)) then
							return true
						else
							return false
						end
					else
						return true
					end
				else
					return true
				end
			end
		end
	end)
	local r_1051 = nodes2
	local r_1081 = _23_1(r_1051)
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
			local r_1041 = r_1071
			local node9 = r_1051[r_1041]
			pushCdr_21_1(queue1, node9)
			return r_1061((r_1071 + r_1091))
		else
		end
	end)
	r_1061(1)
	local r_1101 = nil
	r_1101 = (function()
		if (_23_1(queue1) > 0) then
			visitNode1(removeNth_21_1(queue1, 1), visit1)
			return r_1101()
		else
		end
	end)
	return r_1101()
end)
builtins3 = require1("tacky.analysis.resolve")["builtins"]
builtinVars1 = require1("tacky.analysis.resolve")["declaredVars"]
hasSideEffect1 = (function(node10)
	local tag4 = type1(node10)
	local _temp
	local r_541 = (tag4 == "number")
	if r_541 then
		_temp = r_541
	else
		local r_551 = (tag4 == "string")
		if r_551 then
			_temp = r_551
		else
			local r_561 = (tag4 == "key")
			if r_561 then
				_temp = r_561
			else
				_temp = (tag4 == "symbol")
			end
		end
	end
	if _temp then
		return false
	elseif (tag4 == "list") then
		local fst1 = car1(node10)
		if (type1(fst1) == "symbol") then
			local var5 = fst1["var"]
			local r_571 = (var5 ~= builtins3["lambda"])
			if r_571 then
				return (var5 ~= builtins3["quote"])
			else
				return r_571
			end
		else
			return true
		end
	else
		_error("unmatched item")
	end
end)
optimise1 = (function(nodes3)
	local r_601 = 1
	local r_611 = -1
	local r_581 = nil
	r_581 = (function(r_591)
		local _temp
		if (0 < -1) then
			_temp = (r_591 <= r_601)
		else
			_temp = (r_591 >= r_601)
		end
		if _temp then
			local i4 = r_591
			local node11 = nth1(nodes3, i4)
			local _temp
			local r_1171 = list_3f_1(node11)
			if r_1171 then
				local r_1181 = (_23_1(node11) > 0)
				if r_1181 then
					local r_1191 = symbol_3f_1(car1(node11))
					if r_1191 then
						_temp = (car1(node11)["var"] == builtins3["import"])
					else
						_temp = r_1191
					end
				else
					_temp = r_1181
				end
			else
				_temp = r_1171
			end
			if _temp then
				if (i4 == _23_1(nodes3)) then
					nodes3[i4] = struct1("tag", "symbol", "contents", "nil", "var", builtinVars1["nil"])
				else
					removeNth_21_1(nodes3, i4)
				end
			else
			end
			return r_581((r_591 + r_611))
		else
		end
	end)
	r_581(_23_1(nodes3))
	local r_1221 = 1
	local r_1231 = -1
	local r_1201 = nil
	r_1201 = (function(r_1211)
		local _temp
		if (0 < -1) then
			_temp = (r_1211 <= r_1221)
		else
			_temp = (r_1211 >= r_1221)
		end
		if _temp then
			local i5 = r_1211
			local node12 = nth1(nodes3, i5)
			if _21_1(hasSideEffect1(node12)) then
				removeNth_21_1(nodes3, i5)
			else
			end
			return r_1201((r_1211 + r_1231))
		else
		end
	end)
	r_1201(pred1(_23_1(nodes3)))
	local lookup1 = createState1()
	definitionsVisit1(lookup1, nodes3)
	usagesVisit1(lookup1, nodes3, hasSideEffect1)
	local r_1261 = 1
	local r_1271 = -1
	local r_1241 = nil
	r_1241 = (function(r_1251)
		local _temp
		if (0 < -1) then
			_temp = (r_1251 <= r_1261)
		else
			_temp = (r_1251 >= r_1261)
		end
		if _temp then
			local i6 = r_1251
			local node13 = nth1(nodes3, i6)
			local _temp
			local r_1281 = node13["defVar"]
			if r_1281 then
				_temp = _21_1(getVar1(lookup1, node13["defVar"])["active"])
			else
				_temp = r_1281
			end
			if _temp then
				if (i6 == _23_1(nodes3)) then
					nodes3[i6] = struct1("tag", "symbol", "contents", "nil", "var", builtinVars1["nil"])
				else
					removeNth_21_1(nodes3, i6)
				end
			else
			end
			return r_1241((r_1251 + r_1271))
		else
		end
	end)
	r_1241(_23_1(nodes3))
	return nodes3
end)
return optimise1
