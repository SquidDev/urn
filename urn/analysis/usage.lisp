;;; Defines various methods for gathering and tracking definitions and usages of all variables
;; in the program.

(import table)

(import urn/analysis/visitor visitor)
(import urn/analysis/nodes (side-effect? builtins))
(import urn/analysis/pass (defpass))

(defun create-state ()
  "Create a new, empty usage state."
  { :vars {}
    :nodes {}})

(defun get-var (state var)
  "Find a VAR entry in the current STATE."
  (with (entry (.> state :vars var))
    (unless entry
      (set! entry
        { :var var
          :usages '()
          :defs   '()
          :active false })
      (.<! state :vars var entry))
    entry))

(defun get-node (state node)
  "Find a NODE entry in the current STATE."
  (with (entry (.> state :nodes node))
    (unless entry
      (set! entry { :uses '() })
      (.<! state :nodes node entry))
    entry))

(defun add-usage! (state var node)
  "Mark a NODE as using a specific VAR."
  (with (var-meta (get-var state var))
    (push-cdr! (.> var-meta :usages) node)
    (.<! var-meta :active true)))

(defun add-definition! (state var node kind value)
  "Add a definition for a specific VAR."
  (with (var-meta (get-var state var))
    (push-cdr! (.> var-meta :defs) { :tag   kind
                                     :node  node
                                     :value value })))

(defun definitions-visitor (state node visitor)
  "Visit one NODE and gather its definitions."
  (cond
    [(and (list? node) (symbol? (car node)))
     (with (func (.> (car node) :var))
           (cond
             [(= func (.> builtins :lambda))
              (for-each arg (nth node 2) 1
                        (add-definition! state (.> arg :var) arg "arg" arg))]
             [(= func (.> builtins :set!))
              (add-definition! state (.> node 2 :var) node "set" (nth node 3))]
             [(or (= func (.> builtins :define)) (= func (.> builtins :define-macro)))
              (add-definition! state (.> node :defVar) node "define" (nth node (# node)))]
             [(= func (.> builtins :define-native))
              (add-definition! state (.> node :defVar) node "native")]
             [true]))]
    [(and (list? node) (list? (car node)) (symbol? (caar node)) (= (.> (caar node) :var) (.> builtins :lambda)))
     ;; Inline arguments to a directly called lambda
     (let* [(lam (car node))
            (args (nth lam 2))
            (offset 1)]
       (for i 1 (# args) 1
            (let [(arg (nth args i))
                  (val (nth node (+ i offset)))]
              (if (.> arg :var :isVariadic)
                (with (count (- (# node) (# args)))
                      ;; If it's a variable number of args then just skip them
                      (when (< count 0) (set! count 0))
                      (set! offset count)
                      ;; And define as a normal argument
                      (add-definition! state (.> arg :var) arg "arg" arg))
                (add-definition! state (.> arg :var) arg "let" (or val { :tag "symbol"
                                                                         :contents "nil"
                                                                         :var (.> builtins :nil) })))))
       (visitor/visit-list node 2 visitor)
       (visitor/visit-block lam 3 visitor))
     false]
    (true)))

(defun definitions-visit (state nodes)
  "Visit all NODES, gathering the definitions for a set of variables."
  (visitor/visit-block nodes 1 (cut definitions-visitor state <> <>)))

(defun usages-visit (state nodes pred)
  "Build a lookup of usages.

   Note, this will only visit \"active\" nodes: those which have a side effect
   or are used somewhere else."
  (unless pred (set! pred (lambda() true)))
  (let* [(queue '())
         (visited {})
         (add-usage (lambda (var user)
                      (with (var-meta (get-var state var))
                        (unless (.> var-meta :active)
                          (for-each def (.> var-meta :defs)
                            (with (val (.> def :value))
                              (when (and val (! (.> visited val)))
                                (push-cdr! queue val))))))
                      (add-usage! state var user)))
         (visit (lambda (node)
                  (if (.> visited node)
                    ;; Don't visit nodes we've already visited
                    false
                    (progn
                      (.<! visited node true)
                      (cond
                        [(symbol? node)
                         (add-usage (.> node :var) node)
                         true]
                        [(and (list? node) (> (# node) 0) (symbol? (car node)))
                         (with (func (.> (car node) :var))
                               (if (or (= func (.> builtins :set!)) (= func (.> builtins :define)) (= func (.> builtins :define-macro)))
                                 ;; If this is a definition and the predicate fails then skip
                                 (if (pred (nth node 3)) true false)
                                 true))]
                        [true true])))))]
    (for-each node nodes
      (push-cdr! queue node))
    (while (> (# queue) 0)
      (visitor/visit-node (pop-last! queue) visit))))

(defpass tag-usage (state nodes lookup)
  "Gathers usage and definition data for all expressions in NODES, storing it in LOOKUP."
  :cat '("tag" "usage")
  (definitions-visit lookup nodes)
  (usages-visit lookup nodes side-effect?))
