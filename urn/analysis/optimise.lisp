(import urn/analysis/visitor visitor)

(define builtins (get-idx (require "tacky.analysis.resolve") :builtins))
(define builtin-vars (get-idx (require "tacky.analysis.resolve") :declaredVars))

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

(defun get-var-entry (lookup var)
  (with (entry (.> lookup var))
    (unless entry
      (set! entry (struct
        :var var
        :usages '()
        :defs  '()
        :active false))
      (.<! lookup var entry))
    entry))

;; Gather all definitions of a variable into the lookup
(defun gather-definitions (nodes lookup)
  (with (add-definition (lambda (var def)
    (push-cdr! (.> (get-var-entry lookup var) :defs) def)))

    (visitor/visit-block nodes 1 (lambda (node)
      (when (and (list? node) (> (# node) 0) (symbol? (car node)))
        (with (func (.> (car node) :var))
          (cond
            ((= func (.> builtins :lambda))
              (for-each arg (nth node 2) 1
                (add-definition (.> arg :var) (struct
                  :tag   "arg"
                  :value arg
                  :node  node
                ))))
            ((= func (.> builtins :set!))
               (add-definition (.> node 2 :var) (struct
                  :tag   "set"
                  :value (nth node 3)
                  :node  node
                )))
            ((or (= func (.> builtins :define)) (= func (.> builtins :define-macro)))
              (add-definition (.> node :defVar) (struct
                  :tag   "define"
                  :value (nth node 3)
                  :node  node
                )))
            ((= func (.> builtins :define-native))
              (add-definition (.> node :defVar) (struct
                  :tag   "native"
                  :node  node
                )))
            (true))))))))

;;; Build a lookup of usages. Note, this will only visit "active" nodes: those
;; which have a side effect or are used somewhere else.
(defun gather-usages (nodes lookup)
  (let* ((queue '())
         (add-usage (lambda (var user)
           (with (entry (.> lookup var))
             (when entry
               (unless (.> entry :active)
                 (.<! entry :active true)

                 (for-each def (.> entry :defs)
                   (with (val (.> def :value))
                     (when val (push-cdr! queue val)))))
               (push-cdr! (.> entry :usages) user)))))
         (visit (lambda (node)
           (cond
            ((symbol? node)
              (add-usage (.> node :var) node)
              true)
            ((and (list? node) (> (# node) 0) (symbol? (car node)))
              (with (func (.> (car node) :var))
                (if (or (= func (.> builtins :set!)) (= func (.> builtins :define)) (= func (.> builtins :define-macro)))
                  (if (has-side-effect (nth node 3))
                    (with (entry (.> lookup :var))
                      ;; If we have an entry and we've visited it then skip
                      (! (and entry (.> entry :active))))
                    ;; Skip the definition as it has no side effects
                    false)
                  true)))
            (true true)))))
    (for-each node nodes
      (push-cdr! queue node))
    (while (> (# queue) 0)
      (visitor/visit-node (remove-nth! queue 1) visit))))

(defun optimise (nodes)
  ;; Strip import expressions
  (for i (# nodes) 1 -1
    (with (node (nth nodes i))
      (when (and (list? node) (> (# node) 0) (symbol? (car node)) (= (.> (car node) :var) (.> builtins :import)))
        ;; We replace the last node in the block with a nil: otherwise we might change
        ;; what is returned
        (if (= i (# nodes))
          (set-nth! nodes i (struct :tag "symbol" :contents "nil" :var (.> builtin-vars :nil)))
          (remove-nth! nodes i)))))

  ;; Strip pure expressions (apart from the last one: that will be returned).
  (for i (pred (# nodes)) 1 -1
    (with (node (nth nodes i))
      (when (! (has-side-effect node))
        (remove-nth! nodes i))))


  ;; Strip unused definitions
  (with (lookup (empty-struct))
    (gather-definitions nodes lookup)
    (gather-usages nodes lookup)

    (for i (# nodes) 1 -1
      (with (node (nth nodes i))
        (when (and (.> node :defVar) (! (.> lookup (.> node :defVar) :active)))
          (if (= i (# nodes))
            (set-nth! nodes i (struct :tag "symbol" :contents "nil" :var (.> builtin-vars :nil)))
            (remove-nth! nodes i))))))
  nodes)

optimise
