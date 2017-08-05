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
  (let* [(stats {})
         (call-stack '())]

    (debug/sethook
      (lambda (action)
        (let* [(info (debug/getinfo 2 "Sn"))
               (start (os/clock))]
          ;; If we're calling, pause the parent function
          (when (= action "call")
             (when-with (previous (nth call-stack (n call-stack)))
               (.<! previous :sum (+ (.> previous :sum) (- start (.> previous :inner-start))))))

          ;; Unless this is a call, pop the current function
          (when (/= action "call")
            (unless (empty? call-stack)
              (let* [(current (pop-last! call-stack))
                     (hash (b/.. (.> current :source) (.> current :linedefined)))
                     (entry (.> stats hash))]

                (unless entry
                  (set! entry { :source     (.> current :source)
                                :short-src  (.> current :short_src)
                                :line       (.> current :linedefined)
                                :name       (.> current :name)

                                :calls      0
                                :total-time 0
                                :inner-time 0 })

                  (.<! stats hash entry))

                ;; Push the current entry
                (.<! entry :calls (+ 1 (.> entry :calls)))
                (.<! entry :total-time (+ (.> entry :total-time) (- start (.> current :total-start))))
                (.<! entry :inner-time (+ (.> entry :inner-time) (+ (.> current :sum) (- start (.> current :inner-start))))))))

          ;; Unless this is a return, push the new function
          (when (/= action "return")
             ;; And push the new one
             (.<! info :total-start start)
             (.<! info :inner-start start)
             (.<! info :sum         0)
             (push-cdr! call-stack  info))

          ;; If we're returning, resume the parent function
          (when (= action "return")
            (when-with (next (last call-stack))
               (.<! next :inner-start start)))))
      "cr")

    (fn)

    (debug/sethook)

    (with (out (values stats))
      (table/sort out (lambda (a b) (> (.> a :inner-time) (.> b :inner-time))))

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
                  (.> entry :total-time)
                  (.> entry :inner-time)
                  (.> entry :calls)))))

    stats))

(defun build-stack (parent stack i history fold)
  "Fold a STACK trace into PARENT, looking at the element I.

   This folds from the bottom of the stack, merging upwards, resulting in a normal
   flame graph.

   HISTORY and FOLD are used to fold recursive functions into themselves, hopefully simplifying
   the stack."
  :hidden
  ;; Increment the number of times hit
  (.<! parent :n (+ (.> parent :n) 1))

  (when (>= i 1)
    (let* [(elem (nth stack i))
           (hash (.. (.> elem :source) "|" (.> elem :linedefined)))
           (previous (and fold (.> history hash)))
           (child (.> parent hash))]

      (when previous
        ;; If we've this function in our history already, we'll push to that.
        ;; We decrement it by one to make the graph easier to understand:
        ;; otherwise we're counting the same function multiple times.
        (.<! parent :n (- (.> parent :n) 1))
        (set! child previous))

      (unless child
        (set! child elem)
        (.<! elem :n 0)
        (.<! parent hash child))

      ;; If we've no previous, we push this one to the lookup and pop it again afterwards
      (unless previous (.<! history hash child))
      (build-stack child stack (- i 1) history fold)
      (unless previous (.<! history hash nil)))))

(defun build-rev-stack (parent stack i history fold)
  "Fold a STACK trace into PARENT, looking at the element I.

   This folds from the top of the stack merging downwards, resulting
   in a reverse flame graph, with the root functions.

   HISTORY and FOLD are used to fold recursive functions into themselves, hopefully simplifying
   the stack.

   Word of warning: this generates massive messages: I would not recommend
   running this unless you really want to."
  :hidden
  ;; Increment the number of times hit
  (.<! parent :n (+ (.> parent :n) 1))

  (when (<= i (n stack))
    (let* [(elem (nth stack i))
           (hash (.. (.> elem :source) "|" (.> elem :linedefined)))
           (previous (and fold (.> history hash)))
           (child (.> parent hash))]

      ;; If we've this function in our history already, we'll push to that.
      (when previous
        (.<! parent :n (- (.> parent :n) 1))
        (set! child previous))

      (unless child
        (set! child elem)
        (.<! elem :n 0)
        (.<! parent hash child))

      ;; If we've no previous, we push this one to the lookup and pop it again afterwards
      (unless previous (.<! history hash child))
      (build-rev-stack child stack (+ i 1) history fold)
      (unless previous (.<! history hash nil)))))


