(import urn/analysis/usage usage)
(import urn/analysis/visitor visitor)

(define builtins (rawget (require "tacky.analysis.resolve") :builtins))
(define builtin-vars (rawget (require "tacky.analysis.resolve") :declaredVars))

;;; Checks if a node has a side effect
(defun has-side-effect (node)
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

(defun optimise-once (nodes)
  (with (changed false)
    ;; Strip import expressions
    (for i (# nodes) 1 -1
      (with (node (nth nodes i))
        (when (and (list? node) (> (# node) 0) (symbol? (car node)) (= (.> (car node) :var) (.> builtins :import)))
          ;; We replace the last node in the block with a nil: otherwise we might change
          ;; what is returned
          (if (= i (# nodes))
            (rawset nodes i (struct :tag "symbol" :contents "nil" :var (.> builtin-vars :nil)))
            (remove-nth! nodes i))
          (set! changed true))))

    ;; Strip pure expressions (apart from the last one: that will be returned).
    (for i (pred (# nodes)) 1 -1
      (with (node (nth nodes i))
        (when (! (has-side-effect node))
          (remove-nth! nodes i)
          (set! changed true))))

    ;; Strip unused definitions
    (with (lookup (usage/create-state))
      (usage/definitions-visit lookup nodes)
      (usage/usages-visit lookup nodes has-side-effect)

      (for i (# nodes) 1 -1
        (with (node (nth nodes i))
          (when (and (.> node :defVar) (! (.> (usage/get-var lookup (.> node :defVar)) :active)))
            (if (= i (# nodes))
              (rawset nodes i (struct :tag "symbol" :contents "nil" :var (.> builtin-vars :nil)))
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
