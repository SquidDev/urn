(import core/prelude ())
(import data/format ())
(import math (succ pred))

(defun const (x) :hidden
  (lambda (y)
    x))

(define *setq-generators*
  :hidden '())

(defun add-setq-generator! (generator) :hidden
  (push! *setq-generators* generator)
  `nil)

(defun match-setq-pattern (val) :hidden
  (loop [(i 1)
         (n (n *setq-generators*))]
    [(> i n)]
    (or ((nth *setq-generators* i) val) (recur (+ i 1) n))))

(defmacro over! (address fun)
  "Replace the value at ADDRESS according to FUN.

   ### Examples:
   ```
   > (define list '(1 2 3))
   out = (1 2 3)
   > (over! (car list) (cut = <> 2))
   out = (false 2 3)
   ```"
  (if-with (body (match-setq-pattern address))
    (body fun)
    (format 1 "No way to (setq! {#address} {#fun}")))

(defmacro setq! (address value)
  "Replace the value at ADDRESS with VALUE.

   ### Examples:
   ```
   > (define list '(1 2 3))
   out = (1 2 3)
   > (setq! (car list) 3)
   out = (3 2 3)
   ```"
  (if-with (body (match-setq-pattern address))
    (body `(const ,value))
    (format 1 "No way to (setq! {#address} {#value}")))

(defmacro defsetq (pattern repl)
  "Define the `setq!`/`over!` PATTERN with the replacement REPL. The
   replacement must be a lambda, which is going to be applied to the
   (quoted) replacement. Captures in the pattern are also available in
   the replacement's scope.

   Note that the value given to REPL is *not* a value: Rather, it is a
   function that decides what the new value should be. The returned
   value must be a list, preferably of the form

   ```cl :no-test
   (progn ... ; modify the value
          the-value)
   ```

   That is - modify the value, then return it.

   ### Example:
   ```cl :no-test
   > (defsetq
   .   (car ?addr)
   .   (lambda (val)
   .     `(.<! ,addr 1 (,val (.> ,addr 1)))))
   ```"
  (with (val (gensym))
    (list `unquote
          `(add-setq-generator!
             (lambda (,val)
               (case ,val
                 [,pattern ,repl]
                 [,'_ nil]))))))

(defsetq (car ?addr)
         (lambda (fun)
           (with (xs (gensym 'xs))
             `(with (,xs ,addr)
                (.<! ,xs 1 (,fun (.> ,xs 1)))
                ,xs))))

;; Auto-generate all `ca[ad]r`/`c[ad]rs` methods.
(defun mk-list (name idx stack)
  "A bit of a hack function to prevent capturing loop upvalues."
  :hidden
  (lambda (xs)
    (case xs
      [((?fname ?xs) :when (eq? fname name))
       (lambda (fn)
         (let* [(val (gensym 'val))
                (temp (gensym))]
           `(let* [(,val ,xs)
                   (,temp ,(reduce (lambda (x y) (list y x)) val stack))]
              (.<! ,temp ,idx (,fn (.> ,temp ,idx)))
              ,val)))]
      [_ nil])))

,(let* [(depth-symb (lambda (idx mode) (string->symbol (.. "c" mode (string/rep "d" (- idx 1)) "r"))))]
    (loop [(name "a")
           (stack '())
           (idx 1)
           (depth 3)]
      []
      (when (> (n name) 1)
        (add-setq-generator! (mk-list (string->symbol (.. "c" name "r")) idx stack)))

      (cond
        [(<= depth 0)]
        [else
         (recur (.. name "a") (cons (depth-symb idx "a") stack) 1 (- depth 1))
         (recur (.. name "d") stack (+ idx 1) (- depth 1))])))

(defsetq (.> ?addr ?key)
         (lambda (fun)
           (let* [(val (gensym 'val))
                  (key-s (gensym 'key))]
             `(let [(,val ,addr)
                    (,key-s ,key)]
                (.<! ,val ,key-s (,fun (.> ,val ,key-s)))
                ,val))))

(defsetq (nth ?addr ?idx)
         (lambda (fun)
           (let* [(val (gensym 'val))
                  (idx-s (gensym 'idx))]
             `(let [(,val ,addr)
                    (,idx-s ,idx)]
                (if (>= ,idx-s 0)
                  (.<! ,val ,idx-s (,fun (.> ,val ,idx-s)))
                  (with (,idx-s (+ (.> ,val :n) 1 ,idx-s))
                    (.<! ,val ,idx-s (,fun (.> ,val ,idx-s)))))
                ,val))))

(defmacro inc! (address)
  "Increments the value described by ADDRESS by 1.

   ### Example
   ```cl
   > (with (x 1)
   .   (inc! x)
   .   x)
   out = 2
   ```"
  `(over! ,address succ))

(defmacro dec! (address)
  "Decrements the value described by ADDRESS by 1.

   ### Example
   ```cl
   > (with (x 1)
   .   (dec! x)
   .   x)
   out = 0
   ```"
  `(over! ,address pred))

,(add-setq-generator!
   (lambda (x)
     (when (symbol? x)
       (lambda (fun)
         `(set! ,x (,fun ,x))))))
