---
title: table
---
# table
## `(.<! x &keys value)`
*Macro defined at lib/table.lisp:149:1*

Set the value at `KEYS` in the structure `X` to `VALUE`.

## `(.> x &keys)`
*Macro defined at lib/table.lisp:143:1*

Index the structure `X` with the sequence of accesses given by `KEYS`.

## `(assoc list key or-val)`
*Defined at lib/table.lisp:9:1*

Return the value given by `KEY` in the association list `LIST`, or, in the
case that it does not exist, the value `OR`-`VAL`, which can be nil.

### Example:
```cl
> (assoc '(("foo" 1) ("bar" 2)) "foo" "?")
out = 1
> (assoc '(("foo" 1) ("bar" 2)) "baz" "?")
out = "?"
```

## `(assoc->struct list)`
*Defined at lib/table.lisp:81:1*

Convert the association list `LIST` into a structure. Much like
[`assoc`](lib.table.md#assoc-list-key-or-val), in the case there are several values bound to the same key,
the first value is chosen.

### Example:
```cl
> (assoc->struct '(("a" 1)))
out = {"a" 1}
```

## `(assoc? list key)`
*Defined at lib/table.lisp:28:1*

Check that `KEY` is bound in the association list `LIST`.

### Example:
```cl
> (assoc? '(("foo" 1) ("bar" 2)) "foo")
out = true
> (assoc? '(("foo" 1) ("bar" 2)) "baz")
out = false
```

## `(create-lookup values)`
*Defined at lib/table.lisp:243:1*

Convert `VALUES` into a lookup table, with each value being converted to
a key whose corresponding value is the value's index.

## `(empty-struct? xs)`
*Defined at lib/table.lisp:196:1*

Check that `XS` is the empty struct.

### Example
```cl
> (empty-struct? {})
out = true
> (empty-struct? { :a 1 })
out = false
```

## `(extend ls key val)`
*Defined at lib/table.lisp:57:1*

Extend the association list `LIST`_ by inserting `VAL`, bound to the key
`KEY`, overriding any previous value.

### Example:
```cl
> (extend '(("foo" 1)) "bar" 2)
out = (("bar" 2) ("foo" 1))
```

## `(fast-struct &entries)`
*Defined at lib/table.lisp:183:1*

`A` variation of [`struct`](lib.table.md#struct-entries), which will not perform any coercing of the
`KEYS` in entries.

Note, if you know your values at compile time, it is more performant
to use a struct literal.

## `(insert alist key val)`
*Defined at lib/table.lisp:46:1*

Extend the association list `ALIST` by inserting `VAL`, bound to the key
`KEY`.

### Example:
```cl
> (insert '(("foo" 1)) "bar" 2)
out = (("foo" 1) ("bar" 2))
```

## `(insert! alist key val)`
*Defined at lib/table.lisp:68:1*

Extend the association list `ALIST` in place by inserting `VAL`, bound to
the key `KEY`.

### Example:
```cl
> (define x '(("foo" 1)))
> (insert! x "bar" 2)
> x
out = (("foo" 1) ("bar" 2))
```

## `(iter-pairs table func)`
*Defined at lib/table.lisp:214:1*

Iterate over `TABLE` with a function `FUNC` of the form `(lambda (key val) ...)`

## `(keys st)`
*Defined at lib/table.lisp:226:1*

Return the keys in the structure `ST`.

## `(merge &structs)`
*Defined at lib/table.lisp:218:1*

Merge all tables in `STRUCTS` together into a new table.

## `(nkeys st)`
*Defined at lib/table.lisp:208:1*

Return the number of keys in the structure `ST`.

## `(struct &entries)`
*Defined at lib/table.lisp:157:1*

Return the structure given by the list of pairs `ENTRIES`. Note that, in
contrast to variations of [`let`](lib.binders.md#let-vars-body), the pairs are given "unpacked":
Instead of invoking

```cl
(struct [(:foo bar)])
```
or
```cl
(struct {:foo bar})
```
you must instead invoke it like
```cl
> (struct :foo "bar")
out = {"foo" "bar"}
```

## `(struct->assoc tbl)`
*Defined at lib/table.lisp:102:1*

Convert the structure `TBL` into an association list. Note that
`(eq? x (struct->assoc (assoc->struct x)))` is not guaranteed,
because duplicate elements will be removed.

### Example
```cl
> (struct->assoc { :a 1 })
out = (("a" 1))
```

## `(struct->list tbl)`
*Defined at lib/table.lisp:117:1*

Converts a structure `TBL` that is a list by having its keys be indices
to a regular list.

### Example
```cl
> (struct->list { 1 "foo" 2 "bar" })
out = ("foo" "bar")
```

## `(struct->list! tbl)`
*Defined at lib/table.lisp:129:1*

Converts a structure `TBL` that is a list by having its keys be indices
to a regular list. This differs from `struct->list` in that it mutates
its argument.
### Example
```cl
> (struct->list! { 1 "foo" 2 "bar" })
out = ("foo" "bar")
```

## `(update-struct st &keys)`
*Defined at lib/table.lisp:238:1*

Create a new structure based of `ST`, setting the values given by the
pairs in `KEYS`.

## `(values st)`
*Defined at lib/table.lisp:232:1*

Return the values in the structure `ST`.

## Undocumented symbols
 - `getmetatable` *Native defined at lib/lua/basic.lisp:25:1*
 - `len#` *Native defined at lib/lua/basic.lisp:19:1*
 - `next` *Native defined at lib/lua/basic.lisp:29:1*
 - `setmetatable` *Native defined at lib/lua/basic.lisp:41:1*
