(import core/prelude ())
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
      (when (= d 0)
        (error! (sprintf "(rational %d %d): denominator is zero" n d)))
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
   out = (rational 157 50)
   > (/ 157 50)
   out = 3.14
   ```"
  (let* [((i f) (math/modf y))
         (f' (^ 10 (- (n (tostring f)) 2)))]
    (rational (* y f') f')))

(defun ->float (y)
  "Convert the rational number Y to a floating-point number.

   ### Example:
   ```cl
   > (->float (rational 20 2))
   out = 10
   ```"
  (/ (numerator y) (denominator y)))

(defgeneric r+ (x y) "Add rational numbers")
(defmethod (r+ rational rational) (x y)
  (let* [((xn xd) (normalised-rational-components x))
         ((yn yd) (normalised-rational-components y))]
    (rational (+ (* xn yd) (* yn xd))
              (* xd yd))))

(defmethod (r+ rational number) (x y) (r+ x (->rat y)))
(defmethod (r+ number rational) (x y) (r+ (->rat x) y))
(defmethod (r+ number number)   (x y) (r+ (->rat x) (->rat y)))

(defgeneric r- (x y) "Subtract rational numbers")
(defmethod (r- rational rational) (x y)
  (let* [((xn xd) (normalised-rational-components x))
         ((yn yd) (normalised-rational-components y))]
    (rational (- (* xn yd) (* yn xd))
              (* xd yd))))

(defmethod (r- rational number) (x y) (r- x (->rat y)))
(defmethod (r- number rational) (x y) (r- (->rat x) y))
(defmethod (r- number number)   (x y) (r- (->rat x) (->rat y)))

(defgeneric r* (x y) "Multiply rational numbers")
(defmethod (r* rational rational) (x y)
  (let* [((xn xd) (normalised-rational-components x))
         ((yn yd) (normalised-rational-components y))]
    (rational (* xn yn) (* xd yd))))

(defmethod (r* rational number) (x y) (r* x (->rat y)))
(defmethod (r* number rational) (x y) (r* (->rat x) y))
(defmethod (r* number number)   (x y) (r* (->rat x) (->rat y)))

(defun r/ (x y)
  "Divide rational numbers"
  (r* x (recip y)))

(defun rexp (x y)
  "Raise the rational number X to the primitive numeric (integral or float)
   power Y.

   ### Example:
   ```cl
   > (rexp (rational 1 4) 2)
   out = (rational 1 16)
   ```"
  (if (>= y 0)
    (let* [((xn xd) (normalised-rational-components x))]
      (rational (^ xn y) (^ xd y)))
    (recip (rexp x (* y -1)))))

(define *rational-mt* :hidden
  { :__add r+
    :__sub r-
    :__mul r*
    :__div r/ })

(defmethod (pretty rational) (x)
  (let* [((xn xd) (normalised-rational-components x))]
    (case xd
      [1 (tostring xn)]
      [else (sprintf "(rational %d %d)" xn xd)])))

(defmethod (eq? rational rational) (x y)
  (let* [((xn xd) (normalised-rational-components x))
         ((yn yd) (normalised-rational-components y))]
    (and (= xn xd)
         (= yn yd))))

(defun recip (x)
  "Compute the reciprocal of rational number X"
  (rational (denominator x) (numerator x)))
