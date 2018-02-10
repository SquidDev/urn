(import test ())
(import io/term (coloured))

(import urn/backend/lua/emit lua)
(import urn/backend/lua/escape lua)
(import urn/backend/lua lua)
(import urn/backend/writer writer)
(import urn/resolve/loop resolve)
(import tests/compiler/compiler-helpers (create-compiler wrap-node))

(defun diff-lines (old new out)
  "Diff the strings in OLD to NEW, writing the result to OUT."
  (with (old-map {})
    (for i 1 (n old) 1
      (with (list (.> old-map (nth old i)))
        (unless list
          (set! list '())
          (.<! old-map (nth old i) list))
        (push! list (pred i))))

    (let [(overlap '())
          (sub-start-old 0)
          (sub-start-new 0)
          (sub-length 0)]
      (for idx 1 (n new) 1
        (let [(val (nth new idx))
              (inew (pred idx))
              (sub-overlap {})]
          (when-with (old-vals (.> old-map val))
            (for-each iold old-vals
              (if (<= iold 0)
                (.<! sub-overlap iold 1)
                (.<! sub-overlap iold (succ (or (.> overlap (pred iold)) 0))))
              (when (> (.> sub-overlap iold) sub-length)
                (set! sub-length (.> sub-overlap iold))
                (set! sub-start-old (succ (- iold sub-length)))
                (set! sub-start-new (succ (- inew sub-length))))))
          (set! overlap sub-overlap)))

      (if (= sub-length 0)
        (progn
          (for-each elem old (push! out (coloured 31 (.. "- " elem))))
          (for-each elem new (push! out (coloured 32 (.. "+ " elem)))))
        (progn
          (diff-lines
            (slice old 1 sub-start-old)
            (slice new 1 sub-start-new)
            out)

          (for i (succ sub-start-new ) (+ sub-start-new sub-length) 1
            (push! out (.. "  " (nth new i))))

          (diff-lines
            (slice old (+ sub-start-old sub-length 1))
            (slice new (+ sub-start-new sub-length 1))
            out))))))

(defun affirm-codegen (input-nodes expected-src)
  "Affirm compiling INPUT-NODES generates EXPECTED-SRC."
  (let* [(compiler (create-compiler))
         (compile-state (lua/create-state))
         (writer (writer/create))]
    (.<! compiler :compile-state compile-state)

    (with (resolved (resolve/compile
                     compiler
                     (wrap-node input-nodes)
                     (.> compiler :root-scope)
                     "init.lisp"))

      (for-pairs (_ var) (.> compiler :root-scope :variables)
        (lua/push-escape-var! var compile-state))

      (lua/block resolved writer compile-state 1 "return ")

      (with (res (string/trim (string/gsub (writer/->string writer) "\t" "  ")))
        (when (/= res expected-src)
          (with (out '())
            (push! out (.. "Unexpected result compiling " (pretty input-nodes)))
            (diff-lines (string/split expected-src "\n") (string/split res "\n") out)
            (fail! (concat out "\n"))))))))

(defun affirm-codegen* (input-nodes expected-src)
  "Affirm compiling INPUT-NODES generates EXPECTED-SRC.

   Unlike [[affirm-codegen]], this will not resolve the nodes."
  (with (writer (writer/create))
    (lua/block (wrap-node input-nodes) writer (lua/create-state) 1 "return ")

    (with (res (string/trim (string/gsub (writer/->string writer) "\t" "  ")))
      (when (/= res expected-src)
        (with (out '())
          (push! out (.. "Unexpected result compiling " (pretty input-nodes)))
          (diff-lines (string/split expected-src "\n") (string/split res "\n") out)
          (fail! (concat out "\n")))))))
