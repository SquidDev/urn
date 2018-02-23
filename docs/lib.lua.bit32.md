---
title: lua/bit32
---
# lua/bit32
## `ashr`
*Native defined at lib/lua/bit32.lisp:1:1*

Returns the arithmetic right shift of `X` shifted right by `DISP`.
If `DISP` is greater than 0 and the leftmost bit is 1, the void gets
filled by 1, otherwise 0.

## `bit-and`
*Native defined at lib/lua/bit32.lisp:5:1*

Returns the bitwise `AND` of its arguments.

## `bit-extract`
*Native defined at lib/lua/bit32.lisp:15:1*

Returns the unsigned number formed by splicing the bits `FIELD` to
`FIELD` + `WIDTH` - 1 from `X`.
Bit 0 is the least significant bit, bit 31 the most.
The default for `WIDTH` is 1.

## `bit-not`
*Native defined at lib/lua/bit32.lisp:7:1*

Returns the bitwise `NOT` of `X`.

## `bit-or`
*Native defined at lib/lua/bit32.lisp:9:1*

Returns the bitwise `OR` of its arguments.

## `bit-replace`
*Native defined at lib/lua/bit32.lisp:20:1*

Returns `X` with the bits `FIELD` to `FIELD` + `WIDTH` - 1 replaced with
the unsigned number value of `V`.
Bit 0 is the least significant bit, bit 31 the most.
The default for `WIDTH` is 1.

## `bit-rotl`
*Native defined at lib/lua/bit32.lisp:25:1*

Returns `X` rotated left by `DISP`.

## `bit-rotr`
*Native defined at lib/lua/bit32.lisp:29:1*

Returns `X` rotated right by `DISP`.

## `bit-test`
*Native defined at lib/lua/bit32.lisp:11:1*

Returns true if the bitwise `AND` of its arguments is not 0.

## `bit-xor`
*Native defined at lib/lua/bit32.lisp:13:1*

Returns the bitwise `XOR` of its arguments.

## `shl`
*Native defined at lib/lua/bit32.lisp:27:1*

Returns `X` shifted left by `DISP`.

## `shr`
*Native defined at lib/lua/bit32.lisp:31:1*

Returns `X` shifted right by `DISP`.

