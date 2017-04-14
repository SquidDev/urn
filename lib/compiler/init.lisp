"The compiler plugin infrastructure provides a way of modifying how the
 compiler processes code."

(define-native logger/put-error!
  "Push an error message MSG to the logger")

(define-native logger/put-warning!
  "Push an warning message MSG to the logger")

(define-native logger/put-verbose!
  "Push an verbose message MSG to the logger")

(define-native logger/put-debug!
  "Push an verbose message MSG to the logger")

(define-native logger/put-node-error!
  "Push a defailed error message to the logger.

   You must provide a message MSG and a node NODE, additional
   explainations EXPLAIN can be provided, along with a series of
   LINES. These LINES are split into pairs of elements with the first
   designating it's position and the second a descriptive piece of
   text.")

(define-native logger/put-node-warning!
  "Push a warning message to the logger.

   You must provide a message MSG and a node NODE, additional
   explainations EXPLAIN can be provided, along with a series of
   LINES. These LINES are split into pairs of elements with the first
   designating it's position and the second a descriptive piece of
   text.")

(define-native logger/do-node-error!
  "Push an error message to the logger, then fail.

   You must provide a message MSG and a node NODE, additional
   EXPLAINATIONS explain can be provided, along with a series of
   LINES. These LINES are split into pairs of elements with the first
   designating it's position and the second a descriptive piece of
   text.")

(define-native range/get-source
  "Get the nearest source position of NODE

   This will walk up NODE's tree until a non-macro node is found.")
