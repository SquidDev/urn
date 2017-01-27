;; Create a new unique set
(defun new (hash-func) (struct
  :tag "unique-queue"
  :set (empty-struct)
  :list '()
  :hash (or hash-func (lambda (x) x))))

;; Add an entry into the unique set, returning if it was added
;; (didn't exist before).
(defun add! (lst val)
  (assert-type! lst "unique-queue")
  (with (code ((.> lst :hash) val))
    (if (.> lst :set code)
      false
      (progn
        (.<! lst :set code true)
        (push-cdr! (.> lst :list) val)
        true))))

;; Remove the first entry from the list
(defun remove! (lst)
  (assert-type! lst "unique-queue")
  (when (<= (#q lst) 0) (error! "Empty queue"))
  (with (val (remove-nth! (.> lst :list) 1))
    (.<! lst :set ((.> lst :hash) val) nil)
    val))

;; Get the length of the list
(defun #q (lst) (# (.> lst :list)))

