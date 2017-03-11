local logger = require "tacky.logger"
local Scope = require "tacky.analysis.scope"
local compile = require "tacky.compile"
local resolve = require "tacky.analysis.resolve"
local parser = require "tacky.parser"

local function libLoader(state, name, shouldResolve)
	local termLogger = state.log
	local libs = state.libs
	local paths = state.paths
	local libCache = state.libCache
	local libEnv = state.libEnv
	local libMeta = state.libMeta

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

	local lib = { id = name, name = name }

	local path, handle
	local looked = {}
	if shouldResolve == false then
		path = name
		looked[#looked + 1] = path

		local current = name
		for i = 1, #paths do
			local sub = name:match("^" .. paths[i]:gsub("%?", "(.*)") .. "$")
			if sub and #sub < #current then
				current = sub
			end
		end
		lib.name = current

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
			logger.putVerbose(termLogger, "Reusing " .. tempLib.id .. " for " .. name)
			local current = libCache[tempLib.id]
			libCache[name] = current
			return true, current.scope.exported
		end
	end

	local prefix = lib.name .. "-" .. #libs .. "/"
	lib.prefix = prefix

	-- Load the native file
	local handle = io.open(path .. ".lua", "r")
	if handle then
		lib.native = handle:read("*a")
		handle:close()

		local fun, msg = load(lib.native, "@" .. lib.name, "t", _ENV)
		if not fun then error(msg, 0) end

		for k, v in pairs(fun()) do
			libEnv[prefix .. k] = v
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
			local full = prefix .. name

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

	local lexed = parser.lex(termLogger, lib.lisp, lib.path .. ".lisp")
	local parsed = parser.parse(termLogger, lexed, lib.lisp)

	local scope = Scope.child(state.rootScope)
	scope.isRoot = true
	scope.prefix = prefix
	lib.scope = scope

	local compiled, _ = compile.compile(
		parsed,
		state.global, state.variables, state.states,
		scope,
		state.compileState, function(name) return libLoader(state, name, true) end,
		termLogger
	)

	libs[libs.n + 1] = lib
	libs.n = libs.n + 1
	libCache[name] = lib

	-- Extract the documentation node if it is there.
	if compiled[1] and compiled[1].tag == "string" then
		lib.docs = compiled[1].value
		table.remove(compiled, 1)
	end

	for i = 1, #compiled do
		state.out[state.out.n + 1] = compiled[i]
		state.out.n = state.out.n + 1
	end

	logger.putVerbose(termLogger, "Loaded " .. name)

	return true, scope.exported
end

return {
	['lib-loader'] = libLoader,
	['root-scope'] = resolve.rootScope,
	['scope/child']  = Scope.child,
	['scope/import!'] = Scope.import,
}
