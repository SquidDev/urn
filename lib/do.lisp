(import base (clock))
(import string (#s sub))

(defmacro do (&statements)
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
