---
title: compiler/resolve
---
# compiler/resolve
## `active-module`
*Native defined at lib/compiler/resolve.lisp:7:1*

Get the module of the node currently being resolved.

## `active-node`
*Native defined at lib/compiler/resolve.lisp:1:1*

Get the node currently being resolved.

## `active-scope`
*Native defined at lib/compiler/resolve.lisp:4:1*

Get the scope of the node currently being resolved.

## `(reify x)`
*Defined at lib/compiler/resolve.lisp:49:2*

Return the definition of the _symbol_ (not variable) `X`, returning
`nil` if it's not a top-level definition.

## `scope-vars`
*Native defined at lib/compiler/resolve.lisp:10:1*

Return the variables present in the given `SCOPE`, using the
[`active-scope`](lib.compiler.resolve.md#active-scope) if none is given.

## `try-var-lookup`
*Native defined at lib/compiler/resolve.lisp:22:1*

Try to look up `SYMBOL` in the given `SCOPE`, using the [`active-scope`](lib.compiler.resolve.md#active-scope)
if none given.

If this variable hasn't been defined yet then this will return
`nil`.

## `var-definition`
*Native defined at lib/compiler/resolve.lisp:29:1*

Get the definition of the given `VARIABLE`, returning `nil` if it is
not a top level definition.

Note, if the variable hasn't been fully built, then this function
will yield until it has: do not call this method within another
coroutine.

## `var-docstring`
*Native defined at lib/compiler/resolve.lisp:45:1*

Get the docstring for the given `VARIABLE`, returning `nil` if it is
not a top level definition.

## `var-lookup`
*Native defined at lib/compiler/resolve.lisp:14:1*

Look up `SYMBOL` in the given `SCOPE`, using the [`active-scope`](lib.compiler.resolve.md#active-scope) if none
given.

Note, if the variable hasn't been defined yet, then this function
will yield until it has been resolved: do not call this within
another coroutine.

## `var-value`
*Native defined at lib/compiler/resolve.lisp:37:1*

Get the value of the given `VARIABLE`, returning `nil` if it is not a top
level definition.

Note: if the variable hasn't been fully built or executed, then this
function will yield until it has: do not call this function within
another coroutine.

