(import core/prelude ())

(import compiler/pattern (pattern))
(import compiler/nodes (symbol->var var->symbol))

(define-native fusion/add-rule! "Register a new fusion rule."
  :bind-to "_compiler['fusion/add-rule!']")

(defun fix-pattern! (ptrn)
  "Resolve pattern variables relative to the current state."
  :hidden
  (case (type ptrn)
    ["string" ptrn]
    ["number" ptrn]
    ["symbol"
     (if-with (var (symbol->var ptrn))
       (var->symbol var)
       ptrn)]
    ["list"
     (for i 1 (n ptrn) 1
       (.<! ptrn i (fix-pattern! (nth ptrn i))))
     ptrn]))

(defmacro fusion/defrule (from to)
  "Define a rewrite rule which maps FROM to TO."
  (list `unquote `(fusion/add-rule! { :from (fix-pattern! (pattern ,from))
                                      :to   (fix-pattern! (pattern ,to)) })))
