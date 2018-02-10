(import test ())

(import urn/analysis/warning warn)

(import urn/analysis/pass pass)
(import urn/analysis/tag/usage usage)
(import urn/resolve/loop resolve)
(import tests/compiler/compiler-helpers ())

(defun affirm-warn (pass input-nodes expected-messages)
  "Affirm running INPUT-NODES through PASS produces the
   EXPECTED-MESSAGES."

  (let* [(compiler (create-compiler))
         (logger (tracking-logger))]
    (.<! compiler :log logger)

    (let* [(resolved (resolve/compile
                       compiler
                       (wrap-node input-nodes)
                       (.> compiler :root-scope)
                       "init.lisp"))
           (options { :compiler compiler
                      :logger   (.> compiler :log)
                      :timer    (.> compiler :timer) })]

      (when (table? pass) (set! pass (.> pass :run)))
      (pass (pass/create-tracker) options resolved)

      (affirm (eq? expected-messages (.> logger :warnings))))))

(defun affirm-usage-warn (pass input-nodes expected-messages)
  "Affirm running INPUT-NODES through PASS produces the
   EXPECTED-MESSAGES."
  (affirm-warn
    (lambda (tracker options nodes)
      (with (lookup {})
        ((.> usage/tag-usage :run) tracker options nodes lookup)
        ((.> pass :run) tracker options nodes lookup)))
    input-nodes expected-messages))
