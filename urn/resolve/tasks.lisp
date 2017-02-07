(import collections/unique-queue uq)
(import assert (assert!))

;;; Create a new task queue
(defun new () (struct
                :tag "task-queue"
                :blocked (empty-struct) ;; Set of all blocked tasks
                :ready (uq/new))) ;; Set of all tasks to be executed

;;; Create a new task
(defun new-task (func requires)
  (unless requires (set! requires '()))
  (with (task (struct
                :tag "task"
                :state "none"
                :func func ;; The function used to run this task
                :resolves '() ;; List of tasks that this one "resolves"
                :requires requires ;; List of tasks that this one requires
                :remaining 0)) ;; Number of remaining tasks
    (for-each req requires
      (push-cdr! (.> req :resolves) task))
    task))

;;; Inject a task into the system.
(defun add-task! (queue task)
  (assert-type! queue "task-queue")
  (assert-type! task "task")
  (assert! (= (.> task :state) "none") "Expected type to be none")

  (let [(new-state nil)
        (remaining 0)]
    (for-each req (.> task :requires)
      (with (req-state (.> req :state))
        (cond
          ((= req-state "fail") (unless new-state (set! new-state "fail")))
          ((= req-state "done")) ;; Pass: nothing to do here
          (true
            (unless new-state (set! new-state "wait"))
            (inc! remaining)))))
    (.<! task :remaining remaining)
    (cond
      ((= new-state "fail") (fail-task! task))
      ((= new-state "wait")
        (.<! task :state "wait")
        (.<! queue :blocked task true))
      ((= new-state nil)
        (.<! task :state "ready")
        (uq/add! (.> queue :ready) task)))))

;;; Resolve a failed task, removing it from all queues
;; and failing all dependent tasks
(defun fail-task! (queue task)
  (assert-type! queue "task-queue")
  (assert-type! task "task")
  (assert! (/= (.> task :state) "done") "Cannot fail done task")

  (.<! task :state "fail")
  (.<! queue :blocked task nil)

  (for-each res (.> task :resolves)
    (when (and (/= (.> res :state) "done") (/= (.> res :state) "fail"))
      (fail-task! queue res))))

;;; Resolve a finished task, setting its result
(defun finish-task! (queue task result)
  (assert-type! queue "task-queue")
  (assert-type! task "task")
  (assert! (= (.> task :state) "ready") "Expected task to be ready")

  (.<! task :state "done")
  (.<! task :value result)

  (for-each res (.> task :resolves)
    (with (remaining (pred (.> res :remaining)))
      (.<! res :remaining remaining)
      (when (= remaining 0)
        (.<! res :state "ready")
        (.<! queue :blocked task nil)
        (uq/add! (.> queue :ready) res)))))

;;; Defer the execution of a task, optionally setting a new callback and
;; adding additonal dependencies
(defun suspend-task! (queue task callback requires)
  (assert-type! queue "task-queue")
  (assert-type! task "task")
  (assert! (= (.> task :state) "ready") "Expected task to be ready")

  ;; Change the callback if needed
  (when callback (.<! task :func callback))

  ;; Add all additional requirements
  (when requires
    (for-each req requires
      (push-cdr! (.> req :resolves) task)))

  ;; Reset the task's state and re-inject it into the system
  (.<! task :state "none")
  (add-task! queue task))

;;; Execute a specified task
(defun execute-task! (queue task)
  (assert-type! queue "task-queue")
  (assert-type! task "task")
  (assert! (= (.> task :state) "ready") "Expected task to be ready")

  (with (results (map (cut get-idx <> :value) (.> task :requires)))
    ((.> task :func) queue task results)))
