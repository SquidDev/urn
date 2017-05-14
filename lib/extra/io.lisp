(import lua/io (open))
(import string (byte char concat split))

(defun read-all-mode! (path binary) :hidden
  (when-let* [(handle (open path (.. "r" (if binary "b" ""))))
              (data (self handle :read "*all"))]
    (self handle :close)
    data))

(defun read-all! (path)
  "Reads the data from the file at PATH and returns it as a string.
   Returns nil if it failed.

   ### Example
   ```
   > (read-all! \"hello.txt\")
   \"Hello, world!\"
   ```"
  (read-all-mode! path false))

(defun read-lines! (path)
  "Reads the lines from the file at PATH and returns it as a list of strings.
   Returns nil if it failed.

   ### Example
   ```
   > (read-lines! \"lines.txt\")
   (\"This is the first line.\" \"This is the second.\")
   ```"
  (when-with (data (read-all! path))
    (split data "\n")))

(defun read-bytes! (path)
  "Reads the data from the file at PATH and returns it as a list of bytes
   (numbers). Returns nil if it failed.

   ### Example
   ```
   > (read-bytes! \"abc.txt\")
   (97 98 99)
   ```"
  (when-with (data (read-all-mode! path true))
    (letrec [(string->bytes (str idx)
               (if (> idx (n str))
                 `()
                 (cons (byte str idx)
                       (string->bytes str (+ idx 1)))))]
      (string->bytes data 1 `()))))


(defun write-all-mode! (path append binary data) :hidden
  (with (handle (open path (.. (if append "a" "w") (if binary "b" ""))))
    (if handle
      (progn
        (self handle :write data)
        (self handle :close)
        true)
      false)))

(defun write-all! (path data)
  "Writes the string DATA to the file at PATH.

   Creates a new file if it doesn't exist and overwrite the file if it
   does. Returns true if it succeeded or false if it failed.

   ### Example
   ```
   > (write-all! \"hello.txt\" \"Hello, world!\")
   true
   ```"
  (write-all-mode! path false false data))

(defun write-lines! (path data)
  "Writes the lines (list of strings) DATA to the file at PATH.

   Creates a new file if it doesn't exist and overwrite the file if it
   does. Returns true if it succeeded or false if it failed.

   ### Example
   ```
   > (write-lines! \"lines.txt\" `(\"This is the first line.\" \"This is the second.\"))
   true
   ```"
  (write-all! path (concat data "\n")))

(defun write-bytes! (path data)
  "Writes the bytes (list of numbers) DATA to the file at PATH.

   Creates a new file if it doesn't exist and overwrite the file if it
   does. Returns true if it succeeded or false if it failed.

   ### Example
   ```
   > (write-bytes! \"abc.txt\" `(97 98 99))
   true
   ```"
  (letrec [(bytes->string (bytes idx)
             (if (> idx (n bytes))
               `()
               (cons (char (nth bytes idx))
                     (bytes->string bytes (+ idx 1)))))]
    (write-all-mode! path false true (concat (bytes->string data 1)))))

(defun append-all! (path data)
  "Appends the string DATA to the file at PATH.
   Creates a new file if it doesn't exist.
   Returns true if it succeeded or false if it failed.

   ### Example
   ```
   > (append-all! \"hello.txt\" \" Some appended text.\")
   true
   ```"
  (write-all-mode! path true false data))

(defun append-lines! (path data)
  "Appends the lines (list of strings) DATA to the file at PATH.

   Creates a new file if it doesn't exist. Returns true if it succeeded
   or false if it failed.

   ### Example
   ```
   > (append-lines! \"lines.txt\" `(\" Here's another line:\" \"Another line.\"))
   true
   ```"
  (append-all! path (concat data "\n")))

(defun append-bytes! (path data)
  "Appends the bytes (list of numbers) DATA to the file at PATH.

   Rreates a new file if it doesn't exist. Returns true if it succeeded
   or false if it failed.

   ### Example
   ```
   > (append-bytes! \"abc.txt\" `(100 101 102))
   true
   ```"
  (letrec [(bytes->string (bytes idx)
             (if (> idx (n bytes))
               `()
               (cons (char (nth bytes idx))
                     (bytes->string bytes (+ idx 1)))))]
    (write-all-mode! path true true (concat (bytes->string data 1)))))
