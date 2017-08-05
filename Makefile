LUA        ?= lua
LUA_FLAGS  ?=-O2
TEST_FLAGS ?=
OUT_DIR    ?= bin
DOCS_DIR   ?= docs_tmp
PAGES_DIR  ?= docs
URN        ?= ${LUA} bin/urn.lua

LIBS       := $(shell find lib -type f -name "*.lisp")
MAIN_TESTS := $(shell find tests -type f -name '*.lisp' ! -name '*-helpers.lisp')
DOC_TESTS  := $(LIBS:lib/%.lisp=test_%)

ifeq (${TIME},1)
LUA_FLAGS += --time
TEST_FLAGS += --time
endif

ifeq (${QUIET},1)
TEST_FLAGS += --quiet
endif

.PHONY: ${MAIN_TESTS} ${DOC_TESTS} all test compiler_test docs tasks

all: ${OUT_DIR}/urn
compiler_test: all test
test: ${MAIN_TESTS} ${DOC_TESTS}

${OBJS}: ${OUT_DIR}/%: urn/%.lisp
	@mkdir -p $(shell dirname $@)
	${URN} $^ -o $@ ${LUA_FLAGS}

${OUT_DIR}/urn: urn/cli.lisp
	@mkdir -p $(shell dirname $@)
	${URN} $^ -o $@ ${LUA_FLAGS} --shebang --chmod

${MAIN_TESTS}:
	$(eval TMP := $(shell mktemp -d))
	${URN} $(basename $@) --run -o ${TMP} -- ${TEST_FLAGS}
	@rm -rf ${TMP}.lisp ${TMP}.lua ${TMP}

${DOC_TESTS}:
	$(eval TMP := $(shell mktemp -d))
	${URN} plugins/doc-test --run -o ${TMP} -- ${TEST_FLAGS} $(@:test_%=%)
	@rm -rf ${TMP}.lisp ${TMP}.lua ${TMP}

docs:
	rm -rf ${DOCS_DIR}
	@mkdir -p ${DOCS_DIR}
	${URN} ${LIBS} --docs ${DOCS_DIR}

publish_docs: docs
	git checkout gh-pages
	rm -rf ${PAGES_DIR}
	mv ${DOCS_DIR} ${PAGES_DIR}
	bundler exec jekyll build
	git add ${PAGES_DIR}
	git commit -m "Update docs"
	git push origin gh-pages
	git checkout master

tasks:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'
