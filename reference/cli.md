---
title: CLI
---

# The Urn command line interface
{:.no_toc}

The Urn command line interface, or CLI is used to compile and run Urn programs, as well as providing useful utilities
such as native library generation and the REPL.

The CLI can be started by executing `tacky/cli.lua` on the command line, (or `lua tacky/cli.lua` if you do not wish to
use Lua 5.3). By default this will start the REPL. In order to get more options about the CLI, you can run it using the
`--help` flag. This will detail the various options that the CLI provides.

* TOC
{:toc}

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

## Running files
Whilst you can run the generated file using the Lua interpreter, it is often nicer to run it directly from the Urn
CLI. Along with being slightly easier, you get additional features such as a built in profiler and error message
line-mapping.

 - `--run`, `-r`: Run the compiled source.
 - `--profile`, `-p`: Run the compiled source with the specified profiler, defaulting to the stack profiler if none is
   given.
 - You can also use `--` to provide arguments for compiled program: anything after this will be passed to the compiled
   program. For instance, `tacky/cli.lua foo.lisp --run -- 2 3` will run `foo.lisp` with `2` and `3` as arguments.

There are two profiling modes you can use with the `--profile` flag:

 - `call`: This monitors how long each function takes to execute, along with counting how many times every function is
   called. This has a large overhead, but is useful for getting detailed information on the whole program.
 - `stack`: This will randomly sample the call stack every 10,000 instructions. This allows you to get a rough measure
   of what proportion of time is spent within a given function, as well as what functions call what.

### The stack profiler
Whilst the call profiler is very simple to use, the stack profiler provides several other configuration options.

 - `--stack-show`: This determines the output format to use.
   - `term` will display a tree on the console, with each nested function being indented an additional level.
   - `flame` will produce an output suitable for consumption
     with [FlameGraph](https://github.com/brendangregg/FlameGraph). This can then be piped directly to the
     `flamegraph.pl` command: `tacky/cli --profile=stack --stack-show=flame | flamegraph.pl > out.svg`.
 - `--stack-kind`: By default the stack profiler will use a forward stack: showing what functions call what. If you use
   `--stack-kind=reverse`, you can compute a reverse stack: showing what functions are called by what. This allows you
   to see what calls a frequently called function, and so eliminate it.
 - `--stack-limit`: You may wish to limit the maximum depth of a call stack, you can specify that here. When using the
   reverse stack kind, I recommend setting this on a relatively low number (such as 5).
 - `--stack-fold`: When working with tree traversal (or other recursive functions), your call stack gets increasingly
   hard to understand. This flag will fold recursive function "loops" into themselves. For instance, `foo -> bar -> foo
   -> baz` will get folded into: `foo -> bar` and `foo -> baz`.

## The REPL
 - `--repl`: Launch an interactive session, as detailed in [the main REPL documentation](repl.md).
 - `--exec`: Read a program from stdin and execute it, displaying the result.
