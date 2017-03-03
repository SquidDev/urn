(import base (arg))
(import lua/basic (assert))
(import lua/io io)
(import lua/math math)
(import lua/table table)
(import string)
(import string (quoted))

(import urn/logger logger)
(import urn/parser parser)

(defun gen-native (path prefix)
  (set! path (string/gsub path "%.lisp$" ""))

  (with (qualifier (if prefix (.. prefix ".") ""))

    (with (handle (io/open (.. path ".lisp") "r"))
      (unless handle
        (logger/print-error! (.. "Cannot find " path ".lisp"))
        (exit! 1))

      (with (contents (self handle :read "*a"))
        (self handle :close)

        (let* [(lexed (parser/lex contents (.. path ".lisp")))
               (parsed (parser/parse lexed))
               (max-name 0)
               (max-quot 0)
               (max-pref 0)
               (natives '())]
          (for-each node parsed
            (when (and (list? node) (symbol? (car node)) (= (.> (car node) :contents) "define-native"))
              (with (name (.> (nth node 2) :contents))
                (push-cdr! natives name)

                (set! max-name (math/max max-name (#s (quoted name))))
                (set! max-quot (math/max max-quot (#s (quoted (.. qualifier name)))))
                (set! max-pref (math/max max-pref (#s (.. qualifier name)))))))

          (table/sort natives)

          (let* [(handle (io/open (.. path ".meta.lua") "w"))
                 (format (..
                           "\t[%-"
                           (number->string (+ max-name 3))
                           "s { tag = \"var\", contents = %-"
                           (number->string (+ max-quot 1))
                           "s value = %-"
                           (number->string (+ max-pref 1))
                           "s },\n"))]
            (unless handle
              (logger/print-error! (.. "Cannot write to " path ".lua"))
              (exit! 1))

            (when prefix
              (self handle :write (string/format "local %s = %s or {}\n" prefix prefix)))

            (self handle :write "return {\n")
            (for-each native natives
              (self handle :write (string/format format
                                    (.. (quoted native) "] =")
                                    (.. (quoted (.. qualifier native)) ",")
                                    (.. qualifier native ","))))
            (self handle :write "}\n")

            (self handle :close)))))))

(let* [(file (car arg))
       (prefix (nth arg 2))]
  (unless file
    (logger/print-error! (.. "Expected file name"))
    (exit! 1))

  (print! (if prefix
            (string/format "Generating natives for %s (for global %s)" file prefix)
            (string/format "Generating natives for %s" file)))
  (gen-native file prefix))
