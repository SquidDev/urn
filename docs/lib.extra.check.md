---
title: extra/check
---
# extra/check
`A` checker for algebraic properties.

## `(=:= f g x)`
*Macro defined at lib/extra/check.lisp:137:1*

Express that the functions `F` and `G` are equivalent at the point `X`.

Example:
```cl
> (check [(number a)]
.   (=:= id (compose id id) a))
out = true
```

## `(check bindings &props)`
*Macro defined at lib/extra/check.lisp:52:1*

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

## `(forall var prop)`
*Macro defined at lib/extra/check.lisp:150:1*

Check that `PROP` holds across all possible points. This is a
restricted version of [`check`](lib.extra.check.md#check-bindings-props) that does not allow specifying
several variables.

`VAR` may be either a single, in which case it is interpreted as
being a variable name, or a list with a type and the variable
name.
Example:
```cl
> (forall a (eq? a (id a)))
out = true
```

## `(tripping f g x)`
*Macro defined at lib/extra/check.lisp:118:1*

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

