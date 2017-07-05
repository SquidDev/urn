(import base (defun getmetatable if n progn with for tostring len#
              type# >= > < <= = + - car or and list when set-idx!
              debug
              get-idx getmetatable let* while .. pretty defmacro))
(import base (concat) :export)
(import list)
(import binders (loop))
(import lua/string () :export)

(defun char-at (xs x)
  "Index the string XS, returning the character at position X."
  (sub xs x x))

(defun split (text pattern limit)
  "Split the string given by TEXT in at most LIMIT components, which are
   delineated by the Lua pattern PATTERN.

   It is worth noting that an empty pattern (`\"\"`) will split the
   string into individual characters.

   ### Example
   ```
   > (split \"foo-bar-baz\" \"-\")
   (\"foo\" \"bar\" \"baz\")
   > (split \"foo-bar-baz\" \"-\" 1)
   (\"foo\" \"bar-baz\")
   ```"
  (let* [(out '())
         (loop true)
         (start 1)]
    (while loop
      (let* [(pos (list (find text pattern start)))
             (nstart (list/car pos))
             (nend   (list/cadr pos))]
        (cond
          ;; If nothing was matched, or we've gone over the limit then append the remaining text
          ;; and exit.
          [(or (= nstart nil) (and limit (>= (n out) limit)))
           (set! loop false)
           (list/push-cdr! out (sub text start (n text)))
           (set! start (+ (n text) 1))]
          ;; If the start is beyond the string length (somehow) then maybe append the remaining text
          ;; and exit.
          [(> nstart (len# text))
           (when (<= start (len# text))
             (list/push-cdr! out (sub text start (len# text))))
           (set! loop false)]
          ;; If the end point is before the start point (0 width match) then we'll gobble just one character
          [(< nend nstart)
           (list/push-cdr! out (sub text start nstart))
           (set! start (+ nstart 1))]
          ;; Otherwise gobble everything between matches
          [true
            (list/push-cdr! out (sub text start (- nstart 1)))
            (set! start (+ nend 1))])))
    out))

(defun trim (str)
  "Remove whitespace from both sides of STR."
  (with (res (gsub (gsub str "^%s+" "") "%s+$" ""))
    res))

(define quoted
  "Quote the string STR so it is suitable for printing."
  (with (escapes {})
    ;; Define some mappings for escape characters
    (for i 0 31 1 (set-idx! escapes (char i) (.. "\\" (tostring i))))
    (set-idx! escapes "\n" "n")

    (lambda (str)
      ;; We have to store it in a temp variable to ensure
      ;; we only return one value.
      (with (result (gsub (format "%q" str) "." escapes))
        result))))

(defun starts-with? (str prefix)
  "Determine whether STR starts with PREFIX."
  (= (sub str 1 (len# prefix)) prefix))

(defun ends-with? (str suffix)
  "Determine whether STR ends with SUFFIX."
  (= (sub str (- 0 (len# suffix))) suffix))

(defun display (x) :hidden
  (cond
    [(= (type# x) "string") x]
    [(and (= (type# x) "table")
          (= (get-idx x :tag) "string"))
     x]
    [:else (pretty x)]))

(defmacro $ (str)
  "Perform interpolation (variable substitution) on the string STR.

   The string is a sequence of arbitrary characters which may contain
   an unquote, of the form `~{foo}`, where foo is a variable name.

   ### Example:
   ```cl
   > (let* [(x 1)] ($ \"~{x} = 1\"))
   out = \"1 = 1\"
   ```"
  (set! str (get-idx str :value))
  (let* [(sections '())]
    (loop [(i 1)
           (chr (char-at str 1))
           (buf "")]
      [(> i (n str)) (list/push-cdr! sections buf)]
      (let* [(mth (list (find (sub str i)
                              "~%{([^%) ]+)%}")))]
        (if (and (>= (n mth) 0)
                 (list/car mth))
          (progn
            (list/push-cdr! sections buf)
            (list/push-cdr! sections
                            `(display
                               ,{ :tag "symbol"
                               :contents (list/caddr mth) }))
            (recur (+ i (list/cadr mth))
                   (char-at str (+ i (list/cadr mth)))
                   ""))
          (recur (+ 1 i)
                 (char-at str (+ 1 i))
                 (.. buf chr)))))
    `(.. ,@sections)))
