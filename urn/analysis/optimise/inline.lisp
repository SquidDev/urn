(import urn/analysis/nodes ())
(import urn/analysis/pass ())
(import urn/analysis/tag/usage usage)
(import urn/analysis/transform (transformer))
(import urn/analysis/visitor visitor)
(import urn/resolve/scope scope)

(import urn/analysis/optimise/simple opt)
(import urn/analysis/optimise/usage opt)

(defun get-scope (scope lookup)
  "Gets SCOPE, copying it if is is a child, otherwise reusing it."
  :hidden
  (with (new-scope (.> lookup :scopes scope))
    (if new-scope
      new-scope
      (with (new-scope (scope/child))
        (.<! lookup :scopes scope new-scope)
        new-scope))))

(defun get-var (var lookup)
  "Gets VAR if its is defined within the root scope, then clone it."
  :hidden
  (or (.> lookup :vars var) var))

(defun copy-node (node lookup)
  "Copy NODE, including all variables and scopes."
  :hidden
  (case (type node)
    ["string" node]
    ["key" node]
    ["number" node]
    ["symbol"
     ;; Manually copy the variable to point to our new version
     (let* [(copy (copy-of node))
            (old-var (.> node :var))
            (new-var (get-var old-var lookup))]

       ;; Adjust the var's node if needed
       (when (and (/= old-var new-var) (= (scope/var-node old-var) node))
         (.<! new-var :node copy)) ;; TODO: Use a setter/handle this in the constructor

       ;; And correct the node's var
       (.<! copy :var new-var)
       copy)]
    ["list"
     ;; If we've got a lambda then clone the scope and variables.
     ;; We'll adjust the node definitions later.
     (when (builtin? (car node) :lambda)
       (with (args (cadr node))
         (unless (empty? args)
           (with (new-scope (scope/child (get-scope (scope/var-scope (.> (car args) :var)) lookup)))
             (for-each arg args
               (let* [(var (.> arg :var))
                      (new-var (scope/add! new-scope (scope/var-name var) (scope/var-kind var) nil))]
                 (scope/set-var-variadic! new-var (scope/var-variadic? var)) ;; TODO: Use the actual setter/improvement copying
                 (.<! lookup :vars var new-var)))))))

     ;; And copy this node
     (with (res (copy-of node))
       (for i 1 (n res) 1
         (.<! res i (copy-node (nth res i) lookup)))
       res)]))

(defun copy-node-from (node var)
  "Copy NODE belonging to the given VAR."
  :hidden
  (copy-node node { :scopes {}
                    :vars   {}
                    :root   (scope/var-scope var) }))

(defun score-node (node cumulative threshold)
  "Attempt to score NODE, determining whether it can be inlined or not.
   We pass the CUMULATIVE score of each nodes through the system,
   terminating early if it is larger than THRESHOLD."
  (case (type node)
    ;; Constants are considered free.
    ["string" cumulative]
    ["key"    cumulative]
    ["number" cumulative]

    ;; Symbol access is mostly free
    ;; TODO: Put an additional cost if an argument is accessed more than once.
    ["symbol" (+ cumulative 1)]

    ["list"
     (case (type (car node))
       ["symbol"
        (with (func (.> (car node) :var))
          (cond
            ;; Just a normal function call with symbols. We consider these
            ;; "free".
            ;; TODO: Block recursive functions
            [(/= (scope/var-kind func) "builtin")
             (score-nodes node 1 (+ cumulative (n node) 1) threshold)]

            ;; Now visit the core builtins. This isn't exactly an advanced heuristic.

            [(= func (.> builtins :lambda))
             (score-nodes node 3 (+ cumulative 10) threshold)]

            [(= func (.> builtins :cond))
             (set! cumulative (+ cumulative 3)) ;; Base cost of 3
             (with (len (n node))
               (loop [(i 2)] [(> i len)]
                 (set! cumulative (+ cumulative 4)) ;; Each branch costs 4
                 (when (<= cumulative threshold)
                   (set! cumulative (score-nodes (nth node i) 1 cumulative threshold))
                   (recur (succ i)))))
             cumulative]

            [(= func (.> builtins :set!))
             (score-node (nth node 3) (+ cumulative 5) threshold)]

            ;; As constants are free, "technically" this is all going to be free
            ;; too.
            [(= func (.> builtins :quote))
             (if (list? (nth node 2)) (+ cumulative (n node)) cumulative)]
            [(= func (.> builtins :import)) cumulative]

            ;; TODO: Actually walk this and remove the below handlers
            [(= func (.> builtins :syntax-quote))
             (score-node (nth node 2) (+ cumulative 3) threshold)]
            [(= func (.> builtins :unquote))
             (score-node (nth node 2) cumulative threshold)]
            [(= func (.> builtins :unquote-splice))
             (score-node (nth node 2) (+ cumulative 10) threshold)]

            [(= func (.> builtins :struct-literal))
             (score-nodes node 2 (+ cumulative (/ (pred (n node)) 2) 3) threshold)]))]

       ["list"
        (if (builtin? (caar node) :lambda)
          ;; Currently directly called lambdas are free. Ideally we'd exclude
          ;; variadic functions and symbols with lots of bindings.
          (-> cumulative
            (score-nodes node 2 <> threshold)
            (score-nodes (car node) 3 <> threshold))
          (score-nodes node 1 (+ cumulative (n node) 1) threshold))]

       [_ (score-nodes node 1 (+ cumulative (n node) 1) threshold)])]))

