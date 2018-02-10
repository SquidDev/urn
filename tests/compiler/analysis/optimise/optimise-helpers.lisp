(import test ())

(import urn/analysis/pass pass)
(import urn/analysis/tag/usage usage)
(import urn/analysis/transform ())
(import urn/resolve/loop resolve)
(import tests/compiler/compiler-helpers (create-compiler wrap-node))

(defun affirm-optimise (pass input-nodes expected-nodes expected-change)
  "Affirm running INPUT-NODES through PASS produces the given
   EXPECTED-NODES, with EXPECTED-CHANGE nodes being modified."

  (let* [(compiler (create-compiler))
         (resolved (resolve/compile
                     compiler
                     (wrap-node input-nodes)
                     (.> compiler :root-scope)
                     "init.lisp"))
         (tracker (pass/create-tracker))
         (options { :compiler  compiler
                    :logger    (.> compiler :log)
                    :timer     (.> compiler :timer) })]

      (when (table? pass) (set! pass (.> pass :run)))
      (pass tracker options resolved)

      (affirm (eq? expected-nodes resolved)
              (= expected-change  (.> tracker :changed)))))

(defun affirm-usage-optimise (pass input-nodes expected-nodes expected-change)
  "Affirm running INPUT-NODES through PASS produces the given
   EXPECTED-NODES, with EXPECTED-CHANGE nodes being modified."
  (affirm-optimise
    (lambda (tracker options nodes)
      (with (lookup {})
        ((.> usage/tag-usage :run) tracker options nodes lookup)
        ((.> pass :run) tracker options nodes lookup)))
    input-nodes expected-nodes expected-change))

(defun affirm-transform-optimise (transformers input-nodes expected-nodes expected-change)
  "Affirm running INPUT-NODES from the given TRANSFORMERS produces the
   given EXPECTED-NODES, with EXPECTED-CHANGE nodes being modified."
  (affirm-optimise
    (lambda (tracker options nodes)
      (with (lookup {})
        ((.> usage/tag-usage :run) tracker options nodes lookup)
        ((.> transformer :run) tracker options nodes lookup transformers)))
    input-nodes expected-nodes expected-change))
