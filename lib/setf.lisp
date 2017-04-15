(import base (defmacro if with get-idx set-idx! gensym
              slice + - .. #))

(import binders (let))
(import type (symbol?))
(import list (car cdr nth))
(import table (.> .<!))

(defmacro setf! (obj val)
  "Set the location selector OBJ to VAL.

   If OBJ is a symbol, then the symbol will just have its variable set,
   identical to using `set!`.

   Otherwise, OBJ must be a list. This should be in the form of the
   getter you'd normally use to access that value. For instance, to set
   the first element of the list, you'd use `(setf! (car xs) 42)`.

   This function given in the getter will have `/setf!` appended to it,
   and looked up in the current scope. This definition will then be used
   to generate the setter.

   ### Example
   ```cl
   (setf! foo 123) ;; Set the symbol foo to 123
   (setf! (.> foo :bar) 123) ;; Set the value of index bar in structure
                             ;; foo to 123.
   ```"
  (if (symbol? obj)
    `(set! ,obj ,val)
    `(,{:tag "symbol" :contents (.. (.> (car obj) :contents) "/setf!")} ,(cdr obj) ,val)))

(defmacro .>/setf! (selector val)
  "An implementation of [[setf!]] for table acccess.

   This should not be used directly, but via [[setf!]] or [[.<!]]
   instead.

   ### Example
   ```cl
   (setf! (.> foo :bar) 123)
   ```"
  `(.<! ,@selector ,val))

(defmacro nth/setf! (selector val)
  "An implementation of [[setf!]] for list access.

   This should not be used directly, but via [[setf!]] instead.

   ### Example
   ```cl
   (setf! (nth foo 2) 123)
   ```"
  `(set-idx! ,(nth selector 1) ,(nth selector 2) ,val))

(defmacro car/setf! (selector val)
  "An implementation of [[setf!]] for [[car]].

   This should not be used directly, but via [[setf!]] instead.

   ### Example
   ```cl
   (setf! (car foo) 123)
   ```"
  `(set-idx! ,(nth selector 1) 1 ,val))

(defmacro over! (obj fun)
  "Apply function FUN over the location selector OBJ, storing the result
   in the same place.

   If OBJ is a symbol, then the symbol will just apply FUN, and set the
   symbol again.

   Otherwise, OBJ must be a list. This should be in the form of the
   getter you'd normally use to access that value. For instance, to set
   the first element of the list, you'd use `(over! (car xs) succ)`.

   This function given in the getter will have `/over!` appended to it,
   and looked up in the current scope. This definition will then be used
   to generate the accessor and setter. Implementations should cache
   accesses, meaning that lists and structures are not indexed multiple
   times.

   ### Example
   ```cl
   (over! foo (cut + <> 2)) ;; Add 2 to foo
   (over! (.> foo :bar) (out + <> 2)) ;; Add 2 to the value of index
                                      ;; bar in structure foo.
   ```"
  (if (symbol? obj)
    `(set! ,obj (,fun ,obj))
    `(,{:tag "symbol" :contents (.. (.> (car obj) :contents) "/over!")} ,(cdr obj) ,fun)))

(defmacro .>/over! (selector fun)
  "An implementation of [[over!]] for table access.

   This should not be used directly, but via [[over!]].

   ### Example
   ```cl
   (over! (.> foo :bar) (cut + <> 2))
    ```"
  (let [(key-sym (gensym))
        (val-sym (gensym))]
    `(let [(,val-sym (.> ,@(slice selector 1 (- (# selector) 1))))
           (,key-sym ,(nth selector (# selector)))]
       (set-idx! ,val-sym ,key-sym (,fun (get-idx ,val-sym ,key-sym))))))

(defmacro nth/over! (selector fun)
  "An implementation of [[over!]] for list access.

   This should not be used directly, but via [[over!]] instead.

   ### Example
   ```cl
   (over! (nth foo 2) (cut + <> 2))
   ```"
  (let [(key-sym (gensym))
        (val-sym (gensym))]
    `(let [(,val-sym ,(nth selector 1))
           (,key-sym ,(nth selector 2))]
       (set-idx! ,val-sym ,key-sym (,fun (get-idx ,val-sym ,key-sym))))))

(defmacro car/over! (selector fun)
  "An implementation of [[over!]] for [[car]].

   This should not be used directly, but via [[over!]] instead.

   ### Example
   ```cl
   (over! (car foo) (cut + <> 2))
   ```"
  (with (val-sym (gensym))
    `(with (,val-sym ,(nth selector 1))
       (set-idx! ,val-sym 1 (,fun (car ,val-sym))))))

(defmacro inc! (x)
  "Increment the value selector X in place."
  `(over! ,x (lambda (,'x) (+ ,'x 1))))

(defmacro dec! (x)
  "Decrement the value selector X in place."
  `(over! ,x (lambda (,'x) (- ,'x 1))))
