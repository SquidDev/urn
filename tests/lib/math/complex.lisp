(import math/numerics ())
(import math/complex ())
(import test ())

(defgeneric req? (a b))
(defmethod (req? number number) (a b)
  (< (math/abs (- a b)) 1e-5))
(defmethod (req? complex complex) (a b)
  (and (req? (real a) (real b)) (req? (imaginary a) (imaginary b))))

(describe "The math library has complex numbers which"
  (can "be created and destructured"
    (check [(number a) (number b)]
      (eq? a (real      (complex a b)))
      (eq? b (imaginary (complex a b)))))

  (can "be pretty printed"
    (affirm (eq? "2+3i"  (pretty (complex 2 3)))
            (eq? "2-3i"  (pretty (complex 2 -3)))
            (eq? "-2+3i" (pretty (complex -2 3)))
            (eq? "-2-3i" (pretty (complex -2 -3)))))

  (can "be equated"
    (affirm (eq?  (complex 1 2) (complex 1 2))
            (neq? (complex 1 2) (complex 1 3))
            (neq? (complex 1 2) (complex 2 2))

            (eq?  (complex 1 0) 1)
            (neq? (complex 1 1) 1)
            (eq?  1 (complex 1 0)
            (neq? 1 (complex 1 1)))))

  (can "be added"
    (affirm (eq? (complex 12 15) (n+ (complex 4 5) (complex 8 10)))
            (eq? (complex 5 1)   (n+ (complex 3 1) 2))
            (eq? (complex 5 1)   (n+ 2 (complex 3 1)))))

  (can "be subtracted"
    (affirm (eq? (complex 8 10) (n- (complex 12 15) (complex 4 5)))
            (eq? (complex 3 1)  (n- (complex 5 1) 2))
            (eq? (complex 3 -1) (n- 5 (complex 2 1)))))

  (can "be multiplied"
    (affirm (eq? (complex -13 11) (n* (complex 1 3) (complex 2 5)))
            (eq? (complex 2 6)    (n* (complex 1 3) 2))
            (eq? (complex 2 6)    (n* 2 (complex 1 3)))))

  (can "be divided"
    (affirm (eq? (complex 1.0 1.0)    (n/ (complex 1 3) (complex 2 1)))
            (eq? (complex 20/13 9/13) (n/ (complex 1/1 6/1) (complex 2/1 3/1)))
            (eq? (complex 2/3 1)      (n/ (complex 2 3) 3/1))
            (eq? (complex 0.3 -0.9) (n/ 3 (complex 1 3)))))

  (can "be raised to some power"
    (affirm (req? (complex 0 2) (nexpt (complex 1 1) 2))))

  (can "be conjugated"
    (check [(number a) (number b)]
      (eq? (complex a (nnegate b)) (conjugate (complex a b)))))

  (can "be converted to polar coordinates"
    (affirm (eq? 5 (first (->polar (complex 3 4))))
            (eq? 45 (math/deg (second (->polar (complex 2 2)))))))

  (can "be created from polar coordinates"
    (with (c (polar-> 5 0.92729521800161))
      (affirm (req? (complex 3 4) c))))

  (it "has an identity between ->polar and polar->"
    (check [(number a) (number b)]
      (req? (complex a b) (polar-> (->polar (complex a b))))))

  )
