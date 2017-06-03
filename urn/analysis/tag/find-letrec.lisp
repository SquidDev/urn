(import urn/analysis/nodes ())
(import urn/analysis/pass ())

(defun visit-quote (node level lookup)
  "Visit a `syntax-quote`d NODE at the given LEVEL - where 1 is a single level of nesting,
   and 0 a normal node."
  :hidden
  (if (= level 0)
    (visit-node node nil lookup)
    (with (tag (.> node :tag))
      (cond
        [(or (= tag "string") (= tag "number") (= tag "key") (= tag "symbol"))]
        [(= tag "list")
         (with (first (nth node 1))
           (if (and first (= (.> first :tag) "symbol"))
             (cond
               [(or (= (.> first :contents) "unquote") (= (.> first :contents) "unquote-splice"))
                (visit-quote (nth node 2) (pred level) lookup)]
               [(= (.> first :contents) "syntax-quote")
                (visit-quote (nth node 2) (succ level) lookup)]
               [true
                 (for-each sub node (visit-quote sub level lookup))])
             (for-each sub node (visit-quote sub level lookup))))]
        (error! (.. "Unknown tag " tag))))))

(defun visit-node (node active lookup)
  "VISIT NODE with the current LOOKUP state and variables.

   LOOKUP is a mapping of variables to a struct with the following keys:

   - `:mode` The mode this is currently in. Is the name of one of the
     'counter' fields:

   - `:recur` Counts how often this variable is used in a tail recursive
     context.

   - `:inside` Counts how often this variable is used inside itself as a
     non-tail recursive function.

   - `:outside` Counts how often variable is used outside its definition.

   - `:lambda` The actual lambda this variable corresponds to.

   If we finish visiting a lambda without the `:recur` flag being set, or
   if the definition is ever rebound, then we remove it from
   LOOKUP."
  :hidden
  (case (type node)
    ["string"]
    ["number"]
    ["key"]
    ["symbol"
     ;; If we're in a "recur" context then we should add it to the
     ;; "inside" counter instead.
     (when-with (state (.> lookup (.> node :var)))
       (case (.> state :mode)
         ["inside"  (inc! (.> state :inside))]
         ["outside" (inc! (.> state :outside))]))]

    ["list"
     (with (head (car node))
       (case (type head)
         ["symbol"
          (let* [(func (.> head :var))
                 (funct (.> func :tag))]
            (cond
              ;; Just a bog-standard call.
              [(/= (.> func :tag) "builtin")
               ;; If we're calling the active variable then increment the recursive variable,
               ;; otherwise we visit it normally.
               (if (and (/= active nil) (= active (.> lookup func)))
                 (inc! (.> active :recur))
                 (visit-node (car node) nil lookup))

               ;; And visit the remaining arguments.
               (visit-nodes node 2 lookup)]

              ;; While we're technically visiting a block, we don't want to preserve the
              ;; recursive state.
              [(= func (.> builtins :lambda)) (visit-block node 3 nil lookup)]

              [(= func (.> builtins :set!))
               (let* [(var (.> (nth node 2) :var))
                      (state (.> lookup var))
                      (val (nth node 3))]
                 (when state
                   ;; We attempt to determine whether this set! invalidates a letrec candidate or
                   ;; forms one.
                   ;; TODO: We should ensure the set! occurs before any formal usage and that
                   ;; it isn't inside another lambda. Otherwise this optimisation could be invalid.
                   (cond
                     [(/= (.> state :lambda) nil)
                      ;; If we've already got a function then clear it!
                      (.<! lookup var nil)
                      (visit-node val nil lookup)]
                     [(and (list? val) (builtin? (car val) :lambda)) (.<! state :lambda val)
                      ;; If it's a lambda then set the lambda variable
                      (.<! state :mode "inside")
                      (visit-block val 3 state lookup)
                      (.<! state :mode "outside")]
                     [true
                      ;; Otherwise clear everything.
                      (.<! lookup var nil)
                      (visit-node val nil lookup)])))]

              ;; Now it's just all the standard visitor methods
              [(= func (.> builtins :cond))
               (for i 2 (n node) 1
                 (with (case (nth node i))
                   (visit-node (car case) nil lookup)
                   (visit-block case 2 active lookup)))]
              [(= func (.> builtins :quote))]
              [(= func (.> builtins :syntax-quote)) (visit-quote (nth node 2) 1 lookup)]
              [(or (= func (.> builtins :unquote)) (= func (.> builtins :unquote-splice)))
               (fail! "unquote/unquote-splice should never appear here")]
              [(or (= func (.> builtins :define)) (= func (.> builtins :define-macro)))
               (visit-node (nth node (n node)) nil lookup)]
              [(= func (.> builtins :define-native))] ;; Nothing needs doing here
              [(= func (.> builtins :import))] ;; Nothing needs doing here
              [(= func (.> builtins :struct-literal)) (visit-nodes node 2 lookup)]
              [true (fail! (.. "Unknown builtin for variable " (.> func :name)))]))]
         ["list"
          (with (first (car node))
            (if (and (list? first) (builtin? (car first) :lambda))
              ;; If we're a directly called lambda then we can preserve the "active" state.
              (progn
                ;; We loop over each argument with no value (either nil or empty) and push it to the
                ;; recursion tracker.
                (with (args (nth first 2))
                  (for i 1 (n args) 1
                    (with (val (nth node (succ i)))
                      (when (or (= val nil) (builtin? val :nil))
                        (.<! lookup (.> (nth args i) :var) { :mode    "outside"
                                                             :recur   0
                                                             :inside  0
                                                             :outside 0
                                                             :lambda  nil })))))

                (visit-block node 1 active lookup))

              ;; Otherwise we just visit this normally.
              (visit-nodes node 1 lookup)))]
         [_ (visit-nodes node 1 lookup)]))]))

(defun visit-nodes (node start lookup)
  "Visit NODE starting from START."
  :hidden
  (for i start (n node) 1
    (visit-node (nth node i) nil lookup)))

(defun visit-block (node start active lookup)
  "Visit NODE starting from START, with the last element being visited in
   a tail recursive context."
  :hidden
  (for i start (pred (n node)) 1
    (visit-node (nth node i) nil lookup))

  (when (>= (n node) start)
    (visit-node (last node) active lookup)))

(defpass letrec-nodes (compiler nodes state)
  "Find letrec constructs in a list of NODES"
  :cat '("categorise")
  (visit-nodes nodes 1 (.> state :rec-lookup)))

(defpass letrec-node (compiler node state stmt)
  "Find letrec constructs in a node"
  :cat '("categorise")
  (visit-node node nil (.> state :rec-lookup)))
