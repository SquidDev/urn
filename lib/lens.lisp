"Lenses are a purely functional solution to the issue of accessing and
 setting fields in deeply nested data structures without special
 language support. Indeed, most of the symbols exported by this module
 are either lenses (represented as tables for reflection and
 introspection reasons) or functions that operate on lenses.

 A lens is defined as two basic operators:

 - A function that returns a piece of a data structure given some data
   structure (a _getter_, called `view`)
 - A function that given a function and some data structure, replaces
   a bit of that data structure with the result of applying that
   function (a _replacer_, called `over`).

 We will be using, as a running example, two data structures: the list
 and the struct.

 ```cl
 > (define list-example (range :from 1 :to 10))
 out = '(1 2 3 4 5 6 7 8 9 10)
 > (define struct-example (struct :foo \"bar\" :baz \"quux\"))
 out = (struct \"foo\" \"bar\" \"baz\" \"quux\")
 ```

 Lists have two lenses, [[head]] and [[tail]], which correspond to
 [[car]] and [[cdr]], respectively. To use a lens to _zoom into_ a
 part of a data structure, we can use the combinator [[view]]. If we
 were to give [[view]] a type, it would be `Lens a b -> a -> b`. It uses
 the getter defined by the lens to access a bit of a data structure.

 ```cl
 > (view head list-example)
 out = 1
 > (view tail list-example)
 out = '(2 3 4 5 6 7 8 9 10)
 ```

 Note that lenses may also be applied directly to values, which equates
 to using [[view]]. That is, `(lens x)` is `(view lens x)`.

 Of course, if lenses were only used to [[view]] values, they would not
 be very useful; What is the point of using `(view head ...)` over just
 `(car ...)`? Their real use comes from the _other_ function that makes
 up a lens, `over`. [[over]] applies a function to a specific bit of a
 data structure. For example, the `over` implementation for [[head]]
 returns a new list with the first element replaced.

 ```cl
 > (over head succ list-example)
 out = '(2 2 3 4 5 6 7 8 9 10)
 ```

 Notice that [[over]] doesn't just return the new head, but the a copy
 of the existing list with the new head in place.

 Again, lenses don't seem very useful until you learn the other property
 that they all have in common: _composition_. Lenses, you see, are like
 functions: You can take two and [[<>]] them together, producing a lens
 that [[view]]s and modifies (with [[over]]) a inner piece of the data
 structure.

 For example, by composing `head` and `tail`, you may focus on the second
 element of a list using `(<> head tail)`, or the tail of the first
 element of a list (given that element itself is a list itself) using
 `(<> tail head)`.

 ```
 > (over (<> head tail) succ list-example)
 out = '(1 3 3 4 5 6 7 8 9 10)
 ```"

(import lua/basic (setmetatable .. n))
(import function (compose invokable?))
(import binders (let* letrec))
(import base (defun defmacro and get-idx set-idx! = if error for for-pairs
               gensym > or + <))
(import list (reduce map filter prune car cdr cadr cons nth push-cdr! reverse
                     maybe-map))
(import type (list? function? eq? eql? pretty))

(defun lens (view over)
  "Define a lens using VIEW and OVER as the getter and the replacer
   functions, respectively.

   Lenses built with [[lens]] can be composed (with [[<>]]), used
   to focus on a value (with [[view]]), and replace that value
   (with [[set]] or [[over]])"

  (setmetatable
    {:tag "lens" :view view :over over}
    { :__call (lambda (t x)
                (^. x t)) }))

(defun getter (view)
  "Define a getting lens using VIEW as the accessor.

   Lenses built with [[getter]] can be composed (with [[<>]]) or used
   to focus on a value (with [[view]])."
  (lens view nil))

(defun setter (over)
  "Define a setting lens using VIEW as the accessor.

   Lenses built with [[setter]] can be composed (with [[<>]]) or used
   to replace a value (with [[over]] or [[set]])."
  (lens nil over))

