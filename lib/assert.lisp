(import string)

(defmacro assert! (cnd msg) `(if (! ,cnd) (error! ,msg 0)))

(defun format-value (value)
  (pretty (if (and (table? value) (get-idx value "contents"))
            (get-idx value "contents")
            value)))

(defmacro assert (&assertions)
  (let ((handle-eq
          (lambda (tree)
            `(assert!
               (= ,(car tree) ,(cadr tree))
               ,(string/..
                  "expected "
                  (format-value (car tree))
                  " and "
                  (format-value (cadr tree))
                  " to be equal"))))
        )
    (traverse assertions
              (lambda (x)
                (case (symbol->string (car x))
                  ((= "=") (handle-eq (cdr x))))))))

(assert (= 2 3))
