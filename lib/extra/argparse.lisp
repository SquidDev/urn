"An argument parsing library.

 You specify the arguments for this parser, and the arg parser will
 handle parsing and documentation generation.

 The parser is created with [[create]] and arguments can be added with
 [[add-argument!]]. Should you want the parser to handle `--help` and
 friends, you should call [[add-help!]]. Once the parser is 'built', you
 can parse inputs with [[parse!]]

 ### Example
 ```cl
 (with (spec (create))
   (add-help! spec)
   (add-argument! spec '(\"files\")
     :help \"The input files\")

   (add-argument! spec '(\"--output\" \"-o\")
     :help \"Specify the output file\"
     :default \"out.lua\"
     :nargs 1)

   (parse! spec))
 ```"

(import string)
(import lua/math math)

(defun create (description)
  "Create a new argument parser"
  { :desc      description
    :flag-map  {}
    :opt-map   {}
    :opt       '()
    :pos       '() })

(defun set-action (arg data value)
  "Set the appropriate key in DATA for ARG to VALUE."
  (.<! data (.> arg :name) value))

(defun add-action (arg data value)
  "Append VALUE to the appropriate key in DATA for ARG."
  (with (lst (.> data (.> arg :name)))
    (unless lst
      (set! lst '())
      (.<! data (.> arg :name) lst))

    (push-cdr! lst value)))

(defun set-num-action (aspec data value usage!)
  "Set the appropriate key in DATA for ARG to VALUE, ensuring it is a number."
  (with (val (string->number value))
    (if val
      (.<! data (.> aspec :name) val)
      (usage! (.. "Expected number for " (car (.> arg :names)) ", got " value)))))

(defun add-argument! (spec names &options)
  "Add a new argument to SPEC, using the specified NAMES.

   OPTIONS is composed of a key followed by the corresponding value. The
   following options are valid:

    - `:name`: The name to store the result in. Defaults to the first
      item given in NAMES.

    - `:narg`: The number of arguments to consume. This can be any
      number, '+', '*' or '?'. Defaults to 0 if the first `:name` starts
      with `-`, otherwise `*`.
    - `:default`: The default value to use. Defaults to `false`.
    - `:value`: The value to use if this is used without an
      argument (such as a flag). Defaults to `true`.
    - `:help`: The description text to display when using this.
    - `:var`: The variable name to show in help files. Defaults to
      `:name`.
    - `:action`: The action to execute when this option is used. Must be
      a function which takes three arguments: current arg, data and
      value.
    - `:many`: Whether you can specify this argument multiple times.
    - `:all`: Whether this will consume all values, including those
      starting with `-`."
  (assert-type! names list)
  (when (nil? names) (error! "Names list is empty"))
  (unless (= (% (# options) 2) 0) (error! "Options list should be a multiple of two"))

  (with (result { :names   names
                  :action  nil
                  :narg    0
                  :default false
                  :help    ""
                  :value   true })

    ;; Gather the name, var and narg from the first arg.
    (with (first (car names))
      (cond
        [(= (string/sub first 1 2) "--")
         (push-cdr! (.> spec :opt) result)
         (.<! result :name (string/sub first 3))]
        [(= (string/sub first 1 1) "-")
         (push-cdr! (.> spec :opt) result)
         (.<! result :name (string/sub first 2))]
        [true
         (.<! result :name first)
         (.<! result :narg "*")
         (.<! result :default '())
         (push-cdr! (.> spec :pos) result)]))

    ;; Add them to the appropriate maps
    (for-each name names
       (cond
        [(= (string/sub name 1 2) "--")
         (.<! spec :opt-map (string/sub name 3) result)]
        [(= (string/sub name 1 1) "-")
         (.<! spec :flag-map (string/sub name 2) result)]
        [true]))

    ;; Read the options
    (for i 1 (# options) 2
      (let* [(key (nth options i))
             (val (nth options (+ i 1)))]
        (.<! result key val)))

    ;; Set the metavar for variable argument things.
    (unless (.> result :var)
      (.<! result :var (string/upper (.> result :name))))

    ;; Set the action for variable argument things.
    (unless (.> result :action)
      (.<! result :action (if (if (number? (.> result :narg)) (<= (.> result :narg) 1) (= (.> result :narg) "?"))
                            set-action
                            add-action)))

    result))

(defun add-help! (spec)
  "Add a help argument to SPEC.

   This will show the help message whenever --help or -h is used and
   then quit the program."
  (add-argument! spec '("--help" "-h")
    :help    "Show this help message"
    :default nil
    :value   nil
    :action  (lambda (arg result value)
               (help! spec)
               (exit! 0))))

(defun help-narg! (buffer arg)
  "Append the narg doc of ARG to the BUFFER."
  :hidden
  (case (.> arg :narg)
    ["?" (push-cdr! buffer (.. " [" (.> arg :var) "]"))]
    ["*" (push-cdr! buffer (.. " [" (.> arg :var) "...]"))]
    ["+" (push-cdr! buffer (.. " " (.> arg :var) " [" (.> arg :var) "...]"))]
    [?num (for _ 1 num 1 (push-cdr! buffer (.. " " (.> arg :var))))]))

(defun usage! (spec name)
  "Display a short usage for the argument parser as defined in SPEC."
  (unless name (set! name (or (nth arg 0) (nth arg -1) "?")))

  (with (usage (list "usage: " name))
    (for-each arg (.> spec :opt)
      (push-cdr! usage (.. " [" (car (.> arg :names))))
      (help-narg! usage arg)
      (push-cdr! usage "]"))

    (for-each arg (.> spec :pos) (help-narg! usage arg))

    (print! (concat usage))))

(defun usage-error! (spec name error)
  "Display the usage of SPEC and exit with an ERROR message."
  (usage! spec name)
  (print! error)
  (exit! 1))

(defun help! (spec name)
  "Display the help for the argument parser as defined in SPEC."
  (unless name (set! name (or (nth arg 0) (nth arg -1) "?")))
  (usage! spec name)

  (when (.> spec :desc)
    (print!)
    (print! (.> spec :desc)))

  (with (max 0)
    (for-each arg (.> spec :pos)
      (with (len (#s (.> arg :var)))
        (when (> len max) (set! max len))))
    (for-each arg (.> spec :opt)
      (with (len (#s (concat (.> arg :names) ", ")))
        (when (> len max) (set! max len))))

    (with (fmt (.. " %-" (number->string (+ max 1)) "s %s"))
      (unless (nil? (.> spec :pos))
        (print!)
        (print! "Positional arguments")
        (for-each arg (.> spec :pos)
          (print! (string/format fmt (.> arg :var) (.> arg :help)))))

      (unless (nil? (.> spec :opt))
        (print!)
        (print! "Optional arguments")
        (for-each arg (.> spec :opt)
          (print! (string/format fmt (concat (.> arg :names) ", ") (.> arg :help))))))))

(defun matcher (pattern)
  "A utility function which creates a lambda to check if PATTERN matches
   the given argument."
  :hidden
  (lambda (x)
    (with (res (list (string/match x pattern)))
      (if (= (car res) nil) nil res))))

(defun parse! (spec args)
  "Parse ARGS using the argument parser defined in SPEC. Returns a
   lookup with each argument given its value."
  (unless args (set! args arg))

  (let* [(result {})
         (pos (.> spec :pos))
         (idx 1)
         (len (# args))
         (usage! (lambda (msg) (usage-error! spec (nth args 0) msg)))
         (action (lambda (arg value) ((.> arg :action) arg result value usage!)))
         (read-args (lambda (key arg)
                      (case (.> arg :narg)
                        ["+"
                         ;; Ensure we consume at least one
                         (inc! idx)
                         (with (elem (nth args idx))
                           (cond
                             [(= elem nil) (usage! (.. "Expected " (.> arg :var) " after --" key ", got nothing"))]
                             [(and (! (.> arg :all)) (string/find elem "^%-")) (usage! (.. "Expected " (.> arg :var) " after --" key ", got " (nth args idx)))]
                             [true (action arg elem)]))
                         ;; Try to consume as many additonal tokens as possible
                         (with (running true)
                           (while running
                             (inc! idx)
                             (with (elem (nth args idx))
                               (cond
                                 [(= elem nil) (set! running false)]
                                 [(and (! (.> arg :all)) (string/find elem "^%-")) (set! running false)]
                                 [true (action arg elem)]))))]
                        ["*"
                         ;; Try to consume as many as possible
                         (with (running true)
                           (while running
                             (inc! idx)
                             (with (elem (nth args idx))
                               (cond
                                 [(= elem nil) (set! running false)]
                                 [(and (! (.> arg :all)) (string/find elem "^%-")) (set! running false)]
                                 [true (action arg elem)]))))]
                        ["?"
                         (inc! idx)
                         (with (elem (nth args idx))
                           (if (or (= elem nil) (and (! (.> arg :all)) (string/find elem "^%-")))
                             ((.> arg :action) arg result (.> arg :value))
                             (progn
                               (inc! idx)
                               (action arg elem))))]
                        [0
                          (inc! idx)
                          (action arg (.> arg :value))]
                        [?cnt
                         (for i 1 cnt 1
                           (inc! idx)
                           (with (elem (nth args idx))
                             (cond
                               [(= elem nil) (usage! (.. "Expected " cnt " args for " key ", got " (pred i)))]
                               [(and (! (.> arg :all)) (string/find elem "^%-")) (usage! (.. "Expected " cnt " for " key ", got " (pred i)))]
                               [true (action arg elem)])))
                         (inc! idx)])))]
    (while (<= idx len)
      (case (nth args idx)
        [(-> (matcher "^%-%-([^=]+)=(.+)$") (?key ?val))
         (with (arg (.> spec :opt-map key))
           (cond
             [(= arg nil)
              (usage! (.. "Unknown argument " key  " in " (nth args idx)))]
             [(and (! (.> arg :many)) (/= nil (.> result (.> arg :name))))
              ;; If we've already got a value and this doesn't accept many then fail.
              (usage! (.. "Too may values for " key " in " (nth args idx)))]
             [true
              (with (narg (.> arg :narg))
                (when (and (number? narg) (/= narg 1))
                  (usage! (.. "Expected " (number->string narg) " values, got 1 in " (nth args idx)))))

              ;; Call the setter for this argument.
              (action arg val)]))
         ;; And move onto the next token.
         (inc! idx)]
        [(-> (matcher "^%-%-(.*)$") (?key))
         (with (arg (.> spec :opt-map key))
           (cond
             [(= arg nil)
              (usage! (.. "Unknown argument " key  " in " (nth args idx)))]
             [(and (! (.> arg :many)) (/= nil (.> result (.> arg :name))))
              ;; If we've already got a value and this doesn't accept many then fail.
              (usage! (.. "Too may values for " key " in " (nth args idx)))]

             ;; Attempt to consume the correct number of arguments after this one.
             [true (read-args key arg)]))]
        [(-> (matcher "^%-(.+)$") (?flags))
         (let* [(i 1)
                (s (#s flags))]
           (while (<= i s)
             (let* [(key (string/char-at flags i))
                    (arg (.> spec :flag-map key))]
               (cond
                 [(= arg nil)
                  (usage! (.. "Unknown flag " key " in " (nth args idx)))]
                 [(and (! (.> arg :many)) (/= nil (.> result (.> arg :name))))
                  ;; If we've already got a value and this doesn't accept many then fail.
                  (usage! (.. "Too many occurances of " key " in " (nth args idx)))]
                 [true
                   (with (narg (.> arg :narg))
                     (cond
                       [(= i s) (read-args key arg)]
                       [(= narg 0) (action arg (.> arg :value))]
                       [true
                        ;; Read the rest of this flag as an argument (for instance -W0).
                        (action arg (string/sub flags (succ i)))
                        (set! i (succ s))
                        (inc! idx)]))]))
             (inc! i)))]
        [?any
         (with (arg (car (.> spec :pos)))
           (if arg
             (action arg any)
             (usage! (.. "Unknown argument " arg))))
         (inc! idx)]))

    ;; Copy across the defaults
    (for-each arg (.> spec :opt)
      (when (= (.> result (.> arg :name)) nil) (.<! result (.> arg :name) (.> arg :default))))
    (for-each arg (.> spec :pos)
      (when (= (.> result (.> arg :name)) nil) (.<! result (.> arg :name) (.> arg :default))))

    result))
