(import core/prelude ())

(defmacro assert! (cnd msg)
  "Assert CND is true, otherwise failing with MSG"
  :deprecated "Use [[demand]] instead"
  `(demand ,cnd ,msg))

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
                     (push! nodes child)
                     (push! emit false))
                   (with (var (gensym))
                     (push! nodes var)
                     (push! bindings (list var child))
                     (push! emit (and (> i 1) (or (symbol? child) (list? child))))))
                 (push! lens (n str))))

             (push! out "Assertion failed\n")
             ;; Expression output
             (push! out (pretty expr))
             ;; Initial downward arrows
             (with (buffer '("\n "))
               (for j 1 (n expr) 1
                 (push! buffer (if (nth emit j) "|" " "))
                 (push! buffer (string/rep " " (nth lens j))))
               (push! out (concat buffer)))
             ;; Emit each value and their lines
             (for i (n expr) 1 -1
               (when (nth emit i)
                  (with (buffer '("\n "))
                    (for j 1 (- i 1) 1
                      (push! buffer (if (nth emit j) "|" " "))
                      (push! buffer (string/rep " " (nth lens j))))
                    (push! out (concat buffer))
                    (push! out `(pretty ,(nth nodes i))))))
             `(let* (,@bindings)
                (unless ,nodes
                  (error! (.. ,@out))))))
         asserts )))
