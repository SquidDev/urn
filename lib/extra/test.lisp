(import string)
(import lua/debug (traceback))
(import extra/assert (assert!) :export)

(define tests-passed (gensym))
(define tests-failed (gensym))
(define tests-total (gensym))
(define prefix (gensym))

(defmacro it (name &body)
  `(progn
    (inc! ,tests-total)
    (xpcall
      (lambda ()
        ,@body
        (push-cdr! ,tests-passed (.. ,prefix " " ,name)))
      (lambda (,'msg)
        (push-cdr! ,tests-failed (list (.. ,prefix " " ,name) (traceback ,'msg)))))))

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
         (,tests-total 0)
         (,prefix ,name))
      ,@body

      (print! "Test results: ")
      (print! (string/format "%d (%.2f%%) out of %d passed, %d (%.2f%%) out of %d failed"
        (# ,tests-passed) (* 100 (/ (# ,tests-passed) ,tests-total)) ,tests-total
        (# ,tests-failed) (* 100 (/ (# ,tests-failed) ,tests-total)) ,tests-total))

      (print! (string/format "\027[1;32m- Passed tests:\027[0m (%d)" (# ,tests-passed)))
      (for-each ,'passed ,tests-passed
        (print! (string/format "\27[1;32m+\27[0m %s" ,'passed)))

      (unless (nil? ,tests-failed)
        (print!)

        (print! (string/format "\027[1;31m- Failed tests:\027[0m (%d)" (# ,tests-failed)))
        (for-each ,'failed ,tests-failed
          (print! (string/format "\27[1;31m*\27[0m %s" (car ,'failed)))
          (with (,'lines (string/split (cadr ,'failed) "\n"))
            (for-each ,'line ,'lines (print! (string/format "  %s" ,'line)))))
        (exit! 1))))
