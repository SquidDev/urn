(import extra/test ())
(import extra/assert ())

(describe "A value"
  (it "may or may not exist"
      (assert (= true (exists? 1))
              (= false (exists? nil))))
  [may "be a number"
       (will "exist"
             (assert (= true (exists? 1))
                     (= true (exists? 2))
                     (= true (exists? (^ 2 40)))))
       (will-not "be a list"
                 (assert (= false (list? 1))))
       (will-not "be a string"
                 (assert (= false (string? 1))))]
  [may "be a table"
       (may "be a list"
            (will "satisfy list?"
                  (assert (list? '(1 2 3 4))))
            (will-not "be a number"
                      (assert (= false
                                 (number? '(1 2 3)))))
            (will-not "be a string"
                      (assert (= false
                                 (string? '(1 2 3))))))
       (may "be a symbol"
            (will "satisfy symbol?"
                  (assert (symbol? 'sym)))
            (will-not "be a number"
                      (assert (= false (number? 'sym)))))
       (may "be a (quoted) key"
            (will "satisfy key?"
                  (assert (key? ':key)))
            (will-not "be a symbol"
                      (assert (= false (symbol? ':key)))))]
  [may "be a string"
       (will "satisfy string?"
             (assert (string? "foo")
                     (string? "bar")))
       (will-not "be a number"
                 (assert (= false (number? "foo"))))]
  [may "not exist"
       (will-not "be a number"
                 (assert (= false (number? nil))))
       (will-not "be a string"
                 (assert (= false (string? nil))))
       (will "be nil"
             (assert (= nil nil)))]

  )
