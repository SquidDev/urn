(import io/term (coloured))
(import lua/debug debug)
(import lua/os (clock))

(import test/assert () :export)
(import test/check ()  :export)

(define tests-passed  :hidden (gensym))
(define tests-failed  :hidden (gensym))
(define tests-pending :hidden (gensym))
(define tests-total   :hidden (gensym))
(define prefix        :hidden (gensym))
(define quiet         :hidden (gensym))
(define time          :hidden (gensym))
(define start-time    :hidden (gensym))

(defun traceback (obj)
  :hidden
  (debug/traceback (if (string? obj) obj (pretty obj)) 2))

(defmacro marker (colour)
  "Add a dot with the given COLOUR to mark a single test's result"
  :hidden
  `(when ,quiet
     (write (coloured ,colour "\226\128\162"))))

(defun format-err (x)
  "Format an error message"
  :hidden
  (if (string? x) (const-val x) (pretty x)))

(defmacro it (name &body)
  "Create a test NAME which executes all expressions and assertions in
   BODY"
  `(with (,start-time (clock))
    (inc! ,tests-total)
    (xpcall
      (lambda ()
        ,@body
        (push! ,tests-passed (.. ,prefix " " ,name (if ,time (string/format " (took %.2f seconds)" (- (clock) ,start-time)) "")))
        (marker 32))
      (lambda (,'msg)
        (marker 31)
        (push! ,tests-failed (list (.. ,prefix " " ,name) (if ,quiet (format-err ,'msg) (traceback (format-err ,'msg)))))))))

(defmacro pending (name &body)
  "Create a test NAME whose BODY will not be run.

   This is primarily designed for assertions you know will fail and need
   to be fixed, or features which have not been implemented yet"
  `(progn
     (marker 33)
     (push! ,tests-pending (.. ,prefix " " ,name))))

(defmacro section (name &body)
  "Create a group of tests defined in BODY whose names take the form
   `<prefix> NAME <test_name>`"
  `(with (,prefix (.. ,prefix " " ,name)) ,@body))

(defmacro may (name &body)
  "Create a group of tests defined in BODY whose names take the form
   `<prefix> may NAME, and <test_name>`"
  `(with (,prefix (.. ,prefix " may " ,name ", and")) ,@body))

(defmacro will (name &body)
  "Create a test whose BODY asserts NAME will happen"
  `(with (,prefix (.. ,prefix " will")) (it ,name ,@body)))

(defmacro will-not (name &body)
  "Create a test whose BODY asserts NAME will not happen"
  `(with (,prefix (.. ,prefix " won't")) (it ,name ,@body)))

(defmacro is (name &body)
  "Create a test whose BODY asserts NAME is true"
  `(with (,prefix (.. ,prefix " is")) (it ,name ,@body)))

(defmacro can (name &body)
  "Create a test whose BODY asserts NAME can happen"
  `(with (,prefix (.. ,prefix " can")) (it ,name ,@body)))

(defmacro cannot (name &body)
  "Create a test whose BODY asserts NAME cannot happen"
  `(with (,prefix (.. ,prefix " cannot")) (it ,name ,@body)))

(defmacro describe (name &body)
  "Create a group of tests, defined in BODY, which test NAME"
  `(let [(,tests-passed '())
         (,tests-failed '())
         (,tests-pending '())
         (,tests-total 0)
         (,prefix ,name)
         (,quiet (any (lambda (,'x) (or (= ,'x "--quiet") (= ,'x "-q"))) *arguments*))
         (,time  (any (lambda (,'x) (or (= ,'x "--time") (= ,'x "-t"))) *arguments*))]
     ,@body

     (when (and ,quiet (or (> ,tests-total 0) (> (n ,tests-pending) 0)))
       ;; If we've been outputting dots then add a new line
       (print!))

     ;; Display a summary of all tests
     (print! (string/format "%d (%.2f%%) out of %d passed, %d (%.2f%%) out of %d failed"
               (n ,tests-passed) (if (= ,tests-total 0) 100 (* 100 (/ (n ,tests-passed) ,tests-total))) ,tests-total
               (n ,tests-failed) (if (= ,tests-total 0) 0   (* 100 (/ (n ,tests-failed) ,tests-total))) ,tests-total))

     ;; We don't care about successful tests when quiet
     (unless (or ,quiet (empty? ,tests-passed))
       (print! (string/format "%s (%d)" (coloured 32 "- Passed tests:") (n ,tests-passed)))
       (for-each ,'passed ,tests-passed
         (print! (.. (coloured 32 "+ ") ,'passed))))

     (unless (empty? ,tests-pending)
       (print! (string/format "%s (%d)" (coloured 33 "- Pending tests:") (n ,tests-pending)))
       (for-each ,'pending ,tests-pending
         (print! (.. (coloured 33 "* ") ,'pending))))

     (unless (empty? ,tests-failed)
       (print! (string/format "%s (%d)" (coloured 31 "- Failed tests:") (n ,tests-failed)))
       (for-each ,'failed ,tests-failed
         (print! (.. (coloured 31 "* ") (car ,'failed)))
         (with (,'lines (string/split (cadr ,'failed) "\n"))
           (for-each ,'line ,'lines (print! (string/format "  %s" ,'line)))))
       (exit! 1))))
