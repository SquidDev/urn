(import test ())
(import core/string ())

(describe "A string"
  (it "has a constant length"
    (affirm (eq? (n "") 0)
            (eq? (n "foo") 3)))
  (it "equals itself"
    (affirm (eq? "" "")
            (eq? "foo" "foo")
            (eq? "foo" '"foo")
            (eq? "foo" "f\111\111")))
  (it "can be indexed"
    (affirm (eq? "a" (char-at "abc" 1))
            (eq? "b" (char-at "abc" 2))
            (eq? "c" (char-at "abc" -1))
            (eq? "" (char-at "abc" 4))
            (eq? "" (char-at "abc" -4))
            (eq? "" (char-at "" 1))))
  (it "can be concatenated"
    (affirm (eq? "abc" (.. "a" "b" "c"))
            (eq? "foo-bar-baz" (.. "foo" "-" "bar" "-" "baz"))))
  (it "can be concatenated from a list"
    (affirm (eq? "abc" (concat '("a" "b" "c")))
            (eq? "a b c" (concat '("a" "b" "c") " "))
            (eq? "bc" (concat (cdr '("a" "b" "c"))))))
  (it "can be split"
    (affirm (eq? '("foo" "bar" "baz") (split "foo-bar-baz" "-"))
            (eq? '("foo" "bar-baz") (split "foo-bar-baz" "-" 1))
            (eq? '("foo" "bar" "") (split "foo-bar-" "-"))
            (eq? '("" "foo" "bar") (split "-foo-bar" "-"))
            (eq? '("foo" "" "bar") (split "foo--bar" "-"))
            (eq? '("f" "o" "o") (split "foo" ""))))
  (it "can be quoted"
    (affirm (eq? "\"foo\"" (quoted "foo"))
            (eq? "\"\\9\"" (quoted "\t"))
            (eq? "\"\\n\"" (quoted "\n"))))
  (it "can be trimmed"
    (affirm (eq? "test" (trim "\n\t test \t\r\n")))))
