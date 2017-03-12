(import urn/analysis/nodes ())
(import urn/analysis/pass ())
(import urn/analysis/traverse traverse)
(import urn/analysis/usage usage)
(import urn/analysis/visitor visitor)

(import urn/analysis/optimise/simple opt)
(import urn/analysis/optimise/usage opt)

(defun optimise-once (nodes state)
  "Run all optimisations on NODES once"
  (with (tracker (create-tracker))
    (run-pass opt/strip-import state tracker nodes)
    (run-pass opt/strip-pure state tracker nodes)
    (run-pass opt/constant-fold state tracker nodes)
    (run-pass opt/cond-fold state tracker nodes)

    (with (lookup (usage/create-state))
      (run-pass usage/tag-usage state tracker nodes lookup)

      (run-pass opt/strip-defs state tracker nodes lookup)
      (run-pass opt/strip-args state tracker nodes lookup)
      (run-pass opt/variable-fold state tracker nodes lookup))

    (changed? tracker)))

(defun optimise (nodes state)
  ;; Run the main optimiser until a "fixed point" is reached
  (let [(iteration 0)
        (changed true)]
    (while (and changed (< iteration 10))
      (set! changed (optimise-once nodes state))
      (inc! iteration)))
  nodes)
