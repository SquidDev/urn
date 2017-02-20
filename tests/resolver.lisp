(import extra/assert ())
(import extra/test ())

(import list)
(import prelude)

(describe "The resolver"
  (will "make symbols unique"
    (affirm (= map list/map)
            (= map prelude/map))))
