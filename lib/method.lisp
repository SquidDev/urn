(import base)
(import string)

(defmacro define-method-storage (name)
  (assert-type! name "symbol")
  `(define
    ,(struct
      :tag "symbol"
      :contents (.. (get-idx name "contents") "/lookup"))
    (empty-struct)))

(defmacro define-method-lookup (name args)
  (assert-type! name "symbol")
  (assert-type! args "number")

  ;; Hack to convert tables to numbers
  (if (= (base/type# args) "table") (set! args (string->number (get-idx args "contents"))))

  (let ((sym (get-idx name "contents"))
        (arg-list '())
        (lookup (gensym "lookup")))
    ; Build the argument list
    (for i 1 args 1 (push-cdr! arg-list (gensym "arg")))

    (with (body `(,lookup ,@arg-list))
      ; Build the selector tree
      (for i args 1 -1
        (set! body `(progn
          (set! ,lookup (or (get-idx ,lookup (type ,(get-idx arg-list i))) (get-idx ,lookup "any")))
          (if ,lookup ,body (error! (.. ,(string/.. "Cannot call " sym " for type ") (type ,(get-idx arg-list i))))))))
      `(defun ,name ,arg-list
        (with (,lookup ,(struct :tag "symbol" :contents (.. sym "/lookup")))
          ,body)))))

(defmacro define-method-setter (name args)
  (assert-type! name "symbol")
  (assert-type! args "number")

  ;; Hack to convert tables to numbers
  (if (= (base/type# args) "table") (set! args (string->number (get-idx args "contents"))))

  (let* ((sym (get-idx name "contents"))
         (lookup (gensym))
         (func (gensym "func"))
         (types (gensym "types"))
         (val (gensym "val"))
         (body `(set-idx! ,lookup (symbol->string (get-idx ,types ,args)) ,func)))

    (for i (pred args) 1 -1
      (with (prev-lookup (gensym "lookup"))
        (set! body `(let* ((,val (symbol->string (get-idx ,types ,i)))
                           (,lookup (get-idx ,prev-lookup ,val)))
          (unless ,lookup
            (set! ,lookup (empty-struct))
            (set-idx! ,prev-lookup ,val ,lookup))
          ,body))
        (set! lookup prev-lookup)))
    `(defun ,(struct :tag "symbol" :contents (.. sym "/define")) (,types ,func)
      (with (,lookup ,(struct :tag "symbol" :contents (.. sym "/lookup"))))
      ,body)))

;; (define-method-storage ->string)
;; (define-method-lookup ->string 1)
;; (define-method-setter ->string 1)

;; (->string/define '(string) (lambda (x) x))
;; (->string/define '(number) number->string)
;; (->string/define '(boolean) bool->string)
;; (->string/define '(symbol) symbol->string)
;; (->string/define '(list) (lambda (x)
;;   (string/.. "(" (string/concat (map ->string x) " ") ")")))
;; (->string/define '(any) pretty)

;; (print! (pretty (->string "foobar")))
;; (print! (pretty (->string 2)))
;; (print! (pretty (->string false)))
;; (print! (pretty (->string 'foo)))
;; (print! (pretty (->string (list 1 2 3))))
;; (print! (->string (struct :foo "bar"))) ;; Test "any" fallback
