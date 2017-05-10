(import base (defmacro gensym let* slice))
(import string (#s sub))
(import list (prune nth cddr))

(defmacro do (&stmts)
  "Comprehend over several lists as defined by STMTS.

   ### Example:
   ```cl
   > (do (<- x (range 1 10))
   .     (<- y (range 1 10))
   .     (when (even? (+ x y))
   .       (* x y)))
   out = (1 3 5 7 9 4 8 12 16 20 3 9 15 21 27 8 16 24 32 40 5 15 25
          35 45 12 24 36 48 60 7 21 35 49 63 16 32 48 64 80 9 27 45
          63 81 20 40 60 80 100)
   ```"
  (let* [(yield-sym (gensym))
         (reify-generator (lambda (x cnt)
            (case x
              [(<- ?v ?t :if ?c)
               (let* [(t-sym (gensym))
                      (i-sym (gensym))]
                 `(let* [(,t-sym ,t)]
                    (for ,i-sym 1 (# ,t-sym) 1
                      (let* [(,v (nth ,t-sym ,i-sym))]
                        (when ,c
                          ,cnt)))))]
              [(<- ?v ?t :unless ?c)
               (let* [(t-sym (gensym))
                      (i-sym (gensym))]
                 `(let* [(,t-sym ,t)]
                    (for ,i-sym 1 (# ,t-sym) 1
                      (let* [(,v (nth ,t-sym ,i-sym))]
                        (unless ,c
                          ,cnt)))))]
              [(<- ?v ?t)
               (let* [(t-sym (gensym))
                      (i-sym (gensym))]
                 `(let* [(,t-sym ,t)]
                    (for ,i-sym 1 (# ,t-sym) 1
                      (let* [(,v (nth ,t-sym ,i-sym))]
                        ,cnt))))]
              [?failed-case 
                failed-case])))
         (inside (let* [(out '())]
                   (for i (# stmts) 1 -1
                     (case (nth stmts i)
                       [((<- . _) @ ?gen-stmt)
                        (set! out (reify-generator gen-stmt out))]
                       [?x
                         (set! out `(,yield-sym ,x))]))
                   out))]
    (let* [(out-sym (gensym))]
      `(let* [(,out-sym '())
              (,yield-sym (cut push-cdr! ,out-sym ,'<>))]
         ,inside
         (prune ,out-sym)))))
