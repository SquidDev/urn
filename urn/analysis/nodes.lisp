(import urn/resolve/builtins (builtins builtin-vars) :export)

(import lua/basic (type#))

(defun builtin? (node name)
  "Determine whether NODE is builtin NAME."
  (and (symbol? node) (= (.> node :var) (.> builtins name))))

(defun side-effect? (node)
  "Checks if NODE has a side effect"
  (with (tag (type node))
    (cond
      ;; Constant terms are obviously side effect free
      [(or (= tag "number") (= tag "string") (= tag "key") (= tag "symbol")) false]
      [(= tag "list")
       (with (head (car node))
         (or
           (/= (type head) "symbol")
           (with (var (.> head :var))
             (cond
               ;; If we're calling a non-builtin symbol, then assume it has a side effect.
               [(/= (.> var :tag) "builtin") true]
               ;; Lambdas and quotes obviously have no side-effect.
               [(= var (.> builtins :lambda)) false]
               [(= var (.> builtins :quote)) false]
               ;; struct-literal has no side effect if empty.
               [(= var (.> builtins :struct-literal)) (/= (n node) 1)]
               ;; Otherwise, assume it'll do something
               [else true]))))])))

(defun constant? (node)
  "Checks if NODE is a constant value"
  (or (string? node) (number? node) (key? node)))

(defun urn->val (node)
  "Gets the constant value of NODE"
  (cond
    [(string? node) (.> node :value)]
    [(number? node) (.> node :value)]
    [(key? node) (.> node :value)]))

(defun val->urn (val)
  "Gets the AST representation of VAL"
  (with (ty (type# val))
    (case ty
      ["string"  {:tag "string" :value val}]
      ["number"  {:tag "number" :value val}]
      ["nil"     {:tag "symbol" :contents "nil" :var (.> builtins :nil)}]
      ["boolean" {:tag "symbol" :contents (bool->string val) :var (.> builtins (bool->string val))}])))

(defun urn->bool (node)
  "Attempt to get the boolean value of NODE.

   Returns `true` if truthy, `false` if falsey and `nil` if it cannot be determined."
  (cond
    [(or (string? node) (key? node) (number? node)) true]
    [(symbol? node)
     (cond
       [(= (.> builtins :true)  (.> node :var)) true]
       [(= (.> builtins :false) (.> node :var)) false]
       [(= (.> builtins :nil)   (.> node :var)) false]
       [else nil])]
    [else nil]))

(defun make-progn (body)
  "Allow using BODY as an expression."
  `((,(make-symbol (.> builtins :lambda)) () ,@body)))

(defun make-symbol (var)
  "Make a symbol referencing VAR."
  { :tag "symbol"
    :contents (.> var :name)
    :var var })

(defun symbol->var (state symb)
  "Convert SYMBOL to a variable in compiler STATE."
  (with (var (.> symb :var))
    (if (string? var) (.> state :variables var) var)))

(define make-nil
  "Make a NIL constant."
  (cute make-symbol (.> builtins :nil)))

(defun simple-binding? (node)
  "Determine whether NODE is a simple binding. Namely, it is a directly
   called lambda with no variadic arguments and an equal number of
   arguments and values."
  (and (list? node)
    (with (lam (car node))
      (and (list? lam) (builtin? (car lam) :lambda)
        (all (lambda (x) (not (.> x :var :is-variadic))) (nth lam 2))))))

(defun single-return? (node)
  "Whether this NODE will return a single value."
  (or
    (not (list? node))
    (with (head (car node))
      (if (symbol? head)
        (with (func (.> head :var))
          (cond
            ;; Non-builtin functions will "always" return multiple values.
            [(/= (.> func :tag) "builtin") false]
            ;; Various literals will just return a single value
            [(= func (.> builtins :lambda)) true]
            [(= func (.> builtins :struct-literal)) true]
            [(= func (.> builtins :quote)) true]
            [(= func (.> builtins :syntax-quote)) true]
            ;; Otherwise just assume it returns multiple values
            [else false]))
        false))))

(defun fast-all (fn li i)
  "A fast implementation of all which starts from an offset.

   Normally I'd be against this, but this function is called
   very often, so needs to be fast."
  (cond
    [(> i (n li)) true]
    [(fn (nth li i)) (fast-all fn li (+ i 1))]
    [else false]))

(defun fast-any (fn li i)
  "A fast implementation of any which starts from an offset.

   Normally I'd be against this, but this function is called
   very often, so needs to be fast."
  (cond
    [(> i (n li)) false]
    [(fn (nth li i)) true]
    [else (fast-any fn li (+ i 1))]))

(defun zip-args (args args-start vals vals-start)
  "Zip a set of ARGS with their corresponding VALS.

   This returns a list of pairs. The first element in each pair is a
   list of arguments, the second value is a list of values. Several
   observations can be made about these pairs:

    - If there are multiple values, then the first argument is variadic.
    - If the first argument is variadic, then there is only one.
    - If there are multiple arguments, then this is the last element. Note that
      any of these arguments may be variadic, except from the first one."
  (let* [(res '())
         (an (n args))
         (vn (n vals))]
    (loop
      [(ai args-start)
       (vi vals-start)]
      [(and (> ai an) (> vi vn)) res]

      (with (arg (.> args ai))
        (cond
          ;; If we have no corresponding argument, then push a single value
          [(not arg)
           (push-cdr! res (list '() (list (nth vals vi))))
           (recur ai (succ vi))]

          ;; If we've no more values, then just push an empty list
          [(> vi vn)
           (push-cdr! res (list (list arg) '()))
           (recur (succ ai) vi)]

          [(.> arg :var :is-variadic)
           (if (single-return? (nth vals vn))
             ;; We know how many values will be passed, so merge them
             ;; all in and continue.
             (with (v-end (- vn (- an ai)))
               (when (< v-end vi) (set! v-end (pred vi)))
               (push-cdr! res (list (list arg) (slice vals vi v-end)))
               (recur (succ ai) (succ v-end)))
             ;; We've no clue how many arguments are here, so zip em all
             ;; up and exit.
             (push-cdr! res (list (slice args ai) (slice vals vi))))]

          ;; Just your bog standard argument -> value mapping
          [(or (< vi vn) (single-return? (nth vals vi)))
           (push-cdr! res (list (list arg) (list (nth vals vi))))
           (recur (succ ai) (succ vi))]

          ;; Last value and we don't know how many there are. Let's
          ;; store all arguments to this one value
          [true
           (push-cdr! res (list (slice args ai) (list (nth vals vi))))])))))
