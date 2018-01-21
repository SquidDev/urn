(import core/prelude (defun defmacro with case and or if let loop for
                      symbol->string n nth list? list symbol? type gensym eq? else const-val slice
                      = /= > <= .> .<! + -))
(import core/string string)


(import compiler/nodes ())

(defun metavar? (x)
  "Determine whether X is a metavar."
  :hidden
  (with (str (symbol->string x))
    (and (= (.> x :var) nil) (> (n str) 1) (= (string/char-at str 1) "?"))))

(defun genvar? (x)
  "Determine whether X is a gensym var."
  :hidden
  (with (str (symbol->string x))
    (and (= (.> x :var) nil) (> (n str) 1) (= (string/char-at str 1) "%"))))

(defun fullvar? (x)
  "Determine whether X is a fully qualified variable."
  :hidden
  (with (str (symbol->string x))
    (and (= (.> x :var) nil) (> (n str) 1) (= (string/char-at str 1) "$"))))

(defun pattern# (ptrn)
  "Quote a search/replacement pattern."
  :hidden
  (case (type ptrn)
    ["string" ptrn]
    ["number" ptrn]
    ["key" ptrn]
    ["symbol"
     (case ptrn
       [metavar? (list `unquote (list `quote ptrn))]
       [genvar? (list `unquote (list `quote ptrn))]
       [fullvar? (list `unquote (list `quote ptrn))]
       [_ ptrn])]
    ["list" ptrn
     (for i 1 (n ptrn) 1 (.<! ptrn i (pattern# (nth ptrn i))))
     ptrn]))

(defmacro pattern (ptrn)
  "Quote the provided pattern PTRN, suitable for matching with i
   [[matches?]].

   This provides several \"magic\" symbol prefixes to aid matching:

    - `?` marks a metavar, and will be captured. If the second character
      is `&`, then this will capture zero or more values.

    - `%` marks a genvar, which will result in a randomly generated
      symbol being used in substitutions.

    - `$` marks a fullvar, where one can provide the full name to a
      variable. Use of this is discouraged and should only be used if you
      really need to detect hidden symbols."
  (list `syntax-quote (pattern# ptrn)))

(defun match-impl (p e out)
  :hidden
  (or (= p e)
      (let [(ty-p (type p))
            (ty-e (type e))]
        (cond
          ;; Capture metavars
          [(and (= ty-p "symbol") (metavar? p))
           (.<! out (string/sub (symbol->string p) 2) e)
           true]

          ;; We're now onto normal matching, so let's make sure we're the
          ;; same type.
          [(/= ty-p ty-e) false]

          ;; If we have a variable, check it's the same. Otherwise check
          ;; for contents equality.
          [(= ty-p "symbol")
           (let [(var-p (symbol->var p))
                 (var-e (symbol->var e))]
             (cond
               [(fullvar? p)
                (and (/= var-e nil) (= (string/sub (symbol->string p) 2) (.> var-e :full-name)))]

               [(= var-p nil) (eq? p e)]
               [else (= var-p var-e)]))]

          [(= ty-p "string") (= (const-val p) (const-val e))]
          [(= ty-p "number") (= (const-val p) (const-val e))]
          [(= ty-p "key")    (eq? p e)]
          [(= ty-p "list")
           (let [(np (n p))
                 (ne (n e))]

             (and (<= np ne)
               (loop [(ip 1)
                      (ie 1)]
                 [(or (> ip np) (> ie ne)) true]
                 (with (ptrn (nth p ip))
                   (if (and (symbol? ptrn) (metavar? ptrn) (string/starts-with? (symbol->string ptrn) "?&"))
                     (with (end (+ ie (- ne np)))
                       (.<! out (string/sub (symbol->string ptrn) 3) (slice e ie end))
                       (recur (+ ip 1) (+ end 1)))

                     (and (match-impl ptrn (nth e ie) out) (recur (+ ip 1) (+ ie 1))))))))]))))

(defun match (ptrn expr)
  "Determine whether EXPR matches the provided pattern PTRN, returning
   nil or a lookup of capture names to captured expressions."
  (with (out {})
    (if (match-impl ptrn expr out) out nil)))

(defun matches? (ptrn expr)
  "Determine whether EXPR matches the provided pattern PTRN."
  (if (match-impl ptrn expr {}) true false))

(defmacro matcher (ptrn)
  "Create a matcher for the given pattern literal PTRN.

   This is intended for views [[case]] expressions."
  (with (expr (gensym))
    `(lambda (,expr) (match (pattern ,ptrn) ,expr))))

(defun match-always (ptrn expr)
  (with (out {})
    (match-impl ptrn expr)
    out))
