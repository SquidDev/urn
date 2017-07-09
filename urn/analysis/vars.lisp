(import urn/analysis/visitor visitor)
(import urn/analysis/nodes (builtin?))

(defun node-contains-var? (node var)
  "Determine whether NODE contains a reference to the given VAR."
  (with (found false)
    (visitor/visit-node node
      (lambda (node)
        (cond
          [found false]
          [(and (list? node) (builtin? (car node) :set!)) (set! found (= var (.> (nth node 2) :var)))]
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
          [(and (list? node) (builtin? (car node) :set!)) (set! found (.> vars (.> (nth node 2) :var)))]
          [(symbol? node) (set! found (.> vars (.> node :var)))]
          [true])))
    found))
