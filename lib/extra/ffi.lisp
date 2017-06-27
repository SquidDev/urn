(import luajit/ffi () :export)
(import base (const-val type#))

(defmacro defun-ffi (name typedecl)
  "Define the external symbol NAME with the C type signature
   given by TYPEDECL."
  (cdef (.> typedecl :value))
  (unpack
    `((cdef ,(.> typedecl :value))
      (define ,name (.> C ,(symbol->string name))))))
