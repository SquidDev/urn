(import test ())
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
       recur = function()
         return nil
       end
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

  (will "handle no variables being bound"
    (affirm-codegen
      '(((lambda (recur)
           (set! recur (lambda (x) (recur x)))
           (recur 1))))
      "local x = 1
       while true do
       end"))

  (section "handle variables being captured"
    (it "in set! bindings"
      (affirm-codegen
        '(((lambda (recur)
             (set! recur (lambda (x)
                           (foo (lambda () x))
                           (recur (+ x 1))))
             (recur 1))))
        "local x = 1
         while true do
           local x1 = x
           foo(function()
             return x1
           end)
           x = x1 + 1
         end"))

    (it "with loop termination"
      (affirm-codegen
        '(((lambda (recur)
             (set! recur (lambda (x)
                           (cond
                             [(bar x)
                              (foo (lambda () x))
                              (recur (+ x 1))]
                             [true (foo x)])))
             (recur 1))))
        "local x = 1
         while bar(x) do
           local x1 = x
           foo(function()
             return x1
           end)
           x = x1 + 1
         end
         return foo(x)"))

    (it "in define bindings"
      (affirm-codegen
        '((define recur (lambda (x)
                          (foo (lambda () x))
                          (recur (+ x 1)))))
        "recur = function(x)
           while true do
             local x1 = x
             foo(function()
               return x1
             end)
             x = x1 + 1
           end
         end"))

    (it "unless they are not captured in a binding"
      (affirm-codegen
        '(((lambda (f)
             (set! f (lambda (x)
                       ((lambda (a)
                          (cond
                            [a a]
                            [true (f (+ x 1))]))
                         (foo x))))
             (f 1))))
        "local x = 1
         while true do
           local a = foo(x)
           if a then
             return a
           else
             x = x + 1
           end
         end"))

    (it "unless they are captured in a nested loop"
      (affirm-codegen
        '(((lambda (f)
             (set! f (lambda (x)
                       ((lambda (g)
                          (set! g (lambda ()
                                    (foo x)
                                    (g)))
                          (g)))
                       (f 1)))
             (f 1))))
        "local x = 1
         while true do
           while true do
             foo(x)
           end
           x = 1
         end")))

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
