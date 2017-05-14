(defun fusion/patternquote# (ptrn)
  "Quote a search/replacement pattern."
  :hidden
  (case (type ptrn)
    ["string" ptrn]
    ["number" ptrn]
    ["key" ptrn]
    ["symbol"
     (case (string/char-at (symbol->string ptrn) 1)
       ["?" (list `unquote (list `quote ptrn))]
       ["%" (list `unquote (list `quote ptrn))]
       [_ ptrn])]
    ["list" ptrn
     (for i 1 (n ptrn) 1 (.<! ptrn i (fusion/patternquote# (nth ptrn i))))
     ptrn]))

(defmacro fusion/patternquote (ptrn)
  "Quote pattern PTRN, automatically escaping variables which start with `?` or `%`."
  (list `syntax-quote (fusion/patternquote# ptrn)))

(define-native fusion/add-rule! "Register a new fusion rule.")

(defmacro fusion/defrule (from to)
  "Define a rewrite rule which maps FROM to TO."
  (list `unquote `(fusion/add-rule! { :from `,,(fusion/patternquote# from)
                                      :to   `,,(fusion/patternquote# to) })))
