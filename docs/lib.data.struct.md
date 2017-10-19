---
title: data/struct
---
# data/struct
## `(defstruct name &clauses)`
*Macro defined at lib/data/struct.lisp:103:2*

Define a struct called `NAME`.

`NAME` can be either a symbol or a list of three elements, whose
elements name, respectively, the type (returned from `type` and
used in `defmethod`, for instance), the constructor's name, and
the predicate's name. In case `NAME` is a symbol, the constructor
and predicate names are automatically derived from that symbol.

Consider:
```cl
(defstruct thing ...)
(defstruct (other-thing make-something-else is-something-else?) ...)
```

The first struct declaration generates a constructor called
`make-thing` and a predicate called `thing?`, but the second
declaration generates a constructor called `make-something-else`
and a predicate `is-something-else?`.

The `CLAUSES` argument to [`defstruct`](lib.data.struct.md#defstruct-name-clauses) controls the contents of the
generated structure.

The `(fields field ...)` clause defines the fields of the structure
type. Each `field` must be of one of the following forms:
  - `field-name`
  - `(immutable field-name [getter-name])`
  - `(mutable field-name [getter-name setter-name])`
Where a field in square brackets is optional. If no name is
specified for the getter, it will have the name `struct-field`,
while the setter will have the name `set-struct-field!`.

The `(constructor tag fun)` clause will use `fun` as the constructor
for the structure type. `tag` will be a symbol in `fun`'s scope that
builds the structure according to the fields clause.

