---
title: extra/bignum
---
# extra/bignum
## `(absolute a)`
*Defined at lib/extra/bignum.lisp:29:1*

Returns `A` if `A` is positive, otherwise inverts the sign and returns the positive version of `A`.

## `(add a b)`
*Defined at lib/extra/bignum.lisp:35:1*

Returns `A` plus `B`.

## `(bit-at a bit)`
*Defined at lib/extra/bignum.lisp:187:1*

Returns the value of the bit (0 or 1) of `A` at position `BIT`. The `BIT` index starts at 1.

## `(copy a)`
*Defined at lib/extra/bignum.lisp:15:1*

Returns a deep copied clone of `A`.

## `(divide a b)`
*Defined at lib/extra/bignum.lisp:115:1*

Returns `A` divided by `B`.

## `(equals? a b)`
*Defined at lib/extra/bignum.lisp:246:1*

Returns true if `A` == `B`.

## `(length a)`
*Defined at lib/extra/bignum.lisp:194:1*

Returns the amount of numerical bits needed to contain `A`.

## `(less-or-equal? a b)`
*Defined at lib/extra/bignum.lisp:278:1*

Returns true if `A` <= `B`.

## `(less-than? a b)`
*Defined at lib/extra/bignum.lisp:255:1*

Returns true if `A` < `B`.

## `(modulo a b)`
*Defined at lib/extra/bignum.lisp:125:1*

Returns the remainder of `A` divided by `B`.

## `(multiply a b)`
*Defined at lib/extra/bignum.lisp:82:1*

Returns `A` multiplied by `B`.

## `(negate a)`
*Defined at lib/extra/bignum.lisp:23:1*

Returns `A` with the sign inverted.

## `(new a)`
*Defined at lib/extra/bignum.lisp:300:1*

Creates a new bignum from `A`.
`A` is optional and can be either a normal integer, or a string.
`A` string can begin with '0x' (hex), '0o' (octal), '0b' (binary),
otherwise it's parsed as a decimal value.

## `(power a b)`
*Defined at lib/extra/bignum.lisp:135:1*

Returns `A` to the power of `B`.

## `(shl a b)`
*Defined at lib/extra/bignum.lisp:164:1*

Returns `A` shifted left by `B`. `B` should be a normal integer, not of type bignum.

## `(shl! a b)`
*Defined at lib/extra/bignum.lisp:152:1*

Shifts (modifies) `A` to the left by `B`. `B` should be a normal integer, not of type bignum.

## `(shr a b)`
*Defined at lib/extra/bignum.lisp:181:1*

Returns `A` shifted right by `B`. `B` should be a normal integer, not of type bignum.

## `(shr! a b)`
*Defined at lib/extra/bignum.lisp:170:1*

Shifts (modifies) `A` to the right by `B`. `B` should be a normal integer, not of type bignum.

## `(subtract a b)`
*Defined at lib/extra/bignum.lisp:58:1*

Returns `A` minus `B`.

## `(tostring a format)`
*Defined at lib/extra/bignum.lisp:202:1*

Converts the bignum `A` to a string. `FORMAT` is optional and can be either
'd' (decimal, default),
'x' (lowercase hex),
'`X`' (uppercase hex),
'o' (octal), or
'b' (binary).

