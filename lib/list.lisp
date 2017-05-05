"List manipulation functions.

 These include several often-used functions for manipulation of lists,
 including functional programming classics such as [[map]] and [[foldl]]
 and useful patterns such as [[accumulate-with]].

 Most of these functions are tail-recursive unless noted, which means
 they will not blow up the stack. Along with the property of
 tail-recursiveness, these functions also have favourable performance
 characteristics.

 ## Glossary:
 - **Constant time** The function runs in the same time regardless of the
   size of the input list.
 - **Linear time** The runtime of the function is a linear function of
   the size of the input list.
 - **Logarithmic time** The runtime of the function grows logarithmically
   in proportion to the size of the input list.
 - **Exponential time** The runtime of the function grows exponentially
   in proportion to the size of the input list. This is generally a bad
   thing."

(import base (defun defmacro when let* set-idx!
              get-idx for gensym -or slice /=
              pretty print error tostring  -and
              unpack debug if # + - >= = ! with
              apply and progn ..))
(import base)
(import lua/table)
(import type (nil? list? empty? assert-type! exists? falsey? eq? type))
(import lua/math (min max))

(defun car (x)
  "Return the first element present in the list X. This function operates
   in constant time.

   ### Example:
   ```cl
   > (car '(1 2 3))
   out = 1
   ```"
  (assert-type! x list)
  (base/car x))

(defun cdr (x)
  "Return the list X without the first element present. In the case that
   X is nil, the empty list is returned. Due to the way lists are
   represented internally, this function runs in linear time.

   ### Example:
   ```cl
   > (cdr '(1 2 3))
   out = (2 3)
   ```"
  (assert-type! x list)
  (if (empty? x)
    '()
    (base/cdr x)))

(defun take (xs n)
  "Take the first N elements of the list XS.

   ### Example:
   ```cl
   > (take '(1 2 3 4 5) 2)
   out = (1 2)
   ```"
  (slice xs 1 n))

(defun drop (xs n)
  "Remove the first N elements of the list XS.

   ### Example:
   ```cl
   > (drop '(1 2 3 4 5) 2)
   out = (3 4 5)
   ```"
  (slice xs (+ n 1) nil))

