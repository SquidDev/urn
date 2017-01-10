(import assert (assert!))
(import coroutine)
(import string)

(defun child (parent) (struct
  :tag       "scope"

  ;; The parent scope, used to lookup variables not defined in this one
  :parent    parent

  ;; Name to variable mapping
  :variables (empty-struct)))

(define empty (child nil))

(defun get (scope name)
  (with (var nil)
    (while (and scope (! var))
      (set! var (.> scope :variables name))
      (set! scope (.> scope :parent)))
  var))

;; TODO: Can we redesign this? The node is only passed so the error
;; message knows where we are missing a variable.
;; Maybe this should be migrated to resolve?
;; (unless var
;;   (set! var (coroutine/yield (struct
;;              :tag  "define"
;;              :name name
;;              :node node))))
;; (set! node :var var)

(define kinds (struct :defined true :macro true :arg true :builtin true))

(defun add! (scope name kind node)
  (assert! name "name is nil")
  (assert! (.> kinds kind) (string/.. "unknown kind " kind))
  (assert! (! (.> scope :variables name)) (string/.. "Previous declaration of " name))

  (with (var (struct
               :tag   kind
               :name  name
               :scope scope
               :const (/= kind "arg")
               :node  node))
    (.<! scope :variables name var)
    var))

(defun import! (scope prefix var)
  (assert! var "var is nil")

  (with (name (if prefix
                 (string/.. prefix "/" (.> var :name))
                 (.> var :name)))

    (assert! (! (.> scope :variables name)) (string/.. "Previous declaration of " name))
    (.<! scope :variables :name var)))
