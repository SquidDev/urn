---
title: math/rational
---
# math/rational
## `(->float y)`
*Defined at lib/math/rational.lisp:57:2*

Convert the rational number `Y` to a floating-point number.

### Example:
```cl
> (->float (rational 3 2))
out = 1.5
```

## `(->rat y)`
*Defined at lib/math/rational.lisp:44:2*

Convert the floating-point number `Y` to a rational number.

### Example:
```cl
> (->rat 3.14)
out = 157/50
> (/ 157 50)
out = 3.14
```

## `(denominator rational)`
*Defined at lib/math/rational.lisp:7:2*

The rational's denumerator

## `(numerator rational)`
*Defined at lib/math/rational.lisp:7:2*

The rational's numerator

## `rational`
*Defined at lib/math/rational.lisp:7:2*

`A` rational number, represented as a tuple of numerator and denominator.

## Undocumented symbols
 - `$rational` *Defined at lib/math/rational.lisp:7:2*
 - `(rational? rational)` *Defined at lib/math/rational.lisp:7:2*
