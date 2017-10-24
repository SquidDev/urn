(defun put-error! (logger msg)
  "Push an error message MSG to this LOGGER"
  (self logger :put-error! msg))

(defun put-warning! (logger msg)
  "Push an warning message MSG to this LOGGER"
  (self logger :put-warning! msg))

(defun put-verbose! (logger msg)
  "Push an verbose message MSG to this LOGGER"
  (self logger :put-verbose! msg))

(defun put-debug! (logger msg)
  "Push an verbose message MSG to this LOGGER"
  (self logger :put-debug! msg))

(defun put-time! (logger name time level)
  "Push the TIME it took NAME to execute to this LOGGER.

   Each additonal LEVEL to the timings will delay require an additional -t flag."
  (self logger :put-time! name time level))

(defun put-node-error! (logger msg node explain &lines)
  "Push a defailed error message to this LOGGER.

   You must provide a message MSG and a node NODE, additional explainations
   EXPLAIN can be provided, along with a series of LINES. These LINES are split
   into pairs of elements with the first designating it's position and the
   second a descriptive piece of text."
  (self logger :put-node-error! msg node explain lines))

(defun put-node-warning! (logger msg node explain &lines)
  "Push a warning message to this LOGGER.

   You must provide a message MSG and a node NODE, additional explainations
   EXPLAIN can be provided, along with a series of LINES. These LINES are split
   into pairs of elements with the first designating it's position and the
   second a descriptive piece of text."
  (self logger :put-node-warning! msg node explain lines))

(defun do-node-error! (logger msg node explain &lines)
  "Push an error message to this LOGGER, then fail.

   You must provide a message MSG and a node NODE, additional EXPLAINATIONS
   explain can be provided, along with a series of LINES. These LINES are split
   into pairs of elements with the first designating it's position and the
   second a descriptive piece of text."
  :deprecated "Use error/do-node-error! instead"
  (self logger :put-node-error! msg node explain lines)
  (fail! (or (string/match msg "^([^\n]+)\n") msg)))
