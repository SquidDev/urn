# ![](http://i.imgur.com/XqKyCMC.png) Urn [![Travis Build Status](https://travis-ci.org/SquidDev/urn.svg?branch=master)](https://travis-ci.org/SquidDev/urn) [![Build status](https://gitlab.com/SquidDev/urn/badges/master/build.svg)](https://gitlab.com/SquidDev/urn/commits/master)
## A Lisp implementation for Lua

Urn is a new language developed by me, SquidDev, and demhydraz. Urn is a Lisp dialect with a focus on minimism which
compiles to Lua.

## What is it?
Urn aims to be a minimal implementation of Lua, with full support for compile time code execution and generation. The
"core" language of Urn is composed of just a few builtins, with all other major constructs (such as variable assignment
or loops) being implemented by macros.

 - `define`, `define-macro` and `define-native` allow you to create top level definitions.
 - `quote`, `syntax-quote`, `unquote` and `unquote-splice` allow you to easily switch between code and data.
 - `lambda` creates a new function with the specified arguments and body.
 - `cond` is an `if`-`elseif` chain, executing the first body whose corresponding expression is truthy.
 - `set!` assigns an already existing variable (such as a function argument) a new value.
 - `import` will load code from another file.

See [the roadmap](https://gitlab.com/SquidDev/urn/issues/1) for some idea of where we're heading.

## Features
Powerful assertion and testing framework, ensuring your code is (generally) correct.

![](http://i.imgur.com/F3e338r.png)

Detailed parser messages, helping you find that problem as soon as possible.

![](http://i.imgur.com/RJ2fE2C.png)

## Getting started
Urn is currently hosted on [GitLab](https://gitlab.com/SquidDev/urn) and mirrored
on [GitHub](https://github.com/SquidDev/urn). You can clone the repo from either location, or download
a [zipped version](https://gitlab.com/SquidDev/urn/repository/archive.zip?ref=master).

You should just be able to execute `run.lua` to launch the REPL, or specify a series of `.lisp` files in order to
compile a set of files.

You can find some auto-generated [documentation online](https://squiddev.github.io/urn/). Hopefully this will be
expanded in the future to include tutorials and what not.
