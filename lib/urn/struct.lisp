(defun gen-def (name ll body &extra) :hidden
  (case name
    [(hide ?x) `(defun ,x ,ll :hidden ,@extra ,@body)]
    [?x `(defun ,x ,ll ,@extra ,@body)]))

(defun map-name (f field) :hidden
  (case field
    [(hide ?x) (list 'hide (f x))]
    [?x (f x)]))

(defun field->def (nm field) :hidden
  (let* [(self (gensym))
         (val (gensym))]
    (case field
      [(immutable ?name (optional (string? @ ?docs)))
       (list
         (gen-def (map-name (cut sym.. nm '- <>) name)
                `(,self)
                `((.> ,self ,(symbol->string name)))
                (or docs `nil)))]
      [(immutable ?name ?accessor (optional (string? @ ?docs)))
       (list
         (gen-def accessor
                `(,self)
                `((.> ,self ,(symbol->string name)))
                (or docs `nil)))]
      [(symbol? @ ?name)
       (field->def name (list 'immutable name))]
      [(mutable ?name (optional (string? @ ?docs)))
       (snoc
         (field->def nm (list 'immutable name))
         (gen-def (map-name (cut sym.. 'set- nm '- <> '!) name)
                  (list self val)
                  `((.<! ,self ,(symbol->string name) ,val))
                  (or docs `nil)))]
      [(mutable ?name ?getter ?setter (optional (string? @ ?docs)))
       (snoc
         (field->def nm (list 'immutable name getter))
         (gen-def setter
                  (list self val)
                  `((.<! ,self ,(symbol->string name) ,val))
                  (or docs `nil)))])))

(defun field-name (x)
  (case x
    [(immutable ?name . _) name]
    [(mutable ?name . _) name]
    [?name name]))

(defun make-constructor (docs type-name fields symbol spec) :hidden
  (let* [(lambda-list (map field-name fields))
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
         (hide (and (list? symbol) (eq? (car symbol) 'hide)))]
    `(define ,name ,@(if hide '(:hidden) '())
       ,@(if (nil? docs) '() (list docs))
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
         ((docs clauses)
          (if (string? (car clauses))
            (values-list (car clauses) (cdr clauses))
            (values-list nil clauses)))
         (fields (assoc-cdr clauses 'fields '()))
         (constructor (assoc-cdr clauses 'constructor '(new new)))]
    (let* [(work '())]
      (push-cdr! work (make-constructor docs name fields
                                        constr constructor))
      (push-cdr! work (let* [(self (gensym))]
                        (gen-def pred (list self)
                               `((and (table? ,self)
                                      (= (.> ,self :tag) ,(symbol->string name))
                                      ,@(map (lambda (x)
                                               (let* [(x (field-name x))]
                                                 `(/= (.> ,self ,(symbol->string x)) nil)))
                                             fields))))))
      (map (lambda (x)
             (map (cut push-cdr! work <>) (field->def name x)))
           fields)
      (unpack work 1 (n work)))))
