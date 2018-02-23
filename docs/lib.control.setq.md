---
title: control/setq
---
# control/setq
## `(dec! address)`
*Macro defined at lib/control/setq.lisp:153:2*

Decrements the value described by `ADDRESS` by 1.

### Example
```cl
> (with (x 1)
.   (dec! x)
.   x)
out = 0
```

## `(defsetq pattern repl)`
*Macro defined at lib/control/setq.lisp:50:2*

Define the `setq!`/`over!` `PATTERN` with the replacement `REPL`. The
replacement must be a lambda, which is going to be applied to the
(quoted) replacement. Captures in the pattern are also available in
the replacement's scope.

Note that the value given to `REPL` is *not* a value: Rather, it is a
function that decides what the new value should be. The returned
value must be a list, preferably of the form

```cl
(progn ... ; modify the value
       the-value)
```

That is - modify the value, then return it.

### Example:
```cl
> (defsetq
.   (car ?addr)
.   (lambda (val)
.     `(.<! ,addr 1 (,val (.> ,addr 1)))))
```

## `(inc! address)`
*Macro defined at lib/control/setq.lisp:141:2*

Increments the value described by `ADDRESS` by 1.

### Example
```cl
> (with (x 1)
.   (inc! x)
.   x)
out = 2
```

## `(over! address fun)`
*Macro defined at lib/control/setq.lisp:22:2*

Replace the value at `ADDRESS` according to `FUN`.

### Examples:
```
> (define list '(1 2 3))
out = (1 2 3)
> (over! (car list) (cut = <> 2))
out = (false 2 3)
```

## `(setq! address value)`
*Macro defined at lib/control/setq.lisp:36:2*

Replace the value at `ADDRESS` with `VALUE`.

### Examples:
```
> (define list '(1 2 3))
out = (1 2 3)
> (setq! (car list) 3)
out = (3 2 3)
```

