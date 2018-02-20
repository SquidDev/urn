(import urn/tools/docs       docs)
(import urn/tools/repl       repl)
(import urn/tools/gen-native gen-native)
(import urn/tools/run        run)
(import urn/tools/simple     simple)

(import urn/analysis/optimise optimise)
(import urn/analysis/warning warning)
(import urn/backend/lua lua)
(import urn/error error)
(import urn/loader loader)
(import urn/library library)
(import urn/logger logger)
(import urn/logger/term term)
(import urn/luarocks luarocks)
(import urn/plugins plugins)
(import urn/resolve/builtins builtins)
(import urn/resolve/scope scope)
(import urn/resolve/state state)
(import urn/timer timer)
(import urn/traceback traceback)

(import io/argparse arg)
(import lua/basic (_G))
(import lua/debug debug)
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
       ;; Attempt to derive the directory the compiler lives in
       (directory (with (dir (and os/getenv (os/getenv "URN_ROOT")))
                    (if dir
                      (normalise-path dir true)
                      ;; If we haven't got an URN_ROOT variable then try to work it out from the current file
                      (with (path (or
                                    (.> *arguments* 0) ;; Use the file given on the command line
                                    (and debug/getinfo (string/gsub (.> (debug/getinfo 1 "S") :short_src) "^@", ""))
                                    "urn"))
                        ;; Strip the possible file names
                        (set! path (cond
                                     ;; X/urn/cli.lisp -> X
                                     [(string/find path "urn[/\\]cli%.lisp$") (string/gsub path "urn[/\\]cli%.lisp$" "")]
                                     [(string/find path "urn[/\\]cli$") (string/gsub path "urn[/\\]cli$" "")]
                                     ;; X/bin/* -> X
                                     [(string/find path "bin[/\\][^/\\]*$")   (string/gsub path "bin[/\\][^/\\]*$" "")]
                                     ;; X/* -> X
                                     [else (string/gsub path "[^/\\]*$" "")]))
                        ;; Normalise the path, append the library directory
                        (normalise-path path true)))))

       ;; Determine whether we should use urn-lib or lib directories.
       (lib-name (with (handle (io/open (.. directory "urn-lib/prelude.lisp")))
                   (cond
                     [handle
                      (self handle :close)
                      "urn-lib"]
                     [else "lib"])))

       ;; Build a list of search paths from this information
       (paths (list
                "?"
                "?/init"
                (.. directory lib-name "/?")
                (.. directory lib-name "/?/init")))

       ;; Build a list of tasks to run
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

  (arg/add-category! spec "path" "Input paths"
    "Locations used to configure where libraries are loaded from.")

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
    :cat     "path"
    :many    true
    :narg    1
    :default '()
    :action  arg/add-action)

  (arg/add-argument! spec '("--prelude" "-P")
    :help    "A custom prelude path to use."
    :cat     "path"
    :narg    1
    :default (.. directory lib-name "/prelude"))

  (arg/add-argument! spec '("--include-rocks" "-R")
    :help    "Include all installed LuaRocks on the search path."
    :cat     "path")

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
               (let* [(args (map id *arguments*))
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
                   (when-with (interp (.> *arguments* -1)) (push! command interp))
                   (push! command (.> *arguments* 0))

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

  (arg/add-argument! spec '("--flag" "-f")
    :help    "Turn on a compiler flag, enabling or disabling a specific feature."
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
      (cond
        [(string/find path "%?") (push! paths (normalise-path path false))]
        [else
         (set! path (normalise-path path true))
         (push! paths (.. path "?"))
         (push! paths (.. path "?/init"))]))

    ;; Include LuaRocks modules
    (when (.> args :include-rocks)
      (luarocks/include-rocks logger paths))

    (logger/put-verbose! logger (.. "Using path: " (pretty paths)))

    (when (and (= (.> args :prelude) (.. directory lib-name "/prelude")) (empty? (.> args :plugin)))
      (push! (.> args :plugin) (.. directory "plugins/fold-defgeneric.lisp")))

    (cond
      [(empty? (.> args :input))
       (.<! args :repl true)]
      [(not (.> args :emit-lua))
       (.<! args :emit-lua true)]
      [else])

    (with (compiler { :log       logger
                      :timer     (timer/create (cut logger/put-time! logger <> <> <>))
                      :paths     paths
                      :flags     (.> args :flag)

                      :libs       (library/library-cache)
                      :prelude    nil
                      :root-scope builtins/root-scope

                      :warning   (warning/default)
                      :optimise  (optimise/default)

                      :exec      (lambda (func) (list (xpcall func traceback/traceback)))

                      :variables {}
                      :states    {}
                      :out       '() })

      ;; Add compileState
      (.<! compiler :compile-state (lua/create-state))

      ;; Set the loader
      (.<! compiler :loader (cut loader/named-loader compiler <>))

      ;; Add globals
      (.<! compiler :global (setmetatable
                              {  :_libs (library/library-cache-values (.> compiler :libs))
                                :_compiler (plugins/create-plugin-state compiler)}
                              { :__index _G }))

      ;; Store all builtin vars in the lookup
      (for-pairs (_ var) (scope/scope-variables builtins/root-scope)
        (.<! compiler :variables (tostring var) var))

      ;; Run the various setup functions
      (for-each task tasks
        (when ((.> task :pred) args)
          (when-with (setup (.> task :init)) (setup compiler args))))

      (timer/start-timer! (.> compiler :timer) "loading")
      (with (do-load! (lambda (name)
                        (case (list (xpcall (lambda () (loader/path-loader compiler name)) error/traceback))
                          ;; Could not resolve any nodes, so just do a pure exit
                          [(false error/compiler-error?) (exit! 1)]
                          ;; Some unknown crash, so fail with that.
                          [(false ?error-message)  (fail! error-message)]
                          ;; Module not found
                          [(true (nil ?error-message))
                           (logger/put-error! logger error-message)
                           (exit! 1)]
                          [(true (?lib)) lib])))

        ;; Load the prelude and setup the environment
        (with (lib (do-load! (.> args :prelude)))
          (loader/setup-prelude! compiler lib))

        ;; And load remaining files
        (for-each input (append (.> args :plugin) (.> args :input))
          (do-load! input)))

      (timer/stop-timer! (.> compiler :timer) "loading")

      (for-each task tasks
        (when ((.> task :pred) args)
          (timer/start-timer! (.> compiler :timer) (.> task :name) 1)
          ((.> task :run) compiler args)
          (timer/stop-timer! (.> compiler :timer) (.> task :name)))))))
