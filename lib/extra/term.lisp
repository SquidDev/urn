(import lua/os os)
(import lua/package package)

(defun colored-ansi (col msg)
  "Color a string MSG colored with COL, using ANSI escape codes"
  :hidden
  (.. "\27[" col "m" msg "\27[0m"))

(define colored?
  "Constant defining whether the current terminal has color support"
  (with (term (string/lower (or (os/getenv "TERM") "")))
    (cond
      ;; If the terminal is dumb, then emit plain text.
      [(= term "dumb") false]
      ;; If we're running under xterm then we're OK. This covers Git Bash for Windows.
      [(string/find term "xterm") true]
      ;; If '/' is the path separator then we're probably on a UNIX system.
      [(and package/config (= (string/char-at package/config 1) "/")) true]
      ;; If we have ANSICON defined then we're in a windows prompt which supports ANSI.
      [(and os/getenv (/= (os/getenv "ANSICON") nil)) true]
      ;; Stick to plain text: better safe than sorry.
      [true false])))

(define colored
  "Color a string MSG using COL if supported under the current terminal"
  (if colored? colored-ansi (lambda (col msg) msg)))
