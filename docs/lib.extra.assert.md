---
title: extra/assert
---
# extra/assert
## `(affirm &asserts)`
*Macro defined at lib/extra/assert.lisp:82:1*

Assert each expression in `ASSERTS` evaluates to true

Each expression is expected to be a function call. Each argument is
evaluated and the final function executed. If it returns a falsey
value (nil or false) then each argument will be have it's value
printed out.

### Example
```
> (affirm (= (+ 2 3) (* 2 3)))
[ERROR] Assertion failed
(= (+ 2 3) (* 2 3))
   |       |
   |       6
   5
```

## `(assert &assertions)`
*Macro defined at lib/extra/assert.lisp:16:1*

Assert each assertion in `ASSERTIONS` is true

Each assertion can take several forms:

 - `(= a b)`: Assert that `A` and `B` are equal, printing their values if
   not
 - `(/= a b)`: Assert that `A` and `B` are not equal, printing their
   values if they are
 - Type assertions of the form `(list? a)`: Assert that `A` is of the
   required type.

### Example
```
> (assert (= (+ 2 3) 4))
[ERROR] expected (+ 2 3) and 4 to be equal
> (assert (/= (+ 2 3) 5))
[ERROR] expected (+ 2 3) and 5 to be unequal
> (assert (string? 2))
[ERROR] expected 2 to be a string
```

## `(assert! cnd msg)`
*Macro defined at lib/extra/assert.lisp:12:1*

Assert `CND` is true, otherwise failing with `MSG`

