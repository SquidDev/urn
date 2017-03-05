---
title: Macros and more
layout: text
---

# Macros and more
Metaprogramming is a technique where programs can be treated as data, allow you to write code which can read, manipulate
and generate code. This is an incredibly powerful feature as it allows you to avoid writing out similar code multiple
times, instead generating it at compile time.

Metaprogramming in Urn is achieved through macros. These are function-like objects which are executed at compile time,
allowing them to create and modify code. Before we learn about macros though, we need to talk about quoting.

## Quoting
Quoting allows you to "escape" code: converting it from executable code into a series of lists which can be modified. To
do that, you can either call the `quote` construct, or place the quote symbol at the front of an expression.

For instance, compare a normal expression:

```repl
> (+ 2 3)
5
```

with the quoted form:

```repl
> '(+ 2 3)
(+ 2 3)
> (quote (+ 2 3))

```

As you can see, the quoted form looks exactly the same, but can then be modified as a normal object:

```repl
> (car '(+ 2 3))
+
```

What happens if we want to include our own values in this quoted expression though? Maybe we want to allow people to
specify their own symbols. Of course, we could always create our own lists manually:

```repl
> (define x 3)
> (list '+ 2 x)
(+ 2 3)
```

However, this ends up looking very ugly for nested expressions. Consider:

```repl
> '(+ 2 (* 3 5))
(+ 2 (* 3 5))
> (list '+ 2 (list '* x 5))
(+ 2 (* 3 5))
```

This won't do! Thankfully there is an alternative version of `quote`: using `syntax-quote` or a backtick (`` ` ``) will
act just like a normal quote until it hits a comma (or `unquote`). This will execute the value following the comma and
substitute it's value back into the expression.

```repl
> `(+ 2 (* ,x 5))
(+ 2 (* 3 5))
```

> **A word on `syntax-quote`:** Strictly speaking, `syntax-quote` doesn't act *exactly* the same as `quote`: it requires
> all quoted symbols to be resolvable at compile time. For instance, `` `(+ 2 3)`` requires `+` to be defined.

It is also possible to insert whole lists inside a backtick expression using `,@` (`unquote-splice`).

