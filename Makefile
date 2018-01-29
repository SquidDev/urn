LUA        ?= lua
LUA_FLAGS  ?=-O2 --plugin plugins/fold-defgeneric.lisp --plugin plugins/fold-bool.lisp
TEST_FLAGS ?=-fstrict
TEST_ARGS  ?=
OUT_DIR    ?= bin
DOCS_DIR   ?= docs_tmp
PAGES_DIR  ?= docs
ROCKS_DIR  ?= rock
URN        ?= ${LUA} bin/urn.lua

LIBS       := $(shell find lib -type f -name "*.lisp")
MAIN_TESTS := $(shell find tests -type f -name '*.lisp' ! -name '*-helpers.lisp')
DOC_TESTS  := $(LIBS:lib/%.lisp=test_%)

ifeq (${TIME},1)
LUA_FLAGS += --time
TEST_FLAGS += --time
endif

ifeq (${QUIET},1)
TEST_ARGS += --quiet
endif

.PHONY: all ${OUT_DIR}/urn.lua \
        test gen_coverage ${MAIN_TESTS} ${DOC_TESTS} \
        docs publish_docs \
        rock tasks

# Compilation of source code
all: ${OUT_DIR}/urn.lua

${OUT_DIR}/urn.lua: urn/cli.lisp
	@mkdir -p $(shell dirname $@)
	${URN} $^ -o $@ ${LUA_FLAGS} --shebang --chmod

# Unit tests
test: ${MAIN_TESTS} ${DOC_TESTS}

gen_coverage:
	${URN} $(shell find lib urn -type f -name "*.lisp") --gen-coverage

${MAIN_TESTS}:
	$(eval TMP := $(shell mktemp -d))
	${URN} $(basename $@) --run -o ${TMP} ${TEST_FLAGS} -- ${TEST_ARGS}
	@rm -rf ${TMP}.lisp ${TMP}.lua ${TMP}

${DOC_TESTS}:
	$(eval TMP := $(shell mktemp -d))
	${URN} plugins/doc-test --run -o ${TMP} ${TEST_FLAGS} -- ${TEST_ARGS} $(@:test_%=%)
	@rm -rf ${TMP}.lisp ${TMP}.lua ${TMP}

# Documentation generation
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

# Miscellaneous
rock: all docs
	rm -rf ${ROCKS_DIR}
	@mkdir ${ROCKS_DIR}

	cp -r ${DOCS_DIR} ${ROCKS_DIR}/docs
	cp -r bin ${ROCKS_DIR}
	cp -r lib ${ROCKS_DIR}/urn-lib
	cp -r plugins ${ROCKS_DIR}
	cp -r tests ${ROCKS_DIR}
	cp urn-scm-1.rockspec ${ROCKS_DIR}

	rm -r ${ROCKS_DIR}/tests/data

tasks:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'
