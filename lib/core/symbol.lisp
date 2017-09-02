(import core/base (defun if get-idx))
(import core/type (symbol?))
(import core/list (map))
(import lua/table (concat))

(defun symbol->string (x)
  "Convert the symbol X to a string."
  (if (symbol? x)
    (get-idx x "contents")
    nil))

(defun string->symbol (x)
  "Convert the string X to a symbol."
  { :tag "symbol" :contents x })

(defun sym.. (&xs)
  "Concatenate all the symbols in XS."
  (string->symbol (concat (map symbol->string xs))))
