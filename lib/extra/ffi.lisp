(import luajit/ffi () :export)
(import base (const-val type#))

(defmacro defun-ffi (name typedecl)
  "Define the external symbol NAME with the C type signature
   given by TYPEDECL."
  (cdef (get-idx typedecl :value))
  (unpack
    `((cdef ,(get-idx typedecl :value))
      (define ,name (get-idx C ,(symbol->string name))))))
