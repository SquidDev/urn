(import lua/basic ())
(import lua/table (unpack))

(define-macro defun (lambda (name args &body)
  `(define ,name (lambda ,args ,@body))))

(define-macro defmacro (lambda (name args &body)
  `(define-macro ,name (lambda ,args ,@body))))

(defun car (xs) (rawget xs 1))
(defun cdr (xs) (slice xs 2))
(defun list (&xs) xs)
(defun cons (x xs) (list x (unpack xs)))

(defmacro progn (&body)
  `((lambda () ,@body)))

(defmacro if (c t b) `(cond (,c ,t) (true ,b)))
(defmacro when (c &body) `(cond (,c ,@body) (true)))
(defmacro unless (c &body) `(cond (,c) (true ,@body)))

(defmacro let* (vars &body)
  (if (/= (# vars) 0)
    `((lambda (,(car (car vars)))
       (let* ,(cdr vars) ,@body)) ,(cdr (car vars)))
    `((lambda () ,@body))))

(defun ! (expr) (if expr false true))

(defmacro for (ctr start end step &body)
  (let* [(impl (gensym))
         (ctr' (gensym))
         (end' (gensym))
         (step' (gensym))]
    `(let* [(,end' ,end)
            (,step' ,step)
            (,impl nil)]
       (set! ,impl
         (lambda (,ctr)
           (cond
             [(if (< 0 ,step) (<= ,ctr' ,end') (>= ,ctr' ,end'))
              (let* ((,ctr ,ctr')) ,@body)
              (,impl (+ ,ctr' ,step'))]
             [true])))
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
  `((lambda (,(rawget var 1)) ,@body) ,(rawget var 2)))

(defmacro and (a b &rest)
  (with (symb (gensym))
    `(with (,symb ,a) (if ,symb ,(if (= (# rest) 0) b `(and ,b ,@rest)) ,symb))))

(defmacro or (a b &rest)
  (with (symb (gensym))
    `(with (,symb ,a) (if ,symb ,symb ,(if (= (# rest) 0) b `(or ,b ,@rest))))))
