"Generates constraints for a given expression/set of expressions."

(import data/struct ())

(import plugins/success/types ())

(import compiler/nodes ())
(import compiler/resolve ())

(defstruct (infer-state infer-state infer-state?)
  "Represents the state for type and constraint generation."
  (fields
    (immutable parent
      "The parent for this state, or `nil` if not set. This is used to
       look up variables which are not in the parent scope.")
    (immutable children (hide state-children))
    (immutable fresh (hide state-fresh))
    (immutable vars (hide state-vars))
    (immutable nodes (hide state-nodes)))

  (constructor new
    (lambda (parent)
      (unless (= parent nil)
        (assert-type! parent infer-state))

      (with (created (new parent '()
                          (if parent (state-fresh parent) (fresh-provider))
                          {} {}))
        (when parent (push-cdr! (state-children parent) created))
        created))))

(defun lookup-ty (state var)
  "Lookup the type for the given variable VAR in the provided STATE.

   This will error if such a variable cannot be found."
  (assert-type! state infer-state)
  (assert-type! var var)

  (loop
    [(state state)]
    [(= state nil) (format 1 "cannot find variable {var}" :var (var->symbol var))]

    (with (ty (.> (state-vars state) var))
      (if (= ty nil)
        (recur (infer-state-parent state))
        ty))))

(defun add-ty! (state var ty)
  "Set the type of a given variable VAR to TY."
  (assert-type! state infer-state)
  (assert-type! var var)
  (when (= ty nil) (format 1 "type cannot be nil"))

  (.<! (state-vars state) var ty))

(defun fresh-ty! (state name)
  "Create a fresh type variable with the given NAME."
  (assert-type! state infer-state)
  ((state-fresh state) name))

(defun with-type (state node ty constraints)
  "Associate a particular NODE with a TYPE."
  (assert-type! state infer-state)
  (.<! (state-nodes state) node ty)
  (values-list ty constraints))

(defun infer-expr (state node)
  (case (type node)
    ;; Constants just have the same value as themselves
    ["number" (with-type state node (const-val node) empty-constraint)]
    ["string" (with-type state node (const-val node) empty-constraint)]
    ["key"    (with-type state node (const-val node) empty-constraint)]
    ;; Symbols also have the same type as themselves
    ["symbol" (with-type state node (lookup-ty state (symbol->var node)) empty-constraint)]
    ;; Oh boy, this is going to be a fountain of joy to implement
    ["list"
     (with (head (car node))
       (case (type head)
         ["symbol"
          (with (func (symbol->var head))
            (cond
              [(/= (.> func :kind) "builtin")
               ;; TODO: Expose this in the compiler internals
               (infer-call state node)]

              [(= func (builtin :lambda))
               ;;           { a1 -> t1, ..., an -> tn } |- e: te, C
               ;; ------------------------------------------------------------
               ;; (lambda (a1, ..., an) e): t, (t = (t1, ... tn) -> te when C)
               (let* [(args (nth node 2))
                      (arg-tys '())
                      (child-state (infer-state state))
                      (lam-fresh (fresh-ty! state 'ret))]
                 ;; Setup child state
                 (for-each arg args
                   (with (fresh (fresh-ty! state arg))
                     (add-ty! child-state (symbol->var arg) fresh)
                     (push-cdr! arg-tys fresh)))

                 (with ((ty constraints) (infer-block child-state node 3))
                   (with-type state node (list '-> arg-tys ty) constraints)))]

              [(= func (builtin :cond))
               (fail! "Cond is not yet implemented")]

              [(= func (builtin :set!))
               (fail! "set! is not yet implemented")]

              [(= func (builtin :quote))
               (with-type state node (infer-quote node))]

              [(= func (builtin :syntax-quote))
               (let* [(constraints '())
                      (ty (infer-syntax-quote state node constraints 1))]
                 (with-type state node ty (and-constraints constraints)))]

              [(= func (builtin :struct-literal))
               (let* [(constraints '())
                      (tys '())]

                 (for i 2 (n node) 1
                   (with ((ty constraint) (infer-expr state (nth node i)))
                     (push-cdr! tys ty)
                     (push-cdr! constraints constraint)))

                 (with-type state node (list 'struct tys) (and-constraints constraints)))]

              [(= func (builtin :import))
               ;; Can't really do anything with exprs
               (with-type node 'nil empty-constraint)]

              [else
               (format 1 "(infer-expr <> {#node}): unknown builtin")]))]

         ["list"
          (if (builtin? (caar node))
            ;; TODO: Use zip-args instead
            (let [(args (cadr node))
                  (new-constraints '())
                  (child-state (infer-state state))]

              (for i 1 (n args) 1
                (with ((ty constraints) (infer-expr state (nth node (succ i))))
                  (add-ty! child-state (symbol->var (nth args i)) ty)
                  (push-cdr! new-constraints constraints)))

              (with ((ty constraints) (infer-block child-state (car node) 3))
                (push-cdr! new-constraints constraints)
                (with-type state node ty (and-constraints new-constraints))))

            (infer-call state node))]

         [_ (infer-call state node)]))]))

(defun infer-call (state node)
  "Infer the given CALL node within the provided STATE."
  :hidden
  (let* [((fn-ty fn-constraints) (infer-expr state (car node)))
         (fn-fresh (fresh-ty! state 'fn-ret))
         (ret-fresh (fresh-ty! state 'ret))
         (arg-tys '())
         (arg-constraints '())
         (arg-fresh '())]

    (for i 2 (n node) 1
      (with ((ty constraints) (infer-expr state (nth node i)))
        (push-cdr! arg-tys ty)
        (push-cdr! arg-constraints constraints)
        (push-cdr! arg-fresh (fresh-ty! state (.. "arg" (number->string i))))))

    (with-type state node ret-fresh
      (and-constraints
        ~((= ,fn-ty (-> ,arg-fresh ,fn-fresh))
           (<= ,ret-fresh ,fn-fresh)
           ,@(map (cut list '<= <> <>) arg-tys arg-fresh)
           ,fn-constraints
           ,@arg-constraints)))))

(defun infer-syntax-quote (state node level constraints)
  :hidden
  (if (= level 0)
    (with ((ty constraint) (infer-expr state node))
      (push-cdr! constraints constraint)
      ty)
    (case (type node)
      ["number" (const-val node)]
      ["string" (const-val node)]
      ["key"    (const-val node)]
      ["symbol" 'symbol]

      ["list"
       (case (car node)
         [unquote (infer-syntax-quote state (cadr node) constraints (pred level))]
         [unquote-splice (infer-syntax-quote state (cadr node) constraints (pred level))]
         [syntax-quote (infer-syntax-quote state (cadr node) constraints (succ level))]
         [_
          (with (tys '())
            (for-each child node
              (push-cdr! tys (infer-syntax-quote state child constraints level)))
            (list 'list (union-of tys)))])])))

(defun infer-quote (node)
  :hidden
  (case (type node)
    ["number" (const-val node)]
    ["string" (const-val node)]
    ["key"    (const-val node)]
    ["symbol" 'symbol]
    ["list"   (list 'list (union-of (map infer-quote node)))]))

(defun infer-block (state node start)
  (let* [(last-ty 'none)
         (all-constraints '())]
    (for i start (n node) 1
      (with ((ty constraints) (infer-expr state (nth node i)))
        (set! last-ty ty)
        (push-cdr! all-constraints constraints)))
    (values-list last-ty (and-constraints all-constraints))))
