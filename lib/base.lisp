(import lua/basic () :export)
(import lua/table (unpack concat) :export)

(define copy-meta
  "Copies metadata from the inner body to the outer body"
  :hidden
  (lambda (header args body)
    (cond
      ;; If we've only got one entry in the body then use that: we don't want
      ;; to break functions which return a constant value
      ((= (get-idx body "n") 1)
        `(,@header (lambda ,args ,@body)))
      ;; If we've got a string literal then yoink it
      ((= (type# (car body)) "string")
        (copy-meta `(,@header ,(car body)) args (cdr body)))
      ;; If we've got a table then check if it is a string or key.
      ((= (type# (car body)) "table")
        (cond
          ((= (get-idx (car body) "tag") "string")
            (copy-meta `(,@header ,(car body)) args (cdr body)))
          ((= (get-idx (car body) "tag") "key")
            (copy-meta `(,@header ,(car body)) args (cdr body)))
          ;; Simply splice everything together into our final definition
          (true
            `(,@header (lambda ,args ,@body)))))
      (true
        `(,@header (lambda ,args ,@body))))))

(define-macro defun (lambda (name args &body)
                      (copy-meta `(define ,name) args body)))

(define-macro defmacro (lambda (name args &body)
                         (copy-meta `(define-macro ,name) args body)))

(define car (lambda (xs) (get-idx xs 1)))
(define cdr (lambda (xs) (slice xs 2)))
(defun list (&xs) xs)
(defun cons (x xs) (list x (unpack xs)))

(defmacro progn (&body)
  `((lambda () ,@body)))

(defmacro if (c t b) `(cond (,c ,t) (true ,b)))
(defmacro when (c &body) `(cond (,c ,@body) (true)))
(defmacro unless (c &body) `(cond (,c) (true ,@body)))

(defun debug (x) (print (pretty x)) x)

(defmacro let* (vars &body)
  (if (= (# vars) 0)
    `((lambda () ,@body))
    `((lambda (,(car (car vars)))
        (let* ,(cdr vars) ,@body))
      ,(car (cdr (car vars))))))

(defun ! (expr) (if expr false true))

(defmacro for (ctr start end step &body)
  (let* [(impl (gensym))
         (ctr' (gensym))
         (end' (gensym))
         (step' (gensym))]
    `(let* [(,end' ,end)
            (,step' ,step)
            (,impl nil)]
       (set! ,impl (lambda (,ctr')
                     (cond
                       ((if (< 0 ,step) (<= ,ctr' ,end') (>= ,ctr' ,end'))
                         (let* ((,ctr ,ctr')) ,@body)
                         (,impl (+ ,ctr' ,step')))
                       (true))))
       (,impl ,start))))

(defmacro while (check &body)
  (let* [(impl (gensym))]
    `(let* [(,impl nil)]
       (set! ,impl
         (lambda ()
           (cond
             [,check ,@body (,impl)]
             [true])))
       (,impl))))

(defmacro with (var &body)
  `((lambda (,(get-idx var 1)) ,@body) ,(get-idx var 2)))

(defmacro and (a b &rest)
  (with (symb (gensym))
    `(with (,symb ,a) (if ,symb ,(if (= (# rest) 0) b `(and ,b ,@rest)) ,symb))))

(defmacro or (a b &rest)
  (with (symb (gensym))
    `(with (,symb ,a) (if ,symb ,symb ,(if (= (# rest) 0) b `(or ,b ,@rest))))))
