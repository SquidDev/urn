(import base (defun defmacro progn for while if
              and or with xpcall rawget 
              format pretty empty-struct
              gensym tostring tonumber require
              unpack list  cons car cdr
              = /= < <= > >= + - * / % ^ .. !
              # exit))

(import base)
(import binders ())
(import list ())
(import types ())
(import function ())
(import table ())
(import lua/io ())

(defun succ (x) (+ x 1))
(defun pred (x) (- x 1))

(defmacro inc! (x) `(set! ,x (+ ,x 1)))
(defmacro dec! (x) `(set! ,x (- ,x 1)))

(define string->number tonumber)
(define number->string tostring)
(define bool->string tostring)

(defun symbol->string (x)
  (if (symbol? x)
    (rawget x "contents")
    nil))
(defun string->symbol (x)
  (struct :tag "symbol" :contents x))

(define error! base/error)
(define print! base/print)
(defun fail (x)
  (error! x 0))
