(import base (defun = cons pretty error ! debug # car cdr rawget rawset let* and type#))
(import lua/table (empty-struct))

(defun pair (x y)
  "Build a pair out of the values X and Y. X and Y must both [[exist?]],
   otherwise an invalid pair will be produced."
  (let* [(ret (empty-struct))]
    (rawset ret "tag" 'pair)
    (rawset ret "fst" x)
    (rawset ret "snd" y)))

(defun fst (x)
  "Extract the first component of the pair X."
  (rawget x "fst"))

(defun snd (x)
  "Extract the second component of the pair X."
  (rawget x "snd"))

(defun cons->pair (x)
  "Convert the cons structure X into a pair, where [[cons]]es have been replaced
   by applications of [[pair]]. Aditionally, it holds that
     `(eq? (car x) (fst (cons->pair x)))`
   and
     `(eq? (cdr x) (snd (cons->pair x)))`"
  (cond
    [(= (# x) 0) nil]
    [true (pair (car x) (cons->pair (cdr x)))]))

(defun pair->cons (x)
  "The opposite of [[cons->pair]], building a [[cons]] structure out of the
   (possibly nested) pair X. Conversely, it holds that
     `(eq? (fst x) (cdr (pair->cons x)))`
   and
     `(eq? (snd x) (car (pair->cons x)))`"
  (cond
    [(pair? x) (cons (fst x) (pair->cons (snd x)))]
    [(! x) '()]
    [true (error "not a pair: " (pretty x))]))

(defun pair? (x)
  "Test if X is a pair."
  (and (= (type# x) "table")
       (= (type# (rawget x "tag")) "table")
       (= (rawget (rawget x "tag") "contents") "pair")))
