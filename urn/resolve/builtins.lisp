(import urn/resolve/scope scope)

(define root-scope
  "The root scope containing all builtin-ins."
  (scope/child nil "builtin"))

(define builtins
  "All builtin variables, including special forms and `true`, `false` and
   `nil`."
  {})

(define builtin-vars
  "A set defining all builtin variables (excluding special forms)"
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

(defun create-scope (kind)
  "Create a new scope with [[root-scope]] as the parent and the specified
   KIND."
  (scope/child root-scope kind))
