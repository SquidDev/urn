"Various functions for creating and manipulating types.

 The Urn type system is composed of the following types:

  - Fixed types (any, none, number, string, boolean, nil)
  - Constants (1, 2, \"foo\", \"bar\", ...)
  - Type variables (a, b, c, ...)
  - Functions ((a, b, c) -> d, ...)
  - Unions (a | b | c, ...)

 The following subtyping rules apply:

  - _ <: any
  - none <: _
  - 1 <: number
  - (a) -> c <: (a, b) -> c
  - (a) -> b <: (c) -> d <=> c <: a, b <: d
  - a | b <: c <=> a <: c, b <: c
  - a <: b | c <=> a <: b | a <: c"

(import data/struct ())

(defstruct (tyvar tyvar tyvar?)
  "A type variable."
  (fields
    (immutable name (hide tyvar-name)))
  (constructor new
    (lambda (name)
      (assert-type! name string)
      (new name))))

(defmethod (pretty tyvar) (x)
  (.. "?" (tyvar-name x)))

(defun fresh-provider ()
  "Create a new fresh variable provider."
  (with (count 0)
    (lambda (name)
      (inc! count)
      (tyvar (string/format "%s#%d"
                            (case name
                              [nil "fresh"]
                              [symbol? (symbol->string name)]
                              [string? name])
                            count)))))

(defun subtype? (left right)
  "Determine whether LEFT is a subtype of RIGHT. Namely LEFT can be used
   wherever RIGHT is required."
  (case (list left right)
    ;; Basic cases
    [((?a ?b) :when (eq? a b)) true]
    [(_ any) true]
    [(none _) true]
    ;; Constants
    [(number? number) true]
    [(string? string) true]
    [(boolean? boolean) true]
    ;; TODO: Union, list, structs
    ;; Functions
    [((-> ?argl ?retl) (-> ?argr ?retr))
     (and (<= (n argl) (n argr))
          (subtype? retl retr)
          (all id (map subtype? argr argl)))]
    [_ false]))

(defun union-of (types)
  "Create a union of TYPES."
  (let* [(out '(union))]
    (loop [(types types)
           (i 1)
           (len (n types))]
      [(> i len) (if (= (n out) 2) (cadr out) out)]
      (case (nth types i)
        ;; If we're any then that will mask anything else
        [any 'any]
        ;; If we're another union then push to our list and continue
        [(union . ?rest)
         (recur (append types rest) (succ i) (+ len (n rest)))]
        [?ty
         (loop [(j (n out))]
           [(< j 2) (push-cdr! out ty)]
           (with (other (nth out j))
             (cond
               ;; If this is a subtype of us then overwrite that
               [(subtype? other ty) (.<! out j ty)]
               ;; If we're a subtype of them then skip
               [(subtype? ty other)]
               ;; Otherwise continue
               [else (recur (pred j))])))
         (recur types (succ i) len)]))))

(defun intersection-of (a b)
  "Create the intersection of two types. Namely create a type which is a
   subtype of both."
  (case (list a b)
    ;; Basic cases
    [((?a ?b) :when (eq? a b)) a]
    [(_ any) a]  [(any _) b]
    [(none _) a] [(_ none) b]
    ;; Constants
    [(number? number) a]   [(number number?) b]
    [(string? string) a]   [(string string?) b]
    [(boolean? boolean) a] [(boolean boolean?) b]
    ;; Cannot handle type variables, error
    [(tyvar? _) (format 1 "(intersection-of {#a} {#b}): cannot intersect tyvar")]
    [(_ tyvar?) (format 1 "(intersection-of {#a} {#b}): cannot intersect tyvar")]

    ;; TODO: Union, list, structs
    ;; Functions
    [((-> ?arga ?reta) (-> ?argb ?retb))
     (list '->
           (map (lambda (a b) (union-of (list a b))) arga argb)
           (intersection-of reta retb))]
    [_ 'none]))

(define empty-constraint
  "A constraint which enforces nothing."
  'empty)

(defun and-constraints (constraints)
  "And together a list of CONSTRAINTS, reducing them to the simplest
   form."
  (with (out '(and))
    (for-each constraint constraints
      (cond
        ;; Skip things equal to the empty constraint
        [(= constraint empty-constraint)]
        ;; Flatten ands
        [(and (list? constraint) (eq? car 'and))
         (for i 2 (n constraint) 1 (push-cdr! out (nth constraint i)))]
        ;; Otherwise just append it to the list
        [else
         (push-cdr! out constraint)]))
    (case (n out)
      [1 empty-constraint]
      [2 (cadr out)]
      [_ out])))
