(import base (defun defmacro with if gensym format error!
              get-idx type# = /= # car cdr and when))

(defun table? (x) (= (type# x) "table"))
(defun list? (x) (= (type x) "list"))
(defun null? (x) (and x (list? x) (= (# x) 0)))
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

;; Deep equality comparsion.
(defun eq? (x y)
  (cond
    [(and (symbol? x) (symbol? y))
     (= (get-idx x "contents") (get-idx y "contents"))]
    [(and (symbol? x) (string? y))
     (= (get-idx x "contents") y)]
    [(and (string? x) (symbol? y))
     (= (get-idx y "contents") x)]
    [(and (list? x) (list? y))
     (and (eq? (car x) (car y))
          (eq? (cdr x) (cdr y)))]
    [true (= x y)]))
