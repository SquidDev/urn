"Implements the constraint solver for success typing."

(import plugins/success/types ())
(import plugins/success/infer ())

(import compiler/nodes ())
(import compiler/resolve ())

(import data/struct ())

(defstruct (solution solution solution?)
  "Represents a work in progress solution to a set of constraints."
  (fields
    (immutable (hide vars)
      "All type variables in this solution."))
  (constructor new
    (lambda () (new {}))))

(defmethod (pretty solution) (sol)
  (.. "{ " (concat (map pretty (values (solution-vars sol))) "\n  ") " }"))

(defstruct (solution-var solution-var solution-var?)
  (fields
    (immutable (hide var)
      "The type variable for this solution-var")
    (mutable (hide lower)
      "Represents the most specific type this variable can take. Namely
       lt <: X. This starts as none and becomes less specific.")
    (immutable (hide lower-vars)
      "Variables which are a subtype of this one.")
    (mutable (hide upper)
      "Represents the least specific type this variable can take. Namely X
       <: gt. This starts as any and becomes more specific.")
    (immutable (hide upper-vars)
      "Variables which are a super type of this one."))

  (constructor new
    (lambda (var) (new var 'none {} 'any {}))))

(defmethod (pretty solution-var) (var)
  (string/format "%s[%s] <: %s <: %s[%s]"
                 (pretty (solution-var-lower var))
                 (concat (map (compose pretty solution-var-var) (keys (solution-var-lower-vars var))) " ")
                 (pretty (solution-var-var var))
                 (pretty (solution-var-upper var))
                 (concat (map (compose pretty solution-var-var) (keys (solution-var-upper-vars var))) " ")))

(defun define-var! (solution var)
  "Add a new tyvar to a SOLUTION set."
  (assert-type! solution solution)
  (assert-type! var tyvar)
  (with (svar (solution-var var))
    (.<! (solution-vars solution) var svar)
    svar))

(defun lookup-var (solution var)
  "Lookup the provided type variable VAR in the given SOLUTION."
  (assert-type! solution solution)
  (assert-type! var tyvar)

  (with (svar (.> (solution-vars solution) var))
    (when (= svar nil)
      (set! svar (define-var! solution var)))
    svar))

(defun constrain-pair! (solution sleft sright)
  "Constrain solution variables SLEFT and SRIGHT so that SLEFT <:
   SRIGHT.

   Note that this does **not** set up the various transitive properties
   required."
  :hidden
  (assert-type! solution solution)
  (assert-type! sleft solution-var)
  (assert-type! sleft solution-var)
  (let* [(uppers (solution-var-upper-vars sleft))
         (lowers (solution-var-lower-vars sright))
         (changed (and (/= sleft sright) (= (.> uppers sright) nil)))]
    (when changed
      (.<! uppers sright true)
      (.<! lowers sleft true)

      (constrain-upper! solution sleft (solution-var-upper sright))
      (constrain-lower! solution sright (solution-var-lower sleft)))

    changed))

(defun constrain-lower! (solution svar ty)
  "Add the provided type TY to the lower set of the solution variable
   SVAR. Namely, ensure TY <: SVAR.

   Note that this does **not** propagate the transitive property: one
   should do that oneself."
  :hidden
  (assert-type! solution solution)
  (assert-type! svar solution-var)
  (let* [(existing (solution-var-lower svar))
         (bounded (union-of (list existing ty)))
         (changed (neq? existing bounded))]

    (when changed
      (set-solution-var-lower! svar bounded)
      (constrain! solution (solution-var-lower svar) (solution-var-upper svar)))
    changed))

(defun constrain-upper! (solution svar ty)
  "Add the provided type TY to the upper set of the solution variable
   SVAR. Namely, ensure SVAR <: TY.

   Note that this does **not** propagate the transitive property: one
   should do that oneself."
  :hidden
  (assert-type! solution solution)
  (assert-type! svar solution-var)
  (let* [(existing (solution-var-upper svar))
         (bounded (intersection-of (list existing ty)))
         (changed (neq? existing bounded))]

    (when changed
      (set-solution-var-upper! svar bounded)
      (constrain! solution (solution-var-lower svar) (solution-var-upper svar)))
    changed))

(defun constrain! (solution left right)
  "Constraint LEFT <: RIGHT."
  (assert-type! solution solution)
  (case (list left right)
    ;; Basic cases
    [((?a ?b) :when (eq? a b))]
    [(_ any)]
    [(none _)]
    ;; Constants
    [(number? number)]
    [(string? string)]
    [(boolean? boolean)]

    ;; Type variables
    [(tyvar? tyvar?)
     (let [(sleft (lookup-var solution left))
           (sright (lookup-var solution right))]

       (when (constrain-pair! solution sleft sright)
         (for-pairs (child _) (solution-var-lower-vars sleft)
           (constrain-pair! solution child sright))
         (for-pairs (child _) (solution-var-upper-vars sright)
           (constrain-pair! solution sleft child))))]

    [(tyvar? _)
     (with (sleft (lookup-var solution left))
       (when (constrain-upper! solution sleft right)
         (for-pairs (child _) (solution-var-lower-vars sleft)
           (constrain-upper! solution child right))))]

    [(_ tyvar?)
     (with (sright (lookup-var solution right))
       (when (constrain-lower! solution sright left)
         (for-pairs (child _) (solution-var-upper-vars sright)
           (constrain-lower! solution child left))))]

    [((-> ?argl ?retl) (-> ?argr ?retr))
     (when (> (n argl) (n argr))
       (format 1 "Failed to convert {#left} to {#right}: more arguments required than accepted."))

     (constrain! solution retl retr)
     (for i 1 (n argl) 1
       (constrain! solution (nth argr i) (nth argl i)))]

    ;; x <: a & b <=> x <: a, x <: b
    [(?left (intersection ?rtypes ?rvars))
     (for-each ty rtypes (constrain! solution left ty))
     (for-pairs (tv ) rvars (constrain! solution left tv))]

    ;; a | b <: x <=> a <: x, b <: x
    [((union ?rtypes ?rvars) ?right)
     (for-each ty rtypes (constrain! solution ty right))
     (for-pairs (tv ) rvars (constrain! solution tv right))]

    [else
     (format 1 "Failed to convert {#left} to {#right}")]))

(defun apply-constraint! (solution constraint)
  (assert-type! solution solution)
  (case constraint
    [(= ?a ?b)
     (constrain! solution a b)
     (constrain! solution b a)]
    [(<= ?a ?b) (constrain! solution a b)]
    [(and . _)
     (for i 2 (n constraint) 1
       (apply-constraint! solution (nth constraint i)))]))

(defun subst (solution ty)
  "Substitute the variables provided by SOLUTION back into TY."
  (case ty
    [tyvar?
     (subst solution (solution-var-upper (lookup-var solution ty)))]

    [(-> ?args ?ret)
     (list '->
           (map (cut subst solution <>) args)
           (subst solution ret))]

    [(union ?tys ?tvs)
     (with (res '())
       (for-each ty tys (push-cdr! res (subst solution ty)))
       (for-pairs (tv _) tvs (push-cdr! res (subst solution tv)))
       (union-of res))]

    [(intersection ?tys ?tvs)
     (with (res '())
       (for-each ty tys (push-cdr! res (subst solution ty)))
       (for-pairs (tv _) tvs (push-cdr! res (subst solution tv)))
       (intersection-of res))]

    [_ ty]))

(defun test-func (f x y)
  (+ (f x) (f y)))
;; (defun test-func (f x)
;;   (f x))

,(let* [(def (last (reify `test-func)))
        (state (infer-state))
        (solution (solution))]
   (add-ty! state (symbol->var `+) '(-> (number number) number))

   (with ((ty cons) (infer-expr state def))
     (debug ty)
     (debug cons)

     (apply-constraint! solution cons)
     (print! (pretty solution))
     (debug ty)
     (debug (subst solution ty))

     nil))
