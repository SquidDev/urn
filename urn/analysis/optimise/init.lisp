(import lua/os os)

(import urn/analysis/nodes ())
(import urn/analysis/pass ())
(import urn/analysis/traverse traverse)
(import urn/analysis/usage usage)
(import urn/analysis/visitor visitor)

(import urn/analysis/optimise/simple opt)
(import urn/analysis/optimise/usage opt)
(import urn/analysis/optimise/inline opt)

(defun optimise-once (nodes state)
  "Run all optimisations on NODES once"
  (with (tracker (create-tracker))
    (run-pass opt/strip-import state tracker nodes)
    (run-pass opt/strip-pure state tracker nodes)
    (run-pass opt/constant-fold state tracker nodes)
    (run-pass opt/cond-fold state tracker nodes)
    (run-pass opt/lambda-fold state tracker nodes)

    (with (lookup (usage/create-state))
      (run-pass usage/tag-usage state tracker nodes lookup)

      (run-pass opt/strip-defs state tracker nodes lookup)
      (run-pass opt/strip-args state tracker nodes lookup)
      (run-pass opt/variable-fold state tracker nodes lookup)

      (run-pass opt/expression-fold state tracker nodes lookup)

      (run-pass opt/inline state tracker nodes lookup))

    (changed? tracker)))

(defun optimise (nodes state)
  ;; Run the main optimiser until a "fixed point" is reached
  (let* [(max-n (.> state :max-n))
         (max-t (.> state :max-time))
         (iteration 0)
         (finish (+ (os/clock) max-t))
         (changed true)]
    (while (and changed (or (< max-n 0) (< iteration max-n)) (or (< max-t 0) (< (os/clock) finish)))
      (set! changed (optimise-once nodes state))
      (inc! iteration)))
  nodes)
