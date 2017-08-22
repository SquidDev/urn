---
title: compiler/nodes
---
# compiler/nodes
This library provides a series of methods for interacting with the
internal representation of nodes.

## `builtin?`
*Native defined at lib/compiler/nodes.lisp:38:1*

Determine whether the specified `NODE` is the given `BUILTIN`.

### Example
```cl
> (builtin? (symbol->var `lambda) :lambda)
out = true
```

## `constant?`
*Native defined at lib/compiler/nodes.lisp:47:1*

Determine whether the specified `NODE` is a constant.

## `node->val`
*Native defined at lib/compiler/nodes.lisp:50:1*

Gets the constant value of `NODE`.

## `symbol->var`
*Native defined at lib/compiler/nodes.lisp:28:1*

Extract the variable from the given `SYMBOL`.

This will work with quasi-quoted symbols, and those from resolved
ASTs. You should not use this on macro arguments as it will not
return anything useful.

## `traverse-node`
*Native defined at lib/compiler/nodes.lisp:16:1*

Traverse `NODE` with `VISITOR`.

`VISITOR` should be a function which accepts the current node and the
visitor. It should return the replacement node, or the current node
if no changes should be made.

## `traverse-nodes`
*Native defined at lib/compiler/nodes.lisp:23:1*

Traverse a list of `NODES`, starting at `IDX`, using the specified `VISITOR`.

See [`traverse-node`](lib.compiler.nodes.md#traverse-node) for more information about the `VISITOR`.

## `val->node`
*Native defined at lib/compiler/nodes.lisp:53:1*

Gets the node representation of the constant `VALUE`.

## `var->symbol`
*Native defined at lib/compiler/nodes.lisp:35:1*

Create a new symbol referencing the given `VARIABLE`.

## `visit-node`
*Native defined at lib/compiler/nodes.lisp:4:1*

Visit `NODE` with `VISITOR`.

`VISITOR` should be a function which accepts the current node and the
visitor. This is called before traversing the child nodes. You can
return false to not visit them.

## `visit-nodes`
*Native defined at lib/compiler/nodes.lisp:11:1*

Visit a list of `NODES`, starting at `IDX`, using the specified `VISITOR`.

See [`visit-node`](lib.compiler.nodes.md#visit-node) for more information about the `VISITOR`.

