(import collections/unique-queue uq)

;; States represent the progress made through building a top level
;; definition. They are stored in a global variable -> state lookup table,
;; though not all states have a corresponding variable.

;; States transition through three stages:
;;  `parsed`   is the start state for all states. This represents the initial AST of the node.
;;  `built`    is the "minimum" required state. This is where the node has had all
;;             macros expanded and all variables resolved.
;;  `executed` is only used for macros or there dependencies. This is used for nodes which have been compiled
;;             to Lua and loaded into the environment.

(import assert (assert!))

;;; Create a new state for node at a specified position.
(defun create (range level)
  (assert! range "range is nil")

  (struct
    :tag       "state"

    ;; The level of the current state.
    ;; - 0: Top level definitions, 1
    ;; - 1: Body of top level definitions
    ;; - 2: 1 layer of unquotes
    ;; - 3: 2 layers of unquotes, etc...
    ;; Only variables of the same level (or top level definitions) can be consumed.
    :level     level

    ;; Tracks all required variables.
    :required  (uq/new)

    ;; The current stage we are in.
    :stage     "parsed"

    ;; The position this node is located at.
    :range     range

    ;; The variable this node is defined as (top level only).
    :var       nil

    ;; The final node for this entry. This is set then the "built" stage has finished.
    :node      nil

    ;; The value of this node. This is set when the "executed" stage has finished.
    :value     nil))

;; Mark a variable as required in order for execution to complete.
(defun require! (state var)
  (assert! (= (.> state :stage) "parsed") "Expected to be in parsed state")
  (let* [(var-level (.> var :level))
         (state-level (.> state :level))]
    ;; This should have been handled somewhere else so we don't really need to make fancy errors
    (assert! (or (= var-level state-level) (= var-level 0)) ("Cannot use variable from different level"))

    ;; However, only top-level variables actually matter in terms of requirements.
    (when (= var-level 0)
      (uq/add! (.> state :required) var))))

;; Set this state's variable. This is done before the node has finished
;; being built
(defun set-var! (state var)
  (assert! (= (.> state :stage) "parsed") "Expected to be in parsed state")
  (assert! (= (.> var :scope) (.> state :scope)) "Scopes are not the same")
  (assert! (! (.> state :var)) "Variable is already declared")
  (assert! (= (.> var :level) level) "Variable is on different level to this")

  ;; Set the current variable.
  (.<! state :var var)

  ;; Update the current variable with references to this state.
  ;; TODO: We should probably track this mapping in a separate table
  ;; so we don't pollute variables.
  (.<! var :state state))

;; Set the resulting node for this state, migrating to the built state.
(defun on-built! (state node)
  (assert! node "node cannot be nil")
  (assert! (= (.> state :stage) "parsed") "Expected to be in parsed state")
  (assert! (= (.> node :def-var) (.> state :var)) "Variables are different")

  (.<! state :stage "built")
  (.<! state :node node))

;; Set the resulting value for this state, migrating to the executed state.
(defun on-executed! (state value)
  (assert! (= (.> state :stage) "built") "Expected to be in built state")

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
