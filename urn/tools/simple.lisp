(import io/argparse arg)
(import lua/io io)
(import lua/os os)

(import urn/analysis/optimise optimise)
(import urn/analysis/warning warning)
(import urn/analysis/pass pass)
(import urn/backend/lisp lisp)
(import urn/backend/lua lua)
(import urn/backend/writer writer)
(import urn/logger logger)

(define emit-lua
  { :name  "emit-lua"
    :setup (lambda (spec)
             (arg/add-argument! spec '("--emit-lua")
               :help   "Emit a Lua file."
               :narg   "?"
               :var    "OUTPUT"
               :value  true
               :cat    "out")
             (arg/add-argument! spec '("--shebang")
               :help    "Set the executable to use for the shebang."
               :cat     "out"
               :value   (or (.> *arguments* -1) (.> *arguments* 0) "lua")
               :narg    "?")
             (arg/add-argument! spec '("--chmod")
               :help    "Run chmod +x on the resulting file"
               :cat     "out"))
    :pred  (lambda (args) (.> args :emit-lua))
    :run   (lambda (compiler args)
             (when (empty? (.> args :input))
               (logger/put-error! (.> compiler :log) "No inputs to compile.")
               (exit! 1))

             (let* [(out (lua/file compiler (.> args :shebang)))
                    (name (if (string? (.> args :emit-lua))
                            (.> args :emit-lua)
                            (.. (.> args :output) ".lua")))
                    ((handle error) (io/open name "w"))]
               (unless handle
                 (logger/put-error! (.> compiler :log) (sprintf "Cannot open %q (%s)" name error))
                 (exit! 1))
               (self handle :write (writer/->string out))
               (self handle :close)

               (when (.> args :chmod)
                 ;; string/quoted is not "correct" for escaping names but it is "good enough".
                 (os/execute (.. "chmod +x " (string/quoted name)))))) })

(define emit-lisp
  { :name  "emit-lisp"
    :setup (lambda (spec)
             (arg/add-argument! spec '("--emit-lisp")
               :help "Emit a Lisp file."
               :narg "?"
               :var  "OUTPUT"
               :value true
               :cat  "out"))
    :pred  (lambda (args) (.> args :emit-lisp))
    :run   (lambda (compiler args)
             (when (empty? (.> args :input))
               (logger/put-error! (.> compiler :log) "No inputs to compile.")
               (exit! 1))

             (let [(writer (writer/create))
                   (name (if (string? (.> args :emit-lisp))
                           (.> args :emit-lisp)
                           (.. (.> args :output) ".lisp")))]
               (lisp/block (.> compiler :out) writer)
               (with ((handle error) (io/open name "w"))
                 (unless handle
                   (logger/put-error! (.> compiler :log) (sprintf "Cannot open %q (%s)" (.. (.> args :output) ".lisp") error))
                   (exit! 1))
                 (self handle :write (writer/->string writer))
                 (self handle :close)))) })

(defun pass-arg (arg data value usage!)
  "Handle the argument of a pass runner"
  (let* [(val (string->number value))
         (name (.. (.> arg :name) "-override"))
         (override (.> data name))]
    (unless override
      (set! override {})
      (.<! data name override))
    (cond
      [val
       ;; If we've got a number then we'll try to use that
       (.<! data (.> arg :name) val)]
      [(= (string/char-at value 1) "-")
       ;; Disable this pass
       (.<! override (string/sub value 2) false)]
      [(= (string/char-at value 1) "+")
        ;; Enable this pass
       (.<! override (string/sub value 2) true)]
      [true
       (usage! (.. "Expected number or enable/disable flag for --" (.> arg :name) " , got " value))])))

(defun pass-run (fun name)
  "Create a task which runs FUN using the options from argument NAME."
  :hidden
  (lambda (compiler args)
    (with (options { ;; General pass options
                    :track     true
                    :level     (.> args name)
                    :override  (or (.> args (.. name "-override")) {})

                    ;; Optimisation specific options
                    :max-n     (.> args (.. name "-n"))
                    :max-time  (.> args (.. name "-time"))

                    ;; General shared options
                    :compiler  compiler
                    :logger    (.> compiler :log)
                    :timer     (.> compiler :timer) })
      (fun (.> compiler :out) options (pass/filter-passes (.> compiler name) options)))))

(define warning
  { :name  "warning"
    :setup (lambda (spec)
             (arg/add-argument! spec '("--warning" "-W")
               :help    "Either the warning level to use or an enable/disable flag for a pass."
               :default 1
               :narg    1
               :var     "LEVEL"
               :many    true
               :action  pass-arg))
    :pred  (cut id true)
    :run   (pass-run warning/analyse "warning") })

(define optimise
  { :name  "optimise"
    :setup (lambda (spec)
             (arg/add-category! spec "optimise" "Optimisation"
               "Various controls for how the source code is optimised.")
             (arg/add-argument! spec '("--optimise" "-O")
               :help    "Either the optimisation level to use or an enable/disable flag for a pass."
               :cat     "optimise"
               :default 1
               :narg    1
               :var     "LEVEL"
               :many    true
               :action  pass-arg)
             (arg/add-argument! spec '("--optimise-n" "--optn")
               :help    "The maximum number of iterations the optimiser should run for."
               :cat     "optimise"
               :default 10
               :narg    1
               :action  arg/set-num-action)
             (arg/add-argument! spec '("--optimise-time" "--optt")
               :help    "The maximum time the optimiser should run for."
               :cat     "optimise"
               :default -1
               :narg    1
               :action  arg/set-num-action))
    :pred  (cut id true)
    :run   (pass-run optimise/optimise "optimise") })
