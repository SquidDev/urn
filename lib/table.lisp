(import base (defmacro defun let* when if list unless gensym slice progn get-idx
              set-idx! error = /= % - + n or for for-pairs with ! apply else))
(import lua/string (sub))
(import lua/basic (getmetatable setmetatable next len#) :export)
(import type (empty? list? eq? key? assert-type!))
(import list ())
(import binders (let))

(defun assoc (list key or-val)
  "Return the value given by KEY in the association list LIST, or, in the
   case that it does not exist, the value OR-VAL, which can be nil.

   ### Example:
   ```cl
   > (assoc '((\"foo\" 1) (\"bar\" 2)) \"foo\" \"?\")
   out = 1
   > (assoc '((\"foo\" 1) (\"bar\" 2)) \"baz\" \"?\")
   out = \"?\"
   ```"
  (cond
    [(or (! (list? list))
         (empty? list))
     or-val]
    [(eq? (caar list) key)
     (cadar list)]
    [else (assoc (cdr list) key or-val)]))

(defun assoc? (list key)
  "Check that KEY is bound in the association list LIST.

   ### Example:
   ```cl
   > (assoc? '((\"foo\" 1) (\"bar\" 2)) \"foo\")
   out = true
   > (assoc? '((\"foo\" 1) (\"bar\" 2)) \"baz\")
   out = false
   ```"
  (cond
    [(or (! (list? list))
         (empty? list))
     false]
    [(eq? (caar list) key)
     true]
    [else (assoc? (cdr list) key)]))

(defun insert (alist key val)
  "Extend the association list ALIST by inserting VAL, bound to the key
   KEY.

   ### Example:
   ```cl
   > (insert '((\"foo\" 1)) \"bar\" 2)
   out = ((\"foo\" 1) (\"bar\" 2))
   ```"
  (snoc alist (list key val)))

(defun extend (ls key val)
  "Extend the association list LIST_ by inserting VAL, bound to the key
   KEY, overriding any previous value.

   ### Example:
   ```cl
   > (extend '((\"foo\" 1)) \"bar\" 2)
   out = ((\"bar\" 2) (\"foo\" 1))
   ```"
  (cons (list key val) ls))

(defun insert! (alist key val)
  "Extend the association list ALIST in place by inserting VAL, bound to
   the key KEY.

   ### Example:
   ```cl
   > (define x '((\"foo\" 1)))
   > (insert! x \"bar\" 2)
   > x
   out = ((\"foo\" 1) (\"bar\" 2))
   ```"
  (push-cdr! alist (list key val)))

(defun assoc->struct (list)
  "Convert the association list LIST into a structure. Much like
   [[assoc]], in the case there are several values bound to the same key,
   the first value is chosen.

   ### Example:
   ```cl
   > (assoc->struct '((\"a\" 1)))
   out = {\"a\" 1}
   ```"
  (assert-type! list list)
  (let [(ret {})]
    (for-each x list
      (let [(hd (cond
                  [(key? (car x)) (get-idx (car x) "value")]
                  [else (car x)]))]
        (if (! (get-idx ret hd))
          (set-idx! ret hd (cadr x))
          nil)))
    ret))

(defun struct->assoc (tbl)
  "Convert the structure TBL into an association list. Note that
   `(eq? x (struct->assoc (assoc->struct x)))` is not guaranteed,
   because duplicate elements will be removed.

   ### Example
   ```cl
   > (struct->assoc { :a 1 })
   out = ((\"a\" 1))
   ```"
  (with (out '())
    (for-pairs (k v) tbl
      (push-cdr! out (list k v)))
    out))

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
    `(set-idx! ,res ,(get-idx keys (n keys) 1) ,value)))

(defun struct (&entries)
  "Return the structure given by the list of pairs ENTRIES. Note that, in
   contrast to variations of [[let]], the pairs are given \"unpacked\":
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
  (when (= (% (n entries) 2) 1)
    (error "Expected an even number of arguments to struct" 2))
  (with (out {})
    (for i 1 (n entries) 2
      (let ((key (get-idx entries i))
            (val (get-idx entries (+ 1 i))))
        (set-idx! out (if (key? key) (get-idx key "value") key) val)))
    out))

(defun fast-struct (&entries)
  "A variation of [[struct]], which will not perform any coercing of the
   KEYS in entries.

   Note, if you know your values at compile time, it is more performant
   to use a struct literal."
  (when (= (% (n entries) 2) 1)
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
  (! (next xs)))

(defun nkeys (st)
  "Return the number of keys in the structure ST."
  (with (cnt 0)
    (for-pairs () st (set! cnt (+ cnt 1)))
    cnt))

(defun iter-pairs (table func)
  "Iterate over TABLE with a function FUNC of the form `(lambda (key val) ...)`"
  (for-pairs (k v) table (func k v)))

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
    (for-pairs (k _) st (push-cdr! out k))
    out))

(defun values (st)
  "Return the values in the structure ST."
  (with (out '())
    (for-pairs (_ v) st (push-cdr! out v))
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
