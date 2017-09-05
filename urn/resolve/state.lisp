"The state tracks a single node's resolution progress. Namely, it keeps
 note of:

  - All variables this node \"depends\" on (will access when
    executed). This does not include syntax quoted variables.

  - The variable this node declares.

  - The final node once resolution is finished.

  - The value of this node if it has been executed.

 Further more, this also handles gathering all nested dependencies for
 this node to be executed and build, detecting cycles in building (say
 two macros each require the other in order to be expanded)."

(import urn/range range)
(import urn/resolve/error error)

(import lua/coroutine co)

(defun create (scope compiler)
  "Create a new node state under the current STATE, using the given
   COMPILER instance."
  (unless scope (error! "scope cannot be nil"))
  (unless compiler (error! "compiler cannot be nil"))

  { :scope scope ;; The scope this top level definition lives under
    :compiler compiler ;; The main compiler instance
    :logger (.> compiler :log) ;; The logger instance
    :mappings (.> compiler :compile-state :mappings) ;; TODO: Remove me.
    :required '() ;; List and set of all required vriables
    :required-set {}
    :stage "parsed" ;; The current stage we are in. Transitions from parsed -> built -> executed.
    :var nil ;; The variable this node defines.
    :node nil ;; The final node for this entry. Set when building/resolution has finished.
    :value nil ;; The actual value of this node. Set when this node is executed.
  })

(defun require! (state var user)
  "Mark STATE as requiring the given VAR. USER is the node which
   triggered this requirement."
  ;; General sanity checks
  (when (/= (.> state :stage) "parsed") (error! (.. "Cannot add requirement when in stage "(.> state :stage))))
  (unless var (error! "var is nil"))
  (unless user (error! "user is nil"))

  ;; If we're using a top level definition then add a dependency on it.
  (if (.> var :scope :is-root)
    (with (other (.> state :compiler :states var))
      (when (and other (not (.> state :required-set other)))
        (.<! state :required-set other user)
        (push-cdr! (.> state :required) other))
      other)
    nil))

(defun define! (state var)
  "Mark STATE as defining the given VAR."
  ;; General sanity checks
  (when (/= (.> state :stage) "parsed") (error! (.. "Cannot add definition when in stage "(.> state :stage))))
  (when (/= (.> var :scope) (.> state :scope)) (error! "Defining variable in different scope"))
  (when (.> state :var) (error! "Cannot redeclare variable for given state"))

  ;; Store the variable for convenient access elsewhere.
  (.<! state :var var)
  (.<! state :compiler :states var state)
  (.<! state :compiler :variables (tostring var) var))

(defun built! (state node)
  "Mark this STATE as built, setting the resolved NODE."
  (unless node (error! "node cannot be nil"))
  (when (/= (.> state :stage) "parsed") (error! (.. "Cannot transition from "(.> state :stage) " to built")))
  (when (/= (.> node :def-var) (.> state :var)) (error! "Variables are different"))

  (.<! state :node node)
  (.<! state :stage "built"))

(defun executed! (state value)
  "Mark this STATE as executed, setting the executed VALUE."
  (when (/= (.> state :stage) "built") (error! (.. "Cannot transition from "(.> state :stage) " to executed")))

  (.<! state :value value)
  (.<! state :stage "executed"))

(defun get! (state)
  "Attempt to get the compiled value of STATE. If this has already been
   fetched then it will just return it, otherwise it will resolve all
   dependencies, scan for macro-dependency loops and execute all required
   states."

  (if (= (.> state :stage) "executed")
    (.> state :value)

    (let [(required '())
          (required-set {})]

      ;; We walk the tree of all nodes, marking each of them as required
      ;; We also maintain a stack of all currently visited nodes, in order to
      ;; detect macro loops.
      (letrec [(visit (lambda (state stack stack-hash)
                        (with (idx (.> stack-hash state))
                          (cond
                            [idx
                             ;; We've already visited this node, on this current iteration.
                             (when (= (.> state :var :kind) "macro")
                               (push-cdr! stack state)

                               (let [(states '())
                                     (nodes '())
                                     (first-node nil)]
                                 (for i idx (n stack) 1
                                   (let [(current (nth stack i))
                                         (previous (nth stack (pred i)))]
                                     (push-cdr! states (.> current :var :name))
                                     (when previous
                                       (with (user (.> previous :required-set current))
                                         (unless first-node (set! first-node user))

                                         (push-cdr! nodes (range/get-source user))
                                         (push-cdr! nodes (.. (.> current :var :name) " used in " (.> previous :var :name)))))))

                                 (error/do-node-error! (.> state :logger)
                                   (.. "Loop in macros " (concat states " -> "))
                                   first-node nil
                                   (unpack nodes 1 (n nodes)))))]

                            ;; This node has already been executed so we don't need to worry about it.
                            [(= (.> state :stage) "executed")]
                            [true
                             (push-cdr! stack state)
                             (.<! stack-hash state (n stack))

                             (unless (.> required-set state)
                               (.<! required-set state true)
                               (push-cdr! required state))

                             (with (visited {})
                               (for-each inner (.> state :required)
                                 (.<! visited inner true)
                                 (visit inner stack stack-hash))

                               (when (= (.> state :stage) "parsed")
                                 (co/yield { :tag "build" :state state }))

                               (for-each inner (.> state :required)
                                 (unless (.> visited inner)
                                   (visit inner stack stack-hash)))

                               (pop-last! stack)
                               (.<! stack-hash state nil))]))))]
        (visit state '() {}))

      (co/yield { :tag "execute" :states required })
      (.> state :value))))

(defun name (state)
  "Get a pretty name for this STATE."
  (if (.> state :var)
    (.. "macro " (string/quoted (.> state :var :name)))
    "unquote"))
