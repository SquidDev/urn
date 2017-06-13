(import base (defmacro if with get-idx set-idx! gensym
              slice + - .. n))

(import binders (let*))
(import type (symbol?))
(import list (car cdr nth))
(import table (.> .<!))

(import compiler/resolve res)
(import compiler/nodes nodes)

(defmacro setf! (obj val)
  "Set the location selector OBJ to VAL.

   If OBJ is a symbol, then the symbol will just have its variable set,
   identical to using `set!`.

   Otherwise, OBJ must be a list. This should be in the form of the
   getter you'd normally use to access that value. For instance, to set
   the first element of the list, you'd use `(setf! (car xs) 42)`.

   This function given in the getter will have `/setf!` appended to it,
   and looked up in the scope the getter is defined in (or the current
   scope if not found). This definition will then be used to generate the
   setter.

   ### Example
   ```cl
   (setf! foo 123) ;; Set the symbol foo to 123
   (setf! (.> foo :bar) 123) ;; Set the value of index bar in structure
                             ;; foo to 123.
   ```"
  (if (symbol? obj)
    `(set! ,obj ,val)
    (let* [(symb (car obj))
           (getter (.> (res/var-lookup symb)))
           (name { :tag "symbol" :contents (.. (.> symb :contents) "/setf!") })
           (setter (res/try-var-lookup name (.> (res/var-lookup symb) :scope)))]
      `(,(if setter (nodes/var->symbol setter) name) ,(cdr obj) ,val))))

(defmacro over! (obj fun)
  "Apply function FUN over the location selector OBJ, storing the result
   in the same place.

   If OBJ is a symbol, then the symbol will just apply FUN, and set the
   symbol again.

   Otherwise, OBJ must be a list. This should be in the form of the
   getter you'd normally use to access that value. For instance, to set
   the first element of the list, you'd use `(over! (car xs) succ)`.

   This function given in the getter will have `/over!` appended to it,
   and looked up in the scope the getter is defined in (or the current
   scope if not found). This definition will then be used to generate the
   accessor and setter. Implementations should cache accesses, meaning
   that lists and structures are not indexed multiple times.

   ### Example
   ```cl
   (over! foo (cut + <> 2)) ;; Add 2 to foo
   (over! (.> foo :bar) (out + <> 2)) ;; Add 2 to the value of index
                                      ;; bar in structure foo.
   ```"
  (if (symbol? obj)
    `(set! ,obj (,fun ,obj))
    (let* [(symb (car obj))
           (getter (.> (res/var-lookup symb)))
           (name { :tag "symbol" :contents (.. (.> symb :contents) "/over!") })
           (setter (res/try-var-lookup name (.> (res/var-lookup symb) :scope)))]
      `(,(if setter (nodes/var->symbol setter) name) ,(cdr obj) ,fun))))

(defmacro inc! (x)
  "Increment the value selector X in place."
  `(over! ,x (lambda (,'x) (+ ,'x 1))))

(defmacro dec! (x)
  "Decrement the value selector X in place."
  `(over! ,x (lambda (,'x) (- ,'x 1))))
