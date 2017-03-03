LUA        ?= lua5.3
LUA_FLAGS  ?=
TEST_FLAGS ?=
OUT_DIR    ?= tacky
DOCS_DIR   ?= docs
OBJS       :=                    \
	${OUT_DIR}/analysis/optimise  \
	${OUT_DIR}/analysis/warning   \
	${OUT_DIR}/backend/init       \
	${OUT_DIR}/documentation      \
	${OUT_DIR}/logger             \
	${OUT_DIR}/parser

TESTS     := $(shell find tests -type f)
LIBS      := $(shell find lib -type f -name "*.lisp")

ifeq (${TIME},1)
LUA_FLAGS += --time
endif

ifeq (${QUIET},1)
TEST_FLAGS += --quiet
endif

.PHONY: ${TESTS} all test compiler_test docs

compiler_test: all test
test: ${TESTS}
all: ${OBJS}

${OBJS}: ${OUT_DIR}/%: urn/%.lisp
	@mkdir -p $(shell dirname $@)
	${LUA} run.lua --no-shebang $^ -o $@ ${LUA_FLAGS}

${TESTS}:
	$(eval TMP := $(shell mktemp -d))
	${LUA} run.lua $(basename $@) --run -o ${TMP} -- ${TEST_FLAGS}
	@rm -rf ${TMP}.lisp ${TMP}.lua ${TMP}

docs:
	@mkdir -p ${DOCS_DIR}
	${LUA} run.lua ${LIBS} --docs ${DOCS_DIR}

publish_docs: docs
	git checkout gh-pages
	git add docs
	git commit -m "Update docs"
	git push origin gh-pages
	git checkout master
