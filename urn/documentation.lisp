(import urn/analysis/nodes (builtin?))
(import urn/resolve/scope scope)
(import urn/resolve/native native)

(define tokens
  "The primary tokens for the documentation string"
  :hidden
  '(("arg"    "(%f[%a][%u-]+%f[^%a%d%-])")
    ("mono"   "```[^\n]*\n(.-)\n```")
    ("mono"   "`([^`\n]*)`")
    ("bolic"  "(%*%*%*%w.-%w%*%*%*)")
    ("bold"   "(%*%*%w.-%w%*%*)")
    ("italic" "(%*%w.-%w%*)")
    ("link"   "%[%[([^\n]-)%]%]")))

(define stars
  "The number of stars in a token kind"
  :hidden
  { :text   0
    :italic 1
    :bold   2
    :bolid  3 })

(defun extract-signature (var history)
  "Attempt to extract the function signature from VAR"
  (with (ty (scope/var-kind var))
    (cond
      ;; If we've already attempted to index this variable then give up
      [(and history (.> history var)) nil]
      ;; If we're a macro or normal definition then we can look it up
      [(or (= ty "macro") (= ty "defined"))
       (if-with (root (scope/var-node var))
         ;; Start at (define ... X)
         (loop [(node (nth root (n root)))]
           [(not node) nil]
           (cond
             ;; If we're a symbol then look up that signature instead
             [(symbol? node)
              (unless history (set! history {}))
              (.<! history var true)
              (extract-signature (.> node :var) history)]

             ;; If we're a lambda then return the definition
             [(and (list? node) (builtin? (car node) :lambda))
              ;; Prefer the display name to the actual name.
              (map (lambda (sym) (or (.> sym :display-name) (.> sym :contents))) (nth node 2))]

             ;; If we're a binding then return the last node
             [(and (list? node) (list? (car node)) (builtin? (caar node) :lambda) (>= (n (car node)) 3))
              (recur (last (car node)))]

             [else nil]))
         nil)]

      [(= ty "native")
       (if-with (sig (native/native-signature (scope/var-native var)))
         (map (lambda (sym) (or (.> sym :display-name) (.> sym :contents))) sig)
         nil)]

      [else nil])))

(defun parse-docstring (str)
  "Tokenise STR into a series of tokens
   Each token gets two fields: `:tag`: it's type, and `:contents`: the content of
   the field"
  (let [(out '())
        (pos 1)
        (len (n str))]
    (while (<= pos len)
      (let* [(spos len)
             (epos nil)
             (name nil)
             (ptrn nil)]

        ;; Find the next token in the string
        (for-each tok tokens
          (with (npos (list (string/find str (nth tok 2) pos)))
            (when (and (car npos) (< (car npos) spos))
              (set! spos (car npos))
              (set! epos (nth npos 2))
              (set! name (car tok))
              (set! ptrn (nth tok 2)))))

        (if name
          (progn
            ;; Find any text between tokens
            (when (< pos spos)
              (push! out { :kind     "text"
                               :contents (string/sub str pos (pred spos)) }))

            ;; And push this token
            (push! out { :kind     name
                             :whole    (string/sub str spos epos)
                             :contents (string/match (string/sub str spos epos) ptrn) })
            (set! pos (succ epos)))

          (progn
            ;; Nothing matched to push the remaining text and exit
            (push! out { :kind     "text"
                             :contents (string/sub str pos len) })
            (set! pos (succ len))))))
    out))

(defun extract-summary (toks)
  "Extract a summary from the tokenised docstring TOKS."
  (with (result '())
    (loop [(i 1)]
      [(> i (n toks))]

      (let* [(tok (nth toks i))
             (kind (.> tok :kind))]

        (cond
          [(= kind "mono")
           (cond
             ;; If we have a code block then terminate immediately.
             [(= (string/sub (.> tok :whole) 1 3) "```")
              (push! result { :kind "text" :contents "..." })]
             ;; Otherwise continue as normal
             [else
              (push! result tok)
              (recur (succ i))])]

          ;; Arguments and links can be appended as normal
          [(or (= kind "arg") (= kind "link"))
           (push! result tok)
           (recur (succ i))]

          [else
           (let* [(newline (string/find (.> tok :contents) "\n\n"))
                  (sentence (string/find (.> tok :contents) "[.!?]"))
                  (end (cond
                         [(and newline sentence) (math/min (pred newline) sentence)]
                         [newline (pred newline)]
                         [else sentence]))]

             (cond
               [end
                (push! result { :kind     kind
                                    :contents (-> (.> tok :contents)
                                                  (string/sub <> 1 end)
                                                  (string/gsub <> "\n", " ")
                                                  (.. <> (string/rep "*" (.> stars kind)))) })]

               [else
                (push! result { :kind     kind
                                    :contents (.> (string/gsub (.> tok :contents) "\n" " "))
                                    :whole    (and (.> tok :whole) (.> (string/gsub (.> tok :whole) "\n" " "))) })
                (recur (succ i))]))])))

    result))
