---
title: test
---
# test
## `(=:= f g x)`
*Macro defined at lib/test/check.lisp:141:2*

Express that the functions `F` and `G` are equivalent at the point `X`.

Example:
```cl
> (check [(number a)]
.   (=:= id (compose id id) a))
out = true
```

## `(affirm &asserts)`
*Macro defined at lib/test/assert.lisp:8:2*

Assert each expression in `ASSERTS` evaluates to true

Each expression is expected to be a function call. Each argument is
evaluated and the final function executed. If it returns a falsey
value (nil or false) then each argument will be have it's value
printed out.

### Example
```cl
> (affirm (= (+ 2 3) (* 2 3)))
[ERROR] Assertion failed
(= (+ 2 3) (* 2 3))
   |       |
   |       6
   5
```

## `(assert! cnd msg)`
*Macro defined at lib/test/assert.lisp:3:2*

>**Warning:** assert! is deprecated: Use [`demand`](lib.core.demand.md#demand-condition-message) instead

Assert `CND` is true, otherwise failing with `MSG`

## `(can name &body)`
*Macro defined at lib/test/init.lisp:77:2*

Create a test whose `BODY` asserts `NAME` can happen

## `(cannot name &body)`
*Macro defined at lib/test/init.lisp:81:2*

Create a test whose `BODY` asserts `NAME` cannot happen

## `(check bindings &props)`
*Macro defined at lib/test/check.lisp:56:2*

Check a set of properties against a set of random variables 100 times.
This can be used as a rudimentary algebraic property checker, where
`BINDINGS` is the list of universally-quantified variables and `PROPS` is
the list of properties you're checking.

### Example:
```cl
> (check [(number a)]
.   (= a a))
out = true
> (check [(number a)]
.   (= a (+ 1 a)))
(= a (+ 1 a)) falsified after 1 iteration(s)
falsifying set of values:
  the number, a, had the value 3867638440
out = nil
```

The property is checked against a different set of random values every
iteration. This library has the ability to generate random numbers,
strings, symbols, booleans, keys and lists.

## `(describe name &body)`
*Macro defined at lib/test/init.lisp:85:2*

Create a group of tests, defined in `BODY`, which test `NAME`

## `(forall var prop)`
*Macro defined at lib/test/check.lisp:154:2*

Check that `PROP` holds across all possible points. This is a
restricted version of [`check`](lib.test.check.md#check-bindings-props) that does not allow specifying
several variables.

`VAR` may be either a single, in which case it is interpreted as
being a variable name, or a list with a type and the variable
name.
Example:
```cl
> (forall a (eq? a (id a)))
out = true
```

## `(is name &body)`
*Macro defined at lib/test/init.lisp:73:2*

Create a test whose `BODY` asserts `NAME` is true

## `(it name &body)`
*Macro defined at lib/test/init.lisp:32:2*

Create a test `NAME` which executes all expressions and assertions in
`BODY`

## `(may name &body)`
*Macro defined at lib/test/init.lisp:60:2*

Create a group of tests defined in `BODY` whose names take the form
`<prefix> may NAME, and <test_name>`

## `(pending name &body)`
*Macro defined at lib/test/init.lisp:46:2*

Create a test `NAME` whose `BODY` will not be run.

This is primarily designed for assertions you know will fail and need
to be fixed, or features which have not been implemented yet

## `(section name &body)`
*Macro defined at lib/test/init.lisp:55:2*

Create a group of tests defined in `BODY` whose names take the form
`<prefix> NAME <test_name>`

## `(tripping f g x)`
*Macro defined at lib/test/check.lisp:122:2*

Express that the composition of the functions `F` and `G` (in order!)
are equivalent to the identity, on the argument `X`.

As an example, consider a pair of encoding and decoding functions:
Decoding an encoded datum should be equivalent to the originally
encoded datum. Algebraically, we express this as
`(forall a (=:= (compose f g) id a))`.

Example:
```cl
> (check [(number a)]
.   (tripping tonumber tostring a))
out = true
```

## `(will name &body)`
*Macro defined at lib/test/init.lisp:65:2*

Create a test whose `BODY` asserts `NAME` will happen

## `(will-not name &body)`
*Macro defined at lib/test/init.lisp:69:2*

Create a test whose `BODY` asserts `NAME` will not happen

