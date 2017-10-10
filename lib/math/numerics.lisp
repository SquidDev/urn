(import core/prelude ())

(defgeneric n+    (x y) "Generalised numeric addition.")
(defgeneric n-    (x y) "Generalised numeric subtraction.")
(defgeneric n*    (x y) "Generalised numeric cross product.")
(defgeneric n/    (x y) "Generalised numeric division.")
(defgeneric nmod  (x y) "Generalised numeric modulus.")
(defgeneric nexpt (x y) "Generalised numeric exponentiation.")
(defgeneric n<    (x y) "Generalised numeric less-than comparison.")
(defgeneric n<=   (x y) "Generalised numeric less-than or equal to comparison.")

(defgeneric nsqrt (x)   "Generalised numeric square root.")
(defgeneric nrecip (x)  "Generalised numeric reciprocal.")
(defgeneric nnegate (x) "Generalised numeric negation.")
(defgeneric nsign (x)   "Generalised numeric sign number. (-1 for negative numbers, 1 otherwise)")
(defgeneric nabs (x)    "Generalised numeric absolute value.")

(defun n> (x y)  "Generalised numeric greater than." (n< y x))
(defun n>= (x y) "Generalised numeric greater than or equal to." (n<= y x))
(defun n= (x y)  "Generalised numeric equality." (eq? x y))

; Boilerplate instances:

,@(map (lambda (x)
         `(defmethod (,(sym.. 'n x) ,'number ,'number) (,'x ,'y)
            (,x ,'x ,'y)))
       '(+ - * / mod expt < <=))

(defmethod (nsqrt number)   (x) (math/sqrt x))
(defmethod (nrecip number)  (x) (/ 1 x))
(defmethod (nnegate number) (x) (* x -1))
(defmethod (nabs number)    (x) (math/abs x))
(defmethod (nsign number)   (x)
  (cond
    [(= x 0) 0]
    [(/= x x) nil] ; NaN
    [(> x 0) 1]
    [else -1]))

(defdefault nnegate (x) (n* -1 x))
