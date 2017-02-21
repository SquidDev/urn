(import base (defun = cons pretty error ! debug # car cdr rawget rawset let* and type#))
(import lua/table (empty-struct))

(defun pair (x y)
  (let* [(ret (empty-struct))]
    (rawset ret "tag" 'pair)
    (rawset ret "fst" x)
    (rawset ret "snd" y)))

(defun fst (x) (rawget x "fst"))
(defun snd (x) (rawget x "snd"))

(defun cons->pair (x)
  (cond
    [(= (# x) 0) nil]
    [true (pair (car x) (cons->pair (cdr x)))]))

(defun pair->cons (x)
  (cond
    [(pair? x) (cons (fst x) (pair->cons (snd x)))]
    [(! x) '()]
    [true (error "not a pair: " (pretty x))]))

(defun pair? (x)
  (and (= (type# x) "table")
       (= (type# (rawget x "tag")) "table")
       (= (rawget (rawget x "tag") "contents") "pair")))
