(import urn/logger/format format)
(import urn/resolve/builtins (builtin builtin-var?))
(import urn/resolve/scope scope)

(define keywords
  "A set of all builtin Lua variables"
  :hidden
  (create-lookup '("and" "break" "do" "else" "elseif" "end" "false" "for" "function"
                   "if" "in" "local" "nil" "not" "or" "repeat" "return" "then" "true"
                   "until" "while")))

(defun lua-ident? (ident)
  "Determines if the given IDENT is a valid Lua identifier."
  (and (string/match ident "^[%a_][%w_]*$")
       (= (.> keywords ident) nil)))

(defun ident? (x)
  "Determine whether X is a usable identifier character"
  :hidden
  (string/find x "[%a%d']"))

(defun escape (name)
  "Escape an urn identifier NANE, converting it into a form that is valid Lua."
  (cond
    [(= name "") "_e"]
    ;; Keywords are trivial to escape
    [(.> keywords name) (.. "_e" name)]
    ;; Syntactically valid Lua variables. We exclude _ as they mess with "symbol" quoting.
    [(string/find name "^%a%w*$") name]
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
    (let* [(esc (escape (or (scope/var-display-name var) (scope/var-name var))))
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
    (unless esc (fail! (.. (scope/var-name var) " has not been escaped (when popping).")))
    (.<! state :var-cache esc nil)
    (.<! state :var-lookup var nil)))

(defun rename-escape-var! (from to state)
  "Pop the definition of FROM and use it to define TO."
  (with (esc (.> state :var-lookup from))
    (unless esc (fail! (.. (scope/var-name from) " has not been escaped (when renaming).")))
    (when (.> state :var-lookup to)
      (fail! (.. (scope/var-name to) " already has a name (when renaming).")))

    (.<! state :var-lookup from nil)
    (.<! state :var-lookup to esc)))

(defun escape-var (var state)
  "Escape a variable VAR, which has already been escaped."
  (if (builtin-var? var)
    (scope/var-name var)
    (with (esc (.> state :var-lookup var))
      (unless esc (format 1 "{:id} has not been escaped (at {:id})"
                            (scope/var-name var)
                            (if (scope/var-node var) (format/format-node (scope/var-node var)) "?")))
      esc)))
