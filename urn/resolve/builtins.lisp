(import urn/resolve/scope scope)

(define root-scope
  "The root scope containing all builtin-ins."
  (scope/child nil "builtin"))

(define builtins
  "All builtin variables, including special forms and `true`, `false` and
   `nil`."
  :hidden
  {})

(define builtin-vars
  "A set defining all builtin variables (excluding special forms)."
  :hidden
  {})

(for-each symbol '("define" "define-macro" "define-native"
                   "lambda" "set!" "cond" "import" "struct-literal"
                   "quote" "syntax-quote" "unquote" "unquote-splice")
  (with (var (scope/add! root-scope symbol "builtin" nil))
    (scope/import! root-scope (.. "builtin/" symbol) var true)
    (.<! builtins symbol var)))

(for-each symbol '("nil" "true" "false")
  (with (var (scope/add! root-scope symbol "defined" nil))
    (scope/import! root-scope (.. "builtin/" symbol) var true)
    (.<! builtin-vars var true)
    (.<! builtins symbol var)))

(defun builtin (name)
  "Get a builtin with the given NAME."
  (.> builtins name))

(defun builtin-var? (var)
  "Determine whether this is a built-in 'defined' variable."
  (/= (.> builtin-vars var) nil))

(defun create-scope (kind)
  "Create a new scope with [[root-scope]] as the parent and the specified
   KIND."
  (scope/child root-scope kind))
