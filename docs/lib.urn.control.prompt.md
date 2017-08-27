---
title: urn/control/prompt
---
# urn/control/prompt
### Continuation objects

The value given to the handler in [`call-with-prompt`](lib.urn.control.prompt.md#call-with-prompt-prompt-tag-body-handler), much like
the value captured by [`shift`](lib.urn.control.prompt.md#shift-k-body), is not a coroutine: it is a
continuation object. Continuation objects (or just "continuations")
can be applied, much like functions, to continue their execution.

They may also be given to [`call-with-prompt`](lib.urn.control.prompt.md#call-with-prompt-prompt-tag-body-handler).

## `(abort-to-prompt tag &rest)`
*Defined at lib/urn/control/prompt.lisp:123:1*

Abort to the prompt `TAG`, giving `REST` as arguments to the handler.

## `(abort/p tag &rest)`
*Defined at lib/urn/control/prompt.lisp:127:1*

Abort to the prompt `TAG`, giving `REST` as arguments to the handler.

## `(alive? k)`
*Defined at lib/urn/control/prompt.lisp:159:1*

Check that the continuation `K` may be executed further.

### Example:
```
> (alive? (reset (shift k k)))
out = true
```

## `(block &body)`
*Macro defined at lib/urn/control/prompt.lisp:177:1*

Estabilish an escape continuation called `break` and evaluate `BODY`.

### Example:
```cl
> (block
.   (print! 1)
.   (break)
.   (print! 2))
1
out = nil
```

## `(call-with-escape-continuation body)`
*Defined at lib/urn/control/prompt.lisp:73:1*

Invoke the thunk `BODY` with an escape continuation.

### Example
```cl
> (call-with-escape-continuation
.   (lambda (return)
.     (print! "this is printed")
.     (return 1)
.     (print! "this is not")))
this is printed
out = 1
```

## `(call-with-prompt prompt-tag body handler)`
*Defined at lib/urn/control/prompt.lisp:24:1*

Call the thunk `BODY` with a prompt `PROMPT-TAG` in scope. If `BODY`
aborts to `PROMPT-TAG`, then `HANDLER` is invoked with the coroutine
representing the rest of `BODY` along with any extra arguments to
[`abort-to-prompt`](lib.urn.control.prompt.md#abort-to-prompt-tag-rest).

**NOTE**: The given `HANDLER` is not executed in the scope of the
prompt, so subsequent calls to [`abort-to-prompt`](lib.urn.control.prompt.md#abort-to-prompt-tag-rest) in the
continuation will not be handled.

### Example
```cl
> (call-with-prompt 'tag
.                   (lambda ()
.                     (+ 1 (abort-to-prompt 'tag)))
.                   (lambda (k)
.                     (k 1)))
out = 2
```

## `(let-escape-continuation k &body)`
*Macro defined at lib/urn/control/prompt.lisp:94:1*

Bind `K` within `BODY` to an escape continuation.

### Example
```cl
> (let-escape-continuation return
.   (print! 1)
.   (return 2)
.   (print! 3))
1
out = 2
```

## `(let-prompt tg e h)`
*Macro defined at lib/urn/control/prompt.lisp:68:1*

Evaluate `E` in a prompt with the tag `TG` and handler `H`.

## `(reset &body)`
*Macro defined at lib/urn/control/prompt.lisp:131:1*

Establish a prompt, and evaluate `BODY` within that prompt.

### Example
```
> (* 2 (reset (+ 1 (shift k (k 5)))))
out = 12
```

## `(shift k &body)`
*Macro defined at lib/urn/control/prompt.lisp:146:1*

Abort to the nearest [`reset`](lib.urn.control.prompt.md#reset-body), and evaluate `BODY` in a scope where
the captured continuation is bound to `K`.

### Example
```
> (* 2 (reset (+ 1 (shift k (k 5)))))
out = 12
```

## Undocumented symbols
 - `$continuation` *Defined at lib/urn/control/prompt.lisp:13:1*
 - `call/ec` *Defined at lib/urn/control/prompt.lisp:108:1*
 - `call/p` *Defined at lib/urn/control/prompt.lisp:66:1*
 - `(continuation? r_790)` *Defined at lib/urn/control/prompt.lisp:13:1*
 - `let/ec` *Macro defined at lib/urn/control/prompt.lisp:109:1*
 - `let/p` *Macro defined at lib/urn/control/prompt.lisp:71:1*
