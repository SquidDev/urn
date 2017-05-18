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
  (or (string/find x "[%a%d']") (.> symbols x)))

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
                  [(.> symbols char)
                   (set! char (.> symbols char))
                   (when (or upper (ident? (string/char-at name (pred i))))
                     (set! char (string/gsub char "^%a" string/upper)))
                   (set! upper true)
                   (set! out (.. out char))]
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

(defun escape-var (var state)
  "Escape an urn variable, uniquely numbering different variables with the same name."
  (cond
    [(.> builtin-vars var) (.> var :name)]
    [true
      (let* [(v (escape (.> var :name)))
             (id (.> state :var-lookup var))]
        (unless id
          (set! id (succ (or (.> state :ctr-lookup v) 0)))
          (.<! state :ctr-lookup v id)
          (.<! state :var-lookup var id))
        (.. v (number->string id)))]))
