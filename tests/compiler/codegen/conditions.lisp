(import test ())
(import tests/compiler/codegen/codegen-helpers ())

(describe "The codegen"
  (will "simplify elseif branches"
    (affirm-codegen
      '((cond
          [foo 0]
          [bar 1]))
      "if foo then
         return 0
       elseif bar then
         return 1
       else
         _error(\"unmatched item\")
       end")
    (affirm-codegen
      '((cond
          [foo 0]
          [bar 1]
          [true true]))
      "if foo then
         return 0
       elseif bar then
         return 1
       else
         return true
       end")
    (affirm-codegen
      '((cond
          [foo 0]
          [true true]
          [bar 1]))
      "if foo then
         return 0
       else
         return true
       end")
    (affirm-codegen
      '((cond
          [true true]
          [foo 0]
          [foo 1]))
      "do
         return true
       end"))

  (will "handle nested conds"
    (affirm-codegen
      '((cond
          [(cond
             [foo 0]
             [bar false]) 1]
          [true 2]))
      "local temp
       if foo then
         temp = 0
       elseif bar then
         temp = false
       else
         _error(\"unmatched item\")
       end
       if temp then
         return 1
       else
         return 2
       end")
    (affirm-codegen
      '((cond
          [(cond
             [foo 0]
             [bar 10]) 1]
          [(cond
             [foo 0]
             [bar 10]) 2]
          [(cond
             [foo 0]
             [bar 10]) 3]
          [true 1]))
      "local temp
       if foo then
         temp = 0
       elseif bar then
         temp = 10
       else
         _error(\"unmatched item\")
       end
       if temp then
         return 1
       else
         local temp
         if foo then
           temp = 0
         elseif bar then
           temp = 10
         else
           _error(\"unmatched item\")
         end
         if temp then
           return 2
         else
           local temp
           if foo then
             temp = 0
           elseif bar then
             temp = 10
           else
             _error(\"unmatched item\")
           end
           if temp then
             return 3
           else
             return 1
           end
         end
       end"))

  (will "handle deeply nested conds"
    (affirm-codegen
      '((cond
         [(cond
            [(cond
               [(cond [foo 0]) 1]) 2]) 3]))
      "local temp
       local temp1
       local temp2
       if foo then
         temp2 = 0
       else
         _error(\"unmatched item\")
       end
       if temp2 then
         temp1 = 1
       else
         _error(\"unmatched item\")
       end
       if temp1 then
         temp = 2
       else
         _error(\"unmatched item\")
       end
       if temp then
         return 3
       else
         _error(\"unmatched item\")
       end"))

  (section "will emit and expressions"
    (it "which are simple"
      (affirm-codegen
        '((cond
            [foo bar]
            [true foo]))
        "return foo and bar")
      (affirm-codegen
        '((cond
            [foo bar]
            [true false]))
        "if foo then
           return bar
         else
           return false
         end")
      (affirm-codegen
        '((cond
            [(cond
               [foo bar]
               [true false]) 1]
            [true 2]))
        "if foo and bar then
           return 1
         else
           return 2
         end"))

    (it "which are nested"
      (affirm-codegen
        '((cond
            [foo (cond
                   [bar 2]
                   [true bar])]
            [true foo]))
        "return foo and (bar and 2)"))

    (it "with a directly called lambda"
      (affirm-codegen
        '(((lambda (x)
             (cond
               [x bar]
               [true x]))
            foo))
        "return foo and bar")

      (affirm-codegen
        '(((lambda (x)
             (cond
               [x (bar x)]
               [true x]))
            foo))
        "local x = foo
         return x and bar(x)")))

  (section "will emit or expressions"
    (it "which are simple"
      (affirm-codegen
        '((cond
            [foo foo]
            [true bar]))
        "return foo or bar")
      (affirm-codegen
        '((cond
            [foo true]
            [true bar]))
        "if foo then
           return true
         else
           return bar
         end")
      (affirm-codegen
        '((cond
            [(cond
               [foo true]
               [true bar]) 1]
            [true 2]))
        "if foo or bar then
           return 1
         else
           return 2
         end"))

    (it "which are nested"
      (affirm-codegen
        '((cond
            [foo foo]
            [true (cond
                   [bar bar]
                   [true 2])]))
        "return foo or (bar or 2)"))

    (it "which are sequential"
      (affirm-codegen
        '((cond
            [foo foo]
            [bar bar]
            [true 2]))
        "return foo or bar or 2"))

    (it "with a directly called lambda"
      (affirm-codegen
        '(((lambda (x)
             (cond
               [x x]
               [true bar]))
            foo))
        "return foo or bar")

      (affirm-codegen
        '(((lambda (x)
             (cond
               [x x]
               [true (bar x)]))
            foo))
        "local x = foo
         return x or bar(x)"))

    (section "will handle a trailing `and`"
      (it "in the simple case"
        (affirm-codegen
          '((cond
              [foo foo]
              [bar bar]
              [baz qux]
              [true baz]))
          "return foo or bar or baz and qux"))

      (it "with a directly called lambda"
        (affirm-codegen
          '(((lambda (x)
               (cond
                 [x x]
                 [bar (foo 3)]
                 [true bar])) (foo 2)))
          "return foo(2) or bar and foo(3)"))

      (it "inside a condition"
        (affirm-codegen
          '((cond
              [(cond
                 [foo foo]
                 [bar baz]
                 [true bar]) 1]
              [true 2]))
          "if foo or bar and baz then
             return 1
           else
             return 2
           end")))

    (section "will handle a trailing `or not`"
      (it "in the simple case"
        '((cond
            [foo foo]
            [bar bar]
            [baz false]
            [true true]))
        "return foo or bar or not baz")

      (it "with a directly called lambda"
        '(((lambda (x)
             (cond
               [x x]
               [bar false]
               [true true])) (foo 2)))
        "return foo(2) or not bar")

      (it "inside a condition"
        (affirm-codegen
          '((cond
              [(cond
                 [foo foo]
                 [bar false]
                 [true true]) 1]
              [true 2]))
          "if foo or not bar then
             return 1
           else
             return 2
           end"))))

  (will "emit not expressions"
    (affirm-codegen
      '((cond
          [foo false]
          [true true]))
      "return not foo"))

  (will "invert if statements"
    (affirm-codegen
      '((cond
          [foo]
          [true (bar)])
         nil)
      "if not foo then
         bar()
       end
       return nil")
    (affirm-codegen
      '((cond
          [foo]
          [true (bar)]))
      "if foo then
         return nil
       else
         return bar()
       end"))

  (will "emit if statements in bindings"
    (affirm-codegen
      '(((lambda (x) (+ x 1))
          (cond
            [foo 1]
            [true 2])))
      "local x
       if foo then
         x = 1
       else
         x = 2
       end
       return x + 1")

    (affirm-codegen
      '(((lambda (x) (+ x 1))
          ((lambda (y)
             (cond
               [y 1]
               [true 2]))
             3)))
      "local x
       local y = 3
       if y then
         x = 1
       else
         x = 2
       end
       return x + 1")))
