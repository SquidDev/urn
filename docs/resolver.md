# Resolver planning
The general aims of the resolver are as follows:

 - Produce as many errors as possible. What I actually mean by this is that we shouldn't stop resolving on the first
   error we find (be that in a file or top level definition). Ideally as many errors as possible should be given,
   without producing more than actually exist. For instance, all invalid arguments should be displayed, as many missing
   variables as possible should be shown.
 - Be as flexible as possible. Due to the requirement for macros to return multiple values, we need a way of splicing
   the result into arbitrary places, including the top level definition.
 - Be as usable as possible. The current system uses coroutines which vastly simplifies jumping between resolution and
   macro expansion. However, it does make the REPL implementation significantly more complex than required due to having
   to create coroutines.

The proposed solution is to convert the resolver into a task based system using continuations. If the task needs to
pause (due to a missing requirement) if will call a function marking its dependencies and the function to invoke once all
requirements have been met.

> It may be worth profiling the overhead of creating lots of temporary coroutines compared with temporary closures. One
> potential issue with the former is that many functions will not yield (as all their dependencies have been fulfilled
> already) and so there is little benefit for using coroutines over continuations.

Any "block" level element (top level, `cond` and `lambda` bodies) will create multiple tasks for each element, and merge
them back together once all have finished executing. Each of these tasks will be able to create multiple sub-tasks in
the case that the macro returns multiple elements, allowing an arbitrary number of multiple returns.

We will try to do significantly less in the top level resolver loop now. We will require a set of blocked tasks which
are awaiting on another task, and a queue of tasks which can be executed. Once the queue is empty, all blocked tasks
will have their dependencies checked and added onto the ready queue. If no items are added then we will need to detect
the problems. There are a couple of possible errors which may occur:
 - Undeclared variables. In this case we simply need to print out the failing node and continue.
 - Loop in task dependencies. This may occur when macros depend on each other, causing a loop in the resolver. We can
   simply print out this dependency chain and stop the resolver.
 - A dependency failed. This may be caused by missing variables, syntax errors, or the like. In this case we simply mark
   this task as failed and continue. The failure should propagate up the stack until the blocked set is empty.

It should be clear from the above that tasks can be in four distinct states:
 - `ready`: On the ready queue and can be executed
 - `blocked`: Waiting on one or more dependencies to finish. This is on the blocked set.
 - `failed`: The task failed. This isn't stored anywhere.
 - `done`: The task completed successfully. This isn't stored anywhere.

We will need a way of detecting duplicate tasks and merging them together. Most of the time this will not be required as
nodes are only queued once, but missing variables and requiring a top level definition may occur multiple times. We
should also consider efficient ways of detecting when a dependency has finished (such as each task having its own
`requiredFor` queue).

## Variables
One limitation with the current system is all variables are exported, including those imported from other
modules. Instead, variables data will be split between the a scope variable and definition variable. The definition
variable is simply a store of the variable name and its kind. This will be unique across the entire system and
represents a physical variable in the compiled program. The scope variable is scope specific, and is set for each place
the variable is defined and imported. As well as storing the definition variable and parent scope, it will hold
additional metadata such as visibility level. Lisp side symbols with have accesses to this usage struct at compile time
(though not runtime for obvious reasons).

## State
Due to the new top level `unquote` feature, we will need to track variable requirements for other nodes too. All nodes
will be assigned a state which is either inherited from its parent or created (in the case of top level nodes or
`unquote`s). This will simply hold the node's requirements and (in the case of definitions) its state and value.

When a node requires a variable, it must either be a top level definition or on the same level as the current
expression.
