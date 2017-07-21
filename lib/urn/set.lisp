"Hash sets
 =========

 This module implements hash sets as backed by hash maps, optionally
 with a custom hash function."

(defun make-set (hash-function)
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
  (let* [(hash (or hash-function id))]
    (setmetatable
      { :tag "set"
        :hash hash
        :data {} }
      *set-metatable*)))

(define *set-metatable* :hidden
  { :--pretty-print (lambda (x)
                      (.. "«hash-set: " (concat (map pretty (set->list x)) " ") "»"))
    :compare (lambda (x y)
               (let* [(same-data true)]
                 (for-pairs (k _) (.> y :data)
                   (when (= (.> x :data k) nil)
                     (set! same-data false)))
                 (and (= (.> x :hash)
                         (.> y :hash))
                      same-data))) })

(defun set? (x)
  "Check that X is a set.

   ### Example
   ```cl
   > (set? (set-of 1 2 3))
   out = true
   > (set? '(1 2 3))
   out = false
   ```"
  (and (table? x)
       (= (.> x :tag) :set)
       (function? (.> x :hash))))

(defun element? (set val)
  "Check if VAL is an element of SET.

   ### Example:
   ```cl
   > (element? (set-of 1 2 3) 1)
   out = true
   ```"
  (assert-type! set set)
  (let* [(hash (.> set :hash))]
    (/= (.> set :data (hash val)) nil)))

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
  (let* [(hash (.> set :hash))]
    (map (lambda (v)
           (.<! set :data (hash v) v))
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
  (let* [(hash (.> set :hash))
         (out (make-set hash))]
    (map (lambda (v)
           (.<! out :data (hash v) v))
         vals)
    out))

(defun union (a b)
  "The set of values that occur in either A or B.

   ### Example:
   ```cl
   > (union (set-of 1 2 3) (set-of 4 5 6))
   out = «hash-set 1 2 3 4 5 6»
   ```"
  (assert-type! a set)
  (assert-type! b set)
  (unless (= (.> a :hash) (.> b :hash))
    (error! $"union: ~{a} and ~{b} do not have the same hash function."))
  (let* [(out (make-set (.> a :hash)))]
    (for-pairs (k v) (.> a :data)
      (.<! out :data k v))
    (for-pairs (k v) (.> b :data)
      (.<! out :data k v))
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
  (unless (= (.> a :hash) (.> b :hash))
    (error! $"intersection: ~{a} and ~{b} do not have the same hash function."))
  (let* [(out (make-set (.> a :hash)))]
    (for-pairs (k v) (.> a :data)
      (when (.> b :data k)
        (.<! out :data k v)))
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
    (for-pairs (k v) (.> set :data)
      (push-cdr! out v))
    out))
