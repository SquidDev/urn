(import string)
(import lua/math math)

(define builtins
  :hidden
  (get-idx (require "tacky.analysis.resolve") :builtins))

(define tokens
  "The primary tokens for the documentation string"
  :hidden
  '(("arg"    "(%f[%a]%u+%f[%A])")
    ("mono"   "```[a-z]*\n([^`]*)\n```")
    ("mono"   "`([^`]*)`")
    ("link"   "%[%[(.-)%]%]")))

(defun extract-signature (var)
  "Attempt to extract the function signature from VAR"
  (with (ty (type var))
    (cond
      [(or (= ty "macro") (= ty "defined"))
       (let* [(root (.> var :node))
              (node (nth root (# root)))]
         (if (and (list? node) (symbol? (car node)) (= (.> (car node) :var) (.> builtins :lambda)))
           (nth node 2)
           nil))]
      (true nil))))

(defun parse-docstring (str)
  "Tokenise STR into a series of tokens
   Each token gets two fields: `:tag`: it's type, and `:contents`: the content of
   the field"
  (let [(out '())
        (pos 1)
        (len (#s str))]
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
              (push-cdr! out (struct
                               :tag "text"
                               :contents (string/sub str pos (pred spos)))))

            ;; And push this token
            (push-cdr! out (struct
                             :tag name
                             :whole    (string/sub str spos epos)
                             :contents (string/match (string/sub str spos epos) ptrn)))
            (set! pos (succ epos)))

          (progn
            ;; Nothing matched to push the remaining text and exit
            (push-cdr! out (struct
                             :tag "text"
                             :contents (string/sub str pos len)))
            (set! pos (succ len))))))
    out))
