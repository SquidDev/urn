(import data/struct ())

(import urn/resolve/scope scope)

(defstruct (library-cache library-cache library-cache?)
  "Create a new library cache, responsible for tracking which libraries
   have been loaded, the order they were imported and various additional
   information."
  (fields
    (immutable values
      "A lookup of variable names to their corresponding values.")
    (immutable metas
      "A lookup of variable names to their meta declarations.")
    (immutable paths
      "A lookup of file paths to the library located at that location.")
    (immutable names
      "A cache of library names and the corresponding library.")
    (immutable loaded
      "A list of all loaded libraries."))
  (constructor new
    (lambda () (new {} {} {} {} '()))))

(defun library-cache-value (cache name)
  "Get the value from the library CACHE for the corresponding variable
   NAME."
  (.> (library-cache-values cache) name))

(defun set-library-cache-value! (cache name value)
  "Set the VALUE in the library CACHE for the corresponding variable
   NAME."
  (.<! (library-cache-values cache) name value))

(defun library-cache-meta (cache name)
  "Get the native metadata from the library CACHE for the corresponding
   variable NAME."
  (.> (library-cache-metas cache) name))

(defun set-library-cache-meta! (cache name value)
  "Set the native metadata in the library CACHE for the corresponding variable
   NAME."
  (.<! (library-cache-metas cache) name value))

(defun library-cache-at-path (cache path)
  "Get the cached library at the given PATH."
  (.> (library-cache-paths cache) path))

(defun set-library-cache-at-path! (cache path library)
  "Set the cached library at the given path"
  (.<! (library-cache-paths cache) path library))

(defstruct (library library-of library?)
  "Create a new library with the given NAME, UNIQUE-NAME and PATH. This
   will use PARENT-SCOPE to setup this library's scope."
  (fields
    (immutable name
      "The name of this library.")

    (immutable unique-name
      "A unique name for this library.")

    (immutable path
      "The path this library was loaded from, not including the file
       extension.")

    (mutable scope
      "The scope for this library.")

    (mutable nodes
      "A list of top level nodes belonging to this library")

    (mutable docs
      "This library's documentation string, or nil if it is not set.")

    (mutable lisp-lines
      "The list of lines in the Lisp file.")

    (mutable lua-contents
      "The contents of the associated Lua bindings file.")

    (mutable depends
      "Set of libraries this one directly depends on, does not include
       transitive dependencies."))

  (constructor new
    (lambda (name unique-name path parent-scope)
      (new name unique-name path
           (scope-for-library parent-scope name unique-name)
           nil nil nil nil {}))))

(defun scope-for-library (parent name unique-name)
  "Construct a scope for a library using a PARENT scope, NAME and
   UNIQUE-NAME."
  (assert-type! name string)
  (assert-type! unique-name string)

  (with (scope (scope/child parent "top-level"))
    (scope/set-scope-prefix! scope (.. name "/"))
    (scope/set-scope-unique-prefix! scope (.. unique-name "/"))
    scope))
