(import base (defun defmacro progn for while if quasiquote const-val
              and or xpcall get-idx set-idx! pretty pcall
              gensym tostring tonumber require => <=>
              unpack list when unless arg apply
              = /= < <= > >= + - * / % ^ ! # debug) :export)

(import lua/bit32 () :export)
(import base)
(import string (#s format .. concat) :export)
(import string string :export)
(import lua/os)
(import binders () :export)
(import list () :export)
(import type () :export)
(import function () :export)
(import table () :export)
(import setf () :export)
(import lua/io (write) :export)
(import lua/math math :export)
(import lua/math maths :export)
(import match (destructuring-bind case handler-case matches? function if-match) :export)

(defun succ (x)
  "Return the successor of the number X."
  (+ x 1))

(defun pred (x)
  "Return the predecessor of the number X."
  (- x 1))

(define string->number
  "Convert the string X into a number. Returns `nil` if it could not be
   parsed.

   Optionally takes a BASE which the number is in (such as 16 for
   hexadecimal)."
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
  { :tag "symbol" :contents x })

(defun sym.. (&xs)
  "Concatenate all the symbols in XS."
  (string->symbol (concat (map symbol->string xs))))

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
  "Return a function which always returns X. This is equivalent to the
   `K` combinator in SK combinator calculus."
  (lambda (y) x))

(defun call (x key &args)
  "Index X with KEY and invoke the resulting function with ARGS."
  ((get-idx x key) (unpack args 1 (# args))))

(defun self (x key &args)
  "Index X with KEY and invoke the resulting function with X and ARGS"
  ((get-idx x key) x (unpack args 1 (# args))))

(defun even? (x)
  "Is X an even number?"
  (= (% x 2) 0))

(defun odd? (x)
  "Is X an odd number?"
  (/= (% x 2) 0))
