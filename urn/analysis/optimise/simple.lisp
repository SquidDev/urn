(import urn/analysis/nodes ())
(import urn/analysis/pass ())
(import urn/analysis/traverse traverse)
(import urn/analysis/vars ())
(import urn/analysis/visitor visitor)
(import urn/logger logger)
(import urn/range (get-source))

(defpass strip-import (state nodes)
  "Strip all import expressions in NODES"
  :cat '("opt")
  (visitor/visit-blocks nodes
    (lambda (nodes start)
      (for i (n nodes) start -1
        (with (node (nth nodes i))
          (when (and (list? node) (builtin? (car node) :import))
            ;; We replace the last node in the block with a nil: otherwise we might change
            ;; what is returned
            (if (= i (n nodes))
              (.<! nodes i (make-nil))
              (remove-nth! nodes i))
            (changed!)))))))

(defpass strip-pure (state nodes)
  "Strip all pure expressions in NODES (apart from the last one)."
  :cat '("opt")
  (visitor/visit-blocks nodes
    (lambda (nodes start)
      (for i (pred (n nodes)) start -1
        (with (node (nth nodes i))
          (unless (side-effect? node)
            (remove-nth! nodes i)
            (changed!)))))))

(defpass constant-fold (state nodes)
  "A primitive constant folder

   This simply finds function calls with constant functions and looks up the function.
   If the function is native and pure then we'll execute it and replace the node with the
   result. There are a couple of caveats:

    - If the function call errors then we will flag a warning and continue.
    - If this returns a decimal (or infinity or NaN) then we'll continue: we cannot correctly
      accurately handle this.
    - If this doesn't return exactly one value then we will stop. This might be a future enhancement."
  :cat '("opt")
  (traverse/traverse-list nodes 1
    (lambda (node)
      (if (and (list? node) (fast-all constant? node 2))
        ;; If we're invoking a function with entirely constant arguments then
        (let* [(head (car node))
               (meta (and (symbol? head) (! (.> head :folded)) (= (.> head :var :tag) "native") (.> state :meta (.> head :var :full-name))))]
          ;; Determine whether we have a native (and pure) function. If so, we'll invoke it.
          (if (and meta (.> meta :pure) (.> meta :value))
            (with (res (list (pcall (.> meta :value) (unpack (map urn->val (cdr node)) 1 (- (n node) 1)))))
              (if (car res)
                (with (val (nth res 2))
                  (if (or (/= (n res) 2) (and (number? val) (or (/= (cadr (list (math/modf val))) 0) (= (math/abs val) math/huge))))
                    (progn
                      ;; Don't fold non-integer values as we cannot accurately represent them
                      ;; To consider: could we fold this if a parent expression could be folded (so simplify
                      ;; (math/cos math/pi)) but revert otherwise.
                      ;; That might be overly complicated for a simple constant folding system though.
                      (.<! head :folded true)
                      node)
                    (progn
                      (changed!)
                      (val->urn val))))
                (progn
                  ;; Mark this head as folded so we don't try again
                  (.<! head :folded true)
                  ;; Print a warning message
                  (logger/put-node-warning! (.> state :logger)
                    "Cannot execute constant expression"
                    node nil
                    (get-source node) (.. "Executed " (pretty node) ", failed with: " (nth res 2)))
                  node)))
            node))
        node))))

(defpass cond-fold (state nodes)
  "Simplify all `cond` nodes, removing `false` branches and killing
   all branches after a `true` one."
  :cat '("opt")
  (traverse/traverse-list nodes 1
    (lambda (node)
      (if (and (list? node) (symbol? (car node)) (= (.> (car node) :var) (.> builtins :cond)))
        (let* [(final false)
               (i 2)]
          (while (<= i (n node))
            (with (elem (nth node i))
              (if final
                (progn
                  (changed!)
                  (remove-nth! node i))
                (case (urn->bool (car elem))
                  [false
                   (changed!)
                   (remove-nth! node i)]
                  [true
                   (set! final true)
                   (inc! i)]
                  [nil
                   (inc! i)]))))
          (if (and (= (n node) 2) (= (urn->bool (car (nth node 2))) true))
            (progn
              (changed!)
              (with (body (cdr (nth node 2)))
                (if (= (n body) 1)
                  (car body)
                  (make-progn (cdr (nth node 2))))))
            node))
        node))))



