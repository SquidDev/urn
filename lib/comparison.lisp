"Provides macros for various comparison operators."

(import base b)
(import base (defun defmacro gensym and n with let* if get-idx list .. else get-idx car))

(defun mk-quote (a) :hidden (list `unquote a))
(defun mk-splice-quote (a) :hidden (list `unquote-splice a))

(defmacro def-comparison (name names func-name &additional)
  "Def a comparison macro with the given NAME, which calls FUNC-NAME with two operands.

   ### Example:
   ```
   > (< 1 2 3)
   true
   > (< 1 4 3)
   false
   ```"
  :hidden
  (let* [(a (car names))
         (b (get-idx names 2))
         (sym (gensym))
         (len (gensym))
         (rest (get-idx names 3))]
    ;; Sit back and enjoy the quote/unquote awfulness.
    `(defmacro ,name (,a ,b ,{ :tag "symbol" :contents (.. "&" (get-idx rest :contents)) })
       ,@additional
       (with (,len (n ,rest))
         (cond
           [(b/= ,len 0) `(,,func-name ,,(mk-quote a) ,,(mk-quote b))]
           [else
            (with (,sym (gensym))
              ;; If we've got multiple values then cache b, as that will be reused in the next operator
              `(with (,,(mk-quote sym) ,,(mk-quote b))
                 (if (,,func-name ,,(mk-quote a) ,,(mk-quote sym)) (,,name ,,(mk-quote sym) ,,(mk-splice-quote rest)) false)))])))))

(def-comparison = (a b rest) b/=
  "Check whether A, B and all items in REST are equal.

   This will lazily evaluate each value: if A is not equal to B, then no
   subsequent arguments will be evaluated.

   ### Example:
   ```cl
   > (let [(a 1)
   .       (b 2)]
   .   (= 1 a b))
   out = false
   > (with (a 1)
   .   (= a 1))
   out = true
   ```")

(def-comparison /= (a b rest) b//=
  "Check whether A is not equal to B, B is not equal to the first element
   in REST, etc...

   This will lazily evaluate each value: if A is equal to B, then no
   subsequent arguments will be evaluated.

   ### Example:
   ```cl
   > (let [(a 1)
   .       (b 2)]
   .   (/= a b 1))
   out = true
   > (with (a 1)
   .   (/= a 1))
   out = false
   ```")

(def-comparison < (a b rest) b/<
  "Check whether A is smaller than B, B is smaller than the first element
   in REST, and so on for all subsequent arguments.

   This will lazily evaluate each value: if A is greater or equal to B,
   then no subsequent arguments will be evaluated.

   ### Example:
   ```cl
   > (with (a 3)
   .   (< 1 a 5))
   out = true
   ```")

(def-comparison > (a b rest) b/>
  "Check whether A is larger than B, B is larger than the first element
   in REST, and so on for all subsequent arguments.

   This will lazily evaluate each value: if A is smaller or equal to B,
   then no subsequent arguments will be evaluated.

   ### Example:
   ```cl
   > (with (a 3)
   .   (> 5 a 1))
   out = true
   ```")

(def-comparison <= (a b rest) b/<=
  "Check whether A is smaller or equal to B, B is smaller or equal to the
   first element in REST, and so on for all subsequent arguments.

   This will lazily evaluate each value: if A is larger than B,
   then no subsequent arguments will be evaluated.

   ### Example:
   ```cl
   > (with (a 3)
   .   (<= 1 a 5))
   out = true
   ```")

(def-comparison >= (a b rest) b/>=
  "Check whether A is larger or equal to B, B is larger or equal to the
   first element in REST, and so on for all subsequent arguments.

   This will lazily evaluate each value: if A is smaller than B,
   then no subsequent arguments will be evaluated.

   ### Example:
   ```cl
   > (with (a 3)
   .   (>= 5 a 1))
   out = true
   ```")
