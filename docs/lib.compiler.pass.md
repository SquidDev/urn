---
title: compiler/pass
---
# compiler/pass
The pass system provides a way of reading and modifying resolved trees.

Passes are split into two categories: optimisations and warnings. The
former should attempt to simplify code, making it more
performant. Warnings attempt to find potential bugs or stylistic issues
in your code.

Each pass is defined and registered with [`defpass`](lib.compiler.pass.md#defpass-name-args-body).

### State
Every pass receives a state object. This contains various bits of
information about the current compiler. Some important fields include:

 - `:meta`: Contains information about native definitions. This is just
   a mapping of variable's full names to the information given in a
   `.meta.*` file.

 - `:libs`: `A` list of all loaded libraries. Each library is a struct
    containing the library's nodes (`:out`), documentation (`:docs`),
    display name (`:name`) and path (`:path`).

### Usage analysis
Sometimes you will need to get the definitions or usages of a
variable. Firstly you'll need to include `"usage"` in the category
list in [`defpass`](lib.compiler.pass.md#defpass-name-args-body). You can then access information about the variable
by using [`var-usage`](lib.compiler.pass.md#var-usage).

## `add-pass!`
*Native defined at lib/compiler/pass.lisp:71:1*

Register a `PASS` created with [`defpass`](lib.compiler.pass.md#defpass-name-args-body).

## `(changed!)`
*Macro defined at lib/compiler/pass.lisp:74:1*

Mark this pass as having a side effect.

## `(defpass name args &body)`
*Macro defined at lib/compiler/pass.lisp:32:1*

Define a pass with the given `NAME` and `BODY` taking the specified `ARGS`.

`BODY` can contain key-value pairs (like [`struct`](lib.table.md#struct-entries)) which will be set
as options for this pass.

Inside the `BODY` you can call [`changed!`](lib.compiler.pass.md#changed-) to mark this pass as
modifying something.

## `var-usage`
*Native defined at lib/compiler/pass.lisp:78:1*

Get usage information about the specified `VAR`. This returns a struct
containing:

 - `:defs`: `A` list of all definitions. Each definition is a struct
   containing its type (`:tag`), the defining node `(:node`) and
   corresponding value (`:value`). Node that not all definitions have
   a value.

 - `:usages`: `A` list of most usages. This does not include usages
   from nodes which are considered "dead".

