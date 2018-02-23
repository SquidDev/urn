---
title: core/method
---
# core/method
## `(debug x)`
*Macro defined at lib/core/method.lisp:271:2*

Print the value `X`, then return it unmodified.

## `(defalias name other)`
*Macro defined at lib/core/method.lisp:169:2*

Alias the method at `NAME` to the method at `OTHER`.

## `(defdefault name ll &body)`
*Macro defined at lib/core/method.lisp:151:2*

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
*Macro defined at lib/core/method.lisp:48:2*

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
*Macro defined at lib/core/method.lisp:119:2*

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

## `eq?`
*Defined at lib/core/method.lisp:194:2*

Compare values for equality deeply.

## `(eql? x y)`
*Defined at lib/core/method.lisp:180:2*

`A` version of [`eq?`](lib.core.method.md#eq-) that compares the types of `X` and `Y` instead of
just the values.

### Example:
```cl
> (eq? 'foo "foo")
out = true
> (eql? 'foo "foo")
out = false
```

## `(neq? x y)`
*Defined at lib/core/method.lisp:175:2*

Compare `X` and `Y` for inequality deeply. `X` and `Y` are `neq?`
if `([[eq?]] x y)` is falsey.

## `pretty`
*Defined at lib/core/method.lisp:239:2*

Pretty-print a value.

