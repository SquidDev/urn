(import urn/analysis/visitor visitor)
(import urn/backend/lua/emit ())
(import urn/backend/lua/escape (push-escape-var! escape-var) :export)
(import urn/backend/writer w)
(import urn/library ())
(import urn/resolve/scope scope)
(import urn/resolve/state state)
(import urn/timer timer)
(import urn/traceback traceback)

(import lua/basic (load))

(defun create-state ()
  {
  ;; [[run-pass]] options
  :timer      (timer/void)

  ;; execute-states options
  :count      0
  :mappings   {}

  ;; Various lookup tables
  :var-cache  {}
  :var-lookup {} })

(defun file (compiler shebang)
  "Generate a complete file using the current COMPILER state.

   Returns the resulting writer, from which you can extract line mappings
   and the resulting contents.

   If SHEBANG is specified then it will be prepended."
  (let* [(state (create-state))
         (out (w/create))]
    (when shebang
      (w/line! out (.. "#!/usr/bin/env " shebang)))

    (.<! state :trace true)

    (prelude out)

    (w/line! out "local _libs = {}")

    ;; Emit all native libraries
    (for-each lib (library-cache-loaded (.> compiler :libs))
      (let* [(prefix (string/quoted (.. (library-unique-name lib) "/")))
             (native (library-lua-contents lib))]
        (when native
          (w/begin-block! out "local _temp = (function()")
          (for-each line (string/split native "\n")
            (when (/= line "")
              (w/line! out line)))
          (w/end-block! out "end)()")
          (w/line! out (.. "for k, v in pairs(_temp) do _libs[" prefix ".. k] = v end")))))

    ;; Count the number of active variables
    (with (count 0)
      (for-each node (.> compiler :out)
        (when-with (var (.> node :def-var))
          (inc! count)))

      ;; Pre-escape all variables
      (for-each node (.> compiler :out)
        (when-with (var (.> node :def-var))
          (push-escape-var! var state true)))

      ;; Predeclare all variables. We only do this if we're pretty sure we won't hit the
      ;; "too many local variable" errors. The upper bound is actually 200, but lambda inlining
      ;; will probably bring it up slightly.
      ;; In the future we probably ought to handle this smartly when it is over 150 too.
      (cond
        [(= count 0)]
        [(<= count 100)
         (w/append! out "local ")
         (with (first true)
           (for-each node (.> compiler :out)
             (when-with (var (.> node :def-var))
               (if first
                 (set! first false)
                 (w/append! out ", "))
               (w/append! out (escape-var var state)))))
         (w/line! out)]
        [else
         ;; Very primitive counting of how often each variable is accessed.
         ;; TODO: Do some fancy things with graphs, to flow counts down
         ;; dependency graph.
         (let* [(counts {})
                (vars '())]
           (for-each node (.> compiler :out)
             (when-with (var (.> node :def-var))
               (.<! counts var 0)
               (push! vars var)))
           (visitor/visit-block (.> compiler :out) 1
             (lambda (x)
               (when (symbol? x)
                 (let* [(var (.> x :var))
                        (count (.> counts var))]
                   (when count (.<! counts var (succ count)))))))
           (sort! vars (lambda (x y) (> (.> counts x) (.> counts y))))

           (w/append! out "local ")
           (with (main-vars (map (cut escape-var <> state) (take vars 100)))
             (sort! main-vars)
             (w/append! out (concat main-vars ", ")))
           (w/line! out))

         ;; Create a magic metatable which avoids polluting the global output.
         (w/line! out "local _ENV = setmetatable({}, {__index=_ENV or (getfenv and getfenv()) or _G}) if setfenv then setfenv(0, _ENV) end")]))

    (block (.> compiler :out) out state 1 "return ")
    out))

(defun execute-states (back-state states global)
  "Attempt to execute a series of STATES in the GLOBAL environment.

   BACK-STATE is the backend state, as created with [[create-state]]."
  (let* [(state-list '())
         (name-list '())
         (export-list '())
         (escape-list '())
         (local-list '())]

    (for i (n states) 1 -1
      (with (state (nth states i))
        (unless (= (state/rs-stage state) "executed")
          (demand (state/rs-node state) (.. "State is in " (state/rs-stage state) " instead"))
          (let* [(var (or (state/rs-var state) (scope/temp-var "temp" (state/rs-node state))))
                 (escaped (push-escape-var! var back-state true))
                 (name (scope/var-name var))]
            (push! state-list state)
            (push! export-list (.. escaped " = " escaped))
            (push! name-list name)
            (push! escape-list escaped)

            ;; Only emit locals for variables which will not change. Otherwise
            ;; we'll end up ignoring later changes to the variable
            (when (or (not var) (scope/var-const? var))
              (push! local-list escaped))))))

    (unless (empty? state-list)
      (let* [(out (w/create))
             (id (.> back-state :count))
             (name (concat name-list ","))]

        ;; Update the new count
        (.<! back-state :count (succ id))

        ;; Setup the function name
        (when (> (n name) 20) (set! name (.. (string/sub name 1 17) "...")))
        (set! name (.. "compile#" id "{" name "}"))

        (prelude out)
        (unless (empty? local-list) (w/line! out (.. "local " (concat local-list ", "))))

        ;; Emit all expressions
        (for i 1 (n state-list) 1
          (with (state (nth state-list i))
            (expression
              (state/rs-node state) out back-state

              ;; If we don't have a variable then we'll assign this to the
              ;; temp variable. Otherwise it will be emitted in the main backend
              (if (state/rs-var state)
                ""
                (..(nth escape-list i) " = ")))
            (w/line! out)))

        (w/line! out (.. "return { " (concat export-list ", ") "}"))

        (with (str (w/->string out))
          ;; Store the traceback
          (.<! back-state :mappings name (traceback/generate-mappings (.> out :lines)))

          (case (list (load str (.. "=" name) "t" global))
            [(nil ?msg)
             (let* [(buffer '())
                    (lines (string/split str "\n"))
                    (fmt (.. "%" (n (number->string (n lines))) "d | %s"))]
               (for i 1 (n lines) 1
                 (push! buffer (sprintf fmt i (nth lines i))))
               (fail! (.. msg ":\n" (concat buffer "\n"))))]
            [(?fun)
             (case (list (xpcall fun traceback/traceback))
               [(false ?msg)
                (fail! (traceback/remap-traceback (.> back-state :mappings) msg))]
               [(true ?tbl)
                (for i 1 (n state-list) 1
                  (let* [(state (nth state-list i))
                         (escaped (nth escape-list i))
                         (res (.> tbl escaped))]
                    (state/executed! state res)
                    (when (.> state :var)
                      (.<! global escaped res))))])]))))))

(defun get-native (var)
  "Convert a native VAR into a function."
  (with (native (scope/var-native var))
    (unless (.> native :has-value)
      (with (out (w/create))
        (prelude out)
        (w/append! out "return ")
        (compile-native out var native)

        (.<! native :has-value true)
        (when-let* [(fun (load (w/->string out) (.. "=" (scope/var-name var))))
                    ((ok res) (pcall fun))]
          (.<! native :value res))))

    ;; TODO: Add setter to native or do something else
    (.> native :value)))
