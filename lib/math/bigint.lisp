(import lua/math (abs max floor ceil log))

(define num-tag   :hidden "bigint")
(define part-bits :hidden 24)
(define part-max  :hidden (expt 2 part-bits))

(defun trim! (a) :hidden
  (with (parts (.> a :parts))
    (while (= (nth parts (n parts)) 0)
      (.<! parts (n parts) nil)
      (.<! parts :n (- (n parts) 1)))
    (when (= (n parts) 0)
      (.<! a :sign false))))

(defun copy (a)
  "Returns a deep copied clone of A."
  (with (val (new))
    (.<! val :sign (.> a :sign))
    (for-each part (.> a :parts)
      (push! (.> val :parts) part))
    val))

(defun negate (a)
  "Returns A with the sign inverted."
  (with (val (copy a))
    (.<! val :sign (not (.> a :sign)))
    val))

(defun absolute (a)
  "Returns A if A is positive, otherwise inverts the sign and returns the positive version of A."
  (if (.> a :sign)
    (negate a)
    a))

(defun add (a b)
  "Returns A plus B."
  (cond
    [(and (= (type a) num-tag) (/= (type b) num-tag)) (add a (new b))]
    [(and (/= (type a) num-tag) (= (type b) num-tag)) (add (new a) b)]
    [(and (.> a :sign) (.> b :sign)) (negate (add (negate a) (negate b)))]
    [(and (not (.> a :sign)) (.> b :sign)) (subtract a (negate b))]
    [(and (.> a :sign) (not (.> b :sign))) (subtract b (negate a))]
    [else (let* [(val (new))
                 (a-parts (.> a :parts))
                 (b-parts (.> b :parts))
                 (val-parts (.> val :parts))
                 (max-parts (max (n (.> a :parts)) (n (.> b :parts))))]
            (for i 1 (+ max-parts 1) 1
              (push! val-parts 0))
            (for i 1 max-parts 1
              (with (new-part (+ (or (nth a-parts i) 0) (or (nth b-parts i) 0) (nth val-parts i)))
                (.<! val-parts i (mod new-part part-max))
                (when (>= new-part part-max) ; carry
                  (.<! val-parts (+ i 1) 1))))
            (trim! val)
            val)]))

(defun subtract (a b)
  "Returns A minus B."
  (cond
    [(and (= (type a) num-tag) (/= (type b) num-tag)) (subtract a (new b))]
    [(and (/= (type a) num-tag) (= (type b) num-tag)) (subtract (new a) b)]
    [(and (.> a :sign) (.> b :sign)) (subtract (negate b) (negate a))]
    [(and (not (.> a :sign)) (.> b :sign)) (add a (negate b))]
    [(and (.> a :sign) (not (.> b :sign))) (negate (add (negate a) b))]
    [(less-than? a b) (negate (subtract b a))]
    [else (let* [(val (new))
                 (a-parts (.> a :parts))
                 (b-parts (.> b :parts))
                 (val-parts (.> val :parts))
                 (max-parts (max (n (.> a :parts)) (n (.> b :parts))))]
            (for i 1 max-parts 1
              (push! val-parts 0))
            (for i 1 max-parts 1
              (with (new-part (- (or (nth a-parts i) 0) (or (nth b-parts i) 0) (nth val-parts i)))
                (.<! val-parts i (mod new-part part-max))
                (when (< new-part 0) ; carry
                  (.<! val-parts (+ i 1) 1))))
            (trim! val)
            val)]))

(defun multiply (a b)
  "Returns A multiplied by B."
  (cond
    [(and (= (type a) num-tag) (/= (type b) num-tag)) (multiply a (new b))]
    [(and (/= (type a) num-tag) (= (type b) num-tag)) (multiply (new a) b)]
    [(and (.> a :sign) (.> b :sign)) (multiply (negate a) (negate b))]
    [(and (not (.> a :sign)) (.> b :sign)) (negate (multiply a (negate b)))]
    [(and (.> a :sign) (not (.> b :sign))) (negate (multiply (negate a) b))]
    [(less-than? a b) (multiply b a)]
    [else (let* [(val (new))
                 (a-parts (.> a :parts))
                 (b-parts (.> b :parts))
                 (r (copy a))]
            (for i 1 (n b-parts) 1
              (for j 0 (- part-bits 1) 1
                (when (= (mod (floor (/ (nth b-parts i) (expt 2 j))) 2) 1)
                  (set! val (add val r)))
                (shl! r 1)))
            val)]))

(defun div-mod (a b) :hidden
  (cond
    [(= b (new)) (error! "division by zero.")]
    [else (let* [(r (new))
                 (q (new))]
            (for i (length a) 1 -1
              (shl! r 1)
              (set! r (+ r (bit-at a i)))
              (when (>= r b)
                (set! r (- r b))
                (set! q (+ q (shl (new 1) (- i 1))))))
            (list q r))]))

