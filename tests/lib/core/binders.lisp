(import test ())

(describe "A variable"
  (it "may not be bound using let"
    (with (a 0)
      (let [(a (succ a))
            (b a)]
        (affirm (= a 1)
                (= b 0)))))

  (it "may be bound using let*"
    (with (a 0)
      (let* [(a (succ a))
             (b a)]
        (affirm (= a 1)
                (= b 1)))))

  (it "may be recursively bound using letrec"
    (letrec [(x (lambda () x))]
      (affirm (= x (x)))))

  (may "be bound using when-let"
    (will "execute all items"
      (let* [(ctr 0)
             (state! (lambda (x) (inc! ctr) x))]
        (when-let [(a (state! true))
                   (b (state! true))
                   (c (state! false))
                   (d (state! false))]
          (fail! "This should not be reached"))
        (affirm (= ctr 4))))

    (will "execute the body"
      (let* [(ctr 0)
             (state! (lambda (x) (inc! ctr) x))]
        (when-let [(a (state! true))
                   (b (state! true))
                   (c (state! true))
                   (d (state! true))]
          (affirm (= ctr 4))
          (set! ctr -1))
        (affirm (= ctr -1)))))

  (may "be bound using when-let*"
    (will-not "execute all items"
      (let* [(ctr 0)
             (state! (lambda (x) (inc! ctr) x))]
        (when-let* [(a (state! true))
                    (b (state! true))
                    (c (state! false))
                    (d (state! false))]
          (fail! "This should not be reached"))
        (affirm (= ctr 3))))

    (will "execute the body"
      (let* [(ctr 0)
             (state! (lambda (x) (inc! ctr) x))]
        (when-let* [(a (state! true))
                    (b (state! true))
                    (c (state! true))
                    (d (state! true))]
          (affirm (= ctr 4))
          (set! ctr -1))
        (affirm (= ctr -1)))))

)
