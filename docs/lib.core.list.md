---
title: core/list
---
# core/list
List manipulation functions.

These include several often-used functions for manipulation of lists,
including functional programming classics such as [`map`](lib.core.list.md#map) and [`reduce`](lib.core.list.md#reduce)
and useful patterns such as [`accumulate-with`](lib.core.list.md#accumulate-with).

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

## `\\`
*Defined at lib/core/list.lisp:269:2*

The difference between `XS` and `YS` (non-associative.)

### Example:
```cl
> (\\ '(1 2 3) '(1 3 5 7))
out = (2)
```

## `accumulate-with`
*Defined at lib/core/list.lisp:617:2*

`A` composition of [`reduce`](lib.core.list.md#reduce) and [`map`](lib.core.list.md#map).

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

## `all`
*Defined at lib/core/list.lisp:310:2*

Test if all elements of `XS` match the predicate `P`.

### Example:
```cl
> (all symbol? '(foo bar baz))
out = true
> (all number? '(1 2 foo))
out = false
```

## `any`
*Defined at lib/core/list.lisp:239:2*

Check for the existence of an element in `XS` that matches the predicate
`P`.

### Example:
```cl
> (any exists? '(nil 1 "foo"))
out = true
```

## `append`
*Defined at lib/core/list.lisp:554:2*

Concatenate `XS` and `YS`.

### Example:
```cl
> (append '(1 2) '(3 4))
out = (1 2 3 4)
``` 

## `car`
*Defined at lib/core/list.lisp:34:2*

Return the first element present in the list `X`. This function operates
in constant time.

### Example:
```cl
> (car '(1 2 3))
out = 1
```

## `cdr`
*Defined at lib/core/list.lisp:46:2*

Return the list `X` without the first element present. In the case that
`X` is nil, the empty list is returned. Due to the way lists are
represented internally, this function runs in linear time.

### Example:
```cl
> (cdr '(1 2 3))
out = (2 3)
```

## `cons`
*Defined at lib/core/list.lisp:93:2*

Return a copy of the list `XSS` with the elements `XS` added to its head.

### Example:
```cl
> (cons 1 2 3 '(4 5 6))
out = (1 2 3 4 5 6)
```

## `do`
*Macro defined at lib/core/list.lisp:527:2*

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

## `dolist`
*Macro defined at lib/core/list.lisp:497:2*

Iterate over all given `VARS`, running `STMTS` and collecting the results.

### Example:
```cl
> (dolist [(a '(1 2 3))
.          (b '(1 2 3))]
.   (list a b))
out = ((1 1) (1 2) (1 3) (2 1) (2 2) (2 3) (3 1) (3 2) (3 3))
```

## `drop`
*Defined at lib/core/list.lisp:71:2*

Remove the first `N` elements of the list `XS`.

### Example:
```cl
> (drop '(1 2 3 4 5) 2)
out = (3 4 5)
```

## `elem?`
*Defined at lib/core/list.lisp:331:2*

Test if `X` is present in the list `XS`.

### Example:
```cl
> (elem? 1 '(1 2 3))
out = true
> (elem? 'foo '(1 2 3))
out = false
```

## `exclude`
*Defined at lib/core/list.lisp:228:2*

Return a list with only the elements of `XS` that don't match the
predicate `P`.

### Example:
```cl
> (exclude even? '(1 2 3 4 5 6))
out = (1 3 5)
```

## `filter`
*Defined at lib/core/list.lisp:217:2*

Return a list with only the elements of `XS` that match the predicate
`P`.

### Example:
```cl
> (filter even? '(1 2 3 4 5 6))
out = (2 4 6)
```

## `flat-map`
*Defined at lib/core/list.lisp:187:2*

Map the function `FN` over the lists `XSS`, then flatten the result
lists.

### Example:
```cl
> (flat-map list '(1 2 3) '(4 5 6))
out = (1 4 2 5 3 6)
```

## `flatten`
*Defined at lib/core/list.lisp:564:2*

Concatenate all the lists in `XSS`. `XSS` must not contain elements which
are not lists.

### Example:
```cl
> (flatten '((1 2) (3 4)))
out = (1 2 3 4)
```

## `for-each`
*Macro defined at lib/core/list.lisp:481:2*

>**Warning:** for-each is deprecated: Use [`do`](lib.core.list.md#do)/[`dolist`](lib.core.list.md#dolist) instead

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

## `groups-of`
*Defined at lib/core/list.lisp:705:2*

Splits the list `XS` into sub-lists of size `NUM`.

### Example:
```cl
> (groups-of '(1 2 3 4 5 6) 3)
out = ((1 2 3) (4 5 6))
```

## `init`
*Defined at lib/core/list.lisp:379:2*

Return the list `XS` with the last element removed.
This is the dual of `LAST`.

### Example:
```cl
> (init (range :from 1 :to 10))
out = (1 2 3 4 5 6 7 8 9)
```

## `insert-nth!`
*Defined at lib/core/list.lisp:467:2*

Mutate the list `LI`, inserting `VAL` at `IDX`.

### Example:
```cl
> (define list '(1 2 3))
> (insert-nth! list 2 5)
> list
out = (1 5 2 3)
``` 

## `last`
*Defined at lib/core/list.lisp:367:2*

Return the last element of the list `XS`.
Counterintutively, this function runs in constant time.

### Example:
```cl
> (last (range :from 1 :to 100))
out = 100
```

## `map`
*Defined at lib/core/list.lisp:134:2*

Iterate over all the successive cars of `XSS`, producing a single list
by applying `FN` to all of them. For example:

### Example:
```cl
> (map list '(1 2 3) '(4 5 6) '(7 8 9))
out = ((1 4 7) (2 5 8) (3 6 9))
> (map succ '(1 2 3))
out = (2 3 4)
```

## `maybe-map`
*Defined at lib/core/list.lisp:158:2*

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

## `none`
*Defined at lib/core/list.lisp:259:2*

Check that no elements in `XS` match the predicate `P`.

### Example:
```cl
> (none nil? '("foo" "bar" "baz"))
out = true
```

## `nth`
*Defined at lib/core/list.lisp:391:2*

Get the `IDX` th element in the list `XS`. The first element is 1.
This function runs in constant time.

### Example:
```cl
> (nth (range :from 1 :to 100) 10)
out = 10
```

## `nths`
*Defined at lib/core/list.lisp:404:2*

Get the IDX-th element in all the lists given at `XSS`. The first
element is1.

### Example:
```cl
> (nths '((1 2 3) (4 5 6) (7 8 9)) 2)
out = (2 5 8)
```

## `nub`
*Defined at lib/core/list.lisp:281:2*

Remove duplicate elements from `XS`. This runs in linear time.

### Example:
```cl
> (nub '(1 1 2 2 3 3))
out = (1 2 3)
```

## `partition`
*Defined at lib/core/list.lisp:198:2*

Split `XS` based on the predicate `P`. Values for which the predicate
returns true are returned in the first list, whereas values which
don't pass the predicate are returned in the second list.

### Example:
```cl
> (list (partition even? '(1 2 3 4 5 6)))
out = ((2 4 6) (1 3 5))
```

## `pop-last!`
*Defined at lib/core/list.lisp:435:2*

Mutate the list `XS`, removing and returning its last element.

### Example:
```cl
> (define list '(1 2 3))
> (pop-last! list)
out = 3
> list
out = (1 2)
``` 

## `prod`
*Defined at lib/core/list.lisp:646:2*

Return the product of all elements in `XS`.

### Example:
```cl
> (prod '(1 2 3 4))
out = 24
```

## `prune`
*Defined at lib/core/list.lisp:344:2*

Remove values matching the predicates [`empty?`](lib.core.type.md#empty-) or [`nil?`](lib.core.type.md#nil-) from
the list `XS`.

### Example:
```cl
> (prune (list '() nil 1 nil '() 2))
out = (1 2)
```

## `push-cdr!`
*Defined at lib/core/list.lisp:418:2*

Mutate the list `XS`, adding `VAL` to its end.

### Example:
```cl
> (define list '(1 2 3))
> (push-cdr! list 4)
out = (1 2 3 4)
> list
out = (1 2 3 4)
```

## `range`
*Defined at lib/core/list.lisp:575:2*

Build a list from :`FROM` to :`TO`, optionally passing by :`BY`.

### Example:
```cl
> (range :from 1 :to 10)
out = (1 2 3 4 5 6 7 8 9 10)
> (range :from 1 :to 10 :by 3)
out = (1 3 5 7 9)
```

## `reduce`
*Defined at lib/core/list.lisp:103:2*

Accumulate the list `XS` using the binary function `F` and the zero
element `Z`.  This function is also called `foldl` by some authors. One
can visualise `(reduce f z xs)` as replacing the [`cons`](lib.core.list.md#cons) operator in
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

## `remove-nth!`
*Defined at lib/core/list.lisp:452:2*

Mutate the list `LI`, removing the value at `IDX` and returning it.

### Example:
```cl
> (define list '(1 2 3))
> (remove-nth! list 2)
out = 2
> list
out = (1 3)
``` 

## `reverse`
*Defined at lib/core/list.lisp:604:2*

Reverse the list `XS`, using the accumulator `ACC`.

### Example:
```cl
> (reverse (range :from 1 :to 10))
out = (10 9 8 7 6 5 4 3 2 1)
```

## `snoc`
*Defined at lib/core/list.lisp:81:2*

Return a copy of the list `XS` with the element `XS` added to its end.
This function runs in linear time over the two input lists: That is,
it runs in `O`(n+k) time proportional both to `(n XSS)` and `(n XS)`.

### Example:
```cl
> (snoc '(1 2 3) 4 5 6)
out = (1 2 3 4 5 6)
``` 

## `sort`
*Defined at lib/core/list.lisp:723:2*

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

## `sort!`
*Defined at lib/core/list.lisp:741:2*

Sort the list `XS` in place, optionally using `F` as a comparator.

### Example:
> (define li '(9 5 7 2 1))
out = (9 5 7 2 1)
> (sort! li)
out = (1 2 5 7 9)
> li
out = (1 2 5 7 9)
```

## `split`
*Defined at lib/core/list.lisp:686:2*

Splits a list into sub-lists by the separator `Y`.

### Example:
```cl
> (split '(1 2 3 4) 3)
out = ((1 2) (4))
```

## `sum`
*Defined at lib/core/list.lisp:636:2*

Return the sum of all elements in `XS`.

### Example:
```cl
> (sum '(1 2 3 4))
out = 10
```

## `take`
*Defined at lib/core/list.lisp:61:2*

Take the first `N` elements of the list `XS`.

### Example:
```cl
> (take '(1 2 3 4 5) 2)
out = (1 2)
```

## `take-while`
*Defined at lib/core/list.lisp:656:2*

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

## `traverse`
*Defined at lib/core/list.lisp:356:2*

>**Warning:** traverse is deprecated: Use [`map`](lib.core.list.md#map) instead.

An alias for [`map`](lib.core.list.md#map) with the arguments `XS` and `F` flipped.

### Example:
```cl
> (traverse '(1 2 3) succ)
out = (2 3 4)
```

## `union`
*Defined at lib/core/list.lisp:300:2*

Set-like union of `XS` and `YS`.

### Example:
```cl
> (union '(1 2 3 4) '(1 2 3 4 5))
out = (1 2 3 4 5)
```

## Undocumented symbols
 - `caaaar` *Defined at lib/core/list.lisp:756:1*
 - `caaaars` *Defined at lib/core/list.lisp:756:1*
 - `caaadr` *Defined at lib/core/list.lisp:756:1*
 - `caaadrs` *Defined at lib/core/list.lisp:756:1*
 - `caaar` *Defined at lib/core/list.lisp:756:1*
 - `caaars` *Defined at lib/core/list.lisp:756:1*
 - `caadar` *Defined at lib/core/list.lisp:756:1*
 - `caadars` *Defined at lib/core/list.lisp:756:1*
 - `caaddr` *Defined at lib/core/list.lisp:756:1*
 - `caaddrs` *Defined at lib/core/list.lisp:756:1*
 - `caadr` *Defined at lib/core/list.lisp:756:1*
 - `caadrs` *Defined at lib/core/list.lisp:756:1*
 - `caar` *Defined at lib/core/list.lisp:756:1*
 - `caars` *Defined at lib/core/list.lisp:756:1*
 - `cadaar` *Defined at lib/core/list.lisp:756:1*
 - `cadaars` *Defined at lib/core/list.lisp:756:1*
 - `cadadr` *Defined at lib/core/list.lisp:756:1*
 - `cadadrs` *Defined at lib/core/list.lisp:756:1*
 - `cadar` *Defined at lib/core/list.lisp:756:1*
 - `cadars` *Defined at lib/core/list.lisp:756:1*
 - `caddar` *Defined at lib/core/list.lisp:756:1*
 - `caddars` *Defined at lib/core/list.lisp:756:1*
 - `cadddr` *Defined at lib/core/list.lisp:756:1*
 - `cadddrs` *Defined at lib/core/list.lisp:756:1*
 - `caddr` *Defined at lib/core/list.lisp:756:1*
 - `caddrs` *Defined at lib/core/list.lisp:756:1*
 - `cadr` *Defined at lib/core/list.lisp:756:1*
 - `cadrs` *Defined at lib/core/list.lisp:756:1*
 - `cars` *Defined at lib/core/list.lisp:756:1*
 - `cdaaar` *Defined at lib/core/list.lisp:756:1*
 - `cdaaars` *Defined at lib/core/list.lisp:756:1*
 - `cdaadr` *Defined at lib/core/list.lisp:756:1*
 - `cdaadrs` *Defined at lib/core/list.lisp:756:1*
 - `cdaar` *Defined at lib/core/list.lisp:756:1*
 - `cdaars` *Defined at lib/core/list.lisp:756:1*
 - `cdadar` *Defined at lib/core/list.lisp:756:1*
 - `cdadars` *Defined at lib/core/list.lisp:756:1*
 - `cdaddr` *Defined at lib/core/list.lisp:756:1*
 - `cdaddrs` *Defined at lib/core/list.lisp:756:1*
 - `cdadr` *Defined at lib/core/list.lisp:756:1*
 - `cdadrs` *Defined at lib/core/list.lisp:756:1*
 - `cdar` *Defined at lib/core/list.lisp:756:1*
 - `cdars` *Defined at lib/core/list.lisp:756:1*
 - `cddaar` *Defined at lib/core/list.lisp:756:1*
 - `cddaars` *Defined at lib/core/list.lisp:756:1*
 - `cddadr` *Defined at lib/core/list.lisp:756:1*
 - `cddadrs` *Defined at lib/core/list.lisp:756:1*
 - `cddar` *Defined at lib/core/list.lisp:756:1*
 - `cddars` *Defined at lib/core/list.lisp:756:1*
 - `cdddar` *Defined at lib/core/list.lisp:756:1*
 - `cdddars` *Defined at lib/core/list.lisp:756:1*
 - `cddddr` *Defined at lib/core/list.lisp:756:1*
 - `cddddrs` *Defined at lib/core/list.lisp:756:1*
 - `cdddr` *Defined at lib/core/list.lisp:756:1*
 - `cdddrs` *Defined at lib/core/list.lisp:756:1*
 - `cddr` *Defined at lib/core/list.lisp:756:1*
 - `cddrs` *Defined at lib/core/list.lisp:756:1*
 - `cdrs` *Defined at lib/core/list.lisp:756:1*
