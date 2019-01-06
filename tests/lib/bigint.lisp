(import test ())
(import math/bigint bigint)

(describe "A big number"
  (it "can be created with different bases"
    (affirm (= (bigint/new 17) (bigint/new "17"))
            (= (bigint/new 17) (bigint/new "0x11"))
            (= (bigint/new 17) (bigint/new "0o21"))
            (= (bigint/new 17) (bigint/new "0b10001"))))
  (it "can be negated"
    (affirm (= (bigint/negate (bigint/new 1)) (bigint/new -1))))
  (it "can be added and subtracted"
    (affirm (= (+ (bigint/new 2) (bigint/new 3)) (bigint/new 5))))
  (it "can be subtracted"
    (affirm (= (- (bigint/new 9) (bigint/new 4)) (bigint/new 5))))
  (it "can be multiplied"
    (affirm (= (* (bigint/new 7) (bigint/new 5)) (bigint/new 35))))
  (it "can be divided"
    (affirm (= (/ (bigint/new 42) (bigint/new 4)) (bigint/new 10))))
  (it "can have a remainder of a division"
    (affirm (= (mod (bigint/new 42) (bigint/new 4)) (bigint/new 2))))
  (it "can be expontentiated"
    (affirm (= (expt (bigint/new 10) (bigint/new 10)) (* (bigint/new 100000) (bigint/new 100000)))))
  (it "can be converted to a string in different bases"
    (affirm (= (bigint/tostring (bigint/new "123456789")) "123456789")
            (= (bigint/tostring (bigint/new "0x123456789AB") "X") "123456789AB")
            (= (bigint/tostring (bigint/new "0o123456777") "o") "123456777")
            (= (bigint/tostring (bigint/new "0b111000111000111000") "b") "111000111000111000"))))
