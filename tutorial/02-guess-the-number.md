---
title: Guess the number
layout: text
---

# Guess the number
In order to get more into the spirit of Urn here, let's create the traditional "guess the number" game: the computer
will generate a random number and you've got to guess what it is!

Well then, let's create a new file, `guess.lisp` and start writing some code!

## Totally random, dude!
First off, we'll want to generate some random numbers. To do that, we need to import an external library. Let's import
the `random` function from the `lua/math` library.

```cl
(import lua/math (random))
```

> **A digression on imports**: The import expression takes one argument, and several optional ones. The first argument
> is the library to import, in this case `lua/math`. By default all symbols in `lua/math` will be imported into the
> current scope prefixed with `lua/math/`: for instance, you'd reference the `random` function as `lua/math/random`.
>
> If you specify a symbol as the second argument, all symbols will be prefixed with that instead. For example:
>
> ```cl
> (import lua/math math)
> (math/random 1 10)
> ```
>
> If you only need a few symbols, you can specify a list of required symbols instead: this will import those variables
> directly into the scope. This is what we're doing here.

So now that we've got the ability to generate a couple of random numbers, let's generate a couple and print them to the
terminal. As we want to generate integers (and not decimals) we'll pass two numbers: the lower and upper bounds to
generate between.

```cl
(print! (random 1 10))
```

We can copy and paste this line a few more times to get some more random numbers, but that gets tedious rather
quickly. Let's use a loop instead. As we just want to do something a set number of times, we'll use the `for` looping
construct.

```cl
(for i 1 10 1
  (print! (random 1 10)))
```

So what's going on here? `for` is a rather complex construct so we'll go though this slowly. Firstly, let's consider the
"signature" of `for`:

```cl
(for ctr start end step &body)
```

`for` will create a new variable, `ctr`, and set it to every value between `start` and `end`, adding `step` and
executing all expressions in `body` each time. In our code above, we will set `i` to every number between 1 and 10
inclusive and print a random number.

> **What's this `&body` doing?** When `&` is in front of a variable name, it means it takes a variable number of
> arguments. Any additional arguments you give the function will get bundled into a list and assigned to this argument.

Of course, we only really want one random number, so instead let's generate it and store it to a variable. There are two
kinds of variables in Urn: top level definitions (like those created by `defun`) and "lexically scoped" variables (such
as function arguments). Top level definitions are accessible anywhere in your program, lexically scoped variables are
only available in the current block.

In this case, we want to create a lexically scoped variable. We'll use a `with` construct to do that:

```cl
(with (my-number (random 1 10))
  (print! my-number))
```

The first argument here is a little odd: it is another list. It defines a variable to define (`my-number`) and a value
to store in this variable. You can then use `my-number` anywhere inside the body of the `with` construct. This variable
doesn't exist outside of the block though: you'll get an error if you try to access it:

```cl
(with (my-number (random 1 10))
  (print! my-number)) ;; Works OK: you're inside the `with` block

(print! my-number) ;; [ERROR] Cannot find variable my-number
```

Now that we've got a number, let's ask the player what number they think it is.

## Reading user input
The easiest way to read and write data from the terminal is to use Lua's `io` library, namely the `read` and `write`
functions. So first off, let's import these into the scope:

```cl
(import lua/io (read write))
```

Let's start off with displaying a prompt to the user and just echoing what they typed in. We'll create a helper function
to do this:

```cl
(defun read-input ()
  (write "Enter a number> ")
  (with (res (read "*l"))
    (print! (.. "You entered " res))))
```

