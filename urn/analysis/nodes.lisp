(import urn/resolve/builtins (builtins builtin-vars) :export)

(import base (type#))

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
       (with (fst (car node))
         ;; We simply check if we're defining a lambda/quoting something
         ;; Everything else *may* have a side effect.
         (if (= (type fst) "symbol")
           (with (var (.> fst :var))
             (and (/= var (.> builtins :lambda)) (/= var (.> builtins :quote))))
           true))])))

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
        (all (lambda (x) (! (.> x :var :is-variadic))) (nth lam 2))))))

(defun single-return? (node)
  "Whether this NODE will return a single value."
  (or
    (! (list? node))
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
