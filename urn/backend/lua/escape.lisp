(import urn/analysis/nodes (builtins builtin-vars))

(define keywords
  "A set of all builtin Lua variables"
  :hidden
  (create-lookup '("and" "break" "do" "else" "elseif" "end" "false" "for" "function"
                   "if" "in" "local" "nil" "not" "or" "repeat" "return" "then" "true"
                   "until" "while")))

(define symbols
  "A mapping of various symbols to an their escaped form."
  :hidden
  { "!" "bang"
    "+" "add"
    "-" "sub"
    "*" "mul"
    "/" "div"
    "%" "mod"
    "^" "pow"
    "=" "eq"
    ">" "gt"
    "<" "lt"
    "." "dot"
    "#" "hash"
    "?" "ask" })

(defun ident? (x)
  "Determine whether X is a usable identifier character"
  :hidden
  (string/find x "[%a%d']"))

(defun escape (name)
  "Escape an urn identifier NANE, converting it into a form that is valid Lua."
  (cond
    [(= name "") "_e"]
    [(.> keywords name) (.. "_e" name)] ;; Keywords are trivial to escape
    [(string/find name "^%w[_%w%d]*$") name] ;; Explicitly forbit leading _ as used for compiler internals
    [true (let* [(out (if (-> name (string/char-at <> 1) (string/find <> "%d")) "_e" ""))
                 (upper false)
                 (esc false)]
            (for i 1 (n name) 1
              (with (char (string/char-at name i))
                (cond
                  [(and (= char "-")
                        (ident? (string/char-at name (pred i)))
                        (ident? (string/char-at name (succ i))))
                   ;; If we're surrounded by ident characters then convert the next one to upper case
                   (set! upper true)]
                  [(string/find char "[^%w%d]")
                   (set! char (-> char (string/byte <>) (string/format "%02x" <>)))
                   (set! upper false)
                   (unless esc
                     (set! esc true)
                     (set! out (.. out "_")))
                   (set! out (.. out char))]
                  [true
                    (when esc
                      (set! esc false)
                      (set! out (.. out "_")))
                    (when upper
                      (set! upper false)
                      (set! char (string/upper char)))
                    (set! out (.. out char))])))
            (when esc (set! out (.. out "_")))
            out)]))

(defun push-escape-var! (var state force-num)
  "Push an escaped form of variable VAR. This should be called when it is defined.

   If FORCE-NUM is given then the variable will always be mangled with a number."
  (or (.> state :var-lookup var)
    (let* [(esc (escape (.> var :name)))
           (existing (.> state :var-cache esc))]
      (when (or force-num existing)
        (let* [(ctr 1)
               (finding true)]
          (while finding
            (let* [(esc' (.. esc ctr))
                   (existing (.> state :var-cache esc'))]
              (if existing
                (inc! ctr)
                (progn
                  (set! finding false)
                  (set! esc esc')))))))

      (.<! state :var-cache esc true)
      (.<! state :var-lookup var esc)
      esc)))

(defun pop-escape-var! (var state)
  "Remove an escaped form of variable VAR."
  (with (esc (.> state :var-lookup var))
    (unless esc (fail! (.. (.> var :name) " has not been escaped (when popping).")))
    (.<! state :var-cache esc nil)
    (.<! state :var-lookup var nil)))

(defun escape-var (var state)
  "Escape a variable VAR, which has already been escaped."
  (if (.> builtin-vars var)
    (.> var :name)
    (with (esc (.> state :var-lookup var))
      (unless esc (fail! (.. (.> var :name) " has not been escaped.")))
      esc)))

(defun temp-escape-var (state)
  "Create a temporary escaped variable."
  (let* [(var { :name "temp" })
         (esc (push-escape-var! var state))]
    (pop-escape-var! var state)
    esc))
