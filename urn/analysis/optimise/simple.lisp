(import urn/analysis/nodes ())
(import urn/analysis/pass ())
(import urn/analysis/traverse traverse)
(import urn/analysis/vars ())
(import urn/analysis/visitor visitor)
(import urn/backend/lua lua)
(import urn/logger logger)
(import urn/range (get-source get-top-source))
(import urn/resolve/native native)
(import urn/resolve/scope scope)

(defpass strip-import (state nodes start)
  "Strip all import expressions in NODES"
  :cat '("opt" "transform-pre-block")
  (for i (n nodes) start -1
    (with (node (nth nodes i))
      (when (and (list? node) (builtin? (car node) :import))
        ;; We replace the last node in the block with a nil: otherwise we might change
        ;; what is returned
        (if (= i (n nodes))
          (.<! nodes i (make-nil))
          (remove-nth! nodes i))
        (changed!)))))

(defpass strip-pure (state nodes start)
  "Strip all pure expressions in NODES (apart from the last one)."
  :cat '("opt" "transform-pre-block")
  (for i (pred (n nodes)) start -1
    (with (node (nth nodes i))
      (unless (side-effect? node)
        (remove-nth! nodes i)
        (changed!)))))

(defpass constant-fold (state node)
  "A primitive constant folder

   This simply finds function calls with constant functions and looks up the function.
   If the function is native and pure then we'll execute it and replace the node with the
   result. There are a couple of caveats:

    - If the function call errors then we will flag a warning and continue.
    - If this returns a decimal (or infinity or NaN) then we'll continue: we cannot correctly
      accurately handle this.
    - If this doesn't return exactly one value then we will stop. This might be a future enhancement."
  :cat '("opt" "transform-post")
  (if (and (list? node) (fast-all constant? node 2))
    ;; If we're invoking a function with entirely constant arguments then
    (let* [(head (car node))
           (meta (and (symbol? head)
                      (not (.> head :folded))
                      (= (scope/var-kind (.> head :var)) "native") (scope/var-native (.> head :var))))]
      ;; Determine whether we have a native (and pure) function. If so, we'll invoke it.
      (if (and meta (native/native-pure? meta) (function? (lua/get-native (.> head :var))))
        (with (res (list (pcall (.> meta :value) (splice (map urn->val (cdr node))))))
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
                (get-top-source node) nil
                (get-source node) (.. "Executed " (pretty node) ", failed with: " (nth res 2)))
              node)))
        node))
    node))

(defpass cond-fold (state node)
  "Simplify all `cond` nodes, removing `false` branches and killing
   all branches after a `true` one."
  :cat '("opt" "transform-post")
  (if (and (list? node) (builtin? (car node) :cond))
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
               (unless (builtin? (car elem) :true)
                 (changed!)
                 (.<! elem 1 (make-symbol (builtin :true))))
               (set! final true)
               (inc! i)]
              [nil
               (inc! i)]))))

      (cond
        ;; If we're of the form (cond [true X]), replace with X.
        [(and (= (n node) 2) (builtin? (car (nth node 2)) :true))
         (changed!)
         (with (body (cdr (nth node 2)))
           (if (= (n body) 1)
             (car body)
             (make-progn (cdr (nth node 2)))))]
        ;; If we're of the form (cond ... [true (cond ...)]), replace with (cond ... ...)
        [(and (> (n node) 1)
              (with (branch (last node))
                (and (= (n branch) 2) (builtin? (car branch) :true)
                     (list? (cadr branch)) (builtin? (caadr branch) :cond))))
         (let* [(branch (pop-last! node))
                (child-cond (nth branch 2))]
           (for i 2 (n child-cond) 1
             (push! node (nth child-cond i))))
         (changed!)
         node]
        [else node]))
    node))

