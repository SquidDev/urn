(import core/base (lambda defun defmacro progn for while if quasiquote const-val and or xpcall pcall
                   values-list gensym tostring tonumber getmetatable require => <=> splice list when
                   unless arg *arguments* apply for-pairs first second third setmetatable n else
                   fourth fifth sixth seventh ninth tenth -and -or + - * / mod expt slice not = /=
                   < <= >= > ..) :export)

(import core/base b)
(import core/binders () :export)
(import core/demand () :export)
(import core/list () :export)
(import core/match () :export)
(import core/method () :export)
(import core/string (concat $) :export)
(import core/string string :export)
(import core/symbol () :export)
(import core/table () :export)
(import core/type () :export)

(import lua/os)
(import lua/io (write) :export)
(import lua/io io :export)
(import lua/math math :export)

(define *standard-output*
  "The standard output stream."
  (io/output))

(define *standard-error*
  "The standard error stream."
  (io/stderr))

(define *standard-input*
  "The standard input stream."
  (io/input))

(define string->number
  "Convert the string X into a number. Returns `nil` if it could not be
   parsed.

   Optionally takes a BASE which the number is in (such as 16 for
   hexadecimal).

   ### Example:
   ```cl
   > (string->number \"23\")
   out = 23
   ```"
  tonumber)

(define number->string
  "Convert the number X into a string."
  tostring)

(define bool->string
  "Convert the boolean X into a string."
  tostring)

(define error!
  "Throw an error."
  b/error)

(define print!
  "Print to standard output."
  b/print)

(defun fail! (x)
  "Fail with the error message X, that is, exit the program immediately,
   without unwinding for an error handler."
  (error! x 0))

(defun exit! (reason code)
  "Exit the program with the exit code CODE, and optionally, print the
   error message REASON."
  (with (code (if (string? reason) code reason))
    (cond
      [lua/os/exit
       (when (string? reason) (print! reason))
       (lua/os/exit code)]
      [(string? reason) (fail! reason)]
      [else (fail!)])))

(defun sprintf (fmt &args)
  "Format the format string FMT using ARGS.

   ### Example
   ```cl
   > (sprintf \"%.3d\" 1)
   out = \"001\"
   ```"
  (apply string/format fmt args))

(defun printf (fmt &args)
  "Print the formatted string FMT using ARGS.

   ### Example
   ```cl :no-test
   > (printf \"%.3d\" 1)
   001
   out = nil
   ```"
  (print! (apply sprintf fmt args)))
