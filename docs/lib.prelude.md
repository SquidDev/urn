---
title: prelude
---
# prelude
## `(! expr)`
*Defined at lib/base.lisp:80:1*

Negate the expression `EXPR`.

## `($ str)`
*Macro defined at lib/string.lisp:91:1*

Perform interpolation (variable substitution) on the string `STR`.

The string is a sequence of arbitrary characters which may contain
an unquote, of the form `~{foo}`, where foo is a variable name.

### Example:
```cl
> (let* [(x 1)] ($ "~{x} = 1"))
out = "1 = 1"
```

## `*standard-error*`
*Defined at lib/prelude.lisp:29:1*

The standard error stream.

## `*standard-input*`
*Defined at lib/prelude.lisp:33:1*

The standard error stream.

## `*standard-output*`
*Defined at lib/prelude.lisp:25:1*

The standard output stream.

## `(-> x &funcs)`
*Macro defined at lib/function.lisp:59:1*

Chain a series of method calls together. If the list contains `<>`
then the value is placed there, otherwise the expression is invoked
with the previous entry as an argument.

### Example
```
> (-> '(1 2 3)
    (map succ <>)
    (map (cut * <> 2) <>))
(4 6 8)
```

## `(.<! x &keys value)`
*Macro defined at lib/table.lisp:91:1*

Set the value at `KEYS` in the structure `X` to `VALUE`.

## `(.> x &keys)`
*Macro defined at lib/table.lisp:85:1*

Index the structure `X` with the sequence of accesses given by `KEYS`.

## `(<=> p q)`
*Macro defined at lib/base.lisp:150:1*

Bidirectional implication. `(<=> a b)` means that `(=> a b)` and
`(=> b a)` both hold.

## `(<> &lenses)`
*Defined at lib/lens.lisp:148:1*

Compose, left-associatively, the list of lenses given by `LENSES`.

## `(=> p q)`
*Macro defined at lib/base.lisp:146:1*

Logical implication. `(=> a b)` is equivalent to `(or (! a) b)`.

## `(\\ xs ys)`
*Defined at lib/list.lisp:271:1*

The difference between `XS` and `YS` (non-associative.)

### Example:
```
> (\ '(1 2 3) '(1 3 5 7))
out = (2)
```

## `(^. val lens)`
*Defined at lib/lens.lisp:159:1*

Use `LENS` to focus on a bit of `VAL`.

## `(^= val lens new)`
*Defined at lib/lens.lisp:171:1*

Use `LENS` to replace a bit of `VAL` with `NEW`.

## `(^~ val lens f)`
*Defined at lib/lens.lisp:165:1*

Use `LENS` to apply the function `F` over a bit of `VAL`.

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

## `(accumulating f z l)`
*Defined at lib/lens.lisp:320:1*

Transform the lens `L` into a getter which folds the result using the
function `F` and the zero element `Z`. For performance reasons, a right
fold is performed.

