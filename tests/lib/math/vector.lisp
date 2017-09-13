(import test ())
(import math/vector ())

(describe "The math library has vectors"
  (it "which can be converted from lists"
    (affirm (eq? (vector 1 2 3) (list->vector '(1 2 3)))))

  (can "be added together"
    (check [(number a1) (number a2) (number a3)
            (number b1) (number b2) (number b3)]
      (eq? (vector (+ a1 b1) (+ a2 b2) (+ a3 b3))
           (n+ (vector a1 a2 a3) (vector b1 b2 b3)))))

  (can "be subtracted"
    (check [(number a1) (number a2) (number a3)
            (number b1) (number b2) (number b3)]
      (eq? (vector (- a1 b1) (- a2 b2) (- a3 b3))
           (n- (vector a1 a2 a3) (vector b1 b2 b3)))))

  (can "be multiplied"
    (check [(number a1) (number a2) (number a3)
            (number b)]
      (eq? (vector (* a1 b) (* a2 b) (* a3 b))
           (n* (vector a1 a2 a3) b))))

  (can "be divided"
    (check [(number a1) (number a2) (number a3)
            (number b)]
      (or (= b 0) (eq? (vector (/ a1 b) (/ a2 b) (/ a3 b))
                       (n/ (vector a1 a2 a3) b)))))

  (can "compute the dot product"
    (affirm (eq? 0 (dot (vector 1 0) (vector 0 1)))
            (eq? 1 (dot (vector 1 0) (vector 1 1)))))

  (can "compute the cross product"
    (affirm (eq? (vector 0 0 1) (cross (vector 1 0 0) (vector 0 1 0)))))

  (can "compute the norm"
    (affirm (eq? 5 (norm (vector 3 4)))))

  (can "compute the angle"
    (affirm (eq? (/ math/pi 2) (angle (vector 0 1) (vector 1 0)))))

  (can "compute the unit"
    (affirm (eq? (vector 3/5 4/5) (unit (vector 3/2 4/2)))))

  (can "create a null vector"
    (affirm (eq? (vector 0 0 0) (null 3)))))
