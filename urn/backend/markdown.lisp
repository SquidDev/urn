(import urn/backend/writer writer)
(import urn/documentation doc)
(import urn/library ())
(import urn/loader (strip-extension))
(import urn/range (get-source range-name range-start))
(import urn/logger/format (format-position))
(import urn/resolve/scope scope)

(import data/alist ())

(defun format-range (range)
  "Format a range."
  :hidden
  (string/format "%s:%s" (range-name range) (format-position (range-start range))))

(defun sort-vars! (list)
  "Sort a list of variables"
  :hidden
  (sort! list (lambda (a b) (< (car a) (car b)))))

(defun format-definition (var)
  "Format a variable VAR, including it's kind and the position it was defined at."
  :hidden
  (case (scope/var-kind var)
    ["builtin"
     "Builtin term"]
    ["macro"
     (.. "Macro defined at " (format-range (get-source (scope/var-node var))))]
    ["native"
     (.. "Native defined at " (format-range (get-source (scope/var-node var))))]
    ["defined"
     (.. "Defined at " (format-range (get-source (scope/var-node var))))]))

(defun format-signature (name var)
  "Attempt to extract the function signature from VAR"
  :hidden
  (with (sig (doc/extract-signature var))
    (if (= sig nil)
      name
      (.. "(" (concat (cons name sig) " ") ")"))))

(defun format-link (name var title)
  "Produce a link to VAR with the given NAME and TITLE."
  :hidden
  (let* [(loc (-> (scope/var-node var)
                  get-source
                  range-name
                  strip-extension
                  (string/gsub <> "/" ".")))
         (sig (doc/extract-signature var))
         (hash (cond
                 [(= sig nil) (scope/var-name var)]
                 [(empty? sig) (scope/var-name var)]
                 [true (.. name " " (concat sig " "))]))
         (titleq (if title
                   (.. " \"" title "\"")
                   ""))]

    (string/format "[`%s`](%s.md#%s%s)"
      name
      loc (string/gsub hash "%A+" "-")
      titleq)))


(defun write-docstring (out toks scope)
  :hidden
  (for-each tok toks
    (with (ty (.> tok :kind))
      (cond
        [(= ty "text") (writer/append! out (.> tok :contents))]
        [(= ty "boldic") (writer/append! out (.> tok :contents))]
        [(= ty "bold") (writer/append! out (.> tok :contents))]
        [(= ty "italic") (writer/append! out (.> tok :contents))]
        [(= ty "arg")  (writer/append! out (.. "`" (.> tok :contents) "`"))]
        [(= ty "mono") (writer/append! out (-> (.> tok :whole)
                                             ;; Remove anything after the language definition.
                                             (string/gsub <> "^```(%S+)[^\n]*" "```%1")))]
        [(= ty "link")
         (let* [(name (.> tok :contents))
                (ovar (scope/lookup scope name))]
           (if (and ovar (scope/var-node ovar))
             (writer/append! out (format-link name ovar))
             (writer/append! out (string/format "`%s`" name))))]))))

