(import string)
(import extra/term (colored))
(import lua/debug (traceback))
(import extra/assert (assert!) :export)

(define tests-passed  :hidden (gensym))
(define tests-failed  :hidden (gensym))
(define tests-pending :hidden (gensym))
(define tests-total   :hidden (gensym))
(define prefix        :hidden (gensym))
(define quiet         :hidden (gensym))

(defmacro marker (color)
  "Add a dot with the given COLOR to mark a single test's result"
  :hidden
  `(when ,quiet
     (write (colored ,color "\226\128\162"))))

(defmacro it (name &body)
  "Create a test NAME which executes all expressions and assertions in
   BODY"
  `(progn
    (inc! ,tests-total)
    (xpcall
      (lambda ()
        ,@body
        (marker 32)
        (push-cdr! ,tests-passed (.. ,prefix " " ,name)))
      (lambda (,'msg)
        (marker 31)
        (push-cdr! ,tests-failed (list (.. ,prefix " " ,name) (if ,quiet ,'msg (traceback ,'msg))))))))

(defmacro pending (name &body)
  "Create a test NAME whose BODY will not be run.

   This is primarily designed for assertions you know will fail and need
   to be fixed, or features which have not been implemented yet"
  `(progn
     (marker 33)
     (push-cdr! ,tests-pending (.. ,prefix " " ,name))))

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

(defmacro describe (name &body)
  "Create a group of tests, defined in BODY, which test NAME"
  `(let ((,tests-passed '())
         (,tests-failed '())
         (,tests-pending '())
         (,tests-total 0)
         (,prefix ,name)
         (,quiet (any (lambda (,'x) (or (= ,'x "--quiet") (= ,'x "-q"))) arg)))
     ,@body

     (when (and ,quiet (> ,tests-total 0))
       ;; If we've been outputting dots then add a new line
       (print!))

     ;; Display a summary of all tests
     (print! (string/format "%d (%.2f%%) out of %d passed, %d (%.2f%%) out of %d failed"
               (# ,tests-passed) (* 100 (/ (# ,tests-passed) ,tests-total)) ,tests-total
               (# ,tests-failed) (* 100 (/ (# ,tests-failed) ,tests-total)) ,tests-total))

     ;; We don't care about successful tests when quiet
     (unless ,quiet
       (print! (string/format "%s (%d)" (colored 32 "- Passed tests:") (# ,tests-passed)))
       (for-each ,'passed ,tests-passed
         (print! (.. (colored 32 "+ ") ,'passed))))

     (unless (nil? ,tests-pending)
       (print! (string/format "%s (%d)" (colored 33 "- Pending tests:") (# ,tests-pending)))
       (for-each ,'pending ,tests-pending
         (print! (.. (colored 33 "* ") ,'pending))))

     (unless (nil? ,tests-failed)
       (print! (string/format "%s (%d)" (colored 31 "- Failed tests:") (# ,tests-failed)))
       (for-each ,'failed ,tests-failed
         (print! (.. (colored 31 "* ") (car ,'failed)))
         (with (,'lines (string/split (cadr ,'failed) "\n"))
           (for-each ,'line ,'lines (print! (string/format "  %s" ,'line)))))
       (exit! 1))))
