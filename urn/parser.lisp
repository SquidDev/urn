(import urn/error error)
(import urn/logger logger)
(import urn/logger/void void)
(import urn/range ())
(import prelude p)

(define *roman-digits* :hidden
  "Valid roman numeral digits and their values"
  { :I    1
    :V    5
    :X   10
    :L   50
    :C  100
    :D  500
    :M 1000 })

(defun roman-digit? (char)
  "Determinies whether CHAR is a roman numeral digit"
  :hidden
  (or (.> *roman-digits* char) false))

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
  (or (= char "\n") (= char " ") (= char "\t") (= char ";")
      (= char "(") (= char ")") (= char "[") (= char "]") (= char "{") (= char "}")
      (= char "\v") (= char "\f") (= char "")))

(defun closing-terminator? (char)
  "Determines whether CHAR is a terminator of a block"
  :hidden
  (or (= char "\n") (= char " ") (= char "\t") (= char ";")
      (= char ")") (= char "]") (= char "}")
      (= char "\v") (= char "\f") (= char "")))

(defun digit-error! (logger pos name char)
  "Generate an error at POS where a NAME digit was expected and CHAR received instead"
  :hidden
  (error/do-node-error! logger
    (string/format "Expected %s digit, got %s" name (if (= char "")
                                                      "eof"
                                                      (string/quoted char)))
    pos nil
    pos "Invalid digit here"))

(defun eof-error! (context tokens logger msg source explain &lines)
  "A variation of [[error/do-node-error!]], used when we've reached the
   end of the file. If CONTEXT is truthy, then a \"resumable\" error will
   be thrown instead."
  :hidden
  (if context
    (fail! { :msg msg :context context :tokens tokens })
    (apply error/do-node-error! logger msg source explain lines)))

