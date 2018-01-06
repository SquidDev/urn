(import test ())

(describe "A value"
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
                 (neq? '(1 (3 4 5)) '(1 (3 4)))))])
