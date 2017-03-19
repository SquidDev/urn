(import urn/analysis/nodes ())
(import urn/analysis/pass ())
(import urn/analysis/traverse traverse)
(import urn/analysis/visitor visitor)
(import urn/logger logger)
(import urn/range (get-source))

(import lua/math math)

(defpass strip-import (state nodes)
  "Strip all import expressions in NODES"
  :cat '("opt")
  ;; TODO: Traverse instead of looping over the top level.
  (for i (# nodes) 1 -1
    (with (node (nth nodes i))
      (when (and (list? node) (> (# node) 0) (symbol? (car node)) (= (.> (car node) :var) (.> builtins :import)))
        ;; We replace the last node in the block with a nil: otherwise we might change
        ;; what is returned
        (if (= i (# nodes))
          (.<! nodes i (make-nil))
          (remove-nth! nodes i))
        (changed!)))))

(defpass strip-pure (state nodes)
  "Strip all pure expressions in NODES (apart from the last one)."
  :cat '("opt")
  ;; TODO: Traverse instead of looping over the top level.
  (for i (pred (# nodes)) 1 -1
    (with (node (nth nodes i))
      (unless (side-effect? node)
        (remove-nth! nodes i)
        (changed!)))))

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
               (meta (and (symbol? head) (! (.> head :folded)) (= (.> head :var :tag) "native") (.> state :meta (.> head :var :fullName))))]
          ;; Determine whether we have a native (and pure) function. If so, we'll invoke it.
          (if (and meta (.> meta :pure) (.> meta :value))
            (with (res (list (pcall (.> meta :value) (unpack (map urn->val (cdr node))))))
              (if (car res)
                (with (val (nth res 2))
                  (if (or (/= (# res) 2) (and (number? val) (or (/= (cadr (list (math/modf val))) 0) (= (math/abs val) math/huge))))
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
                    (.. "Cannot execute constant expression")
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
          (while (<= i (# node))
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
          (if (and (= (# node) 2) (= (urn->bool (car (nth node 2))) true))
            (progn
              (changed!)
              (with (body (cdr (nth node 2)))
                (if (= (# body) 1)
                  (car body)
                  (make-progn (cdr (nth node 2))))))
            node))
        node))))

(defpass lambda-fold (state nodes)
  "Simplify all directly called lambdas, inlining them were appropriate."
  :cat '("opt")
  (traverse/traverse-list nodes 1
    (lambda (node)
      (if (and
            ;; If we're a list with one element (the function to call)
            (list? node) (= (# node) 1)
            ;; And this list is a lambda
            (list? (car node)) (builtin? (caar node) :lambda)
            ;; With no arguments and one expression
            (= (# (car node)) 3) (nil? (nth (car node) 2)))
        (nth (car node) 3)
        node))))
