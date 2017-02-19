(import base (defun defmacro progn for while if
              and or with xpcall rawget rawset pretty 
              gensym tostring tonumber require 
              unpack list  cons car cdr when unless
              = /= < <= > >= + - * / % ^ !  #) :export)

(import base)
(import string (#s format .. concat) :export)
(import lua/os)
(import binders () :export)
(import list () :export)
(import type () :export)
(import function () :export)
(import table () :export)
(import lua/io (close flush input lines open output popen read stderr stdin stdout tmpfile write) :export)

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

(defun fail! (x)
  (error! x 0))

(defun apply (f xs)
  (f (unpack xs)))

(defun exit! (&args)
  (apply lua/os/exit args))
