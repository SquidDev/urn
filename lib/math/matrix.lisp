(import core/prelude ())
(import data/format ())
(import data/struct ())
(import math/numerics ())

(defstruct (matrix (hide make-matrix) matrix?)
  "A matrix with a fixed width and height."
  (fields
    (immutable width width "The width of this matrix.")
    (immutable height height "The height of this matrix.")
    (immutable items (hide matrix-items) "The values in this matrix.")))

(defun matrix (width height &items)
  "Create a new matrix with the given WIDTH and HEIGHT.

   ### Example:
   ```cl
   > (matrix 2 2
   .   1 2
   .   3 4)
   out = [1 2 // 3 4]
   ```"
  (assert-type! width number)
  (assert-type! height number)
  (when (empty? items)
    (format 1 "(matrix {#width} {#height} {#items}): cannot create an empty matrix"))
  (when (/= (* width height) (n items))
    (format 1 "(matrix {#width} {#height} {#items}): incorrect number of items"))

  (make-matrix width height items))

(defun identity (dim)
  "Create the identity matrix with the given DIM.

   ### Example:
   ```cl
   > (identity 2)
   out = [1 0 // 0 1]
   ```"
  (assert-type! dim number)
  (when (< dim 1)
    (format 1 "(identity {#dim}): cannot create an empty matrix"))
  (with (out '())
    (for i 1 (* dim dim) 1 (push! out 0))
    (for i 1 dim 1 (.<! out (+ (* dim (pred i)) i) 1))
    (make-matrix dim dim out)))

(defun matrix-item (matrix y x)
  "Get the item in the provided MATRIX at Y X.

   ### Example:
   ```cl
   > (define m (matrix 2 2
   .             1 2
   .             3 4))
   > (matrix-item m 2 1)
   out = 3
   ```"
  (assert-type! matrix matrix)
  (assert-type! y number)
  (assert-type! x number)

  (unless (between? y 1 (height matrix))
    (format 1 "(matrix-item {#matrix} {#y} {#x}): y is out of bounds"))
  (unless (between? x 1 (width matrix))
    (format 1 "(matrix-item {#matrix} {#y} {#x}): x is out of bounds"))

  (nth (matrix-items matrix) (+ (* (pred y) (width matrix)) x)))

(defmethod (pretty matrix) (m)
  (with (buffer '())
    (for y 1 (height m) 1
      (when (> y 1) (push! buffer "//"))
      (for x 1 (width m) 1
        (push! buffer (pretty (matrix-item m y x)))))

    (.. "[" (concat buffer " ") "]")))

(defmethod (eq? matrix matrix) (x y)
  (and (= (width x) (width y))
       (= (height x) (height y))
       (eq? (matrix-items x) (matrix-items y))))

(defmethod (n+ matrix matrix) (x y)
  (when (or (/= (width x) (width y)) (/= (height x) (height y)))
    (format 1 "(n+ {#x} {#y}): matrices are of different dimensions."))

  (make-matrix (width x) (height x) (map n+ (matrix-items x) (matrix-items y))))

(defmethod (n- matrix matrix) (x y)
  (when (or (/= (width x) (width y)) (/= (height x) (height y)))
    (format 1 "(n- {#x} {#y}): matrices are of different dimensions."))

  (make-matrix (width x) (height x) (map n- (matrix-items x) (matrix-items y))))

,@(flat-map (lambda (m)
              ~((defmethod (,m matrix number) (x y)
                  (make-matrix (width x) (height x) (map (cut ,m <> y) (matrix-items x))))
                (defmethod (,m number matrix) (x y)
                  (make-matrix (width y) (height y) (map (cut n* x <>) (matrix-items y))))
                (defalias (,m matrix rational) (,m matrix number))
                (defalias (,m matrix complex)  (,m matrix number))
                (defalias (,m rational matrix) (,m number matrix))
                (defalias (,m complex matrix)  (,m number matrix))))
    `(n* n/))

(defmethod (n* matrix matrix) (a b)
  (let [(wa (width  a))
        (ha (height a))
        (wb (width  b))
        (hb (height b))]

    (when (/= wa hb)
      (format 1 "(n* {#a} {#b}): matrices have incompatible dimensions"))

    (let [(out '())
          (ia (matrix-items a))
          (ib (matrix-items b))]
      (for y 1 ha 1
        (for x 1 wb 1
          (with (accum 0)
            (for i 1 wa 1
              (set! accum (n+ accum (n* (matrix-item a y i) (matrix-item b i x)))))
            (push! out accum))))

      (make-matrix ha wb out))))

(defun echelon (matrix)
  "Reduce the given MATRIX to row echelon form.

   ### Example:
   ```cl
   > (echelon (matrix 3 2
   .            1 2 3
   .            4 5 6))
   out = [1 1.25 1.5 // 0 1 2]
   ```"
  (assert-type! matrix matrix)
  (let [(out (map id (matrix-items matrix)))
        (w (width matrix))
        (h (height matrix))]

    (for k 1 (math/min w h) 1
      ;; Find the "optimal" row to switch to
      (let [(largest nil)
            (largest-y nil)]
        (for y k h 1
          (with (item (nabs (nth out (+ (* (pred y) w) k))))
            (when (or (= largest nil) (n> item largest))
              (set! largest item)
              (set! largest-y y))))

        (when (eq? largest 0)
          (format 1 "(echelon {#matrix}): matrix is singular"))

        ;; Swap the two rows
        (for x 1 w 1
          (let* [(i1 (+ (* (pred k) w) x))
                 (i2 (+ (* (pred largest-y) w) x))

                 (temp (nth out i1))]
            (.<! out i1 (nth out i2))
            (.<! out i2 temp)))

        (for x k w 1
          (.<! out (+ (* (pred k) w) x)
            (n/ (nth out (+ (* (pred k) w) x)) largest)))

        (for y (succ k) h 1
          (with (f (nth out (+ (* (pred y) w) k)))
            (.<! out (+ (* (pred y) w) k) 0)
            (for x (succ k) w 1
              (.<! out (+ (* (pred y) w) x)
                (n- (nth out (+ (* (pred y) w) x))
                    (n* (nth out (+ (* (pred k) w) x)) f))))))))

    (make-matrix w h out)))

(defun reduced-echelon (matrix)
  "Reduce the given MATRIX to reduced row echelon form.

   ### Example:
   ```cl
   > (echelon (matrix 3 2
   .            1 2 3
   .            4 5 6))
   out = [1 1.25 1.5 // 0 1 2]
   ```"
  (assert-type! matrix matrix)
  (let* [(result (echelon matrix))
         (w (width result))
         (h (height result))
         (out (matrix-items result))]

    ;; Step back up the rows, subtracting each previous one from this one
    (for y h 1 -1
      (for k h (succ y) -1
        (with (multiplier (nth out (+ (* (pred y) w) k)))
          (for x k w 1
            (.<! out (+ (* (pred y) w) x)
              (n- (nth out (+ (* (pred y) w) x))
                  (n* (nth out (+ (* (pred k) w) x)) multiplier)))))))

    result))

(defun invert (matrix)
  "Invert the provided MATRIX.

   ### Example:
   ```cl
   > (invert (matrix 2 2
   .           1 2
   .           3 4))
   out = [-2 1 // 1.5 -0.5]
   ```"
  (assert-type! matrix matrix)
  (when (/= (width matrix) (height matrix))
    (format 1 "(invert {#matrix}): matrix is not square"))

  (let* [(w (width matrix))
         (h (height matrix))
         (items (matrix-items matrix))
         (temp '())]

    (for y 1 h 1
      (for x 1 w 1
        (push! temp (nth items (+ (* (pred y) w) x))))
      (for x 1 w 1
        (push! temp (if (= x y) 1 0))))

    (let [(reduced (matrix-items (reduced-echelon (make-matrix (* w 2) h temp))))
          (out '())]

      (for y 1 h 1
        (for x 1 w 1
          (push! out (nth reduced (+ (* (pred y) (* w 2)) w x)))))
      (make-matrix w h out))))
