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
            (eq? '(1 2 5) ~(1 2 ,(+ 2 3))))))
