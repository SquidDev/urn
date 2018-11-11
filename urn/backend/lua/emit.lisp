(import urn/analysis/nodes (builtin builtin? fast-any zip-args single-return?))
(import urn/analysis/pass (run-pass))
(import urn/analysis/tag/categories cat)
(import urn/analysis/tag/find-letrec find-letrec)
(import urn/backend/lua/escape ())
(import urn/backend/writer w)
(import urn/logger/format format)
(import urn/range range)
(import urn/resolve/native native)
(import urn/resolve/scope scope)

(defun create-pass-state (state)
  "Create a state for using in analysis passes and emitting."
  { ;; General information copied from the parent state.
    :var-cache  (.> state :var-cache)
    :var-lookup (.> state :var-lookup)

    ;; Pass information
    :var-skip   {} ;; Variables which we will not emit bindings for
    :cat-lookup {} ;; Node to category lookup
    :rec-lookup {} ;; Information on recursive variables
    })

(defun truthy? (node)
  "Determine whether NODE is true. A more comprehensive implementation exists in the optimiser"
  :hidden
  (builtin? node :true))

(defun sym-variadic? (sym)
  "Determine whether a symbol variable is variadic."
  :hidden
  (scope/var-variadic? (.> sym :var)))

(define break-categories
  "A lookup of all categories which handle control flow, for which the
   'break' information must be propagated to."
  :hidden
  { ;; Each branch needs its own break
    :cond true :unless true
    ;; Obviously this'll occur inside.
    :call-lambda true
    ;; We want to avoid emitting breaks here
    :call-tail true })

(define const-categories
  "A lookup of all categories which are constant/will not be emitted when
   the statement is nil."
  { :const true
    :quote true :quote-const true })

(defun compile-native-fold (out meta a b)
  :hidden
  (for-each entry (native/native-syntax meta)
    (case entry
      [1 (w/append! out a)]
      [2 (w/append! out b)]
      [string? (w/append! out entry)])))

(defun compile-native (out var meta)
  (cond
    [(native/native-bind-to meta)
     ;; Bind to a constant variable
     (w/append-with! out (native/native-bind-to meta))]

    [(native/native-syntax meta)
     ;; Generate a custom function wrapper
     (w/append! out "function(")
     (if (native/native-syntax-fold meta)
       (w/append! out "x, ...")
       (for i 1 (native/native-syntax-arity meta) 1
         (unless (= i 1) (w/append! out ", "))
         (w/append! out (.. "v" (string->number i)))))
     (w/append! out ") ")

     (case (native/native-syntax-fold meta)
       [nil
        ;; Return the value if required.
        (unless (native/native-syntax-stmt? meta)
          (w/append! out "return "))
        ;; And create the template
        (for-each entry (native/native-syntax meta)
          (if (number? entry)
            (w/append! out (.. "v" (string->number entry)))
            (w/append! out entry)))]
       ["left"
        ;; Fold values from the left.
        (w/append! out "local t = ")
        (compile-native-fold out meta "x" "...")
        (w/append! out " for i = 2, _select('#', ...) do t = ")
        (compile-native-fold out meta "t" "_select(i, ...)")
        (w/append! out " end return t")]
       ["right"
        ;; Fold values from the right.
        (w/append! out "local n = _select('#', ...) local t = _select(n, ...) for i = n - 1, 1, -1 do t = ")
        (compile-native-fold out meta "_select(i, ...)" "t")
        (w/append! out " end return ")
        (compile-native-fold out meta "x" "t")])

     (w/append! out " end")]

    [else
     ;; Just copy it from the _libs table
     (w/append! out "_libs[")
     (w/append! out (string/quoted (scope/var-unique-name var)))
     (w/append! out "]")]))

