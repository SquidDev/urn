(import compiler/nodes compiler)
(import compiler/resolve compiler)
(import core/prelude ())

(defmacro exported-vars ()
  "Generate a struct with all variables exported in the current module.

   ### Example:
   ```cl
   > (let [(a 1)]
   .   (exported-vars))
   out = {\"a\" 1}
   ```

   ```cl :no-test
   (define x 1)
   (define y 2)
   (define z 3)
   (exported-vars) ;; { :x 1 :y 2 :z 3 }
   ```"
  (with (out '{})
    (for-pairs (name var) (compiler/scope-exported)
      (push! out name)
      (push! out (compiler/var->symbol var)))
    out))
