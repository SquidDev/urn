(defun format-position (pos)
  "Format position POS to be user-readable"
  (.. (.> pos :line) ":" (.> pos :column)))

(defun format-range (range)
  "Format RANGE to be user-readable"
  (if (.> range :finish)
    (string/format "%s:[%s .. %s]" (.> range :name) (format-position (.> range :start)) (format-position (.> range :finish)))
    (string/format "%s:[%s]" (.> range :name) (format-position (.> range :start)))))

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
           (.> owner :var :name)
           (format-node (.> owner :node)))
         (string/format "unquote expansion (%s)"
           (format-node (.> owner :node)))))]
    [(and (.> node :start) (.> node :finish))
     (format-range node)]
    [true "?"]))

(defun get-source (node)
  "Get the nearest source position of NODE

   This will walk up NODE's tree until a non-macro node is found"
  (with (result nil)
    (while (and node (! result))
      (set! result (.> node :range))
      (set! node (.> node :parent)))
    result))
