;; base is an internal version of core methods without any extensions or assertions.
;; You should not use this unless you are building core libraries.

;; Methods defined in base should the bare minimum of functionality and be as self-sufficient
;; as possible.

; Comparison operators
(define-native =)
(define-native /=)
(define-native <)
(define-native <=)
(define-native >)
(define-native >=)

; Arithmetic operators
(define-native +)
(define-native -)
(define-native *)
(define-native /)
(define-native %)
(define-native ^)
(define-native ..)

; Table operators
(define-native get-idx)
(define-native set-idx!)
(define-native remove-idx!)
(define-native slice)

; Core functions
(define-native format)
(define-native print!)
(define-native pretty)
(define-native error!)
(define-native type#)
(define-native empty-struct)
(define-native xpcall)
(define-native traceback)
(define-native require)

(define-native string->number)
(define-native number->string)
(define-native clock)

; Compiler functions
(define-native gensym)

;; Creates a top-level function
(define-macro defun (lambda (name args &body)
  `(define ,name (lambda ,args ,@body))))

;; Create a top-level macro
(define-macro defmacro (lambda (name args &body)
  `(define-macro ,name (lambda ,args ,@body))))

;; Some basic list indexing expressions
(defun # (xs) (get-idx xs "n"))
(defun car (xs) (get-idx xs 1))
(defun cdr (xs) (slice xs 2))

;; Creates a code block, for use where an expression would normally be required.
(defmacro progn (&body)
  `((lambda () ,@body)))

;; Bind multiple variables in succession
(defmacro let* (vars &body)
  (if (/= (# vars) 0)
    `((lambda (,(get-idx (car vars) 1)) (let* ,(cdr vars) ,@body)) ,(get-idx (car vars) 2))
    `((lambda () ,@body))))

;; Binds a single variable
(defmacro with (var &body)
  `((lambda (,(get-idx var 1)) ,@body) ,(get-idx var 2)))

;; Evaluates a condition, evaluating the second argument if truthy, the third
;; argument if falsey.
(defmacro if (c t b) `(cond (,c ,t) (true ,b)))

;; Evaluates a body if the condition is truthy
(defmacro when (c &body) `(cond (,c ,@body) (true)))

;; Evaluates a body if the condition is falsey
(defmacro unless (c &body) `(cond (,c) (true ,@body)))

;; Iterate over a range, evaluating the body.
(defmacro for (ctr start end step &body)
  (let* ((impl (gensym))
         (ctr' (gensym))
         (end' (gensym))
         (step' (gensym)))
    `(let* ((,end' ,end)
              (,step' ,step)
              (,impl nil))
       (set! ,impl (lambda (,ctr')
                     (cond
                       ((if (< 0 ,step) (<= ,ctr' ,end') (>= ,ctr' ,end'))
                         (let* ((,ctr ,ctr')) ,@body)
                         (,impl (+ ,ctr' ,step')))
                       (true))))
       (,impl ,start))))

;; Perform an action whilst a condition evaluates to true
(defmacro while (check &body)
  (with (impl (gensym))
    `(with (,impl nil)
       (set! ,impl (lambda ()
                     (cond
                       (,check ,@body (,impl))
                       (true))))
       (,impl))))

;; Map a function over every item in the list, creating a new list
(defun map (fn li)
  (with (out '())
    (set-idx! out "n" (# li))
    (for i 1 (# li) 1 (set-idx! out i (fn (get-idx li i))))
    out))

;; Binds a variable to an expression
(defmacro let (vars &body)
  `((lambda ,(map car vars) ,@body) ,@(map (lambda (var) (get-idx var 2)) vars)))

;; Pre-declare variable and define it, allowing recursive functions to exist
(defmacro letrec (vars &body)
  `((lambda ,(map car vars)
    ,@(map (lambda (var) `(set! ,(get-idx var 1) ,(get-idx var 2))) vars)
    ,@body)))

;; Evaluates each expression in turn, returning if it evaluates to a non-truthy value.
;; Returns the last evaluated expression.
(defmacro and (a b &rest)
  (with (symb (gensym))
    `(with (,symb ,a) (if ,symb ,(if (= (# rest) 0) b `(and ,b ,@rest)) ,symb))))

;; Evaluates each expression in turn, returning if it evaluates to a truthy value.
;; Returns the last evaluated expression.
(defmacro or (a b &rest)
  (with (symb (gensym))
    `(with (,symb ,a) (if ,symb ,symb ,(if (= (# rest) 0) b `(or ,b ,@rest))))))

;; Return the boolean negation of this value
(defun ! (expr) (cond (expr false) (true true)))
