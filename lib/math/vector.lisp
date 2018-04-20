(import core/prelude ())
(import data/format ())
(import data/struct ())
(import math ())
(import math/numerics ())

(defstruct (vector (hide make-vector) vector?)
  "A fixed-length list of numbers, which can be operated on as one number."
  (fields
    (immutable dim vector-dim "The dimension of this vector.")
    (immutable items (hide vector-items) "The values in this vector."))

  (constructor new
    (lambda (items)
      (setmetatable (new (n items) items) *vector-mt*))))

(defun vector (&items)
  "Create a new vector from several values.

   ### Example
   ```cl
   > (vector 1 2 3)
   out = [1 2 3]
   ```"
  (when (empty? items)
    (format 1 "(vector {#items}): cannot create a vector with a dimension of 0"))
  (for i 1 (n items) 1
    (when (nan? (nth items i)) (format 1 "(vector {#items}): argument {#i} is not a number")))
  (make-vector items))

(defun list->vector (items)
  "Create a new vector from a list of values.

   ### Example
   ```cl
   > (list->vector '(1 2 3))
   out = [1 2 3]
   ```"
  (assert-type! items list)
  (when (empty? items)
    (format 1 "(list->vector {#items}): cannot create a vector with a dimension of 0"))
  (for i 1 (n items) 1
    (when (nan? (nth items i)) (format 1 "(list->vector ({#items})): element {#i} is not a number")))
  (make-vector items))

(define *vector-mt* :hidden
  { :__add n+
    :__sub n-
    :__mul n*
    :__div n/
    :__mod nmod })

(defun vector-item (x i)
  "Get the I th element in vector X.

   ### Example
   ```cl
   > (define a (vector 5 4 3 2 1))
   > (vector-item a 2)
   out = 4
   > (vector-item a 5)
   out = 1
   ```"
  (assert-type! x vector)
  (assert-type! i number)
  (unless (between? i 1 (vector-dim x))
    (format 1 "(vector-item {#x} {#i}): i is out of bounds"))
  (.> (vector-items x) i))

(defmethod (pretty vector) (x)
  (.. "[" (concat (map pretty (vector-items x)) " ") "]"))

(defmethod (eq? vector vector) (x y)
  (eq? (vector-items x) (vector-items y)))

(defmethod (n+ vector vector) (x y)
  (when (/= (vector-dim x) (vector-dim y))
    (format 1 "(n+ {#x} {#y}): vectors are of different dimensions."))

  (make-vector (map n+ (vector-items x) (vector-items y))))

(defmethod (n- vector vector) (x y)
  (when (/= (vector-dim x) (vector-dim y))
    (format 1 "(n- {#x} {#y}): vectors are of different dimensions."))

  (make-vector (map n- (vector-items x) (vector-items y))))

,@(flat-map (lambda (m)
              `((defmethod (,m ,'vector   ,'number) (,'x ,'y)
                  (when (nan? ,'y)  (format 1 ,(.. "(" (symbol->string m) " {#x} {#y}): attempt to operate on nan")))
                  (make-vector (map (cut ,m ,'<> ,'y) (vector-items ,'x))))
                (defmethod (,m ,'number   ,'vector) (,'x ,'y)
                  (when (nan? ,'x)  (format 1 ,(.. "(" (symbol->string m) " {#x} {#y}): attempt to operate on nan")))
                  (make-vector (map (cut ,m ,'x ,'<>) (vector-items ,'y))))
                (defalias  (,m ,'vector   ,'rational) (,m ,'vector ,'number))
                (defalias  (,m ,'rational ,'vector)   (,m ,'number ,'vector))))
    `(n* nmod))

(defmethod (n/ vector number) (x y)
  (when (nan? y)  (format 1 "(n/ {#x} {#y}): attempt to operate on nan"))
  (when (eq? y 0) (format 1 "(n/ {#x} {#y}): attempt to divide by 0"))

  (make-vector (map (cut n/ <> y) (vector-items x))))
(defmethod (n/ number vector) (x y)
  (when (nan? x) (format 1 "(n/ {#x} {#y}): attempt to operate on nan"))
  (for-each item (vector-items y)
    (when (eq? item 0) (format 1 "(n/ {#x} {#y}): attempt to divide by 0")))

  (make-vector (map (cut n/ x <>) (vector-items y))))
(defalias  (n/ vector   rational) (n/ vector number))
(defalias  (n/ rational vector)   (n/ number vector))

(defmethod (nnegate vector) (x)
  (make-vector (map nnegate (vector-items x))))

(defmethod (nabs vector) (x)
  (make-vector (map nabs (vector-items x))))

(defun dot (x y)
  "Compute the dot product of vectors X and Y.

   ### Example
   ```cl
   > (dot (vector 1 2 3) (vector 3 1 2))
   out = 11
   ```"
  (assert-type! x vector)
  (assert-type! y vector)
  (when (/= (vector-dim x) (vector-dim y))
    (format 1 "(n+ {#x} {#y}): vectors are of different dimensions."))

  (let* [(x (vector-items x))
         (y (vector-items y))
         (accum (n* (car x) (car y)))]
    (for i 2 (n x) 1
      (set! accum (n+ accum (n* (nth x i) (nth y i)))))
    accum))


(defun cross (x y)
  "Compute the vector cross product of X and Y.

   ### Example
   ```cl
   > (cross (vector 1 0 0) (vector 0 1 0))
   out = [0 0 1]
   ```"
  (assert-type! x vector)
  (assert-type! y vector)

  (when (/= (vector-dim x) 3)
    (format 1 "(n+ {#x} {#y}): first vector must have exactly 3 elements."))
  (when (/= (vector-dim y) 3)
    (format 1 "(n+ {#x} {#y}): second vector must have exactly 3 elements."))

  (let [(x (vector-items x))
        (y (vector-items y))]

    (vector
      (n- (n* (nth x 2) (nth y 3)) (n* (nth x 3) (nth y 2)))
      (n- (n* (nth x 1) (nth y 1)) (n* (nth x 1) (nth y 3)))
      (n- (n* (nth x 1) (nth y 2)) (n* (nth x 2) (nth y 1))))))

(defun norm (x)
  "Compute the norm of vector X (i.e. it's length).

   ### Example
   ```cl
   > (norm (vector 3/2 4/2))
   out = 5/2
   ```"
  (assert-type! x vector)
  (nsqrt (reduce (cut n+ <> <>) (map (lambda (v) (n* v v)) (vector-items x)))))

(defun angle (x y)
  "Compute the angle between vectors X and Y.

   ### Example
   ```cl
   > (math/floor (math/deg (angle (vector 1 0) (vector 1 1))))
   out = 45
   ```"
  (math/acos (n/ (dot x y) (n* (norm x) (norm y)))))

(defun unit (x)
  "Convert the vector X into the unit vector. Namely, its direction is
   the same but the magnitude is 1.

   ### Example
   ```cl
   > (unit (vector 3/2 4/2))
   out = [3/5 4/5]
   ```"
  (assert-type! x vector)
  (with (len (norm x))
    (when (= len 0)
      (format 1 "(unit {#x}): vector has 0 length"))
    (n/ x len)))

(defun null (size)
  "Create a vector with a magnitude of 0.

   ### Example
   ```cl
   > (null 3)
   out = [0 0 0]
   ```"
  (assert-type! size number)
  (when (< size 1)
    (format 1 "(zero {#size}): vector must have a positive dimension"))
  (with (out '())
    (for i 1 size 1 (push! out 0))
    (list->vector out)))
