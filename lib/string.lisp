(import base (defun getmetatable if # progn
              type# >= = + - car or and list when
              rawget getmetatable let* while))
(import base (concat) :export)
(import list)
(import lua/string () :export)


(defun char-at (xs x)
  (sub xs x x))

(defun .. (&args) 
  (concat args))

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
            (if (car pos)
              (progn
                (list/push-cdr! out (sub text start (- (car pos) 1)))
                (set! start (+ (list/cadr pos) 1)))
              (set! loop false))))))
    out))

(defun quoted (str)
  (let* [(x (gsub (format "%q" str) "\n" "\\n"))]
    x))
