(import urn/backend/writer writer)
(import urn/logger logger)

(import string)
(import lua/table table)

(define builtins (get-idx (require "tacky.analysis.resolve") :builtins))

(defun format-range (range)
  "Format a range."
  :hidden
  (string/format "%s:%s" (.> range :name) (logger/format-position (.> range :start))))

(defun sort-vars! (list)
  "Sort a list of variables"
  :hidden
  (table/sort list (lambda (a b)
                        (< (car a) (car b)))))

(defun format-variable (var)
  "Format a variable VAR, including it's kind and the position it was defined at."
  :hidden
  (with (ty (type var))
    (cond
      ((= ty "builtin")
        "*Builtin term*")
      ((= ty "macro")
        (.. "*Macro defined at " (format-range (logger/get-source (.> var :node))) "*"))
      ((= ty "native")
       (.. "*Native defined at " (format-range (logger/get-source (.> var :node))) "*"))
      ((= ty "defined")
        (.. "*Defined at " (format-range (logger/get-source (.> var :node))) "*")))))

(defun extract-signature (var)
  "Attempt to extract the function signature from VAR"
  :hidden
  (with (ty (type var))
    (cond
      ((or (= ty "macro") (= ty "defined"))
        (let* [(root (.> var :node))
               (node (nth root (# root)))]
          (if (and (list? node) (symbol? (car node)) (= (.> (car node) :var) (.> builtins :lambda)))
            (pretty (nth node 2))
            "")))
      (true ""))))

(defun exported (out title vars)
  "Print out a list of all exported variables"
  (let* [(documented '())
         (undocumented '())]
    (iter-pairs vars (lambda (name var)
                       (push-cdr!
                         (if (.> var :doc) documented undocumented)
                         (list name var))))

    (sort-vars! documented)
    (sort-vars! undocumented)

    (writer/line! out (.. "# " title))

    (for-each entry documented
      (let* [(name (car entry))
             (var  (nth entry 2))]

        (writer/line! out (.. "## `" name (extract-signature var) "`"))
        (writer/line! out (format-variable var))
        (writer/line! out "" true)
        (writer/line! out (.> var :doc))
        (writer/line! out "" true)))

    (writer/line! out "## Undocumented symbols")
    (for-each entry undocumented
       (let* [(name (car entry))
             (var  (nth entry 2))]
         (writer/line! out (.. " - `" name (extract-signature var) "` " (format-variable var)))))))

(define backend (struct
                  :exported exported))
