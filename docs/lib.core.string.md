---
title: core/string
---
# core/string
## `$`
*Macro defined at lib/core/string.lisp:122:2*

Perform interpolation (variable substitution) on the string `STR`.

The string is a sequence of arbitrary characters which may contain an
unquote, of the form `~{foo}` or `${foo}`, where foo is a variable
name.

The `~{x}` form will format the value using [`pretty`](lib.core.type.md#pretty), ensuring it is
readable. `${x}` requires that `x` is a string, simply splicing the
value in directly.

### Example:
```cl
> (let* [(x 1)] ($ "~{x} = 1"))
out = "1 = 1"
```

## `char-at`
*Defined at lib/core/string.lisp:10:2*

Index the string `XS`, returning the character at position `X`.

### Example:
```cl
> (string/char-at "foo" 1)
out = "f"
```

## `ends-with?`
*Defined at lib/core/string.lisp:104:2*

Determine whether `STR` ends with `SUFFIX`.

### Example:
```cl
> (string/ends-with? "Hello, world" "world")
out = true
```

## `quoted`
*Defined at lib/core/string.lisp:75:1*

Quote the string `STR` so it is suitable for printing.

### Example:
```cl
> (string/quoted "\n")
out = "\"\\n\""
```

## `split`
*Defined at lib/core/string.lisp:20:2*

Split the string given by `TEXT` in at most `LIMIT` components, which are
delineated by the Lua pattern `PATTERN`.

It is worth noting that an empty pattern (`""`) will split the
string into individual characters.

### Example
```
> (split "foo-bar-baz" "-")
out = ("foo" "bar" "baz")
> (split "foo-bar-baz" "-" 1)
out = ("foo" "bar-baz")
```

## `starts-with?`
*Defined at lib/core/string.lisp:94:2*

Determine whether `STR` starts with `PREFIX`.

### Example:
```cl
> (string/starts-with? "Hello, world" "Hello")
out = true
```

## `trim`
*Defined at lib/core/string.lisp:64:2*

Remove whitespace from both sides of `STR`.

### Example:
```cl
> (string/trim "  foo\n\t")
out = "foo"
```

## Undocumented symbols
 - `byte` *Native defined at lib/lua/string.lisp:1:1*
 - `char` *Native defined at lib/lua/string.lisp:2:1*
 - `concat` *Native defined at lib/lua/table.lisp:1:1*
 - `dump` *Native defined at lib/lua/string.lisp:3:1*
 - `find` *Native defined at lib/lua/string.lisp:4:1*
 - `format` *Native defined at lib/lua/string.lisp:5:1*
 - `gsub` *Native defined at lib/lua/string.lisp:6:1*
 - `len` *Native defined at lib/lua/string.lisp:7:1*
 - `lower` *Native defined at lib/lua/string.lisp:8:1*
 - `match` *Native defined at lib/lua/string.lisp:9:1*
 - `rep` *Native defined at lib/lua/string.lisp:10:1*
 - `reverse` *Native defined at lib/lua/string.lisp:11:1*
 - `sub` *Native defined at lib/lua/string.lisp:12:1*
 - `upper` *Native defined at lib/lua/string.lisp:13:1*
