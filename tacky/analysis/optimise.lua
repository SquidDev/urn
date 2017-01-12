local builtins = require "tacky.analysis.resolve".builtins
local visitor = require "tacky.analysis.visitor"
local logger = require "tacky.logger"

--- Checks if a node has side effects
local function hasSideEffects(node)
	local kind = node.tag
	if kind == "number" or kind == "boolean" or kind == "string" or node.tag == "key" or kind == "symbol" then
		-- Do nothing: this is a constant term after all
		return false
	elseif kind == "list" then
		local first = node[1]
		if first and first.tag == "symbol" then
			local func = first.var
			return func ~= builtins["lambda"] and func ~= builtins["quote"]
		else
			return true
		end
	else
		error("Unknown type " .. tostring(kind))
	end
end

--- Checks if a node is a constant
local function isConstant(node)
	local kind = node.tag
	return kind == "number" or kind == "boolean" or kind == "string" or node.tag == "key"
end

local function getVarEntry(varLookup, var)
	local varEntry = varLookup[var]
	if not varEntry then
		varEntry = {
			var = var,
			usages = {},
			defs = {},

			active = false,
		}
		varLookup[var] = varEntry
	end

	return varEntry
end

--- Gather all definitions into the variable lookup
local function gatherDefinitions(nodes, varLookup)
	varLookup = varLookup or {}

	local function addDefinition(var, def)
		local defs = getVarEntry(varLookup, var).defs
		defs[#defs + 1] = def
	end

	visitor.visitBlock(nodes, 1, function(node)
		if node.tag ~= "list" then return end

		local first = node[1]
		if not first or first.tag ~= "symbol" then return end

		local func = first.var
		if func == builtins["lambda"] then
			for i = 1, node[2].n do
				addDefinition(node[2][i].var, {
					tag = "arg",
					value = node[2][i],
					node = node,
				})
			end
		elseif func == builtins["set!"] then
			addDefinition(node[2].var, {
				tag = "set",
				value = node[3],
				node = node,
			})
		elseif func == builtins["define"] or func == builtins["define-macro"] then
			addDefinition(node.defVar, {
				tag = "define",
				value = node[3],
				node = node,
			})
		elseif func == builtins["define-native"] then
			addDefinition(node.defVar, {
				tag = "native",
				node = node,
			})
		end
	end)

	return varLookup
end

--- Build a lookup of usages. Note, this will only visit "active" nodes: those
-- which have a side effect or are used somewhere else.
local function gatherUsages(nodes, varLookup)
	local queue = {}
	local function addUsage(var, user)
		local varEntry = varLookup[var]

		if varEntry == nil then return end

		-- If never seen before then enqueue all definitions
		if not varEntry.active then
			varEntry.active = true

			for i = 1, #varEntry.defs do
				local defVal = varEntry.defs[i].value
				if defVal then
					queue[#queue + 1] = defVal
				end
			end
		end

		local usages = varEntry.usages
		usages[#usages + 1] = usages
	end


	local function visit(node)
		if node.tag == "symbol" then
			addUsage(node.var, node)
			return
		elseif node.tag == "list" then
			local first = node[1]
			if not first or first.tag ~= "symbol" then return end

			local func = first.var
			if func == builtins["set!"] or func == builtins["define"] or func == builtins["define-macro"] then
				if not hasSideEffects(node[3]) then
					-- Skip the definition if it has no side effects
					return false
				else
					local varEntry = varLookup[node.var]
					-- varEntry may be nil for builtins
					if varEntry and varEntry.active then
					-- We've already visited this node so skip it
						return false
					end
				end
			end
		end
	end

	for i = 1, #nodes do
		local node = nodes[i]
		if hasSideEffects(node) then
			queue[#queue + 1] = node
		end
	end

	while #queue > 0 do
		local node = table.remove(queue, 1)
		visitor.visitNode(node, visit)
	end
end

return function(nodes)
	-- Strip all import expressions
	for i = #nodes, 1, -1 do
		local node = nodes[i]
		if node.tag == "list" then
			local first = node[1]
			if first and first.tag == "symbol" and first.var == builtins["import"] then
				table.remove(nodes, i)
			end
		end
	end


	local varLookup = {}
	gatherDefinitions(nodes, varLookup)
	gatherUsages(nodes, varLookup)

	for i = #nodes, 1, -1 do
		local node = nodes[i]
		if not hasSideEffects(node) or (node.defVar and not varLookup[node.defVar].active) then
			table.remove(nodes, i)
		end
	end

	return nodes
end
