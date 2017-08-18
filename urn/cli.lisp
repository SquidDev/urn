(import urn/tools/simple    simple)
(import urn/tools/docs      docs)
(import urn/tools/repl      repl)
(import urn/tools/run       run)
(import urn/tools/gen-native gen-native)

(import urn/analysis/optimise optimise)
(import urn/analysis/warning warning)
(import urn/backend/lua lua)
(import urn/loader loader)
(import urn/logger logger)
(import urn/logger/term term)
(import urn/plugins plugins)
(import urn/resolve/builtins builtins)
(import urn/resolve/scope scope)
(import urn/resolve/state state)
(import urn/timer timer)

(import extra/argparse arg)
(import lua/basic (_G))
(import lua/os os)

(defun normalise-path (path trailing)
  "Normalise the given file PATH. If TRAILING is `true`, then a trailing
   '/' will be added if required."
  :hidden
  ;; Normalise path separators
  (set! path (string/gsub path "\\" "/"))

  ;; Add a trailing "/" where needed
  (when (and trailing (/= path "") (/= (string/char-at path -1) "/"))
    (set! path (.. path "/")))

  ;; Remove leading "./"s
  (while (= (string/sub path 1 2) "./")
    (set! path (string/sub path 3)))

  path)

(let* [(spec (arg/create "The compiler and REPL for the Urn programming language."))
       (directory (with (dir (os/getenv "URN_STDLIB"))
                    (if dir
                      (normalise-path dir true)
                      ;; If we haven't got an URN_STDLIB variable then try to work it out from the current file
                      (with (path (.> arg 0))
                        ;; Strip the possible file names
                        (set! path (cond
                                     ;; X/urn/cli.lisp -> X
                                     [(string/find path "urn[/\\]cli%.lisp$") (string/gsub path "urn[/\\]cli%.lisp$" "")]
                                     ;; X/bin/* -> X
                                     [(string/find path "bin[/\\][^/\\]*$")   (string/gsub path "bin[/\\][^/\\]*$" "")]
                                     ;; X/* -> X
                                     [else (string/gsub path "[^/\\]*$" "")]))
                        ;; Normalise the path, append the library directory
                        (.. (normalise-path path true) "lib/")))))
       (paths (list
                "?"
                "?/init"
                (.. directory "?")
                (.. directory "?/init")))

       (tasks (list
                ;; Must be done before any processing of the tree
                run/coverage-report
                docs/task
                gen-native/task
                ;; Various processing steps
                simple/warning
                simple/optimise
                ;; Then using the fully optimised result
                simple/emit-lisp
                simple/emit-lua
                run/task
                repl/exec-task
                repl/repl-task))]
  (arg/add-help! spec)

  (arg/add-category! spec "out" "Output"
    "Customise what is emitted, as well as where and how it is generated.")

  (arg/add-argument! spec '("--explain" "-e")
    :help    "Explain error messages in more detail.")

  (arg/add-argument! spec '("--time" "-t")
    :help    "Time how long each task takes to execute. Multiple usages will show more detailed timings."
    :many    true
    :default 0
    :action  (lambda (arg data) (.<! data (.> arg :name) (succ (or (.> data (.> arg :name)) 0)))))

  (arg/add-argument! spec '("--verbose" "-v")
    :help    "Make the output more verbose. Can be used multiple times"
    :many    true
    :default 0
    :action  (lambda (arg data) (.<! data (.> arg :name) (succ (or (.> data (.> arg :name)) 0)))))

  (arg/add-argument! spec '("--include" "-i")
    :help    "Add an additional argument to the include path."
    :many    true
    :narg    1
    :default '()
    :action  arg/add-action)

  (arg/add-argument! spec '("--prelude" "-p")
    :help    "A custom prelude path to use."
    :narg    1
    :default (.. directory "prelude"))

  (arg/add-argument! spec '("--output" "--out" "-o")
    :help    "The destination to output to."
    :cat     "Output"
    :narg    1
    :default "out"
    :action (lambda (arg data value)
              (.<! data (.> arg :name) (string/gsub value "%.lua$" ""))))

  (arg/add-argument! spec '("--wrapper" "-w")
    :help    "A wrapper script to launch Urn with"
    :narg    1
    :action  (lambda (a b value)
               (let* [(args (map id arg))
                      (i 1)
                      (len (n args))]
                 (while (<= i len)
                   (with (item (nth args i))
                     (cond
                       [(or (= item "--wrapper") (= item "-w"))
                        (remove-nth! args i)
                        (remove-nth! args i)
                        (set! i (succ len))]
                       [(string/find item "^%-%-wrapper=.*$")
                        (remove-nth! args i)
                        (set! i (succ len))]
                       [(string/find item "^%-[^-]+w$")
                        (.<! args i (string/sub item 1 -2))
                        (remove-nth! args (succ i))
                        (set! i (succ len))]
                       [true])))

                 (with (command (list value))
                   (when-with (interp (.> arg -1)) (push-cdr! command interp))
                   (push-cdr! command (.> arg 0))

                   (case (list (os/execute (concat (append command args) " ")))
                     [((number? @ ?code) . _) (os/exit code)] ; luajit.
                     [(_ _ ?code) (os/exit code)])))))

  (arg/add-argument! spec '("--plugin")
    :help    "Specify a compiler plugin to load."
    :var     "FILE"
    :default '()
    :narg    1
    :many    true
    :action  arg/add-action)

  (arg/add-argument! spec '("input")
    :help    "The file(s) to load."
    :var     "FILE"
    :narg    "*")

  ;; Setup the arguments for each task
  (for-each task tasks ((.> task :setup) spec))

  (let* [(args (arg/parse! spec))
         (logger (term/create
                   (.> args :verbose)
                   (.> args :explain)
                   (.> args :time)))]

    ;; Process include paths
    (for-each path (.> args :include)
      (set! path (normalise-path path false))

      (unless (string/find path "%?")
        (set! path (.. path (if (= (string/char-at path -1) "/") "?" "/?"))))

      (push-cdr! paths path))

    (logger/put-verbose! logger (.. "Using path: " (pretty paths)))

    (if (empty? (.> args :input))
      (.<! args :repl true)
      (.<! args :emit-lua true))

    (with (compiler { :log       logger
                      :timer     (timer/create (cut logger/put-time! logger <> <> <>))
                      :paths     paths

                      :lib-env   {}
                      :lib-meta  {}
                      :libs      '()
                      :lib-cache {}
                      :lib-names {}

                      :warning   (warning/default)
                      :optimise  (optimise/default)

                      :root-scope builtins/root-scope

                      :variables {}
                      :states    {}
                      :out       '() })

      ;; Add compileState
      (.<! compiler :compile-state (lua/create-state (.> compiler :lib-meta)))

      ;; Set the loader
      (.<! compiler :loader (lambda (name) (loader/loader compiler name true)))

      ;; Add globals
      (.<! compiler :global (setmetatable
                              {  :_libs (.> compiler :lib-env)
                                :_compiler (plugins/create-plugin-state compiler)}
                              { :__index _G }))

      ;; Store all builtin vars in the lookup
      (for-pairs (_ var) (.> compiler :root-scope :variables)
        (.<! compiler :variables (tostring var) var))

      (timer/start-timer! (.> compiler :timer) "loading")
      (case (loader/loader compiler (.> args :prelude) false)
        [(nil ?error-message)
         (logger/put-error! logger error-message)
         (exit! 1)]
        [(?lib)
         (.<! compiler :root-scope (scope/child (.> compiler :root-scope)))
         (for-pairs (name var) (.> lib :scope :exported)
           (scope/import! (.> compiler :root-scope) name var))

         (for-each input (append (.> args :plugin) (.> args :input))
           (case (loader/loader compiler input false)
             [(nil ?error-message)
              (logger/put-error! logger error-message)
              (exit! 1)]
             [(_)]))])

      (timer/stop-timer! (.> compiler :timer) "loading")

      (for-each task tasks
        (when ((.> task :pred) args)
          (timer/start-timer! (.> compiler :timer) (.> task :name) 1)
          ((.> task :run) compiler args)
          (timer/stop-timer! (.> compiler :timer) (.> task :name)))))))
