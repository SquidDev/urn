(import string)
(import lua/basic (_G load))
(import lua/debug debug)
(import extra/argparse arg)

(import urn/backend/lua lua)
(import urn/backend/writer w)
(import urn/logger logger)
(import urn/traceback traceback)

(defun run-lua (compiler args)
  (when (nil? (.> args :input))
    (logger/put-error! "No inputs to run")
    (exit! 1))

  (let* [(out (lua/file compiler false))
         (lines (traceback/generate-mappings (.> out :lines)))
         (logger (.> compiler :log))
         (name (.. (or (.> args :output) "out") ".lua"))]
    (case (list (load (w/->string out) (.. "=" name)))
      [(nil ?msg)
       (logger/put-error! logger "Cannot load compiled source")
       (print! msg)
       (print! (w/->string out))
       (exit! 1)]
      [(?fun)
       (.<! _G (.> args :script-args) args)
       (case (list (xpcall fun debug/traceback))
         [(true . ?res)]
         [(false ?msg)
          (logger/put-error! logger "Execution failed")
          (print! (traceback/remap-traceback (struct name lines) msg))
          (exit! 1)])])))

(define task
  (struct
    :name  "run"
    :setup (lambda (spec)
             (arg/add-argument! spec '("--run" "-r")
               :help "Run the compiled code")
             (arg/add-argument! spec '("--")
               :name    "script-args"
               :help    "Arguments to pass to the compiled script."
               :var     "ARG"
               :all     true
               :default '()
               :action  arg/add-action
               :narg    "*"))
    :pred  (lambda (args) (.> args :run))
    :run   run-lua))
