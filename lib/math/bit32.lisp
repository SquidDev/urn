(import lua/basic (_G require xpcall))
(import compiler (flag?))

;;; Sorry for this NIH silliness, the lua/bit32 and luajit/bit
;;; functions compile into for example bit32.arshift and require('bit').arshift
;;; which both error if the libraries don't exist.
(define bit32 :hidden (.> _G :bit32))
(define bit :hidden (with ((status ret) (pcall (cut require "bit")))
                      (when status ret)))
(define u-32 :hidden (expt 2 32))

(defmacro defbitop (name lua-native luajit-native software-docs software-args &software-impl) :hidden
 `(define ,name
    ,software-docs
    (cond
      [bit32 (.> bit32 ,lua-native)]
      [(and bit (neq? ,luajit-native nil)) (wrap-luajit-bitop (.> bit ,luajit-native))]
      [else ,(if (flag? "bit32-no-soft")
               `nil
               `(lambda ,software-args ,@software-impl))])))

;;; LuaJIT bitops return 32-bit signed integers, so make them unsigned.
(defun wrap-luajit-bitop (fn) :hidden
  (lambda (&args)
    (with (result (fn (splice args)))
      (if (< result 0)
        (+ u-32 result)
        result))))

(defun valid-u-32 (n)
  "Returns whether the number N is a valid u32 integer.
   A number is considered valid when it's an integer between 0 and 2^32-1."
  (and (= (math/floor n) n)
       (>= n 0)
       (< n u-32)))

(defun accumulating-bitop (bit-fn args) :hidden
  (desire (all valid-u-32 args) "One or more numbers provided is not a valid u32 integer.")
  (with (result (nth args 1))
    (for i 2 (n args) 1
      (with (new-result 0)
        (for j 0 31 1
          (let* [(a-bit (math/floor (mod (/ result (expt 2 j)) 2)))
                 (b-bit (math/floor (mod (/ (nth args i) (expt 2 j)) 2)))
                 (r-bit (if (bit-fn (= a-bit 1) (= b-bit 1)) 1 0))]
            (set! new-result (+ new-result (* r-bit (expt 2 j))))))
        (set! result new-result)))
    (mod result u-32)))

(defbitop ashr :arshift :arshift
  "Returns the arithmetic right shift of X shifted right by DISP.
   If DISP is greater than 0 and the leftmost bit is 1, the void gets
   filled by 1, otherwise 0."
  (x disp)
  (desire (valid-u-32 x) "Number must be a valid u32 integer.")
  (with (result (shr x disp))
    (when (>= disp 0)
      (when (> disp 32)
        (set! disp 32))
      (when (>= (mod x u-32) (expt 2 31))
        (for i 1 disp 1
          (set! result (+ result (expt 2 (- 32 i)))))))
    result))

(defbitop bit-and :band :band
  "Returns the bitwise AND of its arguments."
  (&args)
  (accumulating-bitop -and args))

(defbitop bit-not :bnot :bnot
  "Returns the bitwise NOT of X."
  (x)
  (desire (valid-u-32 x) "Number must be a valid u32 integer.")
  (- u-32 (mod x u-32) 1))

(defbitop bit-or :bor :bor
  "Returns the bitwise OR of its arguments."
  (&args)
  (accumulating-bitop -or args))

(defbitop bit-test :btest nil
  "Returns true if the bitwise AND of its arguments is not 0."
  (&args)
  (/= (bit-and (splice args)) 0))

(defbitop bit-xor :bxor :bxor
  "Returns the bitwise XOR of its arguments."
  (&args)
  (accumulating-bitop /= args))

(defbitop bit-extract :extract nil
  "Returns the unsigned number formed by splicing the bits FIELD to
   FIELD + WIDTH - 1 from X.
   Bit 0 is the least significant bit, bit 31 the most.
   The default for WIDTH is 1."
  (n field (width 1))
  (desire (valid-u-32 n) "Number must be a valid u32 integer.")
  (math/floor (mod (/ n (expt 2 field)) (expt 2 width))))

(defbitop bit-replace :replace nil
  "Returns X with the bits FIELD to FIELD + WIDTH - 1 replaced with
   the unsigned number value of V.
   Bit 0 is the least significant bit, bit 31 the most.
   The default for WIDTH is 1."
  (n v field (width 1))
  (desire (and (valid-u-32 n) (valid-u-32 v)) "Numbers must be valid u32 integers.")
  (let* [(pre (shr (shl n (- 32 field)) (- 32 field)))
         (val (shl (mod v (expt 2 width)) field))
         (post (shl (shr n (+ field width)) (+ field width)))]
    (mod (+ pre val post) u-32)))

(defbitop bit-rotl :lrotate :rol
  "Returns X rotated left by DISP."
  (x disp)
  (desire (valid-u-32 x) "Number must be a valid u32 integer.")
  (with (disp-32 (mod disp 32))
    (+ (shl x disp-32) (shr x (- 32 disp-32)))))

(defbitop bit-rotr :rrotate :ror
  "Returns X rotated right by DISP."
  (x disp)
  (bit-rotl x (- 0 disp)))

(defbitop shl :lshift :lshift
  "Returns X shifted left by DISP."
  (x disp)
  (desire (valid-u-32 x) "Number must be a valid u32 integer.")
  (if (>= disp 0)
    (mod (* x (expt 2 disp)) u-32)
    (mod (math/floor (* x (expt 2 disp))) u-32)))

(defbitop shr :rshift :rshift
  "Returns X shifted right by DISP."
  (x disp)
  (shl x (- 0 disp)))
