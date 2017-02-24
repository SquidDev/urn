(import urn/analysis/usage usage)
(import urn/analysis/visitor visitor)
(import urn/logger logger)

(define builtins (.> (require "tacky.analysis.resolve") :builtins))
(define builtin-vars (.> (require "tacky.analysis.resolve") :declaredVars))

(defun side-effect? (node)
  "Checks if NODE has a side effect"
  :hidden
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

(defun warn-arity (lookup nodes)
  "Produce a warning if any NODE in NODES calls a function with too many arguments.

   LOOKUP is the variable usage lookup table"
  :hidden
  (letrec [(arity (empty-struct))
           (get-arity (lambda (symbol)
                        (let* [(var (usage/get-var lookup (.> symbol :var)))
                          (ari (get-idx arity var))]
                          (cond
                            ((/= ari nil) ari)
                            ((/= (#keys (.> var :defs)) 1) false)
                            (true
                              ;; We should never hit recursive definitions but you never know
                              (.<! arity var false)

                              ;; Look up the definition, detecting lambdas and re-assignments of other functions.
                              (let* [(def-data (cadr (list (next (.> var :defs)))))
                                     (def (.> def-data :value))]
                                (set! ari
                                  (if (= (.> def-data :tag) "arg")
                                    false
                                    (cond
                                      ((symbol? def) (get-arity def))
                                      ((and (list? def) (symbol? (car def)) (= (.> (car def) :var) (.> builtins :lambda)))
                                        (with (args (nth def 2))
                                          (if (any (lambda (x) (.> x :var :isVariadic)) args)
                                            false
                                            (# args))))
                                      (true false))))
                                (.<! arity var ari)
                                ari))))))]

    (visitor/visit-block nodes 1
      (lambda (node)
        (when (and (list? node) (symbol? (car node)))
          (with (arity (get-arity (car node)))
            (when (and arity (< arity (pred (# node))))
              (logger/print-warning! (.. "Calling " (symbol->string (car node)) " with " (string->number (pred (# node))) " arguments, expected " (string->number arity)))
              (logger/put-trace! node)
              (logger/put-lines! true
                (logger/get-source node) "Called here"))))))))

(defun analyse (nodes)
  (with (lookup (usage/create-state))
    (usage/definitions-visit lookup nodes)
    (usage/usages-visit lookup nodes side-effect?)

    (warn-arity lookup nodes))
  nodes)

(struct
  :analyse analyse)
