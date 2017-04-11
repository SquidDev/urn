---
title: CLI
---

# The Urn command line interface
The Urn command line interface, or CLI is used to compile and run Urn programs, as well as providing useful utilites
such as native library generation and the REPL.

The CLI can be started by executing `tacky/cli.lua` on the command line, (or `lua tacky/cli.lua` if you do not wish to
use Lua 5.3). By default this will start the REPL. In order to get more options about the CLI, you can run it using the
`--help` flag. This will detail the various options that the CLI provides.

## General purpose arguments
Urn has a series of general arguments which can be useful in debugging situations.

 - `--verbose`, `-v`: This specifies the verbosity of the CLI. The flag can be used multiple times, with each usage
   resulting in more messages being displayed.
 - `--time`, `-t`: This specifies the verbosity of timing information. This can be used multiple times: used once, only
   separate stages are times (parsing, optimising, etc...). When used twice, you will get more detailed information on
   the time taken to parse individual files, or run a specific optimisation pass.
 - `--explain`, `-e`: Specifies whether error messages should contain more information about the issue here. Whilst most
   messages do not contain explanations, those which do may help you track down the issue, or explain why your existing
   code is wrong.
 - `--wrapper`, `-w`: You may wish to launch the CLI wrapped in another command, such
   as [rlwrap](https://github.com/hanslub42/rlwrap). Using this flag with the path to an executable, will tell Urn to
   execute this program using all of Urn's arguments. For instance, `tacky/cli.lua -v --wrapper=rlwrap` will result in
   `rlwrap lua5.3 tacky/cli.lua -v --wrapper=rlwrap`.

## Specifying files
Obviously one of the things you'll want to be doing with Urn is loading files, in order to compile and run them. To do
this, just specify the files on the command line. However, you may also want to adjust some other settings:

 - `--include`, `-i`: Provide additional locations to search for. This can either be a directory or a string, where "?"
   will be replaced with the module to load. By default, the path is `("?" "?/init" "<compiler_dir>/?" "<compiler_dir>/?/init")`.
 - `--prelude`, `-p`: Provide a path to the custom prelude to use. Note that this must be relative to the current
   directory: it does not look it up on the library path.
 - `--plugin`: Specify a custom compiler plugin to load. This is loaded as a normal file, but it expected to inject
   additional data in a top level unquote.

## Processing files
Urn will run several processing steps on your files before running/compiling them. Firstly the compiler runs "warning
tests:" a couple of functions which check your code for possible bugs. Then it will optimise your code: stripping unused
symbols, folding constants, and more. However, these features do take substantial amounts of time on large files -
optimising the Urn compiler takes 3 seconds on my machine. Therefore, you may wish to disable certain features.

Both optimisations and warnings are configured with the same system, the former with `--optimise` (and `-O`), the latter
being configured with `--warning` and `-W`. In the following section, replace "optimise" with "warning" where
applicable.

 - `--optimise=<n>`: Specify a given optimisation level. A higher level means more optimisations will be run, though may
   take longer. Setting it to 0 means optimisation will not occur.
 - `--optimise=+<pass>`: Enable an optimisation pass or category. Some optimisations, such as function inlining are
   disabled by default - this can be used to enable it.
 - `--optimise=-<pass>`: Disable an optimisation pass or category. For instance, to disable all passes which depend on
   usage information, use `--optimise=-usage`.

I generally use the shorter argument form instead, for instance: `-O+inline` to enable function inlining.

### Optimisation specific arguments
There are also several optimisation specific flags, which control how long the optimiser will run for:

 - `--optimise-n`, `--optn`: Set the maximum number of "iterations" the optimiser runs for. By default, the compiler
   will run all passes until nothing else needs doing, or 10 iterations have been performed. This flag changes the
   number of iterations, controlling how effective optimisation is at the cost of compilation speed.  -- `--optimise-t`,
   `--optt`: Set the maximum amount of time optimisation will run for. Note that the optimiser will always run for
   longer than the given time: it will only stop when it has gone over the time limit.

## Compiling files
By default, Urn will emit a file named `out.lua` and exit. However, various command arguments provide a little more
flexibility in the output.

 - `--output`, `--out`, `-o`: The file to output to. Note that this *should not* include the `.lua` file extension.
 - `--shebang`: Add a shebang to the top of the emitted file, using the current Lua interpreter.
 - `--chmod`: `chmod +x` the produced file, especially useful in tandem with `--shebang`.

Urn also allows emitting files in other formats, such as a fully expanded Lisp, and generating documentation.

 - `--emit-lisp`: Produce a lisp file, using the name given by the `--output` argument (so `--output=foo` will produce
   `foo.lisp`).
 - `--docs`: Specify a folder in which to place the generated documentation. Each file provided to `tacky/cli.lua` will
   produce one markdown file in the specified directory. Note that this will not create the directory: you have to do
   that yourself.
