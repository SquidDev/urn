(import extra/assert ())
(import extra/test ())
(import extra/check ())

(describe "The base library"
  (it "can unwrap values"
    (affirm (eq? 23 (const-val (struct :tag "number" :value 23)))
            (eq? "foo" (const-val (struct :tag "string" :value "foo")))
            (eq? 'foo (const-val 'foo))
            (neq? false (const-val (struct :tag "boolean" :value false)))
            (eq? "foo" (const-val "foo"))))

  (it "has quasiquote"
    (affirm (eq? '12 ~12)
            (eq? 'foo ~foo)
            (eq? '(1 2 3) ~(1 2 3))
            (eq? '(1 2 5) ~(1 2 ,(+ 2 3)))))

  (it "can negate expressions"
    (affirm (eq? (! false) true)
            (eq? (! true) false)))

  (it "can get the length of lists"
    (affirm (eq? (# '(1 2 3 4)) 4)
            (eq? (# '()) 0)))

  (it "can logical AND two boolean values"
    (affirm (eq? (and false false) false)
            (eq? (and true true) true)
            (eq? (and true false) false)
            (eq? (and false true) false)))

  (it "can logical OR two boolean values"
    (affirm (eq? (or false false) false)
            (eq? (or true true) true)
            (eq? (or true false) true)
            (eq? (or false true) true)))

  (it "can add a value to the start of a list"
    (check [(number a) (number b) (number c) (number d)] (eq? (cons d '(a b c)) '(d a b c)))
    (check [(number n)] (eq? (cons n '()) '(n))))

  (it "can execute a for loop"
    (affirm (eq? (with (x 0)
              (for i 0 9 1
                (set! x (+ x 1)))
              x) 10)))

  (it "can branch based on a condition"
    (check [(number a) (number b)] (= (let [(x 0) (c false)]
                                        (if c
                                          (set! x a)
                                          (set! x b))
                                        x) b)))

  (it "can create a list from variadic arguments"
    (check [(number a) (number b) (number c)] (eq? (list a b c) '(a b c))))

  (it "can convert a value to a lisp expression"
    (affirm (eq? (pretty 3) "3")
            (eq? (pretty "abc") "\"abc\"")
            (eq? (pretty true) "true")
            (eq? (pretty false) "false"))))
