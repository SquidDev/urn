(import core/prelude ())

(defun gcd (x y)
  "Compute the greatest common divisor of X and Y.

   ### Example
   ```cl
   > (gcd 52 32)
   out = 4
   ```"
  (loop [(x (math/abs x))
         (y (math/abs y))]
    [(= y 0) x]
    (recur y (mod x y))))

(defun lcm (x y)
  "Compute the lowest common multiple of X and Y.

   ### Example
   ```cl
   > (lcm 52 32)
   out = 416
   ```"
  ;; The floor isn't technically needed, but forces it to be an integer under 5.3
  (math/floor (math/abs (/ (* x y) (gcd x y)))))

(defun even? (x)
  "Is X an even number?

   ### Example
   ```cl
   > (even? 2)
   out = true
   > (even? 1)
   out = false
   ```"
  (= (mod x 2) 0))

(defun odd? (x)
  "Is X an odd number?

   ### Example
   ```cl
   > (odd? 1)
   out = true
   > (odd? 2)
   out = false
   ```"
  (/= (mod x 2) 0))

(defun nan? (x)
  "Is X equal to NaN?

   ### Example
   ```cl
   > (nan? (/ 0 0))
   out = true
   > (nan? 1)
   out = false
   ```"
  (/= x x))

(defun succ (x)
  "Return the successor of the number X."
  (+ x 1))

(defun pred (x)
  "Return the predecessor of the number X."
  (- x 1))



(defun round (x)
  "Round X, to the nearest integer.

   ### Example:
   ```cl
   > (round 1.5)
   out = 2
   > (round 1.3)
   out = 1
   > (round -1.3)
   out = -1
   ```"
  (let* [((i f) (math/modf x))]
    (if (if (< x 0)
          (<= -0.5 f)
          (>= f 0.5))
      (math/ceil x)
      (math/floor x))))

(define tiny "Negative infinity" (* -1 math/huge))
