"This library provides a series of methods for interacting with the
 internal representation of nodes."

(import core/prelude ())

(define-native visit-node
  "Visit NODE with VISITOR.

   VISITOR should be a function which accepts the current node and the
   visitor. This is called before traversing the child nodes. You can
   return false to not visit them.")

(define-native visit-nodes
  "Visit a list of NODES, starting at IDX, using the specified VISITOR.

   See [[visit-node]] for more information about the VISITOR.")

(define-native traverse-node
  "Traverse NODE with VISITOR.

   VISITOR should be a function which accepts the current node and the
   visitor. It should return the replacement node, or the current node
   if no changes should be made.")

(define-native traverse-nodes
  "Traverse a list of NODES, starting at IDX, using the specified VISITOR.

   See [[traverse-node]] for more information about the VISITOR.")

(define-native symbol->var
  "Extract the variable from the given SYMBOL.

   This will work with quasi-quoted symbols, and those from resolved
   ASTs. You should not use this on macro arguments as it will not
   return anything useful.")

(define-native var->symbol
  "Create a new symbol referencing the given VARIABLE.")

(defun fix-symbol (symbol)
  "Convert the quasi-quoted SYMBOL into a fully resolved one."
  (assert-type! symbol symbol)
  (with (var (symbol->var symbol))
    (if var
      (var->symbol var)
      (error! "Variable is not defined"))))

(define-native builtin?
  "Determine whether the specified NODE is the given BUILTIN.

   ### Example
   ```cl :no-test
   > (builtin? (symbol->var `lambda) :lambda)
   out = true
   ```")

(define-native builtin
  "Get the builtin with the given NAME.")

(define-native constant?
  "Determine whether the specified NODE is a constant.")

(define-native node->val
  "Gets the constant value of NODE.")

(define-native val->node
  "Gets the node representation of the constant VALUE.")

(define-native node-contains-var?
  "Determine whether NODE contains a reference to the given VAR.")

(define-native node-contains-vars?
  "Determine whether NODE contains a reference to any of the given VARS.

   VARS must be a struct, mapping variable names to `true`.")
