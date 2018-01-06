(import urn/analysis/nodes nodes)
(import urn/analysis/vars nodes)
(import urn/analysis/optimise/fusion fusion)
(import urn/analysis/tag/categories categories)
(import urn/analysis/tag/usage usage)
(import urn/analysis/traverse traverse)
(import urn/analysis/visitor visitor)
(import urn/backend/lua/emit lua)
(import urn/backend/writer writer)
(import urn/error error)
(import urn/logger logger)
(import urn/range range)
(import urn/resolve/scope scope)
(import urn/resolve/state state)
(import urn/traceback traceback)

(import lua/coroutine co)
(import lua/debug debug)

(defun create-plugin-state (compiler)
  (let* [(logger    (.> compiler :log))
         (variables (.> compiler :variables))
         (states    (.> compiler :states))
         (warnings  (.> compiler :warning))
         (optimise  (.> compiler :optimise))

         (active-scope (lambda () (.> compiler :active-scope)))
         (active-node  (lambda () (.> compiler :active-node)))]
    { ;; init.lisp
      :logger/put-error!   (cut logger/put-error!   logger <>)
      :logger/put-warning! (cut logger/put-warning! logger <>)
      :logger/put-verbose! (cut logger/put-verbose! logger <>)
      :logger/put-debug!   (cut logger/put-debug!   logger <>)
      :logger/put-node-error!   (lambda (msg node explain &lines)
                                  (logger/put-node-error!   logger msg (range/get-top-source node) explain (splice lines)))
      :logger/put-node-warning! (lambda (msg node explain &lines)
                                  (logger/put-node-warning! logger msg (range/get-top-source node) explain (splice lines)))
      :logger/do-node-error!    (lambda (msg node explain &lines)
                                  (error/do-node-error!     logger msg (range/get-top-source node) explain (splice lines)))
      :range/get-source    range/get-source
      :flags               (lambda () (map id (.> compiler :flags)))
      :flag?               (lambda (&flags)
                             (any (cut elem? <> (.> compiler :flags)) flags))

      ;; nodes.lisp
      :visit-node     visitor/visit-node
      :visit-nodes    visitor/visit-list
      :traverse-nodes traverse/traverse-node
      :traverse-nodes traverse/traverse-list
      :symbol->var    (lambda (x)
                        (with (var (.> x :var))
                              (if (string? var) (.> variables var) var)))
      :var->symbol    nodes/make-symbol
      :builtin        nodes/builtin
      :builtin?       nodes/builtin?
      :constant?      nodes/constant?
      :node->val      nodes/urn->val
      :val->node      nodes/val->urn
      :node-contains-var?  nodes/node-contains-var?
      :node-contains-vars? nodes/node-contains-vars?

      ;; optimise.lisp
      :fusion/add-rule! fusion/add-rule!

      ;; pass.lisp
      :add-pass!      (lambda (pass)
                        (assert-type! pass table)
                        (unless (string? (.> pass :name))
                          (error! (.. "Expected string for name, got " (type (.> pass :name)))))
                        (unless (invokable? (.> pass :run))
                          (error! (.. "Expected function for run, got " (type (.> pass :run)))))
                        (unless (list? (.> pass :cat))
                          (error! (.. "Expected list for cat, got " (type (.> pass :cat)))))

                        (with (func (.> pass :run))
                          (.<! pass :run
                            (lambda (&args)
                              (case (list (xpcall (lambda () (apply func args)) traceback/traceback))
                                [(false ?msg) (fail! (traceback/remap-traceback (.> compiler :compile-state :mappings) msg))]
                                [(true . ?rest) (splice rest)]))))

                        (with (cats (.> pass :cat))
                          (cond
                            [(elem? "opt" cats)
                             (cond
                               [(any (cut string/starts-with? <> "transform-") cats)
                                (push! (.> optimise :transform) pass)]
                               [(elem? "usage" cats) (push! (.> optimise :usage) pass)]
                               [else                 (push! (.> optimise :normal) pass)])]
                            [(elem? "warn" cats)
                             (cond
                               [(elem? "usage" cats) (push! (.> warnings :usage) pass)]
                               [else                 (push! (.> warnings :normal) pass)])]
                            [else (error! (.. "Cannot register " (pretty (.> pass :name)) " (do not know how to process " (pretty cats) ")"))]))
                        nil)
      :var-usage      usage/get-var


      ;; resolve.lisp
      :active-scope   active-scope
      :active-node    active-node
      :active-module  (lambda ()
                        (loop [(scp (active-scope))] []
                          (cond
                            [(not scp) nil]
                            [(scope/scope-top-level? scp) scp]
                            [else (recur (scope/scope-parent scp))])))
      :scope-vars     (lambda (scope)
                        (unless scope (set! scope (active-scope)))
                        (assert-type! scope scope)
                        (scope/scope-variables scope))
      :scope-exported (lambda (scope)
                        (unless scope (set! scope (active-scope)))
                        (assert-type! scope scope)
                        (scope/scope-exported scope))
      :var-lookup     (lambda (symb scope)
                        (assert-type! symb symbol)
                        (when (= (active-node) nil) (error! "Not currently resolving"))
                        (unless scope (set! scope (active-scope)))
                        (scope/lookup-always! scope (symbol->string symb) (active-node)))
      :try-var-lookup (lambda (symb scope)
                        (assert-type! symb symbol)
                        (when (= (active-node) nil) (error! "Not currently resolving"))
                        (unless scope (set! scope (active-scope)))
                        (scope/lookup scope (symbol->string symb)))
      :var-definition (lambda (var)
                        (when (= (active-node) nil) (error! "Not currently resolving"))
                        (when-with (state (.> states var))
                          (when (= (.> state :stage) "parsed")
                            (co/yield { :tag   "build"
                                        :state state }))
                          (.> state :node)))
      :var-value      (lambda (var)
                        (when (= (active-node) nil) (error! "Not currently resolving"))
                        (when-with (state (.> states var))
                          (state/get! state)))
      :var-docstring scope/var-doc }))
