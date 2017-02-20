(import base (defun let* type# if car cdr when
              and or >= = <= /= # get-idx defmacro
              error gensym ! debug))

(import lua/string (format sub))

(defun table? (x) (= (type# x) "table"))
(defun list? (x) (= (type x) "list"))
(defun nil? (x) (and x (list? x) (= (# x) 0)))
(defun string? (x) (= (type x) "string"))
(defun number? (x) (= (type x) "number"))
(defun symbol? (x) (= (type x) "symbol"))
(defun boolean? (x) (= (type x) "boolean"))
(defun function? (x) (= (type x) "function"))
(defun atom? (x)
  (or (boolean? x)
      (string? x)
      (number? x)
      (symbol? x)
      (key? x)))
(defun falsey? (x) (! x))
(defun exists? (x) (! (= (type x) "nil")))
(defun key? (x) (= (type x) "key"))
(defun between? (val min max)
  (and (>= val min) (<= val max)))

(defun type (val)
  (let* [(ty (type# val))]
    (if (= ty "table")
      (let* [(tag (get-idx val "tag"))]
        (if tag tag "table"))
      ty)))

(defun eq? (x y)
  (cond
    [(and (symbol? x) (symbol? y))
     (= (get-idx x "contents") (get-idx y "contents"))]
    [(and (symbol? x) (string? y))
     (= (get-idx x "contents") y)]
    [(and (string? x) (symbol? y))
     (= (get-idx y "contents") x)]
    [(and (key? x) (key? y))
     (= (get-idx x "contents") (get-idx y "contents"))]
    [(and (key? x) (string? y))
     (= (sub (get-idx x "contents") 2) y)]
    [(and (string? x) (key? y))
     (= (sub (get-idx y "contents") 2) x)]
    [(and (nil? x) (nil? y)) true]
    [(and (list? x) (list? y))
     (and (eq? (car x) (car y))
          (eq? (cdr x) (cdr y)))]
    [true (= x y)]))

(defun neq? (x y)
  (! (eq? x y)))

(defmacro assert-type! (arg ty)
  (let* [(sym (gensym))
         (ty (get-idx ty "contents"))]
    `(let* [(,sym (type ,arg))]
      (when (/= ,sym ,ty)
        (error (format "bad argment %s (expected %s, got %s)" ,(get-idx arg "contents") ,ty ,sym) 2)))))
