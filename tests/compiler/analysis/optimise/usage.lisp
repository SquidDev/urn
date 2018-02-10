(import test ())
(import tests/compiler/analysis/optimise/optimise-helpers ())

(import urn/analysis/optimise/usage optimise)

(describe "The optimiser"
  (section "has a fast pass which will strip unused definitions on the top level"
    (it "that are simple"
      (affirm-optimise (lambda (tracker options nodes) (optimise/strip-defs-fast nodes))
        '((define x 1)
          (define y 2)
          x)
        '((define x 1)
          x)
        0))
    (it "that are recursive"
      (affirm-optimise (lambda (tracker options nodes) (optimise/strip-defs-fast nodes))
        '((define x (lambda() y))
          (define y (lambda() x)))
        '(nil)
        0))
    (it "unless there is potential for mutation"
      (affirm-optimise (lambda (tracker options nodes) (optimise/strip-defs-fast nodes))
        '((define x :mutable 1)
          (lambda () (set! x 1)))
        '((define x :mutable 1)
          (lambda () (set! x 1)))
        0)))

  (section "will strip unused definitions on the top level"
    (it "that are simple"
      (affirm-usage-optimise optimise/strip-defs
        '((define x 1)
          (define y 2)
          x)
        '((define x 1)
          x)
        1))
    (it "that are recursive"
      (affirm-usage-optimise optimise/strip-defs
        '((define x (lambda() y))
          (define y (lambda() x)))
        '(nil)
        2))
    (it "that are used in unused lambdas"
      (affirm-usage-optimise optimise/strip-defs
        '((define x (lambda() 1))
          ((lambda (x)) (lambda () (x))))
        '(((lambda (x)) (lambda () (nil))))
        1))
    (it "that are mutable"
      (affirm-usage-optimise optimise/strip-defs
        '((define x :mutable 1)
          (lambda () (set! x 1)))
        '((lambda () nil))
        1)))

  (section "will strip unused arguments"
    (it "that are immutable"
      (affirm-transform-optimise (list optimise/strip-args)
        '(((lambda (x) 2) 3)
          ((lambda (x y z) 2) 3 4 5) ;; Multiple arguments
          ((lambda (x) 2) {})        ;; More complex arguments
          ((lambda (x) 2) (lambda ()))
          ((lambda (x) 2) '())
          ((lambda (x) 2) { :a (foo) }) ;; Non empty const-struct
          ((lambda (x) 2) (foo))     ;; Side effect in definition
          ((lambda (x) x) 3)         ;; x is used
          ((lambda (x y z) x z) 3 4 5) ;; Multiple arguments with some used
          ((lambda (x) `,x) 3))      ;; Used indirectly through syntax-quote
        '(((lambda () 2))
          ((lambda () 2))
          ((lambda () 2))
          ((lambda () 2))
          ((lambda () 2))
          ((lambda (x) 2) { :a (foo) })
          ((lambda (x) 2) (foo))
          ((lambda (x) x) 3)
          ((lambda (x z) x z) 3 5)
          ((lambda (x) `,x) 3))
        8))
    (it "that are mutable"
      (affirm-transform-optimise (list optimise/strip-args)
        '(((lambda (x) (set! x 3) 2) 3)
          ((lambda (x) (set! x 3) 2) (foo))  ;; Side effect in definition
          ((lambda (x) (set! x (foo)) 2) 2)) ;; Side effect in mutation
        '(((lambda () nil 2))
          ((lambda (x) (set! x 3) 2) (foo))
          ((lambda () ((lambda () (foo) nil)) 2)))
        2))
    (it "that are variadic"
      (affirm-transform-optimise (list optimise/strip-args)
        '(((lambda (&x) 2) 3)
          ((lambda (a &b c d) a c d) 2 3)
          ((lambda (a &b c d) a c d) 2 3 4)
          ((lambda (a &b c d) a c d) 2 3 4 5)
          ((lambda (a &b c d) a c d) 2 3 4 5 6)
          ((lambda (&x) 2) (foo)) ;; Side effect in definition
          ((lambda (&x) x) 3))    ;; x is used
        '(((lambda () 2))
          ((lambda (a c d) a c d) 2 3)
          ((lambda (a c d) a c d) 2 3 4)
          ((lambda (a c d) a c d) 2 4 5)
          ((lambda (a c d) a c d) 2 5 6)
          ((lambda (&x) 2) (foo))
          ((lambda (&x) x) 3))
        5))
    (it "when there are no values"
      (affirm-transform-optimise (list optimise/strip-args)
        '(((lambda (x) 2))
          ((lambda (x) x)))    ;; x is used
        '(((lambda () 2))
          ((lambda (x) x)))
        1)))

  (section "will fold variables"
    (it "defined in the top-level"
      (affirm-transform-optimise (list optimise/variable-fold)
        '((define-native a)
          (define b a)
          b

          (define c 1)
          (define d c)
          d)
        '((define-native a)
          (define b a)
          a

          (define c 1)
          (define d 1)
          1)
        3))

    (it "defined in the top level, unless they are mutated"
      (affirm-transform-optimise (list optimise/variable-fold)
        '((define a :mutable 1)
          (set! a 2)
          a)
        '((define a :mutable 1)
          (set! a 2)
          a)
        0))

    (it "defined in let bindings"
      (affirm-transform-optimise (list optimise/variable-fold)
        '((define-native a)
          ((lambda (b c)
             ((lambda (d) d c) b)) 1 a))
        '((define-native a)
          ((lambda (b c)
             ((lambda (d) 1 a) 1)) 1 a))
        3))

    (it "with missing definitions in let bindings"
      (affirm-transform-optimise (list optimise/variable-fold)
        '(((lambda (x)
             ((lambda (y) y) x))))
        '(((lambda (x)
             ((lambda (y) nil) nil))))
        2))

    (it "defined in let bindings, unless they are mutated"
      (affirm-transform-optimise (list optimise/variable-fold)
        '(((lambda (a)
             (set! a 1)
             a) 2))
        '(((lambda (a)
             (set! a 1)
             a) 2))
        0)))

  (section "will fold basic variable access in expressions"
    (it "for simple expressions"
      (affirm-transform-optimise (list optimise/expression-fold)
        '(((lambda (x) (+ x 1)) (+ 2 3)))
        '(((lambda ()  (+ (+ 2 3) 1))))
        1))

    (it "and push directly called lambdas in for variable returns"
      (affirm-transform-optimise (list optimise/expression-fold)
        '(((lambda (x) (+ 1 x)) (+ 2 3)))
        '(((lambda () (+ 1 ((lambda(x) x) (+ 2 3))))))
        1))

    (it "for simple (id x) like expressions"
      (affirm-transform-optimise (list optimise/expression-fold)
        '(((lambda (x) x) 2))
        '(((lambda () 2)))
        1))

    (it "for complex (id x) like expressions"
      (affirm-transform-optimise (list optimise/expression-fold)
        '(((lambda (x) x) (lambda ())))
        '(((lambda () (lambda ()))))
        1))

    (it "unless it's a variadic (id x) like expressions"
      (affirm-transform-optimise (list optimise/expression-fold)
        '(((lambda (x) x) (+ 1 1))
          ((lambda (x) x) ((lambda () (+ 1 1)))))
        '(((lambda (x) x) (+ 1 1))
          ((lambda (x) x) ((lambda () (+ 1 1)))))
        0))

    (it "for nested expressions"
      (affirm-transform-optimise (list optimise/expression-fold)
        '((lambda (x)
            ((lambda (key)
               ((lambda (val)
                  (foo key val))
                 (bar x)))
              (bar (+ x 1)))))
        '((lambda (x)
            ((lambda ()
               ((lambda ()
                  (foo (bar (+ x 1)) ((lambda (val) val) (bar x)))))))))
        2))

    (it "unless variables are used multiple times"
      (affirm-transform-optimise (list optimise/expression-fold)
        '(((lambda (x) (foo x x)) (+ 1 1)))
        '(((lambda (x) (foo x x)) (+ 1 1)))
        0))

    (it "unless variables are used out of order"
      (affirm-transform-optimise (list optimise/expression-fold)
        '(((lambda (x y) (foo y x)) (+ 1 1) (+ 1 1)))
        '(((lambda (x y) (foo y x)) (+ 1 1) (+ 1 1)))
        0))

    (it "when a variable is mutated after"
      (affirm-transform-optimise (list optimise/expression-fold)
        '(((lambda (tmp)
             ((lambda (x)
                (+ x 1)
                (set! tmp 2))
              (+ 2 3)))
           2))
        '(((lambda (tmp)
             ((lambda ()
                (+ (+ 2 3) 1)
                (set! tmp 2))))
           2))
        1))

    (it "unless a variable is mutated before"
      (affirm-transform-optimise (list optimise/expression-fold)
        '(((lambda (tmp)
             ((lambda (x)
                (set! tmp 2)
                (+ x 1))
              (+ 2 3)))
           2))
        '(((lambda (tmp)
             ((lambda (x)
                (set! tmp 2)
                (+ x 1))
              (+ 2 3)))
           2))
        0))

    (it "when a mutable variable is used after"
      (affirm-transform-optimise (list optimise/expression-fold)
        '(((lambda (tmp)
             (set! tmp 2)
             ((lambda (x)
                (+ x tmp 1))
              (+ 2 3)))
           2))
        '(((lambda (tmp)
             (set! tmp 2)
             ((lambda ()
                (+ (+ 2 3) tmp 1))))
           2))
        1))

    (it "unless a mutable variable is used before"
      (affirm-transform-optimise (list optimise/expression-fold)
        '(((lambda (tmp)
             (set! tmp 2)
             ((lambda (x)
                (+ tmp x 1))
              (+ 2 3)))
           2))
        '(((lambda (tmp)
             (set! tmp 2)
             ((lambda (x)
                (+ tmp x 1))
              (+ 2 3)))
           2))
        0))

    (it "when there is potential for mutation after"
      (affirm-transform-optimise (list optimise/expression-fold)
        '(((lambda (tmp)
             ((lambda (x) (+ x 1 (tmp)))
              (+ 2 3)))
           2))
        '(((lambda (tmp)
             ((lambda () (+ (+ 2 3) 1 (tmp)))))
           2))
        1))

    (it "unless there is potential for mutation before"
      (affirm-transform-optimise (list optimise/expression-fold)
        '(((lambda (tmp)
             ((lambda (x) (+ (tmp) x 1))
              (+ 2 3)))
           2))
        '(((lambda (tmp)
             ((lambda (x) (+ (tmp) x 1))
              (+ 2 3)))
           2))
        0)))

  (section "we will simplify conds with known truthy/falsey values"
    (it "in the simple case"
      (affirm-usage-optimise optimise/cond-eliminate
        '((cond
            [(cond [foo foo] [true foo]) true]))
        '((cond
            [(cond [foo true] [true false]) true]))
        2))
    (it "inside the test"
      (affirm-usage-optimise optimise/cond-eliminate
        '((cond
            [(cond [foo foo] [foo foo]) true]))
        '((cond
            [(cond [foo true] [false false]) true]))
        3))
    (it "unless the value is mutable"
      (affirm-usage-optimise optimise/cond-eliminate
        '(((lambda (x) (set! x 0)
             ((cond
                [(cond [x x] [true x]) true])))))
        '(((lambda (x) (set! x 0)
             ((cond
                [(cond [x x] [true x]) true])))))
        0)))

  (section "will push values down"
    (it "when they are lambdas used once in a call"
      (affirm-transform-optimise (list optimise/lower-value)
        '(((lambda (x)
             (x 1))
            (lambda (y) (+ y 1))))
        '(((lambda ()
             ((lambda (y) (+ y 1)) 1))))
        1))

    (it "unless they are used multiple times"
      (affirm-transform-optimise (list optimise/lower-value)
        '(((lambda (x)
             (x 1) x)
            (lambda (y) (+ y 1))))
        '(((lambda (x)
             (x 1) x)
            (lambda (y) (+ y 1))))
        0))

    (it "will push lambdas inside conditions"
      (affirm-transform-optimise (list optimise/lower-value)
        '(((lambda (x)
             (cond
               [1 1]
               [2 (x x)]))
            (lambda (y) (+ y 1))))
        '(((lambda ()
             (cond
               [1 1]
               [2 ((lambda (x)
                     (x x))
                    (lambda (y) (+ y 1)))]))))
        1))


    (it "will push values into conditions through bindings"
      (affirm-transform-optimise (list optimise/lower-value)
        '(((lambda (x)
             (cond
               [1 1]
               [2 ((lambda (z) (z x x)) 1)]))
            { :x 1 :y + }))
        '(((lambda ()
             (cond
               [1 1]
               [2 ((lambda (x)
                     ((lambda (z) (z x x)) 1))
                    { :x 1 :y + })]))))
        1))

    (it "unless they are used in multiple branches"
      (affirm-transform-optimise (list optimise/lower-value)
        '(((lambda (x)
             (cond
               [1 x]
               [2 (x x)]))
            { :x 1 :y + }))
        '(((lambda (x)
             (cond
               [1 x]
               [2 (x x)]))
            { :x 1 :y + }))
        0))

    (it "unless they are not deferrable"
      (affirm-transform-optimise (list optimise/lower-value)
        '(((lambda (a)
             (set! a 2)

             ((lambda (x)
                (cond
                  [1 1]
                  [2 (x x)]))
               { :x a }))))
        '(((lambda (a)
             (set! a 2)

             ((lambda (x)
                (cond
                  [1 1]
                  [2 (x x)]))
               { :x a }))))
        0))))
