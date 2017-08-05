(import extra/argparse arg)
(import extra/term (colored))
(import lua/basic (load))
(import lua/coroutine co)
(import lua/debug debug)
(import lua/io io)
(import lua/os os)
(import lua/table table)

(import urn/backend/lua lua)
(import urn/backend/writer writer)
(import urn/documentation docs)
(import urn/logger logger)
(import urn/logger/void void)
(import urn/logger)
(import urn/parser parser)
(import urn/resolve/loop (compile))
(import urn/resolve/scope scope)
(import urn/resolve/state state)

(defun requires-input (str)
  "Determine whether STR requires additional input (such as quotes or parens).
   The returns false if no input is required, and nil if a syntax error occured."
  (case (list (pcall (lambda()
                       (parser/parse
                         void/void
                         (parser/lex void/void str "<stdin>" true)
                         true))))
    [(true _) false]
    [(false (table? @ ?x)) (if (.> x :cont) true false)]
    [(false ?x) (debug x) nil]))

(defun do-resolve (compiler scope str)
  :hidden
  (let* [(logger (.> compiler :log))
         (lexed (parser/lex logger str "<stdin>"))
         (parsed (parser/parse logger lexed))]
    (cadr (list (compile
                  compiler
                  parsed
                  scope)))))

(define repl-colour-scheme
  :hidden
  (when-let* [(ge os/getenv) ; actually check that os/getenv exists
              (clrs (ge "URN_COLOURS"))
              (scheme-alist (parser/read clrs))]
    scheme-alist))

(defun colour-for (elem) :hidden
  (if (assoc? repl-colour-scheme (string->symbol elem))
    (const-val (assoc repl-colour-scheme (string->symbol elem)))
    (case elem
      ["text" 0]
      ["arg" 36]
      ["mono" 97]
      ["bold" 1]
      ["italic" 3]
      ["link" 94])))

(defun print-docs! (str)
  :hidden
  (with (docs (docs/parse-docstring str))
    (for-each tok docs
      (with (tag (.> tok :tag))
        (cond
          [(= tag "bolic")
           (io/write (colored (colour-for :bold) (colored (colour-for :italic) (.> tok :contents))))]
          [true
           (io/write (colored (colour-for tag) (.> tok :contents)))])))
    (print!)))

