table.pack = function(...) return { n = select("#", ...), ... } end
table.unpack = unpack
local function load(x, _, _, env) local f, e = loadstring(x); if not f then error(e, 1) end; return setfenv(f, env) end
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


		['gensym'] = function(name)

			if name then

				name = "_" .. tostring(name)

			else

				name = ""

			end


			randCtr = randCtr + 1

			return { tag = "symbol", contents = ("r_%d%s"):format(randCtr, name) }

		end,

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

_3d_1 = _libs["="]
_2f3d_1 = _libs["/="]
_3c_1 = _libs["<"]
_3c3d_1 = _libs["<="]
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
_23_1 = (function(xs1)
	return xs1["n"]
end);
key_3f_1 = (function(x5)
	return (type1(x5) == "key")
end);
type1 = (function(val1)
	local ty2
	ty2 = type_23_1(val1)
	if (ty2 == "table") then
		local tag1
		tag1 = val1["tag"]
		if tag1 then
			return tag1
		else
			return "table"
		end
	else
		return ty2
	end
end);
nth1 = (function(li4, idx1)
	local r_51
	r_51 = type1(li4)
	if (r_51 ~= "list") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_51), 2)
	else
	end
	local r_201
	r_201 = type1(idx1)
	if (r_201 ~= "number") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "idx", "number", r_201), 2)
	else
	end
	return li4[idx1]
end);
_23_2 = (function(li5)
	local r_81
	r_81 = type1(li5)
	if (r_81 ~= "list") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_81), 2)
	else
	end
	return _23_1(li5)
