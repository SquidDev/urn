---
title: compiler/optimise
---
# compiler/optimise
## `fusion/add-rule!`
*Native defined at lib/compiler/optimise.lisp:21:1*

Register a new fusion rule.

## `(fusion/defrule from to)`
*Macro defined at lib/compiler/optimise.lisp:23:1*

Define a rewrite rule which maps `FROM` to `TO`.

## `(fusion/patternquote ptrn)`
*Macro defined at lib/compiler/optimise.lisp:17:1*

Quote pattern `PTRN`, automatically escaping variables which start with `?` or `%`.

