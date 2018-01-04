(import core/prelude ())

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
    [(or (not (list? list))
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
    [(or (not (list? list)) (empty? list)) false]
    [(eq? (caar list) key) true]
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
  (push! alist (list key val)))

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
                  [(key? (car x)) (.> (car x) "value")]
                  [else (car x)]))]
        (unless (.> ret hd)
          (.<! ret hd (cadr x)))))
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
      (push! out (list k v)))
    out))
