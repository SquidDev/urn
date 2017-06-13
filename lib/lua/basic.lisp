(define-native =)
(define-native /=)
(define-native <)
(define-native <=)
(define-native >)
(define-native >=)

(define-native +)
(define-native -)
(define-native *)
(define-native /)
(define-native %)
(define-native ^)
(define-native ..)

(define-native _G)
(define-native _ENV)
(define-native arg#)
(define-native len#)

(define-native assert)
(define-native collectgarbage)
(define-native dofile)
(define-native error)
(define-native getmetatable)
(define-native ipairs)
(define-native load)
(define-native loadfile)
(define-native next)
(define-native pairs)
(define-native pcall)
(define-native print)
(define-native rawequal)
(define-native get-idx)
(define-native rawlen)
(define-native set-idx!)
(define-native rawget)
(define-native rawset)
(define-native require)
(define-native select)
(define-native setmetatable)
(define-native tonumber)
(define-native tostring)
(define-native type#)
(define-native xpcall)

(define n
  "Get the length of list X"
  (lambda (x)
    (cond
      [(= (type# x) "table")
       (get-idx x "n")]
      [true (len# x)])))

(define slice
  "Take a slice of XS, with all values at indexes between START and FINISH (or the last
   entry of XS if not specified)."
  (lambda (xs start finish)
    ;; Ensure finish isn't nil
    (cond
      [finish]
      [true
       (set! finish (get-idx xs :n))
       (cond [finish] [true (set! finish (len# xs))])])

    ;; Copy values across.
    ((lambda (len lam)
       (set! lam (lambda (out i j)
                   (cond
                     [(<= j finish)
                      (set-idx! out i (get-idx xs j))
                      (lam out (+ i 1) (+ j 1))]
                     [true out])))

       (cond [(< len 0) (set! len 0)] [true])
       (lam { :tag "list" :n len } 1 start)) (+ (- finish start) 1))))
