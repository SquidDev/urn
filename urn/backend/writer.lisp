(import urn/range (get-source))

(defun create ()
  { :out          '()
    :indent       0
    :tabs-pending false
    :line         1

    ;; Line mapping stuff
    :lines        {}
    :node-stack   '()
    :active-pos   nil })


(defun append! (writer text position)
  "Append a piece of TEXT to the WRITER with the given POSITION"
  (assert-type! text string)

  ;; Push the current position to the line mapping
  (when position
    (with (line (.> writer :lines (.> writer :line)))
      (unless line
        (set! line {})
        (.<! writer :lines (.> writer :line) line))

      (.<! line position true)))

  ;; Write the indent when required
  (when (.> writer :tabs-pending)
    (.<! writer :tabs-pending false)
    (push! (.> writer :out) (string/rep "  " (.> writer :indent))))

  (push! (.> writer :out) text))

(defun append-with! (writer text)
  "Append a piece of TEXT to the writer with the current POSITION"
  (append! writer text (.> writer :active-pos)))

(defun line! (writer text force)
  "Append a line to the buffer"
  (when text (append! writer text))

  ;; Don't write empty lines
  (when (or force (not (.> writer :tabs-pending)))
    (.<! writer :tabs-pending true)
    (over! (.> writer :line) succ)
    (push! (.> writer :out) "\n")))

(defun indent! (writer)
  "Indent the writer"
  (over! (.> writer :indent) succ))

(defun unindent! (writer)
  "Unindent the writer"
  (.<! writer :indent (pred (.> writer :indent))))

(defun begin-block! (writer text)
  "Begin an indented statement with TEXT.

   For example, `if` in an `if .. else .. end` statement."
  (line! writer text)
  (indent! writer))

(defun next-block! (writer text)
  "End one indented statement and begin another.

   For example, `else` in an `if .. else .. end` statement."
  (unindent! writer)
  (line! writer text)
  (indent! writer))

(defun end-block! (writer text)
  "End an indented statement.

   For example, `end` in an `if .. else .. end` statement."
  (unindent! writer)
  (line! writer text))

(defun push-node! (writer node)
  "Push NODE onto the position stack."
  (when-with (range (get-source node))
    (push! (.> writer :node-stack) range)
    (.<! writer :active-pos range)))

(defun pop-node! (writer node)
  "Pop NODE from the position stack."
  (when-with (range (get-source node))
    (let* [(stack (.> writer :node-stack))
           (previous (last stack))]
      (when (/= previous range) (error! "Incorrect node popped"))
      (pop-last! stack)
      (.<! writer :active-pos (last stack)))))

(defun ->string (writer)
  "Convert the writer to a string."
  (string/concat (.> writer :out)))
