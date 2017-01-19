(import base (defmacro if ! when))
(import list ())

;; Bind multiple variables in succession
(defmacro let* (vars &body)
  (if (! (nil? vars))
    `((lambda (,(caar vars)) (let* ,(cdr vars) ,@body)) ,(cadar vars))
    `((lambda () ,@body))))

;; Binds a variable to an expression
(defmacro let (vars &body)
  `((lambda ,(cars vars) ,@body) ,@(cadrs vars)))

(defmacro when-let (vars &body)
  `((lambda ,(cars vars)
     (when (and ,@(cars vars)) ,@body)) ,@(cadrs vars)))

(defmacro when-let* (vars &body)
  (cond
    [(nil? vars) `((lambda () ,@body))]
    [true `((lambda (,(caar vars))
              (cond
                [,(caar vars) (when-let* ,(cdr vars) ,@body)]
                [true nil]))
            ,(cadar vars))]))

;; Pre-declare variable and define it, allowing recursive functions to exist
(defmacro letrec (vars &body)
  `((lambda ,(map car vars)
    ,@(map (lambda (var) `(set! ,(car 1) ,(cadr 2))) vars)
    ,@body)))
