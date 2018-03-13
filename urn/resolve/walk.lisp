"This is the main variable resolver for Urn expressions. This binds
 symbols to the corresponding variable, resolves macros and top level
 unquotes, and ensures that the program is well formed.

 This does not handle importing modules or executing state: we yield to
 the top level compiler loop in order to handle that."

(import lua/basic (type#))
(import lua/coroutine co)

(import urn/error error)
(import urn/library ())
(import urn/logger/format format)
(import urn/range range)
(import urn/resolve/builtins (builtin))
(import urn/resolve/native native)
(import urn/resolve/scope scope)
(import urn/resolve/state state)
(import urn/traceback traceback)

(defun error-positions! (log node message extra)
  "Fail resolution at NODE with the given MESSAGE."
  :hidden
  (error/do-node-error! log
    message (range/get-top-source node) extra
    (range/get-source node) ""))

(defun expect-type! (log node parent expected-type name)
  "Expect NODE to have the given EXPECTED-TYPE."
  :hidden
  (when (/= (type node) expected-type)
    (error-positions! log (or node parent)
      (.. "Expected " (or name expected-type) ", got " (if node (type node) "nothing")))))

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
           (when (scope/var-doc var) (error-positions! log child "Multiple doc strings in definition"))
           (scope/set-var-doc! var (.> child :value))]
          ["key"
           (case (.> child :value)
             ["hidden" (.<! (scope/scope-exported (scope/var-scope var)) (scope/var-name var) nil)]

             ["deprecated"
              (when (scope/var-deprecated var)
                (error-positions! log child "This definition is already deprecated"))

              (with (message true)
                (when (and (< i finish) (string? (nth node (succ i))))
                  (set! message (.> (nth node (succ i)) :value))
                  (inc! i))
                (scope/set-var-deprecated! var message))]

             ["mutable"
              (when (/= (scope/var-kind var) "defined")
                (error-positions! log child "Can only set conventional definitions as mutable"))
              (unless (scope/var-const? var)
                (error-positions! log child "This definition is already mutable"))

              (scope/set-var-const! var false)]

             ["intrinsic"
              (expect-type! log (nth node (succ i)) node "symbol" "intrinsic")
              (when (scope/var-intrinsic var)
                (error-positions! log child "Multiple intrinsics set"))

              (scope/set-var-intrinsic! var (.> (nth node (succ i)) :contents))
              (inc! i)]

             ["pure"
              (when (/= (scope/var-kind var) "native")
                (error-positions! log child "Can only set native definitions as pure"))

              (with (native (scope/var-native var))
                (when (native/native-pure? native)
                  (error-positions! log child "This definition is already pure"))

                (native/set-native-pure! native true))]

             ["signature"
              (when (/= (scope/var-kind var) "native")
                (error-positions! log child "Can only set signature for native definitions"))

              (let [(native (scope/var-native var))
                    (signature (nth node (succ i)))]
                (expect-type! log signature node "list" "signature")
                (for-each child signature (expect-type! log child signature "symbol" "argument"))
                (when (native/native-signature native)
                  (error-positions! log child "multiple signatures set"))
                (native/set-native-signature! native signature)

                (inc! i))]

             ["bind-to"
              (when (/= (scope/var-kind var) "native")
                (error-positions! log child "Can only bind native definitions"))

              (with (native (scope/var-native var))
                (expect-type! log (nth node (succ i)) node "string" "bind expression")
                (when (native/native-bind-to native)
                  (error-positions! log child "Multiple bind expressions set"))

                (native/set-native-bind-to! native (.> (nth node (succ i)) :value))
                (inc! i))]

             ["syntax"
              (when (/= (scope/var-kind var) "native")
                (error-positions! log child "Can only set syntax for native definitions"))

              (let* [(native (scope/var-native var))
                     (syntax (nth node (succ i)))]
                (expect! log syntax node "syntax")
                (when (native/native-syntax native)
                  (error-positions! log child "Multiple syntaxes set"))

                (case (type syntax)
                  ["string"
                   (with ((syn arity) (native/parse-template (.> syntax :value)))
                     (native/set-native-syntax! native syn)
                     (native/set-native-syntax-arity! native arity))]

                  ["list"
                   ;; Ensure the syntax isn't empty
                   (expect! log (car syntax) syntax "syntax element")

                   (let [(syn '())
                         (arity 0)]
                     ;; Gobble list elements, verifying they are valid
                     (for-each child syntax
                       (case (type child)
                         ["string" (push! syn (.> child :value))]
                         ["number"
                          (with (val (.> child :value))
                            (when (> val arity) (set! arity val))
                            (push! syn val))]
                         [?ty
                          (error-positions! log child (format nil "Expected syntax element, got {}" (if (= ty "nil") "nothing" ty)))]))

                     (native/set-native-syntax! native syn)
                     (native/set-native-syntax-arity! native arity))]

                  [?ty
                   (error-positions! log child (format nil "Expected syntax, got {}" (if (= ty "nil") "nothing" ty)))])

                (inc! i))]

             ["stmt"
              (when (/= (scope/var-kind var) "native")
                (error-positions! log child "Can only set native definitions as statements"))

              (with (native (scope/var-native var))
                (when (native/native-syntax-stmt? native)
                  (error-positions! log child "This definition is already a statement"))

                (native/set-native-syntax-stmt! native true))]

             ["syntax-precedence"
              (when (/= (scope/var-kind var) "native")
                (error-positions! log child "Can only set syntax of native definitions"))

              (let [(native (scope/var-native var))
                    (precedence (nth node (succ i)))]
                (when (native/native-syntax-precedence native)
                  (error-positions! log child "Multiple precedences set"))

                (case (type precedence)
                  ["number" (native/set-native-syntax-precedence! native (.> precedence :value))]

                  ["list"
                   (with (res '())
                     (for-each prec precedence
                       (expect-type! log prec precedence "number" "precedence")
                       (push! res (.> prec :value)))

                     (native/set-native-syntax-precedence! native res))]

                  [?ty
                   (error-positions! log child (format nil "Expected precedence, got {}" (if (= ty "nil") "nothing" ty)))])

                (inc! i))]

             ["syntax-fold"
              (when (/= (scope/var-kind var) "native")
                (error-positions! log child "Can only set syntax of native definitions"))

              (with (native (scope/var-native var))
                (expect-type! log (nth node (succ i)) node "string" "fold direction")
                (when (native/native-syntax-fold native)
                  (error-positions! log child "Multiple fold directions set"))

                (case (.> (nth node (succ i)) :value)
                  ["left"  (native/set-native-syntax-fold! native "left")]
                  ["right" (native/set-native-syntax-fold! native "right")]
                  [?str    (error-positions! log (nth node (succ i)) (format nil "Unknown fold direction {#str:string/quoted}"))])
                (inc! i))]

             [_ (error-positions! log child (.. "Unexpected modifier '" (pretty child) "'"))])]
          [?ty (error-positions! log child (.. "Unexpected modifier of type " ty ", have you got too many values?"))]))

      (inc! i)))

  (when (= (scope/var-kind var) "native")
    (with (native (scope/var-native var))
      (when (and (native/native-syntax native) (native/native-bind-to native))
        (error-positions! log node "Cannot specify :syntax and :bind-to in native definition"))

      ;; Verify syntax specific fields are not set
      (when (and (native/native-syntax-fold native) (not (native/native-syntax native)))
        (error-positions! log node "Cannot specify a fold direction when no syntax given"))
      (when (and (native/native-syntax-stmt? native) (not (native/native-syntax native)))
        (error-positions! log node "Cannot have a statement when no syntax given"))
      (when (and (native/native-syntax-precedence native) (not (native/native-syntax native)))
        (error-positions! log node "Cannot specify a precedence when no syntax given"))

      (when-with (syntax (native/native-syntax native))
        (let* [(syntax-arity (native/native-syntax-arity native))

               (signature (native/native-signature native))
               (signature-arity (if (list? signature) (n signature) nil))

               (precedence (native/native-syntax-precedence native))
               (prec-arity (if (list? precedence) (n precedence) nil))]

          ;; Verify signature arity is consistent
          (when (and signature-arity (/= signature-arity syntax-arity))
            (error-positions! log node (format nil "Definition has arity {#syntax-arity}, but signature has {#signature-arity} arguments")))

          ;; Verify precedence arity is consistent
          (when (and prec-arity (/= prec-arity syntax-arity))
            (error-positions! log node (format nil "Definition has arity {#syntax-arity}, but precedence has {#prec-arity} values")))

          ;; Verify folds take 2 arguments
          (when (and (native/native-syntax-fold native) (/= syntax-arity 2))
            (error-positions! log node (format nil "Cannot specify a fold direction with arity {#syntax-arity} (must be 2)")))))))

  nil)

