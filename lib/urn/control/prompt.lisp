"### Continuation objects
 
 The value given to the handler in [[call-with-prompt]], much like
 the value captured by [[shift]], is not a coroutine: it is a
 continuation object. Continuation objects (or just \"continuations\")
 can be applied, much like functions, to continue their execution.

 They may also be given to [[call-with-prompt]]."

(import lua/coroutine c)

(defun reify-continuation (coroutine) :hidden
  (setmetatable
    { :tag "continuation"
      :thread coroutine }
    { :--pretty-print (const "«continuation»")
      :__call (lambda (k &args)
                (apply continue (.> k :thread) args)) }))

(defun call-with-prompt (prompt-tag body handler)
  "Call the thunk BODY with a prompt PROMPT-TAG in scope. If BODY
   aborts to PROMPT-TAG, then HANDLER is invoked with the coroutine
   representing the rest of BODY along with any extra arguments to
   [[abort-to-prompt]].

   **NOTE**: The given HANDLER is not executed in the scope of the
   prompt, so subsequent calls to [[abort-to-prompt]] in the
   continuation will not be handled.

   ### Example
   ```cl
   > (call-with-prompt 'tag
   .                   (lambda ()
   .                     (+ 1 (abort-to-prompt 'tag)))
   .                   (lambda (k)
   .                     (k 1)))
   out = 2
   ```"
  (let* [(k (cond
              [(= (type body) "thread") body]
              ; we reify the continuation before handing it off to the
              ; handler anyway
              [(= (type body) "continuation") (.> body :thread)]
              [(= (type body) "function") (c/create body)]
              [:else (error! (.. "expected a coroutine or a function, got " (type body)))]))
         (last-res nil)]
    (loop [(k k)
           (res nil)]
      [(= (c/status k) :dead) res]
      (let* [((ok err) (c/resume k))]
        (cond
          [(and ok
                (list? err)
                (>= (n err) 2)
                (eq? (car err) :abort))
           (if (eq? (cadr err) prompt-tag)
             (handler (reify-continuation k) (cddr err))
             (apply abort-to-prompt (cadr err) (cddr err)))]
          [(! ok)
           (error! err)]
          [ok
            (recur k err)])))))
(define call/p call-with-prompt)

(defmacro let-prompt (tg e h)
  "Evaluate E in a prompt with the tag TG and handler H."
  `(call-with-prompt ,tg (lambda () ,e) ,h))
(define-macro let/p let-prompt)

(defun call-with-escape-continuation (body)
  "Invoke the thunk BODY with an escape continuation.

   ### Example
   ```cl
   > (call-with-escape-continuation
   .   (lambda (return)
   .     (print! \"this is printed\")
   .     (return 1)
   .     (print! \"this is not\")))
   this is printed
   out = 1
   ```"
  (call-with-prompt 'escape-continuation
                    (lambda ()
                      (body (lambda (&rest)
                              (apply abort-to-prompt
                                     'escape-continuation rest))))
                    (lambda (k &rest)
                      (unpack (car rest) 1 (n (car rest))))))

(defmacro let-escape-continuation (k &body)
  "Bind K within BODY to an escape continuation.

   ### Example
   ```cl
   > (let-escape-continuation return
   .   (print! 1)
   .   (return 2)
   .   (print! 3))
   1
   out = 2
   ```"
  (let* [(tag 'escape-continuation)]
    `(call-with-escape-continuation (lambda (,k) ,@body))))

(define call/ec call-with-escape-continuation)
(define-macro let/ec let-escape-continuation)

(defun continue (k &args) :hidden
  (let* [(last-res nil)]
    (while (/= (c/status k) :dead)
      (let* [((ok err) (apply c/resume k args))]
        (if (! ok)
          (error! err)
          (progn
            (set! args '())
            (when err
              (set! last-res err))))))
    last-res))

(defun abort-to-prompt (tag &rest)
  "Abort to the prompt TAG, giving REST as arguments to the handler."
  (c/yield (cons :abort tag rest)))

(defmacro reset (&body)
  "Establish a prompt, and evaluate BODY within that prompt.

   ### Example
   ```
   > (* 2 (reset (+ 1 (shift k (k 5)))))
   out = 12
   ```"
  (let* [(cont (gensym))
         (f (gensym))]
    `(call-with-prompt ','reset-tag
                       (lambda () ,@body)
                       (lambda (,cont ,f)
                         ((car ,f) ,cont)))))

(defmacro shift (k &body)
  "Abort to the nearest [[reset]], and evaluate BODY in a scope where
   the captured continuation is bound to K.

   ### Example
   ```
   > (* 2 (reset (+ 1 (shift k (k 5)))))
   out = 12
   ```"
  `(abort-to-prompt ','reset-tag
                    (lambda (,k)
                      ,@body)))

(defun alive? (k)
  "Check that the continuation K may be executed further.

   ### Example:
   ```
   > (alive? (reset (shift k k)))
   out = true
   ```"
  (cond
    [(= (type k) :continuation)
     (/= (c/status (.> k :thread)) "dead")]
    [(= (type k) :thread)
     (/= (c/status k) "dead")]
    [(function? k)
     true]
    [:else false]))


(defmacro block (&body)
  "Estabilish an escape continuation called `break` and evaluate BODY.

   ### Example:
   ```cl
   > (block
   .   (print! 1)
   .   (break)
   .   (print! 2))
   1
   out = ()
   ```"
  `(let-escape-continuation ,'break ,@body))
