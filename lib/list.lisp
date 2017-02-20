(import base (defun defmacro when let* set-idx!
              get-idx and cons for gensym
              pretty print error tostring or
              debug if # + - >= = ! with))
(import base)
(import lua/table)
(import type (list? nil? assert-type! exists? falsey?))

(defun car (x)
  "Return the first element of the array X"
  (assert-type! x list)
  (base/car x))

(defun cdr (x)
  "Drop the first element of the array X, and return the rest."
  (assert-type! x list)
  (if (nil? x)
    '()
    (base/cdr x)))

(defun foldr (f z xs)
  "Fold over the list XS using the binary operator F and the starting value Z."
  (assert-type! f function)
  (assert-type! xs list)
  (cond
    [(nil? xs) z]
    [true (let* [(head (car xs))
                 (tail (cdr xs))]
            (f head (foldr f z tail)))]))

(defun map (f xs acc)
  "Map over the list XS using the unary function F. The parameter ACC is for internal use only."
  (assert-type! f function)
  (assert-type! xs list)
  (cond
    [(! (exists? acc)) (map f xs '())]
    [(nil? xs) (reverse acc)]
    [true (map f (cdr xs) (cons (f (car xs)) acc))]))

(defun filter (p xs acc)
  "Filter the list XS using the predicate P. The parameter ACC is for internal use only."
  (assert-type! p function)
  (assert-type! xs list)
  (cond
    [(falsey? acc) (filter p xs '())]
    [(nil? xs) (reverse acc)]
    [true (if (p (car xs))
            (filter p (cdr xs) (cons (car xs) acc))
            (filter p (cdr xs) acc))]))

(defun any (p xs)
  "Test for the existence of any element in XS matching the predicate P."
  (assert-type! p function)
  (assert-type! xs list)
  (foldr (lambda (x y) (or x y)) false (map p xs)))

(defun all (p xs)
  "Test if all elements of XS match the predicate P."
  (assert-type! p function)
  (assert-type! xs list)
  (foldr (lambda (x y) (and x y)) true (map p xs)))

(defun elem? (x xs)
  "Test if X is present in the list XS."
  (assert-type! xs list)
  (any (lambda (y) (= x y)) xs))

(defun prune (xs)
  "Remove values matching the predicate `nil?' from the list XS"
  (assert-type! xs list)
  (filter (lambda (x) (! (nil? x))) xs))

(defun traverse (xs f)
  "An alias for `map' with the arguments XS and F flipped."
  (map f xs))

(defun last (xs)
  "Return the last element of the list XS. (Counterintutively, this function runs in constant time)."
  (assert-type! xs list)
  (get-idx xs (# xs)))

(define nth get-idx)

(defun push-cdr! (xs val)
  "Mutate the list XS, adding VAL to its end."
  (assert-type! xs list)
  (let* [(len (+ (# xs) 1))]
    (set-idx! xs "n" len)
    (set-idx! xs len val)
    xs))

(defun pop-last! (xs)
  "Mutate the list XS, removing and returning its last element."
  (assert-type! xs list)
  (set-idx! xs (# xs) nil)
  (set-idx! xs "n" (- (# xs) 1))
  xs)

(defun remove-nth! (li idx)
  "Mutate the list LI, removing the value at IDX and returning it."
  (assert-type! li list)
  (set-idx! li "n" (- (get-idx li "n") 1))
  (lua/table/remove li idx))

(defmacro for-each (var lst &body)
  "Perform the set of actions BODY for all values in LST, binding the current value to VAR."
  (assert-type! var symbol)
  (let* [(ctr' (gensym))
         (lst' (gensym))]
    `(with (,lst' ,lst)
       (for ,ctr' 1 (# ,lst') 1 (with (,var (get-idx ,lst' ,ctr')) ,@body)))))

(defun append (xs ys)
  "Concatenate XS and YS."
  (cond
    [(nil? xs) ys]
    [true (cons (car xs) (append (cdr xs) ys))]))

(defun flatten (xss)
  "Concatenate all the lists in XSS. XSS must not contain elements which are not lists."
  (foldr append '() xss)) 

(defun range (start end acc)
  "Build a list from START to END. This function is tail recursive, and uses the parameter ACC as an accumulator."
  (cond
    [(! (exists? acc)) (range start end '())]
    [(>= start end) (reverse (cons start acc))]
    [true (range (+ 1 start) end (cons start acc))]))

(defun reverse (xs acc)
  "Reverse the list XS, using the accumulator ACC."
  (cond
    [(! (exists? acc)) (reverse xs '())]
    [(nil? xs) acc]
    [true (reverse (cdr xs) (cons (car xs) acc))]))

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
