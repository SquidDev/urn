(import urn/analysis/nodes ())
(import urn/analysis/pass ())
(import urn/analysis/visitor visitor)

(defun node-contains-var? (node var)
  "Determine whether NODE contains a reference to the given VAR."
  :hidden
  (with (found false)
    (visitor/visit-node node
      (lambda (node)
        (cond
          [found false]
          [(symbol? node) (set! found (= var (.> node :var)))]
          [true])))
    found))

(defun nodes-contain-var? (node start var)
  "Determine whether the NODES starting from START contain the given
   VAR."
  :hidden
  (with (found false)
    (visitor/visit-list start node
      (lambda (node)
        (cond
          [found false]
          [(symbol? node) (set! found (= var (.> node :var)))]
          [true])))
    found))

(defun cat (category &args)
  "Create a CATEGORY data set, using ARGS as additional parameters to [[struct]]."
  (struct
    :category category
    (unpack args 1 (n args))))

(defun part-all (xs i e f)
  "An implementation of [[all]] which just goes between I and E."
  :hidden
  (cond
    [(> i e) true]
    [(f (nth xs i)) (part-all xs (+ i 1) e f)]
    [true false]))

(defun visit-node (lookup node stmt test recur)
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
                     (visit-nodes lookup node 3 true)
                     (cat "lambda")]
                    [(= func (.> builtins :cond))
                     ;; Visit all conditions inside the node. It maybe seem
                     ;; weird that we consider the condition as a statement, but
                     ;; we have enough flexibility at codegen time to allow it to
                     ;; be.
                     (for i 2 (n node) 1
                       (with (case (nth node i))
                         (visit-node lookup (car case) true true)
                         (visit-nodes lookup case 2 true test recur)))

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
                        (cat "not" :stmt (.> lookup (car (nth node 2)) :stmt))]

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
                        (cat "and")]

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
                        (cat "or")]

                       [true (cat "cond" :stmt true)])]
                    [(= func (.> builtins :set!))
                     (visit-node lookup (nth node 3) true)
                     (cat "set!")]
                    [(= func (.> builtins :quote))
                     (visit-quote lookup node)
                     (cat "quote")]
                    [(= func (.> builtins :syntax-quote))
                     (visit-syntax-quote lookup (nth node 2) 1)
                     (cat "syntax-quote")]
                    [(= func (.> builtins :unquote)) (fail! "unquote should never appear")]
                    [(= func (.> builtins :unquote-splice)) (fail! "unquote should never appear")]
                    [(or (= func (.> builtins :define)) (= func (.> builtins :define-macro)))
                     (with (def (nth node (n node)))
                       (if (and (list? def) (builtin? (car def) :lambda))
                         (with (recur { :var (.> node :defVar) :def def})
                           (visit-nodes lookup def 3 true nil recur)
                           (.<! lookup def (if (.> recur :tail)
                                             (cat "lambda" :recur recur)
                                             (cat "lambda"))))
                         (visit-node lookup def true)))
                     (cat "define")]
                    [(= func (.> builtins :define-native)) (cat "define-native")]
                    [(= func (.> builtins :import)) (cat "import")]
                    [(= func (.> builtins :struct-literal))
                     (visit-nodes lookup node 2 false)
                     (cat "struct-literal")]

                    ;; Handle things like `("foo")`
                    [(= func (.> builtins :true))
                     (visit-nodes lookup node 1 false)
                     (cat "call-literal")]
                    [(= func (.> builtins :false))
                     (visit-nodes lookup node 1 false)
                     (cat "call-literal")]
                    [(= func (.> builtins :nil))
                     (visit-nodes lookup node 1 false)
                     (cat "call-literal")]

                    ;; Default invocation
                    [true
                     (visit-nodes lookup node 1 false)
                     (if (and recur (= func (.> recur :var)))
                       (progn
                         (.<! recur :tail true)
                         (cat "call-symbol" :recur recur :stmt recur))
                       (cat "call-symbol"))]))]
               ["list"
                (cond
                  [(and
                     ;; Attempt to determine expressions of the form ((lambda (x) x) Y)
                     ;; where Y is an expression.
                     (= (n node) 2) (builtin? (car head) :lambda)
                     (= (n head) 3) (= (n (nth head 2)) 1)
                     (symbol? (nth head 3)) (= (.> (nth head 3) :var) (.> (car (nth head 2)) :var)))

                   ;; We now need to visit the child node.
                   (with (child-cat (visit-node lookup (nth node 2) stmt test))
                     (if (.> child-cat :stmt)
                       (progn
                         (visit-node lookup head true)
                         ;; If we got a statement out of it, then we either need to emit
                         ;; our fancy let bindings or just a normal call.
                         (if stmt
                           (cat "call-lambda" :stmt true)
                           (cat "call")))
                       (cat "wrap-value")))]

                  [(and
                     ;; Attempt to determine expressions of the form ((lambda (x) (cond ...)) Y)
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

                  (with (child-cat (visit-node lookup (nth node 2) stmt test))
                    (if (.> child-cat :stmt)
                      (progn
                        ;; We got a statement out of it, which means we cannot emit an "and" or "or".
                        ;; Instead we'll just emit a normal call-lambda/call.
                        (.<! lookup head (cat :lambda))
                        (for i 3 (n head) 1
                          (visit-node lookup (nth head i) true test))
                        (if stmt
                          (cat "call-lambda" :stmt true)
                          (cat "call")))
                      (let* [(res (.> (visit-node lookup (nth head 3) true test)))
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
                        (.<! lookup head (cat :lambda))
                        (cond
                          [(and (= ty "and") (unused?)) (cat "and-lambda")]
                          [(and (= ty "or")  (unused?)) (cat "or-lambda")]
                          [stmt (cat "call-lambda" :stmt true)]
                          [true (cat "call")]))))]

                  [(and stmt (builtin? (car head) :lambda))
                   ;; Visit the lambda body
                   (visit-nodes lookup (car node) 3 true test recur)

                   ;; And visit the argument values
                   ;; Yay: My favourite bit of code, zipping over arguments
                   ;; No seriously: I need to write an abstraction layer at some point for this.
                   (let* [(lam (car node))
                          (args (nth lam 2))
                          (offset 1)]
                     (for i 1 (n args) 1
                       (with (arg (nth args i))
                         (if (.> arg :var :isVariadic)
                           (with (count (- (n node) (n args)))
                             (when (< count 0) (set! count 0))
                             (for j 1 count 1
                               (visit-node lookup (nth node (+ i j)) false))
                             (set! offset count))
                           (when-with (val (nth node (+ i offset)))
                             (visit-node lookup val true)))))
                     (for i (+ (n args) (+ offset 1)) (n node) 1
                       (visit-node lookup (nth node i) true))

                     (cat "call-lambda" :stmt true))]
                  [(or (builtin? (car head) :quote) (builtin? (car head) :syntax-quote))
                   (visit-nodes lookup node 1 false)
                   (cat "call-literal")]
                  [true
                    (visit-nodes lookup node 1 false)
                    (cat "call")])]

               ;; We're probably calling a constant here.
               [true
                (visit-nodes lookup node 1 false)
                (cat "call-literal")]))]))
    (when (= cat nil) (fail! (.. "Node returned nil "(pretty node))))
    (.<! lookup node cat)
    cat))

