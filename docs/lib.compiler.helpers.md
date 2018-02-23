---
title: compiler/helpers
---
# compiler/helpers
## `(exported-vars)`
*Macro defined at lib/compiler/helpers.lisp:5:2*

Generate a struct with all variables exported in the current module.

### Example:
```cl
> (let [(a 1)]
.   (exported-vars))
out = {"a" 1}
```

```cl
(define x 1)
(define y 2)
(define z 3)
(exported-vars) ;; { :x 1 :y 2 :z 3 }
```

