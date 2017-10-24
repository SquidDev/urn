(import test ())

(import urn/documentation ())
(import urn/resolve/loop resolve)
(import tests/compiler/compiler-helpers ())

(defun teq? (a b)
  "Determine whether tokens A and B are equal."
  :hidden
  (and
    (= (n a) (n b))
    (all id (map (lambda (x y)
                   (and (= (.> x :kind) (.> y :kind))
                        (= (.> x :contents) (.> y :contents))
                        (= (.> x :whole) (.> y :whole)))) a b))))

(defun tok (kind contents whole)
  "Create a new token with the given KIND, CONTENTS and WHOLE."
  :hidden
  { :kind kind :contents contents :whole whole })

(defun affirm-signature (node expected)
  "Affirm the signature of NODE is EXPECTED."
  :hidden
  (let* [(compiler (create-compiler))
         (resolved (resolve/compile
                     compiler
                     (wrap-node (list node))
                     (.> compiler :root-scope)
                     "init.lisp"))
         (var (.> (car resolved) :def-var))]

    (affirm (eq? expected (extract-signature var)))))

(describe "The Urn compiler handles documentation"
  (section "which can parse docstrings"
    (it "with arguments"
      (affirm (teq? (parse-docstring "FOO")
                    (list (tok "arg" "FOO" "FOO")))
              (teq? (parse-docstring "FOO-BAR")
                    (list (tok "arg" "FOO-BAR" "FOO-BAR")))
              (teq? (parse-docstring "FOO-BAR, baz")
                    (list (tok "arg" "FOO-BAR" "FOO-BAR") (tok "text" ", baz")))
              (teq? (parse-docstring "FOO-bar")
                    (list (tok "text" "FOO-bar")))
              (teq? (parse-docstring "f-OO-bar")
                    (list (tok "text" "f-OO-bar")))
              (teq? (parse-docstring "FOO.")
                    (list (tok "arg" "FOO" "FOO") (tok "text" ".")))))

    (it "with inline code blocks"
      (affirm (teq? (parse-docstring "`code block`")
                    (list (tok "mono" "code block" "`code block`")))
              (teq? (parse-docstring "before `code block` after")
                    (list (tok "text" "before ")
                          (tok "mono" "code block" "`code block`")
                          (tok "text" " after")))
              (teq? (parse-docstring "`multiline\ncode block`")
                    (list (tok "text" "`multiline\ncode block`")))))

    (it "with bold and italic"
      (affirm (teq? (parse-docstring "**foo**")
                    (list (tok "bold" "**foo**" "**foo**")))
              (teq? (parse-docstring "*foo*")
                    (list (tok "italic" "*foo*" "*foo*")))
              (teq? (parse-docstring "***foo***")
                    (list (tok "bolic" "***foo***" "***foo***")))))

    (it "with links to other code"
      (affirm (teq? (parse-docstring "[[foo]]")
                    (list (tok "link" "foo" "[[foo]]"))))))

  (section "can extract signatures"
    (it "for constant definitions"
      (affirm-signature
        '(define x 1)
        nil))

    (it "for lambda definitions"
      (affirm-signature
        '(define x (lambda (a b c)))
        '(a b c)))

    (it "for macros"
      (affirm-signature
        '(define-macro x (lambda (a b c)))
        '(a b c)))

    (it "for native definitions"
      (affirm-signature
        '(define-native x)
        nil)))


  (section "can extract a summary"
    (affirm (teq?
              (extract-summary
                (parse-docstring
                  "This is a summary of my complex module. It has lots and lots of methods"))
              (list (tok "text" "This is a summary of my complex module.")))
            (teq?
              (extract-summary
                (parse-docstring
                  "This is a summary of my complex module

                   It has lots and lots of methods"))
              (list (tok "text" "This is a summary of my complex module")))
            (teq?
              (extract-summary
                (parse-docstring
                  "This is a summary of my complex module"))
              (list (tok "text" "This is a summary of my complex module")))
            (teq?
              (extract-summary
                (parse-docstring
                  "This is a summary of my complex **module. And some more**"))
              (list (tok "text" "This is a summary of my complex ")
                    (tok "bold" "**module.**"))))))
