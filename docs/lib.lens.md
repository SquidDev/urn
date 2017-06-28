---
title: lens
---
# lens
Lenses are a purely functional solution to the issue of accessing and
setting fields in deeply nested data structures without special
language support. Indeed, most of the symbols exported by this module
are either lenses (represented as tables for reflection and
introspection reasons) or functions that operate on lenses.

`A` lens is defined as two basic operators:

- `A` function that returns a piece of a data structure given some data
  structure (a _getter_, called `view`)
- `A` function that given a function and some data structure, replaces
  a bit of that data structure with the result of applying that
  function (a _replacer_, called `over`).

We will be using, as a running example, two data structures: the list
and the struct.

```cl
> (define list-example (range 1 10))
out = '(1 2 3 4 5 6 7 8 9 10)
> (define struct-example (struct :foo "bar" :baz "quux"))
out = (struct "foo" "bar" "baz" "quux")
```

Lists have two lenses, [`head`](lib.lens.md#head) and [`tail`](lib.lens.md#tail), which correspond to
[`car`](lib.list.md#car-x) and [`cdr`](lib.list.md#cdr-x), respectively. To use a lens to _zoom into_ a
part of a data structure, we can use the combinator [`view`](lib.lens.md#view-l-v). If we
were to give [`view`](lib.lens.md#view-l-v) a type, it would be `Lens a b -> a -> b`. It uses
the getter defined by the lens to access a bit of a data structure.

```cl
> (view head list-example)
out = 1
> (view tail list-example)
out = '(2 3 4 5 6 7 8 9 10)
```

Note that lenses may also be applied directly to values, which equates
to using [`view`](lib.lens.md#view-l-v). That is, `(lens x)` is `(view lens x)`.

Of course, if lenses were only used to [`view`](lib.lens.md#view-l-v) values, they would not
be very useful; What is the point of using `(view head ...)` over just
`(car ...)`? Their real use comes from the _other_ function that makes
up a lens, `over`. [`over`](lib.lens.md#over-l-f-v) applies a function to a specific bit of a
data structure. For example, the `over` implementation for [`head`](lib.lens.md#head)
returns a new list with the first element replaced.

```cl
> (over head succ list-example)
out = '(2 2 3 4 5 6 7 8 9 10)
```

Notice that [`over`](lib.lens.md#over-l-f-v) doesn't just return the new head, but the a copy
of the existing list with the new head in place.

Again, lenses don't seem very useful until you learn the other property
that they all have in common: _composition_. Lenses, you see, are like
functions: You can take two and [`<>`](lib.lens.md#-lenses) them together, producing a lens
that [`view`](lib.lens.md#view-l-v)s and modifies (with [`over`](lib.lens.md#over-l-f-v)) a inner piece of the data
structure.

For example, by composing `head` and `tail`, you may focus on the second
element of a list using `(<> head tail)`, or the tail of the first
element of a list (given that element itself is a list itself) using
`(<> tail head)`.

```
> (over (<> head tail) succ list-example)
out = '(1 3 3 4 5 6 7 8 9 10)
```

## `(<> &lenses)`
*Defined at lib/lens.lisp:148:1*

Compose, left-associatively, the list of lenses given by `LENSES`.

## `(^. val lens)`
*Defined at lib/lens.lisp:159:1*

Use `LENS` to focus on a bit of `VAL`.

## `(^= val lens new)`
*Defined at lib/lens.lisp:171:1*

Use `LENS` to replace a bit of `VAL` with `NEW`.

## `(^~ val lens f)`
*Defined at lib/lens.lisp:165:1*

Use `LENS` to apply the function `F` over a bit of `VAL`.

## `(accumulating f z l)`
*Defined at lib/lens.lisp:318:1*

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

## `(at k)`
*Defined at lib/lens.lisp:233:1*

`A` lens that focuses on the `K`-th element of a list. [`view`](lib.lens.md#view-l-v) is
equivalent to `get-idx`, and [`over`](lib.lens.md#over-l-f-v) is like `set-idx!`.

### Example:
```cl
> (^. '(1 2 3) (at 2))
out = 2
```

## `(every x ln)`
*Defined at lib/lens.lisp:334:1*

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

## `(folding f z l)`
*Defined at lib/lens.lisp:302:1*

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

## `head`
*Defined at lib/lens.lisp:211:1*

`A` lens equivalent to [`car`](lib.list.md#car-x), which [`view`](lib.lens.md#view-l-v)s and applies [`over`](lib.lens.md#over-l-f-v)
the first element of a list.

### Example:
```cl
> (^. '(1 2 3) head)
out = 1
```

## `it`
*Defined at lib/lens.lisp:201:1*

The simplest lens, not focusing on any subcomponent. In the case of [`over`](lib.lens.md#over-l-f-v),
if the value being focused on is a list, the function is mapped over every
element of the list.

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

## `(on k)`
*Defined at lib/lens.lisp:252:1*

`A` lens that focuses on the element of a structure that is at the key
`K`.

### Example:
```cl
> (^. { :foo "bar" } (on :foo))
out = "bar"
```

## `(on! k)`
*Defined at lib/lens.lisp:270:1*

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

## `(over l f v)`
*Defined at lib/lens.lisp:179:1*

Flipped synonym for [`^~`](lib.lens.md#-val-lens-f)

## `(overl! lens f val)`
*Macro defined at lib/lens.lisp:193:1*

Mutate `VAL` by applying to a bit of it the function `F`, using `LENS`.

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

## `tail`
*Defined at lib/lens.lisp:222:1*

`A` lens equivalent to [`cdr`](lib.list.md#cdr-x), which [`view`](lib.lens.md#view-l-v)s and applies [`over`](lib.lens.md#over-l-f-v)
to all but the first element of a list.

### Example:
```cl
> (^. '(1 2 3) tail)
out = (2 3)
```

## `(traversing l)`
*Defined at lib/lens.lisp:289:1*

`A` lens which maps the lens `L` over every element of a given list.

Example:
```cl
> (view (traverse (at 3)) '((1 2 3) (4 5 6)))
out = (3 6)
```

## `(view l v)`
*Defined at lib/lens.lisp:175:1*

Flipped synonym for [`^.`](lib.lens.md#-val-lens)

