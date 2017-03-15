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

(defun profile-calls (fn mappings)
  :hidden
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

    (debug/sethook)

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

(defun build-stack (parent stack i)
  ;; Increment the number of times hit
  (.<! parent :n (+ (.> parent :n) 1))

  (when (<= i (# stack))
    (let* [(elem (nth stack i))
           (hash (.. (.> first :source) "|" (.> first :linedefined)))
           (child (.> parent hash))]
      (unless child
        (set! child elem)
        (.<! first :n 0)
        (.<! parent hash child))

      (build-stack child stack (+ i 1)))))

(defun profile-stack (fn mappings)
  :hidden
  (with (stacks '())

    (debug/sethook
      (lambda (action)
        (let* [(pos 2)
               (stack '())
               (info (debug/getinfo pos "Sn"))
          (while info
            (push-cdr! stack info)
            (inc! pos)
            (set! info (debug/getinfo pos "Sn")))
          (push-cdr! stacks stack)))

      "", 1e5)

    (fn)

    (debug/sethook)


    (with (folded (const-struct :n 0))
      (for-each stack stacks
        (built-stack folded stack 1)))))


(defun run-lua (compiler args)
  :hidden
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
         (case (string/lower (.> args :profile))
           ["none"  (exec)]
           ["call"  (profile-call exec (struct name lines))]
           ["stack" (profile-stack exec (struct name lines))]
           [?x
            (logger/put-error! logger (.. "Unknown profiler '" x "'"))
            (exit! 1)]))])))

(define task
  (struct
    :name  "run"
    :setup (lambda (spec)
             (arg/add-argument! spec '("--run" "-r")
               :help "Run the compiled code.")
             (arg/add-argument! spec '("--profile" "-p")
               :help    "Run the compiled code with the profiler."
               :var     "TYPE"
               :default "none"
               :value   "call"
               :narg    "?")
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
