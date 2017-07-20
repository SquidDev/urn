(import extra/test ())
(import extra/assert ())
(import tests/compiler/codegen/codegen-helpers ())

(describe "The codegen"
  (will-not "fail on empty 'recursive' lambdas"
    ;; Historically this would crash the categoriser as it thinks this should recurse,
    ;; but it never does.
    (affirm-codegen
      '(((lambda (recur)
           (set! recur (lambda ()))
           (recur))))
      "local recur
       recur = (function()
         return nil
       end)
       return recur()"))

  (will "correctly propagate breaks"
    (affirm-codegen
      '(((lambda (recur)
           (set! recur (lambda ()
                         ((lambda (x)
                            (cond
                              [x (recur)]
                              [true]))
                           foo)))
           (recur)))
         nil)
      "while true do
         local x = foo
         if x then
         else
           break
         end
       end
       return nil"))

  (will "handle binding variables to themselves"
    (affirm-codegen
      '(((lambda (recur)
           (set! recur (lambda (x y)
                         (recur x (+ y 1))))
           (recur 1 1))))
      "local x, y = 1, 1
       while true do
         y = y + 1
       end"))

  (pending "handle no variables being bound"
    (affirm-codegen
      '(((lambda (recur)
           (set! recur (lambda (x) (recur x)))
           (recur 1))))
      "local x = 1
       while true do
       end"))

  (section "will generate common patterns"
    (section "such as 'while x do'"
      (it "in return contexts"
        (affirm-codegen
          '(((lambda (recur)
               (set! recur (lambda (x)
                             (cond
                               [x (recur 0)]
                               [true (foo)])))
               (recur 1))))
          "local x = 1
           while x do
             x = 0
           end
           return foo()"))

      (it "in non-return contexts"
        (affirm-codegen
          '(((lambda (recur)
               (set! recur (lambda (x)
                             (cond
                               [x (recur 0)]
                               [true (foo)])))
               (recur 1)))
             nil)
          "local x = 1
           while x do
             x = 0
           end
           foo()
           return nil")))

    (section "such as 'while not x do'"
      ;; TODO: Remove additional parens
      (it "in return contexts"
        (affirm-codegen
          '(((lambda (recur)
               (set! recur (lambda (x)
                             (cond
                               [x (foo)]
                               [true (recur 0)])))
               (recur 1))))
          "local x = 1
           while not (x) do
             x = 0
           end
           return foo()"))

      (it "in non-return contexts"
        (affirm-codegen
          '(((lambda (recur)
               (set! recur (lambda (x)
                             (cond
                               [x (foo)]
                               [true (recur 0)])))
               (recur 1)))
             nil)
          "local x = 1
           while not (x) do
             x = 0
           end
           foo()
           return nil"))))

  (section "will not generate common patterns"
    (it "when there are too many branches"
      (affirm-codegen
        '(((lambda (recur)
             (set! recur (lambda (x)
                           (cond
                             [x (recur 0)]
                             [foo (foo)]
                             [true (bar)])))
             (recur 1))))
        "local x = 1
         while true do
           if x then
             x = 0
           elseif foo then
             return foo()
           else
             return bar()
           end
         end")))


  )
