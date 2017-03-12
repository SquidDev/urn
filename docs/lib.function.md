---
title: function
---
# function
## `(-> x &funcs)`
*Macro defined at lib/function.lisp:59:1*

Chain a series of method calls together. If the list contains `<>`
then the value is placed there, otherwise the expression is invoked with
the previous entry as an argument.

### Example
```
> (-> '(1 2 3)
    succ
    (* <> 2))
(4 6 8)
```

## `(compose f g)`
*Defined at lib/function.lisp:100:1*

Return the pointwise composition of functions `F` and `G`. This corresponds to
the mathematical operator `∘`, i.e. `(compose f g)` corresponds to
`h(x) = f (g x)` (`(lambda (x) (f (g x)))`).

## `(cut &func)`
*Macro defined at lib/function.lisp:16:1*

Partially apply a function `FUNC`, where each `<>` is replaced by an
argument to a function. Values are evaluated every time the resulting
function is called.

### Example
```
> (define double (cut * <> 2))
> (double 3)
6
```

## `(cute &func)`
*Macro defined at lib/function.lisp:37:1*

Partially apply a function `FUNC`, where each `<>` is replaced by an
argument to a function. Values are evaluated when this function is
defined.

### Example
```
> (define double (cute * <> 2))
> (double 3)
6
```

## `(invokable? x)`
*Defined at lib/function.lisp:82:1*

Test if the expression `X` makes sense as something that can be applied to a set
of arguments.

### Example
```
> (invokable? invokable?)
true
> (invokable? nil)
false
> (invokable? (setmetatable (empty-struct) (struct :__call (lambda (x) (print! "hello")))))
true
```

## `(slot? symb)`
*Defined at lib/function.lisp:11:1*

Test whether `SYMB` is a slot. For this, it must be a symbol, whose contents
are `<>`.

