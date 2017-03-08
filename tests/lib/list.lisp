(import extra/test ())
(import extra/assert ())

(describe "A quoted list"
  (it "has a constant length"
      (affirm (eq? (# '()) 0)
              (eq? (# '(foo)) 1)
              (eq? (# '(foo "foo" 2)) 3)
              (eq? (cadr '(foo "foo")) "foo")))
  (it "compares equal to itself"
      (affirm (eq? '(1 2 3) '(1 2 3))
              (eq? '(1 2) '(1 2))))
  (it "has a congruent operation cdr"
      (affirm (eq? '(b c d) (cdr '(a b c d)))
              (eq? (cdr '(a b c)) (cdr '(a b c)))))
  (it "has a congruent operation car"
      (affirm (eq? 'a (car '(a)))
              (eq? (cdr '(1 2 3)) (cdr '(1 2 3)))))
  (it "can be extended by cons"
      (affirm (eq? (cons 1 '(2 3)) '(1 2 3))
              (eq? (cons "foo" '(bar baz)) '("foo" bar baz))
              (eq? (cons "foo" (list 1 nil 2)) (list "foo" 1 nil 2))))
  (it "can be extended by snoc"
      (affirm (eq? (snoc '(1 2) 3) '(1 2 3))
              (eq? (snoc '(bar baz) "foo") '(bar baz "foo"))
              (eq? (snoc (list 1 nil 2) "foo") (list 1 nil 2 "foo"))))
  (it "can be reduced to a single value with foldr"
      (affirm (eq? (foldr + 0 '(1 2 3)) (+ (+ 1 2) (+ 3 0)))
              (eq? (foldr append '() '((1 2) (3 4))) '(1 2 3 4))))
  (it "can be appended to another quoted list"
      (affirm (eq? (append '(1 2) '(3 4)) '(1 2 3 4))
              (eq? (# (append '(1 2) '(3 4))) (# '(1 2 3 4)))))
  (it "can be mapped over"
      (affirm (eq? (map (cut + <> 1) '(0 1 2)) '(1 2 3))
              (eq? (map (const 1) '(1 2 3)) '(1 1 1))))
  (it "remains the same when mapped over with id"
      (affirm (eq? (map id '(1 2 3)) '(1 2 3))
              (eq? (traverse '(1 2 3) id) '(1 2 3))))
  (it "has two equivalent operations: map and traverse"
      (affirm (eq? (map (cut + <> 1) '(1 2 3))
                 (traverse '(1 2 3) (cut + <> 1)))))
  (it "can be checked for the presence of an element"
      (affirm (eq? true (elem? 1 '(1 2 3)))
              (eq? true (elem? 2 '(1 2 3)))
              (eq? false (elem? 1 '(2 3 4)))))
  (it "can be built using range"
      (affirm (eq? (range 1 3) '(1 2 3))))
  (it "has a cancellative operation reverse"
      (affirm (eq? (reverse (reverse '(1 2 3))) '(1 2 3))
              (eq? (reverse '(3 2 1)) '(1 2 3))))
  (it "can be tested for one element matching a predicate"
      (affirm (eq? true (any (cut = <> 1) (range 1 3)))
              (eq? false (any (cut = <> 6) (range 1 3)))))
  (it "can be tested for all elements matching a predicate"
      (affirm (eq? true (all (cut = <> 1) '(1 1 1)))
              (eq? false (all (cut = <> 1) (range 1 3)))))
  (it "can be pruned to remove empty elements"
      (affirm (eq? '(1 2 3) (prune '(1 () 2 () 3)))))
  (it "can be flattened"
      (affirm (eq? '(1 2 3 4) (flatten '((1 2) (3 4))))))
  (it "can be indexed in constant time"
      (affirm (eq? (nth '(1 2 3) 1) 1)))
  (it "has a last element"
      (affirm (eq? (last '(1 2 3)) 3)
              (eq? (last '()) nil)
              (eq? (last (list 1 2 nil)) nil)))
  (it "can be zipped over"
      (affirm (eq? (zip list '(1 foo "baz") '(2 bar "qux")) '((1 2) (foo bar) ("baz" "qux")))
              (eq? (zip + '(1 2 3) '(3 7 9)) '(4 9 12))))
  (it "exists"
      (affirm (eq? true (exists? '(1 2 3)))
              (eq? true (exists? (range 1 3)))
              (eq? true (exists? (cons 1 '())))))
  (it "can be accumulated with a monoid"
      (affirm (eq? 10 (accumulate-with tonumber + 0 '(1 2 3 4)))))
)
