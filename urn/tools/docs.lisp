(import io/argparse arg)
(import lua/io io)

(import urn/backend/markdown markdown)
(import urn/backend/writer writer)
(import urn/loader (strip-extension))
(import urn/logger logger)

(defun docs (compiler args)
  (when (empty? (.> args :input))
    (logger/put-error! (.> compiler :log) "No inputs to generate documentation for.")
    (exit! 1))

  (for-each path (.> args :input)
    (let* [(lib (.> compiler :lib-cache path))
           (writer (writer/create))]
      (markdown/exported writer (.> lib :name) (.> lib :docs) (.> lib :scope :exported) (.> lib :scope))

      (with (handle (io/open (.. (.> args :docs) "/" (string/gsub (strip-extension path) "/" ".") ".md") "w"))
        (self handle :write (writer/->string writer))
        (self handle :close)))))

(define task
  { :name "docs"
    :setup (lambda (spec)
             (arg/add-argument! spec '("--docs")
               :help    "Specify the folder to emit documentation to."
               :cat     "out"
               :default nil
               :narg    1))
    :pred  (lambda (args) (/= nil (.> args :docs)))
    :run   docs })
