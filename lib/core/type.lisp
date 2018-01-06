(import core/base (defun let* with if and or not get-idx type# len# else
                   = <= >= /=))

(defun table? (x)
  "Check whether the value X is a table. This might be a structure,
   a list, an associative list, a quoted key, or a quoted symbol."
  (= (type# x) "table"))

(defun list? (x)
  "Check whether X is a list."
  (= (type x) "list"))

(defun empty? (x)
  "Check whether X is the empty list or the empty string."
  (let* [(xt (type x))]
    (cond
      [(= xt "list") (= (get-idx x :n) 0)]
      [(= xt "string") (= (len# x) 0)]
      [else false])))

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
  (or (= (type x) "function")
      ; HACK: We pretend that multimethods are functions.
      (= (type x) "multimethod")))

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
           (with (tag (get-idx x :tag))
             (or (= tag "symbol") (= tag "key") (= tag "number") (= tag "string"))))))

(defun falsey? (x)
  "Check whether X is falsey, that is, it is either `false` or does not
   exist."
  (not x))

(defun exists? (x)
  "Check if X exists, i.e. it is not the special value `nil`.
   Note that, in Urn, `nil` is not the empty list."
  (not (= (type# x) "nil")))

(defun nil? (x)
  "Check if X does not exist, i.e. it is the special value `nil`.
   Note that, in Urn, `nil` is not the empty list."
  (= (type# x) "nil"))

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
