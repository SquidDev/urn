---
title: core/string
---
# core/string
## `($ str)`
*Macro defined at lib/core/string.lisp:188:2*

Perform interpolation (variable substitution) on the string `STR`.

The string is a sequence of arbitrary characters which may contain an
unquote, of the form `~{foo}` or `${foo}`, where foo is a variable
name.

The `~{x}` form will format the value using [`pretty`](lib.core.method.md#pretty), ensuring it is
readable. `${x}` requires that `x` is a string, simply splicing the
value in directly.

### Example:
```cl
> (let* [(x 1)] ($ "~{x} = 1"))
out = "1 = 1"
```

## `(bytes->string bytes)`
*Defined at lib/core/string.lisp:160:2*

Convert a list of `BYTES` to a string.

### Example:
```cl
> (bytes->string '(72 101 108 108 111))
out = "Hello"
```

## `(char-at xs x)`
*Defined at lib/core/string.lisp:12:2*

Index the string `XS`, returning the character at position `X`.

### Example:
```cl
> (string/char-at "foo" 1)
out = "f"
```

## `(chars->string chars)`
*Defined at lib/core/string.lisp:170:2*

Convert a list of `CHARS` to a string.

### Example:
```cl
> (chars->string '("H" "e" "l" "l" "o"))
out = "Hello"
```

## `(concat xs separator)`
*Defined at lib/core/string.lisp:22:2*

Concatenate a list of strings, using an optional separator.

### Example
```cl
> (concat '("H" "i" "!"))
out = "Hi!"
> (concat '("5" "+" "1") " ")
out = "5 + 1"
```

## `(ends-with? str suffix)`
*Defined at lib/core/string.lisp:122:2*

Determine whether `STR` ends with `SUFFIX`.

### Example:
```cl
> (string/ends-with? "Hello, world" "world")
out = true
```

## `(quoted str)`
*Defined at lib/core/string.lisp:93:1*

Quote the string `STR` so it is suitable for printing.

### Example:
```cl
> (string/quoted "\n")
out = "\"\\n\""
```

## `(split text pattern limit)`
*Defined at lib/core/string.lisp:38:2*

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

## `(starts-with? str prefix)`
*Defined at lib/core/string.lisp:112:2*

Determine whether `STR` starts with `PREFIX`.

### Example:
```cl
> (string/starts-with? "Hello, world" "Hello")
out = true
```

## `(string->bytes str)`
*Defined at lib/core/string.lisp:132:2*

Convert a string to a list of character bytes.

### Example:
```cl
> (string->bytes "Hello")
out = (72 101 108 108 111)
```

## `(string->chars str)`
*Defined at lib/core/string.lisp:147:2*

Convert a string to a list of characters.

### Example:
```cl
> (string->chars "Hello")
out = ("H" "e" "l" "l" "o")
```

## `(trim str)`
*Defined at lib/core/string.lisp:82:2*

Remove whitespace from both sides of `STR`.

### Example:
```cl
> (string/trim "  foo\n\t")
out = "foo"
```

## Undocumented symbols
 - `byte` *Native defined at lib/lua/string.lisp:1:1*
 - `char` *Native defined at lib/lua/string.lisp:2:1*
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
