"The backend system is split into two sections:

  - Node categorisation: here we attempt to determine an representation
    of a specific node for which we can generate more efficient flags.

  - Code generation: here we actually emit code for a specific backend.
"

(define-native categorise-node
  "Categorise the given NODE, specifying whether it is a STATEMENT or
  not.")

(define-native categorise-nodes
  "Categorise the given NODES, starting from START, specifying whether
  it is a STATEMENT or not.")

(define-native add-categoriser!
  "Register a custom CATEGORISER. Optionally specify a single backend to
   register for.

   The CATEGORISER should accept a node and a flag marking whether the
   current expression is a statement or not.

   If it can handle this node, you should return the result of [[cat]],
   with optional flags specified, otherwise you should return nil. Note,
   [[cat]] can specify a series of optional flags:

    - `:stmt`: Whether this is a statement or not.

   If you can successfully handle this node, then you must also handle
   the visiting of its children. You should avoid visiting children
   unless you can handle them. Visiting is done using
   [[categorise-node]].")

(define-native cat
  "Create a CATEGORY data set, using ARGS as additional parameters to
   [[struct]].")

(define-native writer/append!
  "Append a string to the specified WRITER.")

(define-native writer/line!
  "Append a line to the specified WRITER. If no string is specified then
   it will just move onto the next line.")

(define-native writer/indent!
  "Add an indentation level to this WRITER.")

(define-native writer/unindent!
  "Remove an indentation level from this WRITER.")

(define-native writer/begin-block!
  "Append a line with the given TEXT to this WRITER, then indent.")

(define-native writer/next-block!
  "End one indented statement and begin another with the given TEXT in
  WRITER.")

(define-native writer/end-block!
  "End an indented statement with the given TEXT in WRITER")

(define-native add-emitter!
  "Register an EMITTER for the specified CATEGORY.

   This accepts a function with the current compiler state, the target
   node, the target node category and \"return preamble\". You are
   responsable for emitting child nodes with [[emit-block]] and
   [[emit-node]].

   Note, the \"return preamble\" represents the place to store the
   result of this node. This is one of three things:

    - `nil`: Represents an expression context.

    - The empty string: Represents a block context for which this value
      is discarded.

    - A non-empty string: represents a place where this value is
      stored.")

(define-native emit-block
  "Using the specified compiler STATE, emit the given NODES, starting at
   IDX. The last expression will be stored in RET.")

(define-native emit-node
  "Using the specified compiler STATE, emit the given NODE, storing its
  value in RET.")
