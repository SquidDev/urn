(import core/base (defmacro defun let* when if list unless gensym slice progn get-idx
              set-idx! error = /= mod - + n or for for-pairs with not apply else))
(import lua/basic (next len#) :export)
(import core/demand (assert-type!))
(import core/list ())
(import core/type (key?))

(defun struct->list (tbl)
  "Converts a structure TBL that is a list by having its keys be indices
   to a regular list.

   ### Example
   ```cl
   > (struct->list { 1 \"foo\" 2 \"bar\" })
   out = (\"foo\" \"bar\")
   ```"
  (update-struct tbl :tag "list"
                     :n   (len# tbl)))

(defun struct->list! (tbl)
  "Converts a structure TBL that is a list by having its keys be indices
   to a regular list. This differs from `struct->list` in that it mutates
   its argument.
   ### Example
   ```cl
   > (struct->list! { 1 \"foo\" 2 \"bar\" })
   out = (\"foo\" \"bar\")
   ```"
  (.<! tbl :tag "list")
  (.<! tbl :n (len# tbl))
  tbl)

(defun list->struct (list)
  "Converts a LIST to a structure, mapping an index to the element in the
   list. Note that `nil` elements may not be mapped correctly.

   ### Example
   ```cl
   > (list->struct '(\"foo\"))
   out = {1 \"foo\"}
   ```"
  (assert-type! list list)
  (with (out {})
    (for i 1 (n list) 1
      (set-idx! out i (nth list i)))
    out))

;; Chain a series of index accesses together
(defmacro .> (x &keys)
  "Index the structure X with the sequence of accesses given by KEYS."
  (with (res x)
    (for-each key keys (set! res `(get-idx ,res ,key)))
    res))

(defmacro .<! (x &keys value)
  "Set the value at KEYS in the structure X to VALUE."
  (with (res x)
    (for i 1 (- (n keys) 1) 1
      (with (key (get-idx keys i))
        (set! res `(get-idx ,res ,key))))
    `(set-idx! ,res ,(get-idx keys (n keys)) ,value)))

(defun struct (&entries)
  "Return the structure given by the list of pairs ENTRIES. Note that, in
   contrast to variations of [[let*]], the pairs are given \"unpacked\":
   Instead of invoking

   ```cl :no-test
   (struct [(:foo bar)])
   ```
   or
   ```cl :no-test
   (struct {:foo bar})
   ```
   you must instead invoke it like
   ```cl
   > (struct :foo \"bar\")
   out = {\"foo\" \"bar\"}
   ```"
  (when (= (mod (n entries) 2) 1)
    (error "Expected an even number of arguments to struct" 2))
  (with (out {})
    (for i 1 (n entries) 2
      (let* [(key (get-idx entries i))
             (val (get-idx entries (+ 1 i)))]
        (set-idx! out (if (key? key) (get-idx key "value") key) val)))
    out))

(defun fast-struct (&entries)
  "A variation of [[struct]], which will not perform any coercing of the
   KEYS in entries.

   Note, if you know your values at compile time, it is more performant
   to use a struct literal."
  (when (= (mod (n entries) 2) 1)
    (error "Expected an even number of arguments to struct" 2))
  (with (out {})
    (for i 1 (n entries) 2
      (set-idx! out (get-idx entries i) (get-idx entries (+ i 1))))
    out))

(defun empty-struct? (xs)
  "Check that XS is the empty struct.

   ### Example
   ```cl
   > (empty-struct? {})
   out = true
   > (empty-struct? { :a 1 })
   out = false
   ```"
  (not (next xs)))

(defun nkeys (st)
  "Return the number of keys in the structure ST."
  (with (cnt 0)
    (for-pairs () st (set! cnt (+ cnt 1)))
    cnt))

(defun iter-pairs (table func)
  "Iterate over TABLE with a function FUNC of the form `(lambda (key val) ...)`"
  (for-pairs (k v) table (func k v)))

(defun copy-of (struct)
  "Create a shallow copy of STRUCT."
  (with (out {})
    (for-pairs (k v) struct (.<! out k v))
    out))

(defun merge (&structs)
  "Merge all tables in STRUCTS together into a new table."
  (with (out {})
    (for-each st structs
      (for-pairs (k v) st
        (.<! out k v)))
    out))

(defun keys (st)
  "Return the keys in the structure ST."
  (with (out '())
    (for-pairs (k _) st (push! out k))
    out))

(defun values (st)
  "Return the values in the structure ST."
  (with (out '())
    (for-pairs (_ v) st (push! out v))
    out))

(defun update-struct (st &keys)
  "Create a new structure based of ST, setting the values given by the
   pairs in KEYS."
  (merge st (apply struct keys)))

(defun create-lookup (values)
  "Convert VALUES into a lookup table, with each value being converted to
   a key whose corresponding value is the value's index."
  (with (res {})
    (for i 1 (n values) 1 (.<! res (nth values i) i))
    res))
