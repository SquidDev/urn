local logger = require "tacky.logger"

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
	}, Scope)

	return child
end

Scope.empty = Scope.child(nil)

function Scope:get(name, user)
	local element = self

	while element do
		local var = element.variables[name]
		if var then return var end

		element = element.parent
	end

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

	local previous = self.variables[name]
	if previous then
		local previous = self.variables[name].node

		logger.printError("Previous declaration of " .. name)
		logger.putTrace(node)

		logger.putLines(true,
			logger.getSource(node), "new definition here",
			logger.getSource(previous), "old definition here"
		)

		error("An error occured", 0)
	end

	local var = {
		tag = kind,
		name = name,
		scope = self,
		const = kind ~= "arg",
		node = node,
	}
	self.variables[name] = var
	self.exported[name] = var
	return var
end

function Scope:import(name, var, node, export)
	if var == nil then error("var is nil", 2) end

	if node then logger.printDebug("Importing " .. name .. " into " .. logger.getSource(node).name) end

	if self.variables[name] then
		local current = var.node
		local previous = self.variables[name].node

		logger.printError("Previous declaration of " .. name)
		logger.putTrace(node)

		logger.putLines(true,
			logger.getSource(node), "imported here",
			logger.getSource(current), "new definition here",
			logger.getSource(previous), "old definition here"
		)

		error("An error occured", 0)
	end

	self.variables[name] = var
	if export then
		if node then logger.printDebug("Exporting " .. name .. " from " .. logger.getSource(node).name) end
		self.exported[name] = var
	end

	return var
end

return Scope
