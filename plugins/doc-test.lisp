(import compiler/resolve _)
(import compiler _)
(import urn/documentation _)
(import urn/parser _/parser)
(import extra/test _/test)
(import extra/assert _/test)

,(string/quoted "hello")

(defun _/var-warning! (var msg)
  :hidden
  (_/logger/put-node-warning! msg
    (_/var-definition var) nil (_/range/get-source (_/var-definition var)) ""))

(defun _/var-error! (var msg)
  :hidden
  (_/logger/do-node-error! msg
    (_/var-definition var) nil (_/range/get-source (_/var-definition var)) ""))

(defun _/subst (tree vars)
  "Substitute the variables in TREE with VARS."
  :hidden
  (case (type tree)
    ["symbol" (or (.> vars (symbol->string tree)) tree)]
    ["list"
     (for i 1 (n tree) 1
       (.<! tree i (_/subst (nth tree i) vars)))
     tree]
    [_ tree]))

(defun _/build-vars ()
  :hidden
  (let* [(top-level '())
         (tests `(_/test/describe "The stdlib"))]

    (for-pairs (k v) (_/scope-vars)
      (unless (string/starts-with? k "_/")
        (with (docs (-> (or (_/var-docstring v) "")
                      _/parse-docstring
                      (filter (lambda (x) (and (= (type x) "mono") (string/starts-with? (.> x :whole) "```"))) <>)
                      (map (cut .> <> :contents) <>)))
          (for-each entry docs
            (with (lines (string/split entry "\n"))
              (cond
                ;; Just do a couple of sanity checks on the code
                [(empty? lines) (_/var-warning! v "This example is empty.")]
                [(/= (string/char-at (car lines) 1) ">") (_/var-warning! v "Example is expected to begin with \">\".")]
                ;; Everything is OK so let's build a list
                [true
                 (let* [(asserts `(_/test/it ,$"has tests for ${k}"))
                        (subst {})
                        (i 1)]
                   (push-cdr! tests asserts)
                   (loop []
                     [(> i (n lines))]
                     (if (/= (string/char-at (nth lines i) 1) ">")
                       (progn
                         (_/var-warning! v (.. "Expected line beginning with '>', got " (string/quoted (nth lines i))))
                         (.<! asserts 1 `_/test/pending))
                       (with (buffer (list (string/sub (nth lines i) 2)))
                         (inc! i)

                         ;; Gobble lines starting with "."
                         (loop [] [(> i (n lines))]
                           (with (line (nth lines i))
                             (when (= (string/char-at line 1) ".")
                               (push-cdr! buffer (string/sub line 2))
                               (inc! i)
                               (recur))))
                         ;; Discard lines starting with ";"
                         (loop [] [(> i (n lines))]
                           (when (= (string/char-at (nth lines i) 1) ";")
                             (inc! i)
                             (recur)))
                         ;; Parse the expression
                         (with ((ok res) (pcall _/parser/read (concat buffer "\n")))
                           (cond
                             ;; Check we didn't fail.
                             [(! ok)
                              (_/var-error! v $"Parsing failed for ${k}: ${res}")
                              (.<! asserts 1 `_/test/pending)]
                             ;; Each line must have exactly one entry
                             [(/= (n res) 1)
                              (_/var-warning! v (.. "Expected exactly one node, got " (n res)))
                              (.<! asserts 1 `_/test/pending)
                              (set! ok false)]
                             ;; Do a primitive check for top level definitions, ensuring they are pushed to the head.
                             [(and (list? (car res)) (or (eq? (caar res) 'define) (eq? (caar res) 'defun)))
                              (with (renamed (string->symbol (.. k "/" (symbol->string (cadar res)))))
                                (.<! subst (symbol->string (cadar res)) renamed)
                                (push-cdr! top-level (_/subst (car res) subst))
                                (set! res renamed))]
                             [true (set! res (_/subst (car res) subst))])
                           ;; Parse the expected result
                           (cond
                             ;; If we have no result then exit the loop.
                             [(! ok) (set! i (n lines))]
                             [(> i (n lines))
                              (_/var-warning! v (.. "Expected result, got nothing"))
                              (.<! asserts 1 `_/test/pending)]
                             ;; If there was no "complex" expression, then just push the raw body.
                             [(= (string/char-at (nth lines i) 1) ">") (push-cdr! asserts res)]
                             ;; Else assume this is an assertion.
                             [true
                              (with (line (nth lines i))
                                (when (string/starts-with? line "out =")
                                  (set! line (string/trim (string/sub line 6))))
                                (push-cdr! asserts `(_/test/affirm (= (pretty ,res) ,line))))
                              (inc! i)]))
                         ;; Discard lines starting with ";"
                         (loop [] [(> i (n lines))]
                           (when (= (string/char-at (nth lines i) 1) ";")
                             (inc! i)
                             (recur)))

                         (recur)))))]))))))

    (push-cdr! top-level tests)
    top-level))

,@(with (args
         (loop
           [(args arg)]
           [(empty? args) '()]
           (if (= (car args) "--")
             (cdr args)
             (recur (cdr args)))))

    (when (empty? args) (fail! "No arguments given to doc-test"))
    (set! args (filter (lambda (x) (/= (string/char-at x 1) "-")) args))

    (with (gen (map (lambda (x) `(import ,(string->symbol x) ())) args))
      (push-cdr! gen (list `unquote-splice `(_/build-vars)))
      gen))
