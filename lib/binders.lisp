(import base (defmacro if ! when car cdr and pretty print debug))
(import type (list? nil?))
(import list (cars cadrs caar cadar map cadr))

;; Bind multiple variables in succession
(defmacro let* (vars &body)
  "Bind several variables (given in VARS), then evaluate BODY.
   Variables bound with `let*' can refer to variables bound previously,
   as they are evaluated in order.

   Example:
   ```
   (let* [(foo 1)
          (bar (+ foo 1))]
     foo
   ```"
  (if (! (nil? vars))
    `((lambda (,(caar vars)) (let* ,(cdr vars) ,@body)) ,(cadar vars))
    `((lambda () ,@body))))

;; Binds a variable to an expression
(defmacro let (vars &body)
  "Bind several variables (given in VARS), then evaluate BODY.
   In contrast to `let*', variables bound with [[let]] can not refer to
   eachother.

   Example:
   ```
   (let [(foo 1)
         (bar 2)]
     (+ foo bar))
   ```"
  `((lambda ,(cars vars) ,@body) ,@(cadrs vars)))

(defmacro when-let (vars &body)
  "Bind VARS, as with [[let]], and check they are all truthy before evaluating
   BODY.
   ```
   (when-let [(foo 1)
              (bar nil)]
     foo)
   ```
   Does not evaluate `foo`, while
   ```
   (when-let [(foo 1)
              (bar 2)]
     (+ foo bar))
   ```
   does."
  `((lambda ,(cars vars)
     (when (and ,@(cars vars)) ,@body)) ,@(cadrs vars)))

(defmacro when-let* (vars &body)
  "Bind each pair of `(name value)` of VARS, checking if the value is truthy
   before binding the next, and finally evaluating BODY. As with [[let*]],
   bindings inside 'when-let*' can refer to previously bound names.

   Example:
   ```
   (when-let* [(foo 1)
               (bar nil)
               (baz 2)
     (+ foo baz))
   ```
   Since `1` is truthy, it is evaluated and bound to `foo`, however, since
   `nil` is falsey, evaluation does not continue."
  (cond
    [(nil? vars) `((lambda () ,@body))]
    [true `((lambda (,(caar vars))
              (cond
                [,(caar vars) (when-let* ,(cdr vars) ,@body)]
                [true nil]))
            ,(cadar vars))]))

;; Pre-declare variable and define it, allowing recursive functions to exist
(defmacro letrec (vars &body)
  "Bind several variables (given in VARS), which may be recursive.

   Example:
   ```
   > (letrec [(is-even? (lambda (n)
                          (or (= 0 n)
                              (is-odd? (pred n)))))
              (is-odd? (lambda (n)
                         (and (! (= 0 n))
                              (is-even? (pred n)))))]
       (is-odd? 11))
   true
   ```"
  `((lambda ,(cars vars)
      ,@(map (lambda (var) `(set! ,(car var) ,(cadr var))) vars)
      ,@body)))
