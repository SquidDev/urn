(import extra/term (colored))

(defun print-error! (msg)
  "Print an error messaage, MSG."
  (unless (string? msg) (set! msg (pretty msg)))
  (with (lines (string/split msg "\n" 1))
    (print! (colored 31 (.. "[ERROR] " (car lines))))
    (when (cadr lines) (print! (cadr lines)))))

(defun print-warning! (msg)
  "Print a warning message, MSG."
  (with (lines (string/split msg "\n" 1))
    (print! (colored 33 (.. "[WARN] " (car lines))))
    (when (cadr lines) (print! (cadr lines)))))

(defun print-verbose! (verbosity msg)
  "Print a verbose message, MSG if VERBOSITy is greater than 0."
  (when (> verbosity 0)
    (print! (.. "[VERBOSE] " msg))))

(defun print-debug! (verbosity msg)
  "Print a debug message, MSG if VERBOSITY is greater than 1."
  (when (> verbosity 1)
    (print! (.. "[DEBUG] " msg))))

(defun print-time! (maximum name time level)
  "Print the TIME NAME took to execute, if LEVEL is <= MAXIMIM."
  (when (<= level maximum)
    (print! (.. "[TIME] " name " took " time))))

(defun print-explain! (explain lines)
  "Put all LINES when explaining is enabled"
  (when explain
    (for-each line (string/split lines "\n")
      (print! (.. "  " line)))))
