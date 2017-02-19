(import extra/test ())
(import extra/assert ())

(describe "List tests"
  (it "quoted lists"
    (assert (= (# '()) 0))
    (assert (= (# '(foo)) 1))
    (assert (= (# '(foo "foo" 2)) 3))
    (assert (= (cadr '(foo "foo")) "foo")))
)
