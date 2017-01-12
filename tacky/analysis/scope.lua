local logger = require "tacky.logger"

local Scope = {}
Scope.__index = Scope

function Scope.child(parent)
	local child = setmetatable({
		--- The parent scope.
		parent = parent,

		--- Lookup of named variables.
		variables = {},
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
	})
end

local kinds = { defined = true, macro = true, arg = true, builtin = true }

function Scope:add(name, kind, node)
	if name == nil then error("name is nil", 2) end
	if not kinds[kind] then error("unknown kind " .. tostring(kind), 2) end

	local previous = self.variables[name]
	if previous then
		logger.errorPositions(node, "Previous declaration of " .. name)
	end

	local var = {
		tag = kind,
		name = name,
		scope = self,
		const = kind ~= "arg",
		node = node,
	}
	self.variables[name] = var
	return var
end

function Scope:import(prefix, var, state, node)
	if var == nil then error("var is nil", 2) end

	local name = prefix and (prefix .. '/' .. var.name) or var.name

	if self.variables[name] then
		local current = state.states[var]
		local previous = state.states[self.variables[name]]

		logger.printError("Previous declaration of " .. name)
		logger.putTrace(node)

		logger.putLines(true,
			logger.getSource(node), "imported here",
			logger.getSource(current.node), "new definition here",
			logger.getSource(previous.node), "old definition here"
		)

		error("An error occured", 0)
	end

	self.variables[name] = var
	return var
end

return Scope
