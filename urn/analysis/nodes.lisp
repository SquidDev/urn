(define builtins (.> (require "tacky.analysis.resolve") :builtins))
(define builtin-vars (.> (require "tacky.analysis.resolve") :declaredVars))

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
    (cond
      [(= ty "string")  (const-struct :tag "string" :value val)]
      [(= ty "number")  (const-struct :tag "number" :value val)]
      [(= ty "nil")     (const-struct :tag "symbol" :contents "nil" :var (.> builtins :nil))]
      [(= ty "boolean") (const-struct :tag "symbol" :contents (bool->string val) :var (.> builtins (bool->string val)))])))

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
       [true nil])]
    [true nil]))

(defun make-progn (body)
  "Allow using BODY as an expression."
  `((,(make-symbol (.> builtins :lambda)) () ,@body)))

(defun make-symbol (var)
  "Make a symbol referencing VAR."
  (const-struct
    :tag "symbol"
    :contents (.> var :name)
    :var var))

(define make-nil
  "Make a NIL constant."
  (cute make-symbol (.> builtins :nil)))

(defun fast-all (fn li i)
  "A fast implementation of all which starts from an offset.

   Normally I'd be against this, but this function is called
   very often, so needs to be fast."
  (cond
    ((> i (# li)) true)
    ((fn (nth li i)) (fast-all fn li (+ i 1)))
    (true false)))
