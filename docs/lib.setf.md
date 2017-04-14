---
title: setf
---
# setf
## `(.>/over! selector fun)`
*Macro defined at lib/setf.lisp:94:1*

An implementation of [`over!`](lib.setf.md#over-obj-fun) for table access.

This should not be used directly, but via [`over!`](lib.setf.md#over-obj-fun).

### Example
```cl
(over! (.> foo :bar) (cut + <> 2))
 ```

## `(.>/setf! selector val)`
*Macro defined at lib/setf.lisp:33:1*

An implementation of [`setf!`](lib.setf.md#setf-obj-val) for table acccess.

This should not be used directly, but via [`setf!`](lib.setf.md#setf-obj-val) or [`.<!`](lib.table.md#-x-keys-value)
instead.

### Example
```cl
(setf! (.> foo :bar) 123)
```

## `(car/over! selector fun)`
*Macro defined at lib/setf.lisp:124:1*

An implementation of [`over!`](lib.setf.md#over-obj-fun) for [`car`](lib.list.md#car-x).

This should not be used directly, but via [`over!`](lib.setf.md#over-obj-fun) instead.

### Example
```cl
(over! (car foo) (cut + <> 2))
```

## `(car/setf! selector val)`
*Macro defined at lib/setf.lisp:56:1*

An implementation of [`setf!`](lib.setf.md#setf-obj-val) for [`car`](lib.list.md#car-x).

This should not be used directly, but via [`setf!`](lib.setf.md#setf-obj-val) instead.

### Example
```cl
(setf! (car foo) 123)
```

## `(dec! x)`
*Macro defined at lib/setf.lisp:141:1*

Decrement the value selector `X` in place.

## `(inc! x)`
*Macro defined at lib/setf.lisp:137:1*

Increment the value selector `X` in place.

## `(nth/over! selector fun)`
*Macro defined at lib/setf.lisp:109:1*

An implementation of [`over!`](lib.setf.md#over-obj-fun) for list access.

This should not be used directly, but via [`over!`](lib.setf.md#over-obj-fun) instead.

### Example
```cl
(over! (nth foo 2) (cut + <> 2))
```

## `(nth/setf! selector val)`
*Macro defined at lib/setf.lisp:45:1*

An implementation of [`setf!`](lib.setf.md#setf-obj-val) for list access.

This should not be used directly, but via [`setf!`](lib.setf.md#setf-obj-val) instead.

### Example
```cl
(setf! (nth foo 2) 123)
```

## `(over! obj fun)`
*Macro defined at lib/setf.lisp:67:1*

Apply function `FUN` over the location selector `OBJ`, storing the result
in the same place.

If `OBJ` is a symbol, then the symbol will just apply `FUN`, and set the
symbol again.

Otherwise, `OBJ` must be a list. This should be in the form of the
getter you'd normally use to access that value. For instance, to set
the first element of the list, you'd use `(over! (car xs) succ)`.

This function given in the getter will have `/over!` appended to it,
and looked up in the current scope. This definition will then be used
to generate the accessor and setter. Implementations should cache
accesses, meaning that lists and structures are not indexed multiple
times.

### Example
```cl
(over! foo (cut + <> 2)) ;; Add 2 to foo
(over! (.> foo :bar) (out + <> 2)) ;; Add 2 to the value of index
                                   ;; bar in structure foo.
```

## `(setf! obj val)`
*Macro defined at lib/setf.lisp:9:1*

Set the location selector `OBJ` to `VAL`.

If `OBJ` is a symbol, then the symbol will just have its variable set,
identical to using `set!`.

Otherwise, `OBJ` must be a list. This should be in the form of the
getter you'd normally use to access that value. For instance, to set
the first element of the list, you'd use `(setf! (car xs) 42)`.

This function given in the getter will have `/setf!` appended to it,
and looked up in the current scope. This definition will then be used
to generate the setter.

### Example
```cl
(setf! foo 123) ;; Set the symbol foo to 123
(setf! (.> foo :bar) 123) ;; Set the value of index bar in structure
                          ;; foo to 123.
```

