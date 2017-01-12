local writer = require "tacky.backend.writer"

local backends = { "lisp", "lua" }

local function wrap(func)
	return function(node, ...)
		local writer = writer()
		func(node, writer, ...)
		return writer.toString()
	end
end

local function buildBackend(module)
	return {
		expression = wrap(module.expression),
		block = wrap(module.block),
		backend = module,
	}
end

local out = {}
for i = 1, #backends do
	local backend = backends[i]
	out[backend] = buildBackend(require("tacky.backend." .. backend))
end

return out
