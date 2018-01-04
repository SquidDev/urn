(import core/prelude ())

(defun slot? (symb)
  "Test whether SYMB is a slot. For this, it must be a symbol, whose
   contents are `<>`.

   ### Example
   ```cl
   > (slot? '<>)
   out = true
   > (slot? 'not-a-slot)
   out = false
   ```"
  (and (symbol? symb) (= (.> symb "contents") "<>")))

(defmacro cut (&func)
  "Partially apply a function FUNC, where each `<>` is replaced by an
   argument to a function. Values are evaluated every time the resulting
   function is called.

   ### Example
   ```cl
   > (define double (cut * <> 2))
   > (double 3)
   out = 6
   ```"
  (let [(args '())
        (call '())]
    (for-each item func
      (if (slot? item)
        (with (symb (gensym))
          (push! args symb)
          (push! call symb))
        (push! call item)))
    `(lambda ,args ,call)))

(defmacro cute (&func)
  "Partially apply a function FUNC, where each `<>` is replaced by an
   argument to a function. Values are evaluated when this function is
   defined.

   ### Example
   ```cl
   > (define double (cute * <> 2))
   > (double 3)
   out = 6
   ```"
  (let ((args '())
        (vals '())
        (call '()))
    (for-each item func
      (with (symb (gensym))
        (push! call symb)
        (if (slot? item)
          (push! args symb)
          (push! vals `(,symb ,item)))))
    `(let ,vals (lambda ,args ,call))))

(defmacro -> (x &funcs)
  "Chain a series of method calls together. If the list contains `<>`
   then the value is placed there, otherwise the expression is invoked
   with the previous entry as an argument.

   ### Example
   ```cl
   > (-> '(1 2 3)
   .   (map succ <>)
   .   (map (cut * <> 2) <>))
   out = (4 6 8)
   ```"
  (with (res x)
    (for-each form funcs
      (let* [(symb (gensym))
             (body (if (and (list? form) (any slot? form))
                     (map (lambda (x) (if (slot? x) symb x)) form)
                     `(,form ,symb)))]
        (set! res `((lambda (,symb) ,body) ,res))))
    res))

(defun invokable? (x)
  "Test if the expression X makes sense as something that can be applied
   to a set of arguments.

   ### Example
   ```cl
   > (invokable? invokable?)
   out = true
   > (invokable? nil)
   out = false
   > (invokable? (setmetatable {} { :__call (lambda (x) (print! \"hello\")) }))
   out = true
   ```"
  (or (function? x)
      (and (table? x)
           (table? (getmetatable x))
           (invokable? (.> (getmetatable x) :__call)))))

(defun compose (f g)
  "Return the pointwise composition of functions F and G.

   ### Example:
   ```cl
   > ((compose (cut + <> 2) (cut * <> 2))
   .  2)
   out = 6
   ```"
  (if (and (invokable? f)
           (invokable? g))
    (lambda (x) (f (g x)))
    nil))

(defun comp (&fs)
  "Return the pointwise composition of all functions in FS.

   ### Example:
   ```cl
   > ((comp succ (cut + <> 2) (cut * <> 2))
   .  2)
   out = 7
   ```"
  (reduce compose (lambda (x) x) fs))


(defun id (x)
  "Return the value X unmodified.

   ### Example
   ```cl
   > (map id '(1 2 3))
   out = (1 2 3)
   ```"
  x)

(defun as-is (x)
  "Return the value X unchanged.

   ### Example
   ```cl
   > (map as-is '(1 2 3))
   out = (1 2 3)
   ```"
  x)

(defun const (x)
  "Return a function which always returns X. This is equivalent to the
   `K` combinator in SK combinator calculus.

   ### Example
   ```cl
   > (define x (const 1))
   > (x 2)
   out = 1
   > (x \"const\")
   out = 1
   ```"
  (lambda () x))

(defun call (x key &args)
  "Index X with KEY and invoke the resulting function with ARGS.

   ### Example
   ```cl
   > (define tbl { :add + })
   > (call tbl :add 1 2 3)
   out = 6
   ```"
  (apply (.> x key) args))

(defun self (x key &args)
  "Index X with KEY and invoke the resulting function with X and ARGS.

   ### Example
   ```cl
   > (define tbl { :get (lambda (self key) (.> self key))
   .               :x 1
   .               :y 2 })
   > (self tbl :get :x)
   out = 1
   ```"
  (apply (.> x key) x args))
