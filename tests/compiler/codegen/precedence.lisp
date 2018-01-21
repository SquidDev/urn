(import test ())
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

    (it "of statements"
      (affirm-codegen
        '((foo ((lambda () 1))))
        "return foo((function()
           return 1
         end)())")
      (affirm-codegen
        '((((lambda (x) x) (cond [true 1])) 1 2))
        "return (function()
           local x
           do
             x = 1
           end
           return x
         end)()(1, 2)")
      (affirm-codegen
        '((((lambda (x) (cond [x x] [true 2])) (cond [true 1])) 1 2))
        "return (function()
           local x
           do
             x = 1
           end
           return x or 2
         end)()(1, 2)")
      (affirm-codegen
        '((((lambda (x) (cond [x 2] [true x])) (cond [true 1])) 1 2))
        "return (function()
           local x
           do
             x = 1
           end
           return x and 2
         end)()(1, 2)")
      (affirm-codegen
        '((((lambda (x) (cond [x false] [true true])) (cond [true 1])) 1 2))
        "return (function()
           local x
           do
             x = 1
           end
           return not x
         end)()(1, 2)"))

    (it "of quotes"
      (affirm-codegen
        '(('(1 2) 1 2))
        "return ({tag=\"list\", n=2, 1, 2})(1, 2)")
      (affirm-codegen
        '((`(1 2) 1 2))
        "return ({tag=\"list\", n=2, 1, 2})(1, 2)"))

    (it "of struct-literal"
      (affirm-codegen
        '(({ :a 1 } 1 2))
        "return ({a=1})(1, 2)"))

    (it "of constants"
      (affirm-codegen*
        '((1 1 2))
        "return (1)(1, 2)"))

    (it "of symbols"
      (affirm-codegen
        '((true 1 2))
        "return (true)(1, 2)")))

  (section "will correctly indexed"
    (it "constants"
      (affirm-codegen
        '((get-idx 1 2))
        "return (1)[2]")
      (affirm-codegen
        '((get-idx foo 2))
        "return foo[2]"))
    (it "quotes"
      (affirm-codegen
        '((get-idx '(1 2 3) 2))
        "return ({tag=\"list\", n=3, 1, 2, 3})[2]")))

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
