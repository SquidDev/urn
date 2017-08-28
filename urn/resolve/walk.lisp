"This is the main variable resolver for Urn expressions. This binds
 symbols to the corresponding variable, resolves macros and top level
 unquotes, and ensures that the program is well formed.

 This does not handle importing modules or executing state: we yield to
 the top level compiler loop in order to handle that."

(import lua/basic (type#))
(import lua/coroutine co)

(import urn/range range)
(import urn/resolve/builtins (builtins))
(import urn/resolve/error error)
(import urn/resolve/scope scope)
(import urn/resolve/state state)
(import urn/traceback traceback)

(defun error-positions! (log node message)
  "Fail resolution at NODE with the given MESSAGE."
  :hidden
  (error/do-node-error! log
    message node nil
    (range/get-source node) ""))

(defun expect-type! (log node parent type name)
  "Expect NODE to have the given TYPE."
  :hidden
  (when (or (not node) (/= (.> node :tag) type))
    (error-positions! log (or node parent)
      (.. "Expected " (or name type) ", got " (if node (.> node :tag) "nothing")))))

(defun expect! (log node parent name)
  "Expect NODE to exist."
  :hidden
  (unless node
    (error-positions! log parent (.. "Expected " name ", got nothing"))))

(defun max-length! (log node len name)
  "Assert NODE has at most LEN elements."
  :hidden
  (when (> (n node) len)
    (error-positions! log (nth node (succ len)) (.. "Unexpected node in '" name '"' (expected " len " values, got " (n node) ")"))))

(defun error-internal! (log node message)
  "Throw an internal compiler error."
  :hidden
  (error-positions! log node (.. "[Internal]" message)))

(defun handle-metadata (log node var start finish)
  "Reads metadata from NODE, annoting the given variabl VAR."
  :hidden
  (with (i start)
    (while (<= i finish)
      (with (child (nth node i))
        (case (type child)
          ["nil" (expect! log child node "variable metadata")]
          ["string"
           (when (.> var :doc) (error-positions! log child "Multiple doc strings in definition"))
           (.<! var :doc (.> child :value))]
          ["key"
           (case (.> child :value)
             ["hidden" (.<! var :scope :exported (.> var :name) nil)]
             ["deprecated"
              (with (message true)
                (when (and (< i finish) (string? (nth node (succ i))))
                  (set! message (.> (nth node (succ i)) :value))
                  (inc! i))
                (.<! var :deprecated message))]
             [_ (error-positions! log child (.. "Unexpected modifier '" (pretty child) "'"))])]
          [?ty (error-positions! log child (.. "Unexpected node of type " ty ", have you got too many values"))]))

      (inc! i))))

(defun resolve-execute-result (owner node parent scope state)
  "Resolve the result of a macro or unquote, binding the parent node and
   marking the macro which generated it.

   Also will correctly re-associate syntax-quoted variables with their
   original definition."
  :hidden
  (case (type# node)
    ["string" (set! node { :tag "string" :value node })]
    ["number" (set! node { :tag "number" :value node })]
    ["boolean" (set! node { :tag "symbol"
                            :contents (tostring node)
                            :var (.> builtins node) })]
    ["table"
     (with (tag (.> node :tag))
       (if (or (= tag "symbol") (= tag "string") (= tag "number") (= tag "key") (= tag "list"))
         (with (copy {})
           ;; We've got a valid node. We'll copy it in order to avoid
           ;; having the same node appearing in multiple macro expansions.
           (for-pairs (k v) node (.<! copy k v))
           (set! node copy))
         (error-positions! (.> state :logger) parent (.. "Invalid node of type " (type node) " from " (state/name owner)))))]
    [_ (error-positions! (.> state :logger) parent (.. "Invalid node of type " (type node) " from " (state/name owner)))])

  (unless (or (.> node :range) (.> node :parent))
    (.<! node :owner owner)
    (.<! node :parent parent))

  (case (type node)
    ["list"
     (for i 1 (n node) 1
       (.<! node i (resolve-execute-result owner (nth node i) node scope state)))]
    ["symbol"
     (when (string? (.> node :var))
       (with (var (.> state :compiler :variables (.> node :var)))
         (unless var
           (error-positions! (.> state :logger) node (.. "Invalid variable key " (string/quoted (.> node :var)) " for " (pretty node))))
         (.<! node :var var)))]
    [_])

  node)

(defun resolve-quote (node scope state level)
  "Resolve a `syntax-quote`d NODE in the given SCOPE and STATE.

   LEVEL signifies the nesting depth: with level 0 being a normal
   expression and 1 being a single `syntax-quote`."
  :hidden
  (if (= level 0)
    (resolve-node node scope state)
    (case (type node)
      ["string" node]
      ["number" node]
      ["key" node]
      ["symbol"
       (unless (.> node :var)
         (.<! node :var (scope/get-always! scope (.> node :contents) node))

         ;; TODO: Allow syntax-quoting symbols in parent scope when unquoting.
         (unless (or (.> node :var :scope :is-root) (.> node :var :scope :builtin))
           (error-positions! (.> state :logger) node (.. "Cannot use non-top level definition '" (.> node :var :name) "' in syntax-quote"))))

       node]
      ["list"
       (when-with (first (car node))
         (.<! node 1 (resolve-quote first scope state level))

         (when (symbol? first)
           (cond
             [(= (.> first :var) (.> builtins :unquote)) (dec! level)]
             [(= (.> first :var) (.> builtins :unquote-splice)) (dec! level)]
             [(= (.> first :var) (.> builtins :syntax-quote)) (inc! level)]
             [true])))

       (for i 2 (n node) 1
         (.<! node i (resolve-quote (nth node i) scope state level)))

       node])))

(defun resolve-node (node scope state root many)
  "Resolve a normal NODE in the given SCOPE and STATE.

   ROOT will be `true` if this expression is at the top-level (and so
   accepts `define`, `define-native` and `define-macro`. MANY will be
   `true` if this node is in a context where multiple values can be
   spliced (so `lambda` and `cond` bodies)."
  (case (type node)
    ["number" node]
    ["string" node]
    ["key" node]
    ["symbol"
     (unless (.> node :var)
       (.<! node :var (scope/get-always! scope (.> node :contents) node)))

     ;; Builtin values aren't actually variables, so it doesn't make sense to use these
     ;; in raw expressions.
     (when (= (.> node :var :tag) "builtin")
       (error-positions! (.> state :logger) node "Cannot have a raw builtin."))

     (state/require! state (.> node :var) node)
     node]
    ["list"
     (with (first (car node))
       (case (type first)
         ["symbol"
          ;; First we want to resolve the node
          (unless (.> first :var)
            (.<! first :var (scope/get-always! scope (.> first :contents) first)))

          (let* [(func (.> first :var))
                 (func-state (state/require! state func first))]
            (case (.> func :tag)
              ["builtin"
               (cond
                 [(= func (.> builtins :lambda))
                  (expect-type! (.> state :logger) (nth node 2) node "list" "argument list")

                  (let [(child-scope (scope/child scope))
                        (args (nth node 2))
                        (has-variadic false)]

                    ;; Walk the argument list, verifying they are all symbols, declaring their arguments, etc...
                    (for i 1 (n args) 1
                      (expect-type! (.> state :logger) (nth args i) args "symbol" "argument")
                      (let* [(arg (nth args i))
                             (name (.> arg :contents))
                             (is-var (= (string/char-at name 1) "&"))]
                        (when is-var
                          (cond
                            [has-variadic (error-positions! (.> state :logger) args "Cannot have multiple variadic arguments")]
                            [(= (n name) 1)
                             ;; We've just got a "&". This doesn't make sense so we'll error.
                             (error-positions! (.> state :logger) arg
                               (if (< i (n args))
                                 (with (next-arg (nth args (succ i)))
                                   (if (and (symbol? args) (/= (string/char-at (.> next-arg :contents) 1) "&"))
                                     (.. "\nDid you mean '&" (.> next-arg :contents) "'?")
                                     ""))
                                 ""))]
                            [true
                             (set! name (string/sub name 2))
                             (set! has-variadic true)]))

                        (with (var (scope/add-verbose! child-scope name "arg" arg (.> state :logger)))
                          (.<! var :display-name (.> arg :display-name))
                          (.<! arg :var var)
                          (.<! var :is-variadic is-var))))

                    (resolve-block node 3 child-scope state))]

                 [(= func (.> builtins :cond))
                  (for i 2 (n node) 1
                    (with (case (nth node i))
                      (expect-type! (.> state :logger) case node "list" "case expression")
                      (expect! (.> state :logger) (car case) case "condition")

                      (.<! case 1 (resolve-node (car case) scope state))
                      (resolve-block case 2 scope state)))

                  node]

                 [(= func (.> builtins :set!))
                  (expect-type! (.> state :logger) (nth node 2) node "symbol")
                  (expect!      (.> state :logger) (nth node 3) node "value")
                  (max-length!  (.> state :logger) node 3 "set!")

                  (with (var (scope/get-always! scope (.> (nth node 2) :contents) (nth node 2)))
                    (state/require! state var (nth node 2))
                    (.<! node 2 :var var)

                    (when (.> var :const)
                      (error-positions! (.> state :logger) node (.. "Cannot rebind constant " (.> var :name)))))

                  (.<! node 3 (resolve-node (nth node 3) scope state))
                  node]

                 [(= func (.> builtins :quote))
                  (expect!     (.> state :logger) (nth node 2) node "value")
                  (max-length! (.> state :logger) node 2 "quote")

                  node]

                 [(= func (.> builtins :syntax-quote))
                  (expect!     (.> state :logger) (nth node 2) node "value")
                  (max-length! (.> state :logger) node 2 "syntax-quote")

                  (.<! node 2 (resolve-quote (nth node 2) scope state 1))
                  node]

                 [(= func (.> builtins :unquote))
                  (expect! (.> state :logger) (nth node 2) node "value")

                  (let [(result '())
                        (states '())]

                    (for i 2 (n node) 1
                      (let* [(child-state (state/create scope (.> state :compiler)))
                             (built (resolve-node (nth node i) scope child-state))]

                        ;; We wrap the child state in a lambda so we can assign errors to a specific
                        ;; node.
                        (state/built! child-state
                          { :tag "list" :n 3
                            :range (.> built :range) :owner (.> built :owner) :parent node
                            1 { :tag "symbol" :contents "lambda" :var (.> builtins :lambda) }
                            2 '()
                            3 built })

                        (with (func (state/get! child-state))
                          ;; Setup the compiler state before executing.
                          (.<! state :compiler :active-scope scope)
                          (.<! state :compiler :active-node  built)

                          (case (list (xpcall func traceback/traceback))
                            [(false ?msg)
                             (error-positions! (.> state :logger) node (traceback/remap-traceback (.> state :mappings) msg))]
                            [(true . ?replacement)
                             (cond
                               [(= i (n node))
                                (for-each child replacement
                                  (push-cdr! result child)
                                  (push-cdr! states child-state))]
                               [(= (n replacement) 1)
                                (push-cdr! result (car replacement))
                                (push-cdr! states child-state)]
                               [true (error-positions! (.> state :logger) (nth node i) (.. "Expected one value, got " (n replacement)))])]))))

                    (when (or (= (n result) 0) (and (= (n result) 1) (= (car result) nil)))
                      (set! result (list { :tag "symbol"
                                           :contents "nil"
                                           :var (.> builtins :nil) })))

                    (for i 1 (n result) 1
                      (.<! result i (resolve-execute-result (nth states i) (nth result i) node scope state)))

                    (cond
                      [(= (n result) 1) (resolve-node (car result) scope state root many)]
                      [many
                       (.<! result :tag "many")
                       result]
                      [true
                       (error-positions! (.> state :logger) node "Multiple values returned in a non block context")]))]
                 [(= func (.> builtins :unquote-splice))
                  (max-length! (.> state :logger) node 2 "unquote-splice")

                  (let* [(child-state (state/create scope (.> state :compiler)))
                         (built (resolve-node (nth node 2) scope child-state))]

                    ;; We wrap the node in a lambda in order to correctly associate
                    ;; any errors with this node.
                    (state/built! child-state
                      { :tag "list" :n 3
                        :range (.> built :range) :owner (.> built :owner) :parent node
                        1 { :tag "symbol" :contents "lambda" :var (.> builtins :lambda) }
                        2 '()
                        3 built })

                    (with (func (state/get! child-state))
                      ;; Setup the compiler state before executing.
                      (.<! state :compiler :active-scope scope)
                      (.<! state :compiler :active-node  built)

                      (case (list (xpcall func traceback/traceback))
                        [(false ?msg)
                         (error-positions! (.> state :logger) node (traceback/remap-traceback (.> state :mappings) msg))]
                        [(true . ?replacement)
                         (with (result (car replacement))
                           (unless (list? result)
                             (error-positions! (.> state :logger) node (.. "Expected list from unquote-splice, got '" (type result) "'")))

                           (when (= (n result) 0)
                             (set! result (list { :tag "symbol"
                                                  :contents "nil"
                                                  :var (.> builtins :nil) })))

                           (for i 1 (n result) 1
                             (.<! result i (resolve-execute-result child-state (nth result i) node scope state)))

                           (cond
                             [(= (n result) 1)
                              (resolve-node (car result) scope state root many)]
                             [many
                              (.<! result :tag "many")
                              result]
                             [true
                              (error-positions! (.> state :logger) node "Multiple values returned in a non-block context")]))])))]

                 [(= func (.> builtins :define))
                  (unless root
                    (error-positions! (.> state :logger) first "define can only be used on the top level"))
                  (expect-type! (.> state :logger) (nth node 2) node "symbol" "name")
                  (expect!      (.> state :logger) (nth node 3) node "value")

                  (with (var (scope/add-verbose! scope (.> (nth node 2) :contents) "defined" node (.> state :logger)))
                    (.<! var :display-name (.> (nth node 2) :display-name))
                    (state/define! state var)
                    (.<! node :def-var var)

                    (handle-metadata (.> state :logger) node var 3 (pred (n node)))
                    (.<! node (n node) (resolve-node (nth node (n node)) scope state))
                    node)]

                 [(= func (.> builtins :define-macro))
                  (unless root
                    (error-positions! (.> state :logger) first "define-macro can only be used on the top level"))
                  (expect-type! (.> state :logger) (nth node 2) node "symbol" "name")
                  (expect!      (.> state :logger) (nth node 3) node "value")

                  (with (var (scope/add-verbose! scope (.> (nth node 2) :contents) "macro" node (.> state :logger)))
                    (.<! var :display-name (.> (nth node 2) :display-name))
                    (state/define! state var)
                    (.<! node :def-var var)

                    (handle-metadata (.> state :logger) node var 3 (pred (n node)))
                    (.<! node (n node) (resolve-node (nth node (n node)) scope state))
                    node)]

                 [(= func (.> builtins :define-native))
                  (unless root
                    (error-positions! (.> state :logger) first "define-native can only be used on the top level"))

                  (expect-type! (.> state :logger) (nth node 2) node "symbol" "name")
                  (with (var (scope/add-verbose! scope (.> (nth node 2) :contents) "native" node (.> state :logger)))
                    (.<! var :display-name (.> (nth node 2) :display-name))
                    (state/define! state var)
                    (.<! node :def-var var)

                    (handle-metadata (.> state :logger) node var 3 (n node))
                    node)]

                 [(= func (.> builtins :import))
                  (expect-type! (.> state :logger) (nth node 2) node "symbol" "module name")

                  (let [(as nil)
                        (symbols nil)
                        (export-idx nil)
                        (qualifier (nth node 3))]
                    (case (type qualifier)
                      ["symbol"
                       ;; (import x y)/(import x y :hidden)
                       (set! export-idx 4)

                       (set! as (.> qualifier :contents))
                       (set! symbols nil)]
                      ["list"
                       ;; (import x (y))/(import x (y) :hidden)
                       (set! export-idx 4)

                       (set! as nil)
                       (if (= (n qualifier) 0)
                         (set! symbols nil)
                         (progn
                           (set! symbols {})
                           (for-each entry qualifier
                             (expect-type! (.> state :logger) entry qualifier "symbol")
                             (.<! symbols (.> entry :contents) entry))))]
                      ["nil"
                       ;; (import x)
                       (set! export-idx 3)

                       (set! as (.> (nth node 2) :contents))
                       (set! symbols nil)]
                      ["key"
                       ;; (import x :export)
                       (set! export-idx 3)

                       (set! as (.> (nth node 2) :contents))
                       (set! symbols nil)]
                      [_ (expect-type! (.> state :logger) (nth node 3) node "symbol" "alias name of import list")])


                    (max-length! (.> state :logger) node export-idx "import")
                    (co/yield { :tag     "import"
                                :module  (.> (nth node 2) :contents)
                                :as      as
                                :symbols symbols
                                :export  (with (export (nth node export-idx))
                                           (and export (progn
                                                         (expect-type! (.> state :logger) export node "key" "import modifier")
                                                         (case (.> export :value)
                                                           ["export" true]
                                                           [_ (error-positions! (.> state :logger) export "unknown import modifier")]))))
                                :scope   scope })
                    node)]

                 [(= func (.> builtins :struct-literal))
                  (when (/= (% (n node) 2) 1)
                    (error-positions! (.> state :logger) node (.. "Expected an even number of arguments, got " (pred (n node)))))
                  (resolve-list node 2 scope state)]

                 [true
                  (error-internal! (.> state :logger) node (.. "Unknown builtin " (if func (.> func :name) "?")))])]

              ["macro"
               (unless func-state (error-internal! (.> state :logger) first "Macro is not defined correctly"))

               (with (builder (state/get! func-state))
                 (when (/= (type builder) "function")
                   (error-positions! (.> state :logger) first (.. "Macro is of type " (type builder))))

                 ;; Set up the active scope and node
                 (.<! state :compiler :active-scope scope)
                 (.<! state :compiler :active-node  node)

                 ;; Execute the macro
                 (case (list (xpcall (lambda () (builder (unpack node 2 (n node)))) traceback/traceback))
                   ;; The macro failed so remap the traceback and error
                   [(false ?msg)
                    (error-positions! (.> state :logger) first (traceback/remap-traceback (.> state :mappings) msg))]

                   ;; The macro worked, we'll gather the output and continue.
                   [(true . ?replacement)
                    (for i 1 (n replacement) 1
                      (.<! replacement i (resolve-execute-result func-state (nth replacement i) node scope state)))

                    (cond
                      [(= (n replacement) 0)
                       (error-positions! (.> state :logger) node (.. "Expected some value from " (state/name func-state) ", got nothing"))]
                      [(= (n replacement) 1) (resolve-node (car replacement) scope state root many)]
                      [many
                       (.<! replacement :tag "many")
                       replacement]
                      [true
                       (error-positions! (.> state :logger) node "Multiple values returned in a non-block context.")])]))]


              ;; We're defined/arg/native so just resolve as normal
              [_ (resolve-list node 1 scope state)]))]
         ["list"
          (resolve-list node 1 scope state)]
         [?ty (error-positions! (.> state :logger) (or first node) (.. "Cannot invoke a non-function type '" ty "'"))]))]))

(defun resolve-list (nodes start scope state)
  "Resolve NODES in the given SCOPE and STATE, starting from START"
  :hidden
  (for i start (n nodes) 1
    (.<! nodes i (resolve-node (nth nodes i) scope state)))
  nodes)

(defun resolve-block (nodes start scope state)
  "Resolve NODES in the given SCOPE and STATE, starting from START.

   Unlike [[resolve-list]], this accepts multiple values being returned
   from [[resolve-node]]."
  :hidden
  (let [(len (n nodes))
        (i start)]
    (while (<= i len)
      (with (node (resolve-node (nth nodes i) scope state false true))
        (if (= (.> node :tag) "many")
          (progn
            (.<! nodes i (nth node 1))
            (for j 2 (n node) 1
              (insert-nth! nodes (+ i (pred j)) (nth node j)))

            (set! len (+ len (pred (n node)))))
          (progn
            (.<! nodes i node)
            (inc! i))))))

  nodes)

(defun resolve (node scope state)
  "Resolve NODE with SCOPE and STATE, attempting to simplify items
   with a `many` tag."
  (set! node (resolve-node node scope state true true))
  (while (and (= (.> node :tag) "many") (= (n node) 1))
    (set! node (resolve-node (car node) scope state true true)))
  node)
