(import urn/analysis/nodes (builtins))
(import urn/analysis/pass (run-pass))
(import urn/analysis/tag/categories cat)
(import urn/backend/lua/escape ())
(import urn/backend/writer w)

(import string)

(defun truthy? (node)
  "Determine whether NODE is true. A more comprehensive implementation exists in the optimiser"
  :hidden
  (and (symbol? node) (= (.> builtins :true) (.> node :var))))

(define boring-categories
  "A lookup of all 'boring' which we will not emit node information for."
  (const-struct
    ;; Constant nodes
    :const true :quote true
    ;; Branch nodes
    :not true :cond true))

(defun compile-quote (node out state level)
  "Compile a quoted NODE to the ouput buffer OUT.

   If the LEVEL is nil then we are compiling `quote`s, otherwise it determines how deep
   we are down this rabbit hole of `syntax-quote`."
  :hidden
  (if (= level 0)
    (compile-expression node out state)
    (with (ty (type node))
      (cond
        [(= ty "string") (w/append! out (string/quoted (.> node :value)))]
        [(= ty "number") (w/append! out (number->string (.> node :value)))]
        [(= ty "symbol")
         (w/append! out (.. "({ tag=\"symbol\", contents=" (string/quoted (.> node :contents))))
         (when (.> node :var)
           (w/append! out (.. ", var=" (string/quoted(number->string (.> node :var))))))
         (w/append! out "})")]
        [(= ty "key")
         (w/append! out (string/.. "({tag=\"key\", value=" (string/quoted (.> node :value)) "})"))]
        [(= ty "list")
         (with (first (car node))
           (cond
             [(and (symbol? first) (or (= (.> first :var) (.> builtins :unquote)) (= (.> :var) (.> builtins :unquote-splice))))
              (compile-quote (nth node 2) out state (and level (pred level)))]
             [(and (symbol? first) (= (.> first :var) (.> builtins :syntax-quote)))
              (compile-quote (nth node 2) out state (and level (succ level)))]
             [true
               (w/push-node! out node)
               (with (contains-unsplice false)
                 (for-each sub node
                   (when (and (list? sub) (symbol? (car sub)) (= (.> sub 1 :var) (.> builtins :unquote-splice)))
                     (set! contains-unsplice true)))
                 (if contains-unsplice
                   (with (offset 0)
                     ;; If we have an unsplice then we have to compile it as a block
                     (w/begin-block! out "(function()")
                     (w/line! out "local _offset, _result, _temp = 0, {tag=\"list\",n=0}")
                     (for i 1 (# node) 1
                       (with (sub (nth node i))
                         (if (and (list? sub) (symbol? (car sub)) (= (.> sub 1 :var) (.> builtins :unquote-splice)))
                           (progn
                             ;; Every unquote-splice subtracts one from the offset position
                             (inc! offset)

                             (w/append! out "_temp = ")
                             (compile-quote (nth sub 2) out state (pred level))
                             (w/line! out)

                             (w/line! out (string/.. "for _c = 1, _temp.n do _result[" (number->string (- i offset)) " + _c + _offset] = _temp[_c] end"))
                             (w/line! out "_offset = _offset + _temp.n"))
                           (progn
                             (w/append! out (string/.. "_result[" (number->string (- i offset)) " + _offset] = "))
                             (compile-quote sub out state level)
                             (w/line! out)))))
                     (w/line! out (.. "_result.n = _offset + " (number->string (- (# node) offset))))
                     (w/line! out "return _result")
                     (w/end-block! out "end)()"))
                   (progn
                     (w/append! out (.. "({tag = \"list\", n = " (number->string (# node))))
                     (for-each sub node
                               (w/append! out ", ")
                               (compile-quote sub out state level))
                     (w/append! out "})"))))
               (w/pop-node! out node)]))]
        (true (error! (.. "Unknown type " ty)))))))

(defun compile-expression (node out state ret)
  :hidden
  (let* [(cat-lookup (.> state :cat-lookup))
         (cat (.> cat-lookup node))
         (_ (unless cat
              (import urn/range r)
              (print! "Cannot find" (pretty node) (r/format-node node))))
         (cat-tag (.> cat :category))]
    (unless (.> boring-categories cat-tag) (w/push-node! out node))
    (case cat-tag
      ["const" (unless (= ret "")
                 (when ret (w/append! out ret))
                 (cond
                   [(symbol? node) (w/append! out (escape-var (.> node :var) state))]
                   [(string? node) (w/append! out (string/quoted (.> node :value)))]
                   [(number? node) (w/append! out (number->string (.> node :value)))]
                   [(key? node) (w/append! out (string/quoted (.> node :value)))] ;; TODO: Should this be a table instead? If so, can we make this more efficient?
                   [true (error! (.. "Unknown type: " (type node)))]))]

      ["lambda"
       (unless (= ret "")
         (when ret (w/append! out ret))
         (let* [(args (nth node 2))
                (variadic nil)
                (i 1)]

           ;; Build the argument list, looking for variadic arguments.
           ;; We stop when we find one: after all, we can't emit successive args
           (w/append! out "(function(")
           (while (and (<= i (# args)) (! variadic))
             (when (> i 1) (w/append! out ", "))
             (with (var (.> args i :var))
               (if (.> var :isVariadic)
                 (progn
                   (w/append! out "...")
                   (set! variadic i))
                 (w/append! out (escape-var var state))))
             (inc! i))
           (w/begin-block! out ")")

           (when variadic
             (with (args-var (escape-var (.> args variadic :var) state))
               (if (= variadic (# args))
                 ;; If it is the last argument then just pack it up into a list
                 (w/line! out (string/.. "local " args-var " = _pack(...) " args-var ".tag = \"list\""))
                 (with (remaining (- (# args) variadic))
                   ;; Otherwise everything is a tad more complicated. We first store the number
                   ;; of arguments to add to our variadic, as well as predeclaring all args
                   (w/line! out (.. "local _n = _select(\"#\", ...) - " (number->string remaining)))

                   (w/append! out (.. "local " args-var))
                   (for i (succ variadic) (# args) 1
                     (w/append! out ", ")
                     (w/append! out (escape-var (.> args i :var) state)))
                   (w/line! out)

                   (w/begin-block! out "if _n > 0 then")
                   ;; If we have something to insert into the variadic area then we pack and unpack
                   ;; the section. It might be more efficient to pack it and append/assign to the various
                   ;; regions, but that can be profiled later.
                   (w/append! out args-var)
                   (w/line! out " = { tag=\"list\", n=_n, _unpack(_pack(...), 1, _n)}")

                   (for i (succ variadic) (# args) 1
                     (w/append! out (escape-var (.> args i :var) state))
                     (when (< i (# args)) (w/append! out ", ")))
                   (w/line! out " = select(_n + 1, ...)")

                   (w/next-block! out "else")
                   ;; Otherwise we'll just assign an empt list to the variadic and pass the ... to the
                   ;; remaining args
                   (w/append! out args-var)
                   (w/line! out " = { tag=\"list\", n=0}")

                   (for i (succ variadic) (# args) 1
                     (w/append! out (escape-var (.> args i :var) state))
                     (when (< i (# args)) (w/append! out ", ")))
                   (w/line! out " = ...")

                   (w/end-block! out "end")))))
           (compile-block node out state 3 "return ")
           (w/unindent! out)
           (w/append! out "end)")))]

      ["cond"
       (let [(closure (! ret))
             (had-final false)
             (ends 1)]

         ;; If we're being used as an expression then we have to wrap as a closure.
         (when closure
           (w/begin-block! out "(function()")
           (set! ret "return "))

         (with (i 2)
           (while (and (! had-final) (<= i (# node)))
             (let* [(item (nth node i))
                    (case (nth item 1))
                    (is-final (truthy? case))]

               ;; If we're the last block and there isn't anything here, then don't emit an
               ;; else
               (when (and (> i 2) (or (! is-final) (/= ret "") (/= (# item) 1)))
                 (w/append! out "else"))

               ;; We stop iterating after a branch marked "true" and just invoke the code.
               (cond
                 [is-final (when (= i 2) (w/append! out "do"))] ;; TODO: Could we dec! the ends variable instead?
                 [(.> cat-lookup case :stmt)
                  ;; We flatten if statements branching on an if by declaring a temp variable
                  ;; and assigning the branch result to it.
                  ;; If we're not the first condition then we also have to indent everything once.
                  ;; A further enhancement would be to detect or and and patterns and convert them
                  ;; to the relevant expression.
                  (when (> i 2)
                    (w/indent! out)
                    (w/line! out)
                    (inc! ends))
                  (with (tmp (escape-var (struct :name "temp") state))
                    (w/line! out (.. "local " tmp))
                    (compile-expression case out state (.. tmp " = "))
                    (w/line! out)
                    (w/line! out (.. "if " tmp " then")))]
                 [true
                   (w/append! out "if ")
                   (compile-expression case out state)
                   (w/append! out " then")])

               (w/indent! out) (w/line! out)
               (compile-block item out state 2 ret)
               (w/unindent! out)

               (when is-final
                 (set! had-final true))
               (inc! i))))

         ;; If we didn't hit a true branch then we should error at runtime
         (unless had-final
           (w/append! out "else")
           (w/indent! out) (w/line! out)
           (w/append! out "_error(\"unmatched item\")")
           (w/unindent! out) (w/line! out))

         ;; End each nested block
         (for i 1 ends 1
           (w/append! out "end")
           (when (< i ends) (w/unindent! out) (w/line! out)))

         ;; And finish of the closure if required
         (when closure
           (w/line! out)
           (w/end-block! out "end)()")))]

      ["not"
       (if ret
         (set! ret (.. ret "not "))
         (w/append! out "not "))

       (compile-expression (car (nth node 2)) out state ret)]

      ["or"
       (when ret (w/append! out ret))
       (w/append! out "(")
       (with (len (# node))
         (for i 2 len 1
           (when (> i 2) (w/append! out " or "))
           (compile-expression (nth (nth node i) (if (= i len) 2 1)) out state)))
       (w/append! out ")")]

      ["or-lambda"
       (when ret (w/append! out ret))
       (w/append! out "(")
       (compile-expression (nth node 2) out state)
       (let* [(branch (.> (nth (car node) 3)))
              (len (# branch))]
         (for i 3 len 1
           (w/append! out " or ")
           (compile-expression (nth (nth branch i) (if (= i len) 2 1)) out state)))
       (w/append! out ")")]

      ["and"
       (when ret (w/append! out ret))
       (w/append! out "(")
       (compile-expression (nth (nth node 2) 1) out state)
       (w/append! out " and ")
       (compile-expression (nth (nth node 2) 2) out state)
       (w/append! out ")")]

      ["and-lambda"
       (when ret (w/append! out ret))
       (w/append! out "(")
       (compile-expression (nth node 2) out state)
       (w/append! out " and ")
       (compile-expression (nth (nth (nth (car node) 3) 2) 2) out state)
       (w/append! out ")")]

      ["set!"
       (compile-expression (nth node 3) out state (.. (escape-var (.> node 2 :var) state) " = "))
       (when (and ret (/= ret ""))
         (w/line! out)
         (w/append! out ret)
         (w/append! out "nil"))]

      ;; This is a rather hacky "special form" of call-lambda which gets compiled to a
      ;; table constructor.
      ["make-struct"
       (when ret (w/append! out ret))
       (w/append! out "{")
       (with (body (car node))
         (for i 3 (pred (# body)) 1
           (when (> i 3) (w/append! out ","))
           (with (entry (nth body i))
             (w/append! out "[")
             (compile-expression (nth entry 3) out state)
             (w/append! out "]=")
             (compile-expression (nth entry 4) out state))))
       (w/append! out "}")]

      ["define"
       (compile-expression (nth node (# node)) out state (.. (escape-var (.> node :defVar) state) " = "))]

      ["define-native"
       (let* [(meta (.> state :meta (.> node :defVar :fullName)))
              (ty (type meta))]
         (cond
           [(= ty "nil")
            ;; Otherwise just copy it from the normal value
            (w/append! out (string/format "%s = _libs[%q]" (escape-var (.> node :defVar) state) (.> node :defVar :fullName)))]

           [(= ty "var")
            ;; Create an alias to a variable
            (w/append! out (string/format "%s = %s" (escape-var (.> node :defVar) state) (.> meta :contents)))]

           [(or (= ty "expr") (= ty "stmt"))
            ;; Generate a custom function wrapper
            (with (count (.> meta :count))
              (w/append! out (string/format "%s = function(" (escape-var (.> node :defVar) state)))
              (for i 1 count 1
                (unless (= i 1) (w/append! out ", "))
                (w/append! out (.. "v" (string->number i))))
              (w/append! out ") ")

              ;; Return the value if required
              (when (= ty "expr") (w/append! out "return "))

              ;; And create the template
              (for-each entry (.> meta :contents)
                (if (number? entry)
                  (w/append! out (.. "v" (string->number entry)))
                  (w/append! out entry)))

              (w/append! out " end"))]))]

      ["quote"
       ;; Quotations are "pure" so we don't have to emit anything
       (unless (= ret "")
         (when ret (w/append! out ret))
         (compile-quote (nth node 2) out state))]

      ["syntax-quote"
       ;; Sadly syntax-quotes may have a side effect so we have to emit
       ;; even if it will be discarded. A future enhancement would be to pass the
       ;; return off to the quote emitter and it can decide there
       (cond
         [(= ret "") (w/append! out "local _ =")]
         [ret (w/append! out ret)]
         [true])
       (compile-quote (nth node 2) out state 1)]

      ["import"
       ;; Imports don't do anything at all (and should have be stripped by the optimiser)
       ;; so we handle the return expression if required.
       (cond
         [(= ret nil) (w/append! out "nil")]
         [(/= ret "")
          (w/append! out ret)
          (w/append! out "nil")]
         [true])]

      ["call-symbol"
       (with (head (car node))
         ;; As we're invoking a known symbol here, we can do some fancy stuff. In this case, we just
         ;; "inline" anything defined in library meta data (such as arithmetic operators).
         (let* [(meta (and (symbol? head) (= (.> head :var :tag) "native") (.> state :meta (.> head :var :fullName))))
                (meta-ty (type meta))]
           ;; Obviously metadata only exists for native expressions. We can only emit it if
           ;; we're in the right context (statements cannot be emitted when we require an expression) and
           ;; we've passed in the correct number of arguments.
           (cond
             [(= meta-ty "nil")]
             [(= meta-ty "boolean")]
             [(= meta-ty "expr")]
             [(= meta-ty "stmt")
              ;; Cannot use statements if we're in an expression
              (unless ret (set! meta nil))]
             [(= meta-ty "var")
              ;; We'll have cached the global lookup above
              (set! meta nil)])

           (if (and meta (= (pred (# node)) (.> meta :count)))
             (progn
               ;; If we're dealing with an expression then we emit the returner first. Statements just
               ;; return nil.
               (when (and ret (= (.> meta :tag) "expr"))
                 (w/append! out ret))

               ;; Emit all entries. Numbers represent an argument, everything else is just
               ;; appended directly.
               (with (contents (.> meta :contents))
                 (for i 1 (# contents) 1
                   (with (entry (nth contents i))
                     (if (number? entry)
                       (compile-expression (nth node (succ entry)) out state)
                       (w/append! out entry)))))

               ;; If we're dealing with a statement then return nil.
               (when (and (/= (.> meta :tag) "expr") (/= ret ""))
                 (w/line! out)
                 (w/append! out ret)
                 (w/append! out "nil")
                 (w/line! out)))
             (progn
               ;; Alas, just emit as normal
               (when ret (w/append! out ret))
               (compile-expression head out state)
               (w/append! out "(")
               (for i 2 (# node) 1
                 (when (> i 2) (w/append! out ", "))
                 (compile-expression (nth node i) out state))
               (w/append! out ")")))))]

      ["wrap-value"
       (when ret (w/append! out ret))
       (w/append! out "(")
       (compile-expression (nth node 2) out state)
       (w/append! out ")")]

      ["call-lambda"
       ;; If we have a direction invokation of a function then inline it
       (when (= ret nil)
         (print! (pretty node) " marked as call-lambda for " ret))
       (let* [(head (car node))
              (args (nth head 2))
              (offset 1)]
         (for i 1 (# args) 1
           (let* [(var (.> args i :var))
                  (esc (escape-var var state))]
             (w/append! out (.. "local " esc))
             (if (.> var :isVariadic)
               ;; If we're variadic then create a list of each sub expression
               (with (count (- (# node) (# args)))
                 (when (< count 0) (set! count 0))

                 (if (or (<= count 0) (atom? (nth node (+ i count))))
                   (progn
                     ;; Emit each expression into the list.
                     ;; A future enhancement might be to check if these are statements and, if so, push it
                     (w/append! out " = { tag=\"list\", n=")
                     (w/append! out (number->string count))

                     (for j 1 count 1
                       (w/append! out ", ")
                       (compile-expression (nth node (+ i j)) out state))
                     (w/line! out "}"))
                   (progn
                     ;; Emit eaach element into a call of table.pack
                     (w/append! out " = _pack(")
                     (for j 1 count 1
                       (when (> j 1) (w/append! out ", "))
                       (compile-expression (nth node (+ i j)) out state))
                     (w/line! out ")")
                     (w/line! out (.. esc ".tag = \"list\""))))

                 (set! offset count))
               (let* [(expr (nth node (+ i offset)))
                      (name (escape-var var state))
                      (ret nil)]
                 (if expr
                   (progn
                     (if (.> cat-lookup expr :stmt)
                       (progn
                         (set! ret (.. name " = "))
                         (w/line! out))
                       (w/append! out " = "))
                     (compile-expression expr out state ret)
                     (w/line! out))
                   (w/line! out))))))

         ;; Emit all arguments which haven't been used anywhere
         (for i (+ (# args) (+ offset 1)) (# node) 1
              (compile-expression (nth node i) out state "")
              (w/line! out))

         (compile-block head out state 3 ret))]
      ["call-literal"
       ;; Just invoke the expression as normal
       (when ret (w/append! out ret))
       ;; If we're invoking false or something then we need to wrap it in parens.
       ;; We'll just error anyway, but I can live with that.
       (w/append! out "(")
       (compile-expression (car node) out state)
       (w/append! out ")(")
       (for i 2 (# node) 1
         (when (> i 2) (w/append! out ", "))
         (compile-expression (nth node i) out state))
       (w/append! out ")")]

      ["call"
       ;; Just invoke the expression as normal
       (when ret (w/append! out ret))
       (compile-expression (car node) out state)
       (w/append! out "(")
       (for i 2 (# node) 1
         (when (> i 2) (w/append! out ", "))
         (compile-expression (nth node i) out state))
       (w/append! out ")")])

    (unless (.> boring-categories cat-tag) (w/pop-node! out node))))

(defun compile-block (nodes out state start ret)
  "Compile a block of expressions."
  :hidden
  (for i start (# nodes) 1
    (with (ret' (if (= i (# nodes)) ret ""))
      (compile-expression (nth nodes i) out state ret'))
    (w/line! out)))

(defun prelude (out)
  "Various code to emit before everything else.

   This includes multi-version compatibility and caches some commonly used globals the compiled code will use."
  ;; Add some compat stuff
  (w/line! out "if not table.pack then table.pack = function(...) return { n = select(\"#\", ...), ... } end end")
  (w/line! out "if not table.unpack then table.unpack = unpack end")
  (w/line! out "local load = load if _VERSION:find(\"5.1\") then load = function(x, n, _, env) local f, e = loadstring(x, n) if not f then error(e, 2) end if env then setfenv(f, env) end return f end end")

  ;; And cache some useful globals
  (w/line! out "local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error"))

(defun expression (node out state ret)
  "Tag NODE and compile it."
  (run-pass cat/categorise-node state nil node (.> state :cat-lookup) (/= ret nil))
  (compile-expression node out state ret))

(defun block (nodes out state start ret)
  "Tag all NODES and compile them."
  (run-pass cat/categorise-nodes state nil nodes (.> state :cat-lookup))
  (compile-block nodes out state start ret))
