;;; Defines various methods for gathering and tracking definitions and usages of all variables
;; in the program.

(import table)

(import urn/analysis/visitor visitor)

(define builtins (rawget (require "tacky.analysis.resolve") :builtins))
(define builtin-vars (rawget (require "tacky.analysis.resolve") :declaredVars))

;;; Create a new, empty usage state
(defun create-state () (struct
                         :vars (empty-struct)
                         :nodes (empty-struct)))

;; Find a variable entry in the current state
(defun get-var (state var)
  (with (entry (.> state :vars var))
    (unless entry
      (set! entry (struct
        :var var
        :usages (struct)
        :defs  (struct)
        :active false))
      (.<! state :vars var entry))
    entry))

;; Find a node entry in the current state
(defun get-node (state node)
  (with (entry (.> state :nodes node))
    (unless entry
      (set! entry (struct
                   :uses '()))
      (.<! state :nodes node entry))
    entry))

;; Mark a node as using a specific variable
(defun add-usage! (state var node)
  (let* [(var-meta (get-var state var))
         (node-meta (get-node state node))]
    (.<! var-meta :usages node true)
    (.<! var-meta :active true)
    (.<! node-meta :uses var true)))

;; Remove a node's usage of a specified variable
(defun remove-usage! (state var node)
  (let* [(var-meta (get-var state var))
         (node-meta (get-node state node))]
    (.<! var-meta :usages node nil)
    (.<! var-meta :active (! (empty-struct? (.> var-meta :usages))))
    (.<! node-meta :uses var nil)))

;; Add a definition for a specific variable
(defun add-definition! (state var node kind value)
  (with (var-meta (get-var state var))
    (when value
      (with (node-meta (get-node state value))
        ;; This shouldn't ever be possible
        (when (.> node-meta :defines) (error! "Value defines multiple variables"))
        (.<! node-meta :defines var)))
    (.<! var-meta :defs node (struct :tag kind :value value))))

;; Add a definition for a specific variable
(defun remove-definition! (state var node)
  (let* [(var-meta (get-var state var))
         (node-meta (get-node state node))]
    (.<! var-meta :defs node nil)
    (.<! node-meta :defines nil)))

;; Visit one node and gather its definitions
(defun definitions-visitor (state node)
  (when (and (list? node) (> (# node) 0) (symbol? (car node)))
    (with (func (.> (car node) :var))
      (cond
        ((= func (.> builtins :lambda))
          (for-each arg (nth node 2) 1
            (add-definition! state (.> arg :var) arg "arg" arg)))
        ((= func (.> builtins :set!))
          (add-definition! state (.> node 2 :var) node "set" (nth node 3)))
        ((or (= func (.> builtins :define)) (= func (.> builtins :define-macro)))
          (add-definition! state (.> node :defVar) node "define" (nth node 3)))
        ((= func (.> builtins :define-native))
          (add-definition! state (.> node :defVar) node "native"))
        (true)))))

;; Visit all nodes, gathering the definitions for a set of variables.
(defun definitions-visit (state nodes)
  (visitor/visit-block nodes 1 (cut definitions-visitor state <>)))

;;; Build a lookup of usages. Note, this will only visit "active" nodes: those
;; which have a side effect or are used somewhere else.
(defun usages-visit (state nodes pred)
  (unless pred (set! pred (lambda() true)))
  (let* [(queue '())
         (visited (empty-struct))
         (add-usage (lambda (var user)
                      (add-usage! state var user)
                      (with (var-meta (get-var state var))
                          (when (.> var-meta :active)
                            (table/iter-pairs (.> var-meta :defs)
                              (lambda (_ def)
                                (with (val (.> def :value))
                                  (when (and val (! (.> visited val)))
                                    (push-cdr! queue val)))))))))
         (visit (lambda (node)
                  (if (.> visited node)
                    ;; Don't visit nodes we've already visited
                    false
                    (progn
                      (.<! visited node true)
                      (cond
                        ((symbol? node)
                          (add-usage (.> node :var) node)
                          true)
                        ((and (list? node) (> (# node) 0) (symbol? (car node)))
                          (with (func (.> (car node) :var))
                            (if (or (= func (.> builtins :set!)) (= func (.> builtins :define)) (= func (.> builtins :define-macro)))
                              ;; If this is a definition and the predicate fails then skip
                              (if (pred (nth node 3)) true false)
                              true)))
                        (true true))))))]
    (for-each node nodes
      (push-cdr! queue node))
    (while (> (# queue) 0)
      (visitor/visit-node (remove-nth! queue 1) visit))))
