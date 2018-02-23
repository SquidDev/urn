---
title: compiler
---
# compiler
The compiler plugin infrastructure provides a way of modifying how the
compiler processes code.

## `flag?`
*Native defined at lib/compiler/init.lisp:60:1*

Determine whether one of the given compiler `FLAGS` are set.

## `flags`
*Native defined at lib/compiler/init.lisp:56:1*

Get a list of all compiler flags.

## `logger/do-node-error!`
*Native defined at lib/compiler/init.lisp:40:1*

Push an error message to the logger, then fail.

You must provide a message `MSG` and a node `NODE`, additional
`EXPLAINATIONS` explain can be provided, along with a series of
`LINES`. These `LINES` are split into pairs of elements with the first
designating it's position and the second a descriptive piece of
text.

## `logger/put-debug!`
*Native defined at lib/compiler/init.lisp:16:1*

Push an verbose message `MSG` to the logger

## `logger/put-error!`
*Native defined at lib/compiler/init.lisp:4:1*

Push an error message `MSG` to the logger

## `logger/put-node-error!`
*Native defined at lib/compiler/init.lisp:20:1*

Push a defailed error message to the logger.

You must provide a message `MSG` and a node `NODE`, additional
explainations `EXPLAIN` can be provided, along with a series of
`LINES`. These `LINES` are split into pairs of elements with the first
designating it's position and the second a descriptive piece of
text.

## `logger/put-node-warning!`
*Native defined at lib/compiler/init.lisp:30:1*

Push a warning message to the logger.

You must provide a message `MSG` and a node `NODE`, additional
explainations `EXPLAIN` can be provided, along with a series of
`LINES`. These `LINES` are split into pairs of elements with the first
designating it's position and the second a descriptive piece of
text.

## `logger/put-verbose!`
*Native defined at lib/compiler/init.lisp:12:1*

Push an verbose message `MSG` to the logger

## `logger/put-warning!`
*Native defined at lib/compiler/init.lisp:8:1*

Push an warning message `MSG` to the logger

## `range/get-source`
*Native defined at lib/compiler/init.lisp:50:1*

Get the nearest source position of `NODE`

This will walk up `NODE`'s tree until a non-macro node is found.

