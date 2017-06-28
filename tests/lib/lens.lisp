(import extra/test ())
(import extra/assert (affirm))

(describe "A lens"
  (it "focuses on the first element of a list"
    (affirm (getter? head)
            (eq? (^. '(1 2 3) head) 1)))
  (it "focuses on the remaining elements of a list"
    (affirm (getter? tail)
            (eq? (^. '(1 2 3) tail) '(2 3))))
  (it "focuses on a table element"
    (affirm (getter? (on :x))
            (eq? (^. { :foo 1 } (on :foo)) 1)))
  (it "focuses on a list index"
    (affirm (getter? (at 1))
            (eq? (^. '(1 2 3) (at 2)) 2)))
  (it "focuses on several values"
    (affirm (getter? (traversing head))
            (eq? (^. '((1 2 3)
                       (2 3 1)
                       (3 2 1))
                     (traversing head))
                 '(1 2 3))))
  (it "folds several values"
    (affirm (getter? (accumulating + 0 head))
            (eq? (^. '((1 2 3)
                       (2 3 1)
                       (3 2 1))
                     (accumulating + 0 head))
                 6))))
