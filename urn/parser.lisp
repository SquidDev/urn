(import urn/logger/init logger)
(import urn/logger/void void)
(import urn/range ())

(import string)

(defun hex-digit? (char)
  "Determines whether CHAR is a hecharadecimal digit"
  :hidden
  (or (between? char "0" "9") (between? char "a" "f") (between? char "A" "F")))

(defun bin-digit? (char)
  "Determines whether char is a binary digit"
  :hidden
  (or (= char "0") (= char "1")))

(defun terminator? (char)
  "Determines whether CHAR is a terminator of a block"
  :hidden
  (or (= char "\n") (= char " ") (= char "\t") (= char "(") (= char ")") (= char "[") (= char "]") (= char "{") (= char "}") (= char "")))

(defun digit-error! (logger pos name char)
  "Generate an error at POS where a NAME digit was expected and CHAR received instead"
  :hidden
  (logger/do-node-error! logger
    (string/format "Expected %s digit, got %s" name (if (= char "")
                                                      "eof"
                                                      (string/quoted char)))
    pos nil
    pos "Invalid digit here"))

(defun lex (logger str name)
  "Lex STR from a file called NAME, returning a series of tokens"
  (let* ((lines (string/split str "\n"))
         (line 1)
         (column 1)
         (offset 1)
         (length (string/#s str))
         (out '())
         ;; Consumes a single symbol and increments the position
         (consume! (lambda ()
                     (if (= (string/char-at str offset) "\n")
                       (progn
                         (inc! line)
                         (set! column 1))
                       (inc! column))
                     (inc! offset)))
          ;; Generates a table with the current position
         (position (lambda () (struct :line line :column column :offset offset)))
         ;; Generates a table with a particular range
         (range (lambda (start finish) (struct :start start :finish (or finish start) :lines lines :name name)))
         ;; Appends a struct to the list
         (append-with! (lambda (data start finish)
                         (let ((start (or start (position)))
                                (finish (or finish (position))))
                           (.<! data :range (range start finish))
                           (.<! data :contents (string/sub str (.> start :offset) (.> finish :offset)))
                           (push-cdr! out data))))
         ;; Appends a token to the list
         (append! (lambda (tag start finish)
                    (append-with! (struct :tag tag) start finish)))
         (parse-base (lambda (name p base)
                       (let* [(start offset)
                              (char (string/char-at str offset))]
                         ;; Require at least one character
                         (unless (p char) (digit-error! logger (range (position)) name char))

                         ;; Consume all remaining characters matching this
                         (set! char (string/char-at str (succ offset)))
                         (while (p char)
                           (consume!)
                           (set! char (string/char-at str (succ offset))))

                         ;; And conver the digit to a string
                         (string->number (string/sub str start offset) base)))))
    ;; Scan the input stream, consume one character, then reading til the end of that token.
    (while (<= offset length)
      (with (char (string/char-at str offset))
        (cond
          ((or (= char "\n") (= char "\t") (= char " ")))
          ((= char "(") (append-with! (struct :tag "open" :close ")")))
          ((= char ")") (append-with! (struct :tag "close" :open "(")))
          ((= char "[") (append-with! (struct :tag "open" :close "]")))
          ((= char "]") (append-with! (struct :tag "close" :open "[")))
          ((= char "{") (append-with! (struct :tag "open" :close "}")))
          ((= char "}") (append-with! (struct :tag "close" :open "{")))
          ((= char "'") (append! "quote"))
          ((= char "`") (append! "syntax-quote"))
          ((= char "~") (append! "quasiquote"))
          ((= char ",") (if (= (string/char-at str (succ offset)) "@")
            (with (start (position))
              (consume!)
              (append! "unquote-splice" start))
            (append! "unquote")))
          ((string/find str "^%-?%.?[0-9]" offset)
            (let [(start (position))
                  (negative (= char "-"))]
              ;; Check whether this number is negative
              (when negative
                (consume!)
                (set! char (string/char-at str offset)))

              (with (val (cond
                           ;; Parse hexadecimal digits
                           ((and (= char "0") (= (string/char-at str (succ offset)) "x"))
                             (consume!)
                             (consume!)
                             (with (res (parse-base "hexadecimal" hex-digit? 16))
                               (when negative (set! res (- 0 res)))
                               res))
                           ;; Parse binary digits
                           ((and (= char "0") (= (string/char-at str (succ offset)) "b"))
                             (consume!)
                             (consume!)
                             (with (res (parse-base "binary" bin-digit? 2))
                               (when negative (set! res (- 0 res)))
                               res))
                           (true
                             ;; Parse leading digits
                             (while (between? (string/char-at str (succ offset))  "0" "9")
                               (consume!))

                             ;; Consume decimal places
                             (when (= (string/char-at str (succ offset)) ".")
                               (consume!)
                               (while (between? (string/char-at str (succ offset))  "0" "9")
                                 (consume!)))

                             ;; Consume exponent
                             (set! char (string/char-at str (succ offset)))
                             (when (or (= char "e") (= char "E"))
                               (consume!)
                               (set! char (string/char-at str (succ offset)))

                               ;; Gobble positive/negative bit
                               (when (or (= char "-") (= char "+")) (consume!))

                               ;; And exponent digits
                               (while (between? (string/char-at str (succ offset)) "0" "9")
                                 (consume!)))

                             (string->number (string/sub str (.> start :offset) offset)))))
                (append-with! (struct :tag "number" :value val) start)

                ;; Ensure the next character is a terminator of some sort, otherwise we'd allow things like 0x2-2
                (set! char (string/char-at str (succ offset)))
                (unless (terminator? char)
                  (consume!)

                  (logger/do-node-error! logger
                    (string/format "Expected digit, got %s" (if (= char "")
                                                              "eof"
                                                              char))
                    (range (position)) nil
                    (range (position)) "Illegal character here. Are you missing whitespace?")))))
          ((= char "\"")
            (let* [(start (position))
                   (start-col (succ column))
                   (buffer '())]
              (consume!)
              (set! char (string/char-at str offset))
              (while (/= char "\"")
                (when (= column 1)
                  (let* [(running true)
                         (line-off offset)]
                    (while (and running (< column start-col))
                      (cond
                        [(= char " ")
                         ;; Got a space, gobble a character and continue.
                         (consume!)]
                        [(= char "\n")
                         ;; Got a new line, we'll append it to the buffer and reset the start position.
                         (consume!)
                         (push-cdr! buffer "\n")
                         (set! line-off offset)]
                        [(= char "")
                         ;; Got an EOF, we'll handle this in the next block so just exit.
                         (set! running false)]
                        [true
                          (logger/put-node-warning! logger (string/format "Expected leading indent, got %q" char)
                            (range (position))
                            "You should try to align multi-line strings at the initial quote
                             mark. This helps keep programs neat and tidy."
                            (range start)      "String started with indent here"
                            (range (position)) "Mis-aligned character here")

                          ;; Append all the spaces.
                          (push-cdr! buffer (string/sub str line-off (pred offset)))
                          (set! running false)])
                      (set! char (string/char-at str offset)))))
                (cond
                  [(= char "")
                   (let ((start (range start))
                         (finish (range (position))))
                     (logger/do-node-error! logger
                       "Expected '\"', got eof"
                       finish nil
                       start "string started here"
                       finish "end of file here"))]
                  [(= char "\\")
                   (consume!)
                   (set! char (string/char-at str offset))
                   (cond
                     ;; Skip new lines
                     [(= char "\n")]
                     ;; Various escape codes
                     [(= char "a") (push-cdr! buffer "\a")]
                     [(= char "b") (push-cdr! buffer "\b")]
                     [(= char "f") (push-cdr! buffer "\f")]
                     [(= char "n") (push-cdr! buffer "\n")]
                     [(= char "t") (push-cdr! buffer "\t")]
                     [(= char "v") (push-cdr! buffer "\v")]
                     ;; Escaped characters
                     [(= char "\"") (push-cdr! buffer "\"")]
                     [(= char "\\") (push-cdr! buffer "\\")]
                     ;; And character codes
                     [(or (= char "x") (= char "X") (between? char "0" "9"))
                      (let [(start (position))
                            (val (if (or (= char "x") (= char "X"))
                                   ;; Gobble hexadecimal codes
                                   (progn
                                     (consume!)

                                     (with (start offset)
                                       ;; Obviously we require the first character to be hex
                                       (unless (hex-digit? (string/char-at str offset))
                                         (digit-error! logger (range (position)) "hexadecimal" (string/char-at str offset)))

                                       ;; The next one doesn't have to be a hex, but it helps :)
                                       (when (hex-digit? (string/char-at str (succ offset)))
                                         (consume!))
                                       (string->number (string/sub str start offset) 16)))
                                   ;; Gobbal normal character codes
                                   (let [(start (position))
                                         (ctr 0)]

                                     (set! char (string/char-at str (succ offset)))
                                     (while (and (< ctr 2) (between? char "0" "9"))
                                       (consume!)
                                       (set! char (string/char-at str (succ offset)))
                                       (inc! ctr))

                                     (string->number (string/sub str (.> start :offset) offset)))))]

                        (when (>= val 256)
                          (logger/do-node-error! logger
                            "Invalid escape code"
                            (range (start)) nil
                            (range (start) position) (.. "Must be between 0 and 255, is " val)))

                        (push-cdr! buffer (string/char val)))]
                     [(= char "")
                      (logger/do-node-error! logger
                        "Expected escape code, got eof"
                        (range (position)) nil
                        (range (position)) "end of file here")]
                     [true
                       (logger/do-node-error! logger
                         "Illegal escape character"
                         (range (position)) nil
                         (range (position)) "Unknown escape character")])]
                  ;; Boring normal characters
                  [true
                   (push-cdr! buffer char)])
                (consume!)
                (set! char (string/char-at str offset)))
              (append-with! (struct :tag "string" :value (concat buffer)) start)))
          [(= char ";")
           (while (and (<= offset length) (/= (string/char-at str (succ offset)) "\n"))
             (consume!))]
          [true
            (let ((start (position))
                  (key (= char ":" )))
              (set! char (string/char-at str (succ offset)))
              (while (! (terminator? char))
                (consume!)
                (set! char (string/char-at str (succ offset))))

              (if key
                (append-with! (struct :tag "key" :value (string/sub str (succ (.> start :offset)) offset)) start)
                (append! "symbol" start)))])
        (consume!)))
    (append! "eof")
    out))

(defun parse (logger toks)
  "Parse tokens TOKS, the result of [[lex]]"
  (let* ((index 1)
         (head '())
         (stack '())

         ;; Append a node onto the current head
         (append! (lambda (node)
           (with (next '())
             (push-cdr! head node)
             (.<! node :parent head))))

         ;; Push a node onto the stack, appending it to the previous head
         (push! (lambda ()
             (with (next '())
               (push-cdr! stack head)
               (append! next)
               (set! head next))))

        ;; Pop a node from the stack
         (pop! (lambda ()
           (.<! head :open nil)
           (.<! head :close nil)
           (.<! head :auto-close nil)
           (.<! head :last-node nil)

           (set! head (last stack))
           (pop-last! stack))))
    (for-each tok toks
      (let* ((tag (.> tok :tag))
             (auto-close false))

        ;; Attempt to find mis-matched indents. This both highlights formatting errors and helps find the source of
        ;; parse errors due to mis-matched parenthesis.
        ;; To do this we store a reference to the first node on the previous line and check if the indent is different.
        (let ((previous (.> head :last-node))
              (tok-pos (.> tok :range)))
          ;; This catches a couple of trivial cases:
          ;;  - Closing parenthesis. As lisp doesn't use C style indentation for brackets, the closing one will be on a
          ;;    different line.
          ;;  - Missing range on head due to top level. In this case we just allow whatever.
          ;;  - Nested parenthesis on the same line (such as (foo (+ 2 3))). Obviously we want to ignore these as the
          ;;    indent will be different.
          (when (and (/= tag "eof") (/= tag "close") (if (.> head :range) (/= (.> tok-pos :start :line) (.> head :range :start :line)) true))
            (if previous
              (with (prev-pos (.> previous :range))
                (when (/= (.> tok-pos :start :line) (.> prev-pos :start :line))
                  ;; We're on a different line so update the previous node to be this one.
                  (.<! head :last-node tok)
                  ;; Then ensure we're on the same column
                  (when (/= (.> tok-pos :start :column) (.> prev-pos :start :column))
                    (logger/put-node-warning! logger
                      "Different indent compared with previous expressions."
                      tok
                      "You should try to maintain consistent indentation across a program,
                       try to ensure all expressions are lined up.
                       If this looks OK to you, check you're not missing a closing ')'."

                      prev-pos ""
                      tok-pos  ""))))
              ;; Otherwise this is the first line so set the previous node
              (.<! head :last-node tok))))
        (cond
          [(or (= tag "string") (= tag "number") (= tag "symbol") (= tag "key"))
           (append! tok)]
          [(= tag "open")
           (push!)
           (.<! head :open (.> tok :contents))
           (.<! head :close (.> tok :close))
           (.<! head :range (struct
                              :start (.> tok :range :start)
                              :name  (.> tok :range :name)
                              :lines (.> tok :range :lines)))]
          [(= tag "close")
           (cond
             [(nil? stack)
              ;; Unmatched closing bracket.
              (logger/do-node-error! logger
                (string/format "'%s' without matching '%s'" (.> tok :contents) (.> tok :open))
                tok nil
                (get-source tok) "")]
             [(.> head :auto-close)
              ;; Attempting to close a quote
              (logger/do-node-error! logger
                (string/format "'%s' without matching '%s' inside quote" (.> tok :contents) (.> tok :open))
                tok nil
                (.> head :range) "quote opened here"
                (.> tok :range)  "attempting to close here")]
             [(/= (.> head :close) (.> tok :contents))
              ;; Mismatched brackets
              (logger/do-node-error! logger
                (string/format "Expected '%s', got '%s'" (.> head :close) (.> tok :contents))
                tok nil
                (.> head :range) (string/format "block opened with '%s'" (.> head :open))
                (.> tok :range) (string/format "'%s' used here" (.> tok :contents)))]
             [true
               ;; All OK!
               (.<! head :range :finish (.> tok :range :finish))
               (pop!)])]
          [(or (= tag "quote") (= tag "unquote") (= tag "syntax-quote") (= tag "unquote-splice") (= tag "quasiquote"))
           (push!)
           (.<! head :range (struct
                              :start (.> tok :range :start)
                              :name  (.> tok :range :name)
                              :lines (.> tok :range :lines)))
           (append! (struct
                      :tag      "symbol"
                      :contents tag
                      :range    (.> tok :range)))

           (set! auto-close true)
           (.<! head :auto-close true)]
          [(= tag "eof")
           (when (/= 0 (# stack))
             (logger/do-node-error! logger
               "Expected ')', got eof"
               tok nil
               (.> head :range) "block opened here"
               (.> tok :range)  "end of file here"))]
          [true (error! (string/.. "Unsupported type" tag))])
        (unless auto-close
          (while (.> head :auto-close)
            (when (nil? stack)
              (logger/do-node-error! logger
                (string/format "'%s' without matching '%s'" (.> tok :contents) (.> tok :open))
                tok nil
                (get-source tok) ""))
            (.<! head :range :finish (.> tok :range :finish))
            (pop!)))))
    head))

(defun read (x path)
  "Combination of [[lex]] and [[parse]]"
  (parse void/void (lex void/void x (or path ""))))

(struct :lex lex :parse parse :read read)
