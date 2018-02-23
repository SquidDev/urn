---
title: core/demand
---
# core/demand
## `(assert-type! arg ty)`
*Macro defined at lib/core/demand.lisp:64:2*

>**Warning:** assert-type! is deprecated: Use [`desire`](lib.core.demand.md#desire-condition-message) or [`demand`](lib.core.demand.md#demand-condition-message) instead.

Assert that the argument `ARG` has type `TY`, as reported by the function
[`type`](lib.core.type.md#type-val).

## `(demand condition message)`
*Macro defined at lib/core/demand.lisp:46:2*

Demand that particular `CONDITION` is upheld. If provided, `MESSAGE` will
be included in the thrown error.

Note that `MESSAGE` is only evaluated if `CONDITION` is not met.

## `(desire condition message)`
*Macro defined at lib/core/demand.lisp:53:2*

Demand that particular `CONDITION` is upheld if debug assertions are
on (`-fstrict-checks`). If provided, `MESSAGE` will be included in the
thrown error.

Note that `MESSAGE` is only evaluated if `CONDITION` is not met. Neither
will be evaluated if debug assertions are disabled.

