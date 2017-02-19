(import extra/test ())
(import extra/assert ())
(import string ())

(describe "A string"
  (it "has a constant length"
    (assert (= (#s "") 0)
            (= (#s "foo") 3)))
  (it "equals itself"
    (assert (= "" "")
            (= "foo" "foo")
            (= "foo" '"foo")
            (= "foo" "f\111\111")))
  (it "can be indexed"
    (assert (= "a" (char-at "abc" 1))
            (= "b" (char-at "abc" 2))
            (= "c" (char-at "abc" -1))
            (= "" (char-at "abc" 4))
            (= "" (char-at "abc" -4))
            (= "" (char-at "" 1))))
  (it "can be concatenated"
    (assert (= "abc" (.. "a" "b" "c"))
            (= "foo-bar-baz" (.. "foo" "-" "bar" "-" "baz"))))
  (it "can be split"
    (assert (= '("foo" "bar" "baz") (split "foo-bar-baz" "-"))
            (= '("foo" "bar-baz") (split "foo-bar-baz" "-" 1))
            (= '("foo" "bar" "") (split "foo-bar-" "-"))
            (= '("" "foo" "bar") (split "-foo-bar" "-"))))
            ;; (= '("foo" "" "" "bar") (split "foo--bar" "-"))
  (it "can be quoted"
    (assert (= "\"foo\"" (quoted "foo"))
            (= "\"\\9\"" (quoted "\t"))
            (= "\"\\n\"" (quoted "\n")))))
