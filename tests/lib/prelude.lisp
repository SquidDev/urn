(import extra/assert ())
(import extra/test ())
(import extra/check ())

(describe "The prelude library"
  (it "can call functions inside structs"
    (let* [(st { :f (lambda (x) (+ x 1)) })
           (y (call st :f 4))]
      (affirm (= y 5))))
  (it "can call functions inside structs that refer to the struct"
    (let* [(st { :x 5 :f (lambda (s y) (.<! s :x y)) })]
      (self st :f 6)
      (affirm (= (.> st :x) 6)))))
