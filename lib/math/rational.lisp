(import core/prelude ())
(import data/format ())
(import data/struct ())
(import math (gcd))
(import math/numerics ())

(defstruct (rational rational rational?)
  "A rational number, represented as a tuple of numerator and denominator."
  (fields
    (immutable numerator numerator "The rational's numerator")
    (immutable denominator denominator "The rational's denominator"))
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
      (when (< d 0)
        (set! d (* -1 d))
        (set! n (* -1 n)))
      (let* [(x (gcd n d))]
        (setmetatable
          (new (/ n x) (/ d x))
          *rational-mt*)))))

(defun ->rat-components (y) :hidden
  (let* [((i f) (math/modf y))
         (f' (expt 10 (- (n (tostring f)) 2)))]
    (if (= 0 f) ;; it's an integer, so we just /1 i
      (values-list y 1)
      (let* [(n (* y f'))
             (g (gcd n f'))]
        (values-list (/ n g) (/ f' g))))))

(defun normalised-rational-components (x) :hidden
  (if (number? x)
    (->rat-components x)
    (values-list (numerator x) (denominator x))))

(defun ->rat (y)
  "Convert the floating-point number Y to a rational number.

   ### Example:
   ```cl
   > (->rat 3.14)
   out = 157/50
   > (/ 157 50)
   out = 3.14
   ```"
  (with ((n d) (->rat-components y))
    (rational n d)))

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

(defmethod (nexpt rational number) (x y)
  (when (/= 0 (second (math/modf y)))
    (format 1 "(expt {#x} {#y}): exponent must be an integral number."))
  (if (>= y 0)
    (let* [((xn xd) (normalised-rational-components x))]
      (rational (expt xn y) (expt xd y)))
    (nrecip (nexpt x (nnegate y)))))

(defmethod (nsqrt rational) (x)
  (let* [((xn xd) (normalised-rational-components x))]
    (rational (math/sqrt xn) (math/sqrt xd))))

(define *rational-mt* :hidden
  { :__add n+
    :__sub n-
    :__mul n*
    :__div n/
    :__pow nexpt
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
  (rational (nabs (numerator x)) (nabs (denominator x))))

(defmethod (nsign rational) (x)
  (* (nsign (numerator x)) (nsign (denominator x))))

(defmethod (n/ rational rational) (x y) (n* x (nrecip y)))

,@(dolist [(op '(n+ n* n- n/))
           (at '(rational number))
           (bt '(rational number))]
    (when (neq? at bt)
      `(defalias (,op ,at ,bt) (,op ,'rational ,'rational))))
