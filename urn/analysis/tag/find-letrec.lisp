(import data/struct ())

(import urn/analysis/nodes ())
(import urn/analysis/pass ())
(import urn/resolve/scope scope)

(defstruct (rec-func (hide rec-func) rec-func?)
  (fields
    (immutable parent
      "The parent lambda which declared this recursive function.")

    (mutable setter rec-func-setter (hide set-rec-func-setter!)
      "The node which sets this recursive function.")

    (mutable lambda rec-func-lambda (hide set-rec-func-lambda!)
      "The main lambda this variable corresponds to.")

    (mutable recur rec-func-recur (hide set-rec-func-recur!)
      "Counts how often this variable is called in a tail-recursive
       context.")

    (mutable direct rec-func-direct (hide set-rec-func-direct!)
      "Counts how often this variable is called in the parent lambda.")

    (mutable var rec-func-var (hide set-rec-func-var!)
      "Counts how often this variable is used in some other context, be
       that a non-tail-recursive call or as a variable."))

  (constructor new
    (lambda (parent)
      (new parent nil nil 0 0 0))))

(defun inc-rec-func-recur! (func)
  :hidden
  (set-rec-func-recur! func (succ (rec-func-recur func))))

(defun inc-rec-func-direct! (func)
  :hidden
  (set-rec-func-direct! func (succ (rec-func-direct func))))

(defun inc-rec-func-var! (func)
  :hidden
  (set-rec-func-var! func (succ (rec-func-var func))))

(defun visit-quote (node level lookup)
  "Visit a `syntax-quote`d NODE at the given LEVEL - where 1 is a single level of nesting,
   and 0 a normal node."
  :hidden
  (if (= level 0)
    (visit-node node nil nil lookup)
    (with (tag (type node))
      (cond
        [(or (= tag "string") (= tag "number") (= tag "key") (= tag "symbol"))]
        [(= tag "list")
         (with (first (nth node 1))
           (if (symbol? node)
             (cond
               [(or (= (.> first :contents) "unquote") (= (.> first :contents) "unquote-splice"))
                (visit-quote (nth node 2) (pred level) lookup)]
               [(= (.> first :contents) "syntax-quote")
                (visit-quote (nth node 2) (succ level) lookup)]
               [true
                 (for-each sub node (visit-quote sub level lookup))])
             (for-each sub node (visit-quote sub level lookup))))]
        (error! (.. "Unknown tag " tag))))))

(defun visit-node (node parents active lookup)
  "VISIT NODE with the current LOOKUP state and variables.

   LOOKUP is a mapping of variables to [[rec-func]]s.

   If we finish visiting a lambda without the `:recur` flag being set, or
   if the definition is ever rebound, then we remove it from LOOKUP."
  :hidden
  (case (type node)
    ["string"]
    ["number"]
    ["key"]
    ["symbol"
     ;; We'd have caught a call, so this must be a normal variable usage.
     (when-with (func (.> lookup (.> node :var)))
       (inc-rec-func-var! func))]

    ["list"
     (with (head (car node))
       (case (type head)
         ["symbol"
          (with (func (.> head :var))
            (cond
              ;; Just a bog-standard call.
              [(/= (scope/var-kind func) "builtin")
               (with (func (.> lookup func))
                 (cond
                   ;; If we have no recursive function, then we can skip it.
                   [(not func)]
                   ;; If this is the active one, then increment the recursive count.
                   [(= active func)
                    (inc-rec-func-recur! func)]
                   ;; If we're in the function which defines this variable and the lambda has been set
                   ;; then consider this a "direct" call.
                   [(and parents (.> parents (rec-func-parent func)))
                    (inc-rec-func-direct! func)]
                   ;; Otherwise increment the current mode.
                   [true
                    (inc-rec-func-var! func)]))

               ;; And visit the remaining arguments.
               (visit-nodes node 2 nil lookup)]

              ;; While we're technically visiting a block, we don't want to preserve the
              ;; recursive function.
              [(= func (builtin :lambda)) (visit-block node 3 nil nil lookup)]

              [(= func (builtin :set!))
               (let* [(var (.> (nth node 2) :var))
                      (func (.> lookup var))
                      (val (nth node 3))]
                 ;; We attempt to determine whether this set! invalidates a letrec candidate or
                 ;; forms one.
                 (if (and
                       func
                       (= (rec-func-lambda func) nil) ;; Ensure we haven't already got a function
                       parents (.> parents (rec-func-parent func)) ;; And we're setting in the parent lambda.
                       (list? val) (builtin? (car val) :lambda)) ;; And we're a lambda
                   (progn
                     ;; Set the lambda variable and visit it.
                     (set-rec-func-lambda! func val)
                     (set-rec-func-setter! func node)
                     (visit-block val 3 nil func lookup)
                     ;; If it doesn't recur, then remove it from the lookup
                     (when (= (rec-func-recur func) 0) (.<! lookup var nil)))
                   (progn
                     ;; Otherwise clear everything and visit the node normally.
                     (.<! lookup var nil)
                     (visit-node val nil nil lookup))))]

              ;; Now it's just all the standard visitor methods
              [(= func (builtin :cond))
               (for i 2 (n node) 1
                 (with (case (nth node i))
                   (visit-node (car case) nil nil lookup)
                   (visit-block case 2 nil active lookup)))]
              [(= func (builtin :quote))]
              [(= func (builtin :syntax-quote)) (visit-quote (nth node 2) 1 lookup)]
              [(or (= func (builtin :unquote)) (= func (builtin :unquote-splice)))
               (fail! "unquote/unquote-splice should never appear here")]
              [(or (= func (builtin :define)) (= func (builtin :define-macro)))
               (visit-node (nth node (n node)) nil nil lookup)]
              [(= func (builtin :define-native))] ;; Nothing needs doing here
              [(= func (builtin :import))] ;; Nothing needs doing here
              [(= func (builtin :struct-literal)) (visit-nodes node 2 nil lookup)]
              [true (fail! (.. "Unknown builtin for variable " (.> func :name)))]))]
         ["list"
          (with (first (car node))
            (if (and (list? first) (builtin? (car first) :lambda))
              ;; If we're a directly called lambda then we can preserve the "active" function and "parents".
              (progn
                ;; We loop over each argument with no value (either nil or empty) and push it to the
                ;; recursion tracker.
                (with (args (nth first 2))
                  (for i 1 (n args) 1
                    (with (val (nth node (succ i)))
                      (when (or (= val nil) (builtin? val :nil))
                        (.<! lookup (.> (nth args i) :var) (rec-func node))))))

                ;; Visit body with parents
                (if parents
                  (.<! parents node true)
                  (set! parents { node true }))
                (visit-block first 3 parents active lookup)
                (.<! parents node nil)

                ;; Then visit arguments
                (visit-nodes node 2 nil lookup))

              ;; Otherwise we just visit this normally.
              (visit-nodes node 1 nil lookup)))]
         [_ (visit-nodes node 1 nil lookup)]))]))

(defun visit-nodes (node start parents lookup)
  "Visit NODE starting from START."
  :hidden
  (for i start (n node) 1
    (visit-node (nth node i) parents nil lookup)))

(defun visit-block (node start parents active lookup)
  "Visit NODE starting from START, with the last element being visited in
   a tail recursive context."
  :hidden
  (for i start (pred (n node)) 1
    (visit-node (nth node i) parents nil lookup))

  (when (>= (n node) start)
    (visit-node (last node) parents active lookup)))

(defpass letrec-nodes (compiler nodes state)
  "Find letrec constructs in a list of NODES"
  :cat '("categorise")
  (visit-nodes nodes 1 nil (.> state :rec-lookup)))

(defpass letrec-node (compiler node state)
  "Find letrec constructs in a node"
  :cat '("categorise")
  (visit-node node nil nil (.> state :rec-lookup)))
