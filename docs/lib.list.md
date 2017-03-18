---
title: list
---
# list
List manipulation functions.
These include several often-used functions for manipulation of lists,
including functional programming classics such as [`map`](lib.list.md#map-f-xs) and [`foldr`](lib.list.md#foldr-f-z-xs)
and useful patterns such as [`accumulate-with`](lib.list.md#accumulate-with-f-ac-z-xs).

Most of these functions are tail-recursive unless noted, which means they
will not blow up the stack. Along with the property of tail-recursiveness,
these functions also have favourable performance characteristics.

Glossary:
- **Constant time** The function runs in the same time regardless of the
  size of the input list.
- **Linear time** The runtime of the function is a linear function of the
  size of the input list.
- **Logarithmic time** The runtime of the function grows logarithmically
  in proportion to the size of the input list.
- **Exponential time** The runtime of the function grows exponentially in
  proportion to the size of the input list. This is generally a bad thing.

## `(accumulate-with f ac z xs)`
*Defined at lib/list.lisp:355:1*

`A` composition of [`foldr`](lib.list.md#foldr-f-z-xs) and [`map`](lib.list.md#map-f-xs)
Transform the values of `XS` using the function `F`, then accumulate them
starting form `Z` using the function `AC`.

This function behaves as if it were folding over the list `XS` with the
monoid described by (`F`, `AC`, `Z`), that is, `F` constructs the monoid, `AC`
is the binary operation, and `Z` is the zero element.

Example:
```
> (accumulate-with tonumber + 0 '(1 2 3 4 5))
15
```

## `(all p xs)`
*Defined at lib/list.lisp:156:1*

Test if all elements of `XS` match the predicate `P`.

Example:
```
> (all symbol? '(foo bar baz))
true
> (all number? '(1 2 foo))
false
```

## `(any p xs)`
*Defined at lib/list.lisp:143:1*

Check for the existence of an element in `XS` that matches the
predicate `P`.

Example:
```
> (any exists? '(nil 1 "foo"))
true
```

## `(append xs ys)`
*Defined at lib/list.lisp:308:1*

Concatenate `XS` and `YS`.

Example:
```
> (append '(1 2) '(3 4))
'(1 2 3 4)
``` 

## `(car x)`
*Defined at lib/list.lisp:29:1*

Return the first element present in the list `X`. This function operates
in constant time.

Example:
```
> (car '(1 2 3))
1
```

## `(cdr x)`
*Defined at lib/list.lisp:41:1*

Return the list `X` without the first element present. In the case that
`X` is nil, the empty list is returned. Due to the way lists are represented
internally, this function runs in linear time.

Example:
```
> (cdr '(1 2 3))
'(2 3)
```

## `(drop xs n)`
*Defined at lib/list.lisp:66:1*

Remove the first `N` elements of the list `XS`.

Example:
```
> (take '(1 2 3 4 5) 2)
'(3 4 5)
```

## `(elem? x xs)`
*Defined at lib/list.lisp:170:1*

Test if `X` is present in the list `XS`.

Example:
```
> (elem? 1 '(1 2 3))
true
> (elem? 'foo '(1 2 3))
false
```

## `(filter p xs)`
*Defined at lib/list.lisp:127:1*

Return the list of elements of `XS` which match the predicate `P`.

Example:
```
> (filter even? '(1 2 3 4 5 6))
'(2 4 6)
```

## `(flatten xss)`
*Defined at lib/list.lisp:318:1*

Concatenate all the lists in `XSS`. `XSS` must not contain elements which
are not lists.

Example:
```
> (flatten '((1 2) (3 4)))
'(1 2 3 4)
```

## `(foldr f z xs)`
*Defined at lib/list.lisp:88:1*

Accumulate the list `XS` using the binary function `F` and the zero element `Z`.
This function is also called `reduce` by some authors. One can visualise
(foldr f z xs) as replacing the [`cons`](lib.base.md#cons-x-xs) operator in building lists with `F`,
and the empty list with `Z`.

Consider:
- `'(1 2 3)` is equivalent to `(cons 1 (cons 2 (cons 3 '())))`
- `(foldr + 0 '(1 2 3))` is equivalent to `(+ 1 (+ 2 (+ 3 0)))`.

Example:
```
> (foldr append '() '((1 2) (3 4)))
; equivalent to (append '(1 2) (append '(3 4) '()))
'(1 2 3 4)
```

## `(for-each var lst &body)`
*Macro defined at lib/list.lisp:290:1*

Perform the set of actions `BODY` for all values in `LST`, binding the current value to `VAR`.

Example:
```
> (for-each var '(1 2 3) \
.   (print! var))
1
2
3
nil
```

## `(last xs)`
*Defined at lib/list.lisp:204:1*

Return the last element of the list `XS`.
Counterintutively, this function runs in constant time.

Example:
```
> (last (range 1 100))
100
```

## `(map f xs)`
*Defined at lib/list.lisp:111:1*

Apply the function `F` to every element of the list `XS`, collecting the
results in a new list.

Example:
```
> (map succ '(0 1 2))
'(1 2 3)
```

## `(nth xs idx)`
*Defined at lib/list.lisp:216:1*

Get the `IDX` th element in the list `XS`. The first element is 1.
This function runs in constant time.

Example:
```
> (nth (range 1 100) 10)
10
```

## `(nths xss idx)`
*Defined at lib/list.lisp:227:1*

Get the `IDX`-th element in all the lists given at `XSS`. The first
element is1.

Example:
```
> (nths '((1 2 3) (4 5 6) (7 8 9)) 2)
'(2 5 8)
```

## `(pop-last! xs)`
*Defined at lib/list.lisp:258:1*

Mutate the list `XS`, removing and returning its last element.

Example:
```
> (define list '(1 2 3))
> (pop-last! list)
3
> list
'(1 2)
``` 

## `(prune xs)`
*Defined at lib/list.lisp:183:1*

Remove values matching the predicate [`nil?`](lib.type.md#nil-x) from the list `XS`.

Example:
```
> (prune '(() 1 () 2))
'(1 2)
```

## `(push-cdr! xs val)`
*Defined at lib/list.lisp:241:1*

Mutate the list `XS`, adding `VAL` to its end.

Example:
```
> (define list '(1 2 3))
> (push-cdr! list 4)
'(1 2 3 4)
> list
'(1 2 3 4)
```

## `(range start end)`
*Defined at lib/list.lisp:329:1*

Build a list from `START` to `END`.

Example:
```
> (range 1 10)
'(1 2 3 4 5 6 7 8 9 10)
```

## `(remove-nth! li idx)`
*Defined at lib/list.lisp:275:1*

Mutate the list `LI`, removing the value at `IDX` and returning it.

Example:
```
> (define list '(1 2 3))
> (remove-nth! list 2)
2
> list
> '(1 3)
``` 

## `(reverse xs)`
*Defined at lib/list.lisp:342:1*

Reverse the list `XS`, using the accumulator `ACC`.

Example:
```
> (reverse (range 1 10))
'(10 9 8 7 6 5 4 3 2 1)
```

## `(snoc xss &xs)`
*Defined at lib/list.lisp:76:1*

Return a copy of the list `XS` with the element `XS` added to its end.
This function runs in linear time over the two input lists: That is,
it runs in `O`(n+k) time proportional both to `(# XSS)` and `(# XS)`.

Example:
```
> (snoc '(1 2 3) 4 5 6)
'(1 2 3 4 5 6)
``` 

## `(take xs n)`
*Defined at lib/list.lisp:56:1*

Take the first `N` elements of the list `XS`.

Example:
```
> (take '(1 2 3 4 5) 2)
'(1 2)
```

## `(traverse xs f)`
*Defined at lib/list.lisp:194:1*

An alias for [`map`](lib.list.md#map-f-xs) with the arguments `XS` and `F` flipped.

Example:
```
> (traverse '(1 2 3) succ)
'(2 3 4)
```

## `(zip fn &xss)`
*Defined at lib/list.lisp:373:1*

Iterate over all the successive cars of `XSS`, producing a single list
by applying `FN` to all of them. For example:

Example:
```
> (zip list '(1 2 3) '(4 5 6) '(7 8 9))
'((1 4 7) (2 5 8) (3 6 9))
```

## Undocumented symbols
 - `(caaaar x)` *Defined at lib/list.lisp:403:1*
 - `(caaaars xs)` *Defined at lib/list.lisp:434:1*
 - `(caaadr x)` *Defined at lib/list.lisp:404:1*
 - `(caaadrs xs)` *Defined at lib/list.lisp:435:1*
 - `(caaar x)` *Defined at lib/list.lisp:395:1*
 - `(caaars xs)` *Defined at lib/list.lisp:426:1*
 - `(caadar x)` *Defined at lib/list.lisp:405:1*
 - `(caadars xs)` *Defined at lib/list.lisp:436:1*
 - `(caaddr x)` *Defined at lib/list.lisp:406:1*
 - `(caaddrs xs)` *Defined at lib/list.lisp:437:1*
 - `(caadr x)` *Defined at lib/list.lisp:396:1*
 - `(caadrs xs)` *Defined at lib/list.lisp:427:1*
 - `(caar x)` *Defined at lib/list.lisp:390:1*
 - `(caars xs)` *Defined at lib/list.lisp:422:1*
 - `(cadaar x)` *Defined at lib/list.lisp:407:1*
 - `(cadaars xs)` *Defined at lib/list.lisp:438:1*
 - `(cadadr x)` *Defined at lib/list.lisp:408:1*
 - `(cadadrs xs)` *Defined at lib/list.lisp:439:1*
 - `(cadar x)` *Defined at lib/list.lisp:397:1*
 - `(cadars xs)` *Defined at lib/list.lisp:428:1*
 - `(caddar x)` *Defined at lib/list.lisp:409:1*
 - `(caddars xs)` *Defined at lib/list.lisp:440:1*
 - `(cadddr x)` *Defined at lib/list.lisp:410:1*
 - `(cadddrs xs)` *Defined at lib/list.lisp:441:1*
 - `(caddr x)` *Defined at lib/list.lisp:398:1*
 - `(caddrs xs)` *Defined at lib/list.lisp:429:1*
 - `(cadr x)` *Defined at lib/list.lisp:391:1*
 - `(cadrs xs)` *Defined at lib/list.lisp:423:1*
 - `(cars xs)` *Defined at lib/list.lisp:420:1*
 - `(cdaaar x)` *Defined at lib/list.lisp:411:1*
 - `(cdaaars xs)` *Defined at lib/list.lisp:442:1*
 - `(cdaadr x)` *Defined at lib/list.lisp:412:1*
 - `(cdaadrs xs)` *Defined at lib/list.lisp:443:1*
 - `(cdaar x)` *Defined at lib/list.lisp:399:1*
 - `(cdaars xs)` *Defined at lib/list.lisp:430:1*
 - `(cdadar x)` *Defined at lib/list.lisp:413:1*
 - `(cdadars xs)` *Defined at lib/list.lisp:444:1*
 - `(cdaddr x)` *Defined at lib/list.lisp:414:1*
 - `(cdaddrs xs)` *Defined at lib/list.lisp:445:1*
 - `(cdadr x)` *Defined at lib/list.lisp:400:1*
 - `(cdadrs xs)` *Defined at lib/list.lisp:431:1*
 - `(cdar x)` *Defined at lib/list.lisp:392:1*
 - `(cdars xs)` *Defined at lib/list.lisp:424:1*
 - `(cddaar x)` *Defined at lib/list.lisp:415:1*
 - `(cddaars xs)` *Defined at lib/list.lisp:446:1*
 - `(cddadr x)` *Defined at lib/list.lisp:416:1*
 - `(cddadrs xs)` *Defined at lib/list.lisp:447:1*
 - `(cddar x)` *Defined at lib/list.lisp:401:1*
 - `(cddars xs)` *Defined at lib/list.lisp:432:1*
 - `(cdddar x)` *Defined at lib/list.lisp:417:1*
 - `(cdddars xs)` *Defined at lib/list.lisp:448:1*
 - `(cddddr x)` *Defined at lib/list.lisp:418:1*
 - `(cddddrs xs)` *Defined at lib/list.lisp:449:1*
 - `(cdddr x)` *Defined at lib/list.lisp:402:1*
 - `(cdddrs xs)` *Defined at lib/list.lisp:433:1*
 - `(cddr x)` *Defined at lib/list.lisp:393:1*
 - `(cddrs xs)` *Defined at lib/list.lisp:425:1*
 - `(cdrs xs)` *Defined at lib/list.lisp:421:1*
