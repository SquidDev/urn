local logger = require "tacky.logger.init"
local range = require "tacky.range"

local State = {}
State.__index = State

--- The state tracks a single node's resolution progress. Namely, it keeps note of:
--
-- - All variables this node "depends" on (will access when executed). Does not include syntax-quoted
--   variables.
-- - The variable this node declares.
-- - The final node once resolution is finished.
-- - The value of this node if it has been executed.
--
-- Further more, this also handles gathering all nested dependencies for this node to be executed and built,
-- detecting cycles in building (say two macros each require the other in order to be expanded).
function State.create(variables, states, scope, logger, mappings)
	if not variables then error("variables cannot be nil", 2) end
	if not states then error("states cannot be nil", 2) end
	if not scope then error("scope cannot be nil", 2) end
	if not logger then error("logger cannot be nil", 2) end
	if not mappings then error("mappings cannot be nil", 2) end

	local state = setmetatable({
		--- The scope this top level definition lives under
		scope = scope,

		--- Variable to state mapping
		states = states,

		-- Variable ID to variable mapping
		variables = variables,

		-- The logger instance
		logger = logger,

		-- The logger
		mappings = mappings,

		--- List of all required variables
		required = {},
		requiredSet = {},

		--- The current stage we are in.
		-- Transitions from parsed -> built -> executed
		stage = "parsed",

		--- The variable this node is defined as
		var = nil,

		--- The final node for this entry. This is set when building
		-- has finished.
		node = nil,

		--- The actual value of this node. This is set when this function
		-- is executed.
		value = nil,
	}, State)

	return state
end

function State:require(var, user)
	if self.stage ~= "parsed" then
		error("Cannot add requirement when in stage " .. self.stage, 2)
	end

	if var == nil then error("var is nil", 2) end
	if user == nil then error("user is nil", 2) end

	if var.scope.isRoot then
		local state = assert(self.states[var], "Variable's State is nil: it probably hasn't finished parsing: " .. var.name)
		if not self.requiredSet[state] then
			-- Ensures they are emitted in the same order
			self.requiredSet[state] = user
			self.required[#self.required + 1] = state
		end
		return state
	end
end

function State:define(var)
	if self.stage ~= "parsed" then
		error("Cannot add definition when in stage " .. self.stage, 2)
	end

	if var.scope ~= self.scope then return end

	if self.var then
		error("Cannot redeclare variable, already have: " .. self.var.name, 2)
	end

	self.var = var
	self.states[var] = self

	-- Also store this as the hash.
	self.variables[tostring(var)] = var
end

function State:built(node)
	if not node then error("node cannot be nil", 2) end

	if self.stage ~= "parsed" then
		error("Cannot transition from " .. self.stage .. " to built", 2)
	end

	self.stage = "built"
	self.node = node

	if node.defVar ~= self.var then
		logger.putError(self.logger, "Variables are different for " .. self.var.name)
	end
end

function State:executed(value)
	if self.stage ~= "built" then
		error("Cannot transition from " .. self.stage .. " to executed", 2)
	end

	self.stage = "executed"
	self.value = value
end

function State:get()
	if self.stage == "executed" then
		return self.value
	end

	local required, requiredList = {}, {}

	--- We walk the tree of all nodes, marking them as required
	-- but also detecting loops in definitions.
	-- This could probably be optimised so we don't walk the same tree multiple
	-- times.
	local function visit(state, stack, stackHash)
		local idx = stackHash[state]
		if idx then
			if state.var.tag ~= "macro" then
				return
			end

			-- Push to the stack anyway, we'll want to dump
			stack[#stack + 1] = state

			local states = {}
			local nodes = {}
			local firstNode
			for i = idx, #stack do
				local current, previous = stack[i], stack[i - 1]
				states[#states + 1] = current.var.name
				if previous then
					local node = previous.requiredSet[current]
					if not firstNode then firstNode = node end

					nodes[#nodes + 1] = range.getSource(node)
					nodes[#nodes + 1] = current.var.name .. " used in " .. previous.var.name
				end
			end

			logger.doNodeError(self.logger,
				"Loop in macros: " .. table.concat(states, " -> "),
				firstNode, nil,
				unpack(nodes)
			)
		end

		idx = #stack + 1

		stack[idx] = state
		stackHash[state] = idx

		if not required[state] then
			-- Ensures they are emitted in the same order, not the correct one though.
			required[state] = true
			requiredList[#requiredList + 1] = state
		end

		local visited = {}

		-- Look for loops the first time round
		for _, inner in pairs(state.required) do
			visited[inner] = true
			visit(inner, stack, stackHash)
		end

		if state.stage ~= "built" and state.stage ~= "executed" then
			coroutine.yield({
				tag = "build",
				state = state,
			})
		end

		-- Add remaining dependencies now
		for _, inner in pairs(state.required) do
			if not visited[inner] then
				visit(inner, stack, stackHash)
			end
		end

		stack[idx] = nil
		stackHash[state] = nil
	end

	visit(self, {}, {})

	coroutine.yield({
		tag    = "execute",
		states = requiredList,
	})

	return self.value
end

return State
