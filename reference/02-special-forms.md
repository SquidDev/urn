---
title: Special forms
---

# Special forms
{:.no_toc}

Urn's core language is made up of a collection of "special forms", from which all other definitions are defined.

* TOC
{:toc}

## Definitions
`define`, `define-macro` and `define-native` are used to create top-level definitions. These definitions are constant
and accessible anywhere in the module. Each module cannot contain multiple definitions of the same symbol, attempting to
declare two variables of the same name will result in a compiler error (even if one is a macro and one is a normal
variable).

> **Note:** Top-level definitions can only be created in the top-level. Attempting to use any one of these inside a
> child expression will result in an error.

Any unused definition will be discarded, even if it has a side effect. Therefore, it is recommended that you do not rely
on definitions ever being executed.

### Metadata
Every definition special form accepts various "metadata" arguments.

 - If the argument is a string, then it is used as the documentation string of this definition. If there is already a
   documentation string, then an error is thrown.

 - If the argument is a key, then it'll be processed as a variable attribute. Some attributes are specific to a certain
   kind of definition (such as macros), but some are more general:

   - `:hidden` will remove a variable from the export list. This makes it inaccessible to other modules. It will also
      not show up on generated documentation.

   - Definitions marked as`:deprecated` will produce a warning when used. This key may optionally be followed by a
     string, which will be used as a deprecation message.

 - If a metadata argument cannot be processed, then an error is thrown.

### `(define name &meta val)`
`define` defines a normal variable with the given name, value and metadata. At compile-time `VAL` will only be executed
if this definition is required by a macro.

```cl
(define pi
  "Represents the mathematical constant pi."
  3.141592)

(define area
  "Compute the area of a circle, given its radius."
  :hidden
  (lambda (r) (* pi (^ r 2))))
```

The `:mutable` annotation can be used inside `define` definitions in order to allow rebinding it at runtime:

```cl
(define x :mutable 1)
(debug x) ;; x = 1
(set! x 2)
(debug x) ;; x = 2
```

### `(define-macro name &meta val)`
`define-macro` defines a macro with the given name, value and metadata.

