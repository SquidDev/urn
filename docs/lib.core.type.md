---
title: core/type
---
# core/type
## `(atom? x)`
*Defined at lib/core/type.lisp:53:2*

Check whether `X` is an atomic object, that is, one of
- `A` boolean
- `A` string
- `A` number
- `A` symbol
- `A` key
- `A` function

## `(between? val min max)`
*Defined at lib/core/type.lisp:81:2*

Check if the numerical value `X` is between
`MIN` and `MAX`.

## `(boolean? x)`
*Defined at lib/core/type.lisp:37:2*

Check whether `X` is a boolean.

## `(empty? x)`
*Defined at lib/core/type.lisp:13:2*

Check whether `X` is the empty list or the empty string.

## `(exists? x)`
*Defined at lib/core/type.lisp:71:2*

Check if `X` exists, i.e. it is not the special value `nil`.
Note that, in Urn, `nil` is not the empty list.

## `(falsey? x)`
*Defined at lib/core/type.lisp:66:2*

Check whether `X` is falsey, that is, it is either `false` or does not
exist.

## `(function? x)`
*Defined at lib/core/type.lisp:43:2*

Check whether `X` is a function.

## `(key? x)`
*Defined at lib/core/type.lisp:49:2*

Check whether `X` is a key.

## `(list? x)`
*Defined at lib/core/type.lisp:9:2*

Check whether `X` is a list.

## `(nil? x)`
*Defined at lib/core/type.lisp:76:2*

Check if `X` does not exist, i.e. it is the special value `nil`.
Note that, in Urn, `nil` is not the empty list.

## `(number? x)`
*Defined at lib/core/type.lisp:27:2*

Check whether `X` is a number.

## `(string? x)`
*Defined at lib/core/type.lisp:21:2*

Check whether `X` is a string.

## `(symbol? x)`
*Defined at lib/core/type.lisp:33:2*

Check whether `X` is a symbol.

## `(table? x)`
*Defined at lib/core/type.lisp:4:2*

Check whether the value `X` is a table. This might be a structure,
a list, an associative list, a quoted key, or a quoted symbol.

## `(type val)`
*Defined at lib/core/type.lisp:86:2*

Return the type of `VAL`.

