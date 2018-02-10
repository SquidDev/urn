(import test ())
(import io/term ())

(import urn/resolve/loop resolve)
(import urn/backend/lua lua)
(import urn/error (compiler-error?))

(import tests/compiler/compiler-helpers ())

(defun resolve (nodes)
  (let* [(compiler (create-compiler))
         (logger (tracking-logger))
         (compile-state (lua/create-state (.> compiler :lib-meta)))]
    (.<! compiler :log logger)
    (.<! compiler :compile-state compile-state)

    (with ((ok err) (pcall resolve/compile
                      compiler
                      (wrap-node nodes)
                      (.> compiler :root-scope)
                      "init.lisp"))

      (cond
        [ok false]
        [(compiler-error? err) (.> logger :errors)]
        [else err]))))

(describe "The resolver will error"
  (section "on malformed"
    (it "definitions"
      (affirm (eq? '("Expected name, got nothing") (resolve '((define))))
              (eq? '("Expected name, got number")  (resolve '((define 2))))
              (eq? '("Expected value, got nothing")  (resolve '((define x))))))

    (it "lambdas"
      (affirm (eq? '("Expected argument list, got nothing") (resolve '((lambda))))
              (eq? '("Expected argument list, got symbol")  (resolve '((lambda x))))
              (eq? '("Expected argument, got number")       (resolve '((lambda (2)))))
              (eq? '("Cannot have multiple variadic arguments") (resolve '((lambda (&x &y)))))
              (eq? '("Expected a symbol for variadic argument.\nDid you mean '&x'?") (resolve '((lambda (& x)))))))

    (it "set!s"
      (affirm (eq? '("Expected symbol, got nothing") (resolve '((set!))))
              (eq? '("Expected symbol, got number")  (resolve '((set! 2))))
              (eq? '("Expected value, got nothing")  (resolve '((set! x))))
              (eq? '("Unexpected node in 'set!' (expected 3 values, got 4)") (resolve '((set! x 2 3))))
              (eq? '("Cannot rebind immutable definition 'x'") (resolve '((define x 1) (set! x 2))))))

    (it "struct-literals"
      (affirm (eq? '("Expected an even number of arguments, got 3") (resolve '({ a b c }))))))

  (section "on missing variables"
    (it "with simple errors"
      (affirm (eq? '("Cannot find variable 'x'") (resolve '((x))))))
    (it "with a single candidate"
      (affirm (eq? (list (format nil "Cannot find variable 'xyy'\nDid you mean '{}'?"
                                     (coloured "1;32" "xyz")))
                   (resolve '((define xyz 1) (xyy)))))))

  (section "on looping macros"
    (it "which are recursive"
      (affirm (eq? '("Loop in macros x -> x\nx used in x") (resolve '((define-macro x (lambda () (x))))))))
    (it "which are mutually recursive"
      (affirm (eq? '("Loop in macros y -> x -> y\nx used in y\ny used in x")
                   (resolve '((define-macro x (lambda () (y)))
                              (define-macro y (lambda () (x))))))))
    (it "which depend on functions"
      (affirm (eq? '("Loop in macros x -> y -> x\ny used in x\nx used in y")
                   (resolve '((define-macro x (lambda () (y)))
                              (define y (lambda () (x)))))))))
  )
