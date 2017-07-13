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

## Custom passes
One of the main uses of the compiler API is the ability to register custom analysis and optimisation passes. For
instance, you could write passes which reduce multiple maps, filters and folds into a single loop. Here, we'll just add
a simple analysis pass which detects when `+` is called with non-number arguments.

First off we'll want to define a pass and register it. To do this, we'll want to use the `defpass` and `add-pass!`
functions:

```cl
(import compiler/nodes ())

(defpass check-type (state nodes)
  "Visit all nodes, ensuring that + is called with numbers."
  :cat '("warn"))

,(add-pass! check-type)
```

We should take node of a couple of things:

 - `defpass` is very similar to `defun`. It defines some additional metadata, such as what type of pass this is (warning or optimise).
 - `add-pass!` needs to be called at compile time, hence the unquote. It registers a given pass in the compiler.

Now let's try to find all usages of the `+` function. We could check for equality to `+`, but a better choice is to get
a reference to the `+` variable, and check equality to that. Thankfully, the `symbol->var` function allows us to do just
that.

```cl
(import compiler/nodes ())

(defpass check-type (state nodes)
  "Visit all nodes, ensuring that + is called with numbers."
  :cat '("warn")
  (with (add-var (symbol->var `+))
    (print! "Got add var")))
```

In order to find all calls of `+`, we'll check for lists whose first element is a symbol which references them `+`
variable. For now we'll just print out a message saying we found one.

```cl
(defpass check-type (state nodes)
  "Visit all nodes, ensuring that + is called with numbers."
  :cat '("warn")
  (with (add-var (symbol->var `+))
    (visit-nodes nodes 1
      (lambda (node)
        (when (and (list? node) (symbol? (car node)) (= (symbol->var (car node)) add-var))
          (print! "Got + call with" (pretty (nth node 2)) (pretty (nth node 3))))))))
```

Now we just need to check when either argument isn't a number, printing a warning if not.

```cl
(defun check-number (node parent)
  (with (ty (type node))
    (unless (or (= "list" ty) (= "symbol" ty) (= "number" ty))
      (logger/put-node-warning!
        (string/format "Expected number for +, got %s" ty)
        (or node parent) nil
        (range/get-source (or node parent)) ""))))

(defpass check-type (state nodes)
  "Visit all nodes, ensuring that + is called with numbers."
  :cat '("warn")
  (with (add-var (symbol->var `+))
    (visit-nodes nodes 1
      (lambda (node)
        (when (and (list? node) (symbol? (car node)) (= (symbol->var (car node)) add-var))
          (check-number (nth node 2) node)
          (check-number (nth node 3) node))))))
```

The start of the `check-number` function is quite simple: if each argument isn't a symbol, a list (so some form of
function call) or a numeric constant, then we print a warning. `logger/put-node-warning` takes a message, a node, some
additional data and then a list of positions to display. As the argument to `+` may be nil, we fall back to the parent
if required .
