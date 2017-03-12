---
title: lib/match
---
# lib/match
`A` pattern matching library.
Utilities for manipulating deeply-nested data and lists in general,
as well as binding multiple values.

The grammar of patterns is described below:
```
pattern ::= literal
          | metavar
          | _
          | ( -> expr pattern ) ;; view
          | ( as pattern metavar ) ;; as
          | ( pattern * ) ;; list
          | ( pattern + . pattern ) ;; list+rest
literal ::= int | string | boolean | symbol
metavar ::= '?' symbol
```

`A` literal pattern matches only if the scrutinee (what's being matched)
compares [`eq?`](lib.type.md#eq-x-y) to the literal.

Both metavariable patterns and the wildcard, `_`, match anything. However,
a metavariable will bind the result of matching to that symbol. For example,

```
(destructuring-bind [x 1]
  (print! x))
```
Results in `1` being printed to standard output, seeing as it is bound to
`x`.

List patterns and _list with rest_ patterns match lists. `A` list pattern will
match every element in a list, while a cons pattern will only match a certain
number of cars and the cdr.
Both bind everything bound by their "inner" patterns.

## `(case val &pts)`
*Macro defined at lib/match.lisp:172:1*

Match a single value against a series of patterns, evaluating the first
body that matches, much like `cond`.

## `(destructuring-bind pt &body)`
*Macro defined at lib/match.lisp:156:1*

Match a single pattern against a single value, then evaluate the `BODY`.
The pattern is given as `(car PT)` and the value as `(cadr PT)`.
If the pattern does not match, an error is thrown.

## Undocumented symbols
 - `(pattern-length pattern correction)` *Defined at lib/match.lisp:64:1*
