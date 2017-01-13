(import base (defmacro defun with for let when if
              get-idx set-idx! error! empty-struct
              = % - + #))

(import list)
(import types)
(import string)

(define-native getmetatable)
(define-native setmetatable)

;; Chain a series of index accesses together
(defmacro .> (x &keys)
  (with (res x)
    (list/for-each key keys (set! res `(get-idx ,res ,key)))
    res))

(defmacro .<! (x &keys value)
  (with (res x)
    ; I lied, the last entry of keys contains the value to set
    (for i 1 (- (# keys) 1) 1
      (with (key (get-idx keys i))
        (set! res `(get-idx ,res ,key))))
    `(set-idx! ,res ,(get-idx keys (# keys) 1) ,value)))

(defun struct (&keys)
  (when (= (% (# keys) 1) 1)
    (error! "Expected an even number of arguments to struct" 2))
  (let ((contents (lambda (key)
                    (string/sub (get-idx key "contents") 2)))
        (out (empty-struct)))
    (for i 1 (# keys) 2
      (let ((key (get-idx keys i))
            (val (get-idx keys (+ 1 i))))
        (set-idx! out (if (types/key? key) (contents key) key) val)))
    out))
