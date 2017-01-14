LUA       ?= lua5.3
LUA_FLAGS ?=
OBJS      :=                 \
	tacky/logger               \
	tacky/parser               \
	tacky/analysis/visitor     \
	tacky/backend/lisp

ifeq (${TIME},1)
LUA_FLAGS += --time
endif

main: ${OBJS}

${OBJS}: tacky/%: urn/%.lisp
	${LUA} run.lua $^ -o $@ ${LUA_FLAGS}
