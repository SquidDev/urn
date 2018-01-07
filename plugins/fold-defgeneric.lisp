(import compiler/pass ())
(import compiler/nodes ())
(import compiler/pattern ())

(import lua/basic (set-idx!))

(defun get-lookup (lookup key)
  :hidden
  (with (len (n lookup))
    (loop [(i 2)]
      [(> i len)
       (with (sub (list (fix-symbol `struct-literal)))
         (push! lookup key)
         (push! lookup sub)
         sub)]
      (if (eq? (nth lookup i) key)
        (nth lookup (succ i))
        (recur (+ i 2))))))

(defpass fold-defgeneric (state nodes)
  "Merges put!s into their corresponding method."
  :cat '("opt")
  (let [(methods {})
        (i 1)
        (offset 0)]
    (while (< i (n nodes))
      (with (node (nth nodes i))
        ;; Built a list of defgenerics
        (case node
          [((matcher (define ?name ?&_ ((builtin/lambda (?var) (setmetatable ?var)) (struct-literal :lookup ?lookup ?&_))))
             -> { :name ?name :lookup ?lookup })
           (.<! methods (.> node :def-var) { :table   (cadr (last node))
                                             :lookup  lookup
                                             :impl    '() })]
          [_])

        (case node
          ;; Find defmethod and defalias instances
          [(((matcher ($core/method/put! ?name (list :lookup ?&entries) ?value))
              -> { :name ?name :entries ?entries :value ?value })
             :when (.> methods (symbol->var name)))

           (push! (.> methods (symbol->var name) :impl) { :entries entries :value value :node node })
           (changed!)
           (remove-nth! nodes i)]

          ;; Match against (set-idx! X :default Y)
          [(((matcher (set-idx! ?name :default ?value))
              -> { :name ?name :value ?value })
             :when (.> methods (symbol->var name)))
           (push! (.> methods (symbol->var name) :impl) { :entries "default" :value value :node node })
           (changed!)
           (remove-nth! nodes i)]

          [_ (inc! i)])))

    (for i 1 (n nodes) 1
      (when-let* [(var (.> (nth nodes i) :def-var))
                  (method (.> methods var))]
        (let [(lookup (.> method :lookup))
              (wrapped nil)
              (wrapped-var nil)]

        (for-each impl (.> method :impl)
          (destructuring-bind [{ :entries ?entries :value ?value :node ?node } impl]
            (cond
              ;; So if we're a lambda (and so implicitly lazy) then just merge it into the definition
              [(or (matches? (pattern (builtin/lambda ?&_)) value)
                   (matches? (pattern ((builtin/lambda (,'myself) (set! ,'myself (builtin/lambda ?&_)) ,'myself) nil)) value))
               (case entries
                 ["default"
                  (push! (.> method :table) (nth node 3))
                  (push! (.> method :table) value)]

                 [?entries
                  (with (sub-lookup lookup)
                    (for i 1 (pred (n entries)) 1
                      (set! sub-lookup (get-lookup sub-lookup (nth entries i))))

                    (push! sub-lookup (last entries))
                    (push! sub-lookup value))])]

              [else
               ;; We've got some complex expression, so we transform it to
               ;; (let [(method <ORIGINAL>)] <EXTENSIONS> method)
               (unless wrapped
                 (set! wrapped-var { :tag "var" :kind "arg" :name (.> var :name) })
                 (set! wrapped `(,(fix-symbol `builtin/lambda) (,(var->symbol wrapped-var)) ,(var->symbol wrapped-var)))
                 (with (orig (nth nodes i))
                   (.<! orig (n orig) `(,wrapped ,(last orig)))))

               (visit-node (.> impl :node)
                 (lambda (x)
                   (when (and (symbol? x) (= (symbol->var x) var))
                     (.<! x :var wrapped-var))))

               (insert-nth! wrapped (n wrapped) (.> impl :node))])))

          )))))


,(add-pass! fold-defgeneric)
