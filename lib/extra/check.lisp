"A checker for algebraic properties."

(import lua/math (random randomseed huge))
(import lua/string string)
(import lua/table (concat))
(import lua/os os)
(randomseed (^ (os/time) (os/clock)))

(defun random-string () :hidden
  (let* [(length (random 1 255))
         (random-byte () (string/char (random 1 255)))]
    (concat (map random-byte (range 1 length)))))

(defun random-number () :hidden
  (random (- 0 (^ 2 32)) (^ 2 32)))

(defun random-boolean () :hidden
  (= 0 (% (random-number) 2)))

(defun random-symbol () :hidden
  (struct :tag "symbol" :contents (random-string)))

(defun random-type () :hidden
  (let* [(types '("symbol" "boolean" "number" "string" "key"
                  "list"))]
    (nth types (random 1 (# types)))))

(defun -random-type () :hidden
  (let* [(types '("symbol" "boolean" "number" "string" "key"))]
    (nth types (random 1 (# types)))))

(defun random-of (type) :hidden
  (case type
    ["string" (random-string)]
    ["boolean" (random-boolean)]
    ["number" (random-number)]
    ["symbol" (random-symbol)]
    ["key" (random-string)]
    ["list" (random-list)]))

(defun random-list () :hidden
  (let* [(length (random 1 2))]
    (map (lambda (x) (random-of (-random-type))) (range 1 length))))

(defmacro check (bindings &props)
  "Check a set of properties against a set of random variables 100 times.
   This can be used as a rudimentary algebraic property checker, where
   BINDINGS is the list of universally-quantified variables and PROPS is
   the list of properties you're checking.

   Example:
   ```
   > (check [(number a)] \
   .   (= a a))
   .
   (= a a) passed 100 tests.
   nil
   > (check [(number a)] \
   .   (= a (+ 1 a)))
   .
   (= a (+ 1 a)) falsified after 1 iteration(s)
   falsifying set of values:
     the number, a, had the value 3867638440
   nil
   ```

   The property is checked against a different set of random values every
   iteration. This library has the ability to generate random numbers, strings,
   symbols, booleans, keys and lists."
  (let* [(generate-binding (binding)
           (destructuring-bind [(?type ?name) binding]
             `(,name (random-of ,(symbol->string type)))))
         (generate-regenerator (binding)
           (destructuring-bind [(?type ?name) binding]
             `(set! ,name (random-of ,(symbol->string type)))))
         (make-printing (binding)
           (destructuring-bind [(?type ?name) binding]
             `(.. ,(.. "  the " (symbol->string type) " `"
                       (symbol->string name) "', had the value ") (pretty ,name))))
         (generate-body (prop)
           (let* [(ctr (gensym))
                  (ok (gensym))]
             `(let* [(,ok true)
                     (,ctr 1)]
                (while (and (>= 100 ,ctr) ,ok)
                  ,@(map generate-regenerator bindings)
                  (if (! ,prop)
                    (progn
                      (set! ,ok false)
                      (error! (.. "Proposition " ,(pretty prop) " falsified after "
                          ,ctr " iteration(s).\n Falsifying set of values:\n"
                          ,@(map make-printing bindings))))
                    (inc! ,ctr)))
                (when ,ok
                  (print! (.. ,(pretty prop) " passed 100 tests."))))))]
    `(let* ,(map generate-binding bindings)
       ,@(map generate-body props))))
