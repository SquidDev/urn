"This is a bit of an ugly module as far as location goes, but it's
 required to avoid cyclic dependencies. Ideally we'll move some of the
 logging code out of `urn/resolve/scope` in the future."

(import urn/range ())
(import urn/resolve/scope scope)

(defun format-position (pos)
  "Format position POS to be user-readable"
  (.. (pos-line pos) ":" (pos-column pos)))

(defmethod (pretty position) (pos)
  (format-position pos))

(defun format-range (range)
  "Format RANGE to be user-readable"
  (if (range-finish range)
    (string/format "%s:[%s .. %s]" (range-name range)
                                   (format-position (range-start range))
                                   (format-position (range-finish range)))
    (string/format "%s:[%s]" (range-name range)
                             (format-position (range-start range)))))

(defmethod (pretty range) (range)
  (format-range range))

(defun format-node-source (source)
  "Format the provided node-source SOURCE."
  (let* [(owner (node-source-owner source))
         (range (source-full-range source))
         (rangef (if range (format-range range) "?"))]
    (if owner
      (string/format "macro expansion of %s (at %s)" (scope/var-name owner) rangef)
      (string/format "unquote expansion (at %s)" rangef))))

(defun format-node-source-name (source)
  (with (owner (node-source-owner source))
    (if owner (scope/var-name owner) "?")))

(defmethod (pretty node-source) (source)
  (format-node-source source))

(defun format-source (source)
  "Format the given NODE-SOURCE."
  (case (type source)
    ["node-source" (format-node-source source)]
    ["range" (format-range source)]
    ["nil" "?"]))

(defun format-node (node)
  "Format the given NODE."
  (if node
    (format-source (.> node :source))
    "?"))