(defpass lambda-fold (state node)
  "Simplify all directly called lambdas without arguments, inlining them
   were appropriate."
  :cat '("opt" "deforest" "transform-post-bind")
  ;; Look for directly called lambdas and attempt to move direct set!s into
  ;; a binding. This effectively reduces letrec into let.
  (when (simple-binding? node)
    (let* [(vars {})
           (node-lam (car node))
           (node-args (nth node-lam 2))
           (arg-n (n node-args))
           (val-n (pred (n node)))
           (i 1)]

      ;; If we've got more values then arguments then we can't do anything - we'd have to
      ;; introduce additional variables.
      (when (<= val-n arg-n)
        ;; Build a set of all arguments
        (for-each arg node-args (.<! vars (.> arg :var) true))

        ;; Find the first non-nil argument
        (while (and (<= i val-n) (not (builtin? (nth node (succ i)) :nil)))
          (inc! i))

        ;; If we've some arguments within the range, let's just debug for now
        (when (<= i arg-n)
          (loop
            []
            [(> i arg-n)]

            (with (head (nth node-lam 3))
              (when (and
                      ;; If the first element is a setter
                      (list? head) (builtin? (car head) :set!)
                      ;; And we're setting the current argument
                      (= (.> (nth head 2) :var) (.> (nth node-args i) :var))
                      ;; And we don't include a previous definition
                      (not (node-contains-vars? (nth head 3) vars)))

                ;; Push all the `nil`s we need
                (while (< val-n i)
                  (push! node (make-nil))
                  (inc! val-n))

                ;; Remove the setter and shift it to the function call
                (remove-nth! node-lam 3)
                (.<! node (succ i) (nth head 3))
                (changed!)))

            (inc! i)
            (recur))))))

  ;; Look for directly called lambdas and attempt to merge them together.
  ;; Namely reducing let* into let
  (when (simple-binding? node)
    (let* [(vars {})
           (node-lam (car node))
           (node-args (nth node-lam 2))]
      (for-each arg node-args (.<! vars (.> arg :var) true))

      ;; While the first element is a simple binding, we have the same number of arguments and values,
      ;; and the lambda body has just one element.
      ;; We require just one element so variables do not "grow" in scope.
      (loop
        [(child (nth node-lam 3))]
        [(or (not (simple-binding? child)) (/= (n node-args) (pred (n node))) (> (n node-lam) 3))]
        (with (args (nth (car child) 2))
          (loop [] []
            (with (val (nth child 2))
              (cond
                ;; Skip empty argument lists
                [(empty? args)]
                [(not val)
                 ;; If we have no value then we just push all arguments to the parent
                 ;; and exit the loop.
                 (for i 1 (n args) 1
                   (changed!)
                   (with (arg (remove-nth! args 1))
                     (push! node-args arg)
                     (.<! vars (.> arg :var) true)))]

                ;; If the value contains any of the variables then we'll exit the loop
                [(node-contains-vars? val vars)]

                [true
                 (changed!)
                 (push! node (remove-nth! child 2))
                 (with (arg (remove-nth! args 1))
                   (push! node-args arg)
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
            (recur (nth node-lam 3))))))))

(defpass wrap-value-flatten (state node)
  "Flatten \"value wrappers\": lambdas with a single argument which
   prevent returning multiple values."
  :cat '("opt" "transform-post")
  (when (and (list? node)
             (with (head (car node))
               (or (not (symbol? head)) (/= (scope/var-kind (.> head :var)) "builtin"))))

    ;; We can always handle the first argument as it's either a symbol (and so a nop)
    ;; or some directly called lambda (which we may be able to work with).
    (for i 1 (math/max 1 (pred (n node))) 1
      (with (arg (nth node i))
        ;; If this argument is some sort of call
        (when (and (list? arg) (= (n arg) 2)
                   (with (head (car arg))
                     (and
                       ;; And we're calling a lambda
                       (list? head) (= (n head) 3)
                       ;; Which has one non-variadic argument
                       (builtin? (car head) :lambda) (= (n (nth head 2)) 1)
                       (not (scope/var-variadic? (.> (car (nth head 2)) :var)))
                       ;; And that argument is just directly returned
                       (symbol? (nth head 3)) (= (.> (nth head 3) :var) (.> (car (nth head 2)) :var)))))
          (changed!)
          (.<! node i (cadr arg))))))

  node)

(defpass progn-fold-expr (state node)
  "Reduce [[progn]]-like nodes with a single body element into a single
   expression."
  :cat '("opt" "deforest" "transform-post")
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
    node))

(defpass progn-fold-block (state nodes start)
  "Reduce [[progn]]-like nodes with a single body element into a single
   expression."
  :cat '("opt" "deforest" "transform-post-block")
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
            (changed!)
            (if (= (n body) 2)
              (remove-nth! nodes i)
              (progn
                (.<! nodes i (nth body 3))
                (for j 4 (n body) 1
                  (insert-nth! nodes (+ i (- j 3)) (nth body j)))))
            (set! len (+ len (pred (n node)))))
          (inc! i))))))
