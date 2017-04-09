(import extra/test ())
(import extra/assert ())

(import urn/parser parser)
(import urn/logger/void (void))

(defun lex (str)
  "Lex STR, removing the EOF token"
  (with (res (parser/lex void str "<stdin>"))
    (pop-last! res)
    res))

(defun parse (str)
  "Lex and parse STR"
  (parser/parse void (parser/lex void str "<stdin>")))

(defun teq? (x y)
  "Check the two values X and Y are equal, unwrapping them using [[const-val]]."
  (cond
    [(/= (type x) (type y)) false]
    [(list? x) (and (= (# x) (# y)) (all id (map teq? x y)))]
    [true (eq? (const-val x) (const-val y))]))

(defun string->key (key) { :tag "key" :value key })

(describe "The parser"
  (it "lexes numbers"
    (affirm (teq? '(23) (lex "23"))
            (teq? '(23) (lex "0x17"))
            (teq? '(23) (lex "0b10111"))
            (teq? '(23) (lex "0.23e2"))))

  (it "lexes strings"
    (affirm (teq? '("foo") (lex "\"foo\""))
            (teq? '("\"foo\"") (lex "\"\\\"foo\\\"\""))
            (teq? '("A") (lex "\"\\65\""))
            (teq? '("A") (lex "\"\\x41\""))
            (teq? '("foo\nbar") (lex "\"foo\n bar\""))
            (teq? '("foo\nbar") (lex "   \"foo\n    bar\""))
            (teq? '("foo\n   bar") (lex "   \"foo\n   bar\""))))

  (it "lexes symbols"
    (affirm (teq? (list (string->symbol "foo")) (lex "foo"))
            (teq? (list (string->symbol "foo-bar")) (lex "foo-bar"))
            (teq? (list (string->symbol "foo-bar!")) (lex "foo-bar!"))
            (teq? (list (string->symbol "foo-\"bar")) (lex "foo-\"bar"))
            (teq? (list (string->symbol "-")) (lex "-"))
            (teq? (list (string->symbol "-.e")) (lex "-.e"))
            (teq? (list (string->symbol "//\\//")) (lex "//\\//"))))

  (it "lexes keys"
    (affirm (teq? (list (string->key "foo")) (lex ":foo"))
            (teq? (list (string->key "foo-bar")) (lex ":foo-bar"))
            (teq? (list (string->key "foo-bar!")) (lex ":foo-bar!"))
            (teq? (list (string->key "foo-\"bar")) (lex ":foo-\"bar"))))

  (it "lexes tokens"
    (affirm (eq? '("unquote") (map type (lex ",")))
            (eq? '("unquote-splice") (map type (lex ",@")))
            (eq? '("quote") (map type (lex "'")))
            (eq? '("syntax-quote") (map type (lex "`")))
            (eq? '("quasiquote") (map type (lex "~")))))

  (it "lexes lists"
    (affirm (eq? '("open" "open" "open-struct") (map type (lex "( [ {")))
            (eq? '("close" "close" "close") (map type (lex ") ] }")))))


  (it "stops symbols on lists"
    (affirm (teq? 'foo-bar (car (lex "foo-bar)")))
            (teq? 'foo-bar (car (lex "foo-bar]")))
            (teq? 'foo-bar (car (lex "foo-bar}")))
            (teq? 'foo-bar (car (lex "foo-bar ")))
            (teq? 'foo-bar (car (lex "foo-bar\n")))))

  (it "lexes handles comments"
    (affirm (teq? '() (lex "; foo bar"))
            (teq? '(foo) (lex "; foo bar\nfoo"))))

  (it "parses constants"
    (affirm (teq? '(23) (parse "23"))
            (teq? '("foo") (parse "\"foo\""))
            (teq? '(23 foo "foo" 23) (parse "23 foo \"foo\" 23"))
            (teq? '((23)) (parse "(23)"))))

  (it "parses lists"
    (affirm (teq? '((((23)))) (parse "(((23)))"))
            (teq? '((foo bar) foo (((foo)))) (parse "(foo bar) foo (((foo)))"))
            (teq? '((foo (bar)) (((foo)))) (parse "[foo (bar)] [[(foo)]]"))))

  (it "parses struct"
    (affirm (teq? '((struct-literal)) (parse "{}"))
            (teq? '((struct-literal :x 2)) (parse "{ :x 2 }"))
            (teq? '(((struct-literal :x 2))) (parse "[{ :x 2 }]"))
            (teq? '((struct-literal :x 2 (y) (z))) (parse "{ :x 2 (y) [z] }"))))

  (it "parses unquotes"
    (affirm (teq? '((quote foo)) (parse "'foo"))
            (teq? '((quote (foo))) (parse "'(foo)"))
            (teq? '((syntax-quote foo)) (parse "`foo"))
            (teq? '((syntax-quote (foo))) (parse "`(foo)"))))

  (it "parses unquotes"
    (affirm (teq? '((unquote foo)) (parse ",foo"))
            (teq? '((unquote (foo))) (parse ",(foo)"))
            (teq? '((unquote-splice foo)) (parse ",@foo"))
            (teq? '((unquote-splice (foo))) (parse ",@(foo)"))))
)
