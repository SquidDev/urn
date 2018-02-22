(import lua/basic (get-idx set-idx! getmetatable setmetatable type# print pcall xpcall
                   tostring tonumber require error len# = /= < <= > >= + - * / mod expt
                   ..) :export)
(import lua/basic ())
(import lua/string string)
(import lua/table (concat) :export)
(import lua/table table)

(define else
  "[[else]] is defined as having the value `true`. Use it as the
   last case in a `cond` expression to increase readability."
  true)

(define n
  "Get the length of list X"
  (builtin/lambda (x)
    (cond
      [(= (type# x) "table")
       (get-idx x "n")]
      [true (len# x)]))) ; COMBAK: can't use else here

(define slice
  "Take a slice of XS, with all values at indexes between START and FINISH (or the last
   entry of XS if not specified)."
  (builtin/lambda (xs start finish)
    ;; Ensure finish isn't nil
    (cond
      [finish]
      [true ; COMBAK: can't use else here
       (set! finish (get-idx xs :n))
       (cond [finish] [true (set! finish (len# xs))])])

    ;; Copy values across.
    ((builtin/lambda (len lam)
       (set! lam (lambda (out i j)
                   (builtin/cond
                     [(<= j finish)
                      (set-idx! out i (get-idx xs j))
                      (lam out (+ i 1) (+ j 1))]
                     [true out]))) ; COMBAK: can't use else here

       (cond [(< len 0) (set! len 0)] [true])
       (lam { :tag "list" :n len } 1 start)) (+ (- finish start) 1))))


; This begs for a bit of explaining. So:
; @SquidDev is a lazy bum.
; @hydraz is a cheating bastard.
; The following is a macro-expanded and a bit polished version of
; https://hydraz.semi.works/txt/optional-arguments.lisp.html, which brings
; optional argument support to Urn as a macro. If it breaks, don't try
; to fix it; You're better off recompiling optional-arguments.lisp and
; polishing the code up again.
(define-macro lambda
  (builtin/lambda (ll &body)
    ((builtin/lambda (argument-names recur)
       (set! recur
         (builtin/lambda (i body)
           (cond
             [(< i 1) `(builtin/lambda (unquote argument-names) ,@body)]
             [else
              ((builtin/lambda (k)
                 (cond
                   [(cond
                      [(= (type# (get-idx ll i)) "table") (= (get-idx (get-idx ll i) :n) 2)]
                      [else false])
                    (recur
                      (- i 1)
                      `(((builtin/lambda (,(get-idx k 1)) ,@body)
                          (cond
                            [(= ,(get-idx k 1) nil) ,(get-idx k 2)]
                            [else ,(get-idx k 1)]))))]
                   [else (recur (- i 1) body)]))
                ;; Binding for k
                (get-idx ll i))])))
       (recur (get-idx ll :n) body))
      ((builtin/lambda (out recur)
         (set! recur
           (builtin/lambda (i)
             (cond
               [(<= i (get-idx ll :n))
                (set-idx! out i
                  (cond
                    [(cond
                       [(= (type# (get-idx ll i)) "table") (= (get-idx (get-idx ll i) :n) 2)]
                       [else false])
                     (get-idx (get-idx ll i) 1)]
                    [else (get-idx ll i)]))
                (recur (+ i 1))]
               [else nil])))
         (recur 1)
         (set-idx! out :n (get-idx ll :n))
         out)
        '() nil))))

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
         [else `(,@header (lambda ,args ,@body))])]
      [else `(,@header (lambda ,args ,@body))])))

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
  "Return the list of variadic arguments given.

   ### Example:
   ```cl
   > (list 1 2 3)
   out = (1 2 3)
   ```"

  xs)

(defun cons (x xs)
  "Add X to the start of the list XS. Note: this is linear in time."
  `(,x ,@xs))

(defmacro progn (&body)
  "Group a series of expressions together.

   ### Example
   ```cl
   > (progn
   .   (print! 123)
   .   456)
   123
   out = 456
   ```"
  `((lambda () ,@body)))

(defmacro if (c t b)
  "Evaluate T if C is true, otherwise, evaluate B.

   ### Example
   ```cl
   > (if (> 1 3) \"> 1 3\" \"<= 1 3\")
   out = \"<= 1 3\"
   ```"
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
      [(= len 0) `((lambda () ,@body))]
      [(= len 1) `((lambda (,(car (car vars))) ,@body) ,(get-idx (car vars) 2))]
      [else      `((lambda (,(car (car vars)))
                     (let* ,(cdr vars) ,@body))
                    ,(get-idx (car vars) 2))])))

(defun not (expr)
  "Compute the logical negation of the expression EXPR.

   ### Example:
   ```cl
   > (with (a 1)
   .   (not (= a 1)))
   out = false
   ```"
  (if expr false true))

(define gensym
  "Create a unique symbol, suitable for using in macros"
  (with (counter 0)
    (lambda (name)
      (with (display "temp")
        (cond
          ;; Allow using the symbol as a display name
          [(if (= (type# name) "table")
             (= (get-idx name :tag) "symbol")
             false)
           (cond
             [(get-idx name :display-name)
              (set! display (get-idx name :display-name))
              (set! name (.. "-" (get-idx name :display-name)))]
             [true
              (set! display (get-idx name :contents))
              (set! name (.. "-" (get-idx name :contents)))])]
          ;; Otherwise assume we're a string
          [name
           (set! display (.. "" name))
           (set! name (.. "-" name))]
          ;; If nil, then set as empty.
          [else (set! name "")])

        (set! counter (+ counter 1))
        { :tag "symbol"
          :display-name display
          :contents (string/format "r_%d%s" counter name) }))))

(defmacro for (ctr start end step &body)
  "Iterate BODY, with the counter CTR bound to START, being incremented
   by STEP every iteration until CTR is outside of the range given by
   [START .. END].

   ### Example:
   ```cl
   > (with (x '())
   .   (for i 1 3 1 (push! x i))
   .   x)
   out = (1 2 3)
   ```"
  (let* [(impl (gensym))
         (ctr' (gensym ctr))
         (start' (gensym "for-start"))
         (end' (gensym "for-limit"))
         (step' (gensym "for-step"))]
    `(let* [(,start' ,start)
            (,end' ,end)
            (,step' ,step)
            (,impl nil)]
       (set! ,impl (lambda (,ctr')
                     (cond
                       [(if (< 0 ,step') (<= ,ctr' ,end') (>= ,ctr' ,end'))
                        (let* ((,ctr ,ctr')) ,@body)
                        (,impl (+ ,ctr' ,step'))]
                       [else])))
       (,impl ,start'))))

(defmacro while (check &body)
  "Iterate BODY while the expression CHECK evaluates to `true`.

   ### Example:
   ```cl
   > (with (x 4)
   .   (while (> x 0) (dec! x))
   .   x)
   out = 0
   ```"
  (let* [(impl (gensym))]
    `(let* [(,impl nil)]
       (set! ,impl
         (lambda ()
           (cond
             [,check ,@body (,impl)]
             [else])))
       (,impl))))

(defmacro with (var &body)
  "Bind the single variable VAR, then evaluate BODY."
  `((lambda (,(get-idx var 1)) ,@body) ,(get-idx var 2)))

(defmacro and (a b &rest)
  "Return the logical and of values A and B, and, if present, the
   logical and of all the values in REST.

   Each argument is lazily evaluated, only being computed if the previous
   argument returned a truthy value. This will return the last argument
   to be evaluated.

   ### Example:
   ```cl
   > (and 1 2 3)
   out = 3
   > (and (> 3 1) (< 3 1))
   out = false
   ```"
  (with (symb (gensym))
    `(with (,symb ,a) (if ,symb ,(if (= (n rest) 0) b `(and ,b ,@rest)) ,symb))))

(defmacro or (a b &rest)
  "Return the logical or of values A and B, and, if present, the
   logical or of all the values in REST.

   Each argument is lazily evaluated, only being computed if the previous
   argument returned a falsey value. This will return the last argument
   to be evaluated.

   ### Example:
   ```cl
   > (or 1 2 3)
   out = 1
   > (or (> 3 1) (< 3 1))
   out = true
   ```"
  (with (symb (gensym))
    `(with (,symb ,a) (if ,symb ,symb ,(if (= (n rest) 0) b `(or ,b ,@rest))))))

(defmacro => (p q)
  "Logical implication. `(=> a b)` is equivalent to `(or (not a) b)`.

   ### Example:
   ```cl
   > (=> (> 3 1) (< 1 3))
   out = true
   ```"
  `(or (not ,p) ,q))

(defmacro <=> (p q)
  "Bidirectional implication. `(<=> a b)` means that `(=> a b)` and
   `(=> b a)` both hold.

   ### Example:
   ```cl
   > (<=> (> 3 1) (< 1 3))
   out = true
   > (<=> (> 1 3) (< 3 1))
   out = true
   > (<=> (> 1 3) (< 1 3))
   out = false
   ```"
  `(and (or (not ,p) ,q)
        (or (not ,q) ,p)))

(defun -or (a b)
  "Return the logical disjunction of values A and B.

   As this is a function rather than a macro, it can be used as a
   variable. However, each argument is evaluated eagerly. See [[or]] for
   a lazy version."
  (or a b))

(defun -and (a b)
  "Return the logical conjunction of values A and B.

   As this is a function rather than a macro, it can be used as a
   variable. However, each argument is evaluated eagerly. See [[and]] for
   a lazy version."
  (and a b))

(defmacro for-pairs (vars tbl &body)
  "Iterate over TBL, binding VARS for each key value pair in BODY.

   ### Example:
   ```cl
   > (let [(res '())
   .       (struct { :foo 123 })]
   .   (for-pairs (k v) struct
   .     (push! res (list k v)))
   .     res)
   out = ((\"foo\" 123))
   ```"
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


(define *arguments*
  "The arguments passed to the currently executing program"
  (cond
    [(= nil arg#) '()]
    [true
      ;; Ensure we've got a list
      (set-idx! arg# :tag "list")
      (cond
        [(get-idx arg# :n)]
        [true (set-idx! arg# :n (len# arg#))])
      arg#]))

(define arg
  "The arguments passed to the currently executing program"
  :deprecated "Use [[*arguments*]] instead."
  *arguments*)

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
        [else val]))
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

      (else val))
    val))

(defmacro quasiquote (val)
  "Quote VAL, but replacing all `unquote` and `unquote-splice` with their actual value.

   Be warned, by using this you lose all macro hygiene. Variables may not be bound to their
   expected values.

   ### Example:
   ```cl
   > (with (x 1)
   .   ~(+ ,x 2))
   out = (+ 1 2)
   ```"
  (list `syntax-quote (quasiquote# val)))

(defun splice (xs)
  "Unpack a list of arguments, returning all elements in XS."
  (with (parent (get-idx xs :parent))
    (if parent
      (table/unpack parent (+ (get-idx xs :offset) 1) (+ (get-idx xs :n) (get-idx xs :offset)))
      (table/unpack xs 1 (get-idx xs :n)))))

(defun apply (f &xss xs)
  "Apply the function F using XS as the argument list, with XSS as
   arguments before XS is spliced.

   ### Example:
   ```cl
   > (apply + '(1 2))
   out = 3
   > (apply + 1 '(2))
   out = 3
   ```"
  (f (splice `(,@xss ,@xs))))

(defmacro values-list (&xs)
  "Return multiple values, one per element in XS.

   ### Example:
   ```cl
   > (print! (values-list 1 2 3))
   1   2   3
   out = nil
   ```"
  `(splice (list ,@(let* [(out '())] ; god
                     (for i 1 (n xs) 1
                       (set-idx! out i `((lambda (,'x) ,'x) ; wake me up
                                          ,(get-idx xs i)))) ; (wake me up inside)
                     (set-idx! out :n (n xs))
                     out))))

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
