(import urn/analysis/nodes ())
(import urn/analysis/pass ())
(import urn/analysis/traverse traverse)

(defun metavar? (x)
  "Determine whether X is a metavar."
  :hidden
  (and (= (.> x :var) nil) (= (string/char-at (symbol->string x) 1) "?")))

(defun genvar? (x)
  "Determine whether X is a gensym var."
  :hidden
  (and (= (.> x :var) nil) (= (string/char-at (symbol->string x) 1) "%")))

(defun builtin-ptrn! (ptrn)
  "Create a pattern from PTRN, binding builtin symbols.

   Note this will mutate the input argument as well as returning it."
  (case (type ptrn)
    ["string" ptrn]
    ["number" ptrn]
    ["key" ptrn]
    ["symbol"
     (.<! ptrn :var (builtin (.> ptrn :contents)))
     ptrn]
    ["list"
     (for i 1 (n ptrn) 1
       (.<! ptrn i (builtin-ptrn! (nth ptrn i))))
     ptrn]))

(defmacro builtin-rule! (from to)
  "Create a rule which maps FROM one pattern TO another using only
   builtin variables."
  `{ :from (builtin-ptrn! ',from)
     :to   (builtin-ptrn! ',to) })

(define fusion-patterns
  "Defines a series of patterns of searches to replacements for patterns."
  (list
    ;; (not (not x)) => (if x true false)
    (builtin-rule!
      (cond
        [(cond [?x false] [true true]) false]
        [true true])
      (cond
        [?x true] [true false]))))

(defun peq? (x y out)
  "Determines whether Y matches the pattern given in X, writing the
   matches to OUT."
  :hidden
  (if (= x y)
    true
    (let [(ty-x (type x))
          (ty-y (type y))]
      (cond
        ;; Capture metavars
        [(and (= ty-x "symbol") (metavar? x))
         (.<! out (symbol->string x) y)
         true]
        ;; Ensure everything is the same type
        [(/= ty-x ty-y) false]
        ;; Otherwise ensure variables are the same.
        [(= ty-x "symbol") (= (.> x :var) (.> y :var))]
        [(= ty-x "string") (= (const-val x) (const-val y))]
        [(= ty-x "number") (= (const-val x) (const-val y))]
        [(= ty-x "key")    (= (const-val x) (const-val y))]
        [(= ty-x "list")
         (if (= (n x) (n y))
           (with (ok true)
             (for i 1 (n x) 1
               (when (and ok (not (peq? (nth x i) (nth y i) out)))
                 (set! ok false)))
             ok)
           false)]))))

(defun substitute (x subs syms)
  "Substitute SUBS in expression X."
  :hidden
  (case (type x)
    ["string" x]
    ["number" x]
    ["key"    x]
    ["symbol"
     (case x
       [metavar?
        (with (res (.> subs (symbol->string x)))
          (when (= res nil) (fail! (.. "Unknown capture " (pretty x))))
          res)]
       [genvar?
        (let* [(name (symbol->string x))
               (sym (.> syms name))]
          ;; TODO: Fix this up so we have actual scopes and everything.
          (unless sym
            (set! sym { :tag      "symbol"
                        :contents name
                        :var      { :tag "var" :kind "arg" :name name } })
            (.<! syms name sym))
          sym)]
       [_ (make-symbol (.> x :var))])]
    ["list" (map (cut substitute <> subs syms) x)]))

(defpass fusion (state node)
  "Merges various loops together as specified by a pattern."
  :cat '("opt" "transform" "transform-pre" "transform-post")
  :level 2
  (when (list? node)
    (for-each ptrn fusion-patterns
      (with (subs {})
        (when (peq? (.> ptrn :from) node subs)
          (changed!)
          (set! node (substitute (.> ptrn :to) subs {}))))))
  node)

(defun add-rule! (rule)
  "Add a new fusion rule RULE."
  (assert-type! rule table)
  (push! fusion-patterns rule)
  nil)