end);
sub1 = _libs["sub"]
struct1 = (function(...)
	local keys2 = table.pack(...) keys2.tag = "list"
	if ((_23_2(keys2) % 1) == 1) then
		error_21_1("Expected an even number of arguments to struct", 2)
	else
	end
	local contents1, out2
	contents1 = (function(key2)
		return sub1(key2["contents"], 2)
	end);
	out2 = {}
	local r_621
	r_621 = _23_1(keys2)
	local r_631
	r_631 = 2
	local r_601
	r_601 = nil
	r_601 = (function(r_611)
		local _temp
		if (0 < 2) then
			_temp = (r_611 <= r_621)
		else
			_temp = (r_611 >= r_621)
		end
		if _temp then
			local i2
			i2 = r_611
			local key3, val2
			key3 = keys2[i2]
			val2 = keys2[(1 + i2)]
			out2[(function()
				if key_3f_1(key3) then
					return contents1(key3)
				else
					return key3
				end
			end)()] = val2
			return r_601((r_611 + r_631))
		else
		end
	end);
	r_601(1)
	return out2
end);
fail1 = (function(msg1)
	return error_21_1(msg1, 0)
end);
succ1 = (function(x6)
	return (1 + x6)
end);
pred1 = (function(x7)
	return (x7 - 1)
end);
builtins1 = require1("tacky.analysis.resolve")["builtins"]
visitQuote1 = (function(node1, visitor1, level1)
	if (level1 == 0) then
		return visitNode1(node1, visitor1)
	else
		local tag2
		tag2 = node1["tag"]
		local _temp
		local r_951
		r_951 = (tag2 == "string")
		if r_951 then
			_temp = r_951
		else
			local r_961
			r_961 = (tag2 == "number")
			if r_961 then
				_temp = r_961
			else
				local r_971
				r_971 = (tag2 == "key")
				if r_971 then
					_temp = r_971
				else
					_temp = (tag2 == "symbol")
				end
			end
		end
		if _temp then
			return nil
		elseif (tag2 == "list") then
			local first1
			first1 = nth1(node1, 1)
			local _temp
			local r_981
			r_981 = first1
			if r_981 then
				_temp = (first1["tag"] == "symbol")
			else
				_temp = r_981
			end
			if _temp then
				local _temp
				local r_991
				r_991 = (first1["contents"] == "unquote")
				if r_991 then
					_temp = r_991
				else
					_temp = (first1["contents"] == "unquote-splice")
				end
				if _temp then
					return visitQuote1(nth1(node1, 2), visitor1, pred1(level1))
				elseif (first1["contents"] == "quasiquote") then
					return visitQuote1(nth1(node1, 2), visitor1(), succ1(level1))
				else
					local r_1011
					r_1011 = node1
					local r_1041
					r_1041 = _23_2(r_1011)
					local r_1051
					r_1051 = 1
					local r_1021
					r_1021 = nil
					r_1021 = (function(r_1031)
						local _temp
						if (0 < 1) then
							_temp = (r_1031 <= r_1041)
						else
							_temp = (r_1031 >= r_1041)
						end
						if _temp then
							local r_1001
							r_1001 = r_1031
							local sub2
							sub2 = r_1011[r_1001]
							visitQuote1(sub2, visitor1, level1)
							return r_1021((r_1031 + r_1051))
						else
						end
					end);
					return r_1021(1)
				end
			else
				local r_1071
				r_1071 = node1
				local r_1101
				r_1101 = _23_2(r_1071)
				local r_1111
				r_1111 = 1
				local r_1081
				r_1081 = nil
				r_1081 = (function(r_1091)
					local _temp
					if (0 < 1) then
						_temp = (r_1091 <= r_1101)
					else
						_temp = (r_1091 >= r_1101)
					end
					if _temp then
						local r_1061
						r_1061 = r_1091
						local sub3
						sub3 = r_1071[r_1061]
						visitQuote1(sub3, visitor1, level1)
						return r_1081((r_1091 + r_1111))
					else
					end
				end);
				return r_1081(1)
			end
		elseif error_21_1 then
			return ("Unknown tag " .. tag2)
		else
			error('unmatched item')
		end
	end
end);
visitNode1 = (function(node2, visitor2)
	if (visitor2(node2) == false) then
	else
		local tag3
		tag3 = node2["tag"]
		local _temp
		local r_1121
		r_1121 = (tag3 == "string")
		if r_1121 then
			_temp = r_1121
		else
			local r_1131
			r_1131 = (tag3 == "number")
			if r_1131 then
				_temp = r_1131
			else
				local r_1141
				r_1141 = (tag3 == "key")
				if r_1141 then
					_temp = r_1141
				else
					_temp = (tag3 == "symbol")
				end
			end
		end
		if _temp then
			return nil
		elseif (tag3 == "list") then
			local first2
			first2 = nth1(node2, 1)
			local _temp
			local r_1151
			r_1151 = first2
			if r_1151 then
				_temp = (first2["tag"] == "symbol")
			else
				_temp = r_1151
			end
			if _temp then
				local func1
				func1 = first2["var"]
				local funct1
				funct1 = func1["tag"]
				if (func1 == builtins1["lambda"]) then
					return visitBlock1(node2, 3, visitor2)
				elseif (func1 == builtins1["cond"]) then
					local r_1181
					r_1181 = _23_2(node2)
					local r_1191
					r_1191 = 1
					local r_1161
					r_1161 = nil
					r_1161 = (function(r_1171)
						local _temp
						if (0 < 1) then
							_temp = (r_1171 <= r_1181)
						else
							_temp = (r_1171 >= r_1181)
						end
						if _temp then
							local i3
							i3 = r_1171
							local case1
							case1 = nth1(node2, i3)
							visitNode1(nth1(case1, 1), visitor2)
							visitBlock1(case1, 2, visitor2)
							return r_1161((r_1171 + r_1191))
						else
						end
					end);
					return r_1161(2)
				elseif (func1 == builtins1["set!"]) then
					return visitNode1(nth1(node2, 3), visitor2)
				elseif (func1 == builtins1["quote"]) then
				elseif (func1 == builtins1["quasiquote"]) then
					return visitQuote1(nth1(node2, 2), visitor2, 1)
				else
					local _temp
					local r_1201
					r_1201 = (func1 == builtins1["unquote"])
					if r_1201 then
						_temp = r_1201
					else
						_temp = (func1 == builtins1["unquote-splice"])
					end
					if _temp then
						return fail1("unquote/unquote-splice should never appear head")
					else
						local _temp
						local r_1211
						r_1211 = (func1 == builtins1["define"])
						if r_1211 then
							_temp = r_1211
						else
							_temp = (func1 == builtins1["define-macro"])
						end
						if _temp then
							return visitBlock1(node2, 3, visitor2)
						elseif (func1 == builtins1["define-native"]) then
						elseif (func1 == builtins1["import"]) then
						elseif (funct1 == "macro") then
							return fail1("Macros should have been expanded")
						else
							local _temp
							local r_1221
							r_1221 = (funct1 == "defined")
							if r_1221 then
								_temp = r_1221
							else
								local r_1231
								r_1231 = (funct1 == "arg")
								if r_1231 then
									_temp = r_1231
								else
									_temp = (funct1 == "native")
								end
							end
							if _temp then
								return visitBlock1(node2, 1, visitor2)
							else
								return fail1(_2e2e_1("Unknown kind ", func1, " for variable ", func1["name"]))
							end
						end
					end
				end
			else
				return visitBlock1(node2, 1, visitor2)
			end
		elseif error_21_1 then
			return ("Unknown tag " .. tag3)
		else
			error('unmatched item')
		end
	end
end);
visitBlock1 = (function(node3, start3, visitor3)
	local r_931
	r_931 = _23_2(node3)
	local r_941
	r_941 = 1
	local r_911
	r_911 = nil
	r_911 = (function(r_921)
		local _temp
		if (0 < 1) then
			_temp = (r_921 <= r_931)
		else
			_temp = (r_921 >= r_931)
		end
		if _temp then
			local i4
			i4 = r_921
			visitNode1(nth1(node3, i4), visitor3)
			return r_911((r_921 + r_941))
		else
		end
	end);
	return r_911(start3)
end);
return struct1("visitNode", visitNode1, "visitBlock", visitBlock1, "visitList", visitBlock1)
