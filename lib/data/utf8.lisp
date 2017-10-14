"An equivalent of the string/ library, but for UTF-8 encoded Unicode
 strings instead."

(defun byte-length (x (i 1))
  "Determine the byte length of the UTF-8 sequence starting at position
   I (or 1) of the byte-string X, also verifying for validity."
  (case (string/byte (string/char-at x i))
    [nil 0]
    [(_ :when (and (> it 0) (<= it 127)))
     1]
    [(_ :when (and (>= it 194) (<= it 223)))
     (case (string/byte x (+ i 1))
       [(_ :when (and (< it 128)
                      (> it 191)))
        (error! "Invalid UTF-8 sequence")]
       [nil (error! "UTF-8 sequence (2 bytes) terminated prematurely")]
       [_ 2])]
    [(?c :when (and (>= it 224) (<= it 239)))
     (let* [((a b) (string/byte x (+ 1 i) (+ 2 i)))]
       (unless (and a b)
         (error! "UTF-8 sequence (3 bytes) terminated prematurely"))
       (cond
         [(or (and (= c 224) (or (< a 160)
                                 (> a 192)))
              (and (= c 237) (or (< a 128)
                                 (> a 159)))
              (or (< a 128) (> a 191))
              (or (< b 128) (> b 191)))
          (error! "Invalid UTF-8 sequence")]
         [else 3]))]
    [(?chr :when (and (>= it 240) (<= it 244)))
     (let* [((a b c)
             (string/byte x (+ 1 i) (+ 3 i)))]
       (unless (and a b c)
         (error! "UTF-8 sequence (4 bytes) terminated prematurely"))
       (cond
         [(or (and (= chr 240) (or (< a 144)
                                   (> a 192)))
              (and (= chr 244) (or (< a 128)
                                   (> a 143)))
              (or (< a 128) (> a 191))
              (or (< b 128) (> b 191))
              (or (< c 128) (> c 191)))
          (error! "Invalid UTF-8 sequence")]
         [else 4]))]))

(defun decode-utf8 (str)
  "Decode the string STR to a list of code points."
  (case (byte-length str 1)
    [1 (cons (string/byte str 1) (decode-utf8 (string/sub str 2)))]
    [2 (let* [((b0 b1) (string/byte str 1 2))
              (code0 (- b0 #xC0))
              (code1 (- b1 #x80))]
         (cons (+ (* code0 (expt 2 6)) code1)
               (decode-utf8 (string/sub str 3))))]
    [3 (let* [((b0 b1 b2) (string/byte str 1 3))
              (code0 (- b0 #xE0))
              (code1 (- b1 #x80)) (code2 (- b2 #x80))]
         (cons (+ (* code0 (expt 2 12))
                  (* code1 (expt 2 6))
                  code2)
               (decode-utf8 (string/sub str 4))))]
    [4 (let* [((b0 b1 b2 b3) (string/byte str 1 4))
              (code0 (- b0 #xF0)) (code1 (- b1 #x80))
              (code2 (- b2 #x80)) (code3 (- b3 #x80))]
         (cons (+ (* code0 (expt 2 18))
                  (* code1 (expt 2 12))
                  (* code2 (expt 2 6))
                  code3)
               (decode-utf8 (string/sub str 5))))]
    [0 (list)]))


(defun quot (a b &rest) :hidden
  (case rest
    [() (math/floor (/ a b))]
    [(?x . ?y) (math/floor (apply quot (/ a b) x y))]))

(defun encode-one-utf8 (ucp) :hidden
  (cond
    [(<= ucp #x7F) (string/char ucp)]
    [(<= ucp #x7FF)
     (string/char (+ #xC0 (quot ucp #x40))
                  (+ #x80 (mod ucp #x40)))]
    [(<= ucp #xFFFF)
     (string/char (+ #xE0 (quot ucp #x1000))
                  (+ #x80 (mod (quot ucp #x40) #x40))
                  (+ #x80 (mod ucp #x40)))]
    [(<= ucp #x10FFFF)
     (let* [(c3 (+ #x80 (mod ucp #x40)))
            (c2 (+ #x80 (mod (quot ucp #x40) #x40)))
            (c1 (+ #x80 (mod (quot ucp #x40 #x40) #x40)))
            (c0 (+ #xF0 (mod (quot ucp #x40 #x40 #x40) #x40)))]
       (string/char c0 c1 c2 c3))]))

(defun encode-utf8 (cps)
  "Encode the list of code points CPS to a byte string"
  (concat (map encode-one-utf8 cps) ""))

(defun utf8-length (str)
  "Return the number of characters in the string STR"
  (loop [(cnt 0)
         (bp 1)]
    [(>= bp (n str)) cnt]
    (recur (succ cnt) (+ bp (byte-length str bp)))))

(defun utf8-sub (s i (j math/huge))
  "Slice the string S, beginning at the character I and ending at the
   J'th character."
  (let* [(bytes (n s))
         (len (or (and (>= i 0) (>= j 0) 0) (utf8-length s)))
         ((start end)
          (values-list
            (or (and (>= i 0) i) (+ len i 1))
            (or (and (>= j 0) j) (+ len j 1))))]
    (if (> start end)
      ""
      (loop [(startb 1) (endb bytes)
             (k 0)      (pos 1)]
        [(or (= k end) (> pos bytes))
         (when (= k end) (set! endb (- pos 1)))
         (string/sub s
                     (if (> start k) (+ startb 1) startb)
                     (if (< end 1) 0 endb))]
        (let* [(k (succ k))]
          (recur (if (= k start) pos startb) endb
                 k (+ pos (byte-length s pos))))))))

