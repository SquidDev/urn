(import string)
(import lua/basic (arg))
(import lua/debug (traceback))
(import extra/assert (assert!) :export)

(define tests-passed (gensym))
(define tests-failed (gensym))
(define tests-pending (gensym))
(define tests-total (gensym))
(define prefix (gensym))
(define quiet (gensym))

(defmacro marker (col)
  `(when ,quiet
     (write (.. "\27[1;" ,col "m\226\128\162" "\27[0m"))))

(defmacro it (name &body)
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
  `(progn
     (marker 33)
     (push-cdr! ,tests-pending (.. ,prefix " " ,name))))

(defmacro may (name &body)
  `(with (,prefix (.. ,prefix " may " ,name ", and")) ,@body))

(defmacro will (name &body)
  `(with (,prefix (.. ,prefix " will")) (it ,name ,@body)))

(defmacro will-not (name &body)
  `(with (,prefix (.. ,prefix " won't")) (it ,name ,@body)))

(defmacro is (name &body)
  `(with (,prefix (.. ,prefix " is")) (it ,name ,@body)))

(defmacro can (name &body)
  `(with (,prefix (.. ,prefix " can")) (it ,name ,@body)))

(defmacro describe (name &body)
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
       (print! (string/format "\027[1;32m- Passed tests:\027[0m (%d)" (# ,tests-passed)))
       (for-each ,'passed ,tests-passed
         (print! (string/format "\27[1;32m+\27[0m %s" ,'passed))))

     (unless (nil? ,tests-pending)
       (print! (string/format "\027[1;33m- Pending tests:\027[0m (%d)" (# ,tests-pending)))
       (for-each ,'pending ,tests-pending
         (print! (string/format "\27[1;33m*\27[0m %s" ,'pending))))

     (unless (nil? ,tests-failed)
       (print! (string/format "\027[1;31m- Failed tests:\027[0m (%d)" (# ,tests-failed)))
       (for-each ,'failed ,tests-failed
         (print! (string/format "\27[1;31m*\27[0m %s" (car ,'failed)))
         (with (,'lines (string/split (cadr ,'failed) "\n"))
           (for-each ,'line ,'lines (print! (string/format "  %s" ,'line)))))
       (exit! 1))))
