---
title: control/comparison
---
# control/comparison
Provides macros for various comparison operators.

## `/=`
*Macro defined at lib/control/comparison.lisp:54:2*

Check whether `A` is not equal to `B`, `B` is not equal to the first element
in `REST`, etc...

This will lazily evaluate each value: if `A` is equal to `B`, then no
subsequent arguments will be evaluated.

### Example:
```cl
> (let [(a 1)
.       (b 2)]
.   (/= a b 1))
out = true
> (with (a 1)
.   (/= a 1))
out = false
```

## `<`
*Macro defined at lib/control/comparison.lisp:72:2*

Check whether `A` is smaller than `B`, `B` is smaller than the first element
in `REST`, and so on for all subsequent arguments.

This will lazily evaluate each value: if `A` is greater or equal to `B`,
then no subsequent arguments will be evaluated.

### Example:
```cl
> (with (a 3)
.   (< 1 a 5))
out = true
```

## `<=`
*Macro defined at lib/control/comparison.lisp:100:2*

Check whether `A` is smaller or equal to `B`, `B` is smaller or equal to the
first element in `REST`, and so on for all subsequent arguments.

This will lazily evaluate each value: if `A` is larger than `B`,
then no subsequent arguments will be evaluated.

### Example:
```cl
> (with (a 3)
.   (<= 1 a 5))
out = true
```

## `=`
*Macro defined at lib/control/comparison.lisp:37:2*

Check whether `A`, `B` and all items in `REST` are equal.

This will lazily evaluate each value: if `A` is not equal to `B`, then no
subsequent arguments will be evaluated.

### Example:
```cl
> (let [(a 1)
.       (b 2)]
.   (= 1 a b))
out = false
> (with (a 1)
.   (= a 1))
out = true
```

## `>`
*Macro defined at lib/control/comparison.lisp:86:2*

Check whether `A` is larger than `B`, `B` is larger than the first element
in `REST`, and so on for all subsequent arguments.

This will lazily evaluate each value: if `A` is smaller or equal to `B`,
then no subsequent arguments will be evaluated.

### Example:
```cl
> (with (a 3)
.   (> 5 a 1))
out = true
```

## `>=`
*Macro defined at lib/control/comparison.lisp:114:2*

Check whether `A` is larger or equal to `B`, `B` is larger or equal to the
first element in `REST`, and so on for all subsequent arguments.

This will lazily evaluate each value: if `A` is smaller than `B`,
then no subsequent arguments will be evaluated.

### Example:
```cl
> (with (a 3)
.   (>= 5 a 1))
out = true
```

