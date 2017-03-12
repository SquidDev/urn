---
title: binders
---
# binders
## `(let vars &body)`
*Macro defined at lib/binders.lisp:41:1*

Bind several variables (given in `VARS`), then evaluate `BODY`.
In contrast to [`let*`](lib.binders.md#let-vars-body), variables bound with [`let`](lib.binders.md#let-vars-body) can not refer to
eachother.

### Example
```cl
(let [(foo 1)
      (bar 2)]
  (+ foo bar))
```

## `(let* vars &body)`
*Macro defined at lib/binders.lisp:23:1*

Bind several variables (given in `VARS`), then evaluate `BODY`.
Variables bound with [`let*`](lib.binders.md#let-vars-body) can refer to variables bound previously,
as they are evaluated in order.

### Example
```cl
(let* [(foo 1)
       (bar (+ foo 1))]
  foo
```

## `(letrec vars &body)`
*Macro defined at lib/binders.lisp:118:1*

Bind several variables (given in `VARS`), which may be recursive.

### Example
```
> (letrec [(is-even? (lambda (n)
                       (or (= 0 n)
                           (is-odd? (pred n)))))
           (is-odd? (lambda (n)
                      (and (! (= 0 n))
                           (is-even? (pred n)))))]
    (is-odd? 11))
true
```

## `(when-let vars &body)`
*Macro defined at lib/binders.lisp:56:1*

Bind `VARS`, as with [`let`](lib.binders.md#let-vars-body), and check they are all truthy before evaluating
`BODY`.
```cl
(when-let [(foo 1)
           (bar nil)]
  foo)
```
Does not evaluate `foo`, while
```
(when-let [(foo 1)
           (bar 2)]
  (+ foo bar))
```
does.

## `(when-let* vars &body)`
*Macro defined at lib/binders.lisp:75:1*

Bind each pair of `(name value)` of `VARS`, checking if the value is truthy
before binding the next, and finally evaluating `BODY`. As with [`let*`](lib.binders.md#let-vars-body),
bindings inside [`when-let*`](lib.binders.md#when-let-vars-body) can refer to previously bound names.

### Example
```cl
(when-let* [(foo 1)
            (bar nil)
            (baz 2)
  (+ foo baz))
```
Since `1` is truthy, it is evaluated and bound to `foo`, however, since
`nil` is falsey, evaluation does not continue.

## `(when-with var &body)`
*Macro defined at lib/binders.lisp:97:1*

Bind the `PAIR` var of the form `(name value)`, only evaluating `BODY` if the
value is truthy

### Example
```cl
(when-with (foo (get-idx bar :baz))
   (print! foo))
```
When `bar` has an index `baz`, it will be bound to `foo` and printed. If not,
the print statement will not be executed.

## Undocumented symbols
 - `(make-setting var)` *Defined at lib/binders.lisp:110:1*
