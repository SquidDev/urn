---
title: compiler/pattern
---
# compiler/pattern
## `(match ptrn expr)`
*Defined at lib/compiler/pattern.lisp:101:2*

Determine whether `EXPR` matches the provided pattern `PTRN`, returning
nil or a lookup of capture names to captured expressions.

## `(matcher ptrn)`
*Macro defined at lib/compiler/pattern.lisp:111:2*

Create a matcher for the given pattern literal `PTRN`.

This is intended for views [`case`](lib.core.match.md#case-val-pts) expressions.

## `(matches? ptrn expr)`
*Defined at lib/compiler/pattern.lisp:107:2*

Determine whether `EXPR` matches the provided pattern `PTRN`.

## `(pattern ptrn)`
*Macro defined at lib/compiler/pattern.lisp:38:2*

Quote the provided pattern `PTRN`, suitable for matching with i
[`matches?`](lib.compiler.pattern.md#matches-ptrn-expr).

This provides several "magic" symbol prefixes to aid matching:

 - `?` marks a metavar, and will be captured. If the second character
   is `&`, then this will capture zero or more values.

 - `%` marks a genvar, which will result in a randomly generated
   symbol being used in substitutions.

 - `$` marks a fullvar, where one can provide the full name to a
   variable. Use of this is discouraged and should only be used if you
   really need to detect hidden symbols.

## Undocumented symbols
 - `(match-always ptrn expr)` *Defined at lib/compiler/pattern.lisp:118:2*
