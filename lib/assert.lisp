(import string (.. sub #s))
(import list (elem traverse))
(import base (print! pretty))

(defun format-value (value)
  (pretty (if (and (table? value) (get-idx value "contents"))
            (get-idx value "contents")
            value)))


(defmacro assert! (cnd msg) `(if (! ,cnd) (error! ,msg 0)))

(defmacro assert (&assertions)
  (let* ((handle-eq
          (lambda (tree)
            `(assert!
               (= ,(car tree) ,(cadr tree))
               ,(..
                  "expected "
                  (format-value (car tree))
                  " and "
                  (format-value (cadr tree))
                  " to be equal"))))
        (handle-neq
          (lambda (tree)
            `(assert!
               (/= ,(car tree) ,(cadr tree))
               ,(..
                  "expected "
                  (format-value (car tree))
                  " and "
                  (format-value (cadr tree))
                  " to be unequal"))))
        (types '("list" "number" "string" "bool" "thread" "function" "table" "userdata"))
        (type-assertion? (lambda (str) (and
                                         (= (sub str (#s str) (#s str)) "?")
                                         (elem (sub str 1 (- (#s str) 1)) types)
                                         )))
        (handle-ty (lambda (ty x)
                     `(assert!
                        (= (type ,x) ,ty)
                        ,(.. "expected "
                             (format-value x)
                             " to be a " ty))))
        )
    `(progn ,@(traverse assertions
              (lambda (x)
                (case (symbol->string (car x))
                  ((= "=") (handle-eq (cdr x)))
                  ((= "/=") (handle-neq (cdr x)))
                  ((type-assertion?) (let* ((str (symbol->string (car x)))
                                            (typ (sub str 1 (- (#s str) 1))))
                                       (handle-ty typ (cadr x))))
                  (true (progn
                          (print! (pretty x))))))))))

