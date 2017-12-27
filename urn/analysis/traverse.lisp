(import urn/resolve/builtins (builtin))
(import urn/resolve/scope scope)

(defun traverse-quote (node visitor level)
  (if (= level 0)
    (traverse-node node visitor)
    (with (tag (type node))
      (cond
        [(or (= tag "string") (= tag "number") (= tag "key") (= tag "symbol"))
         node]
        [(= tag "list")
         (with (first (nth node 1))
           (if (symbol? first)
             (cond
               [(or (= (.> first :contents) "unquote") (= (.> first :contents) "unquote-splice"))
                (.<! node 2 (traverse-quote (nth node 2) visitor (pred level)))
                node]
               [(= (.> first :contents) "syntax-quote")
                (.<! node 2 (traverse-quote (nth node 2) visitor (succ level)))
                node]
               [true
                 (for i 1 (n node) 1
                   (.<! node i (traverse-quote (nth node i) visitor level)))
                 node])
             (progn
               (for i 1 (n node) 1
                 (.<! node i (traverse-quote (nth node i) visitor level)))
               node)))]
        (error! (.. "Unknown tag " tag))))))

(defun traverse-node (node visitor)
  (with (tag (type node))
    (cond
      [(or (= tag "string") (= tag "number") (= tag "key") (= tag "symbol"))
       (visitor node visitor)]
      [(= tag "list")
       (with (first (car node))
         ;; Visit initial node
         (set! first (visitor first visitor))
         (.<! node 1 first)

         (if (symbol? first)
           (let* [(func (.> first :var))
                  (funct (scope/var-kind func))]
             (cond
               [(or (= funct "defined") (= funct "arg") (= funct "native") (= funct "macro"))
                (traverse-list node 1 visitor)
                (visitor node visitor)]
               [(= func (builtin :lambda))
                (traverse-block node 3 visitor)
                (visitor node visitor)]
               [(= func (builtin :cond))
                (for i 2 (n node) 1
                     (with (case (nth node i))
                           (.<! case 1 (traverse-node (nth case 1) visitor))
                           (traverse-block case 2 visitor)))
                (visitor node visitor)]
               [(= func (builtin :set!))
                (.<! node 3 (traverse-node (nth node 3) visitor))
                (visitor node visitor)]
               [(= func (builtin :quote))
                (visitor node visitor)]
               [(= func (builtin :syntax-quote))
                (.<! node 2 (traverse-quote (nth node 2) visitor 1))
                (visitor node visitor)]
               [(or (= func (builtin :unquote)) (= func (builtin :unquote-splice)))
                (fail! "unquote/unquote-splice should never appear head")]
               [(or (= func (builtin :define)) (= func (builtin :define-macro)))
                (.<! node (n node) (traverse-node (nth node (n node)) visitor))
                (visitor node visitor)]
               [(= func (builtin :define-native))
                (visitor node visitor)]
               [(= func (builtin :import))
                (visitor node visitor)]
               [(= func (builtin :struct-literal))
                (traverse-list node 2 visitor)
                (visitor node visitor)]
               [true
                 (fail! (.. "Unknown kind " funct " for variable " (scope/var-name func)))]))
           (progn
             (traverse-list node 1 visitor)
             (visitor node visitor))))]
      [true (error! (.. "Unknown tag " tag))])))


(defun traverse-block (node start visitor)
  "Traverse a block of nodes, starting from START."
  (with (offset 0)
    (for i start (n node) 1
      (with (result (traverse-node (nth node (+ i offset)) visitor))
        (.<! node i result))))
  node)

(defun traverse-list (node start visitor)
  "Traverse a list of nodes, starting from START."
  (for i start (n node) 1
    (.<! node i (traverse-node (nth node i) visitor)))
  node)
