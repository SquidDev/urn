(import test ())
(import math/numerics ())
(import math/matrix ())

(describe "The math library has matrices which"
  (can "be compared"
    (affirm (eq?  (matrix 2 2 1 2 3 4) (matrix 2 2 1 2 3 4))
            (neq? (matrix 2 2 1 2 3 4) (matrix 2 2 1 2 4 3))))

  (can "be queried"
    (with (m (matrix 2 2 1 2 3 4))
      (affirm (eq? 1 (matrix-item m 1 1))
              (eq? 2 (matrix-item m 1 2))
              (eq? 3 (matrix-item m 2 1))
              (eq? 4 (matrix-item m 2 2)))))

  (it "has an identity"
    (affirm (eq? (matrix 2 2 1 0 0 1) (identity 2))))

  (can "be added"
    (check [(number a1) (number a2)
            (number b1) (number b2)]
      (eq? (matrix 1 2 (+ a1 b1) (+ a2 b2))
           (n+ (matrix 1 2 a1 a2) (matrix 1 2 b1 b2)))))

  (can "be subtracted"
    (check [(number a1) (number a2)
            (number b1) (number b2)]
      (eq? (matrix 1 2 (- a1 b1) (- a2 b2))
           (n- (matrix 1 2 a1 a2) (matrix 1 2 b1 b2)))))

  (can "be multiplied"
    (check [(number a1) (number a2) (number a3) (number a4)
            (number b1) (number b2) (number b3) (number b4)]
      (eq? (matrix 2 2
             (+ (* a1 b1) (n* a2 b3)) (n+ (* a1 b2) (n* a2 b4))
             (+ (* a3 b1) (n* a4 b3)) (n+ (* a3 b2) (n* a4 b4)))
           (n* (matrix 2 2 a1 a2 a3 a4)
               (matrix 2 2 b1 b2 b3 b4)))))

  (can "be multiplied with fixed matrices"
    (let [(a (matrix 1 3 1 2 3))
          (b (matrix 3 1 1 2 3))]
      (affirm (eq? (matrix 1 1 14) (n* b a))
              (eq? (matrix 3 3
                     1 2 3
                     2 4 6
                     3 6 9) (n* a b)))))

  (can "be converted to row echelon form"
    (affirm (eq? (matrix 3 2
                   1 1.25 1.5
                   0 1    2)
                 (echelon
                   (matrix 3 2
                     1 2 3
                     4 5 6)))))

  (can "be converted to reduced row echelon form"
    (affirm (eq? (matrix 3 2
                   1 0 -1
                   0 1 2)
                 (reduced-echelon
                   (matrix 3 2
                     1 2 3
                     4 5 6))))))
