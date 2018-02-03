(import test ())
(import tests/compiler/codegen/codegen-helpers ())

(describe "The codegen"
  (section "will generate value wrappers"
    (it "for normal arguments"
      (affirm-codegen
        '(((lambda (x) x) (foo)))
        "return (foo())"))
    (it "for variadic arguments with a known value set"
      (affirm-codegen
        '(((lambda (&x) x) (foo) 2))
        "return {tag=\"list\", n=2, foo(), 2}"))
    (it "unless there are an unknown number of values"
      (affirm-codegen
        '(((lambda (&x) x) (foo)))
        "local x = _pack(foo()) x.tag = \"list\"
         return x")))

  (section "will which handle lambdas with variadic arguments"
    (it "on their own"
      (with (fn (lambda (&fst) fst))
        (affirm (eq? `()    (fn))
                (eq? '(1)   (fn 1))
                (eq? '(1 2) (fn 1 2)))))

    (it "at the beginning"
      (with (fn (lambda (&fst snd last) (list fst snd last)))
        (affirm (eq? `(() 1 ,nil)   (fn 1))
                (eq? '(() 1 2)      (fn 1 2))
                (eq? '((1) 2 3)     (fn 1 2 3))
                (eq? '((1 2) 3 4)   (fn 1 2 3 4))
                (eq? '((1 2 3) 4 5) (fn 1 2 3 4 5)))))

    (it "in the middle"
      (with (fn (lambda (fst snd &middle last) (list fst snd middle last)))
        (affirm (eq? `(1 ,nil () ,nil) (fn 1))
                (eq? `(1 2 () ,nil)    (fn 1 2))
                (eq? '(1 2 () 3)       (fn 1 2 3))
                (eq? '(1 2 (3) 4)      (fn 1 2 3 4))
                (eq? '(1 2 (3 4) 5)    (fn 1 2 3 4 5)))))

    (it "at the end"
      (with (fn (lambda (fst snd &last) (list fst snd last)))
        (affirm (eq? `(1 ,nil ())   (fn 1))
                (eq? '(1 2 ())      (fn 1 2))
                (eq? '(1 2 (3))     (fn 1 2 3))
                (eq? '(1 2 (3 4))   (fn 1 2 3 4))
                (eq? '(1 2 (3 4 5)) (fn 1 2 3 4 5))))))

  (section "generate the appropriate code for lambdas with variadic arguments"
    (it "on their own"
      (affirm-codegen
        '((lambda (&args) 1))
        "return function(...)
           local args = _pack(...) args.tag = \"list\"
           return 1
         end"))

    (it "at the beginning"
      (affirm-codegen
        '((lambda (&args x) 1))
        "return function(...)
           local _n = _select(\"#\", ...) - 1
           local args, x
           if _n > 0 then
             args = {tag=\"list\", n=_n, _unpack(_pack(...), 1, _n)}
             x = select(_n + 1, ...)
           else
             args = {tag=\"list\", n=0}
             x = ...
           end
           return 1
         end")))

  (section "will which handle bindings with variable arguments"
    (section "and a known number of values"
      (it "at the beginning"
        (affirm (eq? `(() 1 ,nil)   ((lambda (&fst snd last) (list fst snd last)) 1))
                (eq? `(() 1 2)      ((lambda (&fst snd last) (list fst snd last)) 1 2))
                (eq? '((1) 2 3)     ((lambda (&fst snd last) (list fst snd last)) 1 2 3))
                (eq? '((1 2) 3 4)   ((lambda (&fst snd last) (list fst snd last)) 1 2 3 4))
                (eq? '((1 2 3) 4 5) ((lambda (&fst snd last) (list fst snd last)) 1 2 3 4 5))))

      (it "in the middle"
        (affirm (eq? `(1 ,nil () ,nil) ((lambda (fst snd &middle last) (list fst snd middle last)) 1))
                (eq? `(1 2 () ,nil)    ((lambda (fst snd &middle last) (list fst snd middle last)) 1 2))
                (eq? '(1 2 () 3)       ((lambda (fst snd &middle last) (list fst snd middle last)) 1 2 3))
                (eq? '(1 2 (3) 4)      ((lambda (fst snd &middle last) (list fst snd middle last)) 1 2 3 4))
                (eq? '(1 2 (3 4) 5)    ((lambda (fst snd &middle last) (list fst snd middle last)) 1 2 3 4 5))))

      (it "at the end"
        (affirm (eq? `(1 ,nil ())   ((lambda (fst snd &last) (list fst snd last)) 1))
                (eq? '(1 2 ())      ((lambda (fst snd &last) (list fst snd last)) 1 2))
                (eq? '(1 2 (3))     ((lambda (fst snd &last) (list fst snd last)) 1 2 3))
                (eq? '(1 2 (3 4))   ((lambda (fst snd &last) (list fst snd last)) 1 2 3 4))
                (eq? '(1 2 (3 4 5)) ((lambda (fst snd &last) (list fst snd last)) 1 2 3 4 5)))))

    (section "and an unknown number of values"
      (it "at the beginning"
        (affirm (eq? `(() 1 ,nil)   ((lambda (&fst snd last) (list fst snd last)) (values-list 1)))
                (eq? `(() 1 2)      ((lambda (&fst snd last) (list fst snd last)) (values-list 1 2)))
                (eq? '((1) 2 3)     ((lambda (&fst snd last) (list fst snd last)) (values-list 1 2 3)))
                (eq? '((1 2) 3 4)   ((lambda (&fst snd last) (list fst snd last)) (values-list 1 2 3 4)))
                (eq? '((1 2 3) 4 5) ((lambda (&fst snd last) (list fst snd last)) (values-list 1 2 3 4 5)))))

      (it "in the middle"
        (affirm (eq? `(1 ,nil () ,nil) ((lambda (fst snd &middle last) (list fst snd middle last)) (values-list 1)))
                (eq? `(1 2 () ,nil)    ((lambda (fst snd &middle last) (list fst snd middle last)) (values-list 1 2)))
                (eq? '(1 2 () 3)       ((lambda (fst snd &middle last) (list fst snd middle last)) (values-list 1 2 3)))
                (eq? '(1 2 (3) 4)      ((lambda (fst snd &middle last) (list fst snd middle last)) (values-list 1 2 3 4)))
                (eq? '(1 2 (3 4) 5)    ((lambda (fst snd &middle last) (list fst snd middle last)) (values-list 1 2 3 4 5)))))

      (it "at the end"
        (affirm (eq? `(1 ,nil ())   ((lambda (fst snd &last) (list fst snd last)) (values-list 1)))
                (eq? '(1 2 ())      ((lambda (fst snd &last) (list fst snd last)) (values-list 1 2)))
                (eq? '(1 2 (3))     ((lambda (fst snd &last) (list fst snd last)) (values-list 1 2 3)))
                (eq? '(1 2 (3 4))   ((lambda (fst snd &last) (list fst snd last)) (values-list 1 2 3 4)))
                (eq? '(1 2 (3 4 5)) ((lambda (fst snd &last) (list fst snd last)) (values-list 1 2 3 4 5))))))

    (section "and a mixture of values"
      (it "at the beginning"
        (affirm (eq? `((1 7) 8 9)   ((lambda (&fst snd last) (list fst snd last)) 1 (values-list 7 8 9)))))

      (it "in the middle"
        (affirm (eq? `(7 8 () 9)    ((lambda (fst snd &middle last) (list fst snd middle last))     (values-list 7 8 9)))
                (eq? `(1 7 (8) 9)   ((lambda (fst snd &middle last) (list fst snd middle last)) 1   (values-list 7 8 9)))
                (eq? '(1 2 (7 8) 9) ((lambda (fst snd &middle last) (list fst snd middle last)) 1 2 (values-list 7 8 9)))))

      (it "at the end"
        (affirm (eq? `(7 8 (9))     ((lambda (fst snd &last) (list fst snd last))     (values-list 7 8 9)))
                (eq? '(1 7 (8 9))   ((lambda (fst snd &last) (list fst snd last)) 1   (values-list 7 8 9)))
                (eq? '(1 2 (7 8 9)) ((lambda (fst snd &last) (list fst snd last)) 1 2 (values-list 7 8 9)))))))
)
