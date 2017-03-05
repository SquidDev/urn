---
title: lib/match
---
# lib/match
A pattern matching library.
Utilities for manipulating deeply-nested data and lists in general,
as well as binding multiple values.

The grammar of patterns is described below:
```
pattern ::= literal
          | symbol
          | _
          | ( pattern * ) ;; list
          | ( pattern . pattern ) ;; cons
```

A literal pattern matches only if the scrutinee (what's being matched)
compares [[eq?]] to the literal.

Both symbol patterns and the wildcard, `_`, match anything. However, a
symbol will bind the result of matching to that symbol. For example,

```
(destructuring-bind [x 1]
  (print! x))
```
Results in `1` being printed to standard output, seeing as it is bound to
`x`.

List patterns and cons patterns match lists. A list pattern will match every
element in a list, while a cons pattern will only match the car and the cdr.
Both bind everything bound by their "inner" patterns.
## `(case val &pts)`
*Macro defined at lib/match.lisp:108:1*

Match a single value against a series of patterns, evaluating the first
body that matches, much like `cond`.

## `(destructuring-bind pt &body)`
*Macro defined at lib/match.lisp:98:1*

Match a single pattern against a single value, then evaluate the `BODY`.
The pattern is given as `(car PT)` and the value as `(cadr PT)`.
If the pattern does not match, an error is thrown.

