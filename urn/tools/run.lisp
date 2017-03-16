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
  "Fold a STACK trace into PARENT, looking at the element I.

   This folds from the bottom of the stack, merging upwards, resulting in a normal
   flame graph."
  :hidden
  ;; Increment the number of times hit
  (.<! parent :n (+ (.> parent :n) 1))

  (when (>= i 1)
    (let* [(elem (nth stack i))
           (hash (.. (.> elem :source) "|" (.> elem :linedefined)))
           (child (.> parent hash))]
      (unless child
        (set! child elem)
        (.<! elem :n 0)
        (.<! parent hash child))

      (build-stack child stack (- i 1)))))

(defun build-rev-stack (parent stack i)
  "Fold a STACK trace into PARENT, looking at the element I.

   This folds from the top of the stack merging downwards, resulting
   in a reverse flame graph, with the root functions.

   Word of warning: this generates massive messages: I would not recommend
   running this unless you really want to."
  :hidden
  ;; Increment the number of times hit
  (.<! parent :n (+ (.> parent :n) 1))

  (when (<= i (# stack))
    (let* [(elem (nth stack i))
           (hash (.. (.> elem :source) "|" (.> elem :linedefined)))
           (child (.> parent hash))]
      (unless child
        (set! child elem)
        (.<! elem :n 0)
        (.<! parent hash child))

      (build-rev-stack child stack (+ i 1)))))

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
                 (traceback/remap-message mappings (.. (.> stack :short_src) ":" (.> stack :linedefined)))
                 (.> stack :n) (* (/ (.> stack :n) total) 100)))
  (when (if remaining (>= remaining 0) true)
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
                   (traceback/remap-message mappings (.. (.> stack :short_src) ":" (.> stack :linedefined)))))
    (print! (string/format "%s%s %d" before renamed (.> stack :n)))
    (when (if remaining (>= remaining 0) true)
      (with (whole (.. before renamed ";"))
        (for-each child (.> stack :children) (show-flame! mappings child whole (and remaining (pred remaining))))))))

(defun profile-stack (fn mappings)
  :hidden
  (with (stacks '())

    (debug/sethook
      (lambda (action)
        (let* [(pos 3)
               (stack '())
               (info (debug/getinfo 2 "Sn"))]
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
        (build-stack folded stack (# stack)))
        ;; (build-rev-stack folded stack 1))

      (finish-stack folded)

      ;; (with (writer (w/create))
      ;;   (show-stack! writer mappings (# stacks) folded 13)
      ;;   (print! (w/->string writer))))))

      (show-flame! mappings folded "" 15))))

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
         (case (.> args :profile)
           ["none"  (exec)]
           [nil  (exec)]
           ["call"  (profile-calls exec (struct name lines))]
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
               :default nil
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
