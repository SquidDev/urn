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
         (method (gensym 'method))]
    `(define ,name
       ,@attrs
       (setmetatable
         { :lookup {} }
         { :__call (lambda ,(cons this ll)
                     (let* [(,method (.> ,this :lookup ,@(map (cut list `type <>) ll)))]
                       (unless ,method
                         (error! (.. "No matching method to call for "
                                     ,@(flat-map (lambda (x)
                                                   `((type ,x) " "))
                                                 ll)
                                     "\nthere are methods to call for "
                                     (pretty (keys (.> ,this :lookup))))))
                       (,method ,@ll)))
           :--pretty-print (lambda (,this)
                             ,(.. "«method: (" (symbol->string name) " "
                                  (concat (map symbol->string ll) " ") ")»")) }))))

(defun put! (t typs l) :hidden
  "Insert the method L (at TYPS) into the lookup table T, creating any needed
   definitions."
  (case typs
    [(?x) (.<! t x l)]
    [(?x . ?y)
     (if (.> t x)
       (put! (.> t x) y l)
       (progn
         (.<! t x {})
         (put! (.> t x) y l)))]))

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
  `(put! ,(car name) (list :lookup ,@(map symbol->string (cdr name)))
         (letrec [(,'self (lambda ,ll ,@body))]
           ,'self)))
