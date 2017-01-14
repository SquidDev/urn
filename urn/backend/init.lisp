(import urn/backend/writer writer)

(define old-writer (require "tacky.backend.writer"))

(defun wrap-generate (func new-style)
  (if new-style
    (lambda (node &args)
      (with (writer (writer/create))
        (func node writer (unpack args))
        (writer/->string writer)))
    (lambda (node &args)
      (with (writer (old-writer))
        (func node writer (unpack args))
        ((.> writer :toString))))))

(with (backends (empty-struct))
  (for-each backend '("lisp" "lua")
    (let* [(module (require (.. "tacky.backend." backend)))
          (new-style (= backend "lisp"))]
      (.<! backends backend (struct
        :expression (wrap-generate (.> module :expression) new-style)
        :block (wrap-generate (.> module :block) new-style)
        :prelude (and (.> module :prelude) (wrap-generate (.> module :prelude) new-style))
        :backend module))))
  backends)
