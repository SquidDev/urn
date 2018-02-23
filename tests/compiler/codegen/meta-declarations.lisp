(import test ())
(import tests/compiler/codegen/codegen-helpers ())
(import tests/compiler/compiler-helpers ())

(import urn/backend/lua/emit lua)
(import urn/backend/writer writer)

(defun affirm-native (meta expected-src)
  (with (out (writer/create))
    (lua/compile-native out nil meta)
    (with (res (string/trim (string/gsub (writer/->string out) "\t" "  ")))
      (when (/= res expected-src)
        (with (out '())
          (push! out (.. "Unexpected result compiling " (pretty meta)))
          (diff-lines (string/split expected-src "\n") (string/split res "\n") out)
          (fail! (concat out "\n")))))))

(describe "The codegen"
  (section "will compile operators"
    (it "which are left associative"
      (affirm-codegen
        '((+ 2 3 4))
        "return 2 + 3 + 4")
      (affirm-codegen
        '((+ 2 3 (- 4 5)))
        "return 2 + 3 + (4 - 5)"))

    (it "which are right associative"
      (affirm-codegen
        '((.. "x" "y" "z"))
        "return \"x\" .. \"y\" .. \"z\"")
      (affirm-codegen
        '((.. "x" "y" (.. "a" "b")))
        "return \"x\" .. \"y\" .. (\"a\" .. \"b\")"))

    (it "which are not associative"
      (affirm-codegen
        '((get-idx foo "x"))
        "return foo[\"x\"]")
      (affirm-codegen
        '((get-idx (get-idx foo "x") "y"))
        "return foo[\"x\"][\"y\"]"))

    (section "which are variadic"
      (it "and have insufficient arguments"
        (affirm-codegen
          '((+ 2))
          "return _2b_(2)"))
      (pending "and have variadic returns"
        (affirm-codegen
          '((+ 2 (foo)))
          "return _2b_(2, foo)")))

    (it "which have the incorrect number of arguments"
      (affirm-codegen
        '((get-idx 1))
        "return getIdx(1)")
      (affirm-codegen
        '((get-idx 1 2 3))
        "return getIdx(1, 2, 3)")))

  (section "will compile operator functions"
    (it "which are left associative"
      (affirm-native
        (native-expr { :contents '(1 " + " 2) :count 2 :fold "left" })
        "function(x, ...) local t = x + ... for i = 2, _select('#', ...) do t = t + _select(i, ...) end return t end"))

    (it "which are right associative"
      (affirm-native
        (native-expr { :contents '(1 " .. " 2) :count 2 :fold "right" })
        "function(x, ...) local n = _select('#', ...) local t = _select(n, ...) for i = n - 1, 1, -1 do t = _select(i, ...) .. t end return x .. t end"))

    (it "which are not associative"
      (affirm-native
        (native-expr { :contents '(1 "[" 2 "]") :count 2 })
        "function(v1, v2) return v1[v2] end")))

  (it "will compile native variables"
    (affirm-native
      (native-var "foo")
      "foo")))
