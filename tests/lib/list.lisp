(import extra/test ())
(import extra/assert ())

(describe "A quoted list"
  (it "has a constant length"
      (assert (= (# '()) 0)
              (= (# '(foo)) 1)
              (= (# '(foo "foo" 2)) 3)
              (= (cadr '(foo "foo")) "foo")))
  (it "compares equal to itself"
      (assert (= '(1 2 3) '(1 2 3))
              (= '(1 2) '(1 2))))
  (it "has a congruent operation cdr"
      (assert (= '(b c d) (cdr '(a b c d)))
              (= (cdr '(a b c)) (cdr '(a b c)))))
  (it "has a congruent operation car"
      (assert (= 'a (car '(a)))
              (= (cdr '(1 2 3)) (cdr '(1 2 3)))))
  (it "can be extended by cons"
      (assert (= (cons 1 '(2 3)) '(1 2 3))
              (= (cons "foo" '(bar baz)) '("foo" bar baz))))
  (it "can be reduced to a single value with foldr"
      (assert (= (foldr + 0 '(1 2 3)) (+ (+ 1 2) (+ 3 0)))
              (= (foldr append '() '((1 2) (3 4))) '(1 2 3 4))))
  (it "can be appended to another quoted list"
      (assert (= (append '(1 2) '(3 4)) '(1 2 3 4))
              (= (# (append '(1 2) '(3 4))) (# '(1 2 3 4)))))
)
