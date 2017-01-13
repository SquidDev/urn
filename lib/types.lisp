(import base (defun defmacro with if gensym format error! get-idx type# = /=))

(defun table? (x) (= (type# x) "table"))
(defun list? (x) (= (type x) "list"))
(defun string? (x) (= (type x) "string"))
(defun number? (x) (= (type x) "number"))
(defun symbol? (x) (= (type x) "symbol"))
(defun boolean? (x) (= (type x) "boolean"))
(defun function? (x) (= (type x) "function"))
(defun key? (x) (= (type x) "key"))

;; Get the type of an object
(defun type (val)
  (with (ty (type# val))
    (if (= ty "table")
      (with (tag (get-idx val "tag")) (if tag tag "table"))
      ty)))

;; Tiny argument validation library. This expects a symbol as the first
;; argument and a constant type as the second
(defmacro assert-type! (arg ty)
  (with (sym (gensym))
    `(with (,sym (type ,arg))
      (when (/= ,sym ,ty) (error! (format "bad argment %s (expected %s, got %s)" ,(get-idx arg "contents") ,ty ,sym) 2)))))

