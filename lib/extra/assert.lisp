(import string (.. sub #s rep))
(import list (elem? traverse))

(defun format-value (value)
  "Format the result of VALUE: extracting `:contents` or `:value` if
   required"
  :hidden
  (if (and (table? value) (get-idx value "contents"))
    (get-idx value "contents")
    (pretty value)))

(defmacro assert! (cnd msg)
  "Assert CND is true, otherwise failing with MSG"
  `(unless ,cnd (error! ,msg 0)))

(defmacro affirm (&asserts)
  "Assert each expression in ASSERTS evaluates to true

   Each expression is expected to be a function call. Each argument is
   evaluated and the final function executed. If it returns a falsey
   value (nil or false) then each argument will be have it's value
   printed out.

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
     ,@( map
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
                  (error! (.. ,@out))))))
         asserts )))
