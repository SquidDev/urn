(import string (.. sub #s rep))
(import list (elem? traverse))

(defun format-value (value)
  "Format the result of VALUE: extracting `:contents` or `:value` if required"
  :hidden
  (if (and (table? value) (get-idx value "contents"))
    (get-idx value "contents")
    (pretty value)))

(defmacro assert! (cnd msg)
  "Assert CND is true, otherwise failing with MSG"
  `(unless ,cnd (error! ,msg 0)))

(defmacro assert (&assertions)
  "Assert each assertion in ASSERTIONS is true

   Each assertion can take several forms:

    - `(= a b)`:  Assert that A and B are equal, printing their values if not
    - `(/= a b)`: Assert that A and B are not equal, printing their values if they are
    - Type assertions of the form `(list? a)`: Assert that A is of the required type.

   ### Example
   ```
   > (assert (= (+ 2 3) 4))
   [ERROR] expected (+ 2 3) and 4 to be equal
   > (assert (/= (+ 2 3) 5))
   [ERROR] expected (+ 2 3) and 5 to be unequal
   > (assert (string? 2))
   [ERROR] expected 2 to be a string
   ```"
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
  "Assert each expression in ASSERTS evaluates to true

   Each expression is expected to be a function call. Each argument is evaluated and the
   final function executed. If it returns a falsey value (nil or false) then each argument
   will be have it's value printed out.

   ### Example
   ```
   > (affirm (= (+ 2 3) (* 2 3)))
   [ERROR] Assertion failed
   (= (+ 2 3) (* 2 3))
      |       |
      |       6
      5
   ```"
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
