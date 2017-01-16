(define builtins (.> (require "tacky.analysis.resolve") :builtins))

(defun visit-quote (node visitor level)
  (if (= level 0)
    (visit-node node visitor)
    (with (tag (.> node :tag))
      (cond
        ((or (= tag "string") (= tag "number") (= tag "key") (= tag "symbol"))
          nil) ;; Skip: Nothing needs to be done for constant terms
        ((= tag "list")
          (with (first (nth node 1))
            (if (and first (= (.> first :tag) "symbol"))
              (cond
                ((or (= (.> first :contents) "unquote") (= (.> first :contents) "unquote-splice"))
                  (visit-quote (nth node 2) visitor (pred level)))
                ((= (.> first :contents) "quasiquote")
                  (visit-quote (nth node 2) visitor (succ level)))
                (true
                  (for-each sub node (visit-quote sub visitor level))))
              (for-each sub node (visit-quote sub visitor level)))))
        (error! (.. "Unknown tag " tag))))))

(defun visit-node (node visitor)
  (unless (= (visitor node) false)
    (with (tag (.> node :tag))
      (cond
        ((or (= tag "string") (= tag "number") (= tag "key") (= tag "symbol"))
          nil) ;; Skip: Nothing needs to be done for constant terms
        ((= tag "list")
          (with (first (nth node 1))
            (if (and first (= (.> first :tag) "symbol"))
              (let* ((func (.> first :var))
                     (funct (.> func :tag)))
                (cond
                  ((= func (.> builtins :lambda))
                    (visit-block node 3 visitor))
                  ((= func (.> builtins :cond))
                    (for i 2 (# node) 1
                      (with (case (nth node i))
                        (visit-node (nth case 1) visitor)
                        (visit-block case 2 visitor))))
                  ((= func (.> builtins :set!))
                    (visit-node (nth node 3) visitor))
                  ((= func (.> builtins :quote))) ;; Nothing needs doing here
                  ((= func (.> builtins :quasiquote))
                    (visit-quote (nth node 2) visitor 1))
                  ((or (= func (.> builtins :unquote)) (= func (.> builtins :unquote-splice)))
                    (fail "unquote/unquote-splice should never appear head"))
                  ((or (= func (.> builtins :define)) (= func (.> builtins :define-macro)))
                    (visit-block node 3 visitor))
                  ((= func (.> builtins :define-native))) ;; Nothing needs doing here
                  ((= func (.> builtins :import))) ;; Nothing needs doing here
                  ((= funct "macro") (fail "Macros should have been expanded"))
                  ((or (= funct "defined") (= funct "arg") (= funct "native"))
                    (visit-block node 1 visitor))
                  (true
                    (fail (.. "Unknown kind " funct " for variable " (.> func :name))))))
              (visit-block node 1 visitor))))
        (true (error! (.. "Unknown tag " tag)))))))


;; Visit a list of nodes
(defun visit-block (node start visitor)
  (for i start (# node) 1
    (visit-node (nth node i) visitor)))

(struct
  :visitNode  visit-node
  :visitBlock visit-block
  :visitList  visit-block)
