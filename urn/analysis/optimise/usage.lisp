(import urn/analysis/nodes ())
(import urn/analysis/vars ())
(import urn/analysis/pass ())
(import urn/analysis/tag/usage usage)
(import urn/analysis/traverse traverse)
(import urn/analysis/visitor visitor)
(import urn/resolve/scope scope)

(defun strip-defs-fast (nodes)
  "A simplistic version of [[strip-defs]] which only works on top level definitions."
  (with (defs {})
    ;; For all nodes of the form `(define ...)` or `(define-macro ...)`, push their definition.
    (for-each node nodes
      (when (list? node)
        (when-with (var (.> node :def-var))
          (.<! defs var node))))

    (let* [(visited {})
           (queue '())
           (visitor (lambda (node visitor)
                      (case (type node)
                        ["symbol"
                         (let* [(var (.> node :var))
                                (def (.> defs var))]
                           (when (and def (not (.> visited var)))
                             (.<! visited var true)
                             (push! queue def)))]
                        ["list"
                         ;; Consider set! as also visiting the node
                         (when (builtin? (car node) :set!)
                           (visitor (cadr node)))]
                        [_])))]

      (for-each node nodes
        (unless (.> node :def-var)
          (visitor/visit-node node visitor)))

      (while (> (n queue) 0)
        (visitor/visit-node (pop-last! queue) visitor))

      (for i (n nodes) 1 -1
        (with (var (.> (nth nodes i) :def-var))
          (when (and var (not (.> visited var)))
            (if (= i (n nodes))
              (.<! nodes i (make-nil))
              (remove-nth! nodes i))))))))

(defun get-constant-val (lookup sym)
  "Get the value of DEF if it is a constant, otherwise nil"
  :hidden
  (let* [(var (.> sym :var))
         (def (usage/get-var lookup (.> sym :var)))]
    (cond
      [(= var (builtin :true)) sym]
      [(= var (builtin :false)) sym]
      [(= var (builtin :nil)) sym]
      [(= (n (.> def :defs)) 1)
       (let* [(ent (car (.> def :defs)))
              (val (.> ent :value))
              (ty  (type ent))]
         (cond
           [(or (string? val) (number? val) (key? val)) val]
           [(and (symbol? val) (= ty "val"))
            ;; Attempt to get this value, or fallback to just the symbol
            ;; This allows us to simplify reference chains to their top immutable variable
            (or (get-constant-val lookup val) sym)]
           [true sym]))]
      [true nil])))

(defun remove-references (vars nodes start)
  "Remove all references to the given VARS in NODES.

   This replaces every `(set! a X)` with `(progn X nil)` and any other
   reference with `nil`."
  :hidden
  (unless (empty-struct? vars)
    (traverse/traverse-list nodes start
      (lambda (node)
        (case (type node)
          ["symbol"
           (if (.> vars (.> node :var)) (make-nil) node)]
          ["list"
           (if (and (builtin? (car node) :set!) (.> vars (.> (nth node 2) :var)))
             (with (val (nth node 3))
               (if (side-effect? val)
                 ;; We have to avoid returning this value.
                 (make-progn (list val (make-nil)))
                 (make-nil)))
             node)]
          [_ node])))))

(defpass strip-defs (state nodes lookup)
  "Strip all unused top level definitions."
  :cat '("opt" "usage")
  (with (removed {})
    (for i (n nodes) 1 -1
      (with (node (nth nodes i))
        (when (and (.> node :def-var) (not (.> (usage/get-var lookup (.> node :def-var)) :active)))
          (if (= i (n nodes))
            (.<! nodes i (make-nil))
            (remove-nth! nodes i))
          (.<! removed (.> node :def-var) true)
          (changed!))))

    (remove-references removed nodes 1)))

(defpass strip-args (state node lookup)
  "Strip all unused, pure arguments in directly called lambdas."
  :cat '("opt" "usage" "transform-post-bind")
  (let* [(lam (car node))
         (lam-args (nth lam 2))
         (arg-offset 1)
         (val-offset 2)
         (removed {})]
    (for-each zipped (zip-args lam-args 1 node 2)
      (let* [(args (car zipped))
             (arg  (car args))
             (vals (cadr zipped))]
        (if (or
              ;; Ignore times we've got multiple arguments
              (> (n args) 1)
              ;; And keep arguments which are actually used
              (and arg (> (n (.> (usage/get-var lookup (.> arg :var)) :usages)) 0))
              ;; Obviously don't remove values which have an effect
              (any side-effect? vals))
          (progn
            ;; We're skipping, so move onto the next set of arguments
            (set! arg-offset (+ arg-offset (n args)))
            (set! val-offset (+ arg-offset (n vals))))

          (progn
            (changed!)
            (when arg
              (.<! removed (.> arg :var) true)
              (remove-nth! lam-args arg-offset))

            (for-each val vals (remove-nth! node val-offset))))))

    (remove-references removed lam 3)))

(defpass variable-fold (state node lookup)
  "Folds constant variable accesses"
  :cat '("opt" "usage" "transform-pre")
  (if (symbol? node)
    (with (replace (get-constant-val lookup node))
      (if (and replace (/= replace node))
        (progn
          ;; Remove usage of old node
          (usage/remove-usage! lookup (.> node :var) node)

          ;; Copy symbol to ensure a unique hash, and add new usage.
          (when (symbol? replace)
            (set! replace (copy-of replace))
            (usage/add-usage! lookup (.> replace :var) replace))

          (changed!)
          replace)
        node))
    node))

(defpass expression-fold (state root lookup)
  "Folds basic variable accesses where execution order will not change.

   For instance, converts ((lambda (x) (+ x 1)) (Y)) to (+ Y 1) in the
   case where Y is an arbitrary expression.

   There are a couple of complexities in the implementation
   here. Firstly, we want to ensure that the arguments are executed in
   the correct order and only once.

   In order to achieve this, we find the lambda forms and visit the body,
   stopping if we visit arguments in the wrong order or non-constant
   terms such as mutable variables or other function calls. For
   simplicity's sake, we fail if we hit other lambdas or conds as that
   makes analysing control flow significantly more complex.

   Another source of added complexity is the case where where Y could
   return multiple values: namely in the last argument to function
   calls. Here it is an invalid optimisation to just place Y, as that
   could result in additional values being passed to the function.

   In order to avoid this, Y will get converted to the
   form ((lambda (<tmp>) <tmp>) Y).  This is understood by the codegen
   and so is not as inefficient as it looks. However, we do have to take
   additional steps to avoid trying to fold the above again and again.

   We use post-bind rather than pre-bind as that enables us to benefit
   from any optimisations inside the node. We're not going to be moving
   any simple, constant-foldable expressions around. After all, that's
   covered by [[variable-fold]]."
  :cat '("opt" "usage" "transform-post-bind")

  (letrec [(lam (car root))
           (args (nth lam 2))
           (len (n args))
           (validate (lambda (i)
                       (if (> i len)
                         true
                         (let* [(arg (nth args i))
                                (var (.> arg :var))
                                (entry (usage/get-var lookup var))]
                           (cond
                             ;; We can't really fold variadic arguments
                             [(scope/var-variadic? var) false]
                             ;; We won't fold if the variable is redefined
                             [(/= (n (.> entry :defs)) 1) false]
                             ;; If the definition is a varaiable then we can't fold.
                             [(= (type (car (.> entry :defs))) "var") false]
                             ;; Ensure there is only one usage of this argument
                             [(/= (n (.> entry :usages)) 1) false]
                             ;; Otherwise ensure that the next argument is valid
                             [true (validate (succ i))])))))]

    ;; If we've got one or more arguments, where none are variadic or
    ;; mutable, then we'll iterate over the body.
    (when (and
            ;; If we've got one or more arguments
            (> len 0)
            ;; And we're not of the form ((lambda (x) x) Y) where Y is a list
            ;; (though we'd have probably have inlined non-lists elsewhere).
            (or
              (/= (n root) 2) (/= len 1) (/= (n lam) 3) (single-return? (nth root 2))
              (not (symbol? (nth lam 3))) (/= (.> (nth lam 3) :var) (.> (car args) :var)))
            ;; And no arguments are variadic or mutable
            (validate 1))
      (let [(current-idx 1)
            (arg-map {})
            (wrap-map {})
            (ok true)
            (finished false)]

        ;; Build a lookup table of argument variables to their corresponding index
        (for i 1 (n args) 1 (.<! arg-map (.> (nth args i) :var) i))
        (visitor/visit-list lam 3
          (lambda (node visitor)
            (if (and ok (not finished))
              (case (type node)
                ["string"]
                ["number"]
                ["key"]
                ["symbol"
                 ;; If this variable is redefined then we've no clue where, we'll just
                 ;; skip for now.
                 (with (idx (.> arg-map (.> node :var)))
                   (cond
                     [(= idx nil)
                      ;; If it's not an argument, just ensure it's immutable
                      (when (> (n (.> (usage/get-var lookup (.> node :var)) :defs)) 1)
                        (set! ok false)
                        false)]
                     [(= idx current-idx)
                      ;; If it's the current argument, then we're rockin'.
                      ;; We'll start working on the next argument, unless we're finished.
                      (inc! current-idx)
                      (when (> current-idx len) (set! finished true))]
                     [true
                      ;; We've hit a different argument. Instead we'll stop everything.
                      ;; This probably means it's an argument we've seen already, or they've
                      ;; been put out of order.
                      (set! ok false)
                      false]))]
                ["list"
                 (with (head (car node))
                   (case (type head)
                     ["symbol"
                      ;; If we're calling known symbol then we'll try to work out execution order
                      (with (var (.> head :var))
                        ;; In this case we'll visit the children first, then the actual node
                        ;; This means we only evaluate the side effects of the children *before*
                        ;; evaluating the side effects of this node.
                        (cond
                          ;; Visit function calls normally
                          [(/= (scope/var-kind var) "builtin")
                           (visitor/visit-list node 1 visitor)

                           ;; If the last argument to this function is from the parent lambda
                           ;; then we'll check if it needs lambda wrapping and mark it for later.
                           (when (> (n node) 1)
                             (with (last (nth node (n node)))
                               (when (symbol? last)
                                 (when-with (idx (.> arg-map (.> last :var)))
                                   (with (val (.> root (+ idx 1)))
                                     (when (list? val) (.<! wrap-map idx true)))))))]
                          ;; Only visit the actual variable to be defined
                          [(= var (builtin :set!)) (visitor/visit-node (nth node 3) visitor)]
                          [(= var (builtin :define)) (visitor/visit-node (last node) visitor)]
                          [(= var (builtin :define-macro)) (visitor/visit-node (last node) visitor)]
                          ;; Nothing doing here
                          [(= var (builtin :define-native))]
                          ;; The first expression is the only one we can guarantee executing. If we've
                          ;; not finished by then, then we should abort.
                          [(= var (builtin :cond))
                           (visitor/visit-node (car (nth node 2)) visitor)]
                          [(= var (builtin :lambda))]
                          [(= var (builtin :quote))]
                          [(= var (builtin :import))]
                          ;; Visit basic builtins normally
                          [(= var (builtin :syntax-quote)) (visitor/visit-quote (nth node 2) visitor 1)]
                          [(= var (builtin :struct-literal)) (visitor/visit-list node 2 visitor)])

                        (cond
                          ;; We've got all the arguments so everything should be OK.
                          [finished]
                          ;; If we hit a set! then this just makes everything complicated,
                          ;; let's abort
                          [(= var (builtin :set!))
                           (set! ok false)]
                          ;; cond's mean the order of execution isn't guarenteed to this
                          ;; analysis goes out the window.
                          [(= var (builtin :cond))
                           (set! ok false)]
                          ;; Similarly with lambda.
                          [(= var (builtin :lambda))
                           (set! ok false)]
                          [true
                           ;; Right. So *technically*, we could check if this function is pure or not.
                           ;; However, this ends up being significantly more complex than that as
                           ;; it could still error or something, so we just don't...
                           (set! ok false)])

                        ;; We've visited everything earlier so let's not do it again.
                        false)]
                     ["list"
                      (if (builtin? (car head) :lambda)
                        ;; If we're a directly called lambda than propagate flow as normal:
                        (progn
                          (visitor/visit-list node 2 visitor)
                          (visitor/visit-block head 3 visitor)
                          false)
                        (progn
                          ;; Otherwise we'll just give up. Sure, it's rather defeatest but...
                          (set! ok false)
                          false))]
                     [_
                      ;; Otherwise we'll just give up. Sure, it's rather defeatest but...
                      (set! ok false)
                      false]))])
              false)))

        (when (and ok finished)
          (changed!)
          (traverse/traverse-list root 1
            (lambda (child)
              (if (symbol? child)
                (let* [(var (.> child :var))
                       (i (.> arg-map var))]
                  (if i
                    (if (.> wrap-map i)
                      ;; If this value is used in a context where it could return multiple values,
                      ;; then we wrap it in a lambda.
                      `((,(make-symbol (builtin :lambda)) (,(make-symbol var)) ,(make-symbol var)) ,(nth root (+ i 1)))
                      ;; Otherwise, just use the normal value!
                      (or (nth root (+ i 1)) (make-nil)))
                    child))
                child)))
          (for i (n root) 2 -1 (remove-nth! root i))
          (for i (n args) 1 -1 (remove-nth! args i)))))))

(defpass cond-eliminate (state nodes var-lookup)
  "Replace variables with known truthy/falsey values with `true` or
   `false` when used in branches."
  :cat '("opt" "usage")
  (with (lookup {})
    (visitor/visit-list nodes 1
      (lambda (node visitor is-cond)
        (case (type node)
          ["symbol"
           (when is-cond
             (case (.> lookup (.> node :var))
               [false (when (/= (.> node :var) (builtin :false)) (make-symbol (builtin :false)))]
               [true  (when (/= (.> node :var) (builtin :true))  (make-symbol (builtin :true)))]
               [_ nil]))]

          ["list"
           (with (head (car node))
             (case (type head)
               ["symbol"
                (when (builtin? head :cond)
                  (with (vars '())
                    (for i 2 (n node) 1
                      (let* [(entry (nth node i))
                             (test (car entry))
                             (len (n entry))
                             (var (and (symbol? test) (.> test :var)))]

                        (when var
                          (cond
                            ;; If we've already got a definition of var then we'll skip it.
                            [(/= (.> lookup var) nil) (set! var nil)]
                            ;; If this variable is redefined then we'll skip it.
                            [(> (n (.> (usage/get-var var-lookup var) :defs)) 1) (set! var nil)]
                            [true]))

                        ;; Visit the condition, setting is-cond to true.
                        (case (visitor test visitor true)
                          [nil (visitor/visit-node test visitor)]
                          [false]
                          [?x
                           (changed!)
                           (.<! entry 1 x)])

                        ;; Set the variable to true and visit all child nodes.
                        (when var
                          (push! vars var)
                          (.<! lookup var true))
                        (for i 2 (pred len) 1 (visitor/visit-node (nth entry i) visitor))

                        ;; Visit the last entry, replacing it if required
                        (when (> len 1)
                          (with (last (nth entry len))
                            (case (visitor last visitor is-cond)
                              [nil (visitor/visit-node last visitor)]
                              [false]
                              [?x
                               (changed!)
                               (.<! entry len x)])))

                        ;; And mark the variable as false for the remaining branches
                        (when var (.<! lookup var false))))

                    (for-each var vars (.<! lookup var nil)))
                  false)]
               ["list"
                (when (and is-cond (builtin? (car head) :lambda))
                  ;; If we have a directly called lambda then we visit pretty much as normal, but make
                  ;; sure to mark the last expression as a cond.

                  ;; Visit arguments to lambda
                  (for i 2 (n node) 1 (visitor/visit-node (nth node i) visitor))

                  (with (len (n head))
                    ;; Visit main lambda body
                    (for i 3 (pred len) 1 (visitor/visit-node (nth head i) visitor))

                    ;; Visit the last entry, replacing it if required
                    (when (> len 2)
                      (with (last (nth head len))
                        (case (visitor last visitor is-cond)
                          [nil (visitor/visit-node last visitor)]
                          [false]
                          [?x
                           (changed!)
                           (.<! node head x)]))))
                  false)]
               [_]))]
          [_])))))

(defun deferrable? (lookup node)
  "Determines whether evaluation of the given NODE can be deferred until
   later."
  :hidden
  (with (deferrable true)
    (visitor/visit-node node
      (lambda (node)
        (case (type node)
          ;; Constants obviously can do whatever
          ["string"]
          ["number"]
          ["key"]

          ;; If we're a symbol, then we can only defer execution if
          ;; the variable is immutable
          ["symbol"
           (with (info (usage/get-var lookup (.> node :var)))
             (when (> (n (.> info :defs)) 1)
               (set! deferrable false)))
           deferrable]

          ["list"
           (case (type (car node))
             ["symbol"
              (with (var (.> (car node) :var))
                (cond
                  ;; Lambdas are obviously deferrable, but we shouldn't
                  ;; visit the body
                  [(= var (builtin :lambda)) false]
                  ;; Visit these as normal
                  [(= var (builtin :quote)) deferrable]
                  [(= var (builtin :quasi-quote)) deferrable]
                  [(= var (builtin :struct-literal)) deferrable]
                  [(= var (builtin :cond))]
                  ;; Everything else cannot be deferred
                  [else
                   (set! deferrable false)
                   false]))]
             ;; Otherwise we're calling a list of a constant, so just give up.
             [_
              (set! deferrable false)
              false])])))

    deferrable))

(defpass lower-value (state node lookup)
  "Pushes various values into child nodes, bringing them closer to the
   place they are used"
  :cat '("opt" "usage" "transform-post-bind")

  (let* [(lam (car node))
         (lam-args (nth lam 2))
         (arg-offset 1)
         (val-offset 2)
         (removed {})]
    (for-each zipped (zip-args lam-args 1 node 2)
      (let* [(args (car zipped))
             (vals (cadr zipped))
             (handled false)]

        ;; We're only interested if there's only one non-variadic argument and only
        ;; one value.
        (when (and (= (n args) 1) (not (scope/var-variadic? (.> (car args) :var)))
                   (= (n vals) 1) (/= (car vals) nil))
          (let* [(var (.> (car args) :var))
                 (val (car vals))]

            ;; Attempt to inline lambdas which are only used once (and that usage is a call).
            (when (and (not handled)
                       ;; If we're a lambda
                       (list? val) (builtin? (car val) :lambda)
                       ;; And we're only used once
                       (= (n (.> (usage/get-var lookup var)  :usages)) 1))
            (let [(users 0)
                  (found nil)]
              ;; So we've found a potential candidate, but we need to do some additional
              ;; checks and filtering.
              ;; Firstly, we need to ensure the node that uses this lambda is calling it
              ;; (and so can be inlined).
              ;; Additionally, we must ensure that this variable is only used once.
              ;; Technically the usage information should ensure this, but sadly it isn't
              ;; guaranteed to be accurate.
              (visitor/visit-block lam 3
                (lambda (child)
                  (cond
                    ;; We've found a call to our variable so set the upvalue.
                    [(and (list? child) (symbol? (car child)) (= (.> (car child) :var) var))
                     (set! found child)]
                    ;; We've found a usage of our variable, so increment the usage count.
                    [(and (symbol? child) (= (.> child :var) var))
                     (inc! users)]
                    [else])
                  ;; A small optimisation: stop if we've got more than one user.
                  (<= users 1)
                  nil))

              (when (and found (= users 1))
                ;; We've got just one usage, replace it!
                (changed!)
                (set! handled true)

                (.<! found 1 val)
                (remove-nth! lam-args arg-offset)
                (remove-nth! node val-offset))))

            ;; If we're some value which can be lazily created then we
            ;; can potentially lower this into a child condition.
            ;; We skip "atoms" as they will be lowered in other, more efficient, passes.
            (when (and (not handled) (not (atom? val)) (deferrable? lookup val))
              ;; Walk down the tree trying to find a position we can push down our node.
              (loop [(cur lam)
                     (start 3)
                     (best nil)]
                []

                ;; Determine whether the variable is only referenced in one child node,
                ;; if so return its index.
                (let* [(found (loop [(i start)
                                     (found nil)]
                                [(> i (n cur)) found]

                                (with (curi (nth cur i))
                                  (cond
                                    ;; If we don't contain the node then just skip onto the next one.
                                    [(not (node-contains-var? curi var)) (recur (succ i) found)]
                                    ;; If we've already found a node that contains it then exit.
                                    [found nil]
                                    ;; Otherwise, let's mark this node as containing it and continue.
                                    [else (recur (succ i) curi)]))))

                       (cond-found (and
                                     ;; We're a condition
                                     (list? found) (builtin? (car found) :cond)
                                     ;; Attempt to find a branch where only that body references it.
                                     (loop [(i 2)
                                            (block nil)]
                                       [(> i (n found)) block]
                                       (with (branch (nth found i))
                                         (cond
                                           ;; If the test references the variable then abort
                                           [(node-contains-var? (car branch) var) nil]
                                           ;; If we don't reference it then continue.
                                           [(not (fast-any (cut node-contains-var? <> var) branch 2))
                                            (recur (succ i) block)]
                                           ;; If we've already found then abort.
                                           [block nil]
                                           ;; Otherwise mark this node and continue
                                           [else
                                            (recur (succ i) branch)])))))]

                  ;; We've potentially found the next node to continue to, so let's attempt to walk down the tree.
                  (cond
                    [cond-found
                     ;; We found a new condition. Onwards!
                     (recur cond-found 2 cond-found)]
                    ;; We found a new condition. Onwards!
                    [(and
                       ;; We found a distinct node which is a directly called lambda
                       (list? found) (list? (car found)) (builtin? (caar found) :lambda)
                       ;; And we don't appear in any of the arguments
                       (fast-all (lambda (x) (not (node-contains-var? x var))) (car found) 3))
                     ;; Then we're OK to propagate into this node.
                     (recur (car found) 3 best)]

                    ;; So there's nothing else we can do: let's find our last successful node
                    ;; and push it there.
                    [best
                     (changed!)
                     (set! handled true)

                     (with (new-body `(,(make-symbol (builtin :lambda)) (,(car args))))
                       (for i 2 (n best) 1
                         (push! new-body (remove-nth! best 2)))

                       (push! best (list new-body val)))

                     (remove-nth! lam-args arg-offset)
                     (remove-nth! node val-offset)]

                    [else]))))))

        (unless handled
          ;; Otherwise we're skipping, so move onto the next set of arguments
          (set! arg-offset (+ arg-offset (n args)))
          (set! val-offset (+ arg-offset (n vals))))))))
