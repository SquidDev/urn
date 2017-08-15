---
title: extra/io
---
# extra/io
## `(append-all! path data)`
*Defined at lib/extra/io.lisp:104:1*

Appends the string `DATA` to the file at `PATH`.
Creates a new file if it doesn't exist.
Returns true if it succeeded or false if it failed.

### Example
```cl
> (append-all! "tests/data/hello_.txt" " Some appended text.")
out = true
```

## `(append-bytes! path data)`
*Defined at lib/extra/io.lisp:129:1*

Appends the bytes (list of numbers) `DATA` to the file at `PATH`.

Rreates a new file if it doesn't exist. Returns true if it succeeded
or false if it failed.

### Example
```cl
> (append-bytes! "tests/data/abc_.txt" `(100 101 102))
out = true
```

## `(append-lines! path data)`
*Defined at lib/extra/io.lisp:116:1*

Appends the lines (list of strings) `DATA` to the file at `PATH`.

Creates a new file if it doesn't exist. Returns true if it succeeded
or false if it failed.

### Example
```cl
> (append-lines! "tests/data/lines_.txt" `(" Here's another line:" "Another line."))
out = true
```

## `(read-all! path)`
*Defined at lib/extra/io.lisp:10:1*

Reads the data from the file at `PATH` and returns it as a string.
Returns nil if it failed.

### Example
```cl
> (read-all! "tests/data/hello.txt")
out = "Hello, world!"
```

## `(read-bytes! path)`
*Defined at lib/extra/io.lisp:33:1*

Reads the data from the file at `PATH` and returns it as a list of bytes
(numbers). Returns nil if it failed.

### Example
```cl
> (read-bytes! "tests/data/abc.txt")
out = (97 98 99)
```

## `(read-lines! path)`
*Defined at lib/extra/io.lisp:21:1*

Reads the lines from the file at `PATH` and returns it as a list of strings.
Returns nil if it failed.

### Example
```cl
> (read-lines! "tests/data/lines.txt")
out = ("This is the first line." "This is the second.")
```

## `(write-all! path data)`
*Defined at lib/extra/io.lisp:60:1*

Writes the string `DATA` to the file at `PATH`.

Creates a new file if it doesn't exist and overwrite the file if it
does. Returns true if it succeeded or false if it failed.

### Example
```cl
> (write-all! "tests/data/hello_.txt" "Hello, world!")
out = true
```

## `(write-bytes! path data)`
*Defined at lib/extra/io.lisp:86:1*

Writes the bytes (list of numbers) `DATA` to the file at `PATH`.

Creates a new file if it doesn't exist and overwrite the file if it
does. Returns true if it succeeded or false if it failed.

### Example
```cl
> (write-bytes! "tests/data/abc_.txt" `(97 98 99))
out = true
```

## `(write-lines! path data)`
*Defined at lib/extra/io.lisp:73:1*

Writes the lines (list of strings) `DATA` to the file at `PATH`.

Creates a new file if it doesn't exist and overwrite the file if it
does. Returns true if it succeeded or false if it failed.

### Example
```cl
> (write-lines! "tests/data/lines_.txt" `("This is the first line." "This is the second."))
out = true
```

