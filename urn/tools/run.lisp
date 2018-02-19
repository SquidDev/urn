(import io/argparse arg)
(import lua/basic (_G load))
(import lua/basic b)
(import lua/debug debug)
(import lua/os os)

(import urn/analysis/nodes (builtin builtin?))
(import urn/analysis/visitor visitor)
(import urn/backend/lua lua)
(import urn/backend/writer w)
(import urn/library library)
(import urn/logger logger)
(import urn/range ())
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
             (push! call-stack  info))

          ;; If we're returning, resume the parent function
          (when (= action "return")
            (when-with (next (last call-stack))
               (.<! next :inner-start start)))))
      "cr")

    (fn)

    (debug/sethook)

    (with (out (values stats))
      (sort! out (lambda (a b) (> (.> a :inner-time) (.> b :inner-time))))

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
    (for-pairs (_ child) element
      (when (table? child)
        (push! children child)))

    (sort! children (lambda (a b) (> (.> a :n) (.> b :n))))

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
        (let* [(pos 2)
               (stack '())
               (info (debug/getinfo 2 "Sn"))]
          (while info
            (if (and (= (.> info :source) (.> top :source)) (= (.> info :linedefined) (.> top :linedefined)))
              (set! info nil)
              (progn
                (push! stack info)
                (inc! pos)
                (set! info (debug/getinfo pos "Sn")))))
          (push! stacks stack)))

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

(defun matcher (pattern)
  "A utility function which creates a lambda to check if PATTERN matches
   the given argument."
  :hidden
  (lambda (x)
    (with (res (list (string/match x pattern)))
      (if (= (car res) nil) nil res))))

(defun add-count! (counts name line count)
  "Increment the COUNTS for NAME at the given LINE."
  :hidden
  (with (file-counts (.> counts name))
    (unless file-counts
      (set! file-counts { :max 0 })
      (.<! counts name file-counts))

    (when (> line (.> file-counts :max))
      (.<! file-counts :max line))

    (.<! file-counts line (+ (or (.> file-counts line) 0) count))))

(defun read-stats! (file-name output)
  "Read in the stats from the given FILE-NAME if it exists."
  :hidden
  (unless output (set! output {}))

  (use [(file (io/open file-name "r"))]
    (loop [] []
      (when-let* [(max (self file :read "*n"))
                  (colon (= (self file :read 1) ":"))
                  (name (self file :read "*l"))]
        (with (data (.> output name))
          (cond
            [(not data)
             (set! data { :max max })
             (.<! output name data)]
            [(> max (.> data :max)) (.<! data :max max)]
            [else])

          (loop
            [(line 1)]
            [(> line max)]
            (when-let* [(count (self file :read "*n"))
                        (space (= (self file :read 1) " "))]
              (when (> count 0)
                (.<! data line (+ (or (.> data line) 0) count)))
              (recur (succ line)))))

        (recur))))

  output)

(defun write-stats! (compiler file-name output)
  "Write the OUTPUT stats to the given FILE-NAME."
  :hidden
  (with ((handle err) (io/open file-name "w"))
    (unless handle
      (logger/put-error! (.> compiler :log) (format nil "Cannot open stats file {#err:id}"))
      (exit! 1))

    (with (names (keys output))
      (sort! names)

      (for-each name names
        (with (data (.> output name))
          (self handle :write (.> data :max) ":" name "\n")
          (for i 1 (.> data :max) 1
            (self handle :write (or (.> data i) 0) " "))
          (self handle :write "\n"))))

    (self handle :close)))

(defun profile-coverage-hook (visited)
  "Create a coverage hook using the given VISITED map."
  :hidden
  (lambda (action line)
    (with (source (.> (debug/getinfo 2 "S") :short_src))
      (with (visited-lines (.> visited source))
        (unless visited-lines
          (set! visited-lines {})
          (.<! visited source visited-lines))

        (with (current (succ (or (.> visited-lines line) 0)))
          (.<! visited-lines line current))))))

(defun profile-coverage (fn mappings compiler)
  "Run FN tracking coverage and mapping it back to the original files."
  :hidden
  (with (visited (or (.> compiler :coverage-visited) {}))
    (debug/sethook (profile-coverage-hook visited) "l")
    (fn)
    (debug/sethook)

    (.<! visited (.> (debug/getinfo 1 "S") :short_src) nil)

    (with (result (read-stats! "luacov.stats.out"))
      (for-pairs (name visited-lines) visited
        (with (this-mappings (.> mappings name))
          (if this-mappings
            (for-pairs (line count) visited-lines
              (with (mapped (.> this-mappings line))
                (case mapped
                  ;; This file was mapped but not within an active region: ignore it.
                  [nil]
                  ;; Increment very line within the range
                  [((matcher "^(.-):(%d+)%-(%d+)$") -> (?file ?start ?end))
                   (for line (string->number start) (string->number end) 1
                     (add-count! result file (string->number line) count))]
                  ;; TODO: What happens if we've got multiple lines which map to the same Urn node?
                  ;; This could occur on conditions with variable binds in the test.
                  [((matcher "^(.-):(%d+)$") -> (?file ?line))
                   (add-count! result file (string->number line) count)])))
            (for-pairs (line count) visited-lines
              (add-count! result name line count)))))

      (write-stats! compiler "luacov.stats.out" result))))

(defun format-coverage (hits misses)
  "Format the given coverage statistic"
  :hidden
  (if (and (= hits 0) (= misses 0))
    "100%"
    (string/format "%2.f%%" (* 100 (/ hits (+ hits misses))))))

(defun gen-coverage-report (compiler args)
  "Generate a coverage report, saving it to the given output."
  :hidden
  (when (empty? (.> args :input))
      (logger/put-error! (.> compiler :log) "No inputs to generate a report for.")
      (exit! 1))

  (let [(stats (read-stats! "luacov.stats.out"))
        (logger (.> compiler :log))
        (max 0)]
    (for-pairs (_ counts) stats
      (for-pairs (line count) counts
        (when (and (number? line) (> count max)) (set! max count))))

    (let* [(max-size (n (string/format "%d" max)))
           (fmt-zero (.. (string/rep "*" max-size) "0"))
           (fmt-none (string/rep " " (succ max-size)))
           (fmt-num  (.. "%" (succ max-size) "d"))

           ((handle err) (io/open (or (.> args :gen-coverage) "luacov.report.out") "w"))
           (summary '())
           (total-hits 0)
           (total-misses 0)]
      (unless handle
        (logger/put-error! logger (format nil "Cannot open report file {#err:id}"))
        (exit! 1))

      (for-each path (.> args :input)
        (self handle :write (string/rep "=" 78) "\n")
        (self handle :write path "\n")
        (self handle :write (string/rep "=" 78) "\n")

        (let* [(lib (library/library-cache-at-path (.> compiler :libs) path))
               (lines (library/library-lisp-lines lib))
               (n-lines (n lines))
               (counts (.> stats path))
               (active {})
               (hits 0)
               (misses 0)]
          (visitor/visit-block (library/library-nodes lib) 1
            (lambda (node)
              (when (or (not (list? node)) ;; Non-list nodes are always interesting
                      (with (head (car node))
                        (case (type head)
                          ["symbol"
                           ;; If invoking a symbol then check whether it is a trivial builtin.
                           (with (var (.> head :var))
                             ;; Otherwise, check the symbol isn't one of these simple side-effect-free builtins.
                             (and
                               (/= var (builtin :lambda)) (/= var (builtin :cond)) (/= var (builtin :import))
                               (/= var (builtin :define)) (/= var (builtin :define-macro)) (/= var (builtin :define-native))))]

                          ["list"
                           ;; Don't emit directly-called lambdas.
                           (not (builtin? (car head) :lambda))]
                          [else true])))

                (with (source (get-source node))
                  (when (= (range-name source) path)
                    (for i (pos-line (range-start source)) (pos-line (range-finish source)) 1
                      (.<! active i true)))))))

          (for i 1 n-lines 1
            (let* [(line (nth lines i))
                   (is-active (.> active i))
                   (count (or (and counts (.> counts i)) 0))]
              (when (and (not is-active) (> count 0))
                (logger/put-warning! logger (format nil "{#path:id}:{#i:id} is not active but has count {#count:id}")))

              (cond
                [(not is-active)
                 (if (= line "")
                   (self handle :write "\n")
                   (self handle :write fmt-none " " line "\n"))]
                [(> count 0)
                 (inc! hits)
                 (self handle :write (string/format fmt-num count) " " line "\n")]
                [true
                 (inc! misses)
                 (self handle :write fmt-zero " " line "\n")])))

          (push! summary (list path
                               (string/format "%d" hits)
                               (string/format "%d" misses)
                               (format-coverage hits misses)))
          (set! total-hits (+ total-hits hits))
          (set! total-misses (+ total-misses misses))))

      (self handle :write (string/rep "=" 78) "\n")
      (self handle :write "Summary\n")
      (self handle :write (string/rep "=" 78) "\n\n")

      (let* [(headings '("File" "Hits" "Misses" "Coverage"))
             (widths (map n headings))
             (total (list "Total"
                      (string/format "%d" total-hits)
                      (string/format "%d" total-misses)
                      (format-coverage total-hits total-misses)))]
        (for-each row summary
          (for i 1 (n row) 1
            (with (width (n (.> row i)))
              (when (> width (.> widths i)) (.<! widths i width)))))

        (for i 1 (n total) 1
          (with (width (n (.> total i)))
            (when (> width (.> widths i)) (set! widths i))))

        (let* [(format (.. "%-" (concat widths "s %-") "s\n"))
               (separator (.. (string/rep "-" (n (apply string/format format headings))) "\n"))]
          (self handle :write (apply string/format format headings))
          (self handle :write separator)
          (for-each row summary
            (self handle :write (apply string/format format row)))
          (self handle :write separator)
          (self handle :write (apply string/format format total))))

      (self handle :close))))

(defun init-lua (compiler args)
  :hidden
  (when (.> args :profile-compile)
    (case (.> args :profile)
      ["coverage"
      ;; Setup the executor wrapper
      (let* [(visited {})
             (hook (profile-coverage-hook visited))
             (exec (.> compiler :exec))]
        (.<! compiler :coverage-visited visited)
        (.<! compiler :exec (lambda (func)
                              (debug/sethook hook "l")
                              (with (result (exec func))
                                (debug/sethook)
                                result))))]
      [_])))

(defun run-lua (compiler args)
  :hidden
  (when (empty? (.> args :input))
    (logger/put-error! (.> compiler :log) "No inputs to run.")
    (exit! 1))

  (let* [(out (lua/file compiler false))
         (lines (traceback/generate-mappings (.> out :lines)))
         (logger (.> compiler :log))
         (name (if (string? (.> args :emit-lua))
                 (.> args :emit-lua)
                 (.. (.> args :output) ".lua")))]
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
                     (case (list (xpcall (cut apply fun (.> args :script-args)) traceback/traceback))
                       [(true . _)]
                       [(false ?msg)
                        (logger/put-error! logger "Execution failed.")
                        (print! (traceback/remap-traceback { name lines } msg))
                        (exit! 1)])))
         (case (.> args :profile)
           ["none"  (exec)]
           [nil     (exec)]
           ["call"  (profile-calls exec { name lines })]
           ["stack" (profile-stack exec { name lines } args)]
           ["coverage" (profile-coverage exec (merge (.> compiler :compile-state :mappings)
                                                     { name lines }) compiler)]
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
             (arg/add-argument! spec '("--profile-compile")
               :help    "Run the profiler when evaluating code at compile time. Not all profilers support this."
               :cat     "run")
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
    :init  init-lua
    :run   run-lua })

(define coverage-report
  { :name "coverage-report"
    :setup (lambda (spec)
             (arg/add-argument! spec '("--gen-coverage")
               :help    "Specify the folder to emit documentation to."
               :cat     "run"
               :default nil
               :value   "luacov.report.out"
               :narg    "?"))
    :pred  (lambda (args) (/= nil (.> args :gen-coverage)))
    :run   gen-coverage-report })
