(import test ())
(import math/bignum bignum)

(describe "A big number"
  (it "can be created with different bases"
    (affirm (= (bignum/new 17) (bignum/new "17"))
            (= (bignum/new 17) (bignum/new "0x11"))
            (= (bignum/new 17) (bignum/new "0o21"))
            (= (bignum/new 17) (bignum/new "0b10001"))))
  (it "can be negated"
    (affirm (= (bignum/negate (bignum/new 1)) (bignum/new -1))))
  (it "can be added and subtracted"
    (affirm (= (+ (bignum/new 2) (bignum/new 3)) (bignum/new 5))))
  (it "can be subtracted"
    (affirm (= (- (bignum/new 9) (bignum/new 4)) (bignum/new 5))))
  (it "can be multiplied"
    (affirm (= (* (bignum/new 7) (bignum/new 5)) (bignum/new 35))))
  (it "can be divided"
    (affirm (= (/ (bignum/new 42) (bignum/new 4)) (bignum/new 10))))
  (it "can have a remainder of a division"
    (affirm (= (% (bignum/new 42) (bignum/new 4)) (bignum/new 2))))
  (it "can be expontentiated"
    (affirm (= (^ (bignum/new 10) (bignum/new 10)) (* (bignum/new 100000) (bignum/new 100000)))))
  (it "can be converted to a string in different bases"
    (affirm (= (bignum/tostring (bignum/new "123456789")) "123456789")
            (= (bignum/tostring (bignum/new "0x123456789AB") "X") "123456789AB")
            (= (bignum/tostring (bignum/new "0o123456777") "o") "123456777")
            (= (bignum/tostring (bignum/new "0b111000111000111000") "b") "111000111000111000"))))
