(define-native ashr
  "Returns the arithmetic right shift of X shifted right by DISP.
   If DISP is greater than 0 and the leftmost bit is 1, the void gets
   filled by 1, otherwise 0.")
(define-native bit-and
  "Returns the bitwise AND of its arguments.")
(define-native bit-not
  "Returns the bitwise NOT of X.")
(define-native bit-or
  "Returns the bitwise OR of its arguments.")
(define-native bit-test
  "Returns true if the bitwise AND of its arguments is not 0.")
(define-native bit-xor
  "Returns the bitwise XOR of its arguments.")
(define-native bit-extract
  "Returns the unsigned number formed by splicing the bits FIELD to
   FIELD + WIDTH - 1 from X.
   Bit 0 is the least significant bit, bit 31 the most.
   The default for WIDTH is 1.")
(define-native bit-replace
  "Returns X with the bits FIELD to FIELD + WIDTH - 1 replaced with
   the unsigned number value of V.
   Bit 0 is the least significant bit, bit 31 the most.
   The default for WIDTH is 1.")
(define-native bit-rotl
  "Returns X rotated left by DISP.")
(define-native shl
  "Returns X shifted left by DISP.")
(define-native bit-rotr
  "Returns X rotated right by DISP.")
(define-native shr
  "Returns X shifted right by DISP.")
