---
title: compiler/backend
---
# compiler/backend
The backend system is split into two sections:

 - Node categorisation: here we attempt to determine an representation of a
   specific node for which we can generate more efficient flags.
 - Code generation: here we actually emit code for a specific backend.


## `add-categoriser!`
*Native defined at lib/compiler/backend.lisp:14:1*

Register a custom `CATEGORISER`. Optionally specify a single backend to register for.

The `CATEGORISER` should accept a node and a flag marking whether the current
expression is a statement or not.

If it can handle this node, you should return the result of [`cat`](lib.compiler.backend.md#cat), with
optional flags specified, otherwise you should return nil. Note, [`cat`](lib.compiler.backend.md#cat) can
specify a series of optional flags:

 - `:stmt`: Whether this is a statement or not.

If you can successfully handle this node, then you must also handle the
visiting of its children. You should avoid visiting children unless you can
handle them. Visiting is done using [`categorise-node`](lib.compiler.backend.md#categorise-node).

## `add-emitter!`
*Native defined at lib/compiler/backend.lisp:56:1*

Register an `EMITTER` for the specified `CATEGORY`.

This accepts a function with the current compiler state, the target node, the
target node category and "return preamble". You are responsable for
emitting child nodes with [`emit-block`](lib.compiler.backend.md#emit-block) and [`emit-node`](lib.compiler.backend.md#emit-node).

Note, the "return preamble" represents the place to store the result of
this node. This is one of three things:

 - `nil`: Represents an expression context.
 - The empty string: Represents a block context for which this value is discarded.
 - `A` non-empty string: represents a place where this value is stored.

## `cat`
*Native defined at lib/compiler/backend.lisp:30:1*

Create a `CATEGORY` data set, using `ARGS` as additional parameters to
[`struct`](lib.table.md#struct-entries).

## `categorise-node`
*Native defined at lib/compiler/backend.lisp:8:1*

Categorise the given `NODE`, specifying whether it is a `STATEMENT` or not.

## `categorise-nodes`
*Native defined at lib/compiler/backend.lisp:11:1*

Categorise the given `NODES`, starting from `START`, specifying whether it is a `STATEMENT` or not.

## `emit-block`
*Native defined at lib/compiler/backend.lisp:70:1*

Using the specified compiler `STATE`, emit the given `NODES`, starting at
`IDX`. The last expression will be stored in `RET`.

## `emit-node`
*Native defined at lib/compiler/backend.lisp:74:1*

Using the specified compiler `STATE`, emit the given `NODE`, storing its value in `RET`.

## `writer/append!`
*Native defined at lib/compiler/backend.lisp:34:1*

Append a string to the specified `WRITER`.

## `writer/begin-block!`
*Native defined at lib/compiler/backend.lisp:47:1*

Append a line with the given `TEXT` to this `WRITER`, then indent.

## `writer/end-block!`
*Native defined at lib/compiler/backend.lisp:53:1*

End an indented statement with the given `TEXT` in `WRITER`

## `writer/indent!`
*Native defined at lib/compiler/backend.lisp:41:1*

Add an indentation level to this `WRITER`.

## `writer/line!`
*Native defined at lib/compiler/backend.lisp:37:1*

Append a line to the specified `WRITER`. If no string is specified then it will
just move onto the next line.

## `writer/next-block!`
*Native defined at lib/compiler/backend.lisp:50:1*

End one indented statement and begin another with the given `TEXT` in `WRITER`.

## `writer/unindent!`
*Native defined at lib/compiler/backend.lisp:44:1*

Remove an indentation level from this `WRITER`.

