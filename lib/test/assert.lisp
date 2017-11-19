(import core/base (defmacro not with gensym and progn error lambda let*
                   unless for if = list or > n when - ..))
(import core/list (map push-cdr! nth))
(import core/type (list? symbol? pretty))
(import lua/string string)
(import lua/table (concat))

(defmacro assert! (cnd msg)
  "Assert CND is true, otherwise failing with MSG"
  `(unless ,cnd (error ,msg 0)))

(defmacro affirm (&asserts)
  "Assert each expression in ASSERTS evaluates to true

   Each expression is expected to be a function call. Each argument is
   evaluated and the final function executed. If it returns a falsey
   value (nil or false) then each argument will be have it's value
   printed out.

   ### Example
   ```cl :no-test
   > (affirm (= (+ 2 3) (* 2 3)))
   [ERROR] Assertion failed
   (= (+ 2 3) (* 2 3))
      |       |
      |       6
      5
   ```"
  `(progn
     ,@(map
         (lambda (expr)
           (let* [(bindings '())
                 (nodes '())
                 (lens '())
                 (emit '())
                 (out '())]
             (for i 1 (n expr) 1
               (let* [(child (nth expr i))
                      (str (pretty child))]
                 (if (if (= i 1) (not (list? child)) (and (not (list? child)) (not (symbol? child))))
                   (progn
                     (push-cdr! nodes child)
                     (push-cdr! emit false))
                   (with (var (gensym))
                     (push-cdr! nodes var)
                     (push-cdr! bindings (list var child))
                     (push-cdr! emit (and (> i 1) (or (symbol? child) (list? child))))))
                 (push-cdr! lens (n str))))

             (push-cdr! out "Assertion failed\n")
             ;; Expression output
             (push-cdr! out (pretty expr))
             ;; Initial downward arrows
             (with (buffer '("\n "))
               (for j 1 (n expr) 1
                 (push-cdr! buffer (if (nth emit j) "|" " "))
                 (push-cdr! buffer (string/rep " " (nth lens j))))
               (push-cdr! out (concat buffer)))
             ;; Emit each value and their lines
             (for i (n expr) 1 -1
               (when (nth emit i)
                  (with (buffer '("\n "))
                    (for j 1 (- i 1) 1
                      (push-cdr! buffer (if (nth emit j) "|" " "))
                      (push-cdr! buffer (string/rep " " (nth lens j))))
                    (push-cdr! out (concat buffer))
                    (push-cdr! out `(pretty ,(nth nodes i))))))
             `(let* (,@bindings)
                (unless ,nodes
                  (error (.. ,@out))))))
         asserts )))
