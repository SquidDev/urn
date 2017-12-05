(import urn/range ())
(import urn/resolve/scope scope)

(defun format-node (node)
  "Format NODE to give a description of its position

   This is either its position in a source file or the macro which created it"
  (cond
    [(and (.> node :range) (.> node :contents))
     (string/format "%s (%s)" (format-range (.> node :range)) (string/quoted (.> node :contents)))]
    [(.> node :range) (format-range (.> node :range))]
    [(.> node :owner)
     (with (owner (.> node :owner))
       (if (.> owner :var)
         (string/format "macro expansion of %s (%s)"
           (scope/var-name (.> owner :var))
           (format-node (.> owner :node)))
         (string/format "unquote expansion (%s)"
           (format-node (.> owner :node)))))]
    [(range? node) (format-range node)]
    [true "?"]))
