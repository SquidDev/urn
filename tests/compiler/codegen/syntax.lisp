(import extra/test ())
(import extra/assert ())
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
        "_and = 2"))
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
       return 1")))
