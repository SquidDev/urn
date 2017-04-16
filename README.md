# ![](https://i.imgur.com/XqKyCMC.png) Urn [![Travis Build Status](https://travis-ci.org/SquidDev/urn.svg?branch=master)](https://travis-ci.org/SquidDev/urn) [![Build status](https://gitlab.com/urn/urn/badges/master/build.svg)](https://gitlab.com/urn/urn/commits/master)

Urn is a new language developed by SquidDev, and demhydraz. Urn is a Lisp dialect with a focus on minimalism which
compiles to Lua.

## What?
 - A minimal Lisp implementation, with full support for compile time code execution and macros.
 - Support for Lua 5.1, 5.2 and 5.3. Should also work with LuaJIT.
 - Lisp-1 scoping rules (functions and data share the same namespace).
 - Influenced by a whole range of Lisp implementations, including Common Lisp and Clojure.
 - Produces standalone, optimised Lua files: no dependencies on a standard library.

## Features
### Pattern matching
![](https://squiddev.github.io/urn/images/example-case.png)

### Various looping constructs
![](https://squiddev.github.io/urn/images/example-loop.png)

### Powerful assertion and testing framework
![](https://squiddev.github.io/urn/images/example-assert.png)

### First-class support for Lua tables
![](https://squiddev.github.io/urn/images/example-struct.png)

### Friendly error messages
![](https://squiddev.github.io/urn/images/example-error.png)

## Getting started
We have a [getting started guide](https://squiddev.github.io/urn/tutorial/01-introduction.html) to help you get set up. Or
you can [clone the repo](https://gitlab.com/urn/urn) and jump right in!

The website also
contains [documentation for all functions and macros](https://squiddev.github.io/urn/docs/lib.prelude.html), should you
need to check how something works.
