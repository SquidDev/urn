"The pass system provides a way of reading and modifying resolved trees.

 Passes are split into two categories: optimisations and warnings. The former
 should attempt to simplify code, making it more performant. Warnings attempt to
 find potential bugs or stylistic issues in your code.

 Each pass is defined and registered with [[defpass]].

 ### State
 Every pass receives a state object. This contains various bits of information
 about the current compiler. Some important fields include:

  - `:meta`: Contains information about native definitions. This is just a
    mapping of variable's full names to the information given in a `.meta.*`
    file.

  - `:libs`: A list of all loaded libraries. Each library is a struct containing
     the library's nodes (`:out`), documentation (`:docs`), display
     name (`:name`) and path (`:path`).

 ### Usage analysis
 Sometimes you will need to get the definitions or usages of a variable. Firstly
 you'll need to include `\"usage\"` in the category list in [[defpass]]. You can
 then access information about the variable by using [[var-usage]]."

(define-native defpass# :hidden)
(define-native changed!# :hidden)

(define-macro defpass
  "Define and register a pass with the given NAME, taking the specified ARGS
   which executes the given BODY.

   ARGS will be given a state object, a list of nodes and any context specific
   arguments.

   BODY can contain key-value pairs (like [[struct]]) which will be set as
   options for this pass. You should specify the following values:

    - `:cat`: A quoted list of categories for this pass. For optimisations, you
      should include `\"opt\"`, for warnings you should include `\"warn\"`. If
      your pass depends on the usage analyser, you should also include
      `\"usage\"`.

   - `:level`: The optimisation level this requires. By default passes exist on
      level 0.

    - `:on`: Whether this optimisation is enabled by default, or requires a
      flag. By default passes are enabled.

   Inside the BODY you can call [[changed!] to mark this pass as modifying
   something. Passes should only be executed with [[run-pass]]."
  defpass#)

(define-macro changed!
  "Mark this pass as having a side effect."
  changed!#)

(define-native var-usage
  "Get usage information about the specified VAR. This returns a struct containing:

    - `:defs`: A list of all definitions. Each definition is a struct containing
      its type (`:tag`), the defining node `(:node`) and corresponding
      value (`:value`). Node that not all definitions have a value.

    - `:usages`: A list of most usages. This does not include usages from nodes
      which are considered \"dead\".")
