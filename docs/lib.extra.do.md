---
title: extra/do
---
# extra/do
## `(do &statements)`
*Macro defined at lib/extra/do.lisp:5:1*

Comprehend over (potentially several) lists according to the rules
given by `STATEMENTS`.

Unfolding rules to convert `STATEMENTS` into code are as follows:
- If `(car STATEMENTS)` is the symbol `'for`, then
  - If the third symbol in `STATEMENTS` is `from`, then iterate with the
    variable given in the second symbol the range of values from the
    fourth symbol to the sixth symbol. that is:
    ```cl
    (do for x from 1 to 10)
    ```
    Will iterate `x` from `1` to `10`.

  - If the third symbol in `STATEMENTS` is `in`, then iterate with the
    variable given in the second symbol over the list given in the
    fourth symbol, that is:
    ```cl
    (do for x in '(1 2 3 4 5))
    ```
    will iterate `x` to be `1`, then `2`, all the way to `5`.

  - If the third symbol in `STATEMENTS` is `over`, then iterate with the
    variable given in the second symbol over the string given in the
    fourth symbol, that is:
    ```cl
    (do for x over "hello")
    ```
    will iterate `x` to be the elements of the string `"hello"`
- If `(car STATEMENTS)` is the symbol `'when`, then only evaluate the rest
  of `STATEMENTS` when the condition given in `(cadr STATEMENTS)` evaluates
  to true.
- If `(car STATEMENTS)` is the symbol `'yield`, then add the value of
  evaluating `(cadr STATEMENTS)` to the output list.
- If `(car STATEMENTS)` is the symbol `'do`, then evaluate `(cadr STATEMENTS)`
  without adding the result to the output list.

### Examples

- The cartesian product of two lists:

  ```cl
  (do for x in xs
      for y in ys
      yield (pair x y))
  ```
- Pythagorean triples less than a number `N`:
  ```cl
  (lambda (n)
    (do for c from 1 to n
        for b from 1 to c
        for a from 1 to b
        when (eq? (^ c 2) (+ (^ a 2) (^ b 2)))
        yield (list a b c)))
  ```

