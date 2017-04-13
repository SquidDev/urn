---
title: The compiler API
---

# The compiler API
> **Note:** This is a relatively advanced tutorial, so feel free to ignore it.

The compiler API is a way with interacting with various compiler internals, allowing for powerful metaprogramming
abilities, and custom optimisation and analysis passes. For obvious reasons, the API is only avalible at compile time,
and therefore should only be used in macros and top-level unquotes.

## Resolving variables
The `compiler/resolve` library provides various methods for accessing variables and scopes. To demonstrate it's possible
uses, let's write an alternative implementation of `setf!`. This will look up the getter, and then look up the setter in
the same scope the getter was defined, meaning it doesn't have to be exported. First off, we'll start by querying the
getter and printing it's definition.

```cl
(import compiler/resolve res)

(defmacro setf! (obj val)
  (let* [(symb (car obj))
         (getter (res/var-lookup symb))]
    (debug (res/var-definition getter)))
  "Not yet implemented")
```

Using this (such as `(setf! (.> x :foo) "bar")`) will print out the definition of the given symbol. Now let's get the
variable's scope and start querying that.

```cl
(defmacro setf! (obj val)
  (let* [(symb (car obj))
         (getter (res/var-lookup symb))
         (setter (res/var-lookup (sym.. symb '/setf!) (.> getter :scope)))]
    (debug (res/var-definition setter)))
  "Not yet implemented")
```

Now we can convert this variable into a symbol, and emit our node:

```cl
(import compile/nodes nodes)

(defmacro setf! (obj val)
  (let* [(symb (car obj))
         (getter (res/var-lookup symb))
         (setter (res/var-lookup (sym.. symb '/setf!) (.> getter :scope)))]
    (debug (res/var-definition setter)))
  (list (nodes/var->symbol setter) ,(cdr obj) ,val))
```
