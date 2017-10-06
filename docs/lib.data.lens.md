---
title: data/lens
---
# data/lens
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
> (define list-example (range :from 1 :to 10))
out = '(1 2 3 4 5 6 7 8 9 10)
> (define struct-example (struct :foo "bar" :baz "quux"))
out = (struct "foo" "bar" "baz" "quux")
```

Lists have two lenses, [`head`](lib.data.lens.md#head) and [`tail`](lib.data.lens.md#tail), which correspond to
[`car`](lib.core.list.md#car) and [`cdr`](lib.core.list.md#cdr), respectively. To use a lens to _zoom into_ a
part of a data structure, we can use the combinator [`view`](lib.data.lens.md#view). If we
were to give [`view`](lib.data.lens.md#view) a type, it would be `Lens a b -> a -> b`. It uses
the getter defined by the lens to access a bit of a data structure.

```cl
> (view head list-example)
out = 1
> (view tail list-example)
out = '(2 3 4 5 6 7 8 9 10)
```

Note that lenses may also be applied directly to values, which equates
to using [`view`](lib.data.lens.md#view). That is, `(lens x)` is `(view lens x)`.

Of course, if lenses were only used to [`view`](lib.data.lens.md#view) values, they would not
be very useful; What is the point of using `(view head ...)` over just
`(car ...)`? Their real use comes from the _other_ function that makes
up a lens, `over`. [`over`](lib.data.lens.md#over) applies a function to a specific bit of a
data structure. For example, the `over` implementation for [`head`](lib.data.lens.md#head)
returns a new list with the first element replaced.

```cl
> (over head succ list-example)
out = '(2 2 3 4 5 6 7 8 9 10)
```

Notice that [`over`](lib.data.lens.md#over) doesn't just return the new head, but the a copy
of the existing list with the new head in place.

Again, lenses don't seem very useful until you learn the other property
that they all have in common: _composition_. Lenses, you see, are like
functions: You can take two and [`<>`](lib.data.lens.md#-) them together, producing a lens
that [`view`](lib.data.lens.md#view)s and modifies (with [`over`](lib.data.lens.md#over)) a inner piece of the data
structure.

For example, by composing `head` and `tail`, you may focus on the second
element of a list using `(<> head tail)`, or the tail of the first
element of a list (given that element itself is a list itself) using
`(<> tail head)`.

```
> (over (<> head tail) succ list-example)
out = '(1 3 3 4 5 6 7 8 9 10)
```

## `<>`
*Defined at lib/data/lens.lisp:138:2*

Compose, left-associatively, the list of lenses given by `LENSES`.

## `^.`
*Defined at lib/data/lens.lisp:149:2*

Use `LENS` to focus on a bit of `VAL`.

## `^=`
*Defined at lib/data/lens.lisp:161:2*

Use `LENS` to replace a bit of `VAL` with `NEW`.

## `^~`
*Defined at lib/data/lens.lisp:155:2*

Use `LENS` to apply the function `F` over a bit of `VAL`.

## `accumulating`
*Defined at lib/data/lens.lisp:310:2*

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

## `at`
*Defined at lib/data/lens.lisp:223:2*

`A` lens that focuses on the K-th element of a list. [`view`](lib.data.lens.md#view) is
equivalent to [`.>`](lib.core.table.md#-), and [`over`](lib.data.lens.md#over) is like [`.<!`](lib.core.table.md#-).

### Example:
```cl
> (^. '(1 2 3) (at 2))
out = 2
```

## `every`
*Defined at lib/data/lens.lisp:326:2*

`A` higher-order lens that focuses `LN` on every element of a list that
satisfies the perdicate `X`. If `X` is a regular value, it is compared
for equality (according to [`eql?`](lib.core.type.md#eql-)) with every list element. If it
is a function, it is treated as the predicate.


Example:
```cl
> (view (every even? it) '(1 2 3 4 5 6))
out = (2 4 6)
> (view (every 'x it) '(1 x 2 x 3 x 4 x))
out = (x x x x)
```

## `folding`
*Defined at lib/data/lens.lisp:294:2*

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

## `getter`
*Defined at lib/data/lens.lisp:88:2*

Define a getting lens using `VIEW` as the accessor.

Lenses built with [`getter`](lib.data.lens.md#getter) can be composed (with [`<>`](lib.data.lens.md#-)) or used
to focus on a value (with [`view`](lib.data.lens.md#view)).

## `getter?`
*Defined at lib/data/lens.lisp:110:2*

Check that `LENS` has a defined getter, along with being tagged as
a `LENS`. This is essentially a relaxed version of [`lens?`](lib.data.lens.md#lens-) in
regards to the setter check.

## `head`
*Defined at lib/data/lens.lisp:201:1*

`A` lens equivalent to [`car`](lib.core.list.md#car), which [`view`](lib.data.lens.md#view)s and applies [`over`](lib.data.lens.md#over)
the first element of a list.

### Example:
```cl
> (^. '(1 2 3) head)
out = 1
```

## `it`
*Defined at lib/data/lens.lisp:191:1*

The simplest lens, not focusing on any subcomponent. In the case of [`over`](lib.data.lens.md#over),
if the value being focused on is a list, the function is mapped over every
element of the list.

## `lens`
*Defined at lib/data/lens.lisp:75:2*

Define a lens using `VIEW` and `OVER` as the getter and the replacer
functions, respectively.

Lenses built with [`lens`](lib.data.lens.md#lens) can be composed (with [`<>`](lib.data.lens.md#-)), used
to focus on a value (with [`view`](lib.data.lens.md#view)), and replace that value
(with [`set`](lib.data.lens.md#set) or [`over`](lib.data.lens.md#over))

## `lens?`
*Defined at lib/data/lens.lisp:102:2*

Check that is `LENS` a valid lens, that is, has the proper tag, a
valid getter and a valid setter.

## `on`
*Defined at lib/data/lens.lisp:244:2*

`A` lens that focuses on the element of a structure that is at the key
`K`.

### Example:
```cl
> (^. { :foo "bar" } (on :foo))
out = "bar"
```

## `on!`
*Defined at lib/data/lens.lisp:262:2*

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

## `over`
*Defined at lib/data/lens.lisp:169:2*

Flipped synonym for [`^~`](lib.data.lens.md#-)

## `overl!`
*Macro defined at lib/data/lens.lisp:183:2*

Mutate `VAL` by applying to a bit of it the function `F`, using `LENS`.

## `set`
*Defined at lib/data/lens.lisp:173:2*

Flipped synonym for [`^=`](lib.data.lens.md#-)

## `setl!`
*Macro defined at lib/data/lens.lisp:177:2*

Mutate `VAL` by replacing a bit of it with `NEW`, using `LENS`.

## `setter`
*Defined at lib/data/lens.lisp:95:2*

Define a setting lens using `VIEW` as the accessor.

Lenses built with [`setter`](lib.data.lens.md#setter) can be composed (with [`<>`](lib.data.lens.md#-)) or used
to replace a value (with [`over`](lib.data.lens.md#over) or [`set`](lib.data.lens.md#set)).

## `setter?`
*Defined at lib/data/lens.lisp:117:2*

Check that `LENS` has a defined setter, along with being tagged as
a `LENS`. This is essentially a relaxed version of [`lens?`](lib.data.lens.md#lens-) in
regards to the getter check.

## `tail`
*Defined at lib/data/lens.lisp:212:1*

`A` lens equivalent to [`cdr`](lib.core.list.md#cdr), which [`view`](lib.data.lens.md#view)s and applies [`over`](lib.data.lens.md#over)
to all but the first element of a list.

### Example:
```cl
> (^. '(1 2 3) tail)
out = (2 3)
```

## `traversing`
*Defined at lib/data/lens.lisp:281:2*

`A` lens which maps the lens `L` over every element of a given list.

Example:
```cl
> (view (traversing (at 3)) '((1 2 3) (4 5 6)))
out = (3 6)
```

## `view`
*Defined at lib/data/lens.lisp:165:2*

Flipped synonym for [`^.`](lib.data.lens.md#-)

