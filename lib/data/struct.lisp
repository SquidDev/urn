(import core/prelude ())
(import data/function (cut))
(import compiler (flag?))
(import data/format (format))
(import control/setq (defsetq))

(defun gen-def (name ll body &extra) :hidden
  (case name
    [(hide ?x) `(defun ,x ,ll :hidden ,@extra ,@body)]
    [?x `(defun ,x ,ll ,@extra ,@body)]))

(defun map-name (f field) :hidden
  (case field
    [(hide ?x) (list 'hide (f x))]
    [?x (f x)]))

(defun field-name (x) :hidden
  (case x
    [(immutable ?name . _) name]
    [(mutable ?name . _) name]
    [?name name]))

(defun symb-name (x) :hidden
  (case x
    [(hide ?x) x]
    [?x x]))

(defun maybe-check (field tp value) :hidden
  (if (flag? :strict :strict-structs)
    `(when (/= (type ,value) ,(symbol->string tp))
       (format 1 "{}: value '{}' is not of type {}"
               ',(symb-name field) ,value ',tp))
    `nil))

(defun gen-setq-definiton (name type check) :hidden
  (let* [(struct (gensym 'struct))
         (value (gensym 'val))
         (fun (gensym 'fun))
         (val (gensym 'val))
         (use (lambda (x)
                `(,'unquote (,'quote ,x))))
         (embed (lambda (x)
                 `(,'unquote ,x)))
         (inner ``(let [(,,(use val) ,,(embed struct))]
                    (.<! ,,(use val) ,,(symbol->string name)
                        (,,(embed fun) (.> ,,(use val) ,,(symbol->string name))))
                    ,,(use val)))]
    (case name
      [(hide ?x) 'nil]
      [?name
        `(defsetq (,(sym.. type '- name) ,(sym.. '? struct))
                  (lambda (,fun)
                    ,inner))])))

(defun field->def (nm field) :hidden
  (let* [(self (gensym nm))
         (val (gensym (symb-name (field-name field))))]
    (case field
      [(immutable ?name (optional (string? @ ?docs)))
       (list
         (gen-def (map-name (cut sym.. nm '- <>) name)
                `(,self)
                `(,(maybe-check (map-name (cut sym.. nm '- <>) name) nm self)
                  (.> ,self ,(symbol->string (symb-name name))))
                (or docs `nil)))]
      [(immutable ?name ?accessor (optional (string? @ ?docs)))
       (list
         (gen-def accessor
                `(,self)
                `(,(maybe-check accessor nm self)
                  (.> ,self ,(symbol->string (symb-name name))))
                (or docs `nil)))]
      [(symbol? @ ?name)
       (field->def nm (list 'immutable name))]
      [(mutable ?name (optional (string? @ ?docs)))
       (snoc
         (field->def nm (list 'immutable name))
         (gen-def (map-name (cut sym.. 'set- nm '- <> '!) name)
                  (list self val)
                  `(,(maybe-check (map-name (cut sym.. 'set- nm '- <> '!) name)
                                  nm self)
                    (.<! ,self ,(symbol->string (symb-name name)) ,val))
                  (or docs `nil))
         (gen-setq-definiton name nm
                             (maybe-check (map-name (cut sym.. 'set- nm '- <> '!) name) nm self)))]
      [(mutable ?name ?getter ?setter (optional (string? @ ?docs)))
       (snoc
         (field->def nm (list 'immutable name getter))
         (gen-def setter
                  (list self val)
                  `(,(maybe-check setter nm self)
                    (.<! ,self ,(symbol->string (symb-name name)) ,val))
                  (or docs `nil))
         (gen-setq-definiton setter nm
                             (maybe-check (map-name (cut sym.. 'set- nm '- <> '!) name) nm self)))])))

(defun make-constructor (docs type-name fields symbol spec) :hidden
  (let* [(lambda-list (map (lambda (x) (symb-name (field-name x))) fields))
         (kv-pairs (map (function
                          [((immutable (symb-name -> ?name) . _))
                           (list (symbol->string name) name)]
                          [((mutable (symb-name -> ?name) . _))
                           (list (symbol->string name) name)]
                          [((symb-name -> ?name))
                           (list (symbol->string name) name)])
                        fields))
         (name (symb-name symbol))
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

(defun make-meta-decl (type-name constructor-name predicate-name clauses meta-clause fields-clause) :hidden
  (let* [(name-sym (symb-name (car meta-clause)))
         (hide (if (list? (car meta-clause)) (eql? (caar meta-clause) 'hide) false))
         (docs (or (cadr meta-clause) nil))
         (fields-clause-sym (gensym))
         (destructure (let* [(self (gensym 'self))]
                        `(lambda (,'_ ,self)
                           (list ,@(map (lambda (x)
                                          `(.> ,self
                                               ,(symbol->string (symb-name (field-name x)))))
                                        fields-clause)))))]
    `(define ,name-sym ,@(if hide '(:hidden) '()) ,@(if docs (list docs) '())
       (let* [(,fields-clause-sym ',fields-clause)]
         (setmetatable
           { :test ,predicate-name }
           { :__call ,destructure })))))

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
         (meta (assoc-cdr clauses 'meta (list (sym.. '$ name))))
         (fields (assoc-cdr clauses 'fields '()))
         (constructor (assoc-cdr clauses 'constructor '(new new)))]
    (let* [(work '())]
      (push! work (make-constructor docs name fields
                                        constr constructor))
      (push! work (let* [(self (gensym name))]
                        (gen-def pred (list self)
                               `((and (table? ,self)
                                      (= (.> ,self :tag) ,(symbol->string name)))))))
      (map (lambda (x)
             (map (cut push! work <>) (field->def name x)))
           fields)
      (push! work (make-meta-decl name (symb-name constr) (symb-name pred) ; names
                                      clauses ; clauses
                                      meta fields)) ; clauses we use
      (splice work))))
