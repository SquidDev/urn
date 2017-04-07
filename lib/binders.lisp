(import base (defmacro if ! when car and or
              cdr and pretty print debug
              get-idx defun = # >= error))
(import type (list? nil?))
(import list (cars cadrs caar cadar map cadr
              cdar cddr caddar))

(import lua/basic (getmetatable))

(defun make-binding (xs) :hidden
  (if (= (# xs) 1)
    (car xs)
    (if (>= (# xs) 2)
      `(lambda ,(car xs) ,@(cdr xs))
      (error "Expected binding, got nil."))))

(defun make-let-binding (xs) :hidden
  (if (= (# xs) 2)
    (cadr xs)
    (if (>= (# xs) 3)
      `(lambda ,(cadr xs) ,@(cddr xs))
      (error "Expected binding, got nil."))))

;; Bind multiple variables in succession
(defmacro let* (vars &body)
  "Bind several variables (given in VARS), then evaluate BODY.
   Variables bound with [[let*]] can refer to variables bound
   previously, as they are evaluated in order.

   ### Example
   ```cl
   (let* [(foo 1)
          (bar (+ foo 1))]
     foo
   ```"
  (if (! (nil? vars))
    `((lambda (,(caar vars))
        (let* ,(cdr vars) ,@body))
      ,(make-binding (cdar vars)))
    `((lambda () ,@body))))

(defmacro with (var &body)
  "Bind the single variable VAR, then evaluate BODY."
  `(let* [,var] ,@body))

;; Binds a variable to an expression
(defmacro let (vars &body)
  "Bind several variables (given in VARS), then evaluate BODY.
   In contrast to [[let*]], variables bound with [[let]] can not refer
   to each other.

   ### Example
   ```cl
   (let [(foo 1)
         (bar 2)]
     (+ foo bar))
   ```"
  `((lambda ,(cars vars)
      ,@body)
    ,@(map make-let-binding vars)))

(defmacro when-let (vars &body)
  "Bind VARS, as with [[let]], and check they are all truthy before
   evaluating BODY.

   ```cl
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
     (when (and ,@(cars vars)) ,@body))
    ,@(map make-let-binding vars)))

(defmacro when-let* (vars &body)
  "Bind each pair of `(name value)` of VARS, checking if the value is
   truthy before binding the next, and finally evaluating BODY. As with
   [[let*]], bindings inside [[when-let*]] can refer to previously bound
   names.

   ### Example
   ```cl
   (when-let* [(foo 1)
               (bar nil)
               (baz 2)
     (+ foo baz))
   ```

   Since `1` is truthy, it is evaluated and bound to `foo`, however,
   since `nil` is falsey, evaluation does not continue."
  (cond
    [(nil? vars) `((lambda () ,@body))]
    [true `((lambda (,(caar vars))
              (cond
                [,(caar vars) (when-let* ,(cdr vars) ,@body)]
                [true nil]))
            ,(make-binding (cdar vars)))]))

(defmacro when-with (var &body)
  "Bind the PAIR var of the form `(name value)`, only evaluating BODY if
   the value is truthy

   ### Example
   ```cl
   (when-with (foo (get-idx bar :baz))
      (print! foo))
   ```

   When `bar` has an index `baz`, it will be bound to `foo` and
   printed. If not, the print statement will not be executed."
  `((lambda (,(car var)) (when ,(car var) ,@body)) ,(cadr var)))

(defun make-setting (var) :hidden
  (if (= (# var) 2)
    `(set! ,(car var) ,(cadr var))
    (if (>= (# var) 3)
      `(set! ,(car var) (lambda ,(cadr var) ,@(cddr var)))
      (error "Expected binding, got nil."))))

;; Pre-declare variable and define it, allowing recursive functions to exist
(defmacro letrec (vars &body)
  "Bind several variables (given in VARS), which may be recursive.

   ### Example
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
      ,@(map make-setting vars)
      ,@body)))

(defun finaliser-for (x) :hidden
  `((or (and (getmetatable ,x)
            (get-idx (getmetatable ,x) :--finalise))
       (get-idx ,x :close)
       (lambda ()))))

(defmacro use (var &body)
  "Bind each variable in VAR, checking for truthyness between bindings,
   execute BODY, then run a finaliser for all the variables bound by
   VAR.

   Potential finalisers might be:
   - `(get-idx (getmetatable FOO) :--finalise)`, where FOO is the
     variable.
   - `(get-idx FOO :close)` where FOO is the variable.

   If there is no finaliser for VAR, then nothing is done for it.

   Example:
   ```
   > (use [(file (io/open \"temp\"))] \\
   .   (print! (self file :read \"*a\")))
   *contents of temp*
   ```"
  `(when-let* ,var
     ,@body
     ,@(map finaliser-for
            (cars var))))
