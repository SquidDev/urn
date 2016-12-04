(import string)
(import coroutine)

(import urn/logger logger)
(import urn/analysis/builtin builtin)
(import urn/analysis/scope scope)
(import urn/analysis/state state)

;; Node resolution walks every expression and performs several actions:
;; - Checks syntax: ensures all expressions are well formed.
;; - Resolves variables: stores and looks up variables in the scope. Also ensures that
;;   set! doesn't change constant variables
;; - Expands macros: if the function to be called is a macro, then the macro is invoked with the
;;   required arguments.
;; If any errors occur then the scanning is terminated.

;; Error if this function is expected
(defun expect-type! (node parent type name)
  (if (and node (= (.> node :tag) type))
    true
    (progn
      (logger/put-error! (or node parent) (string/.. "Expected " (or  name type) ", got " (if node (.> node :tag) "nothing")))
      false)))

(defun expect! (node parent name)
  (if node
    true
    (progn
      (logger/put-error! (or node parent) (string/.. "Expected " (name) ", got nothing"))
      false)))

(defmacro hoist! (&body) `(coroutine/yield (struct ,@body)))

;; Walks the result of a macro, expanding primitives into objects setting nodes without
;; an existing position to include the macro.
;; TODO: Handle duplicate copies, error on recursive data structures.
(defun resolve-macro-result (macro node parent)
  (with (node (with (ty (type# node))
                (cond
                  ((= ty "nil") (struct :tag "symbol" :contents "nil" :var (builtin/builtin "nil")))
                  ((= ty "boolean") (struct :tag "symbol" :contents "boolean" :var (builtin/builtin (bool->string node))))
                  ((= ty "number") (struct :tag "number" :contents node))
                  ((= ty "string") (struct :tag "number" :contents (string/format "%q" node)))
                  ((= ty "table") node)
                  (true (error (string/.. "Cannot handle " ty)))))) ;; TODO Fancy error handling

    ;; Every node should store the parent node
    (.<! node :parent parent)

    ;; Set the position if we don't have it already
    (when (and (! (.> node :range)) (! (.> node :macro)))
      (.<! node :macro macro))

    ;; Walk this node's children. We might have mutated this (please don't though), so
    ;; it is always worth it.
    (when (= (.> node :tag) "list")
      (for i 1 (# node) 1
        (.<! node i (resolve-macro-result macro (.> node i) node))))

    node))

(defun resolve-quote (node scope state level)
  (if (= level 0)
    (resolve-node node scope state)
    (with (tag (.> node :tag))
      (cond
        ((or (= tag "string") (= tag "number") (= tag "symbol") (= tag "key"))
          node)
        ((= tag "list")
          (with (first (.> node 1))
            (if (and first (= (.> first :tag) "symbol"))
              (cond
                ((or (= (.> first :contents) "unquote") (= (.> first :contents) "unquote-splice"))
                  (.<! node 2 (resolve-quote (.> node 2) scope state (pred level)))
                  node)
                ((= (.> first :contents) "quasiquote")
                  (.<! node 2 (resolve-quote (.> node 2) scope state (succ level)))
                  node)
                (true
                  (for i 1 (# node) 1
                    (.<! node i (resolve-quote (.> node i) scope state level)))
                  node))
              (progn
                ;; TODO: we have to duplicate some code here. Can we prevent this?
                (for i 1 (# node) 1
                  (.<! node i (resolve-quote (.> node i) scope state level)))
                node))))
        (true (error (string/.. "Unknown tag " tag)))))))

(defun resolve-var (node scope)
  (let* ((name (.> node :contents))
          (var (or (.> node :var) (scope/get scope name))))

    ;; If we don't have the variable the wait for it and return.
    (when (! var)
      (set! var (hoist!
                  :tag  "use"
                  :name name
                  :node node)))
    ;; It is possible that we still couldn't resolve the variable but are resuming in
    ;; order to find as many errors as possible.
    (if var
      (progn
        (state/require! var)
        (.<! node :var var)
        var)
      nil)))

(defun resolve-define (node scope state kind)
  (let* ((name (.> node 2 :contents))
          (previous (.> scope :variables name)))
    (if previous
      (progn
        ;; TODO: "Fancier" error message include previous variables location
        (logger/put-error! node (string/.. "variable " name " already declared"))
        false)

      (progn
        (.<! node :defvar (scope/add! scope name "defined"))
        (state/set-var! (.> node :defvar))
        true))))

(defun resolve-node (node scope state)
  (with (tag (.> node :tag))
    (cond
      ;; Trivial tags need nothing doing
      ((or (= tag "number") (= tag "string") (= tag "key"))
        node)
      ((= tag "symbol")
        (resolve-var node scope)
        node)
      ((= tag "list")
        (with (first (.> node 1))
          (cond
            ((= first nil)
              (logger/put-error! node "Cannot have an empty list"))
            ((= (.> first :tag) "symbol")
              (with (var (resolve-var first scope state))
                (when var
                  (with (var-state (state/require! state var))
                    (cond
                      ((= var (builtin/builtin "lambda"))
                        (when (expect-type! (.> node 2) node "list" "argument list")
                          (let ((child-scope (scope/child scope))
                                (args (.> node 2))
                                (success true))
                            (for i 1 (# args) 1
                              (with (arg (.> args i))
                                (if (expect-type! arg args "symbol" "argument")
                                  (let* ((name (.> arg :contents))
                                         (is-var (= (string/char-at name 1) "*")))

                                    ;; Strip "&" from variadic argument
                                    (when is-var
                                      (if (= i (# args))
                                        (set! name (string/sub name 2))
                                        (progn
                                          (set! success false)
                                          (logger/put-error! arg "Only last argument can be variadic"))))

                                    ;; TODO: Check for duplicate arguments

                                    ;; Update the variable and additional entries.
                                    (.<! arg :var (scope/add! child-scope name "arg" arg))
                                    (.<! arg :var :is-variadic is-var))
                                  (set! success false))))
                            ;; If we've failed at any point so far then don't bother resolving: the arguments
                            ;; will be invalid so it is probable there will be missing value errors.
                            (when success
                              (resolve-list node 3 child-scope state)))))
                      ((= var (builtin/builtin "cond"))
                        (for i 2 (# node) 1
                          (with (case (.> node i))
                            (when (and (expect-type! case node "list" "case expression") (expect! (.> case 1) case "condition"))
                              (.<! case 1 (resolve-node (.> case 1 scope state)))
                              (resolve-list 2 case scope state))))
                        node)
                      ((= var (builtin/builtin "set!"))
                        (when (and (expect-type! (.> node 2) node "symbol") (expect! (.> node 3) "value"))
                          (with (var (resolve-var (.> node 2)))
                            (cond
                              ((= nil var) nil) ;; Variable doesn't exist, just return
                              ((.> var :const) (logger/put-error! node (string/.. "Cannot rebind constant " (.> var :name))))
                              (true
                                (.<! node 3 (resolve-node (.> node 3) scope state))
                                node)))))
                      ((= var (builtin/builtin "quote"))
                        (when (expect! (.> node 2) node "value")
                          node))
                      ((= var (builtin/builtin "quasiquote"))
                        (when (expect! (.> node 2) node "value")
                          (.<! node 2 (resolve-quote (.> node 2) scope state 1))
                          node))
                      ((or (= var (builtin/builtin "unquote")) (= var (builtin/builtin "unquote-splice")))
                        (logger/put-error! first "unquote outside of quasiquote"))
                      ((= var (builtin/builtin "define"))
                        (when (and (expect-type! (node .> 2) node "symbol" "name") (expect! (node .> 3) node "value"))
                          (when (resolve-define node scope state "defined")
                            (.<! node 3 (resolve-node (.> node 3) scope state))
                            node)))
                      ((= var (builtin/builtin "define-macro"))
                        (when (and (expect-type! (node .> 2) node "symbol" "name") (expect! (node .> 3) node "value"))
                          (when (resolve-define node scope state "macro")
                            (.<! node 3 (resolve-node (.> node 3) scope state))
                            node)))
                      ((= var (builtin/builtin "define-native"))
                        (when (and (expect-type! (node .> 2) node "symbol" "name"))
                          (when (resolve-define node scope state "macro")
                            node)))
                      ((= var (builtin/builtin "import"))
                        (when (expect-type! (.> node 2) node "symbol" "module name")
                          (when (or (! (.> node 3)) (expect-type! (.> node 3) node "symbol" "alias name"))
                            (hoist!
                              :tag    "import"
                              :module (.> node 2 :contents)
                              :as     (if (.> node 3) (.> node 3 :contents) (.> node 2 :contents))
                              :node   node)
                            node)))
                      ((= (.> var :tag) "macro")
                        (logger/put-error! node "Lol, macros")
                        node)
                      ((or (= (.> var :tag) "defined") (= (.> var :tag) "arg"))
                        (resolve-list node 1 scope state))
                      (true (error (string/.. "Unknown kind " (.> var :tag) " for variable " (.> var :name)))))))))
            (true (resolve-list 1 node scope state)))))
      (true (error (string/.. "Unknown type " tag))))))

(defun resolve-list (node start scope state)
  (with (success true)
    (for i start (# node) 1
      (with (result (resolve-node (.> node scope state)))
        (if result
          (.<! node i result)
          (set! success false))))
    ))
