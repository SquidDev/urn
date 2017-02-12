(import urn/resolve/scope scope)

(define root-scope (scope/child))

(define builtins
  (let ((symbols '("lambda" "define" "define-macro" "define-native"
                   "set!" "cond" "import"
                   "quote" "quasiquote" "unquote" "unquote-splice"))
        (lookup (empty-struct)))
  (for-each symbol symbols
    (.<! lookup symbols (scope/add! root-scope symbol "builtin" nil)))
  lookup))

(defun builtin (name) (.> builtins name))

(defun builtin? (var) (any (cut = <> var) builtins))

(define constants
  (let ((symbols '("true" "false" "nil"))
        (lookup (struct)))
  (for-each symbol symbols
    (.<! lookup symbols (scope/add! root-scope symbol "defined" nil)))
  lookup))

(defun constant (name) (.> constants name))

(defun constant? (var) (any (cut = <> var) constants))
