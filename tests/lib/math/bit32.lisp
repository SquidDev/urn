(import test ())

(import math/bit32 ())

(describe "The bit32 library"
  (it "can check whether a number is a valid u32 integer"
    (affirm (eq? (valid-u-32 #xF0000000) true))
    (affirm (eq? (valid-u-32 #x1F0000000) false))
    (affirm (eq? (valid-u-32 2.5) false))
    (affirm (eq? (valid-u-32 -2) false)))
  (it "can arithmetically shift right"
    (affirm (eq? (ashr #x8000001F 4) #xF8000001)))
  (it "can bitwise AND"
    (affirm (eq? (bit-and #b1110 #b0111 #b1010) #b0010)))
  (it "can bitwise NOT"
    (affirm (eq? (bit-not #xF0FFFF1F) #x0F0000E0)))
  (it "can bitwise OR"
    (affirm (eq? (bit-or #b1010 #b0110 #b0100) #b1110)))
  (it "can bitwise test"
    (affirm (eq? (bit-test #b0001 #b0100 #b0100) false)
            (eq? (bit-test #b0101 #b0100 #b0100) true)))
  (it "can bitwise XOR"
    (affirm (eq? (bit-xor #b1110 #b0111 #b1010) #b0011)))
  (it "can bit extract"
    (affirm (eq? (bit-extract #b11101001 2 4) #b1010)))
  (it "can bit replace"
    (affirm (eq? (bit-replace #b11100 #b010 1 3) #b10100)))
  (it "can bit rotate left"
    (affirm (eq? (bit-rotl #b1110 2) #b111000)))
  (it "can bit rotate right"
    (affirm (eq? (bit-rotr #b1110 2) #x80000003)))
  (it "can bit shift left"
    (affirm (eq? (shl #xC0000001 1) #x80000002)))
  (it "can bit shift right"
    (affirm (eq? (shr #x80000003 1) #x40000001))))
