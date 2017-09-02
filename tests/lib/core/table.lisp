(import test ())

(describe "A table"
  [may "be a structure"
    (can "be created"
         (with (st (struct :foo "x" :bar "y"))
           (affirm (= "x" (.> st :foo))
                   (= "y" (.> st :bar)))))
    (can "be mutated"
         (with (st (struct :foo "x"))
           (.<! st :bar "y")
           (.<! st :foo "z")
           (affirm (= "z" (.> st :foo))
                   (= "y" (.> st :bar)))))
    (can "be indexed"
         (with (st (struct :foo (struct :bar (struct :baz "x"))))
           (affirm (= "x" (.> st :foo :bar :baz))
                   (= nil (.> st :foo :bar :qux))
                   (= "table" (type (.> st :foo :bar)))
                   (= "x" (.> st :foo (.. "b" "ar") :baz)))))
    (can "mutate children"
         (with (st (struct :foo "x"))
           (.<! st :bar "y")
           (.<! st :foo {})
           (.<! st :foo :bar { :baz "x" })
           (.<! st :foo "z")
           (affirm (= "z" (.> st :foo))
                   (= "y" (.> st :bar)))))
    (can "be converted to a list"
      (let* [(st (struct 1 "x" 2 "y" 3 "z"))
             (li (struct->list st))]
        (affirm (= (nth li 1) "x")
                (= (nth li 2) "y")
                (= (nth li 3) "z"))))
    (will "be a constant size"
      (affirm (= 0 (nkeys {}))
              (= 0 (nkeys (struct)))
              (= 1 (nkeys (struct :foo "x")))
              (= 2 (nkeys (struct :foo "x" :bar "y")))))
    (will "be empty"
          (affirm (empty-struct? {})
                  (empty-struct? (struct))
                  (empty-struct? (struct :foo nil))))
    (will "not be empty"
          (affirm (not (empty-struct? (struct :foo "x")))
                  (not (empty-struct? (struct :foo false)))
                  (not (empty-struct? (struct :foo {})))))])
