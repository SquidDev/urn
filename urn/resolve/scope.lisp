(import lua/coroutine co)
(import data/struct ())

(import urn/error error)
(import urn/range range)
(import urn/resolve/native (native))

(defstruct (scope child scope?)
  "Create a new scope with the given PARENT, specifying the KIND of
   scope."
  (fields
    (immutable parent
      "The parent scope. This is used to lookup symbols not found in this
       scope.")

    (immutable kind
      "The kind of scope this is. It is either 'top-level', 'normal' or
       'builtin'.")

    (immutable variables
      "The variables within this scope")

    (immutable exported
      "The exported variables within this scope.")

    (mutable prefix
      "A prefix used on all variables within this scope.")

    (mutable unique-prefix
      "A unique prefix used on all variables within this scope."))

  (constructor new
    (lambda (parent kind)
      (when (/= parent nil) (assert-type! parent scope))
      (cond
        [(= kind nil) (set! kind "normal")]
        [(or (= kind "normal") (= kind "top-level") (= kind "builtin"))]
        [else (format 1 "Unknown scope kind {#kind}")])

      (new
        parent kind {} {}
        (if parent (scope-prefix parent) "")
        (if parent (scope-unique-prefix parent) "")))))

(defun scope-top-level? (scope)
  "Whether this is a top level SCOPE."
  (= (scope-kind scope) "top-level"))

(defun scope-builtin? (scope)
  "Whether this is a scope which stores builtin variables."
  (= (scope-kind scope) "builtin"))

(defstruct (var var var?)
  (fields
    (immutable name
      "The name of this variable")

    (immutable kind
      "The kind of this variable. This is either a top level definition
       ('defined', 'native', 'macro'), a function argument ('arg') or a
       builtin ('builtin').")

    (immutable scope
      "The scope associated with this variable")

    (immutable full-name
      "The current name prefixed with [[scope-prefix]].")

    (immutable unique-name
      "The current name prefixed with [[scope-unique-prefix]].")

    (immutable node
      "The node associated with this variable, should only be `nil` for
       builtins.")

    (mutable const var-const? set-var-const!
      "Whether this variable is immutable. This defaults to true for
       top-level definitions and false for function arguments.")

    (mutable is-variadic var-variadic? set-var-variadic!
      "Whether this variable is an argument which accepts multiple
       values.")

    (mutable doc
      "The documentation string for this variable")

    (mutable display-name
      "A name used when displaying this variable, such as in generated
       code.")

    (mutable deprecated
      "Determines if this variable is deprecated. Will either be a string
       storing a warning message, or `true` if no message was provided.")

    (mutable intrinsic
      "Determines if this variable can be optimised to some intrinsic
       operation. Whilst this should generally be done on natives, there
       may be some special cases that normal variables can make use of
       it.")

    (mutable native (hide var-native#) (hide set-var-native#!)
      "[[native]] for this variable."))

  (constructor new
    (lambda (name kind scope node)
      (assert-type! name string)
      (assert-type! kind string)
      (assert-type! scope scope)

      (new name kind scope
           (.. (scope-prefix scope) name)
           (.. (scope-unique-prefix scope) name)
           node
           (/= kind "arg")
           false nil nil false nil nil))))

(defmethod (pretty var) (var)
  (.. "«var : " (var-name var) "»"))

(defun var-native (var)
  "The [[native]] for this VAR. This can only be called for native
   definitions."
  (demand (= (var-kind var) "native") "VAR must be a native definition.")
  (with (v-native (var-native# var))
    (unless v-native
      (set! v-native (native))
      (set-var-native! var v-native))
    v-native))

(defun set-var-native! (var native)
  "Set the NATIVE metadata for this VAR."
  (assert-type! native native)
  (demand (= (var-kind var) "native") "VAR must be a native definition.")
  (demand (= (var-native# var) nil) "VAR already has native metadata.")

  (set-var-native#! var native))

(defun get (scope name)
  "Get variable with the given NAME in the given SCOPE, not looking in
   parent scopes."
  (.> (scope-variables scope) name))

(defun get-exported (scope name)
  "Get exported variable with the given NAME in the given SCOPE, not
   looking in parent scopes."
  (.> (scope-exported scope) name))

(defun lookup (scope name)
  "Lookup NAME in the given SCOPE or any of the parent scopes."
  (if scope
    (or (get scope name)
        (lookup (scope-parent scope) name))
    nil))

(defun lookup-always! (scope name user)
  "Lookup NAME in the given SCOPE or any of the parent scopes, yielding
   if it cannot be found. USER is the node which requires this variable."
  (or (lookup scope name)
      (co/yield { :tag   "define"
                  :name  name
                  :node  user
                  :scope scope })))

(define *temp-scope*
  "A scope for all temporary variables"
  :hidden
  (child))

(defun temp-var (name node)
  "Create a temporary variable with an optional NAME and associated
   NODE."
  (var (or name "temp") "arg" *temp-scope* node))

(define kinds
  "All valid kinds a variable can have."
  :hidden
  { :defined true
    :native  true
    :macro   true
    :arg     true
    :builtin true })

(defun add! (scope name kind node)
  "Define variable NAME in SCOPE with the given KIND. This variable can
   optionally be defined by the given NODE."
  (assert-type! scope scope)
  (assert-type! name string)
  (assert-type! kind string)

  (unless (.> kinds kind) (format 1 "Unknown kind {#kind}"))
  (when (get scope name) (format 1 "Previous declaration of {#name}"))
  (when (and (= name "_") (scope-top-level? scope)) (fail! "Cannot declare \"_\" as a top level definition"))

  (with (var (var name kind scope node))
    (unless (= name "_")
      (.<! (scope-variables scope) name var)
      (.<! (scope-exported scope) name var))
    var))

(defun add-verbose! (scope name kind node logger)
  "Define variable NAME in SCOPE with the given KIND. This variable can
   optionally be defined by the given NODE. If this variable is already`
   deined then it will error, printing the issue to the given LOGGER."
  (assert-type! scope scope)
  (assert-type! name string)
  (assert-type! kind string)

  (unless (.> kinds kind) (format 1 "Unknown kind {#kind}"))
  (when-with (previous (get scope name))
    (error/do-node-error! logger (.. "Previous declaration of " (string/quoted name))
      (range/get-top-source node) nil
      (range/get-source node) "new definition here"
      (range/get-source (var-node previous)) "old definition here"))

  (when (and (= name "_") (scope-top-level? scope))
    (error/do-node-error! logger "Cannot declare \"_\" as a top level definition"
      (range/get-top-source node) nil
      (range/get-source node) "declared here"))

  (add! scope name kind node))

(defun import! (scope name var export)
  "Import the variable VAR into SCOPE using the given NAME. If EXPORT is
   true, then the variable will also be exported under the given name."
  (assert-type! scope scope)
  (assert-type! name string)
  (assert-type! var var)

  (when (and (get scope name) (/= (get scope name) var))
    (format 1 "Previous declaration of {#name}"))

  (.<! (scope-variables scope) name var)
  (when export (.<! (scope-exported scope) name var))

  var)

(defun import-verbose! (scope name var node export logger)
  "Import the variable VAR into SCOPE using the given NAME. If EXPORT is
   true, then the variable will also be exported under the given name. If
   NAME is already defiined in this scope, then a message will be printed
   to LOGGER and an error thrown. NODE represents the statement which
   resulted in this variable being imported."
  (assert-type! scope scope)
  (assert-type! name string)
  (assert-type! var var)

  (when (and (get scope name) (/= (get scope name) var))
    (error/do-node-error! logger
      (.. "Previous declaration of " name)
      (range/get-top-source node) nil
      (range/get-source node) "imported here"
      (range/get-source (var-node var)) "new definition here"
      (range/get-source (var-node (get scope name))) "old definition here"))

  (import! scope name var export))
