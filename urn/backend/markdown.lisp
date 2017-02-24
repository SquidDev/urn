(import urn/backend/writer writer)
(import urn/documentation doc)
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

(defun format-definition (var)
  "Format a variable VAR, including it's kind and the position it was defined at."
  :hidden
  (with (ty (type var))
    (cond
      ((= ty "builtin")
        "Builtin term")
      ((= ty "macro")
        (.. "Macro defined at " (format-range (logger/get-source (.> var :node)))))
      ((= ty "native")
        (.. "Native defined at " (format-range (logger/get-source (.> var :node)))))
      ((= ty "defined")
        (.. "Defined at " (format-range (logger/get-source (.> var :node))))))))

(defun format-signature (name var)
  "Attempt to extract the function signature from VAR"
  :hidden
  (with (sig (doc/extract-signature var))
    (cond
      ((= sig nil) name)
      ((nil? sig)
        (.. "(" name .. ")"))
      (true
        (.. "(" name " " (concat (traverse sig (cut get-idx <> "contents")) " ") ")")))))

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

    (writer/line! out "---")
    (writer/line! out (.. "title: " title))
    (writer/line! out "---")

    (writer/line! out (.. "# " title))

    (for-each entry documented
      (let* [(name (car entry))
             (var  (nth entry 2))]

        (writer/line! out (.. "## `" (format-signature name var) "`"))
        (writer/line! out (.. "*" (format-definition var) "*"))
        (writer/line! out "" true)

        (for-each tok (doc/parse-docstring (.> var :doc))
          (with (ty (type tok))
            (cond
              ((= ty "text") (writer/append! out (.> tok :contents)))
              ((= ty "arg")  (writer/append! out (.. "`" (.> tok :contents) "`")))
              ((= ty "mono") (writer/append! out (.. "`" (.> tok :contents) "`")))
              ((= ty "link")
                (let* [(name  (.> tok :contents))
                       (scope (.> var :scope))
                       (ovar  ((.> scope :get) scope name nil true))]
                  (if ovar
                    (let* [(loc (-> (.> ovar :node)
                                  logger/get-source
                                  (.> <> :name)
                                  (string/gsub <> "%.lisp$" "")
                                  (string/gsub <> "/" ".")))
                           (sig (doc/extract-signature ovar))
                           (hash (cond
                                   ((= sig nil) (.> ovar :name))
                                   ((nil? sig) (.> ovar :name))
                                   (true (.. name " " (concat (traverse sig (cut get-idx <> "contents")) " ")))))]
                      (writer/append! out (string/format "[`%s`](%s.md#%s)" name loc (string/gsub hash "%A+" "-"))))
                    (writer/append! out (string/format "`%s`" name))))))))
        (writer/line! out)
        (writer/line! out "" true)))

    (unless (nil? undocumented)
      (writer/line! out "## Undocumented symbols"))
    (for-each entry undocumented
       (let* [(name (car entry))
             (var  (nth entry 2))]
         (writer/line! out (.. " - `" (format-signature name var) "` *" (format-definition var) "*"))))))

(define backend (struct
                  :exported exported))
