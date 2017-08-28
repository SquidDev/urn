(import urn/logger logger)

(import lua/debug debug)

(define sentinel :hidden
  "A marker object which is errored, used to represent a resolver error."
  {})

(defun resolver-error? (err)
  "Determines whether ERR is a resolver error."
  (= err sentinel))

(defun resolver-error! ()
  "Throw a new resolver error."
  (fail! sentinel))

(defun do-node-error! (logger msg node explain &lines)
  "Push an error message to the LOGGER, then throw a new resolution
   error.

   This is equivalent to [[logger/do-node-error!]], but using
   [[resolver-error!]] instead."
  (apply logger/put-node-error! logger msg node explain lines)
  (resolver-error!))

(defun traceback (err)
  "Show a traceback for the given ERR object."
  (cond
    [(resolver-error? err) err]
    [(string? err)        (debug/traceback err 2)]
    [else                 (debug/traceback (pretty err) 2)]))
