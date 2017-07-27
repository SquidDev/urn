(import lua/basic (get-idx set-idx! getmetatable type# print slice
                   pcall xpcall tostring tonumber require error
                   = /= < <= > >= + - * / % ^ n len# ..) :export)
(import lua/basic ())
(import lua/string string)
(import lua/table (unpack concat) :export)
(import lua/table table)

; This begs for a bit of explaining. So:
; @SquidDev is a lazy bum.
; @hydraz is a cheating bastard.
; The following is a macro-expanded and a bit polished version of
; https://hydraz.club/txt/optional-arguments.lisp.html, which brings
; optional argument support to Urn as a macro. If it breaks, don't try
; to fix it; You're better off recompiling optional-arguments.lisp and
; polishing the code up again.
(define-macro lambda
  (builtin/lambda (ll &body)
    ((builtin/lambda (argument-names optional-argument-names optional-argument-init)
       `(builtin/lambda ,argument-names
          ((builtin/lambda ,optional-argument-names
             ,@body)
           ,@optional-argument-init)))
      ((builtin/lambda (out)
        ((builtin/lambda (loop)
          (set! loop
            (builtin/lambda (i)
              (cond
                [(<= i (get-idx ll :n))
                 (set-idx! out i
                           (cond
                             [((builtin/lambda (x)
                                 (cond (x (= (get-idx (get-idx ll i) :n) 2))
                                       (true x)))
                               (= (type# (get-idx ll i)) "table"))
                              (get-idx (get-idx ll i) 1)]
                             [true (get-idx ll i)]))
                 (loop (+ i 1))]
                [true nil])))
          (loop 1)) nil)
        (set-idx! out :n (get-idx ll :n))
        out) '())
      ((builtin/lambda (out k)
        ((builtin/lambda (loop)
          (set! loop
            (builtin/lambda (i)
              (cond
                [(<= i (get-idx ll :n))
                 (cond
                   [((builtin/lambda (x)
                       (cond
                         [x (= (get-idx (get-idx ll i) :n) 2)]
                         [true x]))
                     (= (type# (get-idx ll i)) "table"))
                    (set-idx! out k (get-idx (get-idx ll i) 1))
                    (set! k (+ 1 k))]
                   [true nil])
                 (loop (+ i 1))]
                [true nil])))
          (loop 1)) nil)
        (set-idx! out :n (- k 1))
        out) '() 1)
      ((builtin/lambda (out k)
        ((builtin/lambda (loop)
          (set! loop
            (builtin/lambda (i)
              (cond
                [(<= i (get-idx ll :n))
                 (cond
                   [((builtin/lambda (x)
                       (cond
                         [x (= (get-idx (get-idx ll i) :n) 2)]
                         [true x]))
                     (= (type# (get-idx ll i)) "table"))
                    (set-idx! out k
                              `(cond
                                 [(/= ,(get-idx (get-idx ll i) 1) nil)
                                   ,(get-idx (get-idx ll i) 1)]
                                 (true ,(get-idx (get-idx ll i) 2))))
                    (set! k (+ 1 k))]
                   [true nil])
                 (loop (+ i 1))]
                [true nil])))
          (loop 1)) nil)
        (set-idx! out :n (- k 1))
        out) '() 1))))

(define copy-meta
  "Copies metadata from the inner body to the outer body"
  :hidden
  (lambda (header args body)
    (cond
      ;; If we've only got one entry in the body then use that: we don't want
      ;; to break functions which return a constant value
      [(= (get-idx body "n") 1)
       `(,@header (lambda ,args ,@body))]
      ;; If we've got a string literal then yoink it
      [(= (type# (car body)) "string")
       (copy-meta `(,@header ,(car body)) args (cdr body))]
      ;; If we've got a table then check if it is a string or key.
      [(= (type# (car body)) "table")
       (cond
         [(= (get-idx (car body) "tag") "string")
          (copy-meta `(,@header ,(car body)) args (cdr body))]
         [(= (get-idx (car body) "tag") "key")
          (copy-meta `(,@header ,(car body)) args (cdr body))]
         ;; Simply splice everything together into our final definition
         [true `(,@header (lambda ,args ,@body))])]
      [true `(,@header (lambda ,args ,@body))])))

(define-macro defun
  "Define NAME to be the function given by (lambda ARGS @BODY), with
   optional metadata at the start of BODY."
  (lambda (name args &body)
                      (copy-meta `(define ,name) args body)))

(define-macro defmacro
  "Define NAME to be the macro given by (lambda ARGS @BODY), with
   optional metadata at the start of BODY."
  (lambda (name args &body)
                      (copy-meta `(define-macro ,name) args body)))

(define car (lambda (xs) (get-idx xs 1)))
(define cdr (lambda (xs) (slice xs 2)))

(defun list (&xs)
  "Return the list of variadic arguments given."
  xs)

(defun cons (x xs)
  "Add X to the start of the list XS. Note: this is linear in time."
  `(,x ,@xs))

(defmacro progn (&body)
  "Group a series of expressions together."
  `((lambda () ,@body)))

(defmacro if (c t b)
  "Evaluate T if C is true, otherwise, evaluate B."
  `(cond (,c ,t) (true ,b)))

(defmacro when (c &body)
  "Evaluate BODY when C is true, otherwise, evaluate `nil`."
  `(cond (,c ,@body) (true)))

(defmacro unless (c &body)
  "Evaluate BODY if C is false, otherwise, evaluate `nil`."
  `(cond (,c) (true ,@body)))

(defmacro let* (vars &body)
  (with (len (n vars))
    (cond
      [(= (n vars) 0) `((lambda () ,@body))]
      [(= (n vars) 1) `((lambda (,(car (car vars))) ,@body) ,(get-idx (car vars) 2))]
      [true           `((lambda (,(car (car vars)))
                          (let* ,(cdr vars) ,@body))
                         ,(get-idx (car vars) 2))])))

