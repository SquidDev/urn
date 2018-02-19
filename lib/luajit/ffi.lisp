(define-native new      :bind-to "require('ffi').new")
(define-native cast     :bind-to "require('ffi').cast")
(define-native typeof   :bind-to "require('ffi').typeof")
(define-native sizeof   :bind-to "require('ffi').sizeof")
(define-native alignof  :bind-to "require('ffi').alignof")
(define-native istype   :bind-to "require('ffi').istype")
(define-native fill     :bind-to "require('ffi').fill")
(define-native cdef     :bind-to "require('ffi').cdef")
(define-native abi      :bind-to "require('ffi').abi")
(define-native metatype :bind-to "require('ffi').metatype")
(define-native copy     :bind-to "require('ffi').copy")
(define-native arch     :bind-to "require('ffi').arch")
(define-native typeinfo :bind-to "require('ffi').typeinfo")
(define-native load     :bind-to "require('ffi').load")
(define-native os       :bind-to "require('ffi').os")
(define-native string   :bind-to "require('ffi').string")
(define-native gc       :bind-to "require('ffi').gc")
(define-native errno    :bind-to "require('ffi').errno")
(define-native C        :bind-to "require('ffi').C")
(define-native offsetof :bind-to "require('ffi').offsetof")

(defmacro defun-ffi (name typedecl)
  :deprecated "Use cdef and index the C table directly"
  "Define the external symbol NAME with the C type signature
   given by TYPEDECL."
  (cdef (.> typedecl :value))
  (values-list
    `(cdef ,(.> typedecl :value))
    `(define ,name (.> C ,(symbol->string name)))))
