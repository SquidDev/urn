(import base (defun getmetatable if # progn with
              type# >= = + - car or and list when set-idx!
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
   delineated by the Lua pattern PATTERN."
  (let* [(out '())
         (loop true)
         (start 1)]
    (while loop
      (let* [(pos (list (find text pattern start)))]
        (if (or (= "nil" (type# pos)) (= (list/nth pos 1) nil) (and limit (>= (# out) limit)))
          (progn
            (set! loop false)
            (list/push-cdr! out (sub text start (#s text)))
            (set! start (+ (#s text) 1)))
          (progn
            (if (car pos)
              (progn
                (list/push-cdr! out (sub text start (- (car pos) 1)))
                (set! start (+ (list/cadr pos) 1)))
              (set! loop false))))))
    out))


(define quoted
  "Quote the string STR so it is suitable for printing."
  (with (escapes (empty-struct))
    ;; Define some mappings for escape characters
    (set-idx! escapes "\t" "\\9")
    (set-idx! escapes "\n" "n")

    (lambda (str)
      ;; We have to store it in a temp variable to ensure
      ;; we only return one value.
      (with (result (gsub (format "%q" str) "." escapes))
        result))))
