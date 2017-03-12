---
title: list
---
# list
List manipulation functions.
These include several often-used functions for manipulation of lists,
including functional programming classics such as [`map`](lib.list.md#map-f-xs-acc) and [`foldr`](lib.list.md#foldr-f-z-xs)
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
*Defined at lib/list.lisp:323:1*

`A` composition of [`foldr`](lib.list.md#foldr-f-z-xs) and [`map`](lib.list.md#map-f-xs-acc)
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
*Defined at lib/list.lisp:136:1*

Test if all elements of `XS` match the predicate `P`.

Example:
```
> (all symbol? '(foo bar baz))
true
> (all number? '(1 2 foo))
false
```

## `(any p xs)`
*Defined at lib/list.lisp:123:1*

Check for the existence of an element in `XS` that matches the
predicate `P`.

Example:
```
> (any exists? '(nil 1 "foo"))
true
```

## `(append xs ys)`
*Defined at lib/list.lisp:273:1*

Concatenate `XS` and `YS`.

Example:
```
> (append '(1 2) '(3 4))
'(1 2 3 4)
``` 

## `(car x)`
*Defined at lib/list.lisp:28:1*

Return the first element present in the list `X`. This function operates
in constant time.

Example:
```
> (car '(1 2 3))
1
```

## `(cdr x)`
*Defined at lib/list.lisp:40:1*

Return the list `X` without the first element present. In the case that
`X` is nil, the empty list is returned. Due to the way lists are represented
internally, this function runs in linear time.

Example:
```
> (cdr '(1 2 3))
'(2 3)
```

## `(elem? x xs)`
*Defined at lib/list.lisp:150:1*

Test if `X` is present in the list `XS`.

Example:
```
> (elem? 1 '(1 2 3))
true
> (elem? 'foo '(1 2 3))
false
```

## `(filter p xs acc)`
*Defined at lib/list.lisp:106:1*

Return the list of elements of `XS` which match the predicate `P`.

Example:
```
> (filter even? '(1 2 3 4 5 6))
'(2 4 6)
```

## `(flatten xss)`
*Defined at lib/list.lisp:285:1*

Concatenate all the lists in `XSS`. `XSS` must not contain elements which
are not lists.

Example:
```
> (flatten '((1 2) (3 4)))
'(1 2 3 4)
```

## `(foldr f z xs)`
*Defined at lib/list.lisp:67:1*

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
*Macro defined at lib/list.lisp:255:1*

Perform the set of actions `BODY` for all values in `LST`, binding the current value to `VAR`.

Example:
```
> (for-each var '(1 2 3)    (print! var))
1
2
3
nil
```

## `(last xs)`
*Defined at lib/list.lisp:184:1*

Return the last element of the list `XS`.
Counterintutively, this function runs in constant time.

Example:
```
> (last (range 1 100))
100
```

## `(map f xs acc)`
*Defined at lib/list.lisp:90:1*

Apply the function `F` to every element of the list `XS`, collecting the
results in a new list.

Example:
```
> (map succ '(0 1 2))
'(1 2 3)
```

## `(nth xs idx)`
*Defined at lib/list.lisp:196:1*

Get the `IDX` th element in the list `XS`. The first element is 1.
This function runs in constant time.

Example:
```
> (nth (range 1 100) 10)
10
```

## `(pop-last! xs)`
*Defined at lib/list.lisp:224:1*

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
*Defined at lib/list.lisp:163:1*

Remove values matching the predicate [`nil?`](lib.type.md#nil-x) from the list `XS`.

Example:
```
> (prune '(() 1 () 2))
'(1 2)
```

## `(push-cdr! xs val)`
*Defined at lib/list.lisp:207:1*

Mutate the list `XS`, adding `VAL` to its end.

Example:
```
> (define list '(1 2 3))
> (push-cdr! list 4)
'(1 2 3 4)
> list
'(1 2 3 4)
```

## `(range start end acc)`
*Defined at lib/list.lisp:296:1*

Build a list from `START` to `END`. This function is tail recursive, and
uses the parameter `ACC` as an accumulator.

Example:
```
> (range 1 10)
'(1 2 3 4 5 6 7 8 9 10)
```

## `(remove-nth! li idx)`
*Defined at lib/list.lisp:240:1*

Mutate the list `LI`, removing the value at `IDX` and returning it.

Example:
```
> (define list '(1 2 3))
> (remove-nth! list 2)
2
> list
> '(1 3) 
``` 

## `(reverse xs acc)`
*Defined at lib/list.lisp:310:1*

Reverse the list `XS`, using the accumulator `ACC`.

Example:
```
> (reverse (range 1 10))
'(10 9 8 7 6 5 4 3 2 1)
```

## `(snoc xss &xs)`
*Defined at lib/list.lisp:55:1*

Return a copy of the list `XS` with the element `XS` added to its end.
This function runs in linear time over the two input lists: That is,
it runs in `O`(n+k) time proportional both to `(# XSS)` and `(# XS)`.

Example:
```
> (snoc '(1 2 3) 4 5 6)
'(1 2 3 4 5 6)
``` 

## `(traverse xs f)`
*Defined at lib/list.lisp:174:1*

An alias for [`map`](lib.list.md#map-f-xs-acc) with the arguments `XS` and `F` flipped.

Example:
```
> (traverse '(1 2 3) succ)
'(2 3 4)
```

## `(zip fn &xss)`
*Defined at lib/list.lisp:341:1*

Iterate over all the successive cars of `XSS`, producing a single list
by applying `FN` to all of them. For example:

Example:
```
> (zip list '(1 2 3) '(4 5 6) '(7 8 9))
'((1 4 7) (2 5 8) (3 6 9))
```

## Undocumented symbols
 - `(caaaar x)` *Defined at lib/list.lisp:373:1*
 - `(caaaars xs)` *Defined at lib/list.lisp:404:1*
 - `(caaadr x)` *Defined at lib/list.lisp:374:1*
 - `(caaadrs xs)` *Defined at lib/list.lisp:405:1*
 - `(caaar x)` *Defined at lib/list.lisp:365:1*
 - `(caaars xs)` *Defined at lib/list.lisp:396:1*
 - `(caadar x)` *Defined at lib/list.lisp:375:1*
 - `(caadars xs)` *Defined at lib/list.lisp:406:1*
 - `(caaddr x)` *Defined at lib/list.lisp:376:1*
 - `(caaddrs xs)` *Defined at lib/list.lisp:407:1*
 - `(caadr x)` *Defined at lib/list.lisp:366:1*
 - `(caadrs xs)` *Defined at lib/list.lisp:397:1*
 - `(caar x)` *Defined at lib/list.lisp:360:1*
 - `(caars xs)` *Defined at lib/list.lisp:392:1*
 - `(cadaar x)` *Defined at lib/list.lisp:377:1*
 - `(cadaars xs)` *Defined at lib/list.lisp:408:1*
 - `(cadadr x)` *Defined at lib/list.lisp:378:1*
 - `(cadadrs xs)` *Defined at lib/list.lisp:409:1*
 - `(cadar x)` *Defined at lib/list.lisp:367:1*
 - `(cadars xs)` *Defined at lib/list.lisp:398:1*
 - `(caddar x)` *Defined at lib/list.lisp:379:1*
 - `(caddars xs)` *Defined at lib/list.lisp:410:1*
 - `(cadddr x)` *Defined at lib/list.lisp:380:1*
 - `(cadddrs xs)` *Defined at lib/list.lisp:411:1*
 - `(caddr x)` *Defined at lib/list.lisp:368:1*
 - `(caddrs xs)` *Defined at lib/list.lisp:399:1*
 - `(cadr x)` *Defined at lib/list.lisp:361:1*
 - `(cadrs xs)` *Defined at lib/list.lisp:393:1*
 - `(cars xs)` *Defined at lib/list.lisp:390:1*
 - `(cdaaar x)` *Defined at lib/list.lisp:381:1*
 - `(cdaaars xs)` *Defined at lib/list.lisp:412:1*
 - `(cdaadr x)` *Defined at lib/list.lisp:382:1*
 - `(cdaadrs xs)` *Defined at lib/list.lisp:413:1*
 - `(cdaar x)` *Defined at lib/list.lisp:369:1*
 - `(cdaars xs)` *Defined at lib/list.lisp:400:1*
 - `(cdadar x)` *Defined at lib/list.lisp:383:1*
 - `(cdadars xs)` *Defined at lib/list.lisp:414:1*
 - `(cdaddr x)` *Defined at lib/list.lisp:384:1*
 - `(cdaddrs xs)` *Defined at lib/list.lisp:415:1*
 - `(cdadr x)` *Defined at lib/list.lisp:370:1*
 - `(cdadrs xs)` *Defined at lib/list.lisp:401:1*
 - `(cdar x)` *Defined at lib/list.lisp:362:1*
 - `(cdars xs)` *Defined at lib/list.lisp:394:1*
 - `(cddaar x)` *Defined at lib/list.lisp:385:1*
 - `(cddaars xs)` *Defined at lib/list.lisp:416:1*
 - `(cddadr x)` *Defined at lib/list.lisp:386:1*
 - `(cddadrs xs)` *Defined at lib/list.lisp:417:1*
 - `(cddar x)` *Defined at lib/list.lisp:371:1*
 - `(cddars xs)` *Defined at lib/list.lisp:402:1*
 - `(cdddar x)` *Defined at lib/list.lisp:387:1*
 - `(cdddars xs)` *Defined at lib/list.lisp:418:1*
 - `(cddddr x)` *Defined at lib/list.lisp:388:1*
 - `(cddddrs xs)` *Defined at lib/list.lisp:419:1*
 - `(cdddr x)` *Defined at lib/list.lisp:372:1*
 - `(cdddrs xs)` *Defined at lib/list.lisp:403:1*
 - `(cddr x)` *Defined at lib/list.lisp:363:1*
 - `(cddrs xs)` *Defined at lib/list.lisp:395:1*
 - `(cdrs xs)` *Defined at lib/list.lisp:391:1*
