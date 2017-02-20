(import urn/analysis/usage usage)
(import urn/analysis/visitor visitor)
(import urn/analysis/traverse traverse)

(import string)
(import base (type#))

(define builtins (.> (require "tacky.analysis.resolve") :builtins))
(define builtin-vars (.> (require "tacky.analysis.resolve") :declaredVars))

(defun has-side-effect (node)
  "Checks if NODE has a side effect"
  (with (tag (type node))
    (cond
      ;; Constant terms are obviously side effect free
      ((or (= tag "number") (= tag "string") (= tag "key") (= tag "symbol")) false)
      ((= tag "list")
        (with (fst (car node))
          ;; We simply check if we're defining a lambda/quoting something
          ;; Everything else *may* have a side effect.
          (if (= (type fst) "symbol")
            (with (var (.> fst :var))
              (and (/= var (.> builtins :lambda)) (/= var (.> builtins :quote))))
            true))))))

(defun constant? (node)
  "Checks if NODE is a constant value"
  (or (string? node) (number? node) (key? node)))

(defun urn->val (node)
  "Gets the constant value of NODE"
  (cond
    ((string? node) (.> node :contents))
    ((number? node) (number->string (.> node :contents)))
    ((key? node) (string/sub (.> node :contents) 2))))

(defun val->urn (val)
  "Gets the AST representation of VAL"
  (with (ty (type# val))
    (cond
      ((= ty "string")  (struct :tag "string" :contents (string/quoted val)))
      ((= ty "number")  (struct :tag "number" :contents (number->string val)))
      ((= ty "nil")     (struct :tag "symbol" :contents "nil" :var (.> builtin-vars :nil)))
      ((= ty "boolean") (struct :tag "symbol" :contents (bool->string val) :var (.> builtin-vars (bool->string val)))))))

(defun truthy? (node)
  "Determine whether NODE is a truthy value"
  (cond
    ((or (string? node) (key? node) (number? node)) true)
    ((symbol? node) (= (.> builtin-vars :true) (.> node :var)))
    (true false)))

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
             (val (.> ent :value))]
        (cond
          ((or (string? val) (number? val) (key? val))
            val)
          (true
            nil))))))

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
                 (meta (and (symbol? head) (= (.> head :var :tag) "native") (.> state :meta (.> head :var :fullName))))]
            ;; Determine whether we have a native (and pure) function. If so, we'll invoke it.
            (if (and meta (.> meta :pure) (.> meta :value))
              (with (res ((.> meta :value) (unpack (map urn->val (cdr node)))))
                (val->urn res))
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
                  (final
                    (set! changed true)
                    (remove-nth! node final))
                  ((truthy? (car (nth node i)))
                    (set! final (succ i)))
                  (true))))
            (if (and (= (# node) 2) (truthy? (car (nth node 2))))
              (progn
                (set! changed true)
                (with (body (cdr (nth node 2)))
                  (if (= (# body) 1)
                    (car body)
                    (make-progn (cdr (nth node 2))))))
              node))
          node)))

    ;; Strip unused definitions
    (with (lookup (usage/create-state))
      (usage/definitions-visit lookup nodes)
      (usage/usages-visit lookup nodes has-side-effect)

      (for i (# nodes) 1 -1
        (with (node (nth nodes i))
          (when (and (.> node :defVar) (! (.> (usage/get-var lookup (.> node :defVar)) :active)))
            (if (= i (# nodes))
              (.<! nodes i (struct :tag "symbol" :contents "nil" :var (.> builtin-vars :nil)))
              (remove-nth! nodes i))
            (set! changed true))))

      (traverse/traverse-list nodes 1
        (lambda (node)
          (if (symbol? node)
            (with (var (get-constant-val lookup node))
              (if var
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
