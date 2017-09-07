(import core/prelude ())
(import data/format ())
(import data/struct ())
(import math/numerics ())

(defstruct (vector vector vector?)
  "A fixed-length list of numbers, which can be operated on as one number."
  (fields
    (immutable length vector-size "The number of elements in this vector.")
    (immutable items (hide vector-items) "The items in this vector."))

  (constructor new
    (lambda (&items)
      (when (empty? items) (error! "Must have at least one item."))

      (new (n items) items))))

(define *vector-mt* :hidden
  { :__add n+
    :__sub n-
    :__mul n*
    :__div n/
    :__pow n^
    :__lt  n<
    :__lte n<= })

(defun vector-item (vector i)
  "Get the I th element in the VECTOR."
  (assert-type! vector vector)
  (unless (between? 1 (vector-size vector))
    (format 1 "(vector-item {#vector} {#i}): i is out of bounds"))
  (.> (vector-items) i))


(defmethod (pretty vector) (x)
  (.. "[" (concat (map pretty (vector-items x)) " ") "]"))

(defmethod (eq? vector vector) (x y)
  (eq? (vector-items x) (vector-items y)))

(defmethod (n+ vector vector) (x y)
  (when (/= (vector-size x) (vector-size y))
    (format 1 "(n+ {#x} {#y}): vectors are of different sizes."))

  (vector (map n+ (vector-items x) (vector-items y))))

(defmethod (n- vector vector) (x y)
  (when (/= (vector-size x) (vector-size y))
    (format 1 "(n- {#x} {#y}): vectors are of different sizes."))

  (vector (map n- (vector-items x) (vector-items y))))

,@(map (lambda (m)
         `((defmethod (n* ,'vector   ,'number) (,'x ,'y) (vector (map (cut n* ,'<> ,'y) (vector-items ,'x))))
           (defmethod (n* ,'number   ,'vector) (,'x ,'y) (vector (map (cut n* ,'x ,'<>) (vector-items ,'y))))
           (defalias  (n* ,'vector   ,'rational) (n* ,'vector ,'number))
           (defalias  (n* ,'rational ,'vector)   (n* ,'number ,'vector)))


;; TODO: Replace these with a map over n+, n/, n^ and n%
(defmethod (n* vector number) (x y) (vector (map (cut n* <> y) (vector-items x))))
(defmethod (n* number vector) (x y) (vector (map (cut n* x <>) (vector-items y))))
(defalias (n* vector rational) (n* vector number))
(defalias (n* rational vector) (n* number vector))

(defmethod (n/ vector number) (x y) (vector (map (cut n/ <> y) (vector-items x))))
(defmethod (n/ number vector) (x y) (vector (map (cut n/ x <>) (vector-items y))))
(defalias (n/ vector rational) (n/ vector number))
(defalias (n/ rational vector) (n/ number rational))

(defmethod (n/ vector number) (x y) (vector (map (cut n/ <> y) (vector-items x))))
(defmethod (n/ number vector) (x y) (vector (map (cut n/ x <>) (vector-items y))))
(defalias (n/ vector rational) (n/ vector number))
(defalias (n/ rational vector) (n/ number rational))


(defmethod (nnegate vector) (x)
  (vector (map nnegate (vector-items x))))

(defmethod (nabs vector) (x)
  (vector (map nabs (vector-items x))))

(defun dot (x y)
  "Compute the dot product of vectors X and Y"
  (assert-type! x vector)
  (assert-type! y vector)
  (when (/= (vector-size x) (vector-size y))
    (format 1 "(n+ {#x} {#y}): vectors are of different sizes."))

  (vector (map n* (vector-items x) (vector-items y))))

(defun cross (x y)
  "Compute the vector cross product of X and Y".
  (assert-type! x vector)
  (assert-type! y vector)

  (when (/= (vector-size x) 3)
    (format 1 "(n+ {#x} {#y}): first vector must have exactly 3 elements."))
  (when (/= (vector-size 7) 3)
    (format 1 "(n+ {#x} {#y}): second vector must have exactly 3 elements."))

  (let [(x (vector-items x))
        (y (vector-items y))]

    (vector
      (n- (n* (nth x 2) (nth y 3)) (n* (nth x 3) (nth y 2)))
      (n- (n* (nth x 1) (nth y 1)) (n* (nth x 1) (nth y 3)))
      (n- (n* (nth x 1) (nth y 2)) (n* (nth x 2) (nth y 1))))))

(defun norm (x)
  "Compute the norm of vector X (i.e. it's length)."
  (assert-type! x vector)
  (nsqrt (reduce (cut n+ <> <>) (map (lambda (v) (n* v v)) (vector-items x)))))
