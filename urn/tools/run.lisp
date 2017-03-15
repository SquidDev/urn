(import extra/argparse arg)
(import lua/basic (_G load))
(import lua/basic b)
(import lua/debug debug)
(import lua/os os)
(import lua/table table)

(import urn/backend/lua lua)
(import urn/backend/writer w)
(import urn/logger logger)
(import urn/traceback traceback)

(defun run-with-profiler (fn mappings)
  (let* [(stats (empty-struct))
         (call-stack '())]

    (debug/sethook
      (lambda (action)
        (let* [(info (debug/getinfo 2 "Sn"))
               (start (os/clock))]
          ;; If we're calling, pause the parent function
          (when (= action "call")
             (when-with (previous (nth call-stack (# call-stack)))
               (.<! previous :sum (+ (.> previous :sum) (- start (.> previous :innerStart))))))

          ;; Unless this is a call, pop the current function
          (when (/= action "call")
            (unless (nil? call-stack)
              (let* [(current (pop-last! call-stack))
                     (hash (b/.. (.> current :source) (.> current :linedefined)))
                     (entry (.> stats hash))]

                (unless entry
                  (set! entry (const-struct
                                :source    (.> current :source)
                                :short-src (.> current :short_src)
                                :line      (.> current :linedefined)
                                :name      (.> current :name)

                                :calls     0
                                :totalTime 0
                                :innerTime 0))

                  (.<! stats hash entry))

                ;; Push the current entry
                (.<! entry :calls (+ 1 (.> entry :calls)))
                (.<! entry :totalTime (+ (.> entry :totalTime) (- start (.> current :totalStart))))
                (.<! entry :innerTime (+ (.> entry :innerTime) (+ (.> current :sum) (- start (.> current :innerStart))))))))

          ;; Unless this is a return, push the new function
          (when (/= action "return")
             ;; And push the new one
             (.<! info :totalStart start)
             (.<! info :innerStart start)
             (.<! info :sum        0)
             (push-cdr! call-stack info))

          ;; If we're returning, resume the parent function
          (when (= action "return")
            (when-with (next (last call-stack))
               (.<! next :innerStart start)))))
      "cr")

    (fn)

    (debug/sethook nil)

    (with (out (values stats))
      (table/sort out (lambda (a b) (> (.> a :innerTime) (.> b :innerTime))))

      (print! (string/format "| %20s | %-60s | %8s | %8s | %7s |"
                "Method"
                "Location"
                "Total"
                "Inner"
                "Calls"))

      (print! (string/format "| %20s | %-60s | %8s | %8s | %7s |"
                (string/rep "-" 20)
                (string/rep "-" 60)
                (string/rep "-" 8)
                (string/rep "-" 8)
                (string/rep "-" 7)))

      (for-each entry out
        (print! (string/format "| %20s | %-60s | %8.5f | %8.5f | %7d | "
                  (if (.> entry :name) (traceback/unmangle-ident (.> entry :name)) "<unknown>")
                  (traceback/remap-message mappings (.. (.> entry :short-src) ":" (.> entry :line)))
                  (.> entry :totalTime)
                  (.> entry :innerTime)
                  (.> entry :calls)))))

    stats))

(defun run-lua (compiler args)
  (when (nil? (.> args :input))
    (logger/put-error! (.> compiler :log) "No inputs to run.")
    (exit! 1))

  (let* [(out (lua/file compiler false))
         (lines (traceback/generate-mappings (.> out :lines)))
         (logger (.> compiler :log))
         (name (.. (or (.> args :output) "out") ".lua"))]
    (case (list (load (w/->string out) (.. "=" name)))
      [(nil ?msg)
       (logger/put-error! logger "Cannot load compiled source.")
       (print! msg)
       (print! (w/->string out))
       (exit! 1)]
      [(?fun)
       (.<! _G :arg (.> args :script-args))
       (.<! _G :arg 0 (car (.> args :input)))
       (with (exec (lambda ()
                     (case (list (xpcall fun debug/traceback))
                       [(true . ?res)]
                       [(false ?msg)
                        (logger/put-error! logger "Execution failed.")
                        (print! (traceback/remap-traceback (struct name lines) msg))
                        (exit! 1)])))
         (if (.> args :profile)
           (run-with-profiler exec (struct name lines))
           (exec)))])))

(define task
  (struct
    :name  "run"
    :setup (lambda (spec)
             (arg/add-argument! spec '("--run" "-r")
               :help "Run the compiled code.")
             (arg/add-argument! spec '("--profile" "-p")
               :help "Run the compiled code with the profiler.")
             (arg/add-argument! spec '("--")
               :name    "script-args"
               :help    "Arguments to pass to the compiled script."
               :var     "ARG"
               :all     true
               :default '()
               :action  arg/add-action
               :narg    "*"))
    :pred  (lambda (args) (or (.> args :run) (.> args :profile)))
    :run   run-lua))
