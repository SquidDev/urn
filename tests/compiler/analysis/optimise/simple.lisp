(import extra/test ())
(import tests/compiler/analysis/optimise/optimise-helpers ())

(import urn/analysis/optimise/simple optimise)

(describe "The optimiser"
  (section "will remove pointless expressions"
    (it "on the top level"
      (affirm-optimise optimise/strip-pure
        '(2 "hello" :foo foo (lambda ()) 4)
        '(4)
        5))
    (it "in nested lambdas"
      (affirm-optimise optimise/strip-pure
        '((lambda () 4 5))
        '((lambda() 5))
        1)))

  (section "will fold constants"
    (it "of pure functions"
      (affirm-optimise optimise/constant-fold
        '((+ 2 3) (- 2 3) (.. "foo" "bar"))
        '(5 -1 "foobar")
        3))
    (it "unless the call is invalid"
        '((+ 0.1 0.2) (+ 23 "ab"))
        '((+ 0.1 0.2) (+ 23 "ab"))
        0))

  (section "will simplify conds"
    (it "removing false branches"
      (affirm-optimise optimise/cond-fold
        '((cond [false 23] [foo "foo"] [true "true"]))
        '((cond [foo "foo"] [true "true"]))
        1))
    (it "removing branches after true ones"
      (affirm-optimise optimise/cond-fold
        '((cond [foo "foo"] [true "true"] [bar "bar"]))
        '((cond [foo "foo"] [true "true"]))
        1))
    (it "removing pointless conds"
      (affirm-optimise optimise/cond-fold
        '((cond [true "true"])
          (cond [true 1 2]))
        '("true"
          ((lambda () 1 2)))
        2)))

  (section "will simplify lambdas"
    (it "removing pointless progns with a single element"
      (affirm-optimise optimise/lambda-fold
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
      (affirm-optimise optimise/lambda-fold
        '(((lambda () 2 3))
          ((lambda () ((lambda () 2 3)) 4)) ;; Will hamdle recursive elements
          ((lambda (x) 2 3))   ;; Has an argument
          ((lambda () 2 3) 4)) ;; Called with an argument
        '(2 3
          2 3 4
          ((lambda (x) 2 3))
          ((lambda () 2 3) 4)) ;; TODO: Could inline this to be 4 2 3
        3))

    (it "folding let* bindings into lets"
      (affirm-optimise optimise/lambda-fold
        '(((lambda (x)
             ((lambda (y) (+ x y)) 3)) 2))
        '(((lambda (x y) (+ x y)) 2 3))
        1)
      ;; Bindings which rely on previous ones
      (affirm-optimise optimise/lambda-fold
        '(((lambda (x)
             ((lambda (y) (+ x y)) (+ x 1))) 2))
        '(((lambda (x)
             ((lambda (y) (+ x y)) (+ x 1))) 2))
        0)
      ;; Bindings which are missing
      (affirm-optimise optimise/lambda-fold
        '(((lambda (x)
             ((lambda (y) (+ x y)))) 2)
          ((lambda (x)
             ((lambda (y) (+ x y)) 3))))

        '(((lambda (x y) (+ x y)) 2)
          ((lambda (x)
             ((lambda (y) (+ x y)) 3))))
        1))))