(defun lens? (lens)
  "Check that is LENS a valid lens, that is, has the proper tag, a
   valid getter and a valid setter."

  (and (= (get-idx lens :tag) :lens)
       (function? (get-idx lens :view))
       (function? (get-idx lens :over))))

(defun getter? (lens)
  "Check that LENS has a defined getter, along with being tagged as
   a LENS. This is essentially a relaxed version of [[lens?]] in
   regards to the setter check."
  (and (= (get-idx lens :tag) :lens)
       (function? (get-idx lens :view))))

(defun setter? (lens)
  "Check that LENS has a defined setter, along with being tagged as
   a LENS. This is essentially a relaxed version of [[lens?]] in
   regards to the getter check."
  (and (= (get-idx lens :tag) :lens)
       (function? (get-idx lens :over))))

(defun compose-inner (l1 l2) :hidden
  (let* [(view-1 (get-idx l1 :view))
         (view-2 (get-idx l2 :view))
         (over-1 (get-idx l1 :over))
         (over-2 (get-idx l2 :over))]
    (lens (if (and view-1 view-2)
            (compose view-2 view-1)
            nil)
          (if (and over-1 over-2)
            (lambda (f x)
              (over-1 (lambda (x)
                        (over-2 f x)) x))
            nil))))

(defun <> (&lenses)
  "Compose, left-associatively, the list of lenses given by LENSES."
  (letrec [(|> (x)
             (cond
               [(= (n x) 1) (car x)]
               [(= (n x) 2) (compose-inner (car x)
                                           (cadr x))]
               [(> (n x) 2) (compose-inner (car x) (|> (cdr x)))]))]
    (|> (reverse lenses))))


(defun ^. (val lens)
  "Use LENS to focus on a bit of VAL."
  (if (getter? lens)
    ((get-idx lens :view) val)
    (error (.. (pretty lens) " is not a getter"))))

(defun ^~ (val lens f)
  "Use LENS to apply the function F over a bit of VAL."
  (if (setter? lens)
    ((get-idx lens :over) f val)
    (error (.. (pretty lens) " is not a setter"))))

(defun ^= (val lens new)
  "Use LENS to replace a bit of VAL with NEW."
  (^~ val lens (lambda () new)))

(defun view (l v)
  "Flipped synonym for [[^.]]"
  (^. v l))

(defun over (l f v)
  "Flipped synonym for [[^~]]"
  (^~ v l f))

(defun set (l n v)
  "Flipped synonym for [[^=]]"
  (^= v l n))

(defmacro setl! (lens new val)
  "Mutate VAL by replacing a bit of it with NEW, using LENS."
  (let* [(v (gensym "value"))]
    `(let* [(,v ,val)]
       (set! ,val (^= ,new ,v)))))

(defmacro overl! (lens f val)
  "Mutate VAL by applying to a bit of it the function F, using LENS."
  (let* [(v (gensym "value"))]
    `(let* [(,v ,val)]
       (set! ,val (^~ ,f ,v)))))

;; Lenses (for lists and structures)

(define it
  "The simplest lens, not focusing on any subcomponent. In the case of [[over]],
   if the value being focused on is a list, the function is mapped over every
   element of the list."
  (lens (lambda (x) x)
        (lambda (f x)
          (if (list? x)
            (map f x)
            (f x)))))

(define head
  "A lens equivalent to [[car]], which [[view]]s and applies [[over]]
   the first element of a list.

   ### Example:
   ```cl
   > (^. '(1 2 3) head)
   out = 1
   ```"
  (lens car (lambda (f x) (cons (f (car x)) (cdr x)))))

(define tail
  "A lens equivalent to [[cdr]], which [[view]]s and applies [[over]]
   to all but the first element of a list.

   ### Example:
   ```cl
   > (^. '(1 2 3) tail)
   out = (2 3)
   ```"
  (lens cdr (lambda (f x) (cons (car x) (f (cdr x))))))

