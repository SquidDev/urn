(import lua/os os)

(import urn/analysis/nodes ())
(import urn/analysis/pass ())
(import urn/analysis/traverse traverse)
(import urn/analysis/usage usage)
(import urn/analysis/visitor visitor)

(import urn/analysis/optimise/fusion opt)
(import urn/analysis/optimise/simple opt)
(import urn/analysis/optimise/usage opt)
(import urn/analysis/optimise/inline opt)

(defun optimise-once (nodes state)
  "Run all optimisations on NODES once"
  (with (tracker (create-tracker))
    (for-each pass (.> state :pass :normal)
      (run-pass pass state tracker nodes))

    (with (lookup (usage/create-state))
      (run-pass usage/tag-usage state tracker nodes lookup)
      (for-each pass (.> state :pass :usage)
        (run-pass pass state tracker nodes lookup)))

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
      (inc! iteration))))

(defun default ()
  "Create a collection of default optimisations."
  { :normal (list opt/strip-import
                  opt/strip-pure
                  opt/constant-fold
                  opt/cond-fold
                  opt/lambda-fold
                  opt/fusion)
    :usage (list opt/strip-defs
                 opt/strip-args
                 opt/variable-fold
                 opt/cond-eliminate
                 opt/expression-fold
                 opt/inline) })
