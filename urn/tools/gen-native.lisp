(import io/argparse arg)
(import lua/io io)
(import lua/math math)

(import urn/logger logger)
(import urn/library ())
(import urn/backend/lua/escape (escape))

(defun dot-quote (prefix name)
  :hidden
  (if (string/find name "^[%w_][%d%w_]*$")
    (if (string? prefix) (.. prefix "." name) name)
    (if (string? prefix) (.. prefix "[" (string/quoted name) "]") (.. "_ENV[" (string/quoted name) "]"))))

(defun gen-native (compiler args)
  :hidden
  (when (/= (n (.> args :input)) 1)
    (logger/put-error! (.> compiler :log) "Expected just one input")
    (exit! 1))

  (let* [(prefix (.> args :gen-native))
         (lib (.> compiler :lib-cache (last (.> args :input))))
         (escaped (if (string? prefix) (escape (last (string/split (library-name lib) "/"))) nil))
         (max-name 0)
         (max-quot 0)
         (max-pref 0)
         (natives '())]
    (for-each node (library-nodes lib)
      (when (and (list? node) (symbol? (car node)) (= (.> (car node) :contents) "define-native"))
        (with (name (.> (nth node 2) :contents))
          (push-cdr! natives name)

          (set! max-name (math/max max-name (n (string/quoted name))))
          (set! max-quot (math/max max-quot (n (string/quoted (dot-quote prefix name)))))
          (set! max-pref (math/max max-pref (n (dot-quote escaped name)))))))

    (sort! natives)

    (let* [(handle (io/open (.. (library-path lib) ".meta.lua") "w"))
           (format (..
                     "\t[%-"
                     (number->string (+ max-name 3))
                     "s { tag = \"var\", contents = %-"
                     (number->string (succ max-quot))
                     "s value = %-"
                     (number->string (succ max-pref))
                     "s },\n"))]
      (unless handle
        (logger/put-error! (.> compiler :log) (.. "Cannot write to " (library-path lib) ".meta.lua"))
        (exit! 1))

      (when (string? prefix)
        (self handle :write (string/format "local %s = %s or {}\n" escaped prefix)))

      (self handle :write "return {\n")
      (for-each native natives
        (self handle :write (string/format format
                              (.. (string/quoted native) "] =")
                              (.. (string/quoted (dot-quote prefix native)) ",")
                              (.. (dot-quote escaped native) ","))))
      (self handle :write "}\n")
      (self handle :close))))

(define task
  { :name  "gen-native"
    :setup (lambda (spec)
             (arg/add-argument! spec '("--gen-native")
               :help "Generate native bindings for a file"
               :var  "PREFIX"
               :narg "?"))
    :pred  (lambda (args) (.> args :gen-native))
    :run   gen-native })