(defun at (k)
  "A lens that focuses on the K-th element of a list. [[view]] is
   equivalent to `get-idx`, and [[over]] is like `set-idx!`.

   ### Example:
   ```cl
   > (^. '(1 2 3) (at 2))
   out = 2
   ```"
  (lens (lambda (x) (nth x k))
        (lambda (f x)
          (let* [(out '())]
            (for i 1 (n x) 1
              (push-cdr! out
                         (if (or (= i k)
                                 (and (< 0 i)
                                      (= (+ (n x) 1 k) i)))
                           (f (get-idx x i))
                           (get-idx x i))))
            out))))

(defun on (k)
  "A lens that focuses on the element of a structure that is at the key
   K.

   ### Example:
   ```cl
   > (^. { :foo \"bar\" } (on :foo))
   out = \"bar\"
   ```"
  (lens (lambda (x) (get-idx x k))
        (lambda (f x)
          (let* [(out {})]
            (for-pairs (ck v) x
               (if (= k ck)
                  (set-idx! out ck (f v))
                  (set-idx! out ck v)))
            out))))

(defun on! (k)
  "A lens that focuses (**and mutates**) the element of a structure
   that is at the key K.

   ### Example:
   ```cl
   > (define foo { :value 1 })
   out = {\"value\" 1}
   > (^= foo (on! :value) 5)
   out = {\"value\" 5}
   > foo
   out = {\"value\" 5}
   ```"
  (lens (lambda (x)
          (get-idx x k))
        (lambda (f x)
          (set-idx! x k (f (get-idx x k)))
          x)))

(defun traversing (l)
  "A lens which maps the lens L over every element of a given list.

   Example:
   ```cl
   > (view (traversing (at 3)) '((1 2 3) (4 5 6)))
   out = (3 6)
   ```"
  (lens (lambda (x)
          (map (lambda (x) (view l x)) x))
        (lambda (f x)
          (map (lambda (x) (over l f x)) x))))

(defun folding (f z l)
  "Transform the (traversing) lens L into a getter which folds
   the result using the function F and the zero element Z. For
   performance reasons, a right fold is performed.

   Example:
   ```cl
   > (view (folding + 0 (traversing (on :bar)))
   .       (list { :bar 1 }
   .             { :bar 2 }
   .             { :baz 3 } ))
   out = 3
   ```"
  (getter (lambda (x)
            (reduce f z (prune (view l x))))))

(defun accumulating (f z l)
  "Transform the lens L into a getter which folds the result using the
   function F and the zero element Z. For performance reasons, a right
   fold is performed.

   Example:
   ```cl
   > (view (accumulating + 0 (on :bar))
   .       (list { :bar 1 }
   .             { :bar 2 }
   .             { :baz 3 } ))
   out = 3
   ```"
  (getter (lambda (x)
            (reduce f z (prune (map (lambda (x) (view l x)) x))))))

(defun every (x ln)
  "A higher-order lens that focuses LN on every element of a list that
   satisfies the perdicate X. If X is a regular value, it is compared
   for equality (according to [[eql?]]) with every list element. If it
   is a function, it is treated as the predicate.


   Example:
   ```cl
   > (view (every even? it) '(1 2 3 4 5 6))
   out = (2 4 6)
   > (view (every 'x it) '(1 x 2 x 3 x 4 x))
   out = (x x x x)
   ```"
  (let* [(pred (if (invokable? x)
                 (lambda (y)
                   (or (x y)
                       (eql? x y)))
                 (lambda (y) (eql? x y))))]
    (lens (lambda (ls)
            (maybe-map (lambda (x)
                   (if (pred x)
                     (view ln x)
                     nil))
                 ls))
          (lambda (f ls)
            (map (lambda (x)
                   (if (pred x)
                     (over ln f x)
                     x))
               ls)))))
