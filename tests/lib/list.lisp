(import extra/test ())
(import extra/assert ())
(import extra/check ())

(describe "A quoted list"
  (it "has a constant length"
      (affirm (eq? (# '()) 0)
              (eq? (# '(foo)) 1)
              (eq? (# '(foo "foo" 2)) 3)
              (eq? (cadr '(foo "foo")) "foo")))
  (it "compares equal to itself"
      (check [(list a)]
        (eq? a a)))
  (it "has a congruent operation cdr"
      (check [(list a)]
        (eq? (drop a 1) (cdr a))))
  (it "has a congruent operation car"
      (check [(list a)]
        (eq? (car a) (nth a 1))))
  (it "can be extended by cons"
      (check [(list a) (any b)]
        (eq? (cons b a) `(,b ,@a))))
  (it "can be extended by snoc"
      (affirm (eq? (snoc '(1 2) 3) '(1 2 3))
              (eq? (snoc '(bar baz) "foo") '(bar baz "foo"))
              (eq? (snoc (list 1 nil 2) "foo") (list 1 nil 2 "foo"))))
  (it "can be reduced to a single value with foldr"
      (affirm (eq? (foldr + 0 '(1 2 3)) (+ (+ 1 2) (+ 3 0)))
              (eq? (foldr append '() '((1 2) (3 4))) '(1 2 3 4))))
  (it "can be appended to another quoted list"
      (check [(list a) (list b)]
        (eq? (# (append a b)) (+ (# a) (# b)))
        (eq? (append a b) (reverse (append (reverse b) (reverse a))))))
  (it "can be mapped over"
      (check [(list a)]
        (eq? (map id a) a)
        (eq? (# (map id a)) (# a))))
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
      (check [(list a)]
        (eq? (reverse (reverse a)) a)))
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
      (affirm (eq? (nth '(1 2 3) 1) 1)
              (eq? (get-idx '(1 2 3) 1) 1)))
  (it "has a last element"
      (affirm (eq? (last '(1 2 3)) 3)
              (eq? (last '()) nil)
              (eq? (last (list 1 2 nil)) nil)))
  (it "can be zipped over"
      (affirm (eq? (map list '(1 foo "baz") '(2 bar "qux")) '((1 2) (foo bar) ("baz" "qux")))
              (eq? (map + '(1 2 3) '(3 7 9)) '(4 9 12))))
  (it "exists"
      (check [(list a)] (exists? a)))
  (it "can be accumulated with a monoid"
      (affirm (eq? 10 (accumulate-with tonumber + 0 '(1 2 3 4)))))
  (it "can have an item mutated in-place"
      (affirm (eq? '(1 3) (with (l '(1 2)) (set-idx! l 2 3) l))))
)
