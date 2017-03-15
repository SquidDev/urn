(import base (defun let* type# if car cdr when
              and or >= = <= /= # get-idx defmacro for
              error gensym !))

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
  (or (= (type# x) "string")
      (and (= (type# x) "table")
           (= (get-idx x :tag) "string"))))

(defun number? (x)
  "Check whether X is a number."
  (or (= (type# x) "number")
      (and (= (type# x) "table")
           (= (get-idx x :tag) "number"))))

(defun symbol? (x)
  "Check whether X is a symbol."
  (= (type x) "symbol"))

(defun boolean? (x)
  "Check whether X is a boolean."
  (or (= (type# x) "boolean")
      (and (= (type# x) "table")
           (= (get-idx x :tag) "boolean"))))

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
  (or (/= (type# x) "table")
      (and (= (type# x) "table")
           (or (= (get-idx x :tag) "symbol")
               (= (get-idx x :tag) "key")))))

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
  (if (= x y)
    true
    (let* [(type-x (type x))
           (type-y (type y))]
      (cond
        [(and (= type-x :list) (= type-y :list) (= (# x) (# y)))
         (let* [(equal true)] ; be optimistic
           (for i 1 (# x) 1
             (when (neq? (get-idx x i) (get-idx y i)) (set! equal false)))
           equal)]
        [(and (= :symbol type-x) (= :symbol type-y)) (= (get-idx x :contents) (get-idx y :contents))]
        [(and (= :key type-x)    (= :key type-y))    (= (get-idx x :value) (get-idx y :value))]
        [(and (= :symbol type-x) (= :string type-y)) (= (get-idx x :contents) y)]
        [(and (= :string type-x) (= :symbol type-y)) (= x (get-idx y :contents))] 
        [(and (= :key type-x)    (= :string type-y)) (= (get-idx x :value) y)]
        [(and (= :string type-x) (= :key type-y))    (= x (get-idx y :value))] 
        [true false]))))

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