(defun divide (a b)
  "Returns A divided by B."
  (cond
    [(and (= (type a) num-tag) (/= (type b) num-tag)) (divide a (new b))]
    [(and (/= (type a) num-tag) (= (type b) num-tag)) (divide (new a) b)]
    [(and (.> a :sign) (.> b :sign)) (divide (negate a) (negate b))]
    [(and (not (.> a :sign)) (.> b :sign)) (negate (divide a (negate b)))]
    [(and (.> a :sign) (not (.> b :sign))) (negate (divide (negate a) b))]
    [else (car (div-mod a b))]))

(defun modulo (a b)
  "Returns the remainder of A divided by B."
  (cond
    [(and (= (type a) num-tag) (/= (type b) num-tag)) (modulo a (new b))]
    [(and (/= (type a) num-tag) (= (type b) num-tag)) (modulo (new a) b)]
    [(and (.> a :sign) (.> b :sign)) (negate (modulo (negate a) (negate b)))]
    [(and (not (.> a :sign)) (.> b :sign)) (negate (modulo a (negate b)))]
    [(and (.> a :sign) (not (.> b :sign))) (subtract (negate b) (modulo a (negate b)))]
    [else (cadr (div-mod a b))]))

(defun power (a b)
  "Returns A to the power of B."
  (cond
    [(and (= (type a) num-tag) (/= (type b) num-tag)) (power a (new b))]
    [(and (/= (type a) num-tag) (= (type b) num-tag)) (power (new a) b)]
    [(< b (new 0)) (new 0)]
    [(= b (new 0)) (new 1)]
    [(= b (new 1)) a]
    [else
      (let* [(val a)
             (r b)]
        (while (> r (new 1))
          (set! val (* val a))
          (set! r (- r (new 1))))
        val)]))


(defun shl! (a b)
  "Shifts (modifies) A to the left by B. B should be a normal integer, not of type bigint."
  (with (a-parts (.> a :parts))
    (for i 1 b 1
      (for j (n a-parts) 1 -1
        (with (new-val (* (nth a-parts j) 2))
          (.<! a-parts j (mod new-val part-max))
          (when (>= new-val part-max) ; carry
            (if (= j (n a-parts))
              (push! a-parts 1)
              (.<! a-parts (+ j 1) (+ (nth a-parts (+ j 1)) 1)))))))))

(defun shl (a b)
  "Returns A shifted left by B. B should be a normal integer, not of type bigint."
  (with (val (copy a))
    (shl! val b)
    val))

(defun shr! (a b)
  "Shifts (modifies) A to the right by B. B should be a normal integer, not of type bigint."
  (with (a-parts (.> a :parts))
    (for i 1 b 1
      (for j 1 (n a-parts) 1
        (with (new-val (/ (nth a-parts j) 2))
          (.<! a-parts j (floor new-val))
          (when (and (/= (mod new-val 1) 0) (/= j 1)) ; carry
            (.<! a-parts (- j 1) (+ (nth a-parts (- j 1)) (expt 2 (- part-bits 1)))))))))
  (trim! a))

(defun shr (a b)
  "Returns A shifted right by B. B should be a normal integer, not of type bigint."
  (with (val (copy a))
    (shr! val b)
    val))

(defun bit-at (a bit)
  "Returns the value of the bit (0 or 1) of A at position BIT. The BIT index starts at 1."
  (if (or (< bit 1) (> bit (* (n (.> a :parts)) part-bits)))
    0
    (mod (floor (/ (nth (.> a :parts) (+ (floor (/ (- bit 1) part-bits)) 1))
                 (expt 2 (mod (- bit 1) part-bits)))) 2)))

(defun length (a)
  "Returns the amount of numerical bits needed to contain A."
  (let* [(a-parts (.> a :parts))
         (a-len (n a-parts))]
    (if (= a-len 0)
      0
      (+ (* (- a-len 1) part-bits) (floor (/ (log (nth a-parts a-len)) (log 2))) 1))))

