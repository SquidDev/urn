(import extra/assert ())
(import extra/test ())

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
    (eq? (cons 0 '(1 2 3)) '(0 1 2 3)))

  (it "can execute a for loop"
    (eq? (with (x 0)
           (for i 0 9 1
             (set! x (+ x 1)))
           x) 10))

  (it "can branch based on a condition"
    (eq? (let [(x 0) (b true)]
      (if (! b)
        (set! x 2)
        (set! x 8))
      x) 8))

  (it "can create a list from variadic arguments"
    (eq? (list 1 2 3 4) '(1 2 3 4)))

  (it "can convert a value to a lisp expression"
    (affirm (eq? (pretty 3) "3")
            (eq? (pretty "abc") "\"abc\"")
            (eq? (pretty true) "true")
            (eq? (pretty false) "false"))))