Example:
```cl
> (view (accumulating + 0 (on :bar))
.       (list { :bar 1 }
.             { :bar 2 }
.             { :baz 3 } ))
out = 3
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

## `(and a b &rest)`
*Macro defined at lib/base.lisp:134:1*

Return the logical and of values `A` and `B`, and, if present, the
logical and of all the values in `REST`.

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

## `(apply f xs)`
*Defined at lib/base.lisp:274:1*

Apply the function `F` using `XS` as the argument list.

### Example:
```cl
> (apply + '(1 2))
3
```

## `arg`
*Defined at lib/base.lisp:222:1*

The arguments passed to the currently executing program

## `(as-is x)`
*Defined at lib/prelude.lisp:99:1*

Return the value `X` unchanged.

## `(assert-type! arg ty)`
*Macro defined at lib/type.lisp:163:1*

Assert that the argument `ARG` has type `TY`, as reported by the function
[`type`](lib.type.md#type-val).

## `(assoc list key or-val)`
*Defined at lib/table.lisp:10:1*

Return the value given by `KEY` in the association list `LIST`, or, in the
case that it does not exist, the value `OR`-`VAL`, which can be nil.

## `(assoc->struct list)`
*Defined at lib/table.lisp:46:1*

Convert the association list `LIST` into a structure. Much like
[`assoc`](lib.table.md#assoc-list-key-or-val), in the case there are several values bound to the same key,
the first value is chosen.

## `(assoc? list key)`
*Defined at lib/table.lisp:21:1*

Check that `KEY` is bound in the association list `LIST`.

## `(at k)`
*Defined at lib/lens.lisp:233:1*

`A` lens that focuses on the `K`-th element of a list. [`view`](lib.lens.md#view-l-v) is
equivalent to `get-idx`, and [`over`](lib.lens.md#over-l-f-v) is like `set-idx!`.

### Example:
```cl
> (^. '(1 2 3) (at 2))
out = 2
```

## `(atom? x)`
*Defined at lib/type.lisp:55:1*

Check whether `X` is an atomic object, that is, one of
- `A` boolean
- `A` string
- `A` number
- `A` symbol
- `A` key
- `A` function

## `(between? val min max)`
*Defined at lib/type.lisp:83:1*

Check if the numerical value `X` is between
`MIN` and `MAX`.

## `bool->string`
*Defined at lib/prelude.lisp:57:1*

Convert the boolean `X` into a string.

## `(boolean? x)`
*Defined at lib/type.lisp:41:1*

Check whether `X` is a boolean.

## `(call x key &args)`
*Defined at lib/prelude.lisp:108:1*

Index `X` with `KEY` and invoke the resulting function with `ARGS`.

## `(car x)`
*Defined at lib/list.lisp:34:1*

Return the first element present in the list `X`. This function operates
in constant time.

### Example:
```cl
> (car '(1 2 3))
out = 1
```

## `(case val &pts)`
*Macro defined at lib/match.lisp:382:1*

Match a single value against a series of patterns, evaluating the
first body that matches, much like `cond`.

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

## `(comp &fs)`
*Defined at lib/function.lisp:112:1*

Return the pointwise composition of all functions in `FS`.

### Example:
```cl
> ((comp succ (cut + <> 2) (cut * <> 2))
.  2)
out = 7
```

## `(compose f g)`
*Defined at lib/function.lisp:98:1*

Return the pointwise composition of functions `F` and `G`.

### Example:
```cl
> ((compose (cut + <> 2) (cut * <> 2))
.  2)
out = 6
```

## `(cons &xs xss)`
*Defined at lib/list.lisp:93:1*

Return a copy of the list `XSS` with the elements `XS` added to its head.

### Example:
```cl
> (cons 1 2 3 '(4 5 6))
out = (1 2 3 4 5 6)
```

## `(const x)`
*Defined at lib/prelude.lisp:103:1*

Return a function which always returns `X`. This is equivalent to the
`K` combinator in `SK` combinator calculus.

## `(const-val val)`
*Defined at lib/base.lisp:234:1*

Get the actual value of `VAL`, an argument to a macro.

Due to how macros are implemented, all values are wrapped as tables
in order to preserve positional data about nodes. You will need to
unwrap them in order to use them.

## `(create-lookup values)`
*Defined at lib/table.lisp:176:1*

Convert `VALUES` into a lookup table, with each value being converted to
a key whose corresponding value is the value's index.

## `(cut &func)`
*Macro defined at lib/function.lisp:16:1*

Partially apply a function `FUNC`, where each `<>` is replaced by an
argument to a function. Values are evaluated every time the resulting
function is called.

### Example
```
> (define double (cut * <> 2))
> (double 3)
6
```

## `(cute &func)`
*Macro defined at lib/function.lisp:37:1*

Partially apply a function `FUNC`, where each `<>` is replaced by an
argument to a function. Values are evaluated when this function is
defined.

### Example
```
> (define double (cute * <> 2))
> (double 3)
6
```

## `(debug x)`
*Macro defined at lib/base.lisp:166:1*

Print the value `X`, then return it unmodified.

## `(defmacro name args &body)`
*Macro defined at lib/base.lisp:38:1*

Define `NAME` to be the macro given by (lambda `ARGS` @`BODY`), with
optional metadata at the start of `BODY`.

## `(defun name args &body)`
*Macro defined at lib/base.lisp:32:1*

Define `NAME` to be the function given by (lambda `ARGS` @`BODY`), with
optional metadata at the start of `BODY`.

## `(destructuring-bind pt &body)`
*Macro defined at lib/match.lisp:365:1*

Match a single pattern against a single value, then evaluate the `BODY`.

The pattern is given as `(car PT)` and the value as `(cadr PT)`.  If
the pattern does not match, an error is thrown.

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

## `(empty-struct? xs)`
*Defined at lib/table.lisp:137:1*

Check that `XS` is the empty struct.

## `(empty? x)`
*Defined at lib/type.lisp:17:1*

Check whether `X` is the empty list or the empty string.

## `(eq? x y)`
*Defined at lib/type.lisp:96:1*

Compare `X` and `Y` for equality deeply.
Rules:
- If `X` and `Y` exist, `X` and `Y` are equal if:
  - If `X` or `Y` are a symbol
    - Both are symbols, and their contents are equal.
    - `X` is a symbol, and `Y` is a string equal to the symbol's contents.
    - `Y` is a symbol, and `X` is a string equal to the symbol's contents.
  - If `X` or `Y` are a key
    - Both are keys, and their values are equal.
    - `X` is a key, and `Y` is a string equal to the key's contents.
    - `Y` is a key, and `X` is a string equal to the key's contents.
  - If `X` or `Y` are lists
    - Both are empty.
    - Both have the same length, their `car`s are equal, and their `cdr`s
      are equal.
  - Otherwise, `X` and `Y` are equal if they are the same value.
- If `X` or `Y` do not exist
  - They are not equal if one exists and the other does not.
  - They are equal if neither exists.  

## `(eql? x y)`
*Defined at lib/type.lisp:149:1*

`A` version of [`eq?`](lib.type.md#eq-x-y) that compares the types of `X` and `Y` instead of
just the values.

### Example:
```cl
> (eq? 'foo "foo")
out = true
> (eql? 'foo "foo")
out = false
```

## `error!`
*Defined at lib/prelude.lisp:75:1*

Throw an error.

## `(even? x)`
*Defined at lib/prelude.lisp:116:1*

Is `X` an even number?

## `(every x ln)`
*Defined at lib/lens.lisp:336:1*

`A` higher-order lens that focuses `LN` on every element of a list that
satisfies the perdicate `X`. If `X` is a regular value, it is compared
for equality (according to [`eql?`](lib.type.md#eql-x-y)) with every list element. If it
is a function, it is treated as the predicate.


Example:
```cl
> (view (every even? it) '(1 2 3 4 5 6))
out = (2 4 6)
> (view (every 'x it) '(1 x 2 x 3 x 4 x))
out = (x x x x)
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

## `(exists? x)`
*Defined at lib/type.lisp:73:1*

Check if `X` exists, i.e. it is not the special value `nil`.
Note that, in Urn, `nil` is not the empty list.

## `(exit! reason code)`
*Defined at lib/prelude.lisp:88:1*

Exit the program with the exit code `CODE`, and optionally, print the
error message `REASON`.

## `(extend ls key val)`
*Defined at lib/table.lisp:36:1*

Extend the association list `LIST`_ by inserting `VAL`, bound to the key
`KEY`, overriding any previous value.

## `(fail! x)`
*Defined at lib/prelude.lisp:83:1*

Fail with the error message `X`, that is, exit the program immediately,
without unwinding for an error handler.

## `(falsey? x)`
*Defined at lib/type.lisp:68:1*

Check whether `X` is falsey, that is, it is either `false` or does not
exist.

## `(fast-struct &entries)`
*Defined at lib/table.lisp:124:1*

`A` variation of [`struct`](lib.table.md#struct-entries), which will not perform any coercing of the
`KEYS` in entries.

Note, if you know your values at compile time, it is more performant
to use a struct literal.

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

## `(folding f z l)`
*Defined at lib/lens.lisp:304:1*

Transform the (traversing) lens `L` into a getter which folds
the result using the function `F` and the zero element `Z`. For
performance reasons, a right fold is performed.

Example:
```cl
> (view (folding + 0 (traversing (on :bar)))
.       (list { :bar 1 }
.             { :bar 2 }
.             { :baz 3 } ))
out = 3
```

## `(for ctr start end step &body)`
*Macro defined at lib/base.lisp:100:1*

Iterate `BODY`, with the counter `CTR` bound to `START`, being incremented
by `STEP` every iteration until `CTR` is outside of the range given by
[`START` .. `END`]

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

## `(for-pairs vars tbl &body)`
*Macro defined at lib/base.lisp:177:1*

Iterate over `TBL`, binding `VARS` for each key value pair in `BODY`

## `(function &arms)`
*Macro defined at lib/match.lisp:435:1*

Create a lambda which matches its arguments against the patterns
defined in `ARMS`.

## `(function? x)`
*Defined at lib/type.lisp:47:1*

Check whether `X` is a function.

## `gensym`
*Defined at lib/base.lisp:84:1*

Create a unique symbol, suitable for using in macros

## `(getter view)`
*Defined at lib/lens.lisp:98:1*

Define a getting lens using `VIEW` as the accessor.

Lenses built with [`getter`](lib.lens.md#getter-view) can be composed (with [`<>`](lib.lens.md#-lenses)) or used
to focus on a value (with [`view`](lib.lens.md#view-l-v)).

## `(getter? lens)`
*Defined at lib/lens.lisp:120:1*

Check that `LENS` has a defined getter, along with being tagged as
a `LENS`. This is essentially a relaxed version of [`lens?`](lib.lens.md#lens-lens) in
regards to the setter check.

## `(handler-case x &body)`
*Macro defined at lib/match.lisp:406:1*

Evaluate the form `X`, and if an error happened, match the series
of `(?pattern (?arg) . ?body)` arms given in `BODY` against the value of
the error, executing the first that succeeeds.

In the case that `X` does not throw an error, the value of that
expression is returned by [`handler-case`](lib.match.md#handler-case-x-body).

### Example:

```cl
> (handler-case \
.   (error! "oh no!")
.   [string? (x)
.    (print! x)])
```

## `head`
*Defined at lib/lens.lisp:211:1*

`A` lens equivalent to [`car`](lib.list.md#car-x), which [`view`](lib.lens.md#view-l-v)s and applies [`over`](lib.lens.md#over-l-f-v)
the first element of a list.

### Example:
```cl
> (^. '(1 2 3) head)
out = 1
```

## `(id x)`
*Defined at lib/prelude.lisp:95:1*

Return the value `X` unmodified.

## `(if c t b)`
*Macro defined at lib/base.lisp:59:1*

Evaluate `T` if `C` is true, otherwise, evaluate `B`.

## `(if-match cs t e)`
*Macro defined at lib/match.lisp:449:1*

Matches a pattern against a value defined in `CS`, evaluating `T` with the
captured variables in scope if the pattern succeeded, otherwise
evaluating `E`.

[`if-match`](lib.match.md#if-match-cs-t-e) is to [`case`](lib.match.md#case-val-pts) what [`if`](lib.base.md#if-c-t-b) is to `cond`.

## `(init xs)`
*Defined at lib/list.lisp:381:1*

Return the list `XS` with the last element removed.
This is the dual of `LAST`.

### Example:
```cl
> (init (range :from 1 :to 10))
out = '(1 2 3 4 5 6 7 8 9)
```

## `(insert list_ key val)`
*Defined at lib/table.lisp:31:1*

Extend the association list `LIST`_ by inserting `VAL`, bound to the key
`KEY`.

## `(insert! list_ key val)`
*Defined at lib/table.lisp:41:1*

Extend the association list `LIST`_ in place by inserting `VAL`, bound to
the key `KEY`.

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

## `(invokable? x)`
*Defined at lib/function.lisp:80:1*

Test if the expression `X` makes sense as something that can be applied
to a set of arguments.

### Example
```
> (invokable? invokable?)
true
> (invokable? nil)
false
> (invokable? (setmetatable {} { :__call (lambda (x) (print! "hello")) }))
true
```

## `it`
*Defined at lib/lens.lisp:201:1*

The simplest lens, not focusing on any subcomponent. In the case of [`over`](lib.lens.md#over-l-f-v),
if the value being focused on is a list, the function is mapped over every
element of the list.

## `(iter-pairs table func)`
*Defined at lib/table.lisp:147:1*

Iterate over `TABLE` with a function `FUNC` of the form `(lambda (key val) ...)`

## `(key? x)`
*Defined at lib/type.lisp:51:1*

Check whether `X` is a key.

## `(keys st)`
*Defined at lib/table.lisp:159:1*

Return the keys in the structure `ST`.

## `(last xs)`
*Defined at lib/list.lisp:369:1*

Return the last element of the list `XS`.
Counterintutively, this function runs in constant time.

### Example:
```cl
> (last (range :from 1 :to 100))
out = 100
```

## `(lens view over)`
*Defined at lib/lens.lisp:85:1*

Define a lens using `VIEW` and `OVER` as the getter and the replacer
functions, respectively.

Lenses built with [`lens`](lib.lens.md#lens-view-over) can be composed (with [`<>`](lib.lens.md#-lenses)), used
to focus on a value (with [`view`](lib.lens.md#view-l-v)), and replace that value
(with [`set`](lib.lens.md#set-l-n-v) or [`over`](lib.lens.md#over-l-f-v))

## `(lens? lens)`
*Defined at lib/lens.lisp:112:1*

Check that is `LENS` a valid lens, that is, has the proper tag, a
valid getter and a valid setter.

## `(let vars &body)`
*Macro defined at lib/binders.lisp:54:1*

Bind several variables (given in `VARS`), then evaluate `BODY`.
In contrast to [`let*`](lib.binders.md#let-vars-body), variables bound with [`let`](lib.binders.md#let-vars-body) can not refer
to each other.

### Example
```cl
(let [(foo 1)
      (bar 2)]
  (+ foo bar))
```

## `(let* vars &body)`
*Macro defined at lib/binders.lisp:30:1*

Bind several variables (given in `VARS`), then evaluate `BODY`.
Variables bound with [`let*`](lib.binders.md#let-vars-body) can refer to variables bound
previously, as they are evaluated in order.

### Example
```cl
(let* [(foo 1)
       (bar (+ foo 1))]
  foo
```

## `(letrec vars &body)`
*Macro defined at lib/binders.lisp:135:1*

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

## `(list &xs)`
*Defined at lib/base.lisp:47:1*

Return the list of variadic arguments given.

## `(list? x)`
*Defined at lib/type.lisp:13:1*

Check whether `X` is a list.

## `(loop vs test &body)`
*Macro defined at lib/binders.lisp:182:1*

`A` general iteration helper.

```cl
(loop [(var0 val0)
       (var1 val1)
       ...]
  [test test-body ...]
  body ...)
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
         (l '(1 2 3))]
.   [(empty? l) o]
.   (recur (cons (car l) o) (cdr l)))
out = (3 2 1)
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

## `(matches? pt x)`
*Macro defined at lib/match.lisp:396:1*

Test if the value `X` matches the pattern `PT`.

Note that, since this does not bind anything, all metavariables may be
replaced by `_` with no loss of meaning.

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

## `(merge &structs)`
*Defined at lib/table.lisp:151:1*

Merge all tables in `STRUCTS` together into a new table.

## `(n x)`
*Defined at lib/lua/basic.lisp:47:1*

Get the length of list X

## `(neq? x y)`
*Defined at lib/type.lisp:144:1*

Compare `X` and `Y` for inequality deeply. `X` and `Y` are `neq?`
if `([[eq?]] x y)` is falsey.

## `(nil? x)`
*Defined at lib/type.lisp:78:1*

Check if `X` does not exist, i.e. it is the special value `nil`.
Note that, in Urn, `nil` is not the empty list.

## `(nkeys st)`
*Defined at lib/table.lisp:141:1*

Return the number of keys in the structure `ST`.

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

## `number->string`
*Defined at lib/prelude.lisp:53:1*

Convert the number `X` into a string.

## `(number? x)`
*Defined at lib/type.lisp:31:1*

Check whether `X` is a number.

## `(odd? x)`
*Defined at lib/prelude.lisp:120:1*

Is `X` an odd number?

## `(on k)`
*Defined at lib/lens.lisp:254:1*

`A` lens that focuses on the element of a structure that is at the key
`K`.

### Example:
```cl
> (^. { :foo "bar" } (on :foo))
out = "bar"
```

## `(on! k)`
*Defined at lib/lens.lisp:272:1*

`A` lens that focuses (**and mutates**) the element of a structure
that is at the key `K`.

### Example:
```cl
> (define foo { :value 1 })
out = {"value" 1}
> (^= foo (on! :value) 5)
out = {"value" 5}
> foo
out = {"value" 5}
```

## `(or a b &rest)`
*Macro defined at lib/base.lisp:140:1*

Return the logical or of values `A` and `B`, and, if present, the
logical or of all the values in `REST`.

## `(over l f v)`
*Defined at lib/lens.lisp:179:1*

Flipped synonym for [`^~`](lib.lens.md#-val-lens-f)

## `(overl! lens f val)`
*Macro defined at lib/lens.lisp:193:1*

Mutate `VAL` by applying to a bit of it the function `F`, using `LENS`.

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

## `(pred x)`
*Defined at lib/prelude.lisp:41:1*

Return the predecessor of the number `X`.

## `(pretty value)`
*Defined at lib/base.lisp:193:1*

Format `VALUE` as a valid Lisp expression which can be parsed.

## `print!`
*Defined at lib/prelude.lisp:79:1*

Print to standard output.

## `(prod xs)`
*Defined at lib/list.lisp:618:1*

Return the product of all elements in `XS`.

### Example:
```cl
> (prod '(1 2 3 4))
out = 24
```

## `(progn &body)`
*Macro defined at lib/base.lisp:55:1*

Group a series of expressions together.

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

## `(quasiquote val)`
*Macro defined at lib/base.lisp:267:1*

Quote `VAL`, but replacing all `unquote` and `unquote-splice` with their actual value.

Be warned, by using this you lose all macro hygiene. Variables may not be bound to their
expected values.

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

## `(self x key &args)`
*Defined at lib/prelude.lisp:112:1*

Index `X` with `KEY` and invoke the resulting function with `X` and `ARGS`

## `(set l n v)`
*Defined at lib/lens.lisp:183:1*

Flipped synonym for [`^=`](lib.lens.md#-val-lens-new)

## `(setl! lens new val)`
*Macro defined at lib/lens.lisp:187:1*

Mutate `VAL` by replacing a bit of it with `NEW`, using `LENS`.

## `(setter over)`
*Defined at lib/lens.lisp:105:1*

Define a setting lens using `VIEW` as the accessor.

Lenses built with [`setter`](lib.lens.md#setter-over) can be composed (with [`<>`](lib.lens.md#-lenses)) or used
to replace a value (with [`over`](lib.lens.md#over-l-f-v) or [`set`](lib.lens.md#set-l-n-v)).

## `(setter? lens)`
*Defined at lib/lens.lisp:127:1*

Check that `LENS` has a defined setter, along with being tagged as
a `LENS`. This is essentially a relaxed version of [`lens?`](lib.lens.md#lens-lens) in
regards to the getter check.

## `(slot? symb)`
*Defined at lib/function.lisp:11:1*

Test whether `SYMB` is a slot. For this, it must be a symbol, whose
contents are `<>`.

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

## `string->number`
*Defined at lib/prelude.lisp:45:1*

Convert the string `X` into a number. Returns `nil` if it could not be
parsed.

Optionally takes a `BASE` which the number is in (such as 16 for
hexadecimal).

## `(string->symbol x)`
*Defined at lib/prelude.lisp:67:1*

Convert the string `X` to a symbol.

## `(string/$ str)`
*Macro defined at lib/string.lisp:91:1*

Perform interpolation (variable substitution) on the string `STR`.

The string is a sequence of arbitrary characters which may contain
an unquote, of the form `~{foo}`, where foo is a variable name.

### Example:
```cl
> (let* [(x 1)] ($ "~{x} = 1"))
out = "1 = 1"
```

## `(string/char-at xs x)`
*Defined at lib/string.lisp:9:1*

Index the string `XS`, returning the character at position `X`.

## `(string/ends-with? str suffix)`
*Defined at lib/string.lisp:79:1*

Determine whether `STR` ends with `SUFFIX`.

## `string/quoted`
*Defined at lib/string.lisp:62:1*

Quote the string `STR` so it is suitable for printing.

## `(string/split text pattern limit)`
*Defined at lib/string.lisp:13:1*

Split the string given by `TEXT` in at most `LIMIT` components, which are
delineated by the Lua pattern `PATTERN`.

It is worth noting that an empty pattern (`""`) will split the
string into individual characters.

### Example
```
> (split "foo-bar-baz" "-")
("foo" "bar" "baz")
> (split "foo-bar-baz" "-" 1)
("foo" "bar-baz")
```

## `(string/starts-with? str prefix)`
*Defined at lib/string.lisp:75:1*

Determine whether `STR` starts with `PREFIX`.

## `(string/trim str)`
*Defined at lib/string.lisp:57:1*

Remove whitespace from both sides of `STR`.

## `(string? x)`
*Defined at lib/type.lisp:25:1*

Check whether `X` is a string.

## `(struct &entries)`
*Defined at lib/table.lisp:99:1*

Return the structure given by the list of pairs `ENTRIES`. Note that, in
contrast to variations of [`let`](lib.binders.md#let-vars-body), the pairs are given "unpacked":
Instead of invoking

```cl
(struct [(:foo bar)])
```
or
```cl
(struct {:foo bar})
```
you must instead invoke it like
```cl
(struct :foo bar)
```

## `(struct->assoc tbl)`
*Defined at lib/table.lisp:62:1*

Convert the structure `TBL` into an association list. Note that
`(eq? x (struct->assoc (assoc->struct x)))` is not guaranteed,
because duplicate elements will be removed.

## `(struct->list tbl)`
*Defined at lib/table.lisp:71:1*

Converts a structure `TBL` that is a list by having its keys be indices
to a regular list.

## `(struct->list! tbl)`
*Defined at lib/table.lisp:77:1*

Converts a structure `TBL` that is a list by having its keys be indices
to a regular list. This differs from `struct->list` in that it mutates
its argument.

## `(succ x)`
*Defined at lib/prelude.lisp:37:1*

Return the successor of the number `X`.

## `(sum xs)`
*Defined at lib/list.lisp:608:1*

Return the sum of all elements in `XS`.

### Example:
```cl
> (sum '(1 2 3 4))
out = 10
```

## `(sym.. &xs)`
*Defined at lib/prelude.lisp:71:1*

Concatenate all the symbols in `XS`.

## `(symbol->string x)`
*Defined at lib/prelude.lisp:61:1*

Convert the symbol `X` to a string.

## `(symbol? x)`
*Defined at lib/type.lisp:37:1*

Check whether `X` is a symbol.

## `(table? x)`
*Defined at lib/type.lisp:8:1*

Check whether the value `X` is a table. This might be a structure,
a list, an associative list, a quoted key, or a quoted symbol.

## `tail`
*Defined at lib/lens.lisp:222:1*

`A` lens equivalent to [`cdr`](lib.list.md#cdr-x), which [`view`](lib.lens.md#view-l-v)s and applies [`over`](lib.lens.md#over-l-f-v)
to all but the first element of a list.

### Example:
```cl
> (^. '(1 2 3) tail)
out = (2 3)
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

## `(traversing l)`
*Defined at lib/lens.lisp:291:1*

`A` lens which maps the lens `L` over every element of a given list.

Example:
```cl
> (view (traverse (at 3)) '((1 2 3) (4 5 6)))
out = (3 6)
```

## `(type val)`
*Defined at lib/type.lisp:88:1*

Return the type of `VAL`.

## `(union xs ys)`
*Defined at lib/list.lisp:302:1*

Set-like union of `XS` and `YS`.

### Example:
```
> (union '(1 2 3 4) '(1 2 3 4 5))
out = (1 2 3 4 5)
```

## `(unless c &body)`
*Macro defined at lib/base.lisp:67:1*

Evaluate `BODY` if `C` is false, otherwise, evaluate `nil`.

## `(update-struct st &keys)`
*Defined at lib/table.lisp:171:1*

Create a new structure based of `ST`, setting the values given by the
pairs in `KEYS`.

## `(use var &body)`
*Macro defined at lib/binders.lisp:159:1*

Bind each variable in `VAR`, checking for truthyness between bindings,
execute `BODY`, then run a finaliser for all the variables bound by
`VAR`.

Potential finalisers might be:
- `(get-idx (getmetatable FOO) :--finalise)`, where `FOO` is the
  variable.
- `(get-idx FOO :close)` where `FOO` is the variable.

If there is no finaliser for `VAR`, then nothing is done for it.

### Example:
```
> (use [(file (io/open "temp"))] \
.   (print! (self file :read "*a")))
*contents of temp*
```

## `(values st)`
*Defined at lib/table.lisp:165:1*

Return the values in the structure `ST`.

## `(values-list &xs)`
*Macro defined at lib/base.lisp:284:1*

Return multiple values, one per element in `XS`.

### Example:
```cl
> (print! (values-list 1 2 3))
1   2   3
out = nil
```

## `(view l v)`
*Defined at lib/lens.lisp:175:1*

Flipped synonym for [`^.`](lib.lens.md#-val-lens)

## `(when c &body)`
*Macro defined at lib/base.lisp:63:1*

Evaluate `BODY` when `C` is true, otherwise, evaluate `nil`.

## `(when-let vars &body)`
*Macro defined at lib/binders.lisp:69:1*

Bind `VARS`, as with [`let`](lib.binders.md#let-vars-body), and check they are all truthy before
evaluating `BODY`.

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
*Macro defined at lib/binders.lisp:89:1*

Bind each pair of `(name value)` of `VARS`, checking if the value is
truthy before binding the next, and finally evaluating `BODY`. As with
[`let*`](lib.binders.md#let-vars-body), bindings inside [`when-let*`](lib.binders.md#when-let-vars-body) can refer to previously bound
names.

### Example
```cl
(when-let* [(foo 1)
            (bar nil)
            (baz 2)
  (+ foo baz))
```

Since `1` is truthy, it is evaluated and bound to `foo`, however,
since `nil` is falsey, evaluation does not continue.

## `(when-with var &body)`
*Macro defined at lib/binders.lisp:113:1*

Bind the `PAIR` var of the form `(name value)`, only evaluating `BODY` if
the value is truthy

### Example
```cl
(when-with (foo (get-idx bar :baz))
   (print! foo))
```

When `bar` has an index `baz`, it will be bound to `foo` and
printed. If not, the print statement will not be executed.

## `(while check &body)`
*Macro defined at lib/base.lisp:119:1*

Iterate `BODY` while the expression `CHECK` evaluates to `true`.

## `(with var &body)`
*Macro defined at lib/binders.lisp:50:1*

Bind the single variable `VAR`, then evaluate `BODY`.

## Undocumented symbols
 - `%` *Native defined at lib/lua/basic.lisp:12:1*
 - `*` *Native defined at lib/lua/basic.lisp:10:1*
 - `+` *Native defined at lib/lua/basic.lisp:8:1*
 - `-` *Native defined at lib/lua/basic.lisp:9:1*
 - `..` *Native defined at lib/lua/basic.lisp:14:1*
 - `/` *Native defined at lib/lua/basic.lisp:11:1*
 - `(/= r_170 r_171 &r_174)` *Macro defined at lib/comparison.lisp:35:1*
 - `(< r_175 r_176 &r_179)` *Macro defined at lib/comparison.lisp:36:1*
 - `(<= r_185 r_186 &r_189)` *Macro defined at lib/comparison.lisp:38:1*
 - `(= r_165 r_166 &r_169)` *Macro defined at lib/comparison.lisp:34:1*
 - `(> r_180 r_181 &r_184)` *Macro defined at lib/comparison.lisp:37:1*
 - `(>= r_190 r_191 &r_194)` *Macro defined at lib/comparison.lisp:39:1*
 - `^` *Native defined at lib/lua/basic.lisp:13:1*
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
 - `concat` *Native defined at lib/lua/table.lisp:1:1*
 - `(dec! x)` *Macro defined at lib/prelude.lisp:127:1*
 - `(fifth &rest)` *Defined at lib/base.lisp:301:1*
 - `(first &rest)` *Defined at lib/base.lisp:301:1*
 - `format` *Native defined at lib/lua/string.lisp:5:1*
 - `(fourth &rest)` *Defined at lib/base.lisp:301:1*
 - `getmetatable` *Native defined at lib/lua/basic.lisp:25:1*
 - `(inc! x)` *Macro defined at lib/prelude.lisp:124:1*
 - `io/close` *Native defined at lib/lua/io.lisp:1:1*
 - `io/flush` *Native defined at lib/lua/io.lisp:2:1*
 - `io/input` *Native defined at lib/lua/io.lisp:3:1*
 - `io/lines` *Native defined at lib/lua/io.lisp:4:1*
 - `io/open` *Native defined at lib/lua/io.lisp:5:1*
 - `io/output` *Native defined at lib/lua/io.lisp:6:1*
 - `io/popen` *Native defined at lib/lua/io.lisp:7:1*
 - `io/read` *Native defined at lib/lua/io.lisp:8:1*
 - `io/stderr` *Native defined at lib/lua/io.lisp:9:1*
 - `io/stdin` *Native defined at lib/lua/io.lisp:10:1*
 - `io/stdout` *Native defined at lib/lua/io.lisp:11:1*
 - `io/tmpfile` *Native defined at lib/lua/io.lisp:12:1*
 - `io/type` *Native defined at lib/lua/io.lisp:13:1*
 - `io/write` *Native defined at lib/lua/io.lisp:14:1*
 - `len#` *Native defined at lib/lua/basic.lisp:19:1*
 - `math/abs` *Native defined at lib/lua/math.lisp:1:1*
 - `math/acos` *Native defined at lib/lua/math.lisp:2:1*
 - `math/asin` *Native defined at lib/lua/math.lisp:3:1*
 - `math/atan` *Native defined at lib/lua/math.lisp:4:1*
 - `math/atan2` *Native defined at lib/lua/math.lisp:5:1*
 - `math/ceil` *Native defined at lib/lua/math.lisp:6:1*
 - `math/cos` *Native defined at lib/lua/math.lisp:7:1*
 - `math/deg` *Native defined at lib/lua/math.lisp:8:1*
 - `math/exp` *Native defined at lib/lua/math.lisp:9:1*
 - `math/floor` *Native defined at lib/lua/math.lisp:10:1*
 - `math/fmod` *Native defined at lib/lua/math.lisp:11:1*
 - `math/huge` *Native defined at lib/lua/math.lisp:12:1*
 - `math/log` *Native defined at lib/lua/math.lisp:13:1*
 - `math/max` *Native defined at lib/lua/math.lisp:14:1*
 - `math/maxinteger` *Native defined at lib/lua/math.lisp:15:1*
 - `math/min` *Native defined at lib/lua/math.lisp:16:1*
 - `math/mininteger` *Native defined at lib/lua/math.lisp:17:1*
 - `math/modf` *Native defined at lib/lua/math.lisp:18:1*
 - `math/pi` *Native defined at lib/lua/math.lisp:19:1*
 - `math/rad` *Native defined at lib/lua/math.lisp:20:1*
 - `math/random` *Native defined at lib/lua/math.lisp:21:1*
 - `math/randomseed` *Native defined at lib/lua/math.lisp:22:1*
 - `math/sin` *Native defined at lib/lua/math.lisp:23:1*
 - `math/sqrt` *Native defined at lib/lua/math.lisp:24:1*
 - `math/tan` *Native defined at lib/lua/math.lisp:25:1*
 - `math/tointeger` *Native defined at lib/lua/math.lisp:26:1*
 - `math/type` *Native defined at lib/lua/math.lisp:27:1*
 - `math/ult` *Native defined at lib/lua/math.lisp:28:1*
 - `maths/abs` *Native defined at lib/lua/math.lisp:1:1*
 - `maths/acos` *Native defined at lib/lua/math.lisp:2:1*
 - `maths/asin` *Native defined at lib/lua/math.lisp:3:1*
 - `maths/atan` *Native defined at lib/lua/math.lisp:4:1*
 - `maths/atan2` *Native defined at lib/lua/math.lisp:5:1*
 - `maths/ceil` *Native defined at lib/lua/math.lisp:6:1*
 - `maths/cos` *Native defined at lib/lua/math.lisp:7:1*
 - `maths/deg` *Native defined at lib/lua/math.lisp:8:1*
 - `maths/exp` *Native defined at lib/lua/math.lisp:9:1*
 - `maths/floor` *Native defined at lib/lua/math.lisp:10:1*
 - `maths/fmod` *Native defined at lib/lua/math.lisp:11:1*
 - `maths/huge` *Native defined at lib/lua/math.lisp:12:1*
 - `maths/log` *Native defined at lib/lua/math.lisp:13:1*
 - `maths/max` *Native defined at lib/lua/math.lisp:14:1*
 - `maths/maxinteger` *Native defined at lib/lua/math.lisp:15:1*
 - `maths/min` *Native defined at lib/lua/math.lisp:16:1*
 - `maths/mininteger` *Native defined at lib/lua/math.lisp:17:1*
 - `maths/modf` *Native defined at lib/lua/math.lisp:18:1*
 - `maths/pi` *Native defined at lib/lua/math.lisp:19:1*
 - `maths/rad` *Native defined at lib/lua/math.lisp:20:1*
 - `maths/random` *Native defined at lib/lua/math.lisp:21:1*
 - `maths/randomseed` *Native defined at lib/lua/math.lisp:22:1*
 - `maths/sin` *Native defined at lib/lua/math.lisp:23:1*
 - `maths/sqrt` *Native defined at lib/lua/math.lisp:24:1*
 - `maths/tan` *Native defined at lib/lua/math.lisp:25:1*
 - `maths/tointeger` *Native defined at lib/lua/math.lisp:26:1*
 - `maths/type` *Native defined at lib/lua/math.lisp:27:1*
 - `maths/ult` *Native defined at lib/lua/math.lisp:28:1*
 - `next` *Native defined at lib/lua/basic.lisp:29:1*
 - `(ninth &rest)` *Defined at lib/base.lisp:301:1*
 - `pcall` *Native defined at lib/lua/basic.lisp:31:1*
 - `require` *Native defined at lib/lua/basic.lisp:39:1*
 - `(second &rest)` *Defined at lib/base.lisp:301:1*
 - `setmetatable` *Native defined at lib/lua/basic.lisp:41:1*
 - `(seventh &rest)` *Defined at lib/base.lisp:301:1*
 - `(sixth &rest)` *Defined at lib/base.lisp:301:1*
 - `string/byte` *Native defined at lib/lua/string.lisp:1:1*
 - `string/char` *Native defined at lib/lua/string.lisp:2:1*
 - `string/concat` *Native defined at lib/lua/table.lisp:1:1*
 - `string/dump` *Native defined at lib/lua/string.lisp:3:1*
 - `string/find` *Native defined at lib/lua/string.lisp:4:1*
 - `string/format` *Native defined at lib/lua/string.lisp:5:1*
 - `string/gsub` *Native defined at lib/lua/string.lisp:6:1*
 - `string/len` *Native defined at lib/lua/string.lisp:7:1*
 - `string/lower` *Native defined at lib/lua/string.lisp:8:1*
 - `string/match` *Native defined at lib/lua/string.lisp:9:1*
 - `string/rep` *Native defined at lib/lua/string.lisp:10:1*
 - `string/reverse` *Native defined at lib/lua/string.lisp:11:1*
 - `string/sub` *Native defined at lib/lua/string.lisp:12:1*
 - `string/upper` *Native defined at lib/lua/string.lisp:13:1*
 - `(tenth &rest)` *Defined at lib/base.lisp:301:1*
 - `(third &rest)` *Defined at lib/base.lisp:301:1*
 - `tonumber` *Native defined at lib/lua/basic.lisp:42:1*
 - `tostring` *Native defined at lib/lua/basic.lisp:43:1*
 - `unpack` *Native defined at lib/lua/table.lisp:7:1*
 - `write` *Native defined at lib/lua/io.lisp:14:1*
 - `xpcall` *Native defined at lib/lua/basic.lisp:45:1*
