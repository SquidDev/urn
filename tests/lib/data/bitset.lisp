(import test ())

(import data/bitset ())

(describe "A bitset"
  (it "looks like a bitset"
    (affirm (= (type (make-bitset)) "bitset")))

  (it "can be checked for equality"
    (let [(a (make-bitset))
          (b (make-bitset))]
      (set-bit! a 3)
      (set-bit! a 7)
      (set-bit! b 3)
      (set-bit! b 7)
      (affirm (eq? a b)))
    (let [(a (make-bitset))
          (b (make-bitset))]
      (set-bit! a 5)
      (set-bit! a 7)
      (set-bit! b 6)
      (set-bit! b 7)
      (affirm (not (eq? a b)))))

  (it "can be pretty printed"
    (with (bs (make-bitset))
      (affirm (= (pretty bs) "«bitset: »"))
      (set-bit! bs 0)
      (affirm (= (pretty bs) "«bitset: 00000001»"))
      (set-bit! bs 2)
      (affirm (= (pretty bs) "«bitset: 00000005»"))
      (set-bit! bs 33)
      (affirm (= (pretty bs) "«bitset: 00000005 00000002»"))))

  (it "has a copying constructor"
    (with (a (make-bitset))
      (set-bit! a 4)
      (with (b (make-bitset a))
        (affirm (not (= a b)))
        (affirm (get-bit b 4)))))

  (it "can have bits set and cleared"
    (with (bs (make-bitset))
      (set-bit! bs 2)
      (set-bit! bs 32)
      (set-bit! bs 33)
      (affirm (get-bit bs 2))
      (affirm (get-bit bs 32))
      (affirm (get-bit bs 33))
      (clear-bit! bs 2)
      (clear-bit! bs 32)
      (clear-bit! bs 33)
      (affirm (not (get-bit bs 2)))
      (affirm (not (get-bit bs 32)))
      (affirm (not (get-bit bs 33)))
      (set-bit-value! bs 4 true)
      (affirm (get-bit bs 4))
      (set-bit-value! bs 4 false)
      (affirm (not (get-bit bs 4)))))

  (it "can have bits flipped"
    (with (bs (make-bitset))
      (flip-bit! bs 2)
      (flip-bit! bs 33)
      (affirm (get-bit bs 2))
      (affirm (get-bit bs 33))
      (flip-bit! bs 2)
      (flip-bit! bs 33)
      (affirm (not (get-bit bs 2)))
      (affirm (not (get-bit bs 33)))))

  (it "can find the next set bit"
    (with (bs (make-bitset))
      (set-bit! bs 5)
      (set-bit! bs 15)
      (set-bit! bs 33)
      (affirm (= (next-set-bit bs 2) 5))
      (affirm (= (next-set-bit bs 6) 15))
      (affirm (= (next-set-bit bs 30) 33))
      (affirm (= (next-set-bit bs 33) 33))))

  (it "can find the next clear bit"
    (with (bs (make-bitset))
      (set-bit! bs 0)
      (set-bit! bs 1)
      (set-bit! bs 2)
      (set-bit! bs 3)
      (set-bit! bs 5)
      (set-bit! bs 7)
      (affirm (= (next-clear-bit bs 2) 4))
      (affirm (= (next-clear-bit bs 5) 6))
      (affirm (= (next-clear-bit bs 7) 8))))

  (it "can count the number of set bits"
    (with (bs (make-bitset))
      (set-bit! bs 2)
      (set-bit! bs 3)
      (set-bit! bs 5)
      (affirm (= (cardinality bs) 3))))

  (it "can test if two bitsets intersect"
    (let [(a (make-bitset))
          (b (make-bitset))]
      (set-bit! a 2)
      (set-bit! a 5)
      (set-bit! b 3)
      (set-bit! b 6)
      (affirm (not (intersects a b))))
    (let [(a (make-bitset))
          (b (make-bitset))]
      (set-bit! a 2)
      (set-bit! a 5)
      (set-bit! b 5)
      (set-bit! b 6)
      (affirm (intersects a b))))

  (it "can perform a logical AND between two bitsets"
    (let [(a (make-bitset))
          (b (make-bitset))]
      (set-bit! a 1)
      (set-bit! a 3)
      (set-bit! a 6)
      (set-bit! b 3)
      (set-bit! b 6)
      (set-bit! b 9)
      (with (c (bitsets-and a b))
        (affirm (not (get-bit c 1)))
        (affirm (not (get-bit c 2)))
        (affirm (get-bit c 3))
        (affirm (not (get-bit c 4)))
        (affirm (not (get-bit c 5)))
        (affirm (get-bit c 6))
        (affirm (not (get-bit c 9))))))

  (it "can perform a logical OR between two bitsets"
    (let [(a (make-bitset))
          (b (make-bitset))]
      (set-bit! a 2)
      (set-bit! a 5)
      (set-bit! a 15)
      (set-bit! a 33)
      (set-bit! b 5)
      (set-bit! b 40)
      (set-bit! b 66)
      (with (c (bitsets-or a b))
        (affirm (get-bit c 2))
        (affirm (get-bit c 5))
        (affirm (get-bit c 15))
        (affirm (get-bit c 33))
        (affirm (get-bit c 40))
        (affirm (get-bit c 66)))))

  (it "can perform a logical XOR between two bitsets"
    (let [(a (make-bitset))
          (b (make-bitset))]
      (set-bit! a 2)
      (set-bit! a 7)
      (set-bit! a 12)
      (set-bit! a 23)
      (set-bit! b 5)
      (set-bit! b 7)
      (set-bit! b 16)
      (set-bit! b 23)
      (with (c (bitsets-xor a b))
        (affirm (not (get-bit c 0)))
        (affirm (get-bit c 2))
        (affirm (get-bit c 5))
        (affirm (not (get-bit c 7)))
        (affirm (get-bit c 12))
        (affirm (get-bit c 16))
        (affirm (not (get-bit c 23)))))))