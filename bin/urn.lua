#!/usr/bin/env lua
if not table.pack then table.pack = function(...) return { n = select("#", ...), ... } end end
if not table.unpack then table.unpack = unpack end
local load = load if _VERSION:find("5.1") then load = function(x, n, _, env) local f, e = loadstring(x, n) if not f then return f, e end if env then setfenv(f, env) end return f end end
local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error
local _libs = {}
local _2a_arguments_2a_1, _2b_1, _2d_1, _2e2e_1, _2f3d_1, _3c3d_1, _3c_1, _3d_1, _3e3d_1, _3e_1, addArgument_21_1, addParen1, any1, append_21_1, apply1, beginBlock_21_1, between_3f_1, builtin_3f_1, builtins1, caar1, cadr1, car1, child1, coloured1, compileBlock1, compileExpression1, concat2, constVal1, demandFailure1, display1, doNodeError_21_1, empty_3f_1, endBlock_21_1, error1, errorPositions_21_1, escapeVar1, exit_21_1, expectType_21_1, expect_21_1, find1, format1, formatOutput_21_1, getIdx1, getVar1, getenv1, getinfo1, gsub1, huge1, last1, len_23_1, lex1, line_21_1, list1, lookup1, lower1, makeNil1, map2, match1, min1, n1, next1, nth1, number_3f_1, open1, pcall1, pretty1, print1, pushEscapeVar_21_1, push_21_1, putNodeWarning_21_1, quoted1, removeNth_21_1, require1, resolveNode1, runPass1, scoreNodes1, self1, setIdx_21_1, sethook1, slice1, sort1, sourceRange1, splice1, split1, string_3f_1, sub1, symbol_2d3e_string1, tonumber1, tostring1, type1, type_23_1, unmangleIdent1, usage_21_1, varNative1, visitBlock1, visitNode1, visitNode2, visitNode3, visitNodes2, zipArgs1
local _ENV = setmetatable({}, {__index=_ENV or (getfenv and getfenv()) or _G}) if setfenv then setfenv(0, _ENV) end
_3d_1 = function(v1, v2) return v1 == v2 end
_2f3d_1 = function(v1, v2) return v1 ~= v2 end
_3c_1 = function(v1, v2) return v1 < v2 end
_3c3d_1 = function(v1, v2) return v1 <= v2 end
_3e_1 = function(v1, v2) return v1 > v2 end
_3e3d_1 = function(v1, v2) return v1 >= v2 end
_2b_1 = function(x, ...) local t = x + ... for i = 2, _select('#', ...) do t = t + _select(i, ...) end return t end
_2d_1 = function(x, ...) local t = x - ... for i = 2, _select('#', ...) do t = t - _select(i, ...) end return t end
_2a_1 = function(x, ...) local t = x * ... for i = 2, _select('#', ...) do t = t * _select(i, ...) end return t end
_2f_1 = function(x, ...) local t = x / ... for i = 2, _select('#', ...) do t = t / _select(i, ...) end return t end
mod1 = function(x, ...) local t = x % ... for i = 2, _select('#', ...) do t = t % _select(i, ...) end return t end
expt1 = function(x, ...) local n = _select('#', ...) local t = _select(n, ...) for i = n - 1, 1, -1 do t = _select(i, ...) ^ t end return x ^ t end
_2e2e_1 = function(x, ...) local n = _select('#', ...) local t = _select(n, ...) for i = n - 1, 1, -1 do t = _select(i, ...) .. t end return x .. t end
len_23_1 = function(v1) return #v1 end
getIdx1 = function(v1, v2) return v1[v2] end
setIdx_21_1 = function(v1, v2, v3) v1[v2] = v3 end
_5f_G1 = _G
arg_23_1 = arg or {...}
error1 = error
getmetatable1 = getmetatable
load1 = load
next1 = next
pcall1 = pcall
print1 = print
require1 = require
setmetatable1 = setmetatable
tonumber1 = tonumber
tostring1 = tostring
type_23_1 = type
xpcall1 = xpcall
byte1 = string.byte
char1 = string.char
find1 = string.find
format1 = string.format
gsub1 = string.gsub
lower1 = string.lower
match1 = string.match
rep1 = string.rep
reverse1 = string.reverse
sub1 = string.sub
upper1 = string.upper
concat1 = table.concat
insert1 = table.insert
remove1 = table.remove
sort1 = table.sort
unpack1 = table.unpack
n1 = function(x)
  if type_23_1(x) == "table" then
    return x["n"]
  else
    return #x
  end
end
slice1 = function(xs, start, finish)
  if not finish then
    finish = xs["n"]
    if not finish then
      finish = #xs
    end
  end
  local len, _ = (finish - start) + 1
  if len < 0 then
    len = 0
  end
  local out, i, j = {tag="list", n=len}, 1, start
  while j <= finish do
    out[i] = xs[j]
    i, j = i + 1, j + 1
  end
  return out
end
list1 = function(...)
  local xs = _pack(...) xs.tag = "list"
  return xs
end
if nil == arg_23_1 then
  _2a_arguments_2a_1 = {tag="list", n=0}
else
  arg_23_1["tag"] = "list"
  if not arg_23_1["n"] then
    arg_23_1["n"] = #arg_23_1
  end
  _2a_arguments_2a_1 = arg_23_1
end
constVal1 = function(val)
  if type_23_1(val) == "table" then
    local tag = val["tag"]
    if tag == "number" then
      return val["value"]
    elseif tag == "string" then
      return val["value"]
    else
      return val
    end
  else
    return val
  end
end
splice1 = function(xs)
  local parent = xs["parent"]
  if parent then
    return unpack1(parent, xs["offset"] + 1, xs["n"] + xs["offset"])
  else
    return unpack1(xs, 1, xs["n"])
  end
end
apply1 = function(f, ...)
  local _n = _select("#", ...) - 1
  local xss, xs
  if _n > 0 then
    xss = {tag="list", n=_n, _unpack(_pack(...), 1, _n)}
    xs = select(_n + 1, ...)
  else
    xss = {tag="list", n=0}
    xs = ...
  end
  return f(splice1((function()
    local _offset, _result, _temp = 0, {tag="list"}
    _temp = xss
    for _c = 1, _temp.n do _result[0 + _c + _offset] = _temp[_c] end
    _offset = _offset + _temp.n
    _temp = xs
    for _c = 1, _temp.n do _result[0 + _c + _offset] = _temp[_c] end
    _offset = _offset + _temp.n
    _result.n = _offset + 0
    return _result
  end)()
  ))
end
first1 = function(...)
  local rest = _pack(...) rest.tag = "list"
  return rest[1]
end
empty_3f_1 = function(x)
  local xt = type1(x)
  if xt == "list" then
    return x["n"] == 0
  elseif xt == "string" then
    return #x == 0
  else
    return false
  end
end
string_3f_1 = function(x)
  return type_23_1(x) == "string" or type_23_1(x) == "table" and x["tag"] == "string"
end
number_3f_1 = function(x)
  return type_23_1(x) == "number" or type_23_1(x) == "table" and x["tag"] == "number"
end
function_3f_1 = function(x)
  return type1(x) == "function" or type1(x) == "multimethod"
end
atom_3f_1 = function(x)
  local temp = type_23_1(x) ~= "table"
  if temp then
    return temp
  else
    local temp1 = type_23_1(x) == "table"
    if temp1 then
      local tag = x["tag"]
      return tag == "symbol" or (tag == "key" or (tag == "number" or tag == "string"))
    else
      return temp1
    end
  end
end
nil_3f_1 = function(x)
  return type_23_1(x) == "nil"
end
between_3f_1 = function(val, min, max)
  return val >= min and val <= max
end
type1 = function(val)
  local ty = type_23_1(val)
  if ty == "table" then
    return val["tag"] or "table"
  else
    return ty
  end
end
map1 = function(f, x)
  local out = {tag="list", n=0}
  local forLimit = n1(x)
  local i = 1
  while i <= forLimit do
    out[i] = f(x[i])
    i = i + 1
  end
  out["n"] = n1(x)
  return out
end
put_21_1 = function(t, typs, l)
  local len = n1(typs)
  local forLimit = len - 1
  local i = 1
  while i <= forLimit do
    local x = typs[i]
    local y = t[x]
    if not y then
      y = {}
      t[x] = y
    end
    t = y
    i = i + 1
  end
  t[typs[len]] = l
  return nil
end
neq_3f_1 = function(x, y)
  return not eq_3f_1(x, y)
end
local eq_3f_
local this = {lookup={list={list=function(x, y)
  if n1(x) ~= n1(y) then
    return false
  else
    local equal = true
    local forLimit = n1(x)
    local i = 1
    while i <= forLimit do
      if neq_3f_1(x[i], y[i]) then
        equal = false
      end
      i = i + 1
    end
    return equal
  end
end}, table={table=function(x, y)
  local equal = true
  local temp, v = next1(x)
  while temp ~= nil do
    if neq_3f_1(v, y[temp]) then
      equal = false
    end
    temp, v = next1(x, temp)
  end
  return equal
end}, symbol={symbol=function(x, y)
  return x["contents"] == y["contents"]
end, string=function(x, y)
  return x["contents"] == y
end}, string={symbol=function(x, y)
  return x == y["contents"]
end, key=function(x, y)
  return x == y["value"]
end, string=function(x, y)
  return constVal1(x) == constVal1(y)
end}, key={string=function(x, y)
  return x["value"] == y
end, key=function(x, y)
  return x["value"] == y["value"]
end}, number={number=function(x, y)
  return constVal1(x) == constVal1(y)
end}, rational={rational=function(x, y)
  local xn, xd = normalisedRationalComponents1(x)
  local yn, yd = normalisedRationalComponents1(y)
  return xn == yn and xd == yd
end}}, tag="multimethod", default=function(x, y)
  return false
end}
eq_3f_ = setmetatable1(this, {__call=function(this1, x, y)
  if x == y then
    return true
  else
    local method = (this["lookup"][type1(x)] or {})[type1(y)] or this["default"]
    if not method then
      error1("No matching method to call for (" .. concat1(list1("eq?", type1(x), type1(y)), " ") .. ")")
    end
    return method(x, y)
  end
end, name="eq?", args=list1("x", "y")})
put_21_1(eq_3f_, list1("lookup", "number", "rational"), (eq_3f_["lookup"]["rational"] or {})["rational"])
put_21_1(eq_3f_, list1("lookup", "rational", "number"), (eq_3f_["lookup"]["rational"] or {})["rational"])
eq_3f_1 = eq_3f_
local this = {lookup={list=function(xs)
  return "(" .. concat1(map1(pretty1, xs), " ") .. ")"
end, symbol=function(x)
  return x["contents"]
end, key=function(x)
  return ":" .. x["value"]
end, number=function(x)
  return format1("%g", constVal1(x))
end, string=function(x)
  return format1("%q", constVal1(x))
end, table=function(x)
  local out = {tag="list", n=0}
  local temp, v = next1(x)
  while temp ~= nil do
    local _offset, _result, _temp = 0, {tag="list"}
    _result[1 + _offset] = pretty1(temp) .. " " .. pretty1(v)
    _temp = out
    for _c = 1, _temp.n do _result[1 + _c + _offset] = _temp[_c] end
    _offset = _offset + _temp.n
    _result.n = _offset + 1
    out = _result
    temp, v = next1(x, temp)
  end
  return "{" .. (concat1(out, " ") .. "}")
end, multimethod=function(x)
  return "«method: (" .. getmetatable1(x)["name"] .. " " .. concat1(getmetatable1(x)["args"], " ") .. ")»"
end, ["demand-failure"]=function(failure)
  return demandFailure_2d3e_string1(failure)
end, rational=function(x)
  local xn, xd = normalisedRationalComponents1(x)
  return formatOutput_21_1(nil, "" .. format1("%d", xn) .. "/" .. format1("%d", xd))
end, var=function(var)
  return "«var : " .. var["name"] .. "»"
end, position=function(pos)
  return pos["line"] .. ":" .. pos["column"]
end, range=function(range)
  return formatRange1(range)
end, ["node-source"]=function(source)
  return formatNodeSource1(source)
end}, tag="multimethod", default=function(x)
  if type_23_1(x) == "table" then
    return pretty1["lookup"]["table"](x)
  else
    return tostring1(x)
  end
end}
pretty1 = setmetatable1(this, {__call=function(this1, x)
  local method = this["lookup"][type1(x)] or this["default"]
  if not method then
    error1("No matching method to call for (" .. concat1(list1("pretty", type1(x)), " ") .. ")")
  end
  return method(x)
end, name="pretty", args=list1("x")})
gethook1 = debug and debug.gethook
getinfo1 = debug and debug.getinfo
sethook1 = debug and debug.sethook
traceback1 = debug and debug.traceback
demandFailure_2d3e_string1 = function(failure)
  if failure["message"] then
    return format1("demand not met: %s (%s).\n%s", failure["condition"], failure["message"], failure["traceback"])
  else
    return format1("demand not met: %s.\n%s", failure["condition"], failure["traceback"])
  end
end
_2a_demandFailureMt_2a_1 = {__tostring=demandFailure_2d3e_string1}
demandFailure1 = function(message, condition)
  return setmetatable1({tag="demand-failure", message=message, traceback=(function()
    if traceback1 then
      return traceback1("", 2)
    else
      return ""
    end
  end)(), condition=condition}, _2a_demandFailureMt_2a_1)
end
abs1 = math.abs
huge1 = math.huge
max1 = math.max
min1 = math.min
modf1 = math.modf
car1 = function(x)
  if type1(x) ~= "list" then
    error1(demandFailure1(nil, "(= (type x) \"list\")"))
  end
  return x[1]
end
local refMt = {__index=function(t, k)
  return t["parent"][k + t["offset"]]
end, __newindex=function(t, k, v)
  t["parent"][k + t["offset"]] = v
  return nil
end}
slicingView1 = function(list, offset)
  if n1(list) <= offset then
    return {tag="list", n=0}
  elseif list["parent"] and list["offset"] then
    return setmetatable1({parent=list["parent"], offset=list["offset"] + offset, n=n1(list) - offset, tag=type1(list)}, refMt)
  else
    return setmetatable1({parent=list, offset=offset, n=n1(list) - offset, tag=type1(list)}, refMt)
  end
end
cons1 = function(...)
  local _n = _select("#", ...) - 1
  local xs, xss
  if _n > 0 then
    xs = {tag="list", n=_n, _unpack(_pack(...), 1, _n)}
    xss = select(_n + 1, ...)
  else
    xs = {tag="list", n=0}
    xss = ...
  end
  local _offset, _result, _temp = 0, {tag="list"}
  _temp = xs
  for _c = 1, _temp.n do _result[0 + _c + _offset] = _temp[_c] end
  _offset = _offset + _temp.n
  _temp = xss
  for _c = 1, _temp.n do _result[0 + _c + _offset] = _temp[_c] end
  _offset = _offset + _temp.n
  _result.n = _offset + 0
  return _result
end
reduce1 = function(f, z, xs)
  if type1(f) ~= "function" then
    error1(demandFailure1(nil, "(= (type f) \"function\")"))
  end
  local start = 1
  if type_23_1(xs) == "nil" and type1(z) == "list" then
    start = 2
    xs = z
    z = car1(z)
  end
  if type1(xs) ~= "list" then
    error1(demandFailure1(nil, "(= (type xs) \"list\")"))
  end
  local accum = z
  local forStart, forLimit = start, n1(xs)
  local i = forStart
  while i <= forLimit do
    accum = f(accum, nth1(xs, i))
    i = i + 1
  end
  return accum
end
map2 = function(fn, ...)
  local xss = _pack(...) xss.tag = "list"
  local ns
  local out = {tag="list", n=0}
  local forLimit = n1(xss)
  local i = 1
  while i <= forLimit do
    if type1((nth1(xss, i))) ~= "list" then
      error1("that's no list! " .. pretty1(nth1(xss, i)) .. " (it's a " .. type1(nth1(xss, i)) .. "!)")
    end
    push_21_1(out, n1(nth1(xss, i)))
    i = i + 1
  end
  ns = out
  local out = {tag="list", n=0}
  local forLimit = apply1(min1, ns)
  local i = 1
  while i <= forLimit do
    push_21_1(out, apply1(fn, nths1(xss, i)))
    i = i + 1
  end
  return out
end
partition1 = function(p, xs)
  if type1(p) ~= "function" then
    error1(demandFailure1(nil, "(= (type p) \"function\")"))
  end
  if type1(xs) ~= "list" then
    error1(demandFailure1(nil, "(= (type xs) \"list\")"))
  end
  local passed, failed = {tag="list", n=0}, {tag="list", n=0}
  local forLimit = n1(xs)
  local i = 1
  while i <= forLimit do
    local x = nth1(xs, i)
    push_21_1((function()
      if p(x) then
        return passed
      else
        return failed
      end
    end)(), x)
    i = i + 1
  end
  return splice1(list1(passed, failed))
end
any1 = function(p, xs)
  if type1(p) ~= "function" then
    error1(demandFailure1(nil, "(= (type p) \"function\")"))
  end
  if type1(xs) ~= "list" then
    error1(demandFailure1(nil, "(= (type xs) \"list\")"))
  end
  local len = n1(xs)
  local i = 1
  while true do
    if i > len then
      return false
    elseif p(nth1(xs, i)) then
      return true
    else
      i = i + 1
    end
  end
end
nub1 = function(xs)
  local hm, out = {}, {tag="list", n=0}
  local forLimit = n1(xs)
  local i = 1
  while i <= forLimit do
    local elm = xs[i]
    local szd = pretty1(elm)
    if type_23_1((hm[szd])) == "nil" then
      push_21_1(out, elm)
      hm[szd] = elm
    end
    i = i + 1
  end
  return out
end
all1 = function(p, xs)
  if type1(p) ~= "function" then
    error1(demandFailure1(nil, "(= (type p) \"function\")"))
  end
  if type1(xs) ~= "list" then
    error1(demandFailure1(nil, "(= (type xs) \"list\")"))
  end
  local len = n1(xs)
  local i = 1
  while true do
    if i > len then
      return true
    elseif p(nth1(xs, i)) then
      i = i + 1
    else
      return false
    end
  end
end
elem_3f_1 = function(x, xs)
  if type1(xs) ~= "list" then
    error1(demandFailure1(nil, "(= (type xs) \"list\")"))
  end
  return any1(function(y)
    return eq_3f_1(x, y)
  end, xs)
end
findIndex1 = function(p, xs)
  if type1(p) ~= "function" then
    error1(demandFailure1(nil, "(= (type p) \"function\")"))
  end
  if type1(xs) ~= "list" then
    error1(demandFailure1(nil, "(= (type xs) \"list\")"))
  end
  local len = n1(xs)
  local i = 1
  while true do
    if i > len then
      return nil
    elseif p(nth1(xs, i)) then
      return i
    else
      i = i + 1
    end
  end
end
last1 = function(xs)
  if type1(xs) ~= "list" then
    error1(demandFailure1(nil, "(= (type xs) \"list\")"))
  end
  return xs[n1(xs)]
end
nth1 = function(xs, idx)
  if idx >= 0 then
    return xs[idx]
  else
    return xs[xs["n"] + 1 + idx]
  end
end
nths1 = function(xss, idx)
  local out = {tag="list", n=0}
  local forLimit = n1(xss)
  local i = 1
  while i <= forLimit do
    push_21_1(out, nth1(nth1(xss, i), idx))
    i = i + 1
  end
  return out
end
push_21_1 = function(xs, ...)
  local vals = _pack(...) vals.tag = "list"
  if type1(xs) ~= "list" then
    error1(demandFailure1(nil, "(= (type xs) \"list\")"))
  end
  local nxs = n1(xs)
  xs["n"] = (nxs + n1(vals))
  local forLimit = n1(vals)
  local i = 1
  while i <= forLimit do
    xs[nxs + i] = vals[i]
    i = i + 1
  end
  return xs
end
popLast_21_1 = function(xs)
  if type1(xs) ~= "list" then
    error1(demandFailure1(nil, "(= (type xs) \"list\")"))
  end
  local x = xs[n1(xs)]
  xs[n1(xs)] = nil
  xs["n"] = n1(xs) - 1
  return x
end
removeNth_21_1 = function(li, idx)
  if type1(li) ~= "list" then
    error1(demandFailure1(nil, "(= (type li) \"list\")"))
  end
  li["n"] = li["n"] - 1
  return remove1(li, idx)
end
insertNth_21_1 = function(li, idx, val)
  if type1(li) ~= "list" then
    error1(demandFailure1(nil, "(= (type li) \"list\")"))
  end
  li["n"] = li["n"] + 1
  return insert1(li, idx, val)
end
append1 = function(xs, ys)
  local _offset, _result, _temp = 0, {tag="list"}
  _temp = xs
  for _c = 1, _temp.n do _result[0 + _c + _offset] = _temp[_c] end
  _offset = _offset + _temp.n
  _temp = ys
  for _c = 1, _temp.n do _result[0 + _c + _offset] = _temp[_c] end
  _offset = _offset + _temp.n
  _result.n = _offset + 0
  return _result
end
range1 = function(...)
  local args = _pack(...) args.tag = "list"
  local x
  local out = {}
  if n1(args) % 2 == 1 then
    error1("Expected an even number of arguments to range", 2)
  end
  local forLimit = n1(args)
  local i = 1
  while i <= forLimit do
    out[args[i]] = args[i + 1]
    i = i + 2
  end
  x = out
  local st, ed = x["from"] or 1, 1 + x["to"] or error1("Expected end index, got nothing")
  local inc = (x["by"] or 1 + st) - st
  local tst
  if st >= ed then
    tst = _3e_1
  else
    tst = _3c_1
  end
  local c, out = st, {tag="list", n=0}
  while tst(c, ed) do
    push_21_1(out, c)
    c = c + inc
  end
  return out
end
sort2 = function(xs, f)
  local copy = map2(function(x)
    return x
  end, xs)
  sort1(copy, f)
  return copy
end
caar1 = function(xs)
  if type1(xs) ~= "list" then
    error1(demandFailure1(nil, "(= (type xs) \"list\")"))
  end
  return car1(xs[1])
end
caadr1 = function(xs)
  if type1(xs) ~= "list" then
    error1(demandFailure1(nil, "(= (type xs) \"list\")"))
  end
  return car1(xs[2])
end
cadr1 = function(xs)
  if type1(xs) ~= "list" then
    error1(demandFailure1(nil, "(= (type xs) \"list\")"))
  end
  return xs[2]
end
cadar1 = function(xs)
  if type1(xs) ~= "list" then
    error1(demandFailure1(nil, "(= (type xs) \"list\")"))
  end
  return cadr1(xs[1])
end
concat2 = function(xs, separator)
  if type1(xs) ~= "list" then
    error1(demandFailure1(nil, "(= (type xs) \"list\")"))
  end
  if xs["parent"] then
    return concat1(xs["parent"], separator, xs["offset"] + 1, xs["n"] + xs["offset"])
  else
    return concat1(xs, separator, 1, xs["n"])
  end
end
split1 = function(text, pattern, limit)
  local out, loop, start = {tag="list", n=0}, true, 1
  while loop do
    local pos = list1(find1(text, pattern, start))
    local nstart, nend = car1(pos), cadr1(pos)
    if nstart == nil or limit and n1(out) >= limit then
      loop = false
      push_21_1(out, sub1(text, start, n1(text)))
      start = n1(text) + 1
    elseif nstart > #text then
      if start <= #text then
        push_21_1(out, sub1(text, start, #text))
      end
      loop = false
    elseif nend < nstart then
      push_21_1(out, sub1(text, start, nstart))
      start = nstart + 1
    else
      push_21_1(out, sub1(text, start, nstart - 1))
      start = nend + 1
    end
  end
  return out
end
trim1 = function(str)
  return (gsub1(gsub1(str, "^%s+", ""), "%s+$", ""))
end
local escapes = {}
local i = 0
while i <= 31 do
  escapes[char1(i)] = "\\" .. tostring1(i)
  i = i + 1
end
escapes["\n"] = "n"
quoted1 = function(str)
  return (gsub1(format1("%q", str), ".", escapes))
end
endsWith_3f_1 = function(str, suffix)
  return sub1(str, 0 - #suffix) == suffix
end
symbol_2d3e_string1 = function(x)
  if type1(x) == "symbol" then
    return x["contents"]
  else
    return nil
  end
end
struct1 = function(...)
  local entries = _pack(...) entries.tag = "list"
  if n1(entries) % 2 == 1 then
    error1("Expected an even number of arguments to struct", 2)
  end
  local out = {}
  local forLimit = n1(entries)
  local i = 1
  while i <= forLimit do
    local key, val = entries[i], entries[1 + i]
    out[(function()
      if type1(key) == "key" then
        return key["value"]
      else
        return key
      end
    end)()] = val
    i = i + 2
  end
  return out
end
iterPairs1 = function(table, func)
  local temp, v = next1(table)
  while temp ~= nil do
    func(temp, v)
    temp, v = next1(table, temp)
  end
  return nil
end
copyOf1 = function(struct)
  local out = {}
  local temp, v = next1(struct)
  while temp ~= nil do
    out[temp] = v
    temp, v = next1(struct, temp)
  end
  return out
end
merge1 = function(...)
  local structs = _pack(...) structs.tag = "list"
  local out = {}
  local forLimit = n1(structs)
  local i = 1
  while i <= forLimit do
    local st = structs[i]
    local temp, v = next1(st)
    while temp ~= nil do
      out[temp] = v
      temp, v = next1(st, temp)
    end
    i = i + 1
  end
  return out
end
keys1 = function(st)
  local out = {tag="list", n=0}
  local temp, _5f_ = next1(st)
  while temp ~= nil do
    push_21_1(out, temp)
    temp, _5f_ = next1(st, temp)
  end
  return out
end
values1 = function(st)
  local out = {tag="list", n=0}
  local temp, v = next1(st)
  while temp ~= nil do
    push_21_1(out, v)
    temp, v = next1(st, temp)
  end
  return out
end
updateStruct1 = function(st, ...)
  local keys = _pack(...) keys.tag = "list"
  return merge1(st, apply1(struct1, keys))
end
createLookup1 = function(values)
  local res = {}
  local forLimit = n1(values)
  local i = 1
  while i <= forLimit do
    res[nth1(values, i)] = i
    i = i + 1
  end
  return res
end
clock1 = os.clock
execute1 = os.execute
exit1 = os.exit
getenv1 = os.getenv
flush1 = io.flush
open1 = io.open
read1 = io.read
write1 = io.write
exit_21_1 = function(reason, code)
  local code1
  if string_3f_1(reason) then
    code1 = code
  else
    code1 = reason
  end
  if exit1 then
    if string_3f_1(reason) then
      print1(reason)
    end
    return exit1(code1)
  elseif string_3f_1(reason) then
    return error1(reason, 0)
  else
    return error1(nil, 0)
  end
end
sprintf1 = function(fmt, ...)
  local args = _pack(...) args.tag = "list"
  return apply1(format1, fmt, args)
end
assoc1 = function(list, key, orVal)
  while true do
    if type1(list) ~= "list" or empty_3f_1(list) then
      return orVal
    elseif eq_3f_1(caar1(list), key) then
      return cadar1(list)
    else
      list = slicingView1(list, 1)
    end
  end
end
assoc_3f_1 = function(list, key)
  while true do
    if type1(list) ~= "list" or empty_3f_1(list) then
      return false
    elseif eq_3f_1(caar1(list), key) then
      return true
    else
      list = slicingView1(list, 1)
    end
  end
end
struct_2d3e_assoc1 = function(tbl)
  local out = {tag="list", n=0}
  local temp, v = next1(tbl)
  while temp ~= nil do
    push_21_1(out, list1(temp, v))
    temp, v = next1(tbl, temp)
  end
  return out
end
display1 = function(x)
  if type_23_1(x) == "string" then
    return x
  elseif type_23_1(x) == "table" and x["tag"] == "string" then
    return x["value"]
  else
    return pretty1(x)
  end
end
formatOutput_21_1 = function(out, buf)
  if out == nil then
    return buf
  elseif out == true then
    return print1(buf)
  elseif number_3f_1(out) then
    return error1(buf, out)
  elseif function_3f_1(out) then
    return out(buf)
  else
    return out["write"](out, buf)
  end
end
invokable_3f_1 = function(x)
  while true do
    local temp = function_3f_1(x)
    if temp then
      return temp
    else
      local temp1 = type_23_1(x) == "table"
      if temp1 then
        local temp2 = type_23_1((getmetatable1(x))) == "table"
        if temp2 then
          x = getmetatable1(x)["__call"]
        else
          return temp2
        end
      else
        return temp1
      end
    end
  end
end
compose1 = function(f, g)
  if invokable_3f_1(f) and invokable_3f_1(g) then
    return function(x)
      return f(g(x))
    end
  else
    return nil
  end
end
comp1 = function(...)
  local fs = _pack(...) fs.tag = "list"
  return reduce1(compose1, function(x)
    return x
  end, fs)
end
id1 = function(x)
  return x
end
call1 = function(x, key, ...)
  local args = _pack(...) args.tag = "list"
  return apply1(x[key], args)
end
self1 = function(x, key, ...)
  local args = _pack(...) args.tag = "list"
  return apply1(x[key], x, args)
end
gcd1 = function(x, y)
  local x1, y1 = abs1(x), abs1(y)
  while not (y1 == 0) do
    x1, y1 = y1, x1 % y1
  end
  return x1
end
_2d3e_ratComponents1 = function(y)
  local i, f = modf1(y)
  local f_27_ = 10 ^ (n1(tostring1(f)) - 2)
  if 0 == f then
    return splice1(list1(y, 1))
  else
    local n = y * f_27_
    local g = gcd1(n, f_27_)
    return splice1(list1(n / g, (f_27_ / g)))
  end
end
normalisedRationalComponents1 = function(x)
  if number_3f_1(x) then
    return _2d3e_ratComponents1(x)
  else
    return splice1(list1(x["numerator"], (x["denominator"])))
  end
end
config1 = package.config
colouredAnsi1 = function(col, msg)
  return "\27[" .. col .. "m" .. msg .. "\27[0m"
end
local termTy = lower1(getenv1 and getenv1("TERM") or "")
if termTy == "dumb" then
  coloured_3f_1 = false
elseif find1(termTy, "xterm") then
  coloured_3f_1 = true
elseif config1 and sub1(config1, 1, 1) == "/" then
  coloured_3f_1 = true
elseif getenv1 and getenv1("ANSICON") ~= nil then
  coloured_3f_1 = true
else
  coloured_3f_1 = false
end
if coloured_3f_1 then
  coloured1 = colouredAnsi1
else
  coloured1 = function(_5f_, msg)
    return msg
  end
end
create1 = function(description)
  return {desc=description, ["flag-map"]={}, ["opt-map"]={}, cats={tag="list", n=0}, opt={tag="list", n=0}, pos={tag="list", n=0}}
end
setAction1 = function(arg, data, value)
  data[arg["name"]] = value
  return nil
end
addAction1 = function(arg, data, value)
  local lst = data[arg["name"]]
  if not lst then
    lst = {tag="list", n=0}
    data[arg["name"]] = lst
  end
  return push_21_1(lst, value)
end
setNumAction1 = function(aspec, data, value, usage_21_)
  local val = tonumber1(value)
  if val then
    data[aspec["name"]] = val
    return nil
  else
    return usage_21_("Expected number for " .. car1(_2a_arguments_2a_1["names"]) .. ", got " .. value)
  end
end
addArgument_21_1 = function(spec, names, ...)
  local options = _pack(...) options.tag = "list"
  if type1(names) ~= "list" then
    error1(demandFailure1(nil, "(= (type names) \"list\")"))
  end
  if empty_3f_1(names) then
    error1("Names list is empty")
  end
  if n1(options) % 2 ~= 0 then
    error1("Options list should be a multiple of two")
  end
  local result = {names=names, action=nil, narg=0, default=false, help="", value=true}
  local first = car1(names)
  if sub1(first, 1, 2) == "--" then
    push_21_1(spec["opt"], result)
    result["name"] = sub1(first, 3)
  elseif sub1(first, 1, 1) == "-" then
    push_21_1(spec["opt"], result)
    result["name"] = sub1(first, 2)
  else
    result["name"] = first
    result["narg"] = "*"
    result["default"] = {tag="list", n=0}
    push_21_1(spec["pos"], result)
  end
  local forLimit = n1(names)
  local i = 1
  while i <= forLimit do
    local name = names[i]
    if sub1(name, 1, 2) == "--" then
      spec["opt-map"][sub1(name, 3)] = result
    elseif sub1(name, 1, 1) == "-" then
      spec["flag-map"][sub1(name, 2)] = result
    end
    i = i + 1
  end
  local forLimit = n1(options)
  local i = 1
  while i <= forLimit do
    result[nth1(options, i)] = (nth1(options, i + 1))
    i = i + 2
  end
  if not result["var"] then
    result["var"] = upper1(result["name"])
  end
  if not result["action"] then
    result["action"] = (function()
      local temp
      if number_3f_1(result["narg"]) then
        temp = result["narg"] <= 1
      else
        temp = result["narg"] == "?"
      end
      if temp then
        return setAction1
      else
        return addAction1
      end
    end)()
  end
  return result
end
addHelp_21_1 = function(spec)
  return addArgument_21_1(spec, {tag="list", n=2, "--help", "-h"}, "help", "Show this help message", "default", nil, "value", nil, "action", function()
    help_21_1(spec)
    return exit_21_1(0)
  end)
end
addCategory_21_1 = function(spec, id, name, description)
  if type1(id) ~= "string" then
    error1(demandFailure1(nil, "(= (type id) \"string\")"))
  end
  if type1(name) ~= "string" then
    error1(demandFailure1(nil, "(= (type name) \"string\")"))
  end
  push_21_1(spec["cats"], {id=id, name=name, desc=description})
  return spec
end
usageNarg_21_1 = function(buffer, arg)
  local temp = arg["narg"]
  if temp == "?" then
    return push_21_1(buffer, " [" .. arg["var"] .. "]")
  elseif temp == "*" then
    return push_21_1(buffer, " [" .. arg["var"] .. "...]")
  elseif temp == "+" then
    return push_21_1(buffer, " " .. arg["var"] .. " [" .. arg["var"] .. "...]")
  else
    local _5f_ = 1
    while _5f_ <= temp do
      push_21_1(buffer, " " .. arg["var"])
      _5f_ = _5f_ + 1
    end
    return nil
  end
end
usage_21_1 = function(spec, name)
  if not name then
    name = nth1(_2a_arguments_2a_1, 0) or (_2a_arguments_2a_1[-1] or "?")
  end
  local usage = list1("usage: ", name)
  local temp = spec["opt"]
  local forLimit = n1(temp)
  local i = 1
  while i <= forLimit do
    local arg = temp[i]
    push_21_1(usage, " [" .. car1(arg["names"]))
    usageNarg_21_1(usage, arg)
    push_21_1(usage, "]")
    i = i + 1
  end
  local temp = spec["pos"]
  local forLimit = n1(temp)
  local i = 1
  while i <= forLimit do
    usageNarg_21_1(usage, (temp[i]))
    i = i + 1
  end
  return print1(concat2(usage))
end
helpArgs_21_1 = function(pos, opt, format)
  if (empty_3f_1(pos) and empty_3f_1(opt)) then
    return nil
  else
    print1()
    local forLimit = n1(pos)
    local i = 1
    while i <= forLimit do
      local arg = pos[i]
      print1(format1(format, arg["var"], arg["help"]))
      i = i + 1
    end
    local forLimit = n1(opt)
    local i = 1
    while i <= forLimit do
      local arg = opt[i]
      print1(format1(format, concat2(arg["names"], ", "), arg["help"]))
      i = i + 1
    end
    return nil
  end
end
help_21_1 = function(spec, name)
  if not name then
    name = nth1(_2a_arguments_2a_1, 0) or (_2a_arguments_2a_1[-1] or "?")
  end
  usage_21_1(spec, name)
  if spec["desc"] then
    print1()
    print1(spec["desc"])
  end
  local max = 0
  local temp = spec["pos"]
  local forLimit = n1(temp)
  local i = 1
  while i <= forLimit do
    local len = n1(temp[i]["var"])
    if len > max then
      max = len
    end
    i = i + 1
  end
  local temp = spec["opt"]
  local forLimit = n1(temp)
  local i = 1
  while i <= forLimit do
    local len = n1(concat2(temp[i]["names"], ", "))
    if len > max then
      max = len
    end
    i = i + 1
  end
  local fmt = " %-" .. tostring1(max + 1) .. "s %s"
  helpArgs_21_1(first1(partition1(function(x)
    return x["cat"] == nil
  end, (spec["pos"]))), first1(partition1(function(x)
    return x["cat"] == nil
  end, (spec["opt"]))), fmt)
  local temp = spec["cats"]
  local forLimit = n1(temp)
  local i = 1
  while i <= forLimit do
    local cat = temp[i]
    print1()
    print1(coloured1("4", cat["name"]))
    local desc = cat["desc"]
    if desc then
      print1(desc)
    end
    helpArgs_21_1(first1(partition1(function(x)
      return x["cat"] == cat["id"]
    end, (spec["pos"]))), first1(partition1(function(x)
      return x["cat"] == cat["id"]
    end, (spec["opt"]))), fmt)
    i = i + 1
  end
  return nil
end
matcher1 = function(pattern)
  return function(x)
    local res = list1(match1(x, pattern))
    if car1(res) == nil then
      return nil
    else
      return res
    end
  end
end
parse_21_1 = function(spec, args)
  if not args then
    args = _2a_arguments_2a_1
  end
  local result, pos, posIdx, idx, len, usage_21_ = {}, spec["pos"], 1, 1, n1(args), function(msg)
    usage_21_1(spec, (nth1(args, 0)))
    print1(msg)
    return exit_21_1(1)
  end
  local readArgs = function(key, arg)
    local temp = arg["narg"]
    if temp == "+" then
      idx = idx + 1
      local elem = nth1(args, idx)
      if elem == nil then
        local msg = "Expected " .. arg["var"] .. " after --" .. key .. ", got nothing"
        usage_21_1(spec, (nth1(args, 0)))
        print1(msg)
        exit_21_1(1)
      elseif not arg["all"] and find1(elem, "^%-") then
        local msg = "Expected " .. arg["var"] .. " after --" .. key .. ", got " .. nth1(args, idx)
        usage_21_1(spec, (nth1(args, 0)))
        print1(msg)
        exit_21_1(1)
      else
        arg["action"](arg, result, elem, usage_21_)
      end
      local running = true
      while running do
        idx = idx + 1
        local elem = nth1(args, idx)
        if elem == nil then
          running = false
        elseif not arg["all"] and find1(elem, "^%-") then
          running = false
        else
          arg["action"](arg, result, elem, usage_21_)
        end
      end
      return nil
    elseif temp == "*" then
      local running = true
      while running do
        idx = idx + 1
        local elem = nth1(args, idx)
        if elem == nil then
          running = false
        elseif not arg["all"] and find1(elem, "^%-") then
          running = false
        else
          arg["action"](arg, result, elem, usage_21_)
        end
      end
      return nil
    elseif temp == "?" then
      idx = idx + 1
      local elem = nth1(args, idx)
      if elem == nil or not arg["all"] and find1(elem, "^%-") then
        return arg["action"](arg, result, arg["value"])
      else
        idx = idx + 1
        return arg["action"](arg, result, elem, usage_21_)
      end
    elseif temp == 0 then
      idx = idx + 1
      local value = arg["value"]
      return arg["action"](arg, result, value, usage_21_)
    else
      local i = 1
      while i <= temp do
        idx = idx + 1
        local elem = nth1(args, idx)
        if elem == nil then
          local msg = "Expected " .. temp .. " args for " .. key .. ", got " .. i - 1
          usage_21_1(spec, (nth1(args, 0)))
          print1(msg)
          exit_21_1(1)
        elseif not arg["all"] and find1(elem, "^%-") then
          local msg = "Expected " .. temp .. " for " .. key .. ", got " .. i - 1
          usage_21_1(spec, (nth1(args, 0)))
          print1(msg)
          exit_21_1(1)
        else
          arg["action"](arg, result, elem, usage_21_)
        end
        i = i + 1
      end
      idx = idx + 1
      return nil
    end
  end
  while idx <= len do
    local temp = nth1(args, idx)
    local temp1
    local temp2 = matcher1("^%-%-([^=]+)=(.+)$")(temp)
    temp1 = type1(temp2) == "list" and (n1(temp2) >= 2 and (n1(temp2) <= 2 and true))
    if temp1 then
      local key, val = nth1(matcher1("^%-%-([^=]+)=(.+)$")(temp), 1), nth1(matcher1("^%-%-([^=]+)=(.+)$")(temp), 2)
      local arg = spec["opt-map"][key]
      if arg == nil then
        local msg = "Unknown argument " .. key .. " in " .. nth1(args, idx)
        usage_21_1(spec, (nth1(args, 0)))
        print1(msg)
        exit_21_1(1)
      elseif not arg["many"] and nil ~= result[arg["name"]] then
        local msg = "Too may values for " .. key .. " in " .. nth1(args, idx)
        usage_21_1(spec, (nth1(args, 0)))
        print1(msg)
        exit_21_1(1)
      else
        local narg = arg["narg"]
        if number_3f_1(narg) and narg ~= 1 then
          local msg = "Expected " .. tostring1(narg) .. " values, got 1 in " .. nth1(args, idx)
          usage_21_1(spec, (nth1(args, 0)))
          print1(msg)
          exit_21_1(1)
        end
        arg["action"](arg, result, val, usage_21_)
      end
      idx = idx + 1
    else
      local temp1
      local temp2 = matcher1("^%-%-(.*)$")(temp)
      temp1 = type1(temp2) == "list" and (n1(temp2) >= 1 and (n1(temp2) <= 1 and true))
      if temp1 then
        local key = nth1(matcher1("^%-%-(.*)$")(temp), 1)
        local arg = spec["opt-map"][key]
        if arg == nil then
          local msg = "Unknown argument " .. key .. " in " .. nth1(args, idx)
          usage_21_1(spec, (nth1(args, 0)))
          print1(msg)
          exit_21_1(1)
        elseif not arg["many"] and nil ~= result[arg["name"]] then
          local msg = "Too may values for " .. key .. " in " .. nth1(args, idx)
          usage_21_1(spec, (nth1(args, 0)))
          print1(msg)
          exit_21_1(1)
        else
          readArgs(key, arg)
        end
      else
        local temp1
        local temp2 = matcher1("^%-(.+)$")(temp)
        temp1 = type1(temp2) == "list" and (n1(temp2) >= 1 and (n1(temp2) <= 1 and true))
        if temp1 then
          local flags, i = nth1(matcher1("^%-(.+)$")(temp), 1), 1
          local s = n1(flags)
          while i <= s do
            local key
            local x = i
            key = sub1(flags, x, x)
            local arg = spec["flag-map"][key]
            if arg == nil then
              local msg = "Unknown flag " .. key .. " in " .. nth1(args, idx)
              usage_21_1(spec, (nth1(args, 0)))
              print1(msg)
              exit_21_1(1)
            elseif not arg["many"] and nil ~= result[arg["name"]] then
              local msg = "Too many occurances of " .. key .. " in " .. nth1(args, idx)
              usage_21_1(spec, (nth1(args, 0)))
              print1(msg)
              exit_21_1(1)
            else
              local narg = arg["narg"]
              if i == s then
                readArgs(key, arg)
              elseif narg == 0 then
                local value = arg["value"]
                arg["action"](arg, result, value, usage_21_)
              else
                local value = sub1(flags, i + 1)
                arg["action"](arg, result, value, usage_21_)
                i = s + 1
                idx = idx + 1
              end
            end
            i = i + 1
          end
        else
          local arg = nth1(pos, posIdx)
          if arg then
            idx = idx - 1
            readArgs(arg["var"], arg)
            if not arg["many"] then
              posIdx = posIdx + 1
            end
          else
            local msg = "Unknown argument " .. temp
            usage_21_1(spec, (nth1(args, 0)))
            print1(msg)
            exit_21_1(1)
          end
        end
      end
    end
  end
  local temp = spec["opt"]
  local forLimit = n1(temp)
  local i = 1
  while i <= forLimit do
    local arg = temp[i]
    if result[arg["name"]] == nil then
      result[arg["name"]] = arg["default"]
    end
    i = i + 1
  end
  local temp = spec["pos"]
  local forLimit = n1(temp)
  local i = 1
  while i <= forLimit do
    local arg = temp[i]
    if result[arg["name"]] == nil then
      result[arg["name"]] = arg["default"]
    end
    i = i + 1
  end
  return result
end
range_3c_1 = function(a, b)
  if a["name"] == b["name"] then
    return a["start"]["offset"] < b["start"]["offset"]
  else
    return a["name"] < b["name"]
  end
end
rangeOfStart1 = function(range)
  if type1(range) ~= "range" then
    error1(demandFailure1(nil, "(= (type range) \"range\")"))
  end
  return {tag="range", name=range["name"], start=range["start"], finish=range["start"], lines=range["lines"]}
end
rangeOfSpan1 = function(from, to)
  if type1(from) ~= "range" then
    error1(demandFailure1(nil, "(= (type from) \"range\")"))
  end
  if type1(to) ~= "range" then
    error1(demandFailure1(nil, "(= (type to) \"range\")"))
  end
  return {tag="range", name=from["name"], start=from["start"], finish=to["finish"], lines=from["lines"]}
end
nodeSource_3f_1 = function(nodeSource)
  return type_23_1(nodeSource) == "table" and nodeSource["tag"] == "node-source"
end
sourceFullRange1 = function(source)
  local temp = type1(source)
  if temp == "node-source" then
    return source["range"]
  elseif temp == "range" then
    return source
  elseif temp == "nil" then
    return nil
  else
    return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"node-source\"`\n  Tried: `\"range\"`\n  Tried: `\"nil\"`")
  end
end
sourceRange1 = function(source)
  while true do
    local temp = type1(source)
    if temp == "node-source" then
      source = source["parent"]
    elseif temp == "range" then
      return source
    elseif temp == "nil" then
      return nil
    else
      return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"node-source\"`\n  Tried: `\"range\"`\n  Tried: `\"nil\"`")
    end
  end
end
getSource1 = function(node)
  return sourceRange1(node["source"])
end
append_21_1 = function(writer, text, position)
  if type1(text) ~= "string" then
    error1(demandFailure1(nil, "(= (type text) \"string\")"))
  end
  if position then
    local line = writer["lines"][writer["line"]]
    if not line then
      line = {}
      writer["lines"][writer["line"]] = line
    end
    line[position] = true
  end
  if writer["tabs-pending"] then
    writer["tabs-pending"] = false
    push_21_1(writer["out"], rep1("  ", writer["indent"]))
  end
  return push_21_1(writer["out"], text)
end
line_21_1 = function(writer, text, force)
  if text then
    append_21_1(writer, text)
  end
  if force or not writer["tabs-pending"] then
    writer["tabs-pending"] = true
    writer["line"] = writer["line"] + 1
    return push_21_1(writer["out"], "\n")
  else
    return nil
  end
end
beginBlock_21_1 = function(writer, text)
  line_21_1(writer, text)
  writer["indent"] = writer["indent"] + 1
  return writer
end
nextBlock_21_1 = function(writer, text)
  writer["indent"] = writer["indent"] - 1
  line_21_1(writer, text)
  writer["indent"] = writer["indent"] + 1
  return writer
end
endBlock_21_1 = function(writer, text)
  writer["indent"] = writer["indent"] - 1
  return line_21_1(writer, text)
end
pushNode_21_1 = function(writer, node)
  local range = sourceRange1(node["source"])
  if range then
    push_21_1(writer["node-stack"], range)
    writer["active-pos"] = range
    return nil
  else
    return nil
  end
end
popNode_21_1 = function(writer, node)
  local range = sourceRange1(node["source"])
  if range then
    local stack = writer["node-stack"]
    if last1(stack) ~= range then
      error1("Incorrect node popped")
    end
    popLast_21_1(stack)
    writer["active-pos"] = last1(stack)
    return nil
  else
    return nil
  end
end
create2 = coroutine.create
resume1 = coroutine.resume
status1 = coroutine.status
yield1 = coroutine.yield
putNodeError_21_1 = function(logger, msg, source, explain, ...)
  local lines = _pack(...) lines.tag = "list"
  return self1(logger, "put-node-error!", msg, source, explain, lines)
end
putNodeWarning_21_1 = function(logger, msg, source, explain, ...)
  local lines = _pack(...) lines.tag = "list"
  return self1(logger, "put-node-warning!", msg, source, explain, lines)
end
tracebackPlain1 = function(...)
  local args = _pack(...) args.tag = "list"
  if traceback1 then
    return apply1(traceback1, args)
  elseif empty_3f_1(args) then
    return ""
  else
    return car1(args)
  end
end
traceback2 = function(msg)
  if not string_3f_1(msg) then
    msg = pretty1(msg)
  end
  return tracebackPlain1(msg, 2)
end
truncateTraceback1 = function(trace)
  local there, here = split1(trace, "\n"), split1(tracebackPlain1(), "\n")
  local i = min1(n1(here), n1(there))
  while true do
    if i <= 1 then
      break
    elseif nth1(here, i) == nth1(there, i) then
      removeNth_21_1(here, i)
      i = i - 1
    else
      break
    end
  end
  local i = n1(there)
  while true do
    if i <= 1 then
      break
    elseif nth1(there, i) == "\9[C]: in function 'xpcall1'" or nth1(there, i) == "\9[C]: in function 'xpcall'" then
      local forStart = n1(there)
      local j = forStart
      while j >= i do
        removeNth_21_1(there, j)
        j = j + -1
      end
      break
    else
      i = i - 1
    end
  end
  return concat2(there, "\n")
end
unmangleIdent1 = function(ident)
  local esc = match1(ident, "^(.-)%d+$")
  if esc == nil then
    return ident
  elseif sub1(esc, 1, 2) == "_e" then
    return sub1(ident, 3)
  else
    local buffer, pos, len = {tag="list", n=0}, 0, n1(esc)
    while pos <= len do
      local char
      local x = pos
      char = sub1(esc, x, x)
      if char == "_" then
        local temp = list1(find1(esc, "^_[%da-z]+_", pos))
        if type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and true)) then
          local start, _eend = nth1(temp, 1), nth1(temp, 2)
          pos = pos + 1
          while pos < _eend do
            push_21_1(buffer, char1(tonumber1(sub1(esc, pos, pos + 1), 16)))
            pos = pos + 2
          end
        else
          push_21_1(buffer, "_")
        end
      elseif between_3f_1(char, "A", "Z") then
        push_21_1(buffer, "-")
        push_21_1(buffer, lower1(char))
      else
        push_21_1(buffer, char)
      end
      pos = pos + 1
    end
    return concat2(buffer)
  end
end
remapError1 = function(msg)
  return (gsub1(gsub1(gsub1(gsub1(msg, "local '([^']+)'", function(x)
    return "local '" .. unmangleIdent1(x) .. "'"
  end), "global '([^']+)'", function(x)
    return "global '" .. unmangleIdent1(x) .. "'"
  end), "upvalue '([^']+)'", function(x)
    return "upvalue '" .. unmangleIdent1(x) .. "'"
  end), "function '([^']+)'", function(x)
    return "function '" .. unmangleIdent1(x) .. "'"
  end))
end
remapMessage1 = function(mappings, msg)
  local temp = list1(match1(msg, "^(.-):(%d+)(.*)$"))
  if type1(temp) == "list" and (n1(temp) >= 3 and (n1(temp) <= 3 and true)) then
    local file, line, extra = nth1(temp, 1), nth1(temp, 2), nth1(temp, 3)
    local mapping = mappings[file]
    if mapping then
      local range = mapping[tonumber1(line)]
      if range then
        return range .. " (" .. file .. ":" .. line .. ")" .. remapError1(extra)
      else
        return msg
      end
    else
      return msg
    end
  else
    return msg
  end
end
remapTraceback1 = function(mappings, msg)
  return gsub1(gsub1(gsub1(gsub1(gsub1(gsub1(gsub1(truncateTraceback1(msg), "^([^\n:]-:%d+:[^\n]*)", function(temp)
    return remapMessage1(mappings, temp)
  end), "\9([^\n:]-:%d+:)", function(msg1)
    return "\9" .. remapMessage1(mappings, msg1)
  end), "<([^\n:]-:%d+)>\n", function(msg1)
    return "<" .. remapMessage1(mappings, msg1) .. ">\n"
  end), "in local '([^']+)'\n", function(x)
    return "in local '" .. unmangleIdent1(x) .. "'\n"
  end), "in global '([^']+)'\n", function(x)
    return "in global '" .. unmangleIdent1(x) .. "'\n"
  end), "in upvalue '([^']+)'\n", function(x)
    return "in upvalue '" .. unmangleIdent1(x) .. "'\n"
  end), "in function '([^']+)'\n", function(x)
    return "in function '" .. unmangleIdent1(x) .. "'\n"
  end)
end
generateMappings1 = function(lines)
  local outLines = {}
  local temp, ranges = next1(lines)
  while temp ~= nil do
    local rangeLists = {}
    local temp1 = next1(ranges)
    while temp1 ~= nil do
      local file = temp1["name"]
      local rangeList = rangeLists[file]
      if not rangeList then
        rangeList = {n=0, min=huge1, max=0 - huge1}
        rangeLists[file] = rangeList
      end
      local forStart, forLimit = temp1["start"]["line"], temp1["finish"]["line"]
      local i = forStart
      while i <= forLimit do
        if not rangeList[i] then
          rangeList["n"] = rangeList["n"] + 1
          rangeList[i] = true
          if i < rangeList["min"] then
            rangeList["min"] = i
          end
          if i > rangeList["max"] then
            rangeList["max"] = i
          end
        end
        i = i + 1
      end
      temp1 = next1(ranges, temp1)
    end
    local bestName, bestLines, bestCount = nil, nil, 0
    local temp1, lines1 = next1(rangeLists)
    while temp1 ~= nil do
      if lines1["n"] > bestCount then
        bestName = temp1
        bestLines = lines1
        bestCount = lines1["n"]
      end
      temp1, lines1 = next1(rangeLists, temp1)
    end
    outLines[temp] = (function()
      if bestLines["min"] == bestLines["max"] then
        return format1("%s:%d", bestName, bestLines["min"])
      else
        return format1("%s:%d-%d", bestName, bestLines["min"], bestLines["max"])
      end
    end)()
    temp, ranges = next1(lines, temp)
  end
  return outLines
end
metatable1 = {__tostring=function(self)
  return self["message"]
end}
compilerError_3f_1 = function(err)
  return type_23_1(err) == "table" and getmetatable1(err) == metatable1
end
compilerError_21_1 = function(message)
  if type1(message) ~= "string" then
    error1(demandFailure1(nil, "(= (type message) \"string\")"))
  end
  return error1(setmetatable1({type="compiler-error", message=message}, metatable1))
end
doNodeError_21_1 = function(logger, msg, source, explain, ...)
  local lines = _pack(...) lines.tag = "list"
  apply1(putNodeError_21_1, logger, msg, source, explain, lines)
  return compilerError_21_1(match1(msg, "^([^\n]+)\n") or msg)
end
traceback3 = function(err)
  if compilerError_3f_1(err) then
    return err
  elseif string_3f_1(err) then
    return tracebackPlain1(err, 2)
  else
    return tracebackPlain1(pretty1(err), 2)
  end
end
parseTemplate1 = function(template)
  local buffer, idx, max, len = {tag="list", n=0}, 0, 0, n1(template)
  while idx <= len do
    local start, finish = find1(template, "%${(%d+)}", idx)
    if start then
      if start > idx then
        push_21_1(buffer, sub1(template, idx, start - 1))
      end
      local val = tonumber1(sub1(template, start + 2, finish - 1))
      push_21_1(buffer, val)
      if val > max then
        max = val
      end
      idx = finish + 1
    else
      push_21_1(buffer, sub1(template, idx, len))
      idx = len + 1
    end
  end
  return splice1(list1(buffer, max))
end
child1 = function(parent, kind)
  if parent ~= nil then
    if type1(parent) ~= "scope" then
      error1(demandFailure1(nil, "(= (type parent) \"scope\")"))
    end
  end
  if kind == nil then
    kind = "normal"
  elseif kind == "normal" or kind == "top-level" or kind == "builtin" then
  else
    formatOutput_21_1(1, "Unknown scope kind " .. display1(kind))
  end
  return {tag="scope", parent=parent, kind=kind, variables={}, exported={}, prefix=(function()
    if parent then
      return parent["prefix"]
    else
      return ""
    end
  end)(), ["unique-prefix"]=(function()
    if parent then
      return parent["unique-prefix"]
    else
      return ""
    end
  end)()}
end
var1 = function(name, kind, scope, node)
  if type1(name) ~= "string" then
    error1(demandFailure1(nil, "(= (type name) \"string\")"))
  end
  if type1(kind) ~= "string" then
    error1(demandFailure1(nil, "(= (type kind) \"string\")"))
  end
  if type1(scope) ~= "scope" then
    error1(demandFailure1(nil, "(= (type scope) \"scope\")"))
  end
  return {tag="var", name=name, kind=kind, scope=scope, ["full-name"]=scope["prefix"] .. name, ["unique-name"]=scope["unique-prefix"] .. name, node=node, const=kind ~= "arg", ["is-variadic"]=false, doc=nil, ["display-name"]=nil, deprecated=false, intrinsic=nil, native=nil}
end
varDoc1 = function(var)
  return var["doc"]
end
varNative1 = function(var)
  if var["kind"] ~= "native" then
    error1(demandFailure1("VAR must be a native definition.", "(= (var-kind var) \"native\")"))
  end
  local vNative = var["native"]
  if not vNative then
    vNative = {tag="native", pure=false, signature=nil, ["bind-to"]=nil, syntax=nil, ["syntax-arity"]=nil, ["syntax-fold"]=nil, ["syntax-stmt"]=false, ["syntax-precedence"]=nil}
    setVarNative_21_1(var, vNative)
  end
  return vNative
end
setVarNative_21_1 = function(var, native)
  if type1(native) ~= "native" then
    error1(demandFailure1(nil, "(= (type native) \"native\")"))
  end
  if var["kind"] ~= "native" then
    error1(demandFailure1("VAR must be a native definition.", "(= (var-kind var) \"native\")"))
  end
  if var["native"] ~= nil then
    error1(demandFailure1("VAR already has native metadata.", "(= (var-native# var) nil)"))
  end
  var["native"] = native
  return nil
end
lookup1 = function(scope, name)
  while true do
    if scope then
      local temp = scope["variables"][name]
      if temp then
        return temp
      else
        scope = scope["parent"]
      end
    else
      return nil
    end
  end
end
lookupAlways_21_1 = function(scope, name, user)
  return lookup1(scope, name) or yield1({tag="define", name=name, node=user, scope=scope})
end
_2a_tempScope_2a_1 = child1()
tempVar1 = function(name, node)
  return var1(name or "temp", "arg", _2a_tempScope_2a_1, node)
end
kinds1 = {defined=true, native=true, macro=true, arg=true, builtin=true}
add_21_1 = function(scope, name, kind, node)
  if type1(scope) ~= "scope" then
    error1(demandFailure1(nil, "(= (type scope) \"scope\")"))
  end
  if type1(name) ~= "string" then
    error1(demandFailure1(nil, "(= (type name) \"string\")"))
  end
  if type1(kind) ~= "string" then
    error1(demandFailure1(nil, "(= (type kind) \"string\")"))
  end
  if not kinds1[kind] then
    formatOutput_21_1(1, "Unknown kind " .. display1(kind))
  end
  if scope["variables"][name] then
    formatOutput_21_1(1, "Previous declaration of " .. display1(name))
  end
  if name == "_" and scope["kind"] == "top-level" then
    error1("Cannot declare \"_\" as a top level definition", 0)
  end
  local var = var1(name, kind, scope, node)
  if not (name == "_") then
    scope["variables"][name] = var
    scope["exported"][name] = var
  end
  return var
end
addVerbose_21_1 = function(scope, name, kind, node, logger)
  if type1(scope) ~= "scope" then
    error1(demandFailure1(nil, "(= (type scope) \"scope\")"))
  end
  if type1(name) ~= "string" then
    error1(demandFailure1(nil, "(= (type name) \"string\")"))
  end
  if type1(kind) ~= "string" then
    error1(demandFailure1(nil, "(= (type kind) \"string\")"))
  end
  if not kinds1[kind] then
    formatOutput_21_1(1, "Unknown kind " .. display1(kind))
  end
  local previous = scope["variables"][name]
  if previous then
    doNodeError_21_1(logger, "Previous declaration of " .. quoted1(name), node["source"], nil, sourceRange1(node["source"]), "new definition here", sourceRange1(previous["node"]["source"]), "old definition here")
  end
  if name == "_" and scope["kind"] == "top-level" then
    doNodeError_21_1(logger, "Cannot declare \"_\" as a top level definition", node["source"], nil, sourceRange1(node["source"]), "declared here")
  end
  return add_21_1(scope, name, kind, node)
end
import_21_1 = function(scope, name, var, export)
  if type1(scope) ~= "scope" then
    error1(demandFailure1(nil, "(= (type scope) \"scope\")"))
  end
  if type1(name) ~= "string" then
    error1(demandFailure1(nil, "(= (type name) \"string\")"))
  end
  if type1(var) ~= "var" then
    error1(demandFailure1(nil, "(= (type var) \"var\")"))
  end
  if scope["variables"][name] and scope["variables"][name] ~= var then
    formatOutput_21_1(1, "Previous declaration of " .. display1(name))
  end
  scope["variables"][name] = var
  if export then
    scope["exported"][name] = var
  end
  return var
end
importVerbose_21_1 = function(scope, name, var, node, export, logger)
  if type1(scope) ~= "scope" then
    error1(demandFailure1(nil, "(= (type scope) \"scope\")"))
  end
  if type1(name) ~= "string" then
    error1(demandFailure1(nil, "(= (type name) \"string\")"))
  end
  if type1(var) ~= "var" then
    error1(demandFailure1(nil, "(= (type var) \"var\")"))
  end
  if scope["variables"][name] and scope["variables"][name] ~= var then
    doNodeError_21_1(logger, "Previous declaration of " .. name, node["source"], nil, sourceRange1(node["source"]), "imported here", sourceRange1(var["node"]["source"]), "new definition here", sourceRange1(scope["variables"][name]["node"]["source"]), "old definition here")
  end
  return import_21_1(scope, name, var, export)
end
rootScope1 = child1(nil, "builtin")
builtins1 = {}
builtinVars1 = {}
local temp = {tag="list", n=12, "define", "define-macro", "define-native", "lambda", "set!", "cond", "import", "struct-literal", "quote", "syntax-quote", "unquote", "unquote-splice"}
local forLimit = n1(temp)
local i = 1
while i <= forLimit do
  local symbol = temp[i]
  local var = add_21_1(rootScope1, symbol, "builtin", nil)
  import_21_1(rootScope1, "builtin/" .. symbol, var, true)
  builtins1[symbol] = var
  i = i + 1
end
local temp = {tag="list", n=3, "nil", "true", "false"}
local forLimit = n1(temp)
local i = 1
while i <= forLimit do
  local symbol = temp[i]
  local var = add_21_1(rootScope1, symbol, "defined", nil)
  import_21_1(rootScope1, "builtin/" .. symbol, var, true)
  builtinVars1[var] = true
  builtins1[symbol] = var
  i = i + 1
end
builtin1 = function(name)
  return builtins1[name]
end
builtin_3f_1 = function(node, name)
  return type1(node) == "symbol" and node["var"] == builtins1[name]
end
sideEffect_3f_1 = function(node)
  local tag = type1(node)
  if tag == "number" or tag == "string" or tag == "key" or tag == "symbol" then
    return false
  elseif tag == "list" then
    local head = car1(node)
    local temp = type1(head) ~= "symbol"
    if temp then
      return temp
    else
      local var = head["var"]
      if var["kind"] ~= "builtin" then
        return true
      elseif var == builtins1["lambda"] then
        return false
      elseif var == builtins1["quote"] then
        return false
      elseif var == builtins1["struct-literal"] then
        return n1(node) ~= 1
      else
        return true
      end
    end
  else
    _error("unmatched item")
  end
end
constant_3f_1 = function(node)
  return string_3f_1(node) or (number_3f_1(node) or type1(node) == "key")
end
urn_2d3e_val1 = function(node)
  if string_3f_1(node) then
    return node["value"]
  elseif number_3f_1(node) then
    return node["value"]
  elseif type1(node) == "key" then
    return node["value"]
  else
    _error("unmatched item")
  end
end
val_2d3e_urn1 = function(val)
  local ty = type_23_1(val)
  if ty == "string" then
    return {tag="string", value=val}
  elseif ty == "number" then
    return {tag="number", value=val}
  elseif ty == "nil" then
    return {tag="symbol", contents="nil", var=builtins1["nil"]}
  elseif ty == "boolean" then
    return {tag="symbol", contents=tostring1(val), var=builtins1[(tostring1(val))]}
  else
    return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(ty) .. ", but none matched.\n" .. "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"nil\"`\n  Tried: `\"boolean\"`")
  end
end
urn_2d3e_bool1 = function(node)
  if string_3f_1(node) or type1(node) == "key" or number_3f_1(node) then
    return true
  elseif type1(node) == "symbol" then
    if builtins1["true"] == node["var"] then
      return true
    elseif builtins1["false"] == node["var"] then
      return false
    elseif builtins1["nil"] == node["var"] then
      return false
    else
      return nil
    end
  else
    return nil
  end
end
makeProgn1 = function(body)
  return {tag="list", n=1, (function()
    local _offset, _result, _temp = 0, {tag="list"}
    _result[1 + _offset] = (function()
      local var = builtins1["lambda"]
      return {tag="symbol", contents=var["name"], var=var}
    end)()
    _result[2 + _offset] = {tag="list", n=0}
    _temp = body
    for _c = 1, _temp.n do _result[2 + _c + _offset] = _temp[_c] end
    _offset = _offset + _temp.n
    _result.n = _offset + 2
    return _result
  end)()
  }
end
makeSymbol1 = function(var)
  return {tag="symbol", contents=var["name"], var=var}
end
local temp = builtins1["nil"]
makeNil1 = function()
  return {tag="symbol", contents=temp["name"], var=temp}
end
simpleBinding_3f_1 = function(node)
  local temp = type1(node) == "list"
  if temp then
    local lam = car1(node)
    return type1(lam) == "list" and (builtin_3f_1(car1(lam), "lambda") and all1(function(x)
      return not x["var"]["is-variadic"]
    end, nth1(lam, 2)))
  else
    return temp
  end
end
singleReturn_3f_1 = function(node)
  while true do
    local temp = type1(node) ~= "list"
    if temp then
      return temp
    else
      local head = car1(node)
      local temp1 = type1(head)
      if temp1 == "symbol" then
        local func = head["var"]
        if func["kind"] ~= "builtin" then
          return false
        elseif func == builtins1["lambda"] then
          return true
        elseif func == builtins1["struct-literal"] then
          return true
        elseif func == builtins1["quote"] then
          return true
        elseif func == builtins1["syntax-quote"] then
          return true
        else
          return false
        end
      elseif temp1 == "list" then
        local temp2 = builtin_3f_1(car1(head), "lambda")
        if temp2 then
          local temp3 = n1(head) >= 3
          if temp3 then
            node = last1(head)
          else
            return temp3
          end
        else
          return temp2
        end
      else
        return false
      end
    end
  end
end
fastAll1 = function(fn, li, i)
  while true do
    if i > n1(li) then
      return true
    elseif fn(nth1(li, i)) then
      i = i + 1
    else
      return false
    end
  end
end
fastAny1 = function(fn, li, i)
  while true do
    if i > n1(li) then
      return false
    elseif fn(nth1(li, i)) then
      return true
    else
      i = i + 1
    end
  end
end
zipArgs1 = function(args, argsStart, vals, valsStart)
  local res, an, vn, _ = {tag="list", n=0}, n1(args), n1(vals)
  local ai, vi = argsStart, valsStart
  while true do
    if ai > an and vi > vn then
      return res
    else
      local arg = args[ai]
      if not arg then
        push_21_1(res, list1({tag="list", n=0}, list1(nth1(vals, vi))))
        vi = vi + 1
      elseif vi > vn then
        push_21_1(res, list1(list1(arg), {tag="list", n=0}))
        ai = ai + 1
      elseif arg["var"]["is-variadic"] then
        if singleReturn_3f_1(nth1(vals, vn)) then
          local vEnd = vn - (an - ai)
          if vEnd < vi then
            vEnd = vi - 1
          end
          push_21_1(res, list1(list1(arg), slice1(vals, vi, vEnd)))
          ai, vi = ai + 1, vEnd + 1
        else
          return push_21_1(res, list1(slice1(args, ai), slice1(vals, vi)))
        end
      elseif vi < vn or singleReturn_3f_1(nth1(vals, vi)) then
        push_21_1(res, list1(list1(arg), list1(nth1(vals, vi))))
        ai, vi = ai + 1, vi + 1
      else
        return push_21_1(res, list1(slice1(args, ai), list1(nth1(vals, vi))))
      end
    end
  end
end
tokens1 = {tag="list", n=7, {tag="list", n=2, "arg", "(%f[%a][%u-]+%f[^%a%d%-])"}, {tag="list", n=2, "mono", "```[^\n]*\n(.-)\n```"}, {tag="list", n=2, "mono", "`([^`\n]*)`"}, {tag="list", n=2, "bolic", "(%*%*%*%w.-%w%*%*%*)"}, {tag="list", n=2, "bold", "(%*%*%w.-%w%*%*)"}, {tag="list", n=2, "italic", "(%*%w.-%w%*)"}, {tag="list", n=2, "link", "%[%[([^\n]-)%]%]"}}
stars1 = {text=0, italic=1, bold=2, bolid=3}
extractSignature1 = function(var, history)
  local ty = var["kind"]
  if history and history[var] then
    return nil
  elseif ty == "macro" or ty == "defined" then
    local root = var["node"]
    if root then
      local node = nth1(root, n1(root))
      while true do
        if not node then
          return nil
        elseif type1(node) == "symbol" then
          if not history then
            history = {}
          end
          history[var] = true
          return extractSignature1(node["var"], history)
        elseif type1(node) == "list" and builtin_3f_1(car1(node), "lambda") then
          return map2(function(sym)
            return sym["display-name"] or sym["contents"]
          end, nth1(node, 2))
        elseif type1(node) == "list" and (type1((car1(node))) == "list" and (builtin_3f_1(caar1(node), "lambda") and n1(car1(node)) >= 3)) then
          node = last1(car1(node))
        else
          return nil
        end
      end
    else
      return nil
    end
  elseif ty == "native" then
    local sig = varNative1(var)["signature"]
    if sig then
      return map2(function(sym)
        return sym["display-name"] or sym["contents"]
      end, sig)
    else
      return nil
    end
  else
    return nil
  end
end
parseDocstring1 = function(str)
  local out, pos, len = {tag="list", n=0}, 1, n1(str)
  while pos <= len do
    local spos, epos, name, ptrn = len, nil, nil, nil
    local forLimit = n1(tokens1)
    local i = 1
    while i <= forLimit do
      local tok = tokens1[i]
      local npos = list1(find1(str, nth1(tok, 2), pos))
      if car1(npos) and car1(npos) < spos then
        spos = car1(npos)
        epos = nth1(npos, 2)
        name = car1(tok)
        ptrn = nth1(tok, 2)
      end
      i = i + 1
    end
    if name then
      if pos < spos then
        push_21_1(out, {kind="text", contents=sub1(str, pos, spos - 1)})
      end
      push_21_1(out, {kind=name, whole=sub1(str, spos, epos), contents=match1(sub1(str, spos, epos), ptrn)})
      pos = epos + 1
    else
      push_21_1(out, {kind="text", contents=sub1(str, pos, len)})
      pos = len + 1
    end
  end
  return out
end
extractSummary1 = function(toks)
  local result = {tag="list", n=0}
  local i = 1
  while true do
    if (i > n1(toks)) then
      break
    else
      local tok = nth1(toks, i)
      local kind = tok["kind"]
      if kind == "mono" then
        if sub1(tok["whole"], 1, 3) == "```" then
          push_21_1(result, {kind="text", contents="..."})
          break
        else
          push_21_1(result, tok)
          i = i + 1
        end
      elseif kind == "arg" or kind == "link" then
        push_21_1(result, tok)
        i = i + 1
      else
        local newline, sentence = find1(tok["contents"], "\n\n"), find1(tok["contents"], "[.!?]")
        local _eend
        if newline and sentence then
          _eend = min1(newline - 1, sentence)
        elseif newline then
          _eend = newline - 1
        else
          _eend = sentence
        end
        if _eend then
          push_21_1(result, {kind=kind, contents=gsub1(sub1(tok["contents"], 1, _eend), "\n", " ") .. rep1("*", stars1[kind])})
          break
        else
          push_21_1(result, {kind=kind, contents=gsub1(tok["contents"], "\n", " "), whole=tok["whole"] and gsub1(tok["whole"], "\n", " ")})
          i = i + 1
        end
      end
    end
  end
  return result
end
libraryCache1 = function()
  return {tag="library-cache", values={}, metas={}, paths={}, names={}, loaded={tag="list", n=0}}
end
libraryOf1 = function(name, uniqueName, path, parentScope)
  return {tag="library", name=name, ["unique-name"]=uniqueName, path=path, scope=scopeForLibrary1(parentScope, name, uniqueName), nodes=nil, docs=nil, ["lisp-lines"]=nil, ["lua-contents"]=nil, depends={}}
end
libraryName1 = function(library)
  return library["name"]
end
scopeForLibrary1 = function(parent, name, uniqueName)
  if type1(name) ~= "string" then
    error1(demandFailure1(nil, "(= (type name) \"string\")"))
  end
  if type1(uniqueName) ~= "string" then
    error1(demandFailure1(nil, "(= (type unique-name) \"string\")"))
  end
  local scope = child1(parent, "top-level")
  scope["prefix"] = (name .. "/")
  scope["unique-prefix"] = (uniqueName .. "/")
  return scope
end
local discard = function()
  return nil
end
void1 = {["put-error!"]=discard, ["put-warning!"]=discard, ["put-verbose!"]=discard, ["put-debug!"]=discard, ["put-time!"]=discard, ["put-node-error!"]=discard, ["put-node-warning!"]=discard}
_2a_romanDigits_2a_1 = {I=1, V=5, X=10, L=50, C=100, D=500, M=1000}
romanDigit_3f_1 = function(char)
  return _2a_romanDigits_2a_1[char] or false
end
hexDigit_3f_1 = function(char)
  return between_3f_1(char, "0", "9") or (between_3f_1(char, "a", "f") or between_3f_1(char, "A", "F"))
end
binDigit_3f_1 = function(char)
  return char == "0" or char == "1"
end
terminator_3f_1 = function(char)
  return char == "\n" or (char == " " or (char == "\9" or (char == ";" or (char == "(" or (char == ")" or (char == "[" or (char == "]" or (char == "{" or (char == "}" or (char == "\11" or (char == "\12" or char == "")))))))))))
end
closingTerminator_3f_1 = function(char)
  return char == "\n" or (char == " " or (char == "\9" or (char == ";" or (char == ")" or (char == "]" or (char == "}" or (char == "\11" or (char == "\12" or char == ""))))))))
end
digitError_21_1 = function(logger, pos, name, char)
  return doNodeError_21_1(logger, format1("Expected %s digit, got %s", name, (function()
    if char == "" then
      return "eof"
    else
      return quoted1(char)
    end
  end)()), pos, nil, pos, "Invalid digit here")
end
eofError_21_1 = function(context, tokens, logger, msg, source, explain, ...)
  local lines = _pack(...) lines.tag = "list"
  if context then
    return error1({msg=msg, context=context, tokens=tokens}, 0)
  else
    return apply1(doNodeError_21_1, logger, msg, source, explain, lines)
  end
end
lex1 = function(logger, str, name, cont)
  str = gsub1(str, "\13\n?", "\n")
  local lines, line, column, offset, length, out = split1(str, "\n"), 1, 1, 1, n1(str), {tag="list", n=0}
  local consume_21_, range = function()
    if (function()
      local xs, x = str, offset
      return sub1(xs, x, x)
    end)() == "\n" then
      line = line + 1
      column = 1
    else
      column = column + 1
    end
    offset = offset + 1
    return nil
  end, function(start, finish)
    return {tag="range", name=name, start=start, finish=finish or start, lines=lines}
  end
  local appendWith_21_, parseBase = function(data, start, finish)
    local start1, finish1 = start or {tag="position", offset=offset, line=line, column=column}, finish or {tag="position", offset=offset, line=line, column=column}
    data["source"] = range(start1, finish1)
    data["contents"] = sub1(str, start1["offset"], finish1["offset"])
    return push_21_1(out, data)
  end, function(name2, p, base)
    local start = offset
    local char
    local xs, x = str, offset
    char = sub1(xs, x, x)
    if not p(char) then
      digitError_21_1(logger, range({tag="position", offset=offset, line=line, column=column}), name2, char)
    end
    local xs, x = str, offset + 1
    char = sub1(xs, x, x)
    while p(char) or "'" == char do
      consume_21_()
      local xs, x = str, offset + 1
      char = sub1(xs, x, x)
    end
    return tonumber1(gsub1(sub1(str, start, offset), "'", ""), base)
  end
  while offset <= length do
    local char
    local xs, x = str, offset
    char = sub1(xs, x, x)
    if char == "\n" or char == "\9" or char == " " or char == "\11" or char == "\12" then
    elseif char == "(" then
      appendWith_21_({tag="open", close=")"})
    elseif char == ")" then
      appendWith_21_({tag="close", open="("})
    elseif char == "[" then
      appendWith_21_({tag="open", close="]"})
    elseif char == "]" then
      appendWith_21_({tag="close", open="["})
    elseif char == "{" then
      appendWith_21_({tag="open-struct", close="}"})
    elseif char == "}" then
      appendWith_21_({tag="close", open="{"})
    elseif char == "'" then
      appendWith_21_({tag="quote"}, nil, nil)
    elseif char == "`" then
      appendWith_21_({tag="syntax-quote"}, nil, nil)
    elseif char == "~" then
      appendWith_21_({tag="quasiquote"}, nil, nil)
    elseif char == "@" and not closingTerminator_3f_1((function()
      local xs, x = str, offset + 1
      return sub1(xs, x, x)
    end)()) then
      appendWith_21_({tag="splice"}, nil, nil)
    elseif char == "," then
      if (function()
        local xs, x = str, offset + 1
        return sub1(xs, x, x)
      end)() == "@" then
        local start = {tag="position", offset=offset, line=line, column=column}
        consume_21_()
        appendWith_21_({tag="unquote-splice"}, start, nil)
      else
        appendWith_21_({tag="unquote"}, nil, nil)
      end
    elseif find1(str, "^%-?%.?[#0-9]", offset) then
      local start, negative = {tag="position", offset=offset, line=line, column=column}, char == "-"
      if negative then
        consume_21_()
        local xs, x = str, offset
        char = sub1(xs, x, x)
      end
      if char == "#" and lower1((function()
        local xs, x = str, offset + 1
        return sub1(xs, x, x)
      end)()) == "x" then
        consume_21_()
        consume_21_()
        local res = parseBase("hexadecimal", hexDigit_3f_1, 16)
        if negative then
          res = 0 - res
        end
        appendWith_21_({tag="number", value=res}, start)
      elseif char == "#" and lower1((function()
        local xs, x = str, offset + 1
        return sub1(xs, x, x)
      end)()) == "b" then
        consume_21_()
        consume_21_()
        local res = parseBase("binary", binDigit_3f_1, 2)
        if negative then
          res = 0 - res
        end
        appendWith_21_({tag="number", value=res}, start)
      elseif char == "#" and lower1((function()
        local xs, x = str, offset + 1
        return sub1(xs, x, x)
      end)()) == "r" then
        consume_21_()
        consume_21_()
        local res
        local start1 = offset
        local char2
        local xs, x = str, offset
        char2 = sub1(xs, x, x)
        if not romanDigit_3f_1(char2) then
          digitError_21_1(logger, range({tag="position", offset=offset, line=line, column=column}), "roman", char2)
        end
        local xs, x = str, offset + 1
        char2 = sub1(xs, x, x)
        while romanDigit_3f_1(char2) or char2 == "'" do
          consume_21_()
          local xs, x = str, offset + 1
          char2 = sub1(xs, x, x)
        end
        local str1 = gsub1(reverse1(sub1(str, start1, offset)), "'", "")
        res = car1(reduce1(function(_e1, _e2, ...)
          local remainingArguments = _pack(...) remainingArguments.tag = "list"
          local temp = append1(list1(_e1, _e2), remainingArguments)
          local temp1
          if type1(temp) == "list" then
            if n1(temp) >= 2 then
              if n1(temp) <= 2 then
                local temp2
                local temp3 = nth1(temp, 1)
                temp2 = type1(temp3) == "list" and (n1(temp3) >= 2 and (n1(temp3) <= 2 and true))
                if temp2 then
                  temp1 = true
                else
                  temp1 = false
                end
              else
                temp1 = false
              end
            else
              temp1 = false
            end
          else
            temp1 = false
          end
          if temp1 then
            local acc, prev, n = nth1(nth1(temp, 1), 1), nth1(nth1(temp, 1), 2), nth1(temp, 2)
            return list1((function()
              if n < prev then
                return _2d_1
              else
                return _2b_1
              end
            end)()(acc, n), max1(n, prev))
          else
            return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `((?acc ?prev) ?n)`")
          end
        end, list1(0, 0), map2(comp1(function(temp)
          return _2a_romanDigits_2a_1[temp]
        end, upper1, function(temp)
          return sub1(str1, temp, temp)
        end), range1("from", 1, "to", n1(str1)))))
        if negative then
          res = 0 - res
        end
        appendWith_21_({tag="number", value=res}, start)
      elseif char == "#" and terminator_3f_1(lower1((function()
        local xs, x = str, offset + 1
        return sub1(xs, x, x)
      end)())) then
        doNodeError_21_1(logger, "Expected hexadecimal (#x), binary (#b), or Roman (#r) digit specifier.", range({tag="position", offset=offset, line=line, column=column}), "The '#' character is used for various number representations, such as binary\nand hexadecimal digits.\n\nIf you're looking for the '#' function, this has been replaced with 'n'. We\napologise for the inconvenience.", range({tag="position", offset=offset, line=line, column=column}), "# must be followed by x, b or r")
      elseif char == "#" then
        consume_21_()
        doNodeError_21_1(logger, "Expected hexadecimal (#x), binary (#b), or Roman (#r) digit specifier.", range({tag="position", offset=offset, line=line, column=column}), "The '#' character is used for various number representations, namely binary,\nhexadecimal and roman numbers.", range({tag="position", offset=offset, line=line, column=column}), "# must be followed by x, b or r")
      else
        while between_3f_1((function()
          local xs, x = str, offset + 1
          return sub1(xs, x, x)
        end)(), "0", "9") or (function()
          local xs, x = str, offset + 1
          return sub1(xs, x, x)
        end)() == "'" do
          consume_21_()
        end
        if (function()
          local xs, x = str, offset + 1
          return sub1(xs, x, x)
        end)() == "/" then
          local numEnd, _5f_, _5f_1, domStart = {tag="position", offset=offset, line=line, column=column}, consume_21_(), consume_21_(), {tag="position", offset=offset, line=line, column=column}
          if not (between_3f_1((function()
            local xs, x = str, offset
            return sub1(xs, x, x)
          end)(), "0", "9") or (function()
            local xs, x = str, offset
            return sub1(xs, x, x)
          end)() == "'") then
            doNodeError_21_1(logger, formatOutput_21_1(nil, "Expected digit, got " .. quoted1((function()
              local xs, x = str, offset
              return sub1(xs, x, x)
            end)())), range(domStart), "", range(domStart), "")
          end
          while between_3f_1((function()
            local xs, x = str, offset + 1
            return sub1(xs, x, x)
          end)(), "0", "9") or (function()
            local xs, x = str, offset + 1
            return sub1(xs, x, x)
          end)() == "'" do
            consume_21_()
          end
          local domEnd, num = {tag="position", offset=offset, line=line, column=column}, tonumber1(gsub1(sub1(str, start["offset"], numEnd["offset"]), "'", ""), 10)
          local dom = tonumber1(gsub1(sub1(str, domStart["offset"], domEnd["offset"]), "'", ""), 10)
          if not num then
            doNodeError_21_1(logger, "Invalid numerator in rational literal", range(start, numEnd), "", range(start, numEnd), "There should be at least one number before the division symbol.")
          end
          if not dom then
            doNodeError_21_1(logger, "Invalid denominator in rational literal", range(domStart, domEnd), "", range(domStart, domEnd), "There should be at least one number after the division symbol.")
          end
          appendWith_21_({tag="rational", num={tag="number", value=num, source=range(start, numEnd)}, dom={tag="number", value=dom, source=range(domStart, domEnd)}}, start)
        else
          if (function()
            local xs, x = str, offset + 1
            return sub1(xs, x, x)
          end)() == "." then
            consume_21_()
            while between_3f_1((function()
              local xs, x = str, offset + 1
              return sub1(xs, x, x)
            end)(), "0", "9") or (function()
              local xs, x = str, offset + 1
              return sub1(xs, x, x)
            end)() == "'" do
              consume_21_()
            end
          end
          local xs, x = str, offset + 1
          char = sub1(xs, x, x)
          if char == "e" or char == "E" then
            consume_21_()
            local xs, x = str, offset + 1
            char = sub1(xs, x, x)
            if char == "-" or char == "+" then
              consume_21_()
            end
            while between_3f_1((function()
              local xs, x = str, offset + 1
              return sub1(xs, x, x)
            end)(), "0", "9") or (function()
              local xs, x = str, offset + 1
              return sub1(xs, x, x)
            end)() == "'" do
              consume_21_()
            end
          end
          local res = tonumber1((gsub1(sub1(str, start["offset"], offset), "'", "")))
          if not res then
            doNodeError_21_1(logger, format1("Expected digit, got %s", (function()
              if char == "" then
                return "eof"
              else
                return quoted1(char)
              end
            end)()), range({tag="position", offset=offset, line=line, column=column}), nil, range({tag="position", offset=offset, line=line, column=column}), "Illegal character here. Are you missing whitespace?")
          end
          appendWith_21_({tag="number", value=res}, start)
        end
      end
      local xs, x = str, offset + 1
      char = sub1(xs, x, x)
      if not terminator_3f_1(char) then
        consume_21_()
        doNodeError_21_1(logger, format1("Expected digit, got %s", (function()
          if char == "" then
            return "eof"
          else
            return quoted1(char)
          end
        end)()), range({tag="position", offset=offset, line=line, column=column}), nil, range({tag="position", offset=offset, line=line, column=column}), "Illegal character here. Are you missing whitespace?")
      end
    elseif char == "\"" or char == "$" and (function()
      local xs, x = str, offset + 1
      return sub1(xs, x, x)
    end)() == "\"" then
      local start, startCol, buffer, interpolate = {tag="position", offset=offset, line=line, column=column}, column + 1, {tag="list", n=0}, char == "$"
      if interpolate then
        consume_21_()
      end
      consume_21_()
      local xs, x = str, offset
      char = sub1(xs, x, x)
      while char ~= "\"" do
        if column == 1 then
          local running, lineOff = true, offset
          while running and column < startCol do
            if char == " " then
              consume_21_()
            elseif char == "\n" then
              consume_21_()
              push_21_1(buffer, "\n")
              lineOff = offset
            elseif char == "" then
              running = false
            else
              putNodeWarning_21_1(logger, format1("Expected leading indent, got %q", char), range({tag="position", offset=offset, line=line, column=column}), "You should try to align multi-line strings at the initial quote\nmark. This helps keep programs neat and tidy.", range(start), "String started with indent here", range({tag="position", offset=offset, line=line, column=column}), "Mis-aligned character here")
              push_21_1(buffer, sub1(str, lineOff, offset - 1))
              running = false
            end
            local xs, x = str, offset
            char = sub1(xs, x, x)
          end
        end
        if char == "" then
          local start1, finish = range(start), range({tag="position", offset=offset, line=line, column=column})
          eofError_21_1(cont and "string", out, logger, "Expected '\"', got eof", finish, nil, start1, "string started here", finish, "end of file here")
        elseif char == "\\" then
          consume_21_()
          local xs, x = str, offset
          char = sub1(xs, x, x)
          if char == "\n" then
          elseif char == "a" then
            push_21_1(buffer, "\7")
          elseif char == "b" then
            push_21_1(buffer, "\8")
          elseif char == "f" then
            push_21_1(buffer, "\12")
          elseif char == "n" then
            push_21_1(buffer, "\n")
          elseif char == "r" then
            push_21_1(buffer, "\13")
          elseif char == "t" then
            push_21_1(buffer, "\9")
          elseif char == "v" then
            push_21_1(buffer, "\11")
          elseif char == "\"" then
            push_21_1(buffer, "\"")
          elseif char == "\\" then
            push_21_1(buffer, "\\")
          elseif char == "x" or char == "X" or between_3f_1(char, "0", "9") then
            local start1 = {tag="position", offset=offset, line=line, column=column}
            local val
            if char == "x" or char == "X" then
              consume_21_()
              local start2 = offset
              if not hexDigit_3f_1((function()
                local xs, x = str, offset
                return sub1(xs, x, x)
              end)()) then
                digitError_21_1(logger, range({tag="position", offset=offset, line=line, column=column}), "hexadecimal", (function()
                  local xs, x = str, offset
                  return sub1(xs, x, x)
                end)())
              end
              if hexDigit_3f_1((function()
                local xs, x = str, offset + 1
                return sub1(xs, x, x)
              end)()) then
                consume_21_()
              end
              val = tonumber1(sub1(str, start2, offset), 16)
            else
              local start2, ctr = {tag="position", offset=offset, line=line, column=column}, 0
              local xs, x = str, offset + 1
              char = sub1(xs, x, x)
              while ctr < 2 and between_3f_1(char, "0", "9") do
                consume_21_()
                local xs, x = str, offset + 1
                char = sub1(xs, x, x)
                ctr = ctr + 1
              end
              val = tonumber1(sub1(str, start2["offset"], offset))
            end
            if val >= 256 then
              doNodeError_21_1(logger, "Invalid escape code", range(start1), nil, range(start1, {tag="position", offset=offset, line=line, column=column}), "Must be between 0 and 255, is " .. val)
            end
            push_21_1(buffer, char1(val))
          elseif char == "" then
            eofError_21_1(cont and "string", out, logger, "Expected escape code, got eof", range({tag="position", offset=offset, line=line, column=column}), nil, range({tag="position", offset=offset, line=line, column=column}), "end of file here")
          else
            doNodeError_21_1(logger, "Illegal escape character", range({tag="position", offset=offset, line=line, column=column}), nil, range({tag="position", offset=offset, line=line, column=column}), "Unknown escape character")
          end
        else
          push_21_1(buffer, char)
        end
        consume_21_()
        local xs, x = str, offset
        char = sub1(xs, x, x)
      end
      if interpolate then
        local value, sections, len = concat2(buffer), {tag="list", n=0}, n1(str)
        local i = 1
        while true do
          local rs, re, rm = find1(value, "~%{([^%} ]+)%}", i)
          local is, ie, im = find1(value, "%$%{([^%} ]+)%}", i)
          if rs and (not is or rs < is) then
            push_21_1(sections, sub1(value, i, rs - 1))
            push_21_1(sections, "{#" .. rm .. "}")
            i = re + 1
          elseif is then
            push_21_1(sections, sub1(value, i, is - 1))
            push_21_1(sections, "{#" .. im .. ":id}")
            i = ie + 1
          else
            push_21_1(sections, sub1(value, i, len))
            break
          end
        end
        putNodeWarning_21_1(logger, "The $ syntax is deprecated and should be replaced with format.", range(start, {tag="position", offset=offset, line=line, column=column}), nil, range(start, {tag="position", offset=offset, line=line, column=column}), "Can be replaced with (format nil " .. quoted1(concat2(sections)) .. ")")
        appendWith_21_({tag="interpolate", value=value}, start)
      else
        appendWith_21_({tag="string", value=concat2(buffer)}, start)
      end
    elseif char == ";" then
      while offset <= length and (function()
        local xs, x = str, offset + 1
        return sub1(xs, x, x)
      end)() ~= "\n" do
        consume_21_()
      end
    else
      local start, key = {tag="position", offset=offset, line=line, column=column}, char == ":"
      local xs, x = str, offset + 1
      char = sub1(xs, x, x)
      while not terminator_3f_1(char) do
        consume_21_()
        local xs, x = str, offset + 1
        char = sub1(xs, x, x)
      end
      if key then
        appendWith_21_({tag="key", value=sub1(str, start["offset"] + 1, offset)}, start)
      else
        appendWith_21_({tag="symbol"}, start, nil)
      end
    end
    consume_21_()
  end
  appendWith_21_({tag="eof"}, nil, nil)
  return splice1(list1(out, (range({tag="position", offset=1, line=1, column=nil}, {tag="position", offset=offset, line=line, column=column}))))
end
parse1 = function(logger, toks, cont)
  local head, stack = {tag="list", n=0}, {tag="list", n=0}
  local pop_21_ = function()
    head["open"] = nil
    head["close"] = nil
    head["auto-close"] = nil
    head["last-node"] = nil
    head = last1(stack)
    return popLast_21_1(stack)
  end
  local forLimit = n1(toks)
  local i = 1
  while i <= forLimit do
    local tok = toks[i]
    local tag, autoClose = type1(tok), false
    local previous, tokPos = head["last-node"], tok["source"]
    local temp
    if tag ~= "eof" then
      if tag ~= "close" then
        if head["source"] then
          temp = tokPos["start"]["line"] ~= head["source"]["start"]["line"]
        else
          temp = true
        end
      else
        temp = false
      end
    else
      temp = false
    end
    if temp then
      if previous then
        local prevPos = previous["source"]
        if tokPos["start"]["line"] ~= prevPos["start"]["line"] then
          head["last-node"] = tok
          if tokPos["start"]["column"] ~= prevPos["start"]["column"] then
            putNodeWarning_21_1(logger, "Different indent compared with previous expressions.", tok["source"], "You should try to maintain consistent indentation across a program,\ntry to ensure all expressions are lined up.\nIf this looks OK to you, check you're not missing a closing ')'.", prevPos, "", tokPos, "")
          end
        end
      else
        head["last-node"] = tok
      end
    end
    if tag == "string" or tag == "number" or tag == "symbol" or tag == "key" then
      push_21_1(head, tok)
    elseif tag == "interpolate" then
      local node = {tag="list", n=2, source=tok["source"], [1]={tag="symbol", contents="$", source=rangeOfStart1(tok["source"])}, [2]={tag="string", value=tok["value"], source=tok["source"]}}
      push_21_1(head, node)
    elseif tag == "rational" then
      local node = {tag="list", n=3, source=tok["source"], [1]={tag="symbol", contents="rational", source=tok["source"]}, [2]=tok["num"], [3]=tok["dom"]}
      push_21_1(head, node)
    elseif tag == "open" then
      local next = {tag="list", n=0}
      push_21_1(stack, head)
      push_21_1(head, next)
      head = next
      head["open"] = tok["contents"]
      head["close"] = tok["close"]
      head["source"] = tok["source"]
    elseif tag == "open-struct" then
      local next = {tag="list", n=0}
      push_21_1(stack, head)
      push_21_1(head, next)
      head = next
      head["open"] = tok["contents"]
      head["close"] = tok["close"]
      head["source"] = tok["source"]
      local node = {tag="symbol", contents="struct-literal", source=head["source"]}
      push_21_1(head, node)
    elseif tag == "close" then
      if empty_3f_1(stack) then
        doNodeError_21_1(logger, format1("'%s' without matching '%s'", tok["contents"], tok["open"]), tok["source"], nil, sourceRange1(tok["source"]), "")
      elseif head["auto-close"] then
        doNodeError_21_1(logger, format1("'%s' without matching '%s' inside quote", tok["contents"], tok["open"]), tok["source"], nil, head["source"], "quote opened here", tok["source"], "attempting to close here")
      elseif head["close"] ~= tok["contents"] then
        doNodeError_21_1(logger, format1("Expected '%s', got '%s'", head["close"], tok["contents"]), tok["source"], nil, head["source"], format1("block opened with '%s'", head["open"]), tok["source"], format1("'%s' used here", tok["contents"]))
      else
        head["source"] = rangeOfSpan1(head["source"], tok["source"])
        pop_21_()
      end
    elseif tag == "quote" or tag == "unquote" or tag == "syntax-quote" or tag == "unquote-splice" or tag == "quasiquote" or tag == "splice" then
      local next = {tag="list", n=0}
      push_21_1(stack, head)
      push_21_1(head, next)
      head = next
      head["source"] = tok["source"]
      local node = {tag="symbol", contents=tag, source=tok["source"]}
      push_21_1(head, node)
      autoClose = true
      head["auto-close"] = true
    elseif tag == "eof" then
      if 0 ~= n1(stack) then
        eofError_21_1(cont and "list", toks, logger, (function()
          if head["auto-close"] then
            return format1("Expected expression quote, got eof", head["close"])
          else
            return format1("Expected '%s', got eof", head["close"])
          end
        end)(), tok["source"], nil, head["source"], "block opened here", tok["source"], "end of file here")
      end
    else
      error1("Unsupported type " .. tag)
    end
    if not autoClose then
      while head["auto-close"] do
        if empty_3f_1(stack) then
          doNodeError_21_1(logger, format1("'%s' without matching '%s'", tok["contents"], tok["open"]), tok["source"], nil, sourceRange1(tok["source"]), "")
        end
        head["source"] = rangeOfSpan1(head["source"], tok["source"])
        pop_21_()
      end
    end
    i = i + 1
  end
  return head
end
read2 = function(x, path)
  return parse1(void1, lex1(void1, x, path or "", nil), nil)
end
visitQuote1 = function(node, visitor, level)
  while true do
    if level == 0 then
      return visitNode1(node, visitor)
    else
      local tag = type1(node)
      if tag == "string" or tag == "number" or tag == "key" or tag == "symbol" then
        return nil
      elseif tag == "list" then
        local first = nth1(node, 1)
        if type1(first) == "symbol" then
          if first["contents"] == "unquote" or first["contents"] == "unquote-splice" then
            node, level = nth1(node, 2), level - 1
          elseif first["contents"] == "syntax-quote" then
            node, level = nth1(node, 2), level + 1
          else
            local forLimit = n1(node)
            local i = 1
            while i <= forLimit do
              visitQuote1(node[i], visitor, level)
              i = i + 1
            end
            return nil
          end
        else
          local forLimit = n1(node)
          local i = 1
          while i <= forLimit do
            visitQuote1(node[i], visitor, level)
            i = i + 1
          end
          return nil
        end
      elseif error1 then
        return "Unknown tag " .. tag
      else
        _error("unmatched item")
      end
    end
  end
end
visitNode1 = function(node, visitor)
  while true do
    if visitor(node, visitor) ~= false then
      local tag = type1(node)
      if tag == "string" or tag == "number" or tag == "key" or tag == "symbol" then
        return nil
      elseif tag == "list" then
        local first = nth1(node, 1)
        if type1(first) == "symbol" then
          local func = first["var"]
          local funct = func["kind"]
          if funct == "defined" or funct == "arg" or funct == "native" or funct == "macro" then
            return visitBlock1(node, 1, visitor)
          elseif func == builtins1["lambda"] then
            return visitBlock1(node, 3, visitor)
          elseif func == builtins1["cond"] then
            local forLimit = n1(node)
            local i = 2
            while i <= forLimit do
              local case = nth1(node, i)
              visitNode1(nth1(case, 1), visitor)
              visitBlock1(case, 2, visitor)
              i = i + 1
            end
            return nil
          elseif func == builtins1["set!"] then
            node = nth1(node, 3)
          elseif func == builtins1["quote"] then
            return nil
          elseif func == builtins1["syntax-quote"] then
            return visitQuote1(nth1(node, 2), visitor, 1)
          elseif func == builtins1["unquote"] or func == builtins1["unquote-splice"] then
            return error1("unquote/unquote-splice should never appear here", 0)
          elseif func == builtins1["define"] or func == builtins1["define-macro"] then
            node = nth1(node, n1(node))
          elseif func == builtins1["define-native"] then
            return nil
          elseif func == builtins1["import"] then
            return nil
          elseif func == builtins1["struct-literal"] then
            return visitBlock1(node, 2, visitor)
          else
            return error1("Unknown kind " .. funct .. " for variable " .. func["name"], 0)
          end
        else
          return visitBlock1(node, 1, visitor)
        end
      else
        return error1("Unknown tag " .. tag)
      end
    else
      return nil
    end
  end
end
visitBlock1 = function(node, start, visitor)
  local forLimit = n1(node)
  local i = start
  while i <= forLimit do
    visitNode1(nth1(node, i), visitor)
    i = i + 1
  end
  return nil
end
startTimer_21_1 = function(timer, name, level)
  local instance = timer["timers"][name]
  if not instance then
    instance = {name=name, level=level or 1, running=false, total=0}
    timer["timers"][name] = instance
  end
  if instance["running"] then
    error1("Timer " .. name .. " is already running")
  end
  instance["running"] = true
  instance["start"] = clock1()
  return nil
end
pauseTimer_21_1 = function(timer, name)
  local instance = timer["timers"][name]
  if not instance then
    error1("Timer " .. name .. " does not exist")
  end
  if not instance["running"] then
    error1("Timer " .. name .. " is not running")
  end
  instance["running"] = false
  instance["total"] = (clock1() - instance["start"]) + instance["total"]
  return nil
end
stopTimer_21_1 = function(timer, name)
  local instance = timer["timers"][name]
  if not instance then
    error1("Timer " .. name .. " does not exist")
  end
  if not instance["running"] then
    error1("Timer " .. name .. " is not running")
  end
  timer["timers"][name] = nil
  instance["total"] = (clock1() - instance["start"]) + instance["total"]
  return timer["callback"](instance["name"], instance["total"], instance["level"])
end
passEnabled_3f_1 = function(pass, options)
  local override = options["override"]
  if override[pass["name"]] == true then
    return true
  elseif override[pass["name"]] == false then
    return false
  elseif any1(function(cat)
    return override[cat] == true
  end, pass["cat"]) then
    return true
  elseif any1(function(cat)
    return override[cat] == false
  end, pass["cat"]) then
    return false
  else
    return pass["on"] ~= false and options["level"] >= (pass["level"] or 1)
  end
end
filterPasses1 = function(passes, options)
  local res = {}
  local temp, v = next1(passes)
  while temp ~= nil do
    res[temp] = first1(partition1(function(temp1)
      return passEnabled_3f_1(temp1, options)
    end, v))
    temp, v = next1(passes, temp)
  end
  return res
end
runPass1 = function(pass, options, tracker, ...)
  local args = _pack(...) args.tag = "list"
  local ptracker, name = {changed=0}, "[" .. concat2(pass["cat"], " ") .. "] " .. pass["name"]
  startTimer_21_1(options["timer"], name, 2)
  pass["run"](ptracker, options, splice1(args))
  stopTimer_21_1(options["timer"], name)
  if options["track"] then
    self1(options["logger"], "put-verbose!", (sprintf1("%s made %d changes", name, ptracker["changed"])))
  end
  if tracker then
    tracker["changed"] = tracker["changed"] + ptracker["changed"]
  end
  return ptracker["changed"] > 0
end
visitQuote2 = function(node, level, lookup)
  while true do
    if level == 0 then
      return visitNode2(node, nil, nil, lookup)
    else
      local tag = type1(node)
      if tag == "string" or tag == "number" or tag == "key" or tag == "symbol" then
        return nil
      elseif tag == "list" then
        local first = nth1(node, 1)
        if type1(node) == "symbol" then
          if first["contents"] == "unquote" or first["contents"] == "unquote-splice" then
            node, level = nth1(node, 2), level - 1
          elseif first["contents"] == "syntax-quote" then
            node, level = nth1(node, 2), level + 1
          else
            local forLimit = n1(node)
            local i = 1
            while i <= forLimit do
              visitQuote2(node[i], level, lookup)
              i = i + 1
            end
            return nil
          end
        else
          local forLimit = n1(node)
          local i = 1
          while i <= forLimit do
            visitQuote2(node[i], level, lookup)
            i = i + 1
          end
          return nil
        end
      elseif error1 then
        return "Unknown tag " .. tag
      else
        _error("unmatched item")
      end
    end
  end
end
visitNode2 = function(node, parents, active, lookup)
  while true do
    local temp = type1(node)
    if temp == "string" then
      return nil
    elseif temp == "number" then
      return nil
    elseif temp == "key" then
      return nil
    elseif temp == "symbol" then
      local func = lookup[node["var"]]
      if func then
        func["var"] = (func["var"] + 1)
        return nil
      else
        return nil
      end
    elseif temp == "list" then
      local head = car1(node)
      local temp1 = type1(head)
      if temp1 == "symbol" then
        local func = head["var"]
        if func["kind"] ~= "builtin" then
          local func1 = lookup[func]
          if not func1 then
          elseif active == func1 then
            func1["recur"] = (func1["recur"] + 1)
          elseif parents and parents[func1["parent"]] then
            func1["direct"] = (func1["direct"] + 1)
          else
            func1["var"] = (func1["var"] + 1)
          end
          return visitNodes1(node, 2, nil, lookup)
        elseif func == builtins1["lambda"] then
          return visitBlock2(node, 3, nil, nil, lookup)
        elseif func == builtins1["set!"] then
          local var = nth1(node, 2)["var"]
          local func1, val = lookup[var], nth1(node, 3)
          if func1 and (func1["lambda"] == nil and (parents and (parents[func1["parent"]] and (type1(val) == "list" and builtin_3f_1(car1(val), "lambda"))))) then
            func1["lambda"] = val
            func1["setter"] = node
            visitBlock2(val, 3, nil, func1, lookup)
            if func1["recur"] == 0 then
              lookup[var] = nil
              return nil
            else
              return nil
            end
          else
            lookup[var] = nil
            node, parents, active = val, nil, nil
          end
        elseif func == builtins1["cond"] then
          local forLimit = n1(node)
          local i = 2
          while i <= forLimit do
            local case = nth1(node, i)
            visitNode2(car1(case), nil, nil, lookup)
            visitBlock2(case, 2, nil, active, lookup)
            i = i + 1
          end
          return nil
        elseif func == builtins1["quote"] then
          return nil
        elseif func == builtins1["syntax-quote"] then
          return visitQuote2(nth1(node, 2), 1, lookup)
        elseif func == builtins1["unquote"] or func == builtins1["unquote-splice"] then
          return error1("unquote/unquote-splice should never appear here", 0)
        elseif func == builtins1["define"] or func == builtins1["define-macro"] then
          node, parents, active = nth1(node, n1(node)), nil, nil
        elseif func == builtins1["define-native"] then
          return nil
        elseif func == builtins1["import"] then
          return nil
        elseif func == builtins1["struct-literal"] then
          return visitNodes1(node, 2, nil, lookup)
        else
          return error1("Unknown builtin for variable " .. func["name"], 0)
        end
      elseif temp1 == "list" then
        local first = car1(node)
        if type1(first) == "list" and builtin_3f_1(car1(first), "lambda") then
          local args = nth1(first, 2)
          local forLimit = n1(args)
          local i = 1
          while i <= forLimit do
            local val = nth1(node, i + 1)
            if val == nil or builtin_3f_1(val, "nil") then
              lookup[nth1(args, i)["var"]] = {tag="rec-func", parent=node, setter=nil, lambda=nil, recur=0, direct=0, var=0}
            end
            i = i + 1
          end
          if parents then
            parents[node] = true
          else
            parents = {[node]=true}
          end
          visitBlock2(first, 3, parents, active, lookup)
          parents[node] = nil
          return visitNodes1(node, 2, nil, lookup)
        else
          return visitNodes1(node, 1, nil, lookup)
        end
      else
        return visitNodes1(node, 1, nil, lookup)
      end
    else
      return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"key\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`")
    end
  end
end
visitNodes1 = function(node, start, parents, lookup)
  local forLimit = n1(node)
  local i = start
  while i <= forLimit do
    visitNode2(nth1(node, i), parents, nil, lookup)
    i = i + 1
  end
  return nil
end
visitBlock2 = function(node, start, parents, active, lookup)
  local forLimit = n1(node) - 1
  local i = start
  while i <= forLimit do
    visitNode2(nth1(node, i), parents, nil, lookup)
    i = i + 1
  end
  if n1(node) >= start then
    return visitNode2(last1(node), parents, active, lookup)
  else
    return nil
  end
end
letrecNodes1 = {name="letrec-nodes", help="Find letrec constructs in a list of NODES", cat={tag="list", n=1, "categorise"}, run=function(temp, compiler, nodes, state)
  return visitNodes1(nodes, 1, nil, state["rec-lookup"])
end}
letrecNode1 = {name="letrec-node", help="Find letrec constructs in a node", cat={tag="list", n=1, "categorise"}, run=function(temp, compiler, node, state)
  return visitNode2(node, nil, nil, state["rec-lookup"])
end}
nodeContainsVar_3f_1 = function(node, var)
  local found = false
  visitNode1(node, function(node1)
    if found then
      return false
    elseif type1(node1) == "list" and builtin_3f_1(car1(node1), "set!") then
      found = var == nth1(node1, 2)["var"]
      return nil
    elseif type1(node1) == "symbol" then
      found = var == node1["var"]
      return nil
    else
      return nil
    end
  end)
  return found
end
nodeContainsVars_3f_1 = function(node, vars)
  local found = false
  visitNode1(node, function(node1)
    if found then
      return false
    elseif type1(node1) == "list" and builtin_3f_1(car1(node1), "set!") then
      found = vars[nth1(node1, 2)["var"]]
      return nil
    elseif type1(node1) == "symbol" then
      found = vars[node1["var"]]
      return nil
    else
      return nil
    end
  end)
  return found
end
capturedBoundary_3f_1 = function(node)
  return type1(node) == "list" and builtin_3f_1(car1(node), "lambda")
end
nodeCaptured1 = function(node, captured, boundary_3f_)
  if not boundary_3f_ then
    boundary_3f_ = capturedBoundary_3f_1
  end
  local capturedVisitor = function(node1)
    if type1(node1) == "symbol" then
      captured[node1["var"]] = true
      return nil
    else
      return nil
    end
  end
  visitNode1(node, function(node1, visitor)
    if boundary_3f_(node1) then
      visitNode1(node1, capturedVisitor)
      return false
    elseif type1(node1) == "list" and (type1((car1(node1))) == "list" and builtin_3f_1(caar1(node1), "lambda")) then
      visitBlock1(car1(node1), 3, visitor)
      visitBlock1(node1, 2, visitor)
      return false
    else
      return true
    end
  end)
  return captured
end
partAll1 = function(xs, i, e, f)
  while true do
    if i > e then
      return true
    elseif f(nth1(xs, i)) then
      i = i + 1
    else
      return false
    end
  end
end
recurDirect_3f_1 = function(state, var)
  local rec = state["rec-lookup"][var]
  return rec and (rec["var"] == 0 and rec["direct"] == 1)
end
notCond_3f_1 = function(first, second)
  return n1(first) == 2 and (builtin_3f_1(nth1(first, 2), "false") and (n1(second) == 2 and (builtin_3f_1(nth1(second, 1), "true") and builtin_3f_1(nth1(second, 2), "true"))))
end
andCond_3f_1 = function(lookup, first, second, test)
  local branch, last, temp = car1(first), nth1(second, 2), n1(first) == 2
  return temp and (n1(second) == 2 and (not lookup[nth1(first, 2)]["stmt"] and (builtin_3f_1(car1(second), "true") and (type1(last) == "symbol" and (type1(branch) == "symbol" and branch["var"] == last["var"] or test and (not lookup[branch]["stmt"] and last["var"] == builtins1["false"]))))))
end
orCond_3f_1 = function(lookup, branch, test)
  local head, tail, temp = car1(branch), nth1(branch, 2), n1(branch) == 2
  return temp and (type1(tail) == "symbol" and (type1(head) == "symbol" and head["var"] == tail["var"] or test and (not lookup[head]["stmt"] and tail["var"] == builtins1["true"])))
end
visitNode3 = function(lookup, state, node, stmt, test, recur)
  local cat
  local temp = type1(node)
  if temp == "string" then
    cat = {category="const", prec=100}
  elseif temp == "number" then
    cat = {category="const", prec=100}
  elseif temp == "key" then
    cat = {category="const", prec=100}
  elseif temp == "symbol" then
    cat = {category="const"}
  elseif temp == "list" then
    local head = car1(node)
    local temp1 = type1(head)
    if temp1 == "symbol" then
      local func = head["var"]
      if func == builtins1["lambda"] then
        visitNodes2(lookup, state, node, 3, true)
        cat = {category="lambda", prec=100}
      elseif func == builtins1["cond"] then
        local forLimit = n1(node)
        local i = 2
        while i <= forLimit do
          local case = nth1(node, i)
          visitNode3(lookup, state, car1(case), true, true)
          visitNodes2(lookup, state, case, 2, true, test, recur)
          i = i + 1
        end
        if n1(node) == 3 and notCond_3f_1(nth1(node, 2), nth1(node, 3)) then
          addParen1(lookup, car1(nth1(node, 2)), 11)
          cat = {category="not", stmt=lookup[car1(nth1(node, 2))]["stmt"], prec=11}
        elseif n1(node) == 3 and andCond_3f_1(lookup, nth1(node, 2), nth1(node, 3), test) then
          addParen1(lookup, nth1(nth1(node, 2), 1), 2)
          addParen1(lookup, nth1(nth1(node, 2), 2), 2)
          cat = {category="and", prec=2}
        else
          local temp2
          if n1(node) >= 3 then
            if partAll1(node, 2, n1(node) - 2, function(temp3)
              return orCond_3f_1(lookup, temp3, test)
            end) then
              local first, second = nth1(node, n1(node) - 1), nth1(node, n1(node))
              temp2 = notCond_3f_1(first, second) or andCond_3f_1(lookup, first, second, test) or orCond_3f_1(lookup, first, test) and (n1(second) == 2 and (builtin_3f_1(car1(second), "true") and not lookup[nth1(second, 2)]["stmt"]))
            else
              temp2 = false
            end
          else
            temp2 = false
          end
          if temp2 then
            local len, first, second = n1(node), nth1(node, n1(node) - 1), nth1(node, n1(node))
            local forLimit = len - 2
            local i = 2
            while i <= forLimit do
              addParen1(lookup, car1(nth1(node, i)), 1)
              i = i + 1
            end
            if notCond_3f_1(first, second) then
              addParen1(lookup, nth1(first, 1), 11)
              cat = {category="or", prec=1, kind="not"}
            elseif andCond_3f_1(lookup, first, second, test) then
              addParen1(lookup, nth1(first, 1), 2)
              addParen1(lookup, nth1(first, 2), 2)
              cat = {category="or", prec=1, kind="and"}
            else
              addParen1(lookup, nth1(first, 1), 1)
              addParen1(lookup, nth1(second, 2), 1)
              cat = {category="or", prec=1, kind="or"}
            end
          elseif n1(node) == 3 and (n1(nth1(node, 2)) == 1 and (builtin_3f_1(car1(nth1(node, 3)), "true") and n1(nth1(node, 3)) > 1)) then
            addParen1(lookup, car1(nth1(node, 2)), 11)
            cat = {category="unless", stmt=true}
          else
            cat = {category="cond", stmt=true}
          end
        end
      elseif func == builtins1["set!"] then
        local def, var = nth1(node, 3), nth1(node, 2)["var"]
        if type1(def) == "list" and (builtin_3f_1(car1(def), "lambda") and state["rec-lookup"][var]) then
          local recur1 = {var=var, def=def}
          visitNodes2(lookup, state, def, 3, true, nil, recur1)
          if not recur1["tail"] then
            error1("Expected tail recursive function from letrec")
          end
          lookup[def] = {category="lambda", prec=100, recur=visitRecur1(lookup, recur1)}
        else
          visitNode3(lookup, state, def, true)
        end
        cat = {category="set!", stmt=true}
      elseif func == builtins1["quote"] then
        visitQuote3(lookup, node)
        cat = {category="quote", prec=100}
      elseif func == builtins1["syntax-quote"] then
        visitSyntaxQuote1(lookup, state, nth1(node, 2), 1)
        cat = {category="syntax-quote", prec=100}
      elseif func == builtins1["unquote"] then
        cat = error1("unquote should never appear", 0)
      elseif func == builtins1["unquote-splice"] then
        cat = error1("unquote should never appear", 0)
      elseif func == builtins1["define"] or func == builtins1["define-macro"] then
        local def = nth1(node, n1(node))
        if type1(def) == "list" and builtin_3f_1(car1(def), "lambda") then
          local recur1 = {var=node["def-var"], def=def}
          visitNodes2(lookup, state, def, 3, true, nil, recur1)
          lookup[def] = (function()
            if recur1["tail"] then
              return {category="lambda", prec=100, recur=visitRecur1(lookup, recur1)}
            else
              return {category="lambda", prec=100}
            end
          end)()
        else
          visitNode3(lookup, state, def, true)
        end
        cat = {category="define"}
      elseif func == builtins1["define-native"] then
        cat = {category="define-native"}
      elseif func == builtins1["import"] then
        cat = {category="import"}
      elseif func == builtins1["struct-literal"] then
        visitNodes2(lookup, state, node, 2, false)
        cat = {category="struct-literal", prec=100}
      elseif func == builtins1["true"] then
        visitNodes2(lookup, state, node, 1, false)
        lookup[head]["parens"] = true
        cat = {category="call"}
      elseif func == builtins1["false"] then
        visitNodes2(lookup, state, node, 1, false)
        lookup[head]["parens"] = true
        cat = {category="call"}
      elseif func == builtins1["nil"] then
        visitNodes2(lookup, state, node, 1, false)
        lookup[head]["parens"] = true
        cat = {category="call"}
      else
        local meta = func["kind"] == "native" and varNative1(func)
        if meta and (meta["bind-to"] or not stmt and meta["syntax-stmt"]) then
          meta = nil
        end
        local temp2
        if meta then
          if meta["syntax-fold"] then
            temp2 = n1(node) - 1 >= meta["syntax-arity"]
          else
            temp2 = n1(node) - 1 == meta["syntax-arity"]
          end
        else
          temp2 = false
        end
        if temp2 then
          visitNodes2(lookup, state, node, 1, false)
          local prec = meta["syntax-precedence"]
          if type1(prec) == "list" then
            addParens1(lookup, node, 2, nil, prec)
          elseif number_3f_1(prec) then
            addParens1(lookup, node, 2, prec, nil)
          end
          cat = {category="call-meta", meta=meta, stmt=meta["syntax-stmt"], prec=number_3f_1(prec) and prec}
        elseif recur and func == recur["var"] then
          recur["tail"] = true
          visitNodes2(lookup, state, node, 1, false)
          cat = {category="call-tail", recur=recur, stmt=true}
        elseif stmt and recurDirect_3f_1(state, func) then
          local rec = state["rec-lookup"][func]
          local lam = rec["lambda"]
          local recur1 = lookup[lam]["recur"]
          if not recur1 then
            print1("Cannot find recursion for ", func["name"])
          end
          local temp2 = zipArgs1(cadr1(lam), 1, node, 2)
          local forLimit = n1(temp2)
          local i = 1
          while i <= forLimit do
            local zip = temp2[i]
            local args, vals = car1(zip), cadr1(zip)
            if n1(vals) == 0 then
            elseif n1(vals) > 1 or car1(args)["var"]["is-variadic"] then
              local forLimit1 = n1(vals)
              local i1 = 1
              while i1 <= forLimit1 do
                visitNode3(lookup, state, vals[i1], false)
                i1 = i1 + 1
              end
            else
              visitNode3(lookup, state, car1(vals), true)
            end
            i = i + 1
          end
          lookup[rec["setter"]] = {category="void"}
          state["var-skip"][func] = true
          cat = {category="call-recur", recur=recur1}
        else
          visitNodes2(lookup, state, node, 1, false)
          cat = {category="call-symbol"}
        end
      end
    elseif temp1 == "list" then
      if n1(node) == 2 and (builtin_3f_1(car1(head), "lambda") and (n1(head) == 3 and (n1(nth1(head, 2)) == 1 and (not car1(nth1(head, 2))["var"]["is-variadic"] and (type1((nth1(head, 3))) == "symbol" and nth1(head, 3)["var"] == car1(nth1(head, 2))["var"]))))) then
        if visitNode3(lookup, state, nth1(node, 2), stmt, test)["stmt"] then
          lookup[head] = {category="lambda", prec=100, parens=true}
          visitNode3(lookup, state, nth1(head, 3), true, false)
          cat = {category="call-lambda", stmt=stmt}
        else
          cat = {category="wrap-value"}
        end
      elseif builtin_3f_1(car1(head), "lambda") and (n1(head) == 3 and (n1(nth1(head, 2)) == 1 and (car1(nth1(head, 2))["var"]["is-variadic"] and (type1((nth1(head, 3))) == "symbol" and (nth1(head, 3)["var"] == car1(nth1(head, 2))["var"] and (n1(node) == 1 or singleReturn_3f_1(last1(node)))))))) then
        local nodeStmt = false
        local forLimit = n1(node)
        local i = 2
        while i <= forLimit do
          if visitNode3(lookup, state, nth1(node, i), stmt, test)["stmt"] and not nodeStmt then
            nodeStmt = true
            lookup[head] = {category="lambda", prec=100, parens=true}
            visitNode3(lookup, state, nth1(head, 3), true, false)
          end
          i = i + 1
        end
        if nodeStmt then
          cat = {category="call-lambda", stmt=stmt}
        else
          cat = {category="wrap-list", prec=100}
        end
      else
        local temp2
        if n1(node) == 2 then
          if builtin_3f_1(car1(head), "lambda") then
            if n1(head) == 3 then
              if n1(nth1(head, 2)) == 1 then
                local elem = nth1(head, 3)
                temp2 = type1(elem) == "list" and (builtin_3f_1(car1(elem), "cond") and (type1((car1(nth1(elem, 2)))) == "symbol" and car1(nth1(elem, 2))["var"] == car1(nth1(head, 2))["var"]))
              else
                temp2 = false
              end
            else
              temp2 = false
            end
          else
            temp2 = false
          end
        else
          temp2 = false
        end
        if temp2 then
          if visitNode3(lookup, state, nth1(node, 2), stmt, test)["stmt"] then
            lookup[head] = {category="lambda", prec=100, parens=true}
            visitNode3(lookup, state, nth1(head, 3), true, test, recur)
            cat = {category="call-lambda", stmt=stmt}
          else
            local res = visitNode3(lookup, state, nth1(head, 3), true, test, recur)
            local ty, unused_3f_ = res["category"], function()
              local condNode, var, working = nth1(head, 3), car1(nth1(head, 2))["var"], true
              local forLimit = n1(condNode)
              local i = 2
              while i <= forLimit do
                if working then
                  local case = nth1(condNode, i)
                  local forLimit1 = n1(case)
                  local i1 = 2
                  while i1 <= forLimit1 do
                    if working then
                      local sub = nth1(case, i1)
                      if type1(sub) ~= "symbol" then
                        working = not nodeContainsVar_3f_1(sub, var)
                      end
                    end
                    i1 = i1 + 1
                  end
                end
                i = i + 1
              end
              return working
            end
            lookup[head] = {category="lambda", prec=100, parens=true}
            if ty == "and" and unused_3f_() then
              addParen1(lookup, nth1(node, 2), 2)
              cat = {category="and-lambda", prec=2}
            elseif ty == "or" and unused_3f_() then
              addParen1(lookup, nth1(node, 2), 1)
              cat = {category="or-lambda", prec=1, kind=res["kind"]}
            else
              cat = {category="call-lambda", stmt=stmt}
            end
          end
        elseif builtin_3f_1(car1(head), "lambda") then
          visitNodes2(lookup, state, head, 3, true, test, recur)
          local temp2 = zipArgs1(cadr1(head), 1, node, 2)
          local forLimit = n1(temp2)
          local i = 1
          while i <= forLimit do
            local zip = temp2[i]
            local args, vals = car1(zip), cadr1(zip)
            if n1(vals) == 0 then
            elseif n1(vals) > 1 or car1(args)["var"]["is-variadic"] then
              local forLimit1 = n1(vals)
              local i1 = 1
              while i1 <= forLimit1 do
                visitNode3(lookup, state, vals[i1], false)
                i1 = i1 + 1
              end
            else
              visitNode3(lookup, state, car1(vals), true)
            end
            i = i + 1
          end
          cat = {category="call-lambda", stmt=stmt}
        else
          visitNodes2(lookup, state, node, 1, false)
          addParen1(lookup, car1(node), 100)
          cat = {category="call"}
        end
      end
    else
      visitNodes2(lookup, state, node, 1, false)
      lookup[car1(node)]["parens"] = true
      cat = {category="call"}
    end
  else
    cat = error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"key\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`")
  end
  if cat == nil then
    error1("Node returned nil " .. pretty1(node), 0)
  end
  lookup[node] = cat
  return cat
end
visitNodes2 = function(lookup, state, nodes, start, stmt, test, recur)
  local len = n1(nodes)
  local i = start
  while i <= len do
    visitNode3(lookup, state, nth1(nodes, i), stmt, test and i == len, i == len and recur)
    i = i + 1
  end
  return nil
end
visitSyntaxQuote1 = function(lookup, state, node, level)
  if level == 0 then
    return visitNode3(lookup, state, node, false)
  else
    local cat
    local temp = type1(node)
    if temp == "string" then
      cat = {category="quote-const"}
    elseif temp == "number" then
      cat = {category="quote-const"}
    elseif temp == "key" then
      cat = {category="quote-const"}
    elseif temp == "symbol" then
      cat = {category="quote-const"}
    elseif temp == "list" then
      local temp1 = car1(node)
      if eq_3f_1(temp1, {tag="symbol", contents="unquote"}) then
        visitSyntaxQuote1(lookup, state, nth1(node, 2), level - 1)
        cat = {category="unquote"}
      elseif eq_3f_1(temp1, {tag="symbol", contents="unquote-splice"}) then
        visitSyntaxQuote1(lookup, state, nth1(node, 2), level - 1)
        cat = {category="unquote-splice"}
      elseif eq_3f_1(temp1, {tag="symbol", contents="syntax-quote"}) then
        local forLimit = n1(node)
        local i = 1
        while i <= forLimit do
          visitSyntaxQuote1(lookup, state, node[i], level + 1)
          i = i + 1
        end
        cat = {category="quote-list"}
      else
        local hasSplice = false
        local forLimit = n1(node)
        local i = 1
        while i <= forLimit do
          if visitSyntaxQuote1(lookup, state, node[i], level)["category"] == "unquote-splice" then
            hasSplice = true
          end
          i = i + 1
        end
        if hasSplice then
          cat = {category="quote-splice", stmt=true}
        else
          cat = {category="quote-list"}
        end
      end
    else
      cat = error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"key\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`")
    end
    if cat == nil then
      error1("Node returned nil " .. pretty1(node), 0)
    end
    lookup[node] = cat
    return cat
  end
end
visitQuote3 = function(lookup, node)
  if type1(node) == "list" then
    local forLimit = n1(node)
    local i = 1
    while i <= forLimit do
      visitQuote3(lookup, (node[i]))
      i = i + 1
    end
    lookup[node] = {category="quote-list"}
    return nil
  else
    lookup[node] = {category="quote-const"}
    return nil
  end
end
visitRecur1 = function(lookup, recur)
  local lam, allCaptured, argCaptured, recBoundary = recur["def"], {}, {}, function(node)
    if type1(node) == "list" and builtin_3f_1(car1(node), "lambda") then
      local cat = lookup[node]
      return not (cat and cat["recur"])
    else
      return false
    end
  end
  local forLimit = n1(lam)
  local i = 3
  while i <= forLimit do
    nodeCaptured1(nth1(lam, i), allCaptured, recBoundary)
    i = i + 1
  end
  local temp = cadr1(lam)
  local forLimit = n1(temp)
  local i = 1
  while i <= forLimit do
    local arg = temp[i]
    if allCaptured[arg["var"]] then
      argCaptured[arg["var"]] = tempVar1(arg["var"]["name"])
    end
    i = i + 1
  end
  recur["captured"] = argCaptured
  local temp
  if n1(lam) == 3 then
    local child = nth1(lam, 3)
    temp = type1(child) == "list" and (builtin_3f_1(car1(child), "cond") and (n1(child) == 3 and (builtin_3f_1(car1(nth1(child, 3)), "true") and not lookup[car1(nth1(child, 2))]["stmt"])))
  else
    temp = false
  end
  if temp then
    local fstCase, sndCase = nth1(nth1(lam, 3), 2), nth1(nth1(lam, 3), 3)
    local fst, snd = n1(fstCase) >= 2 and justRecur_3f_1(lookup, last1(fstCase), recur), n1(sndCase) >= 2 and justRecur_3f_1(lookup, last1(sndCase), recur)
    if fst and snd then
      recur["category"] = "forever"
    elseif fst then
      recur["category"] = "while"
    elseif snd then
      recur["category"] = "while-not"
    else
      recur["category"] = "forever"
    end
  else
    recur["category"] = "forever"
  end
  return recur
end
justRecur_3f_1 = function(lookup, node, recur)
  while true do
    if type1(node) == "list" then
      local cat, head = lookup[node], car1(node)
      if cat["category"] == "call-tail" then
        if cat["recur"] ~= recur then
          error1("Incorrect recur")
        end
        return true
      elseif type1(head) == "list" and builtin_3f_1(car1(head), "lambda") then
        local temp = n1(head) >= 3
        if temp then
          node = last1(head)
        else
          return temp
        end
      elseif builtin_3f_1(head, "cond") then
        local found = true
        local forLimit = n1(node)
        local i = 2
        while i <= forLimit do
          if found then
            local case = nth1(node, i)
            found = n1(case) >= 2 and justRecur_3f_1(lookup, last1(case), recur)
          end
          i = i + 1
        end
        return found
      else
        return false
      end
    else
      return false
    end
  end
end
addParens1 = function(lookup, nodes, start, prec, precs)
  local forLimit = n1(nodes)
  local i = start
  while i <= forLimit do
    local childCat = lookup[nth1(nodes, i)]
    if childCat["prec"] and childCat["prec"] <= (function()
      if precs then
        return nth1(precs, i - 1)
      else
        return prec
      end
    end)() then
      childCat["parens"] = true
    end
    i = i + 1
  end
  return nil
end
addParen1 = function(lookup, node, prec)
  local childCat = lookup[node]
  if childCat["prec"] and childCat["prec"] <= prec then
    childCat["parens"] = true
    return nil
  else
    return nil
  end
end
categoriseNodes1 = {name="categorise-nodes", help="Categorise a group of NODES, annotating their appropriate node type.", cat={tag="list", n=1, "categorise"}, run=function(temp, compiler, nodes, state)
  return visitNodes2(state["cat-lookup"], state, nodes, 1, true)
end}
categoriseNode1 = {name="categorise-node", help="Categorise a NODE, annotating it's appropriate node type.", cat={tag="list", n=1, "categorise"}, run=function(temp, compiler, node, state, stmt)
  return visitNode3(state["cat-lookup"], state, node, stmt)
end}
formatRange1 = function(range)
  if range["finish"] then
    return format1("%s:[%s .. %s]", range["name"], (function()
      local pos = range["start"]
      return pos["line"] .. ":" .. pos["column"]
    end)(), (function()
      local pos = range["finish"]
      return pos["line"] .. ":" .. pos["column"]
    end)())
  else
    return format1("%s:[%s]", range["name"], (function()
      local pos = range["start"]
      return pos["line"] .. ":" .. pos["column"]
    end)())
  end
end
formatNodeSource1 = function(source)
  local owner, range = source["owner"], sourceFullRange1(source)
  local rangef
  if range then
    rangef = formatRange1(range)
  else
    rangef = "?"
  end
  if owner then
    return format1("macro expansion of %s (at %s)", owner["name"], rangef)
  else
    return format1("unquote expansion (at %s)", rangef)
  end
end
formatNodeSourceName1 = function(source)
  local owner = source["owner"]
  if owner then
    return owner["name"]
  else
    return "?"
  end
end
formatSource1 = function(source)
  local temp = type1(source)
  if temp == "node-source" then
    return formatNodeSource1(source)
  elseif temp == "range" then
    return formatRange1(source)
  elseif temp == "nil" then
    return "?"
  else
    return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"node-source\"`\n  Tried: `\"range\"`\n  Tried: `\"nil\"`")
  end
end
formatNode1 = function(node)
  if node then
    return formatSource1(node["source"])
  else
    return "?"
  end
end
keywords1 = createLookup1({tag="list", n=21, "and", "break", "do", "else", "elseif", "end", "false", "for", "function", "if", "in", "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while"})
luaIdent_3f_1 = function(ident)
  return match1(ident, "^[%a_][%w_]*$") and keywords1[ident] == nil
end
escape1 = function(name)
  if name == "" then
    return "_e"
  elseif keywords1[name] then
    return "_e" .. name
  elseif find1(name, "^%a%w*$") then
    return name
  else
    local out
    if find1(sub1(name, 1, 1), "%d") then
      out = "_e"
    else
      out = ""
    end
    local upper, esc = false, false
    local forLimit = n1(name)
    local i = 1
    while i <= forLimit do
      local char = sub1(name, i, i)
      if char == "-" and (find1((function()
        local x = i - 1
        return sub1(name, x, x)
      end)(), "[%a%d']") and find1((function()
        local x = i + 1
        return sub1(name, x, x)
      end)(), "[%a%d']")) then
        upper = true
      elseif find1(char, "[^%w%d]") then
        char = format1("%02x", (byte1(char)))
        upper = false
        if not esc then
          esc = true
          out = out .. "_"
        end
        out = out .. char
      else
        if esc then
          esc = false
          out = out .. "_"
        end
        if upper then
          upper = false
          char = upper1(char)
        end
        out = out .. char
      end
      i = i + 1
    end
    if esc then
      out = out .. "_"
    end
    return out
  end
end
pushEscapeVar_21_1 = function(var, state, forceNum)
  local temp = state["var-lookup"][var]
  if temp then
    return temp
  else
    local esc = escape1(var["display-name"] or var["name"])
    local existing = state["var-cache"][esc]
    if forceNum or existing then
      local ctr, finding = 1, true
      while finding do
        local esc_27_ = esc .. ctr
        if state["var-cache"][esc_27_] then
          ctr = ctr + 1
        else
          finding = false
          esc = esc_27_
        end
      end
    end
    state["var-cache"][esc] = true
    state["var-lookup"][var] = esc
    return esc
  end
end
popEscapeVar_21_1 = function(var, state)
  local esc = state["var-lookup"][var]
  if not esc then
    error1(var["name"] .. " has not been escaped (when popping).", 0)
  end
  state["var-cache"][esc] = nil
  state["var-lookup"][var] = nil
  return nil
end
renameEscapeVar_21_1 = function(from, to, state)
  local esc = state["var-lookup"][from]
  if not esc then
    error1(from["name"] .. " has not been escaped (when renaming).", 0)
  end
  if state["var-lookup"][to] then
    error1(to["name"] .. " already has a name (when renaming).", 0)
  end
  state["var-lookup"][from] = nil
  state["var-lookup"][to] = esc
  return nil
end
escapeVar1 = function(var, state)
  if builtinVars1[var] ~= nil then
    return var["name"]
  else
    local esc = state["var-lookup"][var]
    if not esc then
      formatOutput_21_1(1, "" .. var["name"] .. " has not been escaped (at " .. (function()
        if var["node"] then
          return formatNode1(var["node"])
        else
          return "?"
        end
      end)() .. ")")
    end
    return esc
  end
end
createPassState1 = function(state)
  return {["var-cache"]=state["var-cache"], ["var-lookup"]=state["var-lookup"], ["var-skip"]={}, ["cat-lookup"]={}, ["rec-lookup"]={}}
end
symVariadic_3f_1 = function(sym)
  return sym["var"]["is-variadic"]
end
breakCategories1 = {cond=true, unless=true, ["call-lambda"]=true, ["call-tail"]=true}
constCategories1 = {const=true, quote=true, ["quote-const"]=true}
compileNativeFold1 = function(out, meta, a, b)
  local temp = meta["syntax"]
  local forLimit = n1(temp)
  local i = 1
  while i <= forLimit do
    local entry = temp[i]
    if entry == 1 then
      append_21_1(out, a)
    elseif entry == 2 then
      append_21_1(out, b)
    elseif string_3f_1(entry) then
      append_21_1(out, entry)
    else
      error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(entry) .. ", but none matched.\n" .. "  Tried: `1`\n  Tried: `2`\n  Tried: `string?`")
    end
    i = i + 1
  end
  return nil
end
compileNative1 = function(out, var, meta)
  if meta["bind-to"] then
    return append_21_1(out, meta["bind-to"], out["active-pos"])
  elseif meta["syntax"] then
    append_21_1(out, "function(")
    if meta["syntax-fold"] then
      append_21_1(out, "x, ...")
    else
      local forLimit = meta["syntax-arity"]
      local i = 1
      while i <= forLimit do
        if i ~= 1 then
          append_21_1(out, ", ")
        end
        append_21_1(out, "v" .. tonumber1(i))
        i = i + 1
      end
    end
    append_21_1(out, ") ")
    local temp = meta["syntax-fold"]
    if temp == nil then
      if not meta["syntax-stmt"] then
        append_21_1(out, "return ")
      end
      local temp1 = meta["syntax"]
      local forLimit = n1(temp1)
      local i = 1
      while i <= forLimit do
        local entry = temp1[i]
        if number_3f_1(entry) then
          append_21_1(out, "v" .. tonumber1(entry))
        else
          append_21_1(out, entry)
        end
        i = i + 1
      end
    elseif temp == "left" then
      append_21_1(out, "local t = ")
      compileNativeFold1(out, meta, "x", "...")
      append_21_1(out, " for i = 2, _select('#', ...) do t = ")
      compileNativeFold1(out, meta, "t", "_select(i, ...)")
      append_21_1(out, " end return t")
    elseif temp == "right" then
      append_21_1(out, "local n = _select('#', ...) local t = _select(n, ...) for i = n - 1, 1, -1 do t = ")
      compileNativeFold1(out, meta, "_select(i, ...)", "t")
      append_21_1(out, " end return ")
      compileNativeFold1(out, meta, "x", "t")
    else
      error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `nil`\n  Tried: `\"left\"`\n  Tried: `\"right\"`")
    end
    return append_21_1(out, " end")
  else
    append_21_1(out, "_libs[")
    append_21_1(out, quoted1(var["unique-name"]))
    return append_21_1(out, "]")
  end
end
compileExpression1 = function(node, out, state, ret, _ebreak)
  local catLookup = state["cat-lookup"]
  local cat = catLookup[node]
  local _5f_
  if cat then
    _5f_ = nil
  else
    _5f_ = print1("Cannot find", pretty1(node), formatNode1(node))
  end
  local catTag = cat["category"]
  pushNode_21_1(out, node)
  if catTag == "void" then
    if not (ret == "") then
      if ret then
        append_21_1(out, ret)
      end
      append_21_1(out, "nil")
    end
  elseif catTag == "const" then
    if not (ret == "") then
      if ret then
        append_21_1(out, ret, out["active-pos"])
      end
      if cat["parens"] then
        append_21_1(out, "(")
      end
      if type1(node) == "symbol" then
        append_21_1(out, escapeVar1(node["var"], state), out["active-pos"])
      elseif string_3f_1(node) then
        append_21_1(out, quoted1(node["value"]), out["active-pos"])
      elseif number_3f_1(node) then
        append_21_1(out, tostring1(node["value"]), out["active-pos"])
      elseif type1(node) == "key" then
        append_21_1(out, quoted1(node["value"]), out["active-pos"])
      else
        error1("Unknown type: " .. type1(node))
      end
      if cat["parens"] then
        append_21_1(out, ")")
      end
    end
  elseif catTag == "lambda" then
    if not (ret == "") then
      if ret then
        local pos = sourceRange1(node["source"])
        append_21_1(out, ret, pos and rangeOfStart1(pos))
      end
      local args, variadic, i = nth1(node, 2), nil, 1
      if cat["parens"] then
        append_21_1(out, "(")
      end
      append_21_1(out, "function(")
      while i <= n1(args) and not variadic do
        if i > 1 then
          append_21_1(out, ", ")
        end
        local var = args[i]["var"]
        if var["is-variadic"] then
          append_21_1(out, "...")
          variadic = i
        else
          append_21_1(out, pushEscapeVar_21_1(var, state))
        end
        i = i + 1
      end
      beginBlock_21_1(out, ")")
      if variadic then
        local argsVar = pushEscapeVar_21_1(args[variadic]["var"], state)
        if variadic == n1(args) then
          line_21_1(out, "local " .. argsVar .. " = _pack(...) " .. argsVar .. ".tag = \"list\"")
        else
          line_21_1(out, "local _n = _select(\"#\", ...) - " .. tostring1((n1(args) - variadic)))
          append_21_1(out, "local " .. argsVar)
          local forStart, forLimit = variadic + 1, n1(args)
          local i1 = forStart
          while i1 <= forLimit do
            append_21_1(out, ", ")
            append_21_1(out, pushEscapeVar_21_1(args[i1]["var"], state))
            i1 = i1 + 1
          end
          line_21_1(out)
          beginBlock_21_1(out, "if _n > 0 then")
          append_21_1(out, argsVar)
          line_21_1(out, " = {tag=\"list\", n=_n, _unpack(_pack(...), 1, _n)}")
          local forStart, forLimit = variadic + 1, n1(args)
          local i1 = forStart
          while i1 <= forLimit do
            append_21_1(out, escapeVar1(args[i1]["var"], state))
            if i1 < n1(args) then
              append_21_1(out, ", ")
            end
            i1 = i1 + 1
          end
          line_21_1(out, " = select(_n + 1, ...)")
          nextBlock_21_1(out, "else")
          append_21_1(out, argsVar)
          line_21_1(out, " = {tag=\"list\", n=0}")
          local forStart, forLimit = variadic + 1, n1(args)
          local i1 = forStart
          while i1 <= forLimit do
            append_21_1(out, escapeVar1(args[i1]["var"], state))
            if i1 < n1(args) then
              append_21_1(out, ", ")
            end
            i1 = i1 + 1
          end
          line_21_1(out, " = ...")
          endBlock_21_1(out, "end")
        end
      end
      if cat["recur"] then
        compileRecur1(cat["recur"], out, state, "return ")
      else
        compileBlock1(node, out, state, 3, "return ")
      end
      out["indent"] = out["indent"] - 1
      local forLimit = n1(args)
      local i1 = 1
      while i1 <= forLimit do
        popEscapeVar_21_1(args[i1]["var"], state)
        i1 = i1 + 1
      end
      append_21_1(out, "end")
      if cat["parens"] then
        append_21_1(out, ")")
      end
    end
  elseif catTag == "cond" then
    local closure, hadFinal, ends = not ret, false, 1
    if closure then
      beginBlock_21_1(out, "(function()")
      ret = "return "
    end
    local i = 2
    while not hadFinal and i <= n1(node) do
      local item = nth1(node, i)
      local case = nth1(item, 1)
      local isFinal = builtin_3f_1(case, "true")
      if i > 2 and (not isFinal or ret ~= "" or _ebreak or n1(item) ~= 1 and fastAny1(function(x)
        return not constCategories1[catLookup[x]["category"]]
      end, item, 2)) then
        append_21_1(out, "else")
      end
      if isFinal then
        if i == 2 then
          append_21_1(out, "do")
        end
      elseif catLookup[case]["stmt"] then
        if i > 2 then
          out["indent"] = out["indent"] + 1
          line_21_1(out)
          ends = ends + 1
        end
        local var = tempVar1("temp", node)
        local tmp = pushEscapeVar_21_1(var, state)
        line_21_1(out, "local " .. tmp)
        compileExpression1(case, out, state, tmp .. " = ")
        line_21_1(out)
        popEscapeVar_21_1(var, state)
        line_21_1(out, "if " .. tmp .. " then")
      else
        append_21_1(out, "if ")
        compileExpression1(case, out, state)
        append_21_1(out, " then")
      end
      out["indent"] = out["indent"] + 1
      line_21_1(out)
      compileBlock1(item, out, state, 2, ret, _ebreak)
      out["indent"] = out["indent"] - 1
      if isFinal then
        hadFinal = true
      end
      i = i + 1
    end
    if not hadFinal then
      append_21_1(out, "else")
      out["indent"] = out["indent"] + 1
      line_21_1(out)
      local source = sourceRange1(node["source"])
      append_21_1(out, "_error(\"unmatched item\")", source and rangeOfStart1(source))
      out["indent"] = out["indent"] - 1
      line_21_1(out)
    end
    local forLimit = ends
    local i = 1
    while i <= forLimit do
      append_21_1(out, "end")
      if i < ends then
        out["indent"] = out["indent"] - 1
        line_21_1(out)
      end
      i = i + 1
    end
    if closure then
      line_21_1(out)
      out["indent"] = out["indent"] - 1
      append_21_1(out, "end)()")
    end
  elseif catTag == "unless" then
    local closure = not ret
    if closure then
      beginBlock_21_1(out, "(function()")
      ret = "return "
    end
    local test = car1(nth1(node, 2))
    if catLookup[test]["stmt"] then
      local var = tempVar1("temp", node)
      local tmp = pushEscapeVar_21_1(var, state)
      line_21_1(out, "local " .. tmp)
      compileExpression1(test, out, state, tmp .. " = ")
      line_21_1(out)
      popEscapeVar_21_1(var, state)
      if _ebreak or ret and ret ~= "" then
        beginBlock_21_1(out, formatOutput_21_1(nil, "if " .. tmp .. " then"))
        compileBlock1(nth1(node, 2), out, state, 2, ret, _ebreak)
        nextBlock_21_1(out, "else")
      else
        beginBlock_21_1(out, formatOutput_21_1(nil, "if not " .. tmp .. " then"))
      end
    elseif _ebreak or ret and ret ~= "" then
      append_21_1(out, "if ")
      compileExpression1(test, out, state)
      beginBlock_21_1(out, " then")
      compileBlock1(nth1(node, 2), out, state, 2, ret, _ebreak)
      nextBlock_21_1(out, "else")
    else
      append_21_1(out, "if not ")
      compileExpression1(test, out, state)
      beginBlock_21_1(out, " then")
    end
    compileBlock1(nth1(node, 3), out, state, 2, ret, _ebreak)
    endBlock_21_1(out, "end")
    if closure then
      line_21_1(out)
      out["indent"] = out["indent"] - 1
      append_21_1(out, "end)()")
    end
  elseif catTag == "not" then
    if cat["parens"] then
      append_21_1(out, "(")
    end
    if ret then
      ret = ret .. "not "
    else
      append_21_1(out, "not ")
    end
    compileExpression1(car1(nth1(node, 2)), out, state, ret)
    if cat["parens"] then
      append_21_1(out, ")")
    end
  elseif catTag == "or" then
    if ret then
      append_21_1(out, ret)
    end
    if cat["parens"] then
      append_21_1(out, "(")
    end
    local len = n1(node)
    local forLimit = len - 2
    local i = 2
    while i <= forLimit do
      compileExpression1(car1(nth1(node, i)), out, state)
      append_21_1(out, " or ")
      i = i + 1
    end
    local temp = cat["kind"]
    if temp == "not" then
      append_21_1(out, "not ")
      compileExpression1(nth1(nth1(node, len - 1), 1), out, state)
    elseif temp == "and" then
      compileExpression1(nth1(nth1(node, len - 1), 1), out, state)
      append_21_1(out, " and ")
      compileExpression1(nth1(nth1(node, len - 1), 2), out, state)
    elseif temp == "or" then
      compileExpression1(nth1(nth1(node, len - 1), 1), out, state)
      append_21_1(out, " or ")
      compileExpression1(nth1(nth1(node, len), 2), out, state)
    else
      error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"not\"`\n  Tried: `\"and\"`\n  Tried: `\"or\"`")
    end
    if cat["parens"] then
      append_21_1(out, ")")
    end
  elseif catTag == "or-lambda" then
    if ret then
      append_21_1(out, ret)
    end
    if cat["parens"] then
      append_21_1(out, "(")
    end
    compileExpression1(nth1(node, 2), out, state)
    local branch = nth1(car1(node), 3)
    local len = n1(branch)
    append_21_1(out, " or ")
    local forLimit = len - 2
    local i = 3
    while i <= forLimit do
      compileExpression1(car1(nth1(branch, i)), out, state)
      append_21_1(out, " or ")
      i = i + 1
    end
    local temp = cat["kind"]
    if temp == "not" then
      append_21_1(out, "not ")
      compileExpression1(nth1(nth1(branch, len - 1), 1), out, state)
    elseif temp == "and" then
      compileExpression1(nth1(nth1(branch, len - 1), 1), out, state)
      append_21_1(out, " and ")
      compileExpression1(nth1(nth1(branch, len - 1), 2), out, state)
    elseif temp == "or" then
      if len > 3 then
        compileExpression1(nth1(nth1(branch, len - 1), 1), out, state)
        append_21_1(out, " or ")
      end
      compileExpression1(nth1(nth1(branch, len), 2), out, state)
    else
      error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"not\"`\n  Tried: `\"and\"`\n  Tried: `\"or\"`")
    end
    if cat["parens"] then
      append_21_1(out, ")")
    end
  elseif catTag == "and" then
    if ret then
      append_21_1(out, ret)
    end
    if cat["parens"] then
      append_21_1(out, "(")
    end
    compileExpression1(nth1(nth1(node, 2), 1), out, state)
    append_21_1(out, " and ")
    compileExpression1(nth1(nth1(node, 2), 2), out, state)
    if cat["parens"] then
      append_21_1(out, ")")
    end
  elseif catTag == "and-lambda" then
    if ret then
      append_21_1(out, ret)
    end
    if cat["parens"] then
      append_21_1(out, "(")
    end
    compileExpression1(nth1(node, 2), out, state)
    append_21_1(out, " and ")
    compileExpression1(nth1(nth1(nth1(car1(node), 3), 2), 2), out, state)
    if cat["parens"] then
      append_21_1(out, ")")
    end
  elseif catTag == "set!" then
    if not ret then
      beginBlock_21_1(out, "(function()")
    end
    compileExpression1(nth1(node, 3), out, state, escapeVar1(node[2]["var"], state) .. " = ")
    if not ret then
      line_21_1(out)
      out["indent"] = out["indent"] - 1
      append_21_1(out, "end)()")
    elseif ret == "" then
    else
      line_21_1(out)
      append_21_1(out, ret)
      append_21_1(out, "nil")
    end
  elseif catTag == "struct-literal" then
    if ret == "" then
      append_21_1(out, "local _ = ")
    elseif ret then
      append_21_1(out, ret)
    end
    if cat["parens"] then
      append_21_1(out, "(")
    end
    local temp = n1(node)
    if temp == 1 then
      append_21_1(out, "{}", out["active-pos"])
    else
      append_21_1(out, "{")
      local i = 2
      while i <= temp do
        if i > 2 then
          append_21_1(out, ", ")
        end
        local key = nth1(node, i)
        local tkey = type1(key)
        if (tkey == "string" or tkey == "key") and luaIdent_3f_1(key["value"]) then
          append_21_1(out, key["value"])
          append_21_1(out, "=")
        else
          append_21_1(out, "[")
          compileExpression1(key, out, state)
          append_21_1(out, "]=")
        end
        compileExpression1(nth1(node, i + 1), out, state)
        i = i + 2
      end
      append_21_1(out, "}")
    end
    if cat["parens"] then
      append_21_1(out, ")")
    end
  elseif catTag == "define" then
    compileExpression1(nth1(node, n1(node)), out, state, pushEscapeVar_21_1(node["def-var"], state) .. " = ")
  elseif catTag == "define-native" then
    local var = node["def-var"]
    append_21_1(out, format1("%s = ", escapeVar1(var, state)), out["active-pos"])
    compileNative1(out, var, varNative1(var))
  elseif catTag == "quote" then
    if not (ret == "") then
      if ret then
        append_21_1(out, ret)
      end
      if cat["parens"] then
        append_21_1(out, "(")
      end
      compileExpression1(nth1(node, 2), out, state)
      if cat["parens"] then
        append_21_1(out, ")")
      end
    end
  elseif catTag == "quote-const" then
    if not (ret == "") then
      if ret then
        append_21_1(out, ret)
      end
      if cat["parens"] then
        append_21_1(out, "(")
      end
      local temp = type1(node)
      if temp == "string" then
        append_21_1(out, quoted1(node["value"]), out["active-pos"])
      elseif temp == "number" then
        append_21_1(out, tostring1(node["value"]), out["active-pos"])
      elseif temp == "symbol" then
        append_21_1(out, "{tag=\"symbol\", contents=" .. quoted1(node["contents"]), out["active-pos"])
        if node["var"] then
          append_21_1(out, ", var=" .. quoted1(tostring1(node["var"])), out["active-pos"])
        end
        append_21_1(out, "}", out["active-pos"])
      elseif temp == "key" then
        append_21_1(out, "{tag=\"key\", value=" .. quoted1(node["value"]) .. "}", out["active-pos"])
      else
        error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"symbol\"`\n  Tried: `\"key\"`")
      end
      if cat["parens"] then
        append_21_1(out, ")")
      end
    end
  elseif catTag == "quote-list" then
    if ret == "" then
      append_21_1(out, "local _ = ")
    elseif ret then
      append_21_1(out, ret)
    end
    local temp = n1(node)
    if temp == 0 then
      append_21_1(out, "{tag=\"list\", n=0}", out["active-pos"])
    else
      append_21_1(out, "{tag=\"list\", n=" .. tostring1(temp))
      local forLimit = n1(node)
      local i = 1
      while i <= forLimit do
        local sub = node[i]
        append_21_1(out, ", ")
        compileExpression1(sub, out, state)
        i = i + 1
      end
      append_21_1(out, "}")
    end
  elseif catTag == "quote-splice" then
    if not ret then
      beginBlock_21_1(out, "(function()")
    end
    line_21_1(out, "local _offset, _result, _temp = 0, {tag=\"list\"}")
    local offset = 0
    local forLimit = n1(node)
    local i = 1
    while i <= forLimit do
      local sub = nth1(node, i)
      local cat1 = state["cat-lookup"][sub]
      if not cat1 then
        print1("Cannot find", pretty1(sub), formatNode1(sub))
      end
      if cat1["category"] == "unquote-splice" then
        offset = offset + 1
        append_21_1(out, "_temp = ")
        compileExpression1(nth1(sub, 2), out, state)
        line_21_1(out)
        local pos = sourceRange1(sub["source"])
        append_21_1(out, "for _c = 1, _temp.n do _result[" .. tostring1(i - offset) .. " + _c + _offset] = _temp[_c] end", pos and rangeOfStart1(pos))
        line_21_1(out)
        line_21_1(out, "_offset = _offset + _temp.n")
      else
        append_21_1(out, "_result[" .. tostring1(i - offset) .. " + _offset] = ")
        compileExpression1(sub, out, state)
        line_21_1(out)
      end
      i = i + 1
    end
    line_21_1(out, "_result.n = _offset + " .. tostring1(n1(node) - offset))
    if ret == "" then
    elseif ret then
      append_21_1(out, ret .. "_result")
    else
      line_21_1(out, "return _result")
      endBlock_21_1(out, "end)()")
    end
  elseif catTag == "syntax-quote" then
    if cat["parens"] then
      append_21_1(out, "(")
    end
    compileExpression1(nth1(node, 2), out, state, ret)
    if cat["parens"] then
      append_21_1(out, ")")
    end
  elseif catTag == "unquote" then
    compileExpression1(nth1(node, 2), out, state, ret)
  elseif catTag == "unquote-splice" then
    error1("Should never have explicit unquote-splice", 0)
  elseif catTag == "import" then
    if ret == nil then
      append_21_1(out, "nil")
    elseif ret ~= "" then
      append_21_1(out, ret)
      append_21_1(out, "nil")
    end
  elseif catTag == "call-symbol" then
    local head = car1(node)
    if ret then
      append_21_1(out, ret)
    end
    compileExpression1(head, out, state)
    append_21_1(out, "(")
    local forLimit = n1(node)
    local i = 2
    while i <= forLimit do
      if i > 2 then
        append_21_1(out, ", ")
      end
      compileExpression1(nth1(node, i), out, state)
      i = i + 1
    end
    append_21_1(out, ")")
  elseif catTag == "call-meta" then
    local meta = cat["meta"]
    if meta["syntax-stmt"] then
    elseif ret == "" then
      append_21_1(out, "local _ = ")
    elseif ret then
      append_21_1(out, ret)
    end
    if cat["parens"] then
      append_21_1(out, "(")
    end
    local contents, fold, count, build = meta["syntax"], meta["syntax-fold"], meta["syntax-arity"]
    build = function(start, _eend)
      local forLimit = n1(contents)
      local i = 1
      while i <= forLimit do
        local entry = contents[i]
        if string_3f_1(entry) then
          append_21_1(out, entry)
        elseif fold == "left" and (entry == 1 and start < _eend) then
          build(start, _eend - 1)
          start = _eend
        elseif fold == "right" and (entry == 2 and start < _eend) then
          build(start + 1, _eend)
        else
          compileExpression1(nth1(node, entry + start), out, state)
        end
        i = i + 1
      end
      return nil
    end
    build(1, n1(node) - count)
    if cat["parens"] then
      append_21_1(out, ")")
    end
    if meta["syntax-stmt"] and ret ~= "" then
      line_21_1(out)
      append_21_1(out, ret)
      append_21_1(out, "nil")
      line_21_1(out)
    end
  elseif catTag == "call-recur" then
    if ret == nil then
      print1(pretty1(node), " marked as call-recur for ", ret)
    end
    local args = nth1(cat["recur"]["def"], 2)
    compileBind1(args, 1, node, 2, out, state)
    if ret == "return " then
      compileRecur1(cat["recur"], out, state, "return ")
    else
      compileRecur1(cat["recur"], out, state, ret, cat["recur"])
    end
    local forLimit = n1(args)
    local i = 1
    while i <= forLimit do
      local arg = args[i]
      if not state["var-skip"][arg["var"]] then
        popEscapeVar_21_1(arg["var"], state)
      end
      i = i + 1
    end
  elseif catTag == "call-tail" then
    if ret == nil then
      print1(pretty1(node), " marked as call-tail for ", ret)
    end
    if _ebreak and _ebreak ~= cat["recur"] then
      print1(pretty1(node) .. " Got a different break then defined for.\n  Expected: " .. pretty1(cat["recur"]["def"]) .. "\n       Got: " .. pretty1(_ebreak["def"]))
    end
    local zipped, mapping, packArgs = zipArgs1(cadr1(cat["recur"]["def"]), 1, node, 2), cat["recur"]["captured"], nil
    local forStart = n1(zipped)
    local i = forStart
    while i >= 1 do
      local zip = nth1(zipped, i)
      local args, vals = car1(zip), cadr1(zip)
      if n1(args) == 1 and (n1(vals) == 1 and (type1((car1(vals))) == "symbol" and (car1(args)["var"] == car1(vals)["var"] and mapping[car1(vals)["var"]] == nil))) then
        removeNth_21_1(zipped, i)
      elseif any1(symVariadic_3f_1, args) then
        packArgs = args
      end
      i = i + -1
    end
    if empty_3f_1(zipped) then
    elseif n1(zipped) == 1 and empty_3f_1(caar1(zipped)) then
      local temp = cadar1(zipped)
      local forLimit = n1(temp)
      local i = 1
      while i <= forLimit do
        compileExpression1(temp[i], out, state, "")
        line_21_1(out)
        i = i + 1
      end
    else
      if packArgs and n1(packArgs) > 1 then
        if n1(zipped) == 1 then
          append_21_1(out, "local ")
        else
          line_21_1(out, "local _p")
        end
      end
      local first, forLimit = true, n1(zipped)
      local i = 1
      while i <= forLimit do
        local zip = zipped[i]
        local args = car1(zip)
        if args == packArgs and n1(args) > 1 then
          if first then
            first = false
          else
            append_21_1(out, ", ")
          end
          append_21_1(out, "_p")
        else
          local temp = car1(zip)
          local forLimit1 = n1(temp)
          local i1 = 1
          while i1 <= forLimit1 do
            local arg = temp[i1]
            if first then
              first = false
            else
              append_21_1(out, ", ")
            end
            append_21_1(out, escapeVar1(mapVar1(mapping, arg["var"]), state))
            i1 = i1 + 1
          end
        end
        i = i + 1
      end
      append_21_1(out, " = ")
      local first, packZip = true, nil
      local forLimit = n1(zipped)
      local i = 1
      while i <= forLimit do
        local zip = zipped[i]
        if first then
          first = false
        else
          append_21_1(out, ", ")
        end
        local args, vals = car1(zip), cadr1(zip)
        if any1(symVariadic_3f_1, args) then
          packZip = zip
          append_21_1(out, "_pack(")
          local forLimit1 = n1(vals)
          local i1 = 1
          while i1 <= forLimit1 do
            if i1 > 1 then
              append_21_1(out, ", ")
            end
            compileExpression1(nth1(vals, i1), out, state)
            i1 = i1 + 1
          end
          append_21_1(out, ")")
        elseif empty_3f_1(vals) then
          append_21_1(out, "nil")
        else
          local forLimit1 = n1(vals)
          local i1 = 1
          while i1 <= forLimit1 do
            if i1 > 1 then
              append_21_1(out, ", ")
            end
            compileExpression1(nth1(vals, i1), out, state)
            i1 = i1 + 1
          end
        end
        i = i + 1
      end
      line_21_1(out)
      if packZip == nil then
      elseif n1(car1(packZip)) == 1 then
        append_21_1(out, escapeVar1(mapVar1(mapping, caar1(packZip)["var"]), state))
        append_21_1(out, ".tag = \"list\"")
        line_21_1(out)
      else
        local args = car1(packZip)
        local varIdx = findIndex1(symVariadic_3f_1, args)
        if varIdx > 1 then
          local forLimit = varIdx - 1
          local i = 1
          while i <= forLimit do
            if i > 1 then
              append_21_1(out, ", ")
            end
            append_21_1(out, escapeVar1(mapVar1(mapping, nth1(args, i)["var"]), state))
            i = i + 1
          end
          append_21_1(out, " = ")
          local forLimit = varIdx - 1
          local i = 1
          while i <= forLimit do
            if i > 1 then
              append_21_1(out, ", ")
            end
            append_21_1(out, format1("_p[%d]", i))
            i = i + 1
          end
          line_21_1(out)
        end
        compileBindVariadic1(out, car1(packZip), cadr1(packZip), state, mapping)
      end
    end
  elseif catTag == "wrap-value" then
    if ret then
      append_21_1(out, ret)
    end
    append_21_1(out, "(")
    compileExpression1(nth1(node, 2), out, state)
    append_21_1(out, ")")
  elseif catTag == "wrap-list" then
    if ret then
      append_21_1(out, ret)
    end
    if cat["parens"] then
      append_21_1(out, "(")
    end
    append_21_1(out, "{tag=\"list\", n=")
    append_21_1(out, tostring1(n1(node) - 1))
    local forLimit = n1(node)
    local i = 2
    while i <= forLimit do
      append_21_1(out, ", ")
      compileExpression1(nth1(node, i), out, state)
      i = i + 1
    end
    append_21_1(out, "}")
    if cat["parens"] then
      append_21_1(out, ")")
    end
  elseif catTag == "call-lambda" then
    local empty = ret == nil
    if empty then
      ret = "return "
      beginBlock_21_1(out, "(function()")
    end
    local head = car1(node)
    local args = nth1(head, 2)
    compileBind1(args, 1, node, 2, out, state)
    compileBlock1(head, out, state, 3, ret, _ebreak)
    local forLimit = n1(args)
    local i = 1
    while i <= forLimit do
      local arg = args[i]
      if not state["var-skip"][arg["var"]] then
        popEscapeVar_21_1(arg["var"], state)
      end
      i = i + 1
    end
    if empty then
      out["indent"] = out["indent"] - 1
      append_21_1(out, "end)()")
    end
  elseif catTag == "call" then
    if ret then
      append_21_1(out, ret)
    end
    compileExpression1(car1(node), out, state)
    append_21_1(out, "(")
    local forLimit = n1(node)
    local i = 2
    while i <= forLimit do
      if i > 2 then
        append_21_1(out, ", ")
      end
      compileExpression1(nth1(node, i), out, state)
      i = i + 1
    end
    append_21_1(out, ")")
  else
    error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(catTag) .. ", but none matched.\n" .. "  Tried: `\"void\"`\n  Tried: `\"const\"`\n  Tried: `\"lambda\"`\n  Tried: `\"cond\"`\n  Tried: `\"unless\"`\n  Tried: `\"not\"`\n  Tried: `\"or\"`\n  Tried: `\"or-lambda\"`\n  Tried: `\"and\"`\n  Tried: `\"and-lambda\"`\n  Tried: `\"set!\"`\n  Tried: `\"struct-literal\"`\n  Tried: `\"define\"`\n  Tried: `\"define-native\"`\n  Tried: `\"quote\"`\n  Tried: `\"quote-const\"`\n  Tried: `\"quote-list\"`\n  Tried: `\"quote-splice\"`\n  Tried: `\"syntax-quote\"`\n  Tried: `\"unquote\"`\n  Tried: `\"unquote-splice\"`\n  Tried: `\"import\"`\n  Tried: `\"call-symbol\"`\n  Tried: `\"call-meta\"`\n  Tried: `\"call-recur\"`\n  Tried: `\"call-tail\"`\n  Tried: `\"wrap-value\"`\n  Tried: `\"wrap-list\"`\n  Tried: `\"call-lambda\"`\n  Tried: `\"call\"`")
  end
  return popNode_21_1(out, node)
end
compileBind1 = function(args, argsStart, vals, valsStart, out, state)
  local zipped = zipArgs1(args, argsStart, vals, valsStart)
  local zippedN, zippedI, skip, catLookup = n1(zipped), 1, state["var-skip"], state["cat-lookup"]
  while zippedI <= zippedN do
    local zip = nth1(zipped, zippedI)
    local args1, vals1 = car1(zip), cadr1(zip)
    if empty_3f_1(args1) then
      local forLimit = n1(vals1)
      local i = 1
      while i <= forLimit do
        compileExpression1(vals1[i], out, state, "")
        line_21_1(out)
        i = i + 1
      end
    elseif car1(args1)["var"]["is-variadic"] or n1(args1) > 1 and any1(symVariadic_3f_1, args1) then
      if n1(args1) > 1 then
        append_21_1(out, "local _p = _pack(")
        local forLimit = n1(vals1)
        local i = 1
        while i <= forLimit do
          if i > 1 then
            append_21_1(out, ", ")
          end
          compileExpression1(nth1(vals1, i), out, state)
          i = i + 1
        end
        append_21_1(out, ")")
        line_21_1(out)
        append_21_1(out, "local ")
        local forLimit = n1(args1)
        local i = 1
        while i <= forLimit do
          if i > 1 then
            append_21_1(out, ", ")
          end
          append_21_1(out, pushEscapeVar_21_1(nth1(args1, i)["var"], state))
          i = i + 1
        end
        local varIdx = findIndex1(symVariadic_3f_1, args1)
        if varIdx > 1 then
          append_21_1(out, " = ")
          local forLimit = varIdx - 1
          local i = 1
          while i <= forLimit do
            if i > 1 then
              append_21_1(out, ", ")
            end
            append_21_1(out, format1("_p[%d]", i))
            i = i + 1
          end
        end
        line_21_1(out)
        compileBindVariadic1(out, args1, vals1, state)
      elseif empty_3f_1(vals1) or singleReturn_3f_1(last1(vals1)) then
        append_21_1(out, "local ")
        append_21_1(out, pushEscapeVar_21_1(car1(args1)["var"], state))
        append_21_1(out, " = {tag=\"list\", n=")
        append_21_1(out, tostring1(n1(vals1)))
        local forLimit = n1(vals1)
        local i = 1
        while i <= forLimit do
          append_21_1(out, ", ")
          compileExpression1(nth1(vals1, i), out, state)
          i = i + 1
        end
        append_21_1(out, "}")
        line_21_1(out)
      else
        local name = pushEscapeVar_21_1(car1(args1)["var"], state)
        append_21_1(out, "local ")
        append_21_1(out, name)
        append_21_1(out, " = _pack(")
        local forLimit = n1(vals1)
        local i = 1
        while i <= forLimit do
          if i > 1 then
            append_21_1(out, ", ")
          end
          compileExpression1(nth1(vals1, i), out, state)
          i = i + 1
        end
        append_21_1(out, ") ")
        append_21_1(out, name)
        append_21_1(out, ".tag = \"list\"")
        line_21_1(out)
      end
    elseif n1(args1) == 1 and skip[car1(args1)["var"]] then
    else
      local zippedLim, working = zippedI, true
      while working and zippedLim <= zippedN do
        local zip1 = nth1(zipped, zippedLim)
        local args2, vals2 = car1(zip1), cadr1(zip1)
        if empty_3f_1(args2) then
          working = false
        elseif car1(args2)["var"]["is-variadic"] or n1(args2) > 1 and any1(symVariadic_3f_1, args2) then
          working = false
        elseif n1(vals2) == 1 and catLookup[car1(vals2)]["stmt"] then
          working = false
        else
          zippedLim = zippedLim + 1
        end
      end
      if zippedLim == zippedI then
        local esc
        if n1(args1) == 1 then
          esc = pushEscapeVar_21_1(car1(args1)["var"], state)
        else
          local escs = {tag="list", n=0}
          local forLimit = n1(args1)
          local i = 1
          while i <= forLimit do
            push_21_1(escs, pushEscapeVar_21_1(args1[i]["var"], state))
            i = i + 1
          end
          esc = concat2(escs, ", ")
        end
        if not (n1(vals1) == 1 and catLookup[car1(vals1)]["stmt"]) then
          error1("Expected statement, got something " .. pretty1(zip))
        end
        line_21_1(out, "local " .. esc)
        compileExpression1(car1(vals1), out, state, esc .. " = ")
        line_21_1(out)
      else
        local hasVal = false
        append_21_1(out, "local ")
        local first, forStart, forLimit = true, zippedI, zippedLim - 1
        local i = forStart
        while i <= forLimit do
          local zip1 = nth1(zipped, i)
          local args2 = car1(zip1)
          if not empty_3f_1((cadr1(zip1))) then
            hasVal = true
          end
          if not (n1(args2) == 1 and skip[car1(args2)["var"]]) then
            local forLimit1 = n1(args2)
            local i1 = 1
            while i1 <= forLimit1 do
              local arg = args2[i1]
              if first then
                first = false
              else
                append_21_1(out, ", ")
              end
              local var = arg["var"]
              if skip[var] then
                append_21_1(out, "_")
              else
                append_21_1(out, pushEscapeVar_21_1(var, state))
              end
              i1 = i1 + 1
            end
          end
          i = i + 1
        end
        if hasVal then
          append_21_1(out, " = ")
          local first, forStart, forLimit = true, zippedI, zippedLim - 1
          local i = forStart
          while i <= forLimit do
            local zip1 = nth1(zipped, i)
            local args2, vals2 = car1(zip1), cadr1(zip1)
            if not (n1(args2) == 1 and skip[car1(args2)["var"]]) then
              local forLimit1 = n1(vals2)
              local i1 = 1
              while i1 <= forLimit1 do
                local val = vals2[i1]
                if first then
                  first = false
                else
                  append_21_1(out, ", ")
                end
                compileExpression1(val, out, state)
                i1 = i1 + 1
              end
            end
            i = i + 1
          end
        end
        line_21_1(out)
        zippedI = zippedLim - 1
      end
    end
    zippedI = zippedI + 1
  end
  return nil
end
compileBindVariadic1 = function(out, args, vals, state, mapping)
  local varIdx = findIndex1(symVariadic_3f_1, args)
  local varEsc, nargs = escapeVar1(mapVar1(mapping, nth1(args, varIdx)["var"]), state), n1(args)
  line_21_1(out, "local _n = _p.n")
  beginBlock_21_1(out, format1("if _n > %d then", nargs - 1))
  line_21_1(out, format1("%s = {tag=\"list\", n=_n-%d}", varEsc, nargs - 1))
  line_21_1(out, format1("for i=%d, _n-%d do %s[i-%d]=_p[i] end", varIdx, nargs - varIdx, varEsc, varIdx - 1))
  if varIdx < nargs then
    local forStart = varIdx + 1
    local i = forStart
    while i <= nargs do
      if i > varIdx + 1 then
        append_21_1(out, ", ")
      end
      append_21_1(out, escapeVar1(mapVar1(mapping, nth1(args, i)["var"]), state))
      i = i + 1
    end
    append_21_1(out, " = ")
    local forStart = varIdx + 1
    local i = forStart
    while i <= nargs do
      if i > varIdx + 1 then
        append_21_1(out, ", ")
      end
      append_21_1(out, format1("_p[_n-%d]", nargs - i))
      i = i + 1
    end
    line_21_1(out)
  end
  nextBlock_21_1(out, "else")
  line_21_1(out, format1("%s = {tag=\"list\", n=0}", varEsc))
  if varIdx < nargs then
    local forStart = varIdx + 1
    local i = forStart
    while i <= nargs do
      if i > varIdx + 1 then
        append_21_1(out, ", ")
      end
      append_21_1(out, escapeVar1(mapVar1(mapping, nth1(args, i)["var"]), state))
      i = i + 1
    end
    append_21_1(out, " = ")
    local forStart = varIdx + 1
    local i = forStart
    while i <= nargs do
      if i > varIdx + 1 then
        append_21_1(out, ", ")
      end
      append_21_1(out, format1("_p[%d]", i - 1))
      i = i + 1
    end
    line_21_1(out)
  end
  return endBlock_21_1(out, "end")
end
compileRecur1 = function(recur, out, state, ret, _ebreak)
  local temp = recur["category"]
  if temp == "while" then
    local node = nth1(recur["def"], 3)
    append_21_1(out, "while ")
    compileExpression1(car1(nth1(node, 2)), out, state)
    beginBlock_21_1(out, " do")
    compileRecurPush1(recur, out, state)
    compileBlock1(nth1(node, 2), out, state, 2, ret, _ebreak)
    compileRecurPop1(recur, state)
    endBlock_21_1(out, "end")
    return compileBlock1(nth1(node, 3), out, state, 2, ret)
  elseif temp == "while-not" then
    local node = nth1(recur["def"], 3)
    append_21_1(out, "while not (")
    compileExpression1(car1(nth1(node, 2)), out, state)
    beginBlock_21_1(out, ") do")
    compileRecurPush1(recur, out, state)
    compileBlock1(nth1(node, 3), out, state, 2, ret, _ebreak)
    compileRecurPop1(recur, state)
    endBlock_21_1(out, "end")
    return compileBlock1(nth1(node, 2), out, state, 2, ret)
  elseif temp == "forever" then
    beginBlock_21_1(out, "while true do")
    compileRecurPush1(recur, out, state)
    compileBlock1(recur["def"], out, state, 3, ret, _ebreak)
    compileRecurPop1(recur, state)
    return endBlock_21_1(out, "end")
  else
    return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"while\"`\n  Tried: `\"while-not\"`\n  Tried: `\"forever\"`")
  end
end
compileRecurPush1 = function(recur, out, state)
  local mapping = recur["captured"]
  if (not next1(mapping)) then
    return nil
  else
    append_21_1(out, "local ")
    local first = true
    local temp, to = next1(mapping)
    while temp ~= nil do
      if first then
        first = false
      else
        append_21_1(out, ", ")
      end
      renameEscapeVar_21_1(temp, to, state)
      append_21_1(out, pushEscapeVar_21_1(temp, state))
      temp, to = next1(mapping, temp)
    end
    append_21_1(out, " = ")
    local first = true
    local temp, to = next1(mapping)
    while temp ~= nil do
      if first then
        first = false
      else
        append_21_1(out, ", ")
      end
      append_21_1(out, escapeVar1(to, state))
      temp, to = next1(mapping, temp)
    end
    return line_21_1(out)
  end
end
compileRecurPop1 = function(recur, state)
  local temp = recur["captured"]
  local temp1, to = next1(temp)
  while temp1 ~= nil do
    popEscapeVar_21_1(temp1, state)
    renameEscapeVar_21_1(to, temp1, state)
    temp1, to = next1(temp, temp1)
  end
  return nil
end
mapVar1 = function(mapping, var)
  return mapping and mapping[var] or var
end
compileBlock1 = function(nodes, out, state, start, ret, _ebreak)
  local len = n1(nodes)
  local forLimit = len - 1
  local i = start
  while i <= forLimit do
    compileExpression1(nth1(nodes, i), out, state, "")
    line_21_1(out)
    i = i + 1
  end
  if len >= start then
    local node = nth1(nodes, len)
    compileExpression1(node, out, state, ret, _ebreak)
    line_21_1(out)
    if _ebreak and not breakCategories1[state["cat-lookup"][node]["category"]] then
      return line_21_1(out, "break")
    else
      return nil
    end
  else
    if ret and ret ~= "" then
      append_21_1(out, ret)
      line_21_1(out, "nil")
    end
    if _ebreak then
      return line_21_1(out, "break")
    else
      return nil
    end
  end
end
prelude1 = function(out)
  line_21_1(out, "if not table.pack then table.pack = function(...) return { n = select(\"#\", ...), ... } end end")
  line_21_1(out, "if not table.unpack then table.unpack = unpack end")
  line_21_1(out, "local load = load if _VERSION:find(\"5.1\") then load = function(x, n, _, env) local f, e = loadstring(x, n) if not f then return f, e end if env then setfenv(f, env) end return f end end")
  return line_21_1(out, "local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error")
end
expression1 = function(node, out, state, ret)
  local passState = createPassState1(state)
  runPass1(letrecNode1, state, nil, node, passState)
  runPass1(categoriseNode1, state, nil, node, passState, ret ~= nil)
  return compileExpression1(node, out, passState, ret)
end
block1 = function(nodes, out, state, start, ret)
  local passState = createPassState1(state)
  runPass1(letrecNodes1, state, nil, nodes, passState)
  runPass1(categoriseNodes1, state, nil, nodes, passState)
  return compileBlock1(nodes, out, passState, start, ret)
end
create3 = function(scope, compiler)
  if type1(scope) ~= "scope" then
    error1(demandFailure1(nil, "(= (type scope) \"scope\")"))
  end
  if compiler == nil then
    error1("compiler cannot be nil")
  end
  return {tag="resolve-state", scope=scope, compiler=compiler, required={tag="list", n=0}, ["required-set"]={}, stage="parsed", var=nil, node=nil, value=nil}
end
rsNode1 = function(resolveState)
  return resolveState["node"]
end
require_21_1 = function(state, var, user)
  if state["stage"] ~= "parsed" then
    error1("Cannot add requirement when in stage " .. state["stage"])
  end
  if not var then
    error1("var is nil")
  end
  if not user then
    error1("user is nil")
  end
  if var["scope"]["kind"] == "top-level" then
    local other = state["compiler"]["states"][var]
    if other and not state["required-set"][other] then
      state["required-set"][other] = user
      push_21_1(state["required"], other)
    end
    return other
  else
    return nil
  end
end
define_21_1 = function(state, var)
  if state["stage"] ~= "parsed" then
    error1("Cannot add definition when in stage " .. state["stage"])
  end
  if var["scope"] ~= state["scope"] then
    error1("Defining variable in different scope")
  end
  if state["var"] then
    error1("Cannot redeclare variable for given state")
  end
  state["var"] = var
  state["compiler"]["states"][var] = state
  state["compiler"]["variables"][tostring1(var)] = var
  return nil
end
built_21_1 = function(state, node)
  if not node then
    error1("node cannot be nil")
  end
  if state["stage"] ~= "parsed" then
    error1("Cannot transition from " .. state["stage"] .. " to built")
  end
  if node["def-var"] ~= state["var"] then
    error1("Variables are different")
  end
  state["node"] = node
  state["stage"] = "built"
  return nil
end
executed_21_1 = function(state, value)
  if state["stage"] ~= "built" then
    error1("Cannot transition from " .. state["stage"] .. " to executed")
  end
  state["value"] = value
  state["stage"] = "executed"
  return nil
end
get_21_1 = function(state)
  if state["stage"] == "executed" then
    return state["value"]
  else
    local required, requiredSet = {tag="list", n=0}, {}
    local visit
    visit = function(state1, stack, stackHash)
      local idx = stackHash[state1]
      if idx then
        if state1["var"]["kind"] == "macro" then
          push_21_1(stack, state1)
          local states, nodes, firstNode = {tag="list", n=0}, {tag="list", n=0}, nil
          local forLimit = n1(stack)
          local i = idx
          while i <= forLimit do
            local current, previous = nth1(stack, i), nth1(stack, i - 1)
            push_21_1(states, current["var"]["name"])
            if previous then
              local user = previous["required-set"][current]
              if not firstNode then
                firstNode = user
              end
              push_21_1(nodes, sourceRange1(user["source"]))
              push_21_1(nodes, current["var"]["name"] .. " used in " .. previous["var"]["name"])
            end
            i = i + 1
          end
          return doNodeError_21_1(state1["compiler"]["log"], "Loop in macros " .. concat2(states, " -> "), firstNode["source"], nil, splice1(nodes))
        else
          return nil
        end
      elseif state1["stage"] == "executed" then
        return nil
      else
        push_21_1(stack, state1)
        stackHash[state1] = n1(stack)
        if not requiredSet[state1] then
          requiredSet[state1] = true
          push_21_1(required, state1)
        end
        local visited = {}
        local temp = state1["required"]
        local forLimit = n1(temp)
        local i = 1
        while i <= forLimit do
          local inner = temp[i]
          visited[inner] = true
          visit(inner, stack, stackHash)
          i = i + 1
        end
        if state1["stage"] == "parsed" then
          yield1({tag="build", state=state1})
        end
        local temp = state1["required"]
        local forLimit = n1(temp)
        local i = 1
        while i <= forLimit do
          local inner = temp[i]
          if not visited[inner] then
            visit(inner, stack, stackHash)
          end
          i = i + 1
        end
        popLast_21_1(stack)
        stackHash[state1] = nil
        return nil
      end
    end
    visit(state, {tag="list", n=0}, {})
    yield1({tag="execute", states=required})
    return state["value"]
  end
end
name1 = function(state)
  if state["var"] then
    return "macro " .. quoted1(state["var"]["name"])
  else
    return "unquote"
  end
end
createState1 = function()
  return {timer={callback=function()
    return nil
  end, timers={}}, count=0, mappings={}, ["var-cache"]={}, ["var-lookup"]={}}
end
file1 = function(compiler, shebang)
  local state, out = createState1(), {out={tag="list", n=0}, indent=0, ["tabs-pending"]=false, line=1, lines={}, ["node-stack"]={tag="list", n=0}, ["active-pos"]=nil}
  if shebang then
    line_21_1(out, "#!/usr/bin/env " .. shebang)
  end
  state["trace"] = true
  prelude1(out)
  line_21_1(out, "local _libs = {}")
  local temp = compiler["libs"]["loaded"]
  local forLimit = n1(temp)
  local i = 1
  while i <= forLimit do
    local lib = temp[i]
    local prefix, native = quoted1(lib["unique-name"] .. "/"), lib["lua-contents"]
    if native then
      beginBlock_21_1(out, "local _temp = (function()")
      local temp1 = split1(native, "\n")
      local forLimit1 = n1(temp1)
      local i1 = 1
      while i1 <= forLimit1 do
        local line = temp1[i1]
        if line ~= "" then
          line_21_1(out, line)
        end
        i1 = i1 + 1
      end
      endBlock_21_1(out, "end)()")
      line_21_1(out, "for k, v in pairs(_temp) do _libs[" .. prefix .. ".. k] = v end")
    end
    i = i + 1
  end
  local count = 0
  local temp = compiler["out"]
  local forLimit = n1(temp)
  local i = 1
  while i <= forLimit do
    if temp[i]["def-var"] then
      count = count + 1
    end
    i = i + 1
  end
  local temp = compiler["out"]
  local forLimit = n1(temp)
  local i = 1
  while i <= forLimit do
    local var = temp[i]["def-var"]
    if var then
      pushEscapeVar_21_1(var, state, true)
    end
    i = i + 1
  end
  if count == 0 then
  elseif count <= 100 then
    append_21_1(out, "local ")
    local first, temp = true, compiler["out"]
    local forLimit = n1(temp)
    local i = 1
    while i <= forLimit do
      local var = temp[i]["def-var"]
      if var then
        if first then
          first = false
        else
          append_21_1(out, ", ")
        end
        append_21_1(out, escapeVar1(var, state))
      end
      i = i + 1
    end
    line_21_1(out)
  else
    local counts, vars = {}, {tag="list", n=0}
    local temp = compiler["out"]
    local forLimit = n1(temp)
    local i = 1
    while i <= forLimit do
      local var = temp[i]["def-var"]
      if var then
        counts[var] = 0
        push_21_1(vars, var)
      end
      i = i + 1
    end
    visitBlock1(compiler["out"], 1, function(x)
      if type1(x) == "symbol" then
        local var = x["var"]
        local count1 = counts[var]
        if count1 then
          counts[var] = count1 + 1
          return nil
        else
          return nil
        end
      else
        return nil
      end
    end)
    sort1(vars, function(x, y)
      return counts[x] > counts[y]
    end)
    append_21_1(out, "local ")
    local mainVars = map2(function(temp)
      return escapeVar1(temp, state)
    end, slice1(vars, 1, min1(100, n1(vars))))
    sort1(mainVars, nil)
    append_21_1(out, concat2(mainVars, ", "))
    line_21_1(out)
    line_21_1(out, "local _ENV = setmetatable({}, {__index=_ENV or (getfenv and getfenv()) or _G}) if setfenv then setfenv(0, _ENV) end")
  end
  block1(compiler["out"], out, state, 1, "return ")
  return out
end
executeStates1 = function(backState, states, global)
  local stateList, nameList, exportList, escapeList, localList = {tag="list", n=0}, {tag="list", n=0}, {tag="list", n=0}, {tag="list", n=0}, {tag="list", n=0}
  local forStart = n1(states)
  local i = forStart
  while i >= 1 do
    local state = nth1(states, i)
    if not (state["stage"] == "executed") then
      if not state["node"] then
        error1(demandFailure1("State is in " .. state["stage"] .. " instead", "(state/rs-node state)"))
      end
      local var = state["var"] or tempVar1("temp", state["node"])
      local escaped, name = pushEscapeVar_21_1(var, backState, true), var["name"]
      push_21_1(stateList, state)
      push_21_1(exportList, escaped .. " = " .. escaped)
      push_21_1(nameList, name)
      push_21_1(escapeList, escaped)
      if not var or var["const"] then
        push_21_1(localList, escaped)
      end
    end
    i = i + -1
  end
  if empty_3f_1(stateList) then
    return nil
  else
    local out, id, name = {out={tag="list", n=0}, indent=0, ["tabs-pending"]=false, line=1, lines={}, ["node-stack"]={tag="list", n=0}, ["active-pos"]=nil}, backState["count"], concat2(nameList, ",")
    backState["count"] = id + 1
    if n1(name) > 20 then
      name = sub1(name, 1, 17) .. "..."
    end
    name = "compile#" .. id .. "{" .. name .. "}"
    prelude1(out)
    if not empty_3f_1(localList) then
      line_21_1(out, "local " .. concat2(localList, ", "))
    end
    local forLimit = n1(stateList)
    local i = 1
    while i <= forLimit do
      local state = nth1(stateList, i)
      expression1(state["node"], out, backState, (function()
        if state["var"] then
          return ""
        else
          return nth1(escapeList, i) .. " = "
        end
      end)())
      line_21_1(out)
      i = i + 1
    end
    line_21_1(out, "return { " .. concat2(exportList, ", ") .. "}")
    local str = concat2(out["out"])
    backState["mappings"][name] = generateMappings1(out["lines"])
    local temp = list1(load1(str, "=" .. name, "t", global))
    if type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (nth1(temp, 1) == nil and true))) then
      local msg, buffer, lines = nth1(temp, 2), {tag="list", n=0}, split1(str, "\n")
      local fmt = "%" .. n1(tostring1(n1(lines))) .. "d | %s"
      local forLimit = n1(lines)
      local i = 1
      while i <= forLimit do
        push_21_1(buffer, sprintf1(fmt, i, nth1(lines, i)))
        i = i + 1
      end
      return error1(msg .. ":\n" .. concat2(buffer, "\n"), 0)
    elseif type1(temp) == "list" and (n1(temp) >= 1 and (n1(temp) <= 1 and true)) then
      local temp1 = list1(xpcall1(nth1(temp, 1), traceback2))
      if type1(temp1) == "list" and (n1(temp1) >= 2 and (n1(temp1) <= 2 and (nth1(temp1, 1) == false and true))) then
        local msg = nth1(temp1, 2)
        return error1(remapTraceback1(backState["mappings"], msg), 0)
      elseif type1(temp1) == "list" and (n1(temp1) >= 2 and (n1(temp1) <= 2 and (nth1(temp1, 1) == true and true))) then
        local tbl, forLimit = nth1(temp1, 2), n1(stateList)
        local i = 1
        while i <= forLimit do
          local state, escaped = nth1(stateList, i), nth1(escapeList, i)
          local res = tbl[escaped]
          executed_21_1(state, res)
          if state["var"] then
            global[escaped] = res
          end
          i = i + 1
        end
        return nil
      else
        return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp1) .. ", but none matched.\n" .. "  Tried: `(false ?msg)`\n  Tried: `(true ?tbl)`")
      end
    else
      return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `(nil ?msg)`\n  Tried: `(?fun)`")
    end
  end
end
getNative1 = function(var)
  local native = varNative1(var)
  if not native["has-value"] then
    local out = {out={tag="list", n=0}, indent=0, ["tabs-pending"]=false, line=1, lines={}, ["node-stack"]={tag="list", n=0}, ["active-pos"]=nil}
    prelude1(out)
    append_21_1(out, "return ")
    compileNative1(out, var, native)
    native["has-value"] = true
    local fun = load1(concat2(out["out"]), "=" .. var["name"])
    if fun then
      local ok, res = pcall1(fun)
      if ok then
        native["value"] = res
      end
    end
  end
  return native["value"]
end
errorPositions_21_1 = function(log, node, message, extra)
  return doNodeError_21_1(log, message, node["source"], extra, sourceRange1(node["source"]), "")
end
expectType_21_1 = function(log, node, parent, expectedType, name)
  if type1(node) ~= expectedType then
    return errorPositions_21_1(log, node or parent, "Expected " .. (name or expectedType) .. ", got " .. (function()
      if node then
        return type1(node)
      else
        return "nothing"
      end
    end)())
  else
    return nil
  end
end
expect_21_1 = function(log, node, parent, name)
  if node then
    return nil
  else
    return errorPositions_21_1(log, parent, "Expected " .. name .. ", got nothing")
  end
end
maxLength_21_1 = function(log, node, len, name)
  if n1(node) > len then
    return errorPositions_21_1(log, nth1(node, len + 1), "Unexpected node in '" .. name .. "' (expected " .. len .. " values, got " .. n1(node) .. ")")
  else
    return nil
  end
end
handleMetadata1 = function(log, node, var, start, finish)
  local i = start
  while i <= finish do
    local child = nth1(node, i)
    local temp = type1(child)
    if temp == "nil" then
      expect_21_1(log, child, node, "variable metadata")
    elseif temp == "string" then
      if var["doc"] then
        errorPositions_21_1(log, child, "Multiple doc strings in definition")
      end
      var["doc"] = (child["value"])
    elseif temp == "key" then
      local temp1 = child["value"]
      if temp1 == "hidden" then
        var["scope"]["exported"][var["name"]] = nil
      elseif temp1 == "deprecated" then
        if var["deprecated"] then
          errorPositions_21_1(log, child, "This definition is already deprecated")
        end
        local message = true
        if i < finish and string_3f_1(nth1(node, i + 1)) then
          message = nth1(node, i + 1)["value"]
          i = i + 1
        end
        var["deprecated"] = message
      elseif temp1 == "mutable" then
        if var["kind"] ~= "defined" then
          errorPositions_21_1(log, child, "Can only set conventional definitions as mutable")
        end
        if not var["const"] then
          errorPositions_21_1(log, child, "This definition is already mutable")
        end
        var["const"] = false
      elseif temp1 == "intrinsic" then
        expectType_21_1(log, nth1(node, i + 1), node, "symbol", "intrinsic")
        if var["intrinsic"] then
          errorPositions_21_1(log, child, "Multiple intrinsics set")
        end
        var["intrinsic"] = (nth1(node, i + 1)["contents"])
        i = i + 1
      elseif temp1 == "pure" then
        if var["kind"] ~= "native" then
          errorPositions_21_1(log, child, "Can only set native definitions as pure")
        end
        local native = varNative1(var)
        if native["pure"] then
          errorPositions_21_1(log, child, "This definition is already pure")
        end
        native["pure"] = true
      elseif temp1 == "signature" then
        if var["kind"] ~= "native" then
          errorPositions_21_1(log, child, "Can only set signature for native definitions")
        end
        local native, signature = varNative1(var), nth1(node, i + 1)
        expectType_21_1(log, signature, node, "list", "signature")
        local forLimit = n1(signature)
        local i1 = 1
        while i1 <= forLimit do
          expectType_21_1(log, signature[i1], signature, "symbol", "argument")
          i1 = i1 + 1
        end
        if native["signature"] then
          errorPositions_21_1(log, child, "multiple signatures set")
        end
        native["signature"] = signature
        i = i + 1
      elseif temp1 == "bind-to" then
        if var["kind"] ~= "native" then
          errorPositions_21_1(log, child, "Can only bind native definitions")
        end
        local native = varNative1(var)
        expectType_21_1(log, nth1(node, i + 1), node, "string", "bind expression")
        if native["bind-to"] then
          errorPositions_21_1(log, child, "Multiple bind expressions set")
        end
        native["bind-to"] = (nth1(node, i + 1)["value"])
        i = i + 1
      elseif temp1 == "syntax" then
        if var["kind"] ~= "native" then
          errorPositions_21_1(log, child, "Can only set syntax for native definitions")
        end
        local native, syntax = varNative1(var), nth1(node, i + 1)
        expect_21_1(log, syntax, node, "syntax")
        if native["syntax"] then
          errorPositions_21_1(log, child, "Multiple syntaxes set")
        end
        local temp2 = type1(syntax)
        if temp2 == "string" then
          local syn, arity = parseTemplate1(syntax["value"])
          native["syntax"] = syn
          native["syntax-arity"] = arity
        elseif temp2 == "list" then
          expect_21_1(log, car1(syntax), syntax, "syntax element")
          local syn, arity = {tag="list", n=0}, 0
          local forLimit = n1(syntax)
          local i1 = 1
          while i1 <= forLimit do
            local child2 = syntax[i1]
            local temp3 = type1(child2)
            if temp3 == "string" then
              push_21_1(syn, child2["value"])
            elseif temp3 == "number" then
              local val = child2["value"]
              if val > arity then
                arity = val
              end
              push_21_1(syn, val)
            else
              errorPositions_21_1(log, child2, formatOutput_21_1(nil, "Expected syntax element, got " .. display1((function()
                if temp3 == "nil" then
                  return "nothing"
                else
                  return temp3
                end
              end)())))
            end
            i1 = i1 + 1
          end
          native["syntax"] = syn
          native["syntax-arity"] = arity
        else
          errorPositions_21_1(log, child, formatOutput_21_1(nil, "Expected syntax, got " .. display1((function()
            if temp2 == "nil" then
              return "nothing"
            else
              return temp2
            end
          end)())))
        end
        i = i + 1
      elseif temp1 == "stmt" then
        if var["kind"] ~= "native" then
          errorPositions_21_1(log, child, "Can only set native definitions as statements")
        end
        local native = varNative1(var)
        if native["syntax-stmt"] then
          errorPositions_21_1(log, child, "This definition is already a statement")
        end
        native["syntax-stmt"] = true
      elseif temp1 == "syntax-precedence" then
        if var["kind"] ~= "native" then
          errorPositions_21_1(log, child, "Can only set syntax of native definitions")
        end
        local native, precedence = varNative1(var), nth1(node, i + 1)
        if native["syntax-precedence"] then
          errorPositions_21_1(log, child, "Multiple precedences set")
        end
        local temp2 = type1(precedence)
        if temp2 == "number" then
          native["syntax-precedence"] = (precedence["value"])
        elseif temp2 == "list" then
          local res = {tag="list", n=0}
          local forLimit = n1(precedence)
          local i1 = 1
          while i1 <= forLimit do
            local prec = precedence[i1]
            expectType_21_1(log, prec, precedence, "number", "precedence")
            push_21_1(res, prec["value"])
            i1 = i1 + 1
          end
          native["syntax-precedence"] = res
        else
          errorPositions_21_1(log, child, formatOutput_21_1(nil, "Expected precedence, got " .. display1((function()
            if temp2 == "nil" then
              return "nothing"
            else
              return temp2
            end
          end)())))
        end
        i = i + 1
      elseif temp1 == "syntax-fold" then
        if var["kind"] ~= "native" then
          errorPositions_21_1(log, child, "Can only set syntax of native definitions")
        end
        local native = varNative1(var)
        expectType_21_1(log, nth1(node, i + 1), node, "string", "fold direction")
        if native["syntax-fold"] then
          errorPositions_21_1(log, child, "Multiple fold directions set")
        end
        local temp2 = nth1(node, i + 1)["value"]
        if temp2 == "left" then
          native["syntax-fold"] = "left"
        elseif temp2 == "right" then
          native["syntax-fold"] = "right"
        else
          errorPositions_21_1(log, nth1(node, i + 1), formatOutput_21_1(nil, "Unknown fold direction " .. quoted1(temp2)))
        end
        i = i + 1
      else
        errorPositions_21_1(log, child, "Unexpected modifier '" .. pretty1(child) .. "'")
      end
    else
      errorPositions_21_1(log, child, "Unexpected modifier of type " .. temp .. ", have you got too many values?")
    end
    i = i + 1
  end
  if var["kind"] == "native" then
    local native = varNative1(var)
    if native["syntax"] and native["bind-to"] then
      errorPositions_21_1(log, node, "Cannot specify :syntax and :bind-to in native definition")
    end
    if native["syntax-fold"] and not native["syntax"] then
      errorPositions_21_1(log, node, "Cannot specify a fold direction when no syntax given")
    end
    if native["syntax-stmt"] and not native["syntax"] then
      errorPositions_21_1(log, node, "Cannot have a statement when no syntax given")
    end
    if native["syntax-precedence"] and not native["syntax"] then
      errorPositions_21_1(log, node, "Cannot specify a precedence when no syntax given")
    end
    if native["syntax"] then
      local syntaxArity, signature = native["syntax-arity"], native["signature"]
      local signatureArity
      if type1(signature) == "list" then
        signatureArity = n1(signature)
      else
        signatureArity = nil
      end
      local precedence = native["syntax-precedence"]
      local precArity
      if type1(precedence) == "list" then
        precArity = n1(precedence)
      else
        precArity = nil
      end
      if signatureArity and signatureArity ~= syntaxArity then
        errorPositions_21_1(log, node, formatOutput_21_1(nil, "Definition has arity " .. display1(syntaxArity) .. ", but signature has " .. display1(signatureArity) .. " arguments"))
      end
      if precArity and precArity ~= syntaxArity then
        errorPositions_21_1(log, node, formatOutput_21_1(nil, "Definition has arity " .. display1(syntaxArity) .. ", but precedence has " .. display1(precArity) .. " values"))
      end
      if native["syntax-fold"] and syntaxArity ~= 2 then
        errorPositions_21_1(log, node, formatOutput_21_1(nil, "Cannot specify a fold direction with arity " .. display1(syntaxArity) .. " (must be 2)"))
      end
    end
  end
  return nil
end
resolveExecuteResult1 = function(source, node, scope, state)
  local temp = type_23_1(node)
  if temp == "string" then
    node = {tag="string", value=node}
  elseif temp == "number" then
    node = {tag="number", value=node}
  elseif temp == "boolean" then
    node = {tag="symbol", contents=tostring1(node), var=builtins1[(tostring1(node))]}
  elseif temp == "table" then
    local tag = type1(node)
    if tag == "symbol" or tag == "string" or tag == "number" or tag == "key" or tag == "list" then
      local copy = {}
      local temp1 = node
      local temp2, v = next1(temp1)
      while temp2 ~= nil do
        copy[temp2] = v
        temp2, v = next1(temp1, temp2)
      end
      node = copy
    else
      doNodeError_21_1(state["compiler"]["log"], formatOutput_21_1(nil, "Invalid node of type " .. display1(type1(node)) .. " from " .. display1(formatNodeSourceName1(source))), source, nil, sourceRange1(source), "")
    end
  else
    doNodeError_21_1(state["compiler"]["log"], formatOutput_21_1(nil, "Invalid node of type " .. display1(type1(node)) .. " from " .. display1(formatNodeSourceName1(source))), source, nil, sourceRange1(source), "")
  end
  if not node["source"] then
    node["source"] = source
  end
  local temp = type1(node)
  if temp == "list" then
    local forLimit = n1(node)
    local i = 1
    while i <= forLimit do
      node[i] = resolveExecuteResult1(source, nth1(node, i), scope, state)
      i = i + 1
    end
  elseif temp == "symbol" then
    if string_3f_1(node["var"]) then
      local var = state["compiler"]["variables"][node["var"]]
      if not var then
        errorPositions_21_1(state["compiler"]["log"], node, "Invalid variable key " .. quoted1(node["var"]) .. " for " .. pretty1(node))
      end
      node["var"] = var
    end
  end
  return node
end
resolveQuote1 = function(node, scope, state, level)
  if level == 0 then
    return resolveNode1(node, scope, state)
  else
    local temp = type1(node)
    if temp == "string" then
      return node
    elseif temp == "number" then
      return node
    elseif temp == "key" then
      return node
    elseif temp == "symbol" then
      if not node["var"] then
        node["var"] = lookupAlways_21_1(scope, node["contents"], node)
        if not (node["var"]["scope"]["kind"] == "top-level" or node["var"]["scope"]["kind"] == "builtin") then
          errorPositions_21_1(state["compiler"]["log"], node, "Cannot use non-top level definition '" .. node["var"]["name"] .. "' in syntax-quote")
        end
      end
      return node
    elseif temp == "list" then
      local first = car1(node)
      if first then
        node[1] = resolveQuote1(first, scope, state, level)
        if type1(first) == "symbol" then
          if first["var"] == builtins1["unquote"] then
            level = level - 1
          elseif first["var"] == builtins1["unquote-splice"] then
            level = level - 1
          elseif first["var"] == builtins1["syntax-quote"] then
            level = level + 1
          end
        end
      end
      local forLimit = n1(node)
      local i = 2
      while i <= forLimit do
        node[i] = resolveQuote1(nth1(node, i), scope, state, level)
        i = i + 1
      end
      return node
    else
      return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"key\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`")
    end
  end
end
resolveNode1 = function(node, scope, state, root, many)
  while true do
    local node1 = node
    local temp = type1(node1)
    if temp == "number" then
      return node1
    elseif temp == "string" then
      return node1
    elseif temp == "key" then
      return node1
    elseif temp == "symbol" then
      if not node1["var"] then
        node1["var"] = lookupAlways_21_1(scope, node1["contents"], node1)
      end
      if node1["var"]["kind"] == "builtin" then
        errorPositions_21_1(state["compiler"]["log"], node1, "Cannot have a raw builtin.")
      end
      require_21_1(state, node1["var"], node1)
      return node1
    elseif temp == "list" then
      local first = car1(node1)
      local temp1 = type1(first)
      if temp1 == "symbol" then
        if not first["var"] then
          first["var"] = lookupAlways_21_1(scope, first["contents"], first)
        end
        local func = first["var"]
        local funcState, temp2 = require_21_1(state, func, first), func["kind"]
        if temp2 == "builtin" then
          if func == builtins1["lambda"] then
            expectType_21_1(state["compiler"]["log"], nth1(node1, 2), node1, "list", "argument list")
            local childScope, args, hasVariadic = child1(scope), nth1(node1, 2), false
            local forLimit = n1(args)
            local i = 1
            while i <= forLimit do
              expectType_21_1(state["compiler"]["log"], nth1(args, i), args, "symbol", "argument")
              local arg = nth1(args, i)
              local name = arg["contents"]
              local isVar = sub1(name, 1, 1) == "&"
              if isVar then
                if hasVariadic then
                  errorPositions_21_1(state["compiler"]["log"], args, "Cannot have multiple variadic arguments")
                elseif n1(name) == 1 then
                  errorPositions_21_1(state["compiler"]["log"], arg, format1("Expected a symbol for variadic argument.%s", (function()
                    if i < n1(args) then
                      local nextArg = nth1(args, i + 1)
                      if type1(nextArg) == "symbol" and sub1(nextArg["contents"], 1, 1) ~= "&" then
                        return format1("\nDid you mean '&%s'?", nextArg["contents"])
                      else
                        return ""
                      end
                    else
                      return ""
                    end
                  end)()))
                else
                  name = sub1(name, 2)
                  hasVariadic = true
                end
              end
              local var = addVerbose_21_1(childScope, name, "arg", arg, state["compiler"]["log"])
              var["display-name"] = (arg["display-name"])
              var["is-variadic"] = isVar
              arg["var"] = var
              i = i + 1
            end
            return resolveBlock1(node1, 3, childScope, state)
          elseif func == builtins1["cond"] then
            local forLimit = n1(node1)
            local i = 2
            while i <= forLimit do
              local case = nth1(node1, i)
              expectType_21_1(state["compiler"]["log"], case, node1, "list", "case expression")
              expect_21_1(state["compiler"]["log"], car1(case), case, "condition")
              case[1] = resolveNode1(car1(case), scope, state)
              resolveBlock1(case, 2, scope, state)
              i = i + 1
            end
            return node1
          elseif func == builtins1["set!"] then
            expectType_21_1(state["compiler"]["log"], nth1(node1, 2), node1, "symbol")
            expect_21_1(state["compiler"]["log"], nth1(node1, 3), node1, "value")
            maxLength_21_1(state["compiler"]["log"], node1, 3, "set!")
            local var = lookupAlways_21_1(scope, nth1(node1, 2)["contents"], nth1(node1, 2))
            require_21_1(state, var, nth1(node1, 2))
            node1[2]["var"] = var
            if var["const"] then
              errorPositions_21_1(state["compiler"]["log"], node1, format1("Cannot rebind immutable definition '%s'", nth1(node1, 2)["contents"]), format1("Top level definitions are immutable by default. If you want\nto redefine '%s', add the `:mutable` modifier to its definition.", nth1(node1, 2)["contents"]))
            end
            node1[3] = resolveNode1(nth1(node1, 3), scope, state)
            return node1
          elseif func == builtins1["quote"] then
            expect_21_1(state["compiler"]["log"], nth1(node1, 2), node1, "value")
            maxLength_21_1(state["compiler"]["log"], node1, 2, "quote")
            return node1
          elseif func == builtins1["syntax-quote"] then
            expect_21_1(state["compiler"]["log"], nth1(node1, 2), node1, "value")
            maxLength_21_1(state["compiler"]["log"], node1, 2, "syntax-quote")
            node1[2] = resolveQuote1(nth1(node1, 2), scope, state, 1)
            return node1
          elseif func == builtins1["unquote"] then
            expect_21_1(state["compiler"]["log"], nth1(node1, 2), node1, "value")
            local result, states = {tag="list", n=0}, {tag="list", n=0}
            local forLimit = n1(node1)
            local i = 2
            while i <= forLimit do
              local childState = create3(scope, state["compiler"])
              local built = resolveNode1(nth1(node1, i), scope, childState)
              built_21_1(childState, {tag="list", n=3, source=built["source"], [1]={tag="symbol", contents="lambda", var=builtins1["lambda"]}, [2]={tag="list", n=0}, [3]=built})
              local func1 = get_21_1(childState)
              state["compiler"]["active-scope"] = scope
              state["compiler"]["active-node"] = built
              local temp3 = state["compiler"]["exec"](func1)
              if type1(temp3) == "list" and (n1(temp3) >= 2 and (n1(temp3) <= 2 and (nth1(temp3, 1) == false and true))) then
                local msg = nth1(temp3, 2)
                errorPositions_21_1(state["compiler"]["log"], node1, remapTraceback1(state["compiler"]["compile-state"]["mappings"], msg))
              elseif type1(temp3) == "list" and (n1(temp3) >= 1 and (nth1(temp3, 1) == true and true)) then
                local replacement = slice1(temp3, 2)
                if i == n1(node1) then
                  local forLimit1 = n1(replacement)
                  local i1 = 1
                  while i1 <= forLimit1 do
                    local child = replacement[i1]
                    push_21_1(result, child)
                    push_21_1(states, childState)
                    i1 = i1 + 1
                  end
                elseif n1(replacement) == 1 then
                  push_21_1(result, car1(replacement))
                  push_21_1(states, childState)
                else
                  errorPositions_21_1(state["compiler"]["log"], nth1(node1, i), "Expected one value, got " .. n1(replacement))
                end
              else
                error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp3) .. ", but none matched.\n" .. "  Tried: `(false ?msg)`\n  Tried: `(true . ?replacement)`")
              end
              i = i + 1
            end
            if n1(result) == 0 or n1(result) == 1 and car1(result) == nil then
              result = list1({tag="symbol", contents="nil", var=builtins1["nil"]})
            end
            local source, forLimit = {tag="node-source", owner=nil, parent=node1["source"], range=sourceRange1(node1["source"])}, n1(result)
            local i = 1
            while i <= forLimit do
              result[i] = resolveExecuteResult1(source, nth1(result, i), scope, state)
              i = i + 1
            end
            if n1(result) == 1 then
              node = car1(result)
            elseif many then
              result["tag"] = "many"
              return result
            else
              return errorPositions_21_1(state["compiler"]["log"], node1, "Multiple values returned in a non block context")
            end
          elseif func == builtins1["unquote-splice"] then
            maxLength_21_1(state["compiler"]["log"], node1, 2, "unquote-splice")
            local childState = create3(scope, state["compiler"])
            local built = resolveNode1(nth1(node1, 2), scope, childState)
            built_21_1(childState, {tag="list", n=3, source=built["source"], [1]={tag="symbol", contents="lambda", var=builtins1["lambda"]}, [2]={tag="list", n=0}, [3]=built})
            local func1 = get_21_1(childState)
            state["compiler"]["active-scope"] = scope
            state["compiler"]["active-node"] = built
            local temp3 = state["compiler"]["exec"](func1)
            if type1(temp3) == "list" and (n1(temp3) >= 2 and (n1(temp3) <= 2 and (nth1(temp3, 1) == false and true))) then
              local msg = nth1(temp3, 2)
              return errorPositions_21_1(state["compiler"]["log"], node1, remapTraceback1(state["compiler"]["compile-state"]["mappings"], msg))
            elseif type1(temp3) == "list" and (n1(temp3) >= 1 and (nth1(temp3, 1) == true and true)) then
              local result = car1((slice1(temp3, 2)))
              if type1(result) ~= "list" then
                errorPositions_21_1(state["compiler"]["log"], node1, "Expected list from unquote-splice, got '" .. type1(result) .. "'")
              end
              if n1(result) == 0 then
                result = list1({tag="symbol", contents="nil", var=builtins1["nil"]})
              end
              local source, forLimit = {tag="node-source", owner=nil, parent=node1["source"], range=sourceRange1(node1["source"])}, n1(result)
              local i = 1
              while i <= forLimit do
                result[i] = resolveExecuteResult1(source, nth1(result, i), scope, state)
                i = i + 1
              end
              if n1(result) == 1 then
                node = car1(result)
              elseif many then
                result["tag"] = "many"
                return result
              else
                return errorPositions_21_1(state["compiler"]["log"], node1, "Multiple values returned in a non-block context")
              end
            else
              return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp3) .. ", but none matched.\n" .. "  Tried: `(false ?msg)`\n  Tried: `(true . ?replacement)`")
            end
          elseif func == builtins1["define"] then
            if not root then
              errorPositions_21_1(state["compiler"]["log"], first, "define can only be used on the top level")
            end
            expectType_21_1(state["compiler"]["log"], nth1(node1, 2), node1, "symbol", "name")
            expect_21_1(state["compiler"]["log"], nth1(node1, 3), node1, "value")
            local var = addVerbose_21_1(scope, nth1(node1, 2)["contents"], "defined", node1, state["compiler"]["log"])
            var["display-name"] = (nth1(node1, 2)["display-name"])
            define_21_1(state, var)
            node1["def-var"] = var
            handleMetadata1(state["compiler"]["log"], node1, var, 3, n1(node1) - 1)
            node1[n1(node1)] = resolveNode1(nth1(node1, n1(node1)), scope, state)
            return node1
          elseif func == builtins1["define-macro"] then
            if not root then
              errorPositions_21_1(state["compiler"]["log"], first, "define-macro can only be used on the top level")
            end
            expectType_21_1(state["compiler"]["log"], nth1(node1, 2), node1, "symbol", "name")
            expect_21_1(state["compiler"]["log"], nth1(node1, 3), node1, "value")
            local var = addVerbose_21_1(scope, nth1(node1, 2)["contents"], "macro", node1, state["compiler"]["log"])
            var["display-name"] = (nth1(node1, 2)["display-name"])
            define_21_1(state, var)
            node1["def-var"] = var
            handleMetadata1(state["compiler"]["log"], node1, var, 3, n1(node1) - 1)
            node1[n1(node1)] = resolveNode1(nth1(node1, n1(node1)), scope, state)
            return node1
          elseif func == builtins1["define-native"] then
            if not root then
              errorPositions_21_1(state["compiler"]["log"], first, "define-native can only be used on the top level")
            end
            expectType_21_1(state["compiler"]["log"], nth1(node1, 2), node1, "symbol", "name")
            local var = addVerbose_21_1(scope, nth1(node1, 2)["contents"], "native", node1, state["compiler"]["log"])
            local native
            local cache, name = state["compiler"]["libs"], var["unique-name"]
            native = cache["metas"][name]
            if native then
              setVarNative_21_1(var, native)
            end
            var["display-name"] = (nth1(node1, 2)["display-name"])
            define_21_1(state, var)
            node1["def-var"] = var
            handleMetadata1(state["compiler"]["log"], node1, var, 3, n1(node1))
            return node1
          elseif func == builtins1["import"] then
            expectType_21_1(state["compiler"]["log"], nth1(node1, 2), node1, "symbol", "module name")
            local as, symbols, exportIdx, qualifier = nil, nil, nil, nth1(node1, 3)
            local temp3 = type1(qualifier)
            if temp3 == "symbol" then
              exportIdx = 4
              as = qualifier["contents"]
              symbols = nil
            elseif temp3 == "list" then
              exportIdx = 4
              as = nil
              if n1(qualifier) == 0 then
                symbols = nil
              else
                symbols = {}
                local forLimit = n1(qualifier)
                local i = 1
                while i <= forLimit do
                  local entry = qualifier[i]
                  expectType_21_1(state["compiler"]["log"], entry, qualifier, "symbol")
                  symbols[entry["contents"]] = entry
                  i = i + 1
                end
              end
            elseif temp3 == "nil" then
              exportIdx = 3
              as = nth1(node1, 2)["contents"]
              symbols = nil
            elseif temp3 == "key" then
              exportIdx = 3
              as = nth1(node1, 2)["contents"]
              symbols = nil
            else
              expectType_21_1(state["compiler"]["log"], nth1(node1, 3), node1, "symbol", "alias name of import list")
            end
            maxLength_21_1(state["compiler"]["log"], node1, exportIdx, "import")
            yield1({tag="import", module=nth1(node1, 2)["contents"], as=as, symbols=symbols, export=(function()
              local export = nth1(node1, exportIdx)
              if export then
                expectType_21_1(state["compiler"]["log"], export, node1, "key", "import modifier")
                if export["value"] == "export" then
                  return true
                else
                  return errorPositions_21_1(state["compiler"]["log"], export, "unknown import modifier")
                end
              else
                return export
              end
            end)(), scope=scope})
            return node1
          elseif func == builtins1["struct-literal"] then
            if n1(node1) % 2 ~= 1 then
              errorPositions_21_1(state["compiler"]["log"], node1, "Expected an even number of arguments, got " .. n1(node1) - 1)
            end
            return resolveList1(node1, 2, scope, state)
          else
            return errorPositions_21_1(state["compiler"]["log"], node1, "[Internal]" .. ("Unknown builtin " .. (function()
              if func then
                return func["name"]
              else
                return "?"
              end
            end)()))
          end
        elseif temp2 == "macro" then
          if not funcState then
            errorPositions_21_1(state["compiler"]["log"], first, "[Internal]Macro is not defined correctly")
          end
          local builder = get_21_1(funcState)
          if type1(builder) ~= "function" then
            errorPositions_21_1(state["compiler"]["log"], first, "Macro is of type " .. type1(builder))
          end
          state["compiler"]["active-scope"] = scope
          state["compiler"]["active-node"] = node1
          local temp3
          local _efunction = function()
            return apply1(builder, slicingView1(node1, 1))
          end
          temp3 = state["compiler"]["exec"](_efunction)
          if type1(temp3) == "list" and (n1(temp3) >= 2 and (n1(temp3) <= 2 and (nth1(temp3, 1) == false and true))) then
            local msg = nth1(temp3, 2)
            return errorPositions_21_1(state["compiler"]["log"], first, remapTraceback1(state["compiler"]["compile-state"]["mappings"], msg))
          elseif type1(temp3) == "list" and (n1(temp3) >= 1 and (nth1(temp3, 1) == true and true)) then
            local replacement = slice1(temp3, 2)
            local source, forLimit = {tag="node-source", owner=func, parent=first["source"], range=sourceRange1(node1["source"])}, n1(replacement)
            local i = 1
            while i <= forLimit do
              replacement[i] = resolveExecuteResult1(source, nth1(replacement, i), scope, state)
              i = i + 1
            end
            if n1(replacement) == 0 then
              return errorPositions_21_1(state["compiler"]["log"], node1, "Expected some value from " .. name1(funcState) .. ", got nothing")
            elseif n1(replacement) == 1 then
              node = car1(replacement)
            elseif many then
              replacement["tag"] = "many"
              return replacement
            else
              return errorPositions_21_1(state["compiler"]["log"], node1, "Multiple values returned in a non-block context.")
            end
          else
            return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp3) .. ", but none matched.\n" .. "  Tried: `(false ?msg)`\n  Tried: `(true . ?replacement)`")
          end
        else
          return resolveList1(node1, 1, scope, state)
        end
      elseif temp1 == "list" then
        return resolveList1(node1, 1, scope, state)
      else
        return errorPositions_21_1(state["compiler"]["log"], first or node1, "Cannot invoke a non-function type '" .. temp1 .. "'")
      end
    else
      return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"number\"`\n  Tried: `\"string\"`\n  Tried: `\"key\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`")
    end
  end
end
resolveList1 = function(nodes, start, scope, state)
  local forLimit = n1(nodes)
  local i = start
  while i <= forLimit do
    nodes[i] = resolveNode1(nth1(nodes, i), scope, state)
    i = i + 1
  end
  return nodes
end
resolveBlock1 = function(nodes, start, scope, state)
  local len, i = n1(nodes), start
  while i <= len do
    local node = resolveNode1(nth1(nodes, i), scope, state, false, true)
    if node["tag"] == "many" then
      nodes[i] = nth1(node, 1)
      local forLimit = n1(node)
      local j = 2
      while j <= forLimit do
        insertNth_21_1(nodes, i + (j - 1), nth1(node, j))
        j = j + 1
      end
      len = len + (n1(node) - 1)
    else
      nodes[i] = node
      i = i + 1
    end
  end
  return nodes
end
resolve1 = function(node, scope, state)
  node = resolveNode1(node, scope, state, true, true)
  while node["tag"] == "many" and n1(node) == 1 do
    node = resolveNode1(car1(node), scope, state, true, true)
  end
  return node
end
distance1 = function(a, b)
  if a == b then
    return 0
  elseif n1(a) == 0 then
    return n1(b)
  elseif n1(b) == 0 then
    return n1(a)
  else
    local v0, v1 = {tag="list", n=0}, {tag="list", n=0}
    local forLimit = n1(b) + 1
    local i = 1
    while i <= forLimit do
      push_21_1(v0, i - 1)
      push_21_1(v1, 0)
      i = i + 1
    end
    local forLimit = n1(a)
    local i = 1
    while i <= forLimit do
      v1[1] = i
      local forLimit1 = n1(b)
      local j = 1
      while j <= forLimit1 do
        local subCost, delCost, addCost, aChar, bChar = 1, 1, 1, sub1(a, i, i), sub1(b, j, j)
        if aChar == bChar then
          subCost = 0
        end
        if aChar == "-" or aChar == "/" then
          delCost = 0.5
        end
        if bChar == "-" or bChar == "/" then
          addCost = 0.5
        end
        if n1(a) <= 5 or n1(b) <= 5 then
          subCost = subCost * 2
          delCost = delCost + 0.5
        end
        v1[j + 1] = min1(nth1(v1, j) + delCost, nth1(v0, j + 1) + addCost, nth1(v0, j) + subCost)
        j = j + 1
      end
      local forLimit1 = n1(v0)
      local j = 1
      while j <= forLimit1 do
        v0[j] = nth1(v1, j)
        j = j + 1
      end
      i = i + 1
    end
    return nth1(v1, n1(b) + 1)
  end
end
compile1 = function(compiler, nodes, scope, name, loader)
  local queue, states, loader1, logger, timer = {tag="list", n=0}, {tag="list", n=0}, loader or compiler["loader"], compiler["log"], compiler["timer"]
  if name then
    name = "[resolve] " .. name
  end
  local hook, hookMask, hookCount
  if gethook1 then
    hook, hookMask, hookCount = gethook1()
  else
    hook, hookMask, hookCount = nil
  end
  local forLimit = n1(nodes)
  local i = 1
  while i <= forLimit do
    local node, state, co = nth1(nodes, i), create3(scope, compiler), create2(resolve1)
    push_21_1(states, state)
    if hook then
      sethook1(co, hook, hookMask, hookCount)
    end
    push_21_1(queue, {tag="init", node=node, _co=co, _state=state, _node=node, _idx=i})
    i = i + 1
  end
  local skipped = 0
  local resume = function(action, ...)
    local args = _pack(...) args.tag = "list"
    skipped = 0
    compiler["active-scope"] = action["_active-scope"]
    compiler["active-node"] = action["_active-node"]
    local temp = list1(resume1(action["_co"], splice1(args)))
    if type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and true)) then
      local status, result = nth1(temp, 1), nth1(temp, 2)
      if not status then
        error1(result, 0)
      elseif status1(action["_co"]) == "dead" then
        if result["tag"] == "many" then
          local baseIdx = action["_idx"]
          self1(logger, "put-debug!", "  Got multiple nodes as a result. Adding to queue")
          local forLimit = n1(queue)
          local i = 1
          while i <= forLimit do
            local elem = queue[i]
            if elem["_idx"] > action["_idx"] then
              elem["_idx"] = elem["_idx"] + (n1(result) - 1)
            end
            i = i + 1
          end
          local forLimit = n1(result)
          local i = 1
          while i <= forLimit do
            local state = create3(scope, compiler)
            if i == 1 then
              states[baseIdx] = state
            else
              insertNth_21_1(states, baseIdx + (i - 1), state)
            end
            local co = create2(resolve1)
            if hook then
              sethook1(co, hook, hookMask, hookCount)
            end
            push_21_1(queue, {tag="init", node=nth1(result, i), _co=co, _state=state, _node=nth1(result, i), _idx=baseIdx + (i - 1)})
            i = i + 1
          end
        else
          built_21_1(action["_state"], result)
        end
      else
        result["_co"] = action["_co"]
        result["_state"] = action["_state"]
        result["_node"] = action["_node"]
        result["_idx"] = action["_idx"]
        result["_active-scope"] = compiler["active-scope"]
        result["_active-node"] = compiler["active-node"]
        push_21_1(queue, result)
      end
    else
      error1("Pattern matching failure! Can not match the pattern `(?status ?result)` against `" .. pretty1(temp) .. "`.")
    end
    compiler["active-scope"] = nil
    compiler["active-node"] = nil
    return nil
  end
  if name then
    startTimer_21_1(timer, name, 2)
  end
  while n1(queue) > 0 and skipped <= n1(queue) do
    local head = removeNth_21_1(queue, 1)
    self1(logger, "put-debug!", (formatOutput_21_1(nil, "" .. display1(type1(head)) .. " for " .. display1(head["_state"]["stage"]) .. " at " .. display1(formatNode1(head["_node"])) .. " (" .. display1((function()
      if head["_state"]["var"] then
        return head["_state"]["var"]["name"]
      else
        return "?"
      end
    end)()) .. ")")))
    local temp = type1(head)
    if temp == "init" then
      resume(head, head["node"], scope, head["_state"])
    elseif temp == "define" then
      local var
      local name2 = head["name"]
      var = scope["variables"][name2]
      if var then
        resume(head, var)
      else
        self1(logger, "put-debug!", ("  Awaiting definiion of " .. head["name"]))
        skipped = skipped + 1
        push_21_1(queue, head)
      end
    elseif temp == "build" then
      if head["state"]["stage"] ~= "parsed" then
        resume(head)
      else
        self1(logger, "put-debug!", ("  Awaiting building of node " .. (function()
          if head["state"]["var"] then
            return head["state"]["var"]["name"]
          else
            return "?"
          end
        end)()))
        skipped = skipped + 1
        push_21_1(queue, head)
      end
    elseif temp == "execute" then
      executeStates1(compiler["compile-state"], head["states"], compiler["global"])
      resume(head)
    elseif temp == "import" then
      if name then
        pauseTimer_21_1(timer, name)
      end
      local result = loader1(head["module"])
      local module = car1(result)
      if name then
        startTimer_21_1(timer, name)
      end
      if not module then
        doNodeError_21_1(logger, nth1(result, 2), head["_node"]["source"], nil, sourceRange1(head["_node"]["source"]), "")
      end
      local export, scope1, node, temp1 = head["export"], head["scope"], head["_node"], module["scope"]["exported"]
      local temp2, var = next1(temp1)
      while temp2 ~= nil do
        if head["as"] then
          importVerbose_21_1(scope1, head["as"] .. "/" .. temp2, var, node, export, logger)
        elseif head["symbols"] then
          if head["symbols"][temp2] then
            importVerbose_21_1(scope1, temp2, var, node, export, logger)
          end
        else
          importVerbose_21_1(scope1, temp2, var, node, export, logger)
        end
        temp2, var = next1(temp1, temp2)
      end
      if head["symbols"] then
        local failed = false
        local temp1 = head["symbols"]
        local temp2, nameNode = next1(temp1)
        while temp2 ~= nil do
          if not module["scope"]["exported"][temp2] then
            failed = true
            putNodeError_21_1(logger, "Cannot find " .. temp2, nameNode["source"], nil, sourceRange1(head["_node"]["source"]), "Importing here", sourceRange1(nameNode["source"]), "Required here")
          end
          temp2, nameNode = next1(temp1, temp2)
        end
        if failed then
          compilerError_21_1("Resolution failed")
        end
      end
      resume(head)
    else
      error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"init\"`\n  Tried: `\"define\"`\n  Tried: `\"build\"`\n  Tried: `\"execute\"`\n  Tried: `\"import\"`")
    end
  end
  if n1(queue) > 0 then
    local forLimit = n1(queue)
    local i = 1
    while i <= forLimit do
      local entry = queue[i]
      local temp = type1(entry)
      if temp == "define" then
        local info, suggestions = nil, ""
        local scope1 = entry["scope"]
        if scope1 then
          local vars, varDis, varSet, distances = {tag="list", n=0}, {tag="list", n=0}, {}, {}
          while scope1 do
            local temp1 = scope1["variables"]
            local temp2, _5f_ = next1(temp1)
            while temp2 ~= nil do
              if not varSet[temp2] then
                varSet[temp2] = "true"
                push_21_1(vars, temp2)
                local parlen = n1(entry["name"])
                local lendiff = abs1(n1(temp2) - parlen)
                if parlen <= 5 or lendiff <= parlen * 0.3 then
                  local dis = distance1(temp2, entry["name"]) / parlen
                  if parlen <= 5 then
                    dis = dis / 2
                  end
                  push_21_1(varDis, temp2)
                  distances[temp2] = dis
                end
              end
              temp2, _5f_ = next1(temp1, temp2)
            end
            scope1 = scope1["parent"]
          end
          sort1(vars, nil)
          sort1(varDis, function(a, b)
            return distances[a] < distances[b]
          end)
          local elems
          local temp1
          local xs = first1(partition1(function(x)
            return distances[x] <= 0.5
          end, varDis))
          temp1 = slice1(xs, 1, min1(5, n1(xs)))
          elems = map2(function(temp2)
            return coloured1("1;32", temp2)
          end, temp1)
          local temp1 = n1(elems)
          if temp1 == 0 then
          elseif temp1 == 1 then
            suggestions = "\nDid you mean '" .. car1(elems) .. "'?"
          else
            suggestions = "\nDid you mean any of these?" .. "\n  •" .. concat2(elems, "\n  •")
          end
          info = "Variables in scope are " .. concat2(vars, ", ")
        end
        putNodeError_21_1(logger, "Cannot find variable '" .. entry["name"] .. "'" .. suggestions, (entry["node"] or entry["_node"])["source"], info, sourceRange1((entry["node"] or entry["_node"])["source"]), "")
      elseif temp == "build" then
        local var, node = entry["state"]["var"], entry["state"]["node"]
        self1(logger, "put-error!", ("Could not build " .. (function()
          if var then
            return var["name"]
          elseif node then
            return formatNode1(node)
          else
            return "unknown node"
          end
        end)()))
      else
        error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"define\"`\n  Tried: `\"build\"`")
      end
      i = i + 1
    end
    compilerError_21_1("Resolution failed")
  end
  if name then
    stopTimer_21_1(timer, name)
  end
  return splice1(list1(map2(rsNode1, states), states))
end
pathEscape1 = {["?"]="(.*)", ["."]="%.", ["%"]="%%", ["^"]="%^", ["$"]="%$", ["+"]="%+", ["-"]="%-", ["*"]="%*", ["["]="%[", ["]"]="%]", ["("]="%)", [")"]="%)"}
lispExtensions1 = {tag="list", n=3, ".lisp", ".cl", ".urn"}
tryHandle1 = function(name)
  local i = 1
  while true do
    if (i > n1(lispExtensions1)) then
      return nil
    else
      local handle = open1(name .. nth1(lispExtensions1, i), "r")
      if handle then
        return splice1(list1(handle, (name .. nth1(lispExtensions1, i))))
      else
        i = i + 1
      end
    end
  end
end
simplifyPath1 = function(path, paths)
  local current = path
  local forLimit = n1(paths)
  local i = 1
  while i <= forLimit do
    local sub = match1(path, "^" .. gsub1(paths[i], ".", pathEscape1) .. "$")
    if sub and n1(sub) < n1(current) then
      current = sub
    end
    i = i + 1
  end
  return current
end
stripExtension1 = function(path)
  local i = 1
  while true do
    if i > n1(lispExtensions1) then
      return path
    else
      local suffix = nth1(lispExtensions1, i)
      if endsWith_3f_1(path, suffix) then
        return sub1(path, 1, -1 - n1(suffix))
      else
        i = i + 1
      end
    end
  end
end
readMeta1 = function(state, name, entry)
  local native = {tag="native", pure=false, signature=nil, ["bind-to"]=nil, syntax=nil, ["syntax-arity"]=nil, ["syntax-fold"]=nil, ["syntax-stmt"]=false, ["syntax-precedence"]=nil}
  local temp = type1(entry["count"])
  if temp == "nil" then
  elseif temp == "number" then
    native["syntax-arity"] = (entry["count"])
  else
    self1(state["log"], "put-error!", (formatOutput_21_1(nil, "Expected number for " .. display1(name) .. "'s count, got " .. display1(temp))))
  end
  local temp = type1(entry["prec"])
  if temp == "nil" then
  elseif temp == "number" then
    native["syntax-precedence"] = (entry["prec"])
  else
    self1(state["log"], "put-error!", (formatOutput_21_1(nil, "Expected number for " .. display1(name) .. "'s prec, got " .. display1(temp))))
  end
  local temp = type1(entry["precs"])
  if temp == "nil" then
  elseif temp == "list" then
    native["syntax-precedence"] = (entry["precs"])
  else
    self1(state["log"], "put-error!", (formatOutput_21_1(nil, "Expected number for " .. display1(name) .. "'s precs, got " .. display1(temp))))
  end
  if entry["pure"] then
    native["pure"] = true
  end
  local temp = type1(entry)
  if temp == "expr" then
    local buffer, max = parseTemplate1(entry["contents"])
    native["syntax"] = buffer
    if not entry["count"] then
      native["syntax-arity"] = max
    end
  elseif temp == "stmt" then
    local buffer, max = parseTemplate1(entry["contents"])
    native["syntax"] = buffer
    if not entry["count"] then
      native["syntax-arity"] = max
    end
    native["syntax-stmt"] = true
  elseif temp == "var" then
    native["bind-to"] = (entry["contents"])
  else
    self1(state["log"], "put-error!", (formatOutput_21_1(nil, "Unknown meta type " .. display1(temp) .. " for " .. display1(name))))
  end
  local fold = entry["fold"]
  if fold then
    if type1(entry) ~= "expr" then
      error1("Cannot have fold for non-expression " .. name, 0)
    end
    if entry["count"] ~= 2 then
      error1("Cannot have fold for length " .. entry["count"] .. " for " .. name, 0)
    end
    if fold == "l" then
      native["syntax-fold"] = "left"
    elseif fold == "r" then
      native["syntax-fold"] = "right"
    else
      error1("Unknown fold " .. fold .. " for " .. name, 0)
    end
  end
  entry["name"] = name
  local libValue, metaValue = state["libs"]["values"][name], entry["value"]
  if libValue ~= nil and metaValue ~= nil then
    error1("Duplicate value for " .. name .. ": in native and meta file", 0)
  elseif libValue ~= nil then
    entry["has-value"] = true
    entry["value"] = libValue
  elseif metaValue ~= nil then
    entry["has-value"] = true
    state["libs"]["values"][name] = metaValue
  end
  state["libs"]["metas"][name] = native
  return nil
end
readLibrary1 = function(state, name, path, lispHandle)
  self1(state["log"], "put-verbose!", ("Loading " .. path .. " into " .. name))
  local uniqueName = name .. "-" .. n1(state["libs"]["loaded"])
  local lib, contents = libraryOf1(name, uniqueName, path, state["root-scope"]), self1(lispHandle, "read", "*a")
  self1(lispHandle, "close")
  local handle = open1(path .. ".lib.lua", "r")
  if handle then
    local contents1 = self1(handle, "read", "*a")
    self1(handle, "close")
    lib["lua-contents"] = contents1
    local fun, err = load1(contents1, "@" .. name)
    if fun then
      local temp = list1(xpcall1(fun, tracebackPlain1))
      if type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (nth1(temp, 1) == false and true))) then
        local msg = nth1(temp, 2)
        self1(state["log"], "put-error!", (formatOutput_21_1(nil, "Cannot load " .. display1(path) .. ".lib.lua (" .. tostring1(msg) .. ")")))
      elseif type1(temp) == "list" and (n1(temp) >= 2 and (nth1(temp, 1) == true and (type_23_1((nth1(temp, 2))) == "table" and true))) then
        local res = nth1(temp, 2)
        local temp1, v = next1(res)
        while temp1 ~= nil do
          if string_3f_1(temp1) then
            local cache, name2 = state["libs"], uniqueName .. "/" .. temp1
            cache["values"][name2] = v
          else
            self1(state["log"], "put-warning!", (formatOutput_21_1(nil, "Non-string key '" .. tostring1(temp1) .. "' when loading " .. display1(path) .. ".lib.lua")))
          end
          temp1, v = next1(res, temp1)
        end
      else
        self1(state["log"], "put-error!", (formatOutput_21_1(nil, "Received a non-table value from " .. display1(path) .. ".lib.lua")))
      end
    else
      self1(state["log"], "put-error!", (formatOutput_21_1(nil, "Cannot load " .. display1(path) .. ".lib.lua (" .. display1(err) .. ")")))
    end
  end
  local handle = open1(path .. ".meta.lua", "r")
  if handle then
    local contents1 = self1(handle, "read", "*a")
    self1(handle, "close")
    local fun, err = load1(contents1, "@" .. name)
    if fun then
      local temp = list1(xpcall1(fun, tracebackPlain1))
      if type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (nth1(temp, 1) == false and true))) then
        local msg = nth1(temp, 2)
        self1(state["log"], "put-error!", (formatOutput_21_1(nil, "Cannot load " .. display1(path) .. ".meta.lua (" .. tostring1(msg) .. ")")))
      elseif type1(temp) == "list" and (n1(temp) >= 2 and (nth1(temp, 1) == true and (type_23_1((nth1(temp, 2))) == "table" and true))) then
        local res = nth1(temp, 2)
        local temp1, v = next1(res)
        while temp1 ~= nil do
          if string_3f_1(temp1) then
            readMeta1(state, uniqueName .. "/" .. temp1, v)
          else
            self1(state["log"], "put-warning!", (formatOutput_21_1(nil, "Non-string key '" .. tostring1(temp1) .. "' when loading " .. display1(path) .. ".meta.lua")))
          end
          temp1, v = next1(res, temp1)
        end
      else
        self1(state["log"], "put-error!", (formatOutput_21_1(nil, "Received a non-table value from " .. display1(path) .. ".meta.lua")))
      end
    else
      self1(state["log"], "put-error!", (formatOutput_21_1(nil, "Cannot load " .. display1(path) .. ".meta.lua (" .. display1(err) .. ")")))
    end
  end
  startTimer_21_1(state["timer"], "[parse] " .. path, 2)
  local lexed, range = lex1(state["log"], contents, path .. ".lisp")
  local parsed = parse1(state["log"], lexed)
  stopTimer_21_1(state["timer"], "[parse] " .. path)
  local prelude = state["prelude"]
  if prelude then
    lib["depends"][prelude] = true
  end
  local compiled = compile1(state, parsed, lib["scope"], path, function(name2)
    local res = state["loader"](name2)
    local module = car1(res)
    if module then
      lib["depends"][module] = true
    end
    return res
  end)
  push_21_1(state["libs"]["loaded"], lib)
  if string_3f_1(car1(compiled)) then
    lib["docs"] = (constVal1(car1(compiled)))
    removeNth_21_1(compiled, 1)
  end
  lib["lisp-lines"] = (range["lines"])
  lib["nodes"] = compiled
  local forLimit = n1(compiled)
  local i = 1
  while i <= forLimit do
    local node = compiled[i]
    push_21_1(state["out"], node)
    i = i + 1
  end
  self1(state["log"], "put-verbose!", ("Loaded " .. path .. " into " .. name))
  return lib
end
namedLoader1 = function(state, name)
  local cached = state["libs"]["names"][name]
  if cached == nil then
    state["libs"]["names"][name] = true
    local searched, paths, _ = {tag="list", n=0}, state["paths"]
    local i = 1
    while true do
      if i > n1(paths) then
        return list1(nil, "Cannot find " .. quoted1(name) .. ".\nLooked in " .. concat2(searched, ", "))
      else
        local path = gsub1(nth1(paths, i), "%?", name)
        local temp = pathLoader1(state, path)
        if type1(temp) == "list" and (n1(temp) >= 1 and (n1(temp) <= 1 and true)) then
          local lib = nth1(temp, 1)
          state["libs"]["names"][name] = lib
          return list1(lib)
        elseif type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (nth1(temp, 1) == false and true))) then
          return list1(false, (nth1(temp, 2)))
        elseif type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (nth1(temp, 1) == nil and true))) then
          push_21_1(searched, path)
          i = i + 1
        else
          return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `(?lib)`\n  Tried: `(false ?msg)`\n  Tried: `(nil _)`")
        end
      end
    end
  elseif cached == true then
    return list1(false, "Already loading " .. quoted1(name))
  else
    return list1(cached)
  end
end
pathLoader1 = function(state, path)
  local temp = state["libs"]["paths"][path]
  if temp == nil then
    local name, fullPath, handle = stripExtension1(path), path, nil
    if name == path then
      local handle_27_, path_27_ = tryHandle1(path)
      if handle_27_ then
        handle = handle_27_
        fullPath = path_27_
      end
    else
      handle = open1(path, "r")
    end
    local temp1
    local cache, path1 = state["libs"], fullPath
    temp1 = cache["paths"][path1]
    if temp1 == nil then
      if handle then
        state["libs"]["paths"][path] = true
        local cache, path1 = state["libs"], fullPath
        cache["paths"][path1] = true
        local lib = readLibrary1(state, simplifyPath1(name, state["paths"]), name, handle)
        state["libs"]["paths"][path] = lib
        local cache, path1 = state["libs"], fullPath
        cache["paths"][path1] = lib
        return list1(lib)
      else
        return list1(nil, "Cannot find " .. quoted1(path))
      end
    elseif temp1 == true then
      if handle then
        self1(handle, "close")
      end
      return list1(false, "Already loading " .. quoted1(fullPath))
    else
      if handle then
        self1(handle, "close")
      end
      state["libs"]["paths"][path] = temp1
      return list1(temp1)
    end
  elseif temp == true then
    return list1(false, "Already loading " .. quoted1(path))
  else
    return list1(temp)
  end
end
setupPrelude_21_1 = function(state, prelude)
  if type1(prelude) ~= "library" then
    error1(demandFailure1(nil, "(= (type prelude) \"library\")"))
  end
  state["prelude"] = prelude
  local scope = child1(rootScope1)
  state["root-scope"] = scope
  local temp = prelude["scope"]["exported"]
  local temp1, var = next1(temp)
  while temp1 ~= nil do
    import_21_1(scope, temp1, var)
    temp1, var = next1(temp, temp1)
  end
  return nil
end
reload1 = function(compiler)
  local cache, dirty, updatedLisp = compiler["libs"], {}, {}
  local temp = cache["loaded"]
  local forLimit = n1(temp)
  local i = 1
  while i <= forLimit do
    local lib = temp[i]
    local handle, path_27_ = tryHandle1(lib["path"])
    if handle then
      local newLines = gsub1(self1(handle, "read", "*a"), "\13\n?", "\n")
      self1(handle, "close")
      if neq_3f_1(newLines, concat2(lib["lisp-lines"], "\n")) then
        updatedLisp[lib] = newLines
        dirty[lib] = 1
      end
    else
      error1(formatOutput_21_1(nil, "Cannot find " .. display1(lib["path"]) .. " (for module " .. display1(lib["name"]) .. ")"))
    end
    i = i + 1
  end
  while true do
    local changed = false
    local temp = cache["loaded"]
    local forLimit = n1(temp)
    local i = 1
    while i <= forLimit do
      local lib = temp[i]
      local maxDepth, temp1 = dirty[lib] or 0, lib["depends"]
      local temp2 = next1(temp1)
      while temp2 ~= nil do
        local depth = dirty[temp2]
        if depth and depth >= maxDepth then
          maxDepth = depth + 1
          dirty[lib] = maxDepth
          changed = true
        end
        temp2 = next1(temp1, temp2)
      end
      i = i + 1
    end
    if changed then
    else
      break
    end
  end
  local reload
  local xs, f = keys1(dirty), function(x, y)
    return dirty[x] < dirty[y]
  end
  sort1(xs, f)
  reload = xs
  local forLimit = n1(reload)
  local i = 1
  while i <= forLimit do
    local lib = reload[i]
    local contents = updatedLisp[lib] or concat2(lib["lisp-lines"], "\n")
    local lexed, range = lex1(compiler["log"], contents, lib["path"] .. ".lisp")
    local parsed, oldScope = parse1(compiler["log"], lexed), lib["scope"]
    local newScope, deps = scopeForLibrary1(oldScope["parent"], lib["name"], lib["unique-name"]), {}
    self1(compiler["log"], "put-warning!", (formatOutput_21_1(nil, "" .. display1(lib["path"]) .. " or dependency has changed")))
    if lib["depends"][compiler["prelude"]] then
      deps[compiler["prelude"]] = true
    end
    local compiled = compile1(compiler, parsed, newScope, lib["path"], function(name)
      local res = compiler["loader"](name)
      local module = car1(res)
      if module then
        deps[module] = true
      end
      return res
    end)
    if string_3f_1(car1(compiled)) then
      lib["docs"] = (constVal1(car1(compiled)))
      removeNth_21_1(compiled, 1)
    else
      lib["docs"] = nil
    end
    lib["lisp-lines"] = (range["lines"])
    lib["nodes"] = compiled
    lib["scope"] = newScope
    lib["depends"] = deps
    if lib == compiler["prelude"] then
      local rootScope = compiler["root-scope"]
      local rootVars = rootScope["variables"]
      local temp = next1(rootVars)
      while temp ~= nil do
        rootVars[temp] = nil
        temp = next1(rootVars, temp)
      end
      local temp = newScope["exported"]
      local temp1, var = next1(temp)
      while temp1 ~= nil do
        import_21_1(rootScope, temp1, var)
        temp1, var = next1(temp, temp1)
      end
    end
    local escaped, temp = compiler["compile-state"]["var-lookup"], oldScope["variables"]
    local temp1, oldVar = next1(temp)
    while temp1 ~= nil do
      local esc = escaped[oldVar]
      if esc then
        local newVar = newScope["variables"][temp1]
        if newVar then
          escaped[newVar] = esc
        end
      end
      temp1, oldVar = next1(temp, temp1)
    end
    local temp = oldScope["variables"]
    local temp1, oldVar = next1(temp)
    while temp1 ~= nil do
      local newVar = newScope["variables"][temp1]
      if newVar then
        compiler[tostring1(oldVar)] = newVar
      end
      temp1, oldVar = next1(temp, temp1)
    end
    i = i + 1
  end
  return nil
end
formatRange2 = function(range)
  return format1("%s:%s", range["name"], (function()
    local pos = range["start"]
    return pos["line"] .. ":" .. pos["column"]
  end)())
end
sortVars_21_1 = function(list)
  sort1(list, function(a, b)
    return car1(a) < car1(b)
  end)
  return list
end
formatDefinition1 = function(var)
  local temp = var["kind"]
  if temp == "builtin" then
    return "Builtin term"
  elseif temp == "macro" then
    return "Macro defined at " .. formatRange2(sourceRange1(var["node"]["source"]))
  elseif temp == "native" then
    return "Native defined at " .. formatRange2(sourceRange1(var["node"]["source"]))
  elseif temp == "defined" then
    return "Defined at " .. formatRange2(sourceRange1(var["node"]["source"]))
  else
    return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"builtin\"`\n  Tried: `\"macro\"`\n  Tried: `\"native\"`\n  Tried: `\"defined\"`")
  end
end
formatSignature1 = function(name, var)
  local sig = extractSignature1(var)
  if sig == nil then
    return name
  else
    return "(" .. concat2(cons1(name, sig), " ") .. ")"
  end
end
formatLink1 = function(name, var, title)
  local loc, sig = gsub1(stripExtension1((sourceRange1(var["node"]["source"])["name"])), "/", "."), extractSignature1(var)
  local hash
  if sig == nil then
    hash = var["name"]
  elseif empty_3f_1(sig) then
    hash = var["name"]
  else
    hash = name .. " " .. concat2(sig, " ")
  end
  local titleq
  if title then
    titleq = " \"" .. title .. "\""
  else
    titleq = ""
  end
  return format1("[`%s`](%s.md#%s%s)", name, loc, gsub1(hash, "%A+", "-"), titleq)
end
writeDocstring1 = function(out, toks, scope)
  local forLimit = n1(toks)
  local i = 1
  while i <= forLimit do
    local tok = toks[i]
    local ty = tok["kind"]
    if ty == "text" then
      append_21_1(out, tok["contents"])
    elseif ty == "boldic" then
      append_21_1(out, tok["contents"])
    elseif ty == "bold" then
      append_21_1(out, tok["contents"])
    elseif ty == "italic" then
      append_21_1(out, tok["contents"])
    elseif ty == "arg" then
      append_21_1(out, "`" .. tok["contents"] .. "`")
    elseif ty == "mono" then
      append_21_1(out, gsub1(tok["whole"], "^```(%S+)[^\n]*", "```%1"))
    elseif ty == "link" then
      local name = tok["contents"]
      local ovar = lookup1(scope, name)
      if ovar and ovar["node"] then
        append_21_1(out, formatLink1(name, ovar))
      else
        append_21_1(out, format1("`%s`", name))
      end
    else
      _error("unmatched item")
    end
    i = i + 1
  end
  return nil
end
exported1 = function(out, title, primary, vars, scope)
  local documented, undocumented = {tag="list", n=0}, {tag="list", n=0}
  iterPairs1(vars, function(name, var)
    return push_21_1((function()
      if var["doc"] then
        return documented
      else
        return undocumented
      end
    end)(), list1(name, var))
  end)
  sortVars_21_1(documented)
  sortVars_21_1(undocumented)
  line_21_1(out, "---")
  line_21_1(out, "title: " .. title)
  line_21_1(out, "---")
  line_21_1(out, "# " .. title)
  if primary then
    writeDocstring1(out, parseDocstring1(primary), scope)
    line_21_1(out)
    line_21_1(out, "", true)
  end
  local forLimit = n1(documented)
  local i = 1
  while i <= forLimit do
    local entry = documented[i]
    local name, var = car1(entry), nth1(entry, 2)
    line_21_1(out, "## `" .. formatSignature1(name, var) .. "`")
    line_21_1(out, "*" .. formatDefinition1(var) .. "*")
    line_21_1(out, "", true)
    if var["deprecated"] then
      if string_3f_1(var["deprecated"]) then
        append_21_1(out, format1(">**Warning:** %s is deprecated: ", name))
        writeDocstring1(out, parseDocstring1(var["deprecated"]), var["scope"])
      else
        append_21_1(out, format1(">**Warning:** %s is deprecated.", name))
      end
      line_21_1(out)
      line_21_1(out, "", true)
    end
    writeDocstring1(out, parseDocstring1(var["doc"]), var["scope"])
    line_21_1(out)
    line_21_1(out, "", true)
    i = i + 1
  end
  if not empty_3f_1(undocumented) then
    line_21_1(out, "## Undocumented symbols")
  end
  local forLimit = n1(undocumented)
  local i = 1
  while i <= forLimit do
    local entry = undocumented[i]
    local name, var = car1(entry), nth1(entry, 2)
    line_21_1(out, " - `" .. formatSignature1(name, var) .. "` *" .. formatDefinition1(var) .. "*")
    i = i + 1
  end
  return nil
end
index1 = function(out, libraries)
  local variables, letters = {}, {}
  local forLimit = n1(libraries)
  local i = 1
  while i <= forLimit do
    local lib = libraries[i]
    local temp = lib["scope"]["exported"]
    local temp1, var = next1(temp)
    while temp1 ~= nil do
      local info = variables[var]
      if not info then
        info = {var=var, exported={tag="list", n=0}, defined=nil}
        variables[var] = info
        local letter = lower1(sub1(var["name"], 1, 1))
        if not between_3f_1(letter, "a", "z") then
          letter = "$"
        end
        local lookup = letters[letter]
        if not lookup then
          lookup = {tag="list", n=0}
          letters[letter] = lookup
        end
        push_21_1(lookup, info)
      end
      if var["scope"] == lib["scope"] then
        info["defined"] = lib
      else
        push_21_1(info["exported"], list1(temp1, lib))
      end
      temp1, var = next1(temp, temp1)
    end
    i = i + 1
  end
  local letterList = struct_2d3e_assoc1(letters)
  sort1(letterList, function(a, b)
    return car1(a) < car1(b)
  end)
  local forLimit = n1(letterList)
  local i = 1
  while i <= forLimit do
    local xs, f = cadr1((letterList[i])), function(a, b)
      return a["var"]["full-name"] < b["var"]["full-name"]
    end
    sort1(xs, f)
    i = i + 1
  end
  line_21_1(out, "---")
  line_21_1(out, "title: Symbol index")
  line_21_1(out, "---")
  line_21_1(out, "# Symbol index")
  line_21_1(out, "", true)
  line_21_1(out, "{:.sym-toc}")
  local forLimit = n1(letterList)
  local i = 1
  while i <= forLimit do
    local letter = letterList[i]
    line_21_1(out, format1(" - [%s](#sym-%s)", car1(letter), (function()
      if car1(letter) == "$" then
        return "symbols"
      else
        return car1(letter)
      end
    end)()))
    i = i + 1
  end
  line_21_1(out)
  line_21_1(out, "", true)
  line_21_1(out, "{:.sym-table}")
  line_21_1(out, "|   | Symbol | Defined in |")
  line_21_1(out, "| - | ------ | ---------- |")
  local forLimit = n1(letterList)
  local i = 1
  while i <= forLimit do
    local letter = letterList[i]
    line_21_1(out, format1("| <strong id=\"sym-%s\">%s</strong> | |", (function()
      if car1(letter) == "$" then
        return "symbols"
      else
        return car1(letter)
      end
    end)(), car1(letter)))
    local temp = cadr1(letter)
    local forLimit1 = n1(temp)
    local i1 = 1
    while i1 <= forLimit1 do
      local info = temp[i1]
      local var, defined = info["var"], info["defined"]
      local range = sourceRange1(var["node"]["source"])
      append_21_1(out, "| |")
      append_21_1(out, formatLink1(var["name"], var, formatDefinition1(var)))
      local doc = var["doc"]
      if doc then
        append_21_1(out, ": ")
        writeDocstring1(out, extractSummary1(parseDocstring1(doc)))
      end
      append_21_1(out, "|")
      local name
      if defined then
        name = defined["name"]
      else
        name = range["name"]
      end
      local path = gsub1(stripExtension1((function()
        if defined then
          return defined["path"]
        else
          return range["name"]
        end
      end)()), "/", ".")
      if empty_3f_1(info["exported"]) then
        append_21_1(out, format1("[%s](%s.md)", name, path))
      else
        append_21_1(out, format1("[%s](%s.md \"Also exported from %s\")", name, path, concat2(sort2(nub1(map2(function(x)
          return cadr1(x)["name"]
        end, info["exported"]))), ", ")))
      end
      line_21_1(out, "|")
      i1 = i1 + 1
    end
    i = i + 1
  end
  return nil
end
docs1 = function(compiler, args)
  if empty_3f_1(args["input"]) then
    self1(compiler["log"], "put-error!", "No inputs to generate documentation for.")
    exit_21_1(1)
  end
  local temp = args["input"]
  local forLimit = n1(temp)
  local i = 1
  while i <= forLimit do
    local path = temp[i]
    local lib, writer = compiler["libs"]["paths"][path], {out={tag="list", n=0}, indent=0, ["tabs-pending"]=false, line=1, lines={}, ["node-stack"]={tag="list", n=0}, ["active-pos"]=nil}
    exported1(writer, lib["name"], lib["docs"], lib["scope"]["exported"], lib["scope"])
    local handle = open1(args["docs"] .. "/" .. gsub1(stripExtension1(path), "/", ".") .. ".md", "w")
    self1(handle, "write", concat2(writer["out"]))
    self1(handle, "close")
    i = i + 1
  end
  local writer = {out={tag="list", n=0}, indent=0, ["tabs-pending"]=false, line=1, lines={}, ["node-stack"]={tag="list", n=0}, ["active-pos"]=nil}
  index1(writer, map2(function(temp)
    return compiler["libs"]["paths"][temp]
  end, args["input"]))
  local handle = open1(args["docs"] .. "/index.md", "w")
  self1(handle, "write", concat2(writer["out"]))
  return self1(handle, "close")
end
task1 = {name="docs", setup=function(spec)
  return addArgument_21_1(spec, {tag="list", n=1, "--docs"}, "help", "Specify the folder to emit documentation to.", "cat", "out", "default", nil, "narg", 1)
end, pred=function(args)
  return nil ~= args["docs"]
end, run=docs1}
local home = getenv1 and (getenv1("HOME") or (getenv1("USERPROFILE") or (getenv1("HOMEDRIVE") or getenv1("HOMEPATH"))))
if home then
  historyPath1 = home .. "/.urn_history"
else
  historyPath1 = ".urn_history"
end
readDumb1 = function(prompt)
  write1(prompt)
  flush1()
  return read1("*l")
end
local read, providers = nil, list1(function()
  local rlOk, readline = pcall1(require1, "urn.readline")
  if rlOk then
    return readline
  else
    return nil
  end
end, function()
  local ffiOk, ffi = pcall1(require1, "ffi")
  if ffiOk then
    local ok, readline = pcall1(ffi["load"], "readline")
    if ok then
      ffi["cdef"]("void* malloc(size_t bytes); // Required to allocate strings for completions\nvoid free(void *); // Required to free strings returned by readline\nchar *readline (const char *prompt); // Read a line with the given prompt\nconst char * rl_readline_name; // Set the program name\n\n// History manipulation\nvoid using_history();\nvoid add_history(const char *line);\nvoid read_history(const char *filename);\n\n// Hooks\ntypedef int rl_hook_func_t (void);\nrl_hook_func_t *rl_startup_hook;\n\n// Completion\ntypedef char *rl_compentry_func_t (const char *, int);\ntypedef char **rl_completion_func_t (const char *, int, int);\nchar **rl_completion_matches (const char *text, rl_compentry_func_t *entry_func);\nint rl_attempted_completion_over;\nchar * rl_line_buffer;\nconst char* rl_basic_word_break_characters;\nrl_completion_func_t * rl_attempted_completion_function;\n\nint rl_insert_text (const char *text);")
      local currentInitial, previous, currentCompleter = "", "", nil
      readline["rl_readline_name"] = "urn"
      readline["rl_startup_hook"] = function()
        if n1(currentInitial) > 0 then
          readline["rl_insert_text"](currentInitial)
        end
        return 0
      end
      readline["using_history"]()
      readline["read_history"](historyPath1)
      readline["rl_basic_word_break_characters"] = "\n \9;()[]{},@`'"
      readline["rl_attempted_completion_function"] = function(str, start, finish)
        readline["rl_attempted_completion_over"] = 1
        local results, resultsIdx = nil, 0
        return readline["rl_completion_matches"](str, function(str1, idx)
          if idx == 0 then
            if currentCompleter then
              results = currentCompleter(ffi["string"](readline["rl_line_buffer"], finish))
            else
              results = {tag="list", n=0}
            end
          end
          resultsIdx = resultsIdx + 1
          local resPartial = nth1(results, resultsIdx)
          if resPartial then
            local resStr = ffi["string"](str1) .. resPartial
            local resBuf = ffi["C"]["malloc"](n1(resStr) + 1)
            ffi["copy"](resBuf, resStr, n1(resStr) + 1)
            return resBuf
          else
            return nil
          end
        end)
      end
      return function(prompt, initial, complete)
        currentInitial = initial or ""
        currentCompleter = complete
        prompt = gsub1(prompt, "(\27%[%A*%a)", "\1%1\2")
        local res = readline["readline"](prompt)
        if res == nil then
          return nil
        else
          local str = ffi["string"](res)
          if find1(str, "%S") and previous ~= str then
            previous = str
            readline["add_history"](res)
            local out = open1(historyPath1, "a")
            if out then
              self1(out, "write", str, "\n")
              self1(out, "close")
            end
          end
          ffi["C"]["free"](res)
          return str
        end
      end
    else
      return nil
    end
  else
    return nil
  end
end, function()
  local readlineOk, readline = pcall1(require1, "readline")
  if readlineOk then
    local previous = nil
    readline["set_options"]({histfile=historyPath1, completion=false})
    return function(prompt, initial, complete)
      prompt = gsub1(prompt, "(\27%[%A*%a)", "\1%1\2")
      local res = readline["readline"](prompt)
      if res and (find1(res, "%S") and previous ~= res) then
        previous = res
        local out = open1(historyPath1, "a")
        if out then
          self1(out, "write", res, "\n")
          self1(out, "close")
        end
      end
      return res
    end
  else
    return nil
  end
end, function()
  local linenoiseOk, linenoise = pcall1(require1, "linenoise")
  if linenoiseOk then
    local previous = nil
    linenoise["historysetmaxlen"](1000)
    linenoise["historyload"](historyPath1)
    return function(prompt, initial, complete)
      prompt = gsub1(prompt, "(\27%[%A*%a)", "")
      if complete then
        linenoise["setcompletion"](function(obj, line)
          local temp = complete(line)
          local forLimit = n1(temp)
          local i = 1
          while i <= forLimit do
            local completion = temp[i]
            linenoise["addcompletion"](obj, line .. completion .. " ")
            i = i + 1
          end
          return nil
        end)
      else
        linenoise["setcompletion"](nil)
      end
      local res = linenoise["linenoise"](prompt)
      if res and (find1(res, "%S") and previous ~= res) then
        previous = res
        linenoise["historyadd"](res)
        local out = open1(historyPath1, "a")
        if out then
          self1(out, "write", res, "\n")
          self1(out, "close")
        end
      end
      return res
    end
  else
    return nil
  end
end, function()
  return readDumb1
end)
readLine_21_1 = function(prompt, initial, complete)
  if not read then
    local i = 1
    while true do
      local provider = nth1(providers, i)()
      if provider then
        read = provider
        break
      else
        i = i + 1
      end
    end
  end
  return read(prompt, initial, complete)
end
requiresInput1 = function(str)
  local temp = list1(pcall1(function()
    return parse1(void1, lex1(void1, str, "<stdin>", true), true)
  end))
  if type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (nth1(temp, 1) == true and true))) then
    return false
  elseif type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (nth1(temp, 1) == false and type_23_1((nth1(temp, 2))) == "table"))) then
    if nth1(temp, 2)["context"] then
      return true
    else
      return false
    end
  elseif type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (nth1(temp, 1) == false and true))) then
    local x = nth1(temp, 2)
    return nil
  else
    return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `(true _)`\n  Tried: `(false (table? @ ?x))`\n  Tried: `(false ?x)`")
  end
end
getIndent1 = function(str)
  local toks
  local temp = list1(pcall1(lex1, void1, str, "<stdin>", true))
  if type1(temp) == "list" and (n1(temp) >= 3 and (n1(temp) <= 3 and (nth1(temp, 1) == true and true))) then
    toks = (nth1(temp, 2))
  elseif type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (nth1(temp, 1) == false and type_23_1((nth1(temp, 2))) == "table"))) then
    toks = nth1(temp, 2)["tokens"] or {tag="list", n=0}
  else
    toks = error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `(true ?x _)`\n  Tried: `(false (table? @ ?x))`")
  end
  local stack = {tag="list", n=1, 1}
  local forLimit = n1(toks)
  local i = 1
  while i <= forLimit do
    local tok = toks[i]
    local temp = type1(tok)
    if temp == "open" then
      push_21_1(stack, tok["source"]["start"]["column"] + 2)
    elseif temp == "close" then
      popLast_21_1(stack)
    end
    i = i + 1
  end
  return rep1(" ", last1(stack) - 1)
end
getComplete1 = function(str, scope)
  local temp = list1(pcall1(lex1, void1, str, "<stdin>", true))
  if type1(temp) == "list" and (n1(temp) >= 3 and (n1(temp) <= 3 and (nth1(temp, 1) == true and true))) then
    local toks = nth1(temp, 2)
    local last = nth1(toks, n1(toks) - 1)
    local contents
    if last == nil then
      contents = ""
    elseif last["source"]["finish"]["offset"] < n1(str) then
      contents = ""
    elseif type1(last) == "symbol" then
      contents = symbol_2d3e_string1(last)
    else
      contents = nil
    end
    if contents then
      local visited, vars = {}, {tag="list", n=0}
      local scope1 = scope
      while not ((scope1 == nil)) do
        local temp1 = scope1["variables"]
        local temp2, _5f_ = next1(temp1)
        while temp2 ~= nil do
          if sub1(temp2, 1, #contents) == contents and not visited[temp2] then
            visited[temp2] = true
            push_21_1(vars, sub1(temp2, n1(contents) + 1))
          end
          temp2, _5f_ = next1(temp1, temp2)
        end
        scope1 = scope1["parent"]
      end
      sort1(vars, nil)
      return vars
    else
      return {tag="list", n=0}
    end
  else
    return {tag="list", n=0}
  end
end
if getenv1 then
  local clrs = getenv1("URN_COLOURS")
  if clrs then
    replColourScheme1 = read2(clrs) or nil
  else
    replColourScheme1 = nil
  end
else
  replColourScheme1 = nil
end
colourFor1 = function(elem)
  if assoc_3f_1(replColourScheme1, {tag="symbol", contents=elem}) then
    return constVal1(assoc1(replColourScheme1, {tag="symbol", contents=elem}))
  elseif elem == "text" then
    return "0"
  elseif elem == "arg" then
    return "36"
  elseif elem == "mono" then
    return "1;37"
  elseif elem == "bold" then
    return "1"
  elseif elem == "italic" then
    return "3"
  elseif elem == "link" then
    return "1;34"
  elseif elem == "comment" then
    return "1;30"
  elseif elem == "string" then
    return "32"
  elseif elem == "number" then
    return "0"
  elseif elem == "key" then
    return "36"
  elseif elem == "symbol" then
    return "0"
  elseif elem == "keyword" then
    return "35"
  elseif elem == "operator" then
    return "0"
  else
    return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(elem) .. ", but none matched.\n" .. "  Tried: `\"text\"`\n  Tried: `\"arg\"`\n  Tried: `\"mono\"`\n  Tried: `\"bold\"`\n  Tried: `\"italic\"`\n  Tried: `\"link\"`\n  Tried: `\"comment\"`\n  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"key\"`\n  Tried: `\"symbol\"`\n  Tried: `\"keyword\"`\n  Tried: `\"operator\"`")
  end
end
tokenMapping1 = {string="string", interpolate="string", number="number", key="key", symbol="symbol", open="operator", close="operator", ["open-struct"]="operator", ["close-struct"]="operator", quote="operator", ["quasi-quote"]="operator", ["syntax-quote"]="operator", unquote="operator", ["unquote-splice"]="operator"}
keywords2 = createLookup1({tag="list", n=33, "define", "define-macro", "define-native", "lambda", "set!", "cond", "import", "struct-literal", "quote", "syntax-quote", "unquote", "unquote-splice", "defun", "defmacro", "car", "cdr", "list", "cons", "progn", "if", "when", "unless", "let", "let*", "with", "not", "gensym", "for", "while", "and", "or", "loop", "case"})
printDocs_21_1 = function(str)
  local docs = parseDocstring1(str)
  local forLimit = n1(docs)
  local i = 1
  while i <= forLimit do
    local tok = docs[i]
    local tag = tok["kind"]
    if tag == "bolic" then
      write1(coloured1(colourFor1("bold"), coloured1(colourFor1("italic"), tok["contents"])))
    else
      write1(coloured1(colourFor1(tag), tok["contents"]))
    end
    i = i + 1
  end
  return print1()
end
execCommand1 = function(compiler, scope, args)
  local logger, command = compiler["log"], car1(args)
  if command == "help" or command == "h" then
    return print1("REPL commands:\n[:d]oc NAME        Get documentation about a symbol\n:module NAME       Display a loaded module's docs and definitions.\n[:r]eload          Reload all modules which have changed.\n:scope             Print out all variables in the scope\n[:s]earch QUERY    Search the current scope for symbols and documentation containing a string.\n[:v]iew NAME       Display the definition of a symbol.\n[:q]uit            Exit the REPL cleanly.")
  elseif command == "doc" or command == "d" then
    local name = nth1(args, 2)
    if name then
      local var = lookup1(scope, name)
      if var == nil then
        return self1(logger, "put-error!", ("Cannot find '" .. name .. "'"))
      else
        local sig, name2 = extractSignature1(var), var["full-name"]
        if sig then
          name2 = "(" .. concat2(cons1(name2, sig), " ") .. ")"
        end
        print1(coloured1("36;1", name2))
        local docs = var["doc"]
        if docs then
          return printDocs_21_1(docs)
        else
          return self1(logger, "put-error!", ("No documentation for '" .. name2 .. "'"))
        end
      end
    else
      return self1(logger, "put-error!", ":doc <variable>")
    end
  elseif command == "module" then
    local name = nth1(args, 2)
    if name then
      local mod = compiler["libs"]["names"][name]
      if mod == nil then
        return self1(logger, "put-error!", ("Cannot find '" .. name .. "'"))
      else
        print1(coloured1("36;1", mod["name"]))
        print1("Located at " .. mod["path"])
        local docs = mod["docs"]
        if docs then
          print1()
          printDocs_21_1(docs)
        end
        local vars
        local xs = (keys1((mod["scope"]["exported"])))
        sort1(xs, nil)
        vars = xs
        if not empty_3f_1(vars) then
          print1()
          print1(coloured1("32;1", "Exported symbols"))
          print1(concat2(vars, "  "))
        end
        local imports
        local xs = (map2(libraryName1, (keys1((mod["depends"])))))
        sort1(xs, nil)
        imports = xs
        if empty_3f_1(imports) then
          return nil
        else
          print1()
          print1(coloured1("32;1", "Imports"))
          return print1(concat2(imports, " "))
        end
      end
    else
      return self1(logger, "put-error!", ":module <variable>")
    end
  elseif command == "search" or command == "s" then
    if n1(args) > 1 then
      local keywords, nameResults, docsResults, vars, varsSet, current = map2(lower1, slicingView1(args, 1)), {tag="list", n=0}, {tag="list", n=0}, {tag="list", n=0}, {}, scope
      while current do
        local temp = current["variables"]
        local temp1, var = next1(temp)
        while temp1 ~= nil do
          if not varsSet[temp1] then
            push_21_1(vars, temp1)
            varsSet[temp1] = true
          end
          temp1, var = next1(temp, temp1)
        end
        current = current["parent"]
      end
      local forLimit = n1(vars)
      local i = 1
      while i <= forLimit do
        local var = vars[i]
        local forLimit1 = n1(keywords)
        local i1 = 1
        while i1 <= forLimit1 do
          if find1(var, (keywords[i1])) then
            push_21_1(nameResults, var)
          end
          i1 = i1 + 1
        end
        local docVar = lookup1(scope, var)
        if docVar then
          local tempDocs = docVar["doc"]
          if tempDocs then
            local docs = lower1(tempDocs)
            if docs then
              local keywordsFound = 0
              if keywordsFound then
                local forLimit1 = n1(keywords)
                local i1 = 1
                while i1 <= forLimit1 do
                  if find1(docs, (keywords[i1])) then
                    keywordsFound = keywordsFound + 1
                  end
                  i1 = i1 + 1
                end
                if eq_3f_1(keywordsFound, n1(keywords)) then
                  push_21_1(docsResults, var)
                end
              end
            end
          end
        end
        i = i + 1
      end
      if empty_3f_1(nameResults) and empty_3f_1(docsResults) then
        return self1(logger, "put-error!", "No results")
      else
        if not empty_3f_1(nameResults) then
          print1(coloured1("32;1", "Search by function name:"))
          if n1(nameResults) > 20 then
            print1(concat2(slice1(nameResults, 1, min1(20, n1(nameResults))), "  ") .. "  ...")
          else
            print1(concat2(nameResults, "  "))
          end
        end
        if not empty_3f_1(docsResults) then
          print1(coloured1("32;1", "Search by function docs:"))
          if n1(docsResults) > 20 then
            return print1(concat2(slice1(docsResults, 1, min1(20, n1(docsResults))), "  ") .. "  ...")
          else
            return print1(concat2(docsResults, "  "))
          end
        else
          return nil
        end
      end
    else
      return self1(logger, "put-error!", ":search <keywords>")
    end
  elseif command == "scope" then
    local vars, varsSet, current = {tag="list", n=0}, {}, scope
    while current do
      local temp = current["variables"]
      local temp1, var = next1(temp)
      while temp1 ~= nil do
        if not varsSet[temp1] then
          push_21_1(vars, temp1)
          varsSet[temp1] = true
        end
        temp1, var = next1(temp, temp1)
      end
      current = current["parent"]
    end
    sort1(vars, nil)
    return print1(concat2(vars, "  "))
  elseif command == "view" or command == "v" then
    local name = nth1(args, 2)
    if name then
      local var = lookup1(scope, name)
      if var ~= nil then
        local node = var["node"]
        local range = node and sourceFullRange1(node["source"])
        if range ~= nil then
          local lines, start, finish, buffer = range["lines"], range["start"], range["finish"], {tag="list", n=0}
          local forStart, forLimit = start["line"], finish["line"]
          local i = forStart
          while i <= forLimit do
            push_21_1(buffer, sub1(lines[i], (function()
              if i == start["line"] then
                return start["column"]
              else
                return 1
              end
            end)(), (function()
              if i == finish["line"] then
                return finish["column"]
              else
                return -1
              end
            end)()))
            i = i + 1
          end
          local contents, previous = concat2(buffer, "\n"), 0
          local temp = lex1(void1, contents, "stdin")
          local forLimit = n1(temp)
          local i = 1
          while i <= forLimit do
            local tok = temp[i]
            local start1 = tok["source"]["start"]["offset"]
            if start1 ~= previous then
              write1(coloured1(colourFor1("comment"), sub1(contents, previous, start1 - 1)))
            end
            local tag = type1(tok)
            if tag ~= "eof" then
              if tag == "symbol" and keywords2[tok["contents"]] then
                write1(coloured1(colourFor1("keyword"), tok["contents"]))
              else
                write1(coloured1(colourFor1(tokenMapping1[type1(tok)]), tok["contents"]))
              end
            end
            previous = tok["source"]["finish"]["offset"] + 1
            i = i + 1
          end
          return write1("\n")
        else
          return self1(logger, "put-error!", ("Cannot extract source code for " .. quoted1(name)))
        end
      else
        return self1(logger, "put-error!", ("Cannot find " .. quoted1(name)))
      end
    else
      return self1(logger, "put-error!", ":view <variable>")
    end
  elseif command == "reload" or command == "r" then
    return reload1(compiler)
  elseif command == "quit" or command == "q" then
    print1("Goodbye.")
    return exit1(0)
  else
    return self1(logger, "put-error!", ("Unknown command '" .. command .. "'"))
  end
end
execString1 = function(compiler, scope, string)
  local logger = compiler["log"]
  local state = cadr1(list1(compile1(compiler, parse1(logger, (lex1(logger, string, "<stdin>"))), scope)))
  if n1(state) > 0 then
    local current = 0
    local exec, compileState, global, logger1, run = create2(function()
      local forLimit = n1(state)
      local i = 1
      while i <= forLimit do
        current = state[i]
        get_21_1(current)
        i = i + 1
      end
      return nil
    end), compiler["compile-state"], compiler["global"], compiler["log"], true
    while run do
      local res = list1(resume1(exec))
      if not car1(res) then
        self1(logger1, "put-error!", (cadr1(res)))
        run = false
      elseif status1(exec) == "dead" then
        local lvl = get_21_1(last1(state))
        local prettyFun = pretty1
        local prettyVar = lookup1(scope, "pretty")
        if prettyVar then
          prettyFun = get_21_1(compiler["states"][prettyVar])
        end
        print1("out = " .. coloured1("36;1", prettyFun(lvl)))
        global[pushEscapeVar_21_1(add_21_1(scope, "out", "defined", lvl), compileState)] = lvl
        run = false
      else
        local states = cadr1(res)["states"]
        local latest, co, task = car1(states), create2(executeStates1), nil
        while run and status1(co) ~= "dead" do
          compiler["active-node"] = latest["node"]
          compiler["active-scope"] = latest["scope"]
          local res1
          if task then
            res1 = list1(resume1(co))
          else
            res1 = list1(resume1(co, compileState, states, global))
          end
          compiler["active-node"] = nil
          compiler["active-scope"] = nil
          if type1(res1) == "list" and (n1(res1) >= 2 and (n1(res1) <= 2 and (nth1(res1, 1) == false and true))) then
            error1(nth1(res1, 2), 0)
          elseif type1(res1) == "list" and (n1(res1) >= 1 and (n1(res1) <= 1 and nth1(res1, 1) == true)) then
          elseif type1(res1) == "list" and (n1(res1) >= 2 and (n1(res1) <= 2 and (nth1(res1, 1) == true and true))) then
            local arg = nth1(res1, 2)
            if status1(co) ~= "dead" then
              task = arg
              local temp = type1(task)
              if temp == "execute" then
                executeStates1(compileState, task["states"], global)
              else
                local _ = "Cannot handle " .. temp
              end
            end
          else
            error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(res1) .. ", but none matched.\n" .. "  Tried: `(false ?msg)`\n  Tried: `(true)`\n  Tried: `(true ?arg)`")
          end
        end
      end
    end
    return nil
  else
    return nil
  end
end
repl1 = function(compiler, args)
  local scope, logger, buffer, running = child1(compiler["root-scope"], "top-level"), compiler["log"], "", true
  local read_21_
  if args["read-dumb"] then
    read_21_ = readDumb1
  else
    read_21_ = readLine_21_1
  end
  local temp = args["input"]
  local forLimit = n1(temp)
  local i = 1
  while i <= forLimit do
    local library = car1(pathLoader1(compiler, (temp[i])))
    local temp1 = library["scope"]["exported"]
    local temp2, var = next1(temp1)
    while temp2 ~= nil do
      if scope["variables"][temp2] then
        import_21_1(scope, library["name"] .. "/" .. temp2, var)
      else
        import_21_1(scope, temp2, var)
      end
      temp2, var = next1(temp1, temp2)
    end
    i = i + 1
  end
  while running do
    local line = read_21_(coloured1("32;1", (function()
      if empty_3f_1(buffer) then
        return "> "
      else
        return ". "
      end
    end)()), getIndent1(buffer), function(x)
      return getComplete1(buffer .. x, scope)
    end)
    if not line and empty_3f_1(buffer) then
      running = false
    else
      local data
      if line then
        data = buffer .. line .. "\n"
      else
        data = buffer
      end
      if sub1(data, 1, 1) == ":" then
        buffer = ""
        execCommand1(compiler, scope, map2(trim1, split1(sub1(data, 2), " ")))
      elseif line and (n1(line) > 0 and requiresInput1(data)) then
        buffer = data
      else
        buffer = ""
        scope = child1(scope, "top-level")
        local res = list1(pcall1(execString1, compiler, scope, data))
        compiler["active-node"] = nil
        compiler["active-scope"] = nil
        if not (car1(res) or compilerError_3f_1(cadr1(res))) then
          self1(logger, "put-error!", (cadr1(res)))
        end
      end
    end
  end
  return nil
end
exec1 = function(compiler)
  local data, scope, logger = read1("*a"), compiler["root-scope"], compiler["log"]
  local res = list1(pcall1(execString1, compiler, scope, data))
  if not (car1(res) or compilerError_3f_1(cadr1(res))) then
    self1(logger, "put-error!", (cadr1(res)))
  end
  return exit1(0)
end
replTask1 = {name="repl", setup=function(spec)
  addArgument_21_1(spec, {tag="list", n=1, "--repl"}, "help", "Start an interactive session.")
  return addArgument_21_1(spec, {tag="list", n=1, "--read-dumb"}, "help", "Disable fancy readline input.")
end, pred=function(args)
  return args["repl"]
end, run=repl1}
execTask1 = {name="exec", setup=function(spec)
  return addArgument_21_1(spec, {tag="list", n=1, "--exec"}, "help", "Execute a program from stdin without compiling it. This acts as if it were input in one go via the REPL.")
end, pred=function(args)
  return args["exec"]
end, run=exec1}
dotQuote1 = function(prefix, name)
  if find1(name, "^[%w_][%d%w_]*$") then
    if string_3f_1(prefix) then
      return prefix .. "." .. name
    else
      return name
    end
  elseif string_3f_1(prefix) then
    return prefix .. "[" .. quoted1(name) .. "]"
  else
    return "_ENV[" .. quoted1(name) .. "]"
  end
end
genNative1 = function(compiler, args)
  if n1(args["input"]) ~= 1 then
    self1(compiler["log"], "put-error!", "Expected just one input")
    exit_21_1(1)
  end
  local prefix = args["gen-native"]
  local lib
  local cache, path = compiler["libs"], last1(args["input"])
  lib = cache["paths"][path]
  local maxName, maxQuot, natives = 0, 0, {tag="list", n=0}
  local temp = lib["nodes"]
  local forLimit = n1(temp)
  local i = 1
  while i <= forLimit do
    local node = temp[i]
    if type1(node) == "list" and (type1((car1(node))) == "symbol" and car1(node)["contents"] == "define-native") then
      local name = nth1(node, 2)["contents"]
      push_21_1(natives, name)
      maxName = max1(maxName, n1(quoted1(name)))
      maxQuot = max1(maxQuot, n1(quoted1(dotQuote1(prefix, name))))
    end
    i = i + 1
  end
  sort1(natives, nil)
  local handle, format = open1(lib["path"] .. ".meta.lua", "w"), "  [%-" .. tostring1(maxName + 3) .. "s { tag = \"var\", contents = %-" .. tostring1(maxQuot + 1) .. "s },\n"
  if not handle then
    self1(compiler["log"], "put-error!", ("Cannot write to " .. lib["path"] .. ".meta.lua"))
    exit_21_1(1)
  end
  self1(handle, "write", "return {\n")
  local forLimit = n1(natives)
  local i = 1
  while i <= forLimit do
    local native = natives[i]
    self1(handle, "write", format1(format, quoted1(native) .. "] =", quoted1(dotQuote1(prefix, native)) .. ","))
    i = i + 1
  end
  self1(handle, "write", "}\n")
  return self1(handle, "close")
end
task2 = {name="gen-native", setup=function(spec)
  return addArgument_21_1(spec, {tag="list", n=1, "--gen-native"}, "help", "Generate native bindings for a file", "var", "PREFIX", "narg", "?")
end, pred=function(args)
  return args["gen-native"]
end, run=genNative1}
profileCalls1 = function(fn, mappings)
  local stats, callStack = {}, {tag="list", n=0}
  sethook1(function(action)
    local info, start = getinfo1(2, "Sn"), clock1()
    if action == "call" then
      local previous = nth1(callStack, n1(callStack))
      if previous then
        previous["sum"] = previous["sum"] + (start - previous["inner-start"])
      end
    end
    if action ~= "call" then
      if not empty_3f_1(callStack) then
        local current = popLast_21_1(callStack)
        local hash = current["source"] .. current["linedefined"]
        local entry = stats[hash]
        if not entry then
          entry = {source=current["source"], ["short-src"]=current["short_src"], line=current["linedefined"], name=current["name"], calls=0, ["total-time"]=0, ["inner-time"]=0}
          stats[hash] = entry
        end
        entry["calls"] = 1 + entry["calls"]
        entry["total-time"] = entry["total-time"] + (start - current["total-start"])
        entry["inner-time"] = entry["inner-time"] + (current["sum"] + (start - current["inner-start"]))
      end
    end
    if action ~= "return" then
      info["total-start"] = start
      info["inner-start"] = start
      info["sum"] = 0
      push_21_1(callStack, info)
    end
    if action == "return" then
      local next = last1(callStack)
      if next then
        next["inner-start"] = start
        return nil
      else
        return nil
      end
    else
      return nil
    end
  end, "cr")
  fn()
  sethook1()
  local out = values1(stats)
  sort1(out, function(a, b)
    return a["inner-time"] > b["inner-time"]
  end)
  print1("|               Method | Location                                                     |    Total |    Inner |   Calls |")
  print1("| -------------------- | ------------------------------------------------------------ | -------- | -------- | ------- |")
  local forLimit = n1(out)
  local i = 1
  while i <= forLimit do
    local entry = out[i]
    print1(format1("| %20s | %-60s | %8.5f | %8.5f | %7d | ", (function()
      if entry["name"] then
        return unmangleIdent1(entry["name"])
      else
        return "<unknown>"
      end
    end)(), remapMessage1(mappings, entry["short-src"] .. ":" .. entry["line"]), entry["total-time"], entry["inner-time"], entry["calls"]))
    i = i + 1
  end
  return stats
end
buildStack1 = function(parent, stack, i, history, fold)
  parent["n"] = parent["n"] + 1
  if i >= 1 then
    local elem = nth1(stack, i)
    local hash = elem["source"] .. "|" .. elem["linedefined"]
    local previous, child = fold and history[hash], parent[hash]
    if previous then
      parent["n"] = parent["n"] - 1
      child = previous
    end
    if not child then
      child = elem
      elem["n"] = 0
      parent[hash] = child
    end
    if not previous then
      history[hash] = child
    end
    buildStack1(child, stack, i - 1, history, fold)
    if previous then
      return nil
    else
      history[hash] = nil
      return nil
    end
  else
    return nil
  end
end
buildRevStack1 = function(parent, stack, i, history, fold)
  parent["n"] = parent["n"] + 1
  if i <= n1(stack) then
    local elem = nth1(stack, i)
    local hash = elem["source"] .. "|" .. elem["linedefined"]
    local previous, child = fold and history[hash], parent[hash]
    if previous then
      parent["n"] = parent["n"] - 1
      child = previous
    end
    if not child then
      child = elem
      elem["n"] = 0
      parent[hash] = child
    end
    if not previous then
      history[hash] = child
    end
    buildRevStack1(child, stack, i + 1, history, fold)
    if previous then
      return nil
    else
      history[hash] = nil
      return nil
    end
  else
    return nil
  end
end
finishStack1 = function(element)
  local children = {tag="list", n=0}
  local temp, child = next1(element)
  while temp ~= nil do
    if type_23_1(child) == "table" then
      push_21_1(children, child)
    end
    temp, child = next1(element, temp)
  end
  sort1(children, function(a, b)
    return a["n"] > b["n"]
  end)
  element["children"] = children
  local forLimit = n1(children)
  local i = 1
  while i <= forLimit do
    finishStack1((children[i]))
    i = i + 1
  end
  return nil
end
showStack_21_1 = function(out, mappings, total, stack, remaining)
  line_21_1(out, format1("└ %s %s %d (%2.5f%%)", (function()
    if stack["name"] then
      return unmangleIdent1(stack["name"])
    else
      return "<unknown>"
    end
  end)(), (function()
    if stack["short_src"] then
      return remapMessage1(mappings, stack["short_src"] .. ":" .. stack["linedefined"])
    else
      return ""
    end
  end)(), stack["n"], (stack["n"] / total) * 100))
  local temp
  if remaining then
    temp = remaining >= 1
  else
    temp = true
  end
  if temp then
    out["indent"] = out["indent"] + 1
    local temp = stack["children"]
    local forLimit = n1(temp)
    local i = 1
    while i <= forLimit do
      showStack_21_1(out, mappings, total, temp[i], remaining and remaining - 1)
      i = i + 1
    end
    out["indent"] = out["indent"] - 1
    return nil
  else
    return nil
  end
end
showFlame_21_1 = function(mappings, stack, before, remaining)
  local renamed = (function()
    if stack["name"] then
      return unmangleIdent1(stack["name"])
    else
      return "?"
    end
  end)() .. "`" .. (function()
    if stack["short_src"] then
      return remapMessage1(mappings, stack["short_src"] .. ":" .. stack["linedefined"])
    else
      return ""
    end
  end)()
  print1(format1("%s%s %d", before, renamed, stack["n"]))
  local temp
  if remaining then
    temp = remaining >= 1
  else
    temp = true
  end
  if temp then
    local whole, temp = before .. renamed .. ";", stack["children"]
    local forLimit = n1(temp)
    local i = 1
    while i <= forLimit do
      showFlame_21_1(mappings, temp[i], whole, remaining and remaining - 1)
      i = i + 1
    end
    return nil
  else
    return nil
  end
end
profileStack1 = function(fn, mappings, args)
  local stacks, top = {tag="list", n=0}, getinfo1(2, "S")
  sethook1(function(action)
    local pos, stack, info = 2, {tag="list", n=0}, getinfo1(2, "Sn")
    while info do
      if info["source"] == top["source"] and info["linedefined"] == top["linedefined"] then
        info = nil
      else
        push_21_1(stack, info)
        pos = pos + 1
        info = getinfo1(pos, "Sn")
      end
    end
    return push_21_1(stacks, stack)
  end, "", 100000.0)
  fn()
  sethook1()
  local folded = {n=0, name="<root>"}
  local forLimit = n1(stacks)
  local i = 1
  while i <= forLimit do
    local stack = stacks[i]
    if args["stack-kind"] == "reverse" then
      buildRevStack1(folded, stack, 1, {}, args["stack-fold"])
    else
      buildStack1(folded, stack, n1(stack), {}, args["stack-fold"])
    end
    i = i + 1
  end
  finishStack1(folded)
  if args["stack-show"] == "flame" then
    return showFlame_21_1(mappings, folded, "", args["stack-limit"] or 30)
  else
    local writer = {out={tag="list", n=0}, indent=0, ["tabs-pending"]=false, line=1, lines={}, ["node-stack"]={tag="list", n=0}, ["active-pos"]=nil}
    showStack_21_1(writer, mappings, n1(stacks), folded, args["stack-limit"] or 10)
    return print1(concat2(writer["out"]))
  end
end
matcher2 = function(pattern)
  return function(x)
    local res = list1(match1(x, pattern))
    if car1(res) == nil then
      return nil
    else
      return res
    end
  end
end
addCount_21_1 = function(counts, name, line, count)
  local fileCounts = counts[name]
  if not fileCounts then
    fileCounts = {max=0}
    counts[name] = fileCounts
  end
  if line > fileCounts["max"] then
    fileCounts["max"] = line
  end
  fileCounts[line] = (fileCounts[line] or 0) + count
  return nil
end
readStats_21_1 = function(fileName, output)
  if not output then
    output = {}
  end
  local file = open1(fileName, "r")
  if file then
    while true do
      local max = self1(file, "read", "*n")
      if max then
        if self1(file, "read", 1) == ":" then
          local name = self1(file, "read", "*l")
          if name then
            local data = output[name]
            if not data then
              data = {max=max}
              output[name] = data
            elseif max > data["max"] then
              data["max"] = max
            end
            local line = 1
            while true do
              if (line > max) then
                break
              else
                local count = self1(file, "read", "*n")
                if count then
                  if self1(file, "read", 1) == " " then
                    if count > 0 then
                      data[line] = (data[line] or 0) + count
                    end
                    line = line + 1
                  else
                    break
                  end
                else
                  break
                end
              end
            end
          else
            break
          end
        else
          break
        end
      else
        break
      end
    end
    (getmetatable1(file) and getmetatable1(file)["--finalise"] or (file["close"] or function()
      return nil
    end))(file)
  end
  return output
end
writeStats_21_1 = function(compiler, fileName, output)
  local handle, err = open1(fileName, "w")
  if not handle then
    self1(compiler["log"], "put-error!", (formatOutput_21_1(nil, "Cannot open stats file " .. err)))
    exit_21_1(1)
  end
  local names = keys1(output)
  sort1(names, nil)
  local forLimit = n1(names)
  local i = 1
  while i <= forLimit do
    local name = names[i]
    local data = output[name]
    self1(handle, "write", data["max"], ":", name, "\n")
    local forLimit1 = data["max"]
    local i1 = 1
    while i1 <= forLimit1 do
      self1(handle, "write", data[i1] or 0, " ")
      i1 = i1 + 1
    end
    self1(handle, "write", "\n")
    i = i + 1
  end
  return self1(handle, "close")
end
profileCoverageHook1 = function(visited)
  return function(action, line)
    local source = getinfo1(2, "S")["short_src"]
    local visitedLines = visited[source]
    if not visitedLines then
      visitedLines = {}
      visited[source] = visitedLines
    end
    local current = (visitedLines[line] or 0) + 1
    visitedLines[line] = current
    return nil
  end
end
profileCoverage1 = function(fn, mappings, compiler)
  local visited = compiler["coverage-visited"] or {}
  sethook1(profileCoverageHook1(visited), "l")
  fn()
  sethook1()
  visited[getinfo1(1, "S")["short_src"]] = nil
  local result = readStats_21_1("luacov.stats.out")
  local temp, visitedLines = next1(visited)
  while temp ~= nil do
    local thisMappings = mappings[temp]
    if thisMappings then
      local temp1, count = next1(visitedLines)
      while temp1 ~= nil do
        local mapped = thisMappings[temp1]
        if mapped == nil then
        else
          local temp2
          local temp3 = matcher2("^(.-):(%d+)%-(%d+)$")(mapped)
          temp2 = type1(temp3) == "list" and (n1(temp3) >= 3 and (n1(temp3) <= 3 and true))
          if temp2 then
            local file, start, _eend = nth1(matcher2("^(.-):(%d+)%-(%d+)$")(mapped), 1), nth1(matcher2("^(.-):(%d+)%-(%d+)$")(mapped), 2), nth1(matcher2("^(.-):(%d+)%-(%d+)$")(mapped), 3)
            local forStart, forLimit = tonumber1(start), tonumber1(_eend)
            local line = forStart
            while line <= forLimit do
              addCount_21_1(result, file, tonumber1(line), count)
              line = line + 1
            end
          else
            local temp2
            local temp3 = matcher2("^(.-):(%d+)$")(mapped)
            temp2 = type1(temp3) == "list" and (n1(temp3) >= 2 and (n1(temp3) <= 2 and true))
            if temp2 then
              addCount_21_1(result, nth1(matcher2("^(.-):(%d+)$")(mapped), 1), tonumber1((nth1(matcher2("^(.-):(%d+)$")(mapped), 2))), count)
            else
              error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(mapped) .. ", but none matched.\n" .. "  Tried: `nil`\n  Tried: `((matcher \"^(.-):(%d+)%-(%d+)$\") -> (?file ?start ?end))`\n  Tried: `((matcher \"^(.-):(%d+)$\") -> (?file ?line))`")
            end
          end
        end
        temp1, count = next1(visitedLines, temp1)
      end
    else
      local temp1, count = next1(visitedLines)
      while temp1 ~= nil do
        addCount_21_1(result, temp, temp1, count)
        temp1, count = next1(visitedLines, temp1)
      end
    end
    temp, visitedLines = next1(visited, temp)
  end
  return writeStats_21_1(compiler, "luacov.stats.out", result)
end
formatCoverage1 = function(hits, misses)
  if hits == 0 and misses == 0 then
    return "100%"
  else
    return format1("%2.f%%", 100 * (hits / (hits + misses)))
  end
end
genCoverageReport1 = function(compiler, args)
  if empty_3f_1(args["input"]) then
    self1(compiler["log"], "put-error!", "No inputs to generate a report for.")
    exit_21_1(1)
  end
  local stats, logger, max = readStats_21_1("luacov.stats.out"), compiler["log"], 0
  local temp, counts = next1(stats)
  while temp ~= nil do
    local temp1, count = next1(counts)
    while temp1 ~= nil do
      if number_3f_1(temp1) and count > max then
        max = count
      end
      temp1, count = next1(counts, temp1)
    end
    temp, counts = next1(stats, temp)
  end
  local maxSize = n1(format1("%d", max))
  local fmtZero, fmtNone, fmtNum, handle, err = rep1("*", maxSize) .. "0", rep1(" ", maxSize + 1), "%" .. maxSize + 1 .. "d", open1(args["gen-coverage"] or "luacov.report.out", "w")
  local summary, totalHits, totalMisses = {tag="list", n=0}, 0, 0
  if not handle then
    self1(logger, "put-error!", (formatOutput_21_1(nil, "Cannot open report file " .. err)))
    exit_21_1(1)
  end
  local temp = args["input"]
  local forLimit = n1(temp)
  local i = 1
  while i <= forLimit do
    local path = temp[i]
    self1(handle, "write", "==============================================================================", "\n")
    self1(handle, "write", path, "\n")
    self1(handle, "write", "==============================================================================", "\n")
    local lib = compiler["libs"]["paths"][path]
    local lines = lib["lisp-lines"]
    local nLines, counts, active, hits, misses = n1(lines), stats[path], {}, 0, 0
    visitBlock1(lib["nodes"], 1, function(node)
      local temp1
      if type1(node) ~= "list" then
        temp1 = true
      else
        local head = car1(node)
        local temp2 = type1(head)
        if temp2 == "symbol" then
          local var = head["var"]
          temp1 = var ~= builtins1["lambda"] and (var ~= builtins1["cond"] and (var ~= builtins1["import"] and (var ~= builtins1["define"] and (var ~= builtins1["define-macro"] and var ~= builtins1["define-native"]))))
        elseif temp2 == "list" then
          temp1 = not builtin_3f_1(car1(head), "lambda")
        else
          temp1 = true
        end
      end
      if temp1 then
        local source = sourceRange1(node["source"])
        if source["name"] == path then
          local forStart, forLimit1 = source["start"]["line"], source["finish"]["line"]
          local i1 = forStart
          while i1 <= forLimit1 do
            active[i1] = true
            i1 = i1 + 1
          end
          return nil
        else
          return nil
        end
      else
        return nil
      end
    end)
    local i1 = 1
    while i1 <= nLines do
      local line, isActive, count = nth1(lines, i1), active[i1], counts and counts[i1] or 0
      if not isActive and count > 0 then
        self1(logger, "put-warning!", (formatOutput_21_1(nil, "" .. path .. ":" .. i1 .. " is not active but has count " .. count)))
      end
      if not isActive then
        if line == "" then
          self1(handle, "write", "\n")
        else
          self1(handle, "write", fmtNone, " ", line, "\n")
        end
      elseif count > 0 then
        hits = hits + 1
        self1(handle, "write", format1(fmtNum, count), " ", line, "\n")
      else
        misses = misses + 1
        self1(handle, "write", fmtZero, " ", line, "\n")
      end
      i1 = i1 + 1
    end
    push_21_1(summary, list1(path, format1("%d", hits), format1("%d", misses), formatCoverage1(hits, misses)))
    totalHits = totalHits + hits
    totalMisses = totalMisses + misses
    i = i + 1
  end
  self1(handle, "write", "==============================================================================", "\n")
  self1(handle, "write", "Summary\n")
  self1(handle, "write", "==============================================================================", "\n\n")
  local headings = {tag="list", n=4, "File", "Hits", "Misses", "Coverage"}
  local widths, total = map2(n1, headings), list1("Total", format1("%d", totalHits), format1("%d", totalMisses), formatCoverage1(totalHits, totalMisses))
  local forLimit = n1(summary)
  local i = 1
  while i <= forLimit do
    local row = summary[i]
    local forLimit1 = n1(row)
    local i1 = 1
    while i1 <= forLimit1 do
      local width = n1(row[i1])
      if width > widths[i1] then
        widths[i1] = width
      end
      i1 = i1 + 1
    end
    i = i + 1
  end
  local forLimit = n1(total)
  local i = 1
  while i <= forLimit do
    if n1(total[i]) > widths[i] then
      widths = i
    end
    i = i + 1
  end
  local format = "%-" .. concat2(widths, "s %-") .. "s\n"
  local separator = rep1("-", n1(apply1(format1, format, headings))) .. "\n"
  self1(handle, "write", apply1(format1, format, headings))
  self1(handle, "write", separator)
  local forLimit = n1(summary)
  local i = 1
  while i <= forLimit do
    self1(handle, "write", apply1(format1, format, (summary[i])))
    i = i + 1
  end
  self1(handle, "write", separator)
  self1(handle, "write", apply1(format1, format, total))
  return self1(handle, "close")
end
initLua1 = function(compiler, args)
  if args["profile-compile"] then
    if args["profile"] == "coverage" then
      local visited = {}
      local hook, exec = profileCoverageHook1(visited), compiler["exec"]
      compiler["coverage-visited"] = visited
      compiler["exec"] = function(func)
        sethook1(hook, "l")
        local result = exec(func)
        sethook1()
        return result
      end
      return nil
    else
      return nil
    end
  else
    return nil
  end
end
runLua1 = function(compiler, args)
  if empty_3f_1(args["input"]) then
    self1(compiler["log"], "put-error!", "No inputs to run.")
    exit_21_1(1)
  end
  local out = file1(compiler, false)
  local lines, logger = generateMappings1(out["lines"]), compiler["log"]
  local name
  if string_3f_1(args["emit-lua"]) then
    name = args["emit-lua"]
  else
    name = args["output"] .. ".lua"
  end
  local temp = list1(load1(concat2(out["out"]), "=" .. name))
  if type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (nth1(temp, 1) == nil and true))) then
    local msg = nth1(temp, 2)
    self1(logger, "put-error!", "Cannot load compiled source.")
    print1(msg)
    print1(concat2(out["out"]))
    return exit_21_1(1)
  elseif type1(temp) == "list" and (n1(temp) >= 1 and (n1(temp) <= 1 and true)) then
    local fun = nth1(temp, 1)
    _5f_G1["arg"] = args["script-args"]
    _5f_G1["arg"][0] = car1(args["input"])
    local exec, temp1 = function()
      local temp2 = list1(xpcall1(function()
        return apply1(fun, args["script-args"])
      end, traceback2))
      if type1(temp2) == "list" and (n1(temp2) >= 1 and (nth1(temp2, 1) == true and true)) then
        return nil
      elseif type1(temp2) == "list" and (n1(temp2) >= 2 and (n1(temp2) <= 2 and (nth1(temp2, 1) == false and true))) then
        local msg = nth1(temp2, 2)
        self1(logger, "put-error!", "Execution failed.")
        print1(remapTraceback1({[name]=lines}, msg))
        return exit_21_1(1)
      else
        return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp2) .. ", but none matched.\n" .. "  Tried: `(true . _)`\n  Tried: `(false ?msg)`")
      end
    end, args["profile"]
    if temp1 == "none" then
      return exec()
    elseif temp1 == nil then
      return exec()
    elseif temp1 == "call" then
      return profileCalls1(exec, {[name]=lines})
    elseif temp1 == "stack" then
      return profileStack1(exec, {[name]=lines}, args)
    elseif temp1 == "coverage" then
      return profileCoverage1(exec, merge1(compiler["compile-state"]["mappings"], {[name]=lines}), compiler)
    else
      self1(logger, "put-error!", ("Unknown profiler '" .. temp1 .. "'"))
      return exit_21_1(1)
    end
  else
    return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `(nil ?msg)`\n  Tried: `(?fun)`")
  end
end
task3 = {name="run", setup=function(spec)
  addCategory_21_1(spec, "run", "Running files", "Provides a way to running the compiled script, along with various extensions such as profiling tools.")
  addArgument_21_1(spec, {tag="list", n=2, "--run", "-r"}, "help", "Run the compiled code.", "cat", "run")
  addArgument_21_1(spec, {tag="list", n=1, "--"}, "name", "script-args", "cat", "run", "help", "Arguments to pass to the compiled script.", "var", "ARG", "all", true, "default", {tag="list", n=0}, "action", addAction1, "narg", "*")
  addArgument_21_1(spec, {tag="list", n=2, "--profile", "-p"}, "help", "Run the compiled code with the profiler.", "cat", "run", "var", "none|call|stack", "default", nil, "value", "stack", "narg", "?")
  addArgument_21_1(spec, {tag="list", n=1, "--profile-compile"}, "help", "Run the profiler when evaluating code at compile time. Not all profilers support this.", "cat", "run")
  addArgument_21_1(spec, {tag="list", n=1, "--stack-kind"}, "help", "The kind of stack to emit when using the stack profiler. A reverse stack shows callers of that method instead.", "cat", "run", "var", "forward|reverse", "default", "forward", "narg", 1)
  addArgument_21_1(spec, {tag="list", n=1, "--stack-show"}, "help", "The method to use to display the profiling results.", "cat", "run", "var", "flame|term", "default", "term", "narg", 1)
  addArgument_21_1(spec, {tag="list", n=1, "--stack-limit"}, "help", "The maximum number of call frames to emit.", "cat", "run", "var", "LIMIT", "default", nil, "action", setNumAction1, "narg", 1)
  return addArgument_21_1(spec, {tag="list", n=1, "--stack-fold"}, "help", "Whether to fold recursive functions into themselves. This hopefully makes deep graphs easier to understand, but may result in less accurate graphs.", "cat", "run", "value", true, "default", false)
end, pred=function(args)
  return args["run"] or args["profile"]
end, init=initLua1, run=runLua1}
coverageReport1 = {name="coverage-report", setup=function(spec)
  return addArgument_21_1(spec, {tag="list", n=1, "--gen-coverage"}, "help", "Specify the folder to emit documentation to.", "cat", "run", "default", nil, "value", "luacov.report.out", "narg", "?")
end, pred=function(args)
  return nil ~= args["gen-coverage"]
end, run=genCoverageReport1}
getVar1 = function(state, var)
  local vars = state["usage-vars"]
  local entry = vars[var]
  if not entry then
    entry = {var=var, usages={tag="list", n=0}, soft={tag="list", n=0}, defs={tag="list", n=0}, active=false}
    vars[var] = entry
  end
  return entry
end
addUsage_21_1 = function(state, var, node)
  local varMeta = getVar1(state, var)
  push_21_1(varMeta["usages"], node)
  varMeta["active"] = true
  return nil
end
removeUsage_21_1 = function(state, var, node)
  local varMeta = getVar1(state, var)
  local users = varMeta["usages"]
  local forStart = n1(users)
  local i = forStart
  while i >= 1 do
    if nth1(users, i) == node then
      removeNth_21_1(users, i)
      if empty_3f_1(users) then
        varMeta["active"] = false
      end
    end
    i = i + -1
  end
  return nil
end
addDefinition_21_1 = function(state, var, node, kind, value)
  return push_21_1(getVar1(state, var)["defs"], {tag=kind, node=node, value=value})
end
replaceDefinition_21_1 = function(state, var, oldValue, newKind, newValue)
  local varMeta = state["usage-vars"][var]
  if varMeta then
    local temp = varMeta["defs"]
    local forLimit = n1(temp)
    local i = 1
    while i <= forLimit do
      local def = temp[i]
      if def["value"] == oldValue then
        def["tag"] = newKind
        def["value"] = newValue
      end
      i = i + 1
    end
    return nil
  else
    return nil
  end
end
populateDefinitions1 = function(state, nodes, visit_3f_)
  if not visit_3f_ then
    visit_3f_ = function()
      return true
    end
  end
  local queue, lazyDefs, addCheckedUsage_21_, addLazyDef_21_, visitQuote, visitNode = {tag="list", n=0}, {}
  addCheckedUsage_21_ = function(var, user)
    if not getVar1(state, var)["active"] then
      local defs = lazyDefs[var]
      if defs then
        local forLimit = n1(defs)
        local i = 1
        while i <= forLimit do
          push_21_1(queue, (defs[i]))
          i = i + 1
        end
      end
    end
    return addUsage_21_1(state, var, user)
  end
  addLazyDef_21_ = function(var, node)
    if getVar1(state, var)["active"] then
      return true
    else
      local defs = lazyDefs[var]
      if not defs then
        defs = {tag="list", n=0}
        lazyDefs[var] = defs
      end
      push_21_1(defs, node)
      return false
    end
  end
  visitQuote = function(node, level)
    while true do
      if level == 0 then
        return visitNode(node)
      else
        local temp = type1(node)
        if temp == "string" then
          return nil
        elseif temp == "number" then
          return nil
        elseif temp == "key" then
          return nil
        elseif temp == "symbol" then
          local var = node["var"]
          if var then
            return push_21_1(getVar1(state, var)["soft"], node)
          else
            return nil
          end
        elseif temp == "list" then
          local first = nth1(node, 1)
          if type1(first) ~= "symbol" then
            local forLimit = n1(node)
            local i = 1
            while i <= forLimit do
              local sub = node[i]
              visitQuote(sub, level)
              i = i + 1
            end
            return nil
          elseif first["contents"] == "unquote" or first["contents"] == "unquote-splice" then
            node, level = nth1(node, 2), level - 1
          elseif first["contents"] == "syntax-quote" then
            node, level = nth1(node, 2), level + 1
          else
            local forLimit = n1(node)
            local i = 1
            while i <= forLimit do
              local sub = node[i]
              visitQuote(sub, level)
              i = i + 1
            end
            return nil
          end
        else
          return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"key\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`")
        end
      end
    end
  end
  visitNode = function(node)
    while true do
      local temp = type1(node)
      if temp == "string" then
        return nil
      elseif temp == "number" then
        return nil
      elseif temp == "key" then
        return nil
      elseif temp == "symbol" then
        return addCheckedUsage_21_(node["var"], node)
      elseif temp == "list" then
        local head = car1(node)
        local temp1 = type1(head)
        if temp1 == "symbol" then
          local func = head["var"]
          if func["kind"] ~= "builtin" then
            local forLimit = n1(node)
            local i = 1
            while i <= forLimit do
              visitNode(nth1(node, i))
              i = i + 1
            end
            return nil
          elseif func == builtins1["lambda"] then
            local temp2 = nth1(node, 2)
            local forLimit = n1(temp2)
            local i = 1
            while i <= forLimit do
              local arg = temp2[i]
              addDefinition_21_1(state, arg["var"], arg, "var", arg["var"])
              i = i + 1
            end
            local forLimit = n1(node)
            local i = 3
            while i <= forLimit do
              visitNode(nth1(node, i))
              i = i + 1
            end
            return nil
          elseif func == builtins1["define-native"] then
            return addDefinition_21_1(state, node["def-var"], node, "var", node["def-var"])
          elseif func == builtins1["set!"] then
            local var, val = nth1(node, 2)["var"], nth1(node, 3)
            addDefinition_21_1(state, var, node, "val", val)
            if visit_3f_(val, var, node) or addLazyDef_21_(var, val) then
              node = val
            else
              return nil
            end
          elseif func == builtins1["define"] or func == builtins1["define-macro"] then
            local var, val = node["def-var"], last1(node)
            addDefinition_21_1(state, var, node, "val", val)
            if visit_3f_(val, var, node) or addLazyDef_21_(var, val) then
              node = val
            else
              return nil
            end
          elseif func == builtins1["cond"] then
            local forLimit = n1(node)
            local i = 2
            while i <= forLimit do
              local temp2 = nth1(node, i)
              local forLimit1 = n1(temp2)
              local i1 = 1
              while i1 <= forLimit1 do
                local child = temp2[i1]
                visitNode(child)
                i1 = i1 + 1
              end
              i = i + 1
            end
            return nil
          elseif func == builtins1["quote"] then
            return nil
          elseif func == builtins1["syntax-quote"] then
            return visitQuote(nth1(node, 2), 1)
          elseif func == builtins1["import"] then
            return nil
          elseif func == builtins1["struct-literal"] then
            local forLimit = n1(node)
            local i = 2
            while i <= forLimit do
              visitNode(nth1(node, i))
              i = i + 1
            end
            return nil
          else
            return error1("Unhandled variable " .. func["name"], 0)
          end
        elseif temp1 == "list" then
          if builtin_3f_1(car1(head), "lambda") then
            local temp2 = zipArgs1(cadar1(node), 1, node, 2)
            local forLimit = n1(temp2)
            local i = 1
            while i <= forLimit do
              local zipped = temp2[i]
              local args, vals = car1(zipped), cadr1(zipped)
              if n1(args) == 1 and (n1(vals) <= 1 and not car1(args)["var"]["is-variadic"]) then
                local var, val = car1(args)["var"], car1(vals) or makeNil1()
                addDefinition_21_1(state, var, car1(args), "val", val)
                if visit_3f_(val, var, node) or addLazyDef_21_(var, val) then
                  visitNode(val)
                end
              else
                local forLimit1 = n1(args)
                local i1 = 1
                while i1 <= forLimit1 do
                  local arg = args[i1]
                  addDefinition_21_1(state, arg["var"], arg, "var", arg["var"])
                  i1 = i1 + 1
                end
                local forLimit1 = n1(vals)
                local i1 = 1
                while i1 <= forLimit1 do
                  local val = vals[i1]
                  visitNode(val)
                  i1 = i1 + 1
                end
              end
              i = i + 1
            end
            local forLimit = n1(head)
            local i = 3
            while i <= forLimit do
              visitNode(nth1(head, i))
              i = i + 1
            end
            return nil
          else
            local forLimit = n1(node)
            local i = 1
            while i <= forLimit do
              visitNode(nth1(node, i))
              i = i + 1
            end
            return nil
          end
        else
          local forLimit = n1(node)
          local i = 1
          while i <= forLimit do
            visitNode(nth1(node, i))
            i = i + 1
          end
          return nil
        end
      else
        return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"key\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`")
      end
    end
  end
  local forLimit = n1(nodes)
  local i = 1
  while i <= forLimit do
    push_21_1(queue, (nodes[i]))
    i = i + 1
  end
  while n1(queue) > 0 do
    visitNode(popLast_21_1(queue))
  end
  return nil
end
visitLazyDefinition_3f_1 = function(val, _5f_, node)
  return node["def-var"] == nil and not (type1(val) == "list" and builtin_3f_1(car1(val), "lambda"))
end
visitEagerExported_3f_1 = function(val, _5f_, node)
  local def = node["def-var"]
  local temp
  if def then
    local temp1 = def["kind"] == "macro"
    if temp1 then
      temp = temp1
    else
      local scope, name = def["scope"], def["name"]
      temp = scope["exported"][name]
    end
  else
    temp = def
  end
  return temp or (type1(val) ~= "list" or not builtin_3f_1(car1(val), "lambda"))
end
tagUsage1 = {name="tag-usage", help="Gathers usage and definition data for all expressions in NODES, storing it in LOOKUP.", cat={tag="list", n=2, "tag", "usage"}, run=function(temp, state, nodes, lookup, visit_3f_)
  local visit_3f_1
  if visit_3f_ == nil then
    visit_3f_1 = visitLazyDefinition_3f_1
  else
    visit_3f_1 = visit_3f_
  end
  lookup["usage-vars"] = {}
  return populateDefinitions1(lookup, nodes, visit_3f_1)
end}
transform1 = function(nodes, transformers, lookup)
  local pre, post, preBlock, postBlock, preBind, postBind, transformQuote, transformNode = transformers["pre"], transformers["post"], transformers["pre-block"], transformers["post-block"], transformers["pre-bind"], transformers["post-bind"]
  transformQuote = function(node, level)
    if level == 0 then
      return transformNode(node)
    else
      local tag = type1(node)
      if tag == "string" or tag == "number" or tag == "key" or tag == "symbol" then
      elseif tag == "list" then
        local first = nth1(node, 1)
        if first and type1(first) == "symbol" then
          if first["contents"] == "unquote" or first["contents"] == "unquote-splice" then
            node[2] = transformQuote(nth1(node, 2), level - 1)
          elseif first["contents"] == "syntax-quote" then
            node[2] = transformQuote(nth1(node, 2), level + 1)
          else
            local forLimit = n1(node)
            local i = 1
            while i <= forLimit do
              node[i] = transformQuote(nth1(node, i), level)
              i = i + 1
            end
          end
        else
          local forLimit = n1(node)
          local i = 1
          while i <= forLimit do
            node[i] = transformQuote(nth1(node, i), level)
            i = i + 1
          end
        end
      else
        error1("Unknown tag " .. tag)
      end
      return node
    end
  end
  transformNode = function(node)
    local forLimit = n1(pre)
    local i = 1
    while i <= forLimit do
      node = pre[i](node)
      i = i + 1
    end
    local temp = type1(node)
    if temp == "string" then
    elseif temp == "number" then
    elseif temp == "key" then
    elseif temp == "symbol" then
    elseif temp == "list" then
      local head = car1(node)
      local temp1 = type1(head)
      if temp1 == "symbol" then
        local func = head["var"]
        if func["kind"] ~= "builtin" then
          local forLimit = n1(node)
          local i = 1
          while i <= forLimit do
            node[i] = transformNode(nth1(node, i))
            i = i + 1
          end
        elseif func == builtins1["lambda"] then
          local forLimit = n1(preBlock)
          local i = 1
          while i <= forLimit do
            preBlock[i](node, 3)
            i = i + 1
          end
          local forLimit = n1(node)
          local i = 3
          while i <= forLimit do
            node[i] = transformNode(nth1(node, i))
            i = i + 1
          end
          local forLimit = n1(postBlock)
          local i = 1
          while i <= forLimit do
            postBlock[i](node, 3)
            i = i + 1
          end
        elseif func == builtins1["cond"] then
          local forLimit = n1(node)
          local i = 2
          while i <= forLimit do
            local branch = nth1(node, i)
            branch[1] = transformNode(nth1(branch, 1))
            local forLimit1 = n1(preBlock)
            local i1 = 1
            while i1 <= forLimit1 do
              preBlock[i1](branch, 2)
              i1 = i1 + 1
            end
            local forLimit1 = n1(branch)
            local i1 = 2
            while i1 <= forLimit1 do
              branch[i1] = transformNode(nth1(branch, i1))
              i1 = i1 + 1
            end
            local forLimit1 = n1(postBlock)
            local i1 = 1
            while i1 <= forLimit1 do
              postBlock[i1](branch, 2)
              i1 = i1 + 1
            end
            i = i + 1
          end
        elseif func == builtins1["set!"] then
          local old = nth1(node, 3)
          local new = transformNode(old)
          if old ~= new then
            replaceDefinition_21_1(lookup, nth1(node, 2)["var"], old, "val", new)
            node[3] = new
          end
        elseif func == builtins1["quote"] then
        elseif func == builtins1["syntax-quote"] then
          node[2] = transformQuote(nth1(node, 2), 1)
        elseif func == builtins1["unquote"] or func == builtins1["unquote-splice"] then
          error1("unquote/unquote-splice should never appear head", 0)
        elseif func == builtins1["define"] or func == builtins1["define-macro"] then
          local len = n1(node)
          local old = nth1(node, len)
          local new = transformNode(old)
          if old ~= new then
            replaceDefinition_21_1(lookup, node["def-var"], old, "val", new)
            node[len] = new
          end
        elseif func == builtins1["define-native"] then
        elseif func == builtins1["import"] then
        elseif func == builtins1["struct-literal"] then
          local forLimit = n1(node)
          local i = 1
          while i <= forLimit do
            node[i] = transformNode(nth1(node, i))
            i = i + 1
          end
        else
          error1("Unknown variable " .. func["name"], 0)
        end
      elseif temp1 == "list" then
        if builtin_3f_1(car1(head), "lambda") then
          local forLimit = n1(preBind)
          local i = 1
          while i <= forLimit do
            preBind[i](node)
            i = i + 1
          end
          local valI, temp2 = 2, zipArgs1(nth1(head, 2), 1, node, 2)
          local forLimit = n1(temp2)
          local i = 1
          while i <= forLimit do
            local zipped = temp2[i]
            local args, vals = car1(zipped), cadr1(zipped)
            if n1(args) == 1 and (n1(vals) == 1 and not car1(args)["var"]["is-variadic"]) then
              local old = car1(vals)
              local new = transformNode(old)
              if old ~= new then
                replaceDefinition_21_1(lookup, car1(args)["var"], old, "val", new)
                node[valI] = new
              end
              valI = valI + 1
            else
              local forLimit1 = n1(vals)
              local i1 = 1
              while i1 <= forLimit1 do
                local val = vals[i1]
                node[valI] = transformNode(val)
                valI = valI + 1
                i1 = i1 + 1
              end
            end
            i = i + 1
          end
          local forLimit = n1(preBlock)
          local i = 1
          while i <= forLimit do
            preBlock[i](head, 3)
            i = i + 1
          end
          local forLimit = n1(head)
          local i = 3
          while i <= forLimit do
            head[i] = transformNode(nth1(head, i))
            i = i + 1
          end
          local forLimit = n1(postBlock)
          local i = 1
          while i <= forLimit do
            postBlock[i](head, 2)
            i = i + 1
          end
          local forLimit = n1(postBind)
          local i = 1
          while i <= forLimit do
            postBind[i](node)
            i = i + 1
          end
        else
          local forLimit = n1(node)
          local i = 1
          while i <= forLimit do
            node[i] = transformNode(nth1(node, i))
            i = i + 1
          end
        end
      else
        local forLimit = n1(node)
        local i = 1
        while i <= forLimit do
          node[i] = transformNode(nth1(node, i))
          i = i + 1
        end
      end
    else
      error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"key\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`")
    end
    local forLimit = n1(post)
    local i = 1
    while i <= forLimit do
      node = post[i](node)
      i = i + 1
    end
    return node
  end
  local forLimit = n1(preBlock)
  local i = 1
  while i <= forLimit do
    preBlock[i](nodes, 1)
    i = i + 1
  end
  local forLimit = n1(nodes)
  local i = 1
  while i <= forLimit do
    nodes[i] = transformNode(nth1(nodes, i))
    i = i + 1
  end
  local forLimit = n1(postBlock)
  local i = 1
  while i <= forLimit do
    postBlock[i](nodes, 1)
    i = i + 1
  end
  return nil
end
emptyTransformers1 = function()
  return {pre={tag="list", n=0}, ["pre-block"]={tag="list", n=0}, ["pre-bind"]={tag="list", n=0}, post={tag="list", n=0}, ["post-block"]={tag="list", n=0}, ["post-bind"]={tag="list", n=0}}
end
transformer1 = {name="transformer", help="Run the given TRANSFORMERS on the provides NODES with the given\nLOOKUP information.", cat={tag="list", n=2, "opt", "usage"}, run=function(temp, state, nodes, lookup, transformers)
  local trackers, transLookup = {tag="list", n=0}, emptyTransformers1()
  local forLimit = n1(transformers)
  local i = 1
  while i <= forLimit do
    local trans, tracker = transformers[i], {changed=0}
    local run = trans["run"]
    push_21_1(trackers, tracker)
    local temp1 = trans["cat"]
    local forLimit1 = n1(temp1)
    local i1 = 1
    while i1 <= forLimit1 do
      local cat = temp1[i1]
      local group = match1(cat, "^transform%-(.*)")
      if group then
        if not transLookup[group] then
          error1("Unknown category " .. cat .. " for " .. trans["name"])
        end
        if endsWith_3f_1(group, "-block") then
          push_21_1(transLookup[group], function(node, start)
            return run(tracker, state, node, start, lookup)
          end)
        else
          push_21_1(transLookup[group], function(node)
            return run(tracker, state, node, lookup)
          end)
        end
      end
      i1 = i1 + 1
    end
    i = i + 1
  end
  transform1(nodes, transLookup, lookup)
  local forLimit = n1(trackers)
  local i = 1
  while i <= forLimit do
    temp["changed"] = temp["changed"] + nth1(trackers, i)["changed"]
    if state["track"] then
      self1(state["logger"], "put-verbose!", (sprintf1("%s made %d changes", "[" .. concat2(nth1(transformers, i)["cat"], " ") .. "] " .. nth1(transformers, i)["name"], nth1(trackers, i)["changed"])))
    end
    i = i + 1
  end
  return nil
end}
traverseQuote1 = function(node, visitor, level)
  if level == 0 then
    return traverseNode1(node, visitor)
  else
    local tag = type1(node)
    if tag == "string" or tag == "number" or tag == "key" or tag == "symbol" then
      return node
    elseif tag == "list" then
      local first = nth1(node, 1)
      if type1(first) == "symbol" then
        if first["contents"] == "unquote" or first["contents"] == "unquote-splice" then
          node[2] = traverseQuote1(nth1(node, 2), visitor, level - 1)
          return node
        elseif first["contents"] == "syntax-quote" then
          node[2] = traverseQuote1(nth1(node, 2), visitor, level + 1)
          return node
        else
          local forLimit = n1(node)
          local i = 1
          while i <= forLimit do
            node[i] = traverseQuote1(nth1(node, i), visitor, level)
            i = i + 1
          end
          return node
        end
      else
        local forLimit = n1(node)
        local i = 1
        while i <= forLimit do
          node[i] = traverseQuote1(nth1(node, i), visitor, level)
          i = i + 1
        end
        return node
      end
    elseif error1 then
      return "Unknown tag " .. tag
    else
      _error("unmatched item")
    end
  end
end
traverseNode1 = function(node, visitor)
  local tag = type1(node)
  if tag == "string" or tag == "number" or tag == "key" or tag == "symbol" then
    return visitor(node, visitor)
  elseif tag == "list" then
    local first = car1(node)
    first = visitor(first, visitor)
    node[1] = first
    if type1(first) == "symbol" then
      local func = first["var"]
      local funct = func["kind"]
      if funct == "defined" or funct == "arg" or funct == "native" or funct == "macro" then
        traverseList1(node, 1, visitor)
        return visitor(node, visitor)
      elseif func == builtins1["lambda"] then
        traverseBlock1(node, 3, visitor)
        return visitor(node, visitor)
      elseif func == builtins1["cond"] then
        local forLimit = n1(node)
        local i = 2
        while i <= forLimit do
          local case = nth1(node, i)
          case[1] = traverseNode1(nth1(case, 1), visitor)
          traverseBlock1(case, 2, visitor)
          i = i + 1
        end
        return visitor(node, visitor)
      elseif func == builtins1["set!"] then
        node[3] = traverseNode1(nth1(node, 3), visitor)
        return visitor(node, visitor)
      elseif func == builtins1["quote"] then
        return visitor(node, visitor)
      elseif func == builtins1["syntax-quote"] then
        node[2] = traverseQuote1(nth1(node, 2), visitor, 1)
        return visitor(node, visitor)
      elseif func == builtins1["unquote"] or func == builtins1["unquote-splice"] then
        return error1("unquote/unquote-splice should never appear head", 0)
      elseif func == builtins1["define"] or func == builtins1["define-macro"] then
        node[n1(node)] = traverseNode1(nth1(node, n1(node)), visitor)
        return visitor(node, visitor)
      elseif func == builtins1["define-native"] then
        return visitor(node, visitor)
      elseif func == builtins1["import"] then
        return visitor(node, visitor)
      elseif func == builtins1["struct-literal"] then
        traverseList1(node, 2, visitor)
        return visitor(node, visitor)
      else
        return error1("Unknown kind " .. funct .. " for variable " .. func["name"], 0)
      end
    else
      traverseList1(node, 1, visitor)
      return visitor(node, visitor)
    end
  else
    return error1("Unknown tag " .. tag)
  end
end
traverseBlock1 = function(node, start, visitor)
  local forLimit = n1(node)
  local i = start
  while i <= forLimit do
    node[i] = (traverseNode1(nth1(node, i + 0), visitor))
    i = i + 1
  end
  return node
end
traverseList1 = function(node, start, visitor)
  local forLimit = n1(node)
  local i = start
  while i <= forLimit do
    node[i] = traverseNode1(nth1(node, i), visitor)
    i = i + 1
  end
  return node
end
metavar_3f_1 = function(x)
  return x["var"] == nil and sub1(symbol_2d3e_string1(x), 1, 1) == "?"
end
genvar_3f_1 = function(x)
  return x["var"] == nil and sub1(symbol_2d3e_string1(x), 1, 1) == "%"
end
builtinPtrn_21_1 = function(ptrn)
  local temp = type1(ptrn)
  if temp == "string" then
    return ptrn
  elseif temp == "number" then
    return ptrn
  elseif temp == "key" then
    return ptrn
  elseif temp == "symbol" then
    ptrn["var"] = builtins1[(ptrn["contents"])]
    return ptrn
  elseif temp == "list" then
    local forLimit = n1(ptrn)
    local i = 1
    while i <= forLimit do
      ptrn[i] = builtinPtrn_21_1(nth1(ptrn, i))
      i = i + 1
    end
    return ptrn
  else
    return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"key\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`")
  end
end
fusionPatterns1 = list1({from=builtinPtrn_21_1({tag="list", n=3, {tag="symbol", contents="cond"}, {tag="list", n=2, {tag="list", n=3, {tag="symbol", contents="cond"}, {tag="list", n=2, {tag="symbol", contents="?x"}, {tag="symbol", contents="false"}}, {tag="list", n=2, {tag="symbol", contents="true"}, {tag="symbol", contents="true"}}}, {tag="symbol", contents="false"}}, {tag="list", n=2, {tag="symbol", contents="true"}, {tag="symbol", contents="true"}}}), to=builtinPtrn_21_1({tag="list", n=3, {tag="symbol", contents="cond"}, {tag="list", n=2, {tag="symbol", contents="?x"}, {tag="symbol", contents="true"}}, {tag="list", n=2, {tag="symbol", contents="true"}, {tag="symbol", contents="false"}}})})
peq_3f_1 = function(x, y, out)
  if x == y then
    return true
  else
    local tyX, tyY = type1(x), type1(y)
    if tyX == "symbol" and metavar_3f_1(x) then
      out[symbol_2d3e_string1(x)] = y
      return true
    elseif tyX ~= tyY then
      return false
    elseif tyX == "symbol" then
      return x["var"] == y["var"]
    elseif tyX == "string" then
      return constVal1(x) == constVal1(y)
    elseif tyX == "number" then
      return constVal1(x) == constVal1(y)
    elseif tyX == "key" then
      return constVal1(x) == constVal1(y)
    elseif tyX == "list" then
      if n1(x) == n1(y) then
        local ok = true
        local forLimit = n1(x)
        local i = 1
        while i <= forLimit do
          if ok and not peq_3f_1(nth1(x, i), nth1(y, i), out) then
            ok = false
          end
          i = i + 1
        end
        return ok
      else
        return false
      end
    else
      _error("unmatched item")
    end
  end
end
substitute1 = function(x, subs, syms)
  local temp = type1(x)
  if temp == "string" then
    return x
  elseif temp == "number" then
    return x
  elseif temp == "key" then
    return x
  elseif temp == "symbol" then
    if metavar_3f_1(x) then
      local res = subs[symbol_2d3e_string1(x)]
      if res == nil then
        error1("Unknown capture " .. pretty1(x), 0)
      end
      return res
    elseif genvar_3f_1(x) then
      local name = symbol_2d3e_string1(x)
      local sym = syms[name]
      if not sym then
        sym = {tag="symbol", contents=name, var={tag="var", kind="arg", name=name}}
        syms[name] = sym
      end
      return sym
    else
      local var = x["var"]
      return {tag="symbol", contents=var["name"], var=var}
    end
  elseif temp == "list" then
    return map2(function(temp1)
      return substitute1(temp1, subs, syms)
    end, x)
  else
    return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"key\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`")
  end
end
fusion1 = {name="fusion", help="Merges various loops together as specified by a pattern.", cat={tag="list", n=4, "opt", "transform", "transform-pre", "transform-post"}, level=2, run=function(temp, state, node)
  if type1(node) == "list" then
    local forLimit = n1(fusionPatterns1)
    local i = 1
    while i <= forLimit do
      local ptrn, subs = fusionPatterns1[i], {}
      if peq_3f_1(ptrn["from"], node, subs) then
        temp["changed"] = temp["changed"] + 1
        node = substitute1(ptrn["to"], subs, {})
      end
      i = i + 1
    end
  end
  return node
end}
addRule_21_1 = function(rule)
  if type1(rule) ~= "table" then
    error1(demandFailure1(nil, "(= (type rule) \"table\")"))
  end
  push_21_1(fusionPatterns1, rule)
  return nil
end
stripImport1 = {name="strip-import", help="Strip all import expressions in NODES", cat={tag="list", n=2, "opt", "transform-pre-block"}, run=function(temp, state, nodes, start)
  local forStart = n1(nodes)
  local i = forStart
  while i >= start do
    local node = nth1(nodes, i)
    if type1(node) == "list" and builtin_3f_1(car1(node), "import") then
      if i == n1(nodes) then
        nodes[i] = makeNil1()
      else
        removeNth_21_1(nodes, i)
      end
      temp["changed"] = temp["changed"] + 1
    end
    i = i + -1
  end
  return nil
end}
stripPure1 = {name="strip-pure", help="Strip all pure expressions in NODES (apart from the last one).", cat={tag="list", n=2, "opt", "transform-pre-block"}, run=function(temp, state, nodes, start)
  local forStart = n1(nodes) - 1
  local i = forStart
  while i >= start do
    if not sideEffect_3f_1((nth1(nodes, i))) then
      removeNth_21_1(nodes, i)
      temp["changed"] = temp["changed"] + 1
    end
    i = i + -1
  end
  return nil
end}
constantFold1 = {name="constant-fold", help="A primitive constant folder\n\nThis simply finds function calls with constant functions and looks up the function.\nIf the function is native and pure then we'll execute it and replace the node with the\nresult. There are a couple of caveats:\n\n - If the function call errors then we will flag a warning and continue.\n - If this returns a decimal (or infinity or NaN) then we'll continue: we cannot correctly\n   accurately handle this.\n - If this doesn't return exactly one value then we will stop. This might be a future enhancement.", cat={tag="list", n=2, "opt", "transform-post"}, run=function(temp, state, node)
  if type1(node) == "list" and fastAll1(constant_3f_1, node, 2) then
    local head = car1(node)
    local meta = type1(head) == "symbol" and (not head["folded"] and (head["var"]["kind"] == "native" and varNative1(head["var"])))
    if meta and (meta["pure"] and function_3f_1(getNative1(head["var"]))) then
      local res = list1(pcall1(meta["value"], splice1(map2(urn_2d3e_val1, slicingView1(node, 1)))))
      if car1(res) then
        local val = nth1(res, 2)
        if n1(res) ~= 2 or number_3f_1(val) and (cadr1(list1(modf1(val))) ~= 0 or abs1(val) == huge1) then
          head["folded"] = true
          return node
        else
          temp["changed"] = temp["changed"] + 1
          return val_2d3e_urn1(val)
        end
      else
        head["folded"] = true
        putNodeWarning_21_1(state["logger"], "Cannot execute constant expression", node["source"], nil, sourceRange1(node["source"]), "Executed " .. pretty1(node) .. ", failed with: " .. nth1(res, 2))
        return node
      end
    else
      return node
    end
  else
    return node
  end
end}
condFold1 = {name="cond-fold", help="Simplify all `cond` nodes, removing `false` branches and killing\nall branches after a `true` one.", cat={tag="list", n=2, "opt", "transform-post"}, run=function(temp, state, node)
  if type1(node) == "list" and builtin_3f_1(car1(node), "cond") then
    local final, i = false, 2
    while i <= n1(node) do
      local elem = nth1(node, i)
      if final then
        temp["changed"] = temp["changed"] + 1
        removeNth_21_1(node, i)
      else
        local temp1 = urn_2d3e_bool1(car1(elem))
        if temp1 == false then
          temp["changed"] = temp["changed"] + 1
          removeNth_21_1(node, i)
        elseif temp1 == true then
          if not builtin_3f_1(car1(elem), "true") then
            temp["changed"] = temp["changed"] + 1
            elem[1] = (function()
              local var = builtins1["true"]
              return {tag="symbol", contents=var["name"], var=var}
            end)()
          end
          final = true
          i = i + 1
        elseif temp1 == nil then
          i = i + 1
        else
          error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp1) .. ", but none matched.\n" .. "  Tried: `false`\n  Tried: `true`\n  Tried: `nil`")
        end
      end
    end
    if n1(node) == 2 and builtin_3f_1(car1(nth1(node, 2)), "true") then
      temp["changed"] = temp["changed"] + 1
      local body = slicingView1(nth1(node, 2), 1)
      if n1(body) == 1 then
        return car1(body)
      else
        return makeProgn1(slicingView1(nth1(node, 2), 1))
      end
    else
      local temp1
      if n1(node) > 1 then
        local branch = last1(node)
        temp1 = n1(branch) == 2 and (builtin_3f_1(car1(branch), "true") and (type1((cadr1(branch))) == "list" and builtin_3f_1(caadr1(branch), "cond")))
      else
        temp1 = false
      end
      if temp1 then
        local childCond = nth1(popLast_21_1(node), 2)
        local forLimit = n1(childCond)
        local i1 = 2
        while i1 <= forLimit do
          push_21_1(node, nth1(childCond, i1))
          i1 = i1 + 1
        end
        temp["changed"] = temp["changed"] + 1
        return node
      else
        return node
      end
    end
  else
    return node
  end
end}
lambdaFold1 = {name="lambda-fold", help="Simplify all directly called lambdas without arguments, inlining them\nwere appropriate.", cat={tag="list", n=3, "opt", "deforest", "transform-post-bind"}, run=function(temp, state, node)
  if simpleBinding_3f_1(node) then
    local vars, nodeLam = {}, car1(node)
    local nodeArgs = nth1(nodeLam, 2)
    local argN, valN, i = n1(nodeArgs), n1(node) - 1, 1
    if valN <= argN then
      local forLimit = n1(nodeArgs)
      local i1 = 1
      while i1 <= forLimit do
        vars[nodeArgs[i1]["var"]] = true
        i1 = i1 + 1
      end
      while i <= valN and not builtin_3f_1(nth1(node, i + 1), "nil") do
        i = i + 1
      end
      if i <= argN then
        while not ((i > argN)) do
          local head = nth1(nodeLam, 3)
          if type1(head) == "list" and (builtin_3f_1(car1(head), "set!") and (nth1(head, 2)["var"] == nth1(nodeArgs, i)["var"] and not nodeContainsVars_3f_1(nth1(head, 3), vars))) then
            while valN < i do
              push_21_1(node, makeNil1())
              valN = valN + 1
            end
            removeNth_21_1(nodeLam, 3)
            node[i + 1] = nth1(head, 3)
            temp["changed"] = temp["changed"] + 1
          end
          i = i + 1
        end
      end
    end
  end
  if simpleBinding_3f_1(node) then
    local vars, nodeLam = {}, car1(node)
    local nodeArgs = nth1(nodeLam, 2)
    local forLimit = n1(nodeArgs)
    local i = 1
    while i <= forLimit do
      vars[nodeArgs[i]["var"]] = true
      i = i + 1
    end
    local child = nth1(nodeLam, 3)
    while true do
      if (not simpleBinding_3f_1(child) or n1(nodeArgs) ~= n1(node) - 1 or n1(nodeLam) > 3) then
        return nil
      else
        local args = nth1(car1(child), 2)
        while true do
          local val = nth1(child, 2)
          if empty_3f_1(args) then
            break
          elseif not val then
            local forLimit = n1(args)
            local i = 1
            while i <= forLimit do
              temp["changed"] = temp["changed"] + 1
              local arg = removeNth_21_1(args, 1)
              push_21_1(nodeArgs, arg)
              vars[arg["var"]] = true
              i = i + 1
            end
            break
          elseif nodeContainsVars_3f_1(val, vars) then
            break
          else
            temp["changed"] = temp["changed"] + 1
            push_21_1(node, removeNth_21_1(child, 2))
            local arg = removeNth_21_1(args, 1)
            push_21_1(nodeArgs, arg)
            vars[arg["var"]] = true
          end
        end
        if empty_3f_1(args) and n1(child) == 1 then
          removeNth_21_1(nodeLam, 3)
          local lam = car1(child)
          local forLimit = n1(lam)
          local i = 3
          while i <= forLimit do
            insertNth_21_1(nodeLam, i, nth1(lam, i))
            i = i + 1
          end
          child = nth1(nodeLam, 3)
        else
          return nil
        end
      end
    end
  else
    return nil
  end
end}
wrapValueFlatten1 = {name="wrap-value-flatten", help="Flatten \"value wrappers\": lambdas with a single argument which\nprevent returning multiple values.", cat={tag="list", n=2, "opt", "transform-post"}, run=function(temp, state, node)
  local temp1
  if type1(node) == "list" then
    local head = car1(node)
    temp1 = type1(head) ~= "symbol" or head["var"]["kind"] ~= "builtin"
  else
    temp1 = false
  end
  if temp1 then
    local forLimit = max1(1, n1(node) - 1)
    local i = 1
    while i <= forLimit do
      local arg = nth1(node, i)
      local temp1
      if type1(arg) == "list" then
        if n1(arg) == 2 then
          local head = car1(arg)
          temp1 = type1(head) == "list" and (n1(head) == 3 and (builtin_3f_1(car1(head), "lambda") and (n1(nth1(head, 2)) == 1 and (not car1(nth1(head, 2))["var"]["is-variadic"] and (type1((nth1(head, 3))) == "symbol" and nth1(head, 3)["var"] == car1(nth1(head, 2))["var"])))))
        else
          temp1 = false
        end
      else
        temp1 = false
      end
      if temp1 then
        temp["changed"] = temp["changed"] + 1
        node[i] = cadr1(arg)
      end
      i = i + 1
    end
  end
  return node
end}
prognFoldExpr1 = {name="progn-fold-expr", help="Reduce [[progn]]-like nodes with a single body element into a single\nexpression.", cat={tag="list", n=3, "opt", "deforest", "transform-post"}, run=function(temp, state, node)
  if type1(node) == "list" and (n1(node) == 1 and (type1((car1(node))) == "list" and (builtin_3f_1(caar1(node), "lambda") and (n1(car1(node)) == 3 and empty_3f_1(nth1(car1(node), 2)))))) then
    temp["changed"] = temp["changed"] + 1
    return nth1(car1(node), 3)
  else
    return node
  end
end}
prognFoldBlock1 = {name="progn-fold-block", help="Reduce [[progn]]-like nodes with a single body element into a single\nexpression.", cat={tag="list", n=3, "opt", "deforest", "transform-post-block"}, run=function(temp, state, nodes, start)
  local i, len = start, n1(nodes)
  while i <= len do
    local node = nth1(nodes, i)
    if type1(node) == "list" and (n1(node) == 1 and (type1((car1(node))) == "list" and (builtin_3f_1(car1(car1(node)), "lambda") and empty_3f_1(nth1(car1(node), 2))))) then
      local body = car1(node)
      temp["changed"] = temp["changed"] + 1
      if n1(body) == 2 then
        removeNth_21_1(nodes, i)
      else
        nodes[i] = nth1(body, 3)
        local forLimit = n1(body)
        local j = 4
        while j <= forLimit do
          insertNth_21_1(nodes, i + (j - 3), nth1(body, j))
          j = j + 1
        end
      end
      len = len + (n1(node) - 1)
    else
      i = i + 1
    end
  end
  return nil
end}
stripDefsFast1 = function(nodes)
  local defs = {}
  local forLimit = n1(nodes)
  local i = 1
  while i <= forLimit do
    local node = nodes[i]
    if type1(node) == "list" then
      local var = node["def-var"]
      if var then
        defs[var] = node
      end
    end
    i = i + 1
  end
  local visited, queue = {}, {tag="list", n=0}
  local visitor = function(node, visitor1)
    local temp = type1(node)
    if temp == "symbol" then
      local var = node["var"]
      local def = defs[var]
      if def and not visited[var] then
        visited[var] = true
        return push_21_1(queue, def)
      else
        return nil
      end
    elseif temp == "list" then
      if builtin_3f_1(car1(node), "set!") then
        return visitor1(cadr1(node))
      else
        return nil
      end
    else
      return nil
    end
  end
  local forLimit = n1(nodes)
  local i = 1
  while i <= forLimit do
    local node = nodes[i]
    if not node["def-var"] then
      visitNode1(node, visitor)
    end
    i = i + 1
  end
  while n1(queue) > 0 do
    visitNode1(popLast_21_1(queue), visitor)
  end
  local forStart = n1(nodes)
  local i = forStart
  while i >= 1 do
    local var = nth1(nodes, i)["def-var"]
    if var and not visited[var] then
      if i == n1(nodes) then
        nodes[i] = makeNil1()
      else
        removeNth_21_1(nodes, i)
      end
    end
    i = i + -1
  end
  return nil
end
getConstantVal1 = function(lookup, sym)
  local var, def = sym["var"], getVar1(lookup, sym["var"])
  if var == builtins1["true"] then
    return sym
  elseif var == builtins1["false"] then
    return sym
  elseif var == builtins1["nil"] then
    return sym
  elseif n1(def["defs"]) == 1 then
    local ent = car1(def["defs"])
    local val, ty = ent["value"], type1(ent)
    if string_3f_1(val) or number_3f_1(val) or type1(val) == "key" then
      return val
    elseif type1(val) == "symbol" and ty == "val" then
      return getConstantVal1(lookup, val) or sym
    else
      return sym
    end
  else
    return nil
  end
end
removeReferences1 = function(vars, nodes, start)
  if (not next1(vars)) then
    return nil
  else
    return traverseList1(nodes, start, function(node)
      local temp = type1(node)
      if temp == "symbol" then
        if vars[node["var"]] then
          return makeNil1()
        else
          return node
        end
      elseif temp == "list" then
        if builtin_3f_1(car1(node), "set!") and vars[nth1(node, 2)["var"]] then
          local val = nth1(node, 3)
          if sideEffect_3f_1(val) then
            return makeProgn1(list1(val, makeNil1()))
          else
            return makeNil1()
          end
        else
          return node
        end
      else
        return node
      end
    end)
  end
end
stripDefs1 = {name="strip-defs", help="Strip all unused top level definitions.", cat={tag="list", n=2, "opt", "usage"}, run=function(temp, state, nodes, lookup)
  local removed = {}
  local forStart = n1(nodes)
  local i = forStart
  while i >= 1 do
    local node = nth1(nodes, i)
    if node["def-var"] and not getVar1(lookup, node["def-var"])["active"] then
      if i == n1(nodes) then
        nodes[i] = makeNil1()
      else
        removeNth_21_1(nodes, i)
      end
      removed[node["def-var"]] = true
      temp["changed"] = temp["changed"] + 1
    end
    i = i + -1
  end
  return removeReferences1(removed, nodes, 1)
end}
stripArgs1 = {name="strip-args", help="Strip all unused, pure arguments in directly called lambdas.", cat={tag="list", n=3, "opt", "usage", "transform-post-bind"}, run=function(temp, state, node, lookup)
  local lam = car1(node)
  local lamArgs, argOffset, valOffset, removed = nth1(lam, 2), 1, 2, {}
  local temp1 = zipArgs1(lamArgs, 1, node, 2)
  local forLimit = n1(temp1)
  local i = 1
  while i <= forLimit do
    local zipped = temp1[i]
    local args = car1(zipped)
    local arg, vals = car1(args), cadr1(zipped)
    if n1(args) > 1 or arg and n1(getVar1(lookup, arg["var"])["usages"]) > 0 or any1(sideEffect_3f_1, vals) then
      argOffset = argOffset + n1(args)
      valOffset = argOffset + n1(vals)
    else
      temp["changed"] = temp["changed"] + 1
      if arg then
        removed[arg["var"]] = true
        removeNth_21_1(lamArgs, argOffset)
      end
      local forLimit1 = n1(vals)
      local i1 = 1
      while i1 <= forLimit1 do
        local val = vals[i1]
        removeNth_21_1(node, valOffset)
        i1 = i1 + 1
      end
    end
    i = i + 1
  end
  return removeReferences1(removed, lam, 3)
end}
variableFold1 = {name="variable-fold", help="Folds constant variable accesses", cat={tag="list", n=3, "opt", "usage", "transform-pre"}, run=function(temp, state, node, lookup)
  if type1(node) == "symbol" then
    local replace = getConstantVal1(lookup, node)
    if replace and replace ~= node then
      removeUsage_21_1(lookup, node["var"], node)
      if type1(replace) == "symbol" then
        replace = copyOf1(replace)
        addUsage_21_1(lookup, replace["var"], replace)
      end
      temp["changed"] = temp["changed"] + 1
      return replace
    else
      return node
    end
  else
    return node
  end
end}
expressionFold1 = {name="expression-fold", help="Folds basic variable accesses where execution order will not change.\n\nFor instance, converts ((lambda (x) (+ x 1)) (Y)) to (+ Y 1) in the\ncase where Y is an arbitrary expression.\n\nThere are a couple of complexities in the implementation\nhere. Firstly, we want to ensure that the arguments are executed in\nthe correct order and only once.\n\nIn order to achieve this, we find the lambda forms and visit the body,\nstopping if we visit arguments in the wrong order or non-constant\nterms such as mutable variables or other function calls. For\nsimplicity's sake, we fail if we hit other lambdas or conds as that\nmakes analysing control flow significantly more complex.\n\nAnother source of added complexity is the case where where Y could\nreturn multiple values: namely in the last argument to function\ncalls. Here it is an invalid optimisation to just place Y, as that\ncould result in additional values being passed to the function.\n\nIn order to avoid this, Y will get converted to the\nform ((lambda (<tmp>) <tmp>) Y).  This is understood by the codegen\nand so is not as inefficient as it looks. However, we do have to take\nadditional steps to avoid trying to fold the above again and again.\n\nWe use post-bind rather than pre-bind as that enables us to benefit\nfrom any optimisations inside the node. We're not going to be moving\nany simple, constant-foldable expressions around. After all, that's\ncovered by [[variable-fold]].", cat={tag="list", n=3, "opt", "usage", "transform-post-bind"}, run=function(temp, state, root, lookup)
  local lam, args, len, validate = car1(root)
  args = nth1(lam, 2)
  len = n1(args)
  validate = function(i)
    while true do
      if i > len then
        return true
      else
        local var = nth1(args, i)["var"]
        local entry = getVar1(lookup, var)
        if var["is-variadic"] then
          return false
        elseif n1(entry["defs"]) ~= 1 then
          return false
        elseif type1(car1(entry["defs"])) == "var" then
          return false
        elseif n1(entry["usages"]) ~= 1 then
          return false
        else
          i = i + 1
        end
      end
    end
  end
  if len > 0 and ((n1(root) ~= 2 or len ~= 1 or n1(lam) ~= 3 or singleReturn_3f_1(nth1(root, 2)) or type1((nth1(lam, 3))) ~= "symbol" or nth1(lam, 3)["var"] ~= car1(args)["var"]) and validate(1)) then
    local currentIdx, argMap, wrapMap, ok, finished = 1, {}, {}, true, false
    local forLimit = n1(args)
    local i = 1
    while i <= forLimit do
      argMap[nth1(args, i)["var"]] = i
      i = i + 1
    end
    visitBlock1(lam, 3, function(node, visitor)
      if ok and not finished then
        local temp1 = type1(node)
        if temp1 == "string" then
          return nil
        elseif temp1 == "number" then
          return nil
        elseif temp1 == "key" then
          return nil
        elseif temp1 == "symbol" then
          local idx = argMap[node["var"]]
          if idx == nil then
            if n1(getVar1(lookup, node["var"])["defs"]) > 1 then
              ok = false
              return false
            else
              return nil
            end
          elseif idx == currentIdx then
            currentIdx = currentIdx + 1
            if currentIdx > len then
              finished = true
              return nil
            else
              return nil
            end
          else
            ok = false
            return false
          end
        elseif temp1 == "list" then
          local head = car1(node)
          local temp2 = type1(head)
          if temp2 == "symbol" then
            local var = head["var"]
            if var["kind"] ~= "builtin" then
              visitBlock1(node, 1, visitor)
              if n1(node) > 1 then
                local last = nth1(node, n1(node))
                if type1(last) == "symbol" then
                  local idx = argMap[last["var"]]
                  if idx then
                    if type1((root[idx + 1])) == "list" then
                      wrapMap[idx] = true
                    end
                  end
                end
              end
            elseif var == builtins1["set!"] then
              visitNode1(nth1(node, 3), visitor)
            elseif var == builtins1["define"] then
              visitNode1(last1(node), visitor)
            elseif var == builtins1["define-macro"] then
              visitNode1(last1(node), visitor)
            elseif var == builtins1["define-native"] then
            elseif var == builtins1["cond"] then
              visitNode1(car1(nth1(node, 2)), visitor)
            elseif var == builtins1["lambda"] then
            elseif var == builtins1["quote"] then
            elseif var == builtins1["import"] then
            elseif var == builtins1["syntax-quote"] then
              visitQuote1(nth1(node, 2), visitor, 1)
            elseif var == builtins1["struct-literal"] then
              visitBlock1(node, 2, visitor)
            else
              _error("unmatched item")
            end
            if finished then
            elseif var == builtins1["set!"] then
              ok = false
            elseif var == builtins1["cond"] then
              ok = false
            elseif var == builtins1["lambda"] then
              ok = false
            else
              ok = false
            end
            return false
          elseif temp2 == "list" then
            if builtin_3f_1(car1(head), "lambda") then
              visitBlock1(node, 2, visitor)
              visitBlock1(head, 3, visitor)
              return false
            else
              ok = false
              return false
            end
          else
            ok = false
            return false
          end
        else
          return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp1) .. ", but none matched.\n" .. "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"key\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`")
        end
      else
        return false
      end
    end)
    if ok and finished then
      temp["changed"] = temp["changed"] + 1
      traverseList1(root, 1, function(child)
        if type1(child) == "symbol" then
          local var = child["var"]
          local i = argMap[var]
          if i then
            if wrapMap[i] then
              return {tag="list", n=2, {tag="list", n=3, (function()
                local var2 = builtins1["lambda"]
                return {tag="symbol", contents=var2["name"], var=var2}
              end)(), {tag="list", n=1, {tag="symbol", contents=var["name"], var=var}}, {tag="symbol", contents=var["name"], var=var}}, nth1(root, i + 1)}
            else
              return nth1(root, i + 1) or makeNil1()
            end
          else
            return child
          end
        else
          return child
        end
      end)
      local forStart = n1(root)
      local i = forStart
      while i >= 2 do
        removeNth_21_1(root, i)
        i = i + -1
      end
      local forStart = n1(args)
      local i = forStart
      while i >= 1 do
        removeNth_21_1(args, i)
        i = i + -1
      end
      return nil
    else
      return nil
    end
  else
    return nil
  end
end}
condEliminate1 = {name="cond-eliminate", help="Replace variables with known truthy/falsey values with `true` or\n`false` when used in branches.", cat={tag="list", n=2, "opt", "usage"}, run=function(temp, state, nodes, varLookup)
  local lookup = {}
  return visitBlock1(nodes, 1, function(node, visitor, isCond)
    local temp1 = type1(node)
    if temp1 == "symbol" then
      if isCond then
        local temp2 = lookup[node["var"]]
        if temp2 == false then
          if node["var"] ~= builtins1["false"] then
            local var = builtins1["false"]
            return {tag="symbol", contents=var["name"], var=var}
          else
            return nil
          end
        elseif temp2 == true then
          if node["var"] ~= builtins1["true"] then
            local var = builtins1["true"]
            return {tag="symbol", contents=var["name"], var=var}
          else
            return nil
          end
        else
          return nil
        end
      else
        return nil
      end
    elseif temp1 == "list" then
      local head = car1(node)
      local temp2 = type1(head)
      if temp2 == "symbol" then
        if builtin_3f_1(head, "cond") then
          local vars = {tag="list", n=0}
          local forLimit = n1(node)
          local i = 2
          while i <= forLimit do
            local entry = nth1(node, i)
            local test, len = car1(entry), n1(entry)
            local var = type1(test) == "symbol" and test["var"]
            if var then
              if lookup[var] ~= nil then
                var = nil
              elseif n1(getVar1(varLookup, var)["defs"]) > 1 then
                var = nil
              end
            end
            local temp3 = visitor(test, visitor, true)
            if temp3 == nil then
              visitNode1(test, visitor)
            elseif temp3 == false then
            else
              temp["changed"] = temp["changed"] + 1
              entry[1] = temp3
            end
            if var then
              push_21_1(vars, var)
              lookup[var] = true
            end
            local forLimit1 = len - 1
            local i1 = 2
            while i1 <= forLimit1 do
              visitNode1(nth1(entry, i1), visitor)
              i1 = i1 + 1
            end
            if len > 1 then
              local last = nth1(entry, len)
              local temp3 = visitor(last, visitor, isCond)
              if temp3 == nil then
                visitNode1(last, visitor)
              elseif temp3 == false then
              else
                temp["changed"] = temp["changed"] + 1
                entry[len] = temp3
              end
            end
            if var then
              lookup[var] = false
            end
            i = i + 1
          end
          local forLimit = n1(vars)
          local i = 1
          while i <= forLimit do
            lookup[vars[i]] = nil
            i = i + 1
          end
          return false
        else
          return nil
        end
      elseif temp2 == "list" then
        if isCond and builtin_3f_1(car1(head), "lambda") then
          local forLimit = n1(node)
          local i = 2
          while i <= forLimit do
            visitNode1(nth1(node, i), visitor)
            i = i + 1
          end
          local len = n1(head)
          local forLimit = len - 1
          local i = 3
          while i <= forLimit do
            visitNode1(nth1(head, i), visitor)
            i = i + 1
          end
          if len > 2 then
            local last = nth1(head, len)
            local temp3 = visitor(last, visitor, isCond)
            if temp3 == nil then
              visitNode1(last, visitor)
            elseif temp3 == false then
            else
              temp["changed"] = temp["changed"] + 1
              node[head] = temp3
            end
          end
          return false
        else
          return nil
        end
      else
        return nil
      end
    else
      return nil
    end
  end)
end}
deferrable_3f_1 = function(lookup, node)
  local deferrable = true
  visitNode1(node, function(node1)
    local temp = type1(node1)
    if temp == "string" then
      return nil
    elseif temp == "number" then
      return nil
    elseif temp == "key" then
      return nil
    elseif temp == "symbol" then
      if n1(getVar1(lookup, node1["var"])["defs"]) > 1 then
        deferrable = false
      end
      return deferrable
    elseif temp == "list" then
      if type1(car1(node1)) == "symbol" then
        local var = car1(node1)["var"]
        if var == builtins1["lambda"] then
          return false
        elseif var == builtins1["quote"] then
          return deferrable
        elseif var == builtins1["quasi-quote"] then
          return deferrable
        elseif var == builtins1["struct-literal"] then
          return deferrable
        elseif var == builtins1["cond"] then
          return nil
        else
          deferrable = false
          return false
        end
      else
        deferrable = false
        return false
      end
    else
      return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"key\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`")
    end
  end)
  return deferrable
end
lowerValue1 = {name="lower-value", help="Pushes various values into child nodes, bringing them closer to the\nplace they are used", cat={tag="list", n=3, "opt", "usage", "transform-post-bind"}, run=function(temp, state, node, lookup)
  local lam = car1(node)
  local lamArgs, argOffset, valOffset = nth1(lam, 2), 1, 2
  local temp1 = zipArgs1(lamArgs, 1, node, 2)
  local forLimit = n1(temp1)
  local i = 1
  while i <= forLimit do
    local zipped = temp1[i]
    local args, vals, handled = car1(zipped), cadr1(zipped), false
    if n1(args) == 1 and (not car1(args)["var"]["is-variadic"] and (n1(vals) == 1 and car1(vals) ~= nil)) then
      local var, val = car1(args)["var"], car1(vals)
      if not handled and (type1(val) == "list" and (builtin_3f_1(car1(val), "lambda") and n1(getVar1(lookup, var)["usages"]) == 1)) then
        local users, found = 0, nil
        visitBlock1(lam, 3, function(child)
          if type1(child) == "list" and (type1((car1(child))) == "symbol" and car1(child)["var"] == var) then
            found = child
          elseif type1(child) == "symbol" and child["var"] == var then
            users = users + 1
          end
          local _ = users <= 1
          return nil
        end)
        if found and users == 1 then
          temp["changed"] = temp["changed"] + 1
          handled = true
          found[1] = val
          removeNth_21_1(lamArgs, argOffset)
          removeNth_21_1(node, valOffset)
        end
      end
      if not handled and (not atom_3f_1(val) and deferrable_3f_1(lookup, val)) then
        local cur, start, best = lam, 3, nil
        while true do
          local found
          local i1, found1 = start, nil
          while true do
            if i1 > n1(cur) then
              found = found1
              break
            else
              local curi = nth1(cur, i1)
              if not nodeContainsVar_3f_1(curi, var) then
                i1 = i1 + 1
              elseif found1 then
                found = nil
                break
              else
                i1, found1 = i1 + 1, curi
              end
            end
          end
          local condFound
          local temp2 = type1(found) == "list"
          if temp2 then
            local temp3 = builtin_3f_1(car1(found), "cond")
            if temp3 then
              local i1, block = 2, nil
              while true do
                if i1 > n1(found) then
                  condFound = block
                  break
                else
                  local branch = nth1(found, i1)
                  if nodeContainsVar_3f_1(car1(branch), var) then
                    condFound = nil
                    break
                  elseif not fastAny1(function(temp4)
                    return nodeContainsVar_3f_1(temp4, var)
                  end, branch, 2) then
                    i1 = i1 + 1
                  elseif block then
                    condFound = nil
                    break
                  else
                    i1, block = i1 + 1, branch
                  end
                end
              end
            else
              condFound = temp3
            end
          else
            condFound = temp2
          end
          if condFound then
            cur, start, best = condFound, 2, condFound
          elseif type1(found) == "list" and (type1((car1(found))) == "list" and (builtin_3f_1(caar1(found), "lambda") and fastAll1(function(x)
            return not nodeContainsVar_3f_1(x, var)
          end, car1(found), 3))) then
            cur, start = car1(found), 3
          elseif best then
            temp["changed"] = temp["changed"] + 1
            handled = true
            local newBody = {tag="list", n=2, (function()
              local var2 = builtins1["lambda"]
              return {tag="symbol", contents=var2["name"], var=var2}
            end)(), {tag="list", n=1, car1(args)}}
            local forLimit1 = n1(best)
            local i1 = 2
            while i1 <= forLimit1 do
              push_21_1(newBody, removeNth_21_1(best, 2))
              i1 = i1 + 1
            end
            push_21_1(best, list1(newBody, val))
            removeNth_21_1(lamArgs, argOffset)
            removeNth_21_1(node, valOffset)
            break
          else
            break
          end
        end
      end
    end
    if not handled then
      argOffset = argOffset + n1(args)
      valOffset = argOffset + n1(vals)
    end
    i = i + 1
  end
  return nil
end}
getScope1 = function(scope, lookup)
  local newScope = lookup["scopes"][scope]
  if newScope then
    return newScope
  else
    local newScope1 = child1()
    lookup["scopes"][scope] = newScope1
    return newScope1
  end
end
getVar2 = function(var, lookup)
  return lookup["vars"][var] or var
end
copyNode1 = function(node, lookup)
  local temp = type1(node)
  if temp == "string" then
    return copyOf1(node)
  elseif temp == "key" then
    return copyOf1(node)
  elseif temp == "number" then
    return copyOf1(node)
  elseif temp == "symbol" then
    local copy, oldVar = copyOf1(node), node["var"]
    local newVar = getVar2(oldVar, lookup)
    if oldVar ~= newVar and oldVar["node"] == node then
      newVar["node"] = copy
    end
    copy["var"] = newVar
    return copy
  elseif temp == "list" then
    if builtin_3f_1(car1(node), "lambda") then
      local args = cadr1(node)
      if not empty_3f_1(args) then
        local newScope, forLimit = child1(getScope1(car1(args)["var"]["scope"], lookup)), n1(args)
        local i = 1
        while i <= forLimit do
          local var = args[i]["var"]
          local newVar = add_21_1(newScope, var["name"], var["kind"], nil)
          newVar["is-variadic"] = (var["is-variadic"])
          lookup["vars"][var] = newVar
          i = i + 1
        end
      end
    end
    local res = copyOf1(node)
    local forLimit = n1(res)
    local i = 1
    while i <= forLimit do
      res[i] = copyNode1(nth1(res, i), lookup)
      i = i + 1
    end
    return res
  else
    return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"string\"`\n  Tried: `\"key\"`\n  Tried: `\"number\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`")
  end
end
scoreNode1 = function(node, cumulative, threshold)
  while true do
    local temp = type1(node)
    if temp == "string" then
      return cumulative
    elseif temp == "key" then
      return cumulative
    elseif temp == "number" then
      return cumulative
    elseif temp == "symbol" then
      return cumulative + 1
    elseif temp == "list" then
      local temp1 = type1(car1(node))
      if temp1 == "symbol" then
        local func = car1(node)["var"]
        if func["kind"] ~= "builtin" then
          return scoreNodes1(node, 1, cumulative + n1(node) + 1, threshold)
        elseif func == builtins1["lambda"] then
          return scoreNodes1(node, 3, cumulative + 10, threshold)
        elseif func == builtins1["cond"] then
          cumulative = cumulative + 3
          local len, _ = n1(node)
          local i = 2
          while true do
            if (i > len) then
              break
            else
              cumulative = cumulative + 4
              if cumulative <= threshold then
                cumulative = scoreNodes1(nth1(node, i), 1, cumulative, threshold)
                i = i + 1
              else
                break
              end
            end
          end
          return cumulative
        elseif func == builtins1["set!"] then
          node, cumulative = nth1(node, 3), cumulative + 5
        elseif func == builtins1["quote"] then
          if type1((nth1(node, 2))) == "list" then
            return cumulative + n1(node)
          else
            return cumulative
          end
        elseif func == builtins1["import"] then
          return cumulative
        elseif func == builtins1["syntax-quote"] then
          node, cumulative = nth1(node, 2), cumulative + 3
        elseif func == builtins1["unquote"] then
          node = nth1(node, 2)
        elseif func == builtins1["unquote-splice"] then
          node, cumulative = nth1(node, 2), cumulative + 10
        elseif func == builtins1["struct-literal"] then
          return scoreNodes1(node, 2, cumulative + (n1(node) - 1) / 2 + 3, threshold)
        else
          _error("unmatched item")
        end
      elseif temp1 == "list" then
        if builtin_3f_1(caar1(node), "lambda") then
          local temp2 = scoreNodes1(node, 2, cumulative, threshold)
          return scoreNodes1(car1(node), 3, temp2, threshold)
        else
          return scoreNodes1(node, 1, cumulative + n1(node) + 1, threshold)
        end
      else
        return scoreNodes1(node, 1, cumulative + n1(node) + 1, threshold)
      end
    else
      return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"string\"`\n  Tried: `\"key\"`\n  Tried: `\"number\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`")
    end
  end
end
scoreNodes1 = function(nodes, start, cumulative, threshold)
  local len, _ = n1(nodes)
  local i = start
  while true do
    if i > len then
      break
    elseif cumulative <= threshold then
      cumulative = scoreNode1(nth1(nodes, i), cumulative, threshold)
      i = i + 1
    else
      break
    end
  end
  return cumulative
end
getScore1 = function(lookup, node)
  local score = lookup[node]
  if score == nil then
    score = 0
    local temp = nth1(node, 2)
    local forLimit = n1(temp)
    local i = 1
    while i <= forLimit do
      if temp[i]["var"]["is-variadic"] then
        score = false
      end
      i = i + 1
    end
    if score then
      score = scoreNodes1(node, 3, score, 20)
    end
    lookup[node] = score
  end
  return score or huge1
end
inline1 = {name="inline", help="Inline simple functions.", cat={tag="list", n=2, "opt", "usage"}, level=2, run=function(temp, state, nodes, usage)
  local scoreLookup, forLimit = {}, n1(nodes)
  local i = 1
  while i <= forLimit do
    local root = nodes[i]
    visitNode1(root, function(node)
      if type1(node) == "list" and type1((car1(node))) == "symbol" then
        local func = car1(node)["var"]
        local def = getVar1(usage, func)
        if func ~= root["def-var"] and n1(def["defs"]) == 1 then
          local val = car1(def["defs"])["value"]
          if type1(val) == "list" and (builtin_3f_1(car1(val), "lambda") and getScore1(scoreLookup, val) <= 20) then
            node[1] = (copyNode1(val, {scopes={}, vars={}, root=func["scope"]}))
            temp["changed"] = temp["changed"] + 1
            return nil
          else
            return nil
          end
        else
          return nil
        end
      else
        return nil
      end
    end)
    local var = root["def-var"]
    if var then
      scoreLookup[var] = nil
    end
    i = i + 1
  end
  return nil
end}
optimiseOnce1 = function(nodes, state, passes)
  local tracker, lookup = {changed=0}, {}
  local temp = passes["normal"]
  local forLimit = n1(temp)
  local i = 1
  while i <= forLimit do
    runPass1(temp[i], state, tracker, nodes, lookup)
    i = i + 1
  end
  if not (empty_3f_1(passes["transform"]) and empty_3f_1(passes["usage"])) then
    runPass1(tagUsage1, state, tracker, nodes, lookup)
  end
  if not empty_3f_1(passes["transform"]) then
    runPass1(transformer1, state, tracker, nodes, lookup, passes["transform"])
  end
  local temp = passes["usage"]
  local forLimit = n1(temp)
  local i = 1
  while i <= forLimit do
    runPass1(temp[i], state, tracker, nodes, lookup)
    i = i + 1
  end
  return tracker["changed"] > 0
end
optimise1 = function(nodes, state, passes)
  stripDefsFast1(nodes)
  local maxN, maxT, iteration = state["max-n"], state["max-time"], 0
  local finish, changed = clock1() + maxT, true
  while changed and ((maxN < 0 or iteration < maxN) and (maxT < 0 or clock1() < finish)) do
    changed = optimiseOnce1(nodes, state, passes)
    iteration = iteration + 1
  end
  return nil
end
default1 = function()
  return {normal=list1(), usage=list1(stripDefs1, condEliminate1, inline1), transform=list1(stripImport1, stripPure1, constantFold1, condFold1, wrapValueFlatten1, prognFoldExpr1, prognFoldBlock1, variableFold1, stripArgs1, lambdaFold1, lowerValue1, expressionFold1, fusion1)}
end
visitQuote4 = function(defined, logger, node, level)
  while true do
    if level == 0 then
      return visitNode4(defined, logger, node)
    elseif type1(node) == "list" then
      local first = nth1(node, 1)
      if type1(first) == "symbol" then
        if first["contents"] == "unquote" or first["contents"] == "unquote-splice" then
          node, level = nth1(node, 2), level - 1
        elseif first["contents"] == "syntax-quote" then
          node, level = nth1(node, 2), level + 1
        else
          local forLimit = n1(node)
          local i = 1
          while i <= forLimit do
            visitQuote4(defined, logger, node[i], level)
            i = i + 1
          end
          return nil
        end
      else
        local forLimit = n1(node)
        local i = 1
        while i <= forLimit do
          visitQuote4(defined, logger, node[i], level)
          i = i + 1
        end
        return nil
      end
    else
      return nil
    end
  end
end
visitNode4 = function(defined, logger, node, last)
  while true do
    local temp = type1(node)
    if temp == "string" then
      return nil
    elseif temp == "number" then
      return nil
    elseif temp == "key" then
      return nil
    elseif temp == "symbol" then
      if node["var"]["scope"]["kind"] == "top-level" and not defined[node["var"]] then
        return putNodeWarning_21_1(logger, node["contents"] .. " has not been defined yet", node["source"], "This symbol is not defined until later in the program, but is accessed here.\nConsequently, it's value may be undefined when executing the program.", sourceRange1(node["source"]), "")
      else
        return nil
      end
    elseif temp == "list" then
      local first = nth1(node, 1)
      local firstTy = type1(first)
      if firstTy == "symbol" then
        local func = first["var"]
        local funcTy = func["kind"]
        if funcTy == "defined" or funcTy == "arg" or funcTy == "native" or funcTy == "macro" then
          return visitList1(defined, logger, node, 1)
        elseif func == builtins1["lambda"] then
          if last then
            return nil
          else
            return visitBlock3(defined, logger, node, 3)
          end
        elseif func == builtins1["cond"] then
          local forLimit = n1(node)
          local i = 2
          while i <= forLimit do
            local case = nth1(node, i)
            visitNode4(defined, logger, nth1(case, 1))
            visitBlock3(defined, logger, case, 2, last)
            i = i + 1
          end
          return nil
        elseif func == builtins1["set!"] then
          node, last = nth1(node, 3)
        elseif func == builtins1["struct-literal"] then
          return visitList1(defined, logger, node, 2)
        elseif func == builtins1["syntax-quote"] then
          return visitQuote4(defined, logger, nth1(node, 2), 1)
        elseif func == builtins1["define"] or func == builtins1["define-macro"] then
          visitNode4(defined, logger, nth1(node, n1(node)), true)
          defined[node["def-var"]] = true
          return nil
        elseif func == builtins1["define-native"] then
          defined[node["def-var"]] = true
          return nil
        elseif func == builtins1["quote"] then
          return nil
        elseif func == builtins1["import"] then
          return nil
        elseif func == builtins1["unquote"] or func == builtins1["unquote-splice"] then
          return error1("unquote/unquote-splice should never appear here", 0)
        else
          return error1("Unknown kind " .. funcTy .. " for variable " .. func["name"], 0)
        end
      elseif firstTy == "list" and builtin_3f_1(car1(first), "lambda") then
        visitList1(defined, logger, node, 2)
        return visitBlock3(defined, logger, first, 3, last)
      else
        return visitList1(defined, logger, node, 1)
      end
    else
      return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `\"string\"`\n  Tried: `\"number\"`\n  Tried: `\"key\"`\n  Tried: `\"symbol\"`\n  Tried: `\"list\"`")
    end
  end
end
visitBlock3 = function(defined, logger, node, start, last)
  local forLimit = n1(node) - 1
  local i = start
  while i <= forLimit do
    visitNode4(defined, logger, nth1(node, i))
    i = i + 1
  end
  if n1(node) >= start then
    return visitNode4(defined, logger, nth1(node, n1(node)), last)
  else
    return nil
  end
end
visitList1 = function(defined, logger, node, start)
  local forLimit = n1(node)
  local i = start
  while i <= forLimit do
    visitNode4(defined, logger, nth1(node, i))
    i = i + 1
  end
  return nil
end
checkOrder1 = {name="check-order", help="Check each node only eagerly accesses nodes defined after it.", cat={tag="list", n=1, "warn"}, run=function(temp, state, nodes)
  return visitList1({}, state["logger"], nodes, 1)
end}
checkArity1 = {name="check-arity", help="Produce a warning if any NODE in NODES calls a function with too many arguments.\n\nLOOKUP is the variable usage lookup table.", cat={tag="list", n=2, "warn", "usage"}, run=function(temp, state, nodes, lookup)
  local arity, updateArity_21_, getArity = {}
  updateArity_21_ = function(var, min, max)
    local ari = list1(min, max)
    arity[var] = ari
    return ari
  end
  getArity = function(var)
    local ari = arity[var]
    if ari ~= nil then
      return ari
    elseif var["kind"] == "native" then
      local native = varNative1(var)
      local ari1, signature = native["syntax-arity"], native["signature"]
      if signature then
        local min, max = n1(signature), n1(signature)
        local forLimit = n1(signature)
        local i = 1
        while i <= forLimit do
          local temp1 = sub1(symbol_2d3e_string1((signature[i])), 1, 1)
          if temp1 == "&" then
            max = huge1
          elseif temp1 == "?" then
            min = min - 1
          end
          i = i + 1
        end
        return updateArity_21_(var, min, max)
      elseif ari1 then
        if native["syntax-fold"] then
          return updateArity_21_(var, ari1, huge1)
        else
          return updateArity_21_(var, ari1, ari1)
        end
      else
        return updateArity_21_(var, 0, huge1)
      end
    else
      local defs = getVar1(lookup, var)["defs"]
      if n1(defs) ~= 1 then
        return updateArity_21_(var, 0, huge1)
      else
        local defData = car1(defs)
        local temp1 = type1(defData)
        if temp1 == "var" then
          return updateArity_21_(var, 0, huge1)
        elseif temp1 == "val" then
          local node = defData["value"]
          while true do
            if type1(node) == "symbol" then
              arity[var] = false
              local ari1 = getArity(node["var"])
              arity[var] = ari1
              return ari1
            elseif type1(node) == "list" and builtin_3f_1(car1(node), "lambda") then
              local signature = cadr1(node)
              local max = n1(signature)
              local forLimit = n1(signature)
              local i = 1
              while i <= forLimit do
                if signature[i]["var"]["is-variadic"] then
                  max = huge1
                end
                i = i + 1
              end
              return updateArity_21_(var, 0, max)
            elseif type1(node) == "list" and (type1((car1(node))) == "list" and (builtin_3f_1(caar1(node), "lambda") and n1(car1(node)) >= 3)) then
              node = last1(car1(node))
            elseif type1(node) == "list" then
              return updateArity_21_(var, 0, huge1)
            else
              arity[var] = false
              return false
            end
          end
        else
          return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp1) .. ", but none matched.\n" .. "  Tried: `\"var\"`\n  Tried: `\"val\"`")
        end
      end
    end
  end
  return visitBlock1(nodes, 1, function(node)
    if type1(node) == "list" and (type1((car1(node))) == "symbol" and car1(node)["var"]["kind"] ~= "builtin") then
      local arity1 = getArity(car1(node)["var"])
      local minArgs
      if singleReturn_3f_1(last1(node)) then
        minArgs = n1(node) - 1
      else
        minArgs = huge1
      end
      local maxArgs = n1(node) - 1
      if arity1 == false then
        return putNodeWarning_21_1(state["logger"], formatOutput_21_1(nil, "Calling non-function value " .. display1(car1(node))), node["source"], nil, sourceRange1(node["source"]), "Called here")
      elseif minArgs < car1(arity1) then
        return putNodeWarning_21_1(state["logger"], formatOutput_21_1(nil, "Calling " .. display1(car1(node)) .. " with " .. display1(minArgs) .. " arguments, expected at least " .. display1(car1(arity1))), node["source"], nil, sourceRange1(node["source"]), "Called here")
      elseif maxArgs > cadr1(arity1) then
        return putNodeWarning_21_1(state["logger"], formatOutput_21_1(nil, "Calling " .. display1(car1(node)) .. " with " .. display1(maxArgs) .. " arguments, expected at most " .. display1(cadr1(arity1))), node["source"], nil, sourceRange1(node["source"]), "Called here")
      else
        return nil
      end
    else
      return nil
    end
  end)
end}
deprecated1 = {name="deprecated", help="Produce a warning whenever a deprecated variable is used.", cat={tag="list", n=2, "warn", "usage"}, run=function(temp, state, nodes)
  local forLimit = n1(nodes)
  local i = 1
  while i <= forLimit do
    local node = nodes[i]
    local defVar = node["def-var"]
    visitNode1(node, function(node1)
      if type1(node1) == "symbol" then
        local var = node1["var"]
        if var ~= defVar and var["deprecated"] then
          return putNodeWarning_21_1(state["logger"], (function()
            if string_3f_1(var["deprecated"]) then
              return format1("%s is deprecated: %s", node1["contents"], var["deprecated"])
            else
              return format1("%s is deprecated.", node1["contents"])
            end
          end)(), node1["source"], nil, sourceRange1(node1["source"]), "")
        else
          return nil
        end
      else
        return nil
      end
    end)
    i = i + 1
  end
  return nil
end}
documentation1 = {name="documentation", help="Ensure doc comments are valid.", cat={tag="list", n=1, "warn"}, run=function(temp, state, nodes)
  local validate, forLimit = function(node, var, doc, kind)
    local temp1 = parseDocstring1(doc)
    local forLimit1 = n1(temp1)
    local i = 1
    while i <= forLimit1 do
      local tok = temp1[i]
      if tok["kind"] == "link" then
        if not lookup1(var["scope"], tok["contents"]) then
          putNodeWarning_21_1(state["logger"], format1("%s is not defined.", quoted1(tok["contents"])), node["source"], nil, sourceRange1(node["source"]), format1("Referenced in %s.", kind))
        end
      end
      i = i + 1
    end
    return nil
  end, n1(nodes)
  local i = 1
  while i <= forLimit do
    local node = nodes[i]
    local var = node["def-var"]
    if var then
      if string_3f_1(var["doc"]) then
        validate(node, var, var["doc"], "docstring")
      end
      if string_3f_1(var["deprecated"]) then
        validate(node, var, var["deprecated"], "deprecation message")
      end
    end
    i = i + 1
  end
  return nil
end}
unusedVars1 = {name="unused-vars", help="Ensure all non-exported NODES are used.", cat={tag="list", n=2, "warn", "usage"}, level=2, run=function(temp, state, _5f_, lookup)
  local unused = {tag="list", n=0}
  local temp1 = lookup["usage-vars"]
  local temp2, entry = next1(temp1)
  while temp2 ~= nil do
    if not (n1(entry["usages"]) > 0 or n1(entry["soft"]) > 0 or temp2["name"] == "_" or temp2["display-name"] ~= nil or empty_3f_1(entry["defs"])) then
      local def = car1(entry["defs"])["node"]
      local temp3
      if def["def-var"] == nil then
        temp3 = true
      elseif temp2["kind"] ~= "macro" then
        local scope, name = temp2["scope"], temp2["name"]
        temp3 = not scope["exported"][name]
      else
        temp3 = false
      end
      if temp3 then
        push_21_1(unused, list1(temp2, def))
      end
    end
    temp2, entry = next1(temp1, temp2)
  end
  sort1(unused, function(node1, node2)
    return range_3c_1(sourceRange1(cadr1(node1)["source"]), sourceRange1(cadr1(node2)["source"]))
  end)
  local forLimit = n1(unused)
  local i = 1
  while i <= forLimit do
    local pair = unused[i]
    putNodeWarning_21_1(state["logger"], format1("%s is not used.", quoted1(car1(pair)["name"])), cadr1(pair)["source"], nil, sourceRange1(cadr1(pair)["source"]), "Defined here")
    i = i + 1
  end
  return nil
end}
macroUsage1 = {name="macro-usage", help="Determines whether any macro is used.", cat={tag="list", n=1, "warn"}, run=function(temp, state, nodes)
  return visitBlock1(nodes, 1, function(node)
    if type1(node) == "list" and (builtin_3f_1(car1(node), "define-macro") and type1((nth1(node, 3))) == "symbol") then
      return false
    elseif type1(node) == "symbol" and node["var"]["kind"] == "macro" then
      return putNodeWarning_21_1(state["logger"], format1("The macro %s is not expanded", quoted1(node["contents"])), node["source"], "This macro is used in such a way that it'll be called as a normal function\ninstead of expanding into executable code. Sometimes this may be intentional,\nbut more often than not it is the result of a misspelled variable name.", sourceRange1(node["source"]), "macro used here")
    else
      return nil
    end
  end)
end}
mutableDefinitions1 = {name="mutable-definitions", help="Determines whether any macro is used.", cat={tag="list", n=2, "warn", "usage"}, run=function(temp, state, nodes, lookup)
  local forLimit = n1(nodes)
  local i = 1
  while i <= forLimit do
    local node = nodes[i]
    local var = node["def-var"]
    if var then
      local info = getVar1(lookup, var)
      if not var["const"] and (n1(info["defs"]) == 1 and (function()
        local scope, name = var["scope"], var["name"]
        return scope["exported"][name]
      end)() ~= var) then
        putNodeWarning_21_1(state["logger"], format1("%s is never mutated", quoted1(var["name"])), node["source"], "This definition is explicitly marked as :mutable, but is\nnever mutated. Consider removing the annotation.", sourceRange1(node["source"]), "variable defined here")
      end
    end
    i = i + 1
  end
  return nil
end}
analyse1 = function(nodes, state, passes)
  local lookup = {}
  local temp = passes["normal"]
  local forLimit = n1(temp)
  local i = 1
  while i <= forLimit do
    runPass1(temp[i], state, nil, nodes, lookup)
    i = i + 1
  end
  if not empty_3f_1(passes["usage"]) then
    runPass1(tagUsage1, state, nil, nodes, lookup, visitEagerExported_3f_1)
  end
  local temp = passes["usage"]
  local forLimit = n1(temp)
  local i = 1
  while i <= forLimit do
    runPass1(temp[i], state, nil, nodes, lookup)
    i = i + 1
  end
  return nil
end
default2 = function()
  return {normal=list1(documentation1, checkOrder1, deprecated1, macroUsage1), usage=list1(checkArity1, unusedVars1, mutableDefinitions1)}
end
estimateLength1 = function(node, max)
  local tag = type1(node)
  if tag == "string" or tag == "number" or tag == "symbol" or tag == "key" then
    return n1(tostring1(node["contents"]))
  elseif tag == "list" then
    local sum, i = 2, 1
    while sum <= max and i <= n1(node) do
      sum = sum + estimateLength1(nth1(node, i), max - sum)
      if i > 1 then
        sum = sum + 1
      end
      i = i + 1
    end
    return sum
  else
    return error1("Unknown tag " .. tag, 0)
  end
end
expression2 = function(node, writer)
  local tag = type1(node)
  if tag == "string" then
    return append_21_1(writer, quoted1(node["value"]))
  elseif tag == "number" then
    return append_21_1(writer, tostring1(node["value"]))
  elseif tag == "key" then
    return append_21_1(writer, ":" .. node["value"])
  elseif tag == "symbol" then
    return append_21_1(writer, node["contents"])
  elseif tag == "list" then
    append_21_1(writer, "(")
    if empty_3f_1(node) then
      return append_21_1(writer, ")")
    else
      local newline, max = false, 60 - estimateLength1(car1(node), 60)
      expression2(car1(node), writer)
      if max <= 0 then
        newline = true
        writer["indent"] = writer["indent"] + 1
      end
      local forLimit = n1(node)
      local i = 2
      while i <= forLimit do
        local entry = nth1(node, i)
        if not newline and max > 0 then
          max = max - estimateLength1(entry, max)
          if max <= 0 then
            newline = true
            writer["indent"] = writer["indent"] + 1
          end
        end
        if newline then
          line_21_1(writer)
        else
          append_21_1(writer, " ")
        end
        expression2(entry, writer)
        i = i + 1
      end
      if newline then
        writer["indent"] = writer["indent"] - 1
      end
      return append_21_1(writer, ")")
    end
  else
    return error1("Unknown tag " .. tag, 0)
  end
end
block2 = function(list, writer)
  local forLimit = n1(list)
  local i = 1
  while i <= forLimit do
    expression2(list[i], writer)
    line_21_1(writer)
    i = i + 1
  end
  return nil
end
emitLua1 = {name="emit-lua", setup=function(spec)
  addArgument_21_1(spec, {tag="list", n=1, "--emit-lua"}, "help", "Emit a Lua file.", "narg", "?", "var", "OUTPUT", "value", true, "cat", "out")
  addArgument_21_1(spec, {tag="list", n=1, "--shebang"}, "help", "Set the executable to use for the shebang.", "cat", "out", "value", _2a_arguments_2a_1[-1] or (_2a_arguments_2a_1[0] or "lua"), "narg", "?")
  return addArgument_21_1(spec, {tag="list", n=1, "--chmod"}, "help", "Run chmod +x on the resulting file", "cat", "out")
end, pred=function(args)
  return args["emit-lua"]
end, run=function(compiler, args)
  if empty_3f_1(args["input"]) then
    self1(compiler["log"], "put-error!", "No inputs to compile.")
    exit_21_1(1)
  end
  local out = file1(compiler, args["shebang"])
  local name
  if string_3f_1(args["emit-lua"]) then
    name = args["emit-lua"]
  else
    name = args["output"] .. ".lua"
  end
  local handle, error = open1(name, "w")
  if not handle then
    self1(compiler["log"], "put-error!", (sprintf1("Cannot open %q (%s)", name, error)))
    exit_21_1(1)
  end
  self1(handle, "write", concat2(out["out"]))
  self1(handle, "close")
  if args["chmod"] then
    return execute1("chmod +x " .. quoted1(name))
  else
    return nil
  end
end}
emitLisp1 = {name="emit-lisp", setup=function(spec)
  return addArgument_21_1(spec, {tag="list", n=1, "--emit-lisp"}, "help", "Emit a Lisp file.", "narg", "?", "var", "OUTPUT", "value", true, "cat", "out")
end, pred=function(args)
  return args["emit-lisp"]
end, run=function(compiler, args)
  if empty_3f_1(args["input"]) then
    self1(compiler["log"], "put-error!", "No inputs to compile.")
    exit_21_1(1)
  end
  local writer = {out={tag="list", n=0}, indent=0, ["tabs-pending"]=false, line=1, lines={}, ["node-stack"]={tag="list", n=0}, ["active-pos"]=nil}
  local name
  if string_3f_1(args["emit-lisp"]) then
    name = args["emit-lisp"]
  else
    name = args["output"] .. ".lisp"
  end
  block2(compiler["out"], writer)
  local handle, error = open1(name, "w")
  if not handle then
    self1(compiler["log"], "put-error!", (sprintf1("Cannot open %q (%s)", args["output"] .. ".lisp", error)))
    exit_21_1(1)
  end
  self1(handle, "write", concat2(writer["out"]))
  return self1(handle, "close")
end}
passArg1 = function(arg, data, value, usage_21_)
  local val, name = tonumber1(value), arg["name"] .. "-override"
  local override = data[name]
  if not override then
    override = {}
    data[name] = override
  end
  if val then
    data[arg["name"]] = val
    return nil
  elseif sub1(value, 1, 1) == "-" then
    override[sub1(value, 2)] = false
    return nil
  elseif sub1(value, 1, 1) == "+" then
    override[sub1(value, 2)] = true
    return nil
  else
    return usage_21_("Expected number or enable/disable flag for --" .. arg["name"] .. " , got " .. value)
  end
end
passRun1 = function(fun, name)
  return function(compiler, args)
    local options = {track=true, level=args[name], override=args[name .. "-override"] or {}, ["max-n"]=args[name .. "-n"], ["max-time"]=args[name .. "-time"], compiler=compiler, logger=compiler["log"], timer=compiler["timer"]}
    return fun(compiler["out"], options, filterPasses1(compiler[name], options))
  end
end
warning1 = {name="warning", setup=function(spec)
  return addArgument_21_1(spec, {tag="list", n=2, "--warning", "-W"}, "help", "Either the warning level to use or an enable/disable flag for a pass.", "default", 1, "narg", 1, "var", "LEVEL", "many", true, "action", passArg1)
end, pred=function()
  return true
end, run=passRun1(analyse1, "warning")}
optimise2 = {name="optimise", setup=function(spec)
  addCategory_21_1(spec, "optimise", "Optimisation", "Various controls for how the source code is optimised.")
  addArgument_21_1(spec, {tag="list", n=2, "--optimise", "-O"}, "help", "Either the optimisation level to use or an enable/disable flag for a pass.", "cat", "optimise", "default", 1, "narg", 1, "var", "LEVEL", "many", true, "action", passArg1)
  addArgument_21_1(spec, {tag="list", n=2, "--optimise-n", "--optn"}, "help", "The maximum number of iterations the optimiser should run for.", "cat", "optimise", "default", 10, "narg", 1, "action", setNumAction1)
  return addArgument_21_1(spec, {tag="list", n=2, "--optimise-time", "--optt"}, "help", "The maximum time the optimiser should run for.", "cat", "optimise", "default", -1, "narg", 1, "action", setNumAction1)
end, pred=function()
  return true
end, run=passRun1(optimise1, "optimise")}
printError_21_1 = function(msg)
  if not string_3f_1(msg) then
    msg = pretty1(msg)
  end
  local lines = split1(msg, "\n", 1)
  print1(coloured1(31, "[ERROR] " .. car1(lines)))
  if cadr1(lines) then
    return print1(cadr1(lines))
  else
    return nil
  end
end
printWarning_21_1 = function(msg)
  local lines = split1(msg, "\n", 1)
  print1(coloured1(33, "[WARN] " .. car1(lines)))
  if cadr1(lines) then
    return print1(cadr1(lines))
  else
    return nil
  end
end
printVerbose_21_1 = function(verbosity, msg)
  if verbosity > 0 then
    return formatOutput_21_1(true, "[VERBOSE] " .. msg)
  else
    return nil
  end
end
printDebug_21_1 = function(verbosity, msg)
  if verbosity > 1 then
    return formatOutput_21_1(true, "[DEBUG] " .. msg)
  else
    return nil
  end
end
printTime_21_1 = function(maximum, name, time, level)
  if level <= maximum then
    return formatOutput_21_1(true, "[TIME] " .. name .. " took " .. time)
  else
    return nil
  end
end
printExplain_21_1 = function(explain, lines)
  if explain then
    local temp = split1(lines, "\n")
    local forLimit = n1(temp)
    local i = 1
    while i <= forLimit do
      print1("  " .. (temp[i]))
      i = i + 1
    end
    return nil
  else
    return nil
  end
end
create4 = function(verbosity, explain, time)
  return {verbosity=verbosity or 0, explain=explain == true, time=time or 0, ["put-error!"]=putError_21_1, ["put-warning!"]=putWarning_21_1, ["put-verbose!"]=putVerbose_21_1, ["put-debug!"]=putDebug_21_1, ["put-time!"]=putTime_21_1, ["put-node-error!"]=putNodeError_21_2, ["put-node-warning!"]=putNodeWarning_21_2}
end
putError_21_1 = function(logger, msg)
  return printError_21_1(msg)
end
putWarning_21_1 = function(logger, msg)
  return printWarning_21_1(msg)
end
putVerbose_21_1 = function(logger, msg)
  return printVerbose_21_1(logger["verbosity"], msg)
end
putDebug_21_1 = function(logger, msg)
  return printDebug_21_1(logger["verbosity"], msg)
end
putTime_21_1 = function(logger, name, time, level)
  return printTime_21_1(logger["time"], name, time, level)
end
putNodeError_21_2 = function(logger, msg, source, explain, lines)
  printError_21_1(msg)
  putTrace_21_1(source)
  if explain then
    printExplain_21_1(logger["explain"], explain)
  end
  return putLines_21_1(true, lines)
end
putNodeWarning_21_2 = function(logger, msg, source, explain, lines)
  printWarning_21_1(msg)
  putTrace_21_1(source)
  if explain then
    printExplain_21_1(logger["explain"], explain)
  end
  return putLines_21_1(true, lines)
end
putLines_21_1 = function(ranges, entries)
  if empty_3f_1(entries) then
    error1("Positions cannot be empty")
  end
  if n1(entries) % 2 ~= 0 then
    error1("Positions must be a multiple of 2, is " .. n1(entries))
  end
  local previous, file, code, forLimit = -1, nth1(entries, 1)["name"], coloured1("32;1", " %" .. n1(tostring1((reduce1(function(max, range)
    if string_3f_1(range) then
      return max
    else
      return max1(max, range["start"]["line"])
    end
  end, 0, entries)))) .. "s │") .. " %s", n1(entries)
  local i = 1
  while i <= forLimit do
    local range, message = entries[i], entries[i + 1]
    if file ~= range["name"] then
      file = range["name"]
      print1(coloured1("35;1", " " .. file))
    elseif previous ~= -1 and abs1(range["start"]["line"] - previous) > 2 then
      print1(coloured1("32;1", " ..."))
    end
    previous = range["start"]["line"]
    print1(format1(code, tostring1(range["start"]["line"]), nth1(range["lines"], range["start"]["line"])))
    local pointer
    if not ranges then
      pointer = "^"
    elseif range["finish"] and range["start"]["line"] == range["finish"]["line"] then
      pointer = rep1("^", (range["finish"]["column"] - range["start"]["column"]) + 1)
    else
      pointer = "^..."
    end
    print1(format1(code, "", rep1(" ", range["start"]["column"] - 1) .. pointer .. " " .. message))
    i = i + 2
  end
  return nil
end
putTrace_21_1 = function(source)
  local source1, previous = source, nil
  while true do
    local formatted = formatSource1(source1)
    if previous == nil then
      print1(coloured1("36;1", "  => " .. formatted))
    elseif previous ~= formatted then
      print1("  in " .. formatted)
    end
    if nodeSource_3f_1(source1) then
      source1, previous = source1["parent"], formatted
    else
      return nil
    end
  end
end
includeRocks1 = function(logger, paths)
  local ok, cfg = pcall1(require1, "luarocks.core.cfg")
  if ok then
    call1(cfg, "init_package_paths")
    return includeRocksImpl1(logger, paths, cfg, require1("luarocks.core.path"), require1("luarocks.core.manif"), require1("luarocks.core.vers"), require1("luarocks.core.util"), require1("luarocks.dir"))
  else
    local ok1, cfg1 = pcall1(require1, "luarocks.cfg")
    if ok1 then
      call1(cfg1, "init_package_paths")
      return includeRocksImpl1(logger, paths, cfg1, require1("luarocks.path"), require1("luarocks.manif_core"), require1("luarocks.deps"), require1("luarocks.util"), require1("luarocks.dir"))
    else
      return nil_3f_1
    end
  end
end
includeRocksImpl1 = function(logger, paths, cfg, path, manif, vers, util, dir)
  local temp
  local tbl = cfg["rocks_trees"]
  temp = updateStruct1(tbl, "tag", "list", "n", #tbl)
  local forLimit = n1(temp)
  local i = 1
  while i <= forLimit do
    local tree = temp[i]
    local temp1 = call1(manif, "load_local_manifest", (call1(path, "rocks_dir", tree)))["repository"]
    local temp2, versions = next1(temp1)
    while temp2 ~= nil do
      if not (not next1(versions) or temp2 == "urn") then
        local mainVersion = apply1(min1, ((function()
          local temp3 = keys1(versions)
          return map2(vers["parse_version"], temp3)
        end)()))["string"]
        local rootPath = call1(path, "install_dir", temp2, mainVersion, tree)
        self1(logger, "put-verbose!", (format1("Including %s %s (located at %s)", temp2, mainVersion, rootPath)))
        push_21_1(paths, call1(dir, "path", rootPath, "urn-lib", "?"))
        push_21_1(paths, call1(dir, "path", rootPath, "urn-lib", "?", "init"))
      end
      temp2, versions = next1(temp1, temp2)
    end
    i = i + 1
  end
  return nil
end
createPluginState1 = function(compiler)
  local logger, variables, states, warnings, optimise, activeScope, activeNode = compiler["log"], compiler["variables"], compiler["states"], compiler["warning"], compiler["optimise"], function()
    return compiler["active-scope"]
  end, function()
    return compiler["active-node"]
  end
  return {["logger/put-error!"]=function(temp)
    return self1(logger, "put-error!", temp)
  end, ["logger/put-warning!"]=function(temp)
    return self1(logger, "put-warning!", temp)
  end, ["logger/put-verbose!"]=function(temp)
    return self1(logger, "put-verbose!", temp)
  end, ["logger/put-debug!"]=function(temp)
    return self1(logger, "put-debug!", temp)
  end, ["logger/put-node-error!"]=function(msg, node, explain, ...)
    local lines = _pack(...) lines.tag = "list"
    return putNodeError_21_1(logger, msg, node["source"], explain, splice1(lines))
  end, ["logger/put-node-warning!"]=function(msg, node, explain, ...)
    local lines = _pack(...) lines.tag = "list"
    return putNodeWarning_21_1(logger, msg, node["source"], explain, splice1(lines))
  end, ["logger/do-node-error!"]=function(msg, node, explain, ...)
    local lines = _pack(...) lines.tag = "list"
    return doNodeError_21_1(logger, msg, node["source"], explain, splice1(lines))
  end, ["range/get-source"]=getSource1, flags=function()
    return map2(id1, compiler["flags"])
  end, ["flag?"]=function(...)
    local flags = _pack(...) flags.tag = "list"
    return any1(function(temp)
      return elem_3f_1(temp, compiler["flags"])
    end, flags)
  end, ["visit-node"]=visitNode1, ["visit-nodes"]=visitBlock1, ["traverse-nodes"]=traverseNode1, ["traverse-nodes"]=traverseList1, ["symbol->var"]=function(x)
    local var = x["var"]
    if string_3f_1(var) then
      return variables[var]
    else
      return var
    end
  end, ["var->symbol"]=makeSymbol1, builtin=builtin1, ["builtin?"]=builtin_3f_1, ["constant?"]=constant_3f_1, ["node->val"]=urn_2d3e_val1, ["val->node"]=val_2d3e_urn1, ["node-contains-var?"]=nodeContainsVar_3f_1, ["node-contains-vars?"]=nodeContainsVars_3f_1, ["fusion/add-rule!"]=addRule_21_1, ["add-pass!"]=function(pass)
    if type1(pass) ~= "table" then
      error1(demandFailure1(nil, "(= (type pass) \"table\")"))
    end
    if not string_3f_1(pass["name"]) then
      error1("Expected string for name, got " .. type1(pass["name"]))
    end
    if not invokable_3f_1(pass["run"]) then
      error1("Expected function for run, got " .. type1(pass["run"]))
    end
    if type1((pass["cat"])) ~= "list" then
      error1("Expected list for cat, got " .. type1(pass["cat"]))
    end
    local func = pass["run"]
    pass["run"] = function(...)
      local args = _pack(...) args.tag = "list"
      local temp = list1(xpcall1(function()
        return apply1(func, args)
      end, traceback2))
      if type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (nth1(temp, 1) == false and true))) then
        local msg = nth1(temp, 2)
        return error1(remapTraceback1(compiler["compile-state"]["mappings"], msg), 0)
      elseif type1(temp) == "list" and (n1(temp) >= 1 and (nth1(temp, 1) == true and true)) then
        return splice1((slice1(temp, 2)))
      else
        return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `(false ?msg)`\n  Tried: `(true . ?rest)`")
      end
    end
    local cats = pass["cat"]
    if elem_3f_1("opt", cats) then
      if any1(function(temp)
        return sub1(temp, 1, 10) == "transform-"
      end, cats) then
        push_21_1(optimise["transform"], pass)
      elseif elem_3f_1("usage", cats) then
        push_21_1(optimise["usage"], pass)
      else
        push_21_1(optimise["normal"], pass)
      end
    elseif elem_3f_1("warn", cats) then
      if elem_3f_1("usage", cats) then
        push_21_1(warnings["usage"], pass)
      else
        push_21_1(warnings["normal"], pass)
      end
    else
      error1("Cannot register " .. pretty1(pass["name"]) .. " (do not know how to process " .. pretty1(cats) .. ")")
    end
    return nil
  end, ["var-usage"]=getVar1, ["active-scope"]=activeScope, ["active-node"]=activeNode, ["active-module"]=function()
    local scp = compiler["active-scope"]
    while true do
      if not scp then
        return nil
      elseif scp["kind"] == "top-level" then
        return scp
      else
        scp = scp["parent"]
      end
    end
  end, ["scope-vars"]=function(scope)
    if not scope then
      scope = compiler["active-scope"]
    end
    if type1(scope) ~= "scope" then
      error1(demandFailure1(nil, "(= (type scope) \"scope\")"))
    end
    return scope["variables"]
  end, ["scope-exported"]=function(scope)
    if not scope then
      scope = compiler["active-scope"]
    end
    if type1(scope) ~= "scope" then
      error1(demandFailure1(nil, "(= (type scope) \"scope\")"))
    end
    return scope["exported"]
  end, ["var-lookup"]=function(symb, scope)
    if type1(symb) ~= "symbol" then
      error1(demandFailure1(nil, "(= (type symb) \"symbol\")"))
    end
    if compiler["active-node"] == nil then
      error1("Not currently resolving")
    end
    if not scope then
      scope = compiler["active-scope"]
    end
    return lookupAlways_21_1(scope, symbol_2d3e_string1(symb), compiler["active-node"])
  end, ["try-var-lookup"]=function(symb, scope)
    if type1(symb) ~= "symbol" then
      error1(demandFailure1(nil, "(= (type symb) \"symbol\")"))
    end
    if compiler["active-node"] == nil then
      error1("Not currently resolving")
    end
    if not scope then
      scope = compiler["active-scope"]
    end
    return lookup1(scope, symbol_2d3e_string1(symb))
  end, ["var-definition"]=function(var)
    if compiler["active-node"] == nil then
      error1("Not currently resolving")
    end
    local state = states[var]
    if state then
      if state["stage"] == "parsed" then
        yield1({tag="build", state=state})
      end
      return state["node"]
    else
      return nil
    end
  end, ["var-value"]=function(var)
    if compiler["active-node"] == nil then
      error1("Not currently resolving")
    end
    local state = states[var]
    if state then
      return get_21_1(state)
    else
      return nil
    end
  end, ["var-docstring"]=varDoc1}
end
normalisePath1 = function(path, trailing)
  path = gsub1(path, "\\", "/")
  if trailing and (path ~= "" and sub1(path, -1, -1) ~= "/") then
    path = path .. "/"
  end
  while sub1(path, 1, 2) == "./" do
    path = sub1(path, 3)
  end
  return path
end
local spec = create1("The compiler and REPL for the Urn programming language.")
local directory
local dir = getenv1 and getenv1("URN_ROOT")
if dir then
  directory = normalisePath1(dir, true)
else
  local path = _2a_arguments_2a_1[0] or (getinfo1 and gsub1(getinfo1(1, "S")["short_src"], "^@", "") or "urn")
  if find1(path, "urn[/\\]cli%.lisp$") then
    path = gsub1(path, "urn[/\\]cli%.lisp$", "")
  elseif find1(path, "urn[/\\]cli$") then
    path = gsub1(path, "urn[/\\]cli$", "")
  elseif find1(path, "bin[/\\][^/\\]*$") then
    path = gsub1(path, "bin[/\\][^/\\]*$", "")
  else
    path = gsub1(path, "[^/\\]*$", "")
  end
  directory = normalisePath1(path, true)
end
local libName
local handle = open1(directory .. "urn-lib/prelude.lisp")
if handle then
  self1(handle, "close")
  libName = "urn-lib"
else
  libName = "lib"
end
local paths, tasks = list1("?", "?/init", directory .. libName .. "/?", directory .. libName .. "/?/init"), list1(coverageReport1, task1, task2, warning1, optimise2, emitLisp1, emitLua1, task3, execTask1, replTask1)
addHelp_21_1(spec)
addCategory_21_1(spec, "out", "Output", "Customise what is emitted, as well as where and how it is generated.")
addCategory_21_1(spec, "path", "Input paths", "Locations used to configure where libraries are loaded from.")
addArgument_21_1(spec, {tag="list", n=2, "--explain", "-e"}, "help", "Explain error messages in more detail.")
addArgument_21_1(spec, {tag="list", n=2, "--time", "-t"}, "help", "Time how long each task takes to execute. Multiple usages will show more detailed timings.", "many", true, "default", 0, "action", function(arg, data)
  data[arg["name"]] = (data[arg["name"]] or 0) + 1
  return nil
end)
addArgument_21_1(spec, {tag="list", n=2, "--verbose", "-v"}, "help", "Make the output more verbose. Can be used multiple times", "many", true, "default", 0, "action", function(arg, data)
  data[arg["name"]] = (data[arg["name"]] or 0) + 1
  return nil
end)
addArgument_21_1(spec, {tag="list", n=2, "--include", "-i"}, "help", "Add an additional argument to the include path.", "cat", "path", "many", true, "narg", 1, "default", {tag="list", n=0}, "action", addAction1)
addArgument_21_1(spec, {tag="list", n=2, "--prelude", "-P"}, "help", "A custom prelude path to use.", "cat", "path", "narg", 1, "default", directory .. libName .. "/prelude")
addArgument_21_1(spec, {tag="list", n=2, "--include-rocks", "-R"}, "help", "Include all installed LuaRocks on the search path.", "cat", "path")
addArgument_21_1(spec, {tag="list", n=3, "--output", "--out", "-o"}, "help", "The destination to output to.", "cat", "Output", "narg", 1, "default", "out", "action", function(arg, data, value)
  data[arg["name"]] = gsub1(value, "%.lua$", "")
  return nil
end)
addArgument_21_1(spec, {tag="list", n=2, "--wrapper", "-w"}, "help", "A wrapper script to launch Urn with", "narg", 1, "action", function(a, b, value)
  local args, i = map2(id1, _2a_arguments_2a_1), 1
  local len = n1(args)
  while i <= len do
    local item = nth1(args, i)
    if item == "--wrapper" or item == "-w" then
      removeNth_21_1(args, i)
      removeNth_21_1(args, i)
      i = len + 1
    elseif find1(item, "^%-%-wrapper=.*$") then
      removeNth_21_1(args, i)
      i = len + 1
    elseif find1(item, "^%-[^-]+w$") then
      args[i] = sub1(item, 1, -2)
      removeNth_21_1(args, i + 1)
      i = len + 1
    end
  end
  local command = list1(value)
  local interp = _2a_arguments_2a_1[-1]
  if interp then
    push_21_1(command, interp)
  end
  push_21_1(command, _2a_arguments_2a_1[0])
  local temp = list1(execute1(concat2(append1(command, args), " ")))
  if type1(temp) == "list" and (n1(temp) >= 1 and (number_3f_1(nth1(temp, 1)) and true)) then
    return exit1((nth1(temp, 1)))
  elseif type1(temp) == "list" and (n1(temp) >= 3 and (n1(temp) <= 3 and true)) then
    return exit1((nth1(temp, 3)))
  else
    return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `((number? @ ?code) . _)`\n  Tried: `(_ _ ?code)`")
  end
end)
addArgument_21_1(spec, {tag="list", n=1, "--plugin"}, "help", "Specify a compiler plugin to load.", "var", "FILE", "default", {tag="list", n=0}, "narg", 1, "many", true, "action", addAction1)
addArgument_21_1(spec, {tag="list", n=2, "--flag", "-f"}, "help", "Turn on a compiler flag, enabling or disabling a specific feature.", "default", {tag="list", n=0}, "narg", 1, "many", true, "action", addAction1)
addArgument_21_1(spec, {tag="list", n=1, "input"}, "help", "The file(s) to load.", "var", "FILE", "narg", "*")
local forLimit = n1(tasks)
local i = 1
while i <= forLimit do
  local task = tasks[i]
  task["setup"](spec)
  i = i + 1
end
local args = parse_21_1(spec)
local logger = create4(args["verbose"], args["explain"], args["time"])
local temp = args["include"]
local forLimit = n1(temp)
local i = 1
while i <= forLimit do
  local path = temp[i]
  if find1(path, "%?") then
    push_21_1(paths, normalisePath1(path, false))
  else
    path = normalisePath1(path, true)
    push_21_1(paths, path .. "?")
    push_21_1(paths, path .. "?/init")
  end
  i = i + 1
end
if args["include-rocks"] then
  includeRocks1(logger, paths)
end
self1(logger, "put-verbose!", ("Using path: " .. pretty1(paths)))
if args["prelude"] == directory .. libName .. "/prelude" and empty_3f_1(args["plugin"]) then
  push_21_1(args["plugin"], directory .. "plugins/fold-defgeneric.lisp")
end
if empty_3f_1(args["input"]) then
  args["repl"] = true
elseif not args["emit-lua"] then
  args["emit-lua"] = true
end
local compiler = {log=logger, timer={callback=function(temp, temp1, temp2)
  return self1(logger, "put-time!", temp, temp1, temp2)
end, timers={}}, paths=paths, flags=args["flag"], libs=libraryCache1(), prelude=nil, ["root-scope"]=rootScope1, warning=default2(), optimise=default1(), exec=function(func)
  return list1(xpcall1(func, traceback2))
end, variables={}, states={}, out={tag="list", n=0}}
compiler["compile-state"] = createState1()
compiler["loader"] = function(temp)
  return namedLoader1(compiler, temp)
end
compiler["global"] = setmetatable1({_libs=compiler["libs"]["values"], _compiler=createPluginState1(compiler)}, {__index=_5f_G1})
local temp = rootScope1["variables"]
local temp1, var = next1(temp)
while temp1 ~= nil do
  compiler["variables"][tostring1(var)] = var
  temp1, var = next1(temp, temp1)
end
local forLimit = n1(tasks)
local i = 1
while i <= forLimit do
  local task = tasks[i]
  if task["pred"](args) then
    local setup = task["init"]
    if setup then
      setup(compiler, args)
    end
  end
  i = i + 1
end
startTimer_21_1(compiler["timer"], "loading")
local doLoad_21_ = function(name)
  local temp = list1(xpcall1(function()
    return pathLoader1(compiler, name)
  end, traceback3))
  if type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (nth1(temp, 1) == false and compilerError_3f_1(nth1(temp, 2))))) then
    return exit_21_1(1)
  elseif type1(temp) == "list" and (n1(temp) >= 2 and (n1(temp) <= 2 and (nth1(temp, 1) == false and true))) then
    return error1(nth1(temp, 2), 0)
  else
    local temp1
    if type1(temp) == "list" then
      if n1(temp) >= 2 then
        if n1(temp) <= 2 then
          if nth1(temp, 1) == true then
            local temp2 = nth1(temp, 2)
            temp1 = type1(temp2) == "list" and (n1(temp2) >= 2 and (n1(temp2) <= 2 and (nth1(temp2, 1) == nil and true)))
          else
            temp1 = false
          end
        else
          temp1 = false
        end
      else
        temp1 = false
      end
    else
      temp1 = false
    end
    if temp1 then
      self1(logger, "put-error!", (nth1(nth1(temp, 2), 2)))
      return exit_21_1(1)
    else
      local temp1
      if type1(temp) == "list" then
        if n1(temp) >= 2 then
          if n1(temp) <= 2 then
            if nth1(temp, 1) == true then
              local temp2 = nth1(temp, 2)
              temp1 = type1(temp2) == "list" and (n1(temp2) >= 1 and (n1(temp2) <= 1 and true))
            else
              temp1 = false
            end
          else
            temp1 = false
          end
        else
          temp1 = false
        end
      else
        temp1 = false
      end
      if temp1 then
        return (nth1(nth1(temp, 2), 1))
      else
        return error1("Pattern matching failure!\nTried to match the following patterns against " .. pretty1(temp) .. ", but none matched.\n" .. "  Tried: `(false error/compiler-error?)`\n  Tried: `(false ?error-message)`\n  Tried: `(true (nil ?error-message))`\n  Tried: `(true (?lib))`")
      end
    end
  end
end
setupPrelude_21_1(compiler, (doLoad_21_(args["prelude"])))
local temp = append1(args["plugin"], args["input"])
local forLimit = n1(temp)
local i = 1
while i <= forLimit do
  doLoad_21_((temp[i]))
  i = i + 1
end
stopTimer_21_1(compiler["timer"], "loading")
local forLimit = n1(tasks)
local i = 1
while i <= forLimit do
  local task = tasks[i]
  if task["pred"](args) then
    startTimer_21_1(compiler["timer"], task["name"], 1)
    task["run"](compiler, args)
    stopTimer_21_1(compiler["timer"], task["name"])
  end
  i = i + 1
end
return nil
