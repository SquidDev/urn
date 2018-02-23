---
title: io/foreign
---
# io/foreign
Higher-level wrappers around the LuaJIT ffi module.

## `(define-foreign-function name lambda-list do-errno-check)`
*Macro defined at lib/io/foreign.lisp:8:2*

Define a foreign function wrapper for the `C` symbol `NAME`, taking
arguments `LAMBDA-LIST`.

Additionally, if `DO-ERRNO-CHECK` is true or a number, assume that
negative return values (or the number, if given) signal an error
condition, and raise an exception with the message determined by
strerror(3).

The symbol `NAME` will be mangled by replacing `-`s with `_`s. If this
is undesirable, you may give an argument of the form `(quote foo)`,
in which foo will not be mangled.


### Example:

```cl
> (ffi/cdef "char *get_current_dir_name(void);")
out = nil
> (define-foreign-function get-current-dir-name () 0)
out = function: 0x42e22188
> (get-current-dir-name)
out = cdata<char *>: 0x00d26610
> (ffi/string (get-current-dir-name))
out = "/home/hydraz/Projects/urn/compiler"
```

## `(define-foreign-functions c-definitions &functions)`
*Macro defined at lib/io/foreign.lisp:61:2*

Declare all the foreign functions specified in `C-DEFINITIONS`, and
additionally build the wrappers as described in `FUNCTIONS`, using
[`define-foreign-function`](lib.io.foreign.md#define-foreign-function-name-lambda-list-do-errno-check)

## `(ffi/defun-ffi name typedecl)`
*Macro defined at lib/luajit/ffi.lisp:22:2*

>**Warning:** ffi/defun-ffi is deprecated: Use cdef and index the `C` table directly

Define the external symbol `NAME` with the `C` type signature
given by `TYPEDECL`.

## Undocumented symbols
 - `C` *Native defined at lib/luajit/ffi.lisp:19:1*
 - `bit/arshift` *Native defined at lib/luajit/bit.lisp:9:1*
 - `bit/band` *Native defined at lib/luajit/bit.lisp:4:1*
 - `bit/bnot` *Native defined at lib/luajit/bit.lisp:3:1*
 - `bit/bor` *Native defined at lib/luajit/bit.lisp:5:1*
 - `bit/bswap` *Native defined at lib/luajit/bit.lisp:12:1*
 - `bit/bxor` *Native defined at lib/luajit/bit.lisp:6:1*
 - `bit/lshift` *Native defined at lib/luajit/bit.lisp:7:1*
 - `bit/rol` *Native defined at lib/luajit/bit.lisp:10:1*
 - `bit/ror` *Native defined at lib/luajit/bit.lisp:11:1*
 - `bit/rshift` *Native defined at lib/luajit/bit.lisp:8:1*
 - `bit/tobit` *Native defined at lib/luajit/bit.lisp:1:1*
 - `bit/tohex` *Native defined at lib/luajit/bit.lisp:2:1*
 - `cdef` *Native defined at lib/luajit/ffi.lisp:8:1*
 - `ffi/C` *Native defined at lib/luajit/ffi.lisp:19:1*
 - `ffi/abi` *Native defined at lib/luajit/ffi.lisp:9:1*
 - `ffi/alignof` *Native defined at lib/luajit/ffi.lisp:5:1*
 - `ffi/arch` *Native defined at lib/luajit/ffi.lisp:12:1*
 - `ffi/cast` *Native defined at lib/luajit/ffi.lisp:2:1*
 - `ffi/cdef` *Native defined at lib/luajit/ffi.lisp:8:1*
 - `ffi/copy` *Native defined at lib/luajit/ffi.lisp:11:1*
 - `ffi/errno` *Native defined at lib/luajit/ffi.lisp:18:1*
 - `ffi/fill` *Native defined at lib/luajit/ffi.lisp:7:1*
 - `ffi/gc` *Native defined at lib/luajit/ffi.lisp:17:1*
 - `ffi/istype` *Native defined at lib/luajit/ffi.lisp:6:1*
 - `ffi/load` *Native defined at lib/luajit/ffi.lisp:14:1*
 - `ffi/metatype` *Native defined at lib/luajit/ffi.lisp:10:1*
 - `ffi/new` *Native defined at lib/luajit/ffi.lisp:1:1*
 - `ffi/offsetof` *Native defined at lib/luajit/ffi.lisp:20:1*
 - `ffi/os` *Native defined at lib/luajit/ffi.lisp:15:1*
 - `ffi/sizeof` *Native defined at lib/luajit/ffi.lisp:4:1*
 - `ffi/string` *Native defined at lib/luajit/ffi.lisp:16:1*
 - `ffi/typeinfo` *Native defined at lib/luajit/ffi.lisp:13:1*
 - `ffi/typeof` *Native defined at lib/luajit/ffi.lisp:3:1*
