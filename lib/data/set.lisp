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

(defun union (&sets)
  "The set of values that occur in any set in the SETS.

   ### Example:
   ```cl
   > (union (set-of 1 2 3) (set-of 4 5 6))
   out = «hash-set: 1 2 3 4 5 6»
   > (union (set-of 1 2) (set-of 2 3) (set-of 3 4))
   out = «hash-set: 1 2 3 4»
   ```"
  (when (empty? sets)
    (format 1 "(union): can't take the union of no sets"))
  (let* [(out (make-set (hashset-fn (car sets))))
         (fn (hashset-fn (car sets)))]
    (do [(set sets)]
      (assert-type! set set)
      (unless (= (hashset-fn set) fn)
        (format 1 "(union {@( )}): set '{}' does not have same hash function as the other sets" sets set))
      (for-pairs (k v) (hashset-data set)
        (insert! out v)))
    out))

(defun intersection (&sets)
  "The set of values that occur in all the SETS.

   ### Example:
   ```cl
   > (intersection (set-of 1 2 3) (set-of 3 4 5))
   out = «hash-set: 3»
   > (intersection (set-of 1 2 3) (set-of 3 4 5) (set-of 7 8 9))
   out = «hash-set: »
   ```"
  (letrec [(pairwise-intersection (lambda (a b)
             (assert-type! a set)
             (assert-type! b set)
             (unless (= (hashset-fn a) (hashset-fn b))
               (format 1 "(intersection {}): {#a} and {#b} do not have the same hash function." sets))
             (let* [(out (make-set (hashset-fn a)))]
               (for-pairs (k v) (hashset-data a)
                 (when (.> (hashset-data b) k)
                   (.<! (hashset-data out) k v)))
               out)))
           (inter (lambda (&sets)
                    (case sets
                      [(?x) x]
                      [(?x ?y) (pairwise-intersection x y)]
                      [(?x ?y . ?xs) (apply inter (pairwise-intersection x y) xs)])))]
    (map (lambda (x)
           (unless (set? x)
             (format 1 "(intersection {}): '{}' is not a set" sets x)))
         sets)
    (apply inter sets)))

(defun cardinality (set)
  "Return the number of elements in SET.

   ### Example:
   ```cl
   > (cardinality (set-of 1 2 3))
   out = 3
   > (cardinality (set-of 1 1 2))
   out = 2
   ```"
  (let* [(out 0)]
    (for-pairs (_ _) (hashset-data set)
      (inc! out))
    out))

(defun disjoint? (&sets)
  "Is the intersection of SETS empty?

   ### Example:
   ```cl
   > (disjoint? (set-of 1 2 3) (set-of 3 4 5))
   out = false
   > (disjoint? (set-of 1 2 3) (set-of 4 5 6))
   out = true
   ```"
  (= (cardinality (apply intersection sets)) 0))

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
      (push! out v))
    out))

(defmethod (pretty set) (x)
  (.. "«hash-set: " (concat (map pretty (set->list x)) " ") "»"))
