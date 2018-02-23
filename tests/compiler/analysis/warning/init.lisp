(import test ())

(import urn/analysis/warning warn)

(import tests/compiler/analysis/warning/warning-helpers ())

(describe "The compiler will warn"
  (section "when calling a function with too many values"
    (it "for a known number of arguments"
      ;; Calling with correct number
      (affirm-usage-warn warn/check-arity
        '((define x (lambda (a b)))
          (x 1 2))
        '())

      ;; Calling with too many
      (affirm-usage-warn warn/check-arity
        '((define x (lambda (a b)))
          (x 1 2 3)
          (x 1 2 (x 1 2)))
        '("Calling x with 3 arguments, expected at most 2
           Called here"
          "Calling x with 3 arguments, expected at most 2
           Called here")))

    (it "indirectly"
      (affirm-usage-warn warn/check-arity
        '((define x (lambda (a b)))
          (define y x)
          (y 1 2 3))
        '("Calling y with 3 arguments, expected at most 2
           Called here")))

    (it "on native definitions"
      (affirm-usage-warn warn/check-arity
        '((get-idx 1)
          (get-idx 1 2 3))
        '("Calling get-idx with 1 arguments, expected at least 2
           Called here"
          "Calling get-idx with 3 arguments, expected at most 2
           Called here")))

    (it "unless the function is variadic"
      (affirm-usage-warn warn/check-arity
        '((define x (lambda (a &b)))
          (x 1 2 3))
        '())))

  (section "when using a deprecated symbol"
    (it "directly"
      (affirm-usage-warn warn/deprecated
        '((define x :deprecated 1)
          (define y :deprecated "Don't use" 1)
          x y)
        '("x is deprecated."
          "y is deprecated: Don't use")))

    (it "except in recursive functions"
      (affirm-usage-warn warn/deprecated
        '((define x :deprecated (lambda () x)))
        '())))

  (section "on invalid references"
    (it "in docstrings"
      (affirm-warn warn/documentation
        '((define x "References [[x]] and [[y]]" 1))
        '("\"y\" is not defined.
           Referenced in docstring.")))

    (it "in deprecation strings"
      (affirm-warn warn/documentation
        '((define x :deprecated "References [[x]] and [[y]]" 1))
        '("\"y\" is not defined.
           Referenced in deprecation message."))))

  (section "on unused"
    (it "top-level hidden definitions"
      (affirm-usage-warn warn/unused-vars
        '((define x 1)
           (define y :hidden 2)
           (define z :hidden 2) z)
        '("\"y\" is not used.
           Defined here")))

    (it "recursive definitions"
      (affirm-usage-warn warn/unused-vars
        '((define y :hidden (lambda () (y))))
        '("\"y\" is not used.
           Defined here")))

    (it "arguments"
      (affirm-usage-warn warn/unused-vars
        '((lambda (x y) (x 1)))
        '("\"y\" is not used.
           Defined here"))))

  (section "on using macros"
    (it "as raw symbols"
      (affirm-warn warn/macro-usage
        '((define-macro x 1)
          (define y (lambda () x)))
        '("The macro \"x\" is not expanded
           macro used here")))

    (pending "except in aliases"
      (affirm-warn warn/macro-usage
        '((define-macro x 1)
          (define-macro y x))
        '())))

  (it "on pointless mutable definitions"
    (affirm-usage-warn warn/mutable-definitions
      '((define x :mutable :hidden 1)
        (define y :mutable :hidden 1) (set! y 2)
        (define z :mutable 1))
      '("\"x\" is never mutated
         variable defined here")))
  )
