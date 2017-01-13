(import base (defun defmacro let letrec with for if
              gensym get-idx set-idx!
              == > + -))
(import base)
(import types (assert-type!))

(defun list (&entries) entries)

(defun nth (li idx)
  (assert-type! li "list")
  (assert-type! idx "number")

  (get-idx li idx))

(defun set-nth! (li idx val)
  (assert-type! li "list")
  (assert-type! idx "number")

  (set-idx! li idx val))

(defun remove-nth! (li idx)
  (assert-type! li "list")
  (assert-type! idx "number")

  (base/remove-idx! li idx)
  (set-idx! li "n" (- (get-idx li "n") 1)))

(defun # (li)
  (assert-type! li "list")
  (base/# li))

(defun car (li) (nth li 1))

(defun slice (li start finish)
  (assert-type! li "list")
  (assert-type! start "number")
  (base/slice li start finish))

(defun cdr (li)
  (assert-type! li "list")
  (slice li 2))

;; Push an entry on to the end of this list
(defun push-cdr! (li val)
  (assert-type! li "list")
  (with (len (+ (base/# li) 1))
    (set-idx! li "n" len)
    (set-idx! li len val)
    li))

;; Remove the last entry from this list
(defun pop-last! (li)
  (assert-type! li "list")
  (set-idx! li (base/# li) nil)
  (set-idx! li "n" (- (base/# li) 1))
  li)

;; Checks this is a list and is empty
(defun nil? (li) (== (# li) 0))

;; Perform an action for every entry in the list
(defmacro for-each (var lst &body)
  (let ((ctr' (gensym))
        (lst' (gensym)))
       `(with (,lst' ,lst)
         (for ,ctr' 1 (# ,lst') 1 (with (,var (get-idx ,lst' ,ctr')) ,@body)))))

;; Apply a function for every entry in the list
(defun each (fn li)
  (assert-type! fn "function")
  (assert-type! li "list")

  (for i 1 (# li) 1 (fn (get-idx li i))))

(defun map (fn li)
  (assert-type! fn "function")
  (assert-type! li "list")

  (base/map fn li))

(defun traverse (li fn) (map fn li))

(defun last (xs) (nth xs (# xs)))

(defun caar (x) (car (car x)))
(defun cadr (x) (nth x 2))
(defun cdar (x) (cdr (car x)))
(defun cddr (x) (slice x 3))

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

;; Return a new list where only the predicate matches
(defun filter (fn li)
  (assert-type! fn "function")
  (assert-type! li "list")

  (with (out '())
    (for i 1 (base/# li 1) 1 (let ((item (get-idx li i)))
      (when (fn item) (push-cdr! out item))))
    out))

;; Determine whether any element matches a predicate
(defun any (fn li)
  (assert-type! fn "function")
  (assert-type! li "list")

  (letrec ((any-impl (lambda (i)
                       (cond
                         ((> i (base/# li)) false)
                         ((fn (get-idx li i)) true)
                         (true (any-impl (+ i 1)))))))
    (any-impl 1)))

(defun elem (x li)
  (any (lambda (e) (== x e)) li))

;; Determine whether all elements match a predicate
(defun all (fn li)
  (assert-type! fn "function")
  (assert-type! li "list")

  (letrec ((all-impl (lambda(i)
                       (cond
                         ((> i (base/# li)) true)
                         ((fn (get-idx li i)) (all-impl (+ i 1)))
                         (true false)))))
    (all-impl 1)))

;; Fold left across a list
(defun foldl (fn accum li)
  (assert-type! fn "function")
  (assert-type! li "list")

  (for i 1 (base/# li) 1
    (set! accum (fn accum (get-idx li i))))
  accum)

;; Fold right across a list
(defun foldr (fn accum li)
  (assert-type! fn "function")
  (assert-type! li "list")

  (for i (# li) 1 -1
    (set! accum (fn (get-idx li i) accum)))
  accum)
