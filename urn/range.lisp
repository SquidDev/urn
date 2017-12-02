(import data/struct ())

(defstruct (position mk-position position?)
  "Represents a position within a piece of text."
  (fields
    (immutable offset pos-offset
      "The offset of this position within the text.")
    (immutable line pos-line
      "The line of this position.")
    (immutable column pos-column
      "The column of this position.")))

(defun format-position (pos)
  "Format position POS to be user-readable"
  (.. (pos-line pos) ":" (pos-column pos)))

(defmethod (pretty position) (pos)
  (format-position pos))

(defstruct (range mk-range range?)
  "Represents a range within a piece of source code."
  (fields
    (immutable name
      "The file name of the corresponding source code.")
    (immutable start
      "The start position of this range.")
    (immutable finish
      "The end position of this range.")
    (immutable lines
      "A list of lines which make up the corresponding source code.")))

(defun range< (a b)
  "Determine whether range A occurs before range B in the source.

   If the ranges are in different files then the file name will be used
   instead."
  (if (= (range-name a) (range-name b))
    (< (pos-offset (range-start a)) (pos-offset (range-start b)))
    (< (range-name a) (range-name b))))

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

(defun range-of-start (range)
  "Create a new range which points to RANGE's start position."
  (assert-type! range range)
  (mk-range (range-name  range)
            (range-start range)
            (range-start range)
            (range-lines range)))

(defun range-of-span (from to)
  "Create a new range which spans FROM the start of one range TO the end
   of another."
  (assert-type! from range)
  (assert-type! to range)
  (mk-range (range-name   from)
            (range-start  from)
            (range-finish to)
            (range-lines  from)))

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
    [(range? node) (format-range node)]
    [true "?"]))

(defun get-source (node)
  "Get the nearest source position of NODE

   This will walk up NODE's tree until a non-macro node is found"
  (with (result nil)
    (while (and node (not result))
      (set! result (.> node :range))
      (set! node (.> node :parent)))
    result))
