---
title: math/vector
---
# math/vector
## `(angle x y)`
*Defined at lib/math/vector.lisp:175:2*

Compute the angle between vectors `X` and `Y`.

### Example
```cl
> (math/floor (math/deg (angle (vector 1 0) (vector 1 1))))
out = 45
```

## `(cross x y)`
*Defined at lib/math/vector.lisp:140:2*

Compute the vector cross product of `X` and `Y`.

### Example
```cl
> (cross (vector 1 0 0) (vector 0 1 0))
out = [0 0 1]
```

## `(dot x y)`
*Defined at lib/math/vector.lisp:119:2*

Compute the dot product of vectors `X` and `Y`.

### Example
```cl
> (dot (vector 1 2 3) (vector 3 1 2))
out = 11
```

## `(list->vector items)`
*Defined at lib/math/vector.lisp:31:2*

Create a new vector from a list of values.

### Example
```cl
> (list->vector '(1 2 3))
out = [1 2 3]
```

## `(norm x)`
*Defined at lib/math/vector.lisp:164:2*

Compute the norm of vector `X` (i.e. it's length).

### Example
```cl
> (norm (vector 3/2 4/2))
out = 5/2
```

## `(null size)`
*Defined at lib/math/vector.lisp:200:2*

Create a vector with a magnitude of 0.

### Example
```cl
> (null 3)
out = [0 0 0]
```

## `(unit x)`
*Defined at lib/math/vector.lisp:185:2*

Convert the vector `X` into the unit vector. Namely, its direction is
the same but the magnitude is 1.

### Example
```cl
> (unit (vector 3/2 4/2))
out = [3/5 4/5]
```

## `(vector &items)`
*Defined at lib/math/vector.lisp:17:2*

Create a new vector from several values.

### Example
```cl
> (vector 1 2 3)
out = [1 2 3]
```

## `(vector-dim vector)`
*Defined at lib/math/vector.lisp:7:2*

The dimension of this vector.

## `(vector-item x i)`
*Defined at lib/math/vector.lisp:53:2*

Get the `I` th element in vector `X`.

### Example
```cl
> (define a (vector 5 4 3 2 1))
> (vector-item a 2)
out = 4
> (vector-item a 5)
out = 1
```

## Undocumented symbols
 - `$vector` *Defined at lib/math/vector.lisp:7:2*
 - `(vector? vector)` *Defined at lib/math/vector.lisp:7:2*
