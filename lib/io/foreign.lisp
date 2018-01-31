"Higher-level wrappers around the LuaJIT ffi module."

(import luajit/ffi (cdef C) :export)
(import luajit/bit bit :export)
(import luajit/ffi ffi :export)


(defmacro define-foreign-function (name lambda-list do-errno-check)
  "Define a foreign function wrapper for the C symbol NAME, taking
   arguments LAMBDA-LIST.

   Additionally, if DO-ERRNO-CHECK is true or a number, assume that
   negative return values (or the number, if given) signal an error
   condition, and raise an exception with the message determined by
   strerror(3).

   The symbol NAME will be mangled by replacing `-`s with `_`s. If this
   is undesirable, you may give an argument of the form `(quote foo)`,
   in which foo will not be mangled.


   ### Example:

   ```cl :no-test
   > (ffi/cdef \"char *get_current_dir_name(void);\")
   out = nil
   > (define-foreign-function get-current-dir-name () 0)
   out = function: 0x42e22188
   > (get-current-dir-name)
   out = cdata<char *>: 0x00d26610
   > (ffi/string (get-current-dir-name))
   out = \"/home/hydraz/Projects/urn/compiler\"
   ```"
  (let* [(exit (gensym))
         (fun (gensym))
         (status (gensym))
         (mangle (lambda (nam)
                   (case nam
                     [(quote ?x) (symbol->string x)]
                     [symbol? => (first (string/gsub (symbol->string it) "-" "_"))])))]

    (ffi/cdef "char *strerror(int);")
    `(defun ,name ,lambda-list
       (ffi/cdef "char *strerror(int);")
       (let* [(,fun (.> ffi/C ,(mangle name)))
              (,exit (,fun ,@lambda-list))
              (,status (ffi/cast "int" ,exit))]
         ,(cond
            [(number? do-errno-check)
             `(if (= ,status ,do-errno-check)
                (format 1 "({} {@( )}) failed: {}" ,(symbol->string name) (list ,@lambda-list)
                        (ffi/string ((.> ffi/C :strerror) (ffi/errno))))
                ,exit)]
            [do-errno-check
             `(if (< ,status 0)
                (format 1 "({} {@( )}) failed: {}" ,(symbol->string name) (list ,@lambda-list)
                        (ffi/string ((.> ffi/C :strerror) (ffi/errno))))
                ,exit)]
            [else exit])))))

(defmacro define-foreign-functions (c-definitions &functions)
  "Declare all the foreign functions specified in C-DEFINITIONS, and
   additionally build the wrappers as described in FUNCTIONS, using
   [[define-foreign-function]]"
  (let* [(c-definitions (.> c-definitions :value))]
    (ffi/cdef c-definitions)
    (splice
      `((ffi/cdef ,c-definitions)
        ,@(map (cut cons `define-foreign-function <>) functions)))))
