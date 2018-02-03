"This code block parses and executes all code blocks found within
 documentation strings for a given module.

 This script should be run as follows:

 ```sh
 $ bin/urn.lua plugins/doc-test.lisp --run -- list
 ```

 This will import the `list` library, and use the symbols declared in
 that library to declare tests. One can also generate tests from
 re-exported symbols declared in other libraries by passing the
 `--all` (or `-a`) flag:

 ```sh
 $ bin/urn.lua plugins/doc-test.lisp --run -- list --all
 ```

 You can exclude particular code blocks from being tested by appending
 `:no-test` after the language part of the code block.

 The current implementation has several limitations which will be
 rectified in the future:

  - Does not test the module-level documentation string (namely this
    thing).

  - Does not handle standard output ([[print!]] and the like), as it only
    expects a single line of output.

  - Does not handle results which span multiple lines, such as that found
    in `io/do`.

  - Cannot test for expressions which error."

(import compiler/resolve _)
(import compiler _)
(import urn/documentation _)
(import urn/parser _/parser)
(import test _/test)

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

(defun _/build-vars (libs)
  :hidden
  (let* [(top-level '())
         (tests `(_/test/describe "The stdlib"))
         (vars (_/scope-vars))]

    (for-each name (sort! (keys vars))
      (when (and (not (string/starts-with? name "_/")) (or (empty? libs)
                                                         (any (lambda (x)
                                                                (string/starts-with? (.> (.> vars name) :full-name) (.. x "/")))
                                                           libs)))
        (let* [(var (.> vars name))
               (docs (-> (or (_/var-docstring var) "")
                         _/parse-docstring
                         (filter (lambda (x) (and (= (.> x :kind) "mono")
                                               (string/starts-with? (.> x :whole) "```")
                                               (not (string/find (.> x :whole) "^```[^\n]*:no%-test[^\n]*\n")))) <>)
                         (map (cut .> <> :contents) <>)))]
          (for-each entry docs
            (let [(lines (string/split entry "\n"))
                  (asserts `(_/test/it ,(.. "has tests for " (.> var :full-name))))]
              (push! tests asserts)
              (cond
                ;; Just do a couple of sanity checks on the code
                [(empty? lines)
                 (_/var-warning! var "This example is empty.")
                 (.<! asserts 1 `_/test/pending)]
                ;; Everything is OK so let's build a list
                [true
                 (let [(subst {})
                       (i 1)]
                   (loop []
                     [(> i (n lines))]
                     (if (/= (string/char-at (nth lines i) 1) ">")
                       (progn
                         (_/var-warning! var (.. "Expected line beginning with '>', got " (string/quoted (nth lines i))))
                         (.<! asserts 1 `_/test/pending))
                       (with (buffer (list (string/sub (nth lines i) 2)))
                         (inc! i)

                         ;; Gobble lines starting with "."
                         (loop [] [(> i (n lines))]
                           (with (line (nth lines i))
                             (when (= (string/char-at line 1) ".")
                               (push! buffer (string/sub line 2))
                               (inc! i)
                               (recur))))

                         ;; Parse the expression
                         (with ((ok res) (pcall _/parser/read (concat buffer "\n")))
                           (cond
                             ;; Check we didn't fail.
                             [(not ok)
                              (_/var-error! var (format true "Parsing failed for {#name}: {#res}"))
                              (.<! asserts 1 `_/test/pending)]
                             ;; Each line must have exactly one entry
                             [(/= (n res) 1)
                              (_/var-warning! var (.. "Expected exactly one node, got " (n res)))
                              (.<! asserts 1 `_/test/pending)
                              (set! ok false)]
                             ;; Do a primitive check for top level definitions, ensuring they are pushed to the head.
                             [(and (list? (car res)) (elem? (caar res) '(define define-macro defun defmacro defgeneric)))
                              (with (renamed (string->symbol (.. name "/" (symbol->string (cadar res)))))
                                (.<! subst (symbol->string (cadar res)) renamed)
                                (push! top-level (_/subst (car res) subst))
                                (set! res renamed))]
                             [true (set! res (_/subst (car res) subst))])

                           (when ok
                             (with (stdout '())
                               ;; Gobble stdout lines
                               (loop [] [(> i (n lines))]
                                 (with (line (nth lines i))
                                   (unless (or (string/starts-with? line "out = ") (string/starts-with? line ">"))
                                     (push! stdout line)
                                     (inc! i)
                                     (recur))))

                               (with (line (nth lines i))
                                 (cond
                                   ;; If we're the last line, then we expect some sort of result
                                   [(not line)
                                    (_/var-warning! var "Expected result, got nothing")
                                    (.<! asserts 1 `_/test/pending)]

                                   ;; If we've got no result and we're not the last entry then just push the expression
                                   ;; unless there was a stdout, then warn.
                                   [(not (string/starts-with? line "out ="))
                                    (if (empty? stdout)
                                      (progn
                                        (push! asserts res)
                                        (recur))
                                      (progn
                                        (_/var-warning! var (.. "Expected result to start with \"out = \", got " (pretty line)))
                                        (.<! asserts 1 `_/test/pending)))]

                                   ;; Otherwise, let's push our affirmation and continue
                                   [true
                                    (with (res-lines (list (string/trim (string/sub line 6))))
                                      (inc! i)
                                      (loop [] [(> i (n lines))]
                                        (with (line (nth lines i))
                                          (when (string/starts-with? line " ")
                                            (push! res-lines (string/trim line))
                                            (inc! i)
                                            (recur))))

                                      (if (empty? stdout)
                                        (push! asserts `(_/test/affirm (= (pretty ,res) ,(concat res-lines " "))))
                                        (with (stdout-sym (gensym 'stdout))
                                          (push! asserts `(let* [(,stdout-sym '())
                                                                     (print! (lambda (,'&args) (push! ,stdout-sym (concat (map tostring ,'args) "   ")) nil))]
                                                                (_/test/affirm
                                                                  (= (pretty ,res) ,(concat res-lines " "))
                                                                  (eq? ',stdout ,stdout-sym)))))))

                                    ;; Discard lines starting with ";"
                                    (loop [] [(> i (n lines))]
                                      (when (= (string/char-at (nth lines i) 1) ";")
                                        (inc! i)
                                        (recur)))

                                    (recur)])))))))))]))))))

    (push! top-level tests)
    top-level))

,@(with (args
         (loop
           [(args *arguments*)]
           [(empty? args) '()]
           (if (= (car args) "--")
             (cdr args)
             (recur (cdr args)))))

    (when (empty? args) (fail! "No arguments given to doc-test"))
    (with (libs (filter (lambda (x) (/= (string/char-at x 1) "-")) args))
      (with (gen (map (lambda (x) `(import ,(string->symbol x) ())) libs))
        (push! gen (list `unquote-splice
                             `(_/build-vars ',(if (or (elem? "--all" args) (elem? "-a" args))
                                                '()
                                                libs))))
        gen)))
