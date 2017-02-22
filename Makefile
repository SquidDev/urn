LUA        ?= lua5.3
LUA_FLAGS  ?=
TEST_FLAGS ?=
OUT_DIR    ?= tacky
OBJS       :=                    \
	${OUT_DIR}/analysis/optimise  \
	${OUT_DIR}/backend/init       \
	${OUT_DIR}/documentation      \
	${OUT_DIR}/logger             \
	${OUT_DIR}/parser

TESTS     := $(shell find tests -type f)

ifeq (${TIME},1)
LUA_FLAGS += --time
endif

ifeq (${QUIET},1)
TEST_FLAGS += --quiet
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
	${LUA} run.lua $(basename $@) --run -o ${TMP} -- ${TEST_FLAGS}
	@rm -rf ${TMP}.lisp ${TMP}.lua ${TMP}
