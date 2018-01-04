"Defines various methods for gathering and tracking definitions and
 usages of all variables in the program."

(import urn/analysis/nodes (side-effect? builtin builtin? make-nil zip-args))
(import urn/analysis/pass (defpass))
(import urn/resolve/scope scope)

(defun setup-state! (state)
  "Setup the given STATE ready for usage information"
  (.<! state :usage-vars {})
  state)

(defun get-var (state var)
  "Find a VAR entry in the current STATE."
  (let* [(vars (.> state :usage-vars))
         (entry (.> vars var))]
    (unless entry
      (set! entry
        { :var    var
          :usages '()
          :soft   '()
          :defs   '()
          :active false })
      (.<! vars var entry))
    entry))

(defun add-usage! (state var node)
  "Mark a NODE as using a specific VAR."
  (with (var-meta (get-var state var))
    (push! (.> var-meta :usages) node)
    (.<! var-meta :active true)))

(defun remove-usage! (state var node)
  "Remove NODE using VAR."
  (let* [(var-meta (get-var state var))
         (users (.> var-meta :usages))]
    (for i (n users) 1 -1
      (when (= (nth users i) node)
        (remove-nth! users i)
        (when (empty? users) (.<! var-meta :active false))))))

(defun add-soft-usage! (state var node)
  "Mark a NODE as referencing a specific VAR using a syntax quote."
  :hidden
  (with (var-meta (get-var state var))
    (push! (.> var-meta :soft) node)))

(defun add-definition! (state var node kind value)
  "Add a definition for a specific VAR."
  (with (var-meta (get-var state var))
    (push! (.> var-meta :defs) { :tag   kind
                                     :node  node
                                     :value value })))

(defun remove-definition! (state var value)
  "Remove a definition VALUE for a specific VAR."
  (let* [(var-meta (.> state :usage-vars var))
         (defs (.> var-meta :defs))]
    (for i (n defs) 1 -1
      (when (= (.> (nth defs i) :value) value) (remove-nth! defs i)))))

(defun replace-definition! (state var old-value new-kind new-value)
  "Replace OLD-VALUE with NEW-VALUE in the definition list of VAR."
  (when-with (var-meta (.> state :usage-vars var))
    (for-each def (.> var-meta :defs)
      (when (= (.> def :value) old-value)
        (.<! def :tag   new-kind)
        (.<! def :value new-value)))))

(defun populate-definitions (state nodes visit?)
  (unless visit? (set! visit? (lambda() true)))
  (letrec [(queue '())
           (lazy-defs {})
           ;; Add a usage and enqueue all lazy definitions if required
           (add-checked-usage! (lambda (var user)
                                 (unless (.> (get-var state var) :active)
                                   (when-with (defs (.> lazy-defs var))
                                     (for-each def defs
                                       (push! queue def))))
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
                                (push! defs node)
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
                           [(/= (scope/var-kind func) "builtin")
                            (for i 1 (n node) 1 (visit-node (nth node i)))]

                           ;; First the simple structures, where there is no default definition.
                           [(= func (builtin :lambda))
                            (for-each arg (nth node 2)
                              (add-definition! state (.> arg :var) arg "var" (.> arg :var)))
                            (for i 3 (n node) 1 (visit-node (nth node i)))]

                           [(= func (builtin :define-native))
                            (add-definition! state (.> node :def-var) node "var" (.> node :def-var))]

                           ;; Now consider definitions which are "lazy"
                           [(= func (builtin :set!))
                            (let [(var (.> (nth node 2) :var))
                                  (val (nth node 3))]
                              (add-definition! state var node "val" val)
                              (when (or (visit? val var node) (add-lazy-def! var val))
                                (visit-node val)))]

                           [(or (= func (builtin :define)) (= func (builtin :define-macro)))
                            (let [(var (.> node :def-var))
                                  (val (last node))]
                              (add-definition! state var node "val" val)
                              (when (or (visit? val var node) (add-lazy-def! var val))
                                (visit-node val)))]

                           ;; Normal traversal functions where we don't do usage-specific things
                           [(= func (builtin :cond))
                            (for i 2 (n node) 1
                              (for-each child (nth node i) (visit-node child)))]
                           [(= func (builtin :quote))]
                           [(= func (builtin :syntax-quote)) (visit-quote (nth node 2) 1)]
                           [(= func (builtin :import))]
                           [(= func (builtin :struct-literal))
                            (for i 2 (n node) 1 (visit-node (nth node i)))]

                           [else (fail! (.. "Unhandled variable " (scope/var-name func)))]))]
                      ["list"
                       (if (builtin? (car head) :lambda)
                         ;; Inline arguments to a directly called lambda
                         (progn
                           (for-each zipped (zip-args (cadar node) 1 node 2)
                             (let [(args (car zipped))
                                   (vals (cadr zipped))]
                               (if (and (= (n args) 1) (<= (n vals) 1) (not (scope/var-variadic? (.> (car args) :var))))
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
      (push! queue node))
    (while (> (n queue) 0)
      (visit-node (pop-last! queue)))))

(defun visit-lazy-definition? (val _ node)
  "A predicate for [[populate-definitions]] which will defer visiting a
   value VAL if it's owning NODE is a definition or the value a lambda."
  (and (= (.> node :def-var) nil)
       (not (and (list? val) (builtin? (car val) :lambda)))))

(defun visit-eager-exported? (val _ node)
  "A predicate for [populate-definitions]] which will always visit
   exported symbols and macros (as one cannot determine if they will)
   be referenced or not."
  (with (def (.> node :def-var))
    (or (and def (or (= (scope/var-kind def) "macro")
                        (scope/get-exported (scope/var-scope def) (scope/var-name def))))
        (not (list? val))
        (not (builtin? (car val) :lambda)))))

(defpass tag-usage (state nodes lookup (visit? visit-lazy-definition?))
  "Gathers usage and definition data for all expressions in NODES, storing it in LOOKUP."
  :cat '("tag" "usage")
  (setup-state! lookup)
  (populate-definitions lookup nodes visit?))
