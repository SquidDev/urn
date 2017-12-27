(import urn/resolve/builtins (builtin))
(import urn/resolve/scope scope)

(defun visit-quote (node visitor level)
  (if (= level 0)
    (visit-node node visitor)
    (with (tag (type node))
      (cond
        [(or (= tag "string") (= tag "number") (= tag "key") (= tag "symbol"))
         nil] ;; Skip: Nothing needs to be done for constant terms
        [(= tag "list")
         (with (first (nth node 1))
           (if (symbol? first)
             (cond
               [(or (= (.> first :contents) "unquote") (= (.> first :contents) "unquote-splice"))
                (visit-quote (nth node 2) visitor (pred level))]
               [(= (.> first :contents) "syntax-quote")
                (visit-quote (nth node 2) visitor (succ level))]
               [true
                 (for-each sub node (visit-quote sub visitor level))])
             (for-each sub node (visit-quote sub visitor level))))]
        (error! (.. "Unknown tag " tag))))))

(defun visit-node (node visitor)
  (unless (= (visitor node visitor) false)
    (with (tag (type node))
      (cond
        [(or (= tag "string") (= tag "number") (= tag "key") (= tag "symbol"))
         nil] ;; Skip: Nothing needs to be done for constant terms
        [(= tag "list")
         (with (first (nth node 1))
           (if (symbol? first)
             (let* [(func (.> first :var))
                    (funct (scope/var-kind func))]
               (cond
                 [(or (= funct "defined") (= funct "arg") (= funct "native") (= funct "macro"))
                  (visit-block node 1 visitor)]
                 [(= func (builtin :lambda))
                  (visit-block node 3 visitor)]
                 [(= func (builtin :cond))
                  (for i 2 (n node) 1
                       (with (case (nth node i))
                         (visit-node (nth case 1) visitor)
                         (visit-block case 2 visitor)))]
                 [(= func (builtin :set!))
                  (visit-node (nth node 3) visitor)]
                 [(= func (builtin :quote))] ;; Nothing needs doing here
                 [(= func (builtin :syntax-quote))
                  (visit-quote (nth node 2) visitor 1)]
                 [(or (= func (builtin :unquote)) (= func (builtin :unquote-splice)))
                  (fail! "unquote/unquote-splice should never appear here")]
                 [(or (= func (builtin :define)) (= func (builtin :define-macro)))
                  (visit-node (nth node (n node)) visitor)]
                 [(= func (builtin :define-native))] ;; Nothing needs doing here
                 [(= func (builtin :import))] ;; Nothing needs doing here
                 [(= func (builtin :struct-literal)) (visit-list node 2 visitor)]
                 [true
                   (fail! (.. "Unknown kind " funct " for variable " (scope/var-name func)))]))
             (visit-block node 1 visitor)))]
        [true (error! (.. "Unknown tag " tag))]))))

(defun visit-block (node start visitor)
  "Visit a block of nodes, starting from START."
  (for i start (n node) 1
    (visit-node (nth node i) visitor)))

(define visit-list visit-block)

(defun visit-blocks (nodes func)
  "Visit all blocks in NODES with FUNC. FUNC takes the
   form `(lambda (nodes start) ...)`."
  (func nodes 1)
  (visit-block nodes 1
    (lambda (node)
      (when (list? node)
        (with (head (car node))
          (when (symbol? head)
            (with (var (.> head :var))
              (cond
                [(= var (builtin :lambda)) (func node 3)]
                [(= var (builtin :cond))
                 (for i 2 (n node) 1
                   (func (nth node i) 2))]
                [true])))))
      nil)))
