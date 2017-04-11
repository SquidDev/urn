---
title: The REPL
---

# The REPL
The REPL allows you to input Urn code and execute it immediately. This is immensely useful, as it allows you to quickly
test something, be it a built-in function or a new idea you had. You can launch the REPL by running Urn with no
arguments, or using the `--repl` flag.

For ease-of-use and efficiency, the REPL differs slightly from normal compilation:

 - No optimisation passes or static analysis is performed.
 - You can override top-level definitions in subsequent inputs. Note that expressions that referenced the original
   definition will not be changed.

## Commands
The REPL also comes with several "commands", which can be used to query various aspects of the running state. These can
be seen using the `:help` (or `:h)` command:

### `:[d]oc NAME`
This command allows you to fetch the doc-string of a symbol in the current scope.

### `:[s]earch QUERY`
The search command will look for symbols and doc-strings matching the given pattern. You can use `:doc` to get further
information about a given command.

### `:module NAME`
This will search for loaded modules with the given name, displaying the defined symbols and the module-level
doc-string. Note that this will not attempt to load the module if it cannot be found: you will have to import it
normally first.
