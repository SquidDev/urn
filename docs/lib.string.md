---
title: string
---
# string
## `(.. &args)`
*Defined at lib/string.lisp:12:1*

Concatenate the several values given in `ARGS`. They must all be strings.

## `(char-at xs x)`
*Defined at lib/string.lisp:8:1*

Index the string `XS`, returning the character at position `X`.

## `(ends-with? str suffix)`
*Defined at lib/string.lisp:82:1*

Determine whether `STR` ends with `SUFFIX`.

## `quoted`
*Defined at lib/string.lisp:65:1*

Quote the string `STR` so it is suitable for printing.

## `(split text pattern limit)`
*Defined at lib/string.lisp:16:1*

Split the string given by `TEXT` in at most `LIMIT` components, which are
delineated by the Lua pattern `PATTERN`.

It is worth noting that an empty pattern (`""`) will split the
string into individual characters.

### Example
```
> (split "foo-bar-baz" "-")
("foo" "bar" "baz")
> (split "foo-bar-baz" "-" 1)
("foo" "bar-baz")
```

## `(starts-with? str prefix)`
*Defined at lib/string.lisp:78:1*

Determine whether `STR` starts with `PREFIX`.

## `(trim str)`
*Defined at lib/string.lisp:60:1*

Remove whitespace from both sides of `STR`.

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
