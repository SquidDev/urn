---
title: math/complex
---
# math/complex
## `(->polar z)`
*Defined at lib/math/complex.lisp:103:2*

Get the [`magnitude`](lib.math.complex.md#magnitude-z) and [`angle`](lib.math.complex.md#angle-z) of complex number `Z`.

### Example
```cl
> (first (->polar (complex 3 4)))
out = 5
> (math/deg (second (-> polar (complex 2 2))))
out = 45
 ```

## `(angle z)`
*Defined at lib/math/complex.lisp:149:2*

Get the angle of complex number `Z`.

If you need the [`magnitude`](lib.math.complex.md#magnitude-z) as well, one should probably use
[`->polar`](lib.math.complex.md#-polar-z).

### Example
```cl
> (math/floor (math/deg (angle (complex 2 2))))
out = 45
```

## `(complex r i)`
*Defined at lib/math/complex.lisp:16:2*

Represents a complex number, formed of a [`real`](lib.math.complex.md#real-complex) and [`imaginary`](lib.math.complex.md#imaginary-complex)
part.

## `(conjugate z)`
*Defined at lib/math/complex.lisp:91:2*

Get the complex conjugate of `Z`.

### Example
```cl
> (conjugate (complex 1 2))
out = 1-2i
```

## `(imaginary complex)`
*Defined at lib/math/complex.lisp:16:2*

The imaginary part of this [`complex`](lib.math.complex.md#complex-r-i) number.

## `(magnitude z)`
*Defined at lib/math/complex.lisp:135:2*

Get the magnitude of complex number `Z`.

If you need the [`angle`](lib.math.complex.md#angle-z) as well, one should probably use
[`->polar`](lib.math.complex.md#-polar-z).

### Example
```cl
> (magnitude (complex 3 4))
out = 5
```

## `(polar-> magnitude angle)`
*Defined at lib/math/complex.lisp:122:2*

Create a complex number from the given `MAGNITUDE` and `ANGLE`.

### Example
```cl
> (polar-> (math/sqrt 2) (math/rad 45))
out = 1+1i
```

## `(real complex)`
*Defined at lib/math/complex.lisp:16:2*

The real part of this [`complex`](lib.math.complex.md#complex-r-i) number.

## Undocumented symbols
 - `$complex` *Defined at lib/math/complex.lisp:16:2*
 - `(complex? complex)` *Defined at lib/math/complex.lisp:16:2*
