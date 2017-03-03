(import lua/basic (get-idx set-idx! getmetatable type# print slice
                   pcall xpcall tostring tonumber require error
                   = /= < <= > >= + - * / % ^ #) :export)
(import lua/basic ())
(import lua/string string)
(import lua/table (unpack concat) :export)
(import lua/table table)

(define copy-meta
  "Copies metadata from the inner body to the outer body"
  :hidden
  (lambda (header args body)
    (cond
      ;; If we've only got one entry in the body then use that: we don't want
      ;; to break functions which return a constant value
      ((= (get-idx body "n") 1)
        `(,@header (lambda ,args ,@body)))
      ;; If we've got a string literal then yoink it
      ((= (type# (car body)) "string")
        (copy-meta `(,@header ,(car body)) args (cdr body)))
      ;; If we've got a table then check if it is a string or key.
      ((= (type# (car body)) "table")
        (cond
          ((= (get-idx (car body) "tag") "string")
            (copy-meta `(,@header ,(car body)) args (cdr body)))
          ((= (get-idx (car body) "tag") "key")
            (copy-meta `(,@header ,(car body)) args (cdr body)))
          ;; Simply splice everything together into our final definition
          (true
            `(,@header (lambda ,args ,@body)))))
      (true
        `(,@header (lambda ,args ,@body))))))

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
  (list x (unpack xs)))

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
  (if (= (# vars) 0)
    `((lambda () ,@body))
    `((lambda (,(car (car vars)))
        (let* ,(cdr vars) ,@body))
      ,(car (cdr (car vars))))))

(defun ! (expr)
  "Negate the expresison EXPR."
  (if expr false true))

(define gensym
  "Create a unique symbol, suitable for using in macros"
  (with (counter 0)
    (lambda (name)
      (if name
        (set! name (.. "_" name))
        (set! name ""))
      (set! counter (+ counter 1))
      (with (res (table/empty-struct))
        (set-idx! res :tag "symbol")
        (set-idx! res :contents (string/format "r_%d%s" counter name))
        res))))

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
                       ((if (< 0 ,step) (<= ,ctr' ,end') (>= ,ctr' ,end'))
                         (let* ((,ctr ,ctr')) ,@body)
                         (,impl (+ ,ctr' ,step')))
                       (true))))
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
    `(with (,symb ,a) (if ,symb ,(if (= (# rest) 0) b `(and ,b ,@rest)) ,symb))))

(defmacro or (a b &rest)
  "Return the logical or of values A and B, and, if present, the
   logical or of all the values in REST."
  (with (symb (gensym))
    `(with (,symb ,a) (if ,symb ,symb ,(if (= (# rest) 0) b `(or ,b ,@rest))))))

(defun debug (x)
  "Print the value X, then return it unmodified."
  (print (pretty x)) x)

(defun pretty (value)
  "Format VALUE as a valid Lisp expression which can be parsed."
  (with (ty (type# value))
    (cond
      ((= ty "table")
        (with (tag (get-idx value :tag))
          (cond
            ((= tag "list")
              (with (out '())
                (for i 1 (# value) 1
                  (set-idx! out i (pretty (get-idx value i))))
                (.. "(" (.. (concat out " ") ")"))))
            ((= tag "list") (get-idx value :contents))
            ((= tag "symbol") (get-idx value :contents))
            ((= tag "key") (.. ":" (get-idx value :contents)))
            ((= tag "key") (.. ":" (get-idx value :contents)))
            ((= tag "string") (string/format "%q" (get-idx value :value)))
            ((= tag "number") (tostring (get-idx value :value)))
            (true (tostring value)))))
      ((= ty "string") (string/format "%q" value))
      (true (tostring value)))))

(define arg
  "The arguments passed to the currently executing program"
  (cond
    ((= nil arg#) '())
    (true
      ;; Ensure we're got a list
      (set-idx! arg# :tag "list")
      (cond
        ((get-idx arg# :n))
        (true (set-idx! arg# :n (len# arg#))))
      arg#)))

(defun const-val (val)
  "Get the actual value of VAL, an argument to a macro.

   Due to how macros are implemented, all values are wrapped as tables
   in order to preserve positional data about nodes. You will need to
   unwrap them in order to use them."
  (if (type# val)
    (with (tag (get-idx val :tag))
      (cond
        ((= tag "number") (get-idx val :value))
        ((= tag "string") (get-idx val :value))
        (true val)))
    val))

(defun quasiquote# (val)
  :hidden
  (if (= (type# val) "table")
    (cond
      [(= (get-idx val "tag") "list")
        (with (first (car val))
          ;; Don't expand "unquote" and "unquote-splice" calls, otherwise recurse into the children
          (unless (and (= (type# first) "table") (= (get-idx first "tag") "symbol")
                (or (= (get-idx first "contents") "unquote") (= (get-idx first "contents") "unquote-splice")))
            (for i 1 (# val) 1
              (set-idx! val i (quasiquote# (get-idx val i)))))
          val)]

      [(= (get-idx val "tag") "symbol")
        (list `unquote `(quote ,val))]

      [true val])
    val))

(defmacro quasiquote (val)
  "Quote VAL, but replacing all `unquote` and `unquote-splice` with their actual value.

   Be warned, by using this you loose all macro hygiene. Variables may not be bound to their
   expected values."
  (list `syntax-quote (quasiquote# val)))
