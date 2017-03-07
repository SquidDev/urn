(import lua/os os)

(defmacro time! (body)
  "Modify the function definition BODY so that all executions
   are automatically timed. The time report is printed to standard
   output.
   
   Note that documentation strings and other attributes are
   not preserved, and that the definition must be of the form
   
   ```
   (defun foo (bar) ...)
   ``` "
  (destructuring-bind [(defun ?name ?args . ?body) body]
    (let* [(time-sym (gensym))]
      `(defun ,name ,args
         (let* [(,time-sym (os/clock))]
           ,@body
           (print! (.. (pretty (list ',name ,@args)) " took "
                       (- (os/clock) ,time-sym))))))))

(defmacro benchmark! (times body)
  "Modify the function definition BODY so that all executions are
   benchmarked. That is, the function is run repeatededly TIMES times,
   and the average running time is reported on standard output.
  
   Note that documentation strings and other attributes are
   not preserved, and that the definition must be of the form
   
   ```
   (defun foo (bar) ...)
   ``` "
  (destructuring-bind [(defun ?name ?args . ?body) body]
    (let* [(time-sym (gensym))
           (counter-sym (gensym))]
      `(defun ,name ,args
         (let* [(,name (lambda ,args ,@body))
                (,time-sym (os/clock))]
           (for ,counter-sym 1 ,times 1
             (,name ,@args))
           (print! (.. (pretty (list ',name ,@args))
                       " took, on average, "
                       (/ (- (os/clock) ,time-sym)
                          ,times)
                       " seconds per iteration.")))))))
