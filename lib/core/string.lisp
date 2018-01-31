(import core/base (defun getmetatable if n progn with for tostring len#
              type# >= > < <= = /= + - car or and list when set-idx!
              get-idx getmetatable while .. defmacro else))
(import core/base b)
(import core/binders (loop let*))
(import core/list list)
(import core/method (pretty))
(import core/demand (assert-type!))

(import lua/string () :export)

(defun char-at (xs x)
  "Index the string XS, returning the character at position X.

   ### Example:
   ```cl
   > (string/char-at \"foo\" 1)
   out = \"f\"
   ```"
  (sub xs x x))

(defun concat (xs separator)
  "Concatenate a list of strings, using an optional separator.

   ### Example
   ```cl
   > (concat '(\"H\" \"i\" \"!\"))
   out = \"Hi!\"
   > (concat '(\"5\" \"+\" \"1\") \" \")
   out = \"5 + 1\"
   ```"
  (assert-type! xs list)
  (with (parent (get-idx xs :parent))
    (if parent
      (b/concat (get-idx xs :parent) separator (+ (get-idx xs :offset) 1) (+ (get-idx xs :n) (get-idx xs :offset)))
      (b/concat xs separator 1 (get-idx xs :n)))))

(defun split (text pattern limit)
  "Split the string given by TEXT in at most LIMIT components, which are
   delineated by the Lua pattern PATTERN.

   It is worth noting that an empty pattern (`\"\"`) will split the
   string into individual characters.

   ### Example
   ```
   > (split \"foo-bar-baz\" \"-\")
   out = (\"foo\" \"bar\" \"baz\")
   > (split \"foo-bar-baz\" \"-\" 1)
   out = (\"foo\" \"bar-baz\")
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
           (list/push! out (sub text start (n text)))
           (set! start (+ (n text) 1))]
          ;; If the start is beyond the string length (somehow) then maybe append the remaining text
          ;; and exit.
          [(> nstart (len# text))
           (when (<= start (len# text))
             (list/push! out (sub text start (len# text))))
           (set! loop false)]
          ;; If the end point is before the start point (0 width match) then we'll gobble just one character
          [(< nend nstart)
           (list/push! out (sub text start nstart))
           (set! start (+ nstart 1))]
          ;; Otherwise gobble everything between matches
          [else
            (list/push! out (sub text start (- nstart 1)))
            (set! start (+ nend 1))])))
    out))

(defun trim (str)
  "Remove whitespace from both sides of STR.

   ### Example:
   ```cl
   > (string/trim \"  foo\\n\\t\")
   out = \"foo\"
   ```"
  (with (res (gsub (gsub str "^%s+" "") "%s+$" ""))
    res))

(define quoted
  "Quote the string STR so it is suitable for printing.

   ### Example:
   ```cl
   > (string/quoted \"\\n\")
   out = \"\\\"\\\\n\\\"\"
   ```"
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
  "Determine whether STR starts with PREFIX.

   ### Example:
   ```cl
   > (string/starts-with? \"Hello, world\" \"Hello\")
   out = true
   ```"
  (= (sub str 1 (len# prefix)) prefix))

(defun ends-with? (str suffix)
  "Determine whether STR ends with SUFFIX.

   ### Example:
   ```cl
   > (string/ends-with? \"Hello, world\" \"world\")
   out = true
   ```"
  (= (sub str (- 0 (len# suffix))) suffix))

(defun string->bytes (str)
  "Convert a string to a list of character bytes.

   ### Example:
   ```cl
   > (string->bytes \"Hello\")
   out = (72 101 108 108 111)
   ```"
  (let* [(len (len# str))
         (out { :tag "list" :n len })]
    ;; Note this implementation isn't idiomatic Urn, but is more efficient.
    ;; It's a core library so it's not too big a deal.
    (for i 1 len 1 (set-idx! out i (byte str i)))
    out))

(defun string->chars (str)
  "Convert a string to a list of characters.

   ### Example:
   ```cl
   > (string->chars \"Hello\")
   out = (\"H\" \"e\" \"l\" \"l\" \"o\")
   ```"
  (let* [(len (len# str))
         (out { :tag "list" :n len })]
    (for i 1 len 1 (set-idx! out i (char-at str i)))
    out))

(defun bytes->string (bytes)
  "Convert a list of BYTES to a string.

   ### Example:
   ```cl
   > (bytes->string '(72 101 108 108 111))
   out = \"Hello\"
   ```"
  (b/concat (list/map char bytes)))

(defun chars->string (chars)
  "Convert a list of CHARS to a string.

   ### Example:
   ```cl
   > (chars->string '(\"H\" \"e\" \"l\" \"l\" \"o\"))
   out = \"Hello\"
   ```"
  (b/concat chars "" 1 (n chars)))

(defun display (x) :hidden
  (cond
    [(= (type# x) "string") x]
    [(and (= (type# x) "table")
          (= (get-idx x :tag) "string"))
     (get-idx x :value)]
    [else (pretty x)]))

(defmacro $ (str)
  "Perform interpolation (variable substitution) on the string STR.

   The string is a sequence of arbitrary characters which may contain an
   unquote, of the form `~{foo}` or `${foo}`, where foo is a variable
   name.

   The `~{x}` form will format the value using [[pretty]], ensuring it is
   readable. `${x}` requires that `x` is a string, simply splicing the
   value in directly.

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
      [(> i (n str))
       (when (/= buf "") (list/push! sections buf))]
      (let* [((rs re rm) (find (sub str i)
                               "~%{([^%} ]+)%}"))
             ((is ie im) (find (sub str i)
                               "%$%{([^%} ]+)%}"))]
        (cond
          [(= rs 1) ; regular ~{foo}
           (when (/= buf "") (list/push! sections buf))
           (list/push! sections
                           `(display
                              ,{ :tag "symbol"
                                 :contents rm }))
           (recur (+ i re)
                  (char-at str (+ i re))
                  "")]
          [(= is 1) ; plain ${foo}
           (when (/= buf "") (list/push! sections buf))
           (list/push! sections
                           { :tag "symbol"
                             :contents im })
           (recur (+ i ie)
                  (char-at str (+ i ie))
                  "")]
          [else (recur (+ 1 i)
                   (char-at str (+ 1 i))
                   (.. buf chr))])))
    `(.. ,@sections)))
