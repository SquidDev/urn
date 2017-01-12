main: tacky/logger.lua tacky/parser.lua tacky/analysis/visitor.lua tacky/backend/lisp.lua


tacky/%.lua: urn/%.lisp
	lua5.3 run.lua $^ -o $@
