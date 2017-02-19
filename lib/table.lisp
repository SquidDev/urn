(import base (defmacro defun let* when if car cdr cons list
              rawget rawset error = % - + # or for with ! unpack))
(import lua/string (sub))
(import lua/table (empty-struct iter-pairs) :export)
(import lua/basic (getmetatable setmetatable next) :export)
(import type (nil? list? eq? key?))
(import list ())
(import binders (let))

(defun assoc (list key or-val)
  (cond
    [(or (! (list? list))
         (nil? list))
     or-val]
    [(eq? (caar list) key)
     (cadar list)]
    [true (assoc (cdr list) key or-val)]))

(defun assoc? (list key)
  (cond
    [(or (! (list? list))
         (nil? list))
     false]
    [(eq? (caar list) key)
     true]
    [true (assoc? (cdr list) key)]))

(defun insert (list_ key val)
  (cons (list key val) list_))

(defun assoc->struct (list)
  (let [(ret '())]
    (traverse list
      (lambda (x)
        (rawset ret (car x) (cadr x))))
    ret))

;; Chain a series of index accesses together
(defmacro .> (x &keys)
  (with (res x)
    (for-each key keys (set! res `(rawget ,res ,key)))
    res))

(defmacro .<! (x &keys value)
  (with (res x)
    (for i 1 (- (# keys) 1) 1
      (with (key (rawget keys i))
        (set! res `(rawget ,res ,key))))
    `(rawset ,res ,(rawget keys (# keys) 1) ,value)))

(defun struct (&keys)
  (if (= (% (# keys) 1) 1)
    (error "Expected an even number of arguments to struct" 2)
    '())
  (let* [(contents (lambda (key)
                     (sub (rawget key "contents") 2)))
         (out (empty-struct))]
    (for i 1 (# keys) 2
      (let ((key (rawget keys i))
            (val (rawget keys (+ 1 i))))
        (rawset out (if (key? key) (contents key) key) val)))
    out))

(defun empty-struct? (xs)
  (! (next xs)))
