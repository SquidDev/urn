(import core/prelude ())
(import data/format ())
(import data/struct ())
(import math (gcd))
(import math/numerics ())

(defstruct (rational rational rational?)
  "A rational number, represented as a tuple of numerator and denominator."
  (fields
    (immutable numerator numerator "The rational's numerator")
    (immutable denominator denominator "The rational's denumerator"))
  (constructor new
    (lambda (n d)
      (unless (and (number? n)
                   (= 0 (second (math/modf n))))
        (format 1 "(rational {} {}): numerator must be an integer" n d))
      (unless (and (number? d)
                   (= 0 (second (math/modf d))))
        (format 1 "(rational {%d} {}): denominator must be an integer" n d))
      (when (= d 0)
        (format 1 "(rational {%d} {%d}): denominator is zero" n d))
      (let* [(x (gcd n d))]
        (setmetatable
          (new (/ n x) (/ d x))
          *rational-mt*)))))

(defun normalised-rational-components (x) :hidden
  (if (number? x)
    (case (->rat x)
      [($ $rational ?n ?d)
       (values-list n d)])
    (case (rational (numerator x) (denominator x))
      [($ $rational ?n ?d)
       (values-list n d)])))

(defun ->rat (y)
  "Convert the floating-point number Y to a rational number.

   ### Example:
   ```cl
   > (->rat 3.14)
   out = 157/50
   > (/ 157 50)
   out = 3.14
   ```"
  (let* [((i f) (math/modf y))
         (f' (^ 10 (- (n (tostring f)) 2)))]
    (if (= 0 f) ; it's an integer, so we just /1 it
      (rational y 1)
      (rational (* y f') f'))))

(defun ->float (y)
  "Convert the rational number Y to a floating-point number.

   ### Example:
   ```cl
   > (->float (rational 3 2))
   out = 1.5
   ```"
  (/ (numerator y) (denominator y)))

(defmethod (n+ rational rational) (x y)
  (let* [((xn xd) (normalised-rational-components x))
         ((yn yd) (normalised-rational-components y))]
    (rational (+ (* xn yd) (* yn xd))
              (* xd yd))))

(defmethod (n- rational rational) (x y)
  (let* [((xn xd) (normalised-rational-components x))
         ((yn yd) (normalised-rational-components y))]
    (rational (- (* xn yd) (* yn xd))
              (* xd yd))))

(defmethod (n* rational rational) (x y)
  (let* [((xn xd) (normalised-rational-components x))
         ((yn yd) (normalised-rational-components y))]
    (rational (* xn yn) (* xd yd))))

(defmethod (n< rational rational) (x y)
  (let* [((xn xd) (normalised-rational-components x))
         ((yn yd) (normalised-rational-components y))]
    (< (* xn yd) (* yn xd))))
(defalias (n< rational number) (n< rational rational))
(defalias (n< number rational) (n< rational rational))

(defmethod (n<= rational rational) (x y)
  (let* [((xn xd) (normalised-rational-components x))
         ((yn yd) (normalised-rational-components y))]
    (<= (* xn yd) (* yn xd))))
(defalias (n<= rational number) (n<= rational rational))
(defalias (n<= number rational) (n<= rational rational))

(defmethod (n^ rational number) (x y)
  (when (/= 0 (second (math/modf y)))
    (format 1 "(^ {#x} {#y}): exponent must be an integral number."))
  (if (>= y 0)
    (let* [((xn xd) (normalised-rational-components x))]
      (rational (^ xn y) (^ xd y)))
    (nrecip (n^ x (nnegate y)))))

(defmethod (nsqrt rational) (x)
  (let* [((xn xd) (normalised-rational-components x))]
    (rational (math/sqrt xn) (math/sqrt xd))))

(define *rational-mt* :hidden
  { :__add n+
    :__sub n-
    :__mul n*
    :__div n/
    :__pow n^
    :__lt  n<
    :__lte n<= })

(defmethod (pretty rational) (x)
  (let* [((xn xd) (normalised-rational-components x))]
    (format nil "{%d}/{%d}" xn xd)))

(defmethod (eq? rational rational) (x y)
  (let* [((xn xd) (normalised-rational-components x))
         ((yn yd) (normalised-rational-components y))]
    (and (= xn yn)
         (= xd yd))))
(defalias (eq? number rational) (eq? rational rational))
(defalias (eq? rational number) (eq? rational rational))

(defmethod (nrecip rational) (x)
  (rational (denominator x) (numerator x)))

(defmethod (nnegate rational) (x)
  (* x -1))

(defmethod (nabs rational) (x)
  (rational (nabs (denominator x)) (nabs (numerator x))))

(defmethod (nsign rational) (x)
  (* (nsign (denominator x)) (nsign (numerator x))))

(defmethod (n/ rational rational) (x y) (n* x (nrecip y)))

,@(dolist [(op '(n+ n* n- n/))
           (at '(rational number))
           (bt '(rational number))]
    (when (neq? at bt)
      `(defalias (,op ,at ,bt) (,op ,'rational ,'rational))))
