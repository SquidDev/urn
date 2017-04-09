(import urn/analysis/nodes ())
(import urn/analysis/pass ())
(import urn/analysis/usage usage)
(import urn/analysis/visitor visitor)
(import urn/logger/init logger)
(import urn/range (get-source))

(defpass check-arity (state nodes lookup)
  "Produce a warning if any NODE in NODES calls a function with too many arguments.

   LOOKUP is the variable usage lookup table."
  :cat '("warn" "usage")
  (letrec [(arity {})
           (get-arity (lambda (symbol)
                        (let* [(var (usage/get-var lookup (.> symbol :var)))
                          (ari (get-idx arity var))]
                          (cond
                            [(/= ari nil) ari]
                            [(/= (# (.> var :defs)) 1) false]
                            [true
                              ;; We should never hit recursive definitions but you never know
                              (.<! arity var false)

                              ;; Look up the definition, detecting lambdas and reassignments of other functions.
                              (let* [(def-data (car (.> var :defs)))
                                     (def (.> def-data :value))]
                                (set! ari
                                  (if (= (.> def-data :tag) "arg")
                                    false
                                    (cond
                                      [(symbol? def) (get-arity def)]
                                      [(and (list? def) (symbol? (car def)) (= (.> (car def) :var) (.> builtins :lambda)))
                                       (with (args (nth def 2))
                                             (if (any (lambda (x) (.> x :var :isVariadic)) args)
                                               false
                                               (# args)))]
                                      (true false))))
                                (.<! arity var ari)
                                ari)]))))]

    (visitor/visit-block nodes 1
      (lambda (node)
        (when (and (list? node) (symbol? (car node)))
          (with (arity (get-arity (car node)))
            (when (and arity (< arity (pred (# node))))
              (logger/put-node-warning! (.> state :logger)
                (.. "Calling " (symbol->string (car node)) " with " (string->number (pred (# node))) " arguments, expected " (string->number arity))
                node nil
                (get-source node) "Called here"))))))))

(defun analyse (nodes state)
  (for-each pass (.> state :pass :normal)
    (run-pass pass state nil nodes))

  (with (lookup (usage/create-state))
    (run-pass usage/tag-usage state nil nodes lookup)
    (for-each pass (.> state :pass :usage)
      (run-pass pass state nil nodes lookup))))

(defun default ()
  "Create a collection of default warnings."
  { :normal '()
    :usage (list check-arity)})
