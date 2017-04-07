---
title: extra/test
---
# extra/test
## `(assert! cnd msg)`
*Macro defined at lib/extra/assert.lisp:12:1*

Assert `CND` is true, otherwise failing with `MSG`

## `(can name &body)`
*Macro defined at lib/extra/test.lisp:59:1*

Create a test whose `BODY` asserts `NAME` can happen

## `(describe name &body)`
*Macro defined at lib/extra/test.lisp:63:1*

Create a group of tests, defined in `BODY`, which test `NAME`

## `(is name &body)`
*Macro defined at lib/extra/test.lisp:55:1*

Create a test whose `BODY` asserts `NAME` is true

## `(it name &body)`
*Macro defined at lib/extra/test.lisp:19:1*

Create a test `NAME` which executes all expressions and assertions in
`BODY`

## `(may name &body)`
*Macro defined at lib/extra/test.lisp:42:1*

Create a group of tests defined in `BODY` whose names take the form
`<prefix> may NAME, and <test_name>`

## `(pending name &body)`
*Macro defined at lib/extra/test.lisp:33:1*

Create a test `NAME` whose `BODY` will not be run.

This is primarily designed for assertions you know will fail and need
to be fixed, or features which have not been implemented yet

## `(will name &body)`
*Macro defined at lib/extra/test.lisp:47:1*

Create a test whose `BODY` asserts `NAME` will happen

## `(will-not name &body)`
*Macro defined at lib/extra/test.lisp:51:1*

Create a test whose `BODY` asserts `NAME` will not happen

