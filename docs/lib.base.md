---
title: base
---
# base
## `(! expr)`
*Defined at lib/base.lisp:79:1*

Negate the expresison `EXPR`.

## `(# x)`
*Defined at lib/lua/basic.lisp:50:1*

Get the length of list X

## `(-and a b)`
*Defined at lib/base.lisp:159:1*

Return the logical conjunction of values `A` and `B`.
This is a function, not a macro.

## `(-or a b)`
*Defined at lib/base.lisp:154:1*

Return the logical disjunction of values `A` and `B`.
This is a function, not a macro.

## `(<=> p q)`
*Macro defined at lib/base.lisp:148:1*

Bidirectional implication. `(<=> a b)` means that `(=> a b)` and
`(=> b a)` both hold.

## `(=> p q)`
*Macro defined at lib/base.lisp:144:1*

Logical implication. `(=> a b)` is equivalent to `(or (! a) b)`.

## `(and a b &rest)`
*Macro defined at lib/base.lisp:132:1*

Return the logical and of values `A` and `B`, and, if present, the
logical and of all the values in `REST`.

## `(apply f xs)`
*Defined at lib/base.lisp:257:1*

Apply the function `F` using `XS` as the argument list.

### Example:
```cl
> (apply + '(1 2))
3
```

## `arg`
*Defined at lib/base.lisp:205:1*

The arguments passed to the currently executing program

## `(cons x xs)`
*Defined at lib/base.lisp:52:1*

Add `X` to the start of the list `XS`. Note: this is linear in time.

## `(const-val val)`
*Defined at lib/base.lisp:217:1*

Get the actual value of `VAL`, an argument to a macro.

Due to how macros are implemented, all values are wrapped as tables
in order to preserve positional data about nodes. You will need to
unwrap them in order to use them.

## `(debug x)`
*Macro defined at lib/base.lisp:164:1*

Print the value `X`, then return it unmodified.

## `(defmacro name args &body)`
*Macro defined at lib/base.lisp:39:1*

Define `NAME` to be the macro given by (lambda `ARGS` @`BODY`), with
optional metadata at the start of `BODY`.

## `(defun name args &body)`
*Macro defined at lib/base.lisp:33:1*

Define `NAME` to be the function given by (lambda `ARGS` @`BODY`), with
optional metadata at the start of `BODY`.

## `(for ctr start end step &body)`
*Macro defined at lib/base.lisp:98:1*

Iterate `BODY`, with the counter `CTR` bound to `START`, being incremented
by `STEP` every iteration until `CTR` is outside of the range given by
[`START` .. `END`]

## `gensym`
*Defined at lib/base.lisp:83:1*

Create a unique symbol, suitable for using in macros

## `(if c t b)`
*Macro defined at lib/base.lisp:60:1*

Evaluate `T` if `C` is true, otherwise, evaluate `B`.

## `(list &xs)`
*Defined at lib/base.lisp:48:1*

Return the list of variadic arguments given.

## `(or a b &rest)`
*Macro defined at lib/base.lisp:138:1*

Return the logical or of values `A` and `B`, and, if present, the
logical or of all the values in `REST`.

## `(pretty value)`
*Defined at lib/base.lisp:175:1*

Format `VALUE` as a valid Lisp expression which can be parsed.

## `(progn &body)`
*Macro defined at lib/base.lisp:56:1*

Group a series of expressions together.

## `(quasiquote val)`
*Macro defined at lib/base.lisp:250:1*

Quote `VAL`, but replacing all `unquote` and `unquote-splice` with their actual value.

Be warned, by using this you loose all macro hygiene. Variables may not be bound to their
expected values.

## `slice`
*Native defined at lib/lua/basic.lisp:20:1*

Take a slice of `XS`, with all values at indexes between `START` and `FINISH` (or the last
entry of `XS` if not specified).

## `(unless c &body)`
*Macro defined at lib/base.lisp:68:1*

Evaluate `BODY` if `C` is false, otherwise, evaluate `nil`.

## `(when c &body)`
*Macro defined at lib/base.lisp:64:1*

Evaluate `BODY` when `C` is true, otherwise, evaluate `nil`.

## `(while check &body)`
*Macro defined at lib/base.lisp:117:1*

Iterate `BODY` while the expression `CHECK` evaluates to `true`.

## `(with var &body)`
*Macro defined at lib/base.lisp:128:1*

Bind the single variable `VAR`, then evaluate `BODY`.

## Undocumented symbols
 - `%` *Native defined at lib/lua/basic.lisp:12:1*
 - `*` *Native defined at lib/lua/basic.lisp:10:1*
 - `+` *Native defined at lib/lua/basic.lisp:8:1*
 - `-` *Native defined at lib/lua/basic.lisp:9:1*
 - `..` *Native defined at lib/lua/basic.lisp:14:1*
 - `/` *Native defined at lib/lua/basic.lisp:11:1*
 - `/=` *Native defined at lib/lua/basic.lisp:2:1*
 - `<` *Native defined at lib/lua/basic.lisp:3:1*
 - `<=` *Native defined at lib/lua/basic.lisp:4:1*
 - `=` *Native defined at lib/lua/basic.lisp:1:1*
 - `>` *Native defined at lib/lua/basic.lisp:5:1*
 - `>=` *Native defined at lib/lua/basic.lisp:6:1*
 - `^` *Native defined at lib/lua/basic.lisp:13:1*
 - `(car xs)` *Defined at lib/base.lisp:45:1*
 - `(cdr xs)` *Defined at lib/base.lisp:46:1*
 - `concat` *Native defined at lib/lua/table.lisp:1:1*
 - `error` *Native defined at lib/lua/basic.lisp:27:1*
 - `get-idx` *Native defined at lib/lua/basic.lisp:37:1*
 - `getmetatable` *Native defined at lib/lua/basic.lisp:28:1*
 - `len#` *Native defined at lib/lua/basic.lisp:19:1*
 - `(let* vars &body)` *Macro defined at lib/base.lisp:72:1*
 - `pcall` *Native defined at lib/lua/basic.lisp:34:1*
 - `print` *Native defined at lib/lua/basic.lisp:35:1*
 - `require` *Native defined at lib/lua/basic.lisp:42:1*
 - `set-idx!` *Native defined at lib/lua/basic.lisp:39:1*
 - `tonumber` *Native defined at lib/lua/basic.lisp:45:1*
 - `tostring` *Native defined at lib/lua/basic.lisp:46:1*
 - `type#` *Native defined at lib/lua/basic.lisp:47:1*
 - `unpack` *Native defined at lib/lua/table.lisp:7:1*
 - `xpcall` *Native defined at lib/lua/basic.lisp:48:1*
