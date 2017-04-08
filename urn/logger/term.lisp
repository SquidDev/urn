(import urn/range ())
(import urn/logger/printer ())

(import extra/term (colored))

(defun create (verbosity explain time)
  "Create a console logger with VERBOSITY, displaying additional info if EXPLAIN
   is true. TIME specifies the maximum timing verbosity."
  (struct
    :verbosity (or verbosity 0)
    :explain   (= explain true)
    :time      (or time 0)

    :put-error!   put-error!
    :put-warning! put-warning!
    :put-verbose! put-verbose!
    :put-debug!   put-debug!
    :put-time!    put-time!

    :put-node-error!    put-node-error!
    :put-node-warning!  put-node-warning!))

(defun put-error!    (logger msg) :hidden (print-error!   msg))
(defun put-warning!  (logger msg) :hidden (print-warning! msg))
(defun put-verbose!  (logger msg) :hidden (print-verbose! (.> logger :verbosity) msg))
(defun put-debug!    (logger msg) :hidden (print-debug! (.> logger :verbosity)  msg))

(defun put-time! (logger name time level) :hidden (print-time! (.> logger :time) name time level))

(defun put-node-error! (logger msg node explain lines)
  (print-error! msg)
  (put-trace! node)
  (when explain (print-explain! (.> logger :explain) explain))
  (put-lines! true lines))

(defun put-node-warning! (logger msg node explain lines)
  (print-warning! msg)
  (put-trace! node)
  (when explain (print-explain! (.> logger :explain) explain))
  (put-lines! true lines))

(defun put-lines! (range entries)
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
  :hidden
  (when (nil? entries) (error! "Positions cannot be empty"))
  (when (/= (% (# entries) 2) 0) (error! (string/.. "Positions must be a multiple of 2, is " (# entries))))

  (let* ((previous -1)
         (file (.> (nth entries 1) :name))
         (max-line (foldr (lambda (max node)
                            (if (string? node) max (math/max max (.> node :start :line))))
                     0 entries))
         (code (.. (colored 92 (.. " %" (string/#s (number->string max-line)) "s \xe2\x94\x82")) " %s")))
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
  :hidden
  (with (previous nil)
    (while node
      (with (formatted (format-node node))
        (cond
          [(= previous nil) (print! (colored 96 (string/.. "  => " formatted)))]
          [(/= previous formatted) (print! (string/.. "  in " formatted))]
          [true nil])

        (set! previous formatted)
        (set! node (.> node :parent))))))
