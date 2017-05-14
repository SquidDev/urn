(import urn/analysis/nodes ())
(import urn/analysis/pass ())
(import urn/analysis/usage usage)
(import urn/analysis/visitor visitor)

(define scope/child :hidden (.> (require "tacky.analysis.scope") :child))
(define scope/add! :hidden (.> (require "tacky.analysis.scope") :add))

(defun copy-of (x)
  "Create a shallow copy of X."
  :hidden
  (with (res {})
    (for-pairs (k v) x (set-idx! res k v))
    res))

(defun get-scope (scope lookup n)
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
       (when (and (/= old-var new-var) (= (.> old-var :node) node))
         (.<! new-var :node copy))

       ;; And correct the node's var
       (.<! copy :var new-var)
       copy)]
    ["list"
     ;; If we've got a lambda then clone the scope and variables.
     ;; We'll adjust the node definitions later.
     (when (builtin? (car node) :lambda)
       (with (args (cadr node))
         (unless (empty? args)
           (with (new-scope (scope/child (get-scope (.> (car args) :var :scope) lookup node)))
             (for-each arg args
               (let* [(var (.> arg :var))
                      (new-var (scope/add! new-scope (.> var :name) (.> var :tag) nil))]
                 (.<! new-var :isVariadic (.> var :isVariadic))
                 (.<! lookup :vars var new-var)))))))

     ;; And copy this node
     (with (res (copy-of node))
       (for i 1 (n res) 1
         (.<! res i (copy-node (nth res i) lookup)))
       res)]))

(defun score-node (node)
  "Attempt to score NODE, determining whether it can be inlined or not."
  :hidden
  (case (type node)
    ;; Honestly, I'm not sure what to do with these. They are basically "free" so we don't need to worry.
    ["string" 0]
    ["key" 0]
    ["number" 0]
    ["symbol" 1]

    ["list"
     (case (type (car node))
       ["symbol"
        (with (func (.> (car node) :var))
          (cond
            ;; Please note, these values are entirely arbitrary.
            [(= func (.> builtins :lambda))
             (score-nodes node 3 10)]
            [(= func (.> builtins :cond))
             (score-nodes node 2 10)]
            [(= func (.> builtins :set!))
             (score-nodes node 2 5)]
            [(= func (.> builtins :quote))
             (score-nodes node 2 2)]
            [(= func (.> builtins :quasi-quote))
             (score-nodes node 2 3)]
            [(= func (.> builtins :unquote-splice))
             (score-nodes node 2 10)]
            [true
             (score-nodes node 1 (+ (n node) 1))]))]
       [_ (score-nodes node 1 (+ (n node) 1))])]))

(defun get-score (lookup node)
  "Get the score for NODE, using LOOKUP as a cache."
  :hidden
  (with (score (.> lookup node))
    (when (= score nil)
      ;; We have a lambda. We avoid inlining if we have a varargs somewhere.
      (set! score 0)
      (for-each arg (nth node 2)
        (when (.> arg :var :isVariadic) (set! score false)))

      ;; If we have no varargs, then let's inline this function.
      (when score (set! score (score-nodes node 3 score)))

      (.<! lookup node score))

    (if score score math/huge)))

(defun score-nodes (nodes start sum)
  "Score the lambda NODES, starting from START and adding to SUM.

   This is slightly different to a folr as it will exit if [[score-node]] returns `false`."
  :hidden
  (if (> start (n nodes))
    sum
    (with (score (score-node (nth nodes start)))
      (if score
        (if (> score threshold)
          score
          (score-nodes nodes (succ start) (+ sum score)))
        false))))

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
                                               :root   (.> func :scope) }))
                    (.<! node 1 copy)
                    (changed!)))))))))))
