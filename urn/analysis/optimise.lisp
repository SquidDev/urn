(import urn/analysis/usage usage)
(import urn/analysis/visitor visitor)
(import urn/analysis/traverse traverse)
(import urn/logger logger)

(import string)
(import base (type#))
(import lua/math math)

(define builtins (.> (require "tacky.analysis.resolve") :builtins))
(define builtin-vars (.> (require "tacky.analysis.resolve") :declaredVars))

(defun has-side-effect (node)
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
      [(= ty "string")  (struct :tag "string" :value val)]
      [(= ty "number")  (struct :tag "number" :value val)]
      [(= ty "nil")     (struct :tag "symbol" :contents "nil" :var (.> builtin-vars :nil))]
      [(= ty "boolean") (struct :tag "symbol" :contents (bool->string val) :var (.> builtin-vars (bool->string val)))])))

(defun truthy? (node)
  "Determine whether NODE is a truthy value"
  (cond
    [(or (string? node) (key? node) (number? node)) true]
    [(symbol? node) (= (.> builtin-vars :true) (.> node :var))]
    [true false]))

(defun make-progn (body)
  "Allow using BODY as an expression"
  (with (lambda (struct
                   :tag "symbol"
                   :contents "lambda"
                   :var (.> builtins :lambda)))
    `((,lambda () ,@body))))

(defun get-constant-val (lookup sym)
  "Get the value of DEF if it is a constant, otherwise nil"
  (with (def (usage/get-var lookup (.> sym :var)))
    (when (= 1 (#keys (.> def :defs)))
      (let* [(ent (nth (list (next (.> def :defs))) 2))
             (val (.> ent :value))
             (ty  (.> ent :tag))]
        (cond
          [(or (string? val) (number? val) (key? val))
           val]
          [(and (symbol? val) (or (= ty "define") (= ty "set") (= ty "let")))
           ;; Attempt to get this value, or fallback to just the symbol
           ;; This allows us to simplify reference chains to their top immutable variable
           (or (get-constant-val lookup val) sym)]
          [true
            sym])))))

(defun optimise-once (nodes state)
  "Run all optimisations on NODES once"
  (with (changed false)
    ;; Strip import expressions
    (for i (# nodes) 1 -1
      (with (node (nth nodes i))
        (when (and (list? node) (> (# node) 0) (symbol? (car node)) (= (.> (car node) :var) (.> builtins :import)))
          ;; We replace the last node in the block with a nil: otherwise we might change
          ;; what is returned
          (if (= i (# nodes))
            (.<! nodes i (struct :tag "symbol" :contents "nil" :var (.> builtin-vars :nil)))
            (remove-nth! nodes i))
          (set! changed true))))

    ;; Strip pure expressions (apart from the last one: that will be returned).
    (for i (pred (# nodes)) 1 -1
      (with (node (nth nodes i))
        (when (! (has-side-effect node))
          (remove-nth! nodes i)
          (set! changed true))))

    ;; Primitive constant folding
    (traverse/traverse-list nodes 1
      (lambda (node)
        (if (and (list? node) (all constant? (cdr node)))
          ;; If we're invoking a function with entirely constant arguments then
          (let* [(head (car node))
                 (meta (and (symbol? head) (! (.> head :folded)) (= (.> head :var :tag) "native") (.> state :meta (.> head :var :fullName))))]
            ;; Determine whether we have a native (and pure) function. If so, we'll invoke it.
            (if (and meta (.> meta :pure) (.> meta :value))
              (with (res (list (pcall (.> meta :value) (unpack (map urn->val (cdr node))))))
                (if (car res)
                  (with (val (nth res 2))
                    (if (and (number? val) (or (/= (snd (pair (math/modf val))) 0) (= (math/abs val) math/huge)))
                      (progn
                        ;; Don't fold non-integer values as we cannot accurately represent them
                        ;; To consider: could we fold this if a parent expression could be folded (so simplify
                        ;; (math/cos math/pi)) but revert otherwise.
                        ;; That might be overly complicated for a simple constant folding system though.
                        (.<! head :folded true)
                        node)
                      (val->urn val)))
                  (progn
                    ;; Mark this head as folded so we don't try again
                    (.<! head :folded true)
                    ;; Print a warning message
                    (logger/print-warning! (.. "Cannot execute constant expression"))
                    (logger/put-trace! node)
                    (logger/put-lines! true
                      (logger/get-source node) (.. "Executed " (pretty node) ", failed with: " (nth res 2)))
                    node)))
              node))
          node)))


    ;; Simplify cond expressions
    (traverse/traverse-list nodes 1
      (lambda (node)
        (if (and (list? node) (symbol? (car node)) (= (.> (car node) :var) (.> builtins :cond)))
          (with (final nil)
            (for i 2 (# node) 1
              (with (case (nth node i))
                (cond
                  [final
                    (set! changed true)
                    (remove-nth! node final)]
                  [(truthy? (car (nth node i)))
                   (set! final (succ i))]
                  [true])))
            (if (and (= (# node) 2) (truthy? (car (nth node 2))))
              (progn
                (set! changed true)
                (with (body (cdr (nth node 2)))
                  (if (= (# body) 1)
                    (car body)
                    (make-progn (cdr (nth node 2))))))
              node))
          node)))

    (with (lookup (usage/create-state))
      (usage/definitions-visit lookup nodes)
      (usage/usages-visit lookup nodes has-side-effect)

      ;; Strip unused definitions
      (for i (# nodes) 1 -1
        (with (node (nth nodes i))
          (when (and (.> node :defVar) (! (.> (usage/get-var lookup (.> node :defVar)) :active)))
            (if (= i (# nodes))
              (.<! nodes i (struct :tag "symbol" :contents "nil" :var (.> builtin-vars :nil)))
              (remove-nth! nodes i))
            (set! changed true))))

      ;; Strip unused variables
      (visitor/visit-list nodes 1
        (lambda (node)
          (when (and (list? node) (list? (car node)) (symbol? (caar node)) (= (.> (caar node) :var) (.> builtins :lambda)))
            (let* [(lam (car node))
                   (args (nth lam 2))
                   (offset 1)
                   (rem-offset '0)]
              (for i 1 (# args) 1
                (let [(arg (nth args (- i rem-offset)))
                      (val (nth node (- (+ i offset) rem-offset)))]
                  (cond
                    [(.> arg :var :isVariadic)
                     (with (count (- (# node) (# args)))
                           ;; If it's a variable number of args then just skip them
                           (when (< count 0) (set! count 0))
                           (set! offset count))]

                    [(= nil val)]
                    ;; Obviously don't remove values which have an effect
                    [(has-side-effect val)]
                    ;; And keep values which are actually used
                    [(> (#keys (.> (usage/get-var lookup (.> arg :var)) :usages)) 0)]
                    ;; So remove things which aren't used and have no side effects.
                    [true
                      (remove-nth! args (- i rem-offset))
                      (remove-nth! node (- (+ i offset) rem-offset))
                      (inc! rem-offset)])))))))

      (traverse/traverse-list nodes 1
        (lambda (node)
          (if (symbol? node)
            (with (var (get-constant-val lookup node))
              (if (and var (/= var node))
                (progn
                  (set! changed true)
                  var)
                node))
            node))))

    changed))

(defun optimise (nodes state)
  (unless state (set! state (struct :meta (empty-struct))))
  ;; Run the main optimiser until a "fixed point" is reached
  (let [(iteration 0)
        (changed true)]
    (while (and changed (< iteration 10))
      (set! changed (optimise-once nodes state))
      (inc! iteration)))
  nodes)

optimise
