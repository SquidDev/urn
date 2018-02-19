"The pass system provides a way of reading and modifying resolved trees.

 Passes are split into two categories: optimisations and warnings. The
 former should attempt to simplify code, making it more
 performant. Warnings attempt to find potential bugs or stylistic issues
 in your code.

 Each pass is defined and registered with [[defpass]].

 ### State
 Every pass receives a state object. This contains various bits of
 information about the current compiler. Some important fields include:

  - `:meta`: Contains information about native definitions. This is just
    a mapping of variable's full names to the information given in a
    `.meta.*` file.

  - `:libs`: A list of all loaded libraries. Each library is a struct
     containing the library's nodes (`:out`), documentation (`:docs`),
     display name (`:name`) and path (`:path`).

 ### Usage analysis
 Sometimes you will need to get the definitions or usages of a
 variable. Firstly you'll need to include `\"usage\"` in the category
 list in [[defpass]]. You can then access information about the variable
 by using [[var-usage]]."

(define pass-arg :hidden (gensym))

(defmacro defpass (name args &body)
  "Define a pass with the given NAME and BODY taking the specified ARGS.

   BODY can contain key-value pairs (like [[struct]]) which will be set
   as options for this pass.

   Inside the BODY you can call [[changed!]] to mark this pass as
   modifying something."
  (let* [(main `(define ,name))
         (options '())
         (running true)
         (idx 1)
         (len (n body))]

    ;; If we start with a docstring then push it to both the definition
    ;; and struct
    (with (entry (car body))
      (when (string? entry)
        (push! main entry)
        (push! options `:help)
        (push! options entry)
        (inc! idx)))

    ;; Scan for all remaining entries
    (while (and running (<= idx len))
      (with (entry (nth body idx))
        (if (key? entry)
          (progn
            (push! options entry)
            (push! options (nth body (+ idx 1)))
            (set! idx (+ idx 2)))
          (set! running false))))

    (push! main `{ :name ,(symbol->string name)
                       ,@options
                       ,:run (lambda (,pass-arg ,@args) ,@(slice body idx))})

    main))

(define-native add-pass!
  "Register a PASS created with [[defpass]]."
  :bind-to "_compiler['add-pass!']")

(defmacro changed! ()
  "Mark this pass as having a side effect."
  `(.<! ,pass-arg :changed (succ (.> ,pass-arg :changed))))

(define-native var-usage
  "Get usage information about the specified VAR. This returns a struct
   containing:

    - `:defs`: A list of all definitions. Each definition is a struct
      containing its type (`:tag`), the defining node `(:node`) and
      corresponding value (`:value`). Node that not all definitions have
      a value.

    - `:usages`: A list of most usages. This does not include usages
      from nodes which are considered \"dead\"."
  :bind-to "_compiler['var-usage']")
