---
title: lib/extra/io
---
# lib/extra/io
## `(append-all! path data)`
*Defined at lib/extra/io.lisp:101:1*

Appends the string `DATA` to the file at `PATH`.
Creates a new file if it doesn't exist.
Returns true if it succeeded or false if it failed.

### Example
```
> (append-all! "hello.txt" " Some appended text.")
true
```

## `(append-bytes! path data)`
*Defined at lib/extra/io.lisp:125:1*

Appends the bytes (list of numbers) `DATA` to the file at `PATH`.
Creates a new file if it doesn't exist.
Returns true if it succeeded or false if it failed.

### Example
```
> (append-bytes! "abc.txt" `(100 101 102))
true
```

## `(append-lines! path data)`
*Defined at lib/extra/io.lisp:113:1*

Appends the lines (list of strings) `DATA` to the file at `PATH`.
Creates a new file if it doesn't exist.
Returns true if it succeeded or false if it failed.

### Example
```
> (append-lines! "lines.txt" `(" Here's another line:" "Another line."))
true
```

## `(read-all! path)`
*Defined at lib/extra/io.lisp:10:1*

Reads the data from the file at `PATH` and returns it as a string.
Returns nil if it failed.

### Example
```
> (read-all! "hello.txt")
"Hello, world!"
```

## `(read-bytes! path)`
*Defined at lib/extra/io.lisp:33:1*

Reads the data from the file at `PATH` and returns it as a list of bytes (numbers).
Returns nil if it failed.

### Example
```
> (read-bytes! "abc.txt")
(97 98 99)
```

## `(read-lines! path)`
*Defined at lib/extra/io.lisp:21:1*

Reads the lines from the file at `PATH` and returns it as a list of strings.
Returns nil if it failed.

### Example
```
> (read-lines! "lines.txt")
("This is the first line." "This is the second.")
```

## `(write-all! path data)`
*Defined at lib/extra/io.lisp:60:1*

Writes the string `DATA` to the file at `PATH`.
Creates a new file if it doesn't exist and overwrite the file if it does.
Returns true if it succeeded or false if it failed.

### Example
```
> (write-all! "hello.txt" "Hello, world!")
true
```

## `(write-bytes! path data)`
*Defined at lib/extra/io.lisp:84:1*

Writes the bytes (list of numbers) `DATA` to the file at `PATH`.
Creates a new file if it doesn't exist and overwrite the file if it does.
Returns true if it succeeded or false if it failed.

### Example
```
> (write-bytes! "abc.txt" `(97 98 99))
true
```

## `(write-lines! path data)`
*Defined at lib/extra/io.lisp:72:1*

Writes the lines (list of strings) `DATA` to the file at `PATH`.
Creates a new file if it doesn't exist and overwrite the file if it does.
Returns true if it succeeded or false if it failed.

### Example
```
> (write-lines! "lines.txt" `("This is the first line." "This is the second."))
true
```

