---
title: data/set
---
# data/set
This module implements hash sets as backed by hash maps, optionally
with a custom hash function.

## `(cardinality set)`
*Defined at lib/data/set.lisp:137:2*

Return the number of elements in `SET`.

### Example:
```cl
> (cardinality (set-of 1 2 3))
out = 3
> (cardinality (set-of 1 1 2))
out = 2
```

## `(disjoint? &sets)`
*Defined at lib/data/set.lisp:152:2*

Is the intersection of `SETS` empty?

### Example:
```cl
> (disjoint? (set-of 1 2 3) (set-of 3 4 5))
out = false
> (disjoint? (set-of 1 2 3) (set-of 4 5 6))
out = true
```

## `(element? set val)`
*Defined at lib/data/set.lisp:36:2*

Check if `VAL` is an element of `SET`.

### Example:
```cl
> (element? (set-of 1 2 3) 1)
out = true
```

## `(insert set &vals)`
*Defined at lib/data/set.lisp:67:2*

Build a copy of `SET` with VALs inserted.

### Example
```cl
> (insert (set-of 1 2 3) 4 5 6)
out = «hash-set: 1 2 3 4 5 6»
```

## `(insert! set &vals)`
*Defined at lib/data/set.lisp:48:2*

Insert `VALS` into `SET`.

### Example
```cl
> (define set (set-of 1 2 3))
out = «hash-set: 1 2 3»
> (insert! set 4)
out = «hash-set: 1 2 3 4»
> set
out = «hash-set: 1 2 3 4»
```

## `(intersection &sets)`
*Defined at lib/data/set.lisp:106:2*

The set of values that occur in all the `SETS`.

### Example:
```cl
> (intersection (set-of 1 2 3) (set-of 3 4 5))
out = «hash-set: 3»
> (intersection (set-of 1 2 3) (set-of 3 4 5) (set-of 7 8 9))
out = «hash-set: »
```

## `(make-set hash)`
*Defined at lib/data/set.lisp:6:2*

Create a new, empty set with the given `HASH-FUNCTION`. If no
hash function is given, [`make-set`](lib.data.set.md#make-set-hash) defaults to using object
identity, that is, [`id`](lib.data.function.md#id-x).

**Note**: Comparison for sets also compares their hash function
with pointer equality, meaning that sets will only compare equal
if their hash function is _the same object_.

### Example
```
> (make-set id)
out = «hash-set: »
```

## `(set->list set)`
*Defined at lib/data/set.lisp:176:2*

Convert `SET` to a list. Note that, since hash sets have no specified
order, the list will not nescessarily be sorted.

## `(set-of &values)`
*Defined at lib/data/set.lisp:164:2*

Create the set containing `VALUES` with the default hash function.

### Example:
```cl
> (set-of 1 2 3)
out = «hash-set: 1 2 3»
```

## `(union &sets)`
*Defined at lib/data/set.lisp:84:2*

The set of values that occur in any set in the `SETS`.

### Example:
```cl
> (union (set-of 1 2 3) (set-of 4 5 6))
out = «hash-set: 1 2 3 4 5 6»
> (union (set-of 1 2) (set-of 2 3) (set-of 3 4))
out = «hash-set: 1 2 3 4»
```

## Undocumented symbols
 - `$set` *Defined at lib/data/set.lisp:6:2*
 - `(set? set)` *Defined at lib/data/set.lisp:6:2*
