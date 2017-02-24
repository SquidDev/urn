(import base (defmacro gensym let* slice))
(import string (#s sub))
(import list (prune nth cddr))

(defmacro do (&statements)
  "Comprehend over (potentially several) lists according to the rules given by
   STATEMENTS.

   Unfolding rules to convert STATEMENTS into code are as follows:
   - If `(car STATEMENTS)` is the symbol `'for`, then
     - If the third symbol in STATEMENTS is `from`, then iterate with the
       variable given in the second symbol the range of values from the fourth
       symbol to the sixth symbol. that is:
       ```cl
       (do for x from 1 to 10)
       ```
       Will iterate `x` from `1` to `10`.
     - If the third symbol in STATEMENTS is `in`, then iterate with the
       variable given in the second symbol over the list given in the fourth
       symbol, that is:
       ```cl
       (do for x in '(1 2 3 4 5))
       ```
       will iterate `x` to be `1`, then `2`, all the way to `5`.
     - If the third symbol in STATEMENTS is `over`, then iterate with the
       variable given in the second symbol over the string given in the fourth
       symbol, that is:
       ```cl
       (do for x over \"hello\")
       ```
       will iterate `x` to be the elements of the string `\"hello\"`
   - If `(car STATEMENTS)` is the symbol `'when`, then only evaluate the rest
     of `STATEMENTS` when the condition given in `(cadr STATEMENTS)` evaluates
     to true.
   - If `(car STATEMENTS)` is the symbol `'yield`, then add the value of
     evaluating `(cadr STATEMENTS)` to the output list.
   - If `(car STATEMENTS)` is the symbol `'do`, then evaluate `(cadr STATEMENTS)`
     without adding the result to the output list.

   Examples:

   - The cartesian product of two lists:
     ```cl
     (do for x in xs
         for y in ys
         yield (pair x y))
     ```
   - Pythagorean triples less than a number N:
     ```cl
     (lambda (n)
       (do for c from 1 to n
           for b from 1 to c
           for a from 1 to b
           when (eq? (^ c 2) (+ (^ a 2) (^ b 2)))
           yield (list a b c)))
     ```"
  (letrec [(name (gensym))
           (unfold
             (lambda (stmt)
               (let* [(hd (car stmt))
                      (stmt (cdr stmt))]
                 (cond
                   [(eq? hd 'for)
                    (let* [(var (nth stmt 1))
                           (sep (nth stmt 2))
                           (lis (nth stmt 3))
                           (rest (cdddr stmt))
                           (var_ (gensym (symbol->string var)))
                           (lis_ (gensym (symbol->string lis)))]
                      (cond
                        [(eq? sep 'in)
                         `(for ,var_ 1 (# ,lis) 1
                            (let [(,lis_ ,lis)
                                  (,var (nth ,lis_ ,var_))]
                            ,(unfold rest)))]
                        [(eq? sep 'over)
                         `(let [(,lis_ ,lis)]
                            (for ,var_ 1 (#s ,lis) 1
                              (let [(,var (sub ,lis_ ,var_ ,var_))]
                                ,(unfold rest))))]
                        [(and (eq? sep 'from)
                              (eq? (nth stmt 4) 'to))
                         (let [(start (nth stmt 3))
                               (end (nth stmt 5))]
                          `(for ,var ,start ,end 1
                            ,(unfold (slice stmt 6))))]))]
                   [(eq? hd 'when)
                    (let* [(cond_ (car stmt))
                           (rest  (cdr stmt))]
                      `(if ,cond_
                         ,(unfold rest)
                         (push-cdr! ,name '())))]
                   [(eq? hd 'do)
                    (let* [(expr_ (car stmt))
                           (rest (cdr stmt))]
                      `(progn
                         ,expr_
                         ,(unfold rest)))]
                   [(eq? hd 'yield)
                    (let* [(val_ (car stmt))
                           (rest (cdr stmt))]
                      `(progn
                         (push-cdr! ,name ,val_)
                         ,(unfold rest)))]
                   [true 'nil ]))))]
    `(let [(,name '())]
       ,(unfold statements)
       (prune ,name))))
