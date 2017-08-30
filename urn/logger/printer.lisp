(import extra/term (coloured))

(defun print-error! (msg)
  "Print an error messaage, MSG."
  (unless (string? msg) (set! msg (pretty msg)))
  (with (lines (string/split msg "\n" 1))
    (print! (coloured 31 (.. "[ERROR] " (car lines))))
    (when (cadr lines) (print! (cadr lines)))))

(defun print-warning! (msg)
  "Print a warning message, MSG."
  (with (lines (string/split msg "\n" 1))
    (print! (coloured 33 (.. "[WARN] " (car lines))))
    (when (cadr lines) (print! (cadr lines)))))

(defun print-verbose! (verbosity msg)
  "Print a verbose message, MSG if VERBOSITy is greater than 0."
  (when (> verbosity 0)
    (format true "[VERBOSE] {#msg:id}")))

(defun print-debug! (verbosity msg)
  "Print a debug message, MSG if VERBOSITY is greater than 1."
  (when (> verbosity 1)
    (format true "[DEBUG] {#msg:id}")))

(defun print-time! (maximum name time level)
  "Print the TIME NAME took to execute, if LEVEL is <= MAXIMIM."
  (when (<= level maximum)
    (format true "[TIME] {#name:id} took {#time:id}")))

(defun print-explain! (explain lines)
  "Put all LINES when explaining is enabled"
  (when explain
    (for-each line (string/split lines "\n")
      (print! (.. "  " line)))))
