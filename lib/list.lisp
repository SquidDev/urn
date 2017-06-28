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

(import base (defun defmacro when unless let* set-idx!
              get-idx for gensym -or slice /= %
              pretty print error tostring  -and
              unpack debug if n + - >= > = ! with
              apply and progn .. * while <= < or))
(import base)
(import lua/table)
(import type (nil? list? empty? assert-type! exists? falsey? eq? neq? type))
(import lua/math (min max huge))

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
  (slice xs 1 (min n (base/n xs))))

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
   it runs in O(n+k) time proportional both to `(n XSS)` and `(n XS)`.

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
    (for i 1 (n xs) 1
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
  (let* [(ns (let* [(out '())]
                    (for i 1 (n xss) 1
                      (if (! (list? (nth xss i)))
                        (error (.. "not a list: " (pretty (nth xss i))
                                   " (it's a " (type (nth xss i)) ")"))
                        true)
                      (push-cdr! out (n (nth xss i))))
                    out))
         (out '())]
    (for i 1 (apply min ns) 1
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
                (range :from 1 :to 10))
   out = (2 4 6 8 10)
   ```"
  (let* [(lengths (let* [(out '())]
                    (for i 1 (n xss) 1
                      (if (! (list? (nth xss i)))
                        (error (.. "not a list: " (pretty (nth xss i))
                                   " (it's a " (type (nth xss i)) ")"))
                        true)
                      (push-cdr! out (n (nth xss i))))
                    out))
         (out '())]
    (for i 1 (apply min lengths) 1
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
    (for i 1 (n xs) 1
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
  (let* [(len (n xs))
         (fun nil)]
    (set! fun (lambda (i)
                (cond
                  [(> i len) false]
                  [(p (nth xs i)) true]
                  [true (fun (+ i 1))])))
    (fun 1)))

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

   ### Example:
   ```
   > (\\ '(1 2 3) '(1 3 5 7))
   out = (2)
   ```"
  (filter (lambda (x)
            (! (elem? x ys)))
          xs))

(defun nub (xs)
  "Remove duplicate elements from XS. This runs in linear time.

   ### Example:
   ```
   > (nub '(1 1 2 2 3 3))
   out = (1 2 3)
   ```"
  (let* ((hm {})
         (out '[]))
    (for-each elm xs
      (with (szd (pretty elm))
        (cond
          [(nil? (get-idx hm szd))
            (push-cdr! out elm)
            (set-idx! hm szd elm)]
          [true])))
    out))

(defun union (xs ys)
  "Set-like union of XS and YS.

   ### Example:
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
  (let* [(len (n xs))
         (fun nil)]
    (set! fun (lambda (i)
                (cond
                  [(> i len) true]
                  [(p (nth xs i)) (fun (+ i 1))]
                  [true false])))
    (fun 1)))

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
   > (last (range :from 1 :to 100))
   out = 100
   ```"
  (assert-type! xs list)
  (get-idx xs (n xs)))

(defun init (xs)
  "Return the list XS with the last element removed.
   This is the dual of LAST.

   ### Example:
   ```cl
   > (init (range :from 1 :to 10))
   out = '(1 2 3 4 5 6 7 8 9)
   ```"
  (assert-type! xs list)
  (slice xs 1 (- (n xs) 1)))

(defun nth (xs idx)
  "Get the IDX th element in the list XS. The first element is 1.
   This function runs in constant time.

   ### Example:
   ```cl
   > (nth (range :from 1 :to 100) 10)
   out = 10
   ```"
  (if (>= idx 0)
    (get-idx xs idx)
    (get-idx xs (+ (get-idx xs :n) 1 idx))))

(defmacro nth/setf! (selector val)
  "An implementation of `setf!` for list access.

   ### Example
   ```cl
   (setf! (nth foo 2) 123)
   ```"
  :hidden
  `(set-idx! ,(nth selector 1) ,(nth selector 2) ,val))

(defmacro nth/over! (selector fun)
  "An implementation of `over!` for list access.

   ### Example
   ```cl
   (over! (nth foo 2) (cut + <> 2))
   ```"
  :hidden
  (let* [(key-sym (gensym))
         (val-sym (gensym))]
    `(let* [(,val-sym ,(nth selector 1))
            (,key-sym ,(nth selector 2))]
       (set-idx! ,val-sym ,key-sym (,fun (get-idx ,val-sym ,key-sym))))))

(defun nths (xss idx)
  "Get the IDX-th element in all the lists given at XSS. The first
   element is1.

   ### Example:
   ```cl
   > (nths '((1 2 3) (4 5 6) (7 8 9)) 2)
   out = (2 5 8)
   ```"
  (let* [(out '())]
    (for i 1 (n xss) 1
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
  (let* [(len (+ (n xs) 1))]
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
  (with (x (get-idx xs (n xs)))
    (set-idx! xs (n xs) nil)
    (set-idx! xs "n" (- (n xs) 1))
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

(defun insert-nth! (li idx val)
  "Mutate the list LI, inserting VAL at IDX.

   ### Example:
   ```cl
   > (define list '(1 2 3))
   > (insert-nth! list 2 5)
   2
   > list
   out = (1 5 2 3)
   ``` "
  (assert-type! li list)
  (set-idx! li "n" (+ (get-idx li "n") 1))
  (lua/table/insert li idx val))

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
       (for ,ctr' 1 (n ,lst') 1 (with (,var (get-idx ,lst' ,ctr')) ,@body)))))

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

(defun range (&args)
  "Build a list from :FROM to :TO, optionally passing by :BY.

   ### Example:
   ```cl
   > (range :from 1 :to 10)
   out = (1 2 3 4 5 6 7 8 9 10)
   > (range :from 1 :to 10 :by 3)
   out = (1 3 5 7 9)
   ```"
  (let* [(x (let* [(out {})]
              (when (= (% (n args) 2) 1)
                (error "Expected an even number of arguments to range" 2))
              (for i 1 (n args) 2
                (set-idx! out (get-idx args i) (get-idx args (+ i 1))))
              out))
         (st (or (get-idx x :from) 1))
         (ed (or (get-idx x :to) huge))
         (inc (- (or (get-idx x :by) (+ 1 st)) st))
         (tst (if (>= st ed)
                > <))]
    (let* [(c st)
           (out '())]
      (while (tst c ed)
        (push-cdr! out c)
        (set! c (+ c inc)))
      out)))


(defun reverse (xs)
  "Reverse the list XS, using the accumulator ACC.

   ### Example:
   ```cl
   > (reverse (range :from 1 :to 10))
   out = (10 9 8 7 6 5 4 3 2 1)
   ```"
  (let* [(out '())]
    (for i (n xs) 1 -1
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

(defun sum (xs)
  "Return the sum of all elements in XS.

   ### Example:
   ```cl
   > (sum '(1 2 3 4))
   out = 10
   ```"
  (foldl + 0 xs))

(defun prod (xs)
  "Return the product of all elements in XS.

   ### Example:
   ```cl
   > (prod '(1 2 3 4))
   out = 24
   ```"
  (foldl * 1 xs))

(defun take-while (p xs idx)
  "Takes elements from the list XS while the predicate P is true,
   starting at index IDX. Works like `filter`, but stops after the
   first non-matching element.

   ### Example:
   ```cl
   > (define list '(2 2 4 3 9 8 4 6))
   > (define p (lambda (x) (= (% x 2) 0)))
   > (filter p list)
   out = (2 2 4 8 4 6)
   > (take-while p list 1)
   out = (2 2 4)
   ```"
  (assert-type! p function)
  (assert-type! xs list)
  (unless (= (type idx) "number")
    (set! idx 1))
  (let* [(l '())
         (ln (n xs))
         (x (nth xs idx))]
    (if (nil? x)
      '()
      (progn
        (while (and (<= idx ln) (p x))
          (push-cdr! l x)
          (set! idx (+ idx 1))
          (set! x (nth xs idx)))
        l))))

(defun split (xs y)
  "Splits a list into sub-lists by the separator Y.

   ### Example:
   ```cl
   > (split '(1 2 3 4) 3)
   out = ((1 2) (4))
   ```"
  (assert-type! xs list)
  (let* [(l '())
         (p (lambda (x) (neq? x y)))
         (idx 1)
         (b (take-while p xs idx))]
    (while (! (empty? b))
      (push-cdr! l b)
      (set! idx (+ idx (n b) 1))
      (set! b (take-while p xs idx)))
    l))

;; Auto-generate all `c[ad]r`/`c[ad]rs` methods.
,@(let* [(out '())
         (symb (lambda (x) { :tag "symbol" :contents x }))
         (generate nil)]
    (set! generate (lambda (name body idx depth)
                     (when (> depth 0)
                       ;; Hack as `car` and `cdr` are generated above.
                       (when (/= name "")
                         (push-cdr! out `(define ,(symb (.. "ca" name "r")) (lambda (,'xs) (assert-type! ,'xs ,'list) (get-idx ,body ,idx))))
                         (push-cdr! out `(define ,(symb (.. "cd" name "r")) (lambda (,'xs) (assert-type! ,'xs ,'list) (slice ,body ,(+ idx 1))))))

                       (push-cdr! out `(define ,(symb (.. "ca" name "rs")) (lambda (,'xs) (map ,(symb (.. "ca" name "r")) ,'xs))))
                       (push-cdr! out `(define ,(symb (.. "cd" name "rs")) (lambda (,'xs) (map ,(symb (.. "cd" name "r")) ,'xs))))

                       (generate (.. "d" name) body (+ idx 1) (- depth 1))
                       (generate (.. "a" name) `(get-idx ,body 1) 1 (- depth 1)))))
    (generate "" 'xs 1 4)
    out)
