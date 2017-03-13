(import lua/basic (slice))
(import lua/os os)

(import urn/logger logger)

(define pass-arg :hidden (gensym))

(defmacro defpass (name args &body)
  "Define a pass with the given NAME and BODY taking the specified ARGS.

   BODY can contain key-value pairs (like [[struct]]) which will be set as
   options for this pass.

   Inside the BODY you can call [[changed!] to mark this pass as modifying
   something. Passes should only be executed with [[run-pass]]."
  (let* [(main `(define ,name))
         (options '())
         (running true)
         (idx 1)
         (len (# body))]

    ;; If we start with a docstring then push it to both the definition
    ;; and struct
    (with (entry (car body))
      (when (string? entry)
        (push-cdr! main entry)
        (push-cdr! options `:help)
        (push-cdr! options entry)
        (inc! idx)))

    ;; Scan for all remaining entries
    (while (and running (<= idx len))
      (with (entry (nth body idx))
        (if (key? entry)
          (progn
            (push-cdr! options entry)
            (push-cdr! options (nth body (+ idx 1)))
            (set! idx (+ idx 2)))
          (set! running false))))

    (push-cdr! main `(struct
                       :name ,(symbol->string name)
                       ,@options
                       ,:run (lambda (,pass-arg ,@args) ,@(slice body idx))))

    main))

(defmacro changed! ()
  "Mark this pass as having a side effect."
  `(.<! ,pass-arg :changed true))

(defun create-tracker ()
  "Create a modification tracker."
  (struct :changed false))

(defun changed? (tracker)
  "Determine whether the TRACKER created by [[create-tracker]] was changed."
  (.> tracker :changed))

(import base (type#))
(defun pass-enabled? (pass options)
  "Determine whether a PASS is enabled."
  (with (override (.> options :override))
    (and
      (>= (.> options :level) (or (.> pass :level) 1))
      (if (= (.> pass :on) false)
        (= (.> override (.> pass :name)) true)
        (/= (.> override (.> pass :name)) false))
      (all (lambda (cat) (/= false (.> override cat))) (.> pass :cat)))))

(defun run-pass (pass options tracker &args)
  "Run a PASS with the given ARGS, using OPTIONS to determine how the task should be run.

   This will return whether the PASS did something, though you can also specify TRACKER for
   more convenient tracking of multiple passes."
  (when (pass-enabled? pass options)
    (let [(start (os/clock))
          (ptracker (create-tracker))
          (name (.. "[" (concat (.> pass :cat) " ") "] " (.> pass :name)))]

      ((.> pass :run) ptracker options (unpack args 1 (# args)))

      ;; Print out the timings if required
      (when (.> options :time)
        (logger/put-verbose! (.> options :logger) (.. name " took " (- (os/clock) start) ".")))

      ;; Print out logging modification information
      (when (changed? ptracker)
        (when (.> options :track) (logger/put-verbose! (.> options :logger) (.. name " did something.")))
        (when tracker (.<! tracker :changed true)))

      (changed? ptracker))))
