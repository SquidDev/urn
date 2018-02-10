(import test ())

(import urn/analysis/warning/order warn)

(import tests/compiler/analysis/warning/warning-helpers ())

(describe "The compiler will warn on out-of-order access"
  (it "for the simple case"
    (affirm-warn warn/check-order
      '((define y x)
        (define x 1))
      '("x has not been defined yet")))

  (pending "for mutations"
    (affirm-warn warn/check-order
      '((set! x y)
        (define x :mutable 1)
        (define y 1))
      '("x has not been defined yet"
        "y has not been defined yet")))

  (it "through quote misdirection"
    (affirm-warn warn/check-order
      '((define y `,x)
        (define x 1))
      '("x has not been defined yet")))

  (it "through lambda misdirection"
    (affirm-warn warn/check-order
      '((define y ((lambda () x)))
        (define x 1))
      '("x has not been defined yet")))

  (it "unless accessed through a lambda"
    (affirm-warn warn/check-order
      '((define y (lambda () x))
        (define x 1))
      '()))

  )
