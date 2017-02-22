(import base (defmacro defun let* when if cons list unless debug
              progn get-idx set-idx! error = % - + # or for with ! unpack))
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
        (let [(hd (cond
                    [(key? (car x)) (get-idx (car x) "value")]
                    [true (car x)]))]
          (if (! (get-idx ret hd))
            (set-idx! ret hd (cadr x))
            nil))))
    ret))

(defun struct->assoc (tbl)
  (with (out '())
    (iter-pairs tbl (lambda (k v)
                      (push-cdr! out (list k v))))
    out))

;; Chain a series of index accesses together
(defmacro .> (x &keys)
  (with (res x)
    (for-each key keys (set! res `(get-idx ,res ,key)))
    res))

(defmacro .<! (x &keys value)
  (with (res x)
    (for i 1 (- (# keys) 1) 1
      (with (key (get-idx keys i))
        (set! res `(get-idx ,res ,key))))
    `(set-idx! ,res ,(get-idx keys (# keys) 1) ,value)))

(defun struct (&keys)
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
  (! (next xs)))

(defun #keys (st)
  (with (cnt 0)
    (iter-pairs st (lambda () (set! cnt (+ cnt 1))))
    cnt))
