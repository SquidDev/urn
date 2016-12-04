;; States represent the progress made through building a top level
;; definition. They are stored in a global variable -> state lookup table,
;; though not all states have a corresponding variable.

;; States transition through three stages:
;;  `parsed`   is the start state for all states. This represents the initial AST of the node.
;;  `built`    is the "minimum" required state. This is where the node has had all
;;             macros expanded and all variables resolved
;;  `executed` is only used for macros or there dependencies. This is used for nodes which have been compiled
;;             to Lua and loaded into the environment.

(defun create (variables scope range)
  (assert variables "variables cannot be nil")
  (assert scope "scope cannot be nil")
  (assert (.> scope :is-root) "scope must be root")

  (struct
    :tag       "state"

    ;; The scope this top level definition lives under
    :scope     scope

    ;; Variable to state mapping
    :variables variables

    ;; Set of all required variables.
    :required  (empty-struct)

    ;; The current stage we are in.
    :stage     "parsed"

    ;; The position this node is located at.
    :range     range

    ;; The variable this node is defined as
    :var       nil

    ;; The final node for this entry. This is set then the "built" stage has finished.
    :node      nil

    ;; The value of this node. This is set when the "executed" stage has finished.
    :value     nil))

(defun require! (state var)
  (assert (= (.> state :stage) "parsed") "Expected to be in parsed state")

  (when (.> var :scope :is-root)
    (with (state (assert (.> state :variables var) "Cannot find variable"))
       (.<! state :required state true)
       state)))

(defun set-var! (state var)
  (assert (= (.> state :stage) "parsed") "Expected to be in parsed state")
  (assert (= (.> var :scope) (.> state :scope)) "Scopes are not the same")
  (assert (! (.> state :var)) "Variable is already declared")

  ;; Set the current variable and update the variable -> state mapping.
  (.<! state :var var)
  (.<! state :variables var state))

(defun on-built! (state node)
  (assert node "node cannot be nil")
  (assert (= (.> state :stage) "parsed") "Expected to be in parsed state")
  (assert (= (.> node :def-var) (.> state :var)) "Variables are different")

  (.<! state :stage "built")
  (.<! state :node node))

(defun on-executed! (state value)
  (assert (= (.> state :stage) "built") "Expected to be in built state")

  (.<! state :stage "executed")
  (.<! state :value value))

;; (defun get! (state)
;;   (if (= (.> state :stage) "executed")
;;     (.> state :value)
;;     (letrec ((required (empty-struct))
;;              (required-list '())
;;              (visit (lambda (state stack stack-hash)
;;               (with (idx (.> stack-hash state)))
;;                 (cond
;;                   ((and idx (/= (.> state :var :tag) "macro")) nil)
;;                   (idx
;;                     (with (states '())
;;                       (for i idx (# stack) 1
;;                         (push-cdr! states (.> stack i :var :name)))
;;                       (push-cdr! states (state :var :name))
