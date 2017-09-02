(import compiler/pass ())
(import compiler/nodes ())

(import lua/basic (set-idx!))

(defun get-lookup (lookup key)
  :hidden
  (with (len (n lookup))
    (loop [(i 2)]
      [(> i len)
       (with (sub (list (fix-symbol `struct-literal)))
         (push-cdr! lookup key)
         (push-cdr! lookup sub)
         sub)]
      (if (eq? (nth lookup i) key)
        (nth lookup (succ i))
        (recur (+ i 2))))))

(defpass fold-defgeneric (state nodes)
  "Merges put!s into their corresponding method."
  :cat '("opt")
  (let [(methods {})
        (i 1)]
    (while (< i (n nodes))
      (with (node (nth nodes i))
        ;; Match against (define X ... (setmetatable (struct-literal :lookup Y)))
        (when (and (list? node) (builtin? (car node) :define)
                   (with (def (last node))
                     (and (list? def) (= (symbol->var (car def)) (symbol->var `setmetatable))
                          (with (tbl (cadr def))
                            (and (list? tbl) (= (symbol->var (car tbl)) (builtin :struct-literal))
                                 (eq? (cadr tbl) :lookup))))))

          (.<! methods (.> node :def-var) (cadr (last node))))

        (cond
          ;; Match against (put! X (:lookup Y*) Z)
          [(and (list? node) (symbol? (car node))
                (= (.> (car node) :var :full-name) "core/type/put!") ;; HACK HACK HACK
                (.> methods (symbol->var (cadr node))))
           (let [(lookup (caddr (.> methods (symbol->var (cadr node)))))
                 (entries (caddr node))
                 (def (cadddr node))]

             (for i 3 (pred (n entries)) 1
               (set! lookup (get-lookup lookup (nth entries i))))

             (push-cdr! lookup (last entries))
             (push-cdr! lookup def)
             (remove-nth! nodes i))]

          ;; Match against (set-idx! X :default Y)
          [(and (list? node) (= (n node) 4)
                (= (symbol->var (car node)) (symbol->var `set-idx!))
                (.> methods (symbol->var (nth node 2)))
                (eq? (nth node 3) :default))
           (with (method (.> methods (symbol->var (nth node 2))))
             (push-cdr! method (nth node 3))
             (push-cdr! method (nth node 4)))
           (remove-nth! nodes i)]

          [else
           (inc! i)])))))

,(add-pass! fold-defgeneric)