(defun exec-command (compiler scope args)
  "Execute command given by ARGS using the given compiler state (COMPILER) and SCOPE"
  :hidden
  (let* [(logger (.> compiler :log))
         (command (car args))]
    (cond
      [nil
       (logger/put-error! logger "Expected command after ':'")]
      [(or (= command "help") (= command "h"))
       (print! "REPL commands:
                [:d]oc NAME        Get documentation about a symbol
                :scope             Print out all variables in the scope
                [:s]earch QUERY    Search the current scope for symbols and documentation containing a string.
                :module NAME       Display a loaded module's docs and definitions.")]
      [(or (= command "doc") (= command "d"))
       (with (name (nth args 2))
         (if name
           (with (var (scope/get scope name))
             (cond
               [(= var nil)
                (logger/put-error! logger (.. "Cannot find '" name "'"))]
               [(! (.> var :doc))
                (logger/put-error! logger (.. "No documentation for '" name "'"))]
               [true
                 (let* [(sig (docs/extract-signature var))
                        (name (.> var :full-name))]
                   (when sig
                     (with (buffer (list name))
                       (for-each arg sig (push-cdr! buffer (.> arg :contents)))
                       (set! name (.. "(" (concat buffer " ") ")"))))

                   (print! (colored 96 name))
                   (print-docs! (.> var :doc)))]))
           (logger/put-error! logger ":doc <variable>")))]

      [(= command "module")
       (with (name (nth args 2))
         (if name
           (with (mod (.> compiler :lib-names name))
             (cond
               [(= mod nil)
                (logger/put-error! logger (.. "Cannot find '" name "'"))]
               [true
                (print! (colored 96 (.> mod :name)))

                (when (.> mod :docs)
                  (print-docs! (.> mod :docs))
                  (print!))

                (print! (colored 92 "Exported symbols"))
                (with (vars '())
                  (for-pairs (name) (.> mod :scope :exported) (push-cdr! vars name))
                  (table/sort vars)
                  (print! (concat vars "  ")))]))
           (logger/put-error! logger ":module <variable>")))]

      [(= command "scope")
       (let* [(vars '())
              (vars-set {})
              (current scope)]
         (while current
           (for-pairs (name var) (.> current :variables)
             (unless (.> vars-set name)
               (push-cdr! vars name)
               (.<! vars-set name true)))
           (set! current (.> current :parent)))

         (table/sort vars)

         (print! (concat vars "  ")))]

      [(or (= command "search") (= command "s"))
       (if (> (n args) 1)
         (let* [(keywords (map string/lower (cdr args)))
                (name-results '())
                (docs-results '())
                (vars '())
                (vars-set {})
                (current scope)]
           (while current
             (for-pairs (name var) (.> current :variables)
               (unless (.> vars-set name)
                 (push-cdr! vars name)
                 (.<! vars-set name true)))
             (set! current (.> current :parent)))

           (for-each var vars
             ;; search by function name
             (for-each keyword keywords
               (when (string/find var keyword)
                 (push-cdr! name-results var)))
             ;; search by function docs
             (when-let* [(doc-var (scope/get scope var))
                         (temp-docs (.> doc-var :doc))
                         (docs (string/lower temp-docs))
                         (keywords-found 0)]
               (for-each keyword keywords
                 (when (string/find docs keyword)
                   (inc! keywords-found)))
               (when (eq? keywords-found (n keywords))
                 (push-cdr! docs-results var))))
           (if (and (empty? name-results) (empty? docs-results))
             (logger/put-error! logger "No results")
             (progn
               (when (! (empty? name-results))
                 (print! (colored 92 "Search by function name:"))
                 (if (> (n name-results) 20)
                   (print! (.. (concat (take name-results 20) "  ") "  ..."))
                   (print! (concat name-results "  "))))
               (when (! (empty? docs-results))
                 (print! (colored 92 "Search by function docs:"))
                 (if (> (n docs-results) 20)
                   (print! (.. (concat (take docs-results 20) "  ") "  ..."))
                   (print! (concat docs-results "  ")))))))
         (logger/put-error! logger ":search <keywords>"))]

      [true
        (logger/put-error! logger (.. "Unknown command '" command "'"))])))

(defun exec-string (compiler scope string)
  :hidden
  (with (state (do-resolve compiler scope string))
    (when (> (n state) 0)
      (let* [(current 0)
             (exec (co/create (lambda ()
                                (for-each elem state
                                  (set! current elem)
                                  (state/get! current)))))
             (compileState (.> compiler :compile-state))
             (rootScope (.> compiler :root-scope))
             (global (.> compiler :global))
             (logger (.> compiler :log))
             (run true)]
        (while run
          (with (res (list (co/resume exec)))
            (cond
              [(! (car res))
               (logger/put-error! logger (cadr res))
               (set! run false)]
              [(= (co/status exec) "dead")
               (let* [(lvl (state/get! (last state)))]
                 (print! (.. "out = " (colored 96 (pretty lvl))))
                 (.<! global (lua/push-escape-var! (scope/add! scope "out" "defined" lvl)
                                             compileState)
                      lvl))
               (set! run false)]
              [true
                (let* [(states (.> (cadr res) :states))
                       (latest (car states))
                       (co (co/create lua/execute-states))
                       (task nil)]

                  (while (and run (/= (co/status co) "dead"))
                    (.<! compiler :active-node (.> latest :node))
                    (.<! compiler :active-scope (.> latest :scope))

                    (with (res (if task
                                 (list (co/resume co))
                                 (list (co/resume co compileState states global logger))))

                      (.<! compiler :active-node nil)
                      (.<! compiler :active-scope nil)

                      (case res
                        [(false ?msg) (fail! msg)]
                        [(true)]
                        [(true ?arg)
                         (when (/= (co/status co) "dead")
                           (set! task arg)
                           (case (.> task :tag)
                             ["execute" (lua/execute-states compileState (.> task :states) global logger)]
                             [?task fail! (.. "Cannot handle " task)]))]))))])))))))

(defun repl (compiler)
  (let* [(scope (.> compiler :root-scope))
         (logger (.> compiler :log))
         (buffer "")
         (running true)]
    (while running
      (io/write (colored 92 (if (empty? buffer) "> " ". ")))
      (io/flush)

      (with (line (io/read "*l"))
        (cond
          ;; If we got no input, then exit the REPL
          [(and (! line) (empty? buffer)) (set! running false)]

          [true
            (with (data (if line (.. buffer line "\n") buffer))
              (cond
                [(= (string/char-at data 1) ":")
                 (set! buffer "")
                 (exec-command compiler scope (map string/trim (string/split (string/sub data 2) " ")))]
                [(and line (> (n line) 0) (requires-input data))
                 (set! buffer data)]
                [true
                 (set! buffer "")
                 (set! scope (scope/child scope))
                 (.<! scope :is-root true)

                 (with (res (list (pcall exec-string compiler scope data)))
                   ;; Clear active node/scope
                   (.<! compiler :active-node nil)
                   (.<! compiler :active-scope nil)
                   (unless (car res) (logger/put-error! logger (cadr res))))]))])))))

(defun exec (compiler)
  (let* [(data (io/read "*a"))
         (scope (.> compiler :root-scope))
         (logger (.> compiler :log))
         (res (list (pcall exec-string compiler scope data)))]
    (unless (car res)
      (logger/put-error! logger (cadr res)))
    (os/exit 0)))

(define repl-task
  { :name  "repl"
    :setup (lambda (spec)
             (arg/add-argument! spec '("--repl")
               :help "Start an interactive session."))
    :pred  (lambda (args) (.> args :repl))
    :run  repl })

(define exec-task
  { :name  "exec"
    :setup (lambda (spec)
             (arg/add-argument! spec '("--exec")
               :help "Execute a program from stdin without compiling it. This acts as if it were input in one go via the REPL."))
    :pred  (lambda (args) (.> args :exec))
    :run   exec })