If a macro is called directly (with its symbol as the argument, then it will be called with the quoted form of each of
its arguments. As this process occurs at compile time, invoking macros indirectly (e.g `((id if) 2 3)`) will call them
as normal functions.

### `(define-native name &meta)`
Define a binding to an external variable. As well as normal metadata annotations, native defitions accept some more
complex annotations:

 - `:pure`: If a definition is marked as pure, it can be evaluated at compile time (when its arguments are constant).

 - `:signature`: Specifies the native definition's signature. For conventional definitions, this can be inferred from
   the value. Obviously this is not the case for natives.

Native definitions can be specified in three different ways:

#### Library variable
When loading a module, Urn will look for a `.lib.lua` file with the same name. This file is embedded in the compiled
output, and native variables are bound to the values returned from this file.

#### Binding to an expression
Sometimes including a `.lib.lua` file is a little overkill. In this case, you can instruct bind the native definition to
an arbitrary Lua expression. This is done using the `:bind-to` annotation:

```cl
(define-native random :bind-to "math.random")
(debug (random))
```

Note that these definitions are stripped if they are not used, so you should try to avoid side effects within your code.

#### Template strings
Whilst `:bind-to` serves most forms, sometimes it is useful to allow arbitrary template substitutions. For instance, you
may wish to add support for Lua 5.3 bitop operators. In this case, you should use the `:syntax` annotation. This takes a
template string, where `${1}` is substituted for the 1st argument.

Definitions using `:syntax` also allow several other modifiers:

 - `:stmt`: Specifies that this syntax template is a statement instead of an expression.
 - `:syntax-precedence`: Specifies the precedence this template takes. Child expressions will be wrapped in parenthesis
   if they have a lower precedence. This can either be a number (for a uniform precedence) or a list or numbers, equal
   in length to the number of arguments in the template.
 - `:syntax-fold`: Marks this syntax form as accepting multiple arguments and, if so, the direction such arguments
   should be "folded" in. This should be followed by the string `"left"` or `"right"`.

For more information, see [the native documentation](../tutorial/06-lua-interop.md).

## `(lambda args &body)`
`lambda` defines a function with a given set of arguments and a body to execute.

`ARGS` defines a list of 0-to-many symbols. This list may contain a symbol prefixed with `&`, which will accept any
additional arguments passed to the function. Note that this argument does not need to go at the end of the argument
list.

```cl
(define foo (lambda (x &rem y) (print! (pretty rem))))

(foo 1 2) ;; rem is ()
(foo 1 2 3) ;; rem is (2)
(foo 1 2 3 4) ;; rem is (2 3)
```

The function body can be composed of any number of terms, with the last one being returned when the lambda is
executed. Note that lambdas can return multiple values through the use of Lua's `unpack` function, or the like. Urn also
follows Lua's calling mechanics, meaning all the values a function returns are used as arguments:

```cl
(with (res (list (pcall foo))) ;; Capture all return values of pcall (the success value and return values of foo).
  (print! (pretty res)))
```

## `(cond &cases)`
`cond` is Urn's branching construct, from which other conditionals are derived (like `if`, `and`, `not`). Each case is a
list, with the first element being the test to execute, and the remaining terms defining the corresponding body. Each
test is evaluated in order, stopping at the first "truthy" test and evaluating its body. If no test evaluates to true,
then an error will be thrown. For this reason, it is common to have the last case of the form `[true]`. `cond` returns
the last expression of the body that it executed.

> **Note:** Generally, each test is defined using square brackets (`[]`). This makes your code slightly easier to read,
> as you have more of a visual hint as to what parens belong to what.

```cl
(cond
  [(= x 2)
   (print! "x is 2")
   (* y 2)]
  [(= x 3)
   (print! "x is 3")
   (/ y 3)]
  [true
   (print! "x is something else")
   y])
```

## `(set! var val)`
`set!` is used to change the value of the given variable, setting it to given value. `VAR` must be a symbol, and `VAL`
can be any term. Note that you cannot change the value of top level definitions: this can only be used to mutate
function arguments.

```cl
(lambda (x)
  (unless x (set! x 0)) ;; Set x to 0 if it is falsey
  (+ x 2))
```

## `(import module info? export?)`
`import` allows you to include code from other Urn files. `MODULE` should be a symbol, specifying a file on the include
path (excluding a the `.lisp` file extension). Import takes 3 forms:

 - `(import foo)`: Import the module `foo`, with all exported symbols being prefixed with `foo/`.
 - `(import foo bar)`: Import the module `foo`, with all exported symbols being prefixed with `bar/`.
 - `(import foo ())`: Import the module `foo`, with all exported symbols being placed verbatim in the current scope.
 - `(import foo (x y z))`: Import the symbols `x`, `y` and `z` from the module `foo`, placing them in the current scope.

You can also add `:export` at the end of the import statement in order to re-export those symbols.

Note that scopes can only have one definition per variable name. Attempting to import multiple symbols of the same name
will result in a compiler error.

```cl
(import lua/math (min max) :export)
(import lua/os os)
```

## `(struct-literal &pairs)`
`struct-literal` is used to create a Lua table. It can either be called directly, or using the special `{}`
syntax. `PAIRS` defines a collection of keys and values: the odd numbered elements defining the keys, and the even ones
the values. If there are not an even number of arguments, then compilation will fail.

```cl
{ :foo 2
  bar  (+ 2 3) }

;; Equivalent to Lua's { foo = 23, [bar] = 2 + 3 }
```

## Quoting

### `(quote form)`
`quote` converts the given form into data, according to the following rules:

 - Strings and numbers are returned as is.
 - Keys are converted into a special key object (instead of their normal string representation).
 - Symbols are converted into a symbol object (instead of referencing the value they point to).
 - Lists are converted into an actual list, with each element also being quoted.

### `(syntax-quote form)`
`syntax-quote` takes a similar form to `quote`, with some important extensions:

 - Symbols must be a resolvable, top-level definition. When using `syntax-quote` to quote a symbol, a reference is
   stored to the variable it references. When a macro returns such a symbol, it can correctly resolve it back to the
   original variable.
 - If a list has `syntax-quote` as the first element, then we add one to the "level".
 - If a list has `unquote` as the first element, then we subtract one from the "level". If we're on the root
   `syntax-quote`, then the second list element is evaluated and placed in the list in place of the `unquote`.
 - If a list has `unquote-splice` as the first element, then we subtract one from the "level". If we're on the root
   `syntax-quote`, then the second list element is evaluated and asserted to be a list. Each element in this list is
   "spliced" into the quoted list, in place of the `unquote-splice`.

```cl
(syntax-quote (print! (unquote (+ 2 3)) foo))
```

### `(unquote &forms)`
`unquote`'s primary usage is in the `syntax-quote` form. However, it can be used to allow a more specific form of
compile-time execution, when a macro is overkill. Each form in `FORMS` is evaluated, and the resulting elements spliced
in place of the original `unquote`. Note that only one element can be spliced in non-block contexts (such as function
arguments).

```cl
(define factorial (lambda (n)
                    (cond
                      [(= n 0) 1]
                      [(= n 1) 1]
                      [true (* n (factorial (- n 1)))])))

;; Evaluate 10! at compile time.
(define factorial-10 ,(factorial 10))
```


### `(unquote-splice form)`
`unquote-splice`'s primary usage is in the `syntax-quote` form. When on it's own, it executes much like
`unquote`. Instead, it asserts that its argument evaluates to a list and splices each element in place of the original
`unquote-splice`. As with `unquote`, you can only splice multiple values in a block context.

```cl
;; Define the first four factorial numbers.
,@(map (lambda (k)
         `(define ,(string->symbol (.. "factorial-" k)) ,(factorial k)))
    (range 1 4))
```
