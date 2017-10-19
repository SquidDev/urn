---
title: core/type
---
# core/type
## `(assert-type! arg ty)`
*Macro defined at lib/core/type.lisp:118:2*

Assert that the argument `ARG` has type `TY`, as reported by the function
[`type`](lib.core.type.md#type-val).

## `(atom? x)`
*Defined at lib/core/type.lisp:58:2*

Check whether `X` is an atomic object, that is, one of
- `A` boolean
- `A` string
- `A` number
- `A` symbol
- `A` key
- `A` function

## `(between? val min max)`
*Defined at lib/core/type.lisp:86:2*

Check if the numerical value `X` is between
`MIN` and `MAX`.

## `(boolean? x)`
*Defined at lib/core/type.lisp:42:2*

Check whether `X` is a boolean.

## `(debug x)`
*Macro defined at lib/core/type.lisp:367:2*

Print the value `X`, then return it unmodified.

## `(defalias name other)`
*Macro defined at lib/core/type.lisp:286:2*

Alias the method at `NAME` to the method at `OTHER`.

## `(defdefault name ll &body)`
*Macro defined at lib/core/type.lisp:268:2*

Add a default case to the generic method `NAME` with the arguments `LL` and the
body `BODY`.

`BODY` has in scope a symbol, `myself`, that refers specifically to this
instantiation of the generic method `NAME`. For instance, in

```cl
(defdefault my-pretty-print (x)
  (myself (.. "foo " x)))
```

`myself` refers only to the default case of `my-pretty-print`

## `(defgeneric name ll &attrs)`
*Macro defined at lib/core/type.lisp:165:2*

Define a generic method called `NAME` with the arguments given in `LL`,
and the attributes given in `ATTRS`. Note that documentation _must_
come after `LL`; The mixed syntax accepted by `define` is not allowed.

### Examples:
```cl
> (defgeneric my-pretty-print (x)
.   "Pretty-print a value.")
out = «method: (my-pretty-print x)»
> (defmethod (my-pretty-print string) (x) x)
out = nil
> (my-pretty-print "foo")
out = "foo"
```

## `(defmethod name ll &body)`
*Macro defined at lib/core/type.lisp:236:2*

Add a case to the generic method `NAME` with the arguments `LL` and the body
`BODY`. The types of arguments for this specialisation are given in the list
`NAME`, and the argument names are merely used to build the lambda.

`BODY` has in scope a symbol, `myself`, that refers specifically to this
instantiation of the generic method `NAME`. For instance, in

```cl
(defmethod (my-pretty-print string) (x)
  (myself (.. "foo " x)))
```

`myself` refers only to the case of `my-pretty-print` that handles strings.

### Example
```cl
> (defgeneric my-pretty-print (x)
.   "Pretty-print a value.")
out = «method: (my-pretty-print x)»
> (defmethod (my-pretty-print string) (x) x)
out = nil
> (my-pretty-print "foo")
out = "foo"
```

## `(empty? x)`
*Defined at lib/core/type.lisp:18:2*

Check whether `X` is the empty list or the empty string.

## `eq?`
*Defined at lib/core/type.lisp:291:2*

Compare values for equality deeply.

## `(eql? x y)`
*Defined at lib/core/type.lisp:104:2*

`A` version of [`eq?`](lib.core.type.md#eq-) that compares the types of `X` and `Y` instead of
just the values.

### Example:
```cl
> (eq? 'foo "foo")
out = true
> (eql? 'foo "foo")
out = false
```

## `(exists? x)`
*Defined at lib/core/type.lisp:76:2*

Check if `X` exists, i.e. it is not the special value `nil`.
Note that, in Urn, `nil` is not the empty list.

## `(falsey? x)`
*Defined at lib/core/type.lisp:71:2*

Check whether `X` is falsey, that is, it is either `false` or does not
exist.

## `(function? x)`
*Defined at lib/core/type.lisp:48:2*

Check whether `X` is a function.

## `(key? x)`
*Defined at lib/core/type.lisp:54:2*

Check whether `X` is a key.

## `(list? x)`
*Defined at lib/core/type.lisp:14:2*

Check whether `X` is a list.

## `(neq? x y)`
*Defined at lib/core/type.lisp:99:2*

Compare `X` and `Y` for inequality deeply. `X` and `Y` are `neq?`
if `([[eq?]] x y)` is falsey.

## `(nil? x)`
*Defined at lib/core/type.lisp:81:2*

Check if `X` does not exist, i.e. it is the special value `nil`.
Note that, in Urn, `nil` is not the empty list.

## `(number? x)`
*Defined at lib/core/type.lisp:32:2*

Check whether `X` is a number.

## `pretty`
*Defined at lib/core/type.lisp:335:2*

Pretty-print a value.

## `(string? x)`
*Defined at lib/core/type.lisp:26:2*

Check whether `X` is a string.

## `(symbol? x)`
*Defined at lib/core/type.lisp:38:2*

Check whether `X` is a symbol.

## `(table? x)`
*Defined at lib/core/type.lisp:9:2*

Check whether the value `X` is a table. This might be a structure,
a list, an associative list, a quoted key, or a quoted symbol.

## `(type val)`
*Defined at lib/core/type.lisp:91:2*

Return the type of `VAL`.

