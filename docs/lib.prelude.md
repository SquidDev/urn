---
title: prelude
---
# prelude
## `(! expr)`
*Defined at lib/base.lisp:80:1*

Negate the expression `EXPR`.

## `(-> x &funcs)`
*Macro defined at lib/function.lisp:59:1*

Chain a series of method calls together. If the list contains `<>`
then the value is placed there, otherwise the expression is invoked
with the previous entry as an argument.

### Example
```
> (-> '(1 2 3)
    succ
    (* <> 2))
(4 6 8)
```

## `(.<! x &keys value)`
*Macro defined at lib/table.lisp:121:1*

Set the value at `KEYS` in the structure `X` to `VALUE`.

## `(.> x &keys)`
*Macro defined at lib/table.lisp:85:1*

Index the structure `X` with the sequence of accesses given by `KEYS`.

## `(<=> p q)`
*Macro defined at lib/base.lisp:150:1*

Bidirectional implication. `(<=> a b)` means that `(=> a b)` and
`(=> b a)` both hold.

## `(=> p q)`
*Macro defined at lib/base.lisp:146:1*

Logical implication. `(=> a b)` is equivalent to `(or (! a) b)`.

## `(\\ xs ys)`
*Defined at lib/list.lisp:258:1*

The difference between `XS` and `YS` (non-associative.)

### Example:
```
> (\ '(1 2 3) '(1 3 5 7))
out = (2)
```

## `(accumulate-with f ac z xs)`
*Defined at lib/list.lisp:558:1*

