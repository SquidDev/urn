---
title: prelude
---
# prelude
## `($ str)`
*Macro defined at lib/string.lisp:122:1*

Perform interpolation (variable substitution) on the string `STR`.

The string is a sequence of arbitrary characters which may contain an
unquote, of the form `~{foo}` or `${foo}`, where foo is a variable
name.

The `~{x}` form will format the value using [`pretty`](lib.type.md#pretty), ensuring it is
readable. `${x}` requires that `x` is a string, simply splicing the
value in directly.

### Example:
```cl
> (let* [(x 1)] ($ "~{x} = 1"))
out = "1 = 1"
```

## `*standard-error*`
*Defined at lib/prelude.lisp:27:1*

The standard error stream.

## `*standard-input*`
*Defined at lib/prelude.lisp:31:1*

The standard input stream.

## `*standard-output*`
*Defined at lib/prelude.lisp:23:1*

The standard output stream.

## `(-> x &funcs)`
*Macro defined at lib/function.lisp:59:1*

Chain a series of method calls together. If the list contains `<>`
then the value is placed there, otherwise the expression is invoked
with the previous entry as an argument.

### Example
```cl
> (-> '(1 2 3)
.   (map succ <>)
.   (map (cut * <> 2) <>))
out = (4 6 8)
```

## `(.<! x &keys value)`
*Macro defined at lib/table.lisp:149:1*

Set the value at `KEYS` in the structure `X` to `VALUE`.

## `(.> x &keys)`
*Macro defined at lib/table.lisp:143:1*

Index the structure `X` with the sequence of accesses given by `KEYS`.

## `(/= a b &rest)`
*Macro defined at lib/comparison.lisp:54:1*

Check whether `A` is not equal to `B`, `B` is not equal to the first element
in `REST`, etc...

This will lazily evaluate each value: if `A` is equal to `B`, then no
subsequent arguments will be evaluated.

### Example:
```cl
> (let [(a 1)
.       (b 2)]
.   (/= a b 1))
out = true
> (with (a 1)
.   (/= a 1))
out = false
```

## `(< a b &rest)`
*Macro defined at lib/comparison.lisp:72:1*

Check whether `A` is smaller than `B`, `B` is smaller than the first element
in `REST`, and so on for all subsequent arguments.

This will lazily evaluate each value: if `A` is greater or equal to `B`,
then no subsequent arguments will be evaluated.

### Example:
```cl
> (with (a 3)
.   (< 1 a 5))
out = true
```

## `(<= a b &rest)`
*Macro defined at lib/comparison.lisp:100:1*

Check whether `A` is smaller or equal to `B`, `B` is smaller or equal to the
first element in `REST`, and so on for all subsequent arguments.

This will lazily evaluate each value: if `A` is larger than `B`,
then no subsequent arguments will be evaluated.

### Example:
```cl
> (with (a 3)
.   (<= 1 a 5))
out = true
```

## `(<=> p q)`
*Macro defined at lib/base.lisp:284:1*

Bidirectional implication. `(<=> a b)` means that `(=> a b)` and
`(=> b a)` both hold.

### Example:
```cl
> (<=> (> 3 1) (< 1 3))
out = true
> (<=> (> 1 3) (< 3 1))
out = true
> (<=> (> 1 3) (< 1 3))
out = false
```

## `(<> &lenses)`
*Defined at lib/lens.lisp:144:1*

Compose, left-associatively, the list of lenses given by `LENSES`.

## `(= a b &rest)`
*Macro defined at lib/comparison.lisp:37:1*

Check whether `A`, `B` and all items in `REST` are equal.

This will lazily evaluate each value: if `A` is not equal to `B`, then no
subsequent arguments will be evaluated.

### Example:
```cl
> (let [(a 1)
.       (b 2)]
.   (= 1 a b))
out = false
> (with (a 1)
.   (= a 1))
out = true
```

## `(=> p q)`
*Macro defined at lib/base.lisp:274:1*

Logical implication. `(=> a b)` is equivalent to `(or (not a) b)`.

### Example:
```cl
> (=> (> 3 1) (< 1 3))
out = true
```

## `(> a b &rest)`
*Macro defined at lib/comparison.lisp:86:1*

Check whether `A` is larger than `B`, `B` is larger than the first element
in `REST`, and so on for all subsequent arguments.

This will lazily evaluate each value: if `A` is smaller or equal to `B`,
then no subsequent arguments will be evaluated.

### Example:
```cl
> (with (a 3)
.   (> 5 a 1))
out = true
```

## `(>= a b &rest)`
*Macro defined at lib/comparison.lisp:114:1*

Check whether `A` is larger or equal to `B`, `B` is larger or equal to the
first element in `REST`, and so on for all subsequent arguments.

This will lazily evaluate each value: if `A` is smaller than `B`,
then no subsequent arguments will be evaluated.

### Example:
```cl
> (with (a 3)
.   (>= 5 a 1))
out = true
```

## `(\\ xs ys)`
*Defined at lib/list.lisp:268:1*

The difference between `XS` and `YS` (non-associative.)

### Example:
```cl
> (\\ '(1 2 3) '(1 3 5 7))
out = (2)
```

## `(^. val lens)`
*Defined at lib/lens.lisp:155:1*

Use `LENS` to focus on a bit of `VAL`.

## `(^= val lens new)`
*Defined at lib/lens.lisp:167:1*

Use `LENS` to replace a bit of `VAL` with `NEW`.

## `(^~ val lens f)`
*Defined at lib/lens.lisp:161:1*

Use `LENS` to apply the function `F` over a bit of `VAL`.

## `(accumulate-with f ac z xs)`
*Defined at lib/list.lisp:616:1*

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
*Defined at lib/lens.lisp:316:1*

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
*Defined at lib/list.lisp:309:1*

Test if all elements of `XS` match the predicate `P`.

### Example:
```cl
> (all symbol? '(foo bar baz))
out = true
> (all number? '(1 2 foo))
out = false
```

## `(and a b &rest)`
*Macro defined at lib/base.lisp:238:1*

Return the logical and of values `A` and `B`, and, if present, the
logical and of all the values in `REST`.

Each argument is lazily evaluated, only being computed if the previous
argument returned a truthy value. This will return the last argument
to be evaluated.

### Example:
```cl
> (and 1 2 3)
out = 3
> (and (> 3 1) (< 3 1))
out = false
```

## `(any p xs)`
*Defined at lib/list.lisp:238:1*

Check for the existence of an element in `XS` that matches the predicate
`P`.

### Example:
```cl
> (any exists? '(nil 1 "foo"))
out = true
```

## `(append xs ys)`
*Defined at lib/list.lisp:553:1*

Concatenate `XS` and `YS`.

### Example:
```cl
> (append '(1 2) '(3 4))
out = (1 2 3 4)
``` 

## `(apply f &xss xs)`
*Defined at lib/base.lisp:402:1*

Apply the function `F` using `XS` as the argument list, with `XSS` as
arguments before `XS` is spliced.

### Example:
```cl
> (apply + '(1 2))
out = 3
> (apply + 1 '(2))
out = 3
```

## `arg`
*Defined at lib/base.lisp:343:1*

The arguments passed to the currently executing program

## `(as-is x)`
*Defined at lib/prelude.lisp:107:1*

Return the value `X` unchanged.

## `(assert-type! arg ty)`
*Macro defined at lib/type.lisp:118:1*

Assert that the argument `ARG` has type `TY`, as reported by the function
[`type`](lib.type.md#type-val).

## `(assoc list key or-val)`
*Defined at lib/table.lisp:9:1*

Return the value given by `KEY` in the association list `LIST`, or, in the
case that it does not exist, the value `OR-VAL`, which can be nil.

### Example:
```cl
> (assoc '(("foo" 1) ("bar" 2)) "foo" "?")
out = 1
> (assoc '(("foo" 1) ("bar" 2)) "baz" "?")
out = "?"
```

## `(assoc->struct list)`
*Defined at lib/table.lisp:81:1*

Convert the association list `LIST` into a structure. Much like
[`assoc`](lib.table.md#assoc-list-key-or-val), in the case there are several values bound to the same key,
the first value is chosen.

### Example:
```cl
> (assoc->struct '(("a" 1)))
out = {"a" 1}
```

## `(assoc? list key)`
*Defined at lib/table.lisp:28:1*

Check that `KEY` is bound in the association list `LIST`.

### Example:
```cl
> (assoc? '(("foo" 1) ("bar" 2)) "foo")
out = true
> (assoc? '(("foo" 1) ("bar" 2)) "baz")
out = false
```

## `(at k)`
*Defined at lib/lens.lisp:229:1*

`A` lens that focuses on the K-th element of a list. [`view`](lib.lens.md#view-l-v) is
equivalent to `get-idx`, and [`over`](lib.lens.md#over-l-f-v) is like `set-idx!`.

### Example:
```cl
> (^. '(1 2 3) (at 2))
out = 2
```

## `(atom? x)`
*Defined at lib/type.lisp:58:1*

Check whether `X` is an atomic object, that is, one of
- `A` boolean
- `A` string
- `A` number
- `A` symbol
- `A` key
- `A` function

## `(between? val min max)`
*Defined at lib/type.lisp:86:1*

Check if the numerical value `X` is between
`MIN` and `MAX`.

## `bool->string`
*Defined at lib/prelude.lisp:61:1*

Convert the boolean `X` into a string.

## `(boolean? x)`
*Defined at lib/type.lisp:42:1*

Check whether `X` is a boolean.

## `(call x key &args)`
*Defined at lib/prelude.lisp:125:1*

Index `X` with `KEY` and invoke the resulting function with `ARGS`.

## `(car x)`
*Defined at lib/list.lisp:33:1*

Return the first element present in the list `X`. This function operates
in constant time.

### Example:
```cl
> (car '(1 2 3))
out = 1
```

## `(case val &pts)`
*Macro defined at lib/match.lisp:397:1*

Match a single value against a series of patterns, evaluating the
first body that matches, much like `cond`.

## `(cdr x)`
*Defined at lib/list.lisp:45:1*

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
*Defined at lib/list.lisp:92:1*

Return a copy of the list `XSS` with the elements `XS` added to its head.

### Example:
```cl
> (cons 1 2 3 '(4 5 6))
out = (1 2 3 4 5 6)
```

## `(const x)`
*Defined at lib/prelude.lisp:111:1*

Return a function which always returns `X`. This is equivalent to the
`K` combinator in `SK` combinator calculus.

### Example
```cl
> (define x (const 1))
> (x 2)
out = 1
> (x "const")
out = 1
```

## `(const-val val)`
*Defined at lib/base.lisp:355:1*

Get the actual value of `VAL`, an argument to a macro.

Due to how macros are implemented, all values are wrapped as tables
in order to preserve positional data about nodes. You will need to
unwrap them in order to use them.

## `(copy-of struct)`
*Defined at lib/table.lisp:218:1*

Create a shallow copy of `STRUCT`.

## `(create-lookup values)`
*Defined at lib/table.lisp:249:1*

Convert `VALUES` into a lookup table, with each value being converted to
a key whose corresponding value is the value's index.

## `(cut &func)`
*Macro defined at lib/function.lisp:16:1*

Partially apply a function `FUNC`, where each `<>` is replaced by an
argument to a function. Values are evaluated every time the resulting
function is called.

### Example
```cl
> (define double (cut * <> 2))
> (double 3)
out = 6
```

## `(cute &func)`
*Macro defined at lib/function.lisp:37:1*

Partially apply a function `FUNC`, where each `<>` is replaced by an
argument to a function. Values are evaluated when this function is
defined.

### Example
```cl
> (define double (cute * <> 2))
> (double 3)
out = 6
```

## `(debug x)`
*Macro defined at lib/type.lisp:365:1*

Print the value `X`, then return it unmodified.

## `(dec! x)`
*Macro defined at lib/prelude.lisp:153:1*

Decrements the symbol `X` by 1.

### Example
```cl
> (with (x 1)
.   (dec! x)
.   x)
out = 0
```

## `(defdefault name ll &body)`
*Macro defined at lib/type.lisp:260:1*

Add a default case to the generic method `NAME` with the arguments `LL` and the
body `BODY`.

`BODY` has in scope a symbol, `myself`, that refers specifically to this
instantiation of the generic method `NAME`. For instance, in

```cl
(defdefault my-pretty-print (x)
  (myself (.. "foo " x)))
```

`myself` refers only to the default case of `my-pretty-print`

## `(defgeneric name ll &attrs)`
*Macro defined at lib/type.lisp:160:1*

Define a generic method called `NAME` with the arguments given in `LL`,
and the attributes given in `ATTRS`. Note that documentation _must_
come after `LL`; The mixed syntax accepted by `define` is not allowed.

### Examples:
```cl
> (defgeneric my-pretty-print (x)
.   "Pretty-print a value.")
out = «method: (my-pretty-print x)»
> (defmethod (my-pretty-print string) (x) x)
out = nil
> (my-pretty-print "foo")
out = "foo"
```

## `(defmacro name args &body)`
*Macro defined at lib/base.lisp:94:1*

Define `NAME` to be the macro given by (lambda `ARGS` @`BODY`), with
optional metadata at the start of `BODY`.

## `(defmethod name ll &body)`
*Macro defined at lib/type.lisp:228:1*

Add a case to the generic method `NAME` with the arguments `LL` and the body
`BODY`. The types of arguments for this specialisation are given in the list
`NAME`, and the argument names are merely used to build the lambda.

`BODY` has in scope a symbol, `myself`, that refers specifically to this
instantiation of the generic method `NAME`. For instance, in

```cl
(defmethod (my-pretty-print string) (x)
  (myself (.. "foo " x)))
```

`myself` refers only to the case of `my-pretty-print` that handles strings.

### Example
```cl
> (defgeneric my-pretty-print (x)
.   "Pretty-print a value.")
out = «method: (my-pretty-print x)»
> (defmethod (my-pretty-print string) (x) x)
out = nil
> (my-pretty-print "foo")
out = "foo"
```

## `(defun name args &body)`
*Macro defined at lib/base.lisp:88:1*

Define `NAME` to be the function given by (lambda `ARGS` @`BODY`), with
optional metadata at the start of `BODY`.

## `(destructuring-bind pt &body)`
*Macro defined at lib/match.lisp:380:1*

Match a single pattern against a single value, then evaluate the `BODY`.

The pattern is given as `(car PT)` and the value as `(cadr PT)`.  If
the pattern does not match, an error is thrown.

## `(do vars &stmts)`
*Macro defined at lib/list.lisp:526:1*

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
*Macro defined at lib/list.lisp:496:1*

Iterate over all given `VARS`, running `STMTS` and collecting the results.

### Example:
```cl
> (dolist [(a '(1 2 3))
.          (b '(1 2 3))]
.   (list a b))
out = ((1 1) (1 2) (1 3) (2 1) (2 2) (2 3) (3 1) (3 2) (3 3))
```

## `(drop xs n)`
*Defined at lib/list.lisp:70:1*

Remove the first `N` elements of the list `XS`.

### Example:
```cl
> (drop '(1 2 3 4 5) 2)
out = (3 4 5)
```

## `(elem? x xs)`
*Defined at lib/list.lisp:330:1*

Test if `X` is present in the list `XS`.

### Example:
```cl
> (elem? 1 '(1 2 3))
out = true
> (elem? 'foo '(1 2 3))
out = false
```

## `else`
*Defined at lib/base.lisp:10:1*

[`else`](lib.base.md#else) is defined as having the value `true`. Use it as the
last case in a `cond` expression to increase readability.

## `(empty-struct? xs)`
*Defined at lib/table.lisp:196:1*

Check that `XS` is the empty struct.

### Example
```cl
> (empty-struct? {})
out = true
> (empty-struct? { :a 1 })
out = false
```

## `(empty? x)`
*Defined at lib/type.lisp:18:1*

Check whether `X` is the empty list or the empty string.

## `eq?`
*Defined at lib/type.lisp:278:1*

Compare values for equality deeply.

## `(eql? x y)`
*Defined at lib/type.lisp:104:1*

`A` version of [`eq?`](lib.type.md#eq-) that compares the types of `X` and `Y` instead of
just the values.

### Example:
```cl
> (eq? 'foo "foo")
out = true
> (eql? 'foo "foo")
out = false
```

## `error!`
*Defined at lib/prelude.lisp:79:1*

Throw an error.

## `(even? x)`
*Defined at lib/prelude.lisp:133:1*

Is `X` an even number?

## `(every x ln)`
*Defined at lib/lens.lisp:332:1*

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
*Defined at lib/list.lisp:227:1*

Return a list with only the elements of `XS` that don't match the
predicate `P`.

### Example:
```cl
> (exclude even? '(1 2 3 4 5 6))
out = (1 3 5)
```

## `(exists? x)`
*Defined at lib/type.lisp:76:1*

Check if `X` exists, i.e. it is not the special value `nil`.
Note that, in Urn, `nil` is not the empty list.

## `(exit! reason code)`
*Defined at lib/prelude.lisp:92:1*

Exit the program with the exit code `CODE`, and optionally, print the
error message `REASON`.

## `(extend ls key val)`
*Defined at lib/table.lisp:57:1*

Extend the association list `LIST`_ by inserting `VAL`, bound to the key
`KEY`, overriding any previous value.

### Example:
```cl
> (extend '(("foo" 1)) "bar" 2)
out = (("bar" 2) ("foo" 1))
```

## `(fail! x)`
*Defined at lib/prelude.lisp:87:1*

Fail with the error message `X`, that is, exit the program immediately,
without unwinding for an error handler.

## `(falsey? x)`
*Defined at lib/type.lisp:71:1*

Check whether `X` is falsey, that is, it is either `false` or does not
exist.

## `(fast-struct &entries)`
*Defined at lib/table.lisp:183:1*

`A` variation of [`struct`](lib.table.md#struct-entries), which will not perform any coercing of the
`KEYS` in entries.

Note, if you know your values at compile time, it is more performant
to use a struct literal.

## `(filter p xs)`
*Defined at lib/list.lisp:216:1*

Return a list with only the elements of `XS` that match the predicate
`P`.

### Example:
```cl
> (filter even? '(1 2 3 4 5 6))
out = (2 4 6)
```

## `(flat-map fn &xss)`
*Defined at lib/list.lisp:186:1*

Map the function `FN` over the lists `XSS`, then flatten the result
lists.

### Example:
```cl
> (flat-map list '(1 2 3) '(4 5 6))
out = (1 4 2 5 3 6)
```

## `(flatten xss)`
*Defined at lib/list.lisp:563:1*

Concatenate all the lists in `XSS`. `XSS` must not contain elements which
are not lists.

### Example:
```cl
> (flatten '((1 2) (3 4)))
out = (1 2 3 4)
```

## `(folding f z l)`
*Defined at lib/lens.lisp:300:1*

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
*Macro defined at lib/base.lisp:188:1*

Iterate `BODY`, with the counter `CTR` bound to `START`, being incremented
by `STEP` every iteration until `CTR` is outside of the range given by
[`START` .. `END`].

### Example:
```cl
> (with (x '())
.   (for i 1 3 1 (push-cdr! x i))
.   x)
out = (1 2 3)
```

## `(for-each var lst &body)`
*Macro defined at lib/list.lisp:480:1*

>**Warning:** for-each is deprecated: Use [`do`](lib.list.md#do-vars-stmts)/[`dolist`](lib.list.md#dolist-vars-stmts) instead

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

## `(for-pairs vars tbl &body)`
*Macro defined at lib/base.lisp:316:1*

Iterate over `TBL`, binding `VARS` for each key value pair in `BODY`.

### Example:
```cl
> (let [(res '())
.       (struct { :foo 123 })]
.   (for-pairs (k v) struct
.     (push-cdr! res (list k v)))
.     res)
out = (("foo" 123))
```

## `(function &arms)`
*Macro defined at lib/match.lisp:454:1*

Create a lambda which matches its arguments against the patterns
defined in `ARMS`.

## `(function? x)`
*Defined at lib/type.lisp:48:1*

Check whether `X` is a function.

## `gensym`
*Defined at lib/base.lisp:172:1*

Create a unique symbol, suitable for using in macros

## `(getter view)`
*Defined at lib/lens.lisp:94:1*

Define a getting lens using `VIEW` as the accessor.

Lenses built with [`getter`](lib.lens.md#getter-view) can be composed (with [`<>`](lib.lens.md#-lenses)) or used
to focus on a value (with [`view`](lib.lens.md#view-l-v)).

## `(getter? lens)`
*Defined at lib/lens.lisp:116:1*

Check that `LENS` has a defined getter, along with being tagged as
a `LENS`. This is essentially a relaxed version of [`lens?`](lib.lens.md#lens-lens) in
regards to the setter check.

## `(handler-case x &body)`
*Macro defined at lib/match.lisp:421:1*

Evaluate the form `X`, and if an error happened, match the series
of `(?pattern (?arg) . ?body)` arms given in `BODY` against the value of
the error, executing the first that succeeeds.

In the case that `X` does not throw an error, the value of that
expression is returned by [`handler-case`](lib.match.md#handler-case-x-body).

### Example:

```cl
> (handler-case
.   (fail! "oh no!")
.   [string? (x)
.    (print! x)])
oh no!
out = nil
```

## `head`
*Defined at lib/lens.lisp:207:1*

`A` lens equivalent to [`car`](lib.list.md#car-x), which [`view`](lib.lens.md#view-l-v)s and applies [`over`](lib.lens.md#over-l-f-v)
the first element of a list.

### Example:
```cl
> (^. '(1 2 3) head)
out = 1
```

## `(id x)`
*Defined at lib/prelude.lisp:103:1*

Return the value `X` unmodified.

## `(if c t b)`
*Macro defined at lib/base.lisp:131:1*

Evaluate `T` if `C` is true, otherwise, evaluate `B`.

### Example
```cl
> (if (> 1 3) "> 1 3" "<= 1 3")
out = "<= 1 3"
```

## `(if-match cs t e)`
*Macro defined at lib/match.lisp:469:1*

Matches a pattern against a value defined in `CS`, evaluating `T` with the
captured variables in scope if the pattern succeeded, otherwise
evaluating `E`.

[`if-match`](lib.match.md#if-match-cs-t-e) is to [`case`](lib.match.md#case-val-pts) what [`if`](lib.base.md#if-c-t-b) is to `cond`.

## `(inc! x)`
*Macro defined at lib/prelude.lisp:141:1*

Increments the symbol `X` by 1.

### Example
```cl
> (with (x 1)
.   (inc! x)
.   x)
out = 2
```

## `(init xs)`
*Defined at lib/list.lisp:378:1*

Return the list `XS` with the last element removed.
This is the dual of `LAST`.

### Example:
```cl
> (init (range :from 1 :to 10))
out = (1 2 3 4 5 6 7 8 9)
```

## `(insert alist key val)`
*Defined at lib/table.lisp:46:1*

Extend the association list `ALIST` by inserting `VAL`, bound to the key
`KEY`.

### Example:
```cl
> (insert '(("foo" 1)) "bar" 2)
out = (("foo" 1) ("bar" 2))
```

## `(insert! alist key val)`
*Defined at lib/table.lisp:68:1*

Extend the association list `ALIST` in place by inserting `VAL`, bound to
the key `KEY`.

### Example:
```cl
> (define x '(("foo" 1)))
> (insert! x "bar" 2)
> x
out = (("foo" 1) ("bar" 2))
```

## `(insert-nth! li idx val)`
*Defined at lib/list.lisp:466:1*

Mutate the list `LI`, inserting `VAL` at `IDX`.

### Example:
```cl
> (define list '(1 2 3))
> (insert-nth! list 2 5)
> list
out = (1 5 2 3)
``` 

## `(invokable? x)`
*Defined at lib/function.lisp:80:1*

Test if the expression `X` makes sense as something that can be applied
to a set of arguments.

### Example
```cl
> (invokable? invokable?)
out = true
> (invokable? nil)
out = false
> (invokable? (setmetatable {} { :__call (lambda (x) (print! "hello")) }))
out = true
```

## `it`
*Defined at lib/lens.lisp:197:1*

The simplest lens, not focusing on any subcomponent. In the case of [`over`](lib.lens.md#over-l-f-v),
if the value being focused on is a list, the function is mapped over every
element of the list.

## `(iter-pairs table func)`
*Defined at lib/table.lisp:214:1*

Iterate over `TABLE` with a function `FUNC` of the form `(lambda (key val) ...)`

## `(key? x)`
*Defined at lib/type.lisp:54:1*

Check whether `X` is a key.

## `(keys st)`
*Defined at lib/table.lisp:232:1*

Return the keys in the structure `ST`.

## `(last xs)`
*Defined at lib/list.lisp:366:1*

Return the last element of the list `XS`.
Counterintutively, this function runs in constant time.

### Example:
```cl
> (last (range :from 1 :to 100))
out = 100
```

## `(lens view over)`
*Defined at lib/lens.lisp:81:1*

Define a lens using `VIEW` and `OVER` as the getter and the replacer
functions, respectively.

Lenses built with [`lens`](lib.lens.md#lens-view-over) can be composed (with [`<>`](lib.lens.md#-lenses)), used
to focus on a value (with [`view`](lib.lens.md#view-l-v)), and replace that value
(with [`set`](lib.lens.md#set-l-n-v) or [`over`](lib.lens.md#over-l-f-v))

## `(lens? lens)`
*Defined at lib/lens.lisp:108:1*

Check that is `LENS` a valid lens, that is, has the proper tag, a
valid getter and a valid setter.

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
.                       (and (not (= 0 n))
.                            (is-even? (pred n)))))]
.     (is-odd? 11))
out = true
```

## `(list &xs)`
*Defined at lib/base.lisp:103:1*

Return the list of variadic arguments given.

### Example:
```cl
> (list 1 2 3)
out = (1 2 3)
```

## `(list? x)`
*Defined at lib/type.lisp:14:1*

Check whether `X` is a list.

## `(loop vs test &body)`
*Macro defined at lib/binders.lisp:190:1*

`A` general iteration helper.

```cl
> (loop [(var0 val0)
.        (var1 val1)
.        ...]
.   [test test-body ...]
.   body ...)
```

Bind all the variables given in `VS`. Each iteration begins by
evaluating `TEST`. If it evaluates to a truthy value, `TEST-BODY`
is evaluated and the final expression in `TEST-BODY` is returned.
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

## `(map fn &xss)`
*Defined at lib/list.lisp:133:1*

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
*Macro defined at lib/match.lisp:411:1*

Test if the value `X` matches the pattern `PT`.

Note that, since this does not bind anything, all metavariables may be
replaced by `_` with no loss of meaning.

## `(maybe-map fn &xss)`
*Defined at lib/list.lisp:157:1*

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

## `(merge &structs)`
*Defined at lib/table.lisp:224:1*

Merge all tables in `STRUCTS` together into a new table.

## `(n x)`
*Defined at lib/lua/basic.lisp:47:1*

Get the length of list X

## `(neq? x y)`
*Defined at lib/type.lisp:99:1*

Compare `X` and `Y` for inequality deeply. `X` and `Y` are `neq?`
if `([[eq?]] x y)` is falsey.

## `(nil? x)`
*Defined at lib/type.lisp:81:1*

Check if `X` does not exist, i.e. it is the special value `nil`.
Note that, in Urn, `nil` is not the empty list.

## `(nkeys st)`
*Defined at lib/table.lisp:208:1*

Return the number of keys in the structure `ST`.

## `(none p xs)`
*Defined at lib/list.lisp:258:1*

Check that no elements in `XS` match the predicate `P`.

### Example:
```cl
> (none nil? '("foo" "bar" "baz"))
out = true
```

## `(not expr)`
*Defined at lib/base.lisp:158:1*

Compute the logical negation of the expression `EXPR`.

### Example:
```cl
> (with (a 1)
.   (not (= a 1)))
out = false
```

## `(nth xs idx)`
*Defined at lib/list.lisp:390:1*

Get the `IDX` th element in the list `XS`. The first element is 1.
This function runs in constant time.

### Example:
```cl
> (nth (range :from 1 :to 100) 10)
out = 10
```

## `(nths xss idx)`
*Defined at lib/list.lisp:403:1*

Get the IDX-th element in all the lists given at `XSS`. The first
element is1.

### Example:
```cl
> (nths '((1 2 3) (4 5 6) (7 8 9)) 2)
out = (2 5 8)
```

## `(nub xs)`
*Defined at lib/list.lisp:280:1*

Remove duplicate elements from `XS`. This runs in linear time.

### Example:
```cl
> (nub '(1 1 2 2 3 3))
out = (1 2 3)
```

## `number->string`
*Defined at lib/prelude.lisp:57:1*

Convert the number `X` into a string.

## `(number? x)`
*Defined at lib/type.lisp:32:1*

Check whether `X` is a number.

## `(odd? x)`
*Defined at lib/prelude.lisp:137:1*

Is `X` an odd number?

## `(on k)`
*Defined at lib/lens.lisp:250:1*

`A` lens that focuses on the element of a structure that is at the key
`K`.

### Example:
```cl
> (^. { :foo "bar" } (on :foo))
out = "bar"
```

## `(on! k)`
*Defined at lib/lens.lisp:268:1*

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
*Macro defined at lib/base.lisp:256:1*

Return the logical or of values `A` and `B`, and, if present, the
logical or of all the values in `REST`.

Each argument is lazily evaluated, only being computed if the previous
argument returned a falsey value. This will return the last argument
to be evaluated.

### Example:
```cl
> (or 1 2 3)
out = 1
> (or (> 3 1) (< 3 1))
out = true
```

## `(over l f v)`
*Defined at lib/lens.lisp:175:1*

Flipped synonym for [`^~`](lib.lens.md#-val-lens-f)

## `(overl! lens f val)`
*Macro defined at lib/lens.lisp:189:1*

Mutate `VAL` by applying to a bit of it the function `F`, using `LENS`.

## `(partition p xs)`
*Defined at lib/list.lisp:197:1*

Split `XS` based on the predicate `P`. Values for which the predicate
returns true are returned in the first list, whereas values which
don't pass the predicate are returned in the second list.

### Example:
```cl
> (list (partition even? '(1 2 3 4 5 6)))
out = ((2 4 6) (1 3 5))
```

## `(pop-last! xs)`
*Defined at lib/list.lisp:434:1*

Mutate the list `XS`, removing and returning its last element.

### Example:
```cl
> (define list '(1 2 3))
> (pop-last! list)
out = 3
> list
out = (1 2)
``` 

## `(pred x)`
*Defined at lib/prelude.lisp:39:1*

Return the predecessor of the number `X`.

## `pretty`
*Defined at lib/type.lisp:335:1*

Pretty-print a value.

## `print!`
*Defined at lib/prelude.lisp:83:1*

Print to standard output.

## `(printf fmt &args)`
*Defined at lib/prelude.lisp:175:1*

Print the formatted string `FMT` using `ARGS`.

### Example
```cl
> (printf "%.3d" 1)
001
out = nil
```

## `(prod xs)`
*Defined at lib/list.lisp:645:1*

Return the product of all elements in `XS`.

### Example:
```cl
> (prod '(1 2 3 4))
out = 24
```

## `(progn &body)`
*Macro defined at lib/base.lisp:118:1*

Group a series of expressions together.

### Example
```cl
> (progn
.   (print! 123)
.   456)
123
out = 456
```

## `(prune xs)`
*Defined at lib/list.lisp:343:1*

Remove values matching the predicates [`empty?`](lib.type.md#empty-x) or [`nil?`](lib.type.md#nil-x) from
the list `XS`.

### Example:
```cl
> (prune (list '() nil 1 nil '() 2))
out = (1 2)
```

## `(push-cdr! xs val)`
*Defined at lib/list.lisp:417:1*

Mutate the list `XS`, adding `VAL` to its end.

### Example:
```cl
> (define list '(1 2 3))
> (push-cdr! list 4)
out = (1 2 3 4)
> list
out = (1 2 3 4)
```

## `(quasiquote val)`
*Macro defined at lib/base.lisp:388:1*

Quote `VAL`, but replacing all `unquote` and `unquote-splice` with their actual value.

Be warned, by using this you lose all macro hygiene. Variables may not be bound to their
expected values.

### Example:
```cl
> (with (x 1)
.   ~(+ ,x 2))
out = (+ 1 2)
```

## `(range &args)`
*Defined at lib/list.lisp:574:1*

Build a list from :`FROM` to :`TO`, optionally passing by :`BY`.

### Example:
```cl
> (range :from 1 :to 10)
out = (1 2 3 4 5 6 7 8 9 10)
> (range :from 1 :to 10 :by 3)
out = (1 3 5 7 9)
```

## `(reduce f z xs)`
*Defined at lib/list.lisp:102:1*

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
*Defined at lib/list.lisp:451:1*

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
*Defined at lib/list.lisp:603:1*

Reverse the list `XS`, using the accumulator `ACC`.

### Example:
```cl
> (reverse (range :from 1 :to 10))
out = (10 9 8 7 6 5 4 3 2 1)
```

## `(self x key &args)`
*Defined at lib/prelude.lisp:129:1*

Index `X` with `KEY` and invoke the resulting function with `X` and `ARGS`.

## `(set l n v)`
*Defined at lib/lens.lisp:179:1*

Flipped synonym for [`^=`](lib.lens.md#-val-lens-new)

## `(setl! lens new val)`
*Macro defined at lib/lens.lisp:183:1*

Mutate `VAL` by replacing a bit of it with `NEW`, using `LENS`.

## `(setter over)`
*Defined at lib/lens.lisp:101:1*

Define a setting lens using `VIEW` as the accessor.

Lenses built with [`setter`](lib.lens.md#setter-over) can be composed (with [`<>`](lib.lens.md#-lenses)) or used
to replace a value (with [`over`](lib.lens.md#over-l-f-v) or [`set`](lib.lens.md#set-l-n-v)).

## `(setter? lens)`
*Defined at lib/lens.lisp:123:1*

Check that `LENS` has a defined setter, along with being tagged as
a `LENS`. This is essentially a relaxed version of [`lens?`](lib.lens.md#lens-lens) in
regards to the getter check.

## `(slot? symb)`
*Defined at lib/function.lisp:11:1*

Test whether `SYMB` is a slot. For this, it must be a symbol, whose
contents are `<>`.

## `(snoc xss &xs)`
*Defined at lib/list.lisp:80:1*

Return a copy of the list `XS` with the element `XS` added to its end.
This function runs in linear time over the two input lists: That is,
it runs in `O`(n+k) time proportional both to `(n XSS)` and `(n XS)`.

### Example:
```cl
> (snoc '(1 2 3) 4 5 6)
out = (1 2 3 4 5 6)
``` 

## `(sort xs f)`
*Defined at lib/list.lisp:704:1*

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
*Defined at lib/list.lisp:722:1*

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
*Defined at lib/list.lisp:685:1*

Splits a list into sub-lists by the separator `Y`.

### Example:
```cl
> (split '(1 2 3 4) 3)
out = ((1 2) (4))
```

## `(sprintf fmt &args)`
*Defined at lib/prelude.lisp:165:1*

Format the format string `FMT` using `ARGS`.

### Example
```cl
> (sprintf "%.3d" 1)
out = "001"
```

## `string->number`
*Defined at lib/prelude.lisp:43:1*

Convert the string `X` into a number. Returns `nil` if it could not be
parsed.

Optionally takes a `BASE` which the number is in (such as 16 for
hexadecimal).

### Example:
```cl
> (string->number "23")
out = 23
```

## `(string->symbol x)`
*Defined at lib/prelude.lisp:71:1*

Convert the string `X` to a symbol.

## `(string/$ str)`
*Macro defined at lib/string.lisp:122:1*

Perform interpolation (variable substitution) on the string `STR`.

The string is a sequence of arbitrary characters which may contain an
unquote, of the form `~{foo}` or `${foo}`, where foo is a variable
name.

The `~{x}` form will format the value using [`pretty`](lib.type.md#pretty), ensuring it is
readable. `${x}` requires that `x` is a string, simply splicing the
value in directly.

### Example:
```cl
> (let* [(x 1)] ($ "~{x} = 1"))
out = "1 = 1"
```

## `(string/char-at xs x)`
*Defined at lib/string.lisp:10:1*

Index the string `XS`, returning the character at position `X`.

### Example:
```cl
> (string/char-at "foo" 1)
out = "f"
```

## `(string/ends-with? str suffix)`
*Defined at lib/string.lisp:104:1*

Determine whether `STR` ends with `SUFFIX`.

### Example:
```cl
> (string/ends-with? "Hello, world" "world")
out = true
```

## `string/quoted`
*Defined at lib/string.lisp:75:1*

Quote the string `STR` so it is suitable for printing.

### Example:
```cl
> (string/quoted "\n")
out = "\"\\n\""
```

## `(string/split text pattern limit)`
*Defined at lib/string.lisp:20:1*

Split the string given by `TEXT` in at most `LIMIT` components, which are
delineated by the Lua pattern `PATTERN`.

It is worth noting that an empty pattern (`""`) will split the
string into individual characters.

### Example
```
> (split "foo-bar-baz" "-")
out = ("foo" "bar" "baz")
> (split "foo-bar-baz" "-" 1)
out = ("foo" "bar-baz")
```

## `(string/starts-with? str prefix)`
*Defined at lib/string.lisp:94:1*

Determine whether `STR` starts with `PREFIX`.

### Example:
```cl
> (string/starts-with? "Hello, world" "Hello")
out = true
```

## `(string/trim str)`
*Defined at lib/string.lisp:64:1*

Remove whitespace from both sides of `STR`.

### Example:
```cl
> (string/trim "  foo\n\t")
out = "foo"
```

## `(string? x)`
*Defined at lib/type.lisp:26:1*

Check whether `X` is a string.

## `(struct &entries)`
*Defined at lib/table.lisp:157:1*

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
> (struct :foo "bar")
out = {"foo" "bar"}
```

## `(struct->assoc tbl)`
*Defined at lib/table.lisp:102:1*

Convert the structure `TBL` into an association list. Note that
`(eq? x (struct->assoc (assoc->struct x)))` is not guaranteed,
because duplicate elements will be removed.

### Example
```cl
> (struct->assoc { :a 1 })
out = (("a" 1))
```

## `(struct->list tbl)`
*Defined at lib/table.lisp:117:1*

Converts a structure `TBL` that is a list by having its keys be indices
to a regular list.

### Example
```cl
> (struct->list { 1 "foo" 2 "bar" })
out = ("foo" "bar")
```

## `(struct->list! tbl)`
*Defined at lib/table.lisp:129:1*

Converts a structure `TBL` that is a list by having its keys be indices
to a regular list. This differs from `struct->list` in that it mutates
its argument.
### Example
```cl
> (struct->list! { 1 "foo" 2 "bar" })
out = ("foo" "bar")
```

## `(succ x)`
*Defined at lib/prelude.lisp:35:1*

Return the successor of the number `X`.

## `(sum xs)`
*Defined at lib/list.lisp:635:1*

Return the sum of all elements in `XS`.

### Example:
```cl
> (sum '(1 2 3 4))
out = 10
```

## `(sym.. &xs)`
*Defined at lib/prelude.lisp:75:1*

Concatenate all the symbols in `XS`.

## `(symbol->string x)`
*Defined at lib/prelude.lisp:65:1*

Convert the symbol `X` to a string.

## `(symbol? x)`
*Defined at lib/type.lisp:38:1*

Check whether `X` is a symbol.

## `(table? x)`
*Defined at lib/type.lisp:9:1*

Check whether the value `X` is a table. This might be a structure,
a list, an associative list, a quoted key, or a quoted symbol.

## `tail`
*Defined at lib/lens.lisp:218:1*

`A` lens equivalent to [`cdr`](lib.list.md#cdr-x), which [`view`](lib.lens.md#view-l-v)s and applies [`over`](lib.lens.md#over-l-f-v)
to all but the first element of a list.

### Example:
```cl
> (^. '(1 2 3) tail)
out = (2 3)
```

## `(take xs n)`
*Defined at lib/list.lisp:60:1*

Take the first `N` elements of the list `XS`.

### Example:
```cl
> (take '(1 2 3 4 5) 2)
out = (1 2)
```

## `(take-while p xs idx)`
*Defined at lib/list.lisp:655:1*

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
*Defined at lib/list.lisp:355:1*

>**Warning:** traverse is deprecated: Use [`map`](lib.list.md#map-fn-xss) instead.

An alias for [`map`](lib.list.md#map-fn-xss) with the arguments `XS` and `F` flipped.

### Example:
```cl
> (traverse '(1 2 3) succ)
out = (2 3 4)
```

## `(traversing l)`
*Defined at lib/lens.lisp:287:1*

`A` lens which maps the lens `L` over every element of a given list.

Example:
```cl
> (view (traversing (at 3)) '((1 2 3) (4 5 6)))
out = (3 6)
```

## `(type val)`
*Defined at lib/type.lisp:91:1*

Return the type of `VAL`.

## `(union xs ys)`
*Defined at lib/list.lisp:299:1*

Set-like union of `XS` and `YS`.

### Example:
```cl
> (union '(1 2 3 4) '(1 2 3 4 5))
out = (1 2 3 4 5)
```

## `(unless c &body)`
*Macro defined at lib/base.lisp:145:1*

Evaluate `BODY` if `C` is false, otherwise, evaluate `nil`.

## `(update-struct st &keys)`
*Defined at lib/table.lisp:244:1*

Create a new structure based of `ST`, setting the values given by the
pairs in `KEYS`.

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

## `(values st)`
*Defined at lib/table.lisp:238:1*

Return the values in the structure `ST`.

## `(values-list &xs)`
*Macro defined at lib/base.lisp:416:1*

Return multiple values, one per element in `XS`.

### Example:
```cl
> (print! (values-list 1 2 3))
1   2   3
out = nil
```

## `(view l v)`
*Defined at lib/lens.lisp:171:1*

Flipped synonym for [`^.`](lib.lens.md#-val-lens)

## `(when c &body)`
*Macro defined at lib/base.lisp:141:1*

Evaluate `BODY` when `C` is true, otherwise, evaluate `nil`.

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

## `(while check &body)`
*Macro defined at lib/base.lisp:215:1*

Iterate `BODY` while the expression `CHECK` evaluates to `true`.

### Example:
```cl
> (with (x 4)
.   (while (> x 0) (dec! x))
.   x)
out = 0
```

## `(with var &body)`
*Macro defined at lib/binders.lisp:51:1*

Bind the single variable `VAR`, then evaluate `BODY`.

## Undocumented symbols
 - `(! expr)` *Defined at lib/base.lisp:169:1*
 - `%` *Native defined at lib/lua/basic.lisp:12:1*
 - `*` *Native defined at lib/lua/basic.lisp:10:1*
 - `+` *Native defined at lib/lua/basic.lisp:8:1*
 - `-` *Native defined at lib/lua/basic.lisp:9:1*
 - `..` *Native defined at lib/lua/basic.lisp:14:1*
 - `/` *Native defined at lib/lua/basic.lisp:11:1*
 - `^` *Native defined at lib/lua/basic.lisp:13:1*
 - `(caaaar xs)` *Defined at lib/list.lisp:737:1*
 - `(caaaars xs)` *Defined at lib/list.lisp:737:1*
 - `(caaadr xs)` *Defined at lib/list.lisp:737:1*
 - `(caaadrs xs)` *Defined at lib/list.lisp:737:1*
 - `(caaar xs)` *Defined at lib/list.lisp:737:1*
 - `(caaars xs)` *Defined at lib/list.lisp:737:1*
 - `(caadar xs)` *Defined at lib/list.lisp:737:1*
 - `(caadars xs)` *Defined at lib/list.lisp:737:1*
 - `(caaddr xs)` *Defined at lib/list.lisp:737:1*
 - `(caaddrs xs)` *Defined at lib/list.lisp:737:1*
 - `(caadr xs)` *Defined at lib/list.lisp:737:1*
 - `(caadrs xs)` *Defined at lib/list.lisp:737:1*
 - `(caar xs)` *Defined at lib/list.lisp:737:1*
 - `(caars xs)` *Defined at lib/list.lisp:737:1*
 - `(cadaar xs)` *Defined at lib/list.lisp:737:1*
 - `(cadaars xs)` *Defined at lib/list.lisp:737:1*
 - `(cadadr xs)` *Defined at lib/list.lisp:737:1*
 - `(cadadrs xs)` *Defined at lib/list.lisp:737:1*
 - `(cadar xs)` *Defined at lib/list.lisp:737:1*
 - `(cadars xs)` *Defined at lib/list.lisp:737:1*
 - `(caddar xs)` *Defined at lib/list.lisp:737:1*
 - `(caddars xs)` *Defined at lib/list.lisp:737:1*
 - `(cadddr xs)` *Defined at lib/list.lisp:737:1*
 - `(cadddrs xs)` *Defined at lib/list.lisp:737:1*
 - `(caddr xs)` *Defined at lib/list.lisp:737:1*
 - `(caddrs xs)` *Defined at lib/list.lisp:737:1*
 - `(cadr xs)` *Defined at lib/list.lisp:737:1*
 - `(cadrs xs)` *Defined at lib/list.lisp:737:1*
 - `(cars xs)` *Defined at lib/list.lisp:737:1*
 - `(cdaaar xs)` *Defined at lib/list.lisp:737:1*
 - `(cdaaars xs)` *Defined at lib/list.lisp:737:1*
 - `(cdaadr xs)` *Defined at lib/list.lisp:737:1*
 - `(cdaadrs xs)` *Defined at lib/list.lisp:737:1*
 - `(cdaar xs)` *Defined at lib/list.lisp:737:1*
 - `(cdaars xs)` *Defined at lib/list.lisp:737:1*
 - `(cdadar xs)` *Defined at lib/list.lisp:737:1*
 - `(cdadars xs)` *Defined at lib/list.lisp:737:1*
 - `(cdaddr xs)` *Defined at lib/list.lisp:737:1*
 - `(cdaddrs xs)` *Defined at lib/list.lisp:737:1*
 - `(cdadr xs)` *Defined at lib/list.lisp:737:1*
 - `(cdadrs xs)` *Defined at lib/list.lisp:737:1*
 - `(cdar xs)` *Defined at lib/list.lisp:737:1*
 - `(cdars xs)` *Defined at lib/list.lisp:737:1*
 - `(cddaar xs)` *Defined at lib/list.lisp:737:1*
 - `(cddaars xs)` *Defined at lib/list.lisp:737:1*
 - `(cddadr xs)` *Defined at lib/list.lisp:737:1*
 - `(cddadrs xs)` *Defined at lib/list.lisp:737:1*
 - `(cddar xs)` *Defined at lib/list.lisp:737:1*
 - `(cddars xs)` *Defined at lib/list.lisp:737:1*
 - `(cdddar xs)` *Defined at lib/list.lisp:737:1*
 - `(cdddars xs)` *Defined at lib/list.lisp:737:1*
 - `(cddddr xs)` *Defined at lib/list.lisp:737:1*
 - `(cddddrs xs)` *Defined at lib/list.lisp:737:1*
 - `(cdddr xs)` *Defined at lib/list.lisp:737:1*
 - `(cdddrs xs)` *Defined at lib/list.lisp:737:1*
 - `(cddr xs)` *Defined at lib/list.lisp:737:1*
 - `(cddrs xs)` *Defined at lib/list.lisp:737:1*
 - `(cdrs xs)` *Defined at lib/list.lisp:737:1*
 - `concat` *Native defined at lib/lua/table.lisp:1:1*
 - `(fifth &rest)` *Defined at lib/base.lisp:434:1*
 - `(first &rest)` *Defined at lib/base.lisp:434:1*
 - `format` *Native defined at lib/lua/string.lisp:5:1*
 - `(fourth &rest)` *Defined at lib/base.lisp:434:1*
 - `getmetatable` *Native defined at lib/lua/basic.lisp:25:1*
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
 - `(lambda ll &body)` *Macro defined at lib/base.lisp:23:1*
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
 - `(ninth &rest)` *Defined at lib/base.lisp:434:1*
 - `pcall` *Native defined at lib/lua/basic.lisp:31:1*
 - `require` *Native defined at lib/lua/basic.lisp:39:1*
 - `(second &rest)` *Defined at lib/base.lisp:434:1*
 - `setmetatable` *Native defined at lib/lua/basic.lisp:41:1*
 - `(seventh &rest)` *Defined at lib/base.lisp:434:1*
 - `(sixth &rest)` *Defined at lib/base.lisp:434:1*
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
 - `(tenth &rest)` *Defined at lib/base.lisp:434:1*
 - `(third &rest)` *Defined at lib/base.lisp:434:1*
 - `tonumber` *Native defined at lib/lua/basic.lisp:42:1*
 - `tostring` *Native defined at lib/lua/basic.lisp:43:1*
 - `unpack` *Native defined at lib/lua/table.lisp:7:1*
 - `write` *Native defined at lib/lua/io.lisp:14:1*
 - `xpcall` *Native defined at lib/lua/basic.lisp:45:1*
