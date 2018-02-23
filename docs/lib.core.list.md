---
title: core/list
---
# core/list
List manipulation functions.

These include several often-used functions for manipulation of lists,
including functional programming classics such as [`map`](lib.core.list.md#map-fn-xss) and [`reduce`](lib.core.list.md#reduce-f-z-xs)
and useful patterns such as [`accumulate-with`](lib.core.list.md#accumulate-with-f-ac-z-xs).

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
*Defined at lib/core/list.lisp:342:2*

The difference between `XS` and `YS` (non-associative.)

### Example:
```cl
> (\\ '(1 2 3) '(1 3 5 7))
out = (2)
```

## `(accumulate-with f ac z xs)`
*Defined at lib/core/list.lisp:752:2*

`A` composition of [`reduce`](lib.core.list.md#reduce-f-z-xs) and [`map`](lib.core.list.md#map-fn-xss).

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
*Defined at lib/core/list.lisp:393:2*

Test if all elements of `XS` match the predicate `P`.

### Example:
```cl
> (all symbol? '(foo bar baz))
out = true
> (all number? '(1 2 foo))
out = false
```

## `(any p xs)`
*Defined at lib/core/list.lisp:312:2*

Check for the existence of an element in `XS` that matches the predicate
`P`.

### Example:
```cl
> (any exists? '(nil 1 "foo"))
out = true
```

## `(append xs ys)`
*Defined at lib/core/list.lisp:689:2*

Concatenate `XS` and `YS`.

### Example:
```cl
> (append '(1 2) '(3 4))
out = (1 2 3 4)
``` 

## `(car x)`
*Defined at lib/core/list.lisp:37:2*

Return the first element present in the list `X`. This function operates
in constant time.

### Example:
```cl
> (car '(1 2 3))
out = 1
```

## `(cdr x)`
*Defined at lib/core/list.lisp:122:2*

Return a reference the list `X` without the first element present. In
the case that `X` is nil, the empty list is returned. Note that
mutating the reference will not mutate the

### Example:
```cl
> (cdr '(1 2 3))
out = (2 3)
```

## `(cons &xs xss)`
*Defined at lib/core/list.lisp:166:2*

Return a copy of the list `XSS` with the elements `XS` added to its head.

### Example:
```cl
> (cons 1 2 3 '(4 5 6))
out = (1 2 3 4 5 6)
```

## `(do vars &stmts)`
*Macro defined at lib/core/list.lisp:662:2*

Iterate over all given `VARS`, running `STMTS` **without** collecting the
results.

### Example:
```cl
> (do [(a '(1 2))
.      (b '(1 2))]
.   (print! $"a = ${a}, b = ${b}"))
a = 1, b = 1
a = 1, b = 2
a = 2, b = 1
a = 2, b = 2
out = nil
```

## `(dolist vars &stmts)`
*Macro defined at lib/core/list.lisp:632:2*

Iterate over all given `VARS`, running `STMTS` and collecting the results.

### Example:
```cl
> (dolist [(a '(1 2 3))
.          (b '(1 2 3))]
.   (list a b))
out = ((1 1) (1 2) (1 3) (2 1) (2 2) (2 3) (3 1) (3 2) (3 3))
```

## `(drop xs n)`
*Defined at lib/core/list.lisp:144:2*

Remove the first `N` elements of the list `XS`.

### Example:
```cl
> (drop '(1 2 3 4 5) 2)
out = (3 4 5)
```

## `(elem? x xs)`
*Defined at lib/core/list.lisp:414:2*

Test if `X` is present in the list `XS`.

### Example:
```cl
> (elem? 1 '(1 2 3))
out = true
> (elem? 'foo '(1 2 3))
out = false
```

## `(element-index x xs)`
*Defined at lib/core/list.lisp:449:2*

Finds the first index in `XS` where the item matches `X`. Returns `nil` if
no such item exists.

### Example:
```cl
> (element-index 4 '(3 4 5))
out = 2
> (element-index 2 '(1 3 5))
out = nil
```

## `(exclude p xs)`
*Defined at lib/core/list.lisp:301:2*

Return a list with only the elements of `XS` that don't match the
predicate `P`.

### Example:
```cl
> (exclude even? '(1 2 3 4 5 6))
out = (1 3 5)
```

## `(filter p xs)`
*Defined at lib/core/list.lisp:290:2*

Return a list with only the elements of `XS` that match the predicate
`P`.

### Example:
```cl
> (filter even? '(1 2 3 4 5 6))
out = (2 4 6)
```

## `(find-index p xs)`
*Defined at lib/core/list.lisp:427:2*

Finds the first index in `XS` where the item matches the predicate
`P`. Returns `nil` if no such item exists.

### Example:
```cl
> (find-index even? '(3 4 5))
out = 2
> (find-index even? '(1 3 5))
out = nil
```

## `(flat-map fn &xss)`
*Defined at lib/core/list.lisp:260:2*

Map the function `FN` over the lists `XSS`, then flatten the result
lists.

### Example:
```cl
> (flat-map list '(1 2 3) '(4 5 6))
out = (1 4 2 5 3 6)
```

## `(flatten xss)`
*Defined at lib/core/list.lisp:699:2*

Concatenate all the lists in `XSS`. `XSS` must not contain elements which
are not lists.

### Example:
```cl
> (flatten '((1 2) (3 4)))
out = (1 2 3 4)
```

## `(for-each var lst &body)`
*Macro defined at lib/core/list.lisp:616:2*

>**Warning:** for-each is deprecated: Use [`do`](lib.core.list.md#do-vars-stmts)/[`dolist`](lib.core.list.md#dolist-vars-stmts) instead

Perform the set of actions `BODY` for all values in `LST`, binding the current value to `VAR`.

### Example:
```cl
> (for-each var '(1 2 3)
.   (print! var))
1
2
3
out = nil
```

## `(groups-of xs num)`
*Defined at lib/core/list.lisp:838:2*

Splits the list `XS` into sub-lists of size `NUM`.

### Example:
```cl
> (groups-of '(1 2 3 4 5 6) 3)
out = ((1 2 3) (4 5 6))
```

## `(init xs)`
*Defined at lib/core/list.lisp:498:2*

Return the list `XS` with the last element removed.
This is the dual of `LAST`.

### Example:
```cl
> (init (range :from 1 :to 10))
out = (1 2 3 4 5 6 7 8 9)
```

## `(insert-nth! li idx val)`
*Defined at lib/core/list.lisp:602:2*

Mutate the list `LI`, inserting `VAL` at `IDX`.

### Example:
```cl
> (define list '(1 2 3))
> (insert-nth! list 2 5)
> list
out = (1 5 2 3)
``` 

## `(last xs)`
*Defined at lib/core/list.lisp:486:2*

Return the last element of the list `XS`.
Counterintutively, this function runs in constant time.

### Example:
```cl
> (last (range :from 1 :to 100))
out = 100
```

## `(map fn &xss)`
*Defined at lib/core/list.lisp:207:2*

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
*Defined at lib/core/list.lisp:231:2*

Iterate over all successive cars of `XSS`, producing a single list by
applying `FN` to all of them, while discarding any `nil`s.

### Example:
```cl
> (maybe-map (lambda (x)
.              (if (even? x)
.                nil
.                (succ x)))
.            (range :from 1 :to 10))
out = (2 4 6 8 10)
```

## `(none p xs)`
*Defined at lib/core/list.lisp:332:2*

Check that no elements in `XS` match the predicate `P`.

### Example:
```cl
> (none nil? '("foo" "bar" "baz"))
out = true
```

## `(nth xs idx)`
*Defined at lib/core/list.lisp:510:2*

Get the `IDX` th element in the list `XS`. The first element is 1.
This function runs in constant time.

### Example:
```cl
> (nth (range :from 1 :to 100) 10)
out = 10
```

## `(nths xss idx)`
*Defined at lib/core/list.lisp:523:2*

Get the IDX-th element in all the lists given at `XSS`. The first
element is1.

### Example:
```cl
> (nths '((1 2 3) (4 5 6) (7 8 9)) 2)
out = (2 5 8)
```

## `(nub xs)`
*Defined at lib/core/list.lisp:354:2*

Remove duplicate elements from `XS`. This runs in linear time.

### Example:
```cl
> (nub '(1 1 2 2 3 3))
out = (1 2 3)
```

## `(partition p xs)`
*Defined at lib/core/list.lisp:271:2*

Split `XS` based on the predicate `P`. Values for which the predicate
returns true are returned in the first list, whereas values which
don't pass the predicate are returned in the second list.

### Example:
```cl
> (list (partition even? '(1 2 3 4 5 6)))
out = ((2 4 6) (1 3 5))
```

## `(pop-last! xs)`
*Defined at lib/core/list.lisp:570:2*

Mutate the list `XS`, removing and returning its last element.

### Example:
```cl
> (define list '(1 2 3))
> (pop-last! list)
out = 3
> list
out = (1 2)
``` 

## `(prod xs)`
*Defined at lib/core/list.lisp:781:2*

Return the product of all elements in `XS`.

### Example:
```cl
> (prod '(1 2 3 4))
out = 24
```

## `(prune xs)`
*Defined at lib/core/list.lisp:463:2*

Remove values matching the predicates [`empty?`](lib.core.type.md#empty-x) or [`nil?`](lib.core.type.md#nil-x) from
the list `XS`.

### Example:
```cl
> (prune (list '() nil 1 nil '() 2))
out = (1 2)
```

## `(push! xs &vals)`
*Defined at lib/core/list.lisp:537:2*

Mutate the list `XS`, adding `VALS` to its end.

### Example:
```cl
> (define list '(1 2 3))
> (push! list 4)
out = (1 2 3 4)
> list
out = (1 2 3 4)
```

## `(push-cdr! xs &vals)`
*Defined at lib/core/list.lisp:556:1*

>**Warning:** push-cdr! is deprecated: Use [`push!`](lib.core.list.md#push-xs-vals) instead.

Mutate the list `XS`, adding `VALS` to its end.

### Example:
```cl
> (define list '(1 2 3))
> (push-cdr! list 4)
out = (1 2 3 4)
> list
out = (1 2 3 4)
```

## `(range &args)`
*Defined at lib/core/list.lisp:710:2*

Build a list from :`FROM` to :`TO`, optionally passing by :`BY`.

### Example:
```cl
> (range :from 1 :to 10)
out = (1 2 3 4 5 6 7 8 9 10)
> (range :from 1 :to 10 :by 3)
out = (1 3 5 7 9)
```

## `(reduce f z xs)`
*Defined at lib/core/list.lisp:176:2*

Accumulate the list `XS` using the binary function `F` and the zero
element `Z`.  This function is also called `foldl` by some authors. One
can visualise `(reduce f z xs)` as replacing the [`cons`](lib.core.list.md#cons-xs-xss) operator in
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
*Defined at lib/core/list.lisp:587:2*

Mutate the list `LI`, removing the value at `IDX` and returning it.

### Example:
```cl
> (define list '(1 2 3))
> (remove-nth! list 2)
out = 2
> list
out = (1 3)
``` 

## `(reverse xs)`
*Defined at lib/core/list.lisp:739:2*

Reverse the list `XS`, using the accumulator `ACC`.

### Example:
```cl
> (reverse (range :from 1 :to 10))
out = (10 9 8 7 6 5 4 3 2 1)
```

## `(slicing-view list offset)`
*Defined at lib/core/list.lisp:50:1*

Return a mutable reference to the list `LIST`, with indexing offset
(positively) by `OFFSET`. Mutation in the original list is reflected in
the view, and updates to the view are reflected in the original. In
this, a sliced view resembles an (offset) pointer. Note that trying
to access a key that doesn't make sense in a list (e.g., not its
`:tag`, its `:n`, or a numerical index) will blow up with an arithmetic
error.

**Note** that the behaviour of a sliced view when the underlying list
changes length may be confusing: accessing elements will still work,
but the reported length of the slice will be off. Furthermore, If the
original list shrinks, the view will maintain its length, but will
have an adequate number of `nil`s at the end.

```cl
> (define foo '(1 2 3 4 5))
out = (1 2 3 4 5)
> (define foo-view (cdr foo))
out = (2 3 4 5)
> (remove-nth! foo 5)
out = 5
> foo-view
out = (2 3 4 nil)
```

Also **note** that functions that modify a list in-place, like
`insert-nth!', `remove-nth!`, `pop-last!` and `push!` will not
modify the view *or* the original list.

```cl
> (define bar '(1 2 3 4 5))
out = (1 2 3 4 5)
> (define bar-view (cdr bar))
out = (2 3 4 5)
> (remove-nth! bar-view 4)
out = nil
> bar
out = (1 2 3 4 5)
```

### Example:
```cl
> (define baz '(1 2 3))
out = (1 2 3)
> (slicing-view baz 1)
out = (2 3)
> (.<! (slicing-view baz 1) 1 5)
out = nil
> baz
out = (1 5 3)
```

## `(snoc xss &xs)`
*Defined at lib/core/list.lisp:154:2*

Return a copy of the list `XS` with the element `XS` added to its end.
This function runs in linear time over the two input lists: That is,
it runs in `O`(n+k) time proportional both to `(n XSS)` and `(n XS)`.

### Example:
```cl
> (snoc '(1 2 3) 4 5 6)
out = (1 2 3 4 5 6)
``` 

## `(sort xs f)`
*Defined at lib/core/list.lisp:856:2*

Sort the list `XS`, non-destructively, optionally using `F` as a
comparator.  `A` sorted version of the list is returned, while the
original remains untouched.

### Example:
```cl
> (define li '(9 5 7 2 1))
out = (9 5 7 2 1)
> (sort li)
out = (1 2 5 7 9)
> li
out = (9 5 7 2 1)
```

## `(sort! xs f)`
*Defined at lib/core/list.lisp:874:2*

Sort the list `XS` in place, optionally using `F` as a comparator.

### Example:
> (define li '(9 5 7 2 1))
out = (9 5 7 2 1)
> (sort! li)
out = (1 2 5 7 9)
> li
out = (1 2 5 7 9)
```

## `(split xs y)`
*Defined at lib/core/list.lisp:819:2*

Splits a list into sub-lists by the separator `Y`.

### Example:
```cl
> (split '(1 2 3 4) 3)
out = ((1 2) (4))
```

## `(sum xs)`
*Defined at lib/core/list.lisp:771:2*

Return the sum of all elements in `XS`.

### Example:
```cl
> (sum '(1 2 3 4))
out = 10
```

## `(take xs n)`
*Defined at lib/core/list.lisp:134:2*

Take the first `N` elements of the list `XS`.

### Example:
```cl
> (take '(1 2 3 4 5) 2)
out = (1 2)
```

## `(take-while p xs idx)`
*Defined at lib/core/list.lisp:791:2*

Takes elements from the list `XS` while the predicate `P` is true,
starting at index `IDX`. Works like `filter`, but stops after the
first non-matching element.

### Example:
```cl
> (define list '(2 2 4 3 9 8 4 6))
> (define p (lambda (x) (= (mod x 2) 0)))
> (filter p list)
out = (2 2 4 8 4 6)
> (take-while p list 1)
out = (2 2 4)
```

## `(traverse xs f)`
*Defined at lib/core/list.lisp:475:2*

>**Warning:** traverse is deprecated: Use [`map`](lib.core.list.md#map-fn-xss) instead.

An alias for [`map`](lib.core.list.md#map-fn-xss) with the arguments `XS` and `F` flipped.

### Example:
```cl
> (traverse '(1 2 3) succ)
out = (2 3 4)
```

## `(union &xss)`
*Defined at lib/core/list.lisp:373:2*

Set-like union of all the lists in `XSS`. Note that this function does
not preserve the lists' orders.

### Example:
```cl
> (union '(1 2 3 4) '(1 2 3 4 5))
out = (1 2 3 4 5)
```

## Undocumented symbols
 - `(caaaar xs)` *Defined at lib/core/list.lisp:889:1*
 - `(caaaars xs)` *Defined at lib/core/list.lisp:889:1*
 - `(caaadr xs)` *Defined at lib/core/list.lisp:889:1*
 - `(caaadrs xs)` *Defined at lib/core/list.lisp:889:1*
 - `(caaar xs)` *Defined at lib/core/list.lisp:889:1*
 - `(caaars xs)` *Defined at lib/core/list.lisp:889:1*
 - `(caadar xs)` *Defined at lib/core/list.lisp:889:1*
 - `(caadars xs)` *Defined at lib/core/list.lisp:889:1*
 - `(caaddr xs)` *Defined at lib/core/list.lisp:889:1*
 - `(caaddrs xs)` *Defined at lib/core/list.lisp:889:1*
 - `(caadr xs)` *Defined at lib/core/list.lisp:889:1*
 - `(caadrs xs)` *Defined at lib/core/list.lisp:889:1*
 - `(caar xs)` *Defined at lib/core/list.lisp:889:1*
 - `(caars xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cadaar xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cadaars xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cadadr xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cadadrs xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cadar xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cadars xs)` *Defined at lib/core/list.lisp:889:1*
 - `(caddar xs)` *Defined at lib/core/list.lisp:889:1*
 - `(caddars xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cadddr xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cadddrs xs)` *Defined at lib/core/list.lisp:889:1*
 - `(caddr xs)` *Defined at lib/core/list.lisp:889:1*
 - `(caddrs xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cadr xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cadrs xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cars xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cdaaar xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cdaaars xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cdaadr xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cdaadrs xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cdaar xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cdaars xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cdadar xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cdadars xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cdaddr xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cdaddrs xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cdadr xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cdadrs xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cdar xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cdars xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cddaar xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cddaars xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cddadr xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cddadrs xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cddar xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cddars xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cdddar xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cdddars xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cddddr xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cddddrs xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cdddr xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cdddrs xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cddr xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cddrs xs)` *Defined at lib/core/list.lisp:889:1*
 - `(cdrs xs)` *Defined at lib/core/list.lisp:889:1*
