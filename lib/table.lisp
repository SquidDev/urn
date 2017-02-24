(import base (defmacro defun let* when if cons list unless debug
              progn get-idx set-idx! error = % - + # or for with ! unpack))
(import lua/string (sub))
(import lua/table (empty-struct iter-pairs) :export)
(import lua/basic (getmetatable setmetatable next) :export)
(import type (nil? list? eq? key?))
(import list ())
(import binders (let))

(defun assoc (list key or-val)
  "Return the value given by KEY in the association list LIST, or, in
   the case that it does not exist, the value OR-VAL, which can be nil."
  (cond
    [(or (! (list? list))
         (nil? list))
     or-val]
    [(eq? (caar list) key)
     (cadar list)]
    [true (assoc (cdr list) key or-val)]))

(defun assoc? (list key)
  "Check that KEY is bound in the association list LIST."
  (cond
    [(or (! (list? list))
         (nil? list))
     false]
    [(eq? (caar list) key)
     true]
    [true (assoc? (cdr list) key)]))

(defun insert (list_ key val)
  "Extend the association list LIST_ by inserting VAL, bound to the key KEY."
  (cons (list key val) list_))

(defun assoc->struct (list)
  "Convert the association list LIST into a structure. Much like [[assoc]],
   in the case there are several values bound to the same key, the first
   value is chosen."
  (let [(ret '())]
    (traverse list
      (lambda (x)
        (let [(hd (cond
                    [(key? (car x)) (get-idx (car x) "value")]
                    [true (car x)]))]
          (if (! (get-idx ret hd))
            (set-idx! ret hd (cadr x))
            nil))))
    ret))

(defun struct->assoc (tbl)
  "Convert the structure TBL into an association list. Note that
   `(eq? x (struct->assoc (assoc->struct x)))` is not guaranteed,
   because duplicate elements will be removed."
  (with (out '())
    (iter-pairs tbl (lambda (k v)
                      (push-cdr! out (list k v))))
    out))

;; Chain a series of index accesses together
(defmacro .> (x &keys)
  "Index the structure X with the sequence of accesses given by KEYS."
  (with (res x)
    (for-each key keys (set! res `(get-idx ,res ,key)))
    res))

(defmacro .<! (x &keys value)
  "Set the value at KEYS in the structure X to VALUE."
  (with (res x)
    (for i 1 (- (# keys) 1) 1
      (with (key (get-idx keys i))
        (set! res `(get-idx ,res ,key))))
    `(set-idx! ,res ,(get-idx keys (# keys) 1) ,value)))

(defun struct (&keys)
  "Return the structure given by the list of pairs XS. Note that, in contrast
   to variations of [[LET]], the pairs are given \"unpacked\": Instead of invoking
   ```cl
   (struct [(:foo bar)])
   ```
   or
   ```cl
   (struct {:foo bar})
   ```
   you must instead invoke it like
   ```cl
   (struct :foo bar)
   ```"
  (if (= (% (# keys) 1) 1)
    (error "Expected an even number of arguments to struct" 2)
    '())
  (let* [(contents (lambda (key)
                     (get-idx key "contents")))
         (out (empty-struct))]
    (for i 1 (# keys) 2
      (let ((key (get-idx keys i))
            (val (get-idx keys (+ 1 i))))
        (set-idx! out (if (key? key) (contents key) key) val)))
    out))

(defun empty-struct? (xs)
  "Check that XS is the empty struct."
  (! (next xs)))

(defun #keys (st)
  "Return the number of keys in the structure ST."
  (with (cnt 0)
    (iter-pairs st (lambda () (set! cnt (+ cnt 1))))
    cnt))
