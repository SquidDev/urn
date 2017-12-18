(import urn/analysis/nodes ())
(import urn/analysis/pass ())
(import urn/analysis/tag/usage usage)
(import urn/analysis/visitor visitor)
(import urn/resolve/scope scope)

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
    ["string" (copy-of node)]
    ["key" (copy-of node)]
    ["number" (copy-of node)]
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

            ;; Now visit the core builtins. This isn't exactly an advanced herustic.

            [(= func (builtin :lambda))
             (score-nodes node 3 (+ cumulative 10) threshold)]

            [(= func (builtin :cond))
             (set! cumulative (+ cumulative 3)) ;; Base cost of 3
             (with (len (n node))
               (loop [(i 2)] [(> i len)]
                 (set! cumulative (+ cumulative 4)) ;; Each branch costs 4
                 (when (<= cumulative threshold)
                   (set! cumulative (score-nodes (nth node i) 1 cumulative threshold))
                   (recur (succ i)))))
             cumulative]

            [(= func (builtin :set!))
             (score-node (nth node 3) (+ cumulative 5) threshold)]

            ;; As constants are free, "technically" this is all going to be free
            ;; too.
            [(= func (builtin :quote))
             (if (list? (nth node 2)) (+ cumulative (n node)) cumulative)]
            [(= func (builtin :import)) cumulative]

            ;; TODO: Actually walk this and remove the below handlers
            [(= func (builtin :syntax-quote))
             (score-node (nth node 2) (+ cumulative 3) threshold)]
            [(= func (builtin :unquote))
             (score-node (nth node 2) cumulative threshold)]
            [(= func (builtin :unquote-splice))
             (score-node (nth node 2) (+ cumulative 10) threshold)]

            [(= func (builtin :struct-literal))
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

   This is slightly different to a folr as it will exit if [[score-node]] returns `false`."
  (with (len (n nodes))
    (loop [(i start)] [(> i len)]
      (when (<= cumulative threshold)
        (set! cumulative (score-node (nth nodes i) cumulative threshold))
        (recur (succ i)))))
  cumulative)

(defun get-score (lookup node)
  "Get the score for NODE, using LOOKUP as a cache."
  :hidden
  (with (score (.> lookup node))
    (when (= score nil)
      ;; We have a lambda. We avoid inlining if we have a varargs somewhere.
      (set! score 0)
      (for-each arg (nth node 2)
        (when (scope/var-variadic? (.> arg :var)) (set! score false)))

      ;; If we have no varargs, then let's inline this function.
      (when score (set! score (score-nodes node 3 score threshold)))

      (.<! lookup node score))

    (if score score math/huge)))

(define threshold
  "The maximum score a function can have in order for inlining to be applied."
  :hidden
  20)

(defpass inline (state nodes usage)
  "Inline simple functions."
  :cat '("opt" "usage")
  :level 2
  (with (score-lookup {})
    (visitor/visit-block nodes 1
      (lambda (node)
        ;; Only work on function calls on symbols
        (when (and (list? node) (symbol? (car node)))
          (let* [(func (.> (car node) :var))
                 (def (usage/get-var usage func))]
            ;; If we've only got one definition then we'll look at that
            (when (= (n (.> def :defs)) 1)
              (let* [(ent (car (.> def :defs)))
                     (val (.> ent :value))]
                ;; For all lambda definitions, determine whether we can actually inline it.
                (when (and
                      (list? val) (builtin? (car val) :lambda)
                      (<= (get-score score-lookup val) threshold))
                  ;; We can! Inline the node, and updat the function call with the new node.
                  (with (copy (copy-node val { :scopes {}
                                               :vars   {}
                                               :root   (scope/var-scope func) }))
                    (.<! node 1 copy)
                    (changed!)))))))))))
