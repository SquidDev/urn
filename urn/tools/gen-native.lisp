(import extra/argparse arg)
(import lua/io io)
(import lua/math math)
(import lua/table table)
(import string (quoted))

(import urn/logger logger)

(defun dot-quote (prefix name)
  :hidden
  (if (string/find name "^[%w_][%d%w_]*$")
    (if prefix (.. prefix "." name) name)
    (if prefix (.. prefix "[" (quoted name) "]") (.. "_ENV[" (quoted name) "]"))))

(defun gen-native (compiler args)
  :hidden
  (when (/= (# (.> args :input)) 1)
    (logger/put-error! (.> compiler :log) "Expected just one input")
    (exit! 1))

  (let* [(prefix (.> args :gen-native))
         (lib (.> compiler :libCache (string/gsub (last (.> args :input)) "%.lisp$" "")))
         (max-name 0)
         (max-quot 0)
         (max-pref 0)
         (natives '())]
    (for-each node (.> lib :out)
      (when (and (list? node) (symbol? (car node)) (= (.> (car node) :contents) "define-native"))
        (with (name (.> (nth node 2) :contents))
          (push-cdr! natives name)

          (set! max-name (math/max max-name (#s (quoted name))))
          (set! max-quot (math/max max-quot (#s (quoted (dot-quote prefix name)))))
          (set! max-pref (math/max max-pref (#s (dot-quote prefix name)))))))

    (table/sort natives)

    (let* [(handle (io/open (.. (.> lib :path) ".meta.lua") "w"))
           (format (..
                     "\t[%-"
                     (number->string (+ max-name 3))
                     "s { tag = \"var\", contents = %-"
                     (number->string (succ max-quot))
                     "s value = %-"
                     (number->string (succ max-pref))
                     "s },\n"))]
      (unless handle
        (logger/put-error! (.> compiler :log) (.. "Cannot write to " (.> lib :path) ".meta.lua"))
        (exit! 1))

      (when (string? prefix)
        (self handle :write (string/format "local %s = %s or {}\n" prefix prefix)))

      (self handle :write "return {\n")
      (for-each native natives
        (self handle :write (string/format format
                              (.. (quoted native) "] =")
                              (.. (quoted (dot-quote prefix native)) ",")
                              (.. (dot-quote prefix native) ","))))
      (self handle :write "}\n")
      (self handle :close))))

(define task
  (struct
    :name  "gen-native"
    :setup (lambda (spec)
             (arg/add-argument! spec '("--gen-native")
               :help "Generate native bindings for a file"
               :var  "PREFIX"
               :narg "?"))
    :pred  (lambda (args) (.> args :gen-native))
    :run   gen-native))