This is just a combination of things you've seen before, but with a couple of new functions: we write some text, read a
line from the console (hence the `"*l"` argument to `read`), store it to a variable and print it!. The `..` function
simply takes a list of strings and concatenates them together (just like Lua's `..` operator).

Of course, we're interested in numbers, not strings. So we'll need to convert it to a number, and ask them again if what
the user enters isn't valid. To do this, we'll need to use a conditional.

The simplest conditional in Urn is `if`. This takes three arguments: the condition to test on, an expression to execute
if this condition true and an expression to execute otherwise. We can simply attempt to convert our string to a number,
print a message if it fails or return the number if it works.

```cl
(defun read-input ()
  (write "Enter a number> ")
  (with (res (read "*l"))
    (with (num (string->number res))
      (if num
        num
        (progn
          (print! "That's not a valid number. Try again!")
          (read-input))))))
```

Well, we've got a couple of new things here. Firstly let's talk about `progn`. In Lisp there isn't a distinction between
"statements" and "expressions": everything is an expression. For instance, it is possible to use the result of an `if`
expression in a computation (like a more powerful ternary operator). However, sometimes you need to execute multiple
expressions. Consider `defun` and `with`: these both accept multiple expressions, each one being executed and the last
one being the "result" of the whole thing. `progn` is another such construct, executing a series of expressions in
order.

You can see this all in action here: our `if` will return `num` if it is a number, or otherwise will execute all
expressions in `progn`. `progn` executes the `print!` call, and returns its last expression, calling `read-input`
again. This is an example of tail-recursion. Instead of a manual loop construct, like `for` above, we can simply call
the function again and return its value instead. In fact, behind the scenes, this is how all looping is implemented.

You can now call this function, should you so fancy.

```cl
(print! (.. "You entered: " (number->string (read-input))))
```

Note the `number->string` function. It isn't strictly required, but it is considered good form to add these cast
functions rather than allowing Urn to implicitly convert between types.

## Comparing numbers
So now that we can read user input and have a random number, let's compare the two. We're going to print out a message
telling the user if they are too large, too small or just right. We'll also return if it was correct: so we know when to
stop our program. As we're going to be doing multiple comparisons, our best choice is to use `cond`, a construct similar
to an `if` - `elseif` block in Lua.

```cl
(defun compare (input expected)
  (cond
    [(< input expected)
     (print! "Too small!")
     false]
    [(= input expected)
     (print! "You win!")
     true]
    [(> input expected)
     (print! "Too large!")
     false]))
```

Each element of `cond` is composed of two parts. The first is a condition which, if it evaluates to true, will execute
the remaining parts of this element.

It is worth noting that each `cond` case is executed in order, stopping on the first truthy element. If nothing is
truthy then an error occurs: you should be careful to add a true block if you want to handle all cases. In the above
case this isn't needed as one of the conditions has to be true.

> **A word on brackets:** You might have noticed those square brackets (`[`, `]`) in the above code. This doesn't have
> any special meaning: sometimes we use different sets of brackets in order to make it clearer what brackets line up.


## Putting it all together
Well, we've got all the components, let's merge everything together! We want to loop, prompting for input and comparing
it to the expected value. If it is equal, then we want to exit the program, otherwise prompt again. We could write a
tail-recursive function but, just for fun, let's use a `while` loop instead.

```cl
(with (my-number (random 1 10))
  (with (found false)
    (while (! found)
      (set! found (compare (read-input) my-number)))))
```

Here we use the not function (`!`) to check if we haven't found a match yet, and loop until we do.

This is also our first introduction to `set!`. This takes a symbol and sets it's value to that given. When `compare`
returns true, `found` will be set to true and so `(! found)` is false, resulting in the loop terminating.

You should now be able to run your code (`lua tacky/cli.lua guess.lisp --run`) and play the game.

## Polishing things up
Now that we've got everything working, let's clean up the code a little. Firstly, you may notice that running the
program multiple times always results in the same random number being generated. In order to fix this, you'll need to
"seed" the random number generator. We'll use the current time as our seed.

Let's add `randomseed` to our `lua/math` import list, as well as importing `time` from `lua/os`:

```cl
(import lua/math (random randomseed))
(import lua/os time)

(randomseed (time))
```

Now running our program multiple times should mean we get different numbers. Much better!

The next issues are more stylistic, but still good to fix. First let's look at our `read-input` function and our main
loop: both have nested `with` bindings. This gets a little ugly when you've got a lot of variables, so let's polish this
up using `let*`:

```cl
(let* [(my-number (random 1 10))
       (found false)]
  (while (! found)
    (set! found (compare (read-input) my-number))))
```

`let*` can be thought of as multiple nested `with`s bundled into one: each declared variable is accessible in all
successive bindings. If you fancy, why not apply the same transformation to `read-input`?

Lastly, let's add some documentation to our code. Documentation is given by a string at the top of the program or
function. Firstly we'll document the entire module, giving an explanation of what the entire program does. Just place a
string at the *very* top of the program.

```cl
"A simple implementation of a number guessing game.

 This generates a random number and prompts for a number, giving feedback on whether
 it is too large or too small."

(import lua/math (random randomseed)
;; And the rest of your module
```

> **A word on strings:** Strings can span multiple lines. Multi-line strings are aligned to the start quote character,
> making it easier to format your strings correctly. For instance,
>
> ```cl
> (print! "Hello
>          World")
> ```
>
> results in
>
> ```text
> Hello
> World
> ```

We'll also want to document our `read-input` and `compare` methods.


```cl
(defun read-input ()
  "Read a number from the terminal, prompting until a valid number is entered"
  (write "Enter a number> ")
  ;; Etc...
  )

(defun compare (input expected)
  "Compare INPUT to EXPECTED, returning whether it is too large, small or correct"
  ;; Etc...
  )
```

Doc strings allow for several formatting codes:
 - `SYMBOLS` which are upper case are read as arguments to the function.
 - `[[random]]` will link to the documentation of another symbol in scope.
 - Any markdown code, including GitHub's multi-line code blocks.

We can then generate documentation for this module, by running the compiler with the `--docs .`: this will produce a
`guess.md` file in the current directory. You can also view the documentation of symbols in the REPL using the `:doc`
command. For example:

```repl
> :doc with
(lib/base/with var &body)
Bind the single variable VAR, then evaluate BODY.
```