(defun compile-expression (node out state ret break)
  :hidden
  (let* [(cat-lookup (.> state :cat-lookup))
         (cat (.> cat-lookup node))
         (_ (unless cat
              (print! "Cannot find" (pretty node) (format/format-node node))))
         (cat-tag (.> cat :category))]
    (w/push-node! out node)
    (case cat-tag
      ["void"
       (unless (= ret "")
         (when ret (w/append! out ret))
         (w/append! out "nil"))]
      ["const"
       (unless (= ret "")
         (when ret (w/append-with! out ret))
         (when (.> cat :parens) (w/append! out "("))
         (cond
           [(symbol? node) (w/append-with! out (escape-var (.> node :var) state))]
           [(string? node) (w/append-with! out (string/quoted (.> node :value)))]
           [(number? node) (w/append-with! out (number->string (.> node :value)))]
           [(key? node) (w/append-with! out (string/quoted (.> node :value)))] ;; TODO: Should this be a table instead? If so, can we make this more efficient?
           [true (error! (.. "Unknown type: " (type node)))])
         (when (.> cat :parens) (w/append! out ")")))]

      ["lambda"
       (unless (= ret "")
         (when ret
          (with (pos (range/get-source node))
            (w/append! out ret (and pos (range/range-of-start pos)))))

         (let* [(args (nth node 2))
                (variadic nil)
                (i 1)]

           ;; Build the argument list, looking for variadic arguments.
           ;; We stop when we find one: after all, we can't emit successive args
           (when (.> cat :parens) (w/append! out "("))
           (w/append! out "function(")
           (while (and (<= i (n args)) (not variadic))
             (when (> i 1) (w/append! out ", "))
             (with (var (.> args i :var))
               (if (scope/var-variadic? var)
                 (progn
                   (w/append! out "...")
                   (set! variadic i))
                 (w/append! out (push-escape-var! var state))))
             (inc! i))
           (w/begin-block! out ")")

           (when variadic
             (with (args-var (push-escape-var! (.> args variadic :var) state))
               (if (= variadic (n args))
                 ;; If it is the last argument then just pack it up into a list
                 (w/line! out (.. "local " args-var " = _pack(...) " args-var ".tag = \"list\""))
                 (with (remaining (- (n args) variadic))
                   ;; Otherwise everything is a tad more complicated. We first store the number
                   ;; of arguments to add to our variadic, as well as predeclaring all args
                   (w/line! out (.. "local _n = _select(\"#\", ...) - " (number->string remaining)))

                   (w/append! out (.. "local " args-var))
                   (for i (succ variadic) (n args) 1
                     (w/append! out ", ")
                     (w/append! out (push-escape-var! (.> args i :var) state)))
                   (w/line! out)

                   (w/begin-block! out "if _n > 0 then")
                   ;; If we have something to insert into the variadic area then we pack and unpack
                   ;; the section. It might be more efficient to pack it and append/assign to the various
                   ;; regions, but that can be profiled later.
                   (w/append! out args-var)
                   (w/line! out " = {tag=\"list\", n=_n, _unpack(_pack(...), 1, _n)}")

                   (for i (succ variadic) (n args) 1
                     (w/append! out (escape-var (.> args i :var) state))
                     (when (< i (n args)) (w/append! out ", ")))
                   (w/line! out " = select(_n + 1, ...)")

                   (w/next-block! out "else")
                   ;; Otherwise we'll just assign an empt list to the variadic and pass the ... to the
                   ;; remaining args
                   (w/append! out args-var)
                   (w/line! out " = {tag=\"list\", n=0}")

                   (for i (succ variadic) (n args) 1
                     (w/append! out (escape-var (.> args i :var) state))
                     (when (< i (n args)) (w/append! out ", ")))
                   (w/line! out " = ...")

                   (w/end-block! out "end")))))

           (if (.> cat :recur)
             (compile-recur (.> cat :recur) out state "return ")
             (compile-block node out state 3 "return "))
           (w/unindent! out)
           (for-each arg args (pop-escape-var! (.> arg :var) state))
           (w/append! out "end")
           (when (.> cat :parens) (w/append! out ")"))))]

      ["cond"
       (let [(closure (not ret))
             (had-final false)
             (ends 1)]

         ;; If we're being used as an expression then we have to wrap as a closure.
         (when closure
           (w/begin-block! out "(function()")
           (set! ret "return "))

         (with (i 2)
           (while (and (not had-final) (<= i (n node)))
             (let* [(item (nth node i))
                    (case (nth item 1))
                    (is-final (truthy? case))]

               ;; If we're the last block and there isn't anything here, then don't emit an
               ;; else
               (when (and (> i 2) (or
                                    (not is-final) (/= ret "") break
                                    (and
                                      (/= (n item) 1)
                                      (fast-any (lambda (x) (not (.> const-categories (.> cat-lookup x :category)))) item 2))))
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
                  (let* [(var (scope/temp-var "temp" node))
                         (tmp (push-escape-var! var state))]
                    (w/line! out (.. "local " tmp))
                    (compile-expression case out state (.. tmp " = "))
                    (w/line! out)
                    (pop-escape-var! var state)
                    (w/line! out (.. "if " tmp " then")))]
                 [true
                   (w/append! out "if ")
                   (compile-expression case out state)
                   (w/append! out " then")])

               (w/indent! out) (w/line! out)
               (compile-block item out state 2 ret break)
               (w/unindent! out)

               (when is-final
                 (set! had-final true))
               (inc! i))))

         ;; If we didn't hit a true branch then we should error at runtime
         (unless had-final
           (w/append! out "else")
           (w/indent! out) (w/line! out)
           (with (source (range/get-source node))
             (w/append! out "_error(\"unmatched item\")" (and source (range/range-of-start source))))
           (w/unindent! out) (w/line! out))

         ;; End each nested block
         (for i 1 ends 1
           (w/append! out "end")
           (when (< i ends) (w/unindent! out) (w/line! out)))

         ;; And finish of the closure if required
         (when closure
           (w/line! out)
           (w/unindent! out)
           (w/append! out "end)()")))]

      ["unless"
       (with (closure (not ret))

         ;; If we're being used as an expression then we have to wrap as a closure.
         (when closure
           (w/begin-block! out "(function()")
           (set! ret "return "))

         (with (test (car (nth node 2)))

           (if (.> cat-lookup test :stmt)
             ;; We flatten if statements branching on an if by declaring a temp variable
             ;; and assigning the branch result to it.
             ;; If we're not the first condition then we also have to indent everything once.
             ;; A further enhancement would be to detect or and and patterns and convert them
             ;; to the relevant expression.
             (let* [(var (scope/temp-var "temp" node))
                    (tmp (push-escape-var! var state))]
               (w/line! out (.. "local " tmp))
               (compile-expression test out state (.. tmp " = "))
               (w/line! out)
               (pop-escape-var! var state)

               (if (or break (and ret (/= ret "")))
                 ;; If we have to emit a break/return statement, then all was for nought
                 (progn
                   (w/begin-block! out (format nil "if {#tmp:id} then"))
                   (compile-block (nth node 2) out state 2 ret break)
                   (w/next-block! out "else"))
                 (w/begin-block! out (format nil "if not {#tmp:id} then"))))

             (if (or break (and ret (/= ret "")))
               ;; If we have to emit a break/return statement, then all was for nought
               (progn
                 (w/append! out "if ")
                 (compile-expression test out state)
                 (w/begin-block! out " then")
                 (compile-block (nth node 2) out state 2 ret break)
                 (w/next-block! out "else"))
               (progn
                 (w/append! out "if not ")
                 (compile-expression test out state)
                 (w/begin-block! out " then"))))

           (compile-block (nth node 3) out state 2 ret break)
           (w/end-block! out "end"))

         ;; And finish of the closure if required
         (when closure
           (w/line! out)
           (w/unindent! out)
           (w/append! out "end)()")))]

      ["not"
       (when (.> cat :parens) (w/append! out "("))
       (if ret
         (set! ret (.. ret "not "))
         (w/append! out "not "))
       (compile-expression (car (nth node 2)) out state ret)
       (when (.> cat :parens) (w/append! out ")"))]

      ["or"
       (when ret (w/append! out ret))
       (when (.> cat :parens) (w/append! out "("))
       (with (len (n node))
         (for i 2 (- len 2) 1
           (compile-expression (car (nth node i)) out state)
           (w/append! out " or "))
         (case (.> cat :kind)
           ["not"
            (w/append! out "not ")
            (compile-expression (nth (nth node (pred len)) 1) out state)]
           ["and"
            (compile-expression (nth (nth node (pred len)) 1) out state)
            (w/append! out " and ")
            (compile-expression (nth (nth node (pred len)) 2) out state)]
           ["or"
            (compile-expression (nth (nth node (pred len)) 1) out state)
            (w/append! out " or ")
            (compile-expression (nth (nth node len) 2) out state)]))
       (when (.> cat :parens) (w/append! out ")"))]

      ["or-lambda"
       (when ret (w/append! out ret))
       (when (.> cat :parens) (w/append! out "("))
       (compile-expression (nth node 2) out state)
       (let* [(branch (.> (nth (car node) 3)))
              (len (n branch))]
         (w/append! out " or ")
         (for i 3 (- len 2) 1
           (compile-expression (car (nth branch i)) out state)
           (w/append! out " or "))
         (case (.> cat :kind)
           ["not"
            (w/append! out "not ")
            (compile-expression (nth (nth branch (pred len)) 1) out state)]
           ["and"
            (compile-expression (nth (nth branch (pred len)) 1) out state)
            (w/append! out " and ")
            (compile-expression (nth (nth branch (pred len)) 2) out state)]
           ["or"
            (when (> len 3)
              (compile-expression (nth (nth branch (pred len)) 1) out state)
              (w/append! out " or "))
            (compile-expression (nth (nth branch len) 2) out state)]))
       (when (.> cat :parens) (w/append! out ")"))]

      ["and"
       (when ret (w/append! out ret))
       (when (.> cat :parens) (w/append! out "("))
       (compile-expression (nth (nth node 2) 1) out state)
       (w/append! out " and ")
       (compile-expression (nth (nth node 2) 2) out state)
       (when (.> cat :parens) (w/append! out ")"))]

      ["and-lambda"
       (when ret (w/append! out ret))
       (when (.> cat :parens) (w/append! out "("))
       (compile-expression (nth node 2) out state)
       (w/append! out " and ")
       (compile-expression (nth (nth (nth (car node) 3) 2) 2) out state)
       (when (.> cat :parens) (w/append! out ")"))]

      ["set!"
       ;; If we're in an expression context wrap in a lambda
       (unless ret
         (w/begin-block! out "(function()"))

       (compile-expression (nth node 3) out state (.. (escape-var (.> node 2 :var) state) " = "))

       (cond
         [(not ret)
          ;; If we're in an expression, unwrap our lambda
          (w/line! out)
          (w/unindent! out)
          (w/append! out "end)()")]
         [(= ret "")]
         [else
          ;; Otherwise we're setting in a setter/return
          (w/line! out)
          (w/append! out ret)
          (w/append! out "nil")])
      ]

      ["struct-literal"
       (cond
         [(= ret "") (w/append! out "local _ = ")]
         [ret (w/append! out ret)]
         [true])
       (when (.> cat :parens) (w/append! out "("))
       (case (n node)
         [1
          (w/append-with! out "{}")]
         [?len
          (w/append! out "{")
          (for i 2 len 2
            (when (> i 2) (w/append! out ", "))
            (let* [(key (nth node i))
                   (tkey (type key))]
              (cond
                ;; If we're a key/string and are a valid identifier then
                ;; just emit it directly.
                [(and (or (= tkey "string") (= tkey "key"))
                      (lua-ident? (.> key :value)))
                 (w/append! out (.> key :value))
                 (w/append! out "=")]
                [else
                 (w/append! out "[")
                 (compile-expression key out state)
                 (w/append! out "]=")]))
            (compile-expression (nth node (succ i)) out state))
          (w/append! out "}")])
       (when (.> cat :parens) (w/append! out ")"))]

      ["define"
       (compile-expression (nth node (n node)) out state (.. (push-escape-var! (.> node :def-var) state) " = "))]

      ["define-native"
       (with (var (.> node :def-var))
         (w/append-with! out (string/format "%s = " (escape-var var state)))
         (compile-native out var (scope/var-native var)))]

      ["quote"
       ;; Quotations are "pure" so we don't have to emit anything
       (unless (= ret "")
         (when ret (w/append! out ret))
         (when (.> cat :parens) (w/append! out "("))
         (compile-expression (nth node 2) out state)
         (when (.> cat :parens) (w/append! out ")")))]

      ["quote-const"
       (unless (= ret "")
         (when ret (w/append! out ret))
         (when (.> cat :parens) (w/append! out "("))
         (case (type node)
           ["string" (w/append-with! out (string/quoted (.> node :value)))]
           ["number" (w/append-with! out (number->string (.> node :value)))]
           ["symbol"
            (w/append-with! out (.. "{tag=\"symbol\", contents=" (string/quoted (.> node :contents))))
            (when (.> node :var)
            (w/append-with! out (.. ", var=" (string/quoted(number->string (.> node :var))))))
            (w/append-with! out "}")]
           ["key"
            (w/append-with! out (.. "{tag=\"key\", value=" (string/quoted (.> node :value)) "}"))])
         (when (.> cat :parens) (w/append! out ")")))]

      ["quote-list"
       (cond
         [(= ret "") (w/append! out "local _ = ")]
         [ret (w/append! out ret)]
         [true])
       (case (n node)
         [0
          (w/append-with! out "{tag=\"list\", n=0}")]
         [?len
          (w/append! out (.. "{tag=\"list\", n=" (number->string len)))
          (for-each sub node
            (w/append! out ", ")
            (compile-expression sub out state))
          (w/append! out "}")])]

      ["quote-splice"
       (unless ret (w/begin-block! out "(function()"))
       (w/line! out "local _offset, _result, _temp = 0, {tag=\"list\"}")
       (with (offset 0)
         (for i 1 (n node) 1
           (let* [(sub (nth node i))
                  (cat (.> state :cat-lookup sub))]
             (unless cat
               (print! "Cannot find" (pretty sub) (format/format-node sub)))

             (if (= (.> cat :category) "unquote-splice")
               (progn
                 ;; Every unquote-splice subtracts one from the offset position
                 (inc! offset)

                 (w/append! out "_temp = ")
                 (compile-expression (nth sub 2) out state)
                 (w/line! out)

                 (with (pos (range/get-source sub))
                   (w/append! out (.. "for _c = 1, _temp.n do _result[" (number->string (- i offset)) " + _c + _offset] = _temp[_c] end")
                                  (and pos (range/range-of-start pos))))
                 (w/line! out)
                 (w/line! out "_offset = _offset + _temp.n"))
               (progn
                 (w/append! out (.. "_result[" (number->string (- i offset)) " + _offset] = "))
                 (compile-expression sub out state)
                 (w/line! out)))))
         (w/line! out (.. "_result.n = _offset + " (number->string (- (n node) offset)))))
       (cond
         [(= ret "")]
         [ret (w/append! out (.. ret "_result"))]
         [true
          (w/line! out "return _result")
          (w/end-block! out "end)()")])]

      ["syntax-quote"
       (when (.> cat :parens) (w/append! out "("))
       (compile-expression (nth node 2) out state ret)
       (when (.> cat :parens) (w/append! out ")"))]
      ["unquote" (compile-expression (nth node 2) out state ret)]
      ["unquote-splice" (fail! "Should never have explicit unquote-splice")]

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
         (when ret (w/append! out ret))
         (compile-expression head out state)
         (w/append! out "(")
         (for i 2 (n node) 1
           (when (> i 2) (w/append! out ", "))
           (compile-expression (nth node i) out state))
         (w/append! out ")"))]

      ["call-meta"
       (with (meta (.> cat :meta))
         ;; If we're dealing with an expression then we emit the returner first. Statements just
         ;; return nil.
         (unless (native/native-syntax-stmt? meta)
           (cond
             [(= ret "") (w/append! out "local _ = ")]
             [ret (w/append! out ret)]
             [true]))

         ;; Wrap in parens if required
         (when (.> cat :parens) (w/append! out "("))

         ;; Emit all entries. Numbers represent an argument, everything else is just
         ;; appended directly.
         (let* [(contents (native/native-syntax meta))
                (fold (native/native-syntax-fold meta))
                (count (native/native-syntax-arity meta))]
           (letrec [(build (lambda (start end)
                             (for-each entry contents
                               (cond
                                 [(string? entry) (w/append! out entry)]
                                 [(and (= fold "left") (= entry 1) (< start end)) (build start (pred end)) (set! start end)]
                                 [(and (= fold "right") (= entry 2) (< start end)) (build (succ start) end)]
                                 [true (compile-expression (nth node (+ entry start)) out state)]))))]
             (build 1 (- (n node) count))))

         ;; Wrap in parens if required
         (when (.> cat :parens) (w/append! out ")"))

         ;; If we're dealing with a statement then return nil.
         (when (and (native/native-syntax-stmt? meta) (/= ret ""))
           (w/line! out)
           (w/append! out ret)
           (w/append! out "nil")
           (w/line! out)))]

      ["call-recur"
       (when (= ret nil)
         (print! (pretty node) " marked as call-recur for " ret))

       (let* [(head (.> cat :recur :def))
              (args (nth head 2))]

         (compile-bind args 1 node 2 out state)

         ;; Wrap non-returning loops in an implicit lambda - this is really ugly
         ;; but it means we don't have to handle "break"s.
         (if (= ret "return ")
           (compile-recur (.> cat :recur) out state "return ")
           (compile-recur (.> cat :recur) out state ret (.> cat :recur)))

         (for-each arg args
           (unless (.> state :var-skip (.> arg :var))
             (pop-escape-var! (.> arg :var) state))))]

      ["call-tail"
       (when (= ret nil)
         (print! (pretty node) " marked as call-tail for " ret))

       (when (and break (/= break (.> cat :recur)))
         (print! (.. (pretty node) " Got a different break then defined for.\n  Expected: "  (pretty (.> cat :recur :def))
                                                                           "\n       Got: "  (pretty (.> break :def)))))

       (let* [(zipped (zip-args (cadr (.> cat :recur :def)) 1 node 2))
              (mapping (.> cat :recur :captured))
              (pack-args nil)]

         (for i (n zipped) 1 -1
           (let* [(zip (nth zipped i))
                  (args (car zip))
                  (vals (cadr zip))]
             ;; Strip all "pointless" bindings: namely ones which do not change the variable
             (cond
               [(and (= (n args) 1) (= (n vals) 1)
                     (symbol? (car vals)) (= (.> (car args) :var) (.> (car vals) :var))
                     (= (.> mapping (.> (car vals) :var)) nil))
                (remove-nth! zipped i)]

               [(any sym-variadic? args)
                (set! pack-args args)]

               [else])))

         (cond
           ;; If we've nothing to bind then emit as normal
           [(empty? zipped)]

           ;; If we've got a single node which binds no variables then just emit each expression
           [(and (= (n zipped) 1) (empty? (caar zipped)))
            (for-each val (cadar zipped)
              (compile-expression val out state "")
              (w/line! out))]

           [else
            ;; If we've got to pack some arguments, pre-declare the variable.
            ;; However, if there are no other arguments we can merge them together.
            (when (and pack-args (> (n pack-args) 1))
              (if (= (n zipped) 1)
                (w/append! out "local ")
                (w/line! out "local _p")))

            (with (first true)
              (for-each zip zipped
                (with (args (car zip))
                  (if (and (= args pack-args) (> (n args) 1))
                    (progn
                      (if first (set! first false) (w/append! out ", "))
                      (w/append! out "_p"))
                    (for-each arg (car zip)
                      (if first (set! first false) (w/append! out ", "))
                      (w/append! out (escape-var (map-var mapping (.> arg :var)) state)))))))

            (w/append! out " = ")

            (let [(first true)
                  (pack-zip nil)]
              (for-each zip zipped
                (if first (set! first false) (w/append! out ", "))

                (let [(args (car zip))
                      (vals (cadr zip))]
                  (cond
                    [(any sym-variadic? args)
                     (set! pack-zip zip)
                     (w/append! out "_pack(")
                     (for i 1 (n vals) 1
                       (when (> i 1) (w/append! out ", "))
                       (compile-expression (nth vals i) out state))
                     (w/append! out ")")]

                    [(empty? vals)
                     (w/append! out "nil")]

                    [else
                     (for i 1 (n vals) 1
                       (when (> i 1) (w/append! out ", "))
                       (compile-expression (nth vals i) out state))])))

              (w/line! out)

              (cond
                [(= pack-zip nil)]

                [(= (n (car pack-zip)) 1)
                 (w/append! out (escape-var (map-var mapping (.> (caar pack-zip) :var)) state))
                 (w/append! out ".tag = \"list\"")
                 (w/line! out)]

                [else
                 (let* [(args (car pack-zip))
                        (var-idx (find-index sym-variadic? args))]
                   ;; Set all arguments before the variadic point
                   (when (> var-idx 1)
                     (for i 1 (pred var-idx) 1
                       (when (> i 1) (w/append! out ", "))
                       (w/append! out (escape-var (map-var mapping (.> (nth args i):var)) state)))

                     (w/append! out " = ")
                     (for i 1 (pred var-idx) 1
                       (when (> i 1) (w/append! out ", "))
                       (w/append! out (string/format "_p[%d]" i)))
                     (w/line! out)))

                 (compile-bind-variadic out (car pack-zip) (cadr pack-zip) state mapping)]))]))]

      ["wrap-value"
       (when ret (w/append! out ret))
       (w/append! out "(")
       (compile-expression (nth node 2) out state)
       (w/append! out ")")]

      ["wrap-list"
       (when ret (w/append! out ret))
       (when (.> cat :parens) (w/append! out "("))

       (w/append! out "{tag=\"list\", n=")
       (w/append! out (number->string (pred (n node))))
       (for i 2 (n node) 1
         (w/append! out ", ")
         (compile-expression (nth node i) out state))
       (w/append! out "}")

       (when (.> cat :parens) (w/append! out ")"))]

      ["call-lambda"
       ;; If we have a direction invokation of a function then inline it
       (with (empty (= ret nil))
         (when empty
           (set! ret "return ")
           (w/begin-block! out "(function()"))

         (let* [(head (car node))
                (args (nth head 2))]

           (compile-bind args 1 node 2 out state)
           (compile-block head out state 3 ret break)
           (for-each arg args
             (unless (.> state :var-skip (.> arg :var))
               (pop-escape-var! (.> arg :var) state))))

         (when empty
           (w/unindent! out)
           (w/append! out "end)()")))]

      ["call"
       ;; Just invoke the expression as normal
       (when ret (w/append! out ret))
       (compile-expression (car node) out state)
       (w/append! out "(")
       (for i 2 (n node) 1
         (when (> i 2) (w/append! out ", "))
         (compile-expression (nth node i) out state))
       (w/append! out ")")])

    (w/pop-node! out node)))

