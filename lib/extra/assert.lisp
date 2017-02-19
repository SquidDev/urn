(import string (.. sub #s))
(import list (elem? traverse))

(defun format-value (value)
  (if (and (table? value) (rawget value "contents"))
    (rawget value "contents")
    (pretty value)))

(defmacro assert! (cnd msg) `(unless ,cnd (error! ,msg 0)))

(defmacro assert (&assertions)
  (let* [(handle-eq
          (lambda (tree)
            `(assert!
               (eq? ,(car tree) ,(cadr tree))
               ,(..
                  "expected "
                  (format-value (car tree))
                  " and "
                  (format-value (cadr tree))
                  " to be equal"))))
        (handle-neq
          (lambda (tree)
            `(assert!
               (neq? ,(car tree) ,(cadr tree))
               ,(..
                  "expected "
                  (format-value (car tree))
                  " and "
                  (format-value (cadr tree))
                  " to be unequal"))))
        (types '("list" "number" "string" "bool" "thread" "function" "table" "userdata"
                 "symbol" "key"))
        (type-assertion? (lambda (str) (and
                                         (= (sub str (#s str) (#s str)) "?")
                                         (elem? (sub str 1 (- (#s str) 1)) types)
                                         )))
        (handle-ty (lambda (ty x)
                     `(assert!
                        (= (type ,x) ,ty)
                        ,(.. "expected "
                             (format-value x)
                             " to be a " ty))))]
    `(progn
       ,@(traverse assertions
           (lambda (assertion)
             (with (x (car assertion))
               (cond
                 [(eq? '= x) (handle-eq (cdr assertion))]
                 [(eq? '/= x) (handle-neq (cdr assertion))]
                 [(type-assertion? (symbol->string x))
                 (let* [(str (symbol->string x))
                   (typ (sub str 1 (- (#s str) 1)))]
                   (handle-ty typ (cadr assertion)))]
                 [true (print! (pretty assertion))])))))))
