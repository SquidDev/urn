(import base (defun let* type# if car cdr when
              and or >= = <= /= # get-idx defmacro
              error gensym ! debug))

(import lua/string (format sub))

(defun table? (x)
  "Check whether the value X is a table. This might be a structure,
   a list, an associative list, a quoted key, or a quoted symbol."
  (= (type# x) "table"))

(defun list? (x)
  "Check whether X is a list."
  (= (type x) "list"))

(defun nil? (x)
  "Check whether X is the empty list."
  (and x (list? x) (= (# x) 0)))

(defun string? (x)
  "Check whether X is a string."
  (= (type x) "string"))

(defun number? (x)
  "Check whether X is a number."
  (= (type x) "number"))

(defun symbol? (x)
  "Check whether X is a symbol."
  (= (type x) "symbol"))

(defun boolean? (x)
  "Check whether X is a boolean."
  (= (type x) "boolean"))

(defun function? (x)
  "Check whether X is a function."
  (= (type x) "function"))

(defun key? (x)
  "Check whether X is a key."
  (= (type x) "key"))

(defun atom? (x)
  "Check whether X is an atomic object, that is, one of
   - A boolean
   - A string
   - A number
   - A symbol
   - A key
   - A function"
  (or (boolean? x)
      (string? x)
      (number? x)
      (symbol? x)
      (function? x)
      (key? x)))

(defun falsey? (x)
  "Check whether X is falsey, that is, it is either `false` or does
   not exist."
  (! x))

(defun exists? (x)
  "Check if X exists, i.e. it is not the special value `nil`.
   Note that, in Urn, `nil` is not the empty list."
  (! (= (type# x) "nil")))

(defun between? (val min max)
  "Check if the numerical value X is between
   MIN and MAX."
  (and (>= val min) (<= val max)))

(defun type (val)
  "Return the type of VAL."
  (let* [(ty (type# val))]
    (if (= ty "table")
      (let* [(tag (get-idx val "tag"))]
        (if tag tag "table"))
      ty)))

(defun eq? (x y)
  "Compare X and Y for equality deeply.
   Rules:
   - If X and Y exist, X and Y are equal if:
     - If X or Y are a symbol
       - Both are symbols, and their contents are equal.
       - X is a symbol, and Y is a string equal to the symbol's contents.
       - Y is a symbol, and X is a string equal to the symbol's contents.
     - If X or Y are a key
       - Both are keys, and their values are equal.
       - X is a key, and Y is a string equal to the key's contents.
       - Y is a key, and X is a string equal to the key's contents.
     - If X or Y are lists
       - Both are empty.
       - Both have the same length, their `car`s are equal, and their `cdr`s
         are equal.
     - Otherwise, X and Y are equal if they are the same value.
   - If X or Y do not exist
     - They are not equal if one exists and the other does not.
     - They are equal if neither exists.  "
  (cond
    [(and (exists? x) (exists? y))
     (cond
       [(or (or (string? x) (number? x) (boolean? x) (string? x) (nil? x))
            (or (string? y) (number? y) (boolean? y) (string? y) (nil? y)))
        (= x y)]
       [(and (symbol? x) (symbol? y))
        (= (get-idx x "contents") (get-idx y "contents"))]
       [(and (symbol? x) (string? y))
        (= (get-idx x "contents") y)]
       [(and (string? x) (symbol? y))
        (= (get-idx y "contents") x)]
       [(and (key? x) (key? y))
        (= (get-idx x "value") (get-idx y "value"))]
       [(and (key? x) (string? y))
        (= (get-idx x "value") y)]
       [(and (string? x) (key? y))
        (= (get-idx y "value") x)]
       [(and (list? x) (list? y))
        (and (eq? (car x) (car y))
             (eq? (cdr x) (cdr y)))])]
    [(and (exists? x) (! (exists? y))) false]
    [(and (exists? y) (! (exists? x))) false]
    [true (and (! x) (! y))]))

(defun neq? (x y)
  "Compare X and Y for inequality deeply. X and Y are `neq?`
   if `([[eq?]] x y)` is falsey."
  (! (eq? x y)))

(defmacro assert-type! (arg ty)
  "Assert that the argument ARG has type TY, as reported by the function
   [[type]]."
  (let* [(sym (gensym))
         (ty (get-idx ty "contents"))]
    `(let* [(,sym (type ,arg))]
      (when (/= ,sym ,ty)
        (error (format "bad argment %s (expected %s, got %s)" ,(get-idx arg "contents") ,ty ,sym) 2)))))
