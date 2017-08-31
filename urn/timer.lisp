(import lua/os os)

(defun create (fn)
  "Create a new timer, which will output to LOGGER."
  { :callback fn
    :timers   {} })

(defun start-timer! (timer name level)
  "Start a new timer (or resume an existing one) with the given NAME, pushing onto TIMER's stack."
  (with (instance (.> timer :timers name))
    (unless instance
      (set! instance { :name    name
                       :level   (or level 1)
                       :running false
                       :total   0 })
      (.<! timer :timers name instance))

    (when (.> instance :running) (error! (.. "Timer " name " is already running")))

    (.<! instance :running true)
    (.<! instance :start (os/clock))))

(defun pause-timer! (timer name)
  "Pause a timer with the given NAME on TIMER's stack."
  (with (instance (.> timer :timers name))
    (unless instance (error! (.. "Timer " name " does not exist")))
    (unless (.> instance :running) (error! (.. "Timer " name " is not running")))

    (.<! instance :running false)
    (.<! instance :total (+ (- (os/clock) (.> instance :start)) (.> instance :total)))))

(defun stop-timer! (timer name)
  "Stop a timer with the given NAME on TIMER's stack, removiving it and calling the callback."
  (with (instance (.> timer :timers name))
    (unless instance (error! (.. "Timer " name " does not exist")))
    (unless (.> instance :running) (error! (.. "Timer " name " is not running")))

    (.<! timer :timers name nil)
    (.<! instance :total (+ (- (os/clock) (.> instance :start)) (.> instance :total)))

    ((.> timer :callback) (.> instance :name) (.> instance :total) (.> instance :level))))

(defun void ()
  "An empty timer which does nothing."
  (create (lambda ())))
