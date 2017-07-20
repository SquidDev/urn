(import extra/assert ())
(import extra/term (colored))
(import lua/basic (type# slice))

(import urn/backend/lua/emit lua)
(import urn/backend/lua/escape lua)
(import urn/backend/lua lua)
(import urn/backend/writer writer)
(import urn/logger/void logger)
(import urn/timer timer)
(import urn/resolve/builtins builtins)
(import urn/resolve/loop resolve)
(import urn/resolve/scope scope)

(define start-range
  "The default range for all objects"
  :hidden
  { :name  "init.lisp"
    :lines  '(";; Empty")
    :start  { :line 1 :column 1 }
    :finish { :line 1 :column 1 } })

(defun wrap-node (node)
  "Wraps a NODE, converting it into something usable by [[resolve/compile]]."
  :hidden
  (case (type# node)
    ["number" { :tag "number" :value node :range start-range }]
    ["string" { :tag "string" :value node :range start-range }]
    ["table"
     (.<! node :range start-range)
     (when (list? node)
       (for i 1 (n node) 1
         (.<! node i (wrap-node (nth node i)))))
     node]))

(defun diff-lines (old new out)
  "Diff the strings in OLD to NEW, writing the result to OUT."
  (with (old-map {})
    (for i 1 (n old) 1
      (with (list (.> old-map (nth old i)))
        (unless list
          (set! list '())
          (.<! old-map (nth old i) list))
        (push-cdr! list (pred i))))

    (let [(overlap '())
          (sub-start-old 0)
          (sub-start-new 0)
          (sub-length 0)]
      (for idx 1 (n new) 1
        (let [(val (nth new idx))
              (inew (pred idx))
              (sub-overlap {})]
          (when-with (old-vals (.> old-map val))
            (for-each iold old-vals
              (if (<= iold 0)
                (.<! sub-overlap iold 1)
                (.<! sub-overlap iold (succ (or (.> overlap (pred iold)) 0))))
              (when (> (.> sub-overlap iold) sub-length)
                (set! sub-length (.> sub-overlap iold))
                (set! sub-start-old (succ (- iold sub-length)))
                (set! sub-start-new (succ (- inew sub-length))))))
          (set! overlap sub-overlap)))

      (if (= sub-length 0)
        (progn
          (for-each elem old (push-cdr! out (colored 31 (.. "- " elem))))
          (for-each elem new (push-cdr! out (colored 32 (.. "+ " elem)))))
        (progn
          (diff-lines
            (slice old 1 sub-start-old)
            (slice new 1 sub-start-new)
            out)

          (for i (succ sub-start-new ) (+ sub-start-new sub-length) 1
            (push-cdr! out (.. "  " (nth new i))))

          (diff-lines
            (slice old (+ sub-start-old sub-length 1))
            (slice new (+ sub-start-new sub-length 1))
            out))))))

(defun affirm-codegen (input-nodes expected-src)
  "Affirm compiling INPUT-NODES generates EXPECTED-SRC."
  (let [(scope (builtins/create-scope))
        (compiler { :log           logger/void
                    :timer         (timer/create (lambda ()))
                    :variables     {}
                    :states        {}
                    :compile-state (lua/create-state
                                     { :+       { :tag "expr" :contents '(1 " + " 2) :count 2 :fold "l" :prec 9 }
                                       :-       { :tag "expr" :contents '(1 " - " 2) :count 2 :fold "l" :prec 9 }
                                       :..      { :tag "expr" :contents '(1 " .. " 2) :count 2 :fold "r" :prec 8 }
                                       :get-idx { :tag "expr" :contents '(1 "[" 2 "]") :count 2 :precs '(100 0) }
                                       :print   { :tag "var" :contents "print" } })
                    :loader        (lambda (name) (fail! $"Cannot load external module '${name}'")) })
        (writer (writer/create))]
    (for-each var '("foo" "bar" "baz" "qux" "+" "-" ".." "get-idx" "print")
      (lua/push-escape-var! (scope/add! scope var "native") (.> compiler :compile-state)))

    (for-pairs (_ var) (.> scope :parent :variables) (.<! compiler :variables (tostring var) var))
    (for-pairs (_ var) (.> scope :variables) (.<! compiler :variables (tostring var) var))

    (with (resolved (resolve/compile
                      compiler
                      (wrap-node input-nodes)
                      scope
                      "init.lisp"))
      (lua/block resolved writer (.> compiler :compile-state) 1 "return ")

      (with (res (string/trim (string/gsub (writer/->string writer) "\t" "  ")))
        (when (/= res expected-src)
          (with (out '())
            (push-cdr! out (.. "Unexpected result compiling " (pretty input-nodes)))
            (diff-lines (string/split expected-src "\n") (string/split res "\n") out)
            (fail! (concat out "\n"))))))))

(defun affirm-codegen* (input-nodes expected-src)
  "Affirm compiling INPUT-NODES generates EXPECTED-SRC.

   Unlike [[affirm-codegen]], this will not resolve the nodes."
  (with (writer (writer/create))
    (lua/block (wrap-node input-nodes) writer (lua/create-state {}) 1 "return ")

    (with (res (string/trim (string/gsub (writer/->string writer) "\t" "  ")))
      (when (/= res expected-src)
        (with (out '())
          (push-cdr! out (.. "Unexpected result compiling " (pretty input-nodes)))
          (diff-lines (string/split expected-src "\n") (string/split res "\n") out)
          (fail! (concat out "\n")))))))
