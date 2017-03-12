---
title: An Introduction to Urn
layout: text
---

# An Introduction to Urn
Hello and welcome. These tutorials aim to guide you through Urn, a Lisp dialect which compiles to Lua. We'll assume you
have some prior programming knowledge. A little Lua knowledge is useful in places, though not required.

Lisp is a whole family of programming languages, of which Urn is just one member. Other members include Common Lisp,
Scheme and Clojure. All dialects have their own distinct features and capabilities, but they all have one thing in
common: the use of lists to represent data and code. This makes metaprogramming, the ability to modify and extend the
program, incredibly easy.

## Getting started
First off, you'll want to install Urn. The easiest way to do this is clone the repository using Git:

```sh
> git clone https://gitlab.com/SquidDev/urn.git && cd urn
```

You can now launch the Urn REPL: this allows you to enter code and execute it, allowing for immediate feedback.

```sh
> lua tacky/cli.lua
```

You should have an interactive prompt, where you can enter simple expressions like numbers (`123`) and strings
(`"hello"`). Let's do the classic "Hello, world!" program:

```repl
> (print! "Hello, world!")
```

So let's dissect what's happening here. First off, we have the parenthesis (`( ... )`): this is a list. Anything inside
these parentheses are the elements on the list: in this case `print!` and `"Hello, world!"`. Generally a list represents
a function call: the first element of the list is invoked with the remaining elements as arguments.

In this case, our function is `print!`. This is a symbol: a reference to a variable defined somewhere else. This
specific symbol, `print!`, is a function which prints its arguments to the terminal. It's worth noting that symbols can
contain almost any character.

> **A word on naming:** The `!` character doesn't have any semantic meaning here. By convention, any method which has a
> side effect (such as printing to the terminal, or modifying a value) we put a `!` at the end. Similarly, functions
> which return a boolean often end with `?` (such as `nil?`).

## Basic arithmetic
The next thing to do, as in any programming language tutorial, is try some very basic arithmetic. Unlike many languages,
this is done like any other function call:

```repl
> (+ 2 3)
5
```

In fact, you can just type `+` in the REPL to see that it is just a function. This means you can pass it around as an
ordinary value.

You can, of course, have lists inside lists (and lists inside lists inside lists, etc...).

```repl
> (+ 2 (* 4 5))
22
```

## Defining our own functions
Of course, it's no fun if we only use built in functions, so let's define our own. This is done using the `defun`
macro. This looks like an ordinary list, but instead of invoking a function, it creates a function with the specified
name, arguments and body.

```repl
> (defun times-two (x) (* x 2))
```

Again, let's break this down. Whilst we're not calling a function here, the premise is the same. The first argument,
`times-two`, is the name of the function we're defining. Next comes a list of arguments this function takes. Do note,
unlike before, this argument list does not represent a function call - it has a special meaning here. All remaining
elements in `defun`'s list are expressions which are executed when the function is called. The last expression will be
returned by default.

So, now we've defined this function, let's use it:

```repl
> (times-two 2)
4
> (times-two 3)
6
```

> **More on naming:** Some languages handle multiple word variable names by using `snake_case` or `camelCase`. Lisp uses
> hyphens instead to separate words, it just looks a little prettier.

## Saving everything
Of course, it would be awful if you had to enter your code into the REPL every time you wanted to execute it. Instead,
you can save your program to a `.lisp` file and execute it. Open up your favourite text editor (or ~~Vim~~ Emacs if you
haven't got one) and create a `times-two.lisp` file. Let's define our `times-two` function again, and print out the
double of a couple of numbers.

```cl
(defun times-two (x)
  (* x 2))

(print! (times-two 2))
(print! (times-two 3))
```

> **A word on formatting:** Urn, and lisps in general, have a rather unusual approach to formatting. You generally
> indent with two spaces, but you also try to line up expressions on the same "level" with each other. For example:
>
> ```cl
> (defun times-two (x
>                   y)
>   (* x 2))
> ```
>
> You should also note where the parentheses go here: instead of putting each trailing parenthesis on a new line like
> you might with a C style language, everything goes on the last line of the block.

Now that you've saved your `times-two.lisp` file, you can compile it to Lua and execute it.

```sh
# This will generate a file called "out.lua"
> lua tacky/cli.lua times-two.lisp

# Which can then be run as normal
> lua out.lua
```

If you pass `--run` when compiling, it will do both these steps at once:

```sh
> lua tacky/cli.lua times-two.lisp --run
```

You can also use `--output` to specify a different file to write to:

```sh
> lua tacky/cli.lua times-two.lisp --output my-times-two.lua
```