(defun resolve-execute-result (source node scope state)
  "Resolve the result of a macro or unquote, binding the range and
   generating macro.

   Also will correctly re-associate syntax-quoted variables with their
   original definition."
  :hidden
  (case (type# node)
    ["string" (set! node { :tag "string" :value node })]
    ["number" (set! node { :tag "number" :value node })]
    ["boolean" (set! node { :tag "symbol"
                            :contents (tostring node)
                            :var (builtin (bool->string node)) })]
    ["table"
     (with (tag (type node))
       (if (or (= tag "symbol") (= tag "string") (= tag "number") (= tag "key") (= tag "list"))
         (with (copy {})
           ;; We've got a valid node. We'll copy it in order to avoid
           ;; having the same node appearing in multiple macro expansions.
           (for-pairs (k v) node (.<! copy k v))
           (set! node copy))
         (error/do-node-error! (state/rs-logger state)
           (format nil "Invalid node of type {} from {}"
             (type node)
             (format/format-node-source-name source))
           source nil
           (range/source-range source) "")))]
    [_ (error/do-node-error! (state/rs-logger state)
         (format nil "Invalid node of type {} from {}"
           (type node)
           (format/format-node-source-name source))
         source nil
         (range/source-range source) "")])

  (unless (.> node :source) (.<! node :source source))

  (case (type node)
    ["list"
     (for i 1 (n node) 1
       (.<! node i (resolve-execute-result source (nth node i) scope state)))]
    ["symbol"
     (when (string? (.> node :var))
       (with (var (.> state :compiler :variables (.> node :var)))
         (unless var
           (error-positions! (state/rs-logger state) node (.. "Invalid variable key " (string/quoted (.> node :var)) " for " (pretty node))))
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
         (.<! node :var (scope/lookup-always! scope (.> node :contents) node))

         ;; TODO: Allow syntax-quoting symbols in parent scope when unquoting.
         (unless (or (scope/scope-top-level? (scope/var-scope (.> node :var)))
                     (scope/scope-builtin?  (scope/var-scope (.> node :var))))
           (error-positions! (state/rs-logger state) node (.. "Cannot use non-top level definition '" (scope/var-name (.> node :var)) "' in syntax-quote"))))

       node]
      ["list"
       (when-with (first (car node))
         (.<! node 1 (resolve-quote first scope state level))

         (when (symbol? first)
           (cond
             [(= (.> first :var) (builtin :unquote)) (dec! level)]
             [(= (.> first :var) (builtin :unquote-splice)) (dec! level)]
             [(= (.> first :var) (builtin :syntax-quote)) (inc! level)]
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
       (.<! node :var (scope/lookup-always! scope (.> node :contents) node)))

     ;; Builtin values aren't actually variables, so it doesn't make sense to use these
     ;; in raw expressions.
     (when (= (scope/var-kind (.> node :var)) "builtin")
       (error-positions! (state/rs-logger state) node "Cannot have a raw builtin."))

     (state/require! state (.> node :var) node)
     node]
    ["list"
     (with (first (car node))
       (case (type first)
         ["symbol"
          ;; First we want to resolve the node
          (unless (.> first :var)
            (.<! first :var (scope/lookup-always! scope (.> first :contents) first)))

          (let* [(func (.> first :var))
                 (func-state (state/require! state func first))]
            (case (scope/var-kind func)
              ["builtin"
               (cond
                 [(= func (builtin :lambda))
                  (expect-type! (state/rs-logger state) (nth node 2) node "list" "argument list")

                  (let [(child-scope (scope/child scope))
                        (args (nth node 2))
                        (has-variadic false)]

                    ;; Walk the argument list, verifying they are all symbols, declaring their arguments, etc...
                    (for i 1 (n args) 1
                      (expect-type! (state/rs-logger state) (nth args i) args "symbol" "argument")
                      (let* [(arg (nth args i))
                             (name (.> arg :contents))
                             (is-var (= (string/char-at name 1) "&"))]
                        (when is-var
                          (cond
                            [has-variadic (error-positions! (state/rs-logger state) args "Cannot have multiple variadic arguments")]
                            [(= (n name) 1)
                             ;; We've just got a "&". This doesn't make sense so we'll error.
                             (error-positions! (state/rs-logger state) arg
                               (string/format "Expected a symbol for variadic argument.%s"
                                 (if (< i (n args))
                                   (with (next-arg (nth args (succ i)))
                                     (if (and (symbol? next-arg) (/= (string/char-at (.> next-arg :contents) 1) "&"))
                                       (string/format "\nDid you mean '&%s'?" (.> next-arg :contents))
                                       ""))
                                   "")))]
                            [true
                             (set! name (string/sub name 2))
                             (set! has-variadic true)]))

                        (with (var (scope/add-verbose! child-scope name "arg" arg (state/rs-logger state)))
                          (scope/set-var-display-name! var (.> arg :display-name))
                          (scope/set-var-variadic! var is-var)
                          (.<! arg :var var))))

                    (resolve-block node 3 child-scope state))]

                 [(= func (builtin :cond))
                  (for i 2 (n node) 1
                    (with (case (nth node i))
                      (expect-type! (state/rs-logger state) case node "list" "case expression")
                      (expect! (state/rs-logger state) (car case) case "condition")

                      (.<! case 1 (resolve-node (car case) scope state))
                      (resolve-block case 2 scope state)))

                  node]

                 [(= func (builtin :set!))
                  (expect-type! (state/rs-logger state) (nth node 2) node "symbol")
                  (expect!      (state/rs-logger state) (nth node 3) node "value")
                  (max-length!  (state/rs-logger state) node 3 "set!")

                  (with (var (scope/lookup-always! scope (.> (nth node 2) :contents) (nth node 2)))
                    (state/require! state var (nth node 2))
                    (.<! node 2 :var var)

                    (when (scope/var-const? var)
                      (error-positions! (state/rs-logger state) node
                        (string/format "Cannot rebind immutable definition '%s'" (.> (nth node 2) :contents))
                        (string/format "Top level definitions are immutable by default. If you want
                                        to redefine '%s', add the `:mutable` modifier to its definition."
                                       (.> (nth node 2) :contents)))))

                  (.<! node 3 (resolve-node (nth node 3) scope state))
                  node]

                 [(= func (builtin :quote))
                  (expect!     (state/rs-logger state) (nth node 2) node "value")
                  (max-length! (state/rs-logger state) node 2 "quote")

                  node]

                 [(= func (builtin :syntax-quote))
                  (expect!     (state/rs-logger state) (nth node 2) node "value")
                  (max-length! (state/rs-logger state) node 2 "syntax-quote")

                  (.<! node 2 (resolve-quote (nth node 2) scope state 1))
                  node]

                 [(= func (builtin :unquote))
                  (expect! (state/rs-logger state) (nth node 2) node "value")

                  (let [(result '())
                        (states '())]

                    (for i 2 (n node) 1
                      (let* [(child-state (state/create scope (state/rs-compiler state)))
                             (built (resolve-node (nth node i) scope child-state))]

                        ;; We wrap the child state in a lambda so we can assign errors to a specific
                        ;; node.
                        (state/built! child-state
                          { :tag "list" :n 3
                            :source (.> built :source)
                            1 { :tag "symbol" :contents "lambda" :var (builtin :lambda) }
                            2 '()
                            3 built })

                        (with (func (state/get! child-state))
                          ;; Setup the compiler state before executing.
                          (.<! (state/rs-compiler state) :active-scope scope)
                          (.<! (state/rs-compiler state) :active-node  built)

                          (case (state/rs-exec state func)
                            [(false ?msg)
                             (error-positions! (state/rs-logger state) node (traceback/remap-traceback (state/rs-mappings state) msg))]
                            [(true . ?replacement)
                             (cond
                               [(= i (n node))
                                (for-each child replacement
                                  (push! result child)
                                  (push! states child-state))]
                               [(= (n replacement) 1)
                                (push! result (car replacement))
                                (push! states child-state)]
                               [true (error-positions! (state/rs-logger state) (nth node i) (.. "Expected one value, got " (n replacement)))])]))))

                    (when (or (= (n result) 0) (and (= (n result) 1) (= (car result) nil)))
                      (set! result (list { :tag "symbol"
                                           :contents "nil"
                                           :var (builtin :nil) })))

                    (with (source (range/mk-node-source nil (.> node :source) (range/get-source node)))
                      (for i 1 (n result) 1
                        (.<! result i (resolve-execute-result source (nth result i) scope state))))

                    (cond
                      [(= (n result) 1) (resolve-node (car result) scope state root many)]
                      [many
                       (.<! result :tag "many")
                       result]
                      [true
                       (error-positions! (state/rs-logger state) node "Multiple values returned in a non block context")]))]
                 [(= func (builtin :unquote-splice))
                  (max-length! (state/rs-logger state) node 2 "unquote-splice")

                  (let* [(child-state (state/create scope (state/rs-compiler state)))
                         (built (resolve-node (nth node 2) scope child-state))]

                    ;; We wrap the node in a lambda in order to correctly associate
                    ;; any errors with this node.
                    (state/built! child-state
                      { :tag "list" :n 3
                        :source (.> built :source)
                        1 { :tag "symbol" :contents "lambda" :var (builtin :lambda) }
                        2 '()
                        3 built })

                    (with (func (state/get! child-state))
                      ;; Setup the compiler state before executing.
                      (.<! (state/rs-compiler state) :active-scope scope)
                      (.<! (state/rs-compiler state) :active-node  built)

                      (case (state/rs-exec state func)
                        [(false ?msg)
                         (error-positions! (state/rs-logger state) node (traceback/remap-traceback (state/rs-mappings state) msg))]
                        [(true . ?replacement)
                         (with (result (car replacement))
                           (unless (list? result)
                             (error-positions! (state/rs-logger state) node (.. "Expected list from unquote-splice, got '" (type result) "'")))

                           (when (= (n result) 0)
                             (set! result (list { :tag "symbol"
                                                  :contents "nil"
                                                  :var (builtin :nil) })))

                           (with (source (range/mk-node-source nil (.> node :source) (range/get-source node)))
                             (for i 1 (n result) 1
                               (.<! result i (resolve-execute-result source (nth result i) scope state))))

                           (cond
                             [(= (n result) 1)
                              (resolve-node (car result) scope state root many)]
                             [many
                              (.<! result :tag "many")
                              result]
                             [true
                              (error-positions! (state/rs-logger state) node "Multiple values returned in a non-block context")]))])))]

                 [(= func (builtin :define))
                  (unless root
                    (error-positions! (state/rs-logger state) first "define can only be used on the top level"))
                  (expect-type! (state/rs-logger state) (nth node 2) node "symbol" "name")
                  (expect!      (state/rs-logger state) (nth node 3) node "value")

                  (with (var (scope/add-verbose! scope (.> (nth node 2) :contents) "defined" node (state/rs-logger state)))
                    (scope/set-var-display-name! var (.> (nth node 2) :display-name))
                    (state/define! state var)
                    (.<! node :def-var var)

                    (handle-metadata (state/rs-logger state) node var 3 (pred (n node)))
                    (.<! node (n node) (resolve-node (nth node (n node)) scope state))
                    node)]

                 [(= func (builtin :define-macro))
                  (unless root
                    (error-positions! (state/rs-logger state) first "define-macro can only be used on the top level"))
                  (expect-type! (state/rs-logger state) (nth node 2) node "symbol" "name")
                  (expect!      (state/rs-logger state) (nth node 3) node "value")

                  (with (var (scope/add-verbose! scope (.> (nth node 2) :contents) "macro" node (state/rs-logger state)))
                    (scope/set-var-display-name! var (.> (nth node 2) :display-name))
                    (state/define! state var)
                    (.<! node :def-var var)

                    (handle-metadata (state/rs-logger state) node var 3 (pred (n node)))
                    (.<! node (n node) (resolve-node (nth node (n node)) scope state))
                    node)]

                 [(= func (builtin :define-native))
                  (unless root
                    (error-positions! (state/rs-logger state) first "define-native can only be used on the top level"))

                  (expect-type! (state/rs-logger state) (nth node 2) node "symbol" "name")
                  (with (var (scope/add-verbose! scope (.> (nth node 2) :contents) "native" node (state/rs-logger state)))
                    ;; Copy metadata across
                    (when-with (native (library-cache-meta (.> (state/rs-compiler state) :libs) (scope/var-unique-name var)))
                      (scope/set-var-native! var native))

                    (scope/set-var-display-name! var (.> (nth node 2) :display-name))
                    (state/define! state var)
                    (.<! node :def-var var)

                    (handle-metadata (state/rs-logger state) node var 3 (n node))
                    node)]

                 [(= func (builtin :import))
                  (expect-type! (state/rs-logger state) (nth node 2) node "symbol" "module name")

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
                             (expect-type! (state/rs-logger state) entry qualifier "symbol")
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
                      [_ (expect-type! (state/rs-logger state) (nth node 3) node "symbol" "alias name of import list")])


                    (max-length! (state/rs-logger state) node export-idx "import")
                    (co/yield { :tag     "import"
                                :module  (.> (nth node 2) :contents)
                                :as      as
                                :symbols symbols
                                :export  (with (export (nth node export-idx))
                                           (and export (progn
                                                         (expect-type! (state/rs-logger state) export node "key" "import modifier")
                                                         (case (.> export :value)
                                                           ["export" true]
                                                           [_ (error-positions! (state/rs-logger state) export "unknown import modifier")]))))
                                :scope   scope })
                    node)]

                 [(= func (builtin :struct-literal))
                  (when (/= (mod (n node) 2) 1)
                    (error-positions! (state/rs-logger state) node (.. "Expected an even number of arguments, got " (pred (n node)))))
                  (resolve-list node 2 scope state)]

                 [true
                  (error-internal! (state/rs-logger state) node (.. "Unknown builtin " (if func (scope/var-name func) "?")))])]

              ["macro"
               (unless func-state (error-internal! (state/rs-logger state) first "Macro is not defined correctly"))

               (with (builder (state/get! func-state))
                 (when (/= (type builder) "function")
                   (error-positions! (state/rs-logger state) first (.. "Macro is of type " (type builder))))

                 ;; Set up the active scope and node
                 (.<! (state/rs-compiler state) :active-scope scope)
                 (.<! (state/rs-compiler state) :active-node  node)

                 ;; Execute the macro
                 (case (state/rs-exec state (lambda () (apply builder (cdr node))))
                   ;; The macro failed so remap the traceback and error
                   [(false ?msg)
                    (error-positions! (state/rs-logger state) first (traceback/remap-traceback (state/rs-mappings state) msg))]

                   ;; The macro worked, we'll gather the output and continue.
                   [(true . ?replacement)
                    (with (source (range/mk-node-source func (.> first :source) (range/get-source node)))
                      (for i 1 (n replacement) 1
                        (.<! replacement i (resolve-execute-result source (nth replacement i) scope state))))

                    (cond
                      [(= (n replacement) 0)
                       (error-positions! (state/rs-logger state) node (.. "Expected some value from " (state/name func-state) ", got nothing"))]
                      [(= (n replacement) 1) (resolve-node (car replacement) scope state root many)]
                      [many
                       (.<! replacement :tag "many")
                       replacement]
                      [true
                       (error-positions! (state/rs-logger state) node "Multiple values returned in a non-block context.")])]))]


              ;; We're defined/arg/native so just resolve as normal
              [_ (resolve-list node 1 scope state)]))]
         ["list"
          (resolve-list node 1 scope state)]
         [?ty (error-positions! (state/rs-logger state) (or first node) (.. "Cannot invoke a non-function type '" ty "'"))]))]))

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
