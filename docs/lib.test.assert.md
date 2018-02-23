---
title: test/assert
---
# test/assert
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

