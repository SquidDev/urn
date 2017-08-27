---
title: match
---
# match
`A` pattern matching library.

Utilities for manipulating deeply-nested data and lists in general, as
well as binding multiple values.

## Literal patterns
`A` literal pattern matches only if the scrutinee (what's being matched)
compares [`eql?`](lib.type.md#eql-x-y) to the literal. One can use any Urn atom here:
strings, numbers, keys and symbols.

Note that the `true`, `false` and `nil` symbols will match against their
*values*, whilst other symbols will match against a symbol object.

### Example
```cl
> (with (x 1)
.   (case x
.     [1 "Is 1!"]
.     [2 "Is 2!"]))
"Is 1!"
```

### Wildcards and captures
If one does not require a value to take a particular form, you can use a
wildcard (`_` or `else`). This will match anything, discarding its value. This
is often useful as the last expression in a [`case`](lib.match.md#case-val-pts), where you need to
handle any remaining forms.

If you wish to use this value, you should use a capture, or
metavariable. This is a symbol prefixed with `?`. This will declare a
variable of the same name (though without the `?`), bound to the
captured value.

```cl
> (with (x 3)
.   (case x
.     [1 "Is 1!"]
.     [2 "Is 2!"]
.     [?y $"Is ~{y}"]))
"Is 3"
```

In the above example, neither of the first two arms match, so the value
of `x` is bound to the `y` variable and the arm's body executed.

One can also match against the captured value by using the `@`
form. This is a list which takes a pattern, the `@` symbol and then a
metavariable. It will attempt to match the value against the provided
pattern and, if it matches, bind it to the given variable.

```cl
> (with (x 3)
.   (case x
.     [1 "Is 1!"]
.     [2 "Is 2!"]
.     [(_ @ ?y) $"Is ~{y}"]))
"Is 3"
```

This example is equivalent to the previous one, as the wildcard will
match anything. You can of course use a more complex pattern there.

## List patterns
List patterns and _list with rest_, patterns match lists.

`A` list pattern requires a value to be a list of a specific length,
matching each element in the list with its corresponding pattern in the
list pattern.

List with rest patterns, or cons patterns, require a value to be at
least the given length, bundling all remaining values into a separate
list and matching that against a new pattern.

Both these patterns allow variables to be bound by their "inner"
patterns, allowing one to build up complex expressions.

```cl
> (with (x '(1 2 (3 4 5)))
.   (case x
.     ;; Matching against a fixed list
.     [() "Got an empty list"]
.     [(?a ?b) $"Got a pair ~{a} ~{b}"]
.     ;; Using cons patterns, and capturing inside nested patterns
.     [(?a ?b (?c . ?d)) $"Got a triplet with ~{d}"])
"Got a triplet with (4 5)"
```

## Struct patterns
Not dissimilar to list patterns, struct patterns allow you do match
against an arbitrary struct. However, the struct pattern only checks for
the presence of keys, and does not verify no additional keys are
present.

```cl
> (with (x { :x 1 :y '(1 2 3) })
.   (case x
.     [{ :x 1 :y 1 } "A struct of 1, 1"]
.     [{ :x 1 :y (1 2 ?x) } x]))
3
```

## Additional expressions in patterns
Sometimes the built-in patterns are not enough and you need a little bit
more power. Thankfully, one can use any expression in patterns in several
forms: predicates, guards and views.

### Predicates and guards
Predicates are formed by a symbol ending in a `?`. This symbol is looked
up in the current scope and called with the value to be matched. If it
returns a truthy value, then the pattern is considered to be matched.

Guards are not dissimilar to predicates. They match a pattern against a
value, bind the patterns metavariables and evaluate the expression, only
succeeding if the expression evaluates to a truthy value.

```cl
> (with (x "foo")
.   (case x
.     [(string? @ ?x) x]
.     [?x (pretty x])))
"foo"

> (with (x "foo")
.   (case x
.     [(?x :when (string? ?x)) x]
.     [?x (pretty x)]))
"foo"
```

Note that the above expressions have the same functionality. Predicates
are generally more concise, whilst guards are more powerful.

### Views

Views are a way of implementing your own quasi-patterns. Simply put,
they call an expression with the required value and match the returned
value against a pattern.

```cl
> ;; Declare a helper method for matching strings.
> (defun matcher (ptrn)
.    "Create a function which matches its input against PTRN, returning
.      `nil` or a list of captured groups."
.    (lambda (str)
.      (case (string/match str ptrn)
.        [(nil) nil]
.        [?x x])))

> (with (x "0x23")
.   (case x
.     [((matcher "0x(%d+)") -> ?x) x]))
"23"
```

You can see the view pattern in use on the last line: we create the view
with `(matcher "0x(%d+)")`, apply it to `x` and then match the
returned value (`("23")`) against the `?x` pattern.

## `(case val &pts)`
*Macro defined at lib/match.lisp:397:1*

Match a single value against a series of patterns, evaluating the
first body that matches, much like `cond`.

## `(destructuring-bind pt &body)`
*Macro defined at lib/match.lisp:380:1*

Match a single pattern against a single value, then evaluate the `BODY`.

The pattern is given as `(car PT)` and the value as `(cadr PT)`.  If
the pattern does not match, an error is thrown.

## `(function &arms)`
*Macro defined at lib/match.lisp:454:1*

Create a lambda which matches its arguments against the patterns
defined in `ARMS`.

## `(handler-case x &body)`
*Macro defined at lib/match.lisp:421:1*

Evaluate the form `X`, and if an error happened, match the series
of `(?pattern (?arg) . ?body)` arms given in `BODY` against the value of
the error, executing the first that succeeeds.

In the case that `X` does not throw an error, the value of that
expression is returned by [`handler-case`](lib.match.md#handler-case-x-body).

### Example:

```cl
> (handler-case
.   (fail! "oh no!")
.   [string? (x)
.    (print! x)])
oh no!
out = nil
```

## `(if-match cs t e)`
*Macro defined at lib/match.lisp:469:1*

Matches a pattern against a value defined in `CS`, evaluating `T` with the
captured variables in scope if the pattern succeeded, otherwise
evaluating `E`.

[`if-match`](lib.match.md#if-match-cs-t-e) is to [`case`](lib.match.md#case-val-pts) what [`if`](lib.base.md#if-c-t-b) is to `cond`.

## `(matches? pt x)`
*Macro defined at lib/match.lisp:411:1*

Test if the value `X` matches the pattern `PT`.

Note that, since this does not bind anything, all metavariables may be
replaced by `_` with no loss of meaning.

