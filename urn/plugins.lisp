(import urn/logger logger)
(import urn/backend/writer writer)
(import urn/backend/lua/emit lua)
(import urn/analysis/nodes nodes)
(import urn/analysis/tag/categories categories)
(import urn/analysis/visitor visitor)
(import urn/analysis/traverse traverse)
(import urn/analysis/usage usage)

(import lua/coroutine co)

(define Scope (require "tacky.analysis.scope"))

(defun create-plugin-state (compiler)
  (let* [(logger    (.> compiler :log))
         (variables (.> compiler :variables))
         (states    (.> compiler :states))
         (warnings  (.> compiler :warnings))
         (optimise  (.> compiler :optimise))

         (active-scope (lambda () (.> compiler :active-scope)))
         (active-node  (lambda () (.> compiler :active-node)))

         (categorise '())
         (emit       '())]
    (const-struct
      ;; backend.lisp
      :add-categoriser!    (lambda () (fail! "add-categoriser! is not yet implemented")) ;; TODO: Add add-categoriser!
      :categorise-node     categories/visit-node
      :categorise-nodes    categories/visit-nodes
      :cat                 categories/cat
      :writer/append!      writer/append!
      :writer/line!        writer/line!
      :writer/indent!      writer/indent!
      :writer/unindent!    writer/unindent!
      :writer/begin-block! writer/begin-block!
      :writer/next-block!  writer/next-block!
      :writer/end-block!   writer/end-block!
      :add-emitter!        (lambda () (fail! "add-emitter! is not yet implemented")) ;; TODO: Add add-emitter!
      :emit-node           lua/expression
      :emit-block          lua/block

      ;; init.lisp
      :logger/put-error!   (cut logger/put-error!   logger <>)
      :logger/put-warning! (cut logger/put-warning! logger <>)
      :logger/put-verbose! (cut logger/put-verbose! logger <>)
      :logger/put-debug!   (cut logger/put-debug!   logger <>)
      :logger/put-node-error!   (lambda (msg node explain &lines)
                                  (logger/put-node-error!   logger msg node explain (unpack lines 1 (# lines))))
      :logger/put-node-warning! (lambda (msg node explain &lines)
                                  (logger/put-node-warning! logger msg node explain (unpack lines 1 (# lines))))
      :logger/do-node-error!    (lambda (msg node explain &lines)
                                  (logger/do-node-error!    logger msg node explain (unpack lines 1 (# lines))))

      ;; nodes.lisp
      :visit-node     visitor/visit-node
      :visit-nodes    visitor/visit-list
      :traverse-nodes traverse/traverse-node
      :traverse-nodes traverse/traverse-list
      :symbol->var    (lambda (x)
                        (with (var (.> x :var))
                          (if (string? var) (.> variables var) var)))
      :var->symbol    nodes/make-symbol
      :builtin?       nodes/builtin?
      :constant?      nodes/constant?
      :node->val      nodes/urn->val
      :val->node      nodes/val->urn

      ;; pass.lisp
      :add-pass!      (lambda (pass)
                        (assert-type! pass table)
                        (unless (string? (.> pass :name))
                          (error! (.. "Expected string for name, got " (type (.> pass :name)))))
                        (unless (invokable? (.> pass :run))
                          (error! (.. "Expected function for run, got " (type (.> pass :run)))))
                        (unless (list? (.> pass :cat))
                          (error! (.. "Expected list for cat, got " (type (.> pass :cat)))))

                        (let* [(cats (.> pass :cat))
                               (group (if (elem? "usage" cats) "usage" "normal"))]
                          (cond
                            [(elem? "opt" cats)
                             (push-cdr! (.> optimise group) pass)]
                            [(elem? "warn" cats)
                             (push-cdr! (.> warnings group) pass)]
                            [true (error! (.. "Cannot register " (pretty (.> pass :name)) " (do not know how to process " (pretty cats) ")"))]))
                        nil)
      :var-usage      usage/get-var


      ;; resolve.lisp
      :active-scope   active-scope
      :active-node    active-node
      :var-lookup     (lambda (symb scope)
                        (assert-type! symb symbol)
                        (when (= (active-node) nil) (error! "Not currently resolving"))
                        (unless scope (set! scope (active-scope)))
                        ((.> Scope :getAlways) scope (symbol->string symb) (active-node)))
      :var-definition (lambda (var)
                        (when (= (active-node) nil) (error! "Not currently resolving"))
                        (when-with (state (.> states var))
                          (when (= (.> state :stage) "parsed")
                            (co/yield (const-struct
                                        :tag   "build"
                                        :state state)))
                          (.> state :node)))
      :var-value      (lambda (var)
                        (when (= (active-node) nil) (error! "Not currently resolving"))
                        (when-with (state (.> states var))
                          (self state :get)))
      :var-docstring (lambda (var) (.> var :doc)))))
