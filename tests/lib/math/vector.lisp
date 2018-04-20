(import test ())
(import math/vector ())
(import math/numerics ())

(defmacro ok? (&exprs)
  "Returns whether the list of EXPRS evaluated without erroring."
  `(= (pcall (lambda () ,@exprs)) true))

(defmacro errors? (&exprs)
  "Returns whether the list of EXPRS errored when evaluating."
  `(= (pcall (lambda () ,@exprs)) false))

(describe "The math library has vectors which"
  (can "be converted from lists"
    (affirm (eq? (vector 1 2 3) (list->vector '(1 2 3)))))

  (cannot "be converted from lists with an invalid set of arguments"
    (affirm (= false (ok? (list->vector)))
            (= false (ok? (list->vector '())))
            (= false (ok? (list->vector (list (/ 0 0)))))))

  (cannot "be formed from invalid arguments"
    (affirm (= false (ok? (vector)))
            (= false (ok? (vector (/ 0 0))))))

  (can "be added together"
    (check [(number a1) (number a2) (number a3)
            (number b1) (number b2) (number b3)]
      (eq? (vector (+ a1 b1) (+ a2 b2) (+ a3 b3))
           (n+ (vector a1 a2 a3) (vector b1 b2 b3)))))

  (cannot "be added together with invalid vector"
    (affirm (= false (ok? (n+ (vector 1) (vector 1 2))))
            (= false (ok? (n+ (vector 1) 2)))))

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

  (cannot "be multiplied with nans"
    (affirm (= false (ok? (n* (vector 1) (/ 0 0))))
            (= false (ok? (n* (/ 0 0) (vector 1))))))

  (can "be divided"
    (check [(number a1) (number a2) (number a3)
            (number b)]
      (or (= b 0) (eq? (vector (/ a1 b) (/ a2 b) (/ a3 b))
                       (n/ (vector a1 a2 a3) b)))))

  (cannot "be divided by nans or 0s"
    (affirm (= false (ok? (n/ (vector 1) (/ 0 0))))
            (= false (ok? (n/ (/ 0 0) (vector 1))))
            (= false (ok? (n/ (vector 1) 0)))
            (= false (ok? (n/ 0 (vector 0))))))

  (can "be negated"
    (affirm (eq? (vector -3 -2 1) (nnegate (vector 3 2 -1)))
            (eq? (vector -5/3) (nnegate (vector 5/3)))))

  (can "have the absolute value taken"
    (affirm (eq? (vector 3 2 1 0) (nabs (vector -3 2 -1 0)))
            (eq? (vector 5/3 2/3) (nabs (vector -5/3 2/3)))))

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
