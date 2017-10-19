---
title: data/alist
---
# data/alist
## `(assoc list key or-val)`
*Defined at lib/data/alist.lisp:3:2*

Return the value given by `KEY` in the association list `LIST`, or, in the
case that it does not exist, the value `OR-VAL`, which can be nil.

### Example:
```cl
> (assoc '(("foo" 1) ("bar" 2)) "foo" "?")
out = 1
> (assoc '(("foo" 1) ("bar" 2)) "baz" "?")
out = "?"
```

## `(assoc->struct list)`
*Defined at lib/data/alist.lisp:72:2*

Convert the association list `LIST` into a structure. Much like
[`assoc`](lib.data.alist.md#assoc-list-key-or-val), in the case there are several values bound to the same key,
the first value is chosen.

### Example:
```cl
> (assoc->struct '(("a" 1)))
out = {"a" 1}
```

## `(assoc? list key)`
*Defined at lib/data/alist.lisp:22:2*

Check that `KEY` is bound in the association list `LIST`.

### Example:
```cl
> (assoc? '(("foo" 1) ("bar" 2)) "foo")
out = true
> (assoc? '(("foo" 1) ("bar" 2)) "baz")
out = false
```

## `(extend ls key val)`
*Defined at lib/data/alist.lisp:48:2*

Extend the association list `LIST`_ by inserting `VAL`, bound to the key
`KEY`, overriding any previous value.

### Example:
```cl
> (extend '(("foo" 1)) "bar" 2)
out = (("bar" 2) ("foo" 1))
```

## `(insert alist key val)`
*Defined at lib/data/alist.lisp:37:2*

Extend the association list `ALIST` by inserting `VAL`, bound to the key
`KEY`.

### Example:
```cl
> (insert '(("foo" 1)) "bar" 2)
out = (("foo" 1) ("bar" 2))
```

## `(insert! alist key val)`
*Defined at lib/data/alist.lisp:59:2*

Extend the association list `ALIST` in place by inserting `VAL`, bound to
the key `KEY`.

### Example:
```cl
> (define x '(("foo" 1)))
> (insert! x "bar" 2)
> x
out = (("foo" 1) ("bar" 2))
```

## `(struct->assoc tbl)`
*Defined at lib/data/alist.lisp:92:2*

Convert the structure `TBL` into an association list. Note that
`(eq? x (struct->assoc (assoc->struct x)))` is not guaranteed,
because duplicate elements will be removed.

### Example
```cl
> (struct->assoc { :a 1 })
out = (("a" 1))
```

