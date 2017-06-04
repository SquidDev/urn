(import urn/logger logger)
(import urn/range range)

(import lua/coroutine co)

(defun child (parent)
  "Create a new scope using PARENT as the base."
  { :parent    parent ;; The parent scope
    :variables {} ;; Lookup of named variables
    :exported  {} ;; Lookup of exported variables. For a given key in exported, variables will have the same value.
    :prefix (if parent (.> parent :prefix) "") })

(defun get (scope name)
  "Lookup NAME in the given scope."
  (if scope
    (with (var (.> scope :variables name))
      (if var
        var
        (get (.> scope :parent) name)))
    nil))

(defun get-always! (scope name user)
  "Lookup NAME in SCOPE, yielding if it cannot be found. USER is the node
   which requires this variable."
  (with (var (get scope name))
    (if var
      var
      (co/yield { :tag   "define"
                  :name  name
                  :node  user
                  :scope scope }))))

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
  (assert-type! name string)
  (assert-type! kind string)
  (unless (.> kinds kind) (error! (.. "Unknown kind " (string/quoted kind))))
  (when (.> scope :variables name) (error! (.. "Previous declaration of " name)))

  (with (var { :tag      kind
               :name     name
               :fullName (.. (.> scope :prefix) name)
               :scope    scope
               :const    (/= kind "arg")
               :node     node })
    (.<! scope :variables name var)
    (.<! scope :exported name var)
    var))

(defun add-verbose! (scope name kind node logger)
  "Define variable NAME in SCOPE with the given KIND. This variable can
   optionally be defined by the given NODE. If this variable is already`
   deined then it will error, printing the issue to the given LOGGER."
  (assert-type! name string)
  (assert-type! kind string)
  (unless (.> kinds kind) (error! (.. "Unknown kind " (string/quoted kind))))
  (when-with (previous (.> scope :variables name))
    (logger/do-node-error! logger (.. "Previous declaration of " name)
      node nil
      (range/get-source node) "new definition here"
      (range/get-source (.> previous :node)) "old definition here"))

  (add! scope name kind node))

(defun import! (scope name var export)
  "Import the variable VAR into SCOPE using the given NAME. If EXPORT is
   true, then the variable will also be exported under the given name."
  (unless var (fail! "var is nil"))
  (when (and (.> scope :variables name) (/= (.> scope :variables name) var))
    (fail! (.. "Previous declaration of " name)))

  (.<! scope :variables name var)
  (when export  (.<! scope :exported name var))

  var)

(defun import-verbose! (scope name var node export logger)
  "Import the variable VAR into SCOPE using the given NAME. If EXPORT is
   true, then the variable will also be exported under the given name. If
   NAME is already defiined in this scope, then a message will be printed
   to LOGGER and an error thrown. NODE represents the statement which
   resulted in this variable being imported."
  (unless var (fail! "var is nil"))
  (when (and (.> scope :variables name) (/= (.> scope :variables name) var))
    (logger/do-node-error! logger
      (.. "Previous declaration of " name)
      node nil
      (range/get-source node) "imported here"
      (range/get-source (.> var :node)) "new definition here"
      (range/get-source (.> scope :variables name :node)) "old definition here"))

  (import! scope name var export))
