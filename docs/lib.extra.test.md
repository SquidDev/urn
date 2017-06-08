---
title: extra/test
---
# extra/test
## `(assert! cnd msg)`
*Macro defined at lib/extra/assert.lisp:12:1*

Assert `CND` is true, otherwise failing with `MSG`

## `(can name &body)`
*Macro defined at lib/extra/test.lisp:58:1*

Create a test whose `BODY` asserts `NAME` can happen

## `(describe name &body)`
*Macro defined at lib/extra/test.lisp:62:1*

Create a group of tests, defined in `BODY`, which test `NAME`

## `(is name &body)`
*Macro defined at lib/extra/test.lisp:54:1*

Create a test whose `BODY` asserts `NAME` is true

## `(it name &body)`
*Macro defined at lib/extra/test.lisp:18:1*

Create a test `NAME` which executes all expressions and assertions in
`BODY`

## `(may name &body)`
*Macro defined at lib/extra/test.lisp:41:1*

Create a group of tests defined in `BODY` whose names take the form
`<prefix> may NAME, and <test_name>`

## `(pending name &body)`
*Macro defined at lib/extra/test.lisp:32:1*

Create a test `NAME` whose `BODY` will not be run.

This is primarily designed for assertions you know will fail and need
to be fixed, or features which have not been implemented yet

## `(will name &body)`
*Macro defined at lib/extra/test.lisp:46:1*

Create a test whose `BODY` asserts `NAME` will happen

## `(will-not name &body)`
*Macro defined at lib/extra/test.lisp:50:1*

Create a test whose `BODY` asserts `NAME` will not happen

