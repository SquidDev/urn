"A pattern matching library.

 Utilities for manipulating deeply-nested data and lists in general, as
 well as binding multiple values.

 ## Literal patterns
 A literal pattern matches only if the scrutinee (what's being matched)
 compares [[eql?]] to the literal. One can use any Urn atom here:
 strings, numbers, keys and symbols.

 Note that the `true`, `false` and `nil` symbols will match against their
 *values*, whilst other symbols will match against a symbol object. Note
 that using a quoted symbol will match against a list instead. For
 instance, `'x` will expand to a match against `(quote x)`.

 ### Example
 ```cl
 > (with (x 1)
 .   (case x
 .     [1 \"Is 1!\"]
 .     [x \"Is symbol 'x'!\"]
 .     [nil \"Is nil :/\"]))
 \"Is 1!\"
 ```

 ### Wildcards and captures
 If one does not require a value to take a particular form, you can use a
 wildcard (`_` or `else`). This will match anything, discarding its value. This
 is often useful as the last expression in a [[case]], where you need to
 handle any remaining forms.

 If you wish to use this value, you should use a capture, or
 metavariable. This is a symbol prefixed with `?`. This will declare a
 variable of the same name (though without the `?`), bound to the
 captured value.

 ```cl
 > (with (x 3)
 .   (case x
 .     [1 \"Is 1!\"]
 .     [2 \"Is 2!\"]
 .     [?y $\"Is ~{y}\"]))
 \"Is 3\"
 ```

 In the above example, neither of the first two arms match, so the value
 of `x` is bound to the `y` variable and the arm's body executed.

 One can also match against the captured value by using the `@`
 form. This is a list which takes a pattern, the `@` symbol and then a
 metavariable. It will attempt to match the value against the provided
 pattern and, if it matches, bind it to the given variable.

 ```cl
 > (with (x 3)
 .   (case x
 .     [1 \"Is 1!\"]
 .     [2 \"Is 2!\"]
 .     [(_ @ ?y) $\"Is ~{y}\"]))
 \"Is 3\"
 ```

 This example is equivalent to the previous one, as the wildcard will
 match anything. You can of course use a more complex pattern there.

 ## List patterns
 List patterns and _list with rest_, patterns match lists.

 A list pattern requires a value to be a list of a specific length,
 matching each element in the list with its corresponding pattern in the
 list pattern.

 List with rest patterns, or cons patterns, require a value to be at
 least the given length, bundling all remaining values into a separate
 list and matching that against a new pattern.

 Both these patterns allow variables to be bound by their \"inner\"
 patterns, allowing one to build up complex expressions.

 ```cl
 > (with (x '(1 2 (3 4 5)))
 .   (case x
 .     ;; Matching against a fixed list
 .     [() \"Got an empty list\"]
 .     [(?a ?b) $\"Got a pair ~{a} ~{b}\"]
 .     ;; Using cons patterns, and capturing inside nested patterns
 .     [(?a ?b (?c . ?d)) $\"Got a triplet with ~{d}\"])
 \"Got a triplet with (4 5)\"
 ```

 ## Struct patterns
 Not dissimilar to list patterns, struct patterns allow you do match
 against an arbitrary struct. However, the struct pattern only checks for
 the presence of keys, and does not verify no additional keys are
 present.

 ```cl
 > (with (x { :x 1 :y '(1 2 3) })
 .   (case x
 .     [{ :x 1 :y 1 } \"A struct of 1, 1\"]
 .     [{ :x 1 :y (1 2 ?x) } x]))
 3
 ```

 ## Additional expressions in patterns
 Sometimes the built-in patterns are not enough and you need a little bit
 more power. Thankfully, one can use any expression in patterns in several
 forms: predicates, guards and views.

 ### Predicates and guards
 Predicates are formed by a symbol ending in a `?`. This symbol is looked
 up in the current scope and called with the value to be matched. If it
 returns a truthy value, then the pattern is considered to be matched.

 Guards are not dissimilar to predicates. They match a pattern against a
 value, bind the patterns metavariables and evaluate the expression, only
 succeeding if the expression evaluates to a truthy value.

 ```cl
 > (with (x \"foo\")
 .   (case x
 .     [(string? @ ?x) x]
 .     [?x (pretty x])))
 \"foo\"

 > (with (x \"foo\")
 .   (case x
 .     [(?x :when (string? ?x)) x]
 .     [?x (pretty x)]))
 \"foo\"
 ```

 Note that the above expressions have the same functionality. Predicates
 are generally more concise, whilst guards are more powerful.

 ### Views

 Views are a way of implementing your own quasi-patterns. Simply put,
 they call an expression with the required value and match the returned
 value against a pattern.

 ```cl
 > ;; Declare a helper method for matching strings.
 > (defun matcher (ptrn)
 .    \"Create a function which matches its input against PTRN, returning
 .      `nil` or a list of captured groups.\"
 .    (lambda (str)
 .      (case (list (string/match str ptrn))
 .        [(nil) nil]
 .        [?x x])))

 > (with (x \"0x23\")
 .   (case x
 .     [((matcher \"0x(%d+)\") -> ?x) x]))
 (\"23\")
 ```

 You can see the view pattern in use on the last line: we create the view
 with `(matcher \"0x(%d+)\")`, apply it to `x` and then match the
 returned value (`(\"23\")`) against the `?x` pattern.

 ### The [[case]] expression

 Bodies in case may be either of the form `[pattern exps]` or
 `[pattern => exps]`. In the latter case, the form matched against is
 bound, in its entirety, to the variable `it`."


(import core/base (defun defmacro if get-idx and gensym error for set-idx!
                  quasiquote list or slice concat apply /= n = not - + / * >= <= mod ..
                  else splice))
(import core/binders (let*))
(import core/list (car caddr cadr cdr cddr append for-each map filter
                   push! range snoc nth last elem? flat-map cons))
(import core/method (eq? eql? pretty))
(import core/string (char-at sub))
(import core/type (list? symbol? key? string? boolean? number? table?))

(import lua/basic (pcall))
(import lua/math (max))

(defun cons-pattern? (pattern) :hidden
  (and (list? pattern)
       (symbol? (nth pattern (- (n pattern) 1)))
       (eq? (nth pattern (- (n pattern) 1)) '.)))

(defun cons-pat-left-side (pattern) :hidden
  (slice pattern 1 (- (n pattern) 2)))

(defun cons-pat-right-side (pattern) :hidden
  (last pattern))

(defun meta? (symbol) :hidden
  (and (symbol? symbol)
       (eq? (char-at (get-idx symbol "contents") 1) "?")))

(defun pattern-length (pattern correction) :hidden
  (let* [(len 0)]
    (cond
      [(list? pattern)
       (for i 1 (n pattern) 1
         (if (and (list? (nth pattern i))
                  (eq? (car (nth pattern i)) 'optional))
           0
           (set! len (+ len 1))))]
      [(meta? pattern) 1]
      [else 0])
    (+ len correction)))

(defun pattern-# (pat) :hidden
  (cond
    [(cons-pattern? pat) (pattern-length pat -2)]
    [(and (list? pat)
          (eql? '$ (car pat)))
     (pattern-length pat -3)]
    [else (pattern-length pat 0)]))

(defun predicate? (x) :hidden
  (let* [(x (get-idx x :contents))]
    (= (char-at x (n x)) "?")))

(defun struct-pat? (x) :hidden
  (and (eql? (car x) 'struct-literal)
       (= (mod (n (cdr x)) 2) 0)))

(defun assert-linearity! (pat seen) :hidden
  (cond
    [(not seen) (assert-linearity! pat {})]
    [(list? pat)
     (cond
       [(eql? (cadr pat) '@)
        (assert-linearity! (caddr pat) seen)]
       [(eql? (cadr pat) ':when)
        (assert-linearity! (car pat) seen)]
       [(eql? (cadr pat) '->)
        (assert-linearity! (caddr pat) seen)]
       [(eql? (car pat) 'optional)
        (assert-linearity! (cadr pat) seen)]
       [(eql? (car pat) '$)
        (assert-linearity! (cddr pat) seen)]
       [(struct-pat? pat)
        (for i 3 (n pat) 2
          (assert-linearity! (nth pat i) seen))]
       [(cons-pattern? pat)
        (let* [(seen '())]
          (for i 1 (pattern-# pat) 1
            (assert-linearity! (nth pat i) seen))
          (assert-linearity! (get-idx pat (n pat)) seen))]
       [else
        (let* [(seen '())]
          (for i 1 (n pat) 1
            (assert-linearity! (nth pat i) seen)))])]
    [(or (and (not (meta? pat)) (symbol? pat))
         (and (symbol? pat) (or (eq? pat '_)
                                (eq? pat 'else)))
         (number? pat)
         (string? pat)
         (boolean? pat)
         (eq? pat 'nil))
     true]
    [(meta? pat)
     (if (get-idx seen (get-idx pat :contents))
       (error (.. "pattern is not linear: seen " (pretty pat) " more than once"))
       (set-idx! seen (get-idx pat :contents) true))]
    [else true]))

(defun compile-pattern-test (pattern symb)
  :hidden
  (cond
    [(list? pattern)
     (cond
       [(eql? (cadr pattern) '@)
        (compile-pattern-test (car pattern) symb)]
       [(eql? (cadr pattern) '->)
        (compile-pattern-test (caddr pattern) `(,(car pattern) ,symb))]
       [(eql? (car pattern) '$)
        (let* [(sym (gensym))]
          `(and ((get-idx ,(cadr pattern) :test) ,symb)
             (let* [(,sym (,(cadr pattern) ,symb))]
               ,@(map (lambda (x k)
                        (compile-pattern-test x `(nth ,sym ,k)))
                      (cddr pattern)
                      (range :from 1 :to (n (cddr pattern)))))))]
       [(eql? (cadr pattern) ':when)
        `(and ,(compile-pattern-test (car pattern) symb)
              (let* ,(cons (list 'it symb)
                           (compile-pattern-bindings (car pattern) symb))
                ,(caddr pattern)))]
       [(eql? (car pattern) 'optional)
        `(if ,symb ,(compile-pattern-test (cadr pattern) symb) true)]
       [(struct-pat? pattern)
        `(and (table? ,symb)
              ,@(let* [(out '(true))]
                  (for i 2 (n pattern) 2
                    (push! out (compile-pattern-test
                                     (nth pattern (+ 1 i))
                                     `(get-idx ,symb ,(nth pattern i))))
                    (push! out `(get-idx ,symb ,(nth pattern i))))
                  out))]
       [(cons-pattern? pattern)
        (let* [(pattern-sym (gensym))
               (lhs (cons-pat-left-side pattern))
               (rhs (cons-pat-right-side pattern))
               (lhs-test '())]
          (for i 1 (n lhs) 1
            (push! lhs-test
                       (compile-pattern-test (nth lhs i)
                                             `(nth ,pattern-sym ,i))))
          `(let* [(,pattern-sym ,symb)]
             (and (list? ,pattern-sym)
                  (>= (n ,pattern-sym) ,(pattern-length pattern -2))
                  ,@lhs-test
                  ,(compile-pattern-test
                     (last pattern) `(slice ,pattern-sym ,(+ 1 (n lhs)))))))]
       [else
        (let* [(out '())
               (sym (gensym))]
          (for i 1 (n pattern) 1
            (push! out (compile-pattern-test (nth pattern i)
                                                `(nth ,sym ,i))))
          `(let* [(,sym ,symb)]
             (and (list? ,sym)
                  (>= (n ,sym) ,(pattern-length pattern 0))
                  (<= (n ,sym) ,(n pattern))
                  ,@out)))])]
    [(or (eq? 'else pattern) (eq? '_ pattern) (meta? pattern))
     `true]
    [(and (not (meta? pattern)) (symbol? pattern))
     (cond
       [(eq? pattern 'true) `(= ,symb true)]
       [(eq? pattern 'false) `(= ,symb false)]
       [(eq? pattern 'nil) `(= ,symb nil)]
       [(predicate? pattern) `(,pattern ,symb)]
       [else `(eq? ,symb ',pattern)])]
    [(key? pattern)
     `(eq? ,symb ,pattern)]
    [(or (number? pattern) (boolean? pattern) (string? pattern))
     `(= ,symb ,pattern)]
    [else (error (.. "unsupported pattern " (pretty pattern)))]))

(defun compile-pattern-bindings (pattern symb) :hidden
  (filter (lambda (x) (/= (n x) 0))
    (cond
      [(list? pattern)
       (cond
         [(eql? (cadr pattern) '@)
          `(,@(compile-pattern-bindings (caddr pattern) symb) ,@(compile-pattern-bindings (car pattern) symb))]
         [(eql? (cadr pattern) ':when)
          (compile-pattern-bindings (car pattern) symb)]
         [(eql? (cadr pattern) '->)
          (compile-pattern-bindings (caddr pattern) `(,(car pattern) ,symb))]
         [(eql? (car pattern) '$)
          (let* [(sym (gensym))]
            (cons `(,sym (,(cadr pattern) ,symb))
                  (compile-pattern-bindings (cddr pattern) sym)))]
         [(eql? (car pattern) 'optional)
          (compile-pattern-bindings (cadr pattern) symb)]
         [(struct-pat? pattern)
          (let* [(out '())]
            (for i 2 (n pattern) 2
              (for-each elem (compile-pattern-bindings (nth pattern (+ i 1))
                                                       `(get-idx ,symb ,(nth pattern i)))
                (push! out elem)))
            out)]
         [(cons-pattern? pattern)
          (let* [(lhs (cons-pat-left-side pattern))
                 (rhs (cons-pat-right-side pattern))
                 (lhs-bindings '())]
            (for i 1 (n lhs) 1
              (for-each elem (compile-pattern-bindings (nth lhs i) `(nth ,symb ,i))
                (push! lhs-bindings elem)))
            (append lhs-bindings (compile-pattern-bindings rhs `(slice ,symb ,(+ 1 (n lhs))))))]
         [else
          (let* [(out '())]
            (for i 1 (n pattern) 1
              (for-each elem (compile-pattern-bindings (nth pattern i) `(nth ,symb ,i))
                (push! out elem)))
            out)])]
      [(meta? pattern)
       `((,{ :tag "symbol" :contents (sub (get-idx pattern "contents") 2) } ,symb))]
      [(or (number? pattern) (boolean? pattern) (string? pattern) (key? pattern) (eq? pattern '_) (and (not (meta? pattern)) (symbol? pattern)))
       '()]
      [else (error (.. "unsupported pattern " (pretty pattern)))])))


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
             (cond
               [(eql? '=> (cadr pt))
                `(,(compile-pattern-test (car pt) val-sym)
                   (let* ,(cons (list 'it val-sym)
                                (compile-pattern-bindings (car pt) val-sym))
                     ,@(cddr pt)))]
               [else
                 `(,(compile-pattern-test (car pt) val-sym)
                    (let* ,(compile-pattern-bindings (car pt) val-sym)
                      ,@(cdr pt)))])))]
    `(let* [(,val-sym ,val)]
       (cond ,@(map compile-arm pts)
             [else ,(generate-case-error pts val-sym)]))))

(defmacro matches? (pt x)
  "Test if the value X matches the pattern PT.

   Note that, since this does not bind anything, all metavariables may be
   replaced by `_` with no loss of meaning."
  (compile-pattern-test pt x))

(defun ->meta (x) :hidden
  { :tag "symbol" :contents (.. "?" (get-idx x :contents)) })

(defmacro handler-case (x &body)
  "Evaluate the form X, and if an error happened, match the series
   of `(?pattern . ?body)` arms given in BODY against the value of
   the error, executing the first that succeeeds.

   In the case that X does not throw an error, the value of that
   expression is returned by [[handler-case]].

   ### Example:

   ```cl
   > (handler-case
   .   (fail! \"oh no!\")
   .   [string?
   .    => (print! it)])
   oh no!
   out = nil
   ```"
  (let* [(ok (gensym))
         (val (gensym))
         (err (gensym))
         (error-handler `(lambda (,err)
                           (case ,err
                             ,@body
                             [else (error ,err 2)])))]
    `(let* [(,val (list (pcall (lambda () ,x))))
            (,ok (car ,val))]
       (if ,ok
         (splice (cdr ,val))
         (,error-handler (cadr ,val))))))

(defmacro function (&arms)
  "Create a lambda which matches its arguments against the patterns
   defined in ARMS."
  (let* [(rest-sym (gensym "remaining-arguments"))
         (rest { :tag :symbol
                 :display-name (get-idx rest-sym :display-name)
                 :contents (.. "&" (get-idx rest-sym :contents)) })
         (param-n (apply max (map (lambda (x)
                                    (pattern-# (car x)))
                               arms)))
         (param-nams (map gensym (range :from 1 :to param-n)))]
    `(lambda ,(snoc param-nams rest)
       (case (append (list ,@param-nams) ,rest-sym)
         ,@arms))))

(defmacro if-match (cs t e)
  "Matches a pattern against a value defined in CS, evaluating T with the
   captured variables in scope if the pattern succeeded, otherwise
   evaluating E.

   [[if-match]] is to [[case]] what [[if]] is to `cond`."
  (let* [(x (gensym))]
    `(let* [(,x ,(cadr cs))]
       (if ,(compile-pattern-test (car cs) x)
         (let* ,(compile-pattern-bindings (car cs) x)
           ,t)
         ,e))))
