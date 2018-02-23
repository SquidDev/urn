---
title: core/base
---
# core/base
## `*arguments*`
*Defined at lib/core/base.lisp:386:1*

The arguments passed to the currently executing program

## `(-and a b)`
*Defined at lib/core/base.lisp:351:2*

Return the logical conjunction of values `A` and `B`.

As this is a function rather than a macro, it can be used as a
variable. However, each argument is evaluated eagerly. See [`and`](lib.core.base.md#and-a-b-rest) for
a lazy version.

## `(-or a b)`
*Defined at lib/core/base.lisp:343:2*

Return the logical disjunction of values `A` and `B`.

As this is a function rather than a macro, it can be used as a
variable. However, each argument is evaluated eagerly. See [`or`](lib.core.base.md#or-a-b-rest) for
a lazy version.

## `(<=> p q)`
*Macro defined at lib/core/base.lisp:327:2*

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

## `=`
*Native defined at lib/lua/basic.lisp:1:1*

Determine if two variables are equal.

## `(=> p q)`
*Macro defined at lib/core/base.lisp:317:2*

Logical implication. `(=> a b)` is equivalent to `(or (not a) b)`.

### Example:
```cl
> (=> (> 3 1) (< 1 3))
out = true
```

## `(and a b &rest)`
*Macro defined at lib/core/base.lisp:281:2*

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

## `(apply f &xss xs)`
*Defined at lib/core/base.lisp:457:2*

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
*Defined at lib/core/base.lisp:398:1*

>**Warning:** arg is deprecated: Use [`*arguments*`](lib.core.base.md#-arguments-) instead.

The arguments passed to the currently executing program

## `(cons x xs)`
*Defined at lib/core/base.lisp:145:2*

Add `X` to the start of the list `XS`. Note: this is linear in time.

## `(const-val val)`
*Defined at lib/core/base.lisp:403:2*

Get the actual value of `VAL`, an argument to a macro.

Due to how macros are implemented, all values are wrapped as tables
in order to preserve positional data about nodes. You will need to
unwrap them in order to use them.

## `(defmacro name args &body)`
*Macro defined at lib/core/base.lisp:125:1*

Define `NAME` to be the macro given by (lambda `ARGS` @`BODY`), with
optional metadata at the start of `BODY`.

## `(defun name args &body)`
*Macro defined at lib/core/base.lisp:119:1*

Define `NAME` to be the function given by (lambda `ARGS` @`BODY`), with
optional metadata at the start of `BODY`.

## `else`
*Defined at lib/core/base.lisp:9:1*

[`else`](lib.core.base.md#else) is defined as having the value `true`. Use it as the
last case in a `cond` expression to increase readability.

## `(for ctr start end step &body)`
*Macro defined at lib/core/base.lisp:229:2*

Iterate `BODY`, with the counter `CTR` bound to `START`, being incremented
by `STEP` every iteration until `CTR` is outside of the range given by
[`START` .. `END`].

### Example:
```cl
> (with (x '())
.   (for i 1 3 1 (push! x i))
.   x)
out = (1 2 3)
```

## `(for-pairs vars tbl &body)`
*Macro defined at lib/core/base.lisp:359:2*

Iterate over `TBL`, binding `VARS` for each key value pair in `BODY`.

### Example:
```cl
> (let [(res '())
.       (struct { :foo 123 })]
.   (for-pairs (k v) struct
.     (push! res (list k v)))
.     res)
out = (("foo" 123))
```

## `(gensym name)`
*Defined at lib/core/base.lisp:200:1*

Create a unique symbol, suitable for using in macros

## `(if c t b)`
*Macro defined at lib/core/base.lisp:162:2*

Evaluate `T` if `C` is true, otherwise, evaluate `B`.

### Example
```cl
> (if (> 1 3) "> 1 3" "<= 1 3")
out = "<= 1 3"
```

## `(list &xs)`
*Defined at lib/core/base.lisp:134:2*

Return the list of variadic arguments given.

### Example:
```cl
> (list 1 2 3)
out = (1 2 3)
```

## `(n x)`
*Defined at lib/core/base.lisp:14:1*

Get the length of list X

## `(not expr)`
*Defined at lib/core/base.lisp:189:2*

Compute the logical negation of the expression `EXPR`.

### Example:
```cl
> (with (a 1)
.   (not (= a 1)))
out = false
```

## `(or a b &rest)`
*Macro defined at lib/core/base.lisp:299:2*

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

## `(progn &body)`
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

## `(quasiquote val)`
*Macro defined at lib/core/base.lisp:436:2*

Quote `VAL`, but replacing all `unquote` and `unquote-splice` with their actual value.

Be warned, by using this you lose all macro hygiene. Variables may not be bound to their
expected values.

### Example:
```cl
> (with (x 1)
.   ~(+ ,x 2))
out = (+ 1 2)
```

## `(slice xs start finish)`
*Defined at lib/core/base.lisp:22:1*

Take a slice of `XS`, with all values at indexes between `START` and `FINISH` (or the last
entry of `XS` if not specified).

## `(splice xs)`
*Defined at lib/core/base.lisp:450:2*

Unpack a list of arguments, returning all elements in `XS`.

## `(unless c &body)`
*Macro defined at lib/core/base.lisp:176:2*

Evaluate `BODY` if `C` is false, otherwise, evaluate `nil`.

## `(values-list &xs)`
*Macro defined at lib/core/base.lisp:470:2*

Return multiple values, one per element in `XS`.

### Example:
```cl
> (print! (values-list 1 2 3))
1   2   3
out = nil
```

## `(when c &body)`
*Macro defined at lib/core/base.lisp:172:2*

Evaluate `BODY` when `C` is true, otherwise, evaluate `nil`.

## `(while check &body)`
*Macro defined at lib/core/base.lisp:258:2*

Iterate `BODY` while the expression `CHECK` evaluates to `true`.

### Example:
```cl
> (with (x 4)
.   (while (> x 0) (dec! x))
.   x)
out = 0
```

## `(with var &body)`
*Macro defined at lib/core/base.lisp:277:2*

Bind the single variable `VAR`, then evaluate `BODY`.

## Undocumented symbols
 - `*` *Native defined at lib/lua/basic.lisp:19:1*
 - `+` *Native defined at lib/lua/basic.lisp:15:1*
 - `-` *Native defined at lib/lua/basic.lisp:17:1*
 - `..` *Native defined at lib/lua/basic.lisp:27:1*
 - `/` *Native defined at lib/lua/basic.lisp:21:1*
 - `/=` *Native defined at lib/lua/basic.lisp:4:1*
 - `<` *Native defined at lib/lua/basic.lisp:6:1*
 - `<=` *Native defined at lib/lua/basic.lisp:8:1*
 - `>` *Native defined at lib/lua/basic.lisp:10:1*
 - `>=` *Native defined at lib/lua/basic.lisp:12:1*
 - `(car xs)` *Defined at lib/core/base.lisp:131:1*
 - `(cdr xs)` *Defined at lib/core/base.lisp:132:1*
 - `concat` *Native defined at lib/lua/table.lisp:1:1*
 - `(eighth &rest)` *Defined at lib/core/base.lisp:486:1*
 - `error` *Native defined at lib/lua/basic.lisp:44:1*
 - `expt` *Native defined at lib/lua/basic.lisp:25:1*
 - `(fifth &rest)` *Defined at lib/core/base.lisp:486:1*
 - `(first &rest)` *Defined at lib/core/base.lisp:486:1*
 - `(fourth &rest)` *Defined at lib/core/base.lisp:486:1*
 - `get-idx` *Native defined at lib/lua/basic.lisp:33:1*
 - `getmetatable` *Native defined at lib/lua/basic.lisp:45:1*
 - `(lambda ll &body)` *Macro defined at lib/core/base.lisp:54:1*
 - `len#` *Native defined at lib/lua/basic.lisp:30:1*
 - `(let* vars &body)` *Macro defined at lib/core/base.lisp:180:2*
 - `mod` *Native defined at lib/lua/basic.lisp:23:1*
 - `(ninth &rest)` *Defined at lib/core/base.lisp:486:1*
 - `pcall` *Native defined at lib/lua/basic.lisp:51:1*
 - `print` *Native defined at lib/lua/basic.lisp:52:1*
 - `require` *Native defined at lib/lua/basic.lisp:57:1*
 - `(second &rest)` *Defined at lib/core/base.lisp:486:1*
 - `set-idx!` *Native defined at lib/lua/basic.lisp:35:1*
 - `setmetatable` *Native defined at lib/lua/basic.lisp:59:1*
 - `(seventh &rest)` *Defined at lib/core/base.lisp:486:1*
 - `(sixth &rest)` *Defined at lib/core/base.lisp:486:1*
 - `(tenth &rest)` *Defined at lib/core/base.lisp:486:1*
 - `(third &rest)` *Defined at lib/core/base.lisp:486:1*
 - `tonumber` *Native defined at lib/lua/basic.lisp:60:1*
 - `tostring` *Native defined at lib/lua/basic.lisp:61:1*
 - `type#` *Native defined at lib/lua/basic.lisp:62:1*
 - `xpcall` *Native defined at lib/lua/basic.lisp:63:1*