```repl
> (define x '("foo" "bar" "baz"))
> `(.. ,@x "qux")
(.. "foo" "bar" baz" "qux")
```

## Defining macros
As we've mentioned, macros allow us to change code at compile time. First off, let's see an example:

```cl
(defmacro show (x)
  (print! "Compile-time" (pretty x))
  `(progn
     (print! "Run-time" ,(pretty x))
     (print! "Value" ,x)))
```

If we then use this macro, we should get three lines:

```repl
> (show (+ 2 3))
Compile-time (+ 2 3)
Run-time     (+ 2 3)
Value        5
```

So let's break this down a little. As you may have guessed, `defmacro` is sort of like `defun` but for macros. Instead
of getting a series of values as arguments, it receives the quoted form of its arguments: in this case you will get the
equivalent of `'(+ 2 3)`.

The body of the function is executed at compile time, meaning our first print statement executes when the code is
compiled. It then returns a quoted list, which is composed of two expressions: one which prints out the quoted form of
the value, one which prints out the value itself.

One thing to try here is replace `defmacro` with `defun` and call `show` with the quoted value, then you can see your
exact outputs. In this case, it will be something like:

```cl
(progn
  (print! "Run-time" "(+ 2 3)")
  (print! (+ 2 3)))
```

Of course, this isn't all you can do, anything that can be done in a function can be done in a macro. This means you can
define complex macros which traverse their arguments, perform IO, or anything else you fancy.

There are a couple of things you should be careful of when implementing macros:
 - Macro hygiene
 - Correct evaluation

For instance, let's consider a macro which will evaluate its argument, printing its tree form and value if it returns a
falsey value. Let's look at attempt number 1:

```cl
(defmacro debug-true (x)
  `(unless ,x
    (print! (.. ,(pretty x) " returned " (pretty ,x)))))
```

Let's try this out on a couple of values:

```cl
(debug-true false)
(debug-true (nil? '(1 2 3)))
```

seems to be working pretty well right? How about this:

```cl
(debug-true (print! "foo"))
```

Uh, oh. Due to how we've written the macro, the expression gets evaluated twice if it evaluates to false. Maybe we
should store the result in a temporary variable.


```cl
(defmacro debug-true (x)
  `(with (tmp ,x)
    (unless tmp
      (print! (.. ,(pretty x) " returned " (pretty tmp))))))
```

Wait, now we're getting errors about "Cannot find variable tmp"? That doesn't even make sense! Remember what I said
earlier about `syntax-quote` requiring a variable to be defined: that's coming into play here: `tmp` doesn't actually
exist when we quote this expression.

First off, let's talk about why this restriction exists in the first place. The answer is simple: macro hygiene. Imagine
we didn't have such a requirement and I wrote some code like this:

```cl
(with (pretty "this text is so pretty :)"
  (debug-true "foo"))
```

We're now going to get lots of confusing errors about calling strings and what not: our `debug-true` macro is now
calling this `pretty` variable, rather than the symbol we wanted it to! By resolving all symbols, `syntax-quote` ensures
we always get the correct one.

Now on to the problem at hand: `tmp` doesn't exist and so we can't use it. More over, if we used `tmp` we might suffer
from a similar hygiene problem: what if code inside our macro's argument relied on `tmp`: then it might be using our
value rather than the value they wanted! The solution here is to make our own symbol which won't be used by anyone else:
enter `gensym`.

`gensym` will create a new symbol, which we can store to a variable and `unquote` into our expression:

```cl
(defmacro debug-true (x)
  (with (tmp (gensym))
    `(with (,tmp ,x)
      (unless ,tmp
        (print! (.. ,(pretty x) " returned " (pretty ,tmp)))))))

```

Whilst this macro is a tad more complicated than our original implementation, it is much more sturdy.

> **A word on macro hygiene:** The astute of you will have noticed that `quote` allows you to create your own symbols
> without them having to exist. This means you can unquote a quoted symbol to use a custom symbol. The above example
> could be written as:
>
> ```cl
> (defmacro debug-true (x)
>   `(with (,'tmp ,x)
>     (unless ,'tmp
>       (print! (.. ,(pretty x) " returned " (pretty ,'tmp))))))
> ```
>
> However, be careful: you loose some of the macro safety here so only do it for blocks you know no user code will be
> executed within.

## Everything's a macro
The largest testament to the power of macros is the fact that the vast majority of Urn's language is defined as them. In
fact, there are only a handful of "builtin" constructs, from which everything else can be created:

 - `define`, `define-macro` and `define-native`: Our terms which allow you to create new top level definitions.
 - `quote`, `syntax-quote`, `unquote` and `unquote-splice`: These allow you to switch between code and data.
 - `lambda`: For all function definitions.
 - `cond`: For all conditions.
 - `set!`: For assigning variables.
 - `import`: For interfacing with external modules.

So, how can we use these to build up the whole language? Let's start with a couple of simple macros. First off: `defun`.

```cl
(define-macro defun (lambda (name args &body))
  `(define ,name (lambda ,args ,@body)))
```

As you can see, `defun` is just a simple wrapper for `define-macro`: wrapping the body and arguments in a lambda and
then declaring a variable. `defmacro` is not dissimilar.

> **A word on `defun`:** In reality, `defun` is a tad more complicated as it moves documentation strings from inside the
> function body to outside.

Next off, let's consider another pretty common construct: `if`. We've only got one way of doing conditions, `cond`, so
we'll have to use that. This ends up being pretty simple.

```cl
(defmacro if (c t f)
  `(cond
    [,c ,t]
    [true ,f]))
```

This should be fairly self-explanatory: if `c` evaluates to true then we'll execute `t`, otherwise we'll execute
`f`. Note that now that we've defined `defmacro`, we're free to use it wherever. By defining more complex terms from
simpler ones, the entire language is "bootstrapped".

Now let's cover variables. Looking at the above, we've only two ways to introduce new variables into scope: with
`define` or `lambda`'s arguments. `define` is obviously far from ideal so we'll have to use `lambda`. Let's consider how
this would work: we want to declare a variable `x` and assign it the value `2`. To create this variable, we just need to
create a new lambda taking one argument: `x`.

```cl
(lambda (x) (print! x))
```

Now we need to find a way to set `x` to `2` and then execute it. The answer is simple: call it with `2`!

```cl
((lambda (x) (print! x)) 2)
```

No one wants to actually write code like this though, so we create a macro, `with`, which handles all of this.

```cl
(defmacro with (var &body)
  `((lambda (,(car var 1)) ,@body) ,(cadr var)))
```

We won't go into any more detail here about how other language features are implemented, but you can always peruse the
source if you are interested.

## Debugging macros
Debugging macros is a pesky business as you have to deal with code failing at compile time, producing invalid outputs
and more! There isn't any simple way to debug compile time failures: often smattering your code everywhere with `debug`s
is your best solution.

With generated tools, there is one tool which is slightly more useful. If you run the compiler with the `--emit-lisp`
flag, it will generate a `.lisp` file with the same name as your `.lua` output file. This will contain the expanded
version of all macros, including the one you just defined!
