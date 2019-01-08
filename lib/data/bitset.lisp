"This module implements bit sets"

(import core/base (set-idx!))
(import data/struct ())
(import lua/math (ceil floor min max))
(import math/bit32 ())
(import lua/string (format))

;; This is questionable but 32 bits seems like a safe assumption
(define bits-per-int :hidden 32)

(defun bit->element (bit)
  :hidden
  (floor (/ bit bits-per-int)))

(defun bit->element-index (bit)
  :hidden
  (mod bit bits-per-int))

(defun ensure-bit-exists! (bs bit)
  :hidden
  (let* [(data (bitset-data bs))
         (need (- (+ (bit->element bit) 1) (n data)))]
    (when (> need 0)
      (for i 1 need 1
        (push! data 0)))))

(defstruct (bitset make-bitset bitset?)
  "Creates a new, empty bitset"
  (fields
    (immutable (hide data)))
  (constructor new
    (lambda (other)
      (if (bitset? other)
        (new (map id (bitset-data other)))
        (new '())))))

(defmethod (eq? bitset bitset) (x y)
  (let* [(dx (bitset-data x))
         (dy (bitset-data y))
         (ldx (n dx))
         (ldy (n dy))]
    (if (= ldx ldy)
      (with (result true)
        (for i 1 ldx 1
          (when (/= (nth dx i) (nth dy i))
            (set! result false)))
        result)
      false)))

(defmethod (pretty bitset) (bs)
  (.. "«bitset: " (concat (map (lambda (x) (format "%08x" x)) (bitset-data bs)) " ") "»"))

(defun get-bit (bs bit)
  "Returns the value of the bit in the bitset BS with the specified index BIT

   ### Example:
   ```cl
   > (define bs (make-bitset))
   out = «bitset: »
   > (set-bit! bs 5)
   out = nil
   > (get-bit bs 5)
   out = true
   ```"
  (assert-type! bs bitset)
  (let* [(data (bitset-data bs))
         (eindex (+ (bit->element bit) 1))]
    (if (<= eindex (n data))
      (bit-test (nth data eindex) (shl 1 (bit->element-index bit)))
      false)))

(defun set-bit! (bs bit)
  "Sets the bit in the bitset BS with the specified index BIT

   ### Example:
   ```cl
   > (define bs (make-bitset))
   out = «bitset: »
   > (set-bit! bs 5)
   out = nil
   > bs
   out = «bitset: 00000020»
   ```"
  (assert-type! bs bitset)
  (ensure-bit-exists! bs bit)
  (let* [(data (bitset-data bs))
        (eindex (+ (bit->element bit) 1))
        (orig (nth data eindex))]
    (set-idx! data eindex (bit-or orig (shl 1 (bit->element-index bit))))))

(defun clear-bit! (bs bit)
  "Clears the bit in the bitset BS with the specified index BIT

   ```cl
   > (define bs (make-bitset))
   out = «bitset: »
   > (set-bit! bs 5)
   out = nil
   > bs
   out = «bitset: 00000020»
   > (clear-bit! bs 5)
   out = nil
   > bs
   out = «bitset: 00000000»
   ```"
  (assert-type! bs bitset)
  (ensure-bit-exists! bs bit)
  (let* [(data (bitset-data bs))
         (eindex (+ (bit->element bit) 1))]
    (when (<= eindex (n data))
      (set-idx! data eindex (bit-and (nth data eindex) (bit-not (shl 1 (bit->element-index bit))))))))

(defun set-bit-value! (bs bit value)
  "Sets the value of the bit in the bitset BS with the specified index BIT to VALUE

   ```cl
   > (define bs (make-bitset))
   out = «bitset: »
   > (set-bit-value! bs 2 true)
   out = nil
   > bs
   out = «bitset: 00000004»
   > (set-bit-value! bs 2 false)
   out = nil
   > bs
   out = «bitset: 00000000»"
  (if value
    (set-bit! bs bit)
    (clear-bit! bs bit)))

(defun flip-bit! (bs bit)
  "Inverts the value of the bit in the bitset BS with the specified index BIT

   ### Example:
   ```cl
   > (define bs (make-bitset))
   out = «bitset: »
   > (flip-bit! bs 2)
   out = nil
   > bs
   out = «bitset: 00000004»
   > (flip-bit! bs 2)
   out = nil
   > bs
   out = «bitset: 00000000»
   ```"
  (assert-type! bs bitset)
  (ensure-bit-exists! bs bit)
  (let* [(data (bitset-data bs))
         (eindex (+ (bit->element bit) 1))
         (orig (nth data eindex))]
    (set-idx! data eindex (bit-xor orig (shl 1 (bit->element-index bit))))))

(defun next-set-bit (bs start)
  "Finds the next set bit in the bitset BS at or after the index START. If no set bit is found, -1 is returned

   ### Example:
   ```cl
   > (define bs (make-bitset))
   out = «bitset: »
   > (set-bit! bs 5)
   out = nil
   > (next-set-bit bs 2)
   out = 5
   > (set-bit! bs 0)
   out = nil
   > (next-set-bit bs 0)
   out = 0
   ```"
  (assert-type! bs bitset)
  (let* [(data (bitset-data bs))
         (len (n data))
         (eindex (bit->element start))
         (result -1)]
    (demand (< eindex len))
    (while (and (= result -1) (< eindex len))
      (for i 0 (- bits-per-int 1) 1
        (with (j (+ (* eindex bits-per-int) i))
          (when (and (= result -1) (get-bit bs j) (>= j start))
            (set! result j))))
      (inc! eindex))
    result))

(defun next-clear-bit (bs start)
  "Finds the next clear bit in the bitset BS at or after the index START. If no clear bit is found, -1 is returned

   ### Example:
   ```cl
   > (define bs (make-bitset))
   out = «bitset: »
   > (set-bit! bs 0)
   out = nil
   > (set-bit! bs 1)
   out = nil
   > (next-clear-bit bs 0)
   out = 2
   > (clear-bit! bs 0)
   out = nil
   > (next-clear-bit bs 0)
   out = 0
   ```"
  (assert-type! bs bitset)
  (let* [(data (bitset-data bs))
         (len (n data))
         (eindex (bit->element start))
         (result -1)]
    (demand (< eindex len))
    (while (and (= result -1) (< eindex len))
      (for i 0 (- bits-per-int 1) 1
        (with (j (+ (* eindex bits-per-int) i))
          (when (and (= result -1) (not (get-bit bs j)) (>= j start))
            (set! result j))))
      (inc! eindex))
    result))

(defun cardinality (bs)
  "Returns the number of set bits in the bitset BS

   ### Example:
   ```cl
   > (define bs (make-bitset))
   out = «bitset: »
   > (set-bit! bs 1)
   out = nil
   > (set-bit! bs 4)
   out = nil
   > (cardinality bs)
   out = 2
   ```"
  (assert-type! bs bitset)
  (let* [(data (bitset-data bs))
         (count 0)]
    (for-each elem data
      (for i 0 (- bits-per-int 1) 1
        (when (bit-test elem (shl 1 i))
          (inc! count))))
    count))

(defun intersects (x y)
  "Tests if two bitsets share any of the same set bits

   ### Example:
   ```cl
   > (define a (make-bitset))
   out = «bitset: »
   > (define b (make-bitset))
   out = «bitset: »
   > (set-bit! a 2)
   out = nil
   > (set-bit! b 2)
   out = nil
   > (intersects a b)
   out = true
   ```"
  (assert-type! x bitset)
  (assert-type! y bitset)
  (let* [(dx (bitset-data x))
         (dy (bitset-data y))
         (len (min (n dx) (n dy)))
         (result false)]
    (for i 1 len 1
      (when (bit-test (nth dx i) (nth dy i))
        (set! result true)))
    result))

(defun bitsets-and (x y)
  "Performs a logical AND between two bitsets and returns the result as a new bitset

   ### Example:
   ```cl
   > (define a (make-bitset))
   out = «bitset: »
   > (define b (make-bitset))
   out = «bitset: »
   > (set-bit! a 2)
   out = nil
   > (set-bit! b 2)
   out = nil
   > (bitsets-and a b)
   out = «bitset: 00000004»
   ```"
  (assert-type! x bitset)
  (assert-type! y bitset)
  (let* [(result '())
        (dx (bitset-data x))
        (dy (bitset-data y))
        (len (min (n dx) (n dy)))]
    (for i 1 len 1
      (push! result (bit-and (nth dx i) (nth dy i))))
    (with (rbs (make-bitset))
      (.<! rbs :data result)
      rbs)))

(defun bitsets-or (x y)
  "Performs a logical OR between two bitsets and returns the result as a new bitset

   ### Example:
   ```cl
   > (define a (make-bitset))
   out = «bitset: »
   > (define b (make-bitset))
   out = «bitset: »
   > (set-bit! a 0)
   out = nil
   > (set-bit! b 1)
   out = nil
   > (bitsets-or a b)
   out = «bitset: 00000003»
   ```"
  (assert-type! x bitset)
  (assert-type! y bitset)
  (let* [(result '())
         (dx (bitset-data x))
         (dy (bitset-data y))
         (xlen (n dx))
         (ylen (n dy))
         (len (max xlen ylen))]
    (for i 1 len 1
      (if (and (<= i xlen) (<= i ylen))
        (push! result (bit-or (nth dx i) (nth dy i)))
        (if (<= i xlen)
          (push! result (nth dx i))
          (push! result (nth dy i)))))
    (with (rbs (make-bitset))
      (.<! rbs :data result)
      rbs)))

(defun bitsets-xor (x y)
  "Performs a logical XOR between two bitsets and returns the result as a new bitset

   ### Example:
   ```cl
   > (define a (make-bitset))
   out = «bitset: »
   > (define b (make-bitset))
   out = «bitset: »
   > (set-bit! a 0)
   out = nil
   > (set-bit! a 1)
   out = nil
   > (set-bit! b 1)
   out = nil
   > (bitsets-xor a b)
   out = «bitset: 00000001»
   ```"
  (assert-type! x bitset)
  (assert-type! y bitset)
  (let* [(result '())
         (dx (bitset-data x))
         (dy (bitset-data y))
         (xlen (n dx))
         (ylen (n dy))
         (len (max xlen ylen))]
    (for i 1 len 1
      (if (and (<= i xlen) (<= i ylen))
        (push! result (bit-xor (nth dx i) (nth dy i)))
        (if (<= i xlen)
          (push! result (nth dx i))
          (push! result (nth dy i)))))
    (with (rbs (make-bitset))
      (.<! rbs :data result)
      rbs)))
