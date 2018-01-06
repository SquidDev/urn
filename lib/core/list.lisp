"List manipulation functions.

 These include several often-used functions for manipulation of lists,
 including functional programming classics such as [[map]] and [[reduce]]
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

(import core/base (defun defmacro when unless let* set-idx!  get-idx for gensym -or
                   slice /= mod else print error tostring  -and if n + - >= > =
                   not with apply and progn .. * while <= < or values-list first list
                   second for-pairs))

(import core/base b)
(import core/demand (assert-type!))
(import core/method (pretty eq? neq?))
(import core/type (nil? list? empty? exists? falsey? type))

(import lua/math (min max huge))
(import lua/string)
(import lua/table)

(defun car (x)
  "Return the first element present in the list X. This function operates
   in constant time.

   ### Example:
   ```cl
   > (car '(1 2 3))
   out = 1
   ```"
  (assert-type! x list)
  (b/car x))


(define slicing-view
  "Return a mutable reference to the list LIST, with indexing offset
   (positively) by OFFSET. Mutation in the original list is reflected in
   the view, and updates to the view are reflected in the original. In
   this, a sliced view resembles an (offset) pointer. Note that trying
   to access a key that doesn't make sense in a list (e.g., not its
   `:tag`, its `:n`, or a numerical index) will blow up with an arithmetic
   error.

   **Note** that the behaviour of a sliced view when the underlying list
   changes length may be confusing: accessing elements will still work,
   but the reported length of the slice will be off. Furthermore, If the
   original list shrinks, the view will maintain its length, but will
   have an adequate number of `nil`s at the end.

   ```cl
   > (define foo '(1 2 3 4 5))
   out = (1 2 3 4 5)
   > (define foo-view (cdr foo))
   out = (2 3 4 5)
   > (remove-nth! foo 5)
   out = 5
   > foo-view
   out = (2 3 4 nil)
   ```

   Also **note** that functions that modify a list in-place, like
   `insert-nth!', `remove-nth!`, `pop-last!` and `push!` will not
   modify the view *or* the original list.

   ```cl :no-test
   > (define bar '(1 2 3 4 5))
   out = (1 2 3 4 5)
   > (define bar-view (cdr bar))
   out = (2 3 4 5)
   > (remove-nth! bar-view 4)
   out = nil
   > bar
   out = (1 2 3 4 5)
   ```

   ### Example:
   ```cl
   > (define baz '(1 2 3))
   out = (1 2 3)
   > (slicing-view baz 1)
   out = (2 3)
   > (.<! (slicing-view baz 1) 1 5)
   out = nil
   > baz
   out = (1 5 3)
   ```"
  (let* [(ref-mt { :__index (lambda (t k)
                              (get-idx (get-idx t :parent) (+ k (get-idx t :offset))))
                   :__newindex (lambda (t k v)
                                 (set-idx! (get-idx t :parent) (+ k (get-idx t :offset)) v)) })]
    (lambda (list offset)
      (cond
        [(<= (n list) offset) '()]
        [(and (get-idx list :parent)
              (get-idx list :offset))
         (b/setmetatable { :parent (get-idx list :parent)
                           :offset (+ (get-idx list :offset) offset)
                           :n (- (n list) offset)
                           :tag (type list) }
                         ref-mt)]
        [else (b/setmetatable { :parent list
                                :offset offset
                                :n (- (n list) offset)
                                :tag (type list) }
                              ref-mt)]))))

(defun cdr (x)
  "Return a reference the list X without the first element present. In
   the case that X is nil, the empty list is returned. Note that
   mutating the reference will not mutate the

   ### Example:
   ```cl
   > (cdr '(1 2 3))
   out = (2 3)
   ```"
  (slicing-view x 1))

(defun take (xs n)
  "Take the first N elements of the list XS.

   ### Example:
   ```cl
   > (take '(1 2 3 4 5) 2)
   out = (1 2)
   ```"
  (slice xs 1 (min n (b/n xs))))

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

(defun reduce (f z xs)
  "Accumulate the list XS using the binary function F and the zero
   element Z.  This function is also called `foldl` by some authors. One
   can visualise `(reduce f z xs)` as replacing the [[cons]] operator in
   building lists with F, and the empty list with Z.

   Consider:
   - `'(1 2 3)` is equivalent to `(cons 1 (cons 2 (cons 3 '())))`
   - `(reduce + 0 '(1 2 3))` is equivalent to `(+ 1 (+ 2 (+ 3 0)))`.

   ### Example:
   ```cl
   > (reduce append '() '((1 2) (3 4)))
   out = (1 2 3 4)
   ; equivalent to (append '(1 2) (append '(3 4) '()))
   ```"
  (assert-type! f function)
  (let* [(start 1)]
    (if (and (nil? xs)
             (list? z))
      (progn
        (set! start 2)
        (set! xs z)
        (set! z (car z)))
      nil)
    (assert-type! xs list)
    (let* [(accum z)]
      (for i start (n xs) 1
           (set! accum (f accum (nth xs i))))
      accum)))

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
                      (if (not (list? (nth xss i)))
                        (error (.. "that's no list! " (pretty (nth xss i))
                                   " (it's a " (type (nth xss i)) "!)"))
                        true)
                      (push! out (n (nth xss i))))
                    out))
         (out '())]
    (for i 1 (apply min ns) 1
      (push! out (apply fn (nths xss i))))
    out))

