---
title: math/bit32
---
# math/bit32
## `ashr`
*Defined at lib/math/bit32.lisp:50:2*

Returns the arithmetic right shift of `X` shifted right by `DISP`.
If `DISP` is greater than 0 and the leftmost bit is 1, the void gets
filled by 1, otherwise 0.

## `bit-and`
*Defined at lib/math/bit32.lisp:65:2*

Returns the bitwise `AND` of its arguments.

## `bit-extract`
*Defined at lib/math/bit32.lisp:91:2*

Returns the unsigned number formed by splicing the bits `FIELD` to
`FIELD` + `WIDTH` - 1 from `X`.
Bit 0 is the least significant bit, bit 31 the most.
The default for `WIDTH` is 1.

## `bit-not`
*Defined at lib/math/bit32.lisp:70:2*

Returns the bitwise `NOT` of `X`.

## `bit-or`
*Defined at lib/math/bit32.lisp:76:2*

Returns the bitwise `OR` of its arguments.

## `bit-replace`
*Defined at lib/math/bit32.lisp:100:2*

Returns `X` with the bits `FIELD` to `FIELD` + `WIDTH` - 1 replaced with
the unsigned number value of `V`.
Bit 0 is the least significant bit, bit 31 the most.
The default for `WIDTH` is 1.

## `bit-rotl`
*Defined at lib/math/bit32.lisp:112:2*

Returns `X` rotated left by `DISP`.

## `bit-rotr`
*Defined at lib/math/bit32.lisp:119:2*

Returns `X` rotated right by `DISP`.

## `bit-test`
*Defined at lib/math/bit32.lisp:81:2*

Returns true if the bitwise `AND` of its arguments is not 0.

## `bit-xor`
*Defined at lib/math/bit32.lisp:86:2*

Returns the bitwise `XOR` of its arguments.

## `shl`
*Defined at lib/math/bit32.lisp:124:2*

Returns `X` shifted left by `DISP`.

## `shr`
*Defined at lib/math/bit32.lisp:132:2*

Returns `X` shifted right by `DISP`.

## `(valid-u-32 n)`
*Defined at lib/math/bit32.lisp:30:2*

Returns whether the number `N` is a valid u32 integer.
`A` number is considered valid when it's an integer between 0 and 2^32-1.

