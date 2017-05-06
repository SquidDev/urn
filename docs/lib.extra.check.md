---
title: extra/check
---
# extra/check
`A` checker for algebraic properties.

## `(check bindings &props)`
*Macro defined at lib/extra/check.lisp:52:1*

Check a set of properties against a set of random variables 100 times.
This can be used as a rudimentary algebraic property checker, where
`BINDINGS` is the list of universally-quantified variables and `PROPS` is
the list of properties you're checking.

### Example:
```
> (check [(number a)] \
.   (= a a))
(= a a) passed 100 tests.
nil
> (check [(number a)] \
.   (= a (+ 1 a)))
(= a (+ 1 a)) falsified after 1 iteration(s)
falsifying set of values:
  the number, a, had the value 3867638440
nil
```

The property is checked against a different set of random values every
iteration. This library has the ability to generate random numbers,
strings, symbols, booleans, keys and lists.

