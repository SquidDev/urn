LUA       ?= lua5.3
LUA_FLAGS ?=
OUT_DIR   ?= tacky
OBJS      :=                    \
	${OUT_DIR}/logger             \
	${OUT_DIR}/parser             \
	${OUT_DIR}/analysis/optimise  \
	${OUT_DIR}/backend/init

ifeq (${TIME},1)
LUA_FLAGS += --time
endif

main: ${OBJS}

${OBJS}: ${OUT_DIR}/%: urn/%.lisp
	@mkdir -p $(shell dirname $@)
	${LUA} run.lua $^ -o $@ ${LUA_FLAGS}
