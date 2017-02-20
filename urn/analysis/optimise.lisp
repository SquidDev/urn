(import urn/analysis/usage usage)
(import urn/analysis/visitor visitor)
(import urn/analysis/traverse traverse)

(define builtins (get-idx (require "tacky.analysis.resolve") :builtins))
(define builtin-vars (get-idx (require "tacky.analysis.resolve") :declaredVars))

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

(defun truthy? (node)
  "Determine whether NODE is a truthy value"
  (cond
    ((or (string? node) (key? node) (number? node)) true)
    ((symbol? node) (= (.> builtin-vars :true) (.> node :var)))
    (true false)))

(defun make-progn (body)
  (with (lambda (struct
                   :tag "symbol"
                   :contents "lambda"
                   :var (.> builtins :lambda)))
    `((,lambda () ,@body))))

(defun optimise-once (nodes)
  "Run all optimisations on NODES once"
  (with (changed false)
    ;; Strip import expressions
    (for i (# nodes) 1 -1
      (with (node (nth nodes i))
        (when (and (list? node) (> (# node) 0) (symbol? (car node)) (= (.> (car node) :var) (.> builtins :import)))
          ;; We replace the last node in the block with a nil: otherwise we might change
          ;; what is returned
          (if (= i (# nodes))
            (set-idx! nodes i (struct :tag "symbol" :contents "nil" :var (.> builtin-vars :nil)))
            (remove-nth! nodes i))
          (set! changed true))))

    ;; Strip pure expressions (apart from the last one: that will be returned).
    (for i (pred (# nodes)) 1 -1
      (with (node (nth nodes i))
        (when (! (has-side-effect node))
          (remove-nth! nodes i)
          (set! changed true))))

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
              (set-idx! nodes i (struct :tag "symbol" :contents "nil" :var (.> builtin-vars :nil)))
              (remove-nth! nodes i))
            (set! changed true)))))

    changed))

(defun optimise (nodes)
  ;; Run the main optimiser until a "fixed point" is reached
  (let [(iteration 0)
        (changed true)]
    (while (and changed (< iteration 10))
      (set! changed (optimise-once nodes))
      (inc! iteration)))
  nodes)

optimise
