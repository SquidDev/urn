(import data/struct ())

(defstruct (native native native?)
  "Represents various metadata about native functions."
  (fields
    (mutable pure native-pure? set-native-pure!
      "Determines whether the this expression is pure. Namely it will
       have no side effects and will always evaluate to the same
       expression.")

    (mutable signature
     "The hypothetical signature for this native definition.")

    (mutable bind-to
      "The expression which will be used when emitting this native's
       definition.")

    (mutable syntax
      "A syntax template which will be used when emitting this native's
       definitions and appropriate calls to it. This is intended for
       emitting operators.

       This is a list of template strings or numbers specifying the
       argument's position. In order to ensure correct evaluation,
       arguments should appear in numerical order.

       If the native is called with the correct number of arguments (as
       given by [[native-syntax-arity]]) then the template will be
       emitted inline, otherwise it'll delegate to the generated
       variable.")

    (mutable syntax-arity
      "The arity for this definition. Namely the maximum number of
       arguments that it takes.")

    (mutable syntax-fold
      "If specified, the called function will allow variadic arguments -
       folding in the given direction. This should either be `\"left\"`
       or `\"right\"`.")

    (mutable syntax-stmt native-syntax-stmt? set-native-syntax-stmt!
      "Whether this syntax template is a statement.")

    (mutable syntax-precedence
      "The precedence for this syntax form. This can either be a single
       number or a list of values, one for each argument."))

  (constructor new
    (lambda ()
      (new false nil nil nil nil nil false nil))))

(defun parse-template (template)
  "Parse the template string TEMPLATE, converting it into a list of
   strings and numbers.

   This'll return the converted table and the number of arguments in said
   table."
  (let* [(buffer '())
         (idx     0)
         (max     0)
         (len     (n template))]

    (while (<= idx len)
      (with ((start finish) (string/find template "%${(%d+)}" idx))
        (cond
          [start
           (when (> start idx)
             (push! buffer (string/sub template idx (pred start))))
           (with (val (string->number (string/sub template (+ start 2) (- finish 1))))
             (push! buffer val)
             (when (> val max) (set! max val)))
           (set! idx (succ finish))]
          [else
           (push! buffer (string/sub template idx len))
           (set! idx (succ len))])))

    (values-list buffer max)))
