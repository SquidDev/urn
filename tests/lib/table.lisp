(import extra/assert())
(import extra/test ())

(describe "A table"
  [may "be an associated array"
    (is "indexable"
      (with (li '((:foo "x") (:bar "y")))
        [affirm (= "x" (assoc li :foo))
                (= "y" (assoc li :bar))
                (= nil (assoc li :baz))
                (= "z" (assoc li :baz "z"))
                (= nil (assoc '() :foo))
                (= "z" (assoc '() :foo "z"))
                (= nil (assoc 'x ':foo))
                (= "z" (assoc 'x ':foo "z"))]))
    (will "be identifiable"
      (with (li '((:foo "x") (:bar "y")))
        [affirm (= true (assoc? li :foo))
                (= true (assoc? li :bar))
                (= false (assoc? li :baz))
                (= false (assoc? '() :foo))
                (= false (assoc? 'x :foo))]))

    (can "be inserted into"
      (let [(li '()) (li' '())]
        [affirm (= nil (assoc li :foo))
                (= nil (assoc li :bar))]
        (set! li' (insert li :foo "x"))
        [affirm (= "x" (assoc li' :foo))
                (= nil (assoc li' :bar))
                (= nil (assoc li :foo))
                (= nil (assoc li :bar))]
        (set! li' (insert li' :bar "y"))
        [affirm (= "x" (assoc li' :foo))
                (= "y" (assoc li' :bar))]
        (set! li' (insert li' :foo "z"))
        [affirm (= "z" (assoc li' :foo))
        (= "y" (assoc li' :bar))]))
    ;; (can "be converted to a structure"
    ;;   ;; TODO: Use colon notation here
    ;;   (let* [(li '(("foo" "x") ("bar" "y") ("foo" "z")))
    ;;          (st (assoc->struct li))]
    ;;     (print! (pretty st))
    ;;     [affirm (= (assoc li :foo) (rawget st :foo))
    ;;             (= (assoc li :foo) (rawget st :bar))]))
  ]
  
  [may "be a structure"
    (can "be created"
      (with (st (struct :foo "x" :bar "y"))
        [affirm (= "x" (rawget st :foo))
                (= "y" (rawget st :bar))]))
    (can "be mutated"
      (with (st (struct :foo "x"))
        (rawset st :bar "y")
        (rawset st :foo "z")
        [affirm (= "z" (rawget st :foo))
                (= "y" (rawget st :bar))]))
    (can "be indexed"
      (with (st (struct :foo (struct :bar (struct :baz "x"))))
        [affirm (= "x" (.> st :foo :bar :baz))
                (= nil (.> st :foo :bar :qux))
                (= "table" (type (.> st :foo :bar)))
                (= "x" (.> st :foo (.. "b" "ar") :baz))]))
    (can "mutate children"
      (with (st (struct :foo "x"))
        (.<! st :bar "y")
        (.<! st :foo (empty-struct))
        (.<! st :foo :bar (empty-struct :baz "x"))
        (rawset st :foo "z")
        [affirm (= "z" (rawget st :foo :bar :baz))
                (= "y" (rawget st :bar))]))
    (will "be empty" [affirm
      (empty-struct? (empty-struct))
      (empty-struct? (struct))
      (empty-struct? (struct :foo nil))])

    (will "not be empty" [affirm
      (! (empty-struct? (struct :foo "x")))
      (! (empty-struct? (struct :foo false)))
      (! (empty-struct? (struct :foo (empty-struct))))])])
