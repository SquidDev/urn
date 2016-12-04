(import string)
(import urn/logger logger)

(defun lex (str name)
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
         (range (lambda (start finish) (struct :start start :finish finish :lines lines :name name)))
         ;; Appends a token to the list
         (append! (lambda (tag start finish)
           (let ((start (or start (position)))
                 (finish (or finish (position))))
             (push-cdr! out (struct
               :tag      tag
               :range    (range start finish)
               :contents (string/sub str (.> start :offset) (.> finish :offset))))))))
    ;; Scan the input stream, consume one character, then reading til the end of that token.
    (while (<= offset length)
      (with (char (string/char-at str offset))
        (cond
          ((or (= char "\n") (= char "\t") (= char " ")))
          ((= char "'") (append! "quote"))
          ((= char "(") (append! "open"))
          ((= char ")") (append! "close"))
          ((= char "`") (append! "quasiquote"))
          ((= char ",") (if (= (string/char-at str (succ offset) "@"))
            (with (start (position))
              (consume!)
              (append! "unquote-splice" start))
            (append! "unquote")))
          ((or (between? char "0" "9") (and (= char "-") (between? (string/char-at str (succ offset)) "0" "9")))
            (with (start (position))
              (while (string/find (string/char-at str (succ offset)) "[0-9.e+-]")
                (consume!))
              (append! "number" start)))
          ((= char "\"")
            (with (start (position))
              (consume!)
              (set! char (string/char-at str offset))
              (while (/= char "\"")
                (cond
                  ((or (= char nil) (= char ""))
                    (logger/print-error! "Expected '\"', got eof")

                    (let ((start (range start))
                          (finish (range (position))))
                      (logger/put-trace! (struct :range finish))
                      (logger/put-lines! false
                        start  "string started here"
                        finish "end of file here")
                      (fail "Lexing failed")))
                  ((= char "\\") (consume!))
                  (true))
                (consume!)
                (set! char (string/char-at str offset)))
              (append! "string" start)))
          ((= char ";")
            (while (and (<= offset length) (/= (string/char-at str (succ offset)) "\n"))
              (consume!)))
          (true
            (let ((start (position))
                  (tag (if (= char ":" ) "key" "symbol")))
              (set! char (string/char-at str (succ offset)))
              (while (and (/= char "\n") (/= char " ") (/= char "\t") (/= char "(") (/= char ")") (/= char ""))
                (consume!)
                (set! char (string/char-at str (succ offset))))
              (append! tag start))))
        (consume!)))
    (append! "eof")
    out))

(defun parse (toks)
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
           (set! head (last stack))
           (pop-last! stack))))
    (for-each tok toks
      (let* ((tag (.> tok :tag))
             (auto-close false))
        (cond
          ((or (= tag "string") (= tag "number") (= tag "symbol") (= tag "key"))
            (append! tok))
          ((= tag "open")
            (with (previous (last head))
              ;; We want to detect places where the indent is different.
              ;; Initially we check that they aren't on the same line as the parent:
              ;; this catches cases like:
              ;;   (define x (lambda (x)
              ;;     (foo))) ; Has a different line and indent then parent.
              ;; We obviously shouldn't report entries which are on the same line:
              ;;   (foo) (bar) ; Has a different indent
              ;; TODO: This will fail for "tabulated data"
              (if (and previous (.> head :range) (/= (.> previous :range :start :line) (head :range :start :line)))
                (let ((prev-pos (.> previous :range))
                      (tok-pos (.> tok :range)))
                  (if (and (/= (.> prev-pos :start :column) (.> tok-pos :start :column)) (/= (.> prev-pos :start :line) (.> tok-pos :start :line)))
                    (logger/print-warning! "Different indent compared with previous expressions.")
                    (logger/put-trace! tok)

                    (logger/put-info!
                      "You should try to maintain consistent indentation across a program,"
                      "try to ensure all expressions are lined up."
                      "If this looks OK to you, check you're not missing a closing ')'.")

                    (logger/put-lines! false
                      prev-pos ""
                      tok-pos  ""))))
              (push!)
              (.<! head :range (struct
                :start (.> tok :range :start)
                :name  (.> tok :range :name)
                :lines (.> tok :range :lines)))))
          ((= tag "close")
            (cond
              ((nil? stack)
                (logger/put-error! tok "')' without matching '('")
                (fail "Parsing failed"))
              ((.> head :auto-close)
                ;; TODO: More information about opening quote location
                (logger/print-error! "')' without matching '('")
                (logger/put-trace! tok)

                (logger/put-lines! false
                  (.> head :range) "quote opened here"
                  (.> tok :range)  "attempting to close here")
                (fail "Parsing failed"))
              (true
                (.<! head :range :finish (.> tok :range :finish))
                (pop!))))
          ((or (= tag "quote") (= tag "unquote") (= tag "quasiquote") (= tag "unquote-splice"))
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
            (.<! head :auto-close true))
          ((= tag "eof")
            (when (/= 0 (# stack))
              (logger/print-error! "Expected ')', got eof")
              (logger/put-trace! tok)

              (logger/put-lines! false
                (.> head :range) "block opened here"
                (.> tok :range)  "end of file here")
              (fail "Parsing failed")))
          (true (error (string/.. "Unsupported type" tag))))
        (when (and (! auto-close) (.> head :auto-close))
          (when (nil? stack)
            (logger/put-error! tok "')' without matching '('")
            (fail "Parsing failed"))
          (.<! head :auto-close nil)
          (.<! head :range :finish (.> tok :range :finish))
          (pop!))))
    head))
