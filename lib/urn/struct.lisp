(import urn/control/prompt ())

(defun gen-def (name ll body &extra) :hidden
  (case name
    [(hide ?x) `(defun ,x ,ll :hidden ,@body ,@extra)]
    [?x `(defun ,x ,ll ,body ,@extra)]))

(defun paste-names (prefix field) :hidden
  (case field
    [(hide ?x) (list 'hide (sym.. prefix '- x))]
    [?x (sym.. prefix '- x)]))

(defun field->def (nm field) :hidden
  (case field
    [(immutable ?name)
     (list
       (gen-def (paste-names nm name)
              '(self)
              `((.> ,'self ,(symbol->string name)))))]
    [(immutable ?name ?accessor)
     (list
       (gen-def accessor
              '(self)
              `((.> ,'self ,(symbol->string name)))))]
    [(symbol? @ ?name)
     (field->def name (list 'immutable name))]
    [(mutable ?name)
     (snoc
       (field->def nm (list 'immutable name))
       (gen-def (paste-names (paste-names nm 'set-) name)
                '(self val)
                `((.<! ,'self ,(symbol->string name) ,'val))))]
    [(mutable ?name ?getter ?setter)
     (snoc
       (field->def nm (list 'immutable name getter))
       (gen-def setter
                '(self val)
                `((.<! ,'self ,(symbol->string name) ,'val))))]))

(defun make-constructor (type-name fields symbol spec) :hidden
  (let* [(lambda-list (map (function
                             [((immutable ?name . _)) name]
                             [((mutable ?name . _)) name]
                             [?name name])
                           fields))
         (kv-pairs (map (function
                          [((immutable ?name . _))
                           (list (symbol->string name) `(or ,name nil))]
                          [((mutable ?name . _))
                           (list (symbol->string name) `(or ,name nil))]
                          [?name (list (symbol->string name) `(or ,name nil))])
                        fields))
         (name (case symbol
                 [(hide ?x) x]
                 [?x x]))
         (hide (and (list? type-name) (eq? (car type-name) 'hide)))]
    `(define ,name ,@(if hide '(:hidden) '())
       (let* [(,(car spec)
                (lambda ,lambda-list
                  { :tag ,(symbol->string type-name)
                    ,@(flatten kv-pairs) }))]
         ,(cadr spec)))))

(defun assoc-cdr (list k or-val) :hidden
  (case list
    [() or-val]
    [(((?x . ?y) . _)
      :when (eq? x k))
     y]
    [(_ . ?x) (assoc-cdr x k or-val)]))

(defmacro defstruct (name &clauses)
  "Define a struct called NAME.

   NAME can be either a symbol or a list of three elements, whose
   elements name, respectively, the type (returned from `type` and
   used in `defmethod`, for instance), the constructor's name, and
   the predicate's name. In case NAME is a symbol, the constructor
   and predicate names are automatically derived from that symbol.

   Consider:
   ```cl :no-test
   (defstruct thing ...)
   (defstruct (other-thing make-something-else is-something-else?) ...)
   ```

   The first struct declaration generates a constructor called
   `make-thing` and a predicate called `thing?`, but the second
   declaration generates a constructor called `make-something-else`
   and a predicate `is-something-else?`.

   The CLAUSES argument to [[defstruct]] controls the contents of the
   generated structure.

   The `(fields field ...)` clause defines the fields of the structure
   type. Each `field` must be of one of the following forms:
     - `field-name`
     - `(immutable field-name [getter-name])`
     - `(mutable field-name [getter-name setter-name])`
   Where a field in square brackets is optional. If no name is
   specified for the getter, it will have the name `struct-field`,
   while the setter will have the name `set-struct-field!`.

   The `(constructor tag fun)` clause will use `fun` as the constructor
   for the structure type. `tag` will be a symbol in `fun`'s scope that
   builds the structure according to the fields clause."
  (let* [((name constr pred)
          (case name
            [(?n ?c ?p) (values-list n c p)]
            [?n (values-list n (sym.. 'make- n) (sym.. n '?))]))
         (fields (assoc-cdr clauses 'fields '()))
         (constructor (assoc-cdr clauses 'constructor '(new new)))]
    (let* [(work '())]
      (push-cdr! work (make-constructor name fields constr constructor))
      (push-cdr! work (gen-def pred '(self) `(= (.> ,'self :tag) ,(symbol->string name))))
      (map (lambda (x)
             (map (cut push-cdr! work <>) (field->def name x)))
           fields)
      (unpack work 1 (n work)))))
