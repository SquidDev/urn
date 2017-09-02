(import test ())

(import core/list list)
(import core/prelude prelude)

(describe "The resolver"
  (will "make symbols unique"
    (affirm (= map list/map)
            (= map prelude/map))))