(defun snoc (xss &xs)
  "Return a copy of the list XS with the element XS added to its end.
   This function runs in linear time over the two input lists: That is,
   it runs in O(n+k) time proportional both to `(# XSS)` and `(# XS)`.

   ### Example:
   ```cl
   > (snoc '(1 2 3) 4 5 6)
   out = (1 2 3 4 5 6)
   ``` "
  `(,@xss ,@xs))

(defun cons (&xs xss)
  "Return a copy of the list XSS with the elements XS added to its head.

   ### Example:
   ```cl
   > (cons 1 2 3 '(4 5 6))
   out = (1 2 3 4 5 6)
   ```"
  `(,@xs ,@xss))

(defun foldl (f z xs)
  "Accumulate the list XS using the binary function F and the zero
   element Z.  This function is also called `reduce` by some authors. One
   can visualise `(foldl f z xs)` as replacing the [[cons]] operator in
   building lists with F, and the empty list with Z.

   Consider:
   - `'(1 2 3)` is equivalent to `(cons 1 (cons 2 (cons 3 '())))`
   - `(foldl + 0 '(1 2 3))` is equivalent to `(+ 1 (+ 2 (+ 3 0)))`.

   ### Example:
   ```cl
   > (foldl append '() '((1 2) (3 4)))
   out = (1 2 3 4)
   ; equivalent to (append '(1 2) (append '(3 4) '()))
   ```"
  (assert-type! f function)
  (assert-type! xs list)
  (let* [(accum z)]
    (for i 1 (# xs) 1
      (set! accum (f accum (nth xs i))))
    accum))

(defun map (fn &xss)
  "Iterate over all the successive cars of XSS, producing a single list
   by applying FN to all of them. For example:

   ### Example:
   ```cl
   > (map list '(1 2 3) '(4 5 6) '(7 8 9))
   out = ((1 4 7) (2 5 8) (3 6 9))
   > (map succ '(1 2 3))
   out = (2 3 4)
   ```"
  (let* [(lengths (let* [(out '())]
                    (for i 1 (# xss) 1
                      (if (! (list? (nth xss i)))
                        (error (.. "not a list: " (pretty (nth xss i))
                                   " (it's a " (type (nth xss i)) ")"))
                        true)
                      (push-cdr! out (# (nth xss i))))
                    out))
         (out '())]
    (for i 1 (apply min lengths) 1
      (push-cdr! out (apply fn (nths xss i))))
    out))

(defun maybe-map (fn &xss)
  "Iterate over all successive cars of XSS, producing a single list by
   applying FN to all of them, while discarding any `nil`s.

   ### Example:
   ```cl
   > (maybe-map (lambda (x)
                  (if (even? x)
                    nil
                    (succ x)))
                (range 1 10))
   out = (2 4 6 8 10)
   ```"
  (let* [(lenghts (let* [(out '())]
                    (for i 1 (# xss) 1
                      (if (! (list? (nth xss i)))
                        (error (.. "not a list: " (pretty (nth xss i))
                                   " (it's a " (type (nth xss i)) ")"))
                        true)
                      (push-cdr! out (# (nth xss i))))
                    out))
         (out '())]
    (for i 1 (apply min lenghts) 1
      (let* [(vl (apply fn (nths xss i)))]
        (if (/= vl nil)
          (push-cdr! out vl)
          nil)))
    out))


(defun flat-map (fn &xss)
  "Map the function FN over the lists XSS, then flatten the result
   lists.

   ### Example:
   ```cl
   > (flat-map list '(1 2 3) '(4 5 6))
   out = 1 4 2 5 3 6
   ```"
  (flatten (map fn (unpack xss))))

(defun filter (p xs)
  "Return the list of elements of XS which match the predicate P.

   ### Example:
   ```cl
   > (filter even? '(1 2 3 4 5 6))
   '(2 4 6)
   ```"
  (assert-type! p function)
  (assert-type! xs list)
  (let* [(out '())]
    (for i 1 (# xs) 1
      (with (x (nth xs i))
        (when (p x) (push-cdr! out x))))
    out))

(defun any (p xs)
  "Check for the existence of an element in XS that matches the predicate
   P.

   ### Example:
   ```cl
   > (any exists? '(nil 1 \"foo\"))
   true
   ```"
  (assert-type! p function)
  (assert-type! xs list)
  (accumulate-with p -or false xs))

(defun none (p xs)
  "Check that no elements in XS match the predicate P.

   ### Example:
   ```cl
   > (none nil? '(\"foo\" \"bar\" \"baz\"))
   true
   ```"
  (! (any p xs)))

(defun \\ (xs ys)
  "The difference between XS and YS (non-associative.)

   Example:
   ```
   > (\\ '(1 2 3) '(1 3 5 7))
   out = (2)
   ```"
  (filter (lambda (x)
            (! (elem? x ys)))
          xs))

(defun nub-from (xs ys) :hidden
  (cond
    [(empty? xs) '()]
    [true
      (let* [(out '())]
        (for i 1 (# xs) 1
          (if (elem? (nth xs i) ys)
            nil ;; pass
            (progn
              (push-cdr! out (nth xs i))
              (push-cdr! ys (nth xs i)))))
        out)]))

(defun nub (xs)
  "Remove duplicate elements from XS.

   Example:
   ```
   > (nub '(1 1 2 2 3 3))
   out = (1 2 3)
   ```"
  ;; TODO: This implementation runs in O(shit) time.
  ;; We don't want that :(
  (nub-from xs '()))

(defun union (xs ys)
  "Set-like union of XS and YS.

   Example:
   ```
   > (union '(1 2 3 4) '(1 2 3 4 5))
   out = (1 2 3 4 5)
   ```"
  (nub (append xs ys)))

(defun all (p xs)
  "Test if all elements of XS match the predicate P.

   ### Example:
   ```cl
   > (all symbol? '(foo bar baz))
   true
   > (all number? '(1 2 foo))
   false
   ```"
  (assert-type! p function)
  (assert-type! xs list)
  (accumulate-with p -and true xs))

(defun elem? (x xs)
  "Test if X is present in the list XS.

   ### Example:
   ```cl
   > (elem? 1 '(1 2 3))
   true
   > (elem? 'foo '(1 2 3))
   false
   ```"
  (assert-type! xs list)
  (any (lambda (y) (eq? x y)) xs))

(defun prune (xs)
  "Remove values matching the predicates [[empty?]] or [[nil?]] from
   the list XS.

   ### Example:
   ```cl
   > (prune '(() nil 1 nil () 2))
   out = (1 2)
   ```"
  (assert-type! xs list)
  (filter (lambda (x) (and (! (nil? x)) (! (empty? x)))) xs))

(defun traverse (xs f)
  :deprecated "Use map instead."
  "An alias for [[map]] with the arguments XS and F flipped.

   ### Example:
   ```cl
   > (traverse '(1 2 3) succ)
   out = (2 3 4)
   ```"
  (map f xs))

(defun last (xs)
  "Return the last element of the list XS.
   Counterintutively, this function runs in constant time.

   ### Example:
   ```cl
   > (last (range 1 100))
   out = 100
   ```"
  (assert-type! xs list)
  (get-idx xs (# xs)))

(defun init (xs)
  "Return the list XS with the last element removed.
   This is the dual of LAST.

   ### Example:
   ```cl
   > (init (range 1 10))
   out = '(1 2 3 4 5 6 7 8 9)
   ```"
  (assert-type! xs list)
  (slice xs 1 (- (# xs) 1)))

(defun nth (xs idx)
  "Get the IDX th element in the list XS. The first element is 1.
   This function runs in constant time.

   ### Example:
   ```cl
   > (nth (range 1 100) 10)
   out = 10
   ```"
  (get-idx xs idx))

(defun nths (xss idx)
  "Get the IDX-th element in all the lists given at XSS. The first
   element is1.

   ### Example:
   ```cl
   > (nths '((1 2 3) (4 5 6) (7 8 9)) 2)
   out = (2 5 8)
   ```"
  (let* [(out '())]
    (for i 1 (# xss) 1
      (push-cdr! out (nth (nth xss i) idx)))
    out))

(defun push-cdr! (xs val)
  "Mutate the list XS, adding VAL to its end.

   ### Example:
   ```cl
   > (define list '(1 2 3))
   > (push-cdr! list 4)
   '(1 2 3 4)
   > list
   out = (1 2 3 4)
   ```"
  (assert-type! xs list)
  (let* [(len (+ (# xs) 1))]
    (set-idx! xs "n" len)
    (set-idx! xs len val)
    xs))

(defun pop-last! (xs)
  "Mutate the list XS, removing and returning its last element.

   ### Example:
   ```cl
   > (define list '(1 2 3))
   > (pop-last! list)
   3
   > list
   out = (1 2)
   ``` "
  (assert-type! xs list)
  (with (x (get-idx xs (# xs)))
    (set-idx! xs (# xs) nil)
    (set-idx! xs "n" (- (# xs) 1))
    x))

(defun remove-nth! (li idx)
  "Mutate the list LI, removing the value at IDX and returning it.

   ### Example:
   ```cl
   > (define list '(1 2 3))
   > (remove-nth! list 2)
   2
   > list
   out = (1 3)
   ``` "
  (assert-type! li list)
  (set-idx! li "n" (- (get-idx li "n") 1))
  (lua/table/remove li idx))

(defmacro for-each (var lst &body)
  "Perform the set of actions BODY for all values in LST, binding the current value to VAR.

   ### Example:
   ```cl
   > (for-each var '(1 2 3) \\
   .   (print! var))
   1
   2
   3
   nil
   ```"
  (assert-type! var symbol)
  (let* [(ctr' (gensym))
         (lst' (gensym))]
    `(with (,lst' ,lst)
       (for ,ctr' 1 (# ,lst') 1 (with (,var (get-idx ,lst' ,ctr')) ,@body)))))

(defun append (xs ys)
  "Concatenate XS and YS.

   ### Example:
   ```cl
   > (append '(1 2) '(3 4))
   out = (1 2 3 4)
   ``` "
  `(,@xs ,@ys))

(defun flatten (xss)
  "Concatenate all the lists in XSS. XSS must not contain elements which
   are not lists.

   ### Example:
   ```cl
   > (flatten '((1 2) (3 4)))
   out = (1 2 3 4)
   ```"
  (foldl append '() xss))

(defun range (start end)
  "Build a list from START to END.

   ### Example:
   ```cl
   > (range 1 10)
   out = (1 2 3 4 5 6 7 8 9 10)
   ```"
  (let* [(out '())]
    (for i start end 1
      (push-cdr! out i))
    out))

(defun reverse (xs)
  "Reverse the list XS, using the accumulator ACC.

   ### Example:
   ```cl
   > (reverse (range 1 10))
   out = (10 9 8 7 6 5 4 3 2 1)
   ```"
  (let* [(out '())]
    (for i (# xs) 1 -1
      (push-cdr! out (nth xs i)))
    out))

(defun accumulate-with (f ac z xs)
  "A composition of [[foldl]] and [[map]].

   Transform the values of XS using the function F, then accumulate them
   starting form Z using the function AC.

   This function behaves as if it were folding over the list XS with the
   monoid described by (F, AC, Z), that is, F constructs the monoid, AC
   is the binary operation, and Z is the zero element.

   ### Example:
   ```cl
   > (accumulate-with tonumber + 0 '(1 2 3 4 5))
   out = 15
   ```"
  (assert-type! f function)
  (assert-type! ac function)
  (foldl ac z (map f xs)))

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
