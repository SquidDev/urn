---
title: math/matrix
---
# math/matrix
## `(echelon matrix)`
*Defined at lib/math/matrix.lisp:128:2*

Reduce the given `MATRIX` to row echelon form.

### Example:
```cl
> (echelon (matrix 3 2
.            1 2 3
.            4 5 6))
out = [1 1.25 1.5 // 0 1 2]
```

## `(height matrix)`
*Defined at lib/math/matrix.lisp:6:2*

The height of this matrix.

## `(identity dim)`
*Defined at lib/math/matrix.lisp:32:2*

Create the identity matrix with the given `DIM`.

### Example:
```cl
> (identity 2)
out = [1 0 // 0 1]
```

## `(invert matrix)`
*Defined at lib/math/matrix.lisp:206:2*

Invert the provided `MATRIX`.

### Example:
```cl
> (invert (matrix 2 2
.           1 2
.           3 4))
out = [-2 1 // 1.5 -0.5]
```

## `(matrix width height &items)`
*Defined at lib/math/matrix.lisp:13:2*

Create a new matrix with the given `WIDTH` and `HEIGHT`.

### Example:
```cl
> (matrix 2 2
.   1 2
.   3 4)
out = [1 2 // 3 4]
```

## `(matrix-item matrix y x)`
*Defined at lib/math/matrix.lisp:48:2*

Get the item in the provided `MATRIX` at `Y` `X`.

### Example:
```cl
> (define m (matrix 2 2
.             1 2
.             3 4))
> (matrix-item m 2 1)
out = 3
```

## `(reduced-echelon matrix)`
*Defined at lib/math/matrix.lisp:179:2*

Reduce the given `MATRIX` to reduced row echelon form.

### Example:
```cl
> (echelon (matrix 3 2
.            1 2 3
.            4 5 6))
out = [1 1.25 1.5 // 0 1 2]
```

## `(width matrix)`
*Defined at lib/math/matrix.lisp:6:2*

The width of this matrix.

## Undocumented symbols
 - `$matrix` *Defined at lib/math/matrix.lisp:6:2*
 - `(matrix? matrix)` *Defined at lib/math/matrix.lisp:6:2*
