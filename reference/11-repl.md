---
title: The REPL
---

# The REPL
{:.no_toc}

The REPL allows you to input Urn code and execute it immediately. This is immensely useful, as it allows you to quickly
test something, be it a built-in function or a new idea you had. You can launch the REPL by running Urn with no
arguments, or using the `--repl` flag.

For ease-of-use and efficiency, the REPL differs slightly from normal compilation:

 - No optimisation passes or static analysis is performed.
 - You can override top-level definitions in subsequent inputs. Note that expressions that referenced the original
   definition will not be changed.

The REPL also comes with several "commands", which can be used to query various aspects of the running state. These can
be seen using the `:help` (or `:h`) command:

* TOC
{:toc}

## `:[d]oc NAME`
This command allows you to fetch the doc-string of a symbol in the current scope.


```repl
> :doc car
(list/car x)
Return the first element present in the list X. This function operates
in constant time.

### Example:
> (car '(1 2 3))
out = 1
```

### `:module NAME`
This will search for loaded modules with the given name, displaying the defined symbols and the module-level
doc-string. Note that this will not attempt to load the module if it cannot be found: you will have to import it
normally first.

```repl
> :module table
table
Located at lib/table
Exported symbols
.<!  .>  assoc  assoc->struct  assoc?  copy-of  create-lookup  empty-struct?  extend  fast-struct  ...
```

## `:[r]eload`
This finds modules which have changed on disk, and reloads them along with any files which depend on them. This allows
you to quickly edit + refresh code without having to continuously restart the REPL.

## `:[s]earch QUERY`
The search command will look for symbols and doc-strings matching the given pattern. You can use `:doc` to get further
information about a given command.

```repl
> :search car
Search by function name:
cars  car
Search by function docs:
destructuring-bind  head  map  maybe-map  loop  car
```

## `:[v]iew NAME`
Pretty print the source code of the given symbol's definition.

```repl
> :view car
(defun car (x)
  "Return the first element present in the list X. This function operates
   in constant time."
  (assert-type! x list)
  (base/car x))
```
