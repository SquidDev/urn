(define-native new)
(define-native cast)
(define-native typeof)
(define-native sizeof)
(define-native alignof)
(define-native istype)
(define-native fill)
(define-native cdef)
(define-native abi)
(define-native metatype)
(define-native copy)
(define-native arch)
(define-native typeinfo)
(define-native load)
(define-native os)
(define-native string)
(define-native gc)
(define-native errno)
(define-native C)
(define-native offsetof)

(defmacro defun-ffi (name typedecl)
  :deprecated "Use cdef and index the C table directly"
  "Define the external symbol NAME with the C type signature
   given by TYPEDECL."
  (cdef (.> typedecl :value))
  (values-list
    `(cdef ,(.> typedecl :value))
    `(define ,name (.> C ,(symbol->string name)))))
