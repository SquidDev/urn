(import base (defun getmetatable
              type# >= = + - car
              rawget getmetatable let* while))
(import lua/string ())
(import lua/table (concat))

(import list)

(defun char-at (xs x)
  (sub xs x x))

(defun .. (&args) 
  (concat &args))

(define #s len)

(defun split (text pattern limit)
  (let* [(out '())
         (loop true)
         (start 1)]
    (while loop
      (let* [(pos (list (find text pattern start)))]
        (if (or (= "nil" (type# pos)) (and limit (>= (# out) limit)))
          (progn
            (set! loop false)
            (list/push-cdr! out (sub text start (#s text)))
            (set! start (+ (#s text) 1)))
          (progn
            (let/push-cdr! out (sub text start (- (car pos) 1)))
            (set! start (+ (list/cadr pos) 1))))))
    out))
