---
title: urn/control/prompt
---
# urn/control/prompt
## `(abort-to-prompt tag &rest)`
*Defined at lib/urn/control/prompt.lisp:111:1*

Abort to the prompt `TAG`, giving `REST` as arguments to the handler.

## `(call-with-escape-continuation body)`
*Defined at lib/urn/control/prompt.lisp:51:1*

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
*Defined at lib/urn/control/prompt.lisp:3:1*

Call the thunk `BODY` with a prompt `PROMPT`-`TAG` in scope. If `BODY`
aborts to `PROMPT`-`TAG`, then `HANDLER` is invoked with the coroutine
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
.                     (continue k 1)))
out = 2
```

## `(continue k &args)`
*Defined at lib/urn/control/prompt.lisp:90:1*

Continue execution of `K` with `ARGS` as the arguments.

### Example
```cl
> (continue (coroutine/create
.             (lambda () (+ 1 (coroutine/yield))))
.           2)
out = 3
```

## `(let-escape-continuation k &body)`
*Macro defined at lib/urn/control/prompt.lisp:72:1*

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
*Macro defined at lib/urn/control/prompt.lisp:46:1*

Evaluate `E` in a prompt with the tag `TG` and handler `H`.

## `(reset &body)`
*Macro defined at lib/urn/control/prompt.lisp:115:1*

Establish a prompt, and evaluate `BODY` within that prompt.

### Example
```
> (* 2 (reset (+ 1 (shift k (continue k 5)))))
out = 12
```

## `(shift k &body)`
*Macro defined at lib/urn/control/prompt.lisp:130:1*

Abort to the nearest [`reset`](lib.urn.control.prompt.md#reset-body), and evaluate `BODY` in a scope where
the captured continuation is bound to `K`.

### Example
```
> (* 2 (reset (+ 1 (shift k (continue k 5)))))
out = 12
```

## Undocumented symbols
 - `call/ec` *Defined at lib/urn/control/prompt.lisp:87:1*
 - `call/p` *Defined at lib/urn/control/prompt.lisp:44:1*
 - `let/ec` *Macro defined at lib/urn/control/prompt.lisp:88:1*
 - `let/p` *Macro defined at lib/urn/control/prompt.lisp:49:1*
