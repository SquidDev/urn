(import lua/io (open))
(import string (byte char concat split))

(defun read-all-mode! (path binary) :hidden
  (when-let* [(handle (open path (.. "r" (if binary "b" ""))))
              (data (self handle :read "*all"))]
    (self handle :close)
    data))

(defun read-all! (path) 
  (read-all-mode! path false))

(defun read-lines! (path) 
  (when-with (data (read-all! path))
    (split data "\n")))

(defun read-bytes! (path)
  (when-with (data (read-all-mode! path true))
    (letrec [(string->bytes (str idx xs)
               (if (> idx (#s str))
                 xs
                 (append xs (append (list (byte str idx))
                                    (string->bytes str (+ idx 1) `())))))]
      (string->bytes data 1 `()))))


(defun write-all-mode! (path append binary data) :hidden
  (if (when-with (handle (open path (.. (if append "a" "w") (if binary "b" ""))))
    (self handle :write data)
    (self handle :close)
    true
  ) true false))

(defun write-all! (path data)
  (write-all-mode! path false false data))

(defun write-lines! (path data)
  (write-all! path (concat data "\n")))

(defun write-bytes! (path data)
  (letrec [(bytes->string (bytes idx xs)
           (if (> idx (# bytes))
             xs
             (append xs (append (list (char (nth bytes idx)))
                                (bytes->string bytes (+ idx 1) `())))))]
    (write-all-mode! path false true (concat (bytes->string data 1 `())))))

(defun append-all! (path data)
  (write-all-mode! path true false data))

(defun append-lines! (path data)
  (append-all! path (concat data "\n")))

(defun append-bytes! (path data)
  (letrec [(bytes->string (bytes idx xs)
           (if (> idx (# bytes))
             xs
             (append xs (append (list (char (nth bytes idx)))
                                (bytes->string bytes (+ idx 1) `())))))]
    (write-all-mode! path true true (concat (bytes->string data 1 `())))))