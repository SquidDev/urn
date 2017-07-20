(import extra/assert ())
(import extra/test ())
(import tests/compiler/codegen/codegen-helpers ())

(describe "The codegen"
  (may "allow variadic arguments"
    (will "handle calling with variadic arguments in the middle"
      (with (slice-var (lambda (fst snd &middle last) (list fst snd middle last)))
        (affirm (eq? `(1 2 () ,nil) (slice-var 1 2))
                (eq? '(1 2 () 3)    (slice-var 1 2 3))
                (eq? '(1 2 (3) 4)   (slice-var 1 2 3 4))
                (eq? '(1 2 (3 4) 5) (slice-var 1 2 3 4 5)))))

    (will "handle inlining with variadic arguments in the middle"
      (affirm (eq? `(1 2 () ,nil) ((lambda (fst snd &middle last) (list fst snd middle last)) 1 2))
              (eq? '(1 2 () 3)    ((lambda (fst snd &middle last) (list fst snd middle last)) 1 2 3))
              (eq? '(1 2 (3) 4)   ((lambda (fst snd &middle last) (list fst snd middle last)) 1 2 3 4))
              (eq? '(1 2 (3 4) 5) ((lambda (fst snd &middle last) (list fst snd middle last)) 1 2 3 4 5))))

    (will "handle calling with variadic arguments at the end"
      (with (norm-var (lambda (fst snd &last) (list fst snd last)))
        (affirm (eq? `(1 ,nil ())   (norm-var 1))
                (eq? '(1 2 ())      (norm-var 1 2))
                (eq? '(1 2 (3))     (norm-var 1 2 3))
                (eq? '(1 2 (3 4))   (norm-var 1 2 3 4))
                (eq? '(1 2 (3 4 5)) (norm-var 1 2 3 4 5)))))

    (will "handle inlining with variadic arguments at the end"
        (affirm (eq? `(1 ,nil ())   ((lambda (fst snd &last) (list fst snd last)) 1))
                (eq? '(1 2 ())      ((lambda (fst snd &last) (list fst snd last)) 1 2))
                (eq? '(1 2 (3))     ((lambda (fst snd &last) (list fst snd last)) 1 2 3))
                (eq? '(1 2 (3 4))   ((lambda (fst snd &last) (list fst snd last)) 1 2 3 4))
                (eq? '(1 2 (3 4 5)) ((lambda (fst snd &last) (list fst snd last)) 1 2 3 4 5))))


    (will "handle unpacking at the end"
      (affirm-codegen
        '(((lambda (&args) args)
            2 3 (foo)))
        "local args =  _pack(2, 3, foo()) args.tag = \"list\"
         return args")

      (affirm-codegen
        '(((lambda (&args) args)
            2 3 ((lambda (x)
                   (set! x 2)
                   x)
                  1)))
        "local args =  _pack(2, 3, (function(x)
           x = 2
           return x
         end)(1)) args.tag = \"list\"
         return args"))))