(defpass lambda-fold (state nodes)
  "Simplify all directly called lambdas without arguments, inlining them
   were appropriate."
  :cat '("opt")
  (visitor/visit-block nodes 1
    (lambda (node)
      ;; Look for directly called lambdas
      (when (simple-binding? node)
        (let* [(vars {})
               (node-lam (car node))
               (node-args (nth node-lam 2))]
          (for-each arg node-args (.<! vars (.> arg :var) true))

          ;; While the first element is a simple binding, we have the same number of arguments and values,
          ;; and the lambda body has just one element.
          ;; We require just one element so variables do not "grow" in scope.
          (loop [(child (nth node-lam 3))]
            [(or (! (simple-binding? child)) (/= (n node-args) (pred (n node))) (> (n node-lam) 3))]
            (with (args (nth (car child) 2))
              (loop [] []
                (with (val (nth child 2))
                  (cond
                    ;; Skip empty argument lists
                    [(empty? args)]
                    [(! val)
                     ;; If we have no value then we just push all arguments to the parent
                     ;; and exit the loop.
                     (for i 1 (n args) 1
                       (with (arg (remove-nth! args 1))
                         (push-cdr! node-args arg)
                         (.<! vars (.> arg :var) true)))]

                    ;; If the value contains any of the variables then we'll exit the loop
                    [(node-contains-vars? val vars)]

                    [true
                     (push-cdr! node (remove-nth! child 2))
                     (with (arg (remove-nth! args 1))
                       (push-cdr! node-args arg)
                       (.<! vars (.> arg :var) true))

                     (recur)])))

              ;; When we've got a directly called lambda with empty arguments and values, then inline it
              ;; The more general case is handled below, but we might as well get a simple version done here.
              (when (and (empty? args) (= (n child) 1))
                ;; Remove the existing lambda
                (remove-nth! node-lam 3)
                ;; For each element in the child lambda, insert it into the parent one.
                (with (lam (car child))
                  (for i 3 (n lam) 1
                    (insert-nth! node-lam i (nth lam i))))

                ;; And continue the loop. Otherwise there was something that couldn't be merged.
                (recur (nth node-lam 3)))))))))

  (traverse/traverse-list nodes 1
    (lambda (node)
      (if (and
            ;; If we're a list with one element (the function to call)
            (list? node) (= (n node) 1)
            ;; And this list is a lambda
            (list? (car node)) (builtin? (caar node) :lambda)
            ;; With no arguments and one expression
            (= (n (car node)) 3) (empty? (nth (car node) 2)))
        (progn
          (changed!)
          (nth (car node) 3))
        node)))

  (visitor/visit-blocks nodes
    (lambda (nodes start)
      (let [(i start)
            (len (n nodes))]
        (while (<= i len)
          (with (node (nth nodes i))
            (if (and
                  ;; If we're a list with one element
                  (list? node) (= (n node) 1)
                  ;; And the function is a lambda
                  (list? (car node)) (builtin? (car (car node)) :lambda)
                  ;; And has no arguments
                  (empty? (nth (car node) 2)))
              (with (body (car node))
                (if (= (n body) 2)
                  (remove-nth! nodes i)
                  (progn
                    (.<! nodes i (nth body 3))
                    (for j 4 (n body) 1
                      (insert-nth! nodes (+ i (- j 3)) (nth body j)))))
                (set! len (+ len (pred (n node)))))
              (inc! i))))))))
