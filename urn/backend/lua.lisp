(import urn/backend/writer w)
(import string)

(defun create-lookup (&lst)
  (with (out (empty-struct))
    (for-each entry lst (.<! out entry true))
    out))

(define keywords (create-lookup "and" "break" "do" "else" "elseif" "end" "false" "for" "function"
                   "if" "in" "local" "nil" "not" "or" "repeat" "return" "then" "true"
                   "until" "while"))

(defun create-state (meta) (struct
                             :ctr-lookup (empty-struct)
                             :var-lookup (empty-struct)
                             :meta (or meta (empty-struct))))

(define builtins (get-idx (require "tacky.analysis.resolve") :builtins))
(define builtin-vars (get-idx (require "tacky.analysis.resolve") :declaredVars))

;; Escape an urn identifier, converting it into a form that is valid Lua.
(defun escape (name)
  (cond
    ((.> keywords name) (.. "_e" name)) ;; Keywords are trivial to escape
    ((string/find name "^%w[_%w%d]*$") name) ;; Explicitly forbit leading _ as used for compiler internals
    (true (let* [(out (if (-> name (string/char-at <> 1) (string/find <> "%d")) "_e" ""))
            (upper false)
            (esc false)]
            (for i 1 (# name) 1
              (with (char (string/char-at name i))
                (cond
                  ([and (= char "-")
                    (-> name (string/char-at <> (pred i)) (string/find <> "[%a%d']"))
                    (-> name (string/char-at <> (succ i)) (string/find <> "[%a%d']"))]
                    ;; If we're surrounded by ident characters then conver tthe next one to upper case
                    (set! upper true))
                  ((string/find char "[^%w%d]"
                     (set! char (-> char (string/byte <>) (string/format "%02x" <>)))
                     (unless esc
                       (set! esc true)
                       (set! out (.. out "_")))
                     (set! out (.. out char))))
                  (true
                    (when esc
                      (set! esc false)
                      (set! out (.. out "_")))
                    (when upper
                      (set! upper false)
                      (set! char (string/upper char)))
                    (set! out (.. out char))))))
            (when esc (set! out (.. out "_")))
            out))))

;; Escape an urn variable, uniquely numbering different variables with the same name(defun escape-var (var state)
(defun escape-var (var state)
  (cond
    ((.> builtin-vars var) (.> var :name))
    (true
      (let* [(v (escape (.> var :name)))
        (id (.> state :var-lookup var))]
        (unless id
          (set! id (succ (or (.> state :ctr-lookup v) 0)))
          (.<! state :ctr-lookup v id)
          (.<! state :var-lookup var id))
        (.. v (number->string id))))))

;; A rough test to detect if an nodeession can be compiled to a statement
(defun is-statement (node)
  (if (list? node)
    (with (first (car node))
      (cond
        ((symbol? first)
          ;; Obviously conditions require a statement
          (= (.> first :var) (.> builtins :cond)))
        ((list? first)
          (with (func (car first))
            ;; If we're invoking a lambda than we can inline it.
            (and (symbol? func) (= (.> func :var) (.> builtins :lambda)))))
        (true false)))
    false))

;; Compile quoted nodeessions.
;; If the level is nil then we are compiling quotes, otherwise it determines how deep
;; we are down this rabbit hole.
(defun compile-quote (node out state level)
  (if (= level 0)
    (compile-expression node out state)
    (with (ty (type node))
      (cond
        ((= ty "string") (w/append! out (.> node :contents)))
        ((= ty "number") (w/append! out (.> node :contents)))
        ((= ty "symbol")
          (w/append! out (.. "{ tag=\"symbol\", contents=" (string/quote (.> node :contents))))
          (when (.> node :var)
            (w/append! out (.. ", var=" (string/quote (number->string (.> node :var))))))
          (w/append! out))
        ((= ty "key")
          (w/append! (string/.. "{tag=\"key\" contents=" (string/quote (.> node :contents)) "}")))
        ((= ty "list")
          (with (first (car node))
            (cond
              ((and (symbol? first) (or (= (.> first :var) (.> builtins :unquote)) (= (.> :var) (.> builtins :unquote-splice))))
                (compile-quote (nth node 2) out state (and level (pred level))))
              ((and (symbol? first) (= (.> first :var) (.> builtins :quasiquote)))
                (compile-quote (nth node 2) out state (and level (succ level))))
              (true
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

                              (w/line! out (string/.. "for _c = 1, _temp.n do _result[" (number->string (- i offset)) " + c + _offset] = _temp[c] end"))
                              (w/line! out "_offset = _offset + _temp.n"))
                            (progn
                              (w/append! out (string/.. "_result[" (number->string (- i offset)) " + _offset]"))
                              (compile-quote sub out state level)
                              (w/line! out)))))
                      (w/line! out (.. "_result.n = _offset + " (number->string (- (# node) offset))))
                      (w/line! out "return _result")
                      (w/end-block! out "end)()"))
                    (progn
                      (w/append! out (.. "{tag = \"list\", n =" (number->string (# node))))
                      (for-each sub node
                        (w/append! out ", ")
                        (compile-quote sub out state level))
                      (w/append! out "}"))))))))
        (true (error! (.. "Unknown type " ty)))))))

(defun compile-expression (node out state ret)
  (cond
    ((list? node)
      (with (head (car node))
        (cond
          ((symbol? head)
            (with (var (.> head :var))
              (cond
                ((= var (.> builtins :lambda))) ;; TODO
                ((= var (.> builtins :cond))) ;; TODO
                ((= var (.> builtins :set!))
                   (compile-expression (nth node 3) out state (.. (escape-var (.> node 2 :var) state) " = "))
                   (when (and ret (/= ret ""))
                     (w/line! out)
                     (w/append! out ret)
                     (w/append! out "nil")))
                ((= var (.> builtins :define))
                  (compile-expression (nth node 3) out state (.. (escape-var (.> node 2 :defVar) state) " = ")))
                ((= var (.> builtins :define-macro))
                  (compile-expression (nth node 3) out state (.. (escape-var (.> node 2 :defVar) state) " = ")))
                ((= var (.> builtins :define-native))
                  (w/append! out (string/format "%s = _libs[%q]" (escape-var (.> node 2 :defVar) state) (.> node 2 :contents))))
                ((= var (.> builtins :quote))
                  ;; Quotations are "pure" so we don't have to emit anything
                  (unless (= ret "")
                    (when ret (w/append! out ret))
                    (compile-quote (nth node 2) out state)))
                ((= var (.> builtins :quasiquote))
                  ;; Sadly quasiquotations may have a side effect so we have to emit
                  ;; even if it will be discarded. A future enhancement would be to pass the
                  ;; return off to the quote emitter and it can decide there
                  (cond
                    ((= ret "") (w/append! out "local _ ="))
                    (ret (w/append! out ret)))
                  (compile-quote (nth node 2) out state 1))
                ((= var (.> builtins :unquote)) (fail "unquote outside of quasiquote"))
                ((= var (.> builtins :unquote-splice)) (fail "unquote-splice outside of quasiquote"))
                ((= var (.> builtins :import))
                  ;; Imports don't do anything at all (and should have be stripped by the optimiser)
                  ;; so we handle the return expression if required.
                  (cond
                    ((= ret nil) (w/append! out "nil"))
                    ((/= ret "")
                      (w/append! out ret)
                      (w/append! out "nil"))
                    (true)))
                (true
                  ;; As we're invoking a known symbol here, we can do some fancy stuff. In this case, we just
                  ;; "inline" anything defined in library meta data (such as arithmetic operators).
                  (with (meta (symbol? head) (= (.> head :var :tag) "native") (.> data :meta (.> head :var :name)))
                    ;; Obviously metadata only exists for native expressions. We can only emit it if
                    ;; we're in the right context (statements cannot be emitted when we require an expression) and
                    ;; we've passed in the correct number of arguments.
                    (if (and meta (or ret (= (.> meta :tag) "expr")) (= (pred (# node)) (.> meta :count)))
                      (progn
                        ;; If we're dealing with an expression then we emit the returner first. Statements just
                        ;; return nil.
                        (when (and ret (= (.> meta :tag) "expr"))
                          (w/append! ret out))

                        ;; Emit all entries. Numbers represent an argument, everything else is just
                        ;; appended directly.
                        (with (contents (.> meta :contents))
                          (for i (# contents) 1
                            (with (entry (nth contents 1))
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
                        (w/append! out ")"))))))))
          ((and ret (list? head) (symbol? (car head)) (= (.> head 1 :var) (.> builtins :lambda)))
            ;; If we have a direction invokation of a function then inline it
            ;; TODO:
            )
          (true
            ;; Just invoke the expression as normal
            (when ret (w/append! out ret))
            (compile-expression (car node) out state)
            (w/append! out "(")
            (for i 2 (# node) 1
              (when (> i 2) (w/append! out ", "))
              (compile-expression (nth node i) out state))
            (w/append! out ")")))))
    (true
      (unless (= ret "")
        (when ret (w/append! out ret))
        (cond
          ((symbol? node) (w/append! out (escape-var (.> node :var))))
          ((string? node) (w/append! out (.> node :contents)))
          ((number? node) (w/append! out (number->string (.> node :contents))))
          ((key? node) (w/append! (quote (string/sub (.> node :contents) 1)))) ;; TOD: Should this be a table instead? If so, can we make this more efficient?
          (true (error! (.. "Unknown type: " (type node)))))))))

;; Compile a block of expressions
(defun compile-block (nodes out state start ret)
  (for i start (# nodes) 1
    (with (ret' (if (= i (# nodes)) ret ""))
      (compile-expression (nth nodes i) out state ret'))
    (w/line! out)))

;; Various code to emit before everything else
(defun prelude (out)
  ;; Add some compat stuff
  (w/line! out "if not table.pack then table.pack = function(...) return { n = select(\"#\", ...), ... } end end")
  (w/line! out "if not table.unpack then table.unpack = unpack end")
  (w/line! out "if _VERSION:find(\"5.1\") then local function load(x, _, _, env) local f, e = loadstring(x); if not f then error(e, 1) end; return setfenv(f, env) end end")

  ;; And cache some useful globals
  (w/line! out "local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error"))
