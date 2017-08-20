(import urn/analysis/nodes ())
(import urn/analysis/pass ())
(import urn/analysis/traverse traverse)

(define fusion-patterns
  "Defines a series of patterns of searches to replacements for patterns."
  :hidden
  '())

(defun metavar? (x)
  "Determine whether X is a metavar."
  :hidden
  (and (= (.> x :var) nil) (= (string/char-at (symbol->string x) 1) "?")))

(defun genvar? (x)
  "Determine whether X is a gensym var."
  :hidden
  (and (= (.> x :var) nil) (= (string/char-at (symbol->string x) 1) "%")))

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
               (when (and ok (! (peq? (nth x i) (nth y i) out)))
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
          (unless sym
            (set! sym { :tag "symbol"
                        :name name
                        :var { :tag "arg" :name name })
            (.<! syms name sym))
          sym)]
       [_ (make-symbol (.> x :var))])]
    ["list" (map (cut substitute <> subs syms) x)]))

(defun fix-pattern! (state ptrn)
  "Resolve pattern variables relative to the current state."
  (case (type ptrn)
    ["string" ptrn]
    ["number" ptrn]
    ["symbol"
     (if (.> ptrn :var)
       (make-symbol (symbol->var state ptrn))
       ptrn)]
    ["list" (map (cut fix-pattern! state <>) ptrn)]))

(defun fix-rule! (state rule)
  "Resolve pattern variables relative to the current state."
  { :from (fix-pattern! state (.> rule :from))
    :to   (fix-pattern! state (.> rule :to)) })

(defpass fusion (state nodes)
  "Merges various loops together as specified by a pattern."
  :cat '("opt")
  :on false
  (with (patterns (map (cut fix-rule! (.> state :compiler) <>) fusion-patterns))
    (traverse/traverse-block nodes 1
      (lambda (node)
        (when (list? node)
          (for-each ptrn patterns
            (with (subs {})
              (when (peq? (.> ptrn :from) node subs)
                (changed!)
                (set! node (substitute (.> ptrn :to) subs {}))))))
        node))))

(defun add-rule! (rule)
  "Add a new fusion rule RULE."
  (assert-type! rule table)
  (push-cdr! fusion-patterns rule)
  nil)
