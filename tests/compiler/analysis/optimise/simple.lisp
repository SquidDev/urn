(import test ())
(import tests/compiler/analysis/optimise/optimise-helpers ())

(import urn/analysis/optimise/simple optimise)

(describe "The optimiser"
  (section "will remove pointless expressions"
    (it "on the top level"
      (affirm-transform-optimise (list optimise/strip-pure)
        '(2 "hello" :foo foo (lambda ()) 4)
        '(4)
        5))
    (it "in nested lambdas"
      (affirm-transform-optimise (list optimise/strip-pure)
        '((lambda () 4 5))
        '((lambda() 5))
        1)))

  (section "will fold constants"
    (it "of pure functions"
      (affirm-transform-optimise (list optimise/constant-fold)
        '((+ 2 3) (- 2 3) (.. "foo" "bar"))
        '(5 -1 "foobar")
        3))
    (it "unless the call is invalid"
      (affirm-transform-optimise (list optimise/constant-fold)
        '((+ 0.1 0.2) (+ 23 "ab"))
        '((+ 0.1 0.2) (+ 23 "ab"))
        0)))

  (section "will simplify conds"
    (it "removing false branches"
      (affirm-transform-optimise (list optimise/cond-fold)
        '((cond [false 23] [foo "foo"] [true "true"]))
        '((cond [foo "foo"] [true "true"]))
        1))
    (it "removing branches after true ones"
      (affirm-transform-optimise (list optimise/cond-fold)
        '((cond [foo "foo"] [true "true"] [bar "bar"]))
        '((cond [foo "foo"] [true "true"]))
        1))
    (it "removing pointless conds"
      (affirm-transform-optimise (list optimise/cond-fold)
        '((cond [true "true"])
          (cond [true 1 2]))
        '("true"
          ((lambda () 1 2)))
        2))
    (it "merging trailing conds"
      (affirm-transform-optimise (list optimise/cond-fold)
        '((cond
            [foo 1]
            [true
             (cond
               [bar 2]
               [true 3])]))
        '((cond
            [foo 1]
            [bar 2]
            [true 3]))
        1)))

  (section "will simplify lambdas"
    (it "removing pointless progns with a single element"
      (affirm-transform-optimise (list optimise/progn-fold-expr)
        '((foo ((lambda () 2)))
          (foo ((lambda () 2 3))) ;; Contains multiple elements
          (foo ((lambda (x) 2)))  ;; Has an argument
          (foo ((lambda () 2) 3))) ;; Called with an argument
        '((foo 2)
          (foo ((lambda () 2 3)))
          (foo ((lambda (x) 2)))
          (foo ((lambda () 2) 3)))
        1))

    (it "removing pointless progns with multiple elements"
      (affirm-transform-optimise (list optimise/progn-fold-block)
        '(((lambda () 2 3))
          ((lambda () ((lambda () 2 3)) 4)) ;; Will hamdle recursive elements
          ((lambda (x) 2 3))   ;; Has an argument
          ((lambda () 2 3) 4)) ;; Called with an argument
        '(2 3
          2 3 4
          ((lambda (x) 2 3))
          ((lambda () 2 3) 4)) ;; TODO: Could inline this to be 4 2 3
        3))

    (it "removing pointless value wrappers"
      (affirm-transform-optimise (list optimise/wrap-value-flatten)
        '((foo ((lambda (x) x) (bar)))
          (foo ((lambda (x) x) (bar)) 1)
          (foo ((lambda (&x) x) (bar)) 1)
          (((lambda (x) x) (bar))))
        '((foo ((lambda (x) x) (bar)))
          (foo (bar) 1)
          (foo ((lambda (&x) x) (bar)) 1)
          ((bar)))
        2))

    (it "folding let* bindings into lets"
      (affirm-transform-optimise (list optimise/lambda-fold)
        '(((lambda (x)
             ((lambda (y) (+ x y)) 3)) 2))
        '(((lambda (x y) (+ x y)) 2 3))
        1)
      ;; Bindings which rely on previous ones
      (affirm-transform-optimise (list optimise/lambda-fold)
        '(((lambda (x)
             ((lambda (y) (+ x y)) (+ x 1))) 2))
        '(((lambda (x)
             ((lambda (y) (+ x y)) (+ x 1))) 2))
        0)
      ;; Bindings which are missing
      (affirm-transform-optimise (list optimise/lambda-fold)
        '(((lambda (x)
             ((lambda (y) (+ x y)))) 2)
          ((lambda (x)
             ((lambda (y) (+ x y)) 3))))

        '(((lambda (x y) (+ x y)) 2)
          ((lambda (x)
             ((lambda (y) (+ x y)) 3))))
        1))

    (it "folding letrec bindings into lets"
      ;; Without nil args
      (affirm-transform-optimise (list optimise/lambda-fold)
        '(((lambda (x y)
             (set! x 1)
             (set! y (lambda ()))
             (foo x y))))
        '(((lambda (x y)
             (foo x y))
            1 (lambda ())))
        2)

      ;; With nil args
      (affirm-transform-optimise (list optimise/lambda-fold)
        '(((lambda (x y)
             (set! x 1)
             (set! y (lambda ()))
             (foo x y)) nil nil))
        '(((lambda (x y)
             (foo x y))
            1 (lambda ())))
        2)

      ;; Bindings which rely on previous ones
      ;; TODO: compile this into a let* if possible
      (affirm-transform-optimise (list optimise/lambda-fold)
        '(((lambda (x y)
             (set! x 1)
             (set! y x))))
        '(((lambda (x y)
             (set! y x))
            1))
        1))))
