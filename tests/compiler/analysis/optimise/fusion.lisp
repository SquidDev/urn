(import test ())
(import tests/compiler/analysis/optimise/optimise-helpers ())

(import urn/analysis/optimise/fusion fusion)
(import urn/analysis/nodes (make-symbol))
(import urn/resolve/builtins (builtin))

(defun setup-rules! (&rules)
  (loop [] [(empty? fusion/fusion-patterns)] (pop-last! fusion/fusion-patterns))

  (for-each rule rules
    (push! fusion/fusion-patterns
      { :from (fusion/builtin-ptrn! (.> rule :from))
        :to   (fusion/builtin-ptrn! (.> rule :to)) })))

(describe "The optimiser will fuse expressions"
  (it "will define some basic fusion rules"
    (setup-rules!
      { :from '(cond
                 [(cond
                    [?x true]
                    [true false]) false]
                 [true true])
        :to   '(cond
                 [?x false]
                 [true true]) })
    (affirm-transform-optimise (list fusion/fusion)
      '((cond
          [(cond
             [123 true]
             [true false]) false]
          [true true]))
      '((cond
          [123 false]
          [true true]))
      1)))