`A` composition of [`foldl`](lib.list.md#foldl-f-z-xs) and [`map`](lib.list.md#map-fn-xss).

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
*Defined at lib/list.lisp:299:1*

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
*Defined at lib/list.lisp:228:1*

Check for the existence of an element in `XS` that matches the predicate
`P`.

### Example:
```cl
> (any exists? '(nil 1 "foo"))
true
```

## `(append xs ys)`
*Defined at lib/list.lisp:511:1*

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
*Defined at lib/prelude.lisp:42:1*

Convert the boolean `X` into a string.

## `(boolean? x)`
*Defined at lib/type.lisp:41:1*

Check whether `X` is a boolean.

## `(call x key &args)`
*Defined at lib/prelude.lisp:89:1*

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
*Macro defined at lib/match.lisp:268:1*

Match a single value against a series of patterns, evaluating the
first body that matches, much like `cond`.

## `(cdr x)`
*Defined at lib/list.lisp:67:1*

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
*Defined at lib/list.lisp:114:1*

Return a copy of the list `XSS` with the elements `XS` added to its head.

### Example:
```cl
> (cons 1 2 3 '(4 5 6))
out = (1 2 3 4 5 6)
```

## `(const x)`
*Defined at lib/prelude.lisp:84:1*

Return a function which always returns `X`. This is equivalent to the
`K` combinator in `SK` combinator calculus.

## `(const-val val)`
*Defined at lib/base.lisp:234:1*

Get the actual value of `VAL`, an argument to a macro.

Due to how macros are implemented, all values are wrapped as tables
in order to preserve positional data about nodes. You will need to
unwrap them in order to use them.

## `(create-lookup values)`
*Defined at lib/table.lisp:206:1*

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

## `(dec! x)`
*Macro defined at lib/setf.lisp:76:1*

Decrement the value selector `X` in place.

## `(defmacro name args &body)`
*Macro defined at lib/base.lisp:38:1*

Define `NAME` to be the macro given by (lambda `ARGS` @`BODY`), with
optional metadata at the start of `BODY`.

## `(defun name args &body)`
*Macro defined at lib/base.lisp:32:1*

Define `NAME` to be the function given by (lambda `ARGS` @`BODY`), with
optional metadata at the start of `BODY`.

## `(destructuring-bind pt &body)`
*Macro defined at lib/match.lisp:251:1*

Match a single pattern against a single value, then evaluate the `BODY`.

The pattern is given as `(car PT)` and the value as `(cadr PT)`.  If
the pattern does not match, an error is thrown.

## `(drop xs n)`
*Defined at lib/list.lisp:92:1*

Remove the first `N` elements of the list `XS`.

### Example:
```cl
> (drop '(1 2 3 4 5) 2)
out = (3 4 5)
```

## `(elem? x xs)`
*Defined at lib/list.lisp:320:1*

Test if `X` is present in the list `XS`.

### Example:
```cl
> (elem? 1 '(1 2 3))
true
> (elem? 'foo '(1 2 3))
false
```

## `(empty-struct? xs)`
*Defined at lib/table.lisp:167:1*

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
*Defined at lib/prelude.lisp:60:1*

Throw an error.

## `(even? x)`
*Defined at lib/prelude.lisp:97:1*

Is `X` an even number?

## `(exists? x)`
*Defined at lib/type.lisp:73:1*

Check if `X` exists, i.e. it is not the special value `nil`.
Note that, in Urn, `nil` is not the empty list.

## `(exit! reason code)`
*Defined at lib/prelude.lisp:73:1*

Exit the program with the exit code `CODE`, and optionally, print the
error message `REASON`.

## `(extend ls key val)`
*Defined at lib/table.lisp:36:1*

Extend the association list `LIST`_ by inserting `VAL`, bound to the key
`KEY`, overriding any previous value.

## `(fail! x)`
*Defined at lib/prelude.lisp:68:1*

Fail with the error message `X`, that is, exit the program immediately,
without unwinding for an error handler.

## `(falsey? x)`
*Defined at lib/type.lisp:68:1*

Check whether `X` is falsey, that is, it is either `false` or does not
exist.

## `(fast-struct &entries)`
*Defined at lib/table.lisp:154:1*

`A` variation of [`struct`](lib.table.md#struct-entries), which will not perform any coercing of the
`KEYS` in entries.

Note, if you know your values at compile time, it is more performant
to use a struct literal.

## `(filter p xs)`
*Defined at lib/list.lisp:212:1*

Return the list of elements of `XS` which match the predicate `P`.

### Example:
```cl
> (filter even? '(1 2 3 4 5 6))
'(2 4 6)
```

## `(flat-map fn &xss)`
*Defined at lib/list.lisp:201:1*

Map the function `FN` over the lists `XSS`, then flatten the result
lists.

### Example:
```cl
> (flat-map list '(1 2 3) '(4 5 6))
out = 1 4 2 5 3 6
```

## `(flatten xss)`
*Defined at lib/list.lisp:521:1*

Concatenate all the lists in `XSS`. `XSS` must not contain elements which
are not lists.

### Example:
```cl
> (flatten '((1 2) (3 4)))
out = (1 2 3 4)
```

## `(foldl f z xs)`
*Defined at lib/list.lisp:124:1*

Accumulate the list `XS` using the binary function `F` and the zero
element `Z`.  This function is also called `reduce` by some authors. One
can visualise `(foldl f z xs)` as replacing the [`cons`](lib.list.md#cons-xs-xss) operator in
building lists with `F`, and the empty list with `Z`.

Consider:
- `'(1 2 3)` is equivalent to `(cons 1 (cons 2 (cons 3 '())))`
- `(foldl + 0 '(1 2 3))` is equivalent to `(+ 1 (+ 2 (+ 3 0)))`.

### Example:
```cl
> (foldl append '() '((1 2) (3 4)))
out = (1 2 3 4)
; equivalent to (append '(1 2) (append '(3 4) '()))
```

## `(for ctr start end step &body)`
*Macro defined at lib/base.lisp:100:1*

Iterate `BODY`, with the counter `CTR` bound to `START`, being incremented
by `STEP` every iteration until `CTR` is outside of the range given by
[`START` .. `END`]

## `(for-each var lst &body)`
*Macro defined at lib/list.lisp:493:1*

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

## `(function? x)`
*Defined at lib/type.lisp:47:1*

Check whether `X` is a function.

## `gensym`
*Defined at lib/base.lisp:84:1*

Create a unique symbol, suitable for using in macros

## `(handler-case x &body)`
*Macro defined at lib/match.lisp:292:1*

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

## `(id x)`
*Defined at lib/prelude.lisp:80:1*

Return the value `X` unmodified.

## `(if c t b)`
*Macro defined at lib/base.lisp:59:1*

Evaluate `T` if `C` is true, otherwise, evaluate `B`.

## `(inc! x)`
*Macro defined at lib/setf.lisp:72:1*

Increment the value selector `X` in place.

## `(init xs)`
*Defined at lib/list.lisp:368:1*

Return the list `XS` with the last element removed.
This is the dual of `LAST`.

### Example:
```cl
> (init (range 1 10))
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
*Defined at lib/list.lisp:478:1*

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

## `(iter-pairs table func)`
*Defined at lib/table.lisp:177:1*

Iterate over `TABLE` with a function `FUNC` of the form `(lambda (key val) ...)`

## `(key? x)`
*Defined at lib/type.lisp:51:1*

Check whether `X` is a key.

## `(keys st)`
*Defined at lib/table.lisp:189:1*

Return the keys in the structure `ST`.

## `(last xs)`
*Defined at lib/list.lisp:356:1*

Return the last element of the list `XS`.
Counterintutively, this function runs in constant time.

### Example:
```cl
> (last (range 1 100))
out = 100
```

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
*Defined at lib/list.lisp:147:1*

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
*Macro defined at lib/match.lisp:282:1*

Test if the value `X` matches the pattern `PT`.

Note that, since this does not bind anything, all metavariables may be
replaced by `_` with no loss of meaning.

## `(maybe-map fn &xss)`
*Defined at lib/list.lisp:171:1*

Iterate over all successive cars of `XSS`, producing a single list by
applying `FN` to all of them, while discarding any `nil`s.

### Example:
```cl
> (maybe-map (lambda (x)
               (if (even? x)
                 nil
                 (succ x)))
             (range 1 10))
out = (2 4 6 8 10)
```

## `(merge &structs)`
*Defined at lib/table.lisp:181:1*

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
*Defined at lib/table.lisp:171:1*

Return the number of keys in the structure `ST`.

## `(none p xs)`
*Defined at lib/list.lisp:248:1*

Check that no elements in `XS` match the predicate `P`.

### Example:
```cl
> (none nil? '("foo" "bar" "baz"))
true
```

## `(nth xs idx)`
*Defined at lib/list.lisp:380:1*

Get the `IDX` th element in the list `XS`. The first element is 1.
This function runs in constant time.

### Example:
```cl
> (nth (range 1 100) 10)
out = 10
```

## `(nths xss idx)`
*Defined at lib/list.lisp:415:1*

Get the `IDX`-th element in all the lists given at `XSS`. The first
element is1.

### Example:
```cl
> (nths '((1 2 3) (4 5 6) (7 8 9)) 2)
out = (2 5 8)
```

## `(nub xs)`
*Defined at lib/list.lisp:270:1*

Remove duplicate elements from `XS`. This runs in linear time.

### Example:
```
> (nub '(1 1 2 2 3 3))
out = (1 2 3)
```

## `number->string`
*Defined at lib/prelude.lisp:38:1*

Convert the number `X` into a string.

## `(number? x)`
*Defined at lib/type.lisp:31:1*

Check whether `X` is a number.

## `(odd? x)`
*Defined at lib/prelude.lisp:101:1*

Is `X` an odd number?

## `(or a b &rest)`
*Macro defined at lib/base.lisp:140:1*

Return the logical or of values `A` and `B`, and, if present, the
logical or of all the values in `REST`.

## `(over! obj fun)`
*Macro defined at lib/setf.lisp:41:1*

Apply function `FUN` over the location selector `OBJ`, storing the result
in the same place.

If `OBJ` is a symbol, then the symbol will just apply `FUN`, and set the
symbol again.

Otherwise, `OBJ` must be a list. This should be in the form of the
getter you'd normally use to access that value. For instance, to set
the first element of the list, you'd use `(over! (car xs) succ)`.

This function given in the getter will have `/over!` appended to it,
and looked up in the scope the getter is defined in (or the current
scope if not found). This definition will then be used to generate the
accessor and setter. Implementations should cache accesses, meaning
that lists and structures are not indexed multiple times.

### Example
```cl
(over! foo (cut + <> 2)) ;; Add 2 to foo
(over! (.> foo :bar) (out + <> 2)) ;; Add 2 to the value of index
                                   ;; bar in structure foo.
```

## `(pop-last! xs)`
*Defined at lib/list.lisp:446:1*

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
*Defined at lib/prelude.lisp:26:1*

Return the predecessor of the number `X`.

## `(pretty value)`
*Defined at lib/base.lisp:193:1*

Format `VALUE` as a valid Lisp expression which can be parsed.

## `print!`
*Defined at lib/prelude.lisp:64:1*

Print to standard output.

## `(prod xs)`
*Defined at lib/list.lisp:587:1*

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
*Defined at lib/list.lisp:333:1*

Remove values matching the predicates [`empty?`](lib.type.md#empty-x) or [`nil?`](lib.type.md#nil-x) from
the list `XS`.

### Example:
```cl
> (prune '(() nil 1 nil () 2))
out = (1 2)
```

## `(push-cdr! xs val)`
*Defined at lib/list.lisp:429:1*

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

## `(range start end)`
*Defined at lib/list.lisp:532:1*

Build a list from `START` to `END`.

### Example:
```cl
> (range 1 10)
out = (1 2 3 4 5 6 7 8 9 10)
```

## `(remove-nth! li idx)`
*Defined at lib/list.lisp:463:1*

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
*Defined at lib/list.lisp:545:1*

Reverse the list `XS`, using the accumulator `ACC`.

### Example:
```cl
> (reverse (range 1 10))
out = (10 9 8 7 6 5 4 3 2 1)
```

## `(self x key &args)`
*Defined at lib/prelude.lisp:93:1*

Index `X` with `KEY` and invoke the resulting function with `X` and `ARGS`

## `(setf! obj val)`
*Macro defined at lib/setf.lisp:12:1*

Set the location selector `OBJ` to `VAL`.

If `OBJ` is a symbol, then the symbol will just have its variable set,
identical to using `set!`.

Otherwise, `OBJ` must be a list. This should be in the form of the
getter you'd normally use to access that value. For instance, to set
the first element of the list, you'd use `(setf! (car xs) 42)`.

This function given in the getter will have `/setf!` appended to it,
and looked up in the scope the getter is defined in (or the current
scope if not found). This definition will then be used to generate the
setter.

### Example
```cl
(setf! foo 123) ;; Set the symbol foo to 123
(setf! (.> foo :bar) 123) ;; Set the value of index bar in structure
                          ;; foo to 123.
```

## `(slot? symb)`
*Defined at lib/function.lisp:11:1*

Test whether `SYMB` is a slot. For this, it must be a symbol, whose
contents are `<>`.

## `(snoc xss &xs)`
*Defined at lib/list.lisp:102:1*

Return a copy of the list `XS` with the element `XS` added to its end.
This function runs in linear time over the two input lists: That is,
it runs in `O`(n+k) time proportional both to `(n XSS)` and `(n XS)`.

### Example:
```cl
> (snoc '(1 2 3) 4 5 6)
out = (1 2 3 4 5 6)
``` 

## `(split xs y)`
*Defined at lib/list.lisp:627:1*

Splits a list into sub-lists by the separator `Y`.

### Example:
```cl
> (split '(1 2 3 4) 3)
out = ((1 2) (4))
```

## `string->number`
*Defined at lib/prelude.lisp:30:1*

Convert the string `X` into a number. Returns `nil` if it could not be
parsed.

Optionally takes a `BASE` which the number is in (such as 16 for
hexadecimal).

## `(string->symbol x)`
*Defined at lib/prelude.lisp:52:1*

Convert the string `X` to a symbol.

## `(string/char-at xs x)`
*Defined at lib/string.lisp:8:1*

Index the string `XS`, returning the character at position `X`.

## `(string/ends-with? str suffix)`
*Defined at lib/string.lisp:78:1*

Determine whether `STR` ends with `SUFFIX`.

## `string/quoted`
*Defined at lib/string.lisp:61:1*

Quote the string `STR` so it is suitable for printing.

## `(string/split text pattern limit)`
*Defined at lib/string.lisp:12:1*

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
*Defined at lib/string.lisp:74:1*

Determine whether `STR` starts with `PREFIX`.

## `(string/trim str)`
*Defined at lib/string.lisp:56:1*

Remove whitespace from both sides of `STR`.

## `(string? x)`
*Defined at lib/type.lisp:25:1*

Check whether `X` is a string.

## `(struct &entries)`
*Defined at lib/table.lisp:129:1*

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
*Defined at lib/prelude.lisp:22:1*

Return the successor of the number `X`.

## `(sum xs)`
*Defined at lib/list.lisp:577:1*

Return the sum of all elements in `XS`.

### Example:
```cl
> (sum '(1 2 3 4))
out = 10
```

## `(sym.. &xs)`
*Defined at lib/prelude.lisp:56:1*

Concatenate all the symbols in `XS`.

## `(symbol->string x)`
*Defined at lib/prelude.lisp:46:1*

Convert the symbol `X` to a string.

## `(symbol? x)`
*Defined at lib/type.lisp:37:1*

Check whether `X` is a symbol.

## `(table? x)`
*Defined at lib/type.lisp:8:1*

Check whether the value `X` is a table. This might be a structure,
a list, an associative list, a quoted key, or a quoted symbol.

## `(take xs n)`
*Defined at lib/list.lisp:82:1*

Take the first `N` elements of the list `XS`.

### Example:
```cl
> (take '(1 2 3 4 5) 2)
out = (1 2)
```

## `(take-while p xs idx)`
*Defined at lib/list.lisp:597:1*

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
*Defined at lib/list.lisp:345:1*

> **Warning:** traverse is deprecated: Use map instead.

An alias for [`map`](lib.list.md#map-fn-xss) with the arguments `XS` and `F` flipped.

### Example:
```cl
> (traverse '(1 2 3) succ)
out = (2 3 4)
```

## `(type val)`
*Defined at lib/type.lisp:88:1*

Return the type of `VAL`.

## `(union xs ys)`
*Defined at lib/list.lisp:289:1*

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
*Defined at lib/table.lisp:201:1*

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
*Defined at lib/table.lisp:195:1*

Return the values in the structure `ST`.

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
 - `/=` *Native defined at lib/lua/basic.lisp:2:1*
 - `<` *Native defined at lib/lua/basic.lisp:3:1*
 - `<=` *Native defined at lib/lua/basic.lisp:4:1*
 - `=` *Native defined at lib/lua/basic.lisp:1:1*
 - `>` *Native defined at lib/lua/basic.lisp:5:1*
 - `>=` *Native defined at lib/lua/basic.lisp:6:1*
 - `^` *Native defined at lib/lua/basic.lisp:13:1*
 - `(caaaar xs)` *Defined at lib/list.lisp:647:1*
 - `(caaaars xs)` *Defined at lib/list.lisp:647:1*
 - `(caaadr xs)` *Defined at lib/list.lisp:647:1*
 - `(caaadrs xs)` *Defined at lib/list.lisp:647:1*
 - `(caaar xs)` *Defined at lib/list.lisp:647:1*
 - `(caaars xs)` *Defined at lib/list.lisp:647:1*
 - `(caadar xs)` *Defined at lib/list.lisp:647:1*
 - `(caadars xs)` *Defined at lib/list.lisp:647:1*
 - `(caaddr xs)` *Defined at lib/list.lisp:647:1*
 - `(caaddrs xs)` *Defined at lib/list.lisp:647:1*
 - `(caadr xs)` *Defined at lib/list.lisp:647:1*
 - `(caadrs xs)` *Defined at lib/list.lisp:647:1*
 - `(caar xs)` *Defined at lib/list.lisp:647:1*
 - `(caars xs)` *Defined at lib/list.lisp:647:1*
 - `(cadaar xs)` *Defined at lib/list.lisp:647:1*
 - `(cadaars xs)` *Defined at lib/list.lisp:647:1*
 - `(cadadr xs)` *Defined at lib/list.lisp:647:1*
 - `(cadadrs xs)` *Defined at lib/list.lisp:647:1*
 - `(cadar xs)` *Defined at lib/list.lisp:647:1*
 - `(cadars xs)` *Defined at lib/list.lisp:647:1*
 - `(caddar xs)` *Defined at lib/list.lisp:647:1*
 - `(caddars xs)` *Defined at lib/list.lisp:647:1*
 - `(cadddr xs)` *Defined at lib/list.lisp:647:1*
 - `(cadddrs xs)` *Defined at lib/list.lisp:647:1*
 - `(caddr xs)` *Defined at lib/list.lisp:647:1*
 - `(caddrs xs)` *Defined at lib/list.lisp:647:1*
 - `(cadr xs)` *Defined at lib/list.lisp:647:1*
 - `(cadrs xs)` *Defined at lib/list.lisp:647:1*
 - `(cars xs)` *Defined at lib/list.lisp:647:1*
 - `(cdaaar xs)` *Defined at lib/list.lisp:647:1*
 - `(cdaaars xs)` *Defined at lib/list.lisp:647:1*
 - `(cdaadr xs)` *Defined at lib/list.lisp:647:1*
 - `(cdaadrs xs)` *Defined at lib/list.lisp:647:1*
 - `(cdaar xs)` *Defined at lib/list.lisp:647:1*
 - `(cdaars xs)` *Defined at lib/list.lisp:647:1*
 - `(cdadar xs)` *Defined at lib/list.lisp:647:1*
 - `(cdadars xs)` *Defined at lib/list.lisp:647:1*
 - `(cdaddr xs)` *Defined at lib/list.lisp:647:1*
 - `(cdaddrs xs)` *Defined at lib/list.lisp:647:1*
 - `(cdadr xs)` *Defined at lib/list.lisp:647:1*
 - `(cdadrs xs)` *Defined at lib/list.lisp:647:1*
 - `(cdar xs)` *Defined at lib/list.lisp:647:1*
 - `(cdars xs)` *Defined at lib/list.lisp:647:1*
 - `(cddaar xs)` *Defined at lib/list.lisp:647:1*
 - `(cddaars xs)` *Defined at lib/list.lisp:647:1*
 - `(cddadr xs)` *Defined at lib/list.lisp:647:1*
 - `(cddadrs xs)` *Defined at lib/list.lisp:647:1*
 - `(cddar xs)` *Defined at lib/list.lisp:647:1*
 - `(cddars xs)` *Defined at lib/list.lisp:647:1*
 - `(cdddar xs)` *Defined at lib/list.lisp:647:1*
 - `(cdddars xs)` *Defined at lib/list.lisp:647:1*
 - `(cddddr xs)` *Defined at lib/list.lisp:647:1*
 - `(cddddrs xs)` *Defined at lib/list.lisp:647:1*
 - `(cdddr xs)` *Defined at lib/list.lisp:647:1*
 - `(cdddrs xs)` *Defined at lib/list.lisp:647:1*
 - `(cddr xs)` *Defined at lib/list.lisp:647:1*
 - `(cddrs xs)` *Defined at lib/list.lisp:647:1*
 - `(cdrs xs)` *Defined at lib/list.lisp:647:1*
 - `concat` *Native defined at lib/lua/table.lisp:1:1*
 - `format` *Native defined at lib/lua/string.lisp:5:1*
 - `(function &arms)` *Macro defined at lib/match.lisp:321:1*
 - `get-idx` *Native defined at lib/lua/basic.lisp:34:1*
 - `getmetatable` *Native defined at lib/lua/basic.lisp:25:1*
 - `(if-match cs t e)` *Macro defined at lib/match.lisp:333:1*
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
 - `pcall` *Native defined at lib/lua/basic.lisp:31:1*
 - `require` *Native defined at lib/lua/basic.lisp:39:1*
 - `set-idx!` *Native defined at lib/lua/basic.lisp:36:1*
 - `setmetatable` *Native defined at lib/lua/basic.lisp:41:1*
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
 - `tonumber` *Native defined at lib/lua/basic.lisp:42:1*
 - `tostring` *Native defined at lib/lua/basic.lisp:43:1*
 - `unpack` *Native defined at lib/lua/table.lisp:7:1*
 - `write` *Native defined at lib/lua/io.lisp:14:1*
 - `xpcall` *Native defined at lib/lua/basic.lisp:45:1*
