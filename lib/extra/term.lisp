(import string)
(import lua/os os)
(import lua/package package)

(defun colored-ansi (col msg)
  "Color a string MSG colored with COL, using ANSI escape codes"
  :hidden
  (string/.. "\27[" col "m" msg "\27[0m"))

(define colored?
  "Constant defining whether the current terminal has color support"
  (cond
    ;; If '\' isn't the path separator then we're probably OK.
    [(and package/config (/= (string/char-at package/config 1) "\\")) true]
    ;; If we have ANSICON defined then we're probably OK.
    [(and os/getenv (/= (os/getenv "ANSICON") nil)) true]
    ;; If we're running under xterm then we're OK - covers Git for bash
    [(and os/getenv
          (with (term (os/getenv "TERM"))
            (if term (string/find term "xterm") nil)))
     true]
    ;; Otherwise we're probably not
    [true false]))

(define colored
  "Color a string MSG using COL if supported under the current terminal"
  (if colored? colored-ansi (lambda (col msg) msg)))
