LUA       ?= lua5.3
LUA_FLAGS ?=
OUT_DIR   ?= tacky
OBJS      :=                    \
	${OUT_DIR}/logger             \
	${OUT_DIR}/parser             \
	${OUT_DIR}/analysis/optimise  \
	${OUT_DIR}/backend/init

TESTS     := $(shell find tests -type f)

ifeq (${TIME},1)
LUA_FLAGS += --time
endif

.PHONY: ${TESTS} all test compiler_test

compiler_test: all test
test: ${TESTS}
all: ${OBJS}

${OBJS}: ${OUT_DIR}/%: urn/%.lisp
	@mkdir -p $(shell dirname $@)
	${LUA} run.lua $^ -o $@ ${LUA_FLAGS}

${TESTS}:
	$(eval TMP := $(shell mktemp -d))
	${LUA} run.lua $(basename $@) --run -o ${TMP}
	@rm -rf ${TMP}.lisp ${TMP}.lua ${TMP} 
