(import string)
(import lua/debug (traceback))
(import extra/assert (assert!) :export)

(define tests-passed (gensym))
(define tests-failed (gensym))
(define tests-total (gensym))

(defmacro it (name &body) `(progn
  (inc! ,tests-total)
  (xpcall
    (lambda ()
      ,@body
      (push-cdr! ,tests-passed ,name))
    (lambda (,'msg)
      (push-cdr! ,tests-failed (list ,name (traceback ,'msg)))))))

(defmacro describe (name &body)
  `(let ((,tests-passed '())
         (,tests-failed '())
         (,tests-total 0))
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
          (print! (string/format "  %s" (cadr ,'failed)))))))
