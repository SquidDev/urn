(import string)
(import extra/term (colored) :export)
(import lua/math math)

(define verbosity (struct :value 0))
(defun set-verbosity! (level) (.<! verbosity :value level))

(define show-explain (struct :value false))
(defun set-explain! (value) (.<! show-explain :value value))


(defun print-error! (msg)
  "Print an error messaage, MSG"
  (unless (string? msg) (set! msg (pretty msg)))
  (with (lines (string/split msg "\n" 1))
    (print! (colored 31 (string/.. "[ERROR] " (car lines))))
    (when (cadr lines) (print! (cadr lines)))))

(defun print-warning! (msg)
  "Print a warning message, MSG"
  (with (lines (string/split msg "\n" 1))
    (print! (colored 33 (string/.. "[WARN] " (car lines))))
    (when (cadr lines) (print! (cadr lines)))))

(defun print-verbose! (msg)
  "Print a verbose message, MSG"
  (when (> (.> verbosity :value) 0)
    (print! (string/.. "[VERBOSE] " msg))))

(defun print-debug! (msg)
  "Print a debug message, MSG"
  (when (> (.> verbosity :value) 1)
    (print! (string/.. "[DEBUG] " msg))))

(defun format-position (pos)
  "Format position POS to be user-readable"
  (string/.. (.> pos :line) ":" (.> pos :column)))

(defun format-range (range)
  "Format RANGE to be user-readable"
  (if (.> range :finish)
    (string/format "%s:[%s .. %s]" (.> range :name) (format-position (.> range :start)) (format-position (.> range :finish)))
    (string/format "%s:[%s]" (.> range :name) (format-position (.> range :start)))))

(defun format-node (node)
  "Format NODE to give a description of its position

   This is either its position in a source file or the macro which created it"
  (cond
    [(and (.> node :range) (.> node :contents))
     (string/format "%s (%q)" (format-range (.> node :range)) (.> node :contents))]
    [(.> node :range) (format-range (.> node :range))]
    [(.> node :macro)
     (with (macro (.> node :macro))
       (string/format "macro expansion of %s (%s)"
                      (.> macro :var :name)
                      (format-node (.> macro :node))))]
    [(and (.> node :start) (.> node :finish))
     (format-range node)]
    [true "?"]))

(defun get-source (node)
  "Get the nearest source position of NODE

   This will walk up NODE's tree until a non-macro node is found"
  (with (result nil)
    (while (and node (! result))
      (set! result (.> node :range))
      (set! node (.> node :parent)))
    result))

(defun put-lines! (range &entries)
  "Put a series of lines from various ranges to standard output. RANGE controls whether
   the whole range is selected, or just the first character.

   ENTRIES is a list composed of pairs of elements, the first designating its position,
   the second a descriptive piece of text

   Example:
   ```
   > (put-lines! true
       source \"this text\")
    2 | (+ 2 3)
      | ^^^^^^^ this text
   ```"
  (when (nil? entries) (error! "Positions cannot be empty"))
  (when (/= (% (# entries) 2) 0) (error! (string/.. "Positions must be a multiple of 2, is " (# entries))))

  (let* ((previous -1)
         (file (.> (nth entries 1) :name))
         (max-line (foldr (lambda (node max)
                            (if (string? node) max (math/max max (.> node :start :line))))
                     0 entries))
         (code (.. (colored 92 (.. " %" (string/#s (number->string max-line)) "s |")) " %s")))
    (for i 1 (# entries) 2
      (let ((position (.> entries i))
            (message (.> entries (succ i))))

        (cond
          ;; If we're in a different file then print the new file name
          [(/= file (.> position :name))
           (set! file (.> position :name))
           (print! (colored 95 (.. " " file)))]
          ;; If we've got a gap in the lines then print a ...
          [(and (/= previous -1) (> (math/abs (- (.> position :start :line) previous)) 2))
           (print! (colored 92 " ..."))]
          [true])
        (set! previous (.> position :start :line))

        ; Write the current line
        (print! (string/format code
          (number->string (.> position :start :line))
          (.> position :lines (.> position :start :line))))

        ; Write a pointer to the current line
        (with (pointer
          (cond
            [(! range) "^"]
            [(and (.> position :finish) (= (.> position :start :line) (.> position :finish :line)))
             (string/rep "^" (succ (- (.> position :finish :column) (.> position :start :column))))]
            [true "^..."]))

          (print! (string/format code "" (string/..
            (string/rep " " (- (.> position :start :column) 1))
            pointer
            " "
            message))))))))

(defun put-trace! (node)
  "Put a trace of the positions of NODE and all its parents, using the output of [[format-node]]"
  (with (previous nil)
    (while node
      (with (formatted (format-node node))
        (cond
          [(= previous nil) (print! (colored 96 (string/.. "  => " formatted)))]
          [(/= previous formatted) (print! (string/.. "  in " formatted))]
          [true nil])

        (set! previous formatted)
        (set! node (.> node :parent))))))

(defun put-explain! (&lines)
  "Put all LINES when explaining is enabled"
  (when (.> show-explain :value)
    (for-each line lines
      (print! (string/.. "  " line)))))

(defun put-error! (node msg)
  "Print error message MSG for NODE, including its trace and line"
  (print-error! msg)
  (put-trace! node)

  (with (source (get-source node))
    (when source (put-lines! true source ""))))

(defun error-positions! (node msg)
  "Print error message MSG for NODE, including its trace and line, then exit"
  (print-error! msg)
  (put-trace! node)

  (with (source (get-source node))
    (when source (put-lines! true source "")))

  (fail! "An error occured"))

(struct
  :colored        colored

  :formatPosition format-position
  :formatRange    format-range
  :formatNode     format-node

  :putLines       put-lines!
  :putTrace       put-trace!
  :putInfo        put-explain!
  :getSource      get-source

  :printWarning   print-warning!
  :printError     print-error!
  :printVerbose   print-verbose!
  :printDebug     print-debug!

  :errorPositions error-positions!

  :setVerbosity   set-verbosity!
  :setExplain     set-explain!
)
