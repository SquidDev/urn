(import string (.. sub #s rep))
(import list (elem? traverse))

(defun format-value (value)
  (if (and (table? value) (get-idx value "contents"))
    (get-idx value "contents")
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

(defmacro affirm (&asserts)
  `(progn
     ,@(traverse asserts
         (lambda (expr)
           (let [(bindings '())
                 (vars '())
                 (lens '())
                 (emit '())
                 (out '())]
             (for i 1 (# expr) 1
               (let* [(var (gensym))
                      (child (nth expr i))
                      (str (pretty child))]
                 (push-cdr! vars var)
                 (push-cdr! bindings (list var child))
                 (push-cdr! emit (and (> i 1) (or (symbol? child) (list? child))))
                 (push-cdr! lens (#s str))))

             (push-cdr! out "Assertion failed\n")
             ;; Expression output
             (push-cdr! out (pretty expr))
             ;; Initial downward arrows
             (with (buffer '("\n "))
               (for j 1 (# expr) 1
                 (push-cdr! buffer (if (nth emit j) "|" " "))
                 (push-cdr! buffer (rep " " (nth lens j))))
               (push-cdr! out (concat buffer)))
             ;; Emit each value and their lines
             (for i (# expr) 1 -1
               (when (nth emit i)
                 (with (buffer '("\n "))
                   (for j 1 (pred i) 1
                     (push-cdr! buffer (if (nth emit j) "|" " "))
                     (push-cdr! buffer (rep " " (nth lens j))))
                   (push-cdr! out (concat buffer))
                   (push-cdr! out `(pretty ,(nth vars i))))))
             `(let (,@bindings)
                (unless ,vars
                  (error! (.. ,@out)))))))))
