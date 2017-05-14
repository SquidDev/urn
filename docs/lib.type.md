---
title: type
---
# type
## `(assert-type! arg ty)`
*Macro defined at lib/type.lisp:164:1*

Assert that the argument `ARG` has type `TY`, as reported by the function
[`type`](lib.type.md#type-val).

## `(atom? x)`
*Defined at lib/type.lisp:56:1*

Check whether `X` is an atomic object, that is, one of
- `A` boolean
- `A` string
- `A` number
- `A` symbol
- `A` key
- `A` function

## `(between? val min max)`
*Defined at lib/type.lisp:84:1*

Check if the numerical value `X` is between
`MIN` and `MAX`.

## `(boolean? x)`
*Defined at lib/type.lisp:42:1*

Check whether `X` is a boolean.

## `(empty? x)`
*Defined at lib/type.lisp:18:1*

Check whether `X` is the empty list or the empty string.

## `(eq? x y)`
*Defined at lib/type.lisp:97:1*

Compare `X` and `Y` for equality deeply.
Rules:
- If `X` and `Y` exist, `X` and `Y` are equal if:
  - If `X` or `Y` are a symbol
    - Both are symbols, and their contents are equal.
    - `X` is a symbol, and `Y` is a string equal to the symbol's contents.
    - `Y` is a symbol, and `X` is a string equal to the symbol's contents.
  - If `X` or `Y` are a key
    - Both are keys, and their values are equal.
    - `X` is a key, and `Y` is a string equal to the key's contents.
    - `Y` is a key, and `X` is a string equal to the key's contents.
  - If `X` or `Y` are lists
    - Both are empty.
    - Both have the same length, their `car`s are equal, and their `cdr`s
      are equal.
  - Otherwise, `X` and `Y` are equal if they are the same value.
- If `X` or `Y` do not exist
  - They are not equal if one exists and the other does not.
  - They are equal if neither exists.  

## `(eql? x y)`
*Defined at lib/type.lisp:150:1*

`A` version of [`eq?`](lib.type.md#eq-x-y) that compares the types of `X` and `Y` instead of
just the values.

### Example:
```cl
> (eq? 'foo "foo")
out = true
> (eql? 'foo "foo")
out = false
```

## `(exists? x)`
*Defined at lib/type.lisp:74:1*

Check if `X` exists, i.e. it is not the special value `nil`.
Note that, in Urn, `nil` is not the empty list.

## `(falsey? x)`
*Defined at lib/type.lisp:69:1*

Check whether `X` is falsey, that is, it is either `false` or does not
exist.

## `(function? x)`
*Defined at lib/type.lisp:48:1*

Check whether `X` is a function.

## `(key? x)`
*Defined at lib/type.lisp:52:1*

Check whether `X` is a key.

## `(list? x)`
*Defined at lib/type.lisp:14:1*

Check whether `X` is a list.

## `(neq? x y)`
*Defined at lib/type.lisp:145:1*

Compare `X` and `Y` for inequality deeply. `X` and `Y` are `neq?`
if `([[eq?]] x y)` is falsey.

## `(nil? x)`
*Defined at lib/type.lisp:79:1*

Check if `X` does not exist, i.e. it is the special value `nil`.
Note that, in Urn, `nil` is not the empty list.

## `(number? x)`
*Defined at lib/type.lisp:32:1*

Check whether `X` is a number.

## `(string? x)`
*Defined at lib/type.lisp:26:1*

Check whether `X` is a string.

## `(symbol? x)`
*Defined at lib/type.lisp:38:1*

Check whether `X` is a symbol.

## `(table? x)`
*Defined at lib/type.lisp:9:1*

Check whether the value `X` is a table. This might be a structure,
a list, an associative list, a quoted key, or a quoted symbol.

## `(type val)`
*Defined at lib/type.lisp:89:1*

Return the type of `VAL`.

