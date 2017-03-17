(import urn/backend/lua/emit ())
(import urn/backend/lua/escape (escape-var) :export)
(import urn/backend/writer w)
(import urn/timer timer)
(import urn/traceback traceback)

(import extra/assert (assert!))
(import lua/basic (load))
(import lua/debug debug)
(import string)

(defun create-state (meta) (struct
                             ;; [[run-pass]] options
                             :level      1
                             :override   (empty-struct)
                             :timer      timer/void

                             ;; execute-states options
                             :count      0
                             :mappings   (empty-struct)

                             ;; Various lookup tables
                             :cat-lookup (empty-struct)
                             :ctr-lookup (empty-struct)
                             :var-lookup (empty-struct)
                             :meta       (or meta (empty-struct))))

(defun file (compiler shebang)
  "Generate a complete file using the current COMPILER state.

   Returns the resulting writer, from which you can extract line mappings
   and the resulting contents.

   If SHEBANG is specified then it will be prepended."
  (let* [(state (create-state (.> compiler :libMeta)))
         (out (w/create))]
    (when shebang
      (w/line! out (.. "#!/usr/bin/env " shebang)))

    (.<! state :trace true)

    (prelude out)

    (w/line! out "local _libs = {}")

    ;; Emit all native libraries
    (for-each lib (.> compiler :libs)
      (let* [(prefix (string/quoted (.> lib :prefix)))
             (native (.> lib :native))]
        (when native
          (w/line! out "local _temp = (function()")
          (for-each line (string/split native "\n")
            (when (/= line "")
              (w/append! out "\t")
              (w/line! out line)))
          (w/line! out "end)()")
          (w/line! out (.. "for k, v in pairs(_temp) do _libs[" prefix ".. k] = v end")))))

    ;; Count the number of active variables
    (with (count 0)
      (for-each node (.> compiler :out)
        (when-with (var (.> node :defVar))
          (inc! count)))

      ;; Predeclare all variables. We only do this if we're pretty sure we won't hit the
      ;; "too many local variable" errors. The upper bound is actually 200, but lambda inlining
      ;; will probably bring it up slightly.
      ;; In the future we probably ought to handle this smartly when it is over 150 too.
      (when (between? count 1 150)
        (w/append! out "local ")
        (with (first true)
          (for-each node (.> compiler :out)
            (when-with (var (.> node :defVar))
              (if first
                (set! first false)
                (w/append! out ", "))
              (w/append! out (escape-var var state)))))
        (w/line! out)))

    (block (.> compiler :out) out state 1 "return ")
    out))

(defun execute-states (back-state states global logger)
  "Attempt to execute a series of STATES in the GLOBAL environment.

   BACK-STATE is the backend state, as created with [[create-state]].
   All errors are logged to LOGGER."

  (let* [(state-list '())
         (name-list '())
         (export-list '())
         (escape-list '())]

    (for i (# states) 1 -1
      (with (state (nth states i))
        (unless (= (.> state :stage) "executed")
          (let* [(node (assert! (.> state :node) (.. "State is in " (.> state :stage) " instead")))
                 (var (or (.> state :var) (struct :name "temp")))
                 (escaped (escape-var var back-state))
                 (name (.> var :name))]
            (push-cdr! state-list state)
            (push-cdr! export-list (.. escaped " = " escaped))
            (push-cdr! name-list name)
            (push-cdr! escape-list escaped)))))

    (unless (nil? state-list)
      (let* [(out (w/create))
             (id (.> back-state :count))
             (name (concat name-list ","))]

        ;; Update the new count
        (.<! back-state :count (succ id))

        ;; Setup the function name
        (when (> (#s name) 20) (set! name (.. (string/sub name 1 17) "...")))
        (set! name (.. "compile#" id "{" name "}"))

        (prelude out)
        (w/line! out (.. "local " (concat escape-list ", ")))


        ;; Emit all expressions
        (for i 1 (# state-list) 1
          (with (state (nth state-list i))
            (expression
              (.> state :node) out back-state

              ;; If we don't have a variable then we'll assign this to the
              ;; temp variable. Otherwise it will be emitted in the main backend
              (if (.> state :var)
                ""
                (..(nth escape-list i) "= ")))
            (w/line! out)))

        (w/line! out (.. "return { " (concat export-list ", ") "}"))

        (with (str (w/->string out))
          ;; Store the traceback
          (.<! back-state :mappings name (traceback/generate-mappings (.> out :lines)))

          (case (list (load str (.. "=" name) "t" global))
            [(nil ?msg) (fail! (.. msg ":\n" str))]
            [(?fun)
             (case (list (xpcall fun debug/traceback))
               [(false ?msg)
                (fail! (traceback/remap-traceback (.> back-state :mappings) msg))]
               [(true ?tbl)
                (for i 1 (# state-list) 1
                  (let* [(state (nth state-list i))
                         (escaped (nth escape-list i))
                         (res (.> tbl escaped))]
                    (self state :executed res)
                    (when (.> state :var)
                      (.<! global escaped res))))])]))))))
