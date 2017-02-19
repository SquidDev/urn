(import base (defun defmacro when let* rawset
              rawget car cdr and cons for gensym
              pretty print error tostring or
              if # + - >= = ! with))

(import lua/table)
(import type (list? nil?))

(defun foldr (f z xs)
  (cond
    [(nil? xs) z]
    [true (let* [(head (car xs))
                 (tail (cdr xs))]
            (f head (foldr f z tail)))]))

(defun map (f xs)
  (cond
    [(nil? xs) xs]
    [true (let* [(head (car xs))
                 (tail (cdr xs))]
            (cons (f head) (map f tail)))]))

(defun filter (p xs)
  (cond
    [(nil? xs) xs]
    [true (let* [(head (car xs))
                 (tail (cdr xs))]
            (if (p head)
              (cons head (filter p tail))
              (filter p tail)))]))

(defun any (p xs)
  (foldr (lambda (x y) (or x y)) false (map p xs)))

(defun all (p xs)
  (foldr (lambda (x y) (and x y)) true (map p xs)))

(defun elem? (x xs)
  (any (lambda (y) (= x y)) xs))

(defun prune (xs)
  (filter (lambda (x) (! (nil? x))) xs))

(defun traverse (xs f) (map f xs))
(defun last (xs) (rawget xs (# xs)))

(define nth rawget)

(defun push-cdr! (xs val)
  (let* [(len (+ (# xs) 1))]
    (rawset xs "n" len)
    (rawset xs len val)
    xs))

(defun pop-last! (xs)
  (rawset xs (# xs) nil)
  (rawset xs "n" (- (# xs) 1))
  xs)

(defun remove-nth! (li idx)
  (rawset li "n" (- (rawget li "n") 1))
  (lua/table/remove li idx))

(defmacro for-each (var lst &body)
  (let* [(ctr' (gensym))
         (lst' (gensym))]
    `(with (,lst' ,lst)
       (for ,ctr' 1 (# ,lst') 1 (with (,var (rawget ,lst' ,ctr')) ,@body)))))

;; AUTOMATICALLY GENERATED
;; DO NOT EDIT please.
(defun caar (x) (car (car x)))
(defun cadr (x) (car (cdr x)))
(defun cdar (x) (cdr (car x)))
(defun cddr (x) (cdr (cdr x)))

(defun caaar (x) (car (car (car x))))
(defun caadr (x) (car (car (cdr x))))
(defun cadar (x) (car (cdr (car x))))
(defun caddr (x) (car (cdr (cdr x))))
(defun cdaar (x) (cdr (car (car x))))
(defun cdadr (x) (cdr (car (cdr x))))
(defun cddar (x) (cdr (cdr (car x))))
(defun cdddr (x) (cdr (cdr (cdr x))))
(defun caaaar (x) (car (car (car (car x)))))
(defun caaadr (x) (car (car (car (cdr x)))))
(defun caadar (x) (car (car (cdr (car x)))))
(defun caaddr (x) (car (car (cdr (cdr x)))))
(defun cadaar (x) (car (cdr (car (car x)))))
(defun cadadr (x) (car (cdr (car (cdr x)))))
(defun caddar (x) (car (cdr (cdr (car x)))))
(defun cadddr (x) (car (cdr (cdr (cdr x)))))
(defun cdaaar (x) (cdr (car (car (car x)))))
(defun cdaadr (x) (cdr (car (car (cdr x)))))
(defun cdadar (x) (cdr (car (cdr (car x)))))
(defun cdaddr (x) (cdr (car (cdr (cdr x)))))
(defun cddaar (x) (cdr (cdr (car (car x)))))
(defun cddadr (x) (cdr (cdr (car (cdr x)))))
(defun cdddar (x) (cdr (cdr (cdr (car x)))))
(defun cddddr (x) (cdr (cdr (cdr (cdr x)))))

(defun cars (xs) (map car xs))
(defun cdrs (xs) (map cdr xs))
(defun caars (xs) (map caar xs))
(defun cadrs (xs) (map cadr xs))
(defun cdars (xs) (map cdar xs))
(defun cddrs (xs) (map cddr xs))
(defun caaars (xs) (map caaar xs))
(defun caadrs (xs) (map caadr xs))
(defun cadars (xs) (map cadar xs))
(defun caddrs (xs) (map caddr xs))
(defun cdaars (xs) (map cdaar xs))
(defun cdadrs (xs) (map cdadr xs))
(defun cddars (xs) (map cddar xs))
(defun cdddrs (xs) (map cdddr xs))
(defun caaaars (xs) (map caaaar xs))
(defun caaadrs (xs) (map caaadr xs))
(defun caadars (xs) (map caadar xs))
(defun caaddrs (xs) (map caaddr xs))
(defun cadaars (xs) (map cadaar xs))
(defun cadadrs (xs) (map cadadr xs))
(defun caddars (xs) (map caddar xs))
(defun cadddrs (xs) (map cadddr xs))
(defun cdaaars (xs) (map cdaaar xs))
(defun cdaadrs (xs) (map cdaadr xs))
(defun cdadars (xs) (map cdadar xs))
(defun cdaddrs (xs) (map cdaddr xs))
(defun cddaars (xs) (map cddaar xs))
(defun cddadrs (xs) (map cddadr xs))
(defun cdddars (xs) (map cdddar xs))
(defun cddddrs (xs) (map cddddr xs))
