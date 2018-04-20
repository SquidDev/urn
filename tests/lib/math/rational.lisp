(import test ())
(import math/rational r)
(import math/numerics ())

(describe "The math library has rationals which"
  (can "be written as literals"
    (affirm (eq? 1/2 (rational 1 2))
            (eq? 2/3 (rational 2 3))))

  (it "will reduce to the simplest possible fraction"
    (affirm (eq? (rational 1 2) (rational 2 4))
            (eq? (rational -1 2) (rational 1 -2))))

  (can "be converted to a real"
    (check [(number x) (number y)]
      (eq? (/ x y) (r/->float (rational x y)))))

  (can "be converted from a real"
    ;; Ideally we'd use check here, but sadly we get rounding
    ;; errors for anything more than basic fractions.
    (map (lambda (x y)
           (affirm (eq? (rational x y) (r/->rat (/ x y)))))
      '(1 3 1)
      '(2 4 8)))

  (can "be added together"
    (affirm (eq? (rational 2 3) (n+ (rational 1 3) (rational 1 3)))
            (eq? (rational 1 2) (n+ (rational 1 4) (rational 1 4)))
            (eq? (rational 0 1) (n+ (rational 1 4) (rational -1 4)))
            (eq? (rational 1 2) (n+ (rational 1 4) 0.25))
            (eq? (rational 1 2) (n+ 0.25 (rational 1 4)))))

  (can "be subtracted"
    (affirm (eq? (rational 1 6) (n- (rational 1 2) (rational 1 3)))
            (eq? (rational 0 1) (n- (rational 1 4) (rational 1 4)))
            (eq? (rational 1 2) (n- (rational 1 4) (rational -1 4)))
            (eq? (rational 1 4) (n- (rational 1 2) 0.25))
            (eq? (rational 1 4) (n- 0.75 (rational 1 2)))))

  (can "be multiplied"
    (affirm (eq? (rational 2 9) (n* (rational 2 3) (rational 1 3)))
            (eq? (rational 1 4) (n* (rational 1 2) 0.5))
            (eq? (rational 1 4) (n* 0.5 (rational 1 2)))))

  (can "be divided"
    (affirm (eq? (rational 2 1) (n/ (rational 2 3) (rational 1 3)))
            (eq? (rational 1 2) (n/ (rational 1 4) 0.5))
            (eq? (rational 1 8) (n* 0.25 (rational 1 2)))))

  (can "be square rooted"
    (affirm (eq? (rational 1 2) (nsqrt (rational 1 4)))
            (eq? (rational 1 3) (nsqrt (rational 1 9)))))

  (can "be compared"
    (check [(natural x) (natural y)]
      (n<  (/ (pred x) y)        (rational x y))
      (n<= (/ (pred x) y)        (rational x y))
      (n>  (/ (succ x) y)        (rational x y))
      (n>= (/ (succ x) y)        (rational x y))

      (n<  (rational (pred x) y) (rational x y))
      (n<= (rational (pred x) y) (rational x y))
      (n>  (rational (succ x) y) (rational x y))
      (n>= (rational (succ x) y) (rational x y))

      (n=  (rational x y)        (rational x y))
      (n>= (rational x y) (rational x y))
      (n<= (rational x y) (rational x y))))

  (can "be negated"
    (check [(natural x) (natural y)]
      (eq? (rational (nnegate x) y) (nnegate (rational x y)))))

  (can "have the absolute value taken"
    (check [(natural x) (natural y)]
      (eq? (rational x y) (nabs (rational x y)))
      (eq? (rational x y) (nabs (rational (nnegate x) y)))
      (eq? (rational x y) (nabs (rational x (nnegate y))))))

  (can "compute the sign"
    (affirm (eq?  1 (rational 1 1))
            (eq? -1 (rational -1 1))
            (eq? -1 (rational 1 -1))
            (eq?  1 (rational -1 -1))))

  (can "be exponented"
    (affirm (eq? (rational 1 9) (nexpt (rational 1 3) 2))
            (eq? (rational 8 27) (nexpt (rational 2 3) 3)))))
