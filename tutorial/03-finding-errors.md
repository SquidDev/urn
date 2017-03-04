---
title: Finding errors
layout: text
---

# Finding and fixing errors
{:.no_toc}

* TOC
{:toc}

Finding errors in your programs is always tricky. Here we'll cover some common compilation errors and ways to fix
them. We'll also discuss a couple of ways to find and fix runtime errors.

## Cannot find variable [name]
This error occurs when a variable cannot be found. The first thing to check is that you've spelt the variable name
correctly and, if it is an external symbol, that you've imported it. Otherwise, there are a couple of things to consider:

```repl
> (for i 1 10
.   (print! i))
[ERROR] Cannot find variable i
 => program:[2:11 .. 2:11] ("i")

 2 | (print! i))
   |         ^
```

Here `i` cannot be found, despite it is clearly defined. The issue here is that `for` is missing an argument and so
`(print! i)` is being read as the loop's step variable. Adding an additional 1 fixes the problem:

```repl
> (for i 1 10 1 ;; Note the extra '1' here
.   (print! i))
```


## Previous declaration of [name]
Urn only allows a single definition of a variable in a given scope. When you try to create two variables with the same
name, you'll get an error message. There are a couple of times this could happen.

Firstly, if two modules export variables with the same name, you'll get a clash.

```repl
> (import lua/table ())
. (import lua/os ())
[ERROR] Previous declaration of remove
 => program:[2:1 .. 2:18]
 2 | (import lua/os ())
   | ^^^^^^^^^^^^^^^^^^ imported here
 lib/lua/os.lisp
 7 | (define-native remove)
   | ^^^^^^^^^^^^^^^^^^^^^^ new definition here
 lib/lua/table.lisp
 5 | (define-native remove)
   | ^^^^^^^^^^^^^^^^^^^^^^ old definition here
```

As you can see, both `lua/table` and `lua/os` define a `remove` symbol, resulting in clashes. Instead you should either
selectively choose just the symbols you need (such as `(import lua/table (insert))`) or qualify your inports: `(import
lua/table table)`.

## Runtime errors
Debugging runtime errors in Urn is a tad tricky due to a combination of line numbers and there being no direct mapping
between Urn and Lua tracebacks. Generally my process of fixing code is as follows:

 - Compile your Urn to Lua.
 - Find which lines errored and try to map them back to Urn.
 - Add several `print!` and `debug` around the erroring code. It might be useful to print out values of variables, as
   well as what code has and hasn't been executed.
 - Compile and run again.

We have plans to simplify the first two steps, with the help of line mapping, but that has yet to be implemented yet.
