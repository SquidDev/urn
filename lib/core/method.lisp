(import core/base (defun defmacro let* with if when for for-pairs and or
                   unless values-list
                   get-idx set-idx! n print not car cdr else setmetatable
                   getmetatable list error gensym tostring const-val len#
                   = /= >= + - ..))
(import core/type (type key? table?))

(import lua/table (remove concat))
(import lua/string (format))

(defmacro deep-get (x f &keys)
  "This is a not-invented-here version of .> from table"
  :hidden
  ;; Silly optimisation: the first key isn't guarded against.
  ;; Even sillier: one-key gets aren't guarded either.
  ;; Even sillier: Instead of resolving to guarded.
  (let* [(res `(get-idx ,x ,f))]
    (cond
      [(= (n keys) 1)
       `(get-idx ,res ,(car keys))]
      [else
        (for i 1 (- (n keys) 1) 1
          (set! res `(or (get-idx ,res ,(get-idx keys i)) {})))
        `(get-idx ,res ,(get-idx keys (n keys)))])))

(defun map (f x)
  "This is a bad version of map"
  :hidden
  (let* [(out '())]
    (for i 1 (n x) 1
      (set-idx! out i (f (get-idx x i))))
    (set-idx! out :n (n x))
    out))

(defun keys (x)
  "This is a bad version of keys"
  :hidden
  (let* [(out '())
         (n 0)]
    (for-pairs (k _) x
      (set! n (+ 1 n))
      (set-idx! out n k))
    (set-idx! out :n n)
    out))

(defun s->s (x) :hidden (get-idx x :contents))

(defmacro defgeneric (name ll &attrs)
  "Define a generic method called NAME with the arguments given in LL,
   and the attributes given in ATTRS. Note that documentation _must_
   come after LL; The mixed syntax accepted by `define` is not allowed.

   ### Examples:
   ```cl :no-test
   > (defgeneric my-pretty-print (x)
   .   \"Pretty-print a value.\")
   out = «method: (my-pretty-print x)»
   > (defmethod (my-pretty-print string) (x) x)
   out = nil
   > (my-pretty-print \"foo\")
   out = \"foo\"
   ```"
  (let* [(this (gensym 'this))
         (key (gensym 'key))
         (method (gensym 'method))
         (delegate `(lambda (,@ll)
                      (let* [(,method (or (deep-get ,this :lookup ,@(map (lambda (x)
                                                                           `(type ,x)) ll))
                                          (get-idx ,this :default)))]
                        (unless ,method
                          (error (.. "No matching method to call for ("
                                     (concat (list ,(s->s name)
                                                   ,@(map (lambda (x) `(type ,x)) ll))
                                             " ")
                                     ")")))
                        (,method ,@ll))))]

    (for i (- (n attrs) 1) 1 -1
      (with (elem (get-idx attrs i))
        (when (and (key? elem) (= (get-idx elem :value) "delegate"))
          (set! delegate `(with (,'myself ,delegate)
                            ,(get-idx attrs (+ i 1))))
          (remove attrs i)
          (remove attrs i)
          (set-idx! attrs :n (- (get-idx attrs :n) 2)))))

    `(define ,name
       ,@attrs
       (with (,this { :lookup {}
                      :tag :multimethod })
         (setmetatable
           ,this
           { :__call (with (,'myself ,delegate)
                       (lambda (,this ,@ll)
                         (,'myself ,@ll)))
             :name ,(s->s name)
             :args (list ,@(map s->s ll)) })))))

(defun put! (t typs l) :hidden
  "Insert the method L (at TYPS) into the lookup table T, creating any needed
   definitions."
  (let* [(len (n typs))]
    (for i 1 (- len 1) 1
      (let* [(x (get-idx typs i))
             (y (get-idx t x))]
        (unless y
          (set! y {})
          (set-idx! t x y))

        (set! t y)))

    (set-idx! t (get-idx typs len) l)))

(defun eval-both (expr)
  "Evaluate EXPR at compile time and runtime."
  :hidden
  (values-list (list `unquote expr) expr))

(defmacro defmethod (name ll &body)
  "Add a case to the generic method NAME with the arguments LL and the body
   BODY. The types of arguments for this specialisation are given in the list
   NAME, and the argument names are merely used to build the lambda.

   BODY has in scope a symbol, `myself`, that refers specifically to this
   instantiation of the generic method NAME. For instance, in

   ```cl :no-test
   (defmethod (my-pretty-print string) (x)
     (myself (.. \"foo \" x)))
   ```

   `myself` refers only to the case of `my-pretty-print` that handles strings.

   ### Example
   ```cl :no-test
   > (defgeneric my-pretty-print (x)
   .   \"Pretty-print a value.\")
   out = «method: (my-pretty-print x)»
   > (defmethod (my-pretty-print string) (x) x)
   out = nil
   > (my-pretty-print \"foo\")
   out = \"foo\"
   ```"
  (eval-both
    `(put! ,(car name) (list :lookup ,@(map s->s (cdr name)))
           (let* [(,'myself nil)]
             ;; this is a bodged-together letrec
             (set! ,'myself (lambda ,ll ,@body))
             ,'myself))))

(defmacro defdefault (name ll &body)
  "Add a default case to the generic method NAME with the arguments LL and the
   body BODY.

   BODY has in scope a symbol, `myself`, that refers specifically to this
   instantiation of the generic method NAME. For instance, in

   ```cl :no-test
   (defdefault my-pretty-print (x)
     (myself (.. \"foo \" x)))
   ```

   `myself` refers only to the default case of `my-pretty-print`"
  (eval-both `(set-idx! ,name :default
                (let* [(,'myself nil)]
                  (set! ,'myself (lambda ,ll ,@body))
                  ,'myself))))

(defmacro defalias (name other)
  "Alias the method at NAME to the method at OTHER."
  (eval-both `(put! ,(car name) (list :lookup ,@(map s->s (cdr name)))
                    (deep-get ,(car other) :lookup ,@(map s->s (cdr other))))))


(defun neq? (x y)
  "Compare X and Y for inequality deeply. X and Y are `neq?`
   if `([[eq?]] x y)` is falsey."
  (not (eq? x y)))

(defun eql? (x y)
  "A version of [[eq?]] that compares the types of X and Y instead of
   just the values.

   ### Example:
   ```cl
   > (eq? 'foo \"foo\")
   out = true
   > (eql? 'foo \"foo\")
   out = false
   ```"
  (and (eq? (type x) (type y))
       (eq? x y)))

(defgeneric eq? (x y)
  "Compare values for equality deeply."
  :delegate (lambda (x y)
              (if (= x y)
                true
                (myself x y))))

(defmethod (eq? list list) (x y)
  (if (/= (n x) (n y))
    false
    ; the implementation is new but the optimism is not
    (let* [(equal true)]
      (for i 1 (n x) 1
        (when (neq? (get-idx x i) (get-idx y i))
          (set! equal false)))
      equal)))

(defmethod (eq? table table) (x y)
  (let* [(equal true)]
    (for-pairs (k v) x
      (if (neq? v (get-idx y k))
        (set! equal false)
        nil))
    equal))

(defmethod (eq? symbol symbol) (x y)
  (= (get-idx x :contents) (get-idx y :contents)))
(defmethod (eq? string symbol) (x y)
  (= x (get-idx y :contents)))
(defmethod (eq? symbol string) (x y)
  (= (get-idx x :contents) y))

(defmethod (eq? key string) (x y)
  (= (get-idx x :value) y))
(defmethod (eq? string key) (x y)
  (= x (get-idx y :value)))
(defmethod (eq? key key) (x y)
  (= (get-idx x :value) (get-idx y :value)))

(defmethod (eq? number number) (x y) (= (const-val x) (const-val y)))
(defmethod (eq? string string) (x y) (= (const-val x) (const-val y)))

(defdefault eq? (x y) false)


(defgeneric pretty (x)
  "Pretty-print a value.")

(defmethod (pretty list) (xs)
  (.. "(" (concat (map pretty xs) " ") ")"))

(defmethod (pretty symbol) (x)
  (get-idx x :contents))

(defmethod (pretty key) (x)
  (.. ":" (get-idx x :value)))

(defmethod (pretty number) (x)
  (format "%g" (const-val x)))

(defmethod (pretty string) (x)
  (format "%q" (const-val x)))

(defmethod (pretty table) (x)
  (let* [(out '())]
    (for-pairs (k v) x
      (set! out `(,(.. (pretty k) " " (pretty v)) ,@out)))
    (.. "{" (.. (concat out " ") "}"))))

(defmethod (pretty multimethod) (x)
  (.. "«method: (" (get-idx (getmetatable x) :name) " " (concat (get-idx (getmetatable x) :args) " ") ")»"))

(defdefault pretty (x)
  (if (table? x)
    ((get-idx (get-idx pretty :lookup) :table) x)
    (tostring x)))

(defmacro debug (x)
  "Print the value X, then return it unmodified."
  (let* [(x-sym (gensym))
         (px (pretty x))
         (nm (if (>= 20 (len# px))
               (.. px " = ")
               ""))]
    `(let* [(,x-sym ,x)]
       (print (.. ,nm (pretty ,x-sym)))
       ,x-sym)))
