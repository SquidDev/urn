--- Builds a set of files and runs tests
-- Well, it would if I had tests.

local function compile(name)
	print("Compiling " .. name)
	local ok, _, code = os.execute("lua5.3 run.lua urn/" .. name .. ".lisp -o tacky/" .. name)
	if not ok then os.exit(code) end
end

compile "logger"
compile "parser"
compile "analysis/visitor"
