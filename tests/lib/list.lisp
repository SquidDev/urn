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
      (affirm (eq? (cons 1 '(2 3)) '(1 2 3))
              (eq? (cons "foo" '(bar baz)) '("foo" bar baz))
              (eq? (cons "foo" (list 1 nil 2)) (list "foo" 1 nil 2))))
  (it "can be extended by snoc"
      (assert (= (snoc '(1 2) 3) '(1 2 3))
              (= (snoc '(bar baz) "foo") '(bar baz "foo"))
              (= (snoc (list 1 nil 2) "foo") (list 1 nil 2 "foo"))))
  (it "can be reduced to a single value with foldr"
      (assert (= (foldr + 0 '(1 2 3)) (+ (+ 1 2) (+ 3 0)))
              (= (foldr append '() '((1 2) (3 4))) '(1 2 3 4))))
  (it "can be appended to another quoted list"
      (assert (= (append '(1 2) '(3 4)) '(1 2 3 4))
              (= (# (append '(1 2) '(3 4))) (# '(1 2 3 4)))))
  (it "can be mapped over"
      (assert (= (map (cut + <> 1) '(0 1 2)) '(1 2 3))
              (= (map (const 1) '(1 2 3)) '(1 1 1))))
  (it "remains the same when mapped over with id"
      (assert (= (map id '(1 2 3)) '(1 2 3))
              (= (traverse '(1 2 3) id) '(1 2 3))))
  (it "has two equivalent operations: map and traverse"
      (assert (= (map (cut + <> 1) '(1 2 3))
                 (traverse '(1 2 3) (cut + <> 1)))))
  (it "can be checked for the presence of an element"
      (assert (= true (elem? 1 '(1 2 3)))
              (= true (elem? 2 '(1 2 3)))
              (= false (elem? 1 '(2 3 4)))))
  (it "can be built using range"
      (assert (= (range 1 3) '(1 2 3))))
  (it "has a cancellative operation reverse"
      (assert (= (reverse (reverse '(1 2 3))) '(1 2 3))
              (= (reverse '(3 2 1)) '(1 2 3))))
  (it "can be tested for one element matching a predicate"
      (assert (= true (any (cut = <> 1) (range 1 3)))
              (= false (any (cut = <> 6) (range 1 3)))))
  (it "can be tested for all elements matching a predicate"
      (assert (= true (all (cut = <> 1) '(1 1 1)))
              (= false (all (cut = <> 1) (range 1 3)))))
  (it "can be pruned to remove empty elements"
      (assert (= '(1 2 3) (prune '(1 () 2 () 3)))))
  (it "can be flattened"
      (assert (= '(1 2 3 4) (flatten '((1 2) (3 4))))))
  (it "can be indexed in constant time"
      (assert (= (nth '(1 2 3) 1) 1)))
  (it "has a last element"
      (assert (= (last '(1 2 3)) 3)
              (= (last '()) nil)
              (= (last (list 1 2 nil)) nil)))
  (it "can be zipped over"
      (assert (= (zip list '(1 foo "baz") '(2 bar "qux")) '((1 2) (foo bar) ("baz" "qux")))
              (= (zip + '(1 2 3) '(3 7 9)) '(4 9 12))))
  (it "exists"
      (assert (= true (exists? '(1 2 3)))
              (= true (exists? (range 1 3)))
              (= true (exists? (cons 1 '())))))
)
