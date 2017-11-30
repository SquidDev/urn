"Various functions for creating and manipulating types.

 The Urn type system is composed of the following types:

  - Fixed types (any, none, number, string, boolean, nil)
  - Constants (1, 2, \"foo\", \"bar\", ...)
  - Type variables (a, b, c, ...)
  - Functions ((a, b, c) -> d, ...)
  - Unions (a | b | c, ...)
  - Intersections (a & b & c, ...). Note that this is mainly an
    intermediate representation which will be removed once types are
    finalised.

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
  (assert-type! types list)
  (let* [(primary '())
         (tyvars {})
         (has-any false)]

    ;; First build our primary list of types and type variables, flattening
    ;; unions where appropriate.
    (for-each type types
      (case type
        [tyvar? (.<! tyvars type true)]
        [(union ?tys ?tvs)
         (for-each ty tys
           (when (eq? ty 'any) (set! has-any true))
           (push-cdr! primary ty))
         (for-each tv tvs (.<! tyvars type true))]
        [?ty
         (when (eq? ty 'any) (set! has-any true))
         (push-cdr! primary ty)]))

    (cond
      ;; If we've got some any then just skip everything and return. We
      ;; don't even need to care about type variables as they'll be
      ;; overshadowed.
      [has-any 'any]
      [else
       (loop [(i 1)] [(> i (n primary))]
         (for j (n primary) 1 -1
           (when (and (/= i j) (subtype? (nth primary j) (nth primary i)))
             ;; If it's a subtype then remove it
             (remove-nth! primary j)
             ;; If this appeared before us then shift our counter back by 1.
             (when (< j i) (dec! i))))
         (recur (succ i)))

       (cond
         [(or (> (n primary) 1) (not (empty-struct? tyvars)))
          ~(union ,primary ,tyvars)]
         [(= (n primary) 1) (car primary)]
         [else 'none])])))

(defun intersection-of (types)
  "Create the intersection of two types. Namely create a type which is a
   subtype of both."
  (assert-type! types list)
  (let [(main 'any)
        (primary '())
        (tyvars {})]

    ;; First build our primary list of types and type variables, flattening
    ;; intersections where appropriate.
    (for-each type types
      (case type
        [tyvar? (.<! tyvars type true)]
        [(intersection ?tys ?tvs)
         (for-each ty tys
           (with (isect (atom-intersection main ty))
             (if (/= isect nil)
               (set! main isect)
               (push-cdr! primary ty))))
         (for-each tv tvs (.<! tyvars type true))]
        [?ty
         (with (isect (atom-intersection main ty))
           (if (/= isect nil)
             (set! main isect)
             (push-cdr! primary ty)))]))

    (cond
      ;; If main is 'none then give up here: nothing we do will be able
      ;; to change it.
      [(eq? main 'none) main]
      ;; Otherwise attempt to filter types a little. The main
      ;; intersecting will have to be done another time.
      [else
       (push-cdr! primary main)
       (loop [(i 1)] [(> i (n primary))]
         (for j (n primary) 1 -1
           (when (and (/= i j) (subtype? (nth primary i) (nth primary j)))
             ;; If we're a subtype then remove it
             (remove-nth! primary j)
             ;; If this appeared before us then shift our counter back by 1.
             (when (< j i) (dec! i))))
         (recur (succ i)))

       (cond
         [(or (> (n primary) 1) (not (empty-struct? tyvars)))
          ~(intersection ,primary ,tyvars)]
         [(= (n primary) 1) (car primary)]
         [else 'any])])))

(defun atom-intersection (a b)
  "Attempts to intersect A and B, returning `false` if the types are too
   complex."
  :hidden
  (case (list a b)
    ;; Basic cases
    [((?a ?b) :when (eq? a b)) a]
    [(_ any) a]  [(any _) b]
    [(none _) a] [(_ none) b]
    ;; Constants
    [(number? number) a]   [(number number?) b]
    [(string? string) a]   [(string string?) b]
    [(boolean? boolean) a] [(boolean boolean?) b]
    ;; Catches things like string & number, 1 & 2
    [(atom? atom?) 'none]
    ;; One cannot intersect atoms with functions
    [(atom? (-> _ _)) 'none] [((-> _ _) atom?) 'none]
    ;; TODO: intersect unions with no variables, functions, etc...
    ;; Just give up on everything else.
    [else
     nil]))

(defun pretty-ty (type precedence)
  "Format the provided TYPE."
  (if (= precedence nil)
    (set! precedence 100)
    (assert-type! precedence number))

  (case type
    [atom? (pretty type)]
    [tyvar? (pretty type)]

    [(-> ?args ?ret)
     (string/format "%s(%s) -> %s%s"
                    (if (<= precedence 1) "(" "")
                    (concat (map (cut pretty-ty <> 1) args) " ")
                    (pretty-ty ret 1)
                    (if (<= precedence 1) ")" ""))]

    [(union ?tys ?vars)
     (string/format "%s%s%s"
                    (if (<= precedence 2) "(" "")
                    (concat (map (cut pretty-ty <> 2) (append tys (keys vars))) " | ")
                    (if (<= precedence 2) ")" ""))]

    [(intersection ?tys ?vars)
     (string/format "%s%s%s"
                    (if (<= precedence 2) "(" "")
                    (concat (map (cut pretty-ty <> 2) (append tys (keys vars))) " & ")
                    (if (<= precedence 2) ")" ""))]))

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
        [(and (list? constraint) (eq? (car constraint) 'and))
         (for i 2 (n constraint) 1 (push-cdr! out (nth constraint i)))]
        ;; Otherwise just append it to the list
        [else
         (push-cdr! out constraint)]))
    (case (n out)
      [1 empty-constraint]
      [2 (cadr out)]
      [_ out])))
