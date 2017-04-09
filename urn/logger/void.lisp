(define void
  "A logger which discards all output."
  (with (discard (lambda ()))
    { :put-error!   discard
      :put-warning! discard
      :put-verbose! discard
      :put-debug!   discard
      :put-time!   discard

      :put-node-error!    discard
      :put-node-warning!  discard }))
