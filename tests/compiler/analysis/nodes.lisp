(import test ())

(import urn/analysis/nodes ())
(import urn/resolve/scope scope)

(defun affirm-zip (args vals exp)
  (with (scope (scope/child))
    ;; Add variables for each argument
    (for-each arg args
      (with (var (scope/add! scope (symbol->string arg) "arg" arg))
        (scope/set-var-variadic! var (string/starts-with? (symbol->string arg) "&"))
        (.<! arg :var var))))

  ;; Add variables for each value
  (loop [(val vals)] []
    (case (type val)
      ["symbol" (.<! val :var (scope/temp-var))]
      ["list" (for-each elem val (recur elem))]
      [_]))

  (affirm (eq? (zip-args args 1 vals 1) exp)))

(describe "The compiler can operate on nodes"
  (section "can zip directly called lambdas"
    (it "with no arguments"
      (affirm-zip '() '() '())
      (affirm-zip '() '(1 2 3) '((() (1)) (() (2)) (() (3))))
      (affirm-zip '() '(1 2 (foo)) '((() (1)) (() (2)) (() ((foo))))))

    (it "with no values"
      (affirm-zip '(a) '() '(((a) ())))
      (affirm-zip '(&a) '() '(((&a) ()))))

    (it "with the perfect number of arguments"
      (affirm-zip '(a b c) '(1 2 3) '(((a) (1)) ((b) (2)) ((c) (3))))
      (affirm-zip '(&a b c) '(1 2 3) '(((&a) (1)) ((b) (2)) ((c) (3))))
      (affirm-zip '(&a b c) '(1 2 3 4) '(((&a) (1 2)) ((b) (3)) ((c) (4)))))

    (it "with extra arguments"
      (affirm-zip '(a b c) '(1) '(((a) (1)) ((b) ()) ((c) ())))
      (affirm-zip '(a b c) '(1 (foo)) '(((a) (1)) ((b c) ((foo)))))
      (affirm-zip '(a b c) '((foo)) '(((a b c) ((foo)))))

      (affirm-zip '(&a b c) '(1) '(((&a) ()) ((b) (1)) ((c) ())))
      (affirm-zip '(&a b c) '(1 2) '(((&a) ()) ((b) (1)) ((c) (2))))
      (affirm-zip '(&a b c) '((foo)) '(((&a b c) ((foo)))))

      (affirm-zip '(a b &c) '(1) '(((a) (1)) ((b) ()) ((&c) ())))
      (affirm-zip '(a b &c) '((foo)) '(((a b &c) ((foo))))))

    (it "with extra values"
      (affirm-zip '(a) '(1 2 3) '(((a) (1)) (() (2)) (() (3))))
      (affirm-zip '(a) '(1 2 (foo)) '(((a) (1)) (() (2)) (() ((foo)))))

      (affirm-zip '(&a) '(1 2 3) '(((&a) (1 2 3))))
      (affirm-zip '(&a) '(1 2 (foo)) '(((&a) (1 2 (foo))))))


))
