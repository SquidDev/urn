(define builtins (.> (require "tacky.analysis.resolve") :builtins))

(defun traverse-quote (node visitor level)
  (if (= level 0)
    (traverse-node node visitor)
    (with (tag (.> node :tag))
      (cond
        [(or (= tag "string") (= tag "number") (= tag "key") (= tag "symbol"))
         node]
        [(= tag "list")
         (with (first (nth node 1))
               (if (and first (= (.> first :tag) "symbol"))
                 (cond
                   [(or (= (.> first :contents) "unquote") (= (.> first :contents) "unquote-splice"))
                    (.<! node 2 (traverse-quote (nth node 2) visitor (pred level)))
                    node]
                   [(= (.> first :contents) "quasiquote")
                    (.<! node 2 (traverse-quote (nth node 2) visitor (succ level)))
                    node]
                   [true
                     (for i 1 (# node) 1
                          (.<! node i (traverse-quote (nth node i) visitor level)))
                     node])
                 (progn
                   (for i 1 (# node) 1
                        (.<! node i (traverse-quote (nth node i) visitor level)))
                   node)))]
        (error! (.. "Unknown tag " tag))))))

(defun traverse-node (node visitor)
  (with (tag (.> node :tag))
    (cond
      [(or (= tag "string") (= tag "number") (= tag "key") (= tag "symbol"))
       (visitor node visitor)]
      [(= tag "list")
       (with (first (car node))
             ;; Visit initial node
             (set! first (visitor first visitor))
             (.<! node 1 first)

             (if (= (.> first :tag) "symbol")
               (let* [(func (.> first :var))
                      (funct (.> func :tag))]
                 (cond
                   [(= func (.> builtins :lambda))
                    (traverse-block node 3 visitor)
                    (visitor node visitor)]
                   [(= func (.> builtins :cond))
                    (for i 2 (# node) 1
                         (with (case (nth node i))
                               (.<! case 1 (traverse-node (nth case 1) visitor))
                               (traverse-block case 2 visitor)))
                    (visitor node visitor)]
                   [(= func (.> builtins :set!))
                    (.<! node 3 (traverse-node (nth node 3) visitor))
                    (visitor node visitor)]
                   [(= func (.> builtins :quote))
                    (visitor node visitor)]
                   [(= func (.> builtins :quasiquote))
                    (.<! node 2 (traverse-quote (nth node 2) visitor 1))
                    (visitor node visitor)]
                   [(or (= func (.> builtins :unquote)) (= func (.> builtins :unquote-splice)))
                    (fail! "unquote/unquote-splice should never appear head")]
                   [(or (= func (.> builtins :define)) (= func (.> builtins :define-macro)))
                    (.<! node (# node) (traverse-node (nth node (# node)) visitor))
                    (visitor node visitor)]
                   [(= func (.> builtins :define-native))
                    (visitor node visitor)]
                   [(= func (.> builtins :import))
                    (visitor node visitor)]
                   [(or (= funct "defined") (= funct "arg") (= funct "native") (= funct "macro"))
                    (traverse-list node 1 visitor)
                    (visitor node visitor)]
                   [true
                     (fail! (.. "Unknown kind " funct " for variable " (.> func :name)))]))
               (progn
                 (traverse-list node 1 visitor)
                 (visitor node visitor))))]
      [true (error! (.. "Unknown tag " tag))])))


;; Visit a block, simplifying trivial nodes
(defun traverse-block (node start visitor)
  (with (offset 0)
    (for i start (# node) 1
      (with (result (traverse-node (nth node (+ i offset)) visitor))
        ;; TODO: Inline expressions of the form ((lambda () ...))
        (.<! node i result))))
  node)

;; Visit a list of nodes
(defun traverse-list (node start visitor)
  (for i start (# node) 1
    (.<! node i (traverse-node (nth node i) visitor)))
  node)
