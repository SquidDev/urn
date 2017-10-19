---
title: math
---
# math
## `(dec! x)`
*Macro defined at lib/math/init.lisp:83:2*

Decrements the symbol `X` by 1.

### Example
```cl
> (with (x 1)
.   (dec! x)
.   x)
out = 0
```

## `(even? x)`
*Defined at lib/math/init.lisp:27:2*

Is `X` an even number?

### Example
```cl
> (even? 2)
out = true
> (even? 1)
out = false
```

## `(gcd x y)`
*Defined at lib/math/init.lisp:3:2*

Compute the greatest common divisor of `X` and `Y`.

### Example
```cl
> (gcd 52 32)
out = 4
```

## `(inc! x)`
*Macro defined at lib/math/init.lisp:71:2*

Increments the symbol `X` by 1.

### Example
```cl
> (with (x 1)
.   (inc! x)
.   x)
out = 2
```

## `(lcm x y)`
*Defined at lib/math/init.lisp:16:2*

Compute the lowest common multiple of `X` and `Y`.

### Example
```cl
> (lcm 52 32)
out = 416
```

## `(nan? x)`
*Defined at lib/math/init.lisp:51:2*

Is `X` equal to NaN?

### Example
```cl
> (nan? (/ 0 0))
out = true
> (nan? 1)
out = false
```

## `(odd? x)`
*Defined at lib/math/init.lisp:39:2*

Is `X` an odd number?

### Example
```cl
> (odd? 1)
out = true
> (odd? 2)
out = false
```

## `(pred x)`
*Defined at lib/math/init.lisp:67:2*

Return the predecessor of the number `X`.

## `(round x)`
*Defined at lib/math/init.lisp:96:2*

Round `X`, to the nearest integer.

### Example:
```cl
> (round 1.5)
out = 2
> (round 1.3)
out = 1
> (round -1.3)
out = -1
```

## `(succ x)`
*Defined at lib/math/init.lisp:63:2*

Return the successor of the number `X`.