(defun maybe-map (fn &xss)
  "Iterate over all successive cars of XSS, producing a single list by
   applying FN to all of them, while discarding any `nil`s.

   ### Example:
   ```cl
   > (maybe-map (lambda (x)
   .              (if (even? x)
   .                nil
   .                (succ x)))
   .            (range :from 1 :to 10))
   out = (2 4 6 8 10)
   ```"
  (let* [(lengths (let* [(out '())]
                    (for i 1 (n xss) 1
                      (if (not (list? (nth xss i)))
                        (error (.. "that's no list! " (pretty (nth xss i))
                                   " (it's a " (type (nth xss i)) "!)"))
                        true)
                      (push! out (n (nth xss i))))
                    out))
         (out '())]
    (for i 1 (apply min lengths) 1
      (let* [(vl (apply fn (nths xss i)))]
        (if (/= vl nil)
          (push! out vl)
          nil)))
    out))

(defun flat-map (fn &xss)
  "Map the function FN over the lists XSS, then flatten the result
   lists.

   ### Example:
   ```cl
   > (flat-map list '(1 2 3) '(4 5 6))
   out = (1 4 2 5 3 6)
   ```"
  (flatten (apply map fn xss)))

(defun partition (p xs)
  "Split XS based on the predicate P. Values for which the predicate
   returns true are returned in the first list, whereas values which
   don't pass the predicate are returned in the second list.

   ### Example:
   ```cl
   > (list (partition even? '(1 2 3 4 5 6)))
   out = ((2 4 6) (1 3 5))
   ```"
  (assert-type! p function)
  (assert-type! xs list)
  (let* [(passed '())
         (failed '())]
    (for i 1 (n xs) 1
      (with (x (nth xs i))
        (push! (if (p x) passed failed) x)))
    (values-list passed failed)))

(defun filter (p xs)
  "Return a list with only the elements of XS that match the predicate
   P.

   ### Example:
   ```cl
   > (filter even? '(1 2 3 4 5 6))
   out = (2 4 6)
   ```"
  (first (partition p xs)))

(defun exclude (p xs)
  "Return a list with only the elements of XS that don't match the
   predicate P.

   ### Example:
   ```cl
   > (exclude even? '(1 2 3 4 5 6))
   out = (1 3 5)
   ```"
  (second (partition p xs)))

(defun any (p xs)
  "Check for the existence of an element in XS that matches the predicate
   P.

   ### Example:
   ```cl
   > (any exists? '(nil 1 \"foo\"))
   out = true
   ```"
  (assert-type! p function)
  (assert-type! xs list)
  (let* [(len (n xs))
         (fun nil)]
    (set! fun (lambda (i)
                (cond
                  [(> i len) false]
                  [(p (nth xs i)) true]
                  [else (fun (+ i 1))])))
    (fun 1)))

(defun none (p xs)
  "Check that no elements in XS match the predicate P.

   ### Example:
   ```cl
   > (none nil? '(\"foo\" \"bar\" \"baz\"))
   out = true
   ```"
  (not (any p xs)))

(defun \\ (xs ys)
  "The difference between XS and YS (non-associative.)

   ### Example:
   ```cl
   > (\\\\ '(1 2 3) '(1 3 5 7))
   out = (2)
   ```"
  (filter (lambda (x)
            (not (elem? x ys)))
          xs))

(defun nub (xs)
  "Remove duplicate elements from XS. This runs in linear time.

   ### Example:
   ```cl
   > (nub '(1 1 2 2 3 3))
   out = (1 2 3)
   ```"
  (let* ((hm {})
         (out '[]))
    (for-each elm xs
      (with (szd (pretty elm))
        (cond
          [(nil? (get-idx hm szd))
            (push! out elm)
            (set-idx! hm szd elm)]
          [else])))
    out))

(defun union (&xss)
  "Set-like union of all the lists in XSS. Note that this function does
   not preserve the lists' orders.

   ### Example:
   ```cl
   > (union '(1 2 3 4) '(1 2 3 4 5))
   out = (1 2 3 4 5)
   ```"
  (let* [(set {})
        (out '())]
    (do [(xs xss)]
      (if (list? xs)
        (do [(x xs)]
          (set-idx! set x x))
        (set-idx! set xs xs)))
    (for-pairs (k v) set
      (push! out v))
    out))

(defun all (p xs)
  "Test if all elements of XS match the predicate P.

   ### Example:
   ```cl
   > (all symbol? '(foo bar baz))
   out = true
   > (all number? '(1 2 foo))
   out = false
   ```"
  (assert-type! p function)
  (assert-type! xs list)
  (let* [(len (n xs))
         (fun nil)]
    (set! fun (lambda (i)
                (cond
                  [(> i len) true]
                  [(p (nth xs i)) (fun (+ i 1))]
                  [else false])))
    (fun 1)))

(defun elem? (x xs)
  "Test if X is present in the list XS.

   ### Example:
   ```cl
   > (elem? 1 '(1 2 3))
   out = true
   > (elem? 'foo '(1 2 3))
   out = false
   ```"
  (assert-type! xs list)
  (any (lambda (y) (eq? x y)) xs))

(defun find-index (p xs)
  "Finds the first index in XS where the item matches the predicate
   P. Returns `nil` if no such item exists.

   ### Example:
   ```cl
   > (find-index even? '(3 4 5))
   out = 2
   > (find-index even? '(1 3 5))
   out = nil
   ```"
  (assert-type! p function)
  (assert-type! xs list)
  (let* [(len (n xs))
         (fun nil)]
    (set! fun (lambda (i)
                (cond
                  [(> i len) nil]
                  [(p (nth xs i)) i]
                  [else (fun (+ i 1))])))
    (fun 1)))

(defun element-index (x xs)
  "Finds the first index in XS where the item matches X. Returns `nil` if
   no such item exists.

   ### Example:
   ```cl
   > (element-index 4 '(3 4 5))
   out = 2
   > (element-index 2 '(1 3 5))
   out = nil
   ```"
  (assert-type! xs list)
  (find-index (lambda (y) (eq? x y)) xs))

(defun prune (xs)
  "Remove values matching the predicates [[empty?]] or [[nil?]] from
   the list XS.

   ### Example:
   ```cl
   > (prune (list '() nil 1 nil '() 2))
   out = (1 2)
   ```"
  (assert-type! xs list)
  (filter (lambda (x) (and (not (nil? x)) (not (empty? x)))) xs))

(defun traverse (xs f)
  :deprecated "Use [[map]] instead."
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
   out = (1 2 3 4 5 6 7 8 9)
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
      (push! out (nth (nth xss i) idx)))
    out))

(defun push! (xs &vals)
  "Mutate the list XS, adding VALS to its end.

   ### Example:
   ```cl
   > (define list '(1 2 3))
   > (push! list 4)
   out = (1 2 3 4)
   > list
   out = (1 2 3 4)
   ```"
  (assert-type! xs list)
  (let* [(nxs (n xs))
         (len (+ nxs (n vals)))]
    (set-idx! xs "n" len)
    (for i 1 (n vals) 1
      (set-idx! xs (+ nxs i) (get-idx vals i)))
    xs))

(define push-cdr!
  "Mutate the list XS, adding VALS to its end.

   ### Example:
   ```cl
   > (define list '(1 2 3))
   > (push-cdr! list 4)
   out = (1 2 3 4)
   > list
   out = (1 2 3 4)
   ```"
  :deprecated "Use [[push!]] instead."
  push!)

(defun pop-last! (xs)
  "Mutate the list XS, removing and returning its last element.

   ### Example:
   ```cl
   > (define list '(1 2 3))
   > (pop-last! list)
   out = 3
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
   out = 2
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
   > list
   out = (1 5 2 3)
   ``` "
  (assert-type! li list)
  (set-idx! li "n" (+ (get-idx li "n") 1))
  (lua/table/insert li idx val))

(defmacro for-each (var lst &body)
  :deprecated "Use [[do]]/[[dolist]] instead"
  "Perform the set of actions BODY for all values in LST, binding the current value to VAR.

   ### Example:
   ```cl
   > (for-each var '(1 2 3)
   .   (print! var))
   1
   2
   3
   out = nil
   ```"
  `(do [(,var ,lst)]
     ,@body))

(defmacro dolist (vars &stmts)
  "Iterate over all given VARS, running STMTS and collecting the results.

   ### Example:
   ```cl
   > (dolist [(a '(1 2 3))
   .          (b '(1 2 3))]
   .   (list a b))
   out = ((1 1) (1 2) (1 3) (2 1) (2 2) (2 3) (3 1) (3 2) (3 3))
   ```"
  (let* [(collect (gensym 'list))
         (arg (gensym 'val))
         (yield (gensym 'yield))
         (out `(,yield (progn ,@stmts)))]
    (for i (n vars) 1 -1
      (let* [(var (nth vars i))
             (cur-list (gensym))
             (i (gensym 'i))]
        (set! out
          `(let* [(,cur-list ,(cadr var))]
             (for ,i 1 (n ,cur-list) 1
                  (let* [(,(car var) (get-idx ,cur-list ,i))]
                    ,out))))))
    `(let* [(,collect '())
            (,yield (lambda (,arg)
                      (when (/= ,arg nil)
                        (push! ,collect ,arg))))]
       ,out
       ,collect)))

(defmacro do (vars &stmts)
  "Iterate over all given VARS, running STMTS **without** collecting the
   results.

   ### Example:
   ```cl
   > (do [(a '(1 2))
   .      (b '(1 2))]
   .   (print! $\"a = ${a}, b = ${b}\"))
   a = 1, b = 1
   a = 1, b = 2
   a = 2, b = 1
   a = 2, b = 2
   out = nil
   ```"
  (let* [(out `(progn ,@stmts))]
    (for i (n vars) 1 -1
      (let* [(var (nth vars i))
             (cur-list (gensym))
             (i (gensym 'i))]
        (set! out
          `(let* [(,cur-list ,(cadr var))]
             (for ,i 1 (n ,cur-list) 1
               (let* [(,(car var) (get-idx ,cur-list ,i))]
                 ,out))))))
    out))

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
  (reduce append '() xss))

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
              (when (= (mod (n args) 2) 1)
                (error "Expected an even number of arguments to range" 2))
              (for i 1 (n args) 2
                (set-idx! out (get-idx args i) (get-idx args (+ i 1))))
              out))
         (st (or (get-idx x :from) 1))
         (ed (or (+ 1 (get-idx x :to))
                 (error "Expected end index, got nothing")))
         (inc (- (or (get-idx x :by) (+ 1 st)) st))
         (tst (if (>= st ed)
                > <))]
    (let* [(c st)
           (out '())]
      (while (tst c ed)
        (push! out c)
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
      (push! out (nth xs i)))
    out))

(defun accumulate-with (f ac z xs)
  "A composition of [[reduce]] and [[map]].

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
  (reduce ac z (map f xs)))

(defun sum (xs)
  "Return the sum of all elements in XS.

   ### Example:
   ```cl
   > (sum '(1 2 3 4))
   out = 10
   ```"
  (reduce + 0 xs))

(defun prod (xs)
  "Return the product of all elements in XS.

   ### Example:
   ```cl
   > (prod '(1 2 3 4))
   out = 24
   ```"
  (reduce * 1 xs))

(defun take-while (p xs idx)
  "Takes elements from the list XS while the predicate P is true,
   starting at index IDX. Works like `filter`, but stops after the
   first non-matching element.

   ### Example:
   ```cl
   > (define list '(2 2 4 3 9 8 4 6))
   > (define p (lambda (x) (= (mod x 2) 0)))
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
    (unless (nil? x)
      (while (and (<= idx ln) (p x))
        (push! l x)
        (set! idx (+ idx 1))
        (set! x (nth xs idx))))
    l))

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
    (while (not (empty? b))
      (push! l b)
      (set! idx (+ idx (n b) 1))
      (set! b (take-while p xs idx)))
    l))

(defun groups-of (xs num)
  "Splits the list XS into sub-lists of size NUM.

   ### Example:
   ```cl
   > (groups-of '(1 2 3 4 5 6) 3)
   out = ((1 2 3) (4 5 6))
   ```"
  (assert-type! xs list)
  (let* [(result '())
         (group nil)]
    (for idx 1 (n xs) 1
      (when (= (mod (- idx 1) num) 0)
        (set! group '())
        (push! result group))
      (push! group (nth xs idx)))
    result))

(defun sort (xs f)
  "Sort the list XS, non-destructively, optionally using F as a
   comparator.  A sorted version of the list is returned, while the
   original remains untouched.

   ### Example:
   ```cl
   > (define li '(9 5 7 2 1))
   out = (9 5 7 2 1)
   > (sort li)
   out = (1 2 5 7 9)
   > li
   out = (9 5 7 2 1)
   ```"
  (let* [(copy (map (lambda (x) x) xs))]
    (lua/table/sort copy f)
    copy))

(defun sort! (xs f)
  "Sort the list XS in place, optionally using F as a comparator.

   ### Example:
   > (define li '(9 5 7 2 1))
   out = (9 5 7 2 1)
   > (sort! li)
   out = (1 2 5 7 9)
   > li
   out = (1 2 5 7 9)
   ```"
  (lua/table/sort xs f)
  xs)

;; Auto-generate all `c[ad]r`/`c[ad]rs` methods.
,@(let* [(out '())
         (symb (lambda (x) { :tag "symbol" :contents x }))
         (depth-symb (lambda (idx mode) (symb (.. "c" mode (lua/string/rep "d" (- idx 1)) "r"))))
         (pair (lambda (x y) (list y x)))
         (generate nil)]
    (set! generate (lambda (name stack do-idx idx depth)
                     (when (> (n name) 1)
                       (with (head (if do-idx `(get-idx ,'xs ,idx) `(slicing-view ,'xs ,idx)))
                         (push! out `(define ,(symb (.. "c" name "r"))
                                           (lambda (,'xs)
                                             (assert-type! ,'xs ,'list)
                                             ,(reduce pair head stack))))))

                     (when (> (n name) 0)
                       (push! out `(define ,(symb (.. "c" name "rs")) (lambda (,'xs) (map ,(symb (.. "c" name "r")) ,'xs)))))

                     (cond
                       [(<= depth 0)]
                       [do-idx
                        (generate (.. name "a") (cons (depth-symb idx "a") stack) true 1 (- depth 1))
                        (generate (.. name "d") stack                             true (+ idx 1) (- depth 1))]
                       [else
                        (generate (.. name "a") (cons (depth-symb idx "d") stack) true 1 (- depth 1))
                        (generate (.. name "d") stack                             false (+ idx 1) (- depth 1))])))

    (generate "a" '() true 1 3)
    (generate "d" '() false 1 3)
    out)
