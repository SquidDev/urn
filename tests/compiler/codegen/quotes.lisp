(import test ())
(import tests/compiler/codegen/codegen-helpers ())

(describe "The codegen will generate code for"
  (section "syntax quotes"
    (it "with `unquote`s"
      (affirm-codegen
       '(`(1 2 ,foo))
       "return {tag=\"list\", n=3, 1, 2, foo}"))
    (it "with `unquote-splice`s"
      (affirm-codegen
       '(`(1 2 ,@foo))
       "local _offset, _result, _temp = 0, {tag=\"list\"}
        _result[1 + _offset] = 1
        _result[2 + _offset] = 2
        _temp = foo
        for _c = 1, _temp.n do _result[2 + _c + _offset] = _temp[_c] end
        _offset = _offset + _temp.n
        _result.n = _offset + 2
        return _result"))

    (pending "with (unquote (unquote-splice ...))"
      (affirm-codegen
        '(``,,@'(1 2 3))
        ""))
    (pending "with (unquote-splice (unquote ...))"
      (affirm-codegen
        '(``,,@'(1 2 3))
        ""))))
