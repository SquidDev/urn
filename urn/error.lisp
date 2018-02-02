(import urn/logger logger)
(import urn/traceback (traceback-plain))

(define metatable
  "The metatable for compiler errors. Also doubles as a sentinel value to
   determine whether something is a compiler error or not."
  :hidden
  { :__tostring (lambda (self) (.> self :message)) })

(defun compiler-error? (err)
  "Determines whether ERR is a resolver error."
  (and (table? err) (= (getmetatable err) metatable)))

(defun compiler-error! (message)
  "Throw a new compiler error."
  (assert-type! message string)
  (error! (setmetatable { :type     "compiler-error"
                          :message  message }
                        metatable )))

(defun resolver-error! ()
  "Throw a resolution error."
  (compiler-error! "Resolution failed"))

(defun do-node-error! (logger msg source explain &lines)
  "Push an error message to the LOGGER, then throw a new resolution
   error."
  (apply logger/put-node-error! logger msg source explain lines)
  (compiler-error! (or (string/match msg "^([^\n]+)\n") msg)))

(defun traceback (err)
  "Show a traceback for the given ERR object."
  (cond
    [(compiler-error? err) err]
    [(string? err)        (traceback-plain err 2)]
    [else                 (traceback-plain (pretty err) 2)]))
