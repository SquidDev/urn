(import test ())
(import io/term ())

(import urn/resolve/loop resolve)
(import urn/backend/lua lua)
(import urn/error (compiler-error?))

(import tests/compiler/compiler-helpers ())

(defun resolve (nodes)
  (let* [(compiler (create-compiler))
         (logger (tracking-logger))
         (compile-state (lua/create-state))]
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

  (section "on malformed metadata"
    (it "with docstrings"
      (affirm (eq? '("Multiple doc strings in definition")
                   (resolve '((define x "Foo" "Bar" 1))))))
    (it "with :deprecated"
      (affirm (eq? '("This definition is already deprecated")
                   (resolve '((define x :deprecated :deprecated 1))))))
    (it "with :mutable"
      (affirm (eq? '("This definition is already mutable")
                   (resolve '((define x :mutable :mutable 1))))
              (eq? '("Can only set conventional definitions as mutable")
                   (resolve '((define-macro x :mutable 1))))
              (eq? '("Can only set conventional definitions as mutable")
                   (resolve '((define-native x :mutable))))))
    (section "with native definitions"
      (it "using :pure"
        (affirm (eq? '("Can only set native definitions as pure")
                     (resolve '((define x :pure 1))))
                (eq? '("This definition is already pure")
                     (resolve '((define-native x :pure :pure))))))
      (it "using :bind-to"
        (affirm (eq? '("Can only bind native definitions")
                     (resolve '((define x :bind-to 1))))
                (eq? '("Expected bind expression, got nothing")
                     (resolve '((define-native y :bind-to))))
                (eq? '("Multiple bind expressions set")
                     (resolve '((define-native z :bind-to "z" :bind-to "z"))))))
      (it "using :syntax"
        (affirm (eq? '("Can only set syntax for native definitions")
                     (resolve '((define x :syntax 1))))
                (eq? '("Expected syntax, got nothing")
                     (resolve '((define-native x :syntax))))
                (eq? '("Expected syntax, got key")
                     (resolve '((define-native x :syntax :something))))
                (eq? '("Expected syntax element, got key")
                     (resolve '((define-native x :syntax (:foo)))))
                (eq? '("Multiple syntaxes set")
                     (resolve '((define-native x :syntax "" :syntax ""))))
                (eq? '("Cannot specify :syntax and :bind-to in native definition")
                     (resolve '((define-native x :syntax "" :bind-to ""))))))
      (it "using :syntax-stmt"
        (affirm (eq? '("Can only set native definitions as statements")
                     (resolve '((define x :stmt 1))))
                (eq? '("This definition is already a statement")
                     (resolve '((define-native x :stmt :stmt))))
                (eq? '("Cannot have a statement when no syntax given")
                     (resolve '((define-native x :stmt))))))
      (it "using :syntax-fold"
        (affirm (eq? '("Can only set syntax of native definitions")
                     (resolve '((define x :syntax-fold 1))))
                (eq? '("Multiple fold directions set")
                     (resolve '((define-native x :syntax-fold "left" :syntax-fold "left"))))
                (eq? '("Expected fold direction, got nothing")
                     (resolve '((define-native x :syntax-fold))))
                (eq? '("Unknown fold direction \"Left\"")
                     (resolve '((define-native x :syntax-fold "Left"))))
                (eq? '("Cannot specify a fold direction when no syntax given")
                     (resolve '((define-native x :syntax-fold "left"))))
                (eq? '("Cannot specify a fold direction with arity 1 (must be 2)")
                     (resolve '((define-native x :syntax "${1}" :syntax-fold "left"))))))
      (it "using :syntax-precedence"
        (affirm (eq? '("Can only set syntax of native definitions")
                     (resolve '((define x :syntax-precedence e1))))
                (eq? '("Multiple precedences set")
                     (resolve '((define-native x :syntax-precedence 0 :syntax-precedence 0))))
                (eq? '("Expected precedence, got nothing")
                     (resolve '((define-native x :syntax-precedence))))
                (eq? '("Expected precedence, got key")
                     (resolve '((define-native x :syntax-precedence (:key)))))
                (eq? '("Cannot specify a precedence when no syntax given")
                     (resolve '((define-native x :syntax-precedence 0))))
                (eq? '("Cannot specify a precedence when no syntax given")
                     (resolve '((define-native x :syntax-precedence 0))))
                (eq? '("Definition has arity 1, but precedence has 2 values")
                     (resolve '((define-native x :syntax "${1}" :syntax-precedence (1 2)))))))


      ))

  )
