(import core/prelude ())

(define-native active-node
  "Get the node currently being resolved."
  :bind-to "_compiler['active-node']")

(define-native active-scope
  "Get the scope of the node currently being resolved."
  :bind-to "_compiler['active-scope']")

(define-native active-module
  "Get the module of the node currently being resolved."
  :bind-to "_compiler['active-module']")

(define-native scope-vars
  "Fetch the variables present in the given SCOPE, using the
   [[active-scope]] if none is given."
  :bind-to "_compiler['scope-vars']")

(define-native scope-exported
  "Fetch the variables exported in the given SCOPE, using the
   [[active-scope]] if none is given."
  :bind-to "_compiler['scope-exported']")

(define-native var-lookup
  "Look up SYMBOL in the given SCOPE, using the [[active-scope]] if none
   given.

   Note, if the variable hasn't been defined yet, then this function
   will yield until it has been resolved: do not call this within
   another coroutine."
  :bind-to "_compiler['var-lookup']")

(define-native try-var-lookup
  "Try to look up SYMBOL in the given SCOPE, using the [[active-scope]]
   if none given.

   If this variable hasn't been defined yet then this will return
   `nil`."
  :bind-to "_compiler['try-var-lookup']")

(define-native var-definition
  "Get the definition of the given VARIABLE, returning `nil` if it is
   not a top level definition.

   Note, if the variable hasn't been fully built, then this function
   will yield until it has: do not call this method within another
   coroutine."
  :bind-to "_compiler['var-definition']")

(define-native var-value
  "Get the value of the given VARIABLE, returning `nil` if it is not a top
   level definition.

   Note: if the variable hasn't been fully built or executed, then this
   function will yield until it has: do not call this function within
   another coroutine."
  :bind-to "_compiler['var-value']")

(define-native var-docstring
  "Get the docstring for the given VARIABLE, returning `nil` if it is
   not a top level definition."
  :bind-to "_compiler['var-docstring']")

(defun reify (x)
  "Return the definition of the _symbol_ (not variable) X, returning
   `nil` if it's not a top-level definition."
  (var-definition (var-lookup x)))
