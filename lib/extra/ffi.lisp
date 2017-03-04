(import luajit/ffi () :export)
(import base (const-val type#))

(defmacro defun-ffi (name typedecl)
  (cdef (get-idx typedecl :value))
  `(define ,name (get-idx C ,(symbol->string name))))
