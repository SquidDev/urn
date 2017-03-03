---
title: lib/pair
---
# lib/pair
## `(cons->pair x)`
*Defined at lib/pair.lisp:22:1*

Convert the cons structure `X` into a pair, where [`cons`](lib.base.md#cons-x-xs)es have been replaced
by applications of [`pair`](lib.pair.md#pair-x-y). Aditionally, it holds that
  `(eq? (car x) (fst (cons->pair x)))`
and
  `(eq? (cdr x) (snd (cons->pair x)))`

## `(fst x)`
*Defined at lib/pair.lisp:14:1*

Extract the first component of the pair `X`.

## `(pair x y)`
*Defined at lib/pair.lisp:5:1*

Build a pair out of the values `X` and `Y`. `X` and `Y` must both `exist?`,
otherwise an invalid pair will be produced.

## `(pair->cons x)`
*Defined at lib/pair.lisp:32:1*

The opposite of [`cons->pair`](lib.pair.md#cons-pair-x), building a [`cons`](lib.base.md#cons-x-xs) structure out of the
(possibly nested) pair `X`. Conversely, it holds that
  `(eq? (fst x) (cdr (pair->cons x)))`
and
  `(eq? (snd x) (car (pair->cons x)))`

## `(pair? x)`
*Defined at lib/pair.lisp:43:1*

Test if `X` is a pair.

## `(snd x)`
*Defined at lib/pair.lisp:18:1*

Extract the second component of the pair `X`.

