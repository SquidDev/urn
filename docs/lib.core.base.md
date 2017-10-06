---
title: core/base
---
# core/base
## `-and`
*Defined at lib/core/base.lisp:339:2*

Return the logical conjunction of values `A` and `B`.

As this is a function rather than a macro, it can be used as a
variable. However, each argument is evaluated eagerly. See [`and`](lib.core.base.md#and) for
a lazy version.

## `-or`
*Defined at lib/core/base.lisp:331:2*

Return the logical disjunction of values `A` and `B`.

As this is a function rather than a macro, it can be used as a
variable. However, each argument is evaluated eagerly. See [`or`](lib.core.base.md#or) for
a lazy version.

## `<=>`
*Macro defined at lib/core/base.lisp:315:2*

Bidirectional implication. `(<=> a b)` means that `(=> a b)` and
`(=> b a)` both hold.

### Example:
```cl
> (<=> (> 3 1) (< 1 3))
out = true
> (<=> (> 1 3) (< 3 1))
out = true
> (<=> (> 1 3) (< 1 3))
out = false
```

## `=>`
*Macro defined at lib/core/base.lisp:305:2*

Logical implication. `(=> a b)` is equivalent to `(or (not a) b)`.

### Example:
```cl
> (=> (> 3 1) (< 1 3))
out = true
```

## `and`
*Macro defined at lib/core/base.lisp:269:2*

Return the logical and of values `A` and `B`, and, if present, the
logical and of all the values in `REST`.

Each argument is lazily evaluated, only being computed if the previous
argument returned a truthy value. This will return the last argument
to be evaluated.

### Example:
```cl
> (and 1 2 3)
out = 3
> (and (> 3 1) (< 3 1))
out = false
```

## `apply`
*Defined at lib/core/base.lisp:433:2*

Apply the function `F` using `XS` as the argument list, with `XSS` as
arguments before `XS` is spliced.

### Example:
```cl
> (apply + '(1 2))
out = 3
> (apply + 1 '(2))
out = 3
```

## `arg`
*Defined at lib/core/base.lisp:374:1*

The arguments passed to the currently executing program

## `cons`
*Defined at lib/core/base.lisp:145:2*

Add `X` to the start of the list `XS`. Note: this is linear in time.

## `const-val`
*Defined at lib/core/base.lisp:386:2*

Get the actual value of `VAL`, an argument to a macro.

Due to how macros are implemented, all values are wrapped as tables
in order to preserve positional data about nodes. You will need to
unwrap them in order to use them.

## `defmacro`
*Macro defined at lib/core/base.lisp:125:1*

Define `NAME` to be the macro given by (lambda `ARGS` @`BODY`), with
optional metadata at the start of `BODY`.

## `defun`
*Macro defined at lib/core/base.lisp:119:1*

Define `NAME` to be the function given by (lambda `ARGS` @`BODY`), with
optional metadata at the start of `BODY`.

## `else`
*Defined at lib/core/base.lisp:9:1*

[`else`](lib.core.base.md#else) is defined as having the value `true`. Use it as the
last case in a `cond` expression to increase readability.

## `for`
*Macro defined at lib/core/base.lisp:219:2*

Iterate `BODY`, with the counter `CTR` bound to `START`, being incremented
by `STEP` every iteration until `CTR` is outside of the range given by
[`START` .. `END`].

### Example:
```cl
> (with (x '())
.   (for i 1 3 1 (push-cdr! x i))
.   x)
out = (1 2 3)
```

## `for-pairs`
*Macro defined at lib/core/base.lisp:347:2*

Iterate over `TBL`, binding `VARS` for each key value pair in `BODY`.

### Example:
```cl
> (let [(res '())
.       (struct { :foo 123 })]
.   (for-pairs (k v) struct
.     (push-cdr! res (list k v)))
.     res)
out = (("foo" 123))
```

## `gensym`
*Defined at lib/core/base.lisp:203:1*

Create a unique symbol, suitable for using in macros

## `if`
*Macro defined at lib/core/base.lisp:162:2*

Evaluate `T` if `C` is true, otherwise, evaluate `B`.

### Example
```cl
> (if (> 1 3) "> 1 3" "<= 1 3")
out = "<= 1 3"
```

## `list`
*Defined at lib/core/base.lisp:134:2*

Return the list of variadic arguments given.

### Example:
```cl
> (list 1 2 3)
out = (1 2 3)
```

## `n`
*Defined at lib/core/base.lisp:14:1*

Get the length of list X

## `not`
*Defined at lib/core/base.lisp:189:2*

Compute the logical negation of the expression `EXPR`.

### Example:
```cl
> (with (a 1)
.   (not (= a 1)))
out = false
```

## `or`
*Macro defined at lib/core/base.lisp:287:2*

Return the logical or of values `A` and `B`, and, if present, the
logical or of all the values in `REST`.

Each argument is lazily evaluated, only being computed if the previous
argument returned a falsey value. This will return the last argument
to be evaluated.

### Example:
```cl
> (or 1 2 3)
out = 1
> (or (> 3 1) (< 3 1))
out = true
```

## `progn`
*Macro defined at lib/core/base.lisp:149:2*

Group a series of expressions together.

### Example
```cl
> (progn
.   (print! 123)
.   456)
123
out = 456
```

## `quasiquote`
*Macro defined at lib/core/base.lisp:419:2*

Quote `VAL`, but replacing all `unquote` and `unquote-splice` with their actual value.

Be warned, by using this you lose all macro hygiene. Variables may not be bound to their
expected values.

### Example:
```cl
> (with (x 1)
.   ~(+ ,x 2))
out = (+ 1 2)
```

## `slice`
*Defined at lib/core/base.lisp:22:1*

Take a slice of `XS`, with all values at indexes between `START` and `FINISH` (or the last
entry of `XS` if not specified).

## `unless`
*Macro defined at lib/core/base.lisp:176:2*

Evaluate `BODY` if `C` is false, otherwise, evaluate `nil`.

## `values-list`
*Macro defined at lib/core/base.lisp:447:2*

Return multiple values, one per element in `XS`.

### Example:
```cl
> (print! (values-list 1 2 3))
1   2   3
out = nil
```

## `when`
*Macro defined at lib/core/base.lisp:172:2*

Evaluate `BODY` when `C` is true, otherwise, evaluate `nil`.

## `while`
*Macro defined at lib/core/base.lisp:246:2*

Iterate `BODY` while the expression `CHECK` evaluates to `true`.

### Example:
```cl
> (with (x 4)
.   (while (> x 0) (dec! x))
.   x)
out = 0
```

## `with`
*Macro defined at lib/core/base.lisp:265:2*

Bind the single variable `VAR`, then evaluate `BODY`.

## Undocumented symbols
 - `!` *Defined at lib/core/base.lisp:200:2*
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
 - `car` *Defined at lib/core/base.lisp:131:1*
 - `cdr` *Defined at lib/core/base.lisp:132:1*
 - `concat` *Native defined at lib/lua/table.lisp:1:1*
 - `eighth` *Defined at lib/core/base.lisp:465:1*
 - `error` *Native defined at lib/lua/basic.lisp:24:1*
 - `fifth` *Defined at lib/core/base.lisp:465:1*
 - `first` *Defined at lib/core/base.lisp:465:1*
 - `fourth` *Defined at lib/core/base.lisp:465:1*
 - `get-idx` *Native defined at lib/lua/basic.lisp:34:1*
 - `getmetatable` *Native defined at lib/lua/basic.lisp:25:1*
 - `lambda` *Macro defined at lib/core/base.lisp:54:1*
 - `len#` *Native defined at lib/lua/basic.lisp:19:1*
 - `let*` *Macro defined at lib/core/base.lisp:180:2*
 - `ninth` *Defined at lib/core/base.lisp:465:1*
 - `pcall` *Native defined at lib/lua/basic.lisp:31:1*
 - `print` *Native defined at lib/lua/basic.lisp:32:1*
 - `require` *Native defined at lib/lua/basic.lisp:39:1*
 - `second` *Defined at lib/core/base.lisp:465:1*
 - `set-idx!` *Native defined at lib/lua/basic.lisp:36:1*
 - `setmetatable` *Native defined at lib/lua/basic.lisp:41:1*
 - `seventh` *Defined at lib/core/base.lisp:465:1*
 - `sixth` *Defined at lib/core/base.lisp:465:1*
 - `tenth` *Defined at lib/core/base.lisp:465:1*
 - `third` *Defined at lib/core/base.lisp:465:1*
 - `tonumber` *Native defined at lib/lua/basic.lisp:42:1*
 - `tostring` *Native defined at lib/lua/basic.lisp:43:1*
 - `type#` *Native defined at lib/lua/basic.lisp:44:1*
 - `unpack` *Native defined at lib/lua/table.lisp:7:1*
 - `xpcall` *Native defined at lib/lua/basic.lisp:45:1*
