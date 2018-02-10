(import core/base (defun defmacro error get-idx if unless setmetatable =))
(import core/method (pretty defmethod))
(import core/type (type list? symbol?))

(import compiler (flag?))
(import lua/debug debug)
(import lua/string string)

(defun demand-failure->string (failure)
  :hidden
  (if (get-idx failure :message)
    (string/format "demand not met: %s (%s).\n%s"
                   (get-idx failure :condition)
                   (get-idx failure :message)
                   (get-idx failure :traceback))
    (string/format "demand not met: %s.\n%s"
                   (get-idx failure :condition)
                   (get-idx failure :traceback))))

(define *demand-failure-mt* :hidden
  { :__tostring demand-failure->string })

(defun demand-failure (message condition)
  "Construct a new demand-failure with the given MESSAGE and CONDITION
   string."
  :hidden
  ;; Whilst it may be tidier to error in this function, in order to preserve
  ;; the stack we error in the parent function instead.
  (setmetatable
    { :tag       "demand-failure"
      :message   message
      :traceback (if debug/traceback (debug/traceback "" 2) "")
      :condition condition }
    *demand-failure-mt*))

(defmethod (pretty demand-failure) (failure)
  (demand-failure->string failure))

(defun maybe-demand (condition message) :hidden
  (if (flag? :lax :lax-checks)
    `nil
    `(unless ,condition
       (error (demand-failure ,(if (= message nil) `nil message)
                              ,(pretty condition))))))

(defmacro demand (condition message)
  "Demand that particular CONDITION is upheld. If provided, MESSAGE will
   be included in the thrown error.

   Note that MESSAGE is only evaluated if CONDITION is not met."
  (maybe-demand condition message))

(defmacro desire (condition message)
  "Demand that particular CONDITION is upheld if debug assertions are
   on (`-fstrict-checks`). If provided, MESSAGE will be included in the
   thrown error.

   Note that MESSAGE is only evaluated if CONDITION is not met. Neither
   will be evaluated if debug assertions are disabled."
  (if (flag? :strict :strict-checks)
    (maybe-demand condition message)
    `nil))

(defmacro assert-type! (arg ty)
  "Assert that the argument ARG has type TY, as reported by the function
   [[type]]."
  :deprecated "Use [[desire]] or [[demand]] instead."
  `(demand (= (type ,arg) ,(get-idx ty :contents))))
