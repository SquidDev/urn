(import test ())

(describe "An associated list"
  (can "be indexed"
    (with (li '((:foo "x") (:bar "y")))
      (affirm (= "x" (assoc li :foo))
              (= "y" (assoc li :bar))
              (= nil (assoc li :baz))
              (= "z" (assoc li :baz "z"))
              (= nil (assoc '() :foo))
              (= "z" (assoc '() :foo "z"))
              (= nil (assoc 'x ':foo))
              (= "z" (assoc 'x ':foo "z")))))
  (can "be identified"
          (with (li '((:foo "x") (:bar "y")))
            (affirm (= true (assoc? li :foo))
                    (= true (assoc? li :bar))
                    (= false (assoc? li :baz))
                    (= false (assoc? '() :foo))
                    (= false (assoc? 'x :foo)))))

  (can "may be inserted into"
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
      (affirm (= (assoc li :foo) (.> st :foo))
              (/= (assoc li :foo) (.> st :bar)))))

  (can "be created from a structure"
    (let* [(st { :foo "x" :bar "y" :foo "z" })
           (li (struct->assoc st))]
      (affirm (= (.> st :foo) (assoc li :foo))
              (/= (.> st :bar) (assoc li :foo))))))