(defun exported (out title primary vars scope)
  "Print out a list of all exported variables"
  (let* [(documented '())
         (undocumented '())]
    (iter-pairs vars (lambda (name var)
                       (push!
                         (if (scope/var-doc var) documented undocumented)
                         (list name var))))

    (sort-vars! documented)
    (sort-vars! undocumented)

    (writer/line! out "---")
    (writer/line! out (.. "title: " title))
    (writer/line! out "---")

    (writer/line! out (.. "# " title))
    (when primary
      (write-docstring out (doc/parse-docstring primary) scope)
      (writer/line! out)
      (writer/line! out "" true))

    (for-each entry documented
      (let* [(name (car entry))
             (var  (nth entry 2))]

        (writer/line! out (.. "## `" (format-signature name var) "`"))
        (writer/line! out (.. "*" (format-definition var) "*"))
        (writer/line! out "" true)

        (when (scope/var-deprecated var)
          (cond
            [(string? (scope/var-deprecated var))
             (writer/append! out (string/format ">**Warning:** %s is deprecated: " name))
             (write-docstring out (doc/parse-docstring (scope/var-deprecated var)) (scope/var-scope var))]
            [else
             (writer/append! out (string/format ">**Warning:** %s is deprecated." name))])
          (writer/line! out)
          (writer/line! out "" true))

        (write-docstring out (doc/parse-docstring (scope/var-doc var)) (scope/var-scope var))
        (writer/line! out)
        (writer/line! out "" true)))

    (unless (empty? undocumented)
      (writer/line! out "## Undocumented symbols"))
    (for-each entry undocumented
       (let* [(name (car entry))
             (var  (nth entry 2))]
         (writer/line! out (.. " - `" (format-signature name var) "` *" (format-definition var) "*"))))))

(defun index (out libraries)
  "Write an index for LIBRARIES writing the result to OUT."
  (let [(variables {})
        (letters {})]

    (for-each lib libraries
      (for-pairs (name var) (scope/scope-exported (library-scope lib))
        (with (info (.> variables var))
          (unless info
            ;; We've not seen this variable before so set up the info
            (set! info { :var var
                         :exported '()
                         :defined nil })
            (.<! variables var info)

            ;; Push it to the appropriate category
            (with (letter (string/lower (string/char-at (scope/var-name var) 1)))
              (unless (between? letter "a" "z") (set! letter "$"))
              (with (lookup (.> letters letter))
                (unless lookup
                  (set! lookup '())
                  (.<! letters letter lookup))

                (push! lookup info))))

          ;; Determine whether this scope defines it or exports it
          (if (= (scope/var-scope var) (library-scope lib))
            (.<! info :defined lib)
            (push! (.> info :exported) (list name lib))))))

    (with (letter-list (struct->assoc letters))
      (sort! letter-list (lambda (a b) (< (car a) (car b))))
      (for-each letter letter-list
        (sort! (cadr letter) (lambda (a b) (< (scope/var-full-name (.> a :var)) (scope/var-full-name (.> b :var))))))

      (writer/line! out "---")
      (writer/line! out "title: Symbol index")
      (writer/line! out "---")
      (writer/line! out "# Symbol index")
      (writer/line! out "" true)

      (writer/line! out "{:.sym-toc}")
      (for-each letter letter-list
        (writer/line! out (string/format " - [%s](#sym-%s)"
                                         (car letter)
                                         (if (= (car letter) "$") "symbols" (car letter)))))
      (writer/line! out)
      (writer/line! out "" true)

      (writer/line! out "{:.sym-table}")
      (writer/line! out "|   | Symbol | Defined in |")
      (writer/line! out "| - | ------ | ---------- |")

      (for-each letter letter-list
        (writer/line! out (string/format "| <strong id=\"sym-%s\">%s</strong> | |"
                                         (if (= (car letter) "$") "symbols" (car letter))
                                         (car letter)))

        (for-each info (cadr letter)
          (let* [(var (.> info :var))
                 (defined (.> info :defined))
                 (range (get-source (scope/var-node var)))]

            (writer/append! out "| |")
            (writer/append! out (format-link (scope/var-name var) var (format-definition var)))

            (when-with (doc (scope/var-doc var))
              (writer/append! out ": ")
              (write-docstring out (doc/extract-summary (doc/parse-docstring doc))))
            (writer/append! out "|")

            (let [(name (if defined (library-name defined) (range-name range)))
                  (path (string/gsub (strip-extension (if defined (library-path defined) (range-name range))) "/" "."))]
              (if (empty? (.> info :exported))
                (writer/append! out (string/format "[%s](%s.md)" name path))
                (writer/append! out (string/format "[%s](%s.md \"Also exported from %s\")" name path
                                                   (concat (sort (nub (map (lambda (x) (library-name (cadr x))) (.> info :exported)))) ", ")))))

            (writer/line! out "|")))))))
