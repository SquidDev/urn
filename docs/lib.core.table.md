---
title: core/table
---
# core/table
## `(.<! x &keys value)`
*Macro defined at lib/core/table.lisp:54:2*

Set the value at `KEYS` in the structure `X` to `VALUE`.

## `(.> x &keys)`
*Macro defined at lib/core/table.lisp:48:2*

Index the structure `X` with the sequence of accesses given by `KEYS`.

## `(copy-of struct)`
*Defined at lib/core/table.lisp:123:2*

Create a shallow copy of `STRUCT`.

## `(create-lookup values)`
*Defined at lib/core/table.lisp:154:2*

Convert `VALUES` into a lookup table, with each value being converted to
a key whose corresponding value is the value's index.

## `(empty-struct? xs)`
*Defined at lib/core/table.lisp:101:2*

Check that `XS` is the empty struct.

### Example
```cl
> (empty-struct? {})
out = true
> (empty-struct? { :a 1 })
out = false
```

## `(fast-struct &entries)`
*Defined at lib/core/table.lisp:88:2*

`A` variation of [`struct`](lib.core.table.md#struct-entries), which will not perform any coercing of the
`KEYS` in entries.

Note, if you know your values at compile time, it is more performant
to use a struct literal.

## `(iter-pairs table func)`
*Defined at lib/core/table.lisp:119:2*

Iterate over `TABLE` with a function `FUNC` of the form `(lambda (key val) ...)`

## `(keys st)`
*Defined at lib/core/table.lisp:137:2*

Return the keys in the structure `ST`.

## `(list->struct list)`
*Defined at lib/core/table.lisp:32:2*

Converts a `LIST` to a structure, mapping an index to the element in the
list. Note that `nil` elements may not be mapped correctly.

### Example
```cl
> (list->struct '("foo"))
out = {1 "foo"}
```

## `(merge &structs)`
*Defined at lib/core/table.lisp:129:2*

Merge all tables in `STRUCTS` together into a new table.

## `(nkeys st)`
*Defined at lib/core/table.lisp:113:2*

Return the number of keys in the structure `ST`.

## `(struct &entries)`
*Defined at lib/core/table.lisp:62:2*

Return the structure given by the list of pairs `ENTRIES`. Note that, in
contrast to variations of [`let*`](lib.core.base.md#let-vars-body), the pairs are given "unpacked":
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

## `(struct->list tbl)`
*Defined at lib/core/table.lisp:7:2*

Converts a structure `TBL` that is a list by having its keys be indices
to a regular list.

### Example
```cl
> (struct->list { 1 "foo" 2 "bar" })
out = ("foo" "bar")
```

## `(struct->list! tbl)`
*Defined at lib/core/table.lisp:19:2*

Converts a structure `TBL` that is a list by having its keys be indices
to a regular list. This differs from `struct->list` in that it mutates
its argument.
### Example
```cl
> (struct->list! { 1 "foo" 2 "bar" })
out = ("foo" "bar")
```

## `(update-struct st &keys)`
*Defined at lib/core/table.lisp:149:2*

Create a new structure based of `ST`, setting the values given by the
pairs in `KEYS`.

## `(values st)`
*Defined at lib/core/table.lisp:143:2*

Return the values in the structure `ST`.

## Undocumented symbols
 - `len#` *Native defined at lib/lua/basic.lisp:19:1*
 - `next` *Native defined at lib/lua/basic.lisp:29:1*
