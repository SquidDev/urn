(define-native concat)
(define-native insert)
(define-native move)
(define-native pack)
(define-native remove)
(define-native sort)
(define-native unpack)
(define-native empty-struct
  "Create an empty structure with no fields")
(define-native iter-pairs
  "Iterate over TABLE with a function FUNC of the form (lambda (KEY VAL) ...)")