(defun lex (logger str name cont)
  "Lex STR from a file called NAME, returning a series of tokens. If CONT
   is true, then \"resumable\" errors will be thrown if the end of the
   stream is reached."

  ;; Attempt to "normalise" strings
  (set! str (string/gsub str "\r\n?" "\n"))

  (let* [(lines (string/split str "\n"))
         (line 1)
         (column 1)
         (offset 1)
         (length (n str))
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
         (position (lambda () (mk-position offset line column)))
         ;; Generates a table with a particular range
         (range (lambda (start finish) (mk-range name start (or finish start) lines)))
         ;; Appends a struct to the list
         (append-with! (lambda (data start finish)
                         (let [(start (or start (position)))
                               (finish (or finish (position)))]
                           (.<! data :source (range start finish))
                           (.<! data :contents (string/sub str (pos-offset start) (pos-offset finish)))
                           (push! out data))))
         ;; Appends a token to the list
         (append! (lambda (tag start finish)
                    (append-with! {:tag tag} start finish)))
         ;; Parses a roman numeral(not)
         (parse-roman (lambda ()
                        (let* [(start offset)
                               (char (string/char-at str offset))]
                          ; we need at /least/ one digit
                          (unless (roman-digit? char)
                            (digit-error! logger (range (position)) "roman" char))
                          ; consume the rest
                          (set! char (string/char-at str (succ offset)))
                          (while (or (roman-digit? char)
                                     (= char "'")) ; thousands separator
                            (consume!)
                            (set! char (string/char-at str (succ offset))))
                          (with (str (string/gsub (string/reverse (string/sub str start offset)) "'" ""))
                            ; This implementation was stolen and adapted from
                            ; the Rosetta code entry for decoding Roman numerals
                            ; in Scheme.
                            (car (reduce (function
                                           [((?acc ?prev) ?n)
                                            (list ((if (< n prev) - +) acc n)
                                                  (math/max n prev))])
                                         (list 0 0)
                                         (map (comp (cut .> *roman-digits* <>) string/upper (cut string/char-at str <>))
                                              (p/range :from 1 :to (n str)))))))))
         (parse-base (lambda (name p base)
                       (let* [(start offset)
                              (char (string/char-at str offset))]
                         ;; Require at least one character
                         (unless (p char) (digit-error! logger (range (position)) name char))

                         ;; Consume all remaining characters matching this
                         (set! char (string/char-at str (succ offset)))
                         (while (or (p char)
                                    (= "'" char)) ; thousands separator
                           (consume!)
                           (set! char (string/char-at str (succ offset))))

                         (with (thousands-separated (string/gsub (string/sub str start offset) "'" ""))
                           ;; And convert the digit to a string
                           (string->number thousands-separated base)))))]
    ;; Scan the input stream, consume one character, then read til the end of that token.
    (while (<= offset length)
      (with (char (string/char-at str offset))
        (cond
          [(or (= char "\n") (= char "\t") (= char " ") (= char "\v") (= char "\f"))]
          [(= char "(") (append-with! {:tag "open" :close ")"})]
          [(= char ")") (append-with! {:tag "close" :open "("})]
          [(= char "[") (append-with! {:tag "open" :close "]"})]
          [(= char "]") (append-with! {:tag "close" :open "["})]
          [(= char "{") (append-with! {:tag "open-struct" :close "}"})]
          [(= char "}") (append-with! {:tag "close" :open "{"})]
          [(= char "'") (append! "quote")]
          [(= char "`") (append! "syntax-quote")]
          [(= char "~") (append! "quasiquote")]
          [(and (= char "@") (not (closing-terminator? (string/char-at str (succ offset)))))
           ;; For backwards compatibility reasons we should ensure we've got some symbols after this.
           (append! "splice")]
          [(= char ",")
           (if (= (string/char-at str (succ offset)) "@")
             (with (start (position))
               (consume!)
               (append! "unquote-splice" start))
             (append! "unquote"))]
          [(string/find str "^%-?%.?[#0-9]" offset)
           (let [(start (position))
                 (negative (= char "-"))]
             ;; Check whether this number is negative
             (when negative
               (consume!)
               (set! char (string/char-at str offset)))

             (cond
               ;; Parse hexadecimal digits
               [(and (= char "#") (= (string/lower (string/char-at str (succ offset))) "x"))
                (consume!)
                (consume!)
                (with (res (parse-base "hexadecimal" hex-digit? 16))
                  (when negative (set! res (- 0 res)))
                  (append-with! { :tag "number" :value res } start))]

               ;; Parse binary digits
               [(and (= char "#") (= (string/lower (string/char-at str (succ offset))) "b"))
                (consume!)
                (consume!)
                (with (res (parse-base "binary" bin-digit? 2))
                  (when negative (set! res (- 0 res)))
                  (append-with! { :tag "number" :value res } start))]

               ;; Parse roman digits
               [(and (= char "#") (= (string/lower (string/char-at str (succ offset))) "r"))
                (consume!)
                (consume!)
                (with (res (parse-roman))
                  (when negative (set! res (- 0 res)))
                  (append-with! { :tag "number" :value res } start))]

               ;; Other leading "#"s are illegal
               [(and (= char "#") (terminator? (string/lower (string/char-at str (succ offset)))))
                (error/do-node-error! logger
                  "Expected hexadecimal (#x), binary (#b), or Roman (#r) digit specifier."
                  (range (position))
                  "The '#' character is used for various number representations, such as binary
                   and hexadecimal digits.

                   If you're looking for the '#' function, this has been replaced with 'n'. We
                   apologise for the inconvenience."
                  (range (position)) "# must be followed by x, b or r")]
               [(= char "#")
                (consume!)
                (error/do-node-error! logger
                  "Expected hexadecimal (#x), binary (#b), or Roman (#r) digit specifier."
                  (range (position))
                  "The '#' character is used for various number representations, namely binary,
                   hexadecimal and roman numbers."
                  (range (position)) "# must be followed by x, b or r")]

               [else
                ;; Parse leading digits
                (while (or (between? (string/char-at str (succ offset))  "0" "9")
                           (= (string/char-at str (succ offset)) "'")) ; thousands separator
                  (consume!))

                (cond
                  ;; Rational support
                  [(= (string/char-at str (succ offset)) "/")
                   (let* [(num-end (position))
                          ;; We're currently sitting at the last digit of the numerator, so move to the "/"
                          (_ (consume!))
                          ;; And move once more to reach the start of the denominator
                          (_ (consume!))
                          (dom-start (position))]

                     ;; We ensure we've got some sort of number, as we don't want to allow
                     ;; 1/-1 or 1/.1
                     (unless (or (between? (string/char-at str offset) "0" "9")
                                 (= (string/char-at str offset) "'"))
                       (error/do-node-error! logger
                         (format nil "Expected digit, got {$1:string/quoted}" (string/char-at str offset))
                         (range dom-start)
                         ""
                         (range dom-start) ""))

                     (while (or (between? (string/char-at str (succ offset)) "0" "9")
                                (= (string/char-at str (succ offset)) "'"))
                       (consume!))

                     (let* [(dom-end (position))
                            (num (string->number (string/gsub (string/sub str (pos-offset start) (pos-offset num-end)) "'" "") 10))
                            (dom (string->number (string/gsub (string/sub str (pos-offset dom-start) (pos-offset dom-end)) "'" "") 10))]
                       (unless num
                         (error/do-node-error! logger
                           "Invalid numerator in rational literal"
                           (range start num-end)
                           ""
                           (range start num-end) "There should be at least one number before the division symbol."))
                       (unless dom
                         (error/do-node-error! logger
                           "Invalid denominator in rational literal"
                           (range dom-start dom-end)
                           ""
                           (range dom-start dom-end) "There should be at least one number after the division symbol."))

                       (append-with! { :tag "rational"
                                       :num { :tag "number" :value num :source (range start num-end) }
                                       :dom { :tag "number" :value dom :source (range dom-start dom-end) } } start)))]

                  ;; Decimal support
                  [else
                   ;; Consume decimal places
                   (when (= (string/char-at str (succ offset)) ".")
                     (consume!)
                     (while (or (between? (string/char-at str (succ offset))  "0" "9")
                                (= (string/char-at str (succ offset)) "'")) ; thousands here too
                       (consume!)))

                   ;; Consume exponent
                   (set! char (string/char-at str (succ offset)))
                   (when (or (= char "e") (= char "E"))
                     (consume!)
                     (set! char (string/char-at str (succ offset)))

                     ;; Gobble positive/negative bit
                     (when (or (= char "-") (= char "+")) (consume!))

                     ;; And exponent digits
                     (while (or (between? (string/char-at str (succ offset))  "0" "9")
                                (= (string/char-at str (succ offset)) "'")) ; thousands here too
                       (consume!)))

                   (with (res (string->number (id (string/gsub (string/sub str (pos-offset start) offset) "'" ""))))
                     (unless res
                       (error/do-node-error! logger
                         (string/format "Expected digit, got %s" (if (= char "")
                                                                   "eof"
                                                                   (string/quoted char)))
                         (range (position)) nil
                         (range (position)) "Illegal character here. Are you missing whitespace?"))
                     (append-with! { :tag "number" :value res } start))])])

             ;; Ensure the next character is a terminator of some sort, otherwise we'd allow things like 0x2-2
             (set! char (string/char-at str (succ offset)))
             (unless (terminator? char)
               (consume!)

               (error/do-node-error! logger
                 (string/format "Expected digit, got %s" (if (= char "")
                                                           "eof"
                                                           (string/quoted char)))
                 (range (position)) nil
                 (range (position)) "Illegal character here. Are you missing whitespace?")))]
          [(or (= char "\"") (and (= char "$") (= (string/char-at str (succ offset)) "\"")))
            (let* [(start (position))
                   (start-col (succ column))
                   (buffer '())
                   (interpolate (= char "$"))]
              (when interpolate (consume!))
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
                         (push! buffer "\n")
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
                          (push! buffer (string/sub str line-off (pred offset)))
                          (set! running false)])
                      (set! char (string/char-at str offset)))))
                (cond
                  [(= char "")
                   (let ((start (range start))
                         (finish (range (position))))
                     (eof-error! (and cont "string") out logger
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
                     [(= char "a") (push! buffer "\a")]
                     [(= char "b") (push! buffer "\b")]
                     [(= char "f") (push! buffer "\f")]
                     [(= char "n") (push! buffer "\n")]
                     [(= char "r") (push! buffer "\r")]
                     [(= char "t") (push! buffer "\t")]
                     [(= char "v") (push! buffer "\v")]
                     ;; Escaped characters
                     [(= char "\"") (push! buffer "\"")]
                     [(= char "\\") (push! buffer "\\")]
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
                                   ;; Gobble normal character codes
                                   (let [(start (position))
                                         (ctr 0)]

                                     (set! char (string/char-at str (succ offset)))
                                     (while (and (< ctr 2) (between? char "0" "9"))
                                       (consume!)
                                       (set! char (string/char-at str (succ offset)))
                                       (inc! ctr))

                                     (string->number (string/sub str (pos-offset start) offset)))))]

                        (when (>= val 256)
                          (error/do-node-error! logger
                            "Invalid escape code"
                            (range start) nil
                            (range start (position)) (.. "Must be between 0 and 255, is " val)))

                        (push! buffer (string/char val)))]
                     [(= char "")
                      (eof-error! (and cont "string") out logger
                        "Expected escape code, got eof"
                        (range (position)) nil
                        (range (position)) "end of file here")]
                     [true
                       (error/do-node-error! logger
                         "Illegal escape character"
                         (range (position)) nil
                         (range (position)) "Unknown escape character")])]
                  ;; Boring normal characters
                  [true
                   (push! buffer char)])
                (consume!)
                (set! char (string/char-at str offset)))
              (if interpolate
                (let [(value (concat buffer))
                      (sections '())
                      (len (n str))]
                  (loop [(i 1)] []
                    (let* [((rs re rm) (string/find value  "~%{([^%} ]+)%}" i))
                           ((is ie im) (string/find value "%$%{([^%} ]+)%}" i))]
                      (cond
                        [(and rs (=> is (< rs is)))
                         (push! sections (string/sub value i (pred rs)))
                         (push! sections (.. "{#" rm "}"))
                         (recur (succ re))]
                        [is
                         (push! sections (string/sub value i (pred is)))
                         (push! sections (.. "{#" im ":id}"))
                         (recur (succ ie))]
                        [else
                         (push! sections (string/sub value i len))])))

                  (logger/put-node-warning! logger
                    "The $ syntax is deprecated and should be replaced with format."
                    (range start (position)) nil
                    (range start (position)) (.. "Can be replaced with (format nil " (string/quoted (concat sections)) ")"))

                  (append-with! {:tag "interpolate" :value value} start))
                (append-with! {:tag "string" :value (concat buffer)} start)))]
          [(= char ";")
           (while (and (<= offset length) (/= (string/char-at str (succ offset)) "\n"))
             (consume!))]
          [true
            (let ((start (position))
                  (key (= char ":" )))
              (set! char (string/char-at str (succ offset)))
              (while (not (terminator? char))
                (consume!)
                (set! char (string/char-at str (succ offset))))

              (if key
                (append-with! {:tag "key" :value (string/sub str (succ (pos-offset start)) offset)} start)
                (append! "symbol" start)))])
        (consume!)))
    (append! "eof")
    (values-list out (range (mk-position 1 1) (position)))))

