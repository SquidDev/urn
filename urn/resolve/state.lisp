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

(import urn/error error)
(import urn/range range)
(import urn/resolve/scope scope)

(import lua/coroutine co)
(import data/struct ())

(defstruct (resolve-state create resolve-state?)
  (fields
    (immutable scope rs-scope
      "The scope this top level definition lives under.")
    (immutable compiler rs-compiler
      "The main compiler instance.")
    (immutable required (hide rs-required)
      "Ordered list of all required variables.")
    (immutable required-set (hide rs-required-set)
      "Set of all required variables.")
    (mutable stage rs-stage (hide set-rs-stage!)
      "The current stage we are in. Transitions from parsed → built → executed.")
    (mutable var rs-var (hide set-rs-var!)
      "The variable this node defines.")
    (mutable node rs-node (hide set-rs-node!)
      "The final node for this entry. Set when building/resolution has
       finished.")
    (mutable value (hide rs-value) (hide set-rs-value!)
      "The actual value of this node. Set when this node is executed."))

  (constructor new
    (lambda (scope compiler)
      (assert-type! scope scope)
      (when (= compiler nil) (error! "compiler cannot be nil"))

      (new
        scope
        compiler
        '() {}
        "parsed"
        nil nil nil))))

(defun rs-logger (state)
  "The main logger instance for the STATE's compiler."
  (.> (rs-compiler state) :log))

(defun rs-mappings (state)
  "Line mapping lookup for the STATE's compiler."
  (.> (rs-compiler state) :compile-state :mappings))

(defun rs-exec (state function)
  "Wrap a FUNCTION with STATE's executor wrapper."
  ((.> (rs-compiler state) :exec) function))

(defun require! (state var user)
  "Mark STATE as requiring the given VAR. USER is the node which
   triggered this requirement."
  ;; General sanity checks
  (when (/= (rs-stage state) "parsed") (error! (.. "Cannot add requirement when in stage "(rs-stage state))))
  (unless var (error! "var is nil"))
  (unless user (error! "user is nil"))

  ;; If we're using a top level definition then add a dependency on it.
  (if (scope/scope-top-level? (scope/var-scope var))
    (with (other (.> (rs-compiler state) :states var))
      (when (and other (not (.> (rs-required-set state) other)))
        (.<! (rs-required-set state) other user)
        (push! (rs-required state) other))
      other)
    nil))

(defun define! (state var)
  "Mark STATE as defining the given VAR."
  ;; General sanity checks
  (when (/= (rs-stage state) "parsed") (error! (.. "Cannot add definition when in stage "(rs-stage state))))
  (when (/= (scope/var-scope var) (rs-scope state)) (error! "Defining variable in different scope"))
  (when (rs-var state) (error! "Cannot redeclare variable for given state"))

  ;; Store the variable for convenient access elsewhere.
  (set-rs-var! state var)
  (.<! (rs-compiler state) :states var state)
  (.<! (rs-compiler state) :variables (tostring var) var))

(defun built! (state node)
  "Mark this STATE as built, setting the resolved NODE."
  (unless node (error! "node cannot be nil"))
  (when (/= (rs-stage state) "parsed") (error! (.. "Cannot transition from " (rs-stage state) " to built")))
  (when (/= (.> node :def-var) (rs-var state)) (error! "Variables are different"))

  (set-rs-node! state node)
  (set-rs-stage! state "built"))

(defun executed! (state value)
  "Mark this STATE as executed, setting the executed VALUE."
  (when (/= (rs-stage state) "built") (error! (.. "Cannot transition from "(rs-stage state) " to executed")))

  (set-rs-value! state value)
  (set-rs-stage! state "executed"))

(defun get! (state)
  "Attempt to get the compiled value of STATE. If this has already been
   fetched then it will just return it, otherwise it will resolve all
   dependencies, scan for macro-dependency loops and execute all required
   states."

  (if (= (rs-stage state) "executed")
    (rs-value state)

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
                             (when (= (scope/var-kind (rs-var state)) "macro")
                               (push! stack state)

                               (let [(states '())
                                     (nodes '())
                                     (first-node nil)]
                                 (for i idx (n stack) 1
                                   (let [(current (nth stack i))
                                         (previous (nth stack (pred i)))]
                                     (push! states (scope/var-name (rs-var current)))
                                     (when previous
                                       (with (user (.> (rs-required-set previous) current))
                                         (unless first-node (set! first-node user))

                                         (push! nodes (range/get-source user))
                                         (push! nodes (.. (scope/var-name (rs-var current)) " used in " (scope/var-name (rs-var previous))))))))

                                 (error/do-node-error! (rs-logger state)
                                   (.. "Loop in macros " (concat states " -> "))
                                   (range/get-top-source first-node) nil
                                   (splice nodes))))]

                            ;; This node has already been executed so we don't need to worry about it.
                            [(= (rs-stage state) "executed")]
                            [true
                             (push! stack state)
                             (.<! stack-hash state (n stack))

                             (unless (.> required-set state)
                               (.<! required-set state true)
                               (push! required state))

                             (with (visited {})
                               (for-each inner (rs-required state)
                                 (.<! visited inner true)
                                 (visit inner stack stack-hash))

                               (when (= (rs-stage state) "parsed")
                                 (co/yield { :tag "build" :state state }))

                               (for-each inner (rs-required state)
                                 (unless (.> visited inner)
                                   (visit inner stack stack-hash)))

                               (pop-last! stack)
                               (.<! stack-hash state nil))]))))]
        (visit state '() {}))

      (co/yield { :tag "execute" :states required })
      (rs-value state))))

(defun name (state)
  "Get a pretty name for this STATE."
  (if (rs-var state)
    (.. "macro " (string/quoted (scope/var-name (rs-var state))))
    "unquote"))
