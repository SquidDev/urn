---
title: type
---
# type
## `(assert-type! arg ty)`
*Macro defined at lib/type.lisp:116:1*

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

## `(debug x)`
*Macro defined at lib/type.lisp:351:1*

Print the value `X`, then return it unmodified.

## `(defdefault name ll &body)`
*Macro defined at lib/type.lisp:249:1*

Add a default case to the generic method `NAME` with the arguments `LL` and the
body `BODY`.

`BODY` has in scope a symbol, `myself`, that refers specifically to this
instantiation of the generic method `NAME`. For instance, in

```cl :no-test
(defdefault my-pretty-print (x)
  (myself (.. "foo " x)))
```

`myself` refers only to the default case of `my-pretty-print`

## `(defgeneric name ll &attrs)`
*Macro defined at lib/type.lisp:158:1*

Define a generic method called `NAME` with the arguments given in `LL`,
and the attributes given in `ATTRS`. Note that documentation _must_
come after `LL`; The mixed syntax accepted by `define` is not allowed.

### Examples:
```cl :no-test
> (defgeneric my-pretty-print (x)
.   "Pretty-print a value.")
out = «method: (my-pretty-print x)»
> (defmethod (my-pretty-print string) (x) x)
out = nil
> (my-pretty-print "foo")
out = "foo"
```

## `(defmethod name ll &body)`
*Macro defined at lib/type.lisp:217:1*

Add a case to the generic method `NAME` with the arguments `LL` and the body
`BODY`. The types of arguments for this specialisation are given in the list
`NAME`, and the argument names are merely used to build the lambda.

`BODY` has in scope a symbol, `myself`, that refers specifically to this
instantiation of the generic method `NAME`. For instance, in

```cl :no-test
(defmethod (my-pretty-print string) (x)
  (myself (.. "foo " x)))
```

`myself` refers only to the case of `my-pretty-print` that handles strings.

### Example
```cl :no-test
> (defgeneric my-pretty-print (x)
.   "Pretty-print a value.")
out = «method: (my-pretty-print x)»
> (defmethod (my-pretty-print string) (x) x)
out = nil
> (my-pretty-print "foo")
out = "foo"
```

## `(empty? x)`
*Defined at lib/type.lisp:18:1*

Check whether `X` is the empty list or the empty string.

## `eq?`
*Defined at lib/type.lisp:267:1*

Compare values for equality deeply.

## `(eql? x y)`
*Defined at lib/type.lisp:102:1*

`A` version of [`eq?`](lib.type.md#eq-) that compares the types of `X` and `Y` instead of
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
*Defined at lib/type.lisp:97:1*

Compare `X` and `Y` for inequality deeply. `X` and `Y` are `neq?`
if `([[eq?]] x y)` is falsey.

## `(nil? x)`
*Defined at lib/type.lisp:79:1*

Check if `X` does not exist, i.e. it is the special value `nil`.
Note that, in Urn, `nil` is not the empty list.

## `(number? x)`
*Defined at lib/type.lisp:32:1*

Check whether `X` is a number.

## `pretty`
*Defined at lib/type.lisp:324:1*

Pretty-print a value.

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