(defun parse (logger toks cont)
  "Parse tokens TOKS, the result of [[lex]]. If CONT is true, then
   \"resumable\" errors will be thrown if the end of the stream is
   reached."
  (let* [(head '())
         (stack '())

         ;; Append a node onto the current head
         (append! (lambda (node)
                    (push! head node)))

         ;; Push a node onto the stack, appending it to the previous head
         (push! (lambda ()
                  (with (next '())
                    (push! stack head)
                    (append! next)
                    (set! head next))))

        ;; Pop a node from the stack
         (pop! (lambda ()
                 (.<! head :open nil)
                 (.<! head :close nil)
                 (.<! head :auto-close nil)
                 (.<! head :last-node nil)

                 (set! head (last stack))
                 (pop-last! stack)))]
    (for-each tok toks
      (let* [(tag (type tok))
             (auto-close false)]

        ;; Attempt to find mismatched indents. This both highlights formatting errors and helps find the source of
        ;; parse errors due to mismatched parentheses.
        ;; To do this we store a reference to the first node on the previous line and check if the indent is different.
        (let [(previous (.> head :last-node))
              (tok-pos (.> tok :source))]
          ;; This catches a couple of trivial cases:
          ;;  - Closing parentheses. As lisp doesn't use C style indentation for brackets, the closing one will be on a
          ;;    different line.
          ;;  - Missing range on head due to top level. In this case we just allow whatever.
          ;;  - Nested parentheses on the same line (such as (foo (+ 2 3))). Obviously we want to ignore these as the
          ;;    indent will be different.
          (when (and (/= tag "eof") (/= tag "close")
                     (if (.> head :source)
                       (/= (pos-line (range-start tok-pos)) (pos-line (range-start (.> head :source))))
                       true))
            (if previous
              (with (prev-pos (.> previous :source))
                (when (/= (pos-line (range-start tok-pos)) (pos-line (range-start prev-pos)))
                  ;; We're on a different line so update the previous node to be this one.
                  (.<! head :last-node tok)
                  ;; Then ensure we're on the same column
                  (when (/= (pos-column (range-start tok-pos)) (pos-column (range-start prev-pos)))
                    (logger/put-node-warning! logger
                      "Different indent compared with previous expressions."
                      (.> tok :source)
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
          [(= tag "interpolate")
           (append! { :tag "list"
                      :n 2
                      :source (.> tok :source)
                      1 { :tag "symbol"
                          :contents "$"
                          :source (range-of-start (.> tok :source)) }
                      2 { :tag "string"
                          :value (.> tok :value)
                          :source (.> tok :source) } })]
          [(= tag "rational")
           (append! { :tag "list"
                      :n 3
                      :source (.> tok :source)
                      1 { :tag "symbol"
                          :contents "rational"
                          :source (.> tok :source) }
                      2 (.> tok :num)
                      3 (.> tok :dom) })]
          [(= tag "open")
           (push!)
           (.<! head :open (.> tok :contents))
           (.<! head :close (.> tok :close))
           (.<! head :source (.> tok :source))]
          [(= tag "open-struct")
           (push!)
           (.<! head :open (.> tok :contents))
           (.<! head :close (.> tok :close))
           (.<! head :source (.> tok :source))
           (append! { :tag      "symbol"
                      :contents "struct-literal"
                      :source    (.> head :source) })]
          [(= tag "close")
           (cond
             [(empty? stack)
              ;; Unmatched closing bracket.
              (error/do-node-error! logger
                (string/format "'%s' without matching '%s'" (.> tok :contents) (.> tok :open))
                (.> tok :source) nil
                (get-source tok) "")]
             [(.> head :auto-close)
              ;; Attempting to close a quote
              (error/do-node-error! logger
                (string/format "'%s' without matching '%s' inside quote" (.> tok :contents) (.> tok :open))
                (.> tok :source) nil
                (.> head :source) "quote opened here"
                (.> tok :source)  "attempting to close here")]
             [(/= (.> head :close) (.> tok :contents))
              ;; Mismatched brackets
              (error/do-node-error! logger
                (string/format "Expected '%s', got '%s'" (.> head :close) (.> tok :contents))
                (.> tok :source) nil
                (.> head :source) (string/format "block opened with '%s'" (.> head :open))
                (.> tok :source) (string/format "'%s' used here" (.> tok :contents)))]
             [true
               ;; All OK!
               (.<! head :source (range-of-span (.> head :source) (.> tok :source)))
               (pop!)])]
          [(or (= tag "quote") (= tag "unquote") (= tag "syntax-quote") (= tag "unquote-splice")
               (= tag "quasiquote") (= tag "splice"))
           (push!)
           (.<! head :source (.> tok :source))
           (append! { :tag      "symbol"
                      :contents tag
                      :source    (.> tok :source) })

           (set! auto-close true)
           (.<! head :auto-close true)]
          [(= tag "eof")
           (when (/= 0 (n stack))
             (eof-error! (and cont "list") toks logger
               (if (.> head :auto-close)
                 (string/format "Expected expression quote, got eof" (.> head :close))
                 (string/format "Expected '%s', got eof" (.> head :close)))
               (.> tok :source) nil
               (.> head :source) "block opened here"
               (.> tok :source)  "end of file here"))]
          [else (error! (.. "Unsupported type " tag))])
        (unless auto-close
          (while (.> head :auto-close)
            (when (empty? stack)
              (error/do-node-error! logger
                (string/format "'%s' without matching '%s'" (.> tok :contents) (.> tok :open))
                (.> tok :source) nil
                (get-source tok) ""))
            (.<! head :source (range-of-span (.> head :source) (.> tok :source)))
            (pop!)))))
    head))

(defun read (x path)
  "Combination of [[lex]] and [[parse]]"
  (parse void/void (lex void/void x (or path "") nil) nil))
