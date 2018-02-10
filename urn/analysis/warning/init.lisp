(import urn/analysis/nodes ())
(import urn/analysis/pass ())
(import urn/analysis/tag/usage usage)
(import urn/analysis/visitor visitor)
(import urn/documentation doc)
(import urn/logger logger)
(import urn/range (get-source get-top-source range<))
(import urn/resolve/scope scope)

(import urn/analysis/warning/order warning)

(defpass check-arity (state nodes lookup)
  "Produce a warning if any NODE in NODES calls a function with too many arguments.

   LOOKUP is the variable usage lookup table."
  :cat '("warn" "usage")
  (letrec [(arity {})
           (get-arity (lambda (symbol)
                        (let* [(var (usage/get-var lookup (.> symbol :var)))
                          (ari (.> arity var))]
                          (cond
                            [(/= ari nil) ari]
                            [(/= (n (.> var :defs)) 1) false]
                            [true
                              ;; We should never hit recursive definitions but you never know
                              (.<! arity var false)

                              ;; Look up the definition, detecting lambdas and reassignments of other functions.
                              (let* [(def-data (car (.> var :defs)))
                                     (def (.> def-data :value))]
                                (set! ari
                                  (if (= (type def-data) "var")
                                    false
                                    (cond
                                      [(symbol? def) (get-arity def)]
                                      [(and (list? def) (symbol? (car def)) (= (.> (car def) :var) (builtin :lambda)))
                                       (with (args (nth def 2))
                                             (if (any (lambda (x) (scope/var-variadic? (.> x :var))) args)
                                               false
                                               (n args)))]
                                      (true false))))
                                (.<! arity var ari)
                                ari)]))))]

    (visitor/visit-block nodes 1
      (lambda (node)
        (when (and (list? node) (symbol? (car node)))
          (with (arity (get-arity (car node)))
            (when (and arity (< arity (pred (n node))))
              (logger/put-node-warning! (.> state :logger)
                (.. "Calling " (symbol->string (car node)) " with " (string->number (pred (n node))) " arguments, expected " (string->number arity))
                (get-top-source node) nil
                (get-source node) "Called here"))))))))

(defpass deprecated (state nodes)
  "Produce a warning whenever a deprecated variable is used."
  :cat '("warn" "usage")
  (for-each node nodes
    ;; We traverse each top-level definition and ensure it doesn't use any
    ;; deprecated variables (apart from itself). Whilst we could use usage
    ;; infomation, that doesn't include dead nodes, so isn't much help.
    (with (def-var (.> node :def-var))
      (visitor/visit-node node (lambda (node)
                                 (when (symbol? node)
                                   (with (var (.> node :var))
                                     (when (and (/= var def-var) (scope/var-deprecated var))
                                       (logger/put-node-warning! (.> state :logger)
                                         (if (string? (scope/var-deprecated var))
                                           (string/format "%s is deprecated: %s" (.> node :contents) (scope/var-deprecated var))
                                           (string/format "%s is deprecated." (.> node :contents)))
                                         (get-top-source node) nil
                                         (get-source node) "")))))))))

(defpass documentation (state nodes)
  "Ensure doc comments are valid."
  :cat '("warn")
  (with (validate
          (lambda (node var doc kind)
            (for-each tok (doc/parse-docstring doc)
              (when (= (.> tok :kind) "link")
                (with (var (scope/lookup (scope/var-scope var) (.> tok :contents)))
                  (unless var
                    (logger/put-node-warning! (.> state :logger)
                      (string/format "%s is not defined." (string/quoted (.> tok :contents)))
                      (get-top-source node) nil
                      (get-source node) (string/format "Referenced in %s." kind))))))))
    (for-each node nodes
      (when-with (var (.> node :def-var))
        (when (string? (scope/var-doc var))        (validate node var (scope/var-doc var)         "docstring"))
        (when (string? (scope/var-deprecated var)) (validate node var (scope/var-deprecated var) "deprecation message"))))))

(defpass unused-vars (state _ lookup)
  "Ensure all non-exported NODES are used."
  :cat '("warn" "usage")
  :level 2
  (with (unused '())
    (for-pairs (var entry) (.> lookup :usage-vars)
      (unless (or
                ;; Ignore variables which are visited or obviously temporary ones
                (> (n (.> entry :usages)) 0) (> (n (.> entry :soft)) 0)
                (= (scope/var-name var) "_") (/= (scope/var-display-name var) nil)
                ;; Ignore places where we have no definition. These are probably builtin-ins.
                (empty? (.> entry :defs)))
        (with (def (.> (car (.> entry :defs)) :node))
          (when (or ;; Non top-level definitions
                    (= (.> def :def-var) nil)
                    ;; or non-macro, exported symbols
                    (and (/= (scope/var-kind var) "macro") (not (scope/get-exported (scope/var-scope var) (scope/var-name var)))))
            (push! unused (list var def))))))

    (sort! unused (lambda (node1 node2)
                    (range< (get-source (cadr node1)) (get-source (cadr node2)))))

    (for-each pair unused
      (logger/put-node-warning! (.> state :logger)
        (string/format "%s is not used." (string/quoted (scope/var-name (car pair))))
        (get-top-source (cadr pair)) nil
        (get-source (cadr pair)) "Defined here"))))

(defpass macro-usage (state nodes)
  "Determines whether any macro is used."
  :cat '("warn")
  (visitor/visit-block nodes 1
    (lambda (node)
      (when (symbol? node)
        (when (= (scope/var-kind (.> node :var)) "macro")
          (logger/put-node-warning! (.> state :logger)
            (string/format "The macro %s is not expanded" (string/quoted (.> node :contents)))
            (get-top-source node)
            "This macro is used in such a way that it'll be called as a normal function
             instead of expanding into executable code. Sometimes this may be intentional,
             but more often than not it is the result of a misspelled variable name."
            (get-source node) "macro used here"))))))

(defpass mutable-definitions (state nodes lookup)
  "Determines whether any macro is used."
  :cat '("warn" "usage")
  (for-each node nodes
    (when-with (var (.> node :def-var))
      (with (info (usage/get-var lookup var))
        (when (and
                ;; Only warn if the variable is only mutable
                (not (scope/var-const? var))
                (= (n (.> info :defs)) 1)
                ;; If the variable is exported then we can't really warn about it.
                (/= (scope/get-exported (scope/var-scope var) (scope/var-name var)) var))
          (logger/put-node-warning! (.> state :logger)
            (string/format "%s is never mutated" (string/quoted (scope/var-name var)))
            (get-top-source node)
            "This definition is explicitly marked as :mutable, but is
             never mutated. Consider removing the annotation."
            (get-source node) "variable defined here"))))))

(defun analyse (nodes state passes)
  (with (lookup {})
    (for-each pass (.> passes :normal)
      (run-pass pass state nil nodes lookup))

    (unless (empty? (.> passes :usage))
      (run-pass usage/tag-usage state nil nodes lookup usage/visit-eager-exported?))

    (for-each pass (.> passes :usage)
      (run-pass pass state nil nodes lookup))))

(defun default ()
  "Create a collection of default warnings."
  { :normal (list documentation warning/check-order deprecated macro-usage)
    :usage (list check-arity unused-vars mutable-definitions)})
