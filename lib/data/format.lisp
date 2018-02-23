(import core/prelude ())
(import core/base (type#))

(defun display (x) :hidden
  (cond
    [(= (type# x) "string") x]
    [(and (= (type# x) "table")
          (= (.> x :tag) "string"))
     (.> x :value)]
    [else (pretty x)]))

(defun format-output! (out buf) :hidden
  (cond
    [(= out nil) buf]
    [(= out true) (print! buf)]
    [(number? out) (error! buf out)]
    [(function? out) (out buf)]
    [else ((.> out :write) out buf)]))

(defun str->sym (x) :hidden { :tag "symbol" :contents x })

(defun name-terminator-char? (c) :hidden
  (or (= c ":")
      (= c "%")))

(defun parse-format-reference (str last-pos-ref) :hidden
  "Parse the formatting reference STR."
  (let* [((val end)
          (cond
            [(= (string/char-at str 1) "$")
             (let* [((start end match)
                     (string/find str "%$(%d+)"))]
               (values-list (list 'positional (tonumber match)) end))]
            [(string/find (string/char-at str 1) "[a-zA-Z]")
             (let* [((start end match)
                     (string/find str "([a-zA-Z][^:%%@]*)"))]
               (values-list (list 'named match) end))]
            [(string/find (string/char-at str 1) "#")
             (let* [((start end match)
                     (string/find str "#([a-zA-Z][^:%%@]*)"))]
               (values-list (list 'implicitly-named match) end))]
            [(string/find (string/char-at str 1) "[:%%@]") ; anonymous, but with a formatter
             (let* [(pos (.> last-pos-ref 1))]
                (.<! last-pos-ref 1 (+ pos 1))
                (values-list (list 'positional pos) 0))]
            [else
              (let* [(pos (.> last-pos-ref 1))]
                (.<! last-pos-ref 1 (+ pos 1))
                (values-list (list 'positional pos) 1))]))]
    (values-list val (string/sub str (+ 1 end)))))

(defun display-with-sep (sep frag) :hidden
  (let* [(arg (gensym))
         (li (gensym))
         (bd (compile-format-fragment frag (lambda (x) arg)))]
    `(lambda (,li)
       (string/concat (map (lambda (,arg) ,bd) ,li) ,sep))))

(defun parse-format-formatter (spec) :hidden
  "Parse the formatter specifier in SPEC, returning a continuation that,
   when applied, returns a formatting fragment."
  (cond
    [(string/find spec "^:")
     (lambda (ref) (list 'urn-format ref (str->sym (string/sub spec 2))))]
    [(string/find spec "^%%")
     (lambda (ref) (list 'printf-format ref spec))]
    [(string/find spec "^@")
     (let* [((start end sep fmtr)
             (string/find spec "^@(%b())(.*)$"))
            (k (parse-format-formatter fmtr))]
       (lambda (ref)
         (list 'urn-format ref (display-with-sep (string/sub sep 2 (- (n sep) 1)) (k 'ignored)))))]
    [(= spec "") (lambda (ref) (list 'urn-format ref `display))]))

(defun handle-formatting-specifier (spec last-pos) :hidden
  "Parse the entirety of the format specifier SPEC."
  (let* [((ref spec) (parse-format-reference spec last-pos))
         ((formatter spec) (parse-format-formatter spec))]
  (formatter ref)))

(defun parse-format (str) :hidden
  "Parse the format string STR into a list of fragments."
  (let* [(cur "") ; the current character (for convenience)
         (buf "") ; a buffer
         ; we don't have pointers, so we keep it in a table.
         (last-positional { 1 1 }) ; for anonymous positions
         (frags '())]
    (loop [(i 1)]
      [(> i (n str))
       (when (/= buf "") ; it isn't empty, so we flush it again
         (push! frags (list 'literal buf)))]
      (set! cur (string/char-at str i))
      (case cur
        ["{" ; a formatting fragment (splice)
         (push! frags (list 'literal buf)) ; flush the buffer
         (set! buf "")
         (loop [(parsed "")
                (j (+ 1 i))]
           [(or (>= j (n str))
                (= (string/char-at str j) "}"))
            (set! i j)
            (let* [(frag (handle-formatting-specifier parsed last-positional))]
              (push! frags frag))]
           (recur (.. parsed (string/char-at str j)) (+ 1 j)))]
        [else => (set! buf (.. buf it))])
      (recur (+ 1 i)))
    frags))

(defun compile-format-fragment (frag resolve-spec) :hidden
  (case frag
    [(literal ?x) x]
    [(urn-format ?spec ?fmtr)
     `(,fmtr ,(resolve-spec spec))]
    [(printf-format ?spec ?fmt)
     `(string/format ,fmt ,(resolve-spec spec))]))

(defmacro format (out str &args)
  "Output the string STR formatted against ARGS to the stream OUT. In
   the case OUT is nil, a string in returned; If OUT is true, the result
   is printed to standard output.

   ### Formatting specifiers

   Formatting specifiers take the form `{...}`, where `...` includes
   both a _reference_ (what's to be output) and a _formatter_ (how to
                                                                   output it).

   - If the reference starts with `#`, it is an implicit named symbol
   (something in scope, and not passed explicitly).
   - If the reference starts with an alphabetic character, it is
   _named_: something given to the [[format]] macro explicitly, as a
   keyword argument.
   - If the reference starts with `$`, it is a positional argument.

   The formatter can either start with `:`, in which case it references
   an Urn symbol, or start with `%`, in which case it is a string.format
   format sequence.

   ### Examples
   ```cl
   > (format nil \"{#pretty:pretty} is {what}\" :what 'pretty)
   out = \"«method: (pretty x)» is pretty\"
   > (format nil \"0x{foo%x}\" :foo 123)
   out = \"0x7b\"
   ```"
  (let* [(str (const-val str))
         (fragments (parse-format str))
         (last-positional
           (apply math/max 0
                  (maybe-map (function
                               [((_ (positional ?d) _)) d]
                               [else nil])
                             fragments)))
         (named-map (gensym))
         ((positionals nameds)
          (loop [(pos '())
                 (nam {}) (expecting-nam nil)
                 (togo args)]
                [(empty? togo)
                 (when expecting-nam
                   (error! (string/format "(format %q): expecting value for named argument %s"
                                          (.> expecting-nam :value))))
                 (values-list pos nam)]
                (cond
                  [(key? (car togo))
                   (recur pos nam (.> (car togo) :contents) (cdr togo))]
                  [else
                    (if expecting-nam
                      (.<! nam expecting-nam (car togo))
                      (push! pos (car togo)))
                    (recur pos nam nil (cdr togo))])))
         (named-alist (let* [(arg '())]
                        (for-pairs (k v) nameds
                          (push! arg k)
                          (push! arg v))
                        arg))
         (interpret-spec
           (function
             [((positional ?k)) (or (nth positionals k)
                                    (error! (string/format "(format %q): not given positional argument %d"
                                                           str k)))]
             [((implicitly-named ?k)) (str->sym k)]
             [((named ?k)) (if (.> nameds (.. ":" k))
                             `(.> ,named-map ,(.. ":" k))
                             (error! (string/format "(format %q): not given value for named argument %s"
                                                    str k)))]))]
    (when (> last-positional (n args))
      (error! (string/format "(format %q): not given enough positional arguments (expected %d, got %d)"
                             str last-positional (n args))))
    (with (parts (dolist [(frag fragments)]
                   (compile-format-fragment frag interpret-spec)))
    `(let* [(,named-map { ,@named-alist })]
       (format-output! ,out
                       ,(if (= (n parts) 1)
                          (car parts)
                          (cons `.. parts)))))))
