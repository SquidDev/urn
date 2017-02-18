(import assert (assert-type!))
(import string)

(defun create () (struct
  :out (list)
  :indent 0
  :tabs-pending false))

;; Append a string to the writer
(defun append! (writer text)
  (assert-type! text "string")

  ;; Write the indent when required
  (when (.> writer :tabs-pending)
    (.<! writer :tabs-pending false)
    (push-cdr! (.> writer :out) (string/rep "\t" (.> writer :indent))))

  (push-cdr! (.> writer :out) text))

;; Append a line to the buffer
(defun line! (writer text)
  (when text (append! writer text))

  ;; Don't write empty lines
  (unless (.> writer :tabs-pending)
    (.<! writer :tabs-pending true)
    (push-cdr! (.> writer :out) "\n")))

;; Indent the writer
(defun indent! (writer)
  (.<! writer :indent (succ (.> writer :indent))))

;; Unindent the writer
(defun unindent! (writer)
  (.<! writer :indent (pred (.> writer :indent))))

;; Begin an indented statement
;; (`if` in an `if .. else .. end` statement)
(defun begin-block! (writer text)
  (line! writer text)
  (indent! writer))

;; End one indented statement and begin another
;; (`else` in an `if .. else .. end` statement)
(defun next-block! (writer text)
  (unindent! writer)
  (line! writer text)
  (indent! writer))

;; End an indented statement
;; (`end` in an `if .. else .. end` statement)
(defun end-block! (writer text)
  (unindent! writer)
  (line! writer text))

;; Convert the writer to a string
(defun ->string (writer) (string/concat (.> writer :out)))
