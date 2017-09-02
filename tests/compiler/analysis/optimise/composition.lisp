(import test ())
(import tests/compiler/analysis/optimise/optimise-helpers ())

(import urn/analysis/optimise/simple optimise)
(import urn/analysis/optimise/usage optimise)

(describe "The optimiser"
  (it "has a lambda folder and expression folder which work together"
    (affirm-transform-optimise (list optimise/expression-fold optimise/progn-fold-expr)
      '((lambda (x)
          ((lambda (key)
             ((lambda (val)
                (foo key val))
               (bar x)))
            (bar (+ x 1)))))
      '((lambda (x)
          (foo (bar (+ x 1)) ((lambda (val) val) (bar x)))))
      4))

  (it "has a variable folder and argument stripper which work well together"
    (affirm-transform-optimise (list optimise/variable-fold optimise/strip-args)
      '(((lambda (x) x) 2))
      '(((lambda () 2)))
      2))

  (section "has a variable folder and constant folder which work well together"
    (it "on definitions"
      (affirm-transform-optimise (list optimise/constant-fold optimise/variable-fold)
        '((define a 1)
          (define b (+ a 1))
          (define c (+ b 1)))
        '((define a 1)
          (define b 2)
          (define c 3))
        4))

    (it "on binds"
      (affirm-transform-optimise (list optimise/constant-fold optimise/variable-fold)
        '(((lambda (a)
             ((lambda (b)
                ((lambda (c) c) (+ b 1)))
               (+ a 1)))
            1))
        '(((lambda (a)
             ((lambda (b)
                ((lambda (c) 3) 3))
               2))
            1))
        5))))
