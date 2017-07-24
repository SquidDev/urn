---
title: list
---
# list
List manipulation functions.

These include several often-used functions for manipulation of lists,
including functional programming classics such as [`map`](lib.list.md#map-fn-xss) and [`reduce`](lib.list.md#reduce-f-z-xs)
and useful patterns such as [`accumulate-with`](lib.list.md#accumulate-with-f-ac-z-xs).

Most of these functions are tail-recursive unless noted, which means
they will not blow up the stack. Along with the property of
tail-recursiveness, these functions also have favourable performance
characteristics.

## Glossary:
- **Constant time** The function runs in the same time regardless of the
  size of the input list.
- **Linear time** The runtime of the function is a linear function of
  the size of the input list.
- **Logarithmic time** The runtime of the function grows logarithmically
  in proportion to the size of the input list.
- **Exponential time** The runtime of the function grows exponentially
  in proportion to the size of the input list. This is generally a bad
  thing.

## `(\\ xs ys)`
*Defined at lib/list.lisp:271:1*

The difference between `XS` and `YS` (non-associative.)

### Example:
```
> (\ '(1 2 3) '(1 3 5 7))
out = (2)
```

## `(accumulate-with f ac z xs)`
*Defined at lib/list.lisp:589:1*

`A` composition of [`reduce`](lib.list.md#reduce-f-z-xs) and [`map`](lib.list.md#map-fn-xss).

Transform the values of `XS` using the function `F`, then accumulate them
starting form `Z` using the function `AC`.

This function behaves as if it were folding over the list `XS` with the
monoid described by (`F`, `AC`, `Z`), that is, `F` constructs the monoid, `AC`
is the binary operation, and `Z` is the zero element.

### Example:
```cl
> (accumulate-with tonumber + 0 '(1 2 3 4 5))
out = 15
```

## `(all p xs)`
*Defined at lib/list.lisp:312:1*

Test if all elements of `XS` match the predicate `P`.

### Example:
```cl
> (all symbol? '(foo bar baz))
true
> (all number? '(1 2 foo))
false
```

## `(any p xs)`
*Defined at lib/list.lisp:241:1*

Check for the existence of an element in `XS` that matches the predicate
`P`.

### Example:
```cl
> (any exists? '(nil 1 "foo"))
true
```

## `(append xs ys)`
*Defined at lib/list.lisp:526:1*

Concatenate `XS` and `YS`.

### Example:
```cl
> (append '(1 2) '(3 4))
out = (1 2 3 4)
``` 

## `(car x)`
*Defined at lib/list.lisp:34:1*

Return the first element present in the list `X`. This function operates
in constant time.

### Example:
```cl
> (car '(1 2 3))
out = 1
```

## `(cdr x)`
*Defined at lib/list.lisp:46:1*

Return the list `X` without the first element present. In the case that
`X` is nil, the empty list is returned. Due to the way lists are
represented internally, this function runs in linear time.

### Example:
```cl
> (cdr '(1 2 3))
out = (2 3)
```

## `(cons &xs xss)`
*Defined at lib/list.lisp:93:1*

Return a copy of the list `XSS` with the elements `XS` added to its head.

### Example:
```cl
> (cons 1 2 3 '(4 5 6))
out = (1 2 3 4 5 6)
```

## `(drop xs n)`
*Defined at lib/list.lisp:71:1*

Remove the first `N` elements of the list `XS`.

### Example:
```cl
> (drop '(1 2 3 4 5) 2)
out = (3 4 5)
```

## `(elem? x xs)`
*Defined at lib/list.lisp:333:1*

Test if `X` is present in the list `XS`.

### Example:
```cl
> (elem? 1 '(1 2 3))
true
> (elem? 'foo '(1 2 3))
false
```

## `(exclude p xs)`
*Defined at lib/list.lisp:230:1*

Return a list with only the elements of `XS` that don't match the
predicate `P`.

### Example:
```cl
> (exclude even? '(1 2 3 4 5 6))
out = '(1 3 5)
```

## `(filter p xs)`
*Defined at lib/list.lisp:219:1*

Return a list with only the elements of `XS` that match the predicate
`P`.

### Example:
```cl
> (filter even? '(1 2 3 4 5 6))
out = '(2 4 6)
```

## `(flat-map fn &xss)`
*Defined at lib/list.lisp:188:1*

Map the function `FN` over the lists `XSS`, then flatten the result
lists.

### Example:
```cl
> (flat-map list '(1 2 3) '(4 5 6))
out = 1 4 2 5 3 6
```

## `(flatten xss)`
*Defined at lib/list.lisp:536:1*

Concatenate all the lists in `XSS`. `XSS` must not contain elements which
are not lists.

### Example:
```cl
> (flatten '((1 2) (3 4)))
out = (1 2 3 4)
```

## `(for-each var lst &body)`
*Macro defined at lib/list.lisp:508:1*

Perform the set of actions `BODY` for all values in `LST`, binding the current value to `VAR`.

### Example:
```cl
> (for-each var '(1 2 3) \
.   (print! var))
1
2
3
nil
```

## `(init xs)`
*Defined at lib/list.lisp:381:1*

Return the list `XS` with the last element removed.
This is the dual of `LAST`.

### Example:
```cl
> (init (range :from 1 :to 10))
out = '(1 2 3 4 5 6 7 8 9)
```

## `(insert-nth! li idx val)`
*Defined at lib/list.lisp:493:1*

Mutate the list `LI`, inserting `VAL` at `IDX`.

### Example:
```cl
> (define list '(1 2 3))
> (insert-nth! list 2 5)
2
> list
out = (1 5 2 3)
``` 

## `(last xs)`
*Defined at lib/list.lisp:369:1*

Return the last element of the list `XS`.
Counterintutively, this function runs in constant time.

### Example:
```cl
> (last (range :from 1 :to 100))
out = 100
```

## `(map fn &xss)`
*Defined at lib/list.lisp:134:1*

Iterate over all the successive cars of `XSS`, producing a single list
by applying `FN` to all of them. For example:

### Example:
```cl
> (map list '(1 2 3) '(4 5 6) '(7 8 9))
out = ((1 4 7) (2 5 8) (3 6 9))
> (map succ '(1 2 3))
out = (2 3 4)
```

## `(maybe-map fn &xss)`
*Defined at lib/list.lisp:158:1*

Iterate over all successive cars of `XSS`, producing a single list by
applying `FN` to all of them, while discarding any `nil`s.

### Example:
```cl
> (maybe-map (lambda (x)
               (if (even? x)
                 nil
                 (succ x)))
             (range :from 1 :to 10))
out = (2 4 6 8 10)
```

## `(none p xs)`
*Defined at lib/list.lisp:261:1*

Check that no elements in `XS` match the predicate `P`.

### Example:
```cl
> (none nil? '("foo" "bar" "baz"))
true
```

## `(nth xs idx)`
*Defined at lib/list.lisp:393:1*

Get the `IDX` th element in the list `XS`. The first element is 1.
This function runs in constant time.

### Example:
```cl
> (nth (range :from 1 :to 100) 10)
out = 10
```

## `(nths xss idx)`
*Defined at lib/list.lisp:430:1*

Get the `IDX`-th element in all the lists given at `XSS`. The first
element is1.

### Example:
```cl
> (nths '((1 2 3) (4 5 6) (7 8 9)) 2)
out = (2 5 8)
```

## `(nub xs)`
*Defined at lib/list.lisp:283:1*

Remove duplicate elements from `XS`. This runs in linear time.

### Example:
```
> (nub '(1 1 2 2 3 3))
out = (1 2 3)
```

## `(partition p xs)`
*Defined at lib/list.lisp:199:1*

Split `XS` based on the predicate `P`. Values for which the predicate
returns true are returned in the first list, whereas values which
don't pass the predicate are returned in the second list.

### Example:
```cl
> (print! (partition even? '(1 2 3 4 5 6)))
'(2 4 6)   '(1 3 5)
out = nil
```

## `(pop-last! xs)`
*Defined at lib/list.lisp:461:1*

Mutate the list `XS`, removing and returning its last element.

### Example:
```cl
> (define list '(1 2 3))
> (pop-last! list)
3
> list
out = (1 2)
``` 

## `(prod xs)`
*Defined at lib/list.lisp:618:1*

Return the product of all elements in `XS`.

### Example:
```cl
> (prod '(1 2 3 4))
out = 24
```

## `(prune xs)`
*Defined at lib/list.lisp:346:1*

Remove values matching the predicates [`empty?`](lib.type.md#empty-x) or [`nil?`](lib.type.md#nil-x) from
the list `XS`.

### Example:
```cl
> (prune '(() nil 1 nil () 2))
out = (1 2)
```

## `(push-cdr! xs val)`
*Defined at lib/list.lisp:444:1*

Mutate the list `XS`, adding `VAL` to its end.

### Example:
```cl
> (define list '(1 2 3))
> (push-cdr! list 4)
'(1 2 3 4)
> list
out = (1 2 3 4)
```

## `(range &args)`
*Defined at lib/list.lisp:547:1*

Build a list from :`FROM` to :`TO`, optionally passing by :`BY`.

### Example:
```cl
> (range :from 1 :to 10)
out = (1 2 3 4 5 6 7 8 9 10)
> (range :from 1 :to 10 :by 3)
out = (1 3 5 7 9)
```

## `(reduce f z xs)`
*Defined at lib/list.lisp:103:1*

Accumulate the list `XS` using the binary function `F` and the zero
element `Z`.  This function is also called `foldl` by some authors. One
can visualise `(reduce f z xs)` as replacing the [`cons`](lib.list.md#cons-xs-xss) operator in
building lists with `F`, and the empty list with `Z`.

Consider:
- `'(1 2 3)` is equivalent to `(cons 1 (cons 2 (cons 3 '())))`
- `(reduce + 0 '(1 2 3))` is equivalent to `(+ 1 (+ 2 (+ 3 0)))`.

### Example:
```cl
> (reduce append '() '((1 2) (3 4)))
out = (1 2 3 4)
; equivalent to (append '(1 2) (append '(3 4) '()))
```

## `(remove-nth! li idx)`
*Defined at lib/list.lisp:478:1*

Mutate the list `LI`, removing the value at `IDX` and returning it.

### Example:
```cl
> (define list '(1 2 3))
> (remove-nth! list 2)
2
> list
out = (1 3)
``` 

## `(reverse xs)`
*Defined at lib/list.lisp:576:1*

Reverse the list `XS`, using the accumulator `ACC`.

### Example:
```cl
> (reverse (range :from 1 :to 10))
out = (10 9 8 7 6 5 4 3 2 1)
```

## `(snoc xss &xs)`
*Defined at lib/list.lisp:81:1*

Return a copy of the list `XS` with the element `XS` added to its end.
This function runs in linear time over the two input lists: That is,
it runs in `O`(n+k) time proportional both to `(n XSS)` and `(n XS)`.

### Example:
```cl
> (snoc '(1 2 3) 4 5 6)
out = (1 2 3 4 5 6)
``` 

## `(split xs y)`
*Defined at lib/list.lisp:658:1*

Splits a list into sub-lists by the separator `Y`.

### Example:
```cl
> (split '(1 2 3 4) 3)
out = ((1 2) (4))
```

## `(sum xs)`
*Defined at lib/list.lisp:608:1*

Return the sum of all elements in `XS`.

### Example:
```cl
> (sum '(1 2 3 4))
out = 10
```

## `(take xs n)`
*Defined at lib/list.lisp:61:1*

Take the first `N` elements of the list `XS`.

### Example:
```cl
> (take '(1 2 3 4 5) 2)
out = (1 2)
```

## `(take-while p xs idx)`
*Defined at lib/list.lisp:628:1*

Takes elements from the list `XS` while the predicate `P` is true,
starting at index `IDX`. Works like `filter`, but stops after the
first non-matching element.

### Example:
```cl
> (define list '(2 2 4 3 9 8 4 6))
> (define p (lambda (x) (= (% x 2) 0)))
> (filter p list)
out = (2 2 4 8 4 6)
> (take-while p list 1)
out = (2 2 4)
```

## `(traverse xs f)`
*Defined at lib/list.lisp:358:1*

> **Warning:** traverse is deprecated: Use map instead.

An alias for [`map`](lib.list.md#map-fn-xss) with the arguments `XS` and `F` flipped.

### Example:
```cl
> (traverse '(1 2 3) succ)
out = (2 3 4)
```

## `(union xs ys)`
*Defined at lib/list.lisp:302:1*

Set-like union of `XS` and `YS`.

### Example:
```
> (union '(1 2 3 4) '(1 2 3 4 5))
out = (1 2 3 4 5)
```

## Undocumented symbols
 - `(caaaar xs)` *Defined at lib/list.lisp:678:1*
 - `(caaaars xs)` *Defined at lib/list.lisp:678:1*
 - `(caaadr xs)` *Defined at lib/list.lisp:678:1*
 - `(caaadrs xs)` *Defined at lib/list.lisp:678:1*
 - `(caaar xs)` *Defined at lib/list.lisp:678:1*
 - `(caaars xs)` *Defined at lib/list.lisp:678:1*
 - `(caadar xs)` *Defined at lib/list.lisp:678:1*
 - `(caadars xs)` *Defined at lib/list.lisp:678:1*
 - `(caaddr xs)` *Defined at lib/list.lisp:678:1*
 - `(caaddrs xs)` *Defined at lib/list.lisp:678:1*
 - `(caadr xs)` *Defined at lib/list.lisp:678:1*
 - `(caadrs xs)` *Defined at lib/list.lisp:678:1*
 - `(caar xs)` *Defined at lib/list.lisp:678:1*
 - `(caars xs)` *Defined at lib/list.lisp:678:1*
 - `(cadaar xs)` *Defined at lib/list.lisp:678:1*
 - `(cadaars xs)` *Defined at lib/list.lisp:678:1*
 - `(cadadr xs)` *Defined at lib/list.lisp:678:1*
 - `(cadadrs xs)` *Defined at lib/list.lisp:678:1*
 - `(cadar xs)` *Defined at lib/list.lisp:678:1*
 - `(cadars xs)` *Defined at lib/list.lisp:678:1*
 - `(caddar xs)` *Defined at lib/list.lisp:678:1*
 - `(caddars xs)` *Defined at lib/list.lisp:678:1*
 - `(cadddr xs)` *Defined at lib/list.lisp:678:1*
 - `(cadddrs xs)` *Defined at lib/list.lisp:678:1*
 - `(caddr xs)` *Defined at lib/list.lisp:678:1*
 - `(caddrs xs)` *Defined at lib/list.lisp:678:1*
 - `(cadr xs)` *Defined at lib/list.lisp:678:1*
 - `(cadrs xs)` *Defined at lib/list.lisp:678:1*
 - `(cars xs)` *Defined at lib/list.lisp:678:1*
 - `(cdaaar xs)` *Defined at lib/list.lisp:678:1*
 - `(cdaaars xs)` *Defined at lib/list.lisp:678:1*
 - `(cdaadr xs)` *Defined at lib/list.lisp:678:1*
 - `(cdaadrs xs)` *Defined at lib/list.lisp:678:1*
 - `(cdaar xs)` *Defined at lib/list.lisp:678:1*
 - `(cdaars xs)` *Defined at lib/list.lisp:678:1*
 - `(cdadar xs)` *Defined at lib/list.lisp:678:1*
 - `(cdadars xs)` *Defined at lib/list.lisp:678:1*
 - `(cdaddr xs)` *Defined at lib/list.lisp:678:1*
 - `(cdaddrs xs)` *Defined at lib/list.lisp:678:1*
 - `(cdadr xs)` *Defined at lib/list.lisp:678:1*
 - `(cdadrs xs)` *Defined at lib/list.lisp:678:1*
 - `(cdar xs)` *Defined at lib/list.lisp:678:1*
 - `(cdars xs)` *Defined at lib/list.lisp:678:1*
 - `(cddaar xs)` *Defined at lib/list.lisp:678:1*
 - `(cddaars xs)` *Defined at lib/list.lisp:678:1*
 - `(cddadr xs)` *Defined at lib/list.lisp:678:1*
 - `(cddadrs xs)` *Defined at lib/list.lisp:678:1*
 - `(cddar xs)` *Defined at lib/list.lisp:678:1*
 - `(cddars xs)` *Defined at lib/list.lisp:678:1*
 - `(cdddar xs)` *Defined at lib/list.lisp:678:1*
 - `(cdddars xs)` *Defined at lib/list.lisp:678:1*
 - `(cddddr xs)` *Defined at lib/list.lisp:678:1*
 - `(cddddrs xs)` *Defined at lib/list.lisp:678:1*
 - `(cdddr xs)` *Defined at lib/list.lisp:678:1*
 - `(cdddrs xs)` *Defined at lib/list.lisp:678:1*
 - `(cddr xs)` *Defined at lib/list.lisp:678:1*
 - `(cddrs xs)` *Defined at lib/list.lisp:678:1*
 - `(cdrs xs)` *Defined at lib/list.lisp:678:1*
