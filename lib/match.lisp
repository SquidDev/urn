"A pattern matching library.
 Utilities for manipulating deeply-nested data and lists in general,
 as well as binding multiple values.

 The grammar of patterns is described below:
 ```
 pattern ::= literal
           | symbol
           | _
           | ( pattern * ) ;; list
           | ( pattern . pattern ) ;; cons
 ```
 
 A literal pattern matches only if the scrutinee (what's being matched)
 compares [[eq?]] to the literal.

 Both symbol patterns and the wildcard, `_`, match anything. However, a
 symbol will bind the result of matching to that symbol. For example,

 ```
 (destructuring-bind [x 1]
   (print! x))
 ```
 Results in `1` being printed to standard output, seeing as it is bound to
 `x`.

 List patterns and cons patterns match lists. A list pattern will match every
 element in a list, while a cons pattern will only match the car and the cdr.
 Both bind everything bound by their \"inner\" patterns."

(import base ( defun defmacro if debug print
               let* and gensym error
               quasiquote /= # for
               list or pretty ))
(import type ( eq? list? symbol? string?
               boolean? number? ))
(import list ( car caddr cadr cdr append for-each
               map filter push-cdr!
               nth ))
(import string (..))

(defun cons-pattern? (pattern) :hidden
  (eq? (cadr pattern) '.))

(defun compile-pattern-test (pattern symb) :hidden
  (cond
    [(list? pattern)
     (cond
       [(cons-pattern? pattern)
        (let* [(pattern-sym (gensym))]
          `(let* [(,pattern-sym ,symb)]
             (and (list? ,pattern-sym)
                  ,(compile-pattern-test
                     (car pattern) ~(car ,pattern-sym))
                  ,(compile-pattern-test
                     (caddr pattern) ~(cdr ,pattern-sym)))))]
       [true
        (let* [(out '())
               (sym (gensym))]
          (for i 1 (# pattern) 1
            (push-cdr! out (compile-pattern-test (nth pattern i)
                                                ~(nth ,sym ,i))))
          `(let* [(,sym ,symb)]
             (and (list? ,sym) ,@out)))])]
    [(or (eq? '_ pattern) (symbol? pattern))
     `true]
    [(or (number? pattern) (boolean? pattern) (string? pattern))
     `(eq? ,symb ,pattern)]
    [true (error (.. "unsupported pattern " (pretty pattern)))]))

(defun compile-pattern-bindings (pattern symb) :hidden
  (filter (lambda (x) (/= (# x) 0))
    (cond
      [(list? pattern)
       (cond
         [(cons-pattern? pattern)
          (append (compile-pattern-bindings (car pattern) `(car ,symb))
                  (compile-pattern-bindings (caddr pattern) `(cdr ,symb)))]
         [true
          (let* [(out '())]
            (for i 1 (# pattern) 1
              (for-each elem (compile-pattern-bindings (nth pattern i) `(nth ,symb ,i))
                (push-cdr! out elem)))
            out)])]
      [(symbol? pattern)
       `((,pattern ,symb))]
      [(or (number? pattern) (boolean? pattern) (string? pattern) (eq? pattern '_))
       '()]
      [true (error (.. "unsupported pattern " (pretty pattern)))])))


(defun compile-pattern (pattern symb body) :hidden
  `(if ,(compile-pattern-test pattern symb)
     (let* ,(compile-pattern-bindings pattern symb)
       ,@body)
     (error (.. ,(.. "failed to match pattern " (pretty pattern) " against ") (pretty ,symb)))))

(defmacro destructuring-bind (pt &body)
  "Match a single pattern against a single value, then evaluate the BODY.
   The pattern is given as `(car PT)` and the value as `(cadr PT)`.
   If the pattern does not match, an error is thrown."
  (let* [(pattern (car pt))
         (value (cadr pt))
         (val-sym (gensym))]
    `(let* [(,val-sym ,value)]
       ,(compile-pattern pattern val-sym body))))

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
             [true (error "pattern matching failure")]))))
