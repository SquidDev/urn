(import test ())

(describe "A quoted list"
  (it "has a constant length"
      (affirm (eq? (n '()) 0)
              (eq? (n '(foo)) 1)
              (eq? (n '(foo "foo" 2)) 3)
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
  (it "can be reduced to a single value with reduce"
      (affirm (eq? (reduce + 0 '(1 2 3)) (+ (+ 1 2) (+ 3 0)))
              (eq? (reduce append '() '((1 2) (3 4))) '(1 2 3 4))))
  (it "can be appended to another quoted list"
      (check [(list a) (list b)]
        (eq? (n (append a b)) (+ (n a) (n b)))
        (eq? (append a b) (reverse (append (reverse b) (reverse a))))))
  (it "can be mapped over"
      (check [(list a)]
        (eq? (map id a) a)
        (eq? (n (map id a)) (n a))))
  (it "can be checked for the presence of an element"
      (affirm (eq? true (elem? 1 '(1 2 3)))
              (eq? true (elem? 2 '(1 2 3)))
              (eq? false (elem? 1 '(2 3 4)))))
  (it "can be built using range"
      (affirm (eq? (range :from 1 :to 3) '(1 2 3))))
  (it "has a cancellative operation reverse"
      (check [(list a)]
        (eq? (reverse (reverse a)) a)))
  (it "can be tested for one element matching a predicate"
      (affirm (eq? true (any (cut = <> 1) (range :from 1 :to 3)))
              (eq? false (any (cut = <> 6) (range :from 1 :to 3)))))
  (it "can be tested for all elements matching a predicate"
      (affirm (eq? true (all (cut = <> 1) '(1 1 1)))
              (eq? false (all (cut = <> 1) (range :from 1 :to 3)))))
  (it "can be pruned to remove empty elements"
      (affirm (eq? '(1 2 3) (prune '(1 () 2 () 3)))))
  (it "can be flattened"
      (affirm (eq? '(1 2 3 4) (flatten '((1 2) (3 4))))))
  (it "can be indexed in constant time"
      (affirm (eq? (nth '(1 2 3) 1) 1)
              (eq? (.> '(1 2 3) 1) 1)))
  (it "has a last element"
      (affirm (eq? (last '(1 2 3)) 3)
              (eq? (last '()) nil)
              (eq? (last (list 1 2 nil)) nil)))
  (it "can be zipped over"
      (affirm (eq? (map list '(1 foo "baz") '(2 bar "qux")) '((1 2) (foo bar) ("baz" "qux")))
              (eq? (map + '(1 2 3) '(3 7 9)) '(4 9 12))))
  (it "can be taken from while a condition is true"
      (affirm (eq? (take-while (lambda (x) (/= x 4)) '(1 2 3 4 5 6) 1) '(1 2 3))
              (eq? (take-while (lambda (x) (/= x 4)) '(1 2 3 4 5 6 4) 5) '(5 6))))
  (it "can be splitted"
      (affirm (eq? (split '(1 2 3 4) 3) '((1 2) (4)))
              (eq? (split '(a b c d e) 'b) '((a) (c d e)))))
  (it "exists"
      (check [(list a)] (exists? a)))
  (it "can be accumulated with a monoid"
      (affirm (eq? 10 (accumulate-with tonumber + 0 '(1 2 3 4)))))
  (it "can have an item mutated in-place"
      (affirm (eq? '(1 3) (with (l '(1 2)) (.<! l 2 3) l))))
  (it "is equal if all elements are equal"
      (check [(list a) (list b)]
        (=> (eq? a b)
            (reduce (lambda (x y) (and x y))
                   true
                   (map eq? a b)))))
  (it "can be indexed by c[ad]+ functions"
    (let* [(ctr 0)
           (tree (loop
                   [(depth 4)]
                   [(<= depth 0) (inc! ctr) ctr]
                   (list (recur (pred depth)) (recur (pred depth)) (recur (pred depth)))))]
      (affirm (eq? (caaaar tree) (car (car (car (car tree)))))
              (eq? (caaadr tree) (car (car (car (cdr tree)))))
              (eq? (caadar tree) (car (car (cdr (car tree)))))
              (eq? (caaddr tree) (car (car (cdr (cdr tree)))))
              (eq? (cadaar tree) (car (cdr (car (car tree)))))
              (eq? (cadadr tree) (car (cdr (car (cdr tree)))))
              (eq? (caddar tree) (car (cdr (cdr (car tree)))))
              (eq? (cadddr tree) (car (cdr (cdr (cdr tree)))))
              (eq? (cdaaar tree) (cdr (car (car (car tree)))))
              (eq? (cdaaar tree) (cdr (car (car (car tree)))))
              (eq? (cdaadr tree) (cdr (car (car (cdr tree)))))
              (eq? (cdadar tree) (cdr (car (cdr (car tree)))))
              (eq? (cdaddr tree) (cdr (car (cdr (cdr tree)))))
              (eq? (cddaar tree) (cdr (cdr (car (car tree)))))
              (eq? (cddadr tree) (cdr (cdr (car (cdr tree)))))
              (eq? (cdddar tree) (cdr (cdr (cdr (car tree)))))
              (eq? (cddddr tree) (cdr (cdr (cdr (cdr tree))))))))
)
