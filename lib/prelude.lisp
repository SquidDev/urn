(import base (defun defmacro progn for while if quasiquote const-val
              and or with xpcall get-idx set-idx! pretty pcall
              gensym tostring tonumber require
              unpack list cons when unless arg
              = /= < <= > >= + - * / % ^ ! # debug) :export)

(import base)
(import string (#s format .. concat) :export)
(import lua/os)
(import binders () :export)
(import list () :export)
(import type () :export)
(import function () :export)
(import table () :export)
(import lua/io (write) :export)
(import match (destructuring-bind case) :export)

(defun succ (x)
  "Return the successor of the number X."
  (+ x 1))

(defun pred (x)
  "Return the predecessor of the number X."
  (- x 1))

(defmacro inc! (x)
  "Increment the variable X in place."
  `(set! ,x (+ ,x 1)))

(defmacro dec! (x)
  "Decrement the variable X in place."
  `(set! ,x (- ,x 1)))

(define string->number
  "Convert the string X into a number. Returns `nil` if it could not be parsed.

   Optionally takes a BASE which the number is in (such as 16 for hexadecimal)."
  tonumber)

(define number->string
  "Convert the number X into a string."
  tostring)

(define bool->string
  "Convert the boolean X into a string."
  tostring)

(defun symbol->string (x)
  "Convert the symbol X to a string."
  (if (symbol? x)
    (get-idx x "contents")
    nil))

(defun string->symbol (x)
  "Convert the string X to a symbol."
  (struct :tag "symbol" :contents x))

(define error!
  "Throw an error."
  base/error)

(define print!
  "Print to standard output."
  base/print)

(defun fail! (x)
  "Fail with the error message X, that is, exit the program immediately,
   without unwinding for an error handler."
  (error! x 0))

(defun exit! (reason code)
  "Exit the program with the exit code CODE, and optionally, print the
   error message REASON."
  (with (code (if (string? reason) code reason))
    (when (string? reason) (print! reason))
    (lua/os/exit code)))

(defun id (x)
  "Return the value X unmodified."
  x)

(defun const (x)
  "Return a function which always returns X. This is equivalent to the `K`
   combinator in SK combinator calculus."
  (lambda (y) x))

(defun self (x key &args)
  "Index X with KEY and invoke the resulting function with X and ARGS"
  ((get-idx x key) x (unpack args 1 (# args))))
