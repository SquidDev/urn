(import extra/argparse arg)
(import lua/io io)
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
               :default (or (nth arg 0) (nth arg -1) or "lua")
               :help    "Set the executable to use for the shebang."
               :narg    "?"))
    :pred  (lambda (args) (.> args :emit-lua))
    :run   (lambda (compiler args)
             (when (nil? (.> args :input))
               (logger/put-error! "No inputs to compille.")
               (exit! 1))

             (let* [(out (lua/file compiler (.> args :shebang)))
                    (handle (io/open (.. (.> args :output) ".lua") "w"))]
               (self handle :write (writer/->string out))
               (self handle :close)))))

(define emit-lisp
  (struct
    :name  "emit-lisp"
    :setup (lambda (spec)
             (arg/add-argument! spec '("--emit-lisp")
               :help "Emit a Lisp file."))
    :pred  (lambda (args) (.> args :emit-lisp))
    :run   (lambda (compiler args)
             (when (nil? (.> args :input))
               (logger/put-error! "No inputs to compille.")
               (exit! 1))

             (with (writer (writer/create))
               (lisp/block (.> compiler :out) writer)
               (with (handle (io/open (.. (.> args :output) ".lisp") "w"))
                 (self handle :write (writer/->string writer))
                 (self handle :close))))))

(define warning
  (struct
    :name  "warning"
    :setup (lambda (spec)
             (arg/add-argument! spec '("--warning" "-W")
               :help    "The warning level to use."
               :default 1
               :narg    1))
    :pred  (lambda (args) (> (.> args :warning) 0))
    :run   (lambda (compiler args)
             (warning/analyse (.> compiler :out) (struct
                                                   :meta   (.> compiler :libMeta)
                                                   :logger (.> compiler :log))))))

(define optimise
  (struct
    :name  "optimise"
    :setup (lambda (spec)
             (arg/add-argument! spec '("--optimise" "-O")
               :help    "The optimiation level to use."
               :default 1
               :narg    1))
    :pred  (lambda (args) (> (.> args :optimise) 0))
    :run   (lambda (compiler args)
             (optimise/optimise (.> compiler :out) (struct
                                                     :meta   (.> compiler :libMeta)
                                                     :logger (.> compiler :log))))))
