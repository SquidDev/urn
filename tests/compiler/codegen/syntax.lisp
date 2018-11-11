(import test ())
(import tests/compiler/codegen/codegen-helpers ())

(describe "The codegen will generate syntactically valid Lua for"
  (section "symbols that are"
    (it "empty"
      (affirm-codegen
        ~((define ,(string->symbol "") 2))
        "_e = 2"))
    (it "numbers"
      (affirm-codegen
        ~((define ,(string->symbol "23") 2))
        "_e23 = 2")
      (affirm-codegen
        ~((define ,(string->symbol "23.0") 2))
        "_e23_2e_0 = 2"))
    (it "underscores"
      (affirm-codegen
        ~((define ,(string->symbol "_G") 2))
        "_5f_G = 2")
      (affirm-codegen
        ~((define ,(string->symbol "G_G") 2))
        "G_5f_G = 2"))
    (it "keywords"
      (affirm-codegen
        ~((define ,(string->symbol "and") 2))
        "_eand = 2"))
    (it "symbols"
      (affirm-codegen
        ~((define ,(string->symbol "a+") 2))
        "a_2b_ = 2")
      (affirm-codegen
        ~((define ,(string->symbol "+-") 2))
        "_2b2d_ = 2"))
    (it "hyphenated"
      (affirm-codegen
        ~((define ,(string->symbol "foo-bar") 2))
        "fooBar = 2")))

  (pending "semi-colons between function calls"
    (affirm-codegen
      '((foo) ((cond [foo foo] [true bar])) 1)
      "foo();
       (foo or bar)()
       return 1"))

  (section "setters in"
    (it "arguments"
      (affirm-codegen
        '((lambda (x)
            (foo (set! x 1))))
        "return function(x)
           return foo((function()
             x = 1
           end)())
         end"))

    (it "functions"
      (affirm-codegen
        '((lambda (x)
            ((set! x 1) 1)))
        "return function(x)
           return (function()
             x = 1
           end)()(1)
         end"))

    (it "arguments"
      (affirm-codegen
        '((lambda (x)
            (set! x (set! x 1))))
        "return function(x)
           x = 1
           x = nil
           return nil
         end")))

  (section "tables"
    (it "with identifier keys"
      (affirm-codegen
        '({ :key 123 :! 567})
        "return {key=123, [\"!\"]=567}"))

    (it "with keyword keys"
      (affirm-codegen
        '({ :end 123 })
        "return {[\"end\"]=123}"))

    (it "with identifier strings"
      (affirm-codegen
        '({ "key" 123 "!" 567})
        "return {key=123, [\"!\"]=567}"))))
