"A pattern matching library.
 Utilities for manipulating deeply-nested data and lists in general,
 as well as binding multiple values.

 The grammar of patterns is described below:
 ```
 pattern ::= literal
           | metavar
           | _
           | ( -> expr pattern ) ;; view
           | ( as pattern metavar ) ;; as
           | ( pattern * ) ;; list
           | ( pattern + . pattern ) ;; list+rest
 literal ::= int | string | boolean | symbol
 metavar ::= '?' symbol
 ```

 A literal pattern matches only if the scrutinee (what's being matched)
 compares [[eq?]] to the literal.

 Both metavariable patterns and the wildcard, `_`, match anything. However,
 a metavariable will bind the result of matching to that symbol. For example,

 ```
 (destructuring-bind [x 1]
   (print! x))
 ```
 Results in `1` being printed to standard output, seeing as it is bound to
 `x`.

 List patterns and _list with rest_ patterns match lists. A list pattern will
 match every element in a list, while a cons pattern will only match a certain
 number of cars and the cdr.
 Both bind everything bound by their \"inner\" patterns."

(import base ( defun defmacro if get-idx
               let* and gensym error for
               quasiquote list or pretty
               slice concat debug
               /= # = ! - + / * >= ))
(import type ( eq? list? symbol? string?
               boolean? number? ))

(import list ( car caddr cadr cdr append for-each
               map filter push-cdr!
               nth last ))

(import table (struct))
(import string (.. char-at sub))

(defun cons-pattern? (pattern) :hidden
  (eq? (nth pattern (- (# pattern) 1)) '.))

(defun cons-pat-left-side (pattern) :hidden
  (slice pattern 1 (- (# pattern) 2)))

(defun cons-pat-right-side (pattern) :hidden
  (last pattern))

(defun meta? (symbol) :hidden
  (and (symbol? symbol)
       (eq? (char-at (get-idx symbol "contents") 1) "?")))

(defun compile-pattern-test (pattern symb) :hidden
  (cond
    [(list? pattern)
     (cond
       [(eq? (car pattern) 'as)
        (compile-pattern-test (cadr pattern) symb)]
       [(eq? (car pattern) '->)
        (compile-pattern-test (caddr pattern) `(,(cadr pattern) ,symb))]
       [(cons-pattern? pattern)
        (let* [(pattern-sym (gensym))
               (lhs (cons-pat-left-side pattern))
               (rhs (cons-pat-right-side pattern))
               (lhs-test '())]
          (for i 1 (# lhs) 1
            (push-cdr! lhs-test (compile-pattern-test (nth lhs i)
                                                      `(nth ,pattern-sym ,i))))
          `(let* [(,pattern-sym ,symb)]
             (and (list? ,pattern-sym)
                  (>= (# ,pattern-sym) ,(- (# pattern) 2))
                  ,@lhs-test
                  ,(compile-pattern-test
                     (last pattern) `(slice ,pattern-sym ,(+ 1 (# lhs)))))))]
       [true
        (let* [(out '())
               (sym (gensym))]
          (for i 1 (# pattern) 1
            (push-cdr! out (compile-pattern-test (nth pattern i)
                                                ~(nth ,sym ,i))))
          `(let* [(,sym ,symb)]
             (and (list? ,sym) (= (# ,sym) ,(# pattern)) ,@out)))])]
    [(or (eq? '_ pattern) (meta? pattern))
     `true]
    [(and (! (meta? pattern)) (symbol? pattern))
     ~(eq? ,symb ',pattern)]
    [(or (number? pattern) (boolean? pattern) (string? pattern))
     `(eq? ,symb ,pattern)]
    [true (error (.. "unsupported pattern " (pretty pattern)))]))

(defun compile-pattern-bindings (pattern symb) :hidden
  (filter (lambda (x) (/= (# x) 0))
    (cond
      [(list? pattern)
       (cond
         [(eq? (car pattern) 'as)
          `(,@(compile-pattern-bindings (caddr pattern) symb) ,@(compile-pattern-bindings (cadr pattern) symb))]
         [(eq? (car pattern) '->)
          (compile-pattern-bindings (caddr pattern) `(,(cadr pattern) ,symb))]
         [(cons-pattern? pattern)
          (let* [(lhs (cons-pat-left-side pattern))
                 (rhs (cons-pat-right-side pattern))
                 (lhs-bindings '())]
            (for i 1 (# lhs) 1
              (for-each elem (compile-pattern-bindings (nth lhs i) `(nth ,symb ,i))
                (push-cdr! lhs-bindings elem)))
            (append lhs-bindings (compile-pattern-bindings rhs `(slice ,symb ,(+ 1 (# lhs))))))]
         [true
          (let* [(out '())]
            (for i 1 (# pattern) 1
              (for-each elem (compile-pattern-bindings (nth pattern i) `(nth ,symb ,i))
                (push-cdr! out elem)))
            out)])]
      [(meta? pattern)
       `((,(struct :tag "symbol" :contents (sub (get-idx pattern "contents") 2)) ,symb))]
      [(or (number? pattern) (boolean? pattern) (string? pattern) (eq? pattern '_) (and (! (meta? pattern)) (symbol? pattern)))
       '()]
      [true (error (.. "unsupported pattern " (pretty pattern)))])))


(defun compile-pattern (pattern symb body) :hidden
  `(if ,(compile-pattern-test pattern symb)
     (let* ,(compile-pattern-bindings pattern symb)
       ,@body)
     (error (.. ,(.. "Pattern matching failure! Can not match the pattern `" (pretty pattern) "` against `") (pretty ,symb) "`."))))

(defmacro destructuring-bind (pt &body)
  "Match a single pattern against a single value, then evaluate the BODY.
   The pattern is given as `(car PT)` and the value as `(cadr PT)`.
   If the pattern does not match, an error is thrown."
  (let* [(pattern (car pt))
         (value (cadr pt))
         (val-sym (gensym))]
    `(let* [(,val-sym ,value)]
       ,(compile-pattern pattern val-sym body))))

(defun generate-case-error (arms val) :hidden
  (let* [(patterns (map (lambda (x) (pretty (car x))) arms))
         ]
    `(error (.. "Pattern matching failure!\nTried to match the following patterns against " (pretty ,val) ", but none matched.\n"
                ,(concat (map (lambda (x) (.. "  Tried: `" x "`")) patterns) "\n")))))

(defmacro case (val &pts)
  "Match a single value against a series of patterns, evaluating the first
   body that matches, much like [[cond]]."
  (let* [(val-sym (gensym))
         (compile-arm
           (lambda (pt)
             `(,(compile-pattern-test (car pt) val-sym)
               (let* ,(compile-pattern-bindings (car pt) val-sym)
                 ,@(cdr pt)))))]
    `(let* [(,val-sym ,val)]
       (cond ,@(map compile-arm pts)
             [true ,(generate-case-error pts val-sym)]))))
