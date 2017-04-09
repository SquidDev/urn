(import extra/assert())
(import extra/test ())

(describe "A table"
  [may "be an alist"
    (is "indexable"
        (with (li '((:foo "x") (:bar "y")))
          (affirm (= "x" (assoc li :foo))
                  (= "y" (assoc li :bar))
                  (= nil (assoc li :baz))
                  (= "z" (assoc li :baz "z"))
                  (= nil (assoc '() :foo))
                  (= "z" (assoc '() :foo "z"))
                  (= nil (assoc 'x ':foo))
                  (= "z" (assoc 'x ':foo "z")))))
    (will "be identifiable"
          (with (li '((:foo "x") (:bar "y")))
            (affirm (= true (assoc? li :foo))
                    (= true (assoc? li :bar))
                    (= false (assoc? li :baz))
                    (= false (assoc? '() :foo))
                    (= false (assoc? 'x :foo)))))

    (can "be inserted into"
         (let [(li '()) (li' '())]
           (affirm (= nil (assoc li :foo))
                   (= nil (assoc li :bar)))
           (set! li' (insert li :foo "x"))
           (affirm (= "x" (assoc li' :foo))
                   (= nil (assoc li' :bar))
                   (= nil (assoc li :foo))
                   (= nil (assoc li :bar)))
           (set! li' (insert li' :bar "y"))
           (affirm (= "x" (assoc li' :foo))
                   (= "y" (assoc li' :bar)))
           (set! li' (insert li' :foo "z"))
           (affirm (= "x" (assoc li' :foo))
                   (= "y" (assoc li' :bar)))))
    (can "be converted to a structure"
      (let* [(li '((:foo "x") (:bar "y") (:foo "z")))
             (st (assoc->struct li))]
        (affirm (= (assoc li :foo) (get-idx st :foo))
                (/= (assoc li :foo) (get-idx st :bar)))))
  ]

  [may "be a structure"
    (can "be created"
         (with (st (struct :foo "x" :bar "y"))
           (affirm (= "x" (get-idx st :foo))
                   (= "y" (get-idx st :bar)))))
    (can "be mutated"
         (with (st (struct :foo "x"))
           (set-idx! st :bar "y")
           (set-idx! st :foo "z")
           (affirm (= "z" (get-idx st :foo))
                   (= "y" (get-idx st :bar)))))
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
           (.<! st :foo :bar (empty-struct :baz "x"))
           (set-idx! st :foo "z")
           (affirm (= "z" (get-idx st :foo :bar :baz))
                   (= "y" (get-idx st :bar)))))
    (can "be converted to an alist"
      (let* [(st (struct :foo "x" :bar "y" :foo "z"))
             (li (struct->assoc st))]
        (affirm (= (get-idx st :foo) (assoc li :foo))
                (/= (get-idx st :bar) (assoc li :foo)))))
    (can "be converted to a list"
      (let* [(st (struct 1 "x" 2 "y" 3 "z"))
             (li (struct->list st))]
        (affirm (= (nth li 1) "x")
                (= (nth li 2) "y")
                (= (nth li 3) "z"))))
    (will "be a constant size"
      (affirm (= 0 (#keys {}))
              (= 0 (#keys (struct)))
              (= 1 (#keys (struct :foo "x")))
              (= 2 (#keys (struct :foo "x" :bar "y")))))
    (will "be empty"
          (affirm (empty-struct? {})
                  (empty-struct? (struct))
                  (empty-struct? (struct :foo nil))))
    (will "not be empty"
          (affirm (! (empty-struct? (struct :foo "x")))
                  (! (empty-struct? (struct :foo false)))
                  (! (empty-struct? (struct :foo {})))))])
