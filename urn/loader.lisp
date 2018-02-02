(import data/struct ())
(import lua/basic (load))
(import lua/io io)

(import urn/library ())
(import urn/logger logger)
(import urn/parser parser)
(import urn/range range)
(import urn/resolve/loop (compile))
(import urn/resolve/scope scope)
(import urn/timer timer)
(import urn/traceback (traceback-plain))

(define path-escape
  "Lookup of characters to their escaped pattern variants."
  :hidden
  { "?" "(.*)"
    "." "%." "%" "%%"
    "^" "%^" "$" "%$"
    "+" "%+" "-" "%-" "*" "%*"
    "[" "%[" "]" "%]"
    "(" "%)" ")" "%)" })

(define lisp-extensions
  "List of extensions Lisp files may end in."
  :hidden
  '(".lisp" ".cl" ".urn"))

(defun try-handle (name)
  "Attempt to open NAME with the various extensions."
  :hidden
  (loop [(i 1)] [(> i (n lisp-extensions))]
    (if-with (handle (io/open (.. name (nth lisp-extensions i)) "r"))
      (values-list handle (.. name (nth lisp-extensions i)))
      (recur (succ i)))))

(defun simplify-path (path paths)
  "Simplify PATH, attempting to reduce it to a named module inside PATHS."
  :hidden
  (with (current path)
    (for-each search paths
      (with (sub (string/match path (.. "^" (string/gsub search "." path-escape) "$")))
        (when (and sub (< (n sub) (n current)))
          (set! current sub))))
    current))

(defun strip-extension (path)
  "Strip file extensions from PATH."
  (loop [(i 1)]
    [(> i (n lisp-extensions)) path]
    (with (suffix (nth lisp-extensions i))
      (if (string/ends-with? path suffix)
        (string/sub path 1 (- -1 (n suffix)))
        (recur (succ i))))))

(defun read-meta (state name entry)
  "Parse a single ENTRY in the library metadata, loading the appropriate data into STATE."
  :hidden
  (when (and (or (= (type entry) "expr") (= (type entry) "stmt")) (string? (.> entry :contents)))
    (let* [(buffer '())
           (str     (.> entry :contents))
           (idx     0)
           (max     0)
           (len     (n str))]

      (while (<= idx len)
        (case (list (string/find str "%${(%d+)}" idx))
          [(?start ?finish . _)
           (when (> start idx)
             (push! buffer (string/sub str idx (pred start))))
           (with (val (string->number (string/sub str (+ start 2) (- finish 1))))
             (push! buffer val)
             (when (> val max) (set! max val)))
           (set! idx (succ finish))]
          [?x
           (push! buffer (string/sub str idx len))
           (set! idx  (succ len))]))

      (unless (.> entry :count) (.<! entry :count max))
      (.<! entry :contents buffer)))

  (when-with (fold (.> entry :fold))
    (when (/= (type entry) "expr") (fail! (.. "Cannot have fold for non-expression " name)))
    (when (and (/= fold "l") (/= fold "r")) (fail! (.. "Unknown fold " fold " for " name)))
    (when (/= (.> entry :count) 2) (fail! (.. "Cannot have fold for length " (.> entry :count) " for " name))))

  (.<! entry :name name)
  (let [(lib-value (.> state :lib-env name))
        (met-value (.> entry :value))]
    (cond
      [(and (/= lib-value nil) (/= met-value nil))
       (fail! (.. "Duplicate value for " name ": in native and meta file"))]
      [(/= lib-value nil)
       (.<! entry :has-value true)
       (.<! entry :value lib-value)]
      [(/= met-value nil)
       (.<! entry :has-value true)
       (.<! state :lib-env name met-value)]
      [else]))

  (.<! state :lib-meta name entry)
  entry)

(defun read-library (state name path lisp-handle)
  "Read a library from PATH, using an already existing LISP-HANDLE."
  :hidden
  (logger/put-verbose! (.> state :log) (.. "Loading " path " into " name))

  (let* [(unique-name (.. name "-" (n (.> state :libs))))
         (lib (library-of name unique-name path (.> state :root-scope)))
         (contents (self lisp-handle :read "*a"))]
    (self lisp-handle :close)

    ;; Attempt to load the native file
    (when-with (handle (io/open (.. path ".lib.lua") "r"))
      (with (contents (self handle :read "*a"))
        (self handle :close)
        (set-library-lua-contents! lib contents)

        (if-with ((fun err) (load contents (.. "@" name)))
          (case (list (xpcall fun traceback-plain))
            [(false ?msg)
             (logger/put-error! (.> state :log) (format nil "Cannot load {}.lib.lua ({:tostring})" path msg))]
            [(true (table? @ ?res) . _)
             (for-pairs (k v) res
               (if (string? k)
                 (.<! state :lib-env (.. unique-name "/" k) v)
                 (logger/put-warning! (.> state :log) (format nil "Non-string key '{:tostring}' when loading {}.lib.lua" k path))))]
            [_
             (logger/put-error! (.> state :log) (format nil "Received a non-table value from {}.lib.lua" path))])
          (logger/put-error! (.> state :log) (format nil "Cannot load {}.lib.lua ({})" path err)))))

    ;; Attempt to load the meta info
    (when-with (handle (io/open (.. path ".meta.lua") "r"))
      (with (contents (self handle :read "*a"))
        (self handle :close)

        (if-with ((fun err) (load contents (.. "@" name)))
          (case (list (xpcall fun traceback-plain))
            [(false ?msg)
             (logger/put-error! (.> state :log) (format nil "Cannot load {}.meta.lua ({:tostring})" path msg))]
            [(true (table? @ ?res) . _)
             (for-pairs (k v) res
               (if (string? k)
                 (read-meta state (.. unique-name "/" k) v)
                 (logger/put-warning! (.> state :log) (format nil "Non-string key '{:tostring}' when loading {}.meta.lua" k path))))]
            [_
             (logger/put-error! (.> state :log) (format nil "Received a non-table value from {}.meta.lua" path))])
          (logger/put-error! (.> state :log) (format nil "Cannot load {}.meta.lua ({})" path err)))))

    (timer/start-timer! (.> state :timer) (.. "[parse] " path) 2)

    ;; And parse all the things!
    (let* [((lexed range) (parser/lex (.> state :log) contents (.. path ".lisp")))
           (parsed (parser/parse (.> state :log) lexed))]

      (timer/stop-timer! (.> state :timer) (.. "[parse] " path))

      (with (compiled (compile
                        state
                        parsed
                        (library-scope lib)
                        path))

        (push! (.> state :libs) lib)

        ;; Extract documentation from the root node
        (when (string? (car compiled))
          (set-library-docs! lib (const-val (car compiled)))
          (remove-nth! compiled 1))

        ;; Append on to the complete output
        (set-library-lisp-lines! lib (range/range-lines range))
        (set-library-nodes! lib compiled)
        (for-each node compiled (push! (.> state :out) node))))

    (logger/put-verbose! (.> state :log) (.. "Loaded " path " into " name))
    lib))

(defun named-loader (state name)
  "Attempt to load NAME using the given compile STATE.

   This will search the compiler's load path for a module with the
   appropriate name."
  (with (cached (.> state :lib-names name))
    (cond
      [(= cached nil)
       (.<! state :lib-names name true)

       (let [(searched '())
             (paths (.> state :paths))]

         (loop [(i 1)]
           [(> i (n paths))
            (list nil (.. "Cannot find " (string/quoted name) ".\nLooked in " (concat searched ", ")))]

           ;; For every path, check if we've looked at this already and use it, otherwise
           ;; look it up on the filesystem and parse everything.
           (with (path (string/gsub (nth paths i) "%?" name))
             (case (path-loader state path)
               ;; If we've found the library then return
               [(?lib)
                (.<! state :lib-names name lib)
                (list lib)]
               ;; If we've got an error then propagate it
               [(false ?msg)
                (list false msg)]
               ;; Otherwise look at the next path
               [(nil _)
                (push! searched path)
                (recur (succ i))]))))]
      [(= cached true)
       (list false (.. "Already loading " (string/quoted name)))]
      [true (list cached)])))

(defun path-loader (state path)
  "Attempt to load PATH using the given compiler state.

   This will require an exact file name, optionally adding a file
   extension if needed."

  ;; First attempt to load from the main cache.
  (case (.> state :lib-cache path)
    [nil
     ;; The library doesn't exist, let's try to find it.
     (let* [(name (strip-extension path))
            (full-path path)
            (handle nil)]

       ;; If we've not got a file extension then try to find an appropriate handle
       (if (= name path)
         (when-with ((handle' path') (try-handle path))
           (set! handle handle')
           (set! full-path path'))
         (set! handle (io/open path "r")))

       (case (.> state :lib-cache full-path)
         [nil
          (if handle
            (progn
              ;; Ensure we don't get loops
              (.<! state :lib-cache path true)
              (.<! state :lib-cache full-path true)
              (with (lib (read-library state (simplify-path name (.> state :paths)) name handle))
                (.<! state :lib-cache path lib)
                (.<! state :lib-cache full-path lib)
                (list lib)))
            (list nil (.. "Cannot find " (string/quoted path))))]
         [true
          (when handle (self handle :close))
          (list false (.. "Already loading " (string/quoted full-path)))]
         [?cached
          (when handle (self handle :close))
          (list cached)]))]

    [true
     (list false (.. "Already loading " (string/quoted path)))]
    [?cached (list cached)]))
