---
title: setf
---
# setf
## `(dec! x)`
*Macro defined at lib/setf.lisp:76:1*

Decrement the value selector `X` in place.

## `(inc! x)`
*Macro defined at lib/setf.lisp:72:1*

Increment the value selector `X` in place.

## `(over! obj fun)`
*Macro defined at lib/setf.lisp:41:1*

Apply function `FUN` over the location selector `OBJ`, storing the result
in the same place.

If `OBJ` is a symbol, then the symbol will just apply `FUN`, and set the
symbol again.

Otherwise, `OBJ` must be a list. This should be in the form of the
getter you'd normally use to access that value. For instance, to set
the first element of the list, you'd use `(over! (car xs) succ)`.

This function given in the getter will have `/over!` appended to it,
and looked up in the scope the getter is defined in (or the current
scope if not found). This definition will then be used to generate the
accessor and setter. Implementations should cache accesses, meaning
that lists and structures are not indexed multiple times.

### Example
```cl
(over! foo (cut + <> 2)) ;; Add 2 to foo
(over! (.> foo :bar) (out + <> 2)) ;; Add 2 to the value of index
                                   ;; bar in structure foo.
```

## `(setf! obj val)`
*Macro defined at lib/setf.lisp:12:1*

Set the location selector `OBJ` to `VAL`.

If `OBJ` is a symbol, then the symbol will just have its variable set,
identical to using `set!`.

Otherwise, `OBJ` must be a list. This should be in the form of the
getter you'd normally use to access that value. For instance, to set
the first element of the list, you'd use `(setf! (car xs) 42)`.

This function given in the getter will have `/setf!` appended to it,
and looked up in the scope the getter is defined in (or the current
scope if not found). This definition will then be used to generate the
setter.

### Example
```cl
(setf! foo 123) ;; Set the symbol foo to 123
(setf! (.> foo :bar) 123) ;; Set the value of index bar in structure
                          ;; foo to 123.
```

