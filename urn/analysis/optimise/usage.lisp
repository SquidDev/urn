(import urn/analysis/nodes ())
(import urn/analysis/pass ())
(import urn/analysis/traverse traverse)
(import urn/analysis/usage usage)
(import urn/analysis/visitor visitor)

(defun get-constant-val (lookup sym)
  "Get the value of DEF if it is a constant, otherwise nil"
  :hidden
  (let* [(var (.> sym :var))
         (def (usage/get-var lookup (.> sym :var)))]
    (cond
      [(= var (.> builtin-vars :true)) sym]
      [(= var (.> builtin-vars :false)) sym]
      [(= var (.> builtin-vars :nil)) sym]
      [(= (#keys (.> def :defs)) 1)
       (let* [(ent (nth (list (next (.> def :defs))) 2))
              (val (.> ent :value))
              (ty  (.> ent :tag))]
         (cond
           [(or (string? val) (number? val) (key? val)) val]
           [(and (symbol? val) (or (= ty "define") (= ty "set") (= ty "let")))
            ;; Attempt to get this value, or fallback to just the symbol
            ;; This allows us to simplify reference chains to their top immutable variable
            (or (get-constant-val lookup val) sym)]
           [true sym]))]
      [true nil])))

(defpass strip-defs (state nodes lookup)
  "Strip all unused top level definitions."
  :cat '("opt" "usage")

  (for i (# nodes) 1 -1
    (with (node (nth nodes i))
      (when (and (.> node :defVar) (! (.> (usage/get-var lookup (.> node :defVar)) :active)))
        (if (= i (# nodes))
          (.<! nodes i (struct :tag "symbol" :contents "nil" :var (.> builtin-vars :nil)))
          (remove-nth! nodes i))
        (changed!)))))

(defpass strip-args (state nodes lookup)
  "Strip all unused, pure arguments in directly called lambdas."
  :cat '("opt" "usage")

  (visitor/visit-list nodes 1
    (lambda (node)
      (when (and (list? node) (list? (car node)) (symbol? (caar node)) (= (.> (caar node) :var) (.> builtins :lambda)))
        (let* [(lam (car node))
               (args (nth lam 2))
               (offset 1)
               (rem-offset '0)]
          (for i 1 (# args) 1
            (let [(arg (nth args (- i rem-offset)))
                  (val (nth node (- (+ i offset) rem-offset)))]
              (cond
                [(.> arg :var :isVariadic)
                 (with (count (- (# node) (# args)))
                       ;; If it's a variable number of args then just skip them
                       (when (< count 0) (set! count 0))
                       (set! offset count))]

                [(= nil val)]
                ;; Obviously don't remove values which have an effect
                [(side-effect? val)]
                ;; And keep values which are actually used
                [(> (#keys (.> (usage/get-var lookup (.> arg :var)) :usages)) 0)]
                ;; So remove things which aren't used and have no side effects.
                [true
                  (changed!)
                  (remove-nth! args (- i rem-offset))
                  (remove-nth! node (- (+ i offset) rem-offset))
                  (inc! rem-offset)]))))))))

(defpass variable-fold (state nodes lookup)
  "Folds variables"
  :cat '("opt" "usage")
  (traverse/traverse-list nodes 1
    (lambda (node)
      (if (symbol? node)
        (with (var (get-constant-val lookup node))
          (if (and var (/= var node))
            (progn
              (changed!)
              var)
            node))
        node))))
