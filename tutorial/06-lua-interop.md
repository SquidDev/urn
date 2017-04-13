---
title: Integrating with Lua
---

# Integrating with Lua
Whilst all of Lua's standard libraries are defined in Urn, you may wish to use other libraries. The easiest way to do
this is `require` the module like Lua, then declare a series of globals indexing it:

```cl
(define bit32
  :hidden
  (require "bit32"))

(define & (.> bit32 :band))
(define ~ (.> bit32 :bnot))
;; Etc...
```

This is a perfectly acceptable solution, though sometimes there is a neater way to do the same thing. Enter
`define-native`.

## Simply exporting symbols
`define-native` allows you to declare an object which is exported in an external file. There are a couple of ways of
structuring the external file, so we'll start with the simplest. First create a file named `bit32.lisp`:

```cl
(define-native &)
(define-native bnot)
;; Etc...
```

We'll also need to create another file named `bit32.lua`. This is loaded when compiling and included in the compiled
code. Here you need to export every symbol that your library will use:

```lua
local bit32 = require "bit32"
return {
  ['&'] = bit32.band,
  ['bnot'] = bit32.bnot,
  -- Etc...
}
```

As we're using symbols, this gets rather verbose. However, in simpler cases, you can often just return the library
directly. As the file is included verbatim, you can run any code you require, such as checking for `bit32`, `bitop`,
etc... However, this is also a big disadvantage as the file size increases significantly, especially detrimental when
only a couple of functions are used. Instead, you can use `.meta.lua` files.

## Meta files
Instead of declaring an entire library to export, `.meta.lua` files describe each variable, providing information about
what it should compile to. To use it, first you'll need to delete your `bit32.lua` file. Now you'll need to write a
metadata file. Thankfully, some of this can be automated by Urn:

```cl
tacky/cli.lua --gen-native=bit32 bit32.lisp
```

This should emit a `bit32.meta.lua` file:

```lua
local bit32 = bit32 or {}
return {
  ["&"] =    { tag = "var", contents = "bit32[\"&\"]", value = bit32["&"], },
  ["bnot"] = { tag = "var", contents = "bit32.bnot",   value = bit32.bnot, },
  ;; Etc...
}
```

You'll need to change `bit32[\"&\"]` and `bit32["&"]` to `bit32.band` for obvious reasons. Now when you compile
something using `bit32`, you'll only get declarations for symbols you need.

One other thing we can change, is to mark these symbols as "pure". This means the constant folder may evaluate usages of
this function at compile time, replacing `(& 2 3` with `2`:

```lua
local bit32 = bit32 or {}
return {
  ["&"] =    { tag = "var", contents = "bit32[\"&\"]", value = bit32["&"], pure = true, },
  ["bnot"] = { tag = "var", contents = "bit32.bnot",   value = bit32.bnot, pure = true },
  ;; Etc...
}
```

This is done for most of Lua's basic operators, and many of the `string` and `math` functions.

## Specialising code
Whilst the existing file should be "good enough" for most needs, sometimes it might be useful to generate more
specialised code: for instance our `bit32` functions could be replaced with Lua 5.3's `&` and `~` ops. To do that, we'll
change the `tag` field to be `expr` instead, and specify a `contents` and `count` property.

```lua
return {
  ['&'] =    { tag = "expr", contents = "(${1} & ${2})", value = bit32.band, pure = true },
  ['bnot'] = { tag = "expr", contents = "(~${1})",       value = bit32.bnot, pure = true },
  ;; Etc...
}
```

Here `contents` defines a template, with each `${n}` being replaced with the nth argument. Urn will only use this
template when the exact number of argument are specified, otherwise it will use an automatically generated wrapper
function.

Of course, we could change our `value` fields to also use the binary operators.
