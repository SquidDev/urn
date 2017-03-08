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
  (parser/parse (parser/lex void str "<stdin>")))

(defun teq? (x y)
  "Check the two values X and Y are equal, unwrapping them using [[const-val]]."
  (eq?
    (if (list? x) (map const-val x) (const-val x))
    (if (list? y) (map const-val y) (const-val y))))

(defun string->key (key) (struct :tag "key" :value key))

(describe "The parser"
  (it "lexes numbers"
    (affirm (teq? '(23) (lex "23"))
            (teq? '(23) (lex "0x17"))
            (teq? '(23) (lex "0b10111"))
            (teq? '(23) (lex "0.23e2"))))

  (it "lexes strings"
    (affirm (teq? '("foo") (lex "\"foo\""))
            (teq? '("\"foo\"") (lex "\"\\\"foo\\\"\""))
            (teq? '("A") (lex "\65"))
            (teq? '("A") (lex "\x41"))
            (teq? '("foo\nbar") (lex "\"foo\n bar\""))
            (teq? '("foo\nbar") (lex "   \"foo\n    bar\""))
            (teq? '("foo\n   bar") (lex "   \"foo\n   bar\""))))

  (it "lexes symbols"
    (affirm (teq? (list (string->symbol "foo")) (lex "foo"))
            (teq? (list (string->symbol "foo-bar")) (lex "foo-bar"))
            (teq? (list (string->symbol "foo-bar!")) (lex "foo-bar!"))
            (teq? (list (string->symbol "foo-\"bar")) (lex "foo-\"bar"))))

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
    (affirm (eq? '("open" "open" "open") (map type (lex "( [ {")))
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
)
