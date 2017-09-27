(import test ())
(import io/argparse ())

(describe "We can parse! arguments"
  (section "with a positional argument"
    (it "which accepts any number of values"
      (with (spec (create))
        (add-argument! spec '("x"))
        (affirm (eq? { :x '() }
                     (parse! spec '()))
                (eq? { :x '("foo" "bar") }
                     (parse! spec '("foo" "bar"))))))

    (it "which accepts a fixed number of values"
      (with (spec (create))
        (add-argument! spec '("x") :narg 2)
        (affirm (eq? { :x '("foo" "bar") }
                     (parse! spec '("foo" "bar")))))))

  (it "with multiple positional arguments"
    (with (spec (create))
      (add-argument! spec '("x") :narg 1)
      (add-argument! spec '("y") :narg "*")

      (affirm (eq? { :x '() :y '() }
                   (parse! spec '()))
              (eq? { :x "foo" :y '() }
                   (parse! spec '("foo")))
              (eq? { :x "foo" :y '("bar" "baz") }
                   (parse! spec '("foo" "bar" "baz"))))))

  (section "can have option arguments"
    (it "which accept any number of values"
      (with (spec (create))
        (add-argument! spec '("--x") :narg "*")
        (affirm (eq? { :x false }
                     (parse! spec '()))
                (eq? { :x false }
                     (parse! spec '("--x")))
                (eq? { :x '("foo") }
                     (parse! spec '("--x=foo")))
                (eq? { :x '("foo") }
                     (parse! spec '("--x" "foo")))
                (eq? { :x '("foo" "bar") }
                     (parse! spec '("--x" "foo" "bar"))))))

    (it "which accept an optional value"
      (with (spec (create))
        (add-argument! spec '("--x") :narg "?" :value "y")
        (affirm (eq? { :x false }
                     (parse! spec '()))
                (eq? { :x "y" }
                     (parse! spec '("--x")))
                (eq? { :x "z" }
                     (parse! spec '("--x=z"))))))

    (it "which can accept a fixed number of values"
      (with (spec (create))
        (add-argument! spec '("--x") :narg 2)
        (affirm (eq? { :x '("foo" "bar") }
                     (parse! spec '("--x" "foo" "bar"))))))))
