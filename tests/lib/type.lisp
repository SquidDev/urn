(import extra/test ())
(import extra/assert ())

(describe "A value"
  (it "may or may not exist"
      (affirm (= true (exists? 1))
              (= false (exists? nil))))
  [may "be a number"
       (will "exist"
             (affirm (= true (exists? 1))
                     (= true (exists? 2))
                     (= true (exists? (^ 2 40)))))
       (will-not "be a list"
                 (affirm (= false (list? 1))))
       (will-not "be a string"
                 (affirm (= false (string? 1))))]
  [may "be a table"
       (may "be a list"
            (will "satisfy list?"
                  (affirm (list? '(1 2 3 4))))
            (will-not "be a number"
                      (affirm (= false
                                 (number? '(1 2 3)))))
            (will-not "be a string"
                      (affirm (= false
                                 (string? '(1 2 3))))))
       (may "be a symbol"
            (will "satisfy symbol?"
                  (affirm (symbol? 'sym)))
            (will-not "be a number"
                      (affirm (= false (number? 'sym)))))
       (may "be a (quoted) key"
            (will "satisfy key?"
                  (affirm (key? ':key)))
            (will-not "be a symbol"
                      (affirm (= false (symbol? ':key)))))]
  [may "be a string"
       (will "satisfy string?"
             (affirm (string? "foo")
                     (string? "bar")))
       (will-not "be a number"
                 (affirm (= false (number? "foo"))))]
  [may "not exist"
       (will-not "be a number"
                 (affirm (= false (number? nil))))
       (will-not "be a string"
                 (affirm (= false (string? nil))))
       (will "be nil"
             (affirm (= nil nil)))]

  [may "be equated"
       (it "with constants"
         (affirm (eq? "hello" "hello")
                 (eq? 123 123)
                 (eq? true true)
                 (eq? nil nil)
                 (neq? "hello" "world")
                 (neq? 123 455)
                 (neq? true false)
                 (neq? nil false)))
       (it "with symbols"
         (affirm (eq? 'foo 'foo)
                 (eq? 'foo "foo")
                 (eq? "foo" 'foo)
                 (neq? 'foo 'bar)
                 (neq? 'foo "bar")
                 (neq? "foo" 'bar)
                 (neq? 'foo 123)
                 (neq? 'nil nil)
                 (neq? 'true true)
                 (neq? 123 'foo)))
       (it "with keys"
         (affirm (eq? ':foo ':foo)
                 (eq? ':foo :foo)
                 (eq? :foo ':foo)
                 (neq? ':foo ':bar)
                 (neq? ':foo :bar)
                 (neq? :foo ':bar)
                 (neq? ':foo 123)
                 (neq? 123 ':foo)))
       (it "with lists"
         (affirm (eq? '(1 2 3) '(1 2 3))
                 (eq? '(1 (3 4 5)) '(1 (3 4 5)))
                 (neq? '(1 (3 4 5)) '(1 (3 4)))))]
  )
