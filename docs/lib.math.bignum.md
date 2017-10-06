---
title: math/bignum
---
# math/bignum
## `absolute`
*Defined at lib/math/bignum.lisp:29:2*

Returns `A` if `A` is positive, otherwise inverts the sign and returns the positive version of `A`.

## `add`
*Defined at lib/math/bignum.lisp:35:2*

Returns `A` plus `B`.

## `bit-at`
*Defined at lib/math/bignum.lisp:187:2*

Returns the value of the bit (0 or 1) of `A` at position `BIT`. The `BIT` index starts at 1.

## `copy`
*Defined at lib/math/bignum.lisp:15:2*

Returns a deep copied clone of `A`.

## `divide`
*Defined at lib/math/bignum.lisp:115:2*

Returns `A` divided by `B`.

## `equals?`
*Defined at lib/math/bignum.lisp:246:2*

Returns true if `A` == `B`.

## `length`
*Defined at lib/math/bignum.lisp:194:2*

Returns the amount of numerical bits needed to contain `A`.

## `less-or-equal?`
*Defined at lib/math/bignum.lisp:278:2*

Returns true if `A` <= `B`.

## `less-than?`
*Defined at lib/math/bignum.lisp:255:2*

Returns true if `A` < `B`.

## `modulo`
*Defined at lib/math/bignum.lisp:125:2*

Returns the remainder of `A` divided by `B`.

## `multiply`
*Defined at lib/math/bignum.lisp:82:2*

Returns `A` multiplied by `B`.

## `negate`
*Defined at lib/math/bignum.lisp:23:2*

Returns `A` with the sign inverted.

## `new`
*Defined at lib/math/bignum.lisp:300:2*

Creates a new bignum from `A`.
`A` is optional and can be either a normal integer, or a string.
`A` string can begin with '0x' (hex), '0o' (octal), '0b' (binary),
otherwise it's parsed as a decimal value.

## `power`
*Defined at lib/math/bignum.lisp:135:2*

Returns `A` to the power of `B`.

## `shl`
*Defined at lib/math/bignum.lisp:164:2*

Returns `A` shifted left by `B`. `B` should be a normal integer, not of type bignum.

## `shl!`
*Defined at lib/math/bignum.lisp:152:2*

Shifts (modifies) `A` to the left by `B`. `B` should be a normal integer, not of type bignum.

## `shr`
*Defined at lib/math/bignum.lisp:181:2*

Returns `A` shifted right by `B`. `B` should be a normal integer, not of type bignum.

## `shr!`
*Defined at lib/math/bignum.lisp:170:2*

Shifts (modifies) `A` to the right by `B`. `B` should be a normal integer, not of type bignum.

## `subtract`
*Defined at lib/math/bignum.lisp:58:2*

Returns `A` minus `B`.

## `tostring`
*Defined at lib/math/bignum.lisp:202:2*

Converts the bignum `A` to a string. `FORMAT` is optional and can be either
'd' (decimal, default),
'x' (lowercase hex),
'`X`' (uppercase hex),
'o' (octal), or
'b' (binary).

