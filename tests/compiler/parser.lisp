(import test ())

(import urn/parser parser)
(import urn/logger/void (void))

(defun lex (str)
  "Lex STR, removing the EOF token"
  (with (res (parser/lex void str "<stdin>"))
    (pop-last! res)
    res))

(defun parse (str)
  "Lex and parse STR"
  (let* [(lexed (parser/lex void str "<stdin>"))
         (parsed (parser/parse void lexed))]
    parsed))

(defun teq? (x y)
  "Check the two values X and Y are equal, unwrapping them using [[const-val]]."
  (cond
    [(/= (type x) (type y)) false]
    [(list? x) (and (= (n x) (n y)) (all id (map teq? x y)))]
    [true (eq? x y)]))

(defmethod (pretty interpolate) (x)
  (.. "$" (string/quoted (.> x :value))))

(defmethod (eq? interpolate interpolate) (x y)
  (= (.> x :value) (.> y :value)))

(defmethod (pretty rational) (x)
  (.. (pretty (.> x :num)) "/" (pretty (.> x :dom))))

(defmethod (eq? rational rational) (x y)
  (and (eq? (.> x :num) (.> y :num)) (eq? (.> x :dom) (.> y :dom))))

(defun string->key (key) { :tag "key" :value key })

(defmacro try (expr)
  `(list (pcall (lambda () ,expr))))

(defun failed? (msg res)
  (and (not (car res))
       (string/ends-with? (tostring (cadr res)) msg)))

(describe "The parser"
  (it "lexes whitespace"
    (affirm (teq? '() (lex "  \n \t \f \v"))))

  (it "lexes numbers"
    (affirm (teq? '( 23)  (lex "23"))
            (teq? '(-23)  (lex "-23"))
            (teq? '( 23)  (lex "#x17"))
            (teq? '(-23)  (lex "-#x17"))
            (teq? '( 23)  (lex "#b10111"))
            (teq? '(-23)  (lex "-#b10111"))
            (teq? '( 23)  (lex "0.23e2"))
            (teq? '(-23)  (lex "-0.23e2"))
            (teq? '(23)   (lex "#rXXIII"))
            (teq? '(-23)  (lex "-#rXXIII"))
            (teq? '(1666) (lex "#rMDCLXVI"))
            (teq? (list { :tag "rational" :num 1 :dom 2 }) (lex "1/2"))
            (teq? (list { :tag "rational" :num 1 :dom 2 }) (lex "1'/'2'"))

            (failed? "Expected hexadecimal (#x), binary (#b), or Roman (#r) digit specifier." (try (lex "#)")))
            (failed? "Expected hexadecimal (#x), binary (#b), or Roman (#r) digit specifier." (try (lex "#a")))
            (failed? "Expected binary digit, got \"2\"" (try (lex "#b2")))
            (failed? "Expected hexadecimal digit, got \"h\"" (try (lex "#xh")))
            (failed? "Expected digit, got \"a\"" (try (lex "2a")))
            (failed? "Expected digit, got eof" (try (lex ".2e")))
            (failed? "Expected digit, got \"-\"" (try (lex "2-")))
            (failed? "Invalid denominator in rational literal" (try (lex "2/''")))))

  (it "lexes strings"
    (affirm (teq? '("foo") (lex "\"foo\""))
            (teq? '("\"foo\"") (lex "\"\\\"foo\\\"\""))
            (teq? '("A") (lex "\"\\65\""))
            (teq? '("A") (lex "\"\\x41\""))
            (teq? '("foo\nbar") (lex "\"foo\n bar\""))
            (teq? '("foo\nbar") (lex "   \"foo\n    bar\""))
            (teq? '("foo\n   bar") (lex "   \"foo\n   bar\""))
            (teq? '("foo\nbar\nbaz") (lex "   \"foo\n    bar\n    baz\""))
            (teq? (list { :tag "interpolate" :value "foo"}) (lex "$\"foo\""))

            (failed? "Expected '\"', got eof" (try (lex "\"foo")))
            (failed? "Expected hexadecimal digit, got \"g\"" (try (lex "\"\\xg\"")))
            (failed? "Invalid escape code" (try (lex "\"\\333\"")))
            (failed? "Illegal escape character" (try (lex "\"\\l\"")))
            (failed? "Expected escape code, got eof" (try (lex "\"\\")))))

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
            (eq? '("quasiquote") (map type (lex "~")))
            (eq? '("quote" "symbol") (map type (lex "'@")))
            (eq? '("splice" "open") (map type (lex "@(")))
            (eq? '("symbol" "close") (map type (lex "@)")))))

  (it "lexes lists"
    (affirm (eq? '("open" "open" "open-struct") (map type (lex "( [ {")))
            (eq? '("close" "close" "close") (map type (lex ") ] }")))))

  (it "stops symbols"
    (affirm (teq? 'foo-bar (car (lex "foo-bar)")))
            (teq? 'foo-bar (car (lex "foo-bar]")))
            (teq? 'foo-bar (car (lex "foo-bar}")))
            (teq? 'foo-bar (car (lex "foo-bar ")))
            (teq? 'foo-bar (car (lex "foo-bar\n")))
            (teq? 'foo-bar (car (lex "foo-bar\t")))
            (teq? 'foo-bar (car (lex "foo-bar\f")))
            (teq? 'foo-bar (car (lex "foo-bar\v")))
            (teq? 'foo-bar (car (lex "foo-bar;")))))

  (it "lexes handles comments"
    (affirm (teq? '() (lex "; foo bar"))
            (teq? '(foo) (lex "; foo bar\nfoo"))))

  (it "parses constants"
    (affirm (teq? '(23) (parse "23"))
            (teq? '("foo") (parse "\"foo\""))
            (teq? '(23 foo "foo" 23) (parse "23 foo \"foo\" 23"))
            (teq? '((23)) (parse "(23)"))))

  (it "parses rationals"
    (affirm (teq? '((rational 1 2)) (parse "1/2"))))

  (it "parses string interpolation"
    (affirm (teq? '(($ "foo")) (parse "$\"foo\""))))

  (it "parses lists"
    (affirm (teq? '((((23)))) (parse "(((23)))"))
            (teq? '((foo bar) foo (((foo)))) (parse "(foo bar) foo (((foo)))"))
            (teq? '((foo (bar)) (((foo)))) (parse "[foo (bar)] [[(foo)]]"))))

  (it "parses struct"
    (affirm (teq? '((struct-literal)) (parse "{}"))
            (teq? '((struct-literal :x 2)) (parse "{ :x 2 }"))
            (teq? '(((struct-literal :x 2))) (parse "[{ :x 2 }]"))
            (teq? '((struct-literal :x 2 (y) (z))) (parse "{ :x 2 (y) [z] }"))))

  (it "parses quotes"
    (affirm (teq? '((quote foo)) (parse "'foo"))
            (teq? '((quote (foo))) (parse "'(foo)"))
            (teq? '((syntax-quote foo)) (parse "`foo"))
            (teq? '((syntax-quote (foo))) (parse "`(foo)"))
            (teq? '((quasiquote foo)) (parse "~foo"))
            (teq? '((quasiquote (foo))) (parse "~(foo)"))
            (teq? '((splice foo)) (parse "@foo"))
            (teq? '((splice (foo))) (parse "@(foo)"))

            (failed? "Expected expression quote, got eof" (try (parse "'")))
            (failed? "')' without matching '(' inside quote" (try (parse "')")))))

  (it "parses unquotes"
    (affirm (teq? '((unquote foo)) (parse ",foo"))
            (teq? '((unquote (foo))) (parse ",(foo)"))
            (teq? '((unquote-splice foo)) (parse ",@foo"))
            (teq? '((unquote-splice (foo))) (parse ",@(foo)"))))

  (it "fails on mismatched parens"
    (affirm (failed? "')' without matching '('" (try (parse ")")))
            (failed? "Expected ')', got ']'" (try (parse "(]")))
            (failed? "Expected ')', got eof" (try (parse "(")))))
)
