(import lib/lua/basic (len# type#))

(define default-cfg
  "The default configuration for various methods here"
  { :hide-hash false ;; Print the non array part of tables?
    :use-tag   true  ;; Use Metalua's backtick syntax
    :blacklist { }   ;; Set of fields to not display
    :max-depth -1    ;; The maximum depth to traverse
    :dups      false ;; Print any duplicates in different structures
  })

(define node-cfg
  "The config for printing various nodes."
  (update-struct default-cfg
    {
      :blacklist (create-lookup '("parent" "var" "lines" "macro" "start"
                                  "finish" "range" "variables" "scope"
                                  "required" "states" "required-set" "owner")) }))

(defun valid-key? (key)
  "Determine KEY is table key which can be easily printed."
  :hidden
  (and (string? key) (string/find key "^[a-zA-Z_][a-zA-Z0-9_-]*$")))

(defun serialise# (object data)
  "The main serialisation routine, writes OBJECT to DATA."
  (if (and (> (.> data :cfg :max-depth) -1) (> (.> data :indent) (.> data :cfg :max-depth)))
    (push-cdr! (.> data :buffer) "...")
    (with (ty (type# object))
      (cond
        [(= ty "string") (push-cdr! (.> data :buffer) (string/quoted ty))]
        [(and (= ty "table") (! (.> data :visited object)))
         (.<! data :visited object true)
         (inc! (.> data :indent))

         (let [(has-tag (and (.> data :cfg :use-tag) (valid-key? (.> object :tag))))
               (should-new-line false)
               (obj-len (len# object))
               (buffer (.> data :buffer))
               (builder 0)]

           (when has-tag
             (push-cdr! buffer "`")
             (push-cdr! buffer (.> object :tag)))

           (for-pairs (k v) object
             (when (or
                     (and (number? k) (>= k 1) (<= k obj-len) (= (math/fmod k 1) 0))
                     (and (! (.> data :cfg :hide-hash)) (! (.> data :cfg :blacklist k))))
               (if (or (table? k) (table? v))
                 (set! should-new-line true)
                 (progn
                   (set! builder (+ builder (n (tostring v)) (n (tostring k))))
                   (when (> builder 80) (set! should-new-line true))))))

           (with (first false)
             (push-cdr! buffer "{")

             (unless (.> data :cfg :hide-hash)
               (for-pairs (k v) object
                 (cond
                   [(and has-tag (= k "tag"))]
                   [(and (number? k) (>= k 1) (<= k obj-len) (= (math/fmod k 1) 0))]
                   [(.> data :cfg :blacklist k)]
                   [true
                    (if first
                      (push-cdr! buffer ", ")
                      (set! first true))

                    (when should-new-line
                      (push-cdr! buffer (.. "\n" (string/rep "  " (.> data :indent)))))

                    (if (valid-key? k)
                      (push-cdr! buffer k)
                      (serialise# k data))

                    (push-cdr! buffer " = ")
                    (serialise# v data)])))

             (for i 1 obj-len 1
               (if first
                 (push-cdr! buffer ", ")
                 (set! first true))


               (when should-new-line
                 (push-cdr! buffer (.. "\n" (string/rep "  " (.> data :indent)))))

               (serialise# (.> object i) data))

             (dec! (.> data :indent))
             (when should-new-line
                 (push-cdr! buffer (.. "\n" (string/rep "  " (.> data :indent)))))

             (push-cdr! buffer "}")

             (when (.> data :cfg :dups) (.<! data :visited object false))))]
        [true (push-cdr! (.> data :buffer) (tostring object))]))))

(defun serialise (object cfg)
  "Convert OBJECT to a string using the given CFG."
  (with (data { :indent 0
                :buffer '()
                :cfg (or cfg default-cfg)
                :visited {}})
    (serialise# object data)
    (concat (.> data :buffer))))
