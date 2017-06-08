(import lua/io io)
(import lua/basic (load))

(import urn/backend/lua lua)
(import urn/logger logger)
(import urn/parser parser)
(import urn/resolve/loop (compile))
(import urn/resolve/scope scope)
(import urn/timer timer)

(defun simplify-path (path paths)
  "Simplify PATH, attempting to reduce it to a named module inside PATHS."
  :hidden
  (with (current path)
    (for-each search paths
      (with (sub (string/match path (.. "^" (string/gsub search "%?" "(.*)") "$")))
        (when (and sub (< (n sub) (n current)))
          (set! current sub))))
    current))

(defun read-meta (state name entry)
  "Parse a single ENTRY in the library metadata, loading the appropriate data into STATE."
  :hidden
  (when (and (or (= (.> entry :tag) "expr") (= (.> entry :tag) "stmt")) (string? (.> entry :contents)))
    (let* [(buffer '())
           (str     (.> entry :contents))
           (idx     0)
           (max     0)
           (len     (n str))]

      (while (<= idx len)
        (case (list (string/find str "%${(%d+)}" idx))
          [(?start ?finish . _)
           (when (> start idx)
             (push-cdr! buffer (string/sub str idx (pred start))))
           (with (val (string->number (string/sub str (+ start 2) (- finish 1))))
             (push-cdr! buffer val)
             (when (> val max) (set! max val)))
           (set! idx (succ finish))]
          [?x
           (push-cdr! buffer (string/sub str idx len))
           (set! idx  (succ len))]))

      (unless (.> entry :count) (.<! entry :count max))
      (.<! entry :contents buffer)))

  (when-with (fold (.> entry :fold))
    (when (/= (.> entry :tag) "expr") (fail! (.. "Cannot have fold for non-expression " name)))
    (when (and (/= fold "l") (/= fold "r")) (fail! (.. "Unknown fold " fold " for " name)))
    (when (/= (.> entry :count) 2) (fail! (.. "Cannot have fold for length " (.> entry :count) " for " name))))

  (.<! entry :name name)
  (cond
    [(= (.> entry :value) nil)
     (with (value (.> state :libEnv name))
       (when (= value nil)
         (case (list (pcall lua/native entry (.> state :global)))
           [(true . ?res) (set! value (car res))]
           [(false _)])
         (.<! state :libEnv name value))
       (.<! entry :value value))]
    [(/= (.> state :libEnv name) nil) (fail! (.. "Duplicate value for " name ": in native and meta file"))]
    [true (.<! state :libEnv name (.> entry :value))])

  (.<! state :libMeta name entry)
  entry)

(defun read-library (state name path lisp-handle)
  "Read a library from PATH, using an already existing LISP-HANDLE."
  :hidden
  (logger/put-verbose! (.> state :log) (.. "Loading " path " into " name))

  (let* [(prefix (.. name "-" (n (.> state :libs)) "/"))
         (lib { :name   name
                :prefix prefix
                :path   path })
         (contents (self lisp-handle :read "*a"))]
    (self lisp-handle :close)

    ;; Attempt to load the native file
    (when-with (handle (io/open (.. path ".lua") "r"))
      (with (contents (self handle :read "*a"))
        (self handle :close)
        (.<! lib :native contents)

        (case (list (load contents (.. "@" name)))
          [(nil ?msg) (fail! msg)]
          [(?fun)
           (with (res (fun))
             (if (table? res)
               (for-pairs (k v) res (.<! state :libEnv (.. prefix k) v))
               (fail! (.. path ".lua returned a non-table value"))))])))

    ;; Attempt to load the meta info
    (when-with (handle (io/open (.. path ".meta.lua") "r"))
      (with (contents (self handle :read "*a"))
        (self handle :close)
        (case (list (load contents (.. "@" name)))
          [(nil ?msg) (fail! msg)]
          [(?fun)
           (with (res (fun))
             (if (table? res)
               (for-pairs (k v) res (read-meta state (.. prefix k) v))
               (fail! (.. path ".meta.lua returned a non-table value"))))])))

    (timer/start-timer! (.> state :timer) (.. "[parse] " path) 2)

    ;; And parse all the things!
    (let* [(lexed (parser/lex (.> state :log) contents (.. path ".lisp")))
           (parsed (parser/parse (.> state :log) lexed))
           (scope (scope/child (.> state :rootScope)))]
      (.<! scope :isRoot true)
      (.<! scope :prefix prefix)
      (.<! lib :scope scope)

      (timer/stop-timer! (.> state :timer) (.. "[parse] " path))

      (with (compiled (compile
                        state
                        parsed
                        scope
                        path))

        (push-cdr! (.> state :libs) lib)

        ;; Extract documentation from the root node
        (when (string? (car compiled))
          (.<! lib :docs (const-val (car compiled)))
          (remove-nth! compiled 1))

        ;; Append on to the complete output
        (.<! lib :out compiled)
        (for-each node compiled (push-cdr! (.> state :out) node))))

    (logger/put-verbose! (.> state :log) (.. "Loaded " path " into " name))
    lib))

(defun path-locator (state name)
  "Searches through the the paths in the compiler STATE, trying to locate a package with NAME.

   If found then it will return the library data, otherwise `nil` and the list of paths searched."
  :hidden
  (letrec [(searched '())
           (paths (.> state :paths))
           (searcher (lambda (i)
                       (if (> i (n paths))
                         (list nil (.. "Cannot find " (string/quoted name) ".\nLooked in " (concat searched ", ")))
                         ;; For every path, check if we've looked at this already and use it, otherwise
                         ;; look it up on the filesystem and parse everything.
                         (let* [(path (string/gsub (nth paths i) "%?" name))
                                (cached (.> state :libCache path))]
                           (push-cdr! searched path)
                           (cond
                             [(= cached nil)
                              (with (handle (io/open (.. path ".lisp") "r"))
                                (if handle
                                  (progn
                                    ;; We set this to true to ensure we don't get loops
                                    (.<! state :libCache path true)
                                    (.<! state :libNames name true)
                                    ;; And then we actually load everything
                                    (with (lib (read-library state (simplify-path path paths) path handle))
                                      (.<! state :libCache path lib)
                                      (.<! state :libNames name lib)
                                      (list lib)))
                                  (searcher (+ i 1))))]
                             [(= cached true) (list nil (.. "Already loading " name))]
                             [true (list cached)])))))]
    (searcher 1)))


(defun loader (state name should-resolve)
  "Attempt to load NAME using the given compile STATE.

   If SHOULD-RESOLVE is true then we will search the compile path."
  (if should-resolve
    (with (cached (.> state :libNames name))
      (cond
        [(= cached nil) (path-locator state name)]
        [(= cached true) (list nil (.. "Already loading " name))]
        [true (list cached)]))
    (progn
      (set! name (string/gsub name "%.lisp$" ""))
      (case (.> state :libCache name)
        [nil
         (with (handle (io/open (.. name ".lisp")))
           (if handle
             (progn
               ;; Ensure we don't get loops
               (.<! state :libCache name true)
               (with (lib (read-library state (simplify-path name (.> state :paths)) name handle))
                 (.<! state :libCache name lib)
                 (list lib)))
             (list nil (.. "Cannot find " (string/quoted name)))))]
        [true (list nil (.. "Already loading " name))]
        [?cached (list cached)]))))
