;; This file, whilst it specifies a series of tests to be run, also serves as a useful collection of
;; test cases for where the codegen should simplify expressions.
;; This element isn't automatically tested, you'd have to confirm through manual inspection.

(import extra/assert ())
(import extra/test ())

;; We declare these like this to ensure the optimiser won't inline them.
(define foo (nth '(1 2) 1))
(define bar (nth '(1 2) 2))

(describe "The codegen"
  (may "allow variadic arguments"
    (will "handle calling with variadic arguments in the middle"
      (with (slice-var (lambda (fst snd &middle last) (list fst snd middle last)))
        (affirm (eq? `(1 2 () ,nil) (slice-var 1 2))
                (eq? '(1 2 () 3)    (slice-var 1 2 3))
                (eq? '(1 2 (3) 4)   (slice-var 1 2 3 4))
                (eq? '(1 2 (3 4) 5) (slice-var 1 2 3 4 5)))))

    (will "handle inlining with variadic arguments in the middle"
      (affirm (eq? `(1 2 () ,nil) ((lambda (fst snd &middle last) (list fst snd middle last)) 1 2))
              (eq? '(1 2 () 3)    ((lambda (fst snd &middle last) (list fst snd middle last)) 1 2 3))
              (eq? '(1 2 (3) 4)   ((lambda (fst snd &middle last) (list fst snd middle last)) 1 2 3 4))
              (eq? '(1 2 (3 4) 5) ((lambda (fst snd &middle last) (list fst snd middle last)) 1 2 3 4 5))))

    (will "handle calling with variadic arguments at the end"
      (with (norm-var (lambda (fst snd &last) (list fst snd last)))
        (affirm (eq? `(1 ,nil ())   (norm-var 1))
                (eq? '(1 2 ())      (norm-var 1 2))
                (eq? '(1 2 (3))     (norm-var 1 2 3))
                (eq? '(1 2 (3 4))   (norm-var 1 2 3 4))
                (eq? '(1 2 (3 4 5)) (norm-var 1 2 3 4 5)))))

    (will "handle inlining with variadic arguments at the end"
        (affirm (eq? `(1 ,nil ())   ((lambda (fst snd &last) (list fst snd last)) 1))
                (eq? '(1 2 ())      ((lambda (fst snd &last) (list fst snd last)) 1 2))
                (eq? '(1 2 (3))     ((lambda (fst snd &last) (list fst snd last)) 1 2 3))
                (eq? '(1 2 (3 4))   ((lambda (fst snd &last) (list fst snd last)) 1 2 3 4))
                (eq? '(1 2 (3 4 5)) ((lambda (fst snd &last) (list fst snd last)) 1 2 3 4 5)))))
  (will "simplify conds"
    (affirm (= 0 (cond
                   (foo 0)
                   (bar 1)))
            (= 0 (cond
                   (foo 0)
                   (bar 1)
                   (true true)))
            (= 0 (cond
                   (foo 0)
                   (true true)
                   (bar 1)))
            (= true (cond
                      (true true)
                      (foo 0)
                      (bar 1)))))

  (will "handle nested conds"
    (affirm (= 1 (cond
                   ((cond
                      (foo 0)
                      (bar false)) 1)
                   (true 2)))
            (= 1 (cond
                   ((cond
                      (foo 0)
                      (bar 10)) 1)
                   ((cond
                      (foo 0)
                      (bar 10)) 2)
                   ((cond
                      (foo 0)
                      (bar 10)) 3)
                   (true 1)))))

  (will "handle deeply nested conds"
    (affirm (= 3 (cond
                   ((cond
                      ((cond
                         ((cond (foo 0)) 1)) 2)) 3))))))
