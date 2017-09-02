"This module implements hash sets as backed by hash maps, optionally
 with a custom hash function."

(import data/struct ())

(defstruct (set make-set set?)
  "Create a new, empty set with the given HASH-FUNCTION. If no
   hash function is given, [[make-set]] defaults to using object
   identity, that is, [[id]].

   **Note**: Comparison for sets also compares their hash function
   with pointer equality, meaning that sets will only compare equal
   if their hash function is _the same object_.

   ### Example
   ```
   > (make-set id)
   out = «hash-set: »
   ```"
  (fields
    (immutable hash-function (hide hashset-fn))
    (immutable data (hide hashset-data)))
  (constructor new
    (lambda ((hash id))
      (new hash {}))))

(defmethod (eq? set set) (x y)
  (let* [(same-data true)]
    (for-pairs (k _) (hashset-data y)
               (when (= (.> (hashset-data x) k) nil)
                 (set! same-data false)))
    (and (= (hashset-fn x)
            (hashset-fn y))
         same-data)))

(defun element? (set val)
  "Check if VAL is an element of SET.

   ### Example:
   ```cl
   > (element? (set-of 1 2 3) 1)
   out = true
   ```"
  (assert-type! set set)
  (let* [(hash (hashset-fn set))]
    (/= (.> (hashset-data set) (hash val)) nil)))

(defun insert! (set &vals)
  "Insert VALS into SET.

   ### Example
   ```cl
   > (define set (set-of 1 2 3))
   out = «hash-set: 1 2 3»
   > (insert! set 4)
   out = «hash-set: 1 2 3 4»
   > set
   out = «hash-set: 1 2 3 4»
   ```"
  (assert-type! set set)
  (let* [(hash (hashset-fn set))]
    (map (lambda (v)
           (.<! (hashset-data set) (hash v) v))
         vals))
  set)

(defun insert (set &vals)
  "Build a copy of SET with VALs inserted.

   ### Example
   ```cl
   > (insert (set-of 1 2 3) 4 5 6)
   out = «hash-set: 1 2 3 4 5 6»
   ```"
  (assert-type! set set)
  (let* [(hash (hashset-fn set))
         (out (make-set hash))]
    (for-pairs (k v) (hashset-data set)
      (.<! (hashset-data out) k v))
    (for-each v vals
      (.<! (hashset-data out) (hash v) v))
    out))

(defun union (a b)
  "The set of values that occur in either A or B.

   ### Example:
   ```cl
   > (union (set-of 1 2 3) (set-of 4 5 6))
   out = «hash-set: 1 2 3 4 5 6»
   ```"
  (assert-type! a set)
  (assert-type! b set)
  (unless (= (hashset-fn a) (hashset-fn b))
    (format 1 "union: {#a} and {#b} do not have the same hash function."))
  (let* [(out (make-set (hashset-fn a)))]
    (for-pairs (k v) (hashset-data a)
      (.<! (hashset-data out) k v))
    (for-pairs (k v) (hashset-data b)
      (.<! (hashset-data out) k v))
    out))

(defun intersection (a b)
  "The set of values that occur in both A and B.

   ### Example:
   ```cl
   > (intersection (set-of 1 2 3) (set-of 3 4 5))
   out = «hash-set: 3»
   ```"
  (assert-type! a set)
  (assert-type! b set)
  (unless (= (hashset-fn a) (hashset-fn b))
    (format 1 "intersection: {#a} and {#b} do not have the same hash function."))
  (let* [(out (make-set (hashset-fn a)))]
    (for-pairs (k v) (hashset-data a)
      (when (.> (hashset-data b) k)
        (.<! (hashset-data out) k v)))
    out))

(defun set-of (&values)
  "Create the set containing VALUES with the default hash function.

   ### Example:
   ```cl
   > (set-of 1 2 3)
   out = «hash-set: 1 2 3»
   ```"
  (let* [(out (make-set))]
    (map (cut insert! out <>) values)
    out))

(defun set->list (set)
  "Convert SET to a list. Note that, since hash sets have no specified
   order, the list will not nescessarily be sorted."
  (assert-type! set set)
  (let* [(out '())]
    (for-pairs (_ v) (hashset-data set)
      (push-cdr! out v))
    out))

(defmethod (pretty set) (x)
  (.. "«hash-set: " (concat (map pretty (set->list x)) " ") "»"))
