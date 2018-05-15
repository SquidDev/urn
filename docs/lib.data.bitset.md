---
title: data/bitset
---
# data/bitset
This module implements bit sets

## `(bitsets-and x y)`
*Defined at lib/data/bitset.lisp:260:2*

Performs a logical `AND` between two bitsets and returns the result as a new bitset

### Example:
```cl
> (define a (make-bitset))
out = «bitset: »
> (define b (make-bitset))
out = «bitset: »
> (set-bit! a 2)
out = nil
> (set-bit! b 2)
out = nil
> (bitsets-and a b)
out = «bitset: 00000004»
```

## `(bitsets-or x y)`
*Defined at lib/data/bitset.lisp:288:2*

Performs a logical `OR` between two bitsets and returns the result as a new bitset

### Example:
```cl
> (define a (make-bitset))
out = «bitset: »
> (define b (make-bitset))
out = «bitset: »
> (set-bit! a 0)
out = nil
> (set-bit! b 1)
out = nil
> (bitsets-or a b)
out = «bitset: 00000003»
```

## `(bitsets-xor x y)`
*Defined at lib/data/bitset.lisp:322:2*

Performs a logical `XOR` between two bitsets and returns the result as a new bitset

### Example:
```cl
> (define a (make-bitset))
out = «bitset: »
> (define b (make-bitset))
out = «bitset: »
> (set-bit! a 0)
out = nil
> (set-bit! a 1)
out = nil
> (set-bit! b 1)
out = nil
> (bitsets-xor a b)
out = «bitset: 00000001»
```

## `(cardinality bs)`
*Defined at lib/data/bitset.lisp:210:2*

Returns the number of set bits in the bitset `BS`

### Example:
```cl
> (define bs (make-bitset))
out = «bitset: »
> (set-bit! bs 1)
out = nil
> (set-bit! bs 4)
out = nil
> (cardinality bs)
out = 2
```

## `(clear-bit! bs bit)`
*Defined at lib/data/bitset.lisp:92:2*

Clears the bit in the bitset `BS` with the specified index `BIT`

```cl
> (define bs (make-bitset))
out = «bitset: »
> (set-bit! bs 5)
out = nil
> bs
out = «bitset: 00000020»
> (clear-bit! bs 5)
out = nil
> bs
out = «bitset: 00000000»
```

## `(flip-bit! bs bit)`
*Defined at lib/data/bitset.lisp:131:2*

Inverts the value of the bit in the bitset `BS` with the specified index `BIT`

### Example:
```cl
> (define bs (make-bitset))
out = «bitset: »
> (flip-bit! bs 2)
out = nil
> bs
out = «bitset: 00000004»
> (flip-bit! bs 2)
out = nil
> bs
out = «bitset: 00000000»
```

## `(get-bit bs bit)`
*Defined at lib/data/bitset.lisp:54:2*

Returns the value of the bit in the bitset `BS` with the specified index `BIT`

### Example:
```cl
> (define bs (make-bitset))
out = «bitset: »
> (set-bit! bs 5)
out = nil
> (get-bit bs 5)
out = true
```

## `(intersects x y)`
*Defined at lib/data/bitset.lisp:233:2*

Tests if two bitsets share any of the same set bits

### Example:
```cl
> (define a (make-bitset))
out = «bitset: »
> (define b (make-bitset))
out = «bitset: »
> (set-bit! a 2)
out = nil
> (set-bit! b 2)
out = nil
> (intersects a b)
out = true
```

## `(make-bitset other)`
*Defined at lib/data/bitset.lisp:28:2*

Creates a new, empty bitset

## `(next-clear-bit bs start)`
*Defined at lib/data/bitset.lisp:181:2*

Finds the next clear bit in the bitset `BS` after the index `START`. If no clear bit is found, -1 is returned

### Example:
```cl
> (define bs (make-bitset))
out = «bitset: »
> (set-bit! bs 0)
out = nil
> (set-bit! bs 1)
out = nil
> (next-clear-bit bs 0)
out = 2
```

## `(next-set-bit bs start)`
*Defined at lib/data/bitset.lisp:154:2*

Finds the next set bit in the bitset `BS` after the index `START`. If no set bit is found, -1 is returned

### Example:
```cl
> (define bs (make-bitset))
out = «bitset: »
> (set-bit! bs 5)
out = nil
> (next-set-bit bs 2)
out = 5
```

## `(set-bit! bs bit)`
*Defined at lib/data/bitset.lisp:73:2*

Sets the bit in the bitset `BS` with the specified index `BIT`

### Example:
```cl
> (define bs (make-bitset))
out = «bitset: »
> (set-bit! bs 5)
out = nil
> bs
out = «bitset: 00000020»
```

## `(set-bit-value! bs bit value)`
*Defined at lib/data/bitset.lisp:113:2*

Sets the value of the bit in the bitset `BS` with the specified index `BIT` to `VALUE`

```cl
> (define bs (make-bitset))
out = «bitset: »
> (set-bit-value! bs 2 true)
out = nil
> bs
out = «bitset: 00000004»
> (set-bit-value! bs 2 false)
out = nil
> bs
out = «bitset: 00000000»

## Undocumented symbols
 - `$bitset` *Defined at lib/data/bitset.lisp:28:2*
 - `(bitset? bitset)` *Defined at lib/data/bitset.lisp:28:2*
