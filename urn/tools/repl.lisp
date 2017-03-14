(import extra/argparse arg)
(import extra/term (colored))
(import lua/basic (load))
(import lua/coroutine co)
(import lua/debug debug)
(import lua/io io)
(import lua/table table)
(import string)

(import urn/backend/lua lua)
(import urn/backend/writer writer)
(import urn/documentation docs)
(import urn/logger logger)
(import urn/logger)
(import urn/parser parser)

(define compile (.> (require "tacky.compile") :compile))

(define Scope (require "tacky.analysis.scope"))

(defun do-parse (compiler scope str)
  :hidden
  (let* [(logger (.> compiler :log))
         (lexed (parser/lex logger str "<stdin>"))
         (parsed (parser/parse logger lexed))]
    (cadr (list (compile
                  parsed
                  (.> compiler :global)
                  (.> compiler :variables)
                  (.> compiler :states)
                  scope
                  (.> compiler :compileState)
                  (.> compiler :loader)
                  logger
                  lua/execute-states)))))

(defun exec-command (compiler scope args)
  "Execute command given by ARGS using the given compiler state (COMPILER) and SCOPE"
  :hidden
  (let* [(logger (.> compiler :log))
         (command (car args))]
    (cond
      ((= command nil)
        (logger/put-error! logger "Expected command after ':'"))
      ((= command "doc")
        (with (name (nth args 2))
          (if name
            (with (var ((.> Scope :get) scope name))
              (cond
                ((= var nil)
                  (logger/put-error! logger (.. "Cannot find '" name "'")))
                ((! (.> var :doc))
                  (logger/put-error! logger (.. "No documentation for '" name "'")))
                (true
                  (let* [(sig (docs/extract-signature var))
                         (name (.> var :fullName))
                         (docs (docs/parse-docstring (.> var :doc)))]
                    (when sig
                      (with (buffer (list name))
                        (for-each arg sig (push-cdr! buffer (.> arg :contents)))
                        (set! name (.. "(" (concat buffer " ") ")"))))

                    (print! (colored 96 name))

                    (for-each tok docs
                      (with (tag (.> tok :tag))
                        (cond
                          ((= tag "text") (io/write (.> tok :contents)))
                          ((= tag "arg") (io/write (colored 36 (.> tok :contents))))
                          ((= tag "mono") (io/write (colored 97 (.> tok :contents))))
                          ((= tag "arg") (io/write (colored 97 (.> tok :contents))))
                          ((= tag "bolic") (io/write (colored 3 (colored 1 (.> tok :contents)))))
                          ((= tag "bold") (io/write (colored 1 (.> tok :contents))))
                          ((= tag "italic") (io/write (colored 3 (.> tok :contents))))
                          ((= tag "link") (io/write (colored 94 (.> tok :contents)))))))
                    (print!)))))
            (logger/put-error! logger ":command <variable>"))))
      ((= command "scope")
        (let* [(vars '())
               (vars-set (empty-struct))
               (current scope)]
          (while current
            (for-pairs (name var) (.> current :variables)
              (unless (.> vars-set name)
                (push-cdr! vars name)
                (.<! vars-set name true)))
            (set! current (.> current :parent)))

          (table/sort vars)

          (print! (concat vars "  "))))
      ((= command "search")
          (if (> (# args) 1)
            (let* [(keywords (map string/lower (cdr args)))
                   (name-results '())
                   (docs-results '())
                   (vars '())
                   (vars-set (empty-struct))
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
                (when-let* [(doc-var ((.> Scope :get) scope var))
                            (temp-docs (.> doc-var :doc))
                            (docs (string/lower temp-docs))
                            (keywords-found 0)]
                  (for-each keyword keywords
                    (when (string/find docs keyword)
                      (inc! keywords-found)))
                  (when (eq? keywords-found (# keywords))
                    (push-cdr! docs-results var))))
              (if (and (nil? name-results) (nil? docs-results))
                (logger/put-error! logger "No results")
                (progn
                  (when (! (nil? name-results))
                    (print! (colored 92 "Search by function name:"))
                    (if (> (# name-results) 20)
                      (print! (.. (concat (take name-results 20) "  ") "  ..."))
                      (print! (concat name-results "  "))))
                  (when (! (nil? docs-results))
                    (print! (colored 92 "Search by function docs:"))
                    (if (> (# docs-results) 20)
                      (print! (.. (concat (take docs-results 20) "  ") "  ..."))
                      (print! (concat docs-results "  ")))))))
            (logger/put-error! logger ":search <keywords>")))
      (true
        (logger/put-error! logger (.. "Unknown command '" command "'"))))))

(defun exec-string (compiler scope string)
  :hidden
  (with (state (do-parse compiler scope string))
    (when (> (# state) 0)
      (let* [(current 0)
             (exec (co/create (lambda ()
                                (for-each elem state
                                  (set! current elem)
                                  (self current :get)))))
             (compileState (.> compiler :compileState))
             (global (.> compiler :global))
             (logger (.> compiler :log))
             (run true)]
        (while run
          (with (res (list (co/resume exec)))
            (cond
              ((! (car res))
                (logger/put-error! logger (cadr res))
                (set! run false))
              ((= (co/status exec) "dead")
                (print! (colored 96 (pretty (self (last state) :get))))
                (set! run false))
              (true
                (with (states (.> (cadr res) :states))
                  (lua/execute-states compileState states global logger))))))))))

(defun repl (compiler)
  (let* [(scope (.> compiler :rootScope))
         (logger (.> compiler :log))
         (buffer '())
         (running true)]
    (while running
      (io/write (colored 92 (if (nil? buffer) "> " ". ")))
      (io/flush)

      (with (line (io/read "*l"))
        (cond
          ((and (! line) (nil? buffer)) (set! running false))
          ((and line (= (string/char-at line (#s line)) "\\"))
            (push-cdr! buffer (.. (string/sub line 1 (pred (#s line))) "\n")))
          ((and line (> (# buffer) 0) (> (#s line) 0))
            (push-cdr! buffer (.. line "\n")))
          (true
            (with (data (.. (concat buffer) (or line "")))
              (set! buffer '())

              (if (= (string/char-at data 1) ":")
                (exec-command compiler scope (string/split (string/sub data 2) " "))
                (progn
                  (set! scope ((.> Scope :child) scope))
                  (.<! scope :isRoot true)

                  (with (res (list (pcall exec-string compiler scope data)))
                    (unless (car res) (logger/put-error! logger (cadr res)))))))))))))

(define task
  (struct
    :name  "repl"
    :setup (lambda (spec)
             (arg/add-argument! spec '("--repl")
               :help "Start an interactive session."))
    :pred  (lambda (args) (.> args :repl))
    :run  repl))
