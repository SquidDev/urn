"Defines various methods for gathering and tracking definitions and
 usages of all variables in the program."

(import table)
(import lua/basic (type#))

(import urn/analysis/nodes (side-effect? builtins builtin? make-nil zip-args))
(import urn/analysis/pass (defpass))

(defun create-state ()
  "Create a new, empty usage state."
  { :vars {}
    :nodes {}})

(defun get-var (state var)
  "Find a VAR entry in the current STATE."
  (with (entry (.> state :vars var))
    (unless entry
      (set! entry
        { :var    var
          :usages '()
          :soft   '()
          :defs   '()
          :active false })
      (.<! state :vars var entry))
    entry))

(defun get-node (state node)
  "Find a NODE entry in the current STATE."
  (with (entry (.> state :nodes node))
    (unless entry
      (set! entry { :uses '() })
      (.<! state :nodes node entry))
    entry))

(defun add-usage! (state var node)
  "Mark a NODE as using a specific VAR."
  :hidden
  (with (var-meta (get-var state var))
    (push-cdr! (.> var-meta :usages) node)
    (.<! var-meta :active true)))

(defun add-soft-usage! (state var node)
  "Mark a NODE as referencing a specific VAR using a syntax quote."
  :hidden
  (with (var-meta (get-var state var))
    (push-cdr! (.> var-meta :soft) node)))

(defun add-definition! (state var node kind value)
  "Add a definition for a specific VAR."
  :hidden
  (with (var-meta (get-var state var))
    (push-cdr! (.> var-meta :defs) { :tag   kind
                                     :node  node
                                     :value value })))

(defun populate-definitions (state nodes visit?)
  (unless visit? (set! visit? (lambda() true)))
  (letrec [(queue '())
           (lazy-defs {})
           ;; Add a usage and enqueue all lazy definitions if required
           (add-checked-usage! (lambda (var user)
                                 (unless (.> (get-var state var) :active)
                                   (when-with (defs (.> lazy-defs var))
                                     (for-each def defs
                                       (push-cdr! queue def))))
                                 (add-usage! state var user)))
           ;; Enqueue a lazy definition if required, returning whether it
           ;; should be visited or not.
           (add-lazy-def! (lambda (var node)
                            (if (.> (get-var state var) :active)
                              true
                              (with (defs (.> lazy-defs var))
                                (unless defs
                                  (set! defs '())
                                  (.<! lazy-defs var defs))
                                (push-cdr! defs node)
                                false))))
           ;; Quote visitor function
           (visit-quote
             (lambda (node level)
               (if (= level 0)
                 (visit-node node)
                 (case (type node)
                   ["string"] ["number"] ["key"]
                   ["symbol"
                    (when-with (var (.> node :var)) (add-soft-usage! state var node))]
                   ["list"
                    (with (first (nth node 1))
                      (cond
                        ;; If we're not a symbol, visit as normally
                        [(/= (type first) "symbol") (for-each sub node (visit-quote sub level))]
                        ;; Step up or down a level
                        [(or (= (.> first :contents) "unquote") (= (.> first :contents) "unquote-splice"))
                         (visit-quote (nth node 2) (pred level))]
                        [(= (.> first :contents) "syntax-quote")
                         (visit-quote (nth node 2) (succ level))]
                        ;; Visit a normal
                        [else (for-each sub node (visit-quote sub level))]))]))))

           ;; The main visitor function.
           (visit-node
             (lambda (node)
               (case (type node)
                 ["string"] ["number"] ["key"]
                 ["symbol" (add-checked-usage! (.> node :var) node)]
                 ["list"
                  (with (head (car node))
                    (case (type head)
                      ["symbol"
                       (with (func (.> head :var))
                         (cond
                           ;; "Fast track" for non-builtin symbols
                           [(/= (.> func :tag) "builtin")
                            (for i 1 (n node) 1 (visit-node (nth node i)))]

                           ;; First the simple structures, where there is no default definition.
                           [(= func (.> builtins :lambda))
                            (for-each arg (nth node 2)
                              (add-definition! state (.> arg :var) arg "var" (.> arg :var)))
                            (for i 3 (n node) 1 (visit-node (nth node i)))]

                           [(= func (.> builtins :define-native))
                            (add-definition! state (.> node :def-var) node "var" (.> node :def-var))]

                           ;; Now consider definitions which are "lazy"
                           [(= func (.> builtins :set!))
                            (let [(var (.> (nth node 2) :var))
                                  (val (nth node 3))]
                              (add-definition! state var node "val" val)
                              (when (or (visit? val var node) (add-lazy-def! var val))
                                (visit-node val)))]

                           [(or (= func (.> builtins :define)) (= func (.> builtins :define-macro)))
                            (let [(var (.> node :def-var))
                                  (val (last node))]
                              (add-definition! state var node "val" val)
                              (when (or (visit? val var node) (add-lazy-def! var val))
                                (visit-node val)))]

                           ;; Normal traversal functions where we don't do usage-specific things
                           [(= func (.> builtins :cond))
                            (for i 2 (n node) 1
                              (for-each child (nth node i) (visit-node child)))]
                           [(= func (.> builtins :quote))]
                           [(= func (.> builtins :syntax-quote)) (visit-quote (nth node 2) 1)]
                           [(= func (.> builtins :import))]
                           [(= func (.> builtins :struct-literal))
                            (for i 2 (n node) 1 (visit-node (nth node i)))]

                           [else (fail! (.. "Unhandled variable " (.> func :name)))]))]
                      ["list"
                       (if (builtin? (car head) :lambda)
                         ;; Inline arguments to a directly called lambda
                         (progn
                           (for-each zipped (zip-args (cadar node) 1 node 2)
                             (let [(args (car zipped))
                                   (vals (cadr zipped))]
                               (if (and (= (n args) 1) (<= (n vals) 1) (! (.> (car args) :var :is-variadic)))
                                 ;; If we've just got one argument and one value then lazily visit these
                                 ;; values. Technically this lazy visiting could happen for all arguments,
                                 ;; but this system is easier.
                                 (let [(var (.> (car args) :var))
                                       (val (or (car vals) (make-nil)))]
                                   (add-definition! state var (car args) "val" val)
                                   (when (or (visit? val var node) (add-lazy-def! var val))
                                     (visit-node val)))
                                 (progn
                                   (for-each arg args
                                     (add-definition! state (.> arg :var) arg "var" (.> arg :var)))
                                   (for-each val vals
                                     (visit-node val))))))

                           ;; Never visit directly called lambdas, we'll do that ourselves.
                           (for i 3 (n head) 1 (visit-node (nth head i))))
                         (for i 1 (n node) 1 (visit-node (nth node i))))]
                      [_ (for i 1 (n node) 1 (visit-node (nth node i)))]))])))]

  (for-each node nodes
    (push-cdr! queue node))
  (while (> (n queue) 0)
    (visit-node (pop-last! queue)))))

(defun visit-lazy-definition? (val _ node)
  "A predicate for [[populate-definitions]] which will defer visiting a
   value VAL if it's owning NODE is a definition or the value a lambda."
  (and (= (.> node :def-var) nil)
       (! (and (list? val) (builtin? (car val) :lambda)))))

(defun visit-eager-exported? (val _ node)
  "A predicate for [populate-definitions]] which will always visit
   exported symbols and macros (as one cannot determine if they will)
   be referenced or not."
  (with (def (.> node :def-var))
    (or (and def (or (= (.> def :tag) "macro") (.> def :scope :exported (.> def :name))))
        (! (list? val))
        (! (builtin? (car val) :lambda)))))

(defpass tag-usage (state nodes lookup (visit? visit-lazy-definition?))
  "Gathers usage and definition data for all expressions in NODES, storing it in LOOKUP."
  :cat '("tag" "usage")
  (populate-definitions lookup nodes visit?))
