local M = { }
local insert = table.insert

M.DEFAULT_CFG = {
	hide_hash   = false;   -- Print the non-array part of tables?
	metalua_tag = true;    -- Use Metalua's backtick syntax sugar?
	keywords    = { };     -- Set of keywords which must not use Lua's field shortcuts {["foo"]=...} -> {foo=...}
	blacklist   = { };     -- Set of fields to not display
	max_depth   = -1;      -- Max depth to traverse
	with_name   = false;   -- If the field 'name' exists, print that instead.
	dups        = false;   -- Print any duplicates in different structures
}

M.nodeConfig = {
	blacklist = {
		parent = true, var = true, lines = true,
		macro = true, start = true, finish = true, range = true,
		variables = true, scope = true, required = true,
	},
	dups = true
}

local function validId(x, cfg)
	if type(x) ~= "string" then return false end
	if not x:match "^[a-zA-Z_][a-zA-Z0-9_]*$" then return false end
	if cfg.keywords and cfg.keywords[x] then return false end
	return true
end

local function serializeImplicit(object, data)
	if data.cfg.max_depth > -1 and data.indent > data.cfg.max_depth then
		insert(data, "...")
		return
	end

	local t = type(object)
	if t == "string" then
		insert(data, (string.format("%q", object):gsub("\\\n", "\\n")))
	elseif t == "table" and not data.visited[object] then
		if data.cfg.with_name and type(object.name) == "string" and object.name ~= "" then
			insert(data, '[' .. object.name .. ']')
			return
		end

		data.visited[object] = true
		data.indent = data.indent + 1

		local hasTag = data.cfg.metalua_tag and validId(object.tag, data.cfg)

		if hasTag then
			insert(data, '`')
			insert(data, object.tag)
		end

		local shouldNewLine = false
		local objLen = #object

		local builder = 0
		for k,v in pairs(object) do
			if (not data.cfg.hide_hash and not data.cfg.blacklist[k]) or (type(k) == "number" and k > 0 and k <= objLen and math.fmod(k, 1) == 0) then
				if type(k) == "table" or type(v) == "table" then
					shouldNewLine = true
					break
				else
					builder = builder + #tostring(v) + #tostring(k)
					if builder > 80 then
						shouldNewLine = true
					end
				end
			end
		end

		local first = false
		insert(data, "{")

		if not data.cfg.hide_hash then
			for k, v in pairs(object) do
				if hasTag and k=='tag' then  -- pass the 'tag' field
				elseif type(k) == "number" and k <= objLen and k > 0 and math.fmod(k,1)==0 then
					-- pass array-part keys (consecutive ints less than `#adt`)
				elseif not data.cfg.blacklist[k] then
					if first then
						-- 1st hash-part pair ever found
						insert(data, ", ")
					else
						first = true
					end

					if shouldNewLine then
						insert(data, "\n" .. ("\t"):rep(data.indent))
					end

					-- Print the key
					if validId(k, data.cfg) then
						insert(data, k)
					else
						serializeImplicit(k, data)
					end
					insert(data, " = ")
					serializeImplicit(v, data)
				end
			end
		end

		for k,v in ipairs(object) do
			if first then
				-- 1st hash-part pair ever found
				insert(data, ", ")
			else
				first = true
			end

			if shouldNewLine then
				insert(data, "\n" .. ("\t"):rep(data.indent))
			end
			serializeImplicit(v, data)
		end

		data.indent = data.indent - 1
		if shouldNewLine then
			insert(data, "\n" .. ("\t"):rep(data.indent))
		end
		insert(data, "}")

		-- Allow repeated but not recursive entries
		if data.cfg.dups then
			data.visited[object] = false
		end
	else
		insert(data, tostring(object))
	end
end

function M.tostring(object, cfg)
	if cfg == nil then
		cfg = M.DEFAULT_CFG
	else
		for k,v in pairs(M.DEFAULT_CFG) do
			if cfg[k] == nil then cfg[k] = v end
		end
	end
	local d = {
		indent = 0,
		cfg = cfg,
		visited = {},
	}
	serializeImplicit(object, d)
	return table.concat(d)
end

function M.print(...)
	local args = {...}
	for i = 1, select('#', ...) do args[i] = M.tostring(args[i]) end
	return print(table.unpack(args))
end

function M.sprintf(fmt, ...)
	local args = {...}
	for i = 1, select('#', ...) do args[i] = M.tostring(args[i]) end
	return string.format(fmt, table.unpack(args))
end

function M.printf(...) print(M.sprintf(...)) end

return M
