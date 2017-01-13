(import base (defmacro defun with for let when if and
              get-idx gensym clock
              =))

(import list (for-each push-cdr! any map traverse concatenate))
(import types (symbol? list? function?))
(import table (.> getmetatable))

;; Checks if this symbol is a wildcard
(defun slot? (symb) (and (symbol? symb) (= (get-idx symb "contents") "<>")))

;; Partially apply a function, where <> is replaced by an argument to a function.
;; Values are evaluated every time the resulting function is called.
(defmacro cut (&func)
  (let ((args '())
        (call '()))
    (for-each item func
      (if (slot? item)
        (with (symb (gensym))
          (push-cdr! args symb)
          (push-cdr! call symb))
        (push-cdr! call item)))
    `(lambda ,args ,call)))

;; Partially apply a function, where <> is replaced by an argument to a function.
;; Values are evaluated when this function is defined.
(defmacro cute (&func)
  (let ((args '())
        (vals '())
        (call '()))
    (for-each item func
      (with (symb (gensym))
        (push-cdr! call symb)
        (if (slot? item)
          (push-cdr! args symb)
          (push-cdr! vals `(,symb ,item)))))
    `(let ,vals (lambda ,args ,call))))

;; Chain a series of method calls together.
;; If the list contains <> then the value is placed there, otherwise the expression is invoked
;; with the previous entry as an argument
(defmacro -> (x &funcs)
  (with (res x)
    (for-each form funcs
      (if (and (list? form) (any slot? form))
        (set! res (map (lambda (x) (if (slot? x) res x)) form))
        (set! res `(,form ,res))))
    res))

;; Predicate for determining whether something can safely be invoked, that is,
;; be at `car` position on an unquoted list.
(defun invokable? (x)
  (or (function? x)
      (and (table? x)
           (table? (getmetatable x))
           (function? (.> (getmetatable x) :__call)))))

(defmacro time! (&defs)
  (traverse
    defs
    (lambda (definition)
      (if (eq? (car definition) "defun")
        (let [(name (cadr definition))
              (args (caddr definition))
              (body (cdddr definition))
              (clockn (gensym))
              (resultn (gensym))]
          `(defun ,name ,args
             (let* [(,clockn (clock))
                     (,resultn (progn ,@body))]
                (print! ,(get-idx name "contents") " took " (- (clock) ,clockn))
                ,resultn)))
        (progn
          (print! (pretty definition))
          definition)))))

(defun eq? (x y)
  (cond
    [(and (symbol? x) (symbol? y))
     (= (get-idx x "contents") (get-idx y "contents"))]
    [(and (symbol? x) (string? y))
     (= (get-idx x "contents") y)]
    [(and (string? x) (symbol? y))
     (= (get-idx y "contents") x)]
    [true (= x y)]))
