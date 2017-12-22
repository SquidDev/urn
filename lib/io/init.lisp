(import lua/io (open))

(defun read-all-mode! (path binary) :hidden
  (when-let* [(handle (open path (.. "r" (if binary "b" ""))))
              (data (self handle :read "*all"))]
    (self handle :close)
    data))

(defun read-all! (path)
  "Reads the data from the file at PATH and returns it as a string.
   Returns nil if it failed.

   ### Example
   ```cl
   > (read-all! \"tests/data/hello.txt\")
   out = \"Hello, world!\"
   ```"
  (read-all-mode! path false))

(defun read-lines! (path)
  "Reads the lines from the file at PATH and returns it as a list of strings.
   Returns nil if it failed.

   ### Example
   ```cl
   > (read-lines! \"tests/data/lines.txt\")
   out = (\"This is the first line.\" \"This is the second.\")
   ```"
  (when-with (data (read-all! path))
    (string/split data "\n")))

(defun read-bytes! (path)
  "Reads the data from the file at PATH and returns it as a list of bytes
   (numbers). Returns nil if it failed.

   ### Example
   ```cl
   > (read-bytes! \"tests/data/abc.txt\")
   out = (97 98 99)
   ```"
  (string/string->bytes (read-all-mode! path true)))

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
   ```cl
   > (write-all! \"tests/data/hello_.txt\" \"Hello, world!\")
   out = true
   ```"
  (write-all-mode! path false false data))

(defun write-lines! (path data)
  "Writes the lines (list of strings) DATA to the file at PATH.

   Creates a new file if it doesn't exist and overwrite the file if it
   does. Returns true if it succeeded or false if it failed.

   ### Example
   ```cl
   > (write-lines! \"tests/data/lines_.txt\" `(\"This is the first line.\" \"This is the second.\"))
   out = true
   ```"
  (write-all! path (concat data "\n")))

(defun write-bytes! (path data)
  "Writes the bytes (list of numbers) DATA to the file at PATH.

   Creates a new file if it doesn't exist and overwrite the file if it
   does. Returns true if it succeeded or false if it failed.

   ### Example
   ```cl
   > (write-bytes! \"tests/data/abc_.txt\" `(97 98 99))
   out = true
   ```"
  (write-all-mode! path false true (string/bytes->string data)))

(defun append-all! (path data)
  "Appends the string DATA to the file at PATH.
   Creates a new file if it doesn't exist.
   Returns true if it succeeded or false if it failed.

   ### Example
   ```cl
   > (append-all! \"tests/data/hello_.txt\" \" Some appended text.\")
   out = true
   ```"
  (write-all-mode! path true false data))

(defun append-lines! (path data)
  "Appends the lines (list of strings) DATA to the file at PATH.

   Creates a new file if it doesn't exist. Returns true if it succeeded
   or false if it failed.

   ### Example
   ```cl
   > (append-lines! \"tests/data/lines_.txt\" `(\" Here's another line:\" \"Another line.\"))
   out = true
   ```"
  (append-all! path (concat data "\n")))

(defun append-bytes! (path data)
  "Appends the bytes (list of numbers) DATA to the file at PATH.

   Rreates a new file if it doesn't exist. Returns true if it succeeded
   or false if it failed.

   ### Example
   ```cl
   > (append-bytes! \"tests/data/abc_.txt\" `(100 101 102))
   out = true
   ```"
  (write-all-mode! path true true (string/bytes->string data)))
