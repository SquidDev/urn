local writer = require "tacky.backend.writer"

local backends = { "lisp", "lua" }

local function wrap(func, lisp)
	if lisp then
		-- Hack to emulate urn's writer
		return function(node, ...)
			local writer = {
				out = { tag = "list", n = 0 },
				indent = 0,
				['tabs-pending'] = false,
			}
			func(node, writer, ...)
			return table.concat(writer.out)
		end
	end
	return function(node, ...)
		local writer = writer()
		func(node, writer, ...)
		return writer.toString()
	end
end

local function buildBackend(module, lisp)
	return {
		expression = wrap(module.expression, lisp),
		block = wrap(module.block, lisp),
		backend = module,
	}
end

local out = {}
for i = 1, #backends do
	local backend = backends[i]
	out[backend] = buildBackend(require("tacky.backend." .. backend), backend == "lisp")
end

return out
