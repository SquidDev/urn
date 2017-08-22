---
title: binders
---
# binders
## `(let vars &body)`
*Macro defined at lib/binders.lisp:55:1*

Bind several variables (given in `VARS`), then evaluate `BODY`.
In contrast to [`let*`](lib.binders.md#let-vars-body), variables bound with [`let`](lib.binders.md#let-vars-body) can not refer
to each other.

### Example
```cl
> (let [(foo 1)
.       (bar 2)]
.   (+ foo bar))
out = 3
```

## `(let* vars &body)`
*Macro defined at lib/binders.lisp:30:1*

Bind several variables (given in `VARS`), then evaluate `BODY`.
Variables bound with [`let*`](lib.binders.md#let-vars-body) can refer to variables bound
previously, as they are evaluated in order.

### Example
```cl
> (let* [(foo 1)
.        (bar (+ foo 1))]
.   bar)
out = 2
```

## `(letrec vars &body)`
*Macro defined at lib/binders.lisp:142:1*

Bind several variables (given in `VARS`), which may be recursive.

### Example
```cl
> (letrec [(is-even? (lambda (n)
.                        (or (= 0 n)
.                            (is-odd? (pred n)))))
.            (is-odd? (lambda (n)
.                       (and (! (= 0 n))
.                            (is-even? (pred n)))))]
.     (is-odd? 11))
out = true
```

## `(loop vs test &body)`
*Macro defined at lib/binders.lisp:190:1*

`A` general iteration helper.

```cl :no-test
> (loop [(var0 val0)
.        (var1 val1)
.        ...]
.   [test test-body ...]
.   body ...)
```

Bind all the variables given in `VS`. Each iteration begins by
evaluating `TEST`. If it evaluates to a truthy value, `TEST`-`BODY`
is evaluated and the final expression in `TEST`-`BODY` is returned.
In the case that `TEST` is falsey, the set of expressions `BODY` is
evaluated. `BODY` may contain the "magic" form
`(recur val0 val1 ...)`, which rebinds the respective variables
in `VS` and reiterates.


### Examples:
```cl
> (loop [(o '())
.        (l '(1 2 3))]
.   [(empty? l) o]
.   (recur (cons (car l) o) (cdr l)))
out = (3 2 1)
```

## `(use var &body)`
*Macro defined at lib/binders.lisp:166:1*

Bind each variable in `VAR`, checking for truthyness between bindings,
execute `BODY`, then run a finaliser for all the variables bound by
`VAR`.

Potential finalisers might be:
- `(get-idx (getmetatable FOO) :--finalise)`, where `FOO` is the
  variable.
- `(get-idx FOO :close)` where `FOO` is the variable.

If there is no finaliser for `VAR`, then nothing is done for it.

### Example:
```cl
> (use [(file (io/open "tests/data/hello.txt"))]
.   (print! (self file :read "*a")))
Hello, world!
out = true
```

## `(when-let vars &body)`
*Macro defined at lib/binders.lisp:71:1*

Bind `VARS`, as with [`let`](lib.binders.md#let-vars-body), and check they are all truthy before
evaluating `BODY`.

```cl
> (when-let [(foo 1)
.            (bar nil)]
.   foo)
out = nil
```
Does not evaluate `foo`, while
```
> (when-let [(foo 1)
.            (bar 2)]
.   (+ foo bar))
out = 3
```
does.

## `(when-let* vars &body)`
*Macro defined at lib/binders.lisp:93:1*

Bind each pair of `(name value)` of `VARS`, checking if the value is
truthy before binding the next, and finally evaluating `BODY`. As with
[`let*`](lib.binders.md#let-vars-body), bindings inside [`when-let*`](lib.binders.md#when-let-vars-body) can refer to previously bound
names.

### Example
```cl
> (when-let* [(foo 1)
.             (bar nil)
.             (baz 2)]
.   (+ foo baz))
out = nil
```

Since `1` is truthy, it is evaluated and bound to `foo`, however,
since `nil` is falsey, evaluation does not continue.

## `(when-with var &body)`
*Macro defined at lib/binders.lisp:118:1*

Bind the `PAIR` var of the form `(name value)`, only evaluating `BODY` if
the value is truthy

### Example
```cl
> (when-with (foo (.> { :baz "foo" } :baz))
.   (print! foo))
foo
out = nil
```

When `bar` has an index `baz`, it will be bound to `foo` and
printed. If not, the print statement will not be executed.

## `(with var &body)`
*Macro defined at lib/binders.lisp:51:1*

Bind the single variable `VAR`, then evaluate `BODY`.

