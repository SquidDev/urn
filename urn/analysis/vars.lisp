(import urn/analysis/visitor visitor)

(defun node-contains-var? (node var)
  "Determine whether NODE contains a reference to the given VAR."
  (with (found false)
    (visitor/visit-node node
      (lambda (node)
        (cond
          [found false]
          [(symbol? node) (set! found (= var (.> node :var)))]
          [true])))
    found))

(defun node-contains-vars? (node vars)
  "Determine whether NODE contains a reference to any of the given VARS.

   VARS must be a struct of vars to `true`"
  (with (found false)
    (visitor/visit-node node
      (lambda (node)
        (cond
          [found false]
          [(symbol? node) (set! found (.> vars (.> node :var)))]
          [true])))
    found))