(defun compile-bind (args args-start vals vals-start out state)
  "Declare a series of ARGS, bindings VALS to them."
  :hidden
  (let* [(zipped (zip-args args args-start vals vals-start))
         (zipped-n (n zipped))
         (zipped-i 1)
         (skip (.> state :var-skip))
         (cat-lookup (.> state :cat-lookup))]
    (while (<= zipped-i zipped-n)
      (let* [(zip (nth zipped zipped-i))
             (args (car zip))
             (vals (cadr zip))]
        (cond
          [(empty? args)
           ;; Emit each value on its own.
           (for-each val vals
             (compile-expression val out state "")
             (w/line! out))]

          ;; If we're variadic then emit all the complicated binding.
          ;; Note we use the same check later on in the program.
          [(or (sym-variadic? (car args))
               (and (> (n args) 1) (any sym-variadic? args)))

           (cond
             ;; We've got multiple arguments. This is going to be tricky.
             [(> (n args) 1)
              ;; Pack all the arguments together
              (w/append! out "local _p = _pack(")
              (for i 1 (n vals) 1
                (when (> i 1) (w/append! out ", "))
                (compile-expression (nth vals i) out state))
              (w/append! out ")")
              (w/line! out)

              ;; Now declare these variables
              (w/append! out "local ")
              (for i 1 (n args) 1
                (when (> i 1) (w/append! out ", "))
                (w/append! out (push-escape-var! (.> (nth args i) :var) state)))

              (with (var-idx (find-index sym-variadic? args))
                (when (> var-idx 1)
                  (w/append! out " = ")
                  ;; Set all arguments before the variadic point
                  (for i 1 (pred var-idx) 1
                    (when (> i 1) (w/append! out ", "))
                    (w/append! out (string/format "_p[%d]" i)))))
              (w/line! out)

              (compile-bind-variadic out args vals state)]

             ;; We have a fixed number of arguments & values, thus we know the length
             ;; in advance and so can emit a simple list
             [(or (empty? vals) (single-return? (last vals)))
              (w/append! out "local ")
              (w/append! out (push-escape-var! (.> (car args) :var) state))
              (w/append! out " = {tag=\"list\", n=")
              (w/append! out (number->string (n vals)))
              (for i 1 (n vals) 1
                (w/append! out ", ")
                (compile-expression (nth vals i) out state))
              (w/append! out "}")
              (w/line! out)]
             ;; We don't know how many arguments, so pass it through table.pack
             ;; and then unpack it into wherever is appropriate.
             [else
              (with (name (push-escape-var! (.> (car args) :var) state))
                (w/append! out "local ")
                (w/append! out name)
                (w/append! out " = _pack(")
                (for i 1 (n vals) 1
                  (when (> i 1) (w/append! out ", "))
                  (compile-expression (nth vals i) out state))
                (w/append! out ") ")
                (w/append! out name)
                (w/append! out ".tag = \"list\"")
                (w/line! out))])]

          ;; If we are skipping this variable then just continue
          [(and (= (n args) 1) (.> skip (.> (car args) :var)))]

          [true
           (let [(zipped-lim zipped-i)
                 (working true)]
             ;; Attempt to collapse multiple definitions into one.
             ;; We make use of several "facts" about zip-args behaviour.
             ;;  - Only the last element will bind multiple values
             ;;  - We'll only use multiple bindings if the first argument is variadic.
             (while (and working (<= zipped-lim zipped-n))
               (let* [(zip (nth zipped zipped-lim))
                      (args (car zip))
                      (vals (cadr zip))]
                 (cond
                   ;; We've got no arguments to bind to, so abort.
                   [(empty? args) (set! working false)]
                   ;; Variadic arguments are handled elsewhere as they are rather
                   ;; complicated to work with
                   [(or (sym-variadic? (car args))
                        (and (> (n args) 1) (any sym-variadic? args)))
                    (set! working false)]
                   ;; We've got a statement, so we'll have to handle that elsewhere.
                   [(and (= (n vals) 1) (.> cat-lookup (car vals) :stmt)) (set! working false)]
                   ;; Otherwise everything is dandy!.
                   [true (inc! zipped-lim)])))

             (if (= zipped-lim zipped-i)
               ;; We didn't consume any arguments, so let's just emit the first
               ;; one. It _has_ to be a single statement
               (with (esc (if (= (n args) 1)
                            (push-escape-var! (.> (car args) :var) state)
                            (with (escs '())
                              (for-each arg args
                                (push! escs (push-escape-var! (.> arg :var) state)))
                              (concat escs ", "))))
                 (unless (and (= (n vals) 1) (.> cat-lookup (car vals) :stmt))
                   (error! (.. "Expected statement, got something " (pretty zip))))

                 (w/line! out (.. "local " esc))
                 (compile-expression (car vals) out state (.. esc " = "))
                 (w/line! out))

               (with (has-val false)
                 (w/append! out "local ")
                 (with (first true)
                   (for i zipped-i (pred zipped-lim) 1
                     (let* [(zip (nth zipped i))
                            (args (car zip))
                            (vals (cadr zip))]

                       ;; Check we've got vals
                       (unless (empty? vals) (set! has-val true))

                       ;; Emit all arguments
                       (unless (and (= (n args) 1) (.> skip (.> (car args) :var)))
                         (for-each arg args
                           (if first (set! first false) (w/append! out ", "))
                           (with (var (.> arg :var))
                             (if (.> skip var)
                               (w/append! out "_")
                               (w/append! out (push-escape-var! var state)))))))))

                 (when has-val
                   (w/append! out " = ")
                   (with (first true)
                     (for i zipped-i (pred zipped-lim) 1
                       (let* [(zip (nth zipped i))
                              (args (car zip))
                              (vals (cadr zip))]
                         (unless (and (= (n args) 1) (.> skip (.> (car args) :var)))
                           (for-each val vals
                             (if first (set! first false) (w/append! out ", "))
                             (compile-expression val out state)))))))
                 (w/line! out)
                 (set! zipped-i (pred zipped-lim)))))]))
      (inc! zipped-i))))

(defun compile-bind-variadic (out args vals state mapping)
  "Compile a set of variadic ARGS and VALS.

   Note that this will not emit bindings for variables before the
   variadic: one should that that oneself."
  :hidden
  (let* [(var-idx (find-index sym-variadic? args))
         (var-esc (escape-var (map-var mapping (.> (nth args var-idx) :var)) state))
         (nargs (n args))]

    (w/line! out "local _n = _p.n")

    ;; If we've enough values, then copy them across
    (w/begin-block! out (string/format "if _n > %d then" (pred nargs)))
    (w/line! out (string/format "%s = {tag=\"list\", n=_n-%d}" var-esc (pred nargs)))
    (w/line! out (string/format "for i=%d, _n-%d do %s[i-%d]=_p[i] end"
                                var-idx (- nargs var-idx) var-esc (pred var-idx)))

    ;; And bind the remaining arguments to values after the variadic ones.
    (when (< var-idx nargs)
      (for i (succ var-idx) nargs 1
        (when (> i (succ var-idx)) (w/append! out ", "))
        (w/append! out (escape-var (map-var mapping (.> (nth args i) :var)) state)))
      (w/append! out " = ")
      (for i (succ var-idx) nargs 1
        (when (> i (succ var-idx)) (w/append! out ", "))
        (w/append! out (string/format "_p[_n-%d]" (- nargs i))))
      (w/line! out))

    ;; We have insufficient values, so make the varargs empty and bind
    ;; all remaining arguments to values after the fixed ones.
    (w/next-block! out "else")
    (w/line! out (string/format "%s = {tag=\"list\", n=0}" var-esc))

    (when (< var-idx nargs)
      (for i (succ var-idx) nargs 1
        (when (> i (succ var-idx)) (w/append! out ", "))
        (w/append! out (escape-var (map-var mapping (.> (nth args i) :var)) state)))
      (w/append! out " = ")
      (for i (succ var-idx) nargs 1
        (when (> i (succ var-idx)) (w/append! out ", "))
        (w/append! out (string/format "_p[%d]" (pred i))))
      (w/line! out))
    (w/end-block! out "end")))

(defun compile-recur (recur out state ret break)
  "Compile a recursive lambda."
  (case (.> recur :category)
    ["while"
     (with (node (nth (.> recur :def) 3))
       (w/append! out "while ")
       (compile-expression (car (nth node 2)) out state)
       (w/begin-block! out " do")

       (compile-recur-push recur out state)
       (compile-block (nth node 2) out state 2 ret break)
       (compile-recur-pop recur state)

       (w/end-block! out "end")
       (compile-block (nth node 3) out state 2 ret))]
    ["while-not"
     (with (node (nth (.> recur :def) 3))
       (w/append! out "while not (")
       (compile-expression (car (nth node 2)) out state)
       (w/begin-block! out ") do")

       (compile-recur-push recur out state)
       (compile-block (nth node 3) out state 2 ret break)
       (compile-recur-pop recur state)

       (w/end-block! out "end")
       (compile-block (nth node 2) out state 2 ret))]
    ["forever"
     (w/begin-block! out "while true do")

     (compile-recur-push recur out state)
     (compile-block (.> recur :def) out state 3 ret break)
     (compile-recur-pop recur state)

     (w/end-block! out "end")]))

(defun compile-recur-push (recur out state)
  "Compile the header for recursive variables in OUT."
  :hidden
  (with (mapping (.> recur :captured))
    (unless (empty-struct? mapping)
      (w/append! out "local ")

      (with (first true)
        (for-pairs (from to) mapping
          (if first (set! first false) (w/append! out ", "))

          (rename-escape-var! from to state)
          (w/append! out (push-escape-var! from state))))

      (w/append! out " = ")

      (with (first true)
        (for-pairs (from to) mapping
          (if first (set! first false) (w/append! out ", "))

          (w/append! out (escape-var to state))))

      (w/line! out))))

(defun compile-recur-pop (recur state)
  "Rename all mapped variables in RECUR."
  :hidden
  (for-pairs (from to) (.> recur :captured)
    (pop-escape-var! from state)
    (rename-escape-var! to from state)))

(defun map-var (mapping var)
  "Lookup a variable VAR in the provided MAPPING, returning the original
   if not found."
  :hidden
  (or (and mapping (.> mapping var)) var))

(defun compile-block (nodes out state start ret break)
  "Compile a block of expressions."
  :hidden
  (with (len (n nodes))
    (for i start (pred len) 1
      (compile-expression (nth nodes i) out state "")
      (w/line! out))

    (if (>= len start)
      (with (node (nth nodes len))
        (compile-expression node out state ret break)
        (w/line! out)
        (when (and break (not (.> break-categories (.> state :cat-lookup node :category))))
          (w/line! out "break")))
      (progn
        (when (and ret (/= ret ""))
          (w/append! out ret)
          (w/line! out "nil"))
        (when break
          (w/line! out "break"))))))

(defun prelude (out)
  "Various code to emit before everything else.

   This includes multi-version compatibility and caches some commonly used globals the compiled code will use."
  ;; Add some compat stuff
  (w/line! out "if not table.pack then table.pack = function(...) return { n = select(\"#\", ...), ... } end end")
  (w/line! out "if not table.unpack then table.unpack = unpack end")
  (w/line! out "local load = load if _VERSION:find(\"5.1\") then load = function(x, n, _, env) local f, e = loadstring(x, n) if not f then return f, e end if env then setfenv(f, env) end return f end end")

  ;; And cache some useful globals
  (w/line! out "local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error"))

(defun expression (node out state ret)
  "Tag NODE and compile it."
  (with (pass-state (create-pass-state state))
    (run-pass find-letrec/letrec-node state nil node pass-state)
    (run-pass cat/categorise-node state nil node pass-state (/= ret nil))
    (compile-expression node out pass-state ret)))

(defun block (nodes out state start ret)
  "Tag all NODES and compile them."
  (with (pass-state (create-pass-state state))
    (run-pass find-letrec/letrec-nodes state nil nodes pass-state)
    (run-pass cat/categorise-nodes state nil nodes pass-state)
    (compile-block nodes out pass-state start ret)))
