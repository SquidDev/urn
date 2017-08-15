---
title: function
---
# function
## `(-> x &funcs)`
*Macro defined at lib/function.lisp:59:1*

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

## `(comp &fs)`
*Defined at lib/function.lisp:112:1*

Return the pointwise composition of all functions in `FS`.

### Example:
```cl
> ((comp succ (cut + <> 2) (cut * <> 2))
.  2)
out = 7
```

## `(compose f g)`
*Defined at lib/function.lisp:98:1*

Return the pointwise composition of functions `F` and `G`.

### Example:
```cl
> ((compose (cut + <> 2) (cut * <> 2))
.  2)
out = 6
```

## `(cut &func)`
*Macro defined at lib/function.lisp:16:1*

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
*Macro defined at lib/function.lisp:37:1*

Partially apply a function `FUNC`, where each `<>` is replaced by an
argument to a function. Values are evaluated when this function is
defined.

### Example
```cl
> (define double (cute * <> 2))
> (double 3)
out = 6
```

## `(invokable? x)`
*Defined at lib/function.lisp:80:1*

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

## `(slot? symb)`
*Defined at lib/function.lisp:11:1*

Test whether `SYMB` is a slot. For this, it must be a symbol, whose
contents are `<>`.