(defun visit-nodes (lookup nodes start stmt test recur)
  "Marks all NODES with a category."
  (with (len (n nodes))
    (for i start len 1
      (visit-node lookup (nth nodes i) stmt
        (and test (= i len))
        (and (= i len) recur)))))

(defun visit-syntax-quote (lookup node level)
  "Marks all syntax-quoted NODES with a category."
  :hidden
  (if (= level 0)
    (visit-node lookup node false)
    (with (cat (case (type node)
                 ["string" (cat "quote-const")]
                 ["number" (cat "quote-const")]
                 ["key"    (cat "quote-const")]
                 ["symbol" (cat "quote-const")]
                 ["list"
                  (case (car node)
                    [unquote
                     (visit-syntax-quote lookup (nth node 2) (pred level))
                     (cat "unquote")]
                    [unquote-splice
                     (visit-syntax-quote lookup (nth node 2) (pred level))
                     (cat "unquote-splice")]
                    [syntax-quote
                     (for-each child node (visit-syntax-quote lookup child (succ level)))
                     (cat "quote-list")]
                    [_
                     (with (has-splice false)
                       (for-each child node
                         (with (res (visit-syntax-quote lookup child level))
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

(defpass categorise-nodes (state nodes lookup)
  "Categorise a group of NODES, annotating their appropriate node type."
  :cat '("categorise")
  (visit-nodes lookup nodes 1 true))

(defpass categorise-node (state node lookup stmt)
  "Categorise a NODE, annotating it's appropriate node type."
  :cat '("categorise")
  (visit-node lookup node stmt))
