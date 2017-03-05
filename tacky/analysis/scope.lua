local logger = require "tacky.logger.init"
local range = require "tacky.range"

local Scope = {}
Scope.__index = Scope

function Scope.child(parent)
	local child = setmetatable({
		--- The parent scope.
		parent = parent,

		--- Lookup of named variables.
		variables = {},

		-- Lookup of exported variables
		exported = {},

		-- Prefix for all variables
		prefix = parent and parent.prefix or "",
	}, Scope)

	return child
end

Scope.empty = Scope.child(nil)

function Scope:get(name, user, noYield)
	local element = self

	while element do
		local var = element.variables[name]
		if var then return var end

		element = element.parent
	end

	if noYield then return end

	-- We don't have a variable. This means we've got a function which hasn't
	-- been defined yet or doesn't exist.
	-- Halt this execution and wait til it is parsed.
	return coroutine.yield({
		tag = "define",
		name = name,
		node = user,
		scope = self,
	})
end

local kinds = { defined = true, native = true, macro = true, arg = true, builtin = true }

function Scope:add(name, kind, node)
	if name == nil then error("name is nil", 2) end
	if not kinds[kind] then error("unknown kind " .. tostring(kind), 2) end
	if self.variables[name] then error("Previous declaration of " .. name) end

	local var = {
		tag = kind,
		name = name,
		fullName = self.prefix .. name,
		scope = self,
		const = kind ~= "arg",
		node = node,
	}
	self.variables[name] = var
	self.exported[name] = var
	return var
end

function Scope:addVerbose(name, kind, node, loggerI)
	if name == nil then error("name is nil", 2) end
	if not kinds[kind] then error("unknown kind " .. tostring(kind), 2) end

	local previous = self.variables[name]
	if previous then
		local previous = self.variables[name].node

		logger.doNodeError(loggerI,
			"Previous declaration of " .. name,
			node, nil,
			range.getSource(node), "new definition here",
			range.getSource(previous), "old definition here"
		)
	end

	return self:add(name, kind, node)
end

function Scope:import(name, var, node, export)
	if var == nil then error("var is nil", 2) end
	if self.variables[name] and self.variables[name] ~= var then error("Previous declaration of " .. name) end

	self.variables[name] = var

	if export then
		self.exported[name] = var
	end

	return var
end

function Scope:importVerbose(name, var, node, export, loggerI)
	if var == nil then error("var is nil", 2) end

	if node then logger.putDebug(loggerI, "Importing " .. name .. " into " .. range.getSource(node).name) end

	if self.variables[name] and self.variables[name] ~= var then
		local current = var.node
		local previous = self.variables[name].node

		logger.putNodeError(loggerI,
			"Previous declaration of " .. name,
			node, nil,
			range.getSource(node), "imported here",
			range.getSource(current), "new definition here",
			range.getSource(previous), "old definition here"
		)
	end

	if export and node then logger.putDebug(loggerI, "Exporting " .. name .. " from " .. range.getSource(node).name) end

	return self:import(name, var, node, export)
end

return Scope
