---
title: io/argparse
---
# io/argparse
An argument parsing library.

You specify the arguments for this parser, and the arg parser will
handle parsing and documentation generation.

The parser is created with [`create`](lib.io.argparse.md#create) and arguments can be added with
[`add-argument!`](lib.io.argparse.md#add-argument-). Should you want the parser to handle `--help` and
friends, you should call [`add-help!`](lib.io.argparse.md#add-help-). Once the parser is 'built', you
can parse inputs with [`parse!`](lib.io.argparse.md#parse-)

### Example
```cl
(with (spec (create))
  (add-help! spec)
  (add-argument! spec '("files")
    :help "The input files")

  (add-argument! spec '("--output" "-o")
    :help "Specify the output file"
    :default "out.lua"
    :nargs 1)

  (parse! spec))
```

## `add-action`
*Defined at lib/io/argparse.lisp:41:2*

Append `VALUE` to the appropriate key in `DATA` for `ARG`.

## `add-argument!`
*Defined at lib/io/argparse.lisp:57:2*

Add a new argument to `SPEC`, using the specified `NAMES`.

`OPTIONS` is composed of a key followed by the corresponding value. The
following options are valid:

 - `:name`: The name to store the result in. Defaults to the first
   item given in `NAMES`.

 - `:narg`: The number of arguments to consume. This can be any
   number, '+', '*' or '?'. Defaults to 0 if the first `:name` starts
   with `-`, otherwise `*`.
 - `:default`: The default value to use. Defaults to `false`.
 - `:value`: The value to use if this is used without an
   argument (such as a flag). Defaults to `true`.
 - `:help`: The description text to display when using this.
 - `:var`: The variable name to show in help files. Defaults to
   `:name`.
 - `:action`: The action to execute when this option is used. Must be
   a function which takes three arguments: current arg, data and
   value.
 - `:many`: Whether you can specify this argument multiple times.
 - `:all`: Whether this will consume all values, including those
   starting with `-`.
 - `:cat`: The "category" this argument belongs to. This must be one
   added by [`add-category!`](lib.io.argparse.md#add-category-).

## `add-category!`
*Defined at lib/io/argparse.lisp:149:2*

Add a new category with the given `ID`, display `NAME` and an optional `DESCRIPTION`.

## `add-help!`
*Defined at lib/io/argparse.lisp:136:2*

Add a help argument to `SPEC`.

This will show the help message whenever --help or -h is used and
then quit the program.

## `create`
*Defined at lib/io/argparse.lisp:28:2*

Create a new argument parser

## `help!`
*Defined at lib/io/argparse.lisp:198:2*

Display the help for the argument parser as defined in `SPEC`.

## `parse!`
*Defined at lib/io/argparse.lisp:238:2*

Parse `ARGS` using the argument parser defined in `SPEC`. Returns a
lookup with each argument given its value.

## `set-action`
*Defined at lib/io/argparse.lisp:37:2*

Set the appropriate key in `DATA` for `ARG` to `VALUE`.

## `set-num-action`
*Defined at lib/io/argparse.lisp:50:2*

Set the appropriate key in `DATA` for `ARG` to `VALUE`, ensuring it is a number.

## `usage!`
*Defined at lib/io/argparse.lisp:167:2*

Display a short usage for the argument parser as defined in `SPEC`.

## `usage-error!`
*Defined at lib/io/argparse.lisp:181:2*

Display the usage of `SPEC` and exit with an `ERROR` message.

