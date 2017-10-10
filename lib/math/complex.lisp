(import core/prelude ())
(import data/format ())
(import data/struct ())
(import math/numerics ())
(import math/rational)

;; FIXME: Hack to ensure vector methods are loaded when we declare aliases
(import math/vector)

(defmacro alias-of (m from to (for 'complex))
  "Create an pair of aliases for a bi-way function."
  :hidden
  (values-list `(defalias (,m ,to ,for) (,m ,from ,for))
               `(defalias (,m ,for ,to) (,m ,for ,from))))

(defstruct (complex complex complex?)
  "Represents a complex number, formed of a [[real]] and [[imaginary]]
   part."
  (fields
    (immutable real real "The real part of this [[complex]] number.")
    (immutable imaginary imaginary "The imaginary part of this [[complex]] number."))
  (constructor (new)
    (lambda (r i)
      (when (complex? r) (format 1 "(complex {#r} {#i}): real part is a complex number"))
      (when (complex? i) (format 1 "(complex {#r} {#i}): imaginary part is a complex number"))

      (new r i))))

(defmethod (pretty complex) (x)
  (if (n< (imaginary x) 0)
    (format nil "{1}{2}i" (real x) (imaginary x))
    (format nil "{1}+{2}i" (real x) (imaginary x))))

(defmethod (eq? complex complex) (x y)
  (and (eq? (real x) (real y)) (eq? (imaginary x) (imaginary y))))

(defmethod (eq? complex number) (x y)
  (and (eq? (real x) y) (eq? (imaginary x) 0)))
(defmethod (eq? number complex) (x y)
  (and (eq? x (real y)) (eq? (imaginary y) 0)))
(alias-of eq? number rational complex)

(defmethod (n+ complex complex) (x y)
  (complex (n+ (real x) (real y)) (n+ (imaginary x) (imaginary y))))
(defmethod (n+ complex number) (x y) (complex (n+ (real x) y) (imaginary x)))
(defmethod (n+ number complex) (x y) (complex (n+ x (real y)) (imaginary y)))
(alias-of n+ number rational)

(defmethod (n- complex complex) (x y)
  (complex (n- (real x) (real y)) (n- (imaginary x) (imaginary y))))
(defmethod (n- complex number) (x y) (complex (n- (real x) y) (imaginary x)))
(defmethod (n- number complex) (x y) (complex (n- x (real y)) (nnegate (imaginary y))))
(alias-of n- number rational)

(defmethod (n* complex complex) (x y)
  (complex (n- (n* (real x) (real y)) (n* (imaginary x) (imaginary y)))
    (n+ (n* (real x) (imaginary y)) (n* (imaginary x) (real y)))))

(defmethod (n* complex number) (x y)
  (complex (n* (real x) y) (n* (imaginary x) y)))

(defmethod (n* number complex) (x y)
  (complex (n* x (real y)) (n* x (imaginary y))))

(alias-of n* number rational complex)

(defmethod (n/ complex complex) (x y)
  (when (eq? y 0) (format 1 "(n/ {#x} {#y}): cannot divide by 0"))
  (with (denom (n+ (n* (real y) (real y)) (n* (imaginary y) (imaginary y))))
    (complex (n/ (n+ (n* (real x) (real y)) (n* (imaginary x) (imaginary y))) denom)
             (n/ (n- (n* (imaginary x) (real y))(n* (real x) (imaginary y))) denom))))

(defmethod (n/ complex number) (x y)
  (when (eq? y 0) (format 1 "(n/ {#x} {#y}): attempt to divide by 0"))
  (complex (n/ (real x) y) (n/ (imaginary x) y)))

(defmethod (n/ number complex) (x y)
  (when (eq? y 0) (format 1 "(n/ {#x} {#y}): cannot divide by 0"))
  (with (denom (n+ (n* (real y) (real y)) (n* (imaginary y) (imaginary y))))
    (complex (n/ (n* x (real y)) denom)
             (n/ (nnegate (n* x (imaginary y))) denom))))

(alias-of n/ number rational complex)

;; Create some aliases for vector operations
(alias-of n* number complex vector)
(alias-of n/ number complex vector)

(defmethod (nrecip complex)  (x) (/ 1 x))

(defun conjugate (z)
  "Get the complex conjugate of Z.

   ### Example
   ```cl
   > (conjugate (complex 1 2))
   out = 1-2i
   ```"
  (assert-type! z complex)
  (complex (real z) (nnegate (imaginary z))))


(defun ->polar (z)
  "Get the [[magnitude]] and [[angle]] of complex number Z.

   ### Example
   ```cl
   > (first (->polar (complex 3 4)))
   out = 5
   > (math/deg (second (-> polar (complex 2 2))))
   out = 45
    ```"
  (assert-type! z complex)
  (let [(r (real z))
        (i (imaginary z))]
    (values-list
      (nsqrt (n+ (n* r r) (n* i i)))
      (math/atan2
        (if (math/rational/rational? i) (math/rational/->float i) i)
        (if (math/rational/rational? r) (math/rational/->float r) r)))))

(defun polar-> (magnitude angle)
  "Create a complex number from the given MAGNITUDE and ANGLE.

   ### Example
   ```cl
   > (polar-> (math/sqrt 2) (math/rad 45))
   out = 1+1i
   ```"
  (assert-type! angle number)
  (complex
    (n* magnitude (math/cos angle))
    (n* magnitude (math/sin angle))))

(defun magnitude (z)
  "Get the magnitude of complex number Z.

   If you need the [[angle]] as well, one should probably use
   [[->polar]].

   ### Example
   ```cl
   > (magnitude (complex 3 4))
   out = 5
   ```"
  (assert-type! z complex)
  (nsqrt (n+ (n* (real z) (real z)) (n* (imaginary z) (imaginary z)))))

(defun angle (z)
  "Get the angle of complex number Z.

   If you need the [[magnitude]] as well, one should probably use
   [[->polar]].

   ### Example
   ```cl
   > (math/floor (math/deg (angle (complex 2 2))))
   out = 45
   ```"
  (assert-type! z complex)
  (let [(r (real z))
        (i (imaginary z))]
    (math/atan2
      (if (math/rational/rational? i) (math/rational/->float i) i)
      (if (math/rational/rational? r) (math/rational/->float r) r))))

(defmethod (nexpt complex number) (z y)
  (with ((mag ang) (->polar z))
    (polar-> (nexpt mag y) (n* ang y))))
