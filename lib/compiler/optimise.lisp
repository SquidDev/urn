(import compiler/pattern (pattern))

(define-native fusion/add-rule! "Register a new fusion rule.")

(defmacro fusion/defrule (from to)
  "Define a rewrite rule which maps FROM to TO."
  (list `unquote `(fusion/add-rule! { :from (pattern ,from)
                                      :to   (pattern ,to) })))
