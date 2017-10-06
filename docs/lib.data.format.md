---
title: data/format
---
# data/format
## `format`
*Macro defined at lib/data/format.lisp:120:2*

Output the string `STR` formatted against `ARGS` to the stream `OUT`. In
the case `OUT` is nil, a string in returned; If `OUT` is true, the result
is printed to standard output.

### Formatting specifiers

Formatting specifiers take the form `{...}`, where `...` includes
both a _reference_ (what's to be output) and a _formatter_ (how to
                                                                output it).

- If the reference starts with `#`, it is an implicit named symbol
(something in scope, and not passed explicitly).
- If the reference starts with an alphabetic character, it is
_named_: something given to the [`format`](lib.data.format.md#format) macro explicitly, as a
keyword argument.
- If the reference starts with `$`, it is a positional argument.

The formatter can either start with `:`, in which case it references
an Urn symbol, or start with `%`, in which case it is a string.format
format sequence.

### Examples
```cl
> (format nil "{#pretty:pretty} is {what}" :what 'pretty)
out = "«method: (pretty x)» is pretty"
> (format nil "0x{foo%x}" :foo 123)
out = "0x7b"
```

