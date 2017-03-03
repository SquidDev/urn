---
title: lib/base
---
# lib/base
## `(! expr)`
*Defined at lib/base.lisp:80:1*

Negate the expresison `EXPR`.

## `(# x)`
*Defined at lib/lua/basic.lisp:50:1*

Get the length of list X

## `(and a b &rest)`
*Macro defined at lib/base.lisp:131:1*

Return the logical and of values `A` and `B`, and, if present, the
logical and of all the values in `REST`.

## `arg`
*Defined at lib/base.lisp:169:1*

The arguments passed to the currently executing program

## `(cons x xs)`
*Defined at lib/base.lisp:53:1*

Add `X` to the start of the list `XS`. Note: this is linear in time.

## `(const-val val)`
*Defined at lib/base.lisp:181:1*

Get the actual value of `VAL`, an argument to a macro.

Due to how macros are implemented, all values are wrapped as tables
in order to preserve positional data about nodes. You will need to
unwrap them in order to use them.

## `(debug x)`
*Defined at lib/base.lisp:143:1*

Print the value `X`, then return it unmodified.

## `(defmacro name args &body)`
*Macro defined at lib/base.lisp:40:1*

Define `NAME` to be the macro given by (lambda `ARGS` @`BODY`), with
optional metadata at the start of `BODY`.

## `(defun name args &body)`
*Macro defined at lib/base.lisp:34:1*

Define `NAME` to be the function given by (lambda `ARGS` @`BODY`), with
optional metadata at the start of `BODY`.

## `(for ctr start end step &body)`
*Macro defined at lib/base.lisp:97:1*

Iterate `BODY`, with the counter `CTR` bound to `START`, being incremented
by `STEP` every iteration until `CTR` is outside of the range given by
[`START` .. `END`]

## `gensym`
*Defined at lib/base.lisp:84:1*

Create a unique symbol, suitable for using in macros

## `(if c t b)`
*Macro defined at lib/base.lisp:61:1*

Evaluate `T` if `C` is true, otherwise, evaluate `B`.

## `(list &xs)`
*Defined at lib/base.lisp:49:1*

Return the list of variadic arguments given.

## `(or a b &rest)`
*Macro defined at lib/base.lisp:137:1*

Return the logical or of values `A` and `B`, and, if present, the
logical or of all the values in `REST`.

## `(pretty value)`
*Defined at lib/base.lisp:147:1*

Format `VALUE` as a valid Lisp expression which can be parsed.

## `(progn &body)`
*Macro defined at lib/base.lisp:57:1*

Group a series of expressions together.

## `slice`
*Native defined at lib/lua/basic.lisp:20:1*

Take a slice of `XS`, with all values at indexes between `START` and `FINISH` (or the last
entry of `XS` if not specified).

## `(unless c &body)`
*Macro defined at lib/base.lisp:69:1*

Evaluate `BODY` if `C` is false, otherwise, evaluate `nil`.

## `(when c &body)`
*Macro defined at lib/base.lisp:65:1*

Evaluate `BODY` when `C` is true, otherwise, evaluate `nil`.

## `(while check &body)`
*Macro defined at lib/base.lisp:116:1*

Iterate `BODY` while the expression `CHECK` evaluates to `true`.

## `(with var &body)`
*Macro defined at lib/base.lisp:127:1*

Bind the single variable `VAR`, then evaluate `BODY`.

## Undocumented symbols
 - `%` *Native defined at lib/lua/basic.lisp:12:1*
 - `*` *Native defined at lib/lua/basic.lisp:10:1*
 - `+` *Native defined at lib/lua/basic.lisp:8:1*
 - `-` *Native defined at lib/lua/basic.lisp:9:1*
 - `/` *Native defined at lib/lua/basic.lisp:11:1*
 - `/=` *Native defined at lib/lua/basic.lisp:2:1*
 - `<` *Native defined at lib/lua/basic.lisp:3:1*
 - `<=` *Native defined at lib/lua/basic.lisp:4:1*
 - `=` *Native defined at lib/lua/basic.lisp:1:1*
 - `>` *Native defined at lib/lua/basic.lisp:5:1*
 - `>=` *Native defined at lib/lua/basic.lisp:6:1*
 - `^` *Native defined at lib/lua/basic.lisp:13:1*
 - `(car xs)` *Defined at lib/base.lisp:46:1*
 - `(cdr xs)` *Defined at lib/base.lisp:47:1*
 - `concat` *Native defined at lib/lua/table.lisp:1:1*
 - `error` *Native defined at lib/lua/basic.lisp:27:1*
 - `get-idx` *Native defined at lib/lua/basic.lisp:37:1*
 - `getmetatable` *Native defined at lib/lua/basic.lisp:28:1*
 - `(let* vars &body)` *Macro defined at lib/base.lisp:73:1*
 - `pcall` *Native defined at lib/lua/basic.lisp:34:1*
 - `print` *Native defined at lib/lua/basic.lisp:35:1*
 - `require` *Native defined at lib/lua/basic.lisp:42:1*
 - `set-idx!` *Native defined at lib/lua/basic.lisp:39:1*
 - `tonumber` *Native defined at lib/lua/basic.lisp:45:1*
 - `tostring` *Native defined at lib/lua/basic.lisp:46:1*
 - `type#` *Native defined at lib/lua/basic.lisp:47:1*
 - `unpack` *Native defined at lib/lua/table.lisp:7:1*
 - `xpcall` *Native defined at lib/lua/basic.lisp:48:1*
