"A pattern matching library.

 Utilities for manipulating deeply-nested data and lists in general, as
 well as binding multiple values.

 The grammar of patterns is described below:
 ```
 pattern ::= literal
           | metavar
           | _
           | symbol '?' ;; predicate
           | ( -> expr pattern ) ;; view
           | ( as pattern metavar ) ;; as
           | ( pattern * ) ;; list
           | ( pattern + . pattern ) ;; list+rest
 literal ::= number | string | boolean | symbol | key
 metavar ::= '?' symbol
 ```

 A literal pattern matches only if the scrutinee (what's being matched)
 compares [[eq?]] to the literal.

 Both metavariable patterns and the wildcard, `_`, match
 anything. However, a metavariable will bind the result of matching to
 that symbol. For example,

 ```
 (destructuring-bind [x 1]
   (print! x))
 ```

 Results in `1` being printed to standard output, seeing as it is bound
 to `x`.

 List patterns and _list with rest_ patterns match lists. A list pattern
 will match every element in a list, while a cons pattern will only match
 a certain number of cars and the cdr. Both bind everything bound by
 their \"inner\" patterns.

 A type predicate pattern works much like a wildcard, except it only
 matches if the scrutinee matches the given predicate."

(import lua/basic (xpcall))
(import lua/math (max))
(import base ( defun defmacro if get-idx
               and gensym error for set-idx!
               quasiquote list or pretty
               slice concat debug apply
               /= # = ! - + / * >= <= ))
(import type ())
(import list ( car caddr cadr cdr append for-each
               map filter push-cdr! range snoc
               nth last elem? ))

(import string (.. char-at sub #s))
(import binders (let*))

(defun cons-pattern? (pattern) :hidden
  (and (list? pattern)
       (eq? (nth pattern (- (# pattern) 1)) '.)))

(defun cons-pat-left-side (pattern) :hidden
  (slice pattern 1 (- (# pattern) 2)))

(defun cons-pat-right-side (pattern) :hidden
  (last pattern))

(defun meta? (symbol) :hidden
  (and (symbol? symbol)
       (eq? (char-at (get-idx symbol "contents") 1) "?")))

(defun pattern-length (pattern correction) :hidden
  (let* [(length 0)]
    (cond
      [(list? pattern)
       (for i 1 (# pattern) 1
         (if (and (list? (nth pattern i))
                  (eq? (car (nth pattern i)) 'optional))
           0
           (set! length (+ length 1))))]
      [(meta? pattern) 1]
      [true 0])
    (+ length correction)))

(defun pattern-# (pat) :hidden
  (cond
    [(cons-pattern? pat) (pattern-length pat -2)]
    [true (pattern-length pat 0)]))

(defun predicate? (x) :hidden
  (let* [(x (get-idx x :contents))]
    (= (char-at x (#s x)) "?")))

(defun assert-linearity! (pat seen) :hidden
  (cond
    [(! seen) (assert-linearity! pat {})]
    [(list? pat)
     (cond
       [(eq? (car pat) 'as)
        (assert-linearity! (cadr pat) seen)]
       [(eq? (car pat) '->')
        (assert-linearity! (caddr pat) seen)]
       [(eq? (car pat) 'optional)
        (assert-linearity! (cadr pat) seen)]
       [(cons-pattern? pat)
        (let* [(seen '())]
          (for i 1 (pattern-# pat) 1
            (assert-linearity! (nth pat i) seen))
          (assert-linearity! (get-idx pat (# pat)) seen))]
       [true
        (let* [(seen '())]
          (for i 1 (# pat) 1
            (assert-linearity! (nth pat i) seen)))])]
    [(or (and (! (meta? pat)) (symbol? pat))
         (eq? pat '_)
         (number? pat)
         (string? pat)
         (boolean? pat)
         (eq? pat 'nil))
     true]
    [(meta? pat)
     (if (get-idx seen (get-idx pat :contents))
       (error (.. "pattern is not linear: seen " (pretty pat) " more than once"))
       (set-idx! seen (get-idx pat :contents) true))]))

(defun compile-pattern-test (pattern symb) :hidden
  (cond
    [(list? pattern)
     (cond
       [(eq? (car pattern) 'as)
        (compile-pattern-test (cadr pattern) symb)]
       [(eq? (car pattern) '->)
        (compile-pattern-test (caddr pattern) `(,(cadr pattern) ,symb))]
       [(eq? (car pattern) 'optional)
        `(if ,symb ,(compile-pattern-test (cadr pattern) symb) true)]
       [(cons-pattern? pattern)
        (let* [(pattern-sym (gensym))
               (lhs (cons-pat-left-side pattern))
               (rhs (cons-pat-right-side pattern))
               (lhs-test '())]
          (for i 1 (# lhs) 1
            (push-cdr! lhs-test
                       (compile-pattern-test (nth lhs i)
                                             `(nth ,pattern-sym ,i))))
          `(let* [(,pattern-sym ,symb)]
             (and (list? ,pattern-sym)
                  (>= (# ,pattern-sym) ,(pattern-length pattern -2))
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
             (and (list? ,sym)
                  (>= (# ,sym) ,(pattern-length pattern 0))
                  (<= (# ,sym) ,(# pattern))
                  ,@out)))])]
    [(or (eq? '_ pattern) (meta? pattern))
     `true]
    [(and (! (meta? pattern)) (symbol? pattern))
     (cond
       [(eq? pattern 'true) `(eq? ,symb true)]
       [(eq? pattern 'false) `(eq? ,symb false)]
       [(eq? pattern 'nil) `(eq? ,symb nil)]
       [(predicate? pattern) ~(,pattern ,symb)] ; need the dynamic scoping here.
       [true ~(eq? ,symb ',pattern)])]
    [(key? pattern)
     `(eq? ,symb ,pattern)]
    [(or (number? pattern) (boolean? pattern) (string? pattern))
     `(= ,symb ,pattern)]
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
         [(eq? (car pattern) 'optional)
          (compile-pattern-bindings (cadr pattern) symb)]
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
       `((,{ :tag "symbol" :contents (sub (get-idx pattern "contents") 2) } ,symb))]
      [(or (number? pattern) (boolean? pattern) (string? pattern) (key? pattern) (eq? pattern '_) (and (! (meta? pattern)) (symbol? pattern)))
       '()]
      [true (error (.. "unsupported pattern " (pretty pattern)))])))


(defun compile-pattern (pattern symb body) :hidden
  `(if ,(compile-pattern-test pattern symb)
     (let* ,(compile-pattern-bindings pattern symb)
       ,@body)
     (error (.. ,(.. "Pattern matching failure! Can not match the pattern `" (pretty pattern) "` against `") (pretty ,symb) "`."))))

(defmacro destructuring-bind (pt &body)
  "Match a single pattern against a single value, then evaluate the BODY.

   The pattern is given as `(car PT)` and the value as `(cadr PT)`.  If
   the pattern does not match, an error is thrown."
  (let* [(pattern (car pt))
         (value (cadr pt))
         (val-sym (gensym))]
    (assert-linearity! pattern)
    `(let* [(,val-sym ,value)]
       ,(compile-pattern pattern val-sym body))))

(defun generate-case-error (arms val) :hidden
  (let* [(patterns (map (lambda (x) (pretty (car x))) arms))]
    `(error (.. "Pattern matching failure!\nTried to match the following patterns against " (pretty ,val) ", but none matched.\n"
                ,(concat (map (lambda (x) (.. "  Tried: `" x "`")) patterns) "\n")))))

(defmacro case (val &pts)
  "Match a single value against a series of patterns, evaluating the
   first body that matches, much like [[cond]]."
  (let* [(val-sym (gensym))
         (compile-arm
           (lambda (pt)
             (assert-linearity! (car pt))
             `(,(compile-pattern-test (car pt) val-sym)
               (let* ,(compile-pattern-bindings (car pt) val-sym)
                 ,@(cdr pt)))))]
    `(let* [(,val-sym ,val)]
       (cond ,@(map compile-arm pts)
             [true ,(generate-case-error pts val-sym)]))))

(defmacro matches? (pt x)
  "Test if the value X matches the pattern PT.

   Note that, since this does not bind anything, all metavariables may be
   replaced by `_` with no loss of meaning."
  (compile-pattern-test pt x))

(defun ->meta (x) :hidden
  { :tag "symbol" :contents (.. "?" (get-idx x :contents)) })

(defmacro handler-case (x &body)
  "Evaluate the form X, and if an error happened, match the series
   of `(?pattern (?arg) . ?body)` arms given in BODY against the value of
   the error, executing the first that succeeeds.

   In the case that X does not throw an error, the value of that
   expression is returned by [[handler-case]].

   Example:

   ```cl
   > (handler-case \\
   .   (error! \"oh no!\")
   .   [string? (x)
   .    (print! x)])
   ```"
  (let* [(gen-arm (cs exc)
           (destructuring-bind [(?pattern (?arg) . ?body) cs]
             ~((as ,pattern ,(->meta arg)) ,@body)))
         (exc-sym (gensym))
         (tmp-sym (gensym))
         (error-handler `(lambda (,exc-sym)
                           (case ,exc-sym
                             ,@(map gen-arm body))))]
    `(let* [(,tmp-sym (list (xpcall (lambda () ,x) ,error-handler)))]
       (if (car ,tmp-sym)
         (cadr ,tmp-sym)
         nil))))

(defmacro function (&arms)
  (let* [(rest-sym (gensym "remaining-arguments"))
         (rest { :tag :symbol
                 :contents (.. "&" (get-idx rest-sym :contents)) })
         (param-n (apply max (map (lambda (x)
                                    (pattern-# (car x)))
                               arms)))
         (param-nams (map gensym (range 1 param-n)))]
    `(lambda ,(snoc param-nams rest)
       (case (append (list ,@param-nams) ,rest-sym)
         ,@arms))))
