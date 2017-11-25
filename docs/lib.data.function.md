---
title: data/function
---
# data/function
## `(-> x &funcs)`
*Macro defined at lib/data/function.lisp:59:2*

Chain a series of method calls together. If the list contains `<>`
then the value is placed there, otherwise the expression is invoked
with the previous entry as an argument.

### Example
```cl
> (-> '(1 2 3)
.   (map succ <>)
.   (map (cut * <> 2) <>))
out = (4 6 8)
```

## `(as-is x)`
*Defined at lib/data/function.lisp:134:2*

Return the value `X` unchanged.

### Example
```cl
> (map as-is '(1 2 3))
out = (1 2 3)
```

## `(call x key &args)`
*Defined at lib/data/function.lisp:158:2*

Index `X` with `KEY` and invoke the resulting function with `ARGS`.

### Example
```cl
> (define tbl { :add + })
> (call tbl :add 1 2 3)
out = 6
```

## `(comp &fs)`
*Defined at lib/data/function.lisp:112:2*

Return the pointwise composition of all functions in `FS`.

### Example:
```cl
> ((comp succ (cut + <> 2) (cut * <> 2))
.  2)
out = 7
```

## `(compose f g)`
*Defined at lib/data/function.lisp:98:2*

Return the pointwise composition of functions `F` and `G`.

### Example:
```cl
> ((compose (cut + <> 2) (cut * <> 2))
.  2)
out = 6
```

## `(const x)`
*Defined at lib/data/function.lisp:144:2*

Return a function which always returns `X`. This is equivalent to the
`K` combinator in `SK` combinator calculus.

### Example
```cl
> (define x (const 1))
> (x 2)
out = 1
> (x "const")
out = 1
```

## `(cut &func)`
*Macro defined at lib/data/function.lisp:16:2*

Partially apply a function `FUNC`, where each `<>` is replaced by an
argument to a function. Values are evaluated every time the resulting
function is called.

### Example
```cl
> (define double (cut * <> 2))
> (double 3)
out = 6
```

## `(cute &func)`
*Macro defined at lib/data/function.lisp:37:2*

Partially apply a function `FUNC`, where each `<>` is replaced by an
argument to a function. Values are evaluated when this function is
defined.

### Example
```cl
> (define double (cute * <> 2))
> (double 3)
out = 6
```

## `(id x)`
*Defined at lib/data/function.lisp:124:2*

Return the value `X` unmodified.

### Example
```cl
> (map id '(1 2 3))
out = (1 2 3)
```

## `(invokable? x)`
*Defined at lib/data/function.lisp:80:2*

Test if the expression `X` makes sense as something that can be applied
to a set of arguments.

### Example
```cl
> (invokable? invokable?)
out = true
> (invokable? nil)
out = false
> (invokable? (setmetatable {} { :__call (lambda (x) (print! "hello")) }))
out = true
```

## `(self x key &args)`
*Defined at lib/data/function.lisp:169:2*

Index `X` with `KEY` and invoke the resulting function with `X` and `ARGS`.

### Example
```cl
> (define tbl { :get (lambda (self key) (.> self key))
.               :x 1
.               :y 2 })
> (self tbl :get :x)
out = 1
```

## `(slot? symb)`
*Defined at lib/data/function.lisp:3:2*

Test whether `SYMB` is a slot. For this, it must be a symbol, whose
contents are `<>`.

### Example
```cl
> (slot? '<>)
out = true
> (slot? 'not-a-slot)
out = false
```

