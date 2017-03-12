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
  (struct
    :name  "emit-lua"
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
             (when (nil? (.> args :input))
               (logger/put-error! (.> compiler :log) "No inputs to compile.")
               (exit! 1))

             (let* [(out (lua/file compiler (.> args :shebang)))
                    (handle (io/open (.. (.> args :output) ".lua") "w"))]
               (self handle :write (writer/->string out))
               (self handle :close)

               (when (.> args :chmod)
                 ;; string/quoted is not "correct" for escaping names but it is "good enough".
                 (os/execute (.. "chmod +x " (string/quoted (.. (.> args :output) ".lua")))))))))

(define emit-lisp
  (struct
    :name  "emit-lisp"
    :setup (lambda (spec)
             (arg/add-argument! spec '("--emit-lisp")
               :help "Emit a Lisp file."))
    :pred  (lambda (args) (.> args :emit-lisp))
    :run   (lambda (compiler args)
             (when (nil? (.> args :input))
               (logger/put-error! (.> compiler :log) "No inputs to compile.")
               (exit! 1))

             (with (writer (writer/create))
               (lisp/block (.> compiler :out) writer)
               (with (handle (io/open (.. (.> args :output) ".lisp") "w"))
                 (self handle :write (writer/->string writer))
                 (self handle :close))))))

(defun pass-arg (spec)
  "Handle the argument of a pass runner"
  (lambda (arg data value)
    (let* [(val (string->number value))
           (name (.. (.> arg :name) "-override"))
           (override (.> data name))]
      (unless override
        (set! override (empty-struct))
        (.<! data name override))
      (cond
        [val
         ;; If we've got a number then we'll try to use that
         (.<! data (.> arg :name) value)]
        [(= (string/char-at value 1) "-")
         ;; Disable this pass
         (.<! override (string/sub value 2) false)]
        [(= (string/char-at value 1) "+")
          ;; Enable this pass
         (.<! override (string/sub value 2) true)]
        [true
         (arg/usage-error! spec (nth arg 0) (.. "Expected number or enable/disable flag for --" (.> arg :name) " , got " value))]))))

(defun pass-run (fun name)
  "Create a task which runs FUN using the options from argument NAME."
  :hidden
  (lambda (compiler args)
    (fun (.> compiler :out) (struct
                              :track     true
                              :level     (.> args name)
                              :override  (or (.> args (.. name "-override")) (empty-struct))
                              :time      (.> args :time)
                              :meta      (.> compiler :libMeta)
                              :logger    (.> compiler :log)))))

(define warning
  (struct
    :name  "warning"
    :setup (lambda (spec)
             (arg/add-argument! spec '("--warning" "-W")
               :help    "Either the warning level to use or an enable/disable flag for a pass."
               :default 1
               :narg    1
               :var     "LEVEL"
               :action  (pass-arg spec)))
    :pred  (lambda (args) (> (.> args :warning) 0))
    :run   (pass-run warning/analyse "warning")))

(define optimise
  (struct
    :name  "optimise"
    :setup (lambda (spec)
             (arg/add-argument! spec '("--optimise" "-O")
               :help    "Either the optimiation level to use or an enable/disable flag for a pass."
               :default 1
               :narg    1
               :var     "LEVEL"
               :action  (pass-arg spec)))
    :pred  (lambda (args) (> (.> args :optimise) 0))
    :run   (pass-run optimise/optimise "optimise")))
