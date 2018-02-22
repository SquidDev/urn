(import urn/analysis/nodes ())
(import urn/analysis/pass ())
(import urn/analysis/tag/find-letrec rec)
(import urn/analysis/vars ())
(import urn/analysis/visitor visitor)
(import urn/range range)
(import urn/resolve/scope scope)
(import urn/resolve/native native)

(defmacro cat (category &args)
  "Create a CATEGORY data set, using ARGS as additional parameters to [[struct]]."
  `{ :category ,category
     ,@args })

(defun part-all (xs i e f)
  "An implementation of [[all]] which just goes between I and E."
  :hidden
  (cond
    [(> i e) true]
    [(f (nth xs i)) (part-all xs (+ i 1) e f)]
    [true false]))

(defun recur-direct? (state var)
  "Determine whether the recursive call to VAR can be called directly."
  (with (rec (.> state :rec-lookup var))
    (and rec (= (rec/rec-func-var rec) 0) (= (rec/rec-func-direct rec) 1))))

(defun var-excluded? (state var)
  "Determine whether we will exclude all bindings for VAR."
  (recur-direct? state var))

(defun not-cond? (first second)
  "Determine whether the branches FIRST and SECOND form a not expression.

   Namely, FIRST is of the form `[<expr> false]` and SECOND is of the
   form `[true true]`."
  :hidden
  (and (= (n first) 2)  (builtin?  (nth first 2) :false)
       (= (n second) 2) (builtin?  (nth second 1) :true) (builtin? (nth second 2) :true)))

(defun and-cond? (lookup first second test)
  "Determine whether the branches FIRST and SECOND form an and expression.

   Namely, FIRST is of the form `[A <expr>]` and SECOND is of the form
   `[true A]` (or `[true false]` when in a condition TEST context)."
  :hidden
  (let [(branch (car first))
        (last (nth second 2))]
    (and
      (= (n first) 2) (= (n second) 2)
      (not (.> lookup (nth first 2) :stmt)) (builtin? (car second) :true)
      (symbol? last)
      (or
        (and (symbol? branch) (= (.> branch :var) (.> last :var)))
        (and test (not (.> lookup branch :stmt)) (= (.> last :var) (builtin :false)))))))

(defun or-cond? (lookup branch test)
  "Determine whether this BRANCH forms part of an `or` expression.

   Namely, BRANCH follows the form `[x x]` (or `[x true]` when in a
   condition TEST context)."
  :hidden
  (let* [(head (car branch))
         (tail (nth branch 2))]
    (and (= (n branch) 2) (symbol? tail)
      (or
        (and (symbol? head) (= (.> head :var) (.> tail :var)))
        (and test (not (.> lookup head :stmt)) (= (.> tail :var) (builtin :true)))))))

(defun visit-node (lookup state node stmt test recur)
  "Marks a specific NODE with a category.

   STMT marks whether this node is in a \"statement\" context. This is any node
   for which we are capable of generating a statement: namely any
   block (assignments, returns, simple calls) or the condition inside a `cond`.

   TEST marks whether this node is in a \"test\" context. This is any node which
   is used directly or indirectly inside a condition test."
  (with (cat (case (type node)
          ["string" (cat "const" :prec 100)]
          ["number" (cat "const" :prec 100)]
          ["key"    (cat "const" :prec 100)]
          ["symbol" (cat "const")]
          ["list"
           (with (head (car node))
             (case (type head)
               ["symbol"
                (with (func (.> head :var))
                  (cond
                    ;; Handle all special forms
                    [(= func (builtin :lambda))
                     (visit-nodes lookup state node 3 true)
                     (cat "lambda" :prec 100)]
                    [(= func (builtin :cond))
                     ;; Visit all conditions inside the node. It maybe seem
                     ;; weird that we consider the condition as a statement, but
                     ;; we have enough flexibility at codegen time to allow it to
                     ;; be.
                     (for i 2 (n node) 1
                       (with (case (nth node i))
                         (visit-node lookup state (car case) true true)
                         (visit-nodes lookup state case 2 true test recur)))

                     ;; And attempt to find the best condition
                     (cond
                       [(and
                          ;; If we have two conditions
                          (= (n node) 3)
                          ;; And these are of the appropriate form
                          (not-cond? (nth node 2) (nth node 3)))

                        (add-paren lookup (car (nth node 2)) 11)
                        (cat "not" :stmt (.> lookup (car (nth node 2)) :stmt) :prec 11)]

                       [(and
                          ;; If we have two conditions
                          (= (n node) 3)
                          ;; If these conditions are of the appropriate form
                          (and-cond? lookup (nth node 2) (nth node 3) test))

                        (add-paren lookup (nth (nth node 2) 1) 2) ;; (case [A _] [true A])
                        (add-paren lookup (nth (nth node 2) 2) 2) ;; (case [_ B] [true _])

                        (cat "and" :prec 2)]

                       [(and
                          ;; If we have at least two conditions.
                          (>= (n node) 3)
                          ;; All but the last two nodes are or expressions.
                          (part-all node 2 (- (n node) 2) (cut or-cond? lookup <> test))

                          (let [(first (nth node (pred (n node))))
                                (second (nth node (n node)))]
                            (or
                              ;; The last two nodes form an or expression
                              (not-cond? first second)
                              ;; The last two nodes form an and expression
                              (and-cond? lookup first second test)
                              ;; The last two nodes form an or expression
                              (and
                                ;; The penultimate node forms an and condition
                                (or-cond? lookup first test)
                                ;; The last one is `[true <expr>]`.
                                (= (n second) 2) (builtin? (car second) :true) (not (.> lookup (nth second 2) :stmt))))))

                        (let* [(len (n node))
                               (first (nth node (pred (n node))))
                               (second (nth node (n node)))]

                          (for i 2 (- len 2) 1
                            (add-paren lookup (car (nth node i)) 1))

                          (cond
                            [(not-cond? first second)
                             (add-paren lookup (nth first 1) 11)
                             (cat "or" :prec 1 :kind "not")]

                            [(and-cond? lookup first second test)
                             (add-paren lookup (nth first 1) 2)
                             (add-paren lookup (nth first 2) 2)
                             (cat "or" :prec 1 :kind "and")]

                            [else
                             (add-paren lookup (nth first 1) 1)
                             (add-paren lookup (nth second 2) 1)
                             (cat "or" :prec 1 :kind "or")]))]

                       [(and
                          ;; If we have exactly two conditions
                          (= (n node) 3)
                          ;; The first condition is of the form [X]
                          (= (n (nth node 2)) 1)
                          ;; The second condition is of the form [Y ...]
                          (builtin? (car (nth node 3)) :true) (> (n (nth node 3)) 1))

                        (add-paren lookup (car (nth node 2)) 11)
                        (cat "unless" :stmt true)]

                       [true (cat "cond" :stmt true)])]
                    [(= func (builtin :set!))
                     (let [(def (nth node 3))
                           (var (.> (nth node 2) :var))]
                       (if (and
                             (list? def) (builtin? (car def) :lambda)
                             (.> state :rec-lookup var))
                         (with (recur { :var var :def def })
                           (visit-nodes lookup state def 3 true nil recur)
                           (unless (.> recur :tail) (error! "Expected tail recursive function from letrec"))
                           (.<! lookup def (cat "lambda" :prec 100 :recur (visit-recur lookup recur))))
                         (visit-node lookup state def true)))
                     (cat "set!" :stmt true)]
                    [(= func (builtin :quote))
                     (visit-quote lookup node)
                     (cat "quote" :prec 100)]
                    [(= func (builtin :syntax-quote))
                     (visit-syntax-quote lookup state (nth node 2) 1)
                     (cat "syntax-quote" :prec 100)]
                    [(= func (builtin :unquote)) (fail! "unquote should never appear")]
                    [(= func (builtin :unquote-splice)) (fail! "unquote should never appear")]
                    [(or (= func (builtin :define)) (= func (builtin :define-macro)))
                     (with (def (nth node (n node)))
                       (if (and (list? def) (builtin? (car def) :lambda))
                         (with (recur { :var (.> node :def-var) :def def})
                           (visit-nodes lookup state def 3 true nil recur)
                           (.<! lookup def (if (.> recur :tail)
                                             (cat "lambda" :prec 100 :recur (visit-recur lookup recur))
                                             (cat "lambda" :prec 100))))
                         (visit-node lookup state def true)))
                     (cat "define")]
                    [(= func (builtin :define-native)) (cat "define-native")]
                    [(= func (builtin :import)) (cat "import")]
                    [(= func (builtin :struct-literal))
                     (visit-nodes lookup state node 2 false)
                     (cat "struct-literal" :prec 100)]

                    ;; Handle things like `(true)`
                    [(= func (builtin :true))
                     (visit-nodes lookup state node 1 false)
                     (.<! lookup head :parens true)
                     (cat "call")]
                    [(= func (builtin :false))
                     (visit-nodes lookup state node 1 false)
                     (.<! lookup head :parens true)
                     (cat "call")]
                    [(= func (builtin :nil))
                     (visit-nodes lookup state node 1 false)
                     (.<! lookup head :parens true)
                     (cat "call")]

                    ;; Default invocation
                    [true
                     ;; As we're invoking a known symbol here, we can do some fancy stuff. In this case, we just
                     ;; "inline" anything defined in library meta data (such as arithmetic operators).
                     (with (meta (and (= (scope/var-kind func) "native") (scope/var-native func)))
                       ;; Obviously metadata only exists for native expressions. We can only emit it if
                       ;; we're in the right context (statements cannot be emitted when we require an expression) and
                       ;; we've passed in the correct number of arguments.
                       (when (and meta
                                  (or
                                    ;; If we're binding to a variable then no need to emit fancy calls
                                    (native/native-bind-to meta)
                                    ;; If we're a statement in a non-statement context then emit a raw call.
                                    (and (not stmt) (native/native-syntax-stmt? meta))))
                         (set! meta nil))

                       (cond
                         [(and meta (if (native/native-syntax-fold meta)
                                      (>= (pred (n node)) (native/native-syntax-arity meta))
                                      (= (pred (n node)) (native/native-syntax-arity meta))))
                          (visit-nodes lookup state node 1 false)

                          ;; Mark child nodes as requiring parenthesis.
                          (with (prec (native/native-syntax-precedence meta))
                            (cond
                              [(list? prec) (add-parens lookup node 2 nil prec)]
                              [(number? prec) (add-parens lookup node 2 prec nil)]
                              [else])

                            (cat "call-meta"
                              :meta meta
                              :stmt (native/native-syntax-stmt? meta)
                              :prec (and (number? prec) prec)))]
                         [(and recur (= func (.> recur :var)))
                          (.<! recur :tail true)
                          (visit-nodes lookup state node 1 false)
                          (cat "call-tail" :recur recur :stmt true)]
                         [(and stmt (recur-direct? state func))
                          ;; We're the only invocation of a recursive function, so we can inline
                          ;; it in the codegen.
                          (let* [(rec (.> state :rec-lookup func))
                                 (lam (rec/rec-func-lambda rec))
                                 (recur (.> lookup lam :recur))]

                            (unless recur
                              (print! "Cannot find recursion for " (scope/var-name func)))

                            (for-each zip (zip-args (cadr lam) 1 node 2)
                              (let [(args (car zip))
                                    (vals (cadr zip))]
                                (cond
                                  [(= (n vals) 0)]
                                  ;; If we're binding multiple values or we're going to pack it,
                                  ;; then we'll have to emit an expression
                                  [(or (> (n vals) 1) (scope/var-variadic? (.> (car args) :var)))
                                   (for-each val vals (visit-node lookup state val false))]
                                  ;; Otherwise it's a simple binding, so we can emit it as a statement.
                                  [else (visit-node lookup state (car vals) true)])))

                            (.<! lookup (rec/rec-func-setter rec) (cat "void"))
                            (.<! state :var-skip func true)
                            (cat "call-recur" :recur recur))]
                         [true
                          (visit-nodes lookup state node 1 false)
                          (cat "call-symbol")]))]))]
               ["list"
                (cond
                  [(and
                     ;; Attempt to determine expressions of the form ((lambda (x) x) Y)
                     ;; where Y is an expression.
                     (= (n node) 2) (builtin? (car head) :lambda)
                     ;; One non-variadic argument
                     (= (n head) 3) (= (n (nth head 2)) 1)
                     (not (scope/var-variadic? (.> (car (nth head 2)) :var)))
                     ;; Whose body is just that variable.
                     (symbol? (nth head 3)) (= (.> (nth head 3) :var) (.> (car (nth head 2)) :var)))

                   ;; We now need to visit the child node.
                   (with (child-cat (visit-node lookup state (nth node 2) stmt test))
                     (if (.> child-cat :stmt)
                       (progn
                         (.<! lookup head (cat "lambda" :prec 100 :parens true))
                         (visit-node lookup state (nth head 3) true false)

                         ;; If we got a statement out of it, then we either need to emit
                         ;; our fancy let bindings or just a normal call.
                         (cat "call-lambda" :stmt stmt))
                       (cat "wrap-value")))]

                  [(and
                     ;; Attempt to determine expressions of the form ((lambda (&x) x) Y...)
                     ;; where Y are all expressions
                     (builtin? (car head) :lambda)
                     ;; One variadic argument
                     (= (n head) 3) (= (n (nth head 2)) 1)
                     (scope/var-variadic? (.> (car (nth head 2)) :var))
                     ;; Whose body is just that variable.
                     (symbol? (nth head 3)) (= (.> (nth head 3) :var) (.> (car (nth head 2)) :var))
                     ;; The last Y is a single return (or we have no values)
                     (or (= (n node) 1) (single-return? (last node))))

                   ;; We now need to visit the child node.
                   (with (node-stmt false)
                     (for i 2 (n node) 1
                       (with (child-cat (visit-node lookup state (nth node i) stmt test))
                         (when (and (.> child-cat :stmt) (not node-stmt))
                           (set! node-stmt true)
                           (.<! lookup head (cat "lambda" :prec 100 :parens true))
                           (visit-node lookup state (nth head 3) true false))))

                     ;; If we got a statement out of it, then we either need to emit
                     ;; our fancy let bindings or just a normal call.
                     (if node-stmt
                       (cat "call-lambda" :stmt stmt)
                       (cat "wrap-list" :prec 100)))]

                  [(and
                     ;; Attempt to determine expressions of the form ((lambda (x) (cond [x ...] ...)) Y)
                     ;; where Y is an expression.
                     ;; If the condition is an "and" or "or" on X, then we'll specialise into an and/or expression.
                     (= (n node) 2) (builtin? (car head) :lambda)
                     (= (n head) 3) (= (n (nth head 2)) 1)
                     (with (elem (nth head 3))
                       (and
                         ;; If we're a condition
                         (list? elem) (builtin? (car elem) :cond)
                         ;; And we branch on the given symbol
                         (symbol? (car (nth elem 2))) (= (.> (car (nth elem 2)) :var) (.> (car (nth head 2)) :var)))))

                  (with (child-cat (visit-node lookup state (nth node 2) stmt test))
                    (if (.> child-cat :stmt)
                      (progn
                        ;; We got a statement out of it, which means we cannot emit an "and" or "or".
                        ;; Instead we'll just emit a normal call-lambda/call.
                        (.<! lookup head (cat "lambda" :prec 100 :parens true))
                        (visit-node lookup state (nth head 3) true test recur)
                        (cat "call-lambda" :stmt stmt))
                      (let* [(res (.> (visit-node lookup state (nth head 3) true test recur)))
                             (ty (.> res :category))
                             (unused? (lambda ()
                                        ;; A rather horrible check to determine whether the variable is used within
                                        ;; an the branches: if so then we cannot convert it to an `and`/`or`.
                                        (let [(cond-node (nth head 3))
                                              (var (.> (car (nth head 2)) :var))
                                              (working true)]
                                          (for i 2 (n cond-node) 1
                                            (when working
                                              (with (case (nth cond-node i))
                                                (for i 2 (n case) 1
                                                  (when working
                                                    (with (sub (nth case i))
                                                      (unless (symbol? sub)
                                                        (set! working (not (node-contains-var? sub var))))))))))
                                          working)))]
                        ;; Otherwise we got an expression, so we'll see what we can do.
                        (.<! lookup head (cat "lambda" :prec 100 :parens true))
                        (cond
                          [(and (= ty "and") (unused?))
                           (add-paren lookup (nth node 2) 2)
                           (cat "and-lambda" :prec 2)]
                          [(and (= ty "or") (unused?))
                           (add-paren lookup (nth node 2) 1)
                           (cat "or-lambda" :prec 1 :kind (.> res :kind))]
                          [else (cat "call-lambda" :stmt stmt)]))))]

                  [(builtin? (car head) :lambda)
                   ;; Visit the lambda body
                   (visit-nodes lookup state head 3 true test recur)

                   ;; And visit the argument values
                   (for-each zip (zip-args (cadr head) 1 node 2)
                     (let [(args (car zip))
                           (vals (cadr zip))]
                       (cond
                         [(= (n vals) 0)]
                         ;; If we're binding multiple values or we're going to pack it,
                         ;; then we'll have to emit an expression
                         [(or (> (n vals) 1) (scope/var-variadic? (.> (car args) :var)))
                          (for-each val vals (visit-node lookup state val false))]
                         ;; Otherwise it's a simple binding, so we can emit it as a statement.
                         [else (visit-node lookup state (car vals) true)])))

                   (cat "call-lambda" :stmt stmt)]

                  [true
                    (visit-nodes lookup state node 1 false)
                    (add-paren lookup (car node) 100)
                    (cat "call")])]

               ;; We're probably calling a constant here.
               [_
                (visit-nodes lookup state node 1 false)
                (.<! lookup (car node) :parens true)
                (cat "call")]))]))
    (when (= cat nil) (fail! (.. "Node returned nil "(pretty node))))
    (.<! lookup node cat)
    cat))

(defun visit-nodes (lookup state nodes start stmt test recur)
  "Marks all NODES with a category."
  (with (len (n nodes))
    (for i start len 1
      (visit-node lookup state (nth nodes i) stmt
        (and test (= i len))
        (and (= i len) recur)))))

(defun visit-syntax-quote (lookup state node level)
  "Marks all syntax-quoted NODES with a category."
  :hidden
  (if (= level 0)
    (visit-node lookup state node false)
    (with (cat (case (type node)
                 ["string" (cat "quote-const")]
                 ["number" (cat "quote-const")]
                 ["key"    (cat "quote-const")]
                 ["symbol" (cat "quote-const")]
                 ["list"
                  (case (car node)
                    [unquote
                     (visit-syntax-quote lookup state (nth node 2) (pred level))
                     (cat "unquote")]
                    [unquote-splice
                     (visit-syntax-quote lookup state (nth node 2) (pred level))
                     (cat "unquote-splice")]
                    [syntax-quote
                     (for-each child node (visit-syntax-quote lookup state child (succ level)))
                     (cat "quote-list")]
                    [_
                     (with (has-splice false)
                       (for-each child node
                         (with (res (visit-syntax-quote lookup state child level))
                           (when (= (.> res :category) "unquote-splice")
                             (set! has-splice true))))
                       (if has-splice
                         (cat "quote-splice" :stmt true)
                         (cat "quote-list")))])]))
      (when (= cat nil) (fail! (.. "Node returned nil "(pretty node))))
      (.<! lookup node cat)
      cat)))

(defun visit-quote (lookup node)
  "Marks all quoted NODES with a category."
  :hidden
  (if (list? node)
    (progn
      (for-each child node (visit-quote lookup child))
      (.<! lookup node (cat "quote-list")))
    (.<! lookup node (cat "quote-const"))))

(defun visit-recur (lookup recur)
  "Attempts to categorise a recursive context."
  (let* [(lam (.> recur :def))
         (all-captured {})
         (arg-captured {})
         (rec-boundary (lambda (node)
                         (if (and (list? node) (builtin? (car node) :lambda))
                           (with (cat (.> lookup node))
                             (if (and cat (.> cat :recur))
                               false
                               true))
                           false)))]

    ;; First attempt to determine which loop variables are captured
    (for i 3 (n lam) 1
      (node-captured (nth lam i) all-captured rec-boundary))

    (for-each arg (cadr lam)
      (when (.> all-captured (.> arg :var))
        (.<! arg-captured (.> arg :var) (scope/temp-var (scope/var-name (.> arg :var))))))
    (.<! recur :captured arg-captured)

    (cond
      [(and
         ;; Check the lambda only has one expression
         (= (n lam) 3)
         (with (child (nth lam 3))
           (and
             ;; And that expression is a condition of the form (cond [EXPR X] [true Y])
             (list? child) (builtin? (car child) :cond) (= (n child) 3)
             (builtin? (car (nth child 3)) :true)
             (not (.> lookup (car (nth child 2)) :stmt)))))

       (let* [(fst-case (nth (nth lam 3) 2))
              (snd-case (nth (nth lam 3) 3))

              (fst (and (>= (n fst-case) 2) (just-recur? lookup (last fst-case) recur)))
              (snd (and (>= (n snd-case) 2) (just-recur? lookup (last snd-case) recur)))]
         (cond
           [(and fst snd) (.<! recur :category "forever")]
           [fst (.<! recur :category "while")]
           [snd (.<! recur :category "while-not")]
           [true (.<! recur :category "forever")]))]

      [true
       (.<! recur :category "forever")]))

  recur)

(defun just-recur? (lookup node recur)
  "Determine whether NODE is just calls to the recursive context RECUR."
  (if (list? node)
    (let [(cat (.> lookup node))
          (head (car node))]
      (cond
        ;; If we're a tail call then we're obviously not an exit.
        [(= (.> cat :category) "call-tail")
         (when (/= (.> cat :recur) recur) (error! "Incorrect recur"))
         true]

        ;; If we're a directly called lambda then check the last node is an exit node.
        [(and (list? head) (builtin? (car head) :lambda))
         (and (>= (n head) 3) (just-recur? lookup (last head) recur))]

        ;; If we're a condition, then check if any node is an exit node.
        [(builtin? head :cond)
         (with (found true)
           (for i 2 (n node) 1
             (when found
               ;; Something is an exit if the case is empty or contains an exit.
               (with (case (nth node i))
                 (set! found (and (>= (n case) 2) (just-recur? lookup (last case) recur))) head)))
           found)]

        ;; Otherwise we're not a tail-recursive function.
        [true false]))
    false))

(defun add-parens (lookup nodes start prec precs)
  "Add parentheses all child NODES starting from START if required."
  (for i start (n nodes) 1
    (with (child-cat (.> lookup (nth nodes i)))
      (when (and
              (.> child-cat :prec)
              (<= (.> child-cat :prec) (if precs (nth precs (pred i)) prec)))
        (.<! child-cat :parens true)))))

(defun add-paren (lookup node prec)
  "Add parentheses around a single NODE if required."
  (with (child-cat (.> lookup node))
    (when (and
            (.> child-cat :prec)
            (<= (.> child-cat :prec) prec))
      (.<! child-cat :parens true))))

(defpass categorise-nodes (compiler nodes state)
  "Categorise a group of NODES, annotating their appropriate node type."
  :cat '("categorise")
  (visit-nodes (.> state :cat-lookup) state nodes 1 true))

(defpass categorise-node (compiler node state stmt)
  "Categorise a NODE, annotating it's appropriate node type."
  :cat '("categorise")
  (visit-node (.> state :cat-lookup) state node stmt))
