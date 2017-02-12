(import urn/resolve/tasks tasks)

(defun lookup-var! (task name)
  (let* [(queue (.> task :queue))
         (tasks (.> queue :var-tasks))
         (var-task (.> tasks name))]
    (unless var-task
      ;; TODO: Find a way to have a task which can never be resumed
      (set! var-task (
