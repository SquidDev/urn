---
title: extra/do
---
# extra/do
## `(do &stmts)`
*Macro defined at lib/extra/do.lisp:5:1*

Comprehend over several lists as defined by `STMTS`.

### Example:
```cl
> (do (<- x (range 1 10))
.     (<- y (range 1 10))
.     (when (even? (+ x y))
.       (* x y))))
out = (1 3 5 7 9 4 8 12 16 20 3 9 15 21 27 8 16 24 32 40 5 15 25
       35 45 12 24 36 48 60 7 21 35 49 63 16 32 48 64 80 9 27 45
       63 81 20 40 60 80 100)
```

