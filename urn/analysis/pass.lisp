(import urn/logger logger)
(import urn/timer timer)

(define pass-arg :hidden (gensym))

(defmacro defpass (name args &body)
  "Define a pass with the given NAME and BODY taking the specified ARGS.

   BODY can contain key-value pairs (like [[struct]]) which will be set as
   options for this pass.

   Inside the BODY you can call [[changed!]] to mark this pass as
   modifying something. Passes should only be executed with
   [[run-pass]]."
  (let* [(main `(define ,name))
         (options '())
         (running true)
         (idx 1)
         (len (n body))]

    ;; If we start with a docstring then push it to both the definition
    ;; and struct
    (with (entry (car body))
      (when (string? entry)
        (push! main entry)
        (push! options `:help)
        (push! options entry)
        (inc! idx)))

    ;; Scan for all remaining entries
    (while (and running (<= idx len))
      (with (entry (nth body idx))
        (if (key? entry)
          (progn
            (push! options entry)
            (push! options (nth body (+ idx 1)))
            (set! idx (+ idx 2)))
          (set! running false))))

    (push! main `{ :name ,(symbol->string name)
                       ,@options
                       ,:run (lambda (,pass-arg ,@args) ,@(slice body idx))})

    main))

(defmacro changed! ((count 1))
  "Mark this pass as having a side effect."
  `(.<! ,pass-arg :changed (+ (.> ,pass-arg :changed) ,count)))

(defun create-tracker ()
  "Create a modification tracker."
  { :changed 0 })

(defun changed? (tracker)
  "Determine whether the TRACKER created by [[create-tracker]] was changed."
  (> (.> tracker :changed) 0))

(defun pass-enabled? (pass options)
  "Determine whether a PASS is enabled."
  (with (override (.> options :override))
    (cond
      ;; Check for being explicitly enabled/disabled
      [(= (.> override (.> pass :name)) true) true]
      [(= (.> override (.> pass :name)) false) false]
      ;; Check for category being explicitly enabled/disabled
      [(any (lambda (cat) (= (.> override cat) true)) (.> pass :cat)) true]
      [(any (lambda (cat) (= (.> override cat) false)) (.> pass :cat)) false]
      ;; Otherwise ensure that the pass is on and it has a sufficient level
      [true (and (/= (.> pass :on) false) (>= (.> options :level) (or (.> pass :level) 1)))])))

(defun filter-passes (passes options)
  "Filter a table of PASSES, using the given OPTIONS."
  (with (res {})
    (for-pairs (k v) passes
      (.<! res k (filter (cut pass-enabled? <> options) v)))
    res))

(defun has-category? (pass cat)
  "Determine whether a PASS has a particular category."
  (any (cut = <> cat) (.> pass :cat)))

(defun run-pass (pass options tracker &args)
  "Run a PASS with the given ARGS, using OPTIONS to determine how the task should be run.

   This will return whether the PASS did something, though you can also specify TRACKER for
   more convenient tracking of multiple passes."
  (let [(ptracker (create-tracker))
        (name (.. "[" (concat (.> pass :cat) " ") "] " (.> pass :name)))]

    (timer/start-timer! (.> options :timer) name 2)
    ((.> pass :run) ptracker options (splice args))
    (timer/stop-timer! (.> options :timer) name)

    ;; Print out logging modification information
    (when (.> options :track) (logger/put-verbose! (.> options :logger) (sprintf "%s made %d changes" name (.> ptracker :changed))))
    (when tracker (.<! tracker :changed (+ (.> tracker :changed) (.> ptracker :changed))))

    (changed? ptracker)))