(defun finish-stack (element)
  "This converts the lookup of ELEMENT into a sorted list with
   the most called method at the beginning."
  :hidden
  (with (children '())
    (for-pairs (k child) element
      (when (table? child)
        (push-cdr! children child)))

    (table/sort children (lambda (a b) (> (.> a :n) (.> b :n))))

    (.<! element :children children)
    (for-each child children (finish-stack child))))

(defun show-stack! (out mappings total stack remaining)
  "This prints STACK to OUT, using MAPPINGS to map source locations and TOTAL to
   determine the percentage. REMAINING marks the remaining number of entries to emit."
  :hidden
  (w/line! out (string/format "\xE2\x94\x94 %s %s %d (%2.5f%%)"
                 (if (.> stack :name) (traceback/unmangle-ident (.> stack :name)) "<unknown>")
                 (if (.> stack :short_src) (traceback/remap-message mappings (.. (.> stack :short_src) ":" (.> stack :linedefined))) "")
                 (.> stack :n) (* (/ (.> stack :n) total) 100)))
  (when (if remaining (>= remaining 1) true)
    (w/indent! out)
    (for-each child (.> stack :children)
      (show-stack! out mappings total child (and remaining (pred remaining))))
    (w/unindent! out)))

(defun show-flame! (mappings stack before remaining)
  "This prints STACK to OUT in a format readable by flamegraph.pl

   MAPPINGS to map source locations. REMAINING is used to limit the number of traces to
   emit."
  :hidden
  (with (renamed (..
                   (if (.> stack :name) (traceback/unmangle-ident (.> stack :name)) "?")
                   "`"
                   (if (.> stack :short_src) (traceback/remap-message mappings (.. (.> stack :short_src) ":" (.> stack :linedefined))) "")))
    (print! (string/format "%s%s %d" before renamed (.> stack :n)))
    (when (if remaining (>= remaining 1) true)
      (with (whole (.. before renamed ";"))
        (for-each child (.> stack :children) (show-flame! mappings child whole (and remaining (pred remaining))))))))

(defun profile-stack (fn mappings args)
  :hidden
  (let* [(stacks '())
         (top (debug/getinfo 2 "S"))]

    (debug/sethook
      (lambda (action)
        (let* [(pos 3)
               (stack '())
               (info (debug/getinfo 2 "Sn"))]
          (while info
            (if (and (= (.> info :source) (.> top :source)) (= (.> info :linedefined) (.> top :linedefined)))
              (set! info nil)
              (progn
                (push-cdr! stack info)
                (inc! pos)
                (set! info (debug/getinfo pos "Sn")))))
          (push-cdr! stacks stack)))

      "" 1e5)

    (fn)

    (debug/sethook)

    (with (folded {:n 0 :name "<root>"})
      (for-each stack stacks
        (if (= (.> args :stack-kind) "reverse")
          (build-rev-stack folded stack 1 {} (.> args :stack-fold))
          (build-stack folded stack (n stack) {} (.> args :stack-fold))))

      (finish-stack folded)

      (if (= (.> args :stack-show) "flame")
        (show-flame! mappings folded "" (or (.> args :stack-limit) 30))
        (with (writer (w/create))
          (show-stack! writer mappings (n stacks) folded (or (.> args :stack-limit) 10))
          (print! (w/->string writer)))))))

(defun run-lua (compiler args)
  :hidden
  (when (empty? (.> args :input))
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
                        (print! (traceback/remap-traceback { name lines } msg))
                        (exit! 1)])))
         (case (.> args :profile)
           ["none"  (exec)]
           [nil  (exec)]
           ["call"  (profile-calls exec { name lines })]
           ["stack" (profile-stack exec { name lines } args)]
           [?x
            (logger/put-error! logger (.. "Unknown profiler '" x "'"))
            (exit! 1)]))])))

(define task
  { :name  "run"
    :setup (lambda (spec)
             (arg/add-category! spec "run" "Running files"
               "Provides a way to running the compiled script, along with various extensions such as profiling tools.")
             (arg/add-argument! spec '("--run" "-r")
               :help "Run the compiled code."
               :cat  "run")
             (arg/add-argument! spec '("--")
               :name    "script-args"
               :cat     "run"
               :help    "Arguments to pass to the compiled script."
               :var     "ARG"
               :all     true
               :default '()
               :action  arg/add-action
               :narg    "*")
             (arg/add-argument! spec '("--profile" "-p")
               :help    "Run the compiled code with the profiler."
               :cat     "run"
               :var     "none|call|stack"
               :default nil
               :value   "stack"
               :narg    "?")
             (arg/add-argument! spec '("--stack-kind")
               :help    "The kind of stack to emit when using the stack profiler. A reverse stack shows callers of that method instead."
               :cat     "run"
               :var     "forward|reverse"
               :default "forward"
               :narg    1)
             (arg/add-argument! spec '("--stack-show")
               :help    "The method to use to display the profiling results."
               :cat     "run"
               :var     "flame|term"
               :default "term"
               :narg    1)
             (arg/add-argument! spec '("--stack-limit")
               :help    "The maximum number of call frames to emit."
               :cat     "run"
               :var     "LIMIT"
               :default nil
               :action  arg/set-num-action
               :narg    1)
             (arg/add-argument! spec '("--stack-fold")
               :help    "Whether to fold recursive functions into themselves. This hopefully makes deep graphs easier to understand, but may result in less accurate graphs."
               :cat     "run"
               :value   true
               :default false))

    :pred  (lambda (args) (or (.> args :run) (.> args :profile)))
    :run   run-lua })
