(import test ())

(import data/set ())

(describe "A set"
  (it "looks like a set"
    (affirm (= (type (make-set)) "set")))

  (it "has a function which checks if something is a set"
    (affirm
      (= (set? (make-set)) true)
      (= (set? 23) false)))

  (it "can be pretty printed"
    (affirm
      (= "«hash-set: »" (pretty (make-set)))
      (= "«hash-set: 1»" (pretty (insert! (make-set) 1)))
      (= "«hash-set: 1 2 3»" (pretty (insert! (make-set) 1 2 3)))
      (= "«hash-set: \"foo\"»" (pretty (insert! (make-set) "foo")))))

  (it "can be checked for equality"
    (affirm
      (eq? (make-set) (make-set))
      (eq? (insert! (make-set) 1 2 3) (insert! (make-set) 3 2 1))
      (neq? (insert! (make-set) 1) (insert! (make-set) 2 3))))

  (it "can be converted from a list"
    (affirm (eq? (set-of 1 2 3) (insert! (make-set) 1 2 3))))

  (it "can be converted to a list"
    (check [(list a)]
      (with (set (apply set-of a))
        (eq? set (apply set-of (set->list set))))))

  (it "can be checked for the presence of an element"
    (check [(any a)] (= (element? (set-of a) a) true))
    (check [(number a)] (= (element? (set-of (succ a)) a) false))
    (check [(any a) (any b)] (= (element? (set-of a b) a) true)))

  (it "can have elements inserted into it"
    (with (x (make-set))
      (affirm (eq? (make-set) x))
      (insert! x 1)
      (affirm (eq? (set-of 1) x))
      (insert! x 1)
      (affirm (eq? (set-of 1 2) x))))

  (it "can have elements inserted into it immutably"
    (with (x (make-set))
      (affirm (eq? (make-set) x))
      (affirm
        (eq? (set-of 1) (insert x 1))
        (eq? (set-of 1 2) (insert x 1 2))
        (eq? (make-set) x))))

  (it "has a union"
    (affirm
      (eq? (make-set) (union (make-set) (make-set)))
      (eq? (set-of 1) (union (set-of 1) (make-set)))
      (eq? (set-of 1) (union (make-set) (set-of 1)))
      (eq? (set-of 1 2) (union (set-of 1) (set-of 1 2)))))

  (it "has an intersection"
    (affirm
      (eq? (make-set) (intersection (make-set) (make-set)))
      (eq? (make-set) (intersection (set-of 1) (make-set)))
      (eq? (make-set) (intersection (make-set) (set-of 1)))
      (eq? (set-of 1) (intersection (set-of 1) (set-of 1 2))))))
