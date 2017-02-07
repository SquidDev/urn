(import assert (assert!))
(import string)

;;; Create a new scope with the specified parent
(defun child (parent)
  (struct
    :tag       "scope"
    ;; The parent scope, used to lookup variables not defined in this one
    :parent    parent
    ;; Name to variable mapping
    :variables (empty-struct)))

;;; The empty scope from which all scopes are derived
(define empty (child nil))

;;; Lookup a variable in a scope, returning it if found or `nil` otherwise.
(defun get (scope name)
  (with (var nil)
    (while (and scope (! var))
      (set! var (.> scope :variables name))
      (set! scope (.> scope :parent)))
  var))

;;; Specifies the legal "kinds" of variables
(define kinds (struct
                :defined true
                :native true
                :macro true
                :arg true
                :builtin true))

;;; Determine whether this kind is a normal definition (and so can be invoked at runtime).
(defun kind-normal? (kind) (or (= kind "defined") (= kind "native") (= kind "arg")))

;;; Create a variable definition. This is a unique program-wide
;; reference to a specified node.
(defun create-def (name kind node)
  (assert-type! name "string")
  (assert! (.> kinds kind) (.. "unknown kind " kind))
  (assert! node "node is nil")
  (struct
    :tag   "var-def"
    :name  name
    :kind  kind
    :node  node
    :const (/= kind "arg")))

;;; Add a variable definition to the scope
(defun add! (scope name var)
  (assert-type! scope "scope")
  (assert-type! name "string")
  (assert-type! var "var-def")

  (assert! (! (.> scope :variables name)) (.. "Previous declaration of " name))

  (with (var (struct
               :tag    "var-scope"
               :name   name
               :scope  scope
               :var    var
               :export true))
    (.<! scope :variables name var)
    var))

;;; Import a variable into the current scope.
;; TODO: Move this ufnction somewhere else.
(defun import! (scope prefix var)
  (assert-type! scope "scope")
  (assert-type! prefix "string")
  (assert-type! var "var-def")

  (with (name (if prefix
                (string/.. prefix "/" (.> var :name))
                (.> var :name)))

    (add-scope! scope name var)))
