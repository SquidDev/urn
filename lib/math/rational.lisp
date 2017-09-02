(import core/prelude ())
(import data/format ())
(import data/struct ())

(defun gcd (x y) :hidden
  (letrec [(impl (function
                   [(?a 0) a]
                   [(?x ?y) (impl y (% x y))]))]
    (impl (math/abs x) (math/abs y))))

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
  (case (rational (numerator x) (denominator x))
    [($ $rational ?n ?d)
     (values-list n d)]))

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

(defgeneric r+ (x y) "Add rational numbers" :hidden)
(defmethod (r+ rational rational) (x y)
  (let* [((xn xd) (normalised-rational-components x))
         ((yn yd) (normalised-rational-components y))]
    (rational (+ (* xn yd) (* yn xd))
              (* xd yd))))

(defmethod (r+ rational number) (x y) (r+ x (->rat y)))
(defmethod (r+ number rational) (x y) (r+ (->rat x) y))
(defmethod (r+ number number)   (x y) (r+ (->rat x) (->rat y)))

(defgeneric r- (x y) "Subtract rational numbers" :hidden)
(defmethod (r- rational rational) (x y)
  (let* [((xn xd) (normalised-rational-components x))
         ((yn yd) (normalised-rational-components y))]
    (rational (- (* xn yd) (* yn xd))
              (* xd yd))))

(defmethod (r- rational number) (x y) (r- x (->rat y)))
(defmethod (r- number rational) (x y) (r- (->rat x) y))
(defmethod (r- number number)   (x y) (r- (->rat x) (->rat y)))

(defgeneric r* (x y) "Multiply rational numbers" :hidden)
(defmethod (r* rational rational) (x y)
  (let* [((xn xd) (normalised-rational-components x))
         ((yn yd) (normalised-rational-components y))]
    (rational (* xn yn) (* xd yd))))

(defmethod (r* rational number) (x y) (r* x (->rat y)))
(defmethod (r* number rational) (x y) (r* (->rat x) y))
(defmethod (r* number number)   (x y) (r* (->rat x) (->rat y)))

(defgeneric r< (x y) "Less-than relationship between rational numbers")
(defmethod (r< rational rational) (x y)
  (let* [((xn xd) (normalised-rational-components x))
         ((yn yd) (normalised-rational-components y))]
    (< (* xn yd) (* yn xd))))

(defmethod (r< rational number) (x y) (r< x (->rat y)))
(defmethod (r< number rational) (x y) (r< (->rat x) y))
(defmethod (r< number number)   (x y) (r< (->rat x) (->rat y)))

(defgeneric r<= (x y) "Less-than-or-equals relationship between rational numbers")
(defmethod (r<= rational rational) (x y)
  (let* [((xn xd) (normalised-rational-components x))
         ((yn yd) (normalised-rational-components y))]
    (<= (* xn yd) (* yn xd))))

(defmethod (r<= rational number) (x y) (r< x (->rat y)))
(defmethod (r<= number rational) (x y) (r< (->rat x) y))
(defmethod (r<= number number)   (x y) (r< (->rat x) (->rat y)))

(defun r>= (x y)
  "Check if the rational number X is greater than or equal to the
   rational number Y"
  (r<= y x))

(defun r> (x y)
  "Check if the rational number X is greater than the rational number Y"
  (r< y x))

(defun r/ (x y) :hidden
  (r* x (recip y)))

(defun rexp (x y) :hidden
  (if (>= y 0)
    (let* [((xn xd) (normalised-rational-components x))]
      (rational (^ xn y) (^ xd y)))
    (recip (rexp x (* y -1)))))

(defun rsqrt (x)
  "The square root of rational number X.

   ### Example:
   ```cl
   > (rsqrt (rational 1 4))
   out = 1/2
   ```"
  (let* [((xn xd) (normalised-rational-components x))]
    (rational (math/sqrt xn) (math/sqrt xd))))

(define *rational-mt* :hidden
  { :__add r+
    :__sub r-
    :__mul r*
    :__div r/
    :__pow rexp
    :__lt  r<
    :__lte r<= })

(defmethod (pretty rational) (x)
  (let* [((xn xd) (normalised-rational-components x))]
    (format nil "{%d}/{%d}" xn xd)))

(defmethod (eq? rational rational) (x y)
  (let* [((xn xd) (normalised-rational-components x))
         ((yn yd) (normalised-rational-components y))]
    (and (= xn yn)
         (= xd yd))))

(defmethod (eq? rational number) (x y)
  (eq? x (->rat y)))

(defmethod (eq? number rational) (x y)
  (eq? (->rat x) y))

(defun recip (x)
  "Compute the reciprocal of rational number X"
  (rational (denominator x) (numerator x)))
