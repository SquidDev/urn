(import base (defun let* type# if car cdr when
              and or >= = <= #))

(defun table? (x) (= (type# x) "table"))
(defun list? (x) (= (type x) "list"))
(defun nil? (x) (and x (list? x) (= (# x) 0)))
(defun string? (x) (= (type x) "string"))
(defun number? (x) (= (type x) "number"))
(defun symbol? (x) (= (type x) "symbol"))
(defun boolean? (x) (= (type x) "boolean"))
(defun function? (x) (= (type x) "function"))
(defun key? (x) (= (type x) "key"))
(defun between? (val min max)
  (and (>= val min) (<= val max)))

(defun type (val)
  (let* [(ty (type# val))]
    (if (= ty "table")
      (let* [(tag (rawget val "tag"))]
        (if tag tag "table"))
      ty)))

(defun eq? (x y)
  (cond
    [(and (symbol? x) (symbol? y))
     (= (rawget x "contents") (get-idx y "contents"))]
    [(and (symbol? x) (string? y))
     (= (rawget x "contents") y)]
    [(and (string? x) (symbol? y))
     (= (rawget y "contents") x)]
    [(and (list? x) (list? y))
     (and (eq? (car x) (car y))
          (eq? (cdr x) (cdr y)))]
    [true (= x y)]))
