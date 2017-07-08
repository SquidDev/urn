(import urn/analysis/nodes ())
(import urn/analysis/pass ())
(import urn/analysis/vars ())
(import urn/analysis/visitor visitor)
(import urn/range range)

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
    (and rec (= (.> rec :var) 0) (= (.> rec :direct) 1))))

(defun var-excluded? (state var)
  "Determine whether we will exclude all bindings for VAR."
  (recur-direct? state var))

(defun visit-node (lookup state node stmt test recur)
  "Marks a specific NODE with a category.

   STMT marks whether this node is in a \"statement\" context. This is any node
   for which we are capable of generating a statement: namely any
   block (assignments, returns, simple calls) or the condition inside a `cond`.

   TEST marks whether this node is in a \"test\" context. This is any node which
   is used directly or indirectly inside a condition test."
  (with (cat (case (type node)
          ["string" (cat "const")]
          ["number" (cat "const")]
          ["key"    (cat "const")]
          ["symbol" (cat "const")]
          ["list"
           (with (head (car node))
             (case (type head)
               ["symbol"
                (let* [(func (.> head :var))
                       (funct (.> func :tag))]
                  (cond
                    ;; Handle all special forms
                    [(= func (.> builtins :lambda))
                     (visit-nodes lookup state node 3 true)
                     (cat "lambda")]
                    [(= func (.> builtins :cond))
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
                          ;; If the first condition is of the form `[A false]`
                          (with (sub (nth node 2))
                            (and (= (n sub) 2) (builtin? (nth sub 2) :false)))
                          (with (sub (nth node 3))
                            (and (= (n sub) 2) (builtin? (nth sub 1) :true) (builtin? (nth sub 2) :true))))

                        (add-paren lookup (car (nth node 2)) 11)
                        (cat "not" :stmt (.> lookup (car (nth node 2)) :stmt) :prec 11)]

                       [(and
                          ;; If we have two conditions
                          (= (n node) 3)
                          ;; If the first condition is of the form `[A <expr>]`
                          ;; The second one is of the form `[true A]` (or `[true false]`
                          ;; when in a condition test).
                          (let* [(first (nth node 2))
                                 (second (nth node 3))
                                 (branch (car first))
                                 (last (nth second 2))]
                            (and
                              (= (n first) 2) (= (n second) 2)
                              (! (.> lookup (nth first 2) :stmt)) (builtin? (car second) :true)
                              (symbol? last)
                              (or
                                (and (symbol? branch) (= (.> branch :var) (.> last :var)))
                                (and test (! (.> lookup branch :stmt)) (= (.> last :var) (.> builtins :false)))))))

                        (add-paren lookup (nth (nth node 2) 1) 2) ;; (case [A _] [true A])
                        (add-paren lookup (nth (nth node 2) 2) 2) ;; (case [_ B] [true _])

                        (cat "and" :prec 2)]

                       [(and
                          ;; If we have at least two conditions.
                          (>= (n node) 3)
                          ;; Each condition follows the form `[x x]` (or [x true] if when
                          ;; in a condition test).
                          (part-all node 2 (pred (n node))
                            (lambda (branch)
                              (let* [(head (car branch))
                                     (tail (nth branch 2))]
                                (and (= (n branch) 2) (symbol? tail)
                                  (or
                                    (and (symbol? head) (= (.> head :var) (.> tail :var)))
                                    (and test (! (.> lookup head :stmt)) (= (.> tail :var) (.> builtins :true))))))))
                          ;; Apart from the last one, which is `[true <expr>]`.
                          (with (branch (last node))
                            (and (= (n branch) 2) (builtin? (car branch) :true) (! (.> lookup (nth branch 2) :stmt)))))

                        (with (len (n node))
                          (for i 2 len 1
                            (add-paren lookup (nth (nth node i) (if (= i len) 2 1)) 1)))
                        (cat "or" :prec 1)]

                       [true (cat "cond" :stmt true)])]
                    [(= func (.> builtins :set!))
                     (let [(def (nth node 3))
                           (var (.> (nth node 2) :var))]
                       (if (and
                             (list? def) (builtin? (car def) :lambda)
                             (.> state :rec-lookup var))
                         (with (recur { :var var :def def })
                           (visit-nodes lookup state def 3 true nil recur)
                           (unless (.> recur :tail) (error! "Expected tail recursive function from letrec"))
                           (.<! lookup def (cat "lambda" :recur (visit-recur lookup recur))))
                         (visit-node lookup state def true)))
                     (cat "set!")]
                    [(= func (.> builtins :quote))
                     (visit-quote lookup node)
                     (cat "quote")]
                    [(= func (.> builtins :syntax-quote))
                     (visit-syntax-quote lookup state (nth node 2) 1)
                     (cat "syntax-quote")]
                    [(= func (.> builtins :unquote)) (fail! "unquote should never appear")]
                    [(= func (.> builtins :unquote-splice)) (fail! "unquote should never appear")]
                    [(or (= func (.> builtins :define)) (= func (.> builtins :define-macro)))
                     (with (def (nth node (n node)))
                       (if (and (list? def) (builtin? (car def) :lambda))
                         (with (recur { :var (.> node :def-var) :def def})
                           (visit-nodes lookup state def 3 true nil recur)
                           (.<! lookup def (if (.> recur :tail)
                                             (cat "lambda" :recur (visit-recur lookup recur))
                                             (cat "lambda"))))
                         (visit-node lookup state def true)))
                     (cat "define")]
                    [(= func (.> builtins :define-native)) (cat "define-native")]
                    [(= func (.> builtins :import)) (cat "import")]
                    [(= func (.> builtins :struct-literal))
                     (visit-nodes lookup state node 2 false)
                     (cat "struct-literal")]

                    ;; Handle things like `("foo")`
                    [(= func (.> builtins :true))
                     (visit-nodes lookup state node 1 false)
                     (cat "call-literal")]
                    [(= func (.> builtins :false))
                     (visit-nodes lookup state node 1 false)
                     (cat "call-literal")]
                    [(= func (.> builtins :nil))
                     (visit-nodes lookup state node 1 false)
                     (cat "call-literal")]

                    ;; Default invocation
                    [true
                     ;; As we're invoking a known symbol here, we can do some fancy stuff. In this case, we just
                     ;; "inline" anything defined in library meta data (such as arithmetic operators).
                     (let* [(meta (and (= (.> func :tag) "native") (.> state :meta (.> func :full-name))))
                            (meta-ty (type meta))]
                       ;; Obviously metadata only exists for native expressions. We can only emit it if
                       ;; we're in the right context (statements cannot be emitted when we require an expression) and
                       ;; we've passed in the correct number of arguments.
                       (case meta-ty
                         ["nil"]
                         ["boolean"]
                         ["expr"]
                         ["stmt"
                          ;; Cannot use statements if we're in an expression
                          (unless stmt (set! meta nil))]
                         ["var"
                          ;; We'll have cached the global lookup above
                          (set! meta nil)])

                       (cond
                         [(and meta (if (.> meta :fold)
                                      (>= (pred (n node)) (.> meta :count))
                                      (= (pred (n node)) (.> meta :count))))
                          (visit-nodes lookup state node 1 false)

                          ;; Mark child nodes as requiring parenthesis.
                          (let* [(prec (.> meta :prec))
                                 (precs (.> meta :precs))]
                            (when (or prec precs) (add-parens lookup node 2 prec precs))

                            (cat "call-meta" :meta meta :stmt (= meta-ty "stmt") :prec prec))]
                         [(and recur (= func (.> recur :var)))
                          (.<! recur :tail true)
                          (visit-nodes lookup state node 1 false)
                          (cat "call-tail" :recur recur :stmt true)]
                         [(and stmt (recur-direct? state func))
                          ;; We're the only invocation of a recursive function, so we can inline
                          ;; it in the codegen.
                          (let* [(rec (.> state :rec-lookup func))
                                 (lam (.> rec :lambda))
                                 (args (nth lam 2))
                                 (offset 1)
                                 (recur (.> lookup lam :recur))]

                            (unless recur
                              (print! "Cannot find recursion for " (.> func :name)))

                            ;; And visit the argument values
                            (for i 1 (n args) 1
                              (with (arg (nth args i))
                                (if (.> arg :var :is-variadic)
                                  (with (count (- (n node) (n args)))
                                    (when (< count 0) (set! count 0))
                                    (for j 1 count 1
                                      (visit-node lookup state (nth node (+ i j)) false))
                                    (set! offset count))
                                  (when-with (val (nth node (+ i offset)))
                                    (visit-node lookup state val true)))))
                            ;; Visit the remaining arguments
                            (for i (+ (n args) (+ offset 1)) (n node) 1
                              (visit-node lookup state (nth node i) true))

                            (.<! lookup (.> rec :set!) (cat "void"))
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
                     (= (n head) 3) (= (n (nth head 2)) 1)
                     (symbol? (nth head 3)) (= (.> (nth head 3) :var) (.> (car (nth head 2)) :var)))

                   ;; We now need to visit the child node.
                   (with (child-cat (visit-node lookup state (nth node 2) stmt test))
                     (if (.> child-cat :stmt)
                       (progn
                         (visit-node lookup state head true)
                         ;; If we got a statement out of it, then we either need to emit
                         ;; our fancy let bindings or just a normal call.
                         (if stmt
                           (cat "call-lambda" :stmt true)
                           (cat "call")))
                       (cat "wrap-value")))]

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
                        (.<! lookup head (cat "lambda"))
                        (visit-node lookup state (nth head 3) true test recur)
                        (if stmt
                          (cat "call-lambda" :stmt true)
                          (cat "call")))
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
                                                        (set! working (! (node-contains-var? sub var))))))))))
                                          working)))]
                        ;; Otherwise we got an expression, so we'll see what we can do.
                        (.<! lookup head (cat "lambda"))
                        (cond
                          [(and (= ty "and") (unused?))
                           (add-paren lookup (nth node 2) 2)
                           (cat "and-lambda" :prec 2)]
                          [(and (= ty "or") (unused?))
                           (add-paren lookup (nth node 2) 1)
                           (cat "or-lambda" :prec 1)]
                          [stmt (cat "call-lambda" :stmt true)]
                          [true (cat "call")]))))]

                  [(and stmt (builtin? (car head) :lambda))
                   ;; Visit the lambda body
                   (visit-nodes lookup state (car node) 3 true test recur)

                   ;; And visit the argument values
                   ;; Yay: My favourite bit of code, zipping over arguments
                   ;; No seriously: I need to write an abstraction layer at some point for this.
                   (let* [(lam (car node))
                          (args (nth lam 2))
                          (offset 1)]
                     (for i 1 (n args) 1
                       (with (arg (nth args i))
                         (if (.> arg :var :is-variadic)
                           (with (count (- (n node) (n args)))
                             (when (< count 0) (set! count 0))
                             (for j 1 count 1
                               (visit-node lookup state (nth node (+ i j)) false))
                             (set! offset count))
                           (when-with (val (nth node (+ i offset)))
                             (visit-node lookup state val true)))))
                     (for i (+ (n args) (+ offset 1)) (n node) 1
                       (visit-node lookup state (nth node i) true))

                     (cat "call-lambda" :stmt true))]
                  [(or (builtin? (car head) :quote) (builtin? (car head) :syntax-quote))
                   (visit-nodes lookup state node 1 false)
                   (cat "call-literal")]
                  [true
                    (visit-nodes lookup state node 1 false)
                    (add-paren lookup (car node) 100)
                    (cat "call")])]

               ;; We're probably calling a constant here.
               [true
                (visit-nodes lookup state node 1 false)
                (cat "call-literal")]))]))
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
  (with (lam (.> recur :def))
    (cond
      [(and
         ;; Check the lambda only has one expression
         (= (n lam) 3)
         (with (child (nth lam 3))
           (and
             ;; And that expression is a condition of the form (cond [EXPR X] [true Y])
             (list? child) (builtin? (car child) :cond) (= (n child) 3)
             (builtin? (car (nth child 3)) :true)
             (! (.> lookup (car (nth child 2)) :stmt)))))

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
