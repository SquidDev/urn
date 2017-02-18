(import base (defun defmacro progn for while if when unless and or with xpcall
              get-idx set-idx! format print! pretty error! empty-struct gensym
              traceback string->number number->string require unpack list cons
              = /= < <= > >= + - * / % ^ .. ! exit) :export)

(import binders () :export)
(import list () :export)
(import types () :export)
(import function () :export)
(import table () :export)
(import io () :export)

(defun fail (msg) (error! msg 0))

(defun between? (val min max) (and (>= val min) (<= val max)))

(defun symbol->string (x) (if (symbol? x) (get-idx x "contents") nil))
(defun bool->string (x) (if x "true" "false"))

(defmacro case (x &cases)
  (let* ((name (gensym))
         (transform-case (lambda (case)
                           (if (list? case)
                             (if (list? (car case))
                               `((,@(car case) ,name) ,@(cdr case))
                               `(,(car case) ,@(cdr case)))
                             `(true)))))
    `((lambda (,name) (cond ,@(map transform-case cases))) ,x)))

(defun succ (x) (+ 1 x))
(defun pred (x) (- x 1))

(defmacro inc! (x) `(set! ,x (+ ,x 1)))
(defmacro dec! (x) `(set! ,x (- ,x 1)))
