---
title: extra/argparse
---
# extra/argparse
An argument parsing library.

You specify the arguments for this parser, and the arg parser will handle parsing
and documentation generation.

The parser is created with [`create`](lib.extra.argparse.md#create-description) and arguments can be added with [`add-argument!`](lib.extra.argparse.md#add-argument-spec-names-options). Should you want
the parser to handle `--help` and friends, you should call [`add-help!`](lib.extra.argparse.md#add-help-spec). Once the parser is 'built', you
can parse inputs with [`parse!`](lib.extra.argparse.md#parse-spec-args)

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

## `(add-action arg data value)`
*Defined at lib/extra/argparse.lisp:41:1*

Append `VALUE` to the appropriate key in `DATA` for `ARG`.

## `(add-argument! spec names &options)`
*Defined at lib/extra/argparse.lisp:57:1*

Add a new argument to `SPEC`, using the specified `NAMES`.

`OPTIONS` is composed of a key followed by the corresponding value. The following options
are valid:

 - `:name`:    The name to store the result in. Defaults to the first item given in `NAMES`.
 - `:narg`:    The number of arguments to consume. This can be any number, '+', '*' or '?'. Defaults to 0 if the first `:name` starts with `-`, otherwise `*`.
 - `:default`: The default value to use. Defaults to `false`.
 - `:value`:   The value to use if this is used without an argument (such as a flag). Defaults to `true`.
 - `:help`:    The description text to display when using this.
 - `:var`:     The variable name to show in help files. Defaults to `:name`.
 - `:action`:  The action to execute when this option is used. Must be a function which takes three arguments: current arg, data and value.
 - `:many`:    Whether you can specify this argument multiple times.
 - `:all`:     Whether this will consume all values, including those starting with `-`.

## `(add-help! spec)`
*Defined at lib/extra/argparse.lisp:126:1*

Add a help argument to `SPEC`.

This will show the help message whenever --help or -h is used and then quit the program.

## `(create description)`
*Defined at lib/extra/argparse.lisp:28:1*

Create a new argument parser

## `(help! spec name)`
*Defined at lib/extra/argparse.lisp:167:1*

Display the help for the argument parser as defined in `SPEC`.

## `(parse! spec args)`
*Defined at lib/extra/argparse.lisp:204:1*

Parse `ARGS` using the argument parser defined in `SPEC`. Returns a lookup with each argument given its value.

## `(set-action arg data value)`
*Defined at lib/extra/argparse.lisp:37:1*

Set the appropriate key in `DATA` for `ARG` to `VALUE`.

## `(set-num-action aspec data value usage!)`
*Defined at lib/extra/argparse.lisp:50:1*

Set the appropriate key in `DATA` for `ARG` to `VALUE`, ensuring it is a number.

## `(usage! spec name)`
*Defined at lib/extra/argparse.lisp:147:1*

Display a short usage for the argument parser as defined in `SPEC`.

## `(usage-error! spec name error)`
*Defined at lib/extra/argparse.lisp:161:1*

Display the usage of `SPEC` and exit with an `ERROR` message.

