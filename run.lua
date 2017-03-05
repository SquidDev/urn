#!/usr/bin/env lua

local compiler_dir = debug.getinfo(1).source
compiler_dir = compiler_dir:sub(2, #compiler_dir - #('run.lua'))

-- Normalise compiler directory
if compiler_dir ~= "" and compiler_dir:sub(#compiler_dir) ~= "/" then
	compiler_dir = compiler_dir .. "/"
end
while compiler_dir:sub(1, 2) == "./" do
	compiler_dir = compiler_dir:sub(3)
end

local sep = package.config:sub(3, 3)
package.path = package.path .. sep .. compiler_dir .. '?.lua' .. sep .. compiler_dir .. "?/init.lua" .. sep

local backend = require "tacky.backend.init"
local compile = require "tacky.compile"
local documentation = require "tacky.documentation"
local logger = require "tacky.logger.init"
local optimise = require "tacky.analysis.optimise"
local parser = require "tacky.parser"
local resolve = require "tacky.analysis.resolve"
local warning = require "tacky.analysis.warning"
local term = require "tacky.logger.term"

local termLogger = term.create()
local paths = { "?", "?/init", compiler_dir .. 'lib/?', compiler_dir .. "lib/?/init" }
local inputs, output, run, prelude, time, removeOut, scriptArgs, docs, emitLisp, shebang = {}, "out", false, compiler_dir .. "lib/prelude", false, false, {}, false, false, true

-- Tiny Lua stub
if _VERSION:find("5.1") then
	function load(str, name, _, env)
		local f, e = loadstring(str, name)
		if not f then return false, e end
		if env then setfenv(f, env) end
		return f
	end
end

local args = table.pack(...)
local interp, prog, wi = arg[-1], arg[0]
local i = 1
while i <= args.n do
	local arg = args[i]
	if arg == "--output" or arg == "-o" or arg == "--out" then
		i = i + 1
		output = args[i] or error("Expected output after " .. arg, 0)
		output = output:gsub("%.lua$", "")
	elseif arg == "--remove-out" or arg == "--rm-out" then
		removeOut = true
	elseif arg == "--no-shebang" then
		shebang = false
	elseif arg == "-v" then
		termLogger.verbosity = termLogger.verbosity + 1
	elseif arg == "--explain" or arg == "-e" then
		termLogger.explain = true
	elseif arg == "--run" or arg == "-r" then
		run = true
	elseif arg == "--time" or arg == "-t" then
		time = true
	elseif arg == "--emit-lisp" then
		emitLisp = true
	elseif arg == "--docs" or arg == "-d" then
		i = i + 1
		docs = args[i] or error("Expected directory after " .. arg, 0)
	elseif arg == "--include" or arg == "-i" then
		i = i + 1
		local path = args[i] or error("Expected directory after " .. arg, 0)
		path = path:gsub("\\", "/"):gsub("^%./", "")
		if not path:find("?") then
			if path:sub(#path, #path) == "/" then
				path = path .. "?"
			else
				path = path .. "/?"
			end
		end
		paths[#paths + 1] = path
	elseif arg == "--prelude" or arg == "-p" then
		i = i + 1
		prelude = args[i] or error("Expected prelude after " .. arg, 0)
	elseif arg == '--wrapper' then
		local _, wrapper = table.remove(args, i), table.remove(args, i)
		local command = table.concat({wrapper, interp, prog}, " ")
		os.execute(command .. " " .. table.concat(args, " "))
		return
	elseif arg == '--with-interpreter' then
		_, wi = table.remove(args, i), table.remove(args, i)
	elseif arg == '--' then
		i = i + 1
		while i <= args.n do
			scriptArgs[#scriptArgs + 1] = args[i]
			i = i + 1
		end
		break
	elseif arg and arg:sub(1, 1) == "-" then
		error("Unknown option " .. arg, 0)
	elseif arg then
		inputs[#inputs + 1] = arg:gsub("\\", "/"):gsub("^%./", "")
	end

	i = i + 1
end

logger.putVerbose(termLogger, "Using path: " .. table.concat(paths, ":"))

local libEnv = {}
local libMeta = {}
local libs = {}
local libCache = {}
local global = setmetatable({ _libs = libEnv }, {__index = _ENV or _G})
local compileState = backend.lua.backend.createState(libMeta)

local rootScope = resolve.rootScope
local variables, states = {}, {}
local out = {}

for _, var in pairs(resolve.rootScope.variables) do variables[tostring(var)] = var end

local function libLoader(name, shouldResolve)
	if name:sub(-5) == ".lisp" then
		name = name:sub(1, -6)
	end

	local current = libCache[name]
	if current == true then
		error("Loop: already loading " .. name, 2)
	elseif current ~= nil then
		return true, current.scope.exported
	end

	logger.putVerbose(termLogger, "Loading " .. name)

	libCache[name] = true

	local lib = { name = name }

	local path, handle
	local looked = {}
	if shouldResolve == false then
		path = name
		looked[#looked + 1] = path

		handle = io.open(path .. ".lisp", "r")
	else
		for i = 1, #paths do
			path = paths[i]:gsub("%?", name)
			looked[#looked + 1] = path

			handle = io.open(path .. ".lisp", "r")
			if handle then
				break
			end
		end
	end

	if not handle then return false, "Cannot find " .. name .. " (looked at " .. table.concat(looked, ", ") .. ")" end

	lib.lisp = handle:read("*a")
	lib.path = path
	handle:close()

	for i = 1, #libs do
		local tempLib = libs[i]
		if tempLib.path == path then
			logger.putVerbose(termLogger, "Reusing " .. tempLib.name .. " for " .. name)
			local current = libCache[tempLib.name]
			libCache[name] = current
			return true, current.scope.exported
		end
	end

	-- Load the native file
	local handle = io.open(path .. ".lua", "r")
	if handle then
		lib.native = handle:read("*a")
		handle:close()

		local fun, msg = load(lib.native, "@" .. lib.name, "t", _ENV)
		if not fun then error(msg, 0) end

		for k, v in pairs(fun()) do
			libEnv[lib.path .. "/" .. k] = v
		end
	end

	-- Parse the meta info
	local metaHadle = io.open(path .. ".meta.lua", "r")
	if metaHadle then
		local meta = metaHadle:read("*a")
		metaHadle:close()

		local fun, msg = load(meta, "@" .. lib.name .. ".meta", "t", _ENV)
		if not fun then error(msg, 0) end

		for name, entry in pairs(fun()) do
			local full = lib.path .. "/" .. name

			if (entry.tag == "expr" or entry.tag == "stmt") and type(entry.contents) == "string" then
				local buffer = {tag="list"}
				local str = entry.contents
				local current = 1
				while current <= #str do
					local start, finish = str:find("%${(%d+)}", current)
					if not start then
						buffer[#buffer + 1] = str:sub(current, #str)
						current = #str + 1
					else
						if start > current then
							buffer[#buffer + 1] = str:sub(current, start - 1)
						end
						buffer[#buffer + 1] = tonumber(str:sub(start + 2, finish - 1))
						current = finish + 1
					end
				end

				buffer.n = #buffer
				entry.contents = buffer
			end


			-- Extract the value from one of the nodes
			if entry.value == nil then
				entry.value = libEnv[full]
			elseif entry.value ~= nil then
				if libEnv[full] ~= nil then error("Duplicate value for " .. full .. " (in native and meta file)", 0) end
				libEnv[full] = entry.value
			end

			libMeta[full] = entry
		end
	end

	local start = os.clock()
	local lexed = parser.lex(termLogger, lib.lisp, lib.path .. ".lisp")
	local parsed = parser.parse(termLogger, lexed, lib.lisp)
	if time then print(lib.path .. " parsed in " .. (os.clock() - start)) end

	local scope = rootScope:child()
	scope.isRoot = true
	scope.prefix = lib.path .. "/"
	lib.scope = scope

	local compiled, state = compile.compile(parsed, global, variables, states, scope, compileState, libLoader, termLogger)

	libs[#libs + 1] = lib
	libCache[name] = lib

	-- Extract the documentation node if it is there.
	if compiled[1] and compiled[1].tag == "string" then
		lib.docs = compiled[1].value
		table.remove(compiled, 1)
	end

	for i = 1, #compiled do
		out[#out + 1] = compiled[i]
	end

	logger.putVerbose(termLogger, "Loaded " .. name)

	return true, scope.exported
end

local _, preludeVars = assert(libLoader(prelude, false))

rootScope = rootScope:child()
for name, var in pairs(preludeVars) do
	rootScope:import(name, var)
end

for i = 1, #inputs do
	assert(libLoader(inputs[i], false))
end

if docs then
	for i = 1, #inputs do
		local path = inputs[i]
		if path:sub(-5) == ".lisp" then path = path:sub(1, -6) end

		local lib = libCache[path]
		local out = backend.markdown.exported(path, lib.docs, lib.scope.exported)

		local handle = io.open(docs .. "/" .. path:gsub("/", ".") .. ".md", "w+")
		handle:write(out)
		handle:close()
	end

	if not run then return end
end

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

if #inputs == 0 then
	local scope = rootScope

	local function tryParse(str)
		local start = os.clock()
		local ok, lexed = pcall(parser.lex, termLogger, str, "<stdin>")
		if not ok then
			logger.putError(termLogger, lexed)
			return {}
		end

		local ok, parsed = pcall(parser.parse, termLogger, lexed)
		if not ok then
			logger.putError(termLogger, parsed)
			return {}
		end

		if time then print("<stdin>" .. " parsed in " .. (os.clock() - start)) end

		local ok, msg, state = pcall(compile.compile, parsed, global, variables, states, scope, compileState, libLoader, termLogger)
		if not ok then
			logger.putError(termLogger, msg)
			return {}
		end

		return state
	end

	local buffer = {}
	while true do
		if #buffer == 0 then
			io.write(term.colored(92, "> "))
		else
			io.write(term.colored(92, ". "))
		end
		io.flush()

		local line = io.read("*l")

		if not line and #buffer == 0 then
			-- Exit if we have nothing to run
			break
		elseif line and line:sub(#line, #line) == "\\" then
			buffer[#buffer + 1] = line:sub(1, #line - 1) .. "\n"
		elseif line and #buffer > 0 and #line > 0 then
			buffer[#buffer + 1] = line .. "\n"
		else
			local data = table.concat(buffer) .. (line or "")
			buffer = {}

			local state
			if data:sub(1, 1) == ":" then
				data = data:sub(2)
				local parts = {}
				for part in data:gmatch("(%S+)") do parts[#parts + 1] = part end
				local command = parts[1]

				if not command then
					logger.putError(termLogger, "Expected command after ':'")
				elseif command == "doc" then
					local name = parts[2]
					if not name then
						logger.putError(termLogger, ":command <variable>")
					else
						local var = scope:get(name, nil, true)
						if not var then
							logger.putError(termLogger, "Cannot find '" .. name .. "'")
						elseif not var.doc then
							logger.putError(termLogger, "No documentation for '" .. name .. "'")
						else
							local sig = documentation.extractSignature(var)
							local name = var.fullName
							if sig then
								local buffer = {name}
								for i = 1, sig.n do buffer[i + 1] = sig[i].contents end
								name = "(" .. table.concat(buffer, " ") .. ")"
							end
							print(term.colored(96, name))

							local docs = documentation.parseDocs(var.doc)
							for i = 1, #docs do
								local tok = docs[i]
								if tok.tag == "text" then
									io.write(tok.contents)
								elseif tok.tag == "arg" then
									io.write(term.colored(36, tok.contents))
								elseif tok.tag == "mono" then
									io.write(term.colored(97, tok.contents))
								elseif tok.tag == "link" then
									io.write(term.colored(94, tok.contents))
								end
							end
							print()
						end
					end
				elseif parts[1] == "scope" then
					local vars, varSet = {}, {}
					local current = scope
					while current do
						for name, var in pairs(current.variables) do
							if not varSet[name] then
								varSet[name] = true
								vars[#vars + 1] = name
							end
						end
						current = current.parent
					end

					table.sort(vars)

					print(table.concat(vars, " "))
				else
					logger.putError(termLogger, "Unknown command '" .. command .. "'")
				end
			else
				scope = scope:child()
				scope.isRoot = true

				state = tryParse(data)
			end

			if state and #state ~= 0 then
				local current = 0
				local exec = coroutine.create(function()
					for i = 1, #state do
						current = state[i]
						current:get()
					end
				end)

				while true do
					local ok, data = coroutine.resume(exec)
					if not ok then
						logger.putError(termLogger, data)
						break
					end

					if coroutine.status(exec) == "dead" then
						print(term.colored(96, pretty(state[#state]:get())))
						break
					else
						local states = data.states
						if states[1] == current and not current.var then
							table.remove(states, 1)
							local ok, msg = pcall(compile.executeStates, compileState, states, global, termLogger)
							if not ok then logger.putError(termLogger, msg) break end

							local str = backend.lua.prelude() .. "\n" .. backend.lua.expression(current.node, compileState, "return ")
							local fun, msg = load(str, "=<input>", "t", global)
							if not fun then error(msg .. ":\n" .. str, 0) end

							local ok, res = xpcall(fun, debug.traceback)
							if not ok then logger.putError(termLogger, res) break end

							current:executed(res)
						else
							local ok, msg = pcall(compile.executeStates, compileState, states, global)
							if not ok then logger.putError(termLogger, msg) break end
						end
					end
				end
			end
		end
	end

	return
end

out.n = #out
out.tag = "list"

warning.analyse(out, { meta = libMeta, logger = termLogger })

local start = os.clock()
out = optimise(out, { meta = libMeta, logger = termLogger })
if time then print("Optimised in " .. (os.clock() - start)) end

local state = backend.lua.backend.createState(libMeta)
local compiledLua = backend.lua.block(out, state, 1, "return ")
local handle = io.open(output .. ".lua", "w")

if shebang then
	handle:write("#!/usr/bin/env " .. (wi or interp) .. '\n')
end
handle:write(backend.lua.prelude())

handle:write("local _libs = {}\n")
for i = 1, #libs do
	local prefix = ("%q"):format(libs[i].path .. "/")
	local native = libs[i].native
	if native then
		handle:write("local _temp = (function()\n")

		-- Indent the libraries to make them look prettier
		for line in native:gmatch("[^\n]*") do
			if line == "" then
			else
				handle:write("\t")
				handle:write(line)
				handle:write("\n")
			end
		end
		handle:write("end)()\nfor k, v in pairs(_temp) do _libs[" .. prefix .. ".. k] = v end\n")
	end
end

-- Count the number of active variables
local count = 0
for i = 1, out.n do
	local var = out[i].defVar
	if var then count = count + 1 end
end

-- Predeclare all variables. We only do this if we're pretty sure we won't hit the
-- "too many local variable" errors. The upper bound is actually 200, but lambda inlining
-- will probably bring it up slightly.
-- In the future we probably ought to handle this smartly when it is over 150 too.
if count < 150 then
	handle:write("local ")
	local first = true
	for i = 1, out.n do
		local var = out[i].defVar
		if var then
			if first then
				first = false
			else
				handle:write(", ")
			end

			handle:write(backend.lua.backend.escapeVar(var, state))
		end
	end
end

handle:write("\n")
handle:write(compiledLua)
handle:close()

if emitLisp then
	local compiledLisp = backend.lisp.block(out, 1)
	local handle = io.open(output .. ".lisp", "w")

	handle:write(compiledLisp)
	handle:close()
end

if run then
	_G.arg = scriptArgs -- Execute using specified arguments
	dofile(output .. ".lua")
end

if removeOut then
	os.remove(output .. ".lua")
	os.remove(output .. ".lisp")
end
