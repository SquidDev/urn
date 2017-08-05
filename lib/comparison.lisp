(import base b)
(import base (defun defmacro gensym and n with let* if get-idx list ..))

(defun mk-quote (a) :hidden (list `unquote a))
(defun mk-splice-quote (a) :hidden (list `unquote-splice a))

(defmacro def-comparison (name func-name)
  "Def a comparison macro with the given NAME, which calls FUNC-NAME with two operands.

   ### Example
   ```
   > (< 1 2 3)
   true
   > (< 1 4 3)
   false
   ```"
  :hidden
  (let* [(a (gensym))
         (b (gensym))
         (sym (gensym))
         (len (gensym))
         (rest (gensym))]
    ;; Sit back and enjoy the quote/unquote awfulness.
    `(defmacro ,name (,a ,b ,{ :tag "symbol" :contents (.. "&" (get-idx rest :contents)) })
       (with (,len (n ,rest))
         (cond
           [(b/= ,len 0) `(,,func-name ,,(mk-quote a) ,,(mk-quote b))]
           [:else
            (with (,sym (gensym))
              ;; If we've got multiple values then cache b, as that will be reused in the next operator
              `(with (,,(mk-quote sym) ,,(mk-quote b))
                 (if (,,func-name ,,(mk-quote a) ,,(mk-quote sym)) (,,name ,,(mk-quote sym) ,,(mk-splice-quote rest)) false)))])))))

(def-comparison = b/=)
(def-comparison /= b//=)
(def-comparison < b/<)
(def-comparison > b/>)
(def-comparison <= b/<=)
(def-comparison >= b/>=)
