---
title: Syntax
---

# Syntax
{:.no_toc}

* TOC
{:toc}

## Comments
Like many lisps, Urn uses `;` to mark a line comment. This will result in the parser ignoring all input until the next
new line. There is no block comment syntax, meaning you will have to comment each line individually.

## Number literals
Numbers follow a similar format as Lua, with additional support for binary literals.

 - Binary digits start with `#b`, then one or more `0` or `1`s. Using an invalid digit (such as 2, will result in a syntax error).
 - Hexadecimal digits start with `#x`, then one or more hexadecimal digits, (`[0-9a-zA-Z]`). Unlike Lua, you cannot have
   fractions or exponents in hexadecimal digits.
 - Decimal digits: these follow the same format as Lua: an optional integer part, an optional fractional part, all
   followed by an optional exponent (marked `e` or `E`).

For example, `2`, `#x2`, `#b10`, `2.e0`, `.2e1` and `20e-1` are all the same value.

## Strings
Strings are delimited by *double* quotes. Characters can be escaped using the `\` character, with the following escape
codes defined:

 - `\a`: Bell
 - `\b`: Backspace
 - `\f`: Form feed
 - `\n`: New line
 - `\r`: Carriage return
 - `\t`: Horizontal tab
 - `\v`: Vertical tab
 - `\\`: Backslash
 - `\"`: Literal `"`.

> **Note:** Using single quotes may not always be a syntax error. However, it will definitely not give you want you
> want. For instance, `'foo'` is a quoted version of the `foo'` symbol.

Urn also allows decimal and hexadecimal escape codes. You can specify up to three decimal digits, or `x` followed by two
hexadecimal digits. It is a parser error for the resulting value to exceed 255 (so `\300` will not parse). Consequently,
`"A"`, `"\65"` and `"\x41"` are all equivalent strings.

Strings can also span multiple lines. In this case, all successive lines must be aligned to the character after the
opening quote mark. This is especially convenient for documentation strings.

```cl
(print! "Hello,
         World!")
```

Should you wish to split a string over multiple lines, but not insert a new line character, you can terminate each line with `\`:

```cl
;; Equivalent to (print! "Hello, World!")
(print! "Hello, \
         World!")
```

### Interpolation
Following the `$` character with a string, will result in a string interpolation form. One can embed symbols inside a
string and they will be expanded
automatically. See [the `$` macro](https://squiddev.github.io/urn/docs/lib.string.html#-str) for more information.

```cl
(with (x "World")
  (print! $"Hello, ${x}!"))
```

## Symbols
Symbols represent a reference to a specific variable. Symbols can be composed of almost any character:

 - The first character of a symbol must be any letter or one of ``!#$%&*+-./<=>?@\^_`|``.
 - The remaining characters can be any letter, number or one of ``!"#$%&'*+,-./:<=>?@\^_`|>``.

It is worth noting that symbols are case sensitive: `foo` is not the same as `Foo`. You should try to keep variable
names case sensitive, using `kebab-case` should you need to separate words.

Urn also has a couple of naming conventions:
 - Predicates should end with `?`. For instance, `list?` is a function which tests whether its argument is a list.
 - Impure functions should end with `!`. For example, `push-cdr!` mutates its first argument by adding an element to it.
 - When dealing with modules, `/` is used to separate child packages or components.

## Booleans and `nil`.
The standard values `true`, `false` and `nil` take no special meaning with Urn: they are just another variable which can
be shadowed at will.

## Keys
Keys are a rather weird type. They follow the same syntactic form as symbols, though must be prefixed with
`:`.

```cl
(print! :foo)
```

Keys primary purpose is as indexes in structures. For instance, you will commonly see code like `(.> foo :bar)`, which
is equivalent to Lua's `foo.bar`. Generally, you can consider keys to be equivalent to strings. However, when quoted,
keys are compiled to an object with the type `key`.

## Lists
Lists are delimited by matching pairs of `()` or `[]`. They can contain any number of elements, as long as the
list is terminated.

```cl
() ;; The empty list
(foo bar 23 "foo" [:baz]) ;; Another list, including a series of constants and nested lists.
```

## Structs
Structs are Urn's equivalent of tables, holding key value pairs. They are by specifying key value pairs inside `{}`. For
more information, see the [`const-struct`](02-special-forms.md#const-struct-pairs) documentation.

```cl
{ :foo 2
  :bar 3 }
```

## "Shortcut" characters
Urn offers several shortcut characters, which expand into a list which calls a given variable with the next form. These
are as follows:

 - `'`: Expands to `quote`.
 - `` ` ``: Expands to `syntax-quote`.
 - `~`: Expands to `quasiquote`.
 - `,`: Expands to `unquote`.
 - `,@`: Expands to `unquote-splice`.

```cl
'foo ;; A quoted symbol, which expands to (quote foo)

`(foo bar) ;; A syntax-quoted list (expands to (syntax-quote (foo bar)) ).

,23 ;; An unquoted number, which expands to (unquote 23).
```
