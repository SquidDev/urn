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

(defun node-mutates-var? (node var)
  "Determine whether NODE contains a mutator of the given VAR."
  (with (found false)
    (visitor/visit-node node
      (lambda (node)
        (cond
          [found false]
          [(and (list? node) (builtin? (car node) :set!)) (set! found (= var (.> (nth node 2) :var)))]
          [true])))
    found))

(defun node-mutates-vars? (node vars)
  "Determine whether NODE contains a mutator of one of the given VARS."
  (with (found false)
    (visitor/visit-node node
      (lambda (node)
        (cond
          [found false]
          [(and (list? node) (builtin? (car node) :set!)) (set! found (.> vars (.> (nth node 2) :var)))]
          [true])))
    found))

(defun captured-boundary? (node)
  "The default boundary determiner for [[node-captured]]"
  (and (list? node) (builtin? (car node) :lambda)))

(defun node-captured (node captured boundary?)
  "Determine which variables are CAPTURED within a NODE."
  (unless boundary? (set! boundary? captured-boundary?))

  (let* [(captured-visitor
           (lambda (node)
             (when (symbol? node)
               (.<! captured (.> node :var) true))))

         (normal-visitor
           (lambda (node visitor)
             (cond
               [(boundary? node)
                (visitor/visit-node node captured-visitor)
                false]
               [(and (list? node) (list? (car node)) (builtin? (caar node) :lambda))
                (visitor/visit-block (car node) 3 visitor)
                (visitor/visit-list node 2 visitor)
                false]
               [else true])))]

    (visitor/visit-node node normal-visitor)
    captured))
