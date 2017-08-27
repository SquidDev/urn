(import extra/test ())
(import extra/assert ())

(import urn/documentation ())

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
                          (tok "text" " after")))))

    (it "with bold and italic"
      (affirm (teq? (parse-docstring "**foo**")
                    (list (tok "bold" "**foo**" "**foo**")))
              (teq? (parse-docstring "*foo*")
                    (list (tok "italic" "*foo*" "*foo*")))
              (teq? (parse-docstring "***foo***")
                    (list (tok "bolic" "***foo***" "***foo***")))))

    (it "with links to other code"
      (affirm (teq? (parse-docstring "[[foo]]")
                    (list (tok "link" "foo" "[[foo]]")))))))