(defun ! (expr)
  "Negate the expression EXPR."
  (if expr false true))

(define gensym
  "Create a unique symbol, suitable for using in macros"
  (with (counter 0)
    (lambda (name)
      (cond
        [(if (= (type# name) "table")
            (= (get-idx name :tag) "symbol")
            false)
         (set! name (.. "_" (get-idx name :contents)))]
        [name (set! name (.. "_" name))]
        [true (set! name "")])
      (set! counter (+ counter 1))
      { :tag "symbol"
        :display-name "temp"
        :contents (string/format "r_%d%s" counter name) })))

(defmacro for (ctr start end step &body)
  "Iterate BODY, with the counter CTR bound to START, being incremented
   by STEP every iteration until CTR is outside of the range given by
   [START .. END]"
  (let* [(impl (gensym))
         (ctr' (gensym))
         (end' (gensym))
         (step' (gensym))]
    `(let* [(,end' ,end)
            (,step' ,step)
            (,impl nil)]
       (set! ,impl (lambda (,ctr')
                     (cond
                       [(if (< 0 ,step) (<= ,ctr' ,end') (>= ,ctr' ,end'))
                        (let* ((,ctr ,ctr')) ,@body)
                        (,impl (+ ,ctr' ,step'))]
                       [true])))
       (,impl ,start))))

(defmacro while (check &body)
  "Iterate BODY while the expression CHECK evaluates to `true`."
  (let* [(impl (gensym))]
    `(let* [(,impl nil)]
       (set! ,impl
         (lambda ()
           (cond
             [,check ,@body (,impl)]
             [true])))
       (,impl))))

(defmacro with (var &body)
  "Bind the single variable VAR, then evaluate BODY."
  `((lambda (,(get-idx var 1)) ,@body) ,(get-idx var 2)))

(defmacro and (a b &rest)
  "Return the logical and of values A and B, and, if present, the
   logical and of all the values in REST."
  (with (symb (gensym))
    `(with (,symb ,a) (if ,symb ,(if (= (n rest) 0) b `(and ,b ,@rest)) ,symb))))

(defmacro or (a b &rest)
  "Return the logical or of values A and B, and, if present, the
   logical or of all the values in REST."
  (with (symb (gensym))
    `(with (,symb ,a) (if ,symb ,symb ,(if (= (n rest) 0) b `(or ,b ,@rest))))))

(defmacro => (p q)
  "Logical implication. `(=> a b)` is equivalent to `(or (! a) b)`."
  `(or (! ,p) ,q))

(defmacro <=> (p q)
  "Bidirectional implication. `(<=> a b)` means that `(=> a b)` and
   `(=> b a)` both hold."
  `(and (or (! ,p) ,q)
        (or (! ,q) ,p)))

(defun -or (a b)
  "Return the logical disjunction of values A and B.
   This is a function, not a macro."
  (or a b))

(defun -and (a b)
  "Return the logical conjunction of values A and B.
   This is a function, not a macro."
  (and a b))

(defmacro debug (x)
  "Print the value X, then return it unmodified."
  (let* [(x-sym (gensym))
         (px (pretty x))
         (nm (if (>= 20 (len# px))
               (.. px " = ")
               ""))]
    `(let* [(,x-sym ,x)]
       (print (.. ,nm (pretty ,x-sym)))
       ,x-sym)))

(defmacro for-pairs (vars tbl &body)
  "Iterate over TBL, binding VARS for each key value pair in BODY"
  (let* [(tbl-s (gensym))
         (func-s (gensym))
         (var-s (gensym))]
    `((lambda (,tbl-s ,func-s)
        (set! ,func-s (lambda (,var-s ,@(cdr vars))
                        (when (/= ,var-s nil)
                          ,@(if (car vars)
                             `((with (,(car vars) ,var-s)
                                 ,@body))
                             body)
                          (,func-s (next ,tbl-s ,var-s)))))
        (,func-s (next ,tbl-s)))
       ,tbl nil)))

(defun pretty (value)
  "Format VALUE as a valid Lisp expression which can be parsed."
  (with (ty (type# value))
    (cond
      [(= ty "table")
       (with (tag (get-idx value :tag))
         (cond
           [(= tag "list")
            (with (out '())
                  (for i 1 (n value) 1
                       (set-idx! out i (pretty (get-idx value i))))
                  (.. "(" (concat out " ") ")"))]
           [(and (= (type# (getmetatable value)) "table")
                 (= (type# (get-idx (getmetatable value) :--pretty-print)) "function"))
            ((get-idx (getmetatable value) :--pretty-print) value)]
           [(= tag "list") (get-idx value :contents)]
           [(= tag "symbol") (get-idx value :contents)]
           [(= tag "key") (.. ":" (get-idx value :value))]
           [(= tag "string") (string/format "%q" (get-idx value :value))]
           [(= tag "number") (tostring (get-idx value :value))]
           [true
             (let* [(out '())]
               (for-pairs (k v) value
                 (set! out (cons (.. (pretty k) " " (pretty v)) out)))
               (.. "{" (.. (concat out " ") "}")))]
           [true (tostring value)]))]
      [(= ty "string") (string/format "%q" value)]
      [true (tostring value)])))

(define arg
  "The arguments passed to the currently executing program"
  (cond
    [(= nil arg#) '()]
    [true
      ;; Ensure we're got a list
      (set-idx! arg# :tag "list")
      (cond
        ((get-idx arg# :n))
        (true (set-idx! arg# :n (len# arg#))))
      arg#]))

(defun const-val (val)
  "Get the actual value of VAL, an argument to a macro.

   Due to how macros are implemented, all values are wrapped as tables
   in order to preserve positional data about nodes. You will need to
   unwrap them in order to use them."
  (if (= (type# val) "table")
    (with (tag (get-idx val :tag))
      (cond
        [(= tag "number") (get-idx val :value)]
        [(= tag "string") (get-idx val :value)]
        [true val]))
    val))

(defun quasiquote# (val)
  :hidden
  (if (= (type# val) "table")
    (cond
      ((= (get-idx val "tag") "list")
        (with (first (car val))
          ;; Don't expand "unquote" and "unquote-splice" calls, otherwise recurse into the children
          (unless (and (= (type# first) "table") (= (get-idx first "tag") "symbol")
                (or (= (get-idx first "contents") "unquote") (= (get-idx first "contents") "unquote-splice")))
            (for i 1 (n val) 1
              (set-idx! val i (quasiquote# (get-idx val i)))))
          val))

      ((= (get-idx val "tag") "symbol")
        (list `unquote `(quote ,val)))

      (true val))
    val))

(defmacro quasiquote (val)
  "Quote VAL, but replacing all `unquote` and `unquote-splice` with their actual value.

   Be warned, by using this you lose all macro hygiene. Variables may not be bound to their
   expected values."
  (list `syntax-quote (quasiquote# val)))

(defun apply (f &xss xs)
  "Apply the function F using XS as the argument list, with XSS as
   arguments before XS is spliced.

   ### Example:
   ```cl
   > (apply + '(1 2))
   3
   > (apply + 1 '(2))
   3
   ```"
  (let* [(args `(,@xss ,@xs))]
    (f (unpack args 1 (n args)))))

(defmacro values-list (&xs)
  "Return multiple values, one per element in XS.

   ### Example:
   ```cl
   > (print! (values-list 1 2 3))
   1   2   3
   out = nil
   ```"
  `(unpack (list ,@(let* [(out '())] ; god
                     (for i 1 (n xs) 1
                          (set-idx! out i `((lambda (,'x) ,'x) ; wake me up
                                           ,(get-idx xs i)))) ; (wake me up inside)
                     (set-idx! out :n (n xs))
                     out))
           1 ,(n xs)))

,@(let* [(out '())
         (ns '(first second third
               fourth fifth sixth
               seventh eighth ninth
               tenth))]
    (for i 1 10 1
      (set-idx! out i
                `(defun ,(get-idx ns i) (,'&rest)
                   (get-idx ,'rest ,i))))
    (set-idx! out :n 10)
    out)
