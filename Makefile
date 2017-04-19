LUA        ?= lua
LUA_FLAGS  ?=-O2
TEST_FLAGS ?=
OUT_DIR    ?= tacky
DOCS_DIR   ?= docs_tmp
PAGES_DIR  ?= docs
URN        ?= tacky/cli.lua
OBJS       :=                   \
	${OUT_DIR}/logger/init        \
	${OUT_DIR}/range              \
	${OUT_DIR}/traceback          \

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
all: ${OBJS} ${OUT_DIR}/cli

${OBJS}: ${OUT_DIR}/%: urn/%.lisp
	@mkdir -p $(shell dirname $@)
	${LUA} ${URN} $^ -o $@ ${LUA_FLAGS}

${OUT_DIR}/cli: urn/cli.lisp
	@mkdir -p $(shell dirname $@)
	${LUA} ${URN} $^ -o $@ ${LUA_FLAGS} --shebang --chmod

${TESTS}:
	$(eval TMP := $(shell mktemp -d))
	${LUA} ${URN} $(basename $@) --run -o ${TMP} -- ${TEST_FLAGS}
	@rm -rf ${TMP}.lisp ${TMP}.lua ${TMP}

docs:
	rm -rf ${DOCS_DIR}
	@mkdir -p ${DOCS_DIR}
	${LUA} ${URN} ${LIBS} --docs ${DOCS_DIR}

publish_docs: docs
	git checkout gh-pages
	rm -rf ${PAGES_DIR}
	mv ${DOCS_DIR} ${PAGES_DIR}
	git add ${PAGES_DIR}
	git commit -m "Update docs"
	git push origin gh-pages
	git checkout master