(defun tostring (a format)
  "Converts the bigint A to a string. FORMAT is optional and can be either
    - 'd' (decimal, default),
    - 'x' (lowercase hex),
    - 'X' (uppercase hex),
    - 'o' (octal), or
    - 'b' (binary)."
  (let* [(type (if (> (n (or format "")) 0)
                 (string/char-at format (n format))
                 "d"))
         (digits (if (> (n (or format "")) 1) (tonumber (string/sub format 1 -2)) 0))
         (num->string (lambda (base size symbol)
                        (with (str (concat (reverse (map
                                                      (lambda (n)
                                                        (string/format (.. "%0" (floor (/ part-bits size)) symbol) n))
                                                      (.> a :parts)))))
                          str)))
         (str (case type
                ["x" (num->string 16 4 "x")]
                ["X" (num->string 16 4 "X")]
                ["o" (num->string 8 3 "o")]
                ["b" (concat (map (lambda (c)
                                    (if (tonumber c)
                                      (nth '("000" "001" "010" "011" "100" "101" "110" "111") (+ (tonumber c) 1))
                                      c))
                                  (string/split (num->string 8 3 "o") "")))]
                ["d" (let* [(vald (absolute a))
                            (mult (new 1))
                            (parts '())
                            (step-digits (floor (/ (log (expt 2 part-bits)) (log 10))))
                            (step-exp (expt 10 step-digits))
                            (step-format (.. "%" (string/format "%02u" step-digits) "u"))
                            (step (new (expt 10 step-digits)))]
                       (for i 1 (+ (ceil (/ (log (expt 2 (* (n (.> a :parts)) part-bits))) (log step-exp))) 1) 1
                         (push! parts (string/format step-format (or (car (.> (mod vald step) :parts)) 0)))
                         (set! vald (/ vald step)))
                       (string/concat (reverse parts)))]))]
    (while (= (string/char-at str 1) "0")
      (set! str (string/sub str 2)))
    (when (= (n str) 0)
      (set! str "0"))
    (.. (if (.> a :sign) "-" "") (string/rep "0" (- digits (n str))) str)))


(defun equals? (a b)
  "Returns true if A == B."
  (cond
    [(and (= (type a) num-tag) (/= (type b) num-tag)) (equals? a (new b))]
    [(and (/= (type a) num-tag) (= (type b) num-tag)) (equals? (new a) b)]
    [(/= (.> a :sign) (.> b :sign)) false]
    [(/= (n (.> a :parts)) (n (.> b :parts))) false]
    [else (eq? (.> a :parts) (.> b :parts))]))

(defun less-than? (a b)
  "Returns true if A < B."
  (cond
    [(and (= (type a) num-tag) (/= (type b) num-tag)) (less-than? a (new b))]
    [(and (/= (type a) num-tag) (= (type b) num-tag)) (less-than? (new a) b)]
    [(and (.> a :sign) (.> b :sign)) (less-than? (negate b) (negate a))]
    [(and (.> a :sign) (not (.> b :sign))) true]
    [(and (not (.> a :sign)) (.> b :sign)) false]
    [(/= (n (.> a :parts)) (n (.> b :parts))) (< (n (.> a :parts)) (n (.> b :parts)))]
    [else (let* [(a-parts (.> a :parts))
                 (b-parts (.> b :parts))
                 (less false)
                 (continue true)]
            (for i (n a-parts) 1 -1
              (when continue
                (let* [(a-num (nth a-parts i))
                       (b-num (nth b-parts i))]
                  (cond
                    [(> a-num b-num) (set! continue false)]
                    [(< a-num b-num) (set! continue false) (set! less true)]
                    [else nil]))))
            less)]))

(defun less-or-equal? (a b)
  "Returns true if A <= B."
  (or (equals? a b) (less-than? a b)))

(define funs :hidden
  { :copy copy
    :tostring tostring })

(define mt :hidden
  { :__index funs
    :__add add
    :__sub subtract
    :__mul multiply
    :__div divide
    :__mod modulo
    :__pow power
    :__unm negate
    :__tostring tostring
    :__eq equals?
    :__lt less-than?
    :__le less-or-equal? })

(defun new (a)
  "Creates a new bigint from A.
   A is optional and can be either a normal integer, or a string.
   A string can begin with '0x' (hex), '0o' (octal), '0b' (binary),
   otherwise it's parsed as a decimal value."
  (let* [(val (setmetatable { :tag num-tag :sign false :parts '() } mt))
         (parts (.> val :parts))
         (parse-num! (lambda (base size)
                       (with (first-char (if (= (string/char-at a 3) "-")
                                           (progn (.<! val :sign true) 4)
                                           3))
                         (for i 0 (floor (/ (- (n a) first-char) (/ part-bits size))) 1
                           (let* [(end-pos (- (n a) (* i (/ part-bits size))))
                                  (start-upos (- end-pos (- (/ part-bits size) 1)))
                                  (start-pos (if (< start-upos first-char) first-char start-upos))
                                  (p (tonumber (string/sub a start-pos end-pos) base))]
                             (if (= p nil)
                               (error! "unexpected symbol in string.")
                               (push! parts p)))))))]
    (cond
      [(= a nil) nil]
      [(= (type a) "string")
       (case (string/sub a 1 2)
         ["0x" (parse-num! 16 4)]
         ["0b" (parse-num! 2 1)]
         ["0o" (parse-num! 8 3)]
         [_ (let* [(first-char (if (= (string/char-at a 1) "-") 2 1))
                   (mult (new 1))
                   (ten (new 10))]
              (for i (n a) first-char -1
                (set! val (+ val (* (new (tonumber (string/char-at a i))) mult)))
                (set! mult (* mult ten)))
              (.<! val :sign (= (string/char-at a 1) "-")))])]
      [(tonumber a)
       (when (/= a 0)
         (let* [(n (abs a))
                (num-parts (+ (floor (/ (log n) (log 2) part-bits)) 1))]
           (.<! val :sign (< a 0))
           (for i 0 (- num-parts 1) 1
             (push! parts (floor (mod (/ n (expt part-max i)) part-max))))))]
      [else (error! (.. "string, number or nothing expected, got " (type a) "."))])
    (trim! val)
    val))
