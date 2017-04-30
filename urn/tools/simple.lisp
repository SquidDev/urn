(import extra/argparse arg)
(import lua/io io)
(import lua/os os)
(import string)

(import urn/analysis/optimise optimise)
(import urn/analysis/warning warning)
(import urn/backend/lisp lisp)
(import urn/backend/lua lua)
(import urn/backend/writer writer)
(import urn/logger logger)

(define emit-lua
  { :name  "emit-lua"
    :setup (lambda (spec)
             (arg/add-argument! spec '("--emit-lua")
               :help   "Emit a Lua file.")
             (arg/add-argument! spec '("--shebang")
               :value   (or (nth arg -1) (nth arg 0) "lua")
               :help    "Set the executable to use for the shebang."
               :narg    "?")
             (arg/add-argument! spec '("--chmod")
               :help    "Run chmod +x on the resulting file"))
    :pred  (lambda (args) (.> args :emit-lua))
    :run   (lambda (compiler args)
             (when (empty? (.> args :input))
               (logger/put-error! (.> compiler :log) "No inputs to compile.")
               (exit! 1))

             (let* [(out (lua/file compiler (.> args :shebang)))
                    (handle (io/open (.. (.> args :output) ".lua") "w"))]
               (self handle :write (writer/->string out))
               (self handle :close)

               (when (.> args :chmod)
                 ;; string/quoted is not "correct" for escaping names but it is "good enough".
                 (os/execute (.. "chmod +x " (string/quoted (.. (.> args :output) ".lua"))))))) })

(define emit-lisp
  { :name  "emit-lisp"
    :setup (lambda (spec)
             (arg/add-argument! spec '("--emit-lisp")
               :help "Emit a Lisp file."))
    :pred  (lambda (args) (.> args :emit-lisp))
    :run   (lambda (compiler args)
             (when (empty? (.> args :input))
               (logger/put-error! (.> compiler :log) "No inputs to compile.")
               (exit! 1))

             (with (writer (writer/create))
               (lisp/block (.> compiler :out) writer)
               (with (handle (io/open (.. (.> args :output) ".lisp") "w"))
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

(defun pass-run (fun name passes)
  "Create a task which runs FUN using the options from argument NAME."
  :hidden
  (lambda (compiler args)
    (fun (.> compiler :out) {
                              ;; General pass options
                              :track     true
                              :level     (.> args name)
                              :override  (or (.> args (.. name "-override")) {})
                              :pass      (.> compiler name)

                              ;; Optimisation specific options
                              :max-n     (.> args (.. name "-n"))
                              :max-time  (.> args (.. name "-time"))

                              ;; General shared options
                              :compiler  compiler
                              :meta      (.> compiler :libMeta)
                              :libs      (.> compiler :libs)
                              :logger    (.> compiler :log)
                              :timer     (.> compiler :timer) })))

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
    :pred  (lambda (args) (> (.> args :warning) 0))
    :run   (pass-run warning/analyse "warning") })

(define optimise
  { :name  "optimise"
    :setup (lambda (spec)
             (arg/add-argument! spec '("--optimise" "-O")
               :help    "Either the optimiation level to use or an enable/disable flag for a pass."
               :default 1
               :narg    1
               :var     "LEVEL"
               :many    true
               :action  pass-arg)
             (arg/add-argument! spec '("--optimise-n" "--optn")
               :help    "The maximum number of iterations the optimiser should run for."
               :default 10
               :narg    1
               :action  arg/set-num-action)
             (arg/add-argument! spec '("--optimise-time" "--optt")
               :help    "The maximum time the optimiser should run for."
               :default -1
               :narg    1
               :action  arg/set-num-action))
    :pred  (lambda (args) (> (.> args :optimise) 0))
    :run   (pass-run optimise/optimise "optimise") })
