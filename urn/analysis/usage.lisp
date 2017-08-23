"Defines various methods for gathering and tracking definitions and
 usages of all variables in the program."

(import table)
(import lua/basic (type#))

(import urn/analysis/visitor visitor)
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
        { :var var
          :usages '()
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

(defun add-definition! (state var node kind value)
  "Add a definition for a specific VAR."
  :hidden
  (with (var-meta (get-var state var))
    (push-cdr! (.> var-meta :defs) { :tag   kind
                                     :node  node
                                     :value value })))

(defun populate-definitions (state nodes pred)
  (unless pred (set! pred (lambda() true)))
  (let* [(queue '())
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
         ;; The main visitor function.
         (visitor
           (lambda (node visitor)
             (case (type node)
               ["symbol" (add-checked-usage! (.> node :var) node)]
               ["list"
                (with (head (car node))
                  (case (type head)
                    ["symbol"
                     (with (func (.> head :var))
                       (cond
                         ;; "Fast track" for non-builtin symbols
                         [(/= (.> func :tag) "builtin")]
                         ;; First the simple arguments, where there is no default definition.
                         [(= func (.> builtins :lambda))
                          (for-each arg (nth node 2)
                            (add-definition! state (.> arg :var) arg "var" (.> arg :var)))]
                         [(= func (.> builtins :define-native))
                          (add-definition! state (.> node :def-var) node "var" (.> node :def-var))]

                         ;; Now consider definitions which are "lazy"
                         [(= func (.> builtins :set!))
                          (let [(var (.> (nth node 2) :var))
                                (val (nth node 3))]
                            (add-definition! state var node "val" val)
                            (or (pred val var node) (add-lazy-def! var val)))]
                         [(or (= func (.> builtins :define)) (= func (.> builtins :define-macro)))
                          (let [(var (.> node :def-var))
                                (val (last node))]
                            (add-definition! state var node "val" val)
                            (or (pred val var node) (add-lazy-def! var val)))]

                         [else]))]
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
                                 (when (or (pred val var node) (add-lazy-def! var val))
                                   (visitor/visit-node val visitor)))
                               (progn
                                 (for-each arg args
                                   (add-definition! state (.> arg :var) arg "var" (.> arg :var)))
                                 (for-each val vals
                                   (visitor/visit-node val visitor))))))

                         ;; Never visit directly called lambdas, we'll do that ourselves.
                         (visitor/visit-block head 3 visitor)
                         false)
                       true)]
                    [_]))]
               [_])))]

  (for-each node nodes
    (push-cdr! queue node))
  (while (> (n queue) 0)
    (visitor/visit-node (pop-last! queue) visitor))))

(defpass tag-usage (state nodes lookup)
  "Gathers usage and definition data for all expressions in NODES, storing it in LOOKUP."
  :cat '("tag" "usage")
  (populate-definitions lookup nodes (lambda (val var node)
                                       (! (or (and (list? val) (builtin? (car val) :lambda))
                                              (and (list? node) (or (builtin? (car node) :define)
                                                                    (builtin? (car node) :define-macro))))))))
