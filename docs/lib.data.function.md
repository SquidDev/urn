---
title: data/function
---
# data/function
## `(-> x &funcs)`
*Macro defined at lib/data/function.lisp:51:2*

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
*Defined at lib/data/function.lisp:120:2*

Return the value `X` unchanged.

## `(call x key &args)`
*Defined at lib/data/function.lisp:138:2*

Index `X` with `KEY` and invoke the resulting function with `ARGS`.

## `(comp &fs)`
*Defined at lib/data/function.lisp:104:2*

Return the pointwise composition of all functions in `FS`.

### Example:
```cl
> ((comp succ (cut + <> 2) (cut * <> 2))
.  2)
out = 7
```

## `(compose f g)`
*Defined at lib/data/function.lisp:90:2*

Return the pointwise composition of functions `F` and `G`.

### Example:
```cl
> ((compose (cut + <> 2) (cut * <> 2))
.  2)
out = 6
```

## `(const x)`
*Defined at lib/data/function.lisp:124:2*

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
*Macro defined at lib/data/function.lisp:8:2*

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
*Macro defined at lib/data/function.lisp:29:2*

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
*Defined at lib/data/function.lisp:116:2*

Return the value `X` unmodified.

## `(invokable? x)`
*Defined at lib/data/function.lisp:72:2*

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
*Defined at lib/data/function.lisp:142:2*

Index `X` with `KEY` and invoke the resulting function with `X` and `ARGS`.

## `(slot? symb)`
*Defined at lib/data/function.lisp:3:2*

Test whether `SYMB` is a slot. For this, it must be a symbol, whose
contents are `<>`.

