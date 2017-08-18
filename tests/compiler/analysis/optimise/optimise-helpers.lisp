(import extra/assert ())

(import urn/analysis/pass pass)
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
                    :meta      (.> compiler :lib-meta)
                    :logger    (.> compiler :log)
                    :timer     (.> compiler :timer) })]

      (when (table? pass) (set! pass (.> pass :run)))
      (pass tracker options resolved)

      (affirm (eq? expected-nodes resolved)
              (= expected-change  (.> tracker :changed)))))
