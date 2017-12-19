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

(defstruct (node-source mk-node-source node-source?)
  "The origin of a given node."
  (fields
    (immutable owner
      "The object which owns this. This will be a variable pointing to a macro or `nil`.")

    (immutable parent
      "The parent object, either a [[range?]] or [[node-source?]]")

    (immutable range
      "The full range of this node.")))

(defun source-full-range (source)
  "Get the full range of this SOURCE."
  (case (type source)
    ["node-source" (node-source-range source)]
    ["range" source]
    ["nil" nil]))

(defun source-range (source)
  "Get the range of this SOURCE."
  (case (type source)
    ["node-source" (source-range (node-source-parent source))]
    ["range" source]
    ["nil" nil]))

(defun get-top-source (node)
  "Get the top source for the given NODE."
  (.> node :source))

(defun get-source (node)
  "Get the nearest source position of NODE"
  (source-range (.> node :source)))

(defun get-full-source (node)
  "Get the full range of this NODE."
  (source-full-range (.> node :source)))
