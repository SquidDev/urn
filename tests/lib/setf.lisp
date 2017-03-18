(import extra/test ())
(import extra/assert (affirm))

(describe "setf"
  (it "can set symbols"
    (with (x 0)
      (setf! x 1)
      (affirm (= x 1))))

  (it "can set table indexes"
    (with (x (const-struct
               :a 0
               :b (empty-struct)
               :c (const-struct :d (empty-struct))))
      (setf! (.> x :a) 1)
      (setf! (.> x :b :foo) 1)
      (setf! (.> x :c :d :foo) 1)

      (affirm (= (.> x :a) 1)
              (= (.> x :b :foo) 1)
              (= (.> x :c :d :foo) 1))))

  (it "can set list indexes"
    (with (x '(0 0 (0)))
      (setf! (nth x 1) 1)
      (setf! (nth x 2) 1)
      (setf! (nth (nth x 3) 1) 1)

      (affirm (= (nth x 1) 1)
              (= (nth x 2) 1)
              (= (nth (nth x 3) 1) 1))))

  (it "can set car"
    (with (x '(0 (0)))
      (setf! (car x) 1)
      (setf! (car (nth x 2)) 1)

      (affirm (= (car x) 1)
              (= (car (nth x 2)) 1))))

  (it "can map over symbols"
    (with (x 0)
      (over! x succ)
      (affirm (= x 1))))

  (it "can map over table indexes"
    (with (x (const-struct
               :a 0
               :b (const-struct :foo 0)
               :c (const-struct :d (const-struct :foo 0))))
      (over! (.> x :a) succ)
      (over! (.> x :b :foo) succ)
      (over! (.> x :c :d :foo) succ)

      (affirm (= (.> x :a) 1)
              (= (.> x :b :foo) 1)
              (= (.> x :c :d :foo) 1))))

  (it "can map over list indexes"
    (with (x '(0 0 (0)))
      (over! (nth x 1) succ)
      (over! (nth x 2) succ)
      (over! (nth (nth x 3) 1) succ)

      (affirm (= (nth x 1) 1)
              (= (nth x 2) 1)
              (= (nth (nth x 3) 1) 1))))

  (it "can map over car"
    (with (x '(0 (0)))
      (over! (car x) succ)
      (over! (car (nth x 2)) succ)

      (affirm (= (car x) 1)
              (= (car (nth x 2)) 1))))
  )
