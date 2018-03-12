(import test ())

(import urn/backend/lua/emit lua)
(import urn/backend/lua/escape lua)
(import urn/backend/lua lua)
(import urn/backend/writer writer)
(import urn/range range)
(import urn/resolve/loop resolve)
(import urn/parser parser)
(import urn/traceback traceback)

(import tests/compiler/compiler-helpers (create-compiler wrap-node))
(import tests/compiler/codegen/codegen-helpers ())


(defun affirm-mappings (input-src expected-src)
  "Affirm compiling INPUT-NODES generates EXPECTED-SRC."
  (let* [(compiler (create-compiler))
         (compile-state (lua/create-state))
         (writer (writer/create))]
    (.<! compiler :compile-state compile-state)

    (with (resolved (resolve/compile
                     compiler
                     (parser/read input-src "init.lisp")
                     (.> compiler :root-scope)
                     "init.lisp"))

      (for-pairs (_ var) (.> compiler :root-scope :variables)
        (lua/push-escape-var! var compile-state))

      (lua/block resolved writer compile-state 1 "return ")

      (let* [(res (string/split (string/trim (string/gsub (writer/->string writer) "\t" "  ")) "\n"))
             (mappings (traceback/generate-mappings (.> writer :lines)))
             (max 15)]

        (for-pairs (_ data) mappings (set! max (math/max max (n data))))

        (for i 1 (n res) 1
          (.<! res i (string/format (.. "%" max "s | %s") (or (.> mappings i) "") (nth res i))))

        (when (/= (concat res "\n") expected-src)
          (with (out '())
            (push! out "Unexpected result compiling")
            (push! out input-src)
            (diff-lines (string/split expected-src "\n") res out)
            (fail! (concat out "\n"))))))))

(describe "The codegen will correctly generate mappings"
  (it "for simple constants"
    (affirm-mappings
      "1"
      "    init.lisp:1 | return 1"))

  (section "for quotes"
    (it "of empty lists"
      (affirm-mappings
        "'()"
        "    init.lisp:1 | return {tag=\"list\", n=0}"))

    (it "of quotes with multiple items"
      (affirm-mappings
        "'(
           1
           2
           3)"
        "  init.lisp:2-4 | return {tag=\"list\", n=3, 1, 2, 3}"))

    (it "of syntax-quotes"
      (affirm-mappings
        "`(1 2 ,(cond
                  [foo 1]
                  [true 2]))"
        "    init.lisp:1 | return {tag=\"list\", n=3, 1, 2, (function()
             init.lisp:2 |   if foo then
             init.lisp:2 |     return 1
                         |   else
             init.lisp:3 |     return 2
                         |   end
                         | end)()}"))

    (it "of unquote-splices"
      (affirm-mappings
        "`(1 2
           ,@(+ 2
                3))"
        "                | local _offset, _result, _temp = 0, {tag=\"list\"}
             init.lisp:1 | _result[1 + _offset] = 1
             init.lisp:1 | _result[2 + _offset] = 2
           init.lisp:2-3 | _temp = 2 + 3
             init.lisp:2 | for _c = 1, _temp.n do _result[2 + _c + _offset] = _temp[_c] end
                         | _offset = _offset + _temp.n
                         | _result.n = _offset + 2
                         | return _result")))

  (section "for struct-literals"
    (it "of empty structs"
      (affirm-mappings
        "{}"
        "    init.lisp:1 | return {}"))
    (it "of structs with items in"
      (affirm-mappings
        "{ :foo 1
           :bar 2 }"
        "  init.lisp:1-2 | return {foo=1, bar=2}")))

  (section "for and expressions"
    (it "which span multiple lines"
      (affirm-mappings
        "(cond
          [foo bar]
          [true foo])"
        "    init.lisp:2 | return foo and bar"))

    (it "which span a single line"
      (affirm-mappings
        "(cond [foo bar] [true foo])"
        "    init.lisp:1 | return foo and bar")))

  (section "for or expressions"
    (it "which span multiple lines"
      (affirm-mappings
        "(cond
          [foo foo]
          [true bar])"
        "  init.lisp:2-3 | return foo or bar"))

    (it "which span a single line"
      (affirm-mappings
        "(cond [foo foo] [true bar])"
        "    init.lisp:1 | return foo or bar")))

  (section "for not expressions"
    ;; This only considers the "foo" as active. Possibly worth re-considering
    ;; this
    (it "which span multiple lines"
      (affirm-mappings
        "(cond
          [foo false]
          [true true])"
        "    init.lisp:2 | return not foo"))

    (it "which span a single line"
      (affirm-mappings
        "(cond [foo false] [true true])"
        "    init.lisp:1 | return not foo")))

  (section "for conditions"
    (it "which span multiple lines"
      (affirm-mappings
        "(cond
           [foo 1]
           [true 2])"
        "    init.lisp:2 | if foo then
             init.lisp:2 |   return 1
                         | else
             init.lisp:3 |   return 2
                         | end"))

    (it "which has no else condition"
      ;; TODO: Can we handle this in a more sensible way
      (affirm-mappings
        "(cond
           [foo 1]
           [bar 2])"
        "    init.lisp:2 | if foo then
             init.lisp:2 |   return 1
             init.lisp:3 | elseif bar then
             init.lisp:3 |   return 2
                         | else
             init.lisp:1 |   _error(\"unmatched item\")
                         | end"))
    (it "which has nested conds"
      (affirm-mappings
        "(cond
           [(cond
              [foo 1]
              [true 2])
            3]
           [true 4])"
        "                | local temp
             init.lisp:3 | if foo then
             init.lisp:3 |   temp = 1
                         | else
             init.lisp:4 |   temp = 2
                         | end
                         | if temp then
             init.lisp:5 |   return 3
                         | else
             init.lisp:6 |   return 4
                         | end"))

    (it "inside expressions"
      (affirm-mappings
        "(foo (cond
                [foo 1]
                [true 2]))"
        "    init.lisp:1 | return foo((function()
             init.lisp:2 |   if foo then
             init.lisp:2 |     return 1
                         |   else
             init.lisp:3 |     return 2
                         |   end
                         | end)())")))

  (section "for lambdas"
    (it "on a single line"
      (affirm-mappings
        "(lambda ())"
        "    init.lisp:1 | return function()
                         |   return nil
                         | end")
      (affirm-mappings
        "(lambda () 2)"
        "    init.lisp:1 | return function()
             init.lisp:1 |   return 2
                         | end"))

    (it "across multiple lines"
      (affirm-mappings
        "(lambda ()
           (foo)
           (bar)
           (baz))"
        "    init.lisp:1 | return function()
             init.lisp:2 |   foo()
             init.lisp:3 |   bar()
             init.lisp:4 |   return baz()
                         | end")))

  (section "for definitions"
    (it "native definitions"
      (affirm-mappings
        "(define-native x)"
        "    init.lisp:1 | x = _libs[\"x\"]"))
    (it "constant definitions"
      (affirm-mappings
        "(define x 2)"
        "    init.lisp:1 | x = 2"))
    (section "lambda definitions"
      (it "on a single line"
        (affirm-mappings
          "(define x (lambda () 2))"
          "    init.lisp:1 | x = function()
               init.lisp:1 |   return 2
                           | end"))

      ;; Not sure whether current behaviour or new behaviour is better
      (it "across multiple lines"
        (affirm-mappings
          "(define x
             (lambda ()
               2))"
          "    init.lisp:2 | x = function()
               init.lisp:3 |   return 2
                           | end")))

    ;; Not sure whether current behaviour or new behaviour is better
    (it "with bindings"
      (affirm-mappings
        "(define x ((lambda (x)
          (+ x 1))
          2))"
        "    init.lisp:3 | local x1 = 2
             init.lisp:2 | x = x1 + 1")))

  (it "for macros"
    (affirm-mappings
      "(define-macro inc (lambda (var) `(,'set! ,var (,'+ ,var 1))))
       (lambda (x)
         (inc x)
         (inc
           x)
         (inc x
         ))"
      "    init.lisp:1 | inc1 = function(var)
           init.lisp:1 |   return {tag=\"list\", n=3, {tag=\"symbol\", contents=\"set!\"}, var, {tag=\"list\", n=3, {tag=\"symbol\", contents=\"+\"}, var, 1}}
                       | end
           init.lisp:2 | return function(x)
           init.lisp:3 |   x = x + 1
         init.lisp:4-5 |   x = x + 1
           init.lisp:6 |   x = x + 1
                       |   return nil
                       | end")))
