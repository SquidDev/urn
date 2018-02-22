(import urn/logger/void logger)
(import urn/library ())
(import urn/range ())
(import urn/resolve/builtins builtins)
(import urn/resolve/scope scope)
(import urn/resolve/native native)
(import urn/timer timer)
(import urn/traceback traceback)

(import lua/basic (type#))
(import lua/basic b)

(define start-range
  "The default range for all objects"
  :hidden
  (mk-range "init.lisp"
            (mk-position 1 1 1)
            (mk-position 1 1 1)
            '(";; Empty")))

(defun wrap-node (node)
  "Wraps a NODE, converting it into something usable for resolution."
  (case (type# node)
    ["number" { :tag "number" :value node :range start-range }]
    ["string" { :tag "string" :value node :range start-range }]
    ["table"
     (.<! node :range start-range)
     (when (list? node)
       (for i 1 (n node) 1
         (.<! node i (wrap-node (nth node i)))))
     node]))

(defun native-expr (data)
  (with (native (native/native))
    (native/set-native-pure! native (.> data :pure))

    (native/set-native-syntax! native (.> data :contents))
    (native/set-native-syntax-arity! native (.> data :count))
    (native/set-native-syntax-precedence! native (.> data :prec))
    (native/set-native-syntax-fold! native (.> data :fold))

    native))

(defun native-var (name)
  (with (native (native/native))
    (native/set-native-bind-to! native name)
    native))

(defun create-compiler ()
  "Create a new compilation state, with some basic variables already defined."
  (let* [(scope (builtins/create-scope "top-level"))
         (libs (library-cache))
         (compiler { :log           logger/void
                     :timer         (timer/void)
                     :libs          libs

                     :root-scope    scope
                     :exec          (lambda (func) (list (xpcall func traceback/traceback)))
                     :variables     {}
                     :states        {}
                     :global        (b/setmetatable {} { :__index b/_G })
                     :compile-state { :mappings {} }

                     :loader        (lambda (name) (format 0 "Cannot load external module {#name:string/quoted}")) })]

    ;; Setup meta definitions
    (set-library-cache-meta! libs :+       (native-expr { :contents '(1 " + " 2)   :count 2 :fold "left"  :prec 9 :pure true }))
    (set-library-cache-meta! libs :-       (native-expr { :contents '(1 " - " 2)   :count 2 :fold "left"  :prec 9 :pure true }))
    (set-library-cache-meta! libs :..      (native-expr { :contents '(1 " .. " 2)  :count 2 :fold "right" :prec 8 :pure true }))
    (set-library-cache-meta! libs :=       (native-expr { :contents '(1 " == " 2)  :count 2               :prec 3 :pure true }))
    (set-library-cache-meta! libs :>=      (native-expr { :contents '(1 " >= " 2)  :count 2               :prec 3 :pure true }))
    (set-library-cache-meta! libs :get-idx (native-expr { :contents '(1 "[" 2 "]") :count 2               :prec '(100 0) }))
    (set-library-cache-meta! libs :print   (native-var "print"))

    ;; Setup main definitions
    (for-each name '("foo" "bar" "baz" "qux" "+" "-" ".." "=" ">=" "get-idx" "print")
      (with (var (scope/add! scope name "native"))
        (when-with (native (library-cache-meta libs name))
          (scope/set-var-native! var native))))

    (for-pairs (_ var) (scope/scope-variables (scope/scope-parent scope)) (.<! compiler :variables (tostring var) var))
    (for-pairs (_ var) (scope/scope-variables scope) (.<! compiler :variables (tostring var) var))

    compiler))

(defun tracking-logger ()
  "A logger which tracks error messages."
  (let* [(errors '())
         (warnings '())
         (discard (lambda ()))
         (pusher  (lambda (out)
                    (lambda (logger msg source explain lines)
                      (with (buffer (list msg))
                        (for i 2 (n lines) 2
                          (with (line (nth lines i))
                            (when (/= line "") (push! buffer line))))
                        (push! out (concat buffer "\n"))))))]

    { :put-error!   (lambda (self msg) (push! errors msg))
      :put-warning! (lambda (self msg) (push! warnings msg))
      :put-verbose! discard
      :put-debug!   discard
      :put-time!    discard

      :put-node-error!   (pusher errors)
      :put-node-warning! (pusher warnings)

      :errors            errors
      :warnings          warnings }))
