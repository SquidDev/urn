(import data/struct ())

(import urn/resolve/scope scope)

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

    (immutable scope
      "The scope for this library.")

    (mutable nodes
      "A list of top level nodes belonging to this library")

    (mutable docs
      "This library's documentation string, or nil if it is not set.")

    (mutable lisp-lines
      "The list of lines in the Lisp file.")

    (mutable lua-contents
      "The contents of the associated Lua bindings file.")

    (immutable depends
      "Set of libraries this one directly depends on, does not include
       transitive dependencies."))

  (constructor new
    (lambda (name unique-name path parent-scope)
      (with (scope (scope/child parent-scope "top-level"))
        (scope/set-scope-prefix! scope (.. name "/"))
        (scope/set-scope-unique-prefix! scope (.. unique-name "/"))

        (new name unique-name path scope nil nil nil nil {})))))
