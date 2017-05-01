(import extra/test ())
(import extra/assert ())
(import lua/basic (pcall))

(describe "The matcher"
  (it "can match for a specified amount of list values"
    (affirm (eq? 2 (destructuring-bind [[?x ?y] '(1 2)] y))
            (eq? false (pcall (lambda () (destructuring-bind [[?x ?y] '(1 2 3)] y)))))))
