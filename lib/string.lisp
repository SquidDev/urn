(import base (defun getmetatable if # progn with for tostring
              type# >= > < <= = + - car or and list when set-idx!
              get-idx getmetatable let* while))
(import base (concat) :export)
(import list)
(import lua/string () :export)
(import lua/table (empty-struct))

(defun char-at (xs x)
  "Index the string XS, returning the character at position X."
  (sub xs x x))

(defun .. (&args)
  "Concatenate the several values given in ARGS. They must all be strings."
  (concat args))

(define #s "Return the length of the string X." len)

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
          [(or (= nstart nil) (and limit (>= (# out) limit)))
           (set! loop false)
           (list/push-cdr! out (sub text start (#s text)))
           (set! start (+ (#s text) 1))]
          ;; If the start is beyond the string length (somehow) then maybe append the remaining text
          ;; and exit.
          [(> nstart (#s text))
           (when (<= start (#s text))
             (list/push-cdr! out (sub text start (#s text))))
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
  (if (or (= (sub str 1 1) " ") (= (sub str 1 1) "\t"))
    (trim (sub str 2 (#s str)))
    (if (or (= (sub str -1 -1) " ") (= (sub str -1 -1) "\t"))
      (trim (sub str 1 (- (#s str) 1)))
      str)))

(define quoted
  "Quote the string STR so it is suitable for printing."
  (with (escapes (empty-struct))
    ;; Define some mappings for escape characters
    (for i 0 31 1 (set-idx! escapes (char i) (.. "\\" (tostring i))))
    (set-idx! escapes "\n" "n")

    (lambda (str)
      ;; We have to store it in a temp variable to ensure
      ;; we only return one value.
      (with (result (gsub (format "%q" str) "." escapes))
        result))))
