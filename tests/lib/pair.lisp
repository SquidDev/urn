(import extra/test ())
(import extra/assert ())

(describe "A pair"
  (it "unites two values, fst and snd"
      (affirm (eq? (fst (pair 1 2)) 1)
              (eq? (snd (pair 1 2)) 2)
              (neq? (fst (pair 1 2)) 2)
              (neq? (snd (pair 1 2)) 1)))
  (may "represent a chain of values"
    (can "be converted to and from a list"
      (affirm (eq? (cons->pair '(1 2 3)) (pair 1 (pair 2 (pair 3 nil))))
              (eq? (pair->cons (pair 1 (pair 2 (pair 3 nil)))) '(1 2 3))))
    (can "be compared for equality"
         (affirm (eq? (pair 1 (pair 2 (pair 3 nil))) (pair 1 (pair 2 (pair 3 nil))))
                 (neq? (pair 1 2) 2))))
  (can "contain values of different types"
       (affirm (neq? (type (fst (pair 1 "foo"))) (type (snd (pair 1 "foo"))))))
  (can "contain values of the same type"
       (affirm (eq? (type (fst (pair 1 1))) (type (snd (pair 1 1))))))
  )
