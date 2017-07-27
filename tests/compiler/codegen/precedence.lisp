(import extra/test ())
(import extra/assert ())
(import tests/compiler/codegen/codegen-helpers ())

(describe "The codegen"
  (section "will correctly wrap calls"
    (it "of conditions"
      (affirm-codegen
        '(((cond
             [foo bar]
             [true foo]) 1 2))
        "return (foo and bar)(1, 2)")
      (affirm-codegen
        '(((cond
             [foo foo]
             [true bar]) 1 2))
        "return (foo or bar)(1, 2)")
      (affirm-codegen
        '(((cond
             [foo false]
             [true true]) 1 2))
        "return (not foo)(1, 2)"))

    (it "of quotes"
      ;; TODO: Remove one layer of quotes
      (affirm-codegen
        '(('(1 2) 1 2))
        "return (({tag = \"list\", n = 2, 1, 2}))(1, 2)")
      (affirm-codegen
        '((`(1 2) 1 2))
        "return (({tag = \"list\", n = 2, 1, 2}))(1, 2)"))

    (it "of const-struct"
      (affirm-codegen
        '(({ :a 1 } 1 2))
        "return ({[\"a\"]=1})(1, 2)"))

    (it "of constants"
      (affirm-codegen*
        '((1 1 2))
        "return (1)(1, 2)")))

  (section "will correctly wrap nested expressions"
    (it "with nots"
      (affirm-codegen
        '((cond
            [(+ 2 3) false]
            [true true]))
        "return not (2 + 3)"))

    (it "with and & or"
      (affirm-codegen
        '((+ (cond
               [foo bar]
               [true foo])
            (cond
              [foo foo]
              [true bar])))
        "return (foo and bar) + (foo or bar)"))

    (it "with operators"
      (affirm-codegen
        '((+ 2 3 (+ 4 5)))
        "return 2 + 3 + (4 + 5)")
      (affirm-codegen
        '((+ 2 3 (.. "foo" 5)))
        "return 2 + 3 + (\"foo\" .. 5)")
      (affirm-codegen
        '((.. "foo" (+ 2 3)))
        "return \"foo\" .. 2 + 3"))))
