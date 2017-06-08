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


(defun append! (writer text)
  "Append a string to the writer"
  (assert-type! text string)

  ;; Push the current position to the line mapping
  (when-with (pos (.> writer :active-pos))
    (with (line (.> writer :lines (.> writer :line)))
      (unless line
        (set! line {})
        (.<! writer :lines (.> writer :line) line))

      (.<! line pos true)))

  ;; Write the indent when required
  (when (.> writer :tabs-pending)
    (.<! writer :tabs-pending false)
    (push-cdr! (.> writer :out) (string/rep "\t" (.> writer :indent))))

  (push-cdr! (.> writer :out) text))

(defun line! (writer text force)
  "Append a line to the buffer"
  (when text (append! writer text))

  ;; Don't write empty lines
  (when (or force (! (.> writer :tabs-pending)))
    (.<! writer :tabs-pending true)
    (.<! writer :line (succ (.> writer :line)))
    (push-cdr! (.> writer :out) "\n")))

(defun indent! (writer)
  "Indent the writer"
  (.<! writer :indent (succ (.> writer :indent))))

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
    (push-cdr! (.> writer :node-stack) node)
    (.<! writer :active-pos range)))

(defun pop-node! (writer node)
  "Pop NODE from the position stack."
  (when-with (range (get-source node))
    (let* [(stack (.> writer :node-stack))
           (previous (last stack))]
      (unless (= previous node) (error! "Incorrect node popped"))
      (pop-last! stack)
      (.<! writer :arg-pos (last stack)))))

(defun ->string (writer)
  "Convert the writer to a string."
  (string/concat (.> writer :out)))
