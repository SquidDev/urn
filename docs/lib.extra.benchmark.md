---
title: extra/benchmark
---
# extra/benchmark
## `(benchmark! times body)`
*Macro defined at lib/extra/benchmark.lisp:21:1*

Modify the function definition `BODY` so that all executions are
benchmarked. That is, the function is run repeatededly `TIMES` times,
and the average running time is reported on standard output.

Note that documentation strings and other attributes are not
preserved, and that the definition must be of the form

```
(defun foo (bar) ...)
``` 

## `(time! body)`
*Macro defined at lib/extra/benchmark.lisp:3:1*

Modify the function definition `BODY` so that all executions are
automatically timed. The time report is printed to standard output.

Note that documentation strings and other attributes are not
preserved, and that the definition must be of the form

```
(defun foo (bar) ...)
``` 