(defun score-nodes (nodes start cumulative threshold)
  "Score the lambda NODES, starting from START and adding to SUM.

   This is slightly different to a folr as it will exit if [[score-node]]
   returns `false`."
  (with (len (n nodes))
    (loop [(i start)] [(> i len)]
      (when (<= cumulative threshold)
        (set! cumulative (score-node (nth nodes i) cumulative threshold))
        (recur (succ i)))))
  cumulative)

(define pre-threshold
  "The maximum score a function can have in order for inlining to be
   considered."
  :hidden
  50)

(define post-threshold
  "The maximum score a function can have in order for inlining to be
   applied."
  :hidden
  20)

(defun get-score (state lookup node matchers)
  "Get the score for a given NODE.

   This will return `false` if the node should not be considered for
   inlining, or the computed score if it should be. Note the score will
   always be between 0 and [[pre-threshold]]."
  :hidden
  (with (score (.> lookup node))
    (cond
      ;; If we've found something in the cache then use that.
      [(/= score nil) score]

      ;; We avoid inlining the definition if we have a varargs somewhere.
      ;; This is mostly because the code required to generate this is
      ;; jolly tricky.
      [(any (lambda (arg) (scope/var-variadic? (.> arg :var))) (cadr node))
       (.<! lookup node false)
       false]

      ;; This is a good candidate: let's score the node and attempt to
      ;; inline things.
      [else
       (let* [(score (score-nodes node 3 0 pre-threshold))
              (adj-score
                (cond
                  ;; If we're within the post-threshold then we can always inline
                  [(< score post-threshold) score]

                  ;; If we're within the pre-threshold then let's determine whether
                  ;; one of the arguments is suitable for inlining.
                  [(< score pre-threshold)
                   (let* [(matches false)
                          (args {})]
                     (for-each arg (nth node 2) (.<! args (.> arg :var) arg))

                     (visitor/visit-block node 3
                       (lambda (node)
                         (cond
                           ;; If we've already got a node that matches then abort visiting
                           [matches false]
                           ;; If this node matches then mark and finish
                           [(any (cut <> state node args) matchers)
                            (set! matches true)
                            false]
                           ;; Else continue
                           [else true])))

                     (and matches score))]

                  ;; Otherwise just give up
                  [else false]))]

         (.<! lookup node adj-score)
         adj-score)])))

(defpass inline (state nodes usage)
  "Inline simple functions."
  :cat '("opt" "usage")
  :level 2
  (let* [(score-lookup {})
         ;; TODO: Gather this list by filtering enabled nodes with an `:inline` tag.
         (passes (list opt/constant-fold
                       opt/cond-fold
                       opt/progn-fold-expr
                       opt/progn-fold-block
                       opt/variable-fold
                       opt/strip-args
                       opt/lambda-fold
                       opt/expression-fold))
         (body-matchers (maybe-map (cut .> <> :inline-body) passes))
         (val-matchers (maybe-map (cut .> <> :inline-val) passes))]

    (visitor/visit-block nodes 1
      (lambda (node)
        ;; Only work on function calls on symbols...
        (when (and (list? node) (symbol? (car node)))
          (let* [(func (.> (car node) :var))
                 (def (usage/get-var usage func))]
            ;; which only have one definition...
            (when (= (n (.> def :defs)) 1)
              (with (val (.> (car (.> def :defs)) :value))
                ;; and are lambdas.
                (when (and (list? val) (builtin? (car val) :lambda))
                  (with (score (get-score state score-lookup val body-matchers))
                    (cond
                      ;; Score is false, so cannot do anything
                      [(= score false)]

                      ;; Score is less than post threshold so do no additional checks
                      [(< score post-threshold)
                       (.<! node 1 (copy-node-from val func))
                       (changed!)]

                      ;; If any of the arguments looks like a good candidate then let's do
                      ;; some further speculation
                      [(fast-any (lambda (node) (any (cut <> state node) val-matchers)) node 2)
                       (let* [(copy (copy-node-from val func))
                              (copy-state {})
                              (copy-list (list copy))]
                         ;; We create a copy of the existing usage definition, to
                         ;; avoid mutating the current ones.
                         (run-pass usage/tag-usage state (create-tracker) copy-list copy-state)
                         ;; Now update the definitions of each node with the function argument
                         (for-each zipped (zip-args (cadr copy) 1 node 2)
                           (let [(args (car zipped))
                                 (vals (cadr zipped))]
                             (when (and (= (n args) 1) (<= (n vals) 1) (not (scope/var-variadic? (.> (car args) :var))))
                               ;; If we've just got one argument and one value then lazily visit these
                               ;; values. Technically this lazy visiting could happen for all arguments,
                               ;; but this system is easier.
                               (let [(var (.> (car args) :var))
                                     (val (or (car vals) (make-nil)))]
                                 (usage/replace-definition! copy-state var var "val" val)))))

                         (run-pass transformer state (create-tracker) copy-list copy-state passes)

                         (with (copy-res (case (n copy-list)
                                           [0 (make-nil)]
                                           [1 (car copy-list)]
                                           [_ (make-progn copy-list)]))
                           (when (<= (score-nodes copy-res 1 0 post-threshold) post-threshold)
                             (.<! node 1 copy)
                             (changed!))))]

                      [else])))))))))))
