---
title: How do I do X?
layout: text
---

# How do I do X in Urn?
{:.no_toc}

* TOC
{:toc}

In this document we'll try to cover some of the common expressions and tasks you might do in Lua, and how to translate
them to Urn. If you can't find what you're looking for here, I recommend you have a browse through
the [prelude](../docs/lib.prelude.md), as well as any other hopeful looking libraries on the sidebar.

## Table interaction
In Urn, there are two types of tables: lists (a sequential list of values) and structs (a key to value mapping). Urn
provides functions to interact with both. In this section, we'll deal with structs.

Firstly, you might want to peruse the [table library](../docs/lib.table.md). We'll pick out a couple of useful
definitions from there.

If you've got a table, you probably want to get some values out of it. In order to do this you can use the `.>`
macro. This will lookup the given index in the specified table. Generally when indexing tables you use keys instead of
strings: these are normal symbols, but prefixed with `:`.

```cl
(define x (my-complex-table))

;; Equivalent to x.size in Lua
(print! (.> x :size))

;; You can specify a chained index (this is equivalent to x.range.name)
(print! (.> x :range :name))
```

Of course, you can use more complex expressions too.

```cl
(print! (.> x (io/read "*l")))
```

A similar macro, `.<!` allows you to set a value in a table:

```cl
;; Equivalent to x.size = 2
(.<! x :size)

;; And, like above, you can do chained sets (equivalent to x.range.name = "foo")
(.<! x :range :name "foo")
```

These macros may have slightly confusing names, but there is a rational behind them. The `.` can be thought of as the
index operator, with `>` representing getting values out and `<` representing putting items back in. `.<!` ends with `!`
as it has side effects.

Of course, you probably want to create your own structs (or tables) now. In order to do this, you can use the `{}`
construct: either specifying a set of values, or setting them later.

```cl
(with (x {})
  (.<! x :name "Hello")
  (.<! x :age 2)
  x)

{ :name "Hello"
  :age  2 }
```

## Method calls
A common idiom in Lua is a method call, using a colon you can index a table and call the resulting function, passing the
table as its first argument. Sadly in Urn this is less convenient. In order to do this you must use the `self`
function. This takes the object, the index to get, and the argument with which to invoke the function.

```cl
(when-with (handle (io/open "out.txt" "w"))
  (self handle :write "Hello") ;; The same as handle:write("Hello")
  (self handle :close))
```

## List manipulation
Lists are a key part of any Lisp, and Urn is no exception. There are a couple of key functions in
the [list library](../docs/lib.list.md), as well as some tidy short-cuts.

First off is `car`. This gets the very first element in the list. For instance:

```cl
(print! (car '(2 4 6)))
```

will print out `2`. If you wish to access other elements, you probably want to look at the `nth` function: this takes a
list and an 1-based-index and returns the value at that index. For instance:

```cl
(print! (nth '(2 4 6) 2))
```

prints out `4`.

You'll probably want to modify lists too though, not just create them. In order to add elements to your list you can use
`push-cdr!`. This takes a list and a value and pushes it to the end of the list. It is also possible to use `.<!` and
any other table access operator on lists, should you so fancy.
