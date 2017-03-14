"List manipulation functions.
 These include several often-used functions for manipulation of lists,
 including functional programming classics such as [[map]] and [[foldr]]
 and useful patterns such as [[accumulate-with]].

 Most of these functions are tail-recursive unless noted, which means they
 will not blow up the stack. Along with the property of tail-recursiveness,
 these functions also have favourable performance characteristics.

 Glossary:
 - **Constant time** The function runs in the same time regardless of the
   size of the input list.
 - **Linear time** The runtime of the function is a linear function of the
   size of the input list.
 - **Logarithmic time** The runtime of the function grows logarithmically
   in proportion to the size of the input list.
 - **Exponential time** The runtime of the function grows exponentially in
   proportion to the size of the input list. This is generally a bad thing."

(import base (defun defmacro when let* set-idx!
              get-idx cons for gensym -or slice
              pretty print error tostring  -and
              unpack debug if # + - >= = ! with))
(import base)
(import lua/table)
(import type (list? nil? assert-type! exists? falsey? eq?))

(defun car (x)
  "Return the first element present in the list X. This function operates
   in constant time.

   Example:
   ```
   > (car '(1 2 3))
   1
   ```"
  (assert-type! x list)
  (base/car x))

(defun cdr (x)
  "Return the list X without the first element present. In the case that
   X is nil, the empty list is returned. Due to the way lists are represented
   internally, this function runs in linear time.

   Example:
   ```
   > (cdr '(1 2 3))
   '(2 3)
   ```"
  (assert-type! x list)
  (if (nil? x)
    '()
    (base/cdr x)))

(defun take (xs n)
  "Take the first N elements of the list XS.

   Example:
   ```
   > (take '(1 2 3 4 5) 2)
   '(1 2)
   ```"
  (slice xs 1 n))

(defun drop (xs n)
  "Remove the first N elements of the list XS.

   Example:
   ```
   > (take '(1 2 3 4 5) 2)
   '(3 4 5)
   ```"
  (slice xs n nil))

(defun snoc (xss &xs)
  "Return a copy of the list XS with the element XS added to its end.
   This function runs in linear time over the two input lists: That is,
   it runs in O(n+k) time proportional both to `(# XSS)` and `(# XS)`.

   Example:
   ```
   > (snoc '(1 2 3) 4 5 6)
   '(1 2 3 4 5 6)
   ``` "
  `(,@xss ,@xs))

(defun foldr (f z xs)
  "Accumulate the list XS using the binary function F and the zero element Z.
   This function is also called `reduce` by some authors. One can visualise
   (foldr f z xs) as replacing the [[cons]] operator in building lists with F,
   and the empty list with Z.

   Consider:
   - `'(1 2 3)` is equivalent to `(cons 1 (cons 2 (cons 3 '())))`
   - `(foldr + 0 '(1 2 3))` is equivalent to `(+ 1 (+ 2 (+ 3 0)))`.

   Example:
   ```
   > (foldr append '() '((1 2) (3 4)))
   ; equivalent to (append '(1 2) (append '(3 4) '()))
   '(1 2 3 4)
   ```"
  (assert-type! f function)
  (assert-type! xs list)
  (let* [(accum z)]
    (for i 1 (# xs) 1
      (set! accum (f accum (nth xs i))))
    accum))

(defun map (f xs acc)
  "Apply the function F to every element of the list XS, collecting the
   results in a new list.

   Example:
   ```
   > (map succ '(0 1 2))
   '(1 2 3)
   ```"
  (assert-type! f function)
  (assert-type! xs list)
  (cond
    [(! (exists? acc)) (map f xs '())]
    [(nil? xs) (reverse acc)]
    [true (map f (cdr xs) (cons (f (car xs)) acc))]))

(defun filter (p xs acc)
  "Return the list of elements of XS which match the predicate P.

   Example:
   ```
   > (filter even? '(1 2 3 4 5 6))
   '(2 4 6)
   ```"
  (assert-type! p function)
  (assert-type! xs list)
  (cond
    [(falsey? acc) (filter p xs '())]
    [(nil? xs) (reverse acc)]
    [true (if (p (car xs))
            (filter p (cdr xs) (cons (car xs) acc))
            (filter p (cdr xs) acc))]))

(defun any (p xs)
  "Check for the existence of an element in XS that matches the
   predicate P.

   Example:
   ```
   > (any exists? '(nil 1 \"foo\"))
   true
   ```"
  (assert-type! p function)
  (assert-type! xs list)
  (accumulate-with p -or false xs))

(defun all (p xs)
  "Test if all elements of XS match the predicate P.

   Example:
   ```
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

   Example:
   ```
   > (elem? 1 '(1 2 3))
   true
   > (elem? 'foo '(1 2 3))
   false
   ```"
  (assert-type! xs list)
  (any (lambda (y) (eq? x y)) xs))

(defun prune (xs)
  "Remove values matching the predicate [[nil?]] from the list XS.

   Example:
   ```
   > (prune '(() 1 () 2))
   '(1 2)
   ```"
  (assert-type! xs list)
  (filter (lambda (x) (! (nil? x))) xs))

(defun traverse (xs f)
  "An alias for [[map]] with the arguments XS and F flipped.

   Example:
   ```
   > (traverse '(1 2 3) succ)
   '(2 3 4)
   ```"
  (map f xs))

(defun last (xs)
  "Return the last element of the list XS.
   Counterintutively, this function runs in constant time.

   Example:
   ```
   > (last (range 1 100))
   100
   ```"
  (assert-type! xs list)
  (get-idx xs (# xs)))

(defun nth (xs idx)
  "Get the IDX th element in the list XS. The first element is 1.
   This function runs in constant time.

   Example:
   ```
   > (nth (range 1 100) 10)
   10
   ```"
  (get-idx xs idx))

(defun push-cdr! (xs val)
  "Mutate the list XS, adding VAL to its end.

   Example:
   ```
   > (define list '(1 2 3))
   > (push-cdr! list 4)
   '(1 2 3 4)
   > list
   '(1 2 3 4)
   ```"
  (assert-type! xs list)
  (let* [(len (+ (# xs) 1))]
    (set-idx! xs "n" len)
    (set-idx! xs len val)
    xs))

(defun pop-last! (xs)
  "Mutate the list XS, removing and returning its last element.

   Example:
   ```
   > (define list '(1 2 3))
   > (pop-last! list)
   3
   > list
   '(1 2)
   ``` "
  (assert-type! xs list)
  (with (x (get-idx xs (# xs)))
    (set-idx! xs (# xs) nil)
    (set-idx! xs "n" (- (# xs) 1))
    x))

(defun remove-nth! (li idx)
  "Mutate the list LI, removing the value at IDX and returning it.

   Example:
   ```
   > (define list '(1 2 3))
   > (remove-nth! list 2)
   2
   > list
   > '(1 3)
   ``` "
  (assert-type! li list)
  (set-idx! li "n" (- (get-idx li "n") 1))
  (lua/table/remove li idx))

(defmacro for-each (var lst &body)
  "Perform the set of actions BODY for all values in LST, binding the current value to VAR.

   Example:
   ```
   > (for-each var '(1 2 3)\
       (print! var))
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

   Example:
   ```
   > (append '(1 2) '(3 4))
   '(1 2 3 4)
   ``` "
  (cond
    [(nil? xs) ys]
    [true (cons (car xs) (append (cdr xs) ys))]))

(defun flatten (xss)
  "Concatenate all the lists in XSS. XSS must not contain elements which
   are not lists.

   Example:
   ```
   > (flatten '((1 2) (3 4)))
   '(1 2 3 4)
   ```"
  (foldr append '() xss))

(defun range (start end acc)
  "Build a list from START to END. This function is tail recursive, and
   uses the parameter ACC as an accumulator.

   Example:
   ```
   > (range 1 10)
   '(1 2 3 4 5 6 7 8 9 10)
   ```"
  (cond
    [(! (exists? acc)) (range start end '())]
    [(>= start end) (reverse (cons start acc))]
    [true (range (+ 1 start) end (cons start acc))]))

(defun reverse (xs acc)
  "Reverse the list XS, using the accumulator ACC.

   Example:
   ```
   > (reverse (range 1 10))
   '(10 9 8 7 6 5 4 3 2 1)
   ```"
  (cond
    [(! (exists? acc)) (reverse xs '())]
    [(nil? xs) acc]
    [true (reverse (cdr xs) (cons (car xs) acc))]))

(defun accumulate-with (f ac z xs)
  "A composition of [[foldr]] and [[map]]
   Transform the values of XS using the function F, then accumulate them
   starting form Z using the function AC.

   This function behaves as if it were folding over the list XS with the
   monoid described by (F, AC, Z), that is, F constructs the monoid, AC
   is the binary operation, and Z is the zero element.

   Example:
   ```
   > (accumulate-with tonumber + 0 '(1 2 3 4 5))
   15
   ```"
  (assert-type! f function)
  (assert-type! ac function)
  (foldr ac z (map f xs)))

(defun zip (fn &xss)
  "Iterate over all the successive cars of XSS, producing a single list
   by applying FN to all of them. For example:

   Example:
   ```
   > (zip list '(1 2 3) '(4 5 6) '(7 8 9))
   '((1 4 7) (2 5 8) (3 6 9))
   ```"
  (cond
    [(any nil? xss)
     '()]
    [true
      (cons (fn (unpack (cars xss)))
            (zip fn (unpack (cdrs xss))))]))


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